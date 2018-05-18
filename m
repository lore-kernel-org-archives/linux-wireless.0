Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752224AbeERKia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 06:38:30 -0400
Date: Fri, 18 May 2018 12:38:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Carlos Manuel Santos <cmmpsantos@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH v3] NFC: pn533: don't send USB data off of the stack
Message-ID: <20180518103811.GA29186@kroah.com> (sfid-20180518_123833_527986_B52B4E21)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's amazing that this driver ever worked, but now that x86 doesn't
allow USB data to be sent off of the stack, it really does not work at
all.  Fix this up by properly allocating the data for the small
"commands" that get sent to the device.

The USB stack will free the buffer when the data has been transmitted,
that is why there is no kfree() to mirror the call to kmalloc().

Reported-by: Carlos Manuel Santos <cmmpsantos@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Stephen Hemminger <stephen@networkplumber.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
v3: actually use the correct buffer (thanks to Arend van Spriel)
    use kmemdup (thanks to Johannes Berg and Julia Lawall)
v2: set the urb flags correctly

 drivers/nfc/pn533/usb.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -150,10 +150,16 @@ static int pn533_usb_send_ack(struct pn5
 	struct pn533_usb_phy *phy = dev->phy;
 	static const u8 ack[6] = {0x00, 0x00, 0xff, 0x00, 0xff, 0x00};
 	/* spec 7.1.1.3:  Preamble, SoPC (2), ACK Code (2), Postamble */
+	char *buffer;
 	int rc;
 
-	phy->out_urb->transfer_buffer = (u8 *)ack;
+	buffer = kmemdup(ack, sizeof(ack), GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	phy->out_urb->transfer_buffer = buffer;
 	phy->out_urb->transfer_buffer_length = sizeof(ack);
+	phy->out_urb->transfer_flags |= URB_FREE_BUFFER;
 	rc = usb_submit_urb(phy->out_urb, flags);
 
 	return rc;
@@ -170,6 +176,7 @@ static int pn533_usb_send_frame(struct p
 
 	phy->out_urb->transfer_buffer = out->data;
 	phy->out_urb->transfer_buffer_length = out->len;
+	phy->out_urb->transfer_flags &= ~URB_FREE_BUFFER;
 
 	print_hex_dump_debug("PN533 TX: ", DUMP_PREFIX_NONE, 16, 1,
 			     out->data, out->len, false);
@@ -375,20 +382,26 @@ static int pn533_acr122_poweron_rdr(stru
 	/* Power on th reader (CCID cmd) */
 	u8 cmd[10] = {PN533_ACR122_PC_TO_RDR_ICCPOWERON,
 		      0, 0, 0, 0, 0, 0, 3, 0, 0};
+	char *buffer;
 	int rc;
 	void *cntx;
 	struct pn533_acr122_poweron_rdr_arg arg;
 
 	dev_dbg(&phy->udev->dev, "%s\n", __func__);
 
+	buffer = kmemdup(cmd, sizeof(cmd), GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
 	init_completion(&arg.done);
 	cntx = phy->in_urb->context;  /* backup context */
 
 	phy->in_urb->complete = pn533_acr122_poweron_rdr_resp;
 	phy->in_urb->context = &arg;
 
-	phy->out_urb->transfer_buffer = cmd;
+	phy->out_urb->transfer_buffer = buffer;
 	phy->out_urb->transfer_buffer_length = sizeof(cmd);
+	phy->out_urb->transfer_flags |= URB_FREE_BUFFER;
 
 	print_hex_dump_debug("ACR122 TX: ", DUMP_PREFIX_NONE, 16, 1,
 		       cmd, sizeof(cmd), false);
