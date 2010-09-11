Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42166 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753361Ab0IKQGo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Sep 2010 12:06:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 05/10] iwlwifi: allow configure protection mode
Date: Sat, 11 Sep 2010 09:08:33 -0700
Message-Id: <1284221318-28281-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1284221318-28281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Even driver use rts/cts protection mode for aggregation packets by default.
Allow the protection mode to be configure through debugfs

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   40 ++++++++++++++++++++++++++++
 1 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 86017ed..e0b31a2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1604,6 +1604,44 @@ static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_protection_mode_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
+
+	int pos = 0;
+	char buf[40];
+	const size_t bufsz = sizeof(buf);
+
+	pos += scnprintf(buf + pos, bufsz - pos, "use %s for aggregation\n",
+			 (priv->cfg->use_rts_for_aggregation) ? "rts/cts" :
+			 "cts-to-self");
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
+static ssize_t iwl_dbgfs_protection_mode_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int rts;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &rts) != 1)
+		return -EINVAL;
+	if (rts)
+		priv->cfg->use_rts_for_aggregation = true;
+	else
+		priv->cfg->use_rts_for_aggregation = false;
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -1629,6 +1667,7 @@ DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
 DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
 DEBUGFS_WRITE_FILE_OPS(monitor_period);
 DEBUGFS_READ_FILE_OPS(bt_traffic);
+DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 
 /*
  * Create the debugfs files and directories
@@ -1689,6 +1728,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
 	if (priv->cfg->ops->lib->dev_txfifo_flush)
 		DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(protection_mode, dir_debug, S_IWUSR | S_IRUSR);
 
 	if (priv->cfg->sensitivity_calib_by_driver)
 		DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-- 
1.7.0.4

