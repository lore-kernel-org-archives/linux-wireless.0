Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:31544 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbXI0DfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 23:35:00 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH] iwlwifi: rs_rate_scale_perform clean up
Date: Thu, 27 Sep 2007 11:27:41 +0800
Message-Id: <11908636801368-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1190863679136-git-send-email-yi.zhu@intel.com>
References: <11908636643693-git-send-email-yi.zhu@intel.com>
 <11908636662994-git-send-email-yi.zhu@intel.com>
 <11908636683204-git-send-email-yi.zhu@intel.com>
 <11908636692415-git-send-email-yi.zhu@intel.com>
 <119086367088-git-send-email-yi.zhu@intel.com>
 <11908636712746-git-send-email-yi.zhu@intel.com>
 <11908636732679-git-send-email-yi.zhu@intel.com>
 <11908636743625-git-send-email-yi.zhu@intel.com>
 <11908636753775-git-send-email-yi.zhu@intel.com>
 <11908636772860-git-send-email-yi.zhu@intel.com>
 <11908636781043-git-send-email-yi.zhu@intel.com>
 <1190863679136-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up rs_rate_scale_perform function. It removes dead
code, shortens variable names and removes useless return i.e. function
now returns void.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index bad7466..c4b8ca1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -131,7 +131,7 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct net_device *dev,
 				   struct ieee80211_hdr *hdr,
 				   struct sta_info *sta);
-static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
+static void rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			     struct iwl_rate *tx_mcs,
 			     struct iwl_link_quality_cmd *tbl);
 
@@ -1873,16 +1873,15 @@ static void rs_rate_init(void *priv_rate, void *priv_sta,
 	rs_initialize_lq(priv, sta);
 }
 
-static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
+static void rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			    struct iwl_rate *tx_mcs,
 			    struct iwl_link_quality_cmd *lq_cmd)
 {
 	int index = 0;
-	int rc = 0;
 	int rate_idx;
+	int repeat_rate = 0;
 	u8 ant_toggle_count = 0;
 	u8 use_ht_possible = 1;
-	u8 repeat_cur_rate = 0;
 	struct iwl_rate new_rate;
 	struct iwl_scale_tbl_info tbl_type = { 0 };
 
@@ -1891,9 +1890,9 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 
 	if (is_legacy(tbl_type.lq_type)) {
 		ant_toggle_count = 1;
-		repeat_cur_rate = IWL_NUMBER_TRY;
+		repeat_rate = IWL_NUMBER_TRY;
 	} else
-		repeat_cur_rate = IWL_HT_NUMBER_TRY;
+		repeat_rate = IWL_HT_NUMBER_TRY;
 
 	lq_cmd->general_params.mimo_delimiter =
 			is_mimo(tbl_type.lq_type) ? 1 : 0;
@@ -1907,10 +1906,10 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 		lq_cmd->general_params.single_stream_ant_msk = 2;
 
 	index++;
-	repeat_cur_rate--;
+	repeat_rate--;
 
 	while (index < LINK_QUAL_MAX_RETRY_NUM) {
-		while (repeat_cur_rate && (index < LINK_QUAL_MAX_RETRY_NUM)) {
+		while (repeat_rate > 0 && (index < LINK_QUAL_MAX_RETRY_NUM)) {
 			if (is_legacy(tbl_type.lq_type)) {
 				if (ant_toggle_count <
 				    NUM_TRY_BEFORE_ANTENNA_TOGGLE)
@@ -1922,7 +1921,7 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 			}
 			lq_cmd->rs_table[index].rate_n_flags =
 					cpu_to_le32(new_rate.rate_n_flags);
-			repeat_cur_rate--;
+			repeat_rate--;
 			index++;
 		}
 
@@ -1942,26 +1941,22 @@ static int rs_fill_link_cmd(struct iwl_rate_scale_priv *lq_data,
 				rs_toggle_antenna(&new_rate, &tbl_type);
 				ant_toggle_count = 1;
 			}
-			repeat_cur_rate = IWL_NUMBER_TRY;
+			repeat_rate = IWL_NUMBER_TRY;
 		} else
-			repeat_cur_rate = IWL_HT_NUMBER_TRY;
+			repeat_rate = IWL_HT_NUMBER_TRY;
 
 		use_ht_possible = 0;
 
 		lq_cmd->rs_table[index].rate_n_flags =
 				cpu_to_le32(new_rate.rate_n_flags);
-		/* lq_cmd->rs_table[index].rate_n_flags = 0x800d; */
 
 		index++;
-		repeat_cur_rate--;
+		repeat_rate--;
 	}
 
-	/* lq_cmd->rs_table[0].rate_n_flags = 0x800d; */
-
 	lq_cmd->general_params.dual_stream_ant_msk = 3;
 	lq_cmd->agg_params.agg_dis_start_th = 3;
 	lq_cmd->agg_params.agg_time_limit = cpu_to_le16(4000);
-	return rc;
 }
 
 static void *rs_alloc(struct ieee80211_local *local)
-- 
1.5.1
