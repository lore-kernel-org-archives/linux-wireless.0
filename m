Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:36568 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbbGVSRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:55 -0400
Received: by wicgb10 with SMTP id gb10so109877025wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:54 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/15] staging: vt6655: Fix wReqCount to __le16
Date: Wed, 22 Jul 2015 19:16:43 +0100
Message-Id: <1437589007-5479-11-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201804_332914_8923DA47)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should be __le16 and do and correct endian conversion.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 8 ++++----
 drivers/staging/vt6655/desc.h | 6 +++---
 drivers/staging/vt6655/dpc.c  | 2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index df62bdc..ae8fd7f 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -573,17 +573,17 @@ CARDvSafeResetRx(
 	/* init state, all RD is chip's */
 	for (uu = 0; uu < pDevice->sOpts.nRxDescs0; uu++) {
 		pDesc = &(pDevice->aRD0Ring[uu]);
-		pDesc->m_rd0RD0.wResCount = (unsigned short)(pDevice->rx_buf_sz);
+		pDesc->m_rd0RD0.wResCount = cpu_to_le16(pDevice->rx_buf_sz);
 		pDesc->m_rd0RD0.f1Owner = OWNED_BY_NIC;
-		pDesc->m_rd1RD1.wReqCount = (unsigned short)(pDevice->rx_buf_sz);
+		pDesc->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
 	}
 
 	/* init state, all RD is chip's */
 	for (uu = 0; uu < pDevice->sOpts.nRxDescs1; uu++) {
 		pDesc = &(pDevice->aRD1Ring[uu]);
-		pDesc->m_rd0RD0.wResCount = (unsigned short)(pDevice->rx_buf_sz);
+		pDesc->m_rd0RD0.wResCount = cpu_to_le16(pDevice->rx_buf_sz);
 		pDesc->m_rd0RD0.f1Owner = OWNED_BY_NIC;
-		pDesc->m_rd1RD1.wReqCount = (unsigned short)(pDevice->rx_buf_sz);
+		pDesc->m_rd1RD1.wReqCount = cpu_to_le16(pDevice->rx_buf_sz);
 	}
 
 	/* set perPkt mode */
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 251f7bc..f6563d3 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -175,7 +175,7 @@ typedef struct tagDEVICE_RD_INFO {
 #ifdef __BIG_ENDIAN
 
 typedef struct tagRDES0 {
-	volatile unsigned short wResCount;
+	volatile __le16 wResCount;
 	union {
 		volatile u16    f15Reserved;
 		struct {
@@ -190,7 +190,7 @@ SRDES0, *PSRDES0;
 #else
 
 typedef struct tagRDES0 {
-	unsigned short wResCount;
+	__le16         wResCount;
 	unsigned short f15Reserved:15;
 	unsigned short f1Owner:1;
 } __attribute__ ((__packed__))
@@ -199,7 +199,7 @@ SRDES0;
 #endif
 
 typedef struct tagRDES1 {
-	unsigned short wReqCount;
+	__le16	       wReqCount;
 	unsigned short wReserved;
 } __attribute__ ((__packed__))
 SRDES1;
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index b25ee96..e14eed1 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -144,7 +144,7 @@ bool vnt_receive_frame(struct vnt_private *priv, PSRxDesc curr_rd)
 			 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 	frame_size = le16_to_cpu(curr_rd->m_rd1RD1.wReqCount)
-			- cpu_to_le16(curr_rd->m_rd0RD0.wResCount);
+			- le16_to_cpu(curr_rd->m_rd0RD0.wResCount);
 
 	if ((frame_size > 2364) || (frame_size < 33)) {
 		/* Frame Size error drop this packet.*/
-- 
2.1.4

