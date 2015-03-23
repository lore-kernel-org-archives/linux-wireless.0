Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44757 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853AbbCWIvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 04:51:50 -0400
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	James Cameron <quozl@laptop.org>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH 2/2] mwifiex: recover from skb allocation failures during RX
Date: Mon, 23 Mar 2015 19:50:56 +0530
Message-ID: <1427120456-6247-2-git-send-email-patila@marvell.com> (sfid-20150323_095153_087590_26F15130)
In-Reply-To: <1427120456-6247-1-git-send-email-patila@marvell.com>
References: <1427120456-6247-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch adds recovery mechanism for SDIO RX during SKB allocation
failures.
For allocation failures during multiport aggregation, we skip and drop RX
packets.
For single port read case, we will use preallocated card->mpa_rx.buf to
complete cmd53 read.
Now we terminate SDIO operations only upon cmd53 failures.

CC: James Cameron <quozl@laptop.org>
Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 42 +++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 6af7a082..d10320f 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1317,10 +1317,14 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 			skb_deaggr = mwifiex_alloc_dma_align_buf(len_arr[pind],
 								 GFP_KERNEL |
 								 GFP_DMA);
-			if (!skb_deaggr)
-				goto error;
+			if (!skb_deaggr) {
+				dev_err(adapter->dev, "skb allocation failure drop pkt len=%d type=%d\n",
+					pkt_len, pkt_type);
+				curr_ptr += len_arr[pind];
+				continue;
+			}
+
 			skb_put(skb_deaggr, len_arr[pind]);
-			card->mpa_rx.skb_arr[pind] = skb_deaggr;
 
 			if ((pkt_type == MWIFIEX_TYPE_DATA ||
 			     (pkt_type == MWIFIEX_TYPE_AGGR_DATA &&
@@ -1335,7 +1339,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 				mwifiex_decode_rx_packet(adapter, skb_deaggr,
 							 pkt_type);
 			} else {
-				dev_err(adapter->dev, "wrong aggr pkt:\t"
+				dev_err(adapter->dev, " drop wrong aggr pkt:\t"
 					"sdio_single_port_rx_aggr=%d\t"
 					"type=%d len=%d max_len=%d\n",
 					adapter->sdio_rx_aggr_enable,
@@ -1352,9 +1356,18 @@ rx_curr_single:
 	if (f_do_rx_cur) {
 		dev_dbg(adapter->dev, "info: RX: port: %d, rx_len: %d\n",
 			port, rx_len);
+
 		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
-		if (!skb)
-			goto error;
+		if (!skb) {
+			dev_err(adapter->dev, "single skb allocated fail,\t"
+				"drop pkt port=%d len=%d\n", port, rx_len);
+			if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
+						      card->mpa_rx.buf, rx_len,
+						      adapter->ioport + port))
+				goto error;
+			return 0;
+		}
+
 		skb_put(skb, rx_len);
 
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
@@ -1363,10 +1376,11 @@ rx_curr_single:
 			goto error;
 		if (!adapter->sdio_rx_aggr_enable &&
 		    pkt_type == MWIFIEX_TYPE_AGGR_DATA) {
-			dev_err(adapter->dev, "Wrong pkt type %d\t"
-				"Current SDIO RX Aggr not enabled\n",
+			dev_err(adapter->dev, "drop wrong pkt type %d\t"
+				"current SDIO RX Aggr not enabled\n",
 				pkt_type);
-			goto error;
+			dev_kfree_skb_any(skb);
+			return 0;
 		}
 
 		mwifiex_decode_rx_packet(adapter, skb, pkt_type);
@@ -1379,16 +1393,8 @@ rx_curr_single:
 
 	return 0;
 error:
-	if (MP_RX_AGGR_IN_PROGRESS(card)) {
-		/* Multiport-aggregation transfer failed - cleanup */
-		for (pind = 0; pind < card->mpa_rx.pkt_cnt; pind++) {
-			/* copy pkt to deaggr buf */
-			skb_deaggr = card->mpa_rx.skb_arr[pind];
-			if (skb_deaggr)
-				dev_kfree_skb_any(skb_deaggr);
-		}
+	if (MP_RX_AGGR_IN_PROGRESS(card))
 		MP_RX_AGGR_BUF_RESET(card);
-	}
 
 	if (f_do_rx_cur && skb)
 		/* Single transfer pending. Free curr buff also */
-- 
1.8.1.4

