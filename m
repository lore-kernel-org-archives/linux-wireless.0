Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39288 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757679Ab2DZSIH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:07 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 1/9] compat: move compat_system_workqueue_{create,destroy} and compat_pm_qos_power_{init,deinit}
Date: Thu, 26 Apr 2012 20:07:42 +0200
Message-Id: <1335463674-13003-2-git-send-email-hauke@hauke-m.de> (sfid-20120426_200814_456486_7CF89976)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.36.c        |    1 +
 compat/compat.h               |   66 +++++++++++++++++++++++++++++++++++++++++
 compat/main.c                 |    1 +
 compat/pm_qos_params.c        |    1 +
 include/linux/compat-2.6.25.h |   39 ------------------------
 include/linux/compat-2.6.36.h |   11 -------
 6 files changed, 69 insertions(+), 50 deletions(-)
 create mode 100644 compat/compat.h

diff --git a/compat/compat-2.6.36.c b/compat/compat-2.6.36.c
index 9190ecd..0ba57f0 100644
--- a/compat/compat-2.6.36.c
+++ b/compat/compat-2.6.36.c
@@ -10,6 +10,7 @@
 
 #include <linux/compat.h>
 #include <linux/usb.h>
+#include "compat.h"
 
 #ifdef CONFIG_COMPAT_USB_URB_THREAD_FIX
 /* Callers must hold anchor->lock */
diff --git a/compat/compat.h b/compat/compat.h
new file mode 100644
index 0000000..031ad83
--- /dev/null
+++ b/compat/compat.h
@@ -0,0 +1,66 @@
+#ifndef _COMPAT_COMPAT_H
+#define _COMPAT_COMPAT_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
+/*
+ * Backport work for QoS dependencies (kernel/pm_qos_params.c)
+ * pm-qos stuff written by mark gross mgross@linux.intel.com.
+ *
+ * ipw2100 now makes use of:
+ *
+ * pm_qos_add_requirement(),
+ * pm_qos_update_requirement() and
+ * pm_qos_remove_requirement() from it
+ *
+ * mac80211 uses the network latency to determine if to enable or not
+ * dynamic PS. mac80211 also and registers a notifier for when
+ * the latency changes. Since older kernels do no thave pm-qos stuff
+ * we just implement it completley here and register it upon cfg80211
+ * init. I haven't tested ipw2100 on 2.6.24 though.
+ *
+ * This pm-qos implementation is copied verbatim from the kernel
+ * written by mark gross mgross@linux.intel.com. You don't have
+ * to do anythinig to use pm-qos except use the same exported
+ * routines as used in newer kernels. The compat_pm_qos_power_init()
+ * defned below is used by the compat module to initialize pm-qos.
+ */
+int compat_pm_qos_power_init(void);
+int compat_pm_qos_power_deinit(void);
+
+#else
+/*
+ * Kernels >= 2.6.25 have pm-qos and its initialized as part of
+ * the bootup process
+ */
+static inline int compat_pm_qos_power_init(void)
+{
+	return 0;
+}
+
+static inline int compat_pm_qos_power_deinit(void)
+{
+	return 0;
+}
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
+
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
+
+void compat_system_workqueue_create(void);
+void compat_system_workqueue_destroy(void);
+
+#else
+
+static inline void compat_system_workqueue_create(void)
+{
+}
+
+static inline void compat_system_workqueue_destroy(void)
+{
+}
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)) */
+
+#endif	/* _COMPAT_COMPAT_H */
diff --git a/compat/main.c b/compat/main.c
index 30a4a1e..7e245ff 100644
--- a/compat/main.c
+++ b/compat/main.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include "compat.h"
 
 MODULE_AUTHOR("Luis R. Rodriguez");
 MODULE_DESCRIPTION("Kernel compatibility module");
diff --git a/compat/pm_qos_params.c b/compat/pm_qos_params.c
index 833d98c..bdf4887 100644
--- a/compat/pm_qos_params.c
+++ b/compat/pm_qos_params.c
@@ -1,4 +1,5 @@
 #include <net/compat.h>
+#include "compat.h"
 
 /* This is the backport of pm-qos params for kernels <= 2.6.25 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))
diff --git a/include/linux/compat-2.6.25.h b/include/linux/compat-2.6.25.h
index 356186d..63b0533 100644
--- a/include/linux/compat-2.6.25.h
+++ b/include/linux/compat-2.6.25.h
@@ -129,31 +129,6 @@ typedef u32 phys_addr_t;
 	const struct pci_device_id _table[] __devinitdata
 
 /*
- * Backport work for QoS dependencies (kernel/pm_qos_params.c)
- * pm-qos stuff written by mark gross mgross@linux.intel.com.
- *
- * ipw2100 now makes use of:
- *
- * pm_qos_add_requirement(),
- * pm_qos_update_requirement() and
- * pm_qos_remove_requirement() from it
- *
- * mac80211 uses the network latency to determine if to enable or not
- * dynamic PS. mac80211 also and registers a notifier for when
- * the latency changes. Since older kernels do no thave pm-qos stuff
- * we just implement it completley here and register it upon cfg80211
- * init. I haven't tested ipw2100 on 2.6.24 though.
- *
- * This pm-qos implementation is copied verbatim from the kernel
- * written by mark gross mgross@linux.intel.com. You don't have
- * to do anythinig to use pm-qos except use the same exported
- * routines as used in newer kernels. The compat_pm_qos_power_init()
- * defned below is used by the compat module to initialize pm-qos.
- */
-int compat_pm_qos_power_init(void);
-int compat_pm_qos_power_deinit(void);
-
-/*
  * 2.6.25 adds PM_EVENT_HIBERNATE as well here but
  * we don't have this on <= 2.6.23)
  */
@@ -259,20 +234,6 @@ static inline void led_classdev_unregister_suspended(struct led_classdev *lcd)
 extern int strict_strtoul(const char *, unsigned int, unsigned long *);
 extern int strict_strtol(const char *, unsigned int, long *);
 
-#else
-/*
- * Kernels >= 2.6.25 have pm-qos and its initialized as part of
- * the bootup process
- */
-static inline int compat_pm_qos_power_init(void)
-{
-	return 0;
-}
-
-static inline int compat_pm_qos_power_deinit(void)
-{
-	return 0;
-}
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25)) */
 
 #endif /* LINUX_26_25_COMPAT_H */
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 56d5961..8f6ecc4 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -156,9 +156,6 @@ extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_nrt_wq;
 
-void compat_system_workqueue_create(void);
-void compat_system_workqueue_destroy(void);
-
 int compat_schedule_work(struct work_struct *work);
 int compat_schedule_work_on(int cpu, struct work_struct *work);
 int compat_schedule_delayed_work(struct delayed_work *dwork,
@@ -186,14 +183,6 @@ extern unsigned int work_busy(struct work_struct *work);
 
 #else
 
-static inline void compat_system_workqueue_create(void)
-{
-}
-
-static inline void compat_system_workqueue_destroy(void)
-{
-}
-
 /*
  * This is not part of The 2.6.37 kernel yet but we
  * we use it to optimize the backport code we
-- 
1.7.9.5

