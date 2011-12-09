Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:63468 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab1LIBZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 20:25:05 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/15] iwlagn: use IWL_MAX_TID_COUNT instead of TID_MAX_LOAD_COUNT
Date: Thu,  8 Dec 2011 16:26:22 -0800
Message-Id: <1323390382-1678-16-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111209_022519_202093_126A9C97)
In-Reply-To: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We track the load only on 8 TIDs, previously this
was TID_MAX_LOAD_COUNT. Since IWL_MAX_TID_COUNT
is now 8 as well, use that to make the code more
easily understandable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |    3 +--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 78efa2b..a23835a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -298,7 +298,7 @@ static u8 rs_tl_add_packet(struct iwl_lq_sta *lq_data,
 	} else
 		return IWL_MAX_TID_COUNT;
 
-	if (unlikely(tid >= TID_MAX_LOAD_COUNT))
+	if (unlikely(tid >= IWL_MAX_TID_COUNT))
 		return IWL_MAX_TID_COUNT;
 
 	tl = &lq_data->load[tid];
@@ -379,7 +379,7 @@ static u32 rs_tl_get_load(struct iwl_lq_sta *lq_data, u8 tid)
 	s32 index;
 	struct iwl_traffic_load *tl = NULL;
 
-	if (tid >= TID_MAX_LOAD_COUNT)
+	if (tid >= IWL_MAX_TID_COUNT)
 		return 0;
 
 	tl = &(lq_data->load[tid]);
@@ -444,11 +444,11 @@ static void rs_tl_turn_on_agg(struct iwl_priv *priv, u8 tid,
 			      struct iwl_lq_sta *lq_data,
 			      struct ieee80211_sta *sta)
 {
-	if (tid < TID_MAX_LOAD_COUNT)
+	if (tid < IWL_MAX_TID_COUNT)
 		rs_tl_turn_on_agg_for_tid(priv, lq_data, tid, sta);
 	else
-		IWL_ERR(priv, "tid exceeds max load count: %d/%d\n",
-			tid, TID_MAX_LOAD_COUNT);
+		IWL_ERR(priv, "tid exceeds max TID count: %d/%d\n",
+			tid, IWL_MAX_TID_COUNT);
 }
 
 static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index f4f6deb..6675b3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -281,7 +281,6 @@ enum {
 #define TID_QUEUE_CELL_SPACING	50	/*mS */
 #define TID_QUEUE_MAX_SIZE	20
 #define TID_ROUND_VALUE		5	/* mS */
-#define TID_MAX_LOAD_COUNT	8
 
 #define TID_MAX_TIME_DIFF ((TID_QUEUE_MAX_SIZE - 1) * TID_QUEUE_CELL_SPACING)
 #define TIME_WRAP_AROUND(x, y) (((y) > (x)) ? (y) - (x) : (0-(x)) + (y))
@@ -402,7 +401,7 @@ struct iwl_lq_sta {
 
 	struct iwl_link_quality_cmd lq;
 	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
-	struct iwl_traffic_load load[TID_MAX_LOAD_COUNT];
+	struct iwl_traffic_load load[IWL_MAX_TID_COUNT];
 	u8 tx_agg_tid_en;
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct dentry *rs_sta_dbgfs_scale_table_file;
-- 
1.7.0.4

