Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbZJ0L7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 07:59:32 -0400
Subject: [PATCH] cfg80211/mac80211: use debugfs_remove_recursive
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Oct 2009 12:59:03 +0100
Message-ID: <1256644743.4237.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can save a lot of code and pointers in the structs
by using debugfs_remove_recursive().

First, change cfg80211 to use debugfs_remove_recursive()
so that drivers do not need to clean up any files they
added to the per-wiphy debugfs (if and only if they are
ok to be accessed until after wiphy_unregister!).

Then also make mac80211 use debugfs_remove_recursive()
where necessary -- it need not remove per-wiphy files
as cfg80211 now removes those, but netdev etc. files
still need to be handled but can now be removed without
needing struct dentry pointers to all of them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
This doesn't necessarily have to be one patch, but the cfg80211 bit is
small ... let me know if you'd prefer two patches.

 net/mac80211/debugfs.c        |   73 -----------------
 net/mac80211/debugfs.h        |    2 
 net/mac80211/debugfs_key.c    |   44 +++-------
 net/mac80211/debugfs_netdev.c |  174 ++++++------------------------------------
 net/mac80211/debugfs_sta.c    |   31 -------
 net/mac80211/ieee80211_i.h    |  114 ---------------------------
 net/mac80211/key.h            |   12 --
 net/mac80211/main.c           |    2 
 net/mac80211/rate.c           |    7 -
 net/mac80211/sta_info.h       |   22 -----
 net/wireless/core.c           |    3 
 net/wireless/core.h           |   11 --
 net/wireless/debugfs.c        |   15 ---
 net/wireless/debugfs.h        |    3 
 14 files changed, 51 insertions(+), 462 deletions(-)

--- wireless-testing.orig/net/mac80211/debugfs_sta.c	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_sta.c	2009-10-27 12:27:57.000000000 +0100
@@ -158,13 +158,9 @@ static ssize_t sta_agg_status_read(struc
 STA_OPS(agg_status);
 
 #define DEBUGFS_ADD(name) \
-	sta->debugfs.name = debugfs_create_file(#name, 0400, \
+	debugfs_create_file(#name, 0400, \
 		sta->debugfs.dir, sta, &sta_ ##name## _ops);
 
-#define DEBUGFS_DEL(name) \
-	debugfs_remove(sta->debugfs.name);\
-	sta->debugfs.name = NULL;
-
 
 void ieee80211_sta_debugfs_add(struct sta_info *sta)
 {
@@ -216,29 +212,6 @@ void ieee80211_sta_debugfs_add(struct st
 
 void ieee80211_sta_debugfs_remove(struct sta_info *sta)
 {
-	DEBUGFS_DEL(flags);
-	DEBUGFS_DEL(num_ps_buf_frames);
-	DEBUGFS_DEL(inactive_ms);
-	DEBUGFS_DEL(last_seq_ctrl);
-	DEBUGFS_DEL(agg_status);
-	DEBUGFS_DEL(aid);
-	DEBUGFS_DEL(dev);
-	DEBUGFS_DEL(rx_packets);
-	DEBUGFS_DEL(tx_packets);
-	DEBUGFS_DEL(rx_bytes);
-	DEBUGFS_DEL(tx_bytes);
-	DEBUGFS_DEL(rx_duplicates);
-	DEBUGFS_DEL(rx_fragments);
-	DEBUGFS_DEL(rx_dropped);
-	DEBUGFS_DEL(tx_fragments);
-	DEBUGFS_DEL(tx_filtered);
-	DEBUGFS_DEL(tx_retry_failed);
-	DEBUGFS_DEL(tx_retry_count);
-	DEBUGFS_DEL(last_signal);
-	DEBUGFS_DEL(last_qual);
-	DEBUGFS_DEL(last_noise);
-	DEBUGFS_DEL(wep_weak_iv_count);
-
-	debugfs_remove(sta->debugfs.dir);
+	debugfs_remove_recursive(sta->debugfs.dir);
 	sta->debugfs.dir = NULL;
 }
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-10-27 12:54:41.000000000 +0100
@@ -471,74 +471,11 @@ struct ieee80211_sub_if_data {
 	} u;
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	struct dentry *debugfsdir;
-	union {
-		struct {
-			struct dentry *drop_unencrypted;
-			struct dentry *bssid;
-			struct dentry *aid;
-			struct dentry *capab;
-			struct dentry *force_unicast_rateidx;
-			struct dentry *max_ratectrl_rateidx;
-		} sta;
-		struct {
-			struct dentry *drop_unencrypted;
-			struct dentry *num_sta_ps;
-			struct dentry *dtim_count;
-			struct dentry *force_unicast_rateidx;
-			struct dentry *max_ratectrl_rateidx;
-			struct dentry *num_buffered_multicast;
-		} ap;
-		struct {
-			struct dentry *drop_unencrypted;
-			struct dentry *peer;
-			struct dentry *force_unicast_rateidx;
-			struct dentry *max_ratectrl_rateidx;
-		} wds;
-		struct {
-			struct dentry *drop_unencrypted;
-			struct dentry *force_unicast_rateidx;
-			struct dentry *max_ratectrl_rateidx;
-		} vlan;
-		struct {
-			struct dentry *mode;
-		} monitor;
-	} debugfs;
 	struct {
+		struct dentry *dir;
 		struct dentry *default_key;
 		struct dentry *default_mgmt_key;
-	} common_debugfs;
-
-#ifdef CONFIG_MAC80211_MESH
-	struct dentry *mesh_stats_dir;
-	struct {
-		struct dentry *fwded_mcast;
-		struct dentry *fwded_unicast;
-		struct dentry *fwded_frames;
-		struct dentry *dropped_frames_ttl;
-		struct dentry *dropped_frames_no_route;
-		struct dentry *estab_plinks;
-		struct timer_list mesh_path_timer;
-	} mesh_stats;
-
-	struct dentry *mesh_config_dir;
-	struct {
-		struct dentry *dot11MeshRetryTimeout;
-		struct dentry *dot11MeshConfirmTimeout;
-		struct dentry *dot11MeshHoldingTimeout;
-		struct dentry *dot11MeshMaxRetries;
-		struct dentry *dot11MeshTTL;
-		struct dentry *auto_open_plinks;
-		struct dentry *dot11MeshMaxPeerLinks;
-		struct dentry *dot11MeshHWMPactivePathTimeout;
-		struct dentry *dot11MeshHWMPpreqMinInterval;
-		struct dentry *dot11MeshHWMPnetDiameterTraversalTime;
-		struct dentry *dot11MeshHWMPmaxPREQretries;
-		struct dentry *path_refresh_time;
-		struct dentry *min_discovery_timeout;
-	} mesh_config;
-#endif
-
+	} debugfs;
 #endif
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
@@ -818,53 +755,6 @@ struct ieee80211_local {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct local_debugfsdentries {
 		struct dentry *rcdir;
-		struct dentry *rcname;
-		struct dentry *frequency;
-		struct dentry *total_ps_buffered;
-		struct dentry *wep_iv;
-		struct dentry *tsf;
-		struct dentry *queues;
-		struct dentry *reset;
-		struct dentry *noack;
-		struct dentry *statistics;
-		struct local_debugfsdentries_statsdentries {
-			struct dentry *transmitted_fragment_count;
-			struct dentry *multicast_transmitted_frame_count;
-			struct dentry *failed_count;
-			struct dentry *retry_count;
-			struct dentry *multiple_retry_count;
-			struct dentry *frame_duplicate_count;
-			struct dentry *received_fragment_count;
-			struct dentry *multicast_received_frame_count;
-			struct dentry *transmitted_frame_count;
-			struct dentry *wep_undecryptable_count;
-			struct dentry *num_scans;
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-			struct dentry *tx_handlers_drop;
-			struct dentry *tx_handlers_queued;
-			struct dentry *tx_handlers_drop_unencrypted;
-			struct dentry *tx_handlers_drop_fragment;
-			struct dentry *tx_handlers_drop_wep;
-			struct dentry *tx_handlers_drop_not_assoc;
-			struct dentry *tx_handlers_drop_unauth_port;
-			struct dentry *rx_handlers_drop;
-			struct dentry *rx_handlers_queued;
-			struct dentry *rx_handlers_drop_nullfunc;
-			struct dentry *rx_handlers_drop_defrag;
-			struct dentry *rx_handlers_drop_short;
-			struct dentry *rx_handlers_drop_passive_scan;
-			struct dentry *tx_expand_skb_head;
-			struct dentry *tx_expand_skb_head_cloned;
-			struct dentry *rx_expand_skb_head;
-			struct dentry *rx_expand_skb_head2;
-			struct dentry *rx_handlers_fragments;
-			struct dentry *tx_status_drop;
-#endif
-			struct dentry *dot11ACKFailureCount;
-			struct dentry *dot11RTSFailureCount;
-			struct dentry *dot11FCSErrorCount;
-			struct dentry *dot11RTSSuccessCount;
-		} stats;
 		struct dentry *stations;
 		struct dentry *keys;
 	} debugfs;
--- wireless-testing.orig/net/mac80211/key.h	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/key.h	2009-10-27 12:27:57.000000000 +0100
@@ -118,18 +118,6 @@ struct ieee80211_key {
 	struct {
 		struct dentry *stalink;
 		struct dentry *dir;
-		struct dentry *keylen;
-		struct dentry *flags;
-		struct dentry *keyidx;
-		struct dentry *hw_key_idx;
-		struct dentry *tx_rx_count;
-		struct dentry *algorithm;
-		struct dentry *tx_spec;
-		struct dentry *rx_spec;
-		struct dentry *replays;
-		struct dentry *icverrors;
-		struct dentry *key;
-		struct dentry *ifindex;
 		int cnt;
 	} debugfs;
 #endif
--- wireless-testing.orig/net/mac80211/rate.c	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/rate.c	2009-10-27 12:27:57.000000000 +0100
@@ -163,8 +163,7 @@ struct rate_control_ref *rate_control_al
 #ifdef CONFIG_MAC80211_DEBUGFS
 	debugfsdir = debugfs_create_dir("rc", local->hw.wiphy->debugfsdir);
 	local->debugfs.rcdir = debugfsdir;
-	local->debugfs.rcname = debugfs_create_file("name", 0400, debugfsdir,
-						    ref, &rcname_ops);
+	debugfs_create_file("name", 0400, debugfsdir, ref, &rcname_ops);
 #endif
 
 	ref->priv = ref->ops->alloc(&local->hw, debugfsdir);
@@ -188,9 +187,7 @@ static void rate_control_release(struct 
 	ctrl_ref->ops->free(ctrl_ref->priv);
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-	debugfs_remove(ctrl_ref->local->debugfs.rcname);
-	ctrl_ref->local->debugfs.rcname = NULL;
-	debugfs_remove(ctrl_ref->local->debugfs.rcdir);
+	debugfs_remove_recursive(ctrl_ref->local->debugfs.rcdir);
 	ctrl_ref->local->debugfs.rcdir = NULL;
 #endif
 
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-10-27 12:27:57.000000000 +0100
@@ -301,28 +301,6 @@ struct sta_info {
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
 		struct dentry *dir;
-		struct dentry *flags;
-		struct dentry *num_ps_buf_frames;
-		struct dentry *inactive_ms;
-		struct dentry *last_seq_ctrl;
-		struct dentry *agg_status;
-		struct dentry *aid;
-		struct dentry *dev;
-		struct dentry *rx_packets;
-		struct dentry *tx_packets;
-		struct dentry *rx_bytes;
-		struct dentry *tx_bytes;
-		struct dentry *rx_duplicates;
-		struct dentry *rx_fragments;
-		struct dentry *rx_dropped;
-		struct dentry *tx_fragments;
-		struct dentry *tx_filtered;
-		struct dentry *tx_retry_failed;
-		struct dentry *tx_retry_count;
-		struct dentry *last_signal;
-		struct dentry *last_qual;
-		struct dentry *last_noise;
-		struct dentry *wep_weak_iv_count;
 		bool add_has_run;
 	} debugfs;
 #endif
--- wireless-testing.orig/net/mac80211/debugfs.c	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs.c	2009-10-27 12:54:32.000000000 +0100
@@ -1,3 +1,4 @@
+
 /*
  * mac80211 debugfs for wireless PHYs
  *
@@ -38,16 +39,10 @@ static const struct file_operations name
 };
 
 #define DEBUGFS_ADD(name)						\
-	local->debugfs.name = debugfs_create_file(#name, 0400, phyd,	\
-						  local, &name## _ops);
+	debugfs_create_file(#name, 0400, phyd, local, &name## _ops);
 
 #define DEBUGFS_ADD_MODE(name, mode)					\
-	local->debugfs.name = debugfs_create_file(#name, mode, phyd,	\
-						  local, &name## _ops);
-
-#define DEBUGFS_DEL(name)						\
-	debugfs_remove(local->debugfs.name);				\
-	local->debugfs.name = NULL;
+	debugfs_create_file(#name, mode, phyd, local, &name## _ops);
 
 
 DEBUGFS_READONLY_FILE(frequency, 20, "%d",
@@ -233,12 +228,7 @@ static const struct file_operations stat
 };
 
 #define DEBUGFS_STATS_ADD(name)						\
-	local->debugfs.stats.name = debugfs_create_file(#name, 0400, statsd,\
-		local, &stats_ ##name## _ops);
-
-#define DEBUGFS_STATS_DEL(name)						\
-	debugfs_remove(local->debugfs.stats.name);			\
-	local->debugfs.stats.name = NULL;
+	debugfs_create_file(#name, 0400, statsd, local, &stats_ ##name## _ops);
 
 DEBUGFS_STATS_FILE(transmitted_fragment_count, 20, "%u",
 		   local->dot11TransmittedFragmentCount);
@@ -326,7 +316,6 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_ADD(noack);
 
 	statsd = debugfs_create_dir("statistics", phyd);
-	local->debugfs.statistics = statsd;
 
 	/* if the dir failed, don't put all the other things into the root! */
 	if (!statsd)
@@ -367,57 +356,3 @@ void debugfs_hw_add(struct ieee80211_loc
 	DEBUGFS_STATS_ADD(dot11FCSErrorCount);
 	DEBUGFS_STATS_ADD(dot11RTSSuccessCount);
 }
-
-void debugfs_hw_del(struct ieee80211_local *local)
-{
-	DEBUGFS_DEL(frequency);
-	DEBUGFS_DEL(total_ps_buffered);
-	DEBUGFS_DEL(wep_iv);
-	DEBUGFS_DEL(tsf);
-	DEBUGFS_DEL(queues);
-	DEBUGFS_DEL(reset);
-	DEBUGFS_DEL(noack);
-
-	DEBUGFS_STATS_DEL(transmitted_fragment_count);
-	DEBUGFS_STATS_DEL(multicast_transmitted_frame_count);
-	DEBUGFS_STATS_DEL(failed_count);
-	DEBUGFS_STATS_DEL(retry_count);
-	DEBUGFS_STATS_DEL(multiple_retry_count);
-	DEBUGFS_STATS_DEL(frame_duplicate_count);
-	DEBUGFS_STATS_DEL(received_fragment_count);
-	DEBUGFS_STATS_DEL(multicast_received_frame_count);
-	DEBUGFS_STATS_DEL(transmitted_frame_count);
-	DEBUGFS_STATS_DEL(num_scans);
-#ifdef CONFIG_MAC80211_DEBUG_COUNTERS
-	DEBUGFS_STATS_DEL(tx_handlers_drop);
-	DEBUGFS_STATS_DEL(tx_handlers_queued);
-	DEBUGFS_STATS_DEL(tx_handlers_drop_unencrypted);
-	DEBUGFS_STATS_DEL(tx_handlers_drop_fragment);
-	DEBUGFS_STATS_DEL(tx_handlers_drop_wep);
-	DEBUGFS_STATS_DEL(tx_handlers_drop_not_assoc);
-	DEBUGFS_STATS_DEL(tx_handlers_drop_unauth_port);
-	DEBUGFS_STATS_DEL(rx_handlers_drop);
-	DEBUGFS_STATS_DEL(rx_handlers_queued);
-	DEBUGFS_STATS_DEL(rx_handlers_drop_nullfunc);
-	DEBUGFS_STATS_DEL(rx_handlers_drop_defrag);
-	DEBUGFS_STATS_DEL(rx_handlers_drop_short);
-	DEBUGFS_STATS_DEL(rx_handlers_drop_passive_scan);
-	DEBUGFS_STATS_DEL(tx_expand_skb_head);
-	DEBUGFS_STATS_DEL(tx_expand_skb_head_cloned);
-	DEBUGFS_STATS_DEL(rx_expand_skb_head);
-	DEBUGFS_STATS_DEL(rx_expand_skb_head2);
-	DEBUGFS_STATS_DEL(rx_handlers_fragments);
-	DEBUGFS_STATS_DEL(tx_status_drop);
-#endif
-	DEBUGFS_STATS_DEL(dot11ACKFailureCount);
-	DEBUGFS_STATS_DEL(dot11RTSFailureCount);
-	DEBUGFS_STATS_DEL(dot11FCSErrorCount);
-	DEBUGFS_STATS_DEL(dot11RTSSuccessCount);
-
-	debugfs_remove(local->debugfs.statistics);
-	local->debugfs.statistics = NULL;
-	debugfs_remove(local->debugfs.stations);
-	local->debugfs.stations = NULL;
-	debugfs_remove(local->debugfs.keys);
-	local->debugfs.keys = NULL;
-}
--- wireless-testing.orig/net/mac80211/debugfs_netdev.c	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_netdev.c	2009-10-27 12:27:57.000000000 +0100
@@ -152,9 +152,9 @@ IEEE80211_IF_FILE(min_discovery_timeout,
 #endif
 
 
-#define DEBUGFS_ADD(name, type)\
-	sdata->debugfs.type.name = debugfs_create_file(#name, 0400,\
-		sdata->debugfsdir, sdata, &name##_ops);
+#define DEBUGFS_ADD(name, type) \
+	debugfs_create_file(#name, 0400, sdata->debugfs.dir, \
+			    sdata, &name##_ops);
 
 static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 {
@@ -199,30 +199,32 @@ static void add_monitor_files(struct iee
 }
 
 #ifdef CONFIG_MAC80211_MESH
-#define MESHSTATS_ADD(name)\
-	sdata->mesh_stats.name = debugfs_create_file(#name, 0400,\
-		sdata->mesh_stats_dir, sdata, &name##_ops);
 
 static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 {
-	sdata->mesh_stats_dir = debugfs_create_dir("mesh_stats",
-				sdata->debugfsdir);
+	struct dentry *dir = debugfs_create_dir("mesh_stats",
+						sdata->debugfs.dir);
+
+#define MESHSTATS_ADD(name)\
+	debugfs_create_file(#name, 0400, dir, sdata, &name##_ops);
+
 	MESHSTATS_ADD(fwded_mcast);
 	MESHSTATS_ADD(fwded_unicast);
 	MESHSTATS_ADD(fwded_frames);
 	MESHSTATS_ADD(dropped_frames_ttl);
 	MESHSTATS_ADD(dropped_frames_no_route);
 	MESHSTATS_ADD(estab_plinks);
+#undef MESHSTATS_ADD
 }
 
-#define MESHPARAMS_ADD(name)\
-	sdata->mesh_config.name = debugfs_create_file(#name, 0600,\
-		sdata->mesh_config_dir, sdata, &name##_ops);
-
 static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 {
-	sdata->mesh_config_dir = debugfs_create_dir("mesh_config",
-				sdata->debugfsdir);
+	struct dentry *dir = debugfs_create_dir("mesh_config",
+						sdata->debugfs.dir);
+
+#define MESHPARAMS_ADD(name) \
+	debugfs_create_file(#name, 0600, dir, sdata, &name##_ops);
+
 	MESHPARAMS_ADD(dot11MeshMaxRetries);
 	MESHPARAMS_ADD(dot11MeshRetryTimeout);
 	MESHPARAMS_ADD(dot11MeshConfirmTimeout);
@@ -236,12 +238,14 @@ static void add_mesh_config(struct ieee8
 	MESHPARAMS_ADD(dot11MeshHWMPmaxPREQretries);
 	MESHPARAMS_ADD(path_refresh_time);
 	MESHPARAMS_ADD(min_discovery_timeout);
+
+#undef MESHPARAMS_ADD
 }
 #endif
 
 static void add_files(struct ieee80211_sub_if_data *sdata)
 {
-	if (!sdata->debugfsdir)
+	if (!sdata->debugfs.dir)
 		return;
 
 	switch (sdata->vif.type) {
@@ -274,134 +278,6 @@ static void add_files(struct ieee80211_s
 	}
 }
 
-#define DEBUGFS_DEL(name, type)					\
-	do {							\
-		debugfs_remove(sdata->debugfs.type.name);	\
-		sdata->debugfs.type.name = NULL;		\
-	} while (0)
-
-static void del_sta_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_DEL(drop_unencrypted, sta);
-	DEBUGFS_DEL(force_unicast_rateidx, sta);
-	DEBUGFS_DEL(max_ratectrl_rateidx, sta);
-
-	DEBUGFS_DEL(bssid, sta);
-	DEBUGFS_DEL(aid, sta);
-	DEBUGFS_DEL(capab, sta);
-}
-
-static void del_ap_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_DEL(drop_unencrypted, ap);
-	DEBUGFS_DEL(force_unicast_rateidx, ap);
-	DEBUGFS_DEL(max_ratectrl_rateidx, ap);
-
-	DEBUGFS_DEL(num_sta_ps, ap);
-	DEBUGFS_DEL(dtim_count, ap);
-	DEBUGFS_DEL(num_buffered_multicast, ap);
-}
-
-static void del_wds_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_DEL(drop_unencrypted, wds);
-	DEBUGFS_DEL(force_unicast_rateidx, wds);
-	DEBUGFS_DEL(max_ratectrl_rateidx, wds);
-
-	DEBUGFS_DEL(peer, wds);
-}
-
-static void del_vlan_files(struct ieee80211_sub_if_data *sdata)
-{
-	DEBUGFS_DEL(drop_unencrypted, vlan);
-	DEBUGFS_DEL(force_unicast_rateidx, vlan);
-	DEBUGFS_DEL(max_ratectrl_rateidx, vlan);
-}
-
-static void del_monitor_files(struct ieee80211_sub_if_data *sdata)
-{
-}
-
-#ifdef CONFIG_MAC80211_MESH
-#define MESHSTATS_DEL(name)			\
-	do {						\
-		debugfs_remove(sdata->mesh_stats.name);	\
-		sdata->mesh_stats.name = NULL;		\
-	} while (0)
-
-static void del_mesh_stats(struct ieee80211_sub_if_data *sdata)
-{
-	MESHSTATS_DEL(fwded_mcast);
-	MESHSTATS_DEL(fwded_unicast);
-	MESHSTATS_DEL(fwded_frames);
-	MESHSTATS_DEL(dropped_frames_ttl);
-	MESHSTATS_DEL(dropped_frames_no_route);
-	MESHSTATS_DEL(estab_plinks);
-	debugfs_remove(sdata->mesh_stats_dir);
-	sdata->mesh_stats_dir = NULL;
-}
-
-#define MESHPARAMS_DEL(name)			\
-	do {						\
-		debugfs_remove(sdata->mesh_config.name);	\
-		sdata->mesh_config.name = NULL;		\
-	} while (0)
-
-static void del_mesh_config(struct ieee80211_sub_if_data *sdata)
-{
-	MESHPARAMS_DEL(dot11MeshMaxRetries);
-	MESHPARAMS_DEL(dot11MeshRetryTimeout);
-	MESHPARAMS_DEL(dot11MeshConfirmTimeout);
-	MESHPARAMS_DEL(dot11MeshHoldingTimeout);
-	MESHPARAMS_DEL(dot11MeshTTL);
-	MESHPARAMS_DEL(auto_open_plinks);
-	MESHPARAMS_DEL(dot11MeshMaxPeerLinks);
-	MESHPARAMS_DEL(dot11MeshHWMPactivePathTimeout);
-	MESHPARAMS_DEL(dot11MeshHWMPpreqMinInterval);
-	MESHPARAMS_DEL(dot11MeshHWMPnetDiameterTraversalTime);
-	MESHPARAMS_DEL(dot11MeshHWMPmaxPREQretries);
-	MESHPARAMS_DEL(path_refresh_time);
-	MESHPARAMS_DEL(min_discovery_timeout);
-	debugfs_remove(sdata->mesh_config_dir);
-	sdata->mesh_config_dir = NULL;
-}
-#endif
-
-static void del_files(struct ieee80211_sub_if_data *sdata)
-{
-	if (!sdata->debugfsdir)
-		return;
-
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_MESH_POINT:
-#ifdef CONFIG_MAC80211_MESH
-		del_mesh_stats(sdata);
-		del_mesh_config(sdata);
-#endif
-		break;
-	case NL80211_IFTYPE_STATION:
-		del_sta_files(sdata);
-		break;
-	case NL80211_IFTYPE_ADHOC:
-		/* XXX */
-		break;
-	case NL80211_IFTYPE_AP:
-		del_ap_files(sdata);
-		break;
-	case NL80211_IFTYPE_WDS:
-		del_wds_files(sdata);
-		break;
-	case NL80211_IFTYPE_MONITOR:
-		del_monitor_files(sdata);
-		break;
-	case NL80211_IFTYPE_AP_VLAN:
-		del_vlan_files(sdata);
-		break;
-	default:
-		break;
-	}
-}
-
 static int notif_registered;
 
 void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
@@ -412,16 +288,18 @@ void ieee80211_debugfs_add_netdev(struct
 		return;
 
 	sprintf(buf, "netdev:%s", sdata->dev->name);
-	sdata->debugfsdir = debugfs_create_dir(buf,
+	sdata->debugfs.dir = debugfs_create_dir(buf,
 		sdata->local->hw.wiphy->debugfsdir);
 	add_files(sdata);
 }
 
 void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 {
-	del_files(sdata);
-	debugfs_remove(sdata->debugfsdir);
-	sdata->debugfsdir = NULL;
+	if (!sdata->debugfs.dir)
+		return;
+
+	debugfs_remove_recursive(sdata->debugfs.dir);
+	sdata->debugfs.dir = NULL;
 }
 
 static int netdev_notify(struct notifier_block *nb,
@@ -444,7 +322,7 @@ static int netdev_notify(struct notifier
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	dir = sdata->debugfsdir;
+	dir = sdata->debugfs.dir;
 
 	if (!dir)
 		return 0;
--- wireless-testing.orig/net/mac80211/debugfs_key.c	2009-10-27 12:27:57.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs_key.c	2009-10-27 12:27:57.000000000 +0100
@@ -225,8 +225,8 @@ static ssize_t key_key_read(struct file 
 KEY_OPS(key);
 
 #define DEBUGFS_ADD(name) \
-	key->debugfs.name = debugfs_create_file(#name, 0400,\
-				key->debugfs.dir, key, &key_##name##_ops);
+	debugfs_create_file(#name, 0400, key->debugfs.dir, \
+			    key, &key_##name##_ops);
 
 void ieee80211_debugfs_key_add(struct ieee80211_key *key)
   {
@@ -271,30 +271,12 @@ void ieee80211_debugfs_key_add(struct ie
 	DEBUGFS_ADD(ifindex);
 };
 
-#define DEBUGFS_DEL(name) \
-	debugfs_remove(key->debugfs.name); key->debugfs.name = NULL;
-
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
 {
 	if (!key)
 		return;
 
-	DEBUGFS_DEL(keylen);
-	DEBUGFS_DEL(flags);
-	DEBUGFS_DEL(keyidx);
-	DEBUGFS_DEL(hw_key_idx);
-	DEBUGFS_DEL(tx_rx_count);
-	DEBUGFS_DEL(algorithm);
-	DEBUGFS_DEL(tx_spec);
-	DEBUGFS_DEL(rx_spec);
-	DEBUGFS_DEL(replays);
-	DEBUGFS_DEL(icverrors);
-	DEBUGFS_DEL(key);
-	DEBUGFS_DEL(ifindex);
-
-	debugfs_remove(key->debugfs.stalink);
-	key->debugfs.stalink = NULL;
-	debugfs_remove(key->debugfs.dir);
+	debugfs_remove_recursive(key->debugfs.dir);
 	key->debugfs.dir = NULL;
 }
 void ieee80211_debugfs_key_add_default(struct ieee80211_sub_if_data *sdata)
@@ -302,7 +284,7 @@ void ieee80211_debugfs_key_add_default(s
 	char buf[50];
 	struct ieee80211_key *key;
 
-	if (!sdata->debugfsdir)
+	if (!sdata->debugfs.dir)
 		return;
 
 	/* this is running under the key lock */
@@ -310,9 +292,9 @@ void ieee80211_debugfs_key_add_default(s
 	key = sdata->default_key;
 	if (key) {
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
-		sdata->common_debugfs.default_key =
+		sdata->debugfs.default_key =
 			debugfs_create_symlink("default_key",
-					       sdata->debugfsdir, buf);
+					       sdata->debugfs.dir, buf);
 	} else
 		ieee80211_debugfs_key_remove_default(sdata);
 }
@@ -322,8 +304,8 @@ void ieee80211_debugfs_key_remove_defaul
 	if (!sdata)
 		return;
 
-	debugfs_remove(sdata->common_debugfs.default_key);
-	sdata->common_debugfs.default_key = NULL;
+	debugfs_remove(sdata->debugfs.default_key);
+	sdata->debugfs.default_key = NULL;
 }
 
 void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
@@ -331,7 +313,7 @@ void ieee80211_debugfs_key_add_mgmt_defa
 	char buf[50];
 	struct ieee80211_key *key;
 
-	if (!sdata->debugfsdir)
+	if (!sdata->debugfs.dir)
 		return;
 
 	/* this is running under the key lock */
@@ -339,9 +321,9 @@ void ieee80211_debugfs_key_add_mgmt_defa
 	key = sdata->default_mgmt_key;
 	if (key) {
 		sprintf(buf, "../keys/%d", key->debugfs.cnt);
-		sdata->common_debugfs.default_mgmt_key =
+		sdata->debugfs.default_mgmt_key =
 			debugfs_create_symlink("default_mgmt_key",
-					       sdata->debugfsdir, buf);
+					       sdata->debugfs.dir, buf);
 	} else
 		ieee80211_debugfs_key_remove_mgmt_default(sdata);
 }
@@ -351,8 +333,8 @@ void ieee80211_debugfs_key_remove_mgmt_d
 	if (!sdata)
 		return;
 
-	debugfs_remove(sdata->common_debugfs.default_mgmt_key);
-	sdata->common_debugfs.default_mgmt_key = NULL;
+	debugfs_remove(sdata->debugfs.default_mgmt_key);
+	sdata->debugfs.default_mgmt_key = NULL;
 }
 
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
--- wireless-testing.orig/net/wireless/core.c	2009-10-27 12:42:33.000000000 +0100
+++ wireless-testing/net/wireless/core.c	2009-10-27 12:50:59.000000000 +0100
@@ -547,7 +547,7 @@ void wiphy_unregister(struct wiphy *wiph
 	 * First remove the hardware from everywhere, this makes
 	 * it impossible to find from userspace.
 	 */
-	cfg80211_debugfs_rdev_del(rdev);
+	debugfs_remove_recursive(rdev->wiphy.debugfsdir);
 	list_del(&rdev->list);
 
 	/*
@@ -570,7 +570,6 @@ void wiphy_unregister(struct wiphy *wiph
 
 	cfg80211_rdev_list_generation++;
 	device_del(&rdev->wiphy.dev);
-	debugfs_remove(rdev->wiphy.debugfsdir);
 
 	mutex_unlock(&cfg80211_mutex);
 
--- wireless-testing.orig/net/mac80211/debugfs.h	2009-10-27 12:46:08.000000000 +0100
+++ wireless-testing/net/mac80211/debugfs.h	2009-10-27 12:46:12.000000000 +0100
@@ -3,14 +3,12 @@
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 extern void debugfs_hw_add(struct ieee80211_local *local);
-extern void debugfs_hw_del(struct ieee80211_local *local);
 extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
 #else
 static inline void debugfs_hw_add(struct ieee80211_local *local)
 {
 	return;
 }
-static inline void debugfs_hw_del(struct ieee80211_local *local) {}
 #endif
 
 #endif /* __MAC80211_DEBUGFS_H */
--- wireless-testing.orig/net/mac80211/main.c	2009-10-27 12:46:23.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-10-27 12:46:27.000000000 +0100
@@ -923,7 +923,6 @@ int ieee80211_register_hw(struct ieee802
  fail_wep:
 	sta_info_stop(local);
  fail_sta_info:
-	debugfs_hw_del(local);
 	destroy_workqueue(local->workqueue);
  fail_workqueue:
 	wiphy_unregister(local->hw.wiphy);
@@ -959,7 +958,6 @@ void ieee80211_unregister_hw(struct ieee
 	ieee80211_clear_tx_pending(local);
 	sta_info_stop(local);
 	rate_control_deinitialize(local);
-	debugfs_hw_del(local);
 
 	if (skb_queue_len(&local->skb_queue)
 			|| skb_queue_len(&local->skb_queue_unreliable))
--- wireless-testing.orig/net/wireless/core.h	2009-10-27 12:49:32.000000000 +0100
+++ wireless-testing/net/wireless/core.h	2009-10-27 12:49:42.000000000 +0100
@@ -72,17 +72,6 @@ struct cfg80211_registered_device {
 	/* current channel */
 	struct ieee80211_channel *channel;
 
-#ifdef CONFIG_CFG80211_DEBUGFS
-	/* Debugfs entries */
-	struct wiphy_debugfsdentries {
-		struct dentry *rts_threshold;
-		struct dentry *fragmentation_threshold;
-		struct dentry *short_retry_limit;
-		struct dentry *long_retry_limit;
-		struct dentry *ht40allow_map;
-	} debugfs;
-#endif
-
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __attribute__((__aligned__(NETDEV_ALIGN)));
--- wireless-testing.orig/net/wireless/debugfs.c	2009-10-27 12:50:02.000000000 +0100
+++ wireless-testing/net/wireless/debugfs.c	2009-10-27 12:50:22.000000000 +0100
@@ -104,11 +104,7 @@ static const struct file_operations ht40
 };
 
 #define DEBUGFS_ADD(name)						\
-	rdev->debugfs.name = debugfs_create_file(#name, S_IRUGO, phyd,	\
-						  &rdev->wiphy, &name## _ops);
-#define DEBUGFS_DEL(name)						\
-	debugfs_remove(rdev->debugfs.name);				\
-	rdev->debugfs.name = NULL;
+	debugfs_create_file(#name, S_IRUGO, phyd, &rdev->wiphy, &name## _ops);
 
 void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev)
 {
@@ -120,12 +116,3 @@ void cfg80211_debugfs_rdev_add(struct cf
 	DEBUGFS_ADD(long_retry_limit);
 	DEBUGFS_ADD(ht40allow_map);
 }
-
-void cfg80211_debugfs_rdev_del(struct cfg80211_registered_device *rdev)
-{
-	DEBUGFS_DEL(rts_threshold);
-	DEBUGFS_DEL(fragmentation_threshold);
-	DEBUGFS_DEL(short_retry_limit);
-	DEBUGFS_DEL(long_retry_limit);
-	DEBUGFS_DEL(ht40allow_map);
-}
--- wireless-testing.orig/net/wireless/debugfs.h	2009-10-27 12:50:28.000000000 +0100
+++ wireless-testing/net/wireless/debugfs.h	2009-10-27 12:50:32.000000000 +0100
@@ -3,12 +3,9 @@
 
 #ifdef CONFIG_CFG80211_DEBUGFS
 void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev);
-void cfg80211_debugfs_rdev_del(struct cfg80211_registered_device *rdev);
 #else
 static inline
 void cfg80211_debugfs_rdev_add(struct cfg80211_registered_device *rdev) {}
-static inline
-void cfg80211_debugfs_rdev_del(struct cfg80211_registered_device *rdev) {}
 #endif
 
 #endif /* __CFG80211_DEBUGFS_H */


