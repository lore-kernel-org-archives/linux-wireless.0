Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992587AbXCBQ2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 11:28:44 -0500
Subject: [PATCH] move per-netdev and key stuff to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 17:28:02 +0100
Message-Id: <1172852882.8247.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the remaining sysfs stuff from mac80211 into debugfs.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
It is *slightly* incomplete because it doesn't follow interface renames
yet, the infrastructure is there, the patch to do it will be a few lines
only.

---
 net/mac80211/Makefile          |    4 
 net/mac80211/debugfs.c         |    2 
 net/mac80211/debugfs_key.c     |  244 ++++++++++++++++++++++
 net/mac80211/debugfs_key.h     |   30 ++
 net/mac80211/debugfs_netdev.c  |  439 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs_netdev.h  |   30 ++
 net/mac80211/ieee80211.c       |   49 +---
 net/mac80211/ieee80211_i.h     |   65 +++++-
 net/mac80211/ieee80211_iface.c |   25 --
 net/mac80211/ieee80211_ioctl.c |   31 +-
 net/mac80211/ieee80211_key.h   |   21 +
 net/mac80211/ieee80211_sysfs.c |  344 --------------------------------
 net/mac80211/ieee80211_sysfs.h |   10 
 net/mac80211/key_sysfs.c       |  217 --------------------
 net/mac80211/key_sysfs.h       |   12 -
 net/mac80211/sta_info.c        |    4 
 16 files changed, 872 insertions(+), 655 deletions(-)

--- wireless-dev.orig/net/mac80211/Makefile	2007-03-02 15:07:01.064333268 +0100
+++ wireless-dev/net/mac80211/Makefile	2007-03-02 15:07:58.324333268 +0100
@@ -1,7 +1,7 @@
 obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o debugfs_sta.o
+mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o debugfs_sta.o debugfs_netdev.o debugfs_key.o
 
 mac80211-objs := \
 	ieee80211.o \
@@ -13,13 +13,11 @@ mac80211-objs := \
 	ieee80211_sta.o \
 	ieee80211_iface.o \
 	ieee80211_rate.o \
-	ieee80211_sysfs.o \
 	michael.o \
 	tkip.o \
 	aes_ccm.o \
 	wme.o \
 	ieee80211_cfg.o \
-	key_sysfs.o \
 	$(mac80211-objs-y)
 
 ifeq ($(CONFIG_NET_SCHED),)
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs_netdev.c	2007-03-02 17:09:49.245280266 +0100
@@ -0,0 +1,439 @@
+/*
+ * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/if.h>
+#include <linux/interrupt.h>
+#include <linux/netdevice.h>
+#include <linux/rtnetlink.h>
+#include <linux/notifier.h>
+#include <net/mac80211.h>
+#include <net/cfg80211.h>
+#include "ieee80211_i.h"
+#include "ieee80211_rate.h"
+#include "debugfs.h"
+#include "debugfs_netdev.h"
+
+static ssize_t ieee80211_if_read(
+	struct ieee80211_sub_if_data *sdata,
+	char __user *userbuf,
+	size_t count, loff_t *ppos,
+	ssize_t (*format)(const struct ieee80211_sub_if_data *, char *, int))
+{
+	char buf[70];
+	ssize_t ret = -EINVAL;
+
+	read_lock(&dev_base_lock);
+	if (sdata->dev->reg_state == NETREG_REGISTERED) {
+		ret = (*format)(sdata, buf, sizeof(buf));
+		ret = simple_read_from_buffer(userbuf, count, ppos, buf, ret);
+	}
+	read_unlock(&dev_base_lock);
+	return ret;
+}
+
+#define IEEE80211_IF_FMT(name, field, format_string)			\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata, char *buf,		\
+	int buflen)							\
+{									\
+	return scnprintf(buf, buflen, format_string, sdata->field);	\
+}
+#define IEEE80211_IF_FMT_DEC(name, field)				\
+		IEEE80211_IF_FMT(name, field, "%d\n")
+#define IEEE80211_IF_FMT_HEX(name, field)				\
+		IEEE80211_IF_FMT(name, field, "%#x\n")
+#define IEEE80211_IF_FMT_SIZE(name, field)				\
+		IEEE80211_IF_FMT(name, field, "%zd\n")
+
+#define IEEE80211_IF_FMT_ATOMIC(name, field)				\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata,			\
+	char *buf, int buflen)						\
+{									\
+	return scnprintf(buf, buflen, "%d\n", atomic_read(&sdata->field));\
+}
+
+#define IEEE80211_IF_FMT_MAC(name, field)				\
+static ssize_t ieee80211_if_fmt_##name(					\
+	const struct ieee80211_sub_if_data *sdata, char *buf,		\
+	int buflen)							\
+{									\
+	return scnprintf(buf, buflen, MAC_FMT "\n", MAC_ARG(sdata->field));\
+}
+
+#define __IEEE80211_IF_FILE(name)					\
+static ssize_t ieee80211_if_read_##name(struct file *file,		\
+					char __user *userbuf,		\
+					size_t count, loff_t *ppos)	\
+{									\
+	return ieee80211_if_read(file->private_data,			\
+				 userbuf, count, ppos,			\
+				 ieee80211_if_fmt_##name);		\
+}									\
+static const struct file_operations name##_ops = {			\
+	.read = ieee80211_if_read_##name,				\
+	.open = mac80211_open_file_generic,				\
+}
+
+#define IEEE80211_IF_FILE(name, field, format)				\
+		IEEE80211_IF_FMT_##format(name, field)			\
+		__IEEE80211_IF_FILE(name)
+
+/* common attributes */
+IEEE80211_IF_FILE(channel_use, channel_use, DEC);
+IEEE80211_IF_FILE(drop_unencrypted, drop_unencrypted, DEC);
+IEEE80211_IF_FILE(eapol, eapol, DEC);
+IEEE80211_IF_FILE(ieee8021_x, ieee802_1x, DEC);
+
+/* STA/IBSS attributes */
+IEEE80211_IF_FILE(state, u.sta.state, DEC);
+IEEE80211_IF_FILE(bssid, u.sta.bssid, MAC);
+IEEE80211_IF_FILE(prev_bssid, u.sta.prev_bssid, MAC);
+IEEE80211_IF_FILE(ssid_len, u.sta.ssid_len, SIZE);
+IEEE80211_IF_FILE(aid, u.sta.aid, DEC);
+IEEE80211_IF_FILE(ap_capab, u.sta.ap_capab, HEX);
+IEEE80211_IF_FILE(capab, u.sta.capab, HEX);
+IEEE80211_IF_FILE(extra_ie_len, u.sta.extra_ie_len, SIZE);
+IEEE80211_IF_FILE(auth_tries, u.sta.auth_tries, DEC);
+IEEE80211_IF_FILE(assoc_tries, u.sta.assoc_tries, DEC);
+IEEE80211_IF_FILE(auth_algs, u.sta.auth_algs, HEX);
+IEEE80211_IF_FILE(auth_alg, u.sta.auth_alg, DEC);
+IEEE80211_IF_FILE(auth_transaction, u.sta.auth_transaction, DEC);
+
+static ssize_t ieee80211_if_fmt_flags(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	return scnprintf(buf, buflen, "%s%s%s%s%s%s%s\n",
+			 sdata->u.sta.ssid_set ? "SSID\n" : "",
+			 sdata->u.sta.bssid_set ? "BSSID\n" : "",
+			 sdata->u.sta.prev_bssid_set ? "prev BSSID\n" : "",
+			 sdata->u.sta.authenticated ? "AUTH\n" : "",
+			 sdata->u.sta.associated ? "ASSOC\n" : "",
+			 sdata->u.sta.probereq_poll ? "PROBEREQ POLL\n" : "",
+			 sdata->u.sta.use_protection ? "CTS prot\n" : "");
+}
+__IEEE80211_IF_FILE(flags);
+
+/* AP attributes */
+IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
+IEEE80211_IF_FILE(dtim_period, u.ap.dtim_period, DEC);
+IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
+IEEE80211_IF_FILE(num_beacons, u.ap.num_beacons, DEC);
+IEEE80211_IF_FILE(force_unicast_rateidx, u.ap.force_unicast_rateidx, DEC);
+IEEE80211_IF_FILE(max_ratectrl_rateidx, u.ap.max_ratectrl_rateidx, DEC);
+
+static ssize_t ieee80211_if_fmt_num_buffered_multicast(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	return scnprintf(buf, buflen, "%u\n",
+			 skb_queue_len(&sdata->u.ap.ps_bc_buf));
+}
+__IEEE80211_IF_FILE(num_buffered_multicast);
+
+static ssize_t ieee80211_if_fmt_beacon_head_len(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	if (sdata->u.ap.beacon_head)
+		return scnprintf(buf, buflen, "%d\n",
+				 sdata->u.ap.beacon_head_len);
+	return scnprintf(buf, buflen, "\n");
+}
+__IEEE80211_IF_FILE(beacon_head_len);
+
+static ssize_t ieee80211_if_fmt_beacon_tail_len(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	if (sdata->u.ap.beacon_tail)
+		return scnprintf(buf, buflen, "%d\n",
+				 sdata->u.ap.beacon_tail_len);
+	return scnprintf(buf, buflen, "\n");
+}
+__IEEE80211_IF_FILE(beacon_tail_len);
+
+/* WDS attributes */
+IEEE80211_IF_FILE(peer, u.wds.remote_addr, MAC);
+
+/* VLAN attributes */
+IEEE80211_IF_FILE(vlan_id, u.vlan.id, DEC);
+
+/* MONITOR attributes */
+static ssize_t ieee80211_if_fmt_mode(
+	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+{
+	struct ieee80211_local *local = sdata->local;
+
+	return scnprintf(buf, buflen, "%s\n",
+			 ((local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) ||
+			  local->open_count == local->monitors) ?
+			 "hard" : "soft");
+}
+__IEEE80211_IF_FILE(mode);
+
+
+#define DEBUGFS_ADD(name, type)\
+	sdata->debugfs.type.name = debugfs_create_file(#name, 0444,\
+		sdata->debugfsdir, sdata, &name##_ops);
+
+static void add_sta_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD(channel_use, sta);
+	DEBUGFS_ADD(drop_unencrypted, sta);
+	DEBUGFS_ADD(eapol, sta);
+	DEBUGFS_ADD(ieee8021_x, sta);
+	DEBUGFS_ADD(state, sta);
+	DEBUGFS_ADD(bssid, sta);
+	DEBUGFS_ADD(prev_bssid, sta);
+	DEBUGFS_ADD(ssid_len, sta);
+	DEBUGFS_ADD(aid, sta);
+	DEBUGFS_ADD(ap_capab, sta);
+	DEBUGFS_ADD(capab, sta);
+	DEBUGFS_ADD(extra_ie_len, sta);
+	DEBUGFS_ADD(auth_tries, sta);
+	DEBUGFS_ADD(assoc_tries, sta);
+	DEBUGFS_ADD(auth_algs, sta);
+	DEBUGFS_ADD(auth_alg, sta);
+	DEBUGFS_ADD(auth_transaction, sta);
+	DEBUGFS_ADD(flags, sta);
+}
+
+static void add_ap_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD(channel_use, ap);
+	DEBUGFS_ADD(drop_unencrypted, ap);
+	DEBUGFS_ADD(eapol, ap);
+	DEBUGFS_ADD(ieee8021_x, ap);
+	DEBUGFS_ADD(num_sta_ps, ap);
+	DEBUGFS_ADD(dtim_period, ap);
+	DEBUGFS_ADD(dtim_count, ap);
+	DEBUGFS_ADD(num_beacons, ap);
+	DEBUGFS_ADD(force_unicast_rateidx, ap);
+	DEBUGFS_ADD(max_ratectrl_rateidx, ap);
+	DEBUGFS_ADD(num_buffered_multicast, ap);
+	DEBUGFS_ADD(beacon_head_len, ap);
+	DEBUGFS_ADD(beacon_tail_len, ap);
+}
+
+static void add_wds_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD(channel_use, wds);
+	DEBUGFS_ADD(drop_unencrypted, wds);
+	DEBUGFS_ADD(eapol, wds);
+	DEBUGFS_ADD(ieee8021_x, wds);
+	DEBUGFS_ADD(peer, wds);
+}
+
+static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD(channel_use, vlan);
+	DEBUGFS_ADD(drop_unencrypted, vlan);
+	DEBUGFS_ADD(eapol, vlan);
+	DEBUGFS_ADD(ieee8021_x, vlan);
+	DEBUGFS_ADD(vlan_id, vlan);
+}
+
+static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_ADD(mode, monitor);
+}
+
+void add_files(struct ieee80211_sub_if_data *sdata)
+{
+	if (!sdata->debugfsdir)
+		return;
+
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		add_sta_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		add_ap_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_WDS:
+		add_wds_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_MNTR:
+		add_monitor_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_VLAN:
+		add_vlan_files(sdata);
+		break;
+	default:
+		break;
+	}
+}
+
+#define DEBUGFS_DEL(name, type)\
+	debugfs_remove(sdata->debugfs.type.name);\
+	sdata->debugfs.type.name = NULL;
+
+static void del_sta_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_DEL(channel_use, sta);
+	DEBUGFS_DEL(drop_unencrypted, sta);
+	DEBUGFS_DEL(eapol, sta);
+	DEBUGFS_DEL(ieee8021_x, sta);
+	DEBUGFS_DEL(state, sta);
+	DEBUGFS_DEL(bssid, sta);
+	DEBUGFS_DEL(prev_bssid, sta);
+	DEBUGFS_DEL(ssid_len, sta);
+	DEBUGFS_DEL(aid, sta);
+	DEBUGFS_DEL(ap_capab, sta);
+	DEBUGFS_DEL(capab, sta);
+	DEBUGFS_DEL(extra_ie_len, sta);
+	DEBUGFS_DEL(auth_tries, sta);
+	DEBUGFS_DEL(assoc_tries, sta);
+	DEBUGFS_DEL(auth_algs, sta);
+	DEBUGFS_DEL(auth_alg, sta);
+	DEBUGFS_DEL(auth_transaction, sta);
+	DEBUGFS_DEL(flags, sta);
+}
+
+static void del_ap_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_DEL(channel_use, ap);
+	DEBUGFS_DEL(drop_unencrypted, ap);
+	DEBUGFS_DEL(eapol, ap);
+	DEBUGFS_DEL(ieee8021_x, ap);
+	DEBUGFS_DEL(num_sta_ps, ap);
+	DEBUGFS_DEL(dtim_period, ap);
+	DEBUGFS_DEL(dtim_count, ap);
+	DEBUGFS_DEL(num_beacons, ap);
+	DEBUGFS_DEL(force_unicast_rateidx, ap);
+	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
+	DEBUGFS_DEL(num_buffered_multicast, ap);
+	DEBUGFS_DEL(beacon_head_len, ap);
+	DEBUGFS_DEL(beacon_tail_len, ap);
+}
+
+static void del_wds_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_DEL(channel_use, wds);
+	DEBUGFS_DEL(drop_unencrypted, wds);
+	DEBUGFS_DEL(eapol, wds);
+	DEBUGFS_DEL(ieee8021_x, wds);
+	DEBUGFS_DEL(peer, wds);
+}
+
+static void del_vlan_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_DEL(channel_use, vlan);
+	DEBUGFS_DEL(drop_unencrypted, vlan);
+	DEBUGFS_DEL(eapol, vlan);
+	DEBUGFS_DEL(ieee8021_x, vlan);
+	DEBUGFS_DEL(vlan_id, vlan);
+}
+
+static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
+{
+	DEBUGFS_DEL(mode, monitor);
+}
+
+void del_files(struct ieee80211_sub_if_data *sdata, int type)
+{
+	if (!sdata->debugfsdir)
+		return;
+
+	switch (type) {
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		del_sta_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_AP:
+		del_ap_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_WDS:
+		del_wds_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_MNTR:
+		del_monitor_files(sdata);
+		break;
+	case IEEE80211_IF_TYPE_VLAN:
+		del_vlan_files(sdata);
+		break;
+	default:
+		break;
+	}
+}
+
+static int notif_registered;
+
+void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
+{
+	char buf[10+IFNAMSIZ];
+
+	if (!notif_registered)
+		return;
+
+	sprintf(buf, "netdev:%s", sdata->dev->name);
+	sdata->debugfsdir = debugfs_create_dir(buf,
+		sdata->local->hw.wiphy->debugfsdir);
+}
+
+void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
+{
+	del_files(sdata, sdata->type);
+	debugfs_remove(sdata->debugfsdir);
+}
+
+void ieee80211_debugfs_change_if_type(struct ieee80211_sub_if_data *sdata,
+				      int oldtype)
+{
+	del_files(sdata, oldtype);
+	add_files(sdata);
+}
+
+static int netdev_notify(struct notifier_block * nb,
+			 unsigned long state,
+			 void *ndev)
+{
+	struct net_device *dev = ndev;
+	char buf[10+IFNAMSIZ];
+
+	if (state != NETDEV_CHANGENAME)
+		return 0;
+
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
+		return 0;
+
+	if (dev->ieee80211_ptr->wiphy->privid != mac80211_wiphy_privid)
+		return 0;
+
+	/* TODO
+	sprintf(buf, "netdev:%s", dev->name);
+	debugfs_rename(IEEE80211_DEV_TO_SUB_IF(dev)->debugfsdir, buf);
+	*/
+
+	return 0;
+}
+
+static struct notifier_block mac80211_debugfs_netdev_notifier = {
+	.notifier_call = netdev_notify,
+};
+
+void ieee80211_debugfs_netdev_init(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&mac80211_debugfs_netdev_notifier);
+	if (err) {
+		printk(KERN_ERR
+		       "mac80211: failed to install netdev notifier,"
+		       " disabling per-netdev debugfs!\n");
+	} else
+		notif_registered = 1;
+}
+
+void ieee80211_debugfs_netdev_exit(void)
+{
+	unregister_netdevice_notifier(&mac80211_debugfs_netdev_notifier);
+	notif_registered = 0;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs_netdev.h	2007-03-02 15:07:58.484333268 +0100
@@ -0,0 +1,30 @@
+/* routines exported for sysfs handling */
+
+#ifndef __IEEE80211_SYSFS_H
+#define __IEEE80211_SYSFS_H
+
+#ifdef CONFIG_DEBUG_FS
+void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_change_if_type(struct ieee80211_sub_if_data *sdata,
+				     int oldtype);
+void ieee80211_debugfs_netdev_init(void);
+void ieee80211_debugfs_netdev_exit(void);
+#else
+static inline void ieee80211_debugfs_add_netdev(
+	struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_debugfs_remove_netdev(
+	struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_debugfs_change_if_type
+	struct ieee80211_sub_if_data *sdata, int oldtype)
+{}
+static inline void ieee80211_debugfs_netdev_init(void)
+{}
+
+static inline void ieee80211_debugfs_netdev_exit(void)
+{}
+#endif
+
+#endif /* __IEEE80211_SYSFS_H */
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-02 15:07:01.084333268 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-02 15:07:58.274333268 +0100
@@ -33,9 +33,11 @@
 #include "aes_ccm.h"
 #include "ieee80211_led.h"
 #include "ieee80211_cfg.h"
-#include "ieee80211_sysfs.h"
 #include "debugfs.h"
-#include "key_sysfs.h"
+#include "debugfs_netdev.h"
+
+/* privid for wiphys to determine whether they belong to us or not */
+void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
@@ -86,40 +88,30 @@ struct ieee80211_key *ieee80211_key_allo
 					  int idx, size_t key_len, gfp_t flags)
 {
 	struct ieee80211_key *key;
-	int res;
 
 	key = kzalloc(sizeof(struct ieee80211_key) + key_len, flags);
 	if (!key)
 		return NULL;
-	if (sdata)
-		res = kobject_set_name(&key->kobj, "%d", idx);
-	else
-		res = kobject_set_name(&key->kobj, "key");
-	if (res) {
-		kfree(key);
-		return NULL;
-	}
-	ieee80211_key_sysfs_set_kset(key, sdata ? &sdata->key_kset : NULL);
-	kobject_init(&key->kobj);
+	kref_init(&key->kref);
 	return key;
 }
 
-void ieee80211_key_free(struct ieee80211_key *key)
-{
-	if (key)
-		kobject_put(&key->kobj);
-}
-
-void ieee80211_key_release(struct kobject *kobj)
+void ieee80211_key_release(struct kref *kref)
 {
 	struct ieee80211_key *key;
 
-	key = container_of(kobj, struct ieee80211_key, kobj);
+	key = container_of(kref, struct ieee80211_key, kref);
 	if (key->alg == ALG_CCMP)
 		ieee80211_aes_key_free(key->u.ccmp.tfm);
 	kfree(key);
 }
 
+void ieee80211_key_free(struct ieee80211_key *key)
+{
+	if (key)
+		kref_put(&key->kref, ieee80211_key_release);
+}
+
 static int rate_list_match(const int *rate_list, int rate)
 {
 	int i;
@@ -4516,6 +4508,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	if (!wiphy)
 		return NULL;
 
+	wiphy->privid = mac80211_wiphy_privid;
+
 	local = wiphy_priv(wiphy);
 	local->hw.wiphy = wiphy;
 
@@ -4646,11 +4640,8 @@ int ieee80211_register_hw(struct ieee802
 		rtnl_unlock();
 		goto fail_dev;
 	}
-	result = ieee80211_sysfs_add_netdevice(local->mdev);
-	if (result < 0) {
-		rtnl_unlock();
-		goto fail_if_sysfs;
-	}
+
+	ieee80211_debugfs_add_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 
 	result = ieee80211_init_rate_ctrl_alg(local, NULL);
 	rtnl_unlock();
@@ -4687,8 +4678,7 @@ int ieee80211_register_hw(struct ieee802
 fail_wep:
 	rate_control_deinitialize(local);
 fail_rate:
-	ieee80211_sysfs_remove_netdevice(local->mdev);
-fail_if_sysfs:
+	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(local->mdev));
 	unregister_netdev(local->mdev);
 fail_dev:
 	sta_info_stop(local);
@@ -4899,6 +4889,8 @@ static int __init ieee80211_init(void)
 		return ret;
 	}
 
+	ieee80211_debugfs_netdev_init();
+
 	return 0;
 }
 
@@ -4906,6 +4898,7 @@ static int __init ieee80211_init(void)
 static void __exit ieee80211_exit(void)
 {
 	ieee80211_wme_unregister();
+	ieee80211_debugfs_netdev_exit();
 }
 
 
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-02 15:07:01.064333268 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-02 17:16:31.641680146 +0100
@@ -325,7 +325,6 @@ struct ieee80211_sub_if_data {
 #define NUM_DEFAULT_KEYS 4
 	struct ieee80211_key *keys[NUM_DEFAULT_KEYS];
 	struct ieee80211_key *default_key;
-	struct kset key_kset;
 
 	struct ieee80211_if_ap *bss; /* BSS that this device belongs to */
 
@@ -338,7 +337,64 @@ struct ieee80211_sub_if_data {
 	int channel_use;
 	int channel_use_raw;
 
-	struct attribute_group *sysfs_group;
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *debugfsdir;
+	union {
+		struct {
+			struct dentry *channel_use;
+			struct dentry *drop_unencrypted;
+			struct dentry *eapol;
+			struct dentry *ieee8021_x;
+			struct dentry *state;
+			struct dentry *bssid;
+			struct dentry *prev_bssid;
+			struct dentry *ssid_len;
+			struct dentry *aid;
+			struct dentry *ap_capab;
+			struct dentry *capab;
+			struct dentry *extra_ie_len;
+			struct dentry *auth_tries;
+			struct dentry *assoc_tries;
+			struct dentry *auth_algs;
+			struct dentry *auth_alg;
+			struct dentry *auth_transaction;
+			struct dentry *flags;
+		} sta;
+		struct {
+			struct dentry *channel_use;
+			struct dentry *drop_unencrypted;
+			struct dentry *eapol;
+			struct dentry *ieee8021_x;
+			struct dentry *num_sta_ps;
+			struct dentry *dtim_period;
+			struct dentry *dtim_count;
+			struct dentry *num_beacons;
+			struct dentry *force_unicast_rateidx;
+			struct dentry *max_ratectrl_rateidx;
+			struct dentry *num_buffered_multicast;
+			struct dentry *beacon_head_len;
+			struct dentry *beacon_tail_len;
+		} ap;
+		struct {
+			struct dentry *channel_use;
+			struct dentry *drop_unencrypted;
+			struct dentry *eapol;
+			struct dentry *ieee8021_x;
+			struct dentry *peer;
+		} wds;
+		struct {
+			struct dentry *channel_use;
+			struct dentry *drop_unencrypted;
+			struct dentry *eapol;
+			struct dentry *ieee8021_x;
+			struct dentry *vlan_id;
+		} vlan;
+		struct {
+			struct dentry *mode;
+		} monitor;
+		struct dentry *default_key;
+	} debugfs;
+#endif
 };
 
 #define IEEE80211_DEV_TO_SUB_IF(dev) netdev_priv(dev)
@@ -599,6 +655,7 @@ struct ieee80211_local {
 			struct dentry *wme_rx_queue;
 		} stats;
 		struct dentry *stations;
+		struct dentry *keys;
 	} debugfs;
 #endif
 };
@@ -670,7 +727,6 @@ ieee80211_key_data2conf(struct ieee80211
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  int idx, size_t key_len, gfp_t flags);
 void ieee80211_key_free(struct ieee80211_key *key);
-void ieee80211_key_release(struct kobject *kobj);
 void ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
 		       struct ieee80211_rx_status *status, u32 msg_type);
 void ieee80211_prepare_rates(struct ieee80211_local *local);
@@ -763,4 +819,7 @@ void ieee80211_if_sdata_init(struct ieee
 int ieee80211_if_add_mgmt(struct ieee80211_local *local);
 void ieee80211_if_del_mgmt(struct ieee80211_local *local);
 
+/* for wiphy privid */
+extern void *mac80211_wiphy_privid;
+
 #endif /* IEEE80211_I_H */
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-03-02 15:06:24.524333268 +0100
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-03-02 15:07:58.414333268 +0100
@@ -14,7 +14,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "sta_info.h"
-#include "ieee80211_sysfs.h"
+#include "debugfs_netdev.h"
 
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata)
 {
@@ -81,14 +81,8 @@ int ieee80211_if_add(struct net_device *
 	ret = register_netdevice(ndev);
 	if (ret)
 		goto fail;
-	ret = ieee80211_sysfs_add_netdevice(ndev);
-	if (ret) {
-		/* ndev will be freed by ndev->destructor */
-		unregister_netdevice(ndev);
-		*new_dev = NULL;
-		return ret;
-	}
 
+	ieee80211_debugfs_add_netdev(sdata);
 	list_add(&sdata->list, &local->sub_if_list);
 	ieee80211_update_default_wep_only(local);
 
@@ -130,16 +124,14 @@ int ieee80211_if_add_mgmt(struct ieee802
 	ret = register_netdevice(ndev);
 	if (ret)
 		goto fail;
-	ret = ieee80211_sysfs_add_netdevice(ndev);
-	if (ret)
-		goto fail_sysfs;
+
+	ieee80211_debugfs_add_netdev(nsdata);
+
 	if (local->open_count > 0)
 		dev_open(ndev);
 	local->apdev = ndev;
 	return 0;
 
-fail_sysfs:
-	unregister_netdevice(ndev);
 fail:
 	free_netdev(ndev);
 	return ret;
@@ -151,7 +143,7 @@ void ieee80211_if_del_mgmt(struct ieee80
 
 	ASSERT_RTNL();
 	apdev = local->apdev;
-	ieee80211_sysfs_remove_netdevice(apdev);
+	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(apdev));
 	local->apdev = NULL;
 	unregister_netdevice(apdev);
 }
@@ -160,6 +152,7 @@ void ieee80211_if_set_type(struct net_de
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	int oldtype = sdata->type;
 
 	sdata->type = type;
 	switch (type) {
@@ -205,7 +198,7 @@ void ieee80211_if_set_type(struct net_de
 		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",
 		       dev->name, __FUNCTION__, type);
 	}
-	ieee80211_sysfs_change_if_type(dev);
+	ieee80211_debugfs_change_if_type(sdata, oldtype);
 	ieee80211_update_default_wep_only(local);
 }
 
@@ -309,7 +302,7 @@ void __ieee80211_if_del(struct ieee80211
 	struct net_device *dev = sdata->dev;
 
 	list_del(&sdata->list);
-	ieee80211_sysfs_remove_netdevice(dev);
+	ieee80211_debugfs_remove_netdev(sdata);
 	unregister_netdevice(dev);
 	/* Except master interface, the net_device will be freed by
 	 * net_device->destructor (i. e. ieee80211_if_free). */
--- wireless-dev.orig/net/mac80211/ieee80211_key.h	2007-03-02 15:06:24.604333268 +0100
+++ wireless-dev/net/mac80211/ieee80211_key.h	2007-03-02 16:21:07.854333268 +0100
@@ -11,7 +11,7 @@
 #define IEEE80211_KEY_H
 
 #include <linux/types.h>
-#include <linux/kobject.h>
+#include <linux/kref.h>
 #include <linux/crypto.h>
 #include <net/mac80211.h>
 
@@ -42,7 +42,7 @@
 #define NUM_RX_DATA_QUEUES 17
 
 struct ieee80211_key {
-	struct kobject kobj;
+	struct kref kref;
 
 	int hw_key_idx; /* filled and used by low-level driver */
 	ieee80211_key_alg alg;
@@ -83,6 +83,23 @@ struct ieee80211_key {
 					* (used only for broadcast keys). */
 	s8 keyidx; /* WEP key index */
 
+#ifdef CONFIG_DEBUG_FS
+	struct {
+		struct dentry *stalink;
+		struct dentry *dir;
+		struct dentry *keylen;
+		struct dentry *force_sw_encrypt;
+		struct dentry *keyidx;
+		struct dentry *hw_key_idx;
+		struct dentry *tx_rx_count;
+		struct dentry *algorithm;
+		struct dentry *tx_spec;
+		struct dentry *rx_spec;
+		struct dentry *replays;
+		struct dentry *key;
+	} debugfs;
+#endif
+
 	u8 key[0];
 };
 
--- wireless-dev.orig/net/mac80211/ieee80211_sysfs.c	2007-03-02 15:07:01.094333268 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,344 +0,0 @@
-/*
- * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kernel.h>
-#include <linux/device.h>
-#include <linux/if.h>
-#include <linux/interrupt.h>
-#include <linux/netdevice.h>
-#include <linux/rtnetlink.h>
-#include <net/mac80211.h>
-#include <net/cfg80211.h>
-#include "ieee80211_i.h"
-#include "ieee80211_rate.h"
-#include "ieee80211_sysfs.h"
-#include "key_sysfs.h"
-
-static inline struct ieee80211_local *to_ieee80211_local(struct device *dev)
-{
-	struct wiphy *wiphy = container_of(dev, struct wiphy, dev);
-	return wiphy_priv(wiphy);
-}
-
-static inline int rtnl_lock_local(struct ieee80211_local *local)
-{
-	rtnl_lock();
-	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
-		rtnl_unlock();
-		return -ENODEV;
-	}
-	return 0;
-}
-
-/* attributes in /sys/class/net/X/ */
-
-static ssize_t ieee80211_if_show(struct device *d,
-			struct device_attribute *attr, char *buf,
-			ssize_t (*format)(const struct ieee80211_sub_if_data *,
-					  char *))
-{
-	struct net_device *dev = to_net_dev(d);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	ssize_t ret = -EINVAL;
-
-	read_lock(&dev_base_lock);
-	if (dev->reg_state == NETREG_REGISTERED) {
-		ret = (*format)(sdata, buf);
-	}
-	read_unlock(&dev_base_lock);
-	return ret;
-}
-
-#define IEEE80211_IF_FMT(name, field, format_string)			\
-static ssize_t ieee80211_if_fmt_##name(const struct			\
-			ieee80211_sub_if_data *sdata, char *buf)	\
-{									\
-	return sprintf(buf, format_string, sdata->field);		\
-}
-#define IEEE80211_IF_FMT_DEC(name, field)				\
-		IEEE80211_IF_FMT(name, field, "%d\n")
-#define IEEE80211_IF_FMT_HEX(name, field)				\
-		IEEE80211_IF_FMT(name, field, "%#x\n")
-#define IEEE80211_IF_FMT_SIZE(name, field)				\
-		IEEE80211_IF_FMT(name, field, "%zd\n")
-
-#define IEEE80211_IF_FMT_ATOMIC(name, field)				\
-static ssize_t ieee80211_if_fmt_##name(const struct			\
-			ieee80211_sub_if_data *sdata, char *buf)	\
-{									\
-	return sprintf(buf, "%d\n", atomic_read(&sdata->field));	\
-}
-
-#define IEEE80211_IF_FMT_MAC(name, field)				\
-static ssize_t ieee80211_if_fmt_##name(const struct			\
-			ieee80211_sub_if_data *sdata, char *buf)	\
-{									\
-	return sprintf(buf, MAC_FMT "\n", MAC_ARG(sdata->field));	\
-}
-
-#define __IEEE80211_IF_SHOW(name)					\
-static ssize_t ieee80211_if_show_##name(struct device *d,		\
-					struct device_attribute *attr,	\
-					char *buf)			\
-{									\
-	return ieee80211_if_show(d, attr, buf, ieee80211_if_fmt_##name);\
-}									\
-static DEVICE_ATTR(name, S_IRUGO, ieee80211_if_show_##name, NULL);
-
-#define IEEE80211_IF_SHOW(name, field, format)				\
-		IEEE80211_IF_FMT_##format(name, field)			\
-		__IEEE80211_IF_SHOW(name)
-
-/* common attributes */
-IEEE80211_IF_SHOW(channel_use, channel_use, DEC);
-IEEE80211_IF_SHOW(drop_unencrypted, drop_unencrypted, DEC);
-IEEE80211_IF_SHOW(eapol, eapol, DEC);
-IEEE80211_IF_SHOW(ieee8021_x, ieee802_1x, DEC);
-
-/* STA/IBSS attributes */
-IEEE80211_IF_SHOW(state, u.sta.state, DEC);
-IEEE80211_IF_SHOW(bssid, u.sta.bssid, MAC);
-IEEE80211_IF_SHOW(prev_bssid, u.sta.prev_bssid, MAC);
-IEEE80211_IF_SHOW(ssid_len, u.sta.ssid_len, SIZE);
-IEEE80211_IF_SHOW(aid, u.sta.aid, DEC);
-IEEE80211_IF_SHOW(ap_capab, u.sta.ap_capab, HEX);
-IEEE80211_IF_SHOW(capab, u.sta.capab, HEX);
-IEEE80211_IF_SHOW(extra_ie_len, u.sta.extra_ie_len, SIZE);
-IEEE80211_IF_SHOW(auth_tries, u.sta.auth_tries, DEC);
-IEEE80211_IF_SHOW(assoc_tries, u.sta.assoc_tries, DEC);
-IEEE80211_IF_SHOW(auth_algs, u.sta.auth_algs, HEX);
-IEEE80211_IF_SHOW(auth_alg, u.sta.auth_alg, DEC);
-IEEE80211_IF_SHOW(auth_transaction, u.sta.auth_transaction, DEC);
-
-static ssize_t ieee80211_if_fmt_flags(const struct
-			ieee80211_sub_if_data *sdata, char *buf)
-{
-	return sprintf(buf, "%s%s%s%s%s%s%s\n",
-		       sdata->u.sta.ssid_set ? "SSID\n" : "",
-		       sdata->u.sta.bssid_set ? "BSSID\n" : "",
-		       sdata->u.sta.prev_bssid_set ? "prev BSSID\n" : "",
-		       sdata->u.sta.authenticated ? "AUTH\n" : "",
-		       sdata->u.sta.associated ? "ASSOC\n" : "",
-		       sdata->u.sta.probereq_poll ? "PROBEREQ POLL\n" : "",
-		       sdata->u.sta.use_protection ? "CTS prot\n" : "");
-}
-__IEEE80211_IF_SHOW(flags);
-
-/* AP attributes */
-IEEE80211_IF_SHOW(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
-IEEE80211_IF_SHOW(dtim_period, u.ap.dtim_period, DEC);
-IEEE80211_IF_SHOW(dtim_count, u.ap.dtim_count, DEC);
-IEEE80211_IF_SHOW(num_beacons, u.ap.num_beacons, DEC);
-IEEE80211_IF_SHOW(force_unicast_rateidx, u.ap.force_unicast_rateidx, DEC);
-IEEE80211_IF_SHOW(max_ratectrl_rateidx, u.ap.max_ratectrl_rateidx, DEC);
-
-static ssize_t ieee80211_if_fmt_num_buffered_multicast(const struct
-			ieee80211_sub_if_data *sdata, char *buf)
-{
-	return sprintf(buf, "%u\n", skb_queue_len(&sdata->u.ap.ps_bc_buf));
-}
-__IEEE80211_IF_SHOW(num_buffered_multicast);
-
-static ssize_t ieee80211_if_fmt_beacon_head_len(const struct
-			ieee80211_sub_if_data *sdata, char *buf)
-{
-	if (sdata->u.ap.beacon_head)
-		return sprintf(buf, "%d\n", sdata->u.ap.beacon_head_len);
-	return sprintf(buf, "\n");
-}
-__IEEE80211_IF_SHOW(beacon_head_len);
-
-static ssize_t ieee80211_if_fmt_beacon_tail_len(const struct
-			ieee80211_sub_if_data *sdata, char *buf)
-{
-	if (sdata->u.ap.beacon_tail)
-		return sprintf(buf, "%d\n", sdata->u.ap.beacon_tail_len);
-	return sprintf(buf, "\n");
-}
-__IEEE80211_IF_SHOW(beacon_tail_len);
-
-/* WDS attributes */
-IEEE80211_IF_SHOW(peer, u.wds.remote_addr, MAC);
-
-/* VLAN attributes */
-IEEE80211_IF_SHOW(vlan_id, u.vlan.id, DEC);
-
-/* MONITOR attributes */
-static ssize_t ieee80211_if_fmt_mode(const struct
-			ieee80211_sub_if_data *sdata, char *buf)
-{
-	struct ieee80211_local *local = sdata->local;
-
-	return sprintf(buf, "%s\n",
-		       ((local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) ||
-			local->open_count == local->monitors) ?
-		       "hard" : "soft");
-}
-__IEEE80211_IF_SHOW(mode);
-
-static struct attribute *ieee80211_sta_attrs[] = {
-	&dev_attr_channel_use.attr,
-	&dev_attr_drop_unencrypted.attr,
-	&dev_attr_eapol.attr,
-	&dev_attr_ieee8021_x.attr,
-	&dev_attr_state.attr,
-	&dev_attr_bssid.attr,
-	&dev_attr_prev_bssid.attr,
-	&dev_attr_ssid_len.attr,
-	&dev_attr_aid.attr,
-	&dev_attr_ap_capab.attr,
-	&dev_attr_capab.attr,
-	&dev_attr_extra_ie_len.attr,
-	&dev_attr_auth_tries.attr,
-	&dev_attr_assoc_tries.attr,
-	&dev_attr_auth_algs.attr,
-	&dev_attr_auth_alg.attr,
-	&dev_attr_auth_transaction.attr,
-	&dev_attr_flags.attr,
-	NULL
-};
-
-static struct attribute *ieee80211_ap_attrs[] = {
-	&dev_attr_channel_use.attr,
-	&dev_attr_drop_unencrypted.attr,
-	&dev_attr_eapol.attr,
-	&dev_attr_ieee8021_x.attr,
-	&dev_attr_num_sta_ps.attr,
-	&dev_attr_dtim_period.attr,
-	&dev_attr_dtim_count.attr,
-	&dev_attr_num_beacons.attr,
-	&dev_attr_force_unicast_rateidx.attr,
-	&dev_attr_max_ratectrl_rateidx.attr,
-	&dev_attr_num_buffered_multicast.attr,
-	&dev_attr_beacon_head_len.attr,
-	&dev_attr_beacon_tail_len.attr,
-	NULL
-};
-
-static struct attribute *ieee80211_wds_attrs[] = {
-	&dev_attr_channel_use.attr,
-	&dev_attr_drop_unencrypted.attr,
-	&dev_attr_eapol.attr,
-	&dev_attr_ieee8021_x.attr,
-	&dev_attr_peer.attr,
-	NULL
-};
-
-static struct attribute *ieee80211_vlan_attrs[] = {
-	&dev_attr_channel_use.attr,
-	&dev_attr_drop_unencrypted.attr,
-	&dev_attr_eapol.attr,
-	&dev_attr_ieee8021_x.attr,
-	&dev_attr_vlan_id.attr,
-	NULL
-};
-
-static struct attribute *ieee80211_monitor_attrs[] = {
-	&dev_attr_mode.attr,
-	NULL
-};
-
-static struct attribute_group ieee80211_sta_group = {
-	.name = "sta",
-	.attrs = ieee80211_sta_attrs,
-};
-
-static struct attribute_group ieee80211_ap_group = {
-	.name = "ap",
-	.attrs = ieee80211_ap_attrs,
-};
-
-static struct attribute_group ieee80211_wds_group = {
-	.name = "wds",
-	.attrs = ieee80211_wds_attrs,
-};
-
-static struct attribute_group ieee80211_vlan_group = {
-	.name = "vlan",
-	.attrs = ieee80211_vlan_attrs,
-};
-
-static struct attribute_group ieee80211_monitor_group = {
-	.name = "monitor",
-	.attrs = ieee80211_monitor_attrs,
-};
-
-/* /sys/class/net/X functions */
-
-static void __ieee80211_remove_if_group(struct kobject *kobj,
-					struct ieee80211_sub_if_data *sdata)
-{
-	if (sdata->sysfs_group) {
-		sysfs_remove_group(kobj, sdata->sysfs_group);
-		sdata->sysfs_group = NULL;
-	}
-}
-
-static inline void ieee80211_remove_if_group(struct kobject *kobj,
-					     struct net_device *dev)
-{
-	__ieee80211_remove_if_group(kobj, IEEE80211_DEV_TO_SUB_IF(dev));
-}
-
-static int ieee80211_add_if_group(struct kobject *kobj,
-				  struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	int res = 0;
-
-	__ieee80211_remove_if_group(kobj, sdata);
-	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_STA:
-		sdata->sysfs_group = &ieee80211_sta_group;
-		break;
-	case IEEE80211_IF_TYPE_AP:
-		sdata->sysfs_group = &ieee80211_ap_group;
-		break;
-	case IEEE80211_IF_TYPE_WDS:
-		sdata->sysfs_group = &ieee80211_wds_group;
-		break;
-	case IEEE80211_IF_TYPE_VLAN:
-		sdata->sysfs_group = &ieee80211_vlan_group;
-		break;
-	case IEEE80211_IF_TYPE_MNTR:
-		sdata->sysfs_group = &ieee80211_monitor_group;
-		break;
-	default:
-		goto out;
-	}
-	res = sysfs_create_group(kobj, sdata->sysfs_group);
-	if (res)
-		sdata->sysfs_group = NULL;
-out:
-	return res;
-}
-
-int ieee80211_sysfs_change_if_type(struct net_device *dev)
-{
-	return ieee80211_add_if_group(&dev->dev.kobj, dev);
-}
-
-int ieee80211_sysfs_add_netdevice(struct net_device *dev)
-{
-	int res;
-
-	res = ieee80211_add_if_group(&dev->dev.kobj, dev);
-	if (res)
-		goto err_fail_if_group;
-	res = ieee80211_key_kset_sysfs_register(IEEE80211_DEV_TO_SUB_IF(dev));
-	return res;
-
-err_fail_if_group:
-	return res;
-}
-
-void ieee80211_sysfs_remove_netdevice(struct net_device *dev)
-{
-	ieee80211_key_kset_sysfs_unregister(IEEE80211_DEV_TO_SUB_IF(dev));
-	ieee80211_remove_if_group(&dev->dev.kobj, dev);
-}
--- wireless-dev.orig/net/mac80211/ieee80211_sysfs.h	2007-03-02 15:07:01.004333268 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,10 +0,0 @@
-/* routines exported for sysfs handling */
-
-#ifndef __IEEE80211_SYSFS_H
-#define __IEEE80211_SYSFS_H
-
-int ieee80211_sysfs_add_netdevice(struct net_device *dev);
-void ieee80211_sysfs_remove_netdevice(struct net_device *dev);
-int ieee80211_sysfs_change_if_type(struct net_device *dev);
-
-#endif /* __IEEE80211_SYSFS_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs_key.c	2007-03-02 17:22:55.181680146 +0100
@@ -0,0 +1,244 @@
+/*
+ * Copyright 2003-2005	Devicescape Software, Inc.
+ * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include "ieee80211_i.h"
+#include "ieee80211_key.h"
+#include "debugfs.h"
+#include "debugfs_key.h"
+
+#define KEY_READ(name, buflen, format_string)				\
+static ssize_t key_##name##_read(struct file *file,			\
+				 char __user *userbuf,			\
+				 size_t count, loff_t *ppos)		\
+{									\
+	char buf[buflen];						\
+	struct ieee80211_key *key = file->private_data;			\
+	int res = scnprintf(buf, buflen, format_string, key->name);	\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}
+#define KEY_READ_D(name) KEY_READ(name, 20, "%d\n")
+
+#define KEY_OPS(name)							\
+static const struct file_operations key_ ##name## _ops = {		\
+	.read = key_##name##_read,					\
+	.open = mac80211_open_file_generic,				\
+}
+
+#define KEY_FILE(name, format)						\
+		 KEY_READ_##format(name)				\
+		 KEY_OPS(name)
+
+KEY_FILE(keylen, D);
+KEY_FILE(force_sw_encrypt, D);
+KEY_FILE(keyidx, D);
+KEY_FILE(hw_key_idx, D);
+KEY_FILE(tx_rx_count, D);
+
+static ssize_t key_algorithm_read(struct file *file,
+				  char __user *userbuf,
+				  size_t count, loff_t *ppos)
+{
+	char *alg;
+	struct ieee80211_key *key = file->private_data;
+
+	switch (key->alg) {
+	case ALG_WEP:
+		alg = "WEP\n";
+		break;
+	case ALG_TKIP:
+		alg = "TKIP\n";
+		break;
+	case ALG_CCMP:
+		alg = "CCMP\n";
+		break;
+	default:
+		return 0;
+	}
+	return simple_read_from_buffer(userbuf, count, ppos, alg, strlen(alg));
+}
+KEY_OPS(algorithm);
+
+static ssize_t key_tx_spec_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	const u8 *tpn;
+	char buf[20];
+	int len;
+	struct ieee80211_key *key = file->private_data;
+
+	switch (key->alg) {
+	case ALG_WEP:
+		len = scnprintf(buf, sizeof(buf), "\n");
+	case ALG_TKIP:
+		len = scnprintf(buf, sizeof(buf), "%08x %04x\n",
+				key->u.tkip.iv32,
+				key->u.tkip.iv16);
+	case ALG_CCMP:
+		tpn = key->u.ccmp.tx_pn;
+		len = scnprintf(buf, sizeof(buf), "%02x%02x%02x%02x%02x%02x\n",
+				tpn[0], tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
+	default:
+		return 0;
+	}
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+KEY_OPS(tx_spec);
+
+static ssize_t key_rx_spec_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct ieee80211_key *key = file->private_data;
+	char buf[14*NUM_RX_DATA_QUEUES+1], *p = buf;
+	int i, len;
+	const u8 *rpn;
+
+	switch (key->alg) {
+	case ALG_WEP:
+		len = scnprintf(buf, sizeof(buf), "\n");
+	case ALG_TKIP:
+		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+			p += scnprintf(p, sizeof(buf)+buf-p,
+				       "%08x %04x\n",
+				       key->u.tkip.iv32_rx[i],
+				       key->u.tkip.iv16_rx[i]);
+		len = p - buf;
+	case ALG_CCMP:
+		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
+			rpn = key->u.ccmp.rx_pn[i];
+			p += scnprintf(p, sizeof(buf)+buf-p,
+				       "%02x%02x%02x%02x%02x%02x\n",
+				       rpn[0], rpn[1], rpn[2],
+				       rpn[3], rpn[4], rpn[5]);
+		}
+		len = p - buf;
+	default:
+		return 0;
+	}
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+KEY_OPS(rx_spec);
+
+static ssize_t key_replays_read(struct file *file, char __user *userbuf,
+				size_t count, loff_t *ppos)
+{
+	struct ieee80211_key *key = file->private_data;
+	char buf[20];
+	int len;
+
+	if (key->alg != ALG_CCMP)
+		return 0;
+	len = scnprintf(buf, sizeof(buf), "%u\n", key->u.ccmp.replays);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, len);
+}
+KEY_OPS(replays);
+
+static ssize_t key_key_read(struct file *file, char __user *userbuf,
+			    size_t count, loff_t *ppos)
+{
+	struct ieee80211_key *key = file->private_data;
+	int i, res, bufsize = 2*key->keylen+2;
+	char *buf = kmalloc(bufsize, GFP_KERNEL);
+	char *p = buf;
+
+	for (i = 0; i < key->keylen; i++)
+		p += scnprintf(p, bufsize+buf-p, "%02x", key->key[i]);
+	p += scnprintf(p, bufsize+buf-p, "\n");
+	res = simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+	kfree(buf);
+	return res;
+}
+KEY_OPS(key);
+
+#define DEBUGFS_ADD(name) \
+	key->debugfs.name = debugfs_create_file(#name, 0400,\
+				key->debugfs.dir, key, &key_##name##_ops);
+
+void ieee80211_debugfs_key_add(struct ieee80211_local *local,
+			       struct ieee80211_key *key)
+{
+	char buf[20];
+
+	if (!local->debugfs.keys)
+		return;
+
+	sprintf(buf, "%d", key->keyidx);
+	key->debugfs.dir = debugfs_create_dir(buf,
+					local->debugfs.keys);
+
+	if (!key->debugfs.dir)
+		return;
+
+	DEBUGFS_ADD(keylen);
+	DEBUGFS_ADD(force_sw_encrypt);
+	DEBUGFS_ADD(keyidx);
+	DEBUGFS_ADD(hw_key_idx);
+	DEBUGFS_ADD(tx_rx_count);
+	DEBUGFS_ADD(algorithm);
+	DEBUGFS_ADD(tx_spec);
+	DEBUGFS_ADD(rx_spec);
+	DEBUGFS_ADD(replays);
+	DEBUGFS_ADD(key);
+};
+
+#define DEBUGFS_DEL(name) \
+	debugfs_remove(key->debugfs.name); key->debugfs.name = NULL;
+
+void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
+{
+	if (!key)
+		return;
+
+	DEBUGFS_DEL(keylen);
+	DEBUGFS_DEL(force_sw_encrypt);
+	DEBUGFS_DEL(keyidx);
+	DEBUGFS_DEL(hw_key_idx);
+	DEBUGFS_DEL(tx_rx_count);
+	DEBUGFS_DEL(algorithm);
+	DEBUGFS_DEL(tx_spec);
+	DEBUGFS_DEL(rx_spec);
+	DEBUGFS_DEL(replays);
+	DEBUGFS_DEL(key);
+
+	debugfs_remove(key->debugfs.dir);
+	debugfs_remove(key->debugfs.stalink);
+}
+void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata)
+{
+	char buf[50];
+
+	if (!sdata->debugfsdir)
+		return;
+
+	sprintf(buf, "../keys/%d", sdata->default_key->keyidx);
+	sdata->debugfs.default_key =
+		debugfs_create_symlink("default_key", sdata->debugfsdir, buf);
+}
+void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata)
+{
+	if (!sdata)
+		return;
+
+	debugfs_remove(sdata->debugfs.default_key);
+	sdata->debugfs.default_key = NULL;
+}
+void ieee80211_debugfs_key_sta_link(struct ieee80211_key *key,
+				    struct sta_info *sta)
+{
+	char buf[50];
+
+	if (!key->debugfs.dir)
+		return;
+
+	sprintf(buf, "../sta/" MAC_FMT, MAC_ARG(sta->addr));
+	key->debugfs.stalink =
+		debugfs_create_symlink("station", key->debugfs.dir, buf);
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs_key.h	2007-03-02 16:21:39.624333268 +0100
@@ -0,0 +1,30 @@
+#ifndef __MAC80211_DEBUGFS_KEY_H
+#define __MAC80211_DEBUGFS_KEY_H
+
+#ifdef CONFIG_DEBUG_FS
+void ieee80211_debugfs_key_add(struct ieee80211_local *local,
+			       struct ieee80211_key *key);
+void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
+void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_key_remove_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_key_sta_link(struct ieee80211_key *key,
+				    struct sta_info *sta);
+#else
+static inline void ieee80211_debugfs_key_add(struct ieee80211_local *local,
+					     struct ieee80211_key *key)
+{}
+static inline void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
+{}
+static inline void ieee80211_debugfs_key_add_default(
+	struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_debugfs_key_remove_default(
+	struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_debugfs_key_sta_link(
+	struct ieee80211_key *key, struct sta_info *sta)
+{
+}
+#endif
+
+#endif /* __MAC80211_DEBUGFS_KEY_H */
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-02 15:07:07.114333268 +0100
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-02 16:19:48.794333268 +0100
@@ -25,7 +25,7 @@
 #include "ieee80211_rate.h"
 #include "wpa.h"
 #include "aes_ccm.h"
-#include "key_sysfs.h"
+#include "debugfs_key.h"
 
 static int ieee80211_regdom = 0x10; /* FCC */
 module_param(ieee80211_regdom, int, 0444);
@@ -634,10 +634,10 @@ static int ieee80211_set_encryption(stru
 		kfree(keyconf);
 
 		if (set_tx_key || sdata->default_key == key) {
-			ieee80211_key_sysfs_remove_default(sdata);
+			ieee80211_debugfs_key_remove_default(sdata);
 			sdata->default_key = NULL;
 		}
-		ieee80211_key_sysfs_remove(key);
+		ieee80211_debugfs_key_remove(key);
 		if (sta)
 			sta->key = NULL;
 		else
@@ -678,18 +678,18 @@ static int ieee80211_set_encryption(stru
 		}
 
 		if (set_tx_key || sdata->default_key == old_key) {
-			ieee80211_key_sysfs_remove_default(sdata);
+			ieee80211_debugfs_key_remove_default(sdata);
 			sdata->default_key = NULL;
 		}
-		ieee80211_key_sysfs_remove(old_key);
+		ieee80211_debugfs_key_remove(old_key);
 		if (sta)
 			sta->key = key;
 		else
 			sdata->keys[idx] = key;
 		ieee80211_key_free(old_key);
-		ret = ieee80211_key_sysfs_add(key);
-		if (ret)
-			goto err_null;
+		ieee80211_debugfs_key_add(local, key);
+		if (sta)
+			ieee80211_debugfs_key_sta_link(key, sta);
 
 		if (try_hwaccel &&
 		    (alg == ALG_WEP || alg == ALG_TKIP || alg == ALG_CCMP)) {
@@ -702,9 +702,9 @@ static int ieee80211_set_encryption(stru
 
 	if (set_tx_key || (!sta && !sdata->default_key && key)) {
 		sdata->default_key = key;
-		if (key && ieee80211_key_sysfs_add_default(sdata))
-			printk(KERN_WARNING "%s: cannot create symlink to "
-			       "default key\n", dev->name);
+		if (key)
+			ieee80211_debugfs_key_add_default(sdata);
+
 		if (local->ops->set_key_idx &&
 		    local->ops->set_key_idx(local_to_hw(local), idx))
 			printk(KERN_DEBUG "%s: failed to set TX key idx for "
@@ -716,11 +716,6 @@ static int ieee80211_set_encryption(stru
 
 	return 0;
 
-err_null:
-	if (sta)
-		sta->key = NULL;
-	else
-		sdata->keys[idx] = NULL;
 err_free:
 	ieee80211_key_free(key);
 err_out:
@@ -2949,10 +2944,10 @@ static int ieee80211_ioctl_siwencode(str
 	else if (erq->length == 0) {
 		/* No key data - just set the default TX key index */
 		if (sdata->default_key != sdata->keys[idx]) {
-			ieee80211_key_sysfs_remove_default(sdata);
+			ieee80211_debugfs_key_remove_default(sdata);
 			sdata->default_key = sdata->keys[idx];
 			if (sdata->default_key)
-				ieee80211_key_sysfs_add_default(sdata);
+				ieee80211_debugfs_key_add_default(sdata);
 		}
 		return 0;
 	}
--- wireless-dev.orig/net/mac80211/key_sysfs.c	2007-03-02 15:07:07.584333268 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,217 +0,0 @@
-/*
- * Copyright 2003-2005	Devicescape Software, Inc.
- * Copyright (c) 2006	Jiri Benc <jbenc@suse.cz>
- * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/kobject.h>
-#include <linux/sysfs.h>
-#include "ieee80211_i.h"
-#include "ieee80211_key.h"
-
-/* keys attributtes */
-
-struct key_attribute {
-	struct attribute attr;
-	ssize_t (*show)(const struct ieee80211_key *, char *buf);
-	ssize_t (*store)(struct ieee80211_key *, const char *buf,
-			 size_t count);
-};
-
-#define KEY_SHOW(name, field, format_string)				\
-static ssize_t show_key_##name(const struct ieee80211_key *key, char *buf)\
-{									\
-	return sprintf(buf, format_string, key->field);			\
-}
-#define KEY_SHOW_D(name, field) KEY_SHOW(name, field, "%d\n")
-
-#define __KEY_ATTR(name)						\
-static struct key_attribute key_attr_##name =				\
-	__ATTR(name, S_IRUSR, show_key_##name, NULL)
-
-#define KEY_ATTR(name, field, format)					\
-		KEY_SHOW_##format(name, field)				\
-		__KEY_ATTR(name)
-
-KEY_ATTR(length, keylen, D);
-KEY_ATTR(sw_encrypt, force_sw_encrypt, D);
-KEY_ATTR(index, keyidx, D);
-KEY_ATTR(hw_index, hw_key_idx, D);
-KEY_ATTR(tx_rx_count, tx_rx_count, D);
-
-static ssize_t show_key_algorithm(const struct ieee80211_key *key, char *buf)
-{
-	char *alg;
-
-	switch (key->alg) {
-	case ALG_WEP:
-		alg = "WEP";
-		break;
-	case ALG_TKIP:
-		alg = "TKIP";
-		break;
-	case ALG_CCMP:
-		alg = "CCMP";
-		break;
-	default:
-		return 0;
-	}
-	return sprintf(buf, "%s\n", alg);
-}
-__KEY_ATTR(algorithm);
-
-static ssize_t show_key_tx_spec(const struct ieee80211_key *key, char *buf)
-{
-	const u8 *tpn;
-
-	switch (key->alg) {
-	case ALG_WEP:
-		return sprintf(buf, "\n");
-	case ALG_TKIP:
-		return sprintf(buf, "%08x %04x\n", key->u.tkip.iv32,
-			       key->u.tkip.iv16);
-	case ALG_CCMP:
-		tpn = key->u.ccmp.tx_pn;
-		return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n", tpn[0],
-			       tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
-	default:
-		return 0;
-	}
-}
-__KEY_ATTR(tx_spec);
-
-static ssize_t show_key_rx_spec(const struct ieee80211_key *key, char *buf)
-{
-	int i;
-	const u8 *rpn;
-	char *p = buf;
-
-	switch (key->alg) {
-	case ALG_WEP:
-		return sprintf(buf, "\n");
-	case ALG_TKIP:
-		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-			p += sprintf(p, "%08x %04x\n",
-				     key->u.tkip.iv32_rx[i],
-				     key->u.tkip.iv16_rx[i]);
-		return (p - buf);
-	case ALG_CCMP:
-		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
-			rpn = key->u.ccmp.rx_pn[i];
-			p += sprintf(p, "%02x%02x%02x%02x%02x%02x\n", rpn[0],
-				     rpn[1], rpn[2], rpn[3], rpn[4], rpn[5]);
-		}
-		return (p - buf);
-	default:
-		return 0;
-	}
-}
-__KEY_ATTR(rx_spec);
-
-static ssize_t show_key_replays(const struct ieee80211_key *key, char *buf)
-{
-	if (key->alg != ALG_CCMP)
-		return 0;
-	return sprintf(buf, "%u\n", key->u.ccmp.replays);
-}
-__KEY_ATTR(replays);
-
-static ssize_t show_key_key(const struct ieee80211_key *key, char *buf)
-{
-	int i;
-	char *p = buf;
-
-	for (i = 0; i < key->keylen; i++)
-		p += sprintf(p, "%02x", key->key[i]);
-	p += sprintf(p, "\n");
-	return (p - buf);
-}
-__KEY_ATTR(key);
-
-static struct attribute *key_ktype_attrs[] = {
-	&key_attr_length.attr,
-	&key_attr_sw_encrypt.attr,
-	&key_attr_index.attr,
-	&key_attr_hw_index.attr,
-	&key_attr_tx_rx_count.attr,
-	&key_attr_algorithm.attr,
-	&key_attr_tx_spec.attr,
-	&key_attr_rx_spec.attr,
-	&key_attr_replays.attr,
-	&key_attr_key.attr,
-	NULL
-};
-
-/* structures and functions */
-
-static ssize_t key_sysfs_show(struct kobject *kobj, struct attribute *attr,
-			      char *buf)
-{
-	struct key_attribute *key_attr;
-	struct ieee80211_key *key;
-
-	key_attr = container_of(attr, struct key_attribute, attr);
-	key = container_of(kobj, struct ieee80211_key, kobj);
-	return key_attr->show(key, buf);
-}
-
-static struct sysfs_ops key_ktype_ops = {
-	.show = key_sysfs_show,
-};
-
-static struct kobj_type key_ktype = {
-	.release = ieee80211_key_release,
-	.sysfs_ops = &key_ktype_ops,
-	.default_attrs = key_ktype_attrs,
-};
-
-int ieee80211_key_kset_sysfs_register(struct ieee80211_sub_if_data *sdata)
-{
-	int res;
-
-	res = kobject_set_name(&sdata->key_kset.kobj, "keys");
-	if (res)
-		return res;
-	sdata->key_kset.kobj.parent = &sdata->dev->dev.kobj;
-	sdata->key_kset.ktype = &key_ktype;
-	return kset_register(&sdata->key_kset);
-}
-
-void ieee80211_key_kset_sysfs_unregister(struct ieee80211_sub_if_data *sdata)
-{
-	kset_unregister(&sdata->key_kset);
-}
-
-void ieee80211_key_sysfs_set_kset(struct ieee80211_key *key, struct kset *kset)
-{
-	key->kobj.kset = kset;
-	if (!kset)
-		key->kobj.ktype = &key_ktype;
-}
-
-int ieee80211_key_sysfs_add(struct ieee80211_key *key)
-{
-	return kobject_add(&key->kobj);
-}
-
-void ieee80211_key_sysfs_remove(struct ieee80211_key *key)
-{
-	if (key)
-		kobject_del(&key->kobj);
-}
-
-int ieee80211_key_sysfs_add_default(struct ieee80211_sub_if_data *sdata)
-{
-	return sysfs_create_link(&sdata->key_kset.kobj,
-				 &sdata->default_key->kobj, "default");
-}
-
-void ieee80211_key_sysfs_remove_default(struct ieee80211_sub_if_data *sdata)
-{
-	if (sdata->default_key)
-		sysfs_remove_link(&sdata->key_kset.kobj, "default");
-}
--- wireless-dev.orig/net/mac80211/key_sysfs.h	2007-03-02 15:07:09.254333268 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,12 +0,0 @@
-#ifndef __MAC80211_KEY_SYSFS_H
-#define __MAC80211_KEY_SYSFS_H
-
-int ieee80211_key_kset_sysfs_register(struct ieee80211_sub_if_data *sdata);
-void ieee80211_key_kset_sysfs_unregister(struct ieee80211_sub_if_data *sdata);
-void ieee80211_key_sysfs_set_kset(struct ieee80211_key *key, struct kset *kset);
-int ieee80211_key_sysfs_add(struct ieee80211_key *key);
-void ieee80211_key_sysfs_remove(struct ieee80211_key *key);
-int ieee80211_key_sysfs_add_default(struct ieee80211_sub_if_data *sdata);
-void ieee80211_key_sysfs_remove_default(struct ieee80211_sub_if_data *sdata);
-
-#endif /* __MAC80211_KEY_SYSFS_H */
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-03-02 15:07:08.014333268 +0100
+++ wireless-dev/net/mac80211/sta_info.c	2007-03-02 15:07:58.354333268 +0100
@@ -18,7 +18,7 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "sta_info.h"
-#include "key_sysfs.h"
+#include "debugfs_key.h"
 #include "debugfs_sta.h"
 
 /* Caller must hold local->sta_lock */
@@ -197,7 +197,7 @@ static void finish_sta_info_free(struct 
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
 	if (sta->key) {
-		ieee80211_key_sysfs_remove(sta->key);
+		ieee80211_debugfs_key_remove(sta->key);
 		ieee80211_key_free(sta->key);
 		sta->key = NULL;
 	}
--- wireless-dev.orig/net/mac80211/debugfs.c	2007-03-02 15:07:06.614333268 +0100
+++ wireless-dev/net/mac80211/debugfs.c	2007-03-02 17:21:02.051680146 +0100
@@ -301,6 +301,7 @@ void debugfs_hw_add(struct ieee80211_loc
 		return;
 
 	local->debugfs.stations = debugfs_create_dir("stations", phyd);
+	local->debugfs.keys = debugfs_create_dir("keys", phyd);
 
 	DEBUGFS_ADD(channel);
 	DEBUGFS_ADD(frequency);
@@ -426,4 +427,5 @@ void debugfs_hw_del(struct ieee80211_loc
 
 	debugfs_remove(local->debugfs.statistics);
 	debugfs_remove(local->debugfs.stations);
+	debugfs_remove(local->debugfs.keys);
 }


