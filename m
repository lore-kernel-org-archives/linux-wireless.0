Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbZDKLcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Apr 2009 07:32:51 -0400
Subject: [PATCH] cfg80211: convert mutex assert to macro
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 13:32:46 +0200
Message-Id: <1239449566.17031.40.camel@johannes.local> (sfid-20090411_133254_058378_8070CD59)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That will make the various cases where the WARN_ON
can happen distinguishable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/core.h	2009-04-11 13:31:00.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-04-11 13:31:20.000000000 +0200
@@ -73,10 +73,7 @@ bool wiphy_idx_valid(int wiphy_idx)
 extern struct mutex cfg80211_mutex;
 extern struct list_head cfg80211_drv_list;
 
-static inline void assert_cfg80211_lock(void)
-{
-	WARN_ON(!mutex_is_locked(&cfg80211_mutex));
-}
+#define assert_cfg80211_lock() WARN_ON(!mutex_is_locked(&cfg80211_mutex))
 
 /*
  * You can use this to mark a wiphy_idx as not having an associated wiphy.


