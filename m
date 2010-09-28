Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45869 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759803Ab0I1AHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 20:07:50 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] mac80211:  Allow scanning single channel if other VIF is associated.
Date: Mon, 27 Sep 2010 17:07:37 -0700
Message-Id: <1285632457-27539-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This patch aims to decrease channel switching when there is at least one
interface associated.  This should help multiple station interfaces co-exist
on the same hardware, especially in WPA mode.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 f0518b0... 7ecf8b0... M	include/linux/nl80211.h
:100644 100644 a0613ff... f355b8c... M	include/net/cfg80211.h
:100644 100644 945fbf2... ac720d2... M	net/mac80211/ieee80211_i.h
:100644 100644 8b733cf... 6323954... M	net/mac80211/mlme.c
:100644 100644 0b0e83e... 318b2de... M	net/mac80211/rx.c
:100644 100644 57b5e66... 59d5925... M	net/mac80211/scan.c
:100644 100644 ae344d1... 1bfc1e0... M	net/mac80211/work.c
:100644 100644 4ff827e... b45646e... M	net/wireless/nl80211.c
:100644 100644 f161b98... 87b0cd7... M	net/wireless/sme.c
 include/linux/nl80211.h    |    2 +
 include/net/cfg80211.h     |    3 +
 net/mac80211/ieee80211_i.h |    2 +
 net/mac80211/mlme.c        |   14 +++--
 net/mac80211/rx.c          |    2 +-
 net/mac80211/scan.c        |  110 +++++++++++++++++++++++++++++++++-----------
 net/mac80211/work.c        |   17 ++++--
 net/wireless/nl80211.c     |    6 ++
 net/wireless/sme.c         |    5 ++
 9 files changed, 121 insertions(+), 40 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f0518b0..7ecf8b0 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -965,6 +965,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_CONTROL_PORT_ETHERTYPE,
 	NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT,
 
+	NL80211_ATTR_SCAN_ONE_IF_ASSOC,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a0613ff..f355b8c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -667,6 +667,8 @@ struct cfg80211_ssid {
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
+ * @can_scan_one:  If true, only scan active channel if at least one
+ *       vif is already associated.
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -679,6 +681,7 @@ struct cfg80211_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	bool aborted;
+	bool can_scan_one;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 945fbf2..ac720d2 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -815,6 +815,8 @@ struct ieee80211_local {
 	enum ieee80211_band hw_scan_band;
 	int scan_channel_idx;
 	int scan_ies_len;
+	int scanned_count; /* how many channels scanned so far in this scan */
+	bool scan_probe_once; /* if true, scan only the current channel. */
 
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8b733cf..6323954 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1863,10 +1863,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
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
@@ -1876,9 +1877,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
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
index 0b0e83e..318b2de 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2407,7 +2407,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 	do {				\
 		res = rxh(rx);		\
 		if (res != RX_CONTINUE)	\
-			goto rxh_next;  \
+			goto rxh_next;	\
 	} while (0);
 
 	while ((skb = __skb_dequeue(frames))) {
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 57b5e66..59d5925 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -293,7 +293,9 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 	/* we only have to protect scan_req and hw/sw scan */
 	mutex_unlock(&local->mtx);
 
-	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+	if (!local->scan_probe_once)
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
+
 	if (was_hw_scan)
 		goto done;
 
@@ -301,7 +303,8 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	drv_sw_scan_complete(local);
 
-	ieee80211_offchannel_return(local, true);
+	if (!local->scan_probe_once)
+		ieee80211_offchannel_return(local, true);
 
  done:
 	mutex_lock(&local->mtx);
@@ -341,13 +344,53 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
-	drv_sw_scan_start(local);
+	int avifs = 0;
+	int svifs = 0;
+	struct ieee80211_sub_if_data *sdata;
+
+	local->scan_probe_once = false;
+	if (local->scan_req->can_scan_one) {
+		struct sta_info *sta;
+		mutex_lock(&local->iflist_mtx);
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+
+			if (sdata->vif.type != NL80211_IFTYPE_STATION)
+				avifs++;
+			else
+				svifs++;
+		}
+		mutex_unlock(&local->iflist_mtx);
+
+		rcu_read_lock();
+		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+			if (!ieee80211_sdata_running(sta->sdata))
+				continue;
+			if (sta->sdata->vif.type != NL80211_IFTYPE_STATION)
+				continue;
+			if (test_sta_flags(sta, WLAN_STA_ASSOC))
+				avifs++;
+		}
+		rcu_read_unlock();
+
+		/* If one sta is associated, we don't want another to start
+		 * scanning on all channels, as that will interfere with the
+		 * one already associated.
+		 */
+		if ((avifs > 1) || ((avifs == 1) && (svifs > 1)))
+			local->scan_probe_once = true;
+	}
 
-	ieee80211_offchannel_stop_beaconing(local);
+	drv_sw_scan_start(local);
 
-	local->leave_oper_channel_time = 0;
+	if (!local->scan_probe_once) {
+		ieee80211_offchannel_stop_beaconing(local);
+		local->leave_oper_channel_time = 0;
+		local->scan_channel_idx = 0;
+	}
+	local->scanned_count = 0;
 	local->next_scan_state = SCAN_DECISION;
-	local->scan_channel_idx = 0;
 
 	drv_flush(local, false);
 
@@ -460,7 +503,8 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	struct ieee80211_channel *next_chan;
 
 	/* if no more bands/channels left, complete scan and advance to the idle state */
-	if (local->scan_channel_idx >= local->scan_req->n_channels) {
+	if ((local->scan_channel_idx >= local->scan_req->n_channels) ||
+	    (local->scanned_count && local->scan_probe_once)) {
 		__ieee80211_scan_completed(&local->hw, false);
 		return 1;
 	}
@@ -529,10 +573,13 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
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
@@ -567,14 +614,15 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
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
@@ -588,19 +636,25 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
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
@@ -616,6 +670,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	if (chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
 	    !local->scan_req->n_ssids) {
 		*next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
+		local->scanned_count++;
 		local->next_scan_state = SCAN_DECISION;
 		return;
 	}
@@ -638,6 +693,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4ff827e..b45646e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -138,6 +138,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_CONTROL_PORT] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CONTROL_PORT_ETHERTYPE] = { .type = NLA_U16 },
 	[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SCAN_ONE_IF_ASSOC] = { .type = NLA_FLAG },
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
@@ -3217,6 +3218,11 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_ONE_IF_ASSOC])
+		request->can_scan_one = true;
+	else
+		request->can_scan_one = false;
+
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
 	request->n_ssids = n_ssids;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f161b98..87b0cd7 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -105,6 +105,11 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	if (!request)
 		return -ENOMEM;
 
+	/* If at least one VIF on this hardware is already associated, then
+	 * only scan on the active channel.
+	 */
+	request->can_scan_one = true;
+
 	if (wdev->conn->params.channel)
 		request->channels[0] = wdev->conn->params.channel;
 	else {
-- 
1.7.2.2

