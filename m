Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbYDHPeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 11:34:17 -0400
Subject: [PATCH v2] mac80211: rename files
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1207654046.14253.13.camel@johannes.berg> (sfid-20080408_153246_070974_131A127E)
References: <1207654046.14253.13.camel@johannes.berg>
	 (sfid-20080408_153246_070974_131A127E)
Content-Type: text/plain
Date: Tue, 08 Apr 2008 17:34:10 +0200
Message-Id: <1207668850.4241.6.camel@johannes.berg> (sfid-20080408_163420_941389_843F8B3F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch renames all mac80211 files (except ieee80211_i.h) to get rid
of the useless ieee80211_ prefix.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Even though we have tab completion, I'm getting tired of typing that
prefix all the time. Please first run

git mv ieee80211.c main.c
git mv ieee80211_iface.c iface.c
git mv ieee80211_ioctl.c wext.c
git mv ieee80211_key.h key.h
git mv ieee80211_led.c led.c
git mv ieee80211_led.h led.h
git mv ieee80211_rate.c rate.c
git mv ieee80211_rate.h rate.h
git mv ieee80211_sta.c mlme.c

and then apply this patch.

v2: fix up iwlwifi too

 drivers/net/wireless/iwlwifi/iwl-3945-rs.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 +-
 net/mac80211/Makefile                      |   12 ++++++------
 net/mac80211/aes_ccm.c                     |    2 +-
 net/mac80211/cfg.c                         |    2 +-
 net/mac80211/debugfs.c                     |    2 +-
 net/mac80211/debugfs_key.c                 |    2 +-
 net/mac80211/debugfs_netdev.c              |    2 +-
 net/mac80211/ieee80211_i.h                 |    2 +-
 net/mac80211/led.c                         |    2 +-
 net/mac80211/main.c                        |    4 ++--
 net/mac80211/mesh_plink.c                  |    2 +-
 net/mac80211/mlme.c                        |    4 ++--
 net/mac80211/rate.c                        |    2 +-
 net/mac80211/rc80211_pid_algo.c            |    2 +-
 net/mac80211/rc80211_pid_debugfs.c         |    2 +-
 net/mac80211/rx.c                          |    2 +-
 net/mac80211/sta_info.c                    |    2 +-
 net/mac80211/sta_info.h                    |    2 +-
 net/mac80211/tkip.c                        |    2 +-
 net/mac80211/tkip.h                        |    2 +-
 net/mac80211/tx.c                          |    4 ++--
 net/mac80211/util.c                        |    2 +-
 net/mac80211/wep.h                         |    2 +-
 net/mac80211/wext.c                        |    4 ++--
 25 files changed, 34 insertions(+), 34 deletions(-)

--- everything.orig/net/mac80211/Makefile	2008-04-08 17:09:54.000000000 +0200
+++ everything/net/mac80211/Makefile	2008-04-08 17:10:03.000000000 +0200
@@ -10,14 +10,14 @@ rc-pid-m := rc80211_pid.o
 
 # mac80211 objects
 mac80211-y := \
-	ieee80211.o \
-	ieee80211_ioctl.o \
+	main.o \
+	wext.o \
 	sta_info.o \
 	wep.o \
 	wpa.o \
-	ieee80211_sta.o \
-	ieee80211_iface.o \
-	ieee80211_rate.o \
+	mlme.o \
+	iface.o \
+	rate.o \
 	michael.o \
 	tkip.o \
 	aes_ccm.o \
@@ -28,7 +28,7 @@ mac80211-y := \
 	util.o \
 	event.o
 
-mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
+mac80211-$(CONFIG_MAC80211_LEDS) += led.o
 mac80211-$(CONFIG_NET_SCHED) += wme.o
 mac80211-$(CONFIG_MAC80211_DEBUGFS) += \
 	debugfs.o \
--- everything.orig/net/mac80211/aes_ccm.c	2008-04-08 17:06:42.000000000 +0200
+++ everything/net/mac80211/aes_ccm.c	2008-04-08 17:10:03.000000000 +0200
@@ -13,7 +13,7 @@
 #include <linux/err.h>
 
 #include <net/mac80211.h>
-#include "ieee80211_key.h"
+#include "key.h"
 #include "aes_ccm.h"
 
 
--- everything.orig/net/mac80211/cfg.c	2008-04-08 17:10:01.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-04-08 17:31:32.000000000 +0200
@@ -14,7 +14,7 @@
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "cfg.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "mesh.h"
 
 static enum ieee80211_if_types
--- everything.orig/net/mac80211/debugfs.c	2008-04-08 17:09:57.000000000 +0200
+++ everything/net/mac80211/debugfs.c	2008-04-08 17:10:03.000000000 +0200
@@ -10,7 +10,7 @@
 #include <linux/debugfs.h>
 #include <linux/rtnetlink.h>
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "debugfs.h"
 
 int mac80211_open_file_generic(struct inode *inode, struct file *file)
--- everything.orig/net/mac80211/debugfs_key.c	2008-04-08 17:10:01.000000000 +0200
+++ everything/net/mac80211/debugfs_key.c	2008-04-08 17:10:03.000000000 +0200
@@ -10,7 +10,7 @@
 
 #include <linux/kobject.h>
 #include "ieee80211_i.h"
-#include "ieee80211_key.h"
+#include "key.h"
 #include "debugfs.h"
 #include "debugfs_key.h"
 
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-04-08 17:09:57.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-04-08 17:10:03.000000000 +0200
@@ -17,7 +17,7 @@
 #include <net/mac80211.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "debugfs.h"
 #include "debugfs_netdev.h"
 
--- everything.orig/net/mac80211/ieee80211_i.h	2008-04-08 17:10:01.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-04-08 17:10:03.000000000 +0200
@@ -23,7 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
 #include <net/wireless.h>
-#include "ieee80211_key.h"
+#include "key.h"
 #include "sta_info.h"
 
 /* ieee80211.o internal definitions, etc. These are not included into
--- everything.orig/net/mac80211/led.c	2008-04-08 17:10:02.000000000 +0200
+++ everything/net/mac80211/led.c	2008-04-08 17:10:03.000000000 +0200
@@ -8,7 +8,7 @@
 
 /* just for IFNAMSIZ */
 #include <linux/if.h>
-#include "ieee80211_led.h"
+#include "led.h"
 
 void ieee80211_led_rx(struct ieee80211_local *local)
 {
--- everything.orig/net/mac80211/main.c	2008-04-08 17:10:02.000000000 +0200
+++ everything/net/mac80211/main.c	2008-04-08 17:31:33.000000000 +0200
@@ -25,12 +25,12 @@
 #include <net/cfg80211.h>
 
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "mesh.h"
 #include "wep.h"
 #include "wme.h"
 #include "aes_ccm.h"
-#include "ieee80211_led.h"
+#include "led.h"
 #include "cfg.h"
 #include "debugfs.h"
 #include "debugfs_netdev.h"
--- everything.orig/net/mac80211/mesh_plink.c	2008-04-08 17:09:55.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-04-08 17:31:32.000000000 +0200
@@ -9,7 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/random.h>
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "mesh.h"
 
 #ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
--- everything.orig/net/mac80211/mlme.c	2008-04-08 17:10:02.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-04-08 17:31:32.000000000 +0200
@@ -31,8 +31,8 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
-#include "ieee80211_led.h"
+#include "rate.h"
+#include "led.h"
 #include "mesh.h"
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
--- everything.orig/net/mac80211/rate.c	2008-04-08 17:10:02.000000000 +0200
+++ everything/net/mac80211/rate.c	2008-04-08 17:10:03.000000000 +0200
@@ -10,7 +10,7 @@
 
 #include <linux/kernel.h>
 #include <linux/rtnetlink.h>
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "ieee80211_i.h"
 
 struct rate_control_alg {
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-04-08 17:06:41.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-04-08 17:10:03.000000000 +0200
@@ -14,7 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/debugfs.h>
 #include <net/mac80211.h>
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "mesh.h"
 #include "rc80211_pid.h"
 
--- everything.orig/net/mac80211/rc80211_pid_debugfs.c	2008-04-08 17:06:44.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_debugfs.c	2008-04-08 17:10:03.000000000 +0200
@@ -13,7 +13,7 @@
 #include <linux/skbuff.h>
 
 #include <net/mac80211.h>
-#include "ieee80211_rate.h"
+#include "rate.h"
 
 #include "rc80211_pid.h"
 
--- everything.orig/net/mac80211/rx.c	2008-04-08 17:06:42.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-04-08 17:31:32.000000000 +0200
@@ -19,7 +19,7 @@
 #include <net/ieee80211_radiotap.h>
 
 #include "ieee80211_i.h"
-#include "ieee80211_led.h"
+#include "led.h"
 #include "mesh.h"
 #include "wep.h"
 #include "wpa.h"
--- everything.orig/net/mac80211/sta_info.c	2008-04-08 17:10:01.000000000 +0200
+++ everything/net/mac80211/sta_info.c	2008-04-08 17:31:33.000000000 +0200
@@ -19,7 +19,7 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "sta_info.h"
 #include "debugfs_sta.h"
 #include "mesh.h"
--- everything.orig/net/mac80211/sta_info.h	2008-04-08 17:10:01.000000000 +0200
+++ everything/net/mac80211/sta_info.h	2008-04-08 17:31:32.000000000 +0200
@@ -12,7 +12,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
-#include "ieee80211_key.h"
+#include "key.h"
 
 /**
  * enum ieee80211_sta_info_flags - Stations flags
--- everything.orig/net/mac80211/tkip.c	2008-04-08 17:06:42.000000000 +0200
+++ everything/net/mac80211/tkip.c	2008-04-08 17:10:03.000000000 +0200
@@ -12,7 +12,7 @@
 #include <linux/netdevice.h>
 
 #include <net/mac80211.h>
-#include "ieee80211_key.h"
+#include "key.h"
 #include "tkip.h"
 #include "wep.h"
 
--- everything.orig/net/mac80211/tkip.h	2008-04-08 17:06:41.000000000 +0200
+++ everything/net/mac80211/tkip.h	2008-04-08 17:10:03.000000000 +0200
@@ -11,7 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/crypto.h>
-#include "ieee80211_key.h"
+#include "key.h"
 
 u8 * ieee80211_tkip_add_iv(u8 *pos, struct ieee80211_key *key,
 			   u8 iv0, u8 iv1, u8 iv2);
--- everything.orig/net/mac80211/tx.c	2008-04-08 17:06:42.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-04-08 17:31:32.000000000 +0200
@@ -25,12 +25,12 @@
 #include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
-#include "ieee80211_led.h"
+#include "led.h"
 #include "mesh.h"
 #include "wep.h"
 #include "wpa.h"
 #include "wme.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 
 #define IEEE80211_TX_OK		0
 #define IEEE80211_TX_AGAIN	1
--- everything.orig/net/mac80211/util.c	2008-04-08 17:06:41.000000000 +0200
+++ everything/net/mac80211/util.c	2008-04-08 17:10:03.000000000 +0200
@@ -25,7 +25,7 @@
 #include <net/rtnetlink.h>
 
 #include "ieee80211_i.h"
-#include "ieee80211_rate.h"
+#include "rate.h"
 #include "mesh.h"
 #include "wme.h"
 
--- everything.orig/net/mac80211/wep.h	2008-04-08 17:06:42.000000000 +0200
+++ everything/net/mac80211/wep.h	2008-04-08 17:10:03.000000000 +0200
@@ -14,7 +14,7 @@
 #include <linux/skbuff.h>
 #include <linux/types.h>
 #include "ieee80211_i.h"
-#include "ieee80211_key.h"
+#include "key.h"
 
 int ieee80211_wep_init(struct ieee80211_local *local);
 void ieee80211_wep_free(struct ieee80211_local *local);
--- everything.orig/net/mac80211/wext.c	2008-04-08 17:10:02.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-04-08 17:10:03.000000000 +0200
@@ -21,8 +21,8 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
-#include "ieee80211_led.h"
-#include "ieee80211_rate.h"
+#include "led.h"
+#include "rate.h"
 #include "wpa.h"
 #include "aes_ccm.h"
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-04-08 17:31:38.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945-rs.c	2008-04-08 17:31:44.000000000 +0200
@@ -37,7 +37,7 @@
 
 #include <linux/workqueue.h>
 
-#include "../net/mac80211/ieee80211_rate.h"
+#include "../net/mac80211/rate.h"
 
 #include "iwl-3945.h"
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-04-08 17:31:47.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-rs.c	2008-04-08 17:31:53.000000000 +0200
@@ -36,7 +36,7 @@
 
 #include <linux/workqueue.h>
 
-#include "../net/mac80211/ieee80211_rate.h"
+#include "../net/mac80211/rate.h"
 
 #include "iwl-4965.h"
 #include "iwl-core.h"


