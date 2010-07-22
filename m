Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55834 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0GVL7V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 07:59:21 -0400
Subject: [PATCH] cfg80211: fix IBSS default management key
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 13:59:15 +0200
Message-ID: <1279799955.12439.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When wireless extensions are used to control
an encrypted IBSS, we erroneously can try to
set the default management key. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ibss.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/ibss.c	2010-07-22 12:28:15.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2010-07-22 12:28:27.000000000 +0200
@@ -247,8 +247,10 @@ int cfg80211_ibss_wext_join(struct cfg80
 	if (!netif_running(wdev->netdev))
 		return 0;
 
-	if (wdev->wext.keys)
+	if (wdev->wext.keys) {
 		wdev->wext.keys->def = wdev->wext.default_key;
+		wdev->wext.keys->defmgmt = wdev->wext.default_mgmt_key;
+	}
 
 	wdev->wext.ibss.privacy = wdev->wext.default_key != -1;
 


