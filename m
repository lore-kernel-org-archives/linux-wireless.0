Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/9] ath: move more setup code into ath_regd_init
Date: Mon, 30 Mar 2009 22:30:30 -0400
Message-Id: <1238466635-23280-5-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043044_059107_2C9AA500)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Setup the wiphy regulatory parameters when first initializing the
Atheros regulatory module.  We can remove five exported symbols this
way and simplify the driver code for both ath5k and ath9k.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/regd.c   |   55 ++++++++++++++++++++++++++++---------
 drivers/net/wireless/ath/regd.h   |   12 ++------
 drivers/net/wireless/ath9k/main.c |   47 +++++++++-----------------------
 3 files changed, 58 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 4d3935b..3ccf21c 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -126,14 +126,13 @@ bool ath_is_world_regd(struct ath_regulatory *reg)
 }
 EXPORT_SYMBOL(ath_is_world_regd);
 
-const struct ieee80211_regdomain *ath_default_world_regdomain(void)
+static const struct ieee80211_regdomain *ath_default_world_regdomain(void)
 {
 	/* this is the most restrictive */
 	return &ath_world_regdom_64;
 }
-EXPORT_SYMBOL(ath_default_world_regdomain);
 
-const struct
+static const struct
 ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
 {
 	switch (reg->regpair->regDmnEnum) {
@@ -158,7 +157,6 @@ ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg)
 		return ath_default_world_regdomain();
 	}
 }
-EXPORT_SYMBOL(ath_world_regdomain);
 
 /* Frequency is one where radar detection is required */
 static bool ath_is_radar_freq(u16 center_freq)
@@ -285,7 +283,7 @@ static void ath_reg_apply_active_scan_flags(
 }
 
 /* Always apply Radar/DFS rules on freq range 5260 MHz - 5700 MHz */
-void ath_reg_apply_radar_flags(struct wiphy *wiphy)
+static void ath_reg_apply_radar_flags(struct wiphy *wiphy)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
@@ -316,11 +314,10 @@ void ath_reg_apply_radar_flags(struct wiphy *wiphy)
 				     IEEE80211_CHAN_PASSIVE_SCAN;
 	}
 }
-EXPORT_SYMBOL(ath_reg_apply_radar_flags);
 
-void ath_reg_apply_world_flags(struct wiphy *wiphy,
-			       enum nl80211_reg_initiator initiator,
-			       struct ath_regulatory *reg)
+static void ath_reg_apply_world_flags(struct wiphy *wiphy,
+				 enum nl80211_reg_initiator initiator,
+				 struct ath_regulatory *reg)
 {
 	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
@@ -336,7 +333,6 @@ void ath_reg_apply_world_flags(struct wiphy *wiphy,
 	}
 	return;
 }
-EXPORT_SYMBOL(ath_reg_apply_world_flags);
 
 int ath_reg_notifier_apply(struct wiphy *wiphy,
 	struct regulatory_request *request, struct ath_regulatory *reg)
@@ -360,7 +356,7 @@ int ath_reg_notifier_apply(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(ath_reg_notifier_apply);
 
-bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
+static bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
 {
 	 u16 rd = ath_regd_get_eepromRD(reg);
 	int i;
@@ -381,7 +377,6 @@ bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg)
 		 "ath: invalid regulatory domain/country code 0x%x\n", rd);
 	return false;
 }
-EXPORT_SYMBOL(ath_regd_is_eeprom_valid);
 
 /* EEPROM country code to regpair mapping */
 static struct country_code_to_enum_rd*
@@ -438,7 +433,40 @@ ath_get_regpair(int regdmn)
 	return NULL;
 }
 
-int ath_regd_init(struct ath_regulatory *reg)
+static int ath_regd_init_wiphy(struct ath_regulatory *reg, struct wiphy *wiphy,
+			       int (*reg_notifier)(struct wiphy *wiphy,
+					struct regulatory_request *request))
+{
+	const struct ieee80211_regdomain *regd;
+
+	wiphy->reg_notifier = reg_notifier;
+	wiphy->strict_regulatory = true;
+
+	if (ath_is_world_regd(reg)) {
+		/*
+		 * Anything applied here (prior to wiphy registration) gets
+		 * saved on the wiphy orig_* parameters
+		 */
+		regd = ath_world_regdomain(reg);
+		wiphy->custom_regulatory = true;
+		wiphy->strict_regulatory = false;
+	} else {
+		/*
+		 * This gets applied in the case of the absense of CRDA,
+		 * it's our own custom world regulatory domain, similar to
+		 * cfg80211's but we enable passive scanning.
+		 */
+		regd = ath_default_world_regdomain();
+	}
+	wiphy_apply_custom_regulatory(wiphy, regd);
+	ath_reg_apply_radar_flags(wiphy);
+	ath_reg_apply_world_flags(wiphy, NL80211_REGDOM_SET_BY_DRIVER, reg);
+	return 0;
+}
+
+int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
+		  int (*reg_notifier)(struct wiphy *wiphy,
+			    struct regulatory_request *request))
 {
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
@@ -492,6 +520,7 @@ int ath_regd_init(struct ath_regulatory *reg)
 	printk(KERN_DEBUG "ath: Regpair detected: 0x%0x\n",
 		reg->regpair->regDmnEnum);
 
+	ath_regd_init_wiphy(reg, wiphy, reg_notifier);
 	return 0;
 }
 EXPORT_SYMBOL(ath_regd_init);
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 981f5cf..eba7c71 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -254,15 +254,9 @@ enum CountryCode {
 };
 
 bool ath_is_world_regd(struct ath_regulatory *reg);
-const
-struct ieee80211_regdomain *ath_world_regdomain(struct ath_regulatory *reg);
-const struct ieee80211_regdomain *ath_default_world_regdomain(void);
-void ath_reg_apply_world_flags(struct wiphy *wiphy,
-			       enum nl80211_reg_initiator,
-			       struct ath_regulatory *reg);
-void ath_reg_apply_radar_flags(struct wiphy *wiphy);
-int ath_regd_init(struct ath_regulatory *reg);
-bool ath_regd_is_eeprom_valid(struct ath_regulatory *reg);
+int ath_regd_init(struct ath_regulatory *reg, struct wiphy *wiphy,
+		  int (*reg_notifier)(struct wiphy *wiphy,
+		  struct regulatory_request *request));
 u32 ath_regd_get_band_ctl(struct ath_regulatory *reg,
 			  enum ieee80211_band band);
 int ath_reg_notifier_apply(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 4cc82ec..9a196c1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1353,6 +1353,17 @@ void ath_detach(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 }
 
+static int ath9k_reg_notifier(struct wiphy *wiphy,
+			      struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_regulatory *reg = &sc->sc_ah->regulatory;
+
+	return ath_reg_notifier_apply(wiphy, request, reg);
+}
+
 static int ath_init(u16 devid, struct ath_softc *sc)
 {
 	struct ath_hw *ah = NULL;
@@ -1407,7 +1418,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (ath_regd_init(&sc->sc_ah->regulatory))
+	if (ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
+			  ath9k_reg_notifier))
 		goto bad;
 
 	/* default to MONITOR mode */
@@ -1571,17 +1583,6 @@ bad:
 	return error;
 }
 
-static int ath9k_reg_notifier(struct wiphy *wiphy,
-			      struct regulatory_request *request)
-{
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_regulatory *reg = &sc->sc_ah->regulatory;
-
-	return ath_reg_notifier_apply(wiphy, request, reg);
-}
-
 void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	hw->flags = IEEE80211_HW_RX_INCLUDES_FCS |
@@ -1601,9 +1602,6 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		BIT(NL80211_IFTYPE_ADHOC) |
 		BIT(NL80211_IFTYPE_MESH_POINT);
 
-	hw->wiphy->reg_notifier = ath9k_reg_notifier;
-	hw->wiphy->strict_regulatory = true;
-
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
@@ -1624,7 +1622,6 @@ void ath_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 int ath_attach(u16 devid, struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
-	const struct ieee80211_regdomain *regd;
 	int error = 0, i;
 	struct ath_regulatory *reg;
 
@@ -1668,24 +1665,6 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 		goto error_attach;
 #endif
 
-	if (ath_is_world_regd(reg)) {
-		/* Anything applied here (prior to wiphy registration) gets
-		 * saved on the wiphy orig_* parameters */
-		regd = ath_world_regdomain(reg);
-		hw->wiphy->custom_regulatory = true;
-		hw->wiphy->strict_regulatory = false;
-	} else {
-		/* This gets applied in the case of the absense of CRDA,
-		 * it's our own custom world regulatory domain, similar to
-		 * cfg80211's but we enable passive scanning */
-		regd = ath_default_world_regdomain();
-	}
-	wiphy_apply_custom_regulatory(hw->wiphy, regd);
-	ath_reg_apply_radar_flags(hw->wiphy);
-	ath_reg_apply_world_flags(hw->wiphy,
-				  NL80211_REGDOM_SET_BY_DRIVER,
-				  reg);
-
 	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
 	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
 	sc->wiphy_scheduler_int = msecs_to_jiffies(500);
-- 
1.6.0.6

