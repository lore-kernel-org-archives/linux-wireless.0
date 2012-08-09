Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab2HIC77 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 22:59:59 -0400
From: Andy Gospodarek <andy@greyhouse.net>
To: mcgrof@frijolero.org,
	lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Cc: Phil Perry <phil@elrepo.org>
Subject: [PATCH] compat: support RHEL6.3 as a build target
Date: Wed,  8 Aug 2012 22:58:46 -0400
Message-Id: <1344481126-15702-1-git-send-email-andy@greyhouse.net> (sfid-20120809_050004_407849_CC95E1B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows me to compile and load the latest compat modules on
RHEL6.3.  Users of compat on RHEL6 should note that you should set
CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
---
 compat/compat-2.6.38.c        |    8 ++++----
 compat/compat-3.1.c           |   22 +++++++++++-----------
 include/linux/compat-2.6.33.h |    6 ++++++
 include/linux/compat-2.6.34.h |    6 ++++++
 include/linux/compat-2.6.35.h |    5 +++++
 include/linux/compat-2.6.36.h |    2 ++
 include/linux/compat-2.6.38.h |    6 ++++++
 include/linux/compat-3.1.h    |   12 ++++++++++++
 include/linux/compat-3.2.h    |    9 +++++++++
 include/linux/compat-3.3.h    |    2 ++
 10 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/compat/compat-2.6.38.c b/compat/compat-2.6.38.c
index 0074ac6..b546194 100644
--- a/compat/compat-2.6.38.c
+++ b/compat/compat-2.6.38.c
@@ -22,14 +22,14 @@
  *
  * Initialize the EWMA parameters for a given struct ewma @avg.
  */
-void ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
+void compat_ewma_init(struct ewma *avg, unsigned long factor, unsigned long weight)
 {
 	WARN_ON(weight <= 1 || factor == 0);
 	avg->internal = 0;
 	avg->weight = weight;
 	avg->factor = factor;
 }
-EXPORT_SYMBOL_GPL(ewma_init);
+EXPORT_SYMBOL_GPL(compat_ewma_init);
 
 /**
  * ewma_add() - Exponentially weighted moving average (EWMA)
@@ -38,7 +38,7 @@ EXPORT_SYMBOL_GPL(ewma_init);
  *
  * Add a sample to the average.
  */
-struct ewma *ewma_add(struct ewma *avg, unsigned long val)
+struct ewma *compat_ewma_add(struct ewma *avg, unsigned long val)
 {
 	avg->internal = avg->internal  ?
 		(((avg->internal * (avg->weight - 1)) +
@@ -46,5 +46,5 @@ struct ewma *ewma_add(struct ewma *avg, unsigned long val)
 		(val * avg->factor);
 	return avg;
 }
-EXPORT_SYMBOL_GPL(ewma_add);
+EXPORT_SYMBOL_GPL(compat_ewma_add);
 
diff --git a/compat/compat-3.1.c b/compat/compat-3.1.c
index e81a3e7..03735f6 100644
--- a/compat/compat-3.1.c
+++ b/compat/compat-3.1.c
@@ -19,7 +19,7 @@
  * 	cpufreq: expose a cpufreq_quick_get_max routine
  */
 
-unsigned int cpufreq_quick_get_max(unsigned int cpu)
+unsigned int compat_cpufreq_quick_get_max(unsigned int cpu)
 {
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	unsigned int ret_freq = 0;
@@ -31,10 +31,10 @@ unsigned int cpufreq_quick_get_max(unsigned int cpu)
 
 	return ret_freq;
 }
-EXPORT_SYMBOL(cpufreq_quick_get_max);
+EXPORT_SYMBOL(compat_cpufreq_quick_get_max);
 
 
-static DEFINE_SPINLOCK(simple_ida_lock);
+static DEFINE_SPINLOCK(compat_simple_ida_lock);
 
 /**
  * ida_simple_get - get a new id.
@@ -48,7 +48,7 @@ static DEFINE_SPINLOCK(simple_ida_lock);
  *
  * Use ida_simple_remove() to get rid of an id.
  */
-int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
+int compat_ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask)
 {
 	int ret, id;
@@ -69,7 +69,7 @@ again:
 	if (!ida_pre_get(ida, gfp_mask))
 		return -ENOMEM;
 
-	spin_lock_irqsave(&simple_ida_lock, flags);
+	spin_lock_irqsave(&compat_simple_ida_lock, flags);
 	ret = ida_get_new_above(ida, start, &id);
 	if (!ret) {
 		if (id > max) {
@@ -79,29 +79,29 @@ again:
 			ret = id;
 		}
 	}
-	spin_unlock_irqrestore(&simple_ida_lock, flags);
+	spin_unlock_irqrestore(&compat_simple_ida_lock, flags);
 
 	if (unlikely(ret == -EAGAIN))
 		goto again;
 
 	return ret;
 }
-EXPORT_SYMBOL(ida_simple_get);
+EXPORT_SYMBOL(compat_ida_simple_get);
 
 /**
  * ida_simple_remove - remove an allocated id.
  * @ida: the (initialized) ida.
  * @id: the id returned by ida_simple_get.
  */
-void ida_simple_remove(struct ida *ida, unsigned int id)
+void compat_ida_simple_remove(struct ida *ida, unsigned int id)
 {
 	unsigned long flags;
 
 	BUG_ON((int)id < 0);
-	spin_lock_irqsave(&simple_ida_lock, flags);
+	spin_lock_irqsave(&compat_simple_ida_lock, flags);
 	ida_remove(ida, id);
-	spin_unlock_irqrestore(&simple_ida_lock, flags);
+	spin_unlock_irqrestore(&compat_simple_ida_lock, flags);
 }
-EXPORT_SYMBOL(ida_simple_remove);
+EXPORT_SYMBOL(compat_ida_simple_remove);
 /* source lib/idr.c */
 
diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 0c71af9..dcdf765 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -55,11 +55,17 @@ static inline void compat_release_firmware(const struct firmware *fw)
 #define KEY_RFKILL		247	/* Key that controls all radios */
 #endif
 
+/* mask IFF_DONT_BRIDGE as RHEL6 backports this */
+#if !defined(IFF_DONT_BRIDGE)
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
+#endif
 
+/* mask NETDEV_POST_INIT as RHEL6 backports this */
 /* this will never happen on older kernels */
+#if !defined(NETDEV_POST_INIT)
 #define NETDEV_POST_INIT 0xffff
+#endif
 
 /* mask netdev_alloc_skb_ip_align as debian squeeze also backports this */
 #define netdev_alloc_skb_ip_align(a, b) compat_netdev_alloc_skb_ip_align(a, b)
diff --git a/include/linux/compat-2.6.34.h b/include/linux/compat-2.6.34.h
index b8b48c0..6597ec1 100644
--- a/include/linux/compat-2.6.34.h
+++ b/include/linux/compat-2.6.34.h
@@ -30,8 +30,11 @@ void init_compat_mmc_pm_flags(void);
 #define netdev_mc_count(dev) ((dev)->mc_count)
 #define netdev_mc_empty(dev) (netdev_mc_count(dev) == 0)
 
+/* mask netdev_for_each_mc_addr as RHEL6 backports this */
+#if !defined(netdev_for_each_mc_addr)
 #define netdev_for_each_mc_addr(mclist, dev) \
 	for (mclist = dev->mc_list; mclist; mclist = mclist->next)
+#endif
 /* source: include/linux/netdevice.h */
 
 
@@ -235,6 +238,8 @@ do {							\
 #define sysfs_attr_init(attr) do {} while(0)
 #endif
 
+/* mask sysfs_bin_attr_init as RHEL6 backports this */
+#if !defined(sysfs_bin_attr_init)
 /**
  *	sysfs_bin_attr_init - initialize a dynamically allocated bin_attribute
  *	@attr: struct bin_attribute to initialize
@@ -246,6 +251,7 @@ do {							\
  *	added to sysfs if you don't have this.
  */
 #define sysfs_bin_attr_init(bin_attr) sysfs_attr_init(&(bin_attr)->attr)
+#endif
 
 #define usb_alloc_coherent(dev, size, mem_flags, dma) usb_buffer_alloc(dev, size, mem_flags, dma)
 #define usb_free_coherent(dev, size, addr, dma) usb_buffer_free(dev, size, addr, dma)
diff --git a/include/linux/compat-2.6.35.h b/include/linux/compat-2.6.35.h
index 5814123..d184f00 100644
--- a/include/linux/compat-2.6.35.h
+++ b/include/linux/compat-2.6.35.h
@@ -19,6 +19,8 @@
 
 #define netdev_hw_addr dev_mc_list
 
+/* mask irq_set_affinity_hint as RHEL6 backports this */
+#define irq_set_affinity_hint(a,b) compat_irq_set_affinity_hint(a,b)
 /*
  * We cannot backport this guy as the IRQ data structure
  * was modified in the kernel itself to support this. We
@@ -46,6 +48,9 @@ extern loff_t noop_llseek(struct file *file, loff_t offset, int origin);
 
 #define pm_qos_request(_qos) pm_qos_requirement(_qos)
 
+/* mask usb_pipe_endpoint as RHEL6 backports this */
+#define usb_pipe_endpoint(a,b) compat_usb_pipe_endpoint(a,b)
+
 static inline struct usb_host_endpoint *
 usb_pipe_endpoint(struct usb_device *dev, unsigned int pipe)
 {
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 56d5961..09e4b6f 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -98,6 +98,8 @@ struct pm_qos_request_list {
  * Dummy printk for disabled debugging statements to use whilst maintaining
  * gcc's format and side-effect checking.
  */
+/* mask no_printk as RHEL6 backports this */
+#define no_printk(...) compat_no_printk(...)
 static inline __attribute__ ((format (printf, 1, 2)))
 int no_printk(const char *s, ...) { return 0; }
 
diff --git a/include/linux/compat-2.6.38.h b/include/linux/compat-2.6.38.h
index 0a86468..1d72523 100644
--- a/include/linux/compat-2.6.38.h
+++ b/include/linux/compat-2.6.38.h
@@ -55,9 +55,15 @@ struct ewma {
 	unsigned long weight;
 };
 
+/* mask ewma_init as RHEL6 backports this */
+#define ewma_init(a,b,c) compat_ewma_init(a,b,c)
+
 extern void ewma_init(struct ewma *avg, unsigned long factor,
 		      unsigned long weight);
 
+/* mask ewma_add as RHEL6 backports this */
+#define ewma_add(a,b) compat_ewma_add(a,b)
+
 extern struct ewma *ewma_add(struct ewma *avg, unsigned long val);
 
 /**
diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index bf8a4ef..dfd87a3 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -30,6 +30,8 @@ static inline bool ip_is_fragment(const struct iphdr *iph)
 	return (iph->frag_off & htons(IP_MF | IP_OFFSET)) != 0;
 }
 
+/* mask __netdev_alloc_skb_ip_align as RHEL6 backports this */
+#define __netdev_alloc_skb_ip_align(a,b,c) compat__netdev_alloc_skb_ip_align(a,b,c)
 static inline struct sk_buff *__netdev_alloc_skb_ip_align(struct net_device *dev,
 							  unsigned int length, gfp_t gfp)
 {
@@ -98,10 +100,20 @@ static inline void security_sk_clone(const struct sock *sk, struct sock *newsk)
 #include <asm-generic/atomic64.h>
 #endif
 
+/* mask ida_simple_get as RHEL6 backports this */
+#define ida_simple_get(a,b,c,d) compat_ida_simple_get(a,b,c,d)
+
 int ida_simple_get(struct ida *ida, unsigned int start, unsigned int end,
 		   gfp_t gfp_mask);
+
+/* mask ida_simple_remove as RHEL6 backports this */
+#define ida_simple_remove(a,b) compat_ida_simple_remove(a,b)
+
 void ida_simple_remove(struct ida *ida, unsigned int id);
 
+/* mask cpufreq_quick_get_max as RHEL6 backports this */
+#define cpufreq_quick_get_max(a) compat_cpufreq_quick_get_max(a)
+
 unsigned int cpufreq_quick_get_max(unsigned int cpu);
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
diff --git a/include/linux/compat-3.2.h b/include/linux/compat-3.2.h
index ef27566..cde86b5 100644
--- a/include/linux/compat-3.2.h
+++ b/include/linux/compat-3.2.h
@@ -14,6 +14,9 @@
 
 #define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
 
+/* mask skb_frag_page as RHEL6 backports this */
+#define skb_frag_page(a) compat_skb_frag_page(a)
+
 /**
  * skb_frag_page - retrieve the page refered to by a paged fragment
  * @frag: the paged fragment
@@ -25,6 +28,9 @@ static inline struct page *skb_frag_page(const skb_frag_t *frag)
 	return frag->page;
 }
 
+/* mask skb_frag_dma_map as RHEL6 backports this */
+#define skb_frag_dma_map(a,b,c,d,e) compat_skb_frag_dma_map(a,b,c,d,e)
+
 /**
  * skb_frag_dma_map - maps a paged fragment via the DMA API
  * @device: the device to map the fragment to
@@ -47,6 +53,9 @@ static inline dma_addr_t skb_frag_dma_map(struct device *dev,
 
 #define ETH_P_TDLS	0x890D          /* TDLS */
 
+/* mask skb_frag_size as RHEL6 backports this */
+#define skb_frag_size(a) compat_skb_frag_size(a)
+
 static inline unsigned int skb_frag_size(const skb_frag_t *frag)
 {
 	return frag->size;
diff --git a/include/linux/compat-3.3.h b/include/linux/compat-3.3.h
index 620e661..caefdf2 100644
--- a/include/linux/compat-3.3.h
+++ b/include/linux/compat-3.3.h
@@ -10,6 +10,8 @@
 #include <linux/skbuff.h>
 #include <net/sch_generic.h>
 
+/* mask qdisc_cb_private_validate as RHEL6 backports this */ 
+#define qdisc_cb_private_validate(a,b) compat_qdisc_cb_private_validate(a,b)
 #if !((LINUX_VERSION_CODE >= KERNEL_VERSION(3,2,9) && LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)) || (LINUX_VERSION_CODE >= KERNEL_VERSION(3,0,23) && LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)))
 #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,37))
 static inline void qdisc_cb_private_validate(const struct sk_buff *skb, int sz)
-- 
1.7.1

