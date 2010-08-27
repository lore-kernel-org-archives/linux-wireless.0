Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59883 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0H0SmE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 14:42:04 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: backport linux/pci-aspm.h
Date: Fri, 27 Aug 2010 20:41:54 +0200
Message-Id: <1282934514-18160-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci-aspm.h was introduced in kernel 2.6.25 and is used by the ath5k driver.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/pci-aspm.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pci-aspm.h

diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
new file mode 100644
index 0000000..c791d00
--- /dev/null
+++ b/include/linux/pci-aspm.h
@@ -0,0 +1,55 @@
+#ifndef _COMPAT_LINUX_ASPM_H
+#define _COMPAT_LINUX_ASPM_H
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25))
+#include_next <linux/pci-aspm.h>
+#else
+
+/*
+ *	aspm.h
+ *
+ *	PCI Express ASPM defines and function prototypes
+ *
+ *	Copyright (C) 2007 Intel Corp.
+ *		Zhang Yanmin (yanmin.zhang@intel.com)
+ *		Shaohua Li (shaohua.li@intel.com)
+ *
+ *	For more information, please consult the following manuals (look at
+ *	http://www.pcisig.com/ for how to get them):
+ *
+ *	PCI Express Specification
+ */
+
+#include <linux/pci.h>
+
+#define PCIE_LINK_STATE_L0S	1
+#define PCIE_LINK_STATE_L1	2
+#define PCIE_LINK_STATE_CLKPM	4
+
+static inline void pcie_aspm_init_link_state(struct pci_dev *pdev)
+{
+}
+static inline void pcie_aspm_exit_link_state(struct pci_dev *pdev)
+{
+}
+static inline void pcie_aspm_pm_state_change(struct pci_dev *pdev)
+{
+}
+static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
+{
+}
+static inline void pcie_no_aspm(void)
+{
+}
+static inline void pcie_aspm_create_sysfs_dev_files(struct pci_dev *pdev)
+{
+}
+static inline void pcie_aspm_remove_sysfs_dev_files(struct pci_dev *pdev)
+{
+}
+
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25)) */
+
+#endif	/* _COMPAT_LINUX_ASPM_H */
-- 
1.7.0.4

