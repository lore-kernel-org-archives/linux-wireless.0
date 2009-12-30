Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:25881 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbZL3Mm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 07:42:56 -0500
Subject: [PATCH] mac80211: fix a warning related to pointer conversion to u64
	cookie
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Dec 2009 14:42:20 +0200
Message-ID: <20091230124220.31895.74821.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

On a 32 bit system (in this case an omap 3430 system) gcc warned about
pointer conversion:

net/mac80211/work.c: In function 'ieee80211_remain_on_channel_timeout':
net/mac80211/work.c:534: warning: cast from pointer to integer of different size
net/mac80211/work.c: In function 'ieee80211_remain_done':
net/mac80211/work.c:1030: warning: cast from pointer to integer of different size
net/mac80211/work.c: In function 'ieee80211_wk_remain_on_channel':
net/mac80211/work.c:1056: warning: cast from pointer to integer of different size
net/mac80211/work.c: In function 'ieee80211_wk_cancel_remain_on_channel':
net/mac80211/work.c:1072: warning: cast from pointer to integer of different size

Fix it by casting the pointers to unsigned long instead. This makes the
compiler happy again.

Compile-tested only.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/work.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ea89ed7..5ba7599 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -531,9 +531,9 @@ ieee80211_remain_on_channel_timeout(struct ieee80211_work *wk)
 		wk->remain.started = true;
 		wk->timeout = jiffies + msecs_to_jiffies(wk->remain.duration);
 
-		cfg80211_ready_on_channel(wk->sdata->dev, (u64)wk, wk->chan,
-					  wk->chan_type, wk->remain.duration,
-					  GFP_KERNEL);
+		cfg80211_ready_on_channel(wk->sdata->dev, (unsigned long) wk,
+					  wk->chan, wk->chan_type,
+					  wk->remain.duration, GFP_KERNEL);
 
 		return WORK_ACT_NONE;
 	}
@@ -1027,7 +1027,7 @@ static enum work_done_result ieee80211_remain_done(struct ieee80211_work *wk,
 	/*
 	 * We are done serving the remain-on-channel command.
 	 */
-	cfg80211_remain_on_channel_expired(wk->sdata->dev, (u64)wk,
+	cfg80211_remain_on_channel_expired(wk->sdata->dev, (unsigned long) wk,
 					   wk->chan, wk->chan_type,
 					   GFP_KERNEL);
 
@@ -1053,7 +1053,7 @@ int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 
 	wk->remain.duration = duration;
 
-	*cookie = (u64)wk;
+	*cookie = (unsigned long) wk;
 
 	ieee80211_add_work(wk);
 
@@ -1069,7 +1069,7 @@ int ieee80211_wk_cancel_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&local->work_mtx);
 	list_for_each_entry_safe(wk, tmp, &local->work_list, list) {
-		if ((u64)wk == cookie) {
+		if ((unsigned long) wk == cookie) {
 			wk->timeout = jiffies;
 			found = true;
 			break;

