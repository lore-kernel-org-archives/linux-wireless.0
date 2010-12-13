Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([187.115.55.249]:50777 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab0LMNn4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 08:43:56 -0500
Date: Mon, 13 Dec 2010 11:43:51 -0200
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: avoid calling ieee80211_work_work unconditionally
Message-ID: <20101213114351.47df9333@gotham.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On suspend, there might be usb wireless drivers which wrongly trigger
the warning in ieee80211_work_work. If an usb driver doesn't have a
suspend hook, the usb stack will disconnect the device. On disconnect,
a mac80211 driver calls ieee80211_unregister_hw, which calls dev_close,
which calls ieee80211_stop, and in the end calls ieee80211_work_purge->
ieee80211_work_work.

The problem is that this call to ieee80211_work_purge comes after
mac80211 is suspended, triggering the warning even when we don't have
work queued in work_list (the expected case when already suspended),
because it always calls ieee80211_work_work.

So, just call ieee80211_work_work in ieee80211_work_purge if we really
have to abort work. This addresses the warning reported at
https://bugzilla.kernel.org/show_bug.cgi?id=24402

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 net/mac80211/work.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index de43753..36305e0 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1074,11 +1074,13 @@ void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_work *wk;
+	bool cleanup = false;
 
 	mutex_lock(&local->mtx);
 	list_for_each_entry(wk, &local->work_list, list) {
 		if (wk->sdata != sdata)
 			continue;
+		cleanup = true;
 		wk->type = IEEE80211_WORK_ABORT;
 		wk->started = true;
 		wk->timeout = jiffies;
@@ -1086,7 +1088,8 @@ void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->mtx);
 
 	/* run cleanups etc. */
-	ieee80211_work_work(&local->work_work);
+	if (cleanup)
+		ieee80211_work_work(&local->work_work);
 
 	mutex_lock(&local->mtx);
 	list_for_each_entry(wk, &local->work_list, list) {
-- 
1.7.3.3

