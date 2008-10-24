Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:32505 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751378AbYJXGsm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 02:48:42 -0400
From: Reinette Chatre <reinette.chatre@linux.intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/10] iwlwifi: calibration command namespace renaming
Date: Thu, 23 Oct 2008 23:48:52 -0700
Message-Id: <1224830938-1577-5-git-send-email-reinette.chatre@linux.intel.com> (sfid-20081024_084854_977326_61444952)
In-Reply-To: <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
References: <>
 <1224830938-1577-1-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-2-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-3-git-send-email-reinette.chatre@linux.intel.com>
 <1224830938-1577-4-git-send-email-reinette.chatre@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

Since calibration framework is not HW specific remove 5000 and 4965 prefix
This patch doesn't provide any functional changes only code renaming
and movement

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |    9 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   42 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-commands.h |   69 ++++++++++++++-------------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   15 +++++-
 5 files changed, 74 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index f53cd2b..aad32a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -519,10 +519,10 @@ static void iwl4965_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &(priv->chain_noise_data);
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
-		struct iwl4965_calibration_cmd cmd;
+		struct iwl_calib_diff_gain_cmd cmd;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.opCode = PHY_CALIBRATE_DIFF_GAIN_CMD;
+		cmd.opCode = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
 		cmd.diff_gain_a = 0;
 		cmd.diff_gain_b = 0;
 		cmd.diff_gain_c = 0;
@@ -569,11 +569,11 @@ static void iwl4965_gain_computation(struct iwl_priv *priv,
 
 	/* Differential gain gets sent to uCode only once */
 	if (!data->radio_write) {
-		struct iwl4965_calibration_cmd cmd;
+		struct iwl_calib_diff_gain_cmd cmd;
 		data->radio_write = 1;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.opCode = PHY_CALIBRATE_DIFF_GAIN_CMD;
+		cmd.opCode = IWL_PHY_CALIBRATE_DIFF_GAIN_CMD;
 		cmd.diff_gain_a = data->delta_gain_code[0];
 		cmd.diff_gain_b = data->delta_gain_code[1];
 		cmd.diff_gain_c = data->delta_gain_code[2];
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 66ed993..fa06443 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -129,14 +129,5 @@ struct iwl5000_shared {
 	__le32 padding2;
 } __attribute__ ((packed));
 
-/* calibrations defined for 5000 */
-/* defines the order in which results should be sent to the runtime uCode */
-enum iwl5000_calib {
-	IWL5000_CALIB_XTAL,
-	IWL5000_CALIB_LO,
-	IWL5000_CALIB_TX_IQ,
-	IWL5000_CALIB_TX_IQ_PERD,
-};
-
 #endif /* __iwl_5000_hw_h__ */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cdf328b..8952733 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -337,10 +337,10 @@ static void iwl5000_gain_computation(struct iwl_priv *priv,
 			data->delta_gain_code[1], data->delta_gain_code[2]);
 
 	if (!data->radio_write) {
-		struct iwl5000_calibration_chain_noise_gain_cmd cmd;
+		struct iwl_calib_chain_noise_gain_cmd cmd;
 		memset(&cmd, 0, sizeof(cmd));
 
-		cmd.op_code = IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
+		cmd.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
 		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
@@ -364,10 +364,10 @@ static void iwl5000_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) && iwl_is_associated(priv)) {
-		struct iwl5000_calibration_chain_noise_reset_cmd cmd;
+		struct iwl_calib_chain_noise_reset_cmd cmd;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.op_code = IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
+		cmd.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
 		if (iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 			sizeof(cmd), &cmd))
 			IWL_ERROR("Could not send REPLY_PHY_CALIBRATION_CMD\n");
@@ -420,25 +420,25 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
  */
 static int iwl5000_set_Xtal_calib(struct iwl_priv *priv)
 {
-	u8 data[sizeof(struct iwl5000_calib_hdr) +
+	u8 data[sizeof(struct iwl_calib_hdr) +
 		sizeof(struct iwl_cal_xtal_freq)];
-	struct iwl5000_calib_cmd *cmd = (struct iwl5000_calib_cmd *)data;
+	struct iwl_calib_cmd *cmd = (struct iwl_calib_cmd *)data;
 	struct iwl_cal_xtal_freq *xtal = (struct iwl_cal_xtal_freq *)cmd->data;
 	u16 *xtal_calib = (u16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
 
-	cmd->hdr.op_code = IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
+	cmd->hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
 	xtal->cap_pin1 = (u8)xtal_calib[0];
 	xtal->cap_pin2 = (u8)xtal_calib[1];
-	return iwl_calib_set(&priv->calib_results[IWL5000_CALIB_XTAL],
+	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
 			     data, sizeof(data));
 }
 
 static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
 {
-	struct iwl5000_calib_cfg_cmd calib_cfg_cmd;
+	struct iwl_calib_cfg_cmd calib_cfg_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = CALIBRATION_CFG_CMD,
-		.len = sizeof(struct iwl5000_calib_cfg_cmd),
+		.len = sizeof(struct iwl_calib_cfg_cmd),
 		.data = &calib_cfg_cmd,
 	};
 
@@ -455,7 +455,7 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 			     struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = (void *)rxb->skb->data;
-	struct iwl5000_calib_hdr *hdr = (struct iwl5000_calib_hdr *)pkt->u.raw;
+	struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
 	int len = le32_to_cpu(pkt->len) & FH_RSCSR_FRAME_SIZE_MSK;
 	int index;
 
@@ -466,14 +466,14 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 	 * uCode. iwl_send_calib_results sends them in a row according to their
 	 * index. We sort them here */
 	switch (hdr->op_code) {
-	case IWL5000_PHY_CALIBRATE_LO_CMD:
-		index = IWL5000_CALIB_LO;
+	case IWL_PHY_CALIBRATE_LO_CMD:
+		index = IWL_CALIB_LO;
 		break;
-	case IWL5000_PHY_CALIBRATE_TX_IQ_CMD:
-		index = IWL5000_CALIB_TX_IQ;
+	case IWL_PHY_CALIBRATE_TX_IQ_CMD:
+		index = IWL_CALIB_TX_IQ;
 		break;
-	case IWL5000_PHY_CALIBRATE_TX_IQ_PERD_CMD:
-		index = IWL5000_CALIB_TX_IQ_PERD;
+	case IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD:
+		index = IWL_CALIB_TX_IQ_PERD;
 		break;
 	default:
 		IWL_ERROR("Unknown calibration notification %d\n",
@@ -839,10 +839,10 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 	case CSR_HW_REV_TYPE_5300:
 	case CSR_HW_REV_TYPE_5350:
 		priv->hw_params.calib_init_cfg =
-			BIT(IWL5000_CALIB_XTAL)		|
-			BIT(IWL5000_CALIB_LO)		|
-			BIT(IWL5000_CALIB_TX_IQ) 	|
-			BIT(IWL5000_CALIB_TX_IQ_PERD);
+			BIT(IWL_CALIB_XTAL)		|
+			BIT(IWL_CALIB_LO)		|
+			BIT(IWL_CALIB_TX_IQ) 	|
+			BIT(IWL_CALIB_TX_IQ_PERD);
 		break;
 	case CSR_HW_REV_TYPE_5150:
 		priv->hw_params.calib_init_cfg = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8f8734f..56964ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2875,36 +2875,25 @@ struct iwl_sensitivity_cmd {
  * 1-0: amount of gain, units of 1.5 dB
  */
 
-/* "Differential Gain" opcode used in REPLY_PHY_CALIBRATION_CMD. */
-#define PHY_CALIBRATE_DIFF_GAIN_CMD (7)
-
-struct iwl4965_calibration_cmd {
-	u8 opCode;		/* PHY_CALIBRATE_DIFF_GAIN_CMD (7) */
-	u8 flags;		/* not used */
-	__le16 reserved;
-	s8 diff_gain_a;		/* see above */
-	s8 diff_gain_b;
-	s8 diff_gain_c;
-	u8 reserved1;
-} __attribute__ ((packed));
-
-/* Phy calibration command for 5000 series */
+/* Phy calibration command for series */
 
 enum {
-	IWL5000_PHY_CALIBRATE_DC_CMD		= 8,
-	IWL5000_PHY_CALIBRATE_LO_CMD		= 9,
-	IWL5000_PHY_CALIBRATE_RX_BB_CMD		= 10,
-	IWL5000_PHY_CALIBRATE_TX_IQ_CMD		= 11,
-	IWL5000_PHY_CALIBRATE_RX_IQ_CMD		= 12,
-	IWL5000_PHY_CALIBRATION_NOISE_CMD	= 13,
-	IWL5000_PHY_CALIBRATE_AGC_TABLE_CMD	= 14,
-	IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
-	IWL5000_PHY_CALIBRATE_BASE_BAND_CMD	= 16,
-	IWL5000_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
-	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD = 18,
-	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD = 19,
+	IWL_PHY_CALIBRATE_DIFF_GAIN_CMD		= 7,
+	IWL_PHY_CALIBRATE_DC_CMD		= 8,
+	IWL_PHY_CALIBRATE_LO_CMD		= 9,
+	IWL_PHY_CALIBRATE_RX_BB_CMD		= 10,
+	IWL_PHY_CALIBRATE_TX_IQ_CMD		= 11,
+	IWL_PHY_CALIBRATE_RX_IQ_CMD		= 12,
+	IWL_PHY_CALIBRATION_NOISE_CMD		= 13,
+	IWL_PHY_CALIBRATE_AGC_TABLE_CMD		= 14,
+	IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
+	IWL_PHY_CALIBRATE_BASE_BAND_CMD		= 16,
+	IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
+	IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD	= 18,
+	IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD	= 19,
 };
 
+
 struct iwl_cal_xtal_freq {
 	u8 cap_pin1;
 	u8 cap_pin2;
@@ -2926,32 +2915,44 @@ struct iwl_calib_cfg_status_s {
 	__le32 flags;
 } __attribute__ ((packed));
 
-struct iwl5000_calib_cfg_cmd {
+struct iwl_calib_cfg_cmd {
 	struct iwl_calib_cfg_status_s ucd_calib_cfg;
 	struct iwl_calib_cfg_status_s drv_calib_cfg;
 	__le32 reserved1;
 } __attribute__ ((packed));
 
-struct iwl5000_calib_hdr {
+struct iwl_calib_hdr {
 	u8 op_code;
 	u8 first_group;
 	u8 groups_num;
 	u8 data_valid;
 } __attribute__ ((packed));
 
-struct iwl5000_calib_cmd {
-	struct iwl5000_calib_hdr hdr;
+struct iwl_calib_cmd {
+	struct iwl_calib_hdr hdr;
 	u8 data[0];
 } __attribute__ ((packed));
 
-struct iwl5000_calibration_chain_noise_reset_cmd {
-	u8 op_code;	/* IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
+/* "Differential Gain" opcode used in REPLY_PHY_CALIBRATION_CMD. */
+
+struct iwl_calib_diff_gain_cmd {
+	u8 opCode;		/* IWL_PHY_CALIBRATE_DIFF_GAIN_CMD (7) */
+	u8 flags;		/* not used */
+	__le16 reserved;
+	s8 diff_gain_a;		/* see above */
+	s8 diff_gain_b;
+	s8 diff_gain_c;
+	u8 reserved1;
+} __attribute__ ((packed));
+
+struct iwl_calib_chain_noise_reset_cmd {
+	u8 op_code;	/* IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
 	u8 flags;	/* not used */
 	__le16 reserved;
 } __attribute__ ((packed));
 
-struct iwl5000_calibration_chain_noise_gain_cmd {
-	u8 op_code;	/* IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD */
+struct iwl_calib_chain_noise_gain_cmd {
+	u8 op_code;	/* IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD */
 	u8 flags;	/* not used */
 	__le16 reserved;
 	u8 delta_gain_1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2f871f0..f546b7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -690,6 +690,20 @@ struct statistics_general_data {
 	u32 beacon_energy_c;
 };
 
+
+/*
+ * enum iwl_calib
+ * defines the order in which results of initial calibrations
+ * should be sent to the runtime uCode
+ */
+enum iwl_calib {
+	IWL_CALIB_XTAL,
+	IWL_CALIB_LO,
+	IWL_CALIB_TX_IQ,
+	IWL_CALIB_TX_IQ_PERD,
+	IWL_CALIB_MAX
+};
+
 /* Opaque calibration results */
 struct iwl_calib_result {
 	void *buf;
@@ -756,7 +770,6 @@ enum {
 
 
 #define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
-#define IWL_CALIB_MAX  4
 
 struct iwl_priv {
 
-- 
1.5.4.3

