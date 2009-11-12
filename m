Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45622 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790AbZKLPZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 10:25:59 -0500
Date: Thu, 12 Nov 2009 16:26:00 +0100
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: ath9k: DMA failed to stop in 10 ms
Message-ID: <20091112152600.GA7562@sig21.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have a Samsung N130 netbook which has

  phy0: Atheros AR9285 MAC/BB Rev:2 AR5133 RF Rev:e0: mem=0xf80e0000, irq=16

and I run Debain unstable with a linux-2.6.32-rc6-166-g799dd75 kernel.


When running kismet I get a lot of

[ 2030.531809] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2030.731944] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2030.968118] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2031.169580] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2031.397604] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2031.653803] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2031.883503] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2032.092719] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2032.332719] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020
[ 2032.539756] ath9k: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x00000020

This is 100% reproducable.  However it seems kismet is still working
(but probably missing some frames due to the issue).


Connecting to and AP via WPA2 works (but I didn't test much yet), but
when I terminate wpa_supplicant I also get one of the "DMA failed to stop"
messages (same AR_CR and AR_DIAG_SW).


Is it safe to assume that the message is caused by an invalid
RX DMA descriptor?  Or hat else could cause DMA to fail to complete?


Thanks
Johannes
