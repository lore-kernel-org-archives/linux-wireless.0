Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbbECTdC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/42] iwlwifi: mvm: combine LMAC scans into one
Date: Sun,  3 May 2015 22:31:41 +0300
Message-Id: <1430681513-7838-30-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213321_785296_0A885AC4)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The last remaining difference between the regular scan and scheduled
scan flows for LMAC is the FW capabilities check for EBS scans.

Merge these checks into a new function and then combine the LMAC scan
functions into a single one.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 100 ++++++--------------------------
 1 file changed, 17 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 5576152..f4d38f5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -816,94 +816,31 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 		 iwl_mvm_max_scan_ie_fw_cmd_room(mvm)));
 }
 
-static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-			     struct iwl_mvm_scan_params *params)
+static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm, int n_iterations)
 {
-	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
-	struct iwl_scan_probe_req *preq =
-		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
-			 mvm->fw->ucode_capa.n_scan_channels);
-	u32 flags = 0, ssid_bitmap = 0;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	iwl_mvm_build_generic_scan_cmd(mvm, cmd, params);
+	const struct iwl_ucode_capabilities *capa = &mvm->fw->ucode_capa;
 
-	cmd->n_channels = (u8)params->n_channels;
-
-	cmd->delay = cpu_to_le32(params->delay);
-
-	if (params->pass_all)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASS_ALL;
-	else
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_MATCH;
-
-	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_PRE_CONNECTION;
-
-	if (params->passive_fragmented)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED;
-
-	if (params->n_ssids == 0)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_PASSIVE;
-
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	/* TODO: Check if it's okay to have this in regular scans */
-	if (mvm->scan_iter_notif_enabled)
-		flags |= IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE;
-#endif
-
-	cmd->scan_flags |= cpu_to_le32(flags);
-
-	cmd->flags = iwl_mvm_scan_rxon_flags(params->channels[0]->band);
-	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
-					MAC_FILTER_IN_BEACON);
-	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
-	iwl_scan_build_ssids(params, cmd->direct_scan, &ssid_bitmap);
-
-	/* this API uses bits 1-20 instead of 0-19 */
-	ssid_bitmap <<= 1;
-
-	cmd->schedule[0].delay = cpu_to_le16(params->interval);
-	cmd->schedule[0].iterations = params->schedule[0].iterations;
-	cmd->schedule[0].full_scan_mul = params->schedule[0].full_scan_mul;
-	cmd->schedule[1].delay = cpu_to_le16(params->interval);
-	cmd->schedule[1].iterations = params->schedule[1].iterations;
-	cmd->schedule[1].full_scan_mul = params->schedule[1].iterations;
-
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS &&
-	    mvm->last_ebs_successful) {
-		cmd->channel_opt[0].flags =
-			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
-				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
-		cmd->channel_opt[0].non_ebs_ratio =
-			cpu_to_le16(IWL_DENSE_EBS_SCAN_RATIO);
-		cmd->channel_opt[1].flags =
-			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
-				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-				    IWL_SCAN_CHANNEL_FLAG_CACHE_ADD);
-		cmd->channel_opt[1].non_ebs_ratio =
-			cpu_to_le16(IWL_SPARSE_EBS_SCAN_RATIO);
-	}
-
-	iwl_mvm_lmac_scan_cfg_channels(mvm, params->channels,
-				       params->n_channels, ssid_bitmap, cmd);
-
-	*preq = params->preq;
-
-	return 0;
+	/* We can only use EBS if:
+	 *	1. the feature is supported;
+	 *	2. the last EBS was successful;
+	 *	3. if only single scan, the single scan EBS API is supported.
+	 */
+	return ((capa->flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT) &&
+		mvm->last_ebs_successful &&
+		(n_iterations > 1 ||
+		 (capa->api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)));
 }
 
-static int
-iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
-				   struct iwl_mvm_scan_params *params)
+static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
+			     struct iwl_mvm_scan_params *params)
 {
 	struct iwl_scan_req_lmac *cmd = mvm->scan_cmd;
 	struct iwl_scan_probe_req *preq =
 		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			 mvm->fw->ucode_capa.n_scan_channels);
 	u32 flags = 0, ssid_bitmap = 0;
+	int n_iterations = params->schedule[0].iterations +
+		params->schedule[1].iterations;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -938,7 +875,6 @@ iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
 					MAC_FILTER_IN_BEACON);
 	iwl_mvm_scan_fill_tx_cmd(mvm, cmd->tx_cmd, params->no_cck);
-
 	iwl_scan_build_ssids(params, cmd->direct_scan, &ssid_bitmap);
 
 	/* this API uses bits 1-20 instead of 0-19 */
@@ -951,8 +887,7 @@ iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->schedule[1].iterations = params->schedule[1].iterations;
 	cmd->schedule[1].full_scan_mul = params->schedule[1].iterations;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
-	    mvm->last_ebs_successful) {
+	if (iwl_mvm_scan_use_ebs(mvm, n_iterations)) {
 		cmd->channel_opt[0].flags =
 			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
 				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
@@ -975,7 +910,6 @@ iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return 0;
 }
 
-
 int iwl_mvm_cancel_scan(struct iwl_mvm *mvm)
 {
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN)
@@ -1560,7 +1494,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 		ret = iwl_mvm_sched_scan_umac(mvm, vif, &params);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
-		ret = iwl_mvm_sched_scan_lmac(mvm, vif, &params);
+		ret = iwl_mvm_scan_lmac(mvm, vif, &params);
 	}
 
 	if (ret)
-- 
2.1.0

