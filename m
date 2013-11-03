Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:43541 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab3KCRlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Nov 2013 12:41:10 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so1245337wgg.28
        for <linux-wireless@vger.kernel.org>; Sun, 03 Nov 2013 09:41:08 -0800 (PST)
Message-ID: <1383500451.3758.23.camel@canaries32-MCP7A> (sfid-20131103_184115_176899_F8A8EE40)
Subject: [PATCH 1/5] [v2]staging: vt6656: device.h Remove typedef enum
 __device_init_type.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org
Date: Sun, 03 Nov 2013 17:40:51 +0000
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since typedef enum __device_init_type is only ever called
in one state.

Remove the typedef from main_usb.c:device_init_registers and
replace with macro values. The other values may be needed later.

Apply cold value to sInitCmd.byInitClass.

Remove if braces and correct formatting within.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |   8 +-
 drivers/staging/vt6656/main_usb.c | 274 +++++++++++++++++++-------------------
 2 files changed, 143 insertions(+), 139 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 62b7de1..ef2b922 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -149,11 +149,9 @@ typedef enum __device_msg_level {
 	MSG_LEVEL_DEBUG = 4           /* Only for debug purpose. */
 } DEVICE_MSG_LEVEL, *PDEVICE_MSG_LEVEL;
 
-typedef enum __device_init_type {
-	DEVICE_INIT_COLD = 0,       /* cold init */
-	DEVICE_INIT_RESET,          /* reset init or Dx to D0 power remain */
-	DEVICE_INIT_DXPL            /* Dx to D0 power lost init */
-} DEVICE_INIT_TYPE, *PDEVICE_INIT_TYPE;
+#define DEVICE_INIT_COLD	0x0 /* cold init */
+#define DEVICE_INIT_RESET	0x1 /* reset init or Dx to D0 power remain */
+#define DEVICE_INIT_DXPL	0x2 /* Dx to D0 power lost init */
 
 /* USB */
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index aae228c..297dd10 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -215,8 +215,7 @@ static void device_set_multi(struct net_device *dev);
 static int  device_close(struct net_device *dev);
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 
-static int device_init_registers(struct vnt_private *pDevice,
-	DEVICE_INIT_TYPE InitType);
+static int device_init_registers(struct vnt_private *pDevice);
 static bool device_init_defrag_cb(struct vnt_private *pDevice);
 static void device_init_diversity_timer(struct vnt_private *pDevice);
 static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
@@ -297,8 +296,7 @@ static void device_init_diversity_timer(struct vnt_private *pDevice)
  * initialization of MAC & BBP registers
  */
 
-static int device_init_registers(struct vnt_private *pDevice,
-	DEVICE_INIT_TYPE InitType)
+static int device_init_registers(struct vnt_private *pDevice)
 {
 	struct vnt_manager *pMgmt = &pDevice->vnt_mgmt;
 	u8 abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
@@ -313,12 +311,14 @@ static int device_init_registers(struct vnt_private *pDevice,
 	u8 byTmp;
 	u8 byCalibTXIQ = 0, byCalibTXDC = 0, byCalibRXIQ = 0;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n", InitType, pDevice->byPacketType);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "---->INIbInitAdapter. [%d][%d]\n",
+				DEVICE_INIT_COLD, pDevice->byPacketType);
+
 	spin_lock_irq(&pDevice->lock);
-	if (InitType == DEVICE_INIT_COLD) {
-		memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
-		memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
-		memcpy(pDevice->abySNAP_Bridgetunnel,
+
+	memcpy(pDevice->abyBroadcastAddr, abyBroadcastAddr, ETH_ALEN);
+	memcpy(pDevice->abySNAP_RFC1042, abySNAP_RFC1042, ETH_ALEN);
+	memcpy(pDevice->abySNAP_Bridgetunnel,
 		       abySNAP_Bridgetunnel,
 		       ETH_ALEN);
 
@@ -342,9 +342,8 @@ static int device_init_registers(struct vnt_private *pDevice,
             spin_unlock_irq(&pDevice->lock);
             return false;
         }
-    }
 
-    sInitCmd.byInitClass = (u8)InitType;
+    sInitCmd.byInitClass = DEVICE_INIT_COLD;
     sInitCmd.bExistSWNetAddr = (u8) pDevice->bExistSWNetAddr;
     for (ii = 0; ii < 6; ii++)
 	sInitCmd.bySWNetAddr[ii] = pDevice->abyCurrentNetAddr[ii];
@@ -364,138 +363,145 @@ static int device_init_registers(struct vnt_private *pDevice,
         spin_unlock_irq(&pDevice->lock);
         return false;
     }
-    if (InitType == DEVICE_INIT_COLD) {
 
-        ntStatus = CONTROLnsRequestIn(pDevice,MESSAGE_TYPE_INIT_RSP,0,0,sizeof(RSP_CARD_INIT), (u8 *) &(sInitRsp));
-
-        if (ntStatus != STATUS_SUCCESS) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Cardinit request in status fail!\n");
-            spin_unlock_irq(&pDevice->lock);
-            return false;
-        }
+	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
+			sizeof(RSP_CARD_INIT), (u8 *) &(sInitRsp));
+	if (ntStatus != STATUS_SUCCESS) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
+			"Cardinit request in status fail!\n");
+		spin_unlock_irq(&pDevice->lock);
+		return false;
+	}
 
 	/* local ID for AES functions */
-        ntStatus = CONTROLnsRequestIn(pDevice,
-                                    MESSAGE_TYPE_READ,
-                                    MAC_REG_LOCALID,
-                                    MESSAGE_REQUEST_MACREG,
-                                    1,
-                                    &pDevice->byLocalID);
-
-        if ( ntStatus != STATUS_SUCCESS ) {
-            spin_unlock_irq(&pDevice->lock);
-            return false;
-        }
+	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
+		MAC_REG_LOCALID, MESSAGE_REQUEST_MACREG, 1,
+			&pDevice->byLocalID);
+	if (ntStatus != STATUS_SUCCESS) {
+		spin_unlock_irq(&pDevice->lock);
+		return false;
+	}
 
 	/* do MACbSoftwareReset in MACvInitialize */
 
 	/* force CCK */
-        pDevice->bCCK = true;
+	pDevice->bCCK = true;
 	pDevice->bProtectMode = false;
 	/* only used in 11g type, sync with ERP IE */
-        pDevice->bNonERPPresent = false;
-        pDevice->bBarkerPreambleMd = false;
-        if ( pDevice->bFixRate ) {
-            pDevice->wCurrentRate = (u16) pDevice->uConnectionRate;
-        } else {
-            if ( pDevice->byBBType == BB_TYPE_11B )
-                pDevice->wCurrentRate = RATE_11M;
-            else
-                pDevice->wCurrentRate = RATE_54M;
-        }
+	pDevice->bNonERPPresent = false;
+	pDevice->bBarkerPreambleMd = false;
+	if (pDevice->bFixRate) {
+		pDevice->wCurrentRate = (u16)pDevice->uConnectionRate;
+	} else {
+		if (pDevice->byBBType == BB_TYPE_11B)
+			pDevice->wCurrentRate = RATE_11M;
+		else
+			pDevice->wCurrentRate = RATE_54M;
+	}
 
-        CHvInitChannelTable(pDevice);
+	CHvInitChannelTable(pDevice);
 
-        pDevice->byTopOFDMBasicRate = RATE_24M;
-        pDevice->byTopCCKBasicRate = RATE_1M;
+	pDevice->byTopOFDMBasicRate = RATE_24M;
+	pDevice->byTopCCKBasicRate = RATE_1M;
 	pDevice->byRevId = 0;
 	/* target to IF pin while programming to RF chip */
-        pDevice->byCurPwr = 0xFF;
+	pDevice->byCurPwr = 0xFF;
 
-        pDevice->byCCKPwr = pDevice->abyEEPROM[EEP_OFS_PWR_CCK];
-        pDevice->byOFDMPwrG = pDevice->abyEEPROM[EEP_OFS_PWR_OFDMG];
+	pDevice->byCCKPwr = pDevice->abyEEPROM[EEP_OFS_PWR_CCK];
+	pDevice->byOFDMPwrG = pDevice->abyEEPROM[EEP_OFS_PWR_OFDMG];
 	/* load power table */
 	for (ii = 0; ii < 14; ii++) {
-            pDevice->abyCCKPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
-            if (pDevice->abyCCKPwrTbl[ii] == 0)
-                pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
-            pDevice->abyOFDMPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
-            if (pDevice->abyOFDMPwrTbl[ii] == 0)
-                pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
-        }
+		pDevice->abyCCKPwrTbl[ii] =
+			pDevice->abyEEPROM[ii + EEP_OFS_CCK_PWR_TBL];
+
+		if (pDevice->abyCCKPwrTbl[ii] == 0)
+			pDevice->abyCCKPwrTbl[ii] = pDevice->byCCKPwr;
+			pDevice->abyOFDMPwrTbl[ii] =
+				pDevice->abyEEPROM[ii + EEP_OFS_OFDM_PWR_TBL];
+		if (pDevice->abyOFDMPwrTbl[ii] == 0)
+			pDevice->abyOFDMPwrTbl[ii] = pDevice->byOFDMPwrG;
+	}
 
 	/*
 	 * original zonetype is USA, but custom zonetype is Europe,
 	 * then need to recover 12, 13, 14 channels with 11 channel
 	 */
-          if(((pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Japan) ||
-	        (pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Europe))&&
-	     (pDevice->byOriginalZonetype == ZoneType_USA)) {
+	if (((pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Japan) ||
+		(pDevice->abyEEPROM[EEP_OFS_ZONETYPE] == ZoneType_Europe)) &&
+		(pDevice->byOriginalZonetype == ZoneType_USA)) {
 		for (ii = 11; ii < 14; ii++) {
 			pDevice->abyCCKPwrTbl[ii] = pDevice->abyCCKPwrTbl[10];
 			pDevice->abyOFDMPwrTbl[ii] = pDevice->abyOFDMPwrTbl[10];
 		}
-	  }
+	}
 
-	  pDevice->byOFDMPwrA = 0x34; /* same as RFbMA2829SelectChannel */
+	pDevice->byOFDMPwrA = 0x34; /* same as RFbMA2829SelectChannel */
 
-	  /* load OFDM A power table */
-	  for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
-            pDevice->abyOFDMAPwrTbl[ii] = pDevice->abyEEPROM[ii + EEP_OFS_OFDMA_PWR_TBL];
-            if (pDevice->abyOFDMAPwrTbl[ii] == 0)
-                pDevice->abyOFDMAPwrTbl[ii] = pDevice->byOFDMPwrA;
-        }
+	/* load OFDM A power table */
+	for (ii = 0; ii < CB_MAX_CHANNEL_5G; ii++) {
+		pDevice->abyOFDMAPwrTbl[ii] =
+			pDevice->abyEEPROM[ii + EEP_OFS_OFDMA_PWR_TBL];
 
-        byAntenna = pDevice->abyEEPROM[EEP_OFS_ANTENNA];
-        if (byAntenna & EEP_ANTINV)
-            pDevice->bTxRxAntInv = true;
-        else
-            pDevice->bTxRxAntInv = false;
+		if (pDevice->abyOFDMAPwrTbl[ii] == 0)
+			pDevice->abyOFDMAPwrTbl[ii] = pDevice->byOFDMPwrA;
+	}
 
-        byAntenna &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+	byAntenna = pDevice->abyEEPROM[EEP_OFS_ANTENNA];
+
+	if (byAntenna & EEP_ANTINV)
+		pDevice->bTxRxAntInv = true;
+	else
+		pDevice->bTxRxAntInv = false;
+
+	byAntenna &= (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
 
 	if (byAntenna == 0) /* if not set default is both */
-            byAntenna = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
-
-        if (byAntenna == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
-            pDevice->byAntennaCount = 2;
-            pDevice->byTxAntennaMode = ANT_B;
-            pDevice->dwTxAntennaSel = 1;
-            pDevice->dwRxAntennaSel = 1;
-            if (pDevice->bTxRxAntInv == true)
-                pDevice->byRxAntennaMode = ANT_A;
-            else
-                pDevice->byRxAntennaMode = ANT_B;
-
-            if (pDevice->bDiversityRegCtlON)
-                pDevice->bDiversityEnable = true;
-            else
-                pDevice->bDiversityEnable = false;
-        } else  {
-            pDevice->bDiversityEnable = false;
-            pDevice->byAntennaCount = 1;
-            pDevice->dwTxAntennaSel = 0;
-            pDevice->dwRxAntennaSel = 0;
-            if (byAntenna & EEP_ANTENNA_AUX) {
-                pDevice->byTxAntennaMode = ANT_A;
-                if (pDevice->bTxRxAntInv == true)
-                    pDevice->byRxAntennaMode = ANT_B;
-                else
-                    pDevice->byRxAntennaMode = ANT_A;
-            } else {
-                pDevice->byTxAntennaMode = ANT_B;
-                if (pDevice->bTxRxAntInv == true)
-                    pDevice->byRxAntennaMode = ANT_A;
-                else
-                    pDevice->byRxAntennaMode = ANT_B;
-            }
-        }
-        pDevice->ulDiversityNValue = 100*255;
-        pDevice->ulDiversityMValue = 100*16;
-        pDevice->byTMax = 1;
-        pDevice->byTMax2 = 4;
-        pDevice->ulSQ3TH = 0;
-        pDevice->byTMax3 = 64;
+		byAntenna = (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN);
+
+	if (byAntenna == (EEP_ANTENNA_AUX | EEP_ANTENNA_MAIN)) {
+		pDevice->byAntennaCount = 2;
+		pDevice->byTxAntennaMode = ANT_B;
+		pDevice->dwTxAntennaSel = 1;
+		pDevice->dwRxAntennaSel = 1;
+
+		if (pDevice->bTxRxAntInv == true)
+			pDevice->byRxAntennaMode = ANT_A;
+		else
+			pDevice->byRxAntennaMode = ANT_B;
+
+		if (pDevice->bDiversityRegCtlON)
+			pDevice->bDiversityEnable = true;
+		else
+			pDevice->bDiversityEnable = false;
+	} else  {
+		pDevice->bDiversityEnable = false;
+		pDevice->byAntennaCount = 1;
+		pDevice->dwTxAntennaSel = 0;
+		pDevice->dwRxAntennaSel = 0;
+
+		if (byAntenna & EEP_ANTENNA_AUX) {
+			pDevice->byTxAntennaMode = ANT_A;
+
+			if (pDevice->bTxRxAntInv == true)
+				pDevice->byRxAntennaMode = ANT_B;
+			else
+				pDevice->byRxAntennaMode = ANT_A;
+		} else {
+			pDevice->byTxAntennaMode = ANT_B;
+
+		if (pDevice->bTxRxAntInv == true)
+			pDevice->byRxAntennaMode = ANT_A;
+		else
+			pDevice->byRxAntennaMode = ANT_B;
+		}
+	}
+
+	pDevice->ulDiversityNValue = 100 * 255;
+	pDevice->ulDiversityMValue = 100 * 16;
+	pDevice->byTMax = 1;
+	pDevice->byTMax2 = 4;
+	pDevice->ulSQ3TH = 0;
+	pDevice->byTMax3 = 64;
 
 	/* get Auto Fall Back type */
         pDevice->byAutoFBCtrl = AUTO_FB_0;
@@ -524,49 +530,50 @@ static int device_init_registers(struct vnt_private *pDevice,
         }
 
 	/* load vt3266 calibration parameters in EEPROM */
-        if (pDevice->byRFType == RF_VT3226D0) {
-            if((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
-                (pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
-                byCalibTXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
-                byCalibTXDC = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_DC];
-                byCalibRXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
-                if( (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) ) {
+	if (pDevice->byRFType == RF_VT3226D0) {
+		if ((pDevice->abyEEPROM[EEP_OFS_MAJOR_VER] == 0x1) &&
+			(pDevice->abyEEPROM[EEP_OFS_MINOR_VER] >= 0x4)) {
+
+			byCalibTXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_IQ];
+			byCalibTXDC = pDevice->abyEEPROM[EEP_OFS_CALIB_TX_DC];
+			byCalibRXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
+			if (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) {
 			/* CR255, enable TX/RX IQ and DC compensation mode */
-			ControlvWriteByte(pDevice,
+				ControlvWriteByte(pDevice,
 					  MESSAGE_REQUEST_BBREG,
 					  0xFF,
 					  0x03);
 			/* CR251, TX I/Q Imbalance Calibration */
-			ControlvWriteByte(pDevice,
+				ControlvWriteByte(pDevice,
 					  MESSAGE_REQUEST_BBREG,
 					  0xFB,
 					  byCalibTXIQ);
 			/* CR252, TX DC-Offset Calibration */
-			ControlvWriteByte(pDevice,
+				ControlvWriteByte(pDevice,
 					  MESSAGE_REQUEST_BBREG,
 					  0xFC,
 					  byCalibTXDC);
 			/* CR253, RX I/Q Imbalance Calibration */
-			ControlvWriteByte(pDevice,
+				ControlvWriteByte(pDevice,
 					  MESSAGE_REQUEST_BBREG,
 					  0xFD,
 					  byCalibRXIQ);
-                } else {
+			} else {
 			/* CR255, turn off BB Calibration compensation */
-			ControlvWriteByte(pDevice,
+				ControlvWriteByte(pDevice,
 					  MESSAGE_REQUEST_BBREG,
 					  0xFF,
 					  0x0);
-                }
-            }
-        }
+			}
+		}
+	}
         pMgmt->eScanType = WMAC_SCAN_PASSIVE;
         pMgmt->uCurrChannel = pDevice->uChannel;
         pMgmt->uIBSSChannel = pDevice->uChannel;
         CARDbSetMediaChannel(pDevice, pMgmt->uCurrChannel);
 
 	/* get permanent network address */
-        memcpy(pDevice->abyPermanentNetAddr,&(sInitRsp.byNetAddr[0]),6);
+	memcpy(pDevice->abyPermanentNetAddr, &sInitRsp.byNetAddr[0], 6);
 	memcpy(pDevice->abyCurrentNetAddr,
 	       pDevice->abyPermanentNetAddr,
 	       ETH_ALEN);
@@ -574,7 +581,6 @@ static int device_init_registers(struct vnt_private *pDevice,
 	/* if exist SW network address, use it */
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"Network address = %pM\n",
 		pDevice->abyCurrentNetAddr);
-    }
 
     /*
      * set BB and packet type at the same time
@@ -962,10 +968,10 @@ static int  device_open(struct net_device *dev)
     /* read config file */
     Read_config_file(pDevice);
 
-    if (device_init_registers(pDevice, DEVICE_INIT_COLD) == false) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " init register fail\n");
-        goto free_all;
-    }
+	if (device_init_registers(pDevice) == false) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " init register fail\n");
+		goto free_all;
+	}
 
     device_set_multi(pDevice->dev);
 
-- 
1.8.3.2


