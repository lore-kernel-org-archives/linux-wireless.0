Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38862 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbbHOU6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 16:58:08 -0400
Received: by wicja10 with SMTP id ja10so49528144wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2015 13:58:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/4] staging: vt6655: replace typedef struct tagSRxDesc
Date: Sat, 15 Aug 2015 21:57:35 +0100
Message-Id: <1439672255-2548-4-git-send-email-tvboxspy@gmail.com> (sfid-20150815_225815_064585_6E9F0A7D)
In-Reply-To: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com>
References: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with struct vnt_rx_desc and all members the same.

volatile is removed from pointers as this generates warning
message.

Only the first four members of vnt_rx_desc need to be volatile.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  2 +-
 drivers/staging/vt6655/desc.h        |  8 +++---
 drivers/staging/vt6655/device.h      |  6 ++---
 drivers/staging/vt6655/device_main.c | 51 +++++++++++++++++++-----------------
 drivers/staging/vt6655/dpc.c         |  2 +-
 drivers/staging/vt6655/dpc.h         |  2 +-
 6 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 7a30ba2..ecbe94f 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -564,7 +564,7 @@ CARDvSafeResetRx(
 )
 {
 	unsigned int uu;
-	PSRxDesc    pDesc;
+	struct vnt_rx_desc *pDesc;
 
 	/* initialize RD index */
 	pDevice->pCurrRD[0] = &(pDevice->aRD0Ring[0]);
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 752c546..9fbc717 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -195,16 +195,14 @@ struct vnt_rdes1 {
 } __packed;
 
 /* Rx descriptor*/
-typedef struct tagSRxDesc {
+struct vnt_rx_desc {
 	volatile struct vnt_rdes0 rd0;
 	volatile struct vnt_rdes1 rd1;
 	volatile __le32 buff_addr;
 	volatile __le32 next_desc;
-	struct tagSRxDesc *next __aligned(8);
+	struct vnt_rx_desc *next __aligned(8);
 	struct vnt_rd_info *rd_info __aligned(8);
-} __attribute__ ((__packed__))
-SRxDesc, *PSRxDesc;
-typedef const SRxDesc *PCSRxDesc;
+} __packed;
 
 struct vnt_tdes0 {
 	volatile u8 tsr0;
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 80cc170..d1917d0 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -258,9 +258,9 @@ struct vnt_private {
 	struct vnt_tx_desc *apTD0Rings;
 	struct vnt_tx_desc *apTD1Rings;
 
-	volatile PSRxDesc           aRD0Ring;
-	volatile PSRxDesc           aRD1Ring;
-	volatile PSRxDesc           pCurrRD[TYPE_MAXRD];
+	struct vnt_rx_desc *aRD0Ring;
+	struct vnt_rx_desc *aRD1Ring;
+	struct vnt_rx_desc *pCurrRD[TYPE_MAXRD];
 
 	OPTIONS                     sOpts;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index defdcc0..86c24a1 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -155,7 +155,7 @@ static void device_init_td1_ring(struct vnt_private *pDevice);
 
 static int  device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx);
 static int  device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx);
-static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pDesc);
+static bool device_alloc_rx_buf(struct vnt_private *, struct vnt_rx_desc *);
 static void device_init_registers(struct vnt_private *pDevice);
 static void device_free_tx_buf(struct vnt_private *, struct vnt_tx_desc *);
 static void device_free_td0_ring(struct vnt_private *pDevice);
@@ -520,8 +520,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 
 	/*allocate all RD/TD rings a single pool*/
 	vir_pool = dma_zalloc_coherent(&pDevice->pcid->dev,
-					 pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-					 pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
+					 pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
+					 pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
 					 pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
 					 pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
 					 &pDevice->pool_dma, GFP_ATOMIC);
@@ -532,11 +532,11 @@ static bool device_init_rings(struct vnt_private *pDevice)
 
 	pDevice->aRD0Ring = vir_pool;
 	pDevice->aRD1Ring = vir_pool +
-		pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc);
+		pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
 
 	pDevice->rd0_pool_dma = pDevice->pool_dma;
 	pDevice->rd1_pool_dma = pDevice->rd0_pool_dma +
-		pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc);
+		pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
 
 	pDevice->tx0_bufs = dma_zalloc_coherent(&pDevice->pcid->dev,
 						  pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
@@ -549,8 +549,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 		dev_err(&pDevice->pcid->dev, "allocate buf dma memory failed\n");
 
 		dma_free_coherent(&pDevice->pcid->dev,
-				    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-				    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
+				    pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
+				    pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
 				    pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
 				    pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
 				    vir_pool, pDevice->pool_dma
@@ -559,19 +559,19 @@ static bool device_init_rings(struct vnt_private *pDevice)
 	}
 
 	pDevice->td0_pool_dma = pDevice->rd1_pool_dma +
-		pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc);
+		pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
 
 	pDevice->td1_pool_dma = pDevice->td0_pool_dma +
 		pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
 
 	/* vir_pool: pvoid type */
 	pDevice->apTD0Rings = vir_pool
-		+ pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc)
-		+ pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc);
+		+ pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
+		+ pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
 
 	pDevice->apTD1Rings = vir_pool
-		+ pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc)
-		+ pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc)
+		+ pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
+		+ pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc)
 		+ pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
 
 	pDevice->tx1_bufs = pDevice->tx0_bufs +
@@ -595,8 +595,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 static void device_free_rings(struct vnt_private *pDevice)
 {
 	dma_free_coherent(&pDevice->pcid->dev,
-			    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
-			    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
+			    pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
+			    pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
 			    pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
 			    pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc)
 			    ,
@@ -617,10 +617,11 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t      curr = pDevice->rd0_pool_dma;
-	PSRxDesc        pDesc;
+	struct vnt_rx_desc *pDesc;
 
 	/* Init the RD0 ring entries */
-	for (i = 0; i < pDevice->sOpts.nRxDescs0; i ++, curr += sizeof(SRxDesc)) {
+	for (i = 0; i < pDevice->sOpts.nRxDescs0;
+	     i ++, curr += sizeof(struct vnt_rx_desc)) {
 		pDesc = &(pDevice->aRD0Ring[i]);
 		pDesc->rd_info = alloc_rd_info();
 
@@ -628,7 +629,7 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
 
 		pDesc->next = &(pDevice->aRD0Ring[(i+1) % pDevice->sOpts.nRxDescs0]);
-		pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
+		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
 	if (i > 0)
@@ -640,10 +641,11 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t      curr = pDevice->rd1_pool_dma;
-	PSRxDesc        pDesc;
+	struct vnt_rx_desc *pDesc;
 
 	/* Init the RD1 ring entries */
-	for (i = 0; i < pDevice->sOpts.nRxDescs1; i ++, curr += sizeof(SRxDesc)) {
+	for (i = 0; i < pDevice->sOpts.nRxDescs1;
+	     i ++, curr += sizeof(struct vnt_rx_desc)) {
 		pDesc = &(pDevice->aRD1Ring[i]);
 		pDesc->rd_info = alloc_rd_info();
 
@@ -651,7 +653,7 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
 
 		pDesc->next = &(pDevice->aRD1Ring[(i+1) % pDevice->sOpts.nRxDescs1]);
-		pDesc->next_desc = cpu_to_le32(curr + sizeof(SRxDesc));
+		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
 	if (i > 0)
@@ -664,7 +666,7 @@ static void device_free_rd0_ring(struct vnt_private *pDevice)
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nRxDescs0; i++) {
-		PSRxDesc        pDesc = &(pDevice->aRD0Ring[i]);
+		struct vnt_rx_desc *pDesc = &(pDevice->aRD0Ring[i]);
 		struct vnt_rd_info *rd_info = pDesc->rd_info;
 
 		dma_unmap_single(&pDevice->pcid->dev, rd_info->skb_dma,
@@ -681,7 +683,7 @@ static void device_free_rd1_ring(struct vnt_private *pDevice)
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nRxDescs1; i++) {
-		PSRxDesc        pDesc = &(pDevice->aRD1Ring[i]);
+		struct vnt_rx_desc *pDesc = &(pDevice->aRD1Ring[i]);
 		struct vnt_rd_info *rd_info = pDesc->rd_info;
 
 		dma_unmap_single(&pDevice->pcid->dev, rd_info->skb_dma,
@@ -774,7 +776,7 @@ static void device_free_td1_ring(struct vnt_private *pDevice)
 
 static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 {
-	PSRxDesc    pRD;
+	struct vnt_rx_desc *pRD;
 	int works = 0;
 
 	for (pRD = pDevice->pCurrRD[uIdx];
@@ -801,7 +803,8 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 	return works;
 }
 
-static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
+static bool device_alloc_rx_buf(struct vnt_private *pDevice,
+				struct vnt_rx_desc *pRD)
 {
 	struct vnt_rd_info *pRDInfo = pRD->rd_info;
 
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index 4659185..700032e 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -132,7 +132,7 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 	return true;
 }
 
-bool vnt_receive_frame(struct vnt_private *priv, PSRxDesc curr_rd)
+bool vnt_receive_frame(struct vnt_private *priv, struct vnt_rx_desc *curr_rd)
 {
 	struct vnt_rd_info *rd_info = curr_rd->rd_info;
 	struct sk_buff *skb;
diff --git a/drivers/staging/vt6655/dpc.h b/drivers/staging/vt6655/dpc.h
index ad49571..e80b308 100644
--- a/drivers/staging/vt6655/dpc.h
+++ b/drivers/staging/vt6655/dpc.h
@@ -31,6 +31,6 @@
 
 #include "device.h"
 
-bool vnt_receive_frame(struct vnt_private *priv, PSRxDesc curr_rd);
+bool vnt_receive_frame(struct vnt_private *priv, struct vnt_rx_desc *curr_rd);
 
 #endif /* __RXTX_H__ */
-- 
2.5.0

