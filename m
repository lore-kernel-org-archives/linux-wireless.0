Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63924 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab2CaSbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 14:31:51 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so816411dak.11
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 11:31:51 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>,
	Pavel Zubarev <pavel.zubarev@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] mac80211: Implement mesh synchronization framework
Date: Sat, 31 Mar 2012 11:31:32 -0700
Message-Id: <1333218693-30093-4-git-send-email-javier@cozybit.com> (sfid-20120331_203155_476982_186BEA59)
In-Reply-To: <1333218693-30093-1-git-send-email-javier@cozybit.com>
References: <1333218693-30093-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds MBSS extensible synchronization framework (Sec.
13.13.2 of IEEE Std. 802.11-2012).

The framework is implemented via an ops table which defines the
following functions:

    rx_bcn_presp() - this is called every time a mesh beacon is
received.
    adjust_tbtt() - this is called immediately before a beacon is about
to be transmitted.

The default neighbor offset synchronization defined in the standard is
implemented.  We also provide template functions for vendor specific
methods.

When neighbor offset synchronization is active (which is the default)
mesh neighbors in the same MBSS will track timing offsets to each other
and compensate clock drift.

In our tests we observed that this mesh synchronization implementation
successfully corrected drifts between stations of ~2PPM while
introducing a jitter of ~20us.

It is also possible to test this framework on mac80211_hwsim simulated
phys to see how it behaves under different topologies, over poor links,
etc.

Signed-off-by: Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
Signed-off-by: Pavel Zubarev <pavel.zubarev@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h  |   12 ++
 net/mac80211/Kconfig       |   11 ++
 net/mac80211/Makefile      |    3 +-
 net/mac80211/debugfs_sta.c |    5 +-
 net/mac80211/ieee80211_i.h |   23 ++++
 net/mac80211/mesh.c        |   21 +++-
 net/mac80211/mesh.h        |   19 +++
 net/mac80211/mesh_sync.c   |  296 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.h    |    5 +
 net/mac80211/tx.c          |    5 +
 10 files changed, 392 insertions(+), 8 deletions(-)
 create mode 100644 net/mac80211/mesh_sync.c

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index e8f75af..1f83d0e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1441,6 +1441,18 @@ enum ieee80211_tdls_actioncode {
 #define WLAN_TDLS_SNAP_RFTYPE	0x2
 
 /**
+ * enum - mesh synchronization method identifier
+ *
+ * @IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET: the default synchronization method
+ * @IEEE80211_SYNC_METHOD_VENDOR: a vendor specific synchronization method
+ * that will be specified in a vendor specific information element
+ */
+enum {
+	IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET = 1,
+	IEEE80211_SYNC_METHOD_VENDOR = 255,
+};
+
+/**
  * enum - mesh path selection protocol identifier
  *
  * @IEEE80211_PATH_PROTOCOL_HWMP: the default path selection protocol
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 96ddb72..8d249d7 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -225,6 +225,17 @@ config MAC80211_VERBOSE_MHWMP_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_VERBOSE_MESH_SYNC_DEBUG
+	bool "Verbose mesh mesh synchronization debugging"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_MESH
+	---help---
+	  Selecting this option causes mac80211 to print out very verbose mesh
+	  synchronization debugging messages (when mac80211 is taking part in a
+	  mesh network).
+
+	  Do not select this option.
+
 config MAC80211_VERBOSE_TDLS_DEBUG
 	bool "Verbose TDLS debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 1be7a45..3e9d931 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -38,7 +38,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh.o \
 	mesh_pathtbl.o \
 	mesh_plink.o \
-	mesh_hwmp.o
+	mesh_hwmp.o \
+	mesh_sync.o
 
 mac80211-$(CONFIG_PM) += pm.o
 
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 6d45804..ceeefd4 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -63,7 +63,7 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
@@ -71,7 +71,8 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
 			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
-			    TEST(INSERTED), TEST(RATE_CONTROL));
+			    TEST(INSERTED), TEST(RATE_CONTROL),
+			    TEST(TOFFSET_KNOWN));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d9798a3..19ddbf8 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -552,6 +552,24 @@ struct ieee80211_if_ibss {
 	} state;
 };
 
+/**
+ * struct ieee80211_mesh_sync_ops - Extensible synchronization framework interface
+ *
+ * these declarations define the interface, which enables
+ * vendor-specific mesh synchronization
+ *
+ */
+struct ieee802_11_elems;
+struct ieee80211_mesh_sync_ops {
+	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
+			     u16 stype,
+			     struct ieee80211_mgmt *mgmt,
+			     struct ieee802_11_elems *elems,
+			     struct ieee80211_rx_status *rx_status);
+	void (*adjust_tbtt)(struct ieee80211_sub_if_data *sdata);
+	/* add other framework functions here */
+};
+
 struct ieee80211_if_mesh {
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
@@ -600,6 +618,11 @@ struct ieee80211_if_mesh {
 		IEEE80211_MESH_SEC_AUTHED = 0x1,
 		IEEE80211_MESH_SEC_SECURED = 0x2,
 	} security;
+	/* Extensible Synchronization Framework */
+	struct ieee80211_mesh_sync_ops *sync_ops;
+	s64 sync_offset_clockdrift_max;
+	spinlock_t sync_offset_lock;
+	bool adjusting_tbtt;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index e5fbb7c..aadd0b3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -13,9 +13,6 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
-#define MESHCONF_CAPAB_ACCEPT_PLINKS 0x01
-#define MESHCONF_CAPAB_FORWARDING    0x08
-
 #define TMR_RUNNING_HK	0
 #define TMR_RUNNING_MP	1
 #define TMR_RUNNING_MPR	2
@@ -251,8 +248,10 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	/* Mesh capability */
 	ifmsh->accepting_plinks = mesh_plink_availables(sdata);
 	*pos = MESHCONF_CAPAB_FORWARDING;
-	*pos++ |= ifmsh->accepting_plinks ?
+	*pos |= ifmsh->accepting_plinks ?
 	    MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
+	*pos++ |= ifmsh->adjusting_tbtt ?
+	    MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;
 	*pos++ = 0x00;
 
 	return 0;
@@ -573,8 +572,11 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_configure_filter(local);
 
 	ifmsh->mesh_cc_id = 0;	/* Disabled */
-	ifmsh->mesh_sp_id = 0;	/* Neighbor Offset */
 	ifmsh->mesh_auth_id = 0;	/* Disabled */
+	/* register sync ops from extensible synchronization framework */
+	ifmsh->sync_ops = ieee80211_mesh_sync_ops_get(ifmsh->mesh_sp_id);
+	ifmsh->adjusting_tbtt = false;
+	ifmsh->sync_offset_clockdrift_max = 0;
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
@@ -616,6 +618,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
 	u32 supp_rates = 0;
@@ -654,6 +657,10 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
 		mesh_neighbour_update(mgmt->sa, supp_rates, sdata, &elems);
 	}
+
+	if (ifmsh->sync_ops)
+		ifmsh->sync_ops->rx_bcn_presp(sdata,
+			stype, mgmt, &elems, rx_status);
 }
 
 static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
@@ -721,6 +728,9 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 
 	if (test_and_clear_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags))
 		ieee80211_mesh_rootpath(sdata);
+
+	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
+		mesh_sync_adjust_tbtt(sdata);
 }
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
@@ -761,4 +771,5 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		    (unsigned long) sdata);
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
+	spin_lock_init(&ifmsh->sync_offset_lock);
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8d53b71..0eebc7d 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -19,6 +19,20 @@
 /* Data structures */
 
 /**
+ * enum mesh_config_capab_flags - mesh config IE capability flags
+ *
+ * @MESHCONF_CAPAB_ACCEPT_PLINKS: STA is willing to establish
+ * additional mesh peerings with other mesh STAs
+ * @MESHCONF_CAPAB_FORWARDING: the STA forwards MSDUs
+ * @MESHCONF_CAPAB_TBTT_ADJUSTING: TBTT adjustment procedure is ongoing
+ */
+enum mesh_config_capab_flags {
+	MESHCONF_CAPAB_ACCEPT_PLINKS = BIT(0),
+	MESHCONF_CAPAB_FORWARDING = BIT(3),
+	MESHCONF_CAPAB_TBTT_ADJUSTING = BIT(5),
+};
+
+/**
  * enum mesh_path_flags - mac80211 mesh path flags
  *
  *
@@ -56,12 +70,15 @@ enum mesh_path_flags {
  * @MESH_WORK_GROW_MPP_TABLE: the mesh portals table is full and needs to
  * grow
  * @MESH_WORK_ROOT: the mesh root station needs to send a frame
+ * @MESH_WORK_DRIFT_ADJUST: time to compensate for clock drift relative to other
+ * mesh nodes
  */
 enum mesh_deferred_task_flags {
 	MESH_WORK_HOUSEKEEPING,
 	MESH_WORK_GROW_MPATH_TABLE,
 	MESH_WORK_GROW_MPP_TABLE,
 	MESH_WORK_ROOT,
+	MESH_WORK_DRIFT_ADJUST,
 };
 
 /**
@@ -232,6 +249,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
+struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
@@ -325,6 +343,7 @@ void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
 void mesh_plink_quiesce(struct sta_info *sta);
 void mesh_plink_restart(struct sta_info *sta);
+void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 #else
 #define mesh_allocated	0
 static inline void
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
new file mode 100644
index 0000000..f78b013
--- /dev/null
+++ b/net/mac80211/mesh_sync.c
@@ -0,0 +1,296 @@
+/*
+ * Copyright 2011-2012, Pavel Zubarev <pavel.zubarev@gmail.com>
+ * Copyright 2011-2012, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
+ * Copyright 2011-2012, cozybit Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ieee80211_i.h"
+#include "mesh.h"
+#include "driver-ops.h"
+
+#ifdef CONFIG_MAC80211_VERBOSE_MESH_SYNC_DEBUG
+#define msync_dbg(fmt, args...) \
+	printk(KERN_DEBUG "Mesh sync (%s): " fmt "\n", sdata->name, ##args)
+#else
+#define msync_dbg(fmt, args...)   do { (void)(0); } while (0)
+#endif
+
+/* This is not in the standard.  It represents a tolerable tbtt drift below
+ * which we do no TSF adjustment.
+ */
+#define TBTT_MINIMUM_ADJUSTMENT 10
+
+struct sync_method {
+	u8 method;
+	struct ieee80211_mesh_sync_ops ops;
+};
+
+/**
+ * mesh_peer_tbtt_adjusting - check if an mp is currently adjusting its TBTT
+ *
+ * @ie: information elements of a management frame from the mesh peer
+ */
+static bool mesh_peer_tbtt_adjusting(struct ieee802_11_elems *ie)
+{
+	return (ie->mesh_config->meshconf_cap &
+	    MESHCONF_CAPAB_TBTT_ADJUSTING) != 0;
+}
+
+void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	/* sdata->vif.bss_conf.beacon_int in 1024us units, 0.04% */
+	u64 beacon_int_fraction = sdata->vif.bss_conf.beacon_int * 1024 / 2500;
+	u64 tsf;
+	u64 tsfdelta;
+
+	spin_lock_bh(&ifmsh->sync_offset_lock);
+
+	if (ifmsh->sync_offset_clockdrift_max < beacon_int_fraction) {
+		msync_dbg("TBTT : max clockdrift=%lld; adjusting",
+			(long long) ifmsh->sync_offset_clockdrift_max);
+		tsfdelta = -ifmsh->sync_offset_clockdrift_max;
+		ifmsh->sync_offset_clockdrift_max = 0;
+	} else {
+		msync_dbg("TBTT : max clockdrift=%lld; adjusting by %llu",
+			(long long) ifmsh->sync_offset_clockdrift_max,
+			(unsigned long long) beacon_int_fraction);
+		tsfdelta = -beacon_int_fraction;
+		ifmsh->sync_offset_clockdrift_max -= beacon_int_fraction;
+	}
+
+	tsf = drv_get_tsf(local, sdata);
+	if (tsf != -1ULL)
+		drv_set_tsf(local, sdata, tsf + tsfdelta);
+	spin_unlock_bh(&ifmsh->sync_offset_lock);
+}
+
+static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
+				   u16 stype,
+				   struct ieee80211_mgmt *mgmt,
+				   struct ieee802_11_elems *elems,
+				   struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta;
+	u64 t_t, t_r;
+
+	WARN_ON(ifmsh->mesh_sp_id != IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
+
+	/* standard mentions only beacons */
+	if (stype != IEEE80211_STYPE_BEACON)
+		return;
+
+	/* The current tsf is a first approximation for the timestamp
+	 * for the received beacon.  Further down we try to get a
+	 * better value from the rx_status->mactime field if
+	 * available. Also we have to call drv_get_tsf() before
+	 * entering the rcu-read section.*/
+	t_r = drv_get_tsf(local, sdata);
+
+	rcu_read_lock();
+	sta = sta_info_get(sdata, mgmt->sa);
+	if (!sta)
+		goto no_sync;
+
+	/* check offset sync conditions (13.13.2.2.1)
+	 *
+	 * TODO also sync to
+	 * dot11MeshNbrOffsetMaxNeighbor non-peer non-MBSS neighbors
+	 */
+
+	if (elems->mesh_config && mesh_peer_tbtt_adjusting(elems)) {
+		clear_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
+		msync_dbg("STA %pM : is adjusting TBTT", sta->sta.addr);
+		goto no_sync;
+	}
+
+	if (rx_status->flag & RX_FLAG_MACTIME_MPDU && rx_status->mactime) {
+		/*
+		 * The mactime is defined as the time the first data symbol
+		 * of the frame hits the PHY, and the timestamp of the beacon
+		 * is defined as "the time that the data symbol containing the
+		 * first bit of the timestamp is transmitted to the PHY plus
+		 * the transmitting STA's delays through its local PHY from the
+		 * MAC-PHY interface to its interface with the WM" (802.11
+		 * 11.1.2)
+		 *
+		 * T_r, in 13.13.2.2.2, is just defined as "the frame reception
+		 * time" but we unless we interpret that time to be the same
+		 * time of the beacon timestamp, the offset calculation will be
+		 * off.  Below we adjust t_r to be "the time at which the first
+		 * symbol of the timestamp element in the beacon is received".
+		 * This correction depends on the rate.
+		 *
+		 * Based on similar code in ibss.c
+		 */
+		int rate;
+
+		if (rx_status->flag & RX_FLAG_HT) {
+			/* TODO:
+			 * In principle there could be HT-beacons (Dual Beacon
+			 * HT Operation options), but for now ignore them and
+			 * just use the primary (i.e. non-HT) beacons for
+			 * synchronization.
+			 * */
+			goto no_sync;
+		} else
+			rate = local->hw.wiphy->bands[rx_status->band]->
+				bitrates[rx_status->rate_idx].bitrate;
+
+		/* 24 bytes of header * 8 bits/byte *
+		 * 10*(100 Kbps)/Mbps / rate (100 Kbps)*/
+		t_r = rx_status->mactime + (24 * 8 * 10 / rate);
+	}
+
+	/* Timing offset calculation (see 13.13.2.2.2) */
+	t_t = le64_to_cpu(mgmt->u.beacon.timestamp);
+	sta->t_offset = t_t - t_r;
+
+	if (test_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN)) {
+		s64 t_clockdrift = sta->t_offset_setpoint
+				   - sta->t_offset;
+
+		msync_dbg("STA %pM : sta->t_offset=%lld,"
+			  " sta->t_offset_setpoint=%lld,"
+			  " t_clockdrift=%lld",
+			  sta->sta.addr,
+			  (long long) sta->t_offset,
+			  (long long)
+			  sta->t_offset_setpoint,
+			  (long long) t_clockdrift);
+		rcu_read_unlock();
+
+		spin_lock_bh(&ifmsh->sync_offset_lock);
+		if (t_clockdrift >
+		    ifmsh->sync_offset_clockdrift_max)
+			ifmsh->sync_offset_clockdrift_max
+				= t_clockdrift;
+		spin_unlock_bh(&ifmsh->sync_offset_lock);
+
+	} else {
+		sta->t_offset_setpoint = sta->t_offset;
+		set_sta_flag(sta, WLAN_STA_TOFFSET_KNOWN);
+		msync_dbg("STA %pM : offset was invalid, "
+			  " sta->t_offset=%lld",
+			  sta->sta.addr,
+			  (long long) sta->t_offset);
+		rcu_read_unlock();
+	}
+	return;
+
+no_sync:
+	rcu_read_unlock();
+}
+
+static void mesh_sync_offset_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	WARN_ON(ifmsh->mesh_sp_id
+		!= IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET);
+	BUG_ON(!rcu_read_lock_held());
+
+	spin_lock_bh(&ifmsh->sync_offset_lock);
+
+	if (ifmsh->sync_offset_clockdrift_max >
+		TBTT_MINIMUM_ADJUSTMENT) {
+		/* Since ajusting the tsf here would
+		 * require a possibly blocking call
+		 * to the driver tsf setter, we punt
+		 * the tsf adjustment to the mesh tasklet
+		 */
+		msync_dbg("TBTT : kicking off TBTT "
+			  "adjustment with "
+			  "clockdrift_max=%lld",
+		  ifmsh->sync_offset_clockdrift_max);
+		set_bit(MESH_WORK_DRIFT_ADJUST,
+			&ifmsh->wrkq_flags);
+	} else {
+		msync_dbg("TBTT : max clockdrift=%lld; "
+			  "too small to adjust",
+			  (long long)
+		       ifmsh->sync_offset_clockdrift_max);
+		ifmsh->sync_offset_clockdrift_max = 0;
+	}
+	spin_unlock_bh(&ifmsh->sync_offset_lock);
+}
+
+static const u8 *mesh_get_vendor_oui(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 offset;
+
+	if (!ifmsh->ie || !ifmsh->ie_len)
+		return NULL;
+
+	offset = ieee80211_ie_split_vendor(ifmsh->ie,
+					ifmsh->ie_len, 0);
+
+	if (!offset)
+		return NULL;
+
+	return ifmsh->ie + offset + 2;
+}
+
+static void mesh_sync_vendor_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
+				   u16 stype,
+				   struct ieee80211_mgmt *mgmt,
+				   struct ieee802_11_elems *elems,
+				   struct ieee80211_rx_status *rx_status)
+{
+	const u8 *oui;
+
+	WARN_ON(sdata->u.mesh.mesh_sp_id != IEEE80211_SYNC_METHOD_VENDOR);
+	msync_dbg("called mesh_sync_vendor_rx_bcn_presp");
+	oui = mesh_get_vendor_oui(sdata);
+	/*  here you would implement the vendor offset tracking for this oui */
+}
+
+static void mesh_sync_vendor_adjust_tbtt(struct ieee80211_sub_if_data *sdata)
+{
+	const u8 *oui;
+
+	WARN_ON(sdata->u.mesh.mesh_sp_id != IEEE80211_SYNC_METHOD_VENDOR);
+	msync_dbg("called mesh_sync_vendor_adjust_tbtt");
+	oui = mesh_get_vendor_oui(sdata);
+	/*  here you would implement the vendor tsf adjustment for this oui */
+}
+
+/* global variable */
+static struct sync_method sync_methods[] = {
+	{
+		.method = IEEE80211_SYNC_METHOD_NEIGHBOR_OFFSET,
+		.ops = {
+			.rx_bcn_presp = &mesh_sync_offset_rx_bcn_presp,
+			.adjust_tbtt = &mesh_sync_offset_adjust_tbtt,
+		}
+	},
+	{
+		.method = IEEE80211_SYNC_METHOD_VENDOR,
+		.ops = {
+			.rx_bcn_presp = &mesh_sync_vendor_rx_bcn_presp,
+			.adjust_tbtt = &mesh_sync_vendor_adjust_tbtt,
+		}
+	},
+};
+
+struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method)
+{
+	struct ieee80211_mesh_sync_ops *ops = NULL;
+	u8 i;
+
+	for (i = 0 ; i < ARRAY_SIZE(sync_methods); ++i) {
+		if (sync_methods[i].method == method) {
+			ops = &sync_methods[i].ops;
+			break;
+		}
+	}
+	return ops;
+}
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index ab05768..58faa738 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -55,6 +55,7 @@
  * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
  * @WLAN_STA_INSERTED: This station is inserted into the hash table.
  * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
+ * @WLAN_STA_TOFFSET_KNOWN: toffset calculated for this station is valid.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -76,6 +77,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_4ADDR_EVENT,
 	WLAN_STA_INSERTED,
 	WLAN_STA_RATE_CONTROL,
+	WLAN_STA_TOFFSET_KNOWN,
 };
 
 #define STA_TID_NUM 16
@@ -264,6 +266,7 @@ struct sta_ampdu_mlme {
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
  * @plink_timer_was_running: used by suspend/resume to restore timers
+ * @t_offset: timing offset relative to this host
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -353,6 +356,8 @@ struct sta_info {
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
+	s64 t_offset;
+	s64 t_offset_setpoint;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 782a601..2df806a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2374,6 +2374,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 						 IEEE80211_STYPE_BEACON);
 	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
 		struct ieee80211_mgmt *mgmt;
+		struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 		u8 *pos;
 		int hdr_len = offsetof(struct ieee80211_mgmt, u.beacon) +
 			      sizeof(mgmt->u.beacon);
@@ -2383,6 +2384,10 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 			goto out;
 #endif
 
+		if (ifmsh->sync_ops)
+			ifmsh->sync_ops->adjust_tbtt(
+						sdata);
+
 		skb = dev_alloc_skb(local->tx_headroom +
 				    hdr_len +
 				    2 + /* NULL SSID */
-- 
1.7.5.4

