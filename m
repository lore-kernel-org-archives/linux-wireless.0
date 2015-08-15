Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36709 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbbHOU6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 16:58:06 -0400
Received: by wicja10 with SMTP id ja10so43297583wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2015 13:58:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/4] staging: vt6655: replace typedef struct tagRDES1
Date: Sat, 15 Aug 2015 21:57:33 +0100
Message-Id: <1439672255-2548-2-git-send-email-tvboxspy@gmail.com> (sfid-20150815_225813_242277_9C264301)
In-Reply-To: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com>
References: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with struct vnt_rdes1 and members
wReqCount -> req_count
wReserved -> reserved

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  4 ++--
 drivers/staging/vt6655/desc.h        | 11 +++++------
 drivers/staging/vt6655/device_main.c |  2 +-
 drivers/staging/vt6655/dpc.c         |  2 +-
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index ab632e0..7a30ba2 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -575,7 +575,7 @@ CARDvSafeResetRx(
 		pDesc = &(pDevice->aRD0Ring[uu]);
 		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
 		pDesc->rd0.owner = OWNED_BY_NIC;
-		pDesc->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
+		pDesc->rd1.req_count = cpu_to_le16(pDevice->rx_buf_sz);
 	}
 
 	/* init state, all RD is chip's */
@@ -583,7 +583,7 @@ CARDvSafeResetRx(
 		pDesc = &(pDevice->aRD1Ring[uu]);
 		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
 		pDesc->rd0.owner = OWNED_BY_NIC;
-		pDesc->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
+		pDesc->rd1.req_count = cpu_to_le16(pDevice->rx_buf_sz);
 	}
 
 	/* set perPkt mode */
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 68b3121..eb0c7c3 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -189,16 +189,15 @@ struct vnt_rdes0 {
 #endif
 } __packed;
 
-typedef struct tagRDES1 {
-	__le16	       wReqCount;
-	unsigned short wReserved;
-} __attribute__ ((__packed__))
-SRDES1;
+struct vnt_rdes1 {
+	__le16 req_count;
+	u16 reserved;
+} __packed;
 
 /* Rx descriptor*/
 typedef struct tagSRxDesc {
 	volatile struct vnt_rdes0 rd0;
-	volatile SRDES1 m_rd1RD1;
+	volatile struct vnt_rdes1 rd1;
 	volatile __le32 buff_addr;
 	volatile __le32 next_desc;
 	struct tagSRxDesc *next __aligned(8);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 37c2be2..22c1957 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -818,7 +818,7 @@ static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
 
 	pRD->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
 	pRD->rd0.owner = OWNED_BY_NIC;
-	pRD->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
+	pRD->rd1.req_count = cpu_to_le16(pDevice->rx_buf_sz);
 	pRD->buff_addr = cpu_to_le32(pRDInfo->skb_dma);
 
 	return true;
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index dbaaeeb..ef39cbe 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -143,7 +143,7 @@ bool vnt_receive_frame(struct vnt_private *priv, PSRxDesc curr_rd)
 	dma_unmap_single(&priv->pcid->dev, rd_info->skb_dma,
 			 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
-	frame_size = le16_to_cpu(curr_rd->m_rd1RD1.wReqCount)
+	frame_size = le16_to_cpu(curr_rd->rd1.req_count)
 			- le16_to_cpu(curr_rd->rd0.res_count);
 
 	if ((frame_size > 2364) || (frame_size < 33)) {
-- 
2.5.0

