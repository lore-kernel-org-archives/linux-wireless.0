Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546AbZDHA4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 20:56:06 -0400
Subject: [PATCH] mac80211: re-upload keys only after telling driver about
 association
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bob Copeland <bcopeland@gmail.com>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 02:55:34 +0200
Message-Id: <1239152134.8456.41.camel@johannes.local> (sfid-20090408_025612_653420_92ED938C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the normal WPA or RSN case keys are only configured after
associating, so we should do that in that order when resuming
as well. It shouldn't really matter since we do not send any
data at either point, but iwlwifi prefers it this way and it
does seem more natural.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/pm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/pm.c	2009-04-08 01:33:41.000000000 +0200
+++ wireless-testing/net/mac80211/pm.c	2009-04-08 01:40:35.000000000 +0200
@@ -127,11 +127,6 @@ int __ieee80211_resume(struct ieee80211_
 
 	rcu_read_unlock();
 
-	/* add back keys */
-	list_for_each_entry(sdata, &local->interfaces, list)
-		if (netif_running(sdata->dev))
-			ieee80211_enable_keys(sdata);
-
 	/* setup RTS threshold */
 	if (local->ops->set_rts_threshold)
 		local->ops->set_rts_threshold(hw, local->rts_threshold);
@@ -172,6 +167,11 @@ int __ieee80211_resume(struct ieee80211_
 		}
 	}
 
+	/* add back keys */
+	list_for_each_entry(sdata, &local->interfaces, list)
+		if (netif_running(sdata->dev))
+			ieee80211_enable_keys(sdata);
+
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 


