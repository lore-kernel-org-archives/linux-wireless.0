Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36630 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbGVSRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:06 -0400
Received: by wicgb10 with SMTP id gb10so109849080wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 03/15] staging: vt6655: dead code tx path remove dma_unmap_single
Date: Wed, 22 Jul 2015 19:16:35 +0100
Message-Id: <1437589007-5479-3-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201713_407318_EB10C570)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When pTDInfo->skb_dma not equal to pTDInfo->buf_dma, pTDInfo->skb_dma
equals zero.

as mentioned in comment pre-allocated buf_dma can't be unmapped
so remove dead code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 053291a..695aa25 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -754,10 +754,6 @@ static void device_free_td0_ring(struct vnt_private *pDevice)
 		PSTxDesc        pDesc = &(pDevice->apTD0Rings[i]);
 		PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
 
-		if (pTDInfo->skb_dma && (pTDInfo->skb_dma != pTDInfo->buf_dma))
-			dma_unmap_single(&pDevice->pcid->dev, pTDInfo->skb_dma,
-					 pTDInfo->skb->len, DMA_TO_DEVICE);
-
 		dev_kfree_skb(pTDInfo->skb);
 		kfree(pDesc->pTDInfo);
 	}
@@ -771,10 +767,6 @@ static void device_free_td1_ring(struct vnt_private *pDevice)
 		PSTxDesc        pDesc = &(pDevice->apTD1Rings[i]);
 		PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
 
-		if (pTDInfo->skb_dma && (pTDInfo->skb_dma != pTDInfo->buf_dma))
-			dma_unmap_single(&pDevice->pcid->dev, pTDInfo->skb_dma,
-					 pTDInfo->skb->len, DMA_TO_DEVICE);
-
 		dev_kfree_skb(pTDInfo->skb);
 		kfree(pDesc->pTDInfo);
 	}
@@ -975,12 +967,6 @@ static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 	PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
 	struct sk_buff *skb = pTDInfo->skb;
 
-	/* pre-allocated buf_dma can't be unmapped. */
-	if (pTDInfo->skb_dma && (pTDInfo->skb_dma != pTDInfo->buf_dma)) {
-		dma_unmap_single(&pDevice->pcid->dev, pTDInfo->skb_dma,
-				 skb->len, DMA_TO_DEVICE);
-	}
-
 	if (skb)
 		ieee80211_tx_status_irqsafe(pDevice->hw, skb);
 
-- 
2.1.4

