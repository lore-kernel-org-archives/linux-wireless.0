Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcAGMsM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/21] iwlwifi: mvm: fix memory leaks in error paths upon fw error dump
Date: Thu,  7 Jan 2016 14:47:40 +0200
Message-Id: <1452170861-10060-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134817_844304_FC7A6F58)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When iwl_mvm_fw_error_dump fails, it needs to clear the
state in mvm, which includes:
	* clear IWL_MVM_STATUS_DUMPING_FW_LOG
	* set mvm->fw_dump_trig to NULL
	* free the description

While at it, remove a NULL check in
iwl_mvm_free_fw_dump_desc since kfree is NULL safe.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
index b3bc212..0813f81 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c
@@ -270,8 +270,7 @@ static void iwl_mvm_dump_fifos(struct iwl_mvm *mvm,
 
 void iwl_mvm_free_fw_dump_desc(struct iwl_mvm *mvm)
 {
-	if (mvm->fw_dump_desc == &iwl_mvm_dump_desc_assert ||
-	    !mvm->fw_dump_desc)
+	if (mvm->fw_dump_desc == &iwl_mvm_dump_desc_assert)
 		return;
 
 	kfree(mvm->fw_dump_desc);
@@ -441,7 +440,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	/* there's no point in fw dump if the bus is dead */
 	if (test_bit(STATUS_TRANS_DEAD, &mvm->trans->status)) {
 		IWL_ERR(mvm, "Skip fw error dump since bus is dead\n");
-		return;
+		goto out;
 	}
 
 	if (mvm->fw_dump_trig &&
@@ -450,7 +449,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 
 	fw_error_dump = kzalloc(sizeof(*fw_error_dump), GFP_KERNEL);
 	if (!fw_error_dump)
-		return;
+		goto out;
 
 	/* SRAM - include stack CCM if driver knows the values for it */
 	if (!mvm->cfg->dccm_offset || !mvm->cfg->dccm_len) {
@@ -550,8 +549,7 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 	dump_file = vzalloc(file_len);
 	if (!dump_file) {
 		kfree(fw_error_dump);
-		iwl_mvm_free_fw_dump_desc(mvm);
-		return;
+		goto out;
 	}
 
 	fw_error_dump->op_mode_ptr = dump_file;
@@ -590,8 +588,6 @@ void iwl_mvm_fw_error_dump(struct iwl_mvm *mvm)
 		memcpy(dump_trig, &mvm->fw_dump_desc->trig_desc,
 		       sizeof(*dump_trig) + mvm->fw_dump_desc->len);
 
-		/* now we can free this copy */
-		iwl_mvm_free_fw_dump_desc(mvm);
 		dump_data = iwl_fw_error_next_data(dump_data);
 	}
 
@@ -677,6 +673,8 @@ dump_trans_data:
 	dev_coredumpm(mvm->trans->dev, THIS_MODULE, fw_error_dump, 0,
 		      GFP_KERNEL, iwl_mvm_read_coredump, iwl_mvm_free_coredump);
 
+out:
+	iwl_mvm_free_fw_dump_desc(mvm);
 	mvm->fw_dump_trig = NULL;
 	clear_bit(IWL_MVM_STATUS_DUMPING_FW_LOG, &mvm->status);
 }
-- 
2.5.0

