Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58175 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069AbZGOAO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:14:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: [PATCH 04/21] ath9k: cleanup try count for MRR in rate control
Date: Tue, 14 Jul 2009 20:13:56 -0400
Message-Id: <1247616853-11221-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
References: <1247616853-11221-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has no functional change and just cleans up the code
to be more legible and removes a useless variable for
Multi Rate Retry.

For regular frames we use 2 retries for MRR segments [0-2].
For the last MRR segment [3] we use 4.

MRR[0] = 2
MRR[1] = 2
MRR[2] = 2
MRR[3] = 4

Cc: Derek Smithies <derek@indranet.co.nz>
Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/rc.c    |   29 ++++++++++++++++++++---------
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index eb9d522..3afd7ee 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -164,7 +164,6 @@ void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
 #define WME_NUM_TID             16
 #define ATH_TXBUF               512
 #define ATH_TXMAXTRY            13
-#define ATH_11N_TXMAXTRY        10
 #define ATH_MGT_TXMAXTRY        4
 #define WME_BA_BMP_SIZE         64
 #define WME_MAX_BA              WME_BA_BMP_SIZE
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 961b0ce..19df788 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1540,7 +1540,8 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
 	hw->max_listen_interval = 10;
-	hw->max_rate_tries = ATH_11N_TXMAXTRY;
+	/* Hardware supports 10 but we use 4 */
+	hw->max_rate_tries = 4;
 	hw->sta_data_size = sizeof(struct ath_node);
 	hw->vif_data_size = sizeof(struct ath_vif);
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index d7f4030..a23b66b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -853,9 +853,21 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	__le16 fc = hdr->frame_control;
-	u8 try_per_rate = 0, i = 0, rix, nrix;
+	u8 try_per_rate, i = 0, rix, nrix;
 	int is_probe = 0;
 
+	/*
+	 * For Multi Rate Retry we use a different number of
+	 * retry attempt counts. This ends up looking like this:
+	 *
+	 * MRR[0] = 2
+	 * MRR[1] = 2
+	 * MRR[2] = 2
+	 * MRR[3] = 4
+	 *
+	 */
+	try_per_rate = sc->hw->max_rate_tries;
+
 	rate_table = sc->cur_rate_table;
 	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, &is_probe);
 	nrix = rix;
@@ -866,7 +878,6 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       1, nrix, 0);
 
-		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Get the next tried/allowed rate. No RTS for the next series
 		 * after the probe rate
 		 */
@@ -877,7 +888,6 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 
 		tx_info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
 	} else {
-		try_per_rate = (ATH_11N_TXMAXTRY/4);
 		/* Set the choosen rate. No RTS for first series entry. */
 		ath_rc_rate_set_series(rate_table, &rates[i++], txrc,
 				       try_per_rate, nrix, 0);
@@ -885,18 +895,19 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 
 	/* Fill in the other rates for multirate retry */
 	for ( ; i < 4; i++) {
-		u8 try_num;
 		u8 min_rate;
 
-		try_num = ((i + 1) == 4) ?
-			ATH_11N_TXMAXTRY - (try_per_rate * i) : try_per_rate ;
+		/* Use twice the number of tries for the last MRR segment. */
+		if (i + 1 == 4)
+			try_per_rate = 4;
+
 		min_rate = (((i + 1) == 4) && 0);
 
 		nrix = ath_rc_rate_getidx(sc, ath_rc_priv,
 					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table, &rates[i], txrc,
-				       try_num, nrix, 1);
+				       try_per_rate, nrix, 1);
 	}
 
 	/*
@@ -1529,7 +1540,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	/*
 	 * If underrun error is seen assume it as an excessive retry only
 	 * if prefetch trigger level have reached the max (0x3f for 5416)
-	 * Adjust the long retry as if the frame was tried ATH_11N_TXMAXTRY
+	 * Adjust the long retry as if the frame was tried hw->max_rate_tries
 	 * times. This affects how ratectrl updates PER for the failed rate.
 	 */
 	if (tx_info_priv->tx.ts_flags &
@@ -1544,7 +1555,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		tx_status = 1;
 
 	ath_rc_tx_status(sc, ath_rc_priv, tx_info, final_ts_idx, tx_status,
-			 (is_underrun) ? ATH_11N_TXMAXTRY :
+			 (is_underrun) ? sc->hw->max_rate_tries :
 			 tx_info_priv->tx.ts_longretry);
 
 	/* Check if aggregation has to be enabled for this tid */
-- 
1.6.0.6

