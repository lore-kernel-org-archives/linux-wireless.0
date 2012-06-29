Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:62843 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab2F2Kr0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 06:47:26 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 06/13] cfg80211: track monitor interfaces count
Date: Fri, 29 Jun 2012 12:47:01 +0200
Message-ID: <1340966828-22874-7-git-send-email-michal.kazior@tieto.com> (sfid-20120629_124751_534585_B013D05F)
In-Reply-To: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
References: <1340966828-22874-1-git-send-email-michal.kazior@tieto.com>
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

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/cfg80211.h |    4 ++++
 net/wireless/core.c    |   24 ++++++++++++++++++++++++
 net/wireless/core.h    |   14 ++++++++++++++
 net/wireless/util.c    |    5 +++++
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e030c6a..f0d213d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1499,6 +1499,8 @@ struct cfg80211_gtk_rekey_data {
  *	interfaces are active this callback should reject the configuration.
  *	If no interfaces are active or the device is down, the channel should
  *	be stored for when a monitor interface becomes active.
+ * @set_monitor_enabled: Notify driver that there are only monitor
+ *	interfaces running.
  * @get_channel: Get the current operating channel, should return %NULL if
  *	there's no single defined operating channel if for example the
  *	device implements channel hopping for multi-channel virtual interfaces.
@@ -1817,6 +1819,8 @@ struct cfg80211_ops {
 				struct ethtool_stats *stats, u64 *data);
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
+
+	void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
 };
 
 /*
diff --git a/net/wireless/core.c b/net/wireless/core.c
index c65f59c..8412da7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -717,6 +717,24 @@ static struct device_type wiphy_type = {
 	.name	= "wlan",
 };
 
+void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
+			       enum nl80211_iftype iftype, int num)
+{
+	bool has_monitors_only_old = cfg80211_has_monitors_only(rdev);
+	bool has_monitors_only_new;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	rdev->num_running_ifaces += num;
+	if (iftype == NL80211_IFTYPE_MONITOR)
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
@@ -820,6 +838,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		break;
 	case NETDEV_DOWN:
 		dev_hold(dev);
+		cfg80211_lock_rdev(rdev);
+		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
+		cfg80211_unlock_rdev(rdev);
 		queue_work(cfg80211_wq, &wdev->cleanup_work);
 		break;
 	case NETDEV_UP:
@@ -927,6 +948,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		ret = cfg80211_can_add_interface(rdev, wdev->iftype);
 		if (ret)
 			return notifier_from_errno(ret);
+		cfg80211_lock_rdev(rdev);
+		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
+		cfg80211_unlock_rdev(rdev);
 		break;
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 56f18c2..99acd51 100644
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
@@ -197,6 +200,14 @@ static inline void wdev_unlock(struct wireless_dev *wdev)
 #define ASSERT_RDEV_LOCK(rdev) lockdep_assert_held(&(rdev)->mtx)
 #define ASSERT_WDEV_LOCK(wdev) lockdep_assert_held(&(wdev)->mtx)
 
+static inline bool cfg80211_has_monitors_only(struct cfg80211_registered_device *rdev)
+{
+	ASSERT_RDEV_LOCK(rdev);
+
+	return rdev->num_running_ifaces == rdev->num_running_monitor_ifaces &&
+	       rdev->num_running_ifaces > 0;
+}
+
 enum cfg80211_event_type {
 	EVENT_CONNECT_RESULT,
 	EVENT_ROAMED,
@@ -444,6 +455,9 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int);
 
+void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
+			       enum nl80211_iftype iftype, int num);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
diff --git a/net/wireless/util.c b/net/wireless/util.c
index fc948d0..9b92ec5 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -871,6 +871,11 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		}
 	}
 
+	if (!err && ntype != otype && netif_running(dev)) {
+		cfg80211_update_iface_num(rdev, ntype, 1);
+		cfg80211_update_iface_num(rdev, otype, -1);
+	}
+
 	return err;
 }
 
-- 
1.7.0.4

