Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbZI2V17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 17:27:59 -0400
Subject: [PATCH] wext: refactor
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Sep 2009 23:27:28 +0200
Message-Id: <1254259648.30589.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Refactor wext to
 * split out iwpriv handling
 * split out iwspy handling
 * split out procfs support
 * allow cfg80211 to have wireless extensions compat code
   w/o CONFIG_WIRELESS_EXT

After this, drivers need to
 - select WIRELESS_EXT	- for wext support
 - select WEXT_PRIV	- for iwpriv support
 - select WEXT_SPY	- for iwspy support

except cfg80211 -- which gets new hooks in wext-core.c
and can then get wext handlers without CONFIG_WIRELESS_EXT.

Wireless extensions procfs support is auto-selected
based on PROC_FS and anything that requires the wext core
(i.e. WIRELESS_EXT or CFG80211_WEXT).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
No comments received, so I guess it's good to go. Not for 2.6.32, of
course. Now all out-of-tree wext drivers need to build the kernel with a
wext driver enabled to get wext <insert manic laugh here>

 drivers/net/wireless/Kconfig         |   29 
 drivers/net/wireless/hostap/Kconfig  |    2 
 drivers/net/wireless/ipw2x00/Kconfig |    5 
 drivers/net/wireless/orinoco/Kconfig |    2 
 include/net/cfg80211.h               |    6 
 include/net/iw_handler.h             |   14 
 include/net/net_namespace.h          |    2 
 include/net/wext.h                   |   49 
 net/core/net-sysfs.c                 |    6 
 net/socket.c                         |    4 
 net/wireless/Kconfig                 |   50 
 net/wireless/Makefile                |    8 
 net/wireless/core.c                  |   12 
 net/wireless/ibss.c                  |   10 
 net/wireless/mlme.c                  |    2 
 net/wireless/nl80211.c               |    4 
 net/wireless/scan.c                  |    6 
 net/wireless/sme.c                   |   12 
 net/wireless/wext-core.c             | 1063 ++++++++++++++++++++
 net/wireless/wext-priv.c             |  248 ++++
 net/wireless/wext-proc.c             |  155 +++
 net/wireless/wext-spy.c              |  231 ++++
 net/wireless/wext.c                  | 1775 -----------------------------------
 23 files changed, 1849 insertions(+), 1846 deletions(-)

--- wireless-testing.orig/net/wireless/Kconfig	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/wireless/Kconfig	2009-09-29 23:25:17.000000000 +0200
@@ -1,3 +1,21 @@
+config WIRELESS_EXT
+	bool
+
+config WEXT_CORE
+	def_bool y
+	depends on CFG80211_WEXT || WIRELESS_EXT
+
+config WEXT_PROC
+	def_bool y
+	depends on PROC_FS
+	depends on WEXT_CORE
+
+config WEXT_SPY
+	bool
+
+config WEXT_PRIV
+	bool
+
 config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
@@ -56,6 +74,12 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
+config CFG80211_DEFAULT_PS_VALUE
+	int
+	default 1 if CFG80211_DEFAULT_PS
+	default 0
+	depends on CFG80211
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
@@ -67,14 +91,10 @@ config CFG80211_DEFAULT_PS
 	  applications instead -- they need to register their network
 	  latency requirement, see Documentation/power/pm_qos_interface.txt.
 
-config CFG80211_DEFAULT_PS_VALUE
-	int
-	default 1 if CFG80211_DEFAULT_PS
-	default 0
-
 config CFG80211_DEBUGFS
 	bool "cfg80211 DebugFS entries"
-	depends on CFG80211 && DEBUG_FS
+	depends on CFG80211
+	depends on DEBUG_FS
 	---help---
 	  You can enable this if you want to debugfs entries for cfg80211.
 
@@ -83,6 +103,7 @@ config CFG80211_DEBUGFS
 config WIRELESS_OLD_REGULATORY
 	bool "Old wireless static regulatory definitions"
 	default n
+	depends on CFG80211
 	---help---
 	  This option enables the old static regulatory information
 	  and uses it within the new framework. This option is available
@@ -94,20 +115,19 @@ config WIRELESS_OLD_REGULATORY
 
 	  Say N and if you say Y, please tell us why. The default is N.
 
-config WIRELESS_EXT
-	bool "Wireless extensions"
+config CFG80211_WEXT
+	bool "cfg80211 wireless extensions compatibility"
+	depends on CFG80211
+	select WEXT_CORE
 	default y
-	---help---
-	  This option enables the legacy wireless extensions
-	  (wireless network interface configuration via ioctls.)
-
-	  Say Y unless you've upgraded all your userspace to use
-	  nl80211 instead of wireless extensions.
+	help
+	  Enable this option if you need old userspace for wireless
+	  extensions with cfg80211-based drivers.
 
 config WIRELESS_EXT_SYSFS
 	bool "Wireless extensions sysfs files"
 	default y
-	depends on WIRELESS_EXT && SYSFS
+	depends on WEXT_CORE && SYSFS
 	help
 	  This option enables the deprecated wireless statistics
 	  files in /sys/class/net/*/wireless/. The same information
--- wireless-testing.orig/include/net/net_namespace.h	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/include/net/net_namespace.h	2009-09-29 23:25:17.000000000 +0200
@@ -80,7 +80,7 @@ struct net {
 #ifdef CONFIG_XFRM
 	struct netns_xfrm	xfrm;
 #endif
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_WEXT_CORE
 	struct sk_buff_head	wext_nlevents;
 #endif
 	struct net_generic	*gen;
--- wireless-testing.orig/include/net/cfg80211.h	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-09-29 23:25:17.000000000 +0200
@@ -1171,6 +1171,10 @@ struct wiphy {
 	struct net *_net;
 #endif
 
+#ifdef CONFIG_CFG80211_WEXT
+	const struct iw_handler_def *wext;
+#endif
+
 	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
@@ -1345,7 +1349,7 @@ struct wireless_dev {
 	struct cfg80211_internal_bss *auth_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
 		struct cfg80211_ibss_params ibss;
--- wireless-testing.orig/net/wireless/Makefile	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/wireless/Makefile	2009-09-29 23:25:17.000000000 +0200
@@ -1,13 +1,17 @@
-obj-$(CONFIG_WIRELESS_EXT) += wext.o
 obj-$(CONFIG_CFG80211) += cfg80211.o
 obj-$(CONFIG_LIB80211) += lib80211.o
 obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib80211_crypt_wep.o
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
+obj-$(CONFIG_WEXT_CORE) += wext-core.o
+obj-$(CONFIG_WEXT_PROC) += wext-proc.o
+obj-$(CONFIG_WEXT_SPY) += wext-spy.o
+obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
+
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
 cfg80211-y += mlme.o ibss.o sme.o chan.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
-cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
+cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
 
 ccflags-y += -D__CHECK_ENDIAN__
--- wireless-testing.orig/net/wireless/core.c	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-09-29 23:25:17.000000000 +0200
@@ -358,6 +358,10 @@ struct wiphy *wiphy_new(const struct cfg
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 
+#ifdef CONFIG_CFG80211_WEXT
+	rdev->wiphy.wext = &cfg80211_wext_handler;
+#endif
+
 	device_initialize(&rdev->wiphy.dev);
 	rdev->wiphy.dev.class = &ieee80211_class;
 	rdev->wiphy.dev.platform_data = rdev;
@@ -666,8 +670,6 @@ static int cfg80211_netdev_notifier_call
 		wdev->sme_state = CFG80211_SME_IDLE;
 		mutex_unlock(&rdev->devlist_mtx);
 #ifdef CONFIG_WIRELESS_EXT
-		if (!dev->wireless_handlers)
-			dev->wireless_handlers = &cfg80211_wext_handler;
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
 		wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
@@ -689,7 +691,7 @@ static int cfg80211_netdev_notifier_call
 			break;
 		case NL80211_IFTYPE_STATION:
 			wdev_lock(wdev);
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 			kfree(wdev->wext.ie);
 			wdev->wext.ie = NULL;
 			wdev->wext.ie_len = 0;
@@ -721,7 +723,7 @@ static int cfg80211_netdev_notifier_call
 			mutex_unlock(&rdev->devlist_mtx);
 			dev_put(dev);
 		}
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 		cfg80211_lock_rdev(rdev);
 		mutex_lock(&rdev->devlist_mtx);
 		wdev_lock(wdev);
@@ -759,7 +761,7 @@ static int cfg80211_netdev_notifier_call
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_init(&wdev->list);
 			rdev->devlist_generation++;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 			kfree(wdev->wext.keys);
 #endif
 		}
--- wireless-testing.orig/net/wireless/ibss.c	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-09-29 23:25:18.000000000 +0200
@@ -15,7 +15,7 @@ void __cfg80211_ibss_joined(struct net_d
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
@@ -44,7 +44,7 @@ void __cfg80211_ibss_joined(struct net_d
 
 	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid,
 				GFP_KERNEL);
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
 	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
@@ -96,7 +96,7 @@ int __cfg80211_join_ibss(struct cfg80211
 		kfree(wdev->connect_keys);
 	wdev->connect_keys = connkeys;
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	wdev->wext.ibss.channel = params->channel;
 #endif
 	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
@@ -154,7 +154,7 @@ static void __cfg80211_clear_ibss(struct
 
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	if (!nowext)
 		wdev->wext.ibss.ssid_len = 0;
 #endif
@@ -203,7 +203,7 @@ int cfg80211_leave_ibss(struct cfg80211_
 	return err;
 }
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 			    struct wireless_dev *wdev)
 {
--- wireless-testing.orig/net/wireless/mlme.c	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-09-29 23:25:18.000000000 +0200
@@ -331,7 +331,7 @@ void cfg80211_michael_mic_failure(struct
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 	char *buf = kmalloc(128, gfp);
 
--- wireless-testing.orig/net/wireless/nl80211.c	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-09-29 23:25:18.000000000 +0200
@@ -1264,7 +1264,7 @@ static int nl80211_set_key(struct sk_buf
 	if (!err)
 		err = func(&rdev->wiphy, dev, key.idx);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	if (!err) {
 		if (func == rdev->ops->set_default_key)
 			dev->ieee80211_ptr->wext.default_key = key.idx;
@@ -1365,7 +1365,7 @@ static int nl80211_del_key(struct sk_buf
 	if (!err)
 		err = rdev->ops->del_key(&rdev->wiphy, dev, key.idx, mac_addr);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	if (!err) {
 		if (key.idx == dev->ieee80211_ptr->wext.default_key)
 			dev->ieee80211_ptr->wext.default_key = -1;
--- wireless-testing.orig/net/wireless/scan.c	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-09-29 23:25:18.000000000 +0200
@@ -22,7 +22,7 @@ void ___cfg80211_scan_done(struct cfg802
 {
 	struct cfg80211_scan_request *request;
 	struct net_device *dev;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
@@ -47,7 +47,7 @@ void ___cfg80211_scan_done(struct cfg802
 	else
 		nl80211_send_scan_done(rdev, dev);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	if (!request->aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
 
@@ -592,7 +592,7 @@ void cfg80211_unlink_bss(struct wiphy *w
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,
 			  union iwreq_data *wrqu, char *extra)
--- wireless-testing.orig/net/wireless/sme.c	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-09-29 23:25:18.000000000 +0200
@@ -345,7 +345,7 @@ void __cfg80211_connect_result(struct ne
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	u8 *country_ie;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
@@ -362,7 +362,7 @@ void __cfg80211_connect_result(struct ne
 				    resp_ie, resp_ie_len,
 				    status, GFP_KERNEL);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	if (wextev) {
 		if (req_ie && status == WLAN_STATUS_SUCCESS) {
 			memset(&wrqu, 0, sizeof(wrqu));
@@ -477,7 +477,7 @@ void __cfg80211_roamed(struct wireless_d
 		       const u8 *resp_ie, size_t resp_ie_len)
 {
 	struct cfg80211_bss *bss;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
@@ -512,7 +512,7 @@ void __cfg80211_roamed(struct wireless_d
 			    req_ie, req_ie_len, resp_ie, resp_ie_len,
 			    GFP_KERNEL);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	if (req_ie) {
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = req_ie_len;
@@ -573,7 +573,7 @@ void __cfg80211_disconnected(struct net_
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	int i;
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
 
@@ -631,7 +631,7 @@ void __cfg80211_disconnected(struct net_
 		for (i = 0; i < 6; i++)
 			rdev->ops->del_key(wdev->wiphy, dev, i, NULL);
 
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
--- wireless-testing.orig/net/socket.c	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/socket.c	2009-09-29 23:25:18.000000000 +0200
@@ -905,11 +905,11 @@ static long sock_ioctl(struct file *file
 	if (cmd >= SIOCDEVPRIVATE && cmd <= (SIOCDEVPRIVATE + 15)) {
 		err = dev_ioctl(net, cmd, argp);
 	} else
-#ifdef CONFIG_WIRELESS_EXT
+#ifdef CONFIG_WEXT_CORE
 	if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
 		err = dev_ioctl(net, cmd, argp);
 	} else
-#endif				/* CONFIG_WIRELESS_EXT */
+#endif
 		switch (cmd) {
 		case FIOSETOWN:
 		case SIOCSPGRP:
--- wireless-testing.orig/net/wireless/wext.c	2009-09-29 23:20:10.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,1775 +0,0 @@
-/*
- * This file implement the Wireless Extensions APIs.
- *
- * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
- * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
- *
- * (As all part of the Linux kernel, this file is GPL)
- */
-
-/************************** DOCUMENTATION **************************/
-/*
- * API definition :
- * --------------
- * See <linux/wireless.h> for details of the APIs and the rest.
- *
- * History :
- * -------
- *
- * v1 - 5.12.01 - Jean II
- *	o Created this file.
- *
- * v2 - 13.12.01 - Jean II
- *	o Move /proc/net/wireless stuff from net/core/dev.c to here
- *	o Make Wireless Extension IOCTLs go through here
- *	o Added iw_handler handling ;-)
- *	o Added standard ioctl description
- *	o Initial dumb commit strategy based on orinoco.c
- *
- * v3 - 19.12.01 - Jean II
- *	o Make sure we don't go out of standard_ioctl[] in ioctl_standard_call
- *	o Add event dispatcher function
- *	o Add event description
- *	o Propagate events as rtnetlink IFLA_WIRELESS option
- *	o Generate event on selected SET requests
- *
- * v4 - 18.04.02 - Jean II
- *	o Fix stupid off by one in iw_ioctl_description : IW_ESSID_MAX_SIZE + 1
- *
- * v5 - 21.06.02 - Jean II
- *	o Add IW_PRIV_TYPE_ADDR in priv_type_size (+cleanup)
- *	o Reshuffle IW_HEADER_TYPE_XXX to map IW_PRIV_TYPE_XXX changes
- *	o Add IWEVCUSTOM for driver specific event/scanning token
- *	o Turn on WE_STRICT_WRITE by default + kernel warning
- *	o Fix WE_STRICT_WRITE in ioctl_export_private() (32 => iw_num)
- *	o Fix off-by-one in test (extra_size <= IFNAMSIZ)
- *
- * v6 - 9.01.03 - Jean II
- *	o Add common spy support : iw_handler_set_spy(), wireless_spy_update()
- *	o Add enhanced spy support : iw_handler_set_thrspy() and event.
- *	o Add WIRELESS_EXT version display in /proc/net/wireless
- *
- * v6 - 18.06.04 - Jean II
- *	o Change get_spydata() method for added safety
- *	o Remove spy #ifdef, they are always on -> cleaner code
- *	o Allow any size GET request if user specifies length > max
- *		and if request has IW_DESCR_FLAG_NOMAX flag or is SIOCGIWPRIV
- *	o Start migrating get_wireless_stats to struct iw_handler_def
- *	o Add wmb() in iw_handler_set_spy() for non-coherent archs/cpus
- * Based on patch from Pavel Roskin <proski@gnu.org> :
- *	o Fix kernel data leak to user space in private handler handling
- *
- * v7 - 18.3.05 - Jean II
- *	o Remove (struct iw_point *)->pointer from events and streams
- *	o Remove spy_offset from struct iw_handler_def
- *	o Start deprecating dev->get_wireless_stats, output a warning
- *	o If IW_QUAL_DBM is set, show dBm values in /proc/net/wireless
- *	o Don't lose INVALID/DBM flags when clearing UPDATED flags (iwstats)
- *
- * v8 - 17.02.06 - Jean II
- *	o RtNetlink requests support (SET/GET)
- *
- * v8b - 03.08.06 - Herbert Xu
- *	o Fix Wireless Event locking issues.
- *
- * v9 - 14.3.06 - Jean II
- *	o Change length in ESSID and NICK to strlen() instead of strlen()+1
- *	o Make standard_ioctl_num and standard_event_num unsigned
- *	o Remove (struct net_device *)->get_wireless_stats()
- *
- * v10 - 16.3.07 - Jean II
- *	o Prevent leaking of kernel space in stream on 64 bits.
- */
-
-/***************************** INCLUDES *****************************/
-
-#include <linux/module.h>
-#include <linux/types.h>		/* off_t */
-#include <linux/netdevice.h>		/* struct ifreq, dev_get_by_name() */
-#include <linux/proc_fs.h>
-#include <linux/rtnetlink.h>		/* rtnetlink stuff */
-#include <linux/seq_file.h>
-#include <linux/init.h>			/* for __init */
-#include <linux/if_arp.h>		/* ARPHRD_ETHER */
-#include <linux/etherdevice.h>		/* compare_ether_addr */
-#include <linux/interrupt.h>
-#include <net/net_namespace.h>
-
-#include <linux/wireless.h>		/* Pretty obvious */
-#include <net/iw_handler.h>		/* New driver API */
-#include <net/netlink.h>
-#include <net/wext.h>
-
-#include <asm/uaccess.h>		/* copy_to_user() */
-
-/************************* GLOBAL VARIABLES *************************/
-/*
- * You should not use global variables, because of re-entrancy.
- * On our case, it's only const, so it's OK...
- */
-/*
- * Meta-data about all the standard Wireless Extension request we
- * know about.
- */
-static const struct iw_ioctl_description standard_ioctl[] = {
-	[SIOCSIWCOMMIT	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_NULL,
-	},
-	[SIOCGIWNAME	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_CHAR,
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWNWID	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-		.flags		= IW_DESCR_FLAG_EVENT,
-	},
-	[SIOCGIWNWID	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWFREQ	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_FREQ,
-		.flags		= IW_DESCR_FLAG_EVENT,
-	},
-	[SIOCGIWFREQ	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_FREQ,
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWMODE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_UINT,
-		.flags		= IW_DESCR_FLAG_EVENT,
-	},
-	[SIOCGIWMODE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_UINT,
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWSENS	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWSENS	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWRANGE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_NULL,
-	},
-	[SIOCGIWRANGE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= sizeof(struct iw_range),
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWPRIV	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_NULL,
-	},
-	[SIOCGIWPRIV	- SIOCIWFIRST] = { /* (handled directly by us) */
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= sizeof(struct iw_priv_args),
-		.max_tokens	= 16,
-		.flags		= IW_DESCR_FLAG_NOMAX,
-	},
-	[SIOCSIWSTATS	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_NULL,
-	},
-	[SIOCGIWSTATS	- SIOCIWFIRST] = { /* (handled directly by us) */
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= sizeof(struct iw_statistics),
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWSPY	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= sizeof(struct sockaddr),
-		.max_tokens	= IW_MAX_SPY,
-	},
-	[SIOCGIWSPY	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= sizeof(struct sockaddr) +
-				  sizeof(struct iw_quality),
-		.max_tokens	= IW_MAX_SPY,
-	},
-	[SIOCSIWTHRSPY	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= sizeof(struct iw_thrspy),
-		.min_tokens	= 1,
-		.max_tokens	= 1,
-	},
-	[SIOCGIWTHRSPY	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= sizeof(struct iw_thrspy),
-		.min_tokens	= 1,
-		.max_tokens	= 1,
-	},
-	[SIOCSIWAP	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_ADDR,
-	},
-	[SIOCGIWAP	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_ADDR,
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWMLME	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.min_tokens	= sizeof(struct iw_mlme),
-		.max_tokens	= sizeof(struct iw_mlme),
-	},
-	[SIOCGIWAPLIST	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= sizeof(struct sockaddr) +
-				  sizeof(struct iw_quality),
-		.max_tokens	= IW_MAX_AP,
-		.flags		= IW_DESCR_FLAG_NOMAX,
-	},
-	[SIOCSIWSCAN	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.min_tokens	= 0,
-		.max_tokens	= sizeof(struct iw_scan_req),
-	},
-	[SIOCGIWSCAN	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_SCAN_MAX_DATA,
-		.flags		= IW_DESCR_FLAG_NOMAX,
-	},
-	[SIOCSIWESSID	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_ESSID_MAX_SIZE,
-		.flags		= IW_DESCR_FLAG_EVENT,
-	},
-	[SIOCGIWESSID	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_ESSID_MAX_SIZE,
-		.flags		= IW_DESCR_FLAG_DUMP,
-	},
-	[SIOCSIWNICKN	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_ESSID_MAX_SIZE,
-	},
-	[SIOCGIWNICKN	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_ESSID_MAX_SIZE,
-	},
-	[SIOCSIWRATE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWRATE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWRTS	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWRTS	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWFRAG	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWFRAG	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWTXPOW	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWTXPOW	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWRETRY	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWRETRY	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWENCODE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_ENCODING_TOKEN_MAX,
-		.flags		= IW_DESCR_FLAG_EVENT | IW_DESCR_FLAG_RESTRICT,
-	},
-	[SIOCGIWENCODE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_ENCODING_TOKEN_MAX,
-		.flags		= IW_DESCR_FLAG_DUMP | IW_DESCR_FLAG_RESTRICT,
-	},
-	[SIOCSIWPOWER	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWPOWER	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWGENIE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_GENERIC_IE_MAX,
-	},
-	[SIOCGIWGENIE	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_GENERIC_IE_MAX,
-	},
-	[SIOCSIWAUTH	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCGIWAUTH	- SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_PARAM,
-	},
-	[SIOCSIWENCODEEXT - SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.min_tokens	= sizeof(struct iw_encode_ext),
-		.max_tokens	= sizeof(struct iw_encode_ext) +
-				  IW_ENCODING_TOKEN_MAX,
-	},
-	[SIOCGIWENCODEEXT - SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.min_tokens	= sizeof(struct iw_encode_ext),
-		.max_tokens	= sizeof(struct iw_encode_ext) +
-				  IW_ENCODING_TOKEN_MAX,
-	},
-	[SIOCSIWPMKSA - SIOCIWFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.min_tokens	= sizeof(struct iw_pmksa),
-		.max_tokens	= sizeof(struct iw_pmksa),
-	},
-};
-static const unsigned standard_ioctl_num = ARRAY_SIZE(standard_ioctl);
-
-/*
- * Meta-data about all the additional standard Wireless Extension events
- * we know about.
- */
-static const struct iw_ioctl_description standard_event[] = {
-	[IWEVTXDROP	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_ADDR,
-	},
-	[IWEVQUAL	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_QUAL,
-	},
-	[IWEVCUSTOM	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_CUSTOM_MAX,
-	},
-	[IWEVREGISTERED	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_ADDR,
-	},
-	[IWEVEXPIRED	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_ADDR,
-	},
-	[IWEVGENIE	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_GENERIC_IE_MAX,
-	},
-	[IWEVMICHAELMICFAILURE	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= sizeof(struct iw_michaelmicfailure),
-	},
-	[IWEVASSOCREQIE	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_GENERIC_IE_MAX,
-	},
-	[IWEVASSOCRESPIE	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= IW_GENERIC_IE_MAX,
-	},
-	[IWEVPMKIDCAND	- IWEVFIRST] = {
-		.header_type	= IW_HEADER_TYPE_POINT,
-		.token_size	= 1,
-		.max_tokens	= sizeof(struct iw_pmkid_cand),
-	},
-};
-static const unsigned standard_event_num = ARRAY_SIZE(standard_event);
-
-/* Size (in bytes) of the various private data types */
-static const char iw_priv_type_size[] = {
-	0,				/* IW_PRIV_TYPE_NONE */
-	1,				/* IW_PRIV_TYPE_BYTE */
-	1,				/* IW_PRIV_TYPE_CHAR */
-	0,				/* Not defined */
-	sizeof(__u32),			/* IW_PRIV_TYPE_INT */
-	sizeof(struct iw_freq),		/* IW_PRIV_TYPE_FLOAT */
-	sizeof(struct sockaddr),	/* IW_PRIV_TYPE_ADDR */
-	0,				/* Not defined */
-};
-
-/* Size (in bytes) of various events */
-static const int event_type_size[] = {
-	IW_EV_LCP_LEN,			/* IW_HEADER_TYPE_NULL */
-	0,
-	IW_EV_CHAR_LEN,			/* IW_HEADER_TYPE_CHAR */
-	0,
-	IW_EV_UINT_LEN,			/* IW_HEADER_TYPE_UINT */
-	IW_EV_FREQ_LEN,			/* IW_HEADER_TYPE_FREQ */
-	IW_EV_ADDR_LEN,			/* IW_HEADER_TYPE_ADDR */
-	0,
-	IW_EV_POINT_LEN,		/* Without variable payload */
-	IW_EV_PARAM_LEN,		/* IW_HEADER_TYPE_PARAM */
-	IW_EV_QUAL_LEN,			/* IW_HEADER_TYPE_QUAL */
-};
-
-#ifdef CONFIG_COMPAT
-static const int compat_event_type_size[] = {
-	IW_EV_COMPAT_LCP_LEN,		/* IW_HEADER_TYPE_NULL */
-	0,
-	IW_EV_COMPAT_CHAR_LEN,		/* IW_HEADER_TYPE_CHAR */
-	0,
-	IW_EV_COMPAT_UINT_LEN,		/* IW_HEADER_TYPE_UINT */
-	IW_EV_COMPAT_FREQ_LEN,		/* IW_HEADER_TYPE_FREQ */
-	IW_EV_COMPAT_ADDR_LEN,		/* IW_HEADER_TYPE_ADDR */
-	0,
-	IW_EV_COMPAT_POINT_LEN,		/* Without variable payload */
-	IW_EV_COMPAT_PARAM_LEN,		/* IW_HEADER_TYPE_PARAM */
-	IW_EV_COMPAT_QUAL_LEN,		/* IW_HEADER_TYPE_QUAL */
-};
-#endif
-
-/************************ COMMON SUBROUTINES ************************/
-/*
- * Stuff that may be used in various place or doesn't fit in one
- * of the section below.
- */
-
-/* ---------------------------------------------------------------- */
-/*
- * Return the driver handler associated with a specific Wireless Extension.
- */
-static iw_handler get_handler(struct net_device *dev, unsigned int cmd)
-{
-	/* Don't "optimise" the following variable, it will crash */
-	unsigned int	index;		/* *MUST* be unsigned */
-
-	/* Check if we have some wireless handlers defined */
-	if (dev->wireless_handlers == NULL)
-		return NULL;
-
-	/* Try as a standard command */
-	index = cmd - SIOCIWFIRST;
-	if (index < dev->wireless_handlers->num_standard)
-		return dev->wireless_handlers->standard[index];
-
-	/* Try as a private command */
-	index = cmd - SIOCIWFIRSTPRIV;
-	if (index < dev->wireless_handlers->num_private)
-		return dev->wireless_handlers->private[index];
-
-	/* Not found */
-	return NULL;
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Get statistics out of the driver
- */
-struct iw_statistics *get_wireless_stats(struct net_device *dev)
-{
-	/* New location */
-	if ((dev->wireless_handlers != NULL) &&
-	   (dev->wireless_handlers->get_wireless_stats != NULL))
-		return dev->wireless_handlers->get_wireless_stats(dev);
-
-	/* Not found */
-	return NULL;
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Call the commit handler in the driver
- * (if exist and if conditions are right)
- *
- * Note : our current commit strategy is currently pretty dumb,
- * but we will be able to improve on that...
- * The goal is to try to agreagate as many changes as possible
- * before doing the commit. Drivers that will define a commit handler
- * are usually those that need a reset after changing parameters, so
- * we want to minimise the number of reset.
- * A cool idea is to use a timer : at each "set" command, we re-set the
- * timer, when the timer eventually fires, we call the driver.
- * Hopefully, more on that later.
- *
- * Also, I'm waiting to see how many people will complain about the
- * netif_running(dev) test. I'm open on that one...
- * Hopefully, the driver will remember to do a commit in "open()" ;-)
- */
-static int call_commit_handler(struct net_device *dev)
-{
-	if ((netif_running(dev)) &&
-	   (dev->wireless_handlers->standard[0] != NULL))
-		/* Call the commit handler on the driver */
-		return dev->wireless_handlers->standard[0](dev, NULL,
-							   NULL, NULL);
-	else
-		return 0;		/* Command completed successfully */
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Calculate size of private arguments
- */
-static int get_priv_size(__u16 args)
-{
-	int	num = args & IW_PRIV_SIZE_MASK;
-	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
-
-	return num * iw_priv_type_size[type];
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Re-calculate the size of private arguments
- */
-static int adjust_priv_size(__u16 args, struct iw_point *iwp)
-{
-	int	num = iwp->length;
-	int	max = args & IW_PRIV_SIZE_MASK;
-	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
-
-	/* Make sure the driver doesn't goof up */
-	if (max < num)
-		num = max;
-
-	return num * iw_priv_type_size[type];
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Standard Wireless Handler : get wireless stats
- *	Allow programatic access to /proc/net/wireless even if /proc
- *	doesn't exist... Also more efficient...
- */
-static int iw_handler_get_iwstats(struct net_device *		dev,
-				  struct iw_request_info *	info,
-				  union iwreq_data *		wrqu,
-				  char *			extra)
-{
-	/* Get stats from the driver */
-	struct iw_statistics *stats;
-
-	stats = get_wireless_stats(dev);
-	if (stats) {
-		/* Copy statistics to extra */
-		memcpy(extra, stats, sizeof(struct iw_statistics));
-		wrqu->data.length = sizeof(struct iw_statistics);
-
-		/* Check if we need to clear the updated flag */
-		if (wrqu->data.flags != 0)
-			stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
-		return 0;
-	} else
-		return -EOPNOTSUPP;
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Standard Wireless Handler : get iwpriv definitions
- * Export the driver private handler definition
- * They will be picked up by tools like iwpriv...
- */
-static int iw_handler_get_private(struct net_device *		dev,
-				  struct iw_request_info *	info,
-				  union iwreq_data *		wrqu,
-				  char *			extra)
-{
-	/* Check if the driver has something to export */
-	if ((dev->wireless_handlers->num_private_args == 0) ||
-	   (dev->wireless_handlers->private_args == NULL))
-		return -EOPNOTSUPP;
-
-	/* Check if there is enough buffer up there */
-	if (wrqu->data.length < dev->wireless_handlers->num_private_args) {
-		/* User space can't know in advance how large the buffer
-		 * needs to be. Give it a hint, so that we can support
-		 * any size buffer we want somewhat efficiently... */
-		wrqu->data.length = dev->wireless_handlers->num_private_args;
-		return -E2BIG;
-	}
-
-	/* Set the number of available ioctls. */
-	wrqu->data.length = dev->wireless_handlers->num_private_args;
-
-	/* Copy structure to the user buffer. */
-	memcpy(extra, dev->wireless_handlers->private_args,
-	       sizeof(struct iw_priv_args) * wrqu->data.length);
-
-	return 0;
-}
-
-
-/******************** /proc/net/wireless SUPPORT ********************/
-/*
- * The /proc/net/wireless file is a human readable user-space interface
- * exporting various wireless specific statistics from the wireless devices.
- * This is the most popular part of the Wireless Extensions ;-)
- *
- * This interface is a pure clone of /proc/net/dev (in net/core/dev.c).
- * The content of the file is basically the content of "struct iw_statistics".
- */
-
-#ifdef CONFIG_PROC_FS
-
-/* ---------------------------------------------------------------- */
-/*
- * Print one entry (line) of /proc/net/wireless
- */
-static void wireless_seq_printf_stats(struct seq_file *seq,
-				      struct net_device *dev)
-{
-	/* Get stats from the driver */
-	struct iw_statistics *stats = get_wireless_stats(dev);
-	static struct iw_statistics nullstats = {};
-
-	/* show device if it's wireless regardless of current stats */
-	if (!stats && dev->wireless_handlers)
-		stats = &nullstats;
-
-	if (stats) {
-		seq_printf(seq, "%6s: %04x  %3d%c  %3d%c  %3d%c  %6d %6d %6d "
-				"%6d %6d   %6d\n",
-			   dev->name, stats->status, stats->qual.qual,
-			   stats->qual.updated & IW_QUAL_QUAL_UPDATED
-			   ? '.' : ' ',
-			   ((__s32) stats->qual.level) -
-			   ((stats->qual.updated & IW_QUAL_DBM) ? 0x100 : 0),
-			   stats->qual.updated & IW_QUAL_LEVEL_UPDATED
-			   ? '.' : ' ',
-			   ((__s32) stats->qual.noise) -
-			   ((stats->qual.updated & IW_QUAL_DBM) ? 0x100 : 0),
-			   stats->qual.updated & IW_QUAL_NOISE_UPDATED
-			   ? '.' : ' ',
-			   stats->discard.nwid, stats->discard.code,
-			   stats->discard.fragment, stats->discard.retries,
-			   stats->discard.misc, stats->miss.beacon);
-
-		if (stats != &nullstats)
-			stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
-	}
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Print info for /proc/net/wireless (print all entries)
- */
-static int wireless_dev_seq_show(struct seq_file *seq, void *v)
-{
-	might_sleep();
-
-	if (v == SEQ_START_TOKEN)
-		seq_printf(seq, "Inter-| sta-|   Quality        |   Discarded "
-				"packets               | Missed | WE\n"
-				" face | tus | link level noise |  nwid  "
-				"crypt   frag  retry   misc | beacon | %d\n",
-			   WIRELESS_EXT);
-	else
-		wireless_seq_printf_stats(seq, v);
-	return 0;
-}
-
-static void *wireless_dev_seq_start(struct seq_file *seq, loff_t *pos)
-{
-	struct net *net = seq_file_net(seq);
-	loff_t off;
-	struct net_device *dev;
-
-	rtnl_lock();
-	if (!*pos)
-		return SEQ_START_TOKEN;
-
-	off = 1;
-	for_each_netdev(net, dev)
-		if (off++ == *pos)
-			return dev;
-	return NULL;
-}
-
-static void *wireless_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	struct net *net = seq_file_net(seq);
-
-	++*pos;
-
-	return v == SEQ_START_TOKEN ?
-		first_net_device(net) : next_net_device(v);
-}
-
-static void wireless_dev_seq_stop(struct seq_file *seq, void *v)
-{
-	rtnl_unlock();
-}
-
-static const struct seq_operations wireless_seq_ops = {
-	.start = wireless_dev_seq_start,
-	.next  = wireless_dev_seq_next,
-	.stop  = wireless_dev_seq_stop,
-	.show  = wireless_dev_seq_show,
-};
-
-static int seq_open_wireless(struct inode *inode, struct file *file)
-{
-	return seq_open_net(inode, file, &wireless_seq_ops,
-			    sizeof(struct seq_net_private));
-}
-
-static const struct file_operations wireless_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open    = seq_open_wireless,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release_net,
-};
-
-int wext_proc_init(struct net *net)
-{
-	/* Create /proc/net/wireless entry */
-	if (!proc_net_fops_create(net, "wireless", S_IRUGO, &wireless_seq_fops))
-		return -ENOMEM;
-
-	return 0;
-}
-
-void wext_proc_exit(struct net *net)
-{
-	proc_net_remove(net, "wireless");
-}
-#endif	/* CONFIG_PROC_FS */
-
-/************************** IOCTL SUPPORT **************************/
-/*
- * The original user space API to configure all those Wireless Extensions
- * is through IOCTLs.
- * In there, we check if we need to call the new driver API (iw_handler)
- * or just call the driver ioctl handler.
- */
-
-/* ---------------------------------------------------------------- */
-static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
-				   const struct iw_ioctl_description *descr,
-				   iw_handler handler, struct net_device *dev,
-				   struct iw_request_info *info)
-{
-	int err, extra_size, user_length = 0, essid_compat = 0;
-	char *extra;
-
-	/* Calculate space needed by arguments. Always allocate
-	 * for max space.
-	 */
-	extra_size = descr->max_tokens * descr->token_size;
-
-	/* Check need for ESSID compatibility for WE < 21 */
-	switch (cmd) {
-	case SIOCSIWESSID:
-	case SIOCGIWESSID:
-	case SIOCSIWNICKN:
-	case SIOCGIWNICKN:
-		if (iwp->length == descr->max_tokens + 1)
-			essid_compat = 1;
-		else if (IW_IS_SET(cmd) && (iwp->length != 0)) {
-			char essid[IW_ESSID_MAX_SIZE + 1];
-			unsigned int len;
-			len = iwp->length * descr->token_size;
-
-			if (len > IW_ESSID_MAX_SIZE)
-				return -EFAULT;
-
-			err = copy_from_user(essid, iwp->pointer, len);
-			if (err)
-				return -EFAULT;
-
-			if (essid[iwp->length - 1] == '\0')
-				essid_compat = 1;
-		}
-		break;
-	default:
-		break;
-	}
-
-	iwp->length -= essid_compat;
-
-	/* Check what user space is giving us */
-	if (IW_IS_SET(cmd)) {
-		/* Check NULL pointer */
-		if (!iwp->pointer && iwp->length != 0)
-			return -EFAULT;
-		/* Check if number of token fits within bounds */
-		if (iwp->length > descr->max_tokens)
-			return -E2BIG;
-		if (iwp->length < descr->min_tokens)
-			return -EINVAL;
-	} else {
-		/* Check NULL pointer */
-		if (!iwp->pointer)
-			return -EFAULT;
-		/* Save user space buffer size for checking */
-		user_length = iwp->length;
-
-		/* Don't check if user_length > max to allow forward
-		 * compatibility. The test user_length < min is
-		 * implied by the test at the end.
-		 */
-
-		/* Support for very large requests */
-		if ((descr->flags & IW_DESCR_FLAG_NOMAX) &&
-		    (user_length > descr->max_tokens)) {
-			/* Allow userspace to GET more than max so
-			 * we can support any size GET requests.
-			 * There is still a limit : -ENOMEM.
-			 */
-			extra_size = user_length * descr->token_size;
-
-			/* Note : user_length is originally a __u16,
-			 * and token_size is controlled by us,
-			 * so extra_size won't get negative and
-			 * won't overflow...
-			 */
-		}
-	}
-
-	/* kzalloc() ensures NULL-termination for essid_compat. */
-	extra = kzalloc(extra_size, GFP_KERNEL);
-	if (!extra)
-		return -ENOMEM;
-
-	/* If it is a SET, get all the extra data in here */
-	if (IW_IS_SET(cmd) && (iwp->length != 0)) {
-		if (copy_from_user(extra, iwp->pointer,
-				   iwp->length *
-				   descr->token_size)) {
-			err = -EFAULT;
-			goto out;
-		}
-
-		if (cmd == SIOCSIWENCODEEXT) {
-			struct iw_encode_ext *ee = (void *) extra;
-
-			if (iwp->length < sizeof(*ee) + ee->key_len)
-				return -EFAULT;
-		}
-	}
-
-	err = handler(dev, info, (union iwreq_data *) iwp, extra);
-
-	iwp->length += essid_compat;
-
-	/* If we have something to return to the user */
-	if (!err && IW_IS_GET(cmd)) {
-		/* Check if there is enough buffer up there */
-		if (user_length < iwp->length) {
-			err = -E2BIG;
-			goto out;
-		}
-
-		if (copy_to_user(iwp->pointer, extra,
-				 iwp->length *
-				 descr->token_size)) {
-			err = -EFAULT;
-			goto out;
-		}
-	}
-
-	/* Generate an event to notify listeners of the change */
-	if ((descr->flags & IW_DESCR_FLAG_EVENT) && err == -EIWCOMMIT) {
-		union iwreq_data *data = (union iwreq_data *) iwp;
-
-		if (descr->flags & IW_DESCR_FLAG_RESTRICT)
-			/* If the event is restricted, don't
-			 * export the payload.
-			 */
-			wireless_send_event(dev, cmd, data, NULL);
-		else
-			wireless_send_event(dev, cmd, data, extra);
-	}
-
-out:
-	kfree(extra);
-	return err;
-}
-
-/*
- * Wrapper to call a standard Wireless Extension handler.
- * We do various checks and also take care of moving data between
- * user space and kernel space.
- */
-static int ioctl_standard_call(struct net_device *	dev,
-			       struct iwreq		*iwr,
-			       unsigned int		cmd,
-			       struct iw_request_info	*info,
-			       iw_handler		handler)
-{
-	const struct iw_ioctl_description *	descr;
-	int					ret = -EINVAL;
-
-	/* Get the description of the IOCTL */
-	if ((cmd - SIOCIWFIRST) >= standard_ioctl_num)
-		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
-
-	/* Check if we have a pointer to user space data or not */
-	if (descr->header_type != IW_HEADER_TYPE_POINT) {
-
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, info, &(iwr->u), NULL);
-
-		/* Generate an event to notify listeners of the change */
-		if ((descr->flags & IW_DESCR_FLAG_EVENT) &&
-		   ((ret == 0) || (ret == -EIWCOMMIT)))
-			wireless_send_event(dev, cmd, &(iwr->u), NULL);
-	} else {
-		ret = ioctl_standard_iw_point(&iwr->u.data, cmd, descr,
-					      handler, dev, info);
-	}
-
-	/* Call commit handler if needed and defined */
-	if (ret == -EIWCOMMIT)
-		ret = call_commit_handler(dev);
-
-	/* Here, we will generate the appropriate event if needed */
-
-	return ret;
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Wrapper to call a private Wireless Extension handler.
- * We do various checks and also take care of moving data between
- * user space and kernel space.
- * It's not as nice and slimline as the standard wrapper. The cause
- * is struct iw_priv_args, which was not really designed for the
- * job we are going here.
- *
- * IMPORTANT : This function prevent to set and get data on the same
- * IOCTL and enforce the SET/GET convention. Not doing it would be
- * far too hairy...
- * If you need to set and get data at the same time, please don't use
- * a iw_handler but process it in your ioctl handler (i.e. use the
- * old driver API).
- */
-static int get_priv_descr_and_size(struct net_device *dev, unsigned int cmd,
-				   const struct iw_priv_args **descrp)
-{
-	const struct iw_priv_args *descr;
-	int i, extra_size;
-
-	descr = NULL;
-	for (i = 0; i < dev->wireless_handlers->num_private_args; i++) {
-		if (cmd == dev->wireless_handlers->private_args[i].cmd) {
-			descr = &dev->wireless_handlers->private_args[i];
-			break;
-		}
-	}
-
-	extra_size = 0;
-	if (descr) {
-		if (IW_IS_SET(cmd)) {
-			int	offset = 0;	/* For sub-ioctls */
-			/* Check for sub-ioctl handler */
-			if (descr->name[0] == '\0')
-				/* Reserve one int for sub-ioctl index */
-				offset = sizeof(__u32);
-
-			/* Size of set arguments */
-			extra_size = get_priv_size(descr->set_args);
-
-			/* Does it fits in iwr ? */
-			if ((descr->set_args & IW_PRIV_SIZE_FIXED) &&
-			   ((extra_size + offset) <= IFNAMSIZ))
-				extra_size = 0;
-		} else {
-			/* Size of get arguments */
-			extra_size = get_priv_size(descr->get_args);
-
-			/* Does it fits in iwr ? */
-			if ((descr->get_args & IW_PRIV_SIZE_FIXED) &&
-			   (extra_size <= IFNAMSIZ))
-				extra_size = 0;
-		}
-	}
-	*descrp = descr;
-	return extra_size;
-}
-
-static int ioctl_private_iw_point(struct iw_point *iwp, unsigned int cmd,
-				  const struct iw_priv_args *descr,
-				  iw_handler handler, struct net_device *dev,
-				  struct iw_request_info *info, int extra_size)
-{
-	char *extra;
-	int err;
-
-	/* Check what user space is giving us */
-	if (IW_IS_SET(cmd)) {
-		if (!iwp->pointer && iwp->length != 0)
-			return -EFAULT;
-
-		if (iwp->length > (descr->set_args & IW_PRIV_SIZE_MASK))
-			return -E2BIG;
-	} else if (!iwp->pointer)
-		return -EFAULT;
-
-	extra = kmalloc(extra_size, GFP_KERNEL);
-	if (!extra)
-		return -ENOMEM;
-
-	/* If it is a SET, get all the extra data in here */
-	if (IW_IS_SET(cmd) && (iwp->length != 0)) {
-		if (copy_from_user(extra, iwp->pointer, extra_size)) {
-			err = -EFAULT;
-			goto out;
-		}
-	}
-
-	/* Call the handler */
-	err = handler(dev, info, (union iwreq_data *) iwp, extra);
-
-	/* If we have something to return to the user */
-	if (!err && IW_IS_GET(cmd)) {
-		/* Adjust for the actual length if it's variable,
-		 * avoid leaking kernel bits outside.
-		 */
-		if (!(descr->get_args & IW_PRIV_SIZE_FIXED))
-			extra_size = adjust_priv_size(descr->get_args, iwp);
-
-		if (copy_to_user(iwp->pointer, extra, extra_size))
-			err =  -EFAULT;
-	}
-
-out:
-	kfree(extra);
-	return err;
-}
-
-static int ioctl_private_call(struct net_device *dev, struct iwreq *iwr,
-			      unsigned int cmd, struct iw_request_info *info,
-			      iw_handler handler)
-{
-	int extra_size = 0, ret = -EINVAL;
-	const struct iw_priv_args *descr;
-
-	extra_size = get_priv_descr_and_size(dev, cmd, &descr);
-
-	/* Check if we have a pointer to user space data or not. */
-	if (extra_size == 0) {
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, info, &(iwr->u), (char *) &(iwr->u));
-	} else {
-		ret = ioctl_private_iw_point(&iwr->u.data, cmd, descr,
-					     handler, dev, info, extra_size);
-	}
-
-	/* Call commit handler if needed and defined */
-	if (ret == -EIWCOMMIT)
-		ret = call_commit_handler(dev);
-
-	return ret;
-}
-
-/* ---------------------------------------------------------------- */
-typedef int (*wext_ioctl_func)(struct net_device *, struct iwreq *,
-			       unsigned int, struct iw_request_info *,
-			       iw_handler);
-
-/*
- * Main IOCTl dispatcher.
- * Check the type of IOCTL and call the appropriate wrapper...
- */
-static int wireless_process_ioctl(struct net *net, struct ifreq *ifr,
-				  unsigned int cmd,
-				  struct iw_request_info *info,
-				  wext_ioctl_func standard,
-				  wext_ioctl_func private)
-{
-	struct iwreq *iwr = (struct iwreq *) ifr;
-	struct net_device *dev;
-	iw_handler	handler;
-
-	/* Permissions are already checked in dev_ioctl() before calling us.
-	 * The copy_to/from_user() of ifr is also dealt with in there */
-
-	/* Make sure the device exist */
-	if ((dev = __dev_get_by_name(net, ifr->ifr_name)) == NULL)
-		return -ENODEV;
-
-	/* A bunch of special cases, then the generic case...
-	 * Note that 'cmd' is already filtered in dev_ioctl() with
-	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
-	if (cmd == SIOCGIWSTATS)
-		return standard(dev, iwr, cmd, info,
-				&iw_handler_get_iwstats);
-
-	if (cmd == SIOCGIWPRIV && dev->wireless_handlers)
-		return standard(dev, iwr, cmd, info,
-				&iw_handler_get_private);
-
-	/* Basic check */
-	if (!netif_device_present(dev))
-		return -ENODEV;
-
-	/* New driver API : try to find the handler */
-	handler = get_handler(dev, cmd);
-	if (handler) {
-		/* Standard and private are not the same */
-		if (cmd < SIOCIWFIRSTPRIV)
-			return standard(dev, iwr, cmd, info, handler);
-		else
-			return private(dev, iwr, cmd, info, handler);
-	}
-	/* Old driver API : call driver ioctl handler */
-	if (dev->netdev_ops->ndo_do_ioctl)
-		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
-	return -EOPNOTSUPP;
-}
-
-/* If command is `set a parameter', or `get the encoding parameters',
- * check if the user has the right to do it.
- */
-static int wext_permission_check(unsigned int cmd)
-{
-	if ((IW_IS_SET(cmd) || cmd == SIOCGIWENCODE || cmd == SIOCGIWENCODEEXT)
-	    && !capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	return 0;
-}
-
-/* entry point from dev ioctl */
-static int wext_ioctl_dispatch(struct net *net, struct ifreq *ifr,
-			       unsigned int cmd, struct iw_request_info *info,
-			       wext_ioctl_func standard,
-			       wext_ioctl_func private)
-{
-	int ret = wext_permission_check(cmd);
-
-	if (ret)
-		return ret;
-
-	dev_load(net, ifr->ifr_name);
-	rtnl_lock();
-	ret = wireless_process_ioctl(net, ifr, cmd, info, standard, private);
-	rtnl_unlock();
-
-	return ret;
-}
-
-int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
-		      void __user *arg)
-{
-	struct iw_request_info info = { .cmd = cmd, .flags = 0 };
-	int ret;
-
-	ret = wext_ioctl_dispatch(net, ifr, cmd, &info,
-				  ioctl_standard_call,
-				  ioctl_private_call);
-	if (ret >= 0 &&
-	    IW_IS_GET(cmd) &&
-	    copy_to_user(arg, ifr, sizeof(struct iwreq)))
-		return -EFAULT;
-
-	return ret;
-}
-
-#ifdef CONFIG_COMPAT
-static int compat_standard_call(struct net_device	*dev,
-				struct iwreq		*iwr,
-				unsigned int		cmd,
-				struct iw_request_info	*info,
-				iw_handler		handler)
-{
-	const struct iw_ioctl_description *descr;
-	struct compat_iw_point *iwp_compat;
-	struct iw_point iwp;
-	int err;
-
-	descr = standard_ioctl + (cmd - SIOCIWFIRST);
-
-	if (descr->header_type != IW_HEADER_TYPE_POINT)
-		return ioctl_standard_call(dev, iwr, cmd, info, handler);
-
-	iwp_compat = (struct compat_iw_point *) &iwr->u.data;
-	iwp.pointer = compat_ptr(iwp_compat->pointer);
-	iwp.length = iwp_compat->length;
-	iwp.flags = iwp_compat->flags;
-
-	err = ioctl_standard_iw_point(&iwp, cmd, descr, handler, dev, info);
-
-	iwp_compat->pointer = ptr_to_compat(iwp.pointer);
-	iwp_compat->length = iwp.length;
-	iwp_compat->flags = iwp.flags;
-
-	return err;
-}
-
-static int compat_private_call(struct net_device *dev, struct iwreq *iwr,
-			       unsigned int cmd, struct iw_request_info *info,
-			       iw_handler handler)
-{
-	const struct iw_priv_args *descr;
-	int ret, extra_size;
-
-	extra_size = get_priv_descr_and_size(dev, cmd, &descr);
-
-	/* Check if we have a pointer to user space data or not. */
-	if (extra_size == 0) {
-		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, info, &(iwr->u), (char *) &(iwr->u));
-	} else {
-		struct compat_iw_point *iwp_compat;
-		struct iw_point iwp;
-
-		iwp_compat = (struct compat_iw_point *) &iwr->u.data;
-		iwp.pointer = compat_ptr(iwp_compat->pointer);
-		iwp.length = iwp_compat->length;
-		iwp.flags = iwp_compat->flags;
-
-		ret = ioctl_private_iw_point(&iwp, cmd, descr,
-					     handler, dev, info, extra_size);
-
-		iwp_compat->pointer = ptr_to_compat(iwp.pointer);
-		iwp_compat->length = iwp.length;
-		iwp_compat->flags = iwp.flags;
-	}
-
-	/* Call commit handler if needed and defined */
-	if (ret == -EIWCOMMIT)
-		ret = call_commit_handler(dev);
-
-	return ret;
-}
-
-int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
-			     unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	struct iw_request_info info;
-	struct iwreq iwr;
-	char *colon;
-	int ret;
-
-	if (copy_from_user(&iwr, argp, sizeof(struct iwreq)))
-		return -EFAULT;
-
-	iwr.ifr_name[IFNAMSIZ-1] = 0;
-	colon = strchr(iwr.ifr_name, ':');
-	if (colon)
-		*colon = 0;
-
-	info.cmd = cmd;
-	info.flags = IW_REQUEST_FLAG_COMPAT;
-
-	ret = wext_ioctl_dispatch(net, (struct ifreq *) &iwr, cmd, &info,
-				  compat_standard_call,
-				  compat_private_call);
-
-	if (ret >= 0 &&
-	    IW_IS_GET(cmd) &&
-	    copy_to_user(argp, &iwr, sizeof(struct iwreq)))
-		return -EFAULT;
-
-	return ret;
-}
-#endif
-
-static int __net_init wext_pernet_init(struct net *net)
-{
-	skb_queue_head_init(&net->wext_nlevents);
-	return 0;
-}
-
-static void __net_exit wext_pernet_exit(struct net *net)
-{
-	skb_queue_purge(&net->wext_nlevents);
-}
-
-static struct pernet_operations wext_pernet_ops = {
-	.init = wext_pernet_init,
-	.exit = wext_pernet_exit,
-};
-
-static int __init wireless_nlevent_init(void)
-{
-	return register_pernet_subsys(&wext_pernet_ops);
-}
-
-subsys_initcall(wireless_nlevent_init);
-
-/* Process events generated by the wireless layer or the driver. */
-static void wireless_nlevent_process(struct work_struct *work)
-{
-	struct sk_buff *skb;
-	struct net *net;
-
-	rtnl_lock();
-
-	for_each_net(net) {
-		while ((skb = skb_dequeue(&net->wext_nlevents)))
-			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
-				    GFP_KERNEL);
-	}
-
-	rtnl_unlock();
-}
-
-static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
-
-static struct nlmsghdr *rtnetlink_ifinfo_prep(struct net_device *dev,
-					      struct sk_buff *skb)
-{
-	struct ifinfomsg *r;
-	struct nlmsghdr  *nlh;
-
-	nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*r), 0);
-	if (!nlh)
-		return NULL;
-
-	r = nlmsg_data(nlh);
-	r->ifi_family = AF_UNSPEC;
-	r->__ifi_pad = 0;
-	r->ifi_type = dev->type;
-	r->ifi_index = dev->ifindex;
-	r->ifi_flags = dev_get_flags(dev);
-	r->ifi_change = 0;	/* Wireless changes don't affect those flags */
-
-	NLA_PUT_STRING(skb, IFLA_IFNAME, dev->name);
-
-	return nlh;
- nla_put_failure:
-	nlmsg_cancel(skb, nlh);
-	return NULL;
-}
-
-
-/*
- * Main event dispatcher. Called from other parts and drivers.
- * Send the event on the appropriate channels.
- * May be called from interrupt context.
- */
-void wireless_send_event(struct net_device *	dev,
-			 unsigned int		cmd,
-			 union iwreq_data *	wrqu,
-			 const char *		extra)
-{
-	const struct iw_ioctl_description *	descr = NULL;
-	int extra_len = 0;
-	struct iw_event  *event;		/* Mallocated whole event */
-	int event_len;				/* Its size */
-	int hdr_len;				/* Size of the event header */
-	int wrqu_off = 0;			/* Offset in wrqu */
-	/* Don't "optimise" the following variable, it will crash */
-	unsigned	cmd_index;		/* *MUST* be unsigned */
-	struct sk_buff *skb;
-	struct nlmsghdr *nlh;
-	struct nlattr *nla;
-#ifdef CONFIG_COMPAT
-	struct __compat_iw_event *compat_event;
-	struct compat_iw_point compat_wrqu;
-	struct sk_buff *compskb;
-#endif
-
-	/*
-	 * Nothing in the kernel sends scan events with data, be safe.
-	 * This is necessary because we cannot fix up scan event data
-	 * for compat, due to being contained in 'extra', but normally
-	 * applications are required to retrieve the scan data anyway
-	 * and no data is included in the event, this codifies that
-	 * practice.
-	 */
-	if (WARN_ON(cmd == SIOCGIWSCAN && extra))
-		extra = NULL;
-
-	/* Get the description of the Event */
-	if (cmd <= SIOCIWLAST) {
-		cmd_index = cmd - SIOCIWFIRST;
-		if (cmd_index < standard_ioctl_num)
-			descr = &(standard_ioctl[cmd_index]);
-	} else {
-		cmd_index = cmd - IWEVFIRST;
-		if (cmd_index < standard_event_num)
-			descr = &(standard_event[cmd_index]);
-	}
-	/* Don't accept unknown events */
-	if (descr == NULL) {
-		/* Note : we don't return an error to the driver, because
-		 * the driver would not know what to do about it. It can't
-		 * return an error to the user, because the event is not
-		 * initiated by a user request.
-		 * The best the driver could do is to log an error message.
-		 * We will do it ourselves instead...
-		 */
-		printk(KERN_ERR "%s (WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
-		       dev->name, cmd);
-		return;
-	}
-
-	/* Check extra parameters and set extra_len */
-	if (descr->header_type == IW_HEADER_TYPE_POINT) {
-		/* Check if number of token fits within bounds */
-		if (wrqu->data.length > descr->max_tokens) {
-			printk(KERN_ERR "%s (WE) : Wireless Event too big (%d)\n", dev->name, wrqu->data.length);
-			return;
-		}
-		if (wrqu->data.length < descr->min_tokens) {
-			printk(KERN_ERR "%s (WE) : Wireless Event too small (%d)\n", dev->name, wrqu->data.length);
-			return;
-		}
-		/* Calculate extra_len - extra is NULL for restricted events */
-		if (extra != NULL)
-			extra_len = wrqu->data.length * descr->token_size;
-		/* Always at an offset in wrqu */
-		wrqu_off = IW_EV_POINT_OFF;
-	}
-
-	/* Total length of the event */
-	hdr_len = event_type_size[descr->header_type];
-	event_len = hdr_len + extra_len;
-
-	/*
-	 * The problem for 64/32 bit.
-	 *
-	 * On 64-bit, a regular event is laid out as follows:
-	 *      |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
-	 *      | event.len | event.cmd |     p a d d i n g     |
-	 *      | wrqu data ... (with the correct size)         |
-	 *
-	 * This padding exists because we manipulate event->u,
-	 * and 'event' is not packed.
-	 *
-	 * An iw_point event is laid out like this instead:
-	 *      |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
-	 *      | event.len | event.cmd |     p a d d i n g     |
-	 *      | iwpnt.len | iwpnt.flg |     p a d d i n g     |
-	 *      | extra data  ...
-	 *
-	 * The second padding exists because struct iw_point is extended,
-	 * but this depends on the platform...
-	 *
-	 * On 32-bit, all the padding shouldn't be there.
-	 */
-
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
-	if (!skb)
-		return;
-
-	/* Send via the RtNetlink event channel */
-	nlh = rtnetlink_ifinfo_prep(dev, skb);
-	if (WARN_ON(!nlh)) {
-		kfree_skb(skb);
-		return;
-	}
-
-	/* Add the wireless events in the netlink packet */
-	nla = nla_reserve(skb, IFLA_WIRELESS, event_len);
-	if (!nla) {
-		kfree_skb(skb);
-		return;
-	}
-	event = nla_data(nla);
-
-	/* Fill event - first clear to avoid data leaking */
-	memset(event, 0, hdr_len);
-	event->len = event_len;
-	event->cmd = cmd;
-	memcpy(&event->u, ((char *) wrqu) + wrqu_off, hdr_len - IW_EV_LCP_LEN);
-	if (extra_len)
-		memcpy(((char *) event) + hdr_len, extra, extra_len);
-
-	nlmsg_end(skb, nlh);
-#ifdef CONFIG_COMPAT
-	hdr_len = compat_event_type_size[descr->header_type];
-	event_len = hdr_len + extra_len;
-
-	compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
-	if (!compskb) {
-		kfree_skb(skb);
-		return;
-	}
-
-	/* Send via the RtNetlink event channel */
-	nlh = rtnetlink_ifinfo_prep(dev, compskb);
-	if (WARN_ON(!nlh)) {
-		kfree_skb(skb);
-		kfree_skb(compskb);
-		return;
-	}
-
-	/* Add the wireless events in the netlink packet */
-	nla = nla_reserve(compskb, IFLA_WIRELESS, event_len);
-	if (!nla) {
-		kfree_skb(skb);
-		kfree_skb(compskb);
-		return;
-	}
-	compat_event = nla_data(nla);
-
-	compat_event->len = event_len;
-	compat_event->cmd = cmd;
-	if (descr->header_type == IW_HEADER_TYPE_POINT) {
-		compat_wrqu.length = wrqu->data.length;
-		compat_wrqu.flags = wrqu->data.flags;
-		memcpy(&compat_event->pointer,
-			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
-		if (extra_len)
-			memcpy(((char *) compat_event) + hdr_len,
-				extra, extra_len);
-	} else {
-		/* extra_len must be zero, so no if (extra) needed */
-		memcpy(&compat_event->pointer, wrqu,
-			hdr_len - IW_EV_COMPAT_LCP_LEN);
-	}
-
-	nlmsg_end(compskb, nlh);
-
-	skb_shinfo(skb)->frag_list = compskb;
-#endif
-	skb_queue_tail(&dev_net(dev)->wext_nlevents, skb);
-	schedule_work(&wireless_nlevent_work);
-}
-EXPORT_SYMBOL(wireless_send_event);
-
-/********************** ENHANCED IWSPY SUPPORT **********************/
-/*
- * In the old days, the driver was handling spy support all by itself.
- * Now, the driver can delegate this task to Wireless Extensions.
- * It needs to use those standard spy iw_handler in struct iw_handler_def,
- * push data to us via wireless_spy_update() and include struct iw_spy_data
- * in its private part (and export it in net_device->wireless_data->spy_data).
- * One of the main advantage of centralising spy support here is that
- * it becomes much easier to improve and extend it without having to touch
- * the drivers. One example is the addition of the Spy-Threshold events.
- */
-
-/* ---------------------------------------------------------------- */
-/*
- * Return the pointer to the spy data in the driver.
- * Because this is called on the Rx path via wireless_spy_update(),
- * we want it to be efficient...
- */
-static inline struct iw_spy_data *get_spydata(struct net_device *dev)
-{
-	/* This is the new way */
-	if (dev->wireless_data)
-		return dev->wireless_data->spy_data;
-	return NULL;
-}
-
-/*------------------------------------------------------------------*/
-/*
- * Standard Wireless Handler : set Spy List
- */
-int iw_handler_set_spy(struct net_device *	dev,
-		       struct iw_request_info *	info,
-		       union iwreq_data *	wrqu,
-		       char *			extra)
-{
-	struct iw_spy_data *	spydata = get_spydata(dev);
-	struct sockaddr *	address = (struct sockaddr *) extra;
-
-	/* Make sure driver is not buggy or using the old API */
-	if (!spydata)
-		return -EOPNOTSUPP;
-
-	/* Disable spy collection while we copy the addresses.
-	 * While we copy addresses, any call to wireless_spy_update()
-	 * will NOP. This is OK, as anyway the addresses are changing. */
-	spydata->spy_number = 0;
-
-	/* We want to operate without locking, because wireless_spy_update()
-	 * most likely will happen in the interrupt handler, and therefore
-	 * have its own locking constraints and needs performance.
-	 * The rtnl_lock() make sure we don't race with the other iw_handlers.
-	 * This make sure wireless_spy_update() "see" that the spy list
-	 * is temporarily disabled. */
-	smp_wmb();
-
-	/* Are there are addresses to copy? */
-	if (wrqu->data.length > 0) {
-		int i;
-
-		/* Copy addresses */
-		for (i = 0; i < wrqu->data.length; i++)
-			memcpy(spydata->spy_address[i], address[i].sa_data,
-			       ETH_ALEN);
-		/* Reset stats */
-		memset(spydata->spy_stat, 0,
-		       sizeof(struct iw_quality) * IW_MAX_SPY);
-	}
-
-	/* Make sure above is updated before re-enabling */
-	smp_wmb();
-
-	/* Enable addresses */
-	spydata->spy_number = wrqu->data.length;
-
-	return 0;
-}
-EXPORT_SYMBOL(iw_handler_set_spy);
-
-/*------------------------------------------------------------------*/
-/*
- * Standard Wireless Handler : get Spy List
- */
-int iw_handler_get_spy(struct net_device *	dev,
-		       struct iw_request_info *	info,
-		       union iwreq_data *	wrqu,
-		       char *			extra)
-{
-	struct iw_spy_data *	spydata = get_spydata(dev);
-	struct sockaddr *	address = (struct sockaddr *) extra;
-	int			i;
-
-	/* Make sure driver is not buggy or using the old API */
-	if (!spydata)
-		return -EOPNOTSUPP;
-
-	wrqu->data.length = spydata->spy_number;
-
-	/* Copy addresses. */
-	for (i = 0; i < spydata->spy_number; i++) 	{
-		memcpy(address[i].sa_data, spydata->spy_address[i], ETH_ALEN);
-		address[i].sa_family = AF_UNIX;
-	}
-	/* Copy stats to the user buffer (just after). */
-	if (spydata->spy_number > 0)
-		memcpy(extra  + (sizeof(struct sockaddr) *spydata->spy_number),
-		       spydata->spy_stat,
-		       sizeof(struct iw_quality) * spydata->spy_number);
-	/* Reset updated flags. */
-	for (i = 0; i < spydata->spy_number; i++)
-		spydata->spy_stat[i].updated &= ~IW_QUAL_ALL_UPDATED;
-	return 0;
-}
-EXPORT_SYMBOL(iw_handler_get_spy);
-
-/*------------------------------------------------------------------*/
-/*
- * Standard Wireless Handler : set spy threshold
- */
-int iw_handler_set_thrspy(struct net_device *	dev,
-			  struct iw_request_info *info,
-			  union iwreq_data *	wrqu,
-			  char *		extra)
-{
-	struct iw_spy_data *	spydata = get_spydata(dev);
-	struct iw_thrspy *	threshold = (struct iw_thrspy *) extra;
-
-	/* Make sure driver is not buggy or using the old API */
-	if (!spydata)
-		return -EOPNOTSUPP;
-
-	/* Just do it */
-	memcpy(&(spydata->spy_thr_low), &(threshold->low),
-	       2 * sizeof(struct iw_quality));
-
-	/* Clear flag */
-	memset(spydata->spy_thr_under, '\0', sizeof(spydata->spy_thr_under));
-
-	return 0;
-}
-EXPORT_SYMBOL(iw_handler_set_thrspy);
-
-/*------------------------------------------------------------------*/
-/*
- * Standard Wireless Handler : get spy threshold
- */
-int iw_handler_get_thrspy(struct net_device *	dev,
-			  struct iw_request_info *info,
-			  union iwreq_data *	wrqu,
-			  char *		extra)
-{
-	struct iw_spy_data *	spydata = get_spydata(dev);
-	struct iw_thrspy *	threshold = (struct iw_thrspy *) extra;
-
-	/* Make sure driver is not buggy or using the old API */
-	if (!spydata)
-		return -EOPNOTSUPP;
-
-	/* Just do it */
-	memcpy(&(threshold->low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
-
-	return 0;
-}
-EXPORT_SYMBOL(iw_handler_get_thrspy);
-
-/*------------------------------------------------------------------*/
-/*
- * Prepare and send a Spy Threshold event
- */
-static void iw_send_thrspy_event(struct net_device *	dev,
-				 struct iw_spy_data *	spydata,
-				 unsigned char *	address,
-				 struct iw_quality *	wstats)
-{
-	union iwreq_data	wrqu;
-	struct iw_thrspy	threshold;
-
-	/* Init */
-	wrqu.data.length = 1;
-	wrqu.data.flags = 0;
-	/* Copy address */
-	memcpy(threshold.addr.sa_data, address, ETH_ALEN);
-	threshold.addr.sa_family = ARPHRD_ETHER;
-	/* Copy stats */
-	memcpy(&(threshold.qual), wstats, sizeof(struct iw_quality));
-	/* Copy also thresholds */
-	memcpy(&(threshold.low), &(spydata->spy_thr_low),
-	       2 * sizeof(struct iw_quality));
-
-	/* Send event to user space */
-	wireless_send_event(dev, SIOCGIWTHRSPY, &wrqu, (char *) &threshold);
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Call for the driver to update the spy data.
- * For now, the spy data is a simple array. As the size of the array is
- * small, this is good enough. If we wanted to support larger number of
- * spy addresses, we should use something more efficient...
- */
-void wireless_spy_update(struct net_device *	dev,
-			 unsigned char *	address,
-			 struct iw_quality *	wstats)
-{
-	struct iw_spy_data *	spydata = get_spydata(dev);
-	int			i;
-	int			match = -1;
-
-	/* Make sure driver is not buggy or using the old API */
-	if (!spydata)
-		return;
-
-	/* Update all records that match */
-	for (i = 0; i < spydata->spy_number; i++)
-		if (!compare_ether_addr(address, spydata->spy_address[i])) {
-			memcpy(&(spydata->spy_stat[i]), wstats,
-			       sizeof(struct iw_quality));
-			match = i;
-		}
-
-	/* Generate an event if we cross the spy threshold.
-	 * To avoid event storms, we have a simple hysteresis : we generate
-	 * event only when we go under the low threshold or above the
-	 * high threshold. */
-	if (match >= 0) {
-		if (spydata->spy_thr_under[match]) {
-			if (wstats->level > spydata->spy_thr_high.level) {
-				spydata->spy_thr_under[match] = 0;
-				iw_send_thrspy_event(dev, spydata,
-						     address, wstats);
-			}
-		} else {
-			if (wstats->level < spydata->spy_thr_low.level) {
-				spydata->spy_thr_under[match] = 1;
-				iw_send_thrspy_event(dev, spydata,
-						     address, wstats);
-			}
-		}
-	}
-}
-EXPORT_SYMBOL(wireless_spy_update);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-core.c	2009-09-29 23:25:18.000000000 +0200
@@ -0,0 +1,1063 @@
+/*
+ * This file implement the Wireless Extensions core API.
+ *
+ * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
+ * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
+ * Copyright	2009 Johannes Berg <johannes@sipsolutions.net>
+ *
+ * (As all part of the Linux kernel, this file is GPL)
+ */
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/wireless.h>
+#include <linux/uaccess.h>
+#include <net/cfg80211.h>
+#include <net/iw_handler.h>
+#include <net/netlink.h>
+#include <net/wext.h>
+#include <net/net_namespace.h>
+
+typedef int (*wext_ioctl_func)(struct net_device *, struct iwreq *,
+			       unsigned int, struct iw_request_info *,
+			       iw_handler);
+
+
+/*
+ * Meta-data about all the standard Wireless Extension request we
+ * know about.
+ */
+static const struct iw_ioctl_description standard_ioctl[] = {
+	[SIOCSIWCOMMIT	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_NULL,
+	},
+	[SIOCGIWNAME	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_CHAR,
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWNWID	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+		.flags		= IW_DESCR_FLAG_EVENT,
+	},
+	[SIOCGIWNWID	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWFREQ	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_FREQ,
+		.flags		= IW_DESCR_FLAG_EVENT,
+	},
+	[SIOCGIWFREQ	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_FREQ,
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWMODE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_UINT,
+		.flags		= IW_DESCR_FLAG_EVENT,
+	},
+	[SIOCGIWMODE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_UINT,
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWSENS	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWSENS	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWRANGE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_NULL,
+	},
+	[SIOCGIWRANGE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= sizeof(struct iw_range),
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWPRIV	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_NULL,
+	},
+	[SIOCGIWPRIV	- SIOCIWFIRST] = { /* (handled directly by us) */
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= sizeof(struct iw_priv_args),
+		.max_tokens	= 16,
+		.flags		= IW_DESCR_FLAG_NOMAX,
+	},
+	[SIOCSIWSTATS	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_NULL,
+	},
+	[SIOCGIWSTATS	- SIOCIWFIRST] = { /* (handled directly by us) */
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= sizeof(struct iw_statistics),
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWSPY	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= sizeof(struct sockaddr),
+		.max_tokens	= IW_MAX_SPY,
+	},
+	[SIOCGIWSPY	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= sizeof(struct sockaddr) +
+				  sizeof(struct iw_quality),
+		.max_tokens	= IW_MAX_SPY,
+	},
+	[SIOCSIWTHRSPY	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= sizeof(struct iw_thrspy),
+		.min_tokens	= 1,
+		.max_tokens	= 1,
+	},
+	[SIOCGIWTHRSPY	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= sizeof(struct iw_thrspy),
+		.min_tokens	= 1,
+		.max_tokens	= 1,
+	},
+	[SIOCSIWAP	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_ADDR,
+	},
+	[SIOCGIWAP	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_ADDR,
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWMLME	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.min_tokens	= sizeof(struct iw_mlme),
+		.max_tokens	= sizeof(struct iw_mlme),
+	},
+	[SIOCGIWAPLIST	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= sizeof(struct sockaddr) +
+				  sizeof(struct iw_quality),
+		.max_tokens	= IW_MAX_AP,
+		.flags		= IW_DESCR_FLAG_NOMAX,
+	},
+	[SIOCSIWSCAN	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.min_tokens	= 0,
+		.max_tokens	= sizeof(struct iw_scan_req),
+	},
+	[SIOCGIWSCAN	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_SCAN_MAX_DATA,
+		.flags		= IW_DESCR_FLAG_NOMAX,
+	},
+	[SIOCSIWESSID	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_ESSID_MAX_SIZE,
+		.flags		= IW_DESCR_FLAG_EVENT,
+	},
+	[SIOCGIWESSID	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_ESSID_MAX_SIZE,
+		.flags		= IW_DESCR_FLAG_DUMP,
+	},
+	[SIOCSIWNICKN	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_ESSID_MAX_SIZE,
+	},
+	[SIOCGIWNICKN	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_ESSID_MAX_SIZE,
+	},
+	[SIOCSIWRATE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWRATE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWRTS	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWRTS	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWFRAG	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWFRAG	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWTXPOW	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWTXPOW	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWRETRY	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWRETRY	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWENCODE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_ENCODING_TOKEN_MAX,
+		.flags		= IW_DESCR_FLAG_EVENT | IW_DESCR_FLAG_RESTRICT,
+	},
+	[SIOCGIWENCODE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_ENCODING_TOKEN_MAX,
+		.flags		= IW_DESCR_FLAG_DUMP | IW_DESCR_FLAG_RESTRICT,
+	},
+	[SIOCSIWPOWER	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWPOWER	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWGENIE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_GENERIC_IE_MAX,
+	},
+	[SIOCGIWGENIE	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_GENERIC_IE_MAX,
+	},
+	[SIOCSIWAUTH	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCGIWAUTH	- SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_PARAM,
+	},
+	[SIOCSIWENCODEEXT - SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.min_tokens	= sizeof(struct iw_encode_ext),
+		.max_tokens	= sizeof(struct iw_encode_ext) +
+				  IW_ENCODING_TOKEN_MAX,
+	},
+	[SIOCGIWENCODEEXT - SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.min_tokens	= sizeof(struct iw_encode_ext),
+		.max_tokens	= sizeof(struct iw_encode_ext) +
+				  IW_ENCODING_TOKEN_MAX,
+	},
+	[SIOCSIWPMKSA - SIOCIWFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.min_tokens	= sizeof(struct iw_pmksa),
+		.max_tokens	= sizeof(struct iw_pmksa),
+	},
+};
+static const unsigned standard_ioctl_num = ARRAY_SIZE(standard_ioctl);
+
+/*
+ * Meta-data about all the additional standard Wireless Extension events
+ * we know about.
+ */
+static const struct iw_ioctl_description standard_event[] = {
+	[IWEVTXDROP	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_ADDR,
+	},
+	[IWEVQUAL	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_QUAL,
+	},
+	[IWEVCUSTOM	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_CUSTOM_MAX,
+	},
+	[IWEVREGISTERED	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_ADDR,
+	},
+	[IWEVEXPIRED	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_ADDR,
+	},
+	[IWEVGENIE	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_GENERIC_IE_MAX,
+	},
+	[IWEVMICHAELMICFAILURE	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= sizeof(struct iw_michaelmicfailure),
+	},
+	[IWEVASSOCREQIE	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_GENERIC_IE_MAX,
+	},
+	[IWEVASSOCRESPIE	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= IW_GENERIC_IE_MAX,
+	},
+	[IWEVPMKIDCAND	- IWEVFIRST] = {
+		.header_type	= IW_HEADER_TYPE_POINT,
+		.token_size	= 1,
+		.max_tokens	= sizeof(struct iw_pmkid_cand),
+	},
+};
+static const unsigned standard_event_num = ARRAY_SIZE(standard_event);
+
+/* Size (in bytes) of various events */
+static const int event_type_size[] = {
+	IW_EV_LCP_LEN,			/* IW_HEADER_TYPE_NULL */
+	0,
+	IW_EV_CHAR_LEN,			/* IW_HEADER_TYPE_CHAR */
+	0,
+	IW_EV_UINT_LEN,			/* IW_HEADER_TYPE_UINT */
+	IW_EV_FREQ_LEN,			/* IW_HEADER_TYPE_FREQ */
+	IW_EV_ADDR_LEN,			/* IW_HEADER_TYPE_ADDR */
+	0,
+	IW_EV_POINT_LEN,		/* Without variable payload */
+	IW_EV_PARAM_LEN,		/* IW_HEADER_TYPE_PARAM */
+	IW_EV_QUAL_LEN,			/* IW_HEADER_TYPE_QUAL */
+};
+
+#ifdef CONFIG_COMPAT
+static const int compat_event_type_size[] = {
+	IW_EV_COMPAT_LCP_LEN,		/* IW_HEADER_TYPE_NULL */
+	0,
+	IW_EV_COMPAT_CHAR_LEN,		/* IW_HEADER_TYPE_CHAR */
+	0,
+	IW_EV_COMPAT_UINT_LEN,		/* IW_HEADER_TYPE_UINT */
+	IW_EV_COMPAT_FREQ_LEN,		/* IW_HEADER_TYPE_FREQ */
+	IW_EV_COMPAT_ADDR_LEN,		/* IW_HEADER_TYPE_ADDR */
+	0,
+	IW_EV_COMPAT_POINT_LEN,		/* Without variable payload */
+	IW_EV_COMPAT_PARAM_LEN,		/* IW_HEADER_TYPE_PARAM */
+	IW_EV_COMPAT_QUAL_LEN,		/* IW_HEADER_TYPE_QUAL */
+};
+#endif
+
+
+/* IW event code */
+
+static int __net_init wext_pernet_init(struct net *net)
+{
+	skb_queue_head_init(&net->wext_nlevents);
+	return 0;
+}
+
+static void __net_exit wext_pernet_exit(struct net *net)
+{
+	skb_queue_purge(&net->wext_nlevents);
+}
+
+static struct pernet_operations wext_pernet_ops = {
+	.init = wext_pernet_init,
+	.exit = wext_pernet_exit,
+};
+
+static int __init wireless_nlevent_init(void)
+{
+	return register_pernet_subsys(&wext_pernet_ops);
+}
+
+subsys_initcall(wireless_nlevent_init);
+
+/* Process events generated by the wireless layer or the driver. */
+static void wireless_nlevent_process(struct work_struct *work)
+{
+	struct sk_buff *skb;
+	struct net *net;
+
+	rtnl_lock();
+
+	for_each_net(net) {
+		while ((skb = skb_dequeue(&net->wext_nlevents)))
+			rtnl_notify(skb, net, 0, RTNLGRP_LINK, NULL,
+				    GFP_KERNEL);
+	}
+
+	rtnl_unlock();
+}
+
+static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
+
+static struct nlmsghdr *rtnetlink_ifinfo_prep(struct net_device *dev,
+					      struct sk_buff *skb)
+{
+	struct ifinfomsg *r;
+	struct nlmsghdr  *nlh;
+
+	nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*r), 0);
+	if (!nlh)
+		return NULL;
+
+	r = nlmsg_data(nlh);
+	r->ifi_family = AF_UNSPEC;
+	r->__ifi_pad = 0;
+	r->ifi_type = dev->type;
+	r->ifi_index = dev->ifindex;
+	r->ifi_flags = dev_get_flags(dev);
+	r->ifi_change = 0;	/* Wireless changes don't affect those flags */
+
+	NLA_PUT_STRING(skb, IFLA_IFNAME, dev->name);
+
+	return nlh;
+ nla_put_failure:
+	nlmsg_cancel(skb, nlh);
+	return NULL;
+}
+
+
+/*
+ * Main event dispatcher. Called from other parts and drivers.
+ * Send the event on the appropriate channels.
+ * May be called from interrupt context.
+ */
+void wireless_send_event(struct net_device *	dev,
+			 unsigned int		cmd,
+			 union iwreq_data *	wrqu,
+			 const char *		extra)
+{
+	const struct iw_ioctl_description *	descr = NULL;
+	int extra_len = 0;
+	struct iw_event  *event;		/* Mallocated whole event */
+	int event_len;				/* Its size */
+	int hdr_len;				/* Size of the event header */
+	int wrqu_off = 0;			/* Offset in wrqu */
+	/* Don't "optimise" the following variable, it will crash */
+	unsigned	cmd_index;		/* *MUST* be unsigned */
+	struct sk_buff *skb;
+	struct nlmsghdr *nlh;
+	struct nlattr *nla;
+#ifdef CONFIG_COMPAT
+	struct __compat_iw_event *compat_event;
+	struct compat_iw_point compat_wrqu;
+	struct sk_buff *compskb;
+#endif
+
+	/*
+	 * Nothing in the kernel sends scan events with data, be safe.
+	 * This is necessary because we cannot fix up scan event data
+	 * for compat, due to being contained in 'extra', but normally
+	 * applications are required to retrieve the scan data anyway
+	 * and no data is included in the event, this codifies that
+	 * practice.
+	 */
+	if (WARN_ON(cmd == SIOCGIWSCAN && extra))
+		extra = NULL;
+
+	/* Get the description of the Event */
+	if (cmd <= SIOCIWLAST) {
+		cmd_index = cmd - SIOCIWFIRST;
+		if (cmd_index < standard_ioctl_num)
+			descr = &(standard_ioctl[cmd_index]);
+	} else {
+		cmd_index = cmd - IWEVFIRST;
+		if (cmd_index < standard_event_num)
+			descr = &(standard_event[cmd_index]);
+	}
+	/* Don't accept unknown events */
+	if (descr == NULL) {
+		/* Note : we don't return an error to the driver, because
+		 * the driver would not know what to do about it. It can't
+		 * return an error to the user, because the event is not
+		 * initiated by a user request.
+		 * The best the driver could do is to log an error message.
+		 * We will do it ourselves instead...
+		 */
+		printk(KERN_ERR "%s (WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
+		       dev->name, cmd);
+		return;
+	}
+
+	/* Check extra parameters and set extra_len */
+	if (descr->header_type == IW_HEADER_TYPE_POINT) {
+		/* Check if number of token fits within bounds */
+		if (wrqu->data.length > descr->max_tokens) {
+			printk(KERN_ERR "%s (WE) : Wireless Event too big (%d)\n", dev->name, wrqu->data.length);
+			return;
+		}
+		if (wrqu->data.length < descr->min_tokens) {
+			printk(KERN_ERR "%s (WE) : Wireless Event too small (%d)\n", dev->name, wrqu->data.length);
+			return;
+		}
+		/* Calculate extra_len - extra is NULL for restricted events */
+		if (extra != NULL)
+			extra_len = wrqu->data.length * descr->token_size;
+		/* Always at an offset in wrqu */
+		wrqu_off = IW_EV_POINT_OFF;
+	}
+
+	/* Total length of the event */
+	hdr_len = event_type_size[descr->header_type];
+	event_len = hdr_len + extra_len;
+
+	/*
+	 * The problem for 64/32 bit.
+	 *
+	 * On 64-bit, a regular event is laid out as follows:
+	 *      |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
+	 *      | event.len | event.cmd |     p a d d i n g     |
+	 *      | wrqu data ... (with the correct size)         |
+	 *
+	 * This padding exists because we manipulate event->u,
+	 * and 'event' is not packed.
+	 *
+	 * An iw_point event is laid out like this instead:
+	 *      |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |
+	 *      | event.len | event.cmd |     p a d d i n g     |
+	 *      | iwpnt.len | iwpnt.flg |     p a d d i n g     |
+	 *      | extra data  ...
+	 *
+	 * The second padding exists because struct iw_point is extended,
+	 * but this depends on the platform...
+	 *
+	 * On 32-bit, all the padding shouldn't be there.
+	 */
+
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	/* Send via the RtNetlink event channel */
+	nlh = rtnetlink_ifinfo_prep(dev, skb);
+	if (WARN_ON(!nlh)) {
+		kfree_skb(skb);
+		return;
+	}
+
+	/* Add the wireless events in the netlink packet */
+	nla = nla_reserve(skb, IFLA_WIRELESS, event_len);
+	if (!nla) {
+		kfree_skb(skb);
+		return;
+	}
+	event = nla_data(nla);
+
+	/* Fill event - first clear to avoid data leaking */
+	memset(event, 0, hdr_len);
+	event->len = event_len;
+	event->cmd = cmd;
+	memcpy(&event->u, ((char *) wrqu) + wrqu_off, hdr_len - IW_EV_LCP_LEN);
+	if (extra_len)
+		memcpy(((char *) event) + hdr_len, extra, extra_len);
+
+	nlmsg_end(skb, nlh);
+#ifdef CONFIG_COMPAT
+	hdr_len = compat_event_type_size[descr->header_type];
+	event_len = hdr_len + extra_len;
+
+	compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	if (!compskb) {
+		kfree_skb(skb);
+		return;
+	}
+
+	/* Send via the RtNetlink event channel */
+	nlh = rtnetlink_ifinfo_prep(dev, compskb);
+	if (WARN_ON(!nlh)) {
+		kfree_skb(skb);
+		kfree_skb(compskb);
+		return;
+	}
+
+	/* Add the wireless events in the netlink packet */
+	nla = nla_reserve(compskb, IFLA_WIRELESS, event_len);
+	if (!nla) {
+		kfree_skb(skb);
+		kfree_skb(compskb);
+		return;
+	}
+	compat_event = nla_data(nla);
+
+	compat_event->len = event_len;
+	compat_event->cmd = cmd;
+	if (descr->header_type == IW_HEADER_TYPE_POINT) {
+		compat_wrqu.length = wrqu->data.length;
+		compat_wrqu.flags = wrqu->data.flags;
+		memcpy(&compat_event->pointer,
+			((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
+			hdr_len - IW_EV_COMPAT_LCP_LEN);
+		if (extra_len)
+			memcpy(((char *) compat_event) + hdr_len,
+				extra, extra_len);
+	} else {
+		/* extra_len must be zero, so no if (extra) needed */
+		memcpy(&compat_event->pointer, wrqu,
+			hdr_len - IW_EV_COMPAT_LCP_LEN);
+	}
+
+	nlmsg_end(compskb, nlh);
+
+	skb_shinfo(skb)->frag_list = compskb;
+#endif
+	skb_queue_tail(&dev_net(dev)->wext_nlevents, skb);
+	schedule_work(&wireless_nlevent_work);
+}
+EXPORT_SYMBOL(wireless_send_event);
+
+
+
+/* IW handlers */
+
+struct iw_statistics *get_wireless_stats(struct net_device *dev)
+{
+#ifdef CONFIG_WIRELESS_EXT
+	if ((dev->wireless_handlers != NULL) &&
+	   (dev->wireless_handlers->get_wireless_stats != NULL))
+		return dev->wireless_handlers->get_wireless_stats(dev);
+#endif
+
+#ifdef CONFIG_CFG80211_WEXT
+	if (dev->ieee80211_ptr && dev->ieee80211_ptr &&
+	    dev->ieee80211_ptr->wiphy &&
+	    dev->ieee80211_ptr->wiphy->wext &&
+	    dev->ieee80211_ptr->wiphy->wext->get_wireless_stats)
+		return dev->ieee80211_ptr->wiphy->wext->get_wireless_stats(dev);
+#endif
+
+	/* not found */
+	return NULL;
+}
+
+static int iw_handler_get_iwstats(struct net_device *		dev,
+				  struct iw_request_info *	info,
+				  union iwreq_data *		wrqu,
+				  char *			extra)
+{
+	/* Get stats from the driver */
+	struct iw_statistics *stats;
+
+	stats = get_wireless_stats(dev);
+	if (stats) {
+		/* Copy statistics to extra */
+		memcpy(extra, stats, sizeof(struct iw_statistics));
+		wrqu->data.length = sizeof(struct iw_statistics);
+
+		/* Check if we need to clear the updated flag */
+		if (wrqu->data.flags != 0)
+			stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
+		return 0;
+	} else
+		return -EOPNOTSUPP;
+}
+
+static iw_handler get_handler(struct net_device *dev, unsigned int cmd)
+{
+	/* Don't "optimise" the following variable, it will crash */
+	unsigned int	index;		/* *MUST* be unsigned */
+	const struct iw_handler_def *handlers = NULL;
+
+#ifdef CONFIG_CFG80211_WEXT
+	if (dev->ieee80211_ptr && dev->ieee80211_ptr->wiphy)
+		handlers = dev->ieee80211_ptr->wiphy->wext;
+#endif
+#ifdef CONFIG_WIRELESS_EXT
+	if (dev->wireless_handlers)
+		handlers = dev->wireless_handlers;
+#endif
+
+	if (!handlers)
+		return NULL;
+
+	/* Try as a standard command */
+	index = cmd - SIOCIWFIRST;
+	if (index < handlers->num_standard)
+		return handlers->standard[index];
+
+#ifdef CONFIG_WEXT_PRIV
+	/* Try as a private command */
+	index = cmd - SIOCIWFIRSTPRIV;
+	if (index < handlers->num_private)
+		return handlers->private[index];
+#endif
+
+	/* Not found */
+	return NULL;
+}
+
+static int ioctl_standard_iw_point(struct iw_point *iwp, unsigned int cmd,
+				   const struct iw_ioctl_description *descr,
+				   iw_handler handler, struct net_device *dev,
+				   struct iw_request_info *info)
+{
+	int err, extra_size, user_length = 0, essid_compat = 0;
+	char *extra;
+
+	/* Calculate space needed by arguments. Always allocate
+	 * for max space.
+	 */
+	extra_size = descr->max_tokens * descr->token_size;
+
+	/* Check need for ESSID compatibility for WE < 21 */
+	switch (cmd) {
+	case SIOCSIWESSID:
+	case SIOCGIWESSID:
+	case SIOCSIWNICKN:
+	case SIOCGIWNICKN:
+		if (iwp->length == descr->max_tokens + 1)
+			essid_compat = 1;
+		else if (IW_IS_SET(cmd) && (iwp->length != 0)) {
+			char essid[IW_ESSID_MAX_SIZE + 1];
+			unsigned int len;
+			len = iwp->length * descr->token_size;
+
+			if (len > IW_ESSID_MAX_SIZE)
+				return -EFAULT;
+
+			err = copy_from_user(essid, iwp->pointer, len);
+			if (err)
+				return -EFAULT;
+
+			if (essid[iwp->length - 1] == '\0')
+				essid_compat = 1;
+		}
+		break;
+	default:
+		break;
+	}
+
+	iwp->length -= essid_compat;
+
+	/* Check what user space is giving us */
+	if (IW_IS_SET(cmd)) {
+		/* Check NULL pointer */
+		if (!iwp->pointer && iwp->length != 0)
+			return -EFAULT;
+		/* Check if number of token fits within bounds */
+		if (iwp->length > descr->max_tokens)
+			return -E2BIG;
+		if (iwp->length < descr->min_tokens)
+			return -EINVAL;
+	} else {
+		/* Check NULL pointer */
+		if (!iwp->pointer)
+			return -EFAULT;
+		/* Save user space buffer size for checking */
+		user_length = iwp->length;
+
+		/* Don't check if user_length > max to allow forward
+		 * compatibility. The test user_length < min is
+		 * implied by the test at the end.
+		 */
+
+		/* Support for very large requests */
+		if ((descr->flags & IW_DESCR_FLAG_NOMAX) &&
+		    (user_length > descr->max_tokens)) {
+			/* Allow userspace to GET more than max so
+			 * we can support any size GET requests.
+			 * There is still a limit : -ENOMEM.
+			 */
+			extra_size = user_length * descr->token_size;
+
+			/* Note : user_length is originally a __u16,
+			 * and token_size is controlled by us,
+			 * so extra_size won't get negative and
+			 * won't overflow...
+			 */
+		}
+	}
+
+	/* kzalloc() ensures NULL-termination for essid_compat. */
+	extra = kzalloc(extra_size, GFP_KERNEL);
+	if (!extra)
+		return -ENOMEM;
+
+	/* If it is a SET, get all the extra data in here */
+	if (IW_IS_SET(cmd) && (iwp->length != 0)) {
+		if (copy_from_user(extra, iwp->pointer,
+				   iwp->length *
+				   descr->token_size)) {
+			err = -EFAULT;
+			goto out;
+		}
+
+		if (cmd == SIOCSIWENCODEEXT) {
+			struct iw_encode_ext *ee = (void *) extra;
+
+			if (iwp->length < sizeof(*ee) + ee->key_len)
+				return -EFAULT;
+		}
+	}
+
+	err = handler(dev, info, (union iwreq_data *) iwp, extra);
+
+	iwp->length += essid_compat;
+
+	/* If we have something to return to the user */
+	if (!err && IW_IS_GET(cmd)) {
+		/* Check if there is enough buffer up there */
+		if (user_length < iwp->length) {
+			err = -E2BIG;
+			goto out;
+		}
+
+		if (copy_to_user(iwp->pointer, extra,
+				 iwp->length *
+				 descr->token_size)) {
+			err = -EFAULT;
+			goto out;
+		}
+	}
+
+	/* Generate an event to notify listeners of the change */
+	if ((descr->flags & IW_DESCR_FLAG_EVENT) && err == -EIWCOMMIT) {
+		union iwreq_data *data = (union iwreq_data *) iwp;
+
+		if (descr->flags & IW_DESCR_FLAG_RESTRICT)
+			/* If the event is restricted, don't
+			 * export the payload.
+			 */
+			wireless_send_event(dev, cmd, data, NULL);
+		else
+			wireless_send_event(dev, cmd, data, extra);
+	}
+
+out:
+	kfree(extra);
+	return err;
+}
+
+/*
+ * Call the commit handler in the driver
+ * (if exist and if conditions are right)
+ *
+ * Note : our current commit strategy is currently pretty dumb,
+ * but we will be able to improve on that...
+ * The goal is to try to agreagate as many changes as possible
+ * before doing the commit. Drivers that will define a commit handler
+ * are usually those that need a reset after changing parameters, so
+ * we want to minimise the number of reset.
+ * A cool idea is to use a timer : at each "set" command, we re-set the
+ * timer, when the timer eventually fires, we call the driver.
+ * Hopefully, more on that later.
+ *
+ * Also, I'm waiting to see how many people will complain about the
+ * netif_running(dev) test. I'm open on that one...
+ * Hopefully, the driver will remember to do a commit in "open()" ;-)
+ */
+int call_commit_handler(struct net_device *dev)
+{
+#ifdef CONFIG_WIRELESS_EXT
+	if ((netif_running(dev)) &&
+	   (dev->wireless_handlers->standard[0] != NULL))
+		/* Call the commit handler on the driver */
+		return dev->wireless_handlers->standard[0](dev, NULL,
+							   NULL, NULL);
+	else
+		return 0;		/* Command completed successfully */
+#else
+	/* cfg80211 has no commit */
+	return 0;
+#endif
+}
+
+/*
+ * Main IOCTl dispatcher.
+ * Check the type of IOCTL and call the appropriate wrapper...
+ */
+static int wireless_process_ioctl(struct net *net, struct ifreq *ifr,
+				  unsigned int cmd,
+				  struct iw_request_info *info,
+				  wext_ioctl_func standard,
+				  wext_ioctl_func private)
+{
+	struct iwreq *iwr = (struct iwreq *) ifr;
+	struct net_device *dev;
+	iw_handler	handler;
+
+	/* Permissions are already checked in dev_ioctl() before calling us.
+	 * The copy_to/from_user() of ifr is also dealt with in there */
+
+	/* Make sure the device exist */
+	if ((dev = __dev_get_by_name(net, ifr->ifr_name)) == NULL)
+		return -ENODEV;
+
+	/* A bunch of special cases, then the generic case...
+	 * Note that 'cmd' is already filtered in dev_ioctl() with
+	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
+	if (cmd == SIOCGIWSTATS)
+		return standard(dev, iwr, cmd, info,
+				&iw_handler_get_iwstats);
+
+#ifdef CONFIG_WEXT_PRIV
+	if (cmd == SIOCGIWPRIV && dev->wireless_handlers)
+		return standard(dev, iwr, cmd, info,
+				iw_handler_get_private);
+#endif
+
+	/* Basic check */
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	/* New driver API : try to find the handler */
+	handler = get_handler(dev, cmd);
+	if (handler) {
+		/* Standard and private are not the same */
+		if (cmd < SIOCIWFIRSTPRIV)
+			return standard(dev, iwr, cmd, info, handler);
+		else if (private)
+			return private(dev, iwr, cmd, info, handler);
+	}
+	/* Old driver API : call driver ioctl handler */
+	if (dev->netdev_ops->ndo_do_ioctl)
+		return dev->netdev_ops->ndo_do_ioctl(dev, ifr, cmd);
+	return -EOPNOTSUPP;
+}
+
+/* If command is `set a parameter', or `get the encoding parameters',
+ * check if the user has the right to do it.
+ */
+static int wext_permission_check(unsigned int cmd)
+{
+	if ((IW_IS_SET(cmd) || cmd == SIOCGIWENCODE || cmd == SIOCGIWENCODEEXT)
+	    && !capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	return 0;
+}
+
+/* entry point from dev ioctl */
+static int wext_ioctl_dispatch(struct net *net, struct ifreq *ifr,
+			       unsigned int cmd, struct iw_request_info *info,
+			       wext_ioctl_func standard,
+			       wext_ioctl_func private)
+{
+	int ret = wext_permission_check(cmd);
+
+	if (ret)
+		return ret;
+
+	dev_load(net, ifr->ifr_name);
+	rtnl_lock();
+	ret = wireless_process_ioctl(net, ifr, cmd, info, standard, private);
+	rtnl_unlock();
+
+	return ret;
+}
+
+/*
+ * Wrapper to call a standard Wireless Extension handler.
+ * We do various checks and also take care of moving data between
+ * user space and kernel space.
+ */
+static int ioctl_standard_call(struct net_device *	dev,
+			       struct iwreq		*iwr,
+			       unsigned int		cmd,
+			       struct iw_request_info	*info,
+			       iw_handler		handler)
+{
+	const struct iw_ioctl_description *	descr;
+	int					ret = -EINVAL;
+
+	/* Get the description of the IOCTL */
+	if ((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+		return -EOPNOTSUPP;
+	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+
+	/* Check if we have a pointer to user space data or not */
+	if (descr->header_type != IW_HEADER_TYPE_POINT) {
+
+		/* No extra arguments. Trivial to handle */
+		ret = handler(dev, info, &(iwr->u), NULL);
+
+		/* Generate an event to notify listeners of the change */
+		if ((descr->flags & IW_DESCR_FLAG_EVENT) &&
+		   ((ret == 0) || (ret == -EIWCOMMIT)))
+			wireless_send_event(dev, cmd, &(iwr->u), NULL);
+	} else {
+		ret = ioctl_standard_iw_point(&iwr->u.data, cmd, descr,
+					      handler, dev, info);
+	}
+
+	/* Call commit handler if needed and defined */
+	if (ret == -EIWCOMMIT)
+		ret = call_commit_handler(dev);
+
+	/* Here, we will generate the appropriate event if needed */
+
+	return ret;
+}
+
+
+int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
+		      void __user *arg)
+{
+	struct iw_request_info info = { .cmd = cmd, .flags = 0 };
+	int ret;
+
+	ret = wext_ioctl_dispatch(net, ifr, cmd, &info,
+				  ioctl_standard_call,
+				  ioctl_private_call);
+	if (ret >= 0 &&
+	    IW_IS_GET(cmd) &&
+	    copy_to_user(arg, ifr, sizeof(struct iwreq)))
+		return -EFAULT;
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static int compat_standard_call(struct net_device	*dev,
+				struct iwreq		*iwr,
+				unsigned int		cmd,
+				struct iw_request_info	*info,
+				iw_handler		handler)
+{
+	const struct iw_ioctl_description *descr;
+	struct compat_iw_point *iwp_compat;
+	struct iw_point iwp;
+	int err;
+
+	descr = standard_ioctl + (cmd - SIOCIWFIRST);
+
+	if (descr->header_type != IW_HEADER_TYPE_POINT)
+		return ioctl_standard_call(dev, iwr, cmd, info, handler);
+
+	iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+	iwp.pointer = compat_ptr(iwp_compat->pointer);
+	iwp.length = iwp_compat->length;
+	iwp.flags = iwp_compat->flags;
+
+	err = ioctl_standard_iw_point(&iwp, cmd, descr, handler, dev, info);
+
+	iwp_compat->pointer = ptr_to_compat(iwp.pointer);
+	iwp_compat->length = iwp.length;
+	iwp_compat->flags = iwp.flags;
+
+	return err;
+}
+
+int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
+			     unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct iw_request_info info;
+	struct iwreq iwr;
+	char *colon;
+	int ret;
+
+	if (copy_from_user(&iwr, argp, sizeof(struct iwreq)))
+		return -EFAULT;
+
+	iwr.ifr_name[IFNAMSIZ-1] = 0;
+	colon = strchr(iwr.ifr_name, ':');
+	if (colon)
+		*colon = 0;
+
+	info.cmd = cmd;
+	info.flags = IW_REQUEST_FLAG_COMPAT;
+
+	ret = wext_ioctl_dispatch(net, (struct ifreq *) &iwr, cmd, &info,
+				  compat_standard_call,
+				  compat_private_call);
+
+	if (ret >= 0 &&
+	    IW_IS_GET(cmd) &&
+	    copy_to_user(argp, &iwr, sizeof(struct iwreq)))
+		return -EFAULT;
+
+	return ret;
+}
+#endif
--- wireless-testing.orig/include/net/wext.h	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/include/net/wext.h	2009-09-29 23:25:18.000000000 +0200
@@ -1,29 +1,19 @@
 #ifndef __NET_WEXT_H
 #define __NET_WEXT_H
 
-/*
- * wireless extensions interface to the core code
- */
+#include <net/iw_handler.h>
 
 struct net;
 
-#ifdef CONFIG_WIRELESS_EXT
-extern int wext_proc_init(struct net *net);
-extern void wext_proc_exit(struct net *net);
+#ifdef CONFIG_WEXT_CORE
 extern int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
 			     void __user *arg);
 extern int compat_wext_handle_ioctl(struct net *net, unsigned int cmd,
 				    unsigned long arg);
+
 extern struct iw_statistics *get_wireless_stats(struct net_device *dev);
+extern int call_commit_handler(struct net_device *dev);
 #else
-static inline int wext_proc_init(struct net *net)
-{
-	return 0;
-}
-static inline void wext_proc_exit(struct net *net)
-{
-	return;
-}
 static inline int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
 				    void __user *arg)
 {
@@ -36,4 +26,35 @@ static inline int compat_wext_handle_ioc
 }
 #endif
 
+#ifdef CONFIG_WEXT_PROC
+extern int wext_proc_init(struct net *net);
+extern void wext_proc_exit(struct net *net);
+#else
+static inline int wext_proc_init(struct net *net)
+{
+	return 0;
+}
+static inline void wext_proc_exit(struct net *net)
+{
+	return;
+}
+#endif
+
+#ifdef CONFIG_WEXT_PRIV
+int ioctl_private_call(struct net_device *dev, struct iwreq *iwr,
+		       unsigned int cmd, struct iw_request_info *info,
+		       iw_handler handler);
+int compat_private_call(struct net_device *dev, struct iwreq *iwr,
+			unsigned int cmd, struct iw_request_info *info,
+			iw_handler handler);
+int iw_handler_get_private(struct net_device *		dev,
+			   struct iw_request_info *	info,
+			   union iwreq_data *		wrqu,
+			   char *			extra);
+#else
+#define ioctl_private_call NULL
+#define compat_private_call NULL
+#endif
+
+
 #endif /* __NET_WEXT_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-proc.c	2009-09-29 23:25:18.000000000 +0200
@@ -0,0 +1,155 @@
+/*
+ * This file implement the Wireless Extensions proc API.
+ *
+ * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
+ * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
+ *
+ * (As all part of the Linux kernel, this file is GPL)
+ */
+
+/*
+ * The /proc/net/wireless file is a human readable user-space interface
+ * exporting various wireless specific statistics from the wireless devices.
+ * This is the most popular part of the Wireless Extensions ;-)
+ *
+ * This interface is a pure clone of /proc/net/dev (in net/core/dev.c).
+ * The content of the file is basically the content of "struct iw_statistics".
+ */
+
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/wireless.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <net/iw_handler.h>
+#include <net/wext.h>
+
+
+static void wireless_seq_printf_stats(struct seq_file *seq,
+				      struct net_device *dev)
+{
+	/* Get stats from the driver */
+	struct iw_statistics *stats = get_wireless_stats(dev);
+	static struct iw_statistics nullstats = {};
+
+	/* show device if it's wireless regardless of current stats */
+	if (!stats) {
+#ifdef CONFIG_WIRELESS_EXT
+		if (dev->wireless_handlers)
+			stats = &nullstats;
+#endif
+#ifdef CONFIG_CFG80211
+		if (dev->ieee80211_ptr)
+			stats = &nullstats;
+#endif
+	}
+
+	if (stats) {
+		seq_printf(seq, "%6s: %04x  %3d%c  %3d%c  %3d%c  %6d %6d %6d "
+				"%6d %6d   %6d\n",
+			   dev->name, stats->status, stats->qual.qual,
+			   stats->qual.updated & IW_QUAL_QUAL_UPDATED
+			   ? '.' : ' ',
+			   ((__s32) stats->qual.level) -
+			   ((stats->qual.updated & IW_QUAL_DBM) ? 0x100 : 0),
+			   stats->qual.updated & IW_QUAL_LEVEL_UPDATED
+			   ? '.' : ' ',
+			   ((__s32) stats->qual.noise) -
+			   ((stats->qual.updated & IW_QUAL_DBM) ? 0x100 : 0),
+			   stats->qual.updated & IW_QUAL_NOISE_UPDATED
+			   ? '.' : ' ',
+			   stats->discard.nwid, stats->discard.code,
+			   stats->discard.fragment, stats->discard.retries,
+			   stats->discard.misc, stats->miss.beacon);
+
+		if (stats != &nullstats)
+			stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
+	}
+}
+
+/* ---------------------------------------------------------------- */
+/*
+ * Print info for /proc/net/wireless (print all entries)
+ */
+static int wireless_dev_seq_show(struct seq_file *seq, void *v)
+{
+	might_sleep();
+
+	if (v == SEQ_START_TOKEN)
+		seq_printf(seq, "Inter-| sta-|   Quality        |   Discarded "
+				"packets               | Missed | WE\n"
+				" face | tus | link level noise |  nwid  "
+				"crypt   frag  retry   misc | beacon | %d\n",
+			   WIRELESS_EXT);
+	else
+		wireless_seq_printf_stats(seq, v);
+	return 0;
+}
+
+static void *wireless_dev_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+	loff_t off;
+	struct net_device *dev;
+
+	rtnl_lock();
+	if (!*pos)
+		return SEQ_START_TOKEN;
+
+	off = 1;
+	for_each_netdev(net, dev)
+		if (off++ == *pos)
+			return dev;
+	return NULL;
+}
+
+static void *wireless_dev_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct net *net = seq_file_net(seq);
+
+	++*pos;
+
+	return v == SEQ_START_TOKEN ?
+		first_net_device(net) : next_net_device(v);
+}
+
+static void wireless_dev_seq_stop(struct seq_file *seq, void *v)
+{
+	rtnl_unlock();
+}
+
+static const struct seq_operations wireless_seq_ops = {
+	.start = wireless_dev_seq_start,
+	.next  = wireless_dev_seq_next,
+	.stop  = wireless_dev_seq_stop,
+	.show  = wireless_dev_seq_show,
+};
+
+static int seq_open_wireless(struct inode *inode, struct file *file)
+{
+	return seq_open_net(inode, file, &wireless_seq_ops,
+			    sizeof(struct seq_net_private));
+}
+
+static const struct file_operations wireless_seq_fops = {
+	.owner	 = THIS_MODULE,
+	.open    = seq_open_wireless,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release_net,
+};
+
+int wext_proc_init(struct net *net)
+{
+	/* Create /proc/net/wireless entry */
+	if (!proc_net_fops_create(net, "wireless", S_IRUGO, &wireless_seq_fops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+void wext_proc_exit(struct net *net)
+{
+	proc_net_remove(net, "wireless");
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-spy.c	2009-09-29 23:25:18.000000000 +0200
@@ -0,0 +1,231 @@
+/*
+ * This file implement the Wireless Extensions spy API.
+ *
+ * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
+ * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
+ *
+ * (As all part of the Linux kernel, this file is GPL)
+ */
+
+#include <linux/wireless.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <net/iw_handler.h>
+#include <net/arp.h>
+#include <net/wext.h>
+
+static inline struct iw_spy_data *get_spydata(struct net_device *dev)
+{
+	/* This is the new way */
+	if (dev->wireless_data)
+		return dev->wireless_data->spy_data;
+	return NULL;
+}
+
+int iw_handler_set_spy(struct net_device *	dev,
+		       struct iw_request_info *	info,
+		       union iwreq_data *	wrqu,
+		       char *			extra)
+{
+	struct iw_spy_data *	spydata = get_spydata(dev);
+	struct sockaddr *	address = (struct sockaddr *) extra;
+
+	/* Make sure driver is not buggy or using the old API */
+	if (!spydata)
+		return -EOPNOTSUPP;
+
+	/* Disable spy collection while we copy the addresses.
+	 * While we copy addresses, any call to wireless_spy_update()
+	 * will NOP. This is OK, as anyway the addresses are changing. */
+	spydata->spy_number = 0;
+
+	/* We want to operate without locking, because wireless_spy_update()
+	 * most likely will happen in the interrupt handler, and therefore
+	 * have its own locking constraints and needs performance.
+	 * The rtnl_lock() make sure we don't race with the other iw_handlers.
+	 * This make sure wireless_spy_update() "see" that the spy list
+	 * is temporarily disabled. */
+	smp_wmb();
+
+	/* Are there are addresses to copy? */
+	if (wrqu->data.length > 0) {
+		int i;
+
+		/* Copy addresses */
+		for (i = 0; i < wrqu->data.length; i++)
+			memcpy(spydata->spy_address[i], address[i].sa_data,
+			       ETH_ALEN);
+		/* Reset stats */
+		memset(spydata->spy_stat, 0,
+		       sizeof(struct iw_quality) * IW_MAX_SPY);
+	}
+
+	/* Make sure above is updated before re-enabling */
+	smp_wmb();
+
+	/* Enable addresses */
+	spydata->spy_number = wrqu->data.length;
+
+	return 0;
+}
+EXPORT_SYMBOL(iw_handler_set_spy);
+
+int iw_handler_get_spy(struct net_device *	dev,
+		       struct iw_request_info *	info,
+		       union iwreq_data *	wrqu,
+		       char *			extra)
+{
+	struct iw_spy_data *	spydata = get_spydata(dev);
+	struct sockaddr *	address = (struct sockaddr *) extra;
+	int			i;
+
+	/* Make sure driver is not buggy or using the old API */
+	if (!spydata)
+		return -EOPNOTSUPP;
+
+	wrqu->data.length = spydata->spy_number;
+
+	/* Copy addresses. */
+	for (i = 0; i < spydata->spy_number; i++) 	{
+		memcpy(address[i].sa_data, spydata->spy_address[i], ETH_ALEN);
+		address[i].sa_family = AF_UNIX;
+	}
+	/* Copy stats to the user buffer (just after). */
+	if (spydata->spy_number > 0)
+		memcpy(extra  + (sizeof(struct sockaddr) *spydata->spy_number),
+		       spydata->spy_stat,
+		       sizeof(struct iw_quality) * spydata->spy_number);
+	/* Reset updated flags. */
+	for (i = 0; i < spydata->spy_number; i++)
+		spydata->spy_stat[i].updated &= ~IW_QUAL_ALL_UPDATED;
+	return 0;
+}
+EXPORT_SYMBOL(iw_handler_get_spy);
+
+/*------------------------------------------------------------------*/
+/*
+ * Standard Wireless Handler : set spy threshold
+ */
+int iw_handler_set_thrspy(struct net_device *	dev,
+			  struct iw_request_info *info,
+			  union iwreq_data *	wrqu,
+			  char *		extra)
+{
+	struct iw_spy_data *	spydata = get_spydata(dev);
+	struct iw_thrspy *	threshold = (struct iw_thrspy *) extra;
+
+	/* Make sure driver is not buggy or using the old API */
+	if (!spydata)
+		return -EOPNOTSUPP;
+
+	/* Just do it */
+	memcpy(&(spydata->spy_thr_low), &(threshold->low),
+	       2 * sizeof(struct iw_quality));
+
+	/* Clear flag */
+	memset(spydata->spy_thr_under, '\0', sizeof(spydata->spy_thr_under));
+
+	return 0;
+}
+EXPORT_SYMBOL(iw_handler_set_thrspy);
+
+/*------------------------------------------------------------------*/
+/*
+ * Standard Wireless Handler : get spy threshold
+ */
+int iw_handler_get_thrspy(struct net_device *	dev,
+			  struct iw_request_info *info,
+			  union iwreq_data *	wrqu,
+			  char *		extra)
+{
+	struct iw_spy_data *	spydata = get_spydata(dev);
+	struct iw_thrspy *	threshold = (struct iw_thrspy *) extra;
+
+	/* Make sure driver is not buggy or using the old API */
+	if (!spydata)
+		return -EOPNOTSUPP;
+
+	/* Just do it */
+	memcpy(&(threshold->low), &(spydata->spy_thr_low),
+	       2 * sizeof(struct iw_quality));
+
+	return 0;
+}
+EXPORT_SYMBOL(iw_handler_get_thrspy);
+
+/*------------------------------------------------------------------*/
+/*
+ * Prepare and send a Spy Threshold event
+ */
+static void iw_send_thrspy_event(struct net_device *	dev,
+				 struct iw_spy_data *	spydata,
+				 unsigned char *	address,
+				 struct iw_quality *	wstats)
+{
+	union iwreq_data	wrqu;
+	struct iw_thrspy	threshold;
+
+	/* Init */
+	wrqu.data.length = 1;
+	wrqu.data.flags = 0;
+	/* Copy address */
+	memcpy(threshold.addr.sa_data, address, ETH_ALEN);
+	threshold.addr.sa_family = ARPHRD_ETHER;
+	/* Copy stats */
+	memcpy(&(threshold.qual), wstats, sizeof(struct iw_quality));
+	/* Copy also thresholds */
+	memcpy(&(threshold.low), &(spydata->spy_thr_low),
+	       2 * sizeof(struct iw_quality));
+
+	/* Send event to user space */
+	wireless_send_event(dev, SIOCGIWTHRSPY, &wrqu, (char *) &threshold);
+}
+
+/* ---------------------------------------------------------------- */
+/*
+ * Call for the driver to update the spy data.
+ * For now, the spy data is a simple array. As the size of the array is
+ * small, this is good enough. If we wanted to support larger number of
+ * spy addresses, we should use something more efficient...
+ */
+void wireless_spy_update(struct net_device *	dev,
+			 unsigned char *	address,
+			 struct iw_quality *	wstats)
+{
+	struct iw_spy_data *	spydata = get_spydata(dev);
+	int			i;
+	int			match = -1;
+
+	/* Make sure driver is not buggy or using the old API */
+	if (!spydata)
+		return;
+
+	/* Update all records that match */
+	for (i = 0; i < spydata->spy_number; i++)
+		if (!compare_ether_addr(address, spydata->spy_address[i])) {
+			memcpy(&(spydata->spy_stat[i]), wstats,
+			       sizeof(struct iw_quality));
+			match = i;
+		}
+
+	/* Generate an event if we cross the spy threshold.
+	 * To avoid event storms, we have a simple hysteresis : we generate
+	 * event only when we go under the low threshold or above the
+	 * high threshold. */
+	if (match >= 0) {
+		if (spydata->spy_thr_under[match]) {
+			if (wstats->level > spydata->spy_thr_high.level) {
+				spydata->spy_thr_under[match] = 0;
+				iw_send_thrspy_event(dev, spydata,
+						     address, wstats);
+			}
+		} else {
+			if (wstats->level < spydata->spy_thr_low.level) {
+				spydata->spy_thr_under[match] = 1;
+				iw_send_thrspy_event(dev, spydata,
+						     address, wstats);
+			}
+		}
+	}
+}
+EXPORT_SYMBOL(wireless_spy_update);
--- wireless-testing.orig/drivers/net/wireless/Kconfig	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/Kconfig	2009-09-29 23:25:18.000000000 +0200
@@ -68,6 +68,8 @@ config WAVELAN
 	tristate "AT&T/Lucent old WaveLAN & DEC RoamAbout DS ISA support"
 	depends on ISA && WLAN_PRE80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	---help---
 	  The Lucent WaveLAN (formerly NCR and AT&T; or DEC RoamAbout DS) is
 	  a Radio LAN (wireless Ethernet-like Local Area Network) using the
@@ -91,6 +93,8 @@ config PCMCIA_WAVELAN
 	tristate "AT&T/Lucent old WaveLAN Pcmcia wireless support"
 	depends on PCMCIA && WLAN_PRE80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	help
 	  Say Y here if you intend to attach an AT&T/Lucent Wavelan PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.  This
@@ -103,6 +107,7 @@ config PCMCIA_NETWAVE
 	tristate "Xircom Netwave AirSurfer Pcmcia wireless support"
 	depends on PCMCIA && WLAN_PRE80211
 	select WIRELESS_EXT
+	select WEXT_PRIV
 	help
 	  Say Y here if you intend to attach this type of PCMCIA (PC-card)
 	  wireless Ethernet networking card to your computer.
@@ -124,6 +129,8 @@ config PCMCIA_RAYCS
 	tristate "Aviator/Raytheon 2.4GHz wireless support"
 	depends on PCMCIA && WLAN_80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	---help---
 	  Say Y here if you intend to attach an Aviator/Raytheon PCMCIA
 	  (PC-card) wireless Ethernet networking card to your computer.
@@ -137,6 +144,7 @@ config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
 	select WIRELESS_EXT
+	select WEXT_SPY
 	select LIB80211
 	select FW_LOADER
 	---help---
@@ -191,6 +199,8 @@ config AIRO
 	depends on ISA_DMA_API && WLAN_80211 && (PCI || BROKEN)
 	select WIRELESS_EXT
 	select CRYPTO
+	select WEXT_SPY
+	select WEXT_PRIV
 	---help---
 	  This is the standard Linux driver to support Cisco/Aironet ISA and
 	  PCI 802.11 wireless cards.
@@ -208,6 +218,7 @@ config ATMEL
       tristate "Atmel at76c50x chipset  802.11b support"
       depends on (PCI || PCMCIA) && WLAN_80211
       select WIRELESS_EXT
+      select WEXT_PRIV
       select FW_LOADER
       select CRC32
        ---help---
@@ -267,18 +278,21 @@ config AIRO_CS
 	  Cisco Linux utilities can be used to configure the card.
 
 config PCMCIA_WL3501
-      tristate "Planet WL3501 PCMCIA cards"
-      depends on EXPERIMENTAL && PCMCIA && WLAN_80211
-      select WIRELESS_EXT
-       ---help---
-         A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
-	 It has basic support for Linux wireless extensions and initial
-	 micro support for ethtool.
+	tristate "Planet WL3501 PCMCIA cards"
+	depends on EXPERIMENTAL && PCMCIA && WLAN_80211
+	select WIRELESS_EXT
+	select WEXT_SPY
+	help
+	  A driver for WL3501 PCMCIA 802.11 wireless cards made by Planet.
+	  It has basic support for Linux wireless extensions and initial
+	  micro support for ethtool.
 
 config PRISM54
 	tristate 'Intersil Prism GT/Duette/Indigo PCI/Cardbus (DEPRECATED)'
 	depends on PCI && EXPERIMENTAL && WLAN_80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	select FW_LOADER
 	---help---
 	  This enables support for FullMAC PCI/Cardbus prism54 devices. This
@@ -301,6 +315,7 @@ config USB_ZD1201
 	tristate "USB ZD1201 based Wireless device support"
 	depends on USB && WLAN_80211
 	select WIRELESS_EXT
+	select WEXT_PRIV
 	select FW_LOADER
 	---help---
 	  Say Y if you want to use wireless LAN adapters based on the ZyDAS
--- wireless-testing.orig/drivers/net/wireless/hostap/Kconfig	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/hostap/Kconfig	2009-09-29 23:25:18.000000000 +0200
@@ -2,6 +2,8 @@ config HOSTAP
 	tristate "IEEE 802.11 for Host AP (Prism2/2.5/3 and WEP/TKIP/CCMP)"
 	depends on WLAN_80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	select CRYPTO
 	select CRYPTO_ARC4
 	select CRYPTO_ECB
--- wireless-testing.orig/drivers/net/wireless/ipw2x00/Kconfig	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ipw2x00/Kconfig	2009-09-29 23:25:18.000000000 +0200
@@ -6,6 +6,8 @@ config IPW2100
 	tristate "Intel PRO/Wireless 2100 Network Connection"
 	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	select FW_LOADER
 	select LIB80211
 	select LIBIPW
@@ -65,6 +67,8 @@ config IPW2200
 	tristate "Intel PRO/Wireless 2200BG and 2915ABG Network Connection"
 	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	select FW_LOADER
 	select LIB80211
 	select LIBIPW
@@ -152,6 +156,7 @@ config LIBIPW
 	tristate
 	depends on PCI && WLAN_80211 && CFG80211
 	select WIRELESS_EXT
+	select WEXT_SPY
 	select CRYPTO
 	select CRYPTO_ARC4
 	select CRYPTO_ECB
--- wireless-testing.orig/drivers/net/wireless/orinoco/Kconfig	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/orinoco/Kconfig	2009-09-29 23:25:18.000000000 +0200
@@ -3,6 +3,8 @@ config HERMES
 	depends on (PPC_PMAC || PCI || PCMCIA) && WLAN_80211
 	depends on CFG80211
 	select WIRELESS_EXT
+	select WEXT_SPY
+	select WEXT_PRIV
 	select FW_LOADER
 	select CRYPTO
 	select CRYPTO_MICHAEL_MIC
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/wext-priv.c	2009-09-29 23:25:18.000000000 +0200
@@ -0,0 +1,248 @@
+/*
+ * This file implement the Wireless Extensions core API.
+ *
+ * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
+ * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
+ * Copyright	2009 Johannes Berg <johannes@sipsolutions.net>
+ *
+ * (As all part of the Linux kernel, this file is GPL)
+ */
+#include <linux/wireless.h>
+#include <linux/netdevice.h>
+#include <net/iw_handler.h>
+#include <net/wext.h>
+
+int iw_handler_get_private(struct net_device *		dev,
+			   struct iw_request_info *	info,
+			   union iwreq_data *		wrqu,
+			   char *			extra)
+{
+	/* Check if the driver has something to export */
+	if ((dev->wireless_handlers->num_private_args == 0) ||
+	   (dev->wireless_handlers->private_args == NULL))
+		return -EOPNOTSUPP;
+
+	/* Check if there is enough buffer up there */
+	if (wrqu->data.length < dev->wireless_handlers->num_private_args) {
+		/* User space can't know in advance how large the buffer
+		 * needs to be. Give it a hint, so that we can support
+		 * any size buffer we want somewhat efficiently... */
+		wrqu->data.length = dev->wireless_handlers->num_private_args;
+		return -E2BIG;
+	}
+
+	/* Set the number of available ioctls. */
+	wrqu->data.length = dev->wireless_handlers->num_private_args;
+
+	/* Copy structure to the user buffer. */
+	memcpy(extra, dev->wireless_handlers->private_args,
+	       sizeof(struct iw_priv_args) * wrqu->data.length);
+
+	return 0;
+}
+
+/* Size (in bytes) of the various private data types */
+static const char iw_priv_type_size[] = {
+	0,				/* IW_PRIV_TYPE_NONE */
+	1,				/* IW_PRIV_TYPE_BYTE */
+	1,				/* IW_PRIV_TYPE_CHAR */
+	0,				/* Not defined */
+	sizeof(__u32),			/* IW_PRIV_TYPE_INT */
+	sizeof(struct iw_freq),		/* IW_PRIV_TYPE_FLOAT */
+	sizeof(struct sockaddr),	/* IW_PRIV_TYPE_ADDR */
+	0,				/* Not defined */
+};
+
+static int get_priv_size(__u16 args)
+{
+	int	num = args & IW_PRIV_SIZE_MASK;
+	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
+
+	return num * iw_priv_type_size[type];
+}
+
+static int adjust_priv_size(__u16 args, struct iw_point *iwp)
+{
+	int	num = iwp->length;
+	int	max = args & IW_PRIV_SIZE_MASK;
+	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
+
+	/* Make sure the driver doesn't goof up */
+	if (max < num)
+		num = max;
+
+	return num * iw_priv_type_size[type];
+}
+
+/*
+ * Wrapper to call a private Wireless Extension handler.
+ * We do various checks and also take care of moving data between
+ * user space and kernel space.
+ * It's not as nice and slimline as the standard wrapper. The cause
+ * is struct iw_priv_args, which was not really designed for the
+ * job we are going here.
+ *
+ * IMPORTANT : This function prevent to set and get data on the same
+ * IOCTL and enforce the SET/GET convention. Not doing it would be
+ * far too hairy...
+ * If you need to set and get data at the same time, please don't use
+ * a iw_handler but process it in your ioctl handler (i.e. use the
+ * old driver API).
+ */
+static int get_priv_descr_and_size(struct net_device *dev, unsigned int cmd,
+				   const struct iw_priv_args **descrp)
+{
+	const struct iw_priv_args *descr;
+	int i, extra_size;
+
+	descr = NULL;
+	for (i = 0; i < dev->wireless_handlers->num_private_args; i++) {
+		if (cmd == dev->wireless_handlers->private_args[i].cmd) {
+			descr = &dev->wireless_handlers->private_args[i];
+			break;
+		}
+	}
+
+	extra_size = 0;
+	if (descr) {
+		if (IW_IS_SET(cmd)) {
+			int	offset = 0;	/* For sub-ioctls */
+			/* Check for sub-ioctl handler */
+			if (descr->name[0] == '\0')
+				/* Reserve one int for sub-ioctl index */
+				offset = sizeof(__u32);
+
+			/* Size of set arguments */
+			extra_size = get_priv_size(descr->set_args);
+
+			/* Does it fits in iwr ? */
+			if ((descr->set_args & IW_PRIV_SIZE_FIXED) &&
+			   ((extra_size + offset) <= IFNAMSIZ))
+				extra_size = 0;
+		} else {
+			/* Size of get arguments */
+			extra_size = get_priv_size(descr->get_args);
+
+			/* Does it fits in iwr ? */
+			if ((descr->get_args & IW_PRIV_SIZE_FIXED) &&
+			   (extra_size <= IFNAMSIZ))
+				extra_size = 0;
+		}
+	}
+	*descrp = descr;
+	return extra_size;
+}
+
+static int ioctl_private_iw_point(struct iw_point *iwp, unsigned int cmd,
+				  const struct iw_priv_args *descr,
+				  iw_handler handler, struct net_device *dev,
+				  struct iw_request_info *info, int extra_size)
+{
+	char *extra;
+	int err;
+
+	/* Check what user space is giving us */
+	if (IW_IS_SET(cmd)) {
+		if (!iwp->pointer && iwp->length != 0)
+			return -EFAULT;
+
+		if (iwp->length > (descr->set_args & IW_PRIV_SIZE_MASK))
+			return -E2BIG;
+	} else if (!iwp->pointer)
+		return -EFAULT;
+
+	extra = kmalloc(extra_size, GFP_KERNEL);
+	if (!extra)
+		return -ENOMEM;
+
+	/* If it is a SET, get all the extra data in here */
+	if (IW_IS_SET(cmd) && (iwp->length != 0)) {
+		if (copy_from_user(extra, iwp->pointer, extra_size)) {
+			err = -EFAULT;
+			goto out;
+		}
+	}
+
+	/* Call the handler */
+	err = handler(dev, info, (union iwreq_data *) iwp, extra);
+
+	/* If we have something to return to the user */
+	if (!err && IW_IS_GET(cmd)) {
+		/* Adjust for the actual length if it's variable,
+		 * avoid leaking kernel bits outside.
+		 */
+		if (!(descr->get_args & IW_PRIV_SIZE_FIXED))
+			extra_size = adjust_priv_size(descr->get_args, iwp);
+
+		if (copy_to_user(iwp->pointer, extra, extra_size))
+			err =  -EFAULT;
+	}
+
+out:
+	kfree(extra);
+	return err;
+}
+
+int ioctl_private_call(struct net_device *dev, struct iwreq *iwr,
+		       unsigned int cmd, struct iw_request_info *info,
+		       iw_handler handler)
+{
+	int extra_size = 0, ret = -EINVAL;
+	const struct iw_priv_args *descr;
+
+	extra_size = get_priv_descr_and_size(dev, cmd, &descr);
+
+	/* Check if we have a pointer to user space data or not. */
+	if (extra_size == 0) {
+		/* No extra arguments. Trivial to handle */
+		ret = handler(dev, info, &(iwr->u), (char *) &(iwr->u));
+	} else {
+		ret = ioctl_private_iw_point(&iwr->u.data, cmd, descr,
+					     handler, dev, info, extra_size);
+	}
+
+	/* Call commit handler if needed and defined */
+	if (ret == -EIWCOMMIT)
+		ret = call_commit_handler(dev);
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+int compat_private_call(struct net_device *dev, struct iwreq *iwr,
+			unsigned int cmd, struct iw_request_info *info,
+			iw_handler handler)
+{
+	const struct iw_priv_args *descr;
+	int ret, extra_size;
+
+	extra_size = get_priv_descr_and_size(dev, cmd, &descr);
+
+	/* Check if we have a pointer to user space data or not. */
+	if (extra_size == 0) {
+		/* No extra arguments. Trivial to handle */
+		ret = handler(dev, info, &(iwr->u), (char *) &(iwr->u));
+	} else {
+		struct compat_iw_point *iwp_compat;
+		struct iw_point iwp;
+
+		iwp_compat = (struct compat_iw_point *) &iwr->u.data;
+		iwp.pointer = compat_ptr(iwp_compat->pointer);
+		iwp.length = iwp_compat->length;
+		iwp.flags = iwp_compat->flags;
+
+		ret = ioctl_private_iw_point(&iwp, cmd, descr,
+					     handler, dev, info, extra_size);
+
+		iwp_compat->pointer = ptr_to_compat(iwp.pointer);
+		iwp_compat->length = iwp.length;
+		iwp_compat->flags = iwp.flags;
+	}
+
+	/* Call commit handler if needed and defined */
+	if (ret == -EIWCOMMIT)
+		ret = call_commit_handler(dev);
+
+	return ret;
+}
+#endif
--- wireless-testing.orig/include/net/iw_handler.h	2009-09-29 23:20:10.000000000 +0200
+++ wireless-testing/include/net/iw_handler.h	2009-09-29 23:25:18.000000000 +0200
@@ -323,18 +323,19 @@ typedef int (*iw_handler)(struct net_dev
  */
 struct iw_handler_def
 {
-	/* Number of handlers defined (more precisely, index of the
-	 * last defined handler + 1) */
-	__u16			num_standard;
-	__u16			num_private;
-	/* Number of private arg description */
-	__u16			num_private_args;
 
 	/* Array of handlers for standard ioctls
 	 * We will call dev->wireless_handlers->standard[ioctl - SIOCSIWCOMMIT]
 	 */
 	const iw_handler *	standard;
+	/* Number of handlers defined (more precisely, index of the
+	 * last defined handler + 1) */
+	__u16			num_standard;
 
+#ifdef CONFIG_WEXT_PRIV
+	__u16			num_private;
+	/* Number of private arg description */
+	__u16			num_private_args;
 	/* Array of handlers for private ioctls
 	 * Will call dev->wireless_handlers->private[ioctl - SIOCIWFIRSTPRIV]
 	 */
@@ -344,6 +345,7 @@ struct iw_handler_def
 	 * can put it in any order you want and should not leave holes...
 	 * We will automatically export that to user space... */
 	const struct iw_priv_args *	private_args;
+#endif
 
 	/* New location of get_wireless_stats, to de-bloat struct net_device.
 	 * The old pointer in struct net_device will be gradually phased
--- wireless-testing.orig/net/core/net-sysfs.c	2009-09-29 23:20:09.000000000 +0200
+++ wireless-testing/net/core/net-sysfs.c	2009-09-29 23:25:18.000000000 +0200
@@ -503,8 +503,12 @@ int netdev_register_kobject(struct net_d
 	*groups++ = &netstat_group;
 
 #ifdef CONFIG_WIRELESS_EXT_SYSFS
-	if (net->wireless_handlers || net->ieee80211_ptr)
+	if (net->ieee80211_ptr)
 		*groups++ = &wireless_group;
+#ifdef CONFIG_WIRELESS_EXT
+	else if (net->wireless_handlers)
+		*groups++ = &wireless_group;
+#endif
 #endif
 #endif /* CONFIG_SYSFS */
 


