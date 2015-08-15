Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34151 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbbHOGxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2015 02:53:54 -0400
From: Chandra S Gorentla <csgorentla@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com, Chandra S Gorentla <csgorentla@gmail.com>
Subject: [PATCH v3] staging: wilc1000: Process WARN, INFO options of debug levels from user
Date: Sat, 15 Aug 2015 12:23:31 +0530
Message-Id: <1439621611-31599-1-git-send-email-csgorentla@gmail.com> (sfid-20150815_085358_904273_6FF8652E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables setting the module's debug options WARN and INFO in the
debugfs file 'wilc_debug_level'.  This functionality allows the user to
enable logging of warnings and other information.  Before this change,
writes to this debugfs file set only one option - DEBUG.  Another option
that is enabled by default is ERR.

As a side effect, this patch removes the 'sparse' warning -
'warning: incorrect type in argument 2 (different address spaces)'.


Signed-off-by: Chandra S Gorentla <csgorentla@gmail.com>
---

Changes in v3: Added back a printk that was removed from v1

Changes in v2: Replaced copy_from_user and kstrtoint (added in v1) with
               kstrtouint_from_user

 drivers/staging/wilc1000/wilc_debugfs.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index be2e901..ae11186 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -48,28 +48,19 @@ static ssize_t wilc_debug_level_read(struct file *file, char __user *userbuf, si
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
 
-static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t count, loff_t *ppos)
+static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
+					size_t count, loff_t *ppos)
 {
-	char buffer[128] = {};
 	int flag = 0;
+	int ret;
 
-	if (count > sizeof(buffer))
-		return -EINVAL;
-
-	if (copy_from_user(buffer, buf, count)) {
-		return -EFAULT;
-	}
-
-	flag = buffer[0] - '0';
-
-	if (flag > 0)
-		flag = DEBUG | ERR;
-	else if (flag < 0)
-		flag = 100;
+	ret = kstrtouint_from_user(buf, count, 16, &flag);
+	if (ret)
+		return ret;
 
 	if (flag > DBG_LEVEL_ALL) {
 		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
-		return -EFAULT;
+		return -EINVAL;
 	}
 
 	atomic_set(&DEBUG_LEVEL, (int)flag);
@@ -78,6 +69,7 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char *buf, size_t
 		printk("Debug-level disabled\n");
 	else
 		printk("Debug-level enabled\n");
+
 	return count;
 }
 
-- 
2.5.0

