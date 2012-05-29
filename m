Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43908 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab2E2WkC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 18:40:02 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/8] compat-wireless: deactivate wl1251 for kernel < 2.6.37
Date: Wed, 30 May 2012 00:39:37 +0200
Message-Id: <1338331182-29589-4-git-send-email-hauke@hauke-m.de> (sfid-20120530_004012_148931_A8C63AF7)
In-Reply-To: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
References: <1338331182-29589-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1251_sdio and wl1251_spi are depending on irq_set_status_flags() since

commit f380f2c4a12e913356bd49f8790ec1063c4fe9f8
Author: Grazvydas Ignotas <notasas@gmail.com>
Date:   Fri May 18 03:04:08 2012 +0300

    wl1251: fix oops on early interrupt

irq_set_status_flags() was added to the kernel in version 2.6.37 and
backporting it is hard, so do not build wl1251_sdio and wl1251_spi for
older kernel versions.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    6 +++++-
 patches/08-rename-config-options.patch |    8 +++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/config.mk b/config.mk
index 3caebc4..bc0296f 100644
--- a/config.mk
+++ b/config.mk
@@ -556,7 +556,9 @@ ifdef CONFIG_SPI_MASTER
 ifndef CONFIG_COMPAT_KERNEL_2_6_25
 
 ifdef CONFIG_CRC7
-export CONFIG_WL1251_SPI=m
+ifndef CONFIG_COMPAT_KERNEL_2_6_37
+export CONFIG_COMPAT_WL1251_SPI=m
+endif #CONFIG_COMPAT_KERNEL_2_6_37
 export CONFIG_WLCORE_SPI=m
 endif #CONFIG_CRC7
 export CONFIG_P54_SPI=m
@@ -579,7 +581,9 @@ export CONFIG_B43_SDIO=y
 
 ifdef CONFIG_CRC7
 ifdef CONFIG_WL12XX_PLATFORM_DATA
+ifndef CONFIG_COMPAT_KERNEL_2_6_37
 export CONFIG_COMPAT_WL1251_SDIO=m
+endif #CONFIG_COMPAT_KERNEL_2_6_37
 export CONFIG_WLCORE_SDIO=m
 endif #CONFIG_WL12XX_PLATFORM_DATA
 endif #CONFIG_CRC7
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index 44c362d..f8d459a 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -92,11 +92,13 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  hidp-objs := core.o sock.o
 --- a/drivers/net/wireless/ti/wl1251/Makefile
 +++ b/drivers/net/wireless/ti/wl1251/Makefile
-@@ -5,6 +5,6 @@ wl1251_sdio-objs	+= sdio.o
+@@ -4,7 +4,7 @@ wl1251_spi-objs		+= spi.o
+ wl1251_sdio-objs	+= sdio.o
  
  obj-$(CONFIG_WL1251)		+= wl1251.o
- obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
+-obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
 -obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
++obj-$(CONFIG_COMPAT_WL1251_SPI)+= wl1251_spi.o
 +obj-$(CONFIG_COMPAT_WL1251_SDIO)+= wl1251_sdio.o
  
  ccflags-y += -D__CHECK_ENDIAN__
@@ -154,7 +156,7 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  #else
 --- a/net/bluetooth/rfcomm/sock.c
 +++ b/net/bluetooth/rfcomm/sock.c
-@@ -879,7 +879,7 @@ static int rfcomm_sock_ioctl(struct sock
+@@ -860,7 +860,7 @@ static int rfcomm_sock_ioctl(struct sock
  	err = bt_sock_ioctl(sock, cmd, arg);
  
  	if (err == -ENOIOCTLCMD) {
-- 
1.7.9.5

