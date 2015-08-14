Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35447 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbbHNV7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:59:23 -0400
Received: by wicne3 with SMTP id ne3so29844526wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:59:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 6/6] staging: vt6655: Replace typedef struct tagSTxDesc
Date: Fri, 14 Aug 2015 22:58:51 +0100
Message-Id: <1439589531-3059-6-git-send-email-tvboxspy@gmail.com> (sfid-20150814_235927_605049_B0CFF588)
In-Reply-To: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
References: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace with struct vnt_tx_desc with all members the same.

volatile is removed from pointers as this generates warning
message.

Only the first four members of vnt_tx_desc need to be volatile.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  2 +-
 drivers/staging/vt6655/desc.h        | 12 +++++-----
 drivers/staging/vt6655/device.h      |  8 +++----
 drivers/staging/vt6655/device_main.c | 43 +++++++++++++++++++-----------------
 drivers/staging/vt6655/rxtx.c        | 10 ++++-----
 drivers/staging/vt6655/rxtx.h        |  2 +-
 6 files changed, 39 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index e3ff4ad..c7b75df 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -514,7 +514,7 @@ CARDvSafeResetTx(
 )
 {
 	unsigned int uu;
-	PSTxDesc    pCurrTD;
+	struct vnt_tx_desc *pCurrTD;
 
 	/* initialize TD index */
 	pDevice->apTailTD[0] = pDevice->apCurrTD[0] = &(pDevice->apTD0Rings[0]);
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 452971c..3c9007e 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -250,16 +250,14 @@ struct vnt_td_info {
 };
 
 /* transmit descriptor */
-typedef struct tagSTxDesc {
+struct vnt_tx_desc {
 	volatile struct vnt_tdes0 td0;
 	volatile struct vnt_tdes1 td1;
-	volatile    __le32  buff_addr;
-	volatile    __le32  next_desc;
-	struct tagSTxDesc *next __aligned(8);
+	volatile __le32 buff_addr;
+	volatile __le32 next_desc;
+	struct vnt_tx_desc *next __aligned(8);
 	struct vnt_td_info *td_info __aligned(8);
-} __attribute__ ((__packed__))
-STxDesc, *PSTxDesc;
-typedef const STxDesc *PCSTxDesc;
+} __packed;
 
 /* Length, Service, and Signal fields of Phy for Tx */
 struct vnt_phy_field {
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index a31769a1..c9fa6ef 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -252,11 +252,11 @@ struct vnt_private {
 	int                         nTxQueues;
 	volatile int                iTDUsed[TYPE_MAXTD];
 
-	volatile PSTxDesc           apCurrTD[TYPE_MAXTD];
-	volatile PSTxDesc           apTailTD[TYPE_MAXTD];
+	struct vnt_tx_desc *apCurrTD[TYPE_MAXTD];
+	struct vnt_tx_desc *apTailTD[TYPE_MAXTD];
 
-	volatile PSTxDesc           apTD0Rings;
-	volatile PSTxDesc           apTD1Rings;
+	struct vnt_tx_desc *apTD0Rings;
+	struct vnt_tx_desc *apTD1Rings;
 
 	volatile PSRxDesc           aRD0Ring;
 	volatile PSRxDesc           aRD1Ring;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f3d8178..0d8f123 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -157,7 +157,7 @@ static int  device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx);
 static int  device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx);
 static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pDesc);
 static void device_init_registers(struct vnt_private *pDevice);
-static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc);
+static void device_free_tx_buf(struct vnt_private *, struct vnt_tx_desc *);
 static void device_free_td0_ring(struct vnt_private *pDevice);
 static void device_free_td1_ring(struct vnt_private *pDevice);
 static void device_free_rd0_ring(struct vnt_private *pDevice);
@@ -522,8 +522,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 	vir_pool = dma_zalloc_coherent(&pDevice->pcid->dev,
 					 pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
 					 pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-					 pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-					 pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
+					 pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
+					 pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
 					 &pDevice->pool_dma, GFP_ATOMIC);
 	if (vir_pool == NULL) {
 		dev_err(&pDevice->pcid->dev, "allocate desc dma memory failed\n");
@@ -551,8 +551,8 @@ static bool device_init_rings(struct vnt_private *pDevice)
 		dma_free_coherent(&pDevice->pcid->dev,
 				    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
 				    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-				    pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-				    pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc),
+				    pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
+				    pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
 				    vir_pool, pDevice->pool_dma
 			);
 		return false;
@@ -562,7 +562,7 @@ static bool device_init_rings(struct vnt_private *pDevice)
 		pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc);
 
 	pDevice->td1_pool_dma = pDevice->td0_pool_dma +
-		pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc);
+		pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
 
 	/* vir_pool: pvoid type */
 	pDevice->apTD0Rings = vir_pool
@@ -572,7 +572,7 @@ static bool device_init_rings(struct vnt_private *pDevice)
 	pDevice->apTD1Rings = vir_pool
 		+ pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc)
 		+ pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc)
-		+ pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc);
+		+ pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
 
 	pDevice->tx1_bufs = pDevice->tx0_bufs +
 		pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ;
@@ -597,8 +597,8 @@ static void device_free_rings(struct vnt_private *pDevice)
 	dma_free_coherent(&pDevice->pcid->dev,
 			    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
 			    pDevice->sOpts.nRxDescs1 * sizeof(SRxDesc) +
-			    pDevice->sOpts.nTxDescs[0] * sizeof(STxDesc) +
-			    pDevice->sOpts.nTxDescs[1] * sizeof(STxDesc)
+			    pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
+			    pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc)
 			    ,
 			    pDevice->aRD0Ring, pDevice->pool_dma
 		);
@@ -697,10 +697,11 @@ static void device_init_td0_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t  curr;
-	PSTxDesc        pDesc;
+	struct vnt_tx_desc *pDesc;
 
 	curr = pDevice->td0_pool_dma;
-	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++, curr += sizeof(STxDesc)) {
+	for (i = 0; i < pDevice->sOpts.nTxDescs[0];
+	     i++, curr += sizeof(struct vnt_tx_desc)) {
 		pDesc = &(pDevice->apTD0Rings[i]);
 		pDesc->td_info = alloc_td_info();
 
@@ -709,7 +710,7 @@ static void device_init_td0_ring(struct vnt_private *pDevice)
 			pDesc->td_info->buf_dma = pDevice->tx_bufs_dma0 + (i)*PKT_BUF_SZ;
 		}
 		pDesc->next = &(pDevice->apTD0Rings[(i+1) % pDevice->sOpts.nTxDescs[0]]);
-		pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
+		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
 	if (i > 0)
@@ -721,11 +722,12 @@ static void device_init_td1_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t  curr;
-	PSTxDesc    pDesc;
+	struct vnt_tx_desc *pDesc;
 
 	/* Init the TD ring entries */
 	curr = pDevice->td1_pool_dma;
-	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++, curr += sizeof(STxDesc)) {
+	for (i = 0; i < pDevice->sOpts.nTxDescs[1];
+	     i++, curr += sizeof(struct vnt_tx_desc)) {
 		pDesc = &(pDevice->apTD1Rings[i]);
 		pDesc->td_info = alloc_td_info();
 
@@ -734,7 +736,7 @@ static void device_init_td1_ring(struct vnt_private *pDevice)
 			pDesc->td_info->buf_dma = pDevice->tx_bufs_dma1 + (i) * PKT_BUF_SZ;
 		}
 		pDesc->next = &(pDevice->apTD1Rings[(i + 1) % pDevice->sOpts.nTxDescs[1]]);
-		pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
+		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
 	if (i > 0)
@@ -747,7 +749,7 @@ static void device_free_td0_ring(struct vnt_private *pDevice)
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++) {
-		PSTxDesc        pDesc = &(pDevice->apTD0Rings[i]);
+		struct vnt_tx_desc *pDesc = &pDevice->apTD0Rings[i];
 		struct vnt_td_info *pTDInfo = pDesc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
@@ -760,7 +762,7 @@ static void device_free_td1_ring(struct vnt_private *pDevice)
 	int i;
 
 	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++) {
-		PSTxDesc        pDesc = &(pDevice->apTD1Rings[i]);
+		struct vnt_tx_desc *pDesc = &pDevice->apTD1Rings[i];
 		struct vnt_td_info *pTDInfo = pDesc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
@@ -900,7 +902,7 @@ static int vnt_int_report_rate(struct vnt_private *priv,
 
 static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 {
-	PSTxDesc                 pTD;
+	struct vnt_tx_desc *pTD;
 	int                      works = 0;
 	unsigned char byTsr0;
 	unsigned char byTsr1;
@@ -958,7 +960,8 @@ static void device_error(struct vnt_private *pDevice, unsigned short status)
 	}
 }
 
-static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
+static void device_free_tx_buf(struct vnt_private *pDevice,
+			       struct vnt_tx_desc *pDesc)
 {
 	struct vnt_td_info *pTDInfo = pDesc->td_info;
 	struct sk_buff *skb = pTDInfo->skb;
@@ -1156,7 +1159,7 @@ static irqreturn_t vnt_interrupt(int irq,  void *arg)
 static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	PSTxDesc head_td;
+	struct vnt_tx_desc *head_td;
 	u32 dma_idx;
 	unsigned long flags;
 
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 8d0ae80..5875d65 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -130,7 +130,7 @@ s_vGenerateTxParameter(
 static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr,
-		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
+		  unsigned int uDMAIdx, struct vnt_tx_desc *pHeadTD,
 		  unsigned int uNodeIndex);
 
 static
@@ -1027,7 +1027,7 @@ s_vGenerateTxParameter(
 static unsigned int
 s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned char *pbyTxBufferAddr,
-		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
+		  unsigned int uDMAIdx, struct vnt_tx_desc *pHeadTD,
 		  unsigned int is_pspoll)
 {
 	struct vnt_td_info *td_info = pHeadTD->td_info;
@@ -1047,7 +1047,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	unsigned int cbReqCount = 0;
 	bool bNeedACK = (bool)(fifo_ctl & FIFOCTL_NEEDACK);
 	bool bRTS = (bool)(fifo_ctl & FIFOCTL_RTS);
-	PSTxDesc       ptdCurr;
+	struct vnt_tx_desc *ptdCurr;
 	unsigned int cbHeaderLength = 0;
 	void *pvRrvTime;
 	struct vnt_mic_hdr *pMICHDR;
@@ -1198,7 +1198,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	/* Copy the Packet into a tx Buffer */
 	memcpy((pbyBuffer + uLength), skb->data, skb->len);
 
-	ptdCurr = (PSTxDesc)pHeadTD;
+	ptdCurr = pHeadTD;
 
 	ptdCurr->td_info->req_count = (u16)cbReqCount;
 
@@ -1273,7 +1273,7 @@ static void vnt_fill_txkey(struct ieee80211_hdr *hdr, u8 *key_buffer,
 }
 
 int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
-			     PSTxDesc head_td, struct sk_buff *skb)
+			     struct vnt_tx_desc *head_td, struct sk_buff *skb)
 {
 	struct vnt_td_info *td_info = head_td->td_info;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 54694df..1e30ecb 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -192,7 +192,7 @@ struct vnt_tx_short_buf_head {
 } __packed;
 
 int vnt_generate_fifo_header(struct vnt_private *, u32,
-			     PSTxDesc head_td, struct sk_buff *);
+			     struct vnt_tx_desc *head_td, struct sk_buff *);
 int vnt_beacon_make(struct vnt_private *, struct ieee80211_vif *);
 int vnt_beacon_enable(struct vnt_private *, struct ieee80211_vif *,
 		      struct ieee80211_bss_conf *);
-- 
2.5.0

