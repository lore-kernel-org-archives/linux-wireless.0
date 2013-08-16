Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3HPLH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>
Subject: [PATCH 14/20] iwlwifi: mvm: remove unused param of rs_dbgfs_set_mcs
Date: Fri, 16 Aug 2013 13:07:04 +0200
Message-Id: <1376651230-1060-14-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130802_344739_D59F1991)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

clean it up

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/rs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 5cb3132..9ae1bad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -161,10 +161,10 @@ static void rs_stay_in_table(struct iwl_lq_sta *lq_sta, bool force_search);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
-			     u32 *rate_n_flags, int index);
+			     u32 *rate_n_flags);
 #else
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
-			     u32 *rate_n_flags, int index)
+			     u32 *rate_n_flags)
 {}
 #endif
 
@@ -2370,7 +2370,7 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 	struct iwl_lq_cmd *lq_cmd = &lq_sta->lq;
 
 	/* Override starting rate (index 0) if needed for debug purposes */
-	rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
+	rs_dbgfs_set_mcs(lq_sta, &new_rate);
 
 	/* Interpret new_rate (rate_n_flags) */
 	rs_get_tbl_info_from_mcs(new_rate, lq_sta->band,
@@ -2417,7 +2417,7 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 			}
 
 			/* Override next rate if needed for debug purposes */
-			rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
+			rs_dbgfs_set_mcs(lq_sta, &new_rate);
 
 			/* Fill next table entry */
 			lq_cmd->rs_table[index] =
@@ -2459,7 +2459,7 @@ static void rs_fill_link_cmd(struct iwl_mvm *mvm,
 		use_ht_possible = 0;
 
 		/* Override next rate if needed for debug purposes */
-		rs_dbgfs_set_mcs(lq_sta, &new_rate, index);
+		rs_dbgfs_set_mcs(lq_sta, &new_rate);
 
 		/* Fill next table entry */
 		lq_cmd->rs_table[index] = cpu_to_le32(new_rate);
@@ -2504,7 +2504,7 @@ static void rs_free_sta(void *mvm_r, struct ieee80211_sta *sta,
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
-			     u32 *rate_n_flags, int index)
+			     u32 *rate_n_flags)
 {
 	struct iwl_mvm *mvm;
 	u8 valid_tx_ant;
-- 
1.8.4.rc2

