Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306Ab0CVUmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 16:42:39 -0400
Subject: [PATCH] mac80211: move netdev queue enabling to correct spot
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Mar 2010 13:42:43 -0700
Message-ID: <1269290563.7645.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

"mac80211: fix skb buffering issue" still left a race
between enabling the hardware queues and the virtual
interface queues. In hindsight it's totally obvious
that enabling the netdev queues for a hardware queue
when the hardware queue is enabled is wrong, because
it could well possible that we can fill the hw queue
with packets we already have pending. Thus, we must
only enable the netdev queues once all the pending
packets have been processed and sent off to the device.

In testing, I haven't been able to trigger this race
condition, but it's clearly there, possibly only when
aggregation is being enabled.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: stable@kernel.org
---
 net/mac80211/tx.c   |    6 ++++++
 net/mac80211/util.c |   12 ++++++------
 2 files changed, 12 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/mac80211/tx.c	2010-03-19 21:28:59.000000000 -0700
+++ wireless-testing/net/mac80211/tx.c	2010-03-19 21:29:13.000000000 -0700
@@ -1991,6 +1991,7 @@ static bool ieee80211_tx_pending_skb(str
 void ieee80211_tx_pending(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int i;
 	bool txok;
@@ -2029,6 +2030,11 @@ void ieee80211_tx_pending(unsigned long
 			if (!txok)
 				break;
 		}
+
+		if (skb_queue_empty(&local->pending[i]))
+			list_for_each_entry_rcu(sdata, &local->interfaces, list)
+				netif_tx_wake_queue(
+					netdev_get_tx_queue(sdata->dev, i));
 	}
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 
--- wireless-testing.orig/net/mac80211/util.c	2010-03-19 21:28:59.000000000 -0700
+++ wireless-testing/net/mac80211/util.c	2010-03-22 13:37:34.000000000 -0700
@@ -279,13 +279,13 @@ static void __ieee80211_wake_queue(struc
 		/* someone still has this queue stopped */
 		return;
 
-	if (!skb_queue_empty(&local->pending[queue]))
+	if (skb_queue_empty(&local->pending[queue])) {
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list)
+			netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
+		rcu_read_unlock();
+	} else
 		tasklet_schedule(&local->tx_pending_tasklet);
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		netif_tx_wake_queue(netdev_get_tx_queue(sdata->dev, queue));
-	rcu_read_unlock();
 }
 
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,


