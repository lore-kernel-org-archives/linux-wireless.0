Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49259 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbaECOUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:20:04 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so877462wiw.8
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:20:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/13] staging: vt6656: usbpipe.c PIPEnsControlOut use usb_control_msg
Date: Sat,  3 May 2014 15:17:32 +0100
Message-Id: <1399126654-2663-11-git-send-email-tvboxspy@gmail.com> (sfid-20140503_162010_489664_7C3A9947)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that this fucntion is nolonger atomic change to usb_control_msg

Return STATUS_FAILURE if ntStatus less than wLength.

Remove fMP_CONTROL_WRITES flag

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  1 -
 drivers/staging/vt6656/main_usb.c |  1 -
 drivers/staging/vt6656/usbpipe.c  | 87 ++++-----------------------------------
 3 files changed, 7 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 622cf02..da1b70d 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -744,7 +744,6 @@ struct vnt_private {
 #define fMP_POST_READS                      0x00000100
 #define fMP_POST_WRITES                     0x00000200
 #define fMP_CONTROL_READS                   0x00000400
-#define fMP_CONTROL_WRITES                  0x00000800
 
 #define MP_SET_FLAG(_M, _F)             ((_M)->Flags |= (_F))
 #define MP_CLEAR_FLAG(_M, _F)            ((_M)->Flags &= ~(_F))
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 462f95d..6ca5d78 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -965,7 +965,6 @@ static int  device_open(struct net_device *dev)
 
     MP_CLEAR_FLAG(pDevice, fMP_DISCONNECTED);
     MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
-    MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
     MP_SET_FLAG(pDevice, fMP_POST_READS);
     MP_SET_FLAG(pDevice, fMP_POST_WRITES);
 
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index b707470..1ab3958 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -64,7 +64,6 @@ static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
 static void s_nsControlInUsbIoCompleteRead(struct urb *urb);
-static void s_nsControlInUsbIoCompleteWrite(struct urb *urb);
 
 int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
 	u16 wValue, u16 wIndex, u16 wLength, u8 *pbyBuffer)
@@ -74,9 +73,6 @@ int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
     if (pDevice->Flags & fMP_DISCONNECTED)
         return STATUS_FAILURE;
 
-    if (pDevice->Flags & fMP_CONTROL_WRITES)
-        return STATUS_FAILURE;
-
     if (in_interrupt()) {
         DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"in_interrupt return ..byRequest %x\n", byRequest);
         return STATUS_FAILURE;
@@ -109,69 +105,24 @@ int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
 
 int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 		u16 wIndex, u16 wLength, u8 *pbyBuffer)
-		__releases(&pDevice->lock)
-		__acquires(&pDevice->lock)
 {
 	int ntStatus = 0;
-	int ii;
-
-    if (pDevice->Flags & fMP_DISCONNECTED)
-        return STATUS_FAILURE;
-
-    if (pDevice->Flags & fMP_CONTROL_WRITES)
-        return STATUS_FAILURE;
 
-	if (pDevice->Flags & fMP_CONTROL_READS)
-		return STATUS_FAILURE;
-
-	if (pDevice->pControlURB->hcpriv)
+	if (pDevice->Flags & fMP_DISCONNECTED)
 		return STATUS_FAILURE;
 
 	mutex_lock(&pDevice->usb_lock);
 
-	MP_SET_FLAG(pDevice, fMP_CONTROL_WRITES);
+	ntStatus = usb_control_msg(pDevice->usb,
+		usb_sndctrlpipe(pDevice->usb, 0), byRequest, 0x40, wValue,
+			wIndex, pbyBuffer, wLength, USB_CTL_WAIT);
 
-	pDevice->sUsbCtlRequest.bRequestType = 0x40;
-	pDevice->sUsbCtlRequest.bRequest = byRequest;
-	pDevice->sUsbCtlRequest.wValue = cpu_to_le16p(&wValue);
-	pDevice->sUsbCtlRequest.wIndex = cpu_to_le16p(&wIndex);
-	pDevice->sUsbCtlRequest.wLength = cpu_to_le16p(&wLength);
-	pDevice->pControlURB->transfer_flags |= URB_ASYNC_UNLINK;
-    pDevice->pControlURB->actual_length = 0;
-    // Notice, pbyBuffer limited point to variable buffer, can't be constant.
-  	usb_fill_control_urb(pDevice->pControlURB, pDevice->usb,
-			 usb_sndctrlpipe(pDevice->usb , 0), (char *) &pDevice->sUsbCtlRequest,
-			 pbyBuffer, wLength, s_nsControlInUsbIoCompleteWrite, pDevice);
+	mutex_unlock(&pDevice->usb_lock);
 
-	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
-	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"control send request submission failed: %d\n",
-				ntStatus);
-		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
-		mutex_unlock(&pDevice->usb_lock);
+	if (ntStatus < (int)wLength)
 		return STATUS_FAILURE;
-	}
-
-    for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
-
-	if (pDevice->Flags & fMP_CONTROL_WRITES)
-		mdelay(1);
-        else
-		break;
-
-        if (ii >= USB_CTL_WAIT) {
-		DBG_PRT(MSG_LEVEL_DEBUG,
-			KERN_INFO "control send request submission timeout\n");
-            MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
-	    mutex_unlock(&pDevice->usb_lock);
-            return STATUS_FAILURE;
-        }
-    }
-
-	mutex_unlock(&pDevice->usb_lock);
 
-    return STATUS_SUCCESS;
+	return STATUS_SUCCESS;
 }
 
 int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
@@ -188,9 +139,6 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
     if (pDevice->Flags & fMP_CONTROL_READS)
 	return STATUS_FAILURE;
 
-	if (pDevice->Flags & fMP_CONTROL_WRITES)
-		return STATUS_FAILURE;
-
 	if (pDevice->pControlURB->hcpriv)
 		return STATUS_FAILURE;
 
@@ -239,27 +187,6 @@ int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
     return ntStatus;
 }
 
-static void s_nsControlInUsbIoCompleteWrite(struct urb *urb)
-{
-	struct vnt_private *pDevice = (struct vnt_private *)urb->context;
-
-	pDevice = urb->context;
-	switch (urb->status) {
-	case 0:
-		break;
-	case -EINPROGRESS:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ctrl write urb status EINPROGRESS%d\n", urb->status);
-		break;
-	case -ENOENT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ctrl write urb status ENOENT %d\n", urb->status);
-		break;
-	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ctrl write urb status %d\n", urb->status);
-	}
-
-    MP_CLEAR_FLAG(pDevice, fMP_CONTROL_WRITES);
-}
-
 /*
  * Description:
  *      Complete function of usb Control callback
-- 
1.9.1

