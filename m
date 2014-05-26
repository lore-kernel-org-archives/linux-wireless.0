Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:42402 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaEZNAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:09 -0400
Received: by mail-wi0-f173.google.com with SMTP id bs8so4243181wib.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/11] staging: vt6656: rename PIPEnsControlIn/CONTROLnsRequestIn with vnt_control_in
Date: Mon, 26 May 2014 13:59:02 +0100
Message-Id: <1401109148-3593-5-git-send-email-tvboxspy@gmail.com> (sfid-20140526_150017_060824_221F2455)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replace all to CONTROLnsRequestIn with vnt_control_in and remove macro.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 4 ++--
 drivers/staging/vt6656/control.c  | 3 +--
 drivers/staging/vt6656/control.h  | 3 ---
 drivers/staging/vt6656/firmware.c | 2 +-
 drivers/staging/vt6656/main_usb.c | 8 ++++----
 drivers/staging/vt6656/usbpipe.c  | 4 ++--
 drivers/staging/vt6656/usbpipe.h  | 3 +--
 drivers/staging/vt6656/wcmd.c     | 2 +-
 8 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 8a509d8..8a965bf 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -893,7 +893,7 @@ int BBbVT3184Init(struct vnt_private *priv)
 	u8 array[256];
 	u8 data;
 
-	status = CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ, 0,
+	status = vnt_control_in(priv, MESSAGE_TYPE_READ, 0,
 		MESSAGE_REQUEST_EEPROM, EEP_MAX_CONTEXT_SIZE,
 						priv->abyEEPROM);
 	if (status != STATUS_SUCCESS)
@@ -1044,7 +1044,7 @@ int BBbVT3184Init(struct vnt_private *priv)
 
 
 	/* Fix for TX USB resets from vendors driver */
-	CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ, USB_REG4,
+	vnt_control_in(priv, MESSAGE_TYPE_READ, USB_REG4,
 		MESSAGE_REQUEST_MEM, sizeof(data), &data);
 
 	data |= 0x2;
diff --git a/drivers/staging/vt6656/control.c b/drivers/staging/vt6656/control.c
index 0740521..0c59d6d 100644
--- a/drivers/staging/vt6656/control.c
+++ b/drivers/staging/vt6656/control.c
@@ -27,7 +27,6 @@
  *
  * Functions:
  *      vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
- *      CONTROLnsRequestIn - Read variable length bytes from MEM/BB/MAC/EEPROM
  *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
  *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set
@@ -58,7 +57,7 @@ void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 void ControlvReadByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			u8 *data)
 {
-	CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
+	vnt_control_in(pDevice, MESSAGE_TYPE_READ,
 			reg_off, reg, sizeof(u8), data);
 	return;
 }
diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
index 17a23d5..db9dd54 100644
--- a/drivers/staging/vt6656/control.h
+++ b/drivers/staging/vt6656/control.h
@@ -33,9 +33,6 @@
 #include "device.h"
 #include "usbpipe.h"
 
-#define CONTROLnsRequestIn(Device, Request, Value, Index, Length, Buffer) \
-	PIPEnsControlIn(Device, Request, Value, Index, Length, Buffer)
-
 void ControlvWriteByte(struct vnt_private *pDevice, u8 reg, u8 reg_off,
 			u8 data);
 
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 13b68d5..f9d685f 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -116,7 +116,7 @@ int FIRMWAREbCheckVersion(struct vnt_private *pDevice)
 {
 	int ntStatus;
 
-	ntStatus = CONTROLnsRequestIn(pDevice,
+	ntStatus = vnt_control_in(pDevice,
 					MESSAGE_TYPE_READ,
 					0,
 					MESSAGE_REQUEST_VERSION,
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 9e70aa5..01dd068 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -322,7 +322,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 		return false;
 	}
 
-	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
+	ntStatus = vnt_control_in(pDevice, MESSAGE_TYPE_INIT_RSP, 0, 0,
 		sizeof(struct vnt_rsp_card_init), (u8 *)init_rsp);
 	if (ntStatus != STATUS_SUCCESS) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
@@ -331,7 +331,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	}
 
 	/* local ID for AES functions */
-	ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
+	ntStatus = vnt_control_in(pDevice, MESSAGE_TYPE_READ,
 		MAC_REG_LOCALID, MESSAGE_REQUEST_MACREG, 1,
 			&pDevice->byLocalID);
 	if (ntStatus != STATUS_SUCCESS)
@@ -535,7 +535,7 @@ static int device_init_registers(struct vnt_private *pDevice)
 	pDevice->bHWRadioOff = false;
 
 	if ((pDevice->byRadioCtl & EEP_RADIOCTL_ENABLE) != 0) {
-		ntStatus = CONTROLnsRequestIn(pDevice, MESSAGE_TYPE_READ,
+		ntStatus = vnt_control_in(pDevice, MESSAGE_TYPE_READ,
 			MAC_REG_GPIOCTL1, MESSAGE_REQUEST_MACREG, 1, &byTmp);
 
 		if (ntStatus != STATUS_SUCCESS)
@@ -1269,7 +1269,7 @@ void vnt_configure_filter(struct vnt_private *priv)
 	u8 tmp = 0;
 	int rc;
 
-	rc = CONTROLnsRequestIn(priv, MESSAGE_TYPE_READ,
+	rc = vnt_control_in(priv, MESSAGE_TYPE_READ,
 		MAC_REG_RCR, MESSAGE_REQUEST_MACREG, 1, &tmp);
 	if (rc == 0)
 		priv->byRxMode = tmp;
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 443338e..7d4e131 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -27,7 +27,7 @@
  *
  * Functions:
  *	vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
- *      CONTROLnsRequestIn - Read variable length bytes from MEM/BB/MAC/EEPROM
+ *	vnt_control_in - Read variable length bytes from MEM/BB/MAC/EEPROM
  *      ControlvWriteByte - Write one byte to MEM/BB/MAC/EEPROM
  *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
  *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set some bits in the same address
@@ -83,7 +83,7 @@ int vnt_control_out(struct vnt_private *priv, u8 request, u16 value,
 	return STATUS_SUCCESS;
 }
 
-int PIPEnsControlIn(struct vnt_private *priv, u8 request, u16 value,
+int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 		u16 index, u16 length, u8 *buffer)
 {
 	int status;
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index 6ca250f..f04e30b 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -33,8 +33,7 @@
 #include "device.h"
 
 int vnt_control_out(struct vnt_private *, u8, u16, u16, u16, u8 *);
-int PIPEnsControlIn(struct vnt_private *, u8 byRequest, u16 wValue,
-	u16 wIndex, u16 wLength,  u8 *pbyBuffer);
+int vnt_control_in(struct vnt_private *, u8, u16, u16, u16,  u8 *);
 
 int PIPEnsInterruptRead(struct vnt_private *);
 int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 9947794..aae573b 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -725,7 +725,7 @@ void vRunCommand(struct work_struct *work)
 			int ntStatus = STATUS_SUCCESS;
 			u8            byTmp;
 
-			ntStatus = CONTROLnsRequestIn(pDevice,
+			ntStatus = vnt_control_in(pDevice,
 					MESSAGE_TYPE_READ,
 					MAC_REG_GPIOCTL1,
 					MESSAGE_REQUEST_MACREG,
-- 
1.9.1

