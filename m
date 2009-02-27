Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:26879 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497AbZB0Xjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 18:39:54 -0500
Received: by ey-out-2122.google.com with SMTP id 25so372136eya.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 15:39:51 -0800 (PST)
Message-ID: <49A8787F.3090000@gmail.com> (sfid-20090228_003959_219827_7E0B9C85)
Date: Sat, 28 Feb 2009 00:34:23 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>, IvDoorn@gmail.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH 2.6.29-rc6 1/1] rt2x00 : more devices to rt73usb.c
Content-Type: multipart/mixed;
 boundary="------------020208060601030304040503"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020208060601030304040503
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

add more usb_dev to rt73usb.c . IDs 'stolen' from the
windows inf file(10/21/2008, 1.03.02.0000) plus some
from the Ralink linux driver(2009_0206_RT73_Linux_STA_Drv1.1.0.2.tar.bz2)

Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---

John please, add it to the wireless tree.

-thanks-

regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...

--------------020208060601030304040503
Content-Type: text/plain;
 name="more_dev_id_rt73usb.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="more_dev_id_rt73usb.diff"

--- linux-2.6/drivers/net/wireless/rt2x00/rt73usb.c	2009-01-16 02:12:01.000000000 +0100
+++ b/drivers/net/wireless/rt2x00/rt73usb.c	2009-02-27 22:54:17.000000000 +0100
@@ -2281,7 +2281,18 @@
  */
 static struct usb_device_id rt73usb_device_table[] = {
 	/* AboCom */
+	{ USB_DEVICE(0x07b8, 0xb21b), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x07b8, 0xb21c), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x07b8, 0xb21d), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x07b8, 0xb21e), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x07b8, 0xb21f), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* AL */
+	{ USB_DEVICE(0x14b2, 0x3c10), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Amigo */
+	{ USB_DEVICE(0x148f, 0x9021), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0eb0, 0x9021), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* AMIT  */
+	{ USB_DEVICE(0x18c5, 0x0002), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Askey */
 	{ USB_DEVICE(0x1690, 0x0722), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* ASUS */
@@ -2294,7 +2305,9 @@
 	{ USB_DEVICE(0x050d, 0x905c), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Billionton */
 	{ USB_DEVICE(0x1631, 0xc019), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x08dd, 0x0120), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Buffalo */
+	{ USB_DEVICE(0x0411, 0x00d8), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0411, 0x00f4), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* CNet */
 	{ USB_DEVICE(0x1371, 0x9022), USB_DEVICE_DATA(&rt73usb_ops) },
@@ -2308,6 +2321,11 @@
 	{ USB_DEVICE(0x07d1, 0x3c04), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c06), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x07d1, 0x3c07), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Edimax */
+	{ USB_DEVICE(0x7392, 0x7318), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x7392, 0x7618), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* EnGenius */
+	{ USB_DEVICE(0x1740, 0x3701), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Gemtek */
 	{ USB_DEVICE(0x15a9, 0x0004), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Gigabyte */
@@ -2328,22 +2346,34 @@
 	{ USB_DEVICE(0x0db0, 0xa861), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0db0, 0xa874), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Ralink */
+	{ USB_DEVICE(0x04bb, 0x093d), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Qcom */
 	{ USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x18e8, 0x6238), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Samsung */
+	{ USB_DEVICE(0x04e8, 0x4471), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Senao */
 	{ USB_DEVICE(0x1740, 0x7100), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Sitecom */
-	{ USB_DEVICE(0x0df6, 0x9712), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0024), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x0027), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x002f), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x0df6, 0x90ac), USB_DEVICE_DATA(&rt73usb_ops) },
+	{ USB_DEVICE(0x0df6, 0x9712), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Surecom */
 	{ USB_DEVICE(0x0769, 0x31f3), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Philips */
+	{ USB_DEVICE(0x0471, 0x200a), USB_DEVICE_DATA(&rt73usb_ops) },
 	/* Planex */
 	{ USB_DEVICE(0x2019, 0xab01), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ USB_DEVICE(0x2019, 0xab50), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* Zcom */
+	{ USB_DEVICE(0x0cde, 0x001c), USB_DEVICE_DATA(&rt73usb_ops) },
+	/* ZyXEL */
+	{ USB_DEVICE(0x0586, 0x3415), USB_DEVICE_DATA(&rt73usb_ops) },
 	{ 0, }
 };
 

--------------020208060601030304040503--

