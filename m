Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:51607 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab3KNJXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 04:23:14 -0500
Message-ID: <52849677.3090609@einfach.org> (sfid-20131114_102319_095575_FD1E6537)
Date: Thu, 14 Nov 2013 09:23:03 +0000
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Sujith Manoharan <sujith@msujith.org>, nbd@openwrt.org,
	Ingo Randolf <ingo.randolf@qupik.com>, mcgrof@do-not-panic.com
Subject: ath9k AR9382 high latency ping
References: <52492FB0.3010201@einfach.org>	<5249443E.3080700@rempel-privat.de>	<524954BE.8060603@einfach.org>	<52497C2E.1060406@rempel-privat.de>	<5249A2F7.5090908@einfach.org>	<524DA3DC.6060806@einfach.org> <21087.18050.72635.617321@gargle.gargle.HOWL>
In-Reply-To: <21087.18050.72635.617321@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello All!

Here is another ath9k PCIe card I have problems with in a Intel Atom
N2600 embedded board (Advantech MIO-2261N). This is the same board I was
reporting problems with the AR9287 before. I exchanged the card for an
AR9382 and at least I can associate now.

It's a AR9382 (Unex DNXA-116) and the PCI ID 168c:0030 subsystem
168c:3116, reported as "AR9300 Rev:3"...

The symptom are ping times of around 1000ms, when connected to an AP
(very close, I expect around 2ms), eg.

64 bytes from 192.168.5.1: icmp_seq=1 ttl=64 time=1237 ms
64 bytes from 192.168.5.1: icmp_seq=2 ttl=64 time=1403 ms
64 bytes from 192.168.5.1: icmp_seq=3 ttl=64 time=1567 ms
64 bytes from 192.168.5.1: icmp_seq=4 ttl=64 time=1728 ms

The same card works fine in another Laptop, BTW, so it must be a problem
specific to this board.

I run wireless-testing from yesterday and I tried with different
combinations of enabling/disabling ASPM in the BIOS and booting with
pcie_aspm=off pcie_aspm=force all of which has the same result...

Below is some suspicious output of debug=0x8f49, I can send the full log
if you are interested. Please let me know if you have any idea what else
I can try...

[   45.583338] ath: phy0: unsupported hw bitrate detected 0x1b using 1 Mbit
[   91.109005] ath: phy1: NF did not complete in calibration window
...
[   91.304711] ath: phy1: MAC Hang signature not found at DCU complete
...
[   96.877586] ath: phy1: tx hung, resetting the chip
...
[  101.595052] ath: phy1: MAC Hang signature not found at DCU complete
[  101.595100] ath: phy1: Possible baseband hang, busy=11 (try 1)
[  101.894912] ath: phy1: MAC Hang signature not found at DCU complete
[  101.894960] ath: phy1: Possible baseband hang, busy=4 (try 1)
[  102.194815] ath: phy1: MAC Hang signature not found at DCU complete
[  102.194862] ath: phy1: Possible baseband hang, busy=4 (try 1)
...
[  104.316427] ath: phy1: MAC Hang signature not found at DCU complete
[  104.316455] ath: phy1: Possible baseband hang, busy=0 (try 1)
[  104.316468] ath: phy1: tx hung, resetting the chip

Thanks,
bruno

