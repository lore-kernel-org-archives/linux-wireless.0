Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20116 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab2CDUnI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 15:43:08 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 063/101] iwlwifi: remove PA type configuration
Date: Sun,  4 Mar 2012 11:29:17 -0800
Message-Id: <1330889395-533-64-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120304_214507_977170_8B282F11)
In-Reply-To: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1330889395-533-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

No need to have a special config variable
for the PA type, we can just use the
additional NIC config function to config
the hardware correctly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   17 +++++++++--------
 drivers/net/wireless/iwlwifi/iwl-shared.h |   12 ------------
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 1e29a51..6f7d5f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -96,20 +96,21 @@ static void iwl6150_additional_nic_config(struct iwl_priv *priv)
 		    CSR_GP_DRIVER_REG_BIT_6050_1x2);
 }
 
+static void iwl6000i_additional_nic_config(struct iwl_priv *priv)
+{
+	/* 2x2 IPA phy type */
+	iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
+		     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
+}
+
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
 	iwl_rf_config(priv);
 
-	/* no locking required for register write */
-	if (cfg(priv)->pa_type == IWL_PA_INTERNAL) {
-		/* 2x2 IPA phy type */
-		iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
-			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
-	}
 	/* do additional nic configuration if needed */
 	if (cfg(priv)->additional_nic_config)
-			cfg(priv)->additional_nic_config(priv);
+		cfg(priv)->additional_nic_config(priv);
 }
 
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
@@ -471,8 +472,8 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
 	.lib = &iwl6000_lib,					\
+	.additional_nic_config = iwl6000i_additional_nic_config,\
 	.base_params = &iwl6000_base_params,			\
-	.pa_type = IWL_PA_INTERNAL,				\
 	.led_mode = IWL_LED_BLINK
 
 const struct iwl_cfg iwl6000i_2agn_cfg = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 55f9f07..2ab7462 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -209,16 +209,6 @@ enum iwl_ucode_type {
 	IWL_UCODE_WOWLAN,
 };
 
-/**
- * enum iwl_pa_type - Power Amplifier type
- * @IWL_PA_SYSTEM:  based on uCode configuration
- * @IWL_PA_INTERNAL: use Internal only
- */
-enum iwl_pa_type {
-	IWL_PA_SYSTEM = 0,
-	IWL_PA_INTERNAL = 1,
-};
-
 /*
  * LED mode
  *    IWL_LED_DEFAULT:  use device default
@@ -299,7 +289,6 @@ struct iwl_base_params {
  * @base_params: pointer to basic parameters
  * @ht_params: point to ht patameters
  * @bt_params: pointer to bt parameters
- * @pa_type: used by 6000 series only to identify the type of Power Amplifier
  * @need_temp_offset_calib: need to perform temperature offset calibration
  * @no_xtal_calib: some devices do not need crystal calibration data,
  *	don't send it to those
@@ -339,7 +328,6 @@ struct iwl_cfg {
 	/* params likely to change within a device family */
 	const struct iwl_ht_params *ht_params;
 	const struct iwl_bt_params *bt_params;
-	enum iwl_pa_type pa_type;	  /* if used set to IWL_PA_SYSTEM */
 	const bool need_temp_offset_calib; /* if used set to true */
 	const bool no_xtal_calib;
 	u8 scan_rx_antennas[IEEE80211_NUM_BANDS];
-- 
1.7.0.4

