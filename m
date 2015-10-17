Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36778 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbbJQKd2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:28 -0400
Received: by wicgb1 with SMTP id gb1so37171708wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 9/9] staging: vt6655: card.c rename pDevice with priv
Date: Sat, 17 Oct 2015 11:33:02 +0100
Message-Id: <1445077982-17832-9-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123337_530013_B3A99C4F)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.c | 386 +++++++++++++++++++++---------------------
 1 file changed, 193 insertions(+), 193 deletions(-)

diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index c45e494..76ad036 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -197,13 +197,13 @@ s_vCalculateOFDMRParameter(
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
+ *      priv             - The adapter to be set
  *  Out:
  *      none
  *
  * Return Value: None.
  */
-bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
+bool CARDbSetPhyParameter(struct vnt_private *priv, u8 bb_type)
 {
 	unsigned char byCWMaxMin = 0;
 	unsigned char bySlot = 0;
@@ -214,77 +214,77 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
 
 	/* Set SIFS, DIFS, EIFS, SlotTime, CwMin */
 	if (bb_type == BB_TYPE_11A) {
-		if (pDevice->byRFType == RF_AIROHA7230) {
+		if (priv->byRFType == RF_AIROHA7230) {
 			/* AL7230 use single PAPE and connect to PAPE_2.4G */
-			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11G);
-			pDevice->abyBBVGA[0] = 0x20;
-			pDevice->abyBBVGA[2] = 0x10;
-			pDevice->abyBBVGA[3] = 0x10;
-			BBbReadEmbedded(pDevice, 0xE7, &byData);
+			MACvSetBBType(priv->PortOffset, BB_TYPE_11G);
+			priv->abyBBVGA[0] = 0x20;
+			priv->abyBBVGA[2] = 0x10;
+			priv->abyBBVGA[3] = 0x10;
+			BBbReadEmbedded(priv, 0xE7, &byData);
 			if (byData == 0x1C)
-				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(priv, 0xE7, priv->abyBBVGA[0]);
 
-		} else if (pDevice->byRFType == RF_UW2452) {
-			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
-			pDevice->abyBBVGA[0] = 0x18;
-			BBbReadEmbedded(pDevice, 0xE7, &byData);
+		} else if (priv->byRFType == RF_UW2452) {
+			MACvSetBBType(priv->PortOffset, BB_TYPE_11A);
+			priv->abyBBVGA[0] = 0x18;
+			BBbReadEmbedded(priv, 0xE7, &byData);
 			if (byData == 0x14) {
-				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
-				BBbWriteEmbedded(pDevice, 0xE1, 0x57);
+				BBbWriteEmbedded(priv, 0xE7, priv->abyBBVGA[0]);
+				BBbWriteEmbedded(priv, 0xE1, 0x57);
 			}
 		} else {
-			MACvSetBBType(pDevice->PortOffset, BB_TYPE_11A);
+			MACvSetBBType(priv->PortOffset, BB_TYPE_11A);
 		}
-		BBbWriteEmbedded(pDevice, 0x88, 0x03);
+		BBbWriteEmbedded(priv, 0x88, 0x03);
 		bySlot = C_SLOT_SHORT;
 		bySIFS = C_SIFS_A;
 		byDIFS = C_SIFS_A + 2*C_SLOT_SHORT;
 		byCWMaxMin = 0xA4;
 	} else if (bb_type == BB_TYPE_11B) {
-		MACvSetBBType(pDevice->PortOffset, BB_TYPE_11B);
-		if (pDevice->byRFType == RF_AIROHA7230) {
-			pDevice->abyBBVGA[0] = 0x1C;
-			pDevice->abyBBVGA[2] = 0x00;
-			pDevice->abyBBVGA[3] = 0x00;
-			BBbReadEmbedded(pDevice, 0xE7, &byData);
+		MACvSetBBType(priv->PortOffset, BB_TYPE_11B);
+		if (priv->byRFType == RF_AIROHA7230) {
+			priv->abyBBVGA[0] = 0x1C;
+			priv->abyBBVGA[2] = 0x00;
+			priv->abyBBVGA[3] = 0x00;
+			BBbReadEmbedded(priv, 0xE7, &byData);
 			if (byData == 0x20)
-				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(priv, 0xE7, priv->abyBBVGA[0]);
 
-		} else if (pDevice->byRFType == RF_UW2452) {
-			pDevice->abyBBVGA[0] = 0x14;
-			BBbReadEmbedded(pDevice, 0xE7, &byData);
+		} else if (priv->byRFType == RF_UW2452) {
+			priv->abyBBVGA[0] = 0x14;
+			BBbReadEmbedded(priv, 0xE7, &byData);
 			if (byData == 0x18) {
-				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
-				BBbWriteEmbedded(pDevice, 0xE1, 0xD3);
+				BBbWriteEmbedded(priv, 0xE7, priv->abyBBVGA[0]);
+				BBbWriteEmbedded(priv, 0xE1, 0xD3);
 			}
 		}
-		BBbWriteEmbedded(pDevice, 0x88, 0x02);
+		BBbWriteEmbedded(priv, 0x88, 0x02);
 		bySlot = C_SLOT_LONG;
 		bySIFS = C_SIFS_BG;
 		byDIFS = C_SIFS_BG + 2*C_SLOT_LONG;
 		byCWMaxMin = 0xA5;
 	} else { /* PK_TYPE_11GA & PK_TYPE_11GB */
-		MACvSetBBType(pDevice->PortOffset, BB_TYPE_11G);
-		if (pDevice->byRFType == RF_AIROHA7230) {
-			pDevice->abyBBVGA[0] = 0x1C;
-			pDevice->abyBBVGA[2] = 0x00;
-			pDevice->abyBBVGA[3] = 0x00;
-			BBbReadEmbedded(pDevice, 0xE7, &byData);
+		MACvSetBBType(priv->PortOffset, BB_TYPE_11G);
+		if (priv->byRFType == RF_AIROHA7230) {
+			priv->abyBBVGA[0] = 0x1C;
+			priv->abyBBVGA[2] = 0x00;
+			priv->abyBBVGA[3] = 0x00;
+			BBbReadEmbedded(priv, 0xE7, &byData);
 			if (byData == 0x20)
-				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
+				BBbWriteEmbedded(priv, 0xE7, priv->abyBBVGA[0]);
 
-		} else if (pDevice->byRFType == RF_UW2452) {
-			pDevice->abyBBVGA[0] = 0x14;
-			BBbReadEmbedded(pDevice, 0xE7, &byData);
+		} else if (priv->byRFType == RF_UW2452) {
+			priv->abyBBVGA[0] = 0x14;
+			BBbReadEmbedded(priv, 0xE7, &byData);
 			if (byData == 0x18) {
-				BBbWriteEmbedded(pDevice, 0xE7, pDevice->abyBBVGA[0]);
-				BBbWriteEmbedded(pDevice, 0xE1, 0xD3);
+				BBbWriteEmbedded(priv, 0xE7, priv->abyBBVGA[0]);
+				BBbWriteEmbedded(priv, 0xE1, 0xD3);
 			}
 		}
-		BBbWriteEmbedded(pDevice, 0x88, 0x08);
+		BBbWriteEmbedded(priv, 0x88, 0x08);
 		bySIFS = C_SIFS_BG;
 
-		if (pDevice->bShortSlotTime) {
+		if (priv->bShortSlotTime) {
 			bySlot = C_SLOT_SHORT;
 			byDIFS = C_SIFS_BG + 2*C_SLOT_SHORT;
 		} else {
@@ -295,14 +295,14 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
 		byCWMaxMin = 0xa4;
 
 		for (i = RATE_54M; i >= RATE_6M; i--) {
-			if (pDevice->basic_rates & ((u32)(0x1 << i))) {
+			if (priv->basic_rates & ((u32)(0x1 << i))) {
 				byCWMaxMin |= 0x1;
 				break;
 			}
 		}
 	}
 
-	if (pDevice->byRFType == RF_RFMD2959) {
+	if (priv->byRFType == RF_RFMD2959) {
 		/*
 		 * bcs TX_PE will reserve 3 us hardware's processing
 		 * time here is 2 us.
@@ -316,32 +316,32 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
 		 */
 	}
 
-	if (pDevice->bySIFS != bySIFS) {
-		pDevice->bySIFS = bySIFS;
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_SIFS, pDevice->bySIFS);
+	if (priv->bySIFS != bySIFS) {
+		priv->bySIFS = bySIFS;
+		VNSvOutPortB(priv->PortOffset + MAC_REG_SIFS, priv->bySIFS);
 	}
-	if (pDevice->byDIFS != byDIFS) {
-		pDevice->byDIFS = byDIFS;
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_DIFS, pDevice->byDIFS);
+	if (priv->byDIFS != byDIFS) {
+		priv->byDIFS = byDIFS;
+		VNSvOutPortB(priv->PortOffset + MAC_REG_DIFS, priv->byDIFS);
 	}
-	if (pDevice->byEIFS != C_EIFS) {
-		pDevice->byEIFS = C_EIFS;
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_EIFS, pDevice->byEIFS);
+	if (priv->byEIFS != C_EIFS) {
+		priv->byEIFS = C_EIFS;
+		VNSvOutPortB(priv->PortOffset + MAC_REG_EIFS, priv->byEIFS);
 	}
-	if (pDevice->bySlot != bySlot) {
-		pDevice->bySlot = bySlot;
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_SLOT, pDevice->bySlot);
+	if (priv->bySlot != bySlot) {
+		priv->bySlot = bySlot;
+		VNSvOutPortB(priv->PortOffset + MAC_REG_SLOT, priv->bySlot);
 
-		BBvSetShortSlotTime(pDevice);
+		BBvSetShortSlotTime(priv);
 	}
-	if (pDevice->byCWMaxMin != byCWMaxMin) {
-		pDevice->byCWMaxMin = byCWMaxMin;
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_CWMAXMIN0, pDevice->byCWMaxMin);
+	if (priv->byCWMaxMin != byCWMaxMin) {
+		priv->byCWMaxMin = byCWMaxMin;
+		VNSvOutPortB(priv->PortOffset + MAC_REG_CWMAXMIN0, priv->byCWMaxMin);
 	}
 
-	pDevice->byPacketType = CARDbyGetPktType(pDevice);
+	priv->byPacketType = CARDbyGetPktType(priv);
 
-	CARDvSetRSPINF(pDevice, bb_type);
+	CARDvSetRSPINF(priv, bb_type);
 
 	return true;
 }
@@ -352,7 +352,7 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be sync.
+ *      priv         - The adapter to be sync.
  *      byRxRate        - data rate of receive beacon
  *      qwBSSTimestamp  - Rx BCN's TSF
  *      qwLocalTSF      - Local TSF
@@ -361,21 +361,21 @@ bool CARDbSetPhyParameter(struct vnt_private *pDevice, u8 bb_type)
  *
  * Return Value: none
  */
-bool CARDbUpdateTSF(struct vnt_private *pDevice, unsigned char byRxRate,
+bool CARDbUpdateTSF(struct vnt_private *priv, unsigned char byRxRate,
 		    u64 qwBSSTimestamp)
 {
 	u64 local_tsf;
 	u64 qwTSFOffset = 0;
 
-	CARDbGetCurrentTSF(pDevice, &local_tsf);
+	CARDbGetCurrentTSF(priv, &local_tsf);
 
 	if (qwBSSTimestamp != local_tsf) {
 		qwTSFOffset = CARDqGetTSFOffset(byRxRate, qwBSSTimestamp,
 						local_tsf);
 		/* adjust TSF, HW's TSF add TSF Offset reg */
-		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST, (u32)qwTSFOffset);
-		VNSvOutPortD(pDevice->PortOffset + MAC_REG_TSFOFST + 4, (u32)(qwTSFOffset >> 32));
-		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_TSFSYNCEN);
+		VNSvOutPortD(priv->PortOffset + MAC_REG_TSFOFST, (u32)qwTSFOffset);
+		VNSvOutPortD(priv->PortOffset + MAC_REG_TSFOFST + 4, (u32)(qwTSFOffset >> 32));
+		MACvRegBitsOn(priv->PortOffset, MAC_REG_TFTCTL, TFTCTL_TSFSYNCEN);
 	}
 	return true;
 }
@@ -386,29 +386,29 @@ bool CARDbUpdateTSF(struct vnt_private *pDevice, unsigned char byRxRate,
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be set.
+ *      priv         - The adapter to be set.
  *      wBeaconInterval - Beacon Interval
  *  Out:
  *      none
  *
  * Return Value: true if succeed; otherwise false
  */
-bool CARDbSetBeaconPeriod(struct vnt_private *pDevice,
+bool CARDbSetBeaconPeriod(struct vnt_private *priv,
 			  unsigned short wBeaconInterval)
 {
 	u64 qwNextTBTT = 0;
 
-	CARDbGetCurrentTSF(pDevice, &qwNextTBTT); /* Get Local TSF counter */
+	CARDbGetCurrentTSF(priv, &qwNextTBTT); /* Get Local TSF counter */
 
 	qwNextTBTT = CARDqGetNextTBTT(qwNextTBTT, wBeaconInterval);
 
 	/* set HW beacon interval */
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_BI, wBeaconInterval);
-	pDevice->wBeaconInterval = wBeaconInterval;
+	VNSvOutPortW(priv->PortOffset + MAC_REG_BI, wBeaconInterval);
+	priv->wBeaconInterval = wBeaconInterval;
 	/* Set NextTBTT */
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_NEXTTBTT, (u32)qwNextTBTT);
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_NEXTTBTT + 4, (u32)(qwNextTBTT >> 32));
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
+	VNSvOutPortD(priv->PortOffset + MAC_REG_NEXTTBTT, (u32)qwNextTBTT);
+	VNSvOutPortD(priv->PortOffset + MAC_REG_NEXTTBTT + 4, (u32)(qwNextTBTT >> 32));
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_TFTCTL, TFTCTL_TBTTSYNCEN);
 
 	return true;
 }
@@ -418,41 +418,41 @@ bool CARDbSetBeaconPeriod(struct vnt_private *pDevice,
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be turned off
+ *      priv         - The adapter to be turned off
  *  Out:
  *      none
  *
  * Return Value: true if success; otherwise false
  */
-bool CARDbRadioPowerOff(struct vnt_private *pDevice)
+bool CARDbRadioPowerOff(struct vnt_private *priv)
 {
 	bool bResult = true;
 
-	if (pDevice->bRadioOff)
+	if (priv->bRadioOff)
 		return true;
 
-	switch (pDevice->byRFType) {
+	switch (priv->byRFType) {
 	case RF_RFMD2959:
-		MACvWordRegBitsOff(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_TXPEINV);
-		MACvWordRegBitsOn(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE1);
+		MACvWordRegBitsOff(priv->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_TXPEINV);
+		MACvWordRegBitsOn(priv->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE1);
 		break;
 
 	case RF_AIROHA:
 	case RF_AL2230S:
 	case RF_AIROHA7230:
-		MACvWordRegBitsOff(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE2);
-		MACvWordRegBitsOff(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
+		MACvWordRegBitsOff(priv->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE2);
+		MACvWordRegBitsOff(priv->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE3);
 		break;
 
 	}
 
-	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_RXON);
+	MACvRegBitsOff(priv->PortOffset, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-	BBvSetDeepSleep(pDevice, pDevice->byLocalID);
+	BBvSetDeepSleep(priv, priv->byLocalID);
 
-	pDevice->bRadioOff = true;
+	priv->bRadioOff = true;
 	pr_debug("chester power off\n");
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_GPIOCTL0, LED_ACTSET);  /* LED issue */
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_GPIOCTL0, LED_ACTSET);  /* LED issue */
 	return bResult;
 }
 
@@ -461,89 +461,89 @@ bool CARDbRadioPowerOff(struct vnt_private *pDevice)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be turned on
+ *      priv         - The adapter to be turned on
  *  Out:
  *      none
  *
  * Return Value: true if success; otherwise false
  */
-bool CARDbRadioPowerOn(struct vnt_private *pDevice)
+bool CARDbRadioPowerOn(struct vnt_private *priv)
 {
 	bool bResult = true;
 
 	pr_debug("chester power on\n");
-	if (pDevice->bRadioControlOff) {
-		if (pDevice->bHWRadioOff)
+	if (priv->bRadioControlOff) {
+		if (priv->bHWRadioOff)
 			pr_debug("chester bHWRadioOff\n");
-		if (pDevice->bRadioControlOff)
+		if (priv->bRadioControlOff)
 			pr_debug("chester bRadioControlOff\n");
 		return false; }
 
-	if (!pDevice->bRadioOff) {
+	if (!priv->bRadioOff) {
 		pr_debug("chester pbRadioOff\n");
 		return true; }
 
-	BBvExitDeepSleep(pDevice, pDevice->byLocalID);
+	BBvExitDeepSleep(priv, priv->byLocalID);
 
-	MACvRegBitsOn(pDevice->PortOffset, MAC_REG_HOSTCR, HOSTCR_RXON);
+	MACvRegBitsOn(priv->PortOffset, MAC_REG_HOSTCR, HOSTCR_RXON);
 
-	switch (pDevice->byRFType) {
+	switch (priv->byRFType) {
 	case RF_RFMD2959:
-		MACvWordRegBitsOn(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_TXPEINV);
-		MACvWordRegBitsOff(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE1);
+		MACvWordRegBitsOn(priv->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_TXPEINV);
+		MACvWordRegBitsOff(priv->PortOffset, MAC_REG_SOFTPWRCTL, SOFTPWRCTL_SWPE1);
 		break;
 
 	case RF_AIROHA:
 	case RF_AL2230S:
 	case RF_AIROHA7230:
-		MACvWordRegBitsOn(pDevice->PortOffset, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE2 |
+		MACvWordRegBitsOn(priv->PortOffset, MAC_REG_SOFTPWRCTL, (SOFTPWRCTL_SWPE2 |
 									    SOFTPWRCTL_SWPE3));
 		break;
 
 	}
 
-	pDevice->bRadioOff = false;
+	priv->bRadioOff = false;
 	pr_debug("chester power on\n");
-	MACvRegBitsOff(pDevice->PortOffset, MAC_REG_GPIOCTL0, LED_ACTSET); /* LED issue */
+	MACvRegBitsOff(priv->PortOffset, MAC_REG_GPIOCTL0, LED_ACTSET); /* LED issue */
 	return bResult;
 }
 
 void
 CARDvSafeResetTx(
-	struct vnt_private *pDevice
+	struct vnt_private *priv
 )
 {
 	unsigned int uu;
 	struct vnt_tx_desc *pCurrTD;
 
 	/* initialize TD index */
-	pDevice->apTailTD[0] = pDevice->apCurrTD[0] = &(pDevice->apTD0Rings[0]);
-	pDevice->apTailTD[1] = pDevice->apCurrTD[1] = &(pDevice->apTD1Rings[0]);
+	priv->apTailTD[0] = priv->apCurrTD[0] = &(priv->apTD0Rings[0]);
+	priv->apTailTD[1] = priv->apCurrTD[1] = &(priv->apTD1Rings[0]);
 
 	for (uu = 0; uu < TYPE_MAXTD; uu++)
-		pDevice->iTDUsed[uu] = 0;
+		priv->iTDUsed[uu] = 0;
 
-	for (uu = 0; uu < pDevice->opts.tx_descs[0]; uu++) {
-		pCurrTD = &(pDevice->apTD0Rings[uu]);
+	for (uu = 0; uu < priv->opts.tx_descs[0]; uu++) {
+		pCurrTD = &(priv->apTD0Rings[uu]);
 		pCurrTD->td0.owner = OWNED_BY_HOST;
 		/* init all Tx Packet pointer to NULL */
 	}
-	for (uu = 0; uu < pDevice->opts.tx_descs[1]; uu++) {
-		pCurrTD = &(pDevice->apTD1Rings[uu]);
+	for (uu = 0; uu < priv->opts.tx_descs[1]; uu++) {
+		pCurrTD = &(priv->apTD1Rings[uu]);
 		pCurrTD->td0.owner = OWNED_BY_HOST;
 		/* init all Tx Packet pointer to NULL */
 	}
 
 	/* set MAC TD pointer */
-	MACvSetCurrTXDescAddr(TYPE_TXDMA0, pDevice->PortOffset,
-			      (pDevice->td0_pool_dma));
+	MACvSetCurrTXDescAddr(TYPE_TXDMA0, priv->PortOffset,
+			      (priv->td0_pool_dma));
 
-	MACvSetCurrTXDescAddr(TYPE_AC0DMA, pDevice->PortOffset,
-			      (pDevice->td1_pool_dma));
+	MACvSetCurrTXDescAddr(TYPE_AC0DMA, priv->PortOffset,
+			      (priv->td1_pool_dma));
 
 	/* set MAC Beacon TX pointer */
-	MACvSetCurrBCNTxDescAddr(pDevice->PortOffset,
-				 (pDevice->tx_beacon_dma));
+	MACvSetCurrBCNTxDescAddr(priv->PortOffset,
+				 (priv->tx_beacon_dma));
 }
 
 /*
@@ -552,7 +552,7 @@ CARDvSafeResetTx(
  *
  * Parameters:
  *  In:
- *      pDevice     - Pointer to the adapter
+ *      priv     - Pointer to the adapter
  *  Out:
  *      none
  *
@@ -560,41 +560,41 @@ CARDvSafeResetTx(
  */
 void
 CARDvSafeResetRx(
-	struct vnt_private *pDevice
+	struct vnt_private *priv
 )
 {
 	unsigned int uu;
 	struct vnt_rx_desc *pDesc;
 
 	/* initialize RD index */
-	pDevice->pCurrRD[0] = &(pDevice->aRD0Ring[0]);
-	pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
+	priv->pCurrRD[0] = &(priv->aRD0Ring[0]);
+	priv->pCurrRD[1] = &(priv->aRD1Ring[0]);
 
 	/* init state, all RD is chip's */
-	for (uu = 0; uu < pDevice->opts.rx_descs0; uu++) {
-		pDesc = &(pDevice->aRD0Ring[uu]);
-		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
+	for (uu = 0; uu < priv->opts.rx_descs0; uu++) {
+		pDesc = &(priv->aRD0Ring[uu]);
+		pDesc->rd0.res_count = cpu_to_le16(priv->rx_buf_sz);
 		pDesc->rd0.owner = OWNED_BY_NIC;
-		pDesc->rd1.req_count = cpu_to_le16(pDevice->rx_buf_sz);
+		pDesc->rd1.req_count = cpu_to_le16(priv->rx_buf_sz);
 	}
 
 	/* init state, all RD is chip's */
-	for (uu = 0; uu < pDevice->opts.rx_descs1; uu++) {
-		pDesc = &(pDevice->aRD1Ring[uu]);
-		pDesc->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
+	for (uu = 0; uu < priv->opts.rx_descs1; uu++) {
+		pDesc = &(priv->aRD1Ring[uu]);
+		pDesc->rd0.res_count = cpu_to_le16(priv->rx_buf_sz);
 		pDesc->rd0.owner = OWNED_BY_NIC;
-		pDesc->rd1.req_count = cpu_to_le16(pDevice->rx_buf_sz);
+		pDesc->rd1.req_count = cpu_to_le16(priv->rx_buf_sz);
 	}
 
 	/* set perPkt mode */
-	MACvRx0PerPktMode(pDevice->PortOffset);
-	MACvRx1PerPktMode(pDevice->PortOffset);
+	MACvRx0PerPktMode(priv->PortOffset);
+	MACvRx1PerPktMode(priv->PortOffset);
 	/* set MAC RD pointer */
-	MACvSetCurrRx0DescAddr(pDevice->PortOffset,
-			       pDevice->rd0_pool_dma);
+	MACvSetCurrRx0DescAddr(priv->PortOffset,
+			       priv->rd0_pool_dma);
 
-	MACvSetCurrRx1DescAddr(pDevice->PortOffset,
-			       pDevice->rd1_pool_dma);
+	MACvSetCurrRx1DescAddr(priv->PortOffset,
+			       priv->rd1_pool_dma);
 }
 
 /*
@@ -602,20 +602,20 @@ CARDvSafeResetRx(
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
+ *      priv             - The adapter to be set
  *      wRateIdx            - Receiving data rate
  *  Out:
  *      none
  *
  * Return Value: response Control frame rate
  */
-static unsigned short CARDwGetCCKControlRate(struct vnt_private *pDevice,
+static unsigned short CARDwGetCCKControlRate(struct vnt_private *priv,
 					     unsigned short wRateIdx)
 {
 	unsigned int ui = (unsigned int) wRateIdx;
 
 	while (ui > RATE_1M) {
-		if (pDevice->basic_rates & ((u32)0x1 << ui))
+		if (priv->basic_rates & ((u32)0x1 << ui))
 			return (unsigned short)ui;
 
 		ui--;
@@ -628,28 +628,28 @@ static unsigned short CARDwGetCCKControlRate(struct vnt_private *pDevice,
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
+ *      priv             - The adapter to be set
  *      wRateIdx            - Receiving data rate
  *  Out:
  *      none
  *
  * Return Value: response Control frame rate
  */
-static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
+static unsigned short CARDwGetOFDMControlRate(struct vnt_private *priv,
 					      unsigned short wRateIdx)
 {
 	unsigned int ui = (unsigned int) wRateIdx;
 
-	pr_debug("BASIC RATE: %X\n", pDevice->basic_rates);
+	pr_debug("BASIC RATE: %X\n", priv->basic_rates);
 
-	if (!CARDbIsOFDMinBasicRate((void *)pDevice)) {
+	if (!CARDbIsOFDMinBasicRate((void *)priv)) {
 		pr_debug("CARDwGetOFDMControlRate:(NO OFDM) %d\n", wRateIdx);
 		if (wRateIdx > RATE_24M)
 			wRateIdx = RATE_24M;
 		return wRateIdx;
 	}
 	while (ui > RATE_11M) {
-		if (pDevice->basic_rates & ((u32)0x1 << ui)) {
+		if (priv->basic_rates & ((u32)0x1 << ui)) {
 			pr_debug("CARDwGetOFDMControlRate : %d\n", ui);
 			return (unsigned short)ui;
 		}
@@ -664,162 +664,162 @@ static unsigned short CARDwGetOFDMControlRate(struct vnt_private *pDevice,
  *
  * Parameters:
  *  In:
- *      pDevice             - The adapter to be set
+ *      priv             - The adapter to be set
  *  Out:
  *      none
  *
  * Return Value: None.
  */
-void CARDvSetRSPINF(struct vnt_private *pDevice, u8 bb_type)
+void CARDvSetRSPINF(struct vnt_private *priv, u8 bb_type)
 {
 	union vnt_phy_field_swap phy;
 	unsigned char byTxRate, byRsvTime;      /* For OFDM */
 	unsigned long flags;
 
-	spin_lock_irqsave(&pDevice->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Set to Page1 */
-	MACvSelectPage1(pDevice->PortOffset);
+	MACvSelectPage1(priv->PortOffset);
 
 	/* RSPINF_b_1 */
-	vnt_get_phy_field(pDevice, 14,
-			  CARDwGetCCKControlRate(pDevice, RATE_1M),
+	vnt_get_phy_field(priv, 14,
+			  CARDwGetCCKControlRate(priv, RATE_1M),
 			  PK_TYPE_11B, &phy.field_read);
 
 	 /* swap over to get correct write order */
 	swap(phy.swap[0], phy.swap[1]);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_1, phy.field_write);
+	VNSvOutPortD(priv->PortOffset + MAC_REG_RSPINF_B_1, phy.field_write);
 
 	/* RSPINF_b_2 */
-	vnt_get_phy_field(pDevice, 14,
-			  CARDwGetCCKControlRate(pDevice, RATE_2M),
+	vnt_get_phy_field(priv, 14,
+			  CARDwGetCCKControlRate(priv, RATE_2M),
 			  PK_TYPE_11B, &phy.field_read);
 
 	swap(phy.swap[0], phy.swap[1]);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_2, phy.field_write);
+	VNSvOutPortD(priv->PortOffset + MAC_REG_RSPINF_B_2, phy.field_write);
 
 	/* RSPINF_b_5 */
-	vnt_get_phy_field(pDevice, 14,
-			  CARDwGetCCKControlRate(pDevice, RATE_5M),
+	vnt_get_phy_field(priv, 14,
+			  CARDwGetCCKControlRate(priv, RATE_5M),
 			  PK_TYPE_11B, &phy.field_read);
 
 	swap(phy.swap[0], phy.swap[1]);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_5, phy.field_write);
+	VNSvOutPortD(priv->PortOffset + MAC_REG_RSPINF_B_5, phy.field_write);
 
 	/* RSPINF_b_11 */
-	vnt_get_phy_field(pDevice, 14,
-			  CARDwGetCCKControlRate(pDevice, RATE_11M),
+	vnt_get_phy_field(priv, 14,
+			  CARDwGetCCKControlRate(priv, RATE_11M),
 			  PK_TYPE_11B, &phy.field_read);
 
 	swap(phy.swap[0], phy.swap[1]);
 
-	VNSvOutPortD(pDevice->PortOffset + MAC_REG_RSPINF_B_11, phy.field_write);
+	VNSvOutPortD(priv->PortOffset + MAC_REG_RSPINF_B_11, phy.field_write);
 
 	/* RSPINF_a_6 */
 	s_vCalculateOFDMRParameter(RATE_6M,
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_6, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_9 */
 	s_vCalculateOFDMRParameter(RATE_9M,
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_9, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_12 */
 	s_vCalculateOFDMRParameter(RATE_12M,
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_12, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_18 */
 	s_vCalculateOFDMRParameter(RATE_18M,
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_18, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_24 */
 	s_vCalculateOFDMRParameter(RATE_24M,
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_24, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_36 */
-	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_36M),
+	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)priv, RATE_36M),
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_36, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_48 */
-	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_48M),
+	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)priv, RATE_48M),
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_48, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_54 */
-	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
+	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)priv, RATE_54M),
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_54, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_54, MAKEWORD(byTxRate, byRsvTime));
 	/* RSPINF_a_72 */
-	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)pDevice, RATE_54M),
+	s_vCalculateOFDMRParameter(CARDwGetOFDMControlRate((void *)priv, RATE_54M),
 				   bb_type,
 				   &byTxRate,
 				   &byRsvTime);
-	VNSvOutPortW(pDevice->PortOffset + MAC_REG_RSPINF_A_72, MAKEWORD(byTxRate, byRsvTime));
+	VNSvOutPortW(priv->PortOffset + MAC_REG_RSPINF_A_72, MAKEWORD(byTxRate, byRsvTime));
 	/* Set to Page0 */
-	MACvSelectPage0(pDevice->PortOffset);
+	MACvSelectPage0(priv->PortOffset);
 
-	spin_unlock_irqrestore(&pDevice->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-void CARDvUpdateBasicTopRate(struct vnt_private *pDevice)
+void CARDvUpdateBasicTopRate(struct vnt_private *priv)
 {
 	unsigned char byTopOFDM = RATE_24M, byTopCCK = RATE_1M;
 	unsigned char ii;
 
 	/* Determines the highest basic rate. */
 	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-		if ((pDevice->basic_rates) & ((u32)(1 << ii))) {
+		if ((priv->basic_rates) & ((u32)(1 << ii))) {
 			byTopOFDM = ii;
 			break;
 		}
 	}
-	pDevice->byTopOFDMBasicRate = byTopOFDM;
+	priv->byTopOFDMBasicRate = byTopOFDM;
 
 	for (ii = RATE_11M;; ii--) {
-		if ((pDevice->basic_rates) & ((u32)(1 << ii))) {
+		if ((priv->basic_rates) & ((u32)(1 << ii))) {
 			byTopCCK = ii;
 			break;
 		}
 		if (ii == RATE_1M)
 			break;
 	}
-	pDevice->byTopCCKBasicRate = byTopCCK;
+	priv->byTopCCKBasicRate = byTopCCK;
 }
 
-bool CARDbIsOFDMinBasicRate(struct vnt_private *pDevice)
+bool CARDbIsOFDMinBasicRate(struct vnt_private *priv)
 {
 	int ii;
 
 	for (ii = RATE_54M; ii >= RATE_6M; ii--) {
-		if ((pDevice->basic_rates) & ((u32)BIT(ii)))
+		if ((priv->basic_rates) & ((u32)BIT(ii)))
 			return true;
 	}
 	return false;
 }
 
-unsigned char CARDbyGetPktType(struct vnt_private *pDevice)
+unsigned char CARDbyGetPktType(struct vnt_private *priv)
 {
 
-	if (pDevice->byBBType == BB_TYPE_11A || pDevice->byBBType == BB_TYPE_11B)
-		return (unsigned char)pDevice->byBBType;
-	else if (CARDbIsOFDMinBasicRate((void *)pDevice))
+	if (priv->byBBType == BB_TYPE_11A || priv->byBBType == BB_TYPE_11B)
+		return (unsigned char)priv->byBBType;
+	else if (CARDbIsOFDMinBasicRate((void *)priv))
 		return PK_TYPE_11GA;
 	else
 		return PK_TYPE_11GB;
@@ -830,7 +830,7 @@ unsigned char CARDbyGetPktType(struct vnt_private *pDevice)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be set
+ *      priv         - The adapter to be set
  *      wLoopbackMode   - Loopback mode to be set
  *  Out:
  *      none
@@ -859,17 +859,17 @@ void CARDvSetLoopbackMode(struct vnt_private *priv, unsigned short wLoopbackMode
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be reset
+ *      priv         - The adapter to be reset
  *  Out:
  *      none
  *
  * Return Value: none
  */
-bool CARDbSoftwareReset(struct vnt_private *pDevice)
+bool CARDbSoftwareReset(struct vnt_private *priv)
 {
 
 	/* reset MAC */
-	if (!MACbSafeSoftwareReset(pDevice->PortOffset))
+	if (!MACbSafeSoftwareReset(priv->PortOffset))
 		return false;
 
 	return true;
@@ -881,7 +881,7 @@ bool CARDbSoftwareReset(struct vnt_private *pDevice)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be sync.
+ *      priv         - The adapter to be sync.
  *      qwTSF1          - Rx BCN's TSF
  *      qwTSF2          - Local TSF
  *  Out:
@@ -909,7 +909,7 @@ u64 CARDqGetTSFOffset(unsigned char byRxRate, u64 qwTSF1, u64 qwTSF2)
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be read
+ *      priv         - The adapter to be read
  *  Out:
  *      qwCurrTSF       - Current TSF counter
  *
@@ -995,7 +995,7 @@ void CARDvSetFirstNextTBTT(struct vnt_private *priv, unsigned short wBeaconInter
  *
  * Parameters:
  *  In:
- *      pDevice         - The adapter to be set
+ *      priv         - The adapter to be set
  *      qwTSF           - Current TSF counter
  *      wBeaconInterval - Beacon Interval
  *  Out:
-- 
2.5.0

