Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:49746 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab0CBQHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 11:07:11 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15
Received: from ironport-out-1.rz.rwth-aachen.de ([134.130.5.40])
 by mta-2.ms.rz.RWTH-Aachen.de
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008))
 with ESMTP id <0KYN00HDRWRXZPA0@mta-2.ms.rz.RWTH-Aachen.de> for
 linux-wireless@vger.kernel.org; Tue, 02 Mar 2010 17:07:09 +0100 (CET)
Message-id: <4B8D37AC.4010000@nets.rwth-aachen.de>
Date: Tue, 02 Mar 2010 17:07:08 +0100
From: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
To: ath5k-devel@lists.ath5k.org
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath5k IBSS mode high latency
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently experimenting with ath5k of kernel 2.6.33 in our
mesh network. We, were previously using madwifi in "ahdemo" mode,
which worked reasonably well.

Now, after working around various pitfalls (e.g. BSSID merging,
still does not work reliable for us!,)

It somehow "works", but I'm occasionally seeing huge latency issues:
with ping times in the order of 30-50 seconds over a 2-3 hop path.

(e.g.:)

64 bytes from 169.254.9.47: icmp_seq=1812 ttl=62 time=34703 ms
64 bytes from 169.254.9.47: icmp_seq=1813 ttl=62 time=33782 ms
64 bytes from 169.254.9.47: icmp_seq=1814 ttl=62 time=32803 ms
64 bytes from 169.254.9.47: icmp_seq=1815 ttl=62 time=31804 ms
64 bytes from 169.254.9.47: icmp_seq=1816 ttl=62 time=30810 ms
64 bytes from 169.254.9.47: icmp_seq=1817 ttl=62 time=29814 ms
64 bytes from 169.254.9.47: icmp_seq=1818 ttl=62 time=28815 ms


I noticed that some qdisc queues fill up to pretty high values.

e.g.:
hannemann@mrouter9:~ $ tc -s qdisc
[...]
qdisc pfifo_fast 0: dev ath0 root refcnt 2 bands 3 priomap  1 2 2 2 1 2 0 0 1 1 1 1 1 1 1 1
 Sent 255864 bytes 3034 pkt (dropped 0, overlimits 0 requeues 186)
 backlog 22416b 265p requeues 186

At the same time there is no reasonable traffic that justifies this high backlog.
I'm not yet sure, but it may be related to this message in dmesg:

[ 3681.006797] ath5k phy0: no further txbuf available, dropping packet

When the queue "gets stuck" no communication with this particular node is possible.
If I perform a ping on that node to another node, I can watch the backlog to increase
packet by packet[1]. Usually, at some time the queue gets suddenly "flushed"
and communication is restored. However, right now I have a node where this situation
persists for several minutes now...

Any idea how to debug this problem further?
Anyone using ath5k successfully in IBSS mode, for more than a bunch of nodes?


[1] note that I'm using static arp entries...


FYI:
[   27.141256] ath5k 0000:00:0c.0: registered as 'phy0'
[   27.623005] ath: EEPROM regdomain: 0x0
[   27.623023] ath: EEPROM indicates default country code should be used
[   27.623043] ath: doing EEPROM country->regdmn map search
[   27.623066] ath: country maps to regdmn code: 0x3a
[   27.623084] ath: Country alpha2 being used: US
[   27.623099] ath: Regpair used: 0x3a
[   27.777749] ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
[   27.777749] ath5k phy0: RF5112B multiband radio found (0x36)

00:0c.0 Ethernet controller: Atheros Communications Inc. AR5212/AR5213 Multiprotocol MAC/baseband processor (rev 01)
	Subsystem: Wistron NeWeb Corp. CM9 Wireless a/b/g MiniPCI Adapter
	Flags: bus master, medium devsel, latency 168, IRQ 9
	Memory at e0040000 (32-bit, non-prefetchable) [size=64K]
	Capabilities: [44] Power Management version 2


Best regards.
Arnd
