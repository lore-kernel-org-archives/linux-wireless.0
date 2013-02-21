Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab3BUK3f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 05:29:35 -0500
Date: Thu, 21 Feb 2013 11:29:40 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/2] mac80211: disconnect on suspend in managed mode
Message-ID: <20130221102939.GA19443@redhat.com> (sfid-20130221_112944_147032_F32C2469)
References: <20130219164714.GA27140@redhat.com>
 <1361354804.8629.15.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361354804.8629.15.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 20, 2013 at 11:06:44AM +0100, Johannes Berg wrote:
> On Tue, 2013-02-19 at 17:47 +0100, Stanislaw Gruszka wrote:
> > If possible that after suspend cfg80211 receive request to disconnect
> > what require action on interface that was removed during suspend.
> > Problem can manifest itself by various warnings similar to below one:
> [...]
> > To fix the problem disconnect from AP during suspend.
> 
> This will fix the immediate problem, but not in general. What if we're
> joined to an IBSS while suspending? A similar thing could happen. Or
> operating as an AP? Or joined to a mesh? etc.
> 
> I think it'd be better to implement this as explicit disconnect, leave,
> teardown, whatever ... in cfg80211 rather than mac80211, although then
> of course mac80211 could have a bunch of cleanups, e.g. the various
> _quiesce functions could be reduced then I think.

Ok, I have below patch:

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5ffff03..5a4dc09 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -815,6 +815,46 @@ void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 		rdev->num_running_monitor_ifaces += num;
 }
 
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		   struct wireless_dev *wdev)
+{
+	struct net_device *dev = wdev->netdev;
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+		cfg80211_leave_ibss(rdev, dev, true);
+		break;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_STATION:
+		mutex_lock(&rdev->sched_scan_mtx);
+		__cfg80211_stop_sched_scan(rdev, false);
+		mutex_unlock(&rdev->sched_scan_mtx);
+
+		wdev_lock(wdev);
+#ifdef CONFIG_CFG80211_WEXT
+		kfree(wdev->wext.ie);
+		wdev->wext.ie = NULL;
+		wdev->wext.ie_len = 0;
+		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
+#endif
+		__cfg80211_disconnect(rdev, dev,
+				      WLAN_REASON_DEAUTH_LEAVING, true);
+		cfg80211_mlme_down(rdev, dev);
+		wdev_unlock(wdev);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		cfg80211_leave_mesh(rdev, dev);
+		break;
+	case NL80211_IFTYPE_AP:
+		cfg80211_stop_ap(rdev, dev);
+		break;
+	default:
+		break;
+	}
+
+	wdev->beacon_interval = 0;
+}
+
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state,
 					 void *ndev)
@@ -883,38 +923,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 		break;
 	case NETDEV_GOING_DOWN:
-		switch (wdev->iftype) {
-		case NL80211_IFTYPE_ADHOC:
-			cfg80211_leave_ibss(rdev, dev, true);
-			break;
-		case NL80211_IFTYPE_P2P_CLIENT:
-		case NL80211_IFTYPE_STATION:
-			mutex_lock(&rdev->sched_scan_mtx);
-			__cfg80211_stop_sched_scan(rdev, false);
-			mutex_unlock(&rdev->sched_scan_mtx);
-
-			wdev_lock(wdev);
-#ifdef CONFIG_CFG80211_WEXT
-			kfree(wdev->wext.ie);
-			wdev->wext.ie = NULL;
-			wdev->wext.ie_len = 0;
-			wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
-#endif
-			__cfg80211_disconnect(rdev, dev,
-					      WLAN_REASON_DEAUTH_LEAVING, true);
-			cfg80211_mlme_down(rdev, dev);
-			wdev_unlock(wdev);
-			break;
-		case NL80211_IFTYPE_MESH_POINT:
-			cfg80211_leave_mesh(rdev, dev);
-			break;
-		case NL80211_IFTYPE_AP:
-			cfg80211_stop_ap(rdev, dev);
-			break;
-		default:
-			break;
-		}
-		wdev->beacon_interval = 0;
+		cfg80211_leave(rdev, wdev);
 		break;
 	case NETDEV_DOWN:
 		cfg80211_update_iface_num(rdev, wdev->iftype, -1);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3aec0e4..878d204 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -503,6 +503,9 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
 
+void cfg80211_leave(struct cfg80211_registered_device *rdev,
+		   struct wireless_dev *wdev);
+
 #define CFG80211_MAX_NUM_DIFFERENT_CHANNELS 10
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 238ee49..64e951f 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -86,16 +86,21 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 static int wiphy_suspend(struct device *dev, pm_message_t state)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
+	struct wireless_dev *wdev;
 	int ret = 0;
 
 	rdev->suspend_at = get_seconds();
 
-	if (rdev->ops->suspend) {
-		rtnl_lock();
-		if (rdev->wiphy.registered)
+	rtnl_lock();
+	if (rdev->wiphy.registered) {
+		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
+			cfg80211_leave(rdev, wdev);
+
+		if (rdev->ops->suspend)
 			ret = rdev_suspend(rdev);
-		rtnl_unlock();
+
 	}
+	rtnl_unlock();
 
 	return ret;
 }
