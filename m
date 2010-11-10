Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41925 "EHLO nbd.name"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757010Ab0KJWqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 17:46:51 -0500
Message-ID: <4CDB20D9.603@openwrt.org>
Date: Wed, 10 Nov 2010 23:46:49 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] compat: backport pm_qos_*_request
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -8,6 +8,7 @@
 #include <linux/usb.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
+#include <linux/pm_qos_params.h>
 
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
@@ -58,6 +59,39 @@ static inline int pcmcia_write_config_by
 
 #define PCI_EEPROM_WIDTH_93C86   8
 
+struct pm_qos_request_list {
+	u32 qos;
+	void *request;
+};
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
+
+#define pm_qos_add_request(_req, _class, _value) do {			\
+	(_req)->request = #_req;					\
+	(_req)->qos = _class;						\
+	pm_qos_add_requirement((_class), (_req)->request, (_value));	\
+    } while(0)
+
+#define pm_qos_update_request(_req, _value)				\
+	pm_qos_update_requirement((_req)->qos, (_req)->request, (_value))
+
+#define pm_qos_remove_request(_req)					\
+	pm_qos_remove_requirement((_req)->qos, (_req)->request)
+
+#else
+
+#define pm_qos_add_request(_req, _class, _value) do {			\
+	(_req)->request = pm_qos_add_request((_class), (_value));	\
+    } while (0)
+
+#define pm_qos_update_request(_req, _value)				\
+	pm_qos_update_request((_req)->request, (_value)
+
+#define pm_qos_remove_request(_req)					\
+	pm_qos_remove_request((_req)->request)
+
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
 
 #endif /* LINUX_26_36_COMPAT_H */
