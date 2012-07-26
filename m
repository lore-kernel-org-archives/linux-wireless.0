Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ird.yahoo.com ([77.238.189.62]:28873 "HELO
	nm5.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752306Ab2GZMoK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2012 08:44:10 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net>
Message-ID: <1343306648.16107.YahooMailNeo@web28901.mail.ir2.yahoo.com> (sfid-20120726_144430_213003_9171B03E)
Date: Thu, 26 Jul 2012 13:44:08 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <501129D9.4060407@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your script and the working config file.

1/ here is my output of "cat /proc/sys/fs/file-max"
333653

2/ I have compared the working hostapd.conf file with mine here are the differences: (working file -> mine)
#bridge=br0 -> bridge=br0
ssid=home -> ssid=Sweet Home 2 (and wpa_passphrase changed)

then it gives me another error message when I launch hostapd:

xabix@HTPC:~$ sudo hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
nl80211: Interface wlan0 is in bridge br0
nl80211: Add own interface ifindex 3
nl80211: Add own interface ifindex 4
nl80211: New interface mon.wlan0 created: ifindex=8
nl80211: Add own interface ifindex 8
Could not set interface mon.wlan0 flags: Success
nl80211: Remove interface ifindex=8
nl80211: Failed to set interface wlan0 into AP mode
nl80211 driver initialization failed.
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=4 eloop_data=0x9a988f0 user_data=0x9a9a760 handler=0x807c5e0
ELOOP: remaining socket: sock=6 eloop_data=0x9a9c548 user_data=(nil) handler=0x8086770

syslog:
Jul 26 14:39:01 HTPC CRON[3689]: (root) CMD (  [ -x /usr/lib/php5/maxlifetime ] && [ -d /var/lib/php5 ] && find /var/lib/php5/ -depth -mindepth 1 -maxdepth 1 -type f -cmin +$(/usr/lib/php5/maxlifetime) ! -execdir fuser -s {} 2>/dev/null \; -delete)
Jul 26 14:40:13 HTPC NetworkManager[1266]:    SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0)
Jul 26 14:40:13 HTPC NetworkManager[1266]:    SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0): no ifupdown configuration found.
Jul 26 14:40:13 HTPC kernel: [ 6327.389619] rtl8192ce:_rtl92ce_llt_write():<0-0> Failed to polling write LLT done at address 0!
Jul 26 14:40:13 HTPC kernel: [ 6327.389629] rtl8192ce:rtl92ce_hw_init():<0-0> Init MAC failed
Jul 26 14:40:13 HTPC avahi-daemon[1258]: Withdrawing workstation service for mon.wlan0.
Jul 26 14:40:13 HTPC NetworkManager[1266]:    SCPlugin-Ifupdown: devices removed (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0)
Jul 26 14:41:46 HTPC kernel: [ 6420.634598] rtl8192ce:_rtl92ce_llt_write():<0-0> Failed to polling write LLT done at address 0!
Jul 26 14:41:46 HTPC kernel: [ 6420.634606] rtl8192ce:rtl92ce_hw_init():<0-0> Init MAC failed
Jul 26 14:41:46 HTPC NetworkManager[1266]:    SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0)
Jul 26 14:41:46 HTPC NetworkManager[1266]:    SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0): no ifupdown configuration found.
Jul 26 14:41:46 HTPC avahi-daemon[1258]: Withdrawing workstation service for mon.wlan0.
Jul 26 14:41:46 HTPC NetworkManager[1266]:    SCPlugin-Ifupdown: devices removed (path: /sys/devices/pci0000:00/0000:00:1c.3/0000:03:00.0/net/mon.wlan0, iface: mon.wlan0)

I will try your script and report.


Xabix
