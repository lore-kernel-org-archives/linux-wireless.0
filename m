Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38309 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab0IMXOG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Sep 2010 19:14:06 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o8DNE5JS008165
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Sep 2010 16:14:05 -0700
Message-ID: <4C8EB03D.7070808@candelatech.com>
Date: Mon, 13 Sep 2010 16:14:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RFC:  mac80211/ath9k:  allow scanning single channel if other VIF
 is associated.
Content-Type: multipart/mixed;
 boundary="------------000602070802050906050008"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000602070802050906050008
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

This patch aims to decrease channel switching when there is at least one
interface associated.  This should help multiple station interfaces co-exist
on the same hardware, especially in WPA mode.

This patch is on top of the other 3 I posted recently, and even though I think
this patch is going in the right direction, I still cannot get two WPA interfaces
to complete authentication.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


--------------000602070802050906050008
Content-Type: text/plain;
 name="scan_one.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scan_one.patch"

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1165f90..13673bb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1605,7 +1605,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
 
+		/* If channels are the same, then don't actually do anything.
+		 */
+		if (sc->sc_ah->curchan == &sc->sc_ah->channels[pos])
+			goto skip_chan_change;
+		
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
 		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4e635e2..631b094 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -790,6 +790,8 @@ struct ieee80211_local {
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
+	int scanned_count; /* how many channels scanned so far in this scan */
+	bool scan_probe_once; /* if true, scan only the current channel. */
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0cb822c..abb76ae 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1845,10 +1845,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			printk(KERN_DEBUG "No probe response from AP %pM"
-				" after %dms, try %d\n", bssid,
+			printk(KERN_DEBUG "%s: No probe response from AP %pM"
+				" after %dms, try %d  flags: 0x%x\n",
+				sdata->dev->name, bssid,
 				(1000 * IEEE80211_PROBE_WAIT)/HZ,
-				ifmgd->probe_send_count);
+				ifmgd->probe_send_count, ifmgd->flags);
 #endif
 			ieee80211_mgd_probe_ap_send(sdata);
 		} else {
@@ -1858,9 +1859,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 */
 			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 					  IEEE80211_STA_BEACON_POLL);
-			printk(KERN_DEBUG "No probe response from AP %pM"
-				" after %dms, disconnecting.\n",
-				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+			printk(KERN_DEBUG "%s: No probe response from AP %pM"
+			       " after %dms, disconnecting, flags: 0x%x\n",
+			       sdata->dev->name, bssid,
+			       (1000 * IEEE80211_PROBE_WAIT)/HZ, ifmgd->flags);
 			ieee80211_set_disassoc(sdata, true);
 			mutex_unlock(&ifmgd->mtx);
 			mutex_lock(&local->mtx);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ac205a3..e8ea84d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2399,7 +2399,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 	do {				\
 		res = rxh(rx);		\
 		if (res != RX_CONTINUE)	\
-			goto rxh_next;  \
+			goto rxh_next;	\
 	} while (0);
 
 	while ((skb = __skb_dequeue(frames))) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index e20fb52..1c9f0a8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -292,7 +292,9 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	/* we only have to protect scan_req and hw/sw scan */
 	mutex_unlock(&local->mtx);
 
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!local->scan_probe_once)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
 	if (was_hw_scan)
 		goto done;
 
@@ -300,7 +302,8 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	drv_sw_scan_complete(local);
 
-	ieee80211_offchannel_return(local, true);
+	if (!local->scan_probe_once)
+		ieee80211_offchannel_return(local, true);
 
  done:
 	mutex_lock(&local->mtx);
@@ -340,13 +343,43 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
-	drv_sw_scan_start(local);
+	int avifs = 0;
+	int svifs = 0;
+	struct ieee80211_sub_if_data *sdata;
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!ieee80211_sdata_running(sdata))
+			continue;
 
-	ieee80211_offchannel_stop_beaconing(local);
+		if (sdata->vif.type != NL80211_IFTYPE_STATION
+		    || sdata->u.mgd.associated)
+			avifs++;
 
-	local->leave_oper_channel_time = 0;
+		if (sdata->vif.type == NL80211_IFTYPE_STATION)
+			svifs++;
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	/* If one sta is associated, we don't want another to start scanning,
+	 * as that will un-associate the first.
+	 * TODO:  This still leaves a race when a thundering herd of WPA
+	 * supplicants are all coming up at once.
+	 */
+	if ((avifs > 1) || ((avifs == 1) && (svifs > 1)))
+		local->scan_probe_once = true;
+	else
+		local->scan_probe_once = false;
+
+	drv_sw_scan_start(local);
+
+	if (!local->scan_probe_once) {
+		ieee80211_offchannel_stop_beaconing(local);
+		local->leave_oper_channel_time = 0;
+		local->scan_channel_idx = 0;
+	}
+	local->scanned_count = 0;
 	local->next_scan_state = SCAN_DECISION;
-	local->scan_channel_idx = 0;
 
 	drv_flush(local, false);
 
@@ -459,7 +492,8 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	struct ieee80211_channel *next_chan;
 
 	/* if no more bands/channels left, complete scan and advance to the idle state */
-	if (local->scan_channel_idx >= local->scan_req->n_channels) {
+	if ((local->scan_channel_idx >= local->scan_req->n_channels) ||
+	    (local->scanned_count && local->scan_probe_once)) {
 		__ieee80211_scan_completed(&local->hw, false);
 		return 1;
 	}
@@ -528,10 +562,13 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 			local->next_scan_state = SCAN_SET_CHANNEL;
 	} else {
 		/*
-		 * we're on the operating channel currently, let's
-		 * leave that channel now to scan another one
+		 * we're on the operating channel currently, Leave that
+		 * channel if we are not probing the single channel.
 		 */
-		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
+		if (local->scan_probe_once)
+			local->next_scan_state = SCAN_SET_CHANNEL;
+		else
+			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	}
 
 	*next_delay = 0;
@@ -566,14 +603,15 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 {
 	/* switch back to the operating channel */
 	local->scan_channel = NULL;
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
-
-	/*
-	 * Only re-enable station mode interface now; beaconing will be
-	 * re-enabled once the full scan has been completed.
-	 */
-	ieee80211_offchannel_return(local, false);
+	if (!local->scan_probe_once) {
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
+		/*
+		 * Only re-enable station mode interface now; beaconing will be
+		 * re-enabled once the full scan has been completed.
+		 */
+		ieee80211_offchannel_return(local, false);
+	}
 	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
 
 	*next_delay = HZ / 5;
@@ -587,19 +625,25 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	struct ieee80211_channel *chan;
 
 	skip = 0;
-	chan = local->scan_req->channels[local->scan_channel_idx];
+	if (local->scan_probe_once) {
+		chan = local->oper_channel;
+		local->scan_channel = chan;
+	} else {
+		chan = local->scan_req->channels[local->scan_channel_idx];
+		local->scan_channel = chan;
 
-	local->scan_channel = chan;
-	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
-		skip = 1;
+		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
+			skip = 1;
 
-	/* advance state machine to next channel/band */
-	local->scan_channel_idx++;
+		/* advance state machine to next channel/band */
+		local->scan_channel_idx++;
 
-	if (skip) {
-		/* if we skip this channel return to the decision state */
-		local->next_scan_state = SCAN_DECISION;
-		return;
+		if (skip) {
+			/* if we skip this channel return to the decision
+			 * state */
+			local->next_scan_state = SCAN_DECISION;
+			return;
+		}
 	}
 
 	/*
@@ -615,6 +659,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		local->scanned_count++;
 		local->next_scan_state = SCAN_DECISION;
 		return;
 	}
@@ -637,6 +682,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len);
 
+	local->scanned_count++;
 	/*
 	 * After sending probe requests, wait for probe responses
 	 * on the channel.
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..1bfc1e0 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -910,12 +910,17 @@ static void ieee80211_work_work(struct work_struct *work)
 			 *	 happen to be on the same channel as
 			 *	 the requested channel
 			 */
-			ieee80211_offchannel_stop_beaconing(local);
-			ieee80211_offchannel_stop_station(local);
-
-			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
-			ieee80211_hw_config(local, 0);
+			if (!(wk->chan == local->scan_channel ||
+			      (wk->chan == local->oper_channel &&
+			       !local->scan_channel))) {
+				/* Only change channels if we need to */
+				ieee80211_offchannel_stop_beaconing(local);
+				ieee80211_offchannel_stop_station(local);
+
+				local->tmp_channel = wk->chan;
+				local->tmp_channel_type = wk->chan_type;
+				ieee80211_hw_config(local, 0);
+			}
 			started = true;
 			wk->timeout = jiffies;
 		}

--------------000602070802050906050008--
