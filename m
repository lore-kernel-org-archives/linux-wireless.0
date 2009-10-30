Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9059 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbZJ3VgQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:36:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/15] iwl3945: store station rate scale information in mac80211 station structure
Date: Fri, 30 Oct 2009 14:36:13 -0700
Message-Id: <1256938578-9638-11-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
References: <1256938578-9638-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

Currently the rate scale information is pointed to from the mac80211
station structure but since that is the only member we might as well make
it part of the structure. Also move the rate scaling initialization to the
init function, no need to do it when we allocate the structure. This fits
with how mac80211 deals with rate scaling information (it always calls init
after allocation) and makes it easier for us to later call initialization
directly.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   99 +++++++--------------------
 drivers/net/wireless/iwlwifi/iwl-3945.h    |   35 ++++++++++-
 2 files changed, 60 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index cbb0585..819a81b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -42,38 +42,6 @@
 
 #define RS_NAME "iwl-3945-rs"
 
-struct iwl3945_rate_scale_data {
-	u64 data;
-	s32 success_counter;
-	s32 success_ratio;
-	s32 counter;
-	s32 average_tpt;
-	unsigned long stamp;
-};
-
-struct iwl3945_rs_sta {
-	spinlock_t lock;
-	struct iwl_priv *priv;
-	s32 *expected_tpt;
-	unsigned long last_partial_flush;
-	unsigned long last_flush;
-	u32 flush_time;
-	u32 last_tx_packets;
-	u32 tx_packets;
-	u8 tgg;
-	u8 flush_pending;
-	u8 start_rate;
-	u8 ibss_sta_added;
-	struct timer_list rate_scale_flush;
-	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT_3945];
-#ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *rs_sta_dbgfs_stats_table_file;
-#endif
-
-	/* used to be in sta_info */
-	int last_txrate_idx;
-};
-
 static s32 iwl3945_expected_tpt_g[IWL_RATE_COUNT_3945] = {
 	7, 13, 35, 58, 0, 0, 76, 104, 130, 168, 191, 202
 };
@@ -370,6 +338,28 @@ static void rs_rate_init(void *priv_r, struct ieee80211_supported_band *sband,
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
+	spin_lock_init(&rs_sta->lock);
+
+	rs_sta->priv = priv;
+
+	rs_sta->start_rate = IWL_RATE_INVALID;
+
+	/* default to just 802.11b */
+	rs_sta->expected_tpt = iwl3945_expected_tpt_b;
+
+	rs_sta->last_partial_flush = jiffies;
+	rs_sta->last_flush = jiffies;
+	rs_sta->flush_time = IWL_RATE_FLUSH;
+	rs_sta->last_tx_packets = 0;
+	rs_sta->ibss_sta_added = 0;
+
+	init_timer(&rs_sta->rate_scale_flush);
+	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
+	rs_sta->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
+
+	for (i = 0; i < IWL_RATE_COUNT_3945; i++)
+		iwl3945_clear_window(&rs_sta->win[i]);
+
 	/* TODO: what is a good starting rate for STA? About middle? Maybe not
 	 * the lowest or the highest rate.. Could consider using RSSI from
 	 * previous packets? Need to have IEEE 802.1X auth succeed immediately
@@ -409,45 +399,11 @@ static void *rs_alloc_sta(void *iwl_priv, struct ieee80211_sta *sta, gfp_t gfp)
 {
 	struct iwl3945_rs_sta *rs_sta;
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
-	struct iwl_priv *priv = iwl_priv;
-	int i;
-
-	/*
-	 * XXX: If it's using sta->drv_priv anyway, it might
-	 *	as well just put all the information there.
-	 */
+	struct iwl_priv *priv __maybe_unused = iwl_priv;
 
 	IWL_DEBUG_RATE(priv, "enter\n");
 
-	rs_sta = kzalloc(sizeof(struct iwl3945_rs_sta), gfp);
-	if (!rs_sta) {
-		IWL_DEBUG_RATE(priv, "leave: ENOMEM\n");
-		return NULL;
-	}
-
-	psta->rs_sta = rs_sta;
-
-	spin_lock_init(&rs_sta->lock);
-
-	rs_sta->priv = priv;
-
-	rs_sta->start_rate = IWL_RATE_INVALID;
-
-	/* default to just 802.11b */
-	rs_sta->expected_tpt = iwl3945_expected_tpt_b;
-
-	rs_sta->last_partial_flush = jiffies;
-	rs_sta->last_flush = jiffies;
-	rs_sta->flush_time = IWL_RATE_FLUSH;
-	rs_sta->last_tx_packets = 0;
-	rs_sta->ibss_sta_added = 0;
-
-	init_timer(&rs_sta->rate_scale_flush);
-	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
-	rs_sta->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
-
-	for (i = 0; i < IWL_RATE_COUNT_3945; i++)
-		iwl3945_clear_window(&rs_sta->win[i]);
+	rs_sta = &psta->rs_sta;
 
 	IWL_DEBUG_RATE(priv, "leave\n");
 
@@ -458,14 +414,11 @@ static void rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 			void *priv_sta)
 {
 	struct iwl3945_sta_priv *psta = (void *) sta->drv_priv;
-	struct iwl3945_rs_sta *rs_sta = priv_sta;
+	struct iwl3945_rs_sta *rs_sta = &psta->rs_sta;
 	struct iwl_priv *priv __maybe_unused = rs_sta->priv;
 
-	psta->rs_sta = NULL;
-
 	IWL_DEBUG_RATE(priv, "enter\n");
 	del_timer_sync(&rs_sta->rate_scale_flush);
-	kfree(rs_sta);
 	IWL_DEBUG_RATE(priv, "leave\n");
 }
 
@@ -967,7 +920,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	}
 
 	psta = (void *) sta->drv_priv;
-	rs_sta = psta->rs_sta;
+	rs_sta = &psta->rs_sta;
 
 	spin_lock_irqsave(&rs_sta->lock, flags);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index ebb999a..2b0d65c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -74,8 +74,41 @@ extern struct pci_device_id iwl3945_hw_card_ids[];
 /* Module parameters accessible from iwl-*.c */
 extern struct iwl_mod_params iwl3945_mod_params;
 
+struct iwl3945_rate_scale_data {
+	u64 data;
+	s32 success_counter;
+	s32 success_ratio;
+	s32 counter;
+	s32 average_tpt;
+	unsigned long stamp;
+};
+
+struct iwl3945_rs_sta {
+	spinlock_t lock;
+	struct iwl_priv *priv;
+	s32 *expected_tpt;
+	unsigned long last_partial_flush;
+	unsigned long last_flush;
+	u32 flush_time;
+	u32 last_tx_packets;
+	u32 tx_packets;
+	u8 tgg;
+	u8 flush_pending;
+	u8 start_rate;
+	u8 ibss_sta_added;
+	struct timer_list rate_scale_flush;
+	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT_3945];
+#ifdef CONFIG_MAC80211_DEBUGFS
+	struct dentry *rs_sta_dbgfs_stats_table_file;
+#endif
+
+	/* used to be in sta_info */
+	int last_txrate_idx;
+};
+
+
 struct iwl3945_sta_priv {
-	struct iwl3945_rs_sta *rs_sta;
+	struct iwl3945_rs_sta rs_sta;
 };
 
 enum iwl3945_antenna {
-- 
1.5.6.3

