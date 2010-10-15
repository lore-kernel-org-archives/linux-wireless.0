Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:15449 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313Ab0JOQN7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 12:13:59 -0400
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id o9FGDvtW001577
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 09:13:57 -0700
Received: from glenhelen.mtv.corp.google.com (glenhelen.mtv.corp.google.com [172.22.72.223])
	by kpbe16.cbf.corp.google.com with ESMTP id o9FGDseh009274
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 09:13:55 -0700
From: Paul Stewart <pstew@google.com>
Date: Fri, 15 Oct 2010 09:08:20 -0700
Subject: [PATCH 2/2] mac80211: Add support for CQM tx bitrate monitoring
To: linux-wireless@vger.kernel.org
In-Reply-To: <1287122010.3640.2.camel@jlt3.sipsolutions.net>
Message-Id: <20101015161354.99F142006B@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add state, work proc and debugging parameters for monitoring
transmit-rate changes.

Signed-off-by: Paul Stewart <pstew@google.com>
---
 net/mac80211/cfg.c         |   15 +++++++
 net/mac80211/debugfs.c     |    4 ++
 net/mac80211/ieee80211_i.h |   23 +++++++++++
 net/mac80211/mlme.c        |    9 ++++
 net/mac80211/rate.c        |   90 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rate.h        |    8 ++++
 net/mac80211/status.c      |   13 ++++++
 7 files changed, 162 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18bd0e5..560a9f9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1498,6 +1498,20 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 	return 0;
 }
 
+static int ieee80211_set_cqm_bitrate_config(struct wiphy *wiphy,
+					    struct net_device *dev,
+					    u32 bitrate_thold)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	sdata->u.mgd.cqm_bitrate_thold = bitrate_thold;
+	sdata->u.mgd.last_cqm_bitrate = 0;
+	memset(&sdata->u.mgd.last_cqm_tx_rate, 0,
+	       sizeof(sdata->u.mgd.last_cqm_tx_rate));
+
+	return 0;
+}
+
 static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      const u8 *addr,
@@ -1672,5 +1686,6 @@ struct cfg80211_ops mac80211_config_ops = {
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.mgmt_tx = ieee80211_mgmt_tx,
 	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
+	.set_cqm_bitrate_config = ieee80211_set_cqm_bitrate_config,
 	.mgmt_frame_register = ieee80211_mgmt_frame_register,
 };
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index ebd5b69..8d021eb 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -438,6 +438,10 @@ void debugfs_hw_add(struct ieee80211_local *local)
 		local->rx_handlers_fragments);
 	DEBUGFS_STATS_ADD(tx_status_drop,
 		local->tx_status_drop);
+	DEBUGFS_STATS_ADD(tx_cqm_calculate_count,
+		local->tx_cqm_calculate_count);
+	DEBUGFS_STATS_ADD(tx_cqm_notify_count,
+		local->tx_cqm_notify_count);
 #endif
 	DEBUGFS_DEVSTATS_ADD(dot11ACKFailureCount);
 	DEBUGFS_DEVSTATS_ADD(dot11RTSFailureCount);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b80c386..80b61c9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -338,6 +338,7 @@ enum ieee80211_sta_flags {
 	IEEE80211_STA_UAPSD_ENABLED	= BIT(7),
 	IEEE80211_STA_NULLFUNC_ACKED	= BIT(8),
 	IEEE80211_STA_RESET_SIGNAL_AVE	= BIT(9),
+	IEEE80211_STA_TX_RATE_CHANGED	= BIT(10),
 };
 
 struct ieee80211_if_managed {
@@ -348,6 +349,7 @@ struct ieee80211_if_managed {
 	struct work_struct monitor_work;
 	struct work_struct chswitch_work;
 	struct work_struct beacon_connection_loss_work;
+	struct work_struct bitrate_notify_work;
 
 	unsigned long probe_timeout;
 	int probe_send_count;
@@ -406,6 +408,25 @@ struct ieee80211_if_managed {
 	 * generated for the current association.
 	 */
 	int last_cqm_event_signal;
+
+
+	/*
+	 * Connection quality monitor bitrate threshold, a zero value
+	 * implies disabled
+	 */
+	u32 cqm_bitrate_thold;
+
+	/*
+	 * Last bitrate value sent as an event to signal quality listeners.
+	 * This is a u32 in units of 1000 bits per second.
+	 */
+	u32 last_cqm_bitrate;
+
+	/*
+	 * Previous transmit rate.  Used to detect whether the transmit rate
+	 * for the previous packet is different from the one before it.
+	 */
+	struct ieee80211_tx_rate last_cqm_tx_rate;
 };
 
 struct ieee80211_if_ibss {
@@ -868,6 +889,8 @@ struct ieee80211_local {
 	unsigned int rx_expand_skb_head2;
 	unsigned int rx_handlers_fragments;
 	unsigned int tx_status_drop;
+	unsigned int tx_cqm_calculate_count;
+	unsigned int tx_cqm_notify_count;
 #define I802_DEBUG_INC(c) (c)++
 #else /* CONFIG_MAC80211_DEBUG_COUNTERS */
 #define I802_DEBUG_INC(c) do { } while (0)
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index a3a9421..6260343 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1176,6 +1176,14 @@ void ieee80211_connection_loss(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_connection_loss);
 
+static void ieee80211_rate_notify_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data,
+			     u.mgd.bitrate_notify_work);
+
+	ieee80211_cqm_bitrate_notify(sdata);
+}
 
 static enum rx_mgmt_action __must_check
 ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
@@ -2002,6 +2010,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,
 		  ieee80211_beacon_connection_loss_work);
 	INIT_WORK(&ifmgd->request_smps_work, ieee80211_request_smps_work);
+        INIT_WORK(&ifmgd->bitrate_notify_work, ieee80211_rate_notify_work);
 	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
 		    (unsigned long) sdata);
 	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 4f772de..146d2de 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -399,3 +399,93 @@ void rate_control_deinitialize(struct ieee80211_local *local)
 	rate_control_put(ref);
 }
 
+u32 ieee80211_rate_calculate(struct ieee80211_local *local,
+			     struct ieee80211_if_managed *ifmgd)
+{
+	u32 mcs, rate_h;
+	struct ieee80211_tx_rate *rate_ptr = &ifmgd->last_cqm_tx_rate;
+	struct ieee80211_supported_band *sband;
+        static const u16 mcs_rate_table[128] = {
+		65,   130,  195,  260,  390,  520,  585,  650,
+		130,  260,  390,  520,  780, 1040, 1170, 1300,
+		195,  390,  585,  780, 1170, 1560, 1755, 1950,
+		260,  520,  780, 1040, 1560, 2080, 2340, 2600,
+		135,  270,  405,  540,  810, 1080, 1215, 1350,
+		270,  540,  810, 1080, 1620, 2160, 2430, 2700,
+		405,  810, 1215, 1620, 2430, 3240, 3645, 4050,
+		540, 1080, 1620, 2160, 3240, 4320, 4860, 5400,
+		72,   144,  217,  289,  433,  578,  650,  722,
+		144,  289,  433,  578,  867, 1156, 1300, 1444,
+		217,  433,  650,  867, 1300, 1733, 1950, 2167,
+		289,  578,  867, 1156, 1733, 2311, 2600, 2889,
+		150,  300,  450,  600,  900, 1200, 1350, 1500,
+		300,  600,  900, 1200, 1800, 2400, 2700, 3000,
+		450,  900, 1350, 1800, 2700, 3600, 4050, 4500,
+		600, 1200, 1800, 2400, 3600, 4800, 5400, 6000
+	};
+
+	if (!(rate_ptr->flags & IEEE80211_TX_RC_MCS)) {
+		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		rate_h = sband->bitrates[rate_ptr->idx].bitrate;
+	} else {
+		mcs = rate_ptr->idx;
+
+		/* MCS values over 32 are not yet supported */
+		if (mcs >= 32)
+			return 0;
+
+		if (rate_ptr->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			mcs |= 1 << 5;
+
+		if (rate_ptr->flags & IEEE80211_TX_RC_SHORT_GI)
+			mcs |= 1 << 6;
+
+		rate_h = mcs_rate_table[mcs];
+	}
+
+	return rate_h * 100;
+}
+
+void ieee80211_cqm_bitrate_notify(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	u32 bitrate, threshold;
+	int prev_state, new_state;
+
+	if (!netif_running(sdata->dev) ||
+	    sdata->vif.type != NL80211_IFTYPE_STATION)
+		return;
+	
+	/*
+	 * Skip sending a notification if a the state was cleared
+	 * after the workproc was scheduled (e.g, if userspace
+	 * canceled CQM monitoring)
+	 */
+	if (!(ifmgd->flags & IEEE80211_STA_TX_RATE_CHANGED) ||
+	    ifmgd->cqm_bitrate_thold == 0)
+		return;
+
+	I802_DEBUG_INC(sdata->local->tx_cqm_calculate_count);
+
+	bitrate = ieee80211_rate_calculate(sdata->local, ifmgd);
+	threshold = ifmgd->cqm_bitrate_thold;
+	prev_state = (ifmgd->last_cqm_bitrate < threshold);
+	new_state = (bitrate < threshold);
+
+	/*
+	 * Trigger a bitrate notification if one of the following is
+	 * true:
+	 *   - We haven't sent one since the threshold was reconfigured
+	 *   - We have crossed the threshold in either direction
+	 *   - We are below threshold, and the bitrate has decreased yet
+	 *     again.
+	 */
+	if (ifmgd->last_cqm_bitrate == 0 || prev_state != new_state ||
+	    (new_state && bitrate < ifmgd->last_cqm_bitrate)) {
+		cfg80211_cqm_bitrate_notify(sdata->dev, bitrate,
+					    GFP_KERNEL);
+		ifmgd->last_cqm_bitrate = bitrate;
+		I802_DEBUG_INC(sdata->local->tx_cqm_notify_count);
+	}
+	ifmgd->flags &= ~IEEE80211_STA_TX_RATE_CHANGED;
+}
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 168427b..875c99f 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -120,6 +120,14 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 void rate_control_deinitialize(struct ieee80211_local *local);
 
 
+/* Notify listeners about transmit rate changes */
+void ieee80211_cqm_bitrate_notify(struct ieee80211_sub_if_data *sdata);
+
+/* Convert rate into cfg80211-compatible struct? */
+void ieee80211_rate_convert_cfg(struct ieee80211_local *local,
+				struct ieee80211_if_managed *ifmgd,
+				struct rate_info *rate);
+
 /* Rate control algorithms */
 #ifdef CONFIG_MAC80211_RC_PID
 extern int rc80211_pid_init(void);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 3153c19..c5ee343 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -154,6 +154,19 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 		}
 
 		ieee80211_queue_work(&local->hw, &local->recalc_smps);
+	} else if (ieee80211_is_data(mgmt->frame_control) &&
+		   sdata->vif.type == NL80211_IFTYPE_STATION) {
+		struct ieee80211_if_managed *ifmgd;
+		ifmgd = &sta->sdata->u.mgd;
+		if (ifmgd->cqm_bitrate_thold != 0 &&
+		    (memcmp(&ifmgd->last_cqm_tx_rate, &sta->last_tx_rate,
+			    sizeof(ifmgd->last_cqm_tx_rate)) != 0 ||
+		     sdata->u.mgd.last_cqm_bitrate == 0)) {
+			ifmgd->last_cqm_tx_rate = sta->last_tx_rate;
+			ifmgd->flags |= IEEE80211_STA_TX_RATE_CHANGED;
+			ieee80211_queue_work(&local->hw,
+					     &ifmgd->bitrate_notify_work);
+		}
 	}
 }
 
-- 
1.7.1

