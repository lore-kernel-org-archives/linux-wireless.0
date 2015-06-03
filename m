Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:13470 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbbFCHbp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:31:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/15] iwlwifi: mvm: rs: pass rate directly to column checks
Date: Wed,  3 Jun 2015 10:31:22 +0300
Message-Id: <1433316696-4612-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150603_093148_842885_71B3C13D)
In-Reply-To: <1433316253.25661.3.camel@intel.com>
References: <1433316253.25661.3.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

A minor refactoring for following patches.
This enables the reuse of the checks functions.

type=cleanup

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 1295178..ae99656 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -138,7 +138,7 @@ struct rs_tx_column;
 
 typedef bool (*allow_column_func_t) (struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta,
-				     struct iwl_scale_tbl_info *tbl,
+				     struct rs_rate *rate,
 				     const struct rs_tx_column *next_col);
 
 struct rs_tx_column {
@@ -150,14 +150,14 @@ struct rs_tx_column {
 };
 
 static bool rs_ant_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			 struct iwl_scale_tbl_info *tbl,
+			 struct rs_rate *rate,
 			 const struct rs_tx_column *next_col)
 {
 	return iwl_mvm_bt_coex_is_ant_avail(mvm, next_col->ant);
 }
 
 static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  struct iwl_scale_tbl_info *tbl,
+			  struct rs_rate *rate,
 			  const struct rs_tx_column *next_col)
 {
 	struct iwl_mvm_sta *mvmsta;
@@ -187,7 +187,7 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 }
 
 static bool rs_siso_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  struct iwl_scale_tbl_info *tbl,
+			  struct rs_rate *rate,
 			  const struct rs_tx_column *next_col)
 {
 	if (!sta->ht_cap.ht_supported)
@@ -197,10 +197,9 @@ static bool rs_siso_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 }
 
 static bool rs_sgi_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			 struct iwl_scale_tbl_info *tbl,
+			 struct rs_rate *rate,
 			 const struct rs_tx_column *next_col)
 {
-	struct rs_rate *rate = &tbl->rate;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
 	struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
 
@@ -1659,7 +1658,8 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 
 		for (j = 0; j < MAX_COLUMN_CHECKS; j++) {
 			allow_func = next_col->checks[j];
-			if (allow_func && !allow_func(mvm, sta, tbl, next_col))
+			if (allow_func && !allow_func(mvm, sta, &tbl->rate,
+						      next_col))
 				break;
 		}
 
-- 
2.1.4

