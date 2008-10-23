Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbYJWHkF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 03:40:05 -0400
Subject: [PATCH] wireless: remove write-only 'granted' variable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Oct 2008 09:40:01 +0200
Message-Id: <1224747601.5865.29.camel@johannes.berg> (sfid-20081023_094013_748429_8CB5C27C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    2 --
 1 file changed, 2 deletions(-)

--- everything.orig/net/wireless/reg.c	2008-10-23 09:38:51.000000000 +0200
+++ everything/net/wireless/reg.c	2008-10-23 09:38:52.000000000 +0200
@@ -45,7 +45,6 @@
 /* wiphy is set if this request's initiator is REGDOM_SET_BY_DRIVER */
 struct regulatory_request {
 	struct wiphy *wiphy;
-	int granted;
 	enum reg_set_by initiator;
 	char alpha2[2];
 };
@@ -744,7 +743,6 @@ static int __set_regdom(const struct iee
 
 	/* Tada! */
 	cfg80211_regdomain = rd;
-	last_request->granted = 1;
 
 	return 0;
 }


