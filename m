Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755217Ab2DFVBW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 17:01:22 -0400
Message-ID: <1333746081.5577.11.camel@jlt3.sipsolutions.net> (sfid-20120406_230125_204328_57E806B3)
Subject: [PATCH] compat-wireless: simplify mac80211 queue backport
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 06 Apr 2012 23:01:21 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With compat now having a define for netif_wake_subqueue
for kernels 2.6.23 and higher we can remove most of the
backport patch for multiqueue. This does give up on
kernels 2.6.22 and older though.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/22-multiqueue.patch |   95 +++---------------------------------------
 1 files changed, 7 insertions(+), 88 deletions(-)

diff --git a/patches/22-multiqueue.patch b/patches/22-multiqueue.patch
index 54926d9..0c7940c 100644
--- a/patches/22-multiqueue.patch
+++ b/patches/22-multiqueue.patch
@@ -1,4 +1,4 @@
-Backport multiqueue support for kernels < 2.6.27
+Backport multiqueue support for kernels 2.6.23-27
 
 The 2.6.23 kernel added some initial multiqueue support.
 That release relied on the on the notion of struct
@@ -18,82 +18,16 @@ here is just that all these queues share a common lock
 so stateful operations on one queue would imply a delay
 on other queues.
 
-For older kernels than 2.6.23 we can only stop all the
-queues then and wake them up only if no other queue had
-been stopped previously. This means for kernels older
-than 2.6.23 there is a performance penalty and congestion
-on one queue would imply propagating the same congestion
-impact on all the other queues.
-
 The select_queue callback was only added as of 2.6.27 via
-commit eae792b7 so for kernels older than 2.6.23 and up
-to 2.6.27 we must ensure we do the selection of the queue
-once the core networking calls mac80211's dev_hard_start_xmit()
+commit eae792b7 so for kernels 2.6.23 up to 2.6.27 we must
+ensure we do the selection of the queue once the core
+networking calls mac80211's dev_hard_start_xmit()
 (ndo_start_xmit() callback on newer kernels).
 
-This patch then consists of three parts:
-
-  1) Addresses the lack of select_queue on older kernels than 2.6.27
-  2) Extends the backport of net_device_ops for select_queue for kernels >= 2.6.27
-  3) Backporting wake/stop queue for older kernels:
-	- Handle with net_device_subqueue for >= 2.6.23
-	- Treat each queue operation as an aggregate for all queues
+This patch thus only addresses the lack of select_queue on
+kernels older than 2.6.27, naming differences are handled
+in compat.
 
-Monitor interfaces have their own select_queue -- monitor interfaces
-are used for injecting frames so they have their own respective queue
-handling, but mac80211 just always sends management frames on VO
-queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
-
---- a/net/mac80211/util.c
-+++ b/net/mac80211/util.c
-@@ -265,6 +265,18 @@ __le16 ieee80211_ctstoself_duration(stru
- }
- EXPORT_SYMBOL(ieee80211_ctstoself_duration);
- 
-+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23))
-+static bool ieee80211_all_queues_started(struct ieee80211_hw *hw)
-+{
-+	unsigned int queue;
-+
-+	for (queue = 0; queue < hw->queues; queue++)
-+		if (ieee80211_queue_stopped(hw, queue))
-+			return false;
-+	return true;
-+}
-+#endif
-+
- static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
- 				   enum queue_stop_reason reason)
- {
-@@ -287,7 +299,14 @@ static void __ieee80211_wake_queue(struc
- 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
- 			if (test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state))
- 				continue;
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
- 			netif_wake_subqueue(sdata->dev, queue);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
-+			netif_start_subqueue(sdata->dev, queue);
-+#else
-+			if (ieee80211_all_queues_started(hw))
-+				netif_wake_queue(sdata->dev);
-+#endif
- 		}
- 		rcu_read_unlock();
- 	} else
-@@ -327,7 +346,13 @@ static void __ieee80211_stop_queue(struc
- 
- 	rcu_read_lock();
- 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
-+		netif_stop_subqueue(sdata->dev, queue);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
- 		netif_stop_subqueue(sdata->dev, queue);
-+#else
-+		netif_stop_queue(sdata->dev);
-+#endif
- 	rcu_read_unlock();
- }
- 
 --- a/net/mac80211/tx.c
 +++ b/net/mac80211/tx.c
 @@ -1475,6 +1475,10 @@ void ieee80211_xmit(struct ieee80211_sub
@@ -107,18 +41,3 @@ queue by using skb_set_queue_mapping(skb, 0) through ieee80211_tx_skb()
  	ieee80211_set_qos_hdr(sdata, skb);
  	ieee80211_tx(sdata, skb, false);
  	rcu_read_unlock();
-@@ -2210,7 +2214,14 @@ void ieee80211_tx_pending(unsigned long
- 
- 		if (skb_queue_empty(&local->pending[i]))
- 			list_for_each_entry_rcu(sdata, &local->interfaces, list)
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27))
- 				netif_wake_subqueue(sdata->dev, i);
-+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23))
-+				netif_start_subqueue(sdata->dev, i);
-+#else
-+				if (ieee80211_all_queues_started(hw))
-+					netif_wake_queue(sdata->dev);
-+#endif
- 	}
- 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
- 
-- 
1.7.9.1



