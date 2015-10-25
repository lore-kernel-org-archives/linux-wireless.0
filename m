Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23998 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbJYMBW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 08:01:22 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/16] iwlwifi: rs: Remove workaround that disables MIMO on P2P
Date: Sun, 25 Oct 2015 14:01:01 +0200
Message-Id: <1445774476-24792-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_130125_324199_BD7C1FDE)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8AF6CC@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Remove an old workaround that's no longer needed and
enable MIMO on P2P interfaces.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 1 -
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 6 ------
 2 files changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index a3ca6db..aa9ae1d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -101,7 +101,6 @@
 #define IWL_MVM_FW_BCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_QUOTA_THRESHOLD			4
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
-#define IWL_MVM_RS_DISABLE_P2P_MIMO		0
 #define IWL_MVM_RS_80_20_FAR_RANGE_TWEAK	1
 #define IWL_MVM_TOF_IS_RESPONDER		0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 34d98b2..d1ad103 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -177,9 +177,6 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
-	if (IWL_MVM_RS_DISABLE_P2P_MIMO &&
-	    iwl_mvm_vif_low_latency(mvmvif) && mvmsta->vif->p2p)
-		return false;
 
 	if (mvm->nvm_data->sku_cap_mimo_disabled)
 		return false;
@@ -3071,9 +3068,6 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	else
 		rs_vht_init(mvm, sta, lq_sta, vht_cap);
 
-	if (IWL_MVM_RS_DISABLE_P2P_MIMO && sta_priv->vif->p2p)
-		lq_sta->active_mimo2_rate = 0;
-
 	lq_sta->max_legacy_rate_idx =
 		rs_get_max_rate_from_mask(lq_sta->active_legacy_rate);
 	lq_sta->max_siso_rate_idx =
-- 
2.1.4

