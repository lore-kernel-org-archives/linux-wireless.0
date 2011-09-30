Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47372 "HELO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754682Ab1I3DoE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 23:44:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/2] mwifiex: correct AMSDU aggregation check
Date: Thu, 29 Sep 2011 20:43:40 -0700
Message-Id: <1317354221-13688-1-git-send-email-bzhao@marvell.com> (sfid-20110930_054419_100678_ECBAD417)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

The commit "mwifiex: remove list traversal.."(fcf2176c87..)
wrongly modifies AMSDU aggregation check. Due to this even though
packet size for iperf traffic is already large, we unnecessarily
try to aggregate them which adds some delay. If Tx iperf is started
on UUT for 30 seconds, UUT keeps sending Tx packets for few more
seconds.

That commit is reverted to fix the problem.
Also, MIN_NUM_AMSDU check is moved inside the loop to optimize the
loop.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |    2 -
 drivers/net/wireless/mwifiex/11n_aggr.h |    1 +
 drivers/net/wireless/mwifiex/main.h     |    1 -
 drivers/net/wireless/mwifiex/wmm.c      |   32 +++++++++++++++++++++++-------
 4 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 1a453a6..9e63d16 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -193,7 +193,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		skb_src = skb_dequeue(&pra_list->skb_head);
 
 		pra_list->total_pkts_size -= skb_src->len;
-		pra_list->total_pkts--;
 
 		atomic_dec(&priv->wmm.tx_pkts_queued);
 
@@ -269,7 +268,6 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 		skb_queue_tail(&pra_list->skb_head, skb_aggr);
 
 		pra_list->total_pkts_size += skb_aggr->len;
-		pra_list->total_pkts++;
 
 		atomic_inc(&priv->wmm.tx_pkts_queued);
 
diff --git a/drivers/net/wireless/mwifiex/11n_aggr.h b/drivers/net/wireless/mwifiex/11n_aggr.h
index 9c6dca7..900e1c6 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.h
+++ b/drivers/net/wireless/mwifiex/11n_aggr.h
@@ -21,6 +21,7 @@
 #define _MWIFIEX_11N_AGGR_H_
 
 #define PKT_TYPE_AMSDU	0xE6
+#define MIN_NUM_AMSDU 2
 
 int mwifiex_11n_deaggregate_pkt(struct mwifiex_private *priv,
 				struct sk_buff *skb);
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 4f40428..907ab74 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -173,7 +173,6 @@ struct mwifiex_ra_list_tbl {
 	struct sk_buff_head skb_head;
 	u8 ra[ETH_ALEN];
 	u32 total_pkts_size;
-	u32 total_pkts;
 	u32 is_11n_enabled;
 };
 
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 69e260b..eda2447 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -121,7 +121,6 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 	memcpy(ra_list->ra, ra, ETH_ALEN);
 
 	ra_list->total_pkts_size = 0;
-	ra_list->total_pkts = 0;
 
 	dev_dbg(adapter->dev, "info: allocated ra_list %p\n", ra_list);
 
@@ -648,7 +647,6 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_adapter *adapter,
 	skb_queue_tail(&ra_list->skb_head, skb);
 
 	ra_list->total_pkts_size += skb->len;
-	ra_list->total_pkts++;
 
 	atomic_inc(&priv->wmm.tx_pkts_queued);
 
@@ -975,6 +973,28 @@ mwifiex_wmm_get_highest_priolist_ptr(struct mwifiex_adapter *adapter,
 }
 
 /*
+ * This function checks if 11n aggregation is possible.
+ */
+static int
+mwifiex_is_11n_aggragation_possible(struct mwifiex_private *priv,
+				    struct mwifiex_ra_list_tbl *ptr,
+				    int max_buf_size)
+{
+	int count = 0, total_size = 0;
+	struct sk_buff *skb, *tmp;
+
+	skb_queue_walk_safe(&ptr->skb_head, skb, tmp) {
+		total_size += skb->len;
+		if (total_size >= max_buf_size)
+			break;
+		if (++count >= MIN_NUM_AMSDU)
+			return true;
+	}
+
+	return false;
+}
+
+/*
  * This function sends a single packet to firmware for transmission.
  */
 static void
@@ -1001,7 +1021,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	dev_dbg(adapter->dev, "data: dequeuing the packet %p %p\n", ptr, skb);
 
 	ptr->total_pkts_size -= skb->len;
-	ptr->total_pkts--;
 
 	if (!skb_queue_empty(&ptr->skb_head))
 		skb_next = skb_peek(&ptr->skb_head);
@@ -1027,7 +1046,6 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 		skb_queue_tail(&ptr->skb_head, skb);
 
 		ptr->total_pkts_size += skb->len;
-		ptr->total_pkts++;
 		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
@@ -1213,11 +1231,9 @@ mwifiex_dequeue_tx_packet(struct mwifiex_adapter *adapter)
 				mwifiex_send_delba(priv, tid_del, ra, 1);
 			}
 		}
-/* Minimum number of AMSDU */
-#define MIN_NUM_AMSDU 2
-
 		if (mwifiex_is_amsdu_allowed(priv, tid) &&
-				(ptr->total_pkts >= MIN_NUM_AMSDU))
+		    mwifiex_is_11n_aggragation_possible(priv, ptr,
+							adapter->tx_buf_size))
 			mwifiex_11n_aggregate_pkt(priv, ptr, INTF_HEADER_LEN,
 						  ptr_index, flags);
 			/* ra_list_spinlock has been freed in
-- 
1.7.0.2

