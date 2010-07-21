Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0GUIws (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 04:52:48 -0400
Subject: [PATCH] mac80211: fix IBSS lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Jul 2010 10:52:40 +0200
Message-ID: <1279702360.3707.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Bob reported a lockdep complaint originating in
the mac80211 IBSS code due to the common work
struct patch. The reason is that the IBSS and
station mode code have different locking orders
for the cfg80211 wdev lock and the work struct
(where "locking" implies running/canceling).

Fix this by simply not canceling the work in
the IBSS code, it is not necessary since when
the REQ_RUN bit is cleared, the work will run
without effect if it runs. When the interface
is set down, it is flushed anyway, so there's
no concern about it running after memory has
been invalidated either.

This fixes
https://bugzilla.kernel.org/show_bug.cgi?id=16419

Additionally, looking into this I noticed that
there's a small window while the IBSS is torn
down in which the work may be rescheduled and
the REQ_RUN bit be set again after leave() has
cleared it when a scan finishes at exactly the
same time. Avoid that by setting the ssid_len
to zero before clearing REQ_RUN which signals
to the scan finish code that this interface is
not active.

Reported-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-07-20 10:25:03.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-07-20 10:27:56.000000000 +0200
@@ -943,11 +943,6 @@ int ieee80211_ibss_leave(struct ieee8021
 		}
 	}
 
-	del_timer_sync(&sdata->u.ibss.timer);
-	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-	cancel_work_sync(&sdata->work);
-	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-
 	sta_info_flush(sdata->local, sdata);
 
 	/* remove beacon */
@@ -964,6 +959,20 @@ int ieee80211_ibss_leave(struct ieee8021
 	memset(sdata->u.ibss.bssid, 0, ETH_ALEN);
 	sdata->u.ibss.ssid_len = 0;
 
+	/*
+	 * ssid_len indicates active or not, so needs to be visible to
+	 * everybody, especially ieee80211_ibss_notify_scan_completed,
+	 * so it won't restart the timer after we remove it here.
+	 */
+	mb();
+
+	del_timer_sync(&sdata->u.ibss.timer);
+	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
+	/*
+	 * Since the REQ_RUN bit is clear, the work won't do
+	 * anything if it runs after this.
+	 */
+
 	ieee80211_recalc_idle(sdata->local);
 
 	return 0;


