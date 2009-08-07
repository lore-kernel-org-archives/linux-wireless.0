Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:24343 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZHGWl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:57 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/16] iwlwifi: Display sensitivity and chain noise information
Date: Fri,  7 Aug 2009 15:41:43 -0700
Message-Id: <1249684912-22936-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Display sensitivity and chain noise data to help understand the current
environment and RF condition.

The data is feeded by statistics notification and Beacon from uCode;
then used by sensitivity calibration and chain noise calibration to
determine how DSP should react to the environment changes

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    2 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  149 +++++++++++++++++++++++++++-
 2 files changed, 150 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 18b8cf7..82befb7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -103,6 +103,8 @@ struct iwl_debugfs {
 		struct dentry *file_ucode_rx_stats;
 		struct dentry *file_ucode_tx_stats;
 		struct dentry *file_ucode_general_stats;
+		struct dentry *file_sensitivity;
+		struct dentry *file_chain_noise;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 20e4edb..1ad4ff6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -38,7 +38,7 @@
 #include "iwl-debug.h"
 #include "iwl-core.h"
 #include "iwl-io.h"
-
+#include "iwl-calib.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_DIR(name, parent) do {                              \
@@ -1346,6 +1346,145 @@ static ssize_t iwl_dbgfs_ucode_general_stats_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_sensitivity_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	int cnt = 0;
+	char *buf;
+	int bufsz = sizeof(struct iwl_sensitivity_data) * 4 + 100;
+	ssize_t ret;
+	struct iwl_sensitivity_data *data;
+
+	data = &priv->sensitivity_data;
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, "auto_corr_ofdm:\t\t\t %u\n",
+			data->auto_corr_ofdm);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"auto_corr_ofdm_mrc:\t\t %u\n",
+			data->auto_corr_ofdm_mrc);
+	pos += scnprintf(buf + pos, bufsz - pos, "auto_corr_ofdm_x1:\t\t %u\n",
+			data->auto_corr_ofdm_x1);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"auto_corr_ofdm_mrc_x1:\t\t %u\n",
+			data->auto_corr_ofdm_mrc_x1);
+	pos += scnprintf(buf + pos, bufsz - pos, "auto_corr_cck:\t\t\t %u\n",
+			data->auto_corr_cck);
+	pos += scnprintf(buf + pos, bufsz - pos, "auto_corr_cck_mrc:\t\t %u\n",
+			data->auto_corr_cck_mrc);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"last_bad_plcp_cnt_ofdm:\t\t %u\n",
+			data->last_bad_plcp_cnt_ofdm);
+	pos += scnprintf(buf + pos, bufsz - pos, "last_fa_cnt_ofdm:\t\t %u\n",
+			data->last_fa_cnt_ofdm);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"last_bad_plcp_cnt_cck:\t\t %u\n",
+			data->last_bad_plcp_cnt_cck);
+	pos += scnprintf(buf + pos, bufsz - pos, "last_fa_cnt_cck:\t\t %u\n",
+			data->last_fa_cnt_cck);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_curr_state:\t\t\t %u\n",
+			data->nrg_curr_state);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_prev_state:\t\t\t %u\n",
+			data->nrg_prev_state);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_value:\t\t\t");
+	for (cnt = 0; cnt < 10; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos, " %u",
+				data->nrg_value[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_silence_rssi:\t\t");
+	for (cnt = 0; cnt < NRG_NUM_PREV_STAT_L; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos, " %u",
+				data->nrg_silence_rssi[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_silence_ref:\t\t %u\n",
+			data->nrg_silence_ref);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_energy_idx:\t\t\t %u\n",
+			data->nrg_energy_idx);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_silence_idx:\t\t %u\n",
+			data->nrg_silence_idx);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_th_cck:\t\t\t %u\n",
+			data->nrg_th_cck);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"nrg_auto_corr_silence_diff:\t %u\n",
+			data->nrg_auto_corr_silence_diff);
+	pos += scnprintf(buf + pos, bufsz - pos, "num_in_cck_no_fa:\t\t %u\n",
+			data->num_in_cck_no_fa);
+	pos += scnprintf(buf + pos, bufsz - pos, "nrg_th_ofdm:\t\t\t %u\n",
+			data->nrg_th_ofdm);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
+
+static ssize_t iwl_dbgfs_chain_noise_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+	int pos = 0;
+	int cnt = 0;
+	char *buf;
+	int bufsz = sizeof(struct iwl_chain_noise_data) * 4 + 100;
+	ssize_t ret;
+	struct iwl_chain_noise_data *data;
+
+	data = &priv->chain_noise_data;
+	buf = kzalloc(bufsz, GFP_KERNEL);
+	if (!buf) {
+		IWL_ERR(priv, "Can not allocate Buffer\n");
+		return -ENOMEM;
+	}
+
+	pos += scnprintf(buf + pos, bufsz - pos, "active_chains:\t\t\t %u\n",
+			data->active_chains);
+	pos += scnprintf(buf + pos, bufsz - pos, "chain_noise_a:\t\t\t %u\n",
+			data->chain_noise_a);
+	pos += scnprintf(buf + pos, bufsz - pos, "chain_noise_b:\t\t\t %u\n",
+			data->chain_noise_b);
+	pos += scnprintf(buf + pos, bufsz - pos, "chain_noise_c:\t\t\t %u\n",
+			data->chain_noise_c);
+	pos += scnprintf(buf + pos, bufsz - pos, "chain_signal_a:\t\t\t %u\n",
+			data->chain_signal_a);
+	pos += scnprintf(buf + pos, bufsz - pos, "chain_signal_b:\t\t\t %u\n",
+			data->chain_signal_b);
+	pos += scnprintf(buf + pos, bufsz - pos, "chain_signal_c:\t\t\t %u\n",
+			data->chain_signal_c);
+	pos += scnprintf(buf + pos, bufsz - pos, "beacon_count:\t\t\t %u\n",
+			data->beacon_count);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "disconn_array:\t\t\t");
+	for (cnt = 0; cnt < NUM_RX_CHAINS; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos, " %u",
+				data->disconn_array[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "delta_gain_code:\t\t");
+	for (cnt = 0; cnt < NUM_RX_CHAINS; cnt++) {
+		pos += scnprintf(buf + pos, bufsz - pos, " %u",
+				data->delta_gain_code[cnt]);
+	}
+	pos += scnprintf(buf + pos, bufsz - pos, "\n");
+	pos += scnprintf(buf + pos, bufsz - pos, "radio_write:\t\t\t %u\n",
+			data->radio_write);
+	pos += scnprintf(buf + pos, bufsz - pos, "state:\t\t\t\t %u\n",
+			data->state);
+
+	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+	kfree(buf);
+	return ret;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1354,6 +1493,8 @@ DEBUGFS_READ_FILE_OPS(tx_queue);
 DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
+DEBUGFS_READ_FILE_OPS(sensitivity);
+DEBUGFS_READ_FILE_OPS(chain_noise);
 
 /*
  * Create the debugfs files and directories
@@ -1404,6 +1545,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
 		DEBUGFS_ADD_FILE(ucode_general_stats, debug);
+		DEBUGFS_ADD_FILE(sensitivity, debug);
+		DEBUGFS_ADD_FILE(chain_noise, debug);
 	}
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
@@ -1456,6 +1599,10 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 			file_ucode_tx_stats);
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_general_stats);
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_sensitivity);
+		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_chain_noise);
 	}
 	DEBUGFS_REMOVE(priv->dbgfs->dir_debug);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
-- 
1.5.6.3

