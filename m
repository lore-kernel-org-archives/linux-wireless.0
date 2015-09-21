Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45725 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756079AbbIUU7L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Gregory Greenman <gregory.greenman@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:45 +0300
Message-Id: <1442869141-31637-5-git-send-email-luca@coelho.fi> (sfid-20150921_231005_845955_B2E53FE1)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 05/21] iwlwifi: mvm: don't ask for beacons when AP vif and no assoc sta
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

When in AP mode, we need beacons from other APs for HT protection.
However, when there's no any associated station we will not do
any Tx and thus don't really need beacons. On the other hand, these
beacons will cause a lot of unnecessary wakeups which increase our
power consumption. Handle this by asking FW to pass beacons only when
there's at least one associated station.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 21 +++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  9 +++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  6 ++++++
 drivers/net/wireless/iwlwifi/mvm/sta.c      |  5 +++++
 4 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 3424315..5af0090 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -33,6 +34,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2015 Intel Deutschland GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1124,10 +1126,11 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 	ctxt_ap->beacon_template = cpu_to_le32(mvmvif->id);
 }
 
-static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
-				   struct ieee80211_vif *vif,
-				   u32 action)
+int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
+			    struct ieee80211_vif *vif,
+			    u32 action)
 {
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mac_ctx_cmd cmd = {};
 
 	WARN_ON(vif->type != NL80211_IFTYPE_AP || vif->p2p);
@@ -1137,10 +1140,16 @@ static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
 
 	/*
 	 * pass probe requests and beacons from other APs (needed
-	 * for ht protection)
+	 * for ht protection); when there're no any associated station
+	 * don't ask FW to pass beacons to prevent unnecessary wake-ups.
 	 */
-	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST |
-					MAC_FILTER_IN_BEACON);
+	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
+	if (mvmvif->ap_assoc_sta_count) {
+		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
+		IWL_DEBUG_HC(mvm, "Asking FW to pass beacons\n");
+	} else {
+		IWL_DEBUG_HC(mvm, "No need to receive beacons\n");
+	}
 
 	/* Fill the data specific for ap mode */
 	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.ap,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index aa8c2b7..f9f88e9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2319,6 +2319,8 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (vif->type == NL80211_IFTYPE_AP)
 		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
 
+	mvmvif->ap_assoc_sta_count = 0;
+
 	/* Add the mac context */
 	ret = iwl_mvm_mac_ctxt_add(mvm, vif);
 	if (ret)
@@ -2613,6 +2615,7 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 				       struct ieee80211_sta *sta)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvm_sta = iwl_mvm_sta_from_mac80211(sta);
 
 	/*
@@ -2627,6 +2630,12 @@ static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 	if (sta == rcu_access_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id]))
 		rcu_assign_pointer(mvm->fw_id_to_mac_id[mvm_sta->sta_id],
 				   ERR_PTR(-ENOENT));
+
+	if (mvm_sta->vif->type == NL80211_IFTYPE_AP) {
+		mvmvif->ap_assoc_sta_count--;
+		iwl_mvm_mac_ctxt_cmd_ap(mvm, vif, FW_CTXT_ACTION_MODIFY);
+	}
+
 	mutex_unlock(&mvm->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 72cd67e..ed9b0cc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -338,6 +338,8 @@ struct iwl_mvm_vif_bf_data {
  * @bssid: BSSID for this (client) interface
  * @associated: indicates that we're currently associated, used only for
  *	managing the firmware state in iwl_mvm_bss_info_changed_station()
+ * @ap_assoc_sta_count: count of stations associated to us - valid only
+ *	if VIF type is AP
  * @uploaded: indicates the MAC context has been added to the device
  * @ap_ibss_active: indicates that AP/IBSS is configured and that the interface
  *	should get quota etc.
@@ -367,6 +369,7 @@ struct iwl_mvm_vif {
 
 	u8 bssid[ETH_ALEN];
 	bool associated;
+	u8 ap_assoc_sta_count;
 
 	bool uploaded;
 	bool ap_ibss_active;
@@ -1131,6 +1134,9 @@ void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *exclude_vif);
+int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
+			    struct ieee80211_vif *vif,
+			    u32 action);
 
 /* Bindings */
 int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index df216cd..fe2f538 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -275,6 +275,11 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	if (sta_id == IWL_MVM_STATION_COUNT)
 		return -ENOSPC;
 
+	if (vif->type == NL80211_IFTYPE_AP) {
+		mvmvif->ap_assoc_sta_count++;
+		iwl_mvm_mac_ctxt_cmd_ap(mvm, vif, FW_CTXT_ACTION_MODIFY);
+	}
+
 	spin_lock_init(&mvm_sta->lock);
 
 	mvm_sta->sta_id = sta_id;
-- 
2.5.1

