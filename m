Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43405 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbZIXHBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 03:01:01 -0400
Subject: [PATCH] cfg80211: don't set privacy w/o key
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Sep 2009 09:00:57 +0200
Message-Id: <1253775657.3868.8.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When wpa_supplicant is used to connect to open networks,
it causes the wdev->wext.keys to point to key memory, but
that key memory is all empty. Only use privacy when there
is a default key to be used.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Never happened of course with iw ...

 net/wireless/wext-sme.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/wext-sme.c	2009-09-24 08:51:14.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-09-24 08:57:01.000000000 +0200
@@ -30,7 +30,8 @@ int cfg80211_mgd_wext_connect(struct cfg
 	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
 		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
-		wdev->wext.connect.privacy = true;
+		if (wdev->wext.default_key != -1)
+			wdev->wext.connect.privacy = true;
 	}
 
 	if (!wdev->wext.connect.ssid_len)


