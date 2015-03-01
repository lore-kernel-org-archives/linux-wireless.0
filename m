Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbCATc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/31] iwlwifi: mvm: don't iterate interfaces to disconnect in net-detect
Date: Sun,  1 Mar 2015 21:31:32 +0200
Message-Id: <1425238304-498-19-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203416_906562_23D42C6D)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We shouldn't call iwl_mvm_d3_disconnect_iter() on the running
interfaces when we are woken up due to net-detect, because it doesn't
make sense.  Additionally, this seems to set the
IEEE80211_SDATA_DISCONNECT_RESUME flag that will cause a disconnection
on the next resume (if a normal WoWLAN is used).

To solve this, skip the iteration loop when net-detect is set.

Reported-by: Samuel Tan <samueltan@chromium.org>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 14e8fd6..9bdfa95 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1876,25 +1876,28 @@ static int __iwl_mvm_resume(struct iwl_mvm *mvm, bool test)
 
 	if (mvm->net_detect) {
 		iwl_mvm_query_netdetect_reasons(mvm, vif);
+		/* has unlocked the mutex, so skip that */
+		goto out;
 	} else {
 		keep = iwl_mvm_query_wakeup_reasons(mvm, vif);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 		if (keep)
 			mvm->keep_vif = vif;
+		/* has unlocked the mutex, so skip that */
+		goto out_iterate;
 #endif
 	}
-	/* has unlocked the mutex, so skip that */
-	goto out;
 
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 
- out:
+out_iterate:
 	if (!test)
 		ieee80211_iterate_active_interfaces_rtnl(mvm->hw,
 			IEEE80211_IFACE_ITER_NORMAL,
 			iwl_mvm_d3_disconnect_iter, keep ? vif : NULL);
 
+out:
 	/* return 1 to reconfigure the device */
 	set_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 	set_bit(IWL_MVM_STATUS_D3_RECONFIG, &mvm->status);
-- 
1.9.1

