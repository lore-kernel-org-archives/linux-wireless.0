Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f196.google.com ([209.85.217.196]:35319 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbJHSXg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 14:23:36 -0400
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
To: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Subject: [PATCH 2/2] staging: wilc1000: linux_wlan_spi: include header
Date: Thu,  8 Oct 2015 21:23:14 +0300
Message-Id: <1444328594-10656-2-git-send-email-kholmanskikh.s.s@gmail.com> (sfid-20151008_202354_451492_8B0C4108)
In-Reply-To: <1444328594-10656-1-git-send-email-kholmanskikh.s.s@gmail.com>
References: <1444328594-10656-1-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A check using 'sparse' shows warnings in linux_wlan_spi.c:

drivers/staging/wilc1000/linux_wlan_spi.c:43:19: warning: symbol 'wilc_spi_dev' was not declared. Should it be static?
drivers/staging/wilc1000/linux_wlan_spi.c:71:19: warning: symbol 'wilc_bus' was not declared. Should it be static?
drivers/staging/wilc1000/linux_wlan_spi.c:95:5: warning: symbol 'linux_spi_init' was not declared. Should it be static?
drivers/staging/wilc1000/linux_wlan_spi.c:195:5: warning: symbol 'linux_spi_write' was not declared. Should it be static?
drivers/staging/wilc1000/linux_wlan_spi.c:320:5: warning: symbol 'linux_spi_read' was not declared. Should it be static?
drivers/staging/wilc1000/linux_wlan_spi.c:365:5: warning: symbol 'linux_spi_write_read' was not declared. Should it be static?
drivers/staging/wilc1000/linux_wlan_spi.c:402:5: warning: symbol 'linux_spi_set_max_speed' was not declared. Should it be static?

Let's avoid it by including "linux_wlan_spi.h" header.

Signed-off-by: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index c6c1f6e..760b72a 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -10,6 +10,7 @@
 #include <linux/spi/spi.h>
 
 #include "linux_wlan_common.h"
+#include "linux_wlan_spi.h"
 
 #define USE_SPI_DMA     0       /* johnny add */
 
@@ -40,7 +41,6 @@
 
 static u32 SPEED = MIN_SPEED;
 
-struct spi_device *wilc_spi_dev;
 void linux_spi_deinit(void *vp);
 
 static int __init wilc_bus_probe(struct spi_device *spi)
-- 
1.9.1

