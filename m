Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38881 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059AbbEZTSh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:18:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/39] iwlwifi: mvm: make iwl_mvm_config_sched_scan_profiles() static
Date: Tue, 26 May 2015 22:17:34 +0300
Message-Id: <1432667872-18092-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150526_213349_058256_1D274DEC)
In-Reply-To: <1432667798.26624.3.camel@intel.com>
References: <1432667798.26624.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The iwl_mvm_config_sched_scan_profiles() function is only used in
scan.c, so remove the declaration from mvm.h and make it static.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h  | 2 --
 drivers/net/wireless/iwlwifi/mvm/scan.c | 5 +++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d4e0cab..46668ef 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1133,8 +1133,6 @@ int iwl_mvm_rx_scan_offload_complete_notif(struct iwl_mvm *mvm,
 int iwl_mvm_rx_scan_offload_iter_complete_notif(struct iwl_mvm *mvm,
 						struct iwl_rx_cmd_buffer *rxb,
 						struct iwl_device_cmd *cmd);
-int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
-				       struct cfg80211_sched_scan_request *req);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_sched_scan_request *req,
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 81ea9f4..443562c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -476,8 +476,9 @@ static void iwl_scan_build_ssids(struct iwl_mvm_scan_params *params,
 	}
 }
 
-int iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
-				       struct cfg80211_sched_scan_request *req)
+static int
+iwl_mvm_config_sched_scan_profiles(struct iwl_mvm *mvm,
+				   struct cfg80211_sched_scan_request *req)
 {
 	struct iwl_scan_offload_profile *profile;
 	struct iwl_scan_offload_profile_cfg *profile_cfg;
-- 
2.1.4

