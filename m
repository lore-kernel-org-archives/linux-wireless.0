Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50924 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab1L0SW6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 13:22:58 -0500
Date: Tue, 27 Dec 2011 12:22:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: users@rt2x00.serialmonkey.com, helmut.schaa@googlemail.com,
	gwingerde@gmail.com, IvDoorn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH V2] rt2800usb: Move ID out of unknown
Message-ID: <4efa0cfb.QRlP24Yb0ASrlhga%Larry.Finger@lwfinger.net> (sfid-20111227_192301_218242_11E812CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testing on the openSUSE wireless forum has shown that a Linksys
WUSB54GC v3 with USB ID 1737:0077 works with rt2800usb when the ID is
written to /sys/.../new_id. This ID can therefore be moved out of UNKNOWN.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

V2 - Place new ID with rest of Linksys devices.

Index: wireless-testing-new/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rt2x00/rt2800usb.c
+++ wireless-testing-new/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -976,6 +976,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x13b1, 0x0031) },
 	{ USB_DEVICE(0x1737, 0x0070) },
 	{ USB_DEVICE(0x1737, 0x0071) },
+	{ USB_DEVICE(0x1737, 0x0077) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0162) },
 	{ USB_DEVICE(0x0789, 0x0163) },
@@ -1173,7 +1174,6 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x1740, 0x0605) },
 	{ USB_DEVICE(0x1740, 0x0615) },
 	/* Linksys */
-	{ USB_DEVICE(0x1737, 0x0077) },
 	{ USB_DEVICE(0x1737, 0x0078) },
 	/* Logitec */
 	{ USB_DEVICE(0x0789, 0x0168) },
