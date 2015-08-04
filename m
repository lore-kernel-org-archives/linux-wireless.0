Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbbHDU7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Nicholas Krause <xerofoify@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/37] iwlwifi: make various functions void in the file rs.c
Date: Tue,  4 Aug 2015 23:43:23 +0300
Message-Id: <1438721007-23283-33-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230716_112650_4298766C)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nicholas Krause <xerofoify@gmail.com>

This makes various functions in the file rs.c void due to these
functions never returning a error code to signal to their callers
if and how they have failed to complete their intended work.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.c | 51 +++++++++++++++--------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index 3bd7c86..cef921c 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -1416,11 +1416,11 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 /*
  * Try to switch to new modulation mode from legacy
  */
-static int rs_move_legacy_other(struct iwl_priv *priv,
-				struct iwl_lq_sta *lq_sta,
-				struct ieee80211_conf *conf,
-				struct ieee80211_sta *sta,
-				int index)
+static void rs_move_legacy_other(struct iwl_priv *priv,
+				 struct iwl_lq_sta *lq_sta,
+				 struct ieee80211_conf *conf,
+				 struct ieee80211_sta *sta,
+				 int index)
 {
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 	struct iwl_scale_tbl_info *search_tbl =
@@ -1575,7 +1575,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
 
 	}
 	search_tbl->lq_type = LQ_NONE;
-	return 0;
+	return;
 
 out:
 	lq_sta->search_better_tbl = 1;
@@ -1584,17 +1584,15 @@ out:
 		tbl->action = IWL_LEGACY_SWITCH_ANTENNA1;
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
-	return 0;
-
 }
 
 /*
  * Try to switch to new modulation mode from SISO
  */
-static int rs_move_siso_to_other(struct iwl_priv *priv,
-				 struct iwl_lq_sta *lq_sta,
-				 struct ieee80211_conf *conf,
-				 struct ieee80211_sta *sta, int index)
+static void rs_move_siso_to_other(struct iwl_priv *priv,
+				  struct iwl_lq_sta *lq_sta,
+				  struct ieee80211_conf *conf,
+				  struct ieee80211_sta *sta, int index)
 {
 	u8 is_green = lq_sta->is_green;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1747,7 +1745,7 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 			break;
 	}
 	search_tbl->lq_type = LQ_NONE;
-	return 0;
+	return;
 
  out:
 	lq_sta->search_better_tbl = 1;
@@ -1756,17 +1754,15 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
 		tbl->action = IWL_SISO_SWITCH_ANTENNA1;
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
-
-	return 0;
 }
 
 /*
  * Try to switch to new modulation mode from MIMO2
  */
-static int rs_move_mimo2_to_other(struct iwl_priv *priv,
-				 struct iwl_lq_sta *lq_sta,
-				 struct ieee80211_conf *conf,
-				 struct ieee80211_sta *sta, int index)
+static void rs_move_mimo2_to_other(struct iwl_priv *priv,
+				   struct iwl_lq_sta *lq_sta,
+				   struct ieee80211_conf *conf,
+				   struct ieee80211_sta *sta, int index)
 {
 	s8 is_green = lq_sta->is_green;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -1917,7 +1913,7 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 			break;
 	}
 	search_tbl->lq_type = LQ_NONE;
-	return 0;
+	return;
  out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
@@ -1926,17 +1922,15 @@ static int rs_move_mimo2_to_other(struct iwl_priv *priv,
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
 
-	return 0;
-
 }
 
 /*
  * Try to switch to new modulation mode from MIMO3
  */
-static int rs_move_mimo3_to_other(struct iwl_priv *priv,
-				 struct iwl_lq_sta *lq_sta,
-				 struct ieee80211_conf *conf,
-				 struct ieee80211_sta *sta, int index)
+static void rs_move_mimo3_to_other(struct iwl_priv *priv,
+				   struct iwl_lq_sta *lq_sta,
+				   struct ieee80211_conf *conf,
+				   struct ieee80211_sta *sta, int index)
 {
 	s8 is_green = lq_sta->is_green;
 	struct iwl_scale_tbl_info *tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
@@ -2093,7 +2087,7 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 			break;
 	}
 	search_tbl->lq_type = LQ_NONE;
-	return 0;
+	return;
  out:
 	lq_sta->search_better_tbl = 1;
 	tbl->action++;
@@ -2101,9 +2095,6 @@ static int rs_move_mimo3_to_other(struct iwl_priv *priv,
 		tbl->action = IWL_MIMO3_SWITCH_ANTENNA1;
 	if (update_search_tbl_counter)
 		search_tbl->action = tbl->action;
-
-	return 0;
-
 }
 
 /*
-- 
2.1.4

