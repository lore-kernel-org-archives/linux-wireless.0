Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876AbZGGCAG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:06 -0400
Message-Id: <20090707015708.142063056@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:05 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/9] cfg80211: fix netdev down problem
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We shouldn't be looking at the ssid_len for non-IBSS,
and for IBSS we should also return an error on trying
to leave an IBSS while not in or joining an IBSS.

This fixes an issue where we wouldn't disconnect() on
an interface being taken down since there's no SSID
configured this way.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    3 ---
 net/wireless/ibss.c |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-07 03:37:03.000000000 +0200
@@ -567,9 +567,6 @@ static int cfg80211_netdev_notifier_call
 #endif
 		break;
 	case NETDEV_GOING_DOWN:
-		if (!wdev->ssid_len)
-			break;
-
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
 			cfg80211_leave_ibss(rdev, dev, true);
--- wireless-testing.orig/net/wireless/ibss.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-07-07 03:37:03.000000000 +0200
@@ -92,8 +92,12 @@ void cfg80211_clear_ibss(struct net_devi
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext)
 {
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	if (!wdev->ssid_len)
+		return -ENOLINK;
+
 	err = rdev->ops->leave_ibss(&rdev->wiphy, dev);
 
 	if (err)

-- 

