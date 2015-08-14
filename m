Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36378 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbHNV7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:59:22 -0400
Received: by wicja10 with SMTP id ja10so29659112wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:59:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/6] staging: vt6655: replace typedef struct tagDEVICE_TD_INFO and structure
Date: Fri, 14 Aug 2015 22:58:50 +0100
Message-Id: <1439589531-3059-5-git-send-email-tvboxspy@gmail.com> (sfid-20150814_235928_560049_01C407E8)
In-Reply-To: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
References: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create struct vnt_td_info with members
mic_hdr
skb
buf
buf_dma
dwReqCount -> req_count
byFlags -> flags

In struct tagSTxDesc volatile is removed because it will generate a warning
(in any case this member is not) and renaming td_info.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        | 12 +++++------
 drivers/staging/vt6655/device.h      |  4 ++--
 drivers/staging/vt6655/device_main.c | 42 ++++++++++++++++++------------------
 drivers/staging/vt6655/rxtx.c        |  8 +++----
 4 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 0b786cf..452971c 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -240,14 +240,14 @@ struct vnt_tdes1 {
 	volatile u8 reserved;
 } __packed;
 
-typedef struct tagDEVICE_TD_INFO {
+struct vnt_td_info {
 	void *mic_hdr;
 	struct sk_buff *skb;
 	unsigned char *buf;
-	dma_addr_t          buf_dma;
-	u16 dwReqCount;
-	unsigned char byFlags;
-} DEVICE_TD_INFO,    *PDEVICE_TD_INFO;
+	dma_addr_t buf_dma;
+	u16 req_count;
+	u8 flags;
+};
 
 /* transmit descriptor */
 typedef struct tagSTxDesc {
@@ -256,7 +256,7 @@ typedef struct tagSTxDesc {
 	volatile    __le32  buff_addr;
 	volatile    __le32  next_desc;
 	struct tagSTxDesc *next __aligned(8);
-	volatile    PDEVICE_TD_INFO pTDInfo __aligned(8);
+	struct vnt_td_info *td_info __aligned(8);
 } __attribute__ ((__packed__))
 STxDesc, *PSTxDesc;
 typedef const STxDesc *PCSTxDesc;
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 6aebb49..a31769a1 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -415,8 +415,8 @@ static inline PDEVICE_RD_INFO alloc_rd_info(void)
 	return kzalloc(sizeof(DEVICE_RD_INFO), GFP_ATOMIC);
 }
 
-static inline PDEVICE_TD_INFO alloc_td_info(void)
+static inline struct vnt_td_info *alloc_td_info(void)
 {
-	return kzalloc(sizeof(DEVICE_TD_INFO), GFP_ATOMIC);
+	return kzalloc(sizeof(struct vnt_td_info), GFP_ATOMIC);
 }
 #endif
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index c3b7bd4..f3d8178 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -702,11 +702,11 @@ static void device_init_td0_ring(struct vnt_private *pDevice)
 	curr = pDevice->td0_pool_dma;
 	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++, curr += sizeof(STxDesc)) {
 		pDesc = &(pDevice->apTD0Rings[i]);
-		pDesc->pTDInfo = alloc_td_info();
+		pDesc->td_info = alloc_td_info();
 
 		if (pDevice->flags & DEVICE_FLAGS_TX_ALIGN) {
-			pDesc->pTDInfo->buf = pDevice->tx0_bufs + (i)*PKT_BUF_SZ;
-			pDesc->pTDInfo->buf_dma = pDevice->tx_bufs_dma0 + (i)*PKT_BUF_SZ;
+			pDesc->td_info->buf = pDevice->tx0_bufs + (i)*PKT_BUF_SZ;
+			pDesc->td_info->buf_dma = pDevice->tx_bufs_dma0 + (i)*PKT_BUF_SZ;
 		}
 		pDesc->next = &(pDevice->apTD0Rings[(i+1) % pDevice->sOpts.nTxDescs[0]]);
 		pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
@@ -727,11 +727,11 @@ static void device_init_td1_ring(struct vnt_private *pDevice)
 	curr = pDevice->td1_pool_dma;
 	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++, curr += sizeof(STxDesc)) {
 		pDesc = &(pDevice->apTD1Rings[i]);
-		pDesc->pTDInfo = alloc_td_info();
+		pDesc->td_info = alloc_td_info();
 
 		if (pDevice->flags & DEVICE_FLAGS_TX_ALIGN) {
-			pDesc->pTDInfo->buf = pDevice->tx1_bufs + (i) * PKT_BUF_SZ;
-			pDesc->pTDInfo->buf_dma = pDevice->tx_bufs_dma1 + (i) * PKT_BUF_SZ;
+			pDesc->td_info->buf = pDevice->tx1_bufs + (i) * PKT_BUF_SZ;
+			pDesc->td_info->buf_dma = pDevice->tx_bufs_dma1 + (i) * PKT_BUF_SZ;
 		}
 		pDesc->next = &(pDevice->apTD1Rings[(i + 1) % pDevice->sOpts.nTxDescs[1]]);
 		pDesc->next_desc = cpu_to_le32(curr+sizeof(STxDesc));
@@ -748,10 +748,10 @@ static void device_free_td0_ring(struct vnt_private *pDevice)
 
 	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++) {
 		PSTxDesc        pDesc = &(pDevice->apTD0Rings[i]);
-		PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
+		struct vnt_td_info *pTDInfo = pDesc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
-		kfree(pDesc->pTDInfo);
+		kfree(pDesc->td_info);
 	}
 }
 
@@ -761,10 +761,10 @@ static void device_free_td1_ring(struct vnt_private *pDevice)
 
 	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++) {
 		PSTxDesc        pDesc = &(pDevice->apTD1Rings[i]);
-		PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
+		struct vnt_td_info *pTDInfo = pDesc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
-		kfree(pDesc->pTDInfo);
+		kfree(pDesc->td_info);
 	}
 }
 
@@ -839,7 +839,7 @@ static const u8 fallback_rate1[5][5] = {
 };
 
 static int vnt_int_report_rate(struct vnt_private *priv,
-			       PDEVICE_TD_INFO context, u8 tsr0, u8 tsr1)
+			       struct vnt_td_info *context, u8 tsr0, u8 tsr1)
 {
 	struct vnt_tx_fifo_head *fifo_head;
 	struct ieee80211_tx_info *info;
@@ -916,7 +916,7 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 
 		/* Only the status of first TD in the chain is correct */
 		if (pTD->td1.tcr & TCR_STP) {
-			if ((pTD->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB) != 0) {
+			if ((pTD->td_info->flags & TD_FLAGS_NETIF_SKB) != 0) {
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
 						pr_debug(" Tx[%d] OK but has error. tsr1[%02X] tsr0[%02X]\n",
@@ -930,13 +930,13 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 			}
 
 			if (byTsr1 & TSR1_TERR) {
-				if ((pTD->pTDInfo->byFlags & TD_FLAGS_PRIV_SKB) != 0) {
+				if ((pTD->td_info->flags & TD_FLAGS_PRIV_SKB) != 0) {
 					pr_debug(" Tx[%d] fail has error. tsr1[%02X] tsr0[%02X]\n",
 						 (int)uIdx, byTsr1, byTsr0);
 				}
 			}
 
-			vnt_int_report_rate(pDevice, pTD->pTDInfo, byTsr0, byTsr1);
+			vnt_int_report_rate(pDevice, pTD->td_info, byTsr0, byTsr1);
 
 			device_free_tx_buf(pDevice, pTD);
 			pDevice->iTDUsed[uIdx]--;
@@ -960,14 +960,14 @@ static void device_error(struct vnt_private *pDevice, unsigned short status)
 
 static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 {
-	PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
+	struct vnt_td_info *pTDInfo = pDesc->td_info;
 	struct sk_buff *skb = pTDInfo->skb;
 
 	if (skb)
 		ieee80211_tx_status_irqsafe(pDevice->hw, skb);
 
 	pTDInfo->skb = NULL;
-	pTDInfo->byFlags = 0;
+	pTDInfo->flags = 0;
 }
 
 static void vnt_check_bb_vga(struct vnt_private *priv)
@@ -1176,10 +1176,10 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td->td1.tcr = 0;
 
-	head_td->pTDInfo->skb = skb;
+	head_td->td_info->skb = skb;
 
 	if (dma_idx == TYPE_AC0DMA)
-		head_td->pTDInfo->byFlags = TD_FLAGS_NETIF_SKB;
+		head_td->td_info->flags = TD_FLAGS_NETIF_SKB;
 
 	priv->apCurrTD[dma_idx] = head_td->next;
 
@@ -1193,16 +1193,16 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	/* Set TSR1 & ReqCount in TxDescHead */
 	head_td->td1.tcr |= (TCR_STP | TCR_EDP | EDMSDU);
-	head_td->td1.req_count = cpu_to_le16(head_td->pTDInfo->dwReqCount);
+	head_td->td1.req_count = cpu_to_le16(head_td->td_info->req_count);
 
-	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->buf_dma);
+	head_td->buff_addr = cpu_to_le32(head_td->td_info->buf_dma);
 
 	/* Poll Transmit the adapter */
 	wmb();
 	head_td->td0.owner = OWNED_BY_NIC;
 	wmb(); /* second memory barrier */
 
-	if (head_td->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)
+	if (head_td->td_info->flags & TD_FLAGS_NETIF_SKB)
 		MACvTransmitAC0(priv->PortOffset);
 	else
 		MACvTransmit0(priv->PortOffset);
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index c918248..8d0ae80 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -1030,7 +1030,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 		  unsigned int uDMAIdx, PSTxDesc pHeadTD,
 		  unsigned int is_pspoll)
 {
-	PDEVICE_TD_INFO td_info = pHeadTD->pTDInfo;
+	struct vnt_td_info *td_info = pHeadTD->td_info;
 	struct sk_buff *skb = td_info->skb;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
@@ -1192,7 +1192,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 	hdr->duration_id = uDuration;
 
 	cbReqCount = cbHeaderLength + uPadding + skb->len;
-	pbyBuffer = (unsigned char *)pHeadTD->pTDInfo->buf;
+	pbyBuffer = (unsigned char *)pHeadTD->td_info->buf;
 	uLength = cbHeaderLength + uPadding;
 
 	/* Copy the Packet into a tx Buffer */
@@ -1200,7 +1200,7 @@ s_cbFillTxBufHead(struct vnt_private *pDevice, unsigned char byPktType,
 
 	ptdCurr = (PSTxDesc)pHeadTD;
 
-	ptdCurr->pTDInfo->dwReqCount = (u16)cbReqCount;
+	ptdCurr->td_info->req_count = (u16)cbReqCount;
 
 	return cbHeaderLength;
 }
@@ -1275,7 +1275,7 @@ static void vnt_fill_txkey(struct ieee80211_hdr *hdr, u8 *key_buffer,
 int vnt_generate_fifo_header(struct vnt_private *priv, u32 dma_idx,
 			     PSTxDesc head_td, struct sk_buff *skb)
 {
-	PDEVICE_TD_INFO td_info = head_td->pTDInfo;
+	struct vnt_td_info *td_info = head_td->td_info;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *tx_rate = &info->control.rates[0];
 	struct ieee80211_rate *rate;
-- 
2.5.0

