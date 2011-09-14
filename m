Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58739 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab1INTYe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:34 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 01/12] ath9k: remove ATH_TX_XRETRY and BUF_XRETRY flags
Date: Wed, 14 Sep 2011 21:24:16 +0200
Message-Id: <1316028267-34187-1-git-send-email-nbd@openwrt.org> (sfid-20110914_212453_660455_5DC554CC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +-----
 drivers/net/wireless/ath/ath9k/debug.c |    7 ++++---
 drivers/net/wireless/ath/ath9k/debug.h |    6 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c  |   23 ++++-------------------
 4 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0fb4a26..51d4a60 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -87,17 +87,14 @@ struct ath_config {
  * @BUF_AMPDU: This buffer is an ampdu, as part of an aggregate (during TX)
  * @BUF_AGGR: Indicates whether the buffer can be aggregated
  *	(used in aggregation scheduling)
- * @BUF_XRETRY: To denote excessive retries of the buffer
  */
 enum buffer_type {
 	BUF_AMPDU		= BIT(0),
 	BUF_AGGR		= BIT(1),
-	BUF_XRETRY		= BIT(2),
 };
 
 #define bf_isampdu(bf)		(bf->bf_state.bf_type & BUF_AMPDU)
 #define bf_isaggr(bf)		(bf->bf_state.bf_type & BUF_AGGR)
-#define bf_isxretried(bf)	(bf->bf_state.bf_type & BUF_XRETRY)
 
 #define ATH_TXSTATUS_RING_SIZE 64
 
@@ -277,8 +274,7 @@ struct ath_tx_control {
 };
 
 #define ATH_TX_ERROR        0x01
-#define ATH_TX_XRETRY       0x02
-#define ATH_TX_BAR          0x04
+#define ATH_TX_BAR          0x02
 
 /**
  * @txq_map:  Index is mac80211 queue number.  This is
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 7f14387..179da20 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -826,7 +826,8 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 }
 
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
-		       struct ath_tx_status *ts, struct ath_txq *txq)
+		       struct ath_tx_status *ts, struct ath_txq *txq,
+		       unsigned int flags)
 {
 #define TX_SAMP_DBG(c) (sc->debug.bb_mac_samp[sc->debug.sampidx].ts\
 			[sc->debug.tsidx].c)
@@ -836,12 +837,12 @@ void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
 	sc->debug.stats.txstats[qnum].tx_bytes_all += bf->bf_mpdu->len;
 
 	if (bf_isampdu(bf)) {
-		if (bf_isxretried(bf))
+		if (flags & ATH_TX_BAR)
 			TX_STAT_INC(qnum, a_xretries);
 		else
 			TX_STAT_INC(qnum, a_completed);
 	} else {
-		if (bf_isxretried(bf))
+		if (ts->ts_status & ATH9K_TXERR_XRETRY)
 			TX_STAT_INC(qnum, xretries);
 		else
 			TX_STAT_INC(qnum, completed);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 95f85bd..39f89bc 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -230,7 +230,8 @@ int ath9k_init_debug(struct ath_hw *ah);
 void ath9k_debug_samp_bb_mac(struct ath_softc *sc);
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
-		       struct ath_tx_status *ts, struct ath_txq *txq);
+		       struct ath_tx_status *ts, struct ath_txq *txq,
+		       unsigned int flags);
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #else
@@ -252,7 +253,8 @@ static inline void ath_debug_stat_interrupt(struct ath_softc *sc,
 static inline void ath_debug_stat_tx(struct ath_softc *sc,
 				     struct ath_buf *bf,
 				     struct ath_tx_status *ts,
-				     struct ath_txq *txq)
+				     struct ath_txq *txq,
+				     unsigned int flags)
 {
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index cb37047..5404982 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -390,7 +390,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 		while (bf) {
 			bf_next = bf->bf_next;
 
-			bf->bf_state.bf_type |= BUF_XRETRY;
 			if (!bf->bf_stale || bf_next != NULL)
 				list_move_tail(&bf->list, &bf_head);
 
@@ -470,7 +469,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				clear_filter = true;
 				txpending = 1;
 			} else {
-				bf->bf_state.bf_type |= BUF_XRETRY;
 				txfail = 1;
 				sendbar = 1;
 				txfail_cnt++;
@@ -523,13 +521,11 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 						ath_tx_update_baw(sc, tid, seqno);
 						spin_unlock_bh(&txq->axq_lock);
 
-						bf->bf_state.bf_type |=
-							BUF_XRETRY;
 						ath_tx_rc_status(sc, bf, ts, nframes,
 								nbad, 0, false);
 						ath_tx_complete_buf(sc, bf, txq,
 								    &bf_head,
-								    ts, 0, 0);
+								    ts, 0, 1);
 						break;
 					}
 
@@ -1953,10 +1949,9 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	if (tx_flags & ATH_TX_BAR)
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
-	if (!(tx_flags & (ATH_TX_ERROR | ATH_TX_XRETRY))) {
+	if (!(tx_flags & ATH_TX_ERROR))
 		/* Frame was ACKed */
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
-	}
 
 	padpos = ath9k_cmn_padpos(hdr->frame_control);
 	padsize = padpos & 3;
@@ -2006,13 +2001,9 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	if (sendbar)
 		tx_flags = ATH_TX_BAR;
 
-	if (!txok) {
+	if (!txok)
 		tx_flags |= ATH_TX_ERROR;
 
-		if (bf_isxretried(bf))
-			tx_flags |= ATH_TX_XRETRY;
-	}
-
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
 	bf->bf_buf_addr = 0;
 
@@ -2024,7 +2015,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 		else
 			complete(&sc->paprd_complete);
 	} else {
-		ath_debug_stat_tx(sc, bf, ts, txq);
+		ath_debug_stat_tx(sc, bf, ts, txq, tx_flags);
 		ath_tx_complete(sc, skb, tx_flags, txq);
 	}
 	/* At this point, skb (bf->bf_mpdu) is consumed...make sure we don't
@@ -2115,12 +2106,6 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	spin_unlock_bh(&txq->axq_lock);
 
 	if (!bf_isampdu(bf)) {
-		/*
-		 * This frame is sent out as a single frame.
-		 * Use hardware retry status for this frame.
-		 */
-		if (ts->ts_status & ATH9K_TXERR_XRETRY)
-			bf->bf_state.bf_type |= BUF_XRETRY;
 		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok, true);
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok, 0);
 	} else
-- 
1.7.3.2

