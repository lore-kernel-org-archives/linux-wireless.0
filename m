Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55854 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763042Ab3DDVIU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 17:08:20 -0400
Received: from mailout-de.gmx.net ([10.1.76.33]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MJqWY-1UMlSp2JiW-001D5S for
 <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2013 23:08:19 +0200
From: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
To: bzhao@marvell.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	daniel@zonque.org, yogeshp@marvell.com, patila@marvell.com,
	Andreas Fenkart <andreas.fenkart@streamunlimited.com>
Subject: [PATCH 1/2] mwifiex: replace ra_list_curr by list rotation.
Date: Thu,  4 Apr 2013 23:08:09 +0200
Message-Id: <1365109690-8576-1-git-send-email-andreas.fenkart@streamunlimited.com> (sfid-20130404_230824_126964_C4CB09F3)
In-Reply-To: <20130404205706.GA29851@blumentopf>
References: <20130404205706.GA29851@blumentopf>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a packet is successfully transmitted, ra list is rotated, so the ra
next to the one transmitted, will be the first in the list. This way we
pick the ra' in a round robin fashion. This significantly simplifies
iteration in  mwifiex_wmm_get_highest_priolist_ptr to a call to
list_for_each_entry.
List rotation is done via list_move, where the head itself is temporarily
removed and then re-inserted after the item just transferred.

Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    8 +--
 drivers/net/wireless/mwifiex/main.h     |    1 -
 drivers/net/wireless/mwifiex/wmm.c      |  100 ++++++++++++-------------------
 drivers/net/wireless/mwifiex/wmm.h      |    3 +
 4 files changed, 43 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index af8fe63..c6d7451 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -296,19 +296,13 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		break;
 	}
 	if (ret != -EBUSY) {
-		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
-		if (mwifiex_is_ralist_valid(priv, pra_list, ptrindex)) {
-			priv->wmm.packets_out[ptrindex]++;
-			priv->wmm.tid_tbl_ptr[ptrindex].ra_list_curr = pra_list;
-		}
+		mwifiex_rotate_priolists(priv, pra_list, ptrindex);
 		/* Now bss_prio_cur pointer points to next node */
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			list_first_entry(
 				&adapter->bss_prio_tbl[priv->bss_priority]
 				.bss_prio_cur->list,
 				struct mwifiex_bss_prio_node, list);
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-				       ra_list_flags);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 082a468..80e26c8 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -210,7 +210,6 @@ struct mwifiex_ra_list_tbl {
 
 struct mwifiex_tid_tbl {
 	struct list_head ra_list;
-	struct mwifiex_ra_list_tbl *ra_list_curr;
 };
 
 #define WMM_HIGHEST_PRIORITY		7
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 62d740b..c865e58 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -191,9 +191,6 @@ mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra)
 		}
 		list_add_tail(&ra_list->list,
 			      &priv->wmm.tid_tbl_ptr[i].ra_list);
-
-		if (!priv->wmm.tid_tbl_ptr[i].ra_list_curr)
-			priv->wmm.tid_tbl_ptr[i].ra_list_curr = ra_list;
 	}
 }
 
@@ -424,7 +421,6 @@ mwifiex_wmm_init(struct mwifiex_adapter *adapter)
 			priv->aggr_prio_tbl[i].amsdu = tos_to_tid_inv[i];
 			priv->aggr_prio_tbl[i].ampdu_ap = tos_to_tid_inv[i];
 			priv->aggr_prio_tbl[i].ampdu_user = tos_to_tid_inv[i];
-			priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
 		}
 
 		priv->aggr_prio_tbl[6].amsdu
@@ -533,8 +529,6 @@ static void mwifiex_wmm_delete_all_ralist(struct mwifiex_private *priv)
 		}
 
 		INIT_LIST_HEAD(&priv->wmm.tid_tbl_ptr[i].ra_list);
-
-		priv->wmm.tid_tbl_ptr[i].ra_list_curr = NULL;
 	}
 }
 
@@ -886,7 +880,7 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				     struct mwifiex_private **priv, int *tid)
 {
 	struct mwifiex_private *priv_tmp;
-	struct mwifiex_ra_list_tbl *ptr, *head;
+	struct mwifiex_ra_list_tbl *ptr;
 	struct mwifiex_bss_prio_node *bssprio_node, *bssprio_head;
 	struct mwifiex_tid_tbl *tid_ptr;
 	atomic_t *hqp;
@@ -929,52 +923,17 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 				tid_ptr = &(priv_tmp)->wmm.
 					tid_tbl_ptr[tos_to_tid[i]];
 
-				/* For non-STA ra_list_curr may be NULL */
-				if (!tid_ptr->ra_list_curr)
-					goto skip_wmm_queue;
-
-				if (list_empty(&tid_ptr->ra_list))
-					goto skip_wmm_queue;
-
-				/*
-				 * Always choose the next ra we transmitted
-				 * last time, this way we pick the ra's in
-				 * round robin fashion.
-				 */
-				ptr = list_first_entry(
-						&tid_ptr->ra_list_curr->list,
-						struct mwifiex_ra_list_tbl,
-						list);
-
-				head = ptr;
-				if (ptr == (struct mwifiex_ra_list_tbl *)
-						&tid_ptr->ra_list) {
-					/* Get next ra */
-					ptr = list_first_entry(&ptr->list,
-					    struct mwifiex_ra_list_tbl, list);
-					head = ptr;
-				}
+				/* iterate over receiver addresses */
+				list_for_each_entry(ptr, &tid_ptr->ra_list,
+						    list) {
 
-				do {
 					if (!skb_queue_empty(&ptr->skb_head)) {
 						/* holds both locks */
 						goto found;
 					}
 
-					/* Get next ra */
-					ptr = list_first_entry(&ptr->list,
-						 struct mwifiex_ra_list_tbl,
-						 list);
-					if (ptr ==
-					    (struct mwifiex_ra_list_tbl *)
-					    &tid_ptr->ra_list)
-						ptr = list_first_entry(
-						    &ptr->list,
-						    struct mwifiex_ra_list_tbl,
-						    list);
-				} while (ptr != head);
-
-skip_wmm_queue:
+				}
+
 				spin_unlock_irqrestore(&priv_tmp->wmm.
 						       ra_list_spinlock,
 						       flags_ra);
@@ -1019,6 +978,37 @@ found:
 }
 
 /*
+ * This functions rotates ra lists so packets are picked in round robin
+ * fashion.
+ *
+ * After a packet is successfully transmitted, rotate the ra list, so the ra
+ * next to the one transmitted, will come first in the list. This way we pick
+ * the ra in a round robin fashion.
+ *
+ * Function also increments wmm.packets_out counter.
+ */
+void mwifiex_rotate_priolists(struct mwifiex_private *priv,
+				 struct mwifiex_ra_list_tbl *ra,
+				 int tid)
+{
+	struct mwifiex_tid_tbl *tid_ptr = &priv->wmm.tid_tbl_ptr[tid];
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->wmm.ra_list_spinlock, flags);
+	if (mwifiex_is_ralist_valid(priv, ra, tid)) {
+		priv->wmm.packets_out[tid]++;
+		/*
+		 * dirty trick: we remove 'head' temporarily and reinsert it
+		 * after curr bss node. imagine list to stay fixed while only
+		 * head is moved
+		 */
+		list_move(&tid_ptr->ra_list, &ra->list);
+	}
+	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, flags);
+
+}
+
+/*
  * This function checks if 11n aggregation is possible.
  */
 static int
@@ -1104,11 +1094,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 	} else {
-		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
-		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-			priv->wmm.packets_out[ptr_index]++;
-			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr = ptr;
-		}
+		mwifiex_rotate_priolists(priv, ptr, ptr_index);
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			list_first_entry(
 				&adapter->bss_prio_tbl[priv->bss_priority]
@@ -1116,8 +1102,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 				struct mwifiex_bss_prio_node,
 				list);
 		atomic_dec(&priv->wmm.tx_pkts_queued);
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-				       ra_list_flags);
 	}
 }
 
@@ -1221,11 +1205,7 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 		break;
 	}
 	if (ret != -EBUSY) {
-		spin_lock_irqsave(&priv->wmm.ra_list_spinlock, ra_list_flags);
-		if (mwifiex_is_ralist_valid(priv, ptr, ptr_index)) {
-			priv->wmm.packets_out[ptr_index]++;
-			priv->wmm.tid_tbl_ptr[ptr_index].ra_list_curr = ptr;
-		}
+		mwifiex_rotate_priolists(priv, ptr, ptr_index);
 		adapter->bss_prio_tbl[priv->bss_priority].bss_prio_cur =
 			list_first_entry(
 				&adapter->bss_prio_tbl[priv->bss_priority]
@@ -1233,8 +1213,6 @@ mwifiex_send_processed_packet(struct mwifiex_private *priv,
 				struct mwifiex_bss_prio_node,
 				list);
 		atomic_dec(&priv->wmm.tx_pkts_queued);
-		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-				       ra_list_flags);
 	}
 }
 
diff --git a/drivers/net/wireless/mwifiex/wmm.h b/drivers/net/wireless/mwifiex/wmm.h
index b92f39d..644d6e0 100644
--- a/drivers/net/wireless/mwifiex/wmm.h
+++ b/drivers/net/wireless/mwifiex/wmm.h
@@ -85,6 +85,9 @@ mwifiex_wmm_is_ra_list_empty(struct list_head *ra_list_hhead)
 void mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 					struct sk_buff *skb);
 void mwifiex_ralist_add(struct mwifiex_private *priv, u8 *ra);
+void mwifiex_rotate_priolists(struct mwifiex_private *priv,
+			      struct mwifiex_ra_list_tbl *ra,
+			      int tid);
 
 int mwifiex_wmm_lists_empty(struct mwifiex_adapter *adapter);
 void mwifiex_wmm_process_tx(struct mwifiex_adapter *adapter);
-- 
1.7.10.4

