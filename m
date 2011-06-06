Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39733 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab1FFJ3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:29:15 -0400
Date: Mon, 6 Jun 2011 14:49:32 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/4] mwifiex: remove list traversal in
 mwifiex_num_pkts_in_txq
Message-ID: <20110606091931.GA28199@hertz.marvell.com> (sfid-20110606_112928_945483_4E039863)
References: <20110606091615.GA28184@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110606091615.GA28184@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of counting the number of packets in txq
for particular RA list before AMSDU creation,
maintain a counter which will keep track of the
same.

This will reduce some MIPS while generating AMSDU
traffic as we only have to check the counter instead
of traversing through skb list.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    5 ++++-
 drivers/net/wireless/mwifiex/main.h     |    1 +
 drivers/net/wireless/mwifiex/wmm.c      |   30 ++++++------------------------
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index f807447..84d2c76 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -193,8 +193,10 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		else
 			skb_src = NULL;
 
-		if (skb_src)
+		if (skb_src) {
 			pra_list->total_pkts_size -= skb_src->len;
+			pra_list->total_pkts--;
+		}
 
 		atomic_dec(&priv->wmm.tx_pkts_queued);
 
@@ -258,6 +260,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		skb_queue_tail(&pra_list->skb_head, skb_aggr);
 
 		pra_list->total_pkts_size += skb_aggr->len;
+		pra_list->total_pkts++;
 
 		atomic_inc(&priv->wmm.tx_pkts_queued);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 89f9870..57b183a 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -181,6 +181,7 @@ struct mwifiex_ra_list_tbl {
 	struct sk_buff_head skb_head;
 	u8 ra[ETH_ALEN];
 	u32 total_pkts_size;
+	u32 total_pkts;
 	u32 is_11n_enabled;
 };
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 91634da..67b2d0b 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -121,6 +121,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 	memcpy(ra_list->ra, ra, ETH_ALEN);
 
 	ra_list->total_pkts_size = 0;
+	ra_list->total_pkts = 0;
 
 	dev_dbg(adapter->dev, "info: allocated ra_list %p\n", ra_list);
 
@@ -645,6 +646,7 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	skb_queue_tail(&ra_list->skb_head, skb);
 
 	ra_list->total_pkts_size += skb->len;
+	ra_list->total_pkts++;
 
 	atomic_inc(&priv->wmm.tx_pkts_queued);
 
@@ -971,28 +973,6 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 }
 
 /*
- * This function gets the number of packets in the Tx queue of a
- * particular RA list.
- */
-static int
-mwifiex_num_pkts_in_txq(struct mwifiex_private *priv,
-			struct mwifiex_ra_list_tbl *ptr, int max_buf_size)
-{
-	int count = 0, total_size = 0;
-	struct sk_buff *skb, *tmp;
-
-	skb_queue_walk_safe(&ptr->skb_head, skb, tmp) {
-		total_size += skb->len;
-		if (total_size < max_buf_size)
-			++count;
-		else
-			break;
-	}
-
-	return count;
-}
-
-/*
  * This function sends a single packet to firmware for transmission.
  */
 static void
@@ -1019,6 +999,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	dev_dbg(adapter->dev, "data: dequeuing the packet %p %p\n", ptr, skb);
 
 	ptr->total_pkts_size -= skb->len;
+	ptr->total_pkts--;
 
 	if (!skb_queue_empty(&ptr->skb_head))
 		skb_next = skb_peek(&ptr->skb_head);
@@ -1044,6 +1025,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		skb_queue_tail(&ptr->skb_head, skb);
 
 		ptr->total_pkts_size += skb->len;
+		ptr->total_pkts++;
 		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -1231,9 +1213,9 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 		}
 /* Minimum number of AMSDU */
 #define MIN_NUM_AMSDU 2
+
 		if (mwifiex_is_amsdu_allowed(priv, tid) &&
-		    (mwifiex_num_pkts_in_txq(priv, ptr, adapter->tx_buf_size) >=
-		     MIN_NUM_AMSDU))
+				(ptr->total_pkts >= MIN_NUM_AMSDU))
 			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
 						  ptr_index, flags);
 			/* ra_list_spinlock has been freed in
-- 
1.7.3.5

