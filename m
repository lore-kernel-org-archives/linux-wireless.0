Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbZJKJsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 05:48:35 -0400
Subject: [PATCH] mac80211: fix ibss race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 11:47:57 +0200
Message-Id: <1255254477.4095.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When a scan completes, we call ieee80211_sta_find_ibss(),
which is also called from other places. When the scan was
done in software, there's no problem as both run from the
single-threaded mac80211 workqueue and are thus serialised
against each other, but with hardware scan the completion
can be in a different context and race against callers of
this function from the workqueue (e.g. due to beacon RX).
So instead of calling ieee80211_sta_find_ibss() directly,
just arm the timer and have it fire, scheduling the work,
which will invoke ieee80211_sta_find_ibss() (if that is
appropriate in the current state).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-10-02 10:41:44.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-10-06 14:57:27.000000000 +0200
@@ -831,7 +831,7 @@ void ieee80211_ibss_notify_scan_complete
 		if (!sdata->u.ibss.ssid_len)
 			continue;
 		sdata->u.ibss.last_scan_completed = jiffies;
-		ieee80211_sta_find_ibss(sdata);
+		mod_timer(&sdata->u.ibss.timer, 0);
 	}
 	mutex_unlock(&local->iflist_mtx);
 }


