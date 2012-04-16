Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57140 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755629Ab2DPWBb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:31 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Dor Shaish <dor.shaish@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/16] iwlwifi: Disabling calibrations variable
Date: Mon, 16 Apr 2012 14:57:06 -0700
Message-Id: <1334613430-30720-13-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120417_000138_939387_F1BF851B)
In-Reply-To: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334613430-30720-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

Add a variable for disabling specific calibrations.
Merged old variables for calibrations disabling.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    6 ++--
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    9 +++++-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c   |   35 +++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   11 ++++++-
 4 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 2f73109..61c243f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -599,7 +599,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	struct iwl_sensitivity_data *data = NULL;
 	const struct iwl_sensitivity_ranges *ranges = priv->hw_params.sens;
 
-	if (priv->disable_sens_cal)
+	if (priv->calib_disabled & IWL_SENSITIVITY_CALIB_DISABLED)
 		return;
 
 	IWL_DEBUG_CALIB(priv, "Start iwl_init_sensitivity\n");
@@ -663,7 +663,7 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv)
 	struct statistics_rx_phy *ofdm, *cck;
 	struct statistics_general_data statis;
 
-	if (priv->disable_sens_cal)
+	if (priv->calib_disabled & IWL_SENSITIVITY_CALIB_DISABLED)
 		return;
 
 	data = &(priv->sensitivity_data);
@@ -970,7 +970,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv)
 	 */
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
-	if (priv->disable_chain_noise_cal)
+	if (priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED)
 		return;
 
 	data = &(priv->chain_noise_data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 69279af..88a7f3a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -414,6 +414,9 @@ static int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 	bool defer;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
 
+	if (priv->calib_disabled & IWL_TX_POWER_CALIB_DISABLED)
+		return 0;
+
 	lockdep_assert_held(&priv->mutex);
 
 	if (priv->tx_power_user_lmt == tx_power && !force)
@@ -1319,6 +1322,9 @@ static void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
+	if (!(priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED))
+		return;
+
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
 	    iwl_is_any_associated(priv)) {
 		struct iwl_calib_chain_noise_reset_cmd cmd;
@@ -1471,8 +1477,7 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			iwl_power_update_mode(priv, false);
 
 		/* Enable RX differential gain and sensitivity calibrations */
-		if (!priv->disable_chain_noise_cal)
-			iwlagn_chain_noise_reset(priv);
+		iwlagn_chain_noise_reset(priv);
 		priv->start_calib = 1;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index a77f457..4d1f1dd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2471,6 +2471,34 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_calib_disabled_read(struct file *file,
+					 char __user *user_buf,
+					 size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[120];
+	int pos = 0;
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "Sensitivity calibrations %s\n",
+			 (priv->calib_disabled &
+					IWL_SENSITIVITY_CALIB_DISABLED) ?
+			 "DISABLED" : "ENABLED");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "Chain noise calibrations %s\n",
+			 (priv->calib_disabled &
+					IWL_CHAIN_NOISE_CALIB_DISABLED) ?
+			 "DISABLED" : "ENABLED");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			 "Tx power calibrations %s\n",
+			 (priv->calib_disabled &
+					IWL_TX_POWER_CALIB_DISABLED) ?
+			 "DISABLED" : "ENABLED");
+
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2495,6 +2523,7 @@ DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
 DEBUGFS_WRITE_FILE_OPS(echo_test);
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
+DEBUGFS_READ_FILE_OPS(calib_disabled);
 
 /*
  * Create the debugfs files and directories
@@ -2562,10 +2591,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	if (iwl_advanced_bt_coexist(priv))
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 
-	DEBUGFS_ADD_BOOL(disable_sensitivity, dir_rf,
-			 &priv->disable_sens_cal);
-	DEBUGFS_ADD_BOOL(disable_chain_noise, dir_rf,
-			 &priv->disable_chain_noise_cal);
+	/* Calibrations disabled/enabled status*/
+	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, S_IRUSR);
 
 	if (iwl_trans_dbgfs_register(trans(priv), dir_debug))
 		goto err;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index d56d4db..c235a1e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -741,6 +741,14 @@ struct iwl_wipan_noa_data {
 	u8 data[];
 };
 
+/* Calibration disabling bit mask */
+#define IWL_SENSITIVITY_CALIB_DISABLED	BIT(1)
+#define IWL_CHAIN_NOISE_CALIB_DISABLED	BIT(2)
+#define IWL_TX_POWER_CALIB_DISABLED	BIT(3)
+
+#define IWL_CALIB_ENABLE_ALL	0
+#define IWL_CALIB_DISABLE_ALL	0xFFFFFFFF
+
 #define IWL_OP_MODE_GET_DVM(_iwl_op_mode) \
 	((struct iwl_priv *) ((_iwl_op_mode)->op_mode_specific))
 
@@ -1010,8 +1018,7 @@ struct iwl_priv {
 	enum iwl_nvm_type nvm_device_type;
 
 	struct work_struct txpower_work;
-	u32 disable_sens_cal;
-	u32 disable_chain_noise_cal;
+	u32 calib_disabled;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
-- 
1.7.0.4

