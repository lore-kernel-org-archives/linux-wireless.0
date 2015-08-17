Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:35618 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbbHQXGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 19:06:49 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv3] staging: wilc1000: use netdev_* instead of printk
Date: Mon, 17 Aug 2015 19:06:40 -0400
Message-Id: <b5c4c3dd4babd0cd4daef51626816e95c6d8ee9d.1439852779.git.raphael.beamonte@gmail.com> (sfid-20150818_010710_031619_9843473A)
In-Reply-To: <20150817195542.GB6591@kroah.com>
References: <20150817195542.GB6591@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
---
 drivers/staging/wilc1000/coreconfigurator.c  |  4 ++--
 drivers/staging/wilc1000/linux_wlan.c        |  8 ++++----
 drivers/staging/wilc1000/linux_wlan_common.h | 28 ++++++++++++++--------------
 drivers/staging/wilc1000/linux_wlan_sdio.c   |  2 +-
 drivers/staging/wilc1000/linux_wlan_spi.c    |  2 +-
 drivers/staging/wilc1000/wilc_debugfs.c      | 16 ++++++++--------
 drivers/staging/wilc1000/wilc_exported_buf.c |  2 --
 7 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/wilc1000/coreconfigurator.c b/drivers/staging/wilc1000/coreconfigurator.c
index 16a0abc..9a36b78 100644
--- a/drivers/staging/wilc1000/coreconfigurator.c
+++ b/drivers/staging/wilc1000/coreconfigurator.c
@@ -2001,7 +2001,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 							pstrWIDs[counter].u16WIDid,
 							(counter == u32WIDsCount - 1), drvHandler)) {
 				ret = -1;
-				printk("[Sendconfigpkt]Get Timed out\n");
+				netdev_err("[Sendconfigpkt]Get Timed out\n");
 				break;
 			}
 		}
@@ -2023,7 +2023,7 @@ s32 SendConfigPkt(u8 u8Mode, tstrWID *pstrWIDs,
 							pstrWIDs[counter].s32ValueSize,
 							(counter == u32WIDsCount - 1), drvHandler)) {
 				ret = -1;
-				printk("[Sendconfigpkt]Set Timed out\n");
+				netdev_err("[Sendconfigpkt]Set Timed out\n");
 				break;
 			}
 		}
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index b3cc9f5..7903572 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -1306,7 +1306,7 @@ void wilc1000_wlan_deinit(linux_wlan_t *nic)
 
 	if (g_linux_wlan->wilc1000_initialized)	{
 
-		printk("Deinitializing wilc1000  ...\n");
+		netdev_debug("Deinitializing wilc1000  ...\n");
 
 		if (nic == NULL) {
 			PRINT_ER("nic is NULL\n");
@@ -2565,8 +2565,8 @@ static int __init init_wilc_driver(void)
 	}
 #endif
 
-	printk("IN INIT FUNCTION\n");
-	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
+	netdev_debug("IN INIT FUNCTION\n");
+	netdev_info("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
 
 	linux_wlan_device_power(1);
 	msleep(100);
@@ -2662,7 +2662,7 @@ static void __exit exit_wilc_driver(void)
 			kfree(g_linux_wlan);
 			g_linux_wlan = NULL;
 		}
-		printk("Module_exit Done.\n");
+		netdev_debug("Module_exit Done.\n");
 
 #if defined(WILC_DEBUGFS)
 		wilc_debugfs_remove();
diff --git a/drivers/staging/wilc1000/linux_wlan_common.h b/drivers/staging/wilc1000/linux_wlan_common.h
index e6ebf3e..7f53d8c 100644
--- a/drivers/staging/wilc1000/linux_wlan_common.h
+++ b/drivers/staging/wilc1000/linux_wlan_common.h
@@ -63,8 +63,8 @@ extern atomic_t DEBUG_LEVEL;
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & INFO) &&		\
 		   ((atomic_read(&REGION)) & (region))) {		\
-			printk("INFO [%s]", __func__);			\
-			printk(__VA_ARGS__);				\
+			netdev_info("INFO [%s]", __func__);			\
+			netdev_info(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
@@ -72,16 +72,16 @@ extern atomic_t DEBUG_LEVEL;
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & WRN) &&		\
 		   ((atomic_read(&REGION)) & (region))) {		\
-			printk("WRN [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
+			netdev_warning("WRN [%s: %d]", __func__, __LINE__);	\
+			netdev_warning(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
 #define PRINT_ER(...)							\
 	do {								\
 		if ((atomic_read(&DEBUG_LEVEL) & ERR)) {		\
-			printk("ERR [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
+			netdev_err("ERR [%s: %d]", __func__, __LINE__);	\
+			netdev_err(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
@@ -96,31 +96,31 @@ extern atomic_t DEBUG_LEVEL;
 #define PRINT_D(region, ...)						\
 	do {								\
 		if (DEBUG == 1 && ((REGION)&(region))) {		\
-			printk("DBG [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
+			netdev_debug("DBG [%s: %d]", __func__, __LINE__);	\
+			netdev_debug(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
 #define PRINT_INFO(region, ...)						\
 	do {								\
 		if (INFO == 1 && ((REGION)&(region))) {			\
-			printk("INFO [%s]", __func__);			\
-			printk(__VA_ARGS__);				\
+			netdev_info("INFO [%s]", __func__);			\
+			netdev_info(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
 #define PRINT_WRN(region, ...)						\
 	do {								\
 		if (WRN == 1 && ((REGION)&(region))) {			\
-			printk("WRN [%s: %d]", __func__, __LINE__);	\
-			printk(__VA_ARGS__);				\
+			netdev_warning("WRN [%s: %d]", __func__, __LINE__);	\
+			netdev_warning(__VA_ARGS__);				\
 		}							\
 	} while (0)
 
 #define PRINT_ER(...)							\
 	do {								\
-		printk("ERR [%s: %d]", __func__, __LINE__);		\
-		printk(__VA_ARGS__);					\
+		netdev_err("ERR [%s: %d]", __func__, __LINE__);		\
+		netdev_err(__VA_ARGS__);					\
 	} while (0)
 #endif
 
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 37f31f4..ef2cfa9 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -136,7 +136,7 @@ static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id
 		return -1;
 	}
 
-	printk("Driver Initializing success\n");
+	netdev_info("Driver Initializing success\n");
 	return 0;
 }
 
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 236669c..675db07 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -50,7 +50,7 @@ static int __init wilc_bus_probe(struct spi_device *spi)
 	PRINT_D(BUS_DBG, "spiMax-Speed: %d\n", spi->max_speed_hz);
 	wilc_spi_dev = spi;
 
-	printk("Driver Initializing success\n");
+	netdev_info("Driver Initializing success\n");
 	return 0;
 }
 
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index ae11186..7e88723 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -59,16 +59,16 @@ static ssize_t wilc_debug_level_write(struct file *filp, const char __user *buf,
 		return ret;
 
 	if (flag > DBG_LEVEL_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
+		netdev_err("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&DEBUG_LEVEL));
 		return -EINVAL;
 	}
 
 	atomic_set(&DEBUG_LEVEL, (int)flag);
 
 	if (flag == 0)
-		printk("Debug-level disabled\n");
+		netdev_debug("Debug-level disabled\n");
 	else
-		printk("Debug-level enabled\n");
+		netdev_debug("Debug-level enabled\n");
 
 	return count;
 }
@@ -102,12 +102,12 @@ static ssize_t wilc_debug_region_write(struct file *filp, const char *buf, size_
 	flag = buffer[0] - '0';
 
 	if (flag > DBG_REGION_ALL) {
-		printk("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&REGION));
+		netdev_err("%s, value (0x%08x) is out of range, stay previous flag (0x%08x)\n", __func__, flag, atomic_read(&REGION));
 		return -EFAULT;
 	}
 
 	atomic_set(&REGION, (int)flag);
-	printk("new debug-region is %x\n", atomic_read(&REGION));
+	netdev_debug("new debug-region is %x\n", atomic_read(&REGION));
 
 	return count;
 }
@@ -146,12 +146,12 @@ int wilc_debugfs_init(void)
 	wilc_dir = debugfs_create_dir("wilc_wifi", NULL);
 	if (wilc_dir ==  ERR_PTR(-ENODEV)) {
 		/* it's not error. the debugfs is just not being enabled. */
-		printk("ERR, kernel has built without debugfs support\n");
+		netdev_err("kernel has built without debugfs support\n");
 		return 0;
 	}
 
 	if (!wilc_dir) {
-		printk("ERR, debugfs create dir\n");
+		netdev_err("debugfs create dir\n");
 		return -1;
 	}
 
@@ -164,7 +164,7 @@ int wilc_debugfs_init(void)
 						    &info->fops);
 
 		if (!debugfs_files) {
-			printk("ERR fail to create the debugfs file, %s\n", info->name);
+			netdev_err("fail to create the debugfs file, %s\n", info->name);
 			debugfs_remove_recursive(wilc_dir);
 			return -1;
 		}
diff --git a/drivers/staging/wilc1000/wilc_exported_buf.c b/drivers/staging/wilc1000/wilc_exported_buf.c
index c3f6a0a..148d608 100644
--- a/drivers/staging/wilc1000/wilc_exported_buf.c
+++ b/drivers/staging/wilc1000/wilc_exported_buf.c
@@ -45,7 +45,6 @@ EXPORT_SYMBOL(get_fw_buffer);
 
 static int __init wilc_module_init(void)
 {
-	printk("wilc_module_init\n");
 	/*
 	 * alloc necessary memory
 	 */
@@ -58,7 +57,6 @@ static int __init wilc_module_init(void)
 
 static void __exit wilc_module_deinit(void)
 {
-	printk("wilc_module_deinit\n");
 	FREE_WILC_BUFFER(g_tx_buf)
 	FREE_WILC_BUFFER(g_rx_buf)
 	FREE_WILC_BUFFER(g_fw_buf)
-- 
2.1.4

