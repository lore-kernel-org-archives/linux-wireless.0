Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60575 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1KYMb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 07:31:57 -0500
Subject: [PATCH] mac80211: remove tracing config symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Nov 2011 13:31:53 +0100
Message-ID: <1322224313.4123.8.camel@jlt3.sipsolutions.net> (sfid-20111125_133201_346653_2D092B1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's little point in this config symbol, if
tracing is disabled the overhead is negligible
and if you think it's too bad you can always
turn off tracing completely.

Also remove the part where we don't have sparse
check the tracing code -- it seems that it can
now deal with it (or the code changed).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Kconfig        |   12 ------------
 net/mac80211/Makefile       |    4 ++--
 net/mac80211/driver-trace.h |   11 -----------
 3 files changed, 2 insertions(+), 25 deletions(-)

--- a/net/mac80211/Kconfig	2011-11-08 18:04:33.000000000 +0100
+++ b/net/mac80211/Kconfig	2011-11-25 13:26:00.000000000 +0100
@@ -247,15 +247,3 @@ config MAC80211_DEBUG_COUNTERS
 	  and show them in debugfs.
 
 	  If unsure, say N.
-
-config MAC80211_DRIVER_API_TRACER
-	bool "Driver API tracer"
-	depends on MAC80211_DEBUG_MENU
-	depends on EVENT_TRACING
-	help
-	  Say Y here to make mac80211 register with the ftrace
-	  framework for the driver API -- you can then see which
-	  driver methods it is calling and which API functions
-	  drivers are calling by looking at the trace.
-
-	  If unsure, say Y.
--- a/net/mac80211/Makefile	2011-11-03 13:48:28.000000000 +0100
+++ b/net/mac80211/Makefile	2011-11-25 13:26:56.000000000 +0100
@@ -24,7 +24,8 @@ mac80211-y := \
 	util.o \
 	wme.o \
 	event.o \
-	chan.o
+	chan.o \
+	driver-trace.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
@@ -41,7 +42,6 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 
 mac80211-$(CONFIG_PM) += pm.o
 
-mac80211-$(CONFIG_MAC80211_DRIVER_API_TRACER) += driver-trace.o
 CFLAGS_driver-trace.o := -I$(src)
 
 # objects for PID algorithm
--- a/net/mac80211/driver-trace.h	2011-11-25 12:29:32.000000000 +0100
+++ b/net/mac80211/driver-trace.h	2011-11-25 13:28:22.000000000 +0100
@@ -5,17 +5,6 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 
-#if !defined(CONFIG_MAC80211_DRIVER_API_TRACER) || defined(__CHECKER__)
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, ...) \
-static inline void trace_ ## name(proto) {}
-#undef DECLARE_EVENT_CLASS
-#define DECLARE_EVENT_CLASS(...)
-#undef DEFINE_EVENT
-#define DEFINE_EVENT(evt_class, name, proto, ...) \
-static inline void trace_ ## name(proto) {}
-#endif
-
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM mac80211
 


