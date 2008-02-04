Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.247]:37584 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYBDVYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:24:24 -0500
Received: by an-out-0708.google.com with SMTP id d31so556800and.103
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:24:23 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 11:22:49 -0800
Subject: [PATCH 08/13] o11s: other changes in mac80211 for mesh interface support
Message-ID: <47a78286.07045a0a.0fd0.ffff8bb1@mx.google.com> (sfid-20080204_212428_285984_7DC49E60)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211_i.h     |  152 ++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_iface.c |   49 ++++++++++
 net/mac80211/ieee80211_sta.c   |  197 +++++++++++++++++++++++++++++++---------
 net/mac80211/util.c            |   46 +++++++++
 4 files changed, 400 insertions(+), 44 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ac802fe..5204057 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -224,6 +224,41 @@ struct ieee80211_if_vlan {
 	struct list_head list;
 };
 
+struct mesh_stats {
+	__u32 fwded_frames;		/* Mesh forwarded frames */
+	__u32 dropped_frames_ttl;	/* Not transmitted since mesh_ttl == 0*/
+	__u32 dropped_frames_no_route;	/* Not transmitted, no route found */
+	atomic_t estab_plinks;
+};
+
+#define PREQ_Q_F_START		0x1
+#define PREQ_Q_F_REFRESH	0x2
+struct mesh_preq_queue {
+	struct list_head list;
+	u8 dst[ETH_ALEN];
+	u8 flags;
+};
+
+
+struct mesh_config {
+	/* Timeouts in ms */
+	/* Mesh plink management parameters */
+	u16 dot11MeshRetryTimeout;
+	u16 dot11MeshConfirmTimeout;
+	u16 dot11MeshHoldingTimeout;
+	u16 dot11MeshMaxPeerLinks;
+	u8  dot11MeshMaxRetries;
+	u8  dot11MeshTTL;
+	bool auto_open_plinks;
+	/* HWMP parameters */
+	u32 dot11MeshHWMPactivePathTimeout;
+	u16 dot11MeshHWMPpreqMinInterval;
+	u16 dot11MeshHWMPnetDiameterTraversalTime;
+	u8  dot11MeshHWMPmaxPREQretries;
+	u32 path_refresh_time;
+	u16 min_discovery_timeout;
+};
+
 /* flags used in struct ieee80211_if_sta.flags */
 #define IEEE80211_STA_SSID_SET		BIT(0)
 #define IEEE80211_STA_BSSID_SET		BIT(1)
@@ -242,15 +277,37 @@ struct ieee80211_if_sta {
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
 		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
-		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED
+		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
+		IEEE80211_MESH_UP
 	} state;
 	struct timer_list timer;
+	struct timer_list mesh_path_timer;
 	struct work_struct work;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
+	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
+	bool accepting_plinks;
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
+	atomic_t plinks;
+	atomic_t mpaths;
+	/* Timestamp of last DSN update */
+	unsigned long last_dsn_update;
+	/* Timestamp of last DSN sent */
+	unsigned long last_preq;
+	struct mesh_rmc *rmc;
 	u16 aid;
 	u16 ap_capab, capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
@@ -268,6 +325,9 @@ struct ieee80211_if_sta {
 #define IEEE80211_STA_REQ_RUN  2
 	unsigned long request;
 	struct sk_buff_head skb_queue;
+	spinlock_t mesh_preq_queue_lock;
+	struct mesh_preq_queue preq_queue;
+	int preq_queue_len;
 
 	unsigned long last_probe;
 
@@ -283,6 +343,9 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
 
 	int wmm_last_param_set;
+	struct mesh_stats mshstats;
+	struct mesh_config mshcfg;
+	u8 mesh_seqnum[3];
 };
 
 
@@ -386,6 +449,32 @@ struct ieee80211_sub_if_data {
 		} monitor;
 		struct dentry *default_key;
 	} debugfs;
+
+	struct dentry *mesh_stats_dir;
+	struct {
+		struct dentry *fwded_frames;
+		struct dentry *dropped_frames_ttl;
+		struct dentry *dropped_frames_no_route;
+		struct dentry *estab_plinks;
+	} mesh_stats;
+
+	struct dentry *mesh_config_dir;
+	struct {
+		struct dentry *dot11MeshRetryTimeout;
+		struct dentry *dot11MeshConfirmTimeout;
+		struct dentry *dot11MeshHoldingTimeout;
+		struct dentry *dot11MeshMaxRetries;
+		struct dentry *dot11MeshTTL;
+		struct dentry *auto_open_plinks;
+		struct dentry *dot11MeshMaxPeerLinks;
+		struct dentry *dot11MeshHWMPactivePathTimeout;
+		struct dentry *dot11MeshHWMPpreqMinInterval;
+		struct dentry *dot11MeshHWMPnetDiameterTraversalTime;
+		struct dentry *dot11MeshHWMPmaxPREQretries;
+		struct dentry *path_refresh_time;
+		struct dentry *min_discovery_timeout;
+	} mesh_config;
+
 #endif
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
@@ -614,6 +703,57 @@ struct ieee80211_ra_tid {
 	u16 tid;
 };
 
+/* Parsed Information Elements */
+struct ieee802_11_elems {
+	/* pointers to IEs */
+	u8 *ssid;
+	u8 *supp_rates;
+	u8 *fh_params;
+	u8 *ds_params;
+	u8 *cf_params;
+	u8 *tim;
+	u8 *ibss_params;
+	u8 *challenge;
+	u8 *wpa;
+	u8 *rsn;
+	u8 *erp_info;
+	u8 *ext_supp_rates;
+	u8 *wmm_info;
+	u8 *wmm_param;
+	u8 *ht_cap_elem;
+	u8 *ht_info_elem;
+	u8 *mesh_config;
+	u8 *mesh_id;
+	u8 *peer_link;
+	u8 *preq;
+	u8 *prep;
+	u8 *perr;
+
+	/* length of them, respectively */
+	u8 ssid_len;
+	u8 supp_rates_len;
+	u8 fh_params_len;
+	u8 ds_params_len;
+	u8 cf_params_len;
+	u8 tim_len;
+	u8 ibss_params_len;
+	u8 challenge_len;
+	u8 wpa_len;
+	u8 rsn_len;
+	u8 erp_info_len;
+	u8 ext_supp_rates_len;
+	u8 wmm_info_len;
+	u8 wmm_param_len;
+	u8 ht_cap_elem_len;
+	u8 ht_info_elem_len;
+	u8 mesh_config_len;
+	u8 mesh_id_len;
+	u8 peer_link_len;
+	u8 preq_len;
+	u8 prep_len;
+	u8 perr_len;
+};
+
 static inline struct ieee80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
@@ -757,6 +897,16 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
 void sta_rx_agg_session_timer_expired(unsigned long data);
 void sta_addba_resp_timer_expired(unsigned long data);
+void ieee80211_start_mesh(struct net_device *dev);
+int ieee80211_set_mesh_beacon_template(struct net_device *dev,
+				       struct ieee80211_if_conf *conf);
+void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
+		int encrypt);
+void ieee802_11_parse_elems(u8 *start, size_t len,
+				   struct ieee802_11_elems *elems);
+void ieee80211_mesh_path_timer(unsigned long data);
+
+
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
 		     struct net_device **new_dev, int type);
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index 27cee58..6257af3 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -15,6 +15,7 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "debugfs_netdev.h"
+#include "mesh.h"
 
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata)
 {
@@ -120,6 +121,9 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 
 	sdata->basic_rates = 0;
 
+	if (oldtype == IEEE80211_IF_TYPE_MESH_POINT)
+		mesh_rmc_free(dev);
+
 	switch (type) {
 	case IEEE80211_IF_TYPE_WDS:
 		/* nothing special */
@@ -134,6 +138,7 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		sdata->bss = &sdata->u.ap;
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS: {
 		struct ieee80211_sub_if_data *msdata;
@@ -155,6 +160,47 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
+
+		if (type == IEEE80211_IF_TYPE_MESH_POINT) {
+			ifsta->mshcfg.dot11MeshRetryTimeout = MESH_RET_T;
+			ifsta->mshcfg.dot11MeshConfirmTimeout = MESH_CONF_T;
+			ifsta->mshcfg.dot11MeshHoldingTimeout = MESH_HOLD_T;
+			ifsta->mshcfg.dot11MeshMaxRetries = MESH_MAX_RETR;
+			ifsta->mshcfg.dot11MeshTTL = MESH_TTL;
+			ifsta->mshcfg.auto_open_plinks = true;
+			ifsta->mshcfg.dot11MeshMaxPeerLinks =
+				MESH_MAX_ESTAB_PLINKS;
+			ifsta->mshcfg.dot11MeshHWMPactivePathTimeout =
+				MESH_PATH_TIMEOUT;
+			ifsta->mshcfg.dot11MeshHWMPpreqMinInterval =
+				MESH_PREQ_MIN_INT;
+			ifsta->mshcfg.dot11MeshHWMPnetDiameterTraversalTime =
+				MESH_DIAM_TRAVERSAL_TIME;
+			ifsta->mshcfg.dot11MeshHWMPmaxPREQretries =
+				MESH_MAX_PREQ_RETRIES;
+			ifsta->mshcfg.path_refresh_time =
+				MESH_PATH_REFRESH_TIME;
+			ifsta->mshcfg.min_discovery_timeout =
+				MESH_MIN_DISCOVERY_TIMEOUT;
+			ifsta->accepting_plinks = true;
+			ifsta->preq_id = 0;
+			ifsta->dsn = 0;
+			atomic_set(&ifsta->plinks, 0);
+			atomic_set(&ifsta->mpaths, 0);
+			mesh_rmc_init(dev);
+			ifsta->last_preq = jiffies;
+			/* Allocate all mesh structures when creating the first
+			 * mesh interface.
+			 */
+			if (!mesh_allocated)
+				ieee80211s_init();
+			mesh_set_default_ids(ifsta);
+			setup_timer(&ifsta->mesh_path_timer,
+				    ieee80211_mesh_path_timer,
+				    (unsigned long) sdata);
+			INIT_LIST_HEAD(&ifsta->preq_queue.list);
+			spin_lock_init(&ifsta->mesh_preq_queue_lock);
+		}
 		break;
 	}
 	case IEEE80211_IF_TYPE_MNTR:
@@ -231,6 +277,7 @@ void ieee80211_if_reinit(struct net_device *dev)
 		break;
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
+	case IEEE80211_IF_TYPE_MESH_POINT:
 		kfree(sdata->u.sta.extra_ie);
 		sdata->u.sta.extra_ie = NULL;
 		kfree(sdata->u.sta.assocreq_ies);
@@ -265,6 +312,8 @@ void __ieee80211_if_del(struct ieee80211_local *local,
 	struct net_device *dev = sdata->dev;
 
 	ieee80211_debugfs_remove_netdev(sdata);
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		mesh_rmc_free(dev);
 	unregister_netdevice(dev);
 	/* Except master interface, the net_device will be freed by
 	 * net_device->destructor (i. e. ieee80211_if_free). */
diff --git a/net/mac80211/ieee80211_sta.c b/net/mac80211/ieee80211_sta.c
index 7be1e73..b96ba5f 100644
--- a/net/mac80211/ieee80211_sta.c
+++ b/net/mac80211/ieee80211_sta.c
@@ -31,12 +31,14 @@
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "ieee80211_led.h"
+#include "mesh.h"
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3
 #define IEEE80211_ASSOC_TIMEOUT (HZ / 5)
 #define IEEE80211_ASSOC_MAX_TRIES 3
 #define IEEE80211_MONITORING_INTERVAL (2 * HZ)
+#define IEEE80211_MESH_EXPIRATION_INTERVAL (2 * HZ)
 #define IEEE80211_PROBE_INTERVAL (60 * HZ)
 #define IEEE80211_RETRY_AUTH_INTERVAL (1 * HZ)
 #define IEEE80211_SCAN_INTERVAL (2 * HZ)
@@ -87,45 +89,7 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 				     struct ieee80211_if_sta *ifsta);
 
 
-/* Parsed Information Elements */
-struct ieee802_11_elems {
-	/* pointers to IEs */
-	u8 *ssid;
-	u8 *supp_rates;
-	u8 *fh_params;
-	u8 *ds_params;
-	u8 *cf_params;
-	u8 *tim;
-	u8 *ibss_params;
-	u8 *challenge;
-	u8 *wpa;
-	u8 *rsn;
-	u8 *erp_info;
-	u8 *ext_supp_rates;
-	u8 *wmm_info;
-	u8 *wmm_param;
-	u8 *ht_cap_elem;
-	u8 *ht_info_elem;
-	/* length of them, respectively */
-	u8 ssid_len;
-	u8 supp_rates_len;
-	u8 fh_params_len;
-	u8 ds_params_len;
-	u8 cf_params_len;
-	u8 tim_len;
-	u8 ibss_params_len;
-	u8 challenge_len;
-	u8 wpa_len;
-	u8 rsn_len;
-	u8 erp_info_len;
-	u8 ext_supp_rates_len;
-	u8 wmm_info_len;
-	u8 wmm_param_len;
-	u8 ht_cap_elem_len;
-	u8 ht_info_elem_len;
-};
-
-static void ieee802_11_parse_elems(u8 *start, size_t len,
+void ieee802_11_parse_elems(u8 *start, size_t len,
 				   struct ieee802_11_elems *elems)
 {
 	size_t left = len;
@@ -215,6 +179,30 @@ static void ieee802_11_parse_elems(u8 *start, size_t len,
 			elems->ht_info_elem = pos;
 			elems->ht_info_elem_len = elen;
 			break;
+		case WLAN_EID_MESH_ID:
+			elems->mesh_id = pos;
+			elems->mesh_id_len = elen;
+			break;
+		case WLAN_EID_MESH_CONFIG:
+			elems->mesh_config = pos;
+			elems->mesh_config_len = elen;
+			break;
+		case WLAN_EID_PEER_LINK:
+			elems->peer_link = pos;
+			elems->peer_link_len = elen;
+			break;
+		case WLAN_EID_PREQ:
+			elems->preq = pos;
+			elems->preq_len = elen;
+			break;
+		case WLAN_EID_PREP:
+			elems->prep = pos;
+			elems->prep_len = elen;
+			break;
+		case WLAN_EID_PERR:
+			elems->perr = pos;
+			elems->perr_len = elen;
+			break;
 		default:
 			break;
 		}
@@ -505,8 +493,7 @@ static void ieee80211_set_disassoc(struct net_device *dev,
 	ieee80211_set_associated(dev, ifsta, 0);
 }
 
-static void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
-			     int encrypt)
+void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb, int encrypt)
 {
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_tx_packet_data *pkt_data;
@@ -845,6 +832,52 @@ static void ieee80211_associate(struct net_device *dev,
 }
 
 
+static void ieee80211_mesh_housekeeping(struct net_device *dev,
+			   struct ieee80211_if_sta *ifsta)
+{
+	static unsigned long last_plink_gc, last_path_gc;
+	struct ieee80211_sub_if_data *sdata;
+	bool free_plinks;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (time_after(jiffies,
+			last_plink_gc + IEEE80211_MESH_PLINK_EXPIRATION)) {
+		last_plink_gc = jiffies;
+		mesh_plink_gc();
+	}
+
+	if (time_after(jiffies, last_path_gc + IEEE80211_MESH_PATH_GC)) {
+		last_path_gc = jiffies;
+		mesh_path_gc();
+	}
+
+	free_plinks = available_plinks(sdata);
+
+	/* In case plink_capacity > 0 and mesh_plinktbl_capacity == 0, the mesh
+	 * interface might be able to establish plinks with peers that are
+	 * already on the table but are not on ESTAB state. However, in general
+	 * the mesh interface is not accepting peer link requests from new
+	 * peers, and that must be reflected in the beacon
+	 */
+	if (free_plinks != sdata->u.sta.accepting_plinks) {
+		sdata->u.sta.accepting_plinks = free_plinks;
+		ieee80211_if_config(dev);
+	}
+	mod_timer(&ifsta->timer, jiffies + IEEE80211_MESH_EXPIRATION_INTERVAL);
+}
+
+
+void ieee80211_start_mesh(struct net_device *dev)
+{
+	struct ieee80211_if_sta *ifsta;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	ifsta = &sdata->u.sta;
+	ifsta->state = IEEE80211_MESH_UP;
+	ieee80211_sta_timer((unsigned long)sdata);
+}
+
+
 static void ieee80211_associated(struct net_device *dev,
 				 struct ieee80211_if_sta *ifsta)
 {
@@ -2087,6 +2120,12 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 
 	ieee802_11_parse_elems(mgmt->u.beacon.variable, len - baselen, &elems);
 
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT && elems.mesh_id
+			&& elems.mesh_config)
+		if (same_mesh(mgmt, &elems, dev))
+			update_mesh_neighbour(mgmt->sa, dev,
+					accepting_plinks(mgmt, &elems, dev));
+
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS && elems.supp_rates &&
 	    memcmp(mgmt->bssid, sdata->u.sta.bssid, ETH_ALEN) == 0 &&
 	    (sta = sta_info_get(local, mgmt->sa))) {
@@ -2144,7 +2183,10 @@ static void ieee80211_rx_bss_info(struct net_device *dev,
 		sta_info_put(sta);
 	}
 
-	if (!elems.ssid)
+	/* If len == 0, return, so we ignore mesh beacons till we know how to
+	 * treat them better
+	 */
+	if (!elems.ssid || !elems.ssid_len)
 		return;
 
 	if (elems.ds_params && elems.ds_params_len == 1)
@@ -2427,6 +2469,8 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
 	if (len < IEEE80211_MIN_ACTION_SIZE)
 		return;
 
@@ -2458,7 +2502,18 @@ static void ieee80211_rx_mgmt_action(struct net_device *dev,
 			break;
 		}
 		break;
+	case PLINK_CATEGORY:
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			mesh_rx_plink_frame(dev, mgmt, len);
+		break;
+
+	case MESH_PATH_SEL_CATEGORY:
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			mesh_rx_path_sel_frame(dev, mgmt, len);
+		break;
 	default:
+		printk(KERN_DEBUG "%s: received unknown action frame - "
+		       "category=%d\n", dev->name, mgmt->u.action.category);
 		break;
 	}
 }
@@ -2667,6 +2722,17 @@ void ieee80211_sta_timer(unsigned long data)
 	queue_work(local->hw.workqueue, &ifsta->work);
 }
 
+void ieee80211_mesh_path_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+	struct ieee80211_local *local = wdev_priv(&sdata->wdev);
+
+	queue_work(local->hw.workqueue, &ifsta->work);
+}
+
+
 
 void ieee80211_sta_work(struct work_struct *work)
 {
@@ -2684,7 +2750,8 @@ void ieee80211_sta_work(struct work_struct *work)
 		return;
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
-	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS) {
+	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT) {
 		printk(KERN_DEBUG "%s: ieee80211_sta_work: non-STA interface "
 		       "(type=%d)\n", dev->name, sdata->vif.type);
 		return;
@@ -2694,6 +2761,10 @@ void ieee80211_sta_work(struct work_struct *work)
 	while ((skb = skb_dequeue(&ifsta->skb_queue)))
 		ieee80211_sta_rx_queued_mgmt(dev, skb);
 
+	if (ifsta->preq_queue_len && time_after(jiffies, ifsta->last_preq +
+		msecs_to_jiffies(ifsta->mshcfg.dot11MeshHWMPpreqMinInterval)))
+		mesh_start_path_discovery(dev);
+
 	if (ifsta->state != IEEE80211_AUTHENTICATE &&
 	    ifsta->state != IEEE80211_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifsta->request)) {
@@ -2729,6 +2800,9 @@ void ieee80211_sta_work(struct work_struct *work)
 	case IEEE80211_IBSS_JOINED:
 		ieee80211_sta_merge_ibss(dev, ifsta);
 		break;
+	case IEEE80211_MESH_UP:
+		ieee80211_mesh_housekeeping(dev, ifsta);
+		break;
 	default:
 		printk(KERN_DEBUG "ieee80211_sta_work: Unknown state %d\n",
 		       ifsta->state);
@@ -2894,6 +2968,40 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
 	return -1;
 }
 
+int ieee80211_set_mesh_beacon_template(struct net_device *dev,
+				       struct ieee80211_if_conf *conf)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
+	struct ieee80211_mgmt *mgmt;
+	u8 *pos;
+
+	if (!skb)
+		return -1;
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	mgmt = (struct ieee80211_mgmt *)
+		skb_put(skb, 24 + sizeof(mgmt->u.beacon));
+	memset(mgmt, 0, 24 + sizeof(mgmt->u.beacon));
+	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
+					   IEEE80211_STYPE_BEACON);
+	memset(mgmt->da, 0xff, ETH_ALEN);
+	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
+	/* SSID is left zeroed, wildcard value */
+	mgmt->u.beacon.beacon_int =
+		cpu_to_le16(local->hw.conf.beacon_int);
+	mgmt->u.beacon.capab_info = 0x0; /* 0x0 for MPs */
+
+	pos = skb_put(skb, 2);
+	*pos++ = WLAN_EID_SSID;
+	*pos++ = 0x0;
+
+	mesh_add_mgmt_ies(skb, dev);
+
+	conf->beacon = skb;
+	return 0;
+}
+
+
 static int ieee80211_sta_join_ibss(struct net_device *dev,
 				   struct ieee80211_if_sta *ifsta,
 				   struct ieee80211_sta_bss *bss)
@@ -3380,6 +3488,9 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 			ieee80211_sta_timer((unsigned long)sdata);
 		}
 
+		if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			ieee80211_sta_timer((unsigned long)sdata);
+
 		netif_wake_queue(sdata->dev);
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f64804f..41a636e 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -26,6 +26,7 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#include "mesh.h"
 #include "wme.h"
 
 /* privid for wiphys to determine whether they belong to us or not */
@@ -146,6 +147,24 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
+int ieee80211_get_mesh_hdrlen(struct ieee80211s_hdr *meshhdr)
+{
+	int ae = meshhdr->flags & IEEE80211S_FLAGS_AE;
+	/* 7.1.3.5a.2 */
+	switch (ae) {
+	case 0:
+		return 5;
+	case 1:
+		return 11;
+	case 2:
+		return 17;
+	case 3:
+		return 23;
+	default:
+		return 5;
+	}
+}
+
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
@@ -381,6 +400,7 @@ void ieee80211_iterate_active_interfaces(
 		case IEEE80211_IF_TYPE_AP:
 		case IEEE80211_IF_TYPE_STA:
 		case IEEE80211_IF_TYPE_IBSS:
+		case IEEE80211_IF_TYPE_MESH_POINT:
 		case IEEE80211_IF_TYPE_WDS:
 			break;
 		}
@@ -394,3 +414,29 @@ void ieee80211_iterate_active_interfaces(
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+
+/**
+ * ieee80211_new_mesh_header - create a new mesh header
+ * @meshhdr:    uninitialized mesh header
+ * @sdata:	mesh interface to be used
+ *
+ * Return the header length.
+ */
+int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
+		struct ieee80211_sub_if_data *sdata)
+{
+	meshhdr->flags = 0;
+	meshhdr->ttl = sdata->u.sta.mshcfg.dot11MeshTTL;
+
+	meshhdr->seqnum[0] = sdata->u.sta.mesh_seqnum[0]++;
+	meshhdr->seqnum[1] = sdata->u.sta.mesh_seqnum[1];
+	meshhdr->seqnum[2] = sdata->u.sta.mesh_seqnum[2];
+
+	if (sdata->u.sta.mesh_seqnum[0] == 0) {
+		sdata->u.sta.mesh_seqnum[1]++;
+		if (sdata->u.sta.mesh_seqnum[1] == 0)
+			sdata->u.sta.mesh_seqnum[2]++;
+	}
+
+	return 5;
+}
-- 
1.5.2.5



