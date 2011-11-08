Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab1KHPV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 10:21:26 -0500
Subject: [PATCH] mac80211: simplify scan state machine
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:21:21 +0100
Message-ID: <1320765681.24797.0.camel@jlt3.sipsolutions.net> (sfid-20111108_162144_514977_6A353EB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Attempting to micro-optimise the scan by going
fully live again when scanning the operating
channel just made the code extremely complex
and has little gain in most use cases. Remove
all that code and simplify the state machine
again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |   11 +-
 net/mac80211/scan.c        |  201 +++++++++++++++++----------------------------
 2 files changed, 83 insertions(+), 129 deletions(-)

--- a/net/mac80211/scan.c	2011-11-08 15:22:36.000000000 +0100
+++ b/net/mac80211/scan.c	2011-11-08 15:47:57.000000000 +0100
@@ -212,12 +212,7 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	if (bss)
 		ieee80211_rx_bss_put(sdata->local, bss);
 
-	/* If we are on-operating-channel, and this packet is for the
-	 * current channel, pass the pkt on up the stack so that
-	 * the rest of the stack can make use of it.
-	 */
-	if (ieee80211_cfg_on_oper_channel(sdata->local)
-	    && (channel == sdata->local->oper_channel))
+	if (channel == sdata->local->oper_channel)
 		return RX_CONTINUE;
 
 	dev_kfree_skb(skb);
@@ -263,8 +258,6 @@ static void __ieee80211_scan_completed(s
 				       bool was_hw_scan)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	bool on_oper_chan;
-	bool enable_beacons = false;
 
 	lockdep_assert_held(&local->mtx);
 
@@ -297,25 +290,13 @@ static void __ieee80211_scan_completed(s
 	local->scanning = 0;
 	local->scan_channel = NULL;
 
-	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
-
-	if (was_hw_scan || !on_oper_chan)
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-	else
-		/* Set power back to normal operating levels. */
-		ieee80211_hw_config(local, 0);
+	/* Set power back to normal operating levels. */
+	ieee80211_hw_config(local, 0);
 
 	if (!was_hw_scan) {
-		bool on_oper_chan2;
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
-		/* We should always be on-channel at this point. */
-		WARN_ON(!on_oper_chan2);
-		if (on_oper_chan2 && (on_oper_chan != on_oper_chan2))
-			enable_beacons = true;
-
-		ieee80211_offchannel_return(local, enable_beacons, true);
+		ieee80211_offchannel_return(local, true, true);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -360,11 +341,7 @@ static int ieee80211_start_sw_scan(struc
 	local->next_scan_state = SCAN_DECISION;
 	local->scan_channel_idx = 0;
 
-	/* We always want to use off-channel PS, even if we
-	 * are not really leaving oper-channel.  Don't
-	 * tell the AP though, as long as we are on-channel.
-	 */
-	ieee80211_offchannel_enable_all_ps(local, false);
+	ieee80211_offchannel_stop_vifs(local, true);
 
 	ieee80211_configure_filter(local);
 
@@ -372,8 +349,7 @@ static int ieee80211_start_sw_scan(struc
 	ieee80211_hw_config(local, 0);
 
 	ieee80211_queue_delayed_work(&local->hw,
-				     &local->scan_work,
-				     IEEE80211_CHANNEL_TIME);
+				     &local->scan_work, 0);
 
 	return 0;
 }
@@ -509,96 +485,39 @@ static void ieee80211_scan_state_decisio
 
 	next_chan = local->scan_req->channels[local->scan_channel_idx];
 
-	if (ieee80211_cfg_on_oper_channel(local)) {
-		/* We're currently on operating channel. */
-		if (next_chan == local->oper_channel)
-			/* We don't need to move off of operating channel. */
-			local->next_scan_state = SCAN_SET_CHANNEL;
-		else
-			/*
-			 * We do need to leave operating channel, as next
-			 * scan is somewhere else.
-			 */
-			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
-	} else {
-		/*
-		 * we're currently scanning a different channel, let's
-		 * see if we can scan another channel without interfering
-		 * with the current traffic situation.
-		 *
-		 * Since we don't know if the AP has pending frames for us
-		 * we can only check for our tx queues and use the current
-		 * pm_qos requirements for rx. Hence, if no tx traffic occurs
-		 * at all we will scan as many channels in a row as the pm_qos
-		 * latency allows us to. Additionally we also check for the
-		 * currently negotiated listen interval to prevent losing
-		 * frames unnecessarily.
-		 *
-		 * Otherwise switch back to the operating channel.
-		 */
-
-		bad_latency = time_after(jiffies +
-				ieee80211_scan_get_channel_time(next_chan),
-				local->leave_oper_channel_time +
-				usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
-
-		listen_int_exceeded = time_after(jiffies +
-				ieee80211_scan_get_channel_time(next_chan),
-				local->leave_oper_channel_time +
-				usecs_to_jiffies(min_beacon_int * 1024) *
-				local->hw.conf.listen_interval);
-
-		if (associated && ( !tx_empty || bad_latency ||
-		    listen_int_exceeded))
-			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
-		else
-			local->next_scan_state = SCAN_SET_CHANNEL;
-	}
-
-	*next_delay = 0;
-}
-
-static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
-						    unsigned long *next_delay)
-{
-	/* PS will already be in off-channel mode,
-	 * we do that once at the beginning of scanning.
-	 */
-	ieee80211_offchannel_stop_vifs(local, false);
-
 	/*
-	 * What if the nullfunc frames didn't arrive?
+	 * we're currently scanning a different channel, let's
+	 * see if we can scan another channel without interfering
+	 * with the current traffic situation.
+	 *
+	 * Since we don't know if the AP has pending frames for us
+	 * we can only check for our tx queues and use the current
+	 * pm_qos requirements for rx. Hence, if no tx traffic occurs
+	 * at all we will scan as many channels in a row as the pm_qos
+	 * latency allows us to. Additionally we also check for the
+	 * currently negotiated listen interval to prevent losing
+	 * frames unnecessarily.
+	 *
+	 * Otherwise switch back to the operating channel.
 	 */
-	drv_flush(local, false);
-	if (local->ops->flush)
-		*next_delay = 0;
-	else
-		*next_delay = HZ / 10;
 
-	/* remember when we left the operating channel */
-	local->leave_oper_channel_time = jiffies;
+	bad_latency = time_after(jiffies +
+			ieee80211_scan_get_channel_time(next_chan),
+			local->leave_oper_channel_time +
+			usecs_to_jiffies(pm_qos_request(PM_QOS_NETWORK_LATENCY)));
+
+	listen_int_exceeded = time_after(jiffies +
+			ieee80211_scan_get_channel_time(next_chan),
+			local->leave_oper_channel_time +
+			usecs_to_jiffies(min_beacon_int * 1024) *
+			local->hw.conf.listen_interval);
 
-	/* advance to the next channel to be scanned */
-	local->next_scan_state = SCAN_SET_CHANNEL;
-}
-
-static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
-						    unsigned long *next_delay)
-{
-	/* switch back to the operating channel */
-	local->scan_channel = NULL;
-	if (!ieee80211_cfg_on_oper_channel(local))
-		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	/*
-	 * Re-enable vifs and beaconing.  Leave PS
-	 * in off-channel state..will put that back
-	 * on-channel at the end of scanning.
-	 */
-	ieee80211_offchannel_return(local, true, false);
+	if (associated && (!tx_empty || bad_latency || listen_int_exceeded))
+		local->next_scan_state = SCAN_SUSPEND;
+	else
+		local->next_scan_state = SCAN_SET_CHANNEL;
 
-	*next_delay = HZ / 5;
-	local->next_scan_state = SCAN_DECISION;
+	*next_delay = 0;
 }
 
 static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
@@ -612,10 +531,8 @@ static void ieee80211_scan_state_set_cha
 
 	local->scan_channel = chan;
 
-	/* Only call hw-config if we really need to change channels. */
-	if (chan != local->hw.conf.channel)
-		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-			skip = 1;
+	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+		skip = 1;
 
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
@@ -672,6 +589,44 @@ static void ieee80211_scan_state_send_pr
 	local->next_scan_state = SCAN_DECISION;
 }
 
+static void ieee80211_scan_state_suspend(struct ieee80211_local *local,
+					 unsigned long *next_delay)
+{
+	/* switch back to the operating channel */
+	local->scan_channel = NULL;
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
+	/*
+	 * Re-enable vifs and beaconing.  Leave PS
+	 * in off-channel state..will put that back
+	 * on-channel at the end of scanning.
+	 */
+	ieee80211_offchannel_return(local, true, false);
+
+	*next_delay = HZ / 5;
+	/* afterwards, resume scan & go to next channel */
+	local->next_scan_state = SCAN_RESUME;
+}
+
+static void ieee80211_scan_state_resume(struct ieee80211_local *local,
+					unsigned long *next_delay)
+{
+	/* PS already is in off-channel mode */
+	ieee80211_offchannel_stop_vifs(local, false);
+
+	if (local->ops->flush) {
+		drv_flush(local, false);
+		*next_delay = 0;
+	} else
+		*next_delay = HZ / 10;
+
+	/* remember when we left the operating channel */
+	local->leave_oper_channel_time = jiffies;
+
+	/* advance to the next channel to be scanned */
+	local->next_scan_state = SCAN_DECISION;
+}
+
 void ieee80211_scan_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
@@ -742,11 +697,11 @@ void ieee80211_scan_work(struct work_str
 		case SCAN_SEND_PROBE:
 			ieee80211_scan_state_send_probe(local, &next_delay);
 			break;
-		case SCAN_LEAVE_OPER_CHANNEL:
-			ieee80211_scan_state_leave_oper_channel(local, &next_delay);
+		case SCAN_SUSPEND:
+			ieee80211_scan_state_suspend(local, &next_delay);
 			break;
-		case SCAN_ENTER_OPER_CHANNEL:
-			ieee80211_scan_state_enter_oper_channel(local, &next_delay);
+		case SCAN_RESUME:
+			ieee80211_scan_state_resume(local, &next_delay);
 			break;
 		}
 	} while (next_delay == 0);
--- a/net/mac80211/ieee80211_i.h	2011-11-08 15:23:19.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-08 15:50:44.000000000 +0100
@@ -722,17 +722,16 @@ enum {
  *	operating channel
  * @SCAN_SET_CHANNEL: Set the next channel to be scanned
  * @SCAN_SEND_PROBE: Send probe requests and wait for probe responses
- * @SCAN_LEAVE_OPER_CHANNEL: Leave the operating channel, notify the AP
- *	about us leaving the channel and stop all associated STA interfaces
- * @SCAN_ENTER_OPER_CHANNEL: Enter the operating channel again, notify the
- *	AP about us being back and restart all associated STA interfaces
+ * @SCAN_SUSPEND: Suspend the scan and go back to operating channel to
+ *	send out data
+ * @SCAN_RESUME: Resume the scan and scan the next channel
  */
 enum mac80211_scan_state {
 	SCAN_DECISION,
 	SCAN_SET_CHANNEL,
 	SCAN_SEND_PROBE,
-	SCAN_LEAVE_OPER_CHANNEL,
-	SCAN_ENTER_OPER_CHANNEL,
+	SCAN_SUSPEND,
+	SCAN_RESUME,
 };
 
 struct ieee80211_local {


