Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33267 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241AbZHRAPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 20:15:11 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 17:15:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFT] ath: move regulatory info into shared common structure
Date: Mon, 17 Aug 2009 17:15:10 -0700
Message-ID: <1250554510-5793-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This moves the shared regulatory structure into the
common structure. We will use this ongoing for common
data.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I may not have time to test all the hardware so it would be nice if
others can give this a spin.

 drivers/net/wireless/ath/ar9170/ar9170.h     |    2 +-
 drivers/net/wireless/ath/ar9170/main.c       |   14 ++++---
 drivers/net/wireless/ath/ath.h               |   18 +++++++++
 drivers/net/wireless/ath/ath5k/ath5k.h       |    3 -
 drivers/net/wireless/ath/ath5k/base.c        |   14 +++---
 drivers/net/wireless/ath/ath5k/base.h        |   13 ++++++
 drivers/net/wireless/ath/ath5k/phy.c         |    3 +-
 drivers/net/wireless/ath/ath9k/ath9k.h       |   10 +++++
 drivers/net/wireless/ath/ath9k/eeprom_4k.c   |    8 ++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c |   16 ++++----
 drivers/net/wireless/ath/ath9k/eeprom_def.c  |   14 ++++---
 drivers/net/wireless/ath/ath9k/hw.c          |   53 +++++++++++++++-----------
 drivers/net/wireless/ath/ath9k/hw.h          |    1 -
 drivers/net/wireless/ath/ath9k/main.c        |    6 +-
 drivers/net/wireless/ath/regd.h              |   20 +---------
 15 files changed, 116 insertions(+), 79 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index e6c3ee3..95f8256 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -157,6 +157,7 @@ struct ar9170_sta_tid {
 
 struct ar9170 {
 	struct ieee80211_hw *hw;
+	struct ath_common common;
 	struct mutex mutex;
 	enum ar9170_device_state state;
 	unsigned long bad_hw_nagger;
@@ -222,7 +223,6 @@ struct ar9170 {
 
 	/* EEPROM */
 	struct ar9170_eeprom eeprom;
-	struct ath_regulatory regulatory;
 
 	/* tx queues - as seen by hw - */
 	struct sk_buff_head tx_pending[__AR9170_NUM_TXQ];
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 6a9462e..d30f33d 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2641,6 +2641,7 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 {
 #define RW	8	/* number of words to read at once */
 #define RB	(sizeof(u32) * RW)
+	struct ath_regulatory *regulatory = &ar->common.regulatory;
 	u8 *eeprom = (void *)&ar->eeprom;
 	u8 *addr = ar->eeprom.mac_address;
 	__le32 offsets[RW];
@@ -2707,8 +2708,8 @@ static int ar9170_read_eeprom(struct ar9170 *ar)
 	else
 		ar->hw->channel_change_time = 80 * 1000;
 
-	ar->regulatory.current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
-	ar->regulatory.current_rd_ext = le16_to_cpu(ar->eeprom.reg_domain[1]);
+	regulatory->current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
+	regulatory->current_rd_ext = le16_to_cpu(ar->eeprom.reg_domain[1]);
 
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, addr);
@@ -2722,11 +2723,12 @@ static int ar9170_reg_notifier(struct wiphy *wiphy,
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ar9170 *ar = hw->priv;
 
-	return ath_reg_notifier_apply(wiphy, request, &ar->regulatory);
+	return ath_reg_notifier_apply(wiphy, request, &ar->common.regulatory);
 }
 
 int ar9170_register(struct ar9170 *ar, struct device *pdev)
 {
+	struct ath_regulatory *regulatory = &ar->common.regulatory;
 	int err;
 
 	/* try to read EEPROM, init MAC addr */
@@ -2734,7 +2736,7 @@ int ar9170_register(struct ar9170 *ar, struct device *pdev)
 	if (err)
 		goto err_out;
 
-	err = ath_regd_init(&ar->regulatory, ar->hw->wiphy,
+	err = ath_regd_init(regulatory, ar->hw->wiphy,
 			    ar9170_reg_notifier);
 	if (err)
 		goto err_out;
@@ -2743,8 +2745,8 @@ int ar9170_register(struct ar9170 *ar, struct device *pdev)
 	if (err)
 		goto err_out;
 
-	if (!ath_is_world_regd(&ar->regulatory))
-		regulatory_hint(ar->hw->wiphy, ar->regulatory.alpha2);
+	if (!ath_is_world_regd(regulatory))
+		regulatory_hint(ar->hw->wiphy, regulatory->alpha2);
 
 	err = ar9170_init_leds(ar);
 	if (err)
diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index e284cd3..a63e90c 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -19,8 +19,26 @@
 
 #include <linux/skbuff.h>
 
+struct reg_dmn_pair_mapping {
+	u16 regDmnEnum;
+	u16 reg_5ghz_ctl;
+	u16 reg_2ghz_ctl;
+};
+
+struct ath_regulatory {
+	char alpha2[2];
+	u16 country_code;
+	u16 max_power_level;
+	u32 tp_scale;
+	u16 current_rd;
+	u16 current_rd_ext;
+	int16_t power_limit;
+	struct reg_dmn_pair_mapping *regpair;
+};
+
 struct ath_common {
 	u16 cachelsz;
+	struct ath_regulatory regulatory;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index c09402e..862762c 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -27,8 +27,6 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
-#include "../regd.h"
-
 /* RX/TX descriptor hw structs
  * TODO: Driver part should only see sw structs */
 #include "desc.h"
@@ -1077,7 +1075,6 @@ struct ath5k_hw {
 
 	int			ah_gpio_npins;
 
-	struct ath_regulatory	ah_regulatory;
 	struct ath5k_capabilities ah_capabilities;
 
 	struct ath5k_txq_info	ah_txq[AR5K_NUM_TX_QUEUES];
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3951b5b..5056410 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -718,9 +718,9 @@ static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *re
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath5k_softc *sc = hw->priv;
-	struct ath_regulatory *reg = &sc->ah->ah_regulatory;
+	struct ath_regulatory *regulatory = &sc->common.regulatory;
 
-	return ath_reg_notifier_apply(wiphy, request, reg);
+	return ath_reg_notifier_apply(wiphy, request, regulatory);
 }
 
 static int
@@ -728,6 +728,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
+	struct ath_regulatory *regulatory = &sc->common.regulatory;
 	u8 mac[ETH_ALEN] = {};
 	int ret;
 
@@ -817,9 +818,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 	memset(sc->bssidmask, 0xff, ETH_ALEN);
 	ath5k_hw_set_bssid_mask(sc->ah, sc->bssidmask);
 
-	ah->ah_regulatory.current_rd =
-		ah->ah_capabilities.cap_eeprom.ee_regdomain;
-	ret = ath_regd_init(&ah->ah_regulatory, hw->wiphy, ath5k_reg_notifier);
+	regulatory->current_rd = ah->ah_capabilities.cap_eeprom.ee_regdomain;
+	ret = ath_regd_init(regulatory, hw->wiphy, ath5k_reg_notifier);
 	if (ret) {
 		ATH5K_ERR(sc, "can't initialize regulatory system\n");
 		goto err_queues;
@@ -831,8 +831,8 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 		goto err_queues;
 	}
 
-	if (!ath_is_world_regd(&sc->ah->ah_regulatory))
-		regulatory_hint(hw->wiphy, sc->ah->ah_regulatory.alpha2);
+	if (!ath_is_world_regd(regulatory))
+		regulatory_hint(hw->wiphy, regulatory->alpha2);
 
 	ath5k_init_leds(sc);
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 25a72a8..a28c42f 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -50,6 +50,8 @@
 
 #include "ath5k.h"
 #include "debug.h"
+
+#include "../regd.h"
 #include "../ath.h"
 
 #define	ATH_RXBUF	40		/* number of RX buffers */
@@ -200,4 +202,15 @@ struct ath5k_softc {
 #define ath5k_hw_hasveol(_ah) \
 	(ath5k_hw_get_capability(_ah, AR5K_CAP_VEOL, 0, NULL) == 0)
 
+static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
+{
+	return &ah->ah_sc->common;
+}
+
+static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
+{
+	return &(ath5k_hw_common(ah)->regulatory);
+
+}
+
 #endif
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 298fcf0..1a039f2 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -2198,6 +2198,7 @@ static void
 ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 			struct ieee80211_channel *channel)
 {
+	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	struct ath5k_edge_power *rep = ee->ee_ctl_pwr;
 	u8 *ctl_val = ee->ee_ctl;
@@ -2208,7 +2209,7 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 	u8 ctl_idx = 0xFF;
 	u32 target = channel->center_freq;
 
-	ctl_mode = ath_regd_get_band_ctl(&ah->ah_regulatory, channel->band);
+	ctl_mode = ath_regd_get_band_ctl(regulatory, channel->band);
 
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 2c9f662..0e444a6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -631,6 +631,16 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 
+static inline struct ath_common *ath9k_hw_common(struct ath_hw *ah)
+{
+	return &ah->ah_sc->common;
+}
+
+static inline struct ath_regulatory *ath9k_hw_regulatory(struct ath_hw *ah)
+{
+	return &(ath9k_hw_common(ah)->regulatory);
+}
+
 static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
 {
 	sc->bus_ops->read_cachesize(sc, csz);
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index d34dd23..b8eca7b 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -508,6 +508,7 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 	|| (((cfgCtl & ~CTL_MODE_M) | (pCtlMode[ctlMode] & CTL_MODE_M)) == \
 	    ((pEepData->ctlIndex[i] & CTL_MODE_M) | SD_NO_CTL))
 
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	int i;
 	int16_t twiceLargestAntenna;
 	u16 twiceMinEdgePower;
@@ -541,9 +542,9 @@ static void ath9k_hw_set_4k_power_per_rate_table(struct ath_hw *ah,
 					   twiceLargestAntenna, 0);
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
-	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
+	if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX) {
 		maxRegAllowedPower -=
-			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
+			(tpScaleReductionTable[(regulatory->tp_scale)] * 2);
 	}
 
 	scaledPower = min(powerLimit, maxRegAllowedPower);
@@ -707,6 +708,7 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 				    u8 twiceMaxRegulatoryPower,
 				    u8 powerLimit)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_4k *pEepData = &ah->eeprom.map4k;
 	struct modal_eep_4k_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
@@ -744,7 +746,7 @@ static void ath9k_hw_4k_set_txpower(struct ath_hw *ah,
 	else if (IS_CHAN_HT20(chan))
 		i = rateHt20_0;
 
-	ah->regulatory.max_power_level = ratesArray[i];
+	regulatory->max_power_level = ratesArray[i];
 
 	if (AR_SREV_9280_10_OR_LATER(ah)) {
 		for (i = 0; i < Ar5416RateSize; i++)
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 9590979..c20c21a 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -599,7 +599,7 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 {
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10
-
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
 		{ 0, 3, 6, 9, AR5416_MAX_RATE_POWER };
@@ -632,9 +632,9 @@ static void ath9k_hw_set_AR9287_power_per_rate_table(struct ath_hw *ah,
 					    twiceLargestAntenna, 0);
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
-	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX)
+	if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX)
 		maxRegAllowedPower -=
-			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
+			(tpScaleReductionTable[(regulatory->tp_scale)] * 2);
 
 	scaledPower = min(powerLimit, maxRegAllowedPower);
 
@@ -831,7 +831,7 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 {
 #define INCREASE_MAXPOW_BY_TWO_CHAIN     6
 #define INCREASE_MAXPOW_BY_THREE_CHAIN   10
-
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 	struct modal_eep_ar9287_header *pModal = &pEepData->modalHeader;
 	int16_t ratesArray[Ar5416RateSize];
@@ -949,20 +949,20 @@ static void ath9k_hw_AR9287_set_txpower(struct ath_hw *ah,
 		i = rate6mb;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->regulatory.max_power_level =
+		regulatory->max_power_level =
 			ratesArray[i] + AR9287_PWR_TABLE_OFFSET_DB * 2;
 	else
-		ah->regulatory.max_power_level = ratesArray[i];
+		regulatory->max_power_level = ratesArray[i];
 
 	switch (ar5416_get_ntxchains(ah->txchainmask)) {
 	case 1:
 		break;
 	case 2:
-		ah->regulatory.max_power_level +=
+		regulatory->max_power_level +=
 			INCREASE_MAXPOW_BY_TWO_CHAIN;
 		break;
 	case 3:
-		ah->regulatory.max_power_level +=
+		regulatory->max_power_level +=
 			INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index 5211ad9..ae7fb5d 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -904,6 +904,7 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 #define REDUCE_SCALED_POWER_BY_TWO_CHAIN     6  /* 10*log10(2)*2 */
 #define REDUCE_SCALED_POWER_BY_THREE_CHAIN   10 /* 10*log10(3)*2 */
 
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	u16 twiceMaxEdgePower = AR5416_MAX_RATE_POWER;
 	static const u16 tpScaleReductionTable[5] =
@@ -953,9 +954,9 @@ static void ath9k_hw_set_def_power_per_rate_table(struct ath_hw *ah,
 
 	maxRegAllowedPower = twiceMaxRegulatoryPower + twiceLargestAntenna;
 
-	if (ah->regulatory.tp_scale != ATH9K_TP_SCALE_MAX) {
+	if (regulatory->tp_scale != ATH9K_TP_SCALE_MAX) {
 		maxRegAllowedPower -=
-			(tpScaleReductionTable[(ah->regulatory.tp_scale)] * 2);
+			(tpScaleReductionTable[(regulatory->tp_scale)] * 2);
 	}
 
 	scaledPower = min(powerLimit, maxRegAllowedPower);
@@ -1163,6 +1164,7 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 				    u8 powerLimit)
 {
 #define RT_AR_DELTA(x) (ratesArray[x] - cck_ofdm_delta)
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ar5416_eeprom_def *pEepData = &ah->eeprom.def;
 	struct modal_eep_header *pModal =
 		&(pEepData->modalHeader[IS_CHAN_2GHZ(chan)]);
@@ -1292,19 +1294,19 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		i = rateHt20_0;
 
 	if (AR_SREV_9280_10_OR_LATER(ah))
-		ah->regulatory.max_power_level =
+		regulatory->max_power_level =
 			ratesArray[i] + AR5416_PWR_TABLE_OFFSET * 2;
 	else
-		ah->regulatory.max_power_level = ratesArray[i];
+		regulatory->max_power_level = ratesArray[i];
 
 	switch(ar5416_get_ntxchains(ah->txchainmask)) {
 	case 1:
 		break;
 	case 2:
-		ah->regulatory.max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_TWO_CHAIN;
 		break;
 	case 3:
-		ah->regulatory.max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
+		regulatory->max_power_level += INCREASE_MAXPOW_BY_THREE_CHAIN;
 		break;
 	default:
 		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index df62113..4f3d5ea 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -439,8 +439,13 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 
 static void ath9k_hw_init_defaults(struct ath_hw *ah)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+
+	regulatory->country_code = CTRY_DEFAULT;
+	regulatory->power_limit = MAX_RATE_POWER;
+	regulatory->tp_scale = ATH9K_TP_SCALE_MAX;
+
 	ah->hw_version.magic = AR5416_MAGIC;
-	ah->regulatory.country_code = CTRY_DEFAULT;
 	ah->hw_version.subvendorid = 0;
 
 	ah->ah_flags = 0;
@@ -449,8 +454,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 	if (!AR_SREV_9100(ah))
 		ah->ah_flags = AH_USE_EEPROM;
 
-	ah->regulatory.power_limit = MAX_RATE_POWER;
-	ah->regulatory.tp_scale = ATH9K_TP_SCALE_MAX;
 	ah->atim_window = 0;
 	ah->sta_id1_defaults = AR_STA_ID1_CRPT_MIC_ENABLE;
 	ah->beacon_interval = 100;
@@ -1368,6 +1371,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 				struct ath9k_channel *chan,
 				enum ath9k_ht_macmode macmode)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	int i, regWrites = 0;
 	struct ieee80211_channel *channel = chan->chan;
 	u32 modesIndex, freqIndex;
@@ -1474,11 +1478,11 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 		ath9k_olc_init(ah);
 
 	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(&ah->regulatory, chan),
+				 ath9k_regd_get_ctl(regulatory, chan),
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				 (u32) ah->regulatory.power_limit));
+				 (u32) regulatory->power_limit));
 
 	if (!ath9k_hw_set_rf_regs(ah, chan, freqIndex)) {
 		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
@@ -1796,6 +1800,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 				    struct ath9k_channel *chan,
 				    enum ath9k_ht_macmode macmode)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ieee80211_channel *channel = chan->chan;
 	u32 synthDelay, qnum;
 
@@ -1828,11 +1833,11 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	}
 
 	ah->eep_ops->set_txpower(ah, chan,
-			     ath9k_regd_get_ctl(&ah->regulatory, chan),
+			     ath9k_regd_get_ctl(regulatory, chan),
 			     channel->max_antenna_gain * 2,
 			     channel->max_power * 2,
 			     min((u32) MAX_RATE_POWER,
-			     (u32) ah->regulatory.power_limit));
+			     (u32) regulatory->power_limit));
 
 	synthDelay = REG_READ(ah, AR_PHY_RX_DELAY) & AR_PHY_RX_DELAY_DELAY;
 	if (IS_CHAN_B(chan))
@@ -3480,27 +3485,29 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
+
 	u16 capField = 0, eeval;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
-	ah->regulatory.current_rd = eeval;
+	regulatory->current_rd = eeval;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
 	if (AR_SREV_9285_10_OR_LATER(ah))
 		eeval |= AR9285_RDEXT_DEFAULT;
-	ah->regulatory.current_rd_ext = eeval;
+	regulatory->current_rd_ext = eeval;
 
 	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
 
 	if (ah->opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
-		if (ah->regulatory.current_rd == 0x64 ||
-		    ah->regulatory.current_rd == 0x65)
-			ah->regulatory.current_rd += 5;
-		else if (ah->regulatory.current_rd == 0x41)
-			ah->regulatory.current_rd = 0x43;
+		if (regulatory->current_rd == 0x64 ||
+		    regulatory->current_rd == 0x65)
+			regulatory->current_rd += 5;
+		else if (regulatory->current_rd == 0x41)
+			regulatory->current_rd = 0x43;
 		DPRINTF(ah->ah_sc, ATH_DBG_REGULATORY,
-			"regdomain mapped to 0x%x\n", ah->regulatory.current_rd);
+			"regdomain mapped to 0x%x\n", regulatory->current_rd);
 	}
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_OP_MODE);
@@ -3635,7 +3642,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	else
 		pCap->hw_caps |= ATH9K_HW_CAP_4KB_SPLITTRANS;
 
-	if (ah->regulatory.current_rd_ext & (1 << REG_EXT_JAPAN_MIDBAND)) {
+	if (regulatory->current_rd_ext & (1 << REG_EXT_JAPAN_MIDBAND)) {
 		pCap->reg_cap =
 			AR_EEPROM_EEREGCAP_EN_KK_NEW_11A |
 			AR_EEPROM_EEREGCAP_EN_KK_U1_EVEN |
@@ -3664,6 +3671,7 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
 bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 			    u32 capability, u32 *result)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	switch (type) {
 	case ATH9K_CAP_CIPHER:
 		switch (capability) {
@@ -3712,13 +3720,13 @@ bool ath9k_hw_getcapability(struct ath_hw *ah, enum ath9k_capability_type type,
 		case 0:
 			return 0;
 		case 1:
-			*result = ah->regulatory.power_limit;
+			*result = regulatory->power_limit;
 			return 0;
 		case 2:
-			*result = ah->regulatory.max_power_level;
+			*result = regulatory->max_power_level;
 			return 0;
 		case 3:
-			*result = ah->regulatory.tp_scale;
+			*result = regulatory->tp_scale;
 			return 0;
 		}
 		return false;
@@ -3956,17 +3964,18 @@ bool ath9k_hw_disable(struct ath_hw *ah)
 
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit)
 {
+	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	struct ath9k_channel *chan = ah->curchan;
 	struct ieee80211_channel *channel = chan->chan;
 
-	ah->regulatory.power_limit = min(limit, (u32) MAX_RATE_POWER);
+	regulatory->power_limit = min(limit, (u32) MAX_RATE_POWER);
 
 	ah->eep_ops->set_txpower(ah, chan,
-				 ath9k_regd_get_ctl(&ah->regulatory, chan),
+				 ath9k_regd_get_ctl(regulatory, chan),
 				 channel->max_antenna_gain * 2,
 				 channel->max_power * 2,
 				 min((u32) MAX_RATE_POWER,
-				 (u32) ah->regulatory.power_limit));
+				 (u32) regulatory->power_limit));
 }
 
 void ath9k_hw_setmac(struct ath_hw *ah, const u8 *mac)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index de31a15..24b3063 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -396,7 +396,6 @@ struct ath_hw {
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
 	struct ath9k_hw_capabilities caps;
-	struct ath_regulatory regulatory;
 	struct ath9k_channel channels[38];
 	struct ath9k_channel *curchan;
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2f9c149..55fbce2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1293,7 +1293,7 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_regulatory *reg = &sc->sc_ah->regulatory;
+	struct ath_regulatory *reg = &sc->common.regulatory;
 
 	return ath_reg_notifier_apply(wiphy, request, reg);
 }
@@ -1586,12 +1586,12 @@ int ath_init_device(u16 devid, struct ath_softc *sc)
 
 	ath_set_hw_capab(sc, hw);
 
-	error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
+	error = ath_regd_init(&sc->common.regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
 	if (error)
 		return error;
 
-	reg = &sc->sc_ah->regulatory;
+	reg = &sc->common.regulatory;
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
diff --git a/drivers/net/wireless/ath/regd.h b/drivers/net/wireless/ath/regd.h
index 07291cc..4d3c536 100644
--- a/drivers/net/wireless/ath/regd.h
+++ b/drivers/net/wireless/ath/regd.h
@@ -18,9 +18,10 @@
 #define REGD_H
 
 #include <linux/nl80211.h>
-
 #include <net/cfg80211.h>
 
+#include "ath.h"
+
 #define NO_CTL 0xff
 #define SD_NO_CTL               0xE0
 #define NO_CTL                  0xff
@@ -47,29 +48,12 @@
 #define CHANNEL_HALF_BW         10
 #define CHANNEL_QUARTER_BW      5
 
-struct reg_dmn_pair_mapping {
-	u16 regDmnEnum;
-	u16 reg_5ghz_ctl;
-	u16 reg_2ghz_ctl;
-};
-
 struct country_code_to_enum_rd {
 	u16 countryCode;
 	u16 regDmnEnum;
 	const char *isoName;
 };
 
-struct ath_regulatory {
-	char alpha2[2];
-	u16 country_code;
-	u16 max_power_level;
-	u32 tp_scale;
-	u16 current_rd;
-	u16 current_rd_ext;
-	int16_t power_limit;
-	struct reg_dmn_pair_mapping *regpair;
-};
-
 enum CountryCode {
 	CTRY_ALBANIA = 8,
 	CTRY_ALGERIA = 12,
-- 
1.6.3.3

