Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13488 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753145AbbFCHbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:51 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/15] iwlwifi: mvm: don't use EBS for P2P find
Date: Wed,  3 Jun 2015 10:31:26 +0300
Message-Id: <1433316696-4612-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093156_590653_DFDA6344)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Don't use EBS for P2P find to make sure we find all GOs in
our only attempt.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 9409237..794109e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -770,19 +770,23 @@ static inline bool iwl_mvm_scan_fits(struct iwl_mvm *mvm, int n_ssids,
 		 iwl_mvm_max_scan_ie_fw_cmd_room(mvm)));
 }
 
-static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm, int n_iterations)
+static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif,
+					int n_iterations)
 {
 	const struct iwl_ucode_capabilities *capa = &mvm->fw->ucode_capa;
 
 	/* We can only use EBS if:
 	 *	1. the feature is supported;
 	 *	2. the last EBS was successful;
-	 *	3. if only single scan, the single scan EBS API is supported.
+	 *	3. if only single scan, the single scan EBS API is supported;
+	 *	4. it's not a p2p find operation.
 	 */
 	return ((capa->flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT) &&
 		mvm->last_ebs_successful &&
 		(n_iterations > 1 ||
-		 (capa->api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)));
+		 (capa->api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS)) &&
+		vif->type != NL80211_IFTYPE_P2P_DEVICE);
 }
 
 static int iwl_mvm_scan_total_iterations(struct iwl_mvm_scan_params *params)
@@ -860,7 +864,7 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->schedule[1].iterations = params->schedule[1].iterations;
 	cmd->schedule[1].full_scan_mul = params->schedule[1].iterations;
 
-	if (iwl_mvm_scan_use_ebs(mvm, n_iterations)) {
+	if (iwl_mvm_scan_use_ebs(mvm, vif, n_iterations)) {
 		cmd->channel_opt[0].flags =
 			cpu_to_le16(IWL_SCAN_CHANNEL_FLAG_EBS |
 				    IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
@@ -1102,7 +1106,7 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	cmd->uid = cpu_to_le32(uid);
 	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params));
 
-	if (iwl_mvm_scan_use_ebs(mvm, n_iterations))
+	if (iwl_mvm_scan_use_ebs(mvm, vif, n_iterations))
 		cmd->channel_flags = IWL_SCAN_CHANNEL_FLAG_EBS |
 				     IWL_SCAN_CHANNEL_FLAG_EBS_ACCURATE |
 				     IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
-- 
2.1.4

