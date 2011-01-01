Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39212 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab1AAOX5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jan 2011 09:23:57 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/3] compat: backport pci_wake_from_d3
Date: Sat,  1 Jan 2011 15:23:33 +0100
Message-Id: <1293891815-22087-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is needed by atl1c.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c        |   22 ++++++++++++++++++++++
 include/linux/compat-2.6.28.h |    2 ++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 7a834d2..72c9e09 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -439,3 +439,25 @@ int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 }
 EXPORT_SYMBOL(n_tty_ioctl_helper);
 
+/**
+ * pci_wake_from_d3 - enable/disable device to wake up from D3_hot or D3_cold
+ * @dev: PCI device to prepare
+ * @enable: True to enable wake-up event generation; false to disable
+ *
+ * Many drivers want the device to wake up the system from D3_hot or D3_cold
+ * and this function allows them to set that up cleanly - pci_enable_wake()
+ * should not be called twice in a row to enable wake-up due to PCI PM vs ACPI
+ * ordering constraints.
+ *
+ * This function only returns error code if the device is not capable of
+ * generating PME# from both D3_hot and D3_cold, and the platform is unable to
+ * enable wake-up power for it.
+ */
+int pci_wake_from_d3(struct pci_dev *dev, bool enable)
+{
+	return pci_pme_capable(dev, PCI_D3cold) ?
+			pci_enable_wake(dev, PCI_D3cold, enable) :
+			pci_enable_wake(dev, PCI_D3hot, enable);
+}
+EXPORT_SYMBOL(pci_wake_from_d3);
+
diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 1de39ad..b9024d6 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -234,6 +234,8 @@ extern void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
 extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
+int pci_wake_from_d3(struct pci_dev *dev, bool enable);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
-- 
1.7.1

