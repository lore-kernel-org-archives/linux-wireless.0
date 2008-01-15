Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50375 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324AbYAOC1A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2008 21:27:00 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 09/12] iwlwifi: 3954 renames iwl3945_rate_scale_priv to iwl3945_rs_sta
Date: Mon, 14 Jan 2008 17:46:22 -0800
Message-Id: <1200361585-31801-10-git-send-email-reinette.chatre@intel.com> (sfid-20080115_022718_587872_96037101)
In-Reply-To: <1200361585-31801-9-git-send-email-reinette.chatre@intel.com>
References: <1200361585-31801-1-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-2-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-3-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-4-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-5-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-6-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-7-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-8-git-send-email-reinette.chatre@intel.com>
 <1200361585-31801-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch renames iwl3945_rate_scale_priv to iwl3945_rs_sta as it
better represents the purpose of this variable.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |  204 ++++++++++++++--------------
 1 files changed, 103 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
index 4b475e9..80d31ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-rs.c
@@ -52,7 +52,7 @@ struct iwl3945_rate_scale_data {
 	unsigned long stamp;
 };
 
-struct iwl3945_rate_scale_priv {
+struct iwl3945_rs_sta {
 	spinlock_t lock;
 	s32 *expected_tpt;
 	unsigned long last_partial_flush;
@@ -181,7 +181,7 @@ static void iwl3945_clear_window(struct iwl3945_rate_scale_data *window)
  * not flushed.  If there were any that were not flushed, then
  * reschedule the rate flushing routine.
  */
-static int iwl3945_rate_scale_flush_windows(struct iwl3945_rate_scale_priv *rs_priv)
+static int iwl3945_rate_scale_flush_windows(struct iwl3945_rs_sta *rs_sta)
 {
 	int unflushed = 0;
 	int i;
@@ -193,19 +193,19 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rate_scale_priv *rs_p
 	 * since we flushed, clear out the gathered statistics
 	 */
 	for (i = 0; i < IWL_RATE_COUNT; i++) {
-		if (!rs_priv->win[i].counter)
+		if (!rs_sta->win[i].counter)
 			continue;
 
-		spin_lock_irqsave(&rs_priv->lock, flags);
-		if (time_after(jiffies, rs_priv->win[i].stamp +
+		spin_lock_irqsave(&rs_sta->lock, flags);
+		if (time_after(jiffies, rs_sta->win[i].stamp +
 			       IWL_RATE_WIN_FLUSH)) {
 			IWL_DEBUG_RATE("flushing %d samples of rate "
 				       "index %d\n",
-				       rs_priv->win[i].counter, i);
-			iwl3945_clear_window(&rs_priv->win[i]);
+				       rs_sta->win[i].counter, i);
+			iwl3945_clear_window(&rs_sta->win[i]);
 		} else
 			unflushed++;
-		spin_unlock_irqrestore(&rs_priv->lock, flags);
+		spin_unlock_irqrestore(&rs_sta->lock, flags);
 	}
 
 	return unflushed;
@@ -216,28 +216,28 @@ static int iwl3945_rate_scale_flush_windows(struct iwl3945_rate_scale_priv *rs_p
 
 static void iwl3945_bg_rate_scale_flush(unsigned long data)
 {
-	struct iwl3945_rate_scale_priv *rs_priv = (void *)data;
+	struct iwl3945_rs_sta *rs_sta = (void *)data;
 	int unflushed = 0;
 	unsigned long flags;
 	u32 packet_count, duration, pps;
 
 	IWL_DEBUG_RATE("enter\n");
 
-	unflushed = iwl3945_rate_scale_flush_windows(rs_priv);
+	unflushed = iwl3945_rate_scale_flush_windows(rs_sta);
 
-	spin_lock_irqsave(&rs_priv->lock, flags);
+	spin_lock_irqsave(&rs_sta->lock, flags);
 
-	rs_priv->flush_pending = 0;
+	rs_sta->flush_pending = 0;
 
 	/* Number of packets Rx'd since last time this timer ran */
-	packet_count = (rs_priv->tx_packets - rs_priv->last_tx_packets) + 1;
+	packet_count = (rs_sta->tx_packets - rs_sta->last_tx_packets) + 1;
 
-	rs_priv->last_tx_packets = rs_priv->tx_packets + 1;
+	rs_sta->last_tx_packets = rs_sta->tx_packets + 1;
 
 	if (unflushed) {
 		duration =
-		    jiffies_to_msecs(jiffies - rs_priv->last_partial_flush);
-/*              duration = jiffies_to_msecs(rs_priv->flush_time); */
+		    jiffies_to_msecs(jiffies - rs_sta->last_partial_flush);
+/*              duration = jiffies_to_msecs(rs_sta->flush_time); */
 
 		IWL_DEBUG_RATE("Tx'd %d packets in %dms\n",
 			       packet_count, duration);
@@ -255,23 +255,23 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
 		} else
 			duration = IWL_RATE_FLUSH_MAX;
 
-		rs_priv->flush_time = msecs_to_jiffies(duration);
+		rs_sta->flush_time = msecs_to_jiffies(duration);
 
 		IWL_DEBUG_RATE("new flush period: %d msec ave %d\n",
 			       duration, packet_count);
 
-		mod_timer(&rs_priv->rate_scale_flush, jiffies +
-			  rs_priv->flush_time);
+		mod_timer(&rs_sta->rate_scale_flush, jiffies +
+			  rs_sta->flush_time);
 
-		rs_priv->last_partial_flush = jiffies;
+		rs_sta->last_partial_flush = jiffies;
 	}
 
 	/* If there weren't any unflushed entries, we don't schedule the timer
 	 * to run again */
 
-	rs_priv->last_flush = jiffies;
+	rs_sta->last_flush = jiffies;
 
-	spin_unlock_irqrestore(&rs_priv->lock, flags);
+	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 	IWL_DEBUG_RATE("leave\n");
 }
@@ -283,7 +283,7 @@ static void iwl3945_bg_rate_scale_flush(unsigned long data)
  * at this rate.  window->data contains the bitmask of successful
  * packets.
  */
-static void iwl3945_collect_tx_data(struct iwl3945_rate_scale_priv *rs_priv,
+static void iwl3945_collect_tx_data(struct iwl3945_rs_sta *rs_sta,
 				struct iwl3945_rate_scale_data *window,
 				int success, int retries)
 {
@@ -295,7 +295,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rate_scale_priv *rs_priv,
 	}
 
 	while (retries--) {
-		spin_lock_irqsave(&rs_priv->lock, flags);
+		spin_lock_irqsave(&rs_sta->lock, flags);
 
 		/* If we have filled up the window then subtract one from the
 		 * success counter if the high-bit is counting toward
@@ -323,7 +323,7 @@ static void iwl3945_collect_tx_data(struct iwl3945_rate_scale_priv *rs_priv,
 		/* Tag this window as having been updated */
 		window->stamp = jiffies;
 
-		spin_unlock_irqrestore(&rs_priv->lock, flags);
+		spin_unlock_irqrestore(&rs_sta->lock, flags);
 	}
 }
 
@@ -373,49 +373,49 @@ static void rs_clear(void *priv)
 
 static void *rs_alloc_sta(void *priv, gfp_t gfp)
 {
-	struct iwl3945_rate_scale_priv *rs_priv;
+	struct iwl3945_rs_sta *rs_sta;
 	int i;
 
 	IWL_DEBUG_RATE("enter\n");
 
-	rs_priv = kzalloc(sizeof(struct iwl3945_rate_scale_priv), gfp);
-	if (!rs_priv) {
+	rs_sta = kzalloc(sizeof(struct iwl3945_rs_sta), gfp);
+	if (!rs_sta) {
 		IWL_DEBUG_RATE("leave: ENOMEM\n");
 		return NULL;
 	}
 
-	spin_lock_init(&rs_priv->lock);
+	spin_lock_init(&rs_sta->lock);
 
-	rs_priv->start_rate = IWL_RATE_INVALID;
+	rs_sta->start_rate = IWL_RATE_INVALID;
 
 	/* default to just 802.11b */
-	rs_priv->expected_tpt = iwl3945_expected_tpt_b;
+	rs_sta->expected_tpt = iwl3945_expected_tpt_b;
 
-	rs_priv->last_partial_flush = jiffies;
-	rs_priv->last_flush = jiffies;
-	rs_priv->flush_time = IWL_RATE_FLUSH;
-	rs_priv->last_tx_packets = 0;
-	rs_priv->ibss_sta_added = 0;
+	rs_sta->last_partial_flush = jiffies;
+	rs_sta->last_flush = jiffies;
+	rs_sta->flush_time = IWL_RATE_FLUSH;
+	rs_sta->last_tx_packets = 0;
+	rs_sta->ibss_sta_added = 0;
 
-	init_timer(&rs_priv->rate_scale_flush);
-	rs_priv->rate_scale_flush.data = (unsigned long)rs_priv;
-	rs_priv->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
+	init_timer(&rs_sta->rate_scale_flush);
+	rs_sta->rate_scale_flush.data = (unsigned long)rs_sta;
+	rs_sta->rate_scale_flush.function = &iwl3945_bg_rate_scale_flush;
 
 	for (i = 0; i < IWL_RATE_COUNT; i++)
-		iwl3945_clear_window(&rs_priv->win[i]);
+		iwl3945_clear_window(&rs_sta->win[i]);
 
 	IWL_DEBUG_RATE("leave\n");
 
-	return rs_priv;
+	return rs_sta;
 }
 
 static void rs_free_sta(void *priv, void *priv_sta)
 {
-	struct iwl3945_rate_scale_priv *rs_priv = priv_sta;
+	struct iwl3945_rs_sta *rs_sta = priv_sta;
 
 	IWL_DEBUG_RATE("enter\n");
-	del_timer_sync(&rs_priv->rate_scale_flush);
-	kfree(rs_priv);
+	del_timer_sync(&rs_sta->rate_scale_flush);
+	kfree(rs_sta);
 	IWL_DEBUG_RATE("leave\n");
 }
 
@@ -464,7 +464,7 @@ static void rs_tx_status(void *priv_rate,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct iwl3945_priv *priv = (struct iwl3945_priv *)priv_rate;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct iwl3945_rate_scale_priv *rs_priv;
+	struct iwl3945_rs_sta *rs_sta;
 
 	IWL_DEBUG_RATE("enter\n");
 
@@ -485,9 +485,9 @@ static void rs_tx_status(void *priv_rate,
 		return;
 	}
 
-	rs_priv = (void *)sta->rate_ctrl_priv;
+	rs_sta = (void *)sta->rate_ctrl_priv;
 
-	rs_priv->tx_packets++;
+	rs_sta->tx_packets++;
 
 	scale_rate_index = first_index;
 	last_index = first_index;
@@ -514,8 +514,8 @@ static void rs_tx_status(void *priv_rate,
 
 		/* Update this rate accounting for as many retries
 		 * as was used for it (per current_count) */
-		iwl3945_collect_tx_data(rs_priv,
-				    &rs_priv->win[scale_rate_index],
+		iwl3945_collect_tx_data(rs_sta,
+				    &rs_sta->win[scale_rate_index],
 				    0, current_count);
 		IWL_DEBUG_RATE("Update rate %d for %d retries.\n",
 			       scale_rate_index, current_count);
@@ -533,25 +533,25 @@ static void rs_tx_status(void *priv_rate,
 		       last_index,
 		       (tx_resp->flags & IEEE80211_TX_STATUS_ACK) ?
 		       "success" : "failure");
-	iwl3945_collect_tx_data(rs_priv,
-			    &rs_priv->win[last_index],
+	iwl3945_collect_tx_data(rs_sta,
+			    &rs_sta->win[last_index],
 			    tx_resp->flags & IEEE80211_TX_STATUS_ACK, 1);
 
 	/* We updated the rate scale window -- if its been more than
 	 * flush_time since the last run, schedule the flush
 	 * again */
-	spin_lock_irqsave(&rs_priv->lock, flags);
+	spin_lock_irqsave(&rs_sta->lock, flags);
 
-	if (!rs_priv->flush_pending &&
-	    time_after(jiffies, rs_priv->last_partial_flush +
-		       rs_priv->flush_time)) {
+	if (!rs_sta->flush_pending &&
+	    time_after(jiffies, rs_sta->last_partial_flush +
+		       rs_sta->flush_time)) {
 
-		rs_priv->flush_pending = 1;
-		mod_timer(&rs_priv->rate_scale_flush,
-			  jiffies + rs_priv->flush_time);
+		rs_sta->flush_pending = 1;
+		mod_timer(&rs_sta->rate_scale_flush,
+			  jiffies + rs_sta->flush_time);
 	}
 
-	spin_unlock_irqrestore(&rs_priv->lock, flags);
+	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 	sta_info_put(sta);
 
@@ -560,7 +560,7 @@ static void rs_tx_status(void *priv_rate,
 	return;
 }
 
-static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
+static u16 iwl3945_get_adjacent_rate(struct iwl3945_rs_sta *rs_sta,
 				 u8 index, u16 rate_mask, int phymode)
 {
 	u8 high = IWL_RATE_INVALID;
@@ -595,7 +595,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
 
 	low = index;
 	while (low != IWL_RATE_INVALID) {
-		if (rs_priv->tgg)
+		if (rs_sta->tgg)
 			low = iwl3945_rates[low].prev_rs_tgg;
 		else
 			low = iwl3945_rates[low].prev_rs;
@@ -608,7 +608,7 @@ static u16 iwl3945_get_adjacent_rate(struct iwl3945_rate_scale_priv *rs_priv,
 
 	high = index;
 	while (high != IWL_RATE_INVALID) {
-		if (rs_priv->tgg)
+		if (rs_sta->tgg)
 			high = iwl3945_rates[high].next_rs_tgg;
 		else
 			high = iwl3945_rates[high].next_rs;
@@ -646,7 +646,7 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	u8 high = IWL_RATE_INVALID;
 	u16 high_low;
 	int index;
-	struct iwl3945_rate_scale_priv *rs_priv;
+	struct iwl3945_rs_sta *rs_sta;
 	struct iwl3945_rate_scale_data *window = NULL;
 	int current_tpt = IWL_INVALID_VALUE;
 	int low_tpt = IWL_INVALID_VALUE;
@@ -684,10 +684,10 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 	if (priv->phymode == (u8) MODE_IEEE80211A)
 		rate_mask = rate_mask << IWL_FIRST_OFDM_RATE;
 
-	rs_priv = (void *)sta->rate_ctrl_priv;
+	rs_sta = (void *)sta->rate_ctrl_priv;
 
 	if ((priv->iw_mode == IEEE80211_IF_TYPE_IBSS) &&
-	    !rs_priv->ibss_sta_added) {
+	    !rs_sta->ibss_sta_added) {
 		u8 sta_id = iwl3945_hw_find_station(priv, hdr->addr1);
 
 		if (sta_id == IWL_INVALID_STATION) {
@@ -697,24 +697,24 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 				    hdr->addr1, 0, CMD_ASYNC);
 		}
 		if (sta_id != IWL_INVALID_STATION)
-			rs_priv->ibss_sta_added = 1;
+			rs_sta->ibss_sta_added = 1;
 	}
 
-	spin_lock_irqsave(&rs_priv->lock, flags);
+	spin_lock_irqsave(&rs_sta->lock, flags);
 
-	if (rs_priv->start_rate != IWL_RATE_INVALID) {
-		index = rs_priv->start_rate;
-		rs_priv->start_rate = IWL_RATE_INVALID;
+	if (rs_sta->start_rate != IWL_RATE_INVALID) {
+		index = rs_sta->start_rate;
+		rs_sta->start_rate = IWL_RATE_INVALID;
 	}
 
-	window = &(rs_priv->win[index]);
+	window = &(rs_sta->win[index]);
 
 	fail_count = window->counter - window->success_counter;
 
 	if (((fail_count <= IWL_RATE_MIN_FAILURE_TH) &&
 	     (window->success_counter < IWL_RATE_MIN_SUCCESS_TH))) {
 		window->average_tpt = IWL_INVALID_VALUE;
-		spin_unlock_irqrestore(&rs_priv->lock, flags);
+		spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 		IWL_DEBUG_RATE("Invalid average_tpt on rate %d: "
 			       "counter: %d, success_counter: %d, "
@@ -722,27 +722,27 @@ static void rs_get_rate(void *priv_rate, struct net_device *dev,
 			       index,
 			       window->counter,
 			       window->success_counter,
-			       rs_priv->expected_tpt ? "not " : "");
+			       rs_sta->expected_tpt ? "not " : "");
 		goto out;
 
 	}
 
 	window->average_tpt = ((window->success_ratio *
-				rs_priv->expected_tpt[index] + 64) / 128);
+				rs_sta->expected_tpt[index] + 64) / 128);
 	current_tpt = window->average_tpt;
 
-	high_low = iwl3945_get_adjacent_rate(rs_priv, index, rate_mask,
+	high_low = iwl3945_get_adjacent_rate(rs_sta, index, rate_mask,
 					 local->hw.conf.phymode);
 	low = high_low & 0xff;
 	high = (high_low >> 8) & 0xff;
 
 	if (low != IWL_RATE_INVALID)
-		low_tpt = rs_priv->win[low].average_tpt;
+		low_tpt = rs_sta->win[low].average_tpt;
 
 	if (high != IWL_RATE_INVALID)
-		high_tpt = rs_priv->win[high].average_tpt;
+		high_tpt = rs_sta->win[high].average_tpt;
 
-	spin_unlock_irqrestore(&rs_priv->lock, flags);
+	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 	scale_action = 1;
 
@@ -840,7 +840,7 @@ int iwl3945_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct iwl3945_priv *priv = hw->priv;
-	struct iwl3945_rate_scale_priv *rs_priv;
+	struct iwl3945_rs_sta *rs_sta;
 	struct sta_info *sta;
 	unsigned long flags;
 	int count = 0, i;
@@ -858,8 +858,8 @@ int iwl3945_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 		return sprintf(buf, "station %d not found\n", sta_id);
 	}
 
-	rs_priv = (void *)sta->rate_ctrl_priv;
-	spin_lock_irqsave(&rs_priv->lock, flags);
+	rs_sta = (void *)sta->rate_ctrl_priv;
+	spin_lock_irqsave(&rs_sta->lock, flags);
 	i = IWL_RATE_54M_INDEX;
 	while (1) {
 		u64 mask;
@@ -871,15 +871,16 @@ int iwl3945_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 		mask = (1ULL << (IWL_RATE_MAX_WINDOW - 1));
 		for (j = 0; j < IWL_RATE_MAX_WINDOW; j++, mask >>= 1)
 			buf[count++] =
-			    (rs_priv->win[i].data & mask) ? '1' : '0';
+			    (rs_sta->win[i].data & mask) ? '1' : '0';
 
-		samples += rs_priv->win[i].counter;
-		good += rs_priv->win[i].success_counter;
-		success += rs_priv->win[i].success_counter * iwl3945_rates[i].ieee;
+		samples += rs_sta->win[i].counter;
+		good += rs_sta->win[i].success_counter;
+		success += rs_sta->win[i].success_counter *
+						iwl3945_rates[i].ieee;
 
-		if (rs_priv->win[i].stamp) {
+		if (rs_sta->win[i].stamp) {
 			int delta =
-			    jiffies_to_msecs(now - rs_priv->win[i].stamp);
+			    jiffies_to_msecs(now - rs_sta->win[i].stamp);
 
 			if (delta > max_time)
 				max_time = delta;
@@ -893,7 +894,7 @@ int iwl3945_fill_rs_info(struct ieee80211_hw *hw, char *buf, u8 sta_id)
 			break;
 		i = j;
 	}
-	spin_unlock_irqrestore(&rs_priv->lock, flags);
+	spin_unlock_irqrestore(&rs_sta->lock, flags);
 	sta_info_put(sta);
 
 	/* Display the average rate of all samples taken.
@@ -919,7 +920,7 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 	s32 rssi = 0;
 	unsigned long flags;
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct iwl3945_rate_scale_priv *rs_priv;
+	struct iwl3945_rs_sta *rs_sta;
 	struct sta_info *sta;
 
 	IWL_DEBUG_RATE("enter\n");
@@ -939,33 +940,33 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 		return;
 	}
 
-	rs_priv = (void *)sta->rate_ctrl_priv;
+	rs_sta = (void *)sta->rate_ctrl_priv;
 
-	spin_lock_irqsave(&rs_priv->lock, flags);
+	spin_lock_irqsave(&rs_sta->lock, flags);
 
-	rs_priv->tgg = 0;
+	rs_sta->tgg = 0;
 	switch (priv->phymode) {
 	case MODE_IEEE80211G:
 		if (priv->active_rxon.flags & RXON_FLG_TGG_PROTECT_MSK) {
-			rs_priv->tgg = 1;
-			rs_priv->expected_tpt = iwl3945_expected_tpt_g_prot;
+			rs_sta->tgg = 1;
+			rs_sta->expected_tpt = iwl3945_expected_tpt_g_prot;
 		} else
-			rs_priv->expected_tpt = iwl3945_expected_tpt_g;
+			rs_sta->expected_tpt = iwl3945_expected_tpt_g;
 		break;
 
 	case MODE_IEEE80211A:
-		rs_priv->expected_tpt = iwl3945_expected_tpt_a;
+		rs_sta->expected_tpt = iwl3945_expected_tpt_a;
 		break;
 
 	default:
 		IWL_WARNING("Invalid phymode.  Defaulting to 802.11b\n");
 	case MODE_IEEE80211B:
-		rs_priv->expected_tpt = iwl3945_expected_tpt_b;
+		rs_sta->expected_tpt = iwl3945_expected_tpt_b;
 		break;
 	}
 
 	sta_info_put(sta);
-	spin_unlock_irqrestore(&rs_priv->lock, flags);
+	spin_unlock_irqrestore(&rs_sta->lock, flags);
 
 	rssi = priv->last_rx_rssi;
 	if (rssi == 0)
@@ -973,11 +974,12 @@ void iwl3945_rate_scale_init(struct ieee80211_hw *hw, s32 sta_id)
 
 	IWL_DEBUG(IWL_DL_INFO | IWL_DL_RATE, "Network RSSI: %d\n", rssi);
 
-	rs_priv->start_rate = iwl3945_get_rate_index_by_rssi(rssi, priv->phymode);
+	rs_sta->start_rate =
+			iwl3945_get_rate_index_by_rssi(rssi, priv->phymode);
 
 	IWL_DEBUG_RATE("leave: rssi %d assign rate index: "
-		       "%d (plcp 0x%x)\n", rssi, rs_priv->start_rate,
-		       iwl3945_rates[rs_priv->start_rate].plcp);
+		       "%d (plcp 0x%x)\n", rssi, rs_sta->start_rate,
+		       iwl3945_rates[rs_sta->start_rate].plcp);
 }
 
 void iwl3945_rate_control_register(struct ieee80211_hw *hw)
-- 
1.5.3.4

