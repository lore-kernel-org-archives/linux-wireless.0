Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48520 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab0I2SVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:21:19 -0400
Received: by qwh6 with SMTP id 6so668467qwh.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 11:21:18 -0700 (PDT)
Subject: Re: Question about starting up an AP
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=windows-1252
From: Joshua Smith <jesmith@kaon.com>
In-Reply-To: <201009272235.42545.helmut.schaa@googlemail.com>
Date: Wed, 29 Sep 2010 14:21:14 -0400
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Message-Id: <C4D5DF09-82F0-48B4-9D64-6621B3C82932@kaon.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009272143.52283.helmut.schaa@googlemail.com> <EA2A527E-E8DA-4612-B8CB-518E2C6BA7D2@kaon.com> <201009272235.42545.helmut.schaa@googlemail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I have a working system now.  It's not pretty, but it's better than where I was.

- Using compat-wireless-2010-09-20, with the patch "rt2x00: Fix oops caused by error path in rt2x00lib_start"
  Compiled with:
CONFIG_RT2X00_DEBUG=y
CONFIG_RT2X00_LIB_DEBUGFS=y
  and all the other DEBUGFS also set to y

- Using a 2.6.27.8 kernel compiled with debug_fs support

When my system comes up, I try to start hostapd.  This may succeed, or it may fail because of the error:

phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
phy0 -> rt2800pci_set_device_state: Error - Device failed to enter state 4 (-5).

If the error occurs, try starting hostapd one more time.  (This hardly ever works.)  If it fails again, reboot.

If we got past hostapd starting, then we need to see whether the card is deaf.  Do this by polling
/sys/kernel/debug/ieee80211/phy0/rt2800pci/queue/queue
for a while, to see if the RX queue counts ever get over zero.

If they do, we're good to go.

If not, kick the card this way:

echo 1 > /sys/kernel/debug/ieee80211/phy0/reset

Now check to see if that hit the WPDMA TX/RX busy error.  If it did, reboot.  If not, assume that restarting the card fixed the RX queue (it always seems to), and we're good to go.

For your amusement and horror, I've pasted in the bash script below.

At this point, if I could eliminate the WPDMA TX/RX busy error, I'd be able to eliminate all the reboots, and make a more sane system.  I'm still open to any and all suggestions on how to clear that condition!

-Joshua

…hideous bash script...

  ifconfig wlan0 down

  sleep 1
  if ! hostapd -B /etc/hostapd.conf
  then
    echo "Problem starting Wi-Fi hardware.  Retrying..."
    sleep 3
    if ! hostapd -B /etc/hostapd.conf
    then
      echo -e "***\n*** Unable to initialize Wi-Fi hardware\n***\n***\n*** Restarting...\n***"
      cleanreboot
      sleep 60
    fi
  fi
  sleep 1

  mount -t debugfs none /sys/kernel/debug/
  if [ -e /sys/kernel/debug/ieee80211/phy0/rt2800pci/ ]
  then
    echo "Testing Wi-Fi hardware..."
    RETRY=1
    while [ $RETRY -lt 20 ]
    do
      if [ `cat /sys/kernel/debug/ieee80211/phy0/rt2800pci/queue/queue | egrep -c '^14.0.24.24.0.0.0$'` -eq 0 ]
      then
        break
      fi
      echo -n '.'
      sleep 1
      RETRY=$((RETRY+1))
    done
    if [ $RETRY -eq 20 ]
    then
      echo "failed.  Resetting..."
      echo 1 > /sys/kernel/debug/ieee80211/phy0/reset
      sleep 1
      if [ `dmesg | tail -n 30 | grep -c "rt2800_wait_wpdma_ready"` -gt 0 ]
      then
        echo -e "***\n*** Unable to reset Wi-Fi hardware\n***\n***\n*** Restarting...\n***"
        cleanreboot
        sleep 60
      fi
    else
     echo "Passed!"
    fi
  fi

