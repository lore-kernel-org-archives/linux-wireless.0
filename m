Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370Ab0AYMgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 07:36:40 -0500
Subject: [PATCH] mac80211: track work started through callbacks
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 13:36:36 +0100
Message-ID: <1264422996.23766.38.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the remain_on_channel work callback needs
to track in its own data structure whether the work
was just started or not. By reordering some code this
becomes unnecessary, the generic wk->started variable
can still be 'false' on the first invocation and only
be 'true' on actual timeout invocations, so that the
extra variable can be removed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 -
 net/mac80211/work.c        |   17 ++++++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-01-25 12:53:05.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-01-25 12:53:11.000000000 +0100
@@ -299,7 +299,6 @@ struct ieee80211_work {
 		} assoc;
 		struct {
 			u32 duration;
-			bool started;
 		} remain;
 	};
 
--- wireless-testing.orig/net/mac80211/work.c	2010-01-25 12:53:15.000000000 +0100
+++ wireless-testing/net/mac80211/work.c	2010-01-25 12:56:46.000000000 +0100
@@ -535,8 +535,7 @@ ieee80211_remain_on_channel_timeout(stru
 	 * First time we run, do nothing -- the generic code will
 	 * have switched to the right channel etc.
 	 */
-	if (!wk->remain.started) {
-		wk->remain.started = true;
+	if (!wk->started) {
 		wk->timeout = jiffies + msecs_to_jiffies(wk->remain.duration);
 
 		cfg80211_ready_on_channel(wk->sdata->dev, (unsigned long) wk,
@@ -821,15 +820,17 @@ static void ieee80211_work_work(struct w
 	mutex_lock(&local->work_mtx);
 
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
+		bool started = wk->started;
+
 		/* mark work as started if it's on the current off-channel */
-		if (!wk->started && local->tmp_channel &&
+		if (!started && local->tmp_channel &&
 		    wk->chan == local->tmp_channel &&
 		    wk->chan_type == local->tmp_channel_type) {
-			wk->started = true;
+			started = true;
 			wk->timeout = jiffies;
 		}
 
-		if (!wk->started && !local->tmp_channel) {
+		if (!started && !local->tmp_channel) {
 			/*
 			 * TODO: could optimize this by leaving the
 			 *	 station vifs in awake mode if they
@@ -842,12 +843,12 @@ static void ieee80211_work_work(struct w
 			local->tmp_channel = wk->chan;
 			local->tmp_channel_type = wk->chan_type;
 			ieee80211_hw_config(local, 0);
-			wk->started = true;
+			started = true;
 			wk->timeout = jiffies;
 		}
 
 		/* don't try to work with items that aren't started */
-		if (!wk->started)
+		if (!started)
 			continue;
 
 		if (time_is_after_jiffies(wk->timeout)) {
@@ -882,6 +883,8 @@ static void ieee80211_work_work(struct w
 			break;
 		}
 
+		wk->started = started;
+
 		switch (rma) {
 		case WORK_ACT_NONE:
 			/* might have changed the timeout */


