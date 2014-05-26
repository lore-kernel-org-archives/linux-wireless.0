Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:46054 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbaEZNAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 09:00:16 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so7830096wes.7
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 06:00:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/11] staging: vt6656: create vnt_control_in_u8 to replace ControlvReadByte
Date: Mon, 26 May 2014 13:59:06 +0100
Message-Id: <1401109148-3593-9-git-send-email-tvboxspy@gmail.com> (sfid-20140526_152147_587132_5468FE4C)
In-Reply-To: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
References: <1401109148-3593-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ControlvReadByte will be removed in next patch

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/baseband.c | 2 +-
 drivers/staging/vt6656/power.c    | 2 +-
 drivers/staging/vt6656/usbpipe.c  | 9 +++++++--
 drivers/staging/vt6656/usbpipe.h  | 1 +
 drivers/staging/vt6656/wcmd.c     | 2 +-
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/vt6656/baseband.c b/drivers/staging/vt6656/baseband.c
index 3373812..4cdea2c 100644
--- a/drivers/staging/vt6656/baseband.c
+++ b/drivers/staging/vt6656/baseband.c
@@ -1076,7 +1076,7 @@ void BBvSetShortSlotTime(struct vnt_private *priv)
 	else
 		priv->byBBRxConf |= 0x20;
 
-	ControlvReadByte(priv, MESSAGE_REQUEST_BBREG, 0xe7, &bb_vga);
+	vnt_control_in_u8(priv, MESSAGE_REQUEST_BBREG, 0xe7, &bb_vga);
 
 	if (bb_vga == priv->abyBBVGA[0])
 		priv->byBBRxConf |= 0x20;
diff --git a/drivers/staging/vt6656/power.c b/drivers/staging/vt6656/power.c
index a5cea43..b8ebf58 100644
--- a/drivers/staging/vt6656/power.c
+++ b/drivers/staging/vt6656/power.c
@@ -162,7 +162,7 @@ int PSbConsiderPowerDown(struct vnt_private *pDevice, int bCheckRxDMA,
 	u8 byData;
 
 	/* check if already in Doze mode */
-	ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG,
+	vnt_control_in_u8(pDevice, MESSAGE_REQUEST_MACREG,
 					MAC_REG_PSCTL, &byData);
 
 	if ((byData & PSCTL_PS) != 0)
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 2264c8c..fc68bad 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -29,7 +29,7 @@
  *	vnt_control_out - Write variable length bytes to MEM/BB/MAC/EEPROM
  *	vnt_control_in - Read variable length bytes from MEM/BB/MAC/EEPROM
  *	vnt_control_out_u8 - Write one byte to MEM/BB/MAC/EEPROM
- *      ControlvReadByte - Read one byte from MEM/BB/MAC/EEPROM
+ *	vnt_control_in_u8 - Read one byte from MEM/BB/MAC/EEPROM
  *      ControlvMaskByte - Read one byte from MEM/BB/MAC/EEPROM and clear/set some bits in the same address
  *
  * Revision History:
@@ -41,7 +41,6 @@
 #include "int.h"
 #include "rxtx.h"
 #include "dpc.h"
-#include "control.h"
 #include "desc.h"
 #include "device.h"
 
@@ -111,6 +110,12 @@ int vnt_control_in(struct vnt_private *priv, u8 request, u16 value,
 	return STATUS_SUCCESS;
 }
 
+void vnt_control_in_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 *data)
+{
+	vnt_control_in(priv, MESSAGE_TYPE_READ,
+			reg_off, reg, sizeof(u8), data);
+}
+
 /*
  * Description:
  *      Allocates an usb interrupt in irp and calls USBD.
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index a3d3bac..ea71782 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -36,6 +36,7 @@ int vnt_control_out(struct vnt_private *, u8, u16, u16, u16, u8 *);
 int vnt_control_in(struct vnt_private *, u8, u16, u16, u16,  u8 *);
 
 void vnt_control_out_u8(struct vnt_private *, u8, u8, u8);
+void vnt_control_in_u8(struct vnt_private *, u8, u8, u8 *);
 
 int PIPEnsInterruptRead(struct vnt_private *);
 int PIPEnsBulkInUsbRead(struct vnt_private *, struct vnt_rcb *pRCB);
diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 79f7463..91754fd 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -861,7 +861,7 @@ void vRunCommand(struct work_struct *work)
 		break;
 
 	case WLAN_CMD_MAC_DISPOWERSAVING_START:
-		ControlvReadByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
+		vnt_control_in_u8(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PSCTL, &byData);
 		if ((byData & PSCTL_PS) != 0) {
 			// disable power saving hw function
 			vnt_control_out(pDevice,
-- 
1.9.1

