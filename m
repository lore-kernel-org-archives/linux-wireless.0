Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46752 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070AbZJBBXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 21:23:49 -0400
Date: Thu, 01 Oct 2009 20:23:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] compat-wireless: Fix the bleeding-edge version to build
 on 2.6.27
Message-ID: <4ac55601.EpUUwD1vnjBKSXDy%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When building the bleeding-edge compat-wireless for kernel 2.6.27,
several compilation errors were detected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Luis,

I checked these patches on 2.6.27 and 2.6.31, but not for the intermediate
releases.

Larry
---

Index: compat-wireless-2009-09-05/include/net/compat-2.6.28.h
===================================================================
--- compat-wireless-2009-09-05.orig/include/net/compat-2.6.28.h
+++ compat-wireless-2009-09-05/include/net/compat-2.6.28.h
@@ -149,6 +149,7 @@ static inline void skb_queue_splice_tail
 struct module;
 struct tracepoint;
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
 struct tracepoint {
 	const char *name;		/* Tracepoint name */
 	int state;			/* State. */
@@ -159,6 +160,7 @@ struct tracepoint {
 					 * align these on the structure size.
 					 * Keep in sync with vmlinux.lds.h.
 					 */
+#endif
 
 #ifndef DECLARE_TRACE
 
@@ -179,13 +181,17 @@ struct tracepoint {
 		return -ENOSYS;						\
 	}
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
 #define DEFINE_TRACE(name)
+#endif
 #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
 #define EXPORT_TRACEPOINT_SYMBOL(name)
 
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28))
 static inline void tracepoint_update_probe_range(struct tracepoint *begin,
 	struct tracepoint *end)
 { }
+#endif
 
 #endif
 
Index: compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
===================================================================
--- compat-wireless-2009-09-05.orig/net/wireless/compat-2.6.28.c
+++ compat-wireless-2009-09-05/net/wireless/compat-2.6.28.c
@@ -260,6 +260,7 @@ static unsigned long round_jiffies_commo
 	return j;
 }
 
+#if 0
 /**
  * round_jiffies_up - function to round jiffies up to a full second
  * @j: the time in (absolute) jiffies that should be rounded
@@ -274,5 +275,6 @@ unsigned long round_jiffies_up(unsigned
 	return round_jiffies_common(j, raw_smp_processor_id(), true);
 }
 EXPORT_SYMBOL_GPL(round_jiffies_up);
+#endif
 
 #endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
Index: compat-wireless-2009-09-05/net/wireless/scan.c
===================================================================
--- compat-wireless-2009-09-05.orig/net/wireless/scan.c
+++ compat-wireless-2009-09-05/net/wireless/scan.c
@@ -499,8 +499,10 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 
 	kref_init(&res->ref);
 
+#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,30))
 	/* cfg80211_bss_update() eats up res - we ensure we free it there */
 	kmemleak_ignore(res);
+#endif
 
 	res = cfg80211_bss_update(wiphy_to_dev(wiphy), res, 0);
 	if (!res)
