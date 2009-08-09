Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZHIJvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 05:51:36 -0400
Subject: [PATCH] cfg80211: add missing device list locking
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Aug 2009 11:51:29 +0200
Message-Id: <1249811489.4636.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When calling into the wext code from the NETDEV_UP
notifier, we need to hold the devlist_mtx mutex as
the wext code ends up calling into channel checks.

Reported-by: Kalle Valo <kalle.valo@iki.fi>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/wireless/core.c	2009-08-09 11:48:16.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-09 11:48:32.000000000 +0200
@@ -710,6 +710,7 @@ static int cfg80211_netdev_notifier_call
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
 		cfg80211_lock_rdev(rdev);
+		mutex_lock(&rdev->devlist_mtx);
 		wdev_lock(wdev);
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
@@ -722,6 +723,7 @@ static int cfg80211_netdev_notifier_call
 			break;
 		}
 		wdev_unlock(wdev);
+		mutex_unlock(&rdev->devlist_mtx);
 		cfg80211_unlock_rdev(rdev);
 #endif
 		break;


