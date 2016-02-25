Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14143 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbcBYU5Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 15:57:16 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/2] iwlwifi: mvm: Fix paging memory leak
Date: Thu, 25 Feb 2016 22:57:09 +0200
Message-Id: <1456433829-20285-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160225_215719_453975_792A6314)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

If the opmode is stopped and started again we did not free
the paging buffers. Fix that.
In addition when freeing the firmware's paging download
buffer, set the pointer to NULL.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c  | 4 +++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h | 3 +++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 4ed5180..0ccc697 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -107,7 +107,7 @@ static int iwl_send_tx_ant_cfg(struct iwl_mvm *mvm, u8 valid_tx_ant)
 				    sizeof(tx_ant_cmd), &tx_ant_cmd);
 }
 
-static void iwl_free_fw_paging(struct iwl_mvm *mvm)
+void iwl_free_fw_paging(struct iwl_mvm *mvm)
 {
 	int i;
 
@@ -127,6 +127,8 @@ static void iwl_free_fw_paging(struct iwl_mvm *mvm)
 			     get_order(mvm->fw_paging_db[i].fw_paging_size));
 	}
 	kfree(mvm->trans->paging_download_buf);
+	mvm->trans->paging_download_buf = NULL;
+
 	memset(mvm->fw_paging_db, 0, sizeof(mvm->fw_paging_db));
 }
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 5f3ac8c..ff7c6df 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1225,6 +1225,9 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 					      struct iwl_rx_cmd_buffer *rxb);
 
+/* Paging */
+void iwl_free_fw_paging(struct iwl_mvm *mvm);
+
 /* MVM debugfs */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_mvm_dbgfs_register(struct iwl_mvm *mvm, struct dentry *dbgfs_dir);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 89ea70d..e80be9a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -684,6 +684,8 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 	for (i = 0; i < NVM_MAX_NUM_SECTIONS; i++)
 		kfree(mvm->nvm_sections[i].data);
 
+	iwl_free_fw_paging(mvm);
+
 	iwl_mvm_tof_clean(mvm);
 
 	ieee80211_free_hw(mvm->hw);
-- 
2.5.0

