Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nyc-nss1.cypresscom.net ([64.190.13.53]:44946 "EHLO
	nyc-nss1.cypresscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0I3QCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 12:02:04 -0400
Subject: Re: Question about starting up an AP
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=windows-1252
From: Joshua Smith <JoshuaESmith@charter.net>
In-Reply-To: <C4D5DF09-82F0-48B4-9D64-6621B3C82932@kaon.com>
Date: Thu, 30 Sep 2010 11:52:29 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Message-Id: <71135D34-18F6-4909-A8AB-E7390FA73049@charter.net>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com> <201009272143.52283.helmut.schaa@googlemail.com> <EA2A527E-E8DA-4612-B8CB-518E2C6BA7D2@kaon.com> <201009272235.42545.helmut.schaa@googlemail.com> <C4D5DF09-82F0-48B4-9D64-6621B3C82932@kaon.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think I have a clue about the WPDMA TX/RX busy bug.  I was having trouble using the latest compat-wireless with USB dongle I have (ID AB50:2019 rt73usb), so I tried rolling Helmut's "oops" fix into:

compat-wireless-2010-07-15

which I have been using successfully for the last few months.  Lo and behold, this version does *NOT* exhibit the TX/RX busy error.  So whatever is causing that problem was introduced between 7/15/2010 and 9/20/2010.

This leaves me très happy, since with the "oops" fix, I can restart hostapd at will, and the card never crashes.  Woo hoo!

-Joshua

On Sep 29, 2010, at 2:21 PM, Joshua Smith wrote:

> OK, I have a working system now.  It's not pretty, but it's better than where I was.
> 
> - Using compat-wireless-2010-09-20, with the patch "rt2x00: Fix oops caused by error path in rt2x00lib_start"
>  Compiled with:
> CONFIG_RT2X00_DEBUG=y
> CONFIG_RT2X00_LIB_DEBUGFS=y
>  and all the other DEBUGFS also set to y
> 
> - Using a 2.6.27.8 kernel compiled with debug_fs support
> 
> When my system comes up, I try to start hostapd.  This may succeed, or it may fail because of the error:
> 
> phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
> phy0 -> rt2800pci_set_device_state: Error - Device failed to enter state 4 (-5).
> 
> If the error occurs, try starting hostapd one more time.  (This hardly ever works.)  If it fails again, reboot.
> 
> If we got past hostapd starting, then we need to see whether the card is deaf.  Do this by polling
> /sys/kernel/debug/ieee80211/phy0/rt2800pci/queue/queue
> for a while, to see if the RX queue counts ever get over zero.
> 
> If they do, we're good to go.
> 
> If not, kick the card this way:
> 
> echo 1 > /sys/kernel/debug/ieee80211/phy0/reset
> 
> Now check to see if that hit the WPDMA TX/RX busy error.  If it did, reboot.  If not, assume that restarting the card fixed the RX queue (it always seems to), and we're good to go.
> 
> For your amusement and horror, I've pasted in the bash script below.
> 
> At this point, if I could eliminate the WPDMA TX/RX busy error, I'd be able to eliminate all the reboots, and make a more sane system.  I'm still open to any and all suggestions on how to clear that condition!
> 
> -Joshua
> 
> …hideous bash script...
> 
>  ifconfig wlan0 down
> 
>  sleep 1
>  if ! hostapd -B /etc/hostapd.conf
>  then
>    echo "Problem starting Wi-Fi hardware.  Retrying..."
>    sleep 3
>    if ! hostapd -B /etc/hostapd.conf
>    then
>      echo -e "***\n*** Unable to initialize Wi-Fi hardware\n***\n***\n*** Restarting...\n***"
>      cleanreboot
>      sleep 60
>    fi
>  fi
>  sleep 1
> 
>  mount -t debugfs none /sys/kernel/debug/
>  if [ -e /sys/kernel/debug/ieee80211/phy0/rt2800pci/ ]
>  then
>    echo "Testing Wi-Fi hardware..."
>    RETRY=1
>    while [ $RETRY -lt 20 ]
>    do
>      if [ `cat /sys/kernel/debug/ieee80211/phy0/rt2800pci/queue/queue | egrep -c '^14.0.24.24.0.0.0$'` -eq 0 ]
>      then
>        break
>      fi
>      echo -n '.'
>      sleep 1
>      RETRY=$((RETRY+1))
>    done
>    if [ $RETRY -eq 20 ]
>    then
>      echo "failed.  Resetting..."
>      echo 1 > /sys/kernel/debug/ieee80211/phy0/reset
>      sleep 1
>      if [ `dmesg | tail -n 30 | grep -c "rt2800_wait_wpdma_ready"` -gt 0 ]
>      then
>        echo -e "***\n*** Unable to reset Wi-Fi hardware\n***\n***\n*** Restarting...\n***"
>        cleanreboot
>        sleep 60
>      fi
>    else
>     echo "Passed!"
>    fi
>  fi
> 

