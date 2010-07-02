Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759261Ab0GBSok (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 8/8] iwlwifi: adding enhance sensitivity table entries
Date: Fri,  2 Jul 2010 11:45:40 -0700
Message-Id: <1278096340-2546-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For newer devices (6000g2a and 6000g2b), the sensitivity table send to
uCode require additional table entries to help sensitivity calibration.

All the additional entries has fix data for now, but do expect the value
will be change in the future when device become more stable.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |  133 ++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    6 +
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   43 ++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    3 +
 4 files changed, 157 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index eb052b0..90033e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -409,46 +409,34 @@ static int iwl_sens_auto_corr_ofdm(struct iwl_priv *priv,
 	return 0;
 }
 
-/* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
-static int iwl_sensitivity_write(struct iwl_priv *priv)
+static void iwl_prepare_legacy_sensitivity_tbl(struct iwl_priv *priv,
+				struct iwl_sensitivity_data *data,
+				__le16 *tbl)
 {
-	struct iwl_sensitivity_cmd cmd ;
-	struct iwl_sensitivity_data *data = NULL;
-	struct iwl_host_cmd cmd_out = {
-		.id = SENSITIVITY_CMD,
-		.len = sizeof(struct iwl_sensitivity_cmd),
-		.flags = CMD_ASYNC,
-		.data = &cmd,
-	};
-
-	data = &(priv->sensitivity_data);
-
-	memset(&cmd, 0, sizeof(cmd));
-
-	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX] =
+	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_INDEX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm);
-	cmd.table[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_AUTO_CORR32_X4_TH_ADD_MIN_MRC_INDEX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm_mrc);
-	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX] =
+	tbl[HD_AUTO_CORR32_X1_TH_ADD_MIN_INDEX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm_x1);
-	cmd.table[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_AUTO_CORR32_X1_TH_ADD_MIN_MRC_INDEX] =
 				cpu_to_le16((u16)data->auto_corr_ofdm_mrc_x1);
 
-	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX] =
+	tbl[HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX] =
 				cpu_to_le16((u16)data->auto_corr_cck);
-	cmd.table[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_AUTO_CORR40_X4_TH_ADD_MIN_MRC_INDEX] =
 				cpu_to_le16((u16)data->auto_corr_cck_mrc);
 
-	cmd.table[HD_MIN_ENERGY_CCK_DET_INDEX] =
+	tbl[HD_MIN_ENERGY_CCK_DET_INDEX] =
 				cpu_to_le16((u16)data->nrg_th_cck);
-	cmd.table[HD_MIN_ENERGY_OFDM_DET_INDEX] =
+	tbl[HD_MIN_ENERGY_OFDM_DET_INDEX] =
 				cpu_to_le16((u16)data->nrg_th_ofdm);
 
-	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
+	tbl[HD_BARKER_CORR_TH_ADD_MIN_INDEX] =
 				cpu_to_le16(data->barker_corr_th_min);
-	cmd.table[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
+	tbl[HD_BARKER_CORR_TH_ADD_MIN_MRC_INDEX] =
 				cpu_to_le16(data->barker_corr_th_min_mrc);
-	cmd.table[HD_OFDM_ENERGY_TH_IN_INDEX] =
+	tbl[HD_OFDM_ENERGY_TH_IN_INDEX] =
 				cpu_to_le16(data->nrg_th_cca);
 
 	IWL_DEBUG_CALIB(priv, "ofdm: ac %u mrc %u x1 %u mrc_x1 %u thresh %u\n",
@@ -459,6 +447,25 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "cck: ac %u mrc %u thresh %u\n",
 			data->auto_corr_cck, data->auto_corr_cck_mrc,
 			data->nrg_th_cck);
+}
+
+/* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
+static int iwl_sensitivity_write(struct iwl_priv *priv)
+{
+	struct iwl_sensitivity_cmd cmd;
+	struct iwl_sensitivity_data *data = NULL;
+	struct iwl_host_cmd cmd_out = {
+		.id = SENSITIVITY_CMD,
+		.len = sizeof(struct iwl_sensitivity_cmd),
+		.flags = CMD_ASYNC,
+		.data = &cmd,
+	};
+
+	data = &(priv->sensitivity_data);
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	iwl_prepare_legacy_sensitivity_tbl(priv, data, &cmd.table[0]);
 
 	/* Update uCode's "work" table, and copy it to DSP */
 	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
@@ -477,6 +484,70 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	return iwl_send_cmd(priv, &cmd_out);
 }
 
+/* Prepare a SENSITIVITY_CMD, send to uCode if values have changed */
+static int iwl_enhance_sensitivity_write(struct iwl_priv *priv)
+{
+	struct iwl_enhance_sensitivity_cmd cmd;
+	struct iwl_sensitivity_data *data = NULL;
+	struct iwl_host_cmd cmd_out = {
+		.id = SENSITIVITY_CMD,
+		.len = sizeof(struct iwl_enhance_sensitivity_cmd),
+		.flags = CMD_ASYNC,
+		.data = &cmd,
+	};
+
+	data = &(priv->sensitivity_data);
+
+	memset(&cmd, 0, sizeof(cmd));
+
+	iwl_prepare_legacy_sensitivity_tbl(priv, data, &cmd.enhance_table[0]);
+
+	cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX] =
+		HD_INA_NON_SQUARE_DET_OFDM_DATA;
+	cmd.enhance_table[HD_INA_NON_SQUARE_DET_CCK_INDEX] =
+		HD_INA_NON_SQUARE_DET_CCK_DATA;
+	cmd.enhance_table[HD_CORR_11_INSTEAD_OF_CORR_9_EN_INDEX] =
+		HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA;
+	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
+		HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA;
+	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
+		HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA;
+	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_SLOPE_INDEX] =
+		HD_OFDM_NON_SQUARE_DET_SLOPE_DATA;
+	cmd.enhance_table[HD_OFDM_NON_SQUARE_DET_INTERCEPT_INDEX] =
+		HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA;
+	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_MRC_INDEX] =
+		HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA;
+	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_INDEX] =
+		HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA;
+	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_SLOPE_INDEX] =
+		HD_CCK_NON_SQUARE_DET_SLOPE_DATA;
+	cmd.enhance_table[HD_CCK_NON_SQUARE_DET_INTERCEPT_INDEX] =
+		HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA;
+
+	/* Update uCode's "work" table, and copy it to DSP */
+	cmd.control = SENSITIVITY_CMD_CONTROL_WORK_TABLE;
+
+	/* Don't send command to uCode if nothing has changed */
+	if (!memcmp(&cmd.enhance_table[0], &(priv->sensitivity_tbl[0]),
+		    sizeof(u16)*HD_TABLE_SIZE) &&
+	    !memcmp(&cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX],
+		    &(priv->enhance_sensitivity_tbl[0]),
+		    sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES)) {
+		IWL_DEBUG_CALIB(priv, "No change in SENSITIVITY_CMD\n");
+		return 0;
+	}
+
+	/* Copy table for comparison next time */
+	memcpy(&(priv->sensitivity_tbl[0]), &(cmd.enhance_table[0]),
+	       sizeof(u16)*HD_TABLE_SIZE);
+	memcpy(&(priv->enhance_sensitivity_tbl[0]),
+	       &(cmd.enhance_table[HD_INA_NON_SQUARE_DET_OFDM_INDEX]),
+	       sizeof(u16)*ENHANCE_HD_TABLE_ENTRIES);
+
+	return iwl_send_cmd(priv, &cmd_out);
+}
+
 void iwl_init_sensitivity(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -527,7 +598,10 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	data->last_bad_plcp_cnt_cck = 0;
 	data->last_fa_cnt_cck = 0;
 
-	ret |= iwl_sensitivity_write(priv);
+	if (priv->enhance_sensitivity_table)
+		ret |= iwl_enhance_sensitivity_write(priv);
+	else
+		ret |= iwl_sensitivity_write(priv);
 	IWL_DEBUG_CALIB(priv, "<<return 0x%X\n", ret);
 }
 
@@ -633,7 +707,10 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 
 	iwl_sens_auto_corr_ofdm(priv, norm_fa_ofdm, rx_enable_time);
 	iwl_sens_energy_cck(priv, norm_fa_cck, rx_enable_time, &statis);
-	iwl_sensitivity_write(priv);
+	if (priv->enhance_sensitivity_table)
+		iwl_enhance_sensitivity_write(priv);
+	else
+		iwl_sensitivity_write(priv);
 }
 
 static inline u8 find_first_chain(u8 mask)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 60af542..66c83b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1961,6 +1961,12 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 				pieces->inst_errlog_ptr =
 					le32_to_cpup((__le32 *)tlv_data);
 			break;
+		case IWL_UCODE_TLV_ENHANCE_SENS_TBL:
+			if (tlv_len)
+				ret = -EINVAL;
+			else
+				priv->enhance_sensitivity_table = true;
+			break;
 		default:
 			IWL_WARN(priv, "unknown TLV: %d\n", tlv_type);
 			break;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index d887b57..a587999 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3490,6 +3490,41 @@ struct iwl_missed_beacon_notif {
 #define HD_AUTO_CORR40_X4_TH_ADD_MIN_INDEX          (9)
 #define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
 
+/*
+ * Additional table entries in enhance SENSITIVITY_CMD
+ */
+#define HD_INA_NON_SQUARE_DET_OFDM_INDEX		(11)
+#define HD_INA_NON_SQUARE_DET_CCK_INDEX			(12)
+#define HD_CORR_11_INSTEAD_OF_CORR_9_EN_INDEX		(13)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_INDEX		(14)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_INDEX	(15)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_INDEX		(16)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_INDEX		(17)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_MRC_INDEX		(18)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_INDEX	(19)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_INDEX		(20)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_INDEX		(21)
+#define HD_RESERVED					(22)
+
+/* number of entries for enhanced tbl */
+#define ENHANCE_HD_TABLE_SIZE  (23)
+
+/* number of additional entries for enhanced tbl */
+#define ENHANCE_HD_TABLE_ENTRIES  (ENHANCE_HD_TABLE_SIZE - HD_TABLE_SIZE)
+
+#define HD_INA_NON_SQUARE_DET_OFDM_DATA			cpu_to_le16(0)
+#define HD_INA_NON_SQUARE_DET_CCK_DATA			cpu_to_le16(0)
+#define HD_CORR_11_INSTEAD_OF_CORR_9_EN_DATA		cpu_to_le16(0)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_MRC_DATA		cpu_to_le16(668)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_MRC_DATA	cpu_to_le16(4)
+#define HD_OFDM_NON_SQUARE_DET_SLOPE_DATA		cpu_to_le16(486)
+#define HD_OFDM_NON_SQUARE_DET_INTERCEPT_DATA		cpu_to_le16(37)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_MRC_DATA		cpu_to_le16(853)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_MRC_DATA	cpu_to_le16(4)
+#define HD_CCK_NON_SQUARE_DET_SLOPE_DATA		cpu_to_le16(476)
+#define HD_CCK_NON_SQUARE_DET_INTERCEPT_DATA		cpu_to_le16(99)
+
+
 /* Control field in struct iwl_sensitivity_cmd */
 #define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	cpu_to_le16(0)
 #define SENSITIVITY_CMD_CONTROL_WORK_TABLE	cpu_to_le16(1)
@@ -3506,6 +3541,14 @@ struct iwl_sensitivity_cmd {
 	__le16 table[HD_TABLE_SIZE];	/* use HD_* as index */
 } __attribute__ ((packed));
 
+/*
+ *
+ */
+struct iwl_enhance_sensitivity_cmd {
+	__le16 control;			/* always use "1" */
+	__le16 enhance_table[ENHANCE_HD_TABLE_SIZE];	/* use HD_* as index */
+} __attribute__ ((packed));
+
 
 /**
  * REPLY_PHY_CALIBRATION_CMD = 0xb0 (command, has simple generic response)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c637376..dff1b17 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -570,6 +570,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_INIT_EVTLOG_PTR	= 11,
 	IWL_UCODE_TLV_INIT_EVTLOG_SIZE	= 12,
 	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
+	IWL_UCODE_TLV_ENHANCE_SENS_TBL	= 14,
 };
 
 struct iwl_ucode_tlv {
@@ -1193,7 +1194,9 @@ struct iwl_priv {
 	u8 start_calib;
 	struct iwl_sensitivity_data sensitivity_data;
 	struct iwl_chain_noise_data chain_noise_data;
+	bool enhance_sensitivity_table;
 	__le16 sensitivity_tbl[HD_TABLE_SIZE];
+	__le16 enhance_sensitivity_tbl[ENHANCE_HD_TABLE_ENTRIES];
 
 	struct iwl_ht_config current_ht_config;
 
-- 
1.7.0.4

