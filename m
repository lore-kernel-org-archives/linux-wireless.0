Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.parknet.co.jp ([210.171.160.6]:44540 "EHLO
        mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751282AbcLYJ1O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Dec 2016 04:27:14 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        linux-wireless@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] nfc: Add support RC-S380P to port100
Date: Sun, 25 Dec 2016 18:00:41 +0900
Message-ID: <87tw9s9ydi.fsf@mail.parknet.co.jp> (sfid-20161225_102729_810867_52B5456E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/nfc/port100.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/nfc/port100.c~nfc-add-rcs380p drivers/nfc/port100.c
--- linux/drivers/nfc/port100.c~nfc-add-rcs380p	2016-12-18 22:16:53.503673411 +0900
+++ linux-hirofumi/drivers/nfc/port100.c	2016-12-18 22:16:53.504673416 +0900
@@ -21,8 +21,9 @@
 
 #define VERSION "0.1"
 
-#define SONY_VENDOR_ID    0x054c
-#define RCS380_PRODUCT_ID 0x06c1
+#define SONY_VENDOR_ID		0x054c
+#define RCS380S_PRODUCT_ID	0x06c1
+#define RCS380P_PRODUCT_ID	0x06c3
 
 #define PORT100_PROTOCOLS (NFC_PROTO_JEWEL_MASK    | \
 			   NFC_PROTO_MIFARE_MASK   | \
@@ -1477,7 +1478,8 @@ static struct nfc_digital_ops port100_di
 };
 
 static const struct usb_device_id port100_table[] = {
-	{ USB_DEVICE(SONY_VENDOR_ID, RCS380_PRODUCT_ID), },
+	{ USB_DEVICE(SONY_VENDOR_ID, RCS380S_PRODUCT_ID), },
+	{ USB_DEVICE(SONY_VENDOR_ID, RCS380P_PRODUCT_ID), },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, port100_table);
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
