Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34732 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbFSAGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 20:06:37 -0400
Received: by pdbki1 with SMTP id ki1so77193807pdb.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jun 2015 17:06:36 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH] staging: wilc1000: fix checkpatch warning
Date: Fri, 19 Jun 2015 09:06:28 +0900
Message-Id: <1434672388-4074-1-git-send-email-chaehyun.lim@gmail.com> (sfid-20150619_020640_431486_3E52C53F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix warning founded by checkpatch.pl.
WARNING: __func__ should be used instead of gcc specific __FUNCTION__

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/linux_wlan.c        |  2 +-
 drivers/staging/wilc1000/linux_wlan_common.h | 16 ++++++++--------
 drivers/staging/wilc1000/wilc_platform.h     |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 8ecbb2d..fb875c2 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -2425,7 +2425,7 @@ int mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
 				snprintf(buff, size, "rssi %d", rssi);
 
 				if (copy_to_user(wrq->u.data.pointer, buff, size)) {
-					PRINT_ER("%s: failed to copy data to user buffer\n", __FUNCTION__);
+					PRINT_ER("%s: failed to copy data to user buffer\n", __func__);
 					s32Error = -EFAULT;
 					goto done;
 				}
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index 830d96a..2476bfd 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -54,7 +54,7 @@ extern atomic_t DEBUG_LEVEL;
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & DEBUG) &&		\
 		   ((atomic_read(&REGION)) & (region))) {		\
-			printk("DBG [%s: %d]", __FUNCTION__, __LINE__);	\
+			printk("DBG [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
@@ -63,7 +63,7 @@ extern atomic_t DEBUG_LEVEL;
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & INFO) &&		\
 		   ((atomic_read(&REGION)) & (region))) {		\
-			printk("INFO [%s]", __FUNCTION__);		\
+			printk("INFO [%s]", __func__);			\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
@@ -72,7 +72,7 @@ extern atomic_t DEBUG_LEVEL;
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & WRN) &&		\
 		   ((atomic_read(&REGION)) & (region))) {		\
-			printk("WRN [%s: %d]", __FUNCTION__, __LINE__);	\
+			printk("WRN [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
@@ -80,7 +80,7 @@ extern atomic_t DEBUG_LEVEL;
 #define PRINT_ER(...)							\
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & ERR)) {		\
-			printk("ERR [%s: %d]", __FUNCTION__, __LINE__);	\
+			printk("ERR [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
@@ -96,7 +96,7 @@ extern atomic_t DEBUG_LEVEL;
 #define PRINT_D(region, ...)						\
 	do {								\
 		if (DEBUG == 1 && ((REGION)&(region))) {		\
-			printk("DBG [%s: %d]", __FUNCTION__, __LINE__); \
+			printk("DBG [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
@@ -104,7 +104,7 @@ extern atomic_t DEBUG_LEVEL;
 #define PRINT_INFO(region, ...)						\
 	do {								\
 		if (INFO == 1 && ((REGION)&(region))) {			\
-			printk("INFO [%s]", __FUNCTION__);		\
+			printk("INFO [%s]", __func__);			\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
@@ -112,14 +112,14 @@ extern atomic_t DEBUG_LEVEL;
 #define PRINT_WRN(region, ...)						\
 	do {								\
 		if (WRN == 1 && ((REGION)&(region))) {			\
-			printk("WRN [%s: %d]", __FUNCTION__, __LINE__); \
+			printk("WRN [%s: %d]", __func__, __LINE__);	\
 			printk(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
 #define PRINT_ER(...)							\
 	do {								\
-		printk("ERR [%s: %d]", __FUNCTION__, __LINE__);		\
+		printk("ERR [%s: %d]", __func__, __LINE__);		\
 		printk(__VA_ARGS__);					\
 	} while (0)
 #endif
diff --git a/drivers/staging/wilc1000/wilc_platform.h b/drivers/staging/wilc1000/wilc_platform.h
index 7ddea83..d03532c 100644
--- a/drivers/staging/wilc1000/wilc_platform.h
+++ b/drivers/staging/wilc1000/wilc_platform.h
@@ -47,6 +47,6 @@ typedef time_t WILC_Time;
 
 /* Generic printf function */
 #define __WILC_FILE__		__FILE__
-#define __WILC_FUNCTION__	__FUNCTION__
+#define __WILC_FUNCTION__	__func__
 #define __WILC_LINE__		__LINE__
 #endif
-- 
1.9.1

