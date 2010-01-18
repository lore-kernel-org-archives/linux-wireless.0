Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53825 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab0ARO3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 09:29:10 -0500
Message-ID: <4B547031.60600@openwrt.org>
Date: Mon, 18 Jan 2010 15:29:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/2] compat: fix firmware class compile on linux 2.6.32
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware class API change happened after 2.6.32, so move the compat
code to the 2.6.33 header file.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -9,40 +9,6 @@
 #include <linux/compat.h>
 #include <net/iw_handler.h>
 #include <linux/workqueue.h>
-#include <linux/firmware.h>
-
-#define release_firmware compat_release_firmware
-#define request_firmware compat_request_firmware
-#define request_firmware_nowait compat_request_firmware_nowait
-
-#if defined(CONFIG_FW_LOADER) || (defined(CONFIG_FW_LOADER_MODULE) && defined(MODULE))
-int compat_request_firmware(const struct firmware **fw, const char *name,
-		     struct device *device);
-int compat_request_firmware_nowait(
-	struct module *module, int uevent,
-	const char *name, struct device *device, gfp_t gfp, void *context,
-	void (*cont)(const struct firmware *fw, void *context));
-
-void compat_release_firmware(const struct firmware *fw);
-#else
-static inline int compat_request_firmware(const struct firmware **fw,
-				   const char *name,
-				   struct device *device)
-{
-	return -EINVAL;
-}
-static inline int request_firmware_nowait(
-	struct module *module, int uevent,
-	const char *name, struct device *device, gfp_t gfp, void *context,
-	void (*cont)(const struct firmware *fw, void *context))
-{
-	return -EINVAL;
-}
-
-static inline void compat_release_firmware(const struct firmware *fw)
-{
-}
-#endif
 
 #define SDIO_VENDOR_ID_INTEL			0x0089
 #define SDIO_DEVICE_ID_INTEL_IWMC3200WIMAX	0x1402
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -10,6 +10,40 @@
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
 #include <linux/kfifo.h>
+#include <linux/firmware.h>
+
+#define release_firmware compat_release_firmware
+#define request_firmware compat_request_firmware
+#define request_firmware_nowait compat_request_firmware_nowait
+
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+int compat_request_firmware(const struct firmware **fw, const char *name,
+		     struct device *device);
+int compat_request_firmware_nowait(
+	struct module *module, int uevent,
+	const char *name, struct device *device, gfp_t gfp, void *context,
+	void (*cont)(const struct firmware *fw, void *context));
+
+void compat_release_firmware(const struct firmware *fw);
+#else
+static inline int compat_request_firmware(const struct firmware **fw,
+				   const char *name,
+				   struct device *device)
+{
+	return -EINVAL;
+}
+static inline int request_firmware_nowait(
+	struct module *module, int uevent,
+	const char *name, struct device *device, gfp_t gfp, void *context,
+	void (*cont)(const struct firmware *fw, void *context))
+{
+	return -EINVAL;
+}
+
+static inline void compat_release_firmware(const struct firmware *fw)
+{
+}
+#endif
 
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */

