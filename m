Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab2DWVwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	David Spinadel <david.spinadel@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/29] iwlwifi: Added debugfs calib disabled write
Date: Mon, 23 Apr 2012 14:47:17 -0700
Message-Id: <1335217660-21950-7-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235344_068047_AE2C9A7F)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Added the option to disable calibration via debugfs.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 70c24f5..c93f4e7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2499,6 +2499,27 @@ static ssize_t iwl_dbgfs_calib_disabled_read(struct file *file,
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
+static ssize_t iwl_dbgfs_calib_disabled_write(struct file *file,
+					      const char __user *user_buf,
+					      size_t count, loff_t *ppos)
+{
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	u32 calib_disabled;
+	int buf_size;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) - 1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%x", &calib_disabled) != 1)
+		return -EFAULT;
+
+	priv->calib_disabled = calib_disabled;
+
+	return count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2523,7 +2544,7 @@ DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
 DEBUGFS_WRITE_FILE_OPS(echo_test);
 DEBUGFS_READ_WRITE_FILE_OPS(log_event);
-DEBUGFS_READ_FILE_OPS(calib_disabled);
+DEBUGFS_READ_WRITE_FILE_OPS(calib_disabled);
 
 /*
  * Create the debugfs files and directories
@@ -2592,7 +2613,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 
 	/* Calibrations disabled/enabled status*/
-	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, S_IRUSR);
+	DEBUGFS_ADD_FILE(calib_disabled, dir_rf, S_IWUSR | S_IRUSR);
 
 	if (iwl_trans_dbgfs_register(priv->trans, dir_debug))
 		goto err;
-- 
1.7.0.4

