Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554AbYBAMJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:09:10 -0500
Subject: [PATCH] mac80211: fix initialisation error path
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 19:33:53 +0100
Message-Id: <1201804433.4149.36.camel@johannes.berg> (sfid-20080201_120919_851407_D59A1879)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The error handling in ieee80211_init() is broken when any of
the built-in rate control algorithms fail to initialise, fix
it and rename the error labels.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- everything.orig/net/mac80211/ieee80211.c	2008-01-31 19:30:42.162269153 +0100
+++ everything/net/mac80211/ieee80211.c	2008-01-31 19:31:21.572266440 +0100
@@ -1684,28 +1684,28 @@ static int __init ieee80211_init(void)
 
 	ret = rc80211_simple_init();
 	if (ret)
-		goto fail;
+		goto out;
 
 	ret = rc80211_pid_init();
 	if (ret)
-		goto fail_simple;
+		goto out_cleanup_simple;
 
 	ret = ieee80211_wme_register();
 	if (ret) {
 		printk(KERN_DEBUG "ieee80211_init: failed to "
 		       "initialize WME (err=%d)\n", ret);
-		goto fail_pid;
+		goto out_cleanup_pid;
 	}
 
 	ieee80211_debugfs_netdev_init();
 
 	return 0;
 
- fail_pid:
-	rc80211_simple_exit();
- fail_simple:
+ out_cleanup_pid:
 	rc80211_pid_exit();
- fail:
+ out_cleanup_simple:
+	rc80211_simple_exit();
+ out:
 	return ret;
 }
 


