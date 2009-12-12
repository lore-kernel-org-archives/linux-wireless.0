Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39309 "HELO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759856AbZLMBKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 20:10:23 -0500
Subject: [PATCH] mac80211: remove requeue from work
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 16:29:43 +0100
Message-ID: <1260631783.2442.335.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to be requeueing the work struct
since we check for the scan after removing items
due to possible timeouts.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/work.c |   18 ------------------
 1 file changed, 18 deletions(-)

--- wireless-testing.orig/net/mac80211/work.c	2009-12-12 16:29:08.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2009-12-12 16:29:11.000000000 +0100
@@ -435,12 +435,6 @@ ieee80211_direct_probe(struct ieee80211_
 		 */
 		ieee80211_remove_auth_bss(local, wk);
 
-		/*
-		 * We might have a pending scan which had no chance to run yet
-		 * due to work needing to be done. Hence, queue the STAs work
-		 * again for that.
-		 */
-		ieee80211_queue_work(&local->hw, &local->work_work);
 		return WORK_ACT_TIMEOUT;
 	}
 
@@ -478,12 +472,6 @@ ieee80211_authenticate(struct ieee80211_
 		 */
 		ieee80211_remove_auth_bss(local, wk);
 
-		/*
-		 * We might have a pending scan which had no chance to run yet
-		 * due to work needing to be done. Hence, queue the STAs work
-		 * again for that.
-		 */
-		ieee80211_queue_work(&local->hw, &local->work_work);
 		return WORK_ACT_TIMEOUT;
 	}
 
@@ -519,12 +507,6 @@ ieee80211_associate(struct ieee80211_wor
 		if (wk->assoc.bss)
 			cfg80211_unlink_bss(local->hw.wiphy, wk->assoc.bss);
 
-		/*
-		 * We might have a pending scan which had no chance to run yet
-		 * due to work needing to be done. Hence, queue the STAs work
-		 * again for that.
-		 */
-		ieee80211_queue_work(&local->hw, &local->work_work);
 		return WORK_ACT_TIMEOUT;
 	}
 


