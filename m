Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:64895 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3ARLqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 06:46:21 -0500
Received: by mail-bk0-f42.google.com with SMTP id ji2so1955481bkc.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 03:46:19 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCHv3] mac80211: mesh power save basics
Date: Fri, 18 Jan 2013 12:46:10 +0100
Message-Id: <1358509570-31602-1-git-send-email-marco@cozybit.com> (sfid-20130118_124627_555458_BCF9084D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the local_pm field to the sta_info structure to represent
the link-specific power mode at this station towards the remote
station. When a peer link is established, the local
link-specific power mode is set up equal to the
user-configurable default power mode.
Monitor the status of the local peer-specific power modes for
mesh power mode indication, and for checking if the radio may be
set to doze state. Update the PS status if the peering status of
a neighbor changes.
Maintain a mesh power mode  for non-peer mesh STAs. The non-peer
mesh power mode determines when non-peer mesh STA may send Probe
Requests and Mesh Peering Open frames to the mesh STA.
Based on the status of the peer-specific power modes also the
non-peer power mode is set: if there is at least one link in
light or deep sleep mode, the non-peer power mode will be deep
sleep mode.
To allow successful peering, set the non-peer power mode to
active mode during peering.
Add a debug define for comfortable debugging output.

Indicate the current power mode in transmitted frames. This
differs for individually-addressed frames and group addressed
frames as well as whether the frames are addressed to peers or
non-peers.
Especially indicate a peer-specific mesh power mode transition
with an individually-addressed QoS Null frame to the respective
peer.
Indicate the non-peer mesh power mode in frames transmitted to
non-peer STA and in management frames in the Power Management
field of the Frame Control field.
In group addressed Mesh QoS Data frames the Mesh Power Save
Level field in the QoS Control field indicates whether the local
STA has any deep sleep peers.
In beacon (and probe response) frames indicate whether we have
any deep sleep peers, by setting the Mesh Power Save Level field
of the Mesh Capability field.
For performance reasons, calls to the function setting the frame
flags are placed in HWMP routing routines, as there the STA
pointer is already available.

Add the peer_pm field to the sta_info structure to represent the
peer's link-specific power mode towards the local station.
Additionally, the nonpeer_pm field represents the peer's power
mode towards all non-peer stations.
The peers' link-specific power modes are tracked from the Power
Management field in the Frame Control field and the Mesh Power
Save Level field in the QoS Control field. Peer and non-peer
modes are tracked independently from respective frames. This
allows fast reconfiguration after a peering change.

Add the ps_data structure to ieee80211_if_mesh. This structure
contains the TIM map, a counter how of PS neighbors and the
group-addressed frame buffer.
Functions using this structure are modified for mesh mode.

In case of a neighbor changing its power mode or peering status,
update the setting of the WLAN_STA_PS flag. This flag triggers
the frame buffering routines for individually-addressed frames
in the tx path used for client mode, which are re-used here.
Also the num_sta_ps counter is updated, which triggers the
buffering and release of group-addressed frames after DTIM
beacons.

Until drivers are adapted for mesh power save, do not inform the
driver about the neighbor STA being in PS mode towards us (as
sta_ps_start would do).

Announce the awake window value in an IE in beacons if the local
STA is in light or deep sleep mode towards any peer or non-peer.
On receipt STA parse the IE.

Create a TIM IE similarly to AP mode and add it to mesh beacons.

React to neighbor's Awake Window and TIM IE. When receiving a
neighbor beacon, check if the neighbor indicates buffered frames
and if it announces an awake window duration.

In case the neighbor is an established peer, frames may be
released in a mesh Peer Service Period. MPSPs start and end with
a MPSP trigger frame. The setting of RSPI and EOSP frame flags
determine if a MPSP starts or ends and which STA is the owner,
recipient or both during the MPSP.
The indication of buffered frames at the peer and the status of
the local buffers determine which type of MPSP is started when a
peer beacon is received. The buffered frames are transmitted
only after the MPSP trigger frame has been acknowledged.
To end a MPSP set the EOSP flag in the last QoS Data frame. In
case the last frame is not a QoS data frame, append a QoS Null
frame after the last frame.
Count the number of MPSPs the local STA is owner and/or
recipient in. This will be used to disallow doze state during
ongoing MPSPs.

Currently, in HT channels MPSPs behave imperfectly and show
large delay spikes and frame losses.

Authenticated mesh peering is currently not working when either
node is configured to be in power save mode.

Signed-off-by: Marco Porsch <marco@cozybit.com>
Signed-off-by: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---

v3:
	remove inline for QoS control PM field
	refactor commit log
	__le16 pointer for awake window
	remove delayed setting of local_pm
	adjust comment style
	use lock-free skb queue modifiers for local use
	remove shadow variable
	remove misplaced comments
	remove braces

 include/linux/ieee80211.h     |    8 +
 net/mac80211/Kconfig          |   11 +
 net/mac80211/Makefile         |    3 +-
 net/mac80211/cfg.c            |   27 +-
 net/mac80211/debug.h          |   10 +
 net/mac80211/debugfs_netdev.c |    5 +
 net/mac80211/debugfs_sta.c    |    5 +-
 net/mac80211/ieee80211_i.h    |    7 +
 net/mac80211/mesh.c           |   36 +++
 net/mac80211/mesh.h           |   17 ++
 net/mac80211/mesh_hwmp.c      |    7 +
 net/mac80211/mesh_pathtbl.c   |    1 +
 net/mac80211/mesh_plink.c     |   17 ++
 net/mac80211/mesh_ps.c        |  605 +++++++++++++++++++++++++++++++++++++++++
 net/mac80211/rx.c             |    7 +
 net/mac80211/sta_info.c       |   15 +-
 net/mac80211/sta_info.h       |   11 +
 net/mac80211/status.c         |    5 +
 net/mac80211/tx.c             |   31 ++-
 net/mac80211/util.c           |    4 +
 net/mac80211/wme.c            |   13 +-
 21 files changed, 828 insertions(+), 17 deletions(-)
 create mode 100644 net/mac80211/mesh_ps.c

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ccf9ee1..07fc997 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -151,6 +151,11 @@
 /* Mesh Control 802.11s */
 #define IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT  0x0100
 
+/* Mesh Power Save Level */
+#define IEEE80211_QOS_CTL_MESH_PS_LEVEL		0x0200
+/* Mesh Receiver Service Period Initiated */
+#define IEEE80211_QOS_CTL_RSPI			0x0400
+
 /* U-APSD queue for WMM IEs sent by AP */
 #define IEEE80211_WMM_IE_AP_QOSINFO_UAPSD	(1<<7)
 #define IEEE80211_WMM_IE_AP_QOSINFO_PARAM_SET_CNT_MASK	0x0f
@@ -675,11 +680,14 @@ struct ieee80211_meshconf_ie {
  * @IEEE80211_MESHCONF_CAPAB_FORWARDING: the STA forwards MSDUs
  * @IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING: TBTT adjustment procedure
  *	is ongoing
+ * @IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL: STA is in deep sleep mode or has
+ *	neighbors in deep sleep mode
  */
 enum mesh_config_capab_flags {
 	IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS		= 0x01,
 	IEEE80211_MESHCONF_CAPAB_FORWARDING		= 0x08,
 	IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING		= 0x20,
+	IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL	= 0x40,
 };
 
 /**
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
index ea59c80..ed8c547 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -482,7 +482,10 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 #ifdef CONFIG_MAC80211_MESH
 		sinfo->filled |= STATION_INFO_LLID |
 				 STATION_INFO_PLID |
-				 STATION_INFO_PLINK_STATE;
+				 STATION_INFO_PLINK_STATE |
+				 STATION_INFO_LOCAL_PM |
+				 STATION_INFO_PEER_PM |
+				 STATION_INFO_NONPEER_PM;
 
 		sinfo->llid = le16_to_cpu(sta->llid);
 		sinfo->plid = le16_to_cpu(sta->plid);
@@ -491,6 +494,9 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 			sinfo->filled |= STATION_INFO_T_OFFSET;
 			sinfo->t_offset = sta->t_offset;
 		}
+		sinfo->local_pm = sta->local_pm;
+		sinfo->peer_pm = sta->peer_pm;
+		sinfo->nonpeer_pm = sta->nonpeer_pm;
 #endif
 	}
 
@@ -1252,6 +1258,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					changed = mesh_plink_inc_estab_count(
 							sdata);
 				sta->plink_state = params->plink_state;
+
+				ieee80211_mps_sta_status_update(sta);
+				ieee80211_mps_set_sta_local_pm(sta,
+					sdata->u.mesh.mshcfg.power_mode);
 				break;
 			case NL80211_PLINK_LISTEN:
 			case NL80211_PLINK_BLOCKED:
@@ -1263,6 +1273,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					changed = mesh_plink_dec_estab_count(
 							sdata);
 				sta->plink_state = params->plink_state;
+
+				ieee80211_mps_sta_status_update(sta);
+				ieee80211_mps_local_status_update(sdata);
 				break;
 			default:
 				/*  nothing  */
@@ -1279,6 +1292,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 				break;
 			}
 		}
+
+		if (params->local_pm)
+			ieee80211_mps_set_sta_local_pm(sta, params->local_pm);
 #endif
 	}
 
@@ -1767,6 +1783,15 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_CONFIRMATION_INTERVAL, mask))
 		conf->dot11MeshHWMPconfirmationInterval =
 			nconf->dot11MeshHWMPconfirmationInterval;
+	if (_chg_mesh_attr(NL80211_MESHCONF_POWER_MODE, mask)) {
+		conf->power_mode = nconf->power_mode;
+		ieee80211_mps_local_status_update(sdata);
+	}
+	if (_chg_mesh_attr(NL80211_MESHCONF_AWAKE_WINDOW, mask)) {
+		conf->dot11MeshAwakeWindowDuration =
+			nconf->dot11MeshAwakeWindowDuration;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
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
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index cbde5cc..059bbb8 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -515,6 +515,9 @@ IEEE80211_IF_FILE(dot11MeshHWMProotInterval,
 		  u.mesh.mshcfg.dot11MeshHWMProotInterval, DEC);
 IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
 		  u.mesh.mshcfg.dot11MeshHWMPconfirmationInterval, DEC);
+IEEE80211_IF_FILE(power_mode, u.mesh.mshcfg.power_mode, DEC);
+IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
+		  u.mesh.mshcfg.dot11MeshAwakeWindowDuration, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -620,6 +623,8 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPactivePathToRootTimeout);
 	MESHPARAMS_ADD(dot11MeshHWMProotInterval);
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
+	MESHPARAMS_ADD(power_mode);
+	MESHPARAMS_ADD(dot11MeshAwakeWindowDuration);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 6fb1168..c7591f7 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -65,7 +65,7 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
@@ -74,7 +74,8 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
 			    TEST(TDLS_PEER_AUTH), TEST(4ADDR_EVENT),
 			    TEST(INSERTED), TEST(RATE_CONTROL),
-			    TEST(TOFFSET_KNOWN));
+			    TEST(TOFFSET_KNOWN), TEST(MPSP_OWNER),
+			    TEST(MPSP_RECIPIENT));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0fa44a9..d77d3f7 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -623,6 +623,12 @@ struct ieee80211_if_mesh {
 	s64 sync_offset_clockdrift_max;
 	spinlock_t sync_offset_lock;
 	bool adjusting_tbtt;
+	/* mesh power save */
+	enum nl80211_mesh_power_mode nonpeer_pm;
+	int ps_peers_light_sleep;
+	int ps_peers_deep_sleep;
+	struct ps_data ps;
+	atomic_t num_mpsp; /* counts both owner and recipient independently */
 };
 
 #ifdef CONFIG_MAC80211_MESH
@@ -1219,6 +1225,7 @@ struct ieee802_11_elems {
 	struct ieee80211_meshconf_ie *mesh_config;
 	u8 *mesh_id;
 	u8 *peering;
+	__le16 *awake_window;
 	u8 *preq;
 	u8 *prep;
 	u8 *perr;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 694e273..e4cb9ae 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -261,6 +261,9 @@ mesh_add_meshconf_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	*pos = IEEE80211_MESHCONF_CAPAB_FORWARDING;
 	*pos |= ifmsh->accepting_plinks ?
 	    IEEE80211_MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
+	/* Mesh PS mode. See IEEE802.11-2012 8.4.2.100.8 */
+	*pos |= ifmsh->ps_peers_deep_sleep ?
+	    IEEE80211_MESHCONF_CAPAB_POWER_SAVE_LEVEL : 0x00;
 	*pos++ |= ifmsh->adjusting_tbtt ?
 	    IEEE80211_MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;
 	*pos++ = 0x00;
@@ -286,6 +289,29 @@ mesh_add_meshid_ie(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
+int mesh_add_awake_window_ie(struct sk_buff *skb,
+			     struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u8 *pos;
+
+	/* see IEEE802.11-2012 13.14.6 */
+	if (ifmsh->ps_peers_light_sleep == 0 &&
+	    ifmsh->ps_peers_deep_sleep == 0 &&
+	    ifmsh->nonpeer_pm == NL80211_MESH_POWER_ACTIVE)
+		return 0;
+
+	if (skb_tailroom(skb) < 4)
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + 2);
+	*pos++ = WLAN_EID_MESH_AWAKE_WINDOW;
+	*pos++ = 2;
+	put_unaligned_le16(ifmsh->mshcfg.dot11MeshAwakeWindowDuration, pos);
+
+	return 0;
+}
+
 int
 mesh_add_vendor_ies(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
@@ -634,6 +660,8 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
 
+	ieee80211_mps_local_status_update(sdata);
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
@@ -656,6 +684,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	sta_info_flush(sdata);
 	mesh_path_flush_by_iface(sdata);
 
+	atomic_set(&ifmsh->ps.num_sta_ps, 0); /* not reset by sta_info_flush */
+	atomic_set(&ifmsh->num_mpsp, 0);
+
+	/* free all potentially still buffered group-addressed frames */
+	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
+	skb_queue_purge(&ifmsh->ps.bc_buf);
+
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
@@ -833,6 +868,7 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 		    ieee80211_mesh_path_root_timer,
 		    (unsigned long) sdata);
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
+	skb_queue_head_init(&ifmsh->ps.bc_buf);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 	spin_lock_init(&ifmsh->sync_offset_lock);
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index aff3015..f38a114 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -222,6 +222,8 @@ int mesh_add_meshid_ie(struct sk_buff *skb,
 		       struct ieee80211_sub_if_data *sdata);
 int mesh_add_rsn_ie(struct sk_buff *skb,
 		    struct ieee80211_sub_if_data *sdata);
+int mesh_add_awake_window_ie(struct sk_buff *skb,
+			     struct ieee80211_sub_if_data *sdata);
 int mesh_add_vendor_ies(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata);
 int mesh_add_ds_params_ie(struct sk_buff *skb,
@@ -242,6 +244,21 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh);
 const struct ieee80211_mesh_sync_ops *ieee80211_mesh_sync_ops_get(u8 method);
 
+/* mesh power save */
+void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
+				    enum nl80211_mesh_power_mode pm);
+void ieee80211_mps_set_frame_flags(struct ieee80211_sub_if_data *sdata,
+				   struct sta_info *sta,
+				   struct ieee80211_hdr *hdr);
+void ieee80211_mps_sta_status_update(struct sta_info *sta);
+void ieee80211_mps_rx_h_sta_process(struct sta_info *sta,
+				    struct ieee80211_hdr *hdr);
+void ieee80211_mpsp_trigger_process(struct ieee80211_hdr *hdr,
+				    struct sta_info *sta, bool tx, bool acked);
+void ieee80211_mps_frame_release(struct sta_info *sta,
+				 struct ieee802_11_elems *elems);
+
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 9044296..48ecc3d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -205,6 +205,7 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
 		struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
@@ -216,6 +217,7 @@ static void prepare_frame_for_deferred_tx(struct ieee80211_sub_if_data *sdata,
 
 	info->control.vif = &sdata->vif;
 	ieee80211_set_qos_hdr(sdata, skb);
+	ieee80211_mps_set_frame_flags(sdata, NULL, hdr);
 }
 
 /**
@@ -1077,6 +1079,10 @@ int mesh_nexthop_resolve(struct sk_buff *skb,
 	u8 *target_addr = hdr->addr3;
 	int err = 0;
 
+	/* Nulls are only sent to peers for PS and should be pre-addressed */
+	if (ieee80211_is_qos_nullfunc(hdr->frame_control))
+		return 0;
+
 	rcu_read_lock();
 	err = mesh_nexthop_lookup(skb, sdata);
 	if (!err)
@@ -1148,6 +1154,7 @@ int mesh_nexthop_lookup(struct sk_buff *skb,
 	if (next_hop) {
 		memcpy(hdr->addr1, next_hop->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		ieee80211_mps_set_frame_flags(sdata, next_hop, hdr);
 		err = 0;
 	}
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index aa74981..d5786c3 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -212,6 +212,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
 		hdr = (struct ieee80211_hdr *) skb->data;
 		memcpy(hdr->addr1, sta->sta.addr, ETH_ALEN);
 		memcpy(hdr->addr2, mpath->sdata->vif.addr, ETH_ALEN);
+		ieee80211_mps_set_frame_flags(sta->sdata, sta, hdr);
 	}
 
 	spin_unlock_irqrestore(&mpath->frame_queue.lock, flags);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 9e04166..57e7267 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -165,6 +165,9 @@ static u32 __mesh_plink_deactivate(struct sta_info *sta)
 	sta->plink_state = NL80211_PLINK_BLOCKED;
 	mesh_path_flush_by_nexthop(sta);
 
+	ieee80211_mps_sta_status_update(sta);
+	ieee80211_mps_local_status_update(sdata);
+
 	return changed;
 }
 
@@ -405,6 +408,7 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 	    rssi_threshold_check(sta, sdata))
 		mesh_plink_open(sta);
 
+	ieee80211_mps_frame_release(sta, elems);
 out:
 	rcu_read_unlock();
 }
@@ -535,6 +539,9 @@ int mesh_plink_open(struct sta_info *sta)
 		"Mesh plink: starting establishment with %pM\n",
 		sta->sta.addr);
 
+	/* set the non-peer mode to active during peering */
+	ieee80211_mps_local_status_update(sdata);
+
 	return mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_OPEN,
 				   sta->sta.addr, llid, 0, 0);
 }
@@ -766,6 +773,10 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			sta->llid = llid;
 			mesh_plink_timer_set(sta,
 					     mshcfg->dot11MeshRetryTimeout);
+
+			/* set the non-peer mode to active during peering */
+			ieee80211_mps_local_status_update(sdata);
+
 			spin_unlock_bh(&sta->lock);
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_OPEN,
@@ -858,6 +869,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			changed |= mesh_set_ht_prot_mode(sdata);
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
+			ieee80211_mps_sta_status_update(sta);
+			ieee80211_mps_set_sta_local_pm(sta,
+						       mshcfg->power_mode);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
@@ -896,6 +910,9 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mesh_plink_frame_tx(sdata,
 					    WLAN_SP_MESH_PEERING_CONFIRM,
 					    sta->sta.addr, llid, plid, 0);
+			ieee80211_mps_sta_status_update(sta);
+			ieee80211_mps_set_sta_local_pm(sta,
+						       mshcfg->power_mode);
 			break;
 		default:
 			spin_unlock_bh(&sta->lock);
diff --git a/net/mac80211/mesh_ps.c b/net/mac80211/mesh_ps.c
new file mode 100644
index 0000000..684e2a4
--- /dev/null
+++ b/net/mac80211/mesh_ps.c
@@ -0,0 +1,605 @@
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
+#include "wme.h"
+
+
+static inline bool test_and_set_mpsp_flag(struct sta_info *sta,
+					  enum ieee80211_sta_info_flags flag)
+{
+	if (!test_and_set_sta_flag(sta, flag)) {
+		atomic_inc(&sta->sdata->u.mesh.num_mpsp);
+		return false;
+	}
+	return true;
+}
+
+static inline bool test_and_clear_mpsp_flag(struct sta_info *sta,
+					    enum ieee80211_sta_info_flags flag)
+{
+	if (test_and_clear_sta_flag(sta, flag)) {
+		atomic_dec(&sta->sdata->u.mesh.num_mpsp);
+		return true;
+	}
+	return false;
+}
+
+
+/* mesh PS management */
+
+/**
+ * mps_qos_null_get - create pre-addressed QoS Null frame for mesh powersave
+ */
+static struct sk_buff *mps_qos_null_get(struct sta_info *sta)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_hdr *nullfunc; /* use 4addr header */
+	struct sk_buff *skb;
+	int size = sizeof(*nullfunc);
+	__le16 fc;
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + size + 2);
+	if (!skb)
+		return NULL;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+
+	nullfunc = (struct ieee80211_hdr *) skb_put(skb, size);
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_NULLFUNC);
+	ieee80211_fill_mesh_addresses(nullfunc, &fc, sta->sta.addr,
+				      sdata->vif.addr);
+	nullfunc->frame_control = fc;
+	nullfunc->duration_id = 0;
+	/* no address resolution for this frame -> set addr 1 immediately */
+	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
+	memset(skb_put(skb, 2), 0, 2); /* append QoS control field */
+	ieee80211_mps_set_frame_flags(sdata, sta, nullfunc);
+
+	return skb;
+}
+
+/**
+ * mps_qos_null_tx - send a QoS Null to indicate link-specific power mode
+ */
+static void mps_qos_null_tx(struct sta_info *sta)
+{
+	struct sk_buff *skb;
+
+	skb = mps_qos_null_get(sta);
+	if (!skb)
+		return;
+
+	mps_dbg(sta->sdata, "announcing peer-specific power mode to %pM\n",
+		sta->sta.addr);
+
+	/* don't unintentionally start a MPSP */
+	if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
+		__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(
+				(struct ieee80211_hdr *) skb->data);
+
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+	}
+
+	ieee80211_tx_skb(sta->sdata, skb);
+}
+
+/**
+ * ieee80211_mps_local_status_update - track status of local link-specific PMs
+ *
+ * @sdata: local mesh subif
+ *
+ * sets the non-peer power mode and triggers the driver PS (re-)configuration
+ */
+void ieee80211_mps_local_status_update(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct sta_info *sta;
+	bool peering = false;
+	int light_sleep_cnt = 0;
+	int deep_sleep_cnt = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &sdata->local->sta_list, list) {
+		if (sdata != sta->sdata)
+			continue;
+
+		switch (sta->plink_state) {
+		case NL80211_PLINK_OPN_SNT:
+		case NL80211_PLINK_OPN_RCVD:
+		case NL80211_PLINK_CNF_RCVD:
+			peering = true;
+			break;
+		case NL80211_PLINK_ESTAB:
+			if (sta->local_pm == NL80211_MESH_POWER_LIGHT_SLEEP)
+				light_sleep_cnt++;
+			else if (sta->local_pm == NL80211_MESH_POWER_DEEP_SLEEP)
+				deep_sleep_cnt++;
+			break;
+		default:
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	/*
+	 * Set non-peer mode to active during peering/scanning/authentication
+	 * (see IEEE802.11-2012 13.14.8.3). The non-peer mesh power mode is
+	 * deep sleep if the local STA is in light or deep sleep towards at
+	 * least one mesh peer (see 13.14.3.1). Otherwise, set it to the
+	 * user-configured default value.
+	 */
+	if (peering) {
+		mps_dbg(sdata, "setting non-peer PM to active for peering\n");
+		ifmsh->nonpeer_pm = NL80211_MESH_POWER_ACTIVE;
+	} else if (light_sleep_cnt || deep_sleep_cnt) {
+		mps_dbg(sdata, "setting non-peer PM to deep sleep\n");
+		ifmsh->nonpeer_pm = NL80211_MESH_POWER_DEEP_SLEEP;
+	} else {
+		mps_dbg(sdata, "setting non-peer PM to user value\n");
+		ifmsh->nonpeer_pm = ifmsh->mshcfg.power_mode;
+	}
+
+	ifmsh->ps_peers_light_sleep = light_sleep_cnt;
+	ifmsh->ps_peers_deep_sleep = deep_sleep_cnt;
+}
+
+/**
+ * ieee80211_mps_set_sta_local_pm - set local PM towards a mesh STA
+ *
+ * @sta: mesh STA
+ * @pm: the power mode to set
+ */
+void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
+				    enum nl80211_mesh_power_mode pm)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+
+	mps_dbg(sdata, "local STA operates in mode %d with %pM\n",
+		pm, sta->sta.addr);
+
+	sta->local_pm = pm;
+
+	/*
+	 * announce peer-specific power mode transition
+	 * (see IEEE802.11-2012 13.14.3.2 and 13.14.3.3)
+	 */
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		mps_qos_null_tx(sta);
+
+	ieee80211_mps_local_status_update(sdata);
+}
+
+/**
+ * ieee80211_mps_set_frame_flags - set mesh PS flags in FC (and QoS Control)
+ *
+ * @sdata: local mesh subif
+ * @sta: mesh STA
+ * @hdr: 802.11 frame header
+ *
+ * see IEEE802.11-2012 8.2.4.1.7 and 8.2.4.5.11
+ *
+ * NOTE: sta must be given when an individually-addressed QoS frame header
+ * is handled, for group-addressed and management frames it is not used
+ */
+void ieee80211_mps_set_frame_flags(struct ieee80211_sub_if_data *sdata,
+				   struct sta_info *sta,
+				   struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm;
+	__le16 *qc;
+
+	if (WARN_ON(is_unicast_ether_addr(hdr->addr1) &&
+		    ieee80211_is_data_qos(hdr->frame_control) &&
+		    !sta))
+		return;
+
+	if (is_unicast_ether_addr(hdr->addr1) &&
+	    ieee80211_is_data_qos(hdr->frame_control) &&
+	    sta->plink_state == NL80211_PLINK_ESTAB)
+		pm = sta->local_pm;
+	else
+		pm = sdata->u.mesh.nonpeer_pm;
+
+	if (pm == NL80211_MESH_POWER_ACTIVE)
+		hdr->frame_control &= cpu_to_le16(~IEEE80211_FCTL_PM);
+	else
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+
+	if ((is_unicast_ether_addr(hdr->addr1) &&
+	     pm == NL80211_MESH_POWER_DEEP_SLEEP) ||
+	    (is_multicast_ether_addr(hdr->addr1) &&
+	     sdata->u.mesh.ps_peers_deep_sleep > 0))
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL);
+	else
+		*qc &= cpu_to_le16(~IEEE80211_QOS_CTL_MESH_PS_LEVEL);
+}
+
+/**
+ * ieee80211_mps_sta_status_update - update buffering status of neighbor STA
+ *
+ * @sta: mesh STA
+ *
+ * called after change of peering status or non-peer/peer-specific power mode
+ */
+void ieee80211_mps_sta_status_update(struct sta_info *sta)
+{
+	enum nl80211_mesh_power_mode pm;
+	bool do_buffer;
+
+	/*
+	 * use peer-specific power mode if peering is established and the
+	 * peer's power mode is known
+	 */
+	if (sta->plink_state == NL80211_PLINK_ESTAB &&
+	    sta->peer_pm != NL80211_MESH_POWER_UNKNOWN)
+		pm = sta->peer_pm;
+	else
+		pm = sta->nonpeer_pm;
+
+	do_buffer = (pm != NL80211_MESH_POWER_ACTIVE);
+
+	/* Don't let the same PS state be set twice */
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) == do_buffer)
+		return;
+
+	if (do_buffer) {
+		set_sta_flag(sta, WLAN_STA_PS_STA);
+		atomic_inc(&sta->sdata->u.mesh.ps.num_sta_ps);
+		mps_dbg(sta->sdata, "start PS buffering frames towards %pM\n",
+			sta->sta.addr);
+	} else {
+		ieee80211_sta_ps_deliver_wakeup(sta);
+	}
+
+	/* clear the MPSP flags for non-peers or active STA */
+	if (sta->plink_state != NL80211_PLINK_ESTAB) {
+		test_and_clear_mpsp_flag(sta, WLAN_STA_MPSP_OWNER);
+		test_and_clear_mpsp_flag(sta, WLAN_STA_MPSP_RECIPIENT);
+	} else if (!do_buffer) {
+		test_and_clear_mpsp_flag(sta, WLAN_STA_MPSP_OWNER);
+	}
+}
+
+static void mps_set_sta_peer_pm(struct sta_info *sta,
+				struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm;
+	__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+
+	/*
+	 * Test Power Managment field of frame control (PW) and
+	 * mesh power save level subfield of QoS control field (PSL)
+	 *
+	 * | PM | PSL| Mesh PM |
+	 * +----+----+---------+
+	 * | 0  |Rsrv|  Active |
+	 * | 1  | 0  |  Light  |
+	 * | 1  | 1  |  Deep   |
+	 */
+	if (ieee80211_has_pm(hdr->frame_control)) {
+		if (*qc & cpu_to_le16(IEEE80211_QOS_CTL_MESH_PS_LEVEL))
+			pm = NL80211_MESH_POWER_DEEP_SLEEP;
+		else
+			pm = NL80211_MESH_POWER_LIGHT_SLEEP;
+	} else {
+		pm = NL80211_MESH_POWER_ACTIVE;
+	}
+
+	if (sta->peer_pm == pm)
+		return;
+
+	mps_dbg(sta->sdata, "STA %pM enters mode %d\n",
+		sta->sta.addr, pm);
+
+	sta->peer_pm = pm;
+
+	ieee80211_mps_sta_status_update(sta);
+}
+
+static void mps_set_sta_nonpeer_pm(struct sta_info *sta,
+				   struct ieee80211_hdr *hdr)
+{
+	enum nl80211_mesh_power_mode pm;
+
+	if (ieee80211_has_pm(hdr->frame_control))
+		pm = NL80211_MESH_POWER_DEEP_SLEEP;
+	else
+		pm = NL80211_MESH_POWER_ACTIVE;
+
+	if (sta->nonpeer_pm == pm)
+		return;
+
+	mps_dbg(sta->sdata, "STA %pM sets non-peer mode to %d\n",
+		sta->sta.addr, pm);
+
+	sta->nonpeer_pm = pm;
+
+	ieee80211_mps_sta_status_update(sta);
+}
+
+/**
+ * ieee80211_mps_rx_h_sta_process - frame receive handler for mesh powersave
+ *
+ * @sta: STA info that transmitted the frame
+ * @hdr: IEEE 802.11 (QoS) Header
+ */
+void ieee80211_mps_rx_h_sta_process(struct sta_info *sta,
+				    struct ieee80211_hdr *hdr)
+{
+	if (is_unicast_ether_addr(hdr->addr1) &&
+	    ieee80211_is_data_qos(hdr->frame_control)) {
+		/*
+		 * individually addressed QoS Data/Null frames contain
+		 * peer link-specific PS mode towards the local STA
+		 */
+		mps_set_sta_peer_pm(sta, hdr);
+
+		/* check for mesh Peer Service Period trigger frames */
+		ieee80211_mpsp_trigger_process(hdr, sta, false, false);
+	} else {
+		/*
+		 * can only determine non-peer PS mode
+		 * (see IEEE802.11-2012 8.2.4.1.7)
+		 */
+		mps_set_sta_nonpeer_pm(sta, hdr);
+	}
+}
+
+
+/* mesh PS frame release */
+
+static void mpsp_trigger_send(struct sta_info *sta, bool rspi, bool eosp)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct sk_buff *skb;
+	struct ieee80211_hdr *nullfunc;
+	struct ieee80211_tx_info *info;
+	__le16 *qc;
+
+	skb = mps_qos_null_get(sta);
+	if (!skb)
+		return;
+
+	nullfunc = (struct ieee80211_hdr *) skb->data;
+	if (!eosp)
+		nullfunc->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	/*
+	 * | RSPI | EOSP |  MPSP triggering   |
+	 * +------+------+--------------------+
+	 * |  0   |  0   | local STA is owner |
+	 * |  0   |  1   | no MPSP (MPSP end) |
+	 * |  1   |  0   | both STA are owner |
+	 * |  1   |  1   | peer STA is owner  | see IEEE802.11-2012 13.14.9.2
+	 */
+	qc = (__le16 *) ieee80211_get_qos_ctl(nullfunc);
+	if (rspi)
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_RSPI);
+	if (eosp)
+		*qc |= cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+
+	info = IEEE80211_SKB_CB(skb);
+
+	info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER |
+		       IEEE80211_TX_CTL_REQ_TX_STATUS;
+
+	mps_dbg(sdata, "sending MPSP trigger%s%s to %pM\n",
+		rspi ? " RSPI" : "", eosp ? " EOSP" : "", sta->sta.addr);
+
+	ieee80211_tx_skb(sdata, skb);
+}
+
+/**
+ * mpsp_qos_null_append - append QoS Null frame to MPSP skb queue if needed
+ *
+ * To properly end a mesh MPSP the last transmitted frame has to set the EOSP
+ * flag in the QoS Control field. In case the current tailing frame is not a
+ * QoS Data frame, append a QoS Null to carry the flag.
+ */
+static void mpsp_qos_null_append(struct sta_info *sta,
+				 struct sk_buff_head *frames)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct sk_buff *new_skb, *skb = skb_peek_tail(frames);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_tx_info *info;
+
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	new_skb = mps_qos_null_get(sta);
+	if (!new_skb)
+		return;
+
+	mps_dbg(sdata, "appending QoS Null in MPSP towards %pM\n",
+		sta->sta.addr);
+
+	/* should be transmitted last -> lowest priority */
+	new_skb->priority = 1;
+	skb_set_queue_mapping(new_skb, IEEE80211_AC_BK);
+	ieee80211_set_qos_hdr(sdata, new_skb);
+
+	info = IEEE80211_SKB_CB(new_skb);
+	info->control.vif = &sdata->vif;
+	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING;
+
+	__skb_queue_tail(frames, new_skb);
+}
+
+/**
+ * mps_frame_deliver - transmit frames during mesh powersave
+ *
+ * @sta: STA info to transmit to
+ * @n_frames: number of frames to transmit. -1 for all
+ */
+static void mps_frame_deliver(struct sta_info *sta, int n_frames)
+{
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_local *local = sdata->local;
+	int ac;
+	struct sk_buff_head frames;
+	struct sk_buff *skb;
+	bool more_data = false;
+
+	skb_queue_head_init(&frames);
+
+	/* collect frame(s) from buffers */
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
+		while (n_frames != 0) {
+			skb = skb_dequeue(&sta->tx_filtered[ac]);
+			if (!skb) {
+				skb = skb_dequeue(
+					&sta->ps_tx_buf[ac]);
+				if (skb)
+					local->total_ps_buffered--;
+			}
+			if (!skb)
+				break;
+			n_frames--;
+			__skb_queue_tail(&frames, skb);
+		}
+
+		if (!skb_queue_empty(&sta->tx_filtered[ac]) ||
+		    !skb_queue_empty(&sta->ps_tx_buf[ac]))
+			more_data = true;
+	}
+
+	/* nothing to send? -> EOSP */
+	if (skb_queue_empty(&frames)) {
+		mpsp_trigger_send(sta, false, true);
+		return;
+	}
+
+	/* in a MPSP make sure the last skb is a QoS Data frame */
+	if (test_sta_flag(sta, WLAN_STA_MPSP_OWNER))
+		mpsp_qos_null_append(sta, &frames);
+
+	mps_dbg(sta->sdata, "sending %d frames to PS STA %pM\n",
+		skb_queue_len(&frames), sta->sta.addr);
+
+	/* prepare collected frames for transmission */
+	skb_queue_walk(&frames, skb) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_hdr *hdr = (void *) skb->data;
+
+		/*
+		 * Tell TX path to send this frame even though the
+		 * STA may still remain is PS mode after this frame
+		 * exchange.
+		 */
+		info->flags |= IEEE80211_TX_CTL_NO_PS_BUFFER;
+
+		if (more_data || !skb_queue_is_last(&frames, skb))
+			hdr->frame_control |=
+				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+		else
+			hdr->frame_control &=
+				cpu_to_le16(~IEEE80211_FCTL_MOREDATA);
+
+		if (skb_queue_is_last(&frames, skb) &&
+		    ieee80211_is_data_qos(hdr->frame_control)) {
+			u8 *qoshdr = ieee80211_get_qos_ctl(hdr);
+
+			/* MPSP trigger frame ends service period */
+			*qoshdr |= IEEE80211_QOS_CTL_EOSP;
+			info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+		}
+	}
+
+	ieee80211_add_pending_skbs(local, &frames);
+	sta_info_recalc_tim(sta);
+}
+
+/**
+ * ieee80211_mpsp_trigger_process - track status of mesh Peer Service Periods
+ *
+ * @hdr: IEEE 802.11 QoS Header
+ * @sta: peer to start a MPSP with
+ * @tx: frame was transmitted by the local STA
+ * @acked: frame has been transmitted successfully
+ *
+ * NOTE: active mode STA may only serve as MPSP owner
+ */
+void ieee80211_mpsp_trigger_process(struct ieee80211_hdr *hdr,
+				    struct sta_info *sta, bool tx, bool acked)
+{
+	__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
+	__le16 rspi = *qc & cpu_to_le16(IEEE80211_QOS_CTL_RSPI);
+	__le16 eosp = *qc & cpu_to_le16(IEEE80211_QOS_CTL_EOSP);
+
+	if (tx) {
+		if (rspi && acked)
+			test_and_set_mpsp_flag(sta, WLAN_STA_MPSP_RECIPIENT);
+
+		if (eosp)
+			test_and_clear_mpsp_flag(sta, WLAN_STA_MPSP_OWNER);
+		else if (acked &&
+			 test_sta_flag(sta, WLAN_STA_PS_STA) &&
+			 !test_and_set_mpsp_flag(sta, WLAN_STA_MPSP_OWNER))
+			mps_frame_deliver(sta, -1);
+	} else {
+		if (eosp)
+			test_and_clear_mpsp_flag(sta, WLAN_STA_MPSP_RECIPIENT);
+		else if (sta->local_pm != NL80211_MESH_POWER_ACTIVE)
+			test_and_set_mpsp_flag(sta, WLAN_STA_MPSP_RECIPIENT);
+
+		if (rspi && !test_and_set_mpsp_flag(sta, WLAN_STA_MPSP_OWNER))
+			mps_frame_deliver(sta, -1);
+	}
+}
+
+/**
+ * ieee80211_mps_frame_release - release buffered frames in response to beacon
+ *
+ * @sta: mesh STA
+ * @elems: beacon IEs
+ *
+ * For peers if we have individually-addressed frames buffered or the peer
+ * indicates buffered frames, send a corresponding MPSP trigger frame. Since
+ * we do not evaluate the awake window duration, QoS Nulls are used as MPSP
+ * trigger frames. If the neighbour STA is not a peer, only send single frames.
+ */
+void ieee80211_mps_frame_release(struct sta_info *sta,
+				 struct ieee802_11_elems *elems)
+{
+	int ac, buffer_local = 0;
+	bool has_buffered = false;
+
+	/* TIM map only for LLID <= IEEE80211_MAX_AID */
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		has_buffered = ieee80211_check_tim(elems->tim, elems->tim_len,
+				le16_to_cpu(sta->llid) % IEEE80211_MAX_AID);
+
+	if (has_buffered)
+		mps_dbg(sta->sdata, "%pM indicates buffered frames\n",
+			sta->sta.addr);
+
+	/* only transmit to PS STA with announced, non-zero awake window */
+	if (test_sta_flag(sta, WLAN_STA_PS_STA) &&
+	    (!elems->awake_window || !le16_to_cpu(*elems->awake_window)))
+		return;
+
+	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
+		buffer_local += skb_queue_len(&sta->ps_tx_buf[ac]) +
+				skb_queue_len(&sta->tx_filtered[ac]);
+
+	if (!has_buffered && !buffer_local)
+		return;
+
+	if (sta->plink_state == NL80211_PLINK_ESTAB)
+		mpsp_trigger_send(sta, has_buffered, !buffer_local);
+	else
+		mps_frame_deliver(sta, 1);
+}
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a190895..c98be05 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1452,6 +1452,10 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		}
 	}
 
+	/* mesh power save support */
+	if (ieee80211_vif_is_mesh(&rx->sdata->vif))
+		ieee80211_mps_rx_h_sta_process(sta, hdr);
+
 	/*
 	 * Drop (qos-)data::nullfunc frames silently, since they
 	 * are used only to control station power saving mode.
@@ -2090,7 +2094,10 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	if (is_multicast_ether_addr(fwd_hdr->addr1)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_mcast);
 		memcpy(fwd_hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		/* update power mode indication when forwarding */
+		ieee80211_mps_set_frame_flags(sdata, NULL, fwd_hdr);
 	} else if (!mesh_nexthop_lookup(fwd_skb, sdata)) {
+		/* mesh power mode flags updated in mesh_nexthop_lookup */
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, fwded_unicast);
 	} else {
 		/* unable to resolve next hop */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9d864ed..3d447a1 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -120,6 +120,8 @@ static void cleanup_single_sta(struct sta_info *sta)
 		if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 		    sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			ps = &sdata->bss->ps;
+		else if (ieee80211_vif_is_mesh(&sdata->vif))
+			ps = &sdata->u.mesh.ps;
 		else
 			return;
 
@@ -592,6 +594,12 @@ void sta_info_recalc_tim(struct sta_info *sta)
 
 		ps = &sta->sdata->bss->ps;
 		id = sta->sta.aid;
+#ifdef CONFIG_MAC80211_MESH
+	} else if (ieee80211_vif_is_mesh(&sta->sdata->vif)) {
+		ps = &sta->sdata->u.mesh.ps;
+		/* TIM map only for PLID <= IEEE80211_MAX_AID */
+		id = le16_to_cpu(sta->plid) % IEEE80211_MAX_AID;
+#endif
 	} else {
 		return;
 	}
@@ -750,8 +758,9 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 	bool have_buffered = false;
 	int ac;
 
-	/* This is only necessary for stations on BSS interfaces */
-	if (!sta->sdata->bss)
+	/* This is only necessary for stations on BSS/MBSS interfaces */
+	if (!sta->sdata->bss &&
+	    !ieee80211_vif_is_mesh(&sta->sdata->vif))
 		return false;
 
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
@@ -997,6 +1006,8 @@ static void clear_sta_ps_flags(void *_sta)
 	if (sdata->vif.type == NL80211_IFTYPE_AP ||
 	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		ps = &sdata->bss->ps;
+	else if (ieee80211_vif_is_mesh(&sdata->vif))
+		ps = &sdata->u.mesh.ps;
 	else
 		return;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index af7d78a..5a1deba 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -56,6 +56,8 @@
  * @WLAN_STA_INSERTED: This station is inserted into the hash table.
  * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
  * @WLAN_STA_TOFFSET_KNOWN: toffset calculated for this station is valid.
+ * @WLAN_STA_MPSP_OWNER: local STA is owner of a mesh Peer Service Period.
+ * @WLAN_STA_MPSP_RECIPIENT: local STA is recipient of a MPSP.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -78,6 +80,8 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_INSERTED,
 	WLAN_STA_RATE_CONTROL,
 	WLAN_STA_TOFFSET_KNOWN,
+	WLAN_STA_MPSP_OWNER,
+	WLAN_STA_MPSP_RECIPIENT,
 };
 
 #define ADDBA_RESP_INTERVAL HZ
@@ -282,6 +286,9 @@ struct sta_ampdu_mlme {
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
  * @ch_width: peer's channel width
+ * @local_pm: local link-specific power save mode
+ * @peer_pm: peer-specific power save mode towards local STA
+ * @nonpeer_pm: STA power save mode towards non-peer neighbors
  * @debugfs: debug filesystem info
  * @dead: set to true when sta is unlinked
  * @uploaded: set to true when sta is uploaded to the driver
@@ -379,6 +386,10 @@ struct sta_info {
 	s64 t_offset;
 	s64 t_offset_setpoint;
 	enum nl80211_chan_width ch_width;
+	/* mesh power save */
+	enum nl80211_mesh_power_mode local_pm;
+	enum nl80211_mesh_power_mode peer_pm;
+	enum nl80211_mesh_power_mode nonpeer_pm;
 #endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 07d9957..5e04201 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -468,6 +468,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			return;
 		}
 
+		/* mesh Peer Service Period support */
+		if (ieee80211_vif_is_mesh(&sta->sdata->vif) &&
+		    ieee80211_is_data_qos(hdr->frame_control))
+			ieee80211_mpsp_trigger_process(hdr, sta, true, acked);
+
 		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
 		    (rates_idx != -1))
 			sta->last_tx_rate = info->status.rates[rates_idx];
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 629b0d0..1890441 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -329,6 +329,8 @@ static void purge_old_ps_buffers(struct ieee80211_local *local)
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			ps = &sdata->u.ap.ps;
+		else if (ieee80211_vif_is_mesh(&sdata->vif))
+			ps = &sdata->u.mesh.ps;
 		else
 			continue;
 
@@ -372,18 +374,20 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	/*
 	 * broadcast/multicast frame
 	 *
-	 * If any of the associated stations is in power save mode,
+	 * If any of the associated/peer stations is in power save mode,
 	 * the frame is buffered to be sent after DTIM beacon frame.
 	 * This is done either by the hardware or us.
 	 */
 
-	/* powersaving STAs currently only in AP/VLAN mode */
+	/* powersaving STAs currently only in AP/VLAN/mesh mode */
 	if (tx->sdata->vif.type == NL80211_IFTYPE_AP ||
 	    tx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
 		if (!tx->sdata->bss)
 			return TX_CONTINUE;
 
 		ps = &tx->sdata->bss->ps;
+	} else if (ieee80211_vif_is_mesh(&tx->sdata->vif)) {
+		ps = &tx->sdata->u.mesh.ps;
 	} else {
 		return TX_CONTINUE;
 	}
@@ -1472,12 +1476,14 @@ void ieee80211_xmit(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr *) skb->data;
 	info->control.vif = &sdata->vif;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) &&
-	    ieee80211_is_data(hdr->frame_control) &&
-	    !is_multicast_ether_addr(hdr->addr1) &&
-	    mesh_nexthop_resolve(skb, sdata)) {
-		/* skb queued: don't free */
-		return;
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		if (ieee80211_is_data(hdr->frame_control) &&
+		    is_unicast_ether_addr(hdr->addr1)) {
+			if (mesh_nexthop_resolve(skb, sdata))
+				return; /* skb queued: don't free */
+		} else {
+			ieee80211_mps_set_frame_flags(sdata, NULL, hdr);
+		}
 	}
 
 	ieee80211_set_qos_hdr(sdata, skb);
@@ -2443,12 +2449,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + /* NULL SSID */
 				    2 + 8 + /* supported rates */
 				    2 + 3 + /* DS params */
+				    256 + /* TIM IE */
 				    2 + (IEEE80211_MAX_SUPP_RATES - 8) +
 				    2 + sizeof(struct ieee80211_ht_cap) +
 				    2 + sizeof(struct ieee80211_ht_operation) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
-				    sdata->u.mesh.ie_len);
+				    sdata->u.mesh.ie_len +
+				    2 + sizeof(__le16)); /* awake window */
 		if (!skb)
 			goto out;
 
@@ -2460,6 +2468,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		eth_broadcast_addr(mgmt->da);
 		memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 		memcpy(mgmt->bssid, sdata->vif.addr, ETH_ALEN);
+		ieee80211_mps_set_frame_flags(sdata, NULL, (void *) mgmt);
 		mgmt->u.beacon.beacon_int =
 			cpu_to_le16(sdata->vif.bss_conf.beacon_int);
 		mgmt->u.beacon.capab_info |= cpu_to_le16(
@@ -2473,12 +2482,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_ds_params_ie(skb, sdata) ||
+		    ieee80211_beacon_add_tim(sdata, &ifmsh->ps, skb) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
 		    mesh_add_rsn_ie(skb, sdata) ||
 		    mesh_add_ht_cap_ie(skb, sdata) ||
 		    mesh_add_ht_oper_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
+		    mesh_add_awake_window_ie(skb, sdata) ||
 		    mesh_add_vendor_ies(skb, sdata)) {
 			pr_err("o11s: couldn't add ies!\n");
 			goto out;
@@ -2732,6 +2743,8 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			goto out;
 
 		ps = &sdata->u.ap.ps;
+	} else if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		ps = &sdata->u.mesh.ps;
 	} else {
 		goto out;
 	}
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 1b94207..893920e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -805,6 +805,10 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			elems->peering = pos;
 			elems->peering_len = elen;
 			break;
+		case WLAN_EID_MESH_AWAKE_WINDOW:
+			if (elen >= 2)
+				elems->awake_window = (void *)pos;
+			break;
 		case WLAN_EID_PREQ:
 			elems->preq = pos;
 			elems->preq_len = elen;
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 906f00c..afba19c 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -191,6 +191,15 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 
 	/* qos header is 2 bytes */
 	*p++ = ack_policy | tid;
-	*p = ieee80211_vif_is_mesh(&sdata->vif) ?
-		(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		/* preserve RSPI and Mesh PS Level bit */
+		*p &= ((IEEE80211_QOS_CTL_RSPI |
+			IEEE80211_QOS_CTL_MESH_PS_LEVEL) >> 8);
+
+		/* Nulls don't have a mesh header (frame body) */
+		if (!ieee80211_is_qos_nullfunc(hdr->frame_control))
+			*p |= (IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8);
+	} else {
+		*p = 0;
+	}
 }
-- 
1.7.9.5

