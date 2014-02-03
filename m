Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:33341 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbaBCU6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:44 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so3869034eei.35
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:43 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/62] iwlwifi: mvm: limit non-low-latency binding scheduling duration
Date: Mon,  3 Feb 2014 22:57:25 +0200
Message-Id: <1391461088-8082-19-git-send-email-egrumbach@gmail.com> (sfid-20140203_220011_617818_8E8D1750)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Limit the scheduling duration of bindings without a low-latency
interface in the firmware, this prevents those bindings from
occupying the medium for a period of time longer than what we
want for the other interfaces in low-latency mode.

As older firmware doesn't do anything with the max_duration field
and ignores it completely, there's no need for a firmware flag.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |    2 ++
 drivers/net/wireless/iwlwifi/mvm/quota.c     |   33 ++++++++++++++++++++------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index ffa3346..f3b96e4 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -79,5 +79,7 @@
 #define IWL_MVM_PS_SNOOZE_WINDOW		50
 #define IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW		25
 #define IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT	64
+#define IWL_MVM_LOWLAT_SINGLE_BINDING_MAXDUR	24 /* TU */
+#define IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR	24 /* TU */
 
 #endif /* __MVM_CONSTANTS_H */
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 0d2185b..5691a85 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -180,6 +180,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		.colors = { -1, -1, -1, -1 },
 		.new_vif = newvif,
 	};
+	u32 ll_max_duration;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -198,6 +199,21 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		iwl_mvm_quota_iterator(&data, newvif->addr, newvif);
 	}
 
+	switch (data.n_low_latency_bindings) {
+	case 0: /* no low latency - use default */
+		ll_max_duration = 0;
+		break;
+	case 1: /* SingleBindingLowLatencyMode */
+		ll_max_duration = IWL_MVM_LOWLAT_SINGLE_BINDING_MAXDUR;
+		break;
+	case 2: /* DualBindingLowLatencyMode */
+		ll_max_duration = IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR;
+		break;
+	default: /* MultiBindingLowLatencyMode */
+		ll_max_duration = 0;
+		break;
+	}
+
 	/*
 	 * The FW's scheduling session consists of
 	 * IWL_MVM_MAX_QUOTA fragments. Divide these fragments
@@ -242,18 +258,21 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		cmd.quotas[idx].id_and_color =
 			cpu_to_le32(FW_CMD_ID_AND_COLOR(i, data.colors[i]));
 
-		if (data.n_interfaces[i] <= 0) {
+		if (data.n_interfaces[i] <= 0)
 			cmd.quotas[idx].quota = cpu_to_le32(0);
-			cmd.quotas[idx].max_duration = cpu_to_le32(0);
-		} else if (data.n_low_latency_bindings == 1 && n_non_lowlat &&
-			   data.low_latency[i]) {
+		else if (data.n_low_latency_bindings == 1 && n_non_lowlat &&
+			 data.low_latency[i])
 			cmd.quotas[idx].quota = cpu_to_le32(QUOTA_LOWLAT_MIN);
-			cmd.quotas[idx].max_duration = cpu_to_le32(0);
-		} else {
+		else
 			cmd.quotas[idx].quota =
 				cpu_to_le32(quota * data.n_interfaces[i]);
+
+		if (data.n_interfaces[i] && !data.low_latency[i])
+			cmd.quotas[idx].max_duration =
+				cpu_to_le32(ll_max_duration);
+		else
 			cmd.quotas[idx].max_duration = cpu_to_le32(0);
-		}
+
 		idx++;
 	}
 
-- 
1.7.9.5

