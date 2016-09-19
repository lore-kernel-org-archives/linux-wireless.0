Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55874 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758956AbcISHaq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avrahams Stern <avraham.stern@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:12 +0300
Message-Id: <20160919073028.22065-9-luca@coelho.fi> (sfid-20160919_093100_600681_E0B8CE6F)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 09/25] iwlwifi: mvm: Add support for RRM by scan
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avrahams Stern <avraham.stern@intel.com>

Implement support for RRM by adding an option to configure the scan
dwell time and reporting scan start time and BSS detection time, and
Advertise support for these features.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  5 ++
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   | 20 ++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 10 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  6 +++
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 61 +++++++++++++++++++---
 5 files changed, 88 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 1b1e045..94423f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -256,6 +256,10 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  *	instead of 3.
  * @IWL_UCODE_TLV_API_TX_POWER_CHAIN: TX power API has larger command size
  *	(command version 3) that supports per-chain limits
+ * @IWL_UCODE_TLV_API_SCAN_TSF_REPORT: Scan start time reported in scan
+ *	iteration complete notification, and the timestamp reported for RX
+ *	received during scan, are reported in TSF of the mac specified in the
+ *	scan request.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -267,6 +271,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_NEW_VERSION           = (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
 	IWL_UCODE_TLV_API_TX_POWER_CHAIN	= (__force iwl_ucode_tlv_api_t)27,
+	IWL_UCODE_TLV_API_SCAN_TSF_REPORT	= (__force iwl_ucode_tlv_api_t)28,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index f01dab0..0c294c9f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -603,6 +604,8 @@ struct iwl_scan_req_umac_tail {
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
  * @ooc_priority: out of channel priority - &enum iwl_scan_priority
  * @general_flags: &enum iwl_umac_scan_general_flags
+ * @reserved2: for future use and alignment
+ * @scan_start_mac_id: report the scan start TSF time according to this mac TSF
  * @extended_dwell: dwell time for channels 1, 6 and 11
  * @active_dwell: dwell time for active scan
  * @passive_dwell: dwell time for passive scan
@@ -620,8 +623,10 @@ struct iwl_scan_req_umac {
 	__le32 flags;
 	__le32 uid;
 	__le32 ooc_priority;
-	/* SCAN_GENERAL_PARAMS_API_S_VER_1 */
-	__le32 general_flags;
+	/* SCAN_GENERAL_PARAMS_API_S_VER_4 */
+	__le16 general_flags;
+	u8 reserved2;
+	u8 scan_start_mac_id;
 	u8 extended_dwell;
 	u8 active_dwell;
 	u8 passive_dwell;
@@ -629,7 +634,7 @@ struct iwl_scan_req_umac {
 	__le32 max_out_time;
 	__le32 suspend_time;
 	__le32 scan_priority;
-	/* SCAN_CHANNEL_PARAMS_API_S_VER_1 */
+	/* SCAN_CHANNEL_PARAMS_API_S_VER_4 */
 	u8 channel_flags;
 	u8 n_channels;
 	__le16 reserved;
@@ -718,8 +723,8 @@ struct iwl_scan_offload_profiles_query {
  * @status: one of SCAN_COMP_STATUS_*
  * @bt_status: BT on/off status
  * @last_channel: last channel that was scanned
- * @tsf_low: TSF timer (lower half) in usecs
- * @tsf_high: TSF timer (higher half) in usecs
+ * @start_tsf: TSF timer in usecs of the scan start time for the mac specified
+ *	in &struct iwl_scan_req_umac.
  * @results: array of scan results, only "scanned_channels" of them are valid
  */
 struct iwl_umac_scan_iter_complete_notif {
@@ -728,9 +733,8 @@ struct iwl_umac_scan_iter_complete_notif {
 	u8 status;
 	u8 bt_status;
 	u8 last_channel;
-	__le32 tsf_low;
-	__le32 tsf_high;
+	__le64 start_tsf;
 	struct iwl_scan_results_notif results[];
-} __packed; /* SCAN_ITER_COMPLETE_NTF_UMAC_API_S_VER_1 */
+} __packed; /* SCAN_ITER_COMPLETE_NTF_UMAC_API_S_VER_2 */
 
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b7d80b5..a5ede8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -653,6 +653,16 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 			IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT))
 		hw->wiphy->features |= NL80211_FEATURE_WFA_TPC_IE_IN_PROBES;
 
+	if (fw_has_api(&mvm->fw->ucode_capa,
+		       IWL_UCODE_TLV_API_SCAN_TSF_REPORT)) {
+		wiphy_ext_feature_set(hw->wiphy,
+				      NL80211_EXT_FEATURE_SCAN_START_TIME);
+		wiphy_ext_feature_set(hw->wiphy,
+				      NL80211_EXT_FEATURE_BSS_PARENT_TSF);
+		wiphy_ext_feature_set(hw->wiphy,
+				      NL80211_EXT_FEATURE_SET_SCAN_DWELL);
+	}
+
 	mvm->rts_threshold = IEEE80211_MAX_RTS_THRESHOLD;
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 83f3889..e68a2bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -821,6 +821,12 @@ struct iwl_mvm {
 	/* UMAC scan tracking */
 	u32 scan_uid_status[IWL_MVM_MAX_UMAC_SCANS];
 
+	/* start time of last scan in TSF of the mac that requested the scan */
+	u64 scan_start;
+
+	/* the vif that requested the current scan */
+	struct iwl_mvm_vif *scan_vif;
+
 	/* rx chain antennas set through debugfs for the scan command */
 	u8 scan_rx_ant;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index dac120f..00b03fc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -141,6 +141,7 @@ struct iwl_mvm_scan_params {
 	struct cfg80211_match_set *match_sets;
 	int n_scan_plans;
 	struct cfg80211_sched_scan_plan *scan_plans;
+	u32 measurement_dwell;
 };
 
 static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
@@ -232,6 +233,27 @@ iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm, bool p2p_device)
 	return IWL_SCAN_TYPE_WILD;
 }
 
+static int
+iwl_mvm_get_measurement_dwell(struct iwl_mvm *mvm,
+			      struct cfg80211_scan_request *req,
+			      struct iwl_mvm_scan_params *params)
+{
+	if (!req->duration)
+		return 0;
+
+	if (req->duration_mandatory &&
+	    req->duration > scan_timing[params->type].max_out_time) {
+		IWL_DEBUG_SCAN(mvm,
+			       "Measurement scan - too long dwell %hu (max out time %u)\n",
+			       req->duration,
+			       scan_timing[params->type].max_out_time);
+		return -EOPNOTSUPP;
+	}
+
+	return min_t(u32, (u32)req->duration,
+		     scan_timing[params->type].max_out_time);
+}
+
 static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
 {
 	/* require rrm scan whenever the fw supports it */
@@ -1033,9 +1055,15 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	cmd->extended_dwell = scan_timing[params->type].dwell_extended;
-	cmd->active_dwell = scan_timing[params->type].dwell_active;
-	cmd->passive_dwell = scan_timing[params->type].dwell_passive;
+	if (params->measurement_dwell) {
+		cmd->active_dwell = params->measurement_dwell;
+		cmd->passive_dwell = params->measurement_dwell;
+		cmd->extended_dwell = params->measurement_dwell;
+	} else {
+		cmd->active_dwell = scan_timing[params->type].dwell_active;
+		cmd->passive_dwell = scan_timing[params->type].dwell_passive;
+		cmd->extended_dwell = scan_timing[params->type].dwell_extended;
+	}
 	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
 	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
 	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
@@ -1067,11 +1095,11 @@ iwl_mvm_umac_scan_cfg_channels(struct iwl_mvm *mvm,
 	}
 }
 
-static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
+static u16 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 				   struct iwl_mvm_scan_params *params,
 				   struct ieee80211_vif *vif)
 {
-	int flags = 0;
+	u16 flags = 0;
 
 	if (params->n_ssids == 0)
 		flags = IWL_UMAC_SCAN_GEN_FLAGS_PASSIVE;
@@ -1093,6 +1121,9 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (!iwl_mvm_is_regular_scan(params))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
 
+	if (params->measurement_dwell)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE;
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (mvm->scan_iter_notif_enabled)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE;
@@ -1119,6 +1150,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			mvm->fw->ucode_capa.n_scan_channels;
 	int uid, i;
 	u32 ssid_bitmap = 0;
+	struct iwl_mvm_vif *scan_vif = iwl_mvm_vif_from_mac80211(vif);
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1136,8 +1168,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvm->scan_uid_status[uid] = type;
 
 	cmd->uid = cpu_to_le32(uid);
-	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params,
+	cmd->general_flags = cpu_to_le16(iwl_mvm_scan_umac_flags(mvm, params,
 								 vif));
+	cmd->scan_start_mac_id = scan_vif->id;
 
 	if (type == IWL_MVM_SCAN_SCHED || type == IWL_MVM_SCAN_NETDETECT)
 		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
@@ -1289,6 +1322,12 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		iwl_mvm_get_scan_type(mvm,
 				      vif->type == NL80211_IFTYPE_P2P_DEVICE);
 
+	ret = iwl_mvm_get_measurement_dwell(mvm, req, &params);
+	if (ret < 0)
+		return ret;
+
+	params.measurement_dwell = ret;
+
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
@@ -1315,6 +1354,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	IWL_DEBUG_SCAN(mvm, "Scan request was sent successfully\n");
 	mvm->scan_status |= IWL_MVM_SCAN_REGULAR;
+	mvm->scan_vif = iwl_mvm_vif_from_mac80211(vif);
 	iwl_mvm_ref(mvm, IWL_MVM_REF_SCAN);
 
 	queue_delayed_work(system_wq, &mvm->scan_timeout_dwork,
@@ -1437,9 +1477,12 @@ void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
 		struct cfg80211_scan_info info = {
 			.aborted = aborted,
+			.scan_start_tsf = mvm->scan_start,
 		};
 
+		memcpy(info.tsf_bssid, mvm->scan_vif->bssid, ETH_ALEN);
 		ieee80211_scan_completed(mvm->hw, &info);
+		mvm->scan_vif = NULL;
 		iwl_mvm_unref(mvm, IWL_MVM_REF_SCAN);
 		cancel_delayed_work(&mvm->scan_timeout_dwork);
 	} else if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_SCHED) {
@@ -1473,6 +1516,8 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 	struct iwl_umac_scan_iter_complete_notif *notif = (void *)pkt->data;
 	u8 buf[256];
 
+	mvm->scan_start = le64_to_cpu(notif->start_tsf);
+
 	IWL_DEBUG_SCAN(mvm,
 		       "UMAC Scan iteration complete: status=0x%x scanned_channels=%d channels list: %s\n",
 		       notif->status, notif->scanned_channels,
@@ -1485,6 +1530,10 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 		ieee80211_sched_scan_results(mvm->hw);
 		mvm->sched_scan_pass_all = SCHED_SCAN_PASS_ALL_ENABLED;
 	}
+
+	IWL_DEBUG_SCAN(mvm,
+		       "UMAC Scan iteration complete: scan started at %llu (TSF)\n",
+		       mvm->scan_start);
 }
 
 static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
-- 
2.9.3
