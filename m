Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46338 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbZJ2He0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 03:34:26 -0400
Subject: [PATCH 2.6.32] mac80211: fix addba timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 08:34:00 +0100
Message-ID: <1256801640.3865.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The addba timer function acquires the sta spinlock,
but at the same time we try to del_timer_sync() it
under the spinlock which can produce deadlocks.

To fix this, always del_timer_sync() the timer in
ieee80211_process_addba_resp() and add it again
after checking the conditions, if necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Looks like I forgot to send this when I made it and then hid it in the
middle of my patch pile and forgot!

 net/mac80211/agg-tx.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-10-27 09:06:13.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-10-29 08:32:15.000000000 +0100
@@ -666,26 +666,25 @@ void ieee80211_process_addba_resp(struct
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
+	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+
 	spin_lock_bh(&sta->lock);
 
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
-		spin_unlock_bh(&sta->lock);
-		return;
-	}
+	if (!(*state & HT_ADDBA_REQUESTED_MSK))
+		goto timer_still_needed;
 
 	if (mgmt->u.action.u.addba_resp.dialog_token !=
 		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
-		spin_unlock_bh(&sta->lock);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		return;
+		goto timer_still_needed;
 	}
 
-	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
+
 	if (le16_to_cpu(mgmt->u.action.u.addba_resp.status)
 			== WLAN_STATUS_SUCCESS) {
 		u8 curstate = *state;
@@ -699,5 +698,11 @@ void ieee80211_process_addba_resp(struct
 	} else {
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 	}
+
+	goto out;
+
+ timer_still_needed:
+	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+ out:
 	spin_unlock_bh(&sta->lock);
 }


