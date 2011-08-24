Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39707 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab1HXLUr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 07:20:47 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: add mac_pton()
Date: Wed, 24 Aug 2011 13:20:37 +0200
Message-Id: <1314184839-13279-1-git-send-email-hauke@hauke-m.de> (sfid-20110824_132050_935211_8E891124)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/Makefile            |    1 +
 compat/compat-3.0.c        |   37 +++++++++++++++++++++++++++++++++++++
 include/linux/compat-3.0.h |    2 ++
 3 files changed, 40 insertions(+), 0 deletions(-)
 create mode 100644 compat/compat-3.0.c

diff --git a/compat/Makefile b/compat/Makefile
index e2a6add..8e3739c 100644
--- a/compat/Makefile
+++ b/compat/Makefile
@@ -33,4 +33,5 @@ compat-$(CONFIG_COMPAT_KERNEL_2_6_38) += compat-2.6.38.o
 compat-$(CONFIG_COMPAT_KERNEL_2_6_39) += \
 	compat-2.6.39.o \
 	kstrtox.o
+compat-$(CONFIG_COMPAT_KERNEL_3_0) += compat-3.0.o
 
diff --git a/compat/compat-3.0.c b/compat/compat-3.0.c
new file mode 100644
index 0000000..312eea0
--- /dev/null
+++ b/compat/compat-3.0.c
@@ -0,0 +1,37 @@
+/*
+ * Copyright 2011    Hauke Mehrtens <hauke@hauke-m.de>
+ * Copyright 2011    Alexey Dobriyan <adobriyan@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Compatibility file for Linux wireless for kernels 3.0.
+ */
+
+#include <linux/compat.h>
+#include <linux/if_ether.h>
+
+int mac_pton(const char *s, u8 *mac)
+{
+	int i;
+
+	/* XX:XX:XX:XX:XX:XX */
+	if (strlen(s) < 3 * ETH_ALEN - 1)
+		return 0;
+
+	/* Don't dirty result unless string is valid MAC. */
+	for (i = 0; i < ETH_ALEN; i++) {
+		if (!strchr("0123456789abcdefABCDEF", s[i * 3]))
+			return 0;
+		if (!strchr("0123456789abcdefABCDEF", s[i * 3 + 1]))
+			return 0;
+		if (i != ETH_ALEN - 1 && s[i * 3 + 2] != ':')
+			return 0;
+	}
+	for (i = 0; i < ETH_ALEN; i++) {
+		mac[i] = (hex_to_bin(s[i * 3]) << 4) | hex_to_bin(s[i * 3 + 1]);
+	}
+	return 1;
+}
+EXPORT_SYMBOL(mac_pton);
diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
index 667ea38..7954ddb 100644
--- a/include/linux/compat-3.0.h
+++ b/include/linux/compat-3.0.h
@@ -46,6 +46,8 @@ struct bcma_device_id {
 #define BCMA_ANY_CLASS		0xFF
 #endif /* BCMA_CORE */
 
+int mac_pton(const char *s, u8 *mac);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) */
 
 #endif /* LINUX_3_0_COMPAT_H */
-- 
1.7.4.1

