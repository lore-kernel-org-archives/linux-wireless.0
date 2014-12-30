Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50567 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaL3OUQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:20:16 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/33] iwlwifi: mvm: clean refs before stop_device()
Date: Tue, 30 Dec 2014 16:18:59 +0200
Message-Id: <1419949148-24046-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_154349_349784_17549B7F)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Some implementations (i.e. mini_rpm) assume the references
are managed only while the device is started.

Move the stale reference cleanup before stopping the
device in order to make them happy.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4db051d..084689b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -903,6 +903,11 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	if (!test_and_clear_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status))
 		iwl_mvm_fw_error_dump(mvm);
 
+	/* cleanup all stale references (scan, roc), but keep the
+	 * ucode_down ref until reconfig is complete
+	 */
+	iwl_mvm_unref_all_except(mvm, IWL_MVM_REF_UCODE_DOWN);
+
 	iwl_trans_stop_device(mvm->trans);
 
 	mvm->scan_status = IWL_MVM_SCAN_NONE;
@@ -932,10 +937,6 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 
 	ieee80211_wake_queues(mvm->hw);
 
-	/* cleanup all stale references (scan, roc), but keep the
-	 * ucode_down ref until reconfig is complete */
-	iwl_mvm_unref_all_except(mvm, IWL_MVM_REF_UCODE_DOWN);
-
 	/* clear any stale d0i3 state */
 	clear_bit(IWL_MVM_STATUS_IN_D0I3, &mvm->status);
 
-- 
1.9.1

