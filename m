Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51555 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbYLALJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:09:47 -0500
Subject: [PATCH] cfg80211: fix wiphy remove if no regulatory request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 01 Dec 2008 12:07:56 +0100
Message-Id: <1228129676.3478.0.camel@johannes.berg> (sfid-20081201_120949_625505_34962DA0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes the segfault I just pointed out.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/wireless/reg.c	2008-12-01 11:59:18.000000000 +0100
+++ everything/net/wireless/reg.c	2008-12-01 11:59:30.000000000 +0100
@@ -1330,7 +1330,7 @@ int set_regdom(const struct ieee80211_re
 /* Caller must hold cfg80211_drv_mutex */
 void reg_device_remove(struct wiphy *wiphy)
 {
-	if (!last_request->wiphy)
+	if (!last_request || !last_request->wiphy)
 		return;
 	if (last_request->wiphy != wiphy)
 		return;


