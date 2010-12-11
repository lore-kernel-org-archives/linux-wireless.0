Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42427 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0LKXvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Dec 2010 18:51:36 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3 5/8] ath9k_hw: remove antenna configuration eeprom ops and variables
Date: Sun, 12 Dec 2010 00:51:11 +0100
Message-Id: <1292111474-70939-5-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292111474-70939-4-git-send-email-nbd@openwrt.org>
References: <1292111474-70939-1-git-send-email-nbd@openwrt.org>
 <1292111474-70939-2-git-send-email-nbd@openwrt.org>
 <1292111474-70939-3-git-send-email-nbd@openwrt.org>
 <1292111474-70939-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9280 based hardware with 3 antennas and slow antenna diversity has
not been seen in the wild and ath9k does not support that form of
antenna diversity, so remove the EEPROM ops for it.
These EEPROM ops are currently only used for setting the
AR_PHY_SWITCH_COM register, which is being done in the EEPROM specific
file already.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |   14 ----------
 drivers/net/wireless/ath/ath9k/eeprom.h        |    4 ---
 drivers/net/wireless/ath/ath9k/eeprom_4k.c     |   20 +-------------
 drivers/net/wireless/ath/ath9k/eeprom_9287.c   |   20 +-------------
 drivers/net/wireless/ath/ath9k/eeprom_def.c    |   33 +-----------------------
 drivers/net/wireless/ath/ath9k/hw.c            |    5 ---
 drivers/net/wireless/ath/ath9k/hw.h            |    2 -
 7 files changed, 3 insertions(+), 95 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 2fc3260..5ad37d0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3427,18 +3427,6 @@ static int ath9k_hw_ar9300_get_eeprom_rev(struct ath_hw *ah)
 	return 0;
 }
 
-static u8 ath9k_hw_ar9300_get_num_ant_config(struct ath_hw *ah,
-					     enum ath9k_hal_freq_band freq_band)
-{
-	return 1;
-}
-
-static u32 ath9k_hw_ar9300_get_eeprom_antenna_cfg(struct ath_hw *ah,
-						  struct ath9k_channel *chan)
-{
-	return -EINVAL;
-}
-
 static s32 ar9003_hw_xpa_bias_level_get(struct ath_hw *ah, bool is2ghz)
 {
 	struct ar9300_eeprom *eep = &ah->eeprom.ar9300_eep;
@@ -4848,8 +4836,6 @@ const struct eeprom_ops eep_ar9300_ops = {
 	.fill_eeprom = ath9k_hw_ar9300_fill_eeprom,
 	.get_eeprom_ver = ath9k_hw_ar9300_get_eeprom_ver,
 	.get_eeprom_rev = ath9k_hw_ar9300_get_eeprom_rev,
-	.get_num_ant_config = ath9k_hw_ar9300_get_num_ant_config,
-	.get_eeprom_antenna_cfg = ath9k_hw_ar9300_get_eeprom_antenna_cfg,
 	.set_board_values = ath9k_hw_ar9300_set_board_values,
 	.set_addac = ath9k_hw_ar9300_set_addac,
 	.set_txpower = ath9k_hw_ar9300_set_txpower,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
index 1f6b7128..f6f09d1 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom.h
+++ b/drivers/net/wireless/ath/ath9k/eeprom.h
@@ -649,10 +649,6 @@ struct eeprom_ops {
 	bool (*fill_eeprom)(struct ath_hw *hw);
 	int (*get_eeprom_ver)(struct ath_hw *hw);
 	int (*get_eeprom_rev)(struct ath_hw *hw);
-	u8 (*get_num_ant_config)(struct ath_hw *hw,
-				 enum ath9k_hal_freq_band band);
-	u32 (*get_eeprom_antenna_cfg)(struct ath_hw *hw,
-				      struct ath9k_channel *chan);
 	void (*set_board_values)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_addac)(struct ath_hw *hw, struct ath9k_channel *chan);
 	void (*set_txpower)(struct ath_hw *hw, struct ath9k_channel *chan,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_4k.c b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
index b0f7446..fbdff7e 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_4k.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_4k.c
@@ -770,8 +770,7 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	pModal = &eep->modalHeader;
 	txRxAttenLocal = 23;
 
-	REG_WRITE(ah, AR_PHY_SWITCH_COM,
-		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
+	REG_WRITE(ah, AR_PHY_SWITCH_COM, pModal->antCtrlCommon);
 
 	/* Single chain for 4K EEPROM*/
 	ath9k_hw_4k_set_gain(ah, pModal, eep, txRxAttenLocal);
@@ -987,21 +986,6 @@ static void ath9k_hw_4k_set_board_values(struct ath_hw *ah,
 	}
 }
 
-static u32 ath9k_hw_4k_get_eeprom_antenna_cfg(struct ath_hw *ah,
-					      struct ath9k_channel *chan)
-{
-	struct ar5416_eeprom_4k *eep = &ah->eeprom.map4k;
-	struct modal_eep_4k_header *pModal = &eep->modalHeader;
-
-	return pModal->antCtrlCommon;
-}
-
-static u8 ath9k_hw_4k_get_num_ant_config(struct ath_hw *ah,
-					 enum ath9k_hal_freq_band freq_band)
-{
-	return 1;
-}
-
 static u16 ath9k_hw_4k_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_MAP4K_SPURCHAN \
@@ -1038,8 +1022,6 @@ const struct eeprom_ops eep_4k_ops = {
 	.fill_eeprom		= ath9k_hw_4k_fill_eeprom,
 	.get_eeprom_ver		= ath9k_hw_4k_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_4k_get_eeprom_rev,
-	.get_num_ant_config	= ath9k_hw_4k_get_num_ant_config,
-	.get_eeprom_antenna_cfg	= ath9k_hw_4k_get_eeprom_antenna_cfg,
 	.set_board_values	= ath9k_hw_4k_set_board_values,
 	.set_addac		= ath9k_hw_4k_set_addac,
 	.set_txpower		= ath9k_hw_4k_set_txpower,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 868faf9..9b6bc8a 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -866,8 +866,7 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 		antWrites[j++] = (u16)(pModal->antCtrlChain[i] & 0x3);
 	}
 
-	REG_WRITE(ah, AR_PHY_SWITCH_COM,
-		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
+	REG_WRITE(ah, AR_PHY_SWITCH_COM, pModal->antCtrlCommon);
 
 	for (i = 0; i < AR9287_MAX_CHAINS; i++)	{
 		regChainOffset = i * 0x1000;
@@ -968,21 +967,6 @@ static void ath9k_hw_ar9287_set_board_values(struct ath_hw *ah,
 				  pModal->xpaBiasLvl);
 }
 
-static u8 ath9k_hw_ar9287_get_num_ant_config(struct ath_hw *ah,
-					     enum ath9k_hal_freq_band freq_band)
-{
-	return 1;
-}
-
-static u32 ath9k_hw_ar9287_get_eeprom_antenna_cfg(struct ath_hw *ah,
-						  struct ath9k_channel *chan)
-{
-	struct ar9287_eeprom *eep = &ah->eeprom.map9287;
-	struct modal_eep_ar9287_header *pModal = &eep->modalHeader;
-
-	return pModal->antCtrlCommon;
-}
-
 static u16 ath9k_hw_ar9287_get_spur_channel(struct ath_hw *ah,
 					    u16 i, bool is2GHz)
 {
@@ -1020,8 +1004,6 @@ const struct eeprom_ops eep_ar9287_ops = {
 	.fill_eeprom		= ath9k_hw_ar9287_fill_eeprom,
 	.get_eeprom_ver		= ath9k_hw_ar9287_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_ar9287_get_eeprom_rev,
-	.get_num_ant_config	= ath9k_hw_ar9287_get_num_ant_config,
-	.get_eeprom_antenna_cfg	= ath9k_hw_ar9287_get_eeprom_antenna_cfg,
 	.set_board_values	= ath9k_hw_ar9287_set_board_values,
 	.set_addac		= ath9k_hw_ar9287_set_addac,
 	.set_txpower		= ath9k_hw_ar9287_set_txpower,
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_def.c b/drivers/net/wireless/ath/ath9k/eeprom_def.c
index ad3e234..088f141 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_def.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_def.c
@@ -374,8 +374,7 @@ static void ath9k_hw_def_set_board_values(struct ath_hw *ah,
 	pModal = &(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
 	txRxAttenLocal = IS_CHAN_2GHZ(chan) ? 23 : 44;
 
-	REG_WRITE(ah, AR_PHY_SWITCH_COM,
-		  ah->eep_ops->get_eeprom_antenna_cfg(ah, chan));
+	REG_WRITE(ah, AR_PHY_SWITCH_COM, pModal->antCtrlCommon & 0xffff);
 
 	for (i = 0; i < AR5416_MAX_CHAINS; i++) {
 		if (AR_SREV_9280(ah)) {
@@ -1264,34 +1263,6 @@ static void ath9k_hw_def_set_txpower(struct ath_hw *ah,
 		  | ATH9K_POW_SM(pModal->pwrDecreaseFor2Chain, 0));
 }
 
-static u8 ath9k_hw_def_get_num_ant_config(struct ath_hw *ah,
-					  enum ath9k_hal_freq_band freq_band)
-{
-	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
-	struct modal_eep_header *pModal =
-		&(eep->modalHeader[freq_band]);
-	struct base_eep_header *pBase = &eep->baseEepHeader;
-	u8 num_ant_config;
-
-	num_ant_config = 1;
-
-	if (pBase->version >= 0x0E0D &&
-	    (pModal->lna_ctl & LNA_CTL_USE_ANT1))
-		num_ant_config += 1;
-
-	return num_ant_config;
-}
-
-static u32 ath9k_hw_def_get_eeprom_antenna_cfg(struct ath_hw *ah,
-					       struct ath9k_channel *chan)
-{
-	struct ar5416_eeprom_def *eep = &ah->eeprom.def;
-	struct modal_eep_header *pModal =
-		&(eep->modalHeader[IS_CHAN_2GHZ(chan)]);
-
-	return pModal->antCtrlCommon;
-}
-
 static u16 ath9k_hw_def_get_spur_channel(struct ath_hw *ah, u16 i, bool is2GHz)
 {
 #define EEP_DEF_SPURCHAN \
@@ -1328,8 +1299,6 @@ const struct eeprom_ops eep_def_ops = {
 	.fill_eeprom		= ath9k_hw_def_fill_eeprom,
 	.get_eeprom_ver		= ath9k_hw_def_get_eeprom_ver,
 	.get_eeprom_rev		= ath9k_hw_def_get_eeprom_rev,
-	.get_num_ant_config	= ath9k_hw_def_get_num_ant_config,
-	.get_eeprom_antenna_cfg	= ath9k_hw_def_get_eeprom_antenna_cfg,
 	.set_board_values	= ath9k_hw_def_set_board_values,
 	.set_addac		= ath9k_hw_def_set_addac,
 	.set_txpower		= ath9k_hw_def_set_txpower,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7bc6d22..f2298f2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1916,11 +1916,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	    AR_SREV_5416(ah))
 		pCap->reg_cap |= AR_EEPROM_EEREGCAP_EN_FCC_MIDBAND;
 
-	pCap->num_antcfg_5ghz =
-		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_5GHZ);
-	pCap->num_antcfg_2ghz =
-		ah->eep_ops->get_num_ant_config(ah, ATH9K_HAL_FREQ_BAND_2GHZ);
-
 	if (AR_SREV_9280_20_OR_LATER(ah) && common->btcoex_enabled) {
 		btcoex_hw->btactive_gpio = ATH_BTACTIVE_GPIO;
 		btcoex_hw->wlanactive_gpio = ATH_WLANACTIVE_GPIO;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 157e6bc..910d3c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -204,8 +204,6 @@ struct ath9k_hw_capabilities {
 	u16 tx_triglevel_max;
 	u16 reg_cap;
 	u8 num_gpio_pins;
-	u8 num_antcfg_2ghz;
-	u8 num_antcfg_5ghz;
 	u8 rx_hp_qdepth;
 	u8 rx_lp_qdepth;
 	u8 rx_status_len;
-- 
1.7.3.2

