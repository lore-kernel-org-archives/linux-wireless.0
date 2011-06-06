Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39741 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1FFJal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:30:41 -0400
Date: Mon, 6 Jun 2011 14:50:58 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/4] mwifiex: Remove redundant skb_queue_empty checks
Message-ID: <20110606092057.GB28199@hertz.marvell.com> (sfid-20110606_113045_226474_7A895543)
References: <20110606091615.GA28184@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110606091615.GA28184@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The check of skb list empty before calling skb_peek and skb_dequeue is
redundant. These functions returns NULL if the list is empty.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index 84d2c76..aee3491 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -164,12 +164,13 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	struct mwifiex_tx_param tx_param;
 	struct txpd *ptx_pd = NULL;
 
-	if (skb_queue_empty(&pra_list->skb_head)) {
+	skb_src = skb_peek(&pra_list->skb_head);
+	if (!skb_src) {
 		spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock,
 				       ra_list_flags);
 		return 0;
 	}
-	skb_src = skb_peek(&pra_list->skb_head);
+
 	tx_info_src = MWIFIEX_SKB_TXCB(skb_src);
 	skb_aggr = dev_alloc_skb(adapter->tx_buf_size);
 	if (!skb_aggr) {
@@ -188,10 +189,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 					+ LLC_SNAP_LEN)
 				<= adapter->tx_buf_size)) {
 
-		if (!skb_queue_empty(&pra_list->skb_head))
-			skb_src = skb_dequeue(&pra_list->skb_head);
-		else
-			skb_src = NULL;
+		skb_src = skb_dequeue(&pra_list->skb_head);
 
 		if (skb_src) {
 			pra_list->total_pkts_size -= skb_src->len;
@@ -214,10 +212,7 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			return -1;
 		}
 
-		if (!skb_queue_empty(&pra_list->skb_head))
-			skb_src = skb_peek(&pra_list->skb_head);
-		else
-			skb_src = NULL;
+		skb_src = skb_peek(&pra_list->skb_head);
 	}
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
-- 
1.7.3.5

