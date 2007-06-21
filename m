Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33734 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbXFVIjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:39:19 -0400
Subject: [PATCH] mac80211: use debugfs_rename
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 18:30:19 +0200
Message-Id: <1182443419.21939.44.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/debugfs_netdev.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-06-13 22:45:54.798817885 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-06-13 23:06:25.448817885 +0200
@@ -734,9 +734,9 @@ static int netdev_notify(struct notifier
 			 void *ndev)
 {
 	struct net_device *dev = ndev;
-	/* TODO
 	char buf[10+IFNAMSIZ];
-	*/
+	struct dentry *dir;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (state != NETDEV_CHANGENAME)
 		return 0;
@@ -747,10 +747,12 @@ static int netdev_notify(struct notifier
 	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
 		return 0;
 
-	/* TODO
 	sprintf(buf, "netdev:%s", dev->name);
-	debugfs_rename(IEEE80211_DEV_TO_SUB_IF(dev)->debugfsdir, buf);
-	*/
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	dir = sdata->debugfsdir;
+	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
+		printk(KERN_ERR "mac80211: debugfs: failed to rename debugfs "
+		       "dir to %s\n", buf);
 
 	return 0;
 }


