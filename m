Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbbEZTTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:19:16 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 39/39] iwlwifi: mvm: clean interfaces on drv_stop
Date: Tue, 26 May 2015 22:17:52 +0300
Message-Id: <1432667872-18092-39-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_211924_561346_B0A2A167)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

If a HW recovery was started but not completed since all interfaces went
down, make sure to cleanup all interfaces before clearing the HW_RESTART
flag.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 71b66cb..9e517e2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1489,8 +1489,12 @@ void __iwl_mvm_mac_stop(struct iwl_mvm *mvm)
 	/*
 	 * Clear IN_HW_RESTART flag when stopping the hw (as restart_complete()
 	 * won't be called in this case).
+	 * But make sure to cleanup interfaces that have gone down before/during
+	 * HW restart was requested.
 	 */
-	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
+	if (test_and_clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		ieee80211_iterate_interfaces(mvm->hw, 0,
+					     iwl_mvm_cleanup_iterator, mvm);
 
 	/* We shouldn't have any UIDs still set.  Loop over all the UIDs to
 	 * make sure there's nothing left there and warn if any is found.
-- 
2.1.4

