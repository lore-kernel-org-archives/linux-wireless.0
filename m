Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:58491 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681AbbJTWsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 18:48:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-wireless@vger.kernel.org
Cc: Rachel Kim <rachel.kim@atmel.com>, devel@driverdev.osuosl.org,
	Chris Park <chris.park@atmel.com>, gregkh@linuxfoundation.org,
	Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	linux-kernel@vger.kernel.org, Tony Cho <tony.cho@atmel.com>,
	Glen Lee <glen.lee@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 18/19] staging/wilc1000: split out bus specific modules
Date: Wed, 21 Oct 2015 00:47:37 +0200
Message-Id: <1445381258-1455986-19-git-send-email-arnd@arndb.de> (sfid-20151021_005255_182826_C35F0EE9)
In-Reply-To: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
References: <1445381258-1455986-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SPI and SDIO specific code is now separate enough that
we just need to restructure the Makefile and Kconfig logic
a bit and export a couple of symbols from the common module
to have separate bus glue drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Kconfig           | 66 +++++++++++++-----------------
 drivers/staging/wilc1000/Makefile          |  9 ++--
 drivers/staging/wilc1000/linux_wlan.c      |  6 +++
 drivers/staging/wilc1000/linux_wlan_sdio.c |  1 +
 drivers/staging/wilc1000/linux_wlan_spi.c  |  1 +
 drivers/staging/wilc1000/wilc_debugfs.c    |  2 +
 drivers/staging/wilc1000/wilc_wlan.c       |  1 +
 7 files changed, 45 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wilc1000/Kconfig b/drivers/staging/wilc1000/Kconfig
index ee51b4278088..2923122346ef 100644
--- a/drivers/staging/wilc1000/Kconfig
+++ b/drivers/staging/wilc1000/Kconfig
@@ -1,41 +1,12 @@
-config WILC1000_DRIVER
-	bool "WILC1000 support (WiFi only)"
-	depends on CFG80211 && WEXT_CORE && INET
-	---help---
-	  This module only support IEEE 802.11n WiFi.
-
-if WILC1000_DRIVER
-
 config WILC1000
 	tristate
-
-choice
-        prompt "Memory Allocation"
-        default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
-
-config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
-	bool "Preallocate memory at loading driver"
+	select WIRELESS_EXT
 	---help---
-	  This choice supports static allocation of the memory
-	  for the receive buffer. The driver will allocate the RX buffer
-	  during initial time. The driver will also free the buffer
-	  by calling network device stop.
-
-config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
-        bool "Dynamically allocate memory in real time"
-        ---help---
-	  This choice supports dynamic allocation of the memory
-	  for the receive buffer. The driver will allocate the RX buffer
-	  when it is required.
-endchoice
-
-choice
-	prompt "Bus Type"
-	default WILC1000_SDIO
+	  This module only support IEEE 802.11n WiFi.
 
 config WILC1000_SDIO
-	bool "SDIO support"
-	depends on MMC
+	tristate "Atmel WILC1000 SDIO (WiFi only)"
+	depends on CFG80211 && INET && MMC
 	select WILC1000
 	---help---
 	  This module adds support for the SDIO interface of adapters using
@@ -48,9 +19,9 @@ config WILC1000_SDIO
 	  this if your platform is using the SDIO bus.
 
 config WILC1000_SPI
-	depends on SPI
+	tristate "Atmel WILC1000 SPI (WiFi only)"
+	depends on CFG80211 && INET && SPI
 	select WILC1000
-	bool "SPI support"
 	---help---
 	  This module adds support for the SPI interface of adapters using
 	  WILC1000 chipset. The Atmel WILC1000 has a Serial Peripheral
@@ -59,10 +30,31 @@ config WILC1000_SPI
 	  full-duplex slave synchronous serial interface that is available
 	  immediately following reset when pin 9 (SDIO_SPI_CFG) is tied to
 	  VDDIO. Select this if your platform is using the SPI bus.
+
+choice
+        prompt "WILC1000 Memory Allocation"
+        depends on WILC1000
+        default WILC1000_PREALLOCATE_AT_LOADING_DRIVER
+
+config WILC1000_PREALLOCATE_AT_LOADING_DRIVER
+	bool "Preallocate memory at loading driver"
+	---help---
+	  This choice supports static allocation of the memory
+	  for the receive buffer. The driver will allocate the RX buffer
+	  during initial time. The driver will also free the buffer
+	  by calling network device stop.
+
+config WILC1000_DYNAMICALLY_ALLOCATE_MEMROY
+        bool "Dynamically allocate memory in real time"
+        ---help---
+	  This choice supports dynamic allocation of the memory
+	  for the receive buffer. The driver will allocate the RX buffer
+	  when it is required.
 endchoice
 
+
 config WILC1000_HW_OOB_INTR
-	bool "Use out of band interrupt"
+	bool "WILC1000 out of band interrupt"
 	depends on WILC1000_SDIO
 	default n
 	---help---
@@ -71,5 +63,3 @@ config WILC1000_HW_OOB_INTR
 	  mechanism for SDIO host controllers that don't support SDIO interrupt.
 	  Select this option If the SDIO host controller in your platform
 	  doesn't support SDIO time devision interrupt.
-
-endif
diff --git a/drivers/staging/wilc1000/Makefile b/drivers/staging/wilc1000/Makefile
index 9ce30e92ea3a..198d536da57c 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -18,8 +18,11 @@ ccflags-$(CONFIG_WILC1000_DYNAMICALLY_ALLOCATE_MEMROY) += -DWILC_NORMAL_ALLOC
 wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_msgqueue.o \
 			coreconfigurator.o host_interface.o \
-			wilc_sdio.o wilc_spi.o wilc_wlan_cfg.o wilc_debugfs.o \
+			wilc_wlan_cfg.o wilc_debugfs.o \
 			wilc_wlan.o
 
-wilc1000-$(CONFIG_WILC1000_SDIO) += linux_wlan_sdio.o
-wilc1000-$(CONFIG_WILC1000_SPI) += linux_wlan_spi.o
+obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
+wilc1000-sdio-objs += linux_wlan_sdio.o wilc_sdio.o
+
+obj-$(CONFIG_WILC1000_SPI) += wilc1000-spi.o
+wilc1000-spi-objs += linux_wlan_spi.o wilc_spi.o
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 04ebb6310070..8a5f4673c5d0 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -56,6 +56,8 @@ static void wilc_set_multicast_list(struct net_device *dev);
  * and this data should be pointer to net device
  */
 struct wilc *wilc1000_dev;
+EXPORT_SYMBOL_GPL(wilc1000_dev);
+
 bool wilc1000_enable_ps = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -1590,6 +1592,7 @@ int wilc_netdev_init(struct device *dev, const struct wilc1000_ops *ops,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wilc_netdev_init);
 
 void __init wilc1000_init_driver(void)
 {
@@ -1601,6 +1604,7 @@ void __init wilc1000_init_driver(void)
 	printk("IN INIT FUNCTION\n");
 	printk("*** WILC1000 driver VERSION=[10.2] FW_VER=[10.2] ***\n");
 }
+EXPORT_SYMBOL_GPL(wilc1000_init_driver);
 
 void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
 {
@@ -1647,6 +1651,7 @@ void __exit wilc_netdev_free(struct wilc *wilc1000_dev)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(wilc_netdev_free);
 
 void __exit wilc1000_exit_driver(void)
 {
@@ -1658,5 +1663,6 @@ void __exit wilc1000_exit_driver(void)
 	wilc_debugfs_remove();
 #endif
 }
+EXPORT_SYMBOL_GPL(wilc1000_exit_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 1f79d986be5c..1f343ac72530 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -350,3 +350,4 @@ static void __exit exit_wilc_sdio_driver(void)
 	wilc1000_exit_driver();
 }
 module_exit(exit_wilc_sdio_driver);
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/linux_wlan_spi.c b/drivers/staging/wilc1000/linux_wlan_spi.c
index 02b922ab86bb..c0e0e6be6b0b 100644
--- a/drivers/staging/wilc1000/linux_wlan_spi.c
+++ b/drivers/staging/wilc1000/linux_wlan_spi.c
@@ -447,3 +447,4 @@ static void __exit exit_wilc_spi_driver(void)
 	wilc1000_exit_driver();
 }
 module_exit(exit_wilc_spi_driver);
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index c22f0ca10250..6f37b6491de7 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -27,7 +27,9 @@ static struct dentry *wilc_dir;
 #define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CORECONFIG_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC1000_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
+EXPORT_SYMBOL_GPL(WILC1000_REGION);
 atomic_t WILC1000_DEBUG_LEVEL = ATOMIC_INIT(ERR);
+EXPORT_SYMBOL_GPL(WILC1000_DEBUG_LEVEL);
 
 /*
  * --------------------------------------------------------------------------------
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 04d2938a383c..bebc0880cc02 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1376,6 +1376,7 @@ void wilc_handle_isr(void)
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
 }
+EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
 /********************************************
  *
-- 
2.1.0.rc2

