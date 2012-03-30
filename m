Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab2C3KDj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 06:03:39 -0400
Message-ID: <1333101816.3908.9.camel@jlt3.sipsolutions.net> (sfid-20120330_120342_542200_B2D6AD80)
Subject: [PATCH] compat-wireless: don't hack mac80211 tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 12:03:36 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is no longer needed since Luis's tracing backport.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I'm not actually sure about this, but it seems like your tracing
backport would have addressed it?


 config.mk                                    |    4 ----
 patches/44-deactivate-mac80211-tracing.patch |   15 ---------------
 2 files changed, 0 insertions(+), 19 deletions(-)
 delete mode 100644 patches/44-deactivate-mac80211-tracing.patch

diff --git a/config.mk b/config.mk
index 965dc56..7bab4cf 100644
--- a/config.mk
+++ b/config.mk
@@ -150,10 +150,6 @@ endif #CONFIG_COMPAT_RHEL_6_0
 # Wireless subsystem stuff
 CONFIG_MAC80211=m
 
-ifndef CONFIG_COMPAT_KERNEL_2_6_33
-CONFIG_COMPAT_MAC80211_DRIVER_API_TRACER=y
-endif #CONFIG_COMPAT_KERNEL_2_6_33
-
 # CONFIG_MAC80211_DEBUGFS=y
 # CONFIG_MAC80211_NOINLINE=y
 # CONFIG_MAC80211_VERBOSE_DEBUG=y
diff --git a/patches/44-deactivate-mac80211-tracing.patch b/patches/44-deactivate-mac80211-tracing.patch
deleted file mode 100644
index bb559ab..0000000
--- a/patches/44-deactivate-mac80211-tracing.patch
+++ /dev/null
@@ -1,15 +0,0 @@
-Do not activate the mac80211 tracing for kernels <= 2.6.32
-
---- a/net/mac80211/Makefile
-+++ b/net/mac80211/Makefile
-@@ -25,7 +25,9 @@ mac80211-y := \
- 	wme.o \
- 	event.o \
- 	chan.o \
--	driver-trace.o mlme.o
-+	mlme.o
-+
-+mac80211-$(CONFIG_COMPAT_MAC80211_DRIVER_API_TRACER) += driver-trace.o
- 
- mac80211-$(CONFIG_MAC80211_LEDS) += led.o
- mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
-- 
1.7.9.1



