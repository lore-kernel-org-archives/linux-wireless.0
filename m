Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48071 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755827Ab0KNOUX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 09:20:23 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 09/13] ath9k: remove bf_tx_aborted from struct ath_buf
Date: Sun, 14 Nov 2010 15:20:09 +0100
Message-Id: <1289744413-20789-9-git-send-email-nbd@openwrt.org>
In-Reply-To: <1289744413-20789-8-git-send-email-nbd@openwrt.org>
References: <1289744413-20789-1-git-send-email-nbd@openwrt.org>
 <1289744413-20789-2-git-send-email-nbd@openwrt.org>
 <1289744413-20789-3-git-send-email-nbd@openwrt.org>
 <1289744413-20789-4-git-send-email-nbd@openwrt.org>
 <1289744413-20789-5-git-send-email-nbd@openwrt.org>
 <1289744413-20789-6-git-send-email-nbd@openwrt.org>
 <1289744413-20789-7-git-send-email-nbd@openwrt.org>
 <1289744413-20789-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   23 +++++++++--------------
 2 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 944505c..224df29 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -227,7 +227,6 @@ struct ath_buf {
 	dma_addr_t bf_daddr;		/* physical addr of desc */
 	dma_addr_t bf_buf_addr;	/* physical addr of data buffer, for DMA */
 	bool bf_stale;
-	bool bf_tx_aborted;
 	u16 bf_flags;
 	struct ath_buf_state bf_state;
 	struct ath_wiphy *aphy;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 527151e..c35033f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -334,9 +334,6 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 	*nbad = 0;
 	*nframes = 0;
 
-	if (bf->bf_lastbf->bf_tx_aborted)
-		return;
-
 	isaggr = bf_isaggr(bf);
 	if (isaggr) {
 		seq_st = ts->ts_seqnum;
@@ -357,7 +354,7 @@ static void ath_tx_count_frames(struct ath_softc *sc, struct ath_buf *bf,
 
 static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 struct ath_buf *bf, struct list_head *bf_q,
-				 struct ath_tx_status *ts, int txok)
+				 struct ath_tx_status *ts, int txok, bool retry)
 {
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
@@ -461,8 +458,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			/* transmit completion */
 			acked_cnt++;
 		} else {
-			if (!(tid->state & AGGR_CLEANUP) &&
-			    !bf_last->bf_tx_aborted) {
+			if (!(tid->state & AGGR_CLEANUP) && retry) {
 				if (bf->bf_retries < ATH_MAX_SW_RETRIES) {
 					ath_tx_set_retry(sc, txq, bf);
 					txpending = 1;
@@ -1132,8 +1128,6 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		}
 
 		lastbf = bf->bf_lastbf;
-		if (!retry_tx)
-			lastbf->bf_tx_aborted = true;
 
 		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
 			list_cut_position(&bf_head,
@@ -1150,7 +1144,8 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 		spin_unlock_bh(&txq->axq_lock);
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, 0,
+					     retry_tx);
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, 0, 0);
 	}
@@ -1171,7 +1166,7 @@ void ath_draintxq(struct ath_softc *sc, struct ath_txq *txq, bool retry_tx)
 
 			if (bf_isampdu(bf))
 				ath_tx_complete_aggr(sc, txq, bf, &bf_head,
-						     &ts, 0);
+						     &ts, 0, retry_tx);
 			else
 				ath_tx_complete_buf(sc, bf, txq, &bf_head,
 						    &ts, 0, 0);
@@ -1657,8 +1652,6 @@ static struct ath_buf *ath_tx_setup_buffer(struct ieee80211_hw *hw,
 		return NULL;
 	}
 
-	bf->bf_tx_aborted = false;
-
 	return bf;
 }
 
@@ -2094,7 +2087,8 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		qnum = skb_get_queue_mapping(bf->bf_mpdu);
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &ts, txok,
+					     true);
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, &ts, txok, 0);
 
@@ -2216,7 +2210,8 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 		qnum = skb_get_queue_mapping(bf->bf_mpdu);
 
 		if (bf_isampdu(bf))
-			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs, txok);
+			ath_tx_complete_aggr(sc, txq, bf, &bf_head, &txs,
+					     txok, true);
 		else
 			ath_tx_complete_buf(sc, bf, txq, &bf_head,
 					    &txs, txok, 0);
-- 
1.7.3.2

