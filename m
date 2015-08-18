Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/26] iwlwifi: mvm: simplify calculating scan dwells and other timing values
Date: Tue, 18 Aug 2015 10:57:24 +0300
Message-Id: <1439884656-18146-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_095819_554204_2F7D6EFF)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Remove timing values from iwl_mvm_scan_params and use defines and
arrays of values instead.

While at that fix few values and corner cases and align all OSs
to ChromeOS values.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 169 +++++++++++++++++---------------
 1 file changed, 88 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index e0c0dd7..308a60e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -72,10 +72,60 @@
 #define IWL_DENSE_EBS_SCAN_RATIO 5
 #define IWL_SPARSE_EBS_SCAN_RATIO 1
 
-struct iwl_mvm_scan_params {
-	u32 max_out_time;
+enum iwl_mvm_scan_type {
+	IWL_SCAN_TYPE_UNASSOC,
+	IWL_SCAN_TYPE_WILD,
+	IWL_SCAN_TYPE_MILD,
+	IWL_SCAN_TYPE_FRAGMENTED,
+};
+
+enum iwl_mvm_traffic_load {
+	IWL_MVM_TRAFFIC_LOW,
+	IWL_MVM_TRAFFIC_MEDIUM,
+	IWL_MVM_TRAFFIC_HIGH,
+};
+
+struct iwl_mvm_scan_timing_params {
+	u32 dwell_active;
+	u32 dwell_passive;
+	u32 dwell_fragmented;
 	u32 suspend_time;
-	bool passive_fragmented;
+	u32 max_out_time;
+};
+
+static struct iwl_mvm_scan_timing_params scan_timing[] = {
+	[IWL_SCAN_TYPE_UNASSOC] = {
+		.dwell_active = 10,
+		.dwell_passive = 110,
+		.dwell_fragmented = 44,
+		.suspend_time = 0,
+		.max_out_time = 0,
+	},
+	[IWL_SCAN_TYPE_WILD] = {
+		.dwell_active = 10,
+		.dwell_passive = 110,
+		.dwell_fragmented = 44,
+		.suspend_time = 30,
+		.max_out_time = 120,
+	},
+	[IWL_SCAN_TYPE_MILD] = {
+		.dwell_active = 10,
+		.dwell_passive = 110,
+		.dwell_fragmented = 44,
+		.suspend_time = 120,
+		.max_out_time = 120,
+	},
+	[IWL_SCAN_TYPE_FRAGMENTED] = {
+		.dwell_active = 10,
+		.dwell_passive = 110,
+		.dwell_fragmented = 44,
+		.suspend_time = 95,
+		.max_out_time = 44,
+	},
+};
+
+struct iwl_mvm_scan_params {
+	enum iwl_mvm_scan_type type;
 	u32 n_channels;
 	u16 delay;
 	int n_ssids;
@@ -90,9 +140,6 @@ struct iwl_mvm_scan_params {
 	int n_match_sets;
 	struct iwl_scan_probe_req preq;
 	struct cfg80211_match_set *match_sets;
-	u16 passive_dwell;
-	u16 active_dwell;
-	u16 fragmented_dwell;
 	struct {
 		u8 iterations;
 		u8 full_scan_mul; /* not used for UMAC */
@@ -156,76 +203,39 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 		*global_cnt += 1;
 }
 
-static void iwl_mvm_scan_calc_dwell(struct iwl_mvm *mvm,
-				    struct ieee80211_vif *vif,
-				    struct iwl_mvm_scan_params *params)
+static enum iwl_mvm_traffic_load iwl_mvm_get_traffic_load(struct iwl_mvm *mvm)
+{
+	return IWL_MVM_TRAFFIC_LOW;
+}
+
+static enum
+iwl_mvm_scan_type iwl_mvm_get_scan_type(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif,
+					struct iwl_mvm_scan_params *params)
 {
 	int global_cnt = 0;
-	u8 frag_passive_dwell = 0;
+	enum iwl_mvm_traffic_load load;
+	bool low_latency;
 
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_scan_condition_iterator,
 					    &global_cnt);
 	if (!global_cnt)
-		goto not_bound;
-
-	params->suspend_time = 30;
-	params->max_out_time = 120;
-
-	if (iwl_mvm_low_latency(mvm)) {
-		if (fw_has_api(&mvm->fw->ucode_capa,
-			       IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
-
-			params->suspend_time = 105;
-			/*
-			 * If there is more than one active interface make
-			 * passive scan more fragmented.
-			 */
-			frag_passive_dwell = 40;
-			params->max_out_time = frag_passive_dwell;
-		} else {
-			params->suspend_time = 120;
-			params->max_out_time = 120;
-		}
-	}
-
-	if (frag_passive_dwell &&
-	    fw_has_api(&mvm->fw->ucode_capa,
-		       IWL_UCODE_TLV_API_FRAGMENTED_SCAN)) {
-		/*
-		 * P2P device scan should not be fragmented to avoid negative
-		 * impact on P2P device discovery. Configure max_out_time to be
-		 * equal to dwell time on passive channel.
-		 */
-		if (vif->type == NL80211_IFTYPE_P2P_DEVICE) {
-			params->max_out_time = 120;
-		} else {
-			params->passive_fragmented = true;
-		}
-	}
-
-	if ((params->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
-	    (params->max_out_time > 200))
-		params->max_out_time = 200;
-
-not_bound:
+		return IWL_SCAN_TYPE_UNASSOC;
 
-	if (params->passive_fragmented)
-		params->fragmented_dwell = frag_passive_dwell;
+	load = iwl_mvm_get_traffic_load(mvm);
+	low_latency = iwl_mvm_low_latency(mvm);
 
-	/*
-	 * use only basic dwell time in scan command, regardless of the band or
-	 * the number of the probes. FW will calculate the actual dwell time.
-	 */
-	params->passive_dwell = 110;
-	params->active_dwell = 10;
+	if ((load == IWL_MVM_TRAFFIC_HIGH || low_latency) &&
+	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
+	    fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_FRAGMENTED_SCAN))
+		return IWL_SCAN_TYPE_FRAGMENTED;
 
+	if (load >= IWL_MVM_TRAFFIC_MEDIUM || low_latency)
+		return IWL_SCAN_TYPE_MILD;
 
-	IWL_DEBUG_SCAN(mvm,
-		       "scan parameters: max_out_time %d, suspend_time %d, passive_fragmented %d\n",
-		       params->max_out_time, params->suspend_time,
-		       params->passive_fragmented);
+	return IWL_SCAN_TYPE_WILD;
 }
 
 static inline bool iwl_mvm_rrm_scan_needed(struct iwl_mvm *mvm)
@@ -699,12 +709,11 @@ static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_lmac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	cmd->active_dwell = params->active_dwell;
-	cmd->passive_dwell = params->passive_dwell;
-	if (params->passive_fragmented)
-		cmd->fragmented_dwell = params->fragmented_dwell;
-	cmd->max_out_time = cpu_to_le32(params->max_out_time);
-	cmd->suspend_time = cpu_to_le32(params->suspend_time);
+	cmd->active_dwell = scan_timing[params->type].dwell_active;
+	cmd->passive_dwell = scan_timing[params->type].dwell_passive;
+	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
+	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
+	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
 	cmd->scan_prio = iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 }
 
@@ -755,7 +764,7 @@ static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
-	if (params->passive_fragmented)
+	if (params->type == IWL_SCAN_TYPE_FRAGMENTED)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
 	if (iwl_mvm_rrm_scan_needed(mvm))
@@ -958,12 +967,11 @@ static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
-	cmd->active_dwell = params->active_dwell;
-	cmd->passive_dwell = params->passive_dwell;
-	if (params->passive_fragmented)
-		cmd->fragmented_dwell = params->fragmented_dwell;
-	cmd->max_out_time = cpu_to_le32(params->max_out_time);
-	cmd->suspend_time = cpu_to_le32(params->suspend_time);
+	cmd->active_dwell = scan_timing[params->type].dwell_active;
+	cmd->passive_dwell = scan_timing[params->type].dwell_passive;
+	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
+	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
+	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
 	cmd->scan_priority =
 		iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
 
@@ -1003,7 +1011,7 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT;
 
-	if (params->passive_fragmented)
+	if (params->type == IWL_SCAN_TYPE_FRAGMENTED)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED;
 
 	if (iwl_mvm_rrm_scan_needed(mvm))
@@ -1177,7 +1185,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.schedule[1].iterations = 0;
 	params.schedule[1].full_scan_mul = 0;
 
-	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
+	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
@@ -1259,6 +1267,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.schedule[0].full_scan_mul = 1;
 	params.schedule[1].iterations = 0xff;
 	params.schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
+	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
 
 	if (req->interval > U16_MAX) {
 		IWL_DEBUG_SCAN(mvm,
@@ -1281,8 +1290,6 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		params.delay = req->delay;
 	}
 
-	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
-
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 	if (ret)
 		return ret;
-- 
2.1.4

