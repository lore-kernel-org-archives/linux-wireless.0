Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:56930 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871Ab0LQWmD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Dec 2010 17:42:03 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/3] compat: backport pci_is_pcie and pci_pcie_cap
Date: Fri, 17 Dec 2010 23:41:38 +0100
Message-Id: <1292625698-17289-3-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292625698-17289-1-git-send-email-hauke@hauke-m.de>
References: <1292625698-17289-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat_is_pcie already did the same thing as pci_is_pcie, but this
method is now in kernel so the mainline drivers should use this
function instead of accessing the  member in the struct directly. We
backported this function for older kernels.
pci_pcie_cap is used in rtlwifi so we also need this.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.24.c        |   12 ------------
 include/linux/compat-2.6.24.h |    3 ---
 include/linux/compat-2.6.33.h |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/compat/compat-2.6.24.c b/compat/compat-2.6.24.c
index a5c9c97..5e2a77d 100644
--- a/compat/compat-2.6.24.c
+++ b/compat/compat-2.6.24.c
@@ -165,15 +165,3 @@ int eth_rebuild_header(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(eth_rebuild_header);
 
-/* 2.6.24 will introduce struct pci_dev is_pcie bit. To help
- * with the compatibility code (compat.diff) being smaller, we provide a helper
- * so in cases where that will be used we can simply slap ifdefs with this
- * routine. Use compat_ prefex to not pollute namespace.  */
-int compat_is_pcie(struct pci_dev *pdev)
-{
-	int cap;
-	cap = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-	return cap ? 1 : 0;
-}
-EXPORT_SYMBOL(compat_is_pcie);
-
diff --git a/include/linux/compat-2.6.24.h b/include/linux/compat-2.6.24.h
index f9c777c..6e09530 100644
--- a/include/linux/compat-2.6.24.h
+++ b/include/linux/compat-2.6.24.h
@@ -249,9 +249,6 @@ static inline int usb_endpoint_num(const struct usb_endpoint_descriptor *epd)
 	return epd->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
 }
 
-/* Helper to make struct pci_dev is_pcie compatibility code smaller */
-int compat_is_pcie(struct pci_dev *pdev);
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)) */
 
 #endif /* LINUX_26_24_COMPAT_H */
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index c2dbc1b..2ccf141 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -6,6 +6,7 @@
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
 
 #include <linux/skbuff.h>
+#include <linux/pci.h>
 #if defined(CONFIG_PCCARD) || defined(CONFIG_PCCARD_MODULE)
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cistpl.h>
@@ -147,6 +148,37 @@ static inline void compat_kfifo_free(struct kfifo **fifo) {
 
 #define sock_recv_ts_and_drops(msg, sk, skb) sock_recv_timestamp(msg, sk, skb)
 
+/**
+ * pci_pcie_cap - get the saved PCIe capability offset
+ * @dev: PCI device
+ *
+ * PCIe capability offset is calculated at PCI device initialization
+ * time and saved in the data structure. This function returns saved
+ * PCIe capability offset. Using this instead of pci_find_capability()
+ * reduces unnecessary search in the PCI configuration space. If you
+ * need to calculate PCIe capability offset from raw device for some
+ * reasons, please use pci_find_capability() instead.
+ */
+static inline int pci_pcie_cap(struct pci_dev *dev)
+{
+	return pci_find_capability(dev, PCI_CAP_ID_EXP);
+}
+
+/**
+ * pci_is_pcie - check if the PCI device is PCI Express capable
+ * @dev: PCI device
+ *
+ * Retrun true if the PCI device is PCI Express capable, false otherwise.
+ */
+static inline bool pci_is_pcie(struct pci_dev *dev)
+{
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24))
+	return dev->is_pcie;
+#else
+	return !!pci_pcie_cap(dev);
+#endif
+}
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)) */
 
 #endif /* LINUX_26_33_COMPAT_H */
-- 
1.7.1

