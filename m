Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23804 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763AbZCBIDt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 03:03:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2009 00:03:48 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18859.37361.925333.366362@gargle.gargle.HOWL> (sfid-20090302_090351_941884_7CB07E66)
Date: Mon, 2 Mar 2009 13:29:45 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Fill in rate_update mac80211 callback
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This callback can be used to handle dynamic 20/40,
and changes in the operating channel's HT parameters.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |  121 +++++++++++++++++++++++++++++---------
 1 files changed, 92 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 18d19c3..6d7e636 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1387,42 +1387,18 @@ static struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 static void ath_rc_init(struct ath_softc *sc,
 			struct ath_rate_priv *ath_rc_priv,
 			struct ieee80211_supported_band *sband,
-			struct ieee80211_sta *sta)
+			struct ieee80211_sta *sta,
+			struct ath_rate_table *rate_table)
 {
-	struct ath_rate_table *rate_table = NULL;
 	struct ath_rateset *rateset = &ath_rc_priv->neg_rates;
 	u8 *ht_mcs = (u8 *)&ath_rc_priv->neg_ht_rates;
 	u8 i, j, k, hi = 0, hthi = 0;
-	struct ath_hw *ah = sc->sc_ah;
-
-	/* FIXME: Adhoc */
-	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) ||
-	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)) {
-		bool is_cw_40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
-		rate_table = ath_choose_rate_table(sc, sband->band,
-						   sta->ht_cap.ht_supported,
-						   is_cw_40);
-	} else if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
-		/* cur_rate_table would be set on init through config() */
-		rate_table = sc->cur_rate_table;
-	}
 
 	if (!rate_table) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Rate table not initialized\n");
 		return;
 	}
 
-	if (sta->ht_cap.ht_supported) {
-		ath_rc_priv->ht_cap = WLAN_RC_HT_FLAG;
-		if (sc->sc_ah->caps.tx_chainmask != 1 &&
-			ath9k_hw_getcapability(ah, ATH9K_CAP_DS, 0, NULL))
-			ath_rc_priv->ht_cap |= WLAN_RC_DS_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40)
-			ath_rc_priv->ht_cap |= WLAN_RC_40_FLAG;
-		if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
-			ath_rc_priv->ht_cap |= WLAN_RC_SGI_FLAG;
-	}
-
 	/* Initial rate table size. Will change depending
 	 * on the working rate set */
 	ath_rc_priv->rate_table_size = RATE_TABLE_SIZE;
@@ -1442,7 +1418,7 @@ static void ath_rc_init(struct ath_softc *sc,
 			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
 		ath_rc_priv->valid_phy_ratecnt[i] = 0;
 	}
-	ath_rc_priv->rc_phy_mode = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG);
+	ath_rc_priv->rc_phy_mode = ath_rc_priv->ht_cap & WLAN_RC_40_FLAG;
 
 	/* Set stream capability */
 	ath_rc_priv->single_stream = (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG) ? 0 : 1;
@@ -1487,9 +1463,34 @@ static void ath_rc_init(struct ath_softc *sc,
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
 	sc->cur_rate_table = rate_table;
+
+	DPRINTF(sc, ATH_DBG_CONFIG, "RC Initialized with capabilities: 0x%x\n",
+		ath_rc_priv->ht_cap);
 }
 
-/* Rate Control callbacks */
+static u8 ath_rc_build_ht_caps(struct ath_softc *sc, bool is_ht, bool is_cw40,
+			       bool is_sgi40)
+{
+	u8 caps = 0;
+
+	if (is_ht) {
+		caps = WLAN_RC_HT_FLAG;
+		if (sc->sc_ah->caps.tx_chainmask != 1 &&
+		    ath9k_hw_getcapability(sc->sc_ah, ATH9K_CAP_DS, 0, NULL))
+			caps |= WLAN_RC_DS_FLAG;
+		if (is_cw40)
+			caps |= WLAN_RC_40_FLAG;
+		if (is_sgi40)
+			caps |= WLAN_RC_SGI_FLAG;
+	}
+
+	return caps;
+}
+
+/***********************************/
+/* mac80211 Rate Control callbacks */
+/***********************************/
+
 static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			  struct ieee80211_sta *sta, void *priv_sta,
 			  struct sk_buff *skb)
@@ -1585,6 +1586,8 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 {
 	struct ath_softc *sc = priv;
 	struct ath_rate_priv *ath_rc_priv = priv_sta;
+	struct ath_rate_table *rate_table = NULL;
+	bool is_cw40, is_sgi40;
 	int i, j = 0;
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -1606,7 +1609,66 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 		ath_rc_priv->neg_ht_rates.rs_nrates = j;
 	}
 
-	ath_rc_init(sc, priv_sta, sband, sta);
+	is_cw40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40;
+	is_sgi40 = sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40;
+
+	/* Choose rate table first */
+
+	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) ||
+	    (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)) {
+		rate_table = ath_choose_rate_table(sc, sband->band,
+						   sta->ht_cap.ht_supported,
+						   is_cw40);
+	} else if (sc->sc_ah->opmode == NL80211_IFTYPE_AP) {
+		/* cur_rate_table would be set on init through config() */
+		rate_table = sc->cur_rate_table;
+	}
+
+	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta->ht_cap.ht_supported,
+						   is_cw40, is_sgi40);
+	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+}
+
+static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
+			    struct ieee80211_sta *sta, void *priv_sta,
+			    u32 changed)
+{
+	struct ath_softc *sc = priv;
+	struct ath_rate_priv *ath_rc_priv = priv_sta;
+	struct ath_rate_table *rate_table = NULL;
+	bool oper_cw40 = false, oper_sgi40;
+	bool local_cw40 = (ath_rc_priv->ht_cap & WLAN_RC_40_FLAG) ?
+		true : false;
+	bool local_sgi40 = (ath_rc_priv->ht_cap & WLAN_RC_SGI_FLAG) ?
+		true : false;
+
+	/* FIXME: Handle AP mode later when we support CWM */
+
+	if (changed & IEEE80211_RC_HT_CHANGED) {
+		if (sc->sc_ah->opmode != NL80211_IFTYPE_STATION)
+			return;
+
+		if (sc->hw->conf.channel_type == NL80211_CHAN_HT40MINUS ||
+		    sc->hw->conf.channel_type == NL80211_CHAN_HT40PLUS)
+			oper_cw40 = true;
+
+		oper_sgi40 = (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40) ?
+			true : false;
+
+		if ((local_cw40 != oper_cw40) || (local_sgi40 != oper_sgi40)) {
+			rate_table = ath_choose_rate_table(sc, sband->band,
+						   sta->ht_cap.ht_supported,
+						   oper_cw40);
+			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc,
+						   sta->ht_cap.ht_supported,
+						   oper_cw40, oper_sgi40);
+			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
+
+			DPRINTF(sc, ATH_DBG_CONFIG,
+				"Operating HT Bandwidth changed to: %d\n",
+				sc->hw->conf.channel_type);
+		}
+	}
 }
 
 static void *ath_rate_alloc(struct ieee80211_hw *hw, struct dentry *debugfsdir)
@@ -1650,6 +1712,7 @@ static struct rate_control_ops ath_rate_ops = {
 	.tx_status = ath_tx_status,
 	.get_rate = ath_get_rate,
 	.rate_init = ath_rate_init,
+	.rate_update = ath_rate_update,
 	.alloc = ath_rate_alloc,
 	.free = ath_rate_free,
 	.alloc_sta = ath_rate_alloc_sta,
-- 
1.6.1

