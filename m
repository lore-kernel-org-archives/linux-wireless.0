Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756464AbYAULwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:52:24 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 04/12] mac80211: A-MPDU Tx MLME data initialization
Date: Mon, 21 Jan 2008 13:52:04 +0200
Message-Id: <12009163393109-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115239_390766_464BA6E2)
In-Reply-To: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch initialize A-MPDU MLME data for Tx sessions.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 net/mac80211/sta_info.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index c964082..7c65849 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -117,8 +117,10 @@ static void sta_info_release(struct kref *kref)
 	while ((skb = skb_dequeue(&sta->tx_filtered)) != NULL) {
 		dev_kfree_skb_any(skb);
 	}
-	for (i = 0; i <  STA_TID_NUM; i++)
+	for (i = 0; i <  STA_TID_NUM; i++) {
 		del_timer_sync(&sta->ampdu_mlme.tid_rx[i].session_timer);
+		del_timer_sync(&sta->ampdu_mlme.tid_tx[i].addba_resp_timer);
+	}
 	rate_control_free_sta(sta->rate_ctrl, sta->rate_ctrl_priv);
 	rate_control_put(sta->rate_ctrl);
 	kfree(sta);
@@ -157,17 +159,26 @@ struct sta_info * sta_info_add(struct ieee80211_local *local,
 	sta->local = local;
 	sta->dev = dev;
 	spin_lock_init(&sta->ampdu_mlme.ampdu_rx);
+	spin_lock_init(&sta->ampdu_mlme.ampdu_tx);
 	for (i = 0; i < STA_TID_NUM; i++) {
 		/* timer_to_tid must be initialized with identity mapping to
 		 * enable session_timer's data differentiation. refer to
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
+		/* tid to tx queue: initialize according to HW (0 is valid) */
+		sta->tid_to_tx_q[i] = local->hw.queues;
 		/* rx timers */
 		sta->ampdu_mlme.tid_rx[i].session_timer.function =
 			sta_rx_agg_session_timer_expired;
 		sta->ampdu_mlme.tid_rx[i].session_timer.data =
 			(unsigned long)&sta->timer_to_tid[i];
 		init_timer(&sta->ampdu_mlme.tid_rx[i].session_timer);
+		/* tx timers */
+		sta->ampdu_mlme.tid_tx[i].addba_resp_timer.function =
+			sta_addba_resp_timer_expired;
+		sta->ampdu_mlme.tid_tx[i].addba_resp_timer.data =
+			(unsigned long)&sta->timer_to_tid[i];
+		init_timer(&sta->ampdu_mlme.tid_tx[i].addba_resp_timer);
 	}
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
-- 
1.5.3.7

