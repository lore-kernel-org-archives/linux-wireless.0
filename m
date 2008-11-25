Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:57701 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234AbYKYVfU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 16:35:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/1] iwlwifi: properly initialize calibration command header
Date: Tue, 25 Nov 2008 13:36:01 -0800
Message-Id: <1227648961-9575-1-git-send-email-reinette.chatre@intel.com> (sfid-20081125_223524_222412_86C011A7)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   35 +++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   34 ++++++++++++--------------
 3 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ab0b405..f90c9e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -523,7 +523,7 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 		struct iwl_calib_diff_gain_cmd cmd;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.opCode = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
+		cmd.hdr.op_code = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
 		cmd.diff_gain_a = 0;
 		cmd.diff_gain_b = 0;
 		cmd.diff_gain_c = 0;
@@ -574,7 +574,7 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 		data->radio_write = 1;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.opCode = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
+		cmd.hdr.op_code = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
 		cmd.diff_gain_a = data->delta_gain_code[0];
 		cmd.diff_gain_b = data->delta_gain_code[1];
 		cmd.diff_gain_c = data->delta_gain_code[2];
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a738886..c3dce81 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -338,9 +338,13 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 
 	if (!data->radio_write) {
 		struct iwl_calib_chain_noise_gain_cmd cmd;
+
 		memset(&cmd, 0, sizeof(cmd));
 
-		cmd.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
+		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
+		cmd.hdr.first_group = 0;
+		cmd.hdr.groups_num = 1;
+		cmd.hdr.data_valid = 1;
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
 		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
@@ -362,14 +366,19 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
+	int ret;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
 		struct iwl_calib_chain_noise_reset_cmd cmd;
-
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
-		if (iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-			sizeof(cmd), &cmd))
+
+		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
+		cmd.hdr.first_group = 0;
+		cmd.hdr.groups_num = 1;
+		cmd.hdr.data_valid = 1;
+		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
+					sizeof(cmd), &cmd);
+		if (ret)
 			IWL_ERROR("Could not send REPLY_PHY_CALIBRATION_CMD\n");
 		data->state = IWL_CHAIN_NOISE_ACCUMULATE;
 		IWL_DEBUG_CALIB("Run chain_noise_calibrate\n");
@@ -420,17 +429,17 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
  */
 static int iwl5000_set_Xtal_calib(struct iwl_priv *priv)
 {
-	u8 data[sizeof(struct iwl_calib_hdr) +
-		sizeof(struct iwl_cal_xtal_freq)];
-	struct iwl_calib_cmd *cmd = (struct iwl_calib_cmd *)data;
-	struct iwl_cal_xtal_freq *xtal = (struct iwl_cal_xtal_freq *)cmd->data;
+	struct iwl_calib_xtal_freq_cmd cmd;
 	u16 *xtal_calib = (u16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
 
-	cmd->hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
-	xtal->cap_pin1 = (u8)xtal_calib[0];
-	xtal->cap_pin2 = (u8)xtal_calib[1];
+	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
+	cmd.hdr.first_group = 0;
+	cmd.hdr.groups_num = 1;
+	cmd.hdr.data_valid = 1;
+	cmd.cap_pin1 = (u8)xtal_calib[0];
+	cmd.cap_pin2 = (u8)xtal_calib[1];
 	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
-			     data, sizeof(data));
+			     (u8 *)&cmd, sizeof(cmd));
 }
 
 static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 1fe83d4..7761504 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2896,11 +2896,6 @@ enum {
 };
 
 
-struct iwl_cal_xtal_freq {
-	u8 cap_pin1;
-	u8 cap_pin2;
-} __attribute__ ((packed));
-
 #define IWL_CALIB_INIT_CFG_ALL	__constant_cpu_to_le32(0xffffffff)
 
 struct iwl_calib_cfg_elmnt_s {
@@ -2935,31 +2930,34 @@ struct iwl_calib_cmd {
 	u8 data[0];
 } __attribute__ ((packed));
 
-/* "Differential Gain" opcode used in REPLY_PHY_CALIBRATION_CMD. */
-
+/* IWL_PHY_CALIBRATE_DIFF_GAIN_CMD (7) */
 struct iwl_calib_diff_gain_cmd {
-	u8 opCode;		/* IWL_PHY_CALIBRATE_DIFF_GAIN_CMD (7) */
-	u8 flags;		/* not used */
-	__le16 reserved;
+	struct iwl_calib_hdr hdr;
 	s8 diff_gain_a;		/* see above */
 	s8 diff_gain_b;
 	s8 diff_gain_c;
 	u8 reserved1;
 } __attribute__ ((packed));
 
-struct iwl_calib_chain_noise_reset_cmd {
-	u8 op_code;	/* IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
-	u8 flags;	/* not used */
-	__le16 reserved;
+struct iwl_calib_xtal_freq_cmd {
+	struct iwl_calib_hdr hdr;
+	u8 cap_pin1;
+	u8 cap_pin2;
+	u8 pad[2];
 } __attribute__ ((packed));
 
+/* IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
+struct iwl_calib_chain_noise_reset_cmd {
+	struct iwl_calib_hdr hdr;
+	u8 data[0];
+};
+
+/* IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD */
 struct iwl_calib_chain_noise_gain_cmd {
-	u8 op_code;	/* IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD */
-	u8 flags;	/* not used */
-	__le16 reserved;
+	struct iwl_calib_hdr hdr;
 	u8 delta_gain_1;
 	u8 delta_gain_2;
-	__le16 reserved1;
+	u8 pad[2];
 } __attribute__ ((packed));
 
 /******************************************************************************
-- 
1.5.4.3

