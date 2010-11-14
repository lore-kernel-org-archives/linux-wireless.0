Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48070 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755826Ab0KNOUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 13/13] ath9k: store frame information used by aggregation inside the skb tx info
Date: Sun, 14 Nov 2010 15:20:13 +0100
Message-Id: <1289744413-20789-13-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-12-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
 <1289744413-20789-7-git-send-email-nbd@openwrt.org>
 <1289744413-20789-8-git-send-email-nbd@openwrt.org>
 <1289744413-20789-9-git-send-email-nbd@openwrt.org>
 <1289744413-20789-10-git-send-email-nbd@openwrt.org>
 <1289744413-20789-11-git-send-email-nbd@openwrt.org>
 <1289744413-20789-12-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the pointers after the rates in the tx info cannot be used anymore
after frames have been queued, this area can be used to store information
that was previously stored in the ath_buf. With these changes, we can delay
the ath_buf assignment in the aggregation code until aggregates are formed.

That will not only make it possible to simplify DMA descriptor setup to
do less rewriting of uncached memory, but will also make it easier to
move aggregation out of the core of the ath9k tx path.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   15 ++-
 drivers/net/wireless/ath/ath9k/xmit.c  |  203 ++++++++++++++++----------------
 2 files changed, 109 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index ae876f9..9141ee9 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -89,20 +89,16 @@ struct ath_config {
  * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
  * @BUF_AGGR: Indicates whether the buffer can be aggregated
  *	(used in aggregation scheduling)
- * @BUF_RETRY: Indicates whether the buffer is retried
  * @BUF_XRETRY: To denote excessive retries of the buffer
  */
 enum buffer_type {
 	BUF_AMPDU		= BIT(2),
 	BUF_AGGR		= BIT(3),
-	BUF_RETRY		= BIT(4),
 	BUF_XRETRY		= BIT(5),
 };
 
-#define bf_retries      	bf_state.bfs_retries
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
-#define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
 #define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
 
 #define ATH_TXSTATUS_RING_SIZE 64
@@ -207,8 +203,15 @@ struct ath_atx_ac {
 	struct list_head tid_q;
 };
 
+struct ath_frame_info {
+	int framelen;
+	u32 keyix;
+	enum ath9k_key_type keytype;
+	u8 retries;
+	u16 seqno;
+};
+
 struct ath_buf_state {
-	int bfs_retries;
 	u8 bf_type;
 	u8 bfs_paprd;
 	enum ath9k_internal_frame_type bfs_ftype;
@@ -260,9 +263,9 @@ struct ath_node {
 
 struct ath_tx_control {
 	struct ath_txq *txq;
+	struct ath_node *an;
 	int if_id;
 	enum ath9k_internal_frame_type frame_type;
-	int frmlen;
 	u8 paprd;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 5eeffae..c63e283 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -50,7 +50,7 @@ static u16 bits_per_symbol[][2] = {
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head, int frmlen);
+			       struct list_head *bf_head);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_txq *txq, struct list_head *bf_q,
 				struct ath_tx_status *ts, int txok, int sendbar);
@@ -138,30 +138,12 @@ unlock:
 	spin_unlock_bh(&txq->axq_lock);
 }
 
-static u16 ath_frame_seqno(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	return le16_to_cpu(hdr->seq_ctrl) >> IEEE80211_SEQ_SEQ_SHIFT;
-}
-
-static int ath_frame_len(struct sk_buff *skb)
+static struct ath_frame_info *get_frame_info(struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	int frmlen = skb->len + FCS_LEN;
-	int padpos, padsize;
-
-	/* Remove the padding size, if any */
-	padpos = ath9k_cmn_padpos(hdr->frame_control);
-	padsize = padpos & 3;
-
-	if (padsize && skb->len > padpos + padsize)
-		frmlen -= padsize;
-
-	if (tx_info->control.hw_key)
-		frmlen += tx_info->control.hw_key->icv_len;
-
-	return frmlen;
+	BUILD_BUG_ON(sizeof(struct ath_frame_info) >
+		     sizeof(tx_info->rate_driver_data));
+	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
 }
 
 static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
@@ -170,6 +152,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	struct ath_tx_status ts;
+	struct ath_frame_info *fi;
 
 	INIT_LIST_HEAD(&bf_head);
 
@@ -180,12 +163,12 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 		list_move_tail(&bf->list, &bf_head);
 
-		if (bf_isretried(bf)) {
-			ath_tx_update_baw(sc, tid, ath_frame_seqno(bf->bf_mpdu));
+		fi = get_frame_info(bf->bf_mpdu);
+		if (fi->retries) {
+			ath_tx_update_baw(sc, tid, fi->seqno);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 		} else {
-			ath_tx_send_normal(sc, txq, tid, &bf_head,
-					   ath_frame_len(bf->bf_mpdu));
+			ath_tx_send_normal(sc, txq, tid, &bf_head);
 		}
 	}
 
@@ -237,7 +220,7 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	struct ath_tx_status ts;
-	u16 bf_seqno;
+	struct ath_frame_info *fi;
 
 	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
@@ -249,9 +232,9 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 		list_move_tail(&bf->list, &bf_head);
 
-		bf_seqno = ath_frame_seqno(bf->bf_mpdu);
-		if (bf_isretried(bf))
-			ath_tx_update_baw(sc, tid, bf_seqno);
+		fi = get_frame_info(bf->bf_mpdu);
+		if (fi->retries)
+			ath_tx_update_baw(sc, tid, fi->seqno);
 
 		spin_unlock(&txq->axq_lock);
 		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
@@ -263,16 +246,15 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 }
 
 static void ath_tx_set_retry(struct ath_softc *sc, struct ath_txq *txq,
-			     struct ath_buf *bf)
+			     struct sk_buff *skb)
 {
-	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr;
 
-	bf->bf_state.bf_type |= BUF_RETRY;
-	bf->bf_retries++;
 	TX_STAT_INC(txq->axq_qnum, a_retries);
+	if (tx_info->control.rates[4].count++ > 0)
+		return;
 
-	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
 }
@@ -326,6 +308,7 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 			        struct ath_tx_status *ts, int txok,
 			        int *nframes, int *nbad)
 {
+	struct ath_frame_info *fi;
 	u16 seq_st = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int ba_index;
@@ -341,7 +324,8 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	while (bf) {
-		ba_index = ATH_BA_INDEX(seq_st, ath_frame_seqno(bf->bf_mpdu));
+		fi = get_frame_info(bf->bf_mpdu);
+		ba_index = ATH_BA_INDEX(seq_st, fi->seqno);
 
 		(*nframes)++;
 		if (!txok || (isaggr && !ATH_BA_ISSET(ba, ba_index)))
@@ -370,7 +354,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0, nbad = 0;
 	bool rc_update = true;
 	struct ieee80211_tx_rate rates[4];
-	u16 bf_seqno;
+	struct ath_frame_info *fi;
 	int nframes;
 	u8 tidno;
 
@@ -448,9 +432,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		skb = bf->bf_mpdu;
 		tx_info = IEEE80211_SKB_CB(skb);
-		bf_seqno = ath_frame_seqno(skb);
+		fi = get_frame_info(skb);
 
-		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, bf_seqno))) {
+		if (ATH_BA_ISSET(ba, ATH_BA_INDEX(seq_st, fi->seqno))) {
 			/* transmit completion, subframe is
 			 * acked by block ack */
 			acked_cnt++;
@@ -459,8 +443,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			acked_cnt++;
 		} else {
 			if (!(tid->state & AGGR_CLEANUP) && retry) {
-				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
-					ath_tx_set_retry(sc, txq, bf);
+				if (fi->retries < ATH_MAX_SW_RETRIES) {
+					ath_tx_set_retry(sc, txq, bf->bf_mpdu);
 					txpending = 1;
 				} else {
 					bf->bf_state.bf_type |= BUF_XRETRY;
@@ -498,7 +482,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			 * block-ack window
 			 */
 			spin_lock_bh(&txq->axq_lock);
-			ath_tx_update_baw(sc, tid, bf_seqno);
+			ath_tx_update_baw(sc, tid, fi->seqno);
 			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
@@ -525,8 +509,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 					 */
 					if (!tbf) {
 						spin_lock_bh(&txq->axq_lock);
-						ath_tx_update_baw(sc, tid,
-								bf_seqno);
+						ath_tx_update_baw(sc, tid, fi->seqno);
 						spin_unlock_bh(&txq->axq_lock);
 
 						bf->bf_state.bf_type |=
@@ -666,6 +649,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	u16 minlen;
 	u8 flags, rix;
 	int width, streams, half_gi, ndelim, mindelim;
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
 
 	/* Select standard number of delimiters based on frame length alone */
 	ndelim = ATH_AGGR_GET_NDELIM(frmlen);
@@ -676,7 +660,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * TODO - this could be improved to be dependent on the rate.
 	 *      The hardware can keep up at lower rates, but not higher rates
 	 */
-	if (tx_info->control.hw_key)
+	if (fi->keyix != ATH9K_TXKEYIX_INVALID)
 		ndelim += ATH_AGGR_ENCRYPTDELIM;
 
 	/*
@@ -730,17 +714,16 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
 	struct ieee80211_tx_info *tx_info;
-	int frmlen;
-	u16 bf_seqno;
+	struct ath_frame_info *fi;
 
 	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
 	do {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
-		bf_seqno = ath_frame_seqno(bf->bf_mpdu);
+		fi = get_frame_info(bf->bf_mpdu);
 
 		/* do not step over block-ack window */
-		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, bf_seqno)) {
+		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, fi->seqno)) {
 			status = ATH_AGGR_BAW_CLOSED;
 			break;
 		}
@@ -751,8 +734,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		}
 
 		/* do not exceed aggregation limit */
-		frmlen = ath_frame_len(bf->bf_mpdu);
-		al_delta = ATH_AGGR_DELIM_SZ + frmlen;
+		al_delta = ATH_AGGR_DELIM_SZ + fi->framelen;
 
 		if (nframes &&
 		    (aggr_limit < (al + bpad + al_delta + prev_al))) {
@@ -779,15 +761,15 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		 * Get the delimiters needed to meet the MPDU
 		 * density for this node.
 		 */
-		ndelim = ath_compute_num_delims(sc, tid, bf_first, frmlen);
+		ndelim = ath_compute_num_delims(sc, tid, bf_first, fi->framelen);
 		bpad = PADBYTES(al_delta) + (ndelim << 2);
 
 		bf->bf_next = NULL;
 		ath9k_hw_set_desc_link(sc->sc_ah, bf->bf_desc, 0);
 
 		/* link buffers of this frame to the aggregate */
-		if (!bf_isretried(bf))
-			ath_tx_addto_baw(sc, tid, bf_seqno);
+		if (!fi->retries)
+			ath_tx_addto_baw(sc, tid, fi->seqno);
 		ath9k_hw_set11n_aggr_middle(sc->sc_ah, bf->bf_desc, ndelim);
 		list_move_tail(&bf->list, bf_q);
 		if (bf_prev) {
@@ -810,6 +792,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 {
 	struct ath_buf *bf;
 	enum ATH_AGGR_STATUS status;
+	struct ath_frame_info *fi;
 	struct list_head bf_q;
 	int aggr_len;
 
@@ -833,9 +816,11 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		/* if only one frame, send as non-aggregate */
 		if (bf == bf->bf_lastbf) {
+			fi = get_frame_info(bf->bf_mpdu);
+
 			bf->bf_state.bf_type &= ~BUF_AGGR;
 			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
-			ath_buf_set_rate(sc, bf, ath_frame_len(bf->bf_mpdu));
+			ath_buf_set_rate(sc, bf, fi->framelen);
 			ath_tx_txqaddbuf(sc, txq, &bf_q);
 			continue;
 		}
@@ -1346,12 +1331,11 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      struct ath_buf *bf, struct ath_tx_control *txctl)
 {
+	struct ath_frame_info *fi = get_frame_info(bf->bf_mpdu);
 	struct list_head bf_head;
-	u16 bf_seqno;
 
 	bf->bf_state.bf_type |= BUF_AMPDU;
 	TX_STAT_INC(txctl->txq->axq_qnum, a_queued);
-	bf_seqno = ath_frame_seqno(bf->bf_mpdu);
 
 	/*
 	 * Do not queue to h/w when any of the following conditions is true:
@@ -1361,7 +1345,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	 * - h/w queue depth exceeds low water mark
 	 */
 	if (!list_empty(&tid->buf_q) || tid->paused ||
-	    !BAW_WITHIN(tid->seq_start, tid->baw_size, bf_seqno) ||
+	    !BAW_WITHIN(tid->seq_start, tid->baw_size, fi->seqno) ||
 	    txctl->txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
 		/*
 		 * Add this frame to software queue for scheduling later
@@ -1376,19 +1360,20 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	list_add(&bf->list, &bf_head);
 
 	/* Add sub-frame to BAW */
-	if (!bf_isretried(bf))
-		ath_tx_addto_baw(sc, tid, bf_seqno);
+	if (!fi->retries)
+		ath_tx_addto_baw(sc, tid, fi->seqno);
 
 	/* Queue to h/w without aggregation */
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, txctl->frmlen);
+	ath_buf_set_rate(sc, bf, fi->framelen);
 	ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 			       struct ath_atx_tid *tid,
-			       struct list_head *bf_head, int frmlen)
+			       struct list_head *bf_head)
 {
+	struct ath_frame_info *fi;
 	struct ath_buf *bf;
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
@@ -1399,7 +1384,8 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 		INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_lastbf = bf;
-	ath_buf_set_rate(sc, bf, frmlen);
+	fi = get_frame_info(bf->bf_mpdu);
+	ath_buf_set_rate(sc, bf, fi->framelen);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
 	TX_STAT_INC(txq->axq_qnum, queued);
 }
@@ -1427,30 +1413,49 @@ static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 	return htype;
 }
 
-static void assign_aggr_tid_seqno(struct sk_buff *skb)
+static void setup_frame_info(struct ieee80211_hw *hw, struct sk_buff *skb,
+			     int framelen)
 {
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = tx_info->control.sta;
+	struct ieee80211_key_conf *hw_key = tx_info->control.hw_key;
 	struct ieee80211_hdr *hdr;
+	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_node *an;
 	struct ath_atx_tid *tid;
-	__le16 fc;
+	enum ath9k_key_type keytype;
+	u16 seqno = 0;
 	u8 tidno;
 
-	if (!tx_info->control.sta)
-		return;
+	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
 
-	an = (struct ath_node *)tx_info->control.sta->drv_priv;
 	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-	tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
+	if (sta && ieee80211_is_data_qos(hdr->frame_control) &&
+		conf_is_ht(&hw->conf) && (sc->sc_flags & SC_OP_TXAGGR)) {
 
-	/*
-	 * Override seqno set by upper layer with the one
-	 * in tx aggregation state.
-	 */
-	tid = ATH_AN_2_TID(an, tidno);
-	hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
-	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
+		an = (struct ath_node *) sta->drv_priv;
+		tidno = ieee80211_get_qos_ctl(hdr)[0] & IEEE80211_QOS_CTL_TID_MASK;
+
+		/*
+		 * Override seqno set by upper layer with the one
+		 * in tx aggregation state.
+		 */
+		tid = ATH_AN_2_TID(an, tidno);
+		seqno = tid->seq_next;
+		hdr->seq_ctrl = cpu_to_le16(seqno << IEEE80211_SEQ_SEQ_SHIFT);
+		INCR(tid->seq_next, IEEE80211_SEQ_MAX);
+	}
+
+	memset(fi, 0, sizeof(*fi));
+	if (hw_key)
+		fi->keyix = hw_key->hw_key_idx;
+	else
+		fi->keyix = ATH9K_TXKEYIX_INVALID;
+	fi->keytype = keytype;
+	fi->framelen = framelen;
+	fi->seqno = seqno;
 }
 
 static int setup_tx_flags(struct sk_buff *skb)
@@ -1609,18 +1614,15 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf, int len)
 
 static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 					   struct ath_txq *txq,
-					   struct sk_buff *skb, int frmlen)
+					   struct sk_buff *skb)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb;
+	struct ath_frame_info *fi = get_frame_info(skb);
 	struct ath_buf *bf;
 	struct ath_desc *ds;
-	enum ath9k_key_type keytype;
-	u32 keyix;
 	int frm_type;
 
 	bf = ath_tx_get_buffer(sc);
@@ -1631,10 +1633,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 
 	ATH_TXBUF_RESET(bf);
 
-	if (ieee80211_is_data_qos(hdr->frame_control) &&
-		conf_is_ht(&hw->conf) && (sc->sc_flags & SC_OP_TXAGGR))
-			assign_aggr_tid_seqno(skb);
-
 	bf->aphy = aphy;
 	bf->bf_flags = setup_tx_flags(skb);
 	bf->bf_mpdu = skb;
@@ -1655,14 +1653,8 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 	ds = bf->bf_desc;
 	ath9k_hw_set_desc_link(ah, ds, 0);
 
-	keytype = ath9k_cmn_get_hw_crypto_keytype(skb);
-	if (tx_info->control.hw_key)
-		keyix = tx_info->control.hw_key->hw_key_idx;
-	else
-		keyix = ATH9K_TXKEYIX_INVALID;
-
-	ath9k_hw_set11n_txdesc(ah, ds, frmlen, frm_type, MAX_RATE_POWER,
-			       keyix, keytype, bf->bf_flags);
+	ath9k_hw_set11n_txdesc(ah, ds, fi->framelen, frm_type, MAX_RATE_POWER,
+			       fi->keyix, fi->keytype, bf->bf_flags);
 
 	ath9k_hw_filltxdesc(ah, ds,
 			    skb->len,	/* segment length */
@@ -1683,18 +1675,16 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ath_node *an = NULL;
 	struct list_head bf_head;
 	struct ath_atx_tid *tid;
 	u8 tidno;
 
 	spin_lock_bh(&txctl->txq->axq_lock);
 
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && tx_info->control.sta) {
-		an = (struct ath_node *)tx_info->control.sta->drv_priv;
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && txctl->an) {
 		tidno = ieee80211_get_qos_ctl(hdr)[0] &
 			IEEE80211_QOS_CTL_TID_MASK;
-		tid = ATH_AN_2_TID(an, tidno);
+		tid = ATH_AN_2_TID(txctl->an, tidno);
 
 		WARN_ON(tid->ac->txq != txctl->txq);
 		/*
@@ -1713,7 +1703,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			ar9003_hw_set_paprd_txdesc(sc->sc_ah, bf->bf_desc,
 						   bf->bf_state.bfs_paprd);
 
-		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head, txctl->frmlen);
+		ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head);
 	}
 
 	spin_unlock_bh(&txctl->txq->axq_lock);
@@ -1725,6 +1715,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_sta *sta = info->control.sta;
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_txq *txq = txctl->txq;
@@ -1733,11 +1724,10 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 	int frmlen = skb->len + FCS_LEN;
 	int q;
 
+	txctl->an = (struct ath_node *)sta->drv_priv;
 	if (info->control.hw_key)
 		frmlen += info->control.hw_key->icv_len;
 
-	txctl->frmlen = frmlen;
-
 	/*
 	 * As a temporary workaround, assign seq# here; this will likely need
 	 * to be cleaned up to work better with Beacon transmission and virtual
@@ -1761,7 +1751,14 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		memmove(skb->data, skb->data + padsize, padpos);
 	}
 
-	bf = ath_tx_setup_buffer(hw, txctl->txq, skb, frmlen);
+	setup_frame_info(hw, skb, frmlen);
+
+	/*
+	 * At this point, the vif, hw_key and sta pointers in the tx control
+	 * info are no longer valid (overwritten by the ath_frame_info data.
+	 */
+
+	bf = ath_tx_setup_buffer(hw, txctl->txq, skb);
 	if (unlikely(!bf))
 		return -ENOMEM;
 
-- 
1.7.3.2

