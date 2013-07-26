Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab3GZI3l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:41 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 27/30] iwlwifi: remove duplicate rate scale init code
Date: Fri, 26 Jul 2013 10:28:44 +0200
Message-Id: <1374827327-3464-28-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103017_504453_A68CCB92)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The rate scale windows are cleared twice as part of the init.
Cleanup this duplication in both mvm and dvm.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.c | 3 ---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 1b69394..3395387 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -2826,9 +2826,6 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
-	for (j = 0; j < LQ_SIZE; j++)
-		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
 	IWL_DEBUG_RATE(priv, "LQ: *** rate scale station global init for station %d ***\n",
 		       sta_id);
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 3856c28..e4a7b387 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2688,9 +2688,6 @@ void iwl_mvm_rs_rate_init(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->supp_rates[sband->band];
-	for (j = 0; j < LQ_SIZE; j++)
-		for (i = 0; i < IWL_RATE_COUNT; i++)
-			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
 
 	IWL_DEBUG_RATE(mvm,
 		       "LQ: *** rate scale station global init for station %d ***\n",
-- 
1.8.0

