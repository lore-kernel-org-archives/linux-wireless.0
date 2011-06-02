Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51468 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941Ab1FBQbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 12:31:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Ignacy Gawedzki <i@lri.fr>
Subject: [PATCH 2/4] compat: add device name in register_netdevice(dev)
Date: Thu,  2 Jun 2011 18:31:02 +0200
Message-Id: <1307032264-14663-3-git-send-email-hauke@hauke-m.de> (sfid-20110602_183123_202438_6230510B)
In-Reply-To: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
References: <1307032264-14663-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_alloc_name() is not called explicitly in the driver code any more,
but it is done in register_netdevice(). This causes devices getting
wrong names like "wlan%d". With this patch they get names like wlan0
again.

Add to compat-3.0-stable

CC: Ignacy Gawedzki <i@lri.fr>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.h |    1 +
 include/linux/compat-3.0.h |   31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/compat-3.0.h

diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
index 893a159..e4ca6aa 100644
--- a/include/linux/compat-2.6.h
+++ b/include/linux/compat-2.6.h
@@ -32,6 +32,7 @@
 #include <linux/compat-2.6.37.h>
 #include <linux/compat-2.6.38.h>
 #include <linux/compat-2.6.39.h>
+#include <linux/compat-3.0.h>
 #include <linux/compat-3.1.h>
 
 #endif /* LINUX_26_COMPAT_H */
diff --git a/include/linux/compat-3.0.h b/include/linux/compat-3.0.h
new file mode 100644
index 0000000..5d05093
--- /dev/null
+++ b/include/linux/compat-3.0.h
@@ -0,0 +1,31 @@
+#ifndef LINUX_3_0_COMPAT_H
+#define LINUX_3_0_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0))
+
+/*
+ * since commit 1c5cae815d19ffe02bdfda1260949ef2b1806171
+ * "net: call dev_alloc_name from register_netdevice" dev_alloc_name is
+ * called automatically. This is not implemented in older kernel
+ * versions so it will result in device wrong names.
+ */
+static inline int register_netdevice_name(struct net_device *dev)
+{
+	int err;
+
+	if (strchr(dev->name, '%')) {
+		err = dev_alloc_name(dev, dev->name);
+		if (err < 0)
+			return err;
+	}
+
+	return register_netdevice(dev);
+}
+
+#define register_netdevice(dev) register_netdevice_name(dev)
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)) */
+
+#endif /* LINUX_3_0_COMPAT_H */
-- 
1.7.4.1

