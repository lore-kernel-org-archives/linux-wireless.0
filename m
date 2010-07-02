Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:64101 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759533Ab0GBSoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlwifi: debugfs file for txfifo command testing
Date: Fri,  2 Jul 2010 11:45:38 -0700
Message-Id: <1278096340-2546-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Add debugfs file for REPLY_TXFIFO_FLUSH host command testing.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 48f8908..088a2c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1495,6 +1495,30 @@ static ssize_t iwl_dbgfs_force_reset_write(struct file *file,
 	return ret ? ret : count;
 }
 
+static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int flush;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &flush) != 1)
+		return -EINVAL;
+
+	if (iwl_is_rfkill(priv))
+		return -EFAULT;
+
+	priv->cfg->ops->lib->dev_txfifo_flush(priv, IWL_DROP_ALL);
+
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1516,6 +1540,7 @@ DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
 DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
+DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
 
 /*
  * Create the debugfs files and directories
@@ -1574,6 +1599,8 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
+	if (priv->cfg->ops->lib->dev_txfifo_flush)
+		DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
 
 	if (priv->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-- 
1.7.0.4

