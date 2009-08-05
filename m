Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933168AbZHECEN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 22:04:13 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] wireless: display wext SSID when connected by cfg80211
Date: Wed,  5 Aug 2009 10:05:50 +0800
Message-Id: <1249437950-8059-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211 displays correct link info when connected by wext. But if
the connection is setup by cfg80211, wext cannot display the SSID.
This patch fixed this issue.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 7bacbd1..48c165b 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -210,6 +210,10 @@ int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 		data->flags = 1;
 		data->length = wdev->wext.connect.ssid_len;
 		memcpy(ssid, wdev->wext.connect.ssid, data->length);
+	} else if (wdev->ssid && wdev->ssid_len) {
+		data->flags = 1;
+		data->length = wdev->ssid_len;
+		memcpy(ssid, wdev->ssid, data->length);
 	} else
 		data->flags = 0;
 	wdev_unlock(wdev);
