Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:58997 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbcFWMg5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 08:36:57 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, julian.calaby@gmail.com,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v2 1/2] staging: wilc1000: fix error handling in wilc_debugfs_init()
Date: Thu, 23 Jun 2016 13:36:17 +0100
Message-Id: <1466685378-15597-1-git-send-email-luisbg@osg.samsung.com> (sfid-20160623_143810_697164_70468BBD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The common format to check if a function returned an error pointer is to
use PTR_ERR(). Instead of ERR_PTR() which is used to return said errors.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index fcbc95d..48797dc 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -107,7 +107,7 @@ static int __init wilc_debugfs_init(void)
 	struct wilc_debugfs_info_t *info;
 
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	if (wilc_dir ==  ERR_PTR(-ENODEV)) {
+	if (PTR_ERR(wilc_dir) == -ENODEV) {
 		/* it's not error. the debugfs is just not being enabled. */
 		printk("ERR, kernel has built without debugfs support\n");
 		return 0;
-- 
2.6.4

