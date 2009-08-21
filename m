Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbZHUMor (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 08:44:47 -0400
Subject: [PATCH] mac80211: remove tasklet enable/disable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 14:44:45 +0200
Message-Id: <1250858685.5137.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to the way the tasklets work in mac80211 there's
no need to ever disable them.

However, we need to clear the pending packets when
taking down the last interface because otherwise
the tx_pending_tasklet might be queued if the
driver mucks with the queues (which it shouldn't).

I've had a situation occasionally with ar9170 in
which ksoftirq was using 100% CPU time because
a disabled tasklet was scheduled, and I think that
was due to ar9170 receiving a packet while the
tasklet was disabled. That's strange and it really
should not do that for other reasons, but there's
no need to waste that much CPU time over it, it
should just warn instead.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/driver-ops.h  |   14 +++++++++++++-
 net/mac80211/ieee80211_i.h |    3 +++
 net/mac80211/iface.c       |    9 +--------
 net/mac80211/main.c        |    2 --
 net/mac80211/rx.c          |    9 +++++++++
 5 files changed, 26 insertions(+), 11 deletions(-)

--- wireless-testing.orig/net/mac80211/main.c	2009-08-21 14:28:57.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-08-21 14:28:58.000000000 +0200
@@ -715,12 +715,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 		skb_queue_head_init(&local->pending[i]);
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
 		     (unsigned long)local);
-	tasklet_disable(&local->tx_pending_tasklet);
 
 	tasklet_init(&local->tasklet,
 		     ieee80211_tasklet_handler,
 		     (unsigned long) local);
-	tasklet_disable(&local->tasklet);
 
 	skb_queue_head_init(&local->skb_queue);
 	skb_queue_head_init(&local->skb_queue_unreliable);
--- wireless-testing.orig/net/mac80211/iface.c	2009-08-21 14:28:57.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-08-21 14:30:33.000000000 +0200
@@ -277,11 +277,6 @@ static int ieee80211_open(struct net_dev
 		}
 	}
 
-	if (local->open_count == 0) {
-		tasklet_enable(&local->tx_pending_tasklet);
-		tasklet_enable(&local->tasklet);
-	}
-
 	/*
 	 * set_multicast_list will be invoked by the networking core
 	 * which will check whether any increments here were done in
@@ -552,11 +547,9 @@ static int ieee80211_stop(struct net_dev
 	ieee80211_recalc_ps(local, -1);
 
 	if (local->open_count == 0) {
+		ieee80211_clear_tx_pending(local);
 		ieee80211_stop_device(local);
 
-		tasklet_disable(&local->tx_pending_tasklet);
-		tasklet_disable(&local->tasklet);
-
 		/* no reconfiguring after stop! */
 		hw_reconf_flags = 0;
 	}
--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-08-21 14:28:57.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2009-08-21 14:36:43.000000000 +0200
@@ -12,7 +12,11 @@ static inline int drv_tx(struct ieee8021
 
 static inline int drv_start(struct ieee80211_local *local)
 {
-	int ret = local->ops->start(&local->hw);
+	int ret;
+
+	local->started = true;
+	smp_mb();
+	ret = local->ops->start(&local->hw);
 	trace_drv_start(local, ret);
 	return ret;
 }
@@ -21,6 +25,14 @@ static inline void drv_stop(struct ieee8
 {
 	local->ops->stop(&local->hw);
 	trace_drv_stop(local);
+
+	/* sync away all work on the tasklet before clearing started */
+	tasklet_disable(&local->tasklet);
+	tasklet_enable(&local->tasklet);
+
+	barrier();
+
+	local->started = false;
 }
 
 static inline int drv_add_interface(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-08-21 14:28:57.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-08-21 14:37:11.000000000 +0200
@@ -659,6 +659,9 @@ struct ieee80211_local {
 	 */
 	bool quiescing;
 
+	/* device is started */
+	bool started;
+
 	int tx_headroom; /* required headroom for hardware/radiotap */
 
 	/* Tasklet and skb queue to process calls from IRQ mode. All frames
--- wireless-testing.orig/net/mac80211/rx.c	2009-08-21 14:28:57.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2009-08-21 14:35:23.000000000 +0200
@@ -2465,6 +2465,15 @@ void __ieee80211_rx(struct ieee80211_hw 
 		return;
 	}
 
+	/*
+	 * The same happens when we're not even started,
+	 * but that's worth a warning.
+	 */
+	if (WARN_ON(!local->started)) {
+		kfree_skb(skb);
+		return;
+	}
+
 	if (status->flag & RX_FLAG_HT) {
 		/* rate_idx is MCS index */
 		if (WARN_ON(status->rate_idx < 0 ||


