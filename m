Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37395 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbcE0RvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 13:51:13 -0400
From: Lidza Louina <lidza.louina@oracle.com>
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org
Cc: Lidza Louina <lidza.louina@oracle.com>
Subject: [PATCH] staging/wilc1000: fixes kzalloc call
Date: Fri, 27 May 2016 13:51:17 -0400
Message-Id: <1464371477-16965-1-git-send-email-lidza.louina@oracle.com> (sfid-20160527_195116_649870_B90B38AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl pointer was initialized as a pointer to a struct wilc and
assigned to a piece of memory the size of the pointer. It should be the
size of struct wilc.

Signed-off-by: Lidza Louina <lidza.louina@oracle.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 4f93c11..d1853f6 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1260,7 +1260,7 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	sema_init(&close_exit_sync, 0);
 
-	wl = kzalloc(sizeof(*wl), GFP_KERNEL);
+	wl = kzalloc(sizeof(struct wilc), GFP_KERNEL);
 	if (!wl)
 		return -ENOMEM;
 
-- 
1.9.1

