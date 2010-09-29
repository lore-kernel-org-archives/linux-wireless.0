Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9419 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754651Ab0I2A4y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:56:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Shanyu Zhao <shanyu.zhao@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlwifi: send DC calib config to runtime ucode
Date: Tue, 28 Sep 2010 17:56:57 -0700
Message-Id: <1285721818-10281-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

Since uCode is responsible for doing DC calibration, there's no need
to let init uCode to do initial DC calibration then send results
back to driver, then driver sends the results to runtime uCode.
Driver can simply tell runtime uCode to do DC calibration.

Actually, this patch does not disable DC calib for init uCode. It just
prevent driver from saving and sending the DC calib results (from init
ucode) to runtime uCode. The driver still uses 0xffffffff in
CALIB_CFG_CMD for init ucode.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-commands.h |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 ++
 4 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 83a5262..51444c8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -199,7 +199,7 @@ static int iwl6000_hw_set_hw_params(struct iwl_priv *priv)
 		BIT(IWL_CALIB_TX_IQ)		|
 		BIT(IWL_CALIB_BASE_BAND);
 	if (priv->cfg->need_dc_calib)
-		priv->hw_params.calib_init_cfg |= BIT(IWL_CALIB_DC);
+		priv->hw_params.calib_rt_cfg |= BIT(IWL_CALIB_CFG_DC_IDX);
 
 	priv->hw_params.beacon_time_tsf_bits = IWLAGN_EXT_BEACON_TIME_POS;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 005b07b..e23c554 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2765,6 +2765,25 @@ static void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 	}
 }
 
+static int iwlagn_send_calib_cfg_rt(struct iwl_priv *priv, u32 cfg)
+{
+	struct iwl_calib_cfg_cmd calib_cfg_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = CALIBRATION_CFG_CMD,
+		.len = sizeof(struct iwl_calib_cfg_cmd),
+		.data = &calib_cfg_cmd,
+	};
+
+	memset(&calib_cfg_cmd, 0, sizeof(calib_cfg_cmd));
+	calib_cfg_cmd.ucd_calib_cfg.once.is_enable = IWL_CALIB_INIT_CFG_ALL;
+	calib_cfg_cmd.ucd_calib_cfg.once.start = cfg;
+	calib_cfg_cmd.ucd_calib_cfg.once.send_res = 0;
+	calib_cfg_cmd.ucd_calib_cfg.flags = 0;
+
+	return iwl_send_cmd(priv, &cmd);
+}
+
+
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
@@ -2801,6 +2820,10 @@ static void iwl_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
+	if (priv->hw_params.calib_rt_cfg)
+		iwlagn_send_calib_cfg_rt(priv, priv->hw_params.calib_rt_cfg);
+
+
 	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 27e250c..27350ee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3800,6 +3800,21 @@ enum {
 
 #define IWL_CALIB_INIT_CFG_ALL	cpu_to_le32(0xffffffff)
 
+/* This enum defines the bitmap of various calibrations to enable in both
+ * init ucode and runtime ucode through CALIBRATION_CFG_CMD.
+ */
+enum iwl_ucode_calib_cfg {
+	IWL_CALIB_CFG_RX_BB_IDX,
+	IWL_CALIB_CFG_DC_IDX,
+	IWL_CALIB_CFG_TX_IQ_IDX,
+	IWL_CALIB_CFG_RX_IQ_IDX,
+	IWL_CALIB_CFG_NOISE_IDX,
+	IWL_CALIB_CFG_CRYSTAL_IDX,
+	IWL_CALIB_CFG_TEMPERATURE_IDX,
+	IWL_CALIB_CFG_PAPD_IDX,
+};
+
+
 struct iwl_calib_cfg_elmnt_s {
 	__le32 is_enable;
 	__le32 start;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 74d25bc..90a37a9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -684,6 +684,7 @@ struct iwl_sensitivity_ranges {
  * @ct_kill_threshold: temperature threshold
  * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
  * @calib_init_cfg: setup initial calibrations for the hw
+ * @calib_rt_cfg: setup runtime calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
  */
 struct iwl_hw_params {
@@ -710,6 +711,7 @@ struct iwl_hw_params {
 				    /* for 1000, 6000 series and up */
 	u16 beacon_time_tsf_bits;
 	u32 calib_init_cfg;
+	u32 calib_rt_cfg;
 	const struct iwl_sensitivity_ranges *sens;
 };
 
-- 
1.7.0.4

