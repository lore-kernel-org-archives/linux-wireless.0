Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbHRH6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:17 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/26] iwlwifi: mvm: remove partial and full scan lists from lmac sched scan
Date: Tue, 18 Aug 2015 10:57:25 +0300
Message-Id: <1439884656-18146-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100108_824638_6550BC4E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Lmac sched scan supports partial scans, so we can set some channels to be
scanned on every scan iteration and others to be scanned only on some
iterations. Currently we set all channels to be scanned every iteration,
but still have some configuration of which iterations should be partial
and which should be full.

Remove all partial/full scan configuration to reduce confusions.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 308a60e..f456aad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -140,10 +140,7 @@ struct iwl_mvm_scan_params {
 	int n_match_sets;
 	struct iwl_scan_probe_req preq;
 	struct cfg80211_match_set *match_sets;
-	struct {
-		u8 iterations;
-		u8 full_scan_mul; /* not used for UMAC */
-	} schedule[2];
+	u8 iterations[2];
 };
 
 static u8 iwl_mvm_scan_rx_ant(struct iwl_mvm *mvm)
@@ -750,7 +747,7 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 
 static int iwl_mvm_scan_total_iterations(struct iwl_mvm_scan_params *params)
 {
-	return params->schedule[0].iterations + params->schedule[1].iterations;
+	return params->iterations[0] + params->iterations[1];
 }
 
 static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
@@ -817,11 +814,11 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ssid_bitmap <<= 1;
 
 	cmd->schedule[0].delay = cpu_to_le16(params->interval);
-	cmd->schedule[0].iterations = params->schedule[0].iterations;
-	cmd->schedule[0].full_scan_mul = params->schedule[0].full_scan_mul;
+	cmd->schedule[0].iterations = params->iterations[0];
+	cmd->schedule[0].full_scan_mul = 1;
 	cmd->schedule[1].delay = cpu_to_le16(params->interval);
-	cmd->schedule[1].iterations = params->schedule[1].iterations;
-	cmd->schedule[1].full_scan_mul = params->schedule[1].iterations;
+	cmd->schedule[1].iterations = params->iterations[1];
+	cmd->schedule[1].full_scan_mul = 1;
 
 	if (iwl_mvm_scan_use_ebs(mvm, vif, n_iterations)) {
 		cmd->channel_opt[0].flags =
@@ -1180,10 +1177,8 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	params.n_match_sets = 0;
 	params.match_sets = NULL;
 
-	params.schedule[0].iterations = 1;
-	params.schedule[0].full_scan_mul = 0;
-	params.schedule[1].iterations = 0;
-	params.schedule[1].full_scan_mul = 0;
+	params.iterations[0] = 1;
+	params.iterations[1] = 0;
 
 	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
 
@@ -1263,10 +1258,9 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	params.n_match_sets = req->n_match_sets;
 	params.match_sets = req->match_sets;
 
-	params.schedule[0].iterations = IWL_FAST_SCHED_SCAN_ITERATIONS;
-	params.schedule[0].full_scan_mul = 1;
-	params.schedule[1].iterations = 0xff;
-	params.schedule[1].full_scan_mul = IWL_FULL_SCAN_MULTIPLIER;
+	params.iterations[0] = 0;
+	params.iterations[1] = 0xff;
+
 	params.type = iwl_mvm_get_scan_type(mvm, vif, &params);
 
 	if (req->interval > U16_MAX) {
-- 
2.1.4

