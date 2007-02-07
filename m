Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3483 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030504AbXBGBO7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Feb 2007 20:14:59 -0500
Date: Tue, 6 Feb 2007 19:49:29 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 3/3] cfg80211: add wext-compatible client
Message-ID: <20070207004929.GD23096@tuxdriver.com>
References: <20070131013717.GA28076@tuxdriver.com> <20070207004626.GA23096@tuxdriver.com> <20070207004747.GB23096@tuxdriver.com> <20070207004832.GC23096@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070207004832.GC23096@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 include/linux/netdevice.h  |    7 +-
 include/net/cfg80211.h     |   34 +-
 net/Kconfig                |   28 +
 net/core/dev.c             |   38 +-
 net/core/net-sysfs.c       |    4 +-
 net/core/rtnetlink.c       |   42 ++-
 net/wireless/Makefile      |   10 +
 net/wireless/core.c        |   15 +-
 net/wireless/core.h        |   21 +
 net/wireless/wext-common.c |  610 ++++++++++++++++
 net/wireless/wext-compat.c | 1646 +++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/wext-old.c    |  629 +-----------------
 net/wireless/wext.h        |   13 +
 13 files changed, 2433 insertions(+), 664 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c1e9962..6a9b4c8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -348,12 +348,17 @@ struct net_device
 
 	struct net_device_stats* (*get_stats)(struct net_device *dev);
 
+#ifdef CONFIG_WIRELESS_EXT
 	/* List of functions to handle Wireless Extensions (instead of ioctl).
 	 * See <net/iw_handler.h> for details. Jean II */
 	const struct iw_handler_def *	wireless_handlers;
 	/* Instance data managed by the core of Wireless Extensions. */
 	struct iw_public_data *	wireless_data;
-
+#endif
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	/* pending config used by cfg80211/wext compat code only */
+	void *cfg80211_wext_pending_config;
+#endif
 	const struct ethtool_ops *ethtool_ops;
 
 	/*
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c0bc9d4..353d3ce 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5,6 +5,7 @@
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 #include <net/genetlink.h>
+#include <linux/wireless.h>
 
 /*
  * 802.11 configuration in-kernel interface
@@ -16,21 +17,12 @@
  * struct cfg80211_config - description of a configuration (request)
  */
 struct cfg80211_config {
-	/* first fields with 'internal' validity */
+	/* see below */
+	u32 valid;
 
-	/* SSID to use, valid if not NULL, ssid_len then
-	 * contains the length. change forces reassociation */
 	s8 ssid_len;
 	u8 *ssid;
 
-	/* now fields with explicit validity */
-#define CFG80211_CFG_VALID_NWID			(1<<0)
-#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<1)
-#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<2)
-#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<3)
-#define CFG80211_CFG_VALID_CHANNEL		(1<<4)
-	unsigned int valid;
-
 	u16 network_id;
 	s32 rx_sensitivity;
 	u32 transmit_power;
@@ -38,6 +30,13 @@ struct cfg80211_config {
 	u32 channel;
 };
 
+#define CFG80211_CFG_VALID_SSID			(1<<0)
+#define CFG80211_CFG_VALID_NWID			(1<<1)
+#define CFG80211_CFG_VALID_RX_SENSITIVITY	(1<<2)
+#define CFG80211_CFG_VALID_TRANSMIT_POWER	(1<<3)
+#define CFG80211_CFG_VALID_FRAG_THRESHOLD	(1<<4)
+#define CFG80211_CFG_VALID_CHANNEL		(1<<5)
+
 struct scan_channel {
 	u32 channel;
 	int active;
@@ -86,6 +85,9 @@ struct scan_params {
  *
  * @get_config: fill the given config structure with the current configuration
  *
+ * @get_config_valid: return a bitmask of CFG80211_CFG_VALID_* indicating
+ *		      which parameters can be set.
+ *
  * @reassociate: reassociate with current settings (SSID, BSSID if
  *		 userspace roaming is enabled)
  *
@@ -132,6 +134,7 @@ struct cfg80211_ops {
 			     struct cfg80211_config *cfg);
 	void	(*get_config)(void *priv, struct net_device *dev,
 			      struct cfg80211_config *cfg);
+	u32	(*get_config_valid)(void *priv, struct net_device *dev);
 
 
 	int	(*reassociate)(void *priv, struct net_device *dev);
@@ -183,4 +186,13 @@ extern int cfg80211_register(struct cfg80211_ops *ops, void *priv);
  */
 extern void cfg80211_unregister(void *priv);
 
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+extern int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+int cfg80211_wext_nl_set(struct net_device *dev, char *data, int len);
+int cfg80211_wext_nl_get(struct net_device *dev, char *data, int len,
+			 char **p_buf, int *p_len);
+#endif
+#endif
+
 #endif /* __NET_CFG80211_H */
diff --git a/net/Kconfig b/net/Kconfig
index 8d121a5..fade3fd 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -229,6 +229,34 @@ config FIB_RULES
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
+config CFG80211_WEXTNL_COMPAT
+	bool "cfg80211 WE-netlink compatibility"
+	depends CFG80211 && CFG80211_WEXT_COMPAT
+	---help---
+	This option allows using devices whose drivers have been
+	converted to use the new cfg80211 with wireless extensions
+	over rtnetlink, providing WE-20 compatibility. Note that
+	cfg80211's "native" interface is nl80211 using generic netlink.
+	The wireless extensions are being deprecated and the netlink
+	based API for WE was never configured by default, nor do any
+	userspace tools use this feature.
+
+	This option exists only to make Jean happy. Say N.
+
 endif   # if NET
 endmenu # Networking
 
diff --git a/net/core/dev.c b/net/core/dev.c
index c8822aa..31a3cba 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -116,6 +116,7 @@
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
+#include <net/cfg80211.h>
 
 /*
  *	The list of packet types we will receive (as opposed to discard)
@@ -2228,7 +2229,7 @@ static struct file_operations softnet_seq_fops = {
 	.release = seq_release,
 };
 
-#ifdef CONFIG_WIRELESS_EXT
+#if defined(CONFIG_WIRELESS_EXT) || defined(CFG80211_WEXT_COMPAT)
 extern int wireless_proc_init(void);
 #else
 #define wireless_proc_init() 0
@@ -2798,6 +2799,39 @@ int dev_ioctl(unsigned int cmd, void __user *arg)
 					ret = -EFAULT;
 				return ret;
 			}
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+			/* Take care of cfg80211 WE compatibility */
+			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
+				/* If command is `set a parameter', or
+				 * `get the encoding parameters', check if
+				 * the user has the right to do it */
+				if (IW_IS_SET(cmd) || cmd == SIOCGIWENCODE
+				    || cmd == SIOCGIWENCODEEXT) {
+					if (!capable(CAP_NET_ADMIN))
+						return -EPERM;
+				}
+				dev_load(ifr.ifr_name);
+				rtnl_lock();
+				/* Follow me in net/wireless/wext-compat.c */
+				ret = cfg80211_wext_ioctl(&ifr, cmd);
+				rtnl_unlock();
+				if (ret == 0 && IW_IS_GET(cmd) &&
+				    copy_to_user(arg, &ifr,
+						 sizeof(struct ifreq)))
+					ret = -EFAULT;
+				/* haha, I cheat here by allowing a driver or
+				 * stack to have both WE or CFG80211-WE for
+				 * a little while during conversion... hope that
+				 * ENOSYS is only used to indicate not implemented
+				 *
+				 * if wireless extensions are not configured
+				 * then this is the last thing here so that
+				 * if we fall through we return -EINVAL
+				 */
+				if (ret != -ENOSYS)
+					return ret;
+			}
+#endif
 #ifdef CONFIG_WIRELESS_EXT
 			/* Take care of Wireless Extensions */
 			if (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) {
@@ -2814,7 +2848,7 @@ int dev_ioctl(unsigned int cmd, void __user *arg)
 				/* Follow me in net/wireless/wext-old.c */
 				ret = wireless_process_ioctl(&ifr, cmd);
 				rtnl_unlock();
-				if (IW_IS_GET(cmd) &&
+				if (ret == 0 && IW_IS_GET(cmd) &&
 				    copy_to_user(arg, &ifr,
 					    	 sizeof(struct ifreq)))
 					ret = -EFAULT;
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index f47f319..44e69a2 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -329,7 +329,7 @@ static struct attribute_group netstat_group = {
 	.attrs  = netstat_attrs,
 };
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 /* helper function that does all the locking etc for wireless stats */
 static ssize_t wireless_show(struct class_device *cd, char *buf,
 			     ssize_t (*format)(const struct iw_statistics *,
@@ -462,7 +462,7 @@ int netdev_register_sysfs(struct net_device *net)
 	if (net->get_stats)
 		*groups++ = &netstat_group;
 
-#ifdef WIRELESS_EXT
+#ifdef CONFIG_WIRELESS_EXT
 	if (net->wireless_handlers && net->wireless_handlers->get_wireless_stats)
 		*groups++ = &wireless_group;
 #endif
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index e76539a..45c3d39 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -56,6 +56,9 @@
 #include <linux/wireless.h>
 #include <net/iw_handler.h>
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+#include <net/cfg80211.h>
+#endif
 
 static DEFINE_MUTEX(rtnl_mutex);
 static struct sock *rtnl;
@@ -536,6 +539,20 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh, void *arg)
 		modified = 1;
 	}
 
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+	if (tb[IFLA_WIRELESS]) {
+		/* Call cfg80211 WE backward compat code.
+		 * Various stuff checked in there... */
+		err = cfg80211_wext_nl_set(dev, nla_data(tb[IFLA_WIRELESS]),
+					   nla_len(tb[IFLA_WIRELESS]));
+		if (err < 0 && err != -ENOSYS)
+			goto errout_dev;
+#ifdef CONFIG_NET_WIRELESS_RTNETLINK
+		if (err == 0)
+			goto skip_old_wext_nl;
+#endif
+	}
+#endif
 #ifdef CONFIG_NET_WIRELESS_RTNETLINK
 	if (tb[IFLA_WIRELESS]) {
 		/* Call Wireless Extensions.
@@ -545,8 +562,10 @@ static int rtnl_setlink(struct sk_buff *skb, struct nlmsghdr *nlh, void *arg)
 		if (err < 0)
 			goto errout_dev;
 	}
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+ skip_old_wext_nl:
+#endif
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
-
 	if (tb[IFLA_BROADCAST]) {
 		nla_memcpy(dev->broadcast, tb[IFLA_BROADCAST], dev->addr_len);
 		send_addr_notify = 1;
@@ -611,6 +630,24 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 		return -EINVAL;
 
 
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+	if (tb[IFLA_WIRELESS]) {
+		/* Call Wireless Extensions. We need to know the size before
+		 * we can alloc. Various stuff checked in there... */
+		err = cfg80211_wext_nl_get(dev, nla_data(tb[IFLA_WIRELESS]),
+					   nla_len(tb[IFLA_WIRELESS]),
+					   &iw_buf, &iw_buf_len);
+		if (err < 0 && err != -ENOSYS)
+			goto errout;
+
+		iw += IW_EV_POINT_OFF;
+#ifdef CONFIG_NET_WIRELESS_RTNETLINK
+		if (err == 0)
+			goto skip_old_wext_nl;
+		iw -= IW_EV_POINT_OFF;
+#endif
+	}
+#endif
 #ifdef CONFIG_NET_WIRELESS_RTNETLINK
 	if (tb[IFLA_WIRELESS]) {
 		/* Call Wireless Extensions. We need to know the size before
@@ -623,6 +660,9 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr* nlh, void *arg)
 
 		iw += IW_EV_POINT_OFF;
 	}
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+ skip_old_wext_nl:
+#endif
 #endif	/* CONFIG_NET_WIRELESS_RTNETLINK */
 
 	nskb = nlmsg_new(if_nlmsg_size(iw_buf_len), GFP_KERNEL);
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index 663a7d8..62e67b7 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -4,3 +4,13 @@ cfg80211-objs := \
 	core.o
 
 obj-$(CONFIG_WIRELESS_EXT) += wext-old.o
+
+obj-nn :=
+obj-yy :=
+obj-yn :=
+obj-ny :=
+
+# this needs to be compiled in...
+obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
+obj-$(CONFIG_CFG80211_WEXT_COMPAT)$(CONFIG_NET_WIRELESS) += wext-common.o
+obj-y += $(obj-yy) $(obj-yn) $(obj-ny)
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 60b280e..ce50ae4 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -56,7 +56,7 @@ cfg80211_get_drv_from_ifindex(int ifindex)
 	if (drv)
 		mutex_lock(&drv->mtx);
 	else
-		drv = ERR_PTR(-ENODEV);
+		drv = ERR_PTR(-ENOSYS);
 	dev_put(dev);
  out:
 	mutex_unlock(&cfg80211_drv_mutex);
@@ -146,12 +146,23 @@ EXPORT_SYMBOL_GPL(cfg80211_unregister);
 
 static int cfg80211_init(void)
 {
-	/* possibly need to do more later */
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	cfg80211_core_ops.get_drv_from_ifidx = cfg80211_get_drv_from_ifindex;
+	cfg80211_core_ops.put_drv = cfg80211_put_drv;
+	cfg80211_core_ops.module = THIS_MODULE;
+	cfg80211_core_ops.loaded = 1;
+#endif
 	return 0;
 }
 
 static void cfg80211_exit(void)
 {
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	cfg80211_core_ops.loaded = 0;
+	cfg80211_core_ops.module = NULL;
+	cfg80211_core_ops.get_drv_from_ifidx = NULL;
+	cfg80211_core_ops.put_drv = NULL;
+#endif
 }
 
 module_init(cfg80211_init);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 562c476..595f184 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -9,6 +9,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <net/genetlink.h>
+#include <linux/module.h>
 
 struct cfg80211_registered_driver {
 	struct cfg80211_ops *ops;
@@ -25,6 +26,26 @@ struct cfg80211_registered_driver {
 extern struct mutex cfg80211_drv_mutex;
 extern struct list_head cfg80211_drv_list;
 
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+/* wext compatibility must be compiled in...
+ * this extern is in wext-compat.c */
+struct cfg80211_core_ops {
+	/* flag to see if cfg80211 is there.
+	 * FIXME: isn't that racy? */
+	int loaded;
+
+	/* used to make sure the module isn't going away
+	 * can't really happen, except if no driver has cfg80211
+	 * in use, but in that case  */
+	struct module *module;
+
+	/* and finally these are used to do work */
+	struct cfg80211_registered_driver *(*get_drv_from_ifidx)(int ifidx);
+	void (*put_drv)(struct cfg80211_registered_driver *drv);
+};
+extern struct cfg80211_core_ops cfg80211_core_ops;
+#endif
+
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.
diff --git a/net/wireless/wext-common.c b/net/wireless/wext-common.c
new file mode 100644
index 0000000..c1de1d7
--- /dev/null
+++ b/net/wireless/wext-common.c
@@ -0,0 +1,610 @@
+/* common wext support routines, proc interface and events */
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
+const struct iw_ioctl_description standard_ioctl[] = {
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
+const unsigned standard_ioctl_num = (sizeof(standard_ioctl) /
+					sizeof(struct iw_ioctl_description));
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
+		if(cmd_index < standard_ioctl_num)
+			descr = &(standard_ioctl[cmd_index]);
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
+		printk(KERN_ERR "%s (WE) : Invalid/Unknown Wireless Event (0x%04X)\n",
+		       dev->name, cmd);
+		return;
+	}
+
+	/* Check extra parameters and set extra_len */
+	if(descr->header_type == IW_HEADER_TYPE_POINT) {
+		/* Check if number of token fits within bounds */
+		if(wrqu->data.length > descr->max_tokens) {
+			printk(KERN_ERR "%s (WE) : Wireless Event too big (%d)\n", dev->name, wrqu->data.length);
+			return;
+		}
+		if(wrqu->data.length < descr->min_tokens) {
+			printk(KERN_ERR "%s (WE) : Wireless Event too small (%d)\n", dev->name, wrqu->data.length);
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
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 1c7c361..0cf6ce9 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1,25 +1,1633 @@
-/* NOT YET */
+/*
+ * wireless extensions compatibility for cfg80211.
+ *
+ * Lots of code from the original wireless.c:
+ * Copyright 1997-2006	Jean Tourrilhes <jt@hpl.hp.com>
+ *
+ * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
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
 
-To implement compatibility, we add a new field to struct net_device
-that contains the pending configuration structure. This is dynamically
-allocated when needed and freed when committed.
-In a way it replaces the wireless_handlers field in there which is now
-done by dynamic lookup. No worries. No one is going to have thousands
-of wireless devices, and if that changes we can still trivially change
-this assumption :)
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_arp.h>
+#include <linux/etherdevice.h>
+#include <linux/wireless.h>
+#include <net/iw_handler.h>
+#include <net/netlink.h>
+#include <asm/uaccess.h>
+#include <net/cfg80211.h>
 
-Commit is done some time after the last parameter was changed
-(with each parameter change simply (re-)schedule a timer) or
-if explicitly asked for. This is probably not what most people
-would expect, but perfectly fine in the WE API.
+#include "core.h"
+#include "wext.h"
 
-compatibility mappings:
+/* The cfg80211 driver assigns callbacks in this
+ * if it is loaded. If not, then we can't config
+ * anything anyway... */
+struct cfg80211_core_ops cfg80211_core_ops;
+EXPORT_SYMBOL_GPL(cfg80211_core_ops);
 
-SIOCSIWAP
-  -> if bssid is all-ones: set roaming to kernel, reassociate
-  -> if bssid is all-zeroes: set roaming to kernel
-  -> otherwise: set roaming to userspace, set bssid
+static struct cfg80211_registered_driver *cfg80211_wx_setup(int ifindex)
+{
+	if (!cfg80211_core_ops.loaded)
+		return ERR_PTR(-ENOSYS);
+	if (!try_module_get(cfg80211_core_ops.module))
+		return ERR_PTR(-ENOSYS);
 
-SIOCGIWAP
-  -> get association parameters and fill return bssid appropriately
+	return cfg80211_core_ops.get_drv_from_ifidx(ifindex);
+}
 
+static void cfg80211_wx_teardown(struct cfg80211_registered_driver *drv)
+{
+	if (!IS_ERR(drv))
+		cfg80211_core_ops.put_drv(drv);
+	module_put(cfg80211_core_ops.module);
+}
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
+static void cfg80211_ensure_netdev_pending_cfg(struct net_device *dev)
+{
+	struct cfg80211_config *cfg = dev->cfg80211_wext_pending_config;
+	if (!cfg) {
+		cfg = kmalloc(sizeof(*cfg)+32, GFP_KERNEL);
+		cfg->ssid = (char*)cfg + sizeof(*cfg);
+		dev->cfg80211_wext_pending_config = cfg;
+	}
+}
+
+/* operations we implement. whew, I machine-generated these */
+static int cfg80211_wx_set_commit(struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	if (!net_dev->cfg80211_wext_pending_config) {
+		err = 0;
+		goto out;
+	}
+
+	err = drv->ops->configure(drv->priv, net_dev,
+				  net_dev->cfg80211_wext_pending_config);
+
+	kfree(net_dev->cfg80211_wext_pending_config);
+	net_dev->cfg80211_wext_pending_config = NULL;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_name(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_nwid(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_nwid(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_freq(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_freq(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_mode(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_mode(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_sens(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_sens(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_range(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_range(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_ap(struct net_device *net_dev,
+			      struct iw_request_info *info,
+			      union iwreq_data *data,
+			      char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	/* SIOCSIWAP
+	 *   -> if bssid is all-ones: set roaming to kernel, reassociate
+	 *   -> if bssid is all-zeroes: set roaming to kernel
+	 *   -> otherwise: set roaming to userspace, set bssid
+	 */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_ap(struct net_device *net_dev,
+			      struct iw_request_info *info,
+			      union iwreq_data *data,
+			      char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	/* SIOCGIWAP
+	 *   -> get association parameters and fill return bssid appropriately
+	 */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_mlme(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_waplist(struct net_device *net_dev,
+				   struct iw_request_info *info,
+				   union iwreq_data *data,
+				   char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_scan(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_scan(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_essid(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+	struct cfg80211_config *cfg;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	err = -ENOSYS;
+	if (!drv->ops->configure || !drv->ops->get_config_valid)
+		goto out;
+	if (!(drv->ops->get_config_valid(drv->priv, net_dev)
+			& CFG80211_CFG_VALID_SSID))
+		goto out;
+
+	cfg80211_ensure_netdev_pending_cfg(net_dev);
+	cfg = net_dev->cfg80211_wext_pending_config;
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
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_essid(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_rate(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_rate(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_rts(struct net_device *net_dev,
+			       struct iw_request_info *info,
+			       union iwreq_data *data,
+			       char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_rts(struct net_device *net_dev,
+			       struct iw_request_info *info,
+			       union iwreq_data *data,
+			       char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_frag(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_frag(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_txpow(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_txpow(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_retry(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_retry(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_encode(struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_encode(struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_power(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_power(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_genie(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_genie(struct net_device *net_dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *data,
+				 char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_auth(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_auth(struct net_device *net_dev,
+			        struct iw_request_info *info,
+			        union iwreq_data *data,
+			        char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_encodeext(struct net_device *net_dev,
+				     struct iw_request_info *info,
+				     union iwreq_data *data,
+				     char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_get_encodeext(struct net_device *net_dev,
+				     struct iw_request_info *info,
+				     union iwreq_data *data,
+				     char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+static int cfg80211_wx_set_wpmksa(struct net_device *net_dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *data,
+				  char *extra)
+{
+	struct cfg80211_registered_driver *drv;
+	int err;
+
+	drv = cfg80211_wx_setup(net_dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out;
+	}
+
+	/* TODO: DO SOMETHING */
+	err = -ENOSYS;
+
+ out:
+	cfg80211_wx_teardown(drv);
+	return err;
+}
+
+
+
+/* operations array */
+#ifdef WX
+# undef WX
+#endif
+#define WX(ioctl)  [(ioctl) - SIOCIWFIRST]
+static const iw_handler cfg80211_wx_handlers[] = {
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
+static iw_handler get_handler(struct net_device *dev, unsigned int cmd)
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
+static int iw_handler_get_iwstats(struct net_device *		dev,
+				  struct iw_request_info *	info,
+				  union iwreq_data *		wrqu,
+				  char *			extra)
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
+#ifdef CONFIG_CFG80211_WEXTNL_COMPAT
+/*
+ * Wrapper to call a standard Wireless Extension GET handler.
+ * We do various checks and call the handler with the proper args.
+ */
+static int rtnetlink_standard_get(struct net_device *	dev,
+				  struct iw_event *	request,
+				  int			request_len,
+				  iw_handler		handler,
+				  char **		p_buf,
+				  int *			p_len)
+{
+	const struct iw_ioctl_description *	descr = NULL;
+	unsigned int				cmd;
+	union iwreq_data *			wrqu;
+	int					hdr_len;
+	struct iw_request_info			info;
+	char *					buffer = NULL;
+	int					buffer_size = 0;
+	int					ret = -EINVAL;
+
+	/* Get the description of the Request */
+	cmd = request->cmd;
+	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+		return -EOPNOTSUPP;
+	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+
+	/* Check if wrqu is complete */
+	hdr_len = event_type_size[descr->header_type];
+	if(request_len < hdr_len)
+		return -EINVAL;
+
+	/* Prepare the call */
+	info.cmd = cmd;
+	info.flags = 0;
+
+	/* Check if we have extra data in the reply or not */
+	if(descr->header_type != IW_HEADER_TYPE_POINT) {
+
+		/* Create the kernel buffer that we will return.
+		 * It's at an offset to match the TYPE_POINT case... */
+		buffer_size = request_len + IW_EV_POINT_OFF;
+		buffer = kmalloc(buffer_size, GFP_KERNEL);
+		if (buffer == NULL) {
+			return -ENOMEM;
+		}
+		/* Copy event data */
+		memcpy(buffer + IW_EV_POINT_OFF, request, request_len);
+		/* Use our own copy of wrqu */
+		wrqu = (union iwreq_data *) (buffer + IW_EV_POINT_OFF
+					     + IW_EV_LCP_LEN);
+
+		/* No extra arguments. Trivial to handle */
+		ret = handler(dev, &info, wrqu, NULL);
+
+	} else {
+		union iwreq_data	wrqu_point;
+		char *			extra = NULL;
+		int			extra_size = 0;
+
+		/* Get a temp copy of wrqu (skip pointer) */
+		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
+		       ((char *) request) + IW_EV_LCP_LEN,
+		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+
+		/* Calculate space needed by arguments. Always allocate
+		 * for max space. Easier, and won't last long... */
+		extra_size = descr->max_tokens * descr->token_size;
+		/* Support for very large requests */
+		if((descr->flags & IW_DESCR_FLAG_NOMAX) &&
+		   (wrqu_point.data.length > descr->max_tokens))
+			extra_size = (wrqu_point.data.length
+				      * descr->token_size);
+		buffer_size = extra_size + IW_EV_POINT_LEN + IW_EV_POINT_OFF;
+
+		/* Create the kernel buffer that we will return */
+		buffer = kmalloc(buffer_size, GFP_KERNEL);
+		if (buffer == NULL) {
+			return -ENOMEM;
+		}
+
+		/* Put wrqu in the right place (just before extra).
+		 * Leave space for IWE header and dummy pointer...
+		 * Note that IW_EV_LCP_LEN==4 bytes, so it's still aligned...
+		 */
+		memcpy(buffer + IW_EV_LCP_LEN + IW_EV_POINT_OFF,
+		       ((char *) &wrqu_point) + IW_EV_POINT_OFF,
+		       IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		wrqu = (union iwreq_data *) (buffer + IW_EV_LCP_LEN);
+
+		/* Extra comes logically after that. Offset +12 bytes. */
+		extra = buffer + IW_EV_POINT_OFF + IW_EV_POINT_LEN;
+
+		/* Call the handler */
+		ret = handler(dev, &info, wrqu, extra);
+
+		/* Calculate real returned length */
+		extra_size = (wrqu->data.length * descr->token_size);
+		/* Re-adjust reply size */
+		request->len = extra_size + IW_EV_POINT_LEN;
+
+		/* Put the iwe header where it should, i.e. scrap the
+		 * dummy pointer. */
+		memcpy(buffer + IW_EV_POINT_OFF, request, IW_EV_LCP_LEN);
+
+		/* Check if there is enough buffer up there */
+		if(wrqu_point.data.length < wrqu->data.length)
+			ret = -E2BIG;
+	}
+
+	/* Return the buffer to the caller */
+	if (!ret) {
+		*p_buf = buffer;
+		*p_len = request->len;
+	} else {
+		/* Cleanup */
+		if(buffer)
+			kfree(buffer);
+	}
+
+	return ret;
+}
+
+/*
+ * Wrapper to call a standard Wireless Extension SET handler.
+ * We do various checks and call the handler with the proper args.
+ */
+static inline int rtnetlink_standard_set(struct net_device *	dev,
+					 struct iw_event *	request,
+					 int			request_len,
+					 iw_handler		handler)
+{
+	const struct iw_ioctl_description *	descr = NULL;
+	unsigned int				cmd;
+	union iwreq_data *			wrqu;
+	union iwreq_data			wrqu_point;
+	int					hdr_len;
+	char *					extra = NULL;
+	int					extra_size = 0;
+	struct iw_request_info			info;
+	int					ret = -EINVAL;
+
+	/* Get the description of the Request */
+	cmd = request->cmd;
+	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+		return -EOPNOTSUPP;
+	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+
+	/* Extract fixed header from request. This is properly aligned. */
+	wrqu = &request->u;
+
+	/* Check if wrqu is complete */
+	hdr_len = event_type_size[descr->header_type];
+	if(request_len < hdr_len)
+		return -EINVAL;
+
+	/* Prepare the call */
+	info.cmd = cmd;
+	info.flags = 0;
+
+	/* Check if we have extra data in the request or not */
+	if(descr->header_type != IW_HEADER_TYPE_POINT) {
+
+		/* No extra arguments. Trivial to handle */
+		ret = handler(dev, &info, wrqu, NULL);
+
+	} else {
+		int	extra_len;
+
+		/* Put wrqu in the right place (skip pointer) */
+		memcpy(((char *) &wrqu_point) + IW_EV_POINT_OFF,
+		       wrqu, IW_EV_POINT_LEN - IW_EV_LCP_LEN);
+		/* Don't forget about the event code... */
+		wrqu = &wrqu_point;
+
+		/* Check if number of token fits within bounds */
+		if(wrqu_point.data.length > descr->max_tokens)
+			return -E2BIG;
+		if(wrqu_point.data.length < descr->min_tokens)
+			return -EINVAL;
+
+		/* Real length of payload */
+		extra_len = wrqu_point.data.length * descr->token_size;
+
+		/* Check if request is self consistent */
+		if((request_len - hdr_len) < extra_len)
+			return -EINVAL;
+
+		/* Always allocate for max space. Easier, and won't last
+		 * long... */
+		extra_size = descr->max_tokens * descr->token_size;
+		extra = kmalloc(extra_size, GFP_KERNEL);
+		if (extra == NULL)
+			return -ENOMEM;
+
+		/* Copy extra in aligned buffer */
+		memcpy(extra, ((char *) request) + hdr_len, extra_len);
+
+		/* Call the handler */
+		ret = handler(dev, &info, &wrqu_point, extra);
+	}
+
+        /* Generate an event to notify listeners of the change */
+	if ((descr->flags & IW_DESCR_FLAG_EVENT) &&
+	    ((ret == 0) || (ret == -EIWCOMMIT))) {
+		if(descr->flags & IW_DESCR_FLAG_RESTRICT)
+			/* If the event is restricted, don't
+			 * export the payload */
+			wireless_send_event(dev, cmd, wrqu, NULL);
+		else
+			wireless_send_event(dev, cmd, wrqu, extra);
+	}
+
+	/* Cleanup - I told you it wasn't that long ;-) */
+	if(extra)
+		kfree(extra);
+
+	return ret;
+}
+
+/*
+ * Main RtNetlink dispatcher. Called from the main networking code
+ * (do_getlink() in net/core/rtnetlink.c).
+ * Check the type of Request and call the appropriate wrapper...
+ */
+int cfg80211_wext_nl_get(struct net_device *	dev,
+			 char *			data,
+			 int			len,
+			 char **		p_buf,
+			 int *			p_len)
+{
+	struct iw_event *	request = (struct iw_event *) data;
+	iw_handler		handler;
+
+	/* Check length */
+	if(len < IW_EV_LCP_LEN) {
+		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
+		       dev->name, len);
+		return -EINVAL;
+	}
+
+	/* ReCheck length (len may have padding) */
+	if(request->len > len) {
+		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
+		       dev->name, request->len, len);
+		return -EINVAL;
+	}
+
+	/* Only accept GET requests in here */
+	if(!IW_IS_GET(request->cmd))
+		return -EOPNOTSUPP;
+
+	/* If command is `get the encoding parameters', check if
+	 * the user has the right to do it */
+	if (request->cmd == SIOCGIWENCODE ||
+	    request->cmd == SIOCGIWENCODEEXT) {
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+	}
+
+	/* Special cases */
+	if(request->cmd == SIOCGIWSTATS)
+		/* Get Wireless Stats */
+		return rtnetlink_standard_get(dev,
+					      request,
+					      request->len,
+					      &iw_handler_get_iwstats,
+					      p_buf, p_len);
+	if(request->cmd == SIOCGIWPRIV)
+		return -EOPNOTSUPP;
+
+	/* Basic check */
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	/* Try to find the handler */
+	handler = get_handler(dev, request->cmd);
+	if (handler != NULL && request->cmd < SIOCIWFIRSTPRIV)
+		return rtnetlink_standard_get(dev,
+					      request,
+					      request->len,
+					      handler,
+					      p_buf, p_len);
+
+	return -EOPNOTSUPP;
+}
+
+/*
+ * Main RtNetlink dispatcher. Called from the main networking code
+ * (do_setlink() in net/core/rtnetlink.c).
+ * Check the type of Request and call the appropriate wrapper...
+ */
+int cfg80211_wext_nl_set(struct net_device *	dev,
+			 char *			data,
+			 int			len)
+{
+	struct iw_event *	request = (struct iw_event *) data;
+	iw_handler		handler;
+
+	/* Check length */
+	if(len < IW_EV_LCP_LEN) {
+		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request too short (%d)\n",
+		       dev->name, len);
+		return -EINVAL;
+	}
+
+	/* ReCheck length (len may have padding) */
+	if(request->len > len) {
+		printk(KERN_DEBUG "%s (WE.r) : RtNetlink request len invalid (%d-%d)\n",
+		       dev->name, request->len, len);
+		return -EINVAL;
+	}
+
+	/* Only accept SET requests in here */
+	if(!IW_IS_SET(request->cmd))
+		return -EOPNOTSUPP;
+
+	/* Basic check */
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	/* New driver API : try to find the handler */
+	handler = get_handler(dev, request->cmd);
+	if(handler != NULL && request->cmd < SIOCIWFIRSTPRIV)
+		return rtnetlink_standard_set(dev,
+					      request,
+					      request->len,
+					      handler);
+
+	return -EOPNOTSUPP;
+}
+#endif
+
+/*
+ * Wrapper to call a standard Wireless Extension handler.
+ * We do various checks and also take care of moving data between
+ * user space and kernel space.
+ */
+static int ioctl_standard_call(struct net_device *	dev,
+			       struct ifreq *		ifr,
+			       unsigned int		cmd,
+			       iw_handler		handler)
+{
+	struct iwreq *				iwr = (struct iwreq *) ifr;
+	const struct iw_ioctl_description *	descr;
+	struct iw_request_info			info;
+	int					ret = -EINVAL;
+
+	/* Get the description of the IOCTL */
+	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+		return -EOPNOTSUPP;
+	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+
+	/* Prepare the call */
+	info.cmd = cmd;
+	info.flags = 0;
+
+	/* Check if we have a pointer to user space data or not */
+	if(descr->header_type != IW_HEADER_TYPE_POINT) {
+
+		/* No extra arguments. Trivial to handle */
+		ret = handler(dev, &info, &(iwr->u), NULL);
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
+		ret = handler(dev, &info, &(iwr->u), extra);
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
+	iw_handler	handler;
+
+	/* Permissions are already checked in dev_ioctl() before calling us.
+	 * The copy_to/from_user() of ifr is also dealt with in there */
+
+	/* Make sure the device exist */
+	if ((dev = __dev_get_by_name(ifr->ifr_name)) == NULL)
+		return -ENODEV;
+
+	/* A bunch of special cases, then the generic case...
+	 * Note that 'cmd' is already filtered in dev_ioctl() with
+	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
+	switch(cmd) {
+		case SIOCGIWSTATS:
+			/* Get Wireless Stats */
+			return ioctl_standard_call(dev,
+						   ifr,
+						   cmd,
+						   &iw_handler_get_iwstats);
+
+		case SIOCGIWPRIV:
+			return -EOPNOTSUPP;
+		default:
+			/* Basic check */
+			if (!netif_device_present(dev))
+				return -ENODEV;
+			handler = get_handler(dev, cmd);
+			if(cmd < SIOCIWFIRSTPRIV && handler != NULL)
+				return ioctl_standard_call(dev, ifr, cmd,
+							   handler);
+			return -EOPNOTSUPP;
+	}
+	return -EINVAL;
+}
diff --git a/net/wireless/wext-old.c b/net/wireless/wext-old.c
index f69ab7b..9892396 100644
--- a/net/wireless/wext-old.c
+++ b/net/wireless/wext-old.c
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
@@ -412,21 +124,6 @@ static const char iw_priv_type_size[] = {
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
-
 /************************ COMMON SUBROUTINES ************************/
 /*
  * Stuff that may be used in various place or doesn't fit in one
@@ -464,21 +161,6 @@ static inline iw_handler get_handler(struct net_device *dev,
 
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
@@ -551,7 +233,7 @@ static int iw_handler_get_iwstats(struct net_device *		dev,
 	/* Get stats from the driver */
 	struct iw_statistics *stats;
 
-	stats = get_wireless_stats(dev);
+	stats = get_wireless_stats(dev, NULL);
 	if (stats != (struct iw_statistics *) NULL) {
 
 		/* Copy statistics to extra */
@@ -601,97 +283,6 @@ static int iw_handler_get_private(struct net_device *		dev,
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
@@ -1863,220 +1454,6 @@ int wireless_rtnetlink_set(struct net_device *	dev,
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
diff --git a/net/wireless/wext.h b/net/wireless/wext.h
new file mode 100644
index 0000000..fcf1c5a
--- /dev/null
+++ b/net/wireless/wext.h
@@ -0,0 +1,13 @@
+/*
+ * some foo for wext compat/wext interoperability
+ */
+#ifndef _WEXT_H
+#define _WEXT_H
+#include <linux/wireless.h>
+extern struct iw_statistics *get_wireless_stats(struct net_device *dev,
+						struct iw_statistics *out);
+extern const struct iw_ioctl_description standard_ioctl[];
+extern const unsigned standard_ioctl_num;
+extern const struct iw_ioctl_description standard_event[];
+extern const int event_type_size[];
+#endif /* _WEXT_H */
-- 
1.4.4.2

-- 
John W. Linville
linville@tuxdriver.com
