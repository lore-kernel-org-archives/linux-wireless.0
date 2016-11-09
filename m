Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33774 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbcKIFuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 00:50:22 -0500
Received: by mail-pf0-f195.google.com with SMTP id 144so13893235pfv.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2016 21:50:21 -0800 (PST)
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Tue, 8 Nov 2016 21:50:15 -0800
To: Luca Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Eran Harary <eran.harary@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Eyal Shapira <eyal@wizery.com>,
        Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH v2 1/3] iwlwifi: mvm: rs: Remove unused 'mvmvif'/'mvmsta'
 variables
Message-ID: <20161109055015.GA27416@google.com> (sfid-20161109_065029_844337_FF801AFF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mvmvif is defined and set in rs_mimo_allow but not used. Compiling
iwlwifi with W=1 gives the following warning, remove it. mvmsta is used only to
obtain mvmvif so remove it as well.

iwlwifi/mvm/rs.c: In function 'rs_mimo_allow':
iwlwifi/mvm/rs.c:165:22: warning: variable 'mvmvif' set but not used.[-Wunused-but-set-variable]

This fix removes calls to iwl_mvm_sta_from_mac & iwl_mvm_vif_from_mac. They are
both accessors, and do not have any side-effects.
Commit e621c2282 removed a workaround that disabled MIMO on P2P, 'mvmvif' was
used for that workaround, but not removed with it.

Fixes: e621c2282e31 ("iwlwifi: rs: Remove workaround that disables MIMO on P2P")

Signed-off-by: Kirtika Ruchandani <kirtika@google.com>
Cc: Alexander Bondar <alexander.bondar@intel.com>
Cc: Emmanuel Grumbach <emmmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 227c5ed..0b79f4a 100644
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
2.8.0.rc3.226.g39d4020
