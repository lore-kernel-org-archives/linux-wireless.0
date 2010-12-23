Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout028.mac.com ([17.148.16.103]:57128 "EHLO
	asmtpout028.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab0LWO6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Dec 2010 09:58:16 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp028.mac.com (Oracle Communications Messaging Exchange Server 7u4-20.01
 64bit (built Nov 21 2010)) with ESMTPSA id <0LDV00LQSYWYCZ80@asmtp028.mac.com>
 for linux-wireless@vger.kernel.org; Thu, 23 Dec 2010 06:58:15 -0800 (PST)
Subject: Re: Backporting wl1271 driver to kernel-2.6.32 using compat-wireless
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4D1266FA.7080305@hauke-m.de>
Date: Thu, 23 Dec 2010 18:57:55 +0400
Cc: Linux Wireless Mailing List <linux-wireless@vger.kernel.org>
Message-id: <C3623F33-950F-4D63-AE8A-EB24894C89F5@mac.com>
References: <1CA1EE34-CB3D-404D-ADEE-612C8783BFCF@mac.com>
 <AANLkTin8RZwVrWAdNn_Q+_bX8BAHgKreyHiVjznZtMxU@mail.gmail.com>
 <1A56906E-D786-45E6-9C77-C9D600B508B0@mac.com>
 <AANLkTikhLKuw56BhDkBUMU-nf8ZYF1v5Berj-+qupAtO@mail.gmail.com>
 <E90F18E9-6332-4A7C-97DA-01169E5BB5E1@mac.com>
 <AANLkTik6m0rabY3ZCseoch7fwxhMksMD83A-ygtN4cVu@mail.gmail.com>
 <F4DFEC94-D5AC-4C12-890D-8F242E757071@mac.com>
 <AANLkTi=owvDyO3qfahUwRv4MxJrvMK9hjh5NOwRHQuO+@mail.gmail.com>
 <7F14B85B-566C-45A9-BF8B-FE9DED7944D0@mac.com>
 <AANLkTik7jvW9pA3deanBRXxJh6tLeO7WQgqrkN3xa9LG@mail.gmail.com>
 <4D122B8F.5090302@hauke-m.de> <1813D0B1-5391-48DB-9882-A6586DAB180C@mac.com>
 <AANLkTimMWH63yG2tdu7OHemHs=6OOy_i5fpeEDhhh6O9@mail.gmail.com>
 <4D123FBB.1050801@hauke-m.de> <C7700580-CCBB-498D-9EA5-73E2BF748C68@mac.com>
 <A7C7741B-634A-4C4B-A6F1-EBEA5F2EEED5@mac.com> <4D125B9F.7090503@hauke-m.de>
 <A8ED3E8F-FA2A-46B9-95C6-F2C175581539@mac.com> <4D1266FA.7080305@hauke-m.de>
To: Hauke Mehrtens <hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Dec 23, 2010, at 1:00 AM, Hauke Mehrtens wrote:

> You also have to backport the CONFIG_WL12XX_PLATFORM_DATA and activate
> it in your kernel config, wl1271_sdio depends on that.

I did as you suggested and was able to get wl1271_sdio.ko to build.

I have attached a patch for this, which can be applied on top of the TI android rowboat-eclair-2.6.32 kernel branch. This kernel works with android-2.2.1 (froyo), although the kernel was originally developed for android eclair.

>From cec5d06e38664a44e7b723f55648cbcfbc920d6e Mon Sep 17 00:00:00 2001
From: Elvis Dowson <elvis.dowson@gmail.com>
Date: Thu, 23 Dec 2010 18:52:42 +0400
Subject: [PATCH 3/3] wl12xx: Add support for wl12xx_platform_data.

---
 drivers/net/wireless/wl12xx/Kconfig                |   29 +++++++++++-
 drivers/net/wireless/wl12xx/Makefile               |    2 +
 drivers/net/wireless/wl12xx/wl12xx_platform_data.c |   28 +++++++++++
 include/linux/wl12xx.h                             |   51 ++++++++++++++++++++
 4 files changed, 109 insertions(+), 1 deletions(-)
 create mode 100644 drivers/net/wireless/wl12xx/wl12xx_platform_data.c
 create mode 100644 include/linux/wl12xx.h

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 785e024..4a8bb25 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -41,7 +41,7 @@ config WL1251_SDIO
 
 config WL1271
 	tristate "TI wl1271 support"
-	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
+	depends on WL12XX && GENERIC_HARDIRQS
 	depends on INET
 	select FW_LOADER
 	select CRC7
@@ -51,3 +51,30 @@ config WL1271
 
 	  If you choose to build a module, it'll be called wl1271. Say N if
 	  unsure.
+
+config WL1271_SPI
+	tristate "TI wl1271 SPI support"
+	depends on WL1271 && SPI_MASTER
+	---help---
+	  This module adds support for the SPI interface of adapters using
+	  TI wl1271 chipset.  Select this if your platform is using
+	  the SPI bus.
+
+	  If you choose to build a module, it'll be called wl1251_spi.
+	  Say N if unsure.
+
+config WL1271_SDIO
+	tristate "TI wl1271 SDIO support"
+	depends on WL1271 && MMC
+	---help---
+	  This module adds support for the SDIO interface of adapters using
+	  TI wl1271 chipset.  Select this if your platform is using
+	  the SDIO bus.
+
+	  If you choose to build a module, it'll be called
+	  wl1271_sdio. Say N if unsure.
+
+config WL12XX_PLATFORM_DATA
+	bool
+	depends on WL1271_SDIO != n
+	default y
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index 62e37ad..51b348e 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -12,3 +12,5 @@ wl1271-objs		= wl1271_main.o  wl1271_spi.o wl1271_cmd.o  \
 			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
 			  wl1271_init.o  wl1271_debugfs.o
 obj-$(CONFIG_WL1271)	+= wl1271.o
+
+obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
diff --git a/drivers/net/wireless/wl12xx/wl12xx_platform_data.c b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
new file mode 100644
index 0000000..973b110
--- /dev/null
+++ b/drivers/net/wireless/wl12xx/wl12xx_platform_data.c
@@ -0,0 +1,28 @@
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/wl12xx.h>
+
+static const struct wl12xx_platform_data *platform_data;
+
+int __init wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
+{
+	if (platform_data)
+		return -EBUSY;
+	if (!data)
+		return -EINVAL;
+
+	platform_data = kmemdup(data, sizeof(*data), GFP_KERNEL);
+	if (!platform_data)
+		return -ENOMEM;
+
+	return 0;
+}
+
+const struct wl12xx_platform_data *wl12xx_get_platform_data(void)
+{
+	if (!platform_data)
+		return ERR_PTR(-ENODEV);
+
+	return platform_data;
+}
+EXPORT_SYMBOL(wl12xx_get_platform_data);
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
new file mode 100644
index 0000000..4f902e1
--- /dev/null
+++ b/include/linux/wl12xx.h
@@ -0,0 +1,51 @@
+/*
+ * This file is part of wl12xx
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ *
+ * Contact: Luciano Coelho <luciano.coelho@nokia.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
+ * 02110-1301 USA
+ *
+ */
+
+#ifndef _LINUX_WL12XX_H
+#define _LINUX_WL12XX_H
+
+struct wl12xx_platform_data {
+	void (*set_power)(bool enable);
+	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
+	int irq;
+	bool use_eeprom;
+	int board_ref_clock;
+};
+
+#ifdef CONFIG_WL12XX_PLATFORM_DATA
+
+int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
+
+#else
+
+static inline
+int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
+{
+	return -ENOSYS;
+}
+
+#endif
+
+const struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+
+#endif
-- 
1.7.0.4


Best regards,

Elvis Dowson
