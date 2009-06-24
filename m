Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbZFXMKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:10:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIn-00034W-H6
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:10:12 +0200
Message-Id: <20090624120810.346741106@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:56 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 11/11] cfg80211: self-contained wext handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally! This is what you've all been waiting for!

This patch makes cfg80211 take care of wext emulation
_completely_ by itself, the driver doesn't even need
to use the handlers and create a handler struct etc.
any more, all handled by cfg80211. This means we can
also clean up mac80211's Kconfig and make it possible
to build mac80211 w/o WEXT now!

		WEXT IS DEAD.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |  103 ------------------
 net/mac80211/Kconfig       |    1 
 net/mac80211/Makefile      |    1 
 net/mac80211/ieee80211_i.h |    4 
 net/mac80211/iface.c       |    1 
 net/mac80211/scan.c        |    1 
 net/mac80211/wext.c        |   98 -----------------
 net/wireless/core.c        |    2 
 net/wireless/scan.c        |    3 
 net/wireless/wext-compat.c |  257 +++++++++++++++++++++++++--------------------
 net/wireless/wext-compat.h |   14 ++
 net/wireless/wext-sme.c    |    2 
 12 files changed, 164 insertions(+), 323 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-06-24 13:54:10.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,98 +0,0 @@
-/*
- * Copyright 2002-2005, Instant802 Networks, Inc.
- * Copyright 2005-2006, Devicescape Software, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/netdevice.h>
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/etherdevice.h>
-#include <linux/if_arp.h>
-#include <linux/wireless.h>
-#include <net/iw_handler.h>
-#include <asm/uaccess.h>
-
-#include <net/mac80211.h>
-#include "ieee80211_i.h"
-#include "led.h"
-#include "rate.h"
-#include "wpa.h"
-#include "aes_ccm.h"
-
-
-
-/* Structures to export the Wireless Handlers */
-
-static const iw_handler ieee80211_handler[] =
-{
-	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
-	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
-	(iw_handler) NULL,				/* SIOCSIWNWID */
-	(iw_handler) NULL,				/* SIOCGIWNWID */
-	(iw_handler) cfg80211_wext_siwfreq,		/* SIOCSIWFREQ */
-	(iw_handler) cfg80211_wext_giwfreq,		/* SIOCGIWFREQ */
-	(iw_handler) cfg80211_wext_siwmode,		/* SIOCSIWMODE */
-	(iw_handler) cfg80211_wext_giwmode,		/* SIOCGIWMODE */
-	(iw_handler) NULL,				/* SIOCSIWSENS */
-	(iw_handler) NULL,				/* SIOCGIWSENS */
-	(iw_handler) NULL /* not used */,		/* SIOCSIWRANGE */
-	(iw_handler) cfg80211_wext_giwrange,		/* SIOCGIWRANGE */
-	(iw_handler) NULL /* not used */,		/* SIOCSIWPRIV */
-	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
-	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
-	(iw_handler) NULL /* kernel code */,		/* SIOCGIWSTATS */
-	(iw_handler) NULL,				/* SIOCSIWSPY */
-	(iw_handler) NULL,				/* SIOCGIWSPY */
-	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
-	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
-	(iw_handler) cfg80211_wext_siwap,		/* SIOCSIWAP */
-	(iw_handler) cfg80211_wext_giwap,		/* SIOCGIWAP */
-	(iw_handler) cfg80211_wext_siwmlme,		/* SIOCSIWMLME */
-	(iw_handler) NULL,				/* SIOCGIWAPLIST */
-	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
-	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
-	(iw_handler) cfg80211_wext_siwessid,		/* SIOCSIWESSID */
-	(iw_handler) cfg80211_wext_giwessid,		/* SIOCGIWESSID */
-	(iw_handler) NULL,				/* SIOCSIWNICKN */
-	(iw_handler) NULL,				/* SIOCGIWNICKN */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) cfg80211_wext_siwrate,		/* SIOCSIWRATE */
-	(iw_handler) cfg80211_wext_giwrate,		/* SIOCGIWRATE */
-	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
-	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
-	(iw_handler) cfg80211_wext_siwfrag,		/* SIOCSIWFRAG */
-	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
-	(iw_handler) cfg80211_wext_siwtxpower,		/* SIOCSIWTXPOW */
-	(iw_handler) cfg80211_wext_giwtxpower,		/* SIOCGIWTXPOW */
-	(iw_handler) cfg80211_wext_siwretry,		/* SIOCSIWRETRY */
-	(iw_handler) cfg80211_wext_giwretry,		/* SIOCGIWRETRY */
-	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
-	(iw_handler) cfg80211_wext_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) cfg80211_wext_siwpower,		/* SIOCSIWPOWER */
-	(iw_handler) cfg80211_wext_giwpower,		/* SIOCGIWPOWER */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) cfg80211_wext_siwgenie,		/* SIOCSIWGENIE */
-	(iw_handler) NULL,				/* SIOCGIWGENIE */
-	(iw_handler) cfg80211_wext_siwauth,		/* SIOCSIWAUTH */
-	(iw_handler) cfg80211_wext_giwauth,		/* SIOCGIWAUTH */
-	(iw_handler) cfg80211_wext_siwencodeext,	/* SIOCSIWENCODEEXT */
-	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,				/* SIOCSIWPMKSA */
-	(iw_handler) NULL,				/* -- hole -- */
-};
-
-const struct iw_handler_def ieee80211_iw_handler_def =
-{
-	.num_standard	= ARRAY_SIZE(ieee80211_handler),
-	.standard	= (iw_handler *) ieee80211_handler,
-	.get_wireless_stats = cfg80211_wireless_stats,
-};
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-06-24 13:54:11.000000000 +0200
@@ -17,9 +17,9 @@
 #include "wext-compat.h"
 #include "core.h"
 
-int cfg80211_wext_giwname(struct net_device *dev,
-			  struct iw_request_info *info,
-			  char *name, char *extra)
+static int cfg80211_wext_giwname(struct net_device *dev,
+				 struct iw_request_info *info,
+				 char *name, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_supported_band *sband;
@@ -59,10 +59,10 @@ int cfg80211_wext_giwname(struct net_dev
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwname);
 
-int cfg80211_wext_siwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra)
+static int cfg80211_wext_siwmode(struct net_device *dev,
+				 struct iw_request_info *info,
+				 u32 *mode, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
@@ -110,10 +110,10 @@ int cfg80211_wext_siwmode(struct net_dev
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwmode);
 
-int cfg80211_wext_giwmode(struct net_device *dev, struct iw_request_info *info,
-			  u32 *mode, char *extra)
+static int cfg80211_wext_giwmode(struct net_device *dev,
+				 struct iw_request_info *info,
+				 u32 *mode, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -145,12 +145,11 @@ int cfg80211_wext_giwmode(struct net_dev
 	}
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwmode);
 
 
-int cfg80211_wext_giwrange(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *extra)
+static int cfg80211_wext_giwrange(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_range *range = (struct iw_range *) extra;
@@ -260,8 +259,6 @@ int cfg80211_wext_giwrange(struct net_de
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwrange);
-
 
 /**
  * cfg80211_wext_freq - get wext frequency for non-"auto"
@@ -303,9 +300,9 @@ struct ieee80211_channel *cfg80211_wext_
 	return chan;
 }
 
-int cfg80211_wext_siwrts(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra)
+static int cfg80211_wext_siwrts(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_param *rts, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -326,11 +323,10 @@ int cfg80211_wext_siwrts(struct net_devi
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwrts);
 
-int cfg80211_wext_giwrts(struct net_device *dev,
-			 struct iw_request_info *info,
-			 struct iw_param *rts, char *extra)
+static int cfg80211_wext_giwrts(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_param *rts, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -340,11 +336,10 @@ int cfg80211_wext_giwrts(struct net_devi
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwrts);
 
-int cfg80211_wext_siwfrag(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra)
+static int cfg80211_wext_siwfrag(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *frag, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -367,11 +362,10 @@ int cfg80211_wext_siwfrag(struct net_dev
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwfrag);
 
-int cfg80211_wext_giwfrag(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *frag, char *extra)
+static int cfg80211_wext_giwfrag(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *frag, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -381,11 +375,10 @@ int cfg80211_wext_giwfrag(struct net_dev
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwfrag);
 
-int cfg80211_wext_siwretry(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra)
+static int cfg80211_wext_siwretry(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *retry, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -422,11 +415,10 @@ int cfg80211_wext_siwretry(struct net_de
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwretry);
 
-int cfg80211_wext_giwretry(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *retry, char *extra)
+static int cfg80211_wext_giwretry(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *retry, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -452,7 +444,6 @@ int cfg80211_wext_giwretry(struct net_de
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwretry);
 
 static int cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev, const u8 *addr,
@@ -519,9 +510,9 @@ static int cfg80211_set_encryption(struc
 	}
 }
 
-int cfg80211_wext_siwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf)
+static int cfg80211_wext_siwencode(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct iw_point *erq, char *keybuf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -569,11 +560,10 @@ int cfg80211_wext_siwencode(struct net_d
 				       wdev->wext.default_key == -1,
 				       idx, &params);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwencode);
 
-int cfg80211_wext_siwencodeext(struct net_device *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *erq, char *extra)
+static int cfg80211_wext_siwencodeext(struct net_device *dev,
+				      struct iw_request_info *info,
+				      struct iw_point *erq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -655,7 +645,6 @@ int cfg80211_wext_siwencodeext(struct ne
 			ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
 			idx, &params);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwencodeext);
 
 struct giwencode_cookie {
 	size_t buflen;
@@ -675,9 +664,9 @@ static void giwencode_get_key_cb(void *c
 	memcpy(data->keybuf, params->key, data->buflen);
 }
 
-int cfg80211_wext_giwencode(struct net_device *dev,
-			    struct iw_request_info *info,
-			    struct iw_point *erq, char *keybuf)
+static int cfg80211_wext_giwencode(struct net_device *dev,
+				   struct iw_request_info *info,
+				   struct iw_point *erq, char *keybuf)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -718,11 +707,10 @@ int cfg80211_wext_giwencode(struct net_d
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwencode);
 
-int cfg80211_wext_siwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra)
+static int cfg80211_wext_siwfreq(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -748,11 +736,10 @@ int cfg80211_wext_siwfreq(struct net_dev
 		return 0;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwfreq);
 
-int cfg80211_wext_giwfreq(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_freq *freq, char *extra)
+static int cfg80211_wext_giwfreq(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_freq *freq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -770,11 +757,10 @@ int cfg80211_wext_giwfreq(struct net_dev
 		return 0;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwfreq);
 
-int cfg80211_wext_siwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *extra)
+static int cfg80211_wext_siwtxpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -823,11 +809,10 @@ int cfg80211_wext_siwtxpower(struct net_
 
 	return rdev->ops->set_tx_power(wdev->wiphy, type, dbm);;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwtxpower);
 
-int cfg80211_wext_giwtxpower(struct net_device *dev,
-			     struct iw_request_info *info,
-			     union iwreq_data *data, char *extra)
+static int cfg80211_wext_giwtxpower(struct net_device *dev,
+				    struct iw_request_info *info,
+				    union iwreq_data *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -853,11 +838,10 @@ int cfg80211_wext_giwtxpower(struct net_
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwtxpower);
 
-int cfg80211_wext_siwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra)
+static int cfg80211_wext_siwauth(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *data, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int ret;
@@ -889,21 +873,19 @@ int cfg80211_wext_siwauth(struct net_dev
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwauth);
 
-int cfg80211_wext_giwauth(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *data, char *extra)
+static int cfg80211_wext_giwauth(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *data, char *extra)
 {
 	/* XXX: what do we need? */
 
 	return -EOPNOTSUPP;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwauth);
 
-int cfg80211_wext_siwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra)
+static int cfg80211_wext_siwpower(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *wrq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -947,11 +929,10 @@ int cfg80211_wext_siwpower(struct net_de
 	return 0;
 
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwpower);
 
-int cfg80211_wext_giwpower(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_param *wrq, char *extra)
+static int cfg80211_wext_giwpower(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_param *wrq, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -959,7 +940,6 @@ int cfg80211_wext_giwpower(struct net_de
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwpower);
 
 static int cfg80211_wds_wext_siwap(struct net_device *dev,
 				   struct iw_request_info *info,
@@ -1004,11 +984,10 @@ static int cfg80211_wds_wext_giwap(struc
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wds_wext_giwap);
 
-int cfg80211_wext_siwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra)
+static int cfg80211_wext_siwrate(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *rate, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1018,11 +997,10 @@ int cfg80211_wext_siwrate(struct net_dev
 
 	return rdev->ops->set_bitrate(wdev->wiphy, dev, rate);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwrate);
 
-int cfg80211_wext_giwrate(struct net_device *dev,
-			  struct iw_request_info *info,
-			  struct iw_param *rate, char *extra)
+static int cfg80211_wext_giwrate(struct net_device *dev,
+				 struct iw_request_info *info,
+				 struct iw_param *rate, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1032,10 +1010,9 @@ int cfg80211_wext_giwrate(struct net_dev
 
 	return rdev->ops->get_bitrate(wdev->wiphy, dev, rate);
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwrate);
 
 /* Get wireless statistics.  Called by /proc/net/wireless and by SIOCGIWSTATS */
-struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
+static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -1102,11 +1079,10 @@ struct iw_statistics *cfg80211_wireless_
 
 	return &wstats;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wireless_stats);
 
-int cfg80211_wext_siwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra)
+static int cfg80211_wext_siwap(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct sockaddr *ap_addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1121,11 +1097,10 @@ int cfg80211_wext_siwap(struct net_devic
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwap);
 
-int cfg80211_wext_giwap(struct net_device *dev,
-			struct iw_request_info *info,
-			struct sockaddr *ap_addr, char *extra)
+static int cfg80211_wext_giwap(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct sockaddr *ap_addr, char *extra)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1140,11 +1115,10 @@ int cfg80211_wext_giwap(struct net_devic
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwap);
 
-int cfg80211_wext_siwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid)
+static int cfg80211_wext_siwessid(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1157,11 +1131,10 @@ int cfg80211_wext_siwessid(struct net_de
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwessid);
 
-int cfg80211_wext_giwessid(struct net_device *dev,
-			   struct iw_request_info *info,
-			   struct iw_point *data, char *ssid)
+static int cfg80211_wext_giwessid(struct net_device *dev,
+				  struct iw_request_info *info,
+				  struct iw_point *data, char *ssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
@@ -1174,4 +1147,68 @@ int cfg80211_wext_giwessid(struct net_de
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwessid);
+
+static const iw_handler ieee80211_handler[] = {
+	(iw_handler) NULL,				/* SIOCSIWCOMMIT */
+	(iw_handler) cfg80211_wext_giwname,		/* SIOCGIWNAME */
+	(iw_handler) NULL,				/* SIOCSIWNWID */
+	(iw_handler) NULL,				/* SIOCGIWNWID */
+	(iw_handler) cfg80211_wext_siwfreq,		/* SIOCSIWFREQ */
+	(iw_handler) cfg80211_wext_giwfreq,		/* SIOCGIWFREQ */
+	(iw_handler) cfg80211_wext_siwmode,		/* SIOCSIWMODE */
+	(iw_handler) cfg80211_wext_giwmode,		/* SIOCGIWMODE */
+	(iw_handler) NULL,				/* SIOCSIWSENS */
+	(iw_handler) NULL,				/* SIOCGIWSENS */
+	(iw_handler) NULL /* not used */,		/* SIOCSIWRANGE */
+	(iw_handler) cfg80211_wext_giwrange,		/* SIOCGIWRANGE */
+	(iw_handler) NULL /* not used */,		/* SIOCSIWPRIV */
+	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
+	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
+	(iw_handler) NULL /* kernel code */,		/* SIOCGIWSTATS */
+	(iw_handler) NULL,				/* SIOCSIWSPY */
+	(iw_handler) NULL,				/* SIOCGIWSPY */
+	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
+	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
+	(iw_handler) cfg80211_wext_siwap,		/* SIOCSIWAP */
+	(iw_handler) cfg80211_wext_giwap,		/* SIOCGIWAP */
+	(iw_handler) cfg80211_wext_siwmlme,		/* SIOCSIWMLME */
+	(iw_handler) NULL,				/* SIOCGIWAPLIST */
+	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
+	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
+	(iw_handler) cfg80211_wext_siwessid,		/* SIOCSIWESSID */
+	(iw_handler) cfg80211_wext_giwessid,		/* SIOCGIWESSID */
+	(iw_handler) NULL,				/* SIOCSIWNICKN */
+	(iw_handler) NULL,				/* SIOCGIWNICKN */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) cfg80211_wext_siwrate,		/* SIOCSIWRATE */
+	(iw_handler) cfg80211_wext_giwrate,		/* SIOCGIWRATE */
+	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
+	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
+	(iw_handler) cfg80211_wext_siwfrag,		/* SIOCSIWFRAG */
+	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
+	(iw_handler) cfg80211_wext_siwtxpower,		/* SIOCSIWTXPOW */
+	(iw_handler) cfg80211_wext_giwtxpower,		/* SIOCGIWTXPOW */
+	(iw_handler) cfg80211_wext_siwretry,		/* SIOCSIWRETRY */
+	(iw_handler) cfg80211_wext_giwretry,		/* SIOCGIWRETRY */
+	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
+	(iw_handler) cfg80211_wext_giwencode,		/* SIOCGIWENCODE */
+	(iw_handler) cfg80211_wext_siwpower,		/* SIOCSIWPOWER */
+	(iw_handler) cfg80211_wext_giwpower,		/* SIOCGIWPOWER */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) NULL,				/* -- hole -- */
+	(iw_handler) cfg80211_wext_siwgenie,		/* SIOCSIWGENIE */
+	(iw_handler) NULL,				/* SIOCGIWGENIE */
+	(iw_handler) cfg80211_wext_siwauth,		/* SIOCSIWAUTH */
+	(iw_handler) cfg80211_wext_giwauth,		/* SIOCGIWAUTH */
+	(iw_handler) cfg80211_wext_siwencodeext,	/* SIOCSIWENCODEEXT */
+	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
+	(iw_handler) NULL,				/* SIOCSIWPMKSA */
+	(iw_handler) NULL,				/* -- hole -- */
+};
+
+const struct iw_handler_def cfg80211_wext_handler = {
+	.num_standard	= ARRAY_SIZE(ieee80211_handler),
+	.standard	= (iw_handler *) ieee80211_handler,
+	.get_wireless_stats = cfg80211_wireless_stats,
+};
--- wireless-testing.orig/net/wireless/wext-compat.h	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.h	2009-06-24 13:54:11.000000000 +0200
@@ -38,8 +38,22 @@ int cfg80211_mgd_wext_siwessid(struct ne
 int cfg80211_mgd_wext_giwessid(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_point *data, char *ssid);
+int cfg80211_wext_siwgenie(struct net_device *dev,
+			   struct iw_request_info *info,
+			   struct iw_point *data, char *extra);
+int cfg80211_wext_siwmlme(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
+
+int cfg80211_wext_siwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  union iwreq_data *wrqu, char *extra);
+int cfg80211_wext_giwscan(struct net_device *dev,
+			  struct iw_request_info *info,
+			  struct iw_point *data, char *extra);
 
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
+extern const struct iw_handler_def cfg80211_wext_handler;
 #endif /* __WEXT_COMPAT */
--- wireless-testing.orig/net/mac80211/Kconfig	2009-06-24 13:54:07.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-06-24 13:54:11.000000000 +0200
@@ -6,7 +6,6 @@ config MAC80211
 	select CRYPTO_ARC4
 	select CRYPTO_AES
 	select CRC32
-	select WIRELESS_EXT
 	---help---
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
--- wireless-testing.orig/net/mac80211/Makefile	2009-06-24 13:48:25.000000000 +0200
+++ wireless-testing/net/mac80211/Makefile	2009-06-24 13:54:11.000000000 +0200
@@ -3,7 +3,6 @@ obj-$(CONFIG_MAC80211) += mac80211.o
 # mac80211 objects
 mac80211-y := \
 	main.o \
-	wext.o \
 	sta_info.o \
 	wep.o \
 	wpa.o \
--- wireless-testing.orig/net/mac80211/scan.c	2009-06-24 13:48:25.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-06-24 13:54:11.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <net/mac80211.h>
-#include <net/iw_handler.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-06-24 13:54:04.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-06-24 13:54:11.000000000 +0200
@@ -24,7 +24,6 @@
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
 #include <net/cfg80211.h>
-#include <net/iw_handler.h>
 #include <net/mac80211.h>
 #include "key.h"
 #include "sta_info.h"
@@ -935,9 +934,6 @@ void ieee80211_bss_info_change_notify(st
 void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
-/* wireless extensions */
-extern const struct iw_handler_def ieee80211_iw_handler_def;
-
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/iface.c	2009-06-24 13:53:16.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-06-24 13:54:11.000000000 +0200
@@ -694,7 +694,6 @@ static void ieee80211_if_setup(struct ne
 {
 	ether_setup(dev);
 	dev->netdev_ops = &ieee80211_dataif_ops;
-	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->destructor = free_netdev;
 }
 
--- wireless-testing.orig/net/wireless/scan.c	2009-06-24 13:54:06.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-06-24 13:54:11.000000000 +0200
@@ -14,6 +14,7 @@
 #include <net/iw_handler.h>
 #include "core.h"
 #include "nl80211.h"
+#include "wext-compat.h"
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(10 * HZ)
 
@@ -661,7 +662,6 @@ int cfg80211_wext_siwscan(struct net_dev
 	cfg80211_put_dev(rdev);
 	return err;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
 
 static void ieee80211_scan_add_ies(struct iw_request_info *info,
 				   struct cfg80211_bss *bss,
@@ -970,5 +970,4 @@ int cfg80211_wext_giwscan(struct net_dev
 	cfg80211_put_dev(rdev);
 	return res;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_giwscan);
 #endif
--- wireless-testing.orig/net/wireless/core.c	2009-06-24 13:54:07.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-06-24 13:54:11.000000000 +0200
@@ -19,6 +19,7 @@
 #include "core.h"
 #include "sysfs.h"
 #include "debugfs.h"
+#include "wext-compat.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -552,6 +553,7 @@ static int cfg80211_netdev_notifier_call
 		wdev->sme_state = CFG80211_SME_IDLE;
 		mutex_unlock(&rdev->devlist_mtx);
 #ifdef CONFIG_WIRELESS_EXT
+		dev->wireless_handlers = &cfg80211_wext_handler;
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.ps = CONFIG_CFG80211_DEFAULT_PS_VALUE;
--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:11.000000000 +0200
@@ -1500,109 +1500,6 @@ extern int freq_reg_info(struct wiphy *w
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
-/*
  * callbacks for asynchronous cfg80211 methods, notification
  * functions and BSS handling helpers
  */
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-06-24 13:54:10.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-06-24 13:54:11.000000000 +0200
@@ -278,7 +278,6 @@ int cfg80211_wext_siwgenie(struct net_de
 	/* userspace better not think we'll reconnect */
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwgenie);
 
 int cfg80211_wext_siwmlme(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -308,4 +307,3 @@ int cfg80211_wext_siwmlme(struct net_dev
 		return -EOPNOTSUPP;
 	}
 }
-EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme);

-- 

