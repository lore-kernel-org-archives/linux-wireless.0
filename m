Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391AbbIYI7H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 04:59:07 -0400
Date: Fri, 25 Sep 2015 10:59:04 +0200
From: Jean Delvare <jdelvare@suse.de>
To: linux-wireless@vger.kernel.org
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 3/3] NFC: nfcmrvl: Auto-select core module
Message-ID: <20150925105904.6633628d@endymion.delvare> (sfid-20150925_105913_897814_83E28505)
In-Reply-To: <20150925104936.3b526b68@endymion.delvare>
References: <20150925104936.3b526b68@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As I understand it, the core nfcmrvl module is useless without
either the USB or the UART access module. So hide NFC_MRVL and select
it automatically if either NFC_MRVL_USB or NFC_MRVL_UART is selected.

This avoids presenting NFC_MRVL when neither NFC_MRVL_USB nor
NFC_MRVL_UART can be selected.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
Already sent on 2014-04-19. Changes since v1: rebased to handle
NFC_MRVL_UART.

Note that the s3fwrn5 NFC driver is already implemented the same way.

 drivers/nfc/nfcmrvl/Kconfig |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- linux-4.3-rc2.orig/drivers/nfc/nfcmrvl/Kconfig	2015-09-24 11:44:28.103745867 +0200
+++ linux-4.3-rc2/drivers/nfc/nfcmrvl/Kconfig	2015-09-25 10:39:53.972729905 +0200
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
 	tristate "Marvell NFC-over-USB driver"
-	depends on NFC_MRVL && USB
+	depends on NFC_NCI && USB
+	select NFC_MRVL
 	help
 	  Marvell NFC-over-USB driver.
 
@@ -24,7 +21,8 @@ config NFC_MRVL_USB
 
 config NFC_MRVL_UART
 	tristate "Marvell NFC-over-UART driver"
-	depends on NFC_MRVL && NFC_NCI_UART
+	depends on NFC_NCI && NFC_NCI_UART
+	select NFC_MRVL
 	help
 	  Marvell NFC-over-UART driver.
 

-- 
Jean Delvare
SUSE L3 Support
