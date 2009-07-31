Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52528 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZGaJSs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 05:18:48 -0400
Subject: [PATCH] cfg80211: lower dynamic PS timeout to 100ms
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 11:18:13 +0200
Message-Id: <1249031893.29587.63.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default of 500ms is pretty high, and leads
to the device being awake at least 50% of the
time under such light traffic conditions as a
simple 1 second interval ping. Reduce to just
100ms -- it should have a similar effect while
providing a better sleep time.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-31 11:15:32.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-31 11:15:40.000000000 +0200
@@ -673,7 +673,7 @@ static int cfg80211_netdev_notifier_call
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 		wdev->wext.ps = CONFIG_CFG80211_DEFAULT_PS_VALUE;
-		wdev->wext.ps_timeout = 500;
+		wdev->wext.ps_timeout = 100;
 		if (rdev->ops->set_power_mgmt)
 			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
 						      wdev->wext.ps,


