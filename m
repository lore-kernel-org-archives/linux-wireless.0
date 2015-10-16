Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:55480 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbbJPUpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 16:45:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: gregkh@linuxfoundation.org
Cc: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH] staging/wilc: fix Kconfig dependencies, second try
Date: Fri, 16 Oct 2015 22:45:39 +0200
Message-ID: <5446980.8Rmykv9Tt3@wuerfel> (sfid-20151016_224613_221991_3B5531AD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My first attempt to fix the Kconfig logic for wilc1000 was incomplete,
as it missed the case where SPI is built-in while SDIO is modular
and wilc1000 is configured as built-in in SPI mode (or vice versa),
which would still lead to a link failure.

This works around the problem by adding an intermediate Kconfig
symbol "WILC1000_DRIVER" that controls visibility of the SDIO and
SPI sub-drivers, so we can control the dependencies better.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 9535ebc5e9cc ("staging/wilc1000: fix Kconfig dependencies")

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index 59ccecc316df..ee51b4278088 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -1,14 +1,16 @@
-config WILC1000
-	tristate "WILC1000 support (WiFi only)"
-	depends on !S390
+config WILC1000_DRIVER
+	bool "WILC1000 support (WiFi only)"
 	depends on CFG80211 && WEXT_CORE && INET
-	depends on MMC || SPI
 	---help---
 	  This module only support IEEE 802.11n WiFi.
 
+if WILC1000_DRIVER
+
+config WILC1000
+	tristate
+
 choice
         prompt "Memory Allocation"
-        depends on WILC1000
         default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
 
 config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
@@ -29,12 +31,12 @@ endchoice
 
 choice
 	prompt "Bus Type"
-	depends on WILC1000
 	default WILC1000_SDIO
 
-	config WILC1000_SDIO
+config WILC1000_SDIO
 	bool "SDIO support"
 	depends on MMC
+	select WILC1000
 	---help---
 	  This module adds support for the SDIO interface of adapters using
 	  WILC1000 chipset. The Atmel WILC1000 SDIO is a full speed interface.
@@ -45,8 +47,9 @@ choice
 	  To use this interface, pin9 (SDIO_SPI_CFG) must be grounded. Select
 	  this if your platform is using the SDIO bus.
 
-	config WILC1000_SPI
+config WILC1000_SPI
 	depends on SPI
+	select WILC1000
 	bool "SPI support"
 	---help---
 	  This module adds support for the SPI interface of adapters using
@@ -60,7 +63,7 @@ endchoice
 
 config WILC1000_HW_OOB_INTR
 	bool "Use out of band interrupt"
-	depends on WILC1000 && WILC1000_SDIO
+	depends on WILC1000_SDIO
 	default n
 	---help---
 	  This option enables out-of-band interrupt support for the WILC1000
@@ -68,3 +71,5 @@ config WILC1000_HW_OOB_INTR
 	  mechanism for SDIO host controllers that don't support SDIO interrupt.
 	  Select this option If the SDIO host controller in your platform
 	  doesn't support SDIO time devision interrupt.
+
+endif

