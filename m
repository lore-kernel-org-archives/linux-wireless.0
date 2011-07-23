Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab1GWSBY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jul 2011 14:01:24 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/11] iwlagn: support v2 of enhanced sensitivity table
Date: Sat, 23 Jul 2011 10:24:50 -0700
Message-Id: <1311441890-19959-12-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110723_201610_458857_5D52EB53)
In-Reply-To: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1311441890-19959-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for v2 of enhanced sensitivity table for 2000 series products

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    2 +
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   69 +++++++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   34 +++++++++----
 drivers/net/wireless/iwlwifi/iwl-core.h      |    2 +
 4 files changed, 74 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index cdc7428..06f53b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -222,6 +222,7 @@ static struct iwl_base_params iwl2000_base_params = {
 	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = true,
+	.hd_v2 = true,
 };
 
 
@@ -241,6 +242,7 @@ static struct iwl_base_params iwl2030_base_params = {
 	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.shadow_reg_enable = true,
+	.hd_v2 = true,
 };
 
 static struct iwl_ht_params iwl2000_ht_params = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 72d6297..1789e3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -505,28 +505,53 @@ static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
 
 	iwl_prepare_legacy_sensitivity_tbl(priv, data, &cmd.enhance_table[0]);
 
-	cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX] =
-		HD_INA_NON_SQUARE_DET_OFDM_DATA;
-	cmd.enhance_table[HD_INA_NON_SQUARE_DET_CCK_INDEX] =
-		HD_INA_NON_SQUARE_DET_CCK_DATA;
-	cmd.enhance_table[HD_CORR_11_INSTEAD_OF_CORR_9_EN_INDEX] =
-		HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA;
-	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
-		HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA;
-	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
-		HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA;
-	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_INDEX] =
-		HD_OFDM_NON_SQUARE_DET_SLOPE_DATA;
-	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_INDEX] =
-		HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA;
-	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
-		HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA;
-	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
-		HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA;
-	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_INDEX] =
-		HD_CCK_NON_SQUARE_DET_SLOPE_DATA;
-	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_INDEX] =
-		HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA;
+	if (priv->cfg->base_params->hd_v2) {
+		cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX] =
+			HD_INA_NON_SQUARE_DET_OFDM_DATA_V2;
+		cmd.enhance_table[HD_INA_NON_SQUARE_DET_CCK_INDEX] =
+			HD_INA_NON_SQUARE_DET_CCK_DATA_V2;
+		cmd.enhance_table[HD_CORR_11_INSTEAD_OF_CORR_9_EN_INDEX] =
+			HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA_V2;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA_V2;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V2;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_SLOPE_DATA_V2;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA_V2;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
+			HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA_V2;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
+			HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V2;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_INDEX] =
+			HD_CCK_NON_SQUARE_DET_SLOPE_DATA_V2;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_INDEX] =
+			HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA_V2;
+	} else {
+		cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX] =
+			HD_INA_NON_SQUARE_DET_OFDM_DATA_V1;
+		cmd.enhance_table[HD_INA_NON_SQUARE_DET_CCK_INDEX] =
+			HD_INA_NON_SQUARE_DET_CCK_DATA_V1;
+		cmd.enhance_table[HD_CORR_11_INSTEAD_OF_CORR_9_EN_INDEX] =
+			HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA_V1;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA_V1;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V1;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_SLOPE_DATA_V1;
+		cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_INDEX] =
+			HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA_V1;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
+			HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA_V1;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
+			HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V1;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_INDEX] =
+			HD_CCK_NON_SQUARE_DET_SLOPE_DATA_V1;
+		cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_INDEX] =
+			HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA_V1;
+	}
 
 	/* Update uCode's "work" table, and copy it to DSP */
 	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5769ca5..4e92d56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3067,17 +3067,29 @@ struct iwl_missed_beacon_notif {
 /* number of additional entries for enhanced tbl */
 #define ENHANCE_HD_TABLE_ENTRIES  (ENHANCE_HD_TABLE_SIZE - HD_TABLE_SIZE)
 
-#define HD_INA_NON_SQUARE_DET_OFDM_DATA			cpu_to_le16(0)
-#define HD_INA_NON_SQUARE_DET_CCK_DATA			cpu_to_le16(0)
-#define HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA		cpu_to_le16(0)
-#define HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA		cpu_to_le16(668)
-#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA	cpu_to_le16(4)
-#define HD_OFDM_NON_SQUARE_DET_SLOPE_DATA		cpu_to_le16(486)
-#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA		cpu_to_le16(37)
-#define HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA		cpu_to_le16(853)
-#define HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA	cpu_to_le16(4)
-#define HD_CCK_NON_SQUARE_DET_SLOPE_DATA		cpu_to_le16(476)
-#define HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA		cpu_to_le16(99)
+#define HD_INA_NON_SQUARE_DET_OFDM_DATA_V1		cpu_to_le16(0)
+#define HD_INA_NON_SQUARE_DET_CCK_DATA_V1		cpu_to_le16(0)
+#define HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA_V1		cpu_to_le16(0)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA_V1	cpu_to_le16(668)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V1	cpu_to_le16(4)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_DATA_V1		cpu_to_le16(486)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA_V1	cpu_to_le16(37)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA_V1		cpu_to_le16(853)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V1	cpu_to_le16(4)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_DATA_V1		cpu_to_le16(476)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA_V1		cpu_to_le16(99)
+
+#define HD_INA_NON_SQUARE_DET_OFDM_DATA_V2		cpu_to_le16(1)
+#define HD_INA_NON_SQUARE_DET_CCK_DATA_V2		cpu_to_le16(1)
+#define HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA_V2		cpu_to_le16(1)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA_V2	cpu_to_le16(600)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V2	cpu_to_le16(40)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_DATA_V2		cpu_to_le16(486)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA_V2	cpu_to_le16(45)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA_V2		cpu_to_le16(853)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA_V2	cpu_to_le16(60)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_DATA_V2		cpu_to_le16(476)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA_V2		cpu_to_le16(99)
 
 
 /* Control field in struct iwl_sensitivity_cmd */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 74f043d..c246861 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -135,6 +135,7 @@ struct iwl_mod_params {
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @shadow_reg_enable: HW shadhow register bit
+ * @hd_v2: v2 of enhanced sensitivity value, used for 2000 series and up
  */
 struct iwl_base_params {
 	int eeprom_size;
@@ -156,6 +157,7 @@ struct iwl_base_params {
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool shadow_reg_enable;
+	const bool hd_v2;
 };
 /*
  * @advanced_bt_coexist: support advanced bt coexist
-- 
1.7.0.4

