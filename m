Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11811 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab2HJLRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 07:17:12 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20516.60776.658911.764370@gargle.gargle.HOWL> (sfid-20120810_131717_018287_68E9EE85)
Date: Fri, 10 Aug 2012 16:45:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 01/15] ath9k: Simplify rate table initialization
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove various local variables that duplicate information
already stored in mac80211.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 65 ++++++++++---------------------------
 1 file changed, 17 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index e034add..2188d1b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1185,8 +1185,6 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 					     enum ieee80211_band band,
 					     bool is_ht)
 {
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
 	switch(band) {
 	case IEEE80211_BAND_2GHZ:
 		if (is_ht)
@@ -1197,7 +1195,6 @@ struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 			return &ar5416_11na_ratetable;
 		return &ar5416_11a_ratetable;
 	default:
-		ath_dbg(common, CONFIG, "Invalid band\n");
 		return NULL;
 	}
 }
@@ -1278,8 +1275,7 @@ static void ath_rc_init(struct ath_softc *sc,
 		ath_rc_priv->ht_cap);
 }
 
-static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
-			       bool is_cw40, bool is_sgi)
+static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	u8 caps = 0;
 
@@ -1289,9 +1285,10 @@ static u8 ath_rc_build_ht_caps(struct ath_softc *sc, struct ieee80211_sta *sta,
 			caps |= WLAN_RC_TS_FLAG | WLAN_RC_DS_FLAG;
 		else if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
-		if (is_cw40)
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
 			caps |= WLAN_RC_40_FLAG;
-		if (is_sgi)
+		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40 ||
+		    sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
 			caps |= WLAN_RC_SGI_FLAG;
 	}
 
@@ -1393,9 +1390,9 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
                           struct ieee80211_sta *sta, void *priv_sta)
 {
 	struct ath_softc *sc = priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	const struct ath_rate_table *rate_table;
-	bool is_cw40, is_sgi = false;
 	int i, j = 0;
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -1417,19 +1414,14 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
 
-	is_cw40 = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40);
-
-	if (is_cw40)
-		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40);
-	else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
-		is_sgi = !!(sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20);
-
-	/* Choose rate table first */
-
 	rate_table = ath_choose_rate_table(sc, sband->band,
-	                      sta->ht_cap.ht_supported);
+					   sta->ht_cap.ht_supported);
+	if (!rate_table) {
+		ath_err(common, "No rate table chosen\n");
+		return;
+	}
 
-	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi);
+	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 }
 
@@ -1440,39 +1432,16 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
 	const struct ath_rate_table *rate_table = NULL;
-	bool oper_cw40 = false, oper_sgi;
-	bool local_cw40 = !!(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG);
-	bool local_sgi = !!(ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG);
-
-	/* FIXME: Handle AP mode later when we support CWM */
 
 	if (changed & IEEE80211_RC_BW_CHANGED) {
-		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
-			return;
-
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-			oper_cw40 = true;
-
-		if (oper_cw40)
-			oper_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
-				   true : false;
-		else if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_SGI_20)
-			oper_sgi = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20) ?
-				   true : false;
-		else
-			oper_sgi = false;
-
-		if ((local_cw40 != oper_cw40) || (local_sgi != oper_sgi)) {
-			rate_table = ath_choose_rate_table(sc, sband->band,
+		rate_table = ath_choose_rate_table(sc, sband->band,
 						   sta->ht_cap.ht_supported);
-			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta,
-						   oper_cw40, oper_sgi);
-			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+		ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta);
+		ath_rc_init(sc, priv_sta, sband, sta, rate_table);
 
-			ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
-				"Operating HT Bandwidth changed to: %d\n",
-				sc->hw->conf.channel_type);
-		}
+		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
+			"Operating HT Bandwidth changed to: %d\n",
+			sc->hw->conf.channel_type);
 	}
 }
 
-- 
1.7.11.4

