Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52019 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab0EZOlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 10:41:42 -0400
Subject: [PATCH] mac80211: remove bogus mod_timer() call
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 16:41:40 +0200
Message-ID: <1274884900.3658.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IBSS code has a bogus mod_timer(..., 0) call,
we shouldn't ever pass a constant value to the
function since any constant value could be in the
future or the past.

However, invoking the timer here is not necessary
at all, since we just finished scanning and just
need to have the IBSS code run again from the
workqueue later, so factor out the work starting
and use that instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
The problem was introduced in 2.6.32 ... not sure if that means it
should be sent to stable or not, I guess not since we haven't really had
issues with it that I know of.

 net/mac80211/ibss.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-05-25 20:44:41.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-05-25 20:45:57.000000000 +0200
@@ -798,6 +798,15 @@ static void ieee80211_ibss_work(struct w
 	}
 }
 
+static void ieee80211_queue_ibss_work(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+
+	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
+	ieee80211_queue_work(&local->hw, &ifibss->work);
+}
+
 static void ieee80211_ibss_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -810,8 +819,7 @@ static void ieee80211_ibss_timer(unsigne
 		return;
 	}
 
-	set_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request);
-	ieee80211_queue_work(&local->hw, &ifibss->work);
+	ieee80211_queue_ibss_work(sdata);
 }
 
 #ifdef CONFIG_PM
@@ -859,7 +867,7 @@ void ieee80211_ibss_notify_scan_complete
 		if (!sdata->u.ibss.ssid_len)
 			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
-		mod_timer(&sdata->u.ibss.timer, 0);
+		ieee80211_queue_ibss_work(sdata);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }


