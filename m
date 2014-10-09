Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:64759 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaJIQl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 12:41:28 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Guenter Roeck <linux@roeck-us.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] bcma: Add dependency on OF_ADDRESS
Date: Thu,  9 Oct 2014 09:41:17 -0700
Message-Id: <1412872877-1771-1-git-send-email-linux@roeck-us.net> (sfid-20141009_184152_649326_432D9219)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 2101e533f41a ("bcma: register bcma as device tree driver")
introduces a hard dependency on OF_ADDRESS into the bcma driver.
OF_ADDRESS is specifically disabled for the sparc architecture.
This results in the following error when building sparc64:allmodconfig.

drivers/bcma/main.c: In function 'bcma_of_find_child_device':
drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'

Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 0ee48be..ca4b420 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -1,6 +1,6 @@
 config BCMA_POSSIBLE
 	bool
-	depends on HAS_IOMEM && HAS_DMA
+	depends on HAS_IOMEM && HAS_DMA && OF_ADDRESS
 	default y
 
 menu "Broadcom specific AMBA"
-- 
1.9.1

