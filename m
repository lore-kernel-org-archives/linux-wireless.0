Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14020 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbKZFA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 00:00:56 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 4/5] staging: wilc1000: remove unused files
Date: Thu, 26 Nov 2015 14:04:02 +0900
Message-ID: <1448514243-14181-4-git-send-email-glen.lee@atmel.com> (sfid-20151126_060102_046224_A2F391BD)
In-Reply-To: <1448514243-14181-1-git-send-email-glen.lee@atmel.com>
References: <1448514243-14181-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes linux_wlan_spi.[ch] which are not used anymore.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/Makefile         |  2 +-
 drivers/staging/wilc1000/linux_wlan_spi.c | 16 ----------------
 drivers/staging/wilc1000/linux_wlan_spi.h |  6 ------
 3 files changed, 1 insertion(+), 23 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_spi.c
 delete mode 100644 drivers/staging/wilc1000/linux_wlan_spi.h

diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 09f0ddb..20a5cb9 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -17,4 +17,4 @@ obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
 wilc1000-sdio-objs += wilc_sdio.o
 
 obj-$(CONFIG_WILC1000_SPI) += wilc1000-spi.o
-wilc1000-spi-objs += linux_wlan_spi.o wilc_spi.o
+wilc1000-spi-objs += wilc_spi.o
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
deleted file mode 100644
index c4315f5..0000000
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ /dev/null
@@ -1,16 +0,0 @@
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/fs.h>
-#include <linux/slab.h>
-#include <linux/types.h>
-#include <linux/cdev.h>
-#include <linux/uaccess.h>
-#include <linux/device.h>
-#include <linux/spi/spi.h>
-#include <linux/of_gpio.h>
-
-#include "linux_wlan_spi.h"
-#include "wilc_wfi_netdevice.h"
-#include "linux_wlan_common.h"
-#include "wilc_wlan_if.h"
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.h b/drivers/staging/wilc1000/linux_wlan_spi.h
deleted file mode 100644
index 32e3926..0000000
--- a/drivers/staging/wilc1000/linux_wlan_spi.h
+++ /dev/null
@@ -1,6 +0,0 @@
-#ifndef LINUX_WLAN_SPI_H
-#define LINUX_WLAN_SPI_H
-
-#include <linux/spi/spi.h>
-#include "wilc_wfi_netdevice.h"
-#endif
-- 
1.9.1

