Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38579 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab0I3TUz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 15:20:55 -0400
Subject: [PATCH] cfg80211: remove spurious __KERNEL__ ifdef
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Joe Perches <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 21:21:25 +0200
Message-ID: <1285874485.5137.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The net/cfg80211.h header file isn't exported to
userspace, so there's no need for any kind of
__KERNEL__ protection in it. If it was exported,
everything else in it would need protection as
well, not just the logging stuff ...

Cc:Joe Perches <joe@perches.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Might be something that slipped in elsewhere too?

 include/net/cfg80211.h |    4 ----
 1 file changed, 4 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2010-09-30 21:18:46.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2010-09-30 21:18:51.000000000 +0200
@@ -2551,8 +2551,6 @@ void cfg80211_cqm_rssi_notify(struct net
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
 			      gfp_t gfp);
 
-#ifdef __KERNEL__
-
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
@@ -2599,6 +2597,4 @@ void cfg80211_cqm_rssi_notify(struct net
 #define wiphy_WARN(wiphy, format, args...)			\
 	WARN(1, "wiphy: %s\n" format, wiphy_name(wiphy), ##args);
 
-#endif
-
 #endif /* __NET_CFG80211_H */


