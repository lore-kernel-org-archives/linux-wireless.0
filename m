Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37338 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751074AbdGEGFv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2017 02:05:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  5 Jul 2017 09:05:38 +0300
Message-Id: <20170705060539.20737-7-luca@coelho.fi> (sfid-20170705_080604_437823_A20FFBB3)
In-Reply-To: <20170705060539.20737-1-luca@coelho.fi>
References: <20170705060539.20737-1-luca@coelho.fi>
Subject: [PATCH 6/7] iwlwifi: mvm: handle IBSS probe_queue in a few missing places
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When IBSS was implemented for DQA, we missid a few places where it
should be handled in the same way as AP.

Fixes: ee48b72211f8 ("iwlwifi: mvm: support ibss in dqa mode")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 4a6df45b73df..ab66b4394dfc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2027,7 +2027,8 @@ int iwl_mvm_send_add_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 						IWL_MAX_TID_COUNT,
 						wdg_timeout);
 
-		if (vif->type == NL80211_IFTYPE_AP)
+		if (vif->type == NL80211_IFTYPE_AP ||
+		    vif->type == NL80211_IFTYPE_ADHOC)
 			mvm->probe_queue = queue;
 		else if (vif->type == NL80211_IFTYPE_P2P_DEVICE)
 			mvm->p2p_dev_queue = queue;
-- 
2.11.0
