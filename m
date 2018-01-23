Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbeAWPUb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 10:20:31 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, bjorn.andersson@linaro.org,
        wcn36xx@lists.infradead.org, k.eugene.e@gmail.com
Cc: Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH v2] wcn36xx: release resources in case of error
Date: Tue, 23 Jan 2018 17:20:13 +0200
Message-Id: <20180123152013.18257-1-rfried@codeaurora.org> (sfid-20180123_162042_655935_605674CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wcn36xx_dxe_init() doesn't check for the return value
of wcn36xx_dxe_init_descs().
This patch releases the resources in case an error ocurred.

Change-Id: I924bd7489b60243c0a0cbaa716caf924f11d7587
Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c | 48 +++++++++++++++++++++++++++++-----
 1 file changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index d5c810a8cc52..60bf9b25d07f 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -236,6 +236,16 @@ static int wcn36xx_dxe_init_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn
 	return 0;
 }
 
+static void wcn36xx_dxe_deinit_descs(struct device *dev, struct wcn36xx_dxe_ch *wcn_ch)
+{
+	size_t size;
+
+	size = wcn_ch->desc_num * sizeof(struct wcn36xx_dxe_desc);
+	dma_free_coherent(dev, size,
+					wcn_ch->cpu_addr,
+					wcn_ch->dma_addr);
+}
+
 static void wcn36xx_dxe_init_tx_bd(struct wcn36xx_dxe_ch *ch,
 				   struct wcn36xx_dxe_mem_pool *pool)
 {
@@ -722,7 +732,11 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for TX LOW channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_l_ch);
+	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_l_ch);
+	if (ret) {
+		dev_err(wcn->dev, "Error allocating descriptor\n");
+		return ret;
+	}
 	wcn36xx_dxe_init_tx_bd(&wcn->dxe_tx_l_ch, &wcn->data_mem_pool);
 
 	/* Write channel head to a NEXT register */
@@ -740,7 +754,12 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for TX HIGH channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_h_ch);
+	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_tx_h_ch);
+	if (ret) {
+		dev_err(wcn->dev, "Error allocating descriptor\n");
+		goto out_err_txh_ch;
+	}
+
 	wcn36xx_dxe_init_tx_bd(&wcn->dxe_tx_h_ch, &wcn->mgmt_mem_pool);
 
 	/* Write channel head to a NEXT register */
@@ -760,7 +779,12 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for RX LOW channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_l_ch);
+	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_l_ch);
+	if (ret) {
+		dev_err(wcn->dev, "Error allocating descriptor\n");
+		goto out_err_rxl_ch;
+	}
+
 
 	/* For RX we need to preallocated buffers */
 	wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_l_ch);
@@ -790,7 +814,11 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 	/***************************************/
 	/* Init descriptors for RX HIGH channel */
 	/***************************************/
-	wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_h_ch);
+	ret = wcn36xx_dxe_init_descs(wcn->dev, &wcn->dxe_rx_h_ch);
+	if (ret) {
+		dev_err(wcn->dev, "Error allocating descriptor\n");
+		goto out_err_rxh_ch;
+	}
 
 	/* For RX we need to prealocat buffers */
 	wcn36xx_dxe_ch_alloc_skb(wcn, &wcn->dxe_rx_h_ch);
@@ -819,11 +847,19 @@ int wcn36xx_dxe_init(struct wcn36xx *wcn)
 
 	ret = wcn36xx_dxe_request_irqs(wcn);
 	if (ret < 0)
-		goto out_err;
+		goto out_err_irq;
 
 	return 0;
 
-out_err:
+out_err_irq:
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_rx_h_ch);
+out_err_rxh_ch:
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_rx_l_ch);
+out_err_rxl_ch:
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_tx_h_ch);
+out_err_txh_ch:
+	wcn36xx_dxe_deinit_descs(wcn->dev, &wcn->dxe_tx_l_ch);
+
 	return ret;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
