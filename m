Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:11039 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab0KYBi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:28 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/12] iwlwifi: use antenna information in EEPROM
Date: Wed, 24 Nov 2010 17:32:38 -0800
Message-Id: <1290648768-10075-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The valid tx/rx antenna information is part of EEPROM, so use it
to configure the device.

For few cases, the EEPROM did not reflect the correct antenna, but
it is too late to modify the EEPROM, so overwrite with .cfg parameters

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c       |    8 -----
 drivers/net/wireless/iwlwifi/iwl-4965.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl-5000.c       |   20 +++--------
 drivers/net/wireless/iwlwifi/iwl-6000.c       |   42 +++---------------------
 drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c |   20 ++++++++++++
 5 files changed, 32 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 3100a72..9170120 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -278,8 +278,6 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.ops = &iwl1000_ops,
@@ -294,8 +292,6 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.fw_name_pre = IWL1000_FW_PRE,
 	.ucode_api_max = IWL1000_UCODE_API_MAX,
 	.ucode_api_min = IWL1000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.ops = &iwl1000_ops,
@@ -309,8 +305,6 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.fw_name_pre = IWL100_FW_PRE,
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.ops = &iwl1000_ops,
@@ -325,8 +319,6 @@ struct iwl_cfg iwl100_bg_cfg = {
 	.fw_name_pre = IWL100_FW_PRE,
 	.ucode_api_max = IWL100_UCODE_API_MAX,
 	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_1000_TX_POWER_VERSION,
 	.ops = &iwl1000_ops,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6788ceb..9f1d8d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2624,8 +2624,6 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.fw_name_pre = IWL4965_FW_PRE,
 	.ucode_api_max = IWL4965_UCODE_API_MAX,
 	.ucode_api_min = IWL4965_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_4965_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_4965_TX_POWER_VERSION,
 	.ops = &iwl4965_ops,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 3ee0f7c..cf74edb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -527,8 +527,6 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_ABC,
-	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.ops = &iwl5000_ops,
@@ -543,8 +541,8 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_B,
-	.valid_rx_ant = ANT_AB,
+	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
+	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.ops = &iwl5000_ops,
@@ -559,8 +557,8 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_B,
-	.valid_rx_ant = ANT_AB,
+	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
+	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.ops = &iwl5000_ops,
@@ -574,8 +572,8 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_B,
-	.valid_rx_ant = ANT_AB,
+	.valid_tx_ant = ANT_B,		/* .cfg overwrite */
+	.valid_rx_ant = ANT_AB,		/* .cfg overwrite */
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.ops = &iwl5000_ops,
@@ -590,8 +588,6 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name_pre = IWL5000_FW_PRE,
 	.ucode_api_max = IWL5000_UCODE_API_MAX,
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_ABC,
-	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.ops = &iwl5000_ops,
@@ -606,8 +602,6 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.fw_name_pre = IWL5150_FW_PRE,
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.ops = &iwl5150_ops,
@@ -623,8 +617,6 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.fw_name_pre = IWL5150_FW_PRE,
 	.ucode_api_max = IWL5150_UCODE_API_MAX,
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.ops = &iwl5150_ops,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 93e3fe9..a3a055f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -557,8 +557,6 @@ struct iwl_cfg iwl6000g2a_2agn_cfg = {
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -575,8 +573,6 @@ struct iwl_cfg iwl6000g2a_2abg_cfg = {
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -592,8 +588,6 @@ struct iwl_cfg iwl6000g2a_2bg_cfg = {
 	.fw_name_pre = IWL6000G2A_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -609,8 +603,6 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -631,8 +623,6 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -652,8 +642,6 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -674,8 +662,6 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -695,8 +681,6 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -717,8 +701,6 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -741,8 +723,8 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
+	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */
+	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -758,8 +740,8 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
+	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */
+	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -774,8 +756,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_BC,
-	.valid_rx_ant = ANT_BC,
+	.valid_tx_ant = ANT_BC,		/* .cfg overwrite */
+	.valid_rx_ant = ANT_BC,		/* .cfg overwrite */
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -790,8 +772,6 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.ops = &iwl6050_ops,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
@@ -807,8 +787,6 @@ struct iwl_cfg iwl6050g2_bgn_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6050G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050G2_TX_POWER_VERSION,
 	.ops = &iwl6050g2_ops,
@@ -824,8 +802,6 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.fw_name_pre = IWL6050_FW_PRE,
 	.ucode_api_max = IWL6050_UCODE_API_MAX,
 	.ucode_api_min = IWL6050_UCODE_API_MIN,
-	.valid_tx_ant = ANT_AB,
-	.valid_rx_ant = ANT_AB,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6050_TX_POWER_VERSION,
 	.ops = &iwl6050_ops,
@@ -840,8 +816,6 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.fw_name_pre = IWL6000_FW_PRE,
 	.ucode_api_max = IWL6000_UCODE_API_MAX,
 	.ucode_api_min = IWL6000_UCODE_API_MIN,
-	.valid_tx_ant = ANT_ABC,
-	.valid_rx_ant = ANT_ABC,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000_TX_POWER_VERSION,
 	.ops = &iwl6000_ops,
@@ -857,8 +831,6 @@ struct iwl_cfg iwl130_bgn_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
@@ -878,8 +850,6 @@ struct iwl_cfg iwl130_bg_cfg = {
 	.fw_name_pre = IWL6000G2B_FW_PRE,
 	.ucode_api_max = IWL6000G2_UCODE_API_MAX,
 	.ucode_api_min = IWL6000G2_UCODE_API_MIN,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_A,
 	.eeprom_ver = EEPROM_6000G2_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_6000G2_TX_POWER_VERSION,
 	.ops = &iwl6000g2b_ops,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
index 8a4d3ac..dbada76 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-eeprom.c
@@ -251,6 +251,7 @@ err:
 int iwl_eeprom_check_sku(struct iwl_priv *priv)
 {
 	u16 eeprom_sku;
+	u16 radio_cfg;
 
 	eeprom_sku = iwl_eeprom_query16(priv, EEPROM_SKU_CAP);
 
@@ -266,6 +267,25 @@ int iwl_eeprom_check_sku(struct iwl_priv *priv)
 
 	IWL_INFO(priv, "Device SKU: 0X%x\n", priv->cfg->sku);
 
+	if (!priv->cfg->valid_tx_ant && !priv->cfg->valid_rx_ant) {
+		/* not using .cfg overwrite */
+		radio_cfg = iwl_eeprom_query16(priv, EEPROM_RADIO_CONFIG);
+		priv->cfg->valid_tx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+		priv->cfg->valid_rx_ant = EEPROM_RF_CFG_TX_ANT_MSK(radio_cfg);
+		if (!priv->cfg->valid_tx_ant || !priv->cfg->valid_rx_ant) {
+			IWL_ERR(priv, "Invalid chain (0X%x, 0X%x)\n",
+				priv->cfg->valid_tx_ant,
+				priv->cfg->valid_rx_ant);
+			return -EINVAL;
+		}
+		IWL_INFO(priv, "Valid Tx ant: 0X%x, Valid Rx ant: 0X%x\n",
+			 priv->cfg->valid_tx_ant, priv->cfg->valid_rx_ant);
+	}
+	/*
+	 * for some special cases,
+	 * EEPROM did not reflect the correct antenna setting
+	 * so overwrite the valid tx/rx antenna from .cfg
+	 */
 	return 0;
 }
 
-- 
1.7.0.4

