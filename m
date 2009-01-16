Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46738 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494AbZAPQMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:12:12 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:12:12 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45333.784498.245803@gargle.gargle.HOWL> (sfid-20090116_171221_215766_61B27532)
Date: Fri, 16 Jan 2009 21:38:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 8/9] ath9k: Revamp TX aggregation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up the convoluted buffer management
logic for TX aggregation. Both aggregation creation and
completion are addressed.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   10 --
 drivers/net/wireless/ath9k/xmit.c |  305 +++++++++++-------------------------
 2 files changed, 93 insertions(+), 222 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 04bc6fd..f65933d 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -187,7 +187,6 @@ struct ath_config {
 #define ATH_TXBUF_RESET(_bf) do {				\
 		(_bf)->bf_status = 0;				\
 		(_bf)->bf_lastbf = NULL;			\
-		(_bf)->bf_lastfrm = NULL;			\
 		(_bf)->bf_next = NULL;				\
 		memset(&((_bf)->bf_state), 0,			\
 			    sizeof(struct ath_buf_state));	\
@@ -245,10 +244,8 @@ struct ath_buf_state {
  */
 struct ath_buf {
 	struct list_head list;
-	struct list_head *last;
 	struct ath_buf *bf_lastbf;	/* last buf of this unit (a frame or
 					   an aggregate) */
-	struct ath_buf *bf_lastfrm;	/* last buf of this frame */
 	struct ath_buf *bf_next;	/* next subframe in the aggregate */
 	void *bf_mpdu;			/* enclosing frame structure */
 	struct ath_desc *bf_desc;	/* virtual addr of desc */
@@ -261,13 +258,7 @@ struct ath_buf {
 };
 
 #define ATH_RXBUF_RESET(_bf)    ((_bf)->bf_status = 0)
-
-/* hw processing complete, desc processed by hal */
-#define ATH_BUFSTATUS_DONE      0x00000001
-/* hw processing complete, desc hold for hw */
 #define ATH_BUFSTATUS_STALE     0x00000002
-/* Rx-only: OS is done with this packet and it's ok to queued it to hw */
-#define ATH_BUFSTATUS_FREE      0x00000004
 
 /* DMA state for tx/rx descriptors */
 
@@ -360,7 +351,6 @@ struct ath_txq {
 	u32 *axq_link;			/* link ptr in last TX desc */
 	struct list_head axq_q;		/* transmit queue */
 	spinlock_t axq_lock;
-	unsigned long axq_lockflags;	/* intr state when must cli */
 	u32 axq_depth;			/* queue depth */
 	u8 axq_aggr_depth;		/* aggregates queued */
 	u32 axq_totalqueued;		/* total ever queued */
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index d7cec0f..0d05a7f 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -151,7 +151,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	while (!list_empty(&tid->buf_q)) {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 		ASSERT(!bf_isretried(bf));
-		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
+		list_move_tail(&bf->list, &bf_head);
 		ath_tx_send_normal(sc, txq, tid, &bf_head);
 	}
 
@@ -212,9 +212,9 @@ static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
 	for (;;) {
 		if (list_empty(&tid->buf_q))
 			break;
-		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
-		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
+		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
+		list_move_tail(&bf->list, &bf_head);
 
 		if (bf_isretried(bf))
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
@@ -241,17 +241,37 @@ static void ath_tx_set_retry(struct ath_softc *sc, struct ath_buf *bf)
 	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
 }
 
-static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
-				      struct ath_buf *bf, struct list_head *bf_q,
-				      int txok)
+static struct ath_buf* ath_clone_txbuf(struct ath_softc *sc, struct ath_buf *bf)
+{
+	struct ath_buf *tbf;
+
+	spin_lock_bh(&sc->tx.txbuflock);
+	ASSERT(!list_empty((&sc->tx.txbuf)));
+	tbf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
+	list_del(&tbf->list);
+	spin_unlock_bh(&sc->tx.txbuflock);
+
+	ATH_TXBUF_RESET(tbf);
+
+	tbf->bf_mpdu = bf->bf_mpdu;
+	tbf->bf_buf_addr = bf->bf_buf_addr;
+	*(tbf->bf_desc) = *(bf->bf_desc);
+	tbf->bf_state = bf->bf_state;
+	tbf->bf_dmacontext = bf->bf_dmacontext;
+
+	return tbf;
+}
+
+static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
+				 struct ath_buf *bf, struct list_head *bf_q,
+				 int txok)
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
 	struct ath_atx_tid *tid = NULL;
-	struct ath_buf *bf_last = bf->bf_lastbf;
+	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
 	struct ath_desc *ds = bf_last->bf_desc;
-	struct ath_buf *bf_next, *bf_lastq = NULL;
 	struct list_head bf_head, bf_pending;
 	u16 seq_st = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
@@ -266,28 +286,23 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	isaggr = bf_isaggr(bf);
-	if (isaggr) {
-		if (txok) {
-			if (ATH_DS_TX_BA(ds)) {
-				seq_st = ATH_DS_BA_SEQ(ds);
-				memcpy(ba, ATH_DS_BA_BITMAP(ds),
-				       WME_BA_BMP_SIZE >> 3);
-			} else {
-				memset(ba, 0, WME_BA_BMP_SIZE >> 3);
+	memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 
-				/*
-				 * AR5416 can become deaf/mute when BA
-				 * issue happens. Chip needs to be reset.
-				 * But AP code may have sychronization issues
-				 * when perform internal reset in this routine.
-				 * Only enable reset in STA mode for now.
-				 */
-				if (sc->sc_ah->ah_opmode ==
-					    NL80211_IFTYPE_STATION)
-					needreset = 1;
-			}
+	if (isaggr && txok) {
+		if (ATH_DS_TX_BA(ds)) {
+			seq_st = ATH_DS_BA_SEQ(ds);
+			memcpy(ba, ATH_DS_BA_BITMAP(ds),
+			       WME_BA_BMP_SIZE >> 3);
 		} else {
-			memset(ba, 0, WME_BA_BMP_SIZE >> 3);
+			/*
+			 * AR5416 can become deaf/mute when BA
+			 * issue happens. Chip needs to be reset.
+			 * But AP code may have sychronization issues
+			 * when perform internal reset in this routine.
+			 * Only enable reset in STA mode for now.
+			 */
+			if (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION)
+				needreset = 1;
 		}
 	}
 
@@ -304,7 +319,6 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
 		} else if (!isaggr && txok) {
 			/* transmit completion */
 		} else {
-
 			if (!(tid->state & AGGR_CLEANUP) &&
 			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
@@ -325,19 +339,10 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
 		}
 
 		if (bf_next == NULL) {
-			ASSERT(bf->bf_lastfrm == bf_last);
-			if (!list_empty(bf_q)) {
-				bf_lastq = list_entry(bf_q->prev,
-					struct ath_buf, list);
-				list_cut_position(&bf_head,
-					bf_q, &bf_lastq->list);
-			} else {
-				INIT_LIST_HEAD(&bf_head);
-			}
+			INIT_LIST_HEAD(&bf_head);
 		} else {
 			ASSERT(!list_empty(bf_q));
-			list_cut_position(&bf_head,
-				bf_q, &bf->bf_lastfrm->list);
+			list_move_tail(&bf->list, &bf_head);
 		}
 
 		if (!txpending) {
@@ -351,53 +356,20 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
 
 			ath_tx_complete_buf(sc, bf, &bf_head, !txfail, sendbar);
 		} else {
-			/*
-			 * retry the un-acked ones
-			 */
+			/* retry the un-acked ones */
 			if (bf->bf_next == NULL &&
 			    bf_last->bf_status & ATH_BUFSTATUS_STALE) {
 				struct ath_buf *tbf;
 
-				/* allocate new descriptor */
-				spin_lock_bh(&sc->tx.txbuflock);
-				ASSERT(!list_empty((&sc->tx.txbuf)));
-				tbf = list_first_entry(&sc->tx.txbuf,
-						struct ath_buf, list);
-				list_del(&tbf->list);
-				spin_unlock_bh(&sc->tx.txbuflock);
-
-				ATH_TXBUF_RESET(tbf);
-
-				/* copy descriptor content */
-				tbf->bf_mpdu = bf_last->bf_mpdu;
-				tbf->bf_buf_addr = bf_last->bf_buf_addr;
-				*(tbf->bf_desc) = *(bf_last->bf_desc);
-
-				/* link it to the frame */
-				if (bf_lastq) {
-					bf_lastq->bf_desc->ds_link =
-						tbf->bf_daddr;
-					bf->bf_lastfrm = tbf;
-					ath9k_hw_cleartxdesc(sc->sc_ah,
-						bf->bf_lastfrm->bf_desc);
-				} else {
-					tbf->bf_state = bf_last->bf_state;
-					tbf->bf_lastfrm = tbf;
-					ath9k_hw_cleartxdesc(sc->sc_ah,
-						tbf->bf_lastfrm->bf_desc);
-
-					/* copy the DMA context */
-					tbf->bf_dmacontext =
-						bf_last->bf_dmacontext;
-				}
+				tbf = ath_clone_txbuf(sc, bf_last);
+				ath9k_hw_cleartxdesc(sc->sc_ah, tbf->bf_desc);
 				list_add_tail(&tbf->list, &bf_head);
 			} else {
 				/*
 				 * Clear descriptor status words for
 				 * software retry
 				 */
-				ath9k_hw_cleartxdesc(sc->sc_ah,
-						     bf->bf_lastfrm->bf_desc);
+				ath9k_hw_cleartxdesc(sc->sc_ah, bf->bf_desc);
 			}
 
 			/*
@@ -411,27 +383,18 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
 	}
 
 	if (tid->state & AGGR_CLEANUP) {
-		/* check to see if we're done with cleaning the h/w queue */
-		spin_lock_bh(&txq->axq_lock);
-
 		if (tid->baw_head == tid->baw_tail) {
 			tid->state &= ~AGGR_ADDBA_COMPLETE;
 			tid->addba_exchangeattempts = 0;
-			spin_unlock_bh(&txq->axq_lock);
-
 			tid->state &= ~AGGR_CLEANUP;
 
 			/* send buffered frames as singles */
 			ath_tx_flush_tid(sc, tid);
-		} else
-			spin_unlock_bh(&txq->axq_lock);
-
+		}
 		return;
 	}
 
-	/*
-	 * prepend un-acked frames to the beginning of the pending frame queue
-	 */
+	/* prepend un-acked frames to the beginning of the pending frame queue */
 	if (!list_empty(&bf_pending)) {
 		spin_lock_bh(&txq->axq_lock);
 		list_splice(&bf_pending, &tid->buf_q);
@@ -441,8 +404,6 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
 
 	if (needreset)
 		ath_reset(sc, false);
-
-	return;
 }
 
 static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
@@ -453,15 +414,14 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
 	struct ath_tx_info_priv *tx_info_priv;
-	u32 max_4ms_framelen, frame_length;
+	u32 max_4ms_framelen, frmlen;
 	u16 aggr_limit, legacy = 0, maxampdu;
 	int i;
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
 	rates = tx_info->control.rates;
-	tx_info_priv =
-		(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
+	tx_info_priv = (struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
 
 	/*
 	 * Find the lowest frame length among the rate series that will have a
@@ -477,9 +437,8 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 				break;
 			}
 
-			frame_length =
-				rate_table->info[rates[i].idx].max_4ms_framelen;
-			max_4ms_framelen = min(max_4ms_framelen, frame_length);
+			frmlen = rate_table->info[rates[i].idx].max_4ms_framelen;
+			max_4ms_framelen = min(max_4ms_framelen, frmlen);
 		}
 	}
 
@@ -491,8 +450,7 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 	if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE || legacy)
 		return 0;
 
-	aggr_limit = min(max_4ms_framelen,
-		(u32)ATH_AMPDU_LIMIT_DEFAULT);
+	aggr_limit = min(max_4ms_framelen, (u32)ATH_AMPDU_LIMIT_DEFAULT);
 
 	/*
 	 * h/w can accept aggregates upto 16 bit lengths (65535).
@@ -507,9 +465,9 @@ static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 }
 
 /*
- * returns the number of delimiters to be added to
+ * Returns the number of delimiters to be added to
  * meet the minimum required mpdudensity.
- * caller should make sure that the rate is  HT rate .
+ * caller should make sure that the rate is HT rate .
  */
 static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 				  struct ath_buf *bf, u16 frmlen)
@@ -566,9 +524,7 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 	nsymbits = bits_per_symbol[HT_RC_2_MCS(rc)][width];
 	minlen = (nsymbols * nsymbits) / BITS_PER_BYTE;
 
-	/* Is frame shorter than required minimum length? */
 	if (frmlen < minlen) {
-		/* Get the minimum number of delimiters required. */
 		mindelim = (minlen - frmlen) / ATH_AGGR_DELIM_SZ;
 		ndelim = max(mindelim, ndelim);
 	}
@@ -577,30 +533,22 @@ static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
 }
 
 static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
-		     struct ath_atx_tid *tid, struct list_head *bf_q,
-		     struct ath_buf **bf_last, struct aggr_rifs_param *param,
-		     int *prev_frames)
+					     struct ath_atx_tid *tid,
+					     struct list_head *bf_q)
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
-	struct ath_buf *bf, *tbf, *bf_first, *bf_prev = NULL;
-	struct list_head bf_head;
-	int rl = 0, nframes = 0, ndelim;
+	struct ath_buf *bf, *bf_first, *bf_prev = NULL;
+	int rl = 0, nframes = 0, ndelim, prev_al = 0;
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
-	int prev_al = 0;
-	INIT_LIST_HEAD(&bf_head);
-
-	BUG_ON(list_empty(&tid->buf_q));
 
 	bf_first = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
 	do {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
-		/*
-		 * do not step over block-ack window
-		 */
+		/* do not step over block-ack window */
 		if (!BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno)) {
 			status = ATH_AGGR_BAW_CLOSED;
 			break;
@@ -611,29 +559,23 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 			rl = 1;
 		}
 
-		/*
-		 * do not exceed aggregation limit
-		 */
+		/* do not exceed aggregation limit */
 		al_delta = ATH_AGGR_DELIM_SZ + bf->bf_frmlen;
 
-		if (nframes && (aggr_limit <
-			(al + bpad + al_delta + prev_al))) {
+		if (nframes &&
+		    (aggr_limit < (al + bpad + al_delta + prev_al))) {
 			status = ATH_AGGR_LIMITED;
 			break;
 		}
 
-		/*
-		 * do not exceed subframe limit
-		 */
-		if ((nframes + *prev_frames) >=
-		    min((int)h_baw, ATH_AMPDU_SUBFRAME_DEFAULT)) {
+		/* do not exceed subframe limit */
+		if (nframes >= min((int)h_baw, ATH_AMPDU_SUBFRAME_DEFAULT)) {
 			status = ATH_AGGR_LIMITED;
 			break;
 		}
+		nframes++;
 
-		/*
-		 * add padding for previous frame to aggregation length
-		 */
+		/* add padding for previous frame to aggregation length */
 		al += bpad + al_delta;
 
 		/*
@@ -641,44 +583,25 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		 * density for this node.
 		 */
 		ndelim = ath_compute_num_delims(sc, tid, bf_first, bf->bf_frmlen);
-
 		bpad = PADBYTES(al_delta) + (ndelim << 2);
 
 		bf->bf_next = NULL;
-		bf->bf_lastfrm->bf_desc->ds_link = 0;
+		bf->bf_desc->ds_link = 0;
 
-		/*
-		 * this packet is part of an aggregate
-		 * - remove all descriptors belonging to this frame from
-		 *   software queue
-		 * - add it to block ack window
-		 * - set up descriptors for aggregation
-		 */
-		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
+		/* link buffers of this frame to the aggregate */
 		ath_tx_addto_baw(sc, tid, bf);
-
-		list_for_each_entry(tbf, &bf_head, list) {
-			ath9k_hw_set11n_aggr_middle(sc->sc_ah,
-				tbf->bf_desc, ndelim);
-		}
-
-		/*
-		 * link buffers of this frame to the aggregate
-		 */
-		list_splice_tail_init(&bf_head, bf_q);
-		nframes++;
-
+		ath9k_hw_set11n_aggr_middle(sc->sc_ah, bf->bf_desc, ndelim);
+		list_move_tail(&bf->list, bf_q);
 		if (bf_prev) {
 			bf_prev->bf_next = bf;
-			bf_prev->bf_lastfrm->bf_desc->ds_link = bf->bf_daddr;
+			bf_prev->bf_desc->ds_link = bf->bf_daddr;
 		}
 		bf_prev = bf;
-
 	} while (!list_empty(&tid->buf_q));
 
 	bf_first->bf_al = al;
 	bf_first->bf_nframes = nframes;
-	*bf_last = bf_prev;
+
 	return status;
 #undef PADBYTES
 }
@@ -686,11 +609,9 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			      struct ath_atx_tid *tid)
 {
-	struct ath_buf *bf, *tbf, *bf_last, *bf_lastaggr = NULL;
+	struct ath_buf *bf;
 	enum ATH_AGGR_STATUS status;
 	struct list_head bf_q;
-	struct aggr_rifs_param param = {0, 0, 0, 0, NULL};
-	int prev_frames = 0;
 
 	do {
 		if (list_empty(&tid->buf_q))
@@ -698,66 +619,36 @@ static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 		INIT_LIST_HEAD(&bf_q);
 
-		status = ath_tx_form_aggr(sc, tid, &bf_q, &bf_lastaggr, &param,
-					  &prev_frames);
+		status = ath_tx_form_aggr(sc, tid, &bf_q);
 
 		/*
-		 * no frames picked up to be aggregated; block-ack
-		 * window is not open
+		 * no frames picked up to be aggregated;
+		 * block-ack window is not open.
 		 */
 		if (list_empty(&bf_q))
 			break;
 
 		bf = list_first_entry(&bf_q, struct ath_buf, list);
-		bf_last = list_entry(bf_q.prev, struct ath_buf, list);
-		bf->bf_lastbf = bf_last;
+		bf->bf_lastbf = list_entry(bf_q.prev, struct ath_buf, list);
 
-		/*
-		 * if only one frame, send as non-aggregate
-		 */
+		/* if only one frame, send as non-aggregate */
 		if (bf->bf_nframes == 1) {
-			ASSERT(bf->bf_lastfrm == bf_last);
-
 			bf->bf_state.bf_type &= ~BUF_AGGR;
-			/*
-			 * clear aggr bits for every descriptor
-			 * XXX TODO: is there a way to optimize it?
-			 */
-			list_for_each_entry(tbf, &bf_q, list) {
-				ath9k_hw_clr11n_aggr(sc->sc_ah, tbf->bf_desc);
-			}
-
+			ath9k_hw_clr11n_aggr(sc->sc_ah, bf->bf_desc);
 			ath_buf_set_rate(sc, bf);
 			ath_tx_txqaddbuf(sc, txq, &bf_q);
 			continue;
 		}
 
-		/*
-		 * setup first desc with rate and aggr info
-		 */
+		/* setup first desc of aggregate */
 		bf->bf_state.bf_type |= BUF_AGGR;
 		ath_buf_set_rate(sc, bf);
 		ath9k_hw_set11n_aggr_first(sc->sc_ah, bf->bf_desc, bf->bf_al);
 
-		/*
-		 * anchor last frame of aggregate correctly
-		 */
-		ASSERT(bf_lastaggr);
-		ASSERT(bf_lastaggr->bf_lastfrm == bf_last);
-		tbf = bf_lastaggr;
-		ath9k_hw_set11n_aggr_last(sc->sc_ah, tbf->bf_desc);
-
-		/* XXX: We don't enter into this loop, consider removing this */
-		while (!list_empty(&bf_q) && !list_is_last(&tbf->list, &bf_q)) {
-			tbf = list_entry(tbf->list.next, struct ath_buf, list);
-			ath9k_hw_set11n_aggr_last(sc->sc_ah, tbf->bf_desc);
-		}
+		/* anchor last desc of aggregate */
+		ath9k_hw_set11n_aggr_last(sc->sc_ah, bf->bf_lastbf->bf_desc);
 
 		txq->axq_aggr_depth++;
-
-		/*
-		 * Normal aggregate, queue to hardware
-		 */
 		ath_tx_txqaddbuf(sc, txq, &bf_q);
 
 	} while (txq->axq_depth < ATH_AGGR_MIN_QDEPTH &&
@@ -812,19 +703,17 @@ int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 			 */
 			break;
 		}
-		list_cut_position(&bf_head,
-			&txtid->buf_q, &bf->bf_lastfrm->list);
+		list_move_tail(&bf->list, &bf_head);
 		ath_tx_update_baw(sc, txtid, bf->bf_seqno);
 		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
 	}
+	spin_unlock_bh(&txq->axq_lock);
 
 	if (txtid->baw_head != txtid->baw_tail) {
-		spin_unlock_bh(&txq->axq_lock);
 		txtid->state |= AGGR_CLEANUP;
 	} else {
 		txtid->state &= ~AGGR_ADDBA_COMPLETE;
 		txtid->addba_exchangeattempts = 0;
-		spin_unlock_bh(&txq->axq_lock);
 		ath_tx_flush_tid(sc, txtid);
 	}
 
@@ -1130,7 +1019,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr_rifs(sc, txq, bf, &bf_head, 0);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, 0);
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
 	}
@@ -1326,8 +1215,6 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 {
 	struct ath_buf *bf;
 
-	BUG_ON(list_empty(bf_head));
-
 	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type |= BUF_AMPDU;
 
@@ -1345,7 +1232,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
-		list_splice_tail_init(bf_head, &tid->buf_q);
+		list_move_tail(&bf->list, &tid->buf_q);
 		ath_tx_queue_tid(txctl->txq, tid);
 		return;
 	}
@@ -1355,11 +1242,9 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 
 	/* Queue to h/w without aggregation */
 	bf->bf_nframes = 1;
-	bf->bf_lastbf = bf->bf_lastfrm; /* one single frame */
+	bf->bf_lastbf = bf;
 	ath_buf_set_rate(sc, bf);
 	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
-
-	return;
 }
 
 static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
@@ -1368,8 +1253,6 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 {
 	struct ath_buf *bf;
 
-	BUG_ON(list_empty(bf_head));
-
 	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type &= ~BUF_AMPDU;
 
@@ -1377,7 +1260,7 @@ static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
 	INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
 	bf->bf_nframes = 1;
-	bf->bf_lastbf = bf->bf_lastfrm;
+	bf->bf_lastbf = bf;
 	ath_buf_set_rate(sc, bf);
 	ath_tx_txqaddbuf(sc, txq, bf_head);
 }
@@ -1770,8 +1653,6 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
 			    true,	/* last segment */
 			    ds);	/* first descriptor */
 
-	bf->bf_lastfrm = bf;
-
 	spin_lock_bh(&txctl->txq->axq_lock);
 
 	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR) &&
@@ -2155,7 +2036,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		ath_tx_rc_status(bf, ds, nbad);
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr_rifs(sc, txq, bf, &bf_head, txok);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, txok);
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
 
-- 
1.6.0.3

