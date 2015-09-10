Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27096 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbbIJJ02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 05:26:28 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 1/5] staging: wilc1000: remove STATIC_MACADDRESS
Date: Thu, 10 Sep 2015 18:26:26 +0900
Message-ID: <1441877190-4546-1-git-send-email-tony.cho@atmel.com> (sfid-20150910_112632_106558_2E956364)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes unused definition, STATIC_MACADDRESS from the
linux_wlan.c file.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 77 -----------------------------------
 1 file changed, 77 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 335335a..df5ee26 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -37,13 +37,6 @@
 #include "linux_wlan_spi.h"
 #endif
 
-#ifdef STATIC_MACADDRESS /* brandy_0724 [[ */
-#include <linux/vmalloc.h>
-#include <linux/fs.h>
-struct task_struct *wilc_mac_thread;
-unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xb2};
-#endif /* brandy_0724 ]] */
-
 #if defined(CUSTOMER_PLATFORM)
 /*
  TODO : Write power control functions as customer platform.
@@ -862,19 +855,15 @@ static int linux_wlan_init_test_config(struct net_device *dev, linux_wlan_t *p_n
 {
 
 	unsigned char c_val[64];
-	#ifndef STATIC_MACADDRESS
 	unsigned char mac_add[] = {0x00, 0x80, 0xC2, 0x5E, 0xa2, 0xff};
-	#endif
 
 	/*BugID_5077*/
 	struct WILC_WFI_priv *priv;
 	tstrWILC_WFIDrv *pstrWFIDrv;
 
 	PRINT_D(TX_DBG, "Start configuring Firmware\n");
-	#ifndef STATIC_MACADDRESS
 	get_random_bytes(&mac_add[5], 1);
 	get_random_bytes(&mac_add[4], 1);
-	#endif
 	priv = wiphy_priv(dev->ieee80211_ptr->wiphy);
 	pstrWFIDrv = (tstrWILC_WFIDrv *)priv->hWILCWFIDrv;
 	PRINT_D(INIT_DBG, "Host = %p\n", pstrWFIDrv);
@@ -1415,66 +1404,6 @@ static void wlan_deinitialize_threads(linux_wlan_t *nic)
 	#endif
 }
 
-#ifdef STATIC_MACADDRESS
-const char *path_string[] = {
-	"/etc/wlan",
-	"/data/wlan",
-};
-
-static int linux_wlan_read_mac_addr(void *vp)
-{
-	int ret = 0;
-	struct file *fp = (struct file *)-ENOENT;
-	mm_segment_t old_fs;
-	loff_t pos = 0;
-	int index;
-	int array_size = ARRAY_SIZE(path_string);
-
-	/* change to KERNEL_DS address limit */
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
-	for (index = 0; index < array_size; index++) {
-		fp = filp_open(path_string[index], O_WRONLY, 0640);
-		if (!fp) {
-			ret = -1;
-			goto exit;
-		}
-
-		/*No such file or directory */
-		if (IS_ERR(fp) || !fp->f_op) {
-			get_random_bytes(&mac_add[3], 3);
-			/* open file to write */
-			fp = filp_open(path_string[index], O_WRONLY | O_CREAT, 0640);
-
-			if (!fp || IS_ERR(fp)) {
-				ret = -1;
-				continue;
-			} else {
-				/* write buf to file */
-				fp->f_op->write(fp, mac_add, 6, &pos);
-				break;
-			}
-		} else {
-			/* read file to buf */
-			fp->f_op->read(fp, mac_add, 6, &pos);
-			break;
-		}
-	}
-
-	if (index == array_size)
-		PRINT_ER("random MAC\n");
-
-exit:
-	if (fp && !IS_ERR(fp))
-		filp_close(fp, NULL);
-
-	set_fs(old_fs);
-
-	return ret;
-}
-#endif
-
 #ifdef COMPLEMENT_BOOT
 
 extern volatile int probe;
@@ -1581,12 +1510,6 @@ int wilc1000_wlan_init(struct net_device *dev, perInterface_wlan_t *p_nic)
 
 		wlan_init_locks(g_linux_wlan);
 
-#ifdef STATIC_MACADDRESS
-		wilc_mac_thread = kthread_run(linux_wlan_read_mac_addr, NULL, "wilc_mac_thread");
-		if (wilc_mac_thread < 0)
-			PRINT_ER("couldn't create Mac addr thread\n");
-#endif
-
 		linux_to_wlan(&nwi, g_linux_wlan);
 
 		ret = wilc_wlan_init(&nwi, &nwo);
-- 
1.9.1

