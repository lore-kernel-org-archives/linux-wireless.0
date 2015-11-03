Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:58806 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbbKCOEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 09:04:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Vincent Cuissard <cuissard@marvell.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] NFC: nfcmrvl: fix SPI driver dependencies
Date: Tue, 03 Nov 2015 15:03:33 +0100
Message-ID: <243350307.K4hHIg3V2N@wuerfel> (sfid-20151103_150413_961346_2C8CD9BB)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The newly added nfcmrvl_spi driver uses the spi_nci
infrastructure, but does not have a Kconfig dependency on
that, so we can get a link-time error:

drivers/built-in.o: In function `nfcmrvl_spi_nci_send':
(.text+0x1428dc): undefined reference to `nci_spi_send'
drivers/built-in.o: In function `nfcmrvl_spi_probe':
(.text+0x142a24): undefined reference to `nci_spi_allocate_spi'
drivers/built-in.o: In function `nfcmrvl_spi_int_irq_thread_fn':
(.text+0x142abc): undefined reference to `nci_spi_read'

This clarifies the dependency.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
---
Found on ARM randconfig builds on yesterday's linux-next

diff --git a/drivers/nfc/nfcmrvl/Kconfig b/drivers/nfc/nfcmrvl/Kconfig
index 444ca94697d9..670af76922e0 100644
--- a/drivers/nfc/nfcmrvl/Kconfig
+++ b/drivers/nfc/nfcmrvl/Kconfig
@@ -44,7 +44,7 @@ config NFC_MRVL_I2C
 
 config NFC_MRVL_SPI
 	tristate "Marvell NFC-over-SPI driver"
-	depends on NFC_MRVL && SPI
+	depends on NFC_MRVL && NFC_NCI_SPI
 	help
 	  Marvell NFC-over-SPI driver.
 

