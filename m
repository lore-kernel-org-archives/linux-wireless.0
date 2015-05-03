Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbECTdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:07 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/42] iwlwifi: mvm: combine UMAC scans into one
Date: Sun,  3 May 2015 22:31:43 +0300
Message-Id: <1430681513-7838-32-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213327_375305_A216B23A)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

With just a few differences left in the UMAC scan functions now, we
can merge them into one, taking care of the small difference according
to the total number of iterations required.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 86 +++++++--------------------------
 1 file changed, 17 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 1abbc66..cecc5a3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -1173,6 +1173,8 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			mvm->fw->ucode_capa.n_scan_channels;
 	u32 uid, flags;
 	u32 ssid_bitmap = 0;
+	int n_iterations = params->schedule[0].iterations +
+		params->schedule[1].iterations;
 	int uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1183,77 +1185,22 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, params);
 
-	uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
-	mvm->scan_uid[uid_idx] = uid;
-	cmd->uid = cpu_to_le32(uid);
-
-	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
-
 	flags = iwl_mvm_scan_umac_common_flags(mvm, params->n_ssids,
 					       params->ssids,
 					       params->passive_fragmented);
 
-	if (params->pass_all)
-		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
-	else
-		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
-
-	cmd->general_flags = cpu_to_le32(flags);
-
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS &&
-	    mvm->last_ebs_successful)
-		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
-				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
-				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
-
-	cmd->n_channels = params->n_channels;
-
-	iwl_scan_build_ssids(params, sec_part->direct_scan, &ssid_bitmap);
-
-	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
-				       params->n_channels, ssid_bitmap, cmd);
-
-	sec_part->schedule[0].iter_count = params->schedule[0].iterations;
-	sec_part->delay = cpu_to_le16(params->delay);
-	sec_part->preq = params->preq;
-
-	return 0;
-}
-
-static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
-				   struct ieee80211_vif *vif,
-				   struct iwl_mvm_scan_params *params)
-{
-	struct iwl_scan_req_umac *cmd = mvm->scan_cmd;
-	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
-		sizeof(struct iwl_scan_channel_cfg_umac) *
-			mvm->fw->ucode_capa.n_scan_channels;
-	u32 uid, flags;
-	u32 ssid_bitmap = 0;
-	int uid_idx;
-
-	lockdep_assert_held(&mvm->mutex);
-
-	uid_idx = iwl_mvm_find_free_scan_uid(mvm);
-	if (uid_idx >= mvm->max_scans)
-		return -EBUSY;
-
-	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, params);
-
-	cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
+	if (n_iterations == 1) {
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
+		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
+	} else {
+		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
+		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN);
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
+	}
 
-	uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN);
 	mvm->scan_uid[uid_idx] = uid;
 	cmd->uid = cpu_to_le32(uid);
 
-	cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
-
-	flags = iwl_mvm_scan_umac_common_flags(mvm, params->n_ssids,
-					       params->ssids,
-					       params->passive_fragmented);
-
-	flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
-
 	if (params->pass_all)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
 	else
@@ -1261,8 +1208,7 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 
 	cmd->general_flags = cpu_to_le32(flags);
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
-	    mvm->last_ebs_successful)
+	if (iwl_mvm_scan_use_ebs(mvm, n_iterations))
 		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
@@ -1274,11 +1220,13 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
+	/* With UMAC we can have only one schedule, so use the sum of
+	 * the iterations (with a a maximum of 255).
+	 */
+	sec_part->schedule[0].iter_count =
+		(n_iterations > 255) ? 255 : n_iterations;
 	sec_part->schedule[0].interval = cpu_to_le16(params->interval);
 
-	/* With UMAC we use only one schedule, so take the final one only */
-	sec_part->schedule[0].iter_count = params->schedule[1].iterations;
-
 	sec_part->delay = cpu_to_le16(params->delay);
 	sec_part->preq = params->preq;
 
@@ -1496,7 +1444,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 
 	if (mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_CAPA_UMAC_SCAN) {
 		hcmd.id = SCAN_REQ_UMAC;
-		ret = iwl_mvm_sched_scan_umac(mvm, vif, &params);
+		ret = iwl_mvm_scan_umac(mvm, vif, &params);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
 		ret = iwl_mvm_scan_lmac(mvm, vif, &params);
-- 
2.1.0

