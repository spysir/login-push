#!/bin/bash
# save as /etc/profile.d/telegram-login-push.sh 

exec &> /dev/null #Hide output

Gotify_URL='https://yourdoman.com'
Gotify_Token='ADa1asdfsfsd'

notify()
{

        now=$(date -d "-60 seconds" +%s) #Get current time minus 60 seconds
        end=$((SECONDS+30)) #Set 30s Timeout for loop

        while [ $SECONDS -lt $end ]; do

                SSHdate=$(date -d "$(who |grep pts|tail -1 | awk '{print $3, $4}')" +%s) #Check for the latest SSH session

                if [ $SSHdate -ge $now ]; then #Once who is updated continue with sending Notification

                        title="SSH Login for $(/bin/hostname -f)"
                        message="$(/usr/bin/who | grep pts)"

                        /usr/bin/curl -X POST -s \
                                -F "title=${title}" \
                                -F "message=${message}" \
                                -F "priority=5" \
                                "${Gotify_URL}/message?token=${Gotify_Token}"

                        break
                fi
        done

}

notify & #Run in background to prevent holding up the login process
