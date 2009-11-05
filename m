Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47604 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbZKEQhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2009 11:37:00 -0500
Date: Thu, 05 Nov 2009 10:37:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] usb: Check results of dma_map_single
Message-ID: <4af2ff2f.kX7PBMN9YqPE1zMk%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In map_urb_for_dma(), the DMA address returned by dma_map_single()
is not checked to determine if it is legal. This lack of checking
contributed to a problem with the libertas wireless driver
(http://marc.info/?l=linux-wireless&m=125695331205062&w=2). The
difficulty was not detected until the buffer was unmapped. By this
time memory corruption had occurred.

The situation is fixed by testing the returned DMA address, and
returning -EAGAIN if the address is invalid.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/usb/core/hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd.c
+++ linux-2.6/drivers/usb/core/hcd.c
@@ -1275,13 +1275,16 @@ static int map_urb_for_dma(struct usb_hc
 
 	if (usb_endpoint_xfer_control(&urb->ep->desc)
 	    && !(urb->transfer_flags & URB_NO_SETUP_DMA_MAP)) {
-		if (hcd->self.uses_dma)
+		if (hcd->self.uses_dma) {
 			urb->setup_dma = dma_map_single(
 					hcd->self.controller,
 					urb->setup_packet,
 					sizeof(struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
-		else if (hcd->driver->flags & HCD_LOCAL_MEM)
+			if (dma_mapping_error(hcd->self.controller,
+						urb->setup_dma))
+				return -EAGAIN;
+		} else if (hcd->driver->flags & HCD_LOCAL_MEM)
 			ret = hcd_alloc_coherent(
 					urb->dev->bus, mem_flags,
 					&urb->setup_dma,
@@ -1293,13 +1296,16 @@ static int map_urb_for_dma(struct usb_hc
 	dir = usb_urb_dir_in(urb) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 	if (ret == 0 && urb->transfer_buffer_length != 0
 	    && !(urb->transfer_flags & URB_NO_TRANSFER_DMA_MAP)) {
-		if (hcd->self.uses_dma)
+		if (hcd->self.uses_dma) {
 			urb->transfer_dma = dma_map_single (
 					hcd->self.controller,
 					urb->transfer_buffer,
 					urb->transfer_buffer_length,
 					dir);
-		else if (hcd->driver->flags & HCD_LOCAL_MEM) {
+			if (dma_mapping_error(hcd->self.controller,
+						urb->transfer_dma))
+				return -EAGAIN;
+		} else if (hcd->driver->flags & HCD_LOCAL_MEM) {
 			ret = hcd_alloc_coherent(
 					urb->dev->bus, mem_flags,
 					&urb->transfer_dma,
