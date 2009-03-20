Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:51225 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZCTKBu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 06:01:50 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 03:01:49 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Luis.Rodriguez@atheros.com>,
	<Jouni.Malinen@atheros.com>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/2] ath9k: Fix bug in reporting status of tx rate
Date: Fri, 20 Mar 2009 15:27:49 +0530
Message-ID: <1237543070-25471-1-git-send-email-vasanth@atheros.com> (sfid-20090320_110154_081438_FEF38F05)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates count of every hw tried rate with
appropriate tries before reporting tx status of a frame.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath9k/xmit.c |   35 ++++++++++++++++++++++-------------
 1 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index f287719..21e90bc 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -67,7 +67,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf);
 static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 			      int txok);
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
-			     int nbad, int txok);
+			     int nbad, int txok, bool update_rc);
 
 /*********************/
 /* Aggregation logic */
@@ -370,11 +370,13 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ath_tx_update_baw(sc, tid, bf->bf_seqno);
 			spin_unlock_bh(&txq->axq_lock);
 
-			if (rc_update)
-				if (acked_cnt == 1 || txfail_cnt == 1) {
-					ath_tx_rc_status(bf, ds, nbad, txok);
-					rc_update = false;
-				}
+			if (rc_update && (acked_cnt == 1 || txfail_cnt == 1)) {
+				ath_tx_rc_status(bf, ds, nbad, txok, true);
+				rc_update = false;
+			} else {
+				ath_tx_rc_status(bf, ds, nbad, txok, false);
+			}
+
 			ath_tx_complete_buf(sc, bf, &bf_head, !txfail, sendbar);
 		} else {
 			/* retry the un-acked ones */
@@ -1779,8 +1781,6 @@ static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
-	tx_info->status.rates[0].count = tx_status->retries + 1;
-
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	padsize = hdrlen & 3;
 	if (padsize && hdrlen >= 24) {
@@ -1867,30 +1867,39 @@ static int ath_tx_num_badfrms(struct ath_softc *sc, struct ath_buf *bf,
 }
 
 static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds,
-			     int nbad, int txok)
+			     int nbad, int txok, bool update_rc)
 {
 	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+	struct ieee80211_hw *hw = tx_info_priv->aphy->hw;
+	u8 i, tx_rateindex;
 
 	if (txok)
 		tx_info->status.ack_signal = ds->ds_txstat.ts_rssi;
 
-	tx_info_priv->update_rc = false;
+	tx_rateindex = ds->ds_txstat.ts_rateindex;
+	WARN_ON(tx_rateindex >= hw->max_rates);
+
+	tx_info_priv->update_rc = update_rc;
 	if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 		tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 
 	if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
-	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
+	    (bf->bf_flags & ATH9K_TXDESC_NOACK) == 0 && update_rc) {
 		if (ieee80211_is_data(hdr->frame_control)) {
 			memcpy(&tx_info_priv->tx, &ds->ds_txstat,
 			       sizeof(tx_info_priv->tx));
 			tx_info_priv->n_frames = bf->bf_nframes;
 			tx_info_priv->n_bad_frames = nbad;
-			tx_info_priv->update_rc = true;
 		}
 	}
+
+	for (i = tx_rateindex + 1; i < hw->max_rates; i++)
+		tx_info->status.rates[i].count = 0;
+
+	tx_info->status.rates[tx_rateindex].count = bf->bf_retries + 1;
 }
 
 static void ath_wake_mac80211_queue(struct ath_softc *sc, struct ath_txq *txq)
@@ -2009,7 +2018,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			bf->bf_retries = ds->ds_txstat.ts_longretry;
 			if (ds->ds_txstat.ts_status & ATH9K_TXERR_XRETRY)
 				bf->bf_state.bf_type |= BUF_XRETRY;
-			ath_tx_rc_status(bf, ds, 0, txok);
+			ath_tx_rc_status(bf, ds, 0, txok, true);
 		}
 
 		if (bf_isampdu(bf))
-- 
1.5.5.1

