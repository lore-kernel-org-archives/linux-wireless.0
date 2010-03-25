Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab0CYUo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 11/22] iwlwifi: move agn module parameter structure to common place
Date: Thu, 25 Mar 2010 13:44:39 -0700
Message-Id: <1269549890-19195-12-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

agn module parameter data structure shared by all agn devices, move it
iwl-agn-lib.c file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   31 ++++++++++-----------------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |   12 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    6 +++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 +
 5 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index cf0aa71..b941b3e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -237,7 +237,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -267,7 +267,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4d3dda1..6c09b24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -397,13 +397,6 @@ static const struct iwl_ops iwl5150_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-struct iwl_mod_params iwl50_mod_params = {
-	.amsdu_size_8K = 1,
-	.restart_fw = 1,
-	/* the rest are 0 by default */
-};
-
-
 struct iwl_cfg iwl5300_agn_cfg = {
 	.name = "Intel(R) Ultimate N WiFi Link 5300 AGN",
 	.fw_name_pre = IWL5000_FW_PRE,
@@ -416,7 +409,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -443,7 +436,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -470,7 +463,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -495,7 +488,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -522,7 +515,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -549,7 +542,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -576,7 +569,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = CSR50_ANA_PLL_CFG_VAL,
@@ -592,15 +585,15 @@ struct iwl_cfg iwl5150_abg_cfg = {
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
 
-module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, S_IRUGO);
+module_param_named(swcrypto50, iwlagn_mod_params.sw_crypto, bool, S_IRUGO);
 MODULE_PARM_DESC(swcrypto50,
 		  "using software crypto engine (default 0 [hardware])\n");
-module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, S_IRUGO);
+module_param_named(queues_num50, iwlagn_mod_params.num_of_queues, int, S_IRUGO);
 MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
-module_param_named(11n_disable50, iwl50_mod_params.disable_11n, int, S_IRUGO);
+module_param_named(11n_disable50, iwlagn_mod_params.disable_11n, int, S_IRUGO);
 MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality");
-module_param_named(amsdu_size_8K50, iwl50_mod_params.amsdu_size_8K,
+module_param_named(amsdu_size_8K50, iwlagn_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K50, "enable 8K amsdu size in 50XX series");
-module_param_named(fw_restart50, iwl50_mod_params.restart_fw, int, S_IRUGO);
+module_param_named(fw_restart50, iwlagn_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart50, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index cb9c2d6..f89e1c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -374,7 +374,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.pll_cfg_val = 0,
@@ -407,7 +407,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.pll_cfg_val = 0,
@@ -439,7 +439,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
 	.pll_cfg_val = 0,
@@ -471,7 +471,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
@@ -504,7 +504,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
 	.pll_cfg_val = 0,
@@ -536,7 +536,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.num_of_queues = IWLAGN_NUM_QUEUES,
 	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl50_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = 0,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index e4c0726..c826b7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -375,3 +375,9 @@ const u8 *iwlagn_eeprom_query_addr(const struct iwl_priv *priv,
 	BUG_ON(address >= priv->cfg->eeprom_size);
 	return &priv->eeprom[address];
 }
+
+struct iwl_mod_params iwlagn_mod_params = {
+	.amsdu_size_8K = 1,
+	.restart_fw = 1,
+	/* the rest are 0 by default */
+};
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index aa49e66..ad9b47e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -65,6 +65,7 @@
 
 #include "iwl-dev.h"
 
+extern struct iwl_mod_params iwlagn_mod_params;
 extern struct iwl_ucode_ops iwlagn_ucode;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
-- 
1.6.3.3

