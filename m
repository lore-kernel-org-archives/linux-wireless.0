Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab0CJFWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 00:22:07 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 20/24] iwlwifi: remove duplicate function
Date: Tue,  9 Mar 2010 21:21:48 -0800
Message-Id: <1268198512-6572-21-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
References: <1268198512-6572-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

"internal_scan" debugfs function serves the same propose of mode "0" of
"force_reset" debugfs function. Remove it to avoid duplicate.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index d9255b5..5f58202 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2170,27 +2170,6 @@ static ssize_t iwl_dbgfs_missed_beacon_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_internal_scan_write(struct file *file,
-					 const char __user *user_buf,
-					 size_t count, loff_t *ppos)
-{
-	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int scan;
-
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &scan) != 1)
-		return -EINVAL;
-
-	iwl_internal_short_hw_scan(priv);
-
-	return count;
-}
-
 static ssize_t iwl_dbgfs_plcp_delta_read(struct file *file,
 					char __user *user_buf,
 					size_t count, loff_t *ppos) {
@@ -2304,7 +2283,6 @@ DEBUGFS_WRITE_FILE_OPS(csr);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
-DEBUGFS_WRITE_FILE_OPS(internal_scan);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
 DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
 DEBUGFS_READ_FILE_OPS(rxon_flags);
@@ -2360,7 +2338,6 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(csr, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(internal_scan, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
 	if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) != CSR_HW_REV_TYPE_3945) {
-- 
1.6.3.3

