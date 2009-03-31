Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43410 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZCaCai (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 22:30:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/9] ath9k: pass regd structure directly to regulatory functions
Date: Mon, 30 Mar 2009 22:30:28 -0400
Message-Id: <1238466635-23280-3-git-send-email-lrodriguez@atheros.com> (sfid-20090331_043044_755113_9428A0DE)
In-Reply-To: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
References: <1238466635-23280-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

All regulatory information is encapsulated by the ath9k_regulatory
struct, so we can now change all the callers to take that directly
instead of struct ath_hw.  This in turn will enable us to move the
regulatory functions to common code also used by ath5k, since both
can use this regulatory struct.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c   |    6 +-
 drivers/net/wireless/ath9k/main.c |   18 ++++--
 drivers/net/wireless/ath9k/regd.c |  118 +++++++++++++++++++------------------
 drivers/net/wireless/ath9k/regd.h |   17 ++++--
 4 files changed, 86 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index bb208f5..a8465bb 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1331,7 +1331,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		ath9k_olc_init(ah);
 
 	status = ah->eep_ops->set_txpower(ah, chan,
-				  ath9k_regd_get_ctl(ah, chan),
+				  ath9k_regd_get_ctl(&ah->regulatory, chan),
 				  channel->max_antenna_gain * 2,
 				  channel->max_power * 2,
 				  min((u32) MAX_RATE_POWER,
@@ -1671,7 +1671,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	}
 
 	if (ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(ah, chan),
+			     ath9k_regd_get_ctl(&ah->regulatory, chan),
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
@@ -3710,7 +3710,7 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
 
 	if (ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(ah, chan),
+			     ath9k_regd_get_ctl(&ah->regulatory, chan),
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 70738d5..aef033b 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1407,7 +1407,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (ath9k_regd_init(sc->sc_ah))
+	if (ath9k_regd_init(&sc->sc_ah->regulatory))
 		goto bad;
 
 	/* default to MONITOR mode */
@@ -1615,6 +1615,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	struct ieee80211_hw *hw = sc->hw;
 	const struct ieee80211_regdomain *regd;
 	int error = 0, i;
+	struct ath9k_regulatory *reg;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
 
@@ -1622,6 +1623,8 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	if (error != 0)
 		return error;
 
+	reg = &sc->sc_ah->regulatory;
+
 	/* get mac address from hardware and set in mac80211 */
 
 	SET_IEEE80211_PERM_ADDR(hw, sc->sc_ah->macaddr);
@@ -1654,10 +1657,10 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 		goto error_attach;
 #endif
 
-	if (ath9k_is_world_regd(sc->sc_ah)) {
+	if (ath9k_is_world_regd(reg)) {
 		/* Anything applied here (prior to wiphy registration) gets
 		 * saved on the wiphy orig_* parameters */
-		regd = ath9k_world_regdomain(sc->sc_ah);
+		regd = ath9k_world_regdomain(reg);
 		hw->wiphy->custom_regulatory = true;
 		hw->wiphy->strict_regulatory = false;
 	} else {
@@ -1668,7 +1671,9 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	}
 	wiphy_apply_custom_regulatory(hw->wiphy, regd);
 	ath9k_reg_apply_radar_flags(hw->wiphy);
-	ath9k_reg_apply_world_flags(hw->wiphy, NL80211_REGDOM_SET_BY_DRIVER);
+	ath9k_reg_apply_world_flags(hw->wiphy,
+				    NL80211_REGDOM_SET_BY_DRIVER,
+				    reg);
 
 	INIT_WORK(&sc->chan_work, ath9k_wiphy_chan_work);
 	INIT_DELAYED_WORK(&sc->wiphy_work, ath9k_wiphy_work);
@@ -1676,9 +1681,8 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	error = ieee80211_register_hw(hw);
 
-	if (!ath9k_is_world_regd(sc->sc_ah)) {
-		error = regulatory_hint(hw->wiphy,
-			sc->sc_ah->regulatory.alpha2);
+	if (!ath9k_is_world_regd(reg)) {
+		error = regulatory_hint(hw->wiphy, reg->alpha2);
 		if (error)
 			goto error_attach;
 	}
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 43ed35b..7eaa59e 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -113,14 +113,14 @@ static inline bool is_wwr_sku(u16 regd)
 		(regd == WORLD);
 }
 
-static u16 ath9k_regd_get_eepromRD(struct ath_hw *ah)
+static u16 ath9k_regd_get_eepromRD(struct ath9k_regulatory *reg)
 {
-	return ah->regulatory.current_rd & ~WORLDWIDE_ROAMING_FLAG;
+	return reg->current_rd & ~WORLDWIDE_ROAMING_FLAG;
 }
 
-bool ath9k_is_world_regd(struct ath_hw *ah)
+bool ath9k_is_world_regd(struct ath9k_regulatory *reg)
 {
-	return is_wwr_sku(ath9k_regd_get_eepromRD(ah));
+	return is_wwr_sku(ath9k_regd_get_eepromRD(reg));
 }
 
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
@@ -129,9 +129,10 @@ const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
 	return &ath9k_world_regdom_64;
 }
 
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah)
+const struct
+ieee80211_regdomain *ath9k_world_regdomain(struct ath9k_regulatory *reg)
 {
-	switch (ah->regulatory.regpair->regDmnEnum) {
+	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
 	case 0x61:
 	case 0x62:
@@ -312,14 +313,10 @@ void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
 }
 
 void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
-				 enum nl80211_reg_initiator initiator)
+				 enum nl80211_reg_initiator initiator,
+				 struct ath9k_regulatory *reg)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_hw *ah = sc->sc_ah;
-
-	switch (ah->regulatory.regpair->regDmnEnum) {
+	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
 	case 0x63:
 	case 0x66:
@@ -334,12 +331,9 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
 	return;
 }
 
-int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+static int ath9k_reg_notifier_apply(struct wiphy *wiphy,
+	struct regulatory_request *request, struct ath9k_regulatory *reg)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-
 	/* We always apply this */
 	ath9k_reg_apply_radar_flags(wiphy);
 
@@ -349,17 +343,28 @@ int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (ath9k_is_world_regd(sc->sc_ah))
-			ath9k_reg_apply_world_flags(wiphy, request->initiator);
+		if (ath9k_is_world_regd(reg))
+			ath9k_reg_apply_world_flags(wiphy, request->initiator,
+						    reg);
 		break;
 	}
 
 	return 0;
 }
 
-bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah)
+int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath9k_regulatory *reg = &sc->sc_ah->regulatory;
+
+	return ath9k_reg_notifier_apply(wiphy, request, reg);
+}
+
+bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg)
 {
-	u16 rd = ath9k_regd_get_eepromRD(ah);
+	 u16 rd = ath9k_regd_get_eepromRD(reg);
 	int i;
 
 	if (rd & COUNTRY_ERD_FLAG) {
@@ -374,8 +379,8 @@ bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah)
 			if (regDomainPairs[i].regDmnEnum == rd)
 				return true;
 	}
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		 "invalid regulatory domain/country code 0x%x\n", rd);
+	printk(KERN_DEBUG
+		 "ath9k: invalid regulatory domain/country code 0x%x\n", rd);
 	return false;
 }
 
@@ -434,41 +439,40 @@ ath9k_get_regpair(int regdmn)
 	return NULL;
 }
 
-int ath9k_regd_init(struct ath_hw *ah)
+int ath9k_regd_init(struct ath9k_regulatory *reg)
 {
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
 
-	if (!ath9k_regd_is_eeprom_valid(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"Invalid EEPROM contents\n");
+	if (!ath9k_regd_is_eeprom_valid(reg)) {
+		printk(KERN_DEBUG "ath9k: Invalid EEPROM contents\n");
 		return -EINVAL;
 	}
 
-	regdmn = ath9k_regd_get_eepromRD(ah);
-	ah->regulatory.country_code = ath9k_regd_get_default_country(regdmn);
+	regdmn = ath9k_regd_get_eepromRD(reg);
+	reg->country_code = ath9k_regd_get_default_country(regdmn);
 
-	if (ah->regulatory.country_code == CTRY_DEFAULT &&
+	if (reg->country_code == CTRY_DEFAULT &&
 	    regdmn == CTRY_DEFAULT)
-		ah->regulatory.country_code = CTRY_UNITED_STATES;
+		reg->country_code = CTRY_UNITED_STATES;
 
-	if (ah->regulatory.country_code == CTRY_DEFAULT) {
+	if (reg->country_code == CTRY_DEFAULT) {
 		country = NULL;
 	} else {
-		country = ath9k_regd_find_country(ah->regulatory.country_code);
+		country = ath9k_regd_find_country(reg->country_code);
 		if (country == NULL) {
-			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-				"Country is NULL!!!!, cc= %d\n",
-				ah->regulatory.country_code);
+			printk(KERN_DEBUG
+				"ath9k: Country is NULL!!!!, cc= %d\n",
+				reg->country_code);
 			return -EINVAL;
 		} else
 			regdmn = country->regDmnEnum;
 	}
 
-	ah->regulatory.regpair = ath9k_get_regpair(regdmn);
+	reg->regpair = ath9k_get_regpair(regdmn);
 
-	if (!ah->regulatory.regpair) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+	if (!reg->regpair) {
+		printk(KERN_DEBUG "ath9k: "
 			"No regulatory domain pair found, cannot continue\n");
 		return -EINVAL;
 	}
@@ -477,36 +481,36 @@ int ath9k_regd_init(struct ath_hw *ah)
 		country = ath9k_regd_find_country_by_rd(regdmn);
 
 	if (country) {
-		ah->regulatory.alpha2[0] = country->isoName[0];
-		ah->regulatory.alpha2[1] = country->isoName[1];
+		reg->alpha2[0] = country->isoName[0];
+		reg->alpha2[1] = country->isoName[1];
 	} else {
-		ah->regulatory.alpha2[0] = '0';
-		ah->regulatory.alpha2[1] = '0';
+		reg->alpha2[0] = '0';
+		reg->alpha2[1] = '0';
 	}
 
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		"Country alpha2 being used: %c%c\n"
-		"Regulatory.Regpair detected: 0x%0x\n",
-		ah->regulatory.alpha2[0], ah->regulatory.alpha2[1],
-		ah->regulatory.regpair->regDmnEnum);
+	printk(KERN_DEBUG "ath9k: Country alpha2 being used: %c%c\n",
+		reg->alpha2[0], reg->alpha2[1]);
+	printk(KERN_DEBUG "ath9k: Regpair detected: 0x%0x\n",
+		reg->regpair->regDmnEnum);
 
 	return 0;
 }
 
 static
-u32 ath9k_regd_get_band_ctl(struct ath_hw *ah, enum ieee80211_band band)
+u32 ath9k_regd_get_band_ctl(struct ath9k_regulatory *reg,
+	enum ieee80211_band band)
 {
-	if (!ah->regulatory.regpair ||
-	    (ah->regulatory.country_code == CTRY_DEFAULT &&
-	     is_wwr_sku(ath9k_regd_get_eepromRD(ah)))) {
+	if (!reg->regpair ||
+	    (reg->country_code == CTRY_DEFAULT &&
+	     is_wwr_sku(ath9k_regd_get_eepromRD(reg)))) {
 		return SD_NO_CTL;
 	}
 
 	switch (band) {
 	case IEEE80211_BAND_2GHZ:
-		return ah->regulatory.regpair->reg_2ghz_ctl;
+		return reg->regpair->reg_2ghz_ctl;
 	case IEEE80211_BAND_5GHZ:
-		return ah->regulatory.regpair->reg_5ghz_ctl;
+		return reg->regpair->reg_5ghz_ctl;
 	default:
 		return NO_CTL;
 	}
@@ -514,9 +518,9 @@ u32 ath9k_regd_get_band_ctl(struct ath_hw *ah, enum ieee80211_band band)
 	return NO_CTL;
 }
 
-u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
+u32 ath9k_regd_get_ctl(struct ath9k_regulatory *reg, struct ath9k_channel *chan)
 {
-	u32 ctl = ath9k_regd_get_band_ctl(ah, chan->chan->band);
+	u32 ctl = ath9k_regd_get_band_ctl(reg, chan->chan->band);
 
 	if (IS_CHAN_B(chan))
 		ctl |= CTL_11B;
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 9f5fbd4..61fa42e 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -17,6 +17,8 @@
 #ifndef REGD_H
 #define REGD_H
 
+#include <linux/nl80211.h>
+
 #define COUNTRY_ERD_FLAG        0x8000
 #define WORLDWIDE_ROAMING_FLAG  0x4000
 
@@ -233,15 +235,18 @@ enum CountryCode {
 	CTRY_BELGIUM2 = 5002
 };
 
-bool ath9k_is_world_regd(struct ath_hw *ah);
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah);
+bool ath9k_is_world_regd(struct ath9k_regulatory *reg);
+const struct ieee80211_regdomain *ath9k_world_regdomain(
+				 struct ath9k_regulatory *reg);
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
 void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
-				 enum nl80211_reg_initiator initiator);
+				 enum nl80211_reg_initiator,
+				 struct ath9k_regulatory *reg);
 void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
-int ath9k_regd_init(struct ath_hw *ah);
-bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah);
-u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan);
+int ath9k_regd_init(struct ath9k_regulatory *reg);
+bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg);
+u32 ath9k_regd_get_ctl(struct ath9k_regulatory *reg,
+		       struct ath9k_channel *chan);
 int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
 
 #endif
-- 
1.6.0.6

