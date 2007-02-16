Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946091AbXBPVKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 16:10:10 -0500
Subject: [PATCH/RFT] fix wiphy_create/wiphy_free sequence
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 22:09:59 +0100
Message-Id: <1171660199.3575.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Big bad oops when you did wiphy_create/wiphy_free without registering it
inbetween. This should fix it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Please commit if it does fix the issue, I don't have the hw and don't
feel like writing a dummy driver just to test this :)

 net/wireless/core.c  |    6 ++++--
 net/wireless/sysfs.c |   14 +-------------
 net/wireless/sysfs.h |    3 +--
 3 files changed, 6 insertions(+), 17 deletions(-)

--- wireless-dev.orig/net/wireless/core.c	2007-02-16 22:03:41.944695664 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-16 22:07:00.154695664 +0100
@@ -173,6 +173,8 @@ struct wiphy *wiphy_new(struct cfg80211_
 
 	mutex_init(&drv->mtx);
 
+	drv->wiphy.class_dev.class = &ieee80211_class;
+	drv->wiphy.class_dev.class_data = &drv->wiphy;
 	class_device_initialize(&drv->wiphy.class_dev);
 
 	return &drv->wiphy;
@@ -187,7 +189,7 @@ int wiphy_register(struct wiphy *wiphy)
 	mutex_lock(&cfg80211_drv_mutex);
 
 
-	res = wiphy_sysfs_add(&drv->wiphy);
+	res = class_device_add(&drv->wiphy.class_dev);
 	if (res)
 		goto out_unlock;
 
@@ -217,7 +219,7 @@ void wiphy_unregister(struct wiphy *wiph
 	list_del(&drv->list);
 	mutex_unlock(&drv->mtx);
 
-	wiphy_sysfs_del(wiphy);
+	class_device_del(&drv->wiphy.class_dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
 
 	mutex_unlock(&cfg80211_drv_mutex);
--- wireless-dev.orig/net/wireless/sysfs.c	2007-02-16 22:03:37.204695664 +0100
+++ wireless-dev/net/wireless/sysfs.c	2007-02-16 22:06:21.334695664 +0100
@@ -52,7 +52,7 @@ static int wiphy_uevent(struct class_dev
 	return 0;
 }
 
-static struct class ieee80211_class = {
+struct class ieee80211_class = {
 	.name = "ieee80211",
 	.owner = THIS_MODULE,
 	.release = wiphy_class_dev_release,
@@ -71,15 +71,3 @@ void wiphy_sysfs_exit(void)
 {
 	class_unregister(&ieee80211_class);
 }
-
-int wiphy_sysfs_add(struct wiphy *wiphy)
-{
-	wiphy->class_dev.class = &ieee80211_class;
-	wiphy->class_dev.class_data = wiphy;
-	return class_device_add(&wiphy->class_dev);
-}
-
-void wiphy_sysfs_del(struct wiphy *wiphy)
-{
-	class_device_del(&wiphy->class_dev);
-}
--- wireless-dev.orig/net/wireless/sysfs.h	2007-02-16 22:04:53.794695664 +0100
+++ wireless-dev/net/wireless/sysfs.h	2007-02-16 22:05:09.534695664 +0100
@@ -4,7 +4,6 @@
 extern int wiphy_sysfs_init(void);
 extern void wiphy_sysfs_exit(void);
 
-extern int wiphy_sysfs_add(struct wiphy *wiphy);
-extern void wiphy_sysfs_del(struct wiphy *wiphy);
+extern struct class ieee80211_class;
 
 #endif /* __WIRELESS_SYSFS_H */


