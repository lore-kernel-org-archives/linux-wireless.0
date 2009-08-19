Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mbox2.netikka.net ([213.250.81.203]:39591 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbZHSVOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 17:14:41 -0400
Received: from [172.16.24.149] (ndn243.bob.fi [81.209.19.243])
	by mbox2.netikka.net (Postfix) with ESMTP id B4F824080CB
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 00:14:40 +0300 (EEST)
Message-ID: <4A8C6B40.9030104@mandriva.org>
Date: Thu, 20 Aug 2009 00:14:40 +0300
From: Thomas Backlund <tmb@mandriva.org>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k broken in 2.6.31-rc6
References: <4A8C601D.9040608@mandriva.org>
In-Reply-To: <4A8C601D.9040608@mandriva.org>
Content-Type: multipart/mixed;
 boundary="------------040102000600040305090808"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040102000600040305090808
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Thomas Backlund skrev:
> Hi,
> (please cc me on replies)
> 
> I'm tracking a bug in ath9k in 2.6.31-rc6, and have been cherrypicking 
> patches from wireless-testing to try to get a stable ath9k...
> 
> The problem is that if the user configures the interface it works, but 
> have a weak signal and tends to drop the connection.
> 
> If he reboots, the signal is even weaker, and also drops the connection
> faster. He has to reconfigure the interface to get it back up.
> 
> So here is what I have applied:
> 
> net-wireless-ath9k-Fix-bug-in-PCI-resume.patch
> net-wireless-ath9k-Set-HW-state-properly.patch
> net-wireless-ath9k-Manipulate-and-report-the-correct-RSSI.patch
> net-wireless-ath9k-Update-beacon-RSSI.patch
> net-wireless-ath9k-RX-stucks-during-heavy-traffic-in-HT40-mode.patch
> 
> 
> Now with theese patches the signal strength is correct, and the 
> connection survives the reboot, but does disconnect when transfer
> load increases.
> The good part of the above patches is that only a simple network restart
> is needed to get the connection back...
> 
> The fix for the connection dropping is to apply the patch:
> net-wireless-ath9k-Fix-TX-hang-issue-with-Atheros-chipsets.patch
> 
> with this patch applied the link is stable, and keeps working no
> matter how much data is pushed through it ...
> 
> But the patch has one bad side-effect....
> The transfers are slower, and loading webpages in firefox takes longer...
> 
> So... What patch am I missing ?
> 
> And to help debug the connection dropping issue, attached is a kernel 
> log with "debug=0xffffffff" (and without the last patch)


And to post a followup...

Attached is kernel log with "debug=0xffffffff" and with the last patch 
applied

--
Thomas

--------------040102000600040305090808
Content-Type: text/plain;
 name="ath9k.bug2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ath9k.bug2"

Aug 19 22:47:28 localhost klogd: cfg80211: Calling CRDA to update world regulatory domain
Aug 19 22:47:28 localhost klogd: cfg80211: World regulatory domain updated:
Aug 19 22:47:28 localhost klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 19 22:47:28 localhost klogd: ^I(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 19 22:47:28 localhost klogd: ^I(2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 19 22:47:28 localhost klogd: ^I(2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Aug 19 22:47:28 localhost klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 19 22:47:28 localhost klogd: ^I(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Aug 19 22:47:28 localhost klogd: ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Aug 19 22:47:29 localhost klogd: Registered led device: ath9k-phy0::radio
Aug 19 22:47:29 localhost klogd: Registered led device: ath9k-phy0::assoc
Aug 19 22:47:29 localhost klogd: Registered led device: ath9k-phy0::tx
Aug 19 22:47:29 localhost klogd: Registered led device: ath9k-phy0::rx
Aug 19 22:47:29 localhost klogd: phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=0xffffc900111e0000, irq=17
Aug 19 22:47:29 localhost klogd: 
Aug 19 22:47:31 localhost klogd: NET: Registered protocol family 10
Aug 19 22:47:31 localhost klogd: lo: Disabled Privacy Extensions
Aug 19 22:47:31 localhost klogd: cfg80211: Calling CRDA for country: FR
Aug 19 22:47:31 localhost klogd: cfg80211: Regulatory domain changed to country: FR
Aug 19 22:47:31 localhost klogd: ^I(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Aug 19 22:47:31 localhost klogd: ^I(2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 19 22:47:31 localhost klogd: ^I(5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 19 22:47:31 localhost klogd: ^I(5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Aug 19 22:47:31 localhost klogd: ^I(5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Aug 19 22:47:31 localhost klogd: ADDRCONF(NETDEV_UP): wlan0: link is not ready
Aug 19 22:47:31 localhost klogd: 
Aug 19 22:47:32 localhost klogd: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Aug 19 22:47:44 localhost klogd: transmitting packet, skb: ffff88009b8de400
Aug 19 22:47:45 localhost klogd: 
Aug 19 22:47:46 localhost klogd: transmitting packet, skb: ffff8800a48a5a00
Aug 19 22:47:46 localhost klogd: tx queue 1 (a4aa3900), link ffff8800a4aa3900
Aug 19 22:47:49 localhost klogd: 
Aug 19 22:47:53 localhost klogd: 
Aug 19 22:47:53 localhost klogd: 
Aug 19 22:47:54 localhost klogd: 
Aug 19 22:47:55 localhost klogd: 
Aug 19 22:47:56 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:47:56 localhost klogd: transmitting packet, skb: ffff8800a954d100
Aug 19 22:47:56 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:47:57 localhost klogd: Enable TXE on queue: 1
Aug 19 22:47:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:47:58 localhost klogd: transmitting packet, skb: ffff88009d56c300
Aug 19 22:47:59 localhost klogd: 
Aug 19 22:48:09 localhost klogd: enable IER
Aug 19 22:48:10 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:48:11 localhost klogd: link[1] (ffff8800a4aa8928)=c0 (ffff8800a4aa89c0)
Aug 19 22:48:16 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:48:27 localhost klogd: link[1] (ffff8800a4aa9b90)=28 (ffff8800a4aa9c28)
Aug 19 22:48:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:48:31 localhost klogd: transmitting packet, skb: ffff88006e1dce00
Aug 19 22:48:33 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:48:33 localhost klogd: link[1] (ffff8800a4aac358)=f0 (ffff8800a4aac3f0)
Aug 19 22:48:42 localhost klogd: new IMR 0x918414b4
Aug 19 22:48:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:48:46 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:48:46 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:48:46 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:48:46 localhost klogd: disable IER
Aug 19 22:48:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:48:56 localhost klogd: link[1] (ffff8800a4ab21c0)=58 (ffff8800a4ab2258)
Aug 19 22:48:56 localhost klogd: Enable TXE on queue: 1
Aug 19 22:49:00 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:49:00 localhost klogd: enable IER
Aug 19 22:49:00 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:49:01 localhost klogd: new IMR 0x918414b4
Aug 19 22:49:01 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:49:01 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:49:01 localhost klogd: enable IER
Aug 19 22:49:21 localhost klogd: new IMR 0x918414b4
Aug 19 22:49:22 localhost klogd: new IMR 0x0
Aug 19 22:49:33 localhost klogd: new IMR 0x0
Aug 19 22:49:36 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:49:42 localhost klogd: new IMR 0x918414b4
Aug 19 22:49:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:49:43 localhost klogd: transmitting packet, skb: ffff880086d14900
Aug 19 22:49:43 localhost klogd: new IMR 0x0
Aug 19 22:49:51 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:50:01 localhost klogd: new IMR 0x918414b4
Aug 19 22:50:11 localhost klogd: new IMR 0x918414b4
Aug 19 22:50:15 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:50:20 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:50:21 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:50:26 localhost klogd: new IMR 0x918414b4
Aug 19 22:50:33 localhost klogd: link[1] (ffff8800a4aa77f0)=88 (ffff8800a4aa7888)
Aug 19 22:50:33 localhost klogd: Enable TXE on queue: 1
Aug 19 22:50:36 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:50:36 localhost klogd: link[1] (ffff8800a4aa8a58)=f0 (ffff8800a4aa8af0)
Aug 19 22:50:36 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:50:37 localhost klogd: transmitting packet, skb: ffff8800a48a4a00
Aug 19 22:50:37 localhost klogd: new IMR 0x0
Aug 19 22:50:37 localhost klogd: transmitting packet, skb: ffff8800828fe700
Aug 19 22:50:37 localhost klogd: enable IER
Aug 19 22:50:37 localhost klogd: new IMR 0x0
Aug 19 22:50:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:50:40 localhost klogd: enable IER
Aug 19 22:50:40 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:50:41 localhost klogd: new IMR 0x0
Aug 19 22:50:47 localhost klogd: enable IER
Aug 19 22:50:47 localhost klogd: enable IER
Aug 19 22:50:52 localhost klogd: new IMR 0x918414b4
Aug 19 22:50:53 localhost klogd: enable IER
Aug 19 22:50:56 localhost klogd: enable IER
Aug 19 22:50:56 localhost klogd: new IMR 0x918414b4
Aug 19 22:50:56 localhost klogd: enable IER
Aug 19 22:51:04 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:51:04 localhost klogd: NF calibrated [ctl] [chain 0] is -117
Aug 19 22:51:06 localhost klogd: new IMR 0x918414b4
Aug 19 22:51:07 localhost klogd: enable IER
Aug 19 22:51:21 localhost klogd: link[1] (ffff8800a4ab0e28)=c0 (ffff8800a4ab0ec0)
Aug 19 22:51:21 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:51:37 localhost klogd: transmitting packet, skb: ffff8800a9559100
Aug 19 22:51:37 localhost klogd: link[1] (ffff8800a4aa0980)=20 (ffff8800a4aa0720)
Aug 19 22:51:47 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:51:52 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:51:52 localhost klogd: transmitting packet, skb: ffff8800a954d500
Aug 19 22:51:55 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:51:55 localhost klogd: new IMR 0x918414b4
Aug 19 22:51:57 localhost klogd: link[1] (ffff8800a4aa6c10)=a8 (ffff8800a4aa6ca8)
Aug 19 22:51:57 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:51:57 localhost klogd: link[1] (ffff8800a4aa8af0)=88 (ffff8800a4aa8b88)
Aug 19 22:51:57 localhost klogd: link[1] (ffff8800a4aa9340)=d8 (ffff8800a4aa93d8)
Aug 19 22:51:58 localhost klogd: tx queue 1 (a4aa9af8), link ffff8800a4aa9af8
Aug 19 22:51:58 localhost klogd: link[1] (ffff8800a4aa9c28)=c0 (ffff8800a4aa9cc0)
Aug 19 22:51:58 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:51:58 localhost klogd: transmitting packet, skb: ffff8800828d2800
Aug 19 22:51:58 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:51:59 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:00 localhost klogd: enable IER
Aug 19 22:52:01 localhost klogd: enable IER
Aug 19 22:52:01 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:01 localhost klogd: enable IER
Aug 19 22:52:01 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:02 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:02 localhost klogd: enable IER
Aug 19 22:52:02 localhost klogd: transmitting packet, skb: ffff880097ed84f8
Aug 19 22:52:02 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:52:02 localhost klogd: link[1] (ffff8800a4aada80)=18 (ffff8800a4aadb18)
Aug 19 22:52:03 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:08 localhost klogd: new IMR 0x0
Aug 19 22:52:08 localhost klogd: transmitting packet, skb: ffff88008485f100
Aug 19 22:52:08 localhost klogd: link[1] (ffff8800a4ab08d0)=68 (ffff8800a4ab0968)
Aug 19 22:52:08 localhost klogd: enable IER
Aug 19 22:52:08 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:08 localhost klogd: transmitting packet, skb: ffff8800a4988c00
Aug 19 22:52:08 localhost klogd: enable IER
Aug 19 22:52:08 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:08 localhost klogd: transmitting packet, skb: ffff8800a4919b00
Aug 19 22:52:08 localhost klogd: disable IER
Aug 19 22:52:08 localhost klogd: link[1] (ffff8800a4aa02f8)=90 (ffff8800a4aa0390)
Aug 19 22:52:09 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:09 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:52:09 localhost klogd: enable IER
Aug 19 22:52:10 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:10 localhost klogd: enable IER
Aug 19 22:52:10 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:12 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:12 localhost klogd: new IMR 0x0
Aug 19 22:52:12 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:12 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:12 localhost klogd: disable IER
Aug 19 22:52:12 localhost klogd: new IMR 0x0
Aug 19 22:52:12 localhost klogd: link[1] (ffff8800a4aa5a40)=d8 (ffff8800a4aa5ad8)
Aug 19 22:52:12 localhost klogd: transmitting packet, skb: ffff8800a185d200
Aug 19 22:52:12 localhost klogd: link[1] (ffff8800a4aa5e68)=0 (ffff8800a4aa5f00)
Aug 19 22:52:12 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:52:12 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:12 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:12 localhost klogd: link[1] (ffff8800a4aa9930)=c8 (ffff8800a4aa99c8)
Aug 19 22:52:13 localhost klogd: enable IER
Aug 19 22:52:13 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:13 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:13 localhost klogd: transmitting packet, skb: ffff880084996d00
Aug 19 22:52:13 localhost klogd: link[1] (ffff8800a4aaccd8)=70 (ffff8800a4aacd70)
Aug 19 22:52:13 localhost klogd: disable IER
Aug 19 22:52:13 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:13 localhost klogd: disable IER
Aug 19 22:52:13 localhost klogd: transmitting packet, skb: ffff8800a954dc00
Aug 19 22:52:13 localhost klogd: transmitting packet, skb: ffff880069c0f600
Aug 19 22:52:13 localhost klogd: link[1] (ffff8800a4ab11b8)=50 (ffff8800a4ab1250)
Aug 19 22:52:13 localhost klogd: new IMR 0x0
Aug 19 22:52:13 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:13 localhost klogd: disable IER
Aug 19 22:52:13 localhost klogd: TX complete: skb: ffff8800a4874100
Aug 19 22:52:13 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:13 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:13 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:13 localhost klogd: new IMR 0x0
Aug 19 22:52:13 localhost klogd: link[1] (ffff8800a4aa54e8)=80 (ffff8800a4aa5580)
Aug 19 22:52:13 localhost klogd: transmitting packet, skb: ffff8800a5c73900
Aug 19 22:52:13 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:13 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:13 localhost klogd: tx queue 1 (a4aa6458), link ffff8800a4aa6458
Aug 19 22:52:13 localhost klogd: transmitting packet, skb: ffff8800ba402d00
Aug 19 22:52:13 localhost klogd: link[1] (ffff8800a4aa89c0)=58 (ffff8800a4aa8a58)
Aug 19 22:52:13 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:13 localhost klogd: transmitting packet, skb: ffff8800a48c3200
Aug 19 22:52:13 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:14 localhost klogd: tx queue 1 (a4aad230), link ffff8800a4aad230
Aug 19 22:52:14 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:14 localhost klogd: disable IER
Aug 19 22:52:14 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:14 localhost klogd: transmitting packet, skb: ffff88008484df00
Aug 19 22:52:14 localhost klogd:  => 0x0
Aug 19 22:52:14 localhost klogd: 9k: enable IER
Aug 19 22:52:14 localhost klogd: <7: new IMR 0x0
Aug 19 22:52:14 localhost klogd: <7ath9k: 0x0 => 0xf4041071
Aug 19 22:52:15 localhost klogd: <7: A18414b4 IER 0x1
Aug 19 22:52:16 localhost klogd: enable IER
Aug 19 22:52:16 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:52:16 localhost klogd: disable IER
Aug 19 22:52:16 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:16 localhost klogd: link[1] (ffff8800a4ab08d0)=68 (ffff8800a4ab0968)
Aug 19 22:52:16 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:16 localhost klogd: link[1] (ffff8800a4ab0f58)=88 (ffff8800a4ab1088)
Aug 19 22:52:16 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:16 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:16 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:16 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:52:16 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:16 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:16 localhost klogd: new IMR 0x0
Aug 19 22:52:16 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:16 localhost klogd: link[1] (ffff8800a4aa1728)=c0 (ffff8800a4aa17c0)
Aug 19 22:52:16 localhost klogd: link[1] (ffff8800a4aa1ab8)=50 (ffff8800a4aa1b50)
Aug 19 22:52:16 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:16 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:16 localhost klogd: tx queue 1 (a4aa3018), link ffff8800a4aa3018
Aug 19 22:52:16 localhost klogd: tx queue 1 (a4aa3738), link ffff8800a4aa3738
Aug 19 22:52:16 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:17 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:17 localhost klogd: enable IER
Aug 19 22:52:17 localhost klogd: tx queue 1 (a4aa4d30), link ffff8800a4aa4d30
Aug 19 22:52:17 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:17 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:17 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:17 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: transmitting packet, skb: ffff8800a4810700
Aug 19 22:52:17 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: enable IER
Aug 19 22:52:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: tx queue 1 (a4aa9a60), link ffff8800a4aa9a60
Aug 19 22:52:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: tx queue 1 (a4aa9cc0), link ffff8800a4aa9cc0
Aug 19 22:52:17 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:17 localhost klogd: disable IER
Aug 19 22:52:17 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:17 localhost klogd: transmitting packet, skb: ffff8800a5ca1e00
Aug 19 22:52:17 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:17 localhost klogd: transmitting packet, skb: ffff8800a48a4f00
Aug 19 22:52:17 localhost klogd: transmitting packet, skb: ffff8800af0d7900
Aug 19 22:52:17 localhost klogd: enable IER
Aug 19 22:52:17 localhost klogd: new IMR 0x0
Aug 19 22:52:17 localhost klogd: transmitting packet, skb: ffff8800a5cd2500
Aug 19 22:52:17 localhost klogd: link[1] (ffff8800a4aad3f8)=90 (ffff8800a4aad490)
Aug 19 22:52:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:17 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:18 localhost klogd: transmitting packet, skb: ffff8800a954de00
Aug 19 22:52:19 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:19 localhost klogd: new IMR 0x0
Aug 19 22:52:19 localhost klogd: link[1] (ffff8800a4ab1970)=8 (ffff8800a4ab1a08)
Aug 19 22:52:19 localhost klogd: tx queue 1 (a4ab1aa0), link ffff8800a4ab1aa0
Aug 19 22:52:19 localhost klogd: transmitting packet, skb: ffff880069c0f000
Aug 19 22:52:19 localhost klogd: <9k:4b4 I1
Aug 19 22:52:19 localhost klogd: <receive FIFO overrun interrupt
Aug 19 22:52:19 localhost klogd: <7 AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:19 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:52:19 localhost klogd: enable IER
Aug 19 22:52:19 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:19 localhost klogd: enable IER
Aug 19 22:52:20 localhost klogd: <7=> 0xf4041071
Aug 19 22:52:20 localhost klogd: <7b4
Aug 19 22:52:20 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:20 localhost klogd: enable IER
Aug 19 22:52:20 localhost klogd: enable IER
Aug 19 22:52:23 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:23 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:23 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:23 localhost klogd: transmitting packet, skb: ffff8800af42e100
Aug 19 22:52:23 localhost klogd: enable IER
Aug 19 22:52:23 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:23 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:23 localhost klogd: link[1] (ffff8800a4aa23a0)=38 (ffff8800a4aa2438)
Aug 19 22:52:23 localhost klogd: link[1] (ffff8800a4aa2860)=f8 (ffff8800a4aa28f8)
Aug 19 22:52:23 localhost klogd: new IMR 0x0
Aug 19 22:52:23 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:23 localhost klogd: transmitting packet, skb: ffff880084920a00
Aug 19 22:52:23 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:23 localhost klogd: new IMR 0x0
Aug 19 22:52:23 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:23 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:23 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:23 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:23 localhost klogd: disable IER
Aug 19 22:52:23 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:52:23 localhost klogd: enable IER
Aug 19 22:52:23 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:23 localhost klogd: transmitting packet, skb: ffff8800a5d12100
Aug 19 22:52:24 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:24 localhost klogd: <k: receive FIFO overrun interrupt
Aug 19 22:52:24 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:52:24 localhost klogd: <79k: disable IER
Aug 19 22:52:25 localhost klogd: enable IER
Aug 19 22:52:25 localhost klogd: enable IER
Aug 19 22:52:25 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:26 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:52:26 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:28 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:52:28 localhost klogd: transmitting packet, skb: ffff88009b8def00
Aug 19 22:52:28 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:28 localhost klogd: transmitting packet, skb: ffff8800828fe200
Aug 19 22:52:28 localhost klogd: enable IER
Aug 19 22:52:28 localhost klogd: transmitting packet, skb: ffff88009b8de700
Aug 19 22:52:28 localhost klogd: enable IER
Aug 19 22:52:28 localhost klogd: enable IER
Aug 19 22:52:28 localhost klogd: new IMR 0x0
Aug 19 22:52:28 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:28 localhost klogd: transmitting packet, skb: ffff8800a5ca1b00
Aug 19 22:52:28 localhost klogd: tx queue 1 (a4ab2d08), link ffff8800a4ab2d08
Aug 19 22:52:28 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:28 localhost klogd: new IMR 0x0
Aug 19 22:52:28 localhost klogd: tx queue 1 (a4aa2438), link ffff8800a4aa2438
Aug 19 22:52:28 localhost klogd: link[1] (ffff8800a4aa3278)=10 (ffff8800a4aa3310)
Aug 19 22:52:28 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:28 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:28 localhost klogd: new IMR 0x0
Aug 19 22:52:28 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:28 localhost klogd: enable IER
Aug 19 22:52:28 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:28 localhost klogd: new IMR 0x0
Aug 19 22:52:29 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:29 localhost klogd: new IMR 0x0
Aug 19 22:52:29 localhost klogd: new IMR 0x0
Aug 19 22:52:29 localhost klogd: tx queue 1 (a4aaa348), link ffff8800a4aaa348
Aug 19 22:52:29 localhost klogd: new IMR 0x0
Aug 19 22:52:29 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:29 localhost klogd: transmitting packet, skb: ffff8800af598700
Aug 19 22:52:29 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:29 localhost klogd: transmitting packet, skb: ffff88009e518700
Aug 19 22:52:29 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:29 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:30 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:30 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:31 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:31 localhost klogd: <k: disable IER
Aug 19 22:52:33 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:33 localhost klogd: TX complete: skb: ffff88006e1dca00
Aug 19 22:52:33 localhost klogd: transmitting packet, skb: ffff8800849a9900
Aug 19 22:52:33 localhost klogd: transmitting packet, skb: ffff88009e518100
Aug 19 22:52:33 localhost klogd: link[1] (ffff8800a4aadd78)=10 (ffff8800a4aade10)
Aug 19 22:52:33 localhost klogd: transmitting packet, skb: ffff880084920e00
Aug 19 22:52:33 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:33 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:33 localhost klogd: link[1] (ffff8800a4ab2a10)=a8 (ffff8800a4ab2aa8)
Aug 19 22:52:33 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:33 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:33 localhost klogd: transmitting packet, skb: ffff8800a5ca1200
Aug 19 22:52:33 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:33 localhost klogd: transmitting packet, skb: ffff8800af598900
Aug 19 22:52:33 localhost klogd: new IMR 0x0
Aug 19 22:52:34 localhost klogd: link[1] (ffff8800a4aa3570)=8 (ffff8800a4aa3608)
Aug 19 22:52:34 localhost klogd: link[1] (ffff8800a4aa36a0)=38 (ffff8800a4aa3738)
Aug 19 22:52:34 localhost klogd: transmitting packet, skb: ffff88006e1dc700
Aug 19 22:52:34 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:34 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:34 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:34 localhost klogd: new IMR 0x0
Aug 19 22:52:34 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:34 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:52:35 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:35 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:52:35 localhost klogd: enable IER
Aug 19 22:52:35 localhost klogd: enable IER
Aug 19 22:52:36 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:36 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: disable IER
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff8800a48c3c00
Aug 19 22:52:38 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:38 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff8800a4988800
Aug 19 22:52:38 localhost klogd: new IMR 0x0
Aug 19 22:52:38 localhost klogd: link[1] (ffff8800a4aaf8c8)=60 (ffff8800a4aaf960)
Aug 19 22:52:38 localhost klogd: new IMR 0x0
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: disable IER
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: disable IER
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff8800a5ca1400
Aug 19 22:52:38 localhost klogd: link[1] (ffff8800a4ab0540)=d8 (ffff8800a4ab05d8)
Aug 19 22:52:38 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:38 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:38 localhost klogd: new IMR 0x0
Aug 19 22:52:38 localhost klogd: disable IER
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff880086d14600
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: tx queue 1 (a4ab1ec8), link ffff8800a4ab1ec8
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff88009e518700
Aug 19 22:52:38 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff8800a9559400
Aug 19 22:52:38 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:38 localhost klogd: disable IER
Aug 19 22:52:38 localhost klogd: link[1] (ffff8800a4aa3900)=98 (ffff8800a4aa3998)
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff8800a5c73500
Aug 19 22:52:38 localhost klogd: disable IER
Aug 19 22:52:38 localhost klogd: transmitting packet, skb: ffff8800a2c0dd00
Aug 19 22:52:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:39 localhost klogd: transmitting packet, skb: ffff88009d6bce00
Aug 19 22:52:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:39 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:39 localhost klogd: disable IER
Aug 19 22:52:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:39 localhost klogd: link[1] (ffff8800a4aa9cc0)=58 (ffff8800a4aa9d58)
Aug 19 22:52:39 localhost klogd: new IMR 0x0
Aug 19 22:52:39 localhost klogd: <f4041071 => 0x0
Aug 19 22:52:40 localhost klogd: disable IER
Aug 19 22:52:40 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:40 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:41 localhost klogd: new IMR 0x0
Aug 19 22:52:41 localhost klogd: link[1] (ffff8800a4aab940)=d8 (ffff8800a4aab9d8)
Aug 19 22:52:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:41 localhost klogd: disable IER
Aug 19 22:52:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:41 localhost klogd: transmitting packet, skb: ffff88009d567e00
Aug 19 22:52:41 localhost klogd: enable IER
Aug 19 22:52:41 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:41 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:41 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:41 localhost klogd: link[1] (ffff8800a4aa1db0)=48 (ffff8800a4aa1e48)
Aug 19 22:52:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:41 localhost klogd: disable IER
Aug 19 22:52:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:41 localhost klogd: tx queue 1 (a4aa3e58), link ffff8800a4aa3e58
Aug 19 22:52:41 localhost klogd: transmitting packet, skb: ffff880069c0fd00
Aug 19 22:52:41 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:41 localhost klogd: enable IER
Aug 19 22:52:41 localhost klogd: tx queue 1 (a4aa4a38), link ffff8800a4aa4a38
Aug 19 22:52:41 localhost klogd: link[1] (ffff8800a4aa4b68)=0 (ffff8800a4aa4c00)
Aug 19 22:52:41 localhost klogd: transmitting packet, skb: ffff8800a5d12d00
Aug 19 22:52:42 localhost klogd: disable IER
Aug 19 22:52:42 localhost klogd: link[1] (ffff8800a4aa80d8)=70 (ffff8800a4aa8170)
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff880089d49100
Aug 19 22:52:42 localhost klogd: link[1] (ffff8800a4aa9b90)=28 (ffff8800a4aa9c28)
Aug 19 22:52:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:42 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:42 localhost klogd: disable IER
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800828d2100
Aug 19 22:52:42 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:42 localhost klogd: disable IER
Aug 19 22:52:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:42 localhost klogd: link[1] (ffff8800a4aad2c8)=60 (ffff8800a4aad360)
Aug 19 22:52:42 localhost klogd: disable IER
Aug 19 22:52:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:42 localhost klogd: tx queue 1 (a4aafbc0), link ffff8800a4aafbc0
Aug 19 22:52:42 localhost klogd: link[1] (ffff8800a4aafd88)=20 (ffff8800a4aafe20)
Aug 19 22:52:42 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:42 localhost klogd: link[1] (ffff8800a4ab08d0)=68 (ffff8800a4ab0968)
Aug 19 22:52:42 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:42 localhost klogd: link[1] (ffff8800a4ab0cf8)=90 (ffff8800a4ab0d90)
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: tx queue 1 (a4ab12e8), link ffff8800a4ab1380
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800a4983a00
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff88006e03a000
Aug 19 22:52:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:42 localhost klogd: disable IER
Aug 19 22:52:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:42 localhost klogd: tx queue 1 (a4ab3000), link ffff8800a4ab3000
Aug 19 22:52:42 localhost klogd: disable IER
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800828fd100
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff88009d567400
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800af0b7200
Aug 19 22:52:42 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800a9559d00
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800849a9e00
Aug 19 22:52:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:42 localhost klogd: transmitting packet, skb: ffff8800af598500
Aug 19 22:52:42 localhost klogd: new IMR 0x0
Aug 19 22:52:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:43 localhost klogd: transmitting packet, skb: ffff880084920b00
Aug 19 22:52:43 localhost klogd: link[1] (ffff8800a4aa9638)=d0 (ffff8800a4aa96d0)
Aug 19 22:52:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:43 localhost klogd: transmitting packet, skb: ffff880084996c00
Aug 19 22:52:43 localhost klogd: enable IER
Aug 19 22:52:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:43 localhost klogd: disable IER
Aug 19 22:52:43 localhost klogd: link[1] (ffff8800a4aa87f8)=20 (ffff8800a4aab220)
Aug 19 22:52:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:43 localhost klogd: new IMR 0x0
Aug 19 22:52:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:43 localhost klogd: transmitting packet, skb: ffff88008285c000
Aug 19 22:52:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:43 localhost klogd: transmitting packet, skb: ffff88009b8dee00
Aug 19 22:52:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:43 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:43 localhost klogd: new IMR 0x0
Aug 19 22:52:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:43 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:43 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:43 localhost klogd: tx queue 1 (a4ab15e0), link ffff8800a4ab15e0
Aug 19 22:52:43 localhost klogd: new IMR 0x0
Aug 19 22:52:44 localhost klogd: transmitting packet, skb: ffff880084920b00
Aug 19 22:52:44 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:44 localhost klogd: transmitting packet, skb: ffff880084859b00
Aug 19 22:52:44 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:44 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:44 localhost klogd: tx queue 1 (a4aa0a18), link ffff8800a4aa0a18
Aug 19 22:52:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:44 localhost klogd: tx queue 1 (a4aa0c78), link ffff8800a4aa0c78
Aug 19 22:52:44 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:44 localhost klogd: transmitting packet, skb: ffff88009b8de700
Aug 19 22:52:44 localhost klogd: link[1] (ffff8800a4aa1d18)=b0 (ffff8800a4aa1db0)
Aug 19 22:52:44 localhost klogd: enable IER
Aug 19 22:52:44 localhost klogd: tx queue 1 (a4aa3608), link ffff8800a4aa3608
Aug 19 22:52:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:44 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:44 localhost klogd: new IMR 0x0
Aug 19 22:52:44 localhost klogd: transmitting packet, skb: ffff880082959500
Aug 19 22:52:44 localhost klogd: new IMR 0x0
Aug 19 22:52:44 localhost klogd: transmitting packet, skb: ffff88009e518300
Aug 19 22:52:44 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:44 localhost klogd: new IMR 0x0
Aug 19 22:52:44 localhost klogd: enable IER
Aug 19 22:52:45 localhost klogd: 0
Aug 19 22:52:45 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:45 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:46 localhost klogd: transmitting packet, skb: ffff8800a957a500
Aug 19 22:52:46 localhost klogd: enable IER
Aug 19 22:52:46 localhost klogd: transmitting packet, skb: ffff8800849a9e00
Aug 19 22:52:46 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:46 localhost klogd: disable IER
Aug 19 22:52:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:46 localhost klogd: link[1] (ffff8800a4aac488)=20 (ffff8800a4aac520)
Aug 19 22:52:46 localhost klogd: link[1] (ffff8800a4aaccd8)=70 (ffff8800a4aacd70)
Aug 19 22:52:46 localhost klogd: transmitting packet, skb: ffff8800a957ab00
Aug 19 22:52:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:46 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:46 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:47 localhost klogd: new IMR 0x0
Aug 19 22:52:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff8800828d2400
Aug 19 22:52:47 localhost klogd: enable IER
Aug 19 22:52:47 localhost klogd: disable IER
Aug 19 22:52:47 localhost klogd: new IMR 0x0
Aug 19 22:52:47 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:47 localhost klogd: tx queue 1 (a4ab2c70), link ffff8800a4ab2c70
Aug 19 22:52:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff880082959c00
Aug 19 22:52:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: link[1] (ffff8800a4aa2600)=98 (ffff8800a4aa2698)
Aug 19 22:52:47 localhost klogd: new IMR 0x0
Aug 19 22:52:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:47 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:47 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:47 localhost klogd: tx queue 1 (a4aa49a0), link ffff8800a4aa49a0
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff8800a5ddf000
Aug 19 22:52:47 localhost klogd: link[1] (ffff8800a4aa53b8)=e8 (ffff8800a4aa54e8)
Aug 19 22:52:47 localhost klogd: tx queue 1 (a4aa54e8), link ffff8800a4aa54e8
Aug 19 22:52:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff880089d44b00
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff880089c78300
Aug 19 22:52:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:47 localhost klogd: link[1] (ffff8800a4aa7038)=d0 (ffff8800a4aa70d0)
Aug 19 22:52:47 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:47 localhost klogd: disable IER
Aug 19 22:52:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff8800a4939d00
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff8800af42eb00
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff8800a5c73900
Aug 19 22:52:47 localhost klogd: new IMR 0x0
Aug 19 22:52:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:47 localhost klogd: disable IER
Aug 19 22:52:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:47 localhost klogd: new IMR 0x0
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff88009d6bc600
Aug 19 22:52:47 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:47 localhost klogd: transmitting packet, skb: ffff8800a1a29b00
Aug 19 22:52:47 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:47 localhost klogd: link[1] (ffff8800a4ab0a98)=30 (ffff8800a4ab0b30)
Aug 19 22:52:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:48 localhost klogd: link[1] (ffff8800a4ab1e30)=c8 (ffff8800a4ab1ec8)
Aug 19 22:52:48 localhost klogd: TX complete: skb: ffff8800a1856200
Aug 19 22:52:48 localhost klogd: disable IER
Aug 19 22:52:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:48 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:48 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:48 localhost klogd: tx queue 1 (a4aa0d10), link ffff8800a4aa0d10
Aug 19 22:52:48 localhost klogd: disable IER
Aug 19 22:52:48 localhost klogd: new IMR 0x0
Aug 19 22:52:48 localhost klogd: link[1] (ffff8800a4aa20a8)=40 (ffff8800a4aa2140)
Aug 19 22:52:48 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:48 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:48 localhost klogd: new IMR 0x0
Aug 19 22:52:48 localhost klogd: transmitting packet, skb: ffff88009d567200
Aug 19 22:52:48 localhost klogd: transmitting packet, skb: ffff88009b8de300
Aug 19 22:52:48 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:48 localhost klogd: tx queue 1 (a4aa7200), link ffff8800a4aa7200
Aug 19 22:52:48 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:48 localhost klogd: disable IER
Aug 19 22:52:48 localhost klogd: tx queue 1 (a4aa77f0), link ffff8800a4aa77f0
Aug 19 22:52:48 localhost klogd: new IMR 0x0
Aug 19 22:52:48 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:48 localhost klogd: new IMR 0x0
Aug 19 22:52:48 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:48 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:48 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:48 localhost klogd: transmitting packet, skb: ffff8800a49c7a00
Aug 19 22:52:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:48 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:48 localhost klogd: disable IER
Aug 19 22:52:48 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:48 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:48 localhost klogd: transmitting packet, skb: ffff88008285d300
Aug 19 22:52:48 localhost klogd: new IMR 0x0
Aug 19 22:52:48 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:48 localhost klogd: disable IER
Aug 19 22:52:48 localhost klogd: <7ab0670), link ffff8800a4ab0708
Aug 19 22:52:48 localhost klogd: k: Enable TXE on queue: 1
Aug 19 22:52:48 localhost klogd: 414b4
Aug 19 22:52:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:49 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:49 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:49 localhost klogd: enable IE
Aug 19 22:52:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff8800af0d7800
Aug 19 22:52:49 localhost klogd: disable IER
Aug 19 22:52:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:49 localhost klogd: new IMR 0x0
Aug 19 22:52:49 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff8800a481f300
Aug 19 22:52:49 localhost klogd: link[1] (ffff8800a4aa7d48)=e0 (ffff8800a4aa7de0)
Aug 19 22:52:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff8800a5d12100
Aug 19 22:52:49 localhost klogd: enable IER
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff8800a49c7a00
Aug 19 22:52:49 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:49 localhost klogd: new IMR 0x0
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff880084920800
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff8800a4810300
Aug 19 22:52:49 localhost klogd: new IMR 0x0
Aug 19 22:52:49 localhost klogd: transmitting packet, skb: ffff8800a5c73d00
Aug 19 22:52:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:49 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:49 localhost klogd: link[1] (ffff8800a4aac5b8)=50 (ffff8800a4aac650)
Aug 19 22:52:49 localhost klogd: disable IER
Aug 19 22:52:49 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:49 localhost klogd: link[1] (ffff8800a4aad528)=c0 (ffff8800a4aad5c0)
Aug 19 22:52:49 localhost klogd: R
Aug 19 22:52:49 localhost klogd: <7918414b4 IER 0x1
Aug 19 22:52:50 localhost klogd: <h9k: new IMR 0x0
Aug 19 22:52:50 localhost klogd: <70
Aug 19 22:52:50 localhost klogd: <7nable IER
Aug 19 22:52:50 localhost klogd: PDADC (0,   0): a2d4 8f8f8f8f
Aug 19 22:52:51 localhost klogd: enable IER
Aug 19 22:52:52 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:53 localhost klogd: enable IER
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff88008484d100
Aug 19 22:52:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff8800a4805600
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff880069c0fa00
Aug 19 22:52:53 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:53 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff88008485f400
Aug 19 22:52:53 localhost klogd: qnum: 1, txq depth: 5
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff88008485f100
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff8800a185d200
Aug 19 22:52:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:53 localhost klogd: transmitting packet, skb: ffff8800a48e0900
Aug 19 22:52:53 localhost klogd: disable IER
Aug 19 22:52:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:54 localhost klogd: new IMR 0x0
Aug 19 22:52:54 localhost klogd: enable IER
Aug 19 22:52:54 localhost klogd: link[1] (ffff8800a4aa5878)=10 (ffff8800a4aa5910)
Aug 19 22:52:54 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:54 localhost klogd: transmitting packet, skb: ffff8800af0d7f00
Aug 19 22:52:54 localhost klogd: enable IER
Aug 19 22:52:55 localhost klogd: <b4
Aug 19 22:52:55 localhost klogd: enable IER
Aug 19 22:52:56 localhost klogd: enable IER
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff8800a48e0e00
Aug 19 22:52:56 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:56 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff8800a48e0600
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff88009d56cd00
Aug 19 22:52:56 localhost klogd: new IMR 0x918414b4
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:56 localhost klogd: link[1] (ffff8800a4aae8c0)=58 (ffff8800a4aae958)
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: link[1] (ffff8800a4aaf408)=a0 (ffff8800a4aaf4a0)
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff8800a48a5a00
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff8800af0b7700
Aug 19 22:52:56 localhost klogd: tx queue 1 (a4ab0708), link ffff8800a4ab0708
Aug 19 22:52:56 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:56 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: new IMR 0x0
Aug 19 22:52:56 localhost klogd: link[1] (ffff8800a4ab3260)=f8 (ffff8800a4ab32f8)
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff8800a4983000
Aug 19 22:52:56 localhost klogd: tx queue 1 (a4ab3428), link ffff8800a4ab3428
Aug 19 22:52:56 localhost klogd: transmitting packet, skb: ffff8800a185d600
Aug 19 22:52:57 localhost klogd: new IMR 0x0
Aug 19 22:52:57 localhost klogd: transmitting packet, skb: ffff88008297aa00
Aug 19 22:52:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:57 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:57 localhost klogd: enable IER
Aug 19 22:52:57 localhost klogd: transmitting packet, skb: ffff8800849a9300
Aug 19 22:52:57 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:57 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:58 localhost klogd: disable IER
Aug 19 22:52:58 localhost klogd: new IMR 0x0
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff88009b8dea00
Aug 19 22:52:58 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:58 localhost klogd: tx queue 1 (a4aa7c18), link ffff8800a4aa7c18
Aug 19 22:52:58 localhost klogd: new IMR 0x0
Aug 19 22:52:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff880086d14100
Aug 19 22:52:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:58 localhost klogd: tx queue 1 (a4aacba8), link ffff8800a4aacba8
Aug 19 22:52:58 localhost klogd: enable IER
Aug 19 22:52:58 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:52:58 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:58 localhost klogd: enable IER
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff8800af598700
Aug 19 22:52:58 localhost klogd: new IMR 0x0
Aug 19 22:52:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:58 localhost klogd: TX complete: skb: ffff8800a481e500
Aug 19 22:52:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:58 localhost klogd: new IMR 0x0
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff88008297ab00
Aug 19 22:52:58 localhost klogd: TX complete: skb: ffff88006e03a100
Aug 19 22:52:58 localhost klogd: new IMR 0x0
Aug 19 22:52:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:58 localhost klogd: disable IER
Aug 19 22:52:58 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff8800a481f200
Aug 19 22:52:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:52:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff88006e03a100
Aug 19 22:52:58 localhost klogd: transmitting packet, skb: ffff88009d56c300
Aug 19 22:52:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:59 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:52:59 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:59 localhost klogd: disable IER
Aug 19 22:52:59 localhost klogd: link[1] (ffff8800a4aa92a8)=40 (ffff8800a4aa9340)
Aug 19 22:52:59 localhost klogd: transmitting packet, skb: ffff88009e518700
Aug 19 22:52:59 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:59 localhost klogd: new IMR 0x0
Aug 19 22:52:59 localhost klogd: <>ath9k: transmitting packet, skb: ffff8800a4805200
Aug 19 22:52:59 localhost klogd: transmitting packet, skb: ffff880086d14000
Aug 19 22:52:59 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:59 localhost klogd: tx queue 1 (a4aac5b8), link ffff8800a4aac5b8
Aug 19 22:52:59 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:59 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:59 localhost klogd: transmitting packet, skb: ffff8800ba402b00
Aug 19 22:52:59 localhost klogd: new IMR 0x0
Aug 19 22:52:59 localhost klogd: disable IER
Aug 19 22:52:59 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:59 localhost klogd: transmitting packet, skb: ffff8800af42e200
Aug 19 22:52:59 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:52:59 localhost klogd: tx queue 1 (a4aaeb20), link ffff8800a4aaeb20
Aug 19 22:52:59 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:59 localhost klogd: transmitting packet, skb: ffff8800b9147b00
Aug 19 22:52:59 localhost klogd: Enable TXE on queue: 1
Aug 19 22:52:59 localhost klogd: disable IER
Aug 19 22:52:59 localhost klogd: transmitting packet, skb: ffff8800a5ca1800
Aug 19 22:52:59 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:52:59 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:01 localhost klogd: transmitting packet, skb: ffff8800a4815d00
Aug 19 22:53:01 localhost klogd: link[1] (ffff8800a4aa0980)=20 (ffff8800a4aa0720)
Aug 19 22:53:16 localhost klogd: tx queue 1 (a4aa1ee0), link ffff8800a4aa1ee0
Aug 19 22:53:16 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:16 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:16 localhost klogd: new IMR 0x0
Aug 19 22:53:16 localhost klogd: disable IER
Aug 19 22:53:16 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:16 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:16 localhost klogd: disable IER
Aug 19 22:53:16 localhost klogd: enable IER
Aug 19 22:53:16 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:16 localhost klogd: disable IER
Aug 19 22:53:16 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:16 localhost klogd: transmitting packet, skb: ffff8800a480fb00
Aug 19 22:53:16 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:16 localhost klogd: transmitting packet, skb: ffff8800a480f700
Aug 19 22:53:16 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:16 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:53:16 localhost klogd: link[1] (ffff8800a4aaff50)=80 (ffff8800a4ab0080)
Aug 19 22:53:16 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:16 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:16 localhost klogd: new IMR 0x0
Aug 19 22:53:16 localhost klogd: transmitting packet, skb: ffff8800a5c73000
Aug 19 22:53:16 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:17 localhost klogd: tx queue 1 (a4aa4908), link ffff8800a4aa4ef8
Aug 19 22:53:17 localhost klogd: transmitting packet, skb: ffff8800a481ef00
Aug 19 22:53:17 localhost klogd: disable IER
Aug 19 22:53:17 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:17 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:17 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:17 localhost klogd: disable IER
Aug 19 22:53:28 localhost klogd: new IMR 0x0
Aug 19 22:53:34 localhost klogd: transmitting packet, skb: ffff8800828fd700
Aug 19 22:53:34 localhost klogd: enable IER
Aug 19 22:53:36 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:36 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:53:36 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:37 localhost klogd: transmitting packet, skb: ffff880084920900
Aug 19 22:53:37 localhost klogd: transmitting packet, skb: ffff8800a9559a00
Aug 19 22:53:37 localhost klogd: new IMR 0x0
Aug 19 22:53:37 localhost klogd: new IMR 0x0
Aug 19 22:53:37 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:53:37 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:53:37 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:37 localhost klogd: enable IER
Aug 19 22:53:37 localhost klogd: transmitting packet, skb: ffff8800a5cd2a00
Aug 19 22:53:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:37 localhost klogd: tx queue 1 (a4aa2a28), link ffff8800a4aa2a28
Aug 19 22:53:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:37 localhost klogd: link[1] (ffff8800a4aa40b8)=50 (ffff8800a4aa4150)
Aug 19 22:53:37 localhost klogd: transmitting packet, skb: ffff8800ad98c800
Aug 19 22:53:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:38 localhost klogd: transmitting packet, skb: ffff8800a1856900
Aug 19 22:53:38 localhost klogd: enable IER
Aug 19 22:53:38 localhost klogd: transmitting packet, skb: ffff8800a4919800
Aug 19 22:53:38 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:38 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:38 localhost klogd: enable IER
Aug 19 22:53:38 localhost klogd: transmitting packet, skb: ffff8800a5ca1c00
Aug 19 22:53:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:38 localhost klogd: disable IER
Aug 19 22:53:38 localhost klogd: new IMR 0x0
Aug 19 22:53:38 localhost klogd: new IMR 0x918414b4
Aug 19 22:53:38 localhost klogd: new IMR 0x0
Aug 19 22:53:38 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:53:38 localhost klogd: enable IER
Aug 19 22:53:38 localhost klogd: tx queue 1 (a4aaf370), link ffff8800a4aaf370
Aug 19 22:53:38 localhost klogd: enable IER
Aug 19 22:53:38 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:38 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:38 localhost klogd: disable IER
Aug 19 22:53:38 localhost klogd: 1
Aug 19 22:53:38 localhost klogd: IMR 0x0
Aug 19 22:53:38 localhost klogd: TX complete: skb: ffff8800af0d7900
Aug 19 22:53:38 localhost klogd: tx queue 1 (a4aa7758), link ffff8800a4aa7758
Aug 19 22:53:38 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:39 localhost klogd: new IMR 0x0
Aug 19 22:53:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:39 localhost klogd: disable IER
Aug 19 22:53:39 localhost klogd: transmitting packet, skb: ffff8800a4988900
Aug 19 22:53:39 localhost klogd: qnum: 1, txq depth: 5
Aug 19 22:53:39 localhost klogd: eivath9k: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:53:39 localhost klogd: <7: enable IER
Aug 19 22:53:39 localhost klogd: >ath9k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:39 localhost klogd: <704100x0k: disable IER
Aug 19 22:53:39 localhost klogd: ble IER
Aug 19 22:53:39 localhost klogd: <77>ath9k: 0x0 => 0xf4041071
Aug 19 22:53:39 localhost klogd: MR 0xath> 0xf4041071
Aug 19 22:53:39 localhost klogd: <th9k: disable IER
Aug 19 22:53:40 localhost klogd: <>ath9k: new IMR 0x9187>athnab AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:40 localhost klogd: <1
Aug 19 22:53:40 localhost klogd: interrupt
Aug 19 22:53:40 localhost klogd: enable IER
Aug 19 22:53:40 localhost klogd: IMR 0x918414b4
Aug 19 22:53:40 localhost klogd: <79k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:40 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:53:40 localhost klogd: IMR 0x918414b4
Aug 19 22:53:40 localhost klogd: <>ath9k: new IMR 0x918414b4
Aug 19 22:53:40 localhost klogd: <errun interrupt
Aug 19 22:53:40 localhost klogd: eive FIFO overrun interrupt
Aug 19 22:53:40 localhost klogd: new IMR 0x918414b4
Aug 19 22:53:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:41 localhost klogd: enable IER
Aug 19 22:53:41 localhost klogd: transmitting packet, skb: ffff88008297a600
Aug 19 22:53:41 localhost klogd: transmitting packet, skb: ffff88005f99de00
Aug 19 22:53:41 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:41 localhost klogd: enable IER
Aug 19 22:53:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:41 localhost klogd: enable IER
Aug 19 22:53:41 localhost klogd: link[1] (ffff8800a4aafa90)=28 (ffff8800a4aafb28)
Aug 19 22:53:41 localhost klogd: enable IER
Aug 19 22:53:41 localhost klogd: link[1] (ffff8800a4ab0080)=18 (ffff8800a4ab0118)
Aug 19 22:53:41 localhost klogd: transmitting packet, skb: ffff8800a48c3700
Aug 19 22:53:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:41 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:41 localhost klogd: disable IER
Aug 19 22:53:41 localhost klogd: new IMR 0x0
Aug 19 22:53:42 localhost klogd: link[1] (ffff8800a4aa7ae8)=80 (ffff8800a4aa7b80)
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff8800a481f300
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff8800a4919900
Aug 19 22:53:42 localhost klogd: link[1] (ffff8800a4aab8a8)=40 (ffff8800a4aab940)
Aug 19 22:53:42 localhost klogd: disable IER
Aug 19 22:53:42 localhost klogd: enable IER
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: link[1] (ffff8800a4aad8b8)=50 (ffff8800a4aad950)
Aug 19 22:53:42 localhost klogd: h9k: disable IER
Aug 19 22:53:42 localhost klogd: link[1] (ffff8800a4aadc48)=e0 (ffff8800a4aadce0)
Aug 19 22:53:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:42 localhost klogd: h9k: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff8800a48a5800
Aug 19 22:53:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: <84de00
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff8800828d2800
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: disable IER
Aug 19 22:53:42 localhost klogd: new IMR 0x0
Aug 19 22:53:42 localhost klogd: ath9k: qnum: 1, txq depth: 2
Aug 19 22:53:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: link[1] (ffff8800a4aa1b50)=e8 (ffff8800a4aa1be8)
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: <7ete: skb: ffff8800a5ddf900
Aug 19 22:53:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff880089d49400
Aug 19 22:53:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff8800a4981600
Aug 19 22:53:42 localhost klogd: new IMR 0x0
Aug 19 22:53:42 localhost klogd: <7a4aa9b90), link ffff8800a4aa9b90
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:42 localhost klogd: new IMR 0x0
Aug 19 22:53:42 localhost klogd: <700a4aac8b0)=50 (ffff8800a4ab1250)
Aug 19 22:53:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:42 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:42 localhost klogd: transmitting packet, skb: ffff8800a1856300
Aug 19 22:53:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:42 localhost klogd: <th9k: new IMR 0x0
Aug 19 22:53:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:42 localhost klogd: enable IER
Aug 19 22:53:43 localhost klogd: <[1] (ffff8800a4aa0558)=f0 (ffff8800a4aa05f0)
Aug 19 22:53:43 localhost klogd: link[1] (ffff8800a4aa0688)=b8 (ffff8800a4aa07b8)
Aug 19 22:53:43 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:43 localhost klogd: <0x0
Aug 19 22:53:43 localhost klogd: new IMR 0x0
Aug 19 22:53:43 localhost klogd: link[1] (ffff8800a4aa3018)=b0 (ffff8800a4aa30b0)
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:43 localhost klogd: link[1] (ff>ath9k: enable IER
Aug 19 22:53:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:43 localhost klogd: disable IER
Aug 19 22:53:43 localhost klogd: transmitting packet, skb: ffff88005f837d00
Aug 19 22:53:43 localhost klogd: 0800
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:43 localhost klogd: isable IER
Aug 19 22:53:43 localhost klogd: link[1] (ffff8800a4aa83d0)=68 (ffff8800a4aa8468)
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: new IMR 0x0
Aug 19 22:53:43 localhost klogd: <7packet, skb: ffff8800a4939d00
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: h9k: enable IER
Aug 19 22:53:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:43 localhost klogd: <: new IMR 0x918414b4
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: transmitting packet, skb: ffff8800a5ddfb00
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:43 localhost klogd: new IMR 0x918414b4
Aug 19 22:53:43 localhost klogd: new IMR 0x0
Aug 19 22:53:43 localhost klogd: transmitting packet, skb: ffff88008485fa00
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:43 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:43 localhost klogd: link[1] (ffff8800a4aa4150)=e8 (ffff8800a4aa41e8)
Aug 19 22:53:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:43 localhost klogd: <7x queue 1 (a4aa77f0), link ffff8800a4aa77f0
Aug 19 22:53:43 localhost klogd: link[1] (ffff8800a4aa7ae8)=80 (ffff8800a4aa7b80)
Aug 19 22:53:43 localhost klogd: transmitting packet, skb: ffff8800a481f800
Aug 19 22:53:43 localhost klogd: <7<7>ath9k: 0xf4041071 => 0x0
Aug 19 22:53:43 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:43 localhost klogd: link[1] (ffff8800a4aabba0)=38 (ffff8800a4aabc38)
Aug 19 22:53:43 localhost klogd: transmitting packet, skb: ffff88008484d500
Aug 19 22:53:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:43 localhost klogd: <7omplete: skb: ffff8800a49c7200
Aug 19 22:53:43 localhost klogd: disable IER
Aug 19 22:53:43 localhost klogd: transmitting packet, skb: ffff8800a48b9000
Aug 19 22:53:43 localhost klogd: new IMR 0x0
Aug 19 22:53:44 localhost klogd: <7MR 0x918414b4 IER 0x1
Aug 19 22:53:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:44 localhost klogd: <7918414b4 IER 0x1
Aug 19 22:53:44 localhost klogd: link[1] (ffff8800a4ab0b30)=c8 (ffff8800a4ab0bc8)
Aug 19 22:53:44 localhost klogd: tx queue 1 (a4ab2d08), link ffff8800a4ab2d08
Aug 19 22:53:44 localhost klogd: h9k: new IMR 0x0
Aug 19 22:53:44 localhost klogd: enable IER
Aug 19 22:53:44 localhost klogd: <77>ath9k: enable IER
Aug 19 22:53:44 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:44 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:44 localhost klogd: link[1] (ffff8800a4aa3148)=e0 (ffff8800a4aa31e0)
Aug 19 22:53:44 localhost klogd: <771
Aug 19 22:53:44 localhost klogd: <9k: tx queue 1 (a4aa4740), link ffff8800a4aa4870
Aug 19 22:53:44 localhost klogd: <7 overrun interrupt
Aug 19 22:53:44 localhost klogd: <70x0
Aug 19 22:53:44 localhost klogd: <7: new0x0> 0xf4041071
Aug 19 22:53:44 localhost klogd: <e IER
Aug 19 22:53:44 localhost klogd: <18>ath9kceiinterrupt
Aug 19 22:53:44 localhost klogd: th9k: receive FIFO overrun interrupt
Aug 19 22:53:44 localhost klogd: new IMR 0x918414b4
Aug 19 22:53:44 localhost klogd: IMR 0x918414b4 IER 0x1
Aug 19 22:53:45 localhost klogd: <7h9k:le w IMR 0x0
Aug 19 22:53:45 localhost klogd: <7ath9k: 0x0 => 0xf4041071
Aug 19 22:53:45 localhost klogd: <7x0 => 0xf4041071
Aug 19 22:53:45 localhost klogd: <new IMR 0x918414b4
Aug 19 22:53:45 localhost klogd: <7k: th9k: new IMR 0x0
Aug 19 22:53:45 localhost klogd: <7 IER
Aug 19 22:53:45 localhost klogd: e FIFO overrun interrupt
Aug 19 22:53:45 localhost klogd: 
Aug 19 22:53:45 localhost klogd: <7ER
Aug 19 22:53:45 localhost klogd: <k: enable IER
Aug 19 22:53:45 localhost klogd: R 0x918414b4
Aug 19 22:53:45 localhost klogd: th9k: 0x0 => 0xf40410th9k:IMRth9k: enable IER
Aug 19 22:53:45 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:53:46 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:46 localhost klogd: transmitting packet, skb: ffff8800a4939b00
Aug 19 22:53:46 localhost klogd: transmitting packet, skb: ffff8800a4988800
Aug 19 22:53:46 localhost klogd: new IMR 0x918414b4
Aug 19 22:53:46 localhost klogd: link[1] (ffff8800a4aae368)=0 (ffff8800a4aae400)
Aug 19 22:53:46 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:47 localhost klogd: link[1] (ffff8800a4ab2da0)=38 (ffff8800a4ab2e38)
Aug 19 22:53:47 localhost klogd: transmitting packet, skb: ffff8800a185dc00
Aug 19 22:53:47 localhost klogd: new IMR 0x0
Aug 19 22:53:47 localhost klogd: transmitting packet, skb: ffff880089c78400
Aug 19 22:53:47 localhost klogd: transmitting packet, skb: ffff88005dcb5100
Aug 19 22:53:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:47 localhost klogd: disable IER
Aug 19 22:53:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:47 localhost klogd: tx queue 1 (a4aa9768), link ffff8800a4aa9768
Aug 19 22:53:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:47 localhost klogd: transmitting packet, skb: ffff8800a4815b00
Aug 19 22:53:47 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:47 localhost klogd: disable IER
Aug 19 22:53:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:47 localhost klogd: link[1] (ffff8800a4aad3f8)=90 (ffff8800a4aad490)
Aug 19 22:53:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:47 localhost klogd: new IMR 0x0
Aug 19 22:53:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:47 localhost klogd: new IMR 0x0
Aug 19 22:53:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:48 localhost klogd: transmitting packet, skb: ffff8800a5ca1000
Aug 19 22:53:50 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:50 localhost klogd: disable IER
Aug 19 22:53:53 localhost klogd: new IMR 0x0
Aug 19 22:53:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:53 localhost klogd: new IMR 0x0
Aug 19 22:53:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:53 localhost klogd: new IMR 0x0
Aug 19 22:53:53 localhost klogd: link[1] (ffff8800a4aa4610)=b8 (ffff8800a4aa53b8)
Aug 19 22:53:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:53 localhost klogd: new IMR 0x0
Aug 19 22:53:53 localhost klogd: transmitting packet, skb: ffff8800ad1f8200
Aug 19 22:53:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:53 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:53 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:54 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:54 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:54 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:54 localhost klogd: new IMR 0x0
Aug 19 22:53:54 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:54 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:54 localhost klogd: link[1] (ffff8800a4ab0968)=0 (ffff8800a4ab0a00)
Aug 19 22:53:54 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:54 localhost klogd: new IMR 0x918414b4
Aug 19 22:53:54 localhost klogd: enable IER
Aug 19 22:53:54 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:54 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:54 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:54 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:53:54 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:58 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:58 localhost klogd: enable IER
Aug 19 22:53:58 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:58 localhost klogd: enable IER
Aug 19 22:53:58 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:58 localhost klogd: transmitting packet, skb: ffff88008484de00
Aug 19 22:53:58 localhost klogd: enable IER
Aug 19 22:53:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:58 localhost klogd: new IMR 0x0
Aug 19 22:53:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:58 localhost klogd: transmitting packet, skb: ffff88005dde8200
Aug 19 22:53:58 localhost klogd: disable IER
Aug 19 22:53:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:58 localhost klogd: transmitting packet, skb: ffff8800a5d12200
Aug 19 22:53:58 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:53:58 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:58 localhost klogd: link[1] (ffff8800a4aa8de8)=80 (ffff8800a4aa8e80)
Aug 19 22:53:58 localhost klogd: tx queue 1 (a4aa9048), link ffff8800a4aa9048
Aug 19 22:53:58 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:53:58 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:58 localhost klogd: new IMR 0x0
Aug 19 22:53:58 localhost klogd: transmitting packet, skb: ffff8800a48a5100
Aug 19 22:53:58 localhost klogd: tx queue 1 (a4aac5b8), link ffff8800a4aac5b8
Aug 19 22:53:58 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:58 localhost klogd: link[1] (ffff8800a4aad528)=c0 (ffff8800a4aad5c0)
Aug 19 22:53:58 localhost klogd: new IMR 0x0
Aug 19 22:53:59 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:53:59 localhost klogd: link[1] (ffff8800a4aae1a0)=38 (ffff8800a4aae238)
Aug 19 22:53:59 localhost klogd: new IMR 0x0
Aug 19 22:53:59 localhost klogd: link[1] (ffff8800a4aae828)=c0 (ffff8800a4aae8c0)
Aug 19 22:53:59 localhost klogd: transmitting packet, skb: ffff880069c0f700
Aug 19 22:53:59 localhost klogd: tx queue 1 (a4aaf668), link ffff8800a4aaf668
Aug 19 22:53:59 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:59 localhost klogd: link[1] (ffff8800a4aafcf0)=88 (ffff8800a4aafd88)
Aug 19 22:53:59 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:53:59 localhost klogd: new IMR 0x0
Aug 19 22:53:59 localhost klogd: Enable TXE on queue: 1
Aug 19 22:53:59 localhost klogd: new IMR 0x0
Aug 19 22:53:59 localhost klogd: tx queue 1 (a4ab2128), link ffff8800a4ab2128
Aug 19 22:53:59 localhost klogd: <79k: 
Aug 19 22:53:59 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:53:59 localhost klogd: <7 => 0xf4041071
Aug 19 22:53:59 localhost klogd: <7 => 0xf4041071
Aug 19 22:53:59 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:00 localhost klogd: <77>ath9k: new IMR 0x918414b4
Aug 19 22:54:00 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:00 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:54:01 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff8800a5d12400
Aug 19 22:54:03 localhost klogd: enable IER
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff88008d5cc000
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:54:03 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:03 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:03 localhost klogd: link[1] (ffff8800a4aa5ad8)=70 (ffff8800a4aa5b70)
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff88009b8def00
Aug 19 22:54:03 localhost klogd: disable IER
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:03 localhost klogd: link[1] (ffff8800a4aa6290)=28 (ffff8800a4aa6328)
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff8800a4805100
Aug 19 22:54:03 localhost klogd: link[1] (ffff8800a4aa8040)=d8 (ffff8800a4aa80d8)
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff8800a480f000
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff88005dde7c00
Aug 19 22:54:03 localhost klogd: new IMR 0x0
Aug 19 22:54:03 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:03 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:03 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff880084996f00
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:03 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:03 localhost klogd: transmitting packet, skb: ffff88008485fa00
Aug 19 22:54:03 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:03 localhost klogd: disable IER
Aug 19 22:54:03 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:03 localhost klogd: new IMR 0x0
Aug 19 22:54:04 localhost klogd: tx queue 1 (a4ab1e30), link ffff8800a4ab1e30
Aug 19 22:54:04 localhost klogd: link[1] (ffff8800a4ab24b8)=50 (ffff8800a4ab2550)
Aug 19 22:54:04 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:04 localhost klogd: disable IER
Aug 19 22:54:04 localhost klogd: tx queue 1 (a4ab31c8), link ffff8800a4ab31c8
Aug 19 22:54:04 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:04 localhost klogd: new IMR 0x0
Aug 19 22:54:04 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:04 localhost klogd: link[1] (ffff8800a4aa0e40)=d8 (ffff8800a4aa0ed8)
Aug 19 22:54:04 localhost klogd: transmitting packet, skb: ffff8800af42ee00
Aug 19 22:54:04 localhost klogd: tx queue 1 (a4aa15f8), link ffff8800a4aa15f8
Aug 19 22:54:04 localhost klogd: enable IER
Aug 19 22:54:04 localhost klogd: new IMR 0x0
Aug 19 22:54:04 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:54:04 localhost klogd:  IER
Aug 19 22:54:04 localhost klogd: <7FO overrun interrupt
Aug 19 22:54:05 localhost klogd: enable IER
Aug 19 22:54:05 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:05 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:05 localhost klogd: disable IER
Aug 19 22:54:05 localhost klogd: disable IER
Aug 19 22:54:06 localhost klogd: MR 0x918414b4 IER 0x1
Aug 19 22:54:06 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:08 localhost klogd: enable IER
Aug 19 22:54:08 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:08 localhost klogd: enable IER
Aug 19 22:54:08 localhost klogd: transmitting packet, skb: ffff88008485f900
Aug 19 22:54:08 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:08 localhost klogd: transmitting packet, skb: ffff88009d6bcb00
Aug 19 22:54:08 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:08 localhost klogd: disable IER
Aug 19 22:54:08 localhost klogd: transmitting packet, skb: ffff8800a48c3c00
Aug 19 22:54:08 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:08 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:08 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:08 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:08 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:08 localhost klogd: tx queue 1 (a4aad8b8), link ffff8800a4aad8b8
Aug 19 22:54:08 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:08 localhost klogd: disable IER
Aug 19 22:54:09 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:09 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:09 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:09 localhost klogd: disable IER
Aug 19 22:54:09 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:09 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:09 localhost klogd: transmitting packet, skb: ffff8800a4982800
Aug 19 22:54:09 localhost klogd: transmitting packet, skb: ffff88005dcb5f00
Aug 19 22:54:09 localhost klogd: new IMR 0x0
Aug 19 22:54:09 localhost klogd: new IMR 0x0
Aug 19 22:54:09 localhost klogd: <7receive FIFO overrun interrupt
Aug 19 22:54:10 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:10 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:10 localhost klogd: enable IER
Aug 19 22:54:10 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:13 localhost klogd: link[1] (ffff8800a4aa05f0)=88 (ffff8800a4aa0688)
Aug 19 22:54:13 localhost klogd: enable IER
Aug 19 22:54:13 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:13 localhost klogd: enable IER
Aug 19 22:54:15 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:21 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:54:23 localhost klogd: transmitting packet, skb: ffff88005dcb5900
Aug 19 22:54:23 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:23 localhost klogd: transmitting packet, skb: ffff8800a4981f00
Aug 19 22:54:23 localhost klogd: new IMR 0x0
Aug 19 22:54:23 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:24 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:25 localhost klogd: enable IER
Aug 19 22:54:25 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:25 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:54:25 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:25 localhost klogd: tx queue 1 (a4aa5878), link ffff8800a4aa5910
Aug 19 22:54:26 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:26 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:26 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:26 localhost klogd: link[1] (ffff8800a4aa79b8)=50 (ffff8800a4aa7a50)
Aug 19 22:54:26 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff880089d49400
Aug 19 22:54:26 localhost klogd: enable IER
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: tx queue 1 (a4aa92a8), link ffff8800a4aa92a8
Aug 19 22:54:26 localhost klogd: enable IER
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff880069c0f300
Aug 19 22:54:26 localhost klogd: disable IER
Aug 19 22:54:26 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff8800b9147b00
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff880089d44100
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff8800af0b7c00
Aug 19 22:54:26 localhost klogd: tx queue 1 (a4aade10), link ffff8800a4aade10
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff8800a4983b00
Aug 19 22:54:26 localhost klogd: transmitting packet, skb: ffff88006e03a600
Aug 19 22:54:26 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:26 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: enable IER
Aug 19 22:54:27 localhost klogd: tx queue 1 (a4ab0080), link ffff8800a4ab0080
Aug 19 22:54:27 localhost klogd: tx queue 1 (a4ab0a98), link ffff8800a4ab0a98
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:27 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff8800a1a29b00
Aug 19 22:54:27 localhost klogd: link[1] (ffff8800a4aa0720)=18 (ffff8800a4aa0a18)
Aug 19 22:54:27 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff880084920900
Aug 19 22:54:27 localhost klogd: link[1] (ffff8800a4aa1d18)=b0 (ffff8800a4aa1db0)
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff880089c78c00
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff880084920200
Aug 19 22:54:27 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff88008285c500
Aug 19 22:54:27 localhost klogd: link[1] (ffff8800a4aa2990)=28 (ffff8800a4aa2a28)
Aug 19 22:54:27 localhost klogd: tx queue 1 (a4aa2bf0), link ffff8800a4aa2bf0
Aug 19 22:54:27 localhost klogd: tx queue 1 (a4aa2e50), link ffff8800a4aa2e50
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff880069c0fa00
Aug 19 22:54:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:27 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: enable IER
Aug 19 22:54:27 localhost klogd: new IMR 0x0
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff8800828fd800
Aug 19 22:54:27 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: enable IER
Aug 19 22:54:27 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff88005dde7000
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: transmitting packet, skb: ffff8800a48e0600
Aug 19 22:54:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: enable IER
Aug 19 22:54:27 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:27 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:27 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:27 localhost klogd: link[1] (ffff8800a4aae9f0)=88 (ffff8800a4aaea88)
Aug 19 22:54:28 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:28 localhost klogd: tx queue 1 (a4ab1120), link ffff8800a4ab1120
Aug 19 22:54:28 localhost klogd: disable IER
Aug 19 22:54:28 localhost klogd: link[1] (ffff8800a4ab1970)=8 (ffff8800a4ab1a08)
Aug 19 22:54:28 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a4838000
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a493ae00
Aug 19 22:54:28 localhost klogd: new IMR 0x0
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff880089c78700
Aug 19 22:54:28 localhost klogd: tx queue 1 (a4aa0558), link ffff8800a4aa0558
Aug 19 22:54:28 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:28 localhost klogd: enable IER
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a4805e00
Aug 19 22:54:28 localhost klogd: new IMR 0x0
Aug 19 22:54:28 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:28 localhost klogd: tx queue 1 (a4aa3bf8), link ffff8800a4aa3bf8
Aug 19 22:54:28 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:28 localhost klogd: tx queue 1 (a4aa60c8), link ffff8800a4aa60c8
Aug 19 22:54:28 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:28 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:28 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:28 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:28 localhost klogd: link[1] (ffff8800a4aa9800)=98 (ffff8800a4aa9898)
Aug 19 22:54:28 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a5ca1b00
Aug 19 22:54:28 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a4983700
Aug 19 22:54:28 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:28 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:28 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a4988d00
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff8800a954df00
Aug 19 22:54:28 localhost klogd: transmitting packet, skb: ffff88006e03ae00
Aug 19 22:54:28 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:28 localhost klogd: link[1] (ffff8800a4aad788)=20 (ffff8800a4aad820)
Aug 19 22:54:28 localhost klogd: link[1] (ffff8800a4aadb18)=b0 (ffff8800a4aadbb0)
Aug 19 22:54:28 localhost klogd: enable IER
Aug 19 22:54:28 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:28 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:29 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:29 localhost klogd: transmitting packet, skb: ffff8800af598000
Aug 19 22:54:29 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:29 localhost klogd: transmitting packet, skb: ffff8800a493ad00
Aug 19 22:54:29 localhost klogd: link[1] (ffff8800a4ab2e38)=d0 (ffff8800a4ab2ed0)
Aug 19 22:54:29 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:29 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:29 localhost klogd: link[1] (ffff8800a4aa0e40)=d8 (ffff8800a4aa0ed8)
Aug 19 22:54:29 localhost klogd: transmitting packet, skb: ffff8800828fdb00
Aug 19 22:54:29 localhost klogd: tx queue 1 (a4aa1d18), link ffff8800a4aa1d18
Aug 19 22:54:29 localhost klogd: enable IER
Aug 19 22:54:29 localhost klogd: <7 1 (a4aa5320), link ffff8800a4aa5320
Aug 19 22:54:29 localhost klogd:  0xf4041071
Aug 19 22:54:29 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:29 localhost klogd: transmitting packet, skb: ffff8800a185d900
Aug 19 22:54:29 localhost klogd: ath9k: 0xf4041071 => 0x0
Aug 19 22:54:29 localhost klogd: rrupt
Aug 19 22:54:29 localhost klogd: <7th9k: receive FIFO overrun interrupt
Aug 19 22:54:29 localhost klogd: <7: disable IER
Aug 19 22:54:29 localhost klogd: <ath9k: receive FIFO overrun interath9k: 0xf4041071 => 0x0
Aug 19 22:54:29 localhost klogd: <714b4
Aug 19 22:54:29 localhost klogd: <7x0 => 0xf4041071
Aug 19 22:54:29 localhost klogd: : A4 IE<7>ceive FIFO overrun interrupt
Aug 19 22:54:29 localhost klogd: <7k: new IMR 0x918414b4
Aug 19 22:54:29 localhost klogd: IMR 0x918414b4 IER 0x1
Aug 19 22:54:29 localhost klogd: <7
Aug 19 22:54:30 localhost klogd: FO overrun interrupt
Aug 19 22:54:30 localhost klogd: < receive FIFO overrun interrupt
Aug 19 22:54:30 localhost klogd: R 0x0
Aug 19 22:54:30 localhost klogd: <7AR_IM184ath9k: receive FIFO overrun interrupt
Aug 19 22:54:30 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:54:31 localhost klogd: TX complete: skb: ffff88005dde7400
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff880089d44500
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:31 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:31 localhost klogd: link[1] (ffff8800a4aa8500)=98 (ffff8800a4aa8598)
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff8800a5d12700
Aug 19 22:54:31 localhost klogd: enable IER
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff8800a5ca1f00
Aug 19 22:54:31 localhost klogd: enable IER
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff880084996f00
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff8800a480fd00
Aug 19 22:54:31 localhost klogd: TX complete: skb: ffff8800a480fd00
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff8800a1856000
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff8800a4815d00
Aug 19 22:54:31 localhost klogd: new IMR 0x0
Aug 19 22:54:31 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:31 localhost klogd: tx queue 1 (a4aa96d0), link ffff8800a4aa96d0
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:31 localhost klogd: link[1] (ffff8800a4aaa180)=18 (ffff8800a4aaa218)
Aug 19 22:54:31 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:31 localhost klogd: link[1] (ffff8800a4aabcd0)=68 (ffff8800a4aabd68)
Aug 19 22:54:31 localhost klogd: link[1] (ffff8800a4aaccd8)=70 (ffff8800a4aacd70)
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:31 localhost klogd: link[1] (ffff8800a4aae108)=a0 (ffff8800a4aae1a0)
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff8800a5ca1f00
Aug 19 22:54:31 localhost klogd: transmitting packet, skb: ffff880084920000
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:31 localhost klogd: enable IER
Aug 19 22:54:31 localhost klogd: new IMR 0x0
Aug 19 22:54:31 localhost klogd: link[1] (ffff8800a4ab2848)=e8 (ffff8800a4ab12e8)
Aug 19 22:54:31 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:31 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:31 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: new IMR 0x0
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4aa11d0)=68 (ffff8800a4aa1268)
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff8800a954d600
Aug 19 22:54:32 localhost klogd: new IMR 0x0
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff880089d49900
Aug 19 22:54:32 localhost klogd: enable IER
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff8800a4805b00
Aug 19 22:54:32 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:32 localhost klogd: new IMR 0x0
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: enable IER
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4aa7460)=f8 (ffff8800a4aa74f8)
Aug 19 22:54:32 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:32 localhost klogd: tx queue 1 (a4aa7758), link ffff8800a4aa7758
Aug 19 22:54:32 localhost klogd: tx queue 1 (a4aa7e78), link ffff8800a4aa7e78
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff880084920d00
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff88006e03a000
Aug 19 22:54:32 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:32 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4aa8e80)=18 (ffff8800a4aa8f18)
Aug 19 22:54:32 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:32 localhost klogd: new IMR 0x0
Aug 19 22:54:32 localhost klogd: enable IER
Aug 19 22:54:32 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff8800a4982200
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: enable IER
Aug 19 22:54:32 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:32 localhost klogd: disable IER
Aug 19 22:54:32 localhost klogd: enable IER
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: disable IER
Aug 19 22:54:32 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4aac2c0)=58 (ffff8800a4aac358)
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:32 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:32 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: enable IER
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff8800ad1f8200
Aug 19 22:54:32 localhost klogd: new IMR 0x0
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4ab01b0)=48 (ffff8800a4ab0248)
Aug 19 22:54:32 localhost klogd: disable IER
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: transmitting packet, skb: ffff88009d6bc500
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4ab1840)=d8 (ffff8800a4ab18d8)
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: tx queue 1 (a4ab22f0), link ffff8800a4ab22f0
Aug 19 22:54:32 localhost klogd: tx queue 1 (a4ab25e8), link ffff8800a4ab25e8
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4ab2ed0)=68 (ffff8800a4ab2f68)
Aug 19 22:54:32 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:32 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:32 localhost klogd: link[1] (ffff8800a4ab3390)=28 (ffff8800a4ab3428)
Aug 19 22:54:33 localhost klogd: link[1] (ffff8800a4aa0f70)=8 (ffff8800a4aa1008)
Aug 19 22:54:34 localhost klogd: enable IER
Aug 19 22:54:34 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:35 localhost klogd: enable IER
Aug 19 22:54:35 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:35 localhost klogd: enable IER
Aug 19 22:54:36 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:36 localhost klogd: transmitting packet, skb: ffff8800a5ca1400
Aug 19 22:54:36 localhost klogd: new IMR 0x0
Aug 19 22:54:36 localhost klogd: transmitting packet, skb: ffff88005dcb5c00
Aug 19 22:54:36 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:36 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:36 localhost klogd: enable IER
Aug 19 22:54:36 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:36 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:36 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:36 localhost klogd: disable IER
Aug 19 22:54:36 localhost klogd: disable IER
Aug 19 22:54:36 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:36 localhost klogd: link[1] (ffff8800a4aadc48)=e0 (ffff8800a4aadce0)
Aug 19 22:54:36 localhost klogd: new IMR 0x0
Aug 19 22:54:36 localhost klogd: new IMR 0x0
Aug 19 22:54:36 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:37 localhost klogd: link[1] (ffff8800a4ab1ec8)=60 (ffff8800a4ab1f60)
Aug 19 22:54:37 localhost klogd: disable IER
Aug 19 22:54:37 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800a48c3e00
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800a4815300
Aug 19 22:54:37 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:37 localhost klogd: TX complete: skb: ffff8800a957a300
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800a954db00
Aug 19 22:54:37 localhost klogd: link[1] (ffff8800a4aa3c90)=28 (ffff8800a4aa3d28)
Aug 19 22:54:37 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800a954d900
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800849a9900
Aug 19 22:54:37 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:37 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: disable IER
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: disable IER
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:37 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff88005dde8e00
Aug 19 22:54:37 localhost klogd: tx queue 1 (a4aaed80), link ffff8800a4aaed80
Aug 19 22:54:37 localhost klogd: disable IER
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:37 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800a5d12600
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:37 localhost klogd: transmitting packet, skb: ffff8800a48a4200
Aug 19 22:54:37 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff8800a4981200
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff88008d5cca00
Aug 19 22:54:38 localhost klogd: tx queue 1 (a4aa18f0), link ffff8800a4aa18f0
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff880082959000
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa2730)=c8 (ffff8800a4aa27c8)
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff8800a5cd2500
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff8800a185d000
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa4280)=18 (ffff8800a4aa4318)
Aug 19 22:54:38 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff8800a5d12500
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa4a38)=d0 (ffff8800a4aa4ad0)
Aug 19 22:54:38 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:38 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:38 localhost klogd: disable IER
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa7a50)=e8 (ffff8800a4aa7ae8)
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa8468)=0 (ffff8800a4aa8500)
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff8800a185d400
Aug 19 22:54:38 localhost klogd: tx queue 1 (a4aaab98), link ffff8800a4aaab98
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:38 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aaebb8)=50 (ffff8800a4aaec50)
Aug 19 22:54:38 localhost klogd: disable IER
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff880084920100
Aug 19 22:54:38 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa20a8)=40 (ffff8800a4aa2140)
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: link[1] (ffff8800a4aa47d8)=70 (ffff8800a4aa4870)
Aug 19 22:54:38 localhost klogd: new IMR 0x0
Aug 19 22:54:38 localhost klogd: transmitting packet, skb: ffff8800828d2700
Aug 19 22:54:38 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:54:38 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:39 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:39 localhost klogd: tx queue 1 (a4aa8f18), link ffff8800a4aa8f18
Aug 19 22:54:39 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: new IMR 0x0
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff8800a48e0000
Aug 19 22:54:39 localhost klogd: enable IER
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff880086d14800
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: tx queue 1 (a4aaf4a0), link ffff8800a4aaf4a0
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff8800a1856200
Aug 19 22:54:39 localhost klogd: enable IER
Aug 19 22:54:39 localhost klogd: ab02e0)
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff88005f837000
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff8800a2c0db00
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: new IMR 0x0
Aug 19 22:54:39 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 7
Aug 19 22:54:39 localhost klogd: enable IER
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:39 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:39 localhost klogd: link[1] (ffff8800a4aa6ca8)=40 (ffff8800a4aa6d40)
Aug 19 22:54:39 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:39 localhost klogd: new IMR 0x0
Aug 19 22:54:39 localhost klogd: new IMR 0x0
Aug 19 22:54:39 localhost klogd: disable IER
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff88009d567300
Aug 19 22:54:39 localhost klogd: new IMR 0x0
Aug 19 22:54:39 localhost klogd: transmitting packet, skb: ffff8800a957a700
Aug 19 22:54:39 localhost klogd: tx queue 1 (a4aab2b8), link ffff8800a4aab2b8
Aug 19 22:54:39 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: tx queue 1 (a4aac650), link ffff8800a4aac650
Aug 19 22:54:39 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:39 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:39 localhost klogd: link[1] (ffff8800a4aad788)=20 (ffff8800a4aad820)
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:40 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:40 localhost klogd: disable IER
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff8800a5c73500
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff8800a480f300
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff880089c78e00
Aug 19 22:54:40 localhost klogd: TX complete: skb: ffff880089c78e00
Aug 19 22:54:40 localhost klogd: tx queue 1 (a4ab11b8), link ffff8800a4ab11b8
Aug 19 22:54:40 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:40 localhost klogd: disable IER
Aug 19 22:54:40 localhost klogd: link[1] (ffff8800a4ab3558)=f0 (ffff8800a4ab35f0)
Aug 19 22:54:40 localhost klogd: link[1] (ffff8800a4aa01c8)=60 (ffff8800a4aa0260)
Aug 19 22:54:40 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff8800a2c24500
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: fff8800a4aa34d8
Aug 19 22:54:40 localhost klogd: disable IER
Aug 19 22:54:40 localhost klogd: link[1] (ffff8800a4aa3998)=30 (ffff8800a4aa3a30)
Aug 19 22:54:40 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff8800af42e100
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:40 localhost klogd: link[1] (ffff8800a4aa50c0)=58 (ffff8800a4aa5158)
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:40 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:40 localhost klogd: <7h: 2
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff880086d14a00
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:40 localhost klogd: <(ffff8800a4aa8>ath9k: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:40 localhost klogd:  IMR 0x918414b4
Aug 19 22:54:40 localhost klogd: tx queue 1 (a4aac780), link ffff8800a4aac780
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: disable IER
Aug 19 22:54:40 localhost klogd: TX complete: skb: ffff880089c78900
Aug 19 22:54:40 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:40 localhost klogd: tx queue 1 (a4aae238), link ffff8800a4aae238
Aug 19 22:54:40 localhost klogd: <9k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:40 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:40 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:40 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:54:40 localhost klogd: <7ff8800a48caf00
Aug 19 22:54:40 localhost klogd: disable IER
Aug 19 22:54:40 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:40 localhost klogd: 4b4
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:40 localhost klogd: transmitting packet, skb: ffff880089d44a00
Aug 19 22:54:40 localhost klogd: new IMR 0x0
Aug 19 22:54:41 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:41 localhost klogd: transmitting packet, skb: ffff8800a185d800
Aug 19 22:54:41 localhost klogd: transmitting packet, skb: ffff88009d56cc00
Aug 19 22:54:41 localhost klogd: <70 => 0xf4041071
Aug 19 22:54:41 localhost klogd: transmitting packet, skb: ffff88006e03a700
Aug 19 22:54:41 localhost klogd: enable IER
Aug 19 22:54:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:41 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:41 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:41 localhost klogd: link[1] (ffff8800a4aa9b90)=28 (ffff8800a4aa9c28)
Aug 19 22:54:41 localhost klogd: enable IER
Aug 19 22:54:41 localhost klogd: new IMR 0x0
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:41 localhost klogd: transmitting packet, skb: ffff8800a4983700
Aug 19 22:54:41 localhost klogd: tx queue 1 (a4aaeeb0), link ffff8800a4aaeeb0
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:41 localhost klogd: omplete: skb: ffff880084920e00
Aug 19 22:54:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:41 localhost klogd: link[1] (ffff8800a4aa0390)=28 (ffff8800a4aa0428)
Aug 19 22:54:41 localhost klogd: new IMR 0x0
Aug 19 22:54:41 localhost klogd: <4ew IMR 0x918414b4
Aug 19 22:54:41 localhost klogd: link[1] (ffff8800a4aa1430)=c8 (ffff8800a4aa14c8)
Aug 19 22:54:41 localhost klogd: disable IER
Aug 19 22:54:41 localhost klogd: TX complete: skb: ffff8800a48c3c00
Aug 19 22:54:41 localhost klogd: 0xf4041071
Aug 19 22:54:41 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:41 localhost klogd: link[1] (ffff8800a4aa3998)=30 (ffff8800a4aa3a30)
Aug 19 22:54:41 localhost klogd: transmitting packet, skb: ffff8800a5d12500
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:41 localhost klogd: transmitting packet, skb: ffff8800a9559900
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:41 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:41 localhost klogd: <788008285d400
Aug 19 22:54:41 localhost klogd: <7x1
Aug 19 22:54:41 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:41 localhost klogd: new IMR 0x0
Aug 19 22:54:41 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:41 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:41 localhost klogd: new IMR 0x0
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: transmitting packet, skb: ffff8800a9559100
Aug 19 22:54:42 localhost klogd: new IMR 0x0
Aug 19 22:54:42 localhost klogd: enable IER
Aug 19 22:54:42 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:42 localhost klogd: <9k: disable IER
Aug 19 22:54:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:42 localhost klogd: tx queue 1 (a4aa1be8), link ffff8800a4aa1be8
Aug 19 22:54:42 localhost klogd: new IMR 0x0
Aug 19 22:54:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:42 localhost klogd: new IMR 0x0
Aug 19 22:54:42 localhost klogd: transmitting packet, skb: ffff88008485fa00
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: transmitting packet, skb: ffff880089d49600
Aug 19 22:54:42 localhost klogd: tx queue 1 (a4aa37d0), link ffff8800a4aa37d0
Aug 19 22:54:42 localhost klogd: enable IER
Aug 19 22:54:42 localhost klogd: <70
Aug 19 22:54:42 localhost klogd: link[1] (ffff8800a4aa61f8)=90 (ffff8800a4aa6290)
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: transmitting packet, skb: ffff880084920100
Aug 19 22:54:42 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:54:42 localhost klogd: <7m: 1, txq depth: 3
Aug 19 22:54:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: <a9df0)=88 (ffff8800a4aa9e88)
Aug 19 22:54:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:42 localhost klogd: 9k: tx queue 1 (a4aab220), link ffff8800a4aab220
Aug 19 22:54:42 localhost klogd: new IMR 0x0
Aug 19 22:54:42 localhost klogd: transmitting packet, skb: ffff8800af42e700
Aug 19 22:54:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:42 localhost klogd: disable IER
Aug 19 22:54:42 localhost klogd: tx queue 1 (a4aaebb8), link ffff8800a4aaebb8
Aug 19 22:54:42 localhost klogd: <h9k: new IMR 0x0
Aug 19 22:54:42 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:42 localhost klogd: link[1] (ffff8800a4ab0248)=e0 (ffff8800a4ab02e0)
Aug 19 22:54:42 localhost klogd: tx queue 1 (a4ab0a00), link ffff8800a4ab0a00
Aug 19 22:54:42 localhost klogd: transmitting packet, skb: ffff8800a481eb00
Aug 19 22:54:42 localhost klogd: <2550), link ffff8800a4ab25e8
Aug 19 22:54:42 localhost klogd: disable IER
Aug 19 22:54:42 localhost klogd: x0
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: le TXE on queue: 1
Aug 19 22:54:42 localhost klogd: TX complete: skb: ffff8800a48caf00
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: <7h9k: disable IER
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: nable IER
Aug 19 22:54:42 localhost klogd: link[1] (ffff8800a4aa5878)=10 (ffff8800a4aa5910)
Aug 19 22:54:42 localhost klogd: <74f0
Aug 19 22:54:42 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:42 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:42 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:42 localhost klogd: tx queue 1 (a4aa7888), link ffff8800a4aa7888
Aug 19 22:54:42 localhost klogd: new IMR 0x0
Aug 19 22:54:42 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:42 localhost klogd: disable IER
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff880082959f00
Aug 19 22:54:43 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:43 localhost klogd: tx queue 1 (a4aa9898), link ffff8800a4aa9898
Aug 19 22:54:43 localhost klogd: disable IER
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:43 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:43 localhost klogd: link[1] (ffff8800a4aaaf28)=58 (ffff8800a4aab058)
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff8800a48b9100
Aug 19 22:54:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff8800a4982800
Aug 19 22:54:43 localhost klogd: link[1] (ffff8800a4aaf2d8)=70 (ffff8800a4aaf370)
Aug 19 22:54:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff8800828fda00
Aug 19 22:54:43 localhost klogd: tx queue 1 (a4ab1840), link ffff8800a4ab1840
Aug 19 22:54:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:43 localhost klogd: <7 ffff8800af598400
Aug 19 22:54:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff88009d567500
Aug 19 22:54:43 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:43 localhost klogd: enable IER
Aug 19 22:54:43 localhost klogd: <7depth: 1
Aug 19 22:54:43 localhost klogd:  queue: 1
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff8800a493a900
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: link[1] (ffff8800a4aa4d30)=c8 (ffff8800a4aa4dc8)
Aug 19 22:54:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:43 localhost klogd: link[1] (ffff8800a4aa67e8)=80 (ffff8800a4aa6880)
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:43 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:43 localhost klogd: TX complete: skb: ffff8800a957a300
Aug 19 22:54:43 localhost klogd: qnum: 1, txq depth: 7
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff88008285c200
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff88008297a400
Aug 19 22:54:43 localhost klogd: enable IER
Aug 19 22:54:43 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:43 localhost klogd: <70
Aug 19 22:54:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:43 localhost klogd: <7th9
Aug 19 22:54:43 localhost klogd: transmitting packet, skb: ffff8800a48cac00
Aug 19 22:54:43 localhost klogd: new IMR 0x0
Aug 19 22:54:43 localhost klogd: tx queue 1 (a4ab1f60), link ffff8800a4ab1f60
Aug 19 22:54:43 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:43 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:43 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:43 localhost klogd: tx queue 1 (a4aa0000), link ffff8800a4aa0000
Aug 19 22:54:44 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:44 localhost klogd: k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:44 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:44 localhost klogd: tx queue 1 (a4aa2140), link ffff8800a4aa2140
Aug 19 22:54:44 localhost klogd: transmitting packet, skb: ffff8800a4939600
Aug 19 22:54:44 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:44 localhost klogd: transmitting packet, skb: ffff880089d44800
Aug 19 22:54:44 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:44 localhost klogd: enable IER
Aug 19 22:54:44 localhost klogd: disable IER
Aug 19 22:54:44 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:44 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:44 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:44 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:44 localhost klogd: link[1] (ffff8800a4aab9d8)=70 (ffff8800a4aaba70)
Aug 19 22:54:44 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:44 localhost klogd: transmitting packet, skb: ffff8800b9198a00
Aug 19 22:54:44 localhost klogd:  disable IER
Aug 19 22:54:44 localhost klogd: 1
Aug 19 22:54:44 localhost klogd: <7<7>ath9k: receive FIFO overrun interrupt
Aug 19 22:54:44 localhost klogd: <ath9k: new IMR 0x918414b4
Aug 19 22:54:44 localhost klogd: 9k:x0
Aug 19 22:54:44 localhost klogd: <0x918414b4 IER 0x1
Aug 19 22:54:44 localhost klogd: <70x0
Aug 19 22:54:45 localhost klogd: k: new IMR 0x918414b4
Aug 19 22:54:45 localhost klogd: <w IMR 0x918414b4
Aug 19 22:54:45 localhost klogd: <7ath9k: 0x0 => 0xf4041071
Aug 19 22:54:45 localhost klogd: < new IMR 0x918414b4
Aug 19 22:54:45 localhost klogd:  0x918414b4 IER 0x1
Aug 19 22:54:45 localhost klogd: <7th9k: new IMR 0x0
Aug 19 22:54:45 localhost klogd: <9k:>ath0 =ath9k: new IMR 0x918414b4
Aug 19 22:54:45 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:54:46 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:54:46 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:54:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:46 localhost klogd: transmitting packet, skb: ffff880089d49b00
Aug 19 22:54:46 localhost klogd: transmitting packet, skb: ffff8800a4815800
Aug 19 22:54:46 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:46 localhost klogd: qnum: 1, txq depth: 6
Aug 19 22:54:46 localhost klogd: disable IER
Aug 19 22:54:46 localhost klogd: disable IER
Aug 19 22:54:46 localhost klogd: new IMR 0x0
Aug 19 22:54:46 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:46 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:46 localhost klogd: transmitting packet, skb: ffff8800a49c7600
Aug 19 22:54:46 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:46 localhost klogd: new IMR 0x0
Aug 19 22:54:47 localhost klogd: transmitting packet, skb: ffff8800a4874700
Aug 19 22:54:47 localhost klogd: enable IER
Aug 19 22:54:47 localhost klogd: transmitting packet, skb: ffff88006e03a000
Aug 19 22:54:47 localhost klogd: new IMR 0x0
Aug 19 22:54:47 localhost klogd: enable IER
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:47 localhost klogd: link[1] (ffff8800a4aaa8a0)=38 (ffff8800a4aaa938)
Aug 19 22:54:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:47 localhost klogd: link[1] (ffff8800a4aa87f8)=20 (ffff8800a4aab220)
Aug 19 22:54:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:47 localhost klogd: disable IER
Aug 19 22:54:47 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:47 localhost klogd: new IMR 0x0
Aug 19 22:54:47 localhost klogd: new IMR 0x0
Aug 19 22:54:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:47 localhost klogd: link[1] (ffff8800a4ab1b38)=d0 (ffff8800a4ab1bd0)
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth:MR 0x918414b4 IER 0x1
Aug 19 22:54:47 localhost klogd: transmitting packet, skb: ffff88008285ce00
Aug 19 22:54:47 localhost klogd: new IMR 0x0
Aug 19 22:54:47 localhost klogd: link[1] (ffff8800a4aa1d18)=b0 (ffff8800a4aa1db0)
Aug 19 22:54:47 localhost klogd: transmitting packet, skb: ffff8800a4874700
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:47 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:47 localhost klogd: disable IER
Aug 19 22:54:47 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:47 localhost klogd: tx queue 1 (a4aa5b70), link ffff8800a4aa5b70
Aug 19 22:54:47 localhost klogd: new IMR 0x0
Aug 19 22:54:47 localhost klogd: tx queue 1 (a4aa66b8), link ffff8800a4aa66b8
Aug 19 22:54:47 localhost klogd: TX complete: skb: ffff8800828d2600
Aug 19 22:54:47 localhost klogd: qnum: 1, txq depth: 4
Aug 19 22:54:48 localhost klogd: new IMR 0x0
Aug 19 22:54:48 localhost klogd: TX complete: skb: ffff8800a2c24100
Aug 19 22:54:48 localhost klogd: transmitting packet, skb: ffff8800a48c3500
Aug 19 22:54:48 localhost klogd: qnum: 1, txq depth: 1
Aug 19 22:54:48 localhost klogd: link[1] (ffff8800a4aac3f0)=88 (ffff8800a4aac488)
Aug 19 22:54:48 localhost klogd: link[1] (ffff8800a4aac520)=b8 (ffff8800a4aac5b8)
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:48 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:48 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:48 localhost klogd: transmitting packet, skb: ffff88005f837a00
Aug 19 22:54:48 localhost klogd: enable IER
Aug 19 22:54:48 localhost klogd: tx queue 1 (a4ab0e28), link ffff8800a4ab0e28
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: transmitting packet, skb: ffff8800a954d200
Aug 19 22:54:48 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:48 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:48 localhost klogd: h9k: tx queue 1 (a4aa3900), link ffff8800a4aa3998
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: new IMR 0x0
Aug 19 22:54:48 localhost klogd: TX complete: skb: ffff8800a4805d00
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:48 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:48 localhost klogd: ath9k: 0xf4041071 => 0x0
Aug 19 22:54:48 localhost klogd: disable IER
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:48 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:48 localhost klogd: link[1] (ffff8800a4aad820)=b8 (ffff8800a4aad8b8)
Aug 19 22:54:48 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:49 localhost klogd: new IMR 0x0
Aug 19 22:54:49 localhost klogd: transmitting packet, skb: ffff8800a185de00
Aug 19 22:54:49 localhost klogd: enable IER
Aug 19 22:54:49 localhost klogd: transmitting packet, skb: ffff88009b8dea00
Aug 19 22:54:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:49 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:49 localhost klogd: transmitting packet, skb: ffff88008485ff00
Aug 19 22:54:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:49 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:49 localhost klogd: disable IER
Aug 19 22:54:49 localhost klogd: <pth: 1
Aug 19 22:54:49 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:49 localhost klogd: transmitting packet, skb: ffff8800a4838900
Aug 19 22:54:49 localhost klogd: <70
Aug 19 22:54:49 localhost klogd: up9k:71 => 0x0
Aug 19 22:54:49 localhost klogd: ath9k: enable IER
Aug 19 22:54:49 localhost klogd: <7=> 0xf4041071
Aug 19 22:54:49 localhost klogd: <7ath9k: enable IER
Aug 19 22:54:49 localhost klogd: <le IER
Aug 19 22:54:49 localhost klogd: <ive FIFO overrun interrupt
Aug 19 22:54:49 localhost klogd: <7th9k: enable IER
Aug 19 22:54:49 localhost klogd: <7ble IER
Aug 19 22:54:50 localhost klogd: enable IER
Aug 19 22:54:50 localhost klogd: <enable IER
Aug 19 22:54:50 localhost klogd: k: new IMR 0x918414b4
Aug 19 22:54:50 localhost klogd: < IMR 0x0
Aug 19 22:54:50 localhost klogd: <7 nexf4041071
Aug 19 22:54:50 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:50 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:54:50 localhost klogd: tx hung, resetting the chip
Aug 19 22:54:50 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:51 localhost klogd: transmitting packet, skb: ffff8800a4988900
Aug 19 22:54:51 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:51 localhost klogd: enable IER
Aug 19 22:54:51 localhost klogd: tx queue 1 (a4aabf30), link ffff8800a4aabf30
Aug 19 22:54:51 localhost klogd: transmitting packet, skb: ffff8800a1856000
Aug 19 22:54:51 localhost klogd: transmitting packet, skb: ffff88008297af00
Aug 19 22:54:51 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:51 localhost klogd: link[1] (ffff8800a4aac9e0)=78 (ffff8800a4aaca78)
Aug 19 22:54:51 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:51 localhost klogd: transmitting packet, skb: ffff88008484d000
Aug 19 22:54:51 localhost klogd: tx queue 1 (a4aacf38), link ffff8800a4aacf38
Aug 19 22:54:51 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:51 localhost klogd: tx queue 1 (a4ab0c60), link ffff8800a4ab0c60
Aug 19 22:54:51 localhost klogd: link[1] (ffff8800a4aa0688)=b8 (ffff8800a4aa07b8)
Aug 19 22:54:51 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:51 localhost klogd: tx queue 1 (a4aa0ed8), link ffff8800a4aa0ed8
Aug 19 22:54:51 localhost klogd: transmitting packet, skb: ffff8800a49c7f00
Aug 19 22:54:51 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:51 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:51 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:52 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:52 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:52 localhost klogd: link[1] (ffff8800a4aa6ae0)=78 (ffff8800a4aa6b78)
Aug 19 22:54:52 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:52 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:52 localhost klogd: transmitting packet, skb: ffff880084973e00
Aug 19 22:54:52 localhost klogd: transmitting packet, skb: ffff8800a4874400
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:52 localhost klogd: new IMR 0x0
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:52 localhost klogd: link[1] (ffff8800a4ab1f60)=90 (ffff8800a4ab2090)
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:52 localhost klogd: tx queue 1 (a4aa1988), link ffff8800a4aa1988
Aug 19 22:54:52 localhost klogd: enable IER
Aug 19 22:54:52 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff8800a5cd2200
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff8800a4838900
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff880082959300
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff8800a954d200
Aug 19 22:54:53 localhost klogd: disable IER
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:53 localhost klogd: disable IER
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:53 localhost klogd: disable IER
Aug 19 22:54:53 localhost klogd: disable IER
Aug 19 22:54:53 localhost klogd: tx queue 1 (a4ab18d8), link ffff8800a4ab18d8
Aug 19 22:54:53 localhost klogd: link[1] (ffff8800a4ab1d98)=30 (ffff8800a4ab1e30)
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff8800a4805e00
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: new IMR 0x0
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff8800a4838200
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: disable IER
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff8800a48b9500
Aug 19 22:54:53 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:53 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:53 localhost klogd: new IMR 0x0
Aug 19 22:54:53 localhost klogd: transmitting packet, skb: ffff88009e518e00
Aug 19 22:54:53 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:53 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:53 localhost klogd: disable IER
Aug 19 22:54:53 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:54 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:54:54 localhost klogd: transmitting packet, skb: ffff880082959100
Aug 19 22:54:54 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:54 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:54 localhost klogd: disable IER
Aug 19 22:54:54 localhost klogd: disable IER
Aug 19 22:54:54 localhost klogd: link[1] (ffff8800a4aabba0)=38 (ffff8800a4aabc38)
Aug 19 22:54:54 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:54 localhost klogd: <ath9k: qnum: 1, txq depth: 1
Aug 19 22:54:54 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:54 localhost klogd: new IMR 0x918414b4
Aug 19 22:54:54 localhost klogd: <ew IMR 0x918414b4>ath9k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:54 localhost klogd: <th9k: 0xf4041071 => 0x0
Aug 19 22:54:54 localhost klogd: <0x918414b4 IER 0x1
Aug 19 22:54:54 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:54 localhost klogd: <xf4041071 => 0x0
Aug 19 22:54:54 localhost klogd: < FIFO overrun interrupt
Aug 19 22:54:54 localhost klogd: <7ve FIFO overrun interrupt41071 => 0x0
Aug 19 22:54:55 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:55 localhost klogd: <7k: disable IER
Aug 19 22:54:55 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:54:55 localhost klogd: <FO overrun interrupt
Aug 19 22:54:55 localhost klogd: 41071 => 0x0
Aug 19 22:54:55 localhost klogd: 7>4b4 IER 0x1
Aug 19 22:54:55 localhost klogd: <IER 0x1
Aug 19 22:54:55 localhost klogd: <k: 0x0 => 0xf4041071
Aug 19 22:54:55 localhost klogd: <
Aug 19 22:54:55 localhost klogd: k: AR_IMR 0x9k: receive FIFO overrun interrupt
Aug 19 22:54:55 localhost klogd: h9k: 0x0 => 0xf4041071
Aug 19 22:54:55 localhost klogd: able IER
Aug 19 22:54:55 localhost klogd: h9k: disable IER
Aug 19 22:54:55 localhost klogd: th9k: enable IER
Aug 19 22:54:55 localhost klogd: IER 0x1
Aug 19 22:54:56 localhost klogd: enable IER
Aug 19 22:54:56 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:54:56 localhost klogd: qnum: 1, txq depth: 5
Aug 19 22:54:56 localhost klogd: enable IER
Aug 19 22:54:56 localhost klogd: transmitting packet, skb: ffff880069c0f600
Aug 19 22:54:56 localhost klogd: enable IER
Aug 19 22:54:56 localhost klogd: new IMR 0x0
Aug 19 22:54:56 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:56 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:56 localhost klogd: transmitting packet, skb: ffff8800828fdb00
Aug 19 22:54:56 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:56 localhost klogd: new IMR 0x0
Aug 19 22:54:57 localhost klogd: transmitting packet, skb: ffff88008290faf8
Aug 19 22:54:57 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:54:57 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:54:57 localhost klogd: Enable TXE on queue: 1
Aug 19 22:54:57 localhost klogd: transmitting packet, skb: ffff8800a48a4300
Aug 19 22:54:57 localhost klogd: enable IER
Aug 19 22:55:07 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:55:07 localhost klogd: new IMR 0x0
Aug 19 22:55:07 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:55:07 localhost klogd: transmitting packet, skb: ffff8800a5ca1600
Aug 19 22:55:07 localhost klogd: link[1] (ffff8800a4aa73c8)=60 (ffff8800a4aa7460)
Aug 19 22:55:07 localhost klogd: transmitting packet, skb: ffff88006e03ae00
Aug 19 22:55:08 localhost klogd: link[1] (ffff8800a4aa8598)=30 (ffff8800a4aa8630)
Aug 19 22:55:08 localhost klogd: tx queue 1 (a4aa8b88), link ffff8800a4aa8b88
Aug 19 22:55:08 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:55:08 localhost klogd: transmitting packet, skb: ffff8800a48ca600
Aug 19 22:55:08 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:55:08 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:08 localhost klogd: link[1] (ffff8800a4aaad60)=f8 (ffff8800a4aaadf8)
Aug 19 22:55:08 localhost klogd: link[1] (ffff8800a4aad490)=28 (ffff8800a4aad528)
Aug 19 22:55:08 localhost klogd: disable IER
Aug 19 22:55:08 localhost klogd: Enable TXE on queue: 1
Aug 19 22:55:08 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:55:08 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:08 localhost klogd: transmitting packet, skb: ffff8800a5cd2b00
Aug 19 22:55:08 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:55:08 localhost klogd: transmitting packet, skb: ffff8800a954d200
Aug 19 22:55:08 localhost klogd: Enable TXE on queue: 1
Aug 19 22:55:09 localhost klogd: Enable TXE on queue: 1
Aug 19 22:55:09 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:55:09 localhost klogd: Enable TXE on queue: 1
Aug 19 22:55:09 localhost klogd: 0xf4041071 => 0x0
Aug 19 22:55:09 localhost klogd: disable IER
Aug 19 22:55:09 localhost klogd: link[1] (ffff8800a4aa0ed8)=70 (ffff8800a4aa0f70)
Aug 19 22:55:09 localhost klogd: Enable TXE on queue: 1
Aug 19 22:55:09 localhost klogd: new IMR 0x918414b4
Aug 19 22:55:09 localhost klogd: qnum: 1, txq depth: 2
Aug 19 22:55:09 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:55:09 localhost klogd: qnum: 1, txq depth: 3
Aug 19 22:55:09 localhost klogd: link[1] (ffff8800a4aa6f08)=38 (ffff8800a4aa7038)
Aug 19 22:55:09 localhost klogd: Enable TXE on queue: 1
Aug 19 22:55:09 localhost klogd: >ath9k: enable IER
Aug 19 22:55:09 localhost klogd: tx queue 1 (a4aaa218), link ffff8800a4aaa218
Aug 19 22:55:09 localhost klogd: <>ath9k: new IMR 0x0
Aug 19 22:55:09 localhost klogd: < new IMR 0x918414b4
Aug 19 22:55:09 localhost klogd: < 0x918414b4 IER 0x1
Aug 19 22:55:09 localhost klogd: R 0x918414b4 IER 0x1
Aug 19 22:55:09 localhost klogd: <7h9k: disable IER
Aug 19 22:55:09 localhost klogd: <7IER
Aug 19 22:55:09 localhost klogd: 9k:x918414b4 IER 0x1
Aug 19 22:55:09 localhost klogd: <h9k: 0x0 => 0xf4041071
Aug 19 22:55:09 localhost klogd: IMR 0x918414b4
Aug 19 22:55:09 localhost klogd: enable IER
Aug 19 22:55:09 localhost klogd: <7ath9k: disable IER
Aug 19 22:55:10 localhost klogd: nable IER
Aug 19 22:55:10 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:10 localhost klogd: <77> => 0xf4041071
Aug 19 22:55:10 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:55:10 localhost klogd: <upt
Aug 19 22:55:10 localhost klogd: <7t
Aug 19 22:55:10 localhost klogd: ath9k: enable IER
Aug 19 22:55:10 localhost klogd: 9k:ath9k: new IMR 0x0
Aug 19 22:55:10 localhost klogd: <ath9k: 0xf4041071 => 0x0
Aug 19 22:55:10 localhost klogd: AR_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:55:11 localhost klogd: <7R 0x918414b4
Aug 19 22:55:11 localhost klogd: ath9k: 0x0 => 0xf4041071
Aug 19 22:55:11 localhost klogd: enable IER
Aug 19 22:55:11 localhost klogd: <h9k0x0
Aug 19 22:55:11 localhost klogd:  IMR 0x918414b4
Aug 19 22:55:11 localhost klogd: 
Aug 19 22:55:11 localhost klogd: <7R_INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:55:11 localhost klogd: < 0x0
Aug 19 22:55:11 localhost klogd: ew IMR 0x0
Aug 19 22:55:11 localhost klogd: <7ath9k: receive FIFO overrun interrupt
Aug 19 22:55:11 localhost klogd: k: ER
Aug 19 22:55:11 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:12 localhost klogd: <9k:IER
Aug 19 22:55:12 localhost klogd: 0x918414b4 IER 0x1
Aug 19 22:55:12 localhost klogd: 9k: disable IER
Aug 19 22:55:12 localhost klogd: <7eceive FIFO overrun interrupt
Aug 19 22:55:12 localhost klogd: 0 => 0xf4041071
Aug 19 22:55:12 localhost klogd: < 0x0
Aug 19 22:55:12 localhost klogd: 0x918414b4
Aug 19 22:55:12 localhost klogd: <77>ath9k: new IMR 0x0
Aug 19 22:55:12 localhost klogd: <70x1
Aug 19 22:55:12 localhost klogd: >ath9k: 0xf4041071 => 0x0
Aug 19 22:55:12 localhost klogd: >ath9k: new IMR 0x0
Aug 19 22:55:12 localhost klogd: >ath9k: receive FIFO overrun interrupt
Aug 19 22:55:13 localhost klogd: 9k: receive FIFO overrun interrupt
Aug 19 22:55:13 localhost klogd: new IMR 0x918414b4
Aug 19 22:55:13 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:13 localhost klogd: <9k:x918414b4 IER 0x1
Aug 19 22:55:13 localhost klogd: <7: enable IER
Aug 19 22:55:13 localhost klogd: >ath9k: new IMR 0x918414b4
Aug 19 22:55:13 localhost klogd: <h9k: enable IER
Aug 19 22:55:13 localhost klogd: <IMR 0x918414b4
Aug 19 22:55:13 localhost klogd: <: enable IER
Aug 19 22:55:13 localhost klogd: <k: 0xf4041071 => 0x0
Aug 19 22:55:13 localhost klogd: athle IER
Aug 19 22:55:14 localhost klogd: <ath0410athMR 0x918414b4
Aug 19 22:55:14 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:55:14 localhost klogd: <79k: disable IER
Aug 19 22:55:14 localhost klogd: <e FIrrupt
Aug 19 22:55:14 localhost klogd: <k: enable IER
Aug 19 22:55:14 localhost klogd: : disable IER
Aug 19 22:55:14 localhost klogd: k: 918414b4 IER 0x1
Aug 19 22:55:14 localhost klogd: <9k: 0x0 => 0xf4041071
Aug 19 22:55:14 localhost klogd: <7new IMR 0x918414b4
Aug 19 22:55:14 localhost klogd: < 0x918414b4
Aug 19 22:55:14 localhost klogd: <4b4 IER 0x1
Aug 19 22:55:14 localhost klogd: <7IMR 0x918414b4 IER 0x1
Aug 19 22:55:14 localhost klogd: <errun interrupt
Aug 19 22:55:15 localhost klogd:  0xf4041071 => 0x0
Aug 19 22:55:15 localhost klogd: 1071 => 0x0
Aug 19 22:55:15 localhost klogd: 9k:ath9k: new IMR 0x0
Aug 19 22:55:15 localhost klogd: R 0xb4 7>ath9k: receive FIFO overrun interrupt
Aug 19 22:55:15 localhost klogd:  0x918414b4 IER 0x1
Aug 19 22:55:15 localhost klogd: 0x918414b4 IER 0x1
Aug 19 22:55:15 localhost klogd:  IMR 0x918414b4
Aug 19 22:55:15 localhost klogd: <0xf7>ath9k: disable IER
Aug 19 22:55:15 localhost klogd: <7: 0xf4041071 => 0x0
Aug 19 22:55:15 localhost klogd: >ath9k: new IMR 0x0
Aug 19 22:55:16 localhost klogd: R 0x918414b4
Aug 19 22:55:16 localhost klogd: <7pt: 0xf4041071 => 0x0
Aug 19 22:55:16 localhost klogd: < 0x1
Aug 19 22:55:16 localhost klogd: <7R 0x918414b4
Aug 19 22:55:16 localhost klogd: <b4 IER 0x1
Aug 19 22:55:16 localhost klogd: <h9k0xf4041071
Aug 19 22:55:16 localhost klogd: <new IMR 0x0
Aug 19 22:55:17 localhost klogd: <7ceive FIFO overrun interrupt
Aug 19 22:55:17 localhost klogd: <79k: disable IER
Aug 19 22:55:17 localhost klogd: <77>ath9k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:17 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:55:17 localhost klogd: <h9k: 0xf4041071 => 0x0
Aug 19 22:55:17 localhost klogd: receive FIFO overrun interrupt
Aug 19 22:55:17 localhost klogd: <k: x918414b4
Aug 19 22:55:17 localhost klogd: IER
Aug 19 22:55:17 localhost klogd: 0x0 => 0xf4041071
Aug 19 22:55:17 localhost klogd: < 0x0
Aug 19 22:55:17 localhost klogd: <h9k071
Aug 19 22:55:17 localhost klogd: <7IMR 0x918414b4
Aug 19 22:55:18 localhost klogd: <7: e9k: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:18 localhost klogd: _INTR_SYNC_LOCAL_TIMEOUT
Aug 19 22:55:18 localhost klogd: enable IER
Aug 19 22:55:18 localhost klogd: AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:18 localhost klogd: <7ath9k: new IMR 0x0
Aug 19 22:55:18 localhost klogd: <7errath41071 => 0x0
Aug 19 22:55:18 localhost klogd: <7x918414b4 IER 0x1
Aug 19 22:55:18 localhost klogd: x0
Aug 19 22:55:18 localhost klogd: 1
Aug 19 22:55:18 localhost klogd: <ath9k: enable IER
Aug 19 22:55:18 localhost klogd: <th9k: receive FIFO overrun interrupt
Aug 19 22:55:19 localhost klogd: th9k: 0xf4041071 => 0x0
Aug 19 22:55:19 localhost klogd: 9k:IER
Aug 19 22:55:19 localhost klogd: <7: n0
Aug 19 22:55:19 localhost klogd: <AR_IMR 0x918414b4 IER 0x1
Aug 19 22:55:19 localhost klogd: rupt
Aug 19 22:55:19 localhost klogd: <0x1
Aug 19 22:55:19 localhost klogd: disable IER

--------------040102000600040305090808--
