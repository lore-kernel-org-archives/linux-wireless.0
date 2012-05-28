Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62995 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753703Ab2E1LTj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 07:19:39 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 07/14] cfg80211: track monitor interfaces count
Date: Mon, 28 May 2012 13:18:55 +0200
Message-ID: <1338203942-5667-8-git-send-email-michal.kazior@tieto.com> (sfid-20120528_132046_407011_ABB7DCFF)
In-Reply-To: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
References: <1338203942-5667-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implements .set_monitor_enabled(wiphy, enabled).

Notifies driver upon change of interface layout.

If only monitor interfaces become present it is
called with 2nd argument being true. If
non-monitor interface appears then 2nd argument
is false. Driver is notified only upon change.

This makes it more obvious about the fact that
cfg80211 supports single monitor channel. Once we
implement multi-channel we don't want to allow
setting monitor channel while other interface
types are running. Otherwise it would be ambiguous
once we start considering num_different_channels.

Change-Id: Ibd82a70c256c2de584eb541ea2c36663a59f09d4
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h |    4 ++++
 net/wireless/core.c    |   18 ++++++++++++++++++
 net/wireless/core.h    |    9 +++++++++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0f9d7b4..e2da8e4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1428,6 +1428,8 @@ struct cfg80211_gtk_rekey_data {
  *	interfaces are active this callback should reject the configuration.
  *	If no interfaces are active or the device is down, the channel should
  *	be stored for when a monitor interface becomes active.
+ * @set_monitor_enabled: Notify driver that there are only monitor
+ *	interfaces running.
  * @get_channel: Get the current operating channel, should return %NULL if
  *	there's no single defined operating channel if for example the
  *	device implements channel hopping for multi-channel virtual interfaces.
@@ -1746,6 +1748,8 @@ struct cfg80211_ops {
 				struct ethtool_stats *stats, u64 *data);
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
+
+	void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
 };
 
 /*
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 46a33ea..5b37047 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -776,6 +776,22 @@ static struct device_type wiphy_type = {
 	.name	= "wlan",
 };
 
+static void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
+				      struct wireless_dev *wdev, int num)
+{
+	bool has_monitors_only_old = cfg80211_has_monitors_only(rdev);
+	bool has_monitors_only_new;
+
+	rdev->num_running_ifaces += num;
+	if (wdev->iftype == NL80211_IFTYPE_MONITOR)
+		rdev->num_running_monitor_ifaces += num;
+
+	has_monitors_only_new = cfg80211_has_monitors_only(rdev);
+	if (has_monitors_only_new != has_monitors_only_old)
+		rdev->ops->set_monitor_enabled(&rdev->wiphy,
+					       has_monitors_only_new);
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state,
 					 void *ndev)
@@ -879,6 +895,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_DOWN:
 		dev_hold(dev);
+		cfg80211_update_iface_num(rdev, wdev, -1);
 		queue_work(cfg80211_wq, &wdev->cleanup_work);
 		break;
 	case NETDEV_UP:
@@ -986,6 +1003,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
 		if (ret)
 			return notifier_from_errno(ret);
+		cfg80211_update_iface_num(rdev, wdev, 1);
 		break;
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 54c24de..79e27b1 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -56,6 +56,9 @@ struct cfg80211_registered_device {
 
 	u32 ap_beacons_nlpid;
 
+	int num_running_ifaces;
+	int num_running_monitor_ifaces;
+
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
 	struct list_head bss_list;
@@ -220,6 +223,12 @@ static inline void wdev_unlock(struct wireless_dev *wdev)
 	mutex_unlock(&wdev->mtx);
 }
 
+static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
+{
+	return rdev->num_running_ifaces == rdev->num_running_monitor_ifaces &&
+	       rdev->num_running_ifaces > 0;
+}
+
 #define ASSERT_RDEV_LOCK(rdev) lockdep_assert_held(&(rdev)->mtx)
 #define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
 
-- 
1.7.0.4

