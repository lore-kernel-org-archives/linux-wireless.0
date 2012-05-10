Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40365 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab2EJJOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:14:32 -0400
Received: by wibhr2 with SMTP id hr2so243407wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:14:31 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/78] wl18xx: add new module
Date: Thu, 10 May 2012 12:13:06 +0300
Message-Id: <1336641263-5761-2-git-send-email-arik@wizery.com> (sfid-20120510_111437_209157_7B842D86)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Add the wl18xx module and the probe functions.  Use wlcore for the
main parts (not functional at this point due to differences in the
wl18xx initialization).

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/Kconfig         |    1 +
 drivers/net/wireless/ti/Makefile        |    1 +
 drivers/net/wireless/ti/wl18xx/Kconfig  |    6 +++
 drivers/net/wireless/ti/wl18xx/Makefile |    3 ++
 drivers/net/wireless/ti/wl18xx/main.c   |   73 +++++++++++++++++++++++++++++++
 5 files changed, 84 insertions(+)
 create mode 100644 drivers/net/wireless/ti/wl18xx/Kconfig
 create mode 100644 drivers/net/wireless/ti/wl18xx/Makefile
 create mode 100644 drivers/net/wireless/ti/wl18xx/main.c

diff --git a/drivers/net/wireless/ti/Kconfig b/drivers/net/wireless/ti/Kconfig
index 1a72932..be80011 100644
--- a/drivers/net/wireless/ti/Kconfig
+++ b/drivers/net/wireless/ti/Kconfig
@@ -8,6 +8,7 @@ menuconfig WL_TI
 if WL_TI
 source "drivers/net/wireless/ti/wl1251/Kconfig"
 source "drivers/net/wireless/ti/wl12xx/Kconfig"
+source "drivers/net/wireless/ti/wl18xx/Kconfig"
 
 # keep last for automatic dependencies
 source "drivers/net/wireless/ti/wlcore/Kconfig"
diff --git a/drivers/net/wireless/ti/Makefile b/drivers/net/wireless/ti/Makefile
index 0a56562..4d68239 100644
--- a/drivers/net/wireless/ti/Makefile
+++ b/drivers/net/wireless/ti/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_WLCORE)			+= wlcore/
 obj-$(CONFIG_WL12XX)			+= wl12xx/
 obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wlcore/
 obj-$(CONFIG_WL1251)			+= wl1251/
+obj-$(CONFIG_WL18XX)			+= wl18xx/
diff --git a/drivers/net/wireless/ti/wl18xx/Kconfig b/drivers/net/wireless/ti/wl18xx/Kconfig
new file mode 100644
index 0000000..1451d1f
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/Kconfig
@@ -0,0 +1,6 @@
+config WL18XX
+       tristate "TI wl18xx support"
+       select WLCORE
+       ---help---
+	  This module adds support for wireless adapters based on TI
+	  WiLink 8 chipsets.
diff --git a/drivers/net/wireless/ti/wl18xx/Makefile b/drivers/net/wireless/ti/wl18xx/Makefile
new file mode 100644
index 0000000..d187037
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/Makefile
@@ -0,0 +1,3 @@
+wl18xx-objs	= main.o
+
+obj-$(CONFIG_WL18XX)		+= wl18xx.o
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
new file mode 100644
index 0000000..cb835d9
--- /dev/null
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -0,0 +1,73 @@
+/*
+ * This file is part of wl18xx
+ *
+ * Copyright (C) 2011 Texas Instruments
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
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include "../wlcore/wlcore.h"
+#include "../wlcore/debug.h"
+
+int __devinit wl18xx_probe(struct platform_device *pdev)
+{
+	struct wl1271 *wl;
+	struct ieee80211_hw *hw;
+
+	hw = wlcore_alloc_hw(0);
+	if (IS_ERR(hw)) {
+		wl1271_error("can't allocate hw");
+		return PTR_ERR(hw);
+	}
+
+	wl = hw->priv;
+
+	return wlcore_probe(wl, pdev);
+}
+
+static const struct platform_device_id wl18xx_id_table[] __devinitconst = {
+	{ "wl18xx", 0 },
+	{  } /* Terminating Entry */
+};
+MODULE_DEVICE_TABLE(platform, wl18xx_id_table);
+
+static struct platform_driver wl18xx_driver = {
+	.probe		= wl18xx_probe,
+	.remove		= __devexit_p(wlcore_remove),
+	.id_table	= wl18xx_id_table,
+	.driver = {
+		.name	= "wl18xx_driver",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init wl18xx_init(void)
+{
+	return platform_driver_register(&wl18xx_driver);
+}
+module_init(wl18xx_init);
+
+static void __exit wl18xx_exit(void)
+{
+	platform_driver_unregister(&wl18xx_driver);
+}
+module_exit(wl18xx_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
-- 
1.7.9.5

