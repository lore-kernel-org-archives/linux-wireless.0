Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030976Ab2CSPAm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 11:00:42 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mac80211: fix possible tid_rx->reorder_timer use after free
Date: Mon, 19 Mar 2012 16:00:26 +0100
Message-Id: <1332169226-23204-1-git-send-email-sgruszka@redhat.com> (sfid-20120319_160046_281112_FB7D1146)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that we will arm the tid_rx->reorder_timer after
del_timer_sync() in ___ieee80211_stop_rx_ba_session(). We need to stop
timer after RCU grace period finish, so move it to
ieee80211_free_tid_rx(). Timer will not be armed again, as
rcu_dereference(sta->ampdu_mlme.tid_rx[tid]) will return NULL.

Debug object detected problem with the following warning:
ODEBUG: free active (active state 0) object type: timer_list hint: sta_rx_agg_reorder_timer_expired+0x0/0xf0 [mac80211]

Bug report (with all warning messages):
https://bugzilla.redhat.com/show_bug.cgi?id=804007

Reported-by: "jan p. springer" <jsd@igroup.org>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/agg-rx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 1068f66..64d3ce5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -49,6 +49,8 @@ static void ieee80211_free_tid_rx(struct rcu_head *h)
 		container_of(h, struct tid_ampdu_rx, rcu_head);
 	int i;
 
+	del_timer_sync(&tid_rx->reorder_timer);
+
 	for (i = 0; i < tid_rx->buf_size; i++)
 		dev_kfree_skb(tid_rx->reorder_buf[i]);
 	kfree(tid_rx->reorder_buf);
@@ -91,7 +93,6 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     tid, WLAN_BACK_RECIPIENT, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
-	del_timer_sync(&tid_rx->reorder_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
-- 
1.7.1

