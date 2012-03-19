Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab2CSMuu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 08:50:50 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC] mac80211: fix possible tid_rx->reorder_timer use after free
Date: Mon, 19 Mar 2012 13:50:42 +0100
Message-Id: <1332161442-7315-1-git-send-email-sgruszka@redhat.com> (sfid-20120319_135054_035281_6BD5D501)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that we arm tid_rx->reorder_timer after del_timer_sync(). To
fix: first wait for RCU grace period finish and then delete timer. Timer
will not be armed again as rcu_dereference(sta->ampdu_mlme.tid_rx[tid])
will return NULL.

Debug object detected problem with the following warning:
ODEBUG: free active (active state 0) object type: timer_list hint: sta_rx_agg_reorder_timer_expired+0x0/0xf0 [mac80211]

Bug report (with full warning):
https://bugzilla.redhat.com/show_bug.cgi?id=804007

Reported-by: "jan p. springer" <jsd@igroup.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/agg-rx.c   |    8 ++++----
 net/mac80211/sta_info.h |    1 -
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 1068f66..2c1223e 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -43,10 +43,8 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-static void ieee80211_free_tid_rx(struct rcu_head *h)
+static void ieee80211_free_tid_rx(struct tid_ampdu_rx *tid_rx)
 {
-	struct tid_ampdu_rx *tid_rx =
-		container_of(h, struct tid_ampdu_rx, rcu_head);
 	int i;
 
 	for (i = 0; i < tid_rx->buf_size; i++)
@@ -90,10 +88,12 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
 				     tid, WLAN_BACK_RECIPIENT, reason);
 
+	synchronize_rcu();
+
 	del_timer_sync(&tid_rx->session_timer);
 	del_timer_sync(&tid_rx->reorder_timer);
 
-	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
+	ieee80211_free_tid_rx(tid_rx);
 }
 
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ab05768..d73e05d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -157,7 +157,6 @@ struct tid_ampdu_tx {
  * dialog token being used only for debugging).
  */
 struct tid_ampdu_rx {
-	struct rcu_head rcu_head;
 	spinlock_t reorder_lock;
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
-- 
1.7.1

