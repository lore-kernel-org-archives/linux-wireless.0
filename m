Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33464 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbYJHISi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 04:18:38 -0400
Subject: [PATCH] mac80211: fix debugfs netdev rename
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Robin Holt <holt@sgi.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 10:18:36 +0200
Message-Id: <1223453916.3618.34.camel@johannes.berg> (sfid-20081008_101842_479697_970B922D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If, for some reason, a netdev has no debugfs dir, we shouldn't
try to rename that dir.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Robin Holt <holt@sgi.com>
---
Robin, ok, I was wrong, this might be causing it...

 net/mac80211/debugfs_netdev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/debugfs_netdev.c	2008-10-08 10:08:23.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-10-08 10:08:37.000000000 +0200
@@ -481,8 +481,12 @@ static int netdev_notify(struct notifier
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
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


