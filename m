Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51193 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911Ab3FCR2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 13:28:33 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 1/2] ath9k: add support for IEEE80211_TX_CTL_NO_PS_BUFFER
Date: Mon,  3 Jun 2013 15:27:18 +0200
Message-Id: <1370266039-60971-1-git-send-email-nbd@openwrt.org> (sfid-20130603_192837_955337_C6485A59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the UAPSD hardware queue to get PS-Poll responses out as fast as
possible and without backoff.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  2 ++
 drivers/net/wireless/ath/ath9k/xmit.c  | 43 +++++++++++++++++++++-------------
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 18fcee4..4f79827 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -296,6 +296,7 @@ struct ath_tx {
 	struct ath_txq txq[ATH9K_NUM_TX_QUEUES];
 	struct ath_descdma txdma;
 	struct ath_txq *txq_map[IEEE80211_NUM_ACS];
+	struct ath_txq *uapsdq;
 	u32 txq_max_pending[IEEE80211_NUM_ACS];
 	u16 max_aggr_framelen[IEEE80211_NUM_ACS][4][32];
 };
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f908dc1..21aa0519 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -432,6 +432,8 @@ static int ath9k_init_queues(struct ath_softc *sc)
 	sc->config.cabqReadytime = ATH_CABQ_READY_TIME;
 	ath_cabq_update(sc);
 
+	sc->tx.uapsdq = ath_txq_setup(sc, ATH9K_TX_QUEUE_UAPSD, 0);
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		sc->tx.txq_map[i] = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, i);
 		sc->tx.txq_map[i]->mac80211_qnum = i;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 1c9b1ba..6164509 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1681,8 +1681,9 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	}
 }
 
-static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
-			      struct sk_buff *skb, struct ath_tx_control *txctl)
+static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_txq *txq,
+			      struct ath_atx_tid *tid, struct sk_buff *skb,
+			      struct ath_tx_control *txctl)
 {
 	struct ath_frame_info *fi = get_frame_info(skb);
 	struct list_head bf_head;
@@ -1695,21 +1696,22 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * - seqno is not within block-ack window
 	 * - h/w queue depth exceeds low water mark
 	 */
-	if (!skb_queue_empty(&tid->buf_q) || tid->paused ||
-	    !BAW_WITHIN(tid->seq_start, tid->baw_size, tid->seq_next) ||
-	    txctl->txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) {
+	if ((!skb_queue_empty(&tid->buf_q) || tid->paused ||
+	     !BAW_WITHIN(tid->seq_start, tid->baw_size, tid->seq_next) ||
+	     txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) &&
+	    txq != sc->tx.uapsdq) {
 		/*
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
-		TX_STAT_INC(txctl->txq->axq_qnum, a_queued_sw);
+		TX_STAT_INC(txq->axq_qnum, a_queued_sw);
 		__skb_queue_tail(&tid->buf_q, skb);
 		if (!txctl->an || !txctl->an->sleeping)
-			ath_tx_queue_tid(txctl->txq, tid);
+			ath_tx_queue_tid(txq, tid);
 		return;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 	if (!bf) {
 		ieee80211_free_txskb(sc->hw, skb);
 		return;
@@ -1724,10 +1726,10 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
 
 	/* Queue to h/w without aggregation */
-	TX_STAT_INC(txctl->txq->axq_qnum, a_queued_hw);
+	TX_STAT_INC(txq->axq_qnum, a_queued_hw);
 	bf->bf_lastbf = bf;
-	ath_tx_fill_desc(sc, bf, txctl->txq, fi->framelen);
-	ath_tx_txqaddbuf(sc, txctl->txq, &bf_head, false);
+	ath_tx_fill_desc(sc, bf, txq, fi->framelen);
+	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
@@ -1935,6 +1937,12 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
+	if (info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER) {
+		ath_txq_unlock(sc, txq);
+		txq = sc->tx.uapsdq;
+		ath_txq_lock(sc, txq);
+	}
+
 	if (txctl->an && ieee80211_is_data_qos(hdr->frame_control)) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
@@ -1948,11 +1956,11 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		 * Try aggregation if it's a unicast data frame
 		 * and the destination is HT capable.
 		 */
-		ath_tx_send_ampdu(sc, tid, skb, txctl);
+		ath_tx_send_ampdu(sc, txq, tid, skb, txctl);
 		goto out;
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 	if (!bf) {
 		if (txctl->paprd)
 			dev_kfree_skb_any(skb);
@@ -1967,7 +1975,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		bf->bf_state.bfs_paprd_timestamp = jiffies;
 
 	ath_set_rates(vif, sta, bf);
-	ath_tx_send_normal(sc, txctl->txq, tid, skb);
+	ath_tx_send_normal(sc, txq, tid, skb);
 
 out:
 	ath_txq_unlock(sc, txq);
@@ -2020,7 +2028,12 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	}
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 
+	__skb_queue_tail(&txq->complete_q, skb);
+
 	q = skb_get_queue_mapping(skb);
+	if (txq == sc->tx.uapsdq)
+		txq = sc->tx.txq_map[q];
+
 	if (txq == sc->tx.txq_map[q]) {
 		if (WARN_ON(--txq->pending_frames < 0))
 			txq->pending_frames = 0;
@@ -2031,8 +2044,6 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 			txq->stopped = false;
 		}
 	}
-
-	__skb_queue_tail(&txq->complete_q, skb);
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
-- 
1.8.0.2

