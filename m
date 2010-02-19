Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:49005 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab0BSGDN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 01:03:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/6] iwlwifi: add debugfs to monitor force reset parameters
Date: Thu, 18 Feb 2010 22:03:07 -0800
Message-Id: <1266559387-19637-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
References: <1266559387-19637-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding debugfs file to monitor the counters and other
information related to "force_reset" request.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   34 ++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 7241fda..7bf44f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2221,6 +2221,36 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_force_reset_read(struct file *file,
+					char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	int i, pos = 0;
+	char buf[300];
+	const size_t bufsz = sizeof(buf);
+	struct iwl_force_reset *force_reset;
+
+	for (i = 0; i < IWL_MAX_FORCE_RESET; i++) {
+		force_reset = &priv->force_reset[i];
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"Force reset method %d\n", i);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"\tnumber of reset request: %d\n",
+				force_reset->reset_request_count);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"\tnumber of reset request success: %d\n",
+				force_reset->reset_success_count);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"\tnumber of reset request reject: %d\n",
+				force_reset->reset_reject_count);
+		pos += scnprintf(buf + pos, bufsz - pos,
+				"\treset duration: %lu\n",
+				force_reset->reset_duration);
+	}
+	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
+}
+
 static ssize_t iwl_dbgfs_force_reset_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos) {
@@ -2267,7 +2297,7 @@ DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_WRITE_FILE_OPS(internal_scan);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
-DEBUGFS_WRITE_FILE_OPS(force_reset);
+DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
 
 /*
  * Create the debugfs files and directories
@@ -2321,7 +2351,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(internal_scan, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
-- 
1.6.3.3

