Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34673 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbbHLRgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2015 13:36:21 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com, Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH] staging: wilc1000: Process WARN, INFO options of debug levels from user
Date: Wed, 12 Aug 2015 23:05:58 +0530
Message-Id: <1439400958-10454-1-git-send-email-csgorentla@gmail.com> (sfid-20150812_193644_399889_2F1A5FFF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables setting the module's debug options WARN and INFO in the
debugfs file 'wilc_debug_level'.  This enables the user to enable logging
of warning and other information.  Before this change writes to this debugfs
file sets only one option DGB.  This is additional to the default option
ERR.

As a side effect, this patch removes the 'sparse' warning -
'warning: incorrect type in argument 2 (different address spaces)'.

Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---
 drivers/staging/wilc1000/wilc_debugfs.c | 26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index be2e901..3934e8b 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -48,29 +48,26 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, si
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
-static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
+static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
+					size_t count, loff_t *ppos)
 {
-	char buffer[128] = {};
+	char buffer[2] = {};  /* One character for 'level' + one for null */
 	int flag = 0;
+	int ret;
 
 	if (count > sizeof(buffer))
 		return -EINVAL;
 
-	if (copy_from_user(buffer, buf, count)) {
+	ret = simple_write_to_buffer(buffer, sizeof(buffer), ppos, buf, count);
+	if (ret != count)
 		return -EFAULT;
-	}
-
-	flag = buffer[0] - '0';
 
-	if (flag > 0)
-		flag = DEBUG | ERR;
-	else if (flag < 0)
-		flag = 100;
+	ret = kstrtoint(buffer, 16, &flag);
+	if (ret)
+		return -EINVAL;
 
-	if (flag > DBG_LEVEL_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
-		return -EFAULT;
-	}
+	if (flag > DBG_LEVEL_ALL)
+		return -EINVAL;
 
 	atomic_set(&DEBUG_LEVEL, (int)flag);
 
@@ -78,6 +75,7 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t
 		printk("Debug-level disabled\n");
 	else
 		printk("Debug-level enabled\n");
+
 	return count;
 }
 
-- 
2.5.0

