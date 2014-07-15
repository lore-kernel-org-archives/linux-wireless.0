Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:63735 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbaGOS4J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 14:56:09 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so5964728wgh.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 11:56:07 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 12/12] staging: vt6656: usbpipe irrelevant function descriptions
Date: Tue, 15 Jul 2014 19:54:43 +0100
Message-Id: <1405450483-2875-12-git-send-email-tvboxspy@gmail.com> (sfid-20140715_205952_073048_60377B71)
In-Reply-To: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
References: <1405450483-2875-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All these have no or vague meaning.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/usbpipe.c | 100 ---------------------------------------
 1 file changed, 100 deletions(-)

diff --git a/drivers/staging/vt6656/usbpipe.c b/drivers/staging/vt6656/usbpipe.c
index 5fcfbf5..59e508c 100644
--- a/drivers/staging/vt6656/usbpipe.c
+++ b/drivers/staging/vt6656/usbpipe.c
@@ -117,20 +117,6 @@ void vnt_control_in_u8(struct vnt_private *priv, u8 reg, u8 reg_off, u8 *data)
 			reg_off, reg, sizeof(u8), data);
 }
 
-/*
- * Description:
- *      Allocates an usb interrupt in irp and calls USBD.
- *
- * Parameters:
- *  In:
- *      pDevice     - Pointer to the adapter
- *  Out:
- *      none
- *
- * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
- *
- */
-
 int vnt_start_interrupt_urb(struct vnt_private *priv)
 {
 	int status = STATUS_FAILURE;
@@ -158,21 +144,6 @@ int vnt_start_interrupt_urb(struct vnt_private *priv)
 	return status;
 }
 
-/*
- * Description:
- *      Complete function of usb interrupt in irp.
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
 static void vnt_start_interrupt_urb_complete(struct urb *urb)
 {
 	struct vnt_private *priv = urb->context;
@@ -211,20 +182,6 @@ static void vnt_start_interrupt_urb_complete(struct urb *urb)
 	return;
 }
 
-/*
- * Description:
- *      Allocates an usb BulkIn  irp and calls USBD.
- *
- * Parameters:
- *  In:
- *      pDevice     - Pointer to the adapter
- *  Out:
- *      none
- *
- * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
- *
- */
-
 int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 {
 	int status = 0;
@@ -256,21 +213,6 @@ int vnt_submit_rx_urb(struct vnt_private *priv, struct vnt_rcb *rcb)
 	return status;
 }
 
-/*
- * Description:
- *      Complete function of usb BulkIn irp.
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
 static void vnt_submit_rx_urb_complete(struct urb *urb)
 {
 	struct vnt_rcb *rcb = urb->context;
@@ -323,20 +265,6 @@ static void vnt_submit_rx_urb_complete(struct urb *urb)
 	return;
 }
 
-/*
- * Description:
- *      Allocates an usb BulkOut  irp and calls USBD.
- *
- * Parameters:
- *  In:
- *      pDevice     - Pointer to the adapter
- *  Out:
- *      none
- *
- * Return Value: STATUS_INSUFFICIENT_RESOURCES or result of IoCallDriver
- *
- */
-
 int vnt_tx_context(struct vnt_private *priv,
 				struct vnt_usb_send_context *context)
 {
@@ -369,34 +297,6 @@ int vnt_tx_context(struct vnt_private *priv,
 	return STATUS_PENDING;
 }
 
-/*
- * Description: vnt_tx_context_complete
- *     1a) Indicate to the protocol the status of the write.
- *     1b) Return ownership of the packet to the protocol.
- *
- *     2)  If any more packets are queue for sending, send another packet
- *         to USBD.
- *         If the attempt to send the packet to the driver fails,
- *         return ownership of the packet to the protocol and
- *         try another packet (until one succeeds).
- *
- * Parameters:
- *  In:
- *      pdoUsbDevObj  - pointer to the USB device object which
- *                      completed the irp
- *      pIrp          - the irp which was completed by the
- *                      device object
- *      pContext      - the context given to IoSetCompletionRoutine
- *                      before calling IoCallDriver on the irp
- *                      The pContext is a pointer to the USB device object.
- *  Out:
- *      none
- *
- * Return Value: STATUS_MORE_PROCESSING_REQUIRED - allows the completion routine
- *               (IofCompleteRequest) to stop working on the irp.
- *
- */
-
 static void vnt_tx_context_complete(struct urb *urb)
 {
 	struct vnt_usb_send_context *context = urb->context;
-- 
2.0.1

