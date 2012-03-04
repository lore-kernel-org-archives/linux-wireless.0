Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2CDJJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 04:09:39 -0500
Subject: [PATCH] compat-iwlwifi: properly handle mac80211 tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Mar 2012 10:09:36 +0100
Message-ID: <1330852176.4000.7.camel@jlt3.sipsolutions.net> (sfid-20120304_100947_753103_87A88461)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When tracing was disabled by default, we got build
errors when it was enabled after all because then
the driver-trace.c file was never built, fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/44-deactivate-mac80211-tracing.patch |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/patches/44-deactivate-mac80211-tracing.patch b/patches/44-deactivate-mac80211-tracing.patch
index 6445f30..9f79b89 100644
--- a/patches/44-deactivate-mac80211-tracing.patch
+++ b/patches/44-deactivate-mac80211-tracing.patch
@@ -2,14 +2,16 @@ Do not activate the mac80211 tracing by default as it does not work with
 kernel <= 2.6.32. Compat also includes include/trace/define_trace.h over
 include/trace/events/module.h which makes this not compiling any more.
 
---- a/net/mac80211/Makefile
-+++ b/net/mac80211/Makefile
-@@ -25,7 +25,7 @@ mac80211-y := \
+--- a/net/mac80211/Makefile	2012-02-24 16:39:05.000000000 +0100
++++ b/net/mac80211/Makefile	2012-03-04 10:04:01.000000000 +0100
+@@ -25,8 +25,9 @@ mac80211-y := \
  	wme.o \
  	event.o \
  	chan.o \
 -	driver-trace.o mlme.o
 +	mlme.o
  
++mac80211-$(CONFIG_MAC80211_DRIVER_API_TRACER) += driver-trace.o
  mac80211-$(CONFIG_MAC80211_LEDS) += led.o
  mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
+ 	debugfs.o \
-- 
1.7.6.3



