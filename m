Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1101 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964928AbbBCHOo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 02:14:44 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/19] iwlwifi: mvm: don't reprobe if we fail during reconfig and fw_restart is false
Date: Tue,  3 Feb 2015 09:14:21 +0200
Message-Id: <1422947678-16917-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150203_081448_699517_D388D129)
In-Reply-To: <1422947482.30742.8.camel@egrumbacBox>
References: <1422947482.30742.8.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

If we don't want to restart the firmware, don't reprobe either in case
of a failure during reconfiguration.  This allows us to debug failures
in the reconfig flow as well.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 8bf8c2a..b1dea68 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -870,7 +870,10 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	 * If WoWLAN fw asserted, don't restart either, mac80211
 	 * can't recover this since we're already half suspended.
 	 */
-	if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+	if (!mvm->restart_fw && fw_error) {
+		schedule_work(&mvm->fw_error_dump_wk);
+	} else if (test_and_set_bit(IWL_MVM_STATUS_IN_HW_RESTART,
+				    &mvm->status)) {
 		struct iwl_mvm_reprobe *reprobe;
 
 		IWL_ERR(mvm,
@@ -894,16 +897,13 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 		reprobe->dev = mvm->trans->dev;
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
-	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR &&
-		   (!fw_error || mvm->restart_fw)) {
+	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR) {
 		/* don't let the transport/FW power down */
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
 		if (fw_error && mvm->restart_fw > 0)
 			mvm->restart_fw--;
 		ieee80211_restart_hw(mvm->hw);
-	} else if (fw_error) {
-		schedule_work(&mvm->fw_error_dump_wk);
 	}
 }
 
-- 
1.9.1

