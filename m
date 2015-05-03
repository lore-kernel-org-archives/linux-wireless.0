Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9552 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbbECTdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 15:33:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/42] iwlwifi: mvm: add number of scan iterations and multiplier to params
Date: Sun,  3 May 2015 22:31:40 +0300
Message-Id: <1430681513-7838-29-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150503_213316_580077_161DC19D)
In-Reply-To: <1430681438.3240.3.camel@intel.com>
References: <1430681438.3240.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

As another step towards combining the scan and sched scan functions,
add parameters that tell the scan function how many iterations we want
(i.e. 1 for normal scan, more for scheduled scan) and that set the
full scan multiplier (only meaningful for LMAC).

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 42 ++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index acff2e7..5576152 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -98,6 +98,10 @@ struct iwl_mvm_scan_params {
 		u16 active;
 		u16 fragmented;
 	} dwell[IEEE80211_NUM_BANDS];
+	struct {
+		u8 iterations;
+		u8 full_scan_mul; /* not used for UMAC */
+	} schedule[2];
 };
 
 enum iwl_umac_scan_uid_type {
@@ -861,11 +865,11 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ssid_bitmap <<= 1;
 
 	cmd->schedule[0].delay = cpu_to_le16(params->interval);
-	cmd->schedule[0].iterations = 1;
-	cmd->schedule[0].full_scan_mul = 0;
+	cmd->schedule[0].iterations = params->schedule[0].iterations;
+	cmd->schedule[0].full_scan_mul = params->schedule[0].full_scan_mul;
 	cmd->schedule[1].delay = cpu_to_le16(params->interval);
-	cmd->schedule[1].iterations = 0;
-	cmd->schedule[1].full_scan_mul = 0;
+	cmd->schedule[1].iterations = params->schedule[1].iterations;
+	cmd->schedule[1].full_scan_mul = params->schedule[1].iterations;
 
 	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_SINGLE_SCAN_EBS &&
 	    mvm->last_ebs_successful) {
@@ -941,12 +945,11 @@ iwl_mvm_sched_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ssid_bitmap <<= 1;
 
 	cmd->schedule[0].delay = cpu_to_le16(params->interval);
-	cmd->schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
-	cmd->schedule[0].full_scan_mul = 1;
-
+	cmd->schedule[0].iterations = params->schedule[0].iterations;
+	cmd->schedule[0].full_scan_mul = params->schedule[0].full_scan_mul;
 	cmd->schedule[1].delay = cpu_to_le16(params->interval);
-	cmd->schedule[1].iterations = 0xff;
-	cmd->schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
+	cmd->schedule[1].iterations = params->schedule[1].iterations;
+	cmd->schedule[1].full_scan_mul = params->schedule[1].iterations;
 
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_EBS_SUPPORT &&
 	    mvm->last_ebs_successful) {
@@ -1276,8 +1279,8 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
-	sec_part->schedule[0].iter_count = 1;
-	sec_part->delay = 0;
+	sec_part->schedule[0].iter_count = params->schedule[0].iterations;
+	sec_part->delay = cpu_to_le16(params->delay);
 	sec_part->preq = params->preq;
 
 	return 0;
@@ -1337,9 +1340,10 @@ static int iwl_mvm_sched_scan_umac(struct iwl_mvm *mvm,
 	iwl_mvm_umac_scan_cfg_channels(mvm, params->channels,
 				       params->n_channels, ssid_bitmap, cmd);
 
-	sec_part->schedule[0].interval =
-				cpu_to_le16(params->interval / MSEC_PER_SEC);
-	sec_part->schedule[0].iter_count = 0xff;
+	sec_part->schedule[0].interval = cpu_to_le16(params->interval);
+
+	/* With UMAC we use only one schedule, so take the final one only */
+	sec_part->schedule[0].iter_count = params->schedule[1].iterations;
 
 	if (params->delay > U16_MAX) {
 		IWL_DEBUG_SCAN(mvm,
@@ -1447,6 +1451,11 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.n_match_sets = 0;
 	params.match_sets = NULL;
 
+	params.schedule[0].iterations = 1;
+	params.schedule[0].full_scan_mul = 0;
+	params.schedule[1].iterations = 0;
+	params.schedule[1].full_scan_mul = 0;
+
 	iwl_mvm_scan_calc_dwell(mvm, vif, &params);
 
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
@@ -1525,6 +1534,11 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.n_match_sets = req->n_match_sets;
 	params.match_sets = req->match_sets;
 
+	params.schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
+	params.schedule[0].full_scan_mul = 1;
+	params.schedule[1].iterations = 0xff;
+	params.schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
+
 	if (req->interval > U16_MAX) {
 		IWL_DEBUG_SCAN(mvm,
 			       "interval value is > 16-bits, set to max possible\n");
-- 
2.1.0

