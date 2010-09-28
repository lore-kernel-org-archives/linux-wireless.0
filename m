Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33569 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab0I1VRg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 17:17:36 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v3] mac80211:  Allow scanning single channel if other VIF is associated.
Date: Tue, 28 Sep 2010 14:17:30 -0700
Message-Id: <1285708650-21858-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This patch aims to decrease channel switching when there is at least one
interface associated.  This should help multiple station interfaces co-exist
on the same hardware, especially in WPA mode.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2 -> v3:  Just check can_scan_one flag and if set and there is
   a vif associated, select the active channel as scan-channel and
   let core scanning logic function as designed.

   This gets much of the really ugly logic changes out of the
   scanning core, and any optimizations to this should help
   general purpose scanning on a single channel as well.

:100644 100644 f0518b0... 7ecf8b0... M	include/linux/nl80211.h
:100644 100644 a0613ff... f355b8c... M	include/net/cfg80211.h
:100644 100644 8b733cf... 6323954... M	net/mac80211/mlme.c
:100644 100644 0b0e83e... 318b2de... M	net/mac80211/rx.c
:100644 100644 57b5e66... accd1c3... M	net/mac80211/scan.c
:100644 100644 ae344d1... 1bfc1e0... M	net/mac80211/work.c
:100644 100644 4ff827e... b45646e... M	net/wireless/nl80211.c
:100644 100644 f161b98... 87b0cd7... M	net/wireless/sme.c
 include/linux/nl80211.h |    2 +
 include/net/cfg80211.h  |    3 ++
 net/mac80211/mlme.c     |   14 ++++++-----
 net/mac80211/rx.c       |    2 +-
 net/mac80211/scan.c     |   57 +++++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/work.c     |   17 +++++++++-----
 net/wireless/nl80211.c  |    6 +++++
 net/wireless/sme.c      |    5 ++++
 8 files changed, 89 insertions(+), 17 deletions(-)

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
index 57b5e66..accd1c3 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -301,6 +301,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 
 	drv_sw_scan_complete(local);
 
+	/* TODO:  Don't call this if we never left the channel?? */
 	ieee80211_offchannel_return(local, true);
 
  done:
@@ -341,13 +342,55 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
+	int avifs = 0;
+	int svifs = 0;
+	struct ieee80211_sub_if_data *sdata;
+
+	if (local->scan_req->can_scan_one && local->scan_req->n_channels >= 1) {
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
+		if ((avifs > 1) || ((avifs == 1) && (svifs > 1))) {
+			local->scan_req->channels[0] = local->hw.conf.channel;
+			local->scan_req->n_channels = 1;
+		}
+	}
+
 	drv_sw_scan_start(local);
 
+	/* TODO:  If we are scanning one channel, and only our own channel
+	 * then probably don't need to do these next two lines.
+	 */
 	ieee80211_offchannel_stop_beaconing(local);
-
 	local->leave_oper_channel_time = 0;
-	local->next_scan_state = SCAN_DECISION;
+
 	local->scan_channel_idx = 0;
+	local->next_scan_state = SCAN_DECISION;
 
 	drv_flush(local, false);
 
@@ -529,8 +572,11 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 			local->next_scan_state = SCAN_SET_CHANNEL;
 	} else {
 		/*
-		 * we're on the operating channel currently, let's
-		 * leave that channel now to scan another one
+		 * we're on the operating channel currently, Leave that
+		 * channel if we are not probing the single channel.
+		 */
+		/* TODO:  If we are scanning one channel, and it's our operating
+		 * channel, then we are not really leaving it.
 		 */
 		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
 	}
@@ -573,6 +619,9 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 	 * Only re-enable station mode interface now; beaconing will be
 	 * re-enabled once the full scan has been completed.
 	 */
+	/* TODO:  We only return if we ever left, and should never leave if
+	 * scanning single channel that is also the operating channel.
+	 */
 	ieee80211_offchannel_return(local, false);
 
 	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
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

