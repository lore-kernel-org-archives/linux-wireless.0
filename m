Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44837 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab1EPWv7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 18:51:59 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] wireless: Support can-scan-one logic.
Date: Mon, 16 May 2011 15:51:36 -0700
Message-Id: <1305586296-23147-1-git-send-email-greearb@candelatech.com> (sfid-20110517_005202_689056_9240F1AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Enable this by passing a -1 for a scan frequency.

When enabled, the system will only scan the current active
channel if at least one VIF is actively using it.  If no
VIFS are active or this flag is disabled, then default
behaviour is used.

This helps when using multiple STA interfaces that otherwise might
constantly be trying to scan all channels.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Remove verbose printk commands, fix up comment syntax.

:100644 100644 c32e683... c0be322... M	include/net/cfg80211.h
:100644 100644 489b6ad... d00287f... M	net/mac80211/scan.c
:100644 100644 0a199a1... c0b9cad... M	net/wireless/nl80211.c
:100644 100644 e17b0be... 9044120... M	net/wireless/sme.c
 include/net/cfg80211.h |    3 +++
 net/mac80211/scan.c    |   42 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c |   22 ++++++++++++++++++++--
 net/wireless/sme.c     |    6 ++++++
 4 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c32e683..c0be322 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -780,6 +780,8 @@ struct cfg80211_ssid {
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @aborted: (internal) scan request was notified as aborted
+ * @can_scan_one:  If true, only scan active channel if at least one
+ *       vif is already associated.
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -792,6 +794,7 @@ struct cfg80211_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	bool aborted;
+	bool can_scan_one;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 489b6ad..d00287f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -353,6 +353,48 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 	 * nullfunc frames and probe requests will be dropped in
 	 * ieee80211_tx_h_check_assoc().
 	 */
+	int associated_station_vifs = 0;
+	int running_station_vifs = 0; /* not necessarily associated */
+	int running_other_vifs = 0; /* AP, etc */
+	struct ieee80211_sub_if_data *sdata;
+
+	if (local->scan_req->can_scan_one && local->scan_req->n_channels >= 1) {
+		struct sta_info *sta;
+		mutex_lock(&local->iflist_mtx);
+		list_for_each_entry(sdata, &local->interfaces, list) {
+			if (!ieee80211_sdata_running(sdata))
+				continue;
+
+			if (sdata->vif.type == NL80211_IFTYPE_STATION)
+				running_station_vifs++;
+			else
+				running_other_vifs++;
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
+				associated_station_vifs++;
+		}
+		rcu_read_unlock();
+
+		/*
+		 * If one sta is associated, we don't want another to start
+		 * scanning on all channels, as that will interfere with the
+		 * one already associated.
+		 */
+		if ((running_other_vifs > 0) ||
+		    (associated_station_vifs > 1)) {
+			local->scan_req->channels[0] = local->hw.conf.channel;
+			local->scan_req->n_channels = 1;
+		}
+	}
+
 	drv_sw_scan_start(local);
 
 	local->leave_oper_channel_time = 0;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0a199a1..c0b9cad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3176,6 +3176,9 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	int n_channels = 0, tmp1, tmp2;
 
 	nla_for_each_nested(attr1, freqs, tmp1) {
+		if (nla_get_u32(attr1) == 0xFFFFFFFF)
+			continue; /* skip can-scan-one flag */
+
 		n_channels++;
 		/*
 		 * Some hardware has a limited channel list for
@@ -3207,6 +3210,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	int err, tmp, n_ssids = 0, n_channels, i;
 	enum ieee80211_band band;
 	size_t ie_len;
+	bool do_all_chan = true;
 
 	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
 		return -EINVAL;
@@ -3223,8 +3227,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		n_channels = validate_scan_freqs(
 				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
 		if (!n_channels)
-			return -EINVAL;
+			goto auto_channels;
 	} else {
+auto_channels:
 		n_channels = 0;
 
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
@@ -3270,6 +3275,17 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_FREQUENCIES], tmp) {
 			struct ieee80211_channel *chan;
 
+			/*
+			 * Special hack:  channel -1 means 'scan only active
+			 * channel if any VIFs on this device are associated
+			 * on the channel.
+			 */
+			if (nla_get_u32(attr) == 0xFFFFFFFF) {
+				request->can_scan_one = true;
+				continue;
+			}
+
+			do_all_chan = false;
 			chan = ieee80211_get_channel(wiphy, nla_get_u32(attr));
 
 			if (!chan) {
@@ -3284,7 +3300,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 			request->channels[i] = chan;
 			i++;
 		}
-	} else {
+	}
+
+	if (do_all_chan) {
 		/* all channels */
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 			int j;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index e17b0be..9044120 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -105,6 +105,12 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	if (!request)
 		return -ENOMEM;
 
+	/*
+	 * If at least one VIF on this hardware is already associated, then
+	 * only scan on the active channel.
+	 */
+	request->can_scan_one = true;
+
 	if (wdev->conn->params.channel)
 		request->channels[0] = wdev->conn->params.channel;
 	else {
-- 
1.7.3.4

