Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37244 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaKEVJx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2014 16:09:53 -0500
Received: by mail-wi0-f178.google.com with SMTP id bs8so1254255wib.11
        for <linux-wireless@vger.kernel.org>; Wed, 05 Nov 2014 13:09:52 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/11] staging: vt6655 baseband.c camel case replace pDevice -> priv
Date: Wed,  5 Nov 2014 21:08:59 +0000
Message-Id: <1415221739-3045-11-git-send-email-tvboxspy@gmail.com> (sfid-20141105_221320_714671_80E71957)
In-Reply-To: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
References: <1415221739-3045-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for struct vnt_private

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 472 +++++++++++++++++++-------------------
 1 file changed, 236 insertions(+), 236 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 30dd59d..32000d2 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1702,39 +1702,39 @@ static const unsigned short awcFrameTime[MAX_RATE] = {
 
 static
 unsigned long
-s_ulGetRatio(struct vnt_private *pDevice);
+s_ulGetRatio(struct vnt_private *priv);
 
 static
 void
 s_vChangeAntenna(
-	struct vnt_private *pDevice
+	struct vnt_private *priv
 );
 
 static
 void
 s_vChangeAntenna(
-	struct vnt_private *pDevice
+	struct vnt_private *priv
 )
 {
-	if (pDevice->dwRxAntennaSel == 0) {
-		pDevice->dwRxAntennaSel = 1;
-		if (pDevice->bTxRxAntInv == true)
-			BBvSetRxAntennaMode(pDevice->PortOffset, ANT_A);
+	if (priv->dwRxAntennaSel == 0) {
+		priv->dwRxAntennaSel = 1;
+		if (priv->bTxRxAntInv == true)
+			BBvSetRxAntennaMode(priv->PortOffset, ANT_A);
 		else
-			BBvSetRxAntennaMode(pDevice->PortOffset, ANT_B);
+			BBvSetRxAntennaMode(priv->PortOffset, ANT_B);
 	} else {
-		pDevice->dwRxAntennaSel = 0;
-		if (pDevice->bTxRxAntInv == true)
-			BBvSetRxAntennaMode(pDevice->PortOffset, ANT_B);
+		priv->dwRxAntennaSel = 0;
+		if (priv->bTxRxAntInv == true)
+			BBvSetRxAntennaMode(priv->PortOffset, ANT_B);
 		else
-			BBvSetRxAntennaMode(pDevice->PortOffset, ANT_A);
+			BBvSetRxAntennaMode(priv->PortOffset, ANT_A);
 	}
-	if (pDevice->dwTxAntennaSel == 0) {
-		pDevice->dwTxAntennaSel = 1;
-		BBvSetTxAntennaMode(pDevice->PortOffset, ANT_B);
+	if (priv->dwTxAntennaSel == 0) {
+		priv->dwTxAntennaSel = 1;
+		BBvSetTxAntennaMode(priv->PortOffset, ANT_B);
 	} else {
-		pDevice->dwTxAntennaSel = 0;
-		BBvSetTxAntennaMode(pDevice->PortOffset, ANT_A);
+		priv->dwTxAntennaSel = 0;
+		BBvSetTxAntennaMode(priv->PortOffset, ANT_A);
 	}
 }
 
@@ -2045,13 +2045,13 @@ bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned c
  *
  */
 
-bool BBbVT3253Init(struct vnt_private *pDevice)
+bool BBbVT3253Init(struct vnt_private *priv)
 {
 	bool bResult = true;
 	int        ii;
-	void __iomem *dwIoBase = pDevice->PortOffset;
-	unsigned char byRFType = pDevice->byRFType;
-	unsigned char byLocalID = pDevice->byLocalID;
+	void __iomem *dwIoBase = priv->PortOffset;
+	unsigned char byRFType = priv->byRFType;
+	unsigned char byLocalID = priv->byLocalID;
 
 	if (byRFType == RF_RFMD2959) {
 		if (byLocalID <= REV_ID_VT3253_A1) {
@@ -2068,14 +2068,14 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 			VNSvOutPortD(dwIoBase + MAC_REG_ITRTMSET, 0x23);
 			MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT(0));
 		}
-		pDevice->abyBBVGA[0] = 0x18;
-		pDevice->abyBBVGA[1] = 0x0A;
-		pDevice->abyBBVGA[2] = 0x0;
-		pDevice->abyBBVGA[3] = 0x0;
-		pDevice->ldBmThreshold[0] = -70;
-		pDevice->ldBmThreshold[1] = -50;
-		pDevice->ldBmThreshold[2] = 0;
-		pDevice->ldBmThreshold[3] = 0;
+		priv->abyBBVGA[0] = 0x18;
+		priv->abyBBVGA[1] = 0x0A;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -50;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
 	} else if ((byRFType == RF_AIROHA) || (byRFType == RF_AL2230S)) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
@@ -2083,14 +2083,14 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
-		pDevice->abyBBVGA[0] = 0x1C;
-		pDevice->abyBBVGA[1] = 0x10;
-		pDevice->abyBBVGA[2] = 0x0;
-		pDevice->abyBBVGA[3] = 0x0;
-		pDevice->ldBmThreshold[0] = -70;
-		pDevice->ldBmThreshold[1] = -48;
-		pDevice->ldBmThreshold[2] = 0;
-		pDevice->ldBmThreshold[3] = 0;
+		priv->abyBBVGA[0] = 0x1C;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
 	} else if (byRFType == RF_UW2451) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
@@ -2101,14 +2101,14 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 		VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23);
 		MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT(0));
 
-		pDevice->abyBBVGA[0] = 0x14;
-		pDevice->abyBBVGA[1] = 0x0A;
-		pDevice->abyBBVGA[2] = 0x0;
-		pDevice->abyBBVGA[3] = 0x0;
-		pDevice->ldBmThreshold[0] = -60;
-		pDevice->ldBmThreshold[1] = -50;
-		pDevice->ldBmThreshold[2] = 0;
-		pDevice->ldBmThreshold[3] = 0;
+		priv->abyBBVGA[0] = 0x14;
+		priv->abyBBVGA[1] = 0x0A;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -60;
+		priv->ldBmThreshold[1] = -50;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
 	} else if (byRFType == RF_UW2452) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
@@ -2134,14 +2134,14 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
-		pDevice->abyBBVGA[0] = 0x14;
-		pDevice->abyBBVGA[1] = 0x0A;
-		pDevice->abyBBVGA[2] = 0x0;
-		pDevice->abyBBVGA[3] = 0x0;
-		pDevice->ldBmThreshold[0] = -60;
-		pDevice->ldBmThreshold[1] = -50;
-		pDevice->ldBmThreshold[2] = 0;
-		pDevice->ldBmThreshold[3] = 0;
+		priv->abyBBVGA[0] = 0x14;
+		priv->abyBBVGA[1] = 0x0A;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -60;
+		priv->ldBmThreshold[1] = -50;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
 		/* }} RobertYu */
 
 	} else if (byRFType == RF_VT3226) {
@@ -2151,14 +2151,14 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
-		pDevice->abyBBVGA[0] = 0x1C;
-		pDevice->abyBBVGA[1] = 0x10;
-		pDevice->abyBBVGA[2] = 0x0;
-		pDevice->abyBBVGA[3] = 0x0;
-		pDevice->ldBmThreshold[0] = -70;
-		pDevice->ldBmThreshold[1] = -48;
-		pDevice->ldBmThreshold[2] = 0;
-		pDevice->ldBmThreshold[3] = 0;
+		priv->abyBBVGA[0] = 0x1C;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
 		/* Fix VT3226 DFC system timing issue */
 		MACvSetRFLE_LatchBase(dwIoBase);
 		/* {{ RobertYu: 20050104 */
@@ -2179,19 +2179,19 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
 			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
-		pDevice->abyBBVGA[0] = 0x1C;
-		pDevice->abyBBVGA[1] = 0x10;
-		pDevice->abyBBVGA[2] = 0x0;
-		pDevice->abyBBVGA[3] = 0x0;
-		pDevice->ldBmThreshold[0] = -70;
-		pDevice->ldBmThreshold[1] = -48;
-		pDevice->ldBmThreshold[2] = 0;
-		pDevice->ldBmThreshold[3] = 0;
+		priv->abyBBVGA[0] = 0x1C;
+		priv->abyBBVGA[1] = 0x10;
+		priv->abyBBVGA[2] = 0x0;
+		priv->abyBBVGA[3] = 0x0;
+		priv->ldBmThreshold[0] = -70;
+		priv->ldBmThreshold[1] = -48;
+		priv->ldBmThreshold[2] = 0;
+		priv->ldBmThreshold[3] = 0;
 		/* }} RobertYu */
 	} else {
 		/* No VGA Table now */
-		pDevice->bUpdateBBVGA = false;
-		pDevice->abyBBVGA[0] = 0x1C;
+		priv->bUpdateBBVGA = false;
+		priv->abyBBVGA[0] = 0x1C;
 	}
 
 	if (byLocalID > REV_ID_VT3253_A1) {
@@ -2207,7 +2207,7 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
  *
  * Parameters:
  *  In:
- *      pDevice     - Device Structure
+ *      priv     - Device Structure
  *  Out:
  *      none
  *
@@ -2215,42 +2215,42 @@ bool BBbVT3253Init(struct vnt_private *pDevice)
  *
  */
 void
-BBvSetShortSlotTime(struct vnt_private *pDevice)
+BBvSetShortSlotTime(struct vnt_private *priv)
 {
 	unsigned char byBBRxConf = 0;
 	unsigned char byBBVGA = 0;
 
-	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
+	BBbReadEmbedded(priv->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
 
-	if (pDevice->bShortSlotTime)
+	if (priv->bShortSlotTime)
 		byBBRxConf &= 0xDF; /* 1101 1111 */
 	else
 		byBBRxConf |= 0x20; /* 0010 0000 */
 
 	/* patch for 3253B0 Baseband with Cardbus module */
-	BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byBBVGA);
-	if (byBBVGA == pDevice->abyBBVGA[0])
+	BBbReadEmbedded(priv->PortOffset, 0xE7, &byBBVGA);
+	if (byBBVGA == priv->abyBBVGA[0])
 		byBBRxConf |= 0x20; /* 0010 0000 */
 
-	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf); /* CR10 */
+	BBbWriteEmbedded(priv->PortOffset, 0x0A, byBBRxConf); /* CR10 */
 }
 
-void BBvSetVGAGainOffset(struct vnt_private *pDevice, unsigned char byData)
+void BBvSetVGAGainOffset(struct vnt_private *priv, unsigned char byData)
 {
 	unsigned char byBBRxConf = 0;
 
-	BBbWriteEmbedded(pDevice->PortOffset, 0xE7, byData);
+	BBbWriteEmbedded(priv->PortOffset, 0xE7, byData);
 
-	BBbReadEmbedded(pDevice->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
+	BBbReadEmbedded(priv->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
 	/* patch for 3253B0 Baseband with Cardbus module */
-	if (byData == pDevice->abyBBVGA[0])
+	if (byData == priv->abyBBVGA[0])
 		byBBRxConf |= 0x20; /* 0010 0000 */
-	else if (pDevice->bShortSlotTime)
+	else if (priv->bShortSlotTime)
 		byBBRxConf &= 0xDF; /* 1101 1111 */
 	else
 		byBBRxConf |= 0x20; /* 0010 0000 */
-	pDevice->byBBVGACurrent = byData;
-	BBbWriteEmbedded(pDevice->PortOffset, 0x0A, byBBRxConf); /* CR10 */
+	priv->byBBVGACurrent = byData;
+	BBbWriteEmbedded(priv->PortOffset, 0x0A, byBBRxConf); /* CR10 */
 }
 
 /*
@@ -2323,7 +2323,7 @@ BBvPowerSaveModeOFF(void __iomem *dwIoBase)
  *
  * Parameters:
  *  In:
- *      pDevice          - Device Structure
+ *      priv          - Device Structure
  *      byAntennaMode    - Antenna Mode
  *  Out:
  *      none
@@ -2356,7 +2356,7 @@ BBvSetTxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
  *
  * Parameters:
  *  In:
- *      pDevice          - Device Structure
+ *      priv          - Device Structure
  *      byAntennaMode    - Antenna Mode
  *  Out:
  *      none
@@ -2388,7 +2388,7 @@ BBvSetRxAntennaMode(void __iomem *dwIoBase, unsigned char byAntennaMode)
  *
  * Parameters:
  *  In:
- *      pDevice          - Device Structure
+ *      priv          - Device Structure
  *  Out:
  *      none
  *
@@ -2411,94 +2411,94 @@ BBvExitDeepSleep(void __iomem *dwIoBase, unsigned char byLocalID)
 
 static
 unsigned long
-s_ulGetRatio(struct vnt_private *pDevice)
+s_ulGetRatio(struct vnt_private *priv)
 {
 	unsigned long ulRatio = 0;
 	unsigned long ulMaxPacket;
 	unsigned long ulPacketNum;
 
 	/* This is a thousand-ratio */
-	ulMaxPacket = pDevice->uNumSQ3[RATE_54M];
-	if (pDevice->uNumSQ3[RATE_54M] != 0) {
-		ulPacketNum = pDevice->uNumSQ3[RATE_54M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	ulMaxPacket = priv->uNumSQ3[RATE_54M];
+	if (priv->uNumSQ3[RATE_54M] != 0) {
+		ulPacketNum = priv->uNumSQ3[RATE_54M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_54M;
 	}
-	if (pDevice->uNumSQ3[RATE_48M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_48M] > ulMaxPacket) {
+		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_48M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_48M];
+		ulMaxPacket = priv->uNumSQ3[RATE_48M];
 	}
-	if (pDevice->uNumSQ3[RATE_36M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M] +
-			pDevice->uNumSQ3[RATE_36M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_36M] > ulMaxPacket) {
+		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
+			priv->uNumSQ3[RATE_36M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_36M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_36M];
+		ulMaxPacket = priv->uNumSQ3[RATE_36M];
 	}
-	if (pDevice->uNumSQ3[RATE_24M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M] +
-			pDevice->uNumSQ3[RATE_36M] + pDevice->uNumSQ3[RATE_24M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_24M] > ulMaxPacket) {
+		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
+			priv->uNumSQ3[RATE_36M] + priv->uNumSQ3[RATE_24M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_24M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_24M];
+		ulMaxPacket = priv->uNumSQ3[RATE_24M];
 	}
-	if (pDevice->uNumSQ3[RATE_18M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M] +
-			pDevice->uNumSQ3[RATE_36M] + pDevice->uNumSQ3[RATE_24M] +
-			pDevice->uNumSQ3[RATE_18M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_18M] > ulMaxPacket) {
+		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
+			priv->uNumSQ3[RATE_36M] + priv->uNumSQ3[RATE_24M] +
+			priv->uNumSQ3[RATE_18M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_18M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_18M];
+		ulMaxPacket = priv->uNumSQ3[RATE_18M];
 	}
-	if (pDevice->uNumSQ3[RATE_12M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uNumSQ3[RATE_54M] + pDevice->uNumSQ3[RATE_48M] +
-			pDevice->uNumSQ3[RATE_36M] + pDevice->uNumSQ3[RATE_24M] +
-			pDevice->uNumSQ3[RATE_18M] + pDevice->uNumSQ3[RATE_12M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_12M] > ulMaxPacket) {
+		ulPacketNum = priv->uNumSQ3[RATE_54M] + priv->uNumSQ3[RATE_48M] +
+			priv->uNumSQ3[RATE_36M] + priv->uNumSQ3[RATE_24M] +
+			priv->uNumSQ3[RATE_18M] + priv->uNumSQ3[RATE_12M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_12M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_12M];
+		ulMaxPacket = priv->uNumSQ3[RATE_12M];
 	}
-	if (pDevice->uNumSQ3[RATE_11M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M] -
-			pDevice->uNumSQ3[RATE_2M] - pDevice->uNumSQ3[RATE_5M] -
-			pDevice->uNumSQ3[RATE_6M] - pDevice->uNumSQ3[RATE_9M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_11M] > ulMaxPacket) {
+		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
+			priv->uNumSQ3[RATE_2M] - priv->uNumSQ3[RATE_5M] -
+			priv->uNumSQ3[RATE_6M] - priv->uNumSQ3[RATE_9M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_11M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_11M];
+		ulMaxPacket = priv->uNumSQ3[RATE_11M];
 	}
-	if (pDevice->uNumSQ3[RATE_9M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M] -
-			pDevice->uNumSQ3[RATE_2M] - pDevice->uNumSQ3[RATE_5M] -
-			pDevice->uNumSQ3[RATE_6M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_9M] > ulMaxPacket) {
+		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
+			priv->uNumSQ3[RATE_2M] - priv->uNumSQ3[RATE_5M] -
+			priv->uNumSQ3[RATE_6M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_9M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_9M];
+		ulMaxPacket = priv->uNumSQ3[RATE_9M];
 	}
-	if (pDevice->uNumSQ3[RATE_6M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M] -
-			pDevice->uNumSQ3[RATE_2M] - pDevice->uNumSQ3[RATE_5M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_6M] > ulMaxPacket) {
+		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
+			priv->uNumSQ3[RATE_2M] - priv->uNumSQ3[RATE_5M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_6M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_6M];
+		ulMaxPacket = priv->uNumSQ3[RATE_6M];
 	}
-	if (pDevice->uNumSQ3[RATE_5M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M] -
-			pDevice->uNumSQ3[RATE_2M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_5M] > ulMaxPacket) {
+		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M] -
+			priv->uNumSQ3[RATE_2M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_55M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_5M];
+		ulMaxPacket = priv->uNumSQ3[RATE_5M];
 	}
-	if (pDevice->uNumSQ3[RATE_2M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uDiversityCnt - pDevice->uNumSQ3[RATE_1M];
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_2M] > ulMaxPacket) {
+		ulPacketNum = priv->uDiversityCnt - priv->uNumSQ3[RATE_1M];
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_2M;
-		ulMaxPacket = pDevice->uNumSQ3[RATE_2M];
+		ulMaxPacket = priv->uNumSQ3[RATE_2M];
 	}
-	if (pDevice->uNumSQ3[RATE_1M] > ulMaxPacket) {
-		ulPacketNum = pDevice->uDiversityCnt;
-		ulRatio = (ulPacketNum * 1000 / pDevice->uDiversityCnt);
+	if (priv->uNumSQ3[RATE_1M] > ulMaxPacket) {
+		ulPacketNum = priv->uDiversityCnt;
+		ulRatio = (ulPacketNum * 1000 / priv->uDiversityCnt);
 		ulRatio += TOP_RATE_1M;
 	}
 
@@ -2506,13 +2506,13 @@ s_ulGetRatio(struct vnt_private *pDevice)
 }
 
 void
-BBvClearAntDivSQ3Value(struct vnt_private *pDevice)
+BBvClearAntDivSQ3Value(struct vnt_private *priv)
 {
 	unsigned int ii;
 
-	pDevice->uDiversityCnt = 0;
+	priv->uDiversityCnt = 0;
 	for (ii = 0; ii < MAX_RATE; ii++)
-		pDevice->uNumSQ3[ii] = 0;
+		priv->uNumSQ3[ii] = 0;
 }
 
 /*
@@ -2520,7 +2520,7 @@ BBvClearAntDivSQ3Value(struct vnt_private *pDevice)
  *
  * Parameters:
  *  In:
- *      pDevice          - Device Structure
+ *      priv          - Device Structure
  *      byRSR            - RSR from received packet
  *      bySQ3            - SQ3 value from received packet
  *  Out:
@@ -2530,75 +2530,75 @@ BBvClearAntDivSQ3Value(struct vnt_private *pDevice)
  *
  */
 
-void BBvAntennaDiversity(struct vnt_private *pDevice,
+void BBvAntennaDiversity(struct vnt_private *priv,
 			 unsigned char byRxRate, unsigned char bySQ3)
 {
-	if ((byRxRate >= MAX_RATE) || (pDevice->wAntDiversityMaxRate >= MAX_RATE))
+	if ((byRxRate >= MAX_RATE) || (priv->wAntDiversityMaxRate >= MAX_RATE))
 		return;
 
-	pDevice->uDiversityCnt++;
+	priv->uDiversityCnt++;
 
-	pDevice->uNumSQ3[byRxRate]++;
+	priv->uNumSQ3[byRxRate]++;
 
-	if (pDevice->byAntennaState == 0) {
-		if (pDevice->uDiversityCnt > pDevice->ulDiversityNValue) {
+	if (priv->byAntennaState == 0) {
+		if (priv->uDiversityCnt > priv->ulDiversityNValue) {
 			pr_debug("ulDiversityNValue=[%d],54M-[%d]\n",
-				 (int)pDevice->ulDiversityNValue,
-				 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate]);
+				 (int)priv->ulDiversityNValue,
+				 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate]);
 
-			if (pDevice->uNumSQ3[pDevice->wAntDiversityMaxRate] < pDevice->uDiversityCnt/2) {
-				pDevice->ulRatio_State0 = s_ulGetRatio(pDevice);
+			if (priv->uNumSQ3[priv->wAntDiversityMaxRate] < priv->uDiversityCnt/2) {
+				priv->ulRatio_State0 = s_ulGetRatio(priv);
 				pr_debug("SQ3_State0, rate = [%08x]\n",
-					 (int)pDevice->ulRatio_State0);
+					 (int)priv->ulRatio_State0);
 
-				if (pDevice->byTMax == 0)
+				if (priv->byTMax == 0)
 					return;
 				pr_debug("1.[%08x], uNumSQ3[%d]=%d, %d\n",
-					 (int)pDevice->ulRatio_State0,
-					 (int)pDevice->wAntDiversityMaxRate,
-					 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate],
-					 (int)pDevice->uDiversityCnt);
-
-				s_vChangeAntenna(pDevice);
-				pDevice->byAntennaState = 1;
-				del_timer(&pDevice->TimerSQ3Tmax3);
-				del_timer(&pDevice->TimerSQ3Tmax2);
-				pDevice->TimerSQ3Tmax1.expires =  RUN_AT(pDevice->byTMax * HZ);
-				add_timer(&pDevice->TimerSQ3Tmax1);
+					 (int)priv->ulRatio_State0,
+					 (int)priv->wAntDiversityMaxRate,
+					 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate],
+					 (int)priv->uDiversityCnt);
+
+				s_vChangeAntenna(priv);
+				priv->byAntennaState = 1;
+				del_timer(&priv->TimerSQ3Tmax3);
+				del_timer(&priv->TimerSQ3Tmax2);
+				priv->TimerSQ3Tmax1.expires =  RUN_AT(priv->byTMax * HZ);
+				add_timer(&priv->TimerSQ3Tmax1);
 
 			} else {
-				pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-				add_timer(&pDevice->TimerSQ3Tmax3);
+				priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
+				add_timer(&priv->TimerSQ3Tmax3);
 			}
-			BBvClearAntDivSQ3Value(pDevice);
+			BBvClearAntDivSQ3Value(priv);
 
 		}
 	} else { /* byAntennaState == 1 */
 
-		if (pDevice->uDiversityCnt > pDevice->ulDiversityMValue) {
-			del_timer(&pDevice->TimerSQ3Tmax1);
+		if (priv->uDiversityCnt > priv->ulDiversityMValue) {
+			del_timer(&priv->TimerSQ3Tmax1);
 
-			pDevice->ulRatio_State1 = s_ulGetRatio(pDevice);
+			priv->ulRatio_State1 = s_ulGetRatio(priv);
 			pr_debug("RX:SQ3_State1, rate0 = %08x,rate1 = %08x\n",
-				 (int)pDevice->ulRatio_State0,
-				 (int)pDevice->ulRatio_State1);
+				 (int)priv->ulRatio_State0,
+				 (int)priv->ulRatio_State1);
 
-			if (pDevice->ulRatio_State1 < pDevice->ulRatio_State0) {
+			if (priv->ulRatio_State1 < priv->ulRatio_State0) {
 				pr_debug("2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
-					 (int)pDevice->ulRatio_State0,
-					 (int)pDevice->ulRatio_State1,
-					 (int)pDevice->wAntDiversityMaxRate,
-					 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate],
-					 (int)pDevice->uDiversityCnt);
-
-				s_vChangeAntenna(pDevice);
-				pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-				pDevice->TimerSQ3Tmax2.expires =  RUN_AT(pDevice->byTMax2 * HZ);
-				add_timer(&pDevice->TimerSQ3Tmax3);
-				add_timer(&pDevice->TimerSQ3Tmax2);
+					 (int)priv->ulRatio_State0,
+					 (int)priv->ulRatio_State1,
+					 (int)priv->wAntDiversityMaxRate,
+					 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate],
+					 (int)priv->uDiversityCnt);
+
+				s_vChangeAntenna(priv);
+				priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
+				priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
+				add_timer(&priv->TimerSQ3Tmax3);
+				add_timer(&priv->TimerSQ3Tmax2);
 			}
-			pDevice->byAntennaState = 0;
-			BBvClearAntDivSQ3Value(pDevice);
+			priv->byAntennaState = 0;
+			BBvClearAntDivSQ3Value(priv);
 		}
 	} /* byAntennaState */
 }
@@ -2622,27 +2622,27 @@ TimerSQ3CallBack(
 	unsigned long data
 )
 {
-	struct vnt_private *pDevice = (struct vnt_private *)data;
+	struct vnt_private *priv = (struct vnt_private *)data;
 	unsigned long flags;
 
 	pr_debug("TimerSQ3CallBack...\n");
 
-	spin_lock_irqsave(&pDevice->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	pr_debug("3.[%08x][%08x], %d\n",
-		 (int)pDevice->ulRatio_State0, (int)pDevice->ulRatio_State1,
-		 (int)pDevice->uDiversityCnt);
+		 (int)priv->ulRatio_State0, (int)priv->ulRatio_State1,
+		 (int)priv->uDiversityCnt);
 
-	s_vChangeAntenna(pDevice);
-	pDevice->byAntennaState = 0;
-	BBvClearAntDivSQ3Value(pDevice);
+	s_vChangeAntenna(priv);
+	priv->byAntennaState = 0;
+	BBvClearAntDivSQ3Value(priv);
 
-	pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-	pDevice->TimerSQ3Tmax2.expires =  RUN_AT(pDevice->byTMax2 * HZ);
-	add_timer(&pDevice->TimerSQ3Tmax3);
-	add_timer(&pDevice->TimerSQ3Tmax2);
+	priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
+	priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
+	add_timer(&priv->TimerSQ3Tmax3);
+	add_timer(&priv->TimerSQ3Tmax2);
 
-	spin_unlock_irqrestore(&pDevice->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
 /*+
@@ -2668,43 +2668,43 @@ TimerState1CallBack(
 	unsigned long data
 )
 {
-	struct vnt_private *pDevice = (struct vnt_private *)data;
+	struct vnt_private *priv = (struct vnt_private *)data;
 	unsigned long flags;
 
 	pr_debug("TimerState1CallBack...\n");
 
-	spin_lock_irqsave(&pDevice->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	if (pDevice->uDiversityCnt < pDevice->ulDiversityMValue/100) {
-		s_vChangeAntenna(pDevice);
-		pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-		pDevice->TimerSQ3Tmax2.expires =  RUN_AT(pDevice->byTMax2 * HZ);
-		add_timer(&pDevice->TimerSQ3Tmax3);
-		add_timer(&pDevice->TimerSQ3Tmax2);
+	if (priv->uDiversityCnt < priv->ulDiversityMValue/100) {
+		s_vChangeAntenna(priv);
+		priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
+		priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
+		add_timer(&priv->TimerSQ3Tmax3);
+		add_timer(&priv->TimerSQ3Tmax2);
 	} else {
-		pDevice->ulRatio_State1 = s_ulGetRatio(pDevice);
+		priv->ulRatio_State1 = s_ulGetRatio(priv);
 		pr_debug("SQ3_State1, rate0 = %08x,rate1 = %08x\n",
-			 (int)pDevice->ulRatio_State0,
-			 (int)pDevice->ulRatio_State1);
+			 (int)priv->ulRatio_State0,
+			 (int)priv->ulRatio_State1);
 
-		if (pDevice->ulRatio_State1 < pDevice->ulRatio_State0) {
+		if (priv->ulRatio_State1 < priv->ulRatio_State0) {
 			pr_debug("2.[%08x][%08x], uNumSQ3[%d]=%d, %d\n",
-				 (int)pDevice->ulRatio_State0,
-				 (int)pDevice->ulRatio_State1,
-				 (int)pDevice->wAntDiversityMaxRate,
-				 (int)pDevice->uNumSQ3[(int)pDevice->wAntDiversityMaxRate],
-				 (int)pDevice->uDiversityCnt);
-
-			s_vChangeAntenna(pDevice);
-
-			pDevice->TimerSQ3Tmax3.expires =  RUN_AT(pDevice->byTMax3 * HZ);
-			pDevice->TimerSQ3Tmax2.expires =  RUN_AT(pDevice->byTMax2 * HZ);
-			add_timer(&pDevice->TimerSQ3Tmax3);
-			add_timer(&pDevice->TimerSQ3Tmax2);
+				 (int)priv->ulRatio_State0,
+				 (int)priv->ulRatio_State1,
+				 (int)priv->wAntDiversityMaxRate,
+				 (int)priv->uNumSQ3[(int)priv->wAntDiversityMaxRate],
+				 (int)priv->uDiversityCnt);
+
+			s_vChangeAntenna(priv);
+
+			priv->TimerSQ3Tmax3.expires =  RUN_AT(priv->byTMax3 * HZ);
+			priv->TimerSQ3Tmax2.expires =  RUN_AT(priv->byTMax2 * HZ);
+			add_timer(&priv->TimerSQ3Tmax3);
+			add_timer(&priv->TimerSQ3Tmax2);
 		}
 	}
-	pDevice->byAntennaState = 0;
-	BBvClearAntDivSQ3Value(pDevice);
+	priv->byAntennaState = 0;
+	BBvClearAntDivSQ3Value(priv);
 
-	spin_unlock_irqrestore(&pDevice->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
-- 
2.1.0

