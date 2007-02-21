Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2257 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338AbXBUBWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 20:22:11 -0500
Date: Tue, 20 Feb 2007 19:58:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, jbenc@suse.cz
Subject: [RFC PATCH] d80211: fix build break from netdev class_device -> device changes
Message-ID: <20070221005811.GA3875@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for 2.6.21-rc1, I pulled Linus' latest tree into a
branch of wireless-dev.  I hit a build problem with the sysfs stuff,
due to the recent changes from class_device -> device for net_device.

Since I don't count sysfs as a strength, I thought it was worth
posting this for some review before I actually pulled Linus' latest
into wireless-dev and slapped this on top of it... :-)

Comments?

--

Fix-up the build breakages in d80211 caused by commit
43cb76d91ee85f579a69d42bc8efc08bac560278.
    
Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/net/d80211/ieee80211_sysfs.c b/net/d80211/ieee80211_sysfs.c
index d7006cc..87e71a7 100644
--- a/net/d80211/ieee80211_sysfs.c
+++ b/net/d80211/ieee80211_sysfs.c
@@ -23,9 +23,6 @@ static inline struct ieee80211_local *to_ieee80211_local(struct class_device *de
 	return wiphy_priv(wiphy);
 }
 
-#define to_net_dev(class) \
-	container_of(class, struct net_device, class_dev)
-
 static inline int rtnl_lock_local(struct ieee80211_local *local)
 {
 	rtnl_lock();
@@ -356,11 +353,12 @@ static struct attribute_group ieee80211_stats_group = {
 
 /* attributes in /sys/class/net/X/ */
 
-static ssize_t ieee80211_if_show(struct class_device *cd, char *buf,
+static ssize_t ieee80211_if_show(struct device *d,
+			struct device_attribute *attr, char *buf,
 			ssize_t (*format)(const struct ieee80211_sub_if_data *,
 					  char *))
 {
-	struct net_device *dev = to_net_dev(cd);
+	struct net_device *dev = to_net_dev(d);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	ssize_t ret = -EINVAL;
 
@@ -400,12 +398,13 @@ static ssize_t ieee80211_if_fmt_##name(const struct			\
 }
 
 #define __IEEE80211_IF_SHOW(name)					\
-static ssize_t ieee80211_if_show_##name(struct class_device *cd,	\
+static ssize_t ieee80211_if_show_##name(struct device *d,		\
+					struct device_attribute *attr,	\
 					char *buf)			\
 {									\
-	return ieee80211_if_show(cd, buf, ieee80211_if_fmt_##name);	\
+	return ieee80211_if_show(d, attr, buf, ieee80211_if_fmt_##name);\
 }									\
-static CLASS_DEVICE_ATTR(name, S_IRUGO, ieee80211_if_show_##name, NULL);
+static DEVICE_ATTR(name, S_IRUGO, ieee80211_if_show_##name, NULL);
 
 #define IEEE80211_IF_SHOW(name, field, format)				\
 		IEEE80211_IF_FMT_##format(name, field)			\
@@ -499,64 +498,64 @@ static ssize_t ieee80211_if_fmt_mode(const struct
 __IEEE80211_IF_SHOW(mode);
 
 static struct attribute *ieee80211_sta_attrs[] = {
-	&class_device_attr_channel_use.attr,
-	&class_device_attr_drop_unencrypted.attr,
-	&class_device_attr_eapol.attr,
-	&class_device_attr_ieee8021_x.attr,
-	&class_device_attr_state.attr,
-	&class_device_attr_bssid.attr,
-	&class_device_attr_prev_bssid.attr,
-	&class_device_attr_ssid_len.attr,
-	&class_device_attr_aid.attr,
-	&class_device_attr_ap_capab.attr,
-	&class_device_attr_capab.attr,
-	&class_device_attr_extra_ie_len.attr,
-	&class_device_attr_auth_tries.attr,
-	&class_device_attr_assoc_tries.attr,
-	&class_device_attr_auth_algs.attr,
-	&class_device_attr_auth_alg.attr,
-	&class_device_attr_auth_transaction.attr,
-	&class_device_attr_flags.attr,
+	&dev_attr_channel_use.attr,
+	&dev_attr_drop_unencrypted.attr,
+	&dev_attr_eapol.attr,
+	&dev_attr_ieee8021_x.attr,
+	&dev_attr_state.attr,
+	&dev_attr_bssid.attr,
+	&dev_attr_prev_bssid.attr,
+	&dev_attr_ssid_len.attr,
+	&dev_attr_aid.attr,
+	&dev_attr_ap_capab.attr,
+	&dev_attr_capab.attr,
+	&dev_attr_extra_ie_len.attr,
+	&dev_attr_auth_tries.attr,
+	&dev_attr_assoc_tries.attr,
+	&dev_attr_auth_algs.attr,
+	&dev_attr_auth_alg.attr,
+	&dev_attr_auth_transaction.attr,
+	&dev_attr_flags.attr,
 	NULL
 };
 
 static struct attribute *ieee80211_ap_attrs[] = {
-	&class_device_attr_channel_use.attr,
-	&class_device_attr_drop_unencrypted.attr,
-	&class_device_attr_eapol.attr,
-	&class_device_attr_ieee8021_x.attr,
-	&class_device_attr_num_sta_ps.attr,
-	&class_device_attr_dtim_period.attr,
-	&class_device_attr_dtim_count.attr,
-	&class_device_attr_num_beacons.attr,
-	&class_device_attr_force_unicast_rateidx.attr,
-	&class_device_attr_max_ratectrl_rateidx.attr,
-	&class_device_attr_num_buffered_multicast.attr,
-	&class_device_attr_beacon_head_len.attr,
-	&class_device_attr_beacon_tail_len.attr,
+	&dev_attr_channel_use.attr,
+	&dev_attr_drop_unencrypted.attr,
+	&dev_attr_eapol.attr,
+	&dev_attr_ieee8021_x.attr,
+	&dev_attr_num_sta_ps.attr,
+	&dev_attr_dtim_period.attr,
+	&dev_attr_dtim_count.attr,
+	&dev_attr_num_beacons.attr,
+	&dev_attr_force_unicast_rateidx.attr,
+	&dev_attr_max_ratectrl_rateidx.attr,
+	&dev_attr_num_buffered_multicast.attr,
+	&dev_attr_beacon_head_len.attr,
+	&dev_attr_beacon_tail_len.attr,
 	NULL
 };
 
 static struct attribute *ieee80211_wds_attrs[] = {
-	&class_device_attr_channel_use.attr,
-	&class_device_attr_drop_unencrypted.attr,
-	&class_device_attr_eapol.attr,
-	&class_device_attr_ieee8021_x.attr,
-	&class_device_attr_peer.attr,
+	&dev_attr_channel_use.attr,
+	&dev_attr_drop_unencrypted.attr,
+	&dev_attr_eapol.attr,
+	&dev_attr_ieee8021_x.attr,
+	&dev_attr_peer.attr,
 	NULL
 };
 
 static struct attribute *ieee80211_vlan_attrs[] = {
-	&class_device_attr_channel_use.attr,
-	&class_device_attr_drop_unencrypted.attr,
-	&class_device_attr_eapol.attr,
-	&class_device_attr_ieee8021_x.attr,
-	&class_device_attr_vlan_id.attr,
+	&dev_attr_channel_use.attr,
+	&dev_attr_drop_unencrypted.attr,
+	&dev_attr_eapol.attr,
+	&dev_attr_ieee8021_x.attr,
+	&dev_attr_vlan_id.attr,
 	NULL
 };
 
 static struct attribute *ieee80211_monitor_attrs[] = {
-	&class_device_attr_mode.attr,
+	&dev_attr_mode.attr,
 	NULL
 };
 
@@ -684,7 +683,7 @@ out:
 
 int ieee80211_sysfs_change_if_type(struct net_device *dev)
 {
-	return ieee80211_add_if_group(&dev->class_dev.kobj, dev);
+	return ieee80211_add_if_group(&dev->dev.kobj, dev);
 }
 
 int ieee80211_sysfs_add_netdevice(struct net_device *dev)
@@ -692,19 +691,19 @@ int ieee80211_sysfs_add_netdevice(struct net_device *dev)
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int res;
 
-	res = sysfs_create_link(&dev->class_dev.kobj,
+	res = sysfs_create_link(&dev->dev.kobj,
 				&local->hw.wiphy->class_dev.kobj,
 				"wiphy");
 	if (res)
 		goto err_out;
-	res = ieee80211_add_if_group(&dev->class_dev.kobj, dev);
+	res = ieee80211_add_if_group(&dev->dev.kobj, dev);
 	if (res)
 		goto err_link;
 	res = ieee80211_key_kset_sysfs_register(IEEE80211_DEV_TO_SUB_IF(dev));
 	return res;
 
 err_link:
-	sysfs_remove_link(&dev->class_dev.kobj, "wiphy");
+	sysfs_remove_link(&dev->dev.kobj, "wiphy");
 err_out:
 	return res;
 }
@@ -712,6 +711,6 @@ err_out:
 void ieee80211_sysfs_remove_netdevice(struct net_device *dev)
 {
 	ieee80211_key_kset_sysfs_unregister(IEEE80211_DEV_TO_SUB_IF(dev));
-	ieee80211_remove_if_group(&dev->class_dev.kobj, dev);
-	sysfs_remove_link(&dev->class_dev.kobj, "wiphy");
+	ieee80211_remove_if_group(&dev->dev.kobj, dev);
+	sysfs_remove_link(&dev->dev.kobj, "wiphy");
 }
diff --git a/net/d80211/ieee80211_sysfs_sta.c b/net/d80211/ieee80211_sysfs_sta.c
index fb0bae0..2f9c837 100644
--- a/net/d80211/ieee80211_sysfs_sta.c
+++ b/net/d80211/ieee80211_sysfs_sta.c
@@ -387,7 +387,7 @@ int ieee80211_key_kset_sysfs_register(struct ieee80211_sub_if_data *sdata)
 	res = kobject_set_name(&sdata->key_kset.kobj, "keys");
 	if (res)
 		return res;
-	sdata->key_kset.kobj.parent = &sdata->dev->class_dev.kobj;
+	sdata->key_kset.kobj.parent = &sdata->dev->dev.kobj;
 	sdata->key_kset.ktype = &key_ktype;
 	return kset_register(&sdata->key_kset);
 }
-- 
John W. Linville
linville@tuxdriver.com
