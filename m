Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:46048 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbbLUUvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:51:25 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/45] iwlwifi: mvm: remove the vif parameter of iwl_mvm_configure_bcast_filter()
Date: Mon, 21 Dec 2015 22:50:19 +0200
Message-Id: <1450731046-2796-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_215146_332927_A9EB8041)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Remove the vif parameter of iwl_mvm_configure_bcast_filter()
as it's not being used.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index f428f1c..7487eb0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1734,8 +1734,8 @@ bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
 
 	return true;
 }
-static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif)
+
+static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm)
 {
 	struct iwl_bcast_filter_cmd cmd;
 
@@ -1749,8 +1749,7 @@ static int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
 				    sizeof(cmd), &cmd);
 }
 #else
-static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm,
-						 struct ieee80211_vif *vif)
+static inline int iwl_mvm_configure_bcast_filter(struct iwl_mvm *mvm)
 {
 	return 0;
 }
@@ -1865,7 +1864,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		}
 
 		iwl_mvm_recalc_multicast(mvm);
-		iwl_mvm_configure_bcast_filter(mvm, vif);
+		iwl_mvm_configure_bcast_filter(mvm);
 
 		/* reset rssi values */
 		mvmvif->bf_data.ave_beacon_signal = 0;
@@ -1916,7 +1915,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 
 	if (changes & BSS_CHANGED_ARP_FILTER) {
 		IWL_DEBUG_MAC80211(mvm, "arp filter changed\n");
-		iwl_mvm_configure_bcast_filter(mvm, vif);
+		iwl_mvm_configure_bcast_filter(mvm);
 	}
 }
 
-- 
2.5.0

