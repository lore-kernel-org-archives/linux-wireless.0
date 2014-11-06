Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45663 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaKFUCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 15:02:38 -0500
Received: by mail-wi0-f177.google.com with SMTP id ex7so2605194wid.4
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2014 12:02:36 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/6] staging: vt6655: BBbWriteEmbedded replace __iomem with vnt_private for callers
Date: Thu,  6 Nov 2014 20:02:03 +0000
Message-Id: <1415304125-5165-4-git-send-email-tvboxspy@gmail.com> (sfid-20141106_210251_023773_15A6560C)
In-Reply-To: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
References: <1415304125-5165-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Referencing dwIoBase inside function.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c | 82 +++++++++++++++++++--------------------
 drivers/staging/vt6655/baseband.h |  2 +-
 drivers/staging/vt6655/card.c     | 24 ++++++------
 3 files changed, 52 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index 9d5288c..f1f1075 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -2003,8 +2003,10 @@ bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned ch
  * Return Value: true if succeeded; false if failed.
  *
  */
-bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData)
+bool BBbWriteEmbedded(struct vnt_private *priv,
+		      unsigned char byBBAddr, unsigned char byData)
 {
+	void __iomem *dwIoBase = priv->PortOffset;
 	unsigned short ww;
 	unsigned char byValue;
 
@@ -2056,14 +2058,14 @@ bool BBbVT3253Init(struct vnt_private *priv)
 	if (byRFType == RF_RFMD2959) {
 		if (byLocalID <= REV_ID_VT3253_A1) {
 			for (ii = 0; ii < CB_VT3253_INIT_FOR_RFMD; ii++)
-				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253InitTab_RFMD[ii][0], byVT3253InitTab_RFMD[ii][1]);
+				bResult &= BBbWriteEmbedded(priv, byVT3253InitTab_RFMD[ii][0], byVT3253InitTab_RFMD[ii][1]);
 
 		} else {
 			for (ii = 0; ii < CB_VT3253B0_INIT_FOR_RFMD; ii++)
-				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_RFMD[ii][0], byVT3253B0_RFMD[ii][1]);
+				bResult &= BBbWriteEmbedded(priv, byVT3253B0_RFMD[ii][0], byVT3253B0_RFMD[ii][1]);
 
 			for (ii = 0; ii < CB_VT3253B0_AGC_FOR_RFMD2959; ii++)
-				bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC4_RFMD2959[ii][0], byVT3253B0_AGC4_RFMD2959[ii][1]);
+				bResult &= BBbWriteEmbedded(priv, byVT3253B0_AGC4_RFMD2959[ii][0], byVT3253B0_AGC4_RFMD2959[ii][1]);
 
 			VNSvOutPortD(dwIoBase + MAC_REG_ITRTMSET, 0x23);
 			MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT(0));
@@ -2078,10 +2080,10 @@ bool BBbVT3253Init(struct vnt_private *priv)
 		priv->ldBmThreshold[3] = 0;
 	} else if ((byRFType == RF_AIROHA) || (byRFType == RF_AL2230S)) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
 		priv->abyBBVGA[0] = 0x1C;
 		priv->abyBBVGA[1] = 0x10;
@@ -2093,10 +2095,10 @@ bool BBbVT3253Init(struct vnt_private *priv)
 		priv->ldBmThreshold[3] = 0;
 	} else if (byRFType == RF_UW2451) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
 		VNSvOutPortB(dwIoBase + MAC_REG_ITRTMSET, 0x23);
 		MACvRegBitsOn(dwIoBase, MAC_REG_PAPEDELAY, BIT(0));
@@ -2111,28 +2113,28 @@ bool BBbVT3253Init(struct vnt_private *priv)
 		priv->ldBmThreshold[3] = 0;
 	} else if (byRFType == RF_UW2452) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_UW2451; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_UW2451[ii][0], byVT3253B0_UW2451[ii][1]);
 
 		/* Init ANT B select,TX Config CR09 = 0x61->0x45, 0x45->0x41(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
 		/*bResult &= BBbWriteEmbedded(dwIoBase,0x09,0x41);*/
 		/* Init ANT B select,RX Config CR10 = 0x28->0x2A, 0x2A->0x28(VC1/VC2 define, make the ANT_A, ANT_B inverted) */
 		/*bResult &= BBbWriteEmbedded(dwIoBase,0x0a,0x28);*/
 		/* Select VC1/VC2, CR215 = 0x02->0x06 */
-		bResult &= BBbWriteEmbedded(dwIoBase, 0xd7, 0x06);
+		bResult &= BBbWriteEmbedded(priv, 0xd7, 0x06);
 
 		/* {{RobertYu:20050125, request by Jack */
-		bResult &= BBbWriteEmbedded(dwIoBase, 0x90, 0x20);
-		bResult &= BBbWriteEmbedded(dwIoBase, 0x97, 0xeb);
+		bResult &= BBbWriteEmbedded(priv, 0x90, 0x20);
+		bResult &= BBbWriteEmbedded(priv, 0x97, 0xeb);
 		/* }} */
 
 		/* {{RobertYu:20050221, request by Jack */
-		bResult &= BBbWriteEmbedded(dwIoBase, 0xa6, 0x00);
-		bResult &= BBbWriteEmbedded(dwIoBase, 0xa8, 0x30);
+		bResult &= BBbWriteEmbedded(priv, 0xa6, 0x00);
+		bResult &= BBbWriteEmbedded(priv, 0xa8, 0x30);
 		/* }} */
-		bResult &= BBbWriteEmbedded(dwIoBase, 0xb0, 0x58);
+		bResult &= BBbWriteEmbedded(priv, 0xb0, 0x58);
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
 		priv->abyBBVGA[0] = 0x14;
 		priv->abyBBVGA[1] = 0x0A;
@@ -2146,10 +2148,10 @@ bool BBbVT3253Init(struct vnt_private *priv)
 
 	} else if (byRFType == RF_VT3226) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
 		priv->abyBBVGA[0] = 0x1C;
 		priv->abyBBVGA[1] = 0x10;
@@ -2164,7 +2166,7 @@ bool BBbVT3253Init(struct vnt_private *priv)
 		/* {{ RobertYu: 20050104 */
 	} else if (byRFType == RF_AIROHA7230) {
 		for (ii = 0; ii < CB_VT3253B0_INIT_FOR_AIROHA2230; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AIROHA2230[ii][0], byVT3253B0_AIROHA2230[ii][1]);
 
 
 		/* {{ RobertYu:20050223, request by JerryChung */
@@ -2177,7 +2179,7 @@ bool BBbVT3253Init(struct vnt_private *priv)
 		/* }} */
 
 		for (ii = 0; ii < CB_VT3253B0_AGC; ii++)
-			bResult &= BBbWriteEmbedded(dwIoBase, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
+			bResult &= BBbWriteEmbedded(priv, byVT3253B0_AGC[ii][0], byVT3253B0_AGC[ii][1]);
 
 		priv->abyBBVGA[0] = 0x1C;
 		priv->abyBBVGA[1] = 0x10;
@@ -2195,8 +2197,8 @@ bool BBbVT3253Init(struct vnt_private *priv)
 	}
 
 	if (byLocalID > REV_ID_VT3253_A1) {
-		BBbWriteEmbedded(dwIoBase, 0x04, 0x7F);
-		BBbWriteEmbedded(dwIoBase, 0x0D, 0x01);
+		BBbWriteEmbedded(priv, 0x04, 0x7F);
+		BBbWriteEmbedded(priv, 0x0D, 0x01);
 	}
 
 	return bResult;
@@ -2232,14 +2234,14 @@ BBvSetShortSlotTime(struct vnt_private *priv)
 	if (byBBVGA == priv->abyBBVGA[0])
 		byBBRxConf |= 0x20; /* 0010 0000 */
 
-	BBbWriteEmbedded(priv->PortOffset, 0x0A, byBBRxConf); /* CR10 */
+	BBbWriteEmbedded(priv, 0x0A, byBBRxConf); /* CR10 */
 }
 
 void BBvSetVGAGainOffset(struct vnt_private *priv, unsigned char byData)
 {
 	unsigned char byBBRxConf = 0;
 
-	BBbWriteEmbedded(priv->PortOffset, 0xE7, byData);
+	BBbWriteEmbedded(priv, 0xE7, byData);
 
 	BBbReadEmbedded(priv->PortOffset, 0x0A, &byBBRxConf); /* CR10 */
 	/* patch for 3253B0 Baseband with Cardbus module */
@@ -2250,7 +2252,7 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, unsigned char byData)
 	else
 		byBBRxConf |= 0x20; /* 0010 0000 */
 	priv->byBBVGACurrent = byData;
-	BBbWriteEmbedded(priv->PortOffset, 0x0A, byBBRxConf); /* CR10 */
+	BBbWriteEmbedded(priv, 0x0A, byBBRxConf); /* CR10 */
 }
 
 /*
@@ -2268,12 +2270,10 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, unsigned char byData)
 void
 BBvSoftwareReset(struct vnt_private *priv)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
-
-	BBbWriteEmbedded(dwIoBase, 0x50, 0x40);
-	BBbWriteEmbedded(dwIoBase, 0x50, 0);
-	BBbWriteEmbedded(dwIoBase, 0x9C, 0x01);
-	BBbWriteEmbedded(dwIoBase, 0x9C, 0);
+	BBbWriteEmbedded(priv, 0x50, 0x40);
+	BBbWriteEmbedded(priv, 0x50, 0);
+	BBbWriteEmbedded(priv, 0x9C, 0x01);
+	BBbWriteEmbedded(priv, 0x9C, 0);
 }
 
 /*
@@ -2296,7 +2296,7 @@ BBvPowerSaveModeON(struct vnt_private *priv)
 
 	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
 	byOrgData |= BIT(0);
-	BBbWriteEmbedded(dwIoBase, 0x0D, byOrgData);
+	BBbWriteEmbedded(priv, 0x0D, byOrgData);
 }
 
 /*
@@ -2319,7 +2319,7 @@ BBvPowerSaveModeOFF(struct vnt_private *priv)
 
 	BBbReadEmbedded(dwIoBase, 0x0D, &byOrgData);
 	byOrgData &= ~(BIT(0));
-	BBbWriteEmbedded(dwIoBase, 0x0D, byOrgData);
+	BBbWriteEmbedded(priv, 0x0D, byOrgData);
 }
 
 /*
@@ -2353,7 +2353,7 @@ BBvSetTxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 		byBBTxConf &= 0xFD; /* 1111 1101 */
 		byBBTxConf |= 0x04;
 	}
-	BBbWriteEmbedded(dwIoBase, 0x09, byBBTxConf); /* CR09 */
+	BBbWriteEmbedded(priv, 0x09, byBBTxConf); /* CR09 */
 }
 
 /*
@@ -2386,7 +2386,7 @@ BBvSetRxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 		byBBRxConf &= 0xFE; /* 1111 1110 */
 		byBBRxConf |= 0x02;
 	}
-	BBbWriteEmbedded(dwIoBase, 0x0A, byBBRxConf); /* CR10 */
+	BBbWriteEmbedded(priv, 0x0A, byBBRxConf); /* CR10 */
 }
 
 /*
@@ -2404,19 +2404,15 @@ BBvSetRxAntennaMode(struct vnt_private *priv, unsigned char byAntennaMode)
 void
 BBvSetDeepSleep(struct vnt_private *priv, unsigned char byLocalID)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
-
-	BBbWriteEmbedded(dwIoBase, 0x0C, 0x17); /* CR12 */
-	BBbWriteEmbedded(dwIoBase, 0x0D, 0xB9); /* CR13 */
+	BBbWriteEmbedded(priv, 0x0C, 0x17); /* CR12 */
+	BBbWriteEmbedded(priv, 0x0D, 0xB9); /* CR13 */
 }
 
 void
 BBvExitDeepSleep(struct vnt_private *priv, unsigned char byLocalID)
 {
-	void __iomem *dwIoBase = priv->PortOffset;
-
-	BBbWriteEmbedded(dwIoBase, 0x0C, 0x00); /* CR12 */
-	BBbWriteEmbedded(dwIoBase, 0x0D, 0x01); /* CR13 */
+	BBbWriteEmbedded(priv, 0x0C, 0x00); /* CR12 */
+	BBbWriteEmbedded(priv, 0x0D, 0x01); /* CR13 */
 }
 
 static
diff --git a/drivers/staging/vt6655/baseband.h b/drivers/staging/vt6655/baseband.h
index 26f9cdc..743ec4f 100644
--- a/drivers/staging/vt6655/baseband.h
+++ b/drivers/staging/vt6655/baseband.h
@@ -78,7 +78,7 @@ void vnt_get_phy_field(struct vnt_private *, u32 frame_length,
 		       u16 tx_rate, u8 pkt_type, struct vnt_phy_field *);
 
 bool BBbReadEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char *pbyData);
-bool BBbWriteEmbedded(void __iomem *dwIoBase, unsigned char byBBAddr, unsigned char byData);
+bool BBbWriteEmbedded(struct vnt_private *, unsigned char byBBAddr, unsigned char byData);
 
 void BBvSetShortSlotTime(struct vnt_private *);
 void BBvSetVGAGainOffset(struct vnt_private *, unsigned char byData);
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 0121466..6f1cea0 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -225,20 +225,20 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 			pDevice->abyBBVGA[3] = 0x10;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
 			if (byData == 0x1C)
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 
 		} else if (pDevice->byRFType == RF_UW2452) {
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
 			pDevice->abyBBVGA[0] = 0x18;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
 			if (byData == 0x14) {
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE1, 0x57);
+				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(pDevice, 0xE1, 0x57);
 			}
 		} else {
 			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
 		}
-		BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x03);
+		BBbWriteEmbedded(pDevice, 0x88, 0x03);
 		bySlot = C_SLOT_SHORT;
 		bySIFS = C_SIFS_A;
 		byDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
@@ -251,17 +251,17 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 			pDevice->abyBBVGA[3] = 0x00;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
 			if (byData == 0x20)
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 
 		} else if (pDevice->byRFType == RF_UW2452) {
 			pDevice->abyBBVGA[0] = 0x14;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
 			if (byData == 0x18) {
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE1, 0xD3);
+				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(pDevice, 0xE1, 0xD3);
 			}
 		}
-		BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x02);
+		BBbWriteEmbedded(pDevice, 0x88, 0x02);
 		bySlot = C_SLOT_LONG;
 		bySIFS = C_SIFS_BG;
 		byDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
@@ -274,17 +274,17 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, CARD_PHY_TYPE ePHYType,
 			pDevice->abyBBVGA[3] = 0x00;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
 			if (byData == 0x20)
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
 
 		} else if (pDevice->byRFType == RF_UW2452) {
 			pDevice->abyBBVGA[0] = 0x14;
 			BBbReadEmbedded(pDevice->PortOffset, 0xE7, &byData);
 			if (byData == 0x18) {
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE7, pDevice->abyBBVGA[0]);
-				BBbWriteEmbedded(pDevice->PortOffset, 0xE1, 0xD3);
+				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(pDevice, 0xE1, 0xD3);
 			}
 		}
-		BBbWriteEmbedded(pDevice->PortOffset, 0x88, 0x08);
+		BBbWriteEmbedded(pDevice, 0x88, 0x08);
 		bySIFS = C_SIFS_BG;
 
 		if (pDevice->bShortSlotTime) {
-- 
2.1.0

