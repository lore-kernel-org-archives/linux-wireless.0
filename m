Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbbECTdP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 36/42] iwlwifi: mvm: move all UMAC scan flags setting into the relevant function
Date: Sun,  3 May 2015 22:31:47 +0300
Message-Id: <1430681513-7838-36-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213346_402199_AFA37681)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Clean the code a little by moving all the flags into the right
function.  Additionally, rename the function, since "common" is now
irrelevant.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 44 ++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index cecc5a3..437adc3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -831,6 +831,11 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm, int n_iterations)
 		 (capa->api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)));
 }
 
+static int iwl_mvm_scan_total_iterations(struct iwl_mvm_scan_params *params)
+{
+	return params->schedule[0].iterations + params->schedule[1].iterations;
+}
+
 static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct iwl_mvm_scan_params *params)
 {
@@ -839,8 +844,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		(void *)(cmd->data + sizeof(struct iwl_scan_channel_cfg_lmac) *
 			 mvm->fw->ucode_capa.n_scan_channels);
 	u32 flags = 0, ssid_bitmap = 0;
-	int n_iterations = params->schedule[0].iterations +
-		params->schedule[1].iterations;
+	int n_iterations = iwl_mvm_scan_total_iterations(params);
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -1143,24 +1147,31 @@ iwl_mvm_umac_scan_cfg_channels(struct iwl_mvm *mvm,
 	}
 }
 
-static u32 iwl_mvm_scan_umac_common_flags(struct iwl_mvm *mvm, int n_ssids,
-					  struct cfg80211_ssid *ssids,
-					  int fragmented)
+static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
+				   struct iwl_mvm_scan_params *params)
 {
 	int flags = 0;
 
-	if (n_ssids == 0)
+	if (params->n_ssids == 0)
 		flags = IWL_UMAC_SCAN_GEN_FLAGS_PASSIVE;
 
-	if (n_ssids == 1 && ssids[0].ssid_len != 0)
+	if (params->n_ssids == 1 && params->ssids[0].ssid_len != 0)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PRE_CONNECT;
 
-	if (fragmented)
+	if (params->passive_fragmented)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED;
 
 	if (iwl_mvm_rrm_scan_needed(mvm))
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED;
 
+	if (params->pass_all)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
+	else
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
+
+	if (iwl_mvm_scan_total_iterations(params) > 1)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
+
 	return flags;
 }
 
@@ -1171,10 +1182,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	struct iwl_scan_req_umac_tail *sec_part = (void *)&cmd->data +
 		sizeof(struct iwl_scan_channel_cfg_umac) *
 			mvm->fw->ucode_capa.n_scan_channels;
-	u32 uid, flags;
+	u32 uid;
 	u32 ssid_bitmap = 0;
-	int n_iterations = params->schedule[0].iterations +
-		params->schedule[1].iterations;
+	int n_iterations = iwl_mvm_scan_total_iterations(params);
 	int uid_idx;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1185,28 +1195,18 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	iwl_mvm_build_generic_umac_scan_cmd(mvm, cmd, params);
 
-	flags = iwl_mvm_scan_umac_common_flags(mvm, params->n_ssids,
-					       params->ssids,
-					       params->passive_fragmented);
-
 	if (n_iterations == 1) {
 		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_HIGH);
 		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_REG_SCAN);
 	} else {
 		cmd->ooc_priority = cpu_to_le32(IWL_SCAN_PRIORITY_LOW);
 		uid = iwl_generate_scan_uid(mvm, IWL_UMAC_SCAN_UID_SCHED_SCAN);
-		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PERIODIC;
 	}
 
 	mvm->scan_uid[uid_idx] = uid;
 	cmd->uid = cpu_to_le32(uid);
 
-	if (params->pass_all)
-		flags |= IWL_UMAC_SCAN_GEN_FLAGS_PASS_ALL;
-	else
-		flags |= IWL_UMAC_SCAN_GEN_FLAGS_MATCH;
-
-	cmd->general_flags = cpu_to_le32(flags);
+	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params));
 
 	if (iwl_mvm_scan_use_ebs(mvm, n_iterations))
 		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
-- 
2.1.0

