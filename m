Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37853 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbbHNV7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:59:19 -0400
Received: by wibhh20 with SMTP id hh20so33920481wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:59:18 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/6] staging: vt6655: replaced typedef struct tagTDES1
Date: Fri, 14 Aug 2015 22:58:47 +0100
Message-Id: <1439589531-3059-2-git-send-email-tvboxspy@gmail.com> (sfid-20150814_235922_674180_D31BCDCC)
In-Reply-To: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
References: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Create struct vnt_tdes1 that replaces members
wReqCount -> req_count
byTCR -> tcr
byReserved -> reserved

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h        | 13 ++++++-------
 drivers/staging/vt6655/device_main.c |  9 ++++-----
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 00fa348..6efe825 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -234,12 +234,11 @@ struct vnt_tdes0 {
 #endif
 } __packed;
 
-typedef struct tagTDES1 {
-	volatile    __le16        wReqCount;
-	volatile    unsigned char byTCR;
-	volatile    unsigned char byReserved;
-} __attribute__ ((__packed__))
-STDES1;
+struct vnt_tdes1 {
+	volatile __le16 req_count;
+	volatile u8 tcr;
+	volatile u8 reserved;
+} __packed;
 
 typedef struct tagDEVICE_TD_INFO {
 	void *mic_hdr;
@@ -254,7 +253,7 @@ typedef struct tagDEVICE_TD_INFO {
 /* transmit descriptor */
 typedef struct tagSTxDesc {
 	volatile struct vnt_tdes0 td0;
-	volatile    STDES1  m_td1TD1;
+	volatile struct vnt_tdes1 td1;
 	volatile    __le32  buff_addr;
 	volatile    __le32  next_desc;
 	struct tagSTxDesc *next __aligned(8);
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 842e052..947e868 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -915,7 +915,7 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 		byTsr1 = pTD->td0.tsr1;
 
 		/* Only the status of first TD in the chain is correct */
-		if (pTD->m_td1TD1.byTCR & TCR_STP) {
+		if (pTD->td1.tcr & TCR_STP) {
 			if ((pTD->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB) != 0) {
 				if (!(byTsr1 & TSR1_TERR)) {
 					if (byTsr0 != 0) {
@@ -1174,7 +1174,7 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	head_td = priv->apCurrTD[dma_idx];
 
-	head_td->m_td1TD1.byTCR = 0;
+	head_td->td1.tcr = 0;
 
 	head_td->pTDInfo->skb = skb;
 
@@ -1192,9 +1192,8 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 	priv->bPWBitOn = false;
 
 	/* Set TSR1 & ReqCount in TxDescHead */
-	head_td->m_td1TD1.byTCR |= (TCR_STP | TCR_EDP | EDMSDU);
-	head_td->m_td1TD1.wReqCount =
-			cpu_to_le16((u16)head_td->pTDInfo->dwReqCount);
+	head_td->td1.tcr |= (TCR_STP | TCR_EDP | EDMSDU);
+	head_td->td1.req_count = cpu_to_le16((u16)head_td->pTDInfo->dwReqCount);
 
 	head_td->buff_addr = cpu_to_le32(head_td->pTDInfo->buf_dma);
 
-- 
2.5.0

