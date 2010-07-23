Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:47891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760275Ab0GWQN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:58 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlwifi: add TLV to specify the size of phy calibration table
Date: Fri, 23 Jul 2010 09:15:34 -0700
Message-Id: <1279901739-10541-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Different devices have different size of phy calibration table; add
new TLV to specify the size. If the TLV is not part of uCode header, the
default table size will be used to make sure the backward
compatibilities.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   24 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    9 +++++++++
 4 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index f06d1fe..a7216dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -164,7 +164,7 @@ static void iwlagn_gain_computation(struct iwl_priv *priv,
 
 		memset(&cmd, 0, sizeof(cmd));
 
-		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD;
+		cmd.hdr.op_code = priv->_agn.phy_calib_chain_noise_gain_cmd;
 		cmd.hdr.first_group = 0;
 		cmd.hdr.groups_num = 1;
 		cmd.hdr.data_valid = 1;
@@ -197,7 +197,7 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 		data->beacon_count = 0;
 
 		memset(&cmd, 0, sizeof(cmd));
-		cmd.hdr.op_code = IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD;
+		cmd.hdr.op_code = priv->_agn.phy_calib_chain_noise_reset_cmd;
 		cmd.hdr.first_group = 0;
 		cmd.hdr.groups_num = 1;
 		cmd.hdr.data_valid = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 33a8f13..db86f70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1692,6 +1692,7 @@ static void iwl_nic_start(struct iwl_priv *priv)
 
 struct iwlagn_ucode_capabilities {
 	u32 max_probe_length;
+	u32 standard_phy_calibration_size;
 };
 
 static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context);
@@ -1967,6 +1968,13 @@ static int iwlagn_load_firmware(struct iwl_priv *priv,
 			else
 				priv->enhance_sensitivity_table = true;
 			break;
+		case IWL_UCODE_TLV_PHY_CALIBRATION_SIZE:
+			if (tlv_len != fixed_tlv_size)
+				ret = -EINVAL;
+			else
+				capa->standard_phy_calibration_size =
+					le32_to_cpup((__le32 *)tlv_data);
+			break;
 		default:
 			IWL_WARN(priv, "unknown TLV: %d\n", tlv_type);
 			break;
@@ -2005,6 +2013,8 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	u32 build;
 	struct iwlagn_ucode_capabilities ucode_capa = {
 		.max_probe_length = 200,
+		.standard_phy_calibration_size =
+			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE,
 	};
 
 	memset(&pieces, 0, sizeof(pieces));
@@ -2226,6 +2236,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 			pieces.boot_size);
 	memcpy(priv->ucode_boot.v_addr, pieces.boot, pieces.boot_size);
 
+	/*
+	 * figure out the offset of chain noise reset and gain commands
+	 * base on the size of standard phy calibration commands table size
+	 */
+	if (ucode_capa.standard_phy_calibration_size >
+	    IWL_MAX_PHY_CALIBRATE_TBL_SIZE)
+		ucode_capa.standard_phy_calibration_size =
+			IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE;
+
+	priv->_agn.phy_calib_chain_noise_reset_cmd =
+		ucode_capa.standard_phy_calibration_size;
+	priv->_agn.phy_calib_chain_noise_gain_cmd =
+		ucode_capa.standard_phy_calibration_size + 1;
+
 	/**************************************************
 	 * This is still part of probe() in a sense...
 	 *
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 04b2e29..67892f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3660,10 +3660,10 @@ enum {
 	IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD	= 15,
 	IWL_PHY_CALIBRATE_BASE_BAND_CMD		= 16,
 	IWL_PHY_CALIBRATE_TX_IQ_PERD_CMD	= 17,
-	IWL_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD	= 18,
-	IWL_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD	= 19,
+	IWL_MAX_STANDARD_PHY_CALIBRATE_TBL_SIZE	= 18,
 };
 
+#define IWL_MAX_PHY_CALIBRATE_TBL_SIZE		(253)
 
 #define IWL_CALIB_INIT_CFG_ALL	cpu_to_le32(0xffffffff)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 297f8d1..4fa8cdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -571,6 +571,7 @@ enum iwl_ucode_tlv_type {
 	IWL_UCODE_TLV_INIT_EVTLOG_SIZE	= 12,
 	IWL_UCODE_TLV_INIT_ERRLOG_PTR	= 13,
 	IWL_UCODE_TLV_ENHANCE_SENS_TBL	= 14,
+	IWL_UCODE_TLV_PHY_CALIBRATION_SIZE = 15,
 };
 
 struct iwl_ucode_tlv {
@@ -1321,6 +1322,14 @@ struct iwl_priv {
 			u32 init_evtlog_ptr, init_evtlog_size, init_errlog_ptr;
 			u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 
+			/*
+			 * chain noise reset and gain commands are the
+			 * two extra calibration commands follows the standard
+			 * phy calibration commands
+			 */
+			u8 phy_calib_chain_noise_reset_cmd;
+			u8 phy_calib_chain_noise_gain_cmd;
+
 			struct iwl_notif_statistics statistics;
 			struct iwl_bt_notif_statistics statistics_bt;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.7.0.4

