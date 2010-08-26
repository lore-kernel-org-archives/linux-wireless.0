Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47488 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905Ab0HZLfm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 07:35:42 -0400
Message-Id: <20100826113438.251820520@sipsolutions.net>
Date: Thu, 26 Aug 2010 13:30:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: remove unused scan expire define
References: <20100826113024.738612439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since cfg80211 manages the BSS list completely,
this define hasn't been used for a long time
and will never be used again.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    6 ------
 1 file changed, 6 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-08-26 13:10:20.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-08-26 13:10:24.000000000 +0200
@@ -50,12 +50,6 @@ struct ieee80211_local;
  * increased memory use (about 2 kB of RAM per entry). */
 #define IEEE80211_FRAGMENT_MAX 4
 
-/*
- * Time after which we ignore scan results and no longer report/use
- * them in any way.
- */
-#define IEEE80211_SCAN_RESULT_EXPIRE (10 * HZ)
-
 #define TU_TO_EXP_TIME(x)	(jiffies + usecs_to_jiffies((x) * 1024))
 
 #define IEEE80211_DEFAULT_UAPSD_QUEUES \


