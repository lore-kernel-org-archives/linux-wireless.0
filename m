Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932868Ab2FVNOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 09:14:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/6] mac80211: rename driver-trace file
Date: Fri, 22 Jun 2012 15:14:41 +0200
Message-Id: <1340370882-9258-6-git-send-email-johannes@sipsolutions.net> (sfid-20120622_151458_530177_94B43C66)
In-Reply-To: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
References: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This file will contain more soon, so
rename it to just trace.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/Makefile                    |    4 ++--
 net/mac80211/driver-ops.h                |    2 +-
 net/mac80211/offchannel.c                |    1 -
 net/mac80211/{driver-trace.c => trace.c} |    2 +-
 net/mac80211/{driver-trace.h => trace.h} |    2 +-
 5 files changed, 5 insertions(+), 6 deletions(-)
 rename net/mac80211/{driver-trace.c => trace.c} (88%)
 rename net/mac80211/{driver-trace.h => trace.h} (99%)

diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 2b1470b..0c140f2 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -24,7 +24,7 @@ mac80211-y := \
 	wme.o \
 	event.o \
 	chan.o \
-	driver-trace.o mlme.o
+	trace.o mlme.o
 
 mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
@@ -42,7 +42,7 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 
 mac80211-$(CONFIG_PM) += pm.o
 
-CFLAGS_driver-trace.o := -I$(src)
+CFLAGS_trace.o := -I$(src)
 
 # objects for PID algorithm
 rc80211_pid-y := rc80211_pid_algo.o
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 9330269..44e8c12 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -3,7 +3,7 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-#include "driver-trace.h"
+#include "trace.h"
 
 static inline void check_sdata_in_driver(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 7f93626..b0fb6a2 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -15,7 +15,6 @@
 #include <linux/export.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-#include "driver-trace.h"
 #include "driver-ops.h"
 
 /*
diff --git a/net/mac80211/driver-trace.c b/net/mac80211/trace.c
similarity index 88%
rename from net/mac80211/driver-trace.c
rename to net/mac80211/trace.c
index 8ed8711..943da6e 100644
--- a/net/mac80211/driver-trace.c
+++ b/net/mac80211/trace.c
@@ -5,5 +5,5 @@
 #ifndef __CHECKER__
 #include "driver-ops.h"
 #define CREATE_TRACE_POINTS
-#include "driver-trace.h"
+#include "trace.h"
 #endif
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/trace.h
similarity index 99%
rename from net/mac80211/driver-trace.h
rename to net/mac80211/trace.h
index a0f7d35..392bcc9 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/trace.h
@@ -1637,5 +1637,5 @@ TRACE_EVENT(stop_queue,
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH .
 #undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE driver-trace
+#define TRACE_INCLUDE_FILE trace
 #include <trace/define_trace.h>
-- 
1.7.10

