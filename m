Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab0AKPPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2010 10:15:05 -0500
Subject: [PATCH 2.6.33] cfg80211: fix refcount imbalance when wext is
 disabled
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Jan 2010 16:14:57 +0100
Message-ID: <1263222897.29743.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When CONFIG_CFG80211_WEXT is not set, there is
a refcount imbalance with rdev->opencount, fix
that by moving it out of the ifdef.

Reported-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2010-01-11 16:11:50.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2010-01-11 16:12:04.000000000 +0100
@@ -745,9 +745,9 @@ static int cfg80211_netdev_notifier_call
 			mutex_unlock(&rdev->devlist_mtx);
 			dev_put(dev);
 		}
-#ifdef CONFIG_CFG80211_WEXT
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
+#ifdef CONFIG_CFG80211_WEXT
 		wdev_lock(wdev);
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
@@ -760,10 +760,10 @@ static int cfg80211_netdev_notifier_call
 			break;
 		}
 		wdev_unlock(wdev);
+#endif
 		rdev->opencount++;
 		mutex_unlock(&rdev->devlist_mtx);
 		cfg80211_unlock_rdev(rdev);
-#endif
 		break;
 	case NETDEV_UNREGISTER:
 		/*


