Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756724Ab2CGSb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 13:31:27 -0500
Date: Wed, 7 Mar 2012 19:31:04 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 3.3 v2] rt2x00: fix random stalls
Message-ID: <20120307183103.GB15839@redhat.com> (sfid-20120307_193130_855517_C4DB06F2)
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
buffers on different cpu. This might happen if for example intterrupt
will be triggered on cpu performing rt2x00mac_tx().

To prevent race conditions serialize pause/unpause by queue->tx_lock.

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2:
 - use spin_lock_bh
 - serialize also rt2x00queue_threshold()

 drivers/net/wireless/rt2x00/rt2x00dev.c |    6 +++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c |    7 +++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 49a51b4..61a5042 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -430,10 +430,14 @@ void rt2x00lib_txdone(struct queue_entry *entry,
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
index ede3c58..923702c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -152,13 +152,20 @@ void rt2x00mac_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (unlikely(rt2x00queue_write_tx_frame(queue, skb, false)))
 		goto exit_fail;
 
+	/*
+	 * Pausing queue has to be serialized with rt2x00lib_txdone() .
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
-- 
1.7.1

