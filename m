Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33817 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbbJCTan (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 15:30:43 -0400
Received: by wicfx3 with SMTP id fx3so71872002wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2015 12:30:42 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/6] staging: vt6655: device_alloc_rx_buf replace pRDInfo with rd_info.
Date: Sat,  3 Oct 2015 20:30:24 +0100
Message-Id: <1443900627-2924-3-git-send-email-tvboxspy@gmail.com> (sfid-20151003_213055_339606_09071021)
In-Reply-To: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
References: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 41c08b3..b330379 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -732,15 +732,15 @@ static int device_rx_srv(struct vnt_private *priv, unsigned int uIdx)
 static bool device_alloc_rx_buf(struct vnt_private *priv,
 				struct vnt_rx_desc *pRD)
 {
-	struct vnt_rd_info *pRDInfo = pRD->rd_info;
+	struct vnt_rd_info *rd_info = pRD->rd_info;
 
-	pRDInfo->skb = dev_alloc_skb((int)priv->rx_buf_sz);
-	if (pRDInfo->skb == NULL)
+	rd_info->skb = dev_alloc_skb((int)priv->rx_buf_sz);
+	if (rd_info->skb == NULL)
 		return false;
 
-	pRDInfo->skb_dma =
+	rd_info->skb_dma =
 		dma_map_single(&priv->pcid->dev,
-			       skb_put(pRDInfo->skb, skb_tailroom(pRDInfo->skb)),
+			       skb_put(rd_info->skb, skb_tailroom(rd_info->skb)),
 			       priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 	*((unsigned int *)&pRD->rd0) = 0; /* FIX cast */
@@ -748,7 +748,7 @@ static bool device_alloc_rx_buf(struct vnt_private *priv,
 	pRD->rd0.res_count = cpu_to_le16(priv->rx_buf_sz);
 	pRD->rd0.owner = OWNED_BY_NIC;
 	pRD->rd1.req_count = cpu_to_le16(priv->rx_buf_sz);
-	pRD->buff_addr = cpu_to_le32(pRDInfo->skb_dma);
+	pRD->buff_addr = cpu_to_le32(rd_info->skb_dma);
 
 	return true;
 }
-- 
2.5.0

