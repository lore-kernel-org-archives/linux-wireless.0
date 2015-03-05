Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:54805 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbbCEMuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:50:07 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 4/7] iwlwifi: mvm: Fix ROC removal
Date: Thu,  5 Mar 2015 14:49:50 +0200
Message-Id: <1425559793-25131-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150305_135025_692625_565B0C84)
In-Reply-To: <1425558068.22928.3.camel@egrumbacBox>
References: <1425558068.22928.3.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

iwl_mvm_stop_roc removes TE only if running flag is set. This is not correct
since this flag is only set when the TE is started.
This resulted in a TE not being removed, when mac80211 believes that there are
no active ROCs.

Fixes: bf5da87f60a9 ("iwlwifi: mvm: add remove flow for AUX ROC time events")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 54fafbf..f8d6f30 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -750,8 +750,7 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 	 * request
 	 */
 	list_for_each_entry(te_data, &mvm->time_event_list, list) {
-		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE &&
-		    te_data->running) {
+		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
 			mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
 			is_p2p = true;
 			goto remove_te;
@@ -766,10 +765,8 @@ void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 	 * request
 	 */
 	list_for_each_entry(te_data, &mvm->aux_roc_te_list, list) {
-		if (te_data->running) {
-			mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
-			goto remove_te;
-		}
+		mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
+		goto remove_te;
 	}
 
 remove_te:
-- 
1.9.1

