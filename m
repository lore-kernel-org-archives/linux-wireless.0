Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:44941 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYBVHS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 02:18:26 -0500
Received: by wa-out-1112.google.com with SMTP id v27so346322wah.23
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 23:18:26 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 21 Feb 2008 20:17:08 -0800
Subject: [PATCH 08/13 v2] o11s: other changes in mac80211 for mesh interface support
Message-ID: <47be7741.05d6720a.44c4.ffffd0c9@mx.google.com> (sfid-20080222_071830_924260_34482369)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Includes integration in struct sta_info of mesh peer link elements, previously
on their own mesh peer link table.

Signed-off-by: Luis Carlos Cobo <luisca@cozybit.com>
---
 net/mac80211/ieee80211_i.h      |  173 ++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_iface.c  |   63 ++++++++++++++-
 net/mac80211/ieee80211_ioctl.c  |    1 +
 net/mac80211/rc80211_pid_algo.c |   14 +++
 net/mac80211/sta_info.c         |   42 +++++++++-
 net/mac80211/sta_info.h         |   30 +++++++
 net/mac80211/util.c             |   52 ++++++++++++
 7 files changed, 369 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1b4a449..2192259 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -90,6 +90,12 @@ struct ieee80211_sta_bss {
 	size_t wmm_ie_len;
 	u8 *ht_ie;
 	size_t ht_ie_len;
+#ifdef CONFIG_MAC80211_MESH
+	u8 *mesh_id;
+	size_t mesh_id_len;
+#endif
+	/* mesh_cfg left out the ifdef to reduce clutter on bss handling */
+	u8 *mesh_cfg;
 #define IEEE80211_MAX_SUPP_RATES 32
 	u8 supp_rates[IEEE80211_MAX_SUPP_RATES];
 	size_t supp_rates_len;
@@ -227,6 +233,43 @@ struct ieee80211_if_vlan {
 	struct list_head list;
 };
 
+#ifdef CONFIG_MAC80211_MESH
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
+#endif
+
 /* flags used in struct ieee80211_if_sta.flags */
 #define IEEE80211_STA_SSID_SET		BIT(0)
 #define IEEE80211_STA_BSSID_SET		BIT(1)
@@ -245,7 +288,8 @@ struct ieee80211_if_sta {
 	enum {
 		IEEE80211_DISABLED, IEEE80211_AUTHENTICATE,
 		IEEE80211_ASSOCIATE, IEEE80211_ASSOCIATED,
-		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED
+		IEEE80211_IBSS_SEARCH, IEEE80211_IBSS_JOINED,
+		IEEE80211_MESH_UP
 	} state;
 	struct timer_list timer;
 	struct work_struct work;
@@ -254,6 +298,34 @@ struct ieee80211_if_sta {
 	size_t ssid_len;
 	u8 scan_ssid[IEEE80211_MAX_SSID_LEN];
 	size_t scan_ssid_len;
+#ifdef CONFIG_MAC80211_MESH
+	struct timer_list mesh_path_timer;
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
+	u8 mesh_seqnum[3];
+#endif
 	u16 aid;
 	u16 ap_capab, capab;
 	u8 *extra_ie; /* to be added to the end of AssocReq */
@@ -286,6 +358,7 @@ struct ieee80211_if_sta {
 	u32 supp_rates_bits[IEEE80211_NUM_BANDS];
 
 	int wmm_last_param_set;
+	int num_beacons; /* number of TXed beacon frames by this STA */
 };
 
 
@@ -365,6 +438,7 @@ struct ieee80211_sub_if_data {
 			struct dentry *auth_alg;
 			struct dentry *auth_transaction;
 			struct dentry *flags;
+			struct dentry *num_beacons_sta;
 		} sta;
 		struct {
 			struct dentry *channel_use;
@@ -390,6 +464,35 @@ struct ieee80211_sub_if_data {
 		} monitor;
 		struct dentry *default_key;
 	} debugfs;
+
+#ifdef CONFIG_MAC80211_MESH
+	struct dentry *mesh_stats_dir;
+	struct {
+		struct dentry *fwded_frames;
+		struct dentry *dropped_frames_ttl;
+		struct dentry *dropped_frames_no_route;
+		struct dentry *estab_plinks;
+	struct timer_list mesh_path_timer;
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
+#endif
+
 #endif
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
@@ -617,6 +720,57 @@ struct ieee80211_ra_tid {
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
@@ -720,6 +874,7 @@ int ieee80211_set_compression(struct ieee80211_local *local,
 			      struct net_device *dev, struct sta_info *sta);
 int ieee80211_set_freq(struct ieee80211_local *local, int freq);
 /* ieee80211_sta.c */
+#define IEEE80211_FC(type, stype) cpu_to_le16(type | stype)
 void ieee80211_sta_timer(unsigned long data);
 void ieee80211_sta_work(struct work_struct *work);
 void ieee80211_sta_scan_work(struct work_struct *work);
@@ -760,9 +915,23 @@ void ieee80211_sta_stop_rx_ba_session(struct net_device *dev, u8 *da,
 				u16 tid, u16 initiator, u16 reason);
 void sta_rx_agg_session_timer_expired(unsigned long data);
 void sta_addba_resp_timer_expired(unsigned long data);
+u64 ieee80211_sta_get_rates(struct ieee80211_local *local,
+			    struct ieee802_11_elems *elems,
+			    enum ieee80211_band band);
+void ieee80211_start_mesh(struct net_device *dev);
+void ieee80211_sta_tx(struct net_device *dev, struct sk_buff *skb,
+		int encrypt);
+void ieee802_11_parse_elems(u8 *start, size_t len,
+				   struct ieee802_11_elems *elems);
+#ifdef CONFIG_MAC80211_MESH
+void ieee80211_mesh_path_timer(unsigned long data);
+#endif
+
+
 /* ieee80211_iface.c */
 int ieee80211_if_add(struct net_device *dev, const char *name,
-		     struct net_device **new_dev, int type);
+		     struct net_device **new_dev, int type,
+		     struct vif_params *params);
 void ieee80211_if_set_type(struct net_device *dev, int type);
 void ieee80211_if_reinit(struct net_device *dev);
 void __ieee80211_if_del(struct ieee80211_local *local,
diff --git a/net/mac80211/ieee80211_iface.c b/net/mac80211/ieee80211_iface.c
index f66f1dd..a9cac0d 100644
--- a/net/mac80211/ieee80211_iface.c
+++ b/net/mac80211/ieee80211_iface.c
@@ -15,6 +15,9 @@
 #include "ieee80211_i.h"
 #include "sta_info.h"
 #include "debugfs_netdev.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata)
 {
@@ -39,7 +42,8 @@ static void ieee80211_if_sdata_deinit(struct ieee80211_sub_if_data *sdata)
 
 /* Must be called with rtnl lock held. */
 int ieee80211_if_add(struct net_device *dev, const char *name,
-		     struct net_device **new_dev, int type)
+		     struct net_device **new_dev, int type,
+		     struct vif_params *params)
 {
 	struct net_device *ndev;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
@@ -78,6 +82,15 @@ int ieee80211_if_add(struct net_device *dev, const char *name,
 	ieee80211_debugfs_add_netdev(sdata);
 	ieee80211_if_set_type(ndev, type);
 
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT &&
+	    params && params->mesh_id_len) {
+		sdata->u.sta.mesh_id_len = params->mesh_id_len;
+		memcpy(sdata->u.sta.mesh_id, params->mesh_id,
+		       params->mesh_id_len);
+	}
+#endif
+
 	/* we're under RTNL so all this is fine */
 	if (unlikely(local->reg_state == IEEE80211_DEV_UNREGISTERED)) {
 		__ieee80211_if_del(local, sdata);
@@ -134,6 +147,7 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 		sdata->bss = &sdata->u.ap;
 		INIT_LIST_HEAD(&sdata->u.ap.vlans);
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS: {
 		struct ieee80211_sub_if_data *msdata;
@@ -155,6 +169,48 @@ void ieee80211_if_set_type(struct net_device *dev, int type)
 
 		msdata = IEEE80211_DEV_TO_SUB_IF(sdata->local->mdev);
 		sdata->bss = &msdata->u.ap;
+
+#ifdef CONFIG_MAC80211_MESH
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
+			atomic_set(&ifsta->mpaths, 0);
+			mesh_rmc_init(dev);
+			ifsta->last_preq = jiffies;
+			/* Allocate all mesh structures when creating the first
+			 * mesh interface.
+			 */
+			if (!mesh_allocated)
+				ieee80211s_init();
+			mesh_ids_set_default(ifsta);
+			setup_timer(&ifsta->mesh_path_timer,
+				    ieee80211_mesh_path_timer,
+				    (unsigned long) sdata);
+			INIT_LIST_HEAD(&ifsta->preq_queue.list);
+			spin_lock_init(&ifsta->mesh_preq_queue_lock);
+		}
+#endif
 		break;
 	}
 	case IEEE80211_IF_TYPE_MNTR:
@@ -231,6 +287,11 @@ void ieee80211_if_reinit(struct net_device *dev)
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 		}
 		break;
+	case IEEE80211_IF_TYPE_MESH_POINT:
+#ifdef CONFIG_MAC80211_MESH
+		mesh_rmc_free(dev);
+#endif
+		/* fall through */
 	case IEEE80211_IF_TYPE_STA:
 	case IEEE80211_IF_TYPE_IBSS:
 		kfree(sdata->u.sta.extra_ie);
diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 54ad07a..1f5d236 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -519,6 +519,7 @@ static int ieee80211_ioctl_siwscan(struct net_device *dev,
 
 	if (sdata->vif.type != IEEE80211_IF_TYPE_STA &&
 	    sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
+	    sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT &&
 	    sdata->vif.type != IEEE80211_IF_TYPE_AP)
 		return -EOPNOTSUPP;
 
diff --git a/net/mac80211/rc80211_pid_algo.c b/net/mac80211/rc80211_pid_algo.c
index da8462b..5322486 100644
--- a/net/mac80211/rc80211_pid_algo.c
+++ b/net/mac80211/rc80211_pid_algo.c
@@ -15,6 +15,9 @@
 #include <linux/debugfs.h>
 #include <net/mac80211.h>
 #include "ieee80211_rate.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 
 #include "rc80211_pid.h"
 
@@ -148,6 +151,9 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 				    struct ieee80211_local *local,
 				    struct sta_info *sta)
 {
+#ifdef CONFIG_MAC80211_MESH
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+#endif
 	struct rc_pid_sta_info *spinfo = sta->rate_ctrl_priv;
 	struct rc_pid_rateinfo *rinfo = pinfo->rinfo;
 	struct ieee80211_supported_band *sband;
@@ -178,7 +184,14 @@ static void rate_control_pid_sample(struct rc_pid_info *pinfo,
 		pf = spinfo->last_pf;
 	else {
 		pf = spinfo->tx_num_failed * 100 / spinfo->tx_num_xmit;
+#ifdef CONFIG_MAC80211_MESH
+		if (pf == 100 &&
+		    sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+			mesh_plink_broken(sta);
+#endif
 		pf <<= RC_PID_ARITH_SHIFT;
+		sta->fail_avg = ((pf + (spinfo->last_pf << 3)) / 9)
+					>> RC_PID_ARITH_SHIFT;
 	}
 
 	spinfo->tx_num_xmit = 0;
@@ -360,6 +373,7 @@ static void rate_control_pid_rate_init(void *priv, void *priv_sta,
 
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 	sta->txrate_idx = rate_lowest_index(local, sband, sta);
+	sta->fail_avg = 0;
 }
 
 static void *rate_control_pid_alloc(struct ieee80211_local *local)
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6b53783..91dbb86 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -21,6 +21,9 @@
 #include "ieee80211_rate.h"
 #include "sta_info.h"
 #include "debugfs_sta.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 
 /* Caller must hold local->sta_lock */
 static void sta_info_hash_add(struct ieee80211_local *local,
@@ -74,6 +77,27 @@ struct sta_info *sta_info_get(struct ieee80211_local *local, u8 *addr)
 }
 EXPORT_SYMBOL(sta_info_get);
 
+struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
+				     struct net_device *dev)
+{
+	struct sta_info *sta;
+	int i = 0;
+
+	read_lock_bh(&local->sta_lock);
+	list_for_each_entry(sta, &local->sta_list, list) {
+		if (i < idx) {
+			++i;
+			continue;
+		} else if (!dev || dev == sta->dev) {
+			__sta_info_get(sta);
+			read_unlock_bh(&local->sta_lock);
+			return sta;
+		}
+	}
+	read_unlock_bh(&local->sta_lock);
+
+	return NULL;
+}
 
 static void sta_info_release(struct kref *kref)
 {
@@ -209,6 +233,11 @@ void sta_info_remove(struct sta_info *sta)
 			atomic_dec(&sdata->bss->num_sta_ps);
 	}
 	local->num_sta--;
+
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT)
+		mesh_accept_plinks_update(sdata->dev);
+#endif
 	sta_info_remove_aid_ptr(sta);
 
 }
@@ -217,6 +246,8 @@ void sta_info_free(struct sta_info *sta)
 {
 	struct sk_buff *skb;
 	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+
 	DECLARE_MAC_BUF(mac);
 
 	might_sleep();
@@ -225,6 +256,14 @@ void sta_info_free(struct sta_info *sta)
 	sta_info_remove(sta);
 	write_unlock_bh(&local->sta_lock);
 
+#ifdef CONFIG_MAC80211_MESH
+	if (sdata->vif.type == IEEE80211_IF_TYPE_MESH_POINT) {
+		spin_lock_bh(&sta->plink_lock);
+		mesh_plink_deactivate(sta);
+		spin_unlock_bh(&sta->plink_lock);
+	}
+#endif
+
 	while ((skb = skb_dequeue(&sta->ps_tx_buf)) != NULL) {
 		local->total_ps_buffered--;
 		dev_kfree_skb(skb);
@@ -242,9 +281,6 @@ void sta_info_free(struct sta_info *sta)
 	sta->key = NULL;
 
 	if (local->ops->sta_notify) {
-		struct ieee80211_sub_if_data *sdata;
-
-		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 
 		if (sdata->vif.type == IEEE80211_IF_TYPE_VLAN)
 			sdata = sdata->u.vlan.ap;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 19f3fb4..2e9ddf9 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -103,6 +103,18 @@ struct tid_ampdu_rx {
 	struct timer_list session_timer;
 };
 
+#ifdef CONFIG_MAC80211_MESH
+enum plink_state {
+	LISTEN,
+	OPN_SNT,
+	OPN_RCVD,
+	CNF_RCVD,
+	ESTAB,
+	HOLDING,
+	BLOCKED
+};
+#endif
+
 /**
  * struct sta_ampdu_mlme - STA aggregation information.
  *
@@ -143,6 +155,8 @@ struct sta_info {
 	unsigned long rx_bytes, tx_bytes;
 	unsigned long tx_retry_failed, tx_retry_count;
 	unsigned long tx_filtered_count;
+	/* moving percentage of failed MSDUs */
+	unsigned int fail_avg;
 
 	unsigned int wep_weak_iv_count; /* number of RX frames with weak IV */
 
@@ -193,6 +207,20 @@ struct sta_info {
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[STA_TID_NUM];	/* convert timer id to tid */
 	u8 tid_to_tx_q[STA_TID_NUM];	/* map tid to tx queue */
+#ifdef CONFIG_MAC80211_MESH
+	/* mesh peer link attributes */
+	__le16 llid;		/* Local link ID */
+	__le16 plid;		/* Peer link ID */
+	__le16 reason;		/* Buffer for cancel reason on HOLDING state */
+	enum plink_state plink_state;
+	u32 plink_timeout;
+	struct timer_list plink_timer;
+	u8 plink_retries;	/* Retries in establishment */
+	bool ignore_plink_timer;
+	spinlock_t plink_lock;	/* For peer_state reads / updates and other
+				   updates in the structure. Ensures robust
+				   transitions for the peerlink FSM */
+#endif
 
 #ifdef CONFIG_MAC80211_DEBUGFS
 	struct sta_info_debugfsdentries {
@@ -237,6 +265,8 @@ static inline void __sta_info_get(struct sta_info *sta)
 }
 
 struct sta_info * sta_info_get(struct ieee80211_local *local, u8 *addr);
+struct sta_info *sta_info_get_by_idx(struct ieee80211_local *local, int idx,
+				      struct net_device *dev);
 void sta_info_put(struct sta_info *sta);
 struct sta_info * sta_info_add(struct ieee80211_local *local,
 			       struct net_device *dev, u8 *addr, gfp_t gfp);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f64804f..03d1012 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -26,6 +26,9 @@
 
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
+#ifdef CONFIG_MAC80211_MESH
+#include "mesh.h"
+#endif
 #include "wme.h"
 
 /* privid for wiphys to determine whether they belong to us or not */
@@ -146,6 +149,26 @@ int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
+#ifdef CONFIG_MAC80211_MESH
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
+#endif
+
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
@@ -381,6 +404,7 @@ void ieee80211_iterate_active_interfaces(
 		case IEEE80211_IF_TYPE_AP:
 		case IEEE80211_IF_TYPE_STA:
 		case IEEE80211_IF_TYPE_IBSS:
+		case IEEE80211_IF_TYPE_MESH_POINT:
 		case IEEE80211_IF_TYPE_WDS:
 			break;
 		}
@@ -394,3 +418,31 @@ void ieee80211_iterate_active_interfaces(
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
+
+#ifdef CONFIG_MAC80211_MESH
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
+#endif
-- 
1.5.2.5



