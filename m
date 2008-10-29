Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57637 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYJ2Evj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:51:39 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:51:39 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60221.281481.948692@gargle.gargle.HOWL> (sfid-20081029_060857_443462_114A6BCC)
Date: Wed, 29 Oct 2008 10:19:01 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 15/16] ath9k: Remove internal RX A-MPDU processing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 has RX A-MPDU reordering support.
Use that and remove redundant RX processing within the driver.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.c |    6 -
 drivers/net/wireless/ath9k/core.h |   43 ----
 drivers/net/wireless/ath9k/main.c |   36 +---
 drivers/net/wireless/ath9k/recv.c |  501 -------------------------------------
 4 files changed, 2 insertions(+), 584 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index d138446..5f5184a 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -1189,8 +1189,6 @@ void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta)
 
 	if (sc->sc_flags & SC_OP_TXAGGR)
 		ath_tx_node_init(sc, an);
-	if (sc->sc_flags & SC_OP_RXAGGR)
-		ath_rx_node_init(sc, an);
 
 	an->maxampdu = 1 << (IEEE80211_HTCAP_MAXRXAMPDU_FACTOR +
 			     sta->ht_cap.ampdu_factor);
@@ -1208,8 +1206,6 @@ void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 
 	if (sc->sc_flags & SC_OP_TXAGGR)
 		ath_tx_node_cleanup(sc, an);
-	if (sc->sc_flags & SC_OP_RXAGGR)
-		ath_rx_node_cleanup(sc, an);
 }
 
 /*
@@ -1230,8 +1226,6 @@ void ath_newassoc(struct ath_softc *sc,
 		for (tidno = 0; tidno < WME_NUM_TID; tidno++) {
 			if (sc->sc_flags & SC_OP_TXAGGR)
 				ath_tx_aggr_teardown(sc, an, tidno);
-			if (sc->sc_flags & SC_OP_RXAGGR)
-				ath_rx_aggr_teardown(sc, an, tidno);
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index dd33cb7..5b17e88 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -304,15 +304,7 @@ void ath_descdma_cleanup(struct ath_softc *sc,
 
 #define ATH_MAX_ANTENNA          3
 #define ATH_RXBUF                512
-#define ATH_RX_TIMEOUT           40      /* 40 milliseconds */
 #define WME_NUM_TID              16
-#define IEEE80211_BAR_CTL_TID_M  0xF000  /* tid mask */
-#define IEEE80211_BAR_CTL_TID_S  12      /* tid shift */
-
-enum ATH_RX_TYPE {
-	ATH_RX_NON_CONSUMED = 0,
-	ATH_RX_CONSUMED
-};
 
 /* per frame rx status block */
 struct ath_recv_status {
@@ -346,47 +338,18 @@ struct ath_rxbuf {
 	struct ath_recv_status rx_status;	/* cached rx status */
 };
 
-/* Per-TID aggregate receiver state for a node */
-struct ath_arx_tid {
-	struct ath_node *an;
-	struct ath_rxbuf *rxbuf;	/* re-ordering buffer */
-	struct timer_list timer;
-	spinlock_t tidlock;
-	int baw_head;			/* seq_next at head */
-	int baw_tail;			/* tail of block-ack window */
-	int seq_reset;			/* need to reset start sequence */
-	int addba_exchangecomplete;
-	u16 seq_next;			/* next expected sequence */
-	u16 baw_size;			/* block-ack window size */
-};
-
-/* Per-node receiver aggregate state */
-struct ath_arx {
-	struct ath_arx_tid tid[WME_NUM_TID];
-};
-
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
 void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
-void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an);
-void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_handle_rx_intr(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
 int ath_rx_tasklet(struct ath_softc *sc, int flush);
-int ath_rx_input(struct ath_softc *sc,
-		 struct ath_node *node,
-		 struct sk_buff *skb,
-		 struct ath_recv_status *rx_status,
-		 enum ATH_RX_TYPE *status);
 int _ath_rx_indicate(struct ath_softc *sc,
 		     struct sk_buff *skb,
 		     struct ath_recv_status *status,
 		     u16 keyix);
-int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
-		    struct ath_recv_status *status);
-
 /******/
 /* TX */
 /******/
@@ -599,7 +562,6 @@ struct aggr_rifs_param {
 /* Per-node aggregation state */
 struct ath_node_aggr {
 	struct ath_atx tx;	/* node transmit state */
-	struct ath_arx rx;	/* node receive state */
 };
 
 /* driver-specific node state */
@@ -616,11 +578,6 @@ void ath_tx_resume_tid(struct ath_softc *sc,
 bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 void ath_tx_aggr_teardown(struct ath_softc *sc,
 	struct ath_node *an, u8 tidno);
-void ath_rx_aggr_teardown(struct ath_softc *sc,
-	struct ath_node *an, u8 tidno);
-int ath_rx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
-		      u16 tid, u16 *ssn);
-int ath_rx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
 int ath_tx_aggr_start(struct ath_softc *sc, struct ieee80211_sta *sta,
 		      u16 tid, u16 *ssn);
 int ath_tx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7b8b3d5..376c530 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -445,12 +445,10 @@ int _ath_rx_indicate(struct ath_softc *sc,
 		     u16 keyix)
 {
 	struct ieee80211_hw *hw = sc->hw;
-	struct ath_node *an = NULL;
 	struct ieee80211_rx_status rx_status;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	int hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	int padsize;
-	enum ATH_RX_TYPE st;
 
 	/* see if any padding is done by the hw and remove it */
 	if (hdrlen & 3) {
@@ -474,28 +472,6 @@ int _ath_rx_indicate(struct ath_softc *sc,
 			rx_status.flag |= RX_FLAG_DECRYPTED;
 	}
 
-	if (an) {
-		ath_rx_input(sc, an,
-			     skb, status, &st);
-	}
-	if (!an || (st != ATH_RX_CONSUMED))
-		__ieee80211_rx(hw, skb, &rx_status);
-
-	return 0;
-}
-
-int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
-		    struct ath_recv_status *status)
-{
-	struct ath_softc *sc = an->an_sc;
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_rx_status rx_status;
-
-	/* Prepare rx status */
-	ath9k_rx_prepare(sc, skb, status, &rx_status);
-	if (!(status->flags & ATH_RX_DECRYPT_ERROR))
-		rx_status.flag |= RX_FLAG_DECRYPTED;
-
 	__ieee80211_rx(hw, skb, &rx_status);
 
 	return 0;
@@ -1485,18 +1461,10 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		ret = ath_rx_aggr_start(sc, sta, tid, ssn);
-		if (ret < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to start RX aggregation\n",
-				__func__);
+		if (!(sc->sc_flags & SC_OP_RXAGGR))
+			ret = -ENOTSUPP;
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		ret = ath_rx_aggr_stop(sc, sta, tid);
-		if (ret < 0)
-			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to stop RX aggregation\n",
-				__func__);
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		ret = ath_tx_aggr_start(sc, sta, tid, ssn);
diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 80f26b4..2ecb0a0 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -64,328 +64,6 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	ath9k_hw_rxena(ah);
 }
 
-/* Process received BAR frame */
-
-static int ath_bar_rx(struct ath_softc *sc,
-		      struct ath_node *an,
-		      struct sk_buff *skb)
-{
-	struct ieee80211_bar *bar;
-	struct ath_arx_tid *rxtid;
-	struct sk_buff *tskb;
-	struct ath_recv_status *rx_status;
-	int tidno, index, cindex;
-	u16 seqno;
-
-	/* look at BAR contents	 */
-
-	bar = (struct ieee80211_bar *)skb->data;
-	tidno = (le16_to_cpu(bar->control) & IEEE80211_BAR_CTL_TID_M)
-		>> IEEE80211_BAR_CTL_TID_S;
-	seqno = le16_to_cpu(bar->start_seq_num) >> IEEE80211_SEQ_SEQ_SHIFT;
-
-	/* process BAR - indicate all pending RX frames till the BAR seqno */
-
-	rxtid = &an->an_aggr.rx.tid[tidno];
-
-	spin_lock_bh(&rxtid->tidlock);
-
-	/* get relative index */
-
-	index = ATH_BA_INDEX(rxtid->seq_next, seqno);
-
-	/* drop BAR if old sequence (index is too large) */
-
-	if ((index > rxtid->baw_size) &&
-	    (index > (IEEE80211_SEQ_MAX - (rxtid->baw_size << 2))))
-		/* discard frame, ieee layer may not treat frame as a dup */
-		goto unlock_and_free;
-
-	/* complete receive processing for all pending frames upto BAR seqno */
-
-	cindex = (rxtid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
-	while ((rxtid->baw_head != rxtid->baw_tail) &&
-	       (rxtid->baw_head != cindex)) {
-		tskb = rxtid->rxbuf[rxtid->baw_head].rx_wbuf;
-		rx_status = &rxtid->rxbuf[rxtid->baw_head].rx_status;
-		rxtid->rxbuf[rxtid->baw_head].rx_wbuf = NULL;
-
-		if (tskb != NULL)
-			ath_rx_subframe(an, tskb, rx_status);
-
-		INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-		INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-	}
-
-	/* ... and indicate rest of the frames in-order */
-
-	while (rxtid->baw_head != rxtid->baw_tail &&
-	       rxtid->rxbuf[rxtid->baw_head].rx_wbuf != NULL) {
-		tskb = rxtid->rxbuf[rxtid->baw_head].rx_wbuf;
-		rx_status = &rxtid->rxbuf[rxtid->baw_head].rx_status;
-		rxtid->rxbuf[rxtid->baw_head].rx_wbuf = NULL;
-
-		ath_rx_subframe(an, tskb, rx_status);
-
-		INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-		INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-	}
-
-unlock_and_free:
-	spin_unlock_bh(&rxtid->tidlock);
-	/* free bar itself */
-	dev_kfree_skb(skb);
-	return IEEE80211_FTYPE_CTL;
-}
-
-/* Function to handle a subframe of aggregation when HT is enabled */
-
-static int ath_ampdu_input(struct ath_softc *sc,
-			   struct ath_node *an,
-			   struct sk_buff *skb,
-			   struct ath_recv_status *rx_status)
-{
-	struct ieee80211_hdr *hdr;
-	struct ath_arx_tid *rxtid;
-	struct ath_rxbuf *rxbuf;
-	u8 type, subtype;
-	u16 rxseq;
-	int tid = 0, index, cindex, rxdiff;
-	__le16 fc;
-	u8 *qc;
-
-	hdr = (struct ieee80211_hdr *)skb->data;
-	fc = hdr->frame_control;
-
-	/* collect stats of frames with non-zero version */
-
-	if ((le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_VERS) != 0) {
-		dev_kfree_skb(skb);
-		return -1;
-	}
-
-	type = le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_FTYPE;
-	subtype = le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_STYPE;
-
-	if (ieee80211_is_back_req(fc))
-		return ath_bar_rx(sc, an, skb);
-
-	/* special aggregate processing only for qos unicast data frames */
-
-	if (!ieee80211_is_data(fc) ||
-	    !ieee80211_is_data_qos(fc) ||
-	    is_multicast_ether_addr(hdr->addr1))
-		return ath_rx_subframe(an, skb, rx_status);
-
-	/* lookup rx tid state */
-
-	if (ieee80211_is_data_qos(fc)) {
-		qc = ieee80211_get_qos_ctl(hdr);
-		tid = qc[0] & 0xf;
-	}
-
-	if (sc->sc_ah->ah_opmode == ATH9K_M_STA) {
-		/* Drop the frame not belonging to me. */
-		if (memcmp(hdr->addr1, sc->sc_myaddr, ETH_ALEN)) {
-			dev_kfree_skb(skb);
-			return -1;
-		}
-	}
-
-	rxtid = &an->an_aggr.rx.tid[tid];
-
-	spin_lock(&rxtid->tidlock);
-
-	rxdiff = (rxtid->baw_tail - rxtid->baw_head) &
-		(ATH_TID_MAX_BUFS - 1);
-
-	/*
-	 * If the ADDBA exchange has not been completed by the source,
-	 * process via legacy path (i.e. no reordering buffer is needed)
-	 */
-	if (!rxtid->addba_exchangecomplete) {
-		spin_unlock(&rxtid->tidlock);
-		return ath_rx_subframe(an, skb, rx_status);
-	}
-
-	/* extract sequence number from recvd frame */
-
-	rxseq = le16_to_cpu(hdr->seq_ctrl) >> IEEE80211_SEQ_SEQ_SHIFT;
-
-	if (rxtid->seq_reset) {
-		rxtid->seq_reset = 0;
-		rxtid->seq_next = rxseq;
-	}
-
-	index = ATH_BA_INDEX(rxtid->seq_next, rxseq);
-
-	/* drop frame if old sequence (index is too large) */
-
-	if (index > (IEEE80211_SEQ_MAX - (rxtid->baw_size << 2))) {
-		/* discard frame, ieee layer may not treat frame as a dup */
-		spin_unlock(&rxtid->tidlock);
-		dev_kfree_skb(skb);
-		return IEEE80211_FTYPE_DATA;
-	}
-
-	/* sequence number is beyond block-ack window */
-
-	if (index >= rxtid->baw_size) {
-
-		/* complete receive processing for all pending frames */
-
-		while (index >= rxtid->baw_size) {
-
-			rxbuf = rxtid->rxbuf + rxtid->baw_head;
-
-			if (rxbuf->rx_wbuf != NULL) {
-				ath_rx_subframe(an, rxbuf->rx_wbuf,
-						&rxbuf->rx_status);
-				rxbuf->rx_wbuf = NULL;
-			}
-
-			INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-			INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-
-			index--;
-		}
-	}
-
-	/* add buffer to the recv ba window */
-
-	cindex = (rxtid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);
-	rxbuf = rxtid->rxbuf + cindex;
-
-	if (rxbuf->rx_wbuf != NULL) {
-		spin_unlock(&rxtid->tidlock);
-		/* duplicate frame */
-		dev_kfree_skb(skb);
-		return IEEE80211_FTYPE_DATA;
-	}
-
-	rxbuf->rx_wbuf = skb;
-	rxbuf->rx_time = get_timestamp();
-	rxbuf->rx_status = *rx_status;
-
-	/* advance tail if sequence received is newer
-	 * than any received so far */
-
-	if (index >= rxdiff) {
-		rxtid->baw_tail = cindex;
-		INCR(rxtid->baw_tail, ATH_TID_MAX_BUFS);
-	}
-
-	/* indicate all in-order received frames */
-
-	while (rxtid->baw_head != rxtid->baw_tail) {
-		rxbuf = rxtid->rxbuf + rxtid->baw_head;
-		if (!rxbuf->rx_wbuf)
-			break;
-
-		ath_rx_subframe(an, rxbuf->rx_wbuf, &rxbuf->rx_status);
-		rxbuf->rx_wbuf = NULL;
-
-		INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-		INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-	}
-
-	/*
-	 * start a timer to flush all received frames if there are pending
-	 * receive frames
-	 */
-	if (rxtid->baw_head != rxtid->baw_tail)
-		mod_timer(&rxtid->timer, ATH_RX_TIMEOUT);
-	else
-		del_timer_sync(&rxtid->timer);
-
-	spin_unlock(&rxtid->tidlock);
-	return IEEE80211_FTYPE_DATA;
-}
-
-/* Timer to flush all received sub-frames */
-
-static void ath_rx_timer(unsigned long data)
-{
-	struct ath_arx_tid *rxtid = (struct ath_arx_tid *)data;
-	struct ath_node *an = rxtid->an;
-	struct ath_rxbuf *rxbuf;
-	int nosched;
-
-	spin_lock_bh(&rxtid->tidlock);
-	while (rxtid->baw_head != rxtid->baw_tail) {
-		rxbuf = rxtid->rxbuf + rxtid->baw_head;
-		if (!rxbuf->rx_wbuf) {
-			INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-			INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-			continue;
-		}
-
-		/*
-		 * Stop if the next one is a very recent frame.
-		 *
-		 * Call get_timestamp in every iteration to protect against the
-		 * case in which a new frame is received while we are executing
-		 * this function. Using a timestamp obtained before entering
-		 * the loop could lead to a very large time interval
-		 * (a negative value typecast to unsigned), breaking the
-		 * function's logic.
-		 */
-		if ((get_timestamp() - rxbuf->rx_time) <
-			(ATH_RX_TIMEOUT * HZ / 1000))
-			break;
-
-		ath_rx_subframe(an, rxbuf->rx_wbuf,
-				&rxbuf->rx_status);
-		rxbuf->rx_wbuf = NULL;
-
-		INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-		INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-	}
-
-	/*
-	 * start a timer to flush all received frames if there are pending
-	 * receive frames
-	 */
-	if (rxtid->baw_head != rxtid->baw_tail)
-		nosched = 0;
-	else
-		nosched = 1; /* no need to re-arm the timer again */
-
-	spin_unlock_bh(&rxtid->tidlock);
-}
-
-/* Free all pending sub-frames in the re-ordering buffer */
-
-static void ath_rx_flush_tid(struct ath_softc *sc, struct ath_arx_tid *rxtid,
-			     int drop)
-{
-	struct ath_rxbuf *rxbuf;
-	unsigned long flag;
-
-	spin_lock_irqsave(&rxtid->tidlock, flag);
-	while (rxtid->baw_head != rxtid->baw_tail) {
-		rxbuf = rxtid->rxbuf + rxtid->baw_head;
-		if (!rxbuf->rx_wbuf) {
-			INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-			INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-			continue;
-		}
-
-		if (drop)
-			dev_kfree_skb(rxbuf->rx_wbuf);
-		else
-			ath_rx_subframe(rxtid->an,
-					rxbuf->rx_wbuf,
-					&rxbuf->rx_status);
-
-		rxbuf->rx_wbuf = NULL;
-
-		INCR(rxtid->baw_head, ATH_TID_MAX_BUFS);
-		INCR(rxtid->seq_next, IEEE80211_SEQ_MAX);
-	}
-	spin_unlock_irqrestore(&rxtid->tidlock, flag);
-}
-
 static struct sk_buff *ath_rxbuf_alloc(struct ath_softc *sc,
 	u32 len)
 {
@@ -716,23 +394,6 @@ void ath_flushrecv(struct ath_softc *sc)
 	spin_unlock_bh(&sc->sc_rxflushlock);
 }
 
-/* Process an individual frame */
-
-int ath_rx_input(struct ath_softc *sc,
-		 struct ath_node *an,
-		 struct sk_buff *skb,
-		 struct ath_recv_status *rx_status,
-		 enum ATH_RX_TYPE *status)
-{
-	if (sc->sc_flags & SC_OP_RXAGGR) {
-		*status = ATH_RX_CONSUMED;
-		return ath_ampdu_input(sc, an, skb, rx_status);
-	} else {
-		*status = ATH_RX_NON_CONSUMED;
-		return -1;
-	}
-}
-
 /* Process receive queue, as well as LED, etc. */
 
 int ath_rx_tasklet(struct ath_softc *sc, int flush)
@@ -1091,165 +752,3 @@ rx_next:
 	return 0;
 #undef PA2DESC
 }
-
-/* Process ADDBA request in per-TID data structure */
-
-int ath_rx_aggr_start(struct ath_softc *sc,
-		      struct ieee80211_sta *sta,
-		      u16 tid,
-		      u16 *ssn)
-{
-	struct ath_arx_tid *rxtid;
-	struct ath_node *an;
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_supported_band *sband;
-	u16 buffersize = 0;
-
-	an = (struct ath_node *)sta->drv_priv;
-	sband = hw->wiphy->bands[hw->conf.channel->band];
-	buffersize = IEEE80211_MIN_AMPDU_BUF <<
-		sband->ht_cap.ampdu_factor; /* FIXME */
-
-	rxtid = &an->an_aggr.rx.tid[tid];
-
-	spin_lock_bh(&rxtid->tidlock);
-	if (sc->sc_flags & SC_OP_RXAGGR) {
-		/* Allow aggregation reception
-		 * Adjust rx BA window size. Peer might indicate a
-		 * zero buffer size for a _dont_care_ condition.
-		 */
-		if (buffersize)
-			rxtid->baw_size = min(buffersize, rxtid->baw_size);
-
-		/* set rx sequence number */
-		rxtid->seq_next = *ssn;
-
-		/* Allocate the receive buffers for this TID */
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: Allcating rxbuffer for TID %d\n", __func__, tid);
-
-		if (rxtid->rxbuf == NULL) {
-			/*
-			* If the rxbuff is not NULL at this point, we *probably*
-			* already allocated the buffer on a previous ADDBA,
-			* and this is a subsequent ADDBA that got through.
-			* Don't allocate, but use the value in the pointer,
-			* we zero it out when we de-allocate.
-			*/
-			rxtid->rxbuf = kmalloc(ATH_TID_MAX_BUFS *
-				sizeof(struct ath_rxbuf), GFP_ATOMIC);
-		}
-		if (rxtid->rxbuf == NULL) {
-			DPRINTF(sc, ATH_DBG_AGGR,
-				"%s: Unable to allocate RX buffer, "
-				"refusing ADDBA\n", __func__);
-		} else {
-			/* Ensure the memory is zeroed out (all internal
-			 * pointers are null) */
-			memset(rxtid->rxbuf, 0, ATH_TID_MAX_BUFS *
-				sizeof(struct ath_rxbuf));
-			DPRINTF(sc, ATH_DBG_AGGR,
-				"%s: Allocated @%p\n", __func__, rxtid->rxbuf);
-
-			/* Allow aggregation reception */
-			rxtid->addba_exchangecomplete = 1;
-		}
-	}
-	spin_unlock_bh(&rxtid->tidlock);
-
-	return 0;
-}
-
-/* Process DELBA */
-
-int ath_rx_aggr_stop(struct ath_softc *sc, struct ieee80211_sta *sta, u16 tid)
-{
-	struct ath_node *an = (struct ath_node *)sta->drv_priv;
-
-	ath_rx_aggr_teardown(sc, an, tid);
-	return 0;
-}
-
-/* Rx aggregation tear down */
-
-void ath_rx_aggr_teardown(struct ath_softc *sc, struct ath_node *an, u8 tid)
-{
-	struct ath_arx_tid *rxtid = &an->an_aggr.rx.tid[tid];
-
-	if (!rxtid->addba_exchangecomplete)
-		return;
-
-	del_timer_sync(&rxtid->timer);
-	ath_rx_flush_tid(sc, rxtid, 0);
-	rxtid->addba_exchangecomplete = 0;
-
-	/* De-allocate the receive buffer array allocated when addba started */
-
-	if (rxtid->rxbuf) {
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: Deallocating TID %d rxbuff @%p\n",
-			__func__, tid, rxtid->rxbuf);
-		kfree(rxtid->rxbuf);
-
-		/* Set pointer to null to avoid reuse*/
-		rxtid->rxbuf = NULL;
-	}
-}
-
-/* Initialize per-node receive state */
-
-void ath_rx_node_init(struct ath_softc *sc, struct ath_node *an)
-{
-	struct ath_arx_tid *rxtid;
-	int tidno;
-
-	/* Init per tid rx state */
-	for (tidno = 0, rxtid = &an->an_aggr.rx.tid[tidno];
-	     tidno < WME_NUM_TID;
-	     tidno++, rxtid++) {
-		rxtid->an        = an;
-		rxtid->seq_reset = 1;
-		rxtid->seq_next  = 0;
-		rxtid->baw_size  = WME_MAX_BA;
-		rxtid->baw_head  = rxtid->baw_tail = 0;
-
-		/*
-		 * Ensure the buffer pointer is null at this point
-		 * (needs to be allocated when addba is received)
-		 */
-
-		rxtid->rxbuf = NULL;
-		setup_timer(&rxtid->timer, ath_rx_timer,
-			    (unsigned long)rxtid);
-		spin_lock_init(&rxtid->tidlock);
-
-		/* ADDBA state */
-		rxtid->addba_exchangecomplete = 0;
-	}
-}
-
-void ath_rx_node_cleanup(struct ath_softc *sc, struct ath_node *an)
-{
-	struct ath_arx_tid *rxtid;
-	int tidno, i;
-
-	/* Init per tid rx state */
-	for (tidno = 0, rxtid = &an->an_aggr.rx.tid[tidno];
-	     tidno < WME_NUM_TID;
-	     tidno++, rxtid++) {
-
-		if (!rxtid->addba_exchangecomplete)
-			continue;
-
-		/* must cancel timer first */
-		del_timer_sync(&rxtid->timer);
-
-		/* drop any pending sub-frames */
-		ath_rx_flush_tid(sc, rxtid, 1);
-
-		for (i = 0; i < ATH_TID_MAX_BUFS; i++)
-			ASSERT(rxtid->rxbuf[i].rx_wbuf == NULL);
-
-		rxtid->addba_exchangecomplete = 0;
-	}
-}
-- 
1.6.0.3

