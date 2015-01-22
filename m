Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbbAVUdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:38 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/38] iwlwifi: mvm: make sure state isn't in d0i3 when collecting fw dbg
Date: Thu, 22 Jan 2015 22:32:54 +0200
Message-Id: <1421958809-3371-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213341_909095_664D6506)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

This makes sure that we're not trying to read/write any of
the FW debug data collected during d0i3.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Reviewed-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c | 1 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h     | 1 +
 drivers/net/wireless/iwlwifi/mvm/ops.c     | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index a1b276c..f1b3405 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -1390,6 +1390,7 @@ static ssize_t iwl_dbgfs_d0i3_refs_read(struct file *file,
 	PRINT_MVM_REF(IWL_MVM_REF_TM_CMD);
 	PRINT_MVM_REF(IWL_MVM_REF_EXIT_WORK);
 	PRINT_MVM_REF(IWL_MVM_REF_PROTECT_CSA);
+	PRINT_MVM_REF(IWL_MVM_REF_FW_DBG_COLLECT);
 
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b2100b4..c95297e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -276,6 +276,7 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_TM_CMD,
 	IWL_MVM_REF_EXIT_WORK,
 	IWL_MVM_REF_PROTECT_CSA,
+	IWL_MVM_REF_FW_DBG_COLLECT,
 
 	/* update debugfs.c when changing this */
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 239f033..b0583fc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -818,9 +818,14 @@ static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 	struct iwl_mvm *mvm =
 		container_of(work, struct iwl_mvm, fw_error_dump_wk);
 
+	if (iwl_mvm_ref_sync(mvm, IWL_MVM_REF_FW_DBG_COLLECT))
+		return;
+
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_fw_error_dump(mvm);
 	mutex_unlock(&mvm->mutex);
+
+	iwl_mvm_unref(mvm, IWL_MVM_REF_FW_DBG_COLLECT);
 }
 
 void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
-- 
1.9.1

