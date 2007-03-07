Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965555AbXCGQvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 11:51:48 -0500
Message-Id: <20070307164645.982271000@sipsolutions.net>
References: <20070307164531.910923000@sipsolutions.net>
Date: Wed, 07 Mar 2007 17:45:32 +0100
From: johannes@sipsolutions.net
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH (v3) 1/4] mac80211: move PHY things to debugfs
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch moves everything except the "sta" and "key" directories
from the phy sysfs to phy debugfs. Since the current rate control
algorithm isn't using any global sysfs entries it also removes the
ability for a rate control algorithm to do so. That can be re-added
to debugfs when necessary.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/Makefile          |    1 
 net/mac80211/debugfs.c         |  429 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/debugfs.h         |   15 +
 net/mac80211/ieee80211.c       |   20 -
 net/mac80211/ieee80211_i.h     |   62 +++++
 net/mac80211/ieee80211_rate.h  |   15 -
 net/mac80211/ieee80211_sysfs.c |  375 -----------------------------------
 net/mac80211/ieee80211_sysfs.h |    2 
 8 files changed, 511 insertions(+), 408 deletions(-)

--- wireless-dev.orig/net/mac80211/Makefile	2007-03-07 13:02:31.334710923 +0100
+++ wireless-dev/net/mac80211/Makefile	2007-03-07 13:03:54.934710923 +0100
@@ -1,6 +1,7 @@
 obj-$(CONFIG_MAC80211) += mac80211.o rc80211_simple.o
 
 mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
+mac80211-objs-$(CONFIG_DEBUG_FS) += debugfs.o
 
 mac80211-objs := \
 	ieee80211.o \
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-03-07 13:03:53.334710923 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-03-07 13:03:54.934710923 +0100
@@ -34,6 +34,7 @@
 #include "ieee80211_led.h"
 #include "ieee80211_cfg.h"
 #include "ieee80211_sysfs.h"
+#include "debugfs.h"
 
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
@@ -4444,7 +4445,6 @@ int ieee80211_init_rate_ctrl_alg(struct 
 				 const char *name)
 {
 	struct rate_control_ref *ref, *old;
-	int res;
 
 	ASSERT_RTNL();
 	if (local->open_count || netif_running(local->mdev) ||
@@ -4457,18 +4457,10 @@ int ieee80211_init_rate_ctrl_alg(struct 
 		       "algorithm\n", local->mdev->name);
 		return -ENOENT;
 	}
-	res = rate_control_add_attrs(ref, &local->hw.wiphy->dev.kobj);
-	if (res < 0) {
-		printk(KERN_DEBUG "%s: Failed to register sysfs attributes "
-		       "for rate control\n", local->mdev->name);
-		rate_control_put(ref);
-		return res;
-	}
 
 	old = local->rate_ctrl;
 	local->rate_ctrl = ref;
 	if (old) {
-		rate_control_remove_attrs(ref, &local->hw.wiphy->dev.kobj);
 		rate_control_put(old);
 		sta_info_flush(local, NULL);
 	}
@@ -4487,7 +4479,6 @@ static void rate_control_deinitialize(st
 
 	ref = local->rate_ctrl;
 	local->rate_ctrl = NULL;
-	rate_control_remove_attrs(ref, &local->hw.wiphy->dev.kobj);
 	rate_control_put(ref);
 }
 
@@ -4622,9 +4613,7 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		return result;
 
-	result = ieee80211_dev_sysfs_add(local);
-	if (result < 0)
-		goto fail_sysfs;
+	debugfs_hw_add(local);
 
 	local->hw.conf.beacon_int = 1000;
 
@@ -4703,8 +4692,7 @@ fail_if_sysfs:
 fail_dev:
 	sta_info_stop(local);
 fail_sta_info:
-	ieee80211_dev_sysfs_del(local);
-fail_sysfs:
+	debugfs_hw_del(local);
 	wiphy_unregister(local->hw.wiphy);
 	return result;
 }
@@ -4777,7 +4765,7 @@ void ieee80211_unregister_hw(struct ieee
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
-	ieee80211_dev_sysfs_del(local);
+	debugfs_hw_del(local);
 
 	for (i = 0; i < NUM_IEEE80211_MODES; i++) {
 		kfree(local->supp_rates[i]);
--- wireless-dev.orig/net/mac80211/ieee80211_rate.h	2007-03-07 13:03:50.454710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_rate.h	2007-03-07 13:03:54.934710923 +0100
@@ -123,21 +123,6 @@ static inline void rate_control_free_sta
 	ref->ops->free_sta(ref->priv, priv);
 }
 
-static inline int rate_control_add_attrs(struct rate_control_ref *ref,
-					 struct kobject *kobj)
-{
-	if (ref->ops->add_attrs)
-		return ref->ops->add_attrs(ref->priv, kobj);
-	return 0;
-}
-
-static inline void rate_control_remove_attrs(struct rate_control_ref *ref,
-					     struct kobject *kobj)
-{
-	if (ref->ops->remove_attrs)
-		ref->ops->remove_attrs(ref->priv, kobj);
-}
-
 static inline int rate_control_add_sta_attrs(struct sta_info *sta,
 					     struct kobject *kobj)
 {
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs.h	2007-03-07 13:03:54.934710923 +0100
@@ -0,0 +1,15 @@
+#ifndef __MAC80211_DEBUGFS_H
+#define __MAC80211_DEBUGFS_H
+
+#ifdef CONFIG_DEBUG_FS
+extern void debugfs_hw_add(struct ieee80211_local *local);
+extern void debugfs_hw_del(struct ieee80211_local *local);
+#else
+static inline void debugfs_hw_add(struct ieee80211_local *local)
+{
+	return;
+}
+static inline void debugfs_hw_del(struct ieee80211_local *local) {}
+#endif
+
+#endif /* __MAC80211_DEBUGFS_H */
--- wireless-dev.orig/net/mac80211/ieee80211_sysfs.c	2007-03-07 13:02:31.484710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_sysfs.c	2007-03-07 13:03:54.944710923 +0100
@@ -34,334 +34,6 @@ static inline int rtnl_lock_local(struct
 	return 0;
 }
 
-static const char *ieee80211_mode_str_short(int mode)
-{
-	switch (mode) {
-	case MODE_IEEE80211A:
-		return "802.11a";
-	case MODE_IEEE80211B:
-		return "802.11b";
-	case MODE_IEEE80211G:
-		return "802.11g";
-	case MODE_ATHEROS_TURBO:
-		return "AtherosTurbo";
-	default:
-		return "UNKNOWN";
-	}
-}
-
-static const char *ieee80211_mode_str(int mode)
-{
-	switch (mode) {
-	case MODE_IEEE80211A:
-		return "IEEE 802.11a";
-	case MODE_IEEE80211B:
-		return "IEEE 802.11b";
-	case MODE_IEEE80211G:
-		return "IEEE 802.11g";
-	case MODE_ATHEROS_TURBO:
-		return "Atheros Turbo (5 GHz)";
-	default:
-		return "UNKNOWN";
-	}
-}
-
-/* attributes in /sys/class/ieee80211/phyX/ */
-
-static ssize_t store_rate_ctrl_alg(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t len)
-{
-	struct ieee80211_local *local = to_ieee80211_local(dev);
-	int res;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-	res = rtnl_lock_local(local);
-	if (res)
-		return res;
-	res = ieee80211_init_rate_ctrl_alg(local, buf);
-	rtnl_unlock();
-	return res < 0 ? res : len;
-}
-
-static ssize_t ieee80211_local_show(
-	struct device *dev,
-	struct device_attribute *attr,
-	char *buf,
-	ssize_t (*format)(struct ieee80211_local *, char *))
-{
-	struct ieee80211_local *local = to_ieee80211_local(dev);
-	ssize_t ret = -EINVAL;
-
-	if (local->reg_state == IEEE80211_DEV_REGISTERED)
-		ret = (*format)(local, buf);
-	return ret;
-}
-
-#define IEEE80211_LOCAL_FMT(name, field, format_string)			\
-static ssize_t ieee80211_local_fmt_##name(struct ieee80211_local *local,\
-					  char *buf)			\
-{									\
-	return sprintf(buf, format_string, local->field);		\
-}
-
-#define __IEEE80211_LOCAL_SHOW(name)					\
-static ssize_t ieee80211_local_show_##name(struct device *dev,		\
-					   struct device_attribute *attr,\
-					   char *buf)			\
-{									\
-	return ieee80211_local_show(dev, attr, buf,			\
-				    ieee80211_local_fmt_##name);	\
-}
-
-#define IEEE80211_LOCAL_SHOW(name, field, format)			\
-		IEEE80211_LOCAL_FMT(name, field, format "\n")		\
-		__IEEE80211_LOCAL_SHOW(name)
-
-IEEE80211_LOCAL_SHOW(channel, hw.conf.channel, "%d");
-IEEE80211_LOCAL_SHOW(frequency, hw.conf.freq, "%d");
-IEEE80211_LOCAL_SHOW(radar_detect, hw.conf.radar_detect, "%d");
-IEEE80211_LOCAL_SHOW(antenna_sel_tx, hw.conf.antenna_sel_tx, "%d");
-IEEE80211_LOCAL_SHOW(antenna_sel_rx, hw.conf.antenna_sel_rx, "%d");
-IEEE80211_LOCAL_SHOW(bridge_packets, bridge_packets, "%d");
-IEEE80211_LOCAL_SHOW(key_tx_rx_threshold, key_tx_rx_threshold, "%d");
-IEEE80211_LOCAL_SHOW(rts_threshold, rts_threshold, "%d");
-IEEE80211_LOCAL_SHOW(fragmentation_threshold, fragmentation_threshold, "%d");
-IEEE80211_LOCAL_SHOW(short_retry_limit, short_retry_limit, "%d");
-IEEE80211_LOCAL_SHOW(long_retry_limit, long_retry_limit, "%d");
-IEEE80211_LOCAL_SHOW(total_ps_buffered, total_ps_buffered, "%d");
-
-static ssize_t ieee80211_local_fmt_mode(struct ieee80211_local *local,
-					char *buf)
-{
-	return sprintf(buf, "%s\n", ieee80211_mode_str(local->hw.conf.phymode));
-}
-__IEEE80211_LOCAL_SHOW(mode);
-
-static ssize_t ieee80211_local_fmt_wep_iv(struct ieee80211_local *local,
-					  char *buf)
-{
-	return sprintf(buf, "%#06x\n", local->wep_iv & 0xffffff);
-}
-__IEEE80211_LOCAL_SHOW(wep_iv);
-
-static ssize_t ieee80211_local_fmt_tx_power_reduction(struct ieee80211_local
-						      *local, char *buf)
-{
-	short tx_power_reduction = local->hw.conf.tx_power_reduction;
-
-	return sprintf(buf, "%d.%d dBm\n", tx_power_reduction / 10,
-		       tx_power_reduction % 10);
-}
-__IEEE80211_LOCAL_SHOW(tx_power_reduction);
-
-static ssize_t ieee80211_local_fmt_modes(struct ieee80211_local *local,
-					 char *buf)
-{
-	struct ieee80211_hw_mode *mode;
-	char *p = buf;
-
-	/* FIXME: Locking? Could register a mode in the meantime. */
-	list_for_each_entry(mode, &local->modes_list, list)
-		p += sprintf(p, "%s\n", ieee80211_mode_str_short(mode->mode));
-
-	return (p - buf);
-}
-__IEEE80211_LOCAL_SHOW(modes);
-
-static ssize_t ieee80211_local_fmt_rate_ctrl_alg(struct ieee80211_local *local,
-						 char *buf)
-{
-	struct rate_control_ref *ref = local->rate_ctrl;
-	if (ref)
-		return sprintf(buf, "%s\n", ref->ops->name);
-	return 0;
-}
-__IEEE80211_LOCAL_SHOW(rate_ctrl_alg);
-
-static struct device_attribute ieee80211_dev_attrs[] = {
-	__ATTR(channel, S_IRUGO, ieee80211_local_show_channel, NULL),
-	__ATTR(frequency, S_IRUGO, ieee80211_local_show_frequency, NULL),
-	__ATTR(radar_detect, S_IRUGO, ieee80211_local_show_radar_detect, NULL),
-	__ATTR(antenna_sel_tx, S_IRUGO, ieee80211_local_show_antenna_sel_tx, NULL),
-	__ATTR(antenna_sel_rx, S_IRUGO, ieee80211_local_show_antenna_sel_rx, NULL),
-	__ATTR(bridge_packets, S_IRUGO, ieee80211_local_show_bridge_packets, NULL),
-	__ATTR(key_tx_rx_threshold, S_IRUGO, ieee80211_local_show_key_tx_rx_threshold, NULL),
-	__ATTR(rts_threshold, S_IRUGO, ieee80211_local_show_rts_threshold, NULL),
-	__ATTR(fragmentation_threshold, S_IRUGO, ieee80211_local_show_fragmentation_threshold, NULL),
-	__ATTR(short_retry_limit, S_IRUGO, ieee80211_local_show_short_retry_limit, NULL),
-	__ATTR(long_retry_limit, S_IRUGO, ieee80211_local_show_long_retry_limit, NULL),
-	__ATTR(total_ps_buffered, S_IRUGO, ieee80211_local_show_total_ps_buffered, NULL),
-	__ATTR(mode, S_IRUGO, ieee80211_local_show_mode, NULL),
-	__ATTR(wep_iv, S_IRUGO, ieee80211_local_show_wep_iv, NULL),
-	__ATTR(tx_power_reduction, S_IRUGO, ieee80211_local_show_tx_power_reduction, NULL),
-	__ATTR(modes, S_IRUGO, ieee80211_local_show_modes, NULL),
-	__ATTR(rate_ctrl_alg, S_IRUGO | S_IWUGO, ieee80211_local_show_rate_ctrl_alg, store_rate_ctrl_alg),
-};
-
-/* attributes in /sys/class/ieee80211/phyX/statistics/ */
-
-#define IEEE80211_LOCAL_ATTR(name, field, format)			\
-IEEE80211_LOCAL_SHOW(name, field, format)				\
-static DEVICE_ATTR(name, S_IRUGO, ieee80211_local_show_##name, NULL);
-
-IEEE80211_LOCAL_ATTR(transmitted_fragment_count, dot11TransmittedFragmentCount, "%u");
-IEEE80211_LOCAL_ATTR(multicast_transmitted_frame_count, dot11MulticastTransmittedFrameCount, "%u");
-IEEE80211_LOCAL_ATTR(failed_count, dot11FailedCount, "%u");
-IEEE80211_LOCAL_ATTR(retry_count, dot11RetryCount, "%u");
-IEEE80211_LOCAL_ATTR(multiple_retry_count, dot11MultipleRetryCount, "%u");
-IEEE80211_LOCAL_ATTR(frame_duplicate_count, dot11FrameDuplicateCount, "%u");
-IEEE80211_LOCAL_ATTR(received_fragment_count, dot11ReceivedFragmentCount, "%u");
-IEEE80211_LOCAL_ATTR(multicast_received_frame_count, dot11MulticastReceivedFrameCount, "%u");
-IEEE80211_LOCAL_ATTR(transmitted_frame_count, dot11TransmittedFrameCount, "%u");
-IEEE80211_LOCAL_ATTR(wep_undecryptable_count, dot11WEPUndecryptableCount, "%u");
-IEEE80211_LOCAL_ATTR(num_scans, scan.num_scans, "%u");
-
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-IEEE80211_LOCAL_ATTR(tx_handlers_drop, tx_handlers_drop, "%u");
-IEEE80211_LOCAL_ATTR(tx_handlers_queued, tx_handlers_queued, "%u");
-IEEE80211_LOCAL_ATTR(tx_handlers_drop_unencrypted, tx_handlers_drop_unencrypted, "%u");
-IEEE80211_LOCAL_ATTR(tx_handlers_drop_fragment, tx_handlers_drop_fragment, "%u");
-IEEE80211_LOCAL_ATTR(tx_handlers_drop_wep, tx_handlers_drop_wep, "%u");
-IEEE80211_LOCAL_ATTR(tx_handlers_drop_not_assoc, tx_handlers_drop_not_assoc, "%u");
-IEEE80211_LOCAL_ATTR(tx_handlers_drop_unauth_port, tx_handlers_drop_unauth_port, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_drop, rx_handlers_drop, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_queued, rx_handlers_queued, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_drop_nullfunc, rx_handlers_drop_nullfunc, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_drop_defrag, rx_handlers_drop_defrag, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_drop_short, rx_handlers_drop_short, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_drop_passive_scan, rx_handlers_drop_passive_scan, "%u");
-IEEE80211_LOCAL_ATTR(tx_expand_skb_head, tx_expand_skb_head, "%u");
-IEEE80211_LOCAL_ATTR(tx_expand_skb_head_cloned, tx_expand_skb_head_cloned, "%u");
-IEEE80211_LOCAL_ATTR(rx_expand_skb_head, rx_expand_skb_head, "%u");
-IEEE80211_LOCAL_ATTR(rx_expand_skb_head2, rx_expand_skb_head2, "%u");
-IEEE80211_LOCAL_ATTR(rx_handlers_fragments, rx_handlers_fragments, "%u");
-IEEE80211_LOCAL_ATTR(tx_status_drop, tx_status_drop, "%u");
-
-static ssize_t ieee80211_local_fmt_wme_rx_queue(struct ieee80211_local *local,
-						char *buf)
-{
-	int i;
-	char *p = buf;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += sprintf(p, "%u\n", local->wme_rx_queue[i]);
-	return (p - buf);
-}
-__IEEE80211_LOCAL_SHOW(wme_rx_queue);
-static DEVICE_ATTR(wme_rx_queue, S_IRUGO,
-			 ieee80211_local_show_wme_rx_queue, NULL);
-
-static ssize_t ieee80211_local_fmt_wme_tx_queue(struct ieee80211_local *local,
-						char *buf)
-{
-	int i;
-	char *p = buf;
-
-	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
-		p += sprintf(p, "%u\n", local->wme_tx_queue[i]);
-	return (p - buf);
-}
-__IEEE80211_LOCAL_SHOW(wme_tx_queue);
-static DEVICE_ATTR(wme_tx_queue, S_IRUGO,
-			 ieee80211_local_show_wme_tx_queue, NULL);
-#endif
-
-static ssize_t ieee80211_stats_show(struct device *dev,
-		struct device_attribute *attr,
-		char *buf,
-		ssize_t (*format)(struct ieee80211_low_level_stats *, char *))
-{
-	struct ieee80211_local *local = to_ieee80211_local(dev);
-	struct ieee80211_low_level_stats stats;
-	ssize_t ret = -EINVAL;
-
-	if (!local->ops->get_stats)
-		return -EOPNOTSUPP;
-	ret = rtnl_lock_local(local);
-	if (ret)
-		return ret;
-	ret = local->ops->get_stats(local_to_hw(local), &stats);
-	rtnl_unlock();
-	if (!ret)
-		ret = (*format)(&stats, buf);
-	return ret;
-}
-
-#define IEEE80211_STATS_FMT(name, field, format_string)			\
-static ssize_t ieee80211_stats_fmt_##name(struct ieee80211_low_level_stats \
-					  *stats, char *buf)		\
-{									\
-	return sprintf(buf, format_string, stats->field);		\
-}
-
-#define __IEEE80211_STATS_SHOW(name)					\
-static ssize_t ieee80211_stats_show_##name(struct device *dev,		\
-					   struct device_attribute *attr,\
-					   char *buf)			\
-{									\
-	return ieee80211_stats_show(dev, attr, buf,			\
-				    ieee80211_stats_fmt_##name);	\
-}
-
-#define IEEE80211_STATS_ATTR(name, field, format)			\
-IEEE80211_STATS_FMT(name, field, format "\n")				\
-__IEEE80211_STATS_SHOW(name)						\
-static DEVICE_ATTR(name, S_IRUGO, ieee80211_stats_show_##name, NULL);
-
-IEEE80211_STATS_ATTR(ack_failure_count, dot11ACKFailureCount, "%u");
-IEEE80211_STATS_ATTR(rts_failure_count, dot11RTSFailureCount, "%u");
-IEEE80211_STATS_ATTR(fcs_error_count, dot11FCSErrorCount, "%u");
-IEEE80211_STATS_ATTR(rts_success_count, dot11RTSSuccessCount, "%u");
-
-static struct attribute *ieee80211_stats_attrs[] = {
-	&dev_attr_transmitted_fragment_count.attr,
-	&dev_attr_multicast_transmitted_frame_count.attr,
-	&dev_attr_failed_count.attr,
-	&dev_attr_retry_count.attr,
-	&dev_attr_multiple_retry_count.attr,
-	&dev_attr_frame_duplicate_count.attr,
-	&dev_attr_received_fragment_count.attr,
-	&dev_attr_multicast_received_frame_count.attr,
-	&dev_attr_transmitted_frame_count.attr,
-	&dev_attr_wep_undecryptable_count.attr,
-	&dev_attr_ack_failure_count.attr,
-	&dev_attr_rts_failure_count.attr,
-	&dev_attr_fcs_error_count.attr,
-	&dev_attr_rts_success_count.attr,
-	&dev_attr_num_scans.attr,
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	&dev_attr_tx_handlers_drop.attr,
-	&dev_attr_tx_handlers_queued.attr,
-	&dev_attr_tx_handlers_drop_unencrypted.attr,
-	&dev_attr_tx_handlers_drop_fragment.attr,
-	&dev_attr_tx_handlers_drop_wep.attr,
-	&dev_attr_tx_handlers_drop_not_assoc.attr,
-	&dev_attr_tx_handlers_drop_unauth_port.attr,
-	&dev_attr_rx_handlers_drop.attr,
-	&dev_attr_rx_handlers_queued.attr,
-	&dev_attr_rx_handlers_drop_nullfunc.attr,
-	&dev_attr_rx_handlers_drop_defrag.attr,
-	&dev_attr_rx_handlers_drop_short.attr,
-	&dev_attr_rx_handlers_drop_passive_scan.attr,
-	&dev_attr_tx_expand_skb_head.attr,
-	&dev_attr_tx_expand_skb_head_cloned.attr,
-	&dev_attr_rx_expand_skb_head.attr,
-	&dev_attr_rx_expand_skb_head2.attr,
-	&dev_attr_rx_handlers_fragments.attr,
-	&dev_attr_tx_status_drop.attr,
-	&dev_attr_wme_rx_queue.attr,
-	&dev_attr_wme_tx_queue.attr,
-#endif
-	NULL,
-};
-
-static struct attribute_group ieee80211_stats_group = {
-	.name = "statistics",
-	.attrs = ieee80211_stats_attrs,
-};
-
 /* attributes in /sys/class/net/X/ */
 
 static ssize_t ieee80211_if_show(struct device *d,
@@ -595,53 +267,6 @@ static struct attribute_group ieee80211_
 	.attrs = ieee80211_monitor_attrs,
 };
 
-int ieee80211_dev_sysfs_add(struct ieee80211_local *local)
-{
-	const struct device_attribute *attr;
-	int i, err;
-
-	for (i = 0; i < ARRAY_SIZE(ieee80211_dev_attrs); i++) {
-		attr = &ieee80211_dev_attrs[i];
-		err = sysfs_create_file(&local->hw.wiphy->dev.kobj,
-					&attr->attr);
-		if (err)
-			goto unwind;
-	}
-
-	err = sysfs_create_group(&local->hw.wiphy->dev.kobj,
-				 &ieee80211_stats_group);
-
-	if (err == 0)
-		return err;
-
- unwind:
-	/* one after the failed/last one */
-	i--;
-	while (i >= 0) {
-		attr = &ieee80211_dev_attrs[i];
-		sysfs_remove_file(&local->hw.wiphy->dev.kobj,
-				  &attr->attr);
-		i--;
-	}
-	return err;
-}
-
-void ieee80211_dev_sysfs_del(struct ieee80211_local *local)
-{
-	const struct device_attribute *attr;
-	int i;
-
-	sysfs_remove_group(&local->hw.wiphy->dev.kobj,
-			   &ieee80211_stats_group);
-
-	for (i = 0; i < ARRAY_SIZE(ieee80211_dev_attrs); i++) {
-		attr = &ieee80211_dev_attrs[i];
-		sysfs_remove_file(&local->hw.wiphy->dev.kobj,
-				  &attr->attr);
-	}
-}
-
-
 /* /sys/class/net/X functions */
 
 static void __ieee80211_remove_if_group(struct kobject *kobj,
--- wireless-dev.orig/net/mac80211/ieee80211_sysfs.h	2007-03-07 13:02:31.544710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_sysfs.h	2007-03-07 13:03:54.944710923 +0100
@@ -6,7 +6,5 @@
 int ieee80211_sysfs_add_netdevice(struct net_device *dev);
 void ieee80211_sysfs_remove_netdevice(struct net_device *dev);
 int ieee80211_sysfs_change_if_type(struct net_device *dev);
-int ieee80211_dev_sysfs_add(struct ieee80211_local *local);
-void ieee80211_dev_sysfs_del(struct ieee80211_local *local);
 
 #endif /* __IEEE80211_SYSFS_H */
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-dev/net/mac80211/debugfs.c	2007-03-07 13:03:54.944710923 +0100
@@ -0,0 +1,429 @@
+/*
+ * mac80211 debugfs for wireless PHYs
+ *
+ * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
+ *
+ * GPLv2
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/rtnetlink.h>
+#include "ieee80211_i.h"
+#include "ieee80211_rate.h"
+#include "debugfs.h"
+
+static int mac80211_open_file_generic(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const char *ieee80211_mode_str(int mode)
+{
+	switch (mode) {
+	case MODE_IEEE80211A:
+		return "IEEE 802.11a";
+	case MODE_IEEE80211B:
+		return "IEEE 802.11b";
+	case MODE_IEEE80211G:
+		return "IEEE 802.11g";
+	case MODE_ATHEROS_TURBO:
+		return "Atheros Turbo (5 GHz)";
+	default:
+		return "UNKNOWN";
+	}
+}
+
+static ssize_t modes_read(struct file *file, char __user *userbuf,
+			  size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	struct ieee80211_hw_mode *mode;
+	char buf[150], *p = buf;
+
+	/* FIXME: locking! */
+	list_for_each_entry(mode, &local->modes_list, list) {
+		p += scnprintf(p, sizeof(buf)+buf-p,
+			       "%s\n", ieee80211_mode_str(mode->mode));
+	}
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
+}
+
+static const struct file_operations modes_ops = {
+	.read = modes_read,
+	.open = mac80211_open_file_generic,
+};
+
+#define DEBUGFS_READONLY_FILE(name, buflen, fmt, value...)		\
+static ssize_t name## _read(struct file *file, char __user *userbuf,	\
+			    size_t count, loff_t *ppos)			\
+{									\
+	struct ieee80211_local *local = file->private_data;		\
+	char buf[buflen];						\
+	int res;							\
+									\
+	res = scnprintf(buf, buflen, fmt "\n", ##value);		\
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);	\
+}									\
+									\
+static const struct file_operations name## _ops = {			\
+	.read = name## _read,						\
+	.open = mac80211_open_file_generic,				\
+};
+
+#define DEBUGFS_ADD(name)						\
+	local->debugfs.name = debugfs_create_file(#name, 0444, phyd,	\
+						  local, &name## _ops);
+
+#define DEBUGFS_DEL(name)						\
+	debugfs_remove(local->debugfs.name);				\
+	local->debugfs.name = NULL;
+
+
+DEBUGFS_READONLY_FILE(channel, 20, "%d",
+		      local->hw.conf.channel);
+DEBUGFS_READONLY_FILE(frequency, 20, "%d",
+		      local->hw.conf.freq);
+DEBUGFS_READONLY_FILE(radar_detect, 20, "%d",
+		      local->hw.conf.radar_detect);
+DEBUGFS_READONLY_FILE(antenna_sel_tx, 20, "%d",
+		      local->hw.conf.antenna_sel_tx);
+DEBUGFS_READONLY_FILE(antenna_sel_rx, 20, "%d",
+		      local->hw.conf.antenna_sel_rx);
+DEBUGFS_READONLY_FILE(bridge_packets, 20, "%d",
+		      local->bridge_packets);
+DEBUGFS_READONLY_FILE(key_tx_rx_threshold, 20, "%d",
+		      local->key_tx_rx_threshold);
+DEBUGFS_READONLY_FILE(rts_threshold, 20, "%d",
+		      local->rts_threshold);
+DEBUGFS_READONLY_FILE(fragmentation_threshold, 20, "%d",
+		      local->fragmentation_threshold);
+DEBUGFS_READONLY_FILE(short_retry_limit, 20, "%d",
+		      local->short_retry_limit);
+DEBUGFS_READONLY_FILE(long_retry_limit, 20, "%d",
+		      local->long_retry_limit);
+DEBUGFS_READONLY_FILE(total_ps_buffered, 20, "%d",
+		      local->total_ps_buffered);
+DEBUGFS_READONLY_FILE(mode, 20, "%s",
+		      ieee80211_mode_str(local->hw.conf.phymode));
+DEBUGFS_READONLY_FILE(wep_iv, 20, "%#06x",
+		      local->wep_iv & 0xffffff);
+DEBUGFS_READONLY_FILE(tx_power_reduction, 20, "%d.%d dBm",
+		      local->hw.conf.tx_power_reduction / 10,
+		      local->hw.conf.tx_power_reduction & 10);
+DEBUGFS_READONLY_FILE(rate_ctrl_alg, 100, "%s",
+		      local->rate_ctrl ? local->rate_ctrl->ops->name : "<unset>");
+
+/* statistics stuff */
+
+static inline int rtnl_lock_local(struct ieee80211_local *local)
+{
+	rtnl_lock();
+	if (unlikely(local->reg_state != IEEE80211_DEV_REGISTERED)) {
+		rtnl_unlock();
+		return -ENODEV;
+	}
+	return 0;
+}
+
+#define DEBUGFS_STATS_FILE(name, buflen, fmt, value...)			\
+	DEBUGFS_READONLY_FILE(stats_ ##name, buflen, fmt, ##value)
+
+static ssize_t format_devstat_counter(struct ieee80211_local *local,
+	char __user *userbuf,
+	size_t count, loff_t *ppos,
+	int (*printvalue)(struct ieee80211_low_level_stats *stats, char *buf,
+			  int buflen))
+{
+	struct ieee80211_low_level_stats stats;
+	char buf[20];
+	int res;
+
+	if (!local->ops->get_stats)
+		return -EOPNOTSUPP;
+
+	res = rtnl_lock_local(local);
+	if (res)
+		return res;
+
+	res = local->ops->get_stats(local_to_hw(local), &stats);
+	rtnl_unlock();
+	if (!res)
+		res = printvalue(&stats, buf, sizeof(buf));
+	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
+}
+
+#define DEBUGFS_DEVSTATS_FILE(name)					\
+static int print_devstats_##name(struct ieee80211_low_level_stats *stats,\
+				 char *buf, int buflen)			\
+{									\
+	return scnprintf(buf, buflen, "%u\n", stats->name);		\
+}									\
+static ssize_t stats_ ##name## _read(struct file *file,			\
+			 	     char __user *userbuf,		\
+			 	     size_t count, loff_t *ppos)	\
+{									\
+	return format_devstat_counter(file->private_data,		\
+				      userbuf,				\
+				      count,				\
+				      ppos,				\
+				      print_devstats_##name);		\
+}									\
+									\
+static const struct file_operations stats_ ##name## _ops = {		\
+	.read = stats_ ##name## _read,					\
+	.open = mac80211_open_file_generic,				\
+};
+
+#define DEBUGFS_STATS_ADD(name)						\
+	local->debugfs.stats.name = debugfs_create_file(#name, 0444, statsd,\
+		local, &stats_ ##name## _ops);
+
+#define DEBUGFS_STATS_DEL(name)						\
+	debugfs_remove(local->debugfs.stats.name);			\
+	local->debugfs.stats.name = NULL;
+
+DEBUGFS_STATS_FILE(transmitted_fragment_count, 20, "%u",
+		   local->dot11TransmittedFragmentCount);
+DEBUGFS_STATS_FILE(multicast_transmitted_frame_count, 20, "%u",
+		   local->dot11MulticastTransmittedFrameCount);
+DEBUGFS_STATS_FILE(failed_count, 20, "%u",
+		   local->dot11FailedCount);
+DEBUGFS_STATS_FILE(retry_count, 20, "%u",
+		   local->dot11RetryCount);
+DEBUGFS_STATS_FILE(multiple_retry_count, 20, "%u",
+		   local->dot11MultipleRetryCount);
+DEBUGFS_STATS_FILE(frame_duplicate_count, 20, "%u",
+		   local->dot11FrameDuplicateCount);
+DEBUGFS_STATS_FILE(received_fragment_count, 20, "%u",
+		   local->dot11ReceivedFragmentCount);
+DEBUGFS_STATS_FILE(multicast_received_frame_count, 20, "%u",
+		   local->dot11MulticastReceivedFrameCount);
+DEBUGFS_STATS_FILE(transmitted_frame_count, 20, "%u",
+		   local->dot11TransmittedFrameCount);
+DEBUGFS_STATS_FILE(wep_undecryptable_count, 20, "%u",
+		   local->dot11WEPUndecryptableCount);
+DEBUGFS_STATS_FILE(num_scans, 20, "%u",
+		   local->scan.num_scans);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+DEBUGFS_STATS_FILE(tx_handlers_drop, 20, "%u",
+		   local->tx_handlers_drop);
+DEBUGFS_STATS_FILE(tx_handlers_queued, 20, "%u",
+		   local->tx_handlers_queued);
+DEBUGFS_STATS_FILE(tx_handlers_drop_unencrypted, 20, "%u",
+		   local->tx_handlers_drop_unencrypted);
+DEBUGFS_STATS_FILE(tx_handlers_drop_fragment, 20, "%u",
+		   local->tx_handlers_drop_fragment);
+DEBUGFS_STATS_FILE(tx_handlers_drop_wep, 20, "%u",
+		   local->tx_handlers_drop_wep);
+DEBUGFS_STATS_FILE(tx_handlers_drop_not_assoc, 20, "%u",
+		   local->tx_handlers_drop_not_assoc);
+DEBUGFS_STATS_FILE(tx_handlers_drop_unauth_port, 20, "%u",
+		   local->tx_handlers_drop_unauth_port);
+DEBUGFS_STATS_FILE(rx_handlers_drop, 20, "%u",
+		   local->rx_handlers_drop);
+DEBUGFS_STATS_FILE(rx_handlers_queued, 20, "%u",
+		   local->rx_handlers_queued);
+DEBUGFS_STATS_FILE(rx_handlers_drop_nullfunc, 20, "%u",
+		   local->rx_handlers_drop_nullfunc);
+DEBUGFS_STATS_FILE(rx_handlers_drop_defrag, 20, "%u",
+		   local->rx_handlers_drop_defrag);
+DEBUGFS_STATS_FILE(rx_handlers_drop_short, 20, "%u",
+		   local->rx_handlers_drop_short);
+DEBUGFS_STATS_FILE(rx_handlers_drop_passive_scan, 20, "%u",
+		   local->rx_handlers_drop_passive_scan);
+DEBUGFS_STATS_FILE(tx_expand_skb_head, 20, "%u",
+		   local->tx_expand_skb_head);
+DEBUGFS_STATS_FILE(tx_expand_skb_head_cloned, 20, "%u",
+		   local->tx_expand_skb_head_cloned);
+DEBUGFS_STATS_FILE(rx_expand_skb_head, 20, "%u",
+		   local->rx_expand_skb_head);
+DEBUGFS_STATS_FILE(rx_expand_skb_head2, 20, "%u",
+		   local->rx_expand_skb_head2);
+DEBUGFS_STATS_FILE(rx_handlers_fragments, 20, "%u",
+		   local->rx_handlers_fragments);
+DEBUGFS_STATS_FILE(tx_status_drop, 20, "%u",
+		   local->tx_status_drop);
+#endif
+
+DEBUGFS_DEVSTATS_FILE(dot11ACKFailureCount);
+DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
+DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
+DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);
+
+static ssize_t stats_wme_rx_queue_read(struct file *file,
+				       char __user *userbuf,
+				       size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[NUM_RX_DATA_QUEUES*15], *p = buf;
+	int i;
+
+	for (i = 0; i < NUM_RX_DATA_QUEUES; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p,
+			       "%u\n", local->wme_rx_queue[i]);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
+}
+
+static const struct file_operations stats_wme_rx_queue_ops = {
+	.read = stats_wme_rx_queue_read,
+	.open = mac80211_open_file_generic,
+};
+
+static ssize_t stats_wme_tx_queue_read(struct file *file,
+				       char __user *userbuf,
+				       size_t count, loff_t *ppos)
+{
+	struct ieee80211_local *local = file->private_data;
+	char buf[NUM_TX_DATA_QUEUES*15], *p = buf;
+	int i;
+
+	for (i = 0; i < NUM_TX_DATA_QUEUES; i++)
+		p += scnprintf(p, sizeof(buf)+buf-p,
+			       "%u\n", local->wme_tx_queue[i]);
+
+	return simple_read_from_buffer(userbuf, count, ppos, buf, p-buf);
+}
+
+static const struct file_operations stats_wme_tx_queue_ops = {
+	.read = stats_wme_tx_queue_read,
+	.open = mac80211_open_file_generic,
+};
+
+
+void debugfs_hw_add(struct ieee80211_local *local)
+{
+	struct dentry *phyd = local->hw.wiphy->debugfsdir;
+	struct dentry *statsd;
+
+	if (!phyd)
+		return;
+
+	DEBUGFS_ADD(channel);
+	DEBUGFS_ADD(frequency);
+	DEBUGFS_ADD(radar_detect);
+	DEBUGFS_ADD(antenna_sel_tx);
+	DEBUGFS_ADD(antenna_sel_rx);
+	DEBUGFS_ADD(bridge_packets);
+	DEBUGFS_ADD(key_tx_rx_threshold);
+	DEBUGFS_ADD(rts_threshold);
+	DEBUGFS_ADD(fragmentation_threshold);
+	DEBUGFS_ADD(short_retry_limit);
+	DEBUGFS_ADD(long_retry_limit);
+	DEBUGFS_ADD(total_ps_buffered);
+	DEBUGFS_ADD(mode);
+	DEBUGFS_ADD(wep_iv);
+	DEBUGFS_ADD(tx_power_reduction);
+	DEBUGFS_ADD(modes);
+
+	statsd = debugfs_create_dir("statistics", phyd);
+	local->debugfs.statistics = statsd;
+
+	/* if the dir failed, don't put all the other things into the root! */
+	if (!statsd)
+		return;
+
+	DEBUGFS_STATS_ADD(transmitted_fragment_count);
+	DEBUGFS_STATS_ADD(multicast_transmitted_frame_count);
+	DEBUGFS_STATS_ADD(failed_count);
+	DEBUGFS_STATS_ADD(retry_count);
+	DEBUGFS_STATS_ADD(multiple_retry_count);
+	DEBUGFS_STATS_ADD(frame_duplicate_count);
+	DEBUGFS_STATS_ADD(received_fragment_count);
+	DEBUGFS_STATS_ADD(multicast_received_frame_count);
+	DEBUGFS_STATS_ADD(transmitted_frame_count);
+	DEBUGFS_STATS_ADD(wep_undecryptable_count);
+	DEBUGFS_STATS_ADD(num_scans);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	DEBUGFS_STATS_ADD(tx_handlers_drop);
+	DEBUGFS_STATS_ADD(tx_handlers_queued);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_unencrypted);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_fragment);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_wep);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_not_assoc);
+	DEBUGFS_STATS_ADD(tx_handlers_drop_unauth_port);
+	DEBUGFS_STATS_ADD(rx_handlers_drop);
+	DEBUGFS_STATS_ADD(rx_handlers_queued);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_nullfunc);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_defrag);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_short);
+	DEBUGFS_STATS_ADD(rx_handlers_drop_passive_scan);
+	DEBUGFS_STATS_ADD(tx_expand_skb_head);
+	DEBUGFS_STATS_ADD(tx_expand_skb_head_cloned);
+	DEBUGFS_STATS_ADD(rx_expand_skb_head);
+	DEBUGFS_STATS_ADD(rx_expand_skb_head2);
+	DEBUGFS_STATS_ADD(rx_handlers_fragments);
+	DEBUGFS_STATS_ADD(tx_status_drop);
+#endif
+	DEBUGFS_STATS_ADD(dot11ACKFailureCount);
+	DEBUGFS_STATS_ADD(dot11RTSFailureCount);
+	DEBUGFS_STATS_ADD(dot11FCSErrorCount);
+	DEBUGFS_STATS_ADD(dot11RTSSuccessCount);
+	DEBUGFS_STATS_ADD(wme_tx_queue);
+	DEBUGFS_STATS_ADD(wme_rx_queue);
+}
+
+void debugfs_hw_del(struct ieee80211_local *local)
+{
+	DEBUGFS_DEL(channel);
+	DEBUGFS_DEL(frequency);
+	DEBUGFS_DEL(radar_detect);
+	DEBUGFS_DEL(antenna_sel_tx);
+	DEBUGFS_DEL(antenna_sel_rx);
+	DEBUGFS_DEL(bridge_packets);
+	DEBUGFS_DEL(key_tx_rx_threshold);
+	DEBUGFS_DEL(rts_threshold);
+	DEBUGFS_DEL(fragmentation_threshold);
+	DEBUGFS_DEL(short_retry_limit);
+	DEBUGFS_DEL(long_retry_limit);
+	DEBUGFS_DEL(total_ps_buffered);
+	DEBUGFS_DEL(mode);
+	DEBUGFS_DEL(wep_iv);
+	DEBUGFS_DEL(tx_power_reduction);
+	DEBUGFS_DEL(modes);
+
+	DEBUGFS_STATS_DEL(transmitted_fragment_count);
+	DEBUGFS_STATS_DEL(multicast_transmitted_frame_count);
+	DEBUGFS_STATS_DEL(failed_count);
+	DEBUGFS_STATS_DEL(retry_count);
+	DEBUGFS_STATS_DEL(multiple_retry_count);
+	DEBUGFS_STATS_DEL(frame_duplicate_count);
+	DEBUGFS_STATS_DEL(received_fragment_count);
+	DEBUGFS_STATS_DEL(multicast_received_frame_count);
+	DEBUGFS_STATS_DEL(transmitted_frame_count);
+	DEBUGFS_STATS_DEL(wep_undecryptable_count);
+	DEBUGFS_STATS_DEL(num_scans);
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+	DEBUGFS_STATS_DEL(tx_handlers_drop);
+	DEBUGFS_STATS_DEL(tx_handlers_queued);
+	DEBUGFS_STATS_DEL(tx_handlers_drop_unencrypted);
+	DEBUGFS_STATS_DEL(tx_handlers_drop_fragment);
+	DEBUGFS_STATS_DEL(tx_handlers_drop_wep);
+	DEBUGFS_STATS_DEL(tx_handlers_drop_not_assoc);
+	DEBUGFS_STATS_DEL(tx_handlers_drop_unauth_port);
+	DEBUGFS_STATS_DEL(rx_handlers_drop);
+	DEBUGFS_STATS_DEL(rx_handlers_queued);
+	DEBUGFS_STATS_DEL(rx_handlers_drop_nullfunc);
+	DEBUGFS_STATS_DEL(rx_handlers_drop_defrag);
+	DEBUGFS_STATS_DEL(rx_handlers_drop_short);
+	DEBUGFS_STATS_DEL(rx_handlers_drop_passive_scan);
+	DEBUGFS_STATS_DEL(tx_expand_skb_head);
+	DEBUGFS_STATS_DEL(tx_expand_skb_head_cloned);
+	DEBUGFS_STATS_DEL(rx_expand_skb_head);
+	DEBUGFS_STATS_DEL(rx_expand_skb_head2);
+	DEBUGFS_STATS_DEL(rx_handlers_fragments);
+	DEBUGFS_STATS_DEL(tx_status_drop);
+#endif
+	DEBUGFS_STATS_DEL(dot11ACKFailureCount);
+	DEBUGFS_STATS_DEL(dot11RTSFailureCount);
+	DEBUGFS_STATS_DEL(dot11FCSErrorCount);
+	DEBUGFS_STATS_DEL(dot11RTSSuccessCount);
+	DEBUGFS_STATS_DEL(wme_tx_queue);
+	DEBUGFS_STATS_DEL(wme_rx_queue);
+
+	debugfs_remove(local->debugfs.statistics);
+	local->debugfs.statistics = NULL;
+}
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-03-07 13:03:50.454710923 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-03-07 13:03:54.944710923 +0100
@@ -539,6 +539,68 @@ struct ieee80211_local {
 				* (1 << MODE_*) */
 
 	int user_space_mlme;
+
+#ifdef CONFIG_DEBUG_FS
+	struct local_debugfsdentries {
+		struct dentry *channel;
+		struct dentry *frequency;
+		struct dentry *radar_detect;
+		struct dentry *antenna_sel_tx;
+		struct dentry *antenna_sel_rx;
+		struct dentry *bridge_packets;
+		struct dentry *key_tx_rx_threshold;
+		struct dentry *rts_threshold;
+		struct dentry *fragmentation_threshold;
+		struct dentry *short_retry_limit;
+		struct dentry *long_retry_limit;
+		struct dentry *total_ps_buffered;
+		struct dentry *mode;
+		struct dentry *wep_iv;
+		struct dentry *tx_power_reduction;
+		struct dentry *modes;
+		struct dentry *statistics;
+		struct local_debugfsdentries_statsdentries {
+			struct dentry *transmitted_fragment_count;
+			struct dentry *multicast_transmitted_frame_count;
+			struct dentry *failed_count;
+			struct dentry *retry_count;
+			struct dentry *multiple_retry_count;
+			struct dentry *frame_duplicate_count;
+			struct dentry *received_fragment_count;
+			struct dentry *multicast_received_frame_count;
+			struct dentry *transmitted_frame_count;
+			struct dentry *wep_undecryptable_count;
+			struct dentry *num_scans;
+#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
+			struct dentry *tx_handlers_drop;
+			struct dentry *tx_handlers_queued;
+			struct dentry *tx_handlers_drop_unencrypted;
+			struct dentry *tx_handlers_drop_fragment;
+			struct dentry *tx_handlers_drop_wep;
+			struct dentry *tx_handlers_drop_not_assoc;
+			struct dentry *tx_handlers_drop_unauth_port;
+			struct dentry *rx_handlers_drop;
+			struct dentry *rx_handlers_queued;
+			struct dentry *rx_handlers_drop_nullfunc;
+			struct dentry *rx_handlers_drop_defrag;
+			struct dentry *rx_handlers_drop_short;
+			struct dentry *rx_handlers_drop_passive_scan;
+			struct dentry *tx_expand_skb_head;
+			struct dentry *tx_expand_skb_head_cloned;
+			struct dentry *rx_expand_skb_head;
+			struct dentry *rx_expand_skb_head2;
+			struct dentry *rx_handlers_fragments;
+			struct dentry *tx_status_drop;
+#endif
+			struct dentry *dot11ACKFailureCount;
+			struct dentry *dot11RTSFailureCount;
+			struct dentry *dot11FCSErrorCount;
+			struct dentry *dot11RTSSuccessCount;
+			struct dentry *wme_tx_queue;
+			struct dentry *wme_rx_queue;
+		} stats;
+	} debugfs;
+#endif
 };
 
 static inline struct ieee80211_local *hw_to_local(

--

