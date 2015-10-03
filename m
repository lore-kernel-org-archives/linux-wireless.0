Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37295 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbbJCTal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Oct 2015 15:30:41 -0400
Received: by wicfx3 with SMTP id fx3so67827757wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2015 12:30:40 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/6] staging: vt6655: device_main replace pDevice with priv.
Date: Sat,  3 Oct 2015 20:30:22 +0100
Message-Id: <1443900627-2924-1-git-send-email-tvboxspy@gmail.com> (sfid-20151003_213046_924095_F01DFAFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing camel case.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 588 +++++++++++++++++------------------
 1 file changed, 292 insertions(+), 296 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 07ebdea..603f189 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -134,24 +134,24 @@ static const struct pci_device_id vt6655_pci_id_table[] = {
 /*---------------------  Static Functions  --------------------------*/
 
 static int  vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent);
-static void device_free_info(struct vnt_private *pDevice);
-static void device_print_info(struct vnt_private *pDevice);
+static void device_free_info(struct vnt_private *priv);
+static void device_print_info(struct vnt_private *priv);
 
-static void device_init_rd0_ring(struct vnt_private *pDevice);
-static void device_init_rd1_ring(struct vnt_private *pDevice);
-static void device_init_td0_ring(struct vnt_private *pDevice);
-static void device_init_td1_ring(struct vnt_private *pDevice);
+static void device_init_rd0_ring(struct vnt_private *priv);
+static void device_init_rd1_ring(struct vnt_private *priv);
+static void device_init_td0_ring(struct vnt_private *priv);
+static void device_init_td1_ring(struct vnt_private *priv);
 
-static int  device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx);
-static int  device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx);
+static int  device_rx_srv(struct vnt_private *priv, unsigned int uIdx);
+static int  device_tx_srv(struct vnt_private *priv, unsigned int uIdx);
 static bool device_alloc_rx_buf(struct vnt_private *, struct vnt_rx_desc *);
-static void device_init_registers(struct vnt_private *pDevice);
+static void device_init_registers(struct vnt_private *priv);
 static void device_free_tx_buf(struct vnt_private *, struct vnt_tx_desc *);
-static void device_free_td0_ring(struct vnt_private *pDevice);
-static void device_free_td1_ring(struct vnt_private *pDevice);
-static void device_free_rd0_ring(struct vnt_private *pDevice);
-static void device_free_rd1_ring(struct vnt_private *pDevice);
-static void device_free_rings(struct vnt_private *pDevice);
+static void device_free_td0_ring(struct vnt_private *priv);
+static void device_free_td1_ring(struct vnt_private *priv);
+static void device_free_rd0_ring(struct vnt_private *priv);
+static void device_free_rd1_ring(struct vnt_private *priv);
+static void device_free_rings(struct vnt_private *priv);
 
 /*---------------------  Export Variables  --------------------------*/
 
@@ -159,16 +159,16 @@ static void device_free_rings(struct vnt_private *pDevice);
 
 static void vt6655_remove(struct pci_dev *pcid)
 {
-	struct vnt_private *pDevice = pci_get_drvdata(pcid);
+	struct vnt_private *priv = pci_get_drvdata(pcid);
 
-	if (pDevice == NULL)
+	if (priv == NULL)
 		return;
-	device_free_info(pDevice);
+	device_free_info(priv);
 }
 
-static void device_get_options(struct vnt_private *pDevice)
+static void device_get_options(struct vnt_private *priv)
 {
-	POPTIONS pOpts = &(pDevice->sOpts);
+	POPTIONS pOpts = &priv->sOpts;
 
 	pOpts->nRxDescs0 = RX_DESC_DEF0;
 	pOpts->nRxDescs1 = RX_DESC_DEF1;
@@ -182,28 +182,28 @@ static void device_get_options(struct vnt_private *pDevice)
 }
 
 static void
-device_set_options(struct vnt_private *pDevice)
+device_set_options(struct vnt_private *priv)
 {
-	pDevice->byShortRetryLimit = pDevice->sOpts.short_retry;
-	pDevice->byLongRetryLimit = pDevice->sOpts.long_retry;
-	pDevice->byBBType = pDevice->sOpts.bbp_type;
-	pDevice->byPacketType = pDevice->byBBType;
-	pDevice->byAutoFBCtrl = AUTO_FB_0;
-	pDevice->bUpdateBBVGA = true;
-	pDevice->byPreambleType = 0;
-
-	pr_debug(" byShortRetryLimit= %d\n", (int)pDevice->byShortRetryLimit);
-	pr_debug(" byLongRetryLimit= %d\n", (int)pDevice->byLongRetryLimit);
-	pr_debug(" byPreambleType= %d\n", (int)pDevice->byPreambleType);
-	pr_debug(" byShortPreamble= %d\n", (int)pDevice->byShortPreamble);
-	pr_debug(" byBBType= %d\n", (int)pDevice->byBBType);
+	priv->byShortRetryLimit = priv->sOpts.short_retry;
+	priv->byLongRetryLimit = priv->sOpts.long_retry;
+	priv->byBBType = priv->sOpts.bbp_type;
+	priv->byPacketType = priv->byBBType;
+	priv->byAutoFBCtrl = AUTO_FB_0;
+	priv->bUpdateBBVGA = true;
+	priv->byPreambleType = 0;
+
+	pr_debug(" byShortRetryLimit= %d\n", (int)priv->byShortRetryLimit);
+	pr_debug(" byLongRetryLimit= %d\n", (int)priv->byLongRetryLimit);
+	pr_debug(" byPreambleType= %d\n", (int)priv->byPreambleType);
+	pr_debug(" byShortPreamble= %d\n", (int)priv->byShortPreamble);
+	pr_debug(" byBBType= %d\n", (int)priv->byBBType);
 }
 
 /*
  * Initialisation of MAC & BBP registers
  */
 
-static void device_init_registers(struct vnt_private *pDevice)
+static void device_init_registers(struct vnt_private *priv)
 {
 	unsigned long flags;
 	unsigned int ii;
@@ -211,45 +211,45 @@ static void device_init_registers(struct vnt_private *pDevice)
 	unsigned char byCCKPwrdBm = 0;
 	unsigned char byOFDMPwrdBm = 0;
 
-	MACbShutdown(pDevice->PortOffset);
-	BBvSoftwareReset(pDevice);
+	MACbShutdown(priv->PortOffset);
+	BBvSoftwareReset(priv);
 
 	/* Do MACbSoftwareReset in MACvInitialize */
-	MACbSoftwareReset(pDevice->PortOffset);
+	MACbSoftwareReset(priv->PortOffset);
 
-	pDevice->bAES = false;
+	priv->bAES = false;
 
 	/* Only used in 11g type, sync with ERP IE */
-	pDevice->bProtectMode = false;
+	priv->bProtectMode = false;
 
-	pDevice->bNonERPPresent = false;
-	pDevice->bBarkerPreambleMd = false;
-	pDevice->wCurrentRate = RATE_1M;
-	pDevice->byTopOFDMBasicRate = RATE_24M;
-	pDevice->byTopCCKBasicRate = RATE_1M;
+	priv->bNonERPPresent = false;
+	priv->bBarkerPreambleMd = false;
+	priv->wCurrentRate = RATE_1M;
+	priv->byTopOFDMBasicRate = RATE_24M;
+	priv->byTopCCKBasicRate = RATE_1M;
 
 	/* init MAC */
-	MACvInitialize(pDevice->PortOffset);
+	MACvInitialize(priv->PortOffset);
 
 	/* Get Local ID */
-	VNSvInPortB(pDevice->PortOffset + MAC_REG_LOCALID, &pDevice->byLocalID);
+	VNSvInPortB(priv->PortOffset + MAC_REG_LOCALID, &priv->byLocalID);
 
-	spin_lock_irqsave(&pDevice->lock, flags);
+	spin_lock_irqsave(&priv->lock, flags);
 
-	SROMvReadAllContents(pDevice->PortOffset, pDevice->abyEEPROM);
+	SROMvReadAllContents(priv->PortOffset, priv->abyEEPROM);
 
-	spin_unlock_irqrestore(&pDevice->lock, flags);
+	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Get Channel range */
-	pDevice->byMinChannel = 1;
-	pDevice->byMaxChannel = CB_MAX_CHANNEL;
+	priv->byMinChannel = 1;
+	priv->byMaxChannel = CB_MAX_CHANNEL;
 
 	/* Get Antena */
-	byValue = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_ANTENNA);
+	byValue = SROMbyReadEmbedded(priv->PortOffset, EEP_OFS_ANTENNA);
 	if (byValue & EEP_ANTINV)
-		pDevice->bTxRxAntInv = true;
+		priv->bTxRxAntInv = true;
 	else
-		pDevice->bTxRxAntInv = false;
+		priv->bTxRxAntInv = false;
 
 	byValue &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 	/* if not set default is All */
@@ -257,352 +257,348 @@ static void device_init_registers(struct vnt_private *pDevice)
 		byValue = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
 	if (byValue == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
-		pDevice->byAntennaCount = 2;
-		pDevice->byTxAntennaMode = ANT_B;
-		pDevice->dwTxAntennaSel = 1;
-		pDevice->dwRxAntennaSel = 1;
+		priv->byAntennaCount = 2;
+		priv->byTxAntennaMode = ANT_B;
+		priv->dwTxAntennaSel = 1;
+		priv->dwRxAntennaSel = 1;
 
-		if (pDevice->bTxRxAntInv)
-			pDevice->byRxAntennaMode = ANT_A;
+		if (priv->bTxRxAntInv)
+			priv->byRxAntennaMode = ANT_A;
 		else
-			pDevice->byRxAntennaMode = ANT_B;
+			priv->byRxAntennaMode = ANT_B;
 	} else  {
-		pDevice->byAntennaCount = 1;
-		pDevice->dwTxAntennaSel = 0;
-		pDevice->dwRxAntennaSel = 0;
+		priv->byAntennaCount = 1;
+		priv->dwTxAntennaSel = 0;
+		priv->dwRxAntennaSel = 0;
 
 		if (byValue & EEP_ANTENNA_AUX) {
-			pDevice->byTxAntennaMode = ANT_A;
+			priv->byTxAntennaMode = ANT_A;
 
-			if (pDevice->bTxRxAntInv)
-				pDevice->byRxAntennaMode = ANT_B;
+			if (priv->bTxRxAntInv)
+				priv->byRxAntennaMode = ANT_B;
 			else
-				pDevice->byRxAntennaMode = ANT_A;
+				priv->byRxAntennaMode = ANT_A;
 		} else {
-			pDevice->byTxAntennaMode = ANT_B;
+			priv->byTxAntennaMode = ANT_B;
 
-			if (pDevice->bTxRxAntInv)
-				pDevice->byRxAntennaMode = ANT_A;
+			if (priv->bTxRxAntInv)
+				priv->byRxAntennaMode = ANT_A;
 			else
-				pDevice->byRxAntennaMode = ANT_B;
+				priv->byRxAntennaMode = ANT_B;
 		}
 	}
 
 	/* Set initial antenna mode */
-	BBvSetTxAntennaMode(pDevice, pDevice->byTxAntennaMode);
-	BBvSetRxAntennaMode(pDevice, pDevice->byRxAntennaMode);
+	BBvSetTxAntennaMode(priv, priv->byTxAntennaMode);
+	BBvSetRxAntennaMode(priv, priv->byRxAntennaMode);
 
 	/* zonetype initial */
-	pDevice->byOriginalZonetype = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
+	priv->byOriginalZonetype = priv->abyEEPROM[EEP_OFS_ZONETYPE];
 
-	if (!pDevice->bZoneRegExist)
-		pDevice->byZoneType = pDevice->abyEEPROM[EEP_OFS_ZONETYPE];
+	if (!priv->bZoneRegExist)
+		priv->byZoneType = priv->abyEEPROM[EEP_OFS_ZONETYPE];
 
-	pr_debug("pDevice->byZoneType = %x\n", pDevice->byZoneType);
+	pr_debug("priv->byZoneType = %x\n", priv->byZoneType);
 
 	/* Init RF module */
-	RFbInit(pDevice);
+	RFbInit(priv);
 
 	/* Get Desire Power Value */
-	pDevice->byCurPwr = 0xFF;
-	pDevice->byCCKPwr = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_CCK);
-	pDevice->byOFDMPwrG = SROMbyReadEmbedded(pDevice->PortOffset, EEP_OFS_PWR_OFDMG);
+	priv->byCurPwr = 0xFF;
+	priv->byCCKPwr = SROMbyReadEmbedded(priv->PortOffset, EEP_OFS_PWR_CCK);
+	priv->byOFDMPwrG = SROMbyReadEmbedded(priv->PortOffset, EEP_OFS_PWR_OFDMG);
 
 	/* Load power Table */
 	for (ii = 0; ii < CB_MAX_CHANNEL_24G; ii++) {
-		pDevice->abyCCKPwrTbl[ii + 1] =
-			SROMbyReadEmbedded(pDevice->PortOffset,
+		priv->abyCCKPwrTbl[ii + 1] =
+			SROMbyReadEmbedded(priv->PortOffset,
 					   (unsigned char)(ii + EEP_OFS_CCK_PWR_TBL));
-		if (pDevice->abyCCKPwrTbl[ii + 1] == 0)
-			pDevice->abyCCKPwrTbl[ii+1] = pDevice->byCCKPwr;
+		if (priv->abyCCKPwrTbl[ii + 1] == 0)
+			priv->abyCCKPwrTbl[ii+1] = priv->byCCKPwr;
 
-		pDevice->abyOFDMPwrTbl[ii + 1] =
-			SROMbyReadEmbedded(pDevice->PortOffset,
+		priv->abyOFDMPwrTbl[ii + 1] =
+			SROMbyReadEmbedded(priv->PortOffset,
 					   (unsigned char)(ii + EEP_OFS_OFDM_PWR_TBL));
-		if (pDevice->abyOFDMPwrTbl[ii + 1] == 0)
-			pDevice->abyOFDMPwrTbl[ii + 1] = pDevice->byOFDMPwrG;
+		if (priv->abyOFDMPwrTbl[ii + 1] == 0)
+			priv->abyOFDMPwrTbl[ii + 1] = priv->byOFDMPwrG;
 
-		pDevice->abyCCKDefaultPwr[ii + 1] = byCCKPwrdBm;
-		pDevice->abyOFDMDefaultPwr[ii + 1] = byOFDMPwrdBm;
+		priv->abyCCKDefaultPwr[ii + 1] = byCCKPwrdBm;
+		priv->abyOFDMDefaultPwr[ii + 1] = byOFDMPwrdBm;
 	}
 
 	/* recover 12,13 ,14channel for EUROPE by 11 channel */
 	for (ii = 11; ii < 14; ii++) {
-		pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
-		pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
+		priv->abyCCKPwrTbl[ii] = priv->abyCCKPwrTbl[10];
+		priv->abyOFDMPwrTbl[ii] = priv->abyOFDMPwrTbl[10];
 	}
 
 	/* Load OFDM A Power Table */
 	for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
-		pDevice->abyOFDMPwrTbl[ii + CB_MAX_CHANNEL_24G + 1] =
-			SROMbyReadEmbedded(pDevice->PortOffset,
+		priv->abyOFDMPwrTbl[ii + CB_MAX_CHANNEL_24G + 1] =
+			SROMbyReadEmbedded(priv->PortOffset,
 					   (unsigned char)(ii + EEP_OFS_OFDMA_PWR_TBL));
 
-		pDevice->abyOFDMDefaultPwr[ii + CB_MAX_CHANNEL_24G + 1] =
-			SROMbyReadEmbedded(pDevice->PortOffset,
+		priv->abyOFDMDefaultPwr[ii + CB_MAX_CHANNEL_24G + 1] =
+			SROMbyReadEmbedded(priv->PortOffset,
 					   (unsigned char)(ii + EEP_OFS_OFDMA_PWR_dBm));
 	}
 
-	if (pDevice->byLocalID > REV_ID_VT3253_B1) {
-		MACvSelectPage1(pDevice->PortOffset);
+	if (priv->byLocalID > REV_ID_VT3253_B1) {
+		MACvSelectPage1(priv->PortOffset);
 
-		VNSvOutPortB(pDevice->PortOffset + MAC_REG_MSRCTL + 1,
+		VNSvOutPortB(priv->PortOffset + MAC_REG_MSRCTL + 1,
 			     (MSRCTL1_TXPWR | MSRCTL1_CSAPAREN));
 
-		MACvSelectPage0(pDevice->PortOffset);
+		MACvSelectPage0(priv->PortOffset);
 	}
 
 	/* use relative tx timeout and 802.11i D4 */
-	MACvWordRegBitsOn(pDevice->PortOffset,
+	MACvWordRegBitsOn(priv->PortOffset,
 			  MAC_REG_CFG, (CFG_TKIPOPT | CFG_NOTXTIMEOUT));
 
 	/* set performance parameter by registry */
-	MACvSetShortRetryLimit(pDevice->PortOffset, pDevice->byShortRetryLimit);
-	MACvSetLongRetryLimit(pDevice->PortOffset, pDevice->byLongRetryLimit);
+	MACvSetShortRetryLimit(priv->PortOffset, priv->byShortRetryLimit);
+	MACvSetLongRetryLimit(priv->PortOffset, priv->byLongRetryLimit);
 
 	/* reset TSF counter */
-	VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
+	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTRST);
 	/* enable TSF counter */
-	VNSvOutPortB(pDevice->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
+	VNSvOutPortB(priv->PortOffset + MAC_REG_TFTCTL, TFTCTL_TSFCNTREN);
 
 	/* initialize BBP registers */
-	BBbVT3253Init(pDevice);
+	BBbVT3253Init(priv);
 
-	if (pDevice->bUpdateBBVGA) {
-		pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
-		pDevice->byBBVGANew = pDevice->byBBVGACurrent;
-		BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
+	if (priv->bUpdateBBVGA) {
+		priv->byBBVGACurrent = priv->abyBBVGA[0];
+		priv->byBBVGANew = priv->byBBVGACurrent;
+		BBvSetVGAGainOffset(priv, priv->abyBBVGA[0]);
 	}
 
-	BBvSetRxAntennaMode(pDevice, pDevice->byRxAntennaMode);
-	BBvSetTxAntennaMode(pDevice, pDevice->byTxAntennaMode);
+	BBvSetRxAntennaMode(priv, priv->byRxAntennaMode);
+	BBvSetTxAntennaMode(priv, priv->byTxAntennaMode);
 
 	/* Set BB and packet type at the same time. */
 	/* Set Short Slot Time, xIFS, and RSPINF. */
-	pDevice->wCurrentRate = RATE_54M;
+	priv->wCurrentRate = RATE_54M;
 
-	pDevice->bRadioOff = false;
+	priv->bRadioOff = false;
 
-	pDevice->byRadioCtl = SROMbyReadEmbedded(pDevice->PortOffset,
+	priv->byRadioCtl = SROMbyReadEmbedded(priv->PortOffset,
 						 EEP_OFS_RADIOCTL);
-	pDevice->bHWRadioOff = false;
+	priv->bHWRadioOff = false;
 
-	if (pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) {
+	if (priv->byRadioCtl & EEP_RADIOCTL_ENABLE) {
 		/* Get GPIO */
-		MACvGPIOIn(pDevice->PortOffset, &pDevice->byGPIO);
+		MACvGPIOIn(priv->PortOffset, &priv->byGPIO);
 
-		if (((pDevice->byGPIO & GPIO0_DATA) &&
-		     !(pDevice->byRadioCtl & EEP_RADIOCTL_INV)) ||
-		     (!(pDevice->byGPIO & GPIO0_DATA) &&
-		     (pDevice->byRadioCtl & EEP_RADIOCTL_INV)))
-			pDevice->bHWRadioOff = true;
+		if (((priv->byGPIO & GPIO0_DATA) &&
+		     !(priv->byRadioCtl & EEP_RADIOCTL_INV)) ||
+		     (!(priv->byGPIO & GPIO0_DATA) &&
+		     (priv->byRadioCtl & EEP_RADIOCTL_INV)))
+			priv->bHWRadioOff = true;
 	}
 
-	if (pDevice->bHWRadioOff || pDevice->bRadioControlOff)
-		CARDbRadioPowerOff(pDevice);
+	if (priv->bHWRadioOff || priv->bRadioControlOff)
+		CARDbRadioPowerOff(priv);
 
 	/* get Permanent network address */
-	SROMvReadEtherAddress(pDevice->PortOffset, pDevice->abyCurrentNetAddr);
-	pr_debug("Network address = %pM\n", pDevice->abyCurrentNetAddr);
+	SROMvReadEtherAddress(priv->PortOffset, priv->abyCurrentNetAddr);
+	pr_debug("Network address = %pM\n", priv->abyCurrentNetAddr);
 
 	/* reset Tx pointer */
-	CARDvSafeResetRx(pDevice);
+	CARDvSafeResetRx(priv);
 	/* reset Rx pointer */
-	CARDvSafeResetTx(pDevice);
+	CARDvSafeResetTx(priv);
 
-	if (pDevice->byLocalID <= REV_ID_VT3253_A1)
-		MACvRegBitsOn(pDevice->PortOffset, MAC_REG_RCR, RCR_WPAERR);
+	if (priv->byLocalID <= REV_ID_VT3253_A1)
+		MACvRegBitsOn(priv->PortOffset, MAC_REG_RCR, RCR_WPAERR);
 
 	/* Turn On Rx DMA */
-	MACvReceive0(pDevice->PortOffset);
-	MACvReceive1(pDevice->PortOffset);
+	MACvReceive0(priv->PortOffset);
+	MACvReceive1(priv->PortOffset);
 
 	/* start the adapter */
-	MACvStart(pDevice->PortOffset);
+	MACvStart(priv->PortOffset);
 }
 
-static void device_print_info(struct vnt_private *pDevice)
+static void device_print_info(struct vnt_private *priv)
 {
-	dev_info(&pDevice->pcid->dev, "MAC=%pM IO=0x%lx Mem=0x%lx IRQ=%d\n",
-		 pDevice->abyCurrentNetAddr, (unsigned long)pDevice->ioaddr,
-		 (unsigned long)pDevice->PortOffset, pDevice->pcid->irq);
+	dev_info(&priv->pcid->dev, "MAC=%pM IO=0x%lx Mem=0x%lx IRQ=%d\n",
+		 priv->abyCurrentNetAddr, (unsigned long)priv->ioaddr,
+		 (unsigned long)priv->PortOffset, priv->pcid->irq);
 }
 
-static void device_free_info(struct vnt_private *pDevice)
+static void device_free_info(struct vnt_private *priv)
 {
-	if (!pDevice)
+	if (!priv)
 		return;
 
-	if (pDevice->mac_hw)
-		ieee80211_unregister_hw(pDevice->hw);
+	if (priv->mac_hw)
+		ieee80211_unregister_hw(priv->hw);
 
-	if (pDevice->PortOffset)
-		iounmap(pDevice->PortOffset);
+	if (priv->PortOffset)
+		iounmap(priv->PortOffset);
 
-	if (pDevice->pcid)
-		pci_release_regions(pDevice->pcid);
+	if (priv->pcid)
+		pci_release_regions(priv->pcid);
 
-	if (pDevice->hw)
-		ieee80211_free_hw(pDevice->hw);
+	if (priv->hw)
+		ieee80211_free_hw(priv->hw);
 }
 
-static bool device_init_rings(struct vnt_private *pDevice)
+static bool device_init_rings(struct vnt_private *priv)
 {
 	void *vir_pool;
 
 	/*allocate all RD/TD rings a single pool*/
-	vir_pool = dma_zalloc_coherent(&pDevice->pcid->dev,
-					 pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
-					 pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
-					 pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
-					 pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
-					 &pDevice->pool_dma, GFP_ATOMIC);
+	vir_pool = dma_zalloc_coherent(&priv->pcid->dev,
+				       priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
+				       priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
+				       priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
+				       priv->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
+				       &priv->pool_dma, GFP_ATOMIC);
 	if (vir_pool == NULL) {
-		dev_err(&pDevice->pcid->dev, "allocate desc dma memory failed\n");
+		dev_err(&priv->pcid->dev, "allocate desc dma memory failed\n");
 		return false;
 	}
 
-	pDevice->aRD0Ring = vir_pool;
-	pDevice->aRD1Ring = vir_pool +
-		pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
-
-	pDevice->rd0_pool_dma = pDevice->pool_dma;
-	pDevice->rd1_pool_dma = pDevice->rd0_pool_dma +
-		pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
-
-	pDevice->tx0_bufs = dma_zalloc_coherent(&pDevice->pcid->dev,
-						  pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-						  pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
-						  CB_BEACON_BUF_SIZE +
-						  CB_MAX_BUF_SIZE,
-						  &pDevice->tx_bufs_dma0,
-						  GFP_ATOMIC);
-	if (pDevice->tx0_bufs == NULL) {
-		dev_err(&pDevice->pcid->dev, "allocate buf dma memory failed\n");
-
-		dma_free_coherent(&pDevice->pcid->dev,
-				    pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
-				    pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
-				    pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
-				    pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
-				    vir_pool, pDevice->pool_dma
-			);
+	priv->aRD0Ring = vir_pool;
+	priv->aRD1Ring = vir_pool +
+		priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
+
+	priv->rd0_pool_dma = priv->pool_dma;
+	priv->rd1_pool_dma = priv->rd0_pool_dma +
+		priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc);
+
+	priv->tx0_bufs = dma_zalloc_coherent(&priv->pcid->dev,
+					     priv->sOpts.nTxDescs[0] * PKT_BUF_SZ +
+					     priv->sOpts.nTxDescs[1] * PKT_BUF_SZ +
+					     CB_BEACON_BUF_SIZE +
+					     CB_MAX_BUF_SIZE,
+					     &priv->tx_bufs_dma0,
+					     GFP_ATOMIC);
+	if (priv->tx0_bufs == NULL) {
+		dev_err(&priv->pcid->dev, "allocate buf dma memory failed\n");
+
+		dma_free_coherent(&priv->pcid->dev,
+				  priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
+				  priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
+				  priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
+				  priv->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
+				  vir_pool, priv->pool_dma);
 		return false;
 	}
 
-	pDevice->td0_pool_dma = pDevice->rd1_pool_dma +
-		pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
+	priv->td0_pool_dma = priv->rd1_pool_dma +
+		priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
 
-	pDevice->td1_pool_dma = pDevice->td0_pool_dma +
-		pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
+	priv->td1_pool_dma = priv->td0_pool_dma +
+		priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
 
 	/* vir_pool: pvoid type */
-	pDevice->apTD0Rings = vir_pool
-		+ pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
-		+ pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
+	priv->apTD0Rings = vir_pool
+		+ priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
+		+ priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc);
 
-	pDevice->apTD1Rings = vir_pool
-		+ pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
-		+ pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc)
-		+ pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
+	priv->apTD1Rings = vir_pool
+		+ priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc)
+		+ priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc)
+		+ priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc);
 
-	pDevice->tx1_bufs = pDevice->tx0_bufs +
-		pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ;
+	priv->tx1_bufs = priv->tx0_bufs +
+		priv->sOpts.nTxDescs[0] * PKT_BUF_SZ;
 
-	pDevice->tx_beacon_bufs = pDevice->tx1_bufs +
-		pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ;
+	priv->tx_beacon_bufs = priv->tx1_bufs +
+		priv->sOpts.nTxDescs[1] * PKT_BUF_SZ;
 
-	pDevice->pbyTmpBuff = pDevice->tx_beacon_bufs +
+	priv->pbyTmpBuff = priv->tx_beacon_bufs +
 		CB_BEACON_BUF_SIZE;
 
-	pDevice->tx_bufs_dma1 = pDevice->tx_bufs_dma0 +
-		pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ;
+	priv->tx_bufs_dma1 = priv->tx_bufs_dma0 +
+		priv->sOpts.nTxDescs[0] * PKT_BUF_SZ;
 
-	pDevice->tx_beacon_dma = pDevice->tx_bufs_dma1 +
-		pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ;
+	priv->tx_beacon_dma = priv->tx_bufs_dma1 +
+		priv->sOpts.nTxDescs[1] * PKT_BUF_SZ;
 
 	return true;
 }
 
-static void device_free_rings(struct vnt_private *pDevice)
+static void device_free_rings(struct vnt_private *priv)
 {
-	dma_free_coherent(&pDevice->pcid->dev,
-			    pDevice->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
-			    pDevice->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
-			    pDevice->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
-			    pDevice->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc)
-			    ,
-			    pDevice->aRD0Ring, pDevice->pool_dma
-		);
-
-	if (pDevice->tx0_bufs)
-		dma_free_coherent(&pDevice->pcid->dev,
-				    pDevice->sOpts.nTxDescs[0] * PKT_BUF_SZ +
-				    pDevice->sOpts.nTxDescs[1] * PKT_BUF_SZ +
-				    CB_BEACON_BUF_SIZE +
-				    CB_MAX_BUF_SIZE,
-				    pDevice->tx0_bufs, pDevice->tx_bufs_dma0
-			);
+	dma_free_coherent(&priv->pcid->dev,
+			  priv->sOpts.nRxDescs0 * sizeof(struct vnt_rx_desc) +
+			  priv->sOpts.nRxDescs1 * sizeof(struct vnt_rx_desc) +
+			  priv->sOpts.nTxDescs[0] * sizeof(struct vnt_tx_desc) +
+			  priv->sOpts.nTxDescs[1] * sizeof(struct vnt_tx_desc),
+			  priv->aRD0Ring, priv->pool_dma);
+
+	if (priv->tx0_bufs)
+		dma_free_coherent(&priv->pcid->dev,
+				  priv->sOpts.nTxDescs[0] * PKT_BUF_SZ +
+				  priv->sOpts.nTxDescs[1] * PKT_BUF_SZ +
+				  CB_BEACON_BUF_SIZE +
+				  CB_MAX_BUF_SIZE,
+				  priv->tx0_bufs, priv->tx_bufs_dma0);
 }
 
-static void device_init_rd0_ring(struct vnt_private *pDevice)
+static void device_init_rd0_ring(struct vnt_private *priv)
 {
 	int i;
-	dma_addr_t      curr = pDevice->rd0_pool_dma;
+	dma_addr_t      curr = priv->rd0_pool_dma;
 	struct vnt_rx_desc *pDesc;
 
 	/* Init the RD0 ring entries */
-	for (i = 0; i < pDevice->sOpts.nRxDescs0;
+	for (i = 0; i < priv->sOpts.nRxDescs0;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
-		pDesc = &(pDevice->aRD0Ring[i]);
+		pDesc = &(priv->aRD0Ring[i]);
 		pDesc->rd_info = alloc_rd_info();
 
-		if (!device_alloc_rx_buf(pDevice, pDesc))
-			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
+		if (!device_alloc_rx_buf(priv, pDesc))
+			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
 
-		pDesc->next = &(pDevice->aRD0Ring[(i+1) % pDevice->sOpts.nRxDescs0]);
+		pDesc->next = &(priv->aRD0Ring[(i+1) % priv->sOpts.nRxDescs0]);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
 	if (i > 0)
-		pDevice->aRD0Ring[i-1].next_desc = cpu_to_le32(pDevice->rd0_pool_dma);
-	pDevice->pCurrRD[0] = &(pDevice->aRD0Ring[0]);
+		priv->aRD0Ring[i-1].next_desc = cpu_to_le32(priv->rd0_pool_dma);
+	priv->pCurrRD[0] = &priv->aRD0Ring[0];
 }
 
-static void device_init_rd1_ring(struct vnt_private *pDevice)
+static void device_init_rd1_ring(struct vnt_private *priv)
 {
 	int i;
-	dma_addr_t      curr = pDevice->rd1_pool_dma;
+	dma_addr_t      curr = priv->rd1_pool_dma;
 	struct vnt_rx_desc *pDesc;
 
 	/* Init the RD1 ring entries */
-	for (i = 0; i < pDevice->sOpts.nRxDescs1;
+	for (i = 0; i < priv->sOpts.nRxDescs1;
 	     i ++, curr += sizeof(struct vnt_rx_desc)) {
-		pDesc = &(pDevice->aRD1Ring[i]);
+		pDesc = &(priv->aRD1Ring[i]);
 		pDesc->rd_info = alloc_rd_info();
 
-		if (!device_alloc_rx_buf(pDevice, pDesc))
-			dev_err(&pDevice->pcid->dev, "can not alloc rx bufs\n");
+		if (!device_alloc_rx_buf(priv, pDesc))
+			dev_err(&priv->pcid->dev, "can not alloc rx bufs\n");
 
-		pDesc->next = &(pDevice->aRD1Ring[(i+1) % pDevice->sOpts.nRxDescs1]);
+		pDesc->next = &(priv->aRD1Ring[(i+1) % priv->sOpts.nRxDescs1]);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_rx_desc));
 	}
 
 	if (i > 0)
-		pDevice->aRD1Ring[i-1].next_desc = cpu_to_le32(pDevice->rd1_pool_dma);
-	pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
+		priv->aRD1Ring[i-1].next_desc = cpu_to_le32(priv->rd1_pool_dma);
+	priv->pCurrRD[1] = &priv->aRD1Ring[0];
 }
 
-static void device_free_rd0_ring(struct vnt_private *pDevice)
+static void device_free_rd0_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < pDevice->sOpts.nRxDescs0; i++) {
-		struct vnt_rx_desc *pDesc = &(pDevice->aRD0Ring[i]);
+	for (i = 0; i < priv->sOpts.nRxDescs0; i++) {
+		struct vnt_rx_desc *pDesc = &(priv->aRD0Ring[i]);
 		struct vnt_rd_info *rd_info = pDesc->rd_info;
 
-		dma_unmap_single(&pDevice->pcid->dev, rd_info->skb_dma,
-				 pDevice->rx_buf_sz, DMA_FROM_DEVICE);
+		dma_unmap_single(&priv->pcid->dev, rd_info->skb_dma,
+				 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 		dev_kfree_skb(rd_info->skb);
 
@@ -610,16 +606,16 @@ static void device_free_rd0_ring(struct vnt_private *pDevice)
 	}
 }
 
-static void device_free_rd1_ring(struct vnt_private *pDevice)
+static void device_free_rd1_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < pDevice->sOpts.nRxDescs1; i++) {
-		struct vnt_rx_desc *pDesc = &(pDevice->aRD1Ring[i]);
+	for (i = 0; i < priv->sOpts.nRxDescs1; i++) {
+		struct vnt_rx_desc *pDesc = &(priv->aRD1Ring[i]);
 		struct vnt_rd_info *rd_info = pDesc->rd_info;
 
-		dma_unmap_single(&pDevice->pcid->dev, rd_info->skb_dma,
-				 pDevice->rx_buf_sz, DMA_FROM_DEVICE);
+		dma_unmap_single(&priv->pcid->dev, rd_info->skb_dma,
+				 priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 		dev_kfree_skb(rd_info->skb);
 
@@ -627,61 +623,61 @@ static void device_free_rd1_ring(struct vnt_private *pDevice)
 	}
 }
 
-static void device_init_td0_ring(struct vnt_private *pDevice)
+static void device_init_td0_ring(struct vnt_private *priv)
 {
 	int i;
 	dma_addr_t  curr;
 	struct vnt_tx_desc *pDesc;
 
-	curr = pDevice->td0_pool_dma;
-	for (i = 0; i < pDevice->sOpts.nTxDescs[0];
+	curr = priv->td0_pool_dma;
+	for (i = 0; i < priv->sOpts.nTxDescs[0];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
-		pDesc = &(pDevice->apTD0Rings[i]);
+		pDesc = &(priv->apTD0Rings[i]);
 		pDesc->td_info = alloc_td_info();
 
-		pDesc->td_info->buf = pDevice->tx0_bufs + i * PKT_BUF_SZ;
-		pDesc->td_info->buf_dma = pDevice->tx_bufs_dma0 + i * PKT_BUF_SZ;
+		pDesc->td_info->buf = priv->tx0_bufs + i * PKT_BUF_SZ;
+		pDesc->td_info->buf_dma = priv->tx_bufs_dma0 + i * PKT_BUF_SZ;
 
-		pDesc->next = &(pDevice->apTD0Rings[(i+1) % pDevice->sOpts.nTxDescs[0]]);
+		pDesc->next = &(priv->apTD0Rings[(i+1) % priv->sOpts.nTxDescs[0]]);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
 	if (i > 0)
-		pDevice->apTD0Rings[i-1].next_desc = cpu_to_le32(pDevice->td0_pool_dma);
-	pDevice->apTailTD[0] = pDevice->apCurrTD[0] = &(pDevice->apTD0Rings[0]);
+		priv->apTD0Rings[i-1].next_desc = cpu_to_le32(priv->td0_pool_dma);
+	priv->apTailTD[0] = priv->apCurrTD[0] = &priv->apTD0Rings[0];
 }
 
-static void device_init_td1_ring(struct vnt_private *pDevice)
+static void device_init_td1_ring(struct vnt_private *priv)
 {
 	int i;
 	dma_addr_t  curr;
 	struct vnt_tx_desc *pDesc;
 
 	/* Init the TD ring entries */
-	curr = pDevice->td1_pool_dma;
-	for (i = 0; i < pDevice->sOpts.nTxDescs[1];
+	curr = priv->td1_pool_dma;
+	for (i = 0; i < priv->sOpts.nTxDescs[1];
 	     i++, curr += sizeof(struct vnt_tx_desc)) {
-		pDesc = &(pDevice->apTD1Rings[i]);
+		pDesc = &(priv->apTD1Rings[i]);
 		pDesc->td_info = alloc_td_info();
 
-		pDesc->td_info->buf = pDevice->tx1_bufs + i * PKT_BUF_SZ;
-		pDesc->td_info->buf_dma = pDevice->tx_bufs_dma1 + i * PKT_BUF_SZ;
+		pDesc->td_info->buf = priv->tx1_bufs + i * PKT_BUF_SZ;
+		pDesc->td_info->buf_dma = priv->tx_bufs_dma1 + i * PKT_BUF_SZ;
 
-		pDesc->next = &(pDevice->apTD1Rings[(i + 1) % pDevice->sOpts.nTxDescs[1]]);
+		pDesc->next = &(priv->apTD1Rings[(i + 1) % priv->sOpts.nTxDescs[1]]);
 		pDesc->next_desc = cpu_to_le32(curr + sizeof(struct vnt_tx_desc));
 	}
 
 	if (i > 0)
-		pDevice->apTD1Rings[i-1].next_desc = cpu_to_le32(pDevice->td1_pool_dma);
-	pDevice->apTailTD[1] = pDevice->apCurrTD[1] = &(pDevice->apTD1Rings[0]);
+		priv->apTD1Rings[i-1].next_desc = cpu_to_le32(priv->td1_pool_dma);
+	priv->apTailTD[1] = priv->apCurrTD[1] = &priv->apTD1Rings[0];
 }
 
-static void device_free_td0_ring(struct vnt_private *pDevice)
+static void device_free_td0_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < pDevice->sOpts.nTxDescs[0]; i++) {
-		struct vnt_tx_desc *pDesc = &pDevice->apTD0Rings[i];
+	for (i = 0; i < priv->sOpts.nTxDescs[0]; i++) {
+		struct vnt_tx_desc *pDesc = &priv->apTD0Rings[i];
 		struct vnt_td_info *pTDInfo = pDesc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
@@ -689,12 +685,12 @@ static void device_free_td0_ring(struct vnt_private *pDevice)
 	}
 }
 
-static void device_free_td1_ring(struct vnt_private *pDevice)
+static void device_free_td1_ring(struct vnt_private *priv)
 {
 	int i;
 
-	for (i = 0; i < pDevice->sOpts.nTxDescs[1]; i++) {
-		struct vnt_tx_desc *pDesc = &pDevice->apTD1Rings[i];
+	for (i = 0; i < priv->sOpts.nTxDescs[1]; i++) {
+		struct vnt_tx_desc *pDesc = &priv->apTD1Rings[i];
 		struct vnt_td_info *pTDInfo = pDesc->td_info;
 
 		dev_kfree_skb(pTDInfo->skb);
@@ -704,12 +700,12 @@ static void device_free_td1_ring(struct vnt_private *pDevice)
 
 /*-----------------------------------------------------------------*/
 
-static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
+static int device_rx_srv(struct vnt_private *priv, unsigned int uIdx)
 {
 	struct vnt_rx_desc *pRD;
 	int works = 0;
 
-	for (pRD = pDevice->pCurrRD[uIdx];
+	for (pRD = priv->pCurrRD[uIdx];
 	     pRD->rd0.owner == OWNED_BY_HOST;
 	     pRD = pRD->next) {
 		if (works++ > 15)
@@ -718,9 +714,9 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 		if (!pRD->rd_info->skb)
 			break;
 
-		if (vnt_receive_frame(pDevice, pRD)) {
-			if (!device_alloc_rx_buf(pDevice, pRD)) {
-				dev_err(&pDevice->pcid->dev,
+		if (vnt_receive_frame(priv, pRD)) {
+			if (!device_alloc_rx_buf(priv, pRD)) {
+				dev_err(&priv->pcid->dev,
 					"can not allocate rx buf\n");
 				break;
 			}
@@ -728,30 +724,30 @@ static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 		pRD->rd0.owner = OWNED_BY_NIC;
 	}
 
-	pDevice->pCurrRD[uIdx] = pRD;
+	priv->pCurrRD[uIdx] = pRD;
 
 	return works;
 }
 
-static bool device_alloc_rx_buf(struct vnt_private *pDevice,
+static bool device_alloc_rx_buf(struct vnt_private *priv,
 				struct vnt_rx_desc *pRD)
 {
 	struct vnt_rd_info *pRDInfo = pRD->rd_info;
 
-	pRDInfo->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
+	pRDInfo->skb = dev_alloc_skb((int)priv->rx_buf_sz);
 	if (pRDInfo->skb == NULL)
 		return false;
 
 	pRDInfo->skb_dma =
-		dma_map_single(&pDevice->pcid->dev,
+		dma_map_single(&priv->pcid->dev,
 			       skb_put(pRDInfo->skb, skb_tailroom(pRDInfo->skb)),
-			       pDevice->rx_buf_sz, DMA_FROM_DEVICE);
+			       priv->rx_buf_sz, DMA_FROM_DEVICE);
 
 	*((unsigned int *)&pRD->rd0) = 0; /* FIX cast */
 
-	pRD->rd0.res_count = cpu_to_le16(pDevice->rx_buf_sz);
+	pRD->rd0.res_count = cpu_to_le16(priv->rx_buf_sz);
 	pRD->rd0.owner = OWNED_BY_NIC;
-	pRD->rd1.req_count = cpu_to_le16(pDevice->rx_buf_sz);
+	pRD->rd1.req_count = cpu_to_le16(priv->rx_buf_sz);
 	pRD->buff_addr = cpu_to_le32(pRDInfo->skb_dma);
 
 	return true;
@@ -833,14 +829,14 @@ static int vnt_int_report_rate(struct vnt_private *priv,
 	return 0;
 }
 
-static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
+static int device_tx_srv(struct vnt_private *priv, unsigned int uIdx)
 {
 	struct vnt_tx_desc *pTD;
 	int                      works = 0;
 	unsigned char byTsr0;
 	unsigned char byTsr1;
 
-	for (pTD = pDevice->apTailTD[uIdx]; pDevice->iTDUsed[uIdx] > 0; pTD = pTD->next) {
+	for (pTD = priv->apTailTD[uIdx]; priv->iTDUsed[uIdx] > 0; pTD = pTD->next) {
 		if (pTD->td0.owner == OWNED_BY_NIC)
 			break;
 		if (works++ > 15)
@@ -871,36 +867,36 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 				}
 			}
 
-			vnt_int_report_rate(pDevice, pTD->td_info, byTsr0, byTsr1);
+			vnt_int_report_rate(priv, pTD->td_info, byTsr0, byTsr1);
 
-			device_free_tx_buf(pDevice, pTD);
-			pDevice->iTDUsed[uIdx]--;
+			device_free_tx_buf(priv, pTD);
+			priv->iTDUsed[uIdx]--;
 		}
 	}
 
-	pDevice->apTailTD[uIdx] = pTD;
+	priv->apTailTD[uIdx] = pTD;
 
 	return works;
 }
 
-static void device_error(struct vnt_private *pDevice, unsigned short status)
+static void device_error(struct vnt_private *priv, unsigned short status)
 {
 	if (status & ISR_FETALERR) {
-		dev_err(&pDevice->pcid->dev, "Hardware fatal error\n");
+		dev_err(&priv->pcid->dev, "Hardware fatal error\n");
 
-		MACbShutdown(pDevice->PortOffset);
+		MACbShutdown(priv->PortOffset);
 		return;
 	}
 }
 
-static void device_free_tx_buf(struct vnt_private *pDevice,
+static void device_free_tx_buf(struct vnt_private *priv,
 			       struct vnt_tx_desc *pDesc)
 {
 	struct vnt_td_info *pTDInfo = pDesc->td_info;
 	struct sk_buff *skb = pTDInfo->skb;
 
 	if (skb)
-		ieee80211_tx_status_irqsafe(pDevice->hw, skb);
+		ieee80211_tx_status_irqsafe(priv->hw, skb);
 
 	pTDInfo->skb = NULL;
 	pTDInfo->flags = 0;
-- 
2.5.0

