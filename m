Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752195AbbHRH6f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 22/26] iwlwifi: rs: disable MIMO only if allowed in configuration
Date: Tue, 18 Aug 2015 10:57:32 +0300
Message-Id: <1439884656-18146-22-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100108_501318_9EB52E3E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Fix bug where MIMO is disabled for low latency TX on P2P VIF
regardless of configuration. Make it dependent on
IWL_MVM_RS_DISABLE_P2P_MIMO compilation option. Change configuration
so that MIMO will be disabled only in SDIO platforms.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 19a7926..5ae9c8a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -177,7 +177,8 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
-	if (iwl_mvm_vif_low_latency(mvmvif) && mvmsta->vif->p2p)
+	if (IWL_MVM_RS_DISABLE_P2P_MIMO &&
+	    iwl_mvm_vif_low_latency(mvmvif) && mvmsta->vif->p2p)
 		return false;
 
 	if (mvm->nvm_data->sku_cap_mimo_disabled)
-- 
2.1.4

