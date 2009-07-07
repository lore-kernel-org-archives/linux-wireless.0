Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZGGLml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2009 07:42:41 -0400
Subject: [PATCH] mac80211: driver operation debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 13:42:34 +0200
Message-Id: <1246966954.4755.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes mac80211 use the event tracing framework
to log all operations as given to the driver. This
will need to be extended with more information, but
as a start it should be good.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Here's an example:

# echo 1 > /debug/tracing/events/mac80211/enable
# hostapd ...&
# wpa_supplicant ...
<wait a bit>
# ^C
# fg
# ^C
# cat /debug/tracing/trace

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
         hostapd-1717  [004] 10038.012037: drv_start: phy0
         hostapd-1717  [004] 10038.012047: drv_add_interface: phy0 vif:ffff88001ed31088(3) addr:02:00:00:00:00:00 ret:0
         hostapd-1717  [004] 10038.012056: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0xe
         hostapd-1717  [004] 10038.041698: drv_config: phy0 ch:0xffffffff ret:0
         hostapd-1717  [004] 10038.041703: drv_conf_tx: phy0 queue:0 ret:0
         hostapd-1717  [004] 10038.041707: drv_conf_tx: phy0 queue:1 ret:0
         hostapd-1717  [004] 10038.041711: drv_conf_tx: phy0 queue:2 ret:0
         hostapd-1717  [004] 10038.041714: drv_conf_tx: phy0 queue:3 ret:0
         hostapd-1717  [004] 10038.041720: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:0
         hostapd-1717  [004] 10038.041764: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:1
         hostapd-1717  [004] 10038.041811: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:1
         hostapd-1717  [004] 10038.083795: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:1
         hostapd-1717  [004] 10038.083860: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:1
         hostapd-1717  [004] 10038.151893: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0x20
         hostapd-1717  [004] 10038.151968: drv_config: phy0 ch:0x40 ret:0
         hostapd-1717  [004] 10038.152054: drv_set_rts_threshold: phy0 value:-1 ret:0
         hostapd-1717  [004] 10038.251801: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0x300
         hostapd-1717  [004] 10038.251899: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0x2
         hostapd-1717  [004] 10038.251977: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0x8
         hostapd-1717  [004] 10038.252053: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0x4
  wpa_supplicant-1719  [000] 10049.104183: drv_start: phy1
  wpa_supplicant-1719  [000] 10049.104192: drv_add_interface: phy1 vif:ffff88001ed330e8(2) addr:02:00:00:00:01:00 ret:0
  wpa_supplicant-1719  [000] 10049.104202: drv_bss_info_changed: phy1 vif:ffff88001ed330e8(2) changed:0xe
  wpa_supplicant-1719  [000] 10049.139213: drv_config: phy1 ch:0xffffffff ret:0
  wpa_supplicant-1719  [000] 10049.139218: drv_conf_tx: phy1 queue:0 ret:0
  wpa_supplicant-1719  [000] 10049.139222: drv_conf_tx: phy1 queue:1 ret:0
  wpa_supplicant-1719  [000] 10049.139226: drv_conf_tx: phy1 queue:2 ret:0
  wpa_supplicant-1719  [000] 10049.139229: drv_conf_tx: phy1 queue:3 ret:0
  wpa_supplicant-1719  [000] 10049.139276: drv_configure_filter: phy1 changed:0x0 total:0x0 mc:0
  wpa_supplicant-1719  [000] 10049.139313: drv_configure_filter: phy1 changed:0x0 total:0x0 mc:1
  wpa_supplicant-1719  [000] 10049.139362: drv_configure_filter: phy1 changed:0x0 total:0x0 mc:1
  wpa_supplicant-1719  [006] 10049.304605: drv_config: phy1 ch:0x100 ret:0
  wpa_supplicant-1719  [006] 10049.304610: drv_sw_scan_start: phy1
  wpa_supplicant-1719  [006] 10049.304640: drv_configure_filter: phy1 changed:0x10 total:0x0 mc:1
            phy1-613   [006] 10049.333098: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.389179: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.449175: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.509223: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.569178: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.629194: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.689348: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.749182: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.809179: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.869177: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.929175: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10049.989257: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.049179: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.109179: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.169184: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.229181: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.289190: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.349249: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.409255: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.469240: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.529166: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.589185: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.649176: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.709178: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.769337: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.769353: drv_configure_filter: phy1 changed:0x10 total:0x0 mc:1
            phy1-613   [006] 10050.769355: drv_sw_scan_complete: phy1
            phy1-613   [006] 10050.769376: drv_config: phy1 ch:0x100 ret:0
  wpa_supplicant-1719  [006] 10050.773854: drv_config: phy1 ch:0x40 ret:0
            phy1-613   [006] 10050.774022: drv_config: phy1 ch:0x100 ret:0
         hostapd-1717  [004] 10050.970744: drv_sta_notify: phy0 vif:ffff88001ed31088(3) sta:02:00:00:00:01:00 cmd:0
            phy1-613   [006] 10050.972031: drv_sta_notify: phy1 vif:ffff88001ed330e8(2) sta:02:00:00:00:00:00 cmd:0
            phy1-613   [006] 10050.972155: drv_bss_info_changed: phy1 vif:ffff88001ed330e8(2) changed:0xed
  wpa_supplicant-1719  [006] 10061.292954: drv_conf_tx: phy1 queue:0 ret:0
  wpa_supplicant-1719  [006] 10061.292960: drv_conf_tx: phy1 queue:1 ret:0
  wpa_supplicant-1719  [006] 10061.292964: drv_conf_tx: phy1 queue:2 ret:0
  wpa_supplicant-1719  [006] 10061.292968: drv_conf_tx: phy1 queue:3 ret:0
  wpa_supplicant-1719  [006] 10061.292995: drv_config: phy1 ch:0x100 ret:0
  wpa_supplicant-1719  [006] 10061.293044: drv_bss_info_changed: phy1 vif:ffff88001ed330e8(2) changed:0x8f
  wpa_supplicant-1719  [006] 10061.293166: drv_sta_notify: phy1 vif:ffff88001ed330e8(2) sta:02:00:00:00:00:00 cmd:1
         hostapd-1717  [004] 10061.354522: drv_sta_notify: phy0 vif:ffff88001ed31088(3) sta:02:00:00:00:01:00 cmd:1
  wpa_supplicant-1719  [006] 10061.412163: drv_configure_filter: phy1 changed:0x0 total:0x0 mc:1
  wpa_supplicant-1719  [006] 10061.432941: drv_configure_filter: phy1 changed:0x0 total:0x0 mc:0
  wpa_supplicant-1719  [006] 10061.492912: drv_remove_interface: phy1 vif:ffff88001ed330e8(2) addr:02:00:00:00:01:00
  wpa_supplicant-1719  [006] 10061.492920: drv_stop: phy1
         hostapd-1717  [004] 10063.651665: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:1
         hostapd-1717  [004] 10063.781670: drv_bss_info_changed: phy0 vif:ffff88001ed31088(3) changed:0x200
         hostapd-1717  [004] 10063.811756: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:1
         hostapd-1717  [004] 10063.841668: drv_configure_filter: phy0 changed:0x0 total:0x0 mc:0
         hostapd-1717  [004] 10063.931656: drv_remove_interface: phy0 vif:ffff88001ed31088(3) addr:02:00:00:00:00:00
         hostapd-1717  [004] 10063.931666: drv_stop: phy0


 net/mac80211/Kconfig        |   10 
 net/mac80211/Makefile       |    3 
 net/mac80211/driver-ops.h   |   85 ++++-
 net/mac80211/driver-trace.c |    6 
 net/mac80211/driver-trace.h |  648 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 730 insertions(+), 22 deletions(-)

--- wireless-testing.orig/net/mac80211/driver-ops.h	2009-07-07 13:36:05.000000000 +0200
+++ wireless-testing/net/mac80211/driver-ops.h	2009-07-07 13:36:18.000000000 +0200
@@ -3,6 +3,7 @@
 
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
+#include "driver-trace.h"
 
 static inline int drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
 {
@@ -11,29 +12,37 @@ static inline int drv_tx(struct ieee8021
 
 static inline int drv_start(struct ieee80211_local *local)
 {
-	return local->ops->start(&local->hw);
+	int ret = local->ops->start(&local->hw);
+	trace_drv_start(local, ret);
+	return ret;
 }
 
 static inline void drv_stop(struct ieee80211_local *local)
 {
 	local->ops->stop(&local->hw);
+	trace_drv_stop(local);
 }
 
 static inline int drv_add_interface(struct ieee80211_local *local,
 				    struct ieee80211_if_init_conf *conf)
 {
-	return local->ops->add_interface(&local->hw, conf);
+	int ret = local->ops->add_interface(&local->hw, conf);
+	trace_drv_add_interface(local, conf->mac_addr, conf->vif, ret);
+	return ret;
 }
 
 static inline void drv_remove_interface(struct ieee80211_local *local,
 					struct ieee80211_if_init_conf *conf)
 {
 	local->ops->remove_interface(&local->hw, conf);
+	trace_drv_remove_interface(local, conf->mac_addr, conf->vif);
 }
 
 static inline int drv_config(struct ieee80211_local *local, u32 changed)
 {
-	return local->ops->config(&local->hw, changed);
+	int ret = local->ops->config(&local->hw, changed);
+	trace_drv_config(local, changed, ret);
+	return ret;
 }
 
 static inline void drv_bss_info_changed(struct ieee80211_local *local,
@@ -43,6 +52,7 @@ static inline void drv_bss_info_changed(
 {
 	if (local->ops->bss_info_changed)
 		local->ops->bss_info_changed(&local->hw, vif, info, changed);
+	trace_drv_bss_info_changed(local, vif, info, changed);
 }
 
 static inline void drv_configure_filter(struct ieee80211_local *local,
@@ -53,14 +63,18 @@ static inline void drv_configure_filter(
 {
 	local->ops->configure_filter(&local->hw, changed_flags, total_flags,
 				     mc_count, mc_list);
+	trace_drv_configure_filter(local, changed_flags, total_flags,
+					    mc_count);
 }
 
 static inline int drv_set_tim(struct ieee80211_local *local,
 			      struct ieee80211_sta *sta, bool set)
 {
+	int ret = 0;
 	if (local->ops->set_tim)
-		return local->ops->set_tim(&local->hw, sta, set);
-	return 0;
+		ret = local->ops->set_tim(&local->hw, sta, set);
+	trace_drv_set_tim(local, sta, set, ret);
+	return ret;
 }
 
 static inline int drv_set_key(struct ieee80211_local *local,
@@ -68,7 +82,9 @@ static inline int drv_set_key(struct iee
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_key_conf *key)
 {
-	return local->ops->set_key(&local->hw, cmd, vif, sta, key);
+	int ret = local->ops->set_key(&local->hw, cmd, vif, sta, key);
+	trace_drv_set_key(local, cmd, vif, sta, key, ret);
+	return ret;
 }
 
 static inline void drv_update_tkip_key(struct ieee80211_local *local,
@@ -79,32 +95,41 @@ static inline void drv_update_tkip_key(s
 	if (local->ops->update_tkip_key)
 		local->ops->update_tkip_key(&local->hw, conf, address,
 					    iv32, phase1key);
+	trace_drv_update_tkip_key(local, conf, address, iv32);
 }
 
 static inline int drv_hw_scan(struct ieee80211_local *local,
 			      struct cfg80211_scan_request *req)
 {
-	return local->ops->hw_scan(&local->hw, req);
+	int ret = local->ops->hw_scan(&local->hw, req);
+	trace_drv_hw_scan(local, req, ret);
+	return ret;
 }
 
 static inline void drv_sw_scan_start(struct ieee80211_local *local)
 {
 	if (local->ops->sw_scan_start)
 		local->ops->sw_scan_start(&local->hw);
+	trace_drv_sw_scan_start(local);
 }
 
 static inline void drv_sw_scan_complete(struct ieee80211_local *local)
 {
 	if (local->ops->sw_scan_complete)
 		local->ops->sw_scan_complete(&local->hw);
+	trace_drv_sw_scan_complete(local);
 }
 
 static inline int drv_get_stats(struct ieee80211_local *local,
 				struct ieee80211_low_level_stats *stats)
 {
-	if (!local->ops->get_stats)
-		return -EOPNOTSUPP;
-	return local->ops->get_stats(&local->hw, stats);
+	int ret = -EOPNOTSUPP;
+
+	if (local->ops->get_stats)
+		ret = local->ops->get_stats(&local->hw, stats);
+	trace_drv_get_stats(local, stats, ret);
+
+	return ret;
 }
 
 static inline void drv_get_tkip_seq(struct ieee80211_local *local,
@@ -112,14 +137,17 @@ static inline void drv_get_tkip_seq(stru
 {
 	if (local->ops->get_tkip_seq)
 		local->ops->get_tkip_seq(&local->hw, hw_key_idx, iv32, iv16);
+	trace_drv_get_tkip_seq(local, hw_key_idx, iv32, iv16);
 }
 
 static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 					u32 value)
 {
+	int ret = 0;
 	if (local->ops->set_rts_threshold)
-		return local->ops->set_rts_threshold(&local->hw, value);
-	return 0;
+		ret = local->ops->set_rts_threshold(&local->hw, value);
+	trace_drv_set_rts_threshold(local, value, ret);
+	return ret;
 }
 
 static inline void drv_sta_notify(struct ieee80211_local *local,
@@ -129,46 +157,57 @@ static inline void drv_sta_notify(struct
 {
 	if (local->ops->sta_notify)
 		local->ops->sta_notify(&local->hw, vif, cmd, sta);
+	trace_drv_sta_notify(local, vif, cmd, sta);
 }
 
 static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
 {
+	int ret = -EOPNOTSUPP;
 	if (local->ops->conf_tx)
-		return local->ops->conf_tx(&local->hw, queue, params);
-	return -EOPNOTSUPP;
+		ret = local->ops->conf_tx(&local->hw, queue, params);
+	trace_drv_conf_tx(local, queue, params, ret);
+	return ret;
 }
 
 static inline int drv_get_tx_stats(struct ieee80211_local *local,
 				   struct ieee80211_tx_queue_stats *stats)
 {
-	return local->ops->get_tx_stats(&local->hw, stats);
+	int ret = local->ops->get_tx_stats(&local->hw, stats);
+	trace_drv_get_tx_stats(local, stats, ret);
+	return ret;
 }
 
 static inline u64 drv_get_tsf(struct ieee80211_local *local)
 {
+	u64 ret = -1ULL;
 	if (local->ops->get_tsf)
-		return local->ops->get_tsf(&local->hw);
-	return -1ULL;
+		ret = local->ops->get_tsf(&local->hw);
+	trace_drv_get_tsf(local, ret);
+	return ret;
 }
 
 static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
 {
 	if (local->ops->set_tsf)
 		local->ops->set_tsf(&local->hw, tsf);
+	trace_drv_set_tsf(local, tsf);
 }
 
 static inline void drv_reset_tsf(struct ieee80211_local *local)
 {
 	if (local->ops->reset_tsf)
 		local->ops->reset_tsf(&local->hw);
+	trace_drv_reset_tsf(local);
 }
 
 static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 {
+	int ret = 1;
 	if (local->ops->tx_last_beacon)
-		return local->ops->tx_last_beacon(&local->hw);
-	return 1;
+		ret = local->ops->tx_last_beacon(&local->hw);
+	trace_drv_tx_last_beacon(local, ret);
+	return ret;
 }
 
 static inline int drv_ampdu_action(struct ieee80211_local *local,
@@ -176,10 +215,12 @@ static inline int drv_ampdu_action(struc
 				   struct ieee80211_sta *sta, u16 tid,
 				   u16 *ssn)
 {
+	int ret = -EOPNOTSUPP;
 	if (local->ops->ampdu_action)
-		return local->ops->ampdu_action(&local->hw, action,
-						sta, tid, ssn);
-	return -EOPNOTSUPP;
+		ret = local->ops->ampdu_action(&local->hw, action,
+					       sta, tid, ssn);
+	trace_drv_ampdu_action(local, action, sta, tid, ssn, ret);
+	return ret;
 }
 
 
--- wireless-testing.orig/net/mac80211/Kconfig	2009-07-07 13:36:10.000000000 +0200
+++ wireless-testing/net/mac80211/Kconfig	2009-07-07 13:36:18.000000000 +0200
@@ -205,3 +205,13 @@ config MAC80211_DEBUG_COUNTERS
 	  and show them in debugfs.
 
 	  If unsure, say N.
+
+config MAC80211_DRIVER_API_TRACER
+	bool "Driver API tracer"
+	depends on MAC80211_DEBUG_MENU
+	depends on EVENT_TRACING
+	help
+	  Say Y here to print out verbose driver API messages, for all
+	  driver method calls. This generates a lot of output!
+
+	  If unsure, say N.
--- wireless-testing.orig/net/mac80211/Makefile	2009-07-07 13:36:10.000000000 +0200
+++ wireless-testing/net/mac80211/Makefile	2009-07-07 13:36:18.000000000 +0200
@@ -41,6 +41,9 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 
 mac80211-$(CONFIG_PM) += pm.o
 
+mac80211-$(CONFIG_MAC80211_DRIVER_API_TRACER) += driver-trace.o
+CFLAGS_driver-trace.o := -I$(src)
+
 # objects for PID algorithm
 rc80211_pid-y := rc80211_pid_algo.o
 rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/driver-trace.h	2009-07-07 13:36:18.000000000 +0200
@@ -0,0 +1,648 @@
+#if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
+#define __MAC80211_DRIVER_TRACE
+
+#include <linux/tracepoint.h>
+#include <net/mac80211.h>
+#include "ieee80211_i.h"
+
+#ifndef CONFIG_MAC80211_DRIVER_API_TRACER
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mac80211
+
+#define MAXNAME		32
+#define LOCAL_ENTRY	__array(char, wiphy_name, 32)
+#define LOCAL_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(local->hw.wiphy), MAXNAME)
+#define LOCAL_PR_FMT	"%s"
+#define LOCAL_PR_ARG	__entry->wiphy_name
+
+#define STA_ENTRY	__array(char, sta_addr, ETH_ALEN)
+#define STA_ASSIGN	(sta ? memcpy(__entry->sta_addr, sta->addr, ETH_ALEN) : memset(__entry->sta_addr, 0, ETH_ALEN))
+#define STA_PR_FMT	" sta:%pM"
+#define STA_PR_ARG	__entry->sta_addr
+
+#define VIF_ENTRY	__field(enum nl80211_iftype, vif_type) __field(void *, vif)
+#define VIF_ASSIGN	__entry->vif_type = vif ? vif->type : 0; __entry->vif = vif
+#define VIF_PR_FMT	" vif:%p(%d)"
+#define VIF_PR_ARG	__entry->vif, __entry->vif_type
+
+TRACE_EVENT(drv_start,
+	TP_PROTO(struct ieee80211_local *local, int ret),
+
+	TP_ARGS(local, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_stop,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_add_interface,
+	TP_PROTO(struct ieee80211_local *local,
+		 const u8 *addr,
+		 struct ieee80211_vif *vif,
+		 int ret),
+
+	TP_ARGS(local, addr, vif, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(char, addr, 6)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->addr, addr, 6);
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM ret:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_remove_interface,
+	TP_PROTO(struct ieee80211_local *local,
+		 const u8 *addr, struct ieee80211_vif *vif),
+
+	TP_ARGS(local, addr, vif),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(char, addr, 6)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->addr, addr, 6);
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " addr:%pM",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->addr
+	)
+);
+
+TRACE_EVENT(drv_config,
+	TP_PROTO(struct ieee80211_local *local,
+		 u32 changed,
+		 int ret),
+
+	TP_ARGS(local, changed, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, changed)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->changed = changed;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ch:%#x ret:%d",
+		LOCAL_PR_ARG, __entry->changed, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_bss_info_changed,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_vif *vif,
+		 struct ieee80211_bss_conf *info,
+		 u32 changed),
+
+	TP_ARGS(local, vif, info, changed),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(bool, assoc)
+		__field(u16, aid)
+		__field(bool, cts)
+		__field(bool, shortpre)
+		__field(bool, shortslot)
+		__field(u8, dtimper)
+		__field(u16, bcnint)
+		__field(u16, assoc_cap)
+		__field(u64, timestamp)
+		__field(u32, basic_rates)
+		__field(u32, changed)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->changed = changed;
+		__entry->aid = info->aid;
+		__entry->assoc = info->assoc;
+		__entry->shortpre = info->use_short_preamble;
+		__entry->cts = info->use_cts_prot;
+		__entry->shortslot = info->use_short_slot;
+		__entry->dtimper = info->dtim_period;
+		__entry->bcnint = info->beacon_int;
+		__entry->assoc_cap = info->assoc_capability;
+		__entry->timestamp = info->timestamp;
+		__entry->basic_rates = info->basic_rates;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " changed:%#x",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->changed
+	)
+);
+
+TRACE_EVENT(drv_configure_filter,
+	TP_PROTO(struct ieee80211_local *local,
+		 unsigned int changed_flags,
+		 unsigned int *total_flags,
+		 int mc_count),
+
+	TP_ARGS(local, changed_flags, total_flags, mc_count),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(unsigned int, changed)
+		__field(unsigned int, total)
+		__field(int, mc)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->changed = changed_flags;
+		__entry->total = *total_flags;
+		__entry->mc = mc_count;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " changed:%#x total:%#x mc:%d",
+		LOCAL_PR_ARG, __entry->changed, __entry->total, __entry->mc
+	)
+);
+
+TRACE_EVENT(drv_set_tim,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sta *sta, bool set, int ret),
+
+	TP_ARGS(local, sta, set, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		STA_ENTRY
+		__field(bool, set)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->set = set;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT STA_PR_FMT " set:%d ret:%d",
+		LOCAL_PR_ARG, STA_PR_FMT, __entry->set, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_set_key,
+	TP_PROTO(struct ieee80211_local *local,
+		 enum set_key_cmd cmd, struct ieee80211_vif *vif,
+		 struct ieee80211_sta *sta,
+		 struct ieee80211_key_conf *key, int ret),
+
+	TP_ARGS(local, cmd, vif, sta, key, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(enum ieee80211_key_alg, alg)
+		__field(u8, hw_key_idx)
+		__field(u8, flags)
+		__field(s8, keyidx)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->alg = key->alg;
+		__entry->flags = key->flags;
+		__entry->keyidx = key->keyidx;
+		__entry->hw_key_idx = key->hw_key_idx;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " ret:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_update_tkip_key,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_key_conf *conf,
+		 const u8 *address, u32 iv32),
+
+	TP_ARGS(local, conf, address, iv32),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__array(u8, addr, 6)
+		__field(u32, iv32)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		memcpy(__entry->addr, address, 6);
+		__entry->iv32 = iv32;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " addr:%pM iv32:%#x",
+		LOCAL_PR_ARG, __entry->addr, __entry->iv32
+	)
+);
+
+TRACE_EVENT(drv_hw_scan,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct cfg80211_scan_request *req, int ret),
+
+	TP_ARGS(local, req, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ret:%d",
+		LOCAL_PR_ARG, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_sw_scan_start,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_sw_scan_complete,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_get_stats,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_low_level_stats *stats,
+		 int ret),
+
+	TP_ARGS(local, stats, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, ret)
+		__field(unsigned int, ackfail)
+		__field(unsigned int, rtsfail)
+		__field(unsigned int, fcserr)
+		__field(unsigned int, rtssucc)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+		__entry->ackfail = stats->dot11ACKFailureCount;
+		__entry->rtsfail = stats->dot11RTSFailureCount;
+		__entry->fcserr = stats->dot11FCSErrorCount;
+		__entry->rtssucc = stats->dot11RTSSuccessCount;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ret:%d",
+		LOCAL_PR_ARG, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_get_tkip_seq,
+	TP_PROTO(struct ieee80211_local *local,
+		 u8 hw_key_idx, u32 *iv32, u16 *iv16),
+
+	TP_ARGS(local, hw_key_idx, iv32, iv16),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, hw_key_idx)
+		__field(u32, iv32)
+		__field(u16, iv16)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->hw_key_idx = hw_key_idx;
+		__entry->iv32 = *iv32;
+		__entry->iv16 = *iv16;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_set_rts_threshold,
+	TP_PROTO(struct ieee80211_local *local, u32 value, int ret),
+
+	TP_ARGS(local, value, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u32, value)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+		__entry->value = value;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " value:%d ret:%d",
+		LOCAL_PR_ARG, __entry->value, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_sta_notify,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_vif *vif,
+		 enum sta_notify_cmd cmd,
+		 struct ieee80211_sta *sta),
+
+	TP_ARGS(local, vif, cmd, sta),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u32, cmd)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->cmd = cmd;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " cmd:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->cmd
+	)
+);
+
+TRACE_EVENT(drv_conf_tx,
+	TP_PROTO(struct ieee80211_local *local, u16 queue,
+		 const struct ieee80211_tx_queue_params *params,
+		 int ret),
+
+	TP_ARGS(local, queue, params, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u16, queue)
+		__field(u16, txop)
+		__field(u16, cw_min)
+		__field(u16, cw_max)
+		__field(u8, aifs)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->queue = queue;
+		__entry->ret = ret;
+		__entry->txop = params->txop;
+		__entry->cw_max = params->cw_max;
+		__entry->cw_min = params->cw_min;
+		__entry->aifs = params->aifs;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " queue:%d ret:%d",
+		LOCAL_PR_ARG, __entry->queue, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_get_tx_stats,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_tx_queue_stats *stats,
+		 int ret),
+
+	TP_ARGS(local, stats, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ret:%d",
+		LOCAL_PR_ARG, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_get_tsf,
+	TP_PROTO(struct ieee80211_local *local, u64 ret),
+
+	TP_ARGS(local, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u64, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ret:%llu",
+		LOCAL_PR_ARG, (unsigned long long)__entry->ret
+	)
+);
+
+TRACE_EVENT(drv_set_tsf,
+	TP_PROTO(struct ieee80211_local *local, u64 tsf),
+
+	TP_ARGS(local, tsf),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u64, tsf)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->tsf = tsf;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " tsf:%llu",
+		LOCAL_PR_ARG, (unsigned long long)__entry->tsf
+	)
+);
+
+TRACE_EVENT(drv_reset_tsf,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
+TRACE_EVENT(drv_tx_last_beacon,
+	TP_PROTO(struct ieee80211_local *local, int ret),
+
+	TP_ARGS(local, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->ret = ret;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT " ret:%d",
+		LOCAL_PR_ARG, __entry->ret
+	)
+);
+
+TRACE_EVENT(drv_ampdu_action,
+	TP_PROTO(struct ieee80211_local *local,
+		 enum ieee80211_ampdu_mlme_action action,
+		 struct ieee80211_sta *sta, u16 tid,
+		 u16 *ssn, int ret),
+
+	TP_ARGS(local, action, sta, tid, ssn, ret),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+        	STA_ENTRY
+        	__field(u32, action)
+        	__field(u16, tid)
+        	__field(u16, ssn)
+        	__field(int, ret)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		STA_ASSIGN;
+		__entry->ret = ret;
+		__entry->action = action;
+		__entry->tid = tid;
+		__entry->ssn = *ssn;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  STA_PR_FMT " action:%d tid:%d ret:%d",
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->action, __entry->tid, __entry->ret
+	)
+);
+#endif /* __MAC80211_DRIVER_TRACE */
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE driver-trace
+#include <trace/define_trace.h>
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/mac80211/driver-trace.c	2009-07-07 13:36:18.000000000 +0200
@@ -0,0 +1,6 @@
+/* bug in tracepoint.h, it should include this */
+#include <linux/module.h>
+
+#include "driver-ops.h"
+#define CREATE_TRACE_POINTS
+#include "driver-trace.h"


