Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35937 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1A1GKD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 01:10:03 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC v5] mac80211:  Optimize scans on current operating channel.
Date: Thu, 27 Jan 2011 22:09:55 -0800
Message-Id: <1296194995-12145-1-git-send-email-greearb@candelatech.com>
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

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

This fixes some logic errors related to work_work(), and adds
a bunch of debugging code that I know needs removing before
it is merged.


:100644 100644 5b24740... cb23352... M	net/mac80211/chan.c
:100644 100644 c47d7c0... b24fb2f... M	net/mac80211/ieee80211_i.h
:100644 100644 09a2744... 6684b9e... M	net/mac80211/main.c
:100644 100644 b4e5267... 903ef99... M	net/mac80211/offchannel.c
:100644 100644 f36d70f... fa8e5ec... M	net/mac80211/rx.c
:100644 100644 f246d8a... 18aee42... M	net/mac80211/scan.c
:100644 100644 e46c801... 4cc8add... M	net/mac80211/tx.c
:100644 100644 36305e0... 34355b7... M	net/mac80211/work.c
 net/mac80211/chan.c        |    2 +
 net/mac80211/ieee80211_i.h |   17 ++++++---
 net/mac80211/main.c        |   51 ++++++++++++++++++++++++---
 net/mac80211/offchannel.c  |   53 +++++++++-------------------
 net/mac80211/rx.c          |   12 ++-----
 net/mac80211/scan.c        |   83 +++++++++++++++++++++++++++++--------------
 net/mac80211/tx.c          |    3 +-
 net/mac80211/work.c        |   57 ++++++++++++++++++++++++------
 8 files changed, 182 insertions(+), 96 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5b24740..cb23352 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -119,6 +119,8 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 	if (sdata)
 		sdata->vif.bss_conf.channel_type = chantype;
 
+	printk("%s:  Set channel, superchan: %i  chantype: %i\n",
+	       sdata->name, superchan, chantype);
 	result = true;
  out:
 	mutex_unlock(&local->iflist_mtx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c47d7c0..b24fb2f 100644
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
@@ -1147,10 +1144,18 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
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
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
+				    const char* dbg);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool enable_beaconing);
+				 bool enable_beaconing,
+				 const char* dbg);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
 
 /* interface handling */
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
index b4e5267..903ef99 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -95,55 +95,35 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
+void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
+				    const char* dbg)
 {
 	struct ieee80211_sub_if_data *sdata;
 
+	/*
+	 * notify the AP about us leaving the channel and stop all
+	 * STA interfaces.
+	 */
 	mutex_lock(&local->iflist_mtx);
+	printk("offchannel_stop_vifs: %s\n", dbg);
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
@@ -151,11 +131,12 @@ void ieee80211_offchannel_stop_station(struct ieee80211_local *local)
 }
 
 void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool enable_beaconing)
+				 bool enable_beaconing, const char* dbg)
 {
 	struct ieee80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
+	printk("offchannel_return:  %s\n", dbg);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
@@ -181,7 +162,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 			netif_tx_wake_all_queues(sdata->dev);
 		}
 
-		/* re-enable beaconing */
+		/* Check to see if we should re-enable beaconing */
 		if (enable_beaconing &&
 		    (sdata->vif.type == NL80211_IFTYPE_AP ||
 		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f36d70f..fa8e5ec 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -392,16 +392,10 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
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
@@ -2749,7 +2743,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
+		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
 	if (ieee80211_is_mgmt(fc))
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f246d8a..18aee42 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -293,14 +293,31 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
 					      bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	bool ooc = ieee80211_cfg_on_oper_channel(local);
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
+		WARN_ON_ONCE(!ooc2);
+		if (ooc2 && (ooc != ooc2))
+			ieee80211_offchannel_return(local, true, "scan-completed");
 	}
 
+	printk("scan_completed_finish, conf channel: %d MHz  HT: %i  chan-type: %i ooc: %i\n",
+	       local->hw.conf.channel->center_freq,
+	       conf_is_ht(&local->hw.conf), local->hw.conf.channel_type,
+	       (int)(ooc));
+
+	printk("scan_completed_finish, oper channel: %d MHz  chan-type: %i\n",
+	       local->oper_channel->center_freq,
+	       local->_oper_channel_type);
+
 	mutex_lock(&local->mtx);
 	ieee80211_recalc_idle(local);
 	mutex_unlock(&local->mtx);
@@ -344,6 +361,14 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	int running_other_vifs = 0; /* AP, etc */
 	struct ieee80211_sub_if_data *sdata;
 
+	printk("start_sw_scan, conf channel: %d MHz  HT: %i  chan-type: %i\n",
+	       local->hw.conf.channel->center_freq,
+	       conf_is_ht(&local->hw.conf), local->hw.conf.channel_type);
+
+	printk("start_sw_scan, oper channel: %d MHz  chan-type: %i\n",
+	       local->oper_channel->center_freq,
+	       local->_oper_channel_type);
+	
 	/*
 	  printk("start_sw_scan, can_scan_one: %i  n_channels: %i\n",
 	  local->scan_req->can_scan_one, local->scan_req->n_channels);
@@ -384,10 +409,11 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 			local->scan_req->n_channels = 1;
 			printk(KERN_ERR "start_sw_scan: running-other-vifs: %i  "
 			       "running-station-vifs: %i, associated-stations: %i"
-			       " scanning current channel: %u MHz\n",
+			       " scanning current channel: %u MHz chan-type: %i\n",
 			       running_other_vifs, running_station_vifs,
 			       associated_station_vifs,
-			       local->hw.conf.channel->center_freq);
+			       local->hw.conf.channel->center_freq,
+			       local->hw.conf.channel_type);
 		} else
 			printk(KERN_ERR "start_sw_scan: running-other-vifs: %i  "
 			       "running-station-vifs: %i, associated-stations: %i"
@@ -398,14 +424,10 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 
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
@@ -544,7 +566,21 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
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
@@ -560,7 +596,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 		 *
 		 * Otherwise switch back to the operating channel.
 		 */
-		next_chan = local->scan_req->channels[local->scan_channel_idx];
 
 		bad_latency = time_after(jiffies +
 				ieee80211_scan_get_channel_time(next_chan),
@@ -578,12 +613,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
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
@@ -592,9 +621,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
 						    unsigned long *next_delay)
 {
-	ieee80211_offchannel_stop_station(local);
-
-	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
+	ieee80211_offchannel_stop_vifs(local, "leave_oper_channel");
 
 	/*
 	 * What if the nullfunc frames didn't arrive?
@@ -617,15 +644,13 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
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
+	ieee80211_offchannel_return(local, true, "scan enter_oper_channel");
 
 	*next_delay = HZ / 5;
 	local->next_scan_state = SCAN_DECISION;
@@ -641,8 +666,12 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
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
index e46c801..4cc8add 100644
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
index 36305e0..34355b7 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -924,18 +924,39 @@ static void ieee80211_work_work(struct work_struct *work)
 		}
 
 		if (!started && !local->tmp_channel) {
+			bool ooc = ieee80211_cfg_on_oper_channel(local);
+			bool tmp_chan_changed = false;
+			bool ooc2;
+			if (local->tmp_channel)
+				if ((local->tmp_channel != wk->chan) ||
+				    (local->tmp_channel_type != wk->chan_type))
+					tmp_chan_changed = true;
+		
+			local->tmp_channel = wk->chan;
+			local->tmp_channel_type = wk->chan_type;
 			/*
-			 * TODO: could optimize this by leaving the
-			 *	 station vifs in awake mode if they
-			 *	 happen to be on the same channel as
-			 *	 the requested channel
+			 * Leave the station vifs in awake mode if they
+			 * happen to be on the same channel as
+			 * the requested channel.
 			 */
-			ieee80211_offchannel_stop_beaconing(local);
-			ieee80211_offchannel_stop_station(local);
+			ooc2 = ieee80211_cfg_on_oper_channel(local);
+			printk("work_work: tmp_channel: %d MHz  type: %i ooc: %i  ooc2: %i\n",
+			       local->tmp_channel ? local->tmp_channel->center_freq : 0,
+			       local->tmp_channel_type, ooc, ooc2);
+			if (ooc != ooc2) {
+				if (ooc2) {
+					/* went off operating channel */
+					ieee80211_offchannel_stop_vifs(local, "work_work");
+					ieee80211_hw_config(local, 0);
+				} else {
+					/* went on channel */
+					ieee80211_hw_config(local, 0);
+					ieee80211_offchannel_return(local, true, "work_work, work went on-channel");
+				}
+			} else if (tmp_chan_changed)
+				/* Still off-channel, but on some other channel. */
+				ieee80211_hw_config(local, 0);
 
-			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
-			ieee80211_hw_config(local, 0);
 			started = true;
 			wk->timeout = jiffies;
 		}
@@ -1010,10 +1031,24 @@ static void ieee80211_work_work(struct work_struct *work)
 		remain_off_channel = true;
 	}
 
+	printk("remain_off_channel: %i  tmp_channel: %p\n",
+	       remain_off_channel, local->tmp_channel);
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
+		printk("ooc: %i\n", ooc);
+		if (ieee80211_cfg_on_oper_channel(local) && !ooc) {
+			ieee80211_hw_config(local, 0);
+			ieee80211_offchannel_return(local, true, "work_work, don't-remain-offchannel");
+		}
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
 	}
-- 
1.7.2.3

