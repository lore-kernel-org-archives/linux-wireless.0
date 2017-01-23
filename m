Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36266 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751762AbdAWWSd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:33 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com,
        Kirtika Ruchandani <kirtika.ruchandani@gmail.com>,
        Kirtika Ruchandani <kirtika@google.com>,
        Alexander Bondar <alexander.bondar@intel.com>,
        Emmanuel Grumbach <emmmanuel.grumbach@intel.com>
Date: Tue, 24 Jan 2017 00:03:41 +0200
Message-Id: <20170123220350.25305-17-luca@coelho.fi> (sfid-20170123_231836_396361_16250E02)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: mvm: rs: Remove unused 'mvmvif'/'mvmsta' variables
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>

mvmvif is defined and set in rs_mimo_allow but not used. Compiling
iwlwifi with W=1 gives the following warning, remove it. mvmsta is
used only to obtain mvmvif so remove it as well.

iwlwifi/mvm/rs.c: In function 'rs_mimo_allow':
iwlwifi/mvm/rs.c:165:22: warning: variable 'mvmvif' set but not used.[-Wunused-but-set-variable]

This fix removes calls to iwl_mvm_sta_from_mac &
iwl_mvm_vif_from_mac. They are both accessors, and do not have any
side-effects.  Commit e621c2282e31 ("iwlwifi: rs: Remove workaround
that disables MIMO on P2P") removed a workaround that disabled MIMO on
P2P, 'mvmvif' was used for that workaround, but not removed with it.

Fixes: e621c2282e31 ("iwlwifi: rs: Remove workaround that disables MIMO on P2P")
Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Emmanuel Grumbach <emmmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 227c5ed9cbe6..0b79f4a43eaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -161,9 +161,6 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			  struct rs_rate *rate,
 			  const struct rs_tx_column *next_col)
 {
-	struct iwl_mvm_sta *mvmsta;
-	struct iwl_mvm_vif *mvmvif;
-
 	if (!sta->ht_cap.ht_supported)
 		return false;
 
@@ -176,9 +173,6 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	if (!iwl_mvm_bt_coex_is_mimo_allowed(mvm, sta))
 		return false;
 
-	mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	mvmvif = iwl_mvm_vif_from_mac80211(mvmsta->vif);
-
 	if (mvm->nvm_data->sku_cap_mimo_disabled)
 		return false;
 
-- 
2.11.0
