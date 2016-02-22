Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:29951 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbcBVESS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Feb 2016 23:18:18 -0500
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>,
	Chris Park <chris.park@atmel.com>
Subject: [PATCH V3 21/24] staging: wilc1000: removes unused region feature
Date: Mon, 22 Feb 2016 13:12:06 +0900
Message-ID: <1456114329-7036-22-git-send-email-leo.kim@atmel.com> (sfid-20160222_051820_661609_C617DD96)
In-Reply-To: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
References: <1456114329-7036-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chris Park <chris.park@atmel.com>

This patch removes unused region feature on debug message.
Also, removes the functions of related in this feature.

Signed-off-by: Chris Park <chris.park@atmel.com>
Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_common.h | 17 ++---------
 drivers/staging/wilc1000/wilc_debugfs.c      | 42 ----------------------------
 2 files changed, 3 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index e408631..57d3901 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -1,15 +1,7 @@
 #ifndef LINUX_WLAN_COMMON_H
 #define LINUX_WLAN_COMMON_H
 
-enum debug_region {
-	Init_debug = 0,
-	COMP = 0xFFFFFFFF,
-};
-
-#define INIT_DBG                (1 << Init_debug)
-
 #if defined(WILC_DEBUGFS)
-extern atomic_t WILC_REGION;
 extern atomic_t WILC_DEBUG_LEVEL;
 
 #define DEBUG           BIT(0)
@@ -19,8 +11,7 @@ extern atomic_t WILC_DEBUG_LEVEL;
 
 #define PRINT_D(region, ...)						\
 	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & DEBUG) &&	\
-		   ((atomic_read(&WILC_REGION)) & (region))) {	\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & DEBUG)) {	\
 			printk("DBG [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -28,8 +19,7 @@ extern atomic_t WILC_DEBUG_LEVEL;
 
 #define PRINT_INFO(region, ...)						\
 	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & INFO) &&	\
-		   ((atomic_read(&WILC_REGION)) & (region))) {	\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & INFO)) {	\
 			printk("INFO [%s]", __func__);			\
 			printk(__VA_ARGS__);				\
 		}							\
@@ -37,8 +27,7 @@ extern atomic_t WILC_DEBUG_LEVEL;
 
 #define PRINT_WRN(region, ...)						\
 	do {								\
-		if ((atomic_read(&WILC_DEBUG_LEVEL) & WRN) &&	\
-		   ((atomic_read(&WILC_REGION)) & (region))) {	\
+		if ((atomic_read(&WILC_DEBUG_LEVEL) & WRN)) {	\
 			printk("WRN [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index 266d96b..215e2f0 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -24,10 +24,7 @@ static struct dentry *wilc_dir;
  * --------------------------------------------------------------------------------
  */
 
-#define DBG_REGION_ALL	(INIT_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
-atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG);
-EXPORT_SYMBOL_GPL(WILC_REGION);
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
 EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
 
@@ -75,44 +72,6 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 	return count;
 }
 
-static ssize_t wilc_debug_region_read(struct file *file, char __user *userbuf, size_t count, loff_t *ppos)
-{
-	char buf[128];
-	int res = 0;
-
-	/* only allow read from start */
-	if (*ppos > 0)
-		return 0;
-
-	res = scnprintf(buf, sizeof(buf), "Debug region: %x\n", atomic_read(&WILC_REGION));
-
-	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
-}
-
-static ssize_t wilc_debug_region_write(struct file *filp, const char __user *buf, size_t count, loff_t *ppos)
-{
-	char buffer[128] = {};
-	int flag;
-
-	if (count > sizeof(buffer))
-		return -EINVAL;
-
-	if (copy_from_user(buffer, buf, count))
-		return -EFAULT;
-
-	flag = buffer[0] - '0';
-
-	if (flag > DBG_REGION_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&WILC_REGION));
-		return -EFAULT;
-	}
-
-	atomic_set(&WILC_REGION, (int)flag);
-	printk("new debug-region is %x\n", atomic_read(&WILC_REGION));
-
-	return count;
-}
-
 /*
  * --------------------------------------------------------------------------------
  */
@@ -134,7 +93,6 @@ struct wilc_debugfs_info_t {
 
 static struct wilc_debugfs_info_t debugfs_info[] = {
 	{ "wilc_debug_level",	0666,	(DEBUG | ERR), FOPS(NULL, wilc_debug_level_read, wilc_debug_level_write, NULL), },
-	{ "wilc_debug_region",	0666,	(INIT_DBG), FOPS(NULL, wilc_debug_region_read, wilc_debug_region_write, NULL), },
 };
 
 static int __init wilc_debugfs_init(void)
-- 
1.9.1

