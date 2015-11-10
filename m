Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56957 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbbKJXnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 18:43:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 18/20] staging/wilc1000: split out bus specific modules
Date: Wed, 11 Nov 2015 00:42:38 +0100
Message-Id: <1447198960-2760143-19-git-send-email-arnd@arndb.de> (sfid-20151111_004704_390973_075A94CE)
In-Reply-To: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
References: <1447198960-2760143-1-git-send-email-arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SPI and SDIO specific code is now separate enough that
we just need to restructure the Makefile and Kconfig logic
a bit and export a couple of symbols from the common module
to have separate bus glue drivers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wilc1000/Kconfig        | 66 ++++++++++++++-------------------
 drivers/staging/wilc1000/Makefile       |  7 +++-
 drivers/staging/wilc1000/linux_wlan.c   |  4 ++
 drivers/staging/wilc1000/wilc_debugfs.c |  2 +
 drivers/staging/wilc1000/wilc_wlan.c    |  1 +
 5 files changed, 40 insertions(+), 40 deletions(-)

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
index dcba27bd3bce..198d536da57c 100644
--- a/drivers/staging/wilc1000/Makefile
+++ b/drivers/staging/wilc1000/Makefile
@@ -21,5 +21,8 @@ wilc1000-objs := wilc_wfi_cfgoperations.o linux_wlan.o linux_mon.o \
 			wilc_wlan_cfg.o wilc_debugfs.o \
 			wilc_wlan.o
 
-wilc1000-$(CONFIG_WILC1000_SDIO) += linux_wlan_sdio.o wilc_sdio.o
-wilc1000-$(CONFIG_WILC1000_SPI) += linux_wlan_spi.o wilc_spi.o
+obj-$(CONFIG_WILC1000_SDIO) += wilc1000-sdio.o
+wilc1000-sdio-objs += linux_wlan_sdio.o wilc_sdio.o
+
+obj-$(CONFIG_WILC1000_SPI) += wilc1000-spi.o
+wilc1000-spi-objs += linux_wlan_spi.o wilc_spi.o
diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 1b6e1eec2446..0d6c22ca7920 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -44,6 +44,8 @@ static struct net_device_stats *mac_stats(struct net_device *dev);
 static int  mac_ioctl(struct net_device *ndev, struct ifreq *req, int cmd);
 static void wilc_set_multicast_list(struct net_device *dev);
 struct wilc *wilc_dev;
+EXPORT_SYMBOL_GPL(wilc_dev);
+
 bool wilc_enable_ps = true;
 
 static const struct net_device_ops wilc_netdev_ops = {
@@ -1411,6 +1413,7 @@ void wilc_netdev_cleanup(struct wilc *wilc)
 	wilc_debugfs_remove();
 #endif
 }
+EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
 
 int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 		     int gpio, const struct wilc_hif_func *ops)
@@ -1487,3 +1490,4 @@ int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(wilc_netdev_init);
diff --git a/drivers/staging/wilc1000/wilc_debugfs.c b/drivers/staging/wilc1000/wilc_debugfs.c
index d70f96f475b8..158a1df17195 100644
--- a/drivers/staging/wilc1000/wilc_debugfs.c
+++ b/drivers/staging/wilc1000/wilc_debugfs.c
@@ -27,7 +27,9 @@ static struct dentry *wilc_dir;
 #define DBG_REGION_ALL	(GENERIC_DBG | HOSTAPD_DBG | HOSTINF_DBG | CORECONFIG_DBG | CFG80211_DBG | INT_DBG | TX_DBG | RX_DBG | LOCK_DBG | INIT_DBG | BUS_DBG | MEM_DBG)
 #define DBG_LEVEL_ALL	(DEBUG | INFO | WRN | ERR)
 atomic_t WILC_REGION = ATOMIC_INIT(INIT_DBG | GENERIC_DBG | CFG80211_DBG | FIRM_DBG | HOSTAPD_DBG);
+EXPORT_SYMBOL_GPL(WILC_REGION);
 atomic_t WILC_DEBUG_LEVEL = ATOMIC_INIT(ERR);
+EXPORT_SYMBOL_GPL(WILC_DEBUG_LEVEL);
 
 /*
  * --------------------------------------------------------------------------------
diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index f72f976906cc..a71901c22653 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -1181,6 +1181,7 @@ void wilc_handle_isr(void *wilc)
 	}
 	release_bus(RELEASE_ALLOW_SLEEP);
 }
+EXPORT_SYMBOL_GPL(wilc_handle_isr);
 
 int wilc_wlan_firmware_download(const u8 *buffer, u32 buffer_size)
 {
-- 
2.1.0.rc2

