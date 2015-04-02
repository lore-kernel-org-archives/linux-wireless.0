Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:32677 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbbDBGmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 02:42:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/31] iwlwifi: mvm: rs: refactor rs_update_rate_tbl
Date: Thu,  2 Apr 2015 09:41:09 +0300
Message-Id: <1427956879-11725-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150402_090419_318705_2D45AA42)
In-Reply-To: <1427956656.8122.2.camel@egrumbacBox>
References: <1427956656.8122.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Minor cleanup and refactoring.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 0388e04..e00b454 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -1610,9 +1610,9 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search)
 static void rs_update_rate_tbl(struct iwl_mvm *mvm,
 			       struct ieee80211_sta *sta,
 			       struct iwl_lq_sta *lq_sta,
-			       struct rs_rate *rate)
+			       struct iwl_scale_tbl_info *tbl)
 {
-	rs_fill_lq_cmd(mvm, sta, lq_sta, rate);
+	rs_fill_lq_cmd(mvm, sta, lq_sta, &tbl->rate);
 	iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
 }
 
@@ -2142,7 +2142,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
 			rate->type = LQ_NONE;
 			lq_sta->search_better_tbl = 0;
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
-			rs_update_rate_tbl(mvm, sta, lq_sta, &tbl->rate);
+			rs_update_rate_tbl(mvm, sta, lq_sta, tbl);
 		}
 		return;
 	}
@@ -2305,7 +2305,7 @@ lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq) {
 		tbl->rate.index = index;
-		rs_update_rate_tbl(mvm, sta, lq_sta, &tbl->rate);
+		rs_update_rate_tbl(mvm, sta, lq_sta, tbl);
 	}
 
 	rs_stay_in_table(lq_sta, false);
@@ -2352,8 +2352,7 @@ lq_update:
 
 			rs_dump_rate(mvm, &tbl->rate,
 				     "Switch to SEARCH TABLE:");
-			rs_fill_lq_cmd(mvm, sta, lq_sta, &tbl->rate);
-			iwl_mvm_send_lq_cmd(mvm, &lq_sta->lq, false);
+			rs_update_rate_tbl(mvm, sta, lq_sta, tbl);
 		} else {
 			done_search = 1;
 		}
-- 
1.9.1

