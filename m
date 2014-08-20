Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45616 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaHTVcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Aug 2014 17:32:02 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so8398476wgh.22
        for <linux-wireless@vger.kernel.org>; Wed, 20 Aug 2014 14:32:01 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: rxtx.c change BBvCalculateParameter to function vnt_get_phy_field
Date: Wed, 20 Aug 2014 22:30:29 +0100
Message-Id: <1408570231-10320-4-git-send-email-tvboxspy@gmail.com> (sfid-20140820_233211_700847_79EDF8A8)
In-Reply-To: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
References: <1408570231-10320-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing wLen and pointing to correct member.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/rxtx.c | 151 ++++++++++++++++++------------------------
 1 file changed, 65 insertions(+), 86 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index 635e88c..04cf9e9 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -673,7 +673,6 @@ s_uFillDataHead(
 	unsigned short wCurrentRate
 )
 {
-	unsigned short wLen = 0x0000;
 
 	if (pTxDataHead == NULL)
 		return 0;
@@ -682,15 +681,14 @@ s_uFillDataHead(
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (byFBOption == AUTO_FB_NONE) {
 			PSTxDataHead_g pBuf = (PSTxDataHead_g)pTxDataHead;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
-);
-			pBuf->wTransmitLength_a = cpu_to_le16(wLen);
-			BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
-);
-			pBuf->wTransmitLength_b = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
+					  byPktType, &pBuf->a);
+
+			vnt_get_phy_field(pDevice, cbFrameLength,
+					  pDevice->byTopCCKBasicRate,
+					  PK_TYPE_11B, &pBuf->b);
+
 			//Get Duration and TimeStamp
 			pBuf->wDuration_a = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength,
 											   byPktType, wCurrentRate, bNeedAck, uFragIdx,
@@ -708,15 +706,13 @@ s_uFillDataHead(
 		} else {
 			// Auto Fallback
 			PSTxDataHead_g_FB pBuf = (PSTxDataHead_g_FB)pTxDataHead;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
-);
-			pBuf->wTransmitLength_a = cpu_to_le16(wLen);
-			BBvCalculateParameter(pDevice, cbFrameLength, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
-);
-			pBuf->wTransmitLength_b = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
+					  byPktType, &pBuf->a);
+
+			vnt_get_phy_field(pDevice, cbFrameLength,
+					  pDevice->byTopCCKBasicRate,
+					  PK_TYPE_11B, &pBuf->b);
 			//Get Duration and TimeStamp
 			pBuf->wDuration_a = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
 											   wCurrentRate, bNeedAck, uFragIdx, cbLastFragmentSize, uMACfragNum, byFBOption)); //1: 2.4GHz
@@ -736,11 +732,10 @@ s_uFillDataHead(
 		if ((byFBOption != AUTO_FB_NONE)) {
 			// Auto Fallback
 			PSTxDataHead_a_FB pBuf = (PSTxDataHead_a_FB)pTxDataHead;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
-);
-			pBuf->wTransmitLength = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
+					  byPktType, &pBuf->a);
+
 			//Get Duration and TimeStampOff
 
 			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
@@ -753,11 +748,9 @@ s_uFillDataHead(
 			return pBuf->wDuration;
 		} else {
 			PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
-);
-			pBuf->wTransmitLength = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
+					  byPktType, &pBuf->ab);
 			//Get Duration and TimeStampOff
 
 			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_A, cbFrameLength, byPktType,
@@ -770,11 +763,9 @@ s_uFillDataHead(
 		}
 	} else {
 		PSTxDataHead_ab pBuf = (PSTxDataHead_ab)pTxDataHead;
-		//Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, cbFrameLength, wCurrentRate, byPktType,
-				      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
-);
-		pBuf->wTransmitLength = cpu_to_le16(wLen);
+		/* Get SignalField, ServiceField & Length */
+		vnt_get_phy_field(pDevice, cbFrameLength, wCurrentRate,
+				  byPktType, &pBuf->ab);
 		//Get Duration and TimeStampOff
 		pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetDataDuration(pDevice, DATADUR_B, cbFrameLength, byPktType,
 										 wCurrentRate, bNeedAck, uFragIdx,
@@ -801,7 +792,6 @@ s_vFillRTSHead(
 )
 {
 	unsigned int uRTSFrameLen = 20;
-	unsigned short wLen = 0x0000;
 
 	if (pvRTS == NULL)
 		return;
@@ -817,15 +807,14 @@ s_vFillRTSHead(
 	if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
 		if (byFBOption == AUTO_FB_NONE) {
 			PSRTS_g pBuf = (PSRTS_g)pvRTS;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
-);
-			pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-			BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
-);
-			pBuf->wTransmitLength_a = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, uRTSFrameLen,
+					  pDevice->byTopCCKBasicRate,
+					  PK_TYPE_11B, &pBuf->b);
+
+			vnt_get_phy_field(pDevice, uRTSFrameLen,
+					  pDevice->byTopOFDMBasicRate,
+					  byPktType, &pBuf->a);
 			//Get Duration
 			pBuf->wDuration_bb = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, PK_TYPE_11B, pDevice->byTopCCKBasicRate, bNeedAck, byFBOption));    //0:RTSDuration_bb, 1:2.4G, 1:CCKData
 			pBuf->wDuration_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3: 2.4G OFDMData
@@ -847,16 +836,14 @@ s_vFillRTSHead(
 
 		} else {
 			PSRTS_g_FB pBuf = (PSRTS_g_FB)pvRTS;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
-);
-			pBuf->wTransmitLength_b = cpu_to_le16(wLen);
-			BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_a), (unsigned char *)&(pBuf->bySignalField_a)
-);
-			pBuf->wTransmitLength_a = cpu_to_le16(wLen);
-
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, uRTSFrameLen,
+					  pDevice->byTopCCKBasicRate,
+					  PK_TYPE_11B, &pBuf->b);
+
+			vnt_get_phy_field(pDevice, uRTSFrameLen,
+					  pDevice->byTopOFDMBasicRate,
+					  byPktType, &pBuf->a);
 			//Get Duration
 			pBuf->wDuration_bb = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, PK_TYPE_11B, pDevice->byTopCCKBasicRate, bNeedAck, byFBOption));    //0:RTSDuration_bb, 1:2.4G, 1:CCKData
 			pBuf->wDuration_aa = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //2:RTSDuration_aa, 1:2.4G, 2,3:2.4G OFDMData
@@ -885,11 +872,10 @@ s_vFillRTSHead(
 	} else if (byPktType == PK_TYPE_11A) {
 		if (byFBOption == AUTO_FB_NONE) {
 			PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
-);
-			pBuf->wTransmitLength = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, uRTSFrameLen,
+					  pDevice->byTopOFDMBasicRate,
+					  byPktType, &pBuf->ab);
 			//Get Duration
 			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
 			pBuf->Data.wDurationID = pBuf->wDuration;
@@ -910,11 +896,10 @@ s_vFillRTSHead(
 
 		} else {
 			PSRTS_a_FB pBuf = (PSRTS_a_FB)pvRTS;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopOFDMBasicRate, byPktType,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
-);
-			pBuf->wTransmitLength = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, uRTSFrameLen,
+					  pDevice->byTopOFDMBasicRate,
+					  byPktType, &pBuf->a);
 			//Get Duration
 			pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_aa, 0:5G, 0: 5G OFDMData
 			pBuf->wRTSDuration_f0 = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_AA_F0, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //5:RTSDuration_aa_f0, 0:5G, 0: 5G OFDMData
@@ -936,11 +921,10 @@ s_vFillRTSHead(
 		}
 	} else if (byPktType == PK_TYPE_11B) {
 		PSRTS_ab pBuf = (PSRTS_ab)pvRTS;
-		//Get SignalField,ServiceField,Length
-		BBvCalculateParameter(pDevice, uRTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-				      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField), (unsigned char *)&(pBuf->bySignalField)
-);
-		pBuf->wTransmitLength = cpu_to_le16(wLen);
+		/* Get SignalField, ServiceField & Length */
+		vnt_get_phy_field(pDevice, uRTSFrameLen,
+				  pDevice->byTopCCKBasicRate,
+				  PK_TYPE_11B, &pBuf->ab);
 		//Get Duration
 		pBuf->wDuration = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, RTSDUR_BB, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //0:RTSDuration_bb, 1:2.4G, 1:CCKData
 		pBuf->Data.wDurationID = pBuf->wDuration;
@@ -976,7 +960,6 @@ s_vFillCTSHead(
 )
 {
 	unsigned int uCTSFrameLen = 14;
-	unsigned short wLen = 0x0000;
 
 	if (pvCTS == NULL)
 		return;
@@ -991,12 +974,10 @@ s_vFillCTSHead(
 		if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA) {
 			// Auto Fall back
 			PSCTS_FB pBuf = (PSCTS_FB)pvCTS;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
-);
-
-			pBuf->wTransmitLength_b = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, uCTSFrameLen,
+					  pDevice->byTopCCKBasicRate,
+					  PK_TYPE_11B, &pBuf->b);
 
 			pBuf->wDuration_ba = (unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
 			pBuf->wDuration_ba += pDevice->wCTSDuration;
@@ -1017,11 +998,11 @@ s_vFillCTSHead(
 
 		} else { //if (byFBOption != AUTO_FB_NONE && uDMAIdx != TYPE_ATIMDMA && uDMAIdx != TYPE_BEACONDMA)
 			PSCTS pBuf = (PSCTS)pvCTS;
-			//Get SignalField,ServiceField,Length
-			BBvCalculateParameter(pDevice, uCTSFrameLen, pDevice->byTopCCKBasicRate, PK_TYPE_11B,
-					      (unsigned short *)&(wLen), (unsigned char *)&(pBuf->byServiceField_b), (unsigned char *)&(pBuf->bySignalField_b)
-);
-			pBuf->wTransmitLength_b = cpu_to_le16(wLen);
+			/* Get SignalField, ServiceField & Length */
+			vnt_get_phy_field(pDevice, uCTSFrameLen,
+					  pDevice->byTopCCKBasicRate,
+					  PK_TYPE_11B, &pBuf->b);
+
 			//Get CTSDuration_ba
 			pBuf->wDuration_ba = cpu_to_le16((unsigned short)s_uGetRTSCTSDuration(pDevice, CTSDUR_BA, cbFrameLength, byPktType, wCurrentRate, bNeedAck, byFBOption)); //3:CTSDuration_ba, 1:2.4G, 2,3:2.4G OFDM Data
 			pBuf->wDuration_ba += pDevice->wCTSDuration;
@@ -2358,7 +2339,6 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 	PSTxDataHead_ab  pTxDataHead = (PSTxDataHead_ab) (pbyBuffer + wTxBufSize);
 	PS802_11Header   pMACHeader;
 	unsigned short wCurrentRate;
-	unsigned short wLen = 0x0000;
 
 	memset(pTxBufHead, 0, wTxBufSize);
 
@@ -2387,10 +2367,9 @@ CMD_STATUS csBeacon_xmit(struct vnt_private *pDevice, PSTxMgmtPacket pPacket)
 											wCurrentRate, false, 0, 0, 1, AUTO_FB_NONE));
 	}
 
-	BBvCalculateParameter(pDevice, cbFrameSize, wCurrentRate, byPktType,
-			      (unsigned short *)&(wLen), (unsigned char *)&(pTxDataHead->byServiceField), (unsigned char *)&(pTxDataHead->bySignalField)
-);
-	pTxDataHead->wTransmitLength = cpu_to_le16(wLen);
+	vnt_get_phy_field(pDevice, cbFrameSize,
+			  wCurrentRate, byPktType, &pTxDataHead->ab);
+
 	//Get TimeStampOff
 	pTxDataHead->wTimeStampOff = cpu_to_le16(wTimeStampOff[pDevice->byPreambleType%2][wCurrentRate%MAX_RATE]);
 	cbHeaderSize = wTxBufSize + sizeof(STxDataHead_ab);
-- 
1.9.1

