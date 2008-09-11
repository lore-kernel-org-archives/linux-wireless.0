Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55571 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYIKBFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 21:05:14 -0400
Subject: [PATCH 22/18] mac80211: move txrate_idx into RC algorithms
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080910220145.707263000@sipsolutions.net> (sfid-20080911_001619_033062_98BAB5F3)
References: <20080910220145.707263000@sipsolutions.net>
	 (sfid-20080911_001619_033062_98BAB5F3)
Content-Type: text/plain
Date: Thu, 11 Sep 2008 03:04:36 +0200
Message-Id: <1221095076.3804.72.camel@johannes.berg> (sfid-20080911_030523_419347_9336646F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The sta_info->txrate_idx member isn't used by all RC algorithms
in the way it was intended to be used, move it into those that
require it (only PID) and keep track in the core code of which
rate was last used for reporting to userspace and the mesh MLME.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/ath9k/rc.c            |    1 
 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |   10 ++------
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c  |   13 +----------
 net/mac80211/mesh_hwmp.c                   |    2 -
 net/mac80211/rc80211_pid.h                 |    2 +
 net/mac80211/rc80211_pid_algo.c            |   33 ++++++++++++++++-------------
 net/mac80211/sta_info.h                    |    2 -
 net/mac80211/tx.c                          |    2 +
 net/mac80211/wext.c                        |    4 +--
 9 files changed, 32 insertions(+), 37 deletions(-)

--- everything.orig/net/mac80211/mesh_hwmp.c	2008-09-11 02:39:33.000000000 +0200
+++ everything/net/mac80211/mesh_hwmp.c	2008-09-11 02:39:39.000000000 +0200
@@ -223,7 +223,7 @@ static u32 airtime_link_metric_get(struc
 	/* bitrate is in units of 100 Kbps, while we need rate in units of
 	 * 1Mbps. This will be corrected on tx_time computation.
 	 */
-	rate = sband->bitrates[sta->txrate_idx].bitrate;
+	rate = sband->bitrates[sta->last_txrate_idx].bitrate;
 	tx_time = (device_constant + 10 * test_frame_len / rate);
 	estimated_retx = ((1 << (2 * ARITH_SHIFT)) / (s_unit - err));
 	result = (tx_time * estimated_retx) >> (2 * ARITH_SHIFT) ;
--- everything.orig/net/mac80211/sta_info.h	2008-09-11 02:39:18.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-09-11 02:40:07.000000000 +0200
@@ -274,7 +274,7 @@ struct sta_info {
 	unsigned long tx_packets;
 	unsigned long tx_bytes;
 	unsigned long tx_fragments;
-	int txrate_idx;
+	unsigned int last_txrate_idx;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	unsigned int wme_tx_queue[NUM_RX_DATA_QUEUES];
--- everything.orig/net/mac80211/wext.c	2008-09-11 02:39:43.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-09-11 02:39:50.000000000 +0200
@@ -636,8 +636,8 @@ static int ieee80211_ioctl_giwrate(struc
 
 	sta = sta_info_get(local, sdata->u.sta.bssid);
 
-	if (sta && sta->txrate_idx < sband->n_bitrates)
-		rate->value = sband->bitrates[sta->txrate_idx].bitrate;
+	if (sta && sta->last_txrate_idx < sband->n_bitrates)
+		rate->value = sband->bitrates[sta->last_txrate_idx].bitrate;
 	else
 		rate->value = 0;
 
--- everything.orig/net/mac80211/rc80211_pid.h	2008-09-11 02:40:21.000000000 +0200
+++ everything/net/mac80211/rc80211_pid.h	2008-09-11 02:40:38.000000000 +0200
@@ -180,6 +180,8 @@ struct rc_pid_sta_info {
 	u32 tx_num_failed;
 	u32 tx_num_xmit;
 
+	int txrate_idx;
+
 	/* Average failed frames percentage error (i.e. actual vs. target
 	 * percentage), scaled by RC_PID_SMOOTHING. This value is computed
 	 * using using an exponential weighted average technique:
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-09-11 02:40:17.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-09-11 02:45:02.000000000 +0200
@@ -75,7 +75,8 @@ static void rate_control_pid_adjust_rate
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_supported_band *sband;
 	int cur_sorted, new_sorted, probe, tmp, n_bitrates, band;
-	int cur = sta->txrate_idx;
+	struct rc_pid_sta_info *spinfo = (void *)sta->rate_ctrl_priv;
+	int cur = spinfo->txrate_idx;
 
 	sdata = sta->sdata;
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
@@ -111,7 +112,7 @@ static void rate_control_pid_adjust_rate
 	/* Fit the rate found to the nearest supported rate. */
 	do {
 		if (rate_supported(sta, band, rinfo[tmp].index)) {
-			sta->txrate_idx = rinfo[tmp].index;
+			spinfo->txrate_idx = rinfo[tmp].index;
 			break;
 		}
 		if (adj < 0)
@@ -121,9 +122,9 @@ static void rate_control_pid_adjust_rate
 	} while (tmp < n_bitrates && tmp >= 0);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	rate_control_pid_event_rate_change(
-		&((struct rc_pid_sta_info *)sta->rate_ctrl_priv)->events,
-		sta->txrate_idx, sband->bitrates[sta->txrate_idx].bitrate);
+	rate_control_pid_event_rate_change(&spinfo->events,
+		spinfo->txrate_idx,
+		sband->bitrates[spinfo->txrate_idx].bitrate);
 #endif
 }
 
@@ -190,16 +191,16 @@ static void rate_control_pid_sample(stru
 	spinfo->tx_num_failed = 0;
 
 	/* If we just switched rate, update the rate behaviour info. */
-	if (pinfo->oldrate != sta->txrate_idx) {
+	if (pinfo->oldrate != spinfo->txrate_idx) {
 
 		i = rinfo[pinfo->oldrate].rev_index;
-		j = rinfo[sta->txrate_idx].rev_index;
+		j = rinfo[spinfo->txrate_idx].rev_index;
 
 		tmp = (pf - spinfo->last_pf);
 		tmp = RC_PID_DO_ARITH_RIGHT_SHIFT(tmp, RC_PID_ARITH_SHIFT);
 
 		rinfo[j].diff = rinfo[i].diff + tmp;
-		pinfo->oldrate = sta->txrate_idx;
+		pinfo->oldrate = spinfo->txrate_idx;
 	}
 	rate_control_pid_normalize(pinfo, sband->n_bitrates);
 
@@ -252,19 +253,20 @@ static void rate_control_pid_tx_status(v
 	if (!sta)
 		goto unlock;
 
+	spinfo = sta->rate_ctrl_priv;
+
 	/* Don't update the state if we're not controlling the rate. */
 	sdata = sta->sdata;
 	if (sdata->force_unicast_rateidx > -1) {
-		sta->txrate_idx = sdata->max_ratectrl_rateidx;
+		spinfo->txrate_idx = sdata->max_ratectrl_rateidx;
 		goto unlock;
 	}
 
 	/* Ignore all frames that were sent with a different rate than the rate
 	 * we currently advise mac80211 to use. */
-	if (info->tx_rate_idx != sta->txrate_idx)
+	if (info->tx_rate_idx != spinfo->txrate_idx)
 		goto unlock;
 
-	spinfo = sta->rate_ctrl_priv;
 	spinfo->tx_num_xmit++;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
@@ -301,6 +303,7 @@ static void rate_control_pid_get_rate(vo
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_sub_if_data *sdata;
+	struct rc_pid_sta_info *spinfo;
 	struct sta_info *sta;
 	int rateidx;
 	u16 fc;
@@ -321,10 +324,11 @@ static void rate_control_pid_get_rate(vo
 
 	/* If a forced rate is in effect, select it. */
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	spinfo = (struct rc_pid_sta_info *)sta->rate_ctrl_priv;
 	if (sdata->force_unicast_rateidx > -1)
-		sta->txrate_idx = sdata->force_unicast_rateidx;
+		spinfo->txrate_idx = sdata->force_unicast_rateidx;
 
-	rateidx = sta->txrate_idx;
+	rateidx = spinfo->txrate_idx;
 
 	if (rateidx >= sband->n_bitrates)
 		rateidx = sband->n_bitrates - 1;
@@ -349,9 +353,10 @@ static void rate_control_pid_rate_init(v
 	 * Until that method is implemented, we will use the lowest supported
 	 * rate as a workaround. */
 	struct ieee80211_supported_band *sband;
+	struct rc_pid_sta_info *spinfo = (void *)sta->rate_ctrl_priv;
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	sta->txrate_idx = rate_lowest_index(local, sband, sta);
+	spinfo->txrate_idx = rate_lowest_index(local, sband, sta);
 	sta->fail_avg = 0;
 }
 
--- everything.orig/drivers/net/wireless/ath9k/rc.c	2008-09-11 02:45:29.000000000 +0200
+++ everything/drivers/net/wireless/ath9k/rc.c	2008-09-11 02:45:46.000000000 +0200
@@ -2039,7 +2039,6 @@ static void ath_rate_init(void *priv, vo
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
-	sta->txrate_idx = rate_lowest_index(local, sband, sta);
 
 	ath_setup_rates(local, sta);
 	if (conf->flags & IEEE80211_CONF_SUPPORT_HT_MODE) {
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-11 02:45:55.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-09-11 02:46:49.000000000 +0200
@@ -334,13 +334,11 @@ static void rs_rate_init(void *priv_rate
 
 	for (i = IWL_RATE_COUNT - 1; i >= 0; i--) {
 		if (sta->sta.supp_rates[local->hw.conf.channel->band] & (1 << i)) {
-			sta->txrate_idx = i;
+			rs_sta->last_txrate_idx = i;
 			break;
 		}
 	}
 
-	rs_sta->last_txrate_idx = sta->txrate_idx;
-
 	/* For 5 GHz band it start at IWL_FIRST_OFDM_RATE */
 	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
 		rs_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
@@ -809,15 +807,13 @@ static void rs_get_rate(void *priv_rate,
 
 	rs_sta->last_txrate_idx = index;
 	if (sband->band == IEEE80211_BAND_5GHZ)
-		sta->txrate_idx = rs_sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
+		sel->rate_idx = rs_sta->last_txrate_idx - IWL_FIRST_OFDM_RATE;
 	else
-		sta->txrate_idx = rs_sta->last_txrate_idx;
+		sel->rate_idx = rs_sta->last_txrate_idx;
 
 	rcu_read_unlock();
 
 	IWL_DEBUG_RATE("leave: %d\n", index);
-
-	sel->rate_idx = sta->txrate_idx;
 }
 
 static struct rate_control_ops rs_ops = {
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 02:45:55.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn-rs.c	2008-09-11 03:03:18.000000000 +0200
@@ -2064,14 +2064,6 @@ out:
 	i = index;
 	lq_sta->last_txrate_idx = i;
 
-	/* sta->txrate_idx is an index to A mode rates which start
-	 * at IWL_FIRST_OFDM_RATE
-	 */
-	if (lq_sta->band == IEEE80211_BAND_5GHZ)
-		sta->txrate_idx = i - IWL_FIRST_OFDM_RATE;
-	else
-		sta->txrate_idx = i;
-
 	return;
 }
 
@@ -2234,7 +2226,6 @@ static void rs_rate_init(void *priv_rate
 
 	lq_sta->flush_timer = 0;
 	lq_sta->supp_rates = sta->sta.supp_rates[sband->band];
-	sta->txrate_idx = 3;
 	for (j = 0; j < LQ_SIZE; j++)
 		for (i = 0; i < IWL_RATE_COUNT; i++)
 			rs_rate_scale_clear_window(&lq_sta->lq_info[j].win[i]);
@@ -2269,11 +2260,11 @@ static void rs_rate_init(void *priv_rate
 	}
 
 	/* Find highest tx rate supported by hardware and destination station */
+	lq_sta->last_txrate_idx = 3;
 	for (i = 0; i < sband->n_bitrates; i++)
 		if (sta->sta.supp_rates[sband->band] & BIT(i))
-			sta->txrate_idx = i;
+			lq_sta->last_txrate_idx = i;
 
-	lq_sta->last_txrate_idx = sta->txrate_idx;
 	/* For MODE_IEEE80211A, skip over cck rates in global rate table */
 	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
 		lq_sta->last_txrate_idx += IWL_FIRST_OFDM_RATE;
--- everything.orig/net/mac80211/tx.c	2008-09-11 02:56:05.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-11 02:56:11.000000000 +0200
@@ -485,6 +485,8 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 
 	if (likely(tx->rate_idx < 0)) {
 		rate_control_get_rate(tx->dev, sband, tx->skb, &rsel);
+		if (tx->sta)
+			tx->sta->last_txrate_idx = rsel.rate_idx;
 		tx->rate_idx = rsel.rate_idx;
 		if (unlikely(rsel.probe_idx >= 0)) {
 			info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;


