Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:30463 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbZBIIAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 03:00:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 00:00:49 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18831.57812.450086.800785@gargle.gargle.HOWL> (sfid-20090209_090058_068916_BF262247)
Date: Mon, 9 Feb 2009 13:27:08 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 05/10] ath9k: Move regulatory information to a separate structure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |   16 ++++++------
 drivers/net/wireless/ath9k/hw.c     |   37 ++++++++++++++-------------
 drivers/net/wireless/ath9k/hw.h     |   12 +-------
 drivers/net/wireless/ath9k/main.c   |    2 +-
 drivers/net/wireless/ath9k/regd.c   |   48 +++++++++++++++++-----------------
 drivers/net/wireless/ath9k/regd.h   |   12 ++++++++
 6 files changed, 66 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 420a060..d58d8a3 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -1232,9 +1232,9 @@ static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
 
-	if (ah->ah_tpScale != ATH9K_TP_SCALE_MAX) {
+	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
 		maxRegAllowedPower -=
-			(tpScaleReductionTable[(ah->ah_tpScale)] * 2);
+			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
 	}
 
 	scaledPower = min(powerLimit, maxRegAllowedPower);
@@ -1510,9 +1510,9 @@ static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
 
-	if (ah->ah_tpScale != ATH9K_TP_SCALE_MAX) {
+	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
 		maxRegAllowedPower -=
-			(tpScaleReductionTable[(ah->ah_tpScale)] * 2);
+			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
 	}
 
 	scaledPower = min(powerLimit, maxRegAllowedPower);
@@ -1823,10 +1823,10 @@ static int ath9k_hw_def_set_txpower(struct ath_hal *ah,
 		i = rateHt20_0;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->ah_maxPowerLevel =
+		ah->regulatory.max_power_level =
 			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
 	else
-		ah->ah_maxPowerLevel = ratesArray[i];
+		ah->regulatory.max_power_level = ratesArray[i];
 
 	return 0;
 }
@@ -1951,10 +1951,10 @@ static int ath9k_hw_4k_set_txpower(struct ath_hal *ah,
 		i = rateHt20_0;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->ah_maxPowerLevel =
+		ah->regulatory.max_power_level =
 			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
 	else
-		ah->ah_maxPowerLevel = ratesArray[i];
+		ah->regulatory.max_power_level = ratesArray[i];
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 164a543..9eafada 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -409,7 +409,7 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 	ah->ah_sc = sc;
 	ah->ah_sh = mem;
 	ah->hw_version.magic = AR5416_MAGIC;
-	ah->ah_countryCode = CTRY_DEFAULT;
+	ah->regulatory.country_code = CTRY_DEFAULT;
 	ah->hw_version.devid = devid;
 	ah->hw_version.subvendorid = 0;
 
@@ -419,8 +419,8 @@ static struct ath_hal_5416 *ath9k_hw_newstate(u16 devid,
 	if (!AR_SREV_9100(ah))
 		ah->ah_flags = AH_USE_EEPROM;
 
-	ah->ah_powerLimit = MAX_RATE_POWER;
-	ah->ah_tpScale = ATH9K_TP_SCALE_MAX;
+	ah->regulatory.power_limit = MAX_RATE_POWER;
+	ah->regulatory.tp_scale = ATH9K_TP_SCALE_MAX;
 	ahp->ah_atimWindow = 0;
 	ahp->ah_diversityControl = ah->ah_config.diversity_control;
 	ahp->ah_antennaSwitchSwap =
@@ -1337,7 +1337,7 @@ static int ath9k_hw_process_ini(struct ath_hal *ah,
 				      channel->max_antenna_gain * 2,
 				      channel->max_power * 2,
 				      min((u32) MAX_RATE_POWER,
-					  (u32) ah->ah_powerLimit));
+					  (u32) ah->regulatory.power_limit));
 	if (status != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_POWER_MGMT,
 			"error init'ing transmit power\n");
@@ -1668,7 +1668,7 @@ static bool ath9k_hw_channel_change(struct ath_hal *ah,
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				     (u32) ah->ah_powerLimit)) != 0) {
+				     (u32) ah->regulatory.power_limit)) != 0) {
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
 			"error init'ing transmit power\n");
 		return false;
@@ -3136,21 +3136,22 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 
 	eeval = ath9k_hw_get_eeprom(ah, EEP_REG_0);
 
-	ah->ah_currentRD = eeval;
+	ah->regulatory.current_rd = eeval;
 
 	eeval = ath9k_hw_get_eeprom(ah, EEP_REG_1);
-	ah->ah_currentRDExt = eeval;
+	ah->regulatory.current_rd_ext = eeval;
 
 	capField = ath9k_hw_get_eeprom(ah, EEP_OP_CAP);
 
 	if (ah->ah_opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
-		if (ah->ah_currentRD == 0x64 || ah->ah_currentRD == 0x65)
-			ah->ah_currentRD += 5;
-		else if (ah->ah_currentRD == 0x41)
-			ah->ah_currentRD = 0x43;
+		if (ah->regulatory.current_rd == 0x64 ||
+		    ah->regulatory.current_rd == 0x65)
+			ah->regulatory.current_rd += 5;
+		else if (ah->regulatory.current_rd == 0x41)
+			ah->regulatory.current_rd = 0x43;
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"regdomain mapped to 0x%x\n", ah->ah_currentRD);
+			"regdomain mapped to 0x%x\n", ah->regulatory.current_rd);
 	}
 
 	eeval = ath9k_hw_get_eeprom(ah, EEP_OP_MODE);
@@ -3292,7 +3293,7 @@ bool ath9k_hw_fill_cap_info(struct ath_hal *ah)
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
 
-	if (ah->ah_currentRDExt & (1 << REG_EXT_JAPAN_MIDBAND)) {
+	if (ah->regulatory.current_rd_ext & (1 << REG_EXT_JAPAN_MIDBAND)) {
 		pCap->reg_cap =
 			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
 			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
@@ -3392,13 +3393,13 @@ bool ath9k_hw_getcapability(struct ath_hal *ah, enum ath9k_capability_type type,
 		case 0:
 			return 0;
 		case 1:
-			*result = ah->ah_powerLimit;
+			*result = ah->regulatory.power_limit;
 			return 0;
 		case 2:
-			*result = ah->ah_maxPowerLevel;
+			*result = ah->regulatory.max_power_level;
 			return 0;
 		case 3:
-			*result = ah->ah_tpScale;
+			*result = ah->regulatory.tp_scale;
 			return 0;
 		}
 		return false;
@@ -3655,14 +3656,14 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hal *ah, u32 limit)
 	struct ath9k_channel *chan = ah->ah_curchan;
 	struct ieee80211_channel *channel = chan->chan;
 
-	ah->ah_powerLimit = min(limit, (u32) MAX_RATE_POWER);
+	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
 
 	if (ath9k_hw_set_txpower(ah, chan,
 				 ath9k_regd_get_ctl(ah, chan),
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				     (u32) ah->ah_powerLimit)) != 0)
+				     (u32) ah->regulatory.power_limit)) != 0)
 		return false;
 
 	return true;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index afa64bd..3fdf962 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -425,17 +425,9 @@ struct ath_hal {
 	enum nl80211_iftype ah_opmode;
 	struct ath9k_ops_config ah_config;
 	struct ath9k_hw_capabilities ah_caps;
-
-	u16 ah_countryCode;
+	struct ath9k_regulatory regulatory;
 	u32 ah_flags;
-	int16_t ah_powerLimit;
-	u16 ah_maxPowerLevel;
-	u32 ah_tpScale;
-	u16 ah_currentRD;
-	u16 ah_currentRDExt;
-	u16 ah_currentRDInUse;
-	char alpha2[2];
-	struct reg_dmn_pair_mapping *regpair;
+
 	enum ath9k_power_mode ah_power_mode;
 	enum ath9k_power_mode ah_restore_mode;
 
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index dacf97a..a1c76ec 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1659,7 +1659,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	error = ieee80211_register_hw(hw);
 
 	if (!ath9k_is_world_regd(sc->sc_ah))
-		regulatory_hint(hw->wiphy, sc->sc_ah->alpha2);
+		regulatory_hint(hw->wiphy, sc->sc_ah->regulatory.alpha2);
 
 	/* Initialize LED control */
 	ath_init_leds(sc);
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 819feb9..32dd0cb 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -108,7 +108,7 @@ static const struct ieee80211_regdomain ath9k_world_regdom_67_68_6A = {
 
 static u16 ath9k_regd_get_eepromRD(struct ath_hal *ah)
 {
-	return ah->ah_currentRD & ~WORLDWIDE_ROAMING_FLAG;
+	return ah->regulatory.current_rd & ~WORLDWIDE_ROAMING_FLAG;
 }
 
 u16 ath9k_regd_get_rd(struct ath_hal *ah)
@@ -129,7 +129,7 @@ const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
 
 const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah)
 {
-	switch (ah->regpair->regDmnEnum) {
+	switch (ah->regulatory.regpair->regDmnEnum) {
 	case 0x60:
 	case 0x61:
 	case 0x62:
@@ -284,7 +284,7 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hal *ah = sc->sc_ah;
 
-	switch (ah->regpair->regDmnEnum) {
+	switch (ah->regulatory.regpair->regDmnEnum) {
 	case 0x60:
 	case 0x63:
 	case 0x66:
@@ -413,30 +413,30 @@ int ath9k_regd_init(struct ath_hal *ah)
 		return -EINVAL;
 	}
 
-	ah->ah_countryCode = ath9k_regd_get_default_country(ah);
+	ah->regulatory.country_code = ath9k_regd_get_default_country(ah);
 
-	if (ah->ah_countryCode == CTRY_DEFAULT &&
+	if (ah->regulatory.country_code == CTRY_DEFAULT &&
 	    ath9k_regd_get_eepromRD(ah) == CTRY_DEFAULT)
-		ah->ah_countryCode = CTRY_UNITED_STATES;
+		ah->regulatory.country_code = CTRY_UNITED_STATES;
 
-	if (ah->ah_countryCode == CTRY_DEFAULT) {
+	if (ah->regulatory.country_code == CTRY_DEFAULT) {
 		regdmn = ath9k_regd_get_eepromRD(ah);
 		country = NULL;
 	} else {
-		country = ath9k_regd_find_country(ah->ah_countryCode);
+		country = ath9k_regd_find_country(ah->regulatory.country_code);
 		if (country == NULL) {
 			DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 				"Country is NULL!!!!, cc= %d\n",
-				ah->ah_countryCode);
+				ah->regulatory.country_code);
 			return -EINVAL;
 		} else
 			regdmn = country->regDmnEnum;
 	}
 
-	ah->ah_currentRDInUse = regdmn;
-	ah->regpair = ath9k_get_regpair(regdmn);
+	ah->regulatory.current_rd_inuse = regdmn;
+	ah->regulatory.regpair = ath9k_get_regpair(regdmn);
 
-	if (!ah->regpair) {
+	if (!ah->regulatory.regpair) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
 			"No regulatory domain pair found, cannot continue\n");
 		return -EINVAL;
@@ -446,18 +446,18 @@ int ath9k_regd_init(struct ath_hal *ah)
 		country = ath9k_regd_find_country_by_rd(regdmn);
 
 	if (country) {
-		ah->alpha2[0] = country->isoName[0];
-		ah->alpha2[1] = country->isoName[1];
+		ah->regulatory.alpha2[0] = country->isoName[0];
+		ah->regulatory.alpha2[1] = country->isoName[1];
 	} else {
-		ah->alpha2[0] = '0';
-		ah->alpha2[1] = '0';
+		ah->regulatory.alpha2[0] = '0';
+		ah->regulatory.alpha2[1] = '0';
 	}
 
 	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
 		"Country alpha2 being used: %c%c\n"
-		"Regpair detected: 0x%0x\n",
-		ah->alpha2[0], ah->alpha2[1],
-		ah->regpair->regDmnEnum);
+		"Regulatory.Regpair detected: 0x%0x\n",
+		ah->regulatory.alpha2[0], ah->regulatory.alpha2[1],
+		ah->regulatory.regpair->regDmnEnum);
 
 	return 0;
 }
@@ -466,8 +466,8 @@ u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
 {
 	u32 ctl = NO_CTL;
 
-	if (!ah->regpair ||
-	    (ah->ah_countryCode == CTRY_DEFAULT && isWwrSKU(ah))) {
+	if (!ah->regulatory.regpair ||
+	    (ah->regulatory.country_code == CTRY_DEFAULT && isWwrSKU(ah))) {
 		if (IS_CHAN_B(chan))
 			ctl = SD_NO_CTL | CTL_11B;
 		else if (IS_CHAN_G(chan))
@@ -478,11 +478,11 @@ u32 ath9k_regd_get_ctl(struct ath_hal *ah, struct ath9k_channel *chan)
 	}
 
 	if (IS_CHAN_B(chan))
-		ctl = ah->regpair->reg_2ghz_ctl | CTL_11B;
+		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11B;
 	else if (IS_CHAN_G(chan))
-		ctl = ah->regpair->reg_5ghz_ctl | CTL_11G;
+		ctl = ah->regulatory.regpair->reg_5ghz_ctl | CTL_11G;
 	else
-		ctl = ah->regpair->reg_5ghz_ctl | CTL_11A;
+		ctl = ah->regulatory.regpair->reg_5ghz_ctl | CTL_11A;
 
 	return ctl;
 }
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index d1c4457..65abdf4 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -45,6 +45,18 @@ struct country_code_to_enum_rd {
 	const char *isoName;
 };
 
+struct ath9k_regulatory {
+	char alpha2[2];
+	u16 country_code;
+	u16 max_power_level;
+	u32 tp_scale;
+	u16 current_rd;
+	u16 current_rd_ext;
+	u16 current_rd_inuse;
+	int16_t power_limit;
+	struct reg_dmn_pair_mapping *regpair;
+};
+
 enum CountryCode {
 	CTRY_ALBANIA = 8,
 	CTRY_ALGERIA = 12,
-- 
1.6.1

