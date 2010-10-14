Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39416 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab0JNOCs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Oct 2010 10:02:48 -0400
Message-ID: <4CB70D7F.9090805@openwrt.org>
Date: Thu, 14 Oct 2010 16:02:39 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Rajkumar Manoharan <rmanoharan@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/3] ath9k_hw: remove enum wireless_mode and its users
References: <20101014082135.GG21903@vasanth-laptop> <20101014085107.GA6101@vmraj-lnx.users.atheros.com>
In-Reply-To: <20101014085107.GA6101@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wireless mode bitfield was only used to detect 2.4 and 5 GHz support,
which can be simplified by using ATH9K_HW_CAP_* capabilities.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 v2: remove an unused argument
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |   12 ++++----
 drivers/net/wireless/ath/ath9k/hw.c           |   34 ++------------------
 drivers/net/wireless/ath/ath9k/hw.h           |   15 +--------
 drivers/net/wireless/ath/ath9k/init.c         |   12 ++++----
 drivers/net/wireless/ath/ath9k/rc.c           |   41 ++++--------------------
 5 files changed, 25 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index bbb54bc..3d7b97f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -566,7 +566,7 @@ static void ath9k_init_crypto(struct ath9k_htc_priv *priv)
 
 static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
 {
-	if (test_bit(ATH9K_MODE_11G, priv->ah->caps.wireless_modes)) {
+	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
 		priv->sbands[IEEE80211_BAND_2GHZ].channels =
 			ath9k_2ghz_channels;
 		priv->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
@@ -577,7 +577,7 @@ static void ath9k_init_channels_rates(struct ath9k_htc_priv *priv)
 			ARRAY_SIZE(ath9k_legacy_rates);
 	}
 
-	if (test_bit(ATH9K_MODE_11A, priv->ah->caps.wireless_modes)) {
+	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
 		priv->sbands[IEEE80211_BAND_5GHZ].channels = ath9k_5ghz_channels;
 		priv->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
 		priv->sbands[IEEE80211_BAND_5GHZ].n_channels =
@@ -740,18 +740,18 @@ static void ath9k_set_hw_capab(struct ath9k_htc_priv *priv,
 	hw->extra_tx_headroom = sizeof(struct tx_frame_hdr) +
 		sizeof(struct htc_frame_hdr) + 4;
 
-	if (test_bit(ATH9K_MODE_11G, priv->ah->caps.wireless_modes))
+	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&priv->sbands[IEEE80211_BAND_2GHZ];
-	if (test_bit(ATH9K_MODE_11A, priv->ah->caps.wireless_modes))
+	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&priv->sbands[IEEE80211_BAND_5GHZ];
 
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		if (test_bit(ATH9K_MODE_11G, priv->ah->caps.wireless_modes))
+		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 			setup_ht_cap(priv,
 				     &priv->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-		if (test_bit(ATH9K_MODE_11A, priv->ah->caps.wireless_modes))
+		if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 			setup_ht_cap(priv,
 				     &priv->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f5d7917..cc13ee1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1800,37 +1800,11 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		return -EINVAL;
 	}
 
-	bitmap_zero(pCap->wireless_modes, ATH9K_MODE_MAX);
-
-	if (eeval & AR5416_OPFLAGS_11A) {
-		set_bit(ATH9K_MODE_11A, pCap->wireless_modes);
-		if (ah->config.ht_enable) {
-			if (!(eeval & AR5416_OPFLAGS_N_5G_HT20))
-				set_bit(ATH9K_MODE_11NA_HT20,
-					pCap->wireless_modes);
-			if (!(eeval & AR5416_OPFLAGS_N_5G_HT40)) {
-				set_bit(ATH9K_MODE_11NA_HT40PLUS,
-					pCap->wireless_modes);
-				set_bit(ATH9K_MODE_11NA_HT40MINUS,
-					pCap->wireless_modes);
-			}
-		}
-	}
+	if (eeval & AR5416_OPFLAGS_11A)
+		pCap->hw_caps |= ATH9K_HW_CAP_5GHZ;
 
-	if (eeval & AR5416_OPFLAGS_11G) {
-		set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
-		if (ah->config.ht_enable) {
-			if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
-				set_bit(ATH9K_MODE_11NG_HT20,
-					pCap->wireless_modes);
-			if (!(eeval & AR5416_OPFLAGS_N_2G_HT40)) {
-				set_bit(ATH9K_MODE_11NG_HT40PLUS,
-					pCap->wireless_modes);
-				set_bit(ATH9K_MODE_11NG_HT40MINUS,
-					pCap->wireless_modes);
-			}
-		}
-	}
+	if (eeval & AR5416_OPFLAGS_11G)
+		pCap->hw_caps |= ATH9K_HW_CAP_2GHZ;
 
 	pCap->tx_chainmask = ah->eep_ops->get_eeprom(ah, EEP_TX_MASK);
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6b92334..d032939 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -164,18 +164,6 @@ enum ath_ini_subsys {
 	ATH_INI_NUM_SPLIT,
 };
 
-enum wireless_mode {
-	ATH9K_MODE_11A = 0,
-	ATH9K_MODE_11G,
-	ATH9K_MODE_11NA_HT20,
-	ATH9K_MODE_11NG_HT20,
-	ATH9K_MODE_11NA_HT40PLUS,
-	ATH9K_MODE_11NA_HT40MINUS,
-	ATH9K_MODE_11NG_HT40PLUS,
-	ATH9K_MODE_11NG_HT40MINUS,
-	ATH9K_MODE_MAX,
-};
-
 enum ath9k_hw_caps {
 	ATH9K_HW_CAP_HT                         = BIT(0),
 	ATH9K_HW_CAP_RFSILENT                   = BIT(1),
@@ -190,11 +178,12 @@ enum ath9k_hw_caps {
 	ATH9K_HW_CAP_SGI_20			= BIT(10),
 	ATH9K_HW_CAP_PAPRD			= BIT(11),
 	ATH9K_HW_CAP_ANT_DIV_COMB		= BIT(12),
+	ATH9K_HW_CAP_2GHZ			= BIT(13),
+	ATH9K_HW_CAP_5GHZ			= BIT(14),
 };
 
 struct ath9k_hw_capabilities {
 	u32 hw_caps; /* ATH9K_HW_CAP_* from ath9k_hw_caps */
-	DECLARE_BITMAP(wireless_modes, ATH9K_MODE_MAX); /* ATH9K_MODE_* */
 	u16 total_queues;
 	u16 keycache_size;
 	u16 low_5ghz_chan, high_5ghz_chan;
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index a4c5ed4..bc6c4df 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -485,7 +485,7 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 		     ARRAY_SIZE(ath9k_5ghz_chantable) !=
 		     ATH9K_NUM_CHANNELS);
 
-	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes)) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
 		channels = kmemdup(ath9k_2ghz_chantable,
 			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
 		if (!channels)
@@ -500,7 +500,7 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 			ARRAY_SIZE(ath9k_legacy_rates);
 	}
 
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes)) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
 		channels = kmemdup(ath9k_5ghz_chantable,
 			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
 		if (!channels) {
@@ -681,17 +681,17 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->rate_control_algorithm = "ath9k_rate_control";
 #endif
 
-	if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes))
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&sc->sbands[IEEE80211_BAND_2GHZ];
-	if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			&sc->sbands[IEEE80211_BAND_5GHZ];
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
-		if (test_bit(ATH9K_MODE_11G, sc->sc_ah->caps.wireless_modes))
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
-		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
+		if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
 			setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_5GHZ].ht_cap);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index f436784..e3e8a6a 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -378,17 +378,6 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
 	0,   /* Phy rates allowed initially */
 };
 
-static const struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX] = {
-	[ATH9K_MODE_11A] = &ar5416_11a_ratetable,
-	[ATH9K_MODE_11G] = &ar5416_11g_ratetable,
-	[ATH9K_MODE_11NA_HT20] = &ar5416_11na_ratetable,
-	[ATH9K_MODE_11NG_HT20] = &ar5416_11ng_ratetable,
-	[ATH9K_MODE_11NA_HT40PLUS] = &ar5416_11na_ratetable,
-	[ATH9K_MODE_11NA_HT40MINUS] = &ar5416_11na_ratetable,
-	[ATH9K_MODE_11NG_HT40PLUS] = &ar5416_11ng_ratetable,
-	[ATH9K_MODE_11NG_HT40MINUS] = &ar5416_11ng_ratetable,
-};
-
 static int ath_rc_get_rateindex(const struct ath_rate_table *rate_table,
 				struct ieee80211_tx_rate *rate);
 
@@ -1200,38 +1189,23 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 static const
 struct ath_rate_table *ath_choose_rate_table(struct ath_softc *sc,
 					     enum ieee80211_band band,
-					     bool is_ht,
-					     bool is_cw_40)
+					     bool is_ht)
 {
-	int mode = 0;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	switch(band) {
 	case IEEE80211_BAND_2GHZ:
-		mode = ATH9K_MODE_11G;
 		if (is_ht)
-			mode = ATH9K_MODE_11NG_HT20;
-		if (is_cw_40)
-			mode = ATH9K_MODE_11NG_HT40PLUS;
-		break;
+			return &ar5416_11ng_ratetable;
+		return &ar5416_11g_ratetable;
 	case IEEE80211_BAND_5GHZ:
-		mode = ATH9K_MODE_11A;
 		if (is_ht)
-			mode = ATH9K_MODE_11NA_HT20;
-		if (is_cw_40)
-			mode = ATH9K_MODE_11NA_HT40PLUS;
-		break;
+			return &ar5416_11na_ratetable;
+		return &ar5416_11a_ratetable;
 	default:
 		ath_print(common, ATH_DBG_CONFIG, "Invalid band\n");
 		return NULL;
 	}
-
-	BUG_ON(mode >= ATH9K_MODE_MAX);
-
-	ath_print(common, ATH_DBG_CONFIG,
-		  "Choosing rate table for mode: %d\n", mode);
-
-	return hw_rate_table[mode];
 }
 
 static void ath_rc_init(struct ath_softc *sc,
@@ -1480,7 +1454,7 @@ static void ath_rate_init(void *priv, struct ieee80211_supported_band *sband,
 	/* Choose rate table first */
 
 	rate_table = ath_choose_rate_table(sc, sband->band,
-	                      sta->ht_cap.ht_supported, is_cw40);
+	                      sta->ht_cap.ht_supported);
 
 	ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta, is_cw40, is_sgi);
 	ath_rc_init(sc, priv_sta, sband, sta, rate_table);
@@ -1520,8 +1494,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 
 		if ((local_cw40 != oper_cw40) || (local_sgi != oper_sgi)) {
 			rate_table = ath_choose_rate_table(sc, sband->band,
-						   sta->ht_cap.ht_supported,
-						   oper_cw40);
+						   sta->ht_cap.ht_supported);
 			ath_rc_priv->ht_cap = ath_rc_build_ht_caps(sc, sta,
 						   oper_cw40, oper_sgi);
 			ath_rc_init(sc, priv_sta, sband, sta, rate_table);
-- 
1.7.2.2

