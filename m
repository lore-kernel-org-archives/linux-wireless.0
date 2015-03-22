Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbbCVRVi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 13:21:38 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/6] iwlwifi: mvm: disconnect if CSA time event fails scheduling
Date: Sun, 22 Mar 2015 19:21:28 +0200
Message-Id: <1427044892-13907-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150322_182141_387308_54D9FD37)
In-Reply-To: <1427044767.8611.4.camel@egrumbacBox>
References: <1427044767.8611.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If this situation ever happens, the mac80211 state machine gets
confused because it never clears csa_active. There was a separate
bug that lead to this happening with a working connection, but it
isn't very robust to try to keep the connection up in this case.

When removing the time event the CSA essentially procedure stops,
so the safest thing to do is to disconnect in this case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index f8d6f30..4b81c0b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -197,6 +197,8 @@ iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
 			     struct iwl_time_event_notif *notif)
 {
 	if (!le32_to_cpu(notif->status)) {
+		if (te_data->vif->type == NL80211_IFTYPE_STATION)
+			ieee80211_connection_loss(te_data->vif);
 		IWL_DEBUG_TE(mvm, "CSA time event failed to start\n");
 		iwl_mvm_te_clear_data(mvm, te_data);
 		return;
-- 
1.9.1

