Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:42954 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZKTUFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Nov 2009 15:05:06 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 05/19] iwlwifi: reset led_tpt when clear tx/rx traffic byte counts
Date: Fri, 20 Nov 2009 12:04:56 -0800
Message-Id: <1258747510-21233-6-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
References: <1258747510-21233-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

LED blink rate is based on the traffic load, when tx/rx traffic counts
got reset, we also need to reset the led_tpt to prevent incorrect
blink rate being calculated.

Merge both clear_tx_statistics() and clear_rx_statistics() into
single clear_traffic_statistics() function, when reset the traffic byte
counts, both tx and rx need to be reset at the same time, to make
sure calculated the correct led blink rate.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c    |    8 +----
 drivers/net/wireless/iwlwifi/iwl-core.h    |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   42 ++++++++-------------------
 4 files changed, 18 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 2d6d590..f423afc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3080,15 +3080,11 @@ const char *get_ctrl_string(int cmd)
 	}
 }
 
-void iwl_clear_tx_stats(struct iwl_priv *priv)
+void iwl_clear_traffic_stats(struct iwl_priv *priv)
 {
 	memset(&priv->tx_stats, 0, sizeof(struct traffic_stats));
-
-}
-
-void iwl_clear_rx_stats(struct iwl_priv *priv)
-{
 	memset(&priv->rx_stats, 0, sizeof(struct traffic_stats));
+	priv->led_tpt = 0;
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d75471c..14a9d13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -353,8 +353,7 @@ void iwl_dbg_log_rx_data_frame(struct iwl_priv *priv,
 				u16 length, struct ieee80211_hdr *header);
 const char *get_mgmt_string(int cmd);
 const char *get_ctrl_string(int cmd);
-void iwl_clear_tx_stats(struct iwl_priv *priv);
-void iwl_clear_rx_stats(struct iwl_priv *priv);
+void iwl_clear_traffic_stats(struct iwl_priv *priv);
 void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc,
 		      u16 len);
 #else
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 25a0e73..d61293a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -107,7 +107,8 @@ struct iwl_debugfs {
 		struct dentry *file_chain_noise;
 		struct dentry *file_tx_power;
 		struct dentry *file_power_save_status;
-		struct dentry *file_clear_statistics;
+		struct dentry *file_clear_ucode_statistics;
+		struct dentry *file_clear_traffic_statistics;
 	} dbgfs_debug_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 9a5ca25..b8f9edc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -160,7 +160,7 @@ static ssize_t iwl_dbgfs_tx_statistics_read(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_tx_statistics_write(struct file *file,
+static ssize_t iwl_dbgfs_clear_traffic_statistics_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos)
 {
@@ -175,8 +175,7 @@ static ssize_t iwl_dbgfs_tx_statistics_write(struct file *file,
 		return -EFAULT;
 	if (sscanf(buf, "%x", &clear_flag) != 1)
 		return -EFAULT;
-	if (clear_flag == 1)
-		iwl_clear_tx_stats(priv);
+	iwl_clear_traffic_stats(priv);
 
 	return count;
 }
@@ -221,26 +220,6 @@ static ssize_t iwl_dbgfs_rx_statistics_read(struct file *file,
 	return ret;
 }
 
-static ssize_t iwl_dbgfs_rx_statistics_write(struct file *file,
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
-	if (clear_flag == 1)
-		iwl_clear_rx_stats(priv);
-	return count;
-}
-
 #define BYTE1_MASK 0x000000ff;
 #define BYTE2_MASK 0x0000ffff;
 #define BYTE3_MASK 0x00ffffff;
@@ -1823,7 +1802,7 @@ static ssize_t iwl_dbgfs_power_save_status_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_clear_statistics_write(struct file *file,
+static ssize_t iwl_dbgfs_clear_ucode_statistics_write(struct file *file,
 					 const char __user *user_buf,
 					 size_t count, loff_t *ppos)
 {
@@ -1847,8 +1826,8 @@ static ssize_t iwl_dbgfs_clear_statistics_write(struct file *file,
 	return count;
 }
 
-DEBUGFS_READ_WRITE_FILE_OPS(rx_statistics);
-DEBUGFS_READ_WRITE_FILE_OPS(tx_statistics);
+DEBUGFS_READ_FILE_OPS(rx_statistics);
+DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
@@ -1859,7 +1838,8 @@ DEBUGFS_READ_FILE_OPS(sensitivity);
 DEBUGFS_READ_FILE_OPS(chain_noise);
 DEBUGFS_READ_FILE_OPS(tx_power);
 DEBUGFS_READ_FILE_OPS(power_save_status);
-DEBUGFS_WRITE_FILE_OPS(clear_statistics);
+DEBUGFS_WRITE_FILE_OPS(clear_ucode_statistics);
+DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 
 /*
  * Create the debugfs files and directories
@@ -1908,7 +1888,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(tx_queue, debug);
 	DEBUGFS_ADD_FILE(tx_power, debug);
 	DEBUGFS_ADD_FILE(power_save_status, debug);
-	DEBUGFS_ADD_FILE(clear_statistics, debug);
+	DEBUGFS_ADD_FILE(clear_ucode_statistics, debug);
+	DEBUGFS_ADD_FILE(clear_traffic_statistics, debug);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, debug);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, debug);
@@ -1962,7 +1943,10 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_queue);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_tx_power);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_power_save_status);
-	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.file_clear_statistics);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_clear_ucode_statistics);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
+			file_clear_traffic_statistics);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_REMOVE(priv->dbgfs->dbgfs_debug_files.
 			file_ucode_rx_stats);
-- 
1.5.6.3

