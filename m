Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34323 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1KQWWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 17:22:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v2 4/4] compat: support RHEL6 as a build target
Date: Thu, 17 Nov 2011 17:20:42 -0500
Message-Id: <1321568442-22758-4-git-send-email-linville@tuxdriver.com> (sfid-20111117_232236_652714_E22A380E)
In-Reply-To: <1321568442-22758-1-git-send-email-linville@tuxdriver.com>
References: <1321568442-22758-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables compatibility with RHEL6 as a build target, mostly
with simple tricks similar to what was added for compatibility with
Debian Squeeze.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 compat/compat-2.6.35.c        |    4 ++--
 compat/compat-2.6.37.c        |    4 ++--
 include/linux/compat-2.6.33.h |    7 +++++++
 include/linux/compat-2.6.34.h |   19 +++++++++++++++++++
 include/linux/compat-2.6.35.h |    3 +++
 include/linux/compat-2.6.36.h |    3 +++
 include/linux/compat-2.6.37.h |    6 ++++++
 7 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/compat/compat-2.6.35.c b/compat/compat-2.6.35.c
index 44a15d6..7a31a54 100644
--- a/compat/compat-2.6.35.c
+++ b/compat/compat-2.6.35.c
@@ -18,7 +18,7 @@
  * hex_to_bin() converts one hex digit to its actual value or -1 in case of bad
  * input.
  */
-int hex_to_bin(char ch)
+int compat_hex_to_bin(char ch)
 {
 	if ((ch >= '0') && (ch <= '9'))
 		return ch - '0';
@@ -27,7 +27,7 @@ int hex_to_bin(char ch)
 		return ch - 'a' + 10;
 	return -1;
 }
-EXPORT_SYMBOL(hex_to_bin);
+EXPORT_SYMBOL(compat_hex_to_bin);
 
 /**
  * noop_llseek - No Operation Performed llseek implementation
diff --git a/compat/compat-2.6.37.c b/compat/compat-2.6.37.c
index 257880e..d7259bb 100644
--- a/compat/compat-2.6.37.c
+++ b/compat/compat-2.6.37.c
@@ -345,7 +345,7 @@ EXPORT_SYMBOL(compat_led_classdev_unregister);
  *	For tight control over page level allocator and protection flags
  *	use __vmalloc() instead.
  */
-void *vzalloc(unsigned long size)
+void *compat_vzalloc(unsigned long size)
 {
 	void *buf;
 	buf = vmalloc(size);
@@ -353,6 +353,6 @@ void *vzalloc(unsigned long size)
 		memset(buf, 0, size);
 	return buf;
 }
-EXPORT_SYMBOL(vzalloc);
+EXPORT_SYMBOL(compat_vzalloc);
 
 #endif
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index e9e888a..c900a6f 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -13,6 +13,7 @@
 #include <pcmcia/ds.h>
 #endif
 #include <linux/firmware.h>
+#include <linux/input.h>
 
 #if defined(CONFIG_COMPAT_FIRMWARE_CLASS)
 #define release_firmware compat_release_firmware
@@ -49,7 +50,10 @@ static inline void compat_release_firmware(const struct firmware *fw)
 }
 #endif
 
+/* mask KEY_RFKILL as RHEL6 backports this */
+#if !defined(KEY_RFKILL)
 #define KEY_RFKILL		247	/* Key that controls all radios */
+#endif
 
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
@@ -131,6 +135,9 @@ static inline int pci_pcie_cap(struct pci_dev *dev)
 	return pci_find_capability(dev, PCI_CAP_ID_EXP);
 }
 
+/* mask pci_is_pcie as RHEL6 backports this */
+#define pci_is_pcie(a) compat_pci_is_pcie(a)
+
 /**
  * pci_is_pcie - check if the PCI device is PCI Express capable
  * @dev: PCI device
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index 562ccf7..a9c9dd1 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -46,6 +46,9 @@
 #define netdev_info(dev, format, args...)			\
 	netdev_printk(KERN_INFO, dev, format, ##args)
 
+/* mask netdev_dbg as RHEL6 backports this */
+#if !defined(netdev_dbg)
+
 #if defined(DEBUG)
 #define netdev_dbg(__dev, format, args...)			\
 	netdev_printk(KERN_DEBUG, __dev, format, ##args)
@@ -64,6 +67,11 @@ do {								\
 })
 #endif
 
+#endif
+
+/* mask netdev_vdbg as RHEL6 backports this */
+#if !defined(netdev_dbg)
+
 #if defined(VERBOSE_DEBUG)
 #define netdev_vdbg	netdev_dbg
 #else
@@ -76,6 +84,8 @@ do {								\
 })
 #endif
 
+#endif
+
 /*
  * netdev_WARN() acts like dev_printk(), but with the key difference
  * of using a WARN/WARN_ON to get the message out, including the
@@ -107,6 +117,9 @@ do {					  			\
 #define netif_info(priv, type, dev, fmt, args...)		\
 	netif_printk(priv, type, KERN_INFO, (dev), fmt, ##args)
 
+/* mask netif_dbg as RHEL6 backports this */
+#if !defined(netif_dbg)
+
 #if defined(DEBUG)
 #define netif_dbg(priv, type, dev, format, args...)		\
 	netif_printk(priv, type, KERN_DEBUG, dev, format, ##args)
@@ -127,6 +140,11 @@ do {								\
 })
 #endif
 
+#endif
+
+/* mask netif_vdbg as RHEL6 backports this */
+#if !defined(netif_vdbg)
+
 #if defined(VERBOSE_DEBUG)
 #define netif_vdbg	netdev_dbg
 #else
@@ -137,6 +155,7 @@ do {								\
 	0;							\
 })
 #endif
+#endif
 /* source: include/linux/netdevice.h */
 
 
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 857a521..5e43002 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -26,6 +26,9 @@ static inline wait_queue_head_t *sk_sleep(struct sock *sk)
 
 #define sdio_writeb_readb(func, write_byte, addr, err_ret) sdio_readb(func, addr, err_ret)
 
+/* mask hex_to_bin as RHEL6 backports this */
+#define hex_to_bin(a) compat_hex_to_bin(a)
+
 int hex_to_bin(char ch);
 
 extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 29ade27..b5d9975 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -14,6 +14,9 @@
 #define kparam_block_sysfs_write(a)
 #define kparam_unblock_sysfs_write(a)
 
+/* mask va_format as RHEL6 backports this */
+#define va_format compat_va_format
+
 struct va_format {
 	const char *fmt;
 	va_list *va;
diff --git a/include/linux/compat-2.6.37.h b/include/linux/compat-2.6.37.h
index d375746..c19e781 100644
--- a/include/linux/compat-2.6.37.h
+++ b/include/linux/compat-2.6.37.h
@@ -12,6 +12,9 @@
 
 extern struct kobj_ns_type_operations net_ns_type_operations;
 
+/* mask skb_checksum_none_assert as RHEL6 backports this */
+#define skb_checksum_none_assert(a) compat_skb_checksum_none_assert(a)
+
 /**
  * skb_checksum_none_assert - make sure skb ip_summed is CHECKSUM_NONE
  * @skb: skb to check
@@ -110,6 +113,9 @@ extern void compat_led_brightness_set(struct led_classdev *led_cdev,
 
 #define netdev_refcnt_read(a) atomic_read(&a->refcnt)
 
+/* mask vzalloc as RHEL6 backports this */
+#define vzalloc(a) compat_vzalloc(a)
+
 extern void *vzalloc(unsigned long size);
 
 #define rtnl_dereference(p)                                     \
-- 
1.7.4.4

