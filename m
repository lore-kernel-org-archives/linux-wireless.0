Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28147 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbZJPVZ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 17:25:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/10] iwlwifi: move rate scaling structures to header file
Date: Fri, 16 Oct 2009 14:25:54 -0700
Message-Id: <1255728358-29976-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
References: <1255728358-29976-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Move to header file so they can be included and used in other parts of the
driver.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  100 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.h |  101 +++++++++++++++++++++++++++++
 2 files changed, 101 insertions(+), 100 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index a07be29..2d4ec1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -75,106 +75,6 @@ static const u8 ant_toggle_lookup[] = {
 	/*ANT_ABC  -> */ ANT_ABC,
 };
 
-/**
- * struct iwl_rate_scale_data -- tx success history for one rate
- */
-struct iwl_rate_scale_data {
-	u64 data;		/* bitmap of successful frames */
-	s32 success_counter;	/* number of frames successful */
-	s32 success_ratio;	/* per-cent * 128  */
-	s32 counter;		/* number of frames attempted */
-	s32 average_tpt;	/* success ratio * expected throughput */
-	unsigned long stamp;
-};
-
-/**
- * struct iwl_scale_tbl_info -- tx params and success history for all rates
- *
- * There are two of these in struct iwl_lq_sta,
- * one for "active", and one for "search".
- */
-struct iwl_scale_tbl_info {
-	enum iwl_table_type lq_type;
-	u8 ant_type;
-	u8 is_SGI;	/* 1 = short guard interval */
-	u8 is_ht40;	/* 1 = 40 MHz channel width */
-	u8 is_dup;	/* 1 = duplicated data streams */
-	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
-	u8 max_search;	/* maximun number of tables we can search */
-	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
-	u32 current_rate;  /* rate_n_flags, uCode API format */
-	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
-};
-
-struct iwl_traffic_load {
-	unsigned long time_stamp;	/* age of the oldest statistics */
-	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time
-						 * slice */
-	u32 total;			/* total num of packets during the
-					 * last TID_MAX_TIME_DIFF */
-	u8 queue_count;			/* number of queues that has
-					 * been used since the last cleanup */
-	u8 head;			/* start of the circular buffer */
-};
-
-/**
- * struct iwl_lq_sta -- driver's rate scaling private structure
- *
- * Pointer to this gets passed back and forth between driver and mac80211.
- */
-struct iwl_lq_sta {
-	u8 active_tbl;		/* index of active table, range 0-1 */
-	u8 enable_counter;	/* indicates HT mode */
-	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
-	u8 search_better_tbl;	/* 1: currently trying alternate mode */
-	s32 last_tpt;
-
-	/* The following determine when to search for a new mode */
-	u32 table_count_limit;
-	u32 max_failure_limit;	/* # failed frames before new search */
-	u32 max_success_limit;	/* # successful frames before new search */
-	u32 table_count;
-	u32 total_failed;	/* total failed frames, any/all rates */
-	u32 total_success;	/* total successful frames, any/all rates */
-	u64 flush_timer;	/* time staying in mode before new search */
-
-	u8 action_counter;	/* # mode-switch actions tried */
-	u8 is_green;
-	u8 is_dup;
-	enum ieee80211_band band;
-	u8 ibss_sta_added;
-
-	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
-	u32 supp_rates;
-	u16 active_legacy_rate;
-	u16 active_siso_rate;
-	u16 active_mimo2_rate;
-	u16 active_mimo3_rate;
-	u16 active_rate_basic;
-	s8 max_rate_idx;     /* Max rate set by user */
-	u8 missed_rate_counter;
-
-	struct iwl_link_quality_cmd lq;
-	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
-	struct iwl_traffic_load load[TID_MAX_LOAD_COUNT];
-	u8 tx_agg_tid_en;
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_scale_table_file;
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
-	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
-	u32 dbg_fixed_rate;
-#endif
-	struct iwl_priv *drv;
-
-	/* used to be in sta_info */
-	int last_txrate_idx;
-	/* last tx rate_n_flags */
-	u32 last_rate_n_flags;
-	/* packets destined for this STA are aggregated */
-	u8 is_agg;
-};
-
 static void rs_rate_scale_perform(struct iwl_priv *priv,
 				   struct sk_buff *skb,
 				   struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
index 9fac530..affc0c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
@@ -54,6 +54,7 @@ struct iwl3945_rate_info {
 	u8 prev_table_rs;	/* prev in rate table cmd */
 };
 
+
 /*
  * These serve as indexes into
  * struct iwl_rate_info iwl_rates[IWL_RATE_COUNT];
@@ -335,6 +336,106 @@ struct iwl_rate_mcs_info {
 	char	mcs[IWL_MAX_MCS_DISPLAY_SIZE];
 };
 
+/**
+ * struct iwl_rate_scale_data -- tx success history for one rate
+ */
+struct iwl_rate_scale_data {
+	u64 data;		/* bitmap of successful frames */
+	s32 success_counter;	/* number of frames successful */
+	s32 success_ratio;	/* per-cent * 128  */
+	s32 counter;		/* number of frames attempted */
+	s32 average_tpt;	/* success ratio * expected throughput */
+	unsigned long stamp;
+};
+
+/**
+ * struct iwl_scale_tbl_info -- tx params and success history for all rates
+ *
+ * There are two of these in struct iwl_lq_sta,
+ * one for "active", and one for "search".
+ */
+struct iwl_scale_tbl_info {
+	enum iwl_table_type lq_type;
+	u8 ant_type;
+	u8 is_SGI;	/* 1 = short guard interval */
+	u8 is_ht40;	/* 1 = 40 MHz channel width */
+	u8 is_dup;	/* 1 = duplicated data streams */
+	u8 action;	/* change modulation; IWL_[LEGACY/SISO/MIMO]_SWITCH_* */
+	u8 max_search;	/* maximun number of tables we can search */
+	s32 *expected_tpt;	/* throughput metrics; expected_tpt_G, etc. */
+	u32 current_rate;  /* rate_n_flags, uCode API format */
+	struct iwl_rate_scale_data win[IWL_RATE_COUNT]; /* rate histories */
+};
+
+struct iwl_traffic_load {
+	unsigned long time_stamp;	/* age of the oldest statistics */
+	u32 packet_count[TID_QUEUE_MAX_SIZE];   /* packet count in this time
+						 * slice */
+	u32 total;			/* total num of packets during the
+					 * last TID_MAX_TIME_DIFF */
+	u8 queue_count;			/* number of queues that has
+					 * been used since the last cleanup */
+	u8 head;			/* start of the circular buffer */
+};
+
+/**
+ * struct iwl_lq_sta -- driver's rate scaling private structure
+ *
+ * Pointer to this gets passed back and forth between driver and mac80211.
+ */
+struct iwl_lq_sta {
+	u8 active_tbl;		/* index of active table, range 0-1 */
+	u8 enable_counter;	/* indicates HT mode */
+	u8 stay_in_tbl;		/* 1: disallow, 0: allow search for new mode */
+	u8 search_better_tbl;	/* 1: currently trying alternate mode */
+	s32 last_tpt;
+
+	/* The following determine when to search for a new mode */
+	u32 table_count_limit;
+	u32 max_failure_limit;	/* # failed frames before new search */
+	u32 max_success_limit;	/* # successful frames before new search */
+	u32 table_count;
+	u32 total_failed;	/* total failed frames, any/all rates */
+	u32 total_success;	/* total successful frames, any/all rates */
+	u64 flush_timer;	/* time staying in mode before new search */
+
+	u8 action_counter;	/* # mode-switch actions tried */
+	u8 is_green;
+	u8 is_dup;
+	enum ieee80211_band band;
+	u8 ibss_sta_added;
+
+	/* The following are bitmaps of rates; IWL_RATE_6M_MASK, etc. */
+	u32 supp_rates;
+	u16 active_legacy_rate;
+	u16 active_siso_rate;
+	u16 active_mimo2_rate;
+	u16 active_mimo3_rate;
+	u16 active_rate_basic;
+	s8 max_rate_idx;     /* Max rate set by user */
+	u8 missed_rate_counter;
+
+	struct iwl_link_quality_cmd lq;
+	struct iwl_scale_tbl_info lq_info[LQ_SIZE]; /* "active", "search" */
+	struct iwl_traffic_load load[TID_MAX_LOAD_COUNT];
+	u8 tx_agg_tid_en;
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *rs_sta_dbgfs_scale_table_file;
+	struct dentry *rs_sta_dbgfs_stats_table_file;
+	struct dentry *rs_sta_dbgfs_rate_scale_data_file;
+	struct dentry *rs_sta_dbgfs_tx_agg_tid_en_file;
+	u32 dbg_fixed_rate;
+#endif
+	struct iwl_priv *drv;
+
+	/* used to be in sta_info */
+	int last_txrate_idx;
+	/* last tx rate_n_flags */
+	u32 last_rate_n_flags;
+	/* packets destined for this STA are aggregated */
+	u8 is_agg;
+};
+
 static inline u8 num_of_ant(u8 mask)
 {
 	return  !!((mask) & ANT_A) +
-- 
1.5.6.3

