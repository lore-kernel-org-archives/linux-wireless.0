Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbZGJPxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 11:53:40 -0400
Subject: [PATCH] cfg80211: don't look at wdev->ssid for giwessid
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 17:53:34 +0200
Message-Id: <1247241214.29747.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This variable is only used internally, _while_ connected.
If we use it, the sequence

# iwconfig wlan1 essid foo
<connects>
# iwconfig wlan1 essid ""
<disconnects>
# iwconfig

will still display "foo" as the SSID afterwards, which
is obviously quite bogus. Fix this by only displaying
the wext SSID, if present.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/wext-sme.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-10 17:40:43.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-10 17:47:50.000000000 +0200
@@ -209,11 +209,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 	data->flags = 0;
 
 	wdev_lock(wdev);
-	if (wdev->ssid_len) {
-		data->flags = 1;
-		data->length = wdev->ssid_len;
-		memcpy(ssid, wdev->ssid, data->length);
-	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
+	if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
 		data->flags = 1;
 		data->length = wdev->wext.connect.ssid_len;
 		memcpy(ssid, wdev->wext.connect.ssid, data->length);


