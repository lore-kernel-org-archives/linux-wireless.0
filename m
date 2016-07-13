Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34114 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbcGMUUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2016 16:20:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id q128so2661849wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jul 2016 13:20:06 -0700 (PDT)
From: Alex Briskin <br.shurik@gmail.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Alex Briskin <br.shurik@gmail.com>
Subject: [PATCH 2/4 v1] even better readability
Date: Wed, 13 Jul 2016 23:19:54 +0300
Message-Id: <1468441196-23503-3-git-send-email-br.shurik@gmail.com> (sfid-20160713_222012_050393_852FB7EE)
In-Reply-To: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
References: <1468441196-23503-1-git-send-email-br.shurik@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Further improve readability by replacing if else with switch case

Signed-off-by: Alex Briskin <br.shurik@gmail.com>
---
 net/mac80211/iface.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a68cbac..1793ad2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1207,13 +1207,16 @@ static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
 
-	if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_START) {
+	switch (skb->pkt_type) {
+	case IEEE80211_SDATA_QUEUE_AGG_START:
 		ra_tid = (void *)&skb->cb;
 		ieee80211_start_tx_ba_cb(&sdata->vif, ra_tid->ra, ra_tid->tid);
-	} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_AGG_STOP) {
+		break;
+	case IEEE80211_SDATA_QUEUE_AGG_STOP:
 		ra_tid = (void *)&skb->cb;
 		ieee80211_stop_tx_ba_cb(&sdata->vif, ra_tid->ra, ra_tid->tid);
-	} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_START) {
+		break;
+	case IEEE80211_SDATA_QUEUE_RX_AGG_START:
 		rx_agg = (void *)&skb->cb;
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get_bss(sdata, rx_agg->addr);
@@ -1223,7 +1226,8 @@ static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
 							IEEE80211_MAX_AMPDU_BUF,
 							false, true);
 		mutex_unlock(&local->sta_mtx);
-	} else if (skb->pkt_type == IEEE80211_SDATA_QUEUE_RX_AGG_STOP) {
+		break;
+	case IEEE80211_SDATA_QUEUE_RX_AGG_STOP:
 		rx_agg = (void *)&skb->cb;
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get_bss(sdata, rx_agg->addr);
@@ -1233,7 +1237,8 @@ static bool ieee80211_is_skb_handled_by_pkt_type(struct sk_buff *skb,
 						       WLAN_BACK_RECIPIENT, 0,
 						       false);
 		mutex_unlock(&local->sta_mtx);
-	} else {
+		break;
+	default:
 		return false;
 	}
 	/*will return true if pkt_type found and handled */
-- 
2.5.0

