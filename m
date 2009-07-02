Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZGBNtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 09:49:00 -0400
Subject: [PATCH] cfg80211: reset auth algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 15:49:03 +0200
Message-Id: <1246542543.16770.40.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the interface is brought down, we need to
reset the auth algorithm because wpa_supplicant
doesn't reset it, and then we fail to use shared
key auth when required later.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/net/wireless/core.c	2009-07-02 15:47:06.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-02 15:47:52.000000000 +0200
@@ -579,6 +579,7 @@ static int cfg80211_netdev_notifier_call
 			kfree(wdev->wext.ie);
 			wdev->wext.ie = NULL;
 			wdev->wext.ie_len = 0;
+			wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 #endif
 			cfg80211_disconnect(rdev, dev,
 					    WLAN_REASON_DEAUTH_LEAVING, true);


