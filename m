Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946611AbXBIQdH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 11:33:07 -0500
Message-Id: <20070209162829.001594000@sipsolutions.net>
References: <20070209162711.375886000@sipsolutions.net>
Date: Fri, 09 Feb 2007 17:27:14 +0100
From: johannes@sipsolutions.net
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/4] cfg80211: wext compat code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds wext compat code into cfg80211 and arranges it so that the compat
code can be in the cfg80211 module while the called stuff is built in. This
enable us to upgrade the compatibility code without upgrading the kernel, no
cfg80211 bits need to be built into the kernel.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/netdevice.h  |    3 
 include/net/iw_handler.h   |    3 
 include/net/wireless.h     |   23 +
 net/Kconfig                |   14 
 net/core/dev.c             |   33 -
 net/core/net-sysfs.c       |    4 
 net/wireless/Makefile      |   13 
 net/wireless/core.c        |   19 -
 net/wireless/core.h        |    5 
 net/wireless/wext-common.c |  663 +++++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.c |  844 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/wext-export.c |   29 +
 net/wireless/wext-mod.c    |   20 +
 net/wireless/wext-old.c    |  641 ----------------------------------
 net/wireless/wext.h        |   47 ++
 15 files changed, 1692 insertions(+), 669 deletions(-)

--- linux-2.6.orig/include/linux/netdevice.h	2007-02-09 17:07:23.523840519 +0100
+++ linux-2.6/include/linux/netdevice.h	2007-02-09 17:07:25.513840519 +0100
@@ -350,12 +350,13 @@ struct net_device
 
 	struct net_device_stats* (*get_stats)(struct net_device *dev);
 
+#ifdef CONFIG_WIRELESS_EXT
 	/* List of functions to handle Wireless Extensions (instead of ioctl).
 	 * See <net/iw_handler.h> for details. Jean II */
 	const struct iw_handler_def *	wireless_handlers;
 	/* Instance data managed by the core of Wireless Extensions. */
 	struct iw_public_data *	wireless_data;
-
+#endif
 	const struct ethtool_ops *ethtool_ops;
 
 	/*
--- linux-2.6.orig/net/Kconfig	2007-02-09 17:07:23.623840519 +0100
+++ linux-2.6/net/Kconfig	2007-02-09 17:07:25.523840519 +0100
@@ -229,6 +229,20 @@ config FIB_RULES
 config CFG80211
 	tristate "Improved wireless configuration API"
 
+config CFG80211_WEXT_COMPAT
+	bool "cfg80211 Wireless Extensions compatibility"
+	depends CFG80211
+	default y
+	---help---
+	This option allows using devices whose drivers have been
+	converted to use the new cfg80211 with wireless extensions,
+	providing WE-20 compatibility. Note that cfg80211's "native"
+	interface is nl80211 using generic netlink. The wireless
+	extensions are being deprecated, but userspace tools may still
+	be using them.
+
+	If unsure, say Y.
+
 endif   # if NET
 endmenu # Networking
 
--- linux-2.6.orig/net/core/dev.c	2007-02-09 17:07:23.663840519 +0100
+++ linux-2.6/net/core/dev.c	2007-02-09 17:07:25.523840519 +0100
@@ -116,6 +116,7 @@
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
+#include <net/wireless.h>
 
 /*
  *	The list of packet types we will receive (as opposed to discard)
@@ -2228,12 +2229,6 @@ static struct file_operations softnet_se
 	.release = seq_release,
 };
 
-#ifdef CONFIG_WIRELESS_EXT
-extern int wireless_proc_init(void);
-#else
-#define wireless_proc_init() 0
-#endif
-
 static int __init dev_proc_init(void)
 {
 	int rc = -ENOMEM;
@@ -2798,29 +2793,9 @@ int dev_ioctl(unsigned int cmd, void __u
 					ret = -EFAULT;
 				return ret;
 			}
-#ifdef CONFIG_WIRELESS_EXT
-			/* Take care of Wireless Extensions */
-			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
-				/* If command is `set a parameter', or
-				 * `get the encoding parameters', check if
-				 * the user has the right to do it */
-				if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE
-				    || cmd == SIOCGIWENCODEEXT) {
-					if (!capable(CAP_NET_ADMIN))
-						return -EPERM;
-				}
-				dev_load(ifr.ifr_name);
-				rtnl_lock();
-				/* Follow me in net/wireless/wext-old.c */
-				ret = wireless_process_ioctl(&ifr, cmd);
-				rtnl_unlock();
-				if (IW_IS_GET(cmd) &&
-				    copy_to_user(arg, &ifr,
-					    	 sizeof(struct ifreq)))
-					ret = -EFAULT;
-				return ret;
-			}
-#endif	/* CONFIG_WIRELESS_EXT */
+			/* Take care of wireless extensions */
+			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST)
+				return wext_ioctl(cmd, &ifr, arg);
 			return -EINVAL;
 	}
 }
--- linux-2.6.orig/net/core/net-sysfs.c	2007-02-09 17:07:23.893840519 +0100
+++ linux-2.6/net/core/net-sysfs.c	2007-02-09 17:07:25.523840519 +0100
@@ -329,7 +329,7 @@ static struct attribute_group netstat_gr
 	.attrs  = netstat_attrs,
 };
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct class_device *cd, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -462,7 +462,7 @@ int netdev_register_sysfs(struct net_dev
 	if (net->get_stats)
 		*groups++ = &netstat_group;
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
--- linux-2.6.orig/net/wireless/Makefile	2007-02-09 17:07:23.913840519 +0100
+++ linux-2.6/net/wireless/Makefile	2007-02-09 17:07:25.523840519 +0100
@@ -1,5 +1,16 @@
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
 cfg80211-y += core.o sysfs.o
+cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
 
-obj-$(CONFIG_WIRELESS_EXT) += wext-old.o
+ifeq ($(CONFIG_CFG80211),m)
+obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-export.o
+cfg80211-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-mod.o
+# we need something to tell us what's up...
+# but we can't use #ifdef MODULE because we also need to
+# know in the part that is built in (namely wext-common.c)
+CFLAGS += -DCFG80211_MODULE
+endif
+
+obj-$(CONFIG_WIRELESS_EXT) += wext-common.o wext-old.o
+obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-common.o
--- linux-2.6.orig/net/wireless/core.h	2007-02-09 17:07:23.943840519 +0100
+++ linux-2.6/net/wireless/core.h	2007-02-09 17:07:25.523840519 +0100
@@ -20,6 +20,11 @@ struct cfg80211_registered_driver {
 	 * any call is in progress */
 	struct mutex mtx;
 
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	/* wext compat */
+	struct cfg80211_config *wext_pending_config;
+#endif
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/wext-common.c	2007-02-09 17:07:25.533840519 +0100
@@ -0,0 +1,663 @@
+/*
+ * common wext support routines, proc interface and events
+ *
+ *
+ * Most code is from the original wireless.c:
+ * Copyright 1997-2006  Jean Tourrilhes <jt@hpl.hp.com>
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/proc_fs.h>
+#include <linux/netdevice.h>
+#include <linux/module.h>
+#include <linux/wireless.h>
+#include <linux/types.h>
+#include <net/iw_handler.h>
+#include <linux/seq_file.h>
+#include <net/netlink.h>
+#include <linux/rtnetlink.h>
+#include "wext.h"
+
+/* common data */
+/*
+ * Meta-data about all the standard Wireless Extension request we
+ * know about.
+ */
+const struct iw_ioctl_description wext_standard_ioctl[] = {
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
+const unsigned wext_standard_ioctl_num = ARRAY_SIZE(wext_standard_ioctl);
+
+/*
+ * Meta-data about all the additional standard Wireless Extension events
+ * we know about.
+ */
+const struct iw_ioctl_description standard_event[] = {
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
+unsigned standard_event_num = (sizeof(standard_event) /
+					sizeof(struct iw_ioctl_description));
+
+
+/* Size (in bytes) of various events */
+const int event_type_size[] = {
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
+
+struct iw_statistics *get_wireless_stats(struct net_device *dev,
+					 struct iw_statistics *out)
+{
+#ifdef CONFIG_CFG80211
+	if (dev->ieee80211_ptr && out) {
+		/* bah, just fake some stuff for now */
+		memset(out, 0, sizeof(*out));
+		return out;
+	}
+#endif
+#ifdef CONFIG_WIRELESS_EXT
+	if ((dev->wireless_handlers != NULL) &&
+	    (dev->wireless_handlers->get_wireless_stats != NULL))
+		return dev->wireless_handlers->get_wireless_stats(dev);
+#endif
+	return NULL;
+}
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
+#ifdef CONFIG_PROC_FS
+
+/*
+ * Print one entry (line) of /proc/net/wireless
+ */
+static void wireless_seq_printf_stats(struct seq_file *seq,
+				      struct net_device *dev)
+{
+	/* Get stats from the driver */
+	struct iw_statistics stats_buf;
+	struct iw_statistics *stats = get_wireless_stats(dev, &stats_buf);
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
+		stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
+	}
+}
+
+/*
+ * Print info for /proc/net/wireless (print all entries)
+ */
+static int wireless_seq_show(struct seq_file *seq, void *v)
+{
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
+static struct seq_operations wireless_seq_ops = {
+	.start = dev_seq_start,
+	.next  = dev_seq_next,
+	.stop  = dev_seq_stop,
+	.show  = wireless_seq_show,
+};
+
+static int wireless_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &wireless_seq_ops);
+}
+
+static struct file_operations wireless_seq_fops = {
+	.owner	 = THIS_MODULE,
+	.open    = wireless_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = seq_release,
+};
+
+int __init wireless_proc_init(void)
+{
+	/* Create /proc/net/wireless entry */
+	if (!proc_net_fops_create("wireless", S_IRUGO, &wireless_seq_fops))
+		return -ENOMEM;
+
+	return 0;
+}
+#endif	/* CONFIG_PROC_FS */
+
+/* ---------------------------------------------------------------- */
+/*
+ * Locking...
+ * ----------
+ *
+ * Thanks to Herbert Xu <herbert@gondor.apana.org.au> for fixing
+ * the locking issue in here and implementing this code !
+ *
+ * The issue : wireless_send_event() is often called in interrupt context,
+ * while the Netlink layer can never be called in interrupt context.
+ * The fully formed RtNetlink events are queued, and then a tasklet is run
+ * to feed those to Netlink.
+ * The skb_queue is interrupt safe, and its lock is not held while calling
+ * Netlink, so there is no possibility of dealock.
+ * Jean II
+ */
+
+static struct sk_buff_head wireless_nlevent_queue;
+
+static int __init wireless_nlevent_init(void)
+{
+	skb_queue_head_init(&wireless_nlevent_queue);
+	return 0;
+}
+
+subsys_initcall(wireless_nlevent_init);
+
+static void wireless_nlevent_process(unsigned long data)
+{
+	struct sk_buff *skb;
+
+	while ((skb = skb_dequeue(&wireless_nlevent_queue)))
+		rtnl_notify(skb, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
+}
+
+static DECLARE_TASKLET(wireless_nlevent_tasklet, wireless_nlevent_process, 0);
+
+/* ---------------------------------------------------------------- */
+/*
+ * Fill a rtnetlink message with our event data.
+ * Note that we propage only the specified event and don't dump the
+ * current wireless config. Dumping the wireless config is far too
+ * expensive (for each parameter, the driver need to query the hardware).
+ */
+static inline int rtnetlink_fill_iwinfo(struct sk_buff *	skb,
+					struct net_device *	dev,
+					int			type,
+					char *			event,
+					int			event_len)
+{
+	struct ifinfomsg *r;
+	struct nlmsghdr  *nlh;
+	unsigned char	 *b = skb->tail;
+
+	nlh = NLMSG_PUT(skb, 0, 0, type, sizeof(*r));
+	r = NLMSG_DATA(nlh);
+	r->ifi_family = AF_UNSPEC;
+	r->__ifi_pad = 0;
+	r->ifi_type = dev->type;
+	r->ifi_index = dev->ifindex;
+	r->ifi_flags = dev_get_flags(dev);
+	r->ifi_change = 0;	/* Wireless changes don't affect those flags */
+
+	/* Add the wireless events in the netlink packet */
+	RTA_PUT(skb, IFLA_WIRELESS, event_len, event);
+
+	nlh->nlmsg_len = skb->tail - b;
+	return skb->len;
+
+nlmsg_failure:
+rtattr_failure:
+	skb_trim(skb, b - skb->data);
+	return -1;
+}
+
+/* ---------------------------------------------------------------- */
+/*
+ * Create and broadcast and send it on the standard rtnetlink socket
+ * This is a pure clone rtmsg_ifinfo() in net/core/rtnetlink.c
+ * Andrzej Krzysztofowicz mandated that I used a IFLA_XXX field
+ * within a RTM_NEWLINK event.
+ */
+static inline void rtmsg_iwinfo(struct net_device *	dev,
+				char *			event,
+				int			event_len)
+{
+	struct sk_buff *skb;
+	int size = NLMSG_GOODSIZE;
+
+	skb = alloc_skb(size, GFP_ATOMIC);
+	if (!skb)
+		return;
+
+	if (rtnetlink_fill_iwinfo(skb, dev, RTM_NEWLINK,
+				  event, event_len) < 0) {
+		kfree_skb(skb);
+		return;
+	}
+	NETLINK_CB(skb).dst_group = RTNLGRP_LINK;
+	skb_queue_tail(&wireless_nlevent_queue, skb);
+	tasklet_schedule(&wireless_nlevent_tasklet);
+}
+
+/* ---------------------------------------------------------------- */
+/*
+ * Main event dispatcher. Called from other parts and drivers.
+ * Send the event on the appropriate channels.
+ * May be called from interrupt context.
+ */
+void wireless_send_event(struct net_device *	dev,
+			 unsigned int		cmd,
+			 union iwreq_data *	wrqu,
+			 char *			extra)
+{
+	const struct iw_ioctl_description *	descr = NULL;
+	int extra_len = 0;
+	struct iw_event  *event;		/* Mallocated whole event */
+	int event_len;				/* Its size */
+	int hdr_len;				/* Size of the event header */
+	int wrqu_off = 0;			/* Offset in wrqu */
+	/* Don't "optimise" the following variable, it will crash */
+	unsigned	cmd_index;		/* *MUST* be unsigned */
+
+	/* Get the description of the Event */
+	if(cmd <= SIOCIWLAST) {
+		cmd_index = cmd - SIOCIWFIRST;
+		if(cmd_index < wext_standard_ioctl_num)
+			descr = &(wext_standard_ioctl[cmd_index]);
+	} else {
+		cmd_index = cmd - IWEVFIRST;
+		if(cmd_index < standard_event_num)
+			descr = &(standard_event[cmd_index]);
+	}
+	/* Don't accept unknown events */
+	if(descr == NULL) {
+		/* Note : we don't return an error to the driver, because
+		 * the driver would not know what to do about it. It can't
+		 * return an error to the user, because the event is not
+		 * initiated by a user request.
+		 * The best the driver could do is to log an error message.
+		 * We will do it ourselves instead...
+		 */
+	  	printk(KERN_ERR "%s (WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
+		       dev->name, cmd);
+		return;
+	}
+
+	/* Check extra parameters and set extra_len */
+	if(descr->header_type == IW_HEADER_TYPE_POINT) {
+		/* Check if number of token fits within bounds */
+		if(wrqu->data.length > descr->max_tokens) {
+		  	printk(KERN_ERR "%s (WE) : Wireless Event too big (%d)\n", dev->name, wrqu->data.length);
+			return;
+		}
+		if(wrqu->data.length < descr->min_tokens) {
+		  	printk(KERN_ERR "%s (WE) : Wireless Event too small (%d)\n", dev->name, wrqu->data.length);
+			return;
+		}
+		/* Calculate extra_len - extra is NULL for restricted events */
+		if(extra != NULL)
+			extra_len = wrqu->data.length * descr->token_size;
+		/* Always at an offset in wrqu */
+		wrqu_off = IW_EV_POINT_OFF;
+	}
+
+	/* Total length of the event */
+	hdr_len = event_type_size[descr->header_type];
+	event_len = hdr_len + extra_len;
+
+	/* Create temporary buffer to hold the event */
+	event = kmalloc(event_len, GFP_ATOMIC);
+	if(event == NULL)
+		return;
+
+	/* Fill event */
+	event->len = event_len;
+	event->cmd = cmd;
+	memcpy(&event->u, ((char *) wrqu) + wrqu_off, hdr_len - IW_EV_LCP_LEN);
+	if(extra != NULL)
+		memcpy(((char *) event) + hdr_len, extra, extra_len);
+
+	/* Send via the RtNetlink event channel */
+	rtmsg_iwinfo(dev, (char *) event, event_len);
+
+	/* Cleanup */
+	kfree(event);
+
+	return;		/* Always success, I guess ;-) */
+}
+EXPORT_SYMBOL(wireless_send_event);
+
+/* common code to handle wireless extension ioctls */
+int wext_ioctl(unsigned int cmd, struct ifreq *ifr, void __user *arg)
+{
+	int ret = -EINVAL;
+
+	/* If command is `set a parameter', or `get the encoding parameters',
+	 * check if the user is allowed to do it */
+	if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE || cmd == SIOCGIWENCODEEXT)
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
+	dev_load(ifr->ifr_name);
+
+#ifdef CONFIG_WIRELESS_EXT
+	rtnl_lock();
+	/* Follow me in wext-old.c */
+	ret = wireless_process_ioctl(ifr, cmd);
+	rtnl_unlock();
+
+	if (ret == 0 && IW_IS_GET(cmd) &&
+	    copy_to_user(arg, &ifr, sizeof(struct ifreq)))
+		ret = -EFAULT;
+	/* haha, I cheat here by allowing a driver or stack to have both WE and
+	 * CFG80211-WE for a little while during conversion... wext returns
+	 * -EOPNOTSUPP if a handler is not assigned, so we can in that case try
+	 * calling cfg80211's compat code instead.
+	 */
+	if (ret != -EOPNOTSUPP)
+		return ret;
+#endif
+
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	rtnl_lock();
+	ret = call_cfg80211_wext_ioctl(ifr, cmd);
+	rtnl_unlock();
+
+	if (ret == 0 && IW_IS_GET(cmd) &&
+	    copy_to_user(arg, ifr, sizeof(struct ifreq)))
+		ret = -EFAULT;
+#endif
+
+	return ret;
+}
--- linux-2.6.orig/net/wireless/wext-old.c	2007-02-09 17:07:24.003840519 +0100
+++ linux-2.6/net/wireless/wext-old.c	2007-02-09 17:07:25.533840519 +0100
@@ -83,9 +83,7 @@
 #include <linux/module.h>
 #include <linux/types.h>		/* off_t */
 #include <linux/netdevice.h>		/* struct ifreq, dev_get_by_name() */
-#include <linux/proc_fs.h>
 #include <linux/rtnetlink.h>		/* rtnetlink stuff */
-#include <linux/seq_file.h>
 #include <linux/init.h>			/* for __init */
 #include <linux/if_arp.h>		/* ARPHRD_ETHER */
 #include <linux/etherdevice.h>		/* compare_ether_addr */
@@ -97,6 +95,8 @@
 
 #include <asm/uaccess.h>		/* copy_to_user() */
 
+#include "wext.h"
+
 /**************************** CONSTANTS ****************************/
 
 /* Debugging stuff */
@@ -111,294 +111,6 @@
 #define WE_SET_EVENT		/* Generate an event on some set commands */
 
 /************************* GLOBAL VARIABLES *************************/
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
-static const unsigned standard_ioctl_num = (sizeof(standard_ioctl) /
-					    sizeof(struct iw_ioctl_description));
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
-static const unsigned standard_event_num = (sizeof(standard_event) /
-					    sizeof(struct iw_ioctl_description));
 
 /* Size (in bytes) of the various private data types */
 static const char iw_priv_type_size[] = {
@@ -412,20 +124,6 @@ static const char iw_priv_type_size[] = 
 	0,				/* Not defined */
 };
 
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
 
 /************************ COMMON SUBROUTINES ************************/
 /*
@@ -464,21 +162,6 @@ static inline iw_handler get_handler(str
 
 /* ---------------------------------------------------------------- */
 /*
- * Get statistics out of the driver
- */
-static inline struct iw_statistics *get_wireless_stats(struct net_device *dev)
-{
-	/* New location */
-	if((dev->wireless_handlers != NULL) &&
-	   (dev->wireless_handlers->get_wireless_stats != NULL))
-		return dev->wireless_handlers->get_wireless_stats(dev);
-
-	/* Not found */
-	return (struct iw_statistics *) NULL;
-}
-
-/* ---------------------------------------------------------------- */
-/*
  * Call the commit handler in the driver
  * (if exist and if conditions are right)
  *
@@ -551,7 +234,7 @@ static int iw_handler_get_iwstats(struct
 	/* Get stats from the driver */
 	struct iw_statistics *stats;
 
-	stats = get_wireless_stats(dev);
+	stats = get_wireless_stats(dev, NULL);
 	if (stats != (struct iw_statistics *) NULL) {
 
 		/* Copy statistics to extra */
@@ -601,97 +284,6 @@ static int iw_handler_get_private(struct
 	return 0;
 }
 
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
-static __inline__ void wireless_seq_printf_stats(struct seq_file *seq,
-						 struct net_device *dev)
-{
-	/* Get stats from the driver */
-	struct iw_statistics *stats = get_wireless_stats(dev);
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
-		stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
-	}
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Print info for /proc/net/wireless (print all entries)
- */
-static int wireless_seq_show(struct seq_file *seq, void *v)
-{
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
-static struct seq_operations wireless_seq_ops = {
-	.start = dev_seq_start,
-	.next  = dev_seq_next,
-	.stop  = dev_seq_stop,
-	.show  = wireless_seq_show,
-};
-
-static int wireless_seq_open(struct inode *inode, struct file *file)
-{
-	return seq_open(file, &wireless_seq_ops);
-}
-
-static struct file_operations wireless_seq_fops = {
-	.owner	 = THIS_MODULE,
-	.open    = wireless_seq_open,
-	.read    = seq_read,
-	.llseek  = seq_lseek,
-	.release = seq_release,
-};
-
-int __init wireless_proc_init(void)
-{
-	/* Create /proc/net/wireless entry */
-	if (!proc_net_fops_create("wireless", S_IRUGO, &wireless_seq_fops))
-		return -ENOMEM;
-
-	return 0;
-}
-#endif	/* CONFIG_PROC_FS */
-
 /************************** IOCTL SUPPORT **************************/
 /*
  * The original user space API to configure all those Wireless Extensions
@@ -717,9 +309,9 @@ static int ioctl_standard_call(struct ne
 	int					ret = -EINVAL;
 
 	/* Get the description of the IOCTL */
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_IOCTL_DEBUG
 	printk(KERN_DEBUG "%s (WE) : Found standard handler for 0x%04X\n",
@@ -1178,9 +770,9 @@ static int rtnetlink_standard_get(struct
 
 	/* Get the description of the Request */
 	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_RTNETLINK_DEBUG
 	printk(KERN_DEBUG "%s (WE.r) : Found standard handler for 0x%04X\n",
@@ -1320,9 +912,9 @@ static inline int rtnetlink_standard_set
 
 	/* Get the description of the Request */
 	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_RTNETLINK_DEBUG
 	printk(KERN_DEBUG "%s (WE.r) : Found standard SET handler for 0x%04X\n",
@@ -1863,220 +1455,6 @@ int wireless_rtnetlink_set(struct net_de
 }
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
 
-
-/************************* EVENT PROCESSING *************************/
-/*
- * Process events generated by the wireless layer or the driver.
- * Most often, the event will be propagated through rtnetlink
- */
-
-#ifdef WE_EVENT_RTNETLINK
-/* ---------------------------------------------------------------- */
-/*
- * Locking...
- * ----------
- *
- * Thanks to Herbert Xu <herbert@gondor.apana.org.au> for fixing
- * the locking issue in here and implementing this code !
- *
- * The issue : wireless_send_event() is often called in interrupt context,
- * while the Netlink layer can never be called in interrupt context.
- * The fully formed RtNetlink events are queued, and then a tasklet is run
- * to feed those to Netlink.
- * The skb_queue is interrupt safe, and its lock is not held while calling
- * Netlink, so there is no possibility of dealock.
- * Jean II
- */
-
-static struct sk_buff_head wireless_nlevent_queue;
-
-static int __init wireless_nlevent_init(void)
-{
-	skb_queue_head_init(&wireless_nlevent_queue);
-	return 0;
-}
-
-subsys_initcall(wireless_nlevent_init);
-
-static void wireless_nlevent_process(unsigned long data)
-{
-	struct sk_buff *skb;
-
-	while ((skb = skb_dequeue(&wireless_nlevent_queue)))
-		rtnl_notify(skb, 0, RTNLGRP_LINK, NULL, GFP_ATOMIC);
-}
-
-static DECLARE_TASKLET(wireless_nlevent_tasklet, wireless_nlevent_process, 0);
-
-/* ---------------------------------------------------------------- */
-/*
- * Fill a rtnetlink message with our event data.
- * Note that we propage only the specified event and don't dump the
- * current wireless config. Dumping the wireless config is far too
- * expensive (for each parameter, the driver need to query the hardware).
- */
-static inline int rtnetlink_fill_iwinfo(struct sk_buff *	skb,
-					struct net_device *	dev,
-					int			type,
-					char *			event,
-					int			event_len)
-{
-	struct ifinfomsg *r;
-	struct nlmsghdr  *nlh;
-	unsigned char	 *b = skb->tail;
-
-	nlh = NLMSG_PUT(skb, 0, 0, type, sizeof(*r));
-	r = NLMSG_DATA(nlh);
-	r->ifi_family = AF_UNSPEC;
-	r->__ifi_pad = 0;
-	r->ifi_type = dev->type;
-	r->ifi_index = dev->ifindex;
-	r->ifi_flags = dev_get_flags(dev);
-	r->ifi_change = 0;	/* Wireless changes don't affect those flags */
-
-	/* Add the wireless events in the netlink packet */
-	RTA_PUT(skb, IFLA_WIRELESS, event_len, event);
-
-	nlh->nlmsg_len = skb->tail - b;
-	return skb->len;
-
-nlmsg_failure:
-rtattr_failure:
-	skb_trim(skb, b - skb->data);
-	return -1;
-}
-
-/* ---------------------------------------------------------------- */
-/*
- * Create and broadcast and send it on the standard rtnetlink socket
- * This is a pure clone rtmsg_ifinfo() in net/core/rtnetlink.c
- * Andrzej Krzysztofowicz mandated that I used a IFLA_XXX field
- * within a RTM_NEWLINK event.
- */
-static inline void rtmsg_iwinfo(struct net_device *	dev,
-				char *			event,
-				int			event_len)
-{
-	struct sk_buff *skb;
-	int size = NLMSG_GOODSIZE;
-
-	skb = alloc_skb(size, GFP_ATOMIC);
-	if (!skb)
-		return;
-
-	if (rtnetlink_fill_iwinfo(skb, dev, RTM_NEWLINK,
-				  event, event_len) < 0) {
-		kfree_skb(skb);
-		return;
-	}
-	NETLINK_CB(skb).dst_group = RTNLGRP_LINK;
-	skb_queue_tail(&wireless_nlevent_queue, skb);
-	tasklet_schedule(&wireless_nlevent_tasklet);
-}
-
-#endif	/* WE_EVENT_RTNETLINK */
-
-/* ---------------------------------------------------------------- */
-/*
- * Main event dispatcher. Called from other parts and drivers.
- * Send the event on the appropriate channels.
- * May be called from interrupt context.
- */
-void wireless_send_event(struct net_device *	dev,
-			 unsigned int		cmd,
-			 union iwreq_data *	wrqu,
-			 char *			extra)
-{
-	const struct iw_ioctl_description *	descr = NULL;
-	int extra_len = 0;
-	struct iw_event  *event;		/* Mallocated whole event */
-	int event_len;				/* Its size */
-	int hdr_len;				/* Size of the event header */
-	int wrqu_off = 0;			/* Offset in wrqu */
-	/* Don't "optimise" the following variable, it will crash */
-	unsigned	cmd_index;		/* *MUST* be unsigned */
-
-	/* Get the description of the Event */
-	if(cmd <= SIOCIWLAST) {
-		cmd_index = cmd - SIOCIWFIRST;
-		if(cmd_index < standard_ioctl_num)
-			descr = &(standard_ioctl[cmd_index]);
-	} else {
-		cmd_index = cmd - IWEVFIRST;
-		if(cmd_index < standard_event_num)
-			descr = &(standard_event[cmd_index]);
-	}
-	/* Don't accept unknown events */
-	if(descr == NULL) {
-		/* Note : we don't return an error to the driver, because
-		 * the driver would not know what to do about it. It can't
-		 * return an error to the user, because the event is not
-		 * initiated by a user request.
-		 * The best the driver could do is to log an error message.
-		 * We will do it ourselves instead...
-		 */
-	  	printk(KERN_ERR "%s (WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
-		       dev->name, cmd);
-		return;
-	}
-#ifdef WE_EVENT_DEBUG
-	printk(KERN_DEBUG "%s (WE) : Got event 0x%04X\n",
-	       dev->name, cmd);
-	printk(KERN_DEBUG "%s (WE) : Header type : %d, Token type : %d, size : %d, token : %d\n", dev->name, descr->header_type, descr->token_type, descr->token_size, descr->max_tokens);
-#endif	/* WE_EVENT_DEBUG */
-
-	/* Check extra parameters and set extra_len */
-	if(descr->header_type == IW_HEADER_TYPE_POINT) {
-		/* Check if number of token fits within bounds */
-		if(wrqu->data.length > descr->max_tokens) {
-		  	printk(KERN_ERR "%s (WE) : Wireless Event too big (%d)\n", dev->name, wrqu->data.length);
-			return;
-		}
-		if(wrqu->data.length < descr->min_tokens) {
-		  	printk(KERN_ERR "%s (WE) : Wireless Event too small (%d)\n", dev->name, wrqu->data.length);
-			return;
-		}
-		/* Calculate extra_len - extra is NULL for restricted events */
-		if(extra != NULL)
-			extra_len = wrqu->data.length * descr->token_size;
-		/* Always at an offset in wrqu */
-		wrqu_off = IW_EV_POINT_OFF;
-#ifdef WE_EVENT_DEBUG
-		printk(KERN_DEBUG "%s (WE) : Event 0x%04X, tokens %d, extra_len %d\n", dev->name, cmd, wrqu->data.length, extra_len);
-#endif	/* WE_EVENT_DEBUG */
-	}
-
-	/* Total length of the event */
-	hdr_len = event_type_size[descr->header_type];
-	event_len = hdr_len + extra_len;
-
-#ifdef WE_EVENT_DEBUG
-	printk(KERN_DEBUG "%s (WE) : Event 0x%04X, hdr_len %d, wrqu_off %d, event_len %d\n", dev->name, cmd, hdr_len, wrqu_off, event_len);
-#endif	/* WE_EVENT_DEBUG */
-
-	/* Create temporary buffer to hold the event */
-	event = kmalloc(event_len, GFP_ATOMIC);
-	if(event == NULL)
-		return;
-
-	/* Fill event */
-	event->len = event_len;
-	event->cmd = cmd;
-	memcpy(&event->u, ((char *) wrqu) + wrqu_off, hdr_len - IW_EV_LCP_LEN);
-	if(extra != NULL)
-		memcpy(((char *) event) + hdr_len, extra, extra_len);
-
-#ifdef WE_EVENT_RTNETLINK
-	/* Send via the RtNetlink event channel */
-	rtmsg_iwinfo(dev, (char *) event, event_len);
-#endif	/* WE_EVENT_RTNETLINK */
-
-	/* Cleanup */
-	kfree(event);
-
-	return;		/* Always success, I guess ;-) */
-}
-
 /********************** ENHANCED IWSPY SUPPORT **********************/
 /*
  * In the old days, the driver was handling spy support all by itself.
@@ -2349,5 +1727,4 @@ EXPORT_SYMBOL(iw_handler_get_spy);
 EXPORT_SYMBOL(iw_handler_get_thrspy);
 EXPORT_SYMBOL(iw_handler_set_spy);
 EXPORT_SYMBOL(iw_handler_set_thrspy);
-EXPORT_SYMBOL(wireless_send_event);
 EXPORT_SYMBOL(wireless_spy_update);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/wext.h	2007-02-09 17:07:25.533840519 +0100
@@ -0,0 +1,47 @@
+/*
+ * some foo for wext compat/wext interoperability
+ */
+#ifndef _WEXT_H
+#define _WEXT_H
+#include <linux/netdevice.h>
+#include <linux/if.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
+
+/* wext compatibility must be compiled in...
+ * this extern is in wext-compat.c */
+struct cfg80211_ioctl_ops {
+	/* used to make sure the module isn't going away
+	 * can't really happen, except if no driver has cfg80211
+	 * in use, but in that case  */
+	struct module *module;
+
+	/* and finally this is used to do work */
+	int (*do_wext_ioctl)(struct ifreq *ifr, unsigned int cmd);
+};
+extern struct cfg80211_ioctl_ops cfg80211_ioctl_ops;
+
+
+struct iw_statistics *get_wireless_stats(struct net_device *dev,
+					 struct iw_statistics *out);
+int wireless_process_ioctl(struct ifreq *ifr, unsigned int cmd);
+
+int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+#ifdef CFG80211_MODULE
+int call_cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+int cfg80211_wext_init(void);
+void cfg80211_wext_exit(void);
+#else
+#define call_cfg80211_wext_ioctl cfg80211_wext_ioctl
+static inline int cfg80211_wext_init(void)
+{
+	return 0;
+}
+static inline void cfg80211_wext_exit(void) {}
+#endif
+
+extern const struct iw_ioctl_description wext_standard_ioctl[];
+extern const unsigned wext_standard_ioctl_num;
+extern const struct iw_ioctl_description standard_event[];
+extern const int event_type_size[];
+#endif /* _WEXT_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/wext-compat.c	2007-02-09 17:07:25.543840519 +0100
@@ -0,0 +1,844 @@
+/*
+ * wireless extensions compatibility for cfg80211.
+ *
+ * Lots of code from the original wireless.c:
+ * Copyright 1997-2006	Jean Tourrilhes <jt@hpl.hp.com>
+ *
+ * Copyright 2006,2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * GPLv2.
+ *
+ * Theory of operation, so to speak:
+ *
+ * To implement compatibility, I added a new field to struct net_device
+ * that contains the pending configuration structure. This is dynamically
+ * allocated when needed and freed when committed.
+ *
+ * Commit is done some time after the last parameter was changed
+ * (with each parameter change simply (re-)schedule a timer) or
+ * if explicitly asked for. This is probably not what most people
+ * would expect, but perfectly fine in the WE API.
+ *
+ * NB: we leak memory if the user
+ *      - changes some settings
+ *      - quickly rmmod's the module so that the net device is destroyed
+ * Since only root can do it and I don't see a way to hook into
+ * the net device's destruction... tough.
+ *
+ * NB2: Note that each of the wrappers should check if the cfg80211
+ * user provides the command, and for configure() it must also check
+ * if that parameter can be set or not via get_config_valid()
+ *
+ * NB3: It's really bad that we can't report an error from the timer-
+ * based commit... Hopefully get_config_valid() can catch everything?
+ *
+ * see set_essid for an example
+ *
+ * another question I just thought about.. does wext expect to see
+ * the new config even if it wasn't committed... if so, we need to
+ * look at the pending config in various _get_ calls...
+ */
+
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <linux/wireless.h>
+#include <net/netlink.h>
+#include <asm/uaccess.h>
+#include <net/cfg80211.h>
+
+#include "core.h"
+#include "wext.h"
+
+/* internal API: use this function when changing
+ * some parameter that needs to be committed */
+static void cfg80211_wx_start_commit_timer(int ifindex)
+{
+	/* TODO:
+	 * start a timer associate with this interface
+	 * and then when it expires commit the pending
+	 * data...
+	 * This function must be callable when the timer
+	 * is already running, and the timer must
+	 * be able to deal with an unassigned
+	 * dev->cfg80211_wext_pending_config pointer
+	 * as well as taking the rtnl lock (due to wext)! */
+}
+
+static struct cfg80211_config *cfg80211_ensure_pending_cfg(
+	struct cfg80211_registered_driver *drv)
+{
+	struct cfg80211_config *cfg = drv->wext_pending_config;
+	if (!cfg)
+		cfg = kmalloc(sizeof(*cfg)+32, GFP_KERNEL);
+	if (cfg) {
+		cfg->ssid = (char*)cfg + sizeof(*cfg);
+		drv->wext_pending_config = cfg;
+	}
+	return cfg;
+}
+
+static int cfg80211_wx_set_commit(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	int err;
+
+	if (!drv->wext_pending_config) {
+		err = 0;
+		goto out;
+	}
+
+	err = drv->ops->configure(&drv->wiphy, net_dev,
+				  drv->wext_pending_config);
+
+	kfree(drv->wext_pending_config);
+	drv->wext_pending_config = NULL;
+
+ out:
+	return err;
+}
+
+static int cfg80211_wx_get_name(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_nwid(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_nwid(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_freq(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_freq(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_mode(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_mode(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_sens(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_sens(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_range(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_range(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_ap(struct cfg80211_registered_driver *drv,
+			      struct net_device *net_dev,
+			      struct iw_request_info *info,
+			      union iwreq_data *data,
+			      char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	/* TODO: DO SOMETHING */
+	/* SIOCSIWAP
+	 *   -> if bssid is all-ones: set roaming to kernel, reassociate
+	 *   -> if bssid is all-zeroes: set roaming to kernel
+	 *   -> otherwise: set roaming to userspace, set bssid
+	 */
+
+	return err;
+}
+
+static int cfg80211_wx_get_ap(struct cfg80211_registered_driver *drv,
+			      struct net_device *net_dev,
+			      struct iw_request_info *info,
+			      union iwreq_data *data,
+			      char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	/* TODO: DO SOMETHING */
+	/* SIOCGIWAP
+	 *   -> get association parameters and fill return bssid appropriately
+	 */
+
+	return err;
+}
+
+static int cfg80211_wx_set_mlme(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_waplist(struct cfg80211_registered_driver *drv,
+				   struct net_device *net_dev,
+				   struct iw_request_info *info,
+				   union iwreq_data *data,
+				   char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_scan(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_scan(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_essid(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+	struct cfg80211_config *cfg;
+
+	if (!drv->ops->configure || !drv->ops->get_config_valid)
+		goto out;
+	if (!(drv->ops->get_config_valid(&drv->wiphy, net_dev)
+			& CFG80211_CFG_VALID_SSID))
+		goto out;
+
+	cfg = cfg80211_ensure_pending_cfg(drv);
+	if (!cfg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(cfg->ssid, extra, data->essid.length);
+	cfg->ssid_len = data->essid.length;
+	cfg->valid |= CFG80211_CFG_VALID_SSID;
+
+	cfg80211_wx_start_commit_timer(net_dev->ifindex);
+	err = 0;
+ out:
+	return err;
+}
+
+static int cfg80211_wx_get_essid(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_rate(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_rate(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_rts(struct cfg80211_registered_driver *drv,
+			       struct net_device *net_dev,
+			       struct iw_request_info *info,
+			       union iwreq_data *data,
+			       char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_rts(struct cfg80211_registered_driver *drv,
+			       struct net_device *net_dev,
+			       struct iw_request_info *info,
+			       union iwreq_data *data,
+			       char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_frag(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_frag(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_txpow(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_txpow(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_retry(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_retry(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_encode(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_encode(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_power(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_power(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_genie(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_genie(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_auth(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_auth(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_encodeext(struct cfg80211_registered_driver *drv,
+				     struct net_device *net_dev,
+				     struct iw_request_info *info,
+				     union iwreq_data *data,
+				     char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_get_encodeext(struct cfg80211_registered_driver *drv,
+				     struct net_device *net_dev,
+				     struct iw_request_info *info,
+				     union iwreq_data *data,
+				     char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+static int cfg80211_wx_set_wpmksa(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	int err = -EOPNOTSUPP;
+
+	return err;
+}
+
+
+typedef int (*iw_compat_handler)(struct cfg80211_registered_driver *drv,
+				 struct net_device *dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *wrqu,
+				 char *extra);
+
+/* operations array */
+#ifdef WX
+# undef WX
+#endif
+#define WX(ioctl)  [(ioctl) - SIOCIWFIRST]
+static const iw_compat_handler cfg80211_wx_handlers[] = {
+	WX(SIOCSIWCOMMIT)	= cfg80211_wx_set_commit,
+	WX(SIOCGIWNAME)		= cfg80211_wx_get_name,
+	WX(SIOCSIWNWID)		= cfg80211_wx_set_nwid,
+	WX(SIOCGIWNWID)		= cfg80211_wx_get_nwid,
+	WX(SIOCSIWFREQ)		= cfg80211_wx_set_freq,
+	WX(SIOCGIWFREQ)		= cfg80211_wx_get_freq,
+	WX(SIOCSIWMODE)		= cfg80211_wx_set_mode,
+	WX(SIOCGIWMODE)		= cfg80211_wx_get_mode,
+	WX(SIOCSIWSENS)		= cfg80211_wx_set_sens,
+	WX(SIOCGIWSENS)		= cfg80211_wx_get_sens,
+	WX(SIOCSIWRANGE)	= cfg80211_wx_set_range,
+	WX(SIOCGIWRANGE)	= cfg80211_wx_get_range,
+	WX(SIOCSIWAP)		= cfg80211_wx_set_ap,
+	WX(SIOCGIWAP)		= cfg80211_wx_get_ap,
+	WX(SIOCSIWMLME)		= cfg80211_wx_set_mlme,
+	WX(SIOCGIWAPLIST)	= cfg80211_wx_get_waplist,
+	WX(SIOCSIWSCAN)		= cfg80211_wx_set_scan,
+	WX(SIOCGIWSCAN)		= cfg80211_wx_get_scan,
+	WX(SIOCSIWESSID)	= cfg80211_wx_set_essid,
+	WX(SIOCGIWESSID)	= cfg80211_wx_get_essid,
+	WX(SIOCSIWRATE)		= cfg80211_wx_set_rate,
+	WX(SIOCGIWRATE)		= cfg80211_wx_get_rate,
+	WX(SIOCSIWRTS)		= cfg80211_wx_set_rts,
+	WX(SIOCGIWRTS)		= cfg80211_wx_get_rts,
+	WX(SIOCSIWFRAG)		= cfg80211_wx_set_frag,
+	WX(SIOCGIWFRAG)		= cfg80211_wx_get_frag,
+	WX(SIOCSIWTXPOW)	= cfg80211_wx_set_txpow,
+	WX(SIOCGIWTXPOW)	= cfg80211_wx_get_txpow,
+	WX(SIOCSIWRETRY)	= cfg80211_wx_set_retry,
+	WX(SIOCGIWRETRY)	= cfg80211_wx_get_retry,
+	WX(SIOCSIWENCODE)	= cfg80211_wx_set_encode,
+	WX(SIOCGIWENCODE)	= cfg80211_wx_get_encode,
+	WX(SIOCSIWPOWER)	= cfg80211_wx_set_power,
+	WX(SIOCGIWPOWER)	= cfg80211_wx_get_power,
+	WX(SIOCSIWGENIE)	= cfg80211_wx_set_genie,
+	WX(SIOCGIWGENIE)	= cfg80211_wx_get_genie,
+	WX(SIOCSIWAUTH)		= cfg80211_wx_set_auth,
+	WX(SIOCGIWAUTH)		= cfg80211_wx_get_auth,
+	WX(SIOCSIWENCODEEXT)	= cfg80211_wx_set_encodeext,
+	WX(SIOCGIWENCODEEXT)	= cfg80211_wx_get_encodeext,
+	WX(SIOCSIWPMKSA)	= cfg80211_wx_set_wpmksa,
+};
+
+/* dummy so I didn't have to change that much code... */
+static iw_compat_handler get_handler(unsigned int cmd)
+{
+	int idx = cmd - SIOCIWFIRST;
+	if (idx < ARRAY_SIZE(cfg80211_wx_handlers))
+		return cfg80211_wx_handlers[idx];
+	return NULL;
+}
+
+/*
+ * this is sort of backwards and wouldn't need to call
+ * get_wireless_stats, but it was easier to just copy the code...
+ */
+static int iw_handler_get_iwstats(struct cfg80211_registered_driver *drv,
+				  struct net_device *dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *wrqu,
+				  char *extra)
+{
+	/* Get stats from the driver */
+	struct iw_statistics stats_buf;
+	struct iw_statistics *stats;
+
+	stats = get_wireless_stats(dev, &stats_buf);
+	if (stats != (struct iw_statistics *) NULL) {
+
+		/* Copy statistics to extra */
+		memcpy(extra, stats, sizeof(struct iw_statistics));
+		wrqu->data.length = sizeof(struct iw_statistics);
+
+		/* Check if we need to clear the updated flag */
+		if(wrqu->data.flags != 0)
+			stats->qual.updated &= ~IW_QUAL_ALL_UPDATED;
+		return 0;
+	} else
+		return -EOPNOTSUPP;
+}
+
+/*
+ * Wrapper to call a standard Wireless Extension handler.
+ * We do various checks and also take care of moving data between
+ * user space and kernel space.
+ */
+static int ioctl_standard_call(struct cfg80211_registered_driver *drv,
+			       struct net_device *dev,
+			       struct ifreq *ifr,
+			       unsigned int cmd,
+			       iw_compat_handler handler)
+{
+	struct iwreq *				iwr = (struct iwreq *) ifr;
+	const struct iw_ioctl_description *	descr;
+	struct iw_request_info			info;
+	int					ret = -EINVAL;
+
+	/* Get the description of the IOCTL */
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
+		return -EOPNOTSUPP;
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
+
+	/* Prepare the call */
+	info.cmd = cmd;
+	info.flags = 0;
+
+	/* Check if we have a pointer to user space data or not */
+	if(descr->header_type != IW_HEADER_TYPE_POINT) {
+
+		/* No extra arguments. Trivial to handle */
+		ret = handler(drv, dev, &info, &(iwr->u), NULL);
+
+		/* Generate an event to notify listeners of the change */
+		if((descr->flags & IW_DESCR_FLAG_EVENT) &&
+		   ((ret == 0) || (ret == -EIWCOMMIT)))
+			wireless_send_event(dev, cmd, &(iwr->u), NULL);
+	} else {
+		char *	extra;
+		int	extra_size;
+		int	user_length = 0;
+		int	err;
+
+		/* Calculate space needed by arguments. Always allocate
+		 * for max space. Easier, and won't last long... */
+		extra_size = descr->max_tokens * descr->token_size;
+
+		/* Check what user space is giving us */
+		if(IW_IS_SET(cmd)) {
+			/* Check NULL pointer */
+			if((iwr->u.data.pointer == NULL) &&
+			   (iwr->u.data.length != 0))
+				return -EFAULT;
+			/* Check if number of token fits within bounds */
+			if(iwr->u.data.length > descr->max_tokens)
+				return -E2BIG;
+			if(iwr->u.data.length < descr->min_tokens)
+				return -EINVAL;
+		} else {
+			/* Check NULL pointer */
+			if(iwr->u.data.pointer == NULL)
+				return -EFAULT;
+			/* Save user space buffer size for checking */
+			user_length = iwr->u.data.length;
+
+			/* Don't check if user_length > max to allow forward
+			 * compatibility. The test user_length < min is
+			 * implied by the test at the end. */
+
+			/* Support for very large requests */
+			if((descr->flags & IW_DESCR_FLAG_NOMAX) &&
+			   (user_length > descr->max_tokens)) {
+				/* Allow userspace to GET more than max so
+				 * we can support any size GET requests.
+				 * There is still a limit : -ENOMEM. */
+				extra_size = user_length * descr->token_size;
+				/* Note : user_length is originally a __u16,
+				 * and token_size is controlled by us,
+				 * so extra_size won't get negative and
+				 * won't overflow... */
+			}
+		}
+
+		/* Create the kernel buffer */
+		extra = kmalloc(extra_size, GFP_KERNEL);
+		if (extra == NULL) {
+			return -ENOMEM;
+		}
+
+		/* If it is a SET, get all the extra data in here */
+		if(IW_IS_SET(cmd) && (iwr->u.data.length != 0)) {
+			err = copy_from_user(extra, iwr->u.data.pointer,
+					     iwr->u.data.length *
+					     descr->token_size);
+			if (err) {
+				kfree(extra);
+				return -EFAULT;
+			}
+		}
+
+		/* Call the handler */
+		ret = handler(drv, dev, &info, &(iwr->u), extra);
+
+		/* If we have something to return to the user */
+		if (!ret && IW_IS_GET(cmd)) {
+			/* Check if there is enough buffer up there */
+			if(user_length < iwr->u.data.length) {
+				kfree(extra);
+				return -E2BIG;
+			}
+
+			err = copy_to_user(iwr->u.data.pointer, extra,
+					   iwr->u.data.length *
+					   descr->token_size);
+			if (err)
+				ret =  -EFAULT;
+		}
+
+		/* Generate an event to notify listeners of the change */
+		if((descr->flags & IW_DESCR_FLAG_EVENT) &&
+		   ((ret == 0) || (ret == -EIWCOMMIT))) {
+			if(descr->flags & IW_DESCR_FLAG_RESTRICT)
+				/* If the event is restricted, don't
+				 * export the payload */
+				wireless_send_event(dev, cmd, &(iwr->u), NULL);
+			else
+				wireless_send_event(dev, cmd, &(iwr->u),
+						    extra);
+		}
+
+		/* Cleanup - I told you it wasn't that long ;-) */
+		kfree(extra);
+	}
+
+	return ret;
+}
+
+/* and finally the ioctl wrapper */
+int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd)
+{
+	struct net_device *dev;
+	iw_compat_handler handler;
+	struct cfg80211_registered_driver *drv;
+
+	/* Permissions are already checked in dev_ioctl() before calling us.
+	 * The copy_to/from_user() of ifr is also dealt with in there */
+
+	/* Make sure the device exist */
+	if ((dev = __dev_get_by_name(ifr->ifr_name)) == NULL)
+		return -ENODEV;
+
+	drv = cfg80211_get_drv_from_ifindex(dev->ifindex);
+	if (!IS_ERR(drv))
+		return PTR_ERR(drv);
+
+	/* A bunch of special cases, then the generic case...
+	 * Note that 'cmd' is already filtered in dev_ioctl() with
+	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
+	switch(cmd) {
+		case SIOCGIWSTATS:
+			/* Get Wireless Stats */
+			return ioctl_standard_call(drv, dev, ifr, cmd,
+						   &iw_handler_get_iwstats);
+
+		case SIOCGIWPRIV:
+			return -EOPNOTSUPP;
+		default:
+			handler = get_handler(cmd);
+			if(cmd < SIOCIWFIRSTPRIV && handler != NULL)
+				return ioctl_standard_call(drv, dev, ifr, cmd,
+							   handler);
+			return -EOPNOTSUPP;
+	}
+	return -EINVAL;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/include/net/wireless.h	2007-02-09 17:07:25.543840519 +0100
@@ -0,0 +1,23 @@
+#ifndef __NET_WIRELESS_H
+#define __NET_WIRELESS_H
+
+/*
+ * internal definitions for wireless
+ */
+
+#if defined(CONFIG_CFG80211_WEXT_COMPAT) || defined(CONFIG_WIRELESS_EXT)
+int wext_ioctl(unsigned int cmd, struct ifreq *ifreq, void __user *arg);
+int wireless_proc_init(void);
+#else
+static inline
+int wext_ioctl(unsigned int cmd, struct ifreq *ifreq, void __user *arg)
+{
+	return -EINVAL;
+}
+static inline int wireless_proc_init(void)
+{
+	return 0;
+}
+#endif
+
+#endif /* __NET_WIRELESS_H */
--- linux-2.6.orig/include/net/iw_handler.h	2007-02-09 17:07:23.603840519 +0100
+++ linux-2.6/include/net/iw_handler.h	2007-02-09 17:07:25.543840519 +0100
@@ -433,9 +433,6 @@ struct iw_public_data {
 extern int dev_get_wireless_info(char * buffer, char **start, off_t offset,
 				 int length);
 
-/* Handle IOCTLs, called in net/core/dev.c */
-extern int wireless_process_ioctl(struct ifreq *ifr, unsigned int cmd);
-
 /* Handle RtNetlink requests, called in net/core/rtnetlink.c */
 extern int wireless_rtnetlink_set(struct net_device *	dev,
 				  char *		data,
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/wext-export.c	2007-02-09 17:07:25.543840519 +0100
@@ -0,0 +1,29 @@
+/*
+ * things we only need in the kernel when cfg80211 is modular.
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include "wext.h"
+
+EXPORT_SYMBOL_GPL(wext_standard_ioctl);
+EXPORT_SYMBOL_GPL(wext_standard_ioctl_num);
+EXPORT_SYMBOL_GPL(get_wireless_stats);
+
+struct cfg80211_ioctl_ops cfg80211_ioctl_ops;
+EXPORT_SYMBOL_GPL(cfg80211_ioctl_ops);
+
+int call_cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd)
+{
+	int err = -ENOSYS;
+
+	if (!try_module_get(cfg80211_ioctl_ops.module))
+		return -ENOSYS;
+
+	if (cfg80211_ioctl_ops.do_wext_ioctl)
+		err = cfg80211_ioctl_ops.do_wext_ioctl(ifr, cmd);
+
+	module_put(cfg80211_ioctl_ops.module);
+
+	return err;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6/net/wireless/wext-mod.c	2007-02-09 17:07:25.543840519 +0100
@@ -0,0 +1,20 @@
+/*
+ * things we only need in cfg80211 when it is modular.
+ *
+ * Copyright 2007       Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include "wext.h"
+
+int cfg80211_wext_init(void)
+{
+	cfg80211_ioctl_ops.do_wext_ioctl = cfg80211_wext_ioctl;
+	cfg80211_ioctl_ops.module = THIS_MODULE;
+	return 0;
+}
+
+void cfg80211_wext_exit(void)
+{
+	cfg80211_ioctl_ops.module = NULL;
+	cfg80211_ioctl_ops.do_wext_ioctl = NULL;
+}
--- linux-2.6.orig/net/wireless/core.c	2007-02-09 17:07:24.553840519 +0100
+++ linux-2.6/net/wireless/core.c	2007-02-09 17:07:25.543840519 +0100
@@ -13,6 +13,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "sysfs.h"
+#include "wext.h"
 
 MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
@@ -149,12 +150,28 @@ EXPORT_SYMBOL(wiphy_free);
 
 static int cfg80211_init(void)
 {
-	return wiphy_sysfs_init();
+	int err = wiphy_sysfs_init();
+
+	if (err)
+		return err;
+
+	err = cfg80211_wext_init();
+
+	if (err)
+		goto out_exit_sysfs;
+
+	return 0;
+
+ out_exit_sysfs:
+ 	wiphy_sysfs_exit();
+
+	return err;
 }
 module_init(cfg80211_init);
 
 static void cfg80211_exit(void)
 {
+	cfg80211_wext_exit();
 	wiphy_sysfs_exit();
 }
 module_exit(cfg80211_exit);

--

