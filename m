Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:53306 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965660AbbD1Mnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 08:43:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 8/8] iwlwifi: mvm: force quota update update after FW restart
Date: Tue, 28 Apr 2015 15:43:12 +0300
Message-Id: <1430224992-20327-8-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150428_144336_906375_650DDF17)
In-Reply-To: <1430224907.4748.3.camel@intel.com>
References: <1430224907.4748.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

During firmware restart, the quota command isn't calculated multiple
times, but after the firmware restart it has to be sent, so force it.
Otherwise the firmware crashes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 7c2d5ac..40265b9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1322,7 +1322,7 @@ static void iwl_mvm_restart_complete(struct iwl_mvm *mvm)
 
 	clear_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status);
 	iwl_mvm_d0i3_enable_tx(mvm, NULL);
-	ret = iwl_mvm_update_quotas(mvm, false, NULL);
+	ret = iwl_mvm_update_quotas(mvm, true, NULL);
 	if (ret)
 		IWL_ERR(mvm, "Failed to update quotas after restart (%d)\n",
 			ret);
-- 
2.1.0

