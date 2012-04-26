Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:39355 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329Ab2DZSIk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 14:08:40 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC c 7/9] compat: move code from compat-3.4.h
Date: Thu, 26 Apr 2012 20:07:52 +0200
Message-Id: <1335463674-13003-12-git-send-email-hauke@hauke-m.de> (sfid-20120426_200844_839138_40D2BD45)
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat: move module_pci_driver()

compat: move skb_add_rx_frag()

compat: move COMPAT_USE_64BIT_TIME

compat: move eth_hw_addr_random

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-2.6.28.h |    3 --
 include/linux/compat-3.4.h    |   67 -----------------------------------------
 include/linux/compat.h        |   21 +++++++++++++
 include/linux/etherdevice.h   |   51 +++++++++++++++++++++++++++++++
 include/linux/pci.h           |   16 ++++++++++
 include/linux/skbuff.h        |   23 ++++++++++++++
 6 files changed, 111 insertions(+), 70 deletions(-)
 create mode 100644 include/linux/compat.h
 create mode 100644 include/linux/etherdevice.h
 create mode 100644 include/linux/skbuff.h

diff --git a/include/linux/compat-2.6.28.h b/include/linux/compat-2.6.28.h
index 3980989..662c1b6 100644
--- a/include/linux/compat-2.6.28.h
+++ b/include/linux/compat-2.6.28.h
@@ -246,9 +246,6 @@ static inline void skb_queue_splice_tail(const struct sk_buff_head *list,
 
 unsigned long round_jiffies_up(unsigned long j);
 
-extern void v2_6_28_skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
-			    int off, int size);
-
 #define wake_up_interruptible_poll(x, m)			\
 	__wake_up(x, TASK_INTERRUPTIBLE, 1, (void *) (m))
 
diff --git a/include/linux/compat-3.4.h b/include/linux/compat-3.4.h
index 1b72374..8e72f2f 100644
--- a/include/linux/compat-3.4.h
+++ b/include/linux/compat-3.4.h
@@ -8,73 +8,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
-#define skb_add_rx_frag(skb, i, page, off, size, truesize) \
-	v2_6_28_skb_add_rx_frag(skb, i, page, off, size)
-#else
-#define skb_add_rx_frag(skb, i, page, off, size, truesize) \
-	skb_add_rx_frag(skb, i, page, off, size)
-#endif
-
-#ifdef CONFIG_X86_X32_ABI
-#define COMPAT_USE_64BIT_TIME \
-	(!!(task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT))
-#else
-#define COMPAT_USE_64BIT_TIME 0
-#endif
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12))
-static inline void eth_hw_addr_random(struct net_device *dev)
-{
-#error eth_hw_addr_random() needs to be implemented for < 2.6.12
-}
-#else  /* kernels >= 2.6.12 */
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
-static inline void eth_hw_addr_random(struct net_device *dev)
-{
-	get_random_bytes(dev->dev_addr, ETH_ALEN);
-	dev->dev_addr[0] &= 0xfe;       /* clear multicast bit */
-	dev->dev_addr[0] |= 0x02;       /* set local assignment bit (IEEE802) */
-}
-#else /* kernels >= 2.6.31 */
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
-/* So this is 2.6.31..2.6.35 */
-
-/* Just have the flags present, they won't really mean anything though */
-#define NET_ADDR_PERM          0       /* address is permanent (default) */
-#define NET_ADDR_RANDOM                1       /* address is generated randomly */
-#define NET_ADDR_STOLEN                2       /* address is stolen from other device */
-
-static inline void eth_hw_addr_random(struct net_device *dev)
-{
-	random_ether_addr(dev->dev_addr);
-}
-
-#else /* 2.6.36 and on */
-static inline void eth_hw_addr_random(struct net_device *dev)
-{
-	dev_hw_addr_random(dev, dev->dev_addr);
-}
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
-
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
-#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12)) */
-
-/* source include/linux/pci.h */
-/**
- * module_pci_driver() - Helper macro for registering a PCI driver
- * @__pci_driver: pci_driver struct
- *
- * Helper macro for PCI drivers which do not do anything special in module
- * init/exit. This eliminates a lot of boilerplate. Each module may only
- * use this macro once, and calling it replaces module_init() and module_exit()
- */
-#define module_pci_driver(__pci_driver) \
-	module_driver(__pci_driver, pci_register_driver, \
-		       pci_unregister_driver)
-
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
 
 #endif /* LINUX_5_4_COMPAT_H */
diff --git a/include/linux/compat.h b/include/linux/compat.h
new file mode 100644
index 0000000..852dccd
--- /dev/null
+++ b/include/linux/compat.h
@@ -0,0 +1,21 @@
+#ifndef _COMPAT_LINUX_COMPAT_H
+#define _COMPAT_LINUX_COMPAT_H
+
+#include_next <linux/compat.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
+
+#ifdef CONFIG_X86_X32_ABI
+#define COMPAT_USE_64BIT_TIME \
+	(!!(task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT))
+#else
+#ifndef COMPAT_USE_64BIT_TIME
+#define COMPAT_USE_64BIT_TIME 0
+#endif
+#endif
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
+
+#endif	/* _COMPAT_LINUX_COMPAT_H */
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
new file mode 100644
index 0000000..5c22a6b
--- /dev/null
+++ b/include/linux/etherdevice.h
@@ -0,0 +1,51 @@
+#ifndef _COMPAT_LINUX_ETHERDEVICE_H
+#define _COMPAT_LINUX_ETHERDEVICE_H
+
+#include_next <linux/etherdevice.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12))
+static inline void eth_hw_addr_random(struct net_device *dev)
+{
+#error eth_hw_addr_random() needs to be implemented for < 2.6.12
+}
+#else  /* kernels >= 2.6.12 */
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31))
+static inline void eth_hw_addr_random(struct net_device *dev)
+{
+	get_random_bytes(dev->dev_addr, ETH_ALEN);
+	dev->dev_addr[0] &= 0xfe;       /* clear multicast bit */
+	dev->dev_addr[0] |= 0x02;       /* set local assignment bit (IEEE802) */
+}
+#else /* kernels >= 2.6.31 */
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36))
+/* So this is 2.6.31..2.6.35 */
+
+/* Just have the flags present, they won't really mean anything though */
+#define NET_ADDR_PERM          0       /* address is permanent (default) */
+#define NET_ADDR_RANDOM                1       /* address is generated randomly */
+#define NET_ADDR_STOLEN                2       /* address is stolen from other device */
+
+static inline void eth_hw_addr_random(struct net_device *dev)
+{
+	random_ether_addr(dev->dev_addr);
+}
+
+#else /* 2.6.36 and on */
+static inline void eth_hw_addr_random(struct net_device *dev)
+{
+	dev_hw_addr_random(dev, dev->dev_addr);
+}
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)) */
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12)) */
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
+
+#endif	/* _COMPAT_LINUX_ETHERDEVICE_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fe1a761..6231e5e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -44,4 +44,20 @@
 
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)) */
 
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
+
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
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
+
 #endif	/* _COMPAT_LINUX_PCI_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
new file mode 100644
index 0000000..e505f6a
--- /dev/null
+++ b/include/linux/skbuff.h
@@ -0,0 +1,23 @@
+#ifndef _COMPAT_LINUX_SKBUFF_H
+#define _COMPAT_LINUX_SKBUFF_H
+
+#include_next <linux/skbuff.h>
+
+#include <linux/version.h>
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
+
+#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28))
+#define skb_add_rx_frag(skb, i, page, off, size, truesize) \
+	v2_6_28_skb_add_rx_frag(skb, i, page, off, size)
+
+extern void v2_6_28_skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page,
+			    int off, int size);
+#else
+#define skb_add_rx_frag(skb, i, page, off, size, truesize) \
+	skb_add_rx_frag(skb, i, page, off, size)
+#endif
+
+#endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)) */
+
+#endif	/* _COMPAT_LINUX_SKBUFF_H */
-- 
1.7.9.5

