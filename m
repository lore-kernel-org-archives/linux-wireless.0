Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:58429 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1BFIf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 03:35:29 -0500
Subject: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and EP_INT_IN
	from interrupt to bulk
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ulrich Kunitz <kune@deine-taler.de>
Date: Sun, 06 Feb 2011 10:35:22 +0200
Message-ID: <20110206083522.16858.24185.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes high CPU usage when writing beacon frame to hardware. With this
patch CPU usage of kworker on Intel Atom with 100 TU beacon interval goes
from ~10% down to <1%.

Checking vendor driver appears it's also ignoring fact that endpoints are
interrupt type and is using bulk urbs on these.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   62 +++++++++++++++++++++++---------
 drivers/net/wireless/zd1211rw/zd_usb.h |    1 -
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index f6df366..65aff96 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -452,19 +452,6 @@ resubmit:
 	return;
 }
 
-static inline int int_urb_interval(struct usb_device *udev)
-{
-	switch (udev->speed) {
-	case USB_SPEED_HIGH:
-		return 4;
-	case USB_SPEED_LOW:
-		return 10;
-	case USB_SPEED_FULL:
-	default:
-		return 1;
-	}
-}
-
 static inline int usb_int_enabled(struct zd_usb *usb)
 {
 	unsigned long flags;
@@ -511,10 +498,9 @@ int zd_usb_enable_int(struct zd_usb *usb)
 		goto error_set_urb_null;
 	}
 
-	usb_fill_int_urb(urb, udev, usb_rcvintpipe(udev, EP_INT_IN),
+	usb_fill_bulk_urb(urb, udev, usb_rcvbulkpipe(udev, EP_INT_IN),
 			 intr->buffer, USB_MAX_EP_INT_BUFFER,
-			 int_urb_complete, usb,
-			 intr->interval);
+			 int_urb_complete, usb);
 	urb->transfer_dma = intr->buffer_dma;
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -1118,7 +1104,6 @@ static inline void init_usb_interrupt(struct zd_usb *usb)
 	struct zd_usb_interrupt *intr = &usb->intr;
 
 	spin_lock_init(&intr->lock);
-	intr->interval = int_urb_interval(zd_usb_to_usbdev(usb));
 	init_completion(&intr->read_regs.completion);
 	intr->read_regs.cr_int_addr = cpu_to_le16((u16)CR_INTERRUPT);
 }
@@ -1263,10 +1248,32 @@ static int eject_installer(struct usb_interface *intf)
 	return 0;
 }
 
+static int usb_endpoint_int_to_bulk(struct usb_device *udev, unsigned int pipe)
+{
+	struct usb_host_endpoint *ep;
+
+	ep = usb_pipe_endpoint(udev, pipe);
+	if (!ep)
+		return -EPIPE;
+
+	switch (ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK) {
+	case USB_ENDPOINT_XFER_INT:
+		ep->desc.bmAttributes &= ~USB_ENDPOINT_XFERTYPE_MASK;
+		ep->desc.bmAttributes |= USB_ENDPOINT_XFER_BULK;
+		ep->desc.bInterval = 0;
+		/* passthru */
+	case USB_ENDPOINT_XFER_BULK:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 int zd_usb_init_hw(struct zd_usb *usb)
 {
 	int r;
 	struct zd_mac *mac = zd_usb_to_mac(usb);
+	struct usb_device *udev = zd_usb_to_usbdev(usb);
 
 	dev_dbg_f(zd_usb_dev(usb), "\n");
 
@@ -1277,13 +1284,32 @@ int zd_usb_init_hw(struct zd_usb *usb)
 		return r;
 	}
 
-	r = usb_reset_configuration(zd_usb_to_usbdev(usb));
+	r = usb_reset_configuration(udev);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
 			"couldn't reset configuration. Error number %d\n", r);
 		return r;
 	}
 
+	/* Change EP_REGS_OUT and EP_INT_IN to bulk endpoints. This solves high
+	 * CPU usage of zd_mac_beacon_config.
+	 */
+	r = usb_endpoint_int_to_bulk(udev, usb_sndintpipe(udev, EP_REGS_OUT));
+	if (r) {
+		dev_dbg_f(zd_usb_dev(usb),
+			  "couldn't change EP_REGS_OUT endpoint type to bulk. "
+			  "Error number %d\n", r);
+		return r;
+	}
+
+	r = usb_endpoint_int_to_bulk(udev, usb_rcvintpipe(udev, EP_INT_IN));
+	if (r) {
+		dev_dbg_f(zd_usb_dev(usb),
+			  "couldn't change EP_INT_IN endpoint type to bulk. "
+			  "Error number %d\n", r);
+		return r;
+	}
+
 	r = zd_mac_init_hw(mac->hw);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
diff --git a/drivers/net/wireless/zd1211rw/zd_usb.h b/drivers/net/wireless/zd1211rw/zd_usb.h
index 2d688f4..333bb84 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.h
+++ b/drivers/net/wireless/zd1211rw/zd_usb.h
@@ -168,7 +168,6 @@ struct zd_usb_interrupt {
 	struct urb *urb;
 	void *buffer;
 	dma_addr_t buffer_dma;
-	int interval;
 	u8 read_regs_enabled:1;
 };
 

