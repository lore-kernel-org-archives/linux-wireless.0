Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:36716 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbbHOU6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 16:58:07 -0400
Received: by wicja10 with SMTP id ja10so43297812wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2015 13:58:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/4] staging: vt6655: replace typedef struct tagDEVICE_RD_INFO
Date: Sat, 15 Aug 2015 21:57:34 +0100
Message-Id: <1439672255-2548-3-git-send-email-tvboxspy@gmail.com> (sfid-20150815_225817_794262_49FEB367)
In-Reply-To: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com>
References: <1439672255-2548-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

with struct vnt_rd_info

volatile is removed because it will generate a warning
(in any case this member is not) and renaming rd_info.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        |  6 +++---
 drivers/staging/vt6655/device.h      |  4 ++--
 drivers/staging/vt6655/device_main.c | 24 ++++++++++++------------
 drivers/staging/vt6655/dpc.c         |  2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index eb0c7c3..752c546 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -167,10 +167,10 @@
  * leads error.
  */
 
-typedef struct tagDEVICE_RD_INFO {
+struct vnt_rd_info {
 	struct sk_buff *skb;
 	dma_addr_t  skb_dma;
-} DEVICE_RD_INFO,   *PDEVICE_RD_INFO;
+};
 
 struct vnt_rdes0 {
 	volatile __le16 res_count;
@@ -201,7 +201,7 @@ typedef struct tagSRxDesc {
 	volatile __le32 buff_addr;
 	volatile __le32 next_desc;
 	struct tagSRxDesc *next __aligned(8);
-	volatile PDEVICE_RD_INFO pRDInfo __aligned(8);
+	struct vnt_rd_info *rd_info __aligned(8);
 } __attribute__ ((__packed__))
 SRxDesc, *PSRxDesc;
 typedef const SRxDesc *PCSRxDesc;
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index c9fa6ef..80cc170 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -410,9 +410,9 @@ struct vnt_private {
 	struct ieee80211_low_level_stats low_stats;
 };
 
-static inline PDEVICE_RD_INFO alloc_rd_info(void)
+static inline struct vnt_rd_info *alloc_rd_info(void)
 {
-	return kzalloc(sizeof(DEVICE_RD_INFO), GFP_ATOMIC);
+	return kzalloc(sizeof(struct vnt_rd_info), GFP_ATOMIC);
 }
 
 static inline struct vnt_td_info *alloc_td_info(void)
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 22c1957..defdcc0 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -622,7 +622,7 @@ static void device_init_rd0_ring(struct vnt_private *pDevice)
 	/* Init the RD0 ring entries */
 	for (i = 0; i < pDevice->sOpts.nRxDescs0; i ++, curr += sizeof(SRxDesc)) {
 		pDesc = &(pDevice->aRD0Ring[i]);
-		pDesc->pRDInfo = alloc_rd_info();
+		pDesc->rd_info = alloc_rd_info();
 
 		if (!device_alloc_rx_buf(pDevice, pDesc))
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
@@ -645,7 +645,7 @@ static void device_init_rd1_ring(struct vnt_private *pDevice)
 	/* Init the RD1 ring entries */
 	for (i = 0; i < pDevice->sOpts.nRxDescs1; i ++, curr += sizeof(SRxDesc)) {
 		pDesc = &(pDevice->aRD1Ring[i]);
-		pDesc->pRDInfo = alloc_rd_info();
+		pDesc->rd_info = alloc_rd_info();
 
 		if (!device_alloc_rx_buf(pDevice, pDesc))
 			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
@@ -665,14 +665,14 @@ static void device_free_rd0_ring(struct vnt_private *pDevice)
 
 	for (i = 0; i < pDevice->sOpts.nRxDescs0; i++) {
 		PSRxDesc        pDesc = &(pDevice->aRD0Ring[i]);
-		PDEVICE_RD_INFO  pRDInfo = pDesc->pRDInfo;
+		struct vnt_rd_info *rd_info = pDesc->rd_info;
 
-		dma_unmap_single(&pDevice->pcid->dev, pRDInfo->skb_dma,
+		dma_unmap_single(&pDevice->pcid->dev, rd_info->skb_dma,
 				 pDevice->rx_buf_sz, DMA_FROM_DEVICE);
 
-		dev_kfree_skb(pRDInfo->skb);
+		dev_kfree_skb(rd_info->skb);
 
-		kfree(pDesc->pRDInfo);
+		kfree(pDesc->rd_info);
 	}
 }
 
@@ -682,14 +682,14 @@ static void device_free_rd1_ring(struct vnt_private *pDevice)
 
 	for (i = 0; i < pDevice->sOpts.nRxDescs1; i++) {
 		PSRxDesc        pDesc = &(pDevice->aRD1Ring[i]);
-		PDEVICE_RD_INFO  pRDInfo = pDesc->pRDInfo;
+		struct vnt_rd_info *rd_info = pDesc->rd_info;
 
-		dma_unmap_single(&pDevice->pcid->dev, pRDInfo->skb_dma,
+		dma_unmap_single(&pDevice->pcid->dev, rd_info->skb_dma,
 				 pDevice->rx_buf_sz, DMA_FROM_DEVICE);
 
-		dev_kfree_skb(pRDInfo->skb);
+		dev_kfree_skb(rd_info->skb);
 
-		kfree(pDesc->pRDInfo);
+		kfree(pDesc->rd_info);
 	}
 }
 
@@ -783,7 +783,7 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 		if (works++ > 15)
 			break;
 
-		if (!pRD->pRDInfo->skb)
+		if (!pRD->rd_info->skb)
 			break;
 
 		if (vnt_receive_frame(pDevice, pRD)) {
@@ -803,7 +803,7 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 
 static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
 {
-	PDEVICE_RD_INFO pRDInfo = pRD->pRDInfo;
+	struct vnt_rd_info *pRDInfo = pRD->rd_info;
 
 	pRDInfo->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 	if (pRDInfo->skb == NULL)
diff --git a/drivers/staging/vt6655/dpc.c b/drivers/staging/vt6655/dpc.c
index ef39cbe..4659185 100644
--- a/drivers/staging/vt6655/dpc.c
+++ b/drivers/staging/vt6655/dpc.c
@@ -134,7 +134,7 @@ static bool vnt_rx_data(struct vnt_private *priv, struct sk_buff *skb,
 
 bool vnt_receive_frame(struct vnt_private *priv, PSRxDesc curr_rd)
 {
-	PDEVICE_RD_INFO rd_info = curr_rd->pRDInfo;
+	struct vnt_rd_info *rd_info = curr_rd->rd_info;
 	struct sk_buff *skb;
 	u16 frame_size;
 
-- 
2.5.0

