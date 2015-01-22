Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbbAVUdr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:47 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/38] iwlwifi: mvm: allow to collect debug data from non-sleepable context
Date: Thu, 22 Jan 2015 22:32:58 +0200
Message-Id: <1421958809-3371-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213402_528931_09F5875E)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwl_mvm_fw_dbg_collect allows to collect debug data from
the firmware. Most of the firmware interaction is done in
non-sleepable context. It makes little sense to force the
caller of iwl_mvm_fw_dbg_collect to sleep.
Defer the actual collection to a worker so that this
function will be able to be called from any context.

Reviewed-by: Eran Harary <eran.harary@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw.c  | 8 +-------
 drivers/net/wireless/iwlwifi/mvm/ops.c | 6 ++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index 534ee31..52338b7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -402,8 +402,6 @@ out:
 
 void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
 {
-	lockdep_assert_held(&mvm->mutex);
-
 	/* stop recording */
 	if (mvm->cfg->device_family == IWL_DEVICE_FAMILY_7000) {
 		iwl_set_bits_prph(mvm->trans, MON_BUFF_SAMPLE_CTL, 0x100);
@@ -412,11 +410,7 @@ void iwl_mvm_fw_dbg_collect(struct iwl_mvm *mvm)
 		iwl_write_prph(mvm->trans, DBGC_OUT_CTRL, 0);
 	}
 
-	iwl_mvm_fw_error_dump(mvm);
-
-	/* start recording again */
-	WARN_ON_ONCE(mvm->fw->dbg_dest_tlv &&
-		     iwl_mvm_start_fw_dbg_conf(mvm, mvm->fw_dbg_conf));
+	schedule_work(&mvm->fw_error_dump_wk);
 }
 
 int iwl_mvm_start_fw_dbg_conf(struct iwl_mvm *mvm, enum iwl_fw_dbg_conf conf_id)
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 12b565a..90143aa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -825,6 +825,12 @@ static void iwl_mvm_fw_error_dump_wk(struct work_struct *work)
 
 	mutex_lock(&mvm->mutex);
 	iwl_mvm_fw_error_dump(mvm);
+
+	/* start recording again if the firmware is not crashed */
+	WARN_ON_ONCE((!test_bit(STATUS_FW_ERROR, &mvm->trans->status)) &&
+		      mvm->fw->dbg_dest_tlv &&
+		      iwl_mvm_start_fw_dbg_conf(mvm, mvm->fw_dbg_conf));
+
 	mutex_unlock(&mvm->mutex);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_FW_DBG_COLLECT);
-- 
1.9.1

