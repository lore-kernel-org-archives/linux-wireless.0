Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50137 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1AaTad (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 14:30:33 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v7] mac80211: Optimize scans on current operating channel.
Date: Mon, 31 Jan 2011 11:30:28 -0800
Message-Id: <1296502228-32595-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This should decrease un-necessary flushes, on/off channel work,
and channel changes in cases where the only scanned channel is
the current operating channel.

* Removes SCAN_OFF_CHANNEL flag, uses SDATA_STATE_OFFCHANNEL
  and is-scanning flags instead.

* Add helper method to determine if we are currently configured
  for the operating channel.

* Do no blindly go off/on channel in work.c  Instead, only call
  appropriate on/off code when we really need to change channels.

* Consolidate ieee80211_offchannel_stop_station and
  ieee80211_offchannel_stop_beaconing, call it
  ieee80211_offchannel_stop_vifs instead.

* Accept non-beacon frames when scanning, even if off-channel.

* Scan state machine optimized to minimize on/off channel
  transitions.  Also, when going on-channel, go ahead and
  re-enable beaconing.  We're going to be there for 200ms,
  so seems like some useful beaconing could happen.

* Grab local->mtx earlier in __ieee80211_scan_completed_finish
  so that we are protected when calling hw_config(), etc.

* Pass probe-responses up the stack if scanning on local
  channel, so that mlme can take a look.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v7:  Pass probe responses up stack so that mlme can use them
  when scanning on-channel.

:100644 100644 c47d7c0... 50ceb67... M	net/mac80211/ieee80211_i.h
:100644 100644 09a2744... 6684b9e... M	net/mac80211/main.c
:100644 100644 b4e5267... 5400da6... M	net/mac80211/offchannel.c
:100644 100644 7185c93... 030c3e9... M	net/mac80211/rx.c
:100644 100644 f246d8a... 450d228... M	net/mac80211/scan.c
:100644 100644 ffc6749... 5f8b4a6... M	net/mac80211/tx.c
:100644 100644 36305e0... 3c8ece9... M	net/mac80211/work.c
 net/mac80211/ieee80211_i.h |   13 +++++---
 net/mac80211/main.c        |   51 +++++++++++++++++++++++++++----
 net/mac80211/offchannel.c  |   48 ++++++++---------------------
 net/mac80211/rx.c          |   12 ++-----
 net/mac80211/scan.c        |   72 ++++++++++++++++++++++++++++----------------
 net/mac80211/tx.c          |    3 +-
 net/mac80211/work.c        |   54 ++++++++++++++++++++++++++-------
 7 files changed, 160 insertions(+), 93 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..50ceb67 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -654,8 +654,6 @@ struct tpt_led_trigger {
  *	well be on the operating channel
  * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
  *	determine if we are on the operating channel or not
- * @SCAN_OFF_CHANNEL: We're off our operating channel for scanning,
- *	gets only set in conjunction with SCAN_SW_SCANNING
  * @SCAN_COMPLETED: Set for our scan work function when the driver reported
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
@@ -664,7 +662,6 @@ struct tpt_led_trigger {
 enum {
 	SCAN_SW_SCANNING,
 	SCAN_HW_SCANNING,
-	SCAN_OFF_CHANNEL,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
 };
@@ -1147,8 +1144,14 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_bss *bss);
 
 /* off-channel helpers */
-void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local);
-void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
+/**
+ * Returns true if we are logically configured to be on
+ * the operating channel AND the hardware-conf is currently
+ * configured on the operating channel.  Compares channel-type
+ * as well.
+ */
+bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
 				 bool enable_beaconing);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 09a2744..6684b9e 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -98,6 +98,39 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 	ieee80211_configure_filter(local);
 }
 
+/* Return true if we are logically configured to be on
+ * the operating channel AND the hardware-conf is currently
+ * configured on the operating channel.
+ */
+bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
+{
+	struct ieee80211_channel *chan, *scan_chan;
+	enum nl80211_channel_type channel_type;
+
+	/* This logic needs to match logic in ieee80211_hw_config */
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
@@ -231,7 +270,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
-		    test_bit(SCAN_SW_SCANNING, &local->scanning)) {
+		    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state)) {
 			sdata->vif.bss_conf.enable_beacon = false;
 		} else {
 			/*
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index b4e5267..5400da6 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -95,55 +95,33 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	/*
+	 * notify the AP about us leaving the channel and stop all
+	 * STA interfaces.
+	 */
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
-		/* disable beaconing */
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+
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
-			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
 			netif_tx_stop_all_queues(sdata->dev);
-			if (sdata->u.mgd.associated)
+			if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
+			    sdata->u.mgd.associated)
 				ieee80211_offchannel_ps_enable(sdata);
 		}
 	}
@@ -181,7 +159,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			netif_tx_wake_all_queues(sdata->dev);
 		}
 
-		/* re-enable beaconing */
+		/* Check to see if we should re-enable beaconing */
 		if (enable_beaconing &&
 		    (sdata->vif.type == NL80211_IFTYPE_AP ||
 		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 7185c93..030c3e9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -409,16 +409,10 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
 		return RX_CONTINUE;
 
-	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
+	    test_bit(SCAN_SW_SCANNING, &local->scanning))
 		return ieee80211_scan_rx(rx->sdata, skb);
 
-	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
-		/* drop all the other packets during a software scan anyway */
-		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
-			dev_kfree_skb(skb);
-		return RX_QUEUED;
-	}
-
 	/* scanning finished during invoking of handlers */
 	I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
 	return RX_DROP_UNUSABLE;
@@ -2766,7 +2760,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
+		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
 	if (ieee80211_is_mgmt(fc))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f246d8a..450d228 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -212,6 +212,13 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (bss)
 		ieee80211_rx_bss_put(sdata->local, bss);
 
+	/* If we are scanning on-channel, pass the pkt on up the stack so that
+	 * mlme can make use of it
+	 */
+	if (ieee80211_cfg_on_oper_channel(sdata->local)
+	    && (channel == sdata->local->oper_channel))
+		return RX_CONTINUE;
+
 	dev_kfree_skb(skb);
 	return RX_QUEUED;
 }
@@ -293,15 +300,25 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
 					      bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	bool ooc;
+
+	mutex_lock(&local->mtx);
+	ooc = ieee80211_cfg_on_oper_channel(local);
+
+	if (was_hw_scan || !ooc)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 	if (!was_hw_scan) {
+		bool ooc2;
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true);
+		ooc2 = ieee80211_cfg_on_oper_channel(local);
+		/* We should always be on-channel at this point. */
+		WARN_ON(!ooc2);
+		if (ooc2 && (ooc != ooc2))
+			ieee80211_offchannel_return(local, true);
 	}
 
-	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->mtx);
 
@@ -398,14 +415,10 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
 	drv_sw_scan_start(local);
 
-	ieee80211_offchannel_stop_beaconing(local);
-
 	local->leave_oper_channel_time = 0;
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	drv_flush(local, false);
-
 	ieee80211_configure_filter(local);
 
 	ieee80211_queue_delayed_work(&local->hw,
@@ -544,7 +557,21 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	}
 	mutex_unlock(&local->iflist_mtx);
 
-	if (local->scan_channel) {
+	next_chan = local->scan_req->channels[local->scan_channel_idx];
+
+	if (ieee80211_cfg_on_oper_channel(local)) {
+		/* We're currently on operating channel. */
+		if ((next_chan == local->oper_channel) &&
+		    (local->_oper_channel_type == NL80211_CHAN_NO_HT))
+			/* We don't need to move off of operating channel. */
+			local->next_scan_state = SCAN_SET_CHANNEL;
+		else
+			/*
+			 * We do need to leave operating channel, as next
+			 * scan is somewhere else.
+			 */
+			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+	} else {
 		/*
 		 * we're currently scanning a different channel, let's
 		 * see if we can scan another channel without interfering
@@ -560,7 +587,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 		 *
 		 * Otherwise switch back to the operating channel.
 		 */
-		next_chan = local->scan_req->channels[local->scan_channel_idx];
 
 		bad_latency = time_after(jiffies +
 				ieee80211_scan_get_channel_time(next_chan),
@@ -578,12 +604,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
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
@@ -592,9 +612,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
-	ieee80211_offchannel_stop_station(local);
-
-	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
+	ieee80211_offchannel_stop_vifs(local);
 
 	/*
 	 * What if the nullfunc frames didn't arrive?
@@ -617,15 +635,13 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 {
 	/* switch back to the operating channel */
 	local->scan_channel = NULL;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!ieee80211_cfg_on_oper_channel(local))
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	/*
-	 * Only re-enable station mode interface now; beaconing will be
-	 * re-enabled once the full scan has been completed.
+	 * Re-enable vifs and beaconing.
 	 */
-	ieee80211_offchannel_return(local, false);
-
-	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
+	ieee80211_offchannel_return(local, true);
 
 	*next_delay = HZ / 5;
 	local->next_scan_state = SCAN_DECISION;
@@ -641,8 +657,12 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
 	local->scan_channel = chan;
-	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-		skip = 1;
+
+	/* Only call hw-config if we really need to change channels. */
+	if ((chan != local->hw.conf.channel) ||
+	    (local->hw.conf.channel_type != NL80211_CHAN_NO_HT))
+		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+			skip = 1;
 
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ffc6749..5f8b4a6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -257,7 +257,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
 	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
 		return TX_CONTINUE;
 
-	if (unlikely(test_bit(SCAN_OFF_CHANNEL, &tx->local->scanning)) &&
+	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
+	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&
 	    !ieee80211_is_probe_req(hdr->frame_control) &&
 	    !ieee80211_is_nullfunc(hdr->frame_control))
 		/*
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 36305e0..3c8ece9 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -924,18 +924,39 @@ static void ieee80211_work_work(struct work_struct *work)
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
+			bool ooc = ieee80211_cfg_on_oper_channel(local);
+			bool tmp_chan_changed = false;
+			bool ooc2;
+			if (local->tmp_channel)
+				if ((local->tmp_channel != wk->chan) ||
+				    (local->tmp_channel_type != wk->chan_type))
+					tmp_chan_changed = true;
 
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
-			ieee80211_hw_config(local, 0);
+			/*
+			 * Leave the station vifs in awake mode if they
+			 * happen to be on the same channel as
+			 * the requested channel.
+			 */
+			ooc2 = ieee80211_cfg_on_oper_channel(local);
+			if (ooc != ooc2) {
+				if (ooc2) {
+					/* went off operating channel */
+					ieee80211_offchannel_stop_vifs(local);
+					ieee80211_hw_config(local, 0);
+				} else {
+					/* went on channel */
+					ieee80211_hw_config(local, 0);
+					ieee80211_offchannel_return(local,
+								    true);
+				}
+			} else if (tmp_chan_changed)
+				/* Still off-channel, but on some other
+				 * channel, so update hardware.
+				 */
+				ieee80211_hw_config(local, 0);
+
 			started = true;
 			wk->timeout = jiffies;
 		}
@@ -1011,9 +1032,20 @@ static void ieee80211_work_work(struct work_struct *work)
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
+		bool ooc = ieee80211_cfg_on_oper_channel(local);
 		local->tmp_channel = NULL;
-		ieee80211_hw_config(local, 0);
-		ieee80211_offchannel_return(local, true);
+		/* If tmp_channel wasn't operating channel, then
+		 * we need to go back on-channel.
+		 * NOTE:  If we can ever be here while scannning,
+		 * or if the hw_config() channel config logic changes,
+		 * then we may need to do a more thorough check to see if
+		 * we still need to do a hardware config.  Currently,
+		 * we cannot be here while scanning, however.
+		 */
+		if (ieee80211_cfg_on_oper_channel(local) && !ooc) {
+			ieee80211_hw_config(local, 0);
+			ieee80211_offchannel_return(local, true);
+		}
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
 	}
-- 
1.7.2.3

