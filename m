Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39755 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0DSJA2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 05:00:28 -0400
Subject: [PATCH] mac80211: fix stopping RX BA session from timer
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87wrw3lxjh.fsf@purkki.valot.fi>
References: <87pr20mrez.fsf@purkki.valot.fi>
	 <20100415195812.GC3020@tuxdriver.com> <871veclztk.fsf@purkki.valot.fi>
	 <1271659397.3873.9.camel@jlt3.sipsolutions.net>
	 <87wrw3lxjh.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 11:00:24 +0200
Message-ID: <1271667624.3873.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle reported that his system deadlocks since my
recent work in this area. The reason quickly became
apparent: we try to cancel_timer_sync() a timer
from within itself. Fix that by making the function
aware of the context it is called from.

Reported-by: Kalle Valo <kvalo@adurom.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Please apply after Kalle confirms it fixes the problem.

 net/mac80211/agg-rx.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/mac80211/agg-rx.c	2010-04-19 10:49:25.000000000 +0200
+++ wireless-testing/net/mac80211/agg-rx.c	2010-04-19 10:51:57.000000000 +0200
@@ -18,8 +18,9 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
-				    u16 initiator, u16 reason)
+static void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+					    u16 initiator, u16 reason,
+					    bool from_timer)
 {
 	struct ieee80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
@@ -69,10 +70,17 @@ void __ieee80211_stop_rx_ba_session(stru
 
 	spin_unlock_bh(&sta->lock);
 
-	del_timer_sync(&tid_rx->session_timer);
+	if (!from_timer)
+		del_timer_sync(&tid_rx->session_timer);
 	kfree(tid_rx);
 }
 
+void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
+				    u16 initiator, u16 reason)
+{
+	___ieee80211_stop_rx_ba_session(sta, tid, initiator, reason, false);
+}
+
 /*
  * After accepting the AddBA Request we activated a timer,
  * resetting it after each frame that arrives from the originator.
@@ -91,8 +99,8 @@ static void sta_rx_agg_session_timer_exp
 #ifdef CONFIG_MAC80211_HT_DEBUG
 	printk(KERN_DEBUG "rx session timer expired on tid %d\n", (u16)*ptid);
 #endif
-	__ieee80211_stop_rx_ba_session(sta, *ptid, WLAN_BACK_RECIPIENT,
-				       WLAN_REASON_QSTA_TIMEOUT);
+	___ieee80211_stop_rx_ba_session(sta, *ptid, WLAN_BACK_RECIPIENT,
+					WLAN_REASON_QSTA_TIMEOUT, true);
 }
 
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,


