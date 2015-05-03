Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbbECTcs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:32:48 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/42] iwlwifi: mvm: add common scan params to thw iwl_mvm_scan_params struct
Date: Sun,  3 May 2015 22:31:34 +0300
Message-Id: <1430681513-7838-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213305_352988_974412FD)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Many parameters are common for all scans.  Instead of parsing the
cfg80211 scan and sched scan requests differently in each flow, move
the parsing outside of the API/scan-type specific functions.  In this
way, we only need to differentiate between scan types once.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 239 +++++++++++++++++++-------------
 1 file changed, 145 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 7db3bf3..2836792 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -79,6 +79,19 @@ struct iwl_mvm_scan_params {
 	u32 max_out_time;
 	u32 suspend_time;
 	bool passive_fragmented;
+	u32 n_channels;
+	u32 delay;
+	int n_ssids;
+	struct cfg80211_ssid *ssids;
+	struct ieee80211_channel **channels;
+	u16 interval; /* interval between scans (in secs) */
+	u32 flags;
+	u8 *mac_addr;
+	u8 *mac_addr_mask;
+	bool no_cck;
+	bool pass_all;
+	int n_match_sets;
+	struct cfg80211_match_set *match_sets;
 	struct _dwell {
 		u16 passive;
 		u16 active;
@@ -149,18 +162,17 @@ iwl_mvm_scan_rate_n_flags(struct iwl_mvm *mvm, enum ieee80211_band band,
  * request.
  */
 static void iwl_mvm_scan_fill_ssids(struct iwl_ssid_ie *cmd_ssid,
-				    struct cfg80211_ssid *ssids,
-				    int n_ssids, int first)
+				    struct iwl_mvm_scan_params *params)
 {
 	int fw_idx, req_idx;
 
-	for (req_idx = n_ssids - 1, fw_idx = 0; req_idx >= first;
+	for (req_idx = params->n_ssids - 1, fw_idx = 0; req_idx >= 0;
 	     req_idx--, fw_idx++) {
 		cmd_ssid[fw_idx].id = WLAN_EID_SSID;
-		cmd_ssid[fw_idx].len = ssids[req_idx].ssid_len;
+		cmd_ssid[fw_idx].len = params->ssids[req_idx].ssid_len;
 		memcpy(cmd_ssid[fw_idx].ssid,
-		       ssids[req_idx].ssid,
-		       ssids[req_idx].ssid_len);
+		       params->ssids[req_idx].ssid,
+		       params->ssids[req_idx].ssid_len);
 	}
 }
 
@@ -216,6 +228,8 @@ static void iwl_mvm_scan_calc_params(struct iwl_mvm *mvm,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_scan_condition_iterator,
 					    &global_cnt);
+	params->n_ssids = n_ssids;
+	params->flags = flags;
 
 	if (!global_cnt)
 		goto not_bound;
@@ -427,9 +441,9 @@ static int iwl_ssid_exist(u8 *ssid, u8 ssid_len, struct iwl_ssid_ie *ssid_list)
 	return -1;
 }
 
-static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
+static void iwl_scan_offload_build_ssid(struct iwl_mvm_scan_params *params,
 					struct iwl_ssid_ie *direct_scan,
-					u32 *ssid_bitmap, bool basic_ssid)
+					u32 *ssid_bitmap)
 {
 	int i, j;
 	int index;
@@ -439,28 +453,28 @@ static void iwl_scan_offload_build_ssid(struct cfg80211_sched_scan_request *req,
 	 * iwl_config_sched_scan_profiles() uses the order of these ssids to
 	 * config match list.
 	 */
-	for (i = 0; i < req->n_match_sets && i < PROBE_OPTION_MAX; i++) {
+	for (i = 0; i < params->n_match_sets && i < PROBE_OPTION_MAX; i++) {
 		/* skip empty SSID matchsets */
-		if (!req->match_sets[i].ssid.ssid_len)
+		if (!params->match_sets[i].ssid.ssid_len)
 			continue;
 		direct_scan[i].id = WLAN_EID_SSID;
-		direct_scan[i].len = req->match_sets[i].ssid.ssid_len;
-		memcpy(direct_scan[i].ssid, req->match_sets[i].ssid.ssid,
+		direct_scan[i].len = params->match_sets[i].ssid.ssid_len;
+		memcpy(direct_scan[i].ssid, params->match_sets[i].ssid.ssid,
 		       direct_scan[i].len);
 	}
 
 	/* add SSIDs from scan SSID list */
 	*ssid_bitmap = 0;
-	for (j = 0; j < req->n_ssids && i < PROBE_OPTION_MAX; j++) {
-		index = iwl_ssid_exist(req->ssids[j].ssid,
-				       req->ssids[j].ssid_len,
+	for (j = 0; j < params->n_ssids && i < PROBE_OPTION_MAX; j++) {
+		index = iwl_ssid_exist(params->ssids[j].ssid,
+				       params->ssids[j].ssid_len,
 				       direct_scan);
 		if (index < 0) {
-			if (!req->ssids[j].ssid_len && basic_ssid)
+			if (!params->ssids[j].ssid_len)
 				continue;
 			direct_scan[i].id = WLAN_EID_SSID;
-			direct_scan[i].len = req->ssids[j].ssid_len;
-			memcpy(direct_scan[i].ssid, req->ssids[j].ssid,
+			direct_scan[i].len = params->ssids[j].ssid_len;
+			memcpy(direct_scan[i].ssid, params->ssids[j].ssid,
 			       direct_scan[i].len);
 			*ssid_bitmap |= BIT(i + 1);
 			i++;
@@ -814,46 +828,54 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 }
 
 static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct cfg80211_scan_request *req,
 			     struct ieee80211_scan_ies *ies,
 			     struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq;
-	u32 flags;
-	u32 ssid_bitmap = 0;
+	u32 flags = 0, ssid_bitmap = 0;
 	int i;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	iwl_mvm_build_generic_scan_cmd(mvm, cmd, params);
 
-	cmd->n_channels = (u8)req->n_channels;
+	cmd->n_channels = (u8)params->n_channels;
+
+	cmd->delay = cpu_to_le32(params->delay);
 
-	flags = IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
+	if (params->pass_all)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
+	else
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_MATCH;
 
-	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
+	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
 	if (params->passive_fragmented)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
-	if (req->n_ssids == 0)
+	if (params->n_ssids == 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	/* TODO: Check if it's okay to have this in regular scans */
+	if (mvm->scan_iter_notif_enabled)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE;
+#endif
+
 	cmd->scan_flags |= cpu_to_le32(flags);
 
-	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
+	cmd->flags = iwl_mvm_scan_rxon_flags(params->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
-	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, req->no_cck);
-	iwl_mvm_scan_fill_ssids(cmd->direct_scan, req->ssids,
-				req->n_ssids, 0);
+	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
+	iwl_mvm_scan_fill_ssids(cmd->direct_scan, params);
 
-	cmd->schedule[0].delay = 0;
+	cmd->schedule[0].delay = cpu_to_le16(params->interval);
 	cmd->schedule[0].iterations = 1;
 	cmd->schedule[0].full_scan_mul = 0;
-	cmd->schedule[1].delay = 0;
+	cmd->schedule[1].delay = cpu_to_le16(params->interval);
 	cmd->schedule[1].iterations = 0;
 	cmd->schedule[1].full_scan_mul = 0;
 
@@ -873,29 +895,27 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
 	}
 
-	for (i = 1; i <= req->n_ssids; i++)
+	for (i = 1; i <= params->n_ssids; i++)
 		ssid_bitmap |= BIT(i);
 
-	iwl_mvm_lmac_scan_cfg_channels(mvm, req->channels,
-				       req->n_channels, ssid_bitmap,
-				       cmd);
+	iwl_mvm_lmac_scan_cfg_channels(mvm, params->channels,
+				       params->n_channels, ssid_bitmap, cmd);
 
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, preq,
-		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			req->mac_addr : NULL,
-		req->mac_addr_mask);
+		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			params->mac_addr : NULL,
+		params->mac_addr_mask);
 
 	return 0;
 }
 
-static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
-				   struct ieee80211_vif *vif,
-				   struct cfg80211_sched_scan_request *req,
-				   struct ieee80211_scan_ies *ies,
-				   struct iwl_mvm_scan_params *params)
+static int
+iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			struct ieee80211_scan_ies *ies,
+			struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq;
@@ -905,22 +925,22 @@ static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 
 	iwl_mvm_build_generic_scan_cmd(mvm, cmd, params);
 
-	cmd->n_channels = (u8)req->n_channels;
+	cmd->n_channels = (u8)params->n_channels;
 
-	cmd->delay = cpu_to_le32(req->delay);
+	cmd->delay = cpu_to_le32(params->delay);
 
-	if (iwl_mvm_scan_pass_all(mvm, req))
+	if (params->pass_all)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
 	else
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_MATCH;
 
-	if (req->n_ssids == 1 && req->ssids[0].ssid_len != 0)
+	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
 
 	if (params->passive_fragmented)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
 
-	if (req->n_ssids == 0)
+	if (params->n_ssids == 0)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -930,17 +950,18 @@ static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 
 	cmd->scan_flags |= cpu_to_le32(flags);
 
-	cmd->flags = iwl_mvm_scan_rxon_flags(req->channels[0]->band);
+	cmd->flags = iwl_mvm_scan_rxon_flags(params->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
-	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, false);
-	iwl_scan_offload_build_ssid(req, cmd->direct_scan, &ssid_bitmap, false);
+	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
+
+	iwl_scan_offload_build_ssid(params, cmd->direct_scan, &ssid_bitmap);
 
-	cmd->schedule[0].delay = cpu_to_le16(req->interval / MSEC_PER_SEC);
+	cmd->schedule[0].delay = cpu_to_le16(params->interval);
 	cmd->schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
 	cmd->schedule[0].full_scan_mul = 1;
 
-	cmd->schedule[1].delay = cpu_to_le16(req->interval / MSEC_PER_SEC);
+	cmd->schedule[1].delay = cpu_to_le16(params->interval);
 	cmd->schedule[1].iterations = 0xff;
 	cmd->schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
 
@@ -960,16 +981,16 @@ static int iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm,
 			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
 	}
 
-	iwl_mvm_lmac_scan_cfg_channels(mvm, req->channels, req->n_channels,
-				       ssid_bitmap, cmd);
+	iwl_mvm_lmac_scan_cfg_channels(mvm, params->channels,
+				       params->n_channels, ssid_bitmap, cmd);
 
 	preq = (void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			mvm->fw->ucode_capa.n_scan_channels);
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, preq,
-		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			req->mac_addr : NULL,
-		req->mac_addr_mask);
+		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			params->mac_addr : NULL,
+		params->mac_addr_mask);
 
 	return 0;
 }
@@ -1230,7 +1251,6 @@ static u32 iwl_mvm_scan_umac_common_flags(struct iwl_mvm *mvm, int n_ssids,
 }
 
 static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct cfg80211_scan_request *req,
 			     struct ieee80211_scan_ies *ies,
 			     struct iwl_mvm_scan_params *params)
 {
@@ -1240,7 +1260,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			mvm->fw->ucode_capa.n_scan_channels;
 	u32 uid, flags;
 	u32 ssid_bitmap = 0;
-	int i, uid_idx;
+	int uid_idx, i;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1256,11 +1276,14 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
 
-	flags = iwl_mvm_scan_umac_common_flags(mvm, req->n_ssids,
-					       req->ssids,
+	flags = iwl_mvm_scan_umac_common_flags(mvm, params->n_ssids,
+					       params->ssids,
 					       params->passive_fragmented);
 
-	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
+	if (params->pass_all)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
+	else
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
 
 	cmd->general_flags = cpu_to_le32(flags);
 
@@ -1270,31 +1293,29 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
-	cmd->n_channels = req->n_channels;
+	cmd->n_channels = params->n_channels;
 
-	for (i = 0; i < req->n_ssids; i++)
+	for (i = 0; i < params->n_ssids; i++)
 		ssid_bitmap |= BIT(i);
 
-	iwl_mvm_umac_scan_cfg_channels(mvm, req->channels,
-				       req->n_channels, ssid_bitmap, cmd);
+	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
+				       params->n_channels, ssid_bitmap, cmd);
 
 	sec_part->schedule[0].iter_count = 1;
 	sec_part->delay = 0;
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &sec_part->preq,
-		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			req->mac_addr : NULL,
-		req->mac_addr_mask);
+		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			params->mac_addr : NULL,
+		params->mac_addr_mask);
 
-	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, req->ssids,
-				req->n_ssids, 0);
+	iwl_mvm_scan_fill_ssids(sec_part->direct_scan, params);
 
 	return 0;
 }
 
 static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
-				   struct cfg80211_sched_scan_request *req,
 				   struct ieee80211_scan_ies *ies,
 				   struct iwl_mvm_scan_params *params)
 {
@@ -1322,12 +1343,13 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 
 	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
 
-	flags = iwl_mvm_scan_umac_common_flags(mvm, req->n_ssids, req->ssids,
+	flags = iwl_mvm_scan_umac_common_flags(mvm, params->n_ssids,
+					       params->ssids,
 					       params->passive_fragmented);
 
 	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
 
-	if (iwl_mvm_scan_pass_all(mvm, req))
+	if (params->pass_all)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
 	else
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
@@ -1340,33 +1362,33 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
-	cmd->n_channels = req->n_channels;
+	cmd->n_channels = params->n_channels;
 
-	iwl_scan_offload_build_ssid(req, sec_part->direct_scan, &ssid_bitmap,
-				    false);
+	iwl_scan_offload_build_ssid(params, sec_part->direct_scan,
+				    &ssid_bitmap);
 
 	/* This API uses bits 0-19 instead of 1-20. */
 	ssid_bitmap = ssid_bitmap >> 1;
 
-	iwl_mvm_umac_scan_cfg_channels(mvm, req->channels, req->n_channels,
-				       ssid_bitmap, cmd);
+	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
+				       params->n_channels, ssid_bitmap, cmd);
 
 	sec_part->schedule[0].interval =
-				cpu_to_le16(req->interval / MSEC_PER_SEC);
+				cpu_to_le16(params->interval / MSEC_PER_SEC);
 	sec_part->schedule[0].iter_count = 0xff;
 
-	if (req->delay > U16_MAX) {
+	if (params->delay > U16_MAX) {
 		IWL_DEBUG_SCAN(mvm,
 			       "delay value is > 16-bits, set to max possible\n");
 		sec_part->delay = cpu_to_le16(U16_MAX);
 	} else {
-		sec_part->delay = cpu_to_le16(req->delay);
+		sec_part->delay = cpu_to_le16(params->delay);
 	}
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &sec_part->preq,
-		req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
-			req->mac_addr : NULL,
-		req->mac_addr_mask);
+		params->flags & NL80211_SCAN_FLAG_RANDOM_ADDR ?
+			params->mac_addr : NULL,
+		params->mac_addr_mask);
 
 	return 0;
 }
@@ -1450,15 +1472,26 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
-				 &params);
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags, &params);
+
+	params.n_channels = req->n_channels;
+	params.delay = 0;
+	params.interval = 0;
+	params.ssids = req->ssids;
+	params.channels = req->channels;
+	params.mac_addr = req->mac_addr;
+	params.mac_addr_mask = req->mac_addr_mask;
+	params.no_cck = req->no_cck;
+	params.pass_all = true;
+	params.n_match_sets = 0;
+	params.match_sets = NULL;
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_scan_umac(mvm, vif, req, ies, &params);
+		ret = iwl_mvm_scan_umac(mvm, vif, ies, &params);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
-		ret = iwl_mvm_scan_lmac(mvm, vif, req, ies, &params);
+		ret = iwl_mvm_scan_lmac(mvm, vif, ies, &params);
 	}
 
 	if (ret)
@@ -1514,8 +1547,26 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	if (!iwl_mvm_scan_fits(mvm, req->n_ssids, ies, req->n_channels))
 		return -ENOBUFS;
 
-	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags,
-				 &params);
+	iwl_mvm_scan_calc_params(mvm, vif, req->n_ssids, req->flags, &params);
+
+	params.n_channels = req->n_channels;
+	params.delay = req->delay;
+	params.ssids = req->ssids;
+	params.channels = req->channels;
+	params.mac_addr = req->mac_addr;
+	params.mac_addr_mask = req->mac_addr_mask;
+	params.no_cck = false;
+	params.pass_all =  iwl_mvm_scan_pass_all(mvm, req);
+	params.n_match_sets = req->n_match_sets;
+	params.match_sets = req->match_sets;
+
+	if (req->interval > U16_MAX) {
+		IWL_DEBUG_SCAN(mvm,
+			       "interval value is > 16-bits, set to max possible\n");
+		params.interval = U16_MAX;
+	} else {
+		params.interval = req->interval / MSEC_PER_SEC;
+	}
 
 	ret = iwl_mvm_config_sched_scan_profiles(mvm, req);
 	if (ret)
@@ -1523,10 +1574,10 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_sched_scan_umac(mvm, vif, req, ies, &params);
+		ret = iwl_mvm_sched_scan_umac(mvm, vif, ies, &params);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
-		ret = iwl_mvm_sched_scan_lmac(mvm, vif, req, ies, &params);
+		ret = iwl_mvm_sched_scan_lmac(mvm, vif, ies, &params);
 	}
 
 	if (ret)
-- 
2.1.0

