Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51502 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752774Ab0H1LZm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Aug 2010 07:25:42 -0400
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com
Subject: ath: DMA failed to stop in 10 ms
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 28 Aug 2010 14:25:39 +0300
Message-ID: <87bp8n7zd8.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

ath9k is giving me hard time. Roughly once in two days I get ath9k DMA
timeouts and I need to reload the modules to get wireless working
again. I'm using Ubuntu 10.04 on Samsung X120 laptop and mostly
running latest wireless-testing and connman.

Here's the wireless init output:

[ 1045.894275] cfg80211: Calling CRDA to update world regulatory
domain
[ 1045.913908] cfg80211: World regulatory domain updated:
[ 1045.913913]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1045.913919]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1045.913924]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 1045.913929]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi,
2000 mBm)
[ 1045.913934]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1045.913939]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi,
2000 mBm)
[ 1045.996991] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[ 1045.997026] ath9k 0000:02:00.0: setting latency timer to 64
[ 1046.001673] ath: Using ANI v1
[ 1046.049993] ath: EEPROM regdomain: 0x65
[ 1046.049997] ath: EEPROM indicates we should expect a direct regpair
map
[ 1046.050026] ath: Country alpha2 being used: 00
[ 1046.050029] ath: Regpair used: 0x65
[ 1046.079355] phy0: Selected rate control algorithm
'ath9k_rate_control'
[ 1046.101669] Registered led device: ath9k-phy0::radio
[ 1046.101773] Registered led device: ath9k-phy0::assoc
[ 1046.102228] Registered led device: ath9k-phy0::tx
[ 1046.103727] Registered led device: ath9k-phy0::rx
[ 1046.103742] phy0: Atheros AR9285 Rev:2 mem=0xffffc90023e40000,
irq=16
[ 1046.135555] ADDRCONF(NETDEV_UP): wlan0: link is not ready

Here's a summary of my DMA timeout errors from the last week:

Aug 22 10:07:32 tukki kernel: [ 8823.456281] ath9k: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 23 10:46:10 tukki kernel: [ 7568.356857] ath9k: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 23 14:40:07 tukki kernel: [21605.306715] ath9k: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 23 15:14:38 tukki kernel: [23676.356962] ath9k: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 23 21:02:51 tukki kernel: [44593.927002] ath9k: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 25 01:32:34 tukki kernel: [147176.706583] ath9k: DMA failed to
stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 25 02:46:35 tukki kernel: [151617.916610] ath9k: DMA failed to
stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 25 06:04:44 tukki kernel: [163507.226523] ath9k: DMA failed to
stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 25 06:40:46 tukki kernel: [165669.320942] ath9k: DMA failed to
stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 27 07:24:22 tukki kernel: [295831.816618] ath9k: DMA failed to
stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 27 08:14:19 tukki kernel: [298829.036579] ath9k: DMA failed to
stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:51:59 tukki kernel: [17222.142872] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:51:59 tukki kernel: [17222.155239] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:52:00 tukki kernel: [17223.012741] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:52:00 tukki kernel: [17223.025097] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:29 tukki kernel: [17312.614445] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:29 tukki kernel: [17312.626871] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:30 tukki kernel: [17313.363159] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:30 tukki kernel: [17313.375578] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:30 tukki kernel: [17313.453257] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:30 tukki kernel: [17313.465683] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:30 tukki kernel: [17313.542603] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:30 tukki kernel: [17313.555034] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:32 tukki kernel: [17315.692627] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:32 tukki kernel: [17315.705034] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:33 tukki kernel: [17316.082630] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:33 tukki kernel: [17316.094841] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:35 tukki kernel: [17318.242727] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:35 tukki kernel: [17318.255113] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:35 tukki kernel: [17318.512565] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:35 tukki kernel: [17318.524929] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:35 tukki kernel: [17318.842563] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:35 tukki kernel: [17318.854820] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:36 tukki kernel: [17319.772547] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:36 tukki kernel: [17319.784904] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020
Aug 28 11:53:37 tukki kernel: [17320.163131] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
Aug 28 11:53:37 tukki kernel: [17320.175362] ath: DMA failed to stop
in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x020000

I believe the "ath9k:" version of the error messages is from the
Ubuntu 10.04 kernel which I was forced to use until I disabled broken
ecryptfs setup in my laptop.

Any ideas what's wrong and how to fix this? I can provide more info
and logs, but I have to warn that it will take some time for me to
take them. My backlog is too long again :)

-- 
Kalle Valo
