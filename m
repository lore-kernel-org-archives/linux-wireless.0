Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2470 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2FIVZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 17:25:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 3/5] brcmfmac: add debugfs helper functions
Date: Sat, 9 Jun 2012 22:51:43 +0200
Message-ID: <1339275105-3593-4-git-send-email-arend@broadcom.com> (sfid-20120609_232538_466130_2CF5D0DA)
In-Reply-To: <1339275105-3593-1-git-send-email-arend@broadcom.com>
References: <1339275105-3593-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds debugfs support to brcmfmac. It provide helper functions
to setup the debugfs folder structure for the driver, which has following
hierarchy:

<debugfs_mount>/brcmfmac/<dev_name>/

ie.: /sys/kernel/debug/brcmfmac/mmc0:0001:2/

The new source file provides functions to create and remove the two
folders and a function to retrieve the device-specific folder so files
can be created in it.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    2 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   63 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   23 +++++++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    7 +++
 5 files changed, 98 insertions(+)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index abb4803..9d5170b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -34,3 +34,5 @@ brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 		sdio_chip.o
 brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
 		usb.o
+brcmfmac-$(CONFIG_BRCMDBG) += \
+		dhd_dbg.o
\ No newline at end of file
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 9f63701..a11fe54 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -613,6 +613,9 @@ struct brcmf_pub {
 	struct work_struct multicast_work;
 	u8 macvalue[ETH_ALEN];
 	atomic_t pend_8021x_cnt;
+#ifdef DEBUG
+	struct dentry *dbgfs_dir;
+#endif
 };
 
 struct brcmf_if_event {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
new file mode 100644
index 0000000..0a7a3d5
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -0,0 +1,63 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/debugfs.h>
+#include <linux/if_ether.h>
+#include <linux/if.h>
+#include <linux/ieee80211.h>
+
+#include <defs.h>
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
+#include "dhd.h"
+#include "dhd_bus.h"
+
+static struct dentry *root_folder;
+
+void brcmf_debugfs_init(void)
+{
+	root_folder = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (IS_ERR(root_folder))
+		root_folder = NULL;
+}
+
+void brcmf_debugfs_exit(void)
+{
+	if (!root_folder)
+		return;
+
+	debugfs_remove_recursive(root_folder);
+	root_folder = NULL;
+}
+
+int brcmf_debugfs_attach(struct brcmf_pub *drvr)
+{
+	if (!root_folder)
+		return -ENODEV;
+
+	drvr->dbgfs_dir = debugfs_create_dir(dev_name(drvr->dev), root_folder);
+	return PTR_RET(drvr->dbgfs_dir);
+}
+
+void brcmf_debugfs_detach(struct brcmf_pub *drvr)
+{
+	if (!IS_ERR_OR_NULL(drvr->dbgfs_dir))
+		debugfs_remove_recursive(drvr->dbgfs_dir);
+}
+
+struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr)
+{
+	return drvr->dbgfs_dir;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index a2c4576..0efb226 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -76,4 +76,27 @@ do {									\
 
 extern int brcmf_msg_level;
 
+struct brcmf_pub;
+#ifdef DEBUG
+void brcmf_debugfs_init(void);
+void brcmf_debugfs_exit(void);
+int brcmf_debugfs_attach(struct brcmf_pub *drvr);
+void brcmf_debugfs_detach(struct brcmf_pub *drvr);
+struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
+#else
+static inline void brcmf_debugfs_init(void)
+{
+}
+static inline void brcmf_debugfs_exit(void)
+{
+}
+static inline int brcmf_debugfs_attach(struct brcmf_pub *drvr)
+{
+	return 0;
+}
+static inline void brcmf_debugfs_detach(struct brcmf_pub *drvr)
+{
+}
+#endif
+
 #endif				/* _BRCMF_DBG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8933f9b..01cf6c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -1007,6 +1007,9 @@ int brcmf_attach(uint bus_hdrlen, struct device *dev)
 	drvr->bus_if->drvr = drvr;
 	drvr->dev = dev;
 
+	/* create device debugfs folder */
+	brcmf_debugfs_attach(drvr);
+
 	/* Attach and link in the protocol */
 	ret = brcmf_proto_attach(drvr);
 	if (ret != 0) {
@@ -1123,6 +1126,7 @@ void brcmf_detach(struct device *dev)
 		brcmf_proto_detach(drvr);
 	}
 
+	brcmf_debugfs_detach(drvr);
 	bus_if->drvr = NULL;
 	kfree(drvr);
 }
@@ -1192,6 +1196,8 @@ exit:
 
 static void brcmf_driver_init(struct work_struct *work)
 {
+	brcmf_debugfs_init();
+
 #ifdef CONFIG_BRCMFMAC_SDIO
 	brcmf_sdio_init();
 #endif
@@ -1219,6 +1225,7 @@ static void __exit brcmfmac_module_exit(void)
 #ifdef CONFIG_BRCMFMAC_USB
 	brcmf_usb_exit();
 #endif
+	brcmf_debugfs_exit();
 }
 
 module_init(brcmfmac_module_init);
-- 
1.7.9.5


