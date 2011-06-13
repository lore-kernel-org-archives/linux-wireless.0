Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36471 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab1FMWiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:38:16 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 70891C7DBC
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:12 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id 1483A4030
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:38:09 +0300 (EEST)
Subject: [PATCH v2 24/27] mac80211: ieee80211_sub_if_data to
	mac80211_sub_if_data
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:38:08 +0300
Message-ID: <20110613223808.10517.9248.stgit@localhost6.localdomain6> (sfid-20110614_005723_141817_0101952D)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/agg-rx.c         |    4 +
 net/mac80211/agg-tx.c         |   18 +++---
 net/mac80211/cfg.c            |   90 ++++++++++++++--------------
 net/mac80211/chan.c           |   10 ++-
 net/mac80211/debugfs_key.c    |    6 +-
 net/mac80211/debugfs_key.h    |   12 ++--
 net/mac80211/debugfs_netdev.c |   50 ++++++++--------
 net/mac80211/debugfs_netdev.h |   12 ++--
 net/mac80211/driver-ops.h     |   24 ++++---
 net/mac80211/driver-trace.h   |   44 +++++++-------
 net/mac80211/event.c          |    2 -
 net/mac80211/ht.c             |   12 ++--
 net/mac80211/ibss.c           |   44 +++++++-------
 net/mac80211/iface.c          |   48 +++++++--------
 net/mac80211/key.c            |   26 ++++----
 net/mac80211/key.h            |   16 ++---
 net/mac80211/mac80211_i.h     |  132 +++++++++++++++++++++--------------------
 net/mac80211/main.c           |    6 +-
 net/mac80211/mesh.c           |   48 +++++++--------
 net/mac80211/mesh.h           |   74 +++++++++++------------
 net/mac80211/mesh_hwmp.c      |   26 ++++----
 net/mac80211/mesh_pathtbl.c   |   24 ++++---
 net/mac80211/mesh_plink.c     |   22 +++----
 net/mac80211/mlme.c           |  124 +++++++++++++++++++--------------------
 net/mac80211/offchannel.c     |   12 ++--
 net/mac80211/pm.c             |    4 +
 net/mac80211/rate.c           |    2 -
 net/mac80211/rate.h           |    2 -
 net/mac80211/rx.c             |   42 +++++++------
 net/mac80211/scan.c           |   18 +++---
 net/mac80211/spectmgmt.c      |    4 +
 net/mac80211/sta_info.c       |   30 +++++----
 net/mac80211/sta_info.h       |   18 +++---
 net/mac80211/status.c         |    4 +
 net/mac80211/tkip.c           |    4 +
 net/mac80211/tx.c             |   32 +++++-----
 net/mac80211/util.c           |   30 +++++----
 net/mac80211/wme.c            |    2 -
 net/mac80211/wme.h            |    2 -
 net/mac80211/work.c           |   24 ++++---
 40 files changed, 552 insertions(+), 552 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index bf234e5..8bce4b3 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -103,7 +103,7 @@ void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 void ieee80211_stop_rx_ba_session(struct ieee80211_vif *vif, u16 ba_rx_bitmap,
 				  const u8 *addr)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct sta_info *sta = sta_info_get(sdata, addr);
 	int i;
 
@@ -149,7 +149,7 @@ static void sta_rx_agg_reorder_timer_expired(unsigned long data)
 	rcu_read_unlock();
 }
 
-static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
+static void ieee80211_send_addba_resp(struct mac80211_sub_if_data *sdata, u8 *da, u16 tid,
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
 {
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index d45743b..0d772a6 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -56,7 +56,7 @@
  * and the driver must later call ieee80211_stop_tx_ba_cb_irqsafe().
  */
 
-static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_send_addba_request(struct mac80211_sub_if_data *sdata,
 					 const u8 *da, u16 tid,
 					 u8 dialog_token, u16 start_seq_num,
 					 u16 agg_size, u16 timeout)
@@ -106,7 +106,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
+void ieee80211_send_bar(struct mac80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
 {
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -288,7 +288,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
 	struct mac80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	u16 start_seq_num;
 	int ret;
 
@@ -353,7 +353,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 				  u16 timeout)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct mac80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
@@ -520,7 +520,7 @@ static void ieee80211_agg_tx_operational(struct mac80211_local *local,
 
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct tid_ampdu_tx *tid_tx;
@@ -569,7 +569,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				      const u8 *ra, u16 tid)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_ra_tid *ra_tid;
 	struct sk_buff *skb = dev_alloc_skb(0);
@@ -610,7 +610,7 @@ int __ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct mac80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
@@ -648,7 +648,7 @@ EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct tid_ampdu_tx *tid_tx;
@@ -722,7 +722,7 @@ void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				     const u8 *ra, u16 tid)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_ra_tid *ra_tid;
 	struct sk_buff *skb = dev_alloc_skb(0);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 40ba6be..4d18db7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -26,7 +26,7 @@ static struct net_device *ieee80211_add_iface(struct wiphy *wiphy, char *name,
 {
 	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	int err;
 
 	err = ieee80211_if_add(local, name, &dev, type, params);
@@ -53,7 +53,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 				  enum nl80211_iftype type, u32 *flags,
 				  struct vif_params *params)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int ret;
 
 	ret = ieee80211_if_change_type(sdata, type);
@@ -105,7 +105,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr,
 			     struct key_params *params)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta = NULL;
 	struct ieee80211_key *key;
 	int err;
@@ -160,7 +160,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_key *key = NULL;
@@ -204,7 +204,7 @@ static int ieee80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 			     void (*callback)(void *cookie,
 					      struct key_params *params))
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta = NULL;
 	u8 seq[6] = {0};
 	struct key_params params;
@@ -293,7 +293,7 @@ static int ieee80211_config_default_key(struct wiphy *wiphy,
 					u8 key_idx, bool uni,
 					bool multi)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_set_default_key(sdata, key_idx, uni, multi);
 
@@ -304,7 +304,7 @@ static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
 					     struct net_device *dev,
 					     u8 key_idx)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_set_default_mgmt_key(sdata, key_idx);
 
@@ -324,7 +324,7 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct timespec uptime;
 
 	sinfo->generation = sdata->local->sta_generation;
@@ -406,7 +406,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *mac, struct station_info *sinfo)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
@@ -435,7 +435,7 @@ static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_info *sinfo)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
@@ -455,7 +455,7 @@ static int ieee80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 /*
  * This handles both adding a beacon and setting new beacon info
  */
-static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
+static int ieee80211_config_beacon(struct mac80211_sub_if_data *sdata,
 				   struct beacon_parameters *params)
 {
 	struct beacon_data *new, *old;
@@ -553,7 +553,7 @@ static int ieee80211_config_beacon(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -568,7 +568,7 @@ static int ieee80211_add_beacon(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 				struct beacon_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -582,7 +582,7 @@ static int ieee80211_set_beacon(struct wiphy *wiphy, struct net_device *dev,
 
 static int ieee80211_del_beacon(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct beacon_data *old;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -651,7 +651,7 @@ static void sta_apply_parameters(struct mac80211_local *local,
 	u32 rates;
 	int i, j;
 	struct ieee80211_supported_band *sband;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	u32 mask, set;
 
 	sband = local->hw.wiphy->bands[local->oper_channel->band];
@@ -757,7 +757,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	int err;
 	int layer2_update;
 
@@ -807,7 +807,7 @@ static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac)
 {
 	struct mac80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
@@ -823,10 +823,10 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 				    u8 *mac,
 				    struct station_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
-	struct ieee80211_sub_if_data *vlansdata;
+	struct mac80211_sub_if_data *vlansdata;
 
 	rcu_read_lock();
 
@@ -873,7 +873,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	int err;
@@ -907,7 +907,7 @@ static int ieee80211_add_mpath(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_del_mpath(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *dst)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (dst)
 		return mesh_path_del(dst, sdata);
@@ -920,7 +920,7 @@ static int ieee80211_change_mpath(struct wiphy *wiphy,
 				    struct net_device *dev,
 				    u8 *dst, u8 *next_hop)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 
@@ -993,7 +993,7 @@ static int ieee80211_get_mpath(struct wiphy *wiphy, struct net_device *dev,
 			       u8 *dst, u8 *next_hop, struct mpath_info *pinfo)
 
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1014,7 +1014,7 @@ static int ieee80211_dump_mpath(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, u8 *dst, u8 *next_hop,
 				 struct mpath_info *pinfo)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mesh_path *mpath;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1035,7 +1035,7 @@ static int ieee80211_get_mesh_config(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct mesh_config *conf)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	memcpy(conf, &(sdata->u.mesh.mshcfg), sizeof(struct mesh_config));
@@ -1086,7 +1086,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 					const struct mesh_config *nconf)
 {
 	struct mesh_config *conf;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_if_mesh *ifmsh;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1138,7 +1138,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 			       const struct mesh_config *conf,
 			       const struct mesh_setup *setup)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	int err;
 
@@ -1153,7 +1153,7 @@ static int ieee80211_join_mesh(struct wiphy *wiphy, struct net_device *dev,
 
 static int ieee80211_leave_mesh(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_stop_mesh(sdata);
 
@@ -1165,7 +1165,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct bss_parameters *params)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	u32 changed = 0;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -1265,7 +1265,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 				 enum nl80211_channel_type channel_type)
 {
 	struct mac80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = NULL;
+	struct mac80211_sub_if_data *sdata = NULL;
 	struct ieee80211_channel *old_oper;
 	enum nl80211_channel_type old_oper_type;
 	enum nl80211_channel_type old_vif_oper_type= NL80211_CHAN_NO_HT;
@@ -1328,7 +1328,7 @@ static int ieee80211_scan(struct wiphy *wiphy,
 			  struct net_device *dev,
 			  struct cfg80211_scan_request *req)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (ieee80211_vif_type_p2p(&sdata->vif)) {
 	case NL80211_IFTYPE_STATION:
@@ -1360,7 +1360,7 @@ ieee80211_sched_scan_start(struct wiphy *wiphy,
 			   struct net_device *dev,
 			   struct cfg80211_sched_scan_request *req)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (!sdata->local->ops->sched_scan_start)
 		return -EOPNOTSUPP;
@@ -1371,7 +1371,7 @@ ieee80211_sched_scan_start(struct wiphy *wiphy,
 static int
 ieee80211_sched_scan_stop(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (!sdata->local->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
@@ -1389,7 +1389,7 @@ static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_assoc_request *req)
 {
 	struct mac80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (ieee80211_get_channel_mode(local, sdata)) {
 	case CHAN_MODE_HOPPING:
@@ -1425,7 +1425,7 @@ static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_ibss_params *params)
 {
 	struct mac80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (ieee80211_get_channel_mode(local, sdata)) {
 	case CHAN_MODE_HOPPING:
@@ -1445,7 +1445,7 @@ static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 
 static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	return ieee80211_ibss_leave(sdata);
 }
@@ -1530,7 +1530,7 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
 static int ieee80211_set_wds_peer(struct wiphy *wiphy, struct net_device *dev,
 				  const u8 *addr)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	memcpy(&sdata->u.wds.remote_addr, addr, ETH_ALEN);
 
@@ -1569,7 +1569,7 @@ static int ieee80211_testmode_dump(struct wiphy *wiphy,
 }
 #endif
 
-int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
+int __ieee80211_request_smps(struct mac80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode)
 {
 	const u8 *ap;
@@ -1618,7 +1618,7 @@ int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 				    bool enabled, int timeout)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
@@ -1651,7 +1651,7 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 s32 rssi_thold, u32 rssi_hyst)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_vif *vif = &sdata->vif;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
@@ -1681,7 +1681,7 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      const u8 *addr,
 				      const struct cfg80211_bitrate_mask *mask)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int i, ret;
 
@@ -1735,7 +1735,7 @@ static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 				       unsigned int duration,
 				       u64 *cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 
 	if (local->ops->remain_on_channel) {
@@ -1781,7 +1781,7 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      u64 cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 
 	if (local->ops->cancel_remain_on_channel) {
@@ -1825,7 +1825,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			     bool channel_type_valid, unsigned int wait,
 			     const u8 *buf, size_t len, u64 *cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
@@ -1994,7 +1994,7 @@ static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 					 struct net_device *dev,
 					 u64 cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	struct mac80211_work *wk;
 	int ret = -ENOENT;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index d2fe20d..74b2760 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -7,9 +7,9 @@
 
 static enum ieee80211_chan_mode
 __ieee80211_get_channel_mode(struct mac80211_local *local,
-			     struct ieee80211_sub_if_data *ignore)
+			     struct mac80211_sub_if_data *ignore)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	lockdep_assert_held(&local->iflist_mtx);
 
@@ -46,7 +46,7 @@ __ieee80211_get_channel_mode(struct mac80211_local *local,
 
 enum ieee80211_chan_mode
 ieee80211_get_channel_mode(struct mac80211_local *local,
-			   struct ieee80211_sub_if_data *ignore)
+			   struct mac80211_sub_if_data *ignore)
 {
 	enum ieee80211_chan_mode mode;
 
@@ -58,10 +58,10 @@ ieee80211_get_channel_mode(struct mac80211_local *local,
 }
 
 bool ieee80211_set_channel_type(struct mac80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
+				struct mac80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype)
 {
-	struct ieee80211_sub_if_data *tmp;
+	struct mac80211_sub_if_data *tmp;
 	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
 	bool result;
 
diff --git a/net/mac80211/debugfs_key.c b/net/mac80211/debugfs_key.c
index 958791f..acfe8f2 100644
--- a/net/mac80211/debugfs_key.c
+++ b/net/mac80211/debugfs_key.c
@@ -271,7 +271,7 @@ void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
 	key->debugfs.dir = NULL;
 }
 
-void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
+void ieee80211_debugfs_key_update_default(struct mac80211_sub_if_data *sdata)
 {
 	char buf[50];
 	struct ieee80211_key *key;
@@ -306,7 +306,7 @@ void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
+void ieee80211_debugfs_key_add_mgmt_default(struct mac80211_sub_if_data *sdata)
 {
 	char buf[50];
 	struct ieee80211_key *key;
@@ -325,7 +325,7 @@ void ieee80211_debugfs_key_add_mgmt_default(struct ieee80211_sub_if_data *sdata)
 		ieee80211_debugfs_key_remove_mgmt_default(sdata);
 }
 
-void ieee80211_debugfs_key_remove_mgmt_default(struct ieee80211_sub_if_data *sdata)
+void ieee80211_debugfs_key_remove_mgmt_default(struct mac80211_sub_if_data *sdata)
 {
 	if (!sdata)
 		return;
diff --git a/net/mac80211/debugfs_key.h b/net/mac80211/debugfs_key.h
index 32adc77..2c543cc 100644
--- a/net/mac80211/debugfs_key.h
+++ b/net/mac80211/debugfs_key.h
@@ -4,11 +4,11 @@
 #ifdef CONFIG_MAC80211_DEBUGFS
 void ieee80211_debugfs_key_add(struct ieee80211_key *key);
 void ieee80211_debugfs_key_remove(struct ieee80211_key *key);
-void ieee80211_debugfs_key_update_default(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_key_update_default(struct mac80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_add_mgmt_default(
-	struct ieee80211_sub_if_data *sdata);
+	struct mac80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_remove_mgmt_default(
-	struct ieee80211_sub_if_data *sdata);
+	struct mac80211_sub_if_data *sdata);
 void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 				   struct sta_info *sta);
 #else
@@ -17,13 +17,13 @@ static inline void ieee80211_debugfs_key_add(struct ieee80211_key *key)
 static inline void ieee80211_debugfs_key_remove(struct ieee80211_key *key)
 {}
 static inline void ieee80211_debugfs_key_update_default(
-	struct ieee80211_sub_if_data *sdata)
+	struct mac80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_debugfs_key_add_mgmt_default(
-	struct ieee80211_sub_if_data *sdata)
+	struct mac80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_debugfs_key_remove_mgmt_default(
-	struct ieee80211_sub_if_data *sdata)
+	struct mac80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_debugfs_key_sta_del(struct ieee80211_key *key,
 						 struct sta_info *sta)
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index d2b6a87..bbd9e7c 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -23,10 +23,10 @@
 #include "debugfs_netdev.h"
 
 static ssize_t ieee80211_if_read(
-	struct ieee80211_sub_if_data *sdata,
+	struct mac80211_sub_if_data *sdata,
 	char __user *userbuf,
 	size_t count, loff_t *ppos,
-	ssize_t (*format)(const struct ieee80211_sub_if_data *, char *, int))
+	ssize_t (*format)(const struct mac80211_sub_if_data *, char *, int))
 {
 	char buf[70];
 	ssize_t ret = -EINVAL;
@@ -43,10 +43,10 @@ static ssize_t ieee80211_if_read(
 }
 
 static ssize_t ieee80211_if_write(
-	struct ieee80211_sub_if_data *sdata,
+	struct mac80211_sub_if_data *sdata,
 	const char __user *userbuf,
 	size_t count, loff_t *ppos,
-	ssize_t (*write)(struct ieee80211_sub_if_data *, const char *, int))
+	ssize_t (*write)(struct mac80211_sub_if_data *, const char *, int))
 {
 	u8 *buf;
 	ssize_t ret;
@@ -72,7 +72,7 @@ freebuf:
 
 #define IEEE80211_IF_FMT(name, field, format_string)			\
 static ssize_t ieee80211_if_fmt_##name(					\
-	const struct ieee80211_sub_if_data *sdata, char *buf,		\
+	const struct mac80211_sub_if_data *sdata, char *buf,		\
 	int buflen)							\
 {									\
 	return scnprintf(buf, buflen, format_string, sdata->field);	\
@@ -88,7 +88,7 @@ static ssize_t ieee80211_if_fmt_##name(					\
 
 #define IEEE80211_IF_FMT_ATOMIC(name, field)				\
 static ssize_t ieee80211_if_fmt_##name(					\
-	const struct ieee80211_sub_if_data *sdata,			\
+	const struct mac80211_sub_if_data *sdata,			\
 	char *buf, int buflen)						\
 {									\
 	return scnprintf(buf, buflen, "%d\n", atomic_read(&sdata->field));\
@@ -96,7 +96,7 @@ static ssize_t ieee80211_if_fmt_##name(					\
 
 #define IEEE80211_IF_FMT_MAC(name, field)				\
 static ssize_t ieee80211_if_fmt_##name(					\
-	const struct ieee80211_sub_if_data *sdata, char *buf,		\
+	const struct mac80211_sub_if_data *sdata, char *buf,		\
 	int buflen)							\
 {									\
 	return scnprintf(buf, buflen, "%pM\n", sdata->field);		\
@@ -104,7 +104,7 @@ static ssize_t ieee80211_if_fmt_##name(					\
 
 #define IEEE80211_IF_FMT_DEC_DIV_16(name, field)			\
 static ssize_t ieee80211_if_fmt_##name(					\
-	const struct ieee80211_sub_if_data *sdata,			\
+	const struct mac80211_sub_if_data *sdata,			\
 	char *buf, int buflen)						\
 {									\
 	return scnprintf(buf, buflen, "%d\n", sdata->field / 16);	\
@@ -157,7 +157,7 @@ IEEE80211_IF_FILE(aid, u.mgd.aid, DEC);
 IEEE80211_IF_FILE(last_beacon, u.mgd.last_beacon_signal, DEC);
 IEEE80211_IF_FILE(ave_beacon, u.mgd.ave_beacon_signal, DEC_DIV_16);
 
-static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
+static int ieee80211_set_smps(struct mac80211_sub_if_data *sdata,
 			      enum ieee80211_smps_mode smps_mode)
 {
 	struct mac80211_local *local = sdata->local;
@@ -191,7 +191,7 @@ static const char *smps_modes[IEEE80211_SMPS_NUM_MODES] = {
 	[IEEE80211_SMPS_DYNAMIC] = "dynamic",
 };
 
-static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
+static ssize_t ieee80211_if_fmt_smps(const struct mac80211_sub_if_data *sdata,
 				     char *buf, int buflen)
 {
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
@@ -202,7 +202,7 @@ static ssize_t ieee80211_if_fmt_smps(const struct ieee80211_sub_if_data *sdata,
 			smps_modes[sdata->u.mgd.ap_smps]);
 }
 
-static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
+static ssize_t ieee80211_if_parse_smps(struct mac80211_sub_if_data *sdata,
 				       const char *buf, int buflen)
 {
 	enum ieee80211_smps_mode mode;
@@ -222,7 +222,7 @@ static ssize_t ieee80211_if_parse_smps(struct ieee80211_sub_if_data *sdata,
 __IEEE80211_IF_FILE_W(smps);
 
 static ssize_t ieee80211_if_fmt_tkip_mic_test(
-	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+	const struct mac80211_sub_if_data *sdata, char *buf, int buflen)
 {
 	return -EOPNOTSUPP;
 }
@@ -249,7 +249,7 @@ static int hwaddr_aton(const char *txt, u8 *addr)
 }
 
 static ssize_t ieee80211_if_parse_tkip_mic_test(
-	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
+	struct mac80211_sub_if_data *sdata, const char *buf, int buflen)
 {
 	struct mac80211_local *local = sdata->local;
 	u8 addr[ETH_ALEN];
@@ -324,7 +324,7 @@ IEEE80211_IF_FILE(num_sta_ps, u.ap.num_sta_ps, ATOMIC);
 IEEE80211_IF_FILE(dtim_count, u.ap.dtim_count, DEC);
 
 static ssize_t ieee80211_if_fmt_num_buffered_multicast(
-	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
+	const struct mac80211_sub_if_data *sdata, char *buf, int buflen)
 {
 	return scnprintf(buf, buflen, "%u\n",
 			 skb_queue_len(&sdata->u.ap.ps_bc_buf));
@@ -383,7 +383,7 @@ IEEE80211_IF_FILE(dot11MeshHWMPRootMode,
 	debugfs_create_file(#name, mode, sdata->debugfs.dir, \
 			    sdata, &name##_ops);
 
-static void add_sta_files(struct ieee80211_sub_if_data *sdata)
+static void add_sta_files(struct mac80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
@@ -400,7 +400,7 @@ static void add_sta_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 }
 
-static void add_ap_files(struct ieee80211_sub_if_data *sdata)
+static void add_ap_files(struct mac80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
@@ -415,7 +415,7 @@ static void add_ap_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
 }
 
-static void add_wds_files(struct ieee80211_sub_if_data *sdata)
+static void add_wds_files(struct mac80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
@@ -427,7 +427,7 @@ static void add_wds_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(peer);
 }
 
-static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
+static void add_vlan_files(struct mac80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(drop_unencrypted);
 	DEBUGFS_ADD(flags);
@@ -437,7 +437,7 @@ static void add_vlan_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(rc_rateidx_mask_5ghz);
 }
 
-static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
+static void add_monitor_files(struct mac80211_sub_if_data *sdata)
 {
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
@@ -446,7 +446,7 @@ static void add_monitor_files(struct ieee80211_sub_if_data *sdata)
 
 #ifdef CONFIG_MAC80211_MESH
 
-static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
+static void add_mesh_stats(struct mac80211_sub_if_data *sdata)
 {
 	struct dentry *dir = debugfs_create_dir("mesh_stats",
 						sdata->debugfs.dir);
@@ -463,7 +463,7 @@ static void add_mesh_stats(struct ieee80211_sub_if_data *sdata)
 #undef MESHSTATS_ADD
 }
 
-static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
+static void add_mesh_config(struct mac80211_sub_if_data *sdata)
 {
 	struct dentry *dir = debugfs_create_dir("mesh_config",
 						sdata->debugfs.dir);
@@ -490,7 +490,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 }
 #endif
 
-static void add_files(struct ieee80211_sub_if_data *sdata)
+static void add_files(struct mac80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfs.dir)
 		return;
@@ -525,7 +525,7 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
+void ieee80211_debugfs_add_netdev(struct mac80211_sub_if_data *sdata)
 {
 	char buf[10+IFNAMSIZ];
 
@@ -538,7 +538,7 @@ void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata)
 	add_files(sdata);
 }
 
-void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
+void ieee80211_debugfs_remove_netdev(struct mac80211_sub_if_data *sdata)
 {
 	if (!sdata->debugfs.dir)
 		return;
@@ -547,7 +547,7 @@ void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata)
 	sdata->debugfs.dir = NULL;
 }
 
-void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata)
+void ieee80211_debugfs_rename_netdev(struct mac80211_sub_if_data *sdata)
 {
 	struct dentry *dir;
 	char buf[10 + IFNAMSIZ];
diff --git a/net/mac80211/debugfs_netdev.h b/net/mac80211/debugfs_netdev.h
index 79025e7..9add699 100644
--- a/net/mac80211/debugfs_netdev.h
+++ b/net/mac80211/debugfs_netdev.h
@@ -4,18 +4,18 @@
 #define __IEEE80211_DEBUGFS_NETDEV_H
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-void ieee80211_debugfs_add_netdev(struct ieee80211_sub_if_data *sdata);
-void ieee80211_debugfs_remove_netdev(struct ieee80211_sub_if_data *sdata);
-void ieee80211_debugfs_rename_netdev(struct ieee80211_sub_if_data *sdata);
+void ieee80211_debugfs_add_netdev(struct mac80211_sub_if_data *sdata);
+void ieee80211_debugfs_remove_netdev(struct mac80211_sub_if_data *sdata);
+void ieee80211_debugfs_rename_netdev(struct mac80211_sub_if_data *sdata);
 #else
 static inline void ieee80211_debugfs_add_netdev(
-	struct ieee80211_sub_if_data *sdata)
+	struct mac80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_debugfs_remove_netdev(
-	struct ieee80211_sub_if_data *sdata)
+	struct mac80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_debugfs_rename_netdev(
-	struct ieee80211_sub_if_data *sdata)
+	struct mac80211_sub_if_data *sdata)
 {}
 #endif
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f15f2ca..5242150 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -82,7 +82,7 @@ static inline int drv_add_interface(struct mac80211_local *local,
 }
 
 static inline int drv_change_interface(struct mac80211_local *local,
-				       struct ieee80211_sub_if_data *sdata,
+				       struct mac80211_sub_if_data *sdata,
 				       enum nl80211_iftype type, bool p2p)
 {
 	int ret;
@@ -118,7 +118,7 @@ static inline int drv_config(struct mac80211_local *local, u32 changed)
 }
 
 static inline void drv_bss_info_changed(struct mac80211_local *local,
-					struct ieee80211_sub_if_data *sdata,
+					struct mac80211_sub_if_data *sdata,
 					struct ieee80211_bss_conf *info,
 					u32 changed)
 {
@@ -172,7 +172,7 @@ static inline int drv_set_tim(struct mac80211_local *local,
 
 static inline int drv_set_key(struct mac80211_local *local,
 			      enum set_key_cmd cmd,
-			      struct ieee80211_sub_if_data *sdata,
+			      struct mac80211_sub_if_data *sdata,
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_key_conf *key)
 {
@@ -187,7 +187,7 @@ static inline int drv_set_key(struct mac80211_local *local,
 }
 
 static inline void drv_update_tkip_key(struct mac80211_local *local,
-				       struct ieee80211_sub_if_data *sdata,
+				       struct mac80211_sub_if_data *sdata,
 				       struct ieee80211_key_conf *conf,
 				       struct sta_info *sta, u32 iv32,
 				       u16 *phase1key)
@@ -205,7 +205,7 @@ static inline void drv_update_tkip_key(struct mac80211_local *local,
 }
 
 static inline int drv_hw_scan(struct mac80211_local *local,
-			      struct ieee80211_sub_if_data *sdata,
+			      struct mac80211_sub_if_data *sdata,
 			      struct cfg80211_scan_request *req)
 {
 	int ret;
@@ -220,7 +220,7 @@ static inline int drv_hw_scan(struct mac80211_local *local,
 
 static inline int
 drv_sched_scan_start(struct mac80211_local *local,
-		     struct ieee80211_sub_if_data *sdata,
+		     struct mac80211_sub_if_data *sdata,
 		     struct cfg80211_sched_scan_request *req,
 		     struct ieee80211_sched_scan_ies *ies)
 {
@@ -236,7 +236,7 @@ drv_sched_scan_start(struct mac80211_local *local,
 }
 
 static inline void drv_sched_scan_stop(struct mac80211_local *local,
-				       struct ieee80211_sub_if_data *sdata)
+				       struct mac80211_sub_if_data *sdata)
 {
 	might_sleep();
 
@@ -332,7 +332,7 @@ static inline int drv_set_coverage_class(struct mac80211_local *local,
 }
 
 static inline void drv_sta_notify(struct mac80211_local *local,
-				  struct ieee80211_sub_if_data *sdata,
+				  struct mac80211_sub_if_data *sdata,
 				  enum sta_notify_cmd cmd,
 				  struct ieee80211_sta *sta)
 {
@@ -343,7 +343,7 @@ static inline void drv_sta_notify(struct mac80211_local *local,
 }
 
 static inline int drv_sta_add(struct mac80211_local *local,
-			      struct ieee80211_sub_if_data *sdata,
+			      struct mac80211_sub_if_data *sdata,
 			      struct ieee80211_sta *sta)
 {
 	int ret = 0;
@@ -360,7 +360,7 @@ static inline int drv_sta_add(struct mac80211_local *local,
 }
 
 static inline void drv_sta_remove(struct mac80211_local *local,
-				  struct ieee80211_sub_if_data *sdata,
+				  struct mac80211_sub_if_data *sdata,
 				  struct ieee80211_sta *sta)
 {
 	might_sleep();
@@ -433,7 +433,7 @@ static inline int drv_tx_last_beacon(struct mac80211_local *local)
 }
 
 static inline int drv_ampdu_action(struct mac80211_local *local,
-				   struct ieee80211_sub_if_data *sdata,
+				   struct mac80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
 				   u16 *ssn, u8 buf_size)
@@ -621,7 +621,7 @@ static inline bool drv_tx_frames_pending(struct mac80211_local *local)
 }
 
 static inline int drv_set_bitrate_mask(struct mac80211_local *local,
-				       struct ieee80211_sub_if_data *sdata,
+				       struct mac80211_sub_if_data *sdata,
 				       const struct cfg80211_bitrate_mask *mask)
 {
 	int ret = -EOPNOTSUPP;
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index ffa02ac..d28aa5e 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -57,7 +57,7 @@ DECLARE_EVENT_CLASS(local_only_evt,
 
 DECLARE_EVENT_CLASS(local_sdata_addr_evt,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata),
 
 	TP_STRUCT__entry(
@@ -100,7 +100,7 @@ DECLARE_EVENT_CLASS(local_u32_evt,
 
 DECLARE_EVENT_CLASS(local_sdata_evt,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata),
 
 	TP_STRUCT__entry(
@@ -189,13 +189,13 @@ DEFINE_EVENT(local_only_evt, drv_stop,
 
 DEFINE_EVENT(local_sdata_addr_evt, drv_add_interface,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_change_interface,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 enum nl80211_iftype type, bool p2p),
 
 	TP_ARGS(local, sdata, type, p2p),
@@ -223,7 +223,7 @@ TRACE_EVENT(drv_change_interface,
 
 DEFINE_EVENT(local_sdata_addr_evt, drv_remove_interface,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
@@ -271,7 +271,7 @@ TRACE_EVENT(drv_config,
 
 TRACE_EVENT(drv_bss_info_changed,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 struct ieee80211_bss_conf *info,
 		 u32 changed),
 
@@ -394,7 +394,7 @@ TRACE_EVENT(drv_set_tim,
 
 TRACE_EVENT(drv_set_key,
 	TP_PROTO(struct mac80211_local *local,
-		 enum set_key_cmd cmd, struct ieee80211_sub_if_data *sdata,
+		 enum set_key_cmd cmd, struct mac80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta,
 		 struct ieee80211_key_conf *key),
 
@@ -428,7 +428,7 @@ TRACE_EVENT(drv_set_key,
 
 TRACE_EVENT(drv_update_tkip_key,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 struct ieee80211_key_conf *conf,
 		 struct ieee80211_sta *sta, u32 iv32),
 
@@ -456,19 +456,19 @@ TRACE_EVENT(drv_update_tkip_key,
 
 DEFINE_EVENT(local_sdata_evt, drv_hw_scan,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_start,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_stop,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata),
+		 struct mac80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
@@ -571,7 +571,7 @@ TRACE_EVENT(drv_set_coverage_class,
 
 TRACE_EVENT(drv_sta_notify,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 enum sta_notify_cmd cmd,
 		 struct ieee80211_sta *sta),
 
@@ -599,7 +599,7 @@ TRACE_EVENT(drv_sta_notify,
 
 TRACE_EVENT(drv_sta_add,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
 
 	TP_ARGS(local, sdata, sta),
@@ -624,7 +624,7 @@ TRACE_EVENT(drv_sta_add,
 
 TRACE_EVENT(drv_sta_remove,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
 
 	TP_ARGS(local, sdata, sta),
@@ -715,7 +715,7 @@ DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
 
 TRACE_EVENT(drv_ampdu_action,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
 		 u16 *ssn, u8 buf_size),
@@ -993,7 +993,7 @@ DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
 
 TRACE_EVENT(drv_set_bitrate_mask,
 	TP_PROTO(struct mac80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
+		 struct mac80211_sub_if_data *sdata,
 		 const struct cfg80211_bitrate_mask *mask),
 
 	TP_ARGS(local, sdata, mask),
@@ -1044,7 +1044,7 @@ TRACE_EVENT(api_start_tx_ba_session,
 );
 
 TRACE_EVENT(api_start_tx_ba_cb,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *ra, u16 tid),
+	TP_PROTO(struct mac80211_sub_if_data *sdata, const u8 *ra, u16 tid),
 
 	TP_ARGS(sdata, ra, tid),
 
@@ -1088,7 +1088,7 @@ TRACE_EVENT(api_stop_tx_ba_session,
 );
 
 TRACE_EVENT(api_stop_tx_ba_cb,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata, const u8 *ra, u16 tid),
+	TP_PROTO(struct mac80211_sub_if_data *sdata, const u8 *ra, u16 tid),
 
 	TP_ARGS(sdata, ra, tid),
 
@@ -1116,7 +1116,7 @@ DEFINE_EVENT(local_only_evt, api_restart_hw,
 );
 
 TRACE_EVENT(api_beacon_loss,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata),
+	TP_PROTO(struct mac80211_sub_if_data *sdata),
 
 	TP_ARGS(sdata),
 
@@ -1135,7 +1135,7 @@ TRACE_EVENT(api_beacon_loss,
 );
 
 TRACE_EVENT(api_connection_loss,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata),
+	TP_PROTO(struct mac80211_sub_if_data *sdata),
 
 	TP_ARGS(sdata),
 
@@ -1154,7 +1154,7 @@ TRACE_EVENT(api_connection_loss,
 );
 
 TRACE_EVENT(api_cqm_rssi_notify,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata,
+	TP_PROTO(struct mac80211_sub_if_data *sdata,
 		 enum nl80211_cqm_rssi_threshold_event rssi_event),
 
 	TP_ARGS(sdata, rssi_event),
@@ -1257,7 +1257,7 @@ TRACE_EVENT(api_sta_block_awake,
 );
 
 TRACE_EVENT(api_chswitch_done,
-	TP_PROTO(struct ieee80211_sub_if_data *sdata, bool success),
+	TP_PROTO(struct mac80211_sub_if_data *sdata, bool success),
 
 	TP_ARGS(sdata, success),
 
diff --git a/net/mac80211/event.c b/net/mac80211/event.c
index d888b5a..1e774e1 100644
--- a/net/mac80211/event.c
+++ b/net/mac80211/event.c
@@ -15,7 +15,7 @@
  * the frame that generated the MIC failure (i.e., if it was provided by the
  * driver or is still in the frame), it should provide that information.
  */
-void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
+void mac80211_ev_michael_mic_failure(struct mac80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp)
 {
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index fc7c269..62ce6d1 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -176,7 +176,7 @@ void ieee80211_ba_session_work(struct work_struct *work)
 	mutex_unlock(&sta->ampdu_mlme.mtx);
 }
 
-void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
+void ieee80211_send_delba(struct mac80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code)
 {
@@ -220,7 +220,7 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
+void ieee80211_process_delba(struct mac80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len)
 {
@@ -246,7 +246,7 @@ void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 					       true);
 }
 
-int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
+int ieee80211_send_smps_action(struct mac80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid)
 {
@@ -295,8 +295,8 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_request_smps_work(struct work_struct *work)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
+	struct mac80211_sub_if_data *sdata =
+		container_of(work, struct mac80211_sub_if_data,
 			     u.mgd.request_smps_work);
 
 	mutex_lock(&sdata->u.mgd.mtx);
@@ -307,7 +307,7 @@ void ieee80211_request_smps_work(struct work_struct *work)
 void ieee80211_request_smps(struct ieee80211_vif *vif,
 			    enum ieee80211_smps_mode smps_mode)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 
 	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
 		return;
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 9094687..9e9caeb 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -36,7 +36,7 @@
 #define IEEE80211_IBSS_MAX_STA_ENTRIES 128
 
 
-static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_mgmt_auth_ibss(struct mac80211_sub_if_data *sdata,
 					struct ieee80211_mgmt *mgmt,
 					size_t len)
 {
@@ -61,7 +61,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 				    sdata->u.ibss.bssid, NULL, 0, 0);
 }
 
-static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+static void __ieee80211_sta_join_ibss(struct mac80211_sub_if_data *sdata,
 				      const u8 *bssid, const int beacon_int,
 				      struct ieee80211_channel *chan,
 				      const u32 basic_rates,
@@ -210,7 +210,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	cfg80211_ibss_joined(sdata->dev, ifibss->bssid, GFP_KERNEL);
 }
 
-static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_sta_join_ibss(struct mac80211_sub_if_data *sdata,
 				    struct mac80211_bss *bss)
 {
 	struct cfg80211_bss *cbss =
@@ -250,7 +250,7 @@ static void ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				  cbss->tsf);
 }
 
-static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_bss_info(struct mac80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
 				  struct ieee80211_rx_status *rx_status,
@@ -416,7 +416,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
  * in IBSS mode, receiving a frame from a yet-unknown station, hence
  * must be callable in atomic context.
  */
-struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
+struct sta_info *ieee80211_ibss_add_sta(struct mac80211_sub_if_data *sdata,
 					u8 *bssid,u8 *addr, u32 supp_rates,
 					gfp_t gfp)
 {
@@ -466,7 +466,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
-static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_sta_active_ibss(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	int active = 0;
@@ -494,7 +494,7 @@ static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
  * This function is called with state == IEEE80211_IBSS_MLME_JOINED
  */
 
-static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_sta_merge_ibss(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
@@ -523,7 +523,7 @@ static void ieee80211_sta_merge_ibss(struct ieee80211_sub_if_data *sdata)
 			ifibss->fixed_channel ? ifibss->channel : NULL);
 }
 
-static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_sta_create_ibss(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	u8 bssid[ETH_ALEN];
@@ -564,7 +564,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
  * This function is called with state == IEEE80211_IBSS_MLME_SEARCH
  */
 
-static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_sta_find_ibss(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
@@ -653,7 +653,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_mgmt_probe_req(struct mac80211_sub_if_data *sdata,
 					struct sk_buff *req)
 {
 	struct ieee80211_mgmt *mgmt = (void *)req->data;
@@ -723,7 +723,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_mgmt_probe_resp(struct mac80211_sub_if_data *sdata,
 					 struct ieee80211_mgmt *mgmt,
 					 size_t len,
 					 struct ieee80211_rx_status *rx_status)
@@ -744,7 +744,7 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, false);
 }
 
-static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_mgmt_beacon(struct mac80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
@@ -762,7 +762,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
 }
 
-void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+void ieee80211_ibss_rx_queued_mgmt(struct mac80211_sub_if_data *sdata,
 				   struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
@@ -799,7 +799,7 @@ void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&sdata->u.ibss.mtx);
 }
 
-void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
+void ieee80211_ibss_work(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
@@ -831,8 +831,8 @@ void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_ibss_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct mac80211_local *local = sdata->local;
 
@@ -845,7 +845,7 @@ static void ieee80211_ibss_timer(unsigned long data)
 }
 
 #ifdef CONFIG_PM
-void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
+void ieee80211_ibss_quiesce(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
@@ -853,7 +853,7 @@ void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata)
 		ifibss->timer_running = true;
 }
 
-void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
+void ieee80211_ibss_restart(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
@@ -864,7 +864,7 @@ void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata)
 }
 #endif
 
-void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
+void ieee80211_ibss_setup_sdata(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
 
@@ -876,7 +876,7 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 /* scan finished notification */
 void ieee80211_ibss_notify_scan_completed(struct mac80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -890,7 +890,7 @@ void ieee80211_ibss_notify_scan_completed(struct mac80211_local *local)
 	mutex_unlock(&local->iflist_mtx);
 }
 
-int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
+int ieee80211_ibss_join(struct mac80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params)
 {
 	struct sk_buff *skb;
@@ -954,7 +954,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
+int ieee80211_ibss_leave(struct mac80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
 	struct mac80211_if_ibss *ifibss = &sdata->u.ibss;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ccdc564..6eef3e5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -46,7 +46,7 @@
 static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 {
 	int meshhdrlen;
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	meshhdrlen = (sdata->vif.type == NL80211_IFTYPE_MESH_POINT) ? 5 : 0;
 
@@ -66,7 +66,7 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 
 static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sockaddr *sa = addr;
 	int ret;
 
@@ -95,11 +95,11 @@ static inline int identical_mac_addr_allowed(int type1, int type2)
 			 type2 == NL80211_IFTYPE_AP_VLAN));
 }
 
-static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
+static int ieee80211_check_concurrent_iface(struct mac80211_sub_if_data *sdata,
 					    enum nl80211_iftype iftype)
 {
 	struct mac80211_local *local = sdata->local;
-	struct ieee80211_sub_if_data *nsdata;
+	struct mac80211_sub_if_data *nsdata;
 	struct net_device *dev = sdata->dev;
 
 	ASSERT_RTNL();
@@ -149,7 +149,7 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
+void ieee80211_adjust_monitor_flags(struct mac80211_sub_if_data *sdata,
 				    const int offset)
 {
 	struct mac80211_local *local = sdata->local;
@@ -176,7 +176,7 @@ void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
  */
 static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0;
@@ -359,7 +359,7 @@ static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 
 static int ieee80211_open(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	int err;
 
 	/* fail early if user set an invalid address */
@@ -374,7 +374,7 @@ static int ieee80211_open(struct net_device *dev)
 	return ieee80211_do_open(dev, true);
 }
 
-static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_do_stop(struct mac80211_sub_if_data *sdata,
 			      bool going_down)
 {
 	struct mac80211_local *local = sdata->local;
@@ -448,7 +448,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	/* APs need special treatment */
 	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan, *tmpsdata;
+		struct mac80211_sub_if_data *vlan, *tmpsdata;
 		struct beacon_data *old_beacon =
 			rtnl_dereference(sdata->u.ap.beacon);
 
@@ -569,7 +569,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 static int ieee80211_stop(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	ieee80211_do_stop(sdata, true);
 
@@ -578,7 +578,7 @@ static int ieee80211_stop(struct net_device *dev)
 
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	int allmulti, promisc, sdata_allmulti, sdata_promisc;
 
@@ -614,7 +614,7 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
  */
 static void ieee80211_teardown_sdata(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	int flushed;
 	int i;
@@ -655,7 +655,7 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 					  struct sk_buff *skb)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
@@ -705,8 +705,8 @@ static void ieee80211_if_setup(struct net_device *dev)
 
 static void ieee80211_iface_work(struct work_struct *work)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, work);
+	struct mac80211_sub_if_data *sdata =
+		container_of(work, struct mac80211_sub_if_data, work);
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
@@ -837,7 +837,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 /*
  * Helper function to initialise an interface to a specific type.
  */
-static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_setup_sdata(struct mac80211_sub_if_data *sdata,
 				  enum nl80211_iftype type)
 {
 	/* clear type-dependent union */
@@ -901,7 +901,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_add_netdev(sdata);
 }
 
-static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
+static int ieee80211_runtime_change_iftype(struct mac80211_sub_if_data *sdata,
 					   enum nl80211_iftype type)
 {
 	struct mac80211_local *local = sdata->local;
@@ -972,7 +972,7 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
-int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
+int ieee80211_if_change_type(struct mac80211_sub_if_data *sdata,
 			     enum nl80211_iftype type)
 {
 	int ret;
@@ -1012,7 +1012,7 @@ static void ieee80211_assign_perm_addr(struct mac80211_local *local,
 				       struct net_device *dev,
 				       enum nl80211_iftype type)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	u64 mask, start, addr, val, inc;
 	u8 *m;
 	u8 tmp_addr[ETH_ALEN];
@@ -1125,7 +1125,7 @@ int ieee80211_if_add(struct mac80211_local *local, const char *name,
 		     struct vif_params *params)
 {
 	struct net_device *ndev;
-	struct ieee80211_sub_if_data *sdata = NULL;
+	struct mac80211_sub_if_data *sdata = NULL;
 	int ret, i;
 
 	ASSERT_RTNL();
@@ -1206,7 +1206,7 @@ int ieee80211_if_add(struct mac80211_local *local, const char *name,
 	return ret;
 }
 
-void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
+void ieee80211_if_remove(struct mac80211_sub_if_data *sdata)
 {
 	ASSERT_RTNL();
 
@@ -1224,7 +1224,7 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
  */
 void ieee80211_remove_interfaces(struct mac80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata, *tmp;
+	struct mac80211_sub_if_data *sdata, *tmp;
 	LIST_HEAD(unreg_list);
 
 	ASSERT_RTNL();
@@ -1271,7 +1271,7 @@ static u32 ieee80211_idle_on(struct mac80211_local *local)
 
 u32 __ieee80211_recalc_idle(struct mac80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	int count = 0;
 	bool working = false, scanning = false, hw_roc = false;
 	struct mac80211_work *wk;
@@ -1370,7 +1370,7 @@ static int netdev_notify(struct notifier_block *nb,
 			 void *ndev)
 {
 	struct net_device *dev = ndev;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	if (state != NETDEV_CHANGENAME)
 		return 0;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index c7d0c81..55f67e5 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -63,7 +63,7 @@ static struct ieee80211_sta *get_sta_for_key(struct ieee80211_key *key)
 
 static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct ieee80211_sta *sta;
 	int ret;
 
@@ -93,7 +93,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
 			goto out_unsupported;
 		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
+				     struct mac80211_sub_if_data,
 				     u.ap);
 	}
 
@@ -125,7 +125,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 
 static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct ieee80211_sta *sta;
 	int ret;
 
@@ -144,7 +144,7 @@ static void ieee80211_key_disable_hw_accel(struct ieee80211_key *key)
 
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
+				     struct mac80211_sub_if_data,
 				     u.ap);
 
 	ret = drv_set_key(key->local, DISABLE_KEY, sdata,
@@ -178,7 +178,7 @@ void ieee80211_key_removed(struct ieee80211_key_conf *key_conf)
 }
 EXPORT_SYMBOL_GPL(ieee80211_key_removed);
 
-static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
+static void __ieee80211_set_default_key(struct mac80211_sub_if_data *sdata,
 					int idx, bool uni, bool multi)
 {
 	struct ieee80211_key *key = NULL;
@@ -196,7 +196,7 @@ static void __ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_key_update_default(sdata);
 }
 
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
+void ieee80211_set_default_key(struct mac80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi)
 {
 	mutex_lock(&sdata->local->key_mtx);
@@ -205,7 +205,7 @@ void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 }
 
 static void
-__ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata, int idx)
+__ieee80211_set_default_mgmt_key(struct mac80211_sub_if_data *sdata, int idx)
 {
 	struct ieee80211_key *key = NULL;
 
@@ -220,7 +220,7 @@ __ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata, int idx)
 	ieee80211_debugfs_key_update_default(sdata);
 }
 
-void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
+void ieee80211_set_default_mgmt_key(struct mac80211_sub_if_data *sdata,
 				    int idx)
 {
 	mutex_lock(&sdata->local->key_mtx);
@@ -229,7 +229,7 @@ void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
 }
 
 
-static void __ieee80211_key_replace(struct ieee80211_sub_if_data *sdata,
+static void __ieee80211_key_replace(struct mac80211_sub_if_data *sdata,
 				    struct sta_info *sta,
 				    bool pairwise,
 				    struct ieee80211_key *old,
@@ -401,7 +401,7 @@ static void __ieee80211_key_destroy(struct ieee80211_key *key)
 }
 
 int ieee80211_key_link(struct ieee80211_key *key,
-		       struct ieee80211_sub_if_data *sdata,
+		       struct mac80211_sub_if_data *sdata,
 		       struct sta_info *sta)
 {
 	struct ieee80211_key *old_key;
@@ -487,7 +487,7 @@ void ieee80211_key_free(struct mac80211_local *local,
 	mutex_unlock(&local->key_mtx);
 }
 
-void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
+void ieee80211_enable_keys(struct mac80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;
 
@@ -504,7 +504,7 @@ void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
+void ieee80211_disable_keys(struct mac80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key;
 
@@ -518,7 +518,7 @@ void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&sdata->local->key_mtx);
 }
 
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata)
+void ieee80211_free_keys(struct mac80211_sub_if_data *sdata)
 {
 	struct ieee80211_key *key, *tmp;
 
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index 035fc31..9a930fd 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -32,7 +32,7 @@
 #define NUM_RX_DATA_QUEUES	17
 
 struct mac80211_local;
-struct ieee80211_sub_if_data;
+struct mac80211_sub_if_data;
 struct sta_info;
 
 /**
@@ -60,7 +60,7 @@ struct tkip_ctx {
 
 struct ieee80211_key {
 	struct mac80211_local *local;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
 	/* for sdata list */
@@ -133,18 +133,18 @@ struct ieee80211_key *ieee80211_key_alloc(u32 cipher, int idx, size_t key_len,
  * to make it used, free old key.
  */
 int __must_check ieee80211_key_link(struct ieee80211_key *key,
-				    struct ieee80211_sub_if_data *sdata,
+				    struct mac80211_sub_if_data *sdata,
 				    struct sta_info *sta);
 void __ieee80211_key_free(struct ieee80211_key *key);
 void ieee80211_key_free(struct mac80211_local *local,
 			struct ieee80211_key *key);
-void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
+void ieee80211_set_default_key(struct mac80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi);
-void ieee80211_set_default_mgmt_key(struct ieee80211_sub_if_data *sdata,
+void ieee80211_set_default_mgmt_key(struct mac80211_sub_if_data *sdata,
 				    int idx);
-void ieee80211_free_keys(struct ieee80211_sub_if_data *sdata);
-void ieee80211_enable_keys(struct ieee80211_sub_if_data *sdata);
-void ieee80211_disable_keys(struct ieee80211_sub_if_data *sdata);
+void ieee80211_free_keys(struct mac80211_sub_if_data *sdata);
+void ieee80211_enable_keys(struct mac80211_sub_if_data *sdata);
+void ieee80211_disable_keys(struct mac80211_sub_if_data *sdata);
 
 #define key_mtx_dereference(local, ref) \
 	rcu_dereference_protected(ref, lockdep_is_held(&((local)->key_mtx)))
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 3d1fe4f..f7d50d8 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -143,7 +143,7 @@ typedef unsigned __bitwise__ ieee80211_tx_result;
 struct mac80211_tx_data {
 	struct sk_buff *skb;
 	struct mac80211_local *local;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
 
@@ -197,7 +197,7 @@ enum mac80211_i_rx_flags {
 struct mac80211_rx_data {
 	struct sk_buff *skb;
 	struct mac80211_local *local;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
 
@@ -284,7 +284,7 @@ struct mac80211_work {
 
 	struct rcu_head rcu_head;
 
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	enum work_done_result (*done)(struct mac80211_work *wk,
 				      struct sk_buff *skb);
@@ -536,7 +536,7 @@ enum mac80211_sdata_state_bits {
 	SDATA_STATE_OFFCHANNEL,
 };
 
-struct ieee80211_sub_if_data {
+struct mac80211_sub_if_data {
 	struct list_head list;
 
 	struct wireless_dev wdev;
@@ -616,9 +616,9 @@ struct ieee80211_sub_if_data {
 };
 
 static inline
-struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
+struct mac80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
 {
-	return container_of(p, struct ieee80211_sub_if_data, vif);
+	return container_of(p, struct mac80211_sub_if_data, vif);
 }
 
 enum sdata_queue_type {
@@ -853,7 +853,7 @@ struct mac80211_local {
 	unsigned long leave_oper_channel_time;
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
-	struct ieee80211_sub_if_data *scan_sdata;
+	struct mac80211_sub_if_data *scan_sdata;
 	enum nl80211_channel_type _oper_channel_type;
 	struct ieee80211_channel *oper_channel, *csa_channel;
 
@@ -934,7 +934,7 @@ struct mac80211_local {
 	 * PS can only be enabled when we have exactly one managed
 	 * interface (and monitors) in PS, this then points there.
 	 */
-	struct ieee80211_sub_if_data *ps_sdata;
+	struct mac80211_sub_if_data *ps_sdata;
 	struct work_struct dynamic_ps_enable_work;
 	struct work_struct dynamic_ps_disable_work;
 	struct timer_list dynamic_ps_timer;
@@ -979,7 +979,7 @@ struct mac80211_local {
 	struct napi_struct napi;
 };
 
-static inline struct ieee80211_sub_if_data *
+static inline struct mac80211_sub_if_data *
 IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
 {
 	return netdev_priv(dev);
@@ -1076,71 +1076,71 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 
 int ieee80211_hw_config(struct mac80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct mac80211_tx_data *tx);
-void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+void ieee80211_bss_info_change_notify(struct mac80211_sub_if_data *sdata,
 				      u32 changed);
 void ieee80211_configure_filter(struct mac80211_local *local);
-u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
+u32 ieee80211_reset_erp_info(struct mac80211_sub_if_data *sdata);
 
 /* STA code */
-void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata);
-int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_setup_sdata(struct mac80211_sub_if_data *sdata);
+int ieee80211_mgd_auth(struct mac80211_sub_if_data *sdata,
 		       struct cfg80211_auth_request *req);
-int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_assoc(struct mac80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req);
-int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_deauth(struct mac80211_sub_if_data *sdata,
 			 struct cfg80211_deauth_request *req,
 			 void *cookie);
-int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_disassoc(struct mac80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req,
 			   void *cookie);
 void ieee80211_send_pspoll(struct mac80211_local *local,
-			   struct ieee80211_sub_if_data *sdata);
+			   struct mac80211_sub_if_data *sdata);
 void ieee80211_recalc_ps(struct mac80211_local *local, s32 latency);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
-int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+int ieee80211_set_arp_filter(struct mac80211_sub_if_data *sdata);
+void ieee80211_sta_process_chanswitch(struct mac80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
 				      struct mac80211_bss *bss,
 				      u64 timestamp);
-void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_quiesce(struct mac80211_sub_if_data *sdata);
+void ieee80211_sta_restart(struct mac80211_sub_if_data *sdata);
+void ieee80211_sta_work(struct mac80211_sub_if_data *sdata);
+void ieee80211_sta_rx_queued_mgmt(struct mac80211_sub_if_data *sdata,
 				  struct sk_buff *skb);
-void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_reset_beacon_monitor(struct mac80211_sub_if_data *sdata);
+void ieee80211_sta_reset_conn_monitor(struct mac80211_sub_if_data *sdata);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct mac80211_local *local);
-void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
-struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
+void ieee80211_ibss_setup_sdata(struct mac80211_sub_if_data *sdata);
+struct sta_info *ieee80211_ibss_add_sta(struct mac80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
 					gfp_t gfp);
-int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
+int ieee80211_ibss_join(struct mac80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params);
-int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
-void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata);
-void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata);
-void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata);
-void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+int ieee80211_ibss_leave(struct mac80211_sub_if_data *sdata);
+void ieee80211_ibss_quiesce(struct mac80211_sub_if_data *sdata);
+void ieee80211_ibss_restart(struct mac80211_sub_if_data *sdata);
+void ieee80211_ibss_work(struct mac80211_sub_if_data *sdata);
+void ieee80211_ibss_rx_queued_mgmt(struct mac80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
 
 /* mesh code */
-void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
-void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+void ieee80211_mesh_work(struct mac80211_sub_if_data *sdata);
+void ieee80211_mesh_rx_queued_mgmt(struct mac80211_sub_if_data *sdata,
 				   struct sk_buff *skb);
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
-int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
+int ieee80211_request_internal_scan(struct mac80211_sub_if_data *sdata,
 				    const u8 *ssid, u8 ssid_len,
 				    struct ieee80211_channel *chan);
-int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
+int ieee80211_request_scan(struct mac80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 void ieee80211_scan_cancel(struct mac80211_local *local);
 ieee80211_rx_result
-ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+ieee80211_scan_rx(struct mac80211_sub_if_data *sdata, struct sk_buff *skb);
 
 void ieee80211_mlme_notify_scan_completed(struct mac80211_local *local);
 struct mac80211_bss *
@@ -1158,9 +1158,9 @@ void ieee80211_rx_bss_put(struct mac80211_local *local,
 			  struct mac80211_bss *bss);
 
 /* scheduled scan handling */
-int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
+int ieee80211_request_sched_scan_start(struct mac80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req);
-int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
+int ieee80211_request_sched_scan_stop(struct mac80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
@@ -1180,16 +1180,16 @@ void ieee80211_iface_exit(void);
 int ieee80211_if_add(struct mac80211_local *local, const char *name,
 		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params);
-int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
+int ieee80211_if_change_type(struct mac80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
-void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
+void ieee80211_if_remove(struct mac80211_sub_if_data *sdata);
 void ieee80211_remove_interfaces(struct mac80211_local *local);
 u32 __ieee80211_recalc_idle(struct mac80211_local *local);
 void ieee80211_recalc_idle(struct mac80211_local *local);
-void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
+void ieee80211_adjust_monitor_flags(struct mac80211_sub_if_data *sdata,
 				    const int offset);
 
-static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
+static inline bool ieee80211_sdata_running(struct mac80211_sub_if_data *sdata)
 {
 	return test_bit(SDATA_STATE_RUNNING, &sdata->state);
 }
@@ -1218,11 +1218,11 @@ struct ieee80211_tx_status_rtap_hdr {
 void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
-void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
-void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
+void ieee80211_send_bar(struct mac80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn);
+void ieee80211_send_delba(struct mac80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code);
-int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
+int ieee80211_send_smps_action(struct mac80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid);
 void ieee80211_request_smps_work(struct work_struct *work);
@@ -1232,7 +1232,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 void __ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				    u16 initiator, u16 reason, bool stop);
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx);
-void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
+void ieee80211_process_delba(struct mac80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len);
 void ieee80211_process_addba_resp(struct mac80211_local *local,
@@ -1257,7 +1257,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 /* Spectrum management */
-void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
+void ieee80211_process_measurement_req(struct mac80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len);
 
@@ -1298,11 +1298,11 @@ u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
 int ieee80211_frame_duration(struct mac80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
-void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
+void mac80211_ev_michael_mic_failure(struct mac80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
 				     gfp_t gfp);
-void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata);
-void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
+void ieee80211_set_wmm_default(struct mac80211_sub_if_data *sdata);
+void ieee80211_tx_skb(struct mac80211_sub_if_data *sdata, struct sk_buff *skb);
 void ieee802_11_parse_elems(u8 *start, size_t len,
 			    struct ieee802_11_elems *elems);
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
@@ -1315,11 +1315,11 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
 void ieee80211_send_nullfunc(struct mac80211_local *local,
-			     struct ieee80211_sub_if_data *sdata,
+			     struct mac80211_sub_if_data *sdata,
 			     int powersave);
-void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_rx_notify(struct mac80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr);
-void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_tx_notify(struct mac80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack);
 void ieee80211_beacon_connection_loss_work(struct work_struct *work);
 
@@ -1339,7 +1339,7 @@ int ieee80211_add_pending_skbs_fn(struct mac80211_local *local,
 				  struct sk_buff_head *skbs,
 				  void (*fn)(void *data), void *data);
 
-void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
+void ieee80211_send_auth(struct mac80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *key, u8 key_len, u8 key_idx);
@@ -1347,21 +1347,21 @@ int ieee80211_build_preq_ies(struct mac80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel);
-struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
+struct sk_buff *ieee80211_build_probe_req(struct mac80211_sub_if_data *sdata,
 					  u8 *dst,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len);
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+void ieee80211_send_probe_req(struct mac80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len);
 
-void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_def_wmm_params(struct mac80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates);
 u32 ieee80211_sta_get_rates(struct mac80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
-int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
+int __ieee80211_request_smps(struct mac80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode);
 void ieee80211_recalc_smps(struct mac80211_local *local);
 
@@ -1373,15 +1373,15 @@ size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 void ieee80211_work_init(struct mac80211_local *local);
 void ieee80211_add_work(struct mac80211_work *wk);
 void free_work(struct mac80211_work *wk);
-void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata);
-ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
+void ieee80211_work_purge(struct mac80211_sub_if_data *sdata);
+ieee80211_rx_result ieee80211_work_rx_mgmt(struct mac80211_sub_if_data *sdata,
 					   struct sk_buff *skb);
-int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
+int ieee80211_wk_remain_on_channel(struct mac80211_sub_if_data *sdata,
 				   struct ieee80211_channel *chan,
 				   enum nl80211_channel_type channel_type,
 				   unsigned int duration, u64 *cookie);
 int ieee80211_wk_cancel_remain_on_channel(
-	struct ieee80211_sub_if_data *sdata, u64 cookie);
+	struct mac80211_sub_if_data *sdata, u64 cookie);
 
 /* channel management */
 enum ieee80211_chan_mode {
@@ -1392,9 +1392,9 @@ enum ieee80211_chan_mode {
 
 enum ieee80211_chan_mode
 ieee80211_get_channel_mode(struct mac80211_local *local,
-			   struct ieee80211_sub_if_data *ignore);
+			   struct mac80211_sub_if_data *ignore);
 bool ieee80211_set_channel_type(struct mac80211_local *local,
-				struct ieee80211_sub_if_data *sdata,
+				struct mac80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype);
 
 #ifdef CONFIG_MAC80211_NOINLINE
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index bd8c543..fd1f83c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -231,7 +231,7 @@ int ieee80211_hw_config(struct mac80211_local *local, u32 changed)
 	return ret;
 }
 
-void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
+void ieee80211_bss_info_change_notify(struct mac80211_sub_if_data *sdata,
 				      u32 changed)
 {
 	struct mac80211_local *local = sdata->local;
@@ -312,7 +312,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 	drv_bss_info_changed(local, sdata, &sdata->vif.bss_conf, changed);
 }
 
-u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
+u32 ieee80211_reset_erp_info(struct mac80211_sub_if_data *sdata)
 {
 	sdata->vif.bss_conf.use_cts_prot = false;
 	sdata->vif.bss_conf.use_short_preamble = false;
@@ -407,7 +407,7 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 	struct net_device *ndev = ifa->ifa_dev->dev;
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
 	struct in_device *idev;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct ieee80211_bss_conf *bss_conf;
 	struct mac80211_if_managed *ifmgd;
 	int c = 0;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b86f02e..12bfa03 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -43,7 +43,7 @@ void ieee80211s_stop(void)
 
 static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata = (void *) data;
+	struct mac80211_sub_if_data *sdata = (void *) data;
 	struct mac80211_local *local = sdata->local;
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
@@ -66,7 +66,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
  * This function checks if the mesh configuration of a mesh point matches the
  * local mesh configuration, i.e. if both nodes belong to the same mesh network.
  */
-bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_data *sdata)
+bool mesh_matches_local(struct ieee802_11_elems *ie, struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
@@ -108,7 +108,7 @@ bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie)
  *
  * @sdata: mesh interface in which mesh beacons are going to be updated
  */
-void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
+void mesh_accept_plinks_update(struct mac80211_sub_if_data *sdata)
 {
 	bool free_plinks;
 
@@ -124,7 +124,7 @@ void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mesh_housekeeping_timer((unsigned long) sdata);
 }
 
-int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
+int mesh_rmc_init(struct mac80211_sub_if_data *sdata)
 {
 	int i;
 
@@ -137,7 +137,7 @@ int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
 	return 0;
 }
 
-void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
+void mesh_rmc_free(struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
 	struct rmc_entry *p, *n;
@@ -169,7 +169,7 @@ void mesh_rmc_free(struct ieee80211_sub_if_data *sdata)
  * it.
  */
 int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
-		   struct ieee80211_sub_if_data *sdata)
+		   struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_rmc *rmc = sdata->u.mesh.rmc;
 	u32 seqnum = 0;
@@ -204,7 +204,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 	return 0;
 }
 
-void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
+void mesh_mgmt_ies_add(struct sk_buff *skb, struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -290,8 +290,8 @@ void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_mesh_path_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 
@@ -305,8 +305,8 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 
 static void ieee80211_mesh_path_root_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
 
@@ -376,7 +376,7 @@ int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
  * Return the header length.
  */
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata, char *addr4or5,
+		struct mac80211_sub_if_data *sdata, char *addr4or5,
 		char *addr6)
 {
 	int aelen = 0;
@@ -398,7 +398,7 @@ int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
 	return 6 + aelen;
 }
 
-static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_mesh_housekeeping(struct mac80211_sub_if_data *sdata,
 			   struct mac80211_if_mesh *ifmsh)
 {
 	bool free_plinks;
@@ -419,7 +419,7 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
 }
 
-static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_mesh_rootpath(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
@@ -429,7 +429,7 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 }
 
 #ifdef CONFIG_PM
-void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mesh_quiesce(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
@@ -443,7 +443,7 @@ void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
 }
 
-void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mesh_restart(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
@@ -457,7 +457,7 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 }
 #endif
 
-void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
+void ieee80211_start_mesh(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
@@ -479,7 +479,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 						BSS_CHANGED_BEACON_INT);
 }
 
-void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
+void ieee80211_stop_mesh(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -504,7 +504,7 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_configure_filter(local);
 }
 
-static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_mesh_rx_bcn_presp(struct mac80211_sub_if_data *sdata,
 					u16 stype,
 					struct ieee80211_mgmt *mgmt,
 					size_t len,
@@ -551,7 +551,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_mesh_rx_mgmt_action(struct mac80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len,
 					  struct ieee80211_rx_status *rx_status)
@@ -566,7 +566,7 @@ static void ieee80211_mesh_rx_mgmt_action(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+void ieee80211_mesh_rx_queued_mgmt(struct mac80211_sub_if_data *sdata,
 				   struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
@@ -589,7 +589,7 @@ void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mesh_work(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
@@ -613,7 +613,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_mesh_notify_scan_completed(struct mac80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
@@ -622,7 +622,7 @@ void ieee80211_mesh_notify_scan_completed(struct mac80211_local *local)
 	rcu_read_unlock();
 }
 
-void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mesh_init_sdata(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index db38d57..6be0fd1 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -91,7 +91,7 @@ enum mesh_deferred_task_flags {
 struct mesh_path {
 	u8 dst[ETH_ALEN];
 	u8 mpp[ETH_ALEN];	/* used for MPP or MAP */
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info __rcu *next_hop;
 	struct timer_list timer;
 	struct sk_buff_head frame_queue;
@@ -190,54 +190,54 @@ struct mesh_rmc {
 int ieee80211_fill_mesh_addresses(struct ieee80211_hdr *hdr, __le16 *fc,
 				  const u8 *da, const u8 *sa);
 int ieee80211_new_mesh_header(struct ieee80211s_hdr *meshhdr,
-		struct ieee80211_sub_if_data *sdata, char *addr4or5,
+		struct mac80211_sub_if_data *sdata, char *addr4or5,
 		char *addr6);
 int mesh_rmc_check(u8 *addr, struct ieee80211s_hdr *mesh_hdr,
-		struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
 bool mesh_matches_local(struct ieee802_11_elems *ie,
-		struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
 void mesh_ids_set_default(struct mac80211_if_mesh *mesh);
 void mesh_mgmt_ies_add(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
-int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
+void mesh_rmc_free(struct mac80211_sub_if_data *sdata);
+int mesh_rmc_init(struct mac80211_sub_if_data *sdata);
 void ieee80211s_init(void);
 void ieee80211s_update_metric(struct mac80211_local *local,
 		struct sta_info *stainfo, struct sk_buff *skb);
 void ieee80211s_stop(void);
-void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
-void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata);
-void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_init_sdata(struct mac80211_sub_if_data *sdata);
+void ieee80211_start_mesh(struct mac80211_sub_if_data *sdata);
+void ieee80211_stop_mesh(struct mac80211_sub_if_data *sdata);
 void ieee80211_mesh_root_setup(struct mac80211_if_mesh *ifmsh);
 
 /* Mesh paths */
 int mesh_nexthop_lookup(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
+void mesh_path_start_discovery(struct mac80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup(u8 *dst,
-		struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
 struct mesh_path *mpp_path_lookup(u8 *dst,
-				  struct ieee80211_sub_if_data *sdata);
-int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata);
+				  struct mac80211_sub_if_data *sdata);
+int mpp_path_add(u8 *dst, u8 *mpp, struct mac80211_sub_if_data *sdata);
 struct mesh_path *mesh_path_lookup_by_idx(int idx,
-		struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
 void mesh_path_fix_nexthop(struct mesh_path *mpath, struct sta_info *next_hop);
-void mesh_path_expire(struct ieee80211_sub_if_data *sdata);
-void mesh_path_flush(struct ieee80211_sub_if_data *sdata);
-void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
+void mesh_path_expire(struct mac80211_sub_if_data *sdata);
+void mesh_path_flush(struct mac80211_sub_if_data *sdata);
+void mesh_rx_path_sel_frame(struct mac80211_sub_if_data *sdata,
 		struct ieee80211_mgmt *mgmt, size_t len);
-int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata);
+int mesh_path_add(u8 *dst, struct mac80211_sub_if_data *sdata);
 /* Mesh plinks */
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata,
+		struct mac80211_sub_if_data *sdata,
 		struct ieee802_11_elems *ie);
 bool mesh_peer_accepts_plinks(struct ieee802_11_elems *ie);
-void mesh_accept_plinks_update(struct ieee80211_sub_if_data *sdata);
+void mesh_accept_plinks_update(struct mac80211_sub_if_data *sdata);
 void mesh_plink_broken(struct sta_info *sta);
 void mesh_plink_deactivate(struct sta_info *sta);
 int mesh_plink_open(struct sta_info *sta);
 void mesh_plink_block(struct sta_info *sta);
-void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
+void mesh_rx_plink_frame(struct mac80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len,
 			 struct ieee80211_rx_status *rx_status);
 
@@ -247,33 +247,33 @@ void mesh_mpath_table_grow(void);
 void mesh_mpp_table_grow(void);
 /* Mesh paths */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn, __le16 target_rcode,
-		       const u8 *ra, struct ieee80211_sub_if_data *sdata);
+		       const u8 *ra, struct mac80211_sub_if_data *sdata);
 void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta);
 void mesh_path_flush_pending(struct mesh_path *mpath);
 void mesh_path_tx_pending(struct mesh_path *mpath);
 int mesh_pathtbl_init(void);
 void mesh_pathtbl_unregister(void);
-int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata);
+int mesh_path_del(u8 *addr, struct mac80211_sub_if_data *sdata);
 void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct sk_buff *skb,
-		struct ieee80211_sub_if_data *sdata);
-void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
-void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
-void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
+		struct mac80211_sub_if_data *sdata);
+void mesh_path_quiesce(struct mac80211_sub_if_data *sdata);
+void mesh_path_restart(struct mac80211_sub_if_data *sdata);
+void mesh_path_tx_root_frame(struct mac80211_sub_if_data *sdata);
 
 extern int mesh_paths_generation;
 
 #ifdef CONFIG_MAC80211_MESH
 extern int mesh_allocated;
 
-static inline int mesh_plink_free_count(struct ieee80211_sub_if_data *sdata)
+static inline int mesh_plink_free_count(struct mac80211_sub_if_data *sdata)
 {
 	return sdata->u.mesh.mshcfg.dot11MeshMaxPeerLinks -
 	       atomic_read(&sdata->u.mesh.mshstats.estab_plinks);
 }
 
-static inline bool mesh_plink_availables(struct ieee80211_sub_if_data *sdata)
+static inline bool mesh_plink_availables(struct mac80211_sub_if_data *sdata)
 {
 	return (min_t(long, mesh_plink_free_count(sdata),
 		   MESH_MAX_PLINKS - sdata->local->num_sta)) > 0;
@@ -284,28 +284,28 @@ static inline void mesh_path_activate(struct mesh_path *mpath)
 	mpath->flags |= MESH_PATH_ACTIVE | MESH_PATH_RESOLVED;
 }
 
-static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
+static inline bool mesh_path_sel_is_hwmp(struct mac80211_sub_if_data *sdata)
 {
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
 void ieee80211_mesh_notify_scan_completed(struct mac80211_local *local);
 
-void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
-void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_quiesce(struct mac80211_sub_if_data *sdata);
+void ieee80211_mesh_restart(struct mac80211_sub_if_data *sdata);
 void mesh_plink_quiesce(struct sta_info *sta);
 void mesh_plink_restart(struct sta_info *sta);
 #else
 #define mesh_allocated	0
 static inline void
 ieee80211_mesh_notify_scan_completed(struct mac80211_local *local) {}
-static inline void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
+static inline void ieee80211_mesh_quiesce(struct mac80211_sub_if_data *sdata)
 {}
-static inline void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
+static inline void ieee80211_mesh_restart(struct mac80211_sub_if_data *sdata)
 {}
 static inline void mesh_plink_quiesce(struct sta_info *sta) {}
 static inline void mesh_plink_restart(struct sta_info *sta) {}
-static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
+static inline bool mesh_path_sel_is_hwmp(struct mac80211_sub_if_data *sdata)
 { return false; }
 #endif
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 4eca250..017ec80 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -108,7 +108,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		u8 *orig_addr, __le32 orig_sn, u8 target_flags, u8 *target,
 		__le32 target_sn, const u8 *da, u8 hop_count, u8 ttl,
 		__le32 lifetime, __le32 metric, __le32 preq_id,
-		struct ieee80211_sub_if_data *sdata)
+		struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -202,7 +202,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
  */
 int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		       __le16 target_rcode, const u8 *ra,
-		       struct ieee80211_sub_if_data *sdata)
+		       struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
@@ -321,7 +321,7 @@ static u32 airtime_link_metric_get(struct mac80211_local *local,
  * Notes: this function is the only place (besides user-provided info) where
  * path routing information is updated.
  */
-static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
+static u32 hwmp_route_info_get(struct mac80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt,
 			    u8 *hwmp_ie, enum mpath_frame_type action)
 {
@@ -465,7 +465,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 	return process ? new_metric : 0;
 }
 
-static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
+static void hwmp_preq_frame_process(struct mac80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *preq_elem, u32 metric)
 {
@@ -568,7 +568,7 @@ next_hop_deref_protected(struct mesh_path *mpath)
 }
 
 
-static void hwmp_prep_frame_process(struct ieee80211_sub_if_data *sdata,
+static void hwmp_prep_frame_process(struct mac80211_sub_if_data *sdata,
 				    struct ieee80211_mgmt *mgmt,
 				    u8 *prep_elem, u32 metric)
 {
@@ -633,7 +633,7 @@ fail:
 	sdata->u.mesh.mshstats.dropped_frames_no_route++;
 }
 
-static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
+static void hwmp_perr_frame_process(struct mac80211_sub_if_data *sdata,
 			     struct ieee80211_mgmt *mgmt, u8 *perr_elem)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -675,7 +675,7 @@ static void hwmp_perr_frame_process(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 }
 
-static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
+static void hwmp_rann_frame_process(struct mac80211_sub_if_data *sdata,
 				struct ieee80211_mgmt *mgmt,
 				struct ieee80211_rann_ie *rann)
 {
@@ -725,7 +725,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
 }
 
 
-void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
+void mesh_rx_path_sel_frame(struct mac80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt,
 			    size_t len)
 {
@@ -782,7 +782,7 @@ void mesh_rx_path_sel_frame(struct ieee80211_sub_if_data *sdata,
  */
 static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 {
-	struct ieee80211_sub_if_data *sdata = mpath->sdata;
+	struct mac80211_sub_if_data *sdata = mpath->sdata;
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
 
@@ -827,7 +827,7 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
  *
  * @sdata: local mesh subif
  */
-void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
+void mesh_path_start_discovery(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mesh_preq_queue *preq_node;
@@ -918,7 +918,7 @@ enddiscovery:
  * in this case.
  */
 int mesh_nexthop_lookup(struct sk_buff *skb,
-			struct ieee80211_sub_if_data *sdata)
+			struct mac80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb_to_free = NULL;
 	struct mesh_path *mpath;
@@ -981,7 +981,7 @@ endlookup:
 void mesh_path_timer(unsigned long data)
 {
 	struct mesh_path *mpath = (void *) data;
-	struct ieee80211_sub_if_data *sdata = mpath->sdata;
+	struct mac80211_sub_if_data *sdata = mpath->sdata;
 
 	if (sdata->local->quiescing)
 		return;
@@ -1004,7 +1004,7 @@ void mesh_path_timer(unsigned long data)
 }
 
 void
-mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
+mesh_path_tx_root_frame(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index c52b981..9b9140e 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -164,7 +164,7 @@ errcopy:
 	return -ENOMEM;
 }
 
-static u32 mesh_table_hash(u8 *addr, struct ieee80211_sub_if_data *sdata,
+static u32 mesh_table_hash(u8 *addr, struct mac80211_sub_if_data *sdata,
 			   struct mesh_table *tbl)
 {
 	/* Use last four bytes of hw addr and interface index as hash index */
@@ -215,7 +215,7 @@ void mesh_path_assign_nexthop(struct mesh_path *mpath, struct sta_info *sta)
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+struct mesh_path *mesh_path_lookup(u8 *dst, struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct hlist_node *n;
@@ -242,7 +242,7 @@ struct mesh_path *mesh_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
 	return NULL;
 }
 
-struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
+struct mesh_path *mpp_path_lookup(u8 *dst, struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_path *mpath;
 	struct hlist_node *n;
@@ -279,7 +279,7 @@ struct mesh_path *mpp_path_lookup(u8 *dst, struct ieee80211_sub_if_data *sdata)
  *
  * Locking: must be called within a read rcu section.
  */
-struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data *sdata)
+struct mesh_path *mesh_path_lookup_by_idx(int idx, struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl = rcu_dereference(mesh_paths);
 	struct mpath_node *node;
@@ -313,7 +313,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
  *
  * State: the initial state of the new path is set to 0
  */
-int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
+int mesh_path_add(u8 *dst, struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
@@ -445,7 +445,7 @@ void mesh_mpp_table_grow(void)
 	write_unlock_bh(&pathtbl_resize_lock);
 }
 
-int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
+int mpp_path_add(u8 *dst, u8 *mpp, struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct mac80211_local *local = sdata->local;
@@ -537,7 +537,7 @@ void mesh_plink_broken(struct sta_info *sta)
 	struct mesh_path *mpath;
 	struct mpath_node *node;
 	struct hlist_node *p;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	int i;
 
 	rcu_read_lock();
@@ -590,7 +590,7 @@ void mesh_path_flush_by_nexthop(struct sta_info *sta)
 	rcu_read_unlock();
 }
 
-void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
+void mesh_path_flush(struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
@@ -611,7 +611,7 @@ void mesh_path_flush(struct ieee80211_sub_if_data *sdata)
 static void mesh_path_node_reclaim(struct rcu_head *rp)
 {
 	struct mpath_node *node = container_of(rp, struct mpath_node, rcu);
-	struct ieee80211_sub_if_data *sdata = node->mpath->sdata;
+	struct mac80211_sub_if_data *sdata = node->mpath->sdata;
 
 	del_timer_sync(&node->mpath->timer);
 	atomic_dec(&sdata->u.mesh.mpaths);
@@ -627,7 +627,7 @@ static void mesh_path_node_reclaim(struct rcu_head *rp)
  *
  * Returns: 0 if successful
  */
-int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
+int mesh_path_del(u8 *addr, struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
@@ -694,7 +694,7 @@ void mesh_path_tx_pending(struct mesh_path *mpath)
  * Locking: the function must me called within a rcu_read_lock region
  */
 void mesh_path_discard_frame(struct sk_buff *skb,
-			     struct ieee80211_sub_if_data *sdata)
+			     struct mac80211_sub_if_data *sdata)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct mesh_path *mpath;
@@ -814,7 +814,7 @@ int mesh_pathtbl_init(void)
 	return 0;
 }
 
-void mesh_path_expire(struct ieee80211_sub_if_data *sdata)
+void mesh_path_expire(struct mac80211_sub_if_data *sdata)
 {
 	struct mesh_table *tbl;
 	struct mesh_path *mpath;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index a4e2de0..4a40ada 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -61,14 +61,14 @@ enum plink_event {
 };
 
 static inline
-void mesh_plink_inc_estab_count(struct ieee80211_sub_if_data *sdata)
+void mesh_plink_inc_estab_count(struct mac80211_sub_if_data *sdata)
 {
 	atomic_inc(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
 }
 
 static inline
-void mesh_plink_dec_estab_count(struct ieee80211_sub_if_data *sdata)
+void mesh_plink_dec_estab_count(struct mac80211_sub_if_data *sdata)
 {
 	atomic_dec(&sdata->u.mesh.mshstats.estab_plinks);
 	mesh_accept_plinks_update(sdata);
@@ -92,7 +92,7 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
  * NOTE: This is just an alias for sta_info_alloc(), see notes
  *       on it in the lifecycle management section!
  */
-static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
+static struct sta_info *mesh_plink_alloc(struct mac80211_sub_if_data *sdata,
 					 u8 *hw_addr, u32 rates)
 {
 	struct mac80211_local *local = sdata->local;
@@ -123,7 +123,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
  */
 static bool __mesh_plink_deactivate(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	bool deactivated = false;
 
 	if (sta->plink_state == NL80211_PLINK_ESTAB) {
@@ -145,7 +145,7 @@ static bool __mesh_plink_deactivate(struct sta_info *sta)
  */
 void mesh_plink_deactivate(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	bool deactivated;
 
 	spin_lock_bh(&sta->lock);
@@ -156,7 +156,7 @@ void mesh_plink_deactivate(struct sta_info *sta)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 }
 
-static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
+static int mesh_plink_frame_tx(struct mac80211_sub_if_data *sdata,
 		enum plink_frame_type action, u8 *da, __le16 llid, __le16 plid,
 		__le16 reason) {
 	struct mac80211_local *local = sdata->local;
@@ -238,7 +238,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 }
 
 void mesh_neighbour_update(u8 *hw_addr, u32 rates,
-		struct ieee80211_sub_if_data *sdata,
+		struct mac80211_sub_if_data *sdata,
 		struct ieee802_11_elems *elems)
 {
 	struct mac80211_local *local = sdata->local;
@@ -280,7 +280,7 @@ static void mesh_plink_timer(unsigned long data)
 {
 	struct sta_info *sta;
 	__le16 llid, plid, reason;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	/*
 	 * This STA is valid because sta_info_destroy() will
@@ -378,7 +378,7 @@ static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 int mesh_plink_open(struct sta_info *sta)
 {
 	__le16 llid;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 
 	if (!test_sta_flags(sta, WLAN_STA_AUTH))
 		return -EPERM;
@@ -402,7 +402,7 @@ int mesh_plink_open(struct sta_info *sta)
 
 void mesh_plink_block(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	bool deactivated;
 
 	spin_lock_bh(&sta->lock);
@@ -415,7 +415,7 @@ void mesh_plink_block(struct sta_info *sta)
 }
 
 
-void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
+void mesh_rx_plink_frame(struct mac80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
 {
 	struct mac80211_local *local = sdata->local;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 77fe8a7..46bc4db 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -123,7 +123,7 @@ static void run_again(struct mac80211_if_managed *ifmgd,
 		mod_timer(&ifmgd->timer, timeout);
 }
 
-void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_reset_beacon_monitor(struct mac80211_sub_if_data *sdata)
 {
 	if (sdata->local->hw.flags & IEEE80211_HW_BEACON_FILTER)
 		return;
@@ -132,7 +132,7 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies_up(jiffies + sdata->u.mgd.beacon_timeout));
 }
 
-void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_reset_conn_monitor(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
@@ -158,7 +158,7 @@ static int ecw2cw(int ecw)
  * has been determined as ht configuration depends on the hw's
  * HT abilities for a specific band.
  */
-static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
+static u32 ieee80211_enable_ht(struct mac80211_sub_if_data *sdata,
 			       struct ieee80211_ht_info *hti,
 			       const u8 *bssid, u16 ap_ht_cap_flags)
 {
@@ -261,7 +261,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 
 /* frame sending functions */
 
-static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_send_deauth_disassoc(struct mac80211_sub_if_data *sdata,
 					   const u8 *bssid, u16 stype, u16 reason,
 					   void *cookie, bool send_frame)
 {
@@ -308,7 +308,7 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 }
 
 void ieee80211_send_pspoll(struct mac80211_local *local,
-			   struct ieee80211_sub_if_data *sdata)
+			   struct mac80211_sub_if_data *sdata)
 {
 	struct ieee80211_pspoll *pspoll;
 	struct sk_buff *skb;
@@ -325,7 +325,7 @@ void ieee80211_send_pspoll(struct mac80211_local *local,
 }
 
 void ieee80211_send_nullfunc(struct mac80211_local *local,
-			     struct ieee80211_sub_if_data *sdata,
+			     struct mac80211_sub_if_data *sdata,
 			     int powersave)
 {
 	struct sk_buff *skb;
@@ -344,7 +344,7 @@ void ieee80211_send_nullfunc(struct mac80211_local *local,
 }
 
 static void ieee80211_send_4addr_nullfunc(struct mac80211_local *local,
-					  struct ieee80211_sub_if_data *sdata)
+					  struct mac80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
 	struct ieee80211_hdr *nullfunc;
@@ -378,8 +378,8 @@ static void ieee80211_send_4addr_nullfunc(struct mac80211_local *local,
 /* spectrum management related things */
 static void ieee80211_chswitch_work(struct work_struct *work)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
+	struct mac80211_sub_if_data *sdata =
+		container_of(work, struct mac80211_sub_if_data, u.mgd.chswitch_work);
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -408,7 +408,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_if_managed *ifmgd;
 
 	sdata = vif_to_sdata(vif);
@@ -431,8 +431,8 @@ EXPORT_SYMBOL(ieee80211_chswitch_done);
 
 static void ieee80211_chswitch_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (sdata->local->quiescing) {
@@ -443,7 +443,7 @@ static void ieee80211_chswitch_timer(unsigned long data)
 	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
 }
 
-void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_process_chanswitch(struct mac80211_sub_if_data *sdata,
 				      struct ieee80211_channel_sw_ie *sw_elem,
 				      struct mac80211_bss *bss,
 				      u64 timestamp)
@@ -507,7 +507,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_handle_pwr_constr(struct mac80211_sub_if_data *sdata,
 					u16 capab_info, u8 *pwr_constr_elem,
 					u8 pwr_constr_elem_len)
 {
@@ -529,7 +529,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
 
@@ -544,7 +544,7 @@ EXPORT_SYMBOL(ieee80211_enable_dyn_ps);
 
 void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
 
@@ -562,7 +562,7 @@ EXPORT_SYMBOL(ieee80211_disable_dyn_ps);
 
 /* powersave */
 static void ieee80211_enable_ps(struct mac80211_local *local,
-				struct ieee80211_sub_if_data *sdata)
+				struct mac80211_sub_if_data *sdata)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
 
@@ -604,7 +604,7 @@ static void ieee80211_change_ps(struct mac80211_local *local)
 	}
 }
 
-static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
+static bool ieee80211_powersave_allowed(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *mgd = &sdata->u.mgd;
 	struct sta_info *sta = NULL;
@@ -638,7 +638,7 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 /* need to hold RTNL or interface lock */
 void ieee80211_recalc_ps(struct mac80211_local *local, s32 latency)
 {
-	struct ieee80211_sub_if_data *sdata, *found = NULL;
+	struct mac80211_sub_if_data *sdata, *found = NULL;
 	int count = 0;
 	int timeout;
 
@@ -748,7 +748,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	struct mac80211_local *local =
 		container_of(work, struct mac80211_local,
 			     dynamic_ps_enable_work);
-	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
+	struct mac80211_sub_if_data *sdata = local->ps_sdata;
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	unsigned long flags;
 	int q;
@@ -816,7 +816,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 
 /* MLME */
 static void ieee80211_sta_wmm_params(struct mac80211_local *local,
-				     struct ieee80211_sub_if_data *sdata,
+				     struct mac80211_sub_if_data *sdata,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
 	struct ieee80211_tx_queue_params params;
@@ -914,7 +914,7 @@ static void ieee80211_sta_wmm_params(struct mac80211_local *local,
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
 }
 
-static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
+static u32 ieee80211_handle_bss_capability(struct mac80211_sub_if_data *sdata,
 					   u16 capab, bool erp_valid, u8 erp)
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
@@ -953,7 +953,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	return changed;
 }
 
-static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_set_associated(struct mac80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss,
 				     u32 bss_info_changed)
 {
@@ -1022,7 +1022,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	netif_carrier_on(sdata->dev);
 }
 
-static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_set_disassoc(struct mac80211_sub_if_data *sdata,
 				   bool remove_sta, bool tx)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1112,7 +1112,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
 }
 
-void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_rx_notify(struct mac80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr)
 {
 	/*
@@ -1129,7 +1129,7 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_reset_ap_probe(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
@@ -1158,7 +1158,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 				   IEEE80211_CONNECTION_IDLE_TIME));
 }
 
-void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_tx_notify(struct mac80211_sub_if_data *sdata,
 			     struct ieee80211_hdr *hdr, bool ack)
 {
 	if (!ieee80211_is_data(hdr->frame_control))
@@ -1177,7 +1177,7 @@ void ieee80211_sta_tx_notify(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_mgd_probe_ap_send(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	const u8 *ssid;
@@ -1212,7 +1212,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	run_again(ifmgd, ifmgd->probe_timeout);
 }
 
-static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_mgd_probe_ap(struct mac80211_sub_if_data *sdata,
 				   bool beacon)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1274,7 +1274,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 					  struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	const u8 *ssid;
@@ -1295,7 +1295,7 @@ struct sk_buff *ieee80211_ap_probereq_get(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 
-static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
+static void __ieee80211_connection_loss(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
@@ -1330,8 +1330,8 @@ static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
+	struct mac80211_sub_if_data *sdata =
+		container_of(work, struct mac80211_sub_if_data,
 			     u.mgd.beacon_connection_loss_work);
 
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
@@ -1342,7 +1342,7 @@ void ieee80211_beacon_connection_loss_work(struct work_struct *work)
 
 void ieee80211_beacon_loss(struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_hw *hw = &sdata->local->hw;
 
 	trace_api_beacon_loss(sdata);
@@ -1354,7 +1354,7 @@ EXPORT_SYMBOL(ieee80211_beacon_loss);
 
 void ieee80211_connection_loss(struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_hw *hw = &sdata->local->hw;
 
 	trace_api_connection_loss(sdata);
@@ -1366,7 +1366,7 @@ EXPORT_SYMBOL(ieee80211_connection_loss);
 
 
 static enum rx_mgmt_action __must_check
-ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
+ieee80211_rx_mgmt_deauth(struct mac80211_sub_if_data *sdata,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1395,7 +1395,7 @@ ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 
 
 static enum rx_mgmt_action __must_check
-ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
+ieee80211_rx_mgmt_disassoc(struct mac80211_sub_if_data *sdata,
 			   struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -1428,7 +1428,7 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
 static bool ieee80211_assoc_success(struct mac80211_work *wk,
 				    struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
@@ -1593,7 +1593,7 @@ static bool ieee80211_assoc_success(struct mac80211_work *wk,
 }
 
 
-static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_bss_info(struct mac80211_sub_if_data *sdata,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len,
 				  struct ieee80211_rx_status *rx_status,
@@ -1648,7 +1648,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 }
 
 
-static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_mgmt_probe_resp(struct mac80211_sub_if_data *sdata,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *)skb->data;
@@ -1699,7 +1699,7 @@ static const u64 care_about_ies =
 	(1ULL << WLAN_EID_HT_CAPABILITY) |
 	(1ULL << WLAN_EID_HT_INFORMATION);
 
-static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_rx_mgmt_beacon(struct mac80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len,
 				     struct ieee80211_rx_status *rx_status)
@@ -1894,7 +1894,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
-void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_rx_queued_mgmt(struct mac80211_sub_if_data *sdata,
 				  struct sk_buff *skb)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -2000,8 +2000,8 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 static void ieee80211_sta_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 
@@ -2013,7 +2013,7 @@ static void ieee80211_sta_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
-static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_sta_connection_lost(struct mac80211_sub_if_data *sdata,
 					  u8 *bssid)
 {
 	struct mac80211_local *local = sdata->local;
@@ -2038,7 +2038,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 	mutex_lock(&ifmgd->mtx);
 }
 
-void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_work(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -2122,8 +2122,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing)
@@ -2135,8 +2135,8 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 
 static void ieee80211_sta_conn_mon_timer(unsigned long data)
 {
-	struct ieee80211_sub_if_data *sdata =
-		(struct ieee80211_sub_if_data *) data;
+	struct mac80211_sub_if_data *sdata =
+		(struct mac80211_sub_if_data *) data;
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct mac80211_local *local = sdata->local;
 
@@ -2148,14 +2148,14 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 
 static void ieee80211_sta_monitor_work(struct work_struct *work)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data,
+	struct mac80211_sub_if_data *sdata =
+		container_of(work, struct mac80211_sub_if_data,
 			     u.mgd.monitor_work);
 
 	ieee80211_mgd_probe_ap(sdata, false);
 }
 
-static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_restart_sta_timer(struct mac80211_sub_if_data *sdata)
 {
 	if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 		sdata->u.mgd.flags &= ~(MAC80211_STA_BEACON_POLL |
@@ -2170,7 +2170,7 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 }
 
 #ifdef CONFIG_PM
-void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_quiesce(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
@@ -2196,7 +2196,7 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
 	del_timer_sync(&ifmgd->bcn_mon_timer);
 }
 
-void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_restart(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
 
@@ -2210,7 +2210,7 @@ void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata)
 #endif
 
 /* interface setup */
-void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
+void ieee80211_sta_setup_sdata(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_if_managed *ifmgd;
 
@@ -2242,7 +2242,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 /* scan finished notification */
 void ieee80211_mlme_notify_scan_completed(struct mac80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct mac80211_sub_if_data *sdata = local->scan_sdata;
 
 	/* Restart STA timers */
 	rcu_read_lock();
@@ -2290,7 +2290,7 @@ ieee80211_probe_auth_done(struct mac80211_work *wk,
 	return WORK_DONE_REQUEUE;
 }
 
-int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_auth(struct mac80211_sub_if_data *sdata,
 		       struct cfg80211_auth_request *req)
 {
 	const u8 *ssid;
@@ -2403,7 +2403,7 @@ static enum work_done_result ieee80211_assoc_done(struct mac80211_work *wk,
 	return WORK_DONE_DESTROY;
 }
 
-int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_assoc(struct mac80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req)
 {
 	struct mac80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -2528,7 +2528,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_deauth(struct mac80211_sub_if_data *sdata,
 			 struct cfg80211_deauth_request *req,
 			 void *cookie)
 {
@@ -2601,7 +2601,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
+int ieee80211_mgd_disassoc(struct mac80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req,
 			   void *cookie)
 {
@@ -2645,7 +2645,7 @@ void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
 			       enum nl80211_cqm_rssi_threshold_event rssi_event,
 			       gfp_t gfp)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct mac80211_sub_if_data *sdata = vif_to_sdata(vif);
 
 	trace_api_cqm_rssi_notify(sdata, rssi_event);
 
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 0c97ef7..5473d79 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -23,7 +23,7 @@
  * because we *may* be doing work on-operating channel, and want our
  * hardware unconditionally awake, but still let the AP send us normal frames.
  */
-static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_offchannel_ps_enable(struct mac80211_sub_if_data *sdata,
 					   bool tell_ap)
 {
 	struct mac80211_local *local = sdata->local;
@@ -61,7 +61,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
 }
 
 /* inform AP that we are awake again, unless power save is enabled */
-static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
+static void ieee80211_offchannel_ps_disable(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 
@@ -105,7 +105,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 void ieee80211_offchannel_stop_vifs(struct mac80211_local *local,
 				    bool offchannel_ps_enable)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	/*
 	 * notify the AP about us leaving the channel and stop all
@@ -140,7 +140,7 @@ void ieee80211_offchannel_stop_vifs(struct mac80211_local *local,
 void ieee80211_offchannel_enable_all_ps(struct mac80211_local *local,
 					bool tell_ap)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -158,7 +158,7 @@ void ieee80211_offchannel_return(struct mac80211_local *local,
 				 bool enable_beaconing,
 				 bool offchannel_ps_disable)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
@@ -202,7 +202,7 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 {
 	struct mac80211_local *local =
 		container_of(work, struct mac80211_local, hw_roc_start);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	mutex_lock(&local->mtx);
 
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index bfc9cf3..47505f0 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -9,7 +9,7 @@
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
 	ieee80211_scan_cancel(local);
@@ -68,7 +68,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
+					     struct mac80211_sub_if_data,
 					     u.ap);
 
 			drv_sta_remove(local, sdata, &sta->sta);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 1b2eacf..5384bba 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -295,7 +295,7 @@ static void rate_idx_match_mask(struct ieee80211_tx_rate *rate,
 	 */
 }
 
-void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
+void rate_control_get_rate(struct mac80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc)
 {
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 5693817..64399a7 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -26,7 +26,7 @@ struct rate_control_ref {
 	struct kref kref;
 };
 
-void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
+void rate_control_get_rate(struct mac80211_sub_if_data *sdata,
 			   struct sta_info *sta,
 			   struct ieee80211_tx_rate_control *txrc);
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d4c83cb..be041e5 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -220,7 +220,7 @@ ieee80211_rx_monitor(struct mac80211_local *local, struct sk_buff *origskb,
 		     struct ieee80211_rate *rate)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(origskb);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	int needed_headroom = 0;
 	struct sk_buff *skb, *skb2;
 	struct net_device *prev_dev = NULL;
@@ -936,7 +936,7 @@ ieee80211_rx_h_decrypt(struct mac80211_rx_data *rx)
 		 * have been expected.
 		 */
 		struct ieee80211_key *key = NULL;
-		struct ieee80211_sub_if_data *sdata = rx->sdata;
+		struct mac80211_sub_if_data *sdata = rx->sdata;
 		int i;
 
 		if (ieee80211_is_mgmt(fc) &&
@@ -1091,7 +1091,7 @@ ieee80211_rx_h_check_more_data(struct mac80211_rx_data *rx)
 
 static void ap_sta_ps_start(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct mac80211_local *local = sdata->local;
 
 	atomic_inc(&sdata->bss->num_sta_ps);
@@ -1106,7 +1106,7 @@ static void ap_sta_ps_start(struct sta_info *sta)
 
 static void ap_sta_ps_end(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 
 	atomic_dec(&sdata->bss->num_sta_ps);
 
@@ -1255,7 +1255,7 @@ ieee80211_rx_h_sta_process(struct mac80211_rx_data *rx)
 } /* ieee80211_rx_h_sta_process */
 
 static inline struct mac80211_fragment_entry *
-ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
+ieee80211_reassemble_add(struct mac80211_sub_if_data *sdata,
 			 unsigned int frag, unsigned int seq, int rx_queue,
 			 struct sk_buff **skb)
 {
@@ -1294,7 +1294,7 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 }
 
 static inline struct mac80211_fragment_entry *
-ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
+ieee80211_reassemble_find(struct mac80211_sub_if_data *sdata,
 			  unsigned int frag, unsigned int seq,
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
@@ -1461,7 +1461,7 @@ ieee80211_rx_h_defragment(struct mac80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ps_poll(struct mac80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	__le16 fc = ((struct ieee80211_hdr *)rx->skb->data)->frame_control;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
@@ -1594,7 +1594,7 @@ ieee80211_drop_unencrypted_mgmt(struct mac80211_rx_data *rx)
 static int
 __ieee80211_data_to_8023(struct mac80211_rx_data *rx, bool *port_control)
 {
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	bool check_port_control = false;
 	struct ethhdr *ehdr;
@@ -1662,7 +1662,7 @@ static bool ieee80211_frame_allowed(struct mac80211_rx_data *rx, __le16 fc)
 static void
 ieee80211_deliver_skb(struct mac80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct net_device *dev = sdata->dev;
 	struct sk_buff *skb, *xmit_skb;
 	struct ethhdr *ehdr = (struct ethhdr *) rx->skb->data;
@@ -1810,7 +1810,7 @@ ieee80211_rx_h_mesh_fwding(struct mac80211_rx_data *rx)
 	unsigned int hdrlen;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
 	struct mac80211_local *local = rx->local;
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
 	hdr = (struct ieee80211_hdr *) skb->data;
@@ -1921,7 +1921,7 @@ ieee80211_rx_h_mesh_fwding(struct mac80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct mac80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct mac80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
@@ -1952,7 +1952,7 @@ ieee80211_rx_h_data(struct mac80211_rx_data *rx)
 
 	if (rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
 	    unlikely(port_control) && sdata->bss) {
-		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
+		sdata = container_of(sdata->bss, struct mac80211_sub_if_data,
 				     u.ap);
 		dev = sdata->dev;
 		rx->sdata = sdata;
@@ -2033,7 +2033,7 @@ ieee80211_rx_h_ctrl(struct mac80211_rx_data *rx)
 	return RX_DROP_MONITOR;
 }
 
-static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_process_sa_query_req(struct mac80211_sub_if_data *sdata,
 					   struct ieee80211_mgmt *mgmt,
 					   size_t len)
 {
@@ -2109,7 +2109,7 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_action(struct mac80211_rx_data *rx)
 {
 	struct mac80211_local *local = rx->local;
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	int len = rx->skb->len;
@@ -2277,7 +2277,7 @@ ieee80211_rx_h_action_return(struct mac80211_rx_data *rx)
 	struct mac80211_local *local = rx->local;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct sk_buff *nskb;
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	if (!ieee80211_is_action(mgmt->frame_control))
@@ -2322,7 +2322,7 @@ ieee80211_rx_h_action_return(struct mac80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_mgmt(struct mac80211_rx_data *rx)
 {
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	ieee80211_rx_result rxs;
 	struct ieee80211_mgmt *mgmt = (void *)rx->skb->data;
 	__le16 stype;
@@ -2377,7 +2377,7 @@ ieee80211_rx_h_mgmt(struct mac80211_rx_data *rx)
 static void ieee80211_rx_cooked_monitor(struct mac80211_rx_data *rx,
 					struct ieee80211_rate *rate)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_local *local = rx->local;
 	struct ieee80211_rtap_hdr {
 		struct ieee80211_radiotap_header hdr;
@@ -2611,7 +2611,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 static int prepare_for_handlers(struct mac80211_rx_data *rx,
 				struct ieee80211_hdr *hdr)
 {
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	u8 *bssid = ieee80211_get_bssid(hdr, skb->len, sdata->vif.type);
@@ -2704,7 +2704,7 @@ static bool ieee80211_prepare_and_rx_handle(struct mac80211_rx_data *rx,
 					    struct sk_buff *skb, bool consume)
 {
 	struct mac80211_local *local = rx->local;
-	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct mac80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	int prepares;
@@ -2742,11 +2742,11 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
 	struct mac80211_rx_data rx;
-	struct ieee80211_sub_if_data *prev;
+	struct mac80211_sub_if_data *prev;
 	struct sta_info *sta, *tmp, *prev_sta;
 	int err = 0;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7c3d17b..284e0cb 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -147,7 +147,7 @@ ieee80211_bss_info_update(struct mac80211_local *local,
 }
 
 ieee80211_rx_result
-ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+ieee80211_scan_rx(struct mac80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_mgmt *mgmt;
@@ -378,7 +378,7 @@ static int ieee80211_start_sw_scan(struct mac80211_local *local)
 }
 
 
-static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
+static int __ieee80211_start_scan(struct mac80211_sub_if_data *sdata,
 				  struct cfg80211_scan_request *req)
 {
 	struct mac80211_local *local = sdata->local;
@@ -475,7 +475,7 @@ static void ieee80211_scan_state_decision(struct mac80211_local *local,
 	bool bad_latency;
 	bool listen_int_exceeded;
 	unsigned long min_beacon_int = 0;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
 
 	/*
@@ -651,7 +651,7 @@ static void ieee80211_scan_state_send_probe(struct mac80211_local *local,
 					    unsigned long *next_delay)
 {
 	int i;
-	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
+	struct mac80211_sub_if_data *sdata = local->scan_sdata;
 
 	for (i = 0; i < local->scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
@@ -672,7 +672,7 @@ void ieee80211_scan_work(struct work_struct *work)
 {
 	struct mac80211_local *local =
 		container_of(work, struct mac80211_local, scan_work.work);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	unsigned long next_delay = 0;
 	bool aborted, hw_scan;
 
@@ -757,7 +757,7 @@ out:
 	mutex_unlock(&local->mtx);
 }
 
-int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
+int ieee80211_request_scan(struct mac80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req)
 {
 	int res;
@@ -769,7 +769,7 @@ int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 	return res;
 }
 
-int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
+int ieee80211_request_internal_scan(struct mac80211_sub_if_data *sdata,
 				    const u8 *ssid, u8 ssid_len,
 				    struct ieee80211_channel *chan)
 {
@@ -856,7 +856,7 @@ void ieee80211_scan_cancel(struct mac80211_local *local)
 	mutex_unlock(&local->mtx);
 }
 
-int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
+int ieee80211_request_sched_scan_start(struct mac80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req)
 {
 	struct mac80211_local *local = sdata->local;
@@ -906,7 +906,7 @@ out:
 	return ret;
 }
 
-int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
+int ieee80211_request_sched_scan_stop(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	int ret = 0, i;
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index fe1e76d..0c9ad56 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -21,7 +21,7 @@
 #include "sta_info.h"
 #include "wme.h"
 
-static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_send_refuse_measurement_request(struct mac80211_sub_if_data *sdata,
 					struct ieee80211_msrment_ie *request_ie,
 					const u8 *da, const u8 *bssid,
 					u8 dialog_token)
@@ -68,7 +68,7 @@ static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_da
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
+void ieee80211_process_measurement_req(struct mac80211_sub_if_data *sdata,
 				       struct ieee80211_mgmt *mgmt,
 				       size_t len)
 {
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index d148159..a6b187d 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -90,7 +90,7 @@ static int sta_info_hash_del(struct mac80211_local *local,
 }
 
 /* protected by RCU */
-struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_get(struct mac80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
 	struct mac80211_local *local = sdata->local;
@@ -116,7 +116,7 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
  * Get sta info either from the specified interface
  * or from one of its vlans
  */
-struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_get_bss(struct mac80211_sub_if_data *sdata,
 				  const u8 *addr)
 {
 	struct mac80211_local *local = sdata->local;
@@ -139,7 +139,7 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 	return sta;
 }
 
-struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_get_by_idx(struct mac80211_sub_if_data *sdata,
 				     int idx)
 {
 	struct mac80211_local *local = sdata->local;
@@ -226,7 +226,7 @@ static int sta_prepare_rate_control(struct mac80211_local *local,
 	return 0;
 }
 
-struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_alloc(struct mac80211_sub_if_data *sdata,
 				u8 *addr, gfp_t gfp)
 {
 	struct mac80211_local *local = sdata->local;
@@ -287,7 +287,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 static int sta_info_finish_insert(struct sta_info *sta, bool async)
 {
 	struct mac80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct station_info sinfo;
 	unsigned long flags;
 	int err = 0;
@@ -297,7 +297,7 @@ static int sta_info_finish_insert(struct sta_info *sta, bool async)
 	/* notify driver */
 	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		sdata = container_of(sdata->bss,
-				     struct ieee80211_sub_if_data,
+				     struct mac80211_sub_if_data,
 				     u.ap);
 	err = drv_sta_add(local, sdata, &sta->sta);
 	if (err) {
@@ -374,7 +374,7 @@ static void sta_info_finish_work(struct work_struct *work)
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 {
 	struct mac80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	unsigned long flags;
 	int err = 0;
 
@@ -624,7 +624,7 @@ static bool sta_info_cleanup_expire_buffered(struct mac80211_local *local,
 static int __must_check __sta_info_destroy(struct sta_info *sta)
 {
 	struct mac80211_local *local;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sk_buff *skb;
 	unsigned long flags;
 	int ret, i;
@@ -681,7 +681,7 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	if (sta->uploaded) {
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
+					     struct mac80211_sub_if_data,
 					     u.ap);
 		drv_sta_remove(local, sdata, &sta->sta);
 		sdata = sta->sdata;
@@ -730,7 +730,7 @@ static int __must_check __sta_info_destroy(struct sta_info *sta)
 	return 0;
 }
 
-int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata, const u8 *addr)
+int sta_info_destroy_addr(struct mac80211_sub_if_data *sdata, const u8 *addr)
 {
 	struct sta_info *sta;
 	int ret;
@@ -743,7 +743,7 @@ int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata, const u8 *addr)
 	return ret;
 }
 
-int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
+int sta_info_destroy_addr_bss(struct mac80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
 	struct sta_info *sta;
@@ -806,7 +806,7 @@ void sta_info_stop(struct mac80211_local *local)
  * @sdata: matching rule for the net device (sta->dev) or %NULL to match all STAs
  */
 int sta_info_flush(struct mac80211_local *local,
-		   struct ieee80211_sub_if_data *sdata)
+		   struct mac80211_sub_if_data *sdata)
 {
 	struct sta_info *sta, *tmp;
 	int ret = 0;
@@ -826,7 +826,7 @@ int sta_info_flush(struct mac80211_local *local,
 	return ret;
 }
 
-void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_expire(struct mac80211_sub_if_data *sdata,
 			  unsigned long exp_time)
 {
 	struct mac80211_local *local = sdata->local;
@@ -896,7 +896,7 @@ static void clear_sta_ps_flags(void *_sta)
 /* powersave support code */
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct mac80211_local *local = sdata->local;
 	int sent, buffered;
 
@@ -923,7 +923,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta)
 {
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	int no_pending_pkts;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 3623a2d..16c54cc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -248,7 +248,7 @@ struct sta_info {
 	struct list_head list;
 	struct sta_info __rcu *hnext;
 	struct mac80211_local *local;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *ptk;
 	struct rate_control_ref *rate_ctrl;
@@ -432,10 +432,10 @@ rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
 /*
  * Get a STA info, must be under RCU read lock.
  */
-struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_get(struct mac80211_sub_if_data *sdata,
 			      const u8 *addr);
 
-struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_get_bss(struct mac80211_sub_if_data *sdata,
 				  const u8 *addr);
 
 static inline
@@ -464,13 +464,13 @@ void for_each_sta_info_type_check(struct mac80211_local *local,
 /*
  * Get STA info by index, BROKEN!
  */
-struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_get_by_idx(struct mac80211_sub_if_data *sdata,
 				     int idx);
 /*
  * Create a new STA info, caller owns returned structure
  * until sta_info_insert().
  */
-struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
+struct sta_info *sta_info_alloc(struct mac80211_sub_if_data *sdata,
 				u8 *addr, gfp_t gfp);
 /*
  * Insert STA info into hash table/list, returns zero or a
@@ -484,9 +484,9 @@ int sta_info_insert(struct sta_info *sta);
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU);
 int sta_info_insert_atomic(struct sta_info *sta);
 
-int sta_info_destroy_addr(struct ieee80211_sub_if_data *sdata,
+int sta_info_destroy_addr(struct mac80211_sub_if_data *sdata,
 			  const u8 *addr);
-int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
+int sta_info_destroy_addr_bss(struct mac80211_sub_if_data *sdata,
 			      const u8 *addr);
 
 void sta_info_set_tim_bit(struct sta_info *sta);
@@ -495,8 +495,8 @@ void sta_info_clear_tim_bit(struct sta_info *sta);
 void sta_info_init(struct mac80211_local *local);
 void sta_info_stop(struct mac80211_local *local);
 int sta_info_flush(struct mac80211_local *local,
-		   struct ieee80211_sub_if_data *sdata);
-void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
+		   struct mac80211_sub_if_data *sdata);
+void ieee80211_sta_expire(struct mac80211_sub_if_data *sdata,
 			  unsigned long exp_time);
 
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 464cec7..41fe6ed 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -131,7 +131,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
 	struct mac80211_local *local = sta->local;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct mac80211_sub_if_data *sdata = sta->sdata;
 
 	if (ieee80211_is_action(mgmt->frame_control) &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION &&
@@ -180,7 +180,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	__le16 fc;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct net_device *prev_dev = NULL;
 	struct sta_info *sta, *tmp;
 	int retry_count = -1, i;
diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
index 757e4eb..26f866e 100644
--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -304,11 +304,11 @@ int ieee80211_tkip_decrypt_data(struct crypto_cipher *tfm,
 	if (key->local->ops->update_tkip_key &&
 	    key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE &&
 	    key->u.tkip.rx[queue].state != TKIP_STATE_PHASE1_HW_UPLOADED) {
-		struct ieee80211_sub_if_data *sdata = key->sdata;
+		struct mac80211_sub_if_data *sdata = key->sdata;
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			sdata = container_of(key->sdata->bss,
-					struct ieee80211_sub_if_data, u.ap);
+					struct mac80211_sub_if_data, u.ap);
 		drv_update_tkip_key(key->local, sdata, &key->conf, key->sta,
 				iv32, key->u.tkip.rx[queue].p1k);
 		key->u.tkip.rx[queue].state = TKIP_STATE_PHASE1_HW_UPLOADED;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ab8a71f..e43e34b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -322,7 +322,7 @@ static void purge_old_ps_buffers(struct mac80211_local *local)
 {
 	int total = 0, purged = 0;
 	struct sk_buff *skb;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
 	/*
@@ -1173,7 +1173,7 @@ static bool ieee80211_tx_prep_agg(struct mac80211_tx_data *tx,
  * initialises @tx
  */
 static ieee80211_tx_result
-ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
+ieee80211_tx_prepare(struct mac80211_sub_if_data *sdata,
 		     struct mac80211_tx_data *tx,
 		     struct sk_buff *skb)
 {
@@ -1290,7 +1290,7 @@ static bool __ieee80211_tx(struct mac80211_local *local, struct sk_buff **skbp,
 {
 	struct sk_buff *skb = *skbp, *next;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	unsigned long flags;
 	int len;
 	bool fragm = false;
@@ -1352,7 +1352,7 @@ static bool __ieee80211_tx(struct mac80211_local *local, struct sk_buff **skbp,
 			break;
 		case NL80211_IFTYPE_AP_VLAN:
 			info->control.vif = &container_of(sdata->bss,
-				struct ieee80211_sub_if_data, u.ap)->vif;
+				struct mac80211_sub_if_data, u.ap)->vif;
 			break;
 		default:
 			/* keep */
@@ -1436,7 +1436,7 @@ static int invoke_tx_handlers(struct mac80211_tx_data *tx)
 /*
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
-static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
+static bool ieee80211_tx(struct mac80211_sub_if_data *sdata,
 			 struct sk_buff *skb, bool txpending)
 {
 	struct mac80211_local *local = sdata->local;
@@ -1515,13 +1515,13 @@ static int ieee80211_skb_resize(struct mac80211_local *local,
 	return 0;
 }
 
-static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_xmit(struct mac80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_sub_if_data *tmp_sdata;
+	struct mac80211_sub_if_data *tmp_sdata;
 	int headroom;
 	bool may_encrypt;
 
@@ -1691,7 +1691,7 @@ fail:
 netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct mac80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
 	int ret = NETDEV_TX_BUSY, head_need;
@@ -2026,7 +2026,7 @@ static bool ieee80211_tx_pending_skb(struct mac80211_local *local,
 				     struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_hdr *hdr;
 	bool result;
@@ -2051,7 +2051,7 @@ static bool ieee80211_tx_pending_skb(struct mac80211_local *local,
 void ieee80211_tx_pending(unsigned long data)
 {
 	struct mac80211_local *local = (struct mac80211_local *)data;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	unsigned long flags;
 	int i;
 	bool txok;
@@ -2169,7 +2169,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	struct mac80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_sub_if_data *sdata = NULL;
+	struct mac80211_sub_if_data *sdata = NULL;
 	struct mac80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
@@ -2322,7 +2322,7 @@ EXPORT_SYMBOL(ieee80211_beacon_get_tim);
 struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_if_managed *ifmgd;
 	struct ieee80211_pspoll *pspoll;
 	struct mac80211_local *local;
@@ -2363,7 +2363,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif)
 {
 	struct ieee80211_hdr_3addr *nullfunc;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_if_managed *ifmgd;
 	struct mac80211_local *local;
 	struct sk_buff *skb;
@@ -2402,7 +2402,7 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 				       const u8 *ssid, size_t ssid_len,
 				       const u8 *ie, size_t ie_len)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_local *local;
 	struct ieee80211_hdr_3addr *hdr;
 	struct sk_buff *skb;
@@ -2485,7 +2485,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	struct mac80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct mac80211_tx_data tx;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct mac80211_if_ap *bss = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_tx_info *info;
@@ -2538,7 +2538,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_get_buffered_bc);
 
-void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
+void ieee80211_tx_skb(struct mac80211_sub_if_data *sdata, struct sk_buff *skb)
 {
 	skb_set_mac_header(skb, 0);
 	skb_set_network_header(skb, 0);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3766f2e..7e1514c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -165,7 +165,7 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					struct ieee80211_rate *rate)
 {
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	u16 dur;
 	int erp;
 	bool short_preamble = false;
@@ -191,7 +191,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	bool short_preamble;
 	int erp;
 	u16 dur;
@@ -232,7 +232,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 {
 	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	bool short_preamble;
 	int erp;
 	u16 dur;
@@ -268,7 +268,7 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	trace_wake_queue(local, queue, reason);
 
@@ -315,7 +315,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason)
 {
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	trace_stop_queue(local, queue, reason);
 
@@ -478,7 +478,7 @@ void ieee80211_iterate_active_interfaces(
 	void *data)
 {
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
 
@@ -506,7 +506,7 @@ void ieee80211_iterate_active_interfaces_atomic(
 	void *data)
 {
 	struct mac80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 
 	rcu_read_lock();
 
@@ -739,7 +739,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 	return crc;
 }
 
-void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
+void ieee80211_set_wmm_default(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
@@ -812,7 +812,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
+void ieee80211_sta_def_wmm_params(struct mac80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates)
 {
@@ -861,7 +861,7 @@ u32 ieee80211_mandatory_rates(struct mac80211_local *local,
 	return mandatory_rates;
 }
 
-void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
+void ieee80211_send_auth(struct mac80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *key, u8 key_len, u8 key_idx)
@@ -1015,7 +1015,7 @@ int ieee80211_build_preq_ies(struct mac80211_local *local, u8 *buffer,
 	return pos - buffer;
 }
 
-struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
+struct sk_buff *ieee80211_build_probe_req(struct mac80211_sub_if_data *sdata,
 					  u8 *dst,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len)
@@ -1060,7 +1060,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 	return skb;
 }
 
-void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
+void ieee80211_send_probe_req(struct mac80211_sub_if_data *sdata, u8 *dst,
 			      const u8 *ssid, size_t ssid_len,
 			      const u8 *ie, size_t ie_len)
 {
@@ -1121,7 +1121,7 @@ void ieee80211_stop_device(struct mac80211_local *local)
 int ieee80211_reconfig(struct mac80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	int res;
 
@@ -1182,7 +1182,7 @@ int ieee80211_reconfig(struct mac80211_local *local)
 			sdata = sta->sdata;
 			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 				sdata = container_of(sdata->bss,
-					     struct ieee80211_sub_if_data,
+					     struct mac80211_sub_if_data,
 					     u.ap);
 
 			WARN_ON(drv_sta_add(local, sdata, &sta->sta));
@@ -1343,7 +1343,7 @@ static int check_mgd_smps(struct mac80211_if_managed *ifmgd,
 /* must hold iflist_mtx */
 void ieee80211_recalc_smps(struct mac80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata;
+	struct mac80211_sub_if_data *sdata;
 	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_OFF;
 	int count = 0;
 
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index e20a843..4311c5d 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -54,7 +54,7 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 
 
 /* Indicate which queue to use. */
-u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
+u16 ieee80211_select_queue(struct mac80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
 	struct mac80211_local *local = sdata->local;
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 77a8e8d..e2007e4 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -20,7 +20,7 @@
 
 extern const int ieee802_1d_to_ac[8];
 
-u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
+u16 ieee80211_select_queue(struct mac80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
 void ieee80211_set_qos_hdr(struct mac80211_local *local, struct sk_buff *skb);
 u16 ieee80211_downgrade_queue(struct mac80211_local *local,
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 197704a..4765329 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -183,7 +183,7 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	pos += sizeof(u8);
 }
 
-static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
+static void ieee80211_send_assoc(struct mac80211_sub_if_data *sdata,
 				 struct mac80211_work *wk)
 {
 	struct mac80211_local *local = sdata->local;
@@ -424,7 +424,7 @@ static void ieee80211_remove_auth_bss(struct mac80211_local *local,
 static enum work_action __must_check
 ieee80211_direct_probe(struct mac80211_work *wk)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
 
 	wk->probe_auth.tries++;
@@ -462,7 +462,7 @@ ieee80211_direct_probe(struct mac80211_work *wk)
 static enum work_action __must_check
 ieee80211_authenticate(struct mac80211_work *wk)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
 
 	wk->probe_auth.tries++;
@@ -495,7 +495,7 @@ ieee80211_authenticate(struct mac80211_work *wk)
 static enum work_action __must_check
 ieee80211_associate(struct mac80211_work *wk)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
 
 	wk->assoc.tries++;
@@ -583,7 +583,7 @@ static void ieee80211_auth_challenge(struct mac80211_work *wk,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	u8 *pos;
 	struct ieee802_11_elems elems;
 
@@ -650,7 +650,7 @@ ieee80211_rx_mgmt_assoc_resp(struct mac80211_work *wk,
 			     struct ieee80211_mgmt *mgmt, size_t len,
 			     bool reassoc)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
@@ -708,7 +708,7 @@ ieee80211_rx_mgmt_probe_resp(struct mac80211_work *wk,
 			     struct ieee80211_mgmt *mgmt, size_t len,
 			     struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
 	size_t baselen;
 
@@ -732,7 +732,7 @@ static enum work_action __must_check
 ieee80211_rx_mgmt_beacon(struct mac80211_work *wk,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
-	struct ieee80211_sub_if_data *sdata = wk->sdata;
+	struct mac80211_sub_if_data *sdata = wk->sdata;
 	struct mac80211_local *local = sdata->local;
 
 	ASSERT_WORK_MTX(local);
@@ -1144,7 +1144,7 @@ void ieee80211_work_init(struct mac80211_local *local)
 	skb_queue_head_init(&local->work_skb_queue);
 }
 
-void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
+void ieee80211_work_purge(struct mac80211_sub_if_data *sdata)
 {
 	struct mac80211_local *local = sdata->local;
 	struct mac80211_work *wk;
@@ -1175,7 +1175,7 @@ void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->mtx);
 }
 
-ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
+ieee80211_rx_result ieee80211_work_rx_mgmt(struct mac80211_sub_if_data *sdata,
 					   struct sk_buff *skb)
 {
 	struct mac80211_local *local = sdata->local;
@@ -1225,7 +1225,7 @@ static enum work_done_result ieee80211_remain_done(struct mac80211_work *wk,
 	return WORK_DONE_DESTROY;
 }
 
-int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
+int ieee80211_wk_remain_on_channel(struct mac80211_sub_if_data *sdata,
 				   struct ieee80211_channel *chan,
 				   enum nl80211_channel_type channel_type,
 				   unsigned int duration, u64 *cookie)
@@ -1251,7 +1251,7 @@ int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-int ieee80211_wk_cancel_remain_on_channel(struct ieee80211_sub_if_data *sdata,
+int ieee80211_wk_cancel_remain_on_channel(struct mac80211_sub_if_data *sdata,
 					  u64 cookie)
 {
 	struct mac80211_local *local = sdata->local;

