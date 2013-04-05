Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:37429 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161483Ab3DEDET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 23:04:19 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>,
	<daniel@zonque.org>, Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 4/4] mwifiex: hold proper locks when accessing ra_list / bss_prio lists
Date: Thu, 4 Apr 2013 20:03:53 -0700
Message-ID: <1365131033-7417-5-git-send-email-bzhao@marvell.com> (sfid-20130405_050431_496764_49B72AA0)
In-Reply-To: <1365131033-7417-1-git-send-email-bzhao@marvell.com>
References: <1365131033-7417-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

Not locking ra_list when dequeuing packets creates race conditions.
When adding a packet 'tx_pkts_queued' is modified before setting
highest_priority_queue. If in-between the main loop starts, it will
see a packet queued (tx_pkts_queued > 0) but will not find it, since
max prio is not set yet. Depending on the scheduling, the thread
trying to add the packet could complete and restore the situation.
But this is not something to rely on.

Another race condition exists, if a new packet, exceeding current
max prio is added. If concurrently a packet is dequeued, the newly
set max prio will be overwritten with the value of the dequeued
packet. This can occur, because selecting a packet and modifying
the max prio is not atomic. The result in an infinite loop unless,
a new packet is added that has at least the priority of the hidden
packet.

Same applies to bss_prio_tbl. Forward iteration is no proper
lock-free technique and provides no protection from calls to
list_del. Although BSS are currently not added/removed dynamically,
this must not be the case in the future. Hence always hold proper
locks when accessing those lists.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/wmm.c |   55 +++++++++++++++++++-----------------
 1 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 75c8e80..2cc81ba 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -685,13 +685,13 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 	ra_list->total_pkts_size += skb->len;
 	ra_list->pkt_count++;
 
-	atomic_inc(&priv->wmm.tx_pkts_queued);
-
 	if (atomic_read(&priv->wmm.highest_queued_prio) <
 						tos_to_tid_inv[tid_down])
 		atomic_set(&priv->wmm.highest_queued_prio,
 			   tos_to_tid_inv[tid_down]);
 
+	atomic_inc(&priv->wmm.tx_pkts_queued);
+
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
 }
 
@@ -887,19 +887,15 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 	struct mwifiex_bss_prio_node *bssprio_node, *bssprio_head;
 	struct mwifiex_tid_tbl *tid_ptr;
 	atomic_t *hqp;
-	int is_list_empty;
-	unsigned long flags;
+	unsigned long flags_bss, flags_ra;
 	int i, j;
 
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				  flags);
-		is_list_empty = list_empty(&adapter->bss_prio_tbl[j]
-					   .bss_prio_head);
-		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
-				       flags);
-		if (is_list_empty)
-			continue;
+				  flags_bss);
+
+		if (list_empty(&adapter->bss_prio_tbl[j].bss_prio_head))
+			goto skip_prio_tbl;
 
 		if (adapter->bss_prio_tbl[j].bss_prio_cur ==
 		    (struct mwifiex_bss_prio_node *)
@@ -924,21 +920,18 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 			hqp = &priv_tmp->wmm.highest_queued_prio;
 			for (i = atomic_read(hqp); i >= LOW_PRIO_TID; --i) {
 
+				spin_lock_irqsave(&priv_tmp->wmm.
+						  ra_list_spinlock, flags_ra);
+
 				tid_ptr = &(priv_tmp)->wmm.
 					tid_tbl_ptr[tos_to_tid[i]];
 
 				/* For non-STA ra_list_curr may be NULL */
 				if (!tid_ptr->ra_list_curr)
-					continue;
+					goto skip_wmm_queue;
 
-				spin_lock_irqsave(&priv_tmp->wmm.
-						  ra_list_spinlock, flags);
-				is_list_empty =
-					list_empty(&tid_ptr->ra_list);
-				spin_unlock_irqrestore(&priv_tmp->wmm.
-						       ra_list_spinlock, flags);
-				if (is_list_empty)
-					continue;
+				if (list_empty(&tid_ptr->ra_list))
+					goto skip_wmm_queue;
 
 				/*
 				 * Always choose the next ra we transmitted
@@ -960,10 +953,8 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				}
 
 				do {
-					is_list_empty =
-						skb_queue_empty(&ptr->skb_head);
-
-					if (!is_list_empty)
+					if (!skb_queue_empty(&ptr->skb_head))
+						/* holds both locks */
 						goto found;
 
 					/* Get next ra */
@@ -978,6 +969,11 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 						    struct mwifiex_ra_list_tbl,
 						    list);
 				} while (ptr != head);
+
+skip_wmm_queue:
+				spin_unlock_irqrestore(&priv_tmp->wmm.
+						       ra_list_spinlock,
+						       flags_ra);
 			}
 
 skip_bss:
@@ -995,14 +991,21 @@ skip_bss:
 						struct mwifiex_bss_prio_node,
 						list);
 		} while (bssprio_node != bssprio_head);
+
+skip_prio_tbl:
+		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
+				       flags_bss);
 	}
+
 	return NULL;
 
 found:
-	spin_lock_irqsave(&priv_tmp->wmm.ra_list_spinlock, flags);
+	/* holds bss_prio_lock / ra_list_spinlock */
 	if (atomic_read(hqp) > i)
 		atomic_set(hqp, i);
-	spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags);
+	spin_unlock_irqrestore(&priv_tmp->wmm.ra_list_spinlock, flags_ra);
+	spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
+			       flags_bss);
 
 	*priv = priv_tmp;
 	*tid = tos_to_tid[i];
-- 
1.7.0.2

