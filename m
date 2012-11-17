Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:48658 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2KQGsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 01:48:40 -0500
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
To: johannes@sipsolutions.net, javier@cozybit.com
Cc: linux-wireless@vger.kernel.org,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [RFC 04/14] mac80211: local link-specific mesh power mode logic
Date: Fri, 16 Nov 2012 22:47:56 -0800
Message-Id: <1353134886-13256-5-git-send-email-marco.porsch@etit.tu-chemnitz.de> (sfid-20121117_074845_174575_DFF0FC6F)
In-Reply-To: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to IEEE802.11-2012 a mesh peering is always associated between
two mesh STAs. Both mesh STAs have their own mesh power mode for the
mesh peering. This power mode is called the link-specific power mode.
The local_ps_mode field has been added to sta_info structure to represent
the link-specific power mode at this station for the station represented
by this structure.

When a peer link is established, the local link-specific power mode is
set up equal to the user-configured default power mode. To allow
successful peering, 802.11s defines that the non-peer power mode is
temporarily set to active mode during peering.

The status of the local peer-specific power modes is monitored for
mesh power mode indication and for checking if the radio may be set
to doze state. The PS status is also updated if the peering status
of a neighbor changes.

According to IEEE802.11-2012 a mesh STA maintains a mesh power mode
for non-peer mesh STAs. The non-peer mesh power mode determines when
non-peer mesh STAs may send Probe Request and Mesh Peering Open Request
frames to the mesh STA.
Based on the status of the peer-specific power modes also the non-peer
power mode is set: if there is at least one link in light or deep sleep
mode, the non-peer power mode will be deep sleep mode.

To avoid frame losses when switching to a lower power state after peering
and for use in a future per-link dynamic powersave, the set_local_ps_mode
function can be called with a delay parameter that sets a per-STA timer
accordingly.

A debug define is added for comfortable debugging output.

Signed-off-by: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 net/mac80211/Kconfig       |   11 ++++
 net/mac80211/Makefile      |    3 +-
 net/mac80211/cfg.c         |    4 +-
 net/mac80211/debug.h       |   10 ++++
 net/mac80211/ieee80211_i.h |    4 ++
 net/mac80211/mesh.c        |    1 +
 net/mac80211/mesh.h        |    5 ++
 net/mac80211/mesh_plink.c  |   21 ++++++++
 net/mac80211/mesh_ps.c     |  124 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/sta_info.c    |    2 +
 net/mac80211/sta_info.h    |    6 +++
 11 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 net/mac80211/mesh_ps.c

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index b4ecf26..0ecf947 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -258,6 +258,17 @@ config MAC80211_MESH_SYNC_DEBUG
 
 	  Do not select this option.
 
+config MAC80211_MESH_PS_DEBUG
+	bool "Verbose mesh powersave debugging"
+	depends on MAC80211_DEBUG_MENU
+	depends on MAC80211_MESH
+	---help---
+	  Selecting this option causes mac80211 to print out very verbose mesh
+	  powersave debugging messages (when mac80211 is taking part in a
+	  mesh network).
+
+	  Do not select this option.
+
 config MAC80211_TDLS_DEBUG
 	bool "Verbose TDLS debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/Makefile b/net/mac80211/Makefile
index 4911202..9d7d840 100644
--- a/net/mac80211/Makefile
+++ b/net/mac80211/Makefile
@@ -39,7 +39,8 @@ mac80211-$(CONFIG_MAC80211_MESH) += \
 	mesh_pathtbl.o \
 	mesh_plink.o \
 	mesh_hwmp.o \
-	mesh_sync.o
+	mesh_sync.o \
+	mesh_ps.o
 
 mac80211-$(CONFIG_PM) += pm.o
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 84d63fc..4454aa1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1678,8 +1678,10 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		sdata->vif.bss_conf.dtim_period = nconf->dtim_period;
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	}
-	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask))
+	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask)) {
 		conf->power_mode = nconf->power_mode;
+		ieee80211_local_ps_update(sdata);
+	}
 	return 0;
 }
 
diff --git a/net/mac80211/debug.h b/net/mac80211/debug.h
index 8f383a5..4ccc5ed 100644
--- a/net/mac80211/debug.h
+++ b/net/mac80211/debug.h
@@ -44,6 +44,12 @@
 #define MAC80211_MESH_SYNC_DEBUG 0
 #endif
 
+#ifdef CONFIG_MAC80211_MESH_PS_DEBUG
+#define MAC80211_MESH_PS_DEBUG 1
+#else
+#define MAC80211_MESH_PS_DEBUG 0
+#endif
+
 #ifdef CONFIG_MAC80211_TDLS_DEBUG
 #define MAC80211_TDLS_DEBUG 1
 #else
@@ -151,6 +157,10 @@ do {									\
 	_sdata_dbg(MAC80211_MESH_SYNC_DEBUG,				\
 		   sdata, fmt, ##__VA_ARGS__)
 
+#define mps_dbg(sdata, fmt, ...)					\
+	_sdata_dbg(MAC80211_MESH_PS_DEBUG,				\
+		   sdata, fmt, ##__VA_ARGS__)
+
 #define tdls_dbg(sdata, fmt, ...)					\
 	_sdata_dbg(MAC80211_TDLS_DEBUG,					\
 		   sdata, fmt, ##__VA_ARGS__)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 32e4785..0364844 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -618,6 +618,10 @@ struct ieee80211_if_mesh {
 	s64 sync_offset_clockdrift_max;
 	spinlock_t sync_offset_lock;
 	bool adjusting_tbtt;
+	/* mesh power save */
+	enum nl80211_mesh_power_mode nonpeer_ps_mode;
+	u8 ps_peers_light_sleep;
+	u8 ps_peers_deep_sleep;
 };
 
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 827a7ca..145d9d2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -635,6 +635,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata->local,
 					  ieee80211_get_sdata_band(sdata));
+	ieee80211_local_ps_update(sdata);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
 						BSS_CHANGED_HT |
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 1fc5672..405c6b2 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -256,6 +256,11 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
 
+/* mesh power save */
+void ieee80211_local_ps_update(struct ieee80211_sub_if_data *sdata);
+void ieee80211_set_local_ps_mode(struct sta_info *sta,
+				 enum nl80211_mesh_power_mode pm, u32 delay);
+
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 234fe75..795f8c7 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -24,6 +24,7 @@
 #define dot11MeshConfirmTimeout(s) (s->u.mesh.mshcfg.dot11MeshConfirmTimeout)
 #define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
 #define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
+#define default_ps_mode(s) (s->u.mesh.mshcfg.power_mode)
 
 /* We only need a valid sta if user configured a minimum rssi_threshold. */
 #define rssi_threshold_check(sta, sdata) \
@@ -185,6 +186,8 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
+	ieee80211_local_ps_update(sdata);
+
 	return changed;
 }
 
@@ -549,6 +552,9 @@ int mesh_plink_open(struct sta_info *sta)
 		"Mesh plink: starting establishment with %pM\n",
 		sta->sta.addr);
 
+	/* set the non-peer mode to active during peering */
+	ieee80211_local_ps_update(sdata);
+
 	return mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
 				   sta->sta.addr, llid, 0, 0);
 }
@@ -778,6 +784,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			get_random_bytes(&llid, 2);
 			sta->llid = llid;
 			mesh_plink_timer_set(sta, dot11MeshRetryTimeout(sdata));
+
+			/* set the non-peer mode to active during peering */
+			ieee80211_local_ps_update(sdata);
+
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_OPEN,
@@ -870,6 +880,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			changed |= mesh_set_ht_prot_mode(sdata);
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
+
+			ieee80211_set_local_ps_mode(sta,
+						    default_ps_mode(sdata),
+						    100);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -908,6 +922,13 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
 					    sta->sta.addr, llid, plid, 0);
+			/*
+			 * we need some delay here, otherwise
+			 * the announcement Null would arrive before the CONFIRM
+			 */
+			ieee80211_set_local_ps_mode(sta,
+						    default_ps_mode(sdata),
+						    100);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
new file mode 100644
index 0000000..45a3500
--- /dev/null
+++ b/net/mac80211/mesh_ps.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright 2012, Marco Porsch <marco.porsch@s2005.tu-chemnitz.de>
+ * Copyright 2012, cozybit Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "mesh.h"
+
+/**
+ * ieee80211_local_ps_update - keep track of link-specific PS modes
+ *
+ * @sdata: local mesh subif
+ *
+ * sets the non-peer power mode and triggers the driver PS (re-)configuration
+ * called by cfg80211, on peer link changes and by a timer for delayed setting
+ */
+void ieee80211_local_ps_update(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct sta_info *sta;
+	bool peering = false;
+	u8 light_sleep_cnt = 0;
+	u8 deep_sleep_cnt = 0;
+
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		switch (sta->plink_state) {
+		case NL80211_PLINK_OPN_SNT:
+		case NL80211_PLINK_OPN_RCVD:
+		case NL80211_PLINK_CNF_RCVD:
+			peering = true;
+			break;
+		case NL80211_PLINK_ESTAB:
+			if (sta->local_ps_mode ==
+					NL80211_MESH_POWER_LIGHT_SLEEP)
+				light_sleep_cnt++;
+			if (sta->local_ps_mode ==
+					NL80211_MESH_POWER_DEEP_SLEEP)
+				deep_sleep_cnt++;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/*
+	 * set non-peer mode to active during peering/scanning/authentication
+	 * (see IEEE802.11-2012 13.14.8.3)
+	 * the non-peer mesh power mode is deep sleep if the local STA is in
+	 * light or deep sleep towards at least one mesh peer (see 13.14.3.1)
+	 * otherwise set it to the user-configured default value
+	 */
+	if (peering) {
+		mps_dbg(sdata, "setting non-peer PS mode to active until "
+			"peering is complete\n");
+		ifmsh->nonpeer_ps_mode = NL80211_MESH_POWER_ACTIVE;
+	} else if (light_sleep_cnt || deep_sleep_cnt) {
+		mps_dbg(sdata, "setting non-peer PS mode to deep sleep\n");
+		ifmsh->nonpeer_ps_mode = NL80211_MESH_POWER_DEEP_SLEEP;
+	} else {
+		mps_dbg(sdata, "setting non-peer PS mode to user value\n");
+		ifmsh->nonpeer_ps_mode = ifmsh->mshcfg.power_mode;
+	}
+
+	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
+	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
+}
+
+static void ieee80211_local_ps_mode_timer(unsigned long data)
+{
+	/*
+	 * This STA is valid because free_sta_work() will
+	 * del_timer_sync() this timer after having made sure
+	 * it cannot be armed (by deleting the plink.)
+	 */
+	struct sta_info *sta = (struct sta_info *) data;
+
+	ieee80211_set_local_ps_mode(sta, sta->local_ps_mode_delayed, 0);
+}
+
+/**
+ * ieee80211_set_local_ps_mode - set local PS mode towards a mesh STA
+ *
+ * @sta: mesh STA
+ * @pm: the power mode to set
+ * @delay: delay in msecs for committing and announcing the new value
+ *
+ * called by cfg80211 and on peer link establishment
+ */
+void ieee80211_set_local_ps_mode(struct sta_info *sta,
+				 enum nl80211_mesh_power_mode pm, u32 delay)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	static const char *modes[] = {
+		[NL80211_MESH_POWER_ACTIVE] = "active",
+		[NL80211_MESH_POWER_LIGHT_SLEEP] = "light sleep",
+		[NL80211_MESH_POWER_DEEP_SLEEP] = "deep sleep",
+	};
+
+	if (delay) {
+		/*
+		 * after peering/authentication/scanning it is useful to delay
+		 * the transition to a lower power mode to avoid frame losses
+		 * also intended for per-link dynamic powersave
+		 */
+		sta->local_ps_mode_delayed = pm;
+
+		sta->local_ps_mode_timer.data = (unsigned long) sta;
+		sta->local_ps_mode_timer.function =
+				ieee80211_local_ps_mode_timer;
+		mod_timer(&sta->local_ps_mode_timer,
+			  jiffies + msecs_to_jiffies(delay));
+		return;
+	}
+
+	mps_dbg(sdata, "local STA operates in %s mode with %pM\n",
+		modes[pm], sta->sta.addr);
+
+	sta->local_ps_mode = pm;
+
+	ieee80211_local_ps_update(sdata);
+}
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e9d5768..f8513a7 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -131,6 +131,7 @@ static void free_sta_work(struct work_struct *wk)
 		mesh_accept_plinks_update(sdata);
 		mesh_plink_deactivate(sta);
 		del_timer_sync(&sta->plink_timer);
+		del_timer_sync(&sta->local_ps_mode_timer);
 	}
 #endif
 
@@ -351,6 +352,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 #ifdef CONFIG_MAC80211_MESH
 	sta->plink_state = NL80211_PLINK_LISTEN;
 	init_timer(&sta->plink_timer);
+	init_timer(&sta->local_ps_mode_timer);
 #endif
 
 	return sta;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index c88f161f..046ca70 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -274,6 +274,9 @@ struct sta_ampdu_mlme {
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
  * @ch_type: peer's channel type
+ * @local_ps_mode: local link-specific power save mode
+ * @local_ps_mode_delayed: temp. storage for delayed setting of local_ps_mode
+ * @local_ps_mode_timer: timer for delayed setting of local_ps_mode
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -370,6 +373,9 @@ struct sta_info {
 	s64 t_offset;
 	s64 t_offset_setpoint;
 	enum nl80211_channel_type ch_type;
+	enum nl80211_mesh_power_mode local_ps_mode;
+	enum nl80211_mesh_power_mode local_ps_mode_delayed;
+	struct timer_list local_ps_mode_timer;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-- 
1.7.9.5

