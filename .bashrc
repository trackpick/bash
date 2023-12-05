# Copyright (C) 2004 Patrick Verkaik

# Beep once
alias b='printf "\a"'

# Beep every minute. I use this to alert myself when a long running command terminates. Example:
#   $ make; B
# If your command is in the foreground and doesn't take input, you could also type ahead B after it has started running.
alias B='while :; do b; sleep 1; done'

# wj - wait job 
# Beep every minute and optionally send an email after a background job has finished (or otherwise changed status).
# You must first set the MAIL_SSH_ACCOUNT variable to a user@hostname where mailx can be run.
#
# Usage:
# $ make &
# $ wj [user@example.com]
wj()
{
  local mail="$1"
  local j1=`jobs | grep "^\["`
  echo waiting for $j1
  while sleep 1; do
    local j2=`jobs | grep "^\["`
    if [ "$j2" != "$j1" ]; then
      b
      if [ -n "$mail" ]; then
        echo -e "from:\n$j1\nto:\n$j2" | ssh $MAIL_SSH_ACCOUNT "mailx -s 'jobs changed on $HOSTNAME' $mail"
        unset mail
      fi;
    fi;
  done
}

