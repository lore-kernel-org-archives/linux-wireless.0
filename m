Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112AbZGXSNO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 01/14] iwlwifi: revert to active table when rate is not valid
Date: Fri, 24 Jul 2009 11:13:00 -0700
Message-Id: <1248459194-10239-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When performing rate scaling, if detected that the new rate
index is invalid, clear the search_better_tbl flag
so it will not be stuck in the loop.

Since the search table is already set up in uCode,
we need to empty out the the search table;
revert back to the "active" rate and throughput info.
Also pass the "active" table setup to uCode to make
sure the rate scale is functioning correctly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   37 +++++++++++++++++++++++++----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 6328041..40207da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2003,6 +2003,25 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta)
 }
 
 /*
+ * setup rate table in uCode
+ * return rate_n_flags as used in the table
+ */
+static u32 rs_update_rate_tbl(struct iwl_priv *priv,
+				struct iwl_lq_sta *lq_sta,
+				struct iwl_scale_tbl_info *tbl,
+				int index, u8 is_green)
+{
+	u32 rate;
+
+	/* Update uCode's rate table. */
+	rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
+	rs_fill_link_cmd(priv, lq_sta, rate);
+	iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
+
+	return rate;
+}
+
+/*
  * Do rate scaling and search for new modulation mode.
  */
 static void rs_rate_scale_perform(struct iwl_priv *priv,
@@ -2098,6 +2117,16 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 	if (!((1 << index) & rate_scale_index_msk)) {
 		IWL_ERR(priv, "Current Rate is not valid\n");
+		if (lq_sta->search_better_tbl) {
+			/* revert to active table if search table is not valid*/
+			tbl->lq_type = LQ_NONE;
+			lq_sta->search_better_tbl = 0;
+			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
+			/* get "active" rate info */
+			index = iwl_hwrate_to_plcp_idx(tbl->current_rate);
+			rate = rs_update_rate_tbl(priv, lq_sta,
+						  tbl, index, is_green);
+		}
 		return;
 	}
 
@@ -2308,11 +2337,9 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
-	if (update_lq) {
-		rate = rate_n_flags_from_tbl(priv, tbl, index, is_green);
-		rs_fill_link_cmd(priv, lq_sta, rate);
-		iwl_send_lq_cmd(priv, &lq_sta->lq, CMD_ASYNC);
-	}
+	if (update_lq)
+		rate = rs_update_rate_tbl(priv, lq_sta,
+					  tbl, index, is_green);
 
 	/* Should we stay with this modulation mode, or search for a new one? */
 	rs_stay_in_table(lq_sta);
-- 
1.5.6.3

