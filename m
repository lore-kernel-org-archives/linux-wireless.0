Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34626 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbZG0KDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 06:03:37 -0400
Message-Id: <20090727100244.154781962@sipsolutions.net>
References: <20090727100149.839649874@sipsolutions.net>
Date: Mon, 27 Jul 2009 12:01:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/4] cfg80211: self-contained wext handling where possible
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally! This is what you've all been waiting for!

This patch makes cfg80211 take care of wext emulation
_completely_ by itself, drivers that don't need things
cfg80211 doesn't do yet don't even need to be aware of
wireless extensions.
This means we can also clean up mac80211's and iwm's
Kconfig and make it possible to build them w/o wext
now!

		RIP wext.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    1 
 drivers/net/wireless/iwmc3200wifi/Makefile |    2 
 drivers/net/wireless/iwmc3200wifi/iwm.h    |    2 
 drivers/net/wireless/iwmc3200wifi/netdev.c |    1 
 drivers/net/wireless/iwmc3200wifi/wext.c   |   95 ----------------------------
 net/mac80211/Kconfig                       |    1 
 net/mac80211/Makefile                      |    1 
 net/mac80211/ieee80211_i.h                 |    4 -
 net/mac80211/iface.c                       |    1 
 net/mac80211/scan.c                        |    1 
 net/mac80211/wext.c                        |   98 -----------------------------
 net/wireless/core.c                        |    3 
 net/wireless/mlme.c                        |    2 
 net/wireless/scan.c                        |    1 
 net/wireless/sme.c                         |    2 
 net/wireless/wext-compat.c                 |   40 +++++++++++
 net/wireless/wext-compat.h                 |    5 +
 17 files changed, 54 insertions(+), 206 deletions(-)

--- wireless-testing.orig/net/mac80211/wext.c	2009-07-27 11:42:06.000000000 +0200
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
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-07-27 11:42:06.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-07-27 11:42:14.000000000 +0200
@@ -1397,3 +1397,43 @@ int cfg80211_wext_giwessid(struct net_de
 	}
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwessid);
+
+static const iw_handler cfg80211_handlers[] = {
+	[IW_IOCTL_IDX(SIOCGIWNAME)]	= (iw_handler) cfg80211_wext_giwname,
+	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= (iw_handler) cfg80211_wext_siwfreq,
+	[IW_IOCTL_IDX(SIOCGIWFREQ)]	= (iw_handler) cfg80211_wext_giwfreq,
+	[IW_IOCTL_IDX(SIOCSIWMODE)]	= (iw_handler) cfg80211_wext_siwmode,
+	[IW_IOCTL_IDX(SIOCGIWMODE)]	= (iw_handler) cfg80211_wext_giwmode,
+	[IW_IOCTL_IDX(SIOCGIWRANGE)]	= (iw_handler) cfg80211_wext_giwrange,
+	[IW_IOCTL_IDX(SIOCSIWAP)]	= (iw_handler) cfg80211_wext_siwap,
+	[IW_IOCTL_IDX(SIOCGIWAP)]	= (iw_handler) cfg80211_wext_giwap,
+	[IW_IOCTL_IDX(SIOCSIWMLME)]	= (iw_handler) cfg80211_wext_siwmlme,
+	[IW_IOCTL_IDX(SIOCSIWSCAN)]	= (iw_handler) cfg80211_wext_siwscan,
+	[IW_IOCTL_IDX(SIOCGIWSCAN)]	= (iw_handler) cfg80211_wext_giwscan,
+	[IW_IOCTL_IDX(SIOCSIWESSID)]	= (iw_handler) cfg80211_wext_siwessid,
+	[IW_IOCTL_IDX(SIOCGIWESSID)]	= (iw_handler) cfg80211_wext_giwessid,
+	[IW_IOCTL_IDX(SIOCSIWRATE)]	= (iw_handler) cfg80211_wext_siwrate,
+	[IW_IOCTL_IDX(SIOCGIWRATE)]	= (iw_handler) cfg80211_wext_giwrate,
+	[IW_IOCTL_IDX(SIOCSIWRTS)]	= (iw_handler) cfg80211_wext_siwrts,
+	[IW_IOCTL_IDX(SIOCGIWRTS)]	= (iw_handler) cfg80211_wext_giwrts,
+	[IW_IOCTL_IDX(SIOCSIWFRAG)]	= (iw_handler) cfg80211_wext_siwfrag,
+	[IW_IOCTL_IDX(SIOCGIWFRAG)]	= (iw_handler) cfg80211_wext_giwfrag,
+	[IW_IOCTL_IDX(SIOCSIWTXPOW)]	= (iw_handler) cfg80211_wext_siwtxpower,
+	[IW_IOCTL_IDX(SIOCGIWTXPOW)]	= (iw_handler) cfg80211_wext_giwtxpower,
+	[IW_IOCTL_IDX(SIOCSIWRETRY)]	= (iw_handler) cfg80211_wext_siwretry,
+	[IW_IOCTL_IDX(SIOCGIWRETRY)]	= (iw_handler) cfg80211_wext_giwretry,
+	[IW_IOCTL_IDX(SIOCSIWENCODE)]	= (iw_handler) cfg80211_wext_siwencode,
+	[IW_IOCTL_IDX(SIOCGIWENCODE)]	= (iw_handler) cfg80211_wext_giwencode,
+	[IW_IOCTL_IDX(SIOCSIWPOWER)]	= (iw_handler) cfg80211_wext_siwpower,
+	[IW_IOCTL_IDX(SIOCGIWPOWER)]	= (iw_handler) cfg80211_wext_giwpower,
+	[IW_IOCTL_IDX(SIOCSIWGENIE)]	= (iw_handler) cfg80211_wext_siwgenie,
+	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= (iw_handler) cfg80211_wext_siwauth,
+	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= (iw_handler) cfg80211_wext_giwauth,
+	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= (iw_handler) cfg80211_wext_siwencodeext,
+};
+
+const struct iw_handler_def cfg80211_wext_handler = {
+	.num_standard		= ARRAY_SIZE(cfg80211_handlers),
+	.standard		= cfg80211_handlers,
+	.get_wireless_stats = cfg80211_wireless_stats,
+};
--- wireless-testing.orig/net/wireless/wext-compat.h	2009-07-27 11:42:06.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.h	2009-07-27 11:42:14.000000000 +0200
@@ -1,6 +1,9 @@
 #ifndef __WEXT_COMPAT
 #define __WEXT_COMPAT
 
+#include <net/iw_handler.h>
+#include <linux/wireless.h>
+
 int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
 			       struct iw_request_info *info,
 			       struct iw_freq *freq, char *extra);
@@ -42,4 +45,6 @@ int cfg80211_mgd_wext_giwessid(struct ne
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
+
+extern const struct iw_handler_def cfg80211_wext_handler;
 #endif /* __WEXT_COMPAT */
--- wireless-testing.orig/net/mac80211/Kconfig	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-07-27 11:42:14.000000000 +0200
@@ -6,7 +6,6 @@ config MAC80211
 	select CRYPTO_ARC4
 	select CRYPTO_AES
 	select CRC32
-	select WIRELESS_EXT
 	---help---
 	  This option enables the hardware independent IEEE 802.11
 	  networking stack.
--- wireless-testing.orig/net/mac80211/Makefile	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/mac80211/Makefile	2009-07-27 11:42:14.000000000 +0200
@@ -3,7 +3,6 @@ obj-$(CONFIG_MAC80211) += mac80211.o
 # mac80211 objects
 mac80211-y := \
 	main.o \
-	wext.o \
 	sta_info.o \
 	wep.o \
 	wpa.o \
--- wireless-testing.orig/net/mac80211/scan.c	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-07-27 11:42:15.000000000 +0200
@@ -18,7 +18,6 @@
 #include <linux/if_arp.h>
 #include <linux/rtnetlink.h>
 #include <net/mac80211.h>
-#include <net/iw_handler.h>
 
 #include "ieee80211_i.h"
 #include "driver-ops.h"
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-27 11:42:15.000000000 +0200
@@ -24,7 +24,6 @@
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
 #include <net/cfg80211.h>
-#include <net/iw_handler.h>
 #include <net/mac80211.h>
 #include "key.h"
 #include "sta_info.h"
@@ -951,9 +950,6 @@ void ieee80211_bss_info_change_notify(st
 void ieee80211_configure_filter(struct ieee80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
-/* wireless extensions */
-extern const struct iw_handler_def ieee80211_iw_handler_def;
-
 /* STA code */
 void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
--- wireless-testing.orig/net/mac80211/iface.c	2009-07-25 10:45:14.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2009-07-27 11:42:15.000000000 +0200
@@ -684,7 +684,6 @@ static void ieee80211_if_setup(struct ne
 {
 	ether_setup(dev);
 	dev->netdev_ops = &ieee80211_dataif_ops;
-	dev->wireless_handlers = &ieee80211_iw_handler_def;
 	dev->destructor = free_netdev;
 }
 
--- wireless-testing.orig/net/wireless/scan.c	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-27 11:42:15.000000000 +0200
@@ -14,6 +14,7 @@
 #include <net/iw_handler.h>
 #include "core.h"
 #include "nl80211.h"
+#include "wext-compat.h"
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(15 * HZ)
 
--- wireless-testing.orig/net/wireless/core.c	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-27 11:42:15.000000000 +0200
@@ -19,6 +19,7 @@
 #include "core.h"
 #include "sysfs.h"
 #include "debugfs.h"
+#include "wext-compat.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -665,6 +666,8 @@ static int cfg80211_netdev_notifier_call
 		wdev->sme_state = CFG80211_SME_IDLE;
 		mutex_unlock(&rdev->devlist_mtx);
 #ifdef CONFIG_WIRELESS_EXT
+		if (!dev->wireless_handlers)
+			dev->wireless_handlers = &cfg80211_wext_handler;
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
--- wireless-testing.orig/net/wireless/sme.c	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-27 11:42:15.000000000 +0200
@@ -8,6 +8,8 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/workqueue.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
 #include "nl80211.h"
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-27 11:42:03.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-27 11:42:15.000000000 +0200
@@ -8,7 +8,9 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
+#include <linux/wireless.h>
 #include <net/cfg80211.h>
+#include <net/iw_handler.h>
 #include "core.h"
 #include "nl80211.h"
 
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Makefile	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Makefile	2009-07-27 11:42:15.000000000 +0200
@@ -1,5 +1,5 @@
 obj-$(CONFIG_IWM) := iwmc3200wifi.o
 iwmc3200wifi-objs += main.o netdev.o rx.o tx.o sdio.o hal.o fw.o
-iwmc3200wifi-objs += commands.o wext.o cfg80211.o eeprom.o
+iwmc3200wifi-objs += commands.o cfg80211.o eeprom.o
 
 iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/iwm.h	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/iwm.h	2009-07-27 11:42:15.000000000 +0200
@@ -306,8 +306,6 @@ static inline void *iwm_private(struct i
 #define skb_to_rx_info(s) ((struct iwm_rx_info *)(s->cb))
 #define skb_to_tx_info(s) ((struct iwm_tx_info *)s->cb)
 
-extern const struct iw_handler_def iwm_iw_handler_def;
-
 void *iwm_if_alloc(int sizeof_bus, struct device *dev,
 		   struct iwm_if_ops *if_ops);
 void iwm_if_free(struct iwm_priv *iwm);
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/netdev.c	2009-07-27 11:42:15.000000000 +0200
@@ -123,7 +123,6 @@ void *iwm_if_alloc(int sizeof_bus, struc
 	}
 
 	ndev->netdev_ops = &iwm_netdev_ops;
-	ndev->wireless_handlers = &iwm_iw_handler_def;
 	ndev->ieee80211_ptr = wdev;
 	SET_NETDEV_DEV(ndev, wiphy_dev(wdev->wiphy));
 	wdev->netdev = ndev;
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/wext.c	2009-07-27 11:42:06.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,95 +0,0 @@
-/*
- * Intel Wireless Multicomm 3200 WiFi driver
- *
- * Copyright (C) 2009 Intel Corporation <ilw@linux.intel.com>
- * Samuel Ortiz <samuel.ortiz@intel.com>
- * Zhu Yi <yi.zhu@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License version
- * 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
- */
-
-#include <linux/wireless.h>
-#include <net/cfg80211.h>
-
-#include "iwm.h"
-#include "commands.h"
-
-static const iw_handler iwm_handlers[] =
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
-	(iw_handler) NULL,			        /* SIOCSIWMLME */
-	(iw_handler) NULL,				/* SIOCGIWAPLIST */
-	(iw_handler) cfg80211_wext_siwscan,		/* SIOCSIWSCAN */
-	(iw_handler) cfg80211_wext_giwscan,		/* SIOCGIWSCAN */
-	(iw_handler) cfg80211_wext_siwessid,		/* SIOCSIWESSID */
-	(iw_handler) cfg80211_wext_giwessid,		/* SIOCGIWESSID */
-	(iw_handler) NULL,				/* SIOCSIWNICKN */
-	(iw_handler) NULL,				/* SIOCGIWNICKN */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* SIOCSIWRATE */
-	(iw_handler) cfg80211_wext_giwrate,		/* SIOCGIWRATE */
-	(iw_handler) cfg80211_wext_siwrts,		/* SIOCSIWRTS */
-	(iw_handler) cfg80211_wext_giwrts,		/* SIOCGIWRTS */
-	(iw_handler) cfg80211_wext_siwfrag,	        /* SIOCSIWFRAG */
-	(iw_handler) cfg80211_wext_giwfrag,		/* SIOCGIWFRAG */
-	(iw_handler) cfg80211_wext_siwtxpower,		/* SIOCSIWTXPOW */
-	(iw_handler) cfg80211_wext_giwtxpower,		/* SIOCGIWTXPOW */
-	(iw_handler) NULL,				/* SIOCSIWRETRY */
-	(iw_handler) NULL,				/* SIOCGIWRETRY */
-	(iw_handler) cfg80211_wext_siwencode,		/* SIOCSIWENCODE */
-	(iw_handler) cfg80211_wext_giwencode,		/* SIOCGIWENCODE */
-	(iw_handler) cfg80211_wext_siwpower,		/* SIOCSIWPOWER */
-	(iw_handler) cfg80211_wext_giwpower,		/* SIOCGIWPOWER */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) NULL,				/* -- hole -- */
-	(iw_handler) cfg80211_wext_siwgenie,            /* SIOCSIWGENIE */
-	(iw_handler) NULL,				/* SIOCGIWGENIE */
-	(iw_handler) cfg80211_wext_siwauth,		/* SIOCSIWAUTH */
-	(iw_handler) cfg80211_wext_giwauth,		/* SIOCGIWAUTH */
-	(iw_handler) cfg80211_wext_siwencodeext,	/* SIOCSIWENCODEEXT */
-	(iw_handler) NULL,				/* SIOCGIWENCODEEXT */
-	(iw_handler) NULL,				/* SIOCSIWPMKSA */
-	(iw_handler) NULL,				/* -- hole -- */
-};
-
-const struct iw_handler_def iwm_iw_handler_def = {
-	.num_standard	= ARRAY_SIZE(iwm_handlers),
-	.standard	= (iw_handler *) iwm_handlers,
-	.get_wireless_stats = cfg80211_wireless_stats,
-};
-
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-07-25 10:45:11.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/Kconfig	2009-07-27 11:42:15.000000000 +0200
@@ -2,7 +2,6 @@ config IWM
 	tristate "Intel Wireless Multicomm 3200 WiFi driver"
 	depends on MMC && WLAN_80211 && EXPERIMENTAL
 	depends on CFG80211
-	select WIRELESS_EXT
 	select FW_LOADER
 	help
 	  The Intel Wireless Multicomm 3200 hardware is a combo

-- 

