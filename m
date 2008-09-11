Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48362 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYIKAXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:23:35 -0400
Subject: [PATCH 20/18] mac80211: move last_txrate_idx into RC algorithms
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 02:22:58 +0200
Message-Id: <1221092578.3804.66.camel@johannes.berg> (sfid-20080911_022339_112521_23CB86B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable in sta_info is only used in a meaningful way
by the Intel RC algorithms, so move it into those.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   20 ++++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   15 +++++++++------
 net/mac80211/rc80211_pid_algo.c            |    2 --
 net/mac80211/sta_info.h                    |    2 --
 4 files changed, 21 insertions(+), 18 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 02:15:29.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 02:19:12.000000000 +0200
@@ -163,6 +163,9 @@ struct iwl_lq_sta {
 	u32 dbg_fixed_rate;
 #endif
 	struct iwl_priv *drv;
+
+	/* used to be in sta_info */
+	int last_txrate_idx;
 };
 
 static void rs_rate_scale_perform(struct iwl_priv *priv,
@@ -1746,7 +1749,7 @@ static void rs_rate_scale_perform(struct
 	is_green = lq_sta->is_green;
 
 	/* current tx rate */
-	index = sta->last_txrate_idx;
+	index = lq_sta->last_txrate_idx;
 
 	IWL_DEBUG_RATE("Rate scale index %d for type %d\n", index,
 		       tbl->lq_type);
@@ -2059,7 +2062,7 @@ lq_update:
 out:
 	tbl->current_rate = rate_n_flags_from_tbl(tbl, index, is_green);
 	i = index;
-	sta->last_txrate_idx = i;
+	lq_sta->last_txrate_idx = i;
 
 	/* sta->txrate_idx is an index to A mode rates which start
 	 * at IWL_FIRST_OFDM_RATE
@@ -2090,7 +2093,7 @@ static void rs_initialize_lq(struct iwl_
 		goto out;
 
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
-	i = sta->last_txrate_idx;
+	i = lq_sta->last_txrate_idx;
 
 	if ((lq_sta->lq.sta_id == 0xff) &&
 	    (priv->iw_mode == NL80211_IFTYPE_ADHOC))
@@ -2161,7 +2164,7 @@ static void rs_get_rate(void *priv_rate,
 	}
 
 	lq_sta = (struct iwl_lq_sta *)sta->rate_ctrl_priv;
-	i = sta->last_txrate_idx;
+	i = lq_sta->last_txrate_idx;
 
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !lq_sta->ibss_sta_added) {
@@ -2270,10 +2273,10 @@ static void rs_rate_init(void *priv_rate
 		if (sta->supp_rates[sband->band] & BIT(i))
 			sta->txrate_idx = i;
 
-	sta->last_txrate_idx = sta->txrate_idx;
+	lq_sta->last_txrate_idx = sta->txrate_idx;
 	/* For MODE_IEEE80211A, skip over cck rates in global rate table */
 	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
-		sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
+		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	lq_sta->is_dup = 0;
 	lq_sta->is_green = rs_use_green(priv, conf);
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-09-11 02:19:12.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-09-11 02:19:12.000000000 +0200
@@ -329,8 +329,6 @@ static void rate_control_pid_get_rate(vo
 	if (rateidx >= sband->n_bitrates)
 		rateidx = sband->n_bitrates - 1;
 
-	sta->last_txrate_idx = rateidx;
-
 	rcu_read_unlock();
 
 	sel->rate_idx = rateidx;
--- everything.orig/net/mac80211/sta_info.h	2008-09-11 02:19:12.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-11 02:19:12.000000000 +0200
@@ -200,7 +200,6 @@ struct sta_ampdu_mlme {
  * @tx_bytes: TBD
  * @tx_fragments: number of transmitted MPDUs
  * @txrate_idx: TBD
- * @last_txrate_idx: TBD
  * @tid_seq: TBD
  * @wme_tx_queue: TBD
  * @ampdu_mlme: TBD
@@ -278,7 +277,6 @@ struct sta_info {
 	unsigned long tx_bytes;
 	unsigned long tx_fragments;
 	int txrate_idx;
-	int last_txrate_idx;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-11 02:15:08.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-11 02:19:12.000000000 +0200
@@ -65,6 +65,9 @@ struct iwl3945_rs_sta {
 	u8 ibss_sta_added;
 	struct timer_list rate_scale_flush;
 	struct iwl3945_rate_scale_data win[IWL_RATE_COUNT];
+
+	/* used to be in sta_info */
+	int last_txrate_idx;
 };
 
 static s32 iwl3945_expected_tpt_g[IWL_RATE_COUNT] = {
@@ -319,6 +322,7 @@ static void iwl3945_collect_tx_data(stru
 static void rs_rate_init(void *priv_rate, void *priv_sta,
 			 struct ieee80211_local *local, struct sta_info *sta)
 {
+	struct iwl3945_rs_sta *rs_sta = (void *)sta->rate_ctrl_priv;
 	int i;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -335,11 +339,11 @@ static void rs_rate_init(void *priv_rate
 		}
 	}
 
-	sta->last_txrate_idx = sta->txrate_idx;
+	rs_sta->last_txrate_idx = sta->txrate_idx;
 
 	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
 	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
-		sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
+		rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
 
 	IWL_DEBUG_RATE("leave\n");
 }
@@ -674,14 +678,14 @@ static void rs_get_rate(void *priv_rate,
 		return;
 	}
 
+	rs_sta = (void *)sta->rate_ctrl_priv;
+
 	rate_mask = sta->supp_rates[sband->band];
-	index = min(sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
+	index = min(rs_sta->last_txrate_idx & 0xffff, IWL_RATE_COUNT - 1);
 
 	if (sband->band == IEEE80211_BAND_5GHZ)
 		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
 
-	rs_sta = (void *)sta->rate_ctrl_priv;
-
 	if ((priv->iw_mode == NL80211_IFTYPE_ADHOC) &&
 	    !rs_sta->ibss_sta_added) {
 		u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
@@ -803,11 +807,11 @@ static void rs_get_rate(void *priv_rate,
 
  out:
 
-	sta->last_txrate_idx = index;
+	rs_sta->last_txrate_idx = index;
 	if (sband->band == IEEE80211_BAND_5GHZ)
-		sta->txrate_idx = sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
+		sta->txrate_idx = rs_sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
 	else
-		sta->txrate_idx = sta->last_txrate_idx;
+		sta->txrate_idx = rs_sta->last_txrate_idx;
 
 	rcu_read_unlock();
 


