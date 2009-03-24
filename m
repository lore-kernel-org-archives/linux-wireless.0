Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:42618 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbZCXSiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 14:38:54 -0400
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC] ath9k's regulatory domain code changes (for ar9170)
Date: Tue, 24 Mar 2009 19:38:46 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903241938.47155.chunkeey@web.de> (sfid-20090324_193858_792957_691FF881)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

This is more or less what I need from ath9k's regulatory domain code.
What's your opinion? Would you accept the changes, or do you see
a potential conflict/problem with the design?

Regards,
	Chr
---
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 9818945..334a20f 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -1366,7 +1366,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		ath9k_olc_init(ah);
 
 	status = ah->eep_ops->set_txpower(ah, chan,
-				  ath9k_regd_get_ctl(ah, chan),
+				  ath9k_regd_get_ctl(&ah->regulatory, chan),
 				  channel->max_antenna_gain * 2,
 				  channel->max_power * 2,
 				  min((u32) MAX_RATE_POWER,
@@ -1706,7 +1706,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	}
 
 	if (ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(ah, chan),
+			     ath9k_regd_get_ctl(&ah->regulatory, chan),
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
@@ -3768,7 +3768,7 @@ bool ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
 
 	if (ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(ah, chan),
+			     ath9k_regd_get_ctl(&ah->regulatory, chan),
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index c13e4e5..8db019f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1362,6 +1362,16 @@ void ath_detach(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 }
 
+struct ath9k_regulatory *ath9k_reg_get_from_wiphy(struct wiphy *wiphy)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+
+	return &ah->regulatory;
+}
+
 static int ath_init(u16 devid, struct ath_softc *sc)
 {
 	struct ath_hw *ah = NULL;
@@ -1416,7 +1426,8 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	if (ath9k_regd_init(sc->sc_ah))
+	sc->sc_ah->regulatory.debug = sc;
+	if (ath9k_regd_init(&sc->sc_ah->regulatory))
 		goto bad;
 
 	/* default to MONITOR mode */
@@ -1666,10 +1677,10 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 		goto error_attach;
 #endif
 
-	if (ath9k_is_world_regd(sc->sc_ah)) {
+	if (ath9k_is_world_regd(&sc->sc_ah->regulatory)) {
 		/* Anything applied here (prior to wiphy registration) gets
 		 * saved on the wiphy orig_* parameters */
-		regd = ath9k_world_regdomain(sc->sc_ah);
+		regd = ath9k_world_regdomain(&sc->sc_ah->regulatory);
 		hw->wiphy->custom_regulatory = true;
 		hw->wiphy->strict_regulatory = false;
 	} else {
@@ -1688,7 +1699,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 
 	error = ieee80211_register_hw(hw);
 
-	if (!ath9k_is_world_regd(sc->sc_ah)) {
+	if (!ath9k_is_world_regd(&sc->sc_ah->regulatory)) {
 		error = regulatory_hint(hw->wiphy,
 			sc->sc_ah->regulatory.alpha2);
 		if (error)
diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 4ca6251..017a05f 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -112,14 +112,14 @@ static inline bool is_wwr_sku(u16 regd)
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
@@ -128,9 +128,9 @@ const struct ieee80211_regdomain *ath9k_default_world_regdomain(void)
 	return &ath9k_world_regdom_64;
 }
 
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah)
+const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath9k_regulatory *reg)
 {
-	switch (ah->regulatory.regpair->regDmnEnum) {
+	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
 	case 0x61:
 	case 0x62:
@@ -313,12 +313,9 @@ void ath9k_reg_apply_radar_flags(struct wiphy *wiphy)
 void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
 				 enum nl80211_reg_initiator initiator)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
-	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_regulatory *reg = ath9k_reg_get_from_wiphy(wiphy);
 
-	switch (ah->regulatory.regpair->regDmnEnum) {
+	switch (reg->regpair->regDmnEnum) {
 	case 0x60:
 	case 0x63:
 	case 0x66:
@@ -335,9 +332,7 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
 
 int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_wiphy *aphy = hw->priv;
-	struct ath_softc *sc = aphy->sc;
+	struct ath9k_regulatory *reg = ath9k_reg_get_from_wiphy(wiphy);
 
 	/* We always apply this */
 	ath9k_reg_apply_radar_flags(wiphy);
@@ -348,7 +343,7 @@ int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	case NL80211_REGDOM_SET_BY_USER:
 		break;
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		if (ath9k_is_world_regd(sc->sc_ah))
+		if (ath9k_is_world_regd(reg))
 			ath9k_reg_apply_world_flags(wiphy, request->initiator);
 		break;
 	}
@@ -356,9 +351,9 @@ int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request)
 	return 0;
 }
 
-bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah)
+bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg)
 {
-	u16 rd = ath9k_regd_get_eepromRD(ah);
+	u16 rd = ath9k_regd_get_eepromRD(reg);
 	int i;
 
 	if (rd & COUNTRY_ERD_FLAG) {
@@ -373,8 +368,8 @@ bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah)
 			if (regDomainPairs[i].regDmnEnum == rd)
 				return true;
 	}
-	DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-		 "invalid regulatory domain/country code 0x%x\n", rd);
+	DPRINTF(reg->debug, ATH_DBG_REGULATORY,
+		"invalid regulatory domain/country code 0x%x\n", rd);
 	return false;
 }
 
@@ -433,42 +428,42 @@ ath9k_get_regpair(int regdmn)
 	return NULL;
 }
 
-int ath9k_regd_init(struct ath_hw *ah)
+int ath9k_regd_init(struct ath9k_regulatory *reg)
 {
 	struct country_code_to_enum_rd *country = NULL;
 	u16 regdmn;
 
-	if (!ath9k_regd_is_eeprom_valid(ah)) {
-		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
+	if (!ath9k_regd_is_eeprom_valid(reg)) {
+		DPRINTF(reg->debug, ATH_DBG_FATAL,
 			"Invalid EEPROM contents\n");
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
+			DPRINTF(reg->debug, ATH_DBG_FATAL,
 				"Country is NULL!!!!, cc= %d\n",
-				ah->regulatory.country_code);
+				reg->country_code);
 			return -EINVAL;
 		} else
 			regdmn = country->regDmnEnum;
 	}
 
-	ah->regulatory.regpair = ath9k_get_regpair(regdmn);
+	reg->regpair = ath9k_get_regpair(regdmn);
 
-	if (!ah->regulatory.regpair) {
-		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
-			"No regulatory domain pair found, cannot continue\n");
+	if (!reg->regpair) {
+		DPRINTF(reg->debug, ATH_DBG_FATAL, "No regulatory domain "
+			"pair found, cannot continue\n");
 		return -EINVAL;
 	}
 
@@ -476,29 +471,29 @@ int ath9k_regd_init(struct ath_hw *ah)
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
+	DPRINTF(reg->debug, ATH_DBG_REGULATORY,
 		"Country alpha2 being used: %c%c\n"
 		"Regulatory.Regpair detected: 0x%0x\n",
-		ah->regulatory.alpha2[0], ah->regulatory.alpha2[1],
-		ah->regulatory.regpair->regDmnEnum);
+		reg->alpha2[0], reg->alpha2[1],
+		reg->regpair->regDmnEnum);
 
 	return 0;
 }
 
-u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
+u32 ath9k_regd_get_ctl(struct ath9k_regulatory *reg,
+		       struct ath9k_channel *chan)
 {
 	u32 ctl = NO_CTL;
 
-	if (!ah->regulatory.regpair ||
-	    (ah->regulatory.country_code == CTRY_DEFAULT &&
-	     is_wwr_sku(ath9k_regd_get_eepromRD(ah)))) {
+	if (!reg->regpair || (reg->country_code == CTRY_DEFAULT &&
+	     is_wwr_sku(ath9k_regd_get_eepromRD(reg)))) {
 		if (IS_CHAN_B(chan))
 			ctl = SD_NO_CTL | CTL_11B;
 		else if (IS_CHAN_G(chan))
@@ -509,11 +504,11 @@ u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	if (IS_CHAN_B(chan))
-		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11B;
+		ctl = reg->regpair->reg_2ghz_ctl | CTL_11B;
 	else if (IS_CHAN_G(chan))
-		ctl = ah->regulatory.regpair->reg_2ghz_ctl | CTL_11G;
+		ctl = reg->regpair->reg_2ghz_ctl | CTL_11G;
 	else
-		ctl = ah->regulatory.regpair->reg_5ghz_ctl | CTL_11A;
+		ctl = reg->regpair->reg_5ghz_ctl | CTL_11A;
 
 	return ctl;
 }
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 9f5fbd4..dc23883 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -49,6 +49,7 @@ struct ath9k_regulatory {
 	u16 current_rd_ext;
 	int16_t power_limit;
 	struct reg_dmn_pair_mapping *regpair;
+	void *debug;
 };
 
 enum CountryCode {
@@ -233,15 +234,17 @@ enum CountryCode {
 	CTRY_BELGIUM2 = 5002
 };
 
-bool ath9k_is_world_regd(struct ath_hw *ah);
-const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah);
+struct ath9k_channel;
+
+bool ath9k_is_world_regd(struct ath9k_regulatory *reg);
+const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath9k_regulatory *reg);
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
 void ath9k_reg_apply_world_flags(struct wiphy *wiphy,
 				 enum nl80211_reg_initiator initiator);
 void ath9k_reg_apply_radar_flags(struct wiphy *wiphy);
-int ath9k_regd_init(struct ath_hw *ah);
-bool ath9k_regd_is_eeprom_valid(struct ath_hw *ah);
-u32 ath9k_regd_get_ctl(struct ath_hw *ah, struct ath9k_channel *chan);
+int ath9k_regd_init(struct ath9k_regulatory *reg);
+bool ath9k_regd_is_eeprom_valid(struct ath9k_regulatory *reg);
+u32 ath9k_regd_get_ctl(struct ath9k_regulatory *reg, struct ath9k_channel *chan);
 int ath9k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *request);
-
+struct ath9k_regulatory *ath9k_reg_get_from_wiphy(struct wiphy *wiphy);
 #endif
---



of course, here are the ar9170 changes:
---
diff --git a/drivers/net/wireless/ar9170/Makefile b/drivers/net/wireless/ar9170/Makefile
index 8d91c7e..66e89ce 100644
--- a/drivers/net/wireless/ar9170/Makefile
+++ b/drivers/net/wireless/ar9170/Makefile
@@ -1,3 +1,3 @@
-ar9170usb-objs := usb.o main.o cmd.o mac.o phy.o led.o
+ar9170usb-objs := usb.o ../ath9k/regd.o main.o cmd.o mac.o phy.o led.o
 
 obj-$(CONFIG_AR9170_USB) += ar9170usb.o
diff --git a/drivers/net/wireless/ar9170/ar9170.h b/drivers/net/wireless/ar9170/ar9170.h
index f4fb2e9..49d4995 100644
--- a/drivers/net/wireless/ar9170/ar9170.h
+++ b/drivers/net/wireless/ar9170/ar9170.h
@@ -48,6 +48,9 @@
 #include "eeprom.h"
 #include "hw.h"
 
+/* ath9k definitions */
+#include "../ath9k/regd.h"
+
 #define PAYLOAD_MAX	(AR9170_MAX_CMD_LEN/4 - 1)
 
 enum ar9170_bw {
@@ -156,6 +159,9 @@ struct ar9170 {
 	struct sk_buff_head global_tx_status;
 	struct sk_buff_head global_tx_status_waste;
 	struct delayed_work tx_status_janitor;
+
+	/* regulatory domain */
+	struct ath9k_regulatory regulatory;
 };
 
 struct ar9170_sta_info {
diff --git a/drivers/net/wireless/ar9170/main.c b/drivers/net/wireless/ar9170/main.c
index 5996ff9..c5a2012 100644
--- a/drivers/net/wireless/ar9170/main.c
+++ b/drivers/net/wireless/ar9170/main.c
@@ -149,6 +149,13 @@ static struct ieee80211_supported_band ar9170_band_2GHz = {
 	.n_bitrates	= ar9170_g_ratetable_size,
 };
 
+static struct ieee80211_supported_band ar9170_band_5GHz = {
+	.channels	= ar9170_5ghz_chantable,
+	.n_channels	= ARRAY_SIZE(ar9170_5ghz_chantable),
+	.bitrates	= ar9170_a_ratetable,
+	.n_bitrates	= ar9170_a_ratetable_size,
+};
+
 #ifdef AR9170_QUEUE_DEBUG
 /*
  * In case some wants works with AR9170's crazy tx_status queueing techniques.
@@ -190,12 +197,30 @@ static void ar9170_dump_station_tx_status_queue(struct ar9170 *ar,
 }
 #endif /* AR9170_QUEUE_DEBUG */
 
-static struct ieee80211_supported_band ar9170_band_5GHz = {
-	.channels	= ar9170_5ghz_chantable,
-	.n_channels	= ARRAY_SIZE(ar9170_5ghz_chantable),
-	.bitrates	= ar9170_a_ratetable,
-	.n_bitrates	= ar9170_a_ratetable_size,
-};
+/* regulatory domain glue code */
+struct ath9k_regulatory *ath9k_reg_get_from_wiphy(struct wiphy *wiphy)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct ar9170 *ar = hw->priv;
+
+	return &ar->regulatory;
+}
+
+void DPRINTF(struct ar9170 *ar, int dbg_mask, const char *fmt, ...)
+{
+	if (!ar)
+		return;
+
+	/* print fatal errors */
+	if (dbg_mask & 0x8000) {
+		va_list args;
+
+		va_start(args, fmt);
+		printk(KERN_ERR "%s: ", wiphy_name(ar->hw->wiphy));
+		vprintk(fmt, args);
+		va_end(args);
+	}
+}
 
 void ar9170_handle_tx_status(struct ar9170 *ar, struct sk_buff *skb,
 			     bool valid_status, u16 tx_status)
@@ -1557,6 +1582,11 @@ void *ar9170_alloc(size_t priv_size)
 	ar->hw->max_rates = 1;
 	ar->hw->max_rate_tries = 3;
 
+	ar->regulatory.debug = ar;
+	ar->regulatory.country_code = 0;	/* CTRY_DEFAULT */
+	ar->regulatory.power_limit = 63;	/* MAX_RATE_POWER */
+	ar->regulatory.tp_scale = 0;		/* ATH9K_TP_SCALE_MAX */
+
 	for (i = 0; i < ARRAY_SIZE(ar->noise); i++)
 		ar->noise[i] = -95; /* ATH_DEFAULT_NOISE_FLOOR */
 
@@ -1607,6 +1637,10 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 		ar->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &ar9170_band_5GHz;
 		bands++;
 	}
+
+	ar->regulatory.current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
+	ar->regulatory.current_rd_ext = le16_to_cpu(ar->eeprom.reg_domain[1]);
+
 	/*
 	 * I measured this, a bandswitch takes roughly
 	 * 135 ms and a frequency switch about 80.
@@ -1627,6 +1661,7 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 
 int ar9170_register(struct ar9170 *ar, struct device *pdev)
 {
+	const struct ieee80211_regdomain *regd;
 	int err;
 
 	/* try to read EEPROM, init MAC addr */
@@ -1634,10 +1669,38 @@ int ar9170_register(struct ar9170 *ar, struct device *pdev)
 	if (err)
 		goto err_out;
 
+	err = ath9k_regd_init(&ar->regulatory);
+	if (err)
+		goto err_out;
+
+	if (ath9k_is_world_regd(&ar->regulatory)) {
+		/* Anything applied here (prior to wiphy registration) gets
+		 * saved on the wiphy orig_* parameters */
+		regd = ath9k_world_regdomain(&ar->regulatory);
+		ar->hw->wiphy->custom_regulatory = true;
+		ar->hw->wiphy->strict_regulatory = false;
+	} else {
+		/* This gets applied in the case of the absense of CRDA,
+		 * it's our own custom world regulatory domain, similar to
+		 * cfg80211's but we enable passive scanning */
+		regd = ath9k_default_world_regdomain();
+	}
+	wiphy_apply_custom_regulatory(ar->hw->wiphy, regd);
+	ath9k_reg_apply_radar_flags(ar->hw->wiphy);
+	ath9k_reg_apply_world_flags(ar->hw->wiphy,
+				    NL80211_REGDOM_SET_BY_DRIVER);
+
 	err = ieee80211_register_hw(ar->hw);
 	if (err)
 		goto err_out;
 
+	if (!ath9k_is_world_regd(&ar->regulatory)) {
+		err = regulatory_hint(ar->hw->wiphy,
+				      ar->regulatory.alpha2);
+		if (err)
+			goto err_unreg;
+	}
+
 	err = ar9170_init_leds(ar);
 	if (err)
 		goto err_unreg;
---
