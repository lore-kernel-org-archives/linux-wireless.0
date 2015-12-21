Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbLUUu7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:50:59 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/45] iwlwifi: mvm: configure scheduled scan according to traffic conditions
Date: Mon, 21 Dec 2015 22:50:05 +0200
Message-Id: <1450731046-2796-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215105_219332_FAA259AA)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Change scan configuration (dwell time, suspend time etc.) according
to traffic conditions. This is useful for scans that are managed by
the FW (e.g. scheduled scan).

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 +++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 10 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 43 +++++++++++------------
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 518a1d5..fc13ad9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -993,6 +993,7 @@ static void iwl_mvm_restart_cleanup(struct iwl_mvm *mvm)
 	mvm->vif_count = 0;
 	mvm->rx_ba_sessions = 0;
 	mvm->fw_dbg_conf = FW_DBG_INVALID;
+	mvm->scan_type = IWL_SCAN_TYPE_NOT_SET;
 
 	/* keep statistics ticking */
 	iwl_mvm_accu_radio_stats(mvm);
@@ -1868,6 +1869,9 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		iwl_mvm_bt_coex_vif_change(mvm);
 		iwl_mvm_update_smps(mvm, vif, IWL_MVM_SMPS_REQ_TT,
 				    IEEE80211_SMPS_AUTOMATIC);
+		if (fw_has_capa(&mvm->fw->ucode_capa,
+				IWL_UCODE_TLV_CAPA_UMAC_SCAN))
+			iwl_mvm_config_scan(mvm);
 	} else if (changes & BSS_CHANGED_BEACON_INFO) {
 		/*
 		 * We received a beacon _after_ association so
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 7dc3af6..612799a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -475,6 +475,14 @@ enum iwl_scan_status {
 	IWL_MVM_SCAN_MASK		= 0xff,
 };
 
+enum iwl_mvm_scan_type {
+	IWL_SCAN_TYPE_NOT_SET,
+	IWL_SCAN_TYPE_UNASSOC,
+	IWL_SCAN_TYPE_WILD,
+	IWL_SCAN_TYPE_MILD,
+	IWL_SCAN_TYPE_FRAGMENTED,
+};
+
 /**
  * struct iwl_nvm_section - describes an NVM section in memory.
  *
@@ -643,7 +651,7 @@ struct iwl_mvm {
 	unsigned int scan_status;
 	void *scan_cmd;
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
-	bool scan_fragmented;
+	enum iwl_mvm_scan_type scan_type;
 
 	/* max number of simultaneous scans the FW supports */
 	unsigned int max_scans;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 7cbfb08..4887418 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -72,13 +72,6 @@
 #define IWL_DENSE_EBS_SCAN_RATIO 5
 #define IWL_SPARSE_EBS_SCAN_RATIO 1
 
-enum iwl_mvm_scan_type {
-	IWL_SCAN_TYPE_UNASSOC,
-	IWL_SCAN_TYPE_WILD,
-	IWL_SCAN_TYPE_MILD,
-	IWL_SCAN_TYPE_FRAGMENTED,
-};
-
 enum iwl_mvm_traffic_load {
 	IWL_MVM_TRAFFIC_LOW,
 	IWL_MVM_TRAFFIC_MEDIUM,
@@ -206,9 +199,7 @@ static enum iwl_mvm_traffic_load iwl_mvm_get_traffic_load(struct iwl_mvm *mvm)
 }
 
 static enum
-iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm,
-					struct ieee80211_vif *vif,
-					struct iwl_mvm_scan_params *params)
+iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device)
 {
 	int global_cnt = 0;
 	enum iwl_mvm_traffic_load load;
@@ -224,8 +215,7 @@ iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm,
 	load = iwl_mvm_get_traffic_load(mvm);
 	low_latency = iwl_mvm_low_latency(mvm);
 
-	if ((load == IWL_MVM_TRAFFIC_HIGH || low_latency) &&
-	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
+	if ((load == IWL_MVM_TRAFFIC_HIGH || low_latency) && !p2p_device &&
 	    fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_FRAGMENTED_SCAN))
 		return IWL_SCAN_TYPE_FRAGMENTED;
 
@@ -917,18 +907,20 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	struct iwl_host_cmd cmd = {
 		.id = iwl_cmd_id(SCAN_CFG_CMD, IWL_ALWAYS_LONG_GROUP, 0),
 	};
+	enum iwl_mvm_scan_type type = iwl_mvm_get_scan_type(mvm, false);
 
 	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
 		return -ENOBUFS;
 
+	if (type == mvm->scan_type)
+		return 0;
+
 	cmd_size = sizeof(*scan_config) + mvm->fw->ucode_capa.n_scan_channels;
 
 	scan_config = kzalloc(cmd_size, GFP_KERNEL);
 	if (!scan_config)
 		return -ENOMEM;
 
-	mvm->scan_fragmented = iwl_mvm_low_latency(mvm);
-
 	scan_config->flags = cpu_to_le32(SCAN_CONFIG_FLAG_ACTIVATE |
 					 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
 					 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
@@ -938,17 +930,18 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 					 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
 					 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS|
 					 SCAN_CONFIG_N_CHANNELS(num_channels) |
-					 (mvm->scan_fragmented ?
+					 (type == IWL_SCAN_TYPE_FRAGMENTED ?
 					  SCAN_CONFIG_FLAG_SET_FRAGMENTED :
 					  SCAN_CONFIG_FLAG_CLEAR_FRAGMENTED));
 	scan_config->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 	scan_config->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
 	scan_config->legacy_rates = iwl_mvm_scan_config_rates(mvm);
-	scan_config->out_of_channel_time = cpu_to_le32(170);
-	scan_config->suspend_time = cpu_to_le32(30);
-	scan_config->dwell_active = 20;
-	scan_config->dwell_passive = 110;
-	scan_config->dwell_fragmented = 20;
+	scan_config->out_of_channel_time =
+		cpu_to_le32(scan_timing[type].max_out_time);
+	scan_config->suspend_time = cpu_to_le32(scan_timing[type].suspend_time);
+	scan_config->dwell_active = scan_timing[type].dwell_active;
+	scan_config->dwell_passive = scan_timing[type].dwell_passive;
+	scan_config->dwell_fragmented = scan_timing[type].dwell_fragmented;
 
 	memcpy(&scan_config->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
 
@@ -972,6 +965,8 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	IWL_DEBUG_SCAN(mvm, "Sending UMAC scan config\n");
 
 	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (!ret)
+		mvm->scan_type = type;
 
 	kfree(scan_config);
 	return ret;
@@ -1225,7 +1220,9 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.scan_plans = &scan_plan;
 	params.n_scan_plans = 1;
 
-	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
+	params.type =
+		iwl_mvm_get_scan_type(mvm,
+				      vif->type == NL80211_IFTYPE_P2P_DEVICE);
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
@@ -1307,7 +1304,9 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.n_scan_plans = req->n_scan_plans;
 	params.scan_plans = req->scan_plans;
 
-	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
+	params.type =
+		iwl_mvm_get_scan_type(mvm,
+				      vif->type == NL80211_IFTYPE_P2P_DEVICE);
 
 	/* In theory, LMAC scans can handle a 32-bit delay, but since
 	 * waiting for over 18 hours to start the scan is a bit silly
-- 
2.5.0

