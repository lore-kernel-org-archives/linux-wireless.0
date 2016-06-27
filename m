Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:37647 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcF0NA6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 09:00:58 -0400
From: Luis de Bethencourt <luisbg@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: [PATCH v3] staging: wilc1000: fix error handling in wilc_debugfs_init()
Date: Mon, 27 Jun 2016 14:00:20 +0100
Message-Id: <1467032420-19995-1-git-send-email-luisbg@osg.samsung.com> (sfid-20160627_150118_581322_294CFE16)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can just ignore the return value from debugfs_create_dir() and
debugfs_create_file(). The second one already interanlly checks the dentry
created by the first before creating the file.

debugfs was written so it would be easy to use, no need for error checking.

Signed-off-by: Luis de Bethencourt <luisbg@osg.samsung.com>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index fcbc95d..b052628 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -102,35 +102,16 @@ static struct wilc_debugfs_info_t debugfs_info[] = {
 static int __init wilc_debugfs_init(void)
 {
 	int i;
-
-	struct dentry *debugfs_files;
 	struct wilc_debugfs_info_t *info;
 
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
-	if (wilc_dir ==  ERR_PTR(-ENODEV)) {
-		/* it's not error. the debugfs is just not being enabled. */
-		printk("ERR, kernel has built without debugfs support\n");
-		return 0;
-	}
-
-	if (!wilc_dir) {
-		printk("ERR, debugfs create dir\n");
-		return -1;
-	}
-
 	for (i = 0; i < ARRAY_SIZE(debugfs_info); i++) {
 		info = &debugfs_info[i];
-		debugfs_files = debugfs_create_file(info->name,
-						    info->perm,
-						    wilc_dir,
-						    &info->data,
-						    &info->fops);
-
-		if (!debugfs_files) {
-			printk("ERR fail to create the debugfs file, %s\n", info->name);
-			debugfs_remove_recursive(wilc_dir);
-			return -1;
-		}
+		debugfs_create_file(info->name,
+				    info->perm,
+				    wilc_dir,
+				    &info->data,
+				    &info->fops);
 	}
 	return 0;
 }
-- 
2.6.4

