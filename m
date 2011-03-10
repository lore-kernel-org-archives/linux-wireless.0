Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36686 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1CJAfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 19:35:09 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/4] ath9k: fix the .flush driver op implementation
Date: Thu, 10 Mar 2011 01:35:02 +0100
Message-Id: <1299717303-42430-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1299717303-42430-2-git-send-email-nbd@openwrt.org>
References: <1299717303-42430-1-git-send-email-nbd@openwrt.org>
 <1299717303-42430-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k has a timeout of 60ms for the flush, but instead waiting 60 ms for
all tx activity to finish, it resets it for every single queue.

This patch simplifies the flush op and reuses ath_drain_all_txq for
flushing out pending frames if necessary.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |   55 +++++++++++---------------------
 1 files changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2e228aa..0e9f748 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2128,54 +2128,37 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 
 static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 {
-#define ATH_FLUSH_TIMEOUT	60 /* ms */
 	struct ath_softc *sc = hw->priv;
-	struct ath_txq *txq = NULL;
-	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
-	int i, j, npend = 0;
+	int timeout = 60; /* ms */
+	int i, j;
 
 	mutex_lock(&sc->mutex);
 
 	cancel_delayed_work_sync(&sc->tx_complete_work);
 
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (!ATH_TXQ_SETUP(sc, i))
-			continue;
-		txq = &sc->tx.txq[i];
+	if (drop)
+		timeout = 1;
 
-		if (!drop) {
-			for (j = 0; j < ATH_FLUSH_TIMEOUT; j++) {
-				if (!ath9k_has_pending_frames(sc, txq))
-					break;
-				usleep_range(1000, 2000);
-			}
-		}
+	for (j = 0; j < timeout; j++) {
+		int npend = 0;
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (!ATH_TXQ_SETUP(sc, i))
+				continue;
 
-		if (drop || ath9k_has_pending_frames(sc, txq)) {
-			ath_dbg(common, ATH_DBG_QUEUE, "Drop frames from hw queue:%d\n",
-				txq->axq_qnum);
-			spin_lock_bh(&txq->axq_lock);
-			txq->txq_flush_inprogress = true;
-			spin_unlock_bh(&txq->axq_lock);
-
-			ath9k_ps_wakeup(sc);
-			ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-			npend = ath9k_hw_numtxpending(ah, txq->axq_qnum);
-			ath9k_ps_restore(sc);
-			if (npend)
-				break;
-
-			ath_draintxq(sc, txq, false);
-			txq->txq_flush_inprogress = false;
+			npend += ath9k_has_pending_frames(sc, &sc->tx.txq[i]);
 		}
-	}
 
-	if (npend) {
-		ath_reset(sc, false);
-		txq->txq_flush_inprogress = false;
+		if (!npend)
+		    goto out;
+
+		usleep_range(1000, 2000);
 	}
 
+	ath9k_ps_wakeup(sc);
+	ath_drain_all_txq(sc, false);
+	ath9k_ps_restore(sc);
+
+out:
 	ieee80211_queue_delayed_work(hw, &sc->tx_complete_work, 0);
 	mutex_unlock(&sc->mutex);
 }
-- 
1.7.3.2

