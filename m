Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23965 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbaL3OTh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/33] iwlwifi: mvm: clear tt values when entering CT-kill
Date: Tue, 30 Dec 2014 16:18:44 +0200
Message-Id: <1419949148-24046-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151940_154497_F892B3B1)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Clear the thermal throttling values when entering CT-kill, since
everything will be reinitialized anyway when we exit CT-kill.

Additionally, clear the dynamic_smps value in the initialization
funciton, for consistency.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/tt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 2b1e61f..ba615ad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -69,6 +69,7 @@
 
 static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 {
+	struct iwl_mvm_tt_mgmt *tt = &mvm->thermal_throttle;
 	u32 duration = mvm->thermal_throttle.params->ct_kill_duration;
 
 	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
@@ -77,12 +78,15 @@ static void iwl_mvm_enter_ctkill(struct iwl_mvm *mvm)
 	IWL_ERR(mvm, "Enter CT Kill\n");
 	iwl_mvm_set_hw_ctkill_state(mvm, true);
 
+	tt->throttle = false;
+	tt->dynamic_smps = false;
+
 	/* Don't schedule an exit work if we're in test mode, since
 	 * the temperature will not change unless we manually set it
 	 * again (or disable testing).
 	 */
 	if (!mvm->temperature_test)
-		schedule_delayed_work(&mvm->thermal_throttle.ct_kill_exit,
+		schedule_delayed_work(&tt->ct_kill_exit,
 				      round_jiffies_relative(duration * HZ));
 }
 
@@ -452,6 +456,7 @@ void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff)
 		tt->params = &iwl7000_tt_params;
 
 	tt->throttle = false;
+	tt->dynamic_smps = false;
 	tt->min_backoff = min_backoff;
 	INIT_DELAYED_WORK(&tt->ct_kill_exit, check_exit_ctkill);
 }
-- 
1.9.1

