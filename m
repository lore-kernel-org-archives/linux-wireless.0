Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbCATbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:31:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/31] iwlwifi: mvm: rs: fix BT Coex check to look at the correct ant
Date: Sun,  1 Mar 2015 21:31:15 +0200
Message-Id: <1425238304-498-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203155_864365_EADFB6B7)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

The check to avoid the shared antenna was passed the wrong
antenna parameter. It should have checked whether the antenna of
the next column we're considering is allowed and instead it was
passed the current antenna.
This could lead to a wrong choice of the next column in the rs
algorithm and non optimal performance.

Fixes: commit 219fb66b49fac64bb ("iwlwifi: mvm: rs - don't use the shared antenna when BT load is high")
Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 1e82434..2e45b81 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -134,9 +134,12 @@ enum rs_column_mode {
 #define MAX_NEXT_COLUMNS 7
 #define MAX_COLUMN_CHECKS 3
 
+struct rs_tx_column;
+
 typedef bool (*allow_column_func_t) (struct iwl_mvm *mvm,
 				     struct ieee80211_sta *sta,
-				     struct iwl_scale_tbl_info *tbl);
+				     struct iwl_scale_tbl_info *tbl,
+				     const struct rs_tx_column *next_col);
 
 struct rs_tx_column {
 	enum rs_column_mode mode;
@@ -147,13 +150,15 @@ struct rs_tx_column {
 };
 
 static bool rs_ant_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			 struct iwl_scale_tbl_info *tbl)
+			 struct iwl_scale_tbl_info *tbl,
+			 const struct rs_tx_column *next_col)
 {
-	return iwl_mvm_bt_coex_is_ant_avail(mvm, tbl->rate.ant);
+	return iwl_mvm_bt_coex_is_ant_avail(mvm, next_col->ant);
 }
 
 static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  struct iwl_scale_tbl_info *tbl)
+			  struct iwl_scale_tbl_info *tbl,
+			  const struct rs_tx_column *next_col)
 {
 	if (!sta->ht_cap.ht_supported)
 		return false;
@@ -171,7 +176,8 @@ static bool rs_mimo_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 }
 
 static bool rs_siso_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			  struct iwl_scale_tbl_info *tbl)
+			  struct iwl_scale_tbl_info *tbl,
+			  const struct rs_tx_column *next_col)
 {
 	if (!sta->ht_cap.ht_supported)
 		return false;
@@ -180,7 +186,8 @@ static bool rs_siso_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 }
 
 static bool rs_sgi_allow(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
-			 struct iwl_scale_tbl_info *tbl)
+			 struct iwl_scale_tbl_info *tbl,
+			 const struct rs_tx_column *next_col)
 {
 	struct rs_rate *rate = &tbl->rate;
 	struct ieee80211_sta_ht_cap *ht_cap = &sta->ht_cap;
@@ -1557,7 +1564,7 @@ static enum rs_column rs_get_next_column(struct iwl_mvm *mvm,
 
 		for (j = 0; j < MAX_COLUMN_CHECKS; j++) {
 			allow_func = next_col->checks[j];
-			if (allow_func && !allow_func(mvm, sta, tbl))
+			if (allow_func && !allow_func(mvm, sta, tbl, next_col))
 				break;
 		}
 
-- 
1.9.1

