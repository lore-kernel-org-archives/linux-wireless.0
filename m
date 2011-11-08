Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45167 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1KHRK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:10:26 -0500
Subject: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 18:10:22 +0100
Message-ID: <1320772222.24797.22.camel@jlt3.sipsolutions.net> (sfid-20111108_181030_255154_67DB7F22)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI -- I'm going to test this a bit more but I am going to put it in.
The code is a mess -- look at how much code I remove below (and that's
after everybody elses cleanups!) for a dubious optimisation.

I agree that we should address this and we need to really do this to not
mess up our aggregation state, but the current code is too complex and
causing too many issues. We also need to think about this in the context
of multi-virtual-channel support.

johannes



From: Johannes Berg <johannes.berg@intel.com>

The on-channel work optimisations have caused a
number of issues, and the code is unfortunately
very complex and almost impossible to follow.
Instead of attempting to put in more workarounds
let's just remove those optimisations, we can
work on them again later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This applies on top of Stanislaw's three patches and
my patch from today to remove the same mess from the
scan code.

 net/mac80211/ieee80211_i.h |    2 
 net/mac80211/main.c        |   41 ------------------
 net/mac80211/offchannel.c  |    9 +---
 net/mac80211/scan.c        |    4 -
 net/mac80211/work.c        |   99 +++------------------------------------------
 5 files changed, 13 insertions(+), 142 deletions(-)

--- a/net/mac80211/work.c	2011-11-08 18:04:34.000000000 +0100
+++ b/net/mac80211/work.c	2011-11-08 18:05:52.000000000 +0100
@@ -881,44 +881,6 @@ static void ieee80211_work_rx_queued_mgm
 	kfree_skb(skb);
 }
 
-static bool ieee80211_work_ct_coexists(enum nl80211_channel_type wk_ct,
-				       enum nl80211_channel_type oper_ct)
-{
-	switch (wk_ct) {
-	case NL80211_CHAN_NO_HT:
-		return true;
-	case NL80211_CHAN_HT20:
-		if (oper_ct != NL80211_CHAN_NO_HT)
-			return true;
-		return false;
-	case NL80211_CHAN_HT40MINUS:
-	case NL80211_CHAN_HT40PLUS:
-		return (wk_ct == oper_ct);
-	}
-	WARN_ON(1); /* shouldn't get here */
-	return false;
-}
-
-static enum nl80211_channel_type
-ieee80211_calc_ct(enum nl80211_channel_type wk_ct,
-		  enum nl80211_channel_type oper_ct)
-{
-	switch (wk_ct) {
-	case NL80211_CHAN_NO_HT:
-		return oper_ct;
-	case NL80211_CHAN_HT20:
-		if (oper_ct != NL80211_CHAN_NO_HT)
-			return oper_ct;
-		return wk_ct;
-	case NL80211_CHAN_HT40MINUS:
-	case NL80211_CHAN_HT40PLUS:
-		return wk_ct;
-	}
-	WARN_ON(1); /* shouldn't get here */
-	return wk_ct;
-}
-
-
 static void ieee80211_work_timer(unsigned long data)
 {
 	struct ieee80211_local *local = (void *) data;
@@ -969,40 +931,12 @@ static void ieee80211_work_work(struct w
 		}
 
 		if (!started && !local->tmp_channel) {
-			bool on_oper_chan, on_oper_chan2;
-			enum nl80211_channel_type wk_ct;
-
-			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
-
-			/* Work with existing channel type if possible. */
-			wk_ct = wk->chan_type;
-			if (wk->chan == local->hw.conf.channel)
-				wk_ct = ieee80211_calc_ct(wk->chan_type,
-						local->hw.conf.channel_type);
+			ieee80211_offchannel_stop_vifs(local, true);
 
 			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk_ct;
-			/*
-			 * Leave the station vifs in awake mode if they
-			 * happen to be on the same channel as
-			 * the requested channel.
-			 */
-			on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
-			if (on_oper_chan != on_oper_chan2) {
-				if (on_oper_chan2) {
-					/* going off oper channel, PS too */
-					ieee80211_offchannel_stop_vifs(local,
-								       true);
-					ieee80211_hw_config(local, 0);
-				} else {
-					/* going on channel, but leave PS
-					 * off-channel. */
-					ieee80211_hw_config(local, 0);
-					ieee80211_offchannel_return(local,
-								    true,
-								    false);
-				}
-			}
+			local->tmp_channel_type = wk->chan_type;
+
+			ieee80211_hw_config(local, 0);
 
 			started = true;
 			wk->timeout = jiffies;
@@ -1071,34 +1005,17 @@ static void ieee80211_work_work(struct w
 	list_for_each_entry(wk, &local->work_list, list) {
 		if (!wk->started)
 			continue;
-		if (wk->chan != local->tmp_channel)
-			continue;
-		if (!ieee80211_work_ct_coexists(wk->chan_type,
-						local->tmp_channel_type))
+		if (wk->chan != local->tmp_channel ||
+		    wk->chan_type != local->tmp_channel_type)
 			continue;
 		remain_off_channel = true;
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
 		local->tmp_channel = NULL;
-		/* If tmp_channel wasn't operating channel, then
-		 * we need to go back on-channel.
-		 * NOTE:  If we can ever be here while scannning,
-		 * or if the hw_config() channel config logic changes,
-		 * then we may need to do a more thorough check to see if
-		 * we still need to do a hardware config.  Currently,
-		 * we cannot be here while scanning, however.
-		 */
-		if (!ieee80211_cfg_on_oper_channel(local))
-			ieee80211_hw_config(local, 0);
+		ieee80211_hw_config(local, 0);
 
-		/* At the least, we need to disable offchannel_ps,
-		 * so just go ahead and run the entire offchannel
-		 * return logic here.  We *could* skip enabling
-		 * beaconing if we were already on-oper-channel
-		 * as a future optimization.
-		 */
-		ieee80211_offchannel_return(local, true, true);
+		ieee80211_offchannel_return(local, true);
 
 		/* give connection some time to breathe */
 		run_again(local, jiffies + HZ/2);
--- a/net/mac80211/ieee80211_i.h	2011-11-08 18:05:51.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-08 18:05:52.000000000 +0100
@@ -1139,13 +1139,11 @@ int ieee80211_request_sched_scan_stop(st
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
 void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
 					bool tell_ap);
 void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 				    bool offchannel_ps_enable);
 void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool enable_beaconing,
 				 bool offchannel_ps_disable);
 void ieee80211_hw_roc_setup(struct ieee80211_local *local);
 
--- a/net/mac80211/offchannel.c	2011-11-08 17:51:57.000000000 +0100
+++ b/net/mac80211/offchannel.c	2011-11-08 18:05:52.000000000 +0100
@@ -155,7 +155,6 @@ void ieee80211_offchannel_enable_all_ps(
 }
 
 void ieee80211_offchannel_return(struct ieee80211_local *local,
-				 bool enable_beaconing,
 				 bool offchannel_ps_disable)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -187,11 +186,9 @@ void ieee80211_offchannel_return(struct
 			netif_tx_wake_all_queues(sdata->dev);
 		}
 
-		/* Check to see if we should re-enable beaconing */
-		if (enable_beaconing &&
-		    (sdata->vif.type == NL80211_IFTYPE_AP ||
-		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		     sdata->vif.type == NL80211_IFTYPE_MESH_POINT))
+		if (sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
 			ieee80211_bss_info_change_notify(
 				sdata, BSS_CHANGED_BEACON_ENABLED);
 	}
--- a/net/mac80211/main.c	2011-11-08 18:04:34.000000000 +0100
+++ b/net/mac80211/main.c	2011-11-08 18:05:52.000000000 +0100
@@ -92,47 +92,6 @@ static void ieee80211_reconfig_filter(st
 	ieee80211_configure_filter(local);
 }
 
-/*
- * Returns true if we are logically configured to be on
- * the operating channel AND the hardware-conf is currently
- * configured on the operating channel.  Compares channel-type
- * as well.
- */
-bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
-{
-	struct ieee80211_channel *chan;
-	enum nl80211_channel_type channel_type;
-
-	/* This logic needs to match logic in ieee80211_hw_config */
-	if (local->scan_channel) {
-		chan = local->scan_channel;
-		/* If scanning on oper channel, use whatever channel-type
-		 * is currently in use.
-		 */
-		if (chan == local->oper_channel)
-			channel_type = local->_oper_channel_type;
-		else
-			channel_type = NL80211_CHAN_NO_HT;
-	} else if (local->tmp_channel) {
-		chan = local->tmp_channel;
-		channel_type = local->tmp_channel_type;
-	} else {
-		chan = local->oper_channel;
-		channel_type = local->_oper_channel_type;
-	}
-
-	if (chan != local->oper_channel ||
-	    channel_type != local->_oper_channel_type)
-		return false;
-
-	/* Check current hardware-config against oper_channel. */
-	if (local->oper_channel != local->hw.conf.channel ||
-	    local->_oper_channel_type != local->hw.conf.channel_type)
-		return false;
-
-	return true;
-}
-
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan;
--- a/net/mac80211/scan.c	2011-11-08 18:05:51.000000000 +0100
+++ b/net/mac80211/scan.c	2011-11-08 18:05:52.000000000 +0100
@@ -296,7 +296,7 @@ static void __ieee80211_scan_completed(s
 	if (!was_hw_scan) {
 		ieee80211_configure_filter(local);
 		drv_sw_scan_complete(local);
-		ieee80211_offchannel_return(local, true, true);
+		ieee80211_offchannel_return(local, true);
 	}
 
 	ieee80211_recalc_idle(local);
@@ -601,7 +601,7 @@ static void ieee80211_scan_state_suspend
 	 * in off-channel state..will put that back
 	 * on-channel at the end of scanning.
 	 */
-	ieee80211_offchannel_return(local, true, false);
+	ieee80211_offchannel_return(local, false);
 
 	*next_delay = HZ / 5;
 	/* afterwards, resume scan & go to next channel */


