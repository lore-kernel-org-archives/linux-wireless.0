Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:35622 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaECOUH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:20:07 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi5so2708016wib.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:20:06 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 13/13] staging: vt6656: Remove PIPEnsControlOutAsyn/CONTROLnsRequestOutAsyn
Date: Sat,  3 May 2014 15:17:34 +0100
Message-Id: <1399126654-2663-13-git-send-email-tvboxspy@gmail.com> (sfid-20140503_162016_457802_C0E9F452)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This now the sames as PIPEnsControlOut.

Replace with PIPEnsControlOut/CONTROLnsRequestOut.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/control.h  |  3 ---
 drivers/staging/vt6656/firmware.c |  2 +-
 drivers/staging/vt6656/mac.c      |  2 +-
 drivers/staging/vt6656/usbpipe.c  | 38 --------------------------------------
 drivers/staging/vt6656/usbpipe.h  |  2 --
 5 files changed, 2 insertions(+), 45 deletions(-)

diff --git a/drivers/staging/vt6656/control.h b/drivers/staging/vt6656/control.h
index 9da9b96..4658910 100644
--- a/drivers/staging/vt6656/control.h
+++ b/drivers/staging/vt6656/control.h
@@ -36,9 +36,6 @@
 #define CONTROLnsRequestOut(Device, Request, Value, Index, Length, Buffer) \
 	PIPEnsControlOut(Device, Request, Value, Index, Length, Buffer)
 
-#define CONTROLnsRequestOutAsyn(Device, Request, Value, Index, Length, Buffer) \
-	PIPEnsControlOutAsyn(Device, Request, Value, Index, Length, Buffer)
-
 #define CONTROLnsRequestIn(Device, Request, Value, Index, Length, Buffer) \
 	PIPEnsControlIn(Device, Request, Value, Index, Length, Buffer)
 
diff --git a/drivers/staging/vt6656/firmware.c b/drivers/staging/vt6656/firmware.c
index 7a4a972..e03f1f9 100644
--- a/drivers/staging/vt6656/firmware.c
+++ b/drivers/staging/vt6656/firmware.c
@@ -71,7 +71,7 @@ int FIRMWAREbDownload(struct vnt_private *pDevice)
 		wLength = min_t(int, fw->size - ii, FIRMWARE_CHUNK_SIZE);
 		memcpy(pBuffer, fw->data + ii, wLength);
 
-		NdisStatus = CONTROLnsRequestOutAsyn(pDevice,
+		NdisStatus = CONTROLnsRequestOut(pDevice,
 						0,
 						0x1200+ii,
 						0x0000,
diff --git a/drivers/staging/vt6656/mac.c b/drivers/staging/vt6656/mac.c
index 3ce19dd..8bd3ab0 100644
--- a/drivers/staging/vt6656/mac.c
+++ b/drivers/staging/vt6656/mac.c
@@ -75,7 +75,7 @@ void MACvWriteMultiAddr(struct vnt_private *pDevice, u64 mc_filter)
  */
 void MACbShutdown(struct vnt_private *pDevice)
 {
-    CONTROLnsRequestOutAsyn(pDevice,
+	CONTROLnsRequestOut(pDevice,
                         MESSAGE_TYPE_MACSHUTDOWN,
                         0,
                         0,
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 9946bfd..433edca 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -64,44 +64,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
 
-int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
-	u16 wValue, u16 wIndex, u16 wLength, u8 *pbyBuffer)
-{
-	int ntStatus;
-
-    if (pDevice->Flags & fMP_DISCONNECTED)
-        return STATUS_FAILURE;
-
-    if (in_interrupt()) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"in_interrupt return ..byRequest %x\n", byRequest);
-        return STATUS_FAILURE;
-    }
-
-	mutex_lock(&pDevice->usb_lock);
-
-    ntStatus = usb_control_msg(
-                            pDevice->usb,
-                            usb_sndctrlpipe(pDevice->usb , 0),
-                            byRequest,
-                            0x40, // RequestType
-                            wValue,
-                            wIndex,
-			    (void *) pbyBuffer,
-                            wLength,
-                            HZ
-                          );
-    if (ntStatus >= 0) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"usb_sndctrlpipe ntStatus= %d\n", ntStatus);
-        ntStatus = 0;
-    } else {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"usb_sndctrlpipe fail, ntStatus= %d\n", ntStatus);
-    }
-
-	mutex_unlock(&pDevice->usb_lock);
-
-    return ntStatus;
-}
-
 int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		u16 wIndex, u16 wLength, u8 *pbyBuffer)
 {
diff --git a/drivers/staging/vt6656/usbpipe.h b/drivers/staging/vt6656/usbpipe.h
index f537703..42ad4f7 100644
--- a/drivers/staging/vt6656/usbpipe.h
+++ b/drivers/staging/vt6656/usbpipe.h
@@ -34,8 +34,6 @@
 
 int PIPEnsControlOut(struct vnt_private *, u8 byRequest, u16 wValue,
 		u16 wIndex, u16 wLength, u8 *pbyBuffer);
-int PIPEnsControlOutAsyn(struct vnt_private *, u8 byRequest,
-	u16 wValue, u16 wIndex, u16 wLength, u8 *pbyBuffer);
 int PIPEnsControlIn(struct vnt_private *, u8 byRequest, u16 wValue,
 	u16 wIndex, u16 wLength,  u8 *pbyBuffer);
 
-- 
1.9.1

