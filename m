Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48074 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755855Ab0KNOUY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:24 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 01/13] ath9k: remove bfs_seqno from struct ath_buf_state
Date: Sun, 14 Nov 2010 15:20:01 +0100
Message-Id: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   44 ++++++++++++++++++++-----------
 2 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5ec99eb..332c2c4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -105,7 +105,6 @@ enum buffer_type {
 #define bf_al           	bf_state.bfs_al
 #define bf_frmlen       	bf_state.bfs_frmlen
 #define bf_retries      	bf_state.bfs_retries
-#define bf_seqno        	bf_state.bfs_seqno
 #define bf_tidno        	bf_state.bfs_tidno
 #define bf_keyix                bf_state.bfs_keyix
 #define bf_keytype      	bf_state.bfs_keytype
@@ -221,7 +220,6 @@ struct ath_buf_state {
 	int bfs_nframes;
 	u16 bfs_al;
 	u16 bfs_frmlen;
-	int bfs_seqno;
 	int bfs_tidno;
 	int bfs_retries;
 	u8 bf_type;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index dc648a5..e84c9c2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -140,6 +140,12 @@ unlock:
 	spin_unlock_bh(&txq->axq_lock);
 }
 
+static u16 ath_frame_seqno(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	return le16_to_cpu(hdr->seq_ctrl) >> IEEE80211_SEQ_SEQ_SHIFT;
+}
+
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = tid->ac->txq;
@@ -157,7 +163,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		list_move_tail(&bf->list, &bf_head);
 
 		if (bf_isretried(bf)) {
-			ath_tx_update_baw(sc, tid, bf->bf_seqno);
+			ath_tx_update_baw(sc, tid, ath_frame_seqno(bf->bf_mpdu));
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 		} else {
 			ath_tx_send_normal(sc, txq, tid, &bf_head);
@@ -184,14 +190,11 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 }
 
 static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
-			     struct ath_buf *bf)
+			     u16 seqno)
 {
 	int index, cindex;
 
-	if (bf_isretried(bf))
-		return;
-
-	index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
+	index  = ATH_BA_INDEX(tid->seq_start, seqno);
 	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 	__set_bit(cindex, tid->tx_buf);
 
@@ -215,6 +218,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	struct ath_tx_status ts;
+	u16 bf_seqno;
 
 	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
@@ -226,8 +230,9 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 		list_move_tail(&bf->list, &bf_head);
 
+		bf_seqno = ath_frame_seqno(bf->bf_mpdu);
 		if (bf_isretried(bf))
-			ath_tx_update_baw(sc, tid, bf->bf_seqno);
+			ath_tx_update_baw(sc, tid, bf_seqno);
 
 		spin_unlock(&txq->axq_lock);
 		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
@@ -316,6 +321,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 	struct ieee80211_tx_rate rates[4];
+	u16 bf_seqno;
 	int nframes;
 
 	skb = bf->bf_mpdu;
@@ -392,8 +398,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		skb = bf->bf_mpdu;
 		tx_info = IEEE80211_SKB_CB(skb);
+		bf_seqno = ath_frame_seqno(skb);
 
-		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf->bf_seqno))) {
+		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf_seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
 			acked_cnt++;
@@ -442,7 +449,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			 * block-ack window
 			 */
 			spin_lock_bh(&txq->axq_lock);
-			ath_tx_update_baw(sc, tid, bf->bf_seqno);
+			ath_tx_update_baw(sc, tid, bf_seqno);
 			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
@@ -471,7 +478,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 					if (!tbf) {
 						spin_lock_bh(&txq->axq_lock);
 						ath_tx_update_baw(sc, tid,
-								bf->bf_seqno);
+								bf_seqno);
 						spin_unlock_bh(&txq->axq_lock);
 
 						bf->bf_state.bf_type |=
@@ -674,14 +681,16 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
 	struct ieee80211_tx_info *tx_info;
+	u16 bf_seqno;
 
 	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
 	do {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
+		bf_seqno = ath_frame_seqno(bf->bf_mpdu);
 
 		/* do not step over block-ack window */
-		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno)) {
+		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, bf_seqno)) {
 			status = ATH_AGGR_BAW_CLOSED;
 			break;
 		}
@@ -726,7 +735,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, 0);
 
 		/* link buffers of this frame to the aggregate */
-		ath_tx_addto_baw(sc, tid, bf);
+		if (!bf_isretried(bf))
+			ath_tx_addto_baw(sc, tid, bf_seqno);
 		ath9k_hw_set11n_aggr_middle(sc->sc_ah, bf->bf_desc, ndelim);
 		list_move_tail(&bf->list, bf_q);
 		if (bf_prev) {
@@ -1288,10 +1298,12 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      struct ath_tx_control *txctl)
 {
 	struct ath_buf *bf;
+	u16 bf_seqno;
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type |= BUF_AMPDU;
 	TX_STAT_INC(txctl->txq->axq_qnum, a_queued);
+	bf_seqno = ath_frame_seqno(bf->bf_mpdu);
 
 	/*
 	 * Do not queue to h/w when any of the following conditions is true:
@@ -1301,7 +1313,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * - h/w queue depth exceeds low water mark
 	 */
 	if (!list_empty(&tid->buf_q) || tid->paused ||
-	    !BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno) ||
+	    !BAW_WITHIN(tid->seq_start, tid->baw_size, bf_seqno) ||
 	    txctl->txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
 		/*
 		 * Add this frame to software queue for scheduling later
@@ -1313,7 +1325,8 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	}
 
 	/* Add sub-frame to BAW */
-	ath_tx_addto_baw(sc, tid, bf);
+	if (!bf_isretried(bf))
+		ath_tx_addto_baw(sc, tid, bf_seqno);
 
 	/* Queue to h/w without aggregation */
 	bf->bf_nframes = 1;
@@ -1394,7 +1407,6 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 	 */
 	tid = ATH_AN_2_TID(an, bf->bf_tidno);
 	hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
-	bf->bf_seqno = tid->seq_next;
 	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
 
@@ -1903,7 +1915,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	while (bf) {
-		ba_index = ATH_BA_INDEX(seq_st, bf->bf_seqno);
+		ba_index = ATH_BA_INDEX(seq_st, ath_frame_seqno(bf->bf_mpdu));
 		if (!txok || (isaggr && !ATH_BA_ISSET(ba, ba_index)))
 			nbad++;
 
-- 
1.7.3.2

