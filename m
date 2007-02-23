Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202AbXBWULf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:11:35 -0500
Subject: [RFC] convert wiphy to struct device
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, jbenc@suse.cz,
	Greg KH <greg@kroah.com>
In-Reply-To: <20070221133202.GB4978@tuxdriver.com>
References: <20070221005811.GA3875@tuxdriver.com>
	 <1172054717.3705.1.camel@johannes.berg>
	 <20070221133202.GB4978@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 23 Feb 2007 15:59:48 +0100
Message-Id: <1172242788.3870.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok so I did the wiphy stuff w/o knowing that class devs are apparently
deprecated. Below is a patch to convert it.

However, that patch has a problem. As discussed on netdev in the thread
"Converting network devices from class devices causes namespace
pollution" we'll have the same problem here, currently after the patch
this means that wiphys and netdevs will share the same namespace within
the device directory.

I think the generic code Greg promised in that thread will fix it by
renaming the symlink to "ieee80211:wiphy0" instead of just "wiphy0" but
I'd like to have confirmation about that.

johannes

---
 include/net/wireless.h           |   12 +--
 net/d80211/ieee80211.c           |    6 -
 net/d80211/ieee80211_sysfs.c     |  132 ++++++++++++++++++++-------------------
 net/d80211/ieee80211_sysfs_sta.c |    2 
 net/wireless/core.c              |   14 ++--
 net/wireless/sysfs.c             |   44 +++++++------
 6 files changed, 112 insertions(+), 98 deletions(-)

--- wireless-dev.orig/include/net/wireless.h	2007-02-23 15:20:05.904587899 +0100
+++ wireless-dev/include/net/wireless.h	2007-02-23 15:43:13.504587899 +0100
@@ -24,9 +24,9 @@ struct wiphy {
 
 	/* fields below are read-only, assigned by cfg80211 */
 
-	/* dir in /sys/class/ieee80211/, you need
-	 * to assign its dev pointer */
-	struct class_device class_dev;
+	/* the item in /sys/class/ieee80211/ points to this,
+	 * you need use set_wiphy_dev() (see below) */
+	struct device dev;
 
 	/* dir in debugfs: ieee80211/<wiphyname> */
 	struct dentry *debugfsdir;
@@ -64,7 +64,7 @@ static inline void *wiphy_priv(struct wi
  */
 static inline void set_wiphy_dev(struct wiphy *wiphy, struct device *dev)
 {
-	wiphy->class_dev.dev = dev;
+	wiphy->dev.parent = dev;
 }
 
 /**
@@ -72,7 +72,7 @@ static inline void set_wiphy_dev(struct 
  */
 static inline struct device *wiphy_dev(struct wiphy *wiphy)
 {
-	return wiphy->class_dev.dev;
+	return wiphy->dev.parent;
 }
 
 /**
@@ -80,7 +80,7 @@ static inline struct device *wiphy_dev(s
  */
 static inline char *wiphy_name(struct wiphy *wiphy)
 {
-	return wiphy->class_dev.class_id;
+	return wiphy->dev.bus_id;
 }
 
 /**
--- wireless-dev.orig/net/wireless/core.c	2007-02-23 15:40:50.844587899 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-23 15:44:09.654587899 +0100
@@ -164,7 +164,7 @@ struct wiphy *wiphy_new(struct cfg80211_
 	drv->idx = wiphy_counter;
 
 	/* give it a proper name */
-	snprintf(drv->wiphy.class_dev.class_id, BUS_ID_SIZE,
+	snprintf(drv->wiphy.dev.bus_id, BUS_ID_SIZE,
 		 "wiphy%d", drv->idx);
 
 	/* now increase counter for the next time */
@@ -173,9 +173,9 @@ struct wiphy *wiphy_new(struct cfg80211_
 
 	mutex_init(&drv->mtx);
 
-	drv->wiphy.class_dev.class = &ieee80211_class;
-	drv->wiphy.class_dev.class_data = &drv->wiphy;
-	class_device_initialize(&drv->wiphy.class_dev);
+	device_initialize(&drv->wiphy.dev);
+	drv->wiphy.dev.class = &ieee80211_class;
+	drv->wiphy.dev.platform_data = drv;
 
 	return &drv->wiphy;
 }
@@ -189,7 +189,7 @@ int wiphy_register(struct wiphy *wiphy)
 	mutex_lock(&cfg80211_drv_mutex);
 
 
-	res = class_device_add(&drv->wiphy.class_dev);
+	res = device_add(&drv->wiphy.dev);
 	if (res)
 		goto out_unlock;
 
@@ -219,7 +219,7 @@ void wiphy_unregister(struct wiphy *wiph
 	list_del(&drv->list);
 	mutex_unlock(&drv->mtx);
 
-	class_device_del(&drv->wiphy.class_dev);
+	device_del(&drv->wiphy.dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
 
 	mutex_unlock(&cfg80211_drv_mutex);
@@ -234,7 +234,7 @@ void cfg80211_dev_free(struct cfg80211_r
 
 void wiphy_free(struct wiphy *wiphy)
 {
-	class_device_put(&wiphy->class_dev);
+	put_device(&wiphy->dev);
 }
 EXPORT_SYMBOL(wiphy_free);
 
--- wireless-dev.orig/net/wireless/sysfs.c	2007-02-23 15:35:53.494587899 +0100
+++ wireless-dev/net/wireless/sysfs.c	2007-02-23 15:44:43.684587899 +0100
@@ -15,29 +15,33 @@
 #include <net/cfg80211.h>
 #include "core.h"
 
-static inline struct cfg80211_registered_device *cdev_to_dev(
-	struct class_device *cdev)
+static inline struct cfg80211_registered_device *dev_to_rdev(
+	struct device *dev)
 {
-	return container_of(cdev, struct cfg80211_registered_device, wiphy.class_dev);
+	return container_of(dev, struct cfg80211_registered_device, wiphy.dev);
 }
 
-static ssize_t _show_index(struct class_device *cdev, char *buf)
+static ssize_t _show_index(struct device *dev, struct device_attribute *attr,
+			   char *buf)
 {
-	return sprintf(buf, "%d\n", cdev_to_dev(cdev)->idx);
+	return sprintf(buf, "%d\n", dev_to_rdev(dev)->idx);
 }
 
-static ssize_t _show_permaddr(struct class_device *cdev, char *buf)
+static ssize_t _show_permaddr(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
 {
-	char *addr = cdev_to_dev(cdev)->wiphy.perm_addr;
+	char *addr = dev_to_rdev(dev)->wiphy.perm_addr;
 
 	return sprintf(buf, "%.2x:%.2x:%.2x:%.2x:%.2x:%.2x\n",
 		       addr[0], addr[1], addr[2], addr[3], addr[4], addr[5]);
 }
 
-static ssize_t _store_add_iface(struct class_device *dev,
+static ssize_t _store_add_iface(struct device *dev,
+				struct device_attribute *attr,
 				const char *buf, size_t len)
 {
-	struct cfg80211_registered_device *rdev = cdev_to_dev(dev);
+	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int res;
 
 	if (len > IFNAMSIZ)
@@ -52,10 +56,11 @@ static ssize_t _store_add_iface(struct c
 	return res ? res : len;
 }
 
-static ssize_t _store_remove_iface(struct class_device *dev,
+static ssize_t _store_remove_iface(struct device *dev,
+				   struct device_attribute *attr,
 				   const char *buf, size_t len)
 {
-	struct cfg80211_registered_device *rdev = cdev_to_dev(dev);
+	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int res, ifidx;
 	struct net_device *netdev;
 
@@ -76,7 +81,7 @@ static ssize_t _store_remove_iface(struc
 	return res ? res : len;
 }
 
-static struct class_device_attribute ieee80211_class_dev_attrs[] = {
+static struct device_attribute ieee80211_dev_attrs[] = {
 	__ATTR(index, S_IRUGO, _show_index, NULL),
 	__ATTR(macaddress, S_IRUGO, _show_permaddr, NULL),
 	__ATTR(add_iface, S_IWUGO, NULL, _store_add_iface),
@@ -84,26 +89,27 @@ static struct class_device_attribute iee
 	{}
 };
 
-static void wiphy_class_dev_release(struct class_device *cdev)
+static void wiphy_dev_release(struct device *dev)
 {
-	struct cfg80211_registered_device *dev = cdev_to_dev(cdev);
+	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 
-	cfg80211_dev_free(dev);
+	cfg80211_dev_free(rdev);
 }
 
-static int wiphy_uevent(struct class_device *cdev, char **envp,
+static int wiphy_uevent(struct device *dev, char **envp,
 			int num_envp, char *buf, int size)
 {
+	/* TODO, we probably need stuff here */
 	return 0;
 }
 
 struct class ieee80211_class = {
 	.name = "ieee80211",
 	.owner = THIS_MODULE,
-	.release = wiphy_class_dev_release,
-	.class_dev_attrs = ieee80211_class_dev_attrs,
+	.dev_release = wiphy_dev_release,
+	.dev_attrs = ieee80211_dev_attrs,
 #ifdef CONFIG_HOTPLUG
-	.uevent = wiphy_uevent,
+	.dev_uevent = wiphy_uevent,
 #endif
 };
 
--- wireless-dev.orig/net/d80211/ieee80211.c	2007-02-23 15:45:01.364587899 +0100
+++ wireless-dev/net/d80211/ieee80211.c	2007-02-23 15:45:23.814587899 +0100
@@ -4469,7 +4469,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 		       "algorithm\n", local->mdev->name);
 		return -ENOENT;
 	}
-	res = rate_control_add_attrs(ref, &local->hw.wiphy->class_dev.kobj);
+	res = rate_control_add_attrs(ref, &local->hw.wiphy->dev.kobj);
 	if (res < 0) {
 		printk(KERN_DEBUG "%s: Failed to register sysfs attributes "
 		       "for rate control\n", local->mdev->name);
@@ -4480,7 +4480,7 @@ int ieee80211_init_rate_ctrl_alg(struct 
 	old = local->rate_ctrl;
 	local->rate_ctrl = ref;
 	if (old) {
-		rate_control_remove_attrs(ref, &local->hw.wiphy->class_dev.kobj);
+		rate_control_remove_attrs(ref, &local->hw.wiphy->dev.kobj);
 		rate_control_put(old);
 		sta_info_flush(local, NULL);
 	}
@@ -4499,7 +4499,7 @@ static void rate_control_deinitialize(st
 
 	ref = local->rate_ctrl;
 	local->rate_ctrl = NULL;
-	rate_control_remove_attrs(ref, &local->hw.wiphy->class_dev.kobj);
+	rate_control_remove_attrs(ref, &local->hw.wiphy->dev.kobj);
 	rate_control_put(ref);
 }
 
--- wireless-dev.orig/net/d80211/ieee80211_sysfs.c	2007-02-23 15:45:34.554587899 +0100
+++ wireless-dev/net/d80211/ieee80211_sysfs.c	2007-02-23 15:54:40.804587899 +0100
@@ -17,9 +17,9 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 
-static inline struct ieee80211_local *to_ieee80211_local(struct class_device *dev)
+static inline struct ieee80211_local *to_ieee80211_local(struct device *dev)
 {
-	struct wiphy *wiphy = container_of(dev, struct wiphy, class_dev);
+	struct wiphy *wiphy = container_of(dev, struct wiphy, dev);
 	return wiphy_priv(wiphy);
 }
 
@@ -67,7 +67,8 @@ static const char *ieee80211_mode_str(in
 
 /* attributes in /sys/class/ieee80211/phyX/ */
 
-static ssize_t store_rate_ctrl_alg(struct class_device *dev,
+static ssize_t store_rate_ctrl_alg(struct device *dev,
+				   struct device_attribute *attr,
 				   const char *buf, size_t len)
 {
 	struct ieee80211_local *local = to_ieee80211_local(dev);
@@ -83,8 +84,11 @@ static ssize_t store_rate_ctrl_alg(struc
 	return res < 0 ? res : len;
 }
 
-static ssize_t ieee80211_local_show(struct class_device *dev, char *buf,
-			ssize_t (*format)(struct ieee80211_local *, char *))
+static ssize_t ieee80211_local_show(
+	struct device *dev,
+	struct device_attribute *attr,
+	char *buf,
+	ssize_t (*format)(struct ieee80211_local *, char *))
 {
 	struct ieee80211_local *local = to_ieee80211_local(dev);
 	ssize_t ret = -EINVAL;
@@ -102,10 +106,11 @@ static ssize_t ieee80211_local_fmt_##nam
 }
 
 #define __IEEE80211_LOCAL_SHOW(name)					\
-static ssize_t ieee80211_local_show_##name(struct class_device *cd,	\
+static ssize_t ieee80211_local_show_##name(struct device *dev,		\
+					   struct device_attribute *attr,\
 					   char *buf)			\
 {									\
-	return ieee80211_local_show(cd, buf,				\
+	return ieee80211_local_show(dev, attr, buf,			\
 				    ieee80211_local_fmt_##name);	\
 }
 
@@ -173,7 +178,7 @@ static ssize_t ieee80211_local_fmt_rate_
 }
 __IEEE80211_LOCAL_SHOW(rate_ctrl_alg);
 
-static struct class_device_attribute ieee80211_class_dev_attrs[] = {
+static struct device_attribute ieee80211_dev_attrs[] = {
 	__ATTR(channel, S_IRUGO, ieee80211_local_show_channel, NULL),
 	__ATTR(frequency, S_IRUGO, ieee80211_local_show_frequency, NULL),
 	__ATTR(radar_detect, S_IRUGO, ieee80211_local_show_radar_detect, NULL),
@@ -196,7 +201,7 @@ static struct class_device_attribute iee
 
 #define IEEE80211_LOCAL_ATTR(name, field, format)			\
 IEEE80211_LOCAL_SHOW(name, field, format)				\
-static CLASS_DEVICE_ATTR(name, S_IRUGO, ieee80211_local_show_##name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, ieee80211_local_show_##name, NULL);
 
 IEEE80211_LOCAL_ATTR(transmitted_fragment_count, dot11TransmittedFragmentCount, "%u");
 IEEE80211_LOCAL_ATTR(multicast_transmitted_frame_count, dot11MulticastTransmittedFrameCount, "%u");
@@ -260,7 +265,9 @@ static CLASS_DEVICE_ATTR(wme_tx_queue, S
 			 ieee80211_local_show_wme_tx_queue, NULL);
 #endif
 
-static ssize_t ieee80211_stats_show(struct class_device *dev, char *buf,
+static ssize_t ieee80211_stats_show(struct device *dev,
+		struct device_attribute *attr,
+		char *buf,
 		ssize_t (*format)(struct ieee80211_low_level_stats *, char *))
 {
 	struct ieee80211_local *local = to_ieee80211_local(dev);
@@ -287,17 +294,18 @@ static ssize_t ieee80211_stats_fmt_##nam
 }
 
 #define __IEEE80211_STATS_SHOW(name)					\
-static ssize_t ieee80211_stats_show_##name(struct class_device *cd,	\
+static ssize_t ieee80211_stats_show_##name(struct device *dev,		\
+					   struct device_attribute *attr,\
 					   char *buf)			\
 {									\
-	return ieee80211_stats_show(cd, buf,				\
+	return ieee80211_stats_show(dev, attr, buf,			\
 				    ieee80211_stats_fmt_##name);	\
 }
 
 #define IEEE80211_STATS_ATTR(name, field, format)			\
 IEEE80211_STATS_FMT(name, field, format "\n")				\
 __IEEE80211_STATS_SHOW(name)						\
-static CLASS_DEVICE_ATTR(name, S_IRUGO, ieee80211_stats_show_##name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, ieee80211_stats_show_##name, NULL);
 
 IEEE80211_STATS_ATTR(ack_failure_count, dot11ACKFailureCount, "%u");
 IEEE80211_STATS_ATTR(rts_failure_count, dot11RTSFailureCount, "%u");
@@ -305,43 +313,43 @@ IEEE80211_STATS_ATTR(fcs_error_count, do
 IEEE80211_STATS_ATTR(rts_success_count, dot11RTSSuccessCount, "%u");
 
 static struct attribute *ieee80211_stats_attrs[] = {
-	&class_device_attr_transmitted_fragment_count.attr,
-	&class_device_attr_multicast_transmitted_frame_count.attr,
-	&class_device_attr_failed_count.attr,
-	&class_device_attr_retry_count.attr,
-	&class_device_attr_multiple_retry_count.attr,
-	&class_device_attr_frame_duplicate_count.attr,
-	&class_device_attr_received_fragment_count.attr,
-	&class_device_attr_multicast_received_frame_count.attr,
-	&class_device_attr_transmitted_frame_count.attr,
-	&class_device_attr_wep_undecryptable_count.attr,
-	&class_device_attr_ack_failure_count.attr,
-	&class_device_attr_rts_failure_count.attr,
-	&class_device_attr_fcs_error_count.attr,
-	&class_device_attr_rts_success_count.attr,
-	&class_device_attr_num_scans.attr,
+	&dev_attr_transmitted_fragment_count.attr,
+	&dev_attr_multicast_transmitted_frame_count.attr,
+	&dev_attr_failed_count.attr,
+	&dev_attr_retry_count.attr,
+	&dev_attr_multiple_retry_count.attr,
+	&dev_attr_frame_duplicate_count.attr,
+	&dev_attr_received_fragment_count.attr,
+	&dev_attr_multicast_received_frame_count.attr,
+	&dev_attr_transmitted_frame_count.attr,
+	&dev_attr_wep_undecryptable_count.attr,
+	&dev_attr_ack_failure_count.attr,
+	&dev_attr_rts_failure_count.attr,
+	&dev_attr_fcs_error_count.attr,
+	&dev_attr_rts_success_count.attr,
+	&dev_attr_num_scans.attr,
 #ifdef CONFIG_D80211_DEBUG_COUNTERS
-	&class_device_attr_tx_handlers_drop.attr,
-	&class_device_attr_tx_handlers_queued.attr,
-	&class_device_attr_tx_handlers_drop_unencrypted.attr,
-	&class_device_attr_tx_handlers_drop_fragment.attr,
-	&class_device_attr_tx_handlers_drop_wep.attr,
-	&class_device_attr_tx_handlers_drop_not_assoc.attr,
-	&class_device_attr_tx_handlers_drop_unauth_port.attr,
-	&class_device_attr_rx_handlers_drop.attr,
-	&class_device_attr_rx_handlers_queued.attr,
-	&class_device_attr_rx_handlers_drop_nullfunc.attr,
-	&class_device_attr_rx_handlers_drop_defrag.attr,
-	&class_device_attr_rx_handlers_drop_short.attr,
-	&class_device_attr_rx_handlers_drop_passive_scan.attr,
-	&class_device_attr_tx_expand_skb_head.attr,
-	&class_device_attr_tx_expand_skb_head_cloned.attr,
-	&class_device_attr_rx_expand_skb_head.attr,
-	&class_device_attr_rx_expand_skb_head2.attr,
-	&class_device_attr_rx_handlers_fragments.attr,
-	&class_device_attr_tx_status_drop.attr,
-	&class_device_attr_wme_rx_queue.attr,
-	&class_device_attr_wme_tx_queue.attr,
+	&dev_attr_tx_handlers_drop.attr,
+	&dev_attr_tx_handlers_queued.attr,
+	&dev_attr_tx_handlers_drop_unencrypted.attr,
+	&dev_attr_tx_handlers_drop_fragment.attr,
+	&dev_attr_tx_handlers_drop_wep.attr,
+	&dev_attr_tx_handlers_drop_not_assoc.attr,
+	&dev_attr_tx_handlers_drop_unauth_port.attr,
+	&dev_attr_rx_handlers_drop.attr,
+	&dev_attr_rx_handlers_queued.attr,
+	&dev_attr_rx_handlers_drop_nullfunc.attr,
+	&dev_attr_rx_handlers_drop_defrag.attr,
+	&dev_attr_rx_handlers_drop_short.attr,
+	&dev_attr_rx_handlers_drop_passive_scan.attr,
+	&dev_attr_tx_expand_skb_head.attr,
+	&dev_attr_tx_expand_skb_head_cloned.attr,
+	&dev_attr_rx_expand_skb_head.attr,
+	&dev_attr_rx_expand_skb_head2.attr,
+	&dev_attr_rx_handlers_fragments.attr,
+	&dev_attr_tx_status_drop.attr,
+	&dev_attr_wme_rx_queue.attr,
+	&dev_attr_wme_tx_queue.attr,
 #endif
 	NULL,
 };
@@ -586,18 +594,18 @@ static struct attribute_group ieee80211_
 
 int ieee80211_dev_sysfs_add(struct ieee80211_local *local)
 {
-	const struct class_device_attribute *attr;
+	const struct device_attribute *attr;
 	int i, err;
 
-	for (i = 0; i < ARRAY_SIZE(ieee80211_class_dev_attrs); i++) {
-		attr = &ieee80211_class_dev_attrs[i];
-		err = sysfs_create_file(&local->hw.wiphy->class_dev.kobj,
+	for (i = 0; i < ARRAY_SIZE(ieee80211_dev_attrs); i++) {
+		attr = &ieee80211_dev_attrs[i];
+		err = sysfs_create_file(&local->hw.wiphy->dev.kobj,
 					&attr->attr);
 		if (err)
 			goto unwind;
 	}
 
-	err = sysfs_create_group(&local->hw.wiphy->class_dev.kobj,
+	err = sysfs_create_group(&local->hw.wiphy->dev.kobj,
 				 &ieee80211_stats_group);
 
 	if (err == 0)
@@ -607,8 +615,8 @@ int ieee80211_dev_sysfs_add(struct ieee8
 	/* one after the failed/last one */
 	i--;
 	while (i >= 0) {
-		attr = &ieee80211_class_dev_attrs[i];
-		sysfs_remove_file(&local->hw.wiphy->class_dev.kobj,
+		attr = &ieee80211_dev_attrs[i];
+		sysfs_remove_file(&local->hw.wiphy->dev.kobj,
 				  &attr->attr);
 		i--;
 	}
@@ -617,15 +625,15 @@ int ieee80211_dev_sysfs_add(struct ieee8
 
 void ieee80211_dev_sysfs_del(struct ieee80211_local *local)
 {
-	const struct class_device_attribute *attr;
+	const struct device_attribute *attr;
 	int i;
 
-	sysfs_remove_group(&local->hw.wiphy->class_dev.kobj,
+	sysfs_remove_group(&local->hw.wiphy->dev.kobj,
 			   &ieee80211_stats_group);
 
-	for (i = 0; i < ARRAY_SIZE(ieee80211_class_dev_attrs); i++) {
-		attr = &ieee80211_class_dev_attrs[i];
-		sysfs_remove_file(&local->hw.wiphy->class_dev.kobj,
+	for (i = 0; i < ARRAY_SIZE(ieee80211_dev_attrs); i++) {
+		attr = &ieee80211_dev_attrs[i];
+		sysfs_remove_file(&local->hw.wiphy->dev.kobj,
 				  &attr->attr);
 	}
 }
@@ -692,7 +700,7 @@ int ieee80211_sysfs_add_netdevice(struct
 	int res;
 
 	res = sysfs_create_link(&dev->dev.kobj,
-				&local->hw.wiphy->class_dev.kobj,
+				&local->hw.wiphy->dev.kobj,
 				"wiphy");
 	if (res)
 		goto err_out;
--- wireless-dev.orig/net/d80211/ieee80211_sysfs_sta.c	2007-02-23 15:51:51.624587899 +0100
+++ wireless-dev/net/d80211/ieee80211_sysfs_sta.c	2007-02-23 15:52:09.574587899 +0100
@@ -370,7 +370,7 @@ int ieee80211_sta_kset_sysfs_register(st
 	res = kobject_set_name(&local->sta_kset.kobj, "sta");
 	if (res)
 		return res;
-	local->sta_kset.kobj.parent = &local->hw.wiphy->class_dev.kobj;
+	local->sta_kset.kobj.parent = &local->hw.wiphy->dev.kobj;
 	local->sta_kset.ktype = &sta_ktype;
 	return kset_register(&local->sta_kset);
 }


