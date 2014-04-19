Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33394 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbaDSKwv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 06:52:51 -0400
Date: Sat, 19 Apr 2014 12:52:47 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH] NFC: nfcmrvl: Auto-select core module
Message-ID: <20140419125247.40671230@endymion.delvare> (sfid-20140419_125259_528847_B7D95C39)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I understand it, the core nfcmrvl module is useless without the
USB access module. So hide NFC_MRVL and select it automatically if
NFC_MRVL_USB is selected.

This avoids presenting NFC_MRVL when NFC_MRVL_USB can't be selected.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/nfc/nfcmrvl/Kconfig |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- linux-3.15-rc1.orig/drivers/nfc/nfcmrvl/Kconfig	2014-03-31 05:40:15.000000000 +0200
+++ linux-3.15-rc1/drivers/nfc/nfcmrvl/Kconfig	2014-04-18 21:10:14.493649773 +0200
@@ -1,18 +1,15 @@
 config NFC_MRVL
-	tristate "Marvell NFC driver support"
-	depends on NFC_NCI
+	tristate
 	help
 	  The core driver to support Marvell NFC devices.
 
 	  This driver is required if you want to support
 	  Marvell NFC device 8897.
 
-	  Say Y here to compile Marvell NFC driver into the kernel or
-	  say M to compile it as module.
-
 config NFC_MRVL_USB
-	tristate "Marvell NFC-over-USB driver"
-	depends on NFC_MRVL && USB
+	tristate  "Marvell Avastar 88W8897 device support (USB)"
+	depends on NFC_NCI && USB
+	select NFC_MRVL
 	help
 	  Marvell NFC-over-USB driver.
 


-- 
Jean Delvare
SUSE L3 Support
