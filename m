Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46731 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbZAPQMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:12:01 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:12:01 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18800.45322.375401.327043@gargle.gargle.HOWL> (sfid-20090116_171213_029052_59EC9805)
Date: Fri, 16 Jan 2009 21:38:42 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 3/9] ath9k: Reorganize code in xmit.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch starts cleaning up all the crufty code in transmission path,
grouping functions into logical blocks.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    6 -
 drivers/net/wireless/ath9k/rc.c   |    2 +-
 drivers/net/wireless/ath9k/xmit.c | 2596 +++++++++++++++++--------------------
 3 files changed, 1180 insertions(+), 1424 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index b687ae9..4eb21a7 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -490,23 +490,17 @@ void ath_tx_draintxq(struct ath_softc *sc,
 		     struct ath_txq *txq, bool retry_tx);
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
-void ath_tx_node_free(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
 int ath_tx_cleanup(struct ath_softc *sc);
-int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype);
 struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
 int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
 		 struct ath_tx_control *txctl);
 void ath_tx_tasklet(struct ath_softc *sc);
-u32 ath_txq_depth(struct ath_softc *sc, int qnum);
-u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
 void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
-void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid);
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
-void ath_tx_aggr_teardown(struct ath_softc *sc,	struct ath_node *an, u8 tidno);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 68bda23..46172b5 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -23,7 +23,7 @@ static struct ath_rate_table ar5416_11na_ratetable = {
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 6000, /* 6 Mb */
 			5400, 0x0b, 0x00, 12,
 			0, 2, 1, 0, 0, 0, 0, 0 },
-		{ VALID,	VALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
+		{ VALID, VALID, WLAN_RC_PHY_OFDM, 9000, /* 9 Mb */
 			7800,  0x0f, 0x00, 18,
 			0, 3, 1, 1, 1, 1, 1, 0 },
 		{ VALID, VALID, WLAN_RC_PHY_OFDM, 12000, /* 12 Mb */
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 522078d..5e6e5cf 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -55,94 +55,19 @@ static u32 bits_per_symbol[][2] = {
 
 #define IS_HT_RATE(_rate)     ((_rate) & 0x80)
 
-/*
- * Insert a chain of ath_buf (descriptors) on a txq and
- * assume the descriptors are already chained together by caller.
- * NB: must be called with txq lock held
- */
-
+static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
+			       struct ath_atx_tid *tid,
+			       struct list_head *bf_head);
+static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
+				struct list_head *bf_q,
+				int txok, int sendbar);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
-			     struct list_head *head)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_buf *bf;
-
-	/*
-	 * Insert the frame on the outbound list and
-	 * pass it on to the hardware.
-	 */
-
-	if (list_empty(head))
-		return;
-
-	bf = list_first_entry(head, struct ath_buf, list);
-
-	list_splice_tail_init(head, &txq->axq_q);
-	txq->axq_depth++;
-	txq->axq_totalqueued++;
-	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
-
-	DPRINTF(sc, ATH_DBG_QUEUE,
-		"qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
-
-	if (txq->axq_link == NULL) {
-		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
-		DPRINTF(sc, ATH_DBG_XMIT,
-			"TXDP[%u] = %llx (%p)\n",
-			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
-	} else {
-		*txq->axq_link = bf->bf_daddr;
-		DPRINTF(sc, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
-			txq->axq_qnum, txq->axq_link,
-			ito64(bf->bf_daddr), bf->bf_desc);
-	}
-	txq->axq_link = &(bf->bf_lastbf->bf_desc->ds_link);
-	ath9k_hw_txstart(ah, txq->axq_qnum);
-}
+			     struct list_head *head);
+static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf);
 
-static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-			    struct ath_xmit_status *tx_status)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-	int hdrlen, padsize;
-
-	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
-
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
-	    tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		kfree(tx_info_priv);
-		tx_info->rate_driver_data[0] = NULL;
-	}
-
-	if (tx_status->flags & ATH_TX_BAR) {
-		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
-		tx_status->flags &= ~ATH_TX_BAR;
-	}
-
-	if (!(tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY))) {
-		/* Frame was ACKed */
-		tx_info->flags |= IEEE80211_TX_STAT_ACK;
-	}
-
-	tx_info->status.rates[0].count = tx_status->retries + 1;
-
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	padsize = hdrlen & 3;
-	if (padsize && hdrlen >= 24) {
-		/*
-		 * Remove MAC header padding before giving the frame back to
-		 * mac80211.
-		 */
-		memmove(skb->data + padsize, skb->data, hdrlen);
-		skb_pull(skb, padsize);
-	}
-
-	ieee80211_tx_status(hw, skb);
-}
-
-/* Check if it's okay to send out aggregates */
+/*********************/
+/* Aggregation logic */
+/*********************/
 
 static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 {
@@ -156,230 +81,19 @@ static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 		return 0;
 }
 
-static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
-				 struct ath_beacon_config *conf)
-{
-	struct ieee80211_hw *hw = sc->hw;
-
-	/* fill in beacon config data */
-
-	conf->beacon_interval = hw->conf.beacon_int;
-	conf->listen_interval = 100;
-	conf->dtim_count = 1;
-	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
-}
-
-/* Calculate Atheros packet type from IEEE80211 packet header */
-
-static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr;
-	enum ath9k_pkt_type htype;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	if (ieee80211_is_beacon(fc))
-		htype = ATH9K_PKT_TYPE_BEACON;
-	else if (ieee80211_is_probe_resp(fc))
-		htype = ATH9K_PKT_TYPE_PROBE_RESP;
-	else if (ieee80211_is_atim(fc))
-		htype = ATH9K_PKT_TYPE_ATIM;
-	else if (ieee80211_is_pspoll(fc))
-		htype = ATH9K_PKT_TYPE_PSPOLL;
-	else
-		htype = ATH9K_PKT_TYPE_NORMAL;
-
-	return htype;
-}
-
-static bool is_pae(struct sk_buff *skb)
-{
-	struct ieee80211_hdr *hdr;
-	__le16 fc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	if (ieee80211_is_data(fc)) {
-		if (ieee80211_is_nullfunc(fc) ||
-		    /* Port Access Entity (IEEE 802.1X) */
-		    (skb->protocol == cpu_to_be16(ETH_P_PAE))) {
-			return true;
-		}
-	}
-
-	return false;
-}
-
-static int get_hw_crypto_keytype(struct sk_buff *skb)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-
-	if (tx_info->control.hw_key) {
-		if (tx_info->control.hw_key->alg == ALG_WEP)
-			return ATH9K_KEY_TYPE_WEP;
-		else if (tx_info->control.hw_key->alg == ALG_TKIP)
-			return ATH9K_KEY_TYPE_TKIP;
-		else if (tx_info->control.hw_key->alg == ALG_CCMP)
-			return ATH9K_KEY_TYPE_AES;
-	}
-
-	return ATH9K_KEY_TYPE_CLEAR;
-}
-
-/* Called only when tx aggregation is enabled and HT is supported */
-
-static void assign_aggr_tid_seqno(struct sk_buff *skb,
-				  struct ath_buf *bf)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr;
-	struct ath_node *an;
-	struct ath_atx_tid *tid;
-	__le16 fc;
-	u8 *qc;
-
-	if (!tx_info->control.sta)
-		return;
-
-	an = (struct ath_node *)tx_info->control.sta->drv_priv;
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	/* Get tidno */
-
-	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		bf->bf_tidno = qc[0] & 0xf;
-	}
-
-	/* Get seqno */
-	/* For HT capable stations, we save tidno for later use.
-	 * We also override seqno set by upper layer with the one
-	 * in tx aggregation state.
-	 *
-	 * If fragmentation is on, the sequence number is
-	 * not overridden, since it has been
-	 * incremented by the fragmentation routine.
-	 *
-	 * FIXME: check if the fragmentation threshold exceeds
-	 * IEEE80211 max.
-	 */
-	tid = ATH_AN_2_TID(an, bf->bf_tidno);
-	hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
-			IEEE80211_SEQ_SEQ_SHIFT);
-	bf->bf_seqno = tid->seq_next;
-	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
-}
-
-static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
-			  struct ath_txq *txq)
-{
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	int flags = 0;
-
-	flags |= ATH9K_TXDESC_CLRDMASK; /* needed for crypto errors */
-	flags |= ATH9K_TXDESC_INTREQ;
-
-	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
-		flags |= ATH9K_TXDESC_NOACK;
-	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
-		flags |= ATH9K_TXDESC_RTSENA;
-
-	return flags;
-}
-
-static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
-{
-	struct ath_buf *bf = NULL;
-
-	spin_lock_bh(&sc->tx.txbuflock);
-
-	if (unlikely(list_empty(&sc->tx.txbuf))) {
-		spin_unlock_bh(&sc->tx.txbuflock);
-		return NULL;
-	}
-
-	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
-	list_del(&bf->list);
-
-	spin_unlock_bh(&sc->tx.txbuflock);
-
-	return bf;
-}
-
-/* To complete a chain of buffers associated a frame */
-
-static void ath_tx_complete_buf(struct ath_softc *sc,
-				struct ath_buf *bf,
-				struct list_head *bf_q,
-				int txok, int sendbar)
-{
-	struct sk_buff *skb = bf->bf_mpdu;
-	struct ath_xmit_status tx_status;
-	unsigned long flags;
-
-	/*
-	 * Set retry information.
-	 * NB: Don't use the information in the descriptor, because the frame
-	 * could be software retried.
-	 */
-	tx_status.retries = bf->bf_retries;
-	tx_status.flags = 0;
-
-	if (sendbar)
-		tx_status.flags = ATH_TX_BAR;
-
-	if (!txok) {
-		tx_status.flags |= ATH_TX_ERROR;
-
-		if (bf_isxretried(bf))
-			tx_status.flags |= ATH_TX_XRETRY;
-	}
-
-	/* Unmap this frame */
-	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
-
-	/* complete this frame */
-	ath_tx_complete(sc, skb, &tx_status);
-
-	/*
-	 * Return the list of ath_buf of this mpdu to free queue
-	 */
-	spin_lock_irqsave(&sc->tx.txbuflock, flags);
-	list_splice_tail_init(bf_q, &sc->tx.txbuf);
-	spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
-}
-
-/*
- * queue up a dest/ac pair for tx scheduling
- * NB: must be called with txq lock held
- */
-
 static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 {
 	struct ath_atx_ac *ac = tid->ac;
 
-	/*
-	 * if tid is paused, hold off
-	 */
 	if (tid->paused)
 		return;
 
-	/*
-	 * add tid to ac atmost once
-	 */
 	if (tid->sched)
 		return;
 
 	tid->sched = true;
 	list_add_tail(&tid->list, &ac->tid_q);
 
-	/*
-	 * add node ac to txq atmost once
-	 */
 	if (ac->sched)
 		return;
 
@@ -387,22 +101,16 @@ static void ath_tx_queue_tid(struct ath_txq *txq, struct ath_atx_tid *tid)
 	list_add_tail(&ac->list, &txq->axq_acq);
 }
 
-/* pause a tid */
-
 static void ath_tx_pause_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 
 	spin_lock_bh(&txq->axq_lock);
-
 	tid->paused++;
-
 	spin_unlock_bh(&txq->axq_lock);
 }
 
-/* resume a tid and schedule aggregate */
-
-void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
+static void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
 	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 
@@ -417,63 +125,39 @@ void ath_tx_resume_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 	if (list_empty(&tid->buf_q))
 		goto unlock;
 
-	/*
-	 * Add this TID to scheduler and try to send out aggregates
-	 */
 	ath_tx_queue_tid(txq, tid);
 	ath_txq_schedule(sc, txq);
 unlock:
 	spin_unlock_bh(&txq->axq_lock);
 }
 
-/* Compute the number of bad frames */
-
-static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
-			      int txok)
+static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_buf *bf_last = bf->bf_lastbf;
-	struct ath_desc *ds = bf_last->bf_desc;
-	u16 seq_st = 0;
-	u32 ba[WME_BA_BMP_SIZE >> 5];
-	int ba_index;
-	int nbad = 0;
-	int isaggr = 0;
-
-	if (ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
-		return 0;
+	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
+	struct ath_buf *bf;
+	struct list_head bf_head;
+	INIT_LIST_HEAD(&bf_head);
 
-	isaggr = bf_isaggr(bf);
-	if (isaggr) {
-		seq_st = ATH_DS_BA_SEQ(ds);
-		memcpy(ba, ATH_DS_BA_BITMAP(ds), WME_BA_BMP_SIZE >> 3);
-	}
+	ASSERT(tid->paused > 0);
+	spin_lock_bh(&txq->axq_lock);
 
-	while (bf) {
-		ba_index = ATH_BA_INDEX(seq_st, bf->bf_seqno);
-		if (!txok || (isaggr && !ATH_BA_ISSET(ba, ba_index)))
-			nbad++;
+	tid->paused--;
 
-		bf = bf->bf_next;
+	if (tid->paused > 0) {
+		spin_unlock_bh(&txq->axq_lock);
+		return;
 	}
 
-	return nbad;
-}
-
-static void ath_tx_set_retry(struct ath_softc *sc, struct ath_buf *bf)
-{
-	struct sk_buff *skb;
-	struct ieee80211_hdr *hdr;
-
-	bf->bf_state.bf_type |= BUF_RETRY;
-	bf->bf_retries++;
+	while (!list_empty(&tid->buf_q)) {
+		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
+		ASSERT(!bf_isretried(bf));
+		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
+		ath_tx_send_normal(sc, txq, tid, &bf_head);
+	}
 
-	skb = bf->bf_mpdu;
-	hdr = (struct ieee80211_hdr *)skb->data;
-	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
+	spin_unlock_bh(&txq->axq_lock);
 }
 
-/* Update block ack window */
-
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      int seqno)
 {
@@ -490,247 +174,75 @@ static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 	}
 }
 
-/*
- * ath_pkt_dur - compute packet duration (NB: not NAV)
- *
- * rix - rate index
- * pktlen - total bytes (delims + data + fcs + pads + pad delims)
- * width  - 0 for 20 MHz, 1 for 40 MHz
- * half_gi - to use 4us v/s 3.6 us for symbol time
- */
-static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
-			    int width, int half_gi, bool shortPreamble)
-{
-	struct ath_rate_table *rate_table = sc->cur_rate_table;
-	u32 nbits, nsymbits, duration, nsymbols;
-	u8 rc;
-	int streams, pktlen;
-
-	pktlen = bf_isaggr(bf) ? bf->bf_al : bf->bf_frmlen;
-	rc = rate_table->info[rix].ratecode;
-
-	/* for legacy rates, use old function to compute packet duration */
-	if (!IS_HT_RATE(rc))
-		return ath9k_hw_computetxtime(sc->sc_ah, rate_table, pktlen,
-					      rix, shortPreamble);
-
-	/* find number of symbols: PLCP + data */
-	nbits = (pktlen << 3) + OFDM_PLCP_BITS;
-	nsymbits = bits_per_symbol[HT_RC_2_MCS(rc)][width];
-	nsymbols = (nbits + nsymbits - 1) / nsymbits;
-
-	if (!half_gi)
-		duration = SYMBOL_TIME(nsymbols);
-	else
-		duration = SYMBOL_TIME_HALFGI(nsymbols);
-
-	/* addup duration for legacy/ht training and signal fields */
-	streams = HT_RC_2_STREAMS(rc);
-	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
-
-	return duration;
-}
-
-/* Rate module function to set rate related fields in tx descriptor */
-
-static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
+static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
+			     struct ath_buf *bf)
 {
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_rate_table *rt;
-	struct ath_desc *ds = bf->bf_desc;
-	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
-	struct ath9k_11n_rate_series series[4];
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *tx_info;
-	struct ieee80211_tx_rate *rates;
-	struct ieee80211_hdr *hdr;
-	struct ieee80211_hw *hw = sc->hw;
-	int i, flags, rtsctsena = 0, enable_g_protection = 0;
-	u32 ctsduration = 0;
-	u8 rix = 0, cix, ctsrate = 0;
-	__le16 fc;
-
-	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
-
-	skb = (struct sk_buff *)bf->bf_mpdu;
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-	tx_info = IEEE80211_SKB_CB(skb);
-	rates = tx_info->control.rates;
-
-	if (ieee80211_has_morefrags(fc) ||
-	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
-		rates[1].count = rates[2].count = rates[3].count = 0;
-		rates[1].idx = rates[2].idx = rates[3].idx = 0;
-		rates[0].count = ATH_TXMAXTRY;
-	}
-
-	/* get the cix for the lowest valid rix */
-	rt = sc->cur_rate_table;
-	for (i = 3; i >= 0; i--) {
-		if (rates[i].count && (rates[i].idx >= 0)) {
-			rix = rates[i].idx;
-			break;
-		}
-	}
-
-	flags = (bf->bf_flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA));
-	cix = rt->info[rix].ctrl_rate;
-
-	/* All protection frames are transmited at 2Mb/s for 802.11g,
-	 * otherwise we transmit them at 1Mb/s */
-	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
-	  !conf_is_ht(&hw->conf))
-		enable_g_protection = 1;
-
-	/*
-	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
-	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
-	 */
-	if (sc->sc_protmode != PROT_M_NONE && !(bf->bf_flags & ATH9K_TXDESC_NOACK)
-	    && (rt->info[rix].phy == WLAN_RC_PHY_OFDM ||
-		WLAN_RC_PHY_HT(rt->info[rix].phy))) {
-		if (sc->sc_protmode == PROT_M_RTSCTS)
-			flags = ATH9K_TXDESC_RTSENA;
-		else if (sc->sc_protmode == PROT_M_CTSONLY)
-			flags = ATH9K_TXDESC_CTSENA;
-
-		cix = rt->info[enable_g_protection].ctrl_rate;
-		rtsctsena = 1;
-	}
-
-	/* For 11n, the default behavior is to enable RTS for hw retried frames.
-	 * We enable the global flag here and let rate series flags determine
-	 * which rates will actually use RTS.
-	 */
-	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf_isdata(bf)) {
-		/* 802.11g protection not needed, use our default behavior */
-		if (!rtsctsena)
-			flags = ATH9K_TXDESC_RTSENA;
-	}
-
-	/* Set protection if aggregate protection on */
-	if (sc->sc_config.ath_aggr_prot &&
-	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
-		flags = ATH9K_TXDESC_RTSENA;
-		cix = rt->info[enable_g_protection].ctrl_rate;
-		rtsctsena = 1;
-	}
-
-	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
-	if (bf_isaggr(bf) && (bf->bf_al > ah->ah_caps.rts_aggr_limit))
-		flags &= ~(ATH9K_TXDESC_RTSENA);
-
-	/*
-	 * CTS transmit rate is derived from the transmit rate by looking in the
-	 * h/w rate table.  We must also factor in whether or not a short
-	 * preamble is to be used. NB: cix is set above where RTS/CTS is enabled
-	 */
-	ctsrate = rt->info[cix].ratecode |
-		(bf_isshpreamble(bf) ? rt->info[cix].short_preamble : 0);
-
-	for (i = 0; i < 4; i++) {
-		if (!rates[i].count || (rates[i].idx < 0))
-			continue;
-
-		rix = rates[i].idx;
-
-		series[i].Rate = rt->info[rix].ratecode |
-			(bf_isshpreamble(bf) ? rt->info[rix].short_preamble : 0);
-
-		series[i].Tries = rates[i].count;
+	int index, cindex;
 
-		series[i].RateFlags = (
-			(rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) ?
-				ATH9K_RATESERIES_RTS_CTS : 0) |
-			((rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
-				ATH9K_RATESERIES_2040 : 0) |
-			((rates[i].flags & IEEE80211_TX_RC_SHORT_GI) ?
-				ATH9K_RATESERIES_HALFGI : 0);
+	if (bf_isretried(bf))
+		return;
 
-		series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
-			 (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) != 0,
-			 (rates[i].flags & IEEE80211_TX_RC_SHORT_GI),
-			 bf_isshpreamble(bf));
+	index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
+	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
 
-		series[i].ChSel = sc->sc_tx_chainmask;
+	ASSERT(tid->tx_buf[cindex] == NULL);
+	tid->tx_buf[cindex] = bf;
 
-		if (rtsctsena)
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+	if (index >= ((tid->baw_tail - tid->baw_head) &
+		(ATH_TID_MAX_BUFS - 1))) {
+		tid->baw_tail = cindex;
+		INCR(tid->baw_tail, ATH_TID_MAX_BUFS);
 	}
-
-	/* set dur_update_en for l-sig computation except for PS-Poll frames */
-	ath9k_hw_set11n_ratescenario(ah, ds, lastds, !bf_ispspoll(bf),
-				     ctsrate, ctsduration,
-				     series, 4, flags);
-
-	if (sc->sc_config.ath_aggr_prot && flags)
-		ath9k_hw_set11n_burstduration(ah, ds, 8192);
 }
 
 /*
- * Function to send a normal HT (non-AMPDU) frame
- * NB: must be called with txq lock held
+ * TODO: For frame(s) that are in the retry state, we will reuse the
+ * sequence number(s) without setting the retry bit. The
+ * alternative is to give up on these and BAR the receiver's window
+ * forward.
  */
-static int ath_tx_send_normal(struct ath_softc *sc,
-			      struct ath_txq *txq,
-			      struct ath_atx_tid *tid,
-			      struct list_head *bf_head)
-{
-	struct ath_buf *bf;
-
-	BUG_ON(list_empty(bf_head));
-
-	bf = list_first_entry(bf_head, struct ath_buf, list);
-	bf->bf_state.bf_type &= ~BUF_AMPDU; /* regular HT frame */
-
-	/* update starting sequence number for subsequent ADDBA request */
-	INCR(tid->seq_start, IEEE80211_SEQ_MAX);
-
-	/* Queue to h/w without aggregation */
-	bf->bf_nframes = 1;
-	bf->bf_lastbf = bf->bf_lastfrm; /* one single frame */
-	ath_buf_set_rate(sc, bf);
-	ath_tx_txqaddbuf(sc, txq, bf_head);
-
-	return 0;
-}
-
-/* flush tid's software queue and send frames as non-ampdu's */
+static void ath_tid_drain(struct ath_softc *sc, struct ath_txq *txq,
+			  struct ath_atx_tid *tid)
 
-static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 {
-	struct ath_txq *txq = &sc->tx.txq[tid->ac->qnum];
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
 
-	ASSERT(tid->paused > 0);
-	spin_lock_bh(&txq->axq_lock);
+	for (;;) {
+		if (list_empty(&tid->buf_q))
+			break;
+		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
 
-	tid->paused--;
+		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
 
-	if (tid->paused > 0) {
-		spin_unlock_bh(&txq->axq_lock);
-		return;
-	}
+		if (bf_isretried(bf))
+			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 
-	while (!list_empty(&tid->buf_q)) {
-		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
-		ASSERT(!bf_isretried(bf));
-		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
-		ath_tx_send_normal(sc, txq, tid, &bf_head);
+		spin_unlock(&txq->axq_lock);
+		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+		spin_lock(&txq->axq_lock);
 	}
 
-	spin_unlock_bh(&txq->axq_lock);
+	tid->seq_next = tid->seq_start;
+	tid->baw_tail = tid->baw_head;
 }
 
-/* Completion routine of an aggregate */
+static void ath_tx_set_retry(struct ath_softc *sc, struct ath_buf *bf)
+{
+	struct sk_buff *skb;
+	struct ieee80211_hdr *hdr;
+
+	bf->bf_state.bf_type |= BUF_RETRY;
+	bf->bf_retries++;
+
+	skb = bf->bf_mpdu;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_RETRY);
+}
 
-static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
-				      struct ath_txq *txq,
-				      struct ath_buf *bf,
-				      struct list_head *bf_q,
+static void ath_tx_complete_aggr_rifs(struct ath_softc *sc, struct ath_txq *txq,
+				      struct ath_buf *bf, struct list_head *bf_q,
 				      int txok)
 {
 	struct ath_node *an = NULL;
@@ -757,14 +269,9 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	if (isaggr) {
 		if (txok) {
 			if (ATH_DS_TX_BA(ds)) {
-				/*
-				 * extract starting sequence and
-				 * block-ack bitmap
-				 */
 				seq_st = ATH_DS_BA_SEQ(ds);
-				memcpy(ba,
-					ATH_DS_BA_BITMAP(ds),
-					WME_BA_BMP_SIZE >> 3);
+				memcpy(ba, ATH_DS_BA_BITMAP(ds),
+				       WME_BA_BMP_SIZE >> 3);
 			} else {
 				memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 
@@ -816,31 +323,15 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 				txfail = 1;
 			}
 		}
-		/*
-		 * Remove ath_buf's of this sub-frame from aggregate queue.
-		 */
-		if (bf_next == NULL) {  /* last subframe in the aggregate */
-			ASSERT(bf->bf_lastfrm == bf_last);
-
-			/*
-			 * The last descriptor of the last sub frame could be
-			 * a holding descriptor for h/w. If that's the case,
-			 * bf->bf_lastfrm won't be in the bf_q.
-			 * Make sure we handle bf_q properly here.
-			 */
 
+		if (bf_next == NULL) {
+			ASSERT(bf->bf_lastfrm == bf_last);
 			if (!list_empty(bf_q)) {
 				bf_lastq = list_entry(bf_q->prev,
 					struct ath_buf, list);
 				list_cut_position(&bf_head,
 					bf_q, &bf_lastq->list);
 			} else {
-				/*
-				 * XXX: if the last subframe only has one
-				 * descriptor which is also being used as
-				 * a holding descriptor. Then the ath_buf
-				 * is not in the bf_q at all.
-				 */
 				INIT_LIST_HEAD(&bf_head);
 			}
 		} else {
@@ -858,18 +349,11 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 			spin_unlock_bh(&txq->axq_lock);
 
-			/* complete this sub-frame */
 			ath_tx_complete_buf(sc, bf, &bf_head, !txfail, sendbar);
 		} else {
 			/*
 			 * retry the un-acked ones
 			 */
-			/*
-			 * XXX: if the last descriptor is holding descriptor,
-			 * in order to requeue the frame to software queue, we
-			 * need to allocate a new descriptor and
-			 * copy the content of holding descriptor to it.
-			 */
 			if (bf->bf_next == NULL &&
 			    bf_last->bf_status & ATH_BUFSTATUS_STALE) {
 				struct ath_buf *tbf;
@@ -950,8 +434,6 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	 */
 	if (!list_empty(&bf_pending)) {
 		spin_lock_bh(&txq->axq_lock);
-		/* Note: we _prepend_, we _do_not_ at to
-		 * the end of the queue ! */
 		list_splice(&bf_pending, &tid->buf_q);
 		ath_tx_queue_tid(txq, tid);
 		spin_unlock_bh(&txq->axq_lock);
@@ -963,292 +445,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	return;
 }
 
-static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
-{
-	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-
-	tx_info_priv->update_rc = false;
-	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
-		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-
-	if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
-	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
-		if (bf_isdata(bf)) {
-			memcpy(&tx_info_priv->tx, &ds->ds_txstat,
-			       sizeof(tx_info_priv->tx));
-			tx_info_priv->n_frames = bf->bf_nframes;
-			tx_info_priv->n_bad_frames = nbad;
-			tx_info_priv->update_rc = true;
-		}
-	}
-}
-
-/* Process completed xmit descriptors from the specified queue */
-
-static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	struct ath_buf *bf, *lastbf, *bf_held = NULL;
-	struct list_head bf_head;
-	struct ath_desc *ds;
-	int txok, nbad = 0;
-	int status;
-
-	DPRINTF(sc, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
-		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
-		txq->axq_link);
-
-	for (;;) {
-		spin_lock_bh(&txq->axq_lock);
-		if (list_empty(&txq->axq_q)) {
-			txq->axq_link = NULL;
-			txq->axq_linkbuf = NULL;
-			spin_unlock_bh(&txq->axq_lock);
-			break;
-		}
-		bf = list_first_entry(&txq->axq_q, struct ath_buf, list);
-
-		/*
-		 * There is a race condition that a BH gets scheduled
-		 * after sw writes TxE and before hw re-load the last
-		 * descriptor to get the newly chained one.
-		 * Software must keep the last DONE descriptor as a
-		 * holding descriptor - software does so by marking
-		 * it with the STALE flag.
-		 */
-		bf_held = NULL;
-		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
-			bf_held = bf;
-			if (list_is_last(&bf_held->list, &txq->axq_q)) {
-				/* FIXME:
-				 * The holding descriptor is the last
-				 * descriptor in queue. It's safe to remove
-				 * the last holding descriptor in BH context.
-				 */
-				spin_unlock_bh(&txq->axq_lock);
-				break;
-			} else {
-				/* Lets work with the next buffer now */
-				bf = list_entry(bf_held->list.next,
-					struct ath_buf, list);
-			}
-		}
-
-		lastbf = bf->bf_lastbf;
-		ds = lastbf->bf_desc;    /* NB: last decriptor */
-
-		status = ath9k_hw_txprocdesc(ah, ds);
-		if (status == -EINPROGRESS) {
-			spin_unlock_bh(&txq->axq_lock);
-			break;
-		}
-		if (bf->bf_desc == txq->axq_lastdsWithCTS)
-			txq->axq_lastdsWithCTS = NULL;
-		if (ds == txq->axq_gatingds)
-			txq->axq_gatingds = NULL;
-
-		/*
-		 * Remove ath_buf's of the same transmit unit from txq,
-		 * however leave the last descriptor back as the holding
-		 * descriptor for hw.
-		 */
-		lastbf->bf_status |= ATH_BUFSTATUS_STALE;
-		INIT_LIST_HEAD(&bf_head);
-
-		if (!list_is_singular(&lastbf->list))
-			list_cut_position(&bf_head,
-				&txq->axq_q, lastbf->list.prev);
-
-		txq->axq_depth--;
-
-		if (bf_isaggr(bf))
-			txq->axq_aggr_depth--;
-
-		txok = (ds->ds_txstat.ts_status == 0);
-
-		spin_unlock_bh(&txq->axq_lock);
-
-		if (bf_held) {
-			list_del(&bf_held->list);
-			spin_lock_bh(&sc->tx.txbuflock);
-			list_add_tail(&bf_held->list, &sc->tx.txbuf);
-			spin_unlock_bh(&sc->tx.txbuflock);
-		}
-
-		if (!bf_isampdu(bf)) {
-			/*
-			 * This frame is sent out as a single frame.
-			 * Use hardware retry status for this frame.
-			 */
-			bf->bf_retries = ds->ds_txstat.ts_longretry;
-			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
-				bf->bf_state.bf_type |= BUF_XRETRY;
-			nbad = 0;
-		} else {
-			nbad = ath_tx_num_badfrms(sc, bf, txok);
-		}
-
-		ath_tx_rc_status(bf, ds, nbad);
-
-		/*
-		 * Complete this transmit unit
-		 */
-		if (bf_isampdu(bf))
-			ath_tx_complete_aggr_rifs(sc, txq, bf, &bf_head, txok);
-		else
-			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
-
-		/* Wake up mac80211 queue */
-
-		spin_lock_bh(&txq->axq_lock);
-		if (txq->stopped && ath_txq_depth(sc, txq->axq_qnum) <=
-				(ATH_TXBUF - 20)) {
-			int qnum;
-			qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
-			if (qnum != -1) {
-				ieee80211_wake_queue(sc->hw, qnum);
-				txq->stopped = 0;
-			}
-
-		}
-
-		/*
-		 * schedule any pending packets if aggregation is enabled
-		 */
-		if (sc->sc_flags & SC_OP_TXAGGR)
-			ath_txq_schedule(sc, txq);
-		spin_unlock_bh(&txq->axq_lock);
-	}
-}
-
-static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
-{
-	struct ath_hal *ah = sc->sc_ah;
-
-	(void) ath9k_hw_stoptxdma(ah, txq->axq_qnum);
-	DPRINTF(sc, ATH_DBG_XMIT, "tx queue [%u] %x, link %p\n",
-		txq->axq_qnum, ath9k_hw_gettxbuf(ah, txq->axq_qnum),
-		txq->axq_link);
-}
-
-/* Drain only the data queues */
-
-static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
-{
-	struct ath_hal *ah = sc->sc_ah;
-	int i, npend = 0;
-
-	if (!(sc->sc_flags & SC_OP_INVALID)) {
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (ATH_TXQ_SETUP(sc, i)) {
-				ath_tx_stopdma(sc, &sc->tx.txq[i]);
-				/* The TxDMA may not really be stopped.
-				 * Double check the hal tx pending count */
-				npend += ath9k_hw_numtxpending(ah,
-						       sc->tx.txq[i].axq_qnum);
-			}
-		}
-	}
-
-	if (npend) {
-		int r;
-		/* TxDMA not stopped, reset the hal */
-		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
-
-		spin_lock_bh(&sc->sc_resetlock);
-		r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, true);
-		if (r)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Unable to reset hardware; reset status %u\n",
-				r);
-		spin_unlock_bh(&sc->sc_resetlock);
-	}
-
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i))
-			ath_tx_draintxq(sc, &sc->tx.txq[i], retry_tx);
-	}
-}
-
-/* Add a sub-frame to block ack window */
-
-static void ath_tx_addto_baw(struct ath_softc *sc,
-			     struct ath_atx_tid *tid,
-			     struct ath_buf *bf)
-{
-	int index, cindex;
-
-	if (bf_isretried(bf))
-		return;
-
-	index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
-	cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
-
-	ASSERT(tid->tx_buf[cindex] == NULL);
-	tid->tx_buf[cindex] = bf;
-
-	if (index >= ((tid->baw_tail - tid->baw_head) &
-		(ATH_TID_MAX_BUFS - 1))) {
-		tid->baw_tail = cindex;
-		INCR(tid->baw_tail, ATH_TID_MAX_BUFS);
-	}
-}
-
-/*
- * Function to send an A-MPDU
- * NB: must be called with txq lock held
- */
-static int ath_tx_send_ampdu(struct ath_softc *sc,
-			     struct ath_atx_tid *tid,
-			     struct list_head *bf_head,
-			     struct ath_tx_control *txctl)
-{
-	struct ath_buf *bf;
-
-	BUG_ON(list_empty(bf_head));
-
-	bf = list_first_entry(bf_head, struct ath_buf, list);
-	bf->bf_state.bf_type |= BUF_AMPDU;
-
-	/*
-	 * Do not queue to h/w when any of the following conditions is true:
-	 * - there are pending frames in software queue
-	 * - the TID is currently paused for ADDBA/BAR request
-	 * - seqno is not within block-ack window
-	 * - h/w queue depth exceeds low water mark
-	 */
-	if (!list_empty(&tid->buf_q) || tid->paused ||
-	    !BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno) ||
-	    txctl->txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
-		/*
-		 * Add this frame to software queue for scheduling later
-		 * for aggregation.
-		 */
-		list_splice_tail_init(bf_head, &tid->buf_q);
-		ath_tx_queue_tid(txctl->txq, tid);
-		return 0;
-	}
-
-	/* Add sub-frame to BAW */
-	ath_tx_addto_baw(sc, tid, bf);
-
-	/* Queue to h/w without aggregation */
-	bf->bf_nframes = 1;
-	bf->bf_lastbf = bf->bf_lastfrm; /* one single frame */
-	ath_buf_set_rate(sc, bf);
-	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
-
-	return 0;
-}
-
-/*
- * looks up the rate
- * returns aggr limit based on lowest of the rates
- */
-static u32 ath_lookup_rate(struct ath_softc *sc,
-			   struct ath_buf *bf,
+static u32 ath_lookup_rate(struct ath_softc *sc, struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
 {
 	struct ath_rate_table *rate_table = sc->cur_rate_table;
@@ -1314,10 +511,8 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
  * meet the minimum required mpdudensity.
  * caller should make sure that the rate is  HT rate .
  */
-static int ath_compute_num_delims(struct ath_softc *sc,
-				  struct ath_atx_tid *tid,
-				  struct ath_buf *bf,
-				  u16 frmlen)
+static int ath_compute_num_delims(struct ath_softc *sc, struct ath_atx_tid *tid,
+				  struct ath_buf *bf, u16 frmlen)
 {
 	struct ath_rate_table *rt = sc->cur_rate_table;
 	struct sk_buff *skb = bf->bf_mpdu;
@@ -1381,16 +576,10 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 	return ndelim;
 }
 
-/*
- * For aggregation from software buffer queue.
- * NB: must be called with txq lock held
- */
 static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
-					struct ath_atx_tid *tid,
-					struct list_head *bf_q,
-					struct ath_buf **bf_last,
-					struct aggr_rifs_param *param,
-					int *prev_frames)
+		     struct ath_atx_tid *tid, struct list_head *bf_q,
+		     struct ath_buf **bf_last, struct aggr_rifs_param *param,
+		     int *prev_frames)
 {
 #define PADBYTES(_len) ((4 - ((_len) % 4)) % 4)
 	struct ath_buf *bf, *tbf, *bf_first, *bf_prev = NULL;
@@ -1485,15 +674,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		}
 		bf_prev = bf;
 
-#ifdef AGGR_NOSHORT
-		/*
-		 * terminate aggregation on a small packet boundary
-		 */
-		if (bf->bf_frmlen < ATH_AGGR_MINPLEN) {
-			status = ATH_AGGR_SHORTPKT;
-			break;
-		}
-#endif
 	} while (!list_empty(&tid->buf_q));
 
 	bf_first->bf_al = al;
@@ -1503,12 +683,8 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 #undef PADBYTES
 }
 
-/*
- * process pending frames possibly doing a-mpdu aggregation
- * NB: must be called with txq lock held
- */
-static void ath_tx_sched_aggr(struct ath_softc *sc,
-	struct ath_txq *txq, struct ath_atx_tid *tid)
+static void ath_tx_sched_aggr(struct ath_softc *sc, struct ath_txq *txq,
+			      struct ath_atx_tid *tid)
 {
 	struct ath_buf *bf, *tbf, *bf_last, *bf_lastaggr = NULL;
 	enum ATH_AGGR_STATUS status;
@@ -1588,313 +764,190 @@ static void ath_tx_sched_aggr(struct ath_softc *sc,
 		 status != ATH_AGGR_BAW_CLOSED);
 }
 
-/* Called with txq lock held */
+int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
+		      u16 tid, u16 *ssn)
+{
+	struct ath_atx_tid *txtid;
+	struct ath_node *an;
 
-static void ath_tid_drain(struct ath_softc *sc,
-			  struct ath_txq *txq,
-			  struct ath_atx_tid *tid)
+	an = (struct ath_node *)sta->drv_priv;
+
+	if (sc->sc_flags & SC_OP_TXAGGR) {
+		txtid = ATH_AN_2_TID(an, tid);
+		txtid->state |= AGGR_ADDBA_PROGRESS;
+		ath_tx_pause_tid(sc, txtid);
+	}
 
+	return 0;
+}
+
+int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
+	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
+	struct ath_txq *txq = &sc->tx.txq[txtid->ac->qnum];
 	struct ath_buf *bf;
 	struct list_head bf_head;
 	INIT_LIST_HEAD(&bf_head);
 
-	for (;;) {
-		if (list_empty(&tid->buf_q))
-			break;
-		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
-
-		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
+	if (txtid->state & AGGR_CLEANUP)
+		return 0;
 
-		/* update baw for software retried frame */
-		if (bf_isretried(bf))
-			ath_tx_update_baw(sc, tid, bf->bf_seqno);
+	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
+		txtid->addba_exchangeattempts = 0;
+		return 0;
+	}
 
-		/*
-		 * do not indicate packets while holding txq spinlock.
-		 * unlock is intentional here
-		 */
-		spin_unlock(&txq->axq_lock);
+	ath_tx_pause_tid(sc, txtid);
 
-		/* complete this sub-frame */
+	/* drop all software retried frames and mark this TID */
+	spin_lock_bh(&txq->axq_lock);
+	while (!list_empty(&txtid->buf_q)) {
+		bf = list_first_entry(&txtid->buf_q, struct ath_buf, list);
+		if (!bf_isretried(bf)) {
+			/*
+			 * NB: it's based on the assumption that
+			 * software retried frame will always stay
+			 * at the head of software queue.
+			 */
+			break;
+		}
+		list_cut_position(&bf_head,
+			&txtid->buf_q, &bf->bf_lastfrm->list);
+		ath_tx_update_baw(sc, txtid, bf->bf_seqno);
 		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+	}
 
-		spin_lock(&txq->axq_lock);
+	if (txtid->baw_head != txtid->baw_tail) {
+		spin_unlock_bh(&txq->axq_lock);
+		txtid->state |= AGGR_CLEANUP;
+	} else {
+		txtid->state &= ~AGGR_ADDBA_COMPLETE;
+		txtid->addba_exchangeattempts = 0;
+		spin_unlock_bh(&txq->axq_lock);
+		ath_tx_flush_tid(sc, txtid);
 	}
 
-	/*
-	 * TODO: For frame(s) that are in the retry state, we will reuse the
-	 * sequence number(s) without setting the retry bit. The
-	 * alternative is to give up on these and BAR the receiver's window
-	 * forward.
-	 */
-	tid->seq_next = tid->seq_start;
-	tid->baw_tail = tid->baw_head;
+	return 0;
 }
 
-/*
- * Drain all pending buffers
- * NB: must be called with txq lock held
- */
-static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
-					  struct ath_txq *txq)
+void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
 {
-	struct ath_atx_ac *ac, *ac_tmp;
-	struct ath_atx_tid *tid, *tid_tmp;
+	struct ath_atx_tid *txtid;
+	struct ath_node *an;
 
-	list_for_each_entry_safe(ac, ac_tmp, &txq->axq_acq, list) {
-		list_del(&ac->list);
-		ac->sched = false;
-		list_for_each_entry_safe(tid, tid_tmp, &ac->tid_q, list) {
-			list_del(&tid->list);
-			tid->sched = false;
-			ath_tid_drain(sc, txq, tid);
-		}
+	an = (struct ath_node *)sta->drv_priv;
+
+	if (sc->sc_flags & SC_OP_TXAGGR) {
+		txtid = ATH_AN_2_TID(an, tid);
+		txtid->baw_size =
+			IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
+		txtid->state |= AGGR_ADDBA_COMPLETE;
+		txtid->state &= ~AGGR_ADDBA_PROGRESS;
+		ath_tx_resume_tid(sc, txtid);
 	}
 }
 
-static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
-				struct sk_buff *skb,
-				struct ath_tx_control *txctl)
+bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 {
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct ath_tx_info_priv *tx_info_priv;
-	int hdrlen;
-	__le16 fc;
-
-	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
-	if (unlikely(!tx_info_priv))
-		return -ENOMEM;
-	tx_info->rate_driver_data[0] = tx_info_priv;
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	fc = hdr->frame_control;
-
-	ATH_TXBUF_RESET(bf);
-
-	/* Frame type */
-
-	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
-
-	ieee80211_is_data(fc) ?
-		(bf->bf_state.bf_type |= BUF_DATA) :
-		(bf->bf_state.bf_type &= ~BUF_DATA);
-	ieee80211_is_back_req(fc) ?
-		(bf->bf_state.bf_type |= BUF_BAR) :
-		(bf->bf_state.bf_type &= ~BUF_BAR);
-	ieee80211_is_pspoll(fc) ?
-		(bf->bf_state.bf_type |= BUF_PSPOLL) :
-		(bf->bf_state.bf_type &= ~BUF_PSPOLL);
-	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
-		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
-		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
-	(conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
-	 (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) ?
-		(bf->bf_state.bf_type |= BUF_HT) :
-		(bf->bf_state.bf_type &= ~BUF_HT);
-
-	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
+	struct ath_atx_tid *txtid;
 
-	/* Crypto */
+	if (!(sc->sc_flags & SC_OP_TXAGGR))
+		return false;
 
-	bf->bf_keytype = get_hw_crypto_keytype(skb);
+	txtid = ATH_AN_2_TID(an, tidno);
 
-	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
-		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
-		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
-	} else {
-		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
+	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
+		if (!(txtid->state & AGGR_ADDBA_PROGRESS) &&
+		    (txtid->addba_exchangeattempts < ADDBA_EXCHANGE_ATTEMPTS)) {
+			txtid->addba_exchangeattempts++;
+			return true;
+		}
 	}
 
-	/* Assign seqno, tidno */
-
-	if (ieee80211_is_data_qos(fc) && (sc->sc_flags & SC_OP_TXAGGR))
-		assign_aggr_tid_seqno(skb, bf);
-
-	/* DMA setup */
-	bf->bf_mpdu = skb;
+	return false;
+}
 
-	bf->bf_dmacontext = dma_map_single(sc->dev, skb->data,
-					   skb->len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
-		bf->bf_mpdu = NULL;
-		DPRINTF(sc, ATH_DBG_CONFIG,
-			"dma_mapping_error() on TX\n");
-		return -ENOMEM;
-	}
+/********************/
+/* Queue Management */
+/********************/
 
-	bf->bf_buf_addr = bf->bf_dmacontext;
-	return 0;
+static u32 ath_txq_depth(struct ath_softc *sc, int qnum)
+{
+	return sc->tx.txq[qnum].axq_depth;
 }
 
-/* FIXME: tx power */
-static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
-			     struct ath_tx_control *txctl)
+static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
 {
-	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
-	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
-	struct ath_node *an = NULL;
-	struct list_head bf_head;
-	struct ath_desc *ds;
-	struct ath_atx_tid *tid;
 	struct ath_hal *ah = sc->sc_ah;
-	int frm_type;
-
-	frm_type = get_hw_packet_type(skb);
-
-	INIT_LIST_HEAD(&bf_head);
-	list_add_tail(&bf->list, &bf_head);
-
-	/* setup descriptor */
-
-	ds = bf->bf_desc;
-	ds->ds_link = 0;
-	ds->ds_data = bf->bf_buf_addr;
-
-	/* Formulate first tx descriptor with tx controls */
-
-	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
-			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
-
-	ath9k_hw_filltxdesc(ah, ds,
-			    skb->len,	/* segment length */
-			    true,	/* first segment */
-			    true,	/* last segment */
-			    ds);	/* first descriptor */
-
-	bf->bf_lastfrm = bf;
-
-	spin_lock_bh(&txctl->txq->axq_lock);
-
-	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR) &&
-	    tx_info->control.sta) {
-		an = (struct ath_node *)tx_info->control.sta->drv_priv;
-		tid = ATH_AN_2_TID(an, bf->bf_tidno);
-
-		if (ath_aggr_query(sc, an, bf->bf_tidno)) {
-			/*
-			 * Try aggregation if it's a unicast data frame
-			 * and the destination is HT capable.
-			 */
-			ath_tx_send_ampdu(sc, tid, &bf_head, txctl);
-		} else {
-			/*
-			 * Send this frame as regular when ADDBA
-			 * exchange is neither complete nor pending.
-			 */
-			ath_tx_send_normal(sc, txctl->txq,
-					   tid, &bf_head);
-		}
-	} else {
-		bf->bf_lastbf = bf;
-		bf->bf_nframes = 1;
-
-		ath_buf_set_rate(sc, bf);
-		ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
-	}
-
-	spin_unlock_bh(&txctl->txq->axq_lock);
+	(void) ath9k_hw_stoptxdma(ah, txq->axq_qnum);
 }
 
-/* Upon failure caller should free skb */
-int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
-		 struct ath_tx_control *txctl)
+static void ath_get_beaconconfig(struct ath_softc *sc, int if_id,
+				 struct ath_beacon_config *conf)
 {
-	struct ath_buf *bf;
-	int r;
-
-	/* Check if a tx buffer is available */
-
-	bf = ath_tx_get_buffer(sc);
-	if (!bf) {
-		DPRINTF(sc, ATH_DBG_XMIT, "TX buffers are full\n");
-		return -1;
-	}
-
-	r = ath_tx_setup_buffer(sc, bf, skb, txctl);
-	if (unlikely(r)) {
-		struct ath_txq *txq = txctl->txq;
-
-		DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
-
-		/* upon ath_tx_processq() this TX queue will be resumed, we
-		 * guarantee this will happen by knowing beforehand that
-		 * we will at least have to run TX completionon one buffer
-		 * on the queue */
-		spin_lock_bh(&txq->axq_lock);
-		if (ath_txq_depth(sc, txq->axq_qnum) > 1) {
-			ieee80211_stop_queue(sc->hw,
-				skb_get_queue_mapping(skb));
-			txq->stopped = 1;
-		}
-		spin_unlock_bh(&txq->axq_lock);
-
-		spin_lock_bh(&sc->tx.txbuflock);
-		list_add_tail(&bf->list, &sc->tx.txbuf);
-		spin_unlock_bh(&sc->tx.txbuflock);
-
-		return r;
-	}
+	struct ieee80211_hw *hw = sc->hw;
 
-	ath_tx_start_dma(sc, bf, txctl);
+	/* fill in beacon config data */
 
-	return 0;
+	conf->beacon_interval = hw->conf.beacon_int;
+	conf->listen_interval = 100;
+	conf->dtim_count = 1;
+	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
 }
 
-/* Initialize TX queue and h/w */
-
-int ath_tx_init(struct ath_softc *sc, int nbufs)
+static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 {
-	int error = 0;
-
-	do {
-		spin_lock_init(&sc->tx.txbuflock);
+	struct ath_hal *ah = sc->sc_ah;
+	int i, npend = 0;
 
-		/* Setup tx descriptors */
-		error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
-			"tx", nbufs, 1);
-		if (error != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Failed to allocate tx descriptors: %d\n",
-				error);
-			break;
+	if (!(sc->sc_flags & SC_OP_INVALID)) {
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (ATH_TXQ_SETUP(sc, i)) {
+				ath_tx_stopdma(sc, &sc->tx.txq[i]);
+				npend += ath9k_hw_numtxpending(ah,
+						       sc->tx.txq[i].axq_qnum);
+			}
 		}
+	}
 
-		/* XXX allocate beacon state together with vap */
-		error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
-					  "beacon", ATH_BCBUF, 1);
-		if (error != 0) {
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"Failed to allocate beacon descriptors: %d\n",
-				error);
-			break;
-		}
+	if (npend) {
+		int r;
 
-	} while (0);
+		DPRINTF(sc, ATH_DBG_XMIT, "Unable to stop TxDMA. Reset HAL!\n");
 
-	if (error != 0)
-		ath_tx_cleanup(sc);
+		spin_lock_bh(&sc->sc_resetlock);
+		r = ath9k_hw_reset(ah, sc->sc_ah->ah_curchan, true);
+		if (r)
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"Unable to reset hardware; reset status %u\n",
+				r);
+		spin_unlock_bh(&sc->sc_resetlock);
+	}
 
-	return error;
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (ATH_TXQ_SETUP(sc, i))
+			ath_tx_draintxq(sc, &sc->tx.txq[i], retry_tx);
+	}
 }
 
-/* Reclaim all tx queue resources */
-
-int ath_tx_cleanup(struct ath_softc *sc)
+static void ath_txq_drain_pending_buffers(struct ath_softc *sc,
+					  struct ath_txq *txq)
 {
-	/* cleanup beacon descriptors */
-	if (sc->beacon.bdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->beacon.bdma, &sc->beacon.bbuf);
-
-	/* cleanup tx descriptors */
-	if (sc->tx.txdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->tx.txdma, &sc->tx.txbuf);
+	struct ath_atx_ac *ac, *ac_tmp;
+	struct ath_atx_tid *tid, *tid_tmp;
 
-	return 0;
+	list_for_each_entry_safe(ac, ac_tmp, &txq->axq_acq, list) {
+		list_del(&ac->list);
+		ac->sched = false;
+		list_for_each_entry_safe(tid, tid_tmp, &ac->tid_q, list) {
+			list_del(&tid->list);
+			tid->sched = false;
+			ath_tid_drain(sc, txq, tid);
+		}
+	}
 }
 
-/* Setup a h/w transmit queue */
-
 struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 {
 	struct ath_hal *ah = sc->sc_ah;
@@ -1960,43 +1013,7 @@ struct ath_txq *ath_txq_setup(struct ath_softc *sc, int qtype, int subtype)
 	return &sc->tx.txq[qnum];
 }
 
-/* Reclaim resources for a setup queue */
-
-void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
-{
-	ath9k_hw_releasetxqueue(sc->sc_ah, txq->axq_qnum);
-	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
-}
-
-/*
- * Setup a hardware data transmit queue for the specified
- * access control.  The hal may not support all requested
- * queues in which case it will return a reference to a
- * previously setup queue.  We record the mapping from ac's
- * to h/w queues for use by ath_tx_start and also track
- * the set of h/w queues being used to optimize work in the
- * transmit interrupt handler and related routines.
- */
-
-int ath_tx_setup(struct ath_softc *sc, int haltype)
-{
-	struct ath_txq *txq;
-
-	if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
-			"HAL AC %u out of range, max %zu!\n",
-			 haltype, ARRAY_SIZE(sc->tx.hwq_map));
-		return 0;
-	}
-	txq = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, haltype);
-	if (txq != NULL) {
-		sc->tx.hwq_map[haltype] = txq->axq_qnum;
-		return 1;
-	} else
-		return 0;
-}
-
-int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
+static int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 {
 	int qnum;
 
@@ -2022,8 +1039,6 @@ int ath_tx_get_qnum(struct ath_softc *sc, int qtype, int haltype)
 	return qnum;
 }
 
-/* Get a transmit queue, if available */
-
 struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ath_txq *txq = NULL;
@@ -2034,7 +1049,6 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 
 	spin_lock_bh(&txq->axq_lock);
 
-	/* Try to avoid running out of descriptors */
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"TX queue: %d is full, depth: %d\n",
@@ -2050,8 +1064,6 @@ struct ath_txq *ath_test_get_txq(struct ath_softc *sc, struct sk_buff *skb)
 	return txq;
 }
 
-/* Update parameters for a transmit queue */
-
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *qinfo)
 {
@@ -2083,7 +1095,7 @@ int ath_txq_update(struct ath_softc *sc, int qnum,
 			"Unable to update hardware queue %u!\n", qnum);
 		error = -EIO;
 	} else {
-		ath9k_hw_resettxqueue(ah, qnum); /* push to h/w */
+		ath9k_hw_resettxqueue(ah, qnum);
 	}
 
 	return error;
@@ -2112,26 +1124,7 @@ int ath_cabq_update(struct ath_softc *sc)
 	return 0;
 }
 
-/* Deferred processing of transmit interrupt */
-
-void ath_tx_tasklet(struct ath_softc *sc)
-{
-	int i;
-	u32 qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
-
-	ath9k_hw_gettxintrtxqs(sc->sc_ah, &qcumask);
-
-	/*
-	 * Process each active queue.
-	 */
-	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-		if (ATH_TXQ_SETUP(sc, i) && (qcumask & (1 << i)))
-			ath_tx_processq(sc, &sc->tx.txq[i]);
-	}
-}
-
-void ath_tx_draintxq(struct ath_softc *sc,
-	struct ath_txq *txq, bool retry_tx)
+void ath_tx_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
@@ -2191,44 +1184,245 @@ void ath_tx_draintxq(struct ath_softc *sc,
 	}
 }
 
-/* Drain the transmit queues and reclaim resources */
+void ath_tx_cleanupq(struct ath_softc *sc, struct ath_txq *txq)
+{
+	ath9k_hw_releasetxqueue(sc->sc_ah, txq->axq_qnum);
+	sc->tx.txqsetup &= ~(1<<txq->axq_qnum);
+}
 
 void ath_draintxq(struct ath_softc *sc, bool retry_tx)
 {
-	/* stop beacon queue. The beacon will be freed when
-	 * we go to INIT state */
-	if (!(sc->sc_flags & SC_OP_INVALID)) {
+	if (!(sc->sc_flags & SC_OP_INVALID))
 		(void) ath9k_hw_stoptxdma(sc->sc_ah, sc->beacon.beaconq);
-		DPRINTF(sc, ATH_DBG_XMIT, "beacon queue %x\n",
-			ath9k_hw_gettxbuf(sc->sc_ah, sc->beacon.beaconq));
-	}
 
 	ath_drain_txdataq(sc, retry_tx);
 }
 
-u32 ath_txq_depth(struct ath_softc *sc, int qnum)
+void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 {
-	return sc->tx.txq[qnum].axq_depth;
+	struct ath_atx_ac *ac;
+	struct ath_atx_tid *tid;
+
+	if (list_empty(&txq->axq_acq))
+		return;
+
+	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
+	list_del(&ac->list);
+	ac->sched = false;
+
+	do {
+		if (list_empty(&ac->tid_q))
+			return;
+
+		tid = list_first_entry(&ac->tid_q, struct ath_atx_tid, list);
+		list_del(&tid->list);
+		tid->sched = false;
+
+		if (tid->paused)
+			continue;
+
+		if ((txq->axq_depth % 2) == 0)
+			ath_tx_sched_aggr(sc, txq, tid);
+
+		/*
+		 * add tid to round-robin queue if more frames
+		 * are pending for the tid
+		 */
+		if (!list_empty(&tid->buf_q))
+			ath_tx_queue_tid(txq, tid);
+
+		break;
+	} while (!list_empty(&ac->tid_q));
+
+	if (!list_empty(&ac->tid_q)) {
+		if (!ac->sched) {
+			ac->sched = true;
+			list_add_tail(&ac->list, &txq->axq_acq);
+		}
+	}
+}
+
+int ath_tx_setup(struct ath_softc *sc, int haltype)
+{
+	struct ath_txq *txq;
+
+	if (haltype >= ARRAY_SIZE(sc->tx.hwq_map)) {
+		DPRINTF(sc, ATH_DBG_FATAL,
+			"HAL AC %u out of range, max %zu!\n",
+			 haltype, ARRAY_SIZE(sc->tx.hwq_map));
+		return 0;
+	}
+	txq = ath_txq_setup(sc, ATH9K_TX_QUEUE_DATA, haltype);
+	if (txq != NULL) {
+		sc->tx.hwq_map[haltype] = txq->axq_qnum;
+		return 1;
+	} else
+		return 0;
 }
 
-u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum)
+/***********/
+/* TX, DMA */
+/***********/
+
+/*
+ * Insert a chain of ath_buf (descriptors) on a txq and
+ * assume the descriptors are already chained together by caller.
+ */
+static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
+			     struct list_head *head)
 {
-	return sc->tx.txq[qnum].axq_aggr_depth;
+	struct ath_hal *ah = sc->sc_ah;
+	struct ath_buf *bf;
+
+	/*
+	 * Insert the frame on the outbound list and
+	 * pass it on to the hardware.
+	 */
+
+	if (list_empty(head))
+		return;
+
+	bf = list_first_entry(head, struct ath_buf, list);
+
+	list_splice_tail_init(head, &txq->axq_q);
+	txq->axq_depth++;
+	txq->axq_totalqueued++;
+	txq->axq_linkbuf = list_entry(txq->axq_q.prev, struct ath_buf, list);
+
+	DPRINTF(sc, ATH_DBG_QUEUE,
+		"qnum: %d, txq depth: %d\n", txq->axq_qnum, txq->axq_depth);
+
+	if (txq->axq_link == NULL) {
+		ath9k_hw_puttxbuf(ah, txq->axq_qnum, bf->bf_daddr);
+		DPRINTF(sc, ATH_DBG_XMIT,
+			"TXDP[%u] = %llx (%p)\n",
+			txq->axq_qnum, ito64(bf->bf_daddr), bf->bf_desc);
+	} else {
+		*txq->axq_link = bf->bf_daddr;
+		DPRINTF(sc, ATH_DBG_XMIT, "link[%u] (%p)=%llx (%p)\n",
+			txq->axq_qnum, txq->axq_link,
+			ito64(bf->bf_daddr), bf->bf_desc);
+	}
+	txq->axq_link = &(bf->bf_lastbf->bf_desc->ds_link);
+	ath9k_hw_txstart(ah, txq->axq_qnum);
 }
 
-bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
+static struct ath_buf *ath_tx_get_buffer(struct ath_softc *sc)
 {
-	struct ath_atx_tid *txtid;
+	struct ath_buf *bf = NULL;
 
-	if (!(sc->sc_flags & SC_OP_TXAGGR))
-		return false;
+	spin_lock_bh(&sc->tx.txbuflock);
 
-	txtid = ATH_AN_2_TID(an, tidno);
+	if (unlikely(list_empty(&sc->tx.txbuf))) {
+		spin_unlock_bh(&sc->tx.txbuflock);
+		return NULL;
+	}
 
-	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
-		if (!(txtid->state & AGGR_ADDBA_PROGRESS) &&
-		    (txtid->addba_exchangeattempts < ADDBA_EXCHANGE_ATTEMPTS)) {
-			txtid->addba_exchangeattempts++;
+	bf = list_first_entry(&sc->tx.txbuf, struct ath_buf, list);
+	list_del(&bf->list);
+
+	spin_unlock_bh(&sc->tx.txbuflock);
+
+	return bf;
+}
+
+static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
+			      struct list_head *bf_head,
+			      struct ath_tx_control *txctl)
+{
+	struct ath_buf *bf;
+
+	BUG_ON(list_empty(bf_head));
+
+	bf = list_first_entry(bf_head, struct ath_buf, list);
+	bf->bf_state.bf_type |= BUF_AMPDU;
+
+	/*
+	 * Do not queue to h/w when any of the following conditions is true:
+	 * - there are pending frames in software queue
+	 * - the TID is currently paused for ADDBA/BAR request
+	 * - seqno is not within block-ack window
+	 * - h/w queue depth exceeds low water mark
+	 */
+	if (!list_empty(&tid->buf_q) || tid->paused ||
+	    !BAW_WITHIN(tid->seq_start, tid->baw_size, bf->bf_seqno) ||
+	    txctl->txq->axq_depth >= ATH_AGGR_MIN_QDEPTH) {
+		/*
+		 * Add this frame to software queue for scheduling later
+		 * for aggregation.
+		 */
+		list_splice_tail_init(bf_head, &tid->buf_q);
+		ath_tx_queue_tid(txctl->txq, tid);
+		return;
+	}
+
+	/* Add sub-frame to BAW */
+	ath_tx_addto_baw(sc, tid, bf);
+
+	/* Queue to h/w without aggregation */
+	bf->bf_nframes = 1;
+	bf->bf_lastbf = bf->bf_lastfrm; /* one single frame */
+	ath_buf_set_rate(sc, bf);
+	ath_tx_txqaddbuf(sc, txctl->txq, bf_head);
+
+	return;
+}
+
+static void ath_tx_send_normal(struct ath_softc *sc, struct ath_txq *txq,
+			       struct ath_atx_tid *tid,
+			       struct list_head *bf_head)
+{
+	struct ath_buf *bf;
+
+	BUG_ON(list_empty(bf_head));
+
+	bf = list_first_entry(bf_head, struct ath_buf, list);
+	bf->bf_state.bf_type &= ~BUF_AMPDU;
+
+	/* update starting sequence number for subsequent ADDBA request */
+	INCR(tid->seq_start, IEEE80211_SEQ_MAX);
+
+	bf->bf_nframes = 1;
+	bf->bf_lastbf = bf->bf_lastfrm;
+	ath_buf_set_rate(sc, bf);
+	ath_tx_txqaddbuf(sc, txq, bf_head);
+}
+
+static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	enum ath9k_pkt_type htype;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	if (ieee80211_is_beacon(fc))
+		htype = ATH9K_PKT_TYPE_BEACON;
+	else if (ieee80211_is_probe_resp(fc))
+		htype = ATH9K_PKT_TYPE_PROBE_RESP;
+	else if (ieee80211_is_atim(fc))
+		htype = ATH9K_PKT_TYPE_ATIM;
+	else if (ieee80211_is_pspoll(fc))
+		htype = ATH9K_PKT_TYPE_PSPOLL;
+	else
+		htype = ATH9K_PKT_TYPE_NORMAL;
+
+	return htype;
+}
+
+static bool is_pae(struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	if (ieee80211_is_data(fc)) {
+		if (ieee80211_is_nullfunc(fc) ||
+		    /* Port Access Entity (IEEE 802.1X) */
+		    (skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 			return true;
 		}
 	}
@@ -2236,175 +1430,801 @@ bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 	return false;
 }
 
-/* Start TX aggregation */
+static int get_hw_crypto_keytype(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 
-int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		      u16 tid, u16 *ssn)
+	if (tx_info->control.hw_key) {
+		if (tx_info->control.hw_key->alg == ALG_WEP)
+			return ATH9K_KEY_TYPE_WEP;
+		else if (tx_info->control.hw_key->alg == ALG_TKIP)
+			return ATH9K_KEY_TYPE_TKIP;
+		else if (tx_info->control.hw_key->alg == ALG_CCMP)
+			return ATH9K_KEY_TYPE_AES;
+	}
+
+	return ATH9K_KEY_TYPE_CLEAR;
+}
+
+static void assign_aggr_tid_seqno(struct sk_buff *skb,
+				  struct ath_buf *bf)
 {
-	struct ath_atx_tid *txtid;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr;
 	struct ath_node *an;
+	struct ath_atx_tid *tid;
+	__le16 fc;
+	u8 *qc;
 
-	an = (struct ath_node *)sta->drv_priv;
+	if (!tx_info->control.sta)
+		return;
 
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		txtid = ATH_AN_2_TID(an, tid);
-		txtid->state |= AGGR_ADDBA_PROGRESS;
-		ath_tx_pause_tid(sc, txtid);
+	an = (struct ath_node *)tx_info->control.sta->drv_priv;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+
+	if (ieee80211_is_data_qos(fc)) {
+		qc = ieee80211_get_qos_ctl(hdr);
+		bf->bf_tidno = qc[0] & 0xf;
 	}
 
-	return 0;
+	/*
+	 * For HT capable stations, we save tidno for later use.
+	 * We also override seqno set by upper layer with the one
+	 * in tx aggregation state.
+	 *
+	 * If fragmentation is on, the sequence number is
+	 * not overridden, since it has been
+	 * incremented by the fragmentation routine.
+	 *
+	 * FIXME: check if the fragmentation threshold exceeds
+	 * IEEE80211 max.
+	 */
+	tid = ATH_AN_2_TID(an, bf->bf_tidno);
+	hdr->seq_ctrl = cpu_to_le16(tid->seq_next <<
+			IEEE80211_SEQ_SEQ_SHIFT);
+	bf->bf_seqno = tid->seq_next;
+	INCR(tid->seq_next, IEEE80211_SEQ_MAX);
 }
 
-/* Stop tx aggregation */
-
-int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
+static int setup_tx_flags(struct ath_softc *sc, struct sk_buff *skb,
+			  struct ath_txq *txq)
 {
-	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	int flags = 0;
 
-	ath_tx_aggr_teardown(sc, an, tid);
-	return 0;
+	flags |= ATH9K_TXDESC_CLRDMASK; /* needed for crypto errors */
+	flags |= ATH9K_TXDESC_INTREQ;
+
+	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK)
+		flags |= ATH9K_TXDESC_NOACK;
+	if (tx_info->control.rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS)
+		flags |= ATH9K_TXDESC_RTSENA;
+
+	return flags;
 }
 
-/* Resume tx aggregation */
+/*
+ * rix - rate index
+ * pktlen - total bytes (delims + data + fcs + pads + pad delims)
+ * width  - 0 for 20 MHz, 1 for 40 MHz
+ * half_gi - to use 4us v/s 3.6 us for symbol time
+ */
+static u32 ath_pkt_duration(struct ath_softc *sc, u8 rix, struct ath_buf *bf,
+			    int width, int half_gi, bool shortPreamble)
+{
+	struct ath_rate_table *rate_table = sc->cur_rate_table;
+	u32 nbits, nsymbits, duration, nsymbols;
+	u8 rc;
+	int streams, pktlen;
 
-void ath_tx_aggr_resume(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
+	pktlen = bf_isaggr(bf) ? bf->bf_al : bf->bf_frmlen;
+	rc = rate_table->info[rix].ratecode;
+
+	/* for legacy rates, use old function to compute packet duration */
+	if (!IS_HT_RATE(rc))
+		return ath9k_hw_computetxtime(sc->sc_ah, rate_table, pktlen,
+					      rix, shortPreamble);
+
+	/* find number of symbols: PLCP + data */
+	nbits = (pktlen << 3) + OFDM_PLCP_BITS;
+	nsymbits = bits_per_symbol[HT_RC_2_MCS(rc)][width];
+	nsymbols = (nbits + nsymbits - 1) / nsymbits;
+
+	if (!half_gi)
+		duration = SYMBOL_TIME(nsymbols);
+	else
+		duration = SYMBOL_TIME_HALFGI(nsymbols);
+
+	/* addup duration for legacy/ht training and signal fields */
+	streams = HT_RC_2_STREAMS(rc);
+	duration += L_STF + L_LTF + L_SIG + HT_SIG + HT_STF + HT_LTF(streams);
+
+	return duration;
+}
+
+static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 {
-	struct ath_atx_tid *txtid;
-	struct ath_node *an;
+	struct ath_hal *ah = sc->sc_ah;
+	struct ath_rate_table *rt;
+	struct ath_desc *ds = bf->bf_desc;
+	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
+	struct ath9k_11n_rate_series series[4];
+	struct sk_buff *skb;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rates;
+	struct ieee80211_hdr *hdr;
+	struct ieee80211_hw *hw = sc->hw;
+	int i, flags, rtsctsena = 0, enable_g_protection = 0;
+	u32 ctsduration = 0;
+	u8 rix = 0, cix, ctsrate = 0;
+	__le16 fc;
 
-	an = (struct ath_node *)sta->drv_priv;
+	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
-	if (sc->sc_flags & SC_OP_TXAGGR) {
-		txtid = ATH_AN_2_TID(an, tid);
-		txtid->baw_size =
-			IEEE80211_MIN_AMPDU_BUF << sta->ht_cap.ampdu_factor;
-		txtid->state |= AGGR_ADDBA_COMPLETE;
-		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		ath_tx_resume_tid(sc, txtid);
+	skb = (struct sk_buff *)bf->bf_mpdu;
+	hdr = (struct ieee80211_hdr *)skb->data;
+	fc = hdr->frame_control;
+	tx_info = IEEE80211_SKB_CB(skb);
+	rates = tx_info->control.rates;
+
+	if (ieee80211_has_morefrags(fc) ||
+	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
+		rates[1].count = rates[2].count = rates[3].count = 0;
+		rates[1].idx = rates[2].idx = rates[3].idx = 0;
+		rates[0].count = ATH_TXMAXTRY;
+	}
+
+	/* get the cix for the lowest valid rix */
+	rt = sc->cur_rate_table;
+	for (i = 3; i >= 0; i--) {
+		if (rates[i].count && (rates[i].idx >= 0)) {
+			rix = rates[i].idx;
+			break;
+		}
+	}
+
+	flags = (bf->bf_flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA));
+	cix = rt->info[rix].ctrl_rate;
+
+	/* All protection frames are transmited at 2Mb/s for 802.11g,
+	 * otherwise we transmit them at 1Mb/s */
+	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
+	  !conf_is_ht(&hw->conf))
+		enable_g_protection = 1;
+
+	/*
+	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
+	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
+	 */
+	if (sc->sc_protmode != PROT_M_NONE && !(bf->bf_flags & ATH9K_TXDESC_NOACK)
+	    && (rt->info[rix].phy == WLAN_RC_PHY_OFDM ||
+		WLAN_RC_PHY_HT(rt->info[rix].phy))) {
+		if (sc->sc_protmode == PROT_M_RTSCTS)
+			flags = ATH9K_TXDESC_RTSENA;
+		else if (sc->sc_protmode == PROT_M_CTSONLY)
+			flags = ATH9K_TXDESC_CTSENA;
+
+		cix = rt->info[enable_g_protection].ctrl_rate;
+		rtsctsena = 1;
 	}
+
+	/* For 11n, the default behavior is to enable RTS for hw retried frames.
+	 * We enable the global flag here and let rate series flags determine
+	 * which rates will actually use RTS.
+	 */
+	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf_isdata(bf)) {
+		/* 802.11g protection not needed, use our default behavior */
+		if (!rtsctsena)
+			flags = ATH9K_TXDESC_RTSENA;
+	}
+
+	/* Set protection if aggregate protection on */
+	if (sc->sc_config.ath_aggr_prot &&
+	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
+		flags = ATH9K_TXDESC_RTSENA;
+		cix = rt->info[enable_g_protection].ctrl_rate;
+		rtsctsena = 1;
+	}
+
+	/* For AR5416 - RTS cannot be followed by a frame larger than 8K */
+	if (bf_isaggr(bf) && (bf->bf_al > ah->ah_caps.rts_aggr_limit))
+		flags &= ~(ATH9K_TXDESC_RTSENA);
+
+	/*
+	 * CTS transmit rate is derived from the transmit rate by looking in the
+	 * h/w rate table.  We must also factor in whether or not a short
+	 * preamble is to be used. NB: cix is set above where RTS/CTS is enabled
+	 */
+	ctsrate = rt->info[cix].ratecode |
+		(bf_isshpreamble(bf) ? rt->info[cix].short_preamble : 0);
+
+	for (i = 0; i < 4; i++) {
+		if (!rates[i].count || (rates[i].idx < 0))
+			continue;
+
+		rix = rates[i].idx;
+
+		series[i].Rate = rt->info[rix].ratecode |
+			(bf_isshpreamble(bf) ? rt->info[rix].short_preamble : 0);
+
+		series[i].Tries = rates[i].count;
+
+		series[i].RateFlags = (
+			(rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) ?
+				ATH9K_RATESERIES_RTS_CTS : 0) |
+			((rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
+				ATH9K_RATESERIES_2040 : 0) |
+			((rates[i].flags & IEEE80211_TX_RC_SHORT_GI) ?
+				ATH9K_RATESERIES_HALFGI : 0);
+
+		series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
+			 (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) != 0,
+			 (rates[i].flags & IEEE80211_TX_RC_SHORT_GI),
+			 bf_isshpreamble(bf));
+
+		series[i].ChSel = sc->sc_tx_chainmask;
+
+		if (rtsctsena)
+			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
+	}
+
+	/* set dur_update_en for l-sig computation except for PS-Poll frames */
+	ath9k_hw_set11n_ratescenario(ah, ds, lastds, !bf_ispspoll(bf),
+				     ctsrate, ctsduration,
+				     series, 4, flags);
+
+	if (sc->sc_config.ath_aggr_prot && flags)
+		ath9k_hw_set11n_burstduration(ah, ds, 8192);
 }
 
-/*
- * Performs transmit side cleanup when TID changes from aggregated to
- * unaggregated.
- * - Pause the TID and mark cleanup in progress
- * - Discard all retry frames from the s/w queue.
- */
+static int ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
+				struct sk_buff *skb,
+				struct ath_tx_control *txctl)
+{
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath_tx_info_priv *tx_info_priv;
+	int hdrlen;
+	__le16 fc;
+
+	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
+	if (unlikely(!tx_info_priv))
+		return -ENOMEM;
+	tx_info->rate_driver_data[0] = tx_info_priv;
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	fc = hdr->frame_control;
+
+	ATH_TXBUF_RESET(bf);
+
+	bf->bf_frmlen = skb->len + FCS_LEN - (hdrlen & 3);
 
-void ath_tx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
+	ieee80211_is_data(fc) ?
+		(bf->bf_state.bf_type |= BUF_DATA) :
+		(bf->bf_state.bf_type &= ~BUF_DATA);
+	ieee80211_is_back_req(fc) ?
+		(bf->bf_state.bf_type |= BUF_BAR) :
+		(bf->bf_state.bf_type &= ~BUF_BAR);
+	ieee80211_is_pspoll(fc) ?
+		(bf->bf_state.bf_type |= BUF_PSPOLL) :
+		(bf->bf_state.bf_type &= ~BUF_PSPOLL);
+	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
+		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
+		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
+	(conf_is_ht(&sc->hw->conf) && !is_pae(skb) &&
+	 (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) ?
+		(bf->bf_state.bf_type |= BUF_HT) :
+		(bf->bf_state.bf_type &= ~BUF_HT);
+
+	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
+
+	bf->bf_keytype = get_hw_crypto_keytype(skb);
+
+	if (bf->bf_keytype != ATH9K_KEY_TYPE_CLEAR) {
+		bf->bf_frmlen += tx_info->control.hw_key->icv_len;
+		bf->bf_keyix = tx_info->control.hw_key->hw_key_idx;
+	} else {
+		bf->bf_keyix = ATH9K_TXKEYIX_INVALID;
+	}
+
+	if (ieee80211_is_data_qos(fc) && (sc->sc_flags & SC_OP_TXAGGR))
+		assign_aggr_tid_seqno(skb, bf);
+
+	bf->bf_mpdu = skb;
+
+	bf->bf_dmacontext = dma_map_single(sc->dev, skb->data,
+					   skb->len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sc->dev, bf->bf_dmacontext))) {
+		bf->bf_mpdu = NULL;
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"dma_mapping_error() on TX\n");
+		return -ENOMEM;
+	}
+
+	bf->bf_buf_addr = bf->bf_dmacontext;
+	return 0;
+}
+
+/* FIXME: tx power */
+static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
+			     struct ath_tx_control *txctl)
 {
-	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
-	struct ath_txq *txq = &sc->tx.txq[txtid->ac->qnum];
-	struct ath_buf *bf;
+	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info =  IEEE80211_SKB_CB(skb);
+	struct ath_node *an = NULL;
 	struct list_head bf_head;
+	struct ath_desc *ds;
+	struct ath_atx_tid *tid;
+	struct ath_hal *ah = sc->sc_ah;
+	int frm_type;
+
+	frm_type = get_hw_packet_type(skb);
+
 	INIT_LIST_HEAD(&bf_head);
+	list_add_tail(&bf->list, &bf_head);
 
-	if (txtid->state & AGGR_CLEANUP) /* cleanup is in progress */
-		return;
+	ds = bf->bf_desc;
+	ds->ds_link = 0;
+	ds->ds_data = bf->bf_buf_addr;
 
-	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
-		txtid->addba_exchangeattempts = 0;
-		return;
-	}
+	ath9k_hw_set11n_txdesc(ah, ds, bf->bf_frmlen, frm_type, MAX_RATE_POWER,
+			       bf->bf_keyix, bf->bf_keytype, bf->bf_flags);
 
-	/* TID must be paused first */
-	ath_tx_pause_tid(sc, txtid);
+	ath9k_hw_filltxdesc(ah, ds,
+			    skb->len,	/* segment length */
+			    true,	/* first segment */
+			    true,	/* last segment */
+			    ds);	/* first descriptor */
 
-	/* drop all software retried frames and mark this TID */
-	spin_lock_bh(&txq->axq_lock);
-	while (!list_empty(&txtid->buf_q)) {
-		bf = list_first_entry(&txtid->buf_q, struct ath_buf, list);
-		if (!bf_isretried(bf)) {
+	bf->bf_lastfrm = bf;
+
+	spin_lock_bh(&txctl->txq->axq_lock);
+
+	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR) &&
+	    tx_info->control.sta) {
+		an = (struct ath_node *)tx_info->control.sta->drv_priv;
+		tid = ATH_AN_2_TID(an, bf->bf_tidno);
+
+		if (ath_aggr_query(sc, an, bf->bf_tidno)) {
 			/*
-			 * NB: it's based on the assumption that
-			 * software retried frame will always stay
-			 * at the head of software queue.
+			 * Try aggregation if it's a unicast data frame
+			 * and the destination is HT capable.
 			 */
-			break;
+			ath_tx_send_ampdu(sc, tid, &bf_head, txctl);
+		} else {
+			/*
+			 * Send this frame as regular when ADDBA
+			 * exchange is neither complete nor pending.
+			 */
+			ath_tx_send_normal(sc, txctl->txq,
+					   tid, &bf_head);
 		}
-		list_cut_position(&bf_head,
-			&txtid->buf_q, &bf->bf_lastfrm->list);
-		ath_tx_update_baw(sc, txtid, bf->bf_seqno);
+	} else {
+		bf->bf_lastbf = bf;
+		bf->bf_nframes = 1;
 
-		/* complete this sub-frame */
-		ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
+		ath_buf_set_rate(sc, bf);
+		ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
 	}
 
-	if (txtid->baw_head != txtid->baw_tail) {
-		spin_unlock_bh(&txq->axq_lock);
-		txtid->state |= AGGR_CLEANUP;
-	} else {
-		txtid->state &= ~AGGR_ADDBA_COMPLETE;
-		txtid->addba_exchangeattempts = 0;
+	spin_unlock_bh(&txctl->txq->axq_lock);
+}
+
+/* Upon failure caller should free skb */
+int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
+		 struct ath_tx_control *txctl)
+{
+	struct ath_buf *bf;
+	int r;
+
+	bf = ath_tx_get_buffer(sc);
+	if (!bf) {
+		DPRINTF(sc, ATH_DBG_XMIT, "TX buffers are full\n");
+		return -1;
+	}
+
+	r = ath_tx_setup_buffer(sc, bf, skb, txctl);
+	if (unlikely(r)) {
+		struct ath_txq *txq = txctl->txq;
+
+		DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
+
+		/* upon ath_tx_processq() this TX queue will be resumed, we
+		 * guarantee this will happen by knowing beforehand that
+		 * we will at least have to run TX completionon one buffer
+		 * on the queue */
+		spin_lock_bh(&txq->axq_lock);
+		if (ath_txq_depth(sc, txq->axq_qnum) > 1) {
+			ieee80211_stop_queue(sc->hw,
+				skb_get_queue_mapping(skb));
+			txq->stopped = 1;
+		}
 		spin_unlock_bh(&txq->axq_lock);
-		ath_tx_flush_tid(sc, txtid);
+
+		spin_lock_bh(&sc->tx.txbuflock);
+		list_add_tail(&bf->list, &sc->tx.txbuf);
+		spin_unlock_bh(&sc->tx.txbuflock);
+
+		return r;
 	}
-}
 
-/*
- * Tx scheduling logic
- * NB: must be called with txq lock held
- */
+	ath_tx_start_dma(sc, bf, txctl);
 
-void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
+	return 0;
+}
+
+void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
 {
-	struct ath_atx_ac *ac;
-	struct ath_atx_tid *tid;
+	int hdrlen, padsize;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_control txctl;
 
-	/* nothing to schedule */
-	if (list_empty(&txq->axq_acq))
-		return;
-	/*
-	 * get the first node/ac pair on the queue
-	 */
-	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
-	list_del(&ac->list);
-	ac->sched = false;
+	memset(&txctl, 0, sizeof(struct ath_tx_control));
 
 	/*
-	 * process a single tid per destination
+	 * As a temporary workaround, assign seq# here; this will likely need
+	 * to be cleaned up to work better with Beacon transmission and virtual
+	 * BSSes.
 	 */
-	do {
-		/* nothing to schedule */
-		if (list_empty(&ac->tid_q))
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+			sc->tx.seq_no += 0x10;
+		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
+		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
+	}
+
+	/* Add the padding after the header if this is not already done */
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdrlen & 3) {
+		padsize = hdrlen % 4;
+		if (skb_headroom(skb) < padsize) {
+			DPRINTF(sc, ATH_DBG_XMIT, "TX CABQ padding failed\n");
+			dev_kfree_skb_any(skb);
 			return;
+		}
+		skb_push(skb, padsize);
+		memmove(skb->data, skb->data + padsize, hdrlen);
+	}
 
-		tid = list_first_entry(&ac->tid_q, struct ath_atx_tid, list);
-		list_del(&tid->list);
-		tid->sched = false;
+	txctl.txq = sc->beacon.cabq;
 
-		if (tid->paused)    /* check next tid to keep h/w busy */
-			continue;
+	DPRINTF(sc, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
 
-		if ((txq->axq_depth % 2) == 0)
-			ath_tx_sched_aggr(sc, txq, tid);
+	if (ath_tx_start(sc, skb, &txctl) != 0) {
+		DPRINTF(sc, ATH_DBG_XMIT, "CABQ TX failed\n");
+		goto exit;
+	}
 
+	return;
+exit:
+	dev_kfree_skb_any(skb);
+}
+
+/*****************/
+/* TX Completion */
+/*****************/
+
+static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
+			    struct ath_xmit_status *tx_status)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+	int hdrlen, padsize;
+
+	DPRINTF(sc, ATH_DBG_XMIT, "TX complete: skb: %p\n", skb);
+
+	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
+	    tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
+		kfree(tx_info_priv);
+		tx_info->rate_driver_data[0] = NULL;
+	}
+
+	if (tx_status->flags & ATH_TX_BAR) {
+		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
+		tx_status->flags &= ~ATH_TX_BAR;
+	}
+
+	if (!(tx_status->flags & (ATH_TX_ERROR | ATH_TX_XRETRY))) {
+		/* Frame was ACKed */
+		tx_info->flags |= IEEE80211_TX_STAT_ACK;
+	}
+
+	tx_info->status.rates[0].count = tx_status->retries + 1;
+
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	padsize = hdrlen & 3;
+	if (padsize && hdrlen >= 24) {
 		/*
-		 * add tid to round-robin queue if more frames
-		 * are pending for the tid
+		 * Remove MAC header padding before giving the frame back to
+		 * mac80211.
 		 */
-		if (!list_empty(&tid->buf_q))
-			ath_tx_queue_tid(txq, tid);
+		memmove(skb->data + padsize, skb->data, hdrlen);
+		skb_pull(skb, padsize);
+	}
 
-		/* only schedule one TID at a time */
-		break;
-	} while (!list_empty(&ac->tid_q));
+	ieee80211_tx_status(hw, skb);
+}
+
+static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
+				struct list_head *bf_q,
+				int txok, int sendbar)
+{
+	struct sk_buff *skb = bf->bf_mpdu;
+	struct ath_xmit_status tx_status;
+	unsigned long flags;
 
 	/*
-	 * schedule AC if more TIDs need processing
+	 * Set retry information.
+	 * NB: Don't use the information in the descriptor, because the frame
+	 * could be software retried.
 	 */
-	if (!list_empty(&ac->tid_q)) {
+	tx_status.retries = bf->bf_retries;
+	tx_status.flags = 0;
+
+	if (sendbar)
+		tx_status.flags = ATH_TX_BAR;
+
+	if (!txok) {
+		tx_status.flags |= ATH_TX_ERROR;
+
+		if (bf_isxretried(bf))
+			tx_status.flags |= ATH_TX_XRETRY;
+	}
+
+	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
+	ath_tx_complete(sc, skb, &tx_status);
+
+	/*
+	 * Return the list of ath_buf of this mpdu to free queue
+	 */
+	spin_lock_irqsave(&sc->tx.txbuflock, flags);
+	list_splice_tail_init(bf_q, &sc->tx.txbuf);
+	spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
+}
+
+static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
+			      int txok)
+{
+	struct ath_buf *bf_last = bf->bf_lastbf;
+	struct ath_desc *ds = bf_last->bf_desc;
+	u16 seq_st = 0;
+	u32 ba[WME_BA_BMP_SIZE >> 5];
+	int ba_index;
+	int nbad = 0;
+	int isaggr = 0;
+
+	if (ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
+		return 0;
+
+	isaggr = bf_isaggr(bf);
+	if (isaggr) {
+		seq_st = ATH_DS_BA_SEQ(ds);
+		memcpy(ba, ATH_DS_BA_BITMAP(ds), WME_BA_BMP_SIZE >> 3);
+	}
+
+	while (bf) {
+		ba_index = ATH_BA_INDEX(seq_st, bf->bf_seqno);
+		if (!txok || (isaggr && !ATH_BA_ISSET(ba, ba_index)))
+			nbad++;
+
+		bf = bf->bf_next;
+	}
+
+	return nbad;
+}
+
+static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
+{
+	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+
+	tx_info_priv->update_rc = false;
+	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
+		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+
+	if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
+	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
+		if (bf_isdata(bf)) {
+			memcpy(&tx_info_priv->tx, &ds->ds_txstat,
+			       sizeof(tx_info_priv->tx));
+			tx_info_priv->n_frames = bf->bf_nframes;
+			tx_info_priv->n_bad_frames = nbad;
+			tx_info_priv->update_rc = true;
+		}
+	}
+}
+
+static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
+{
+	struct ath_hal *ah = sc->sc_ah;
+	struct ath_buf *bf, *lastbf, *bf_held = NULL;
+	struct list_head bf_head;
+	struct ath_desc *ds;
+	int txok, nbad = 0;
+	int status;
+
+	DPRINTF(sc, ATH_DBG_QUEUE, "tx queue %d (%x), link %p\n",
+		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
+		txq->axq_link);
+
+	for (;;) {
+		spin_lock_bh(&txq->axq_lock);
+		if (list_empty(&txq->axq_q)) {
+			txq->axq_link = NULL;
+			txq->axq_linkbuf = NULL;
+			spin_unlock_bh(&txq->axq_lock);
+			break;
+		}
+		bf = list_first_entry(&txq->axq_q, struct ath_buf, list);
+
 		/*
-		 * add dest ac to txq if not already added
+		 * There is a race condition that a BH gets scheduled
+		 * after sw writes TxE and before hw re-load the last
+		 * descriptor to get the newly chained one.
+		 * Software must keep the last DONE descriptor as a
+		 * holding descriptor - software does so by marking
+		 * it with the STALE flag.
 		 */
-		if (!ac->sched) {
-			ac->sched = true;
-			list_add_tail(&ac->list, &txq->axq_acq);
+		bf_held = NULL;
+		if (bf->bf_status & ATH_BUFSTATUS_STALE) {
+			bf_held = bf;
+			if (list_is_last(&bf_held->list, &txq->axq_q)) {
+				/* FIXME:
+				 * The holding descriptor is the last
+				 * descriptor in queue. It's safe to remove
+				 * the last holding descriptor in BH context.
+				 */
+				spin_unlock_bh(&txq->axq_lock);
+				break;
+			} else {
+				bf = list_entry(bf_held->list.next,
+					struct ath_buf, list);
+			}
+		}
+
+		lastbf = bf->bf_lastbf;
+		ds = lastbf->bf_desc;
+
+		status = ath9k_hw_txprocdesc(ah, ds);
+		if (status == -EINPROGRESS) {
+			spin_unlock_bh(&txq->axq_lock);
+			break;
 		}
+		if (bf->bf_desc == txq->axq_lastdsWithCTS)
+			txq->axq_lastdsWithCTS = NULL;
+		if (ds == txq->axq_gatingds)
+			txq->axq_gatingds = NULL;
+
+		/*
+		 * Remove ath_buf's of the same transmit unit from txq,
+		 * however leave the last descriptor back as the holding
+		 * descriptor for hw.
+		 */
+		lastbf->bf_status |= ATH_BUFSTATUS_STALE;
+		INIT_LIST_HEAD(&bf_head);
+
+		if (!list_is_singular(&lastbf->list))
+			list_cut_position(&bf_head,
+				&txq->axq_q, lastbf->list.prev);
+
+		txq->axq_depth--;
+
+		if (bf_isaggr(bf))
+			txq->axq_aggr_depth--;
+
+		txok = (ds->ds_txstat.ts_status == 0);
+
+		spin_unlock_bh(&txq->axq_lock);
+
+		if (bf_held) {
+			list_del(&bf_held->list);
+			spin_lock_bh(&sc->tx.txbuflock);
+			list_add_tail(&bf_held->list, &sc->tx.txbuf);
+			spin_unlock_bh(&sc->tx.txbuflock);
+		}
+
+		if (!bf_isampdu(bf)) {
+			/*
+			 * This frame is sent out as a single frame.
+			 * Use hardware retry status for this frame.
+			 */
+			bf->bf_retries = ds->ds_txstat.ts_longretry;
+			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
+				bf->bf_state.bf_type |= BUF_XRETRY;
+			nbad = 0;
+		} else {
+			nbad = ath_tx_num_badfrms(sc, bf, txok);
+		}
+
+		ath_tx_rc_status(bf, ds, nbad);
+
+		if (bf_isampdu(bf))
+			ath_tx_complete_aggr_rifs(sc, txq, bf, &bf_head, txok);
+		else
+			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
+
+		spin_lock_bh(&txq->axq_lock);
+		if (txq->stopped && ath_txq_depth(sc, txq->axq_qnum) <=
+				(ATH_TXBUF - 20)) {
+			int qnum;
+			qnum = ath_get_mac80211_qnum(txq->axq_qnum, sc);
+			if (qnum != -1) {
+				ieee80211_wake_queue(sc->hw, qnum);
+				txq->stopped = 0;
+			}
+
+		}
+
+		if (sc->sc_flags & SC_OP_TXAGGR)
+			ath_txq_schedule(sc, txq);
+		spin_unlock_bh(&txq->axq_lock);
 	}
 }
 
-/* Initialize per-node transmit state */
+
+void ath_tx_tasklet(struct ath_softc *sc)
+{
+	int i;
+	u32 qcumask = ((1 << ATH9K_NUM_TX_QUEUES) - 1);
+
+	ath9k_hw_gettxintrtxqs(sc->sc_ah, &qcumask);
+
+	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+		if (ATH_TXQ_SETUP(sc, i) && (qcumask & (1 << i)))
+			ath_tx_processq(sc, &sc->tx.txq[i]);
+	}
+}
+
+/*****************/
+/* Init, Cleanup */
+/*****************/
+
+int ath_tx_init(struct ath_softc *sc, int nbufs)
+{
+	int error = 0;
+
+	do {
+		spin_lock_init(&sc->tx.txbuflock);
+
+		error = ath_descdma_setup(sc, &sc->tx.txdma, &sc->tx.txbuf,
+			"tx", nbufs, 1);
+		if (error != 0) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"Failed to allocate tx descriptors: %d\n",
+				error);
+			break;
+		}
+
+		error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
+					  "beacon", ATH_BCBUF, 1);
+		if (error != 0) {
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"Failed to allocate beacon descriptors: %d\n",
+				error);
+			break;
+		}
+
+	} while (0);
+
+	if (error != 0)
+		ath_tx_cleanup(sc);
+
+	return error;
+}
+
+int ath_tx_cleanup(struct ath_softc *sc)
+{
+	if (sc->beacon.bdma.dd_desc_len != 0)
+		ath_descdma_cleanup(sc, &sc->beacon.bdma, &sc->beacon.bbuf);
+
+	if (sc->tx.txdma.dd_desc_len != 0)
+		ath_descdma_cleanup(sc, &sc->tx.txdma, &sc->tx.txbuf);
+
+	return 0;
+}
 
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
@@ -2412,9 +2232,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	struct ath_atx_ac *ac;
 	int tidno, acno;
 
-	/*
-	 * Init per tid tx state
-	 */
 	for (tidno = 0, tid = &an->tid[tidno];
 	     tidno < WME_NUM_TID;
 	     tidno++, tid++) {
@@ -2424,22 +2241,16 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 		tid->baw_size  = WME_MAX_BA;
 		tid->baw_head  = tid->baw_tail = 0;
 		tid->sched     = false;
-		tid->paused = false;
+		tid->paused    = false;
 		tid->state &= ~AGGR_CLEANUP;
 		INIT_LIST_HEAD(&tid->buf_q);
-
 		acno = TID_TO_WME_AC(tidno);
 		tid->ac = &an->ac[acno];
-
-		/* ADDBA state */
 		tid->state &= ~AGGR_ADDBA_COMPLETE;
 		tid->state &= ~AGGR_ADDBA_PROGRESS;
 		tid->addba_exchangeattempts = 0;
 	}
 
-	/*
-	 * Init per ac tx state
-	 */
 	for (acno = 0, ac = &an->ac[acno];
 	     acno < WME_NUM_AC; acno++, ac++) {
 		ac->sched    = false;
@@ -2466,14 +2277,13 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 	}
 }
 
-/* Cleanupthe pending buffers for the node. */
-
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 {
 	int i;
 	struct ath_atx_ac *ac, *ac_tmp;
 	struct ath_atx_tid *tid, *tid_tmp;
 	struct ath_txq *txq;
+
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
 		if (ATH_TXQ_SETUP(sc, i)) {
 			txq = &sc->tx.txq[i];
@@ -2504,51 +2314,3 @@ void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
 		}
 	}
 }
-
-void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb)
-{
-	int hdrlen, padsize;
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_control txctl;
-
-	memset(&txctl, 0, sizeof(struct ath_tx_control));
-
-	/*
-	 * As a temporary workaround, assign seq# here; this will likely need
-	 * to be cleaned up to work better with Beacon transmission and virtual
-	 * BSSes.
-	 */
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-			sc->tx.seq_no += 0x10;
-		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
-		hdr->seq_ctrl |= cpu_to_le16(sc->tx.seq_no);
-	}
-
-	/* Add the padding after the header if this is not already done */
-	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
-	if (hdrlen & 3) {
-		padsize = hdrlen % 4;
-		if (skb_headroom(skb) < padsize) {
-			DPRINTF(sc, ATH_DBG_XMIT, "TX CABQ padding failed\n");
-			dev_kfree_skb_any(skb);
-			return;
-		}
-		skb_push(skb, padsize);
-		memmove(skb->data, skb->data + padsize, hdrlen);
-	}
-
-	txctl.txq = sc->beacon.cabq;
-
-	DPRINTF(sc, ATH_DBG_XMIT, "transmitting CABQ packet, skb: %p\n", skb);
-
-	if (ath_tx_start(sc, skb, &txctl) != 0) {
-		DPRINTF(sc, ATH_DBG_XMIT, "CABQ TX failed\n");
-		goto exit;
-	}
-
-	return;
-exit:
-	dev_kfree_skb_any(skb);
-}
-- 
1.6.0.3

