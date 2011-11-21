Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50482 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921Ab1KUCXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Nov 2011 21:23:13 -0500
Received: by yenq3 with SMTP id q3so4209472yen.19
        for <linux-wireless@vger.kernel.org>; Sun, 20 Nov 2011 18:23:12 -0800 (PST)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, kolya <mar.kolya@gmail.com>
Subject: [PATCH 2/3] mac80211: use WLAN_BACK_RECIPIENT instead of hardcoded 0
Date: Sun, 20 Nov 2011 21:22:51 -0500
Message-Id: <1321842172-6732-3-git-send-email-mar.kolya@gmail.com> (sfid-20111121_032317_379708_83A50D25)
In-Reply-To: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
References: <1321842172-6732-1-git-send-email-mar.kolya@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: kolya <mar.kolya@gmail.com>

---
 net/mac80211/agg-rx.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 476b106..449d77b 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -73,8 +73,9 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
-	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u\n",
-	       sta->sta.addr, tid);
+	printk(KERN_DEBUG "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
+	       sta->sta.addr, tid, initiator == WLAN_BACK_RECIPIENT ? "recipient" : "inititator",
+               (int)reason);
 #endif /* CONFIG_MAC80211_HT_DEBUG */
 
 	if (drv_ampdu_action(local, sta->sdata, IEEE80211_AMPDU_RX_STOP,
@@ -85,7 +86,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 	/* check if this is a self generated aggregation halt */
 	if (initiator == WLAN_BACK_RECIPIENT && tx)
 		ieee80211_send_delba(sta->sdata, sta->sta.addr,
-				     tid, 0, reason);
+				     tid, WLAN_BACK_RECIPIENT, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
 	del_timer_sync(&tid_rx->reorder_timer);
-- 
1.7.4.1

