Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36341 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbcGOJGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 05:06:43 -0400
Received: by mail-wm0-f67.google.com with SMTP id x83so1354668wma.3
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2016 02:06:42 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 1/4 v2 iface_work] New function  ieee80211_is_skb_handled_by_pkt_type
Date: Fri, 15 Jul 2016 12:06:33 +0300
Message-Id: <1468573596-20055-1-git-send-email-br.shurik@gmail.com> (sfid-20160715_110657_746907_90A1C6D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split ieee80211_iface_work in two. Moved part of a code that checks
pkt_type.

Signed-off-by: Alex Briskin <br.shurik@gmail.com>
---
 net/mac80211/iface.c | 75 +++++++++++++++++++++++++++++++---------------------
 1 file changed, 45 insertions(+), 30 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c59af3e..a68cbac 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1198,6 +1198,48 @@ static void ieee80211_if_setup(struct net_device *dev)
 	dev->destructor = ieee80211_if_free;
 }
 
+static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
+						 struct ieee80211_sub_if_data
+						 *sdata)
+{
+	struct ieee80211_ra_tid *ra_tid;
+	struct ieee80211_rx_agg *rx_agg;
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+
+	if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
+		ra_tid = (void *)&skb->cb;
+		ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra, ra_tid->tid);
+	} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_STOP) {
+		ra_tid = (void *)&skb->cb;
+		ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra, ra_tid->tid);
+	} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_START) {
+		rx_agg = (void *)&skb->cb;
+		mutex_lock(&local->sta_mtx);
+		sta = sta_info_get_bss(sdata, rx_agg->addr);
+		if (sta)
+			__ieee80211_start_rx_ba_session(sta,
+							0, 0, 0, 1, rx_agg->tid,
+							IEEE80211_MAX_AMPDU_BUF,
+							false, true);
+		mutex_unlock(&local->sta_mtx);
+	} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_STOP) {
+		rx_agg = (void *)&skb->cb;
+		mutex_lock(&local->sta_mtx);
+		sta = sta_info_get_bss(sdata, rx_agg->addr);
+		if (sta)
+			__ieee80211_stop_rx_ba_session(sta,
+						       rx_agg->tid,
+						       WLAN_BACK_RECIPIENT, 0,
+						       false);
+		mutex_unlock(&local->sta_mtx);
+	} else {
+		return false;
+	}
+	/*will return true if pkt_type found and handled */
+	return true;
+}
+
 static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -1205,8 +1247,6 @@ static void ieee80211_iface_work(struct work_struct *work)
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
-	struct ieee80211_ra_tid *ra_tid;
-	struct ieee80211_rx_agg *rx_agg;
 
 	if (!ieee80211_sdata_running(sdata))
 		return;
@@ -1221,34 +1261,8 @@ static void ieee80211_iface_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&sdata->skb_queue))) {
 		struct ieee80211_mgmt *mgmt = (void *)skb->data;
 
-		if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
-			ra_tid = (void *)&skb->cb;
-			ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra,
-						 ra_tid->tid);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_STOP) {
-			ra_tid = (void *)&skb->cb;
-			ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra,
-						ra_tid->tid);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_START) {
-			rx_agg = (void *)&skb->cb;
-			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get_bss(sdata, rx_agg->addr);
-			if (sta)
-				__ieee80211_start_rx_ba_session(sta,
-						0, 0, 0, 1, rx_agg->tid,
-						IEEE80211_MAX_AMPDU_BUF,
-						false, true);
-			mutex_unlock(&local->sta_mtx);
-		} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_STOP) {
-			rx_agg = (void *)&skb->cb;
-			mutex_lock(&local->sta_mtx);
-			sta = sta_info_get_bss(sdata, rx_agg->addr);
-			if (sta)
-				__ieee80211_stop_rx_ba_session(sta,
-							rx_agg->tid,
-							WLAN_BACK_RECIPIENT, 0,
-							false);
-			mutex_unlock(&local->sta_mtx);
+		if (ieee80211_is_skb_handled_by_pkt_type(skb, sdata)) {
+			goto free_skb;
 		} else if (ieee80211_is_action(mgmt->frame_control) &&
 			   mgmt->u.action.category == WLAN_CATEGORY_BACK) {
 			int len = skb->len;
@@ -1333,6 +1347,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 			break;
 		}
 
+free_skb:
 		kfree_skb(skb);
 	}
 
-- 
2.5.0

