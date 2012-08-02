Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab2HBUPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 16:15:08 -0400
Message-ID: <1343938505.4471.31.camel@jlt3.sipsolutions.net> (sfid-20120802_221513_646318_93A4D9D8)
Subject: [PATCH] compat: handle pci suspend/resume on kernel 2.6.29
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 02 Aug 2012 22:15:05 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Before kernel 2.6.29, we use compat_pci_{suspend,resume}
and not the SIMPLE_DEV_PM_OPS, which include the code for
PCI device handling. For 2.6.30 and higher, the core PCI
code includes the device handling.

That leaves 2.6.29 as the odd one out and causes suspend
and resume to fail. Fix it by including the PCI device
handling code in the definition of SIMPLE_DEV_PM_OPS for
that kernel version.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'm not sure what the word on this is yet, it hasn't been tested, but
from the looks of it this should fix the issue with 2.6.29 and not
calling the PCI functions there in suspend/resume. Could have a stupid
bug though for all I know...

 include/linux/compat-2.6.32.h |   47 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat-2.6.32.h b/include/linux/compat-2.6.32.h
index b0c699a..0a6d0e4 100644
--- a/include/linux/compat-2.6.32.h
+++ b/include/linux/compat-2.6.32.h
@@ -116,9 +116,52 @@ typedef enum netdev_tx netdev_tx_t;
 /*
  * dev_pm_ops is only available on kernels >= 2.6.29, for
  * older kernels we rely on reverting the work to old
- * power management style stuff.
+ * power management style stuff. On 2.6.29 the pci calls
+ * weren't included yet though, so include them here.
  */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
+#if (LINUX_VERSION_CODE == KERNEL_VERSION(2,6,29))
+/*
+ * Note the lack of "static" in this definition. The code may put
+ * a "static" in front of using the define, which makes it impossible
+ * to put static here. We lose that static if it is present (it ends
+ * up being on the suspend_fn) but that doesn't really matter much
+ * unless a driver defines multiple pm_ops structs with the same name
+ * (in which case we'll need to fix it)
+ */
+#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn)		\
+int __compat_suspend_fn_ ## name(struct device *dev)		\
+{								\
+	int ret = suspend_fn(dev);				\
+	if (ret)						\
+		return ret;					\
+	if (dev->bus == &pci_bus_type) {			\
+		pci_save_state(to_pci_dev(dev));		\
+		pci_disable_device(to_pci_dev(dev));		\
+		pci_set_power_state(to_pci_dev(dev), PCI_D3hot);\
+	}							\
+	return 0;						\
+}								\
+int __compat_resume_fn_ ## name(struct device *dev)		\
+{								\
+	int ret;						\
+	if (dev->bus == &pci_bus_type) {			\
+		pci_set_power_state(to_pci_dev(dev), PCI_D0);	\
+		ret = pci_enable_device(to_pci_dev(dev));	\
+		if (ret)					\
+			return ret;				\
+		pci_restore_state(to_pci_dev(dev));		\
+	}							\
+	return resume_fn(dev);					\
+}								\
+struct dev_pm_ops name = {					\
+	.suspend = __compat_suspend_fn_ ## name,		\
+	.resume = __compat_resume_fn_ ## name,			\
+	.freeze = __compat_suspend_fn_ ## name,			\
+	.thaw = __compat_resume_fn_ ## name,			\
+	.poweroff = __compat_suspend_fn_ ## name,		\
+	.restore = __compat_resume_fn_ ## name,			\
+}
+#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,30))
 /*
  * Use this if you want to use the same suspend and resume callbacks for suspend
  * to RAM and hibernation.
-- 
1.7.10.4



