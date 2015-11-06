Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36576 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030287AbbKFV7e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 16:59:34 -0500
From: Punit Vara <punitvara@gmail.com>
To: gregkh@linuxfoundation.org
Cc: glen.lee@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Punit Vara <punitvara@gmail.com>
Subject: [PATCH] Staging: wilc1000: Declare *wilc in init_wilc_driver to fix build error
Date: Sat,  7 Nov 2015 03:29:23 +0530
Message-Id: <1446847163-9643-1-git-send-email-punitvara@gmail.com> (sfid-20151106_225951_258241_FAB6486F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is to the linux_wlan.c file that fixes declaration of *wilc
to remove following error while building it.

make drivers/staging/wilc1000/linux_wlan.o
drivers/staging/wilc1000/linux_wlan.c:1824:24: error: ‘wilc’ undeclared

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 2a5b36f..0805050 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1780,6 +1780,7 @@ int wilc_netdev_init(struct wilc **wilc)
 /*The 1st function called after module inserted*/
 static int __init init_wilc_driver(void)
 {
+	struct wilc *wilc;
 #ifdef WILC_SPI
 	struct wilc *wilc;
 #endif
-- 
2.6.2

