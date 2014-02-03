Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f180.google.com ([209.85.215.180]:61198 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaBCU73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:29 -0500
Received: by mail-ea0-f180.google.com with SMTP id o10so3927561eaj.25
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/62] iwlwifi: mvm: add D0i3 ref/unref when ap, ibss or p2p_cli vifs are running
Date: Mon,  3 Feb 2014 22:57:49 +0200
Message-Id: <1391461088-8082-43-git-send-email-egrumbach@gmail.com> (sfid-20140203_220006_895953_29889D61)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

We don't want to go into D0i3, when P2P_CLI, AP (including
GO) or IBSS interfaces are running, so take appropriate
references.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |    9 +++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |    2 ++
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 64d9efd..827510e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1202,6 +1202,8 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 
 			iwl_mvm_sf_update(mvm, vif, false);
 			iwl_mvm_power_vif_assoc(mvm, vif);
+			if (vif->p2p)
+				iwl_mvm_ref(mvm, IWL_MVM_REF_P2P_CLIENT);
 		} else if (mvmvif->ap_sta_id != IWL_MVM_STATION_COUNT) {
 			/*
 			 * If update fails - SF might be running in associated
@@ -1219,6 +1221,9 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			ret = iwl_mvm_update_quotas(mvm, NULL);
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
+
+			if (vif->p2p)
+				iwl_mvm_unref(mvm, IWL_MVM_REF_P2P_CLIENT);
 		}
 
 		iwl_mvm_recalc_multicast(mvm);
@@ -1327,6 +1332,8 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->p2p && mvm->p2p_device_vif)
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif);
 
+	iwl_mvm_ref(mvm, IWL_MVM_REF_AP_IBSS);
+
 	iwl_mvm_bt_coex_vif_change(mvm);
 
 	mutex_unlock(&mvm->mutex);
@@ -1360,6 +1367,8 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 
 	iwl_mvm_bt_coex_vif_change(mvm);
 
+	iwl_mvm_unref(mvm, IWL_MVM_REF_AP_IBSS);
+
 	/* Need to update the P2P Device MAC (only GO, IBSS is single vif) */
 	if (vif->p2p && mvm->p2p_device_vif)
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 19a90d1..fe3896c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -243,6 +243,8 @@ enum iwl_mvm_ref_type {
 	IWL_MVM_REF_UCODE_DOWN,
 	IWL_MVM_REF_SCAN,
 	IWL_MVM_REF_ROC,
+	IWL_MVM_REF_P2P_CLIENT,
+	IWL_MVM_REF_AP_IBSS,
 
 	IWL_MVM_REF_COUNT,
 };
-- 
1.7.9.5

