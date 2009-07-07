Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbZGGCAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:08 -0400
Message-Id: <20090707015708.306828606@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:06 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] cfg80211: dont use union for wext
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise it becomes very hard to reset the structs
correctly since wext can be configured while the
interface is down.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-07 03:37:04.000000000 +0200
@@ -1270,10 +1270,8 @@ struct wireless_dev {
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
 	struct {
-		union {
-			struct cfg80211_ibss_params ibss;
-			struct cfg80211_connect_params connect;
-		};
+		struct cfg80211_ibss_params ibss;
+		struct cfg80211_connect_params connect;
 		u8 *ie;
 		size_t ie_len;
 		u8 bssid[ETH_ALEN];

-- 

