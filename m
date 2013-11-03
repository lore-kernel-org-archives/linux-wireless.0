Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:49865 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3KCRw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 12:52:28 -0500
Received: by mail-we0-f169.google.com with SMTP id q58so1296902wes.14
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2013 09:52:27 -0800 (PST)
Message-ID: <1383501135.3758.29.camel@canaries32-MCP7A> (sfid-20131103_185231_805153_828D1E1B)
Subject: [PATCH 5/5] staging: vt6656: cleanup device_init_registers
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Nov 2013 17:52:15 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

White space and formatting clean up.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 227 +++++++++++++++++++-------------------
 1 file changed, 116 insertions(+), 111 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index ba39aaa..21805c6 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -294,7 +294,6 @@ static void device_init_diversity_timer(struct vnt_private *pDevice)
 /*
  * initialization of MAC & BBP registers
  */
-
 static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
@@ -317,30 +316,29 @@ static int device_init_registers(struct vnt_private *pDevice)
 
 	memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
 	memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
-	memcpy(pDevice->abySNAP_Bridgetunnel,
-		       abySNAP_Bridgetunnel,
-		       ETH_ALEN);
-
-        if ( !FIRMWAREbCheckVersion(pDevice) ) {
-            if (FIRMWAREbDownload(pDevice) == true) {
-                if (FIRMWAREbBrach2Sram(pDevice) == false) {
-                    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" FIRMWAREbBrach2Sram fail \n");
-                  	spin_unlock_irq(&pDevice->lock);
-                    return false;
-                }
-            } else {
-
-                DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" FIRMWAREbDownload fail \n");
-                spin_unlock_irq(&pDevice->lock);
-                return false;
-            }
-        }
+	memcpy(pDevice->abySNAP_Bridgetunnel, abySNAP_Bridgetunnel, ETH_ALEN);
+
+	if (!FIRMWAREbCheckVersion(pDevice)) {
+		if (FIRMWAREbDownload(pDevice) == true) {
+			if (FIRMWAREbBrach2Sram(pDevice) == false) {
+				DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+					" FIRMWAREbBrach2Sram fail\n");
+				spin_unlock_irq(&pDevice->lock);
+				return false;
+			}
+		} else {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+				" FIRMWAREbDownload fail\n");
+			spin_unlock_irq(&pDevice->lock);
+			return false;
+		}
+	}
 
-        if ( !BBbVT3184Init(pDevice) ) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" BBbVT3184Init fail \n");
-            spin_unlock_irq(&pDevice->lock);
-            return false;
-        }
+	if (!BBbVT3184Init(pDevice)) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" BBbVT3184Init fail\n");
+		spin_unlock_irq(&pDevice->lock);
+		return false;
+	}
 
 	init_cmd->init_class = DEVICE_INIT_COLD;
 	init_cmd->exist_sw_net_addr = (u8) pDevice->bExistSWNetAddr;
@@ -353,12 +351,11 @@ static int device_init_registers(struct vnt_private *pDevice)
 	ntStatus = CONTROLnsRequestOut(pDevice,
 		MESSAGE_TYPE_CARDINIT, 0, 0,
 		sizeof(struct vnt_cmd_card_init), (u8 *)init_cmd);
-
-    if ( ntStatus != STATUS_SUCCESS ) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail \n");
-        spin_unlock_irq(&pDevice->lock);
-        return false;
-    }
+	if (ntStatus != STATUS_SUCCESS) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO" Issue Card init fail\n");
+		spin_unlock_irq(&pDevice->lock);
+		return false;
+	}
 
 	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
 		sizeof(struct vnt_rsp_card_init), (u8 *)init_rsp);
@@ -500,30 +497,30 @@ static int device_init_registers(struct vnt_private *pDevice)
 	pDevice->byTMax3 = 64;
 
 	/* get Auto Fall Back type */
-        pDevice->byAutoFBCtrl = AUTO_FB_0;
+	pDevice->byAutoFBCtrl = AUTO_FB_0;
 
 	/* set SCAN Time */
-        pDevice->uScanTime = WLAN_SCAN_MINITIME;
+	pDevice->uScanTime = WLAN_SCAN_MINITIME;
 
 	/* default Auto Mode */
 	/* pDevice->NetworkType = Ndis802_11Automode; */
-        pDevice->eConfigPHYMode = PHY_TYPE_AUTO;
-        pDevice->byBBType = BB_TYPE_11G;
+	pDevice->eConfigPHYMode = PHY_TYPE_AUTO;
+	pDevice->byBBType = BB_TYPE_11G;
 
 	/* initialize BBP registers */
-        pDevice->ulTxPower = 25;
+	pDevice->ulTxPower = 25;
 
 	/* get channel range */
-        pDevice->byMinChannel = 1;
-        pDevice->byMaxChannel = CB_MAX_CHANNEL;
+	pDevice->byMinChannel = 1;
+	pDevice->byMaxChannel = CB_MAX_CHANNEL;
 
 	/* get RFType */
 	pDevice->byRFType = init_rsp->rf_type;
 
-        if ((pDevice->byRFType & RF_EMU) != 0) {
+	if ((pDevice->byRFType & RF_EMU) != 0) {
 		/* force change RevID for VT3253 emu */
 		pDevice->byRevId = 0x80;
-        }
+	}
 
 	/* load vt3266 calibration parameters in EEPROM */
 	if (pDevice->byRFType == RF_VT3226D0) {
@@ -536,105 +533,113 @@ static int device_init_registers(struct vnt_private *pDevice)
 			if (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) {
 			/* CR255, enable TX/RX IQ and DC compensation mode */
 				ControlvWriteByte(pDevice,
-					  MESSAGE_REQUEST_BBREG,
-					  0xFF,
-					  0x03);
+					MESSAGE_REQUEST_BBREG,
+					0xff,
+					0x03);
 			/* CR251, TX I/Q Imbalance Calibration */
 				ControlvWriteByte(pDevice,
-					  MESSAGE_REQUEST_BBREG,
-					  0xFB,
-					  byCalibTXIQ);
+					MESSAGE_REQUEST_BBREG,
+					0xfb,
+					byCalibTXIQ);
 			/* CR252, TX DC-Offset Calibration */
 				ControlvWriteByte(pDevice,
-					  MESSAGE_REQUEST_BBREG,
-					  0xFC,
-					  byCalibTXDC);
+					MESSAGE_REQUEST_BBREG,
+					0xfC,
+					byCalibTXDC);
 			/* CR253, RX I/Q Imbalance Calibration */
 				ControlvWriteByte(pDevice,
-					  MESSAGE_REQUEST_BBREG,
-					  0xFD,
-					  byCalibRXIQ);
+					MESSAGE_REQUEST_BBREG,
+					0xfd,
+					byCalibRXIQ);
 			} else {
 			/* CR255, turn off BB Calibration compensation */
 				ControlvWriteByte(pDevice,
-					  MESSAGE_REQUEST_BBREG,
-					  0xFF,
-					  0x0);
+					MESSAGE_REQUEST_BBREG,
+					0xff,
+					0x0);
 			}
 		}
 	}
-        pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-        pMgmt->uCurrChannel = pDevice->uChannel;
-        pMgmt->uIBSSChannel = pDevice->uChannel;
-        CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
+
+	pMgmt->eScanType = WMAC_SCAN_PASSIVE;
+	pMgmt->uCurrChannel = pDevice->uChannel;
+	pMgmt->uIBSSChannel = pDevice->uChannel;
+	CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
 
 	/* get permanent network address */
 	memcpy(pDevice->abyPermanentNetAddr, init_rsp->net_addr, 6);
 	memcpy(pDevice->abyCurrentNetAddr,
-	       pDevice->abyPermanentNetAddr,
-	       ETH_ALEN);
+				pDevice->abyPermanentNetAddr, ETH_ALEN);
 
 	/* if exist SW network address, use it */
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
 		pDevice->abyCurrentNetAddr);
 
-    /*
-     * set BB and packet type at the same time
-     * set Short Slot Time, xIFS, and RSPINF
-     */
-    if (pDevice->byBBType == BB_TYPE_11A) {
-        CARDbAddBasicRate(pDevice, RATE_6M);
-        pDevice->bShortSlotTime = true;
-    } else {
-        CARDbAddBasicRate(pDevice, RATE_1M);
-        pDevice->bShortSlotTime = false;
-    }
-    BBvSetShortSlotTime(pDevice);
-    CARDvSetBSSMode(pDevice);
+	/*
+	* set BB and packet type at the same time
+	* set Short Slot Time, xIFS, and RSPINF
+	*/
+	if (pDevice->byBBType == BB_TYPE_11A) {
+		CARDbAddBasicRate(pDevice, RATE_6M);
+		pDevice->bShortSlotTime = true;
+	} else {
+		CARDbAddBasicRate(pDevice, RATE_1M);
+		pDevice->bShortSlotTime = false;
+	}
 
-    if (pDevice->bUpdateBBVGA) {
-        pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
-        pDevice->byBBVGANew = pDevice->byBBVGACurrent;
-        BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
-    }
+	BBvSetShortSlotTime(pDevice);
+	CARDvSetBSSMode(pDevice);
 
-    pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
-    pDevice->bHWRadioOff = false;
-    if ( (pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0 ) {
-        ntStatus = CONTROLnsRequestIn(pDevice,
-                                    MESSAGE_TYPE_READ,
-                                    MAC_REG_GPIOCTL1,
-                                    MESSAGE_REQUEST_MACREG,
-                                    1,
-                                    &byTmp);
-
-        if ( ntStatus != STATUS_SUCCESS ) {
-            spin_unlock_irq(&pDevice->lock);
-            return false;
-        }
-        if ( (byTmp & GPIO3_DATA) == 0 ) {
-            pDevice->bHWRadioOff = true;
-            MACvRegBitsOn(pDevice,MAC_REG_GPIOCTL1,GPIO3_INTMD);
-        } else {
-            MACvRegBitsOff(pDevice,MAC_REG_GPIOCTL1,GPIO3_INTMD);
-            pDevice->bHWRadioOff = false;
-        }
+	if (pDevice->bUpdateBBVGA) {
+		pDevice->byBBVGACurrent = pDevice->abyBBVGA[0];
+		pDevice->byBBVGANew = pDevice->byBBVGACurrent;
 
-    }
+		BBvSetVGAGainOffset(pDevice, pDevice->abyBBVGA[0]);
+	}
 
-    ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_TMLEN,0x38);
-    ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-    MACvRegBitsOn(pDevice,MAC_REG_GPIOCTL0,0x01);
+	pDevice->byRadioCtl = pDevice->abyEEPROM[EEP_OFS_RADIOCTL];
+	pDevice->bHWRadioOff = false;
 
-    if ((pDevice->bHWRadioOff == true) || (pDevice->bRadioControlOff == true)) {
-        CARDbRadioPowerOff(pDevice);
-    } else {
-        CARDbRadioPowerOn(pDevice);
-    }
+	if ((pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0) {
+		ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
+			MAC_REG_GPIOCTL1, MESSAGE_REQUEST_MACREG, 1, &byTmp);
 
-    spin_unlock_irq(&pDevice->lock);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
-    return true;
+		if (ntStatus != STATUS_SUCCESS) {
+			spin_unlock_irq(&pDevice->lock);
+			return false;
+		}
+
+		if ((byTmp & GPIO3_DATA) == 0) {
+			pDevice->bHWRadioOff = true;
+			MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+		} else {
+			MACvRegBitsOff(pDevice, MAC_REG_GPIOCTL1, GPIO3_INTMD);
+			pDevice->bHWRadioOff = false;
+		}
+
+	}
+
+	ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG,
+				MAC_REG_PAPEDELAY, LEDSTS_TMLEN, 0x38);
+
+	ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG,
+				MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+
+	MACvRegBitsOn(pDevice, MAC_REG_GPIOCTL0, 0x01);
+
+	if ((pDevice->bHWRadioOff == true) ||
+				(pDevice->bRadioControlOff == true)) {
+		CARDbRadioPowerOff(pDevice);
+	} else {
+		CARDbRadioPowerOn(pDevice);
+	}
+
+
+	spin_unlock_irq(&pDevice->lock);
+
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"<----INIbInitAdapter Exit\n");
+
+	return true;
 }
 
 #ifdef CONFIG_PM	/* Minimal support for suspend and resume */
-- 
1.8.3.2

