Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:61556 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763362Ab3DKLwW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 07:52:22 -0400
Received: from mailout-de.gmx.net ([10.1.76.20]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M3PXK-1Uhmrs48W0-00qy73 for
 <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2013 13:52:20 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org, yogeshp@marvell.com, patila@marvell.com,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 2/2] mwifiex: rework round robin scheduling of bss nodes.
Date: Thu, 11 Apr 2013 13:51:08 +0200
Message-Id: <1365681068-27820-3-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130411_135230_576227_309EB052)
In-Reply-To: <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com>
References: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com>
 <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rotate bss prio list, so the bss next to the one served, will come first
in the list of bss' with equal priority. This way we pick bss nodes in a
round robin fashion. Using list rotation instead of a cur ptr simplifies
iteration to calling list_for_each_entry. List rotation is done via
list_move, where the head itself is temporarily removed and then
re-inserted after the bss just served.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    6 ---
 drivers/net/wireless/mwifiex/init.c     |   21 +++-----
 drivers/net/wireless/mwifiex/wmm.c      |   79 +++++++++----------------------
 3 files changed, 29 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index c6d7451..a78e065 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -297,12 +297,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	}
 	if (ret != -EBUSY) {
 		mwifiex_rotate_priolists(priv, pra_list, ptrindex);
-		/* Now bss_prio_cur pointer points to next node */
-		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-			list_first_entry(
-				&adapter->bss_prio_tbl[priv->bss_priority]
-				.bss_prio_cur->list,
-				struct mwifiex_bss_prio_node, list);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/init.c b/drivers/net/wireless/mwifiex/init.c
index 716a68b..ff6b7ec 100644
--- a/drivers/net/wireless/mwifiex/init.c
+++ b/drivers/net/wireless/mwifiex/init.c
@@ -44,8 +44,6 @@ static int mwifiex_add_bss_prio_tbl(struct mwifiex_private *priv)
 
 	bss_prio->priv = priv;
 	INIT_LIST_HEAD(&bss_prio->list);
-	if (!tbl[priv->bss_priority].bss_prio_cur)
-		tbl[priv->bss_priority].bss_prio_cur = bss_prio;
 
 	spin_lock_irqsave(&tbl[priv->bss_priority].bss_prio_lock, flags);
 	list_add_tail(&bss_prio->list, &tbl[priv->bss_priority].bss_prio_head);
@@ -525,7 +523,6 @@ int mwifiex_init_lock_list(struct mwifiex_adapter *adapter)
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		INIT_LIST_HEAD(&adapter->bss_prio_tbl[i].bss_prio_head);
-		adapter->bss_prio_tbl[i].bss_prio_cur = NULL;
 		spin_lock_init(&adapter->bss_prio_tbl[i].bss_prio_lock);
 	}
 
@@ -625,42 +622,36 @@ static void mwifiex_delete_bss_prio_tbl(struct mwifiex_private *priv)
 {
 	int i;
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct mwifiex_bss_prio_node *bssprio_node, *tmp_node, **cur;
+	struct mwifiex_bss_prio_node *bssprio_node, *tmp_node;
 	struct list_head *head;
 	spinlock_t *lock; /* bss priority lock */
 	unsigned long flags;
 
 	for (i = 0; i < adapter->priv_num; ++i) {
 		head = &adapter->bss_prio_tbl[i].bss_prio_head;
-		cur = &adapter->bss_prio_tbl[i].bss_prio_cur;
 		lock = &adapter->bss_prio_tbl[i].bss_prio_lock;
 		dev_dbg(adapter->dev, "info: delete BSS priority table,"
 				" bss_type = %d, bss_num = %d, i = %d,"
-				" head = %p, cur = %p\n",
-			      priv->bss_type, priv->bss_num, i, head, *cur);
-		if (*cur) {
+				" head = %p\n",
+			      priv->bss_type, priv->bss_num, i, head);
+
+		{
 			spin_lock_irqsave(lock, flags);
 			if (list_empty(head)) {
 				spin_unlock_irqrestore(lock, flags);
 				continue;
 			}
-			bssprio_node = list_first_entry(head,
-					struct mwifiex_bss_prio_node, list);
-			spin_unlock_irqrestore(lock, flags);
-
 			list_for_each_entry_safe(bssprio_node, tmp_node, head,
 						 list) {
 				if (bssprio_node->priv == priv) {
 					dev_dbg(adapter->dev, "info: Delete "
 						"node %p, next = %p\n",
 						bssprio_node, tmp_node);
-					spin_lock_irqsave(lock, flags);
 					list_del(&bssprio_node->list);
-					spin_unlock_irqrestore(lock, flags);
 					kfree(bssprio_node);
 				}
 			}
-			*cur = (struct mwifiex_bss_prio_node *)head;
+			spin_unlock_irqrestore(lock, flags);
 		}
 	}
 }
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index c0d7952..21ae7c2 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -881,37 +881,25 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 {
 	struct mwifiex_private *priv_tmp;
 	struct mwifiex_ra_list_tbl *ptr;
-	struct mwifiex_bss_prio_node *bssprio_node, *bssprio_head;
 	struct mwifiex_tid_tbl *tid_ptr;
 	atomic_t *hqp;
 	unsigned long flags_bss, flags_ra;
 	int i, j;
 
+	/* check the BSS with highest priority first */
 	for (j = adapter->priv_num - 1; j >= 0; --j) {
 		spin_lock_irqsave(&adapter->bss_prio_tbl[j].bss_prio_lock,
 				  flags_bss);
 
-		if (list_empty(&adapter->bss_prio_tbl[j].bss_prio_head))
-			goto skip_prio_tbl;
-
-		if (adapter->bss_prio_tbl[j].bss_prio_cur ==
-		    (struct mwifiex_bss_prio_node *)
-		    &adapter->bss_prio_tbl[j].bss_prio_head) {
-			adapter->bss_prio_tbl[j].bss_prio_cur =
-				list_first_entry(&adapter->bss_prio_tbl[j]
-						 .bss_prio_head,
-						 struct mwifiex_bss_prio_node,
-						 list);
-		}
-
-		bssprio_node = adapter->bss_prio_tbl[j].bss_prio_cur;
-		bssprio_head = bssprio_node;
+		/* iterate over BSS with the equal priority */
+		list_for_each_entry(adapter->bss_prio_tbl[j].bss_prio_cur,
+				    &adapter->bss_prio_tbl[j].bss_prio_head,
+				    list) {
 
-		do {
-			priv_tmp = bssprio_node->priv;
+			priv_tmp = adapter->bss_prio_tbl[j].bss_prio_cur->priv;
 
 			if (atomic_read(&priv_tmp->wmm.tx_pkts_queued) == 0)
-				goto skip_bss;
+				continue;
 
 			/* iterate over the WMM queues of the BSS */
 			hqp = &priv_tmp->wmm.highest_queued_prio;
@@ -936,24 +924,8 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 						       ra_list_spinlock,
 						       flags_ra);
 			}
+		}
 
-skip_bss:
-			/* Get next bss priority node */
-			bssprio_node = list_first_entry(&bssprio_node->list,
-						struct mwifiex_bss_prio_node,
-						list);
-
-			if (bssprio_node ==
-			    (struct mwifiex_bss_prio_node *)
-			    &adapter->bss_prio_tbl[j].bss_prio_head)
-				/* Get next bss priority node */
-				bssprio_node = list_first_entry(
-						&bssprio_node->list,
-						struct mwifiex_bss_prio_node,
-						list);
-		} while (bssprio_node != bssprio_head);
-
-skip_prio_tbl:
 		spin_unlock_irqrestore(&adapter->bss_prio_tbl[j].bss_prio_lock,
 				       flags_bss);
 	}
@@ -974,12 +946,12 @@ found:
 	return ptr;
 }
 
-/* This functions rotates ra lists so packets are picked in round robin
- * fashion.
+/* This functions rotates ra and bss lists so packets are picked round robin.
  *
  * After a packet is successfully transmitted, rotate the ra list, so the ra
  * next to the one transmitted, will come first in the list. This way we pick
- * the ra in a round robin fashion.
+ * the ra' in a round robin fashion. Same applies to bss nodes of equal
+ * priority.
  *
  * Function also increments wmm.packets_out counter.
  */
@@ -987,17 +959,24 @@ void mwifiex_rotate_priolists(struct mwifiex_private *priv,
 				 struct mwifiex_ra_list_tbl *ra,
 				 int tid)
 {
+	struct mwifiex_adapter *adapter = priv->adapter;
+	struct mwifiex_bss_prio_tbl *tbl = adapter->bss_prio_tbl;
 	struct mwifiex_tid_tbl *tid_ptr = &priv->wmm.tid_tbl_ptr[tid];
 	unsigned long flags;
 
+	spin_lock_irqsave(&tbl[priv->bss_priority].bss_prio_lock, flags);
+	/*
+	 * dirty trick: we remove 'head' temporarily and reinsert it after
+	 * curr bss node. imagine list to stay fixed while head is moved
+	 */
+	list_move(&tbl[priv->bss_priority].bss_prio_head,
+		  &tbl[priv->bss_priority].bss_prio_cur->list);
+	spin_unlock_irqrestore(&tbl[priv->bss_priority].bss_prio_lock, flags);
+
 	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
 	if (mwifiex_is_ralist_valid(priv, ra, tid)) {
 		priv->wmm.packets_out[tid]++;
-		/*
-		 * dirty trick: we remove 'head' temporarily and reinsert it
-		 * after curr bss node. imagine list to stay fixed while only
-		 * head is moved
-		 */
+		/* same as above */
 		list_move(&tid_ptr->ra_list, &ra->list);
 	}
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
@@ -1090,12 +1069,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 				       ra_list_flags);
 	} else {
 		mwifiex_rotate_priolists(priv, ptr, ptr_index);
-		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-			list_first_entry(
-				&adapter->bss_prio_tbl[priv->bss_priority]
-				.bss_prio_cur->list,
-				struct mwifiex_bss_prio_node,
-				list);
 		atomic_dec(&priv->wmm.tx_pkts_queued);
 	}
 }
@@ -1201,12 +1174,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 	}
 	if (ret != -EBUSY) {
 		mwifiex_rotate_priolists(priv, ptr, ptr_index);
-		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
-			list_first_entry(
-				&adapter->bss_prio_tbl[priv->bss_priority]
-				.bss_prio_cur->list,
-				struct mwifiex_bss_prio_node,
-				list);
 		atomic_dec(&priv->wmm.tx_pkts_queued);
 	}
 }
-- 
1.7.10.4

