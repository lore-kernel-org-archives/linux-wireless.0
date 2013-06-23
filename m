Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27083 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab3FWKAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jun 2013 06:00:37 -0400
Cc: Kirshenbaum Erez <erezk@wilocity.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 1/2] wil6210: set vring index for all descriptors
Date: Sun, 23 Jun 2013 12:59:34 +0300
Message-ID: <1371981575-14395-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130623_120043_275129_1E641B9D)
In-Reply-To: <1371981575-14395-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1371981575-14395-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kirshenbaum Erez <erezk@wilocity.com>

The vring index (MAC queue id) must be set in all TX descriptors
otherwise HW will fail to release descriptors for a specific vring
(disconnect or vring switch flows).
This is normally occurs when fragmentation required, if vring index
will not be the same for all SKB descriptors HW will fail to flush
this MAC queue.

Signed-off-by: Kirshenbaum Erez <erezk@wilocity.com>
Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e1c492b..73d6c2d 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -621,7 +621,8 @@ static struct vring *wil_find_tx_vring(struct wil6210_priv *wil,
 	return NULL;
 }
 
-static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len)
+static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len,
+			   int vring_index)
 {
 	wil_desc_addr_set(&d->dma.addr, pa);
 	d->dma.ip_length = 0;
@@ -630,7 +631,7 @@ static int wil_tx_desc_map(struct vring_tx_desc *d, dma_addr_t pa, u32 len)
 	d->dma.error = 0;
 	d->dma.status = 0; /* BIT(0) should be 0 for HW_OWNED */
 	d->dma.length = cpu_to_le16((u16)len);
-	d->dma.d0 = 0;
+	d->dma.d0 = (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
 	d->mac.d[0] = 0;
 	d->mac.d[1] = 0;
 	d->mac.d[2] = 0;
@@ -684,7 +685,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	if (unlikely(dma_mapping_error(dev, pa)))
 		return -EINVAL;
 	/* 1-st segment */
-	wil_tx_desc_map(d, pa, skb_headlen(skb));
+	wil_tx_desc_map(d, pa, skb_headlen(skb), vring_index);
 	d->mac.d[2] |= ((nr_frags + 1) <<
 		       MAC_CFG_DESC_TX_2_NUM_OF_DESCRIPTORS_POS);
 	if (nr_frags)
@@ -701,7 +702,7 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 				DMA_TO_DEVICE);
 		if (unlikely(dma_mapping_error(dev, pa)))
 			goto dma_error;
-		wil_tx_desc_map(d, pa, len);
+		wil_tx_desc_map(d, pa, len, vring_index);
 		vring->ctx[i] = NULL;
 		*_d = *d;
 	}
@@ -709,7 +710,6 @@ static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_EOP_POS);
 	d->dma.d0 |= BIT(9); /* BUG: undocumented bit */
 	d->dma.d0 |= BIT(DMA_CFG_DESC_TX_0_CMD_DMA_IT_POS);
-	d->dma.d0 |= (vring_index << DMA_CFG_DESC_TX_0_QID_POS);
 	*_d = *d;
 
 	wil_hex_dump_txrx("Tx ", DUMP_PREFIX_NONE, 32, 4,
-- 
1.8.1.2

