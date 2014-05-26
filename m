Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54727 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaEZNAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:11 -0400
Received: by mail-wg0-f46.google.com with SMTP id n12so7835846wgh.17
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:09 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/11] staging: vt6656: replace ControlvWriteByte with vnt_control_out_u8
Date: Mon, 26 May 2014 13:59:03 +0100
Message-Id: <1401109148-3593-6-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150030_652070_B4226F40)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add new function in usbpipe.c to replace ControlvWriteByte

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 26 +++++++++++++-------------
 drivers/staging/vt6656/card.c     | 12 ++++++------
 drivers/staging/vt6656/control.c  | 11 -----------
 drivers/staging/vt6656/control.h  |  3 ---
 drivers/staging/vt6656/main_usb.c | 12 ++++++------
 drivers/staging/vt6656/usbpipe.c  |  8 +++++++-
 drivers/staging/vt6656/usbpipe.h  |  2 ++
 7 files changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 8a965bf..3373812 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1028,17 +1028,17 @@ int BBbVT3184Init(struct vnt_private *priv)
 
 	if ((priv->byRFType == RF_VT3226) ||
 		(priv->byRFType == RF_VT3342A0)) {
-		ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG,
+		vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 						MAC_REG_ITRTMSET, 0x23);
 		MACvRegBitsOn(priv, MAC_REG_PAPEDELAY, 0x01);
 	} else if (priv->byRFType == RF_VT3226D0) {
-		ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG,
+		vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 						MAC_REG_ITRTMSET, 0x11);
 		MACvRegBitsOn(priv, MAC_REG_PAPEDELAY, 0x01);
 	}
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x04, 0x7f);
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x04, 0x7f);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);
 
 	RFbRFTableDownload(priv);
 
@@ -1081,13 +1081,13 @@ void BBvSetShortSlotTime(struct vnt_private *priv)
 	if (bb_vga == priv->abyBBVGA[0])
 		priv->byBBRxConf |= 0x20;
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
 }
 
 void BBvSetVGAGainOffset(struct vnt_private *priv, u8 data)
 {
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0xE7, data);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0xE7, data);
 
 	/* patch for 3253B0 Baseband with Cardbus module */
 	if (priv->bShortSlotTime)
@@ -1095,7 +1095,7 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, u8 data)
 	else
 		priv->byBBRxConf |= 0x20; /* 0010 0000 */
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0a, priv->byBBRxConf);
 }
 
 /*
@@ -1112,14 +1112,14 @@ void BBvSetVGAGainOffset(struct vnt_private *priv, u8 data)
  */
 void BBvSetDeepSleep(struct vnt_private *priv)
 {
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x17);/* CR12 */
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0xB9);/* CR13 */
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x17);/* CR12 */
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0xB9);/* CR13 */
 }
 
 void BBvExitDeepSleep(struct vnt_private *priv)
 {
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x00);/* CR12 */
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);/* CR13 */
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0c, 0x00);/* CR12 */
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x0d, 0x01);/* CR13 */
 }
 
 void BBvUpdatePreEDThreshold(struct vnt_private *priv, int scanning)
@@ -1384,7 +1384,7 @@ void BBvUpdatePreEDThreshold(struct vnt_private *priv, int scanning)
 	if (!cr_201 && !cr_206)
 		return;
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0xc9, cr_201);
-	ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0xce, cr_206);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0xc9, cr_201);
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0xce, cr_206);
 }
 
diff --git a/drivers/staging/vt6656/card.c b/drivers/staging/vt6656/card.c
index 1f20e9a..9313730 100644
--- a/drivers/staging/vt6656/card.c
+++ b/drivers/staging/vt6656/card.c
@@ -111,7 +111,7 @@ void CARDbSetMediaChannel(struct vnt_private *priv, u32 connection_channel)
 			priv->abyCCKPwrTbl[connection_channel-1], RATE_1M);
 	}
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG, MAC_REG_CHANNEL,
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG, MAC_REG_CHANNEL,
 		(u8)(connection_channel|0x80));
 }
 
@@ -844,11 +844,11 @@ void CARDvSetBSSMode(struct vnt_private *priv)
 	priv->byPacketType = CARDbyGetPktType(priv);
 
 	if (priv->byBBType == BB_TYPE_11A)
-		ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
+		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x03);
 	else if (priv->byBBType == BB_TYPE_11B)
-		ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x02);
+		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x02);
 	else if (priv->byBBType == BB_TYPE_11G)
-		ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
+		vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG, 0x88, 0x08);
 
 	vUpdateIFS(priv);
 	CARDvSetRSPINF(priv, (u8)priv->byBBType);
@@ -857,7 +857,7 @@ void CARDvSetBSSMode(struct vnt_private *priv)
 		if (priv->byRFType == RF_AIROHA7230) {
 			priv->abyBBVGA[0] = 0x20;
 
-			ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG,
+			vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG,
 						0xe7, priv->abyBBVGA[0]);
 		}
 
@@ -867,7 +867,7 @@ void CARDvSetBSSMode(struct vnt_private *priv)
 		if (priv->byRFType == RF_AIROHA7230) {
 			priv->abyBBVGA[0] = 0x1c;
 
-			ControlvWriteByte(priv, MESSAGE_REQUEST_BBREG,
+			vnt_control_out_u8(priv, MESSAGE_REQUEST_BBREG,
 						0xe7, priv->abyBBVGA[0]);
 		}
 
diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 0c59d6d..14346a6 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -27,7 +27,6 @@
  *
  * Functions:
  *      vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
- *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
  *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set
  *				some bits in the same address
@@ -44,16 +43,6 @@
 /* static int          msglevel                =MSG_LEVEL_INFO;  */
 /* static int          msglevel                =MSG_LEVEL_DEBUG; */
 
-void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
-			u8 data)
-{
-
-	vnt_control_out(pDevice, MESSAGE_TYPE_WRITE, reg_off, reg,
-		sizeof(u8), &data);
-
-	return;
-}
-
 void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			u8 *data)
 {
diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
index db9dd54..e4e252e 100644
--- a/drivers/staging/vt6656/control.h
+++ b/drivers/staging/vt6656/control.h
@@ -33,9 +33,6 @@
 #include "device.h"
 #include "usbpipe.h"
 
-void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
-			u8 data);
-
 void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			u8 *data);
 
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 01dd068..6cc056d 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -468,28 +468,28 @@ static int device_init_registers(struct vnt_private *pDevice)
 			byCalibRXIQ = pDevice->abyEEPROM[EEP_OFS_CALIB_RX_IQ];
 			if (byCalibTXIQ || byCalibTXDC || byCalibRXIQ) {
 			/* CR255, enable TX/RX IQ and DC compensation mode */
-				ControlvWriteByte(pDevice,
+				vnt_control_out_u8(pDevice,
 					MESSAGE_REQUEST_BBREG,
 					0xff,
 					0x03);
 			/* CR251, TX I/Q Imbalance Calibration */
-				ControlvWriteByte(pDevice,
+				vnt_control_out_u8(pDevice,
 					MESSAGE_REQUEST_BBREG,
 					0xfb,
 					byCalibTXIQ);
 			/* CR252, TX DC-Offset Calibration */
-				ControlvWriteByte(pDevice,
+				vnt_control_out_u8(pDevice,
 					MESSAGE_REQUEST_BBREG,
 					0xfC,
 					byCalibTXDC);
 			/* CR253, RX I/Q Imbalance Calibration */
-				ControlvWriteByte(pDevice,
+				vnt_control_out_u8(pDevice,
 					MESSAGE_REQUEST_BBREG,
 					0xfd,
 					byCalibRXIQ);
 			} else {
 			/* CR255, turn off BB Calibration compensation */
-				ControlvWriteByte(pDevice,
+				vnt_control_out_u8(pDevice,
 					MESSAGE_REQUEST_BBREG,
 					0xff,
 					0x0);
@@ -1310,7 +1310,7 @@ void vnt_configure_filter(struct vnt_private *priv)
 		priv->byRxMode &= ~(RCR_UNICAST);
 	}
 
-	ControlvWriteByte(priv, MESSAGE_REQUEST_MACREG,
+	vnt_control_out_u8(priv, MESSAGE_REQUEST_MACREG,
 					MAC_REG_RCR, priv->byRxMode);
 
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 7d4e131..2264c8c 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -28,7 +28,7 @@
  * Functions:
  *	vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
  *	vnt_control_in - Read variable length bytes from MEM/BB/MAC/EEPROM
- *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
+ *	vnt_control_out_u8 - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
  *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set some bits in the same address
  *
@@ -83,6 +83,12 @@ int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 	return STATUS_SUCCESS;
 }
 
+void vnt_control_out_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 data)
+{
+	vnt_control_out(priv, MESSAGE_TYPE_WRITE,
+					reg_off, reg, sizeof(u8), &data);
+}
+
 int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
 {
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index f04e30b..a3d3bac 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -35,6 +35,8 @@
 int vnt_control_out(struct vnt_private *, u8, u16, u16, u16, u8 *);
 int vnt_control_in(struct vnt_private *, u8, u16, u16, u16,  u8 *);
 
+void vnt_control_out_u8(struct vnt_private *, u8, u8, u8);
+
 int PIPEnsInterruptRead(struct vnt_private *);
 int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
 int PIPEnsSendBulkOut(struct vnt_private *,
-- 
1.9.1

