Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab0FJI0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:23 -0400
Message-Id: <20100610082232.287876519@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 19/23] mac80211: defer TX agg session teardown to work
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since we want the code to be able to sleep
in the future, it must not be called from
the timer directly. To achieve that, simply
call the function drivers would call, and
also use RCU in the timer to get the struct
so we don't need to rely on the spinlock in
the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-tx.c	2010-06-09 17:21:14.000000000 +0200
+++ wireless-testing/net/mac80211/agg-tx.c	2010-06-09 17:21:16.000000000 +0200
@@ -200,11 +200,11 @@ static void sta_addba_resp_timer_expired
 	struct tid_ampdu_tx *tid_tx;
 
 	/* check if the TID waits for addBA response */
-	spin_lock_bh(&sta->lock);
-	tid_tx = sta->ampdu_mlme.tid_tx[tid];
+	rcu_read_lock();
+	tid_tx = rcu_dereference(sta->ampdu_mlme.tid_tx[tid]);
 	if (!tid_tx ||
 	    test_bit(HT_AGG_STATE_RESPONSE_RECEIVED, &tid_tx->state)) {
-		spin_unlock_bh(&sta->lock);
+		rcu_read_unlock();
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "timer expired on tid %d but we are not "
 				"(or no longer) expecting addBA response there\n",
@@ -217,8 +217,8 @@ static void sta_addba_resp_timer_expired
 	printk(KERN_DEBUG "addBA response timer expired on tid %d\n", tid);
 #endif
 
-	___ieee80211_stop_tx_ba_session(sta, tid, WLAN_BACK_INITIATOR);
-	spin_unlock_bh(&sta->lock);
+	ieee80211_stop_tx_ba_session(&sta->sta, tid);
+	rcu_read_unlock();
 }
 
 static inline int ieee80211_ac_from_tid(int tid)


