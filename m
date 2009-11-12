Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:44589 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117AbZKLT3X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:29:23 -0500
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 14:29:27 -0500
From: <pat-lkml@erley.org>
To: <linux-wireless@vger.kernel.org>, <mcgrof@gmail.com>
Subject: ATH9K AP+MP Simultaneous Success
Message-ID: <3e6a3a7fd3826c7999b03d078a497c2d@127.0.0.1>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an ath9k pci card [1] in a router/AP system that's been doing great
as just an AP and wired router for many months now.  Today, I decided to
see if Mesh Point was still working in Compat Wireless.  After bringing 
down the AP (I thought, never hit enter), I did:

# iw phy phy0 interface add mp0 type mp mesh_id FooBarMesh
# macchanger -e mp0
# ifconfig mp0 10.0.2.1/24 up

Then in my laptop (has a mini-pci ath9k card [2]) I did:

# iw phy phy0 interface add mp0 type mp mesh_id FooBarMesh
# macchanger -e mp0
# ifconfig mp0 10.0.2.2/24 up
# ping -f -I mp0 10.0.2.1

which took a few seconds to start getting responses, worked well, but had
some packet loss [3] which I decided to inspect.  I went back to the
router
system and did an 'ifconfig' only to see I still had the access point 
interface up (and my ps3 associated to it, and working) [4].

Just wanted to report this success.  Any further multiple vif tests that 
are of interest to people?  

Pat Erley

[1] Belkin PCI N1 Wireless Desktop Card 
[Atheros AR5416 MAC/BB Rev:2 AR2133 RF Rev:81] 

[2] COMPEX IWAVEPORT WLM200NX
[Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0]

[3]  Ping Output

# ping 10.0.2.1 -I mp0 -f
PING 10.0.2.1 (10.0.2.1) from 10.0.2.2 mp0: 56(84) bytes of data.
.........................<snip>......................^C
--- 10.0.2.1 ping statistics ---
1048 packets transmitted, 822 received, 21% packet loss, time 5232ms
rtt min/avg/max/mdev = 0.911/2.279/12.451/1.432 ms, pipe 2, ipg/ewma
4.997/2.753 ms


[4] abridged Ifconfig output

mon.wlan0 Link encap:UNSPEC  HWaddr
00-11-50-F6-C1-F0-00-00-00-00-00-00-00-00-00-00
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6222 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:859328 (839.1 KiB)  TX bytes:0 (0.0 B)

mp0       Link encap:Ethernet  HWaddr 00:11:50:fc:3a:18
          inet addr:10.0.2.1  Bcast:10.0.2.255  Mask:255.255.255.0
          inet6 addr: fe80::211:50ff:fefc:3a18/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:6146 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8061 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:575052 (561.5 KiB)  TX bytes:1005758 (982.1 KiB)

wlan0     Link encap:Ethernet  HWaddr 00:11:50:f6:c1:f0
          inet addr:10.0.1.200  Bcast:10.0.1.255  Mask:255.255.255.0
          inet6 addr: fe80::211:50ff:fef6:c1f0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:104 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:0 (782.3 KiB)  TX bytes:43650 (42.6 KiB)
