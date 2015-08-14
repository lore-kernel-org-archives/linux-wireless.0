Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:32831 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbbHNV7S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 17:59:18 -0400
Received: by wijp15 with SMTP id p15so31601515wij.0
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2015 14:59:16 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: desc.h replace typedef struct tagTDES0
Date: Fri, 14 Aug 2015 22:58:46 +0100
Message-Id: <1439589531-3059-1-git-send-email-tvboxspy@gmail.com> (sfid-20150814_235921_245741_A318E5FB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

create struct vnt_tdes0 replacing used members
byTSR0 -> tsr0
byTSR1 -> tsr1
f1Owner -> owner

Narrowing endian differences to inside structure.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c        |  4 ++--
 drivers/staging/vt6655/desc.h        | 36 +++++++++++++-----------------------
 drivers/staging/vt6655/device_main.c |  8 ++++----
 3 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index ae8fd7f..e3ff4ad 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -525,12 +525,12 @@ CARDvSafeResetTx(
 
 	for (uu = 0; uu < pDevice->sOpts.nTxDescs[0]; uu++) {
 		pCurrTD = &(pDevice->apTD0Rings[uu]);
-		pCurrTD->m_td0TD0.f1Owner = OWNED_BY_HOST;
+		pCurrTD->td0.owner = OWNED_BY_HOST;
 		/* init all Tx Packet pointer to NULL */
 	}
 	for (uu = 0; uu < pDevice->sOpts.nTxDescs[1]; uu++) {
 		pCurrTD = &(pDevice->apTD1Rings[uu]);
-		pCurrTD->m_td0TD0.f1Owner = OWNED_BY_HOST;
+		pCurrTD->td0.owner = OWNED_BY_HOST;
 		/* init all Tx Packet pointer to NULL */
 	}
 
diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index c916214..00fa348 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -216,33 +216,23 @@ typedef struct tagSRxDesc {
 SRxDesc, *PSRxDesc;
 typedef const SRxDesc *PCSRxDesc;
 
+struct vnt_tdes0 {
+	volatile u8 tsr0;
+	volatile u8 tsr1;
 #ifdef __BIG_ENDIAN
-
-typedef struct tagTDES0 {
-	volatile    unsigned char byTSR0;
-	volatile    unsigned char byTSR1;
 	union {
-		volatile u16    f15Txtime;
+		volatile u16 f15_txtime;
 		struct {
-			volatile u8 f8Reserved1;
-			volatile u8 f1Owner:1;
-			volatile u8 f7Reserved:7;
-		} __attribute__ ((__packed__));
-	} __attribute__ ((__packed__));
-} __attribute__ ((__packed__))
-STDES0, PSTDES0;
-
+			volatile u8 f8_reserved;
+			volatile u8 owner:1;
+			volatile u8 f7_reserved:7;
+		} __packed;
+	} __packed;
 #else
-
-typedef struct tagTDES0 {
-	volatile    unsigned char byTSR0;
-	volatile    unsigned char byTSR1;
-	volatile    unsigned short f15Txtime:15;
-	volatile    unsigned short f1Owner:1;
-} __attribute__ ((__packed__))
-STDES0;
-
+	volatile u16 f15_txtime:15;
+	volatile u16 owner:1;
 #endif
+} __packed;
 
 typedef struct tagTDES1 {
 	volatile    __le16        wReqCount;
@@ -263,7 +253,7 @@ typedef struct tagDEVICE_TD_INFO {
 
 /* transmit descriptor */
 typedef struct tagSTxDesc {
-	volatile    STDES0  m_td0TD0;
+	volatile struct vnt_tdes0 td0;
 	volatile    STDES1  m_td1TD1;
 	volatile    __le32  buff_addr;
 	volatile    __le32  next_desc;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index b74af8d..842e052 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -906,13 +906,13 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 	unsigned char byTsr1;
 
 	for (pTD = pDevice->apTailTD[uIdx]; pDevice->iTDUsed[uIdx] > 0; pTD = pTD->next) {
-		if (pTD->m_td0TD0.f1Owner == OWNED_BY_NIC)
+		if (pTD->td0.owner == OWNED_BY_NIC)
 			break;
 		if (works++ > 15)
 			break;
 
-		byTsr0 = pTD->m_td0TD0.byTSR0;
-		byTsr1 = pTD->m_td0TD0.byTSR1;
+		byTsr0 = pTD->td0.tsr0;
+		byTsr1 = pTD->td0.tsr1;
 
 		/* Only the status of first TD in the chain is correct */
 		if (pTD->m_td1TD1.byTCR & TCR_STP) {
@@ -1200,7 +1200,7 @@ static int vnt_tx_packet(struct vnt_private *priv, struct sk_buff *skb)
 
 	/* Poll Transmit the adapter */
 	wmb();
-	head_td->m_td0TD0.f1Owner = OWNED_BY_NIC;
+	head_td->td0.owner = OWNED_BY_NIC;
 	wmb(); /* second memory barrier */
 
 	if (head_td->pTDInfo->byFlags & TD_FLAGS_NETIF_SKB)
-- 
2.5.0

