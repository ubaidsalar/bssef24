<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsive Class Schedule</title>
    <style>
        body {
    font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
    background-color: #f4f4f4;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 20px;
    margin: 0;
}

section {
    width: 100%;
    max-width: 1200px;
    margin: 20px 0;
    padding: 20px;
    background-color: white;
    border-radius: 8px;
    box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
    display: flex;
    flex-direction: column;
    align-items: center;
}

h1 {
    text-align: center;
    margin-bottom: 20px;
    font-size: 2rem;
}

table {
    width: 100%;
    border-collapse: collapse;
    min-width: 600px;
}

table, th, td {
    border: 1px solid #ddd;
}

th, td {
    padding: 10px;
    text-align: center;
    position: relative;
}

th {
    background-color: #007BFF;
    color: white;
}

/* Tooltip styling */
td:hover::after {
    content: attr(data-info); /* Custom attribute to hold extra info */
    position: absolute;
    bottom: 120%; /* Position above the cell */
    left: 50%;
    transform: translateX(-50%);
    background-color: rgba(0, 0, 0, 0.7);
    color: white;
    padding: 5px;
    border-radius: 5px;
    white-space: nowrap;
    font-size: 0.8rem;
    z-index: 1;
}

/* Responsive adjustments */
@media screen and (max-width: 768px) {
    th, td {
        padding: 8px;
        font-size: 0.9rem;
    }

    table {
        min-width: 100%;
    }

    h1 {
        font-size: 1.8rem;
    }
}

@media screen and (max-width: 480px) {
    th, td {
        padding: 6px;
        font-size: 0.8rem;
    }

    table {
        min-width: 100%;
    }

    h1 {
        font-size: 1.5rem;
    }

    section {
        padding: 15px;
    }
}

    </style>
</head>
<body>

<!-- Upper Section for Today's Schedule -->
<section id="status-section">
    <h1>Today's Schedule</h1>
    <div id="class-status"></div>
</section>

<!-- Lower Section for Weekly Timetable -->
<section id="schedule-section">
    <h1>Weekly Timetable</h1>
    <table id="timetable">
        <thead>
            <tr>
                <th>Time</th>
                <th>Monday</th>
                <th>Tuesday</th>
                <th>Wednesday</th>
                <th>Thursday</th>
                <th>Friday</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>8:30 - 9:50</td>
                <td class="class-cell">Calculus</td>
                <td class="class-cell">DS</td>
                <td class="class-cell">FE</td>
                <td class="class-cell">ICT</td>
                <td class="class-cell">Calculus</td>
            </tr>
            <tr>
                <td>10:00 - 11:20</td>
                <td class="class-cell">ICP</td>
                <td class="class-cell">PF</td>
                <td class="class-cell">DS</td>
                <td class="class-cell">Free</td>
                <td class="class-cell">ICT</td>
            </tr>
            <tr>
                <td>11:30 - 12:50</td>
                <td class="class-cell">Calculus</td>
                <td class="class-cell">ICP</td>
                <td>Free</td>
                <td class="class-cell">DS</td>
                <td class="class-cell">FE</td>
            </tr>
            <tr>
                <td>12:50 - 1:30</td>
                <td colspan="5">Break</td>
            </tr>
            <tr>
                <td>1:30 - 2:50</td>
                <td class="class-cell">DS</td>
                <td class="class-cell">FE</td>
                <td class="class-cell">ICP</td>
                <td class="class-cell">PF</td>
                <td class="class-cell">ICT</td>
            </tr>
            <tr>
                <td>3:00 - 4:20</td>
                <td class="class-cell">ICT</td>
                <td class="class-cell">Calculus</td>
                <td class="class-cell">ICP</td>
                <td class="class-cell">FE</td>
                <td class="class-cell">FE</td>
            </tr>
        </tbody>
    </table>
</section>

<script>
    // Class information to avoid repetition
const classDetails = {
    PF: { teacher: "Mr. Shakeel", room: "R10" },
    DS: { teacher: "Mr. Ali", room: "R20" },
    FE: { teacher: "Ms. Sara", room: "R30" },
    ICT: { teacher: "Mr. Ahmed", room: "R25" },
    Calculus: { teacher: "Ms. Fatima", room: "R40" },
    ICP: { teacher: "Mr. Ahmed", room: "R50" }
};

const timetable = [
    ["08:30", "09:50", "Calculus", "DS", "FE", "ICT", "Calculus"],
    ["10:00", "11:20", "ICP", "PF", "DS", "Free", "ICT"],
    ["11:30", "12:50", "Calculus", "ICP", "Free", "DS", "FE"],
    ["12:50", "13:30", "Break", "Break", "Break", "Break", "Break"],
    ["13:30", "14:50", "DS", "FE", "ICP", "PF", "ICT"],
    ["15:00", "16:20", "ICT", "Calculus", "ICP", "FE", "FE"]
];

function timeToMinutes(time) {
    const [hours, minutes] = time.split(':').map(Number);
    return hours * 60 + minutes;
}

function getClassDetails(className) {
    if (classDetails[className]) {
        return `Teacher: ${classDetails[className].teacher}, Room: ${classDetails[className].room}`;
    }
    return "";
}

function getCurrentStatus() {
    const now = new Date(); // Get the current date and time
    const nowMinutes = now.getHours() * 60 + now.getMinutes();
    const currentDay = now.getDay(); // Get the current day (0 is Sunday, 1 is Monday, etc.)
    let statusDiv = document.getElementById('class-status');

    // Check for weekends
    if (currentDay === 0 || currentDay === 6) {
        statusDiv.innerHTML = "No classes today. Enjoy your weekend!";
        return; // Exit function early if it's the weekend
    }

    let classFound = false;

    // Loop through the timetable for the current day
    for (let i = 0; i < timetable.length; i++) {
        const [start, end, ...classes] = timetable[i];
        const startMinutes = timeToMinutes(start);
        const endMinutes = timeToMinutes(end);
        const className = classes[currentDay - 1]; // Get the class for today

        if (className === "Free" || className === "Break") continue;

        // If a class is in progress
        if (nowMinutes >= startMinutes && nowMinutes < endMinutes) {
            const timeRemaining = endMinutes - nowMinutes;
            const classInfo = getClassDetails(className);
            statusDiv.innerHTML = `Class in progress: <strong>${className}</strong>. ${classInfo}. Time left: ${timeRemaining} minutes.`;
            classFound = true;
            break;
        } else if (nowMinutes < startMinutes) {
            // Next class countdown
            const timeUntilNextClass = startMinutes - nowMinutes;
            const classInfo = getClassDetails(className);
            statusDiv.innerHTML = `Next class: <strong>${className}</strong> (${classInfo}) in ${timeUntilNextClass} minutes.`;
            classFound = true;
            break;
        }
    }

    if (!classFound) {
        statusDiv.innerHTML = "No more classes today. See you tomorrow!";
    }
}

// Function to set data-info attributes for tooltip
function setTooltipData() {
    const cells = document.querySelectorAll('.class-cell');
    cells.forEach(cell => {
        const className = cell.textContent.trim();
        cell.setAttribute('data-info', getClassDetails(className));
    });
}

// Initialize
getCurrentStatus();
setTooltipData();

</script>
</body>
</html>
