Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758574AbZIQRnz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:55 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel C Halperin <daniel.c.halperin@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/13] iwlwifi: add aggregation tables to the rate scaling algorithm
Date: Thu, 17 Sep 2009 10:43:50 -0700
Message-Id: <1253209436-2309-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel C Halperin <daniel.c.halperin@intel.com>

Current rate scale algorithm fluctuates between different MIMO modes fairly
rapidly, causing widely varying performance. These fluctuations occur because in
the rate_scale tables for expected throughput the values are not very different
for different modes.

However, when aggregation is turned on and MAC overhead is reduced, the
expected throughput for different MIMO modes grows and different modes have
vastly different performance. Add expected throughput tables for this case.

We also need to keep track of aggregation status per-station, so we add the
"is_agg" field to struct lq_sta.

Also includes cleanup of comments and variable names in/around the affected
code.

Signed-off-by: Daniel C Halperin <daniel.c.halperin@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |  223 +++++++++++++++--------------
 1 files changed, 115 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index cd24763..e6c35e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -171,6 +171,8 @@ struct iwl_lq_sta {
 	int last_txrate_idx;
 	/* last tx rate_n_flags */
 	u32 last_rate_n_flags;
+	/* packets destined for this STA are aggregated */
+	u8 is_agg;
 };
 
 static void rs_rate_scale_perform(struct iwl_priv *priv,
@@ -190,84 +192,78 @@ static void rs_dbgfs_set_mcs(struct iwl_lq_sta *lq_sta,
 {}
 #endif
 
-/*
- * Expected throughput metrics for following rates:
- * 1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
- * "G" is the only table that supports CCK (the first 4 rates).
+/**
+ * The following tables contain the expected throughput metrics for all rates
+ *
+ *	1, 2, 5.5, 11, 6, 9, 12, 18, 24, 36, 48, 54, 60 MBits
+ *
+ * where invalid entries are zeros.
+ *
+ * CCK rates are only valid in legacy table and will only be used in G
+ * (2.4 GHz) band.
  */
 
-static s32 expected_tpt_A[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 40, 57, 72, 98, 121, 154, 177, 186, 186
-};
-
-static s32 expected_tpt_G[IWL_RATE_COUNT] = {
-	7, 13, 35, 58, 40, 57, 72, 98, 121, 154, 177, 186, 186
-};
-
-static s32 expected_tpt_siso20MHz[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 42, 42, 76, 102, 124, 159, 183, 193, 202
-};
-
-static s32 expected_tpt_siso20MHzSGI[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 46, 46, 82, 110, 132, 168, 192, 202, 211
-};
-
-static s32 expected_tpt_mimo2_20MHz[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 74, 74, 123, 155, 179, 214, 236, 244, 251
-};
-
-static s32 expected_tpt_mimo2_20MHzSGI[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 81, 81, 131, 164, 188, 222, 243, 251, 257
+static s32 expected_tpt_legacy[IWL_RATE_COUNT] = {
+	7, 13, 35, 58, 40, 57, 72, 98, 121, 154, 177, 186, 0
 };
 
-static s32 expected_tpt_siso40MHz[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 77, 77, 127, 160, 184, 220, 242, 250, 257
+static s32 expected_tpt_siso20MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0, 42, 0,  76, 102, 124, 158, 183, 193, 202}, /* Norm */
+	{0, 0, 0, 0, 46, 0,  82, 110, 132, 167, 192, 202, 210}, /* SGI */
+	{0, 0, 0, 0, 48, 0,  93, 135, 176, 251, 319, 351, 381}, /* AGG */
+	{0, 0, 0, 0, 53, 0, 102, 149, 193, 275, 348, 381, 413}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_siso40MHzSGI[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 83, 83, 135, 169, 193, 229, 250, 257, 264
+static s32 expected_tpt_siso40MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0,  77, 0, 127, 160, 184, 220, 242, 250, 257}, /* Norm */
+	{0, 0, 0, 0,  83, 0, 135, 169, 193, 229, 250, 257, 264}, /* SGI */
+	{0, 0, 0, 0,  96, 0, 182, 259, 328, 451, 553, 598, 640}, /* AGG */
+	{0, 0, 0, 0, 106, 0, 199, 282, 357, 487, 593, 640, 683}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo2_40MHz[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 123, 123, 182, 214, 235, 264, 279, 285, 289
+static s32 expected_tpt_mimo2_20MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0,  74, 0, 123, 155, 179, 213, 235, 243, 250}, /* Norm */
+	{0, 0, 0, 0,  81, 0, 131, 164, 187, 221, 242, 250, 256}, /* SGI */
+	{0, 0, 0, 0,  92, 0, 175, 250, 317, 436, 534, 578, 619}, /* AGG */
+	{0, 0, 0, 0, 102, 0, 192, 273, 344, 470, 573, 619, 660}, /* AGG+SGI*/
 };
 
-static s32 expected_tpt_mimo2_40MHzSGI[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 131, 131, 191, 222, 242, 270, 284, 289, 293
+static s32 expected_tpt_mimo2_40MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0, 123, 0, 182, 214, 235, 264, 279, 285, 289}, /* Norm */
+	{0, 0, 0, 0, 131, 0, 191, 222, 242, 270, 284, 289, 293}, /* SGI */
+	{0, 0, 0, 0, 180, 0, 327, 446, 545, 708, 828, 878, 922}, /* AGG */
+	{0, 0, 0, 0, 197, 0, 355, 481, 584, 752, 872, 922, 966}, /* AGG+SGI */
 };
 
-/* Expected throughput metric MIMO3 */
-static s32 expected_tpt_mimo3_20MHz[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 99, 99, 153, 186, 208, 239, 256, 263, 268
+static s32 expected_tpt_mimo3_20MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0,  99, 0, 153, 186, 208, 239, 256, 263, 268}, /* Norm */
+	{0, 0, 0, 0, 106, 0, 162, 194, 215, 246, 262, 268, 273}, /* SGI */
+	{0, 0, 0, 0, 134, 0, 249, 346, 431, 574, 685, 732, 775}, /* AGG */
+	{0, 0, 0, 0, 148, 0, 272, 376, 465, 614, 727, 775, 818}, /* AGG+SGI */
 };
 
-static s32 expected_tpt_mimo3_20MHzSGI[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 106, 106, 162, 194, 215, 246, 262, 268, 273
-};
-
-static s32 expected_tpt_mimo3_40MHz[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 152, 152, 211, 239, 255, 279, 290, 294, 297
-};
-
-static s32 expected_tpt_mimo3_40MHzSGI[IWL_RATE_COUNT] = {
-	0, 0, 0, 0, 160, 160, 219, 245, 261, 284, 294, 297, 300
+static s32 expected_tpt_mimo3_40MHz[4][IWL_RATE_COUNT] = {
+	{0, 0, 0, 0, 152, 0, 211, 239, 255, 279,  290,  294,  297}, /* Norm */
+	{0, 0, 0, 0, 160, 0, 219, 245, 261, 284,  294,  297,  300}, /* SGI */
+	{0, 0, 0, 0, 254, 0, 443, 584, 695, 868,  984, 1030, 1070}, /* AGG */
+	{0, 0, 0, 0, 277, 0, 478, 624, 737, 911, 1026, 1070, 1109}, /* AGG+SGI */
 };
 
 /* mbps, mcs */
 const static struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
-  {"1", ""},
-  {"2", ""},
-  {"5.5", ""},
-  {"11", ""},
-  {"6", "BPSK 1/2"},
-  {"9", "BPSK 1/2"},
-  {"12", "QPSK 1/2"},
-  {"18", "QPSK 3/4"},
-  {"24", "16QAM 1/2"},
-  {"36", "16QAM 3/4"},
-  {"48", "64QAM 2/3"},
-  {"54", "64QAM 3/4"},
-  {"60", "64QAM 5/6"}
+	{  "1", "BPSK DSSS"},
+	{  "2", "QPSK DSSS"},
+	{"5.5", "BPSK CCK"},
+	{ "11", "QPSK CCK"},
+	{  "6", "BPSK 1/2"},
+	{  "9", "BPSK 1/2"},
+	{ "12", "QPSK 1/2"},
+	{ "18", "QPSK 3/4"},
+	{ "24", "16QAM 1/2"},
+	{ "36", "16QAM 3/4"},
+	{ "48", "64QAM 2/3"},
+	{ "54", "64QAM 3/4"},
+	{ "60", "64QAM 5/6"},
 };
 
 #define MCS_INDEX_PER_STREAM	(8)
@@ -444,7 +440,7 @@ static inline int get_num_of_ant_from_rate(u32 rate_n_flags)
  * packets.
  */
 static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
-			      int scale_index, s32 tpt, int retries,
+			      int scale_index, s32 tpt, int attempts,
 			      int successes)
 {
 	struct iwl_rate_scale_data *window = NULL;
@@ -454,7 +450,7 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 	if (scale_index < 0 || scale_index >= IWL_RATE_COUNT)
 		return -EINVAL;
 
-	/* Select data for current tx bit rate */
+	/* Select window for current tx bit rate */
 	window = &(windows[scale_index]);
 
 	/*
@@ -465,7 +461,7 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 	 * subtract "1" from the success counter (this is the main reason
 	 * we keep these bitmaps!).
 	 */
-	while (retries > 0) {
+	while (attempts > 0) {
 		if (window->counter >= IWL_RATE_MAX_WINDOW) {
 
 			/* remove earliest */
@@ -480,17 +476,17 @@ static int rs_collect_tx_data(struct iwl_rate_scale_data *windows,
 		/* Increment frames-attempted counter */
 		window->counter++;
 
-		/* Shift bitmap by one frame (throw away oldest history),
-		 * OR in "1", and increment "success" if this
-		 * frame was successful. */
+		/* Shift bitmap by one frame to throw away oldest history */
 		window->data <<= 1;
+
+		/* Mark the most recent #successes attempts as successful */
 		if (successes > 0) {
 			window->success_counter++;
 			window->data |= 0x1;
 			successes--;
 		}
 
-		retries--;
+		attempts--;
 	}
 
 	/* Calculate current success ratio, avoid divide-by-0! */
@@ -868,12 +864,11 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 	    info->flags & IEEE80211_TX_CTL_NO_ACK)
 		return;
 
-	/* This packet was aggregated but doesn't carry rate scale info */
+	/* This packet was aggregated but doesn't carry status info */
 	if ((info->flags & IEEE80211_TX_CTL_AMPDU) &&
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added)
 		return;
@@ -1052,43 +1047,45 @@ static void rs_set_stay_in_table(struct iwl_priv *priv, u8 is_legacy,
 static void rs_set_expected_tpt_table(struct iwl_lq_sta *lq_sta,
 				      struct iwl_scale_tbl_info *tbl)
 {
+	/* Used to choose among HT tables */
+	s32 (*ht_tbl_pointer)[IWL_RATE_COUNT];
+
+	/* Check for invalid LQ type */
+	if (WARN_ON_ONCE(!is_legacy(tbl->lq_type) && !is_Ht(tbl->lq_type))) {
+		tbl->expected_tpt = expected_tpt_legacy;
+		return;
+	}
+
+	/* Legacy rates have only one table */
 	if (is_legacy(tbl->lq_type)) {
-		if (!is_a_band(tbl->lq_type))
-			tbl->expected_tpt = expected_tpt_G;
-		else
-			tbl->expected_tpt = expected_tpt_A;
-	} else if (is_siso(tbl->lq_type)) {
-		if (tbl->is_ht40 && !lq_sta->is_dup)
-			if (tbl->is_SGI)
-				tbl->expected_tpt = expected_tpt_siso40MHzSGI;
-			else
-				tbl->expected_tpt = expected_tpt_siso40MHz;
-		else if (tbl->is_SGI)
-			tbl->expected_tpt = expected_tpt_siso20MHzSGI;
-		else
-			tbl->expected_tpt = expected_tpt_siso20MHz;
-	} else if (is_mimo2(tbl->lq_type)) {
-		if (tbl->is_ht40 && !lq_sta->is_dup)
-			if (tbl->is_SGI)
-				tbl->expected_tpt = expected_tpt_mimo2_40MHzSGI;
-			else
-				tbl->expected_tpt = expected_tpt_mimo2_40MHz;
-		else if (tbl->is_SGI)
-			tbl->expected_tpt = expected_tpt_mimo2_20MHzSGI;
-		else
-			tbl->expected_tpt = expected_tpt_mimo2_20MHz;
-	} else if (is_mimo3(tbl->lq_type)) {
-		if (tbl->is_ht40 && !lq_sta->is_dup)
-			if (tbl->is_SGI)
-				tbl->expected_tpt = expected_tpt_mimo3_40MHzSGI;
-			else
-				tbl->expected_tpt = expected_tpt_mimo3_40MHz;
-		else if (tbl->is_SGI)
-			tbl->expected_tpt = expected_tpt_mimo3_20MHzSGI;
-		else
-			tbl->expected_tpt = expected_tpt_mimo3_20MHz;
-	} else
-		tbl->expected_tpt = expected_tpt_G;
+		tbl->expected_tpt = expected_tpt_legacy;
+		return;
+	}
+
+	/* Choose among many HT tables depending on number of streams
+	 * (SISO/MIMO2/MIMO3), channel width (20/40), SGI, and aggregation
+	 * status */
+	if (is_siso(tbl->lq_type) && (!tbl->is_ht40 || lq_sta->is_dup))
+		ht_tbl_pointer = expected_tpt_siso20MHz;
+	else if (is_siso(tbl->lq_type))
+		ht_tbl_pointer = expected_tpt_siso40MHz;
+	else if (is_mimo2(tbl->lq_type) && (!tbl->is_ht40 || lq_sta->is_dup))
+		ht_tbl_pointer = expected_tpt_mimo2_20MHz;
+	else if (is_mimo2(tbl->lq_type))
+		ht_tbl_pointer = expected_tpt_mimo2_40MHz;
+	else if (is_mimo3(tbl->lq_type) && (!tbl->is_ht40 || lq_sta->is_dup))
+		ht_tbl_pointer = expected_tpt_mimo3_20MHz;
+	else /* if (is_mimo3(tbl->lq_type)) <-- must be true */
+		ht_tbl_pointer = expected_tpt_mimo3_40MHz;
+
+	if (!tbl->is_SGI && !lq_sta->is_agg)		/* Normal */
+		tbl->expected_tpt = ht_tbl_pointer[0];
+	else if (tbl->is_SGI && !lq_sta->is_agg)	/* SGI */
+		tbl->expected_tpt = ht_tbl_pointer[1];
+	else if (!tbl->is_SGI && lq_sta->is_agg)	/* AGG */
+		tbl->expected_tpt = ht_tbl_pointer[2];
+	else						/* AGG+SGI */
+		tbl->expected_tpt = ht_tbl_pointer[3];
 }
 
 /*
@@ -2063,6 +2060,14 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = rs_tl_add_packet(lq_sta, hdr);
+	if ((tid != MAX_TID_COUNT) && (lq_sta->tx_agg_tid_en & (1 << tid))) {
+		tid_data = &priv->stations[lq_sta->lq.sta_id].tid[tid];
+		if (tid_data->agg.state == IWL_AGG_OFF)
+			lq_sta->is_agg = 0;
+		else
+			lq_sta->is_agg = 1;
+	} else
+		lq_sta->is_agg = 0;
 
 	/*
 	 * Select rate-scale / modulation-mode table to work with in
@@ -2163,10 +2168,10 @@ static void rs_rate_scale_perform(struct iwl_priv *priv,
 
 		goto out;
 	}
-
 	/* Else we have enough samples; calculate estimate of
 	 * actual average throughput */
 
+	/* Sanity-check TPT calculations */
 	BUG_ON(window->average_tpt != ((window->success_ratio *
 			tbl->expected_tpt[index] + 64) / 128));
 
@@ -2676,6 +2681,7 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 	lq_sta->last_txrate_idx = rate_lowest_index(sband, sta);
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
+	lq_sta->is_agg = 0;
 
 	rs_initialize_lq(priv, conf, sta, lq_sta);
 }
@@ -2928,8 +2934,9 @@ static ssize_t rs_sta_dbgfs_scale_table_read(struct file *file,
 		   ((is_mimo2(tbl->lq_type)) ? "MIMO2" : "MIMO3"));
 		   desc += sprintf(buff+desc, " %s",
 		   (tbl->is_ht40) ? "40MHz" : "20MHz");
-		   desc += sprintf(buff+desc, " %s %s\n", (tbl->is_SGI) ? "SGI" : "",
-		   (lq_sta->is_green) ? "GF enabled" : "");
+		   desc += sprintf(buff+desc, " %s %s %s\n", (tbl->is_SGI) ? "SGI" : "",
+		   (lq_sta->is_green) ? "GF enabled" : "",
+		   (lq_sta->is_agg) ? "AGG on" : "");
 	}
 	desc += sprintf(buff+desc, "last tx rate=0x%X\n",
 		lq_sta->last_rate_n_flags);
-- 
1.5.6.3

