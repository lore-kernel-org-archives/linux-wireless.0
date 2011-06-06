Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:39751 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab1FFJco (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:32:44 -0400
Date: Mon, 6 Jun 2011 14:53:02 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3/4] mwifiex: adding check for enough space before padding
Message-ID: <20110606092300.GC28199@hertz.marvell.com> (sfid-20110606_113250_823097_050052D5)
References: <20110606091615.GA28184@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110606091615.GA28184@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All MSDUs, except the last one in an AMSDU, should end up at 4
bytes boundary. There is need to check if enough skb_tailroom
space exists before padding the skb.

Also re-arranging code for better readablity.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
---
 drivers/net/wireless/mwifiex/11n_aggr.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
index aee3491..25312e4 100644
--- a/drivers/net/wireless/mwifiex/11n_aggr.c
+++ b/drivers/net/wireless/mwifiex/11n_aggr.c
@@ -185,16 +185,15 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 	tx_info_aggr->bss_index = tx_info_src->bss_index;
 	skb_aggr->priority = skb_src->priority;
 
-	while (skb_src && ((skb_headroom(skb_aggr) + skb_src->len
-					+ LLC_SNAP_LEN)
-				<= adapter->tx_buf_size)) {
+	do {
+		/* Check if AMSDU can accommodate this MSDU */
+		if (skb_tailroom(skb_aggr) < (skb_src->len + LLC_SNAP_LEN))
+			break;
 
 		skb_src = skb_dequeue(&pra_list->skb_head);
 
-		if (skb_src) {
-			pra_list->total_pkts_size -= skb_src->len;
-			pra_list->total_pkts--;
-		}
+		pra_list->total_pkts_size -= skb_src->len;
+		pra_list->total_pkts--;
 
 		atomic_dec(&priv->wmm.tx_pkts_queued);
 
@@ -212,8 +211,15 @@ mwifiex_11n_aggregate_pkt(struct mwifiex_private *priv,
 			return -1;
 		}
 
+		if (skb_tailroom(skb_aggr) < pad) {
+			pad = 0;
+			break;
+		}
+		skb_put(skb_aggr, pad);
+
 		skb_src = skb_peek(&pra_list->skb_head);
-	}
+
+	} while (skb_src);
 
 	spin_unlock_irqrestore(&priv->wmm.ra_list_spinlock, ra_list_flags);
 
-- 
1.7.3.5

