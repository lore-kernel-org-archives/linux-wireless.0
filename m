Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38161 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbcEQHcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2016 03:32:39 -0400
Date: Tue, 17 May 2016 10:32:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Michael Thalmeier <michael.thalmeier@hale.at>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] NFC: pn533: double free on error in probe()
Message-ID: <20160517073219.GC10872@mwanda> (sfid-20160517_093242_338562_E96A1214)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can't pass devm_ allocated pointers to kfree() because they will be
freed again after the drive is unloaded.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/nfc/pn533/usb.c b/drivers/nfc/pn533/usb.c
index 8ca0603..33ed78b 100644
--- a/drivers/nfc/pn533/usb.c
+++ b/drivers/nfc/pn533/usb.c
@@ -464,10 +464,8 @@ static int pn533_usb_probe(struct usb_interface *interface,
 		return -ENOMEM;
 
 	in_buf = kzalloc(in_buf_len, GFP_KERNEL);
-	if (!in_buf) {
-		rc = -ENOMEM;
-		goto out_free_phy;
-	}
+	if (!in_buf)
+		return -ENOMEM;
 
 	phy->udev = usb_get_dev(interface_to_usbdev(interface));
 	phy->interface = interface;
@@ -554,8 +552,7 @@ error:
 	usb_free_urb(phy->out_urb);
 	usb_put_dev(phy->udev);
 	kfree(in_buf);
-out_free_phy:
-	kfree(phy);
+
 	return rc;
 }
 
