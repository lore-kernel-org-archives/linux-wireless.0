Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54411 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258AbaCROqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Mar 2014 10:46:39 -0400
Received: by mail-ee0-f54.google.com with SMTP id d49so5467870eek.13
        for <linux-wireless@vger.kernel.org>; Tue, 18 Mar 2014 07:46:38 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/35] iwlwifi: mvm: remove using max_duration in firmware API
Date: Tue, 18 Mar 2014 16:45:33 +0200
Message-Id: <1395153939-23897-29-git-send-email-egrumbach@gmail.com> (sfid-20140318_154710_905060_CB303348)
In-Reply-To: <53285AF8.7050305@gmail.com>
References: <53285AF8.7050305@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware decided to not implement this API in this way,
so for now remove setting the field completely. This will
allow the firmware to change how to use this field later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |  2 --
 drivers/net/wireless/iwlwifi/mvm/quota.c     | 22 +---------------------
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 921b177..5168569 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -79,8 +79,6 @@
 #define IWL_MVM_PS_SNOOZE_WINDOW		50
 #define IWL_MVM_WOWLAN_PS_SNOOZE_WINDOW		25
 #define IWL_MVM_LOWLAT_QUOTA_MIN_PERCENT	64
-#define IWL_MVM_LOWLAT_SINGLE_BINDING_MAXDUR	24 /* TU */
-#define IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR	24 /* TU */
 #define IWL_MVM_BT_COEX_SYNC2SCO		1
 #define IWL_MVM_BT_COEX_CORUNNING		1
 #define IWL_MVM_BT_COEX_MPLUT			1
diff --git a/drivers/net/wireless/iwlwifi/mvm/quota.c b/drivers/net/wireless/iwlwifi/mvm/quota.c
index 06d8429..7ec62ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/quota.c
+++ b/drivers/net/wireless/iwlwifi/mvm/quota.c
@@ -180,7 +180,6 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		.colors = { -1, -1, -1, -1 },
 		.new_vif = newvif,
 	};
-	u32 ll_max_duration;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -199,21 +198,6 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 		iwl_mvm_quota_iterator(&data, newvif->addr, newvif);
 	}
 
-	switch (data.n_low_latency_bindings) {
-	case 0: /* no low latency - use default */
-		ll_max_duration = 0;
-		break;
-	case 1: /* SingleBindingLowLatencyMode */
-		ll_max_duration = IWL_MVM_LOWLAT_SINGLE_BINDING_MAXDUR;
-		break;
-	case 2: /* DualBindingLowLatencyMode */
-		ll_max_duration = IWL_MVM_LOWLAT_DUAL_BINDING_MAXDUR;
-		break;
-	default: /* MultiBindingLowLatencyMode */
-		ll_max_duration = 0;
-		break;
-	}
-
 	/*
 	 * The FW's scheduling session consists of
 	 * IWL_MVM_MAX_QUOTA fragments. Divide these fragments
@@ -287,11 +271,7 @@ int iwl_mvm_update_quotas(struct iwl_mvm *mvm, struct ieee80211_vif *newvif)
 			  "Binding=%d, quota=%u > max=%u\n",
 			  idx, le32_to_cpu(cmd.quotas[idx].quota), QUOTA_100);
 
-		if (data.n_interfaces[i] && !data.low_latency[i])
-			cmd.quotas[idx].max_duration =
-				cpu_to_le32(ll_max_duration);
-		else
-			cmd.quotas[idx].max_duration = cpu_to_le32(0);
+		cmd.quotas[idx].max_duration = cpu_to_le32(0);
 
 		idx++;
 	}
-- 
1.8.3.2

