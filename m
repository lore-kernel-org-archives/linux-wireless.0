Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab2CILkO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 06:40:14 -0500
Date: Fri, 9 Mar 2012 12:39:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 3.3 v3] rt2x00: fix random stalls
Message-ID: <20120309113953.GB2339@redhat.com> (sfid-20120309_124019_196587_F3048DAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is possible that we stop queue and then do not wake up it again,
especially when packets are transmitted fast. That can be easily
reproduced with modified tx queue entry_num to some small value e.g. 16.

If mac80211 already hold local->queue_stop_reason_lock, then we can wait
on that lock in both rt2x00queue_pause_queue() and
rt2x00queue_unpause_queue(). After drooping ->queue_stop_reason_lock
is possible that __ieee80211_wake_queue() will be performed before
__ieee80211_stop_queue(), hence we stop queue and newer wake up it
again.

Another race condition is possible when between rt2x00queue_threshold()
check and rt2x00queue_pause_queue() we will process all pending tx
buffers on different cpu. This might happen if for example interrupt
will be triggered on cpu performing rt2x00mac_tx().

To prevent race conditions serialize pause/unpause by queue->tx_lock.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
v1 -> v2: 
 - use spin_lock_bh
 - serialize also rt2x00queue_threshold()
v2 -> v3:
 - comment lack of _bh usage in rt2x00mac_tx()

 drivers/net/wireless/rt2x00/rt2x00dev.c   |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c   |    9 +++++++++
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 +++
 3 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index d2a1ea9..fd356b7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -426,10 +426,14 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	/*
 	 * If the data queue was below the threshold before the txdone
 	 * handler we must make sure the packet queue in the mac80211 stack
-	 * is reenabled when the txdone handler has finished.
+	 * is reenabled when the txdone handler has finished. This has to be
+	 * serialized with rt2x00mac_tx(), otherwise we can wake up queue
+	 * before it was stopped.
 	 */
+	spin_lock_bh(&entry->queue->tx_lock);
 	if (!rt2x00queue_threshold(entry->queue))
 		rt2x00queue_unpause_queue(entry->queue);
+	spin_unlock_bh(&entry->queue->tx_lock);
 }
 EXPORT_SYMBOL_GPL(rt2x00lib_txdone);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index ede3c58..2df2eb6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -152,13 +152,22 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
 		goto exit_fail;
 
+	/*
+	 * Pausing queue has to be serialized with rt2x00lib_txdone(). Note
+	 * we should not use spin_lock_bh variant as bottom halve was already
+	 * disabled before ieee80211_xmit() call.
+	 */
+	spin_lock(&queue->tx_lock);
 	if (rt2x00queue_threshold(queue))
 		rt2x00queue_pause_queue(queue);
+	spin_unlock(&queue->tx_lock);
 
 	return;
 
  exit_fail:
+	spin_lock(&queue->tx_lock);
 	rt2x00queue_pause_queue(queue);
+	spin_unlock(&queue->tx_lock);
  exit_free_skb:
 	ieee80211_free_txskb(hw, skb);
 }
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 5adfb3e..9b1b2b7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -619,6 +619,9 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb,
 	else if (test_bit(REQUIRE_DMA, &queue->rt2x00dev->cap_flags))
 		rt2x00queue_align_frame(skb);
 
+	/*
+	 * That function must be called with bh disabled.
+	 */
 	spin_lock(&queue->tx_lock);
 
 	if (unlikely(rt2x00queue_full(queue))) {
-- 
1.7.1

