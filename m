Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:44652 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaA2N2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 08:28:11 -0500
Received: by mail-ee0-f52.google.com with SMTP id e53so887158eek.25
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 05:28:10 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] cfg80211: consider existing DFS interfaces
Date: Wed, 29 Jan 2014 14:22:27 +0100
Message-Id: <1391001747-9442-1-git-send-email-michal.kazior@tieto.com> (sfid-20140129_142817_065831_6DE97D84)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to break interface combinations in
the following way:

 combo 1: iftype = AP, num_ifaces = 2, num_chans = 2,
 combo 2: iftype = AP, num_ifaces = 1, num_chans = 1, radar = HT20

With the above interface combinations it was
possible to:

 step 1. start AP on DFS channel by matching combo 2
 step 2. start AP on non-DFS channel by matching combo 1

This was possible beacuse (step 2) did not consider
if other interfaces require radar detection.

The patch changes how cfg80211 tracks channels -
instead of channel itself now a complete chandef
is stored.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h |  8 +++-----
 net/wireless/ap.c      |  2 +-
 net/wireless/chan.c    | 23 +++++++++++++++++++----
 net/wireless/core.h    |  3 ++-
 net/wireless/ibss.c    |  2 ++
 net/wireless/mesh.c    |  6 +++---
 net/wireless/mlme.c    |  2 +-
 net/wireless/nl80211.c |  6 +++---
 net/wireless/util.c    |  2 +-
 9 files changed, 35 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 459700e..09aed62 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3146,8 +3146,8 @@ struct cfg80211_cached_keys;
  * @identifier: (private) Identifier used in nl80211 to identify this
  *	wireless device if it has no netdev
  * @current_bss: (private) Used by the internal configuration code
- * @channel: (private) Used by the internal configuration code to track
- *	the user-set AP, monitor and WDS channel
+ * @chandef: (private) Used by the internal configuration code to track
+ *	the user-set channel definition.
  * @preset_chandef: (private) Used by the internal configuration code to
  *	track the channel to be used for AP later
  * @bssid: (private) Used by the internal configuration code
@@ -3211,9 +3211,7 @@ struct wireless_dev {
 
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
 	struct cfg80211_chan_def preset_chandef;
-
-	/* for AP and mesh channel tracking */
-	struct ieee80211_channel *channel;
+	struct cfg80211_chan_def chandef;
 
 	bool ibss_fixed;
 	bool ibss_dfs_possible;
diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 4760d65..68602be 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -27,7 +27,7 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 	err = rdev_stop_ap(rdev, dev);
 	if (!err) {
 		wdev->beacon_interval = 0;
-		wdev->channel = NULL;
+		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 		wdev->ssid_len = 0;
 		rdev_set_qos_map(rdev, dev, NULL);
 		nl80211_send_ap_stopped(wdev);
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..f8ab7df 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -642,7 +642,8 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 void
 cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        struct ieee80211_channel **chan,
-		        enum cfg80211_chan_mode *chanmode)
+		        enum cfg80211_chan_mode *chanmode,
+		        u8 *radar_detect)
 {
 	*chan = NULL;
 	*chanmode = CHAN_MODE_UNDEFINED;
@@ -660,6 +661,11 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 				     !wdev->ibss_dfs_possible)
 				  ? CHAN_MODE_SHARED
 				  : CHAN_MODE_EXCLUSIVE;
+
+			/* consider worst-case - IBSS can try to return to the
+			 * original user-specified channel as creator */
+			if (wdev->ibss_dfs_possible)
+				*radar_detect |= BIT(wdev->chandef.width);
 			return;
 		}
 		break;
@@ -674,17 +680,26 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_P2P_GO:
 		if (wdev->cac_started) {
-			*chan = wdev->channel;
+			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
+			*radar_detect |= BIT(wdev->chandef.width);
 		} else if (wdev->beacon_interval) {
-			*chan = wdev->channel;
+			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
+
+			if (cfg80211_chandef_dfs_required(wdev->wiphy,
+							  &wdev->chandef))
+				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (wdev->mesh_id_len) {
-			*chan = wdev->channel;
+			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
+
+			if (cfg80211_chandef_dfs_required(wdev->wiphy,
+							  &wdev->chandef))
+				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
 	case NL80211_IFTYPE_MONITOR:
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 37ec16d..b4eca21 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -441,7 +441,8 @@ static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
 void
 cfg80211_get_chan_state(struct wireless_dev *wdev,
 		        struct ieee80211_channel **chan,
-		        enum cfg80211_chan_mode *chanmode);
+		        enum cfg80211_chan_mode *chanmode,
+		        u8 *radar_detect);
 
 int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 struct cfg80211_chan_def *chandef);
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index f911c5f..5e4dd03 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -117,6 +117,7 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 
 	wdev->ibss_fixed = params->channel_fixed;
 	wdev->ibss_dfs_possible = params->userspace_handles_dfs;
+	wdev->chandef = params->chandef;
 #ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.chandef = params->chandef;
 #endif
@@ -200,6 +201,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
+	memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 #ifdef CONFIG_CFG80211_WEXT
 	if (!nowext)
 		wdev->wext.ibss.ssid_len = 0;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 8858624..d42a3fc 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -195,7 +195,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
 		wdev->mesh_id_len = setup->mesh_id_len;
-		wdev->channel = setup->chandef.chan;
+		wdev->chandef = setup->chandef;
 	}
 
 	return err;
@@ -244,7 +244,7 @@ int cfg80211_set_mesh_channel(struct cfg80211_registered_device *rdev,
 		err = rdev_libertas_set_mesh_channel(rdev, wdev->netdev,
 						     chandef->chan);
 		if (!err)
-			wdev->channel = chandef->chan;
+			wdev->chandef = *chandef;
 
 		return err;
 	}
@@ -276,7 +276,7 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 	err = rdev_leave_mesh(rdev, dev);
 	if (!err) {
 		wdev->mesh_id_len = 0;
-		wdev->channel = NULL;
+		memset(&wdev->chandef, 0, sizeof(wdev->chandef));
 		rdev_set_qos_map(rdev, dev, NULL);
 	}
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 52cca05..d47c9d1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -772,7 +772,7 @@ void cfg80211_cac_event(struct net_device *netdev,
 	if (WARN_ON(!wdev->cac_started))
 		return;
 
-	if (WARN_ON(!wdev->channel))
+	if (WARN_ON(!wdev->chandef.chan))
 		return;
 
 	switch (event) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6753203..7f6cd3a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3309,7 +3309,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!err) {
 		wdev->preset_chandef = params.chandef;
 		wdev->beacon_interval = params.beacon_interval;
-		wdev->channel = params.chandef.chan;
+		wdev->chandef = params.chandef;
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
@@ -5825,7 +5825,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 
 	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef);
 	if (!err) {
-		wdev->channel = chandef.chan;
+		wdev->chandef = chandef;
 		wdev->cac_started = true;
 		wdev->cac_start_time = jiffies;
 	}
@@ -11243,7 +11243,7 @@ void cfg80211_ch_switch_notify(struct net_device *dev,
 		    wdev->iftype != NL80211_IFTYPE_MESH_POINT))
 		return;
 
-	wdev->channel = chandef->chan;
+	wdev->chandef = *chandef;
 	nl80211_ch_switch_notify(rdev, dev, chandef, GFP_KERNEL);
 }
 EXPORT_SYMBOL(cfg80211_ch_switch_notify);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d39c371..847bed7 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1356,7 +1356,7 @@ int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 		 */
 		mutex_lock_nested(&wdev_iter->mtx, 1);
 		__acquire(wdev_iter->mtx);
-		cfg80211_get_chan_state(wdev_iter, &ch, &chmode);
+		cfg80211_get_chan_state(wdev_iter, &ch, &chmode, &radar_detect);
 		wdev_unlock(wdev_iter);
 
 		switch (chmode) {
-- 
1.8.5.3

