Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60783 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757744Ab0KPTs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 14:48:56 -0500
Subject: [PATCH] mac80211: fix powersaving clients races
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 11:50:28 -0800
Message-ID: <1289937028.3673.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code to handle powersaving stations has a race:
when the powersave flag is lifted from a station,
we could transmit a packet that is being processed
for TX at the same time right away, even if there
are other frames queued for it. This would cause
frame reordering. To fix this, lift the flag only
under the appropriate lock that blocks TX.

Additionally, the code to allow drivers to block a
station while frames for it are on the HW queue is
never re-enabled the station, so traffic would get
stuck indefinitely. Fix this by clearing the flag
for this appropriately.

Finally, as an optimisation, don't do anything if
the driver unblocks an already unblocked station.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/rx.c          |    2 --
 net/mac80211/sta_info.c    |   17 ++++++++++++++---
 net/mac80211/util.c        |   14 ++++++++++++--
 4 files changed, 29 insertions(+), 7 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-11-16 11:30:12.000000000 -0800
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-11-16 11:30:19.000000000 -0800
@@ -1278,6 +1278,9 @@ void ieee80211_add_pending_skb(struct ie
 			       struct sk_buff *skb);
 int ieee80211_add_pending_skbs(struct ieee80211_local *local,
 			       struct sk_buff_head *skbs);
+int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
+				  struct sk_buff_head *skbs,
+				  void (*fn)(void *data), void *data);
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
--- wireless-testing.orig/net/mac80211/rx.c	2010-11-16 11:27:41.000000000 -0800
+++ wireless-testing/net/mac80211/rx.c	2010-11-16 11:30:19.000000000 -0800
@@ -1102,8 +1102,6 @@ static void ap_sta_ps_end(struct sta_inf
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
-	clear_sta_flags(sta, WLAN_STA_PS_STA);
-
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
 	printk(KERN_DEBUG "%s: STA %pM aid %d exits power save mode\n",
 	       sdata->name, sta->sta.addr, sta->sta.aid);
--- wireless-testing.orig/net/mac80211/sta_info.c	2010-11-16 11:30:12.000000000 -0800
+++ wireless-testing/net/mac80211/sta_info.c	2010-11-16 11:30:19.000000000 -0800
@@ -199,8 +199,11 @@ static void sta_unblock(struct work_stru
 
 	if (!test_sta_flags(sta, WLAN_STA_PS_STA))
 		ieee80211_sta_ps_deliver_wakeup(sta);
-	else if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL))
+	else if (test_and_clear_sta_flags(sta, WLAN_STA_PSPOLL)) {
+		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
 		ieee80211_sta_ps_deliver_poll_response(sta);
+	} else
+		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
 }
 
 static int sta_prepare_rate_control(struct ieee80211_local *local,
@@ -880,6 +883,13 @@ struct ieee80211_sta *ieee80211_find_sta
 }
 EXPORT_SYMBOL(ieee80211_find_sta);
 
+static void clear_sta_ps_flags(void *_sta)
+{
+	struct sta_info *sta = _sta;
+
+	clear_sta_flags(sta, WLAN_STA_PS_DRIVER | WLAN_STA_PS_STA);
+}
+
 /* powersave support code */
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 {
@@ -894,7 +904,8 @@ void ieee80211_sta_ps_deliver_wakeup(str
 
 	/* Send all buffered frames to the station */
 	sent = ieee80211_add_pending_skbs(local, &sta->tx_filtered);
-	buffered = ieee80211_add_pending_skbs(local, &sta->ps_tx_buf);
+	buffered = ieee80211_add_pending_skbs_fn(local, &sta->ps_tx_buf,
+						 clear_sta_ps_flags, sta);
 	sent += buffered;
 	local->total_ps_buffered -= buffered;
 
@@ -973,7 +984,7 @@ void ieee80211_sta_block_awake(struct ie
 
 	if (block)
 		set_sta_flags(sta, WLAN_STA_PS_DRIVER);
-	else
+	else if (test_sta_flags(sta, WLAN_STA_PS_DRIVER))
 		ieee80211_queue_work(hw, &sta->drv_unblock_wk);
 }
 EXPORT_SYMBOL(ieee80211_sta_block_awake);
--- wireless-testing.orig/net/mac80211/util.c	2010-11-16 11:27:41.000000000 -0800
+++ wireless-testing/net/mac80211/util.c	2010-11-16 11:30:19.000000000 -0800
@@ -368,8 +368,9 @@ void ieee80211_add_pending_skb(struct ie
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-int ieee80211_add_pending_skbs(struct ieee80211_local *local,
-			       struct sk_buff_head *skbs)
+int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
+				  struct sk_buff_head *skbs,
+				  void (*fn)(void *data), void *data)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct sk_buff *skb;
@@ -394,6 +395,9 @@ int ieee80211_add_pending_skbs(struct ie
 		__skb_queue_tail(&local->pending[queue], skb);
 	}
 
+	if (fn)
+		fn(data);
+
 	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i,
 			IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
@@ -402,6 +406,12 @@ int ieee80211_add_pending_skbs(struct ie
 	return ret;
 }
 
+int ieee80211_add_pending_skbs(struct ieee80211_local *local,
+			       struct sk_buff_head *skbs)
+{
+	return ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
+}
+
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				    enum queue_stop_reason reason)
 {


