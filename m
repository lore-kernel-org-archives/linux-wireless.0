Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51575 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab2DVV7e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 17:59:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] compat: add module_pci_driver
Date: Sun, 22 Apr 2012 23:59:24 +0200
Message-Id: <1335131965-20280-1-git-send-email-hauke@hauke-m.de> (sfid-20120422_235938_801778_597DC650)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

module_pci_driver is needed to register the pci driver to the pci sub system.
---
 include/linux/compat-3.4.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/compat-3.4.h b/include/linux/compat-3.4.h
index e82e52f..1b72374 100644
--- a/include/linux/compat-3.4.h
+++ b/include/linux/compat-3.4.h
@@ -62,6 +62,19 @@ static inline void eth_hw_addr_random(struct net_device *dev)
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12)) */
 
+/* source include/linux/pci.h */
+/**
+ * module_pci_driver() - Helper macro for registering a PCI driver
+ * @__pci_driver: pci_driver struct
+ *
+ * Helper macro for PCI drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_pci_driver(__pci_driver) \
+	module_driver(__pci_driver, pci_register_driver, \
+		       pci_unregister_driver)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
 
 #endif /* LINUX_5_4_COMPAT_H */
-- 
1.7.9.5

