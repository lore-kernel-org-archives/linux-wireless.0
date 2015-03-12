Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19186 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603AbbCLNGd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:06:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 47/49] iwlwifi: mvm: clarify time event end handling
Date: Thu, 12 Mar 2015 15:04:32 +0200
Message-Id: <1426165474-25586-47-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_143418_315169_0DB7C1E1)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code here is a little confusing, the iwl_mvm_te_check_disconnect()
will check that the interface is a station, but going into it after
already having processed the time even end for P2P seems strange at
first look.

Put a switch statement there to distinguish the interface types and
make this more readable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 54fafbf..1dbfcc4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -261,17 +261,23 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			     "TE ended - current time %lu, estimated end %lu\n",
 			     jiffies, te_data->end_jiffies);
 
-		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+		switch (te_data->vif->type) {
+		case NL80211_IFTYPE_P2P_DEVICE:
 			ieee80211_remain_on_channel_expired(mvm->hw);
 			iwl_mvm_roc_finished(mvm);
+			break;
+		case NL80211_IFTYPE_STATION:
+			/*
+			 * By now, we should have finished association
+			 * and know the dtim period.
+			 */
+			iwl_mvm_te_check_disconnect(mvm, te_data->vif,
+				"No association and the time event is over already...");
+			break;
+		default:
+			break;
 		}
 
-		/*
-		 * By now, we should have finished association
-		 * and know the dtim period.
-		 */
-		iwl_mvm_te_check_disconnect(mvm, te_data->vif,
-			"No association and the time event is over already...");
 		iwl_mvm_te_clear_data(mvm, te_data);
 	} else if (le32_to_cpu(notif->action) & TE_V2_NOTIF_HOST_EVENT_START) {
 		te_data->running = true;
-- 
1.9.1

