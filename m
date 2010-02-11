Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50477 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab0BKSmN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2010 13:42:13 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 03/12] iwlwifi: add debug function to reset/reload radio/firmware
Date: Thu, 11 Feb 2010 10:41:56 -0800
Message-Id: <1265913725-4279-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
References: <1265913725-4279-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Adding function to force reset radio or reload firmware from debugfs.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d134301..78298be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2223,6 +2223,32 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 	return count;
 }
 
+static ssize_t iwl_dbgfs_force_reset_write(struct file *file,
+					const char __user *user_buf,
+					size_t count, loff_t *ppos) {
+
+	struct iwl_priv *priv = file->private_data;
+	char buf[8];
+	int buf_size;
+	int reset, ret;
+
+	memset(buf, 0, sizeof(buf));
+	buf_size = min(count, sizeof(buf) -  1);
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	if (sscanf(buf, "%d", &reset) != 1)
+		return -EINVAL;
+	switch (reset) {
+	case IWL_RF_RESET:
+	case IWL_FW_RESET:
+		ret = iwl_force_reset(priv, reset);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return ret ? ret : count;
+}
+
 DEBUGFS_READ_FILE_OPS(rx_statistics);
 DEBUGFS_READ_FILE_OPS(tx_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(traffic_log);
@@ -2243,6 +2269,7 @@ DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_WRITE_FILE_OPS(internal_scan);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
+DEBUGFS_WRITE_FILE_OPS(force_reset);
 
 /*
  * Create the debugfs files and directories
@@ -2296,6 +2323,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(internal_scan, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
 		DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
 		DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
-- 
1.6.3.3

