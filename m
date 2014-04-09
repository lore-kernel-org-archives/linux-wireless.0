Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45435 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaDIB3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 21:29:07 -0400
Received: by mail-pd0-f171.google.com with SMTP id r10so1762241pdi.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 18:29:07 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 8/8] cfg80211: remove unnecessary include clauses
Date: Wed,  9 Apr 2014 09:28:13 +0800
Message-Id: <c02aba28b27fe39da9730cd965e322054815713f.1397006688.git.gamerh2o@gmail.com> (sfid-20140409_032913_086421_21E1A53B)
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
In-Reply-To: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
References: <c0bf65125e2d1fce1a1757cd2d46ef47d4a145b9.1397006688.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/wireless/ap.c          |  5 -----
 net/wireless/chan.c        |  3 ---
 net/wireless/core.c        | 14 +-------------
 net/wireless/core.h        |  8 +++-----
 net/wireless/debugfs.c     |  1 -
 net/wireless/ethtool.c     |  3 +--
 net/wireless/ibss.c        |  5 +----
 net/wireless/mesh.c        |  4 ----
 net/wireless/mlme.c        | 10 +---------
 net/wireless/nl80211.c     | 17 +----------------
 net/wireless/radiotap.c    |  3 ---
 net/wireless/rdev-ops.h    |  3 ---
 net/wireless/reg.c         |  9 +--------
 net/wireless/scan.c        | 11 ++---------
 net/wireless/sme.c         |  9 +--------
 net/wireless/sysfs.c       |  7 -------
 net/wireless/trace.c       |  3 +--
 net/wireless/trace.h       |  2 --
 net/wireless/util.c        | 10 ++--------
 net/wireless/wext-compat.c |  8 +-------
 net/wireless/wext-compat.h |  1 -
 net/wireless/wext-sme.c    |  4 +---
 22 files changed, 17 insertions(+), 123 deletions(-)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index 3e02ade..f53cf30 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -1,11 +1,6 @@
-#include <linux/ieee80211.h>
-#include <linux/export.h>
-#include <net/cfg80211.h>
 #include "nl80211.h"
-#include "core.h"
 #include "rdev-ops.h"
 
-
 static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 			      struct net_device *dev, bool notify)
 {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 7908dc2..9407b24 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -6,9 +6,6 @@
  * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
  */
 
-#include <linux/export.h>
-#include <net/cfg80211.h>
-#include "core.h"
 #include "rdev-ops.h"
 
 void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5fc0df0..509b000 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -6,22 +6,10 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/if.h>
 #include <linux/module.h>
-#include <linux/err.h>
-#include <linux/list.h>
-#include <linux/slab.h>
-#include <linux/nl80211.h>
-#include <linux/debugfs.h>
-#include <linux/notifier.h>
-#include <linux/device.h>
 #include <linux/etherdevice.h>
-#include <linux/rtnetlink.h>
-#include <linux/sched.h>
-#include <net/genetlink.h>
-#include <net/cfg80211.h>
+
 #include "nl80211.h"
-#include "core.h"
 #include "sysfs.h"
 #include "debugfs.h"
 #include "wext-compat.h"
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5bee6cc..bfb1afd 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -3,19 +3,17 @@
  *
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  */
+
 #ifndef __NET_WIRELESS_CORE_H
 #define __NET_WIRELESS_CORE_H
-#include <linux/list.h>
-#include <linux/netdevice.h>
+
 #include <linux/rbtree.h>
-#include <linux/debugfs.h>
 #include <linux/rfkill.h>
-#include <linux/workqueue.h>
 #include <linux/rtnetlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
-#include "reg.h"
 
+#include "reg.h"
 
 #define WIPHY_IDX_INVALID	-1
 
diff --git a/net/wireless/debugfs.c b/net/wireless/debugfs.c
index 4541577..879a779 100644
--- a/net/wireless/debugfs.c
+++ b/net/wireless/debugfs.c
@@ -9,7 +9,6 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
 #include "core.h"
 #include "debugfs.h"
 
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index e37862f..7926224 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -1,6 +1,5 @@
 #include <linux/utsname.h>
-#include <net/cfg80211.h>
-#include "core.h"
+
 #include "ethtool.h"
 #include "rdev-ops.h"
 
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 407f413..9d91f78 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -6,14 +6,11 @@
 
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <net/cfg80211.h>
+
 #include "wext-compat.h"
 #include "nl80211.h"
 #include "rdev-ops.h"
 
-
 void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
 			    struct ieee80211_channel *channel)
 {
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 3ddfb7c..95c1ae2 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -1,8 +1,4 @@
-#include <linux/ieee80211.h>
-#include <linux/export.h>
-#include <net/cfg80211.h>
 #include "nl80211.h"
-#include "core.h"
 #include "rdev-ops.h"
 
 /* Default values, timeouts in ms */
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4b4ba70..48dbb3f 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -4,20 +4,12 @@
  * Copyright (c) 2009, Jouni Malinen <j@w1.fi>
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
 #include <linux/etherdevice.h>
-#include <linux/netdevice.h>
-#include <linux/nl80211.h>
-#include <linux/slab.h>
-#include <linux/wireless.h>
-#include <net/cfg80211.h>
 #include <net/iw_handler.h>
-#include "core.h"
+
 #include "nl80211.h"
 #include "rdev-ops.h"
 
-
 void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 			    const u8 *buf, size_t len)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 232d15c..3d53a91 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4,25 +4,10 @@
  * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
  */
 
-#include <linux/if.h>
-#include <linux/module.h>
-#include <linux/err.h>
-#include <linux/slab.h>
-#include <linux/list.h>
-#include <linux/if_ether.h>
-#include <linux/ieee80211.h>
-#include <linux/nl80211.h>
-#include <linux/rtnetlink.h>
-#include <linux/netlink.h>
 #include <linux/etherdevice.h>
-#include <net/net_namespace.h>
-#include <net/genetlink.h>
-#include <net/cfg80211.h>
-#include <net/sock.h>
 #include <net/inet_connection_sock.h>
-#include "core.h"
+
 #include "nl80211.h"
-#include "reg.h"
 #include "rdev-ops.h"
 
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/radiotap.c b/net/wireless/radiotap.c
index 722da61..f3e04e4 100644
--- a/net/wireless/radiotap.c
+++ b/net/wireless/radiotap.c
@@ -14,11 +14,8 @@
  * See COPYING for more details.
  */
 
-#include <linux/kernel.h>
-#include <linux/export.h>
 #include <net/cfg80211.h>
 #include <net/ieee80211_radiotap.h>
-#include <asm/unaligned.h>
 
 /* function prototypes and related defs are in include/net/cfg80211.h */
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 74d97d3..3a8bace 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1,9 +1,6 @@
 #ifndef __CFG80211_RDEV_OPS
 #define __CFG80211_RDEV_OPS
 
-#include <linux/rtnetlink.h>
-#include <net/cfg80211.h>
-#include "core.h"
 #include "trace.h"
 
 static inline int rdev_suspend(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3ebce75..e571ea6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -44,17 +44,10 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kernel.h>
-#include <linux/export.h>
-#include <linux/slab.h>
-#include <linux/list.h>
 #include <linux/ctype.h>
-#include <linux/nl80211.h>
 #include <linux/platform_device.h>
 #include <linux/moduleparam.h>
-#include <net/cfg80211.h>
-#include "core.h"
-#include "reg.h"
+
 #include "regdb.h"
 #include "nl80211.h"
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index d526d65..bd64517 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3,18 +3,11 @@
  *
  * Copyright 2008 Johannes Berg <johannes@sipsolutions.net>
  */
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/wireless.h>
-#include <linux/nl80211.h>
+
 #include <linux/etherdevice.h>
 #include <net/arp.h>
-#include <net/cfg80211.h>
 #include <net/cfg80211-wext.h>
-#include <net/iw_handler.h>
-#include "core.h"
+
 #include "nl80211.h"
 #include "wext-compat.h"
 #include "rdev-ops.h"
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 998674f..6e549ff 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -7,17 +7,10 @@
  * Copyright (C) 2009   Intel Corporation. All rights reserved.
  */
 
-#include <linux/etherdevice.h>
 #include <linux/if_arp.h>
-#include <linux/slab.h>
-#include <linux/workqueue.h>
-#include <linux/wireless.h>
-#include <linux/export.h>
 #include <net/iw_handler.h>
-#include <net/cfg80211.h>
-#include <net/rtnetlink.h>
+
 #include "nl80211.h"
-#include "reg.h"
 #include "rdev-ops.h"
 
 /*
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 9ee6bc1..43d35d9 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -8,14 +8,7 @@
  * This file is GPLv2 as found in COPYING.
  */
 
-#include <linux/device.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <linux/nl80211.h>
-#include <linux/rtnetlink.h>
-#include <net/cfg80211.h>
 #include "sysfs.h"
-#include "core.h"
 #include "rdev-ops.h"
 
 static inline struct cfg80211_registered_device *dev_to_rdev(
diff --git a/net/wireless/trace.c b/net/wireless/trace.c
index 95f997f..e9f7a99 100644
--- a/net/wireless/trace.c
+++ b/net/wireless/trace.c
@@ -1,7 +1,6 @@
-#include <linux/module.h>
-
 #ifndef __CHECKER__
 #define CREATE_TRACE_POINTS
+
 #include "trace.h"
 
 #endif
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 47b499f..cb04787 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -6,8 +6,6 @@
 
 #include <linux/tracepoint.h>
 
-#include <linux/rtnetlink.h>
-#include <net/cfg80211.h>
 #include "core.h"
 
 #define MAC_ENTRY(entry_mac) __array(u8, entry_mac, ETH_ALEN)
diff --git a/net/wireless/util.c b/net/wireless/util.c
index c5d0208..d865356 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -3,17 +3,11 @@
  *
  * Copyright 2007-2009	Johannes Berg <johannes@sipsolutions.net>
  */
-#include <linux/export.h>
-#include <linux/bitops.h>
-#include <linux/etherdevice.h>
-#include <linux/slab.h>
-#include <net/cfg80211.h>
-#include <net/ip.h>
+
 #include <net/dsfield.h>
 #include <linux/if_vlan.h>
-#include "core.h"
-#include "rdev-ops.h"
 
+#include "rdev-ops.h"
 
 struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 9984d2f..d53faa58 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -8,17 +8,11 @@
  * Copyright 2008-2009	Johannes Berg <johannes@sipsolutions.net>
  */
 
-#include <linux/export.h>
-#include <linux/wireless.h>
-#include <linux/nl80211.h>
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
-#include <linux/slab.h>
-#include <net/iw_handler.h>
-#include <net/cfg80211.h>
 #include <net/cfg80211-wext.h>
+
 #include "wext-compat.h"
-#include "core.h"
 #include "rdev-ops.h"
 
 int cfg80211_wext_giwname(struct net_device *dev,
diff --git a/net/wireless/wext-compat.h b/net/wireless/wext-compat.h
index bd6aa81..4d643f4 100644
--- a/net/wireless/wext-compat.h
+++ b/net/wireless/wext-compat.h
@@ -2,7 +2,6 @@
 #define __WEXT_COMPAT
 
 #include <net/iw_handler.h>
-#include <linux/wireless.h>
 
 int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 765e37b..0c46790 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -5,12 +5,10 @@
  * Copyright (C) 2009   Intel Corporation. All rights reserved.
  */
 
-#include <linux/export.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
-#include <linux/slab.h>
-#include <net/cfg80211.h>
 #include <net/cfg80211-wext.h>
+
 #include "wext-compat.h"
 #include "nl80211.h"
 
-- 
1.9.0

