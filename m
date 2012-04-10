Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2DJAuV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:21 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/11] iwlwifi: remove watchdog debugfs file
Date: Mon,  9 Apr 2012 17:46:52 -0700
Message-Id: <1334018821-30416-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025028_188364_2A85E8E1)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This file isn't really all that useful as
when the watchdog triggered it's already
too late, and the setting doesn't persist
unlike e.g. a module parameter that could
be added to the right config file.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 417fc37..a7df9de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2353,29 +2353,6 @@ static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_wd_timeout_write(struct file *file,
-					const char __user *user_buf,
-					size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int timeout;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &timeout) != 1)
-		return -EINVAL;
-	if (timeout < 0 || timeout > IWL_MAX_WD_TIMEOUT)
-		timeout = IWL_DEF_WD_TIMEOUT;
-
-	hw_params(priv).wd_timeout = timeout;
-	iwl_setup_watchdog(priv);
-	return count;
-}
-
 static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
@@ -2541,7 +2518,6 @@ DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
 DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
-DEBUGFS_WRITE_FILE_OPS(wd_timeout);
 DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
@@ -2608,7 +2584,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(echo_test, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(log_event, dir_debug, S_IWUSR | S_IRUSR);
 
-- 
1.7.0.4

