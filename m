Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54857 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaECOUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2014 10:20:06 -0400
Received: by mail-we0-f176.google.com with SMTP id q59so3374220wes.35
        for <linux-wireless@vger.kernel.org>; Sat, 03 May 2014 07:20:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/13] staging: vt6656: PIPEnsControlIn use usb_control_msg
Date: Sat,  3 May 2014 15:17:33 +0100
Message-Id: <1399126654-2663-12-git-send-email-tvboxspy@gmail.com> (sfid-20140503_163657_320921_8204E790)
In-Reply-To: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
References: <1399126654-2663-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that this function is nolonger atomic useusb_control_msg.

Return STATUS_FAILURE if ntStatus less than wLength

Remove the old struct urb and struct usb_ctrlrequest structures.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/device.h   |  3 --
 drivers/staging/vt6656/main_usb.c | 11 -----
 drivers/staging/vt6656/usbpipe.c  | 94 ++++-----------------------------------
 3 files changed, 9 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index da1b70d..410e028 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -380,9 +380,7 @@ struct vnt_private {
 	u32 uCurrentDFCBIdx;
 
 	/* USB */
-	struct urb *pControlURB;
 	struct urb *pInterruptURB;
-	struct usb_ctrlrequest sUsbCtlRequest;
 	u32 int_interval;
 
 	/* Variables to track resources for the BULK In Pipe */
@@ -743,7 +741,6 @@ struct vnt_private {
 #define fMP_RECV_SIDE_RESOURCE_ALLOCATED    0x00000080
 #define fMP_POST_READS                      0x00000100
 #define fMP_POST_WRITES                     0x00000200
-#define fMP_CONTROL_READS                   0x00000400
 
 #define MP_SET_FLAG(_M, _F)             ((_M)->Flags |= (_F))
 #define MP_CLEAR_FLAG(_M, _F)            ((_M)->Flags &= ~(_F))
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 6ca5d78..1b58cca 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -702,12 +702,6 @@ vt6656_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	INIT_WORK(&pDevice->read_work_item, RXvWorkItem);
 	INIT_WORK(&pDevice->rx_mng_work_item, RXvMngWorkItem);
 
-	pDevice->pControlURB = usb_alloc_urb(0, GFP_ATOMIC);
-	if (!pDevice->pControlURB) {
-		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR"Failed to alloc control urb\n");
-		goto err_netdev;
-	}
-
 	pDevice->tx_80211 = device_dma0_tx_80211;
 	pDevice->vnt_mgmt.pAdapter = (void *) pDevice;
 
@@ -964,7 +958,6 @@ static int  device_open(struct net_device *dev)
     }
 
     MP_CLEAR_FLAG(pDevice, fMP_DISCONNECTED);
-    MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
     MP_SET_FLAG(pDevice, fMP_POST_READS);
     MP_SET_FLAG(pDevice, fMP_POST_WRITES);
 
@@ -1130,10 +1123,6 @@ static void vt6656_disconnect(struct usb_interface *intf)
 
 	if (device->dev) {
 		unregister_netdev(device->dev);
-
-		usb_kill_urb(device->pControlURB);
-		usb_free_urb(device->pControlURB);
-
 		free_netdev(device->dev);
 	}
 }
diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 1ab3958..9946bfd 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -63,7 +63,6 @@ static int          msglevel                =MSG_LEVEL_INFO;
 static void s_nsInterruptUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkInUsbIoCompleteRead(struct urb *urb);
 static void s_nsBulkOutIoCompleteWrite(struct urb *urb);
-static void s_nsControlInUsbIoCompleteRead(struct urb *urb);
 
 int PIPEnsControlOutAsyn(struct vnt_private *pDevice, u8 byRequest,
 	u16 wValue, u16 wIndex, u16 wLength, u8 *pbyBuffer)
@@ -126,100 +125,25 @@ int PIPEnsControlOut(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
 }
 
 int PIPEnsControlIn(struct vnt_private *pDevice, u8 byRequest, u16 wValue,
-	u16 wIndex, u16 wLength,  u8 *pbyBuffer)
-	__releases(&pDevice->lock)
-	__acquires(&pDevice->lock)
+	u16 wIndex, u16 wLength, u8 *pbyBuffer)
 {
-	int ntStatus = 0;
-	int ii;
-
-    if (pDevice->Flags & fMP_DISCONNECTED)
-        return STATUS_FAILURE;
-
-    if (pDevice->Flags & fMP_CONTROL_READS)
-	return STATUS_FAILURE;
+	int ntStatus;
 
-	if (pDevice->pControlURB->hcpriv)
+	if (pDevice->Flags & fMP_DISCONNECTED)
 		return STATUS_FAILURE;
 
 	mutex_lock(&pDevice->usb_lock);
 
-	MP_SET_FLAG(pDevice, fMP_CONTROL_READS);
-
-	pDevice->sUsbCtlRequest.bRequestType = 0xC0;
-	pDevice->sUsbCtlRequest.bRequest = byRequest;
-	pDevice->sUsbCtlRequest.wValue = cpu_to_le16p(&wValue);
-	pDevice->sUsbCtlRequest.wIndex = cpu_to_le16p(&wIndex);
-	pDevice->sUsbCtlRequest.wLength = cpu_to_le16p(&wLength);
-	pDevice->pControlURB->transfer_flags |= URB_ASYNC_UNLINK;
-    pDevice->pControlURB->actual_length = 0;
-	usb_fill_control_urb(pDevice->pControlURB, pDevice->usb,
-			 usb_rcvctrlpipe(pDevice->usb , 0), (char *) &pDevice->sUsbCtlRequest,
-			 pbyBuffer, wLength, s_nsControlInUsbIoCompleteRead, pDevice);
-
-	ntStatus = usb_submit_urb(pDevice->pControlURB, GFP_ATOMIC);
-	if (ntStatus != 0) {
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO
-			"control request submission failed: %d\n", ntStatus);
-		MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
-		mutex_unlock(&pDevice->usb_lock);
-		return STATUS_FAILURE;
-	}
-
-    for (ii = 0; ii <= USB_CTL_WAIT; ii ++) {
-
-	if (pDevice->Flags & fMP_CONTROL_READS)
-		mdelay(1);
-	else
-		break;
-
-	if (ii >= USB_CTL_WAIT) {
-		DBG_PRT(MSG_LEVEL_DEBUG,
-			KERN_INFO "control rcv request submission timeout\n");
-            MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
-	    mutex_unlock(&pDevice->usb_lock);
-            return STATUS_FAILURE;
-        }
-    }
+	ntStatus = usb_control_msg(pDevice->usb,
+		usb_rcvctrlpipe(pDevice->usb, 0), byRequest, 0xc0, wValue,
+			wIndex, pbyBuffer, wLength, USB_CTL_WAIT);
 
 	mutex_unlock(&pDevice->usb_lock);
 
-    return ntStatus;
-}
-
-/*
- * Description:
- *      Complete function of usb Control callback
- *
- * Parameters:
- *  In:
- *      pDevice     - Pointer to the adapter
- *
- *  Out:
- *      none
- *
- * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
- *
- */
-
-static void s_nsControlInUsbIoCompleteRead(struct urb *urb)
-{
-	struct vnt_private *pDevice = (struct vnt_private *)urb->context;
-
-	switch (urb->status) {
-	case 0:
-		break;
-	case -EINPROGRESS:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ctrl read urb status EINPROGRESS%d\n", urb->status);
-		break;
-	case -ENOENT:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ctrl read urb status = ENOENT %d\n", urb->status);
-		break;
-	default:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"ctrl read urb status %d\n", urb->status);
-	}
+	if (ntStatus < (int)wLength)
+		return STATUS_FAILURE;
 
-    MP_CLEAR_FLAG(pDevice, fMP_CONTROL_READS);
+	return STATUS_SUCCESS;
 }
 
 /*
-- 
1.9.1

