Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46055 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab1H0Wcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 18:32:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: defer ath_tx_setup_buffer setup to the first tx attempt during aggr
Date: Sun, 28 Aug 2011 00:32:25 +0200
Message-Id: <1314484345-7018-5-git-send-email-nbd@openwrt.org> (sfid-20110828_003247_119573_3B4179EC)
In-Reply-To: <1314484345-7018-4-git-send-email-nbd@openwrt.org>
References: <1314484345-7018-1-git-send-email-nbd@openwrt.org>
 <1314484345-7018-2-git-send-email-nbd@openwrt.org>
 <1314484345-7018-3-git-send-email-nbd@openwrt.org>
 <1314484345-7018-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With sequence number and buffer allocation deferred to when they're needed
for the first time, it becomes much easier to start dropping packets from
the tid queue if necessary, e.g. when latency suddenly increases. This can
lead to some future improvements in buffer management for better latency.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |  105 +++++++++++++++++++++------------
 1 files changed, 66 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 00e9191..3d921b3 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -48,8 +48,9 @@ static u16 bits_per_symbol[][2] = {
 #define IS_HT_RATE(_rate)     ((_rate) & 0x80)
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
-			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head);
+			       struct ath_atx_tid *tid, struct sk_buff *skb);
+static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
+			    int tx_flags, struct ath_txq *txq);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
 				struct ath_tx_status *ts, int txok, int sendbar);
@@ -61,6 +62,10 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     int txok, bool update_rc);
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      int seqno);
+static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
+					   struct ath_txq *txq,
+					   struct ath_atx_tid *tid,
+					   struct sk_buff *skb);
 
 enum {
 	MCS_HT20,
@@ -164,14 +169,13 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
-		list_add_tail(&bf->list, &bf_head);
-
 		spin_unlock_bh(&txq->axq_lock);
-		if (fi->retries) {
+		if (bf && fi->retries) {
+			list_add_tail(&bf->list, &bf_head);
 			ath_tx_update_baw(sc, tid, bf->bf_state.seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 1);
 		} else {
-			ath_tx_send_normal(sc, txq, NULL, &bf_head);
+			ath_tx_send_normal(sc, txq, NULL, skb);
 		}
 		spin_lock_bh(&txq->axq_lock);
 	}
@@ -234,6 +238,13 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 		fi = get_frame_info(skb);
 		bf = fi->bf;
 
+		if (!bf) {
+			spin_unlock(&txq->axq_lock);
+			ath_tx_complete(sc, skb, ATH_TX_ERROR, txq);
+			spin_lock(&txq->axq_lock);
+			continue;
+		}
+
 		list_add_tail(&bf->list, &bf_head);
 
 		if (fi->retries)
@@ -757,8 +768,14 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		skb = skb_peek(&tid->buf_q);
 		fi = get_frame_info(skb);
 		bf = fi->bf;
-		seqno = bf->bf_state.seqno;
+		if (!fi->bf)
+			bf = ath_tx_setup_buffer(sc, txq, tid, skb);
 
+		if (!bf)
+			continue;
+
+		bf->bf_state.bf_type |= BUF_AMPDU;
+		seqno = bf->bf_state.seqno;
 		if (!bf_first)
 			bf_first = bf;
 
@@ -1431,13 +1448,11 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 }
 
 static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
-			      struct ath_buf *bf, struct ath_tx_control *txctl)
+			      struct sk_buff *skb, struct ath_tx_control *txctl)
 {
-	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
+	struct ath_frame_info *fi = get_frame_info(skb);
 	struct list_head bf_head;
-	u16 seqno = bf->bf_state.seqno;
-
-	bf->bf_state.bf_type |= BUF_AMPDU;
+	struct ath_buf *bf;
 
 	/*
 	 * Do not queue to h/w when any of the following conditions is true:
@@ -1447,25 +1462,29 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * - h/w queue depth exceeds low water mark
 	 */
 	if (!skb_queue_empty(&tid->buf_q) || tid->paused ||
-	    !BAW_WITHIN(tid->seq_start, tid->baw_size, seqno) ||
+	    !BAW_WITHIN(tid->seq_start, tid->baw_size, tid->seq_next) ||
 	    txctl->txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH) {
 		/*
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
 		TX_STAT_INC(txctl->txq->axq_qnum, a_queued_sw);
-		__skb_queue_tail(&tid->buf_q, bf->bf_mpdu);
+		__skb_queue_tail(&tid->buf_q, skb);
 		if (!txctl->an || !txctl->an->sleeping)
 			ath_tx_queue_tid(txctl->txq, tid);
 		return;
 	}
 
+	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+	if (!bf)
+		return;
+
+	bf->bf_state.bf_type |= BUF_AMPDU;
 	INIT_LIST_HEAD(&bf_head);
 	list_add(&bf->list, &bf_head);
 
 	/* Add sub-frame to BAW */
-	if (!fi->retries)
-		ath_tx_addto_baw(sc, tid, seqno);
+	ath_tx_addto_baw(sc, tid, bf->bf_state.seqno);
 
 	/* Queue to h/w without aggregation */
 	TX_STAT_INC(txctl->txq->axq_qnum, a_queued_hw);
@@ -1475,13 +1494,21 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
-			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head)
+			       struct ath_atx_tid *tid, struct sk_buff *skb)
 {
-	struct ath_frame_info *fi;
+	struct ath_frame_info *fi = get_frame_info(skb);
+	struct list_head bf_head;
 	struct ath_buf *bf;
 
-	bf = list_first_entry(bf_head, struct ath_buf, list);
+	bf = fi->bf;
+	if (!bf)
+		bf = ath_tx_setup_buffer(sc, txq, tid, skb);
+
+	if (!bf)
+		return;
+
+	INIT_LIST_HEAD(&bf_head);
+	list_add_tail(&bf->list, &bf_head);
 	bf->bf_state.bf_type &= ~BUF_AMPDU;
 
 	/* update starting sequence number for subsequent ADDBA request */
@@ -1489,9 +1516,8 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_lastbf = bf;
-	fi = get_frame_info(bf->bf_mpdu);
 	ath_buf_set_rate(sc, bf, fi->framelen);
-	ath_tx_txqaddbuf(sc, txq, bf_head, false);
+	ath_tx_txqaddbuf(sc, txq, &bf_head, false);
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
 
@@ -1714,6 +1740,10 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 
 }
 
+/*
+ * Assign a descriptor (and sequence number if necessary,
+ * and map buffer for DMA. Frees skb on error
+ */
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 					   struct ath_txq *txq,
 					   struct ath_atx_tid *tid,
@@ -1731,7 +1761,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	bf = ath_tx_get_buffer(sc);
 	if (!bf) {
 		ath_dbg(common, ATH_DBG_XMIT, "TX buffers are full\n");
-		return NULL;
+		goto error;
 	}
 
 	ATH_TXBUF_RESET(bf);
@@ -1754,7 +1784,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 		ath_err(ath9k_hw_common(sc->sc_ah),
 			"dma_mapping_error() on TX\n");
 		ath_tx_return_buffer(sc, bf);
-		return NULL;
+		goto error;
 	}
 
 	frm_type = get_hw_packet_type(skb);
@@ -1776,18 +1806,20 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 	fi->bf = bf;
 
 	return bf;
+
+error:
+	dev_kfree_skb_any(skb);
+	return NULL;
 }
 
 /* FIXME: tx power */
-static int ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
+static void ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 			     struct ath_tx_control *txctl)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct list_head bf_head;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf;
-	int ret = 0;
 	u8 tidno;
 
 	spin_lock_bh(&txctl->txq->axq_lock);
@@ -1800,21 +1832,16 @@ static int ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 		WARN_ON(tid->ac->txq != txctl->txq);
 	}
 
-	bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
-	if (unlikely(!bf)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tid) {
 		/*
 		 * Try aggregation if it's a unicast data frame
 		 * and the destination is HT capable.
 		 */
-		ath_tx_send_ampdu(sc, tid, bf, txctl);
+		ath_tx_send_ampdu(sc, tid, skb, txctl);
 	} else {
-		INIT_LIST_HEAD(&bf_head);
-		list_add_tail(&bf->list, &bf_head);
+		bf = ath_tx_setup_buffer(sc, txctl->txq, tid, skb);
+		if (!bf)
+			goto out;
 
 		bf->bf_state.bfs_paprd = txctl->paprd;
 
@@ -1828,12 +1855,11 @@ static int ath_tx_start_dma(struct ath_softc *sc, struct sk_buff *skb,
 		if (tx_info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)
 			ath9k_hw_set_clrdmask(sc->sc_ah, bf->bf_desc, true);
 
-		ath_tx_send_normal(sc, txctl->txq, tid, &bf_head);
+		ath_tx_send_normal(sc, txctl->txq, tid, skb);
 	}
 
 out:
 	spin_unlock_bh(&txctl->txq->axq_lock);
-	return ret;
 }
 
 /* Upon failure caller should free skb */
@@ -1901,7 +1927,8 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	}
 	spin_unlock_bh(&txq->axq_lock);
 
-	return ath_tx_start_dma(sc, skb, txctl);
+	ath_tx_start_dma(sc, skb, txctl);
+	return 0;
 }
 
 /*****************/
-- 
1.7.3.2

