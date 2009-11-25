Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp104.plus.mail.re1.yahoo.com ([69.147.102.67]:49082 "HELO
	smtp104.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758456AbZKYOTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 09:19:38 -0500
Message-ID: <4B0D3B6C.60309@yahoo.com>
Date: Wed, 25 Nov 2009 15:13:00 +0100
From: Alban Browaeys <prahal@yahoo.com>
Reply-To: prahal@yahoo.com
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] wireless : use a dedicated workqueue for cfg80211.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the works cleanup, scan and events to a cfg80211
dedicated workqueue.

Platform driver like eeepc-laptop ought to use works to rfkill (as
new rfkill does lock in rfkill_unregister and the platform driver is
called from rfkill_switch_all which also lock the same mutex).
This raise a new issue in itself that the work scheduled by the platform
driver to the global worqueue calls wiphy_unregister which flush_work
scan and event works (which thus flush works on the global workqueue inside
a work on the global workqueue) and also put on hold the  wdev_cleanup_work
 (which prevents the dev_put on netdev thus indefinite Usage count error on
wifi device).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Alban Browaeys <prahal@yahoo.com>
---
 net/wireless/core.c |   12 +++++++++++-
 net/wireless/core.h |    2 ++
 net/wireless/ibss.c |    2 +-
 net/wireless/scan.c |    2 +-
 net/wireless/sme.c  |    6 +++---
 5 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 44b2ea5..c674567 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -45,6 +45,9 @@ DEFINE_MUTEX(cfg80211_mutex);
 /* for debugfs */
 static struct dentry *ieee80211_debugfs_dir;
 
+/* for the cleanup, scan and event works */
+struct workqueue_struct *cfg80211_wq;
+
 /* requires cfg80211_mutex to be held! */
 struct cfg80211_registered_device *cfg80211_rdev_by_wiphy_idx(int wiphy_idx)
 {
@@ -720,7 +723,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block * nb,
 		break;
 	case NETDEV_DOWN:
 		dev_hold(dev);
-		schedule_work(&wdev->cleanup_work);
+		queue_work(cfg80211_wq, &wdev->cleanup_work);
 		break;
 	case NETDEV_UP:
 		/*
@@ -838,8 +841,14 @@ static int __init cfg80211_init(void)
 	if (err)
 		goto out_fail_reg;
 
+	cfg80211_wq = create_singlethread_workqueue("cfg80211");
+	if (!cfg80211_wq)
+		goto out_fail_wq;
+
 	return 0;
 
+out_fail_wq:
+	regulatory_exit();
 out_fail_reg:
 	debugfs_remove(ieee80211_debugfs_dir);
 out_fail_nl80211:
@@ -861,5 +870,6 @@ static void cfg80211_exit(void)
 	wiphy_sysfs_exit();
 	regulatory_exit();
 	unregister_pernet_device(&cfg80211_pernet_ops);
+	destroy_workqueue(cfg80211_wq);
 }
 module_exit(cfg80211_exit);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index a9db9e6..4ef3efc 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -91,6 +91,8 @@ bool wiphy_idx_valid(int wiphy_idx)
 	return (wiphy_idx >= 0);
 }
 
+
+extern struct workqueue_struct *cfg80211_wq;
 extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_rdev_list;
 extern int cfg80211_rdev_list_generation;
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 34dfc93..6ef5a49 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -70,7 +70,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
-	schedule_work(&rdev->event_work);
+	queue_work(cfg80211_wq, &rdev->event_work);
 }
 EXPORT_SYMBOL(cfg80211_ibss_joined);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 227d57b..df26228 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -88,7 +88,7 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
 
 	request->aborted = aborted;
-	schedule_work(&wiphy_to_dev(request->wiphy)->scan_done_wk);
+	queue_work(cfg80211_wq, &wiphy_to_dev(request->wiphy)->scan_done_wk);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 0115d07..2333d78 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -488,7 +488,7 @@ void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
-	schedule_work(&rdev->event_work);
+	queue_work(cfg80211_wq, &rdev->event_work);
 }
 EXPORT_SYMBOL(cfg80211_connect_result);
 
@@ -583,7 +583,7 @@ void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
-	schedule_work(&rdev->event_work);
+	queue_work(cfg80211_wq, &rdev->event_work);
 }
 EXPORT_SYMBOL(cfg80211_roamed);
 
@@ -681,7 +681,7 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
 	spin_lock_irqsave(&wdev->event_lock, flags);
 	list_add_tail(&ev->list, &wdev->event_list);
 	spin_unlock_irqrestore(&wdev->event_lock, flags);
-	schedule_work(&rdev->event_work);
+	queue_work(cfg80211_wq, &rdev->event_work);
 }
 EXPORT_SYMBOL(cfg80211_disconnected);
 
-- 
1.6.5.3

