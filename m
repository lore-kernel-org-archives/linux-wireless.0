Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39343 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab2DZSIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 5/9] compat: move compat_pci_{suspend,resume}
Date: Thu, 26 Apr 2012 20:07:50 +0200
Message-Id: <1335463674-13003-10-git-send-email-hauke@hauke-m.de> (sfid-20120426_200839_201596_3619A5F9)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.29.h |   33 -----------------------------
 include/linux/pci.h           |   47 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 33 deletions(-)
 create mode 100644 include/linux/pci.h

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index c830c7a..c70af3a 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -141,36 +141,6 @@ static inline struct net *read_pnet(struct net * const *pnet)
 
 extern int		init_dummy_netdev(struct net_device *dev);
 
-#define compat_pci_suspend(fn)						\
-	int fn##_compat(struct pci_dev *pdev, pm_message_t state) 	\
-	{								\
-		int r;							\
-									\
-		r = fn(&pdev->dev);					\
-		if (r)							\
-			return r;					\
-									\
-		pci_save_state(pdev);					\
-		pci_disable_device(pdev);				\
-		pci_set_power_state(pdev, PCI_D3hot);			\
-									\
-		return 0;						\
-	}
-
-#define compat_pci_resume(fn)						\
-	int fn##_compat(struct pci_dev *pdev)				\
-	{								\
-		int r;							\
-									\
-		pci_set_power_state(pdev, PCI_D0);			\
-		r = pci_enable_device(pdev);				\
-		if (r)							\
-			return r;					\
-		pci_restore_state(pdev);				\
-									\
-		return fn(&pdev->dev);					\
-	}
-
 #else /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 /* Kernels >= 2.6.29 follows */
@@ -185,9 +155,6 @@ static inline int ndo_do_ioctl(struct net_device *dev,
 	return -EOPNOTSUPP;
 }
 
-#define compat_pci_suspend(fn)
-#define compat_pci_resume(fn)
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
 #endif /*  LINUX_26_29_COMPAT_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
new file mode 100644
index 0000000..fe1a761
--- /dev/null
+++ b/include/linux/pci.h
@@ -0,0 +1,47 @@
+#ifndef _COMPAT_LINUX_PCI_H
+#define _COMPAT_LINUX_PCI_H
+
+#include_next <linux/pci.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29))
+
+#define compat_pci_suspend(fn)						\
+	int fn##_compat(struct pci_dev *pdev, pm_message_t state) 	\
+	{								\
+		int r;							\
+									\
+		r = fn(&pdev->dev);					\
+		if (r)							\
+			return r;					\
+									\
+		pci_save_state(pdev);					\
+		pci_disable_device(pdev);				\
+		pci_set_power_state(pdev, PCI_D3hot);			\
+									\
+		return 0;						\
+	}
+
+#define compat_pci_resume(fn)						\
+	int fn##_compat(struct pci_dev *pdev)				\
+	{								\
+		int r;							\
+									\
+		pci_set_power_state(pdev, PCI_D0);			\
+		r = pci_enable_device(pdev);				\
+		if (r)							\
+			return r;					\
+		pci_restore_state(pdev);				\
+									\
+		return fn(&pdev->dev);					\
+	}
+
+#else /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
+
+#define compat_pci_suspend(fn)
+#define compat_pci_resume(fn)
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
+
+#endif	/* _COMPAT_LINUX_PCI_H */
-- 
1.7.9.5

