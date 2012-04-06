Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2DFKlN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 06:41:13 -0400
Message-ID: <1333708867.3447.1.camel@jlt3.sipsolutions.net> (sfid-20120406_124126_803834_17ED6FB3)
Subject: [PATCH] compat: properly handle tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Date: Fri, 06 Apr 2012 12:41:07 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We have to disable tracing on old kernels, but should
disable it only on old kernels. Since 2.6.33 it pretty
much hasn't changed at all, so we can keep it. Prior
to 2.6.33, there are various different reasons for not
supporting tracing, as noted in the tracepoint.h file.

This fixes tracing as the previous attempts here at
backporting it completely disabled it for all kernels,
not just for those where it's not possible.

Tested compilation of compat-wireless with tracing in
mac80211 against 2.6.24 through 3.3, but some versions
didn't compile due to unrelated issues.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/tracepoint.h |  188 +++++---------------------------------------
 1 files changed, 21 insertions(+), 167 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 23eb760..fc44692 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -3,172 +3,22 @@
 
 #include <linux/version.h>
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27))
-
+#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,32))
+/*
+ * Disable all tracing for older kernels
+ * < 2.6.27		had no tracing
+ * 2.6.27		had broken tracing
+ * 2.6.28-2.6.32	didn't have anything like DECLARE_EVENT_CLASS
+ *			and faking it would be extremely difficult
+ */
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
+/*
+ * For 2.6.28+ include the original tracepoint.h but override
+ * the defines new code uses to disable tracing completely.
+ */
 #include_next <linux/tracepoint.h>
-
-/* Backports f42c85e7 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-#undef TP_STRUCT__entry
-#define TP_STRUCT__entry(args...) args
-#endif
-
-/* Backports 091ad365, a rename */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33))
-#define DECLARE_EVENT_CLASS TRACE_EVENT_TEMPLATE
-#endif
-
-/* Backpports 2939b0469 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-#define TP_PROTO TPPROTO
-#define TP_ARGS TPARGS
-#define TP_FMT TPFMT
-#define TP_RAW_FMT TPRAWFMT
 #endif
 
-/* Force disabling tracing */
-
-#undef PARAMS
-#define PARAMS(args...) args
-
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, ...) \
-DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(...)
-#undef DEFINE_EVENT
-
-#define DEFINE_EVENT(template, name, proto, args)               \
-	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
-
-#undef DECLARE_TRACE_NOARGS
-#define DECLARE_TRACE_NOARGS(name)					\
-		__DECLARE_TRACE(name, void, , 1, void *__data, __data)
-
-
-/* Backports 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
-
-#undef DECLARE_TRACE
-#define DECLARE_TRACE(name, proto, args)				\
-		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), 1,	\
-				PARAMS(void *__data, proto),		\
-				PARAMS(__data, args))
-
-#undef DECLARE_TRACE_CONDITION
-#define DECLARE_TRACE_CONDITION(name, proto, args, cond)		\
-	__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), PARAMS(cond), \
-			PARAMS(void *__data, proto),			\
-			PARAMS(__data, args))
-
-#else
-
-#undef DECLARE_TRACE
-#define DECLARE_TRACE(name, proto, args)				\
-		__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), 1,	\
-				PARAMS(void *__data, proto),		\
-				PARAMS(__data, args))
-
-#undef DECLARE_TRACE_CONDITION
-#define DECLARE_TRACE_CONDITION(name, proto, args, cond)		\
-	__DECLARE_TRACE(name, PARAMS(proto), PARAMS(args), PARAMS(cond), \
-			PARAMS(void *__data, proto),			\
-			PARAMS(__data, args))
-#endif /* backport 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
-
-/* Backports 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
-
-/* Backports c420970ef476d7d68df119711700666224001f43 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,30))
-
-#undef __DECLARE_TRACE
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
-	static inline void trace_##name(proto)				\
-	{ }								\
-	static inline void trace_##name##_rcuidle(proto)		\
-	{ }								\
-	static inline int						\
-	register_trace_##name(void (*probe)(proto))			\
-	{								\
-		return -ENOSYS;						\
-	}								\
-	static inline void						\
-	unregister_trace_##name(void (*probe)(proto))			\
-	{								\
-	}								\
-	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
-	{								\
-	}
-#else
-
-#undef __DECLARE_TRACE
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
-	static inline void trace_##name(proto)				\
-	{ }								\
-	static inline void trace_##name##_rcuidle(proto)		\
-	{ }								\
-	static inline int						\
-	register_trace_##name(void (*probe)(proto))			\
-	{								\
-		return -ENOSYS;						\
-	}								\
-	static inline int						\
-	unregister_trace_##name(void (*probe)(proto))			\
-	{								\
-		return -ENOSYS;						\
-	}								\
-	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
-	{								\
-	}
-#endif /* backport c420970ef476d7d68df119711700666224001f43 */
-
-#else
-
-#undef __DECLARE_TRACE
-#define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
-	static inline void trace_##name(proto)				\
-	{ }								\
-	static inline void trace_##name##_rcuidle(proto)		\
-	{ }								\
-	static inline int						\
-	register_trace_##name(void (*probe)(data_proto),		\
-			      void *data)				\
-	{								\
-		return -ENOSYS;						\
-	}								\
-	static inline int						\
-	unregister_trace_##name(void (*probe)(data_proto),		\
-				void *data)				\
-	{								\
-		return -ENOSYS;						\
-	}								\
-	static inline void check_trace_callback_type_##name(void (*cb)(data_proto)) \
-	{								\
-	}
-
-#endif /* backport 38516ab59fbc5b3bb278cf5e1fe2867c70cff32e */
-
-#undef DEFINE_TRACE_FN
-#define DEFINE_TRACE_FN(name, reg, unreg)
-
-#undef DEFINE_TRACE
-#define DEFINE_TRACE(name)
-
-#undef EXPORT_TRACEPOINT_SYMBOL_GPL
-#define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
-
-#undef EXPORT_TRACEPOINT_SYMBOL
-#define EXPORT_TRACEPOINT_SYMBOL(name)
-
-#ifdef CONFIG_TRACEPOINTS
-#else /* CONFIG_TRACEPOINTS */
-#endif /* CONFIG_TRACEPOINTS */
-
-#else /* just disable tracing */
-
-/* Disable all tracing */
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
@@ -178,10 +28,14 @@ static inline void trace_ ## name(proto) {}
 #define DEFINE_EVENT(evt_class, name, proto, ...) \
 static inline void trace_ ## name(proto) {}
 
-#define TP_PROTO(args...)  args
-#define TP_ARGS(args...)   args
-#define TP_CONDITION(args...)      args
+#define TP_PROTO(args...)	args
+#define TP_ARGS(args...)	args
+#define TP_CONDITION(args...)	args
+
+#else
+/* since 2.6.33, tracing hasn't changed, so just include the kernel's file */
+#include_next <linux/tracepoint.h>
 
-#endif /* (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)) */
+#endif /* (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,32)) */
 
 #endif	/* _COMPAT_LINUX_TRACEPOINT_H */
-- 
1.7.9.1



