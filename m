Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab2DWVw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/29] iwlwifi: remove traffic log
Date: Mon, 23 Apr 2012 14:47:27 -0700
Message-Id: <1335217660-21950-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235332_834345_F5CBEB23)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is superseded by tracing and no longer needed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   13 +---
 drivers/net/wireless/iwlwifi/iwl-core.c    |   99 --------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h    |   37 +----------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |  103 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 -
 7 files changed, 5 insertions(+), 253 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index a6a6d8a..45a153f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -969,7 +969,6 @@ static int iwlagn_rx_reply_rx(struct iwl_priv *priv,
 	/* Find max signal strength (dBm) among 3 antenna/receiver chains */
 	rx_status.signal = iwlagn_calc_rssi(priv, phy_res);
 
-	iwl_dbg_log_rx_data_frame(priv, len, header);
 	IWL_DEBUG_STATS_LIMIT(priv, "Rssi %d, TSF %llu\n",
 		rx_status.signal, (unsigned long long)rx_status.mactime);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index b77a079..2a2ac15 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -396,7 +396,6 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* TODO need this for burst mode later on */
 	iwlagn_tx_cmd_build_basic(priv, skb, tx_cmd, info, hdr, sta_id);
-	iwl_dbg_log_tx_data_frame(priv, len, hdr);
 
 	iwlagn_tx_cmd_build_rate(priv, tx_cmd, info, fc);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3024d8c..39187ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1545,7 +1545,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	}
 
 	if (WARN_ON(!priv->lib))
-		goto out_free_traffic_mem;
+		goto out_free_hw;
 
 	/*
 	 * Populate the state variables that the transport layer needs
@@ -1609,9 +1609,6 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	IWL_DEBUG_INFO(priv, "BT channel inhibition is %s\n",
 		       (priv->bt_ch_announce) ? "On" : "Off");
 
-	if (iwl_alloc_traffic_mem(priv))
-		IWL_ERR(priv, "Not enough memory to generate traffic log\n");
-
 	/* these spin locks will be used in apm_ops.init and EEPROM access
 	 * we should init now
 	 */
@@ -1625,12 +1622,12 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 		priv->cfg->name, priv->trans->hw_rev);
 
 	if (iwl_trans_start_hw(priv->trans))
-		goto out_free_traffic_mem;
+		goto out_free_hw;
 
 	/* Read the EEPROM */
 	if (iwl_eeprom_init(priv, priv->trans->hw_rev)) {
 		IWL_ERR(priv, "Unable to init EEPROM\n");
-		goto out_free_traffic_mem;
+		goto out_free_hw;
 	}
 	/* Reset chip to save power until we load uCode during "up". */
 	iwl_trans_stop_hw(priv->trans, false);
@@ -1745,8 +1742,7 @@ out_destroy_workqueue:
 	iwl_uninit_drv(priv);
 out_free_eeprom:
 	iwl_eeprom_free(priv);
-out_free_traffic_mem:
-	iwl_free_traffic_mem(priv);
+out_free_hw:
 	ieee80211_free_hw(priv->hw);
 out:
 	op_mode = NULL;
@@ -1780,7 +1776,6 @@ void iwl_op_mode_dvm_stop(struct iwl_op_mode *op_mode)
 	 * until now... */
 	destroy_workqueue(priv->workqueue);
 	priv->workqueue = NULL;
-	iwl_free_traffic_mem(priv);
 
 	iwl_uninit_drv(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index a476397..52805a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -42,99 +42,6 @@
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
-#define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
-
-void iwl_reset_traffic_log(struct iwl_priv *priv)
-{
-	priv->tx_traffic_idx = 0;
-	priv->rx_traffic_idx = 0;
-	if (priv->tx_traffic)
-		memset(priv->tx_traffic, 0, IWL_TRAFFIC_DUMP_SIZE);
-	if (priv->rx_traffic)
-		memset(priv->rx_traffic, 0, IWL_TRAFFIC_DUMP_SIZE);
-}
-
-int iwl_alloc_traffic_mem(struct iwl_priv *priv)
-{
-	u32 traffic_size = IWL_TRAFFIC_DUMP_SIZE;
-
-	if (iwl_have_debug_level(IWL_DL_TX)) {
-		if (!priv->tx_traffic) {
-			priv->tx_traffic =
-				kzalloc(traffic_size, GFP_KERNEL);
-			if (!priv->tx_traffic)
-				return -ENOMEM;
-		}
-	}
-	if (iwl_have_debug_level(IWL_DL_RX)) {
-		if (!priv->rx_traffic) {
-			priv->rx_traffic =
-				kzalloc(traffic_size, GFP_KERNEL);
-			if (!priv->rx_traffic)
-				return -ENOMEM;
-		}
-	}
-	iwl_reset_traffic_log(priv);
-	return 0;
-}
-
-void iwl_free_traffic_mem(struct iwl_priv *priv)
-{
-	kfree(priv->tx_traffic);
-	priv->tx_traffic = NULL;
-
-	kfree(priv->rx_traffic);
-	priv->rx_traffic = NULL;
-}
-
-void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
-		      u16 length, struct ieee80211_hdr *header)
-{
-	__le16 fc;
-	u16 len;
-
-	if (likely(!iwl_have_debug_level(IWL_DL_TX)))
-		return;
-
-	if (!priv->tx_traffic)
-		return;
-
-	fc = header->frame_control;
-	if (ieee80211_is_data(fc)) {
-		len = (length > IWL_TRAFFIC_ENTRY_SIZE)
-		       ? IWL_TRAFFIC_ENTRY_SIZE : length;
-		memcpy((priv->tx_traffic +
-		       (priv->tx_traffic_idx * IWL_TRAFFIC_ENTRY_SIZE)),
-		       header, len);
-		priv->tx_traffic_idx =
-			(priv->tx_traffic_idx + 1) % IWL_TRAFFIC_ENTRIES;
-	}
-}
-
-void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
-		      u16 length, struct ieee80211_hdr *header)
-{
-	__le16 fc;
-	u16 len;
-
-	if (likely(!iwl_have_debug_level(IWL_DL_RX)))
-		return;
-
-	if (!priv->rx_traffic)
-		return;
-
-	fc = header->frame_control;
-	if (ieee80211_is_data(fc)) {
-		len = (length > IWL_TRAFFIC_ENTRY_SIZE)
-		       ? IWL_TRAFFIC_ENTRY_SIZE : length;
-		memcpy((priv->rx_traffic +
-		       (priv->rx_traffic_idx * IWL_TRAFFIC_ENTRY_SIZE)),
-		       header, len);
-		priv->rx_traffic_idx =
-			(priv->rx_traffic_idx + 1) % IWL_TRAFFIC_ENTRIES;
-	}
-}
-
 const char *get_mgmt_string(int cmd)
 {
 #define IWL_CMD(x) case x: return #x
@@ -177,12 +84,6 @@ const char *get_ctrl_string(int cmd)
 #undef IWL_CMD
 }
 
-void iwl_clear_traffic_stats(struct iwl_priv *priv)
-{
-	memset(&priv->tx_stats, 0, sizeof(struct traffic_stats));
-	memset(&priv->rx_stats, 0, sizeof(struct traffic_stats));
-}
-
 /*
  * if CONFIG_IWLWIFI_DEBUGFS defined, iwl_update_stats function will
  * record all the MGMT, CTRL and DATA pkt for both TX and Rx pass.
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3ec011b..cfa539b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -77,49 +77,14 @@ struct iwl_cmd;
  ***************************/
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-int iwl_alloc_traffic_mem(struct iwl_priv *priv);
-void iwl_free_traffic_mem(struct iwl_priv *priv);
-void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
-				u16 length, struct ieee80211_hdr *header);
-void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
-				u16 length, struct ieee80211_hdr *header);
 const char *get_mgmt_string(int cmd);
 const char *get_ctrl_string(int cmd);
-void iwl_clear_traffic_stats(struct iwl_priv *priv);
-void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc,
-		      u16 len);
-void iwl_reset_traffic_log(struct iwl_priv *priv);
-
+void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len);
 #else
-static inline int iwl_alloc_traffic_mem(struct iwl_priv *priv)
-{
-	return 0;
-}
-static inline void iwl_free_traffic_mem(struct iwl_priv *priv)
-{
-}
-static inline void iwl_reset_traffic_log(struct iwl_priv *priv)
-{
-}
-static inline void iwl_dbg_log_tx_data_frame(struct iwl_priv *priv,
-		      u16 length, struct ieee80211_hdr *header)
-{
-}
-static inline void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
-		      u16 length, struct ieee80211_hdr *header)
-{
-}
 static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 				    __le16 fc, u16 len)
 {
 }
 #endif
 
-/*******************************************************************************
- * Scanning
- ******************************************************************************/
-/* traffic log definitions */
-#define IWL_TRAFFIC_ENTRIES	(256)
-#define IWL_TRAFFIC_ENTRY_SIZE  (64)
-
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index f4a9910..eb93fdd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -150,26 +150,6 @@ static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_clear_traffic_statistics_write(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	u32 clear_flag;
-	char buf[8];
-	int buf_size;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%x", &clear_flag) != 1)
-		return -EFAULT;
-	iwl_clear_traffic_stats(priv);
-
-	return count;
-}
-
 static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 						char __user *user_buf,
 						size_t count, loff_t *ppos) {
@@ -805,85 +785,6 @@ DEBUGFS_READ_FILE_OPS(temperature);
 DEBUGFS_READ_WRITE_FILE_OPS(sleep_level_override);
 DEBUGFS_READ_FILE_OPS(current_sleep_command);
 
-static ssize_t iwl_dbgfs_traffic_log_read(struct file *file,
-					 char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	int pos = 0, ofs = 0;
-	int cnt = 0, entry;
-
-	char *buf;
-	int bufsz = ((IWL_TRAFFIC_ENTRIES * IWL_TRAFFIC_ENTRY_SIZE * 64) * 2) +
-		(priv->cfg->base_params->num_of_queues * 32 * 8) + 400;
-	const u8 *ptr;
-	ssize_t ret;
-
-	buf = kzalloc(bufsz, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
-	if (priv->tx_traffic && iwl_have_debug_level(IWL_DL_TX)) {
-		ptr = priv->tx_traffic;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Tx Traffic idx: %u\n", priv->tx_traffic_idx);
-		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
-			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
-			     entry++,  ofs += 16) {
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"0x%.4x ", ofs);
-				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
-						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf + pos);
-				if (bufsz - pos > 0)
-					buf[pos++] = '\n';
-			}
-		}
-	}
-
-	if (priv->rx_traffic && iwl_have_debug_level(IWL_DL_RX)) {
-		ptr = priv->rx_traffic;
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Rx Traffic idx: %u\n", priv->rx_traffic_idx);
-		for (cnt = 0, ofs = 0; cnt < IWL_TRAFFIC_ENTRIES; cnt++) {
-			for (entry = 0; entry < IWL_TRAFFIC_ENTRY_SIZE / 16;
-			     entry++,  ofs += 16) {
-				pos += scnprintf(buf + pos, bufsz - pos,
-						"0x%.4x ", ofs);
-				hex_dump_to_buffer(ptr + ofs, 16, 16, 2,
-						   buf + pos, bufsz - pos, 0);
-				pos += strlen(buf + pos);
-				if (bufsz - pos > 0)
-					buf[pos++] = '\n';
-			}
-		}
-	}
-
-	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
-	kfree(buf);
-	return ret;
-}
-
-static ssize_t iwl_dbgfs_traffic_log_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int traffic_log;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &traffic_log) != 1)
-		return -EFAULT;
-	if (traffic_log == 0)
-		iwl_reset_traffic_log(priv);
-
-	return count;
-}
-
 static const char *fmt_value = "  %-30s %10u\n";
 static const char *fmt_hex   = "  %-30s       0x%02X\n";
 static const char *fmt_table = "  %-30s %10u  %10u  %10u  %10u\n";
@@ -2506,7 +2407,6 @@ static ssize_t iwl_dbgfs_calib_disabled_write(struct file *file,
 
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
-DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_FILE_OPS(ucode_rx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_tx_stats);
 DEBUGFS_READ_FILE_OPS(ucode_general_stats);
@@ -2514,7 +2414,6 @@ DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(power_save_status);
 DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
-DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
@@ -2571,10 +2470,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 
 	DEBUGFS_ADD_FILE(rx_statistics, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(tx_statistics, dir_debug, S_IRUSR);
-	DEBUGFS_ADD_FILE(traffic_log, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(power_save_status, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(clear_ucode_statistics, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(rf_reset, dir_debug, S_IWUSR | S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index a76be80..e89dc26 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1017,10 +1017,6 @@ struct iwl_priv {
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	/* debugfs */
-	u16 tx_traffic_idx;
-	u16 rx_traffic_idx;
-	u8 *tx_traffic;
-	u8 *rx_traffic;
 	struct dentry *debugfs_dir;
 	u32 dbgfs_sram_offset, dbgfs_sram_len;
 	bool disable_ht40;
-- 
1.7.0.4

