Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:36980 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab0C3DO1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 23:14:27 -0400
Message-ID: <4BB16C8F.60001@openwrt.org>
Date: Mon, 29 Mar 2010 20:14:23 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/3] ath9k: allocate tx and rx status information on stack
References: <4BB16ADF.8090609@openwrt.org> <4BB16B67.4020708@openwrt.org>
In-Reply-To: <4BB16B67.4020708@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_tx_status and ath_rx_status data are only necessary for a short
time, until they have been processed and converted into mac80211 data
structures.
Because of that, it makes no sense to keep them tied to the DMA
descriptor, that only wastes precious memory.
This patch allocates the data on stack in the functions that call the
conversion functions from ath9k_hw.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -477,7 +477,6 @@ int ath_rx_tasklet(struct ath_softc *sc,
 
 	struct ath_buf *bf;
 	struct ath_desc *ds;
-	struct ath_rx_status *rx_stats;
 	struct sk_buff *skb = NULL, *requeue_skb;
 	struct ieee80211_rx_status *rxs;
 	struct ath_hw *ah = sc->sc_ah;
@@ -491,6 +490,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 	struct ieee80211_hdr *hdr;
 	int retval;
 	bool decrypt_error = false;
+	struct ath_rx_status rs;
 
 	spin_lock_bh(&sc->rx.rxbuflock);
 
@@ -506,7 +506,6 @@ int ath_rx_tasklet(struct ath_softc *sc,
 
 		bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
 		ds = bf->bf_desc;
-		rx_stats = &ds->ds_us.rx;
 
 		/*
 		 * Must provide the virtual address of the current
@@ -519,11 +518,14 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		 * on.  All this is necessary because of our use of
 		 * a self-linked list to avoid rx overruns.
 		 */
-		retval = ath9k_hw_rxprocdesc(ah, ds, rx_stats, 0);
+		memset(&rs, 0, sizeof(rs));
+		retval = ath9k_hw_rxprocdesc(ah, ds, &rs, 0);
 		if (retval == -EINPROGRESS) {
+			struct ath_rx_status trs;
 			struct ath_buf *tbf;
 			struct ath_desc *tds;
 
+			memset(&trs, 0, sizeof(trs));
 			if (list_is_last(&bf->list, &sc->rx.rxbuf)) {
 				sc->rx.rxlink = NULL;
 				break;
@@ -543,7 +545,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 			 */
 
 			tds = tbf->bf_desc;
-			retval = ath9k_hw_rxprocdesc(ah, tds, &tds->ds_us.rx, 0);
+			retval = ath9k_hw_rxprocdesc(ah, tds, &trs, 0);
 			if (retval == -EINPROGRESS) {
 				break;
 			}
@@ -567,7 +569,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 
 		hw = ath_get_virt_hw(sc, hdr);
 
-		ath_debug_stat_rx(sc, rx_stats);
+		ath_debug_stat_rx(sc, &rs);
 
 		/*
 		 * If we're asked to flush receive queue, directly
@@ -576,7 +578,7 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		if (flush)
 			goto requeue;
 
-		retval = ath9k_cmn_rx_skb_preprocess(common, hw, skb, rx_stats,
+		retval = ath9k_cmn_rx_skb_preprocess(common, hw, skb, &rs,
 						     rxs, &decrypt_error);
 		if (retval)
 			goto requeue;
@@ -597,9 +599,9 @@ int ath_rx_tasklet(struct ath_softc *sc,
 				 common->rx_bufsize,
 				 DMA_FROM_DEVICE);
 
-		skb_put(skb, rx_stats->rs_datalen);
+		skb_put(skb, rs.rs_datalen);
 
-		ath9k_cmn_rx_skb_postprocess(common, skb, rx_stats,
+		ath9k_cmn_rx_skb_postprocess(common, skb, &rs,
 					     rxs, decrypt_error);
 
 		/* We will now give hardware our shiny new allocated skb */
@@ -622,9 +624,9 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		 * change the default rx antenna if rx diversity chooses the
 		 * other antenna 3 times in a row.
 		 */
-		if (sc->rx.defant != rx_stats->rs_antenna) {
+		if (sc->rx.defant != rs.rs_antenna) {
 			if (++sc->rx.rxotherant >= 3)
-				ath_setdefantenna(sc, rx_stats->rs_antenna);
+				ath_setdefantenna(sc, rs.rs_antenna);
 		} else {
 			sc->rx.rxotherant = 0;
 		}
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -233,11 +233,6 @@ struct ath_desc {
 	u32 ds_ctl0;
 	u32 ds_ctl1;
 	u32 ds_hw[20];
-	union {
-		struct ath_tx_status tx;
-		struct ath_rx_status rx;
-		void *stats;
-	} ds_us;
 	void *ds_vdata;
 } __packed;
 
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1981,7 +1981,7 @@ static void ath_tx_processq(struct ath_s
 	struct ath_buf *bf, *lastbf, *bf_held = NULL;
 	struct list_head bf_head;
 	struct ath_desc *ds;
-	struct ath_tx_status *ts;
+	struct ath_tx_status ts;
 	int txok;
 	int status;
 
@@ -2020,9 +2020,9 @@ static void ath_tx_processq(struct ath_s
 
 		lastbf = bf->bf_lastbf;
 		ds = lastbf->bf_desc;
-		ts = &ds->ds_us.tx;
 
-		status = ath9k_hw_txprocdesc(ah, ds, ts);
+		memset(&ts, 0, sizeof(ts));
+		status = ath9k_hw_txprocdesc(ah, ds, &ts);
 		if (status == -EINPROGRESS) {
 			spin_unlock_bh(&txq->axq_lock);
 			break;
@@ -2033,7 +2033,7 @@ static void ath_tx_processq(struct ath_s
 		 * can disable RX.
 		 */
 		if (bf->bf_isnullfunc &&
-		    (ts->ts_status & ATH9K_TX_ACKED)) {
+		    (ts.ts_status & ATH9K_TX_ACKED)) {
 			if ((sc->ps_flags & PS_ENABLED))
 				ath9k_enable_ps(sc);
 			else
@@ -2052,7 +2052,7 @@ static void ath_tx_processq(struct ath_s
 				&txq->axq_q, lastbf->list.prev);
 
 		txq->axq_depth--;
-		txok = !(ts->ts_status & ATH9K_TXERR_MASK);
+		txok = !(ts.ts_status & ATH9K_TXERR_MASK);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 
@@ -2067,16 +2067,16 @@ static void ath_tx_processq(struct ath_s
 			 * This frame is sent out as a single frame.
 			 * Use hardware retry status for this frame.
 			 */
-			bf->bf_retries = ts->ts_longretry;
-			if (ts->ts_status & ATH9K_TXERR_XRETRY)
+			bf->bf_retries = ts.ts_longretry;
+			if (ts.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-			ath_tx_rc_status(bf, ts, 0, txok, true);
+			ath_tx_rc_status(bf, &ts, 0, txok, true);
 		}
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, ts, txok);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok);
 		else
-			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts, txok, 0);
+			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
 		ath_wake_mac80211_queue(sc, txq);
 

