Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37363 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbbGVSRD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:03 -0400
Received: by wibud3 with SMTP id ud3so184779026wib.0
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:02 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/15] staging: vt6655: Remove ununsed macro ASSERT
Date: Wed, 22 Jul 2015 19:16:33 +0100
Message-Id: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201708_911722_513F590E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VIAWET_DEBUG is not defined so macro is empty.

Remove the macro.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c    | 4 +---
 drivers/staging/vt6655/card.c        | 1 -
 drivers/staging/vt6655/device_cfg.h  | 9 ---------
 drivers/staging/vt6655/device_main.c | 9 ++++-----
 drivers/staging/vt6655/mac.c         | 1 -
 drivers/staging/vt6655/rxtx.c        | 1 -
 6 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index b0ea38f..befaa42 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1728,10 +1728,8 @@ BBuGetFrameTime(
 	unsigned int uRateIdx = (unsigned int) wRate;
 	unsigned int uRate = 0;
 
-	if (uRateIdx > RATE_54M) {
-		ASSERT(0);
+	if (uRateIdx > RATE_54M)
 		return 0;
-	}
 
 	uRate = (unsigned int)awcFrameTime[uRateIdx];
 
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index e00c060..df62bdc 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -847,7 +847,6 @@ void CARDvSetLoopbackMode(struct vnt_private *priv, unsigned short wLoopbackMode
 	case CARD_LB_PHY:
 		break;
 	default:
-		ASSERT(false);
 		break;
 	}
 	/* set MAC loopback */
diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/device_cfg.h
index a4a8a84..c7f21716 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -70,17 +70,8 @@ typedef enum  _chip_type {
 } CHIP_TYPE, *PCHIP_TYPE;
 
 #ifdef VIAWET_DEBUG
-#define ASSERT(x)							\
-do {									\
-	if (!(x)) {							\
-		pr_err("assertion %s failed: file %s line %d\n", \
-		       #x, __func__, __LINE__);				\
-		*(int *)0 = 0;						\
-	}								\
-} while (0)
 #define DBG_PORT80(value)                   outb(value, 0x80)
 #else
-#define ASSERT(x)
 #define DBG_PORT80(value)
 #endif
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 23ad16e..053291a 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -623,7 +623,7 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 	for (i = 0; i < pDevice->sOpts.nRxDescs0; i ++, curr += sizeof(SRxDesc)) {
 		pDesc = &(pDevice->aRD0Ring[i]);
 		pDesc->pRDInfo = alloc_rd_info();
-		ASSERT(pDesc->pRDInfo);
+
 		if (!device_alloc_rx_buf(pDevice, pDesc))
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
 
@@ -647,7 +647,7 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 	for (i = 0; i < pDevice->sOpts.nRxDescs1; i ++, curr += sizeof(SRxDesc)) {
 		pDesc = &(pDevice->aRD1Ring[i]);
 		pDesc->pRDInfo = alloc_rd_info();
-		ASSERT(pDesc->pRDInfo);
+
 		if (!device_alloc_rx_buf(pDevice, pDesc))
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
 
@@ -705,7 +705,7 @@ static void device_init_td0_ring(struct vnt_private *pDevice)
 	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++, curr += sizeof(STxDesc)) {
 		pDesc = &(pDevice->apTD0Rings[i]);
 		pDesc->pTDInfo = alloc_td_info();
-		ASSERT(pDesc->pTDInfo);
+
 		if (pDevice->flags & DEVICE_FLAGS_TX_ALIGN) {
 			pDesc->pTDInfo->buf = pDevice->tx0_bufs + (i)*PKT_BUF_SZ;
 			pDesc->pTDInfo->buf_dma = pDevice->tx_bufs_dma0 + (i)*PKT_BUF_SZ;
@@ -731,7 +731,7 @@ static void device_init_td1_ring(struct vnt_private *pDevice)
 	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++, curr += sizeof(STxDesc)) {
 		pDesc = &(pDevice->apTD1Rings[i]);
 		pDesc->pTDInfo = alloc_td_info();
-		ASSERT(pDesc->pTDInfo);
+
 		if (pDevice->flags & DEVICE_FLAGS_TX_ALIGN) {
 			pDesc->pTDInfo->buf = pDevice->tx1_bufs + (i) * PKT_BUF_SZ;
 			pDesc->pTDInfo->buf_dma = pDevice->tx_bufs_dma1 + (i) * PKT_BUF_SZ;
@@ -818,7 +818,6 @@ static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
 	pRDInfo->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 	if (pRDInfo->skb == NULL)
 		return false;
-	ASSERT(pRDInfo->skb);
 
 	pRDInfo->skb_dma =
 		dma_map_single(&pDevice->pcid->dev,
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index aed530f..65dd49c 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -186,7 +186,6 @@ void MACvSetLoopbackMode(void __iomem *dwIoBase, unsigned char byLoopbackMode)
 {
 	unsigned char byOrgValue;
 
-	ASSERT(byLoopbackMode < 3);
 	byLoopbackMode <<= 6;
 	/* set TCR */
 	VNSvInPortB(dwIoBase + MAC_REG_TEST, &byOrgValue);
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 534338c..0ffa9bf 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -387,7 +387,6 @@ s_uGetDataDuration(
 		break;
 	}
 
-	ASSERT(false);
 	return 0;
 }
 
-- 
2.1.4

