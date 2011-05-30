Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-01.sanoma.fi ([158.127.18.161]:41463 "EHLO
	sd-mail-sa-01.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab1E3HVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 03:21:25 -0400
Subject: [PATCH wireless-2.6] zd1211rw: fix to work on OHCI
To: "John W. Linville" <linville@tuxdriver.com>
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Date: Mon, 30 May 2011 10:15:47 +0300
Message-ID: <20110530071547.1834.38429.stgit@localhost6.localdomain6> (sfid-20110530_092130_531599_FB875202)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

zd1211 devices register 'EP 4 OUT' endpoint as Interrupt type on USB 2.0:

      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               1

However on USB 1.1 endpoint becomes Bulk:

      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x04  EP 4 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0

Commit 37939810b937aba830dd751291fcdc51cae1a6cb assumed that endpoint is
always interrupt type and changed usb_bulk_msg() calls to usb_interrupt_msg().

Problem here is that usb_bulk_msg() on interrupt endpoint selfcorrects the
call and changes requested pipe to interrupt type (see usb_bulk_msg).
However with usb_interrupt_msg() on bulk endpoint does not correct the
pipe type to bulk, but instead URB is submitted with interrupt type pipe.

So pre-2.6.39 used usb_bulk_msg() and therefore worked with both endpoint
types, however in 2.6.39 usb_interrupt_msg() with bulk endpoint causes
ohci_hcd to fail submitted URB instantly with -ENOSPC and preventing zd1211rw
from working with OHCI.

Fix this by detecting endpoint type and using correct endpoint/pipe types
for URB. Also fix asynchronous zd_usb_iowrite16v_async() to use right
URB type on 'EP 4 OUT'.

Cc: stable@kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
---
 drivers/net/wireless/zd1211rw/zd_usb.c |   53 +++++++++++++++++++++++++-------
 1 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/zd1211rw/zd_usb.c b/drivers/net/wireless/zd1211rw/zd_usb.c
index 0e81994..631194d 100644
--- a/drivers/net/wireless/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zd1211rw/zd_usb.c
@@ -1533,6 +1533,31 @@ static void __exit usb_exit(void)
 module_init(usb_init);
 module_exit(usb_exit);
 
+static int zd_ep_regs_out_msg(struct usb_device *udev, void *data, int len,
+			      int *actual_length, int timeout)
+{
+	/* In USB 2.0 mode EP_REGS_OUT endpoint is interrupt type. However in
+	 * USB 1.1 mode endpoint is bulk. Select correct type URB by endpoint
+	 * descriptor.
+	 */
+	struct usb_host_endpoint *ep;
+	unsigned int pipe;
+
+	pipe = usb_sndintpipe(udev, EP_REGS_OUT);
+	ep = usb_pipe_endpoint(udev, pipe);
+	if (!ep)
+		return -EINVAL;
+
+	if (usb_endpoint_xfer_int(&ep->desc)) {
+		return usb_interrupt_msg(udev, pipe, data, len,
+					 actual_length, timeout);
+	} else {
+		pipe = usb_sndbulkpipe(udev, EP_REGS_OUT);
+		return usb_bulk_msg(udev, pipe, data, len, actual_length,
+				    timeout);
+	}
+}
+
 static int usb_int_regs_length(unsigned int count)
 {
 	return sizeof(struct usb_int_regs) + count * sizeof(struct reg_data);
@@ -1648,15 +1673,14 @@ int zd_usb_ioread16v(struct zd_usb *usb, u16 *values,
 
 	udev = zd_usb_to_usbdev(usb);
 	prepare_read_regs_int(usb);
-	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			      req, req_len, &actual_req_len, 50 /* ms */);
+	r = zd_ep_regs_out_msg(udev, req, req_len, &actual_req_len, 50 /*ms*/);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_interrupt_msg(). Error number %d\n", r);
+			"error in zd_ep_regs_out_msg(). Error number %d\n", r);
 		goto error;
 	}
 	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb), "error in usb_interrupt_msg()\n"
+		dev_dbg_f(zd_usb_dev(usb), "error in zd_ep_regs_out_msg()\n"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;
@@ -1818,9 +1842,17 @@ int zd_usb_iowrite16v_async(struct zd_usb *usb, const struct zd_ioreq16 *ioreqs,
 		rw->value = cpu_to_le16(ioreqs[i].value);
 	}
 
-	usb_fill_int_urb(urb, udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			 req, req_len, iowrite16v_urb_complete, usb,
-			 ep->desc.bInterval);
+	/* In USB 2.0 mode endpoint is interrupt type. However in USB 1.1 mode
+	 * endpoint is bulk. Select correct type URB by endpoint descriptor.
+	 */
+	if (usb_endpoint_xfer_int(&ep->desc))
+		usb_fill_int_urb(urb, udev, usb_sndintpipe(udev, EP_REGS_OUT),
+				 req, req_len, iowrite16v_urb_complete, usb,
+				 ep->desc.bInterval);
+	else
+		usb_fill_bulk_urb(urb, udev, usb_sndbulkpipe(udev, EP_REGS_OUT),
+				  req, req_len, iowrite16v_urb_complete, usb);
+
 	urb->transfer_flags |= URB_FREE_BUFFER;
 
 	/* Submit previous URB */
@@ -1924,15 +1956,14 @@ int zd_usb_rfwrite(struct zd_usb *usb, u32 value, u8 bits)
 	}
 
 	udev = zd_usb_to_usbdev(usb);
-	r = usb_interrupt_msg(udev, usb_sndintpipe(udev, EP_REGS_OUT),
-			      req, req_len, &actual_req_len, 50 /* ms */);
+	r = zd_ep_regs_out_msg(udev, req, req_len, &actual_req_len, 50 /*ms*/);
 	if (r) {
 		dev_dbg_f(zd_usb_dev(usb),
-			"error in usb_interrupt_msg(). Error number %d\n", r);
+			"error in zd_ep_regs_out_msg(). Error number %d\n", r);
 		goto out;
 	}
 	if (req_len != actual_req_len) {
-		dev_dbg_f(zd_usb_dev(usb), "error in usb_interrupt_msg()"
+		dev_dbg_f(zd_usb_dev(usb), "error in zd_ep_regs_out_msg()"
 			" req_len %d != actual_req_len %d\n",
 			req_len, actual_req_len);
 		r = -EIO;

