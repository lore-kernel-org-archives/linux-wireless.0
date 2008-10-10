Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbYJJPwz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 11:52:55 -0400
Subject: [PATCH v2.6.27] mac80211: fix two issues in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: stable <stable@kernel.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 17:52:49 +0200
Message-Id: <1223653970.3748.23.camel@johannes.berg> (sfid-20081010_175259_315265_8BF6A0C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes RHBZ 466264, whenever the master interface is
renamed this code would BUG_ON. Also fixes a separately
reported bug with the debugfs dir being NULL.

This patch is not applicable to the next kernel version
because both these issues have been fixed, the first one
by not having the master interface have a ieee80211_ptr
at all, and the second one by also leaving the function
early.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>
---
 net/mac80211/debugfs_netdev.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- net-tx-2.6.orig/net/mac80211/debugfs_netdev.c	2008-10-10 17:46:50.000000000 +0200
+++ net-tx-2.6/net/mac80211/debugfs_netdev.c	2008-10-10 17:48:41.000000000 +0200
@@ -537,6 +537,7 @@ static int netdev_notify(struct notifier
 {
 	struct net_device *dev = ndev;
 	struct dentry *dir;
+	struct ieee80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	char buf[10+IFNAMSIZ];
 
@@ -549,10 +550,19 @@ static int netdev_notify(struct notifier
 	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
 		return 0;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	/*
+	 * Do not use IEEE80211_DEV_TO_SUB_IF because that
+	 * BUG_ONs for the master netdev which we need to
+	 * handle here.
+	 */
+	sdata = netdev_priv(dev);
 
-	sprintf(buf, "netdev:%s", dev->name);
 	dir = sdata->debugfsdir;
+
+	if (!dir)
+		return 0;
+
+	sprintf(buf, "netdev:%s", dev->name);
 	if (!debugfs_rename(dir->d_parent, dir, dir->d_parent, buf))
 		printk(KERN_ERR "mac80211: debugfs: failed to rename debugfs "
 		       "dir to %s\n", buf);


