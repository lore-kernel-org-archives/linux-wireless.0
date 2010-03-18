Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:62672 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0CRPht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 11:37:49 -0400
Received: by ywh2 with SMTP id 2so142071ywh.33
        for <linux-wireless@vger.kernel.org>; Thu, 18 Mar 2010 08:37:48 -0700 (PDT)
Message-ID: <4BA24790.4040602@gmail.com>
Date: Thu, 18 Mar 2010 16:32:32 +0100
From: "lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Larry.Finger@lwfinger.ne, br1@einfach.org, ht6100@gmail.com
Subject: [PATCH V2] mac80211: Revise,pending queue depth in ieee80211_local
 data structure
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I resend the patch in order to fix style violations that Larry suggested me.

I noticed a possible issue in the pending queue management of the
ieee80211_local data structure. In particular, there is no control of the queue
depth and this could cause a memory overflow. In the tests I carried out I
obtain a memory overflow when I use a low priority queue (e.g. Backgreound
queue) and I transmit a data stream that exceeds the channel capacity (e.g.
50Mbps@MCS 3, 800ns GI and 20MHz channel width). I tested the patch below on the
last compat-wireless (2010-03-03) on an AR9280 chipset (Ubiquiti Rocket M with
the latest version of OpenWrt trunk).

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -703,6 +703,8 @@
  	struct work_struct sta_finish_work;
  	int sta_generation;

+/* Pending buffer dimension */
+#define PENDING_BUF	512
  	struct sk_buff_head pending[IEEE80211_MAX_QUEUES];
  	struct tasklet_struct tx_pending_tasklet;

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1403,10 +1403,17 @@
  		if (local->queue_stop_reasons[queue] ||
  		    !skb_queue_empty(&local->pending[queue])) {
  			/*
-			 * if queue is stopped, queue up frames for later
-			 * transmission from the tasklet
+			 * if queue is stopped and there is enough space
+			 * in the queue, queue up frames for later transmission
+			 * from the tasklet
  			 */
-			do {
+			if (skb_queue_len(&local->pending[queue])
+					  >= PENDING_BUF) {
+				spin_unlock_irqrestore(
+						&local->queue_stop_reason_lock,
+						flags);
+				goto drop;
+			} do {
  				next = skb->next;
  				skb->next = NULL;
  				if (unlikely(txpending))
@@ -2028,8 +2035,14 @@
  						flags);

  			txok = ieee80211_tx_pending_skb(local, skb);
-			if (!txok)
-				__skb_queue_head(&local->pending[i], skb);
+			if (!txok) {
+				if (skb_queue_len(&local->pending[i])
+						  < PENDING_BUF)
+					__skb_queue_head(&local->pending[i],
+							 skb);
+				else
+					kfree_skb(skb);
+			}
  			spin_lock_irqsave(&local->queue_stop_reason_lock,
  					  flags);
  			if (!txok)
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -383,7 +383,10 @@

  	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
  	__ieee80211_stop_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
-	__skb_queue_tail(&local->pending[queue], skb);
+	if (skb_queue_len(&local->pending[queue]) < PENDING_BUF)
+		__skb_queue_tail(&local->pending[queue], skb);
+	else
+		kfree_skb(skb);
  	__ieee80211_wake_queue(hw, queue, IEEE80211_QUEUE_STOP_REASON_SKB_ADD);
  	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
  }
@@ -409,9 +412,12 @@
  			continue;
  		}

-		ret++;
  		queue = skb_get_queue_mapping(skb);
-		__skb_queue_tail(&local->pending[queue], skb);
+		if (skb_queue_len(&local->pending[queue]) < PENDING_BUF) {
+			ret++;
+			__skb_queue_tail(&local->pending[queue], skb);
+		} else
+			kfree_skb(skb);
  	}

  	for (i = 0; i < hw->queues; i++)
--

Regards

Lorenzo
