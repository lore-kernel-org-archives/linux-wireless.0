Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58850 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1K0HX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 02:23:57 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so7031615iag.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Nov 2011 23:23:56 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Nikolay Martynov <mar.kolya@gmail.com>
Subject: [PATCH] mac80211: fix race condition caused by late addBA resp
Date: Sun, 27 Nov 2011 02:23:41 -0500
Message-Id: <1322378621-14647-2-git-send-email-mar.kolya@gmail.com> (sfid-20111127_082402_823149_B8E64ABA)
In-Reply-To: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  Currently if addBA respones comes in just after addba_resp_timer has
expired we still accept addBA response and (try to) open agg
session. This patch fixes this race condition and makes sure that if
addba_resp_timer has expired addBA response is not longer accepted and
we do not try to open half-closed session.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
---
 net/mac80211/agg-tx.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 39d72cc..683effe 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -746,6 +746,23 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 	if (!tid_tx)
 		goto out;
 
+	del_timer_sync(&tid_tx->addba_resp_timer);
+
+	/*
+	 * Test that we are not stopping agg session now.
+	 * Since addba_resp_timer may have just finished we need to
+	 * check HT_AGG_STATE_STOPPING too.
+	 */
+	if (test_bit(HT_AGG_STATE_WANT_STOP, &tid_tx->state)
+	    || test_bit(HT_AGG_STATE_STOPPING, &tid_tx->state)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		printk(KERN_DEBUG "got addBA resp for tid %d but we are not "
+				"(or no longer) expecting expecting it\n",
+			tid);
+#endif
+		goto out;
+	}
+
 	if (mgmt->u.action.u.addba_resp.dialog_token != tid_tx->dialog_token) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
@@ -753,8 +770,6 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 		goto out;
 	}
 
-	del_timer(&tid_tx->addba_resp_timer);
-
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d\n", tid);
 #endif
-- 
1.7.4.1

