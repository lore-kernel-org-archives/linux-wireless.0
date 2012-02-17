Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:10956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab2BQUXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 15:23:55 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 24/26] iwlwifi: SRAM size moves from hw_params to cfg
Date: Fri, 17 Feb 2012 11:13:52 -0800
Message-Id: <1329506034-1394-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120217_212425_930565_848772E1)
In-Reply-To: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1329506034-1394-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This will allow to set the hw_params after we fetch the uCode.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c   |    6 ++++--
 drivers/net/wireless/iwlwifi/iwl-2000.c   |   10 ++++++++--
 drivers/net/wireless/iwlwifi/iwl-5000.c   |   10 ++++++----
 drivers/net/wireless/iwlwifi/iwl-6000.c   |   14 ++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-shared.h |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-ucode.c  |    8 ++++----
 6 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 91c4a72..605ee3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -128,8 +128,6 @@ static void iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
-	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
@@ -191,6 +189,8 @@ static struct iwl_ht_params iwl1000_ht_params = {
 	.ucode_api_max = IWL1000_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL1000_UCODE_API_OK,			\
 	.ucode_api_min = IWL1000_UCODE_API_MIN,			\
+	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
+	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.lib = &iwl1000_lib,					\
@@ -213,6 +213,8 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.ucode_api_max = IWL100_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL100_UCODE_API_OK,			\
 	.ucode_api_min = IWL100_UCODE_API_MIN,			\
+	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
+	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,	\
 	.lib = &iwl1000_lib,					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 75f0e50..e6e8c79 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -124,8 +124,6 @@ static void iwl2000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
-	hw_params(priv).max_inst_size = IWL60_RTC_INST_SIZE;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ);
 
@@ -240,6 +238,8 @@ static struct iwl_bt_params iwl2030_bt_params = {
 	.ucode_api_max = IWL2000_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL2000_UCODE_API_OK,			\
 	.ucode_api_min = IWL2000_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.lib = &iwl2000_lib,					\
@@ -266,6 +266,8 @@ struct iwl_cfg iwl2000_2bgn_d_cfg = {
 	.ucode_api_max = IWL2030_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL2030_UCODE_API_OK,			\
 	.ucode_api_min = IWL2030_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.lib = &iwl2030_lib,					\
@@ -288,6 +290,8 @@ struct iwl_cfg iwl2030_2bgn_cfg = {
 	.ucode_api_max = IWL105_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL105_UCODE_API_OK,			\
 	.ucode_api_min = IWL105_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.lib = &iwl2000_lib,					\
@@ -316,6 +320,8 @@ struct iwl_cfg iwl105_bgn_d_cfg = {
 	.ucode_api_max = IWL135_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL135_UCODE_API_OK,			\
 	.ucode_api_min = IWL135_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_2000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_2000_TX_POWER_VERSION,	\
 	.lib = &iwl2030_lib,					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 458e677..1527dec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -170,8 +170,6 @@ static void iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
-	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
@@ -195,8 +193,6 @@ static void iwl5150_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	hw_params(priv).max_data_size = IWLAGN_RTC_DATA_SIZE;
-	hw_params(priv).max_inst_size = IWLAGN_RTC_INST_SIZE;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
@@ -352,6 +348,8 @@ static struct iwl_ht_params iwl5000_ht_params = {
 	.fw_name_pre = IWL5000_FW_PRE,				\
 	.ucode_api_max = IWL5000_UCODE_API_MAX,			\
 	.ucode_api_min = IWL5000_UCODE_API_MIN,			\
+	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
+	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,	\
 	.lib = &iwl5000_lib,					\
@@ -395,6 +393,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
+	.max_inst_size = IWLAGN_RTC_INST_SIZE,
+	.max_data_size = IWLAGN_RTC_DATA_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.lib = &iwl5000_lib,
@@ -408,6 +408,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name_pre = IWL5150_FW_PRE,				\
 	.ucode_api_max = IWL5150_UCODE_API_MAX,			\
 	.ucode_api_min = IWL5150_UCODE_API_MIN,			\
+	.max_inst_size = IWLAGN_RTC_INST_SIZE,			\
+	.max_data_size = IWLAGN_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,	\
 	.lib = &iwl5150_lib,					\
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 19e4103..1e6fbf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -145,8 +145,6 @@ static void iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 			iwlagn_mod_params.num_of_queues;
 
 	hw_params(priv).max_txq_num = cfg(priv)->base_params->num_of_queues;
-	hw_params(priv).max_data_size = IWL60_RTC_DATA_SIZE;
-	hw_params(priv).max_inst_size = IWL60_RTC_INST_SIZE;
 
 	hw_params(priv).ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
@@ -348,6 +346,8 @@ static struct iwl_bt_params iwl6000_bt_params = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
 	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_6005_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6005_TX_POWER_VERSION,	\
 	.lib = &iwl6000_lib,					\
@@ -388,6 +388,8 @@ struct iwl_cfg iwl6005_2agn_d_cfg = {
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,		\
 	.ucode_api_ok = IWL6000G2_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,		\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.eeprom_ver = EEPROM_6030_EEPROM_VERSION,		\
 	.eeprom_calib_ver = EEPROM_6030_TX_POWER_VERSION,	\
 	.lib = &iwl6030_lib,					\
@@ -457,6 +459,8 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,			\
 	.ucode_api_ok = IWL6000_UCODE_API_OK,			\
 	.ucode_api_min = IWL6000_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */	\
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,		\
@@ -486,6 +490,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,				\
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.valid_tx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */	\
 	.lib = &iwl6000_lib,					\
@@ -511,6 +517,8 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,				\
 	.ucode_api_max = IWL6050_UCODE_API_MAX,			\
 	.ucode_api_min = IWL6050_UCODE_API_MIN,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
 	.lib = &iwl6000_lib,					\
 	.additional_nic_config = iwl6150_additional_nic_config,	\
 	.eeprom_ver = EEPROM_6150_EEPROM_VERSION,		\
@@ -536,6 +544,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_ok = IWL6000_UCODE_API_OK,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.max_inst_size = IWL60_RTC_INST_SIZE,
+	.max_data_size = IWL60_RTC_DATA_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.lib = &iwl6000_lib,
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8c6fc6e..f810b41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -173,8 +173,6 @@ struct iwl_mod_params {
  * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
  * @sku: sku read from EEPROM
  * @rx_page_order: Rx buffer page order
- * @max_inst_size: for ucode use
- * @max_data_size: for ucode use
  * @ct_kill_threshold: temperature threshold - in hw dependent unit
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
  *	relevant for 1000, 6000 and up
@@ -192,8 +190,6 @@ struct iwl_hw_params {
 	bool shadow_reg_enable;
 	u16 sku;
 	u32 rx_page_order;
-	u32 max_inst_size;
-	u32 max_data_size;
 	u32 ct_kill_threshold;
 	u32 ct_kill_exit_threshold;
 	unsigned int wd_timeout;
@@ -283,6 +279,8 @@ enum iwl_led_mode {
  * @ucode_api_ok: oldest version of the uCode API that is OK to load
  *	without a warning, for use in transitions
  * @ucode_api_min: Lowest version of uCode API supported by driver.
+ * @max_inst_size: The maximal length of the fw inst section
+ * @max_data_size: The maximal length of the fw data section
  * @valid_tx_ant: valid transmit antenna
  * @valid_rx_ant: valid receive antenna
  * @sku: sku information from EEPROM
@@ -320,6 +318,8 @@ struct iwl_cfg {
 	const unsigned int ucode_api_max;
 	const unsigned int ucode_api_ok;
 	const unsigned int ucode_api_min;
+	const u32 max_data_size;
+	const u32 max_inst_size;
 	u8   valid_tx_ant;
 	u8   valid_rx_ant;
 	u16  sku;
diff --git a/drivers/net/wireless/iwlwifi/iwl-ucode.c b/drivers/net/wireless/iwlwifi/iwl-ucode.c
index 9e21fc1..61c6c05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-ucode.c
@@ -1135,25 +1135,25 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 		       pieces.init_data_size);
 
 	/* Verify that uCode images will fit in card's SRAM */
-	if (pieces.inst_size > hw_params(nic).max_inst_size) {
+	if (pieces.inst_size > cfg->max_inst_size) {
 		IWL_ERR(nic, "uCode instr len %Zd too large to fit in\n",
 			pieces.inst_size);
 		goto try_again;
 	}
 
-	if (pieces.data_size > hw_params(nic).max_data_size) {
+	if (pieces.data_size > cfg->max_data_size) {
 		IWL_ERR(nic, "uCode data len %Zd too large to fit in\n",
 			pieces.data_size);
 		goto try_again;
 	}
 
-	if (pieces.init_size > hw_params(nic).max_inst_size) {
+	if (pieces.init_size > cfg->max_inst_size) {
 		IWL_ERR(nic, "uCode init instr len %Zd too large to fit in\n",
 			pieces.init_size);
 		goto try_again;
 	}
 
-	if (pieces.init_data_size > hw_params(nic).max_data_size) {
+	if (pieces.init_data_size > cfg->max_data_size) {
 		IWL_ERR(nic, "uCode init data len %Zd too large to fit in\n",
 			pieces.init_data_size);
 		goto try_again;
-- 
1.7.0.4

