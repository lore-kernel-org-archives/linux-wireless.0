Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48416 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2DJAuZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/11] iwlwifi: introduce device family enum
Date: Mon,  9 Apr 2012 17:47:00 -0700
Message-Id: <1334018821-30416-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025036_330315_0CD6CE81)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will later be used to dynamically bind
the configuration data for DVM and MVM.

For now, we can use it to get rid of the
additional_nic_config() hook.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    2 +
 drivers/net/wireless/iwlwifi/iwl-2000.c   |    4 ++
 drivers/net/wireless/iwlwifi/iwl-5000.c   |    3 +
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   64 +++++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-config.h |   22 +++++++++-
 5 files changed, 61 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index b131f9d..66f86c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -180,6 +180,7 @@ static const struct iwl_ht_params iwl1000_ht_params = {
 	.ucode_api_max = IWL1000_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL1000_UCODE_API_OK,			\
 	.ucode_api_min = IWL1000_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_1000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
@@ -204,6 +205,7 @@ const struct iwl_cfg iwl1000_bg_cfg = {
 	.ucode_api_max = IWL100_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL100_UCODE_API_OK,			\
 	.ucode_api_min = IWL100_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_100,			\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index d4c495e..cedec43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -223,6 +223,7 @@ static const struct iwl_bt_params iwl2030_bt_params = {
 	.ucode_api_max = IWL2000_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL2000_UCODE_API_OK,			\
 	.ucode_api_min = IWL2000_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_2000,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
@@ -250,6 +251,7 @@ const struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL2030_UCODE_API_OK,			\
 	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_2030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
@@ -273,6 +275,7 @@ const struct iwl_cfg iwl2030_2bgn_cfg = {
 	.ucode_api_max = IWL105_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL105_UCODE_API_OK,			\
 	.ucode_api_min = IWL105_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_105,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
@@ -302,6 +305,7 @@ const struct iwl_cfg iwl105_bgn_d_cfg = {
 	.ucode_api_max = IWL135_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL135_UCODE_API_OK,			\
 	.ucode_api_min = IWL135_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_135,			\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 056d552..55294a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -325,6 +325,7 @@ static const struct iwl_ht_params iwl5000_ht_params = {
 	.fw_name_pre = IWL5000_FW_PRE,				\
 	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
 	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_5000,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
@@ -370,6 +371,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
+	.device_family = IWL_DEVICE_FAMILY_5000,
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
@@ -385,6 +387,7 @@ const struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name_pre = IWL5150_FW_PRE,				\
 	.ucode_api_max = IWL5150_UCODE_API_MAX,			\
 	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_5150,		\
 	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
 	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 5c8987b..f124ec6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -78,39 +78,38 @@ static void iwl6000_set_ct_threshold(struct iwl_priv *priv)
 	priv->hw_params.ct_kill_exit_threshold = CT_KILL_EXIT_THRESHOLD;
 }
 
-static void iwl6050_additional_nic_config(struct iwl_priv *priv)
-{
-	/* Indicate calibration version to uCode. */
-	if (iwl_eeprom_calib_version(priv) >= 6)
-		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-}
-
-static void iwl6150_additional_nic_config(struct iwl_priv *priv)
-{
-	/* Indicate calibration version to uCode. */
-	if (iwl_eeprom_calib_version(priv) >= 6)
-		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-				CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
-	iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
-		    CSR_GP_DRIVER_REG_BIT_6050_1x2);
-}
-
-static void iwl6000i_additional_nic_config(struct iwl_priv *priv)
-{
-	/* 2x2 IPA phy type */
-	iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
-		     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
-}
-
 /* NIC configuration for 6000 series */
 static void iwl6000_nic_config(struct iwl_priv *priv)
 {
 	iwl_rf_config(priv);
 
-	/* do additional nic configuration if needed */
-	if (cfg(priv)->additional_nic_config)
-		cfg(priv)->additional_nic_config(priv);
+	switch (cfg(priv)->device_family) {
+	case IWL_DEVICE_FAMILY_6005:
+	case IWL_DEVICE_FAMILY_6030:
+	case IWL_DEVICE_FAMILY_6000:
+		break;
+	case IWL_DEVICE_FAMILY_6000i:
+		/* 2x2 IPA phy type */
+		iwl_write32(trans(priv), CSR_GP_DRIVER_REG,
+			     CSR_GP_DRIVER_REG_BIT_RADIO_SKU_2x2_IPA);
+		break;
+	case IWL_DEVICE_FAMILY_6050:
+		/* Indicate calibration version to uCode. */
+		if (iwl_eeprom_calib_version(priv) >= 6)
+			iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
+		break;
+	case IWL_DEVICE_FAMILY_6150:
+		/* Indicate calibration version to uCode. */
+		if (iwl_eeprom_calib_version(priv) >= 6)
+			iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+					CSR_GP_DRIVER_REG_BIT_CALIB_VERSION6);
+		iwl_set_bit(trans(priv), CSR_GP_DRIVER_REG,
+			    CSR_GP_DRIVER_REG_BIT_6050_1x2);
+		break;
+	default:
+		WARN_ON(1);
+	}
 }
 
 static const struct iwl_sensitivity_ranges iwl6000_sensitivity = {
@@ -333,6 +332,7 @@ static const struct iwl_bt_params iwl6000_bt_params = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
 	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
+	.device_family = IWL_DEVICE_FAMILY_6005,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
@@ -387,6 +387,7 @@ const struct iwl_cfg iwl6005_2agn_mow2_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
 	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
+	.device_family = IWL_DEVICE_FAMILY_6030,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
@@ -458,6 +459,7 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL6000_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_6000i,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
@@ -465,7 +467,6 @@ const struct iwl_cfg iwl130_bg_cfg = {
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,	\
 	.lib = &iwl6000_lib,					\
-	.additional_nic_config = iwl6000i_additional_nic_config,\
 	.base_params = &iwl6000_base_params,			\
 	.led_mode = IWL_LED_BLINK
 
@@ -489,12 +490,12 @@ const struct iwl_cfg iwl6000i_2bg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,				\
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_6050,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.lib = &iwl6000_lib,					\
-	.additional_nic_config = iwl6050_additional_nic_config,	\
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -516,10 +517,10 @@ const struct iwl_cfg iwl6050_2abg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,				\
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_6150,		\
 	.max_inst_size = IWL60_RTC_INST_SIZE,			\
 	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.lib = &iwl6000_lib,					\
-	.additional_nic_config = iwl6150_additional_nic_config,	\
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6150_TX_POWER_VERSION,	\
 	.base_params = &iwl6050_base_params,			\
@@ -543,6 +544,7 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_ok = IWL6000_UCODE_API_OK,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.device_family = IWL_DEVICE_FAMILY_6000,
 	.max_inst_size = IWL60_RTC_INST_SIZE,
 	.max_data_size = IWL60_RTC_DATA_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index c50b428..bdf2a77 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -66,10 +66,27 @@
 #include <linux/types.h>
 #include <net/mac80211.h>
 
-struct iwl_priv;
 struct iwl_lib_ops;
 
 
+enum iwl_device_family {
+	IWL_DEVICE_FAMILY_UNDEFINED,
+	IWL_DEVICE_FAMILY_1000,
+	IWL_DEVICE_FAMILY_100,
+	IWL_DEVICE_FAMILY_2000,
+	IWL_DEVICE_FAMILY_2030,
+	IWL_DEVICE_FAMILY_105,
+	IWL_DEVICE_FAMILY_135,
+	IWL_DEVICE_FAMILY_5000,
+	IWL_DEVICE_FAMILY_5150,
+	IWL_DEVICE_FAMILY_6000,
+	IWL_DEVICE_FAMILY_6000i,
+	IWL_DEVICE_FAMILY_6005,
+	IWL_DEVICE_FAMILY_6030,
+	IWL_DEVICE_FAMILY_6050,
+	IWL_DEVICE_FAMILY_6150,
+};
+
 /*
  * LED mode
  *    IWL_LED_DEFAULT:  use device default
@@ -165,7 +182,6 @@ struct iwl_ht_params {
  * @eeprom_ver: EEPROM version
  * @eeprom_calib_ver: EEPROM calibration version
  * @lib: pointer to the lib ops
- * @additional_nic_config: additional nic configuration
  * @base_params: pointer to basic parameters
  * @ht_params: point to ht patameters
  * @bt_params: pointer to bt parameters
@@ -189,6 +205,7 @@ struct iwl_cfg {
 	const unsigned int ucode_api_max;
 	const unsigned int ucode_api_ok;
 	const unsigned int ucode_api_min;
+	const enum iwl_device_family device_family;
 	const u32 max_data_size;
 	const u32 max_inst_size;
 	u8   valid_tx_ant;
@@ -196,7 +213,6 @@ struct iwl_cfg {
 	u16  eeprom_ver;
 	u16  eeprom_calib_ver;
 	const struct iwl_lib_ops *lib;
-	void (*additional_nic_config)(struct iwl_priv *priv);
 	/* params not likely to change within a device family */
 	const struct iwl_base_params *base_params;
 	/* params likely to change within a device family */
-- 
1.7.0.4

