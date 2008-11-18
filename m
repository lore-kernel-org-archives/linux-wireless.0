Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27862 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752882AbYKRDk0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 22:40:26 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 19:40:26 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18722.14458.73182.725632@gargle.gargle.HOWL> (sfid-20081118_044048_950440_97213BAF)
Date: Tue, 18 Nov 2008 09:07:30 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 11/18] ath9k: Use rate_driver_data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the hack using vif, and use rate_driver_data within
skb->cb to hold driver specific rate information.
Setup the rate series in the skb's tx control area and remove
all references to ath9k specific rate series ( using struct ath_rc_series ).

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 -
 drivers/net/wireless/ath9k/main.c |    9 +-
 drivers/net/wireless/ath9k/rc.c   |  145 ++++++++++++++-------------------
 drivers/net/wireless/ath9k/rc.h   |   17 ----
 drivers/net/wireless/ath9k/xmit.c |  162 ++++++++++---------------------------
 5 files changed, 108 insertions(+), 226 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index cf2d941..255f860 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -203,7 +203,6 @@ struct ath_buf_state {
 	int bfs_seqno;				/* sequence number */
 	int bfs_tidno;				/* tid of this frame */
 	int bfs_retries;			/* current retries */
-	struct ath_rc_series bfs_rcs[4];	/* rate series */
 	u32 bf_type;				/* BUF_* (enum buffer_type) */
 	/* key type use to encrypt this frame */
 	u32 bfs_keyix;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 7415c63..7ddb932 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -351,13 +351,12 @@ void ath_tx_complete(struct ath_softc *sc, struct sk_buff *skb,
 	DPRINTF(sc, ATH_DBG_XMIT,
 		"%s: TX complete: skb: %p\n", __func__, skb);
 
-	ieee80211_tx_info_clear_status(tx_info);
 	if (tx_info->flags & IEEE80211_TX_CTL_NO_ACK ||
 		tx_info->flags & IEEE80211_TX_STAT_TX_FILTERED) {
-		/* free driver's private data area of tx_info, XXX: HACK! */
-		if (tx_info->control.vif != NULL)
-			kfree(tx_info->control.vif);
-			tx_info->control.vif = NULL;
+		if (tx_info->rate_driver_data[0] != NULL) {
+			kfree(tx_info->rate_driver_data[0]);
+			tx_info->rate_driver_data[0] = NULL;
+		}
 	}
 
 	if (tx_status->flags & ATH_TX_BAR) {
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 59c146c..156b245 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -805,22 +805,22 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
 }
 
 static void ath_rc_rate_set_series(struct ath_rate_table *rate_table ,
-				   struct ath_rc_series *series,
+				   struct ieee80211_tx_rate *rate,
 				   u8 tries,
 				   u8 rix,
 				   int rtsctsenable)
 {
-	series->tries = tries;
-	series->flags = (rtsctsenable ? ATH_RC_RTSCTS_FLAG : 0) |
-		(WLAN_RC_PHY_DS(rate_table->info[rix].phy) ?
-		 ATH_RC_DS_FLAG : 0) |
-		(WLAN_RC_PHY_40(rate_table->info[rix].phy) ?
-		 ATH_RC_CW40_FLAG : 0) |
-		(WLAN_RC_PHY_SGI(rate_table->info[rix].phy) ?
-		 ATH_RC_SGI_FLAG : 0);
-
-	series->rix = rate_table->info[rix].base_index;
-	series->max_4ms_framelen = rate_table->info[rix].max_4ms_framelen;
+	rate->count = tries;
+	rate->idx = rix;
+
+	if (rtsctsenable)
+		rate->flags |= IEEE80211_TX_RC_USE_RTS_CTS;
+	if (WLAN_RC_PHY_40(rate_table->info[rix].phy))
+		rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+	if (WLAN_RC_PHY_SGI(rate_table->info[rix].phy))
+		rate->flags |= IEEE80211_TX_RC_SHORT_GI;
+	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy))
+		rate->flags |= IEEE80211_TX_RC_MCS;
 }
 
 static u8 ath_rc_rate_getidx(struct ath_softc *sc,
@@ -855,11 +855,12 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 static void ath_rc_ratefind(struct ath_softc *sc,
 			    struct ath_rate_node *ath_rc_priv,
 			    int num_tries, int num_rates, unsigned int rcflag,
-			    struct ath_rc_series series[], int *is_probe,
+			    struct ieee80211_tx_info *tx_info, int *is_probe,
 			    int is_retry)
 {
 	u8 try_per_rate = 0, i = 0, rix, nrix;
 	struct ath_rate_table *rate_table;
+	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 
 	rate_table = sc->hw_rate_table[sc->sc_curmode];
 	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table,
@@ -871,7 +872,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		/* set one try for probe rates. For the
 		 * probes don't enable rts */
 		ath_rc_rate_set_series(rate_table,
-			&series[i++], 1, nrix, FALSE);
+			&rates[i++], 1, nrix, FALSE);
 
 		try_per_rate = (num_tries/num_rates);
 		/* Get the next tried/allowed rate. No RTS for the next series
@@ -880,12 +881,12 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		nrix = ath_rc_rate_getidx(sc,
 			ath_rc_priv, rate_table, nrix, 1, FALSE);
 		ath_rc_rate_set_series(rate_table,
-			&series[i++], try_per_rate, nrix, 0);
+			&rates[i++], try_per_rate, nrix, 0);
 	} else {
 		try_per_rate = (num_tries/num_rates);
 		/* Set the choosen rate. No RTS for first series entry. */
 		ath_rc_rate_set_series(rate_table,
-			&series[i++], try_per_rate, nrix, FALSE);
+			&rates[i++], try_per_rate, nrix, FALSE);
 	}
 
 	/* Fill in the other rates for multirate retry */
@@ -902,7 +903,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 					  rate_table, nrix, 1, min_rate);
 		/* All other rates in the series have RTS enabled */
 		ath_rc_rate_set_series(rate_table,
-				       &series[i], try_num, nrix, TRUE);
+				       &rates[i], try_num, nrix, TRUE);
 	}
 
 	/*
@@ -928,9 +929,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 		if (i == 4 &&
 		    ((dot11rate == 2 && phy == WLAN_RC_PHY_HT_40_SS) ||
 		     (dot11rate == 3 && phy == WLAN_RC_PHY_HT_20_SS))) {
-			series[3].rix = series[2].rix;
-			series[3].flags = series[2].flags;
-			series[3].max_4ms_framelen = series[2].max_4ms_framelen;
+			rates[3].idx = rates[2].idx;
+			rates[3].flags = rates[2].flags;
 		}
 	}
 }
@@ -943,7 +943,7 @@ static void ath_rate_findrate(struct ath_softc *sc,
 			      int num_tries,
 			      int num_rates,
 			      unsigned int rcflag,
-			      struct ath_rc_series series[],
+			      struct ieee80211_tx_info *tx_info,
 			      int *is_probe,
 			      int is_retry)
 {
@@ -951,7 +951,7 @@ static void ath_rate_findrate(struct ath_softc *sc,
 		return;
 
 	ath_rc_ratefind(sc, ath_rc_priv, num_tries, num_rates,
-			rcflag, series, is_probe, is_retry);
+			rcflag, tx_info, is_probe, is_retry);
 }
 
 static void ath_rc_update_ht(struct ath_softc *sc,
@@ -1283,17 +1283,17 @@ static void ath_rc_update_ht(struct ath_softc *sc,
  */
 static void ath_rc_update(struct ath_softc *sc,
 			  struct ath_rate_node *ath_rc_priv,
-			  struct ath_tx_info_priv *info_priv, int final_ts_idx,
+			  struct ieee80211_tx_info *tx_info, int final_ts_idx,
 			  int xretries, int long_retry)
 {
+	struct ath_tx_info_priv *info_priv =
+		(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
 	struct ath_rate_table *rate_table;
-	struct ath_rc_series rcs[4];
+	struct ieee80211_tx_rate *rates = tx_info->status.rates;
 	u8 flags;
 	u32 series = 0, rix;
 
-	memcpy(rcs, info_priv->rcs, 4 * sizeof(rcs[0]));
 	rate_table = sc->hw_rate_table[sc->sc_curmode];
-	ASSERT(rcs[0].tries != 0);
 
 	/*
 	 * If the first rate is not the final index, there
@@ -1302,31 +1302,31 @@ static void ath_rc_update(struct ath_softc *sc,
 	if (final_ts_idx != 0) {
 		/* Process intermediate rates that failed.*/
 		for (series = 0; series < final_ts_idx ; series++) {
-			if (rcs[series].tries != 0) {
-				flags = rcs[series].flags;
+			if (rates[series].count != 0) {
+				flags = rates[series].flags;
 				/* If HT40 and we have switched mode from
 				 * 40 to 20 => don't update */
-				if ((flags & ATH_RC_CW40_FLAG) &&
+				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
 					(ath_rc_priv->rc_phy_mode !=
-					(flags & ATH_RC_CW40_FLAG)))
+					(flags & IEEE80211_TX_RC_40_MHZ_WIDTH)))
 					return;
-				if ((flags & ATH_RC_CW40_FLAG) &&
-					(flags & ATH_RC_SGI_FLAG))
+				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+					(flags & IEEE80211_TX_RC_SHORT_GI))
 					rix = rate_table->info[
-						rcs[series].rix].ht_index;
-				else if (flags & ATH_RC_SGI_FLAG)
+						rates[series].idx].ht_index;
+				else if (flags & IEEE80211_TX_RC_SHORT_GI)
 					rix = rate_table->info[
-						rcs[series].rix].sgi_index;
-				else if (flags & ATH_RC_CW40_FLAG)
+						rates[series].idx].sgi_index;
+				else if (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 					rix = rate_table->info[
-						rcs[series].rix].cw40index;
+						rates[series].idx].cw40index;
 				else
 					rix = rate_table->info[
-						rcs[series].rix].base_index;
+						rates[series].idx].base_index;
 				ath_rc_update_ht(sc, ath_rc_priv,
 						info_priv, rix,
 						xretries ? 1 : 2,
-						rcs[series].tries);
+						rates[series].count);
 			}
 		}
 	} else {
@@ -1336,24 +1336,24 @@ static void ath_rc_update(struct ath_softc *sc,
 		 * Treating it as an excessive retry penalizes the rate
 		 * inordinately.
 		 */
-		if (rcs[0].tries == 1 && xretries == 1)
+		if (rates[0].count == 1 && xretries == 1)
 			xretries = 2;
 	}
 
-	flags = rcs[series].flags;
+	flags = rates[series].flags;
 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
-	if ((flags & ATH_RC_CW40_FLAG) &&
-		(ath_rc_priv->rc_phy_mode != (flags & ATH_RC_CW40_FLAG)))
+	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
+		(ath_rc_priv->rc_phy_mode != (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)))
 		return;
 
-	if ((flags & ATH_RC_CW40_FLAG) && (flags & ATH_RC_SGI_FLAG))
-		rix = rate_table->info[rcs[series].rix].ht_index;
-	else if (flags & ATH_RC_SGI_FLAG)
-		rix = rate_table->info[rcs[series].rix].sgi_index;
-	else if (flags & ATH_RC_CW40_FLAG)
-		rix = rate_table->info[rcs[series].rix].cw40index;
+	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) && (flags & IEEE80211_TX_RC_SHORT_GI))
+		rix = rate_table->info[rates[series].idx].ht_index;
+	else if (flags & IEEE80211_TX_RC_SHORT_GI)
+		rix = rate_table->info[rates[series].idx].sgi_index;
+	else if (flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+		rix = rate_table->info[rates[series].idx].cw40index;
 	else
-		rix = rate_table->info[rcs[series].rix].base_index;
+		rix = rate_table->info[rates[series].idx].base_index;
 
 	ath_rc_update_ht(sc, ath_rc_priv, info_priv, rix,
 		xretries, long_retry);
@@ -1365,8 +1365,10 @@ static void ath_rc_update(struct ath_softc *sc,
 static void ath_rate_tx_complete(struct ath_softc *sc,
 				 struct ath_node *an,
 				 struct ath_rate_node *rc_priv,
-				 struct ath_tx_info_priv *info_priv)
+				 struct ieee80211_tx_info *tx_info)
 {
+	struct ath_tx_info_priv *info_priv =
+		(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
 	int final_ts_idx = info_priv->tx.ts_rateindex;
 	int tx_status = 0, is_underrun = 0;
 
@@ -1395,7 +1397,7 @@ static void ath_rate_tx_complete(struct ath_softc *sc,
 			(info_priv->tx.ts_status & ATH9K_TXERR_FIFO))
 		tx_status = 1;
 
-	ath_rc_update(sc, rc_priv, info_priv, final_ts_idx, tx_status,
+	ath_rc_update(sc, rc_priv, tx_info, final_ts_idx, tx_status,
 		      (is_underrun) ? ATH_11N_TXMAXTRY :
 		      info_priv->tx.ts_longretry);
 }
@@ -1507,8 +1509,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
-	/* XXX: UGLY HACK!! */
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
+	tx_info_priv = (struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
 
 	an = (struct ath_node *)sta->drv_priv;
 
@@ -1516,10 +1517,9 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		return;
 
 	if (an && priv_sta && ieee80211_is_data(fc))
-		ath_rate_tx_complete(sc, an, priv_sta, tx_info_priv);
+		ath_rate_tx_complete(sc, an, priv_sta, tx_info);
 
 	kfree(tx_info_priv);
-	tx_info->control.vif = NULL;
 }
 
 static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
@@ -1530,28 +1530,18 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_softc *sc = priv;
 	struct ieee80211_hw *hw = sc->hw;
-	struct ath_tx_info_priv *tx_info_priv;
 	struct ath_rate_node *ath_rc_priv = priv_sta;
 	struct ath_node *an;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	int is_probe = FALSE;
-	s8 lowest_idx;
 	__le16 fc = hdr->frame_control;
 	u8 *qc, tid;
 
-	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
-
-	/* allocate driver private area of tx_info, XXX: UGLY HACK! */
-	tx_info->control.vif = kzalloc(sizeof(*tx_info_priv), GFP_ATOMIC);
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
-	ASSERT(tx_info_priv != NULL);
-
-	lowest_idx = rate_lowest_index(sband, sta);
-	tx_info_priv->min_rate = (sband->bitrates[lowest_idx].bitrate * 2) / 10;
 	/* lowest rate for management and multicast/broadcast frames */
-	if (!ieee80211_is_data(fc) ||
-	    is_multicast_ether_addr(hdr->addr1) || !sta) {
-		tx_info->control.rates[0].idx = lowest_idx;
+	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1)) {
+		tx_info->control.rates[0].idx = rate_lowest_index(sband, sta);
+		tx_info->control.rates[0].count =
+			is_multicast_ether_addr(hdr->addr1) ? 1 : ATH_MGT_TXMAXTRY;
 		return;
 	}
 
@@ -1559,24 +1549,11 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	ath_rate_findrate(sc, ath_rc_priv,
 			  ATH_11N_TXMAXTRY, 4,
 			  ATH_RC_PROBE_ALLOWED,
-			  tx_info_priv->rcs,
+			  tx_info,
 			  &is_probe,
 			  false);
-#if 0
-	if (is_probe)
-		sel->probe_idx = ath_rc_priv->tx_ratectrl.probe_rate;
-#endif
-
-	/* Ratecontrol sometimes returns invalid rate index */
-	if (tx_info_priv->rcs[0].rix != 0xff)
-		ath_rc_priv->prev_data_rix = tx_info_priv->rcs[0].rix;
-	else
-		tx_info_priv->rcs[0].rix = ath_rc_priv->prev_data_rix;
-
-	tx_info->control.rates[0].idx = tx_info_priv->rcs[0].rix;
 
 	/* Check if aggregation has to be enabled for this tid */
-
 	if (hw->conf.ht.enabled) {
 		if (ieee80211_is_data_qos(fc)) {
 			qc = ieee80211_get_qos_ctl(hdr);
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index 30248de..3324bed 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -169,20 +169,6 @@ struct ath_rate_table {
 #define ATH_RC_PROBE_ALLOWED            0x00000001
 #define ATH_RC_MINRATE_LASTRATE         0x00000002
 
-struct ath_rc_series {
-	u8 rix;
-	u8 tries;
-	u8 flags;
-	u32 max_4ms_framelen;
-};
-
-/* rcs_flags definition */
-#define ATH_RC_DS_FLAG               0x01
-#define ATH_RC_CW40_FLAG             0x02    /* CW 40 */
-#define ATH_RC_SGI_FLAG              0x04    /* Short Guard Interval */
-#define ATH_RC_HT_FLAG               0x08    /* HT */
-#define ATH_RC_RTSCTS_FLAG           0x10    /* RTS-CTS */
-
 /*
  * State structures for new rate adaptation code
  */
@@ -259,13 +245,10 @@ struct ath_rate_node {
 	struct ath_rate_softc *asc;
 };
 
-/* Driver data of ieee80211_tx_info */
 struct ath_tx_info_priv {
-	struct ath_rc_series rcs[4];
 	struct ath_tx_status tx;
 	int n_frames;
 	int n_bad_frames;
-	u8 min_rate;
 };
 
 void ath_rate_attach(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 44735b6..baf5cb9 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -102,23 +102,6 @@ static void ath_tx_txqaddbuf(struct ath_softc *sc, struct ath_txq *txq,
 	ath9k_hw_txstart(ah, txq->axq_qnum);
 }
 
-/* Get transmit rate index using rate in Kbps */
-
-static int ath_tx_findindex(const struct ath9k_rate_table *rt, int rate)
-{
-	int i;
-	int ndx = 0;
-
-	for (i = 0; i < rt->rateCount; i++) {
-		if (rt->info[i].rateKbps == rate) {
-			ndx = i;
-			break;
-		}
-	}
-
-	return ndx;
-}
-
 /* Check if it's okay to send out aggregates */
 
 static int ath_aggr_query(struct ath_softc *sc, struct ath_node *an, u8 tidno)
@@ -158,26 +141,23 @@ static enum ath9k_pkt_type get_hw_packet_type(struct sk_buff *skb)
 	return htype;
 }
 
-static bool check_min_rate(struct sk_buff *skb)
+static bool is_pae(struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
-	bool use_minrate = false;
 	__le16 fc;
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
 
-	if (ieee80211_is_mgmt(fc) || ieee80211_is_ctl(fc)) {
-		use_minrate = true;
-	} else if (ieee80211_is_data(fc)) {
+	if (ieee80211_is_data(fc)) {
 		if (ieee80211_is_nullfunc(fc) ||
 		    /* Port Access Entity (IEEE 802.1X) */
 		    (skb->protocol == cpu_to_be16(ETH_P_PAE))) {
-			use_minrate = true;
+			return true;
 		}
 	}
 
-	return use_minrate;
+	return false;
 }
 
 static int get_hw_crypto_keytype(struct sk_buff *skb)
@@ -199,50 +179,19 @@ static int get_hw_crypto_keytype(struct sk_buff *skb)
 static void setup_rate_retries(struct ath_softc *sc, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	struct ath_tx_info_priv *tx_info_priv;
-	struct ath_rc_series *rcs;
+	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 	struct ieee80211_hdr *hdr;
-	const struct ath9k_rate_table *rt;
-	bool use_minrate;
 	__le16 fc;
-	u8 rix;
-
-	rt = sc->sc_currates;
-	BUG_ON(!rt);
 
 	hdr = (struct ieee80211_hdr *)skb->data;
 	fc = hdr->frame_control;
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif; /* HACK */
-	rcs = tx_info_priv->rcs;
-
-	/* Check if min rates have to be used */
-	use_minrate = check_min_rate(skb);
-
-	if (ieee80211_is_data(fc) && !use_minrate) {
-		if (is_multicast_ether_addr(hdr->addr1)) {
-			rcs[0].rix =
-				ath_tx_findindex(rt, tx_info_priv->min_rate);
-			/* mcast packets are not re-tried */
-			rcs[0].tries = 1;
-		}
-	} else {
-		/* for management and control frames,
-		   or for NULL and EAPOL frames */
-		if (use_minrate)
-			rcs[0].rix = ath_rate_findrateix(sc, tx_info_priv->min_rate);
-		else
-			rcs[0].rix = 0;
-		rcs[0].tries = ATH_MGT_TXMAXTRY;
-	}
-
-	rix = rcs[0].rix;
 
 	if (ieee80211_has_morefrags(fc) ||
 	    (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
-		rcs[1].tries = rcs[2].tries = rcs[3].tries = 0;
-		rcs[1].rix = rcs[2].rix = rcs[3].rix = 0;
+		rates[1].count = rates[2].count = rates[3].count = 0;
+		rates[1].idx = rates[2].idx = rates[3].idx = 0;
 		/* reset tries but keep rate index */
-		rcs[0].tries = ATH_TXMAXTRY;
+		rates[0].count = ATH_TXMAXTRY;
 	}
 }
 
@@ -274,7 +223,7 @@ static void assign_aggr_tid_seqno(struct sk_buff *skb,
 
 	/* Get seqno */
 
-	if (ieee80211_is_data(fc) && !check_min_rate(skb)) {
+	if (ieee80211_is_data(fc) && !is_pae(skb)) {
 		/* For HT capable stations, we save tidno for later use.
 		 * We also override seqno set by upper layer with the one
 		 * in tx aggregation state.
@@ -573,9 +522,11 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_node *an = NULL;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rates;
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
+	rates = tx_info->rate_driver_data[0];
 
 	if (tx_info->control.sta)
 		an = (struct ath_node *)tx_info->control.sta->drv_priv;
@@ -584,9 +535,9 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	 * get the cix for the lowest valid rix.
 	 */
 	rt = sc->sc_currates;
-	for (i = 4; i--;) {
-		if (bf->bf_rcs[i].tries) {
-			rix = bf->bf_rcs[i].rix;
+	for (i = 3; i >= 0; i--) {
+		if (rates[i].count) {
+			rix = rates[i].idx;
 			break;
 		}
 	}
@@ -662,27 +613,27 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	memset(series, 0, sizeof(struct ath9k_11n_rate_series) * 4);
 
 	for (i = 0; i < 4; i++) {
-		if (!bf->bf_rcs[i].tries)
+		if (!rates[i].count)
 			continue;
 
-		rix = bf->bf_rcs[i].rix;
+		rix = rates[i].idx;
 
 		series[i].Rate = rt->info[rix].rateCode |
 			(bf_isshpreamble(bf) ? rt->info[rix].shortPreamble : 0);
 
-		series[i].Tries = bf->bf_rcs[i].tries;
+		series[i].Tries = rates[i].count;
 
 		series[i].RateFlags = (
-			(bf->bf_rcs[i].flags & ATH_RC_RTSCTS_FLAG) ?
+			(rates[i].flags & IEEE80211_TX_RC_USE_RTS_CTS) ?
 				ATH9K_RATESERIES_RTS_CTS : 0) |
-			((bf->bf_rcs[i].flags & ATH_RC_CW40_FLAG) ?
+			((rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
 				ATH9K_RATESERIES_2040 : 0) |
-			((bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG) ?
+			((rates[i].flags & IEEE80211_TX_RC_SHORT_GI) ?
 				ATH9K_RATESERIES_HALFGI : 0);
 
 		series[i].PktDuration = ath_pkt_duration(sc, rix, bf,
-			 (bf->bf_rcs[i].flags & ATH_RC_CW40_FLAG) != 0,
-			 (bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
+			 (rates[i].flags & IEEE80211_TX_RC_40_MHZ_WIDTH) != 0,
+			 (rates[i].flags & IEEE80211_TX_RC_SHORT_GI),
 			 bf_isshpreamble(bf));
 
 		if (bf_isht(bf) && an)
@@ -718,22 +669,12 @@ static int ath_tx_send_normal(struct ath_softc *sc,
 			      struct list_head *bf_head)
 {
 	struct ath_buf *bf;
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *tx_info;
-	struct ath_tx_info_priv *tx_info_priv;
 
 	BUG_ON(list_empty(bf_head));
 
 	bf = list_first_entry(bf_head, struct ath_buf, list);
 	bf->bf_state.bf_type &= ~BUF_AMPDU; /* regular HT frame */
 
-	skb = (struct sk_buff *)bf->bf_mpdu;
-	tx_info = IEEE80211_SKB_CB(skb);
-
-	/* XXX: HACK! */
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
-	memcpy(bf->bf_rcs, tx_info_priv->rcs, 4 * sizeof(tx_info_priv->rcs[0]));
-
 	/* update starting sequence number for subsequent ADDBA request */
 	INCR(tid->seq_start, IEEE80211_SEQ_MAX);
 
@@ -1124,8 +1065,8 @@ static int ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 		skb = bf->bf_mpdu;
 		tx_info = IEEE80211_SKB_CB(skb);
 
-		/* XXX: HACK! */
-		tx_info_priv = (struct ath_tx_info_priv *) tx_info->control.vif;
+		tx_info_priv =
+			(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
 		if (ds->ds_txstat.ts_status & ATH9K_TXERR_FILT)
 			tx_info->flags |= IEEE80211_TX_STAT_TX_FILTERED;
 		if ((ds->ds_txstat.ts_status & ATH9K_TXERR_FILT) == 0 &&
@@ -1268,9 +1209,6 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 			     struct ath_tx_control *txctl)
 {
 	struct ath_buf *bf;
-	struct sk_buff *skb;
-	struct ieee80211_tx_info *tx_info;
-	struct ath_tx_info_priv *tx_info_priv;
 
 	BUG_ON(list_empty(bf_head));
 
@@ -1296,12 +1234,6 @@ static int ath_tx_send_ampdu(struct ath_softc *sc,
 		return 0;
 	}
 
-	skb = (struct sk_buff *)bf->bf_mpdu;
-	tx_info = IEEE80211_SKB_CB(skb);
-	/* XXX: HACK! */
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
-	memcpy(bf->bf_rcs, tx_info_priv->rcs, 4 * sizeof(tx_info_priv->rcs[0]));
-
 	/* Add sub-frame to BAW */
 	ath_tx_addto_baw(sc, tid, bf);
 
@@ -1323,9 +1255,11 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 			   struct ath_buf *bf,
 			   struct ath_atx_tid *tid)
 {
+	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
 	const struct ath9k_rate_table *rt = sc->sc_currates;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *rates;
 	struct ath_tx_info_priv *tx_info_priv;
 	u32 max_4ms_framelen, frame_length;
 	u16 aggr_limit, legacy = 0, maxampdu;
@@ -1333,10 +1267,9 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 
 	skb = (struct sk_buff *)bf->bf_mpdu;
 	tx_info = IEEE80211_SKB_CB(skb);
-	tx_info_priv = (struct ath_tx_info_priv *)
-		tx_info->control.vif; /* XXX: HACK! */
-	memcpy(bf->bf_rcs,
-		tx_info_priv->rcs, 4 * sizeof(tx_info_priv->rcs[0]));
+	rates = tx_info->control.rates;
+	tx_info_priv =
+		(struct ath_tx_info_priv *)tx_info->rate_driver_data[0];
 
 	/*
 	 * Find the lowest frame length among the rate series that will have a
@@ -1346,14 +1279,14 @@ static u32 ath_lookup_rate(struct ath_softc *sc,
 	max_4ms_framelen = ATH_AMPDU_LIMIT_MAX;
 
 	for (i = 0; i < 4; i++) {
-		if (bf->bf_rcs[i].tries) {
-			frame_length = bf->bf_rcs[i].max_4ms_framelen;
-
-			if (rt->info[bf->bf_rcs[i].rix].phy != PHY_HT) {
+		if (rates[i].count) {
+			if (rt->info[rates[i].idx].phy != PHY_HT) {
 				legacy = 1;
 				break;
 			}
 
+			frame_length =
+				rate_table->info[rates[i].idx].max_4ms_framelen;
 			max_4ms_framelen = min(max_4ms_framelen, frame_length);
 		}
 	}
@@ -1393,6 +1326,8 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 				  u16 frmlen)
 {
 	const struct ath9k_rate_table *rt = sc->sc_currates;
+	struct sk_buff *skb = bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	u32 nsymbits, nsymbols, mpdudensity;
 	u16 minlen;
 	u8 rc, flags, rix;
@@ -1425,11 +1360,11 @@ static int ath_compute_num_delims(struct ath_softc *sc,
 	if (mpdudensity == 0)
 		return ndelim;
 
-	rix = bf->bf_rcs[0].rix;
-	flags = bf->bf_rcs[0].flags;
+	rix = tx_info->control.rates[0].idx;
+	flags = tx_info->control.rates[0].flags;
 	rc = rt->info[rix].rateCode;
-	width = (flags & ATH_RC_CW40_FLAG) ? 1 : 0;
-	half_gi = (flags & ATH_RC_SGI_FLAG) ? 1 : 0;
+	width = (flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ? 1 : 0;
+	half_gi = (flags & IEEE80211_TX_RC_SHORT_GI) ? 1 : 0;
 
 	if (half_gi)
 		nsymbols = NUM_SYMBOLS_PER_USEC_HALFGI(mpdudensity);
@@ -1471,7 +1406,7 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 	u16 aggr_limit = 0, al = 0, bpad = 0,
 		al_delta, h_baw = tid->baw_size / 2;
 	enum ATH_AGGR_STATUS status = ATH_AGGR_DONE;
-	int prev_al = 0, is_ds_rate = 0;
+	int prev_al = 0;
 	INIT_LIST_HEAD(&bf_head);
 
 	BUG_ON(list_empty(&tid->buf_q));
@@ -1492,11 +1427,6 @@ static enum ATH_AGGR_STATUS ath_tx_form_aggr(struct ath_softc *sc,
 		if (!rl) {
 			aggr_limit = ath_lookup_rate(sc, bf, tid);
 			rl = 1;
-			/*
-			 * Is rate dual stream
-			 */
-			is_ds_rate =
-				(bf->bf_rcs[0].flags & ATH_RC_DS_FLAG) ? 1 : 0;
 		}
 
 		/*
@@ -1739,14 +1669,13 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ath_tx_info_priv *tx_info_priv;
-	struct ath_rc_series *rcs;
 	int hdrlen;
 	__le16 fc;
 
-	tx_info_priv = (struct ath_tx_info_priv *)tx_info->control.vif;
+	tx_info_priv = kzalloc(sizeof(*tx_info_priv), GFP_KERNEL);
+	tx_info->rate_driver_data[0] = tx_info_priv;
 	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
 	fc = hdr->frame_control;
-	rcs = tx_info_priv->rcs;
 
 	ATH_TXBUF_RESET(bf);
 
@@ -1766,7 +1695,7 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 	(sc->sc_flags & SC_OP_PREAMBLE_SHORT) ?
 		(bf->bf_state.bf_type |= BUF_SHORT_PREAMBLE) :
 		(bf->bf_state.bf_type &= ~BUF_SHORT_PREAMBLE);
-	(sc->hw->conf.ht.enabled &&
+	(sc->hw->conf.ht.enabled && !is_pae(skb) &&
 	 (tx_info->flags & IEEE80211_TX_CTL_AMPDU)) ?
 		(bf->bf_state.bf_type |= BUF_HT) :
 		(bf->bf_state.bf_type &= ~BUF_HT);
@@ -1788,11 +1717,6 @@ static void ath_tx_setup_buffer(struct ath_softc *sc, struct ath_buf *bf,
 
 	setup_rate_retries(sc, skb);
 
-	bf->bf_rcs[0] = rcs[0];
-	bf->bf_rcs[1] = rcs[1];
-	bf->bf_rcs[2] = rcs[2];
-	bf->bf_rcs[3] = rcs[3];
-
 	/* Assign seqno, tidno */
 
 	if (bf_isht(bf) && (sc->sc_flags & SC_OP_TXAGGR))
-- 
1.6.0.3

