Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36144 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbbJ3GYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 02:24:40 -0400
Received: by pacfv9 with SMTP id fv9so67168021pac.3
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2015 23:24:40 -0700 (PDT)
From: Fengwei Yin <fengwei.yin@linaro.org>
To: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org,
	me@bobcopeland.com, k.eugene.e@gmail.com,
	bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org
Subject: [PATCH v2] wcn36xx: Remove warning message when dev is NULL for arm64 dma_alloc.
Date: Fri, 30 Oct 2015 14:21:58 +0800
Message-Id: <1446186118-7609-1-git-send-email-fengwei.yin@linaro.org> (sfid-20151030_072446_306735_5807EE08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

arm64 has requirement that all the dma operations have actual device.
Otherwise, following warnning message shown and dma allocation fails:

WARNING: CPU: 0 PID: 954 at arch/arm64/mm/dma-mapping.c:106 __dma_alloc+0x24c/0x258()
Use an actual device structure for DMA allocation
Modules linked in: wcn36xx wcn36xx_platform
CPU: 0 PID: 954 Comm: ifconfig Not tainted 4.0.0+ #14
Hardware name: Qualcomm Technologies, Inc. MSM 8916 MTP (DT)
Call trace:
[<ffffffc000089904>] dump_backtrace+0x0/0x124
[<ffffffc000089a38>] show_stack+0x10/0x1c
[<ffffffc000627114>] dump_stack+0x80/0xc4
[<ffffffc0000b2e64>] warn_slowpath_common+0x98/0xd0
[<ffffffc0000b2ee8>] warn_slowpath_fmt+0x4c/0x58
[<ffffffc00009487c>] __dma_alloc+0x248/0x258
[<ffffffbffc009270>] wcn36xx_dxe_allocate_mem_pools+0xc4/0x108 [wcn36xx]
[<ffffffbffc0079c4>] wcn36xx_start+0x38/0x240 [wcn36xx]
[<ffffffc0005f161c>] ieee80211_do_open+0x1b0/0x9a4
[<ffffffc0005f1e68>] ieee80211_open+0x58/0x68
[<ffffffc00051693c>] __dev_open+0xb0/0x120
[<ffffffc000516c10>] __dev_change_flags+0x88/0x150
[<ffffffc000516cf4>] dev_change_flags+0x1c/0x5c
[<ffffffc000570950>] devinet_ioctl+0x644/0x6f0

Signed-off-by: Fengwei Yin <fengwei.yin@linaro.org>
Acked-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---
 v2: Update the submitter name according to suggestion from Kalle Valo.

 drivers/net/wireless/ath/wcn36xx/dxe.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 086549b..9bff361 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -169,7 +169,7 @@ void wcn36xx_dxe_free_ctl_blks(struct wcn36xx *wcn)
 	wcn36xx_dxe_free_ctl_block(&wcn->dxe_rx_h_ch);
 }
 
-static int wcn36xx_dxe_init_descs(struct wcn36xx_dxe_ch *wcn_ch)
+static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn_ch)
 {
 	struct wcn36xx_dxe_desc *cur_dxe = NULL;
 	struct wcn36xx_dxe_desc *prev_dxe = NULL;
@@ -178,7 +178,7 @@ static int wcn36xx_dxe_init_descs(struct wcn36xx_dxe_ch *wcn_ch)
 	int i;
 
 	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
-	wcn_ch->cpu_addr = dma_alloc_coherent(NULL, size, &wcn_ch->dma_addr,
+	wcn_ch->cpu_addr = dma_alloc_coherent(dev, size, &wcn_ch->dma_addr,
 					      GFP_KERNEL);
 	if (!wcn_ch->cpu_addr)
 		return -ENOMEM;
@@ -270,7 +270,7 @@ static int wcn36xx_dxe_enable_ch_int(struct wcn36xx *wcn, u16 wcn_ch)
 	return 0;
 }
 
-static int wcn36xx_dxe_fill_skb(struct wcn36xx_dxe_ctl *ctl)
+static int wcn36xx_dxe_fill_skb(struct device *dev, struct wcn36xx_dxe_ctl *ctl)
 {
 	struct wcn36xx_dxe_desc *dxe = ctl->desc;
 	struct sk_buff *skb;
@@ -279,7 +279,7 @@ static int wcn36xx_dxe_fill_skb(struct wcn36xx_dxe_ctl *ctl)
 	if (skb == NULL)
 		return -ENOMEM;
 
-	dxe->dst_addr_l = dma_map_single(NULL,
+	dxe->dst_addr_l = dma_map_single(dev,
 					 skb_tail_pointer(skb),
 					 WCN36XX_PKT_SIZE,
 					 DMA_FROM_DEVICE);
@@ -297,7 +297,7 @@ static int wcn36xx_dxe_ch_alloc_skb(struct wcn36xx *wcn,
 	cur_ctl = wcn_ch->head_blk_ctl;
 
 	for (i = 0; i < wcn_ch->desc_num; i++) {
-		wcn36xx_dxe_fill_skb(cur_ctl);
+		wcn36xx_dxe_fill_skb(wcn->dev, cur_ctl);
 		cur_ctl = cur_ctl->next;
 	}
 
@@ -358,7 +358,7 @@ static void reap_tx_dxes(struct wcn36xx *wcn, struct wcn36xx_dxe_ch *ch)
 		if (ctl->desc->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)
 			break;
 		if (ctl->skb) {
-			dma_unmap_single(NULL, ctl->desc->src_addr_l,
+			dma_unmap_single(wcn->dev, ctl->desc->src_addr_l,
 					 ctl->skb->len, DMA_TO_DEVICE);
 			info = IEEE80211_SKB_CB(ctl->skb);
 			if (!(info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)) {
@@ -474,7 +474,7 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 	while (!(dxe->ctrl & WCN36XX_DXE_CTRL_VALID_MASK)) {
 		skb = ctl->skb;
 		dma_addr = dxe->dst_addr_l;
-		wcn36xx_dxe_fill_skb(ctl);
+		wcn36xx_dxe_fill_skb(wcn->dev, ctl);
 
 		switch (ch->ch_type) {
 		case WCN36XX_DXE_CH_RX_L:
@@ -491,7 +491,7 @@ static int wcn36xx_rx_handle_packets(struct wcn36xx *wcn,
 			wcn36xx_warn("Unknown channel\n");
 		}
 
-		dma_unmap_single(NULL, dma_addr, WCN36XX_PKT_SIZE,
+		dma_unmap_single(wcn->dev, dma_addr, WCN36XX_PKT_SIZE,
 				 DMA_FROM_DEVICE);
 		wcn36xx_rx_skb(wcn, skb);
 		ctl = ctl->next;
@@ -540,7 +540,7 @@ int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn)
 		16 - (WCN36XX_BD_CHUNK_SIZE % 8);
 
 	s = wcn->mgmt_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_H;
-	cpu_addr = dma_alloc_coherent(NULL, s, &wcn->mgmt_mem_pool.phy_addr,
+	cpu_addr = dma_alloc_coherent(wcn->dev, s, &wcn->mgmt_mem_pool.phy_addr,
 				      GFP_KERNEL);
 	if (!cpu_addr)
 		goto out_err;
@@ -555,7 +555,7 @@ int wcn36xx_dxe_allocate_mem_pools(struct wcn36xx *wcn)
 		16 - (WCN36XX_BD_CHUNK_SIZE % 8);
 
 	s = wcn->data_mem_pool.chunk_size * WCN36XX_DXE_CH_DESC_NUMB_TX_L;
-	cpu_addr = dma_alloc_coherent(NULL, s, &wcn->data_mem_pool.phy_addr,
+	cpu_addr = dma_alloc_coherent(wcn->dev, s, &wcn->data_mem_pool.phy_addr,
 				      GFP_KERNEL);
 	if (!cpu_addr)
 		goto out_err;
@@ -574,13 +574,13 @@ out_err:
 void wcn36xx_dxe_free_mem_pools(struct wcn36xx *wcn)
 {
 	if (wcn->mgmt_mem_pool.virt_addr)
-		dma_free_coherent(NULL, wcn->mgmt_mem_pool.chunk_size *
+		dma_free_coherent(wcn->dev, wcn->mgmt_mem_pool.chunk_size *
 				  WCN36XX_DXE_CH_DESC_NUMB_TX_H,
 				  wcn->mgmt_mem_pool.virt_addr,
 				  wcn->mgmt_mem_pool.phy_addr);
 
 	if (wcn->data_mem_pool.virt_addr) {
-		dma_free_coherent(NULL, wcn->data_mem_pool.chunk_size *
+		dma_free_coherent(wcn->dev, wcn->data_mem_pool.chunk_size *
 				  WCN36XX_DXE_CH_DESC_NUMB_TX_L,
 				  wcn->data_mem_pool.virt_addr,
 				  wcn->data_mem_pool.phy_addr);
@@ -643,7 +643,7 @@ int wcn36xx_dxe_tx_frame(struct wcn36xx *wcn,
 		return -EINVAL;
 	}
 
-	desc->src_addr_l = dma_map_single(NULL,
+	desc->src_addr_l = dma_map_single(wcn->dev,
 					  ctl->skb->data,
 					  ctl->skb->len,
 					  DMA_TO_DEVICE);
@@ -696,7 +696,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for TX LOW channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(&wcn->dxe_tx_l_ch);
+	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_l_ch);
 	wcn36xx_dxe_init_tx_bd(&wcn->dxe_tx_l_ch, &wcn->data_mem_pool);
 
 	/* Write channel head to a NEXT register */
@@ -714,7 +714,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for TX HIGH channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(&wcn->dxe_tx_h_ch);
+	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_h_ch);
 	wcn36xx_dxe_init_tx_bd(&wcn->dxe_tx_h_ch, &wcn->mgmt_mem_pool);
 
 	/* Write channel head to a NEXT register */
@@ -734,7 +734,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for RX LOW channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(&wcn->dxe_rx_l_ch);
+	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_l_ch);
 
 	/* For RX we need to preallocated buffers */
 	wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_l_ch);
@@ -764,7 +764,7 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for RX HIGH channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(&wcn->dxe_rx_h_ch);
+	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_h_ch);
 
 	/* For RX we need to prealocat buffers */
 	wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_h_ch);
-- 
2.1.4

