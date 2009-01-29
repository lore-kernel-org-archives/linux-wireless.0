Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23398 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbZA2TGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 14:06:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/7] iwlwifi: simplify parameter setting to allow support for 6000 series
Date: Thu, 29 Jan 2009 11:09:12 -0800
Message-Id: <1233256157-21290-3-git-send-email-reinette.chatre@intel.com> (sfid-20090129_200627_155093_12369B5F)
In-Reply-To: <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
References: <>
 <1233256157-21290-1-git-send-email-reinette.chatre@intel.com>
 <1233256157-21290-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

by parametrizing the set hw function, in addition to allowing for
supporting the 6000 family significantly simplify the addition of new
hardware.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-100.c  |    2 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |   76 ++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-6000.c |   10 ++++
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +
 4 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-100.c b/drivers/net/wireless/iwlwifi/iwl-100.c
index dbadaf4..4c4d165 100644
--- a/drivers/net/wireless/iwlwifi/iwl-100.c
+++ b/drivers/net/wireless/iwlwifi/iwl-100.c
@@ -66,5 +66,7 @@ struct iwl_cfg iwl100_bgn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c5e9a66..535a46c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -43,6 +43,7 @@
 #include "iwl-sta.h"
 #include "iwl-helpers.h"
 #include "iwl-5000-hw.h"
+#include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 1
@@ -840,8 +841,18 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
-	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
+
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_6x00:
+	case CSR_HW_REV_TYPE_6x50:
+		priv->hw_params.max_data_size = IWL60_RTC_DATA_SIZE;
+		priv->hw_params.max_inst_size = IWL60_RTC_INST_SIZE;
+		break;
+	default:
+		priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
+		priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
+	}
+
 	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.fat_channel =  BIT(IEEE80211_BAND_2GHZ) |
 					BIT(IEEE80211_BAND_5GHZ);
@@ -849,61 +860,40 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 
 	priv->hw_params.sens = &iwl5000_sensitivity;
 
-	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_5100:
-		priv->hw_params.tx_chains_num = 1;
-		priv->hw_params.rx_chains_num = 2;
-		priv->hw_params.valid_tx_ant = ANT_B;
-		priv->hw_params.valid_rx_ant = ANT_AB;
-		break;
-	case CSR_HW_REV_TYPE_5150:
-		priv->hw_params.tx_chains_num = 1;
-		priv->hw_params.rx_chains_num = 2;
-		priv->hw_params.valid_tx_ant = ANT_A;
-		priv->hw_params.valid_rx_ant = ANT_AB;
-		break;
-	case CSR_HW_REV_TYPE_5300:
-	case CSR_HW_REV_TYPE_5350:
-		priv->hw_params.tx_chains_num = 3;
-		priv->hw_params.rx_chains_num = 3;
-		priv->hw_params.valid_tx_ant = ANT_ABC;
-		priv->hw_params.valid_rx_ant = ANT_ABC;
-		break;
-	}
+	priv->hw_params.tx_chains_num = priv->cfg->valid_tx_ant;
+	priv->hw_params.rx_chains_num = priv->cfg->valid_rx_ant;
+	priv->hw_params.valid_tx_ant = num_of_ant(priv->cfg->valid_tx_ant);
+	priv->hw_params.valid_rx_ant = num_of_ant(priv->cfg->valid_rx_ant);
 
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_5100:
-	case CSR_HW_REV_TYPE_5300:
-	case CSR_HW_REV_TYPE_5350:
-		/* 5X00 and 5350 wants in Celsius */
-		priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
-		break;
 	case CSR_HW_REV_TYPE_5150:
 		/* 5150 wants in Kelvin */
 		priv->hw_params.ct_kill_threshold =
 				iwl5150_get_ct_threshold(priv);
 		break;
+	default:
+		/* all others want Celsius */
+		priv->hw_params.ct_kill_threshold = CT_KILL_THRESHOLD;
+		break;
 	}
 
 	/* Set initial calibration set */
 	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
-	case CSR_HW_REV_TYPE_5100:
-	case CSR_HW_REV_TYPE_5300:
-	case CSR_HW_REV_TYPE_5350:
+	case CSR_HW_REV_TYPE_5150:
 		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_XTAL)		|
+			BIT(IWL_CALIB_DC)		|
 			BIT(IWL_CALIB_LO)		|
 			BIT(IWL_CALIB_TX_IQ) 		|
-			BIT(IWL_CALIB_TX_IQ_PERD)	|
 			BIT(IWL_CALIB_BASE_BAND);
+
 		break;
-	case CSR_HW_REV_TYPE_5150:
+	default:
 		priv->hw_params.calib_init_cfg =
-			BIT(IWL_CALIB_DC)		|
+			BIT(IWL_CALIB_XTAL)		|
 			BIT(IWL_CALIB_LO)		|
 			BIT(IWL_CALIB_TX_IQ) 		|
+			BIT(IWL_CALIB_TX_IQ_PERD)	|
 			BIT(IWL_CALIB_BASE_BAND);
-
 		break;
 	}
 
@@ -1556,6 +1546,8 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
 };
 
 struct iwl_cfg iwl5100_bg_cfg = {
@@ -1569,6 +1561,8 @@ struct iwl_cfg iwl5100_bg_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1582,6 +1576,8 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_B,
+	.valid_rx_ant = ANT_AB,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1595,6 +1591,8 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_B,
+	.valid_rx_ant = ANT_AB,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1608,6 +1606,8 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1621,6 +1621,8 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_B,
+	.valid_rx_ant = ANT_AB,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4515a60..b78d676 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -72,6 +72,8 @@ struct iwl_cfg iwl6000_2ag_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
 };
 
 struct iwl_cfg iwl6000_2agn_cfg = {
@@ -85,6 +87,8 @@ struct iwl_cfg iwl6000_2agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -98,6 +102,8 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_BC,
+	.valid_rx_ant = ANT_BC,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -111,6 +117,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
 };
 
 struct iwl_cfg iwl6050_3agn_cfg = {
@@ -124,6 +132,8 @@ struct iwl_cfg iwl6050_3agn_cfg = {
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
 	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_ABC,
+	.valid_rx_ant = ANT_ABC,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 0a719ae..02e92be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -211,6 +211,8 @@ struct iwl_cfg {
 	u16  eeprom_calib_ver;
 	const struct iwl_ops *ops;
 	const struct iwl_mod_params *mod_params;
+	u8   valid_tx_ant;
+	u8   valid_rx_ant;
 };
 
 /***************************
-- 
1.5.4.3

