Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab2DFR5c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 13:57:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SGDPe-0006tF-Sb
	for linux-wireless@vger.kernel.org; Fri, 06 Apr 2012 19:57:30 +0200
Message-ID: <1333735050.5577.6.camel@jlt3.sipsolutions.net> (sfid-20120406_195736_030132_AAD420FB)
Subject: [RFC] nl80211: prevent additions to old station flags API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 06 Apr 2012 19:57:30 +0200
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

--- a/include/linux/nl80211.h	2012-04-06 19:03:06.000000000 +0200
+++ b/include/linux/nl80211.h	2012-04-06 19:03:09.000000000 +0200
@@ -1587,6 +1587,8 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MAX = __NL80211_STA_FLAG_AFTER_LAST - 1
 };
 
+#define NL80211_STA_FLAG_MAX_OLD_API	NL80211_STA_FLAG_TDLS_PEER
+
 /**
  * struct nl80211_sta_flag_update - station flags mask/set
  * @mask: mask of station flags to set
--- a/net/wireless/nl80211.c	2012-04-06 19:03:06.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-04-06 19:03:09.000000000 +0200
@@ -2357,10 +2357,16 @@ static int parse_station_flags(struct ge
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
 


