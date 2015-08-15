Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35180 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbbHOU6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 16:58:06 -0400
Received: by wicne3 with SMTP id ne3so43528146wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2015 13:58:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/4] staging: vt6655: replace typedef struct tagRDES0
Date: Sat, 15 Aug 2015 21:57:32 +0100
Message-Id: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com> (sfid-20150815_225810_821151_C589D8C0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with struct vnt_rdes0 replacing members as follows
wResCount -> res_count
f15Reserved -> f15_reserved
f1Owner -> owner

big endian
f8Reserved1 -> f8_reserved1
f7Reserved -> f7_reserved

Narrowing endian differences to inside structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  8 ++++----
 drivers/staging/vt6655/desc.h        | 33 ++++++++++++---------------------
 drivers/staging/vt6655/device_main.c | 10 +++++-----
 drivers/staging/vt6655/dpc.c         |  2 +-
 4 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index c7b75df..ab632e0 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -573,16 +573,16 @@ CARDvSafeResetRx(
 	/* init state, all RD is chip's */
 	for (uu = 0; uu < pDevice->sOpts.nRxDescs0; uu++) {
 		pDesc = &(pDevice->aRD0Ring[uu]);
-		pDesc->m_rd0RD0.wResCount = cpu_to_le16(pDevice->rx_buf_sz);
-		pDesc->m_rd0RD0.f1Owner = OWNED_BY_NIC;
+		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
+		pDesc->rd0.owner = OWNED_BY_NIC;
 		pDesc->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
 	}
 
 	/* init state, all RD is chip's */
 	for (uu = 0; uu < pDevice->sOpts.nRxDescs1; uu++) {
 		pDesc = &(pDevice->aRD1Ring[uu]);
-		pDesc->m_rd0RD0.wResCount = cpu_to_le16(pDevice->rx_buf_sz);
-		pDesc->m_rd0RD0.f1Owner = OWNED_BY_NIC;
+		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
+		pDesc->rd0.owner = OWNED_BY_NIC;
 		pDesc->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
 	}
 
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 3c9007e..68b3121 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -172,31 +172,22 @@ typedef struct tagDEVICE_RD_INFO {
 	dma_addr_t  skb_dma;
 } DEVICE_RD_INFO,   *PDEVICE_RD_INFO;
 
+struct vnt_rdes0 {
+	volatile __le16 res_count;
 #ifdef __BIG_ENDIAN
-
-typedef struct tagRDES0 {
-	volatile __le16 wResCount;
 	union {
-		volatile u16    f15Reserved;
+		volatile u16 f15_reserved;
 		struct {
-			volatile u8 f8Reserved1;
-			volatile u8 f1Owner:1;
-			volatile u8 f7Reserved:7;
-		} __attribute__ ((__packed__));
-	} __attribute__ ((__packed__));
-} __attribute__ ((__packed__))
-SRDES0, *PSRDES0;
-
+			volatile u8 f8_reserved1;
+			volatile u8 owner:1;
+			volatile u8 f7_reserved:7;
+		} __packed;
+	} __packed;
 #else
-
-typedef struct tagRDES0 {
-	__le16         wResCount;
-	unsigned short f15Reserved:15;
-	unsigned short f1Owner:1;
-} __attribute__ ((__packed__))
-SRDES0;
-
+	u16 f15_reserved:15;
+	u16 owner:1;
 #endif
+} __packed;
 
 typedef struct tagRDES1 {
 	__le16	       wReqCount;
@@ -206,7 +197,7 @@ SRDES1;
 
 /* Rx descriptor*/
 typedef struct tagSRxDesc {
-	volatile SRDES0 m_rd0RD0;
+	volatile struct vnt_rdes0 rd0;
 	volatile SRDES1 m_rd1RD1;
 	volatile __le32 buff_addr;
 	volatile __le32 next_desc;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 0d8f123..37c2be2 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -778,7 +778,7 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 	int works = 0;
 
 	for (pRD = pDevice->pCurrRD[uIdx];
-	     pRD->m_rd0RD0.f1Owner == OWNED_BY_HOST;
+	     pRD->rd0.owner == OWNED_BY_HOST;
 	     pRD = pRD->next) {
 		if (works++ > 15)
 			break;
@@ -793,7 +793,7 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 				break;
 			}
 		}
-		pRD->m_rd0RD0.f1Owner = OWNED_BY_NIC;
+		pRD->rd0.owner = OWNED_BY_NIC;
 	}
 
 	pDevice->pCurrRD[uIdx] = pRD;
@@ -814,10 +814,10 @@ static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
 			       skb_put(pRDInfo->skb, skb_tailroom(pRDInfo->skb)),
 			       pDevice->rx_buf_sz, DMA_FROM_DEVICE);
 
-	*((unsigned int *)&(pRD->m_rd0RD0)) = 0; /* FIX cast */
+	*((unsigned int *)&pRD->rd0) = 0; /* FIX cast */
 
-	pRD->m_rd0RD0.wResCount = cpu_to_le16(pDevice->rx_buf_sz);
-	pRD->m_rd0RD0.f1Owner = OWNED_BY_NIC;
+	pRD->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
+	pRD->rd0.owner = OWNED_BY_NIC;
 	pRD->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
 	pRD->buff_addr = cpu_to_le32(pRDInfo->skb_dma);
 
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index e14eed1..dbaaeeb 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -144,7 +144,7 @@ bool vnt_receive_frame(struct vnt_private *priv, PSRxDesc curr_rd)
 			 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 	frame_size = le16_to_cpu(curr_rd->m_rd1RD1.wReqCount)
-			- le16_to_cpu(curr_rd->m_rd0RD0.wResCount);
+			- le16_to_cpu(curr_rd->rd0.res_count);
 
 	if ((frame_size > 2364) || (frame_size < 33)) {
 		/* Frame Size error drop this packet.*/
-- 
2.5.0

