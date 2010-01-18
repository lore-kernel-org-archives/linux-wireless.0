Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53837 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab0AROaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 09:30:18 -0500
Message-ID: <4B547076.5060006@openwrt.org>
Date: Mon, 18 Jan 2010 15:30:14 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] compat: fix compile errors with CONFIG_FW_LOADER unset
References: <4B547031.60600@openwrt.org>
In-Reply-To: <4B547031.60600@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
--- a/compat/compat_firmware_class.c
+++ b/compat/compat_firmware_class.c
@@ -20,6 +20,8 @@
 #include <linux/highmem.h>
 #include <linux/firmware.h>
 
+#if defined(CONFIG_FW_LOADER) || defined(CONFIG_FW_LOADER_MODULE)
+
 #define to_dev(obj) container_of(obj, struct device, kobj)
 
 MODULE_AUTHOR("Manuel Estrada Sainz");
@@ -724,3 +726,5 @@ module_exit(firmware_class_exit);
 EXPORT_SYMBOL(release_firmware);
 EXPORT_SYMBOL(request_firmware);
 EXPORT_SYMBOL(request_firmware_nowait);
+
+#endif
