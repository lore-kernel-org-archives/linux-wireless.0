Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38010 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab0IBNTX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 09:19:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] [PATCH v2] compat: backport linux/pci-aspm.h
Date: Thu,  2 Sep 2010 15:19:13 +0200
Message-Id: <1283433553-25991-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pci-aspm.h was introduced in kernel 2.6.25 and is used by the ath5k and iwlwifi driver.

v2: Do not place the empty functions into pci-aspm.h. Now we do not
have to change pci-aspm.h when it changes in the mainline kernel only
compat-2.6.26.h has to be changed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---

This should also go into stable.

 include/linux/compat-2.6.26.h |    9 +++++++++
 include/linux/pci-aspm.h      |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/pci-aspm.h

diff --git a/include/linux/compat-2.6.26.h b/include/linux/compat-2.6.26.h
index 8251177..30ee46c 100644
--- a/include/linux/compat-2.6.26.h
+++ b/include/linux/compat-2.6.26.h
@@ -394,6 +394,15 @@ struct net *dev_net(const struct net_device *dev)
 
 #endif /* xtensa */
 
+#define PCIE_LINK_STATE_L0S	1
+#define PCIE_LINK_STATE_L1	2
+#define PCIE_LINK_STATE_CLKPM	4
+
+static inline void pci_disable_link_state(struct pci_dev *pdev, int state)
+{
+}
+/* source: include/linux/pci-aspm.h */
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,26)) */
 
 #endif /* LINUX_26_26_COMPAT_H */
diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
new file mode 100644
index 0000000..2bc6efb
--- /dev/null
+++ b/include/linux/pci-aspm.h
@@ -0,0 +1,5 @@
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25))
+#include_next <linux/pci-aspm.h>
+#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,25)) */
-- 
1.7.0.4

