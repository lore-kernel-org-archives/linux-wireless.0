Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54323 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaHITQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 15:16:42 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so2484566wib.16
        for <linux-wireless@vger.kernel.org>; Sat, 09 Aug 2014 12:16:41 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH] staging: vt6655: rxtx: Replace typedef struct tagSMICHDRHead
Date: Sat,  9 Aug 2014 20:15:56 +0100
Message-Id: <1407611756-5022-1-git-send-email-tvboxspy@gmail.com> (sfid-20140809_211738_025726_4257C301)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With struct vnt_mic_hdr replacing pointer assigments in
s_vFillTxKey.

The size of new struture is the same as old with packing

Create the struture rxtx.h where it is only used.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/desc.h | 11 ------
 drivers/staging/vt6655/rxtx.c | 88 +++++++++++++++++++++----------------------
 drivers/staging/vt6655/rxtx.h | 17 +++++++++
 3 files changed, 60 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/vt6655/desc.h b/drivers/staging/vt6655/desc.h
index 05efa4e..d3c9b0c 100644
--- a/drivers/staging/vt6655/desc.h
+++ b/drivers/staging/vt6655/desc.h
@@ -550,17 +550,6 @@ typedef struct tagSTxDataHead_a_FB {
 STxDataHead_a_FB, *PSTxDataHead_a_FB;
 typedef const STxDataHead_a_FB *PCSTxDataHead_a_FB;
 
-//
-// MICHDR data header
-//
-typedef struct tagSMICHDRHead {
-	u32 adwHDR0[4];
-	u32 adwHDR1[4];
-	u32 adwHDR2[4];
-} __attribute__ ((__packed__))
-SMICHDRHead, *PSMICHDRHead;
-typedef const SMICHDRHead *PCSMICHDRHead;
-
 typedef struct tagSBEACONCtl {
 	u32 BufReady:1;
 	u32 TSF:15;
diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 0d45aa0..0866d9f 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -196,9 +196,9 @@ s_vFillTxKey(
 	unsigned char *pMICHDR
 )
 {
+	struct vnt_mic_hdr *mic_hdr = (struct vnt_mic_hdr *)pMICHDR;
 	unsigned long *pdwIV = (unsigned long *)pbyIVHead;
 	unsigned long *pdwExtIV = (unsigned long *)((unsigned char *)pbyIVHead+4);
-	unsigned short wValue;
 	PS802_11Header  pMACHeader = (PS802_11Header)pbyHdrBuf;
 	unsigned long dwRevIVCounter;
 	unsigned char byKeyIndex = 0;
@@ -262,40 +262,38 @@ s_vFillTxKey(
 		//Append IV&ExtIV after Mac Header
 		*pdwExtIV = cpu_to_le32(pTransmitKey->dwTSC47_16);
 
-		//Fill MICHDR0
-		*pMICHDR = 0x59;
-		*((unsigned char *)(pMICHDR+1)) = 0; // TxPriority
-		memcpy(pMICHDR+2, &(pMACHeader->abyAddr2[0]), 6);
-		*((unsigned char *)(pMICHDR+8)) = HIBYTE(HIWORD(pTransmitKey->dwTSC47_16));
-		*((unsigned char *)(pMICHDR+9)) = LOBYTE(HIWORD(pTransmitKey->dwTSC47_16));
-		*((unsigned char *)(pMICHDR+10)) = HIBYTE(LOWORD(pTransmitKey->dwTSC47_16));
-		*((unsigned char *)(pMICHDR+11)) = LOBYTE(LOWORD(pTransmitKey->dwTSC47_16));
-		*((unsigned char *)(pMICHDR+12)) = HIBYTE(pTransmitKey->wTSC15_0);
-		*((unsigned char *)(pMICHDR+13)) = LOBYTE(pTransmitKey->wTSC15_0);
-		*((unsigned char *)(pMICHDR+14)) = HIBYTE(wPayloadLen);
-		*((unsigned char *)(pMICHDR+15)) = LOBYTE(wPayloadLen);
-
-		//Fill MICHDR1
-		*((unsigned char *)(pMICHDR+16)) = 0; // HLEN[15:8]
+		/* MICHDR0 */
+		mic_hdr->id = 0x59;
+		mic_hdr->tx_priority = 0;
+		memcpy(mic_hdr->mic_addr2, pMACHeader->abyAddr2, ETH_ALEN);
+
+		/* ccmp pn big endian order */
+		mic_hdr->ccmp_pn[0] = (u8)(pTransmitKey->dwTSC47_16 >> 24);
+		mic_hdr->ccmp_pn[1] = (u8)(pTransmitKey->dwTSC47_16 >> 16);
+		mic_hdr->ccmp_pn[2] = (u8)(pTransmitKey->dwTSC47_16 >> 8);
+		mic_hdr->ccmp_pn[3] = (u8)pTransmitKey->dwTSC47_16;
+		mic_hdr->ccmp_pn[4] = (u8)(pTransmitKey->wTSC15_0 >> 8);
+		mic_hdr->ccmp_pn[5] = (u8)pTransmitKey->wTSC15_0;
+
+		/* MICHDR1 */
+		mic_hdr->payload_len = cpu_to_be16(wPayloadLen);
+
 		if (pDevice->bLongHeader)
-			*((unsigned char *)(pMICHDR+17)) = 28; // HLEN[7:0]
+			mic_hdr->hlen = cpu_to_be16(28);
 		else
-			*((unsigned char *)(pMICHDR+17)) = 22; // HLEN[7:0]
-
-		wValue = cpu_to_le16(pMACHeader->wFrameCtl & 0xC78F);
-		memcpy(pMICHDR+18, (unsigned char *)&wValue, 2); // MSKFRACTL
-		memcpy(pMICHDR+20, &(pMACHeader->abyAddr1[0]), 6);
-		memcpy(pMICHDR+26, &(pMACHeader->abyAddr2[0]), 6);
-
-		//Fill MICHDR2
-		memcpy(pMICHDR+32, &(pMACHeader->abyAddr3[0]), 6);
-		wValue = pMACHeader->wSeqCtl;
-		wValue &= 0x000F;
-		wValue = cpu_to_le16(wValue);
-		memcpy(pMICHDR+38, (unsigned char *)&wValue, 2); // MSKSEQCTL
-		if (pDevice->bLongHeader)
-			memcpy(pMICHDR+40, &(pMACHeader->abyAddr4[0]), 6);
+			mic_hdr->hlen = cpu_to_be16(22);
 
+		memcpy(mic_hdr->addr1, pMACHeader->abyAddr1, ETH_ALEN);
+		memcpy(mic_hdr->addr2, pMACHeader->abyAddr2, ETH_ALEN);
+
+		/* MICHDR2 */
+		memcpy(mic_hdr->addr3, pMACHeader->abyAddr3, ETH_ALEN);
+		mic_hdr->frame_control =
+				cpu_to_le16(pMACHeader->wFrameCtl & 0xc78f);
+		mic_hdr->seq_ctrl = cpu_to_le16(pMACHeader->wSeqCtl & 0xf);
+
+		if (pDevice->bLongHeader)
+			memcpy(mic_hdr->addr4, pMACHeader->abyAddr4, ETH_ALEN);
 	}
 }
 
@@ -1252,7 +1250,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 	PSTxBufHead    psTxBufHd = (PSTxBufHead) pbyTxBufferAddr;
 	unsigned int cbHeaderLength = 0;
 	void *pvRrvTime;
-	PSMICHDRHead   pMICHDR;
+	struct vnt_mic_hdr *pMICHDR;
 	void *pvRTS;
 	void *pvCTS;
 	void *pvTxDataHd;
@@ -1297,7 +1295,7 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 		if (pTransmitKey->byCipherSuite == KEY_CTL_CCMP) {
 			cbIVlen = 8;//RSN Header
 			cbICVlen = 8;//MIC
-			cbMICHDR = sizeof(SMICHDRHead);
+			cbMICHDR = sizeof(struct vnt_mic_hdr);
 		}
 		if (pDevice->byLocalID > REV_ID_VT3253_A1) {
 			//MAC Header should be padding 0 to DW alignment.
@@ -1333,14 +1331,14 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 		if (byFBOption == AUTO_FB_NONE) {
 			if (bRTS == true) {//RTS_need
 				pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
 				pvRTS = (PSRTS_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
 				pvCTS = NULL;
 				pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g));
 				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g) + sizeof(STxDataHead_g);
 			} else { //RTS_needless
 				pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
 				pvRTS = NULL;
 				pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
 				pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS));
@@ -1350,14 +1348,14 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 			// Auto Fall Back
 			if (bRTS == true) {//RTS_need
 				pvRrvTime = (PSRrvTime_gRTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS));
 				pvRTS = (PSRTS_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR);
 				pvCTS = NULL;
 				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB));
 				cbHeaderLength = wTxBufSize + sizeof(SRrvTime_gRTS) + cbMICHDR + sizeof(SRTS_g_FB) + sizeof(STxDataHead_g_FB);
 			} else { //RTS_needless
 				pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
 				pvRTS = NULL;
 				pvCTS = (PSCTS_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
 				pvTxDataHd = (PSTxDataHead_g_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS_FB));
@@ -1369,14 +1367,14 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 		if (byFBOption == AUTO_FB_NONE) {
 			if (bRTS == true) {
 				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
 				pvRTS = (PSRTS_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
 				pvCTS = NULL;
 				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab));
 				cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_ab) + sizeof(STxDataHead_ab);
 			} else { //RTS_needless, need MICHDR
 				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
 				pvRTS = NULL;
 				pvCTS = NULL;
 				pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
@@ -1386,14 +1384,14 @@ s_cbFillTxBufHead(PSDevice pDevice, unsigned char byPktType, unsigned char *pbyT
 			// Auto Fall Back
 			if (bRTS == true) {//RTS_need
 				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
 				pvRTS = (PSRTS_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
 				pvCTS = NULL;
 				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB));
 				cbHeaderLength = wTxBufSize + sizeof(PSRrvTime_ab) + cbMICHDR + sizeof(SRTS_a_FB) + sizeof(STxDataHead_a_FB);
 			} else { //RTS_needless
 				pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-				pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+				pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
 				pvRTS = NULL;
 				pvCTS = NULL;
 				pvTxDataHd = (PSTxDataHead_a_FB) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
@@ -2656,7 +2654,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 		} else if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
 			cbIVlen = 8;//RSN Header
 			cbICVlen = 8;//MIC
-			cbMICHDR = sizeof(SMICHDRHead);
+			cbMICHDR = sizeof(struct vnt_mic_hdr);
 			pTxBufHead->wFragCtl |= FRAGCTL_AES;
 			pDevice->bAES = true;
 		}
@@ -2676,7 +2674,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {//802.11g packet
 
 		pvRrvTime = (PSRrvTime_gCTS) (pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
+		pMICHDR = (struct vnt_mic_hdr *)(pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS));
 		pvRTS = NULL;
 		pvCTS = (PSCTS) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR);
 		pvTxDataHd = (PSTxDataHead_g) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_gCTS) + cbMICHDR + sizeof(SCTS));
@@ -2685,7 +2683,7 @@ vDMA0_tx_80211(PSDevice  pDevice, struct sk_buff *skb, unsigned char *pbMPDU, un
 	} else {//802.11a/b packet
 
 		pvRrvTime = (PSRrvTime_ab) (pbyTxBufferAddr + wTxBufSize);
-		pMICHDR = (PSMICHDRHead) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
+		pMICHDR = (struct vnt_mic_hdr *) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab));
 		pvRTS = NULL;
 		pvCTS = NULL;
 		pvTxDataHd = (PSTxDataHead_ab) (pbyTxBufferAddr + wTxBufSize + sizeof(SRrvTime_ab) + cbMICHDR);
diff --git a/drivers/staging/vt6655/rxtx.h b/drivers/staging/vt6655/rxtx.h
index 601bedb..a9a8ede 100644
--- a/drivers/staging/vt6655/rxtx.h
+++ b/drivers/staging/vt6655/rxtx.h
@@ -39,6 +39,23 @@
 
 /*---------------------  Export Functions  --------------------------*/
 
+/* MIC HDR data header */
+struct vnt_mic_hdr {
+	u8 id;
+	u8 tx_priority;
+	u8 mic_addr2[ETH_ALEN];
+	u8 ccmp_pn[6];
+	__be16 payload_len;
+	__be16 hlen;
+	__le16 frame_control;
+	u8 addr1[ETH_ALEN];
+	u8 addr2[ETH_ALEN];
+	u8 addr3[ETH_ALEN];
+	__le16 seq_ctrl;
+	u8 addr4[ETH_ALEN];
+	u16 packing; /* packing to 48 bytes */
+} __packed;
+
 void
 vGenerateMACHeader(
 	PSDevice         pDevice,
-- 
1.9.1

