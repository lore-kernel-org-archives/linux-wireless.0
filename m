Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:50293 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaBCU6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:43 -0500
Received: by mail-ee0-f47.google.com with SMTP id d49so3859881eek.20
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:42 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/62] iwlwifi: mvm: reserve bandwidth for low-latency interface
Date: Mon,  3 Feb 2014 22:57:24 +0200
Message-Id: <1391461088-8082-18-git-send-email-egrumbach@gmail.com> (sfid-20140203_223006_154887_EAF51624)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there is/are interface(s) in low-latency mode, reserve a
percentage (currently 64%) of the quota for that binding to
improve the quality of service for those interfaces. However,
if there's more than one binding that has low-latency, then
give up and don't reserve, we can't allocate more than 100%.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |    1 +
 drivers/net/wireless/iwlwifi/mvm/quota.c     |   63 ++++++++++++++++++++------
 2 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 0368576..ffa3346 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -78,5 +78,6 @@
 #define IWL_MVM_PS_SNOOZE_INTERVAL		25
 #define IWL_MVM_PS_SNOOZE_WINDOW		50
 #define IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW		25
+#define IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT	64
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index ce5db6c..0d2185b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -65,9 +65,14 @@
 #include "fw-api.h"
 #include "mvm.h"
 
+#define QUOTA_100	IWL_MVM_MAX_QUOTA
+#define QUOTA_LOWLAT_MIN ((QUOTA_100 * IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT) / 100)
+
 struct iwl_mvm_quota_iterator_data {
 	int n_interfaces[MAX_BINDINGS];
 	int colors[MAX_BINDINGS];
+	int low_latency[MAX_BINDINGS];
+	int n_low_latency_bindings;
 	struct ieee80211_vif *new_vif;
 };
 
@@ -107,22 +112,29 @@ static void iwl_mvm_quota_iterator(void *_data, u8 *mac,
 	switch (vif->type) {
 	case NL80211_IFTYPE_STATION:
 		if (vif->bss_conf.assoc)
-			data->n_interfaces[id]++;
-		break;
+			break;
+		return;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
 		if (mvmvif->ap_ibss_active)
-			data->n_interfaces[id]++;
-		break;
+			break;
+		return;
 	case NL80211_IFTYPE_MONITOR:
 		if (mvmvif->monitor_active)
-			data->n_interfaces[id]++;
-		break;
+			break;
+		return;
 	case NL80211_IFTYPE_P2P_DEVICE:
-		break;
+		return;
 	default:
 		WARN_ON_ONCE(1);
-		break;
+		return;
+	}
+
+	data->n_interfaces[id]++;
+
+	if (iwl_mvm_vif_low_latency(mvmvif) && !data->low_latency[id]) {
+		data->n_low_latency_bindings++;
+		data->low_latency[id] = true;
 	}
 }
 
@@ -162,7 +174,7 @@ static void iwl_mvm_adjust_quota_for_noa(struct iwl_mvm *mvm,
 int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 {
 	struct iwl_time_quota_cmd cmd = {};
-	int i, idx, ret, num_active_macs, quota, quota_rem;
+	int i, idx, ret, num_active_macs, quota, quota_rem, n_non_lowlat;
 	struct iwl_mvm_quota_iterator_data data = {
 		.n_interfaces = {},
 		.colors = { -1, -1, -1, -1 },
@@ -197,11 +209,30 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		num_active_macs += data.n_interfaces[i];
 	}
 
-	quota = 0;
-	quota_rem = 0;
-	if (num_active_macs) {
-		quota = IWL_MVM_MAX_QUOTA / num_active_macs;
-		quota_rem = IWL_MVM_MAX_QUOTA % num_active_macs;
+	n_non_lowlat = num_active_macs;
+
+	if (data.n_low_latency_bindings == 1) {
+		for (i = 0; i < MAX_BINDINGS; i++) {
+			if (data.low_latency[i]) {
+				n_non_lowlat -= data.n_interfaces[i];
+				break;
+			}
+		}
+		if (n_non_lowlat) {
+			quota = (QUOTA_100 - QUOTA_LOWLAT_MIN) / n_non_lowlat;
+			quota_rem = QUOTA_100 - n_non_lowlat * quota -
+				    QUOTA_LOWLAT_MIN;
+		} else {
+			quota = QUOTA_100;
+			quota_rem = 0;
+		}
+	} else if (num_active_macs) {
+		quota = QUOTA_100 / num_active_macs;
+		quota_rem = QUOTA_100 % num_active_macs;
+	} else {
+		/* values don't really matter - won't be used */
+		quota = 0;
+		quota_rem = 0;
 	}
 
 	for (idx = 0, i = 0; i < MAX_BINDINGS; i++) {
@@ -214,6 +245,10 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		if (data.n_interfaces[i] <= 0) {
 			cmd.quotas[idx].quota = cpu_to_le32(0);
 			cmd.quotas[idx].max_duration = cpu_to_le32(0);
+		} else if (data.n_low_latency_bindings == 1 && n_non_lowlat &&
+			   data.low_latency[i]) {
+			cmd.quotas[idx].quota = cpu_to_le32(QUOTA_LOWLAT_MIN);
+			cmd.quotas[idx].max_duration = cpu_to_le32(0);
 		} else {
 			cmd.quotas[idx].quota =
 				cpu_to_le32(quota * data.n_interfaces[i]);
-- 
1.7.9.5

