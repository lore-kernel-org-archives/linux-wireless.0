Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58228 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbbDAM1L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 08:27:11 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix RX A-MPDU session reorder timer deletion
Date: Wed,  1 Apr 2015 14:27:04 +0200
Message-Id: <1427891224-31685-1-git-send-email-johannes@sipsolutions.net> (sfid-20150401_142715_726410_D8A42A33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's an issue with the way the RX A-MPDU reorder timer is
deleted that can cause a kernel crash like this:

 * tid_rx is removed - call_rcu(ieee80211_free_tid_rx)
 * station is destroyed
 * reorder timer fires before ieee80211_free_tid_rx() runs,
   accessing the station, thus potentially crashing due to
   the use-after-free

The station deletion is protected by synchronize_net(), but
that isn't enough -- ieee80211_free_tid_rx() need not have
run when that returns (it deletes the timer.) We could use
rcu_barrier() instead of synchronize_net(), but that's much
more expensive.

Instead, to fix this, add a field tracking that the session
is being deleted. In this case, the only re-arming of the
timer happens with the reorder spinlock held, so make that
code not rearm it if the session is being deleted and also
delete the timer after setting that field. This ensures the
timer cannot fire after ___ieee80211_stop_rx_ba_session()
returns, which fixes the problem.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c   | 8 ++++++--
 net/mac80211/rx.c       | 7 ++++---
 net/mac80211/sta_info.h | 2 ++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 2c090c507391..87594ec2987a 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -49,8 +49,6 @@ static void ieee80211_free_tid_rx(struct rcu_head *h)
 		container_of(h, struct tid_ampdu_rx, rcu_head);
 	int i;
 
-	del_timer_sync(&tid_rx->reorder_timer);
-
 	for (i = 0; i < tid_rx->buf_size; i++)
 		__skb_queue_purge(&tid_rx->reorder_buf[i]);
 	kfree(tid_rx->reorder_buf);
@@ -93,6 +91,12 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 
 	del_timer_sync(&tid_rx->session_timer);
 
+	/* make sure ieee80211_sta_reorder_release() doesn't re-arm the timer */
+	spin_lock_bh(tid_rx->reorder_lock);
+	tid_rx->removed = true;
+	spin_unlock_bh(tid_rx->reorder_lock);
+	del_timer_sync(&tid_rx->reorder_timer);
+
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5b60bcf00ec3..c1aee0e57bfe 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -873,9 +873,10 @@ static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 
  set_release_timer:
 
-		mod_timer(&tid_agg_rx->reorder_timer,
-			  tid_agg_rx->reorder_time[j] + 1 +
-			  HT_RX_REORDER_BUF_TIMEOUT);
+		if (!tid_agg_rx->removed)
+			mod_timer(&tid_agg_rx->reorder_timer,
+				  tid_agg_rx->reorder_time[j] + 1 +
+				  HT_RX_REORDER_BUF_TIMEOUT);
 	} else {
 		del_timer(&tid_agg_rx->reorder_timer);
 	}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 97f25b9e52be..71a5ec29473b 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -176,6 +176,7 @@ struct tid_ampdu_tx {
  * @reorder_lock: serializes access to reorder buffer, see below.
  * @auto_seq: used for offloaded BA sessions to automatically pick head_seq_and
  *	and ssn.
+ * @removed: this session is removed (but might have been found due to RCU)
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -200,6 +201,7 @@ struct tid_ampdu_rx {
 	u16 timeout;
 	u8 dialog_token;
 	bool auto_seq;
+	bool removed;
 };
 
 /**
-- 
2.1.4

