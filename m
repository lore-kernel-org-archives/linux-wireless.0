Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:55108 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116AbXGZKzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 06:55:33 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 25E8C8CAD8
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 12:55:29 +0200 (CEST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id E00CC10444
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 10:57:14 +0000 (UTC)
Message-ID: <46A87DA3.7040500@warmcat.com>
Date: Thu, 26 Jul 2007 11:55:31 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Incomplete Monitor mode with > 1 interface
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

iwl3945 is associated on the wlan0 interface, and a second interface
mon0 is created and put into monitor mode like this

echo -n mon0 >/sys/class/ieee80211/phy0/add_iface
iwconfig mon0 mode monitor
ifconfig mon0 up
iwconfig mon0 channel 6

tcpdump reports things going on

# tcpdump -i mon0
tcpdump: WARNING: mon0: no IPv4 address assigned
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on mon0, link-type IEEE802_11_RADIO (802.11 plus BSD radio
information header), capture size 96 bytes
11:46:04.512476 5.5 Mb/s 2437 MHz (0x0480) 220dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
11:46:04.614885 5.5 Mb/s 2437 MHz (0x0480) 220dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
11:46:04.717285 5.5 Mb/s 2437 MHz (0x0480) 220dB signal Beacon (froh)
[1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
...

Setting IFF_PROMISC on wlan0 or mon0 did not help.

If I remove the iwl3945 module, kill wpa_supplicant and dhclient. and
reinsert it, and set the only interface wlan0 to monitor mode, I see a
more genuine view of what is out there.

# tcpdump -i wlan0
tcpdump: WARNING: wlan0: no IPv4 address assigned
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type IEEE802_11_RADIO (802.11 plus BSD radio
information header), capture size 96 bytes
11:50:18.364596 587219133us tsft 1.0 Mb/s 6 MHz (0x00a0) 0dB signal 0dB
noise antenna 2 Beacon (froh) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
11:50:18.378049 587205672us tsft short preamble 5.5 Mb/s 6 MHz (0x00a0)
0dB signal 0dB noise antenna 2 13:22:33:44:55:66 (oui Unknown) Unknown
SSAP 0x60 > 13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50
Unnumbered, ua, Flags [Response], length 77
11:50:18.466993 603996348us tsft 1.0 Mb/s 6 MHz (0x00a0) 0dB signal 0dB
noise antenna 2 Beacon (froh) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
11:50:18.476051 603987283us tsft short preamble 2.0 Mb/s 6 MHz (0x00a0)
0dB signal 0dB noise antenna 2 13:22:33:44:55:66 (oui Unknown) Unknown
SSAP 0x60 > 13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50
Unnumbered, ua, Flags [Response], length 77
11:50:18.569394 620773564us tsft 1.0 Mb/s 6 MHz (0x00a0) 0dB signal 0dB
noise antenna 2 Beacon (froh) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
11:50:18.576754 620766193us tsft 1.0 Mb/s 6 MHz (0x00a0) 0dB signal 0dB
noise antenna 2 13:22:33:44:55:66 (oui Unknown) Unknown SSAP 0x60 >
13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50 Unnumbered, ua, Flags
[Response], length 77
11:50:18.671802 637550779us tsft 1.0 Mb/s 6 MHz (0x00a0) 0dB signal 0dB
noise antenna 2 Beacon (froh) [1.0* 2.0* 5.5* 11.0* Mbit] ESS CH: 6, PRIVACY
11:50:18.675912 637546653us tsft 54.0 Mb/s 6 MHz (0x00c0) 0dB signal 0dB
noise antenna 2 13:22:33:44:55:66 (oui Unknown) Unknown SSAP 0x60 >
13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50 Unnumbered, ua, Flags
[Response], length 77

This is the same situation as with zd1211rw after Ulrich's fix... if you
are the only virtual interface, monitor mode works properly... it would
really be beneficial if monitor mode acted consistently regardless of
the number of virtual interfaces.

-Andy
