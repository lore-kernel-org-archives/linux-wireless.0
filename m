Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:34482 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZHSU1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 16:27:11 -0400
Received: from [172.16.24.149] (ndn243.bob.fi [81.209.19.243])
	by mbox2.netikka.net (Postfix) with ESMTP id 1C6F4408135
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 23:27:09 +0300 (EEST)
Message-ID: <4A8C601D.9040608@mandriva.org>
Date: Wed, 19 Aug 2009 23:27:09 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k broken in 2.6.31-rc6
Content-Type: multipart/mixed;
 boundary="------------040605030103010809060106"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040605030103010809060106
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
(please cc me on replies)

I'm tracking a bug in ath9k in 2.6.31-rc6, and have been cherrypicking 
patches from wireless-testing to try to get a stable ath9k...

The problem is that if the user configures the interface it works, but 
have a weak signal and tends to drop the connection.

If he reboots, the signal is even weaker, and also drops the connection
faster. He has to reconfigure the interface to get it back up.

So here is what I have applied:

net-wireless-ath9k-Fix-bug-in-PCI-resume.patch
net-wireless-ath9k-Set-HW-state-properly.patch
net-wireless-ath9k-Manipulate-and-report-the-correct-RSSI.patch
net-wireless-ath9k-Update-beacon-RSSI.patch
net-wireless-ath9k-RX-stucks-during-heavy-traffic-in-HT40-mode.patch


Now with theese patches the signal strength is correct, and the 
connection survives the reboot, but does disconnect when transfer
load increases.
The good part of the above patches is that only a simple network restart
is needed to get the connection back...

The fix for the connection dropping is to apply the patch:
net-wireless-ath9k-Fix-TX-hang-issue-with-Atheros-chipsets.patch

with this patch applied the link is stable, and keeps working no
matter how much data is pushed through it ...

But the patch has one bad side-effect....
The transfers are slower, and loading webpages in firefox takes longer...

So... What patch am I missing ?

And to help debug the connection dropping issue, attached is a kernel 
log with "debug=0xffffffff" (and without the last patch)

--
Thomas




--------------040605030103010809060106
Content-Type: text/plain;
 name="ath9k.bug"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ath9k.bug"

Aug 19 21:10:46 localhost klogd: cfg80211: World regulatory domain updated:
Aug 19 21:10:46 localhost klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 19 21:10:46 localhost klogd: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 19 21:10:46 localhost klogd: ^I(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 19 21:10:46 localhost klogd: ^I(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 19 21:10:46 localhost klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 19 21:10:46 localhost klogd: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 19 21:10:46 localhost klogd: ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Aug 19 21:10:46 localhost klogd: phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xffffc90011280000, irq=17
Aug 19 21:10:46 localhost klogd: 
Aug 19 21:10:48 localhost klogd: NET: Registered protocol family 10
Aug 19 21:10:48 localhost klogd: lo: Disabled Privacy Extensions
Aug 19 21:10:49 localhost klogd: cfg80211: Calling CRDA for country: FR
Aug 19 21:10:49 localhost klogd: cfg80211: Regulatory domain changed to country: FR
Aug 19 21:10:49 localhost klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 19 21:10:49 localhost klogd: ^I(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 19 21:10:49 localhost klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 19 21:10:49 localhost klogd: ^I(5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 19 21:10:49 localhost klogd: ^I(5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Aug 19 21:10:49 localhost klogd: 
Aug 19 21:10:49 localhost klogd: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Aug 19 21:10:49 localhost klogd: 
Aug 19 21:10:50 localhost klogd: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Aug 19 21:10:51 localhost klogd: 
Aug 19 21:10:51 localhost klogd: 
Aug 19 21:10:52 localhost klogd: 
Aug 19 21:10:53 localhost klogd: 
Aug 19 21:10:54 localhost klogd: NET: Registered protocol family 17
Aug 19 21:10:54 localhost klogd: 
Aug 19 21:10:55 localhost klogd: 
Aug 19 21:10:58 localhost klogd: new IMR 0x0
Aug 19 21:11:11 localhost klogd: new IMR 0x0
Aug 19 21:11:15 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:11:15 localhost klogd: Enable TXE on queue: 1
Aug 19 21:11:15 localhost klogd: link[1] (ffff8800a5327d48)=e0 (ffff8800a5327de0)
Aug 19 21:11:32 localhost klogd: transmitting packet, skb: ffff8800850ab300
Aug 19 21:11:56 localhost klogd: new IMR 0x0
Aug 19 21:11:59 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:11:59 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:12:30 localhost klogd: transmitting packet, skb: ffff8800a51bb100
Aug 19 21:12:30 localhost klogd: transmitting packet, skb: ffff8800a1801500
Aug 19 21:12:30 localhost klogd: link[1] (ffff8800a53312e8)=80 (ffff8800a5331380)
Aug 19 21:12:38 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:12:38 localhost klogd: enable IER
Aug 19 21:12:38 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:39 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:39 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:39 localhost klogd: new IMR 0x0
Aug 19 21:12:39 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:39 localhost klogd: TX complete: skb: ffff8800a3826f00
Aug 19 21:12:39 localhost klogd: disable IER
Aug 19 21:12:41 localhost klogd: transmitting packet, skb: ffff88006b56eef8
Aug 19 21:12:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:12:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:44 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:12:44 localhost klogd: transmitting packet, skb: ffff8800a51c1c00
Aug 19 21:12:44 localhost klogd: link[1] (ffff8800a5327590)=28 (ffff8800a5327628)
Aug 19 21:12:44 localhost klogd: enable IER
Aug 19 21:12:46 localhost klogd: new IMR 0x0
Aug 19 21:12:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:47 localhost klogd: transmitting packet, skb: ffff88006f54dcf8
Aug 19 21:12:47 localhost klogd: tx queue 1 (a532a348), link ffff8800a532a348
Aug 19 21:12:47 localhost klogd: transmitting packet, skb: ffff8800a5163800
Aug 19 21:12:47 localhost klogd: new IMR 0x0
Aug 19 21:12:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:47 localhost klogd: qnum: 1, txq depth: 1
Aug 19 21:12:47 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:47 localhost klogd: transmitting packet, skb: ffff8800a51fc900
Aug 19 21:12:47 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:49 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:49 localhost klogd: link[1] (ffff8800a532dea8)=40 (ffff8800a532df40)
Aug 19 21:12:49 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:49 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:49 localhost klogd: qnum: 1, txq depth: 4
Aug 19 21:12:50 localhost klogd: disable IER
Aug 19 21:12:50 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:55 localhost klogd: transmitting packet, skb: ffff8800a51c1700
Aug 19 21:12:55 localhost klogd: transmitting packet, skb: ffff8800851f7600
Aug 19 21:12:55 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:56 localhost klogd: disable IER
Aug 19 21:12:56 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:12:56 localhost klogd: tx queue 1 (a5325320), link ffff8800a5325320
Aug 19 21:12:56 localhost klogd: link[1] (ffff8800a5325748)=e0 (ffff8800a53257e0)
Aug 19 21:12:56 localhost klogd: qnum: 1, txq depth: 5
Aug 19 21:12:56 localhost klogd: disable IER
Aug 19 21:12:56 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:12:56 localhost klogd: qnum: 1, txq depth: 4
Aug 19 21:12:57 localhost klogd: transmitting packet, skb: ffff88009c123400
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 4
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:12:57 localhost klogd: transmitting packet, skb: ffff88007ec3e300
Aug 19 21:12:57 localhost klogd: link[1] (ffff8800a5329c28)=c0 (ffff8800a5329cc0)
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: transmitting packet, skb: ffff8800a51b9800
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: tx queue 1 (a532cb10), link ffff8800a532cb10
Aug 19 21:12:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:57 localhost klogd: link[1] (ffff8800a532d2c8)=60 (ffff8800a532d360)
Aug 19 21:12:57 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: tx queue 1 (a532e530), link ffff8800a532e530
Aug 19 21:12:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 1
Aug 19 21:12:57 localhost klogd: TXDP[1] = a0 (ffff8800a532f4a0)
Aug 19 21:12:57 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:57 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:57 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:12:57 localhost klogd: transmitting packet, skb: ffff8800a51fca00
Aug 19 21:12:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:57 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: enable IER
Aug 19 21:12:57 localhost klogd: link[1] (ffff8800a5320390)=28 (ffff8800a5320428)
Aug 19 21:12:57 localhost klogd: transmitting packet, skb: ffff8800b92ec600
Aug 19 21:12:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:57 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: link[1] (ffff8800a5325a40)=d8 (ffff8800a5325ad8)
Aug 19 21:12:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:58 localhost klogd: tx queue 1 (a5326ae0), link ffff8800a5326ae0
Aug 19 21:12:58 localhost klogd: TXDP[1] = f0 (ffff8800a53277f0)
Aug 19 21:12:58 localhost klogd: transmitting packet, skb: ffff8800a515a900
Aug 19 21:12:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:58 localhost klogd: tx queue 1 (a5327f10), link ffff8800a5327f10
Aug 19 21:12:58 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: tx queue 1 (a5329048), link ffff8800a5329048
Aug 19 21:12:58 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: tx queue 1 (a5329b90), link ffff8800a5329b90
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:58 localhost klogd: link[1] (ffff8800a532a938)=d0 (ffff8800a532a9d0)
Aug 19 21:12:58 localhost klogd: new IMR 0x918414b4
Aug 19 21:12:58 localhost klogd: enable IER
Aug 19 21:12:58 localhost klogd: enable IER
Aug 19 21:12:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:58 localhost klogd: transmitting packet, skb: ffff8800a51fd500
Aug 19 21:12:58 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:58 localhost klogd: link[1] (ffff8800a532d3f8)=90 (ffff8800a532d490)
Aug 19 21:12:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:12:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:58 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:58 localhost klogd: enable IER
Aug 19 21:12:58 localhost klogd: qnum: 1, txq depth: 1
Aug 19 21:12:58 localhost klogd: link[1] (ffff8800a5332da0)=38 (ffff8800a5332e38)
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:58 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:12:58 localhost klogd: transmitting packet, skb: ffff88008409a800
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:12:58 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: new IMR 0x918414b4
Aug 19 21:12:58 localhost klogd: new IMR 0x0
Aug 19 21:12:58 localhost klogd: transmitting packet, skb: ffff88009b9b3a00
Aug 19 21:12:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:12:58 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:00 localhost klogd: new IMR 0x0
Aug 19 21:13:00 localhost klogd: link[1] (ffff8800a5323bf8)=90 (ffff8800a5323c90)
Aug 19 21:13:00 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:13:00 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:00 localhost klogd: new IMR 0x0
Aug 19 21:13:00 localhost klogd: transmitting packet, skb: ffff8800a5163500
Aug 19 21:13:00 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: link[1] (ffff8800a5325878)=10 (ffff8800a5325910)
Aug 19 21:13:00 localhost klogd: qnum: 1, txq depth: 5
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:00 localhost klogd: enable IER
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: qnum: 1, txq depth: 4
Aug 19 21:13:00 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: disable IER
Aug 19 21:13:00 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:13:00 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:13:00 localhost klogd: tx queue 1 (a532cd70), link ffff8800a532cd70
Aug 19 21:13:00 localhost klogd: new IMR 0x0
Aug 19 21:13:00 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:13:00 localhost klogd: tx queue 1 (a532e238), link ffff8800a532e238
Aug 19 21:13:00 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:00 localhost klogd: transmitting packet, skb: ffff88008511de00
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: tx queue 1 (a53308d0), link ffff8800a53308d0
Aug 19 21:13:00 localhost klogd: disable IER
Aug 19 21:13:00 localhost klogd: transmitting packet, skb: ffff88009c123f00
Aug 19 21:13:00 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:13:00 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:00 localhost klogd: transmitting packet, skb: ffff8800a515b100
Aug 19 21:13:00 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:00 localhost klogd: transmitting packet, skb: ffff8800a51b8d00
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff88008314ae00
Aug 19 21:13:01 localhost klogd: new IMR 0x0
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a5235900
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:01 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a51fec00
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff88008314a400
Aug 19 21:13:01 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a5235800
Aug 19 21:13:01 localhost klogd: qnum: 1, txq depth: 1
Aug 19 21:13:01 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:13:01 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:01 localhost klogd: disable IER
Aug 19 21:13:01 localhost klogd: 0xf4041071 => 0x0
Aug 19 21:13:01 localhost klogd: disable IER
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a5002600
Aug 19 21:13:01 localhost klogd: qnum: 1, txq depth: 2
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a45d2900
Aug 19 21:13:01 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: new IMR 0x0
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a51fca00
Aug 19 21:13:01 localhost klogd: new IMR 0x918414b4
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800b91a3900
Aug 19 21:13:01 localhost klogd: link[1] (ffff8800a532e660)=f8 (ffff8800a532e6f8)
Aug 19 21:13:01 localhost klogd: Enable TXE on queue: 1
Aug 19 21:13:01 localhost klogd: link[1] (ffff8800a5330ec0)=58 (ffff8800a5330f58)
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a5002100
Aug 19 21:13:01 localhost klogd: qnum: 1, txq depth: 3
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800a5232d00
Aug 19 21:13:01 localhost klogd: new IMR 0x0
Aug 19 21:13:01 localhost klogd: transmitting packet, skb: ffff8800830e8d00
Aug 19 21:13:01 localhost klogd: new IMR 0x0
Aug 19 21:13:01 localhost klogd: <414b4 IER 0x1
Aug 19 21:13:01 localhost klogd: h9=> 0xf4041071
Aug 19 21:13:01 localhost klogd: 7>ath9k: new IMR 0x0
Aug 19 21:13:02 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:13:02 localhost klogd: <7
Aug 19 21:13:02 localhost klogd: <7 disable IER
Aug 19 21:13:02 localhost klogd: < FIFO overrun interrupt
Aug 19 21:13:02 localhost klogd: <7NTR_SYNC_LOCAL_TIMEOUT
Aug 19 21:13:03 localhost klogd: enable IER
Aug 19 21:13:03 localhost klogd: <: enable IER
Aug 19 21:13:03 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:13:04 localhost klogd: enable IER
Aug 19 21:13:05 localhost klogd: enable IER
Aug 19 21:13:05 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:13:05 localhost klogd: new IMR 0x918414b4
Aug 19 21:13:05 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:13:05 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:13:06 localhost klogd: enable IER
Aug 19 21:13:06 localhost klogd: new IMR 0x0
Aug 19 21:13:06 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:13:06 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 21:13:09 localhost klogd: enable IER
Aug 19 21:13:10 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 21:13:10 localhost klogd: CE: hpet increasing min_delta_ns to 15000 nsec
Aug 19 21:13:11 localhost klogd: enable IER
Aug 19 21:13:11 localhost klogd: 0x0 => 0xf4041071
Aug 19 21:13:13 localhost klogd: ADDRCONF(NETDEV_UP): wlan0: link is not ready

--------------040605030103010809060106--
