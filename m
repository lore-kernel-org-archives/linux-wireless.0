Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22015 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab2DWTPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 15:15:06 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: use queue helpers to suspend/resume transmission
Date: Tue, 24 Apr 2012 00:45:39 +0530
Message-ID: <1335208539-31325-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120423_211511_485009_663C6740)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The powersave notification and scan suspen/resume directly calls
netif_tx_* functions to stop and wakeup tx queue instead ieee80211
utils. As the stop queue reason is not set, the transmission can be
resumed accidentally in the middle of channel set or driver flush.
So this patch replaces netif_tx_* functions by ieee80211_*_queue helper
utility functions.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |    6 ++++--
 net/mac80211/offchannel.c  |   19 +++++--------------
 net/mac80211/tx.c          |   16 ++++++++++++----
 4 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bd7a451..7181e6a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -780,6 +780,7 @@ enum queue_stop_reason {
 	IEEE80211_QUEUE_STOP_REASON_AGGREGATION,
 	IEEE80211_QUEUE_STOP_REASON_SUSPEND,
 	IEEE80211_QUEUE_STOP_REASON_SKB_ADD,
+	IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE,
 };
 
 #ifdef CONFIG_MAC80211_LEDS
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c8836fa..82fc068 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1085,7 +1085,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 
 	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
 	    !(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
-		netif_tx_stop_all_queues(sdata->dev);
+		ieee80211_stop_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE);
 
 		if (drv_tx_frames_pending(local))
 			mod_timer(&local->dynamic_ps_timer, jiffies +
@@ -1107,7 +1108,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	}
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
-		netif_tx_wake_all_queues(sdata->dev);
+		ieee80211_wake_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE);
 }
 
 void ieee80211_dynamic_ps_timer(unsigned long data)
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f054e94..4e14c42 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -128,7 +128,8 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 				sdata, BSS_CHANGED_BEACON_ENABLED);
 
 		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			netif_tx_stop_all_queues(sdata->dev);
+			ieee80211_stop_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE);
 			if (offchannel_ps_enable &&
 			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
 			    sdata->u.mgd.associated)
@@ -158,19 +159,9 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 				ieee80211_offchannel_ps_disable(sdata);
 		}
 
-		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
-			/*
-			 * This may wake up queues even though the driver
-			 * currently has them stopped. This is not very
-			 * likely, since the driver won't have gotten any
-			 * (or hardly any) new packets while we weren't
-			 * on the right channel, and even if it happens
-			 * it will at most lead to queueing up one more
-			 * packet per queue in mac80211 rather than on
-			 * the interface qdisc.
-			 */
-			netif_tx_wake_all_queues(sdata->dev);
-		}
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
+			ieee80211_wake_queues_by_reason(&local->hw,
+				IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE);
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 0abbef95..f85d728 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1221,6 +1221,8 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 	skb_queue_walk_safe(skbs, skb, tmp) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		int q = info->hw_queue;
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+		bool defer_tx = false;
 
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (WARN_ON_ONCE(q >= local->hw.queues)) {
@@ -1231,7 +1233,16 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 #endif
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		if (local->queue_stop_reasons[q] ||
+		if (local->queue_stop_reasons[q]) {
+			defer_tx = true;
+			if (test_bit(IEEE80211_QUEUE_STOP_REASON_ALLOW_PROBE,
+					&local->queue_stop_reasons[q]) &&
+			    (ieee80211_is_probe_req(hdr->frame_control) ||
+			     ieee80211_is_nullfunc(hdr->frame_control)))
+				defer_tx = false;
+		}
+		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
+		if (defer_tx ||
 		    (!txpending && !skb_queue_empty(&local->pending[q]))) {
 			/*
 			 * Since queue is stopped, queue up frames for later
@@ -1244,11 +1255,8 @@ static bool ieee80211_tx_frags(struct ieee80211_local *local,
 				skb_queue_splice_tail_init(skbs,
 							   &local->pending[q]);
 
-			spin_unlock_irqrestore(&local->queue_stop_reason_lock,
-					       flags);
 			return false;
 		}
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
 		info->control.vif = vif;
 		info->control.sta = sta;
-- 
1.7.10

