Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758055Ab3GZI3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 20/30] iwlwifi: mvm: assign quota per virtual interface
Date: Fri, 26 Jul 2013 10:28:37 +0200
Message-Id: <1374827327-3464-21-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103017_928560_727CA20A)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of assigning quota per used binding (channel) assign
the same amount of quota for each virtual interface so that
when there are more than two interfaces using more than one
channel, we'll stay on the channels proportionally to the
number of virtual interfaces using the channels.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/quota.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 29d49cf..1897387 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -132,7 +132,7 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 {
 	struct iwl_time_quota_cmd cmd;
-	int i, idx, ret, num_active_bindings, quota, quota_rem;
+	int i, idx, ret, num_active_macs, quota, quota_rem;
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
@@ -162,18 +162,17 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 	 * IWL_MVM_MAX_QUOTA fragments. Divide these fragments
 	 * equally between all the bindings that require quota
 	 */
-	num_active_bindings = 0;
+	num_active_macs = 0;
 	for (i = 0; i < MAX_BINDINGS; i++) {
 		cmd.quotas[i].id_and_color = cpu_to_le32(FW_CTXT_INVALID);
-		if (data.n_interfaces[i] > 0)
-			num_active_bindings++;
+		num_active_macs += data.n_interfaces[i];
 	}
 
 	quota = 0;
 	quota_rem = 0;
-	if (num_active_bindings) {
-		quota = IWL_MVM_MAX_QUOTA / num_active_bindings;
-		quota_rem = IWL_MVM_MAX_QUOTA % num_active_bindings;
+	if (num_active_macs) {
+		quota = IWL_MVM_MAX_QUOTA / num_active_macs;
+		quota_rem = IWL_MVM_MAX_QUOTA % num_active_macs;
 	}
 
 	for (idx = 0, i = 0; i < MAX_BINDINGS; i++) {
@@ -187,7 +186,8 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 			cmd.quotas[idx].quota = cpu_to_le32(0);
 			cmd.quotas[idx].max_duration = cpu_to_le32(0);
 		} else {
-			cmd.quotas[idx].quota = cpu_to_le32(quota);
+			cmd.quotas[idx].quota =
+				cpu_to_le32(quota * data.n_interfaces[i]);
 			cmd.quotas[idx].max_duration =
 				cpu_to_le32(IWL_MVM_MAX_QUOTA);
 		}
-- 
1.8.0

