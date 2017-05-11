Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34591 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932376AbdEKR6A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 13:58:00 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/4] staging: rtl8192e: rtl92e_fill_tx_desc fix write to mapped out memory.
Date: Thu, 11 May 2017 18:57:43 +0100
Message-Id: <20170511175746.12378-1-tvboxspy@gmail.com> (sfid-20170511_195805_439638_2F7FC1EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver attempts to alter memory that is mapped to PCI device.

This is because tx_fwinfo_8190pci points to skb->data

Move the pci_map_single to when completed buffer is ready to be mapped with
psdec is empty to drop on mapping error.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: <stable@vger.kernel.org>
---
v2 - Fix typo in subject header. 
 drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
index 4723a0bd5067..a23628f390c9 100644
--- a/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
+++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_dev.c
@@ -1182,8 +1182,7 @@ void  rtl92e_fill_tx_desc(struct net_device *dev, struct tx_desc *pdesc,
 			  struct cb_desc *cb_desc, struct sk_buff *skb)
 {
 	struct r8192_priv *priv = rtllib_priv(dev);
-	dma_addr_t mapping = pci_map_single(priv->pdev, skb->data, skb->len,
-			 PCI_DMA_TODEVICE);
+	dma_addr_t mapping;
 	struct tx_fwinfo_8190pci *pTxFwInfo;
 
 	pTxFwInfo = (struct tx_fwinfo_8190pci *)skb->data;
@@ -1194,8 +1193,6 @@ void  rtl92e_fill_tx_desc(struct net_device *dev, struct tx_desc *pdesc,
 	pTxFwInfo->Short = _rtl92e_query_is_short(pTxFwInfo->TxHT,
 						  pTxFwInfo->TxRate, cb_desc);
 
-	if (pci_dma_mapping_error(priv->pdev, mapping))
-		netdev_err(dev, "%s(): DMA Mapping error\n", __func__);
 	if (cb_desc->bAMPDUEnable) {
 		pTxFwInfo->AllowAggregation = 1;
 		pTxFwInfo->RxMF = cb_desc->ampdu_factor;
@@ -1230,6 +1227,14 @@ void  rtl92e_fill_tx_desc(struct net_device *dev, struct tx_desc *pdesc,
 	}
 
 	memset((u8 *)pdesc, 0, 12);
+
+	mapping = pci_map_single(priv->pdev, skb->data, skb->len,
+				 PCI_DMA_TODEVICE);
+	if (pci_dma_mapping_error(priv->pdev, mapping)) {
+		netdev_err(dev, "%s(): DMA Mapping error\n", __func__);
+		return;
+	}
+
 	pdesc->LINIP = 0;
 	pdesc->CmdInit = 1;
 	pdesc->Offset = sizeof(struct tx_fwinfo_8190pci) + 8;
-- 
2.11.0
