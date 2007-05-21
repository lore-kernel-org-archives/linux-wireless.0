Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbXEVHGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 03:06:16 -0400
Subject: [PATCH] cfg80211: use debugfs_rename
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 21 May 2007 21:04:15 +0200
Message-Id: <1179774255.6070.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the new debugfs_rename function in mac80211's debugfs where
necessary and fix a bug with renaming.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
debugfs_rename hasn't actually been merged yet, but I hope it will be
merged soon. URL is
http://article.gmane.org/gmane.linux.file-systems/14819

This patch should also apply against net-2.6 (with some fuzz though due
to the nl80211 bit)

 net/wireless/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/wireless/core.c	2007-05-21 18:37:40.541805077 +0200
+++ wireless-dev/net/wireless/core.c	2007-05-21 21:01:03.481611481 +0200
@@ -162,10 +162,15 @@ int cfg80211_dev_rename(struct cfg80211_
 
 	/* this will check for collisions */
 	result = device_rename(&rdev->wiphy.dev, newname);
-	if (!result)
+	if (result)
 		return result;
 
-	/* TODO: do debugfs rename! */
+	if (!debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
+			    rdev->wiphy.debugfsdir,
+			    rdev->wiphy.debugfsdir->d_parent,
+			    newname))
+		printk(KERN_ERR "cfg80211: failed to rename debugfs dir to %s!\n",
+		       newname);
 
 	nl80211_notify_dev_rename(rdev);
 


