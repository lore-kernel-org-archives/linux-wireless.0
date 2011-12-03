Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50326 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab1LCOrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Dec 2011 09:47:00 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, mcgrof@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6/6] compat-wireless deactivate mac80211 tracing for old kernels
Date: Sat,  3 Dec 2011 15:46:25 +0100
Message-Id: <1322923585-13966-6-git-send-email-hauke@hauke-m.de> (sfid-20111203_154703_760591_5838C237)
In-Reply-To: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
References: <1322923585-13966-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Activating tracing on kernel <= 2.6.32 causes build errors.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 config.mk                                    |    4 ++
 patches/44-deactivate-mac80211-tracing.patch |   44 ++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 patches/44-deactivate-mac80211-tracing.patch

diff --git a/config.mk b/config.mk
index c8256b8..f09d16d 100644
--- a/config.mk
+++ b/config.mk
@@ -162,6 +162,10 @@ endif #CONFIG_COMPAT_RHEL_6_0
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
 
+ifndef CONFIG_COMPAT_KERNEL_2_6_33
+CONFIG_MAC80211_DRIVER_API_TRACER=y
+endif #CONFIG_COMPAT_KERNEL_2_6_33
+
 # CONFIG_MAC80211_DEBUGFS=y
 # CONFIG_MAC80211_NOINLINE=y
 # CONFIG_MAC80211_VERBOSE_DEBUG=y
diff --git a/patches/44-deactivate-mac80211-tracing.patch b/patches/44-deactivate-mac80211-tracing.patch
new file mode 100644
index 0000000..feff5eb
--- /dev/null
+++ b/patches/44-deactivate-mac80211-tracing.patch
@@ -0,0 +1,44 @@
+Do not activate the mac80211 tracing by default as it does not work with 
+kernel <= 2.6.32. Compat also includes include/trace/define_trace.h over
+include/trace/events/module.h which makes this not compiling any more.
+
+--- a/net/mac80211/Makefile
++++ b/net/mac80211/Makefile
+@@ -24,8 +24,7 @@ mac80211-y := \
+ 	util.o \
+ 	wme.o \
+ 	event.o \
+-	chan.o \
+-	driver-trace.o
++	chan.o
+ 
+ mac80211-$(CONFIG_MAC80211_LEDS) += led.o
+ mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
+@@ -42,6 +41,7 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
+ 
+ mac80211-$(CONFIG_PM) += pm.o
+ 
++mac80211-$(CONFIG_MAC80211_DRIVER_API_TRACER) += driver-trace.o
+ CFLAGS_driver-trace.o := -I$(src)
+ 
+ # objects for PID algorithm
+--- a/net/mac80211/driver-trace.h
++++ b/net/mac80211/driver-trace.h
+@@ -5,6 +5,17 @@
+ #include <net/mac80211.h>
+ #include "ieee80211_i.h"
+ 
++#if !defined(CONFIG_MAC80211_DRIVER_API_TRACER) || defined(__CHECKER__)
++#undef TRACE_EVENT
++#define TRACE_EVENT(name, proto, ...) \
++static inline void trace_ ## name(proto) {}
++#undef DECLARE_EVENT_CLASS
++#define DECLARE_EVENT_CLASS(...)
++#undef DEFINE_EVENT
++#define DEFINE_EVENT(evt_class, name, proto, ...) \
++static inline void trace_ ## name(proto) {}
++#endif
++
+ #undef TRACE_SYSTEM
+ #define TRACE_SYSTEM mac80211
+ 
-- 
1.7.5.4

