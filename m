Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:60906 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0C3DHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 23:07:20 -0400
Message-ID: <4BB16ADF.8090609@openwrt.org>
Date: Mon, 29 Mar 2010 20:07:11 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath9k: split out access to tx status information
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch passes in a pointer to the ath_tx_status data structure for
functions that need it, instead of letting them grab it directly from
the ath_desc struct. This is useful for making it possible to allocate
the intermediate tx status data separately.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -246,79 +246,80 @@ void ath9k_hw_cleartxdesc(struct ath_hw 
 }
 EXPORT_SYMBOL(ath9k_hw_cleartxdesc);
 
-int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds)
+int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds,
+			struct ath_tx_status *ts)
 {
 	struct ar5416_desc *ads = AR5416DESC(ds);
 
 	if ((ads->ds_txstatus9 & AR_TxDone) == 0)
 		return -EINPROGRESS;
 
-	ds->ds_txstat.ts_seqnum = MS(ads->ds_txstatus9, AR_SeqNum);
-	ds->ds_txstat.ts_tstamp = ads->AR_SendTimestamp;
-	ds->ds_txstat.ts_status = 0;
-	ds->ds_txstat.ts_flags = 0;
+	ts->ts_seqnum = MS(ads->ds_txstatus9, AR_SeqNum);
+	ts->ts_tstamp = ads->AR_SendTimestamp;
+	ts->ts_status = 0;
+	ts->ts_flags = 0;
 
 	if (ads->ds_txstatus1 & AR_FrmXmitOK)
-		ds->ds_txstat.ts_status |= ATH9K_TX_ACKED;
+		ts->ts_status |= ATH9K_TX_ACKED;
 	if (ads->ds_txstatus1 & AR_ExcessiveRetries)
-		ds->ds_txstat.ts_status |= ATH9K_TXERR_XRETRY;
+		ts->ts_status |= ATH9K_TXERR_XRETRY;
 	if (ads->ds_txstatus1 & AR_Filtered)
-		ds->ds_txstat.ts_status |= ATH9K_TXERR_FILT;
+		ts->ts_status |= ATH9K_TXERR_FILT;
 	if (ads->ds_txstatus1 & AR_FIFOUnderrun) {
-		ds->ds_txstat.ts_status |= ATH9K_TXERR_FIFO;
+		ts->ts_status |= ATH9K_TXERR_FIFO;
 		ath9k_hw_updatetxtriglevel(ah, true);
 	}
 	if (ads->ds_txstatus9 & AR_TxOpExceeded)
-		ds->ds_txstat.ts_status |= ATH9K_TXERR_XTXOP;
+		ts->ts_status |= ATH9K_TXERR_XTXOP;
 	if (ads->ds_txstatus1 & AR_TxTimerExpired)
-		ds->ds_txstat.ts_status |= ATH9K_TXERR_TIMER_EXPIRED;
+		ts->ts_status |= ATH9K_TXERR_TIMER_EXPIRED;
 
 	if (ads->ds_txstatus1 & AR_DescCfgErr)
-		ds->ds_txstat.ts_flags |= ATH9K_TX_DESC_CFG_ERR;
+		ts->ts_flags |= ATH9K_TX_DESC_CFG_ERR;
 	if (ads->ds_txstatus1 & AR_TxDataUnderrun) {
-		ds->ds_txstat.ts_flags |= ATH9K_TX_DATA_UNDERRUN;
+		ts->ts_flags |= ATH9K_TX_DATA_UNDERRUN;
 		ath9k_hw_updatetxtriglevel(ah, true);
 	}
 	if (ads->ds_txstatus1 & AR_TxDelimUnderrun) {
-		ds->ds_txstat.ts_flags |= ATH9K_TX_DELIM_UNDERRUN;
+		ts->ts_flags |= ATH9K_TX_DELIM_UNDERRUN;
 		ath9k_hw_updatetxtriglevel(ah, true);
 	}
 	if (ads->ds_txstatus0 & AR_TxBaStatus) {
-		ds->ds_txstat.ts_flags |= ATH9K_TX_BA;
-		ds->ds_txstat.ba_low = ads->AR_BaBitmapLow;
-		ds->ds_txstat.ba_high = ads->AR_BaBitmapHigh;
+		ts->ts_flags |= ATH9K_TX_BA;
+		ts->ba_low = ads->AR_BaBitmapLow;
+		ts->ba_high = ads->AR_BaBitmapHigh;
 	}
 
-	ds->ds_txstat.ts_rateindex = MS(ads->ds_txstatus9, AR_FinalTxIdx);
-	switch (ds->ds_txstat.ts_rateindex) {
+	ts->ts_rateindex = MS(ads->ds_txstatus9, AR_FinalTxIdx);
+	switch (ts->ts_rateindex) {
 	case 0:
-		ds->ds_txstat.ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate0);
+		ts->ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate0);
 		break;
 	case 1:
-		ds->ds_txstat.ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate1);
+		ts->ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate1);
 		break;
 	case 2:
-		ds->ds_txstat.ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate2);
+		ts->ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate2);
 		break;
 	case 3:
-		ds->ds_txstat.ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate3);
+		ts->ts_ratecode = MS(ads->ds_ctl3, AR_XmitRate3);
 		break;
 	}
 
-	ds->ds_txstat.ts_rssi = MS(ads->ds_txstatus5, AR_TxRSSICombined);
-	ds->ds_txstat.ts_rssi_ctl0 = MS(ads->ds_txstatus0, AR_TxRSSIAnt00);
-	ds->ds_txstat.ts_rssi_ctl1 = MS(ads->ds_txstatus0, AR_TxRSSIAnt01);
-	ds->ds_txstat.ts_rssi_ctl2 = MS(ads->ds_txstatus0, AR_TxRSSIAnt02);
-	ds->ds_txstat.ts_rssi_ext0 = MS(ads->ds_txstatus5, AR_TxRSSIAnt10);
-	ds->ds_txstat.ts_rssi_ext1 = MS(ads->ds_txstatus5, AR_TxRSSIAnt11);
-	ds->ds_txstat.ts_rssi_ext2 = MS(ads->ds_txstatus5, AR_TxRSSIAnt12);
-	ds->ds_txstat.evm0 = ads->AR_TxEVM0;
-	ds->ds_txstat.evm1 = ads->AR_TxEVM1;
-	ds->ds_txstat.evm2 = ads->AR_TxEVM2;
-	ds->ds_txstat.ts_shortretry = MS(ads->ds_txstatus1, AR_RTSFailCnt);
-	ds->ds_txstat.ts_longretry = MS(ads->ds_txstatus1, AR_DataFailCnt);
-	ds->ds_txstat.ts_virtcol = MS(ads->ds_txstatus1, AR_VirtRetryCnt);
-	ds->ds_txstat.ts_antenna = 0;
+	ts->ts_rssi = MS(ads->ds_txstatus5, AR_TxRSSICombined);
+	ts->ts_rssi_ctl0 = MS(ads->ds_txstatus0, AR_TxRSSIAnt00);
+	ts->ts_rssi_ctl1 = MS(ads->ds_txstatus0, AR_TxRSSIAnt01);
+	ts->ts_rssi_ctl2 = MS(ads->ds_txstatus0, AR_TxRSSIAnt02);
+	ts->ts_rssi_ext0 = MS(ads->ds_txstatus5, AR_TxRSSIAnt10);
+	ts->ts_rssi_ext1 = MS(ads->ds_txstatus5, AR_TxRSSIAnt11);
+	ts->ts_rssi_ext2 = MS(ads->ds_txstatus5, AR_TxRSSIAnt12);
+	ts->evm0 = ads->AR_TxEVM0;
+	ts->evm1 = ads->AR_TxEVM1;
+	ts->evm2 = ads->AR_TxEVM2;
+	ts->ts_shortretry = MS(ads->ds_txstatus1, AR_RTSFailCnt);
+	ts->ts_longretry = MS(ads->ds_txstatus1, AR_DataFailCnt);
+	ts->ts_virtcol = MS(ads->ds_txstatus1, AR_VirtRetryCnt);
+	ts->ts_antenna = 0;
 
 	return 0;
 }
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -241,7 +241,6 @@ struct ath_desc {
 	void *ds_vdata;
 } __packed;
 
-#define	ds_txstat	ds_us.tx
 #define	ds_rxstat	ds_us.rx
 #define ds_stat		ds_us.stats
 
@@ -702,7 +701,8 @@ void ath9k_hw_filltxdesc(struct ath_hw *
 			 u32 segLen, bool firstSeg,
 			 bool lastSeg, const struct ath_desc *ds0);
 void ath9k_hw_cleartxdesc(struct ath_hw *ah, struct ath_desc *ds);
-int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds);
+int ath9k_hw_txprocdesc(struct ath_hw *ah, struct ath_desc *ds,
+			struct ath_tx_status *ts);
 void ath9k_hw_set11n_txdesc(struct ath_hw *ah, struct ath_desc *ds,
 			    u32 pktLen, enum ath9k_pkt_type type, u32 txPower,
 			    u32 keyIx, enum ath9k_key_type keyType, u32 flags);
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -59,15 +59,14 @@ static void ath_tx_send_ht_normal(struct
 				  struct ath_atx_tid *tid,
 				  struct list_head *bf_head);
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
-				struct ath_txq *txq,
-				struct list_head *bf_q,
-				int txok, int sendbar);
+				struct ath_txq *txq, struct list_head *bf_q,
+				struct ath_tx_status *ts, int txok, int sendbar);
 static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head);
 static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf);
 static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
-			      int txok);
-static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
+			      struct ath_tx_status *ts, int txok);
+static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 			     int nbad, int txok, bool update_rc);
 
 enum {
@@ -223,6 +222,9 @@ static void ath_tid_drain(struct ath_sof
 {
 	struct ath_buf *bf;
 	struct list_head bf_head;
+	struct ath_tx_status ts;
+
+	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
 
 	for (;;) {
@@ -236,7 +238,7 @@ static void ath_tid_drain(struct ath_sof
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 
 		spin_unlock(&txq->axq_lock);
-		ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
+		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 		spin_lock(&txq->axq_lock);
 	}
 
@@ -286,7 +288,7 @@ static struct ath_buf* ath_clone_txbuf(s
 
 static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 struct ath_buf *bf, struct list_head *bf_q,
-				 int txok)
+				 struct ath_tx_status *ts, int txok)
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
@@ -296,7 +298,6 @@ static void ath_tx_complete_aggr(struct 
 	struct ieee80211_tx_info *tx_info;
 	struct ath_atx_tid *tid = NULL;
 	struct ath_buf *bf_next, *bf_last = bf->bf_lastbf;
-	struct ath_desc *ds = bf_last->bf_desc;
 	struct list_head bf_head, bf_pending;
 	u16 seq_st = 0, acked_cnt = 0, txfail_cnt = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
@@ -325,10 +326,9 @@ static void ath_tx_complete_aggr(struct 
 	memset(ba, 0, WME_BA_BMP_SIZE >> 3);
 
 	if (isaggr && txok) {
-		if (ATH_DS_TX_BA(ds)) {
-			seq_st = ATH_DS_BA_SEQ(ds);
-			memcpy(ba, ATH_DS_BA_BITMAP(ds),
-			       WME_BA_BMP_SIZE >> 3);
+		if (ts->ts_flags & ATH9K_TX_BA) {
+			seq_st = ts->ts_seqnum;
+			memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);
 		} else {
 			/*
 			 * AR5416 can become deaf/mute when BA
@@ -345,7 +345,7 @@ static void ath_tx_complete_aggr(struct 
 	INIT_LIST_HEAD(&bf_pending);
 	INIT_LIST_HEAD(&bf_head);
 
-	nbad = ath_tx_num_badfrms(sc, bf, txok);
+	nbad = ath_tx_num_badfrms(sc, bf, ts, txok);
 	while (bf) {
 		txfail = txpending = 0;
 		bf_next = bf->bf_next;
@@ -359,7 +359,7 @@ static void ath_tx_complete_aggr(struct 
 			acked_cnt++;
 		} else {
 			if (!(tid->state & AGGR_CLEANUP) &&
-			    ds->ds_txstat.ts_flags != ATH9K_TX_SW_ABORTED) {
+			    ts->ts_flags != ATH9K_TX_SW_ABORTED) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
 					ath_tx_set_retry(sc, txq, bf);
 					txpending = 1;
@@ -402,13 +402,14 @@ static void ath_tx_complete_aggr(struct 
 			spin_unlock_bh(&txq->axq_lock);
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
-				ath_tx_rc_status(bf, ds, nbad, txok, true);
+				ath_tx_rc_status(bf, ts, nbad, txok, true);
 				rc_update = false;
 			} else {
-				ath_tx_rc_status(bf, ds, nbad, txok, false);
+				ath_tx_rc_status(bf, ts, nbad, txok, false);
 			}
 
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, !txfail, sendbar);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
+				!txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
 			if (bf->bf_next == NULL && bf_last->bf_stale) {
@@ -426,10 +427,10 @@ static void ath_tx_complete_aggr(struct 
 					spin_unlock_bh(&txq->axq_lock);
 
 					bf->bf_state.bf_type |= BUF_XRETRY;
-					ath_tx_rc_status(bf, ds, nbad,
+					ath_tx_rc_status(bf, ts, nbad,
 							 0, false);
 					ath_tx_complete_buf(sc, bf, txq,
-							    &bf_head, 0, 0);
+							    &bf_head, ts, 0, 0);
 					break;
 				}
 
@@ -752,8 +753,11 @@ void ath_tx_aggr_stop(struct ath_softc *
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	struct ath_atx_tid *txtid = ATH_AN_2_TID(an, tid);
 	struct ath_txq *txq = &sc->tx.txq[txtid->ac->qnum];
+	struct ath_tx_status ts;
 	struct ath_buf *bf;
 	struct list_head bf_head;
+
+	memset(&ts, 0, sizeof(ts));
 	INIT_LIST_HEAD(&bf_head);
 
 	if (txtid->state & AGGR_CLEANUP)
@@ -780,7 +784,7 @@ void ath_tx_aggr_stop(struct ath_softc *
 		}
 		list_move_tail(&bf->list, &bf_head);
 		ath_tx_update_baw(sc, txtid, bf->bf_seqno);
-		ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
+		ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 	}
 	spin_unlock_bh(&txq->axq_lock);
 
@@ -1028,6 +1032,11 @@ void ath_draintxq(struct ath_softc *sc, 
 {
 	struct ath_buf *bf, *lastbf;
 	struct list_head bf_head;
+	struct ath_tx_status ts;
+
+	memset(&ts, 0, sizeof(ts));
+	if (!retry_tx)
+		ts.ts_flags = ATH9K_TX_SW_ABORTED;
 
 	INIT_LIST_HEAD(&bf_head);
 
@@ -1053,9 +1062,6 @@ void ath_draintxq(struct ath_softc *sc, 
 		}
 
 		lastbf = bf->bf_lastbf;
-		if (!retry_tx)
-			lastbf->bf_desc->ds_txstat.ts_flags =
-				ATH9K_TX_SW_ABORTED;
 
 		/* remove ath_buf's of the same mpdu from txq */
 		list_cut_position(&bf_head, &txq->axq_q, &lastbf->list);
@@ -1064,9 +1070,9 @@ void ath_draintxq(struct ath_softc *sc, 
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, 0);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0);
 		else
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, 0, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 	}
 
 	spin_lock_bh(&txq->axq_lock);
@@ -1852,9 +1858,8 @@ static void ath_tx_complete(struct ath_s
 }
 
 static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
-				struct ath_txq *txq,
-				struct list_head *bf_q,
-				int txok, int sendbar)
+				struct ath_txq *txq, struct list_head *bf_q,
+				struct ath_tx_status *ts, int txok, int sendbar)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	unsigned long flags;
@@ -1872,7 +1877,7 @@ static void ath_tx_complete_buf(struct a
 
 	dma_unmap_single(sc->dev, bf->bf_dmacontext, skb->len, DMA_TO_DEVICE);
 	ath_tx_complete(sc, skb, bf->aphy, tx_flags);
-	ath_debug_stat_tx(sc, txq, bf);
+	ath_debug_stat_tx(sc, txq, bf, ts);
 
 	/*
 	 * Return the list of ath_buf of this mpdu to free queue
@@ -1883,23 +1888,21 @@ static void ath_tx_complete_buf(struct a
 }
 
 static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
-			      int txok)
+			      struct ath_tx_status *ts, int txok)
 {
-	struct ath_buf *bf_last = bf->bf_lastbf;
-	struct ath_desc *ds = bf_last->bf_desc;
 	u16 seq_st = 0;
 	u32 ba[WME_BA_BMP_SIZE >> 5];
 	int ba_index;
 	int nbad = 0;
 	int isaggr = 0;
 
-	if (ds->ds_txstat.ts_flags == ATH9K_TX_SW_ABORTED)
+	if (ts->ts_flags == ATH9K_TX_SW_ABORTED)
 		return 0;
 
 	isaggr = bf_isaggr(bf);
 	if (isaggr) {
-		seq_st = ATH_DS_BA_SEQ(ds);
-		memcpy(ba, ATH_DS_BA_BITMAP(ds), WME_BA_BMP_SIZE >> 3);
+		seq_st = ts->ts_seqnum;
+		memcpy(ba, &ts->ba_low, WME_BA_BMP_SIZE >> 3);
 	}
 
 	while (bf) {
@@ -1913,7 +1916,7 @@ static int ath_tx_num_badfrms(struct ath
 	return nbad;
 }
 
-static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
+static void ath_tx_rc_status(struct ath_buf *bf, struct ath_tx_status *ts,
 			     int nbad, int txok, bool update_rc)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
@@ -1923,24 +1926,24 @@ static void ath_tx_rc_status(struct ath_
 	u8 i, tx_rateindex;
 
 	if (txok)
-		tx_info->status.ack_signal = ds->ds_txstat.ts_rssi;
+		tx_info->status.ack_signal = ts->ts_rssi;
 
-	tx_rateindex = ds->ds_txstat.ts_rateindex;
+	tx_rateindex = ts->ts_rateindex;
 	WARN_ON(tx_rateindex >= hw->max_rates);
 
-	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
+	if (ts->ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && update_rc)
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 
-	if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
+	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
 	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0 && update_rc) {
 		if (ieee80211_is_data(hdr->frame_control)) {
-			if (ds->ds_txstat.ts_flags &
+			if (ts->ts_flags &
 			    (ATH9K_TX_DATA_UNDERRUN | ATH9K_TX_DELIM_UNDERRUN))
 				tx_info->pad[0] |= ATH_TX_INFO_UNDERRUN;
-			if ((ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY) ||
-			    (ds->ds_txstat.ts_status & ATH9K_TXERR_FIFO))
+			if ((ts->ts_status & ATH9K_TXERR_XRETRY) ||
+			    (ts->ts_status & ATH9K_TXERR_FIFO))
 				tx_info->pad[0] |= ATH_TX_INFO_XRETRY;
 			tx_info->status.ampdu_len = bf->bf_nframes;
 			tx_info->status.ampdu_ack_len = bf->bf_nframes - nbad;
@@ -1978,6 +1981,7 @@ static void ath_tx_processq(struct ath_s
 	struct ath_buf *bf, *lastbf, *bf_held = NULL;
 	struct list_head bf_head;
 	struct ath_desc *ds;
+	struct ath_tx_status *ts;
 	int txok;
 	int status;
 
@@ -2016,8 +2020,9 @@ static void ath_tx_processq(struct ath_s
 
 		lastbf = bf->bf_lastbf;
 		ds = lastbf->bf_desc;
+		ts = &ds->ds_us.tx;
 
-		status = ath9k_hw_txprocdesc(ah, ds);
+		status = ath9k_hw_txprocdesc(ah, ds, ts);
 		if (status == -EINPROGRESS) {
 			spin_unlock_bh(&txq->axq_lock);
 			break;
@@ -2028,7 +2033,7 @@ static void ath_tx_processq(struct ath_s
 		 * can disable RX.
 		 */
 		if (bf->bf_isnullfunc &&
-		    (ds->ds_txstat.ts_status & ATH9K_TX_ACKED)) {
+		    (ts->ts_status & ATH9K_TX_ACKED)) {
 			if ((sc->ps_flags & PS_ENABLED))
 				ath9k_enable_ps(sc);
 			else
@@ -2047,7 +2052,7 @@ static void ath_tx_processq(struct ath_s
 				&txq->axq_q, lastbf->list.prev);
 
 		txq->axq_depth--;
-		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_MASK);
+		txok = !(ts->ts_status & ATH9K_TXERR_MASK);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
@@ -2062,16 +2067,16 @@ static void ath_tx_processq(struct ath_s
 			 * This frame is sent out as a single frame.
 			 * Use hardware retry status for this frame.
 			 */
-			bf->bf_retries = ds->ds_txstat.ts_longretry;
-			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
+			bf->bf_retries = ts->ts_longretry;
+			if (ts->ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-			ath_tx_rc_status(bf, ds, 0, txok, true);
+			ath_tx_rc_status(bf, ts, 0, txok, true);
 		}
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, txok);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, ts, txok);
 		else
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, txok, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts, txok, 0);
 
 		ath_wake_mac80211_queue(sc, txq);
 
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -640,10 +640,8 @@ static ssize_t read_file_xmit(struct fil
 }
 
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
-		       struct ath_buf *bf)
+		       struct ath_buf *bf, struct ath_tx_status *ts)
 {
-	struct ath_desc *ds = bf->bf_desc;
-
 	if (bf_isampdu(bf)) {
 		if (bf_isxretried(bf))
 			TX_STAT_INC(txq->axq_qnum, a_xretries);
@@ -653,17 +651,17 @@ void ath_debug_stat_tx(struct ath_softc 
 		TX_STAT_INC(txq->axq_qnum, completed);
 	}
 
-	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FIFO)
+	if (ts->ts_status & ATH9K_TXERR_FIFO)
 		TX_STAT_INC(txq->axq_qnum, fifo_underrun);
-	if (ds->ds_txstat.ts_status & ATH9K_TXERR_XTXOP)
+	if (ts->ts_status & ATH9K_TXERR_XTXOP)
 		TX_STAT_INC(txq->axq_qnum, xtxop);
-	if (ds->ds_txstat.ts_status & ATH9K_TXERR_TIMER_EXPIRED)
+	if (ts->ts_status & ATH9K_TXERR_TIMER_EXPIRED)
 		TX_STAT_INC(txq->axq_qnum, timer_exp);
-	if (ds->ds_txstat.ts_flags & ATH9K_TX_DESC_CFG_ERR)
+	if (ts->ts_flags & ATH9K_TX_DESC_CFG_ERR)
 		TX_STAT_INC(txq->axq_qnum, desc_cfg_err);
-	if (ds->ds_txstat.ts_flags & ATH9K_TX_DATA_UNDERRUN)
+	if (ts->ts_flags & ATH9K_TX_DATA_UNDERRUN)
 		TX_STAT_INC(txq->axq_qnum, data_underrun);
-	if (ds->ds_txstat.ts_flags & ATH9K_TX_DELIM_UNDERRUN)
+	if (ts->ts_flags & ATH9K_TX_DELIM_UNDERRUN)
 		TX_STAT_INC(txq->axq_qnum, delim_underrun);
 }
 
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -172,7 +172,7 @@ void ath9k_debug_remove_root(void);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_rc(struct ath_softc *sc, int final_rate);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_txq *txq,
-		       struct ath_buf *bf);
+		       struct ath_buf *bf, struct ath_tx_status *ts);
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_buf *bf);
 void ath_debug_stat_retries(struct ath_softc *sc, int rix,
 			    int xretries, int retries, u8 per);
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -178,9 +178,6 @@ void ath_descdma_cleanup(struct ath_soft
 #define BAW_WITHIN(_start, _bawsz, _seqno) \
 	((((_seqno) - (_start)) & 4095) < (_bawsz))
 
-#define ATH_DS_BA_SEQ(_ds)         ((_ds)->ds_us.tx.ts_seqnum)
-#define ATH_DS_BA_BITMAP(_ds)      (&(_ds)->ds_us.tx.ba_low)
-#define ATH_DS_TX_BA(_ds)          ((_ds)->ds_us.tx.ts_flags & ATH9K_TX_BA)
 #define ATH_AN_2_TID(_an, _tidno)  (&(_an)->tid[(_tidno)])
 
 #define ATH_TX_COMPLETE_POLL_INT	1000
