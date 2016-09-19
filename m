Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55974 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S936248AbcISHbq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:31:46 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:16 +0300
Message-Id: <20160919073028.22065-13-luca@coelho.fi> (sfid-20160919_093149_184925_0E52A209)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 13/25] iwlwifi: mvm: make iwl_mvm_update_sta() an inline
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no point in making this an out-of-line function
since it just calls a single other function with a few
changed parameters.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c |  7 -------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h | 11 ++++++++---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index d3a0378..258a234 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1297,13 +1297,6 @@ err:
 	return ret;
 }
 
-int iwl_mvm_update_sta(struct iwl_mvm *mvm,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta)
-{
-	return iwl_mvm_sta_send_to_fw(mvm, sta, true, 0);
-}
-
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 709542b..e068d53 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -473,9 +473,14 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 		    struct ieee80211_vif *vif,
 		    struct ieee80211_sta *sta);
-int iwl_mvm_update_sta(struct iwl_mvm *mvm,
-		       struct ieee80211_vif *vif,
-		       struct ieee80211_sta *sta);
+
+static inline int iwl_mvm_update_sta(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta)
+{
+	return iwl_mvm_sta_send_to_fw(mvm, sta, true, 0);
+}
+
 int iwl_mvm_rm_sta(struct iwl_mvm *mvm,
 		   struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
-- 
2.9.3
