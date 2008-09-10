Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYIJWHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:07:12 -0400
Message-Id: <20080910220410.722573000@sipsolutions.net> (sfid-20080911_000716_571673_C4A2F2CE)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:48 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/18] mac80211: dont set REQ_RUN when scan finishes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timer restart is done wrongly, we shouldn't set the REQ_RUN
bit when the scan has finished if it hadn't been set before the
scan started. If the timer fires during the scan, it will set
REQ_RUN and then we can run the work for it, if it didn't fire
then we shouldn't run its work either.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:52.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:57:55.000000000 +0200
@@ -2629,7 +2629,8 @@ static void ieee80211_restart_sta_timer(
 {
 	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
 	    ieee80211_vif_is_mesh(&sdata->vif))
-		ieee80211_sta_timer((unsigned long)sdata);
+		queue_work(sdata->local->hw.workqueue,
+			   &sdata->u.sta.work);
 }
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)

-- 

