Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59003 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037AbcFWMhA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2016 08:37:00 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, julian.calaby@gmail.com,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v2 2/2] staging: wilc1000: fix error values in wilc_debugfs_init()
Date: Thu, 23 Jun 2016 13:36:18 +0100
Message-Id: <1466685378-15597-2-git-send-email-luisbg@osg.samsung.com> (sfid-20160623_143759_393921_9D9F822C)
In-Reply-To: <1466685378-15597-1-git-send-email-luisbg@osg.samsung.com>
References: <1466685378-15597-1-git-send-email-luisbg@osg.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there was an error, returning -EINVAL is more appropriate than -1.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 48797dc..6252931 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -115,7 +115,7 @@ static int __init wilc_debugfs_init(void)
 
 	if (!wilc_dir) {
 		printk("ERR, debugfs create dir\n");
-		return -1;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
@@ -129,7 +129,7 @@ static int __init wilc_debugfs_init(void)
 		if (!debugfs_files) {
 			printk("ERR fail to create the debugfs file, %s\n", info->name);
 			debugfs_remove_recursive(wilc_dir);
-			return -1;
+			return -EINVAL;
 		}
 	}
 	return 0;
-- 
2.6.4

