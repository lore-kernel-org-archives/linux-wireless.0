Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:64527 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbDBGlj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:41:39 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/31] iwlwifi: mvm: take IWL_MVM_REF_UCODE_DOWN before restarting hw
Date: Thu,  2 Apr 2015 09:40:56 +0300
Message-Id: <1427956879-11725-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_084142_637899_FE9089E8)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

we unref IWL_MVM_REF_UCODE_DOWN on iwl_mvm_restart_complete().

Usually, the restart is initiated by iwl_mvm_nic_restart(),
which takes the reference before restarting the hw.

However, in D3 flow we might call ieee80211_restart_hw()
directly (in case of suspend error and on d3_test-resume),
which without taking the ref first. fix it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 5f8afa5..e730ea2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1131,6 +1131,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 	iwl_trans_d3_suspend(mvm->trans, test);
  out:
 	if (ret < 0) {
+		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 		ieee80211_restart_hw(mvm->hw);
 		iwl_mvm_free_nd(mvm);
 	}
@@ -2016,6 +2017,7 @@ static int iwl_mvm_d3_test_release(struct inode *inode, struct file *file)
 	__iwl_mvm_resume(mvm, true);
 	rtnl_unlock();
 	iwl_abort_notification_waits(&mvm->notif_wait);
+	iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 	ieee80211_restart_hw(mvm->hw);
 
 	/* wait for restart and disconnect all interfaces */
-- 
1.9.1

