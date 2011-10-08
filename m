Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39720 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab1JHNuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Oct 2011 09:50:11 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k: disable unnecessary PHY error reporting
Date: Sat,  8 Oct 2011 15:49:57 +0200
Message-Id: <1318081797-77919-1-git-send-email-nbd@openwrt.org> (sfid-20111008_155020_392758_ECEA0FA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PHY errors relevant for ANI are always tracked by hardware counters, the
bits that allow them to pass through the rx filter are independent of that.
Enabling PHY errors in the rx filter often creates lots of useless DMA traffic
and might be responsible for some of the rx dma stop failure warnings.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ani.c  |    5 -----
 drivers/net/wireless/ath/ath9k/recv.c |    5 +----
 2 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 01240d6..2776c3c 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -504,9 +504,6 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_CCK_WEAK_SIGNAL_THR,
 				     ATH9K_ANI_CCK_WEAK_SIG_THR);
 
-		ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) |
-				     ATH9K_RX_FILTER_PHYERR);
-
 		ath9k_ani_restart(ah);
 		return;
 	}
@@ -527,8 +524,6 @@ static void ath9k_ani_reset_old(struct ath_hw *ah, bool is_scanning)
 		ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 				     aniState->firstepLevel);
 
-	ath9k_hw_setrxfilter(ah, ath9k_hw_getrxfilter(ah) &
-			     ~ATH9K_RX_FILTER_PHYERR);
 	ath9k_ani_restart(ah);
 
 	ENABLE_REGWRITE_BUFFER(ah);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f658ec6..d28a5dd 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -433,12 +433,9 @@ void ath_rx_cleanup(struct ath_softc *sc)
 
 u32 ath_calcrxfilter(struct ath_softc *sc)
 {
-#define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
-
 	u32 rfilt;
 
-	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
-		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
+	rfilt = ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
 		| ATH9K_RX_FILTER_MCAST;
 
 	if (sc->rx.rxfilter & FIF_PROBE_REQ)
-- 
1.7.3.2

