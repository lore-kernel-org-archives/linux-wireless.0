Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:20859 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754003AbbCLLxA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 07:53:00 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t2CBoDGM014703
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 04:53:00 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1t20qjf1r7-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2015 04:53:00 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, <pchen@marvell.com>, <szli@marvell.com>,
	<nishants@marvell.com>
Subject: [PATCH 9/9] mwifiex: delay skb allocation for RX until cmd53 over
Date: Thu, 12 Mar 2015 22:52:00 +0530
Message-ID: <1426180920-10567-10-git-send-email-patila@marvell.com> (sfid-20150312_125305_750379_900C5493)
In-Reply-To: <1426180920-10567-1-git-send-email-patila@marvell.com>
References: <1426180920-10567-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch moves SKB allocation for RX packets from current
place i.e. after reading MP regs to place where we already
have read data from SDIO bus ie after cmd53.

mp_rx_aggr_setup has been modified accordingly to set
skb_arr to NULL.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
Reviewed-by: Amitkumar Karwar <akarwar@marvell.com>
Reviewed-by: Cathy Luo <cluo@marvell.com>
Reviewed-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 59 ++++++++++++++++++-------------------
 drivers/net/wireless/mwifiex/sdio.h |  8 ++---
 2 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 9b75756..aae2972 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -1197,7 +1197,7 @@ static int mwifiex_decode_rx_packet(struct mwifiex_adapter *adapter,
  * provided there is space left, processed and finally uploaded.
  */
 static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
-					     struct sk_buff *skb, u8 port)
+					     u16 rx_len, u8 port)
 {
 	struct sdio_mmc_card *card = adapter->card;
 	s32 f_do_rx_aggr = 0;
@@ -1205,10 +1205,9 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_aggr_cur = 0;
 	s32 f_post_aggr_cur = 0;
 	struct sk_buff *skb_deaggr;
-	u32 pind;
-	u32 pkt_len, pkt_type, mport;
+	struct sk_buff *skb = NULL;
+	u32 pkt_len, pkt_type, mport, pind;
 	u8 *curr_ptr;
-	u32 rx_len = skb->len;
 
 	if ((card->has_control_mask) && (port == CTRL_PORT)) {
 		/* Read the command Resp without aggr */
@@ -1235,7 +1234,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		dev_dbg(adapter->dev, "info: %s: not last packet\n", __func__);
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
-			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len)) {
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, rx_len)) {
 				f_aggr_cur = 1;
 			} else {
 				/* No room in Aggr buf, do rx aggr now */
@@ -1253,7 +1252,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 
 		if (MP_RX_AGGR_IN_PROGRESS(card)) {
 			f_do_rx_aggr = 1;
-			if (MP_RX_AGGR_BUF_HAS_ROOM(card, skb->len))
+			if (MP_RX_AGGR_BUF_HAS_ROOM(card, rx_len))
 				f_aggr_cur = 1;
 			else
 				/* No room in Aggr buf, do rx aggr now */
@@ -1266,7 +1265,7 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 	if (f_aggr_cur) {
 		dev_dbg(adapter->dev, "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
-		mp_rx_aggr_setup(card, skb, port);
+		mp_rx_aggr_setup(card, rx_len, port);
 
 		if (MP_RX_AGGR_PKT_LIMIT_REACHED(card) ||
 		    mp_rx_aggr_port_limit_reached(card)) {
@@ -1309,18 +1308,25 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 		curr_ptr = card->mpa_rx.buf;
 
 		for (pind = 0; pind < card->mpa_rx.pkt_cnt; pind++) {
+			u32 *len_arr = card->mpa_rx.len_arr;
 
 			/* get curr PKT len & type */
 			pkt_len = le16_to_cpu(*(__le16 *) &curr_ptr[0]);
 			pkt_type = le16_to_cpu(*(__le16 *) &curr_ptr[2]);
 
 			/* copy pkt to deaggr buf */
-			skb_deaggr = card->mpa_rx.skb_arr[pind];
+			skb_deaggr = mwifiex_alloc_dma_align_buf(len_arr[pind],
+								 GFP_KERNEL |
+								 GFP_DMA);
+			if (!skb_deaggr)
+				goto error;
+			skb_put(skb_deaggr, len_arr[pind]);
+			card->mpa_rx.skb_arr[pind] = skb_deaggr;
 
 			if ((pkt_type == MWIFIEX_TYPE_DATA ||
 			     (pkt_type == MWIFIEX_TYPE_AGGR_DATA &&
 			      adapter->sdio_rx_aggr_enable)) &&
-			    (pkt_len <= card->mpa_rx.len_arr[pind])) {
+			    (pkt_len <= len_arr[pind])) {
 
 				memcpy(skb_deaggr->data, curr_ptr, pkt_len);
 
@@ -1335,10 +1341,10 @@ static int mwifiex_sdio_card_to_host_mp_aggr(struct mwifiex_adapter *adapter,
 					"type=%d len=%d max_len=%d\n",
 					adapter->sdio_rx_aggr_enable,
 					pkt_type, pkt_len,
-					card->mpa_rx.len_arr[pind]);
+					len_arr[pind]);
 				dev_kfree_skb_any(skb_deaggr);
 			}
-			curr_ptr += card->mpa_rx.len_arr[pind];
+			curr_ptr += len_arr[pind];
 		}
 		MP_RX_AGGR_BUF_RESET(card);
 	}
@@ -1347,6 +1353,10 @@ rx_curr_single:
 	if (f_do_rx_cur) {
 		dev_dbg(adapter->dev, "info: RX: port: %d, rx_len: %d\n",
 			port, rx_len);
+		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
+		if (!skb)
+			goto error;
+		skb_put(skb, rx_len);
 
 		if (mwifiex_sdio_card_to_host(adapter, &pkt_type,
 					      skb->data, skb->len,
@@ -1365,7 +1375,7 @@ rx_curr_single:
 	if (f_post_aggr_cur) {
 		dev_dbg(adapter->dev, "info: current packet aggregation\n");
 		/* Curr pkt can be aggregated */
-		mp_rx_aggr_setup(card, skb, port);
+		mp_rx_aggr_setup(card, skb->len, port);
 	}
 
 	return 0;
@@ -1375,12 +1385,13 @@ error:
 		for (pind = 0; pind < card->mpa_rx.pkt_cnt; pind++) {
 			/* copy pkt to deaggr buf */
 			skb_deaggr = card->mpa_rx.skb_arr[pind];
-			dev_kfree_skb_any(skb_deaggr);
+			if (skb_deaggr)
+				dev_kfree_skb_any(skb_deaggr);
 		}
 		MP_RX_AGGR_BUF_RESET(card);
 	}
 
-	if (f_do_rx_cur)
+	if (f_do_rx_cur && skb)
 		/* Single transfer pending. Free curr buff also */
 		dev_kfree_skb_any(skb);
 
@@ -1442,6 +1453,7 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 		     MWIFIEX_RX_DATA_BUF_SIZE)
 			return -1;
 		rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
+		dev_dbg(adapter->dev, "info: rx_len = %d\n", rx_len);
 
 		skb = mwifiex_alloc_dma_align_buf(rx_len, GFP_KERNEL | GFP_DMA);
 		if (!skb)
@@ -1538,24 +1550,11 @@ static int mwifiex_process_int_status(struct mwifiex_adapter *adapter)
 					rx_len);
 				return -1;
 			}
-			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
 
-			skb = mwifiex_alloc_dma_align_buf(rx_len,
-							  GFP_KERNEL |
-							  GFP_DMA);
-
-			if (!skb) {
-				dev_err(adapter->dev, "%s: failed to alloc skb",
-					__func__);
-				return -1;
-			}
-
-			skb_put(skb, rx_len);
-
-			dev_dbg(adapter->dev, "info: rx_len = %d skb->len = %d\n",
-				rx_len, skb->len);
+			rx_len = (u16) (rx_blocks * MWIFIEX_SDIO_BLOCK_SIZE);
+			dev_dbg(adapter->dev, "info: rx_len = %d\n", rx_len);
 
-			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, skb,
+			if (mwifiex_sdio_card_to_host_mp_aggr(adapter, rx_len,
 							      port)) {
 				dev_err(adapter->dev, "card_to_host_mpa failed:"
 					" int status=%#x\n", sdio_ireg);
diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index 5a23bd0..65ab8b5 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -572,9 +572,9 @@ mp_tx_aggr_port_limit_reached(struct sdio_mmc_card *card)
 
 /* Prepare to copy current packet from card to SDIO Rx aggregation buffer */
 static inline void mp_rx_aggr_setup(struct sdio_mmc_card *card,
-				    struct sk_buff *skb, u8 port)
+				    u16 rx_len, u8 port)
 {
-	card->mpa_rx.buf_len += skb->len;
+	card->mpa_rx.buf_len += rx_len;
 
 	if (!card->mpa_rx.pkt_cnt)
 		card->mpa_rx.start_port = port;
@@ -587,8 +587,8 @@ static inline void mp_rx_aggr_setup(struct sdio_mmc_card *card,
 		else
 			card->mpa_rx.ports |= 1 << (card->mpa_rx.pkt_cnt + 1);
 	}
-	card->mpa_rx.skb_arr[card->mpa_rx.pkt_cnt] = skb;
-	card->mpa_rx.len_arr[card->mpa_rx.pkt_cnt] = skb->len;
+	card->mpa_rx.skb_arr[card->mpa_rx.pkt_cnt] = NULL;
+	card->mpa_rx.len_arr[card->mpa_rx.pkt_cnt] = rx_len;
 	card->mpa_rx.pkt_cnt++;
 }
 #endif /* _MWIFIEX_SDIO_H */
-- 
1.8.1.4

