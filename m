Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53864 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478Ab1CJNlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 08:41:46 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	vasanth@atheros.com, mark@moxienet.com
Subject: [PATCH v2 4/4] ath9k: improve reliability of beacon transmission and stuck beacon handling
Date: Thu, 10 Mar 2011 14:41:39 +0100
Message-Id: <1299764499-76251-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299764499-76251-3-git-send-email-nbd@openwrt.org>
References: <1299764499-76251-1-git-send-email-nbd@openwrt.org>
 <1299764499-76251-2-git-send-email-nbd@openwrt.org>
 <1299764499-76251-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k calls ath9k_hw_stoptxdma every time it sends a beacon, however there
is not much point in doing that if the previous beacon and mcast traffic
went out properly. On AR9380, calling that function too often can result
in an increase of stuck beacons due to differences in the handling of the
queue enable/disable functionality.

With this patch, the queue will only be explicitly stopped if the previous
data frames were not sent successfully. With the beacon code being the
only remaining user of ath9k_hw_stoptxdma, this function can be simplified
in order to remove the now pointless attempts at waiting for transmission
completion, which would never happen at this point due to the different
method of tx scheduling of the beacon queue.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   13 +-----
 drivers/net/wireless/ath/ath9k/mac.c    |   68 +++---------------------------
 drivers/net/wireless/ath/ath9k/mac.h    |    2 +-
 3 files changed, 10 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index a4bdfdb..6d2a545f 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -373,6 +373,7 @@ void ath_beacon_tasklet(unsigned long data)
 			ath_dbg(common, ATH_DBG_BSTUCK,
 				"missed %u consecutive beacons\n",
 				sc->beacon.bmisscnt);
+			ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
 			ath9k_hw_bstuck_nfcal(ah);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			ath_dbg(common, ATH_DBG_BSTUCK,
@@ -450,16 +451,6 @@ void ath_beacon_tasklet(unsigned long data)
 		sc->beacon.updateslot = OK;
 	}
 	if (bfaddr != 0) {
-		/*
-		 * Stop any current dma and put the new frame(s) on the queue.
-		 * This should never fail since we check above that no frames
-		 * are still pending on the queue.
-		 */
-		if (!ath9k_hw_stoptxdma(ah, sc->beacon.beaconq)) {
-			ath_err(common, "beacon queue %u did not stop?\n",
-				sc->beacon.beaconq);
-		}
-
 		/* NB: cabq traffic should already be queued and primed */
 		ath9k_hw_puttxbuf(ah, sc->beacon.beaconq, bfaddr);
 		ath9k_hw_txstart(ah, sc->beacon.beaconq);
@@ -780,7 +771,7 @@ void ath9k_set_beaconing_status(struct ath_softc *sc, bool status)
 		ah->imask &= ~ATH9K_INT_SWBA;
 		ath9k_hw_set_interrupts(ah, ah->imask);
 		tasklet_kill(&sc->bcon_tasklet);
-		ath9k_hw_stoptxdma(ah, sc->beacon.beaconq);
+		ath9k_hw_stop_dma_queue(ah, sc->beacon.beaconq);
 	}
 	ath9k_ps_restore(sc);
 }
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 188af17..0a734f1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -170,84 +170,30 @@ void ath9k_hw_abort_tx_dma(struct ath_hw *ah)
 }
 EXPORT_SYMBOL(ath9k_hw_abort_tx_dma);
 
-bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
+bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q)
 {
-#define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
+#define ATH9K_TX_STOP_DMA_TIMEOUT	1000    /* usec */
 #define ATH9K_TIME_QUANTUM		100     /* usec */
-	struct ath_common *common = ath9k_hw_common(ah);
-	struct ath9k_hw_capabilities *pCap = &ah->caps;
-	struct ath9k_tx_queue_info *qi;
-	u32 tsfLow, j, wait;
-	u32 wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
-
-	if (q >= pCap->total_queues) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Stopping TX DMA, invalid queue: %u\n", q);
-		return false;
-	}
-
-	qi = &ah->txq[q];
-	if (qi->tqi_type == ATH9K_TX_QUEUE_INACTIVE) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"Stopping TX DMA, inactive queue: %u\n", q);
-		return false;
-	}
+	int wait_time = ATH9K_TX_STOP_DMA_TIMEOUT / ATH9K_TIME_QUANTUM;
+	int wait;
 
 	REG_WRITE(ah, AR_Q_TXD, 1 << q);
 
 	for (wait = wait_time; wait != 0; wait--) {
 		if (ath9k_hw_numtxpending(ah, q) == 0)
 			break;
-		udelay(ATH9K_TIME_QUANTUM);
-	}
-
-	if (ath9k_hw_numtxpending(ah, q)) {
-		ath_dbg(common, ATH_DBG_QUEUE,
-			"%s: Num of pending TX Frames %d on Q %d\n",
-			__func__, ath9k_hw_numtxpending(ah, q), q);
-
-		for (j = 0; j < 2; j++) {
-			tsfLow = REG_READ(ah, AR_TSF_L32);
-			REG_WRITE(ah, AR_QUIET2,
-				  SM(10, AR_QUIET2_QUIET_DUR));
-			REG_WRITE(ah, AR_QUIET_PERIOD, 100);
-			REG_WRITE(ah, AR_NEXT_QUIET_TIMER, tsfLow >> 10);
-			REG_SET_BIT(ah, AR_TIMER_MODE,
-				       AR_QUIET_TIMER_EN);
-
-			if ((REG_READ(ah, AR_TSF_L32) >> 10) == (tsfLow >> 10))
-				break;
-
-			ath_dbg(common, ATH_DBG_QUEUE,
-				"TSF has moved while trying to set quiet time TSF: 0x%08x\n",
-				tsfLow);
-		}
-
-		REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
 
-		udelay(200);
-		REG_CLR_BIT(ah, AR_TIMER_MODE, AR_QUIET_TIMER_EN);
-
-		wait = wait_time;
-		while (ath9k_hw_numtxpending(ah, q)) {
-			if ((--wait) == 0) {
-				ath_err(common,
-					"Failed to stop TX DMA in 100 msec after killing last frame\n");
-				break;
-			}
-			udelay(ATH9K_TIME_QUANTUM);
-		}
-
-		REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+		udelay(ATH9K_TIME_QUANTUM);
 	}
 
 	REG_WRITE(ah, AR_Q_TXD, 0);
+
 	return wait != 0;
 
 #undef ATH9K_TX_STOP_DMA_TIMEOUT
 #undef ATH9K_TIME_QUANTUM
 }
-EXPORT_SYMBOL(ath9k_hw_stoptxdma);
+EXPORT_SYMBOL(ath9k_hw_stop_dma_queue);
 
 void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs)
 {
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index d37c6d4..b2b2ff8 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -676,7 +676,7 @@ void ath9k_hw_txstart(struct ath_hw *ah, u32 q);
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, void *ds);
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
-bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q);
+bool ath9k_hw_stop_dma_queue(struct ath_hw *ah, u32 q);
 void ath9k_hw_abort_tx_dma(struct ath_hw *ah);
 void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs);
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
-- 
1.7.3.2

