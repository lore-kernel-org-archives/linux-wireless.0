Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:56003 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbbE0UCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 16:02:23 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Rachel Kim <rachel.kim@atmel.com>, Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH -next] staging: wilc1000: Include linux/gpio.h instead of asm/gpio.h
Date: Wed, 27 May 2015 13:02:16 -0700
Message-Id: <1432756936-6188-1-git-send-email-linux@roeck-us.net> (sfid-20150527_220227_541033_03B70A72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix:

drivers/staging/wilc1000/linux_wlan.c:18:22: fatal error:
	asm/gpio.h: No such file or directory

Not every architecture has asm/gpio.h. Include linux/gpio.h instead.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 49b238a05a88..18f1bd00201a 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -15,7 +15,7 @@
 #include <linux/workqueue.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 #include <linux/kthread.h>
 #include <linux/firmware.h>
-- 
2.1.0

