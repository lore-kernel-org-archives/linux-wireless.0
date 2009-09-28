Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbZI1IWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 04:22:16 -0400
Subject: [PATCH 2/2] cfg80211: fix wireless handlers assignment
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Sep 2009 10:21:57 +0200
Message-Id: <1254126117.6583.19.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The point we assign dev->wireless_handlers at is too
late, we need to do that before netdev_register_kobject()
gets called, so use the new NETDEV_PRE_INIT notifier.
The result of adding wireless_handlers too late is the
disappearance of /sys/class/net/wlan0/wireless which a
bunch of distro scripts still require.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-09-28 09:54:52.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-09-28 10:18:47.000000000 +0200
@@ -641,6 +641,12 @@ static int cfg80211_netdev_notifier_call
 	WARN_ON(wdev->iftype == NL80211_IFTYPE_UNSPECIFIED);
 
 	switch (state) {
+	case NETDEV_POST_INIT:
+#ifdef CONFIG_WIRELESS_EXT
+		if (!dev->wireless_handlers)
+			dev->wireless_handlers = &cfg80211_wext_handler;
+#endif
+		break;
 	case NETDEV_REGISTER:
 		/*
 		 * NB: cannot take rdev->mtx here because this may be
@@ -666,8 +672,6 @@ static int cfg80211_netdev_notifier_call
 		wdev->sme_state = CFG80211_SME_IDLE;
 		mutex_unlock(&rdev->devlist_mtx);
 #ifdef CONFIG_WIRELESS_EXT
-		if (!dev->wireless_handlers)
-			dev->wireless_handlers = &cfg80211_wext_handler;
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;


