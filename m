Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbYJHIXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 04:23:47 -0400
Subject: [PATCH] cfg80211: fix debugfs error handling
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 10:23:48 +0200
Message-Id: <1223454228.3618.36.camel@johannes.berg> (sfid-20081008_102353_116365_591C6294)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If something goes wrong creating the debugfs dir or when
debugfs is not compiled in, the current code might lead to
trouble; make it more robust.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- everything.orig/net/wireless/core.c	2008-10-08 10:13:49.000000000 +0200
+++ everything/net/wireless/core.c	2008-10-08 10:19:10.000000000 +0200
@@ -185,7 +185,8 @@ int cfg80211_dev_rename(struct cfg80211_
 	if (result)
 		goto out_unlock;
 
-	if (!debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
+	if (rdev->wiphy.debugfsdir &&
+	    !debugfs_rename(rdev->wiphy.debugfsdir->d_parent,
 			    rdev->wiphy.debugfsdir,
 			    rdev->wiphy.debugfsdir->d_parent,
 			    newname))
@@ -318,6 +319,8 @@ int wiphy_register(struct wiphy *wiphy)
 	drv->wiphy.debugfsdir =
 		debugfs_create_dir(wiphy_name(&drv->wiphy),
 				   ieee80211_debugfs_dir);
+	if (IS_ERR(drv->wiphy.debugfsdir))
+		drv->wiphy.debugfsdir = NULL;
 
 	res = 0;
 out_unlock:


