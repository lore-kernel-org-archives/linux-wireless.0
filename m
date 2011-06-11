Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758608Ab1FKOzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/18] iwlagn: merge duplicated code into single place
Date: Sat, 11 Jun 2011 07:25:50 -0700
Message-Id: <1307802352-16398-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165603_233922_EDE5398C)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Multiple places have similar code to construct calib header. Merge into
single inline function.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |   12 ++++--------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   14 +++++---------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    8 ++++++++
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 23eee0c..ba7ed91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -111,10 +111,8 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 
 		memset(&cmd, 0, sizeof(cmd));
 
-		cmd.hdr.op_code = priv->_agn.phy_calib_chain_noise_gain_cmd;
-		cmd.hdr.first_group = 0;
-		cmd.hdr.groups_num = 1;
-		cmd.hdr.data_valid = 1;
+		iwl_set_calib_hdr(&cmd.hdr,
+			priv->_agn.phy_calib_chain_noise_gain_cmd);
 		cmd.delta_gain_1 = data->delta_gain_code[1];
 		cmd.delta_gain_2 = data->delta_gain_code[2];
 		iwl_send_cmd_pdu_async(priv, REPLY_PHY_CALIBRATION_CMD,
@@ -144,10 +142,8 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		data->beacon_count = 0;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.hdr.op_code = priv->_agn.phy_calib_chain_noise_reset_cmd;
-		cmd.hdr.first_group = 0;
-		cmd.hdr.groups_num = 1;
-		cmd.hdr.data_valid = 1;
+		iwl_set_calib_hdr(&cmd.hdr,
+			priv->_agn.phy_calib_chain_noise_reset_cmd);
 		ret = iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
 					sizeof(cmd), &cmd);
 		if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 4be7a0f..de8277e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -183,10 +183,7 @@ static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
 	__le16 *xtal_calib =
 		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_XTAL);
 
-	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
-	cmd.hdr.first_group = 0;
-	cmd.hdr.groups_num = 1;
-	cmd.hdr.data_valid = 1;
+	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD);
 	cmd.cap_pin1 = le16_to_cpu(xtal_calib[0]);
 	cmd.cap_pin2 = le16_to_cpu(xtal_calib[1]);
 	return iwl_calib_set(&priv->calib_results[IWL_CALIB_XTAL],
@@ -198,14 +195,13 @@ static int iwlagn_set_temperature_offset_calib(struct iwl_priv *priv)
 	struct iwl_calib_temperature_offset_cmd cmd;
 	__le16 *offset_calib =
 		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_TEMPERATURE);
-	cmd.hdr.op_code = IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD;
-	cmd.hdr.first_group = 0;
-	cmd.hdr.groups_num = 1;
-	cmd.hdr.data_valid = 1;
+
+	memset(&cmd, 0, sizeof(cmd));
+	iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
 	cmd.radio_sensor_offset = le16_to_cpu(offset_calib[1]);
 	if (!(cmd.radio_sensor_offset))
 		cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
-	cmd.reserved = 0;
+
 	IWL_DEBUG_CALIB(priv, "Radio sensor offset: %d\n",
 			cmd.radio_sensor_offset);
 	return iwl_calib_set(&priv->calib_results[IWL_CALIB_TEMP_OFFSET],
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 94ee141..5d8b2db 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -129,6 +129,14 @@ static inline void iwl_synchronize_irq(struct iwl_priv *priv)
 	tasklet_kill(&priv->irq_tasklet);
 }
 
+static inline void iwl_set_calib_hdr(struct iwl_calib_hdr *hdr, u8 cmd)
+{
+	hdr->op_code = cmd;
+	hdr->first_group = 0;
+	hdr->groups_num = 1;
+	hdr->data_valid = 1;
+}
+
 int iwl_prepare_card_hw(struct iwl_priv *priv);
 
 int iwlagn_start_device(struct iwl_priv *priv);
-- 
1.7.0.4

