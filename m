Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58757 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920Ab1INTYh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:24:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 11/12] ath9k: optimize ath_tx_rc_status usage
Date: Wed, 14 Sep 2011 21:24:26 +0200
Message-Id: <1316028267-34187-11-git-send-email-nbd@openwrt.org> (sfid-20110914_212446_422649_C4D2652C)
In-Reply-To: <1316028267-34187-10-git-send-email-nbd@openwrt.org>
References: <1316028267-34187-1-git-send-email-nbd@openwrt.org>
 <1316028267-34187-2-git-send-email-nbd@openwrt.org>
 <1316028267-34187-3-git-send-email-nbd@openwrt.org>
 <1316028267-34187-4-git-send-email-nbd@openwrt.org>
 <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
 <1316028267-34187-8-git-send-email-nbd@openwrt.org>
 <1316028267-34187-9-git-send-email-nbd@openwrt.org>
 <1316028267-34187-10-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The only flag that needs to be set when ath_tx_rc_status is called with
rc_update == false is the IEEE80211_TX_STAT_TX_FILTERED flag. All other
data is ignored in that case.
This flag can be set from ath_tx_complete_buf instead, so that we can
drop a few redundant calls to ath_tx_rc_status and remove the rc_update
function parameter

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   29 +++++++++++++----------------
 1 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 634a29a..a0cd51f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -58,7 +58,7 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 			     struct list_head *head, bool internal);
 static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_status *ts, int nframes, int nbad,
-			     int txok, bool update_rc);
+			     int txok);
 static void ath_tx_update_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
 			      int seqno);
 static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
@@ -392,7 +392,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			if (!bf->bf_stale || bf_next != NULL)
 				list_move_tail(&bf->list, &bf_head);
 
-			ath_tx_rc_status(sc, bf, ts, 1, 1, 0, false);
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
 				0, 0);
 
@@ -494,10 +493,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
 				memcpy(tx_info->control.rates, rates, sizeof(rates));
-				ath_tx_rc_status(sc, bf, ts, nframes, nbad, txok, true);
+				ath_tx_rc_status(sc, bf, ts, nframes, nbad, txok);
 				rc_update = false;
-			} else {
-				ath_tx_rc_status(sc, bf, ts, nframes, nbad, txok, false);
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, ts,
@@ -519,8 +516,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 						ath_tx_update_baw(sc, tid, seqno);
 						spin_unlock_bh(&txq->axq_lock);
 
-						ath_tx_rc_status(sc, bf, ts, nframes,
-								nbad, 0, false);
 						ath_tx_complete_buf(sc, bf, txq,
 								    &bf_head,
 								    ts, 0, 1);
@@ -1983,6 +1978,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 				struct ath_tx_status *ts, int txok, int sendbar)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	unsigned long flags;
 	int tx_flags = 0;
 
@@ -1992,6 +1988,9 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 	if (!txok)
 		tx_flags |= ATH_TX_ERROR;
 
+	if (ts->ts_status & ATH9K_TXERR_FILT)
+		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+
 	dma_unmap_single(sc->dev, bf->bf_buf_addr, skb->len, DMA_TO_DEVICE);
 	bf->bf_buf_addr = 0;
 
@@ -2021,7 +2020,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 
 static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 			     struct ath_tx_status *ts, int nframes, int nbad,
-			     int txok, bool update_rc)
+			     int txok)
 {
 	struct sk_buff *skb = bf->bf_mpdu;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -2036,9 +2035,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	tx_rateindex = ts->ts_rateindex;
 	WARN_ON(tx_rateindex >= hw->max_rates);
 
-	if (ts->ts_status & ATH9K_TXERR_FILT)
-		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && update_rc) {
+	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
 		tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 
 		BUG_ON(nbad > nframes);
@@ -2048,7 +2045,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 	}
 
 	if ((ts->ts_status & ATH9K_TXERR_FILT) == 0 &&
-	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0 && update_rc) {
+	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) == 0) {
 		/*
 		 * If an underrun error is seen assume it as an excessive
 		 * retry only if max frame trigger level has been reached
@@ -2061,9 +2058,9 @@ static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
 		 * successfully by eventually preferring slower rates.
 		 * This itself should also alleviate congestion on the bus.
 		 */
-		if (ieee80211_is_data(hdr->frame_control) &&
-		    (ts->ts_flags & (ATH9K_TX_DATA_UNDERRUN |
-		                     ATH9K_TX_DELIM_UNDERRUN)) &&
+		if (unlikely(ts->ts_flags & (ATH9K_TX_DATA_UNDERRUN |
+		                             ATH9K_TX_DELIM_UNDERRUN)) &&
+		    ieee80211_is_data(hdr->frame_control) &&
 		    ah->tx_trig_level >= sc->sc_ah->config.max_txtrig_level)
 			tx_info->status.rates[tx_rateindex].count =
 				hw->max_rate_tries;
@@ -2094,7 +2091,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	spin_unlock_bh(&txq->axq_lock);
 
 	if (!bf_isampdu(bf)) {
-		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok, true);
+		ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
 		ath_tx_complete_buf(sc, bf, txq, bf_head, ts, txok, 0);
 	} else
 		ath_tx_complete_aggr(sc, txq, bf, bf_head, ts, txok, true);
-- 
1.7.3.2

