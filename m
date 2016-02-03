Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25840 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbcBCGRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:17:55 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>, <wnhuang@chromium.org>,
	<devicetree@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 1/3] mwifiex: register platform specific driver
Date: Tue, 2 Feb 2016 22:14:18 -0800
Message-ID: <1454480060-27314-1-git-send-email-akarwar@marvell.com> (sfid-20160203_071802_833754_84C7BBF8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

Platform device and driver provides easy way to
interact with device-tree-enabled system.

This patch registers platform driver and reorganise
existing device tree specific code.
Corresponding device tree binding file is
also created.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 Documentation/devicetree/bindings/mwifiex.txt      | 29 +++++++++++
 drivers/net/wireless/marvell/mwifiex/Makefile      |  1 +
 drivers/net/wireless/marvell/mwifiex/main.c        |  2 +
 drivers/net/wireless/marvell/mwifiex/main.h        | 14 +++++
 .../net/wireless/marvell/mwifiex/platform_drv.c    | 59 ++++++++++++++++++++++
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  5 +-
 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   |  2 +-
 7 files changed, 108 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mwifiex.txt
 create mode 100644 drivers/net/wireless/marvell/mwifiex/platform_drv.c

diff --git a/Documentation/devicetree/bindings/mwifiex.txt b/Documentation/devicetree/bindings/mwifiex.txt
new file mode 100644
index 0000000..39b6a74
--- /dev/null
+++ b/Documentation/devicetree/bindings/mwifiex.txt
@@ -0,0 +1,29 @@
+mwifiex
+------
+
+Required properties:
+
+  - name : must be "mwifiex"
+  - compatible : must be "marvell,mwifiex"
+
+Optional properties:
+
+  - mwifiex,caldata* : A series of properties with marvell,caldata prefix,
+  		      represent Calibration data downloaded to the device during
+		      initialization. This is an array of unsigned values.
+
+
+Example:
+
+Tx power limit calibration data is configured in below example.
+The calibration data is an array of unsigned values, the length
+can vary between hw versions.
+
+mwifiex {
+	compatible = "marvell,mwifiex";
+
+	mwifiex,caldata_00_txpwrlimit_2g_cfg_set = /bits/ 8 <
+0x01 0x00 0x06 0x00 0x08 0x02 0x89 0x01 ...>;
+
+};
+
diff --git a/drivers/net/wireless/marvell/mwifiex/Makefile b/drivers/net/wireless/marvell/mwifiex/Makefile
index fdfd9bf..1444fd1 100644
--- a/drivers/net/wireless/marvell/mwifiex/Makefile
+++ b/drivers/net/wireless/marvell/mwifiex/Makefile
@@ -42,6 +42,7 @@ mwifiex-y += cfg80211.o
 mwifiex-y += ethtool.o
 mwifiex-y += 11h.o
 mwifiex-y += tdls.o
+mwifiex-y += platform_drv.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 3cfa946..b93ae69 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -1538,6 +1538,7 @@ EXPORT_SYMBOL_GPL(_mwifiex_dbg);
 static int
 mwifiex_init_module(void)
 {
+	mwifiex_platform_drv_init();
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_debugfs_init();
 #endif
@@ -1552,6 +1553,7 @@ mwifiex_init_module(void)
 static void
 mwifiex_cleanup_module(void)
 {
+	mwifiex_platform_drv_exit();
 #ifdef CONFIG_DEBUG_FS
 	mwifiex_debugfs_remove();
 #endif
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index aea7aee..464d79f 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -37,6 +37,16 @@
 #include <linux/idr.h>
 #include <linux/inetdevice.h>
 #include <linux/devcoredump.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/gfp.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/of_gpio.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include "decl.h"
 #include "ioctl.h"
@@ -47,6 +57,7 @@
 #include "sdio.h"
 
 extern const char driver_version[];
+extern struct platform_device *mwifiex_plt_dev;
 
 struct mwifiex_adapter;
 struct mwifiex_private;
@@ -1597,6 +1608,9 @@ void mwifiex_process_multi_chan_event(struct mwifiex_private *priv,
 				      struct sk_buff *event_skb);
 void mwifiex_multi_chan_resync(struct mwifiex_adapter *adapter);
 
+int mwifiex_platform_drv_init(void);
+void mwifiex_platform_drv_exit(void);
+
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
 void mwifiex_debugfs_remove(void);
diff --git a/drivers/net/wireless/marvell/mwifiex/platform_drv.c b/drivers/net/wireless/marvell/mwifiex/platform_drv.c
new file mode 100644
index 0000000..f64a12a
--- /dev/null
+++ b/drivers/net/wireless/marvell/mwifiex/platform_drv.c
@@ -0,0 +1,59 @@
+/* Marvell wireless LAN device driver: platform specific driver
+ *
+ * Copyright (C) 2015, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available on the worldwide web at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+#include "main.h"
+
+struct platform_device *mwifiex_plt_dev;
+
+static int mwifiex_plt_probe(struct platform_device *pdev)
+{
+	mwifiex_plt_dev = pdev;
+	return 0;
+}
+
+static int mwifiex_plt_remove(struct platform_device *pdev)
+{
+	mwifiex_plt_dev = NULL;
+	return 0;
+}
+
+static const struct of_device_id mwifiex_dt_match[] = {
+	{
+		.compatible = "marvell,mwifiex",
+	},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, mwifiex_dt_match);
+
+static struct platform_driver mwifiex_platform_driver = {
+	.probe		= mwifiex_plt_probe,
+	.remove		= mwifiex_plt_remove,
+	.driver = {
+		.name	= "mwifiex_plt",
+		.of_match_table = mwifiex_dt_match,
+	}
+};
+
+int mwifiex_platform_drv_init(void)
+{
+	return platform_driver_register(&mwifiex_platform_driver);
+}
+
+void mwifiex_platform_drv_exit(void)
+{
+	platform_driver_unregister(&mwifiex_platform_driver);
+}
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 30f1526..64fc697 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -2154,11 +2154,10 @@ int mwifiex_sta_init_cmd(struct mwifiex_private *priv, u8 first_sta, bool init)
 		 * The cal-data can be read from device tree and/or
 		 * a configuration file and downloaded to firmware.
 		 */
-		adapter->dt_node =
-				of_find_node_by_name(NULL, "marvell_cfgdata");
+		adapter->dt_node = mwifiex_plt_dev->dev.of_node;
 		if (adapter->dt_node) {
 			ret = mwifiex_dnld_dt_cfgdata(priv, adapter->dt_node,
-						      "marvell,caldata");
+						      "mwifiex,caldata");
 			if (ret)
 				return -1;
 		}
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
index 5cbee58..c598f66 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
@@ -195,7 +195,7 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 void mwifiex_dnld_txpwr_table(struct mwifiex_private *priv)
 {
 	if (priv->adapter->dt_node) {
-		char txpwr[] = {"marvell,00_txpwrlimit"};
+		char txpwr[] = {"mwifiex,00_txpwrlimit"};
 
 		memcpy(&txpwr[8], priv->adapter->country_code, 2);
 		mwifiex_dnld_dt_cfgdata(priv, priv->adapter->dt_node, txpwr);
-- 
1.8.1.4

