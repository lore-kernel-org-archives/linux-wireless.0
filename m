Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYIJWIy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 18:08:54 -0400
Message-Id: <20080910220411.840825000@sipsolutions.net> (sfid-20080911_000859_720986_B2D24B46)
References: <20080910220145.707263000@sipsolutions.net>
Date: Thu, 11 Sep 2008 00:01:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/18] mac80211: split off mesh handling entirely
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch splits off mesh handling from the STA/IBSS.
Unfortunately it increases mesh code size a bit, but I
think it makes things clearer. The patch also reduces
per-interface run-time memory usage.

Also clean up a few places where ifdef is not required.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/cfg.c              |    6 
 net/mac80211/debugfs_netdev.c   |   38 ++--
 net/mac80211/ieee80211_i.h      |  101 ++++++------
 net/mac80211/iface.c            |   13 -
 net/mac80211/main.c             |   13 +
 net/mac80211/mesh.c             |  326 +++++++++++++++++++++++++++++++++-------
 net/mac80211/mesh.h             |   15 +
 net/mac80211/mesh_hwmp.c        |   98 ++++++------
 net/mac80211/mesh_pathtbl.c     |    8 
 net/mac80211/mesh_plink.c       |   18 +-
 net/mac80211/mlme.c             |   83 ----------
 net/mac80211/rc80211_pid_algo.c |    7 
 net/mac80211/rx.c               |    8 
 net/mac80211/scan.c             |    1 
 net/mac80211/tx.c               |    8 
 15 files changed, 451 insertions(+), 292 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-09-10 23:57:55.000000000 +0200
@@ -308,7 +308,6 @@ enum ieee80211_sta_mlme_state {
 	IEEE80211_STA_MLME_ASSOCIATED,
 	IEEE80211_STA_MLME_IBSS_SEARCH,
 	IEEE80211_STA_MLME_IBSS_JOINED,
-	IEEE80211_STA_MLME_MESH_UP
 };
 
 /* bitfield of allowed auth algs */
@@ -325,34 +324,6 @@ struct ieee80211_if_sta {
 	size_t ssid_len;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
-#ifdef CONFIG_MAC80211_MESH
-	struct timer_list mesh_path_timer;
-	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
-	size_t mesh_id_len;
-	/* Active Path Selection Protocol Identifier */
-	u8 mesh_pp_id[4];
-	/* Active Path Selection Metric Identifier */
-	u8 mesh_pm_id[4];
-	/* Congestion Control Mode Identifier */
-	u8 mesh_cc_id[4];
-	/* Local mesh Destination Sequence Number */
-	u32 dsn;
-	/* Last used PREQ ID */
-	u32 preq_id;
-	atomic_t mpaths;
-	/* Timestamp of last DSN update */
-	unsigned long last_dsn_update;
-	/* Timestamp of last DSN sent */
-	unsigned long last_preq;
-	struct mesh_rmc *rmc;
-	spinlock_t mesh_preq_queue_lock;
-	struct mesh_preq_queue preq_queue;
-	int preq_queue_len;
-	struct mesh_stats mshstats;
-	struct mesh_config mshcfg;
-	u32 mesh_seqnum;
-	bool accepting_plinks;
-#endif
 	u16 aid;
 	u16 ap_capab, capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
@@ -387,20 +358,47 @@ struct ieee80211_if_sta {
 	int num_beacons; /* number of TXed beacon frames by this STA */
 };
 
-static inline void ieee80211_if_sta_set_mesh_id(struct ieee80211_if_sta *ifsta,
-						u8 mesh_id_len, u8 *mesh_id)
-{
-#ifdef CONFIG_MAC80211_MESH
-	ifsta->mesh_id_len = mesh_id_len;
-	memcpy(ifsta->mesh_id, mesh_id, mesh_id_len);
-#endif
-}
+struct ieee80211_if_mesh {
+	struct work_struct work;
+	struct timer_list housekeeping_timer;
+	struct timer_list mesh_path_timer;
+	struct sk_buff_head skb_queue;
+
+	bool housekeeping;
+
+	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
+	size_t mesh_id_len;
+	/* Active Path Selection Protocol Identifier */
+	u8 mesh_pp_id[4];
+	/* Active Path Selection Metric Identifier */
+	u8 mesh_pm_id[4];
+	/* Congestion Control Mode Identifier */
+	u8 mesh_cc_id[4];
+	/* Local mesh Destination Sequence Number */
+	u32 dsn;
+	/* Last used PREQ ID */
+	u32 preq_id;
+	atomic_t mpaths;
+	/* Timestamp of last DSN update */
+	unsigned long last_dsn_update;
+	/* Timestamp of last DSN sent */
+	unsigned long last_preq;
+	struct mesh_rmc *rmc;
+	spinlock_t mesh_preq_queue_lock;
+	struct mesh_preq_queue preq_queue;
+	int preq_queue_len;
+	struct mesh_stats mshstats;
+	struct mesh_config mshcfg;
+	u32 mesh_seqnum;
+	bool accepting_plinks;
+	int num_beacons;
+};
 
 #ifdef CONFIG_MAC80211_MESH
-#define IEEE80211_IFSTA_MESH_CTR_INC(sta, name)	\
-	do { (sta)->mshstats.name++; } while (0)
+#define IEEE80211_IFSTA_MESH_CTR_INC(msh, name)	\
+	do { (msh)->mshstats.name++; } while (0)
 #else
-#define IEEE80211_IFSTA_MESH_CTR_INC(sta, name) \
+#define IEEE80211_IFSTA_MESH_CTR_INC(msh, name) \
 	do { } while (0)
 #endif
 
@@ -455,6 +453,9 @@ struct ieee80211_sub_if_data {
 		struct ieee80211_if_wds wds;
 		struct ieee80211_if_vlan vlan;
 		struct ieee80211_if_sta sta;
+#ifdef CONFIG_MAC80211_MESH
+		struct ieee80211_if_mesh mesh;
+#endif
 		u32 mntr_flags;
 	} u;
 
@@ -548,6 +549,19 @@ struct ieee80211_sub_if_data *vif_to_sda
 	return container_of(p, struct ieee80211_sub_if_data, vif);
 }
 
+static inline void
+ieee80211_sdata_set_mesh_id(struct ieee80211_sub_if_data *sdata,
+			    u8 mesh_id_len, u8 *mesh_id)
+{
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	ifmsh->mesh_id_len = mesh_id_len;
+	memcpy(ifmsh->mesh_id, mesh_id, mesh_id_len);
+#else
+	WARN_ON(1);
+#endif
+}
+
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
@@ -935,13 +949,6 @@ ieee80211_rx_bss_get(struct ieee80211_lo
 void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			  struct ieee80211_sta_bss *bss);
 
-#ifdef CONFIG_MAC80211_MESH
-void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
-#else
-static inline void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
-{}
-#endif
-
 /* interface handling */
 void ieee80211_if_setup(struct net_device *dev);
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
--- everything.orig/net/mac80211/cfg.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/cfg.c	2008-09-10 23:57:55.000000000 +0200
@@ -109,9 +109,9 @@ static int ieee80211_change_iface(struct
 		return ret;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) && params->mesh_id_len)
-		ieee80211_if_sta_set_mesh_id(&sdata->u.sta,
-					     params->mesh_id_len,
-					     params->mesh_id);
+		ieee80211_sdata_set_mesh_id(sdata,
+					    params->mesh_id_len,
+					    params->mesh_id);
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_MNTR || !flags)
 		return 0;
--- everything.orig/net/mac80211/debugfs_netdev.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/debugfs_netdev.c	2008-09-10 23:57:55.000000000 +0200
@@ -207,37 +207,37 @@ IEEE80211_IF_FILE(peer, u.wds.remote_add
 
 #ifdef CONFIG_MAC80211_MESH
 /* Mesh stats attributes */
-IEEE80211_IF_FILE(fwded_frames, u.sta.mshstats.fwded_frames, DEC);
-IEEE80211_IF_FILE(dropped_frames_ttl, u.sta.mshstats.dropped_frames_ttl, DEC);
+IEEE80211_IF_FILE(fwded_frames, u.mesh.mshstats.fwded_frames, DEC);
+IEEE80211_IF_FILE(dropped_frames_ttl, u.mesh.mshstats.dropped_frames_ttl, DEC);
 IEEE80211_IF_FILE(dropped_frames_no_route,
-		u.sta.mshstats.dropped_frames_no_route, DEC);
-IEEE80211_IF_FILE(estab_plinks, u.sta.mshstats.estab_plinks, ATOMIC);
+		u.mesh.mshstats.dropped_frames_no_route, DEC);
+IEEE80211_IF_FILE(estab_plinks, u.mesh.mshstats.estab_plinks, ATOMIC);
 
 /* Mesh parameters */
 IEEE80211_IF_WFILE(dot11MeshMaxRetries,
-		u.sta.mshcfg.dot11MeshMaxRetries, DEC, u8);
+		u.mesh.mshcfg.dot11MeshMaxRetries, DEC, u8);
 IEEE80211_IF_WFILE(dot11MeshRetryTimeout,
-		u.sta.mshcfg.dot11MeshRetryTimeout, DEC, u16);
+		u.mesh.mshcfg.dot11MeshRetryTimeout, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshConfirmTimeout,
-		u.sta.mshcfg.dot11MeshConfirmTimeout, DEC, u16);
+		u.mesh.mshcfg.dot11MeshConfirmTimeout, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshHoldingTimeout,
-		u.sta.mshcfg.dot11MeshHoldingTimeout, DEC, u16);
-IEEE80211_IF_WFILE(dot11MeshTTL, u.sta.mshcfg.dot11MeshTTL, DEC, u8);
-IEEE80211_IF_WFILE(auto_open_plinks, u.sta.mshcfg.auto_open_plinks, DEC, u8);
+		u.mesh.mshcfg.dot11MeshHoldingTimeout, DEC, u16);
+IEEE80211_IF_WFILE(dot11MeshTTL, u.mesh.mshcfg.dot11MeshTTL, DEC, u8);
+IEEE80211_IF_WFILE(auto_open_plinks, u.mesh.mshcfg.auto_open_plinks, DEC, u8);
 IEEE80211_IF_WFILE(dot11MeshMaxPeerLinks,
-		u.sta.mshcfg.dot11MeshMaxPeerLinks, DEC, u16);
+		u.mesh.mshcfg.dot11MeshMaxPeerLinks, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshHWMPactivePathTimeout,
-		u.sta.mshcfg.dot11MeshHWMPactivePathTimeout, DEC, u32);
+		u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout, DEC, u32);
 IEEE80211_IF_WFILE(dot11MeshHWMPpreqMinInterval,
-		u.sta.mshcfg.dot11MeshHWMPpreqMinInterval, DEC, u16);
+		u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshHWMPnetDiameterTraversalTime,
-		u.sta.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC, u16);
+		u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime, DEC, u16);
 IEEE80211_IF_WFILE(dot11MeshHWMPmaxPREQretries,
-		u.sta.mshcfg.dot11MeshHWMPmaxPREQretries, DEC, u8);
+		u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries, DEC, u8);
 IEEE80211_IF_WFILE(path_refresh_time,
-		u.sta.mshcfg.path_refresh_time, DEC, u32);
+		u.mesh.mshcfg.path_refresh_time, DEC, u32);
 IEEE80211_IF_WFILE(min_discovery_timeout,
-		u.sta.mshcfg.min_discovery_timeout, DEC, u16);
+		u.mesh.mshcfg.min_discovery_timeout, DEC, u16);
 #endif
 
 
@@ -350,7 +350,7 @@ static void add_files(struct ieee80211_s
 		add_mesh_stats(sdata);
 		add_mesh_config(sdata);
 #endif
-		/* fall through */
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		add_sta_files(sdata);
@@ -487,7 +487,7 @@ static void del_files(struct ieee80211_s
 		del_mesh_stats(sdata);
 		del_mesh_config(sdata);
 #endif
-		/* fall through */
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		del_sta_files(sdata);
--- everything.orig/net/mac80211/iface.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-09-10 23:57:55.000000000 +0200
@@ -54,10 +54,9 @@ static void ieee80211_teardown_sdata(str
 
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
-		/* Allow compiler to elide mesh_rmc_free call. */
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			mesh_rmc_free(sdata);
-		/* fall through */
+		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		kfree(sdata->u.sta.extra_ie);
@@ -100,7 +99,6 @@ static void ieee80211_setup_sdata(struct
 		skb_queue_head_init(&sdata->u.ap.ps_bc_buf);
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		ifsta = &sdata->u.sta;
@@ -117,7 +115,8 @@ static void ieee80211_setup_sdata(struct
 			IEEE80211_STA_AUTO_CHANNEL_SEL;
 		if (ieee80211_num_regular_queues(&sdata->local->hw) >= 4)
 			ifsta->flags |= IEEE80211_STA_WMM_ENABLED;
-
+		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		if (ieee80211_vif_is_mesh(&sdata->vif))
 			ieee80211_mesh_init_sdata(sdata);
 		break;
@@ -225,9 +224,9 @@ int ieee80211_if_add(struct ieee80211_lo
 
 	if (ieee80211_vif_is_mesh(&sdata->vif) &&
 	    params && params->mesh_id_len)
-		ieee80211_if_sta_set_mesh_id(&sdata->u.sta,
-					     params->mesh_id_len,
-					     params->mesh_id);
+		ieee80211_sdata_set_mesh_id(sdata,
+					    params->mesh_id_len,
+					    params->mesh_id);
 
 	list_add_tail_rcu(&sdata->list, &local->interfaces);
 
--- everything.orig/net/mac80211/mesh.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/mesh.c	2008-09-10 23:57:55.000000000 +0200
@@ -12,6 +12,9 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
+#define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
+#define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
+
 #define PP_OFFSET 	1		/* Path Selection Protocol */
 #define PM_OFFSET	5		/* Path Selection Metric   */
 #define CC_OFFSET	9		/* Congestion Control Mode */
@@ -35,6 +38,16 @@ void ieee80211s_stop(void)
 	kmem_cache_destroy(rm_cache);
 }
 
+static void ieee80211_mesh_housekeeping_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata = (void *) data;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	ifmsh->housekeeping = true;
+	queue_work(local->hw.workqueue, &ifmsh->work);
+}
+
 /**
  * mesh_matches_local - check if the config of a mesh point matches ours
  *
@@ -46,7 +59,7 @@ void ieee80211s_stop(void)
  */
 bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_sta *sta = &sdata->u.sta;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -58,11 +71,11 @@ bool mesh_matches_local(struct ieee802_1
 	 *   - MDA enabled
 	 * - Power management control on fc
 	 */
-	if (sta->mesh_id_len == ie->mesh_id_len &&
-		memcmp(sta->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
-		memcmp(sta->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
-		memcmp(sta->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
-		memcmp(sta->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0)
+	if (ifmsh->mesh_id_len == ie->mesh_id_len &&
+		memcmp(ifmsh->mesh_id, ie->mesh_id, ie->mesh_id_len) == 0 &&
+		memcmp(ifmsh->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) == 0 &&
+		memcmp(ifmsh->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) == 0 &&
+		memcmp(ifmsh->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) == 0)
 		return true;
 
 	return false;
@@ -95,11 +108,11 @@ void mesh_accept_plinks_update(struct ie
 	 */
 	free_plinks = mesh_plink_availables(sdata);
 
-	if (free_plinks != sdata->u.sta.accepting_plinks)
-		ieee80211_sta_timer((unsigned long) sdata);
+	if (free_plinks != sdata->u.mesh.accepting_plinks)
+		ieee80211_mesh_housekeeping_timer((unsigned long) sdata);
 }
 
-void mesh_ids_set_default(struct ieee80211_if_sta *sta)
+void mesh_ids_set_default(struct ieee80211_if_mesh *sta)
 {
 	u8 def_id[4] = {0x00, 0x0F, 0xAC, 0xff};
 
@@ -112,22 +125,22 @@ int mesh_rmc_init(struct ieee80211_sub_i
 {
 	int i;
 
-	sdata->u.sta.rmc = kmalloc(sizeof(struct mesh_rmc), GFP_KERNEL);
-	if (!sdata->u.sta.rmc)
+	sdata->u.mesh.rmc = kmalloc(sizeof(struct mesh_rmc), GFP_KERNEL);
+	if (!sdata->u.mesh.rmc)
 		return -ENOMEM;
-	sdata->u.sta.rmc->idx_mask = RMC_BUCKETS - 1;
+	sdata->u.mesh.rmc->idx_mask = RMC_BUCKETS - 1;
 	for (i = 0; i < RMC_BUCKETS; i++)
-		INIT_LIST_HEAD(&sdata->u.sta.rmc->bucket[i].list);
+		INIT_LIST_HEAD(&sdata->u.mesh.rmc->bucket[i].list);
 	return 0;
 }
 
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_rmc *rmc = sdata->u.sta.rmc;
+	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
 	struct rmc_entry *p, *n;
 	int i;
 
-	if (!sdata->u.sta.rmc)
+	if (!sdata->u.mesh.rmc)
 		return;
 
 	for (i = 0; i < RMC_BUCKETS; i++)
@@ -137,7 +150,7 @@ void mesh_rmc_free(struct ieee80211_sub_
 		}
 
 	kfree(rmc);
-	sdata->u.sta.rmc = NULL;
+	sdata->u.mesh.rmc = NULL;
 }
 
 /**
@@ -155,7 +168,7 @@ void mesh_rmc_free(struct ieee80211_sub_
 int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 		   struct ieee80211_sub_if_data *sdata)
 {
-	struct mesh_rmc *rmc = sdata->u.sta.rmc;
+	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
 	u32 seqnum = 0;
 	int entries = 0;
 	u8 idx;
@@ -217,11 +230,11 @@ void mesh_mgmt_ies_add(struct sk_buff *s
 		}
 	}
 
-	pos = skb_put(skb, 2 + sdata->u.sta.mesh_id_len);
+	pos = skb_put(skb, 2 + sdata->u.mesh.mesh_id_len);
 	*pos++ = WLAN_EID_MESH_ID;
-	*pos++ = sdata->u.sta.mesh_id_len;
-	if (sdata->u.sta.mesh_id_len)
-		memcpy(pos, sdata->u.sta.mesh_id, sdata->u.sta.mesh_id_len);
+	*pos++ = sdata->u.mesh.mesh_id_len;
+	if (sdata->u.mesh.mesh_id_len)
+		memcpy(pos, sdata->u.mesh.mesh_id, sdata->u.mesh.mesh_id_len);
 
 	pos = skb_put(skb, 21);
 	*pos++ = WLAN_EID_MESH_CONFIG;
@@ -230,15 +243,15 @@ void mesh_mgmt_ies_add(struct sk_buff *s
 	*pos++ = 1;
 
 	/* Active path selection protocol ID */
-	memcpy(pos, sdata->u.sta.mesh_pp_id, 4);
+	memcpy(pos, sdata->u.mesh.mesh_pp_id, 4);
 	pos += 4;
 
 	/* Active path selection metric ID   */
-	memcpy(pos, sdata->u.sta.mesh_pm_id, 4);
+	memcpy(pos, sdata->u.mesh.mesh_pm_id, 4);
 	pos += 4;
 
 	/* Congestion control mode identifier */
-	memcpy(pos, sdata->u.sta.mesh_cc_id, 4);
+	memcpy(pos, sdata->u.mesh.mesh_cc_id, 4);
 	pos += 4;
 
 	/* Channel precedence:
@@ -248,8 +261,8 @@ void mesh_mgmt_ies_add(struct sk_buff *s
 	pos += 4;
 
 	/* Mesh capability */
-	sdata->u.sta.accepting_plinks = mesh_plink_availables(sdata);
-	*pos++ = sdata->u.sta.accepting_plinks ? ACCEPT_PLINKS : 0x00;
+	sdata->u.mesh.accepting_plinks = mesh_plink_availables(sdata);
+	*pos++ = sdata->u.mesh.accepting_plinks ? ACCEPT_PLINKS : 0x00;
 	*pos++ = 0x00;
 
 	return;
@@ -337,10 +350,10 @@ static void ieee80211_mesh_path_timer(un
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = wdev_priv(&sdata->wdev);
 
-	queue_work(local->hw.workqueue, &ifsta->work);
+	queue_work(local->hw.workqueue, &ifmsh->work);
 }
 
 struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
@@ -392,50 +405,255 @@ int ieee80211_new_mesh_header(struct iee
 		struct ieee80211_sub_if_data *sdata)
 {
 	meshhdr->flags = 0;
-	meshhdr->ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
-	put_unaligned(cpu_to_le32(sdata->u.sta.mesh_seqnum), &meshhdr->seqnum);
-	sdata->u.sta.mesh_seqnum++;
+	meshhdr->ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
+	put_unaligned(cpu_to_le32(sdata->u.mesh.mesh_seqnum), &meshhdr->seqnum);
+	sdata->u.mesh.mesh_seqnum++;
 
 	return 6;
 }
 
+static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_if_mesh *ifmsh)
+{
+	bool free_plinks;
+
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: running mesh housekeeping\n",
+	       sdata->dev->name);
+#endif
+
+	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
+	mesh_path_expire(sdata);
+
+	free_plinks = mesh_plink_availables(sdata);
+	if (free_plinks != sdata->u.mesh.accepting_plinks)
+		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+
+	ifmsh->housekeeping = false;
+	mod_timer(&ifmsh->housekeeping_timer,
+		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
+}
+
+
+void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
+
+	ifmsh->housekeeping = true;
+	queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
+}
+
+void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
+{
+	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
+	/*
+	 * When we get here, the interface is marked down.
+	 * Call synchronize_rcu() to wait for the RX path
+	 * should it be using the interface and enqueuing
+	 * frames at this very time on another CPU.
+	 */
+	synchronize_rcu();
+	skb_queue_purge(&sdata->u.mesh.skb_queue);
+}
+
+static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
+					u16 stype,
+					struct ieee80211_mgmt *mgmt,
+					size_t len,
+					struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_local *local= sdata->local;
+	struct ieee802_11_elems elems;
+	struct ieee80211_channel *channel;
+	u64 supp_rates = 0;
+	size_t baselen;
+	int freq;
+	enum ieee80211_band band = rx_status->band;
+
+	/* ignore ProbeResp to foreign address */
+	if (stype == IEEE80211_STYPE_PROBE_RESP &&
+	    compare_ether_addr(mgmt->da, sdata->dev->dev_addr))
+		return;
+
+	baselen = (u8 *) mgmt->u.probe_resp.variable - (u8 *) mgmt;
+	if (baselen > len)
+		return;
+
+	ieee802_11_parse_elems(mgmt->u.probe_resp.variable, len - baselen,
+			       &elems);
+
+	if (elems.ds_params && elems.ds_params_len == 1)
+		freq = ieee80211_channel_to_frequency(elems.ds_params[0]);
+	else
+		freq = rx_status->freq;
+
+	channel = ieee80211_get_channel(local->hw.wiphy, freq);
+
+	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
+		return;
+
+	if (elems.mesh_id && elems.mesh_config &&
+	    mesh_matches_local(&elems, sdata)) {
+		supp_rates = ieee80211_sta_get_rates(local, &elems, band);
+
+		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
+				      mesh_peer_accepts_plinks(&elems));
+	}
+}
+
+static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
+					  struct ieee80211_mgmt *mgmt,
+					  size_t len,
+					  struct ieee80211_rx_status *rx_status)
+{
+	switch (mgmt->u.action.category) {
+	case PLINK_CATEGORY:
+		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
+		break;
+	case MESH_PATH_SEL_CATEGORY:
+		mesh_rx_path_sel_frame(sdata, mgmt, len);
+		break;
+	}
+}
+
+static void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+					  struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *rx_status;
+	struct ieee80211_if_mesh *ifmsh;
+	struct ieee80211_mgmt *mgmt;
+	u16 stype;
+
+	ifmsh = &sdata->u.mesh;
+
+	rx_status = (struct ieee80211_rx_status *) skb->cb;
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	stype = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_STYPE;
+
+	switch (stype) {
+	case IEEE80211_STYPE_PROBE_RESP:
+	case IEEE80211_STYPE_BEACON:
+		ieee80211_mesh_rx_bcn_presp(sdata, stype, mgmt, skb->len,
+					    rx_status);
+		break;
+	case IEEE80211_STYPE_ACTION:
+		ieee80211_mesh_rx_mgmt_action(sdata, mgmt, skb->len, rx_status);
+		break;
+	}
+
+	kfree_skb(skb);
+}
+
+static void ieee80211_mesh_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, u.mesh.work);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct sk_buff *skb;
+
+	if (!netif_running(sdata->dev))
+		return;
+
+	if (local->sta_sw_scanning || local->sta_hw_scanning)
+		return;
+
+	while ((skb = skb_dequeue(&ifmsh->skb_queue)))
+		ieee80211_mesh_rx_queued_mgmt(sdata, skb);
+
+	if (ifmsh->preq_queue_len &&
+	    time_after(jiffies,
+		       ifmsh->last_preq + msecs_to_jiffies(ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval)))
+		mesh_path_start_discovery(sdata);
+
+	if (ifmsh->housekeeping)
+		ieee80211_mesh_housekeeping(sdata, ifmsh);
+}
+
+void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list)
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			queue_work(local->hw.workqueue, &sdata->u.mesh.work);
+	rcu_read_unlock();
+}
+
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	INIT_WORK(&ifmsh->work, ieee80211_mesh_work);
+	setup_timer(&ifmsh->housekeeping_timer,
+		    ieee80211_mesh_housekeeping_timer,
+		    (unsigned long) sdata);
+	skb_queue_head_init(&sdata->u.mesh.skb_queue);
 
-	ifsta->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
-	ifsta->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
-	ifsta->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
-	ifsta->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
-	ifsta->mshcfg.dot11MeshTTL = MESH_TTL;
-	ifsta->mshcfg.auto_open_plinks = true;
-	ifsta->mshcfg.dot11MeshMaxPeerLinks =
+	ifmsh->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
+	ifmsh->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
+	ifmsh->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
+	ifmsh->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
+	ifmsh->mshcfg.dot11MeshTTL = MESH_TTL;
+	ifmsh->mshcfg.auto_open_plinks = true;
+	ifmsh->mshcfg.dot11MeshMaxPeerLinks =
 		MESH_MAX_ESTAB_PLINKS;
-	ifsta->mshcfg.dot11MeshHWMPactivePathTimeout =
+	ifmsh->mshcfg.dot11MeshHWMPactivePathTimeout =
 		MESH_PATH_TIMEOUT;
-	ifsta->mshcfg.dot11MeshHWMPpreqMinInterval =
+	ifmsh->mshcfg.dot11MeshHWMPpreqMinInterval =
 		MESH_PREQ_MIN_INT;
-	ifsta->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
+	ifmsh->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
 		MESH_DIAM_TRAVERSAL_TIME;
-	ifsta->mshcfg.dot11MeshHWMPmaxPREQretries =
+	ifmsh->mshcfg.dot11MeshHWMPmaxPREQretries =
 		MESH_MAX_PREQ_RETRIES;
-	ifsta->mshcfg.path_refresh_time =
+	ifmsh->mshcfg.path_refresh_time =
 		MESH_PATH_REFRESH_TIME;
-	ifsta->mshcfg.min_discovery_timeout =
+	ifmsh->mshcfg.min_discovery_timeout =
 		MESH_MIN_DISCOVERY_TIMEOUT;
-	ifsta->accepting_plinks = true;
-	ifsta->preq_id = 0;
-	ifsta->dsn = 0;
-	atomic_set(&ifsta->mpaths, 0);
+	ifmsh->accepting_plinks = true;
+	ifmsh->preq_id = 0;
+	ifmsh->dsn = 0;
+	atomic_set(&ifmsh->mpaths, 0);
 	mesh_rmc_init(sdata);
-	ifsta->last_preq = jiffies;
+	ifmsh->last_preq = jiffies;
 	/* Allocate all mesh structures when creating the first mesh interface. */
 	if (!mesh_allocated)
 		ieee80211s_init();
-	mesh_ids_set_default(ifsta);
-	setup_timer(&ifsta->mesh_path_timer,
+	mesh_ids_set_default(ifmsh);
+	setup_timer(&ifmsh->mesh_path_timer,
 		    ieee80211_mesh_path_timer,
 		    (unsigned long) sdata);
-	INIT_LIST_HEAD(&ifsta->preq_queue.list);
-	spin_lock_init(&ifsta->mesh_preq_queue_lock);
+	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
+	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
+}
+
+ieee80211_rx_result
+ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		       struct ieee80211_rx_status *rx_status)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_mgmt *mgmt;
+	u16 fc;
+
+	if (skb->len < 24)
+		return RX_DROP_MONITOR;
+
+	mgmt = (struct ieee80211_mgmt *) skb->data;
+	fc = le16_to_cpu(mgmt->frame_control);
+
+	switch (fc & IEEE80211_FCTL_STYPE) {
+	case IEEE80211_STYPE_PROBE_RESP:
+	case IEEE80211_STYPE_BEACON:
+	case IEEE80211_STYPE_ACTION:
+		memcpy(skb->cb, rx_status, sizeof(*rx_status));
+		skb_queue_tail(&ifmsh->skb_queue, skb);
+		queue_work(local->hw.workqueue, &ifmsh->work);
+		return RX_QUEUED;
+	}
+
+	return RX_CONTINUE;
 }
--- everything.orig/net/mac80211/mesh.h	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/mesh.h	2008-09-10 23:57:55.000000000 +0200
@@ -206,7 +206,7 @@ int mesh_rmc_check(u8 *addr, struct ieee
 		struct ieee80211_sub_if_data *sdata);
 bool mesh_matches_local(struct ieee802_11_elems *ie,
 		struct ieee80211_sub_if_data *sdata);
-void mesh_ids_set_default(struct ieee80211_if_sta *sta);
+void mesh_ids_set_default(struct ieee80211_if_mesh *mesh);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
@@ -214,6 +214,11 @@ int mesh_rmc_init(struct ieee80211_sub_i
 void ieee80211s_init(void);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
+ieee80211_rx_result
+ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
+		       struct ieee80211_rx_status *rx_status);
+void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
+void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
@@ -269,8 +274,8 @@ extern int mesh_allocated;
 
 static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
 {
-	return sdata->u.sta.mshcfg.dot11MeshMaxPeerLinks -
-	       atomic_read(&sdata->u.sta.mshstats.estab_plinks);
+	return sdata->u.mesh.mshcfg.dot11MeshMaxPeerLinks -
+	       atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
 }
 
 static inline bool mesh_plink_availables(struct ieee80211_sub_if_data *sdata)
@@ -288,8 +293,12 @@ static inline void mesh_path_activate(st
 	for (i = 0; i <= x->hash_mask; i++) \
 		hlist_for_each_entry_rcu(node, p, &x->hash_buckets[i], list)
 
+void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
+
 #else
 #define mesh_allocated	0
+static inline void
+ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
 #endif
 
 #endif /* IEEE80211S_H */
--- everything.orig/net/mac80211/mlme.c	2008-09-10 23:57:55.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-09-10 23:57:55.000000000 +0200
@@ -22,11 +22,11 @@
 #include <linux/rtnetlink.h>
 #include <net/iw_handler.h>
 #include <net/mac80211.h>
+#include <asm/unaligned.h>
 
 #include "ieee80211_i.h"
 #include "rate.h"
 #include "led.h"
-#include "mesh.h"
 
 #define IEEE80211_ASSOC_SCANS_MAX_TRIES 2
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
@@ -34,7 +34,6 @@
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
-#define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
 #define IEEE80211_PROBE_INTERVAL (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
@@ -43,7 +42,6 @@
 
 #define IEEE80211_IBSS_MERGE_INTERVAL (30 * HZ)
 #define IEEE80211_IBSS_INACTIVITY_LIMIT (60 * HZ)
-#define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
@@ -1539,14 +1537,6 @@ static void ieee80211_rx_bss_info(struct
 	if (!channel || channel->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	if (ieee80211_vif_is_mesh(&sdata->vif) && elems->mesh_id &&
-	    elems->mesh_config && mesh_matches_local(elems, sdata)) {
-		supp_rates = ieee80211_sta_get_rates(local, elems, band);
-
-		mesh_neighbour_update(mgmt->sa, supp_rates, sdata,
-				      mesh_peer_accepts_plinks(elems));
-	}
-
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems->supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0) {
 		supp_rates = ieee80211_sta_get_rates(local, elems, band);
@@ -1816,26 +1806,6 @@ static void ieee80211_rx_mgmt_probe_req(
 	ieee80211_tx_skb(sdata, skb, 0);
 }
 
-static void ieee80211_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
-				     struct ieee80211_if_sta *ifsta,
-				     struct ieee80211_mgmt *mgmt,
-				     size_t len,
-				     struct ieee80211_rx_status *rx_status)
-{
-	/* currently we only handle mesh interface action frames here */
-	if (!ieee80211_vif_is_mesh(&sdata->vif))
-		return;
-
-	switch (mgmt->u.action.category) {
-	case PLINK_CATEGORY:
-		mesh_rx_plink_frame(sdata, mgmt, len, rx_status);
-		break;
-	case MESH_PATH_SEL_CATEGORY:
-		mesh_rx_path_sel_frame(sdata, mgmt, len);
-		break;
-	}
-}
-
 void ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb,
 			   struct ieee80211_rx_status *rx_status)
 {
@@ -1856,7 +1826,6 @@ void ieee80211_sta_rx_mgmt(struct ieee80
 	case IEEE80211_STYPE_PROBE_REQ:
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
-	case IEEE80211_STYPE_ACTION:
 		memcpy(skb->cb, rx_status, sizeof(*rx_status));
 	case IEEE80211_STYPE_AUTH:
 	case IEEE80211_STYPE_ASSOC_RESP:
@@ -1912,9 +1881,6 @@ static void ieee80211_sta_rx_queued_mgmt
 	case IEEE80211_STYPE_DISASSOC:
 		ieee80211_rx_mgmt_disassoc(sdata, ifsta, mgmt, skb->len);
 		break;
-	case IEEE80211_STYPE_ACTION:
-		ieee80211_rx_mgmt_action(sdata, ifsta, mgmt, skb->len, rx_status);
-		break;
 	}
 
 	kfree_skb(skb);
@@ -1959,35 +1925,6 @@ static void ieee80211_sta_merge_ibss(str
 }
 
 
-#ifdef CONFIG_MAC80211_MESH
-static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
-			   struct ieee80211_if_sta *ifsta)
-{
-	bool free_plinks;
-
-	ieee80211_sta_expire(sdata, IEEE80211_MESH_PEER_INACTIVITY_LIMIT);
-	mesh_path_expire(sdata);
-
-	free_plinks = mesh_plink_availables(sdata);
-	if (free_plinks != sdata->u.sta.accepting_plinks)
-		ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
-
-	mod_timer(&ifsta->timer, jiffies +
-			IEEE80211_MESH_HOUSEKEEPING_INTERVAL);
-}
-
-
-void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_sta *ifsta;
-	ifsta = &sdata->u.sta;
-	ifsta->state = IEEE80211_STA_MLME_MESH_UP;
-	ieee80211_sta_timer((unsigned long)sdata);
-	ieee80211_if_config(sdata, IEEE80211_IFCC_BEACON);
-}
-#endif
-
-
 void ieee80211_sta_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
@@ -2555,21 +2492,13 @@ void ieee80211_sta_work(struct work_stru
 		return;
 
 	if (WARN_ON(sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-		    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
+		    sdata->vif.type != IEEE80211_IF_TYPE_IBSS))
 		return;
 	ifsta = &sdata->u.sta;
 
 	while ((skb = skb_dequeue(&ifsta->skb_queue)))
 		ieee80211_sta_rx_queued_mgmt(sdata, skb);
 
-#ifdef CONFIG_MAC80211_MESH
-	if (ifsta->preq_queue_len &&
-	    time_after(jiffies,
-		       ifsta->last_preq + msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
-		mesh_path_start_discovery(sdata);
-#endif
-
 	if (ifsta->state != IEEE80211_STA_MLME_DIRECT_PROBE &&
 	    ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_STA_MLME_ASSOCIATE &&
@@ -2606,11 +2535,6 @@ void ieee80211_sta_work(struct work_stru
 	case IEEE80211_STA_MLME_IBSS_JOINED:
 		ieee80211_sta_merge_ibss(sdata, ifsta);
 		break;
-#ifdef CONFIG_MAC80211_MESH
-	case IEEE80211_STA_MLME_MESH_UP:
-		ieee80211_mesh_housekeeping(sdata, ifsta);
-		break;
-#endif
 	default:
 		WARN_ON(1);
 		break;
@@ -2627,8 +2551,7 @@ void ieee80211_sta_work(struct work_stru
 
 static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 {
-	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
-	    ieee80211_vif_is_mesh(&sdata->vif))
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA)
 		queue_work(sdata->local->hw.workqueue,
 			   &sdata->u.sta.work);
 }
--- everything.orig/net/mac80211/rx.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/rx.c	2008-09-10 23:57:55.000000000 +0200
@@ -1404,7 +1404,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80
 
 	if (rx->flags & IEEE80211_RX_RA_MATCH) {
 		if (!mesh_hdr->ttl)
-			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.sta,
+			IEEE80211_IFSTA_MESH_CTR_INC(&rx->sdata->u.mesh,
 						     dropped_frames_ttl);
 		else {
 			struct ieee80211_hdr *fwd_hdr;
@@ -1591,9 +1591,11 @@ ieee80211_rx_h_mgmt(struct ieee80211_rx_
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_DROP_MONITOR;
 
+	if (ieee80211_vif_is_mesh(&sdata->vif))
+		return ieee80211_mesh_rx_mgmt(sdata, rx->skb, rx->status);
+
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT)
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS)
 		return RX_DROP_MONITOR;
 
 	if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME)
--- everything.orig/net/mac80211/tx.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/tx.c	2008-09-10 23:57:55.000000000 +0200
@@ -1330,7 +1330,7 @@ int ieee80211_master_start_xmit(struct s
 				if (mesh_nexthop_lookup(skb, osdata))
 					return  0;
 			if (memcmp(odev->dev_addr, hdr->addr4, ETH_ALEN) != 0)
-				IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.sta,
+				IEEE80211_IFSTA_MESH_CTR_INC(&osdata->u.mesh,
 							     fwded_frames);
 		}
 	}
@@ -1483,9 +1483,9 @@ int ieee80211_subif_start_xmit(struct sk
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data, ETH_ALEN);
 		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
-		if (!sdata->u.sta.mshcfg.dot11MeshTTL) {
+		if (!sdata->u.mesh.mshcfg.dot11MeshTTL) {
 			/* Do not send frames with mesh_ttl == 0 */
-			sdata->u.sta.mshstats.dropped_frames_ttl++;
+			sdata->u.mesh.mshstats.dropped_frames_ttl++;
 			ret = 0;
 			goto fail;
 		}
@@ -1910,7 +1910,7 @@ struct sk_buff *ieee80211_beacon_get(str
 
 		mesh_mgmt_ies_add(skb, sdata);
 
-		num_beacons = &sdata->u.sta.num_beacons;
+		num_beacons = &sdata->u.mesh.num_beacons;
 	} else {
 		WARN_ON(1);
 		goto out;
--- everything.orig/net/mac80211/mesh_hwmp.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/mesh_hwmp.c	2008-09-10 23:57:55.000000000 +0200
@@ -64,14 +64,14 @@ static inline u32 u32_field_get(u8 *preq
 #define DSN_LT(x, y) ((long) (x) - (long) (y) < 0)
 
 #define net_traversal_jiffies(s) \
-	msecs_to_jiffies(s->u.sta.mshcfg.dot11MeshHWMPnetDiameterTraversalTime)
+	msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime)
 #define default_lifetime(s) \
-	MSEC_TO_TU(s->u.sta.mshcfg.dot11MeshHWMPactivePathTimeout)
+	MSEC_TO_TU(s->u.mesh.mshcfg.dot11MeshHWMPactivePathTimeout)
 #define min_preq_int_jiff(s) \
-	(msecs_to_jiffies(s->u.sta.mshcfg.dot11MeshHWMPpreqMinInterval))
-#define max_preq_retries(s) (s->u.sta.mshcfg.dot11MeshHWMPmaxPREQretries)
+	(msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPpreqMinInterval))
+#define max_preq_retries(s) (s->u.mesh.mshcfg.dot11MeshHWMPmaxPREQretries)
 #define disc_timeout_jiff(s) \
-	msecs_to_jiffies(sdata->u.sta.mshcfg.min_discovery_timeout)
+	msecs_to_jiffies(sdata->u.mesh.mshcfg.min_discovery_timeout)
 
 enum mpath_frame_type {
 	MPATH_PREQ = 0,
@@ -395,7 +395,7 @@ static u32 hwmp_route_info_get(struct ie
 static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *preq_elem, u32 metric) {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_path *mpath;
 	u8 *dst_addr, *orig_addr;
 	u8 dst_flags, ttl;
@@ -414,11 +414,11 @@ static void hwmp_preq_frame_process(stru
 		forward = false;
 		reply = true;
 		metric = 0;
-		if (time_after(jiffies, ifsta->last_dsn_update +
+		if (time_after(jiffies, ifmsh->last_dsn_update +
 					net_traversal_jiffies(sdata)) ||
-		    time_before(jiffies, ifsta->last_dsn_update)) {
-			dst_dsn = ++ifsta->dsn;
-			ifsta->last_dsn_update = jiffies;
+		    time_before(jiffies, ifmsh->last_dsn_update)) {
+			dst_dsn = ++ifmsh->dsn;
+			ifmsh->last_dsn_update = jiffies;
 		}
 	} else {
 		rcu_read_lock();
@@ -444,7 +444,7 @@ static void hwmp_preq_frame_process(stru
 
 	if (reply) {
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
-		ttl = ifsta->mshcfg.dot11MeshTTL;
+		ttl = ifmsh->mshcfg.dot11MeshTTL;
 		if (ttl != 0)
 			mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
 				cpu_to_le32(dst_dsn), 0, orig_addr,
@@ -452,7 +452,7 @@ static void hwmp_preq_frame_process(stru
 				cpu_to_le32(lifetime), cpu_to_le32(metric),
 				0, sdata);
 		else
-			ifsta->mshstats.dropped_frames_ttl++;
+			ifmsh->mshstats.dropped_frames_ttl++;
 	}
 
 	if (forward) {
@@ -462,7 +462,7 @@ static void hwmp_preq_frame_process(stru
 		ttl = PREQ_IE_TTL(preq_elem);
 		lifetime = PREQ_IE_LIFETIME(preq_elem);
 		if (ttl <= 1) {
-			ifsta->mshstats.dropped_frames_ttl++;
+			ifmsh->mshstats.dropped_frames_ttl++;
 			return;
 		}
 		--ttl;
@@ -475,7 +475,7 @@ static void hwmp_preq_frame_process(stru
 				hopcount, ttl, cpu_to_le32(lifetime),
 				cpu_to_le32(metric), cpu_to_le32(preq_id),
 				sdata);
-		ifsta->mshstats.fwded_frames++;
+		ifmsh->mshstats.fwded_frames++;
 	}
 }
 
@@ -503,7 +503,7 @@ static void hwmp_prep_frame_process(stru
 
 	ttl = PREP_IE_TTL(prep_elem);
 	if (ttl <= 1) {
-		sdata->u.sta.mshstats.dropped_frames_ttl++;
+		sdata->u.mesh.mshstats.dropped_frames_ttl++;
 		return;
 	}
 
@@ -533,12 +533,12 @@ static void hwmp_prep_frame_process(stru
 		cpu_to_le32(lifetime), cpu_to_le32(metric),
 		0, sdata);
 	rcu_read_unlock();
-	sdata->u.sta.mshstats.fwded_frames++;
+	sdata->u.mesh.mshstats.fwded_frames++;
 	return;
 
 fail:
 	rcu_read_unlock();
-	sdata->u.sta.mshstats.dropped_frames_no_route++;
+	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 	return;
 }
 
@@ -631,7 +631,7 @@ void mesh_rx_path_sel_frame(struct ieee8
 static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 {
 	struct ieee80211_sub_if_data *sdata = mpath->sdata;
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 
 	preq_node = kmalloc(sizeof(struct mesh_preq_queue), GFP_KERNEL);
@@ -640,9 +640,9 @@ static void mesh_queue_preq(struct mesh_
 		return;
 	}
 
-	spin_lock(&ifsta->mesh_preq_queue_lock);
-	if (ifsta->preq_queue_len == MAX_PREQ_QUEUE_LEN) {
-		spin_unlock(&ifsta->mesh_preq_queue_lock);
+	spin_lock(&ifmsh->mesh_preq_queue_lock);
+	if (ifmsh->preq_queue_len == MAX_PREQ_QUEUE_LEN) {
+		spin_unlock(&ifmsh->mesh_preq_queue_lock);
 		kfree(preq_node);
 		if (printk_ratelimit())
 			printk(KERN_DEBUG "Mesh HWMP: PREQ node queue full\n");
@@ -652,21 +652,21 @@ static void mesh_queue_preq(struct mesh_
 	memcpy(preq_node->dst, mpath->dst, ETH_ALEN);
 	preq_node->flags = flags;
 
-	list_add_tail(&preq_node->list, &ifsta->preq_queue.list);
-	++ifsta->preq_queue_len;
-	spin_unlock(&ifsta->mesh_preq_queue_lock);
+	list_add_tail(&preq_node->list, &ifmsh->preq_queue.list);
+	++ifmsh->preq_queue_len;
+	spin_unlock(&ifmsh->mesh_preq_queue_lock);
 
-	if (time_after(jiffies, ifsta->last_preq + min_preq_int_jiff(sdata)))
-		queue_work(sdata->local->hw.workqueue, &ifsta->work);
+	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
+		queue_work(sdata->local->hw.workqueue, &ifmsh->work);
 
-	else if (time_before(jiffies, ifsta->last_preq)) {
+	else if (time_before(jiffies, ifmsh->last_preq)) {
 		/* avoid long wait if did not send preqs for a long time
 		 * and jiffies wrapped around
 		 */
-		ifsta->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
-		queue_work(sdata->local->hw.workqueue, &ifsta->work);
+		ifmsh->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
+		queue_work(sdata->local->hw.workqueue, &ifmsh->work);
 	} else
-		mod_timer(&ifsta->mesh_path_timer, ifsta->last_preq +
+		mod_timer(&ifmsh->mesh_path_timer, ifmsh->last_preq +
 						min_preq_int_jiff(sdata));
 }
 
@@ -677,25 +677,25 @@ static void mesh_queue_preq(struct mesh_
  */
 void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 	struct mesh_path *mpath;
 	u8 ttl, dst_flags;
 	u32 lifetime;
 
-	spin_lock(&ifsta->mesh_preq_queue_lock);
-	if (!ifsta->preq_queue_len ||
-		time_before(jiffies, ifsta->last_preq +
+	spin_lock(&ifmsh->mesh_preq_queue_lock);
+	if (!ifmsh->preq_queue_len ||
+		time_before(jiffies, ifmsh->last_preq +
 				min_preq_int_jiff(sdata))) {
-		spin_unlock(&ifsta->mesh_preq_queue_lock);
+		spin_unlock(&ifmsh->mesh_preq_queue_lock);
 		return;
 	}
 
-	preq_node = list_first_entry(&ifsta->preq_queue.list,
+	preq_node = list_first_entry(&ifmsh->preq_queue.list,
 			struct mesh_preq_queue, list);
 	list_del(&preq_node->list);
-	--ifsta->preq_queue_len;
-	spin_unlock(&ifsta->mesh_preq_queue_lock);
+	--ifmsh->preq_queue_len;
+	spin_unlock(&ifmsh->mesh_preq_queue_lock);
 
 	rcu_read_lock();
 	mpath = mesh_path_lookup(preq_node->dst, sdata);
@@ -720,18 +720,18 @@ void mesh_path_start_discovery(struct ie
 		goto enddiscovery;
 	}
 
-	ifsta->last_preq = jiffies;
+	ifmsh->last_preq = jiffies;
 
-	if (time_after(jiffies, ifsta->last_dsn_update +
+	if (time_after(jiffies, ifmsh->last_dsn_update +
 				net_traversal_jiffies(sdata)) ||
-	    time_before(jiffies, ifsta->last_dsn_update)) {
-		++ifsta->dsn;
-		sdata->u.sta.last_dsn_update = jiffies;
+	    time_before(jiffies, ifmsh->last_dsn_update)) {
+		++ifmsh->dsn;
+		sdata->u.mesh.last_dsn_update = jiffies;
 	}
 	lifetime = default_lifetime(sdata);
-	ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
+	ttl = sdata->u.mesh.mshcfg.dot11MeshTTL;
 	if (ttl == 0) {
-		sdata->u.sta.mshstats.dropped_frames_ttl++;
+		sdata->u.mesh.mshstats.dropped_frames_ttl++;
 		spin_unlock_bh(&mpath->state_lock);
 		goto enddiscovery;
 	}
@@ -743,10 +743,10 @@ void mesh_path_start_discovery(struct ie
 
 	spin_unlock_bh(&mpath->state_lock);
 	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->dev->dev_addr,
-			cpu_to_le32(ifsta->dsn), dst_flags, mpath->dst,
+			cpu_to_le32(ifmsh->dsn), dst_flags, mpath->dst,
 			cpu_to_le32(mpath->dsn), sdata->dev->broadcast, 0,
 			ttl, cpu_to_le32(lifetime), 0,
-			cpu_to_le32(ifsta->preq_id++), sdata);
+			cpu_to_le32(ifmsh->preq_id++), sdata);
 	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 
 enddiscovery:
@@ -783,7 +783,7 @@ int mesh_nexthop_lookup(struct sk_buff *
 		mpath = mesh_path_lookup(dst_addr, sdata);
 		if (!mpath) {
 			dev_kfree_skb(skb);
-			sdata->u.sta.mshstats.dropped_frames_no_route++;
+			sdata->u.mesh.mshstats.dropped_frames_no_route++;
 			err = -ENOSPC;
 			goto endlookup;
 		}
@@ -791,7 +791,7 @@ int mesh_nexthop_lookup(struct sk_buff *
 
 	if (mpath->flags & MESH_PATH_ACTIVE) {
 		if (time_after(jiffies, mpath->exp_time -
-			msecs_to_jiffies(sdata->u.sta.mshcfg.path_refresh_time))
+			msecs_to_jiffies(sdata->u.mesh.mshcfg.path_refresh_time))
 				&& !memcmp(sdata->dev->dev_addr, hdr->addr4,
 					   ETH_ALEN)
 				&& !(mpath->flags & MESH_PATH_RESOLVING)
--- everything.orig/net/mac80211/mesh_pathtbl.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/mesh_pathtbl.c	2008-09-10 23:57:55.000000000 +0200
@@ -153,7 +153,7 @@ int mesh_path_add(u8 *dst, struct ieee80
 	if (is_multicast_ether_addr(dst))
 		return -ENOTSUPP;
 
-	if (atomic_add_unless(&sdata->u.sta.mpaths, 1, MESH_MAX_MPATHS) == 0)
+	if (atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS) == 0)
 		return -ENOSPC;
 
 	err = -ENOMEM;
@@ -221,7 +221,7 @@ err_exists:
 err_node_alloc:
 	kfree(new_mpath);
 err_path_alloc:
-	atomic_dec(&sdata->u.sta.mpaths);
+	atomic_dec(&sdata->u.mesh.mpaths);
 	return err;
 }
 
@@ -306,7 +306,7 @@ static void mesh_path_node_reclaim(struc
 	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
 
 	del_timer_sync(&node->mpath->timer);
-	atomic_dec(&sdata->u.sta.mpaths);
+	atomic_dec(&sdata->u.mesh.mpaths);
 	kfree(node->mpath);
 	kfree(node);
 }
@@ -401,7 +401,7 @@ void mesh_path_discard_frame(struct sk_b
 	}
 
 	kfree_skb(skb);
-	sdata->u.sta.mshstats.dropped_frames_no_route++;
+	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
 /**
--- everything.orig/net/mac80211/mesh_plink.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/mesh_plink.c	2008-09-10 23:57:55.000000000 +0200
@@ -36,11 +36,11 @@
 #define MESH_SECURITY_AUTHENTICATION_IMPOSSIBLE	9
 #define MESH_SECURITY_FAILED_VERIFICATION	10
 
-#define dot11MeshMaxRetries(s) (s->u.sta.mshcfg.dot11MeshMaxRetries)
-#define dot11MeshRetryTimeout(s) (s->u.sta.mshcfg.dot11MeshRetryTimeout)
-#define dot11MeshConfirmTimeout(s) (s->u.sta.mshcfg.dot11MeshConfirmTimeout)
-#define dot11MeshHoldingTimeout(s) (s->u.sta.mshcfg.dot11MeshHoldingTimeout)
-#define dot11MeshMaxPeerLinks(s) (s->u.sta.mshcfg.dot11MeshMaxPeerLinks)
+#define dot11MeshMaxRetries(s) (s->u.mesh.mshcfg.dot11MeshMaxRetries)
+#define dot11MeshRetryTimeout(s) (s->u.mesh.mshcfg.dot11MeshRetryTimeout)
+#define dot11MeshConfirmTimeout(s) (s->u.mesh.mshcfg.dot11MeshConfirmTimeout)
+#define dot11MeshHoldingTimeout(s) (s->u.mesh.mshcfg.dot11MeshHoldingTimeout)
+#define dot11MeshMaxPeerLinks(s) (s->u.mesh.mshcfg.dot11MeshMaxPeerLinks)
 
 enum plink_frame_type {
 	PLINK_OPEN = 0,
@@ -63,14 +63,14 @@ enum plink_event {
 static inline
 void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
 {
-	atomic_inc(&sdata->u.sta.mshstats.estab_plinks);
+	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
 }
 
 static inline
 void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
 {
-	atomic_dec(&sdata->u.sta.mshstats.estab_plinks);
+	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
 }
 
@@ -245,8 +245,8 @@ void mesh_neighbour_update(u8 *hw_addr, 
 	sta->last_rx = jiffies;
 	sta->supp_rates[local->hw.conf.channel->band] = rates;
 	if (peer_accepting_plinks && sta->plink_state == PLINK_LISTEN &&
-			sdata->u.sta.accepting_plinks &&
-			sdata->u.sta.mshcfg.auto_open_plinks)
+			sdata->u.mesh.accepting_plinks &&
+			sdata->u.mesh.mshcfg.auto_open_plinks)
 		mesh_plink_open(sta);
 
 	rcu_read_unlock();
--- everything.orig/net/mac80211/rc80211_pid_algo.c	2008-09-10 23:50:29.000000000 +0200
+++ everything/net/mac80211/rc80211_pid_algo.c	2008-09-10 23:57:55.000000000 +0200
@@ -148,9 +148,7 @@ static void rate_control_pid_sample(stru
 				    struct ieee80211_local *local,
 				    struct sta_info *sta)
 {
-#ifdef CONFIG_MAC80211_MESH
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-#endif
 	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
 	struct ieee80211_supported_band *sband;
@@ -181,11 +179,8 @@ static void rate_control_pid_sample(stru
 		pf = spinfo->last_pf;
 	else {
 		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
-#ifdef CONFIG_MAC80211_MESH
-		if (pf == 100 &&
-		    sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		if (ieee80211_vif_is_mesh(&sdata->vif) && pf == 100)
 			mesh_plink_broken(sta);
-#endif
 		pf <<= RC_PID_ARITH_SHIFT;
 		sta->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
 					>> RC_PID_ARITH_SHIFT;
--- everything.orig/net/mac80211/scan.c	2008-09-10 23:57:52.000000000 +0200
+++ everything/net/mac80211/scan.c	2008-09-10 23:57:55.000000000 +0200
@@ -476,6 +476,7 @@ void ieee80211_scan_completed(struct iee
 
  done:
 	ieee80211_mlme_notify_scan_completed(local);
+	ieee80211_mesh_notify_scan_completed(local);
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
--- everything.orig/net/mac80211/main.c	2008-09-10 23:50:30.000000000 +0200
+++ everything/net/mac80211/main.c	2008-09-10 23:57:55.000000000 +0200
@@ -252,6 +252,8 @@ static int ieee80211_open(struct net_dev
 		sdata->bss = &sdata->u.ap;
 		break;
 	case IEEE80211_IF_TYPE_MESH_POINT:
+		if (!ieee80211_vif_is_mesh(&sdata->vif))
+			break;
 		/* mesh ifaces must set allmulti to forward mcast traffic */
 		atomic_inc(&local->iff_allmultis);
 		break;
@@ -540,10 +542,6 @@ static int ieee80211_stop(struct net_dev
 		ieee80211_configure_filter(local);
 		netif_addr_unlock_bh(local->mdev);
 		break;
-	case IEEE80211_IF_TYPE_MESH_POINT:
-		/* allmulti is always set on mesh ifaces */
-		atomic_dec(&local->iff_allmultis);
-		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		sdata->u.sta.state = IEEE80211_STA_MLME_DISABLED;
@@ -571,6 +569,13 @@ static int ieee80211_stop(struct net_dev
 		sdata->u.sta.extra_ie = NULL;
 		sdata->u.sta.extra_ie_len = 0;
 		/* fall through */
+	case IEEE80211_IF_TYPE_MESH_POINT:
+		if (ieee80211_vif_is_mesh(&sdata->vif)) {
+			/* allmulti is always set on mesh ifaces */
+			atomic_dec(&local->iff_allmultis);
+			ieee80211_stop_mesh(sdata);
+		}
+		/* fall through */
 	default:
 		conf.vif = &sdata->vif;
 		conf.type = sdata->vif.type;

-- 

