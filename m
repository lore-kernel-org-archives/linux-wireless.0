Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57616 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZIQPg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 11:36:28 -0400
Subject: [PATCH] cfg80211: wext: don't display BSSID unless associated
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Thomas H. Guenther" <thomas.h.guenther@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 08:35:54 -0700
Message-Id: <1253201754.9450.18.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, cfg80211's SIOCGIWAP implementation returns
the BSSID that the user set, even if the connection has
since been dropped due to other changes. It only should
return the current BSSID when actually connected.

Also do a small code cleanup.

Reported-by: Thomas H. Guenther <thomas.h.guenther@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Thomas H. Guenther <thomas.h.guenther@intel.com>
---
 net/wireless/wext-sme.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-09-15 21:20:09.000000000 -0700
+++ wireless-testing/net/wireless/wext-sme.c	2009-09-15 21:20:50.000000000 -0700
@@ -229,8 +229,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 		data->flags = 1;
 		data->length = wdev->wext.connect.ssid_len;
 		memcpy(ssid, wdev->wext.connect.ssid, data->length);
-	} else
-		data->flags = 0;
+	}
 	wdev_unlock(wdev);
 
 	return 0;
@@ -306,8 +305,6 @@ int cfg80211_mgd_wext_giwap(struct net_d
 	wdev_lock(wdev);
 	if (wdev->current_bss)
 		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
-	else if (wdev->wext.connect.bssid)
-		memcpy(ap_addr->sa_data, wdev->wext.connect.bssid, ETH_ALEN);
 	else
 		memset(ap_addr->sa_data, 0, ETH_ALEN);
 	wdev_unlock(wdev);


