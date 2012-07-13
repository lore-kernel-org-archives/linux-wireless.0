Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526Ab2GML6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 07:58:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] cfg80211: reduce monitor interface tracking
Date: Fri, 13 Jul 2012 13:58:50 +0200
Message-Id: <1342180730-19987-4-git-send-email-johannes@sipsolutions.net> (sfid-20120713_135904_578509_4729C0EC)
In-Reply-To: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
References: <1342180730-19987-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Revert commit b78e8ceac23655e1e06b30aa95ab11742d1ac7c0
("cfg80211: track monitor channel") and remove the
set_monitor_enabled() callback.

Due to the tracking happening in NETDEV_PRE_UP, it had
introduced bugs because the monitor interface callback
would be called before the device was started. It looks
like there's no way to fix this, and using NETDEV_PRE_UP
is broken anyway (since there's no NETDEV_UP_FAIL), so
remove all that code, track interfaces in NETDEV_UP and
also stop tracking the monitor channel in cfg80211.

This mostly reverts to before the tracking, except that
we keep the interface count tracking so that setting the
monitor channel can be rejected properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h |    4 ----
 net/wireless/chan.c    |    9 +--------
 net/wireless/core.c    |   48 +-----------------------------------------------
 net/wireless/core.h    |    3 ---
 4 files changed, 2 insertions(+), 62 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8115d68..0245208 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1504,8 +1504,6 @@ struct cfg80211_gtk_rekey_data {
  *	interfaces are active this callback should reject the configuration.
  *	If no interfaces are active or the device is down, the channel should
  *	be stored for when a monitor interface becomes active.
- * @set_monitor_enabled: Notify driver that there are only monitor
- *	interfaces running.
  *
  * @scan: Request to do a scan. If returning zero, the scan request is given
  *	the driver, and will be valid until passed to cfg80211_scan_done().
@@ -1824,8 +1822,6 @@ struct cfg80211_ops {
 	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
 				  u32 sset, u8 *data);
 
-	void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
-
 	struct ieee80211_channel *
 		(*get_channel)(struct wiphy *wiphy,
 			       struct wireless_dev *wdev,
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index a16cdff..d355f67 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -82,7 +82,6 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 				 int freq, enum nl80211_channel_type chantype)
 {
 	struct ieee80211_channel *chan;
-	int err;
 
 	if (!rdev->ops->set_monitor_channel)
 		return -EOPNOTSUPP;
@@ -93,13 +92,7 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 	if (!chan)
 		return -EINVAL;
 
-	err = rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
-	if (!err) {
-		rdev->monitor_channel = chan;
-		rdev->monitor_channel_type = chantype;
-	}
-
-	return err;
+	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
 }
 
 void
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 0557bb1..71b684b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -736,60 +736,14 @@ static struct device_type wiphy_type = {
 	.name	= "wlan",
 };
 
-static struct ieee80211_channel *
-cfg80211_get_any_chan(struct cfg80211_registered_device *rdev)
-{
-	struct ieee80211_supported_band *sband;
-	int i;
-
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
-		sband = rdev->wiphy.bands[i];
-		if (sband && sband->n_channels > 0)
-			return &sband->channels[0];
-	}
-
-	return NULL;
-}
-
-static void cfg80211_init_mon_chan(struct cfg80211_registered_device *rdev)
-{
-	struct ieee80211_channel *chan;
-
-	chan = cfg80211_get_any_chan(rdev);
-	if (WARN_ON(!chan))
-		return;
-
-	mutex_lock(&rdev->devlist_mtx);
-	WARN_ON(cfg80211_set_monitor_channel(rdev, chan->center_freq,
-					     NL80211_CHAN_NO_HT));
-	mutex_unlock(&rdev->devlist_mtx);
-}
-
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num)
 {
-	bool has_monitors_only_old = cfg80211_has_monitors_only(rdev);
-	bool has_monitors_only_new;
-
 	ASSERT_RTNL();
 
 	rdev->num_running_ifaces += num;
 	if (iftype == NL80211_IFTYPE_MONITOR)
 		rdev->num_running_monitor_ifaces += num;
-
-	has_monitors_only_new = cfg80211_has_monitors_only(rdev);
-	if (has_monitors_only_new != has_monitors_only_old) {
-		if (rdev->ops->set_monitor_enabled)
-			rdev->ops->set_monitor_enabled(&rdev->wiphy,
-						       has_monitors_only_new);
-
-		if (!has_monitors_only_new) {
-			rdev->monitor_channel = NULL;
-			rdev->monitor_channel_type = NL80211_CHAN_NO_HT;
-		} else {
-			cfg80211_init_mon_chan(rdev);
-		}
-	}
 }
 
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
@@ -912,6 +866,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			mutex_unlock(&rdev->devlist_mtx);
 			dev_put(dev);
 		}
+		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
 		wdev_lock(wdev);
@@ -1006,7 +961,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		mutex_unlock(&rdev->devlist_mtx);
 		if (ret)
 			return notifier_from_errno(ret);
-		cfg80211_update_iface_num(rdev, wdev->iftype, 1);
 		break;
 	}
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index bac97da..5206c68 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -61,9 +61,6 @@ struct cfg80211_registered_device {
 	int num_running_ifaces;
 	int num_running_monitor_ifaces;
 
-	struct ieee80211_channel *monitor_channel;
-	enum nl80211_channel_type monitor_channel_type;
-
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
 	struct list_head bss_list;
-- 
1.7.10.4

