Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54380 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbZKRQPf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 11:15:35 -0500
Subject: [PATCH] mac80211: fix addba timer (again...)
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 17:15:06 +0100
Message-ID: <1258560906.30511.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  commit 2171abc58644e09dbba546d91366b12743115396
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Thu Oct 29 08:34:00 2009 +0100

      mac80211: fix addba timer

left a problem in there, even if the timer was
never started it could be deleted and then added.

Linus pointed out that del_timer_sync() isn't
actually needed if we make the timer able to
deal with no longer being needed when it gets
queued _while_ we're in the locked section that
also deletes it. For that the timer function only
needs to check the HT_ADDBA_RECEIVED_MSK bit as
well as the HT_ADDBA_REQUESTED_MSK bit, only if
the former is clear should it do anything.

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-tx.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-11-18 17:12:49.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-11-18 17:12:50.000000000 +0100
@@ -174,12 +174,14 @@ static void sta_addba_resp_timer_expired
 
 	/* check if the TID waits for addBA response */
 	spin_lock_bh(&sta->lock);
-	if (!(*state & HT_ADDBA_REQUESTED_MSK)) {
+	if ((*state & (HT_ADDBA_REQUESTED_MSK | HT_ADDBA_RECEIVED_MSK)) !=
+						HT_ADDBA_REQUESTED_MSK) {
 		spin_unlock_bh(&sta->lock);
 		*state = HT_AGG_STATE_IDLE;
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
-				"expecting addBA response there", tid);
+				"(or no longer) expecting addBA response there",
+			tid);
 #endif
 		return;
 	}
@@ -648,21 +650,21 @@ void ieee80211_process_addba_resp(struct
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-	del_timer_sync(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
-
 	spin_lock_bh(&sta->lock);
 
 	if (!(*state & HT_ADDBA_REQUESTED_MSK))
-		goto timer_still_needed;
+		goto out;
 
 	if (mgmt->u.action.u.addba_resp.dialog_token !=
 		sta->ampdu_mlme.tid_tx[tid]->dialog_token) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "wrong addBA response token, tid %d\n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
-		goto timer_still_needed;
+		goto out;
 	}
 
+	del_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
+
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "switched off addBA timer for tid %d \n", tid);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
@@ -681,10 +683,6 @@ void ieee80211_process_addba_resp(struct
 		___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
 	}
 
-	goto out;
-
- timer_still_needed:
-	add_timer(&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer);
  out:
 	spin_unlock_bh(&sta->lock);
 }


