Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:5471 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZDJQQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 12:16:18 -0400
MIME-Version: 1.0
Date: Fri, 10 Apr 2009 18:16:16 +0200
Message-ID: <15d0b9b20904100916u3ff85ff5gd7a989120b7c048f@mail.gmail.com> (sfid-20090410_181622_176019_7B058F1E)
Subject: Additional USB identifier for otus driver [WN111v2]
From: Daniele Napolitano <dnax88@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a patch for Otus driver [Atheros 9k series] that provide
support for WN111v2 USB 802.11n
adapter.

Otus sources tree: OAL/Otus/Linux

--- zdusb.h.orig	2009-04-10 17:48:17.620423000 +0200
+++ zdusb.h	2009-04-10 17:54:41.356419568 +0200
@@ -26,5 +26,9 @@


 #define VENDOR_DLINK            0x07D1  //Dlink

 #define PRODUCT_DWA160A         0x3C10

+
+#define VENDOR_NETGEAR          0x0846  //NetGear
+#define PRODUCT_WNDA3100        0x9010
+#define PRODUCT_WN111v2         0x9001


 #endif


--- zdusb.c.orig	2009-04-10 17:48:17.620423000 +0200
+++ zdusb.c	2009-04-10 17:53:15.316421516 +0200
@@ -36,7 +36,8 @@
 static struct usb_device_id zd1221_ids [] = {

 	{ USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170) },

         { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA160A) },

-	{ USB_DEVICE(0x0846, 0x9010) },

+	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100) },
+	{ USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WN111v2) },

 	{ }					/* Terminating entry */

 };




-- 
Daniele "DnaX" Napolitano
https://launchpad.net/~dnax88
http://dnax.netsons.org/
