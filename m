Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:28652 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751498Ab0IPJvQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 05:51:16 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-044909675
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 18:51:15 +0900 (JST)
Subject: [PATCH 4/9] ath5k: Move tx frame completion into separate function
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Thu, 16 Sep 2010 18:51:33 +0900
Message-ID: <20100916095133.17637.68969.stgit@tt-desk>
In-Reply-To: <20100916095112.17637.17207.stgit@tt-desk>
References: <20100916095112.17637.17207.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clearer separation between queue handling and what we do with completed frames.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |  107 ++++++++++++++++++---------------
 1 files changed, 57 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 1e3d7b7..eba2e74 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1520,6 +1520,61 @@ drop_packet:
 	return NETDEV_TX_OK;
 }
 
+static void
+ath5k_tx_frame_completed(struct ath5k_softc *sc, struct sk_buff *skb,
+			 struct ath5k_tx_status *ts)
+{
+	struct ieee80211_tx_info *info;
+	int i;
+
+	sc->stats.tx_all_count++;
+	info = IEEE80211_SKB_CB(skb);
+
+	ieee80211_tx_info_clear_status(info);
+	for (i = 0; i < 4; i++) {
+		struct ieee80211_tx_rate *r =
+			&info->status.rates[i];
+
+		if (ts->ts_rate[i]) {
+			r->idx = ath5k_hw_to_driver_rix(sc, ts->ts_rate[i]);
+			r->count = ts->ts_retry[i];
+		} else {
+			r->idx = -1;
+			r->count = 0;
+		}
+	}
+
+	/* count the successful attempt as well */
+	info->status.rates[ts->ts_final_idx].count++;
+
+	if (unlikely(ts->ts_status)) {
+		sc->stats.ack_fail++;
+		if (ts->ts_status & AR5K_TXERR_FILT) {
+			info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
+			sc->stats.txerr_filt++;
+		}
+		if (ts->ts_status & AR5K_TXERR_XRETRY)
+			sc->stats.txerr_retry++;
+		if (ts->ts_status & AR5K_TXERR_FIFO)
+			sc->stats.txerr_fifo++;
+	} else {
+		info->flags |= IEEE80211_TX_STAT_ACK;
+		info->status.ack_signal = ts->ts_rssi;
+	}
+
+	/*
+	* Remove MAC header padding before giving the frame
+	* back to mac80211.
+	*/
+	ath5k_remove_padding(skb);
+
+	if (ts->ts_antenna > 0 && ts->ts_antenna < 5)
+		sc->stats.antenna_tx[ts->ts_antenna]++;
+	else
+		sc->stats.antenna_tx[0]++; /* invalid */
+
+	ieee80211_tx_status(sc->hw, skb);
+}
 
 static void
 ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
@@ -1528,8 +1583,7 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 	struct ath5k_buf *bf, *bf0;
 	struct ath5k_desc *ds;
 	struct sk_buff *skb;
-	struct ieee80211_tx_info *info;
-	int i, ret;
+	int ret;
 
 	spin_lock(&txq->lock);
 	list_for_each_entry_safe(bf, bf0, &txq->q, list) {
@@ -1545,7 +1599,6 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 		if (ath5k_hw_get_txdp(sc->ah, txq->qnum) == bf->daddr &&
 		    !list_is_last(&bf->list, &txq->q))
 			break;
-
 		ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
 		if (unlikely(ret == -EINPROGRESS))
 			break;
@@ -1555,58 +1608,12 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
 			break;
 		}
 
-		sc->stats.tx_all_count++;
 		skb = bf->skb;
-		info = IEEE80211_SKB_CB(skb);
 		bf->skb = NULL;
-
 		pci_unmap_single(sc->pdev, bf->skbaddr, skb->len,
 				PCI_DMA_TODEVICE);
 
-		ieee80211_tx_info_clear_status(info);
-		for (i = 0; i < 4; i++) {
-			struct ieee80211_tx_rate *r =
-				&info->status.rates[i];
-
-			if (ts.ts_rate[i]) {
-				r->idx = ath5k_hw_to_driver_rix(sc, ts.ts_rate[i]);
-				r->count = ts.ts_retry[i];
-			} else {
-				r->idx = -1;
-				r->count = 0;
-			}
-		}
-
-		/* count the successful attempt as well */
-		info->status.rates[ts.ts_final_idx].count++;
-
-		if (unlikely(ts.ts_status)) {
-			sc->stats.ack_fail++;
-			if (ts.ts_status & AR5K_TXERR_FILT) {
-				info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-				sc->stats.txerr_filt++;
-			}
-			if (ts.ts_status & AR5K_TXERR_XRETRY)
-				sc->stats.txerr_retry++;
-			if (ts.ts_status & AR5K_TXERR_FIFO)
-				sc->stats.txerr_fifo++;
-		} else {
-			info->flags |= IEEE80211_TX_STAT_ACK;
-			info->status.ack_signal = ts.ts_rssi;
-		}
-
-		/*
-		 * Remove MAC header padding before giving the frame
-		 * back to mac80211.
-		 */
-		ath5k_remove_padding(skb);
-
-		if (ts.ts_antenna > 0 && ts.ts_antenna < 5)
-			sc->stats.antenna_tx[ts.ts_antenna]++;
-		else
-			sc->stats.antenna_tx[0]++; /* invalid */
-
-		ieee80211_tx_status(sc->hw, skb);
+		ath5k_tx_frame_completed(sc, skb, &ts);
 
 		spin_lock(&sc->txbuflock);
 		list_move_tail(&bf->list, &sc->txbuf);

