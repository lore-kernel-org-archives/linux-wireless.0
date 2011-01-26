Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58601 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab1AZUhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 15:37:32 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC v3] mac80211:  Optimize scans on current operating channel.
Date: Wed, 26 Jan 2011 12:37:18 -0800
Message-Id: <1296074238-4012-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This should decrease un-necessary flushes, on/off channel work,
and channel changes in cases where the only scanned channel is
the current operating channel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 c47d7c0... 9508486... M	net/mac80211/ieee80211_i.h
:100644 100644 09a2744... 1e845c5... M	net/mac80211/main.c
:100644 100644 b4e5267... 0441b16... M	net/mac80211/offchannel.c
:100644 100644 f36d70f... 76b3a68... M	net/mac80211/rx.c
:100644 100644 f246d8a... b2eca7e... M	net/mac80211/scan.c
:100644 100644 36305e0... 62ffc8e... M	net/mac80211/work.c
 net/mac80211/ieee80211_i.h |   10 +++++++-
 net/mac80211/main.c        |   53 +++++++++++++++++++++++++++++++++++++++-----
 net/mac80211/offchannel.c  |   44 ++++++++----------------------------
 net/mac80211/rx.c          |   13 +++++++---
 net/mac80211/scan.c        |   43 +++++++++++++++++++++--------------
 net/mac80211/work.c        |   19 +++++++--------
 6 files changed, 110 insertions(+), 72 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..9508486 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -660,6 +660,10 @@ struct tpt_led_trigger {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_LEFT_OPER_CHANNEL:  Set this flag if the scan process leaves the
+ *      operating channel at any time.  If scanning ONLY the current operating
+ *      channel this flag should not be set, and this will allow fewer
+ *      offchannel changes.
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -667,6 +671,7 @@ enum {
 	SCAN_OFF_CHANNEL,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_LEFT_OPER_CHANNEL,
 };
 
 /**
@@ -1147,7 +1152,10 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local);
+/* Returns true if hardware is currently configured for the operating channel
+ * and if the logical configured state is to be on the operating channel.
+ */
+bool ieee80211_on_oper_channel(struct ieee80211_local *local);
 void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
 				 bool enable_beaconing);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 09a2744..1e845c5 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -98,6 +98,39 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 	ieee80211_configure_filter(local);
 }
 
+/** If we are configured to be off the operating channel,
+ * or if we are already off the operating channel, return
+ * false.
+ */
+bool ieee80211_on_oper_channel(struct ieee80211_local *local)
+{
+	struct ieee80211_channel *chan, *scan_chan;
+	enum nl80211_channel_type channel_type;
+
+	/** This logic needs to match logic in ieee80211_hw_config */
+	if (local->scan_channel) {
+		chan = local->scan_channel;
+		channel_type = NL80211_CHAN_NO_HT;
+	} else if (local->tmp_channel) {
+		chan = scan_chan = local->tmp_channel;
+		channel_type = local->tmp_channel_type;
+	} else {
+		chan = local->oper_channel;
+		channel_type = local->_oper_channel_type;
+	}
+
+	if (chan != local->oper_channel ||
+	    channel_type != local->_oper_channel_type)
+		return false;
+
+	/* Check current hardware-config against oper_channel. */
+	if ((local->oper_channel != local->hw.conf.channel) ||
+	    (local->_oper_channel_type != local->hw.conf.channel_type))
+		return false;
+
+	return true;
+}
+
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan, *scan_chan;
@@ -110,21 +143,27 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 
 	scan_chan = local->scan_channel;
 
+	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
+	 * may need to change as well.
+	 */
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (scan_chan) {
 		chan = scan_chan;
 		channel_type = NL80211_CHAN_NO_HT;
-		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
-	} else if (local->tmp_channel &&
-		   local->oper_channel != local->tmp_channel) {
+	} else if (local->tmp_channel) {
 		chan = scan_chan = local->tmp_channel;
 		channel_type = local->tmp_channel_type;
-		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	} else {
 		chan = local->oper_channel;
 		channel_type = local->_oper_channel_type;
-		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
 	}
+
+	if (chan != local->oper_channel ||
+	    channel_type != local->_oper_channel_type)
+		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
+	else
+		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
+	
 	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
 	if (offchannel_flag || chan != local->hw.conf.channel ||
@@ -183,6 +222,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 	return ret;
 }
 
+
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed)
 {
@@ -231,7 +271,8 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
-		    test_bit(SCAN_SW_SCANNING, &local->scanning)) {
+		    test_bit(SCAN_OFF_CHANNEL, &local->scanning) ||
+		    !ieee80211_on_oper_channel(local)) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
 			/*
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index b4e5267..0441b16 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -95,57 +95,33 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
+void ieee80211_offchannel_stop_station(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	/*
+	 * notify the AP about us leaving the channel and stop all STA interfaces
+	 */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		/* disable beaconing */
+		/* Check to see if we should disable beaconing. */
 		if (sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
 		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 			ieee80211_bss_info_change_notify(
 				sdata, BSS_CHANGED_BEACON_ENABLED);
 
-		/*
-		 * only handle non-STA interfaces here, STA interfaces
-		 * are handled in ieee80211_offchannel_stop_station(),
-		 * e.g., from the background scan state machine.
-		 *
-		 * In addition, do not stop monitor interface to allow it to be
-		 * used from user space controlled off-channel operations.
-		 */
-		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
-		    sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
-			netif_tx_stop_all_queues(sdata->dev);
-		}
-	}
-	mutex_unlock(&local->iflist_mtx);
-}
-
-void ieee80211_offchannel_stop_station(struct ieee80211_local *local)
-{
-	struct ieee80211_sub_if_data *sdata;
-
-	/*
-	 * notify the AP about us leaving the channel and stop all STA interfaces
-	 */
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
-			continue;
-
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
 			netif_tx_stop_all_queues(sdata->dev);
-			if (sdata->u.mgd.associated)
+			if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
+			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
 		}
+
 	}
 	mutex_unlock(&local->iflist_mtx);
 }
@@ -181,7 +157,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			netif_tx_wake_all_queues(sdata->dev);
 		}
 
-		/* re-enable beaconing */
+		/* Check to see if we should re-enable beaconing */
 		if (enable_beaconing &&
 		    (sdata->vif.type == NL80211_IFTYPE_AP ||
 		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f36d70f..76b3a68 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -388,6 +388,7 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct sk_buff *skb = rx->skb;
+	int ret;
 
 	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
 		return RX_CONTINUE;
@@ -396,10 +397,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 		return ieee80211_scan_rx(rx->sdata, skb);
 
 	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
-		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
+		ret = ieee80211_scan_rx(rx->sdata, skb);
+		/* drop all the other packets while scanning off channel */
+		if (ret != RX_QUEUED &&
+		    test_bit(SCAN_OFF_CHANNEL, &local->scanning)) {
 			dev_kfree_skb(skb);
-		return RX_QUEUED;
+			return RX_QUEUED;
+		}
+		return ret;
 	}
 
 	/* scanning finished during invoking of handlers */
@@ -2749,7 +2754,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
+		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
 	if (ieee80211_is_mgmt(fc))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f246d8a..b2eca7e 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -294,11 +294,14 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if ((local->oper_channel != local->hw.conf.channel) || was_hw_scan)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		if (test_bit(SCAN_LEFT_OPER_CHANNEL, &local->scanning))
+			ieee80211_offchannel_return(local, true);
 	}
 
 	mutex_lock(&local->mtx);
@@ -398,13 +401,10 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	drv_sw_scan_start(local);
 
-	ieee80211_offchannel_stop_beaconing(local);
-
 	local->leave_oper_channel_time = 0;
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
-
-	drv_flush(local, false);
+	__clear_bit(SCAN_LEFT_OPER_CHANNEL, &local->scanning);
 
 	ieee80211_configure_filter(local);
 
@@ -544,7 +544,18 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	if (local->scan_channel) {
+	next_chan = local->scan_req->channels[local->scan_channel_idx];
+
+	if (local->oper_channel == local->hw.conf.channel) {
+		if (next_chan == local->oper_channel)
+			local->next_scan_state = SCAN_SET_CHANNEL;
+		else
+			/*
+			 * we're on the operating channel currently, let's
+			 * leave that channel now to scan another one
+			 */
+			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+	} else {
 		/*
 		 * we're currently scanning a different channel, let's
 		 * see if we can scan another channel without interfering
@@ -560,7 +571,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 		 *
 		 * Otherwise switch back to the operating channel.
 		 */
-		next_chan = local->scan_req->channels[local->scan_channel_idx];
 
 		bad_latency = time_after(jiffies +
 				ieee80211_scan_get_channel_time(next_chan),
@@ -578,12 +588,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
 			local->next_scan_state = SCAN_SET_CHANNEL;
-	} else {
-		/*
-		 * we're on the operating channel currently, let's
-		 * leave that channel now to scan another one
-		 */
-		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	}
 
 	*next_delay = 0;
@@ -592,9 +596,12 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
+	/* This must be set before we do the stop_station logic. */
+	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
+
 	ieee80211_offchannel_stop_station(local);
 
-	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
+	__set_bit(SCAN_LEFT_OPER_CHANNEL, &local->scanning);
 
 	/*
 	 * What if the nullfunc frames didn't arrive?
@@ -641,8 +648,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
 	local->scan_channel = chan;
-	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-		skip = 1;
+
+	if (chan != local->hw.conf.channel)
+		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+			skip = 1;
 
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 36305e0..62ffc8e 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -924,18 +924,17 @@ static void ieee80211_work_work(struct work_struct *work)
 		}
 
 		if (!started && !local->tmp_channel) {
-			/*
-			 * TODO: could optimize this by leaving the
-			 *	 station vifs in awake mode if they
-			 *	 happen to be on the same channel as
-			 *	 the requested channel
-			 */
-			ieee80211_offchannel_stop_beaconing(local);
-			ieee80211_offchannel_stop_station(local);
-
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
-			ieee80211_hw_config(local, 0);
+			if (!ieee80211_on_oper_channel(local)) {
+				/*
+				 * Leave the station vifs in awake mode if they
+				 * happen to be on the same channel as
+				 * the requested channel
+				 */
+				ieee80211_offchannel_stop_station(local);
+				ieee80211_hw_config(local, 0);
+			}
 			started = true;
 			wk->timeout = jiffies;
 		}
-- 
1.7.2.3

