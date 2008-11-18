Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28320 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYKRDmY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:42:24 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:42:24 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
Message-ID: <18722.14578.225321.179115@gargle.gargle.HOWL> (sfid-20081118_044242_350211_4DBB1751)
Date: Tue, 18 Nov 2008 09:09:30 +0530
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 15/18] ath9k: Move TX completion routine to xmit.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, use a helper function to setup RC status data
when processing completed TX descriptors.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    2 -
 drivers/net/wireless/ath9k/main.c |   31 -------------
 drivers/net/wireless/ath9k/xmit.c |   88 +++++++++++++++++++++++-------------
 3 files changed, 56 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 0c34820..e672556 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -453,8 +453,6 @@ void ath_tx_tasklet(struct ath_softc *sc);
 u32 ath_txq_depth(struct ath_softc *sc, int qnum);
 u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum);
 void ath_notify_txq_status(struct ath_softc *sc, u16 queue_depth);
-void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-		     struct ath_xmit_status *tx_status);
 void ath_tx_cabq(struct ath_softc *sc, struct sk_buff *skb);
 
 /**********************/
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 28a24df..ee3eb99 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -342,37 +342,6 @@ void ath_get_beaconconfig(struct ath_softc *sc,
 	conf->bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf->listen_interval;
 }
 
-void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
-		     struct ath_xmit_status *tx_status)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
-
-	DPRINTF(sc, ATH_DBG_XMIT,
-		"%s: TX complete: skb: %p\n", __func__, skb);
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
-	ieee80211_tx_status(hw, skb);
-}
-
 /********************************/
 /*	 LED functions		*/
 /********************************/
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 93317ce..4c9a03e 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -102,6 +102,37 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	ath9k_hw_txstart(ah, txq->axq_qnum);
 }
 
+static void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
+			    struct ath_xmit_status *tx_status)
+{
+	struct ieee80211_hw *hw = sc->hw;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+
+	DPRINTF(sc, ATH_DBG_XMIT,
+		"%s: TX complete: skb: %p\n", __func__, skb);
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
+	ieee80211_tx_status(hw, skb);
+}
+
 /* Check if it's okay to send out aggregates */
 
 static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
@@ -913,18 +944,35 @@ static void ath_tx_complete_aggr_rifs(struct ath_softc *sc,
 	return;
 }
 
+static void ath_tx_rc_status(struct ath_buf *bf, struct ath_desc *ds, int nbad)
+{
+	struct sk_buff *skb = (struct sk_buff *)bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ath_tx_info_priv *tx_info_priv = ATH_TX_INFO_PRIV(tx_info);
+
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
+		}
+	}
+}
+
 /* Process completed xmit descriptors from the specified queue */
 
-static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
+static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	struct ath_buf *bf, *lastbf, *bf_held = NULL;
 	struct list_head bf_head;
-	struct ath_desc *ds, *tmp_ds;
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *tx_info;
-	struct ath_tx_info_priv *tx_info_priv;
-	int nacked, txok, nbad = 0, isrifs = 0;
+	struct ath_desc *ds;
+	int txok, nbad = 0;
 	int status;
 
 	DPRINTF(sc, ATH_DBG_QUEUE,
@@ -932,7 +980,6 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		txq->axq_qnum, ath9k_hw_gettxbuf(sc->sc_ah, txq->axq_qnum),
 		txq->axq_link);
 
-	nacked = 0;
 	for (;;) {
 		spin_lock_bh(&txq->axq_lock);
 		if (list_empty(&txq->axq_q)) {
@@ -1022,30 +1069,8 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		} else {
 			nbad = ath_tx_num_badfrms(sc, bf, txok);
 		}
-		skb = bf->bf_mpdu;
-		tx_info = IEEE80211_SKB_CB(skb);
-
-		tx_info_priv =
-			(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
-		if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
-			tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
-		if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
-				(bf->bf_flags & ATH9K_TXDESC_NOACK) == 0) {
-			if (ds->ds_txstat.ts_status == 0)
-				nacked++;
-
-			if (bf_isdata(bf)) {
-				if (isrifs)
-					tmp_ds = bf->bf_rifslast->bf_desc;
-				else
-					tmp_ds = ds;
-				memcpy(&tx_info_priv->tx,
-					&tmp_ds->ds_txstat,
-					sizeof(tx_info_priv->tx));
-				tx_info_priv->n_frames = bf->bf_nframes;
-				tx_info_priv->n_bad_frames = nbad;
-			}
-		}
+
+		ath_tx_rc_status(bf, ds, nbad);
 
 		/*
 		 * Complete this transmit unit
@@ -1076,7 +1101,6 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			ath_txq_schedule(sc, txq);
 		spin_unlock_bh(&txq->axq_lock);
 	}
-	return nacked;
 }
 
 static void ath_tx_stopdma(struct ath_softc *sc, struct ath_txq *txq)
-- 
1.6.0.3

