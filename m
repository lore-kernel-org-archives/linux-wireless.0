Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp03.smtpout.orange.fr ([80.12.242.125]:53157 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbcGTFrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 01:47:17 -0400
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
	sameo@linux.intel.com, michael.thalmeier@hale.at
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] NFC: pn533: Avoid a double free in error handling code
Date: Wed, 20 Jul 2016 07:46:51 +0200
Message-Id: <1468993611-21449-1-git-send-email-christophe.jaillet@wanadoo.fr> (sfid-20160720_074736_034109_6025B6E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

'phy' has been allocated with 'devm_kzalloc', so we should not free it
using an explicit 'kfree'. It would result in a double free if the
allocation of 'in_buf' fails.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nfc/pn533/usb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

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
 
-- 
2.7.4


---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus

