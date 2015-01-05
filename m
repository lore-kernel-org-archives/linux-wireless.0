Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:42615 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbbAEJZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 04:25:24 -0500
Received: from edge01.upcmail.net ([192.168.13.236])
          by viefep16-int.chello.at
          (InterMail vM.8.01.05.13 201-2260-151-135-20130320) with ESMTP
          id <20150105090704.LCKS26000.viefep16-int.chello.at@edge01.upcmail.net>
          for <linux-wireless@vger.kernel.org>;
          Mon, 5 Jan 2015 10:07:04 +0100
Received: from [194.124.158.2] (jupiter.think.ch [194.124.158.2])
	(authenticated bits=0)
	by luna.think.ch (8.14.3/8.14.3) with ESMTP id t05972mx006135
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Mon, 5 Jan 2015 10:07:03 +0100
Message-ID: <54AA5438.9070902@think.ch> (sfid-20150105_102529_675996_57CD7390)
Date: Mon, 05 Jan 2015 10:07:04 +0100
From: Erich Titl <erich.titl@think.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: b43 driver and WEP
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I am working on a WLAN client on an embedded system and I am facing a
problem using WEP. I am using the b43 driver with a BCM43222 mini-pci
card and kernel 3.10.55.

The card works fine with WPA and without encryption. Using WEP results
in a weird situation where dhcp requests can be sent across the wireless
link, but a dhcp reply is never received.

The only error I could come up with is

AP# ip link set wlan0 up
AP# iw event -f &
AP# iw wlan0 connect scoobly keys 0:abcdefghijklm
wlan0 (phy #0): scan started
AP# wlan0 (phy #0): scan finished: 2412 2417 2422 2427 2432 2437 2442
2447 2452 2457 2462 2467 2472 2484, "scoobly"
wlan0: new station f8:1a:67:56:42:96

[  417.886167] b43 ssb0:0 wlan0: failed to set key 0

wlan0 (phy #0): auth f8:1a:67:56:42:96 -> 00:1a:2b:5f:61:11 status: 0:
Successful [frame: b0 00 40 01 00 1a 2b 5f 61 11 f8 1a 67 56 42 96 f8 1a
67 56 42 96 00 00 00 00 02 00 00 00]
wlan0 (phy #0): assoc f8:1a:67:56:42:96 -> 00:1a:2b:5f:61:11 status: 0:
Successful [frame: 10 00 40 01 00 1a 2b 5f 61 11 f8 1a 67 56 42 96 f8 1a
67 56 42 96 10 00 31 04 00 00 01 c0 01 08 82 84 8b 0c 12 96 18 24 32 04
30 48 60 6c dd 18 00 50 f2 02 01 01 85 00 03 a4 00 00 27 a4 00 00 42 43
5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01
00 06 00 40 00]
wlan0 (phy #0): connected to f8:1a:67:56:42:96

AP# tcpdump -i wlan0 -s 1500 -w /tmp/foo &
AP# tcpdump: WARNING: wlan0: no IPv4 address assigned
tcpdump: listening on wlan0, link-type EN10MB (Ethernet), capture size
1500 bytes

AP# dhcpcd wlan0
dhcpcd[4335]: version 5.2.11 starting
dhcpcd[4335]: wlan0: broadcasting for a lease
dhcpcd[4335]: timed out

AP# tcpdump -r /tmp/foo
reading from file /tmp/foo, link-type EN10MB (Ethernet)
08:49:56.270834 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
08:50:00.395859 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
08:50:07.559542 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314
08:50:22.958262 IP 0.0.0.0.bootpc > 255.255.255.255.bootps: BOOTP/DHCP,
Request from 00:1a:2b:5f:61:11 (oui Unknown), length 314

AP# iw dev wlan0 link
Connected to f8:1a:67:56:42:96 (on wlan0)
        SSID: scoobly
        freq: 2427
        RX: 537892 bytes (7445 packets)
        TX: 3639 bytes (21 packets)
        signal: -76 dBm
        tx bitrate: 1.0 MBit/s

        bss flags:      short-preamble short-slot-time
        dtim period:    0
        beacon int:     100

The dhcp request is received at the dhcp server and is being answered to.

Any ideas?

Thanks

Erich Titl






