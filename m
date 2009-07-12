Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37601 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbZGLL0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 07:26:18 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] [compat-2.6] Update compat.diff for master-2009-07-10
Date: Sun, 12 Jul 2009 13:26:05 +0200
Message-Id: <1247397966-1374-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now compiling with kernel at least 2.6.26 to 2.6.30.
MAC80211_DRIVER_API_TRACER is only working with kernel >= 2.6.30.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 compat/compat-2.6.28.c |   53 +++++++++++++++++++++++++++++++++++++++++++
 compat/compat-2.6.28.h |   59 ++++++++++++++++++++++++++++++++++++++++++++++++
 compat/compat-2.6.30.h |    9 ++++++-
 compat/compat.diff     |   25 ++++++++++++++++++--
 4 files changed, 142 insertions(+), 4 deletions(-)

diff --git a/compat/compat-2.6.28.c b/compat/compat-2.6.28.c
index 53856d0..7abd50d 100644
--- a/compat/compat-2.6.28.c
+++ b/compat/compat-2.6.28.c
@@ -28,4 +28,57 @@ void __iomem *pci_ioremap_bar(struct pci_dev *pdev, int bar)
 }
 EXPORT_SYMBOL_GPL(pci_ioremap_bar);
 
+static unsigned long round_jiffies_common(unsigned long j, int cpu,
+		bool force_up)
+{
+	int rem;
+	unsigned long original = j;
+
+	/*
+	 * We don't want all cpus firing their timers at once hitting the
+	 * same lock or cachelines, so we skew each extra cpu with an extra
+	 * 3 jiffies. This 3 jiffies came originally from the mm/ code which
+	 * already did this.
+	 * The skew is done by adding 3*cpunr, then round, then subtract this
+	 * extra offset again.
+	 */
+	j += cpu * 3;
+
+	rem = j % HZ;
+
+	/*
+	 * If the target jiffie is just after a whole second (which can happen
+	 * due to delays of the timer irq, long irq off times etc etc) then
+	 * we should round down to the whole second, not up. Use 1/4th second
+	 * as cutoff for this rounding as an extreme upper bound for this.
+	 * But never round down if @force_up is set.
+	 */
+	if (rem < HZ/4 && !force_up) /* round down */
+		j = j - rem;
+	else /* round up */
+		j = j - rem + HZ;
+
+	/* now that we have rounded, subtract the extra skew again */
+	j -= cpu * 3;
+
+	if (j <= jiffies) /* rounding ate our timeout entirely; */
+		return original;
+	return j;
+}
+
+/**
+ * round_jiffies_up - function to round jiffies up to a full second
+ * @j: the time in (absolute) jiffies that should be rounded
+ *
+ * This is the same as round_jiffies() except that it will never
+ * round down.  This is useful for timeouts for which the exact time
+ * of firing does not matter too much, as long as they don't fire too
+ * early.
+ */
+unsigned long round_jiffies_up(unsigned long j)
+{
+	return round_jiffies_common(j, raw_smp_processor_id(), true);
+}
+EXPORT_SYMBOL_GPL(round_jiffies_up);
+
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
index cb956b7..6f7760e 100644
--- a/compat/compat-2.6.28.h
+++ b/compat/compat-2.6.28.h
@@ -92,6 +92,20 @@ static inline void __skb_queue_splice(const struct sk_buff_head *list,
 }
 
 /**
+ *	skb_queue_splice - join two skb lists, this is designed for stacks
+ *	@list: the new list to add
+ *	@head: the place to add it in the first list
+ */
+static inline void skb_queue_splice(const struct sk_buff_head *list,
+				    struct sk_buff_head *head)
+{
+	if (!skb_queue_empty(list)) {
+		__skb_queue_splice(list, (struct sk_buff *) head, head->next);
+		head->qlen += list->qlen;
+	}
+}
+
+/**
  *	skb_queue_splice_tail - join two skb lists and reinitialise the emptied list
  *	@list: the new list to add
  *	@head: the place to add it in the first list
@@ -109,6 +123,51 @@ static inline void skb_queue_splice_tail_init(struct sk_buff_head *list,
 	}
 } /* From include/linux/skbuff.h */
 
+struct module;
+struct tracepoint;
+
+struct tracepoint {
+	const char *name;		/* Tracepoint name */
+	int state;			/* State. */
+	void **funcs;
+} __attribute__((aligned(32)));		/*
+					 * Aligned on 32 bytes because it is
+					 * globally visible and gcc happily
+					 * align these on the structure size.
+					 * Keep in sync with vmlinux.lds.h.
+					 */
+
+#ifndef DECLARE_TRACE
+
+#define TP_PROTO(args...)	args
+#define TP_ARGS(args...)		args
+
+#define DECLARE_TRACE(name, proto, args)				\
+	static inline void _do_trace_##name(struct tracepoint *tp, proto) \
+	{ }								\
+	static inline void trace_##name(proto)				\
+	{ }								\
+	static inline int register_trace_##name(void (*probe)(proto))	\
+	{								\
+		return -ENOSYS;						\
+	}								\
+	static inline int unregister_trace_##name(void (*probe)(proto))	\
+	{								\
+		return -ENOSYS;						\
+	}
+
+#define DEFINE_TRACE(name)
+#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
+#define EXPORT_TRACEPOINT_SYMBOL(name)
+
+static inline void tracepoint_update_probe_range(struct tracepoint *begin,
+	struct tracepoint *end)
+{ }
+
+#endif
+
+unsigned long round_jiffies_up(unsigned long j);
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)) */
 
 #endif /* LINUX_26_28_COMPAT_H */
diff --git a/compat/compat-2.6.30.h b/compat/compat-2.6.30.h
index 112cf19..6a7c8fb 100644
--- a/compat/compat-2.6.30.h
+++ b/compat/compat-2.6.30.h
@@ -6,7 +6,14 @@
 #include <linux/compat_autoconf.h>
 
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-/* Nothing ! */
+
+#ifndef TP_PROTO
+#define TP_PROTO(args...)	TPPROTO(args)
+#endif
+#ifndef TP_ARGS
+#define TP_ARGS(args...)	TPARGS(args)
+#endif
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30)) */
 
 #endif /* LINUX_26_30_COMPAT_H */
diff --git a/compat/compat.diff b/compat/compat.diff
index 4c5c8d6..6214f4a 100644
--- a/compat/compat.diff
+++ b/compat/compat.diff
@@ -413,9 +413,9 @@
  	rtap_dev->ml_priv = priv;
  	SET_NETDEV_DEV(rtap_dev, priv->dev->dev.parent);
  
---- a/drivers/net/wireless/mac80211_hwsim.c	2009-07-08 23:32:17.001186494 -0700
-+++ b/drivers/net/wireless/mac80211_hwsim.c	2009-07-08 23:32:17.065187158 -0700
-@@ -813,16 +813,22 @@
+--- a/drivers/net/wireless/mac80211_hwsim.c
++++ b/drivers/net/wireless/mac80211_hwsim.c
+@@ -814,16 +814,22 @@ static struct device_driver mac80211_hwsim_driver = {
  	.name = "mac80211_hwsim"
  };
  
@@ -521,6 +521,25 @@
  
  
  /*
+--- a/net/mac80211/driver-trace.h
++++ b/net/mac80211/driver-trace.h
+@@ -1,7 +1,9 @@
+ #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+ #define __MAC80211_DRIVER_TRACE
+ 
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
+ #include <linux/tracepoint.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
+ #include <net/mac80211.h>
+ #include "ieee80211_i.h"
+ 
+@@ -645,4 +647,6 @@ TRACE_EVENT(drv_ampdu_action,
+ #define TRACE_INCLUDE_PATH .
+ #undef TRACE_INCLUDE_FILE
+ #define TRACE_INCLUDE_FILE driver-trace
++#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
+ #include <trace/define_trace.h>
++#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30)) */
 --- a/net/mac80211/iface.c	2009-07-08 15:46:16.452255410 -0700
 +++ b/net/mac80211/iface.c	2009-07-08 15:46:06.060257895 -0700
 @@ -643,6 +643,7 @@
-- 
1.6.2.1

