Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748AbZGXSNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/14] iwlwifi: fix TX queue race
Date: Fri, 24 Jul 2009 11:13:07 -0700
Message-Id: <1248459194-10239-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

I had a problem on 4965 hardware (well, probably other hardware too,
but others don't survive my stress testing right now, unfortunately)
where the driver was sending invalid commands to the device, but no
such thing could be seen from the driver's point of view. I could
reproduce this fairly easily by sending multiple TCP streams with
iperf on different TIDs, though sometimes a single iperf stream was
sufficient. It even happened with a single core, but I have forced
preemption turned on.

The culprit was a queue overrun, where we advanced the queue's write
pointer over the read pointer. After careful analysis I've come to
the conclusion that the cause is a race condition between iwlwifi
and mac80211.

mac80211, of course, checks whether the queue is stopped, before
transmitting a frame. This effectively looks like this:

        lock(queues)
        if (stopped(queue)) {
                unlock(queues)
                return busy;
	}
        unlock(queues)
        ...             <-- this place will be important
			    there is some more code here
        drv_tx(frame)

The driver, on the other hand, can stop and start queues, which does

        lock(queues)
        mark_running/stopped(queue)
        unlock(queues)

	[if marked running: wake up tasklet to send pending frames]

Now, however, once the driver starts the queue, mac80211 can see that
and end up at the marked place above, at which point for some reason the
driver seems to stop the queue again (I don't understand that) and then
we end up transmitting while the queue is actually full.

Now, this shouldn't actually matter much, but for some reason I've seen
it happen multiple times in a row and the queue actually overflows, at
which point the queue bites itself in the tail and things go completely
wrong.

This patch fixes this by just dropping the packet should this have
happened, and making the lock in iwlwifi cover everything so iwlwifi
can't race against itself (dropping the lock there might make it more
likely, but it did seem to happen without that too).

Since we can't hold the lock across drv_tx() above, I see no way to fix
this in mac80211, but I also don't understand why I haven't seen this
before -- maybe I just never stress tested it this badly.

With this patch, the device has survived many minutes of simultanously
sending two iperf streams on different TIDs with combined throughput
of about 60 Mbps.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index e1558db..5a997f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -737,8 +737,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		goto drop_unlock;
 	}
 
-	spin_unlock_irqrestore(&priv->lock, flags);
-
 	hdr_len = ieee80211_hdrlen(fc);
 
 	/* Find (or create) index into station table for destination station */
@@ -746,7 +744,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_id == IWL_INVALID_STATION) {
 		IWL_DEBUG_DROP(priv, "Dropping - INVALID STATION: %pM\n",
 			       hdr->addr1);
-		goto drop;
+		goto drop_unlock;
 	}
 
 	IWL_DEBUG_TX(priv, "station Id %d\n", sta_id);
@@ -764,14 +762,17 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		/* aggregation is on for this <sta,tid> */
 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
-		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
 
 	txq = &priv->txq[txq_id];
 	swq_id = txq->swq_id;
 	q = &txq->q;
 
-	spin_lock_irqsave(&priv->lock, flags);
+	if (unlikely(iwl_queue_space(q) < q->high_mark))
+		goto drop_unlock;
+
+	if (ieee80211_is_data_qos(fc))
+		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 
 	/* Set up driver data for this TFD */
 	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
@@ -917,7 +918,6 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 drop_unlock:
 	spin_unlock_irqrestore(&priv->lock, flags);
-drop:
 	return -1;
 }
 EXPORT_SYMBOL(iwl_tx_skb);
-- 
1.5.6.3

