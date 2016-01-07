Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbcAGMr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/21] iwlwifi: mvm: fix extended dwell time
Date: Thu,  7 Jan 2016 14:47:29 +0200
Message-Id: <1452170861-10060-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_140653_548774_3DD4B036)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

FW adds 10 msec for every dwell time in low band, so we need
to set 10 msec less.
Don't use extended dwell time when fragmented scan is needed
because FW adds 3 msec per probe and it can easily exceed
max out of channel time.

Fixes: c3e230b167a9 ("iwlwifi: mvm: add extended dwell time")
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index bee3201..9a15642 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -92,7 +92,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
-		.dwell_extended = 100,
+		.dwell_extended = 90,
 		.suspend_time = 0,
 		.max_out_time = 0,
 	},
@@ -100,7 +100,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
-		.dwell_extended = 100,
+		.dwell_extended = 90,
 		.suspend_time = 30,
 		.max_out_time = 120,
 	},
@@ -108,7 +108,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
-		.dwell_extended = 100,
+		.dwell_extended = 90,
 		.suspend_time = 120,
 		.max_out_time = 120,
 	},
@@ -116,7 +116,6 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
-		.dwell_extended = 44,
 		.suspend_time = 95,
 		.max_out_time = 44,
 	},
@@ -790,7 +789,8 @@ static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 #endif
 
 	if (iwl_mvm_is_regular_scan(params) &&
-	    vif->type != NL80211_IFTYPE_P2P_DEVICE)
+	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
+	    params->type != IWL_SCAN_TYPE_FRAGMENTED)
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_EXTENDED_DWELL;
 
 	return flags;
@@ -1072,7 +1072,8 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 #endif
 
 	if (iwl_mvm_is_regular_scan(params) &&
-	    vif->type != NL80211_IFTYPE_P2P_DEVICE)
+	    vif->type != NL80211_IFTYPE_P2P_DEVICE &&
+	    params->type != IWL_SCAN_TYPE_FRAGMENTED)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_EXTENDED_DWELL;
 
 	return flags;
-- 
2.5.0

