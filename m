Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXFVIji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:39:38 -0400
Subject: [PATCH] cfg80211: use debugfs_rename
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 18:30:57 +0200
Message-Id: <1182443457.21939.47.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
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
 


