Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56969 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbbJYMCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:02:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/16] iwlwifi: mvm: remove pointless scan plan checks
Date: Sun, 25 Oct 2015 14:01:13 +0200
Message-Id: <1445774476-24792-13-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_131654_681676_6144CB70)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As cfg80211 already enforces these limits, there's little point
in having them again here in our code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/scan.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index a8e11cc..0e9d28c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -819,16 +819,9 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ssid_bitmap <<= 1;
 
 	for (i = 0; i < params->n_scan_plans; i++) {
-		struct wiphy *wiphy = mvm->hw->wiphy;
 		struct cfg80211_sched_scan_plan *scan_plan =
 			&params->scan_plans[i];
 
-		if (WARN_ON(scan_plan->iterations >
-			    wiphy->max_sched_scan_plan_iterations ||
-			    scan_plan->interval >
-			    wiphy->max_sched_scan_plan_interval))
-			return -EINVAL;
-
 		cmd->schedule[i].delay =
 			cpu_to_le16(scan_plan->interval);
 		cmd->schedule[i].iterations = scan_plan->iterations;
@@ -1103,16 +1096,9 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				       params->n_channels, ssid_bitmap, cmd);
 
 	for (i = 0; i < params->n_scan_plans; i++) {
-		struct wiphy *wiphy = mvm->hw->wiphy;
 		struct cfg80211_sched_scan_plan *scan_plan =
 			&params->scan_plans[i];
 
-		if (WARN_ON(scan_plan->iterations >
-			    wiphy->max_sched_scan_plan_iterations ||
-			    scan_plan->interval >
-			    wiphy->max_sched_scan_plan_interval))
-			return -EINVAL;
-
 		sec_part->schedule[i].iter_count = scan_plan->iterations;
 		sec_part->schedule[i].interval =
 			cpu_to_le16(scan_plan->interval);
-- 
2.1.4

