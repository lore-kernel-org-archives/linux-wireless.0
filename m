Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZIRAP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 20:15:59 -0400
Subject: [PATCH] cfg80211: don't overwrite privacy setting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ASIC Felix <ic.felix@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 17:15:31 -0700
Message-Id: <1253232931.23567.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cfg80211 is instructed to connect, it always
uses the default WEP key for the privacy setting,
which clearly is wrong when using wpa_supplicant.
Don't overwrite the setting, and rely on it being
false when wpa_supplicant is not running, instead
set it to true when we have keys.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-09-17 17:12:03.000000000 -0700
+++ wireless-testing/net/wireless/wext-sme.c	2009-09-17 17:12:53.000000000 -0700
@@ -26,11 +26,11 @@ int cfg80211_mgd_wext_connect(struct cfg
 
 	wdev->wext.connect.ie = wdev->wext.ie;
 	wdev->wext.connect.ie_len = wdev->wext.ie_len;
-	wdev->wext.connect.privacy = wdev->wext.default_key != -1;
 
 	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
 		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
+		wdev->wext.connect.privacy = true;
 	}
 
 	if (!wdev->wext.connect.ssid_len)


