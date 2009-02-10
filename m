Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487AbZBJUhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2009 15:37:48 -0500
Message-Id: <20090210202555.374514996@sipsolutions.net> (sfid-20090210_213751_071297_5DEB432B)
References: <20090210202536.425266119@sipsolutions.net>
Date: Tue, 10 Feb 2009 21:25:51 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/27] mac80211: fix aggregation timer lockups
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as I can tell, there are possible lockups because both the RX
session_timer and TX addba_resp_timer are del_timer_sync'ed under
the sta spinlock which both timer functions take. Additionally, the
TX agg code seems to leak memory when TX aggregation is not disabled
before the sta_info is freed.

Fix this by making the free code a little smarter in the RX agg case,
and actually make the sta_info_destroy code free the TX agg info in
the TX agg case. We won't notify the peer, but it'll notice something
is wrong anyway, and normally this only happens after we've told it
in some other way we will no longer talk to it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/agg-rx.c   |   11 +++++++++--
 net/mac80211/sta_info.c |   37 +++++++++++++++++++++++++++++++++----
 net/mac80211/sta_info.h |    1 +
 3 files changed, 43 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2009-02-10 20:59:32.000000000 +0100
+++ wireless-testing/net/mac80211/agg-rx.c	2009-02-10 20:59:34.000000000 +0100
@@ -78,11 +78,18 @@ void ieee80211_sta_stop_rx_ba_session(st
 			sta->ampdu_mlme.tid_rx[tid]->reorder_buf[i] = NULL;
 		}
 	}
+
+	spin_lock_bh(&sta->lock);
 	/* free resources */
 	kfree(sta->ampdu_mlme.tid_rx[tid]->reorder_buf);
-	kfree(sta->ampdu_mlme.tid_rx[tid]);
-	sta->ampdu_mlme.tid_rx[tid] = NULL;
+
+	if (!sta->ampdu_mlme.tid_rx[tid]->shutdown) {
+		kfree(sta->ampdu_mlme.tid_rx[tid]);
+		sta->ampdu_mlme.tid_rx[tid] = NULL;
+	}
+
 	sta->ampdu_mlme.tid_state_rx[tid] = HT_AGG_STATE_IDLE;
+	spin_unlock_bh(&sta->lock);
 
 	rcu_read_unlock();
 }
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-02-10 20:59:25.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-02-10 20:59:34.000000000 +0100
@@ -194,12 +194,41 @@ void sta_info_destroy(struct sta_info *s
 		dev_kfree_skb_any(skb);
 
 	for (i = 0; i <  STA_TID_NUM; i++) {
+		struct tid_ampdu_rx *tid_rx;
+		struct tid_ampdu_tx *tid_tx;
+
 		spin_lock_bh(&sta->lock);
-		if (sta->ampdu_mlme.tid_rx[i])
-		  del_timer_sync(&sta->ampdu_mlme.tid_rx[i]->session_timer);
-		if (sta->ampdu_mlme.tid_tx[i])
-		  del_timer_sync(&sta->ampdu_mlme.tid_tx[i]->addba_resp_timer);
+		tid_rx = sta->ampdu_mlme.tid_rx[i];
+		/* Make sure timer won't free the tid_rx struct, see below */
+		if (tid_rx)
+			tid_rx->shutdown = true;
 		spin_unlock_bh(&sta->lock);
+
+		/*
+		 * Outside spinlock - shutdown is true now so that the timer
+		 * won't free tid_rx, we have to do that now. Can't let the
+		 * timer do it because we have to sync the timer outside the
+		 * lock that it takes itself.
+		 */
+		if (tid_rx) {
+			del_timer_sync(&tid_rx->session_timer);
+			kfree(tid_rx);
+		}
+
+		/*
+		 * No need to do such complications for TX agg sessions, the
+		 * path leading to freeing the tid_tx struct goes via a call
+		 * from the driver, and thus needs to look up the sta struct
+		 * again, which cannot be found when we get here. Hence, we
+		 * just need to delete the timer and free the aggregation
+		 * info; we won't be telling the peer about it then but that
+		 * doesn't matter if we're not talking to it again anyway.
+		 */
+		tid_tx = sta->ampdu_mlme.tid_tx[i];
+		if (tid_tx) {
+			del_timer_sync(&tid_tx->addba_resp_timer);
+			kfree(tid_tx);
+		}
 	}
 
 	__sta_info_free(local, sta);
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-02-10 20:59:32.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-02-10 20:59:34.000000000 +0100
@@ -100,6 +100,7 @@ struct tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u8 dialog_token;
+	bool shutdown;
 };
 
 /**

-- 

