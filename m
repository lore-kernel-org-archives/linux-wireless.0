Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:40870 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbaGPVX1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:27 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so1547637wes.28
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:25 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/21] staging: vt6656: device_init_registers remove camel case
Date: Wed, 16 Jul 2014 22:22:01 +0100
Message-Id: <1405545731-6082-11-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232415_047576_2904C94C)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

camel case changes
pDevice -> priv
byAntenna -> antenna
ntStatus -> status
byTmp-> tmp
byCalibTXIQ -> calib_tx_iq
byCalibTXDC -> calib_tx_dc
byCalibRXIQ -> calib_rx_iq

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 234 +++++++++++++++++++-------------------
 1 file changed, 117 insertions(+), 117 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 37541f0..12f93c7 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -220,22 +220,22 @@ static void device_set_options(struct vnt_private *priv)
 /*
  * initialization of MAC & BBP registers
  */
-static int device_init_registers(struct vnt_private *pDevice)
+static int device_init_registers(struct vnt_private *priv)
 {
-	struct vnt_cmd_card_init *init_cmd = &pDevice->init_command;
-	struct vnt_rsp_card_init *init_rsp = &pDevice->init_response;
-	u8 byAntenna;
+	struct vnt_cmd_card_init *init_cmd = &priv->init_command;
+	struct vnt_rsp_card_init *init_rsp = &priv->init_response;
+	u8 antenna;
 	int ii;
-	int ntStatus = STATUS_SUCCESS;
-	u8 byTmp;
-	u8 byCalibTXIQ = 0, byCalibTXDC = 0, byCalibRXIQ = 0;
+	int status = STATUS_SUCCESS;
+	u8 tmp;
+	u8 calib_tx_iq = 0, calib_tx_dc = 0, calib_rx_iq = 0;
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n",
-				DEVICE_INIT_COLD, pDevice->byPacketType);
+				DEVICE_INIT_COLD, priv->byPacketType);
 
-	if (!vnt_check_firmware_version(pDevice)) {
-		if (vnt_download_firmware(pDevice) == true) {
-			if (vnt_firmware_branch_to_sram(pDevice) == false) {
+	if (!vnt_check_firmware_version(priv)) {
+		if (vnt_download_firmware(priv) == true) {
+			if (vnt_firmware_branch_to_sram(priv) == false) {
 				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 					" vnt_firmware_branch_to_sram fail\n");
 				return false;
@@ -247,63 +247,63 @@ static int device_init_registers(struct vnt_private *pDevice)
 		}
 	}
 
-	if (!vnt_vt3184_init(pDevice)) {
+	if (!vnt_vt3184_init(priv)) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" vnt_vt3184_init fail\n");
 		return false;
 	}
 
 	init_cmd->init_class = DEVICE_INIT_COLD;
-	init_cmd->exist_sw_net_addr = (u8) pDevice->bExistSWNetAddr;
+	init_cmd->exist_sw_net_addr = (u8) priv->bExistSWNetAddr;
 	for (ii = 0; ii < 6; ii++)
-		init_cmd->sw_net_addr[ii] = pDevice->abyCurrentNetAddr[ii];
-	init_cmd->short_retry_limit = pDevice->byShortRetryLimit;
-	init_cmd->long_retry_limit = pDevice->byLongRetryLimit;
+		init_cmd->sw_net_addr[ii] = priv->abyCurrentNetAddr[ii];
+	init_cmd->short_retry_limit = priv->byShortRetryLimit;
+	init_cmd->long_retry_limit = priv->byLongRetryLimit;
 
 	/* issue card_init command to device */
-	ntStatus = vnt_control_out(pDevice,
+	status = vnt_control_out(priv,
 		MESSAGE_TYPE_CARDINIT, 0, 0,
 		sizeof(struct vnt_cmd_card_init), (u8 *)init_cmd);
-	if (ntStatus != STATUS_SUCCESS) {
+	if (status != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail\n");
 		return false;
 	}
 
-	ntStatus = vnt_control_in(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
+	status = vnt_control_in(priv, MESSAGE_TYPE_INIT_RSP, 0, 0,
 		sizeof(struct vnt_rsp_card_init), (u8 *)init_rsp);
-	if (ntStatus != STATUS_SUCCESS) {
+	if (status != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
 			"Cardinit request in status fail!\n");
 		return false;
 	}
 
 	/* local ID for AES functions */
-	ntStatus = vnt_control_in(pDevice, MESSAGE_TYPE_READ,
+	status = vnt_control_in(priv, MESSAGE_TYPE_READ,
 		MAC_REG_LOCALID, MESSAGE_REQUEST_MACREG, 1,
-			&pDevice->byLocalID);
-	if (ntStatus != STATUS_SUCCESS)
+			&priv->byLocalID);
+	if (status != STATUS_SUCCESS)
 		return false;
 
 	/* do MACbSoftwareReset in MACvInitialize */
 
-	pDevice->byTopOFDMBasicRate = RATE_24M;
-	pDevice->byTopCCKBasicRate = RATE_1M;
+	priv->byTopOFDMBasicRate = RATE_24M;
+	priv->byTopCCKBasicRate = RATE_1M;
 
 	/* target to IF pin while programming to RF chip */
-	pDevice->byCurPwr = 0xFF;
+	priv->byCurPwr = 0xFF;
 
-	pDevice->byCCKPwr = pDevice->abyEEPROM[EEP_OFS_PWR_CCK];
-	pDevice->byOFDMPwrG = pDevice->abyEEPROM[EEP_OFS_PWR_OFDMG];
+	priv->byCCKPwr = priv->abyEEPROM[EEP_OFS_PWR_CCK];
+	priv->byOFDMPwrG = priv->abyEEPROM[EEP_OFS_PWR_OFDMG];
 	/* load power table */
 	for (ii = 0; ii < 14; ii++) {
-		pDevice->abyCCKPwrTbl[ii] =
-			pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
-
-		if (pDevice->abyCCKPwrTbl[ii] == 0)
-			pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
-		pDevice->abyOFDMPwrTbl[ii] =
-				pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
-		if (pDevice->abyOFDMPwrTbl[ii] == 0)
-			pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
+		priv->abyCCKPwrTbl[ii] =
+			priv->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
+
+		if (priv->abyCCKPwrTbl[ii] == 0)
+			priv->abyCCKPwrTbl[ii] = priv->byCCKPwr;
+		priv->abyOFDMPwrTbl[ii] =
+				priv->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
+		if (priv->abyOFDMPwrTbl[ii] == 0)
+			priv->abyOFDMPwrTbl[ii] = priv->byOFDMPwrG;
 	}
 
 	/*
@@ -311,111 +311,111 @@ static int device_init_registers(struct vnt_private *pDevice)
 	 * then need to recover 12, 13, 14 channels with 11 channel
 	 */
 	for (ii = 11; ii < 14; ii++) {
-		pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
-		pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
+		priv->abyCCKPwrTbl[ii] = priv->abyCCKPwrTbl[10];
+		priv->abyOFDMPwrTbl[ii] = priv->abyOFDMPwrTbl[10];
 	}
 
-	pDevice->byOFDMPwrA = 0x34; /* same as RFbMA2829SelectChannel */
+	priv->byOFDMPwrA = 0x34; /* same as RFbMA2829SelectChannel */
 
 	/* load OFDM A power table */
 	for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
-		pDevice->abyOFDMAPwrTbl[ii] =
-			pDevice->abyEEPROM[ii + EEP_OFS_OFDMA_PWR_TBL];
+		priv->abyOFDMAPwrTbl[ii] =
+			priv->abyEEPROM[ii + EEP_OFS_OFDMA_PWR_TBL];
 
-		if (pDevice->abyOFDMAPwrTbl[ii] == 0)
-			pDevice->abyOFDMAPwrTbl[ii] = pDevice->byOFDMPwrA;
+		if (priv->abyOFDMAPwrTbl[ii] == 0)
+			priv->abyOFDMAPwrTbl[ii] = priv->byOFDMPwrA;
 	}
 
-	byAntenna = pDevice->abyEEPROM[EEP_OFS_ANTENNA];
+	antenna = priv->abyEEPROM[EEP_OFS_ANTENNA];
 
-	if (byAntenna & EEP_ANTINV)
-		pDevice->bTxRxAntInv = true;
+	if (antenna & EEP_ANTINV)
+		priv->bTxRxAntInv = true;
 	else
-		pDevice->bTxRxAntInv = false;
+		priv->bTxRxAntInv = false;
 
-	byAntenna &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+	antenna &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
-	if (byAntenna == 0) /* if not set default is both */
-		byAntenna = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+	if (antenna == 0) /* if not set default is both */
+		antenna = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
-	if (byAntenna == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
-		pDevice->byAntennaCount = 2;
-		pDevice->byTxAntennaMode = ANT_B;
-		pDevice->dwTxAntennaSel = 1;
-		pDevice->dwRxAntennaSel = 1;
+	if (antenna == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
+		priv->byAntennaCount = 2;
+		priv->byTxAntennaMode = ANT_B;
+		priv->dwTxAntennaSel = 1;
+		priv->dwRxAntennaSel = 1;
 
-		if (pDevice->bTxRxAntInv == true)
-			pDevice->byRxAntennaMode = ANT_A;
+		if (priv->bTxRxAntInv == true)
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
 
-		if (byAntenna & EEP_ANTENNA_AUX) {
-			pDevice->byTxAntennaMode = ANT_A;
+		if (antenna & EEP_ANTENNA_AUX) {
+			priv->byTxAntennaMode = ANT_A;
 
-			if (pDevice->bTxRxAntInv == true)
-				pDevice->byRxAntennaMode = ANT_B;
+			if (priv->bTxRxAntInv == true)
+				priv->byRxAntennaMode = ANT_B;
 			else
-				pDevice->byRxAntennaMode = ANT_A;
+				priv->byRxAntennaMode = ANT_A;
 		} else {
-			pDevice->byTxAntennaMode = ANT_B;
+			priv->byTxAntennaMode = ANT_B;
 
-		if (pDevice->bTxRxAntInv == true)
-			pDevice->byRxAntennaMode = ANT_A;
+		if (priv->bTxRxAntInv == true)
+			priv->byRxAntennaMode = ANT_A;
 		else
-			pDevice->byRxAntennaMode = ANT_B;
+			priv->byRxAntennaMode = ANT_B;
 		}
 	}
 
 	/* Set initial antenna mode */
-	vnt_set_antenna_mode(pDevice, pDevice->byRxAntennaMode);
+	vnt_set_antenna_mode(priv, priv->byRxAntennaMode);
 
 	/* get Auto Fall Back type */
-	pDevice->byAutoFBCtrl = AUTO_FB_0;
+	priv->byAutoFBCtrl = AUTO_FB_0;
 
 	/* default Auto Mode */
-	pDevice->byBBType = BB_TYPE_11G;
+	priv->byBBType = BB_TYPE_11G;
 
 	/* get RFType */
-	pDevice->byRFType = init_rsp->rf_type;
+	priv->byRFType = init_rsp->rf_type;
 
 	/* load vt3266 calibration parameters in EEPROM */
-	if (pDevice->byRFType == RF_VT3226D0) {
-		if ((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
-		    (pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
-
-			byCalibTXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
-			byCalibTXDC = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_DC];
-			byCalibRXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
-			if (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) {
+	if (priv->byRFType == RF_VT3226D0) {
+		if ((priv->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
+		    (priv->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
+
+			calib_tx_iq = priv->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
+			calib_tx_dc = priv->abyEEPROM[EEP_OFS_CALIB_TX_DC];
+			calib_rx_iq = priv->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
+			if (calib_tx_iq || calib_tx_dc || calib_rx_iq) {
 				/* CR255, enable TX/RX IQ and
 				   DC compensation mode */
-				vnt_control_out_u8(pDevice,
+				vnt_control_out_u8(priv,
 						   MESSAGE_REQUEST_BBREG,
 						   0xff,
 						   0x03);
 				/* CR251, TX I/Q Imbalance Calibration */
-				vnt_control_out_u8(pDevice,
+				vnt_control_out_u8(priv,
 						   MESSAGE_REQUEST_BBREG,
 						   0xfb,
-						   byCalibTXIQ);
+						   calib_tx_iq);
 				/* CR252, TX DC-Offset Calibration */
-				vnt_control_out_u8(pDevice,
+				vnt_control_out_u8(priv,
 						   MESSAGE_REQUEST_BBREG,
 						   0xfC,
-						   byCalibTXDC);
+						   calib_tx_dc);
 				/* CR253, RX I/Q Imbalance Calibration */
-				vnt_control_out_u8(pDevice,
+				vnt_control_out_u8(priv,
 						   MESSAGE_REQUEST_BBREG,
 						   0xfd,
-						   byCalibRXIQ);
+						   calib_rx_iq);
 			} else {
 				/* CR255, turn off
 				   BB Calibration compensation */
-				vnt_control_out_u8(pDevice,
+				vnt_control_out_u8(priv,
 						   MESSAGE_REQUEST_BBREG,
 						   0xff,
 						   0x0);
@@ -424,58 +424,58 @@ static int device_init_registers(struct vnt_private *pDevice)
 	}
 
 	/* get permanent network address */
-	memcpy(pDevice->abyPermanentNetAddr, init_rsp->net_addr, 6);
-	memcpy(pDevice->abyCurrentNetAddr,
-				pDevice->abyPermanentNetAddr, ETH_ALEN);
+	memcpy(priv->abyPermanentNetAddr, init_rsp->net_addr, 6);
+	memcpy(priv->abyCurrentNetAddr,
+				priv->abyPermanentNetAddr, ETH_ALEN);
 
 	/* if exist SW network address, use it */
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
-		pDevice->abyCurrentNetAddr);
+		priv->abyCurrentNetAddr);
 
 	/*
 	* set BB and packet type at the same time
 	* set Short Slot Time, xIFS, and RSPINF
 	*/
-	if (pDevice->byBBType == BB_TYPE_11A)
-		pDevice->bShortSlotTime = true;
+	if (priv->byBBType == BB_TYPE_11A)
+		priv->bShortSlotTime = true;
 	else
-		pDevice->bShortSlotTime = false;
+		priv->bShortSlotTime = false;
 
-	vnt_set_short_slot_time(pDevice);
+	vnt_set_short_slot_time(priv);
 
-	pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
-	pDevice->bHWRadioOff = false;
+	priv->byRadioCtl = priv->abyEEPROM[EEP_OFS_RADIOCTL];
+	priv->bHWRadioOff = false;
 
-	if ((pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0) {
-		ntStatus = vnt_control_in(pDevice, MESSAGE_TYPE_READ,
-			MAC_REG_GPIOCTL1, MESSAGE_REQUEST_MACREG, 1, &byTmp);
+	if ((priv->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0) {
+		status = vnt_control_in(priv, MESSAGE_TYPE_READ,
+			MAC_REG_GPIOCTL1, MESSAGE_REQUEST_MACREG, 1, &tmp);
 
-		if (ntStatus != STATUS_SUCCESS)
+		if (status != STATUS_SUCCESS)
 			return false;
 
-		if ((byTmp & GPIO3_DATA) == 0) {
-			pDevice->bHWRadioOff = true;
-			vnt_mac_reg_bits_on(pDevice, MAC_REG_GPIOCTL1,
+		if ((tmp & GPIO3_DATA) == 0) {
+			priv->bHWRadioOff = true;
+			vnt_mac_reg_bits_on(priv, MAC_REG_GPIOCTL1,
 								GPIO3_INTMD);
 		} else {
-			vnt_mac_reg_bits_off(pDevice, MAC_REG_GPIOCTL1,
+			vnt_mac_reg_bits_off(priv, MAC_REG_GPIOCTL1,
 								GPIO3_INTMD);
-			pDevice->bHWRadioOff = false;
+			priv->bHWRadioOff = false;
 		}
 
 	}
 
-	vnt_mac_set_led(pDevice, LEDSTS_TMLEN, 0x38);
+	vnt_mac_set_led(priv, LEDSTS_TMLEN, 0x38);
 
-	vnt_mac_set_led(pDevice, LEDSTS_STS, LEDSTS_SLOW);
+	vnt_mac_set_led(priv, LEDSTS_STS, LEDSTS_SLOW);
 
-	vnt_mac_reg_bits_on(pDevice, MAC_REG_GPIOCTL0, 0x01);
+	vnt_mac_reg_bits_on(priv, MAC_REG_GPIOCTL0, 0x01);
 
-	if ((pDevice->bHWRadioOff == true) ||
-				(pDevice->bRadioControlOff == true)) {
-		vnt_radio_power_off(pDevice);
+	if ((priv->bHWRadioOff == true) ||
+				(priv->bRadioControlOff == true)) {
+		vnt_radio_power_off(priv);
 	} else {
-		vnt_radio_power_on(pDevice);
+		vnt_radio_power_on(priv);
 	}
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
-- 
2.0.1

