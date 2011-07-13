Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1GMIlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:25 -0400
Message-Id: <20110713084031.423163062@sipsolutions.net> (sfid-20110713_104130_175683_9CC3371F)
Date: Wed, 13 Jul 2011 10:39:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 01/11] cfg80211: split wext compatibility to separate header
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

A lot of drivers erroneously use wext constants
and don't notice since cfg80211.h includes them.
Make this more split up so drivers needing wext
compatibility from cfg80211 need to explicitly
include that from cfg80211-wext.h.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |    1 
 drivers/net/wireless/orinoco/wext.c    |    1 
 include/net/cfg80211-wext.h            |  124 +++++++++++++++++++++++++++++++++
 include/net/cfg80211.h                 |  112 -----------------------------
 net/wireless/scan.c                    |    1 
 net/wireless/wext-compat.c             |    1 
 net/wireless/wext-sme.c                |    1 
 7 files changed, 129 insertions(+), 112 deletions(-)

--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/include/net/cfg80211-wext.h	2011-07-13 09:54:23.000000000 +0200
@@ -0,0 +1,124 @@
+#ifndef __NET_CFG80211_WEXT_H
+#define __NET_CFG80211_WEXT_H
+/*
+ * 802.11 device and configuration interface -- wext handlers
+ *
+ * Copyright 2006-2010	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
+
+/*
+ * Temporary wext handlers & helper functions
+ *
+ * These are used only by drivers that aren't yet fully
+ * converted to cfg80211.
+ */
+int cfg80211_wext_giwname(struct net_device *dev,
+			  struct iw_request_info *info,
+			  char *name, char *extra);
+int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
+			  u32 *mode, char *extra);
+int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
+			  u32 *mode, char *extra);
+int cfg80211_wext_siwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  union iwreq_data *wrqu, char *extra);
+int cfg80211_wext_giwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
+int cfg80211_wext_siwmlme(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
+int cfg80211_wext_giwrange(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+int cfg80211_wext_siwgenie(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+int cfg80211_wext_siwauth(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *data, char *extra);
+int cfg80211_wext_giwauth(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *data, char *extra);
+
+int cfg80211_wext_siwfreq(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_freq *freq, char *extra);
+int cfg80211_wext_giwfreq(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_freq *freq, char *extra);
+int cfg80211_wext_siwessid(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *ssid);
+int cfg80211_wext_giwessid(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *ssid);
+int cfg80211_wext_siwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra);
+int cfg80211_wext_giwrate(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *rate, char *extra);
+
+int cfg80211_wext_siwrts(struct net_device *dev,
+			 struct iw_request_info *info,
+			 struct iw_param *rts, char *extra);
+int cfg80211_wext_giwrts(struct net_device *dev,
+			 struct iw_request_info *info,
+			 struct iw_param *rts, char *extra);
+int cfg80211_wext_siwfrag(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *frag, char *extra);
+int cfg80211_wext_giwfrag(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_param *frag, char *extra);
+int cfg80211_wext_siwretry(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *retry, char *extra);
+int cfg80211_wext_giwretry(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *retry, char *extra);
+int cfg80211_wext_siwencodeext(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *erq, char *extra);
+int cfg80211_wext_siwencode(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_point *erq, char *keybuf);
+int cfg80211_wext_giwencode(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct iw_point *erq, char *keybuf);
+int cfg80211_wext_siwtxpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *data, char *keybuf);
+int cfg80211_wext_giwtxpower(struct net_device *dev,
+			     struct iw_request_info *info,
+			     union iwreq_data *data, char *keybuf);
+struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev);
+
+int cfg80211_wext_siwpower(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *wrq, char *extra);
+int cfg80211_wext_giwpower(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_param *wrq, char *extra);
+
+int cfg80211_wext_siwap(struct net_device *dev,
+			struct iw_request_info *info,
+			struct sockaddr *ap_addr, char *extra);
+int cfg80211_wext_giwap(struct net_device *dev,
+			struct iw_request_info *info,
+			struct sockaddr *ap_addr, char *extra);
+
+int cfg80211_wext_siwpmksa(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+
+#endif /* __NET_CFG80211_WEXT_H */
--- a/include/net/cfg80211.h	2011-07-13 09:44:48.000000000 +0200
+++ b/include/net/cfg80211.h	2011-07-13 09:49:23.000000000 +0200
@@ -20,11 +20,6 @@
 #include <linux/ieee80211.h>
 #include <net/regulatory.h>
 
-/* remove once we remove the wext stuff */
-#include <net/iw_handler.h>
-#include <linux/wireless.h>
-
-
 /**
  * DOC: Introduction
  *
@@ -2368,113 +2363,6 @@ extern int freq_reg_info(struct wiphy *w
 			 const struct ieee80211_reg_rule **reg_rule);
 
 /*
- * Temporary wext handlers & helper functions
- *
- * In the future cfg80211 will simply assign the entire wext handler
- * structure to netdevs it manages, but we're not there yet.
- */
-int cfg80211_wext_giwname(struct net_device *dev,
-			  struct iw_request_info *info,
-			  char *name, char *extra);
-int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra);
-int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra);
-int cfg80211_wext_siwscan(struct net_device *dev,
-			  struct iw_request_info *info,
-			  union iwreq_data *wrqu, char *extra);
-int cfg80211_wext_giwscan(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra);
-int cfg80211_wext_siwmlme(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_point *data, char *extra);
-int cfg80211_wext_giwrange(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
-int cfg80211_wext_siwgenie(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
-int cfg80211_wext_siwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra);
-int cfg80211_wext_giwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra);
-
-int cfg80211_wext_siwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra);
-int cfg80211_wext_giwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra);
-int cfg80211_wext_siwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid);
-int cfg80211_wext_giwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid);
-int cfg80211_wext_siwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra);
-int cfg80211_wext_giwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra);
-
-int cfg80211_wext_siwrts(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra);
-int cfg80211_wext_giwrts(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra);
-int cfg80211_wext_siwfrag(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra);
-int cfg80211_wext_giwfrag(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra);
-int cfg80211_wext_siwretry(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra);
-int cfg80211_wext_giwretry(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra);
-int cfg80211_wext_siwencodeext(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *erq, char *extra);
-int cfg80211_wext_siwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf);
-int cfg80211_wext_giwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf);
-int cfg80211_wext_siwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *keybuf);
-int cfg80211_wext_giwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *keybuf);
-struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev);
-
-int cfg80211_wext_siwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra);
-int cfg80211_wext_giwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra);
-
-int cfg80211_wext_siwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra);
-int cfg80211_wext_giwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra);
-
-int cfg80211_wext_siwpmksa(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra);
-
-/*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
  */
--- a/net/wireless/scan.c	2011-07-13 09:46:42.000000000 +0200
+++ b/net/wireless/scan.c	2011-07-13 09:46:51.000000000 +0200
@@ -12,6 +12,7 @@
 #include <linux/etherdevice.h>
 #include <net/arp.h>
 #include <net/cfg80211.h>
+#include <net/cfg80211-wext.h>
 #include <net/iw_handler.h>
 #include "core.h"
 #include "nl80211.h"
--- a/net/wireless/wext-compat.c	2011-07-13 09:47:02.000000000 +0200
+++ b/net/wireless/wext-compat.c	2011-07-13 09:47:05.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <net/iw_handler.h>
 #include <net/cfg80211.h>
+#include <net/cfg80211-wext.h>
 #include "wext-compat.h"
 #include "core.h"
 
--- a/net/wireless/wext-sme.c	2011-07-13 09:47:46.000000000 +0200
+++ b/net/wireless/wext-sme.c	2011-07-13 09:47:48.000000000 +0200
@@ -9,6 +9,7 @@
 #include <linux/if_arp.h>
 #include <linux/slab.h>
 #include <net/cfg80211.h>
+#include <net/cfg80211-wext.h>
 #include "wext-compat.h"
 #include "nl80211.h"
 
--- a/drivers/net/wireless/ipw2x00/ipw2200.c	2011-07-13 09:50:04.000000000 +0200
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c	2011-07-13 09:50:26.000000000 +0200
@@ -32,6 +32,7 @@
 
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <net/cfg80211-wext.h>
 #include "ipw2200.h"
 
 
--- a/drivers/net/wireless/orinoco/wext.c	2011-07-13 09:50:04.000000000 +0200
+++ b/drivers/net/wireless/orinoco/wext.c	2011-07-13 09:50:30.000000000 +0200
@@ -9,6 +9,7 @@
 #include <linux/ieee80211.h>
 #include <net/iw_handler.h>
 #include <net/cfg80211.h>
+#include <net/cfg80211-wext.h>
 
 #include "hermes.h"
 #include "hermes_rid.h"


