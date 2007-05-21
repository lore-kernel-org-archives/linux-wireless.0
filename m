Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35259 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756335AbXEVHGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 03:06:16 -0400
Subject: [PATCH] mac80211: use debugfs_rename
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 21:04:53 +0200
Message-Id: <1179774293.6070.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new debugfs_rename function in mac80211's debugfs where
necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
debugfs_rename hasn't actually been merged yet, but I hope it will be
merged soon. URL is
http://article.gmane.org/gmane.linux.file-systems/14819

This patch should also apply against net-2.6

 net/mac80211/debugfs_netdev.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- wireless-dev.orig/net/mac80211/debugfs_netdev.c	2007-05-21 17:59:03.538418048 +0200
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-05-21 18:03:31.768418048 +0200
@@ -398,6 +398,8 @@ static int netdev_notify(struct notifier
 {
 	struct net_device *dev = ndev;
 	char buf[10+IFNAMSIZ];
+	struct dentry *dir;
+	struct ieee80211_sub_if_data *sdata;
 
 	if (state != NETDEV_CHANGENAME)
 		return 0;
@@ -408,10 +410,12 @@ static int netdev_notify(struct notifier
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


