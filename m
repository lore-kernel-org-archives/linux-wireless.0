Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:35944 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753745Ab3GWCSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:18:47 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 03/21] mwifiex: maintain outstanding packet count for RA list instead of packet size
Date: Mon, 22 Jul 2013 19:17:40 -0700
Message-ID: <1374545878-15683-4-git-send-email-bzhao@marvell.com> (sfid-20130723_041903_256067_EA82AFE3)
In-Reply-To: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
References: <1374545878-15683-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

Maintain total outstanding packet count for RA list instead of total
outstanding size as packet count metric seems more reasonable for
checking threshold etc.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c | 4 ++--
 drivers/net/wireless/mwifiex/main.h     | 2 +-
 drivers/net/wireless/mwifiex/wmm.c      | 8 ++++----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index a78e065..8f9f542 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -189,7 +189,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		skb_src = skb_dequeue(&pra_list->skb_head);
 
-		pra_list->total_pkts_size -= skb_src->len;
+		pra_list->total_pkt_count--;
 
 		atomic_dec(&priv->wmm.tx_pkts_queued);
 
@@ -268,7 +268,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 
 		skb_queue_tail(&pra_list->skb_head, skb_aggr);
 
-		pra_list->total_pkts_size += skb_aggr->len;
+		pra_list->total_pkt_count++;
 
 		atomic_inc(&priv->wmm.tx_pkts_queued);
 
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 884b42b..a3036d1 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -204,11 +204,11 @@ struct mwifiex_ra_list_tbl {
 	struct list_head list;
 	struct sk_buff_head skb_head;
 	u8 ra[ETH_ALEN];
-	u32 total_pkts_size;
 	u32 is_11n_enabled;
 	u16 max_amsdu;
 	u16 ba_pkt_count;
 	u8 ba_packet_thr;
+	u16 total_pkt_count;
 };
 
 struct mwifiex_tid_tbl {
diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 9c1eeee..2e8f9cd 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -120,7 +120,7 @@ mwifiex_wmm_allocate_ralist_node(struct mwifiex_adapter *adapter, u8 *ra)
 
 	memcpy(ra_list->ra, ra, ETH_ALEN);
 
-	ra_list->total_pkts_size = 0;
+	ra_list->total_pkt_count = 0;
 
 	dev_dbg(adapter->dev, "info: allocated ra_list %p\n", ra_list);
 
@@ -679,8 +679,8 @@ mwifiex_wmm_add_buf_txqueue(struct mwifiex_private *priv,
 
 	skb_queue_tail(&ra_list->skb_head, skb);
 
-	ra_list->total_pkts_size += skb->len;
 	ra_list->ba_pkt_count++;
+	ra_list->total_pkt_count++;
 
 	if (atomic_read(&priv->wmm.highest_queued_prio) <
 						tos_to_tid_inv[tid_down])
@@ -1037,7 +1037,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 	tx_info = MWIFIEX_SKB_TXCB(skb);
 	dev_dbg(adapter->dev, "data: dequeuing the packet %p %p\n", ptr, skb);
 
-	ptr->total_pkts_size -= skb->len;
+	ptr->total_pkt_count--;
 
 	if (!skb_queue_empty(&ptr->skb_head))
 		skb_next = skb_peek(&ptr->skb_head);
@@ -1062,7 +1062,7 @@ mwifiex_send_single_packet(struct mwifiex_private *priv,
 
 		skb_queue_tail(&ptr->skb_head, skb);
 
-		ptr->total_pkts_size += skb->len;
+		ptr->total_pkt_count++;
 		ptr->ba_pkt_count++;
 		tx_info->flags |= MWIFIEX_BUF_FLAG_REQUEUED_PKT;
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
-- 
1.8.2.3

