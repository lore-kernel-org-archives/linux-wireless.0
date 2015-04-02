Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbbDBGlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:52 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/31] iwlwifi: mvm: use debugfs_create_bool() for enable_scan_iteration_notif
Date: Thu,  2 Apr 2015 09:41:01 +0300
Message-Id: <1427956879-11725-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090420_354377_AE61096B)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There is no need to implement the enable_scan_iteration_notif handling
explicitly and there's no reason not to export the current value.  So
use debugfs_create_bool() instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 28 +++++-----------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h     |  2 +-
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 8c52298..01b97a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1473,26 +1473,6 @@ out:
 	return count;
 }
 
-static ssize_t iwl_dbgfs_enable_scan_iteration_notif_write(struct iwl_mvm *mvm,
-							   char *buf,
-							   size_t count,
-							   loff_t *ppos)
-{
-	int val;
-
-	mutex_lock(&mvm->mutex);
-
-	if (kstrtoint(buf, 10, &val)) {
-		mutex_unlock(&mvm->mutex);
-		return -EINVAL;
-	}
-
-	mvm->scan_iter_notif_enabled = val;
-	mutex_unlock(&mvm->mutex);
-
-	return count;
-}
-
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(prph_reg, 64);
 
 /* Device wide debugfs entries */
@@ -1515,7 +1495,6 @@ MVM_DEBUGFS_READ_WRITE_FILE_OPS(scan_ant_rxchain, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(d0i3_refs, 8);
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(fw_dbg_conf, 8);
 MVM_DEBUGFS_WRITE_FILE_OPS(fw_dbg_collect, 8);
-MVM_DEBUGFS_WRITE_FILE_OPS(enable_scan_iteration_notif, 8);
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 MVM_DEBUGFS_READ_WRITE_FILE_OPS(bcast_filters, 256);
@@ -1559,8 +1538,11 @@ int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir)
 	MVM_DEBUGFS_ADD_FILE(d0i3_refs, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_conf, mvm->debugfs_dir, S_IRUSR | S_IWUSR);
 	MVM_DEBUGFS_ADD_FILE(fw_dbg_collect, mvm->debugfs_dir, S_IWUSR);
-	MVM_DEBUGFS_ADD_FILE(enable_scan_iteration_notif, mvm->debugfs_dir,
-			     S_IWUSR);
+	if (!debugfs_create_bool("enable_scan_iteration_notif",
+				 S_IRUSR | S_IWUSR,
+				 mvm->debugfs_dir,
+				 &mvm->scan_iter_notif_enabled))
+		goto err;
 
 #ifdef CONFIG_IWLWIFI_BCAST_FILTERING
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BCAST_FILTERING) {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 02c02e2..91c74d4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -688,7 +688,7 @@ struct iwl_mvm {
 	bool disable_power_off;
 	bool disable_power_off_d3;
 
-	bool scan_iter_notif_enabled;
+	u32 scan_iter_notif_enabled; /* must be u32 for debugfs_create_bool */
 
 	struct debugfs_blob_wrapper nvm_hw_blob;
 	struct debugfs_blob_wrapper nvm_sw_blob;
-- 
1.9.1

