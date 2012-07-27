Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.ird.yahoo.com ([77.238.189.215]:32001 "HELO
	nm18-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752275Ab2G0OMi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 10:12:38 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com>
Message-ID: <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> (sfid-20120727_161250_019548_605603B1)
Date: Fri, 27 Jul 2012 15:12:36 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>So I have download the file from your link which provides a directory called: "compat-wireless-2012-05-10". I was using one called "compat-wireless-2012-07-03".
>
>FYI I already compiled the 3.5 kernel but as you recommend I keep using the 3.4.6 for now as it will not necessary bring something new around the rtl8188ce wifi driver.
>
>FYI there should be something wrong in the README as if I do:
>root@HTPC:/home/xabix/tmp/compat-wireless-2012-05-10# ./scripts/driver-select rtl8192ce
>Processing new driver-select request...
>Backing up makefile: Makefile.bk
>Unsupported driver
>
>I ve got the Unsupported driver message
>
>Anyway I am compilling them all based on the link you suggested: compat-wireless-2012-05-10
>
>Will report when done
>
>merci
>


Hi Larry,

So after rebooting (and installing the compat drivers from 05-10) it seems to work meaning that the process runs:

5 S root      1486     1  0  80   0 -  1415 poll_s 16:03 ?        00:00:00 /usr/sbin/hostapd -B -P /var/run/hostapd.pid -dd /etc/hostapd/hostapd.conf


Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authentication OK (open system)
Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authenticated
Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
Jul 27 16:06:15 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)
Jul 27 16:06:18 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: deauthenticated due to local deauth request
Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authentication OK (open system)
Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authenticated
Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
Jul 27 16:06:22 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)
Jul 27 16:06:25 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: deauthenticated due to local deauth request
Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authentication OK (open system)
Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authenticated
Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
Jul 27 16:06:29 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)

but I launch manually it doesn't work anymore

xabix@HTPC:~$ sudo service hostapd stop
[sudo] password for xabix: 
 * Stopping advanced IEEE 802.11 management hostapd
   ...done.
xabix@HTPC:~$ /usr/sbin/hostapd -B -P /var/run/hostapd.pid -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
nl80211: Register Action command failed: ret=-1 (Operation not permitted)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 3
nl80211: Add own interface ifindex 4
nl80211: Failed to set interface 4 to mode 3: -1 (Operation not permitted)
nl80211: Failed to set interface 4 to mode 3: -1 (Operation not permitted)
Could not set interface wlan0 flags: Permission denied
nl80211: Interface mode change to 3 from 0 failed
nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=4 eloop_data=0x9cdc910 user_data=0x9cde780 handler=0x807c


so the only to launch it for now is to reboot :)

I dit put this on the conf file
# Levels (minimum value for logged events):
#  0 = verbose debugging
#  1 = debugging
#  2 = informational messages
#  3 = notification
#  4 = warning
logger_syslog=1
logger_syslog_level=0


but I don't see enough logs to know why after the association there is a deauthentication.

Cheers
almost there :D

