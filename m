Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbXBOO7w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 09:59:52 -0500
Message-Id: <20070215144257.007663000@sipsolutions.net>
References: <20070215144241.847938000@sipsolutions.net>
Date: Thu, 15 Feb 2007 15:42:43 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: John Linville <linville@tuxdriver.com>, Jiri Benc <jbenc@suse.cz>
Subject: [PATCH 02/10] update cfg80211/wext and wext code
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch updates the cfg80211/wext compat code as well as the original
wext code. To ease development/testing, it allows having cfg80211 including
all the compat code as a module, only a registration hook for the wext
ioctls needs to be built-in.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/netdevice.h  |    4 
 include/net/cfg80211.h     |    4 
 include/net/iw_handler.h   |    3 
 include/net/wireless.h     |   23 +
 net/core/dev.c             |   67 ---
 net/wireless/Makefile      |   24 -
 net/wireless/core.c        |   28 -
 net/wireless/core.h        |   25 -
 net/wireless/wext-common.c |   67 ++-
 net/wireless/wext-compat.c |  923 +++++++++++----------------------------------
 net/wireless/wext-export.c |   29 +
 net/wireless/wext-mod.c    |   20 
 net/wireless/wext-old.c    |   13 
 net/wireless/wext.h        |   42 +-
 14 files changed, 445 insertions(+), 827 deletions(-)

--- wireless-dev.orig/net/wireless/wext-compat.c	2007-02-15 12:28:34.647940064 +0100
+++ wireless-dev/net/wireless/wext-compat.c	2007-02-15 12:28:35.637940064 +0100
@@ -4,7 +4,7 @@
  * Lots of code from the original wireless.c:
  * Copyright 1997-2006	Jean Tourrilhes <jt@hpl.hp.com>
  *
- * Copyright 2006	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006,2007	Johannes Berg <johannes@sipsolutions.net>
  *
  * GPLv2.
  *
@@ -45,7 +45,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/wireless.h>
-#include <net/iw_handler.h>
 #include <net/netlink.h>
 #include <asm/uaccess.h>
 #include <net/cfg80211.h>
@@ -53,29 +52,6 @@
 #include "core.h"
 #include "wext.h"
 
-/* The cfg80211 driver assigns callbacks in this
- * if it is loaded. If not, then we can't config
- * anything anyway... */
-struct cfg80211_core_ops cfg80211_core_ops;
-EXPORT_SYMBOL_GPL(cfg80211_core_ops);
-
-static struct cfg80211_registered_driver *cfg80211_wx_setup(int ifindex)
-{
-	if (!cfg80211_core_ops.loaded)
-		return ERR_PTR(-ENOSYS);
-	if (!try_module_get(cfg80211_core_ops.module))
-		return ERR_PTR(-ENOSYS);
-
-	return cfg80211_core_ops.get_drv_from_ifidx(ifindex);
-}
-
-static void cfg80211_wx_teardown(struct cfg80211_registered_driver *drv)
-{
-	if (!IS_ERR(drv))
-		cfg80211_core_ops.put_drv(drv);
-	module_put(cfg80211_core_ops.module);
-}
-
 /* internal API: use this function when changing
  * some parameter that needs to be committed */
 static void cfg80211_wx_start_commit_timer(int ifindex)
@@ -91,302 +67,170 @@ static void cfg80211_wx_start_commit_tim
 	 * as well as taking the rtnl lock (due to wext)! */
 }
 
-static void cfg80211_ensure_netdev_pending_cfg(struct net_device *dev)
+static struct cfg80211_config *cfg80211_ensure_pending_cfg(
+	struct cfg80211_registered_driver *drv)
 {
-	struct cfg80211_config *cfg = dev->cfg80211_wext_pending_config;
-	if (!cfg) {
+	struct cfg80211_config *cfg = drv->wext_pending_config;
+	if (!cfg)
 		cfg = kmalloc(sizeof(*cfg)+32, GFP_KERNEL);
+	if (cfg) {
 		cfg->ssid = (char*)cfg + sizeof(*cfg);
-		dev->cfg80211_wext_pending_config = cfg;
+		drv->wext_pending_config = cfg;
 	}
+	return cfg;
 }
 
-/* operations we implement. whew, I machine-generated these */
-static int cfg80211_wx_set_commit(struct net_device *net_dev,
+static int cfg80211_wx_set_commit(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
 	int err;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	if (!net_dev->cfg80211_wext_pending_config) {
+	if (!drv->wext_pending_config) {
 		err = 0;
 		goto out;
 	}
 
-	err = drv->ops->configure(drv->priv, net_dev,
-				  net_dev->cfg80211_wext_pending_config);
+	err = drv->ops->configure(&drv->wiphy, net_dev,
+				  drv->wext_pending_config);
 
-	kfree(net_dev->cfg80211_wext_pending_config);
-	net_dev->cfg80211_wext_pending_config = NULL;
+	kfree(drv->wext_pending_config);
+	drv->wext_pending_config = NULL;
 
  out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_name(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_name(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_nwid(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_nwid(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_nwid(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_nwid(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_freq(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_freq(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_freq(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_freq(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_mode(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_mode(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_mode(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_mode(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_sens(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_sens(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_sens(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_sens(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_range(struct net_device *net_dev,
+static int cfg80211_wx_set_range(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_range(struct net_device *net_dev,
+static int cfg80211_wx_get_range(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_ap(struct net_device *net_dev,
+static int cfg80211_wx_set_ap(struct cfg80211_registered_driver *drv,
+			      struct net_device *net_dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *data,
 			      char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
 	/* TODO: DO SOMETHING */
 	/* SIOCSIWAP
@@ -394,150 +238,86 @@ static int cfg80211_wx_set_ap(struct net
 	 *   -> if bssid is all-zeroes: set roaming to kernel
 	 *   -> otherwise: set roaming to userspace, set bssid
 	 */
-	err = -ENOSYS;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_ap(struct net_device *net_dev,
+static int cfg80211_wx_get_ap(struct cfg80211_registered_driver *drv,
+			      struct net_device *net_dev,
 			      struct iw_request_info *info,
 			      union iwreq_data *data,
 			      char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
 	/* TODO: DO SOMETHING */
 	/* SIOCGIWAP
 	 *   -> get association parameters and fill return bssid appropriately
 	 */
-	err = -ENOSYS;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_mlme(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_mlme(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_waplist(struct net_device *net_dev,
+static int cfg80211_wx_get_waplist(struct cfg80211_registered_driver *drv,
+				   struct net_device *net_dev,
 				   struct iw_request_info *info,
 				   union iwreq_data *data,
 				   char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_scan(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_scan(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_scan(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_scan(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_essid(struct net_device *net_dev,
+static int cfg80211_wx_set_essid(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 	struct cfg80211_config *cfg;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	err = -ENOSYS;
 	if (!drv->ops->configure || !drv->ops->get_config_valid)
 		goto out;
-	if (!(drv->ops->get_config_valid(drv->priv, net_dev)
+	if (!(drv->ops->get_config_valid(&drv->wiphy, net_dev)
 			& CFG80211_CFG_VALID_SSID))
 		goto out;
 
-	cfg80211_ensure_netdev_pending_cfg(net_dev);
-	cfg = net_dev->cfg80211_wext_pending_config;
+	cfg = cfg80211_ensure_pending_cfg(drv);
 	if (!cfg) {
 		err = -ENOMEM;
 		goto out;
@@ -550,502 +330,264 @@ static int cfg80211_wx_set_essid(struct 
 	cfg80211_wx_start_commit_timer(net_dev->ifindex);
 	err = 0;
  out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_essid(struct net_device *net_dev,
+static int cfg80211_wx_get_essid(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_rate(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_rate(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_rate(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_rate(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_rts(struct net_device *net_dev,
+static int cfg80211_wx_set_rts(struct cfg80211_registered_driver *drv,
+			       struct net_device *net_dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data,
 			       char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_rts(struct net_device *net_dev,
+static int cfg80211_wx_get_rts(struct cfg80211_registered_driver *drv,
+			       struct net_device *net_dev,
 			       struct iw_request_info *info,
 			       union iwreq_data *data,
 			       char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_frag(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_frag(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_frag(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_frag(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_txpow(struct net_device *net_dev,
+static int cfg80211_wx_set_txpow(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_txpow(struct net_device *net_dev,
+static int cfg80211_wx_get_txpow(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_retry(struct net_device *net_dev,
+static int cfg80211_wx_set_retry(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_retry(struct net_device *net_dev,
+static int cfg80211_wx_get_retry(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_encode(struct net_device *net_dev,
+static int cfg80211_wx_set_encode(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_encode(struct net_device *net_dev,
+static int cfg80211_wx_get_encode(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_power(struct net_device *net_dev,
+static int cfg80211_wx_set_power(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_power(struct net_device *net_dev,
+static int cfg80211_wx_get_power(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_genie(struct net_device *net_dev,
+static int cfg80211_wx_set_genie(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_genie(struct net_device *net_dev,
+static int cfg80211_wx_get_genie(struct cfg80211_registered_driver *drv,
+				 struct net_device *net_dev,
 				 struct iw_request_info *info,
 				 union iwreq_data *data,
 				 char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
+	int err = -EOPNOTSUPP;
 
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_auth(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_set_auth(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_auth(struct net_device *net_dev,
-			        struct iw_request_info *info,
-			        union iwreq_data *data,
-			        char *extra)
+static int cfg80211_wx_get_auth(struct cfg80211_registered_driver *drv,
+				struct net_device *net_dev,
+				struct iw_request_info *info,
+				union iwreq_data *data,
+				char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_encodeext(struct net_device *net_dev,
+static int cfg80211_wx_set_encodeext(struct cfg80211_registered_driver *drv,
+				     struct net_device *net_dev,
 				     struct iw_request_info *info,
 				     union iwreq_data *data,
 				     char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_get_encodeext(struct net_device *net_dev,
+static int cfg80211_wx_get_encodeext(struct cfg80211_registered_driver *drv,
+				     struct net_device *net_dev,
 				     struct iw_request_info *info,
 				     union iwreq_data *data,
 				     char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
-
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
+	int err = -EOPNOTSUPP;
 
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
-static int cfg80211_wx_set_wpmksa(struct net_device *net_dev,
+static int cfg80211_wx_set_wpmksa(struct cfg80211_registered_driver *drv,
+				  struct net_device *net_dev,
 				  struct iw_request_info *info,
 				  union iwreq_data *data,
 				  char *extra)
 {
-	struct cfg80211_registered_driver *drv;
-	int err;
+	int err = -EOPNOTSUPP;
 
-	drv = cfg80211_wx_setup(net_dev->ifindex);
-	if (IS_ERR(drv)) {
-		err = PTR_ERR(drv);
-		goto out;
-	}
-
-	/* TODO: DO SOMETHING */
-	err = -ENOSYS;
-
- out:
-	cfg80211_wx_teardown(drv);
 	return err;
 }
 
 
+typedef int (*iw_compat_handler)(struct cfg80211_registered_driver *drv,
+				 struct net_device *dev,
+				 struct iw_request_info *info,
+				 union iwreq_data *wrqu,
+				 char *extra);
 
 /* operations array */
 #ifdef WX
 # undef WX
 #endif
 #define WX(ioctl)  [(ioctl) - SIOCIWFIRST]
-static const iw_handler cfg80211_wx_handlers[] = {
+static const iw_compat_handler cfg80211_wx_handlers[] = {
 	WX(SIOCSIWCOMMIT)	= cfg80211_wx_set_commit,
 	WX(SIOCGIWNAME)		= cfg80211_wx_get_name,
 	WX(SIOCSIWNWID)		= cfg80211_wx_set_nwid,
@@ -1090,7 +632,7 @@ static const iw_handler cfg80211_wx_hand
 };
 
 /* dummy so I didn't have to change that much code... */
-static iw_handler get_handler(struct net_device *dev, unsigned int cmd)
+static iw_compat_handler get_handler(unsigned int cmd)
 {
 	int idx = cmd - SIOCIWFIRST;
 	if (idx < ARRAY_SIZE(cfg80211_wx_handlers))
@@ -1102,10 +644,11 @@ static iw_handler get_handler(struct net
  * this is sort of backwards and wouldn't need to call
  * get_wireless_stats, but it was easier to just copy the code...
  */
-static int iw_handler_get_iwstats(struct net_device *		dev,
-				  struct iw_request_info *	info,
-				  union iwreq_data *		wrqu,
-				  char *			extra)
+static int iw_handler_get_iwstats(struct cfg80211_registered_driver *drv,
+				  struct net_device *dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *wrqu,
+				  char *extra)
 {
 	/* Get stats from the driver */
 	struct iw_statistics stats_buf;
@@ -1131,10 +674,11 @@ static int iw_handler_get_iwstats(struct
  * We do various checks and also take care of moving data between
  * user space and kernel space.
  */
-static int ioctl_standard_call(struct net_device *	dev,
-			       struct ifreq *		ifr,
-			       unsigned int		cmd,
-			       iw_handler		handler)
+static int ioctl_standard_call(struct cfg80211_registered_driver *drv,
+			       struct net_device *dev,
+			       struct ifreq *ifr,
+			       unsigned int cmd,
+			       iw_compat_handler handler)
 {
 	struct iwreq *				iwr = (struct iwreq *) ifr;
 	const struct iw_ioctl_description *	descr;
@@ -1142,9 +686,9 @@ static int ioctl_standard_call(struct ne
 	int					ret = -EINVAL;
 
 	/* Get the description of the IOCTL */
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 	/* Prepare the call */
 	info.cmd = cmd;
@@ -1154,7 +698,7 @@ static int ioctl_standard_call(struct ne
 	if(descr->header_type != IW_HEADER_TYPE_POINT) {
 
 		/* No extra arguments. Trivial to handle */
-		ret = handler(dev, &info, &(iwr->u), NULL);
+		ret = handler(drv, dev, &info, &(iwr->u), NULL);
 
 		/* Generate an event to notify listeners of the change */
 		if((descr->flags & IW_DESCR_FLAG_EVENT) &&
@@ -1224,7 +768,7 @@ static int ioctl_standard_call(struct ne
 		}
 
 		/* Call the handler */
-		ret = handler(dev, &info, &(iwr->u), extra);
+		ret = handler(drv, dev, &info, &(iwr->u), extra);
 
 		/* If we have something to return to the user */
 		if (!ret && IW_IS_GET(cmd)) {
@@ -1264,37 +808,46 @@ static int ioctl_standard_call(struct ne
 int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd)
 {
 	struct net_device *dev;
-	iw_handler	handler;
+	iw_compat_handler handler;
+	struct cfg80211_registered_driver *drv;
+	int err;
 
 	/* Permissions are already checked in dev_ioctl() before calling us.
 	 * The copy_to/from_user() of ifr is also dealt with in there */
 
-	/* Make sure the device exist */
-	if ((dev = __dev_get_by_name(ifr->ifr_name)) == NULL)
+	dev = dev_get_by_name(ifr->ifr_name);
+	if (!dev)
 		return -ENODEV;
 
+	drv = cfg80211_get_drv_from_ifindex(dev->ifindex);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto out_put_dev;
+	}
+
 	/* A bunch of special cases, then the generic case...
 	 * Note that 'cmd' is already filtered in dev_ioctl() with
 	 * (cmd >= SIOCIWFIRST && cmd <= SIOCIWLAST) */
 	switch(cmd) {
 		case SIOCGIWSTATS:
 			/* Get Wireless Stats */
-			return ioctl_standard_call(dev,
-						   ifr,
-						   cmd,
-						   &iw_handler_get_iwstats);
-
+			err = ioctl_standard_call(drv, dev, ifr, cmd,
+						  &iw_handler_get_iwstats);
+			break;
 		case SIOCGIWPRIV:
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			break;
 		default:
-			/* Basic check */
-			if (!netif_device_present(dev))
-				return -ENODEV;
-			handler = get_handler(dev, cmd);
+			handler = get_handler(cmd);
 			if(cmd < SIOCIWFIRSTPRIV && handler != NULL)
-				return ioctl_standard_call(dev, ifr, cmd,
-							   handler);
-			return -EOPNOTSUPP;
+				err = ioctl_standard_call(drv, dev, ifr, cmd,
+							  handler);
+			else
+				err = -EOPNOTSUPP;
 	}
-	return -EINVAL;
+
+	cfg80211_put_drv(drv);
+ out_put_dev:
+	dev_put(dev);
+	return err;
 }
--- wireless-dev.orig/include/linux/netdevice.h	2007-02-15 12:28:30.597940064 +0100
+++ wireless-dev/include/linux/netdevice.h	2007-02-15 12:28:35.637940064 +0100
@@ -355,10 +355,6 @@ struct net_device
 	/* Instance data managed by the core of Wireless Extensions. */
 	struct iw_public_data *	wireless_data;
 #endif
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-	/* pending config used by cfg80211/wext compat code only */
-	void *cfg80211_wext_pending_config;
-#endif
 	const struct ethtool_ops *ethtool_ops;
 
 	/*
--- wireless-dev.orig/include/net/cfg80211.h	2007-02-15 12:28:34.647940064 +0100
+++ wireless-dev/include/net/cfg80211.h	2007-02-15 12:28:35.647940064 +0100
@@ -193,8 +193,4 @@ extern void *nl80211hdr_put(struct sk_bu
 extern void *nl80211msg_new(struct sk_buff **skb, u32 pid,
 			    u32 seq, int flags, u8 cmd);
 
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-extern int cfg80211_wext_ioctl(struct ifreq *ifr, unsigned int cmd);
-#endif
-
 #endif /* __NET_CFG80211_H */
--- wireless-dev.orig/include/net/iw_handler.h	2007-02-15 12:28:30.677940064 +0100
+++ wireless-dev/include/net/iw_handler.h	2007-02-15 12:28:35.647940064 +0100
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
+++ wireless-dev/include/net/wireless.h	2007-02-15 12:28:35.647940064 +0100
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
--- wireless-dev.orig/net/core/dev.c	2007-02-15 12:28:30.577940064 +0100
+++ wireless-dev/net/core/dev.c	2007-02-15 12:28:35.647940064 +0100
@@ -116,7 +116,7 @@
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/ctype.h>
-#include <net/cfg80211.h>
+#include <net/wireless.h>
 
 /*
  *	The list of packet types we will receive (as opposed to discard)
@@ -2229,12 +2229,6 @@ static struct file_operations softnet_se
 	.release = seq_release,
 };
 
-#if defined(CONFIG_WIRELESS_EXT) || defined(CFG80211_WEXT_COMPAT)
-extern int wireless_proc_init(void);
-#else
-#define wireless_proc_init() 0
-#endif
-
 static int __init dev_proc_init(void)
 {
 	int rc = -ENOMEM;
@@ -2799,62 +2793,9 @@ int dev_ioctl(unsigned int cmd, void __u
 					ret = -EFAULT;
 				return ret;
 			}
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-			/* Take care of cfg80211 WE compatibility */
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
-				/* Follow me in net/wireless/wext-compat.c */
-				ret = cfg80211_wext_ioctl(&ifr, cmd);
-				rtnl_unlock();
-				if (ret == 0 && IW_IS_GET(cmd) &&
-				    copy_to_user(arg, &ifr,
-					    	 sizeof(struct ifreq)))
-					ret = -EFAULT;
-				/* haha, I cheat here by allowing a driver or
-				 * stack to have both WE or CFG80211-WE for
-				 * a little while during conversion... hope that
-				 * ENOSYS is only used to indicate not implemented
-				 *
-				 * if wireless extensions are not configured
-				 * then this is the last thing here so that
-				 * if we fall through we return -EINVAL
-				 */
-				if (ret != -ENOSYS)
-					return ret;
-			}
-#endif
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
-				if (ret == 0 && IW_IS_GET(cmd) &&
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
--- wireless-dev.orig/net/wireless/core.c	2007-02-15 12:28:30.257940064 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-15 12:28:35.647940064 +0100
@@ -1,21 +1,24 @@
 /*
- * This is the new wireless configuration interface.
+ * This is the linux wireless configuration interface.
  *
- * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright 2006, 2007		Johannes Berg <johannes@sipsolutions.net>
  */
 
-#include "core.h"
-#include "nl80211.h"
 #include <linux/if.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <net/genetlink.h>
-#include <net/cfg80211.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
+#include <linux/nl80211.h>
+#include <net/genetlink.h>
+#include <net/cfg80211.h>
+#include "nl80211.h"
+#include "core.h"
+#include "wext.h"
 
 MODULE_AUTHOR("Johannes Berg");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("wireless configuration support");
 
 /* RCU might be appropriate here since we usually
  * only read the list, and that can happen quite
@@ -116,7 +119,6 @@ cfg80211_get_drv_from_info(struct genl_i
 	return drv;
 }
 
-/* wext will need this */
 struct cfg80211_registered_driver *
 cfg80211_get_drv_from_ifindex(int ifindex)
 {
@@ -221,23 +223,11 @@ EXPORT_SYMBOL_GPL(cfg80211_unregister);
 
 static int cfg80211_init(void)
 {
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-	cfg80211_core_ops.get_drv_from_ifidx = cfg80211_get_drv_from_ifindex;
-	cfg80211_core_ops.put_drv = cfg80211_put_drv;
-	cfg80211_core_ops.module = THIS_MODULE;
-	cfg80211_core_ops.loaded = 1;
-#endif
 	return nl80211_init();
 }
 
 static void cfg80211_exit(void)
 {
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-	cfg80211_core_ops.loaded = 0;
-	cfg80211_core_ops.module = NULL;
-	cfg80211_core_ops.get_drv_from_ifidx = NULL;
-	cfg80211_core_ops.put_drv = NULL;
-#endif
 	nl80211_exit();
 }
 
--- wireless-dev.orig/net/wireless/wext-common.c	2007-02-15 12:28:30.297940064 +0100
+++ wireless-dev/net/wireless/wext-common.c	2007-02-15 12:28:35.657940064 +0100
@@ -1,4 +1,12 @@
-/* common wext support routines, proc interface and events */
+/*
+ * common wext support routines, proc interface and events
+ *
+ *
+ * Most code is from the original wireless.c:
+ * Copyright 1997-2006  Jean Tourrilhes <jt@hpl.hp.com>
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ */
 
 #include <linux/proc_fs.h>
 #include <linux/netdevice.h>
@@ -16,7 +24,7 @@
  * Meta-data about all the standard Wireless Extension request we
  * know about.
  */
-const struct iw_ioctl_description standard_ioctl[] = {
+const struct iw_ioctl_description wext_standard_ioctl[] = {
 	[SIOCSIWCOMMIT	- SIOCIWFIRST] = {
 		.header_type	= IW_HEADER_TYPE_NULL,
 	},
@@ -243,8 +251,7 @@ const struct iw_ioctl_description standa
 		.max_tokens	= sizeof(struct iw_pmksa),
 	},
 };
-const unsigned standard_ioctl_num = (sizeof(standard_ioctl) /
-					sizeof(struct iw_ioctl_description));
+const unsigned wext_standard_ioctl_num = ARRAY_SIZE(wext_standard_ioctl);
 
 /*
  * Meta-data about all the additional standard Wireless Extension events
@@ -545,8 +552,8 @@ void wireless_send_event(struct net_devi
 	/* Get the description of the Event */
 	if(cmd <= SIOCIWLAST) {
 		cmd_index = cmd - SIOCIWFIRST;
-		if(cmd_index < standard_ioctl_num)
-			descr = &(standard_ioctl[cmd_index]);
+		if(cmd_index < wext_standard_ioctl_num)
+			descr = &(wext_standard_ioctl[cmd_index]);
 	} else {
 		cmd_index = cmd - IWEVFIRST;
 		if(cmd_index < standard_event_num)
@@ -608,3 +615,51 @@ void wireless_send_event(struct net_devi
 
 	return;		/* Always success, I guess ;-) */
 }
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
+#ifdef CONFIG_WIRELESS_EXT
+	dev_load(ifr->ifr_name);
+
+	/* we could change the code to not hold the rtnl but
+	 * some callees might require it held */
+	rtnl_lock();
+
+	/* Follow me in wext-old.c */
+	ret = wireless_process_ioctl(ifr, cmd);
+
+	rtnl_unlock();
+
+	if (IW_IS_GET(cmd) && copy_to_user(arg, &ifr, sizeof(struct ifreq)))
+		ret = -EFAULT;
+
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
+	/* no need to hold rtnl lock here for the new stuff,
+	 * we properly use dev_get_by_name() and dev_put() */
+	ret = call_cfg80211_wext_ioctl(ifr, cmd);
+
+	if (IW_IS_GET(cmd) && copy_to_user(arg, ifr, sizeof(struct ifreq)))
+		ret = -EFAULT;
+#endif
+
+	return ret;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/wext-export.c	2007-02-15 12:28:35.657940064 +0100
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
--- wireless-dev.orig/net/wireless/wext.h	2007-02-15 12:28:30.347940064 +0100
+++ wireless-dev/net/wireless/wext.h	2007-02-15 12:28:35.657940064 +0100
@@ -3,11 +3,45 @@
  */
 #ifndef _WEXT_H
 #define _WEXT_H
+#include <linux/netdevice.h>
+#include <linux/if.h>
 #include <linux/wireless.h>
-extern struct iw_statistics *get_wireless_stats(struct net_device *dev,
-						struct iw_statistics *out);
-extern const struct iw_ioctl_description standard_ioctl[];
-extern const unsigned standard_ioctl_num;
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
 extern const struct iw_ioctl_description standard_event[];
 extern const int event_type_size[];
 #endif /* _WEXT_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/wireless/wext-mod.c	2007-02-15 12:28:35.657940064 +0100
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
--- wireless-dev.orig/net/wireless/wext-old.c	2007-02-15 12:28:30.397940064 +0100
+++ wireless-dev/net/wireless/wext-old.c	2007-02-15 12:28:35.657940064 +0100
@@ -308,9 +308,9 @@ static int ioctl_standard_call(struct ne
 	int					ret = -EINVAL;
 
 	/* Get the description of the IOCTL */
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_IOCTL_DEBUG
 	printk(KERN_DEBUG "%s (WE) : Found standard handler for 0x%04X\n",
@@ -769,9 +769,9 @@ static int rtnetlink_standard_get(struct
 
 	/* Get the description of the Request */
 	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_RTNETLINK_DEBUG
 	printk(KERN_DEBUG "%s (WE.r) : Found standard handler for 0x%04X\n",
@@ -911,9 +911,9 @@ static inline int rtnetlink_standard_set
 
 	/* Get the description of the Request */
 	cmd = request->cmd;
-	if((cmd - SIOCIWFIRST) >= standard_ioctl_num)
+	if((cmd - SIOCIWFIRST) >= wext_standard_ioctl_num)
 		return -EOPNOTSUPP;
-	descr = &(standard_ioctl[cmd - SIOCIWFIRST]);
+	descr = &(wext_standard_ioctl[cmd - SIOCIWFIRST]);
 
 #ifdef WE_RTNETLINK_DEBUG
 	printk(KERN_DEBUG "%s (WE.r) : Found standard SET handler for 0x%04X\n",
@@ -1726,5 +1726,4 @@ EXPORT_SYMBOL(iw_handler_get_spy);
 EXPORT_SYMBOL(iw_handler_get_thrspy);
 EXPORT_SYMBOL(iw_handler_set_spy);
 EXPORT_SYMBOL(iw_handler_set_thrspy);
-EXPORT_SYMBOL(wireless_send_event);
 EXPORT_SYMBOL(wireless_spy_update);
--- wireless-dev.orig/net/wireless/core.h	2007-02-15 12:28:30.457940064 +0100
+++ wireless-dev/net/wireless/core.h	2007-02-15 12:28:35.657940064 +0100
@@ -21,31 +21,16 @@ struct cfg80211_registered_driver {
 	 * to avoid the deregister call to proceed while
 	 * any call is in progress */
 	struct mutex mtx;
+
+#ifdef CONFIG_CFG80211_WEXT_COMPAT
+	/* wext compat */
+	struct cfg80211_config *wext_pending_config;
+#endif
 };
 
 extern struct mutex cfg80211_drv_mutex;
 extern struct list_head cfg80211_drv_list;
 
-#ifdef CONFIG_CFG80211_WEXT_COMPAT
-/* wext compatibility must be compiled in...
- * this extern is in wext-compat.c */
-struct cfg80211_core_ops {
-	/* flag to see if cfg80211 is there.
-	 * FIXME: isn't that racy? */
-	int loaded;
-
-	/* used to make sure the module isn't going away
-	 * can't really happen, except if no driver has cfg80211
-	 * in use, but in that case  */
-	struct module *module;
-
-	/* and finally these are used to do work */
-	struct cfg80211_registered_driver *(*get_drv_from_ifidx)(int ifidx);
-	void (*put_drv)(struct cfg80211_registered_driver *drv);
-};
-extern struct cfg80211_core_ops cfg80211_core_ops;
-#endif
-
 /*
  * This function returns a pointer to the driver
  * that the genl_info item that is passed refers to.
--- wireless-dev.orig/net/wireless/Makefile	2007-02-15 12:28:30.477940064 +0100
+++ wireless-dev/net/wireless/Makefile	2007-02-15 12:28:35.657940064 +0100
@@ -1,16 +1,16 @@
 obj-$(CONFIG_CFG80211) += cfg80211.o
 
-cfg80211-objs := \
-	core.o nl80211.o
+cfg80211-y += core.o nl80211.o
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
 
-obj-nn :=
-obj-yy :=
-obj-yn :=
-obj-ny :=
-
-# this needs to be compiled in...
-obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-compat.o
-obj-$(CONFIG_CFG80211_WEXT_COMPAT)$(CONFIG_NET_WIRELESS) += wext-common.o
-obj-y += $(obj-yy) $(obj-yn) $(obj-ny)
+obj-$(CONFIG_WIRELESS_EXT) += wext-common.o wext-old.o
+obj-$(CONFIG_CFG80211_WEXT_COMPAT) += wext-common.o

--

