Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36684 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1CJAfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 19:35:09 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/4] ath9k: fix stopping tx dma on reset
Date: Thu, 10 Mar 2011 01:35:01 +0100
Message-Id: <1299717303-42430-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299717303-42430-1-git-send-email-nbd@openwrt.org>
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some situations, stopping Tx DMA frequently fails, leading to messages
like this:

ath: Failed to stop TX DMA in 100 msec after killing last frame
ath: Failed to stop TX DMA!

This patch uses a few MAC features to abort DMA globally instead of iterating
over all hardware queues and attempting to stop them individually.
Not only is that faster and works with a shorter timeout, it also makes the
process much more reliable.

With this change, I can no longer trigger these messages on AR9380,
and on AR9280 they become much more rare.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.c  |   31 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/mac.h  |    1 +
 drivers/net/wireless/ath/ath9k/xmit.c |   14 ++++++--------
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 5efc869..aa9f646 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -143,6 +143,37 @@ bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel)
 }
 EXPORT_SYMBOL(ath9k_hw_updatetxtriglevel);
 
+bool ath9k_hw_abort_tx_dma(struct ath_hw *ah)
+{
+	int i, q;
+
+	REG_WRITE(ah, AR_Q_TXD, AR_Q_TXD_M);
+
+	REG_SET_BIT(ah, AR_PCU_MISC, AR_PCU_FORCE_QUIET_COLL | AR_PCU_CLEAR_VMF);
+	REG_SET_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+	REG_SET_BIT(ah, AR_D_GBL_IFS_MISC, AR_D_GBL_IFS_MISC_IGNORE_BACKOFF);
+
+	for (q = 0; q < AR_NUM_QCU; q++) {
+		for (i = 1000; i > 0; i--) {
+			if (!ath9k_hw_numtxpending(ah, q))
+				break;
+
+			udelay(5);
+		}
+	}
+	if (!i)
+		return false;
+
+	REG_CLR_BIT(ah, AR_PCU_MISC, AR_PCU_FORCE_QUIET_COLL | AR_PCU_CLEAR_VMF);
+	REG_CLR_BIT(ah, AR_DIAG_SW, AR_DIAG_FORCE_CH_IDLE_HIGH);
+	REG_CLR_BIT(ah, AR_D_GBL_IFS_MISC, AR_D_GBL_IFS_MISC_IGNORE_BACKOFF);
+
+	REG_WRITE(ah, AR_Q_TXD, 0);
+
+	return true;
+}
+EXPORT_SYMBOL(ath9k_hw_abort_tx_dma);
+
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q)
 {
 #define ATH9K_TX_STOP_DMA_TIMEOUT	4000    /* usec */
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 04d58ae..347ee5f 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -677,6 +677,7 @@ void ath9k_hw_cleartxdesc(struct ath_hw *ah, void *ds);
 u32 ath9k_hw_numtxpending(struct ath_hw *ah, u32 q);
 bool ath9k_hw_updatetxtriglevel(struct ath_hw *ah, bool bIncTrigLevel);
 bool ath9k_hw_stoptxdma(struct ath_hw *ah, u32 q);
+bool ath9k_hw_abort_tx_dma(struct ath_hw *ah);
 void ath9k_hw_gettxintrtxqs(struct ath_hw *ah, u32 *txqs);
 bool ath9k_hw_set_txq_props(struct ath_hw *ah, int q,
 			    const struct ath9k_tx_queue_info *qinfo);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index e16136d..bb1d29e 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1194,16 +1194,14 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 	if (sc->sc_flags & SC_OP_INVALID)
 		return true;
 
-	/* Stop beacon queue */
-	ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
+	ath9k_hw_abort_tx_dma(ah);
 
-	/* Stop data queues */
+	/* Check if any queue remains active */
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i)) {
-			txq = &sc->tx.txq[i];
-			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-			npend += ath9k_hw_numtxpending(ah, txq->axq_qnum);
-		}
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		npend += ath9k_hw_numtxpending(ah, sc->tx.txq[i].axq_qnum);
 	}
 
 	if (npend)
-- 
1.7.3.2

