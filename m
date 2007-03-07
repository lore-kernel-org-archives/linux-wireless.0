Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965570AbXCGQvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 11:51:51 -0500
Message-Id: <20070307164646.874205000@sipsolutions.net>
References: <20070307164531.910923000@sipsolutions.net>
Date: Wed, 07 Mar 2007 17:45:33 +0100
From: johannes@sipsolutions.net
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH (v3) 2/4] mac80211: move sta dir to debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves the "sta" dir to a new debugfs dir "stations".

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Makefile              |    4 
 net/mac80211/debugfs.c             |    6 
 net/mac80211/debugfs.h             |    1 
 net/mac80211/debugfs_sta.c         |  242 ++++++++++++++++++++
 net/mac80211/debugfs_sta.h         |   12 +
 net/mac80211/ieee80211.c           |    1 
 net/mac80211/ieee80211_i.h         |   15 -
 net/mac80211/ieee80211_ioctl.c     |    4 
 net/mac80211/ieee80211_rate.h      |   29 +-
 net/mac80211/ieee80211_sysfs.c     |    1 
 net/mac80211/ieee80211_sysfs_sta.c |  439 -------------------------------------
 net/mac80211/key_sysfs.c           |  217 ++++++++++++++++++
 net/mac80211/key_sysfs.h           |   12 +
 net/mac80211/rc80211_simple.c      |   82 ++++--
 net/mac80211/sta_info.c            |   55 +---
 net/mac80211/sta_info.h            |   18 +
 16 files changed, 602 insertions(+), 536 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_sysfs_sta.c	2007-03-07 13:03:50.464710923 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,439 +0,0 @@
-/*
- * Copyright 2003-2005, Devicescape Software, Inc.
- * Copyright (c) 2006 Jiri Benc <jbenc@suse.cz>
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
-#include "sta_info.h"
-
-static ssize_t sta_sysfs_show(struct kobject *, struct attribute *, char *);
-static ssize_t key_sysfs_show(struct kobject *, struct attribute *, char *);
-
-static struct sysfs_ops sta_ktype_ops = {
-	.show = sta_sysfs_show,
-};
-
-static struct sysfs_ops key_ktype_ops = {
-	.show = key_sysfs_show,
-};
-
-/* sta attributtes */
-
-#define STA_SHOW(name, field, format_string)				\
-static ssize_t show_sta_##name(const struct sta_info *sta, char *buf)	\
-{									\
-	return sprintf(buf, format_string, sta->field);			\
-}
-#define STA_SHOW_D(name, field) STA_SHOW(name, field, "%d\n")
-#define STA_SHOW_U(name, field) STA_SHOW(name, field, "%u\n")
-#define STA_SHOW_LU(name, field) STA_SHOW(name, field, "%lu\n")
-#define STA_SHOW_S(name, field) STA_SHOW(name, field, "%s\n")
-
-#define STA_SHOW_RATE(name, field)					\
-static ssize_t show_sta_##name(const struct sta_info *sta, char *buf)	\
-{									\
-	struct ieee80211_local *local = wdev_priv(sta->dev->ieee80211_ptr);\
-	struct ieee80211_hw_mode *mode = local->oper_hw_mode;		\
-	return sprintf(buf, "%d\n",					\
-		       (sta->field >= 0 &&				\
-			sta->field < mode->num_rates) ?			\
-		       mode->rates[sta->field].rate : -1);		\
-}
-
-#define __STA_ATTR(name)						\
-static struct sta_attribute sta_attr_##name =				\
-	__ATTR(name, S_IRUGO, show_sta_##name, NULL)
-
-#define STA_ATTR(name, field, format)					\
-		STA_SHOW_##format(name, field)				\
-		__STA_ATTR(name)
-
-STA_ATTR(aid, aid, D);
-STA_ATTR(key_idx_compression, key_idx_compression, D);
-STA_ATTR(dev, dev->name, S);
-STA_ATTR(vlan_id, vlan_id, D);
-STA_ATTR(rx_packets, rx_packets, LU);
-STA_ATTR(tx_packets, tx_packets, LU);
-STA_ATTR(rx_bytes, rx_bytes, LU);
-STA_ATTR(tx_bytes, tx_bytes, LU);
-STA_ATTR(rx_duplicates, num_duplicates, LU);
-STA_ATTR(rx_fragments, rx_fragments, LU);
-STA_ATTR(rx_dropped, rx_dropped, LU);
-STA_ATTR(tx_fragments, tx_fragments, LU);
-STA_ATTR(tx_filtered, tx_filtered_count, LU);
-STA_ATTR(txrate, txrate, RATE);
-STA_ATTR(last_txrate, last_txrate, RATE);
-STA_ATTR(tx_retry_failed, tx_retry_failed, LU);
-STA_ATTR(tx_retry_count, tx_retry_count, LU);
-STA_ATTR(last_rssi, last_rssi, D);
-STA_ATTR(last_signal, last_signal, D);
-STA_ATTR(last_noise, last_noise, D);
-STA_ATTR(channel_use, channel_use, D);
-STA_ATTR(wep_weak_iv_count, wep_weak_iv_count, D);
-
-static ssize_t show_sta_flags(const struct sta_info *sta, char *buf)
-{
-	return sprintf(buf, "%s%s%s%s%s%s%s%s%s",
-		       sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
-		       sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
-		       sta->flags & WLAN_STA_PS ? "PS\n" : "",
-		       sta->flags & WLAN_STA_TIM ? "TIM\n" : "",
-		       sta->flags & WLAN_STA_PERM ? "PERM\n" : "",
-		       sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
-		       sta->flags & WLAN_STA_SHORT_PREAMBLE ?
-		       "SHORT PREAMBLE\n" : "",
-		       sta->flags & WLAN_STA_WME ? "WME\n" : "",
-		       sta->flags & WLAN_STA_WDS ? "WDS\n" : "");
-}
-__STA_ATTR(flags);
-
-static ssize_t show_sta_num_ps_buf_frames(const struct sta_info *sta, char *buf)
-{
-	return sprintf(buf, "%u\n", skb_queue_len(&sta->ps_tx_buf));
-}
-__STA_ATTR(num_ps_buf_frames);
-
-static ssize_t show_sta_last_ack_rssi(const struct sta_info *sta, char *buf)
-{
-	return sprintf(buf, "%d %d %d\n", sta->last_ack_rssi[0],
-		       sta->last_ack_rssi[1], sta->last_ack_rssi[2]);
-}
-__STA_ATTR(last_ack_rssi);
-
-static ssize_t show_sta_last_ack_ms(const struct sta_info *sta, char *buf)
-{
-	return sprintf(buf, "%d\n", sta->last_ack ?
-		       jiffies_to_msecs(jiffies - sta->last_ack) : -1);
-}
-__STA_ATTR(last_ack_ms);
-
-static ssize_t show_sta_inactive_ms(const struct sta_info *sta, char *buf)
-{
-	return sprintf(buf, "%d\n", jiffies_to_msecs(jiffies - sta->last_rx));
-}
-__STA_ATTR(inactive_ms);
-
-static ssize_t show_sta_last_seq_ctrl(const struct sta_info *sta, char *buf)
-{
-	int i;
-	char *p = buf;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += sprintf(p, "%x ", sta->last_seq_ctrl[i]);
-	p += sprintf(p, "\n");
-	return (p - buf);
-}
-__STA_ATTR(last_seq_ctrl);
-
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-static ssize_t show_sta_wme_rx_queue(const struct sta_info *sta, char *buf)
-{
-	int i;
-	char *p = buf;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += sprintf(p, "%u ", sta->wme_rx_queue[i]);
-	p += sprintf(p, "\n");
-	return (p - buf);
-}
-__STA_ATTR(wme_rx_queue);
-
-static ssize_t show_sta_wme_tx_queue(const struct sta_info *sta, char *buf)
-{
-	int i;
-	char *p = buf;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += sprintf(p, "%u ", sta->wme_tx_queue[i]);
-	p += sprintf(p, "\n");
-	return (p - buf);
-}
-__STA_ATTR(wme_tx_queue);
-#endif
-
-static struct attribute *sta_ktype_attrs[] = {
-	&sta_attr_aid.attr,
-	&sta_attr_key_idx_compression.attr,
-	&sta_attr_dev.attr,
-	&sta_attr_vlan_id.attr,
-	&sta_attr_rx_packets.attr,
-	&sta_attr_tx_packets.attr,
-	&sta_attr_rx_bytes.attr,
-	&sta_attr_tx_bytes.attr,
-	&sta_attr_rx_duplicates.attr,
-	&sta_attr_rx_fragments.attr,
-	&sta_attr_rx_dropped.attr,
-	&sta_attr_tx_fragments.attr,
-	&sta_attr_tx_filtered.attr,
-	&sta_attr_txrate.attr,
-	&sta_attr_last_txrate.attr,
-	&sta_attr_tx_retry_failed.attr,
-	&sta_attr_tx_retry_count.attr,
-	&sta_attr_last_rssi.attr,
-	&sta_attr_last_signal.attr,
-	&sta_attr_last_noise.attr,
-	&sta_attr_channel_use.attr,
-	&sta_attr_wep_weak_iv_count.attr,
-
-	&sta_attr_flags.attr,
-	&sta_attr_num_ps_buf_frames.attr,
-	&sta_attr_last_ack_rssi.attr,
-	&sta_attr_last_ack_ms.attr,
-	&sta_attr_inactive_ms.attr,
-	&sta_attr_last_seq_ctrl.attr,
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	&sta_attr_wme_rx_queue.attr,
-	&sta_attr_wme_tx_queue.attr,
-#endif
-	NULL
-};
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
-static struct kobj_type sta_ktype = {
-	.release = sta_info_release,
-	.sysfs_ops = &sta_ktype_ops,
-	.default_attrs = sta_ktype_attrs,
-};
-
-static struct kobj_type key_ktype = {
-	.release = ieee80211_key_release,
-	.sysfs_ops = &key_ktype_ops,
-	.default_attrs = key_ktype_attrs,
-};
-
-static ssize_t sta_sysfs_show(struct kobject *kobj, struct attribute *attr,
-			      char *buf)
-{
-	struct sta_attribute *sta_attr;
-	struct sta_info *sta;
-
-	sta_attr = container_of(attr, struct sta_attribute, attr);
-	sta = container_of(kobj, struct sta_info, kobj);
-	return sta_attr->show(sta, buf);
-}
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
-int ieee80211_sta_kset_sysfs_register(struct ieee80211_local *local)
-{
-	int res;
-
-	res = kobject_set_name(&local->sta_kset.kobj, "sta");
-	if (res)
-		return res;
-	local->sta_kset.kobj.parent = &local->hw.wiphy->dev.kobj;
-	local->sta_kset.ktype = &sta_ktype;
-	return kset_register(&local->sta_kset);
-}
-
-void ieee80211_sta_kset_sysfs_unregister(struct ieee80211_local *local)
-{
-	kset_unregister(&local->sta_kset);
-}
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
-int ieee80211_sta_sysfs_add(struct sta_info *sta)
-{
-	return kobject_add(&sta->kobj);
-}
-
-void ieee80211_sta_sysfs_remove(struct sta_info *sta)
-{
-	kobject_del(&sta->kobj);
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
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-07 13:03:54.944710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-07 13:03:56.054710923 +0100
@@ -381,7 +381,6 @@ struct ieee80211_local {
 	} ieee80211_msg_enum;
 
 	/* Station data structures */
-	struct kset sta_kset;
 	spinlock_t sta_lock; /* mutex for STA data structures */
 	int num_sta; /* number of stations in sta_list */
 	struct list_head sta_list;
@@ -599,6 +598,7 @@ struct ieee80211_local {
 			struct dentry *wme_tx_queue;
 			struct dentry *wme_rx_queue;
 		} stats;
+		struct dentry *stations;
 	} debugfs;
 #endif
 };
@@ -763,17 +763,4 @@ void ieee80211_if_sdata_init(struct ieee
 int ieee80211_if_add_mgmt(struct ieee80211_local *local);
 void ieee80211_if_del_mgmt(struct ieee80211_local *local);
 
-/* ieee80211_sysfs_sta.c */
-int ieee80211_sta_kset_sysfs_register(struct ieee80211_local *local);
-void ieee80211_sta_kset_sysfs_unregister(struct ieee80211_local *local);
-int ieee80211_sta_sysfs_add(struct sta_info *sta);
-void ieee80211_sta_sysfs_remove(struct sta_info *sta);
-int ieee80211_key_kset_sysfs_register(struct ieee80211_sub_if_data *sdata);
-void ieee80211_key_kset_sysfs_unregister(struct ieee80211_sub_if_data *sdata);
-void ieee80211_key_sysfs_set_kset(struct ieee80211_key *key, struct kset *kset);
-int ieee80211_key_sysfs_add(struct ieee80211_key *key);
-void ieee80211_key_sysfs_remove(struct ieee80211_key *key);
-int ieee80211_key_sysfs_add_default(struct ieee80211_sub_if_data *sdata);
-void ieee80211_key_sysfs_remove_default(struct ieee80211_sub_if_data *sdata);
-
 #endif /* IEEE80211_I_H */
--- wireless-dev.orig/net/mac80211/Makefile	2007-03-07 13:03:54.934710923 +0100
+++ wireless-dev/net/mac80211/Makefile	2007-03-07 13:03:56.054710923 +0100
@@ -1,7 +1,7 @@
 obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
-mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o
+mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o debugfs_sta.o
 
 mac80211-objs := \
 	ieee80211.o \
@@ -14,12 +14,12 @@ mac80211-objs := \
 	ieee80211_iface.o \
 	ieee80211_rate.o \
 	ieee80211_sysfs.o \
-	ieee80211_sysfs_sta.o \
 	michael.o \
 	tkip.o \
 	aes_ccm.o \
 	wme.o \
 	ieee80211_cfg.o \
+	key_sysfs.o \
 	$(mac80211-objs-y)
 
 ifeq ($(CONFIG_NET_SCHED),)
--- wireless-dev.orig/net/mac80211/debugfs.c	2007-03-07 13:03:54.944710923 +0100
+++ wireless-dev/net/mac80211/debugfs.c	2007-03-07 13:03:56.054710923 +0100
@@ -13,7 +13,7 @@
 #include "ieee80211_rate.h"
 #include "debugfs.h"
 
-static int mac80211_open_file_generic(struct inode *inode, struct file *file)
+int mac80211_open_file_generic(struct inode *inode, struct file *file)
 {
 	file->private_data = inode->i_private;
 	return 0;
@@ -302,6 +302,8 @@ void debugfs_hw_add(struct ieee80211_loc
 	if (!phyd)
 		return;
 
+	local->debugfs.stations = debugfs_create_dir("stations", phyd);
+
 	DEBUGFS_ADD(channel);
 	DEBUGFS_ADD(frequency);
 	DEBUGFS_ADD(radar_detect);
@@ -426,4 +428,6 @@ void debugfs_hw_del(struct ieee80211_loc
 
 	debugfs_remove(local->debugfs.statistics);
 	local->debugfs.statistics = NULL;
+	debugfs_remove(local->debugfs.stations);
+	local->debugfs.stations = NULL;
 }
--- wireless-dev.orig/net/mac80211/debugfs.h	2007-03-07 13:03:54.934710923 +0100
+++ wireless-dev/net/mac80211/debugfs.h	2007-03-07 13:03:56.054710923 +0100
@@ -4,6 +4,7 @@
 #ifdef CONFIG_DEBUG_FS
 extern void debugfs_hw_add(struct ieee80211_local *local);
 extern void debugfs_hw_del(struct ieee80211_local *local);
+extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
 #else
 static inline void debugfs_hw_add(struct ieee80211_local *local)
 {
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-03-07 13:03:50.464710923 +0100
+++ wireless-dev/net/mac80211/sta_info.c	2007-03-07 13:03:56.064710923 +0100
@@ -8,7 +8,6 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
-#include <linux/kobject.h>
 #include <linux/netdevice.h>
 #include <linux/types.h>
 #include <linux/slab.h>
@@ -19,7 +18,8 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "sta_info.h"
-
+#include "key_sysfs.h"
+#include "debugfs_sta.h"
 
 /* Caller must hold local->sta_lock */
 static void sta_info_hash_add(struct ieee80211_local *local,
@@ -53,12 +53,12 @@ static void sta_info_hash_del(struct iee
 		       "hash table\n", local->mdev->name, MAC_ARG(sta->addr));
 }
 
-static inline struct sta_info *__sta_info_get(struct sta_info *sta)
+static inline void __sta_info_get(struct sta_info *sta)
 {
-	return kobject_get(&sta->kobj) ? sta : NULL;
+	kref_get(&sta->kref);
 }
 
-struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr)
+struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
 {
 	struct sta_info *sta;
 
@@ -102,15 +102,9 @@ int sta_info_min_txrate_get(struct ieee8
 }
 
 
-void sta_info_put(struct sta_info *sta)
+void sta_info_release(struct kref *kref)
 {
-	kobject_put(&sta->kobj);
-}
-EXPORT_SYMBOL(sta_info_put);
-
-void sta_info_release(struct kobject *kobj)
-{
-	struct sta_info *sta = container_of(kobj, struct sta_info, kobj);
+	struct sta_info *sta = container_of(kref, struct sta_info, kref);
 	struct ieee80211_local *local = sta->local;
 	struct sk_buff *skb;
 
@@ -131,6 +125,13 @@ void sta_info_release(struct kobject *ko
 }
 
 
+void sta_info_put(struct sta_info *sta)
+{
+	kref_put(&sta->kref, sta_info_release);
+}
+EXPORT_SYMBOL(sta_info_put);
+
+
 struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp)
 {
@@ -140,18 +141,13 @@ struct sta_info * sta_info_add(struct ie
 	if (!sta)
 		return NULL;
 
-	if (kobject_set_name(&sta->kobj, MAC_FMT, MAC_ARG(addr))) {
-		kfree(sta);
-		return NULL;
-	}
-	sta->kobj.kset = &local->sta_kset;
-	kobject_init(&sta->kobj);
+	kref_init(&sta->kref);
 
 	sta->rate_ctrl = rate_control_get(local->rate_ctrl);
 	sta->rate_ctrl_priv = rate_control_alloc_sta(sta->rate_ctrl, gfp);
 	if (!sta->rate_ctrl_priv) {
 		rate_control_put(sta->rate_ctrl);
-		kobject_put(&sta->kobj);
+		kref_put(&sta->kref, sta_info_release);
 		kfree(sta);
 		return NULL;
 	}
@@ -180,8 +176,8 @@ struct sta_info * sta_info_add(struct ie
 
 	if (!in_interrupt()) {
 		sta->sysfs_registered = 1;
-		ieee80211_sta_sysfs_add(sta);
-		rate_control_add_sta_attrs(sta, &sta->kobj);
+		ieee80211_sta_debugfs_add(sta);
+		rate_control_add_sta_debugfs(sta);
 	} else {
 		/* procfs entry adding might sleep, so schedule process context
 		 * task for adding proc entry for STAs that do not yet have
@@ -206,8 +202,8 @@ static void finish_sta_info_free(struct 
 		sta->key = NULL;
 	}
 
-	rate_control_remove_sta_attrs(sta, &sta->kobj);
-	ieee80211_sta_sysfs_remove(sta);
+	rate_control_remove_sta_debugfs(sta);
+	ieee80211_sta_debugfs_remove(sta);
 
 	sta_info_put(sta);
 }
@@ -380,8 +376,8 @@ static void sta_info_proc_add_task(struc
 			break;
 
 		sta->sysfs_registered = 1;
-		ieee80211_sta_sysfs_add(sta);
-		rate_control_add_sta_attrs(sta, &sta->kobj);
+		ieee80211_sta_debugfs_add(sta);
+		rate_control_add_sta_debugfs(sta);
 		sta_info_put(sta);
 	}
 }
@@ -403,11 +399,6 @@ void sta_info_init(struct ieee80211_loca
 
 int sta_info_start(struct ieee80211_local *local)
 {
-	int res;
-
-	res = ieee80211_sta_kset_sysfs_register(local);
-	if (res)
-		return res;
 	add_timer(&local->sta_cleanup);
 	return 0;
 }
@@ -425,10 +416,8 @@ void sta_info_stop(struct ieee80211_loca
 		 * point. */
 		sta_info_free(sta, 0);
 	}
-	ieee80211_sta_kset_sysfs_unregister(local);
 }
 
-
 void sta_info_remove_aid_ptr(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata;
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/key_sysfs.c	2007-03-07 13:03:56.064710923 +0100
@@ -0,0 +1,217 @@
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
+
+/* keys attributtes */
+
+struct key_attribute {
+	struct attribute attr;
+	ssize_t (*show)(const struct ieee80211_key *, char *buf);
+	ssize_t (*store)(struct ieee80211_key *, const char *buf,
+			 size_t count);
+};
+
+#define KEY_SHOW(name, field, format_string)				\
+static ssize_t show_key_##name(const struct ieee80211_key *key, char *buf)\
+{									\
+	return sprintf(buf, format_string, key->field);			\
+}
+#define KEY_SHOW_D(name, field) KEY_SHOW(name, field, "%d\n")
+
+#define __KEY_ATTR(name)						\
+static struct key_attribute key_attr_##name =				\
+	__ATTR(name, S_IRUSR, show_key_##name, NULL)
+
+#define KEY_ATTR(name, field, format)					\
+		KEY_SHOW_##format(name, field)				\
+		__KEY_ATTR(name)
+
+KEY_ATTR(length, keylen, D);
+KEY_ATTR(sw_encrypt, force_sw_encrypt, D);
+KEY_ATTR(index, keyidx, D);
+KEY_ATTR(hw_index, hw_key_idx, D);
+KEY_ATTR(tx_rx_count, tx_rx_count, D);
+
+static ssize_t show_key_algorithm(const struct ieee80211_key *key, char *buf)
+{
+	char *alg;
+
+	switch (key->alg) {
+	case ALG_WEP:
+		alg = "WEP";
+		break;
+	case ALG_TKIP:
+		alg = "TKIP";
+		break;
+	case ALG_CCMP:
+		alg = "CCMP";
+		break;
+	default:
+		return 0;
+	}
+	return sprintf(buf, "%s\n", alg);
+}
+__KEY_ATTR(algorithm);
+
+static ssize_t show_key_tx_spec(const struct ieee80211_key *key, char *buf)
+{
+	const u8 *tpn;
+
+	switch (key->alg) {
+	case ALG_WEP:
+		return sprintf(buf, "\n");
+	case ALG_TKIP:
+		return sprintf(buf, "%08x %04x\n", key->u.tkip.iv32,
+			       key->u.tkip.iv16);
+	case ALG_CCMP:
+		tpn = key->u.ccmp.tx_pn;
+		return sprintf(buf, "%02x%02x%02x%02x%02x%02x\n", tpn[0],
+			       tpn[1], tpn[2], tpn[3], tpn[4], tpn[5]);
+	default:
+		return 0;
+	}
+}
+__KEY_ATTR(tx_spec);
+
+static ssize_t show_key_rx_spec(const struct ieee80211_key *key, char *buf)
+{
+	int i;
+	const u8 *rpn;
+	char *p = buf;
+
+	switch (key->alg) {
+	case ALG_WEP:
+		return sprintf(buf, "\n");
+	case ALG_TKIP:
+		for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+			p += sprintf(p, "%08x %04x\n",
+				     key->u.tkip.iv32_rx[i],
+				     key->u.tkip.iv16_rx[i]);
+		return (p - buf);
+	case ALG_CCMP:
+		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
+			rpn = key->u.ccmp.rx_pn[i];
+			p += sprintf(p, "%02x%02x%02x%02x%02x%02x\n", rpn[0],
+				     rpn[1], rpn[2], rpn[3], rpn[4], rpn[5]);
+		}
+		return (p - buf);
+	default:
+		return 0;
+	}
+}
+__KEY_ATTR(rx_spec);
+
+static ssize_t show_key_replays(const struct ieee80211_key *key, char *buf)
+{
+	if (key->alg != ALG_CCMP)
+		return 0;
+	return sprintf(buf, "%u\n", key->u.ccmp.replays);
+}
+__KEY_ATTR(replays);
+
+static ssize_t show_key_key(const struct ieee80211_key *key, char *buf)
+{
+	int i;
+	char *p = buf;
+
+	for (i = 0; i < key->keylen; i++)
+		p += sprintf(p, "%02x", key->key[i]);
+	p += sprintf(p, "\n");
+	return (p - buf);
+}
+__KEY_ATTR(key);
+
+static struct attribute *key_ktype_attrs[] = {
+	&key_attr_length.attr,
+	&key_attr_sw_encrypt.attr,
+	&key_attr_index.attr,
+	&key_attr_hw_index.attr,
+	&key_attr_tx_rx_count.attr,
+	&key_attr_algorithm.attr,
+	&key_attr_tx_spec.attr,
+	&key_attr_rx_spec.attr,
+	&key_attr_replays.attr,
+	&key_attr_key.attr,
+	NULL
+};
+
+/* structures and functions */
+
+static ssize_t key_sysfs_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct key_attribute *key_attr;
+	struct ieee80211_key *key;
+
+	key_attr = container_of(attr, struct key_attribute, attr);
+	key = container_of(kobj, struct ieee80211_key, kobj);
+	return key_attr->show(key, buf);
+}
+
+static struct sysfs_ops key_ktype_ops = {
+	.show = key_sysfs_show,
+};
+
+static struct kobj_type key_ktype = {
+	.release = ieee80211_key_release,
+	.sysfs_ops = &key_ktype_ops,
+	.default_attrs = key_ktype_attrs,
+};
+
+int ieee80211_key_kset_sysfs_register(struct ieee80211_sub_if_data *sdata)
+{
+	int res;
+
+	res = kobject_set_name(&sdata->key_kset.kobj, "keys");
+	if (res)
+		return res;
+	sdata->key_kset.kobj.parent = &sdata->dev->dev.kobj;
+	sdata->key_kset.ktype = &key_ktype;
+	return kset_register(&sdata->key_kset);
+}
+
+void ieee80211_key_kset_sysfs_unregister(struct ieee80211_sub_if_data *sdata)
+{
+	kset_unregister(&sdata->key_kset);
+}
+
+void ieee80211_key_sysfs_set_kset(struct ieee80211_key *key, struct kset *kset)
+{
+	key->kobj.kset = kset;
+	if (!kset)
+		key->kobj.ktype = &key_ktype;
+}
+
+int ieee80211_key_sysfs_add(struct ieee80211_key *key)
+{
+	return kobject_add(&key->kobj);
+}
+
+void ieee80211_key_sysfs_remove(struct ieee80211_key *key)
+{
+	if (key)
+		kobject_del(&key->kobj);
+}
+
+int ieee80211_key_sysfs_add_default(struct ieee80211_sub_if_data *sdata)
+{
+	return sysfs_create_link(&sdata->key_kset.kobj,
+				 &sdata->default_key->kobj, "default");
+}
+
+void ieee80211_key_sysfs_remove_default(struct ieee80211_sub_if_data *sdata)
+{
+	if (sdata->default_key)
+		sysfs_remove_link(&sdata->key_kset.kobj, "default");
+}
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-07 13:03:54.934710923 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-07 13:03:56.064710923 +0100
@@ -35,6 +35,7 @@
 #include "ieee80211_cfg.h"
 #include "ieee80211_sysfs.h"
 #include "debugfs.h"
+#include "key_sysfs.h"
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-03-07 13:03:50.454710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-03-07 13:03:56.074710923 +0100
@@ -25,7 +25,7 @@
 #include "ieee80211_rate.h"
 #include "wpa.h"
 #include "aes_ccm.h"
-
+#include "key_sysfs.h"
 
 static int ieee80211_regdom = 0x10; /* FCC */
 module_param(ieee80211_regdom, int, 0444);
@@ -687,8 +687,6 @@ static int ieee80211_set_encryption(stru
 		else
 			sdata->keys[idx] = key;
 		ieee80211_key_free(old_key);
-		if (sta)
-			key->kobj.parent = &sta->kobj;
 		ret = ieee80211_key_sysfs_add(key);
 		if (ret)
 			goto err_null;
--- wireless-dev.orig/net/mac80211/ieee80211_sysfs.c	2007-03-07 13:03:54.944710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_sysfs.c	2007-03-07 13:03:56.074710923 +0100
@@ -17,6 +17,7 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "ieee80211_sysfs.h"
+#include "key_sysfs.h"
 
 static inline struct ieee80211_local *to_ieee80211_local(struct device *dev)
 {
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/key_sysfs.h	2007-03-07 13:03:56.074710923 +0100
@@ -0,0 +1,12 @@
+#ifndef __MAC80211_KEY_SYSFS_H
+#define __MAC80211_KEY_SYSFS_H
+
+int ieee80211_key_kset_sysfs_register(struct ieee80211_sub_if_data *sdata);
+void ieee80211_key_kset_sysfs_unregister(struct ieee80211_sub_if_data *sdata);
+void ieee80211_key_sysfs_set_kset(struct ieee80211_key *key, struct kset *kset);
+int ieee80211_key_sysfs_add(struct ieee80211_key *key);
+void ieee80211_key_sysfs_remove(struct ieee80211_key *key);
+int ieee80211_key_sysfs_add_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_key_sysfs_remove_default(struct ieee80211_sub_if_data *sdata);
+
+#endif /* __MAC80211_KEY_SYSFS_H */
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-03-07 13:02:30.814710923 +0100
+++ wireless-dev/net/mac80211/sta_info.h	2007-03-07 13:03:56.074710923 +0100
@@ -12,6 +12,7 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/if_ether.h>
+#include <linux/kref.h>
 #include "ieee80211_key.h"
 
 /* Stations flags (struct sta_info::flags) */
@@ -30,8 +31,8 @@
 
 
 struct sta_info {
+	struct kref kref;
 	struct list_head list;
-	struct kobject kobj;
 	struct sta_info *hnext; /* next entry in hash table list */
 
 	struct ieee80211_local *local;
@@ -113,6 +114,20 @@ struct sta_info {
 	int vlan_id;
 
 	u16 listen_interval;
+
+#ifdef CONFIG_DEBUG_FS
+	struct sta_info_debugfsdentries {
+		struct dentry *dir;
+		struct dentry *flags;
+		struct dentry *num_ps_buf_frames;
+		struct dentry *last_ack_rssi;
+		struct dentry *last_ack_ms;
+		struct dentry *inactive_ms;
+		struct dentry *last_seq_ctrl;
+		struct dentry *wme_rx_queue;
+		struct dentry *wme_tx_queue;
+	} debugfs;
+#endif
 };
 
 
@@ -140,7 +155,6 @@ void sta_info_put(struct sta_info *sta);
 struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp);
 void sta_info_free(struct sta_info *sta, int locked);
-void sta_info_release(struct kobject *kobj);
 void sta_info_init(struct ieee80211_local *local);
 int sta_info_start(struct ieee80211_local *local);
 void sta_info_stop(struct ieee80211_local *local);
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs_sta.c	2007-03-07 13:03:56.074710923 +0100
@@ -0,0 +1,242 @@
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
+#include <linux/debugfs.h>
+#include <linux/ieee80211.h>
+#include "ieee80211_i.h"
+#include "debugfs.h"
+#include "debugfs_sta.h"
+#include "sta_info.h"
+
+/* sta attributtes */
+
+#define STA_READ(name, buflen, field, format_string)			\
+static ssize_t sta_ ##name## _read(struct file *file,			\
+				   char __user *userbuf,		\
+				   size_t count, loff_t *ppos)		\
+{									\
+	int res;							\
+	struct sta_info *sta = file->private_data;			\
+	char buf[buflen];						\
+	res = scnprintf(buf, buflen, format_string, sta->field);	\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}
+#define STA_READ_D(name, field) STA_READ(name, 20, field, "%d\n")
+#define STA_READ_U(name, field) STA_READ(name, 20, field, "%u\n")
+#define STA_READ_LU(name, field) STA_READ(name, 20, field, "%lu\n")
+#define STA_READ_S(name, field) STA_READ(name, 20, field, "%s\n")
+
+#define STA_READ_RATE(name, field)					\
+static ssize_t sta_##name##_read(struct file *file,			\
+				 char __user *userbuf,			\
+				 size_t count, loff_t *ppos)		\
+{									\
+	struct sta_info *sta = file->private_data;			\
+	struct ieee80211_local *local = wdev_priv(sta->dev->ieee80211_ptr);\
+	struct ieee80211_hw_mode *mode = local->oper_hw_mode;		\
+	char buf[20];							\
+	int res = scnprintf(buf, sizeof(buf), "%d\n",			\
+			    (sta->field >= 0 &&				\
+			    sta->field < mode->num_rates) ?		\
+			    mode->rates[sta->field].rate : -1);		\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}
+
+#define STA_OPS(name)							\
+static const struct file_operations sta_ ##name## _ops = {		\
+	.read = sta_##name##_read,					\
+	.open = mac80211_open_file_generic,				\
+}
+
+#define STA_FILE(name, field, format)					\
+		STA_READ_##format(name, field)				\
+		STA_OPS(name)
+
+STA_FILE(aid, aid, D);
+STA_FILE(key_idx_compression, key_idx_compression, D);
+STA_FILE(dev, dev->name, S);
+STA_FILE(vlan_id, vlan_id, D);
+STA_FILE(rx_packets, rx_packets, LU);
+STA_FILE(tx_packets, tx_packets, LU);
+STA_FILE(rx_bytes, rx_bytes, LU);
+STA_FILE(tx_bytes, tx_bytes, LU);
+STA_FILE(rx_duplicates, num_duplicates, LU);
+STA_FILE(rx_fragments, rx_fragments, LU);
+STA_FILE(rx_dropped, rx_dropped, LU);
+STA_FILE(tx_fragments, tx_fragments, LU);
+STA_FILE(tx_filtered, tx_filtered_count, LU);
+STA_FILE(txrate, txrate, RATE);
+STA_FILE(last_txrate, last_txrate, RATE);
+STA_FILE(tx_retry_failed, tx_retry_failed, LU);
+STA_FILE(tx_retry_count, tx_retry_count, LU);
+STA_FILE(last_rssi, last_rssi, D);
+STA_FILE(last_signal, last_signal, D);
+STA_FILE(last_noise, last_noise, D);
+STA_FILE(channel_use, channel_use, D);
+STA_FILE(wep_weak_iv_count, wep_weak_iv_count, D);
+
+static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
+			      size_t count, loff_t *ppos)
+{
+	char buf[100];
+	struct sta_info *sta = file->private_data;
+	int res = scnprintf(buf, sizeof(buf), "%s%s%s%s%s%s%s%s%s",
+		sta->flags & WLAN_STA_AUTH ? "AUTH\n" : "",
+		sta->flags & WLAN_STA_ASSOC ? "ASSOC\n" : "",
+		sta->flags & WLAN_STA_PS ? "PS\n" : "",
+		sta->flags & WLAN_STA_TIM ? "TIM\n" : "",
+		sta->flags & WLAN_STA_PERM ? "PERM\n" : "",
+		sta->flags & WLAN_STA_AUTHORIZED ? "AUTHORIZED\n" : "",
+		sta->flags & WLAN_STA_SHORT_PREAMBLE ? "SHORT PREAMBLE\n" : "",
+		sta->flags & WLAN_STA_WME ? "WME\n" : "",
+		sta->flags & WLAN_STA_WDS ? "WDS\n" : "");
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+STA_OPS(flags);
+
+static ssize_t sta_num_ps_buf_frames_read(struct file *file,
+					  char __user *userbuf,
+					  size_t count, loff_t *ppos)
+{
+	char buf[20];
+	struct sta_info *sta = file->private_data;
+	int res = scnprintf(buf, sizeof(buf), "%u\n",
+			    skb_queue_len(&sta->ps_tx_buf));
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+STA_OPS(num_ps_buf_frames);
+
+static ssize_t sta_last_ack_rssi_read(struct file *file, char __user *userbuf,
+				      size_t count, loff_t *ppos)
+{
+	char buf[100];
+	struct sta_info *sta = file->private_data;
+	int res = scnprintf(buf, sizeof(buf), "%d %d %d\n",
+			    sta->last_ack_rssi[0],
+			    sta->last_ack_rssi[1],
+			    sta->last_ack_rssi[2]);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+STA_OPS(last_ack_rssi);
+
+static ssize_t sta_last_ack_ms_read(struct file *file, char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	char buf[20];
+	struct sta_info *sta = file->private_data;
+	int res = scnprintf(buf, sizeof(buf), "%d\n",
+			    sta->last_ack ?
+			    jiffies_to_msecs(jiffies - sta->last_ack) : -1);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+STA_OPS(last_ack_ms);
+
+static ssize_t sta_inactive_ms_read(struct file *file, char __user *userbuf,
+				    size_t count, loff_t *ppos)
+{
+	char buf[20];
+	struct sta_info *sta = file->private_data;
+	int res = scnprintf(buf, sizeof(buf), "%d\n",
+			    jiffies_to_msecs(jiffies - sta->last_rx));
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+STA_OPS(inactive_ms);
+
+static ssize_t sta_last_seq_ctrl_read(struct file *file, char __user *userbuf,
+				      size_t count, loff_t *ppos)
+{
+	char buf[15*NUM_RX_DATA_QUEUES], *p = buf;
+	int i;
+	struct sta_info *sta = file->private_data;
+	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%x ",
+			       sta->last_seq_ctrl[i]);
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(last_seq_ctrl);
+
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+static ssize_t sta_wme_rx_queue_read(struct file *file, char __user *userbuf,
+				     size_t count, loff_t *ppos)
+{
+	char buf[15*NUM_RX_DATA_QUEUES], *p = buf;
+	int i;
+	struct sta_info *sta = file->private_data;
+	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
+			       sta->wme_rx_queue[i]);
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(wme_rx_queue);
+
+static ssize_t sta_wme_tx_queue_read(struct file *file, char __user *userbuf,
+				     size_t count, loff_t *ppos)
+{
+	char buf[15*NUM_TX_DATA_QUEUES], *p = buf;
+	int i;
+	struct sta_info *sta = file->private_data;
+	for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p, "%u ",
+			       sta->wme_tx_queue[i]);
+	p += scnprintf(p, sizeof(buf)+buf-p, "\n");
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p - buf);
+}
+STA_OPS(wme_tx_queue);
+#endif
+
+#define DEBUGFS_ADD(name) \
+	sta->debugfs.name = debugfs_create_file(#name, 0444, \
+		sta->debugfs.dir, sta, &sta_ ##name## _ops);
+
+#define DEBUGFS_DEL(name) \
+	debugfs_remove(sta->debugfs.name);\
+	sta->debugfs.name = NULL;
+
+
+void ieee80211_sta_debugfs_add(struct sta_info *sta)
+{
+	char buf[3*6];
+	struct dentry *stations_dir = sta->local->debugfs.stations;
+
+	if (!stations_dir)
+		return;
+
+	sprintf(buf, MAC_FMT, MAC_ARG(sta->addr));
+
+	sta->debugfs.dir = debugfs_create_dir(buf, stations_dir);
+	if (!sta->debugfs.dir)
+		return;
+
+	DEBUGFS_ADD(flags);
+	DEBUGFS_ADD(num_ps_buf_frames);
+	DEBUGFS_ADD(last_ack_rssi);
+	DEBUGFS_ADD(last_ack_ms);
+	DEBUGFS_ADD(inactive_ms);
+	DEBUGFS_ADD(last_seq_ctrl);
+	DEBUGFS_ADD(wme_rx_queue);
+	DEBUGFS_ADD(wme_tx_queue);
+}
+
+void ieee80211_sta_debugfs_remove(struct sta_info *sta)
+{
+	DEBUGFS_DEL(flags);
+	DEBUGFS_DEL(num_ps_buf_frames);
+	DEBUGFS_DEL(last_ack_rssi);
+	DEBUGFS_DEL(last_ack_ms);
+	DEBUGFS_DEL(inactive_ms);
+	DEBUGFS_DEL(last_seq_ctrl);
+	DEBUGFS_DEL(wme_rx_queue);
+	DEBUGFS_DEL(wme_tx_queue);
+
+	debugfs_remove(sta->debugfs.dir);
+	sta->debugfs.dir = NULL;
+}
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs_sta.h	2007-03-07 13:03:56.074710923 +0100
@@ -0,0 +1,12 @@
+#ifndef __MAC80211_DEBUGFS_STA_H
+#define __MAC80211_DEBUGFS_STA_H
+
+#ifdef CONFIG_DEBUG_FS
+void ieee80211_sta_debugfs_add(struct sta_info *sta);
+void ieee80211_sta_debugfs_remove(struct sta_info *sta);
+#else
+static inline void ieee80211_sta_debugfs_add(struct sta_info *sta) {}
+static inline void ieee80211_sta_debugfs_remove(struct sta_info *sta) {}
+#endif
+
+#endif /* __MAC80211_DEBUGFS_STA_H */
--- wireless-dev.orig/net/mac80211/ieee80211_rate.h	2007-03-07 13:03:54.934710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_rate.h	2007-03-07 13:03:56.084710923 +0100
@@ -56,10 +56,9 @@ struct rate_control_ops {
 
 	int (*add_attrs)(void *priv, struct kobject *kobj);
 	void (*remove_attrs)(void *priv, struct kobject *kobj);
-	int (*add_sta_attrs)(void *priv, void *priv_sta,
-			     struct kobject *kobj);
-	void (*remove_sta_attrs)(void *priv, void *priv_sta,
-				 struct kobject *kobj);
+	void (*add_sta_debugfs)(void *priv, void *priv_sta,
+				struct dentry *dir);
+	void (*remove_sta_debugfs)(void *priv, void *priv_sta);
 };
 
 struct rate_control_ref {
@@ -123,23 +122,23 @@ static inline void rate_control_free_sta
 	ref->ops->free_sta(ref->priv, priv);
 }
 
-static inline int rate_control_add_sta_attrs(struct sta_info *sta,
-					     struct kobject *kobj)
+static inline void rate_control_add_sta_debugfs(struct sta_info *sta)
 {
+#ifdef CONFIG_DEBUG_FS
 	struct rate_control_ref *ref = sta->rate_ctrl;
-	if (ref->ops->add_sta_attrs)
-		return ref->ops->add_sta_attrs(ref->priv, sta->rate_ctrl_priv,
-					       kobj);
-	return 0;
+	if (sta->debugfs.dir && ref->ops->add_sta_debugfs)
+		ref->ops->add_sta_debugfs(ref->priv, sta->rate_ctrl_priv,
+					  sta->debugfs.dir);
+#endif
 }
 
-static inline void rate_control_remove_sta_attrs(struct sta_info *sta,
-						 struct kobject *kobj)
+static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 {
+#ifdef CONFIG_DEBUG_FS
 	struct rate_control_ref *ref = sta->rate_ctrl;
-	if (ref->ops->remove_sta_attrs)
-		ref->ops->remove_sta_attrs(ref->priv, sta->rate_ctrl_priv,
-					   kobj);
+	if (ref->ops->remove_sta_debugfs)
+		ref->ops->remove_sta_debugfs(ref->priv, sta->rate_ctrl_priv);
+#endif
 }
 
 #endif /* IEEE80211_RATE_H */
--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-03-07 13:03:50.464710923 +0100
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-03-07 13:03:56.084710923 +0100
@@ -18,6 +18,7 @@
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#include "debugfs.h"
 
 
 /* This is a minimal implementation of TX rate controlling that can be used
@@ -121,6 +122,11 @@ struct sta_rate_control {
 	unsigned long avg_rate_update;
 	u32 tx_avg_rate_sum;
 	u32 tx_avg_rate_num;
+
+#ifdef CONFIG_DEBUG_FS
+	struct dentry *tx_avg_rate_sum_dentry;
+	struct dentry *tx_avg_rate_num_dentry;
+#endif
 };
 
 
@@ -327,47 +333,67 @@ static void rate_control_simple_free_sta
 	kfree(rctrl);
 }
 
-static ssize_t show_sta_tx_avg_rate_sum(const struct sta_info *sta, char *buf)
-{
-	struct sta_rate_control *srctrl = sta->rate_ctrl_priv;
+#ifdef CONFIG_DEBUG_FS
 
-	return sprintf(buf, "%d\n", srctrl->tx_avg_rate_sum);
+static int open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
 }
 
-static ssize_t show_sta_tx_avg_rate_num(const struct sta_info *sta, char *buf)
+static ssize_t sta_tx_avg_rate_sum_read(struct file *file,
+					char __user *userbuf,
+					size_t count, loff_t *ppos)
 {
-	struct sta_rate_control *srctrl = sta->rate_ctrl_priv;
+	struct sta_rate_control *srctrl = file->private_data;
+	char buf[20];
 
-	return sprintf(buf, "%d\n", srctrl->tx_avg_rate_num);
+	sprintf(buf, "%d\n", srctrl->tx_avg_rate_sum);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
 }
 
-static struct sta_attribute sta_attr_tx_avg_rate_sum =
-	__ATTR(tx_avg_rate_sum, S_IRUSR, show_sta_tx_avg_rate_sum, NULL);
-static struct sta_attribute sta_attr_tx_avg_rate_num =
-	__ATTR(tx_avg_rate_num, S_IRUSR, show_sta_tx_avg_rate_num, NULL);
-
-static struct attribute *rate_control_simple_sta_attrs[] = {
-	&sta_attr_tx_avg_rate_sum.attr,
-	&sta_attr_tx_avg_rate_num.attr,
-	NULL,
+static const struct file_operations sta_tx_avg_rate_sum_ops = {
+	.read = sta_tx_avg_rate_sum_read,
+	.open = open_file_generic,
 };
 
-static struct attribute_group rate_control_simple_sta_group = {
-	.name = "rate_control_simple",
-	.attrs = rate_control_simple_sta_attrs,
+static ssize_t sta_tx_avg_rate_num_read(struct file *file,
+					char __user *userbuf,
+					size_t count, loff_t *ppos)
+{
+	struct sta_rate_control *srctrl = file->private_data;
+	char buf[20];
+
+	sprintf(buf, "%d\n", srctrl->tx_avg_rate_num);
+	return simple_read_from_buffer(userbuf, count, ppos, buf, strlen(buf));
+}
+
+static const struct file_operations sta_tx_avg_rate_num_ops = {
+	.read = sta_tx_avg_rate_num_read,
+	.open = open_file_generic,
 };
 
-static int rate_control_simple_add_sta_attrs(void *priv, void *priv_sta,
-					     struct kobject *kobj)
+static void rate_control_simple_add_sta_debugfs(void *priv, void *priv_sta,
+						struct dentry *dir)
 {
-	return sysfs_create_group(kobj, &rate_control_simple_sta_group);
+	struct sta_rate_control *srctrl = priv_sta;
+
+	srctrl->tx_avg_rate_num_dentry =
+		debugfs_create_file("rc_simple_sta_tx_avg_rate_num", 0400,
+				    dir, srctrl, &sta_tx_avg_rate_num_ops);
+	srctrl->tx_avg_rate_sum_dentry =
+		debugfs_create_file("rc_simple_sta_tx_avg_rate_sum", 0400,
+				    dir, srctrl, &sta_tx_avg_rate_sum_ops);
 }
 
-static void rate_control_simple_remove_sta_attrs(void *priv, void *priv_sta,
-						 struct kobject *kobj)
+static void rate_control_simple_remove_sta_debugfs(void *priv, void *priv_sta)
 {
-	sysfs_remove_group(kobj, &rate_control_simple_sta_group);
+	struct sta_rate_control *srctrl = priv_sta;
+
+	debugfs_remove(srctrl->tx_avg_rate_sum_dentry);
+	debugfs_remove(srctrl->tx_avg_rate_num_dentry);
 }
+#endif
 
 static struct rate_control_ops rate_control_simple = {
 	.module = THIS_MODULE,
@@ -380,8 +406,10 @@ static struct rate_control_ops rate_cont
 	.free = rate_control_simple_free,
 	.alloc_sta = rate_control_simple_alloc_sta,
 	.free_sta = rate_control_simple_free_sta,
-	.add_sta_attrs = rate_control_simple_add_sta_attrs,
-	.remove_sta_attrs = rate_control_simple_remove_sta_attrs,
+#ifdef CONFIG_DEBUG_FS
+	.add_sta_debugfs = rate_control_simple_add_sta_debugfs,
+	.remove_sta_debugfs = rate_control_simple_remove_sta_debugfs,
+#endif
 };
 
 

--

