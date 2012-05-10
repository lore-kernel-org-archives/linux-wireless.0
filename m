Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754754Ab2EJSOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 14:14:43 -0400
Message-ID: <1336673683.4334.30.camel@jlt3.sipsolutions.net> (sfid-20120510_201447_641863_6C0B4BEF)
Subject: [PATCH] nl80211: prevent additions to old station flags API
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 10 May 2012 20:14:43 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We don't really want/need to maintain the old
station flags API any more, so refuse changes
to new (not yet defined) flags from the old
flags API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    2 ++
 net/wireless/nl80211.c  |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/nl80211.h	2012-05-08 13:02:00.000000000 +0200
+++ b/include/linux/nl80211.h	2012-05-08 20:37:33.000000000 +0200
@@ -1594,6 +1594,8 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MAX = __NL80211_STA_FLAG_AFTER_LAST - 1
 };
 
+#define NL80211_STA_FLAG_MAX_OLD_API	NL80211_STA_FLAG_TDLS_PEER
+
 /**
  * struct nl80211_sta_flag_update - station flags mask/set
  * @mask: mask of station flags to set
--- a/net/wireless/nl80211.c	2012-05-08 13:02:00.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-05-08 20:37:33.000000000 +0200
@@ -2370,10 +2370,16 @@ static int parse_station_flags(struct ge
 		return -EINVAL;
 	}
 
-	for (flag = 1; flag <= NL80211_STA_FLAG_MAX; flag++)
-		if (flags[flag])
+	for (flag = 1; flag <= NL80211_STA_FLAG_MAX; flag++) {
+		if (flags[flag]) {
 			params->sta_flags_set |= (1<<flag);
 
+			/* no longer support new API additions in old API */
+			if (flag > NL80211_STA_FLAG_MAX_OLD_API)
+				return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 


