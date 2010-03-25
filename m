Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:22722 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab0CYUoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 16:44:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/22] iwlwifi: move hw related defines to separate file
Date: Thu, 25 Mar 2010 13:44:35 -0700
Message-Id: <1269549890-19195-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
References: <1269549890-19195-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Multiple iwlagn based devices shared the same hw definitions.
Move device hardware related defines from iwl-5000-hw.h to iwl-agn-hw.h
file.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |   18 ++--
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h   |   33 --------
 drivers/net/wireless/iwlwifi/iwl-5000.c      |   57 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-6000.c      |   30 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-hw.h    |  102 ++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   22 +++---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    6 +-
 8 files changed, 169 insertions(+), 100 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-agn-hw.h

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 6bdbe2d..f866410 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -44,7 +44,7 @@
 #include "iwl-sta.h"
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
-#include "iwl-5000-hw.h"
+#include "iwl-agn-hw.h"
 #include "iwl-agn-led.h"
 
 /* Highest firmware API version supported */
@@ -118,7 +118,7 @@ static struct iwl_sensitivity_ranges iwl1000_sensitivity = {
 static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWL50_NUM_QUEUES)
+	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
@@ -126,13 +126,13 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->num_of_queues *
-			sizeof(struct iwl5000_scd_bc_tbl);
+			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
+	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
 
 	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
@@ -235,8 +235,8 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
@@ -265,8 +265,8 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_1000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 714e032..146e643 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -68,25 +68,6 @@
 #ifndef __iwl_5000_hw_h__
 #define __iwl_5000_hw_h__
 
-#define IWL50_RTC_INST_LOWER_BOUND		(0x000000)
-#define IWL50_RTC_INST_UPPER_BOUND		(0x020000)
-
-#define IWL50_RTC_DATA_LOWER_BOUND		(0x800000)
-#define IWL50_RTC_DATA_UPPER_BOUND		(0x80C000)
-
-#define IWL50_RTC_INST_SIZE (IWL50_RTC_INST_UPPER_BOUND - \
-				IWL50_RTC_INST_LOWER_BOUND)
-#define IWL50_RTC_DATA_SIZE (IWL50_RTC_DATA_UPPER_BOUND - \
-				IWL50_RTC_DATA_LOWER_BOUND)
-
-/* EEPROM */
-#define IWL_5000_EEPROM_IMG_SIZE			2048
-
-#define IWL50_CMD_FIFO_NUM                 7
-#define IWL50_NUM_QUEUES                  20
-#define IWL50_NUM_AMPDU_QUEUES		  10
-#define IWL50_FIRST_AMPDU_QUEUE		  10
-
 /* 5150 only */
 #define IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF	(-5)
 
@@ -103,19 +84,5 @@ static inline s32 iwl_temp_calib_to_offset(struct iwl_priv *priv)
 	return (s32)(temperature - voltage / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF);
 }
 
-/* Fixed (non-configurable) rx data from phy */
-
-/**
- * struct iwl5000_schedq_bc_tbl scheduler byte count table
- * 	base physical address of iwl5000_shared
- * 	is provided to SCD_DRAM_BASE_ADDR
- * @tfd_offset  0-12 - tx command byte count
- *	       12-16 - station index
- */
-struct iwl5000_scd_bc_tbl {
-	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
-} __attribute__ ((packed));
-
-
 #endif /* __iwl_5000_hw_h__ */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7e27895..a41af47 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -45,6 +45,7 @@
 #include "iwl-helpers.h"
 #include "iwl-agn.h"
 #include "iwl-agn-led.h"
+#include "iwl-agn-hw.h"
 #include "iwl-5000-hw.h"
 #include "iwl-6000-hw.h"
 
@@ -69,7 +70,7 @@ static const s8 iwl5000_default_queue_to_tx_fifo[] = {
 	IWL_TX_FIFO_VI,
 	IWL_TX_FIFO_BE,
 	IWL_TX_FIFO_BK,
-	IWL50_CMD_FIFO_NUM,
+	IWLAGN_CMD_FIFO_NUM,
 	IWL_TX_FIFO_UNUSED,
 	IWL_TX_FIFO_UNUSED,
 	IWL_TX_FIFO_UNUSED,
@@ -456,7 +457,7 @@ int iwl5000_alive_notify(struct iwl_priv *priv)
 int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWL50_NUM_QUEUES)
+	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
@@ -464,13 +465,13 @@ int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->num_of_queues *
-			sizeof(struct iwl5000_scd_bc_tbl);
+			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
 
-	priv->hw_params.max_data_size = IWL50_RTC_DATA_SIZE;
-	priv->hw_params.max_inst_size = IWL50_RTC_INST_SIZE;
+	priv->hw_params.max_data_size = IWLAGN_RTC_DATA_SIZE;
+	priv->hw_params.max_inst_size = IWLAGN_RTC_INST_SIZE;
 
 	priv->hw_params.max_bsm_size = 0;
 	priv->hw_params.ht40_channel =  BIT(IEEE80211_BAND_2GHZ) |
@@ -741,8 +742,8 @@ void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 
 int iwl5000_hw_valid_rtc_data_addr(u32 addr)
 {
-	return (addr >= IWL50_RTC_DATA_LOWER_BOUND) &&
-		(addr < IWL50_RTC_DATA_UPPER_BOUND);
+	return (addr >= IWLAGN_RTC_DATA_LOWER_BOUND) &&
+		(addr < IWLAGN_RTC_DATA_UPPER_BOUND);
 }
 
 int  iwl5000_send_tx_power(struct iwl_priv *priv)
@@ -977,11 +978,11 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
@@ -1004,11 +1005,11 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
@@ -1031,11 +1032,11 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl5000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
@@ -1056,11 +1057,11 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_B,
 	.valid_rx_ant = ANT_AB,
@@ -1083,11 +1084,11 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.ucode_api_min = IWL5000_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
@@ -1110,11 +1111,11 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5150_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
@@ -1137,11 +1138,11 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.ucode_api_min = IWL5150_UCODE_API_MIN,
 	.sku = IWL_SKU_A|IWL_SKU_G,
 	.ops = &iwl5150_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_size = IWLAGN_EEPROM_IMG_SIZE,
 	.eeprom_ver = EEPROM_5050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5050_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_A,
 	.valid_rx_ant = ANT_AB,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f376390..2bbff18 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -44,7 +44,7 @@
 #include "iwl-sta.h"
 #include "iwl-agn.h"
 #include "iwl-helpers.h"
-#include "iwl-5000-hw.h"
+#include "iwl-agn-hw.h"
 #include "iwl-6000-hw.h"
 #include "iwl-agn-led.h"
 
@@ -137,7 +137,7 @@ static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 {
 	if (priv->cfg->mod_params->num_of_queues >= IWL_MIN_NUM_QUEUES &&
-	    priv->cfg->mod_params->num_of_queues <= IWL50_NUM_QUEUES)
+	    priv->cfg->mod_params->num_of_queues <= IWLAGN_NUM_QUEUES)
 		priv->cfg->num_of_queues =
 			priv->cfg->mod_params->num_of_queues;
 
@@ -145,7 +145,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 	priv->hw_params.dma_chnl_num = FH50_TCSR_CHNL_NUM;
 	priv->hw_params.scd_bc_tbls_size =
 			priv->cfg->num_of_queues *
-			sizeof(struct iwl5000_scd_bc_tbl);
+			sizeof(struct iwlagn_scd_bc_tbl);
 	priv->hw_params.tfd_size = sizeof(struct iwl_tfd);
 	priv->hw_params.max_stations = IWL5000_STATION_COUNT;
 	priv->hw_params.bcast_sta_id = IWL5000_BROADCAST_ID;
@@ -372,8 +372,8 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
@@ -405,8 +405,8 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
@@ -437,8 +437,8 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_BC,
 	.valid_rx_ant = ANT_BC,
@@ -469,8 +469,8 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -502,8 +502,8 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6050_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_AB,
@@ -534,8 +534,8 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_size = OTP_LOW_IMAGE_SIZE,
 	.eeprom_ver = EEPROM_6000_EEPROM_VERSION,
 	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.num_of_queues = IWL50_NUM_QUEUES,
-	.num_of_ampdu_queues = IWL50_NUM_AMPDU_QUEUES,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.num_of_ampdu_queues = IWLAGN_NUM_AMPDU_QUEUES,
 	.mod_params = &iwl50_mod_params,
 	.valid_tx_ant = ANT_ABC,
 	.valid_rx_ant = ANT_ABC,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 3ac010b..a0e3c11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -35,7 +35,6 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-5000-hw.h"
 
 static int iwlagn_send_rxon_assoc(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hw.h b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
new file mode 100644
index 0000000..e2ad870
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hw.h
@@ -0,0 +1,102 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2010 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2010 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+/*
+ * Please use this file (iwl-agn-hw.h) only for hardware-related definitions.
+ */
+
+#ifndef __iwl_agn_hw_h__
+#define __iwl_agn_hw_h__
+
+#define IWLAGN_RTC_INST_LOWER_BOUND		(0x000000)
+#define IWLAGN_RTC_INST_UPPER_BOUND		(0x020000)
+
+#define IWLAGN_RTC_DATA_LOWER_BOUND		(0x800000)
+#define IWLAGN_RTC_DATA_UPPER_BOUND		(0x80C000)
+
+#define IWLAGN_RTC_INST_SIZE (IWLAGN_RTC_INST_UPPER_BOUND - \
+				IWLAGN_RTC_INST_LOWER_BOUND)
+#define IWLAGN_RTC_DATA_SIZE (IWLAGN_RTC_DATA_UPPER_BOUND - \
+				IWLAGN_RTC_DATA_LOWER_BOUND)
+
+/* EEPROM */
+#define IWLAGN_EEPROM_IMG_SIZE		2048
+
+#define IWLAGN_CMD_FIFO_NUM		7
+#define IWLAGN_NUM_QUEUES		20
+#define IWLAGN_NUM_AMPDU_QUEUES		10
+#define IWLAGN_FIRST_AMPDU_QUEUE	10
+
+/* Fixed (non-configurable) rx data from phy */
+
+/**
+ * struct iwlagn_schedq_bc_tbl scheduler byte count table
+ *	base physical address provided by SCD_DRAM_BASE_ADDR
+ * @tfd_offset  0-12 - tx command byte count
+ *	       12-16 - station index
+ */
+struct iwlagn_scd_bc_tbl {
+	__le16 tfd_offset[TFD_QUEUE_BC_SIZE];
+} __attribute__ ((packed));
+
+
+#endif /* __iwl_agn_hw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 44b3d53..43bdd9d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -36,7 +36,7 @@
 #include "iwl-core.h"
 #include "iwl-sta.h"
 #include "iwl-io.h"
-#include "iwl-5000-hw.h"
+#include "iwl-agn-hw.h"
 
 /**
  * iwlagn_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
@@ -45,7 +45,7 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
-	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int write_ptr = txq->q.write_ptr;
 	int txq_id = txq->q.id;
 	u8 sec_ctl = 0;
@@ -84,7 +84,7 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq)
 {
-	struct iwl5000_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
 	int txq_id = txq->q.id;
 	int read_ptr = txq->q.read_ptr;
 	u8 sta_id = 0;
@@ -171,13 +171,13 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	unsigned long flags;
 	u16 ra_tid;
 
-	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWLAGN_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
 	     <= txq_id)) {
 		IWL_WARN(priv,
 			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWL50_FIRST_AMPDU_QUEUE,
-			IWL50_FIRST_AMPDU_QUEUE +
+			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
+			IWLAGN_FIRST_AMPDU_QUEUE +
 			priv->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
@@ -231,13 +231,13 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 			   u16 ssn_idx, u8 tx_fifo)
 {
-	if ((IWL50_FIRST_AMPDU_QUEUE > txq_id) ||
-	    (IWL50_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
+	if ((IWLAGN_FIRST_AMPDU_QUEUE > txq_id) ||
+	    (IWLAGN_FIRST_AMPDU_QUEUE + priv->cfg->num_of_ampdu_queues
 	     <= txq_id)) {
 		IWL_ERR(priv,
 			"queue number out of range: %d, must be %d to %d\n",
-			txq_id, IWL50_FIRST_AMPDU_QUEUE,
-			IWL50_FIRST_AMPDU_QUEUE +
+			txq_id, IWLAGN_FIRST_AMPDU_QUEUE,
+			IWLAGN_FIRST_AMPDU_QUEUE +
 			priv->cfg->num_of_ampdu_queues - 1);
 		return -EINVAL;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index f57a4f8..f0af388 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -35,7 +35,7 @@
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-#include "iwl-5000-hw.h"
+#include "iwl-agn-hw.h"
 
 /*
  * ucode
@@ -101,12 +101,12 @@ static int iwlagn_load_given_ucode(struct iwl_priv *priv,
 	int ret = 0;
 
 	ret = iwlagn_load_section(priv, "INST", inst_image,
-				   IWL50_RTC_INST_LOWER_BOUND);
+				   IWLAGN_RTC_INST_LOWER_BOUND);
 	if (ret)
 		return ret;
 
 	return iwlagn_load_section(priv, "DATA", data_image,
-				    IWL50_RTC_DATA_LOWER_BOUND);
+				    IWLAGN_RTC_DATA_LOWER_BOUND);
 }
 
 int iwlagn_load_ucode(struct iwl_priv *priv)
-- 
1.6.3.3

