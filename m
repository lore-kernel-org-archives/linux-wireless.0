Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D1BC43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF892214C5
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:26:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CF892214C5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbeIZQit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:38:49 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:39495 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726915AbeIZQis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:38:48 -0400
X-IronPort-AV: E=Sophos;i="5.54,306,1534834800"; 
   d="scan'208";a="21366829"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES128-SHA; 26 Sep 2018 03:26:32 -0700
Received: from ajaysk-VirtualBox.microchip.com (10.10.76.4) by
 CHN-SV-EXCH01.mchp-main.com (10.10.76.37) with Microsoft SMTP Server id
 14.3.352.0; Wed, 26 Sep 2018 03:26:31 -0700
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>
Subject: [PATCH 18/19] wilc: add Makefile and Kconfig files for  wilc compilation
Date:   Wed, 26 Sep 2018 15:55:24 +0530
Message-ID: <1537957525-11467-19-git-send-email-ajay.kathat@microchip.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Added the Makefile and Kconfig  for compiling the wilc module.
Renaming the module as 'wilc', so modified the Kconfig and Makefile
accordingly.
Modified wilc_sdio.c file to avoid the use of wilc1000 in macro name.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/net/wireless/microchip/Kconfig       | 14 ++++++++++
 drivers/net/wireless/microchip/Makefile      |  1 +
 drivers/net/wireless/microchip/wilc/Kconfig  | 42 ++++++++++++++++++++++++++++
 drivers/net/wireless/microchip/wilc/Makefile | 15 ++++++++++
 drivers/staging/wilc1000/wilc_sdio.c         |  4 +--
 5 files changed, 74 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/wireless/microchip/Kconfig
 create mode 100644 drivers/net/wireless/microchip/Makefile
 create mode 100644 drivers/net/wireless/microchip/wilc/Kconfig
 create mode 100644 drivers/net/wireless/microchip/wilc/Makefile

diff --git a/drivers/net/wireless/microchip/Kconfig b/drivers/net/wireless/microchip/Kconfig
new file mode 100644
index 0000000..4429b3d
--- /dev/null
+++ b/drivers/net/wireless/microchip/Kconfig
@@ -0,0 +1,14 @@
+config WLAN_VENDOR_MICROCHIP
+	bool "Microchip devices"
+	default y
+	---help---
+	  If you have a wireless card belonging to this class, say Y.
+
+	  Note that the answer to this question doesn't directly affect the
+	  kernel: saying N will just cause the configurator to skip all the
+	  questions about these cards. If you say Y, you will be asked for
+	  your specific card in the following questions.
+
+if WLAN_VENDOR_MICROCHIP
+source "drivers/net/wireless/microchip/wilc/Kconfig"
+endif # WLAN_VENDOR_MICROCHIP
diff --git a/drivers/net/wireless/microchip/Makefile b/drivers/net/wireless/microchip/Makefile
new file mode 100644
index 0000000..6c15d8f
--- /dev/null
+++ b/drivers/net/wireless/microchip/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_WILC)	+= wilc/
diff --git a/drivers/net/wireless/microchip/wilc/Kconfig b/drivers/net/wireless/microchip/wilc/Kconfig
new file mode 100644
index 0000000..5268165
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc/Kconfig
@@ -0,0 +1,42 @@
+config WILC
+	tristate
+	---help---
+	  This module only support IEEE 802.11n WiFi.
+
+config WILC_SDIO
+	tristate "Microchip WILC SDIO (WiFi only)"
+	depends on CFG80211 && INET && MMC
+	select WILC
+	---help---
+	  This module adds support for the SDIO interface of adapters using
+	  WILC chipset. The Microchip WILC SDIO is a full speed interface.
+	  It meets SDIO card specification version 2.0. The interface supports
+	  the 1-bit/4-bit SD transfer mode at the clock range of 0-50 MHz.
+	  The host can use this interface to read and write from any register
+	  within the chip as well as configure the WILC for data DMA.
+	  To use this interface, pin9 (SDIO_SPI_CFG) must be grounded. Select
+	  this if your platform is using the SDIO bus.
+
+config WILC_SPI
+	tristate "Microchip WILC SPI (WiFi only)"
+	depends on CFG80211 && INET && SPI
+	select WILC
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  WILC chipset. The Microchip WILC has a Serial Peripheral
+	  Interface (SPI) that operates as a SPI slave. This SPI interface can
+	  be used for control and for serial I/O of 802.11 data. The SPI is a
+	  full-duplex slave synchronous serial interface that is available
+	  immediately following reset when pin 9 (SDIO_SPI_CFG) is tied to
+	  VDDIO. Select this if your platform is using the SPI bus.
+
+config WILC_HW_OOB_INTR
+	bool "WILC out of band interrupt"
+	depends on WILC_SDIO
+	default n
+	---help---
+	  This option enables out-of-band interrupt support for the WILC
+	  chipset. This OOB interrupt is intended to provide a faster interrupt
+	  mechanism for SDIO host controllers that don't support SDIO interrupt.
+	  Select this option If the SDIO host controller in your platform
+	  doesn't support SDIO time devision interrupt.
diff --git a/drivers/net/wireless/microchip/wilc/Makefile b/drivers/net/wireless/microchip/wilc/Makefile
new file mode 100644
index 0000000..a98a4af
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc/Makefile
@@ -0,0 +1,15 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_WILC) += wilc.o
+
+ccflags-y += -DFIRMWARE_1002=\"atmel/wilc1002_firmware.bin\" \
+		-DFIRMWARE_1003=\"atmel/wilc1003_firmware.bin\"
+
+wilc-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
+			coreconfigurator.o host_interface.o \
+			wilc_wlan_cfg.o wilc_wlan.o
+
+obj-$(CONFIG_WILC_SDIO) += wilc-sdio.o
+wilc-sdio-objs += wilc_sdio.o
+
+obj-$(CONFIG_WILC_SPI) += wilc-spi.o
+wilc-spi-objs += wilc_spi.o
diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index b2080d8..4df1da1 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -9,7 +9,7 @@
 
 #include "wilc_wfi_netdevice.h"
 
-#define SDIO_MODALIAS "wilc1000_sdio"
+#define SDIO_MODALIAS "wilc_sdio"
 
 #define SDIO_VENDOR_ID_WILC 0x0296
 #define SDIO_DEVICE_ID_WILC 0x5347
@@ -110,7 +110,7 @@ static int linux_sdio_probe(struct sdio_func *func,
 	int ret;
 	struct gpio_desc *gpio = NULL;
 
-	if (IS_ENABLED(CONFIG_WILC1000_HW_OOB_INTR)) {
+	if (IS_ENABLED(CONFIG_WILC_HW_OOB_INTR)) {
 		gpio = gpiod_get(&func->dev, "irq", GPIOD_IN);
 		if (IS_ERR(gpio)) {
 			/* get the GPIO descriptor from hardcode GPIO number */
-- 
2.7.4

