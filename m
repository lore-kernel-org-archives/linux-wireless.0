Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:60182 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab3LPPvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 10:51:06 -0500
Received: by mail-ee0-f42.google.com with SMTP id e53so2336063eek.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 07:51:05 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Marek Puzyniak <marek.puzyniak@tieto.com>
Subject: [PATCH v5] cfg80211: fix dfs channel state after stopping AP
Date: Mon, 16 Dec 2013 16:50:49 +0100
Message-Id: <1387209049-25529-1-git-send-email-marek.puzyniak@tieto.com> (sfid-20131216_165114_848530_B09F927E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode DFS channel state is changed to DFS_AVAILABLE
after successful CAC and remains as such until a radar
signal is detected during the In-Service Monitoring.
When AP is stopped it is no longer monitoring current channel
for radar signals. DFS channel state should be changed
to DFS_USABLE when last AP interface is stopped. Starting AP
again on that channel will start CAC instead of starting radiation.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
---

Patch v1:
*Initial version. Partially in mac80211 and cfg80211.

Patch v2:
*Moved all implementation to cfg80211.

Patch v3:
*Rephrase patch description.

Patch v4:
*Fix coding style,
*Do not check if RADAR flag is set, when dfs channel state was AVAILABLE
 change it to USABLE, 
*Handle multiBSSID APs - Change DFS channel state when last AP was stoped. 

Patch v5:
*Fix coding style,
*Remove unnecessary and nested wdev_lock.

 net/wireless/ap.c   | 36 ++++++++++++++++++++++++++++++++++++
 net/wireless/chan.c | 38 ++++++++++++++++++++++++++++++++++++++
 net/wireless/core.h | 11 +++++++++++
 3 files changed, 85 insertions(+)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 324e8d8..28d1a3c 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -6,6 +6,39 @@
 #include "rdev-ops.h"
 
 
+static bool cfg80211_is_last_ap_running(struct cfg80211_registered_device *rdev,
+					struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wireless_dev *wdev_iter;
+
+	ASSERT_WDEV_LOCK(wdev);
+
+	if (rdev->num_running_ifaces == 1) {
+		/* Last running AP iface */
+		return true;
+	}
+
+	/* More running interfaces */
+	list_for_each_entry(wdev_iter, &rdev->wdev_list, list) {
+		if (wdev_iter == wdev)
+			continue;
+
+		if (!wdev_iter->netdev)
+			continue;
+
+		if (!netif_running(wdev_iter->netdev)) {
+			continue;
+		}
+
+		if (wdev_iter->iftype == NL80211_IFTYPE_AP) {
+			return false;
+		}
+	}
+
+	return true;
+}
+
 static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 			      struct net_device *dev)
 {
@@ -31,6 +64,9 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 		wdev->ssid_len = 0;
 	}
 
+	if (cfg80211_is_last_ap_running(rdev, dev))
+		cfg80211_leave_dfs_chandef(wdev->wiphy, &wdev->preset_chandef);
+
 	return err;
 }
 
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 78559b5..54c217a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -490,6 +490,44 @@ static bool cfg80211_chandef_dfs_available(struct wiphy *wiphy,
 	return r;
 }
 
+static void cfg80211_leave_dfs_chans(struct wiphy *wiphy,
+				     u32 center_freq,
+				     u32 bandwidth)
+{
+	struct ieee80211_channel *c;
+	u32 freq, start_freq, end_freq;
+
+	start_freq = cfg80211_get_start_freq(center_freq, bandwidth);
+	end_freq = cfg80211_get_end_freq(center_freq, bandwidth);
+
+	for (freq = start_freq; freq <= end_freq; freq += 20) {
+		c = ieee80211_get_channel(wiphy, freq);
+		if (!c)
+			continue;
+		if (c->dfs_state != NL80211_DFS_AVAILABLE)
+			continue;
+
+		c->dfs_state = NL80211_DFS_USABLE;
+		c->dfs_state_entered = jiffies;
+	}
+}
+
+void cfg80211_leave_dfs_chandef(struct wiphy *wiphy,
+				struct cfg80211_chan_def *chandef)
+{
+	int width;
+
+	if (WARN_ON(!cfg80211_chandef_valid(chandef)))
+		return;
+
+	width = cfg80211_chandef_get_width(chandef);
+	cfg80211_leave_dfs_chans(wiphy, chandef->center_freq1, width);
+
+	if (!chandef->center_freq2)
+		return;
+
+	cfg80211_leave_dfs_chans(wiphy, chandef->center_freq2, width);
+}
 
 static bool cfg80211_secondary_chans_ok(struct wiphy *wiphy,
 					u32 center_freq, u32 bandwidth,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 37ec16d..4ed2c81 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -398,6 +398,17 @@ void cfg80211_set_dfs_state(struct wiphy *wiphy,
 
 void cfg80211_dfs_channels_update_work(struct work_struct *work);
 
+/**
+ * cfg80211_leave_dfs_chandef - Leaving dfs chandef
+ * @wiphy: the wiphy
+ * @chandef: chandef for the current channel
+ *
+ * This function is called when dfs chandef is being not used for different
+ * reasons. Change channels DFS_AVAILABLE to DFS_USABLE again. Leave channels
+ * DFS_UNAVAILABLE untouched.
+ */
+void cfg80211_leave_dfs_chandef(struct wiphy *wiphy,
+				struct cfg80211_chan_def *chandef);
 
 static inline int
 cfg80211_can_change_interface(struct cfg80211_registered_device *rdev,
-- 
1.8.1.2

