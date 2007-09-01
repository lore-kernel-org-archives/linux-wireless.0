Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:63607 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbXIAEec (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:34:32 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 350F8618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:34:32 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 03/35] Rewrite at76_alloc_urbs() in a more linear fashion
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:34:31 -0400
Message-ID: <20070901043431.2498.11849.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   66 +++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 31 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index be9ef6e..d1d604e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -2026,8 +2026,7 @@ static void at76_delete_device(struct at76_priv *priv)
 static int at76_alloc_urbs(struct at76_priv *priv,
 			   struct usb_interface *interface)
 {
-	struct usb_endpoint_descriptor *endpoint;
-	struct usb_device *udev = priv->udev;
+	struct usb_endpoint_descriptor *endpoint, *ep_in, *ep_out;
 	int i;
 	int buffer_size;
 	struct usb_host_interface *iface_desc;
@@ -2037,41 +2036,46 @@ static int at76_alloc_urbs(struct at76_priv *priv,
 	at76_dbg(DBG_URB, "%s: NumEndpoints %d ", __func__,
 		 interface->altsetting[0].desc.bNumEndpoints);
 
+	ep_in = NULL;
+	ep_out = NULL;
 	iface_desc = interface->cur_altsetting;
 	for (i = 0; i < iface_desc->desc.bNumEndpoints; i++) {
 		endpoint = &iface_desc->endpoint[i].desc;
 
 		at76_dbg(DBG_URB, "%s: %d. endpoint: addr 0x%x attr 0x%x",
-			 __func__,
-			 i, endpoint->bEndpointAddress, endpoint->bmAttributes);
-
-		if (usb_endpoint_is_bulk_in(endpoint)) {
-			priv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!priv->read_urb) {
-				err("No free urbs available");
-				return -ENOMEM;
-			}
-			priv->rx_bulk_pipe =
-			    usb_rcvbulkpipe(udev, endpoint->bEndpointAddress);
-		}
+			 __func__, i, endpoint->bEndpointAddress,
+			 endpoint->bmAttributes);
 
-		if (usb_endpoint_is_bulk_out(endpoint)) {
-			priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!priv->write_urb) {
-				err("no free urbs available");
-				return -ENOMEM;
-			}
-			buffer_size = sizeof(struct at76_tx_buffer) +
-			    MAX_PADDING_SIZE;
-			priv->tx_bulk_pipe =
-			    usb_sndbulkpipe(udev, endpoint->bEndpointAddress);
-			priv->bulk_out_buffer =
-			    kmalloc(buffer_size, GFP_KERNEL);
-			if (!priv->bulk_out_buffer) {
-				err("couldn't allocate bulk_out_buffer");
-				return -ENOMEM;
-			}
-		}
+		if (!ep_in && usb_endpoint_is_bulk_in(endpoint))
+			ep_in = endpoint;
+
+		if (!ep_out && usb_endpoint_is_bulk_out(endpoint))
+			ep_out = endpoint;
+	}
+
+	if (!ep_in || !ep_out) {
+		printk(KERN_ERR DRIVER_NAME ": bulk endpoints missing\n");
+		return -ENXIO;
+	}
+
+	priv->rx_bulk_pipe =
+	    usb_rcvbulkpipe(priv->udev, ep_in->bEndpointAddress);
+	priv->tx_bulk_pipe =
+	    usb_sndbulkpipe(priv->udev, ep_out->bEndpointAddress);
+
+	priv->read_urb = usb_alloc_urb(0, GFP_KERNEL);
+	priv->write_urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!priv->read_urb || !priv->write_urb) {
+		printk(KERN_ERR DRIVER_NAME ": cannot allocate URB\n");
+		return -ENOMEM;
+	}
+
+	buffer_size = sizeof(struct at76_tx_buffer) + MAX_PADDING_SIZE;
+	priv->bulk_out_buffer = kmalloc(buffer_size, GFP_KERNEL);
+	if (!priv->bulk_out_buffer) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": cannot allocate output buffer\n");
+		return -ENOMEM;
 	}
 
 	at76_dbg(DBG_PROC_ENTRY, "%s: EXIT", __func__);
