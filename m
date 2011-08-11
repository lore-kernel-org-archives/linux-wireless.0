Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53070 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1HKK7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 06:59:15 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: do not build libertas_sdio for kernel < 2.6.32
Date: Thu, 11 Aug 2011 12:59:07 +0200
Message-Id: <1313060347-665-2-git-send-email-hauke@hauke-m.de> (sfid-20110811_125918_841137_FA272088)
In-Reply-To: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
References: <1313060347-665-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

if_sdio.c needs some new power management functions not available in
older kernel functions. When building for older kernel I get these
compiler errors:

/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_power_save’:
/drivers/net/wireless/libertas/if_sdio.c:1071:2: error: implicit declaration of function ‘pm_runtime_put_sync’
/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_power_restore’:
/drivers/net/wireless/libertas/if_sdio.c:1081:2: error: implicit declaration of function ‘pm_runtime_get_sync’
/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_probe’:
/drivers/net/wireless/libertas/if_sdio.c:1231:2: error: implicit declaration of function ‘pm_runtime_put_noidle’
/drivers/net/wireless/libertas/if_sdio.c: In function ‘if_sdio_remove’:
/drivers/net/wireless/libertas/if_sdio.c:1268:2: error: implicit declaration of function ‘pm_runtime_get_noresume’

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                              |    9 +++------
 patches/08-rename-config-options.patch |    9 +++++++++
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/config.mk b/config.mk
index 27d4daf..e2bffeb 100644
--- a/config.mk
+++ b/config.mk
@@ -555,13 +555,10 @@ endif #CONFIG_CRC7
 
 CONFIG_MWIFIEX_SDIO=m
 
-ifdef CONFIG_COMPAT_KERNEL_2_6_27
-CONFIG_LIBERTAS_SDIO=n
-NEED_LIBERTAS=n
-else #CONFIG_COMPAT_KERNEL_2_6_27
-CONFIG_LIBERTAS_SDIO=m
+ifndef CONFIG_COMPAT_KERNEL_2_6_32
+CONFIG_COMPAT_LIBERTAS_SDIO=m
 NEED_LIBERTAS=y
-endif #CONFIG_COMPAT_KERNEL_2_6_27
+endif #CONFIG_COMPAT_KERNEL_2_6_32
 
 CONFIG_IWM=m
 # CONFIG_IWM_DEBUG=y
diff --git a/patches/08-rename-config-options.patch b/patches/08-rename-config-options.patch
index 70ca190..5505018 100644
--- a/patches/08-rename-config-options.patch
+++ b/patches/08-rename-config-options.patch
@@ -59,6 +59,15 @@ CONFIG_BT_HIDP does not build with older kernel versions.
  
  	{0}
  };
+--- a/drivers/net/wireless/libertas/Makefile
++++ b/drivers/net/wireless/libertas/Makefile
+@@ -16,5 +16,5 @@ libertas_spi-objs += if_spi.o
+ obj-$(CONFIG_LIBERTAS)     += libertas.o
+ obj-$(CONFIG_LIBERTAS_USB) += usb8xxx.o
+ obj-$(CONFIG_LIBERTAS_CS)  += libertas_cs.o
+-obj-$(CONFIG_LIBERTAS_SDIO) += libertas_sdio.o
++obj-$(CONFIG_COMPAT_LIBERTAS_SDIO) += libertas_sdio.o
+ obj-$(CONFIG_LIBERTAS_SPI) += libertas_spi.o
 --- a/drivers/net/wireless/zd1211rw/Makefile
 +++ b/drivers/net/wireless/zd1211rw/Makefile
 @@ -1,4 +1,4 @@
-- 
1.7.4.1

