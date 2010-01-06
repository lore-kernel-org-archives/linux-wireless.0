Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40294 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852Ab0AFObL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 09:31:11 -0500
Subject: [PATCH] mac80211: fix a few work bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 15:30:58 +0100
Message-ID: <1262788258.9268.113.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle and Lennert reported problems with the new work
code, and at least Kalle's problem I was able to trace
to a missing jiffies initialisation.

I also ran into a problem where occasionally I couldn't
connect, which seems fixed with kicking the work items
after scanning.

Finally, also add some sanity checking code to verify
that we're not adding work items while an interface is
down -- that case could lead to something similar to
what Lennert was seeing.

There still seems to be a race condition that we're
trying to figure out separately.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/scan.c |    1 +
 net/mac80211/work.c |    4 ++++
 2 files changed, 5 insertions(+)

--- wireless-testing.orig/net/mac80211/scan.c	2010-01-06 09:50:40.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2010-01-06 09:53:23.000000000 +0100
@@ -285,6 +285,7 @@ void ieee80211_scan_completed(struct iee
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_ibss_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
+	ieee80211_queue_work(&local->hw, &local->work_work);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
--- wireless-testing.orig/net/mac80211/work.c	2010-01-06 09:51:03.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2010-01-06 11:30:26.000000000 +0100
@@ -818,6 +818,7 @@ static void ieee80211_work_work(struct w
 		    wk->chan == local->tmp_channel &&
 		    wk->chan_type == local->tmp_channel_type) {
 			wk->started = true;
+			wk->timeout = jiffies;
 		}
 
 		if (!wk->started && !local->tmp_channel) {
@@ -935,6 +936,9 @@ void ieee80211_add_work(struct ieee80211
 	if (WARN_ON(!wk->done))
 		return;
 
+	if (WARN_ON(!ieee80211_sdata_running(wk->sdata)))
+		return;
+
 	wk->started = false;
 
 	local = wk->sdata->local;


