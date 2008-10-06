Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYJFILu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 04:11:50 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 1/7] iwlwifi: make initial calibration set configurable
Date: Mon,  6 Oct 2008 16:05:27 +0800
Message-Id: <1223280333-4383-2-git-send-email-yi.zhu@intel.com> (sfid-20081006_101200_993471_D17DA1AA)
In-Reply-To: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds ability to configure inital calibration set.
Some clean ups are also included in this patch.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   44 +++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    8 +++--
 drivers/net/wireless/iwlwifi/iwl-commands.h |   27 +++++++----------
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 ++-
 5 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index c479ee2..66ed993 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -132,6 +132,7 @@ struct iwl5000_shared {
 /* calibrations defined for 5000 */
 /* defines the order in which results should be sent to the runtime uCode */
 enum iwl5000_calib {
+	IWL5000_CALIB_XTAL,
 	IWL5000_CALIB_LO,
 	IWL5000_CALIB_TX_IQ,
 	IWL5000_CALIB_TX_IQ_PERD,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index f6003e7..ba92667 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -429,20 +429,19 @@ static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
 /*
  *  Calibration
  */
-static int iwl5000_send_Xtal_calib(struct iwl_priv *priv)
+static int iwl5000_set_Xtal_calib(struct iwl_priv *priv)
 {
+	u8 data[sizeof(struct iwl5000_calib_hdr) +
+		sizeof(struct iwl_cal_xtal_freq)];
+	struct iwl5000_calib_cmd *cmd = (struct iwl5000_calib_cmd *)data;
+	struct iwl_cal_xtal_freq *xtal = (struct iwl_cal_xtal_freq *)cmd->data;
 	u16 *xtal_calib = (u16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
 
-	struct iwl5000_calibration cal_cmd = {
-		.op_code = IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD,
-		.data = {
-			(u8)xtal_calib[0],
-			(u8)xtal_calib[1],
-		}
-	};
-
-	return iwl_send_cmd_pdu(priv, REPLY_PHY_CALIBRATION_CMD,
-				sizeof(cal_cmd), &cal_cmd);
+	cmd->hdr.op_code = IWL5000_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
+	xtal->cap_pin1 = (u8)xtal_calib[0];
+	xtal->cap_pin2 = (u8)xtal_calib[1];
+	return iwl_calib_set(&priv->calib_results[IWL5000_CALIB_XTAL],
+			     data, sizeof(data));
 }
 
 static int iwl5000_send_calib_cfg(struct iwl_priv *priv)
@@ -784,10 +783,8 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 
 	iwl5000_send_wimax_coex(priv);
 
-	iwl5000_send_Xtal_calib(priv);
-
-	if (priv->ucode_type == UCODE_RT)
-		iwl_send_calib_results(priv);
+	iwl5000_set_Xtal_calib(priv);
+	iwl_send_calib_results(priv);
 
 	return 0;
 }
@@ -844,6 +841,23 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
 		break;
 	}
 
+	/* Set initial calibration set */
+	switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
+	case CSR_HW_REV_TYPE_5100:
+	case CSR_HW_REV_TYPE_5300:
+	case CSR_HW_REV_TYPE_5350:
+		priv->hw_params.calib_init_cfg =
+			BIT(IWL5000_CALIB_XTAL)		|
+			BIT(IWL5000_CALIB_LO)		|
+			BIT(IWL5000_CALIB_TX_IQ) 	|
+			BIT(IWL5000_CALIB_TX_IQ_PERD);
+		break;
+	case CSR_HW_REV_TYPE_5150:
+		priv->hw_params.calib_init_cfg = 0;
+		break;
+	}
+
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 72fbf47..25f4658 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -70,7 +70,7 @@
  * INIT calibrations framework
  *****************************************************************************/
 
- int iwl_send_calib_results(struct iwl_priv *priv)
+int iwl_send_calib_results(struct iwl_priv *priv)
 {
 	int ret = 0;
 	int i = 0;
@@ -80,14 +80,16 @@
 		.meta.flags = CMD_SIZE_HUGE,
 	};
 
-	for (i = 0; i < IWL_CALIB_MAX; i++)
-		if (priv->calib_results[i].buf) {
+	for (i = 0; i < IWL_CALIB_MAX; i++) {
+		if ((BIT(i) & priv->hw_params.calib_init_cfg) &&
+		    priv->calib_results[i].buf) {
 			hcmd.len = priv->calib_results[i].buf_len;
 			hcmd.data = priv->calib_results[i].buf;
 			ret = iwl_send_cmd_sync(priv, &hcmd);
 			if (ret)
 				goto err;
 		}
+	}
 
 	return 0;
 err:
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 8d04e96..fc467c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -98,6 +98,11 @@ enum {
 	COEX_MEDIUM_NOTIFICATION = 0x5b,
 	COEX_EVENT_CMD = 0x5c,
 
+	/* Calibration */
+	CALIBRATION_CFG_CMD = 0x65,
+	CALIBRATION_RES_NOTIFICATION = 0x66,
+	CALIBRATION_COMPLETE_NOTIFICATION = 0x67,
+
 	/* 802.11h related */
 	RADAR_NOTIFICATION = 0x70,	/* not used */
 	REPLY_QUIET_CMD = 0x71,		/* not used */
@@ -2879,25 +2884,11 @@ enum {
 	IWL5000_PHY_CALIBRATE_CHAIN_NOISE_GAIN_CMD = 19,
 };
 
-enum {
-	CALIBRATION_CFG_CMD = 0x65,
-	CALIBRATION_RES_NOTIFICATION = 0x66,
-	CALIBRATION_COMPLETE_NOTIFICATION = 0x67
-};
-
-struct iwl_cal_crystal_freq_cmd {
+struct iwl_cal_xtal_freq {
 	u8 cap_pin1;
 	u8 cap_pin2;
 } __attribute__ ((packed));
 
-struct iwl5000_calibration {
-	u8 op_code;
-	u8 first_group;
-	u8 num_groups;
-	u8 all_data_valid;
-	struct iwl_cal_crystal_freq_cmd data;
-} __attribute__ ((packed));
-
 #define IWL_CALIB_INIT_CFG_ALL	__constant_cpu_to_le32(0xffffffff)
 
 struct iwl_calib_cfg_elmnt_s {
@@ -2927,6 +2918,11 @@ struct iwl5000_calib_hdr {
 	u8 data_valid;
 } __attribute__ ((packed));
 
+struct iwl5000_calib_cmd {
+	struct iwl5000_calib_hdr hdr;
+	u8 data[0];
+} __attribute__ ((packed));
+
 struct iwl5000_calibration_chain_noise_reset_cmd {
 	u8 op_code;	/* IWL5000_PHY_CALIBRATE_CHAIN_NOISE_RESET_CMD */
 	u8 flags;	/* not used */
@@ -3039,7 +3035,6 @@ struct iwl_rx_packet {
 		struct iwl_notif_statistics stats;
 		struct iwl_compressed_ba_resp compressed_ba;
 		struct iwl4965_missed_beacon_notif missed_beacon;
-		struct iwl5000_calibration calib;
 		__le32 status;
 		u8 raw[0];
 	} u;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c018121..2125844 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -527,6 +527,7 @@ struct iwl_sensitivity_ranges {
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
+ * @calib_init_cfg: setup initial claibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  * @first_ampdu_q: first HW queue available for ampdu
  */
@@ -548,6 +549,7 @@ struct iwl_hw_params {
 	u32 max_data_size;
 	u32 max_bsm_size;
 	u32 ct_kill_threshold; /* value in hw-dependent units */
+	u32 calib_init_cfg;
 	const struct iwl_sensitivity_ranges *sens;
 	u8 first_ampdu_q;
 };
@@ -765,7 +767,7 @@ enum {
 
 
 #define IWL_MAX_NUM_QUEUES	20 /* FIXME: do dynamic allocation */
-#define IWL_CALIB_MAX  3
+#define IWL_CALIB_MAX  4
 
 struct iwl_priv {
 
-- 
1.5.3.6

