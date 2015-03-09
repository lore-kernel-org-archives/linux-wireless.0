Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39678 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbbCILxa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 07:53:30 -0400
Received: by wiwl15 with SMTP id l15so19400906wiw.4
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 04:53:28 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: handle hw roc cancel vs. expiration race
Date: Mon,  9 Mar 2015 13:53:21 +0200
Message-Id: <1425902001-3163-1-git-send-email-eliad@wizery.com> (sfid-20150309_125334_121378_870B2BF5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 handles roc expirations (indicated by
ieee80211_remain_on_channel_expired()) with a separate
work (hw_roc_done).

If userspace asks to cancel the ongoing roc before
hw_roc_done was scheduled, mac80211 will cancel
the ongoing roc, while leaving the hw_roc_done work
pending.

This might end up in the next roc being cancelled
by the stale work, causing mac80211 and the low-level
driver to go out of sync.

Fix it by cancelling hw_roc_done on roc cancel.
Since hw_roc_done takes local->mtx, temporarily
release it (before re-acquiring it and starting
the next roc if needed).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/mac80211/cfg.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36..a80f7b3 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2782,7 +2782,22 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 		}
 
 		list_del(&found->list);
+		mutex_unlock(&local->mtx);
+
+		/*
+		 * The driver might have already expired the ROC (by
+		 * calling ieee80211_remain_on_channel_expired()), so
+		 * cancel the pending roc_done work (otherwise, it might
+		 * cancel the upcoming roc).
+		 */
+		cancel_work_sync(&local->hw_roc_done);
 
+		mutex_lock(&local->mtx);
+		/*
+		 * We hold rtnl, so nothing should have been able to
+		 * manipulate the roc_list during the temporary
+		 * lock release.
+		 */
 		if (found->started)
 			ieee80211_start_next_roc(local);
 		mutex_unlock(&local->mtx);
-- 
1.8.5.2.229.g4448466.dirty

