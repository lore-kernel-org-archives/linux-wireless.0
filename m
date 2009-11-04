Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:36382 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZKDFsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 00:48:50 -0500
Date: Tue, 03 Nov 2009 23:48:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [RFC] usb: Check results of dma_map_single
Message-ID: <4af115c3.JUDAYfcydqPYCYyH%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At http://marc.info/?l=linux-wireless&m=125695331205062&w=2, a problem
with DMA buffer processing was corrected for the libertas driver. Because
routine usb_fill_bulk_urb() does not check that DMA is possible when
dma_map_single() is called, this condition was not detected until the buffer
was unmapped. By this time memory corruption had occurred.

The situation is fixed by testing the returned DMA address. If not a legal
address, a WARN_ON(1) is executed to provide traceback and the error is
returned.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: linux-2.6/drivers/usb/core/hcd.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd.c
+++ linux-2.6/drivers/usb/core/hcd.c
@@ -1281,6 +1281,13 @@ static int map_urb_for_dma(struct usb_hc
 					urb->setup_packet,
 					sizeof(struct usb_ctrlrequest),
 					DMA_TO_DEVICE);
+			ret = dma_mapping_error(hcd->self.controller,
+						urb->setup_dma);
+			/* warn if DMA mapping failed */
+			if (ret) {
+				WARN_ON(1);
+				return ret;
+			}
 		else if (hcd->driver->flags & HCD_LOCAL_MEM)
 			ret = hcd_alloc_coherent(
 					urb->dev->bus, mem_flags,
@@ -1299,6 +1306,13 @@ static int map_urb_for_dma(struct usb_hc
 					urb->transfer_buffer,
 					urb->transfer_buffer_length,
 					dir);
+			ret = dma_mapping_error(hcd->self.controller,
+						urb->transfer_dma);
+			/* warn if DMA mapping failed */
+			if (ret) {
+				WARN_ON(1);
+				return ret;
+			}
 		else if (hcd->driver->flags & HCD_LOCAL_MEM) {
 			ret = hcd_alloc_coherent(
 					urb->dev->bus, mem_flags,
