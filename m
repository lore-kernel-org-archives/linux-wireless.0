Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39471 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab0HMWeq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Aug 2010 18:34:46 -0400
Received: by vws3 with SMTP id 3so1616412vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 13 Aug 2010 15:34:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 14 Aug 2010 00:34:45 +0200
Message-ID: <AANLkTi=O6aXPVwdAmDTO3cr1dXA84_PfwqRu-8X=R-Xe@mail.gmail.com>
Subject: Sitecom WL-172 drops ~50% packets (rt2573)
From: Henk Poley <henkpoley@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running Ubuntu 10.04 with bleeding edge compat-wireless. Pinging
often doesn't even resolve DNS, if it does  and I let it run for a
while it reports around 50% packets dropped. The Airport Extreme
basestation stats shows a stable ca. -70dBm connection. The local
wireless network performance is excellent with other network devices.
For example I stream MPEG2-TS video just fine with another 802.11g
machine. Also tested the USB dongle on a Windows 7 machine, and it
worked after installing the appropriate driver.

What are the next steps to debug this problem?

dmesg with irrelevant lines removed:

[   15.092812] cfg80211: World regulatory domain updated:
[   15.092819]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   15.092823]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.092827]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.092831]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   15.092834]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   15.092838]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.282712] phy0: Selected rate control algorithm 'minstrel'
[   16.283937] Registered led device: rt73usb-phy0::radio
[   16.283983] Registered led device: rt73usb-phy0::assoc
[   16.285573] Registered led device: rt73usb-phy0::quality
[   16.286528] usbcore: registered new interface driver rt73usb
[   16.370910] type=1505 audit(1281736368.123:5):
operation="profile_replace" pid=630 name="/sbin/dhclient3"
[   16.371640] type=1505 audit(1281736368.123:6):
operation="profile_replace" pid=630
name="/usr/lib/NetworkManager/nm-dhcp-client.action"
[   16.372403] type=1505 audit(1281736368.127:7):
operation="profile_replace" pid=630
name="/usr/lib/connman/scripts/dhclient-script"
[   16.470082] type=1505 audit(1281736368.223:8):
operation="profile_load" pid=631 name="/usr/bin/evince"
[   16.479936] type=1505 audit(1281736368.231:9):
operation="profile_load" pid=631 name="/usr/bin/evince-previewer"
[   16.486174] type=1505 audit(1281736368.239:10):
operation="profile_load" pid=631 name="/usr/bin/evince-thumbnailer"
[   16.562356] type=1505 audit(1281736368.315:11):
operation="profile_load" pid=635 name="/usr/sbin/tcpdump"
[   17.159682] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   24.951478] wlan0: deauthenticating from 00:19:e3:32:71:f6 by local
choice (reason=3)
[   24.953549] wlan0: authenticate with 00:19:e3:32:71:f6 (try 1)
[   24.960957] wlan0: authenticated
[   24.962030] wlan0: associate with 00:19:e3:32:71:f6 (try 1)
[   24.965056] wlan0: RX AssocResp from 00:19:e3:32:71:f6 (capab=0x31
status=0 aid=1)
[   24.965064] wlan0: associated
[   24.984546] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   24.984714] cfg80211: Calling CRDA for country: NL
