Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:32860 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbbE1Ecs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 00:32:48 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Rachel Kim <rachel.kim@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] staging: wilc1000: Disable for S390
Date: Wed, 27 May 2015 21:32:43 -0700
Message-Id: <1432787563-25800-1-git-send-email-linux@roeck-us.net> (sfid-20150528_063311_198962_9B398678)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wilc1000 driver uses definitions such as DEBUG_LEVEL, DEBUG,
and PRINT_INFO. This causes compile errors on S390 which has similar
definitions in its core code. Disable the driver for S390 instead
of giving the non-standard messaging code credit by trying to fix it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/staging/wilc1000/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index 101f908bc9ed..0b349d3c1475 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -1,5 +1,6 @@
 config WILC1000
 	tristate "WILC1000 support (WiFi only)"
+	depends on !S390
 	---help---
 		This module only support IEEE 802.11n WiFi.
 
-- 
2.1.0

