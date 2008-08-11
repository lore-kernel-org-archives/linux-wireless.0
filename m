Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:52122 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbYHKIpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 04:45:05 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 11 Aug 2008 01:45:05 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18591.63838.639171.406441@localhost.localdomain> (sfid-20080811_104510_185921_723044A6)
Date: Mon, 11 Aug 2008 14:03:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 03/10] ath9k: Use bitfields for buffer type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   70 ++++++++++++----------------
 drivers/net/wireless/ath9k/xmit.c |   92 +++++++++++++++++++++----------------
 2 files changed, 83 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 07c9588..9e16c6c 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -177,11 +177,6 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht);
 /* Descriptor Management */
 /*************************/
 
-/* Number of descriptors per buffer. The only case where we see skbuff
-chains is due to FF aggregation in the driver. */
-#define	ATH_TXDESC	    1
-/* if there's more fragment for this MSDU */
-#define ATH_BF_MORE_MPDU    1
 #define ATH_TXBUF_RESET(_bf) do {				\
 		(_bf)->bf_status = 0;				\
 		(_bf)->bf_lastbf = NULL;			\
@@ -191,28 +186,29 @@ chains is due to FF aggregation in the driver. */
 			    sizeof(struct ath_buf_state));	\
 	} while (0)
 
+enum buffer_type {
+	BUF_DATA		= BIT(0),
+	BUF_AGGR		= BIT(1),
+	BUF_AMPDU		= BIT(2),
+	BUF_HT			= BIT(3),
+	BUF_RETRY		= BIT(4),
+	BUF_XRETRY		= BIT(5),
+	BUF_SHORT_PREAMBLE	= BIT(6),
+	BUF_BAR			= BIT(7),
+	BUF_PSPOLL		= BIT(8),
+	BUF_AGGR_BURST		= BIT(9),
+	BUF_CALC_AIRTIME	= BIT(10),
+};
+
 struct ath_buf_state {
-	int bfs_nframes;	/* # frames in aggregate */
-	u16 bfs_al;		/* length of aggregate */
-	u16 bfs_frmlen;		/* length of frame */
-	int bfs_seqno;		/* sequence number */
-	int bfs_tidno;		/* tid of this frame */
-	int bfs_retries;	/* current retries */
+	int bfs_nframes;			/* # frames in aggregate */
+	u16 bfs_al;				/* length of aggregate */
+	u16 bfs_frmlen;				/* length of frame */
+	int bfs_seqno;				/* sequence number */
+	int bfs_tidno;				/* tid of this frame */
+	int bfs_retries;			/* current retries */
 	struct ath_rc_series bfs_rcs[4];	/* rate series */
-	u8 bfs_isdata:1;	/* is a data frame/aggregate */
-	u8 bfs_isaggr:1;	/* is an aggregate */
-	u8 bfs_isampdu:1;	/* is an a-mpdu, aggregate or not */
-	u8 bfs_ht:1;		/* is an HT frame */
-	u8 bfs_isretried:1;	/* is retried */
-	u8 bfs_isxretried:1;	/* is excessive retried */
-	u8 bfs_shpreamble:1;	/* is short preamble */
-	u8 bfs_isbar:1;		/* is a BAR */
-	u8 bfs_ispspoll:1;	/* is a PS-Poll */
-	u8 bfs_aggrburst:1;	/* is a aggr burst */
-	u8 bfs_calcairtime:1;	/* requests airtime be calculated
-				when set for tx frame */
-	int bfs_rifsburst_elem;	/* RIFS burst/bar */
-	int bfs_nrifsubframes;	/* # of elements in burst */
+	u32 bf_type;				/* BUF_* (enum buffer_type) */
 	/* key type use to encrypt this frame */
 	enum ath9k_key_type bfs_keytype;
 };
@@ -224,26 +220,22 @@ struct ath_buf_state {
 #define bf_seqno        	bf_state.bfs_seqno
 #define bf_tidno        	bf_state.bfs_tidno
 #define bf_rcs          	bf_state.bfs_rcs
-#define bf_isdata       	bf_state.bfs_isdata
-#define bf_isaggr       	bf_state.bfs_isaggr
-#define bf_isampdu      	bf_state.bfs_isampdu
-#define bf_ht           	bf_state.bfs_ht
-#define bf_isretried    	bf_state.bfs_isretried
-#define bf_isxretried   	bf_state.bfs_isxretried
-#define bf_shpreamble   	bf_state.bfs_shpreamble
-#define bf_rifsburst_elem  	bf_state.bfs_rifsburst_elem
-#define bf_nrifsubframes  	bf_state.bfs_nrifsubframes
 #define bf_keytype      	bf_state.bfs_keytype
-#define bf_isbar        	bf_state.bfs_isbar
-#define bf_ispspoll     	bf_state.bfs_ispspoll
-#define bf_aggrburst    	bf_state.bfs_aggrburst
-#define bf_calcairtime  	bf_state.bfs_calcairtime
+#define bf_isdata(bf)		(bf->bf_state.bf_type & BUF_DATA)
+#define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
+#define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
+#define bf_isht(bf)		(bf->bf_state.bf_type & BUF_HT)
+#define bf_isretried(bf)	(bf->bf_state.bf_type & BUF_RETRY)
+#define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
+#define bf_isshpreamble(bf)	(bf->bf_state.bf_type & BUF_SHORT_PREAMBLE)
+#define bf_isbar(bf)		(bf->bf_state.bf_type & BUF_BAR)
+#define bf_ispspoll(bf) 	(bf->bf_state.bf_type & BUF_PSPOLL)
+#define bf_isaggrburst(bf)	(bf->bf_state.bf_type & BUF_AGGR_BURST)
 
 /*
  * Abstraction of a contiguous buffer to transmit/receive.  There is only
  * a single hw descriptor encapsulated here.
  */
-
 struct ath_buf {
 	struct list_head list;
 	struct list_head *last;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 93064cc..47cf9f3 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -518,7 +518,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc,
 	if (!txok) {
 		tx_status.flags |= ATH_TX_ERROR;
 
-		if (bf->bf_isxretried)
+		if (bf_isxretried(bf))
 			tx_status.flags |= ATH_TX_XRETRY;
 	}
 	/* Unmap this frame */
@@ -629,7 +629,7 @@ static int ath_tx_num_badfrms(struct ath_softc *sc,
 	if (isnodegone || ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
 		return 0;
 
-	isaggr = bf->bf_isaggr;
+	isaggr = bf_isaggr(bf);
 	if (isaggr) {
 		seq_st = ATH_DS_BA_SEQ(ds);
 		memcpy(ba, ATH_DS_BA_BITMAP(ds), WME_BA_BMP_SIZE >> 3);
@@ -651,7 +651,7 @@ static void ath_tx_set_retry(struct ath_softc *sc, struct ath_buf *bf)
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
 
-	bf->bf_isretried = 1;
+	bf->bf_state.bf_type |= BUF_RETRY;
 	bf->bf_retries++;
 
 	skb = bf->bf_mpdu;
@@ -698,7 +698,7 @@ static u32 ath_pkt_duration(struct ath_softc *sc,
 	u8 rc;
 	int streams, pktlen;
 
-	pktlen = bf->bf_isaggr ? bf->bf_al : bf->bf_frmlen;
+	pktlen = bf_isaggr(bf) ? bf->bf_al : bf->bf_frmlen;
 	rc = rt->info[rix].rateCode;
 
 	/*
@@ -781,7 +781,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * let rate series flags determine which rates will actually
 	 * use RTS.
 	 */
-	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf->bf_isdata) {
+	if ((ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT) && bf_isdata(bf)) {
 		BUG_ON(!an);
 		/*
 		 * 802.11g protection not needed, use our default behavior
@@ -793,7 +793,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 * and the second aggregate should have any protection at all.
 		 */
 		if (an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) {
-			if (!bf->bf_aggrburst) {
+			if (!bf_isaggrburst(bf)) {
 				flags = ATH9K_TXDESC_RTSENA;
 				dynamic_mimops = 1;
 			} else {
@@ -806,7 +806,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * Set protection if aggregate protection on
 	 */
 	if (sc->sc_config.ath_aggr_prot &&
-	    (!bf->bf_isaggr || (bf->bf_isaggr && bf->bf_al < 8192))) {
+	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
 		flags = ATH9K_TXDESC_RTSENA;
 		cix = rt->info[sc->sc_protrix].controlRate;
 		rtsctsena = 1;
@@ -815,7 +815,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	/*
 	 *  For AR5416 - RTS cannot be followed by a frame larger than 8K.
 	 */
-	if (bf->bf_isaggr && (bf->bf_al > aggr_limit_with_rts)) {
+	if (bf_isaggr(bf) && (bf->bf_al > aggr_limit_with_rts)) {
 		/*
 		 * Ensure that in the case of SM Dynamic power save
 		 * while we are bursting the second aggregate the
@@ -832,7 +832,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	/* NB: cix is set above where RTS/CTS is enabled */
 	BUG_ON(cix == 0xff);
 	ctsrate = rt->info[cix].rateCode |
-		(bf->bf_shpreamble ? rt->info[cix].shortPreamble : 0);
+		(bf_isshpreamble(bf) ? rt->info[cix].shortPreamble : 0);
 
 	/*
 	 * Setup HAL rate series
@@ -846,7 +846,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		rix = bf->bf_rcs[i].rix;
 
 		series[i].Rate = rt->info[rix].rateCode |
-			(bf->bf_shpreamble ? rt->info[rix].shortPreamble : 0);
+			(bf_isshpreamble(bf) ? rt->info[rix].shortPreamble : 0);
 
 		series[i].Tries = bf->bf_rcs[i].tries;
 
@@ -862,7 +862,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			sc, rix, bf,
 			(bf->bf_rcs[i].flags & ATH_RC_CW40_FLAG) != 0,
 			(bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
-			bf->bf_shpreamble);
+			bf_isshpreamble(bf));
 
 		if ((an->an_smmode == ATH_SM_PWRSAV_STATIC) &&
 		    (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG) == 0) {
@@ -875,7 +875,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			 */
 			series[i].ChSel = sc->sc_tx_chainmask;
 		} else {
-			if (bf->bf_ht)
+			if (bf_isht(bf))
 				series[i].ChSel =
 					ath_chainmask_sel_logic(sc, an);
 			else
@@ -908,7 +908,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 *     use the precalculated ACK durations.
 		 */
 		if (flags & ATH9K_TXDESC_RTSENA) {    /* SIFS + CTS */
-			ctsduration += bf->bf_shpreamble ?
+			ctsduration += bf_isshpreamble(bf) ?
 				rt->info[cix].spAckDuration :
 				rt->info[cix].lpAckDuration;
 		}
@@ -916,7 +916,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		ctsduration += series[0].PktDuration;
 
 		if ((bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) { /* SIFS + ACK */
-			ctsduration += bf->bf_shpreamble ?
+			ctsduration += bf_isshpreamble(bf) ?
 				rt->info[rix].spAckDuration :
 				rt->info[rix].lpAckDuration;
 		}
@@ -932,10 +932,10 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * set dur_update_en for l-sig computation except for PS-Poll frames
 	 */
 	ath9k_hw_set11n_ratescenario(ah, ds, lastds,
-				    !bf->bf_ispspoll,
-				    ctsrate,
-				    ctsduration,
-				    series, 4, flags);
+				     !bf_ispspoll(bf),
+				     ctsrate,
+				     ctsduration,
+				     series, 4, flags);
 	if (sc->sc_config.ath_aggr_prot && flags)
 		ath9k_hw_set11n_burstduration(ah, ds, 8192);
 }
@@ -958,7 +958,7 @@ static int ath_tx_send_normal(struct ath_softc *sc,
 	BUG_ON(list_empty(bf_head));
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
-	bf->bf_isampdu = 0; /* regular HT frame */
+	bf->bf_state.bf_type &= ~BUF_AMPDU; /* regular HT frame */
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
@@ -998,7 +998,7 @@ static void ath_tx_flush_tid(struct ath_softc *sc, struct ath_atx_tid *tid)
 
 	while (!list_empty(&tid->buf_q)) {
 		bf = list_first_entry(&tid->buf_q, struct ath_buf, list);
-		ASSERT(!bf->bf_isretried);
+		ASSERT(!bf_isretried(bf));
 		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
 		ath_tx_send_normal(sc, txq, tid, &bf_head);
 	}
@@ -1025,7 +1025,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	int isaggr, txfail, txpending, sendbar = 0, needreset = 0;
 	int isnodegone = (an->an_flags & ATH_NODE_CLEAN);
 
-	isaggr = bf->bf_isaggr;
+	isaggr = bf_isaggr(bf);
 	if (isaggr) {
 		if (txok) {
 			if (ATH_DS_TX_BA(ds)) {
@@ -1075,7 +1075,7 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 					ath_tx_set_retry(sc, bf);
 					txpending = 1;
 				} else {
-					bf->bf_isxretried = 1;
+					bf->bf_state.bf_type |= BUF_XRETRY;
 					txfail = 1;
 					sendbar = 1;
 				}
@@ -1331,7 +1331,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 
 		txq->axq_depth--;
 
-		if (bf->bf_isaggr)
+		if (bf_isaggr(bf))
 			txq->axq_aggr_depth--;
 
 		txok = (ds->ds_txstat.ts_status == 0);
@@ -1345,14 +1345,14 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			spin_unlock_bh(&sc->sc_txbuflock);
 		}
 
-		if (!bf->bf_isampdu) {
+		if (!bf_isampdu(bf)) {
 			/*
 			 * This frame is sent out as a single frame.
 			 * Use hardware retry status for this frame.
 			 */
 			bf->bf_retries = ds->ds_txstat.ts_longretry;
 			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
-				bf->bf_isxretried = 1;
+				bf->bf_state.bf_type |= BUF_XRETRY;
 			nbad = 0;
 		} else {
 			nbad = ath_tx_num_badfrms(sc, bf, txok);
@@ -1368,7 +1368,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			if (ds->ds_txstat.ts_status == 0)
 				nacked++;
 
-			if (bf->bf_isdata) {
+			if (bf_isdata(bf)) {
 				if (isrifs)
 					tmp_ds = bf->bf_rifslast->bf_desc;
 				else
@@ -1384,7 +1384,7 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		/*
 		 * Complete this transmit unit
 		 */
-		if (bf->bf_isampdu)
+		if (bf_isampdu(bf))
 			ath_tx_complete_aggr_rifs(sc, txq, bf, &bf_head, txok);
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, txok, 0);
@@ -1481,7 +1481,7 @@ static void ath_tx_addto_baw(struct ath_softc *sc,
 {
 	int index, cindex;
 
-	if (bf->bf_isretried)
+	if (bf_isretried(bf))
 		return;
 
 	index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
@@ -1516,7 +1516,7 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 	BUG_ON(list_empty(bf_head));
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
-	bf->bf_isampdu = 1;
+	bf->bf_state.bf_type |= BUF_AMPDU;
 	bf->bf_seqno = txctl->seqno; /* save seqno and tidno in buffer */
 	bf->bf_tidno = txctl->tidno;
 
@@ -1860,7 +1860,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc,
 		if (bf->bf_nframes == 1) {
 			ASSERT(bf->bf_lastfrm == bf_last);
 
-			bf->bf_isaggr = 0;
+			bf->bf_state.bf_type &= ~BUF_AGGR;
 			/*
 			 * clear aggr bits for every descriptor
 			 * XXX TODO: is there a way to optimize it?
@@ -1877,7 +1877,7 @@ static void ath_tx_sched_aggr(struct ath_softc *sc,
 		/*
 		 * setup first desc with rate and aggr info
 		 */
-		bf->bf_isaggr  = 1;
+		bf->bf_state.bf_type |= BUF_AGGR;
 		ath_buf_set_rate(sc, bf);
 		ath9k_hw_set11n_aggr_first(sc->sc_ah, bf->bf_desc, bf->bf_al);
 
@@ -1925,7 +1925,7 @@ static void ath_tid_drain(struct ath_softc *sc,
 		list_cut_position(&bf_head, &tid->buf_q, &bf->bf_lastfrm->list);
 
 		/* update baw for software retried frame */
-		if (bf->bf_isretried)
+		if (bf_isretried(bf))
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 
 		/*
@@ -2014,11 +2014,21 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 	/* set up this buffer */
 	ATH_TXBUF_RESET(bf);
 	bf->bf_frmlen = txctl->frmlen;
-	bf->bf_isdata = ieee80211_is_data(fc);
-	bf->bf_isbar = ieee80211_is_back_req(fc);
-	bf->bf_ispspoll = ieee80211_is_pspoll(fc);
+
+	ieee80211_is_data(fc) ?
+		(bf->bf_state.bf_type |= BUF_DATA) :
+		(bf->bf_state.bf_type &= ~BUF_DATA);
+	ieee80211_is_back_req(fc) ?
+		(bf->bf_state.bf_type |= BUF_BAR) :
+		(bf->bf_state.bf_type &= ~BUF_BAR);
+	ieee80211_is_pspoll(fc) ?
+		(bf->bf_state.bf_type |= BUF_PSPOLL) :
+		(bf->bf_state.bf_type &= ~BUF_PSPOLL);
+	(sc->sc_flags & ATH_PREAMBLE_SHORT) ?
+		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
+		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
+
 	bf->bf_flags = txctl->flags;
-	bf->bf_shpreamble = sc->sc_flags & ATH_PREAMBLE_SHORT;
 	bf->bf_keytype = txctl->keytype;
 	tx_info_priv = (struct ath_tx_info_priv *)tx_info->driver_data[0];
 	rcs = tx_info_priv->rcs;
@@ -2060,7 +2070,9 @@ static int ath_tx_start_dma(struct ath_softc *sc,
 			    ds);                /* first descriptor */
 
 	bf->bf_lastfrm = bf;
-	bf->bf_ht = txctl->ht;
+	(txctl->ht) ?
+		(bf->bf_state.bf_type |= BUF_HT) :
+		(bf->bf_state.bf_type &= ~BUF_HT);
 
 	spin_lock_bh(&txq->axq_lock);
 
@@ -2162,7 +2174,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 
 		/* Setup tx descriptors */
 		error = ath_descdma_setup(sc, &sc->sc_txdma, &sc->sc_txbuf,
-			"tx", nbufs * ATH_FRAG_PER_MSDU, ATH_TXDESC);
+			"tx", nbufs * ATH_FRAG_PER_MSDU, 1);
 		if (error != 0) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"%s: failed to allocate tx descriptors: %d\n",
@@ -2486,7 +2498,7 @@ void ath_tx_draintxq(struct ath_softc *sc,
 
 		spin_unlock_bh(&txq->axq_lock);
 
-		if (bf->bf_isampdu)
+		if (bf_isampdu(bf))
 			ath_tx_complete_aggr_rifs(sc, txq, bf, &bf_head, 0);
 		else
 			ath_tx_complete_buf(sc, bf, &bf_head, 0, 0);
@@ -2647,7 +2659,7 @@ void ath_tx_aggr_teardown(struct ath_softc *sc,
 	spin_lock_bh(&txq->axq_lock);
 	while (!list_empty(&txtid->buf_q)) {
 		bf = list_first_entry(&txtid->buf_q, struct ath_buf, list);
-		if (!bf->bf_isretried) {
+		if (!bf_isretried(bf)) {
 			/*
 			 * NB: it's based on the assumption that
 			 * software retried frame will always stay
-- 
1.5.6.5

