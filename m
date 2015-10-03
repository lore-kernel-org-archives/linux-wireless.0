Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:33827 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbJCTao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 15:30:44 -0400
Received: by wicfx3 with SMTP id fx3so71872339wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2015 12:30:43 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: device_main replace pRD with rd.
Date: Sat,  3 Oct 2015 20:30:25 +0100
Message-Id: <1443900627-2924-4-git-send-email-tvboxspy@gmail.com> (sfid-20151003_213050_283148_90DD71F1)
In-Reply-To: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
References: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b330379..7e76176 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -702,37 +702,37 @@ static void device_free_td1_ring(struct vnt_private *priv)
 
 static int device_rx_srv(struct vnt_private *priv, unsigned int uIdx)
 {
-	struct vnt_rx_desc *pRD;
+	struct vnt_rx_desc *rd;
 	int works = 0;
 
-	for (pRD = priv->pCurrRD[uIdx];
-	     pRD->rd0.owner == OWNED_BY_HOST;
-	     pRD = pRD->next) {
+	for (rd = priv->pCurrRD[uIdx];
+	     rd->rd0.owner == OWNED_BY_HOST;
+	     rd = rd->next) {
 		if (works++ > 15)
 			break;
 
-		if (!pRD->rd_info->skb)
+		if (!rd->rd_info->skb)
 			break;
 
-		if (vnt_receive_frame(priv, pRD)) {
-			if (!device_alloc_rx_buf(priv, pRD)) {
+		if (vnt_receive_frame(priv, rd)) {
+			if (!device_alloc_rx_buf(priv, rd)) {
 				dev_err(&priv->pcid->dev,
 					"can not allocate rx buf\n");
 				break;
 			}
 		}
-		pRD->rd0.owner = OWNED_BY_NIC;
+		rd->rd0.owner = OWNED_BY_NIC;
 	}
 
-	priv->pCurrRD[uIdx] = pRD;
+	priv->pCurrRD[uIdx] = rd;
 
 	return works;
 }
 
 static bool device_alloc_rx_buf(struct vnt_private *priv,
-				struct vnt_rx_desc *pRD)
+				struct vnt_rx_desc *rd)
 {
-	struct vnt_rd_info *rd_info = pRD->rd_info;
+	struct vnt_rd_info *rd_info = rd->rd_info;
 
 	rd_info->skb = dev_alloc_skb((int)priv->rx_buf_sz);
 	if (rd_info->skb == NULL)
@@ -743,12 +743,12 @@ static bool device_alloc_rx_buf(struct vnt_private *priv,
 			       skb_put(rd_info->skb, skb_tailroom(rd_info->skb)),
 			       priv->rx_buf_sz, DMA_FROM_DEVICE);
 
-	*((unsigned int *)&pRD->rd0) = 0; /* FIX cast */
+	*((unsigned int *)&rd->rd0) = 0; /* FIX cast */
 
-	pRD->rd0.res_count = cpu_to_le16(priv->rx_buf_sz);
-	pRD->rd0.owner = OWNED_BY_NIC;
-	pRD->rd1.req_count = cpu_to_le16(priv->rx_buf_sz);
-	pRD->buff_addr = cpu_to_le32(rd_info->skb_dma);
+	rd->rd0.res_count = cpu_to_le16(priv->rx_buf_sz);
+	rd->rd0.owner = OWNED_BY_NIC;
+	rd->rd1.req_count = cpu_to_le16(priv->rx_buf_sz);
+	rd->buff_addr = cpu_to_le32(rd_info->skb_dma);
 
 	return true;
 }
-- 
2.5.0

