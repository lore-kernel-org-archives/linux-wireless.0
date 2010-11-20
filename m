Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39442 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756329Ab0KTCIx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 21:08:53 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/3] ath9k: fix timeout on stopping rx dma
Date: Sat, 20 Nov 2010 03:08:47 +0100
Message-Id: <1290218928-87475-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290218928-87475-1-git-send-email-nbd@openwrt.org>
References: <1290218928-87475-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that using ath9k_hw_stoppcurecv to stop rx dma is not enough.
When it's time to stop DMA, the PCU is still busy, so the rx enable
bit never clears.
Using ath9k_hw_abortpcurecv helps with getting rx stopped much faster,
with this change, I cannot reproduce the rx stop related WARN_ON anymore.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c5c8076..262c815 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -518,7 +518,7 @@ bool ath_stoprecv(struct ath_softc *sc)
 	bool stopped;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
-	ath9k_hw_stoppcurecv(ah);
+	ath9k_hw_abortpcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah);
 
-- 
1.7.3.2

