Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f44.google.com ([74.125.83.44]:52961 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaALJGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 04:06:43 -0500
Received: by mail-ee0-f44.google.com with SMTP id b57so2639319eek.3
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jan 2014 01:06:42 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: move roc cookie assignment earlier
Date: Sun, 12 Jan 2014 11:06:37 +0200
Message-Id: <1389517597-3865-1-git-send-email-eliad@wizery.com> (sfid-20140112_100819_604406_727A42BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_start_roc_work() might add a new roc
to existing roc, and tell cfg80211 it has already
started.

However, this might happen before the roc cookie
was set, resulting in REMAIN_ON_CHANNEL (started)
event with null cookie. Consequently, it can make
wpa_supplicant go out of sync.

Fix it by setting the roc cookie earlier.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f9ae9b8..94b4acb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2638,6 +2638,24 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	INIT_DELAYED_WORK(&roc->work, ieee80211_sw_roc_work);
 	INIT_LIST_HEAD(&roc->dependents);
 
+	/*
+	 * cookie is either the roc cookie (for normal roc)
+	 * or the SKB (for mgmt TX)
+	 */
+	if (!txskb) {
+		/* local->mtx protects this */
+		local->roc_cookie_counter++;
+		roc->cookie = local->roc_cookie_counter;
+		/* wow, you wrapped 64 bits ... more likely a bug */
+		if (WARN_ON(roc->cookie == 0)) {
+			roc->cookie = 1;
+			local->roc_cookie_counter++;
+		}
+		*cookie = roc->cookie;
+	} else {
+		*cookie = (unsigned long)txskb;
+	}
+
 	/* if there's one pending or we're scanning, queue this one */
 	if (!list_empty(&local->roc_list) ||
 	    local->scanning || local->radar_detect_enabled)
@@ -2772,24 +2790,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	if (!queued)
 		list_add_tail(&roc->list, &local->roc_list);
 
-	/*
-	 * cookie is either the roc cookie (for normal roc)
-	 * or the SKB (for mgmt TX)
-	 */
-	if (!txskb) {
-		/* local->mtx protects this */
-		local->roc_cookie_counter++;
-		roc->cookie = local->roc_cookie_counter;
-		/* wow, you wrapped 64 bits ... more likely a bug */
-		if (WARN_ON(roc->cookie == 0)) {
-			roc->cookie = 1;
-			local->roc_cookie_counter++;
-		}
-		*cookie = roc->cookie;
-	} else {
-		*cookie = (unsigned long)txskb;
-	}
-
 	return 0;
 }
 
-- 
1.8.5.2.229.g4448466.dirty

