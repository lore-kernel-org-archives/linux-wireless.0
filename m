Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40788 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab2HKAaS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 20:30:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org,
	lf_driver_backport@lists.linux-foundation.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] compat: fix SIMPLE_DEV_PM_OPS() on kernel 2.6.29
Date: Sat, 11 Aug 2012 02:30:04 +0200
Message-Id: <1344645007-26757-2-git-send-email-hauke@hauke-m.de> (sfid-20120811_023023_267459_29EC29DD)
In-Reply-To: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
References: <1344645007-26757-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch reworks this commit:
commit 8e661d67b1965afcfd9d3672803e2fc37765f6ef
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Aug 2 22:15:05 2012 +0200

    compat: handle pci suspend/resume on kernel 2.6.29

The functions for pci suspend and resume are now created by
compat_pci_suspend and compat_pci_resume and then used by
SIMPLE_DEV_PM_OPS. This way attributes like static, const and so on are
forwarded in the struct dev_pm_ops define on all kernel versions.

In addition this patch adds an own SIMPLE_DEV_PM_OPS() for kernel
2.6.32 overwriting the original, because in kernel 2.6.32 const is
needed for struct dev_pm_ops in pci drivers.

This is based on work done by Johannes Berg.

CC: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.29.h |   80 +++++++++++++++++++++++++++++------------
 include/linux/compat-2.6.32.h |   44 ++++-------------------
 include/linux/compat-2.6.33.h |   13 +++++++
 3 files changed, 76 insertions(+), 61 deletions(-)

diff --git a/include/linux/compat-2.6.29.h b/include/linux/compat-2.6.29.h
index e65c229..e859a19 100644
--- a/include/linux/compat-2.6.29.h
+++ b/include/linux/compat-2.6.29.h
@@ -325,6 +325,30 @@ static inline struct net *read_pnet(struct net * const *pnet)
 
 extern int		init_dummy_netdev(struct net_device *dev);
 
+#else /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
+
+/* Kernels >= 2.6.29 follows */
+
+/* XXX: this can probably just go upstream ! */
+static inline void netdev_attach_ops(struct net_device *dev,
+		       const struct net_device_ops *ops)
+{
+	dev->netdev_ops = ops;
+}
+
+/* XXX: this can probably just go upstream! */
+static inline int ndo_do_ioctl(struct net_device *dev,
+			       struct ifreq *ifr,
+			       int cmd)
+{
+	if (dev->netdev_ops && dev->netdev_ops->ndo_do_ioctl)
+		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+	return -EOPNOTSUPP;
+}
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
 #define compat_pci_suspend(fn)						\
 	int fn##_compat(struct pci_dev *pdev, pm_message_t state) 	\
 	{								\
@@ -354,31 +378,41 @@ extern int		init_dummy_netdev(struct net_device *dev);
 									\
 		return fn(&pdev->dev);					\
 	}
+#elif LINUX_VERSION_CODE == KERNEL_VERSION(2,6,29)
+#define compat_pci_suspend(fn)						\
+	int fn##_compat(struct device *dev)			 	\
+	{								\
+		struct pci_dev *pdev = to_pci_dev(dev);			\
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
 
-#else /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
-
-/* Kernels >= 2.6.29 follows */
-
-/* XXX: this can probably just go upstream ! */
-static inline void netdev_attach_ops(struct net_device *dev,
-		       const struct net_device_ops *ops)
-{
-	dev->netdev_ops = ops;
-}
-
-/* XXX: this can probably just go upstream! */
-static inline int ndo_do_ioctl(struct net_device *dev,
-			       struct ifreq *ifr,
-			       int cmd)
-{
-	if (dev->netdev_ops && dev->netdev_ops->ndo_do_ioctl)
-		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
-	return -EOPNOTSUPP;
-}
-
+#define compat_pci_resume(fn)						\
+	int fn##_compat(struct device *dev)				\
+	{								\
+		struct pci_dev *pdev = to_pci_dev(dev);			\
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
+#else
 #define compat_pci_suspend(fn)
 #define compat_pci_resume(fn)
-
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
+#endif
 
 #endif /*  LINUX_26_29_COMPAT_H */
diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index ff57dca..f8320cf 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -128,46 +128,14 @@ typedef enum netdev_tx netdev_tx_t;
  * weren't included yet though, so include them here.
  */
 #if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,29))
-/*
- * Note the lack of "static" in this definition. The code may put
- * a "static" in front of using the define, which makes it impossible
- * to put static here. We lose that static if it is present (it ends
- * up being on the suspend_fn) but that doesn't really matter much
- * unless a driver defines multiple pm_ops structs with the same name
- * (in which case we'll need to fix it)
- */
 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn)		\
-int __compat_suspend_fn_ ## name(struct device *dev)		\
-{								\
-	int ret = suspend_fn(dev);				\
-	if (ret)						\
-		return ret;					\
-	if (dev->bus == &pci_bus_type) {			\
-		pci_save_state(to_pci_dev(dev));		\
-		pci_disable_device(to_pci_dev(dev));		\
-		pci_set_power_state(to_pci_dev(dev), PCI_D3hot);\
-	}							\
-	return 0;						\
-}								\
-int __compat_resume_fn_ ## name(struct device *dev)		\
-{								\
-	int ret;						\
-	if (dev->bus == &pci_bus_type) {			\
-		pci_set_power_state(to_pci_dev(dev), PCI_D0);	\
-		ret = pci_enable_device(to_pci_dev(dev));	\
-		if (ret)					\
-			return ret;				\
-		pci_restore_state(to_pci_dev(dev));		\
-	}							\
-	return resume_fn(dev);					\
-}								\
 struct dev_pm_ops name = {					\
-	.suspend = __compat_suspend_fn_ ## name,		\
-	.resume = __compat_resume_fn_ ## name,			\
-	.freeze = __compat_suspend_fn_ ## name,			\
-	.thaw = __compat_resume_fn_ ## name,			\
-	.poweroff = __compat_suspend_fn_ ## name,		\
-	.restore = __compat_resume_fn_ ## name,			\
+	.suspend = suspend_fn ## _compat,			\
+	.resume = resume_fn ## _compat,				\
+	.freeze = suspend_fn ## _compat,			\
+	.thaw = resume_fn ## _compat,				\
+	.poweroff = suspend_fn ## _compat,			\
+	.restore = resume_fn ## _compat,			\
 }
 #elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 /*
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index dcdf765..381146d 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -173,6 +173,19 @@ static inline long __must_check IS_ERR_OR_NULL(const void *ptr)
 	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
 }
 
+#if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,32))
+#undef SIMPLE_DEV_PM_OPS
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
+const struct dev_pm_ops name = { \
+	.suspend = suspend_fn, \
+	.resume = resume_fn, \
+	.freeze = suspend_fn, \
+	.thaw = resume_fn, \
+	.poweroff = suspend_fn, \
+	.restore = resume_fn, \
+}
+#endif /* (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,32)) */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.7.9.5

