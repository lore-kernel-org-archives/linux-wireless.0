Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51344 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934447AbeCSQkQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Mar 2018 12:40:16 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Michael Thalmeier <michael.thalmeier@hale.at>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] NFC: pn533: Use kmalloc-ed memory for USB transfer buffers
Date: Mon, 19 Mar 2018 17:40:11 +0100
Message-Id: <20180319164012.31714-1-hdegoede@redhat.com> (sfid-20180319_174036_336599_9780FE51)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 8b55d7581fc5 ("NFC: pn533: use constant off-stack buffer for sending
acks"), fixed the ack case of using on stack mem for the transfer_buffer,
by making the ack buffer "static const", which is an unusual solution for
this and I wonder if this is not a problem wrt buffer alignment. It also
misses fixing the same problem for the cmd buffer in the
pn533_acr122_poweron_rdr() function.

This commit introduces an out_buf which gets kmalloc-ed on probe and
then memcpy-s the ack / cmd buffer into that buffer before submitting
the out urb. Fixing the use of on stack memory for the cmd buffer and
moving the ack code-path over to more conventional ways.

While at it this commit also changes the kmalloc of the in_buf to
devm_kmalloc, to avoid the need to introduce a new goto in the error-
handling of the kmalloc of the introduced out_buf.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1514134
Fixes: 8b55d7581fc5 ("NFC: pn533: use constant off-stack buffer ...")
Cc: Michał Mirosław <mirq-linux@rere.qmqm.pl>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/nfc/pn533/usb.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index e153e8b64bb8..c9398712ba31 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -42,6 +42,9 @@
 #define ACS_VENDOR_ID 0x072f
 #define ACR122U_PRODUCT_ID 0x2200
 
+/* Large enough to hold an ack or the power-on CCID command */
+#define OUT_BUF_LEN 16
+
 static const struct usb_device_id pn533_usb_table[] = {
 	{ USB_DEVICE(PN533_VENDOR_ID, PN533_PRODUCT_ID),
 	  .driver_info = PN533_DEVICE_STD },
@@ -61,6 +64,7 @@ struct pn533_usb_phy {
 
 	struct urb *out_urb;
 	struct urb *in_urb;
+	u8 *out_buf;
 
 	struct pn533 *priv;
 };
@@ -152,7 +156,8 @@ static int pn533_usb_send_ack(struct pn533 *dev, gfp_t flags)
 	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
 	int rc;
 
-	phy->out_urb->transfer_buffer = (u8 *)ack;
+	memcpy(phy->out_buf, ack, sizeof(ack));
+	phy->out_urb->transfer_buffer = phy->out_buf;
 	phy->out_urb->transfer_buffer_length = sizeof(ack);
 	rc = usb_submit_urb(phy->out_urb, flags);
 
@@ -373,8 +378,8 @@ static void pn533_acr122_poweron_rdr_resp(struct urb *urb)
 static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 {
 	/* Power on th reader (CCID cmd) */
-	u8 cmd[10] = {PN533_ACR122_PC_TO_RDR_ICCPOWERON,
-		      0, 0, 0, 0, 0, 0, 3, 0, 0};
+	static const u8 cmd[10] = { PN533_ACR122_PC_TO_RDR_ICCPOWERON,
+				    0, 0, 0, 0, 0, 0, 3, 0, 0 };
 	int rc;
 	void *cntx;
 	struct pn533_acr122_poweron_rdr_arg arg;
@@ -387,7 +392,8 @@ static int pn533_acr122_poweron_rdr(struct pn533_usb_phy *phy)
 	phy->in_urb->complete = pn533_acr122_poweron_rdr_resp;
 	phy->in_urb->context = &arg;
 
-	phy->out_urb->transfer_buffer = cmd;
+	memcpy(phy->out_buf, cmd, sizeof(cmd));
+	phy->out_urb->transfer_buffer = phy->out_buf;
 	phy->out_urb->transfer_buffer_length = sizeof(cmd);
 
 	print_hex_dump_debug("ACR122 TX: ", DUMP_PREFIX_NONE, 16, 1,
@@ -463,10 +469,14 @@ static int pn533_usb_probe(struct usb_interface *interface,
 	if (!phy)
 		return -ENOMEM;
 
-	in_buf = kzalloc(in_buf_len, GFP_KERNEL);
+	in_buf = devm_kzalloc(&interface->dev, in_buf_len, GFP_KERNEL);
 	if (!in_buf)
 		return -ENOMEM;
 
+	phy->out_buf = devm_kzalloc(&interface->dev, OUT_BUF_LEN, GFP_KERNEL);
+	if (!phy->out_buf)
+		return -ENOMEM;
+
 	phy->udev = usb_get_dev(interface_to_usbdev(interface));
 	phy->interface = interface;
 
@@ -555,7 +565,6 @@ static int pn533_usb_probe(struct usb_interface *interface,
 	usb_free_urb(phy->in_urb);
 	usb_free_urb(phy->out_urb);
 	usb_put_dev(phy->udev);
-	kfree(in_buf);
 
 	return rc;
 }
@@ -574,7 +583,6 @@ static void pn533_usb_disconnect(struct usb_interface *interface)
 	usb_kill_urb(phy->in_urb);
 	usb_kill_urb(phy->out_urb);
 
-	kfree(phy->in_urb->transfer_buffer);
 	usb_free_urb(phy->in_urb);
 	usb_free_urb(phy->out_urb);
 
-- 
2.14.3
