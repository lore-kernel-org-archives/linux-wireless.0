Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39948 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752467Ab3ATRwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jan 2013 12:52:16 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 2/8] ath9k: clean up processing of pending tx frames on reset
Date: Sun, 20 Jan 2013 18:51:53 +0100
Message-Id: <1358704319-81749-2-git-send-email-nbd@openwrt.org> (sfid-20130120_185221_059944_BADF3EF5)
In-Reply-To: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
References: <1358704319-81749-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping packets from aggregation sessions is usually not a good idea, as
it might upset the synchronization of the BlockAck receive window of the
remote node. The use of the retry_tx parameter to reset/tx-drain functions
also seemed a bit arbitrary.
This patch removes this parameter altogether and ensures that pending tx
frames are not dropped for no good reason.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  5 ++--
 drivers/net/wireless/ath/ath9k/beacon.c |  2 +-
 drivers/net/wireless/ath/ath9k/main.c   | 41 +++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/xmit.c   | 43 ++++++++-------------------------
 4 files changed, 32 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8250330..b2d6c18 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -332,9 +332,8 @@ void ath_txq_lock(struct ath_softc *sc, struct ath_txq *txq);
 void ath_txq_unlock(struct ath_softc *sc, struct ath_txq *txq);
 void ath_txq_unlock_complete(struct ath_softc *sc, struct ath_txq *txq);
 void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq);
-bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx);
-void ath_draintxq(struct ath_softc *sc,
-		     struct ath_txq *txq, bool retry_tx);
+bool ath_drain_all_txq(struct ath_softc *sc);
+void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 2ca355e..dd37719 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -199,7 +199,7 @@ static struct ath_buf *ath9k_beacon_generate(struct ieee80211_hw *hw,
 		if (sc->nvifs > 1) {
 			ath_dbg(common, BEACON,
 				"Flushing previous cabq traffic\n");
-			ath_draintxq(sc, cabq, false);
+			ath_draintxq(sc, cabq);
 		}
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4b96cde..a637cdb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -182,7 +182,7 @@ static void ath_restart_work(struct ath_softc *sc)
 	ath_start_ani(sc);
 }
 
-static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
+static bool ath_prepare_reset(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	bool ret = true;
@@ -196,7 +196,7 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
-	if (!ath_drain_all_txq(sc, retry_tx))
+	if (!ath_drain_all_txq(sc))
 		ret = false;
 
 	if (!ath_stoprecv(sc))
@@ -247,8 +247,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	return true;
 }
 
-static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
-			      bool retry_tx)
+static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -271,7 +270,7 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 		hchan = ah->curchan;
 	}
 
-	if (!ath_prepare_reset(sc, retry_tx))
+	if (!ath_prepare_reset(sc))
 		fastcc = false;
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
@@ -312,7 +311,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
 		return -EIO;
 
-	r = ath_reset_internal(sc, hchan, false);
+	r = ath_reset_internal(sc, hchan);
 
 	return r;
 }
@@ -542,23 +541,21 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-static int ath_reset(struct ath_softc *sc, bool retry_tx)
+static int ath_reset(struct ath_softc *sc)
 {
-	int r;
+	int i, r;
 
 	ath9k_ps_wakeup(sc);
 
-	r = ath_reset_internal(sc, NULL, retry_tx);
+	r = ath_reset_internal(sc, NULL);
 
-	if (retry_tx) {
-		int i;
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (ATH_TXQ_SETUP(sc, i)) {
-				spin_lock_bh(&sc->tx.txq[i].axq_lock);
-				ath_txq_schedule(sc, &sc->tx.txq[i]);
-				spin_unlock_bh(&sc->tx.txq[i].axq_lock);
-			}
-		}
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (!ATH_TXQ_SETUP(sc, i))
+			continue;
+
+		spin_lock_bh(&sc->tx.txq[i].axq_lock);
+		ath_txq_schedule(sc, &sc->tx.txq[i]);
+		spin_unlock_bh(&sc->tx.txq[i].axq_lock);
 	}
 
 	ath9k_ps_restore(sc);
@@ -579,7 +576,7 @@ void ath_reset_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, hw_reset_work);
 
-	ath_reset(sc, true);
+	ath_reset(sc);
 }
 
 /**********************/
@@ -797,7 +794,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
-	ath_prepare_reset(sc, false);
+	ath_prepare_reset(sc);
 
 	if (sc->rx.frag) {
 		dev_kfree_skb_any(sc->rx.frag);
@@ -1809,11 +1806,11 @@ static void ath9k_flush(struct ieee80211_hw *hw, bool drop)
 	if (drop) {
 		ath9k_ps_wakeup(sc);
 		spin_lock_bh(&sc->sc_pcu_lock);
-		drain_txq = ath_drain_all_txq(sc, false);
+		drain_txq = ath_drain_all_txq(sc);
 		spin_unlock_bh(&sc->sc_pcu_lock);
 
 		if (!drain_txq)
-			ath_reset(sc, false);
+			ath_reset(sc);
 
 		ath9k_ps_restore(sc);
 		ieee80211_wake_queues(hw);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ca4a034..ac9ee67 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -378,7 +378,7 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 
 static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 struct ath_buf *bf, struct list_head *bf_q,
-				 struct ath_tx_status *ts, int txok, bool retry)
+				 struct ath_tx_status *ts, int txok)
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
@@ -490,7 +490,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		} else if (!isaggr && txok) {
 			/* transmit completion */
 			acked_cnt++;
-		} else if ((tid->state & AGGR_CLEANUP) || !retry) {
+		} else if (tid->state & AGGR_CLEANUP) {
 			/*
 			 * cleanup in progress, just fail
 			 * the un-acked sub-frames
@@ -1331,23 +1331,6 @@ void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid
 /* Queue Management */
 /********************/
 
-static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
-					  struct ath_txq *txq)
-{
-	struct ath_atx_ac *ac, *ac_tmp;
-	struct ath_atx_tid *tid, *tid_tmp;
-
-	list_for_each_entry_safe(ac, ac_tmp, &txq->axq_acq, list) {
-		list_del(&ac->list);
-		ac->sched = false;
-		list_for_each_entry_safe(tid, tid_tmp, &ac->tid_q, list) {
-			list_del(&tid->list);
-			tid->sched = false;
-			ath_tid_drain(sc, txq, tid);
-		}
-	}
-}
-
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -1477,7 +1460,7 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
 }
 
 static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
-			       struct list_head *list, bool retry_tx)
+			       struct list_head *list)
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
@@ -1505,8 +1488,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 			txq->axq_ampdu_depth--;
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0,
-					     retry_tx);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0);
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0);
 	}
@@ -1518,7 +1500,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
  * This assumes output has been stopped and
  * we do not need to block ath_tx_tasklet.
  */
-void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
+void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	ath_txq_lock(sc, txq);
 
@@ -1526,8 +1508,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		int idx = txq->txq_tailidx;
 
 		while (!list_empty(&txq->txq_fifo[idx])) {
-			ath_drain_txq_list(sc, txq, &txq->txq_fifo[idx],
-					   retry_tx);
+			ath_drain_txq_list(sc, txq, &txq->txq_fifo[idx]);
 
 			INCR(idx, ATH_TXFIFO_DEPTH);
 		}
@@ -1536,16 +1517,12 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 
 	txq->axq_link = NULL;
 	txq->axq_tx_inprogress = false;
-	ath_drain_txq_list(sc, txq, &txq->axq_q, retry_tx);
-
-	/* flush any pending frames if aggregation is enabled */
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) && !retry_tx)
-		ath_txq_drain_pending_buffers(sc, txq);
+	ath_drain_txq_list(sc, txq, &txq->axq_q);
 
 	ath_txq_unlock_complete(sc, txq);
 }
 
-bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
+bool ath_drain_all_txq(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -1581,7 +1558,7 @@ bool ath_drain_all_txq(struct ath_softc *sc, bool retry_tx)
 		 */
 		txq = &sc->tx.txq[i];
 		txq->stopped = false;
-		ath_draintxq(sc, txq, retry_tx);
+		ath_draintxq(sc, txq);
 	}
 
 	return !npend;
@@ -2191,7 +2168,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok);
 	} else
-		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
+		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
 		ath_txq_schedule(sc, txq);
-- 
1.8.0.2

