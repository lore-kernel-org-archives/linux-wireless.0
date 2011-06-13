Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:36307 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1FMWff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 18:35:35 -0400
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 3E448C7C7D
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:33 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-184-248.elisa-laajakaista.fi [88.115.184.248])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id D582041BE2
	for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 01:35:29 +0300 (EEST)
Subject: [PATCH v2 07/27] mac80211: rename ieee80211_local to mac80211_local
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 14 Jun 2011 01:35:28 +0300
Message-ID: <20110613223528.10517.73584.stgit@localhost6.localdomain6> (sfid-20110614_003540_579233_7609B327)
In-Reply-To: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
References: <20110613223029.10517.52197.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@adurom.com>
---
 net/mac80211/agg-rx.c              |    6 +-
 net/mac80211/agg-tx.c              |   32 +++++----
 net/mac80211/cfg.c                 |   66 +++++++++----------
 net/mac80211/chan.c                |    6 +-
 net/mac80211/debugfs.c             |   30 ++++-----
 net/mac80211/debugfs.h             |    4 +
 net/mac80211/debugfs_netdev.c      |    4 +
 net/mac80211/driver-ops.h          |   96 ++++++++++++++-------------
 net/mac80211/driver-trace.h        |  126 ++++++++++++++++++------------------
 net/mac80211/ht.c                  |    4 +
 net/mac80211/ibss.c                |   18 +++--
 net/mac80211/iface.c               |   34 +++++-----
 net/mac80211/key.c                 |    4 +
 net/mac80211/key.h                 |    6 +-
 net/mac80211/led.c                 |   34 +++++-----
 net/mac80211/led.h                 |   36 +++++-----
 net/mac80211/mac80211_i.h          |   90 +++++++++++++-------------
 net/mac80211/main.c                |   48 +++++++-------
 net/mac80211/mesh.c                |   16 ++---
 net/mac80211/mesh.h                |    6 +-
 net/mac80211/mesh_hwmp.c           |   10 +--
 net/mac80211/mesh_pathtbl.c        |    4 +
 net/mac80211/mesh_plink.c          |    8 +-
 net/mac80211/mlme.c                |   64 +++++++++---------
 net/mac80211/offchannel.c          |   24 +++----
 net/mac80211/pm.c                  |    2 -
 net/mac80211/rate.c                |    6 +-
 net/mac80211/rate.h                |   12 ++-
 net/mac80211/rc80211_minstrel.c    |    4 +
 net/mac80211/rc80211_minstrel_ht.c |    2 -
 net/mac80211/rx.c                  |   40 ++++++-----
 net/mac80211/scan.c                |   46 +++++++------
 net/mac80211/spectmgmt.c           |    2 -
 net/mac80211/sta_info.c            |   44 ++++++-------
 net/mac80211/sta_info.h            |   10 +--
 net/mac80211/status.c              |    8 +-
 net/mac80211/tx.c                  |   42 ++++++------
 net/mac80211/util.c                |   60 +++++++++--------
 net/mac80211/wep.c                 |   14 ++--
 net/mac80211/wep.h                 |    6 +-
 net/mac80211/wme.c                 |    6 +-
 net/mac80211/wme.h                 |    4 +
 net/mac80211/work.c                |   38 +++++------
 43 files changed, 561 insertions(+), 561 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 3c13f42..bf234e5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -58,7 +58,7 @@ static void ieee80211_free_tid_rx(struct rcu_head *h)
 void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     u16 initiator, u16 reason, bool tx)
 {
-	struct ieee80211_local *local = sta->local;
+	struct mac80211_local *local = sta->local;
 	struct tid_ampdu_rx *tid_rx;
 
 	lockdep_assert_held(&sta->ampdu_mlme.mtx);
@@ -153,7 +153,7 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u16 capab;
@@ -196,7 +196,7 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_process_addba_request(struct ieee80211_local *local,
+void ieee80211_process_addba_request(struct mac80211_local *local,
 				     struct sta_info *sta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len)
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 54c7d85..a725f8a 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -61,7 +61,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 					 u8 dialog_token, u16 start_seq_num,
 					 u16 agg_size, u16 timeout)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u16 capab;
@@ -108,7 +108,7 @@ static void ieee80211_send_addba_request(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_send_bar(struct ieee80211_sub_if_data *sdata, u8 *ra, u16 tid, u16 ssn)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_bar *bar;
 	u16 bar_control = 0;
@@ -148,7 +148,7 @@ int ___ieee80211_stop_tx_ba_session(struct sta_info *sta, u16 tid,
 				    enum ieee80211_back_parties initiator,
 				    bool tx)
 {
-	struct ieee80211_local *local = sta->local;
+	struct mac80211_local *local = sta->local;
 	struct tid_ampdu_tx *tid_tx;
 	int ret;
 
@@ -261,7 +261,7 @@ static inline int ieee80211_ac_from_tid(int tid)
  * a global "agg_queue_stop" refcount.
  */
 static void __acquires(agg_queue)
-ieee80211_stop_queue_agg(struct ieee80211_local *local, int tid)
+ieee80211_stop_queue_agg(struct mac80211_local *local, int tid)
 {
 	int queue = ieee80211_ac_from_tid(tid);
 
@@ -273,7 +273,7 @@ ieee80211_stop_queue_agg(struct ieee80211_local *local, int tid)
 }
 
 static void __releases(agg_queue)
-ieee80211_wake_queue_agg(struct ieee80211_local *local, int tid)
+ieee80211_wake_queue_agg(struct mac80211_local *local, int tid)
 {
 	int queue = ieee80211_ac_from_tid(tid);
 
@@ -287,7 +287,7 @@ ieee80211_wake_queue_agg(struct ieee80211_local *local, int tid)
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 {
 	struct tid_ampdu_tx *tid_tx;
-	struct ieee80211_local *local = sta->local;
+	struct mac80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u16 start_seq_num;
 	int ret;
@@ -354,7 +354,7 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
 
@@ -456,7 +456,7 @@ EXPORT_SYMBOL(ieee80211_start_tx_ba_session);
  * requires a call to ieee80211_agg_splice_finish later
  */
 static void __acquires(agg_queue)
-ieee80211_agg_splice_packets(struct ieee80211_local *local,
+ieee80211_agg_splice_packets(struct mac80211_local *local,
 			     struct tid_ampdu_tx *tid_tx, u16 tid)
 {
 	int queue = ieee80211_ac_from_tid(tid);
@@ -478,12 +478,12 @@ ieee80211_agg_splice_packets(struct ieee80211_local *local,
 }
 
 static void __releases(agg_queue)
-ieee80211_agg_splice_finish(struct ieee80211_local *local, u16 tid)
+ieee80211_agg_splice_finish(struct mac80211_local *local, u16 tid)
 {
 	ieee80211_wake_queue_agg(local, tid);
 }
 
-static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
+static void ieee80211_agg_tx_operational(struct mac80211_local *local,
 					 struct sta_info *sta, u16 tid)
 {
 	struct tid_ampdu_tx *tid_tx;
@@ -521,7 +521,7 @@ static void ieee80211_agg_tx_operational(struct ieee80211_local *local,
 void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct tid_ampdu_tx *tid_tx;
 
@@ -570,7 +570,7 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				      const u8 *ra, u16 tid)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_ra_tid *ra_tid;
 	struct sk_buff *skb = dev_alloc_skb(0);
 
@@ -611,7 +611,7 @@ int ieee80211_stop_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid)
 {
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
 
@@ -649,7 +649,7 @@ EXPORT_SYMBOL(ieee80211_stop_tx_ba_session);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct tid_ampdu_tx *tid_tx;
 
@@ -723,7 +723,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 				     const u8 *ra, u16 tid)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_ra_tid *ra_tid;
 	struct sk_buff *skb = dev_alloc_skb(0);
 
@@ -746,7 +746,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_vif *vif,
 EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
 
 
-void ieee80211_process_addba_resp(struct ieee80211_local *local,
+void ieee80211_process_addba_resp(struct mac80211_local *local,
 				  struct sta_info *sta,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len)
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 5077013..936ad16 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -24,7 +24,7 @@ static struct net_device *ieee80211_add_iface(struct wiphy *wiphy, char *name,
 					      u32 *flags,
 					      struct vif_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct net_device *dev;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
@@ -68,7 +68,7 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		sdata->u.mgd.use_4addr = params->use_4addr;
 
 	if (sdata->vif.type == NL80211_IFTYPE_MONITOR && flags) {
-		struct ieee80211_local *local = sdata->local;
+		struct mac80211_local *local = sdata->local;
 
 		if (ieee80211_sdata_running(sdata)) {
 			/*
@@ -161,7 +161,7 @@ static int ieee80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 			     u8 key_idx, bool pairwise, const u8 *mac_addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct ieee80211_key *key = NULL;
 	int ret;
@@ -427,7 +427,7 @@ static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
 				 int idx, struct survey_info *survey)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	return drv_get_survey(local, idx, survey);
 }
@@ -643,7 +643,7 @@ static void ieee80211_send_layer2_update(struct sta_info *sta)
 	netif_rx_ni(skb);
 }
 
-static void sta_apply_parameters(struct ieee80211_local *local,
+static void sta_apply_parameters(struct mac80211_local *local,
 				 struct sta_info *sta,
 				 struct station_parameters *params)
 {
@@ -755,7 +755,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac, struct station_parameters *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	int err;
@@ -806,7 +806,7 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_del_station(struct wiphy *wiphy, struct net_device *dev,
 				 u8 *mac)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -824,7 +824,7 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 				    struct station_parameters *params)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *vlansdata;
 
@@ -1195,7 +1195,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (params->basic_rates) {
 		int i, j;
 		u32 rates = 0;
-		struct ieee80211_local *local = wiphy_priv(wiphy);
+		struct mac80211_local *local = wiphy_priv(wiphy);
 		struct ieee80211_supported_band *sband =
 			wiphy->bands[local->oper_channel->band];
 
@@ -1231,7 +1231,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 static int ieee80211_set_txq_params(struct wiphy *wiphy,
 				    struct ieee80211_txq_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_tx_queue_params p;
 
 	if (!local->ops->conf_tx)
@@ -1264,7 +1264,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 				 struct ieee80211_channel *chan,
 				 enum nl80211_channel_type channel_type)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_channel *old_oper;
 	enum nl80211_channel_type old_oper_type;
@@ -1388,7 +1388,7 @@ static int ieee80211_auth(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_assoc_request *req)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (ieee80211_get_channel_mode(local, sdata)) {
@@ -1424,7 +1424,7 @@ static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
 static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 			       struct cfg80211_ibss_params *params)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	switch (ieee80211_get_channel_mode(local, sdata)) {
@@ -1452,7 +1452,7 @@ static int ieee80211_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 
 static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	int err;
 
 	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
@@ -1490,7 +1490,7 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_channel *chan = local->hw.conf.channel;
 	u32 changes = 0;
 
@@ -1520,7 +1520,7 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 
 static int ieee80211_get_tx_power(struct wiphy *wiphy, int *dbm)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	*dbm = local->hw.conf.power_level;
 
@@ -1539,7 +1539,7 @@ static int ieee80211_set_wds_peer(struct wiphy *wiphy, struct net_device *dev,
 
 static void ieee80211_rfkill_poll(struct wiphy *wiphy)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	drv_rfkill_poll(local);
 }
@@ -1547,7 +1547,7 @@ static void ieee80211_rfkill_poll(struct wiphy *wiphy)
 #ifdef CONFIG_NL80211_TESTMODE
 static int ieee80211_testmode_cmd(struct wiphy *wiphy, void *data, int len)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	if (!local->ops->testmode_cmd)
 		return -EOPNOTSUPP;
@@ -1560,7 +1560,7 @@ static int ieee80211_testmode_dump(struct wiphy *wiphy,
 				   struct netlink_callback *cb,
 				   void *data, int len)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	if (!local->ops->testmode_dump)
 		return -EOPNOTSUPP;
@@ -1619,7 +1619,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 				    bool enabled, int timeout)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
@@ -1652,7 +1652,7 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 					 s32 rssi_thold, u32 rssi_hyst)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_vif *vif = &sdata->vif;
 	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
 
@@ -1682,7 +1682,7 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      const struct cfg80211_bitrate_mask *mask)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	int i, ret;
 
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) {
@@ -1697,7 +1697,7 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	return 0;
 }
 
-static int ieee80211_remain_on_channel_hw(struct ieee80211_local *local,
+static int ieee80211_remain_on_channel_hw(struct mac80211_local *local,
 					  struct net_device *dev,
 					  struct ieee80211_channel *chan,
 					  enum nl80211_channel_type chantype,
@@ -1736,7 +1736,7 @@ static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 				       u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->ops->remain_on_channel) {
 		int ret;
@@ -1755,7 +1755,7 @@ static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 					      duration, cookie);
 }
 
-static int ieee80211_cancel_remain_on_channel_hw(struct ieee80211_local *local,
+static int ieee80211_cancel_remain_on_channel_hw(struct mac80211_local *local,
 						 u64 cookie)
 {
 	int ret;
@@ -1782,7 +1782,7 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 					      u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->ops->cancel_remain_on_channel) {
 		int ret;
@@ -1826,7 +1826,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			     const u8 *buf, size_t len, u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
 	struct ieee80211_work *wk;
@@ -1995,7 +1995,7 @@ static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
 					 u64 cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_work *wk;
 	int ret = -ENOENT;
 
@@ -2053,7 +2053,7 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 					  struct net_device *dev,
 					  u16 frame_type, bool reg)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	if (frame_type != (IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_PROBE_REQ))
 		return;
@@ -2068,7 +2068,7 @@ static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
 
 static int ieee80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	if (local->started)
 		return -EOPNOTSUPP;
@@ -2078,14 +2078,14 @@ static int ieee80211_set_antenna(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant)
 
 static int ieee80211_get_antenna(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	return drv_get_antenna(local, tx_ant, rx_ant);
 }
 
 static int ieee80211_set_ringparam(struct wiphy *wiphy, u32 tx, u32 rx)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	return drv_set_ringparam(local, tx, rx);
 }
@@ -2093,7 +2093,7 @@ static int ieee80211_set_ringparam(struct wiphy *wiphy, u32 tx, u32 rx)
 static void ieee80211_get_ringparam(struct wiphy *wiphy,
 				    u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
 {
-	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct mac80211_local *local = wiphy_priv(wiphy);
 
 	drv_get_ringparam(local, tx, tx_max, rx, rx_max);
 }
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a412c4a..d2fe20d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -6,7 +6,7 @@
 #include "mac80211_i.h"
 
 static enum ieee80211_chan_mode
-__ieee80211_get_channel_mode(struct ieee80211_local *local,
+__ieee80211_get_channel_mode(struct mac80211_local *local,
 			     struct ieee80211_sub_if_data *ignore)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -45,7 +45,7 @@ __ieee80211_get_channel_mode(struct ieee80211_local *local,
 }
 
 enum ieee80211_chan_mode
-ieee80211_get_channel_mode(struct ieee80211_local *local,
+ieee80211_get_channel_mode(struct mac80211_local *local,
 			   struct ieee80211_sub_if_data *ignore)
 {
 	enum ieee80211_chan_mode mode;
@@ -57,7 +57,7 @@ ieee80211_get_channel_mode(struct ieee80211_local *local,
 	return mode;
 }
 
-bool ieee80211_set_channel_type(struct ieee80211_local *local,
+bool ieee80211_set_channel_type(struct mac80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype)
 {
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index e8bd10a..d5a07aa 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -41,7 +41,7 @@ int mac80211_format_buffer(char __user *userbuf, size_t count,
 static ssize_t name## _read(struct file *file, char __user *userbuf,	\
 			    size_t count, loff_t *ppos)			\
 {									\
-	struct ieee80211_local *local = file->private_data;		\
+	struct mac80211_local *local = file->private_data;		\
 									\
 	return mac80211_format_buffer(userbuf, count, ppos, 		\
 				      fmt "\n", ##value);		\
@@ -81,7 +81,7 @@ DEBUGFS_READONLY_FILE(rate_ctrl_alg, "%s",
 static ssize_t tsf_read(struct file *file, char __user *user_buf,
 			     size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	u64 tsf;
 
 	tsf = drv_get_tsf(local);
@@ -94,7 +94,7 @@ static ssize_t tsf_write(struct file *file,
                          const char __user *user_buf,
                          size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	unsigned long long tsf;
 	char buf[100];
 	size_t len;
@@ -132,7 +132,7 @@ static const struct file_operations tsf_ops = {
 static ssize_t reset_write(struct file *file, const char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 
 	rtnl_lock();
 	__ieee80211_suspend(&local->hw, NULL);
@@ -151,7 +151,7 @@ static const struct file_operations reset_ops = {
 static ssize_t noack_read(struct file *file, char __user *user_buf,
 			  size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 
 	return mac80211_format_buffer(user_buf, count, ppos, "%d\n",
 				      local->wifi_wme_noack_test);
@@ -161,7 +161,7 @@ static ssize_t noack_write(struct file *file,
 			   const char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	char buf[10];
 	size_t len;
 
@@ -185,7 +185,7 @@ static const struct file_operations noack_ops = {
 static ssize_t uapsd_queues_read(struct file *file, char __user *user_buf,
 				 size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	return mac80211_format_buffer(user_buf, count, ppos, "0x%x\n",
 				      local->uapsd_queues);
 }
@@ -194,7 +194,7 @@ static ssize_t uapsd_queues_write(struct file *file,
 				  const char __user *user_buf,
 				  size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	unsigned long val;
 	char buf[10];
 	size_t len;
@@ -228,7 +228,7 @@ static const struct file_operations uapsd_queues_ops = {
 static ssize_t uapsd_max_sp_len_read(struct file *file, char __user *user_buf,
 				     size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 
 	return mac80211_format_buffer(user_buf, count, ppos, "0x%x\n",
 				      local->uapsd_max_sp_len);
@@ -238,7 +238,7 @@ static ssize_t uapsd_max_sp_len_write(struct file *file,
 				      const char __user *user_buf,
 				      size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	unsigned long val;
 	char buf[10];
 	size_t len;
@@ -272,7 +272,7 @@ static const struct file_operations uapsd_max_sp_len_ops = {
 static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 		       size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	const char *buf;
 
 	switch (local->hw.conf.channel_type) {
@@ -299,7 +299,7 @@ static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 			    size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	int mxln = 500;
 	ssize_t rv;
 	char *buf = kzalloc(mxln, GFP_KERNEL);
@@ -364,7 +364,7 @@ static ssize_t hwflags_read(struct file *file, char __user *user_buf,
 static ssize_t queues_read(struct file *file, char __user *user_buf,
 			   size_t count, loff_t *ppos)
 {
-	struct ieee80211_local *local = file->private_data;
+	struct mac80211_local *local = file->private_data;
 	unsigned long flags;
 	char buf[IEEE80211_MAX_QUEUES * 20];
 	int q, res = 0;
@@ -385,7 +385,7 @@ DEBUGFS_READONLY_FILE_OPS(queues);
 
 /* statistics stuff */
 
-static ssize_t format_devstat_counter(struct ieee80211_local *local,
+static ssize_t format_devstat_counter(struct mac80211_local *local,
 	char __user *userbuf,
 	size_t count, loff_t *ppos,
 	int (*printvalue)(struct ieee80211_low_level_stats *stats, char *buf,
@@ -437,7 +437,7 @@ DEBUGFS_DEVSTATS_FILE(dot11RTSFailureCount);
 DEBUGFS_DEVSTATS_FILE(dot11FCSErrorCount);
 DEBUGFS_DEVSTATS_FILE(dot11RTSSuccessCount);
 
-void debugfs_hw_add(struct ieee80211_local *local)
+void debugfs_hw_add(struct mac80211_local *local)
 {
 	struct dentry *phyd = local->hw.wiphy->debugfsdir;
 	struct dentry *statsd;
diff --git a/net/mac80211/debugfs.h b/net/mac80211/debugfs.h
index 7c87529..b7970b4 100644
--- a/net/mac80211/debugfs.h
+++ b/net/mac80211/debugfs.h
@@ -2,12 +2,12 @@
 #define __MAC80211_DEBUGFS_H
 
 #ifdef CONFIG_MAC80211_DEBUGFS
-extern void debugfs_hw_add(struct ieee80211_local *local);
+extern void debugfs_hw_add(struct mac80211_local *local);
 extern int mac80211_open_file_generic(struct inode *inode, struct file *file);
 extern int mac80211_format_buffer(char __user *userbuf, size_t count,
 				  loff_t *ppos, char *fmt, ...);
 #else
-static inline void debugfs_hw_add(struct ieee80211_local *local)
+static inline void debugfs_hw_add(struct mac80211_local *local)
 {
 }
 #endif
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 950c1d5..d2b6a87 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -160,7 +160,7 @@ IEEE80211_IF_FILE(ave_beacon, u.mgd.ave_beacon_signal, DEC_DIV_16);
 static int ieee80211_set_smps(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_smps_mode smps_mode)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int err;
 
 	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_STATIC_SMPS) &&
@@ -251,7 +251,7 @@ static int hwaddr_aton(const char *txt, u8 *addr)
 static ssize_t ieee80211_if_parse_tkip_mic_test(
 	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	u8 addr[ETH_ALEN];
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 06236f6..f15f2ca 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -5,12 +5,12 @@
 #include "mac80211_i.h"
 #include "driver-trace.h"
 
-static inline void drv_tx(struct ieee80211_local *local, struct sk_buff *skb)
+static inline void drv_tx(struct mac80211_local *local, struct sk_buff *skb)
 {
 	local->ops->tx(&local->hw, skb);
 }
 
-static inline int drv_start(struct ieee80211_local *local)
+static inline int drv_start(struct mac80211_local *local)
 {
 	int ret;
 
@@ -24,7 +24,7 @@ static inline int drv_start(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline void drv_stop(struct ieee80211_local *local)
+static inline void drv_stop(struct mac80211_local *local)
 {
 	might_sleep();
 
@@ -42,7 +42,7 @@ static inline void drv_stop(struct ieee80211_local *local)
 }
 
 #ifdef CONFIG_PM
-static inline int drv_suspend(struct ieee80211_local *local,
+static inline int drv_suspend(struct mac80211_local *local,
 			      struct cfg80211_wowlan *wowlan)
 {
 	int ret;
@@ -55,7 +55,7 @@ static inline int drv_suspend(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_resume(struct ieee80211_local *local)
+static inline int drv_resume(struct mac80211_local *local)
 {
 	int ret;
 
@@ -68,7 +68,7 @@ static inline int drv_resume(struct ieee80211_local *local)
 }
 #endif
 
-static inline int drv_add_interface(struct ieee80211_local *local,
+static inline int drv_add_interface(struct mac80211_local *local,
 				    struct ieee80211_vif *vif)
 {
 	int ret;
@@ -81,7 +81,7 @@ static inline int drv_add_interface(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_change_interface(struct ieee80211_local *local,
+static inline int drv_change_interface(struct mac80211_local *local,
 				       struct ieee80211_sub_if_data *sdata,
 				       enum nl80211_iftype type, bool p2p)
 {
@@ -95,7 +95,7 @@ static inline int drv_change_interface(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_remove_interface(struct ieee80211_local *local,
+static inline void drv_remove_interface(struct mac80211_local *local,
 					struct ieee80211_vif *vif)
 {
 	might_sleep();
@@ -105,7 +105,7 @@ static inline void drv_remove_interface(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_config(struct ieee80211_local *local, u32 changed)
+static inline int drv_config(struct mac80211_local *local, u32 changed)
 {
 	int ret;
 
@@ -117,7 +117,7 @@ static inline int drv_config(struct ieee80211_local *local, u32 changed)
 	return ret;
 }
 
-static inline void drv_bss_info_changed(struct ieee80211_local *local,
+static inline void drv_bss_info_changed(struct mac80211_local *local,
 					struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_bss_conf *info,
 					u32 changed)
@@ -130,7 +130,7 @@ static inline void drv_bss_info_changed(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
+static inline u64 drv_prepare_multicast(struct mac80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
 	u64 ret = 0;
@@ -145,7 +145,7 @@ static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_configure_filter(struct ieee80211_local *local,
+static inline void drv_configure_filter(struct mac80211_local *local,
 					unsigned int changed_flags,
 					unsigned int *total_flags,
 					u64 multicast)
@@ -159,7 +159,7 @@ static inline void drv_configure_filter(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_set_tim(struct ieee80211_local *local,
+static inline int drv_set_tim(struct mac80211_local *local,
 			      struct ieee80211_sta *sta, bool set)
 {
 	int ret = 0;
@@ -170,7 +170,7 @@ static inline int drv_set_tim(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_set_key(struct ieee80211_local *local,
+static inline int drv_set_key(struct mac80211_local *local,
 			      enum set_key_cmd cmd,
 			      struct ieee80211_sub_if_data *sdata,
 			      struct ieee80211_sta *sta,
@@ -186,7 +186,7 @@ static inline int drv_set_key(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_update_tkip_key(struct ieee80211_local *local,
+static inline void drv_update_tkip_key(struct mac80211_local *local,
 				       struct ieee80211_sub_if_data *sdata,
 				       struct ieee80211_key_conf *conf,
 				       struct sta_info *sta, u32 iv32,
@@ -204,7 +204,7 @@ static inline void drv_update_tkip_key(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_hw_scan(struct ieee80211_local *local,
+static inline int drv_hw_scan(struct mac80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
 			      struct cfg80211_scan_request *req)
 {
@@ -219,7 +219,7 @@ static inline int drv_hw_scan(struct ieee80211_local *local,
 }
 
 static inline int
-drv_sched_scan_start(struct ieee80211_local *local,
+drv_sched_scan_start(struct mac80211_local *local,
 		     struct ieee80211_sub_if_data *sdata,
 		     struct cfg80211_sched_scan_request *req,
 		     struct ieee80211_sched_scan_ies *ies)
@@ -235,7 +235,7 @@ drv_sched_scan_start(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_sched_scan_stop(struct ieee80211_local *local,
+static inline void drv_sched_scan_stop(struct mac80211_local *local,
 				       struct ieee80211_sub_if_data *sdata)
 {
 	might_sleep();
@@ -245,7 +245,7 @@ static inline void drv_sched_scan_stop(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_sw_scan_start(struct ieee80211_local *local)
+static inline void drv_sw_scan_start(struct mac80211_local *local)
 {
 	might_sleep();
 
@@ -255,7 +255,7 @@ static inline void drv_sw_scan_start(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
-static inline void drv_sw_scan_complete(struct ieee80211_local *local)
+static inline void drv_sw_scan_complete(struct mac80211_local *local)
 {
 	might_sleep();
 
@@ -265,7 +265,7 @@ static inline void drv_sw_scan_complete(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
-static inline int drv_get_stats(struct ieee80211_local *local,
+static inline int drv_get_stats(struct mac80211_local *local,
 				struct ieee80211_low_level_stats *stats)
 {
 	int ret = -EOPNOTSUPP;
@@ -279,7 +279,7 @@ static inline int drv_get_stats(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_get_tkip_seq(struct ieee80211_local *local,
+static inline void drv_get_tkip_seq(struct mac80211_local *local,
 				    u8 hw_key_idx, u32 *iv32, u16 *iv16)
 {
 	if (local->ops->get_tkip_seq)
@@ -287,7 +287,7 @@ static inline void drv_get_tkip_seq(struct ieee80211_local *local,
 	trace_drv_get_tkip_seq(local, hw_key_idx, iv32, iv16);
 }
 
-static inline int drv_set_frag_threshold(struct ieee80211_local *local,
+static inline int drv_set_frag_threshold(struct mac80211_local *local,
 					u32 value)
 {
 	int ret = 0;
@@ -301,7 +301,7 @@ static inline int drv_set_frag_threshold(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_set_rts_threshold(struct ieee80211_local *local,
+static inline int drv_set_rts_threshold(struct mac80211_local *local,
 					u32 value)
 {
 	int ret = 0;
@@ -315,7 +315,7 @@ static inline int drv_set_rts_threshold(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_set_coverage_class(struct ieee80211_local *local,
+static inline int drv_set_coverage_class(struct mac80211_local *local,
 					 u8 value)
 {
 	int ret = 0;
@@ -331,7 +331,7 @@ static inline int drv_set_coverage_class(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_sta_notify(struct ieee80211_local *local,
+static inline void drv_sta_notify(struct mac80211_local *local,
 				  struct ieee80211_sub_if_data *sdata,
 				  enum sta_notify_cmd cmd,
 				  struct ieee80211_sta *sta)
@@ -342,7 +342,7 @@ static inline void drv_sta_notify(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_sta_add(struct ieee80211_local *local,
+static inline int drv_sta_add(struct mac80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
 			      struct ieee80211_sta *sta)
 {
@@ -359,7 +359,7 @@ static inline int drv_sta_add(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_sta_remove(struct ieee80211_local *local,
+static inline void drv_sta_remove(struct mac80211_local *local,
 				  struct ieee80211_sub_if_data *sdata,
 				  struct ieee80211_sta *sta)
 {
@@ -372,7 +372,7 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
+static inline int drv_conf_tx(struct mac80211_local *local, u16 queue,
 			      const struct ieee80211_tx_queue_params *params)
 {
 	int ret = -EOPNOTSUPP;
@@ -386,7 +386,7 @@ static inline int drv_conf_tx(struct ieee80211_local *local, u16 queue,
 	return ret;
 }
 
-static inline u64 drv_get_tsf(struct ieee80211_local *local)
+static inline u64 drv_get_tsf(struct mac80211_local *local)
 {
 	u64 ret = -1ULL;
 
@@ -399,7 +399,7 @@ static inline u64 drv_get_tsf(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
+static inline void drv_set_tsf(struct mac80211_local *local, u64 tsf)
 {
 	might_sleep();
 
@@ -409,7 +409,7 @@ static inline void drv_set_tsf(struct ieee80211_local *local, u64 tsf)
 	trace_drv_return_void(local);
 }
 
-static inline void drv_reset_tsf(struct ieee80211_local *local)
+static inline void drv_reset_tsf(struct mac80211_local *local)
 {
 	might_sleep();
 
@@ -419,7 +419,7 @@ static inline void drv_reset_tsf(struct ieee80211_local *local)
 	trace_drv_return_void(local);
 }
 
-static inline int drv_tx_last_beacon(struct ieee80211_local *local)
+static inline int drv_tx_last_beacon(struct mac80211_local *local)
 {
 	int ret = 0; /* default unsuported op for less congestion */
 
@@ -432,7 +432,7 @@ static inline int drv_tx_last_beacon(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_ampdu_action(struct ieee80211_local *local,
+static inline int drv_ampdu_action(struct mac80211_local *local,
 				   struct ieee80211_sub_if_data *sdata,
 				   enum ieee80211_ampdu_mlme_action action,
 				   struct ieee80211_sta *sta, u16 tid,
@@ -453,7 +453,7 @@ static inline int drv_ampdu_action(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_get_survey(struct ieee80211_local *local, int idx,
+static inline int drv_get_survey(struct mac80211_local *local, int idx,
 				struct survey_info *survey)
 {
 	int ret = -EOPNOTSUPP;
@@ -468,7 +468,7 @@ static inline int drv_get_survey(struct ieee80211_local *local, int idx,
 	return ret;
 }
 
-static inline void drv_rfkill_poll(struct ieee80211_local *local)
+static inline void drv_rfkill_poll(struct mac80211_local *local)
 {
 	might_sleep();
 
@@ -476,7 +476,7 @@ static inline void drv_rfkill_poll(struct ieee80211_local *local)
 		local->ops->rfkill_poll(&local->hw);
 }
 
-static inline void drv_flush(struct ieee80211_local *local, bool drop)
+static inline void drv_flush(struct mac80211_local *local, bool drop)
 {
 	might_sleep();
 
@@ -486,7 +486,7 @@ static inline void drv_flush(struct ieee80211_local *local, bool drop)
 	trace_drv_return_void(local);
 }
 
-static inline void drv_channel_switch(struct ieee80211_local *local,
+static inline void drv_channel_switch(struct mac80211_local *local,
 				     struct ieee80211_channel_switch *ch_switch)
 {
 	might_sleep();
@@ -497,7 +497,7 @@ static inline void drv_channel_switch(struct ieee80211_local *local,
 }
 
 
-static inline int drv_set_antenna(struct ieee80211_local *local,
+static inline int drv_set_antenna(struct mac80211_local *local,
 				  u32 tx_ant, u32 rx_ant)
 {
 	int ret = -EOPNOTSUPP;
@@ -508,7 +508,7 @@ static inline int drv_set_antenna(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_get_antenna(struct ieee80211_local *local,
+static inline int drv_get_antenna(struct mac80211_local *local,
 				  u32 *tx_ant, u32 *rx_ant)
 {
 	int ret = -EOPNOTSUPP;
@@ -519,7 +519,7 @@ static inline int drv_get_antenna(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_remain_on_channel(struct ieee80211_local *local,
+static inline int drv_remain_on_channel(struct mac80211_local *local,
 					struct ieee80211_channel *chan,
 					enum nl80211_channel_type chantype,
 					unsigned int duration)
@@ -536,7 +536,7 @@ static inline int drv_remain_on_channel(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_cancel_remain_on_channel(struct ieee80211_local *local)
+static inline int drv_cancel_remain_on_channel(struct mac80211_local *local)
 {
 	int ret;
 
@@ -549,7 +549,7 @@ static inline int drv_cancel_remain_on_channel(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_offchannel_tx(struct ieee80211_local *local,
+static inline int drv_offchannel_tx(struct mac80211_local *local,
 				    struct sk_buff *skb,
 				    struct ieee80211_channel *chan,
 				    enum nl80211_channel_type channel_type,
@@ -567,7 +567,7 @@ static inline int drv_offchannel_tx(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline int drv_offchannel_tx_cancel_wait(struct ieee80211_local *local)
+static inline int drv_offchannel_tx_cancel_wait(struct mac80211_local *local)
 {
 	int ret;
 
@@ -580,7 +580,7 @@ static inline int drv_offchannel_tx_cancel_wait(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_set_ringparam(struct ieee80211_local *local,
+static inline int drv_set_ringparam(struct mac80211_local *local,
 				    u32 tx, u32 rx)
 {
 	int ret = -ENOTSUPP;
@@ -595,7 +595,7 @@ static inline int drv_set_ringparam(struct ieee80211_local *local,
 	return ret;
 }
 
-static inline void drv_get_ringparam(struct ieee80211_local *local,
+static inline void drv_get_ringparam(struct mac80211_local *local,
 				     u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
 {
 	might_sleep();
@@ -606,7 +606,7 @@ static inline void drv_get_ringparam(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline bool drv_tx_frames_pending(struct ieee80211_local *local)
+static inline bool drv_tx_frames_pending(struct mac80211_local *local)
 {
 	bool ret = false;
 
@@ -620,7 +620,7 @@ static inline bool drv_tx_frames_pending(struct ieee80211_local *local)
 	return ret;
 }
 
-static inline int drv_set_bitrate_mask(struct ieee80211_local *local,
+static inline int drv_set_bitrate_mask(struct mac80211_local *local,
 				       struct ieee80211_sub_if_data *sdata,
 				       const struct cfg80211_bitrate_mask *mask)
 {
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 399ae8c..ffa02ac 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -44,7 +44,7 @@ static inline void trace_ ## name(proto) {}
  */
 
 DECLARE_EVENT_CLASS(local_only_evt,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local),
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -56,7 +56,7 @@ DECLARE_EVENT_CLASS(local_only_evt,
 );
 
 DECLARE_EVENT_CLASS(local_sdata_addr_evt,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata),
 
@@ -79,7 +79,7 @@ DECLARE_EVENT_CLASS(local_sdata_addr_evt,
 );
 
 DECLARE_EVENT_CLASS(local_u32_evt,
-	TP_PROTO(struct ieee80211_local *local, u32 value),
+	TP_PROTO(struct mac80211_local *local, u32 value),
 	TP_ARGS(local, value),
 
 	TP_STRUCT__entry(
@@ -99,7 +99,7 @@ DECLARE_EVENT_CLASS(local_u32_evt,
 );
 
 DECLARE_EVENT_CLASS(local_sdata_evt,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata),
 
@@ -120,12 +120,12 @@ DECLARE_EVENT_CLASS(local_sdata_evt,
 );
 
 DEFINE_EVENT(local_only_evt, drv_return_void,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_return_int,
-	TP_PROTO(struct ieee80211_local *local, int ret),
+	TP_PROTO(struct mac80211_local *local, int ret),
 	TP_ARGS(local, ret),
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -139,7 +139,7 @@ TRACE_EVENT(drv_return_int,
 );
 
 TRACE_EVENT(drv_return_bool,
-	TP_PROTO(struct ieee80211_local *local, bool ret),
+	TP_PROTO(struct mac80211_local *local, bool ret),
 	TP_ARGS(local, ret),
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -154,7 +154,7 @@ TRACE_EVENT(drv_return_bool,
 );
 
 TRACE_EVENT(drv_return_u64,
-	TP_PROTO(struct ieee80211_local *local, u64 ret),
+	TP_PROTO(struct mac80211_local *local, u64 ret),
 	TP_ARGS(local, ret),
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
@@ -168,33 +168,33 @@ TRACE_EVENT(drv_return_u64,
 );
 
 DEFINE_EVENT(local_only_evt, drv_start,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, drv_suspend,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, drv_resume,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, drv_stop,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_sdata_addr_evt, drv_add_interface,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_change_interface,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum nl80211_iftype type, bool p2p),
 
@@ -222,13 +222,13 @@ TRACE_EVENT(drv_change_interface,
 );
 
 DEFINE_EVENT(local_sdata_addr_evt, drv_remove_interface,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 TRACE_EVENT(drv_config,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 u32 changed),
 
 	TP_ARGS(local, changed),
@@ -270,7 +270,7 @@ TRACE_EVENT(drv_config,
 );
 
 TRACE_EVENT(drv_bss_info_changed,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_bss_conf *info,
 		 u32 changed),
@@ -320,7 +320,7 @@ TRACE_EVENT(drv_bss_info_changed,
 );
 
 TRACE_EVENT(drv_prepare_multicast,
-	TP_PROTO(struct ieee80211_local *local, int mc_count),
+	TP_PROTO(struct mac80211_local *local, int mc_count),
 
 	TP_ARGS(local, mc_count),
 
@@ -341,7 +341,7 @@ TRACE_EVENT(drv_prepare_multicast,
 );
 
 TRACE_EVENT(drv_configure_filter,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 unsigned int changed_flags,
 		 unsigned int *total_flags,
 		 u64 multicast),
@@ -369,7 +369,7 @@ TRACE_EVENT(drv_configure_filter,
 );
 
 TRACE_EVENT(drv_set_tim,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sta *sta, bool set),
 
 	TP_ARGS(local, sta, set),
@@ -393,7 +393,7 @@ TRACE_EVENT(drv_set_tim,
 );
 
 TRACE_EVENT(drv_set_key,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 enum set_key_cmd cmd, struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta,
 		 struct ieee80211_key_conf *key),
@@ -427,7 +427,7 @@ TRACE_EVENT(drv_set_key,
 );
 
 TRACE_EVENT(drv_update_tkip_key,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_key_conf *conf,
 		 struct ieee80211_sta *sta, u32 iv32),
@@ -455,35 +455,35 @@ TRACE_EVENT(drv_update_tkip_key,
 );
 
 DEFINE_EVENT(local_sdata_evt, drv_hw_scan,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_start,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 DEFINE_EVENT(local_sdata_evt, drv_sched_scan_stop,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata),
 	TP_ARGS(local, sdata)
 );
 
 DEFINE_EVENT(local_only_evt, drv_sw_scan_start,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, drv_sw_scan_complete,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_get_stats,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_low_level_stats *stats,
 		 int ret),
 
@@ -514,7 +514,7 @@ TRACE_EVENT(drv_get_stats,
 );
 
 TRACE_EVENT(drv_get_tkip_seq,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 u8 hw_key_idx, u32 *iv32, u16 *iv16),
 
 	TP_ARGS(local, hw_key_idx, iv32, iv16),
@@ -539,17 +539,17 @@ TRACE_EVENT(drv_get_tkip_seq,
 );
 
 DEFINE_EVENT(local_u32_evt, drv_set_frag_threshold,
-	TP_PROTO(struct ieee80211_local *local, u32 value),
+	TP_PROTO(struct mac80211_local *local, u32 value),
 	TP_ARGS(local, value)
 );
 
 DEFINE_EVENT(local_u32_evt, drv_set_rts_threshold,
-	TP_PROTO(struct ieee80211_local *local, u32 value),
+	TP_PROTO(struct mac80211_local *local, u32 value),
 	TP_ARGS(local, value)
 );
 
 TRACE_EVENT(drv_set_coverage_class,
-	TP_PROTO(struct ieee80211_local *local, u8 value),
+	TP_PROTO(struct mac80211_local *local, u8 value),
 
 	TP_ARGS(local, value),
 
@@ -570,7 +570,7 @@ TRACE_EVENT(drv_set_coverage_class,
 );
 
 TRACE_EVENT(drv_sta_notify,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum sta_notify_cmd cmd,
 		 struct ieee80211_sta *sta),
@@ -598,7 +598,7 @@ TRACE_EVENT(drv_sta_notify,
 );
 
 TRACE_EVENT(drv_sta_add,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
 
@@ -623,7 +623,7 @@ TRACE_EVENT(drv_sta_add,
 );
 
 TRACE_EVENT(drv_sta_remove,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_sta *sta),
 
@@ -648,7 +648,7 @@ TRACE_EVENT(drv_sta_remove,
 );
 
 TRACE_EVENT(drv_conf_tx,
-	TP_PROTO(struct ieee80211_local *local, u16 queue,
+	TP_PROTO(struct mac80211_local *local, u16 queue,
 		 const struct ieee80211_tx_queue_params *params),
 
 	TP_ARGS(local, queue, params),
@@ -678,12 +678,12 @@ TRACE_EVENT(drv_conf_tx,
 );
 
 DEFINE_EVENT(local_only_evt, drv_get_tsf,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_set_tsf,
-	TP_PROTO(struct ieee80211_local *local, u64 tsf),
+	TP_PROTO(struct mac80211_local *local, u64 tsf),
 
 	TP_ARGS(local, tsf),
 
@@ -704,17 +704,17 @@ TRACE_EVENT(drv_set_tsf,
 );
 
 DEFINE_EVENT(local_only_evt, drv_reset_tsf,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, drv_tx_last_beacon,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_ampdu_action,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 enum ieee80211_ampdu_mlme_action action,
 		 struct ieee80211_sta *sta, u16 tid,
@@ -750,7 +750,7 @@ TRACE_EVENT(drv_ampdu_action,
 );
 
 TRACE_EVENT(drv_get_survey,
-	TP_PROTO(struct ieee80211_local *local, int idx,
+	TP_PROTO(struct mac80211_local *local, int idx,
 		 struct survey_info *survey),
 
 	TP_ARGS(local, idx, survey),
@@ -772,7 +772,7 @@ TRACE_EVENT(drv_get_survey,
 );
 
 TRACE_EVENT(drv_flush,
-	TP_PROTO(struct ieee80211_local *local, bool drop),
+	TP_PROTO(struct mac80211_local *local, bool drop),
 
 	TP_ARGS(local, drop),
 
@@ -793,7 +793,7 @@ TRACE_EVENT(drv_flush,
 );
 
 TRACE_EVENT(drv_channel_switch,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_channel_switch *ch_switch),
 
 	TP_ARGS(local, ch_switch),
@@ -821,7 +821,7 @@ TRACE_EVENT(drv_channel_switch,
 );
 
 TRACE_EVENT(drv_set_antenna,
-	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
+	TP_PROTO(struct mac80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
 
 	TP_ARGS(local, tx_ant, rx_ant, ret),
 
@@ -846,7 +846,7 @@ TRACE_EVENT(drv_set_antenna,
 );
 
 TRACE_EVENT(drv_get_antenna,
-	TP_PROTO(struct ieee80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
+	TP_PROTO(struct mac80211_local *local, u32 tx_ant, u32 rx_ant, int ret),
 
 	TP_ARGS(local, tx_ant, rx_ant, ret),
 
@@ -871,7 +871,7 @@ TRACE_EVENT(drv_get_antenna,
 );
 
 TRACE_EVENT(drv_remain_on_channel,
-	TP_PROTO(struct ieee80211_local *local, struct ieee80211_channel *chan,
+	TP_PROTO(struct mac80211_local *local, struct ieee80211_channel *chan,
 		 enum nl80211_channel_type chantype, unsigned int duration),
 
 	TP_ARGS(local, chan, chantype, duration),
@@ -897,12 +897,12 @@ TRACE_EVENT(drv_remain_on_channel,
 );
 
 DEFINE_EVENT(local_only_evt, drv_cancel_remain_on_channel,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_offchannel_tx,
-	TP_PROTO(struct ieee80211_local *local, struct sk_buff *skb,
+	TP_PROTO(struct mac80211_local *local, struct sk_buff *skb,
 		 struct ieee80211_channel *chan,
 		 enum nl80211_channel_type channel_type,
 		 unsigned int wait),
@@ -930,7 +930,7 @@ TRACE_EVENT(drv_offchannel_tx,
 );
 
 TRACE_EVENT(drv_set_ringparam,
-	TP_PROTO(struct ieee80211_local *local, u32 tx, u32 rx),
+	TP_PROTO(struct mac80211_local *local, u32 tx, u32 rx),
 
 	TP_ARGS(local, tx, rx),
 
@@ -953,7 +953,7 @@ TRACE_EVENT(drv_set_ringparam,
 );
 
 TRACE_EVENT(drv_get_ringparam,
-	TP_PROTO(struct ieee80211_local *local, u32 *tx, u32 *tx_max,
+	TP_PROTO(struct mac80211_local *local, u32 *tx, u32 *tx_max,
 		 u32 *rx, u32 *rx_max),
 
 	TP_ARGS(local, tx, tx_max, rx, rx_max),
@@ -982,17 +982,17 @@ TRACE_EVENT(drv_get_ringparam,
 );
 
 DEFINE_EVENT(local_only_evt, drv_tx_frames_pending,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, drv_offchannel_tx_cancel_wait,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 TRACE_EVENT(drv_set_bitrate_mask,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 const struct cfg80211_bitrate_mask *mask),
 
@@ -1111,7 +1111,7 @@ TRACE_EVENT(api_stop_tx_ba_cb,
 );
 
 DEFINE_EVENT(local_only_evt, api_restart_hw,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
@@ -1176,7 +1176,7 @@ TRACE_EVENT(api_cqm_rssi_notify,
 );
 
 TRACE_EVENT(api_scan_completed,
-	TP_PROTO(struct ieee80211_local *local, bool aborted),
+	TP_PROTO(struct mac80211_local *local, bool aborted),
 
 	TP_ARGS(local, aborted),
 
@@ -1197,7 +1197,7 @@ TRACE_EVENT(api_scan_completed,
 );
 
 TRACE_EVENT(api_sched_scan_results,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 
 	TP_ARGS(local),
 
@@ -1215,7 +1215,7 @@ TRACE_EVENT(api_sched_scan_results,
 );
 
 TRACE_EVENT(api_sched_scan_stopped,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 
 	TP_ARGS(local),
 
@@ -1233,7 +1233,7 @@ TRACE_EVENT(api_sched_scan_stopped,
 );
 
 TRACE_EVENT(api_sta_block_awake,
-	TP_PROTO(struct ieee80211_local *local,
+	TP_PROTO(struct mac80211_local *local,
 		 struct ieee80211_sta *sta, bool block),
 
 	TP_ARGS(local, sta, block),
@@ -1278,12 +1278,12 @@ TRACE_EVENT(api_chswitch_done,
 );
 
 DEFINE_EVENT(local_only_evt, api_ready_on_channel,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
 DEFINE_EVENT(local_only_evt, api_remain_on_channel_expired,
-	TP_PROTO(struct ieee80211_local *local),
+	TP_PROTO(struct mac80211_local *local),
 	TP_ARGS(local)
 );
 
@@ -1293,7 +1293,7 @@ DEFINE_EVENT(local_only_evt, api_remain_on_channel_expired,
  */
 
 TRACE_EVENT(wake_queue,
-	TP_PROTO(struct ieee80211_local *local, u16 queue,
+	TP_PROTO(struct mac80211_local *local, u16 queue,
 		 enum queue_stop_reason reason),
 
 	TP_ARGS(local, queue, reason),
@@ -1317,7 +1317,7 @@ TRACE_EVENT(wake_queue,
 );
 
 TRACE_EVENT(stop_queue,
-	TP_PROTO(struct ieee80211_local *local, u16 queue,
+	TP_PROTO(struct mac80211_local *local, u16 queue,
 		 enum queue_stop_reason reason),
 
 	TP_ARGS(local, queue, reason),
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 3b1abcf..fc7c269 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -180,7 +180,7 @@ void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
 			  const u8 *da, u16 tid,
 			  u16 initiator, u16 reason_code)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u16 params;
@@ -250,7 +250,7 @@ int ieee80211_send_smps_action(struct ieee80211_sub_if_data *sdata,
 			       enum ieee80211_smps_mode smps, const u8 *da,
 			       const u8 *bssid)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *action_frame;
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 991114a..d97273b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -68,7 +68,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 				      const u16 capability, u64 tsf)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int rates, i;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -257,7 +257,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee802_11_elems *elems,
 				  bool beacon)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int freq;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
@@ -421,7 +421,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					gfp_t gfp)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int band = local->hw.conf.channel->band;
 
@@ -468,7 +468,7 @@ struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 
 static int ieee80211_sta_active_ibss(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int active = 0;
 	struct sta_info *sta;
 
@@ -567,7 +567,7 @@ static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_channel *chan = NULL;
 	const u8 *bssid = NULL;
@@ -658,7 +658,7 @@ static void ieee80211_rx_mgmt_probe_req(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_mgmt *mgmt = (void *)req->data;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int tx_last_beacon, len = req->len;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *resp;
@@ -834,7 +834,7 @@ static void ieee80211_ibss_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
 		ifibss->timer_running = true;
@@ -874,7 +874,7 @@ void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata)
 }
 
 /* scan finished notification */
-void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local)
+void ieee80211_ibss_notify_scan_completed(struct mac80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
@@ -958,7 +958,7 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct cfg80211_bss *cbss;
 	u16 capability;
 	int active_ibss;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 08e987e..5c44737 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -29,7 +29,7 @@
 /**
  * DOC: Interface list locking
  *
- * The interface list in each struct ieee80211_local is protected
+ * The interface list in each struct mac80211_local is protected
  * three-fold:
  *
  * (1) modifications may only be done under the RTNL
@@ -98,7 +98,7 @@ static inline int identical_mac_addr_allowed(int type1, int type2)
 static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 					    enum nl80211_iftype iftype)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *nsdata;
 	struct net_device *dev = sdata->dev;
 
@@ -152,7 +152,7 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	u32 flags = sdata->u.mntr_flags;
 
 #define ADJUST(_f, _s)	do {					\
@@ -177,7 +177,7 @@ void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_do_open(struct net_device *dev, bool coming_up)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0;
 	int res;
@@ -377,7 +377,7 @@ static int ieee80211_open(struct net_device *dev)
 static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			      bool going_down)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
@@ -579,7 +579,7 @@ static int ieee80211_stop(struct net_device *dev)
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int allmulti, promisc, sdata_allmulti, sdata_promisc;
 
 	allmulti = !!(dev->flags & IFF_ALLMULTI);
@@ -615,7 +615,7 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
 static void ieee80211_teardown_sdata(struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int flushed;
 	int i;
 
@@ -656,7 +656,7 @@ static u16 ieee80211_monitor_select_queue(struct net_device *dev,
 					  struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_radiotap_header *rtap = (void *)skb->data;
 	u8 *p;
@@ -707,7 +707,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, work);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
 	struct ieee80211_ra_tid *ra_tid;
@@ -904,7 +904,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 					   enum nl80211_iftype type)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int ret, err;
 	enum nl80211_iftype internal_type = type;
 	bool p2p = false;
@@ -1008,7 +1008,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
+static void ieee80211_assign_perm_addr(struct mac80211_local *local,
 				       struct net_device *dev,
 				       enum nl80211_iftype type)
 {
@@ -1120,7 +1120,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-int ieee80211_if_add(struct ieee80211_local *local, const char *name,
+int ieee80211_if_add(struct mac80211_local *local, const char *name,
 		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params)
 {
@@ -1222,7 +1222,7 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
  * Remove all interfaces, may only be called at hardware unregistration
  * time because it doesn't do RCU-safe list removals.
  */
-void ieee80211_remove_interfaces(struct ieee80211_local *local)
+void ieee80211_remove_interfaces(struct mac80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata, *tmp;
 	LIST_HEAD(unreg_list);
@@ -1240,7 +1240,7 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_del(&unreg_list);
 }
 
-static u32 ieee80211_idle_off(struct ieee80211_local *local,
+static u32 ieee80211_idle_off(struct mac80211_local *local,
 			      const char *reason)
 {
 	if (!(local->hw.conf.flags & IEEE80211_CONF_IDLE))
@@ -1254,7 +1254,7 @@ static u32 ieee80211_idle_off(struct ieee80211_local *local,
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
 
-static u32 ieee80211_idle_on(struct ieee80211_local *local)
+static u32 ieee80211_idle_on(struct mac80211_local *local)
 {
 	if (local->hw.conf.flags & IEEE80211_CONF_IDLE)
 		return 0;
@@ -1269,7 +1269,7 @@ static u32 ieee80211_idle_on(struct ieee80211_local *local)
 	return IEEE80211_CONF_CHANGE_IDLE;
 }
 
-u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
+u32 __ieee80211_recalc_idle(struct mac80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	int count = 0;
@@ -1354,7 +1354,7 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
 	return 0;
 }
 
-void ieee80211_recalc_idle(struct ieee80211_local *local)
+void ieee80211_recalc_idle(struct mac80211_local *local)
 {
 	u32 chg;
 
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index f6210ef..c7d0c81 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -48,7 +48,7 @@
 
 static const u8 bcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
-static void assert_key_lock(struct ieee80211_local *local)
+static void assert_key_lock(struct mac80211_local *local)
 {
 	lockdep_assert_held(&local->key_mtx);
 }
@@ -479,7 +479,7 @@ void __ieee80211_key_free(struct ieee80211_key *key)
 	__ieee80211_key_destroy(key);
 }
 
-void ieee80211_key_free(struct ieee80211_local *local,
+void ieee80211_key_free(struct mac80211_local *local,
 			struct ieee80211_key *key)
 {
 	mutex_lock(&local->key_mtx);
diff --git a/net/mac80211/key.h b/net/mac80211/key.h
index d801d53..035fc31 100644
--- a/net/mac80211/key.h
+++ b/net/mac80211/key.h
@@ -31,7 +31,7 @@
 
 #define NUM_RX_DATA_QUEUES	17
 
-struct ieee80211_local;
+struct mac80211_local;
 struct ieee80211_sub_if_data;
 struct sta_info;
 
@@ -59,7 +59,7 @@ struct tkip_ctx {
 };
 
 struct ieee80211_key {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
@@ -136,7 +136,7 @@ int __must_check ieee80211_key_link(struct ieee80211_key *key,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct sta_info *sta);
 void __ieee80211_key_free(struct ieee80211_key *key);
-void ieee80211_key_free(struct ieee80211_local *local,
+void ieee80211_key_free(struct mac80211_local *local,
 			struct ieee80211_key *key);
 void ieee80211_set_default_key(struct ieee80211_sub_if_data *sdata, int idx,
 			       bool uni, bool multi);
diff --git a/net/mac80211/led.c b/net/mac80211/led.c
index 1459033..0d2fd97 100644
--- a/net/mac80211/led.c
+++ b/net/mac80211/led.c
@@ -11,7 +11,7 @@
 #include <linux/slab.h>
 #include "led.h"
 
-void ieee80211_led_rx(struct ieee80211_local *local)
+void ieee80211_led_rx(struct mac80211_local *local)
 {
 	if (unlikely(!local->rx_led))
 		return;
@@ -22,7 +22,7 @@ void ieee80211_led_rx(struct ieee80211_local *local)
 }
 
 /* q is 1 if a packet was enqueued, 0 if it has been transmitted */
-void ieee80211_led_tx(struct ieee80211_local *local, int q)
+void ieee80211_led_tx(struct mac80211_local *local, int q)
 {
 	if (unlikely(!local->tx_led))
 		return;
@@ -34,7 +34,7 @@ void ieee80211_led_tx(struct ieee80211_local *local, int q)
 		led_trigger_event(local->tx_led, LED_FULL);
 }
 
-void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
+void ieee80211_led_assoc(struct mac80211_local *local, bool associated)
 {
 	if (unlikely(!local->assoc_led))
 		return;
@@ -44,7 +44,7 @@ void ieee80211_led_assoc(struct ieee80211_local *local, bool associated)
 		led_trigger_event(local->assoc_led, LED_OFF);
 }
 
-void ieee80211_led_radio(struct ieee80211_local *local, bool enabled)
+void ieee80211_led_radio(struct mac80211_local *local, bool enabled)
 {
 	if (unlikely(!local->radio_led))
 		return;
@@ -54,7 +54,7 @@ void ieee80211_led_radio(struct ieee80211_local *local, bool enabled)
 		led_trigger_event(local->radio_led, LED_OFF);
 }
 
-void ieee80211_led_names(struct ieee80211_local *local)
+void ieee80211_led_names(struct mac80211_local *local)
 {
 	snprintf(local->rx_led_name, sizeof(local->rx_led_name),
 		 "%srx", wiphy_name(local->hw.wiphy));
@@ -66,7 +66,7 @@ void ieee80211_led_names(struct ieee80211_local *local)
 		 "%sradio", wiphy_name(local->hw.wiphy));
 }
 
-void ieee80211_led_init(struct ieee80211_local *local)
+void ieee80211_led_init(struct mac80211_local *local)
 {
 	local->rx_led = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
 	if (local->rx_led) {
@@ -112,7 +112,7 @@ void ieee80211_led_init(struct ieee80211_local *local)
 	}
 }
 
-void ieee80211_led_exit(struct ieee80211_local *local)
+void ieee80211_led_exit(struct mac80211_local *local)
 {
 	if (local->radio_led) {
 		led_trigger_unregister(local->radio_led);
@@ -139,7 +139,7 @@ void ieee80211_led_exit(struct ieee80211_local *local)
 
 char *__ieee80211_get_radio_led_name(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	return local->radio_led_name;
 }
@@ -147,7 +147,7 @@ EXPORT_SYMBOL(__ieee80211_get_radio_led_name);
 
 char *__ieee80211_get_assoc_led_name(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	return local->assoc_led_name;
 }
@@ -155,7 +155,7 @@ EXPORT_SYMBOL(__ieee80211_get_assoc_led_name);
 
 char *__ieee80211_get_tx_led_name(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	return local->tx_led_name;
 }
@@ -163,13 +163,13 @@ EXPORT_SYMBOL(__ieee80211_get_tx_led_name);
 
 char *__ieee80211_get_rx_led_name(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	return local->rx_led_name;
 }
 EXPORT_SYMBOL(__ieee80211_get_rx_led_name);
 
-static unsigned long tpt_trig_traffic(struct ieee80211_local *local,
+static unsigned long tpt_trig_traffic(struct mac80211_local *local,
 				      struct tpt_led_trigger *tpt_trig)
 {
 	unsigned long traffic, delta;
@@ -183,7 +183,7 @@ static unsigned long tpt_trig_traffic(struct ieee80211_local *local,
 
 static void tpt_trig_timer(unsigned long data)
 {
-	struct ieee80211_local *local = (void *)data;
+	struct mac80211_local *local = (void *)data;
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
 	struct led_classdev *led_cdev;
 	unsigned long on, off, tpt;
@@ -220,7 +220,7 @@ char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
 				const struct ieee80211_tpt_blink *blink_table,
 				unsigned int blink_table_len)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct tpt_led_trigger *tpt_trig;
 
 	if (WARN_ON(local->tpt_led_trigger))
@@ -247,7 +247,7 @@ char *__ieee80211_create_tpt_led_trigger(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(__ieee80211_create_tpt_led_trigger);
 
-static void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
+static void ieee80211_start_tpt_led_trig(struct mac80211_local *local)
 {
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
 
@@ -262,7 +262,7 @@ static void ieee80211_start_tpt_led_trig(struct ieee80211_local *local)
 	mod_timer(&tpt_trig->timer, round_jiffies(jiffies + HZ));
 }
 
-static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
+static void ieee80211_stop_tpt_led_trig(struct mac80211_local *local)
 {
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
 	struct led_classdev *led_cdev;
@@ -279,7 +279,7 @@ static void ieee80211_stop_tpt_led_trig(struct ieee80211_local *local)
 	read_unlock(&tpt_trig->trig.leddev_list_lock);
 }
 
-void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
+void ieee80211_mod_tpt_led_trig(struct mac80211_local *local,
 				unsigned int types_on, unsigned int types_off)
 {
 	struct tpt_led_trigger *tpt_trig = local->tpt_led_trigger;
diff --git a/net/mac80211/led.h b/net/mac80211/led.h
index 9be15dd..9219e7e 100644
--- a/net/mac80211/led.h
+++ b/net/mac80211/led.h
@@ -12,42 +12,42 @@
 #include "mac80211_i.h"
 
 #ifdef CONFIG_MAC80211_LEDS
-void ieee80211_led_rx(struct ieee80211_local *local);
-void ieee80211_led_tx(struct ieee80211_local *local, int q);
-void ieee80211_led_assoc(struct ieee80211_local *local,
+void ieee80211_led_rx(struct mac80211_local *local);
+void ieee80211_led_tx(struct mac80211_local *local, int q);
+void ieee80211_led_assoc(struct mac80211_local *local,
 			 bool associated);
-void ieee80211_led_radio(struct ieee80211_local *local,
+void ieee80211_led_radio(struct mac80211_local *local,
 			 bool enabled);
-void ieee80211_led_names(struct ieee80211_local *local);
-void ieee80211_led_init(struct ieee80211_local *local);
-void ieee80211_led_exit(struct ieee80211_local *local);
-void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
+void ieee80211_led_names(struct mac80211_local *local);
+void ieee80211_led_init(struct mac80211_local *local);
+void ieee80211_led_exit(struct mac80211_local *local);
+void ieee80211_mod_tpt_led_trig(struct mac80211_local *local,
 				unsigned int types_on, unsigned int types_off);
 #else
-static inline void ieee80211_led_rx(struct ieee80211_local *local)
+static inline void ieee80211_led_rx(struct mac80211_local *local)
 {
 }
-static inline void ieee80211_led_tx(struct ieee80211_local *local, int q)
+static inline void ieee80211_led_tx(struct mac80211_local *local, int q)
 {
 }
-static inline void ieee80211_led_assoc(struct ieee80211_local *local,
+static inline void ieee80211_led_assoc(struct mac80211_local *local,
 				       bool associated)
 {
 }
-static inline void ieee80211_led_radio(struct ieee80211_local *local,
+static inline void ieee80211_led_radio(struct mac80211_local *local,
 				       bool enabled)
 {
 }
-static inline void ieee80211_led_names(struct ieee80211_local *local)
+static inline void ieee80211_led_names(struct mac80211_local *local)
 {
 }
-static inline void ieee80211_led_init(struct ieee80211_local *local)
+static inline void ieee80211_led_init(struct mac80211_local *local)
 {
 }
-static inline void ieee80211_led_exit(struct ieee80211_local *local)
+static inline void ieee80211_led_exit(struct mac80211_local *local)
 {
 }
-static inline void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
+static inline void ieee80211_mod_tpt_led_trig(struct mac80211_local *local,
 					      unsigned int types_on,
 					      unsigned int types_off)
 {
@@ -55,7 +55,7 @@ static inline void ieee80211_mod_tpt_led_trig(struct ieee80211_local *local,
 #endif
 
 static inline void
-ieee80211_tpt_led_trig_tx(struct ieee80211_local *local, __le16 fc, int bytes)
+ieee80211_tpt_led_trig_tx(struct mac80211_local *local, __le16 fc, int bytes)
 {
 #ifdef CONFIG_MAC80211_LEDS
 	if (local->tpt_led_trigger && ieee80211_is_data(fc))
@@ -64,7 +64,7 @@ ieee80211_tpt_led_trig_tx(struct ieee80211_local *local, __le16 fc, int bytes)
 }
 
 static inline void
-ieee80211_tpt_led_trig_rx(struct ieee80211_local *local, __le16 fc, int bytes)
+ieee80211_tpt_led_trig_rx(struct mac80211_local *local, __le16 fc, int bytes)
 {
 #ifdef CONFIG_MAC80211_LEDS
 	if (local->tpt_led_trigger && ieee80211_is_data(fc))
diff --git a/net/mac80211/mac80211_i.h b/net/mac80211/mac80211_i.h
index 7f4f453..d35b195 100644
--- a/net/mac80211/mac80211_i.h
+++ b/net/mac80211/mac80211_i.h
@@ -30,7 +30,7 @@
 #include "key.h"
 #include "sta_info.h"
 
-struct ieee80211_local;
+struct mac80211_local;
 
 /* Maximum number of broadcast/multicast frames to buffer when some of the
  * associated stations are using power saving. */
@@ -142,7 +142,7 @@ typedef unsigned __bitwise__ ieee80211_tx_result;
 
 struct ieee80211_tx_data {
 	struct sk_buff *skb;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
@@ -196,7 +196,7 @@ enum ieee80211_rx_flags {
 
 struct ieee80211_rx_data {
 	struct sk_buff *skb;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	struct ieee80211_key *key;
@@ -545,7 +545,7 @@ struct ieee80211_sub_if_data {
 	struct list_head key_list;
 
 	struct net_device *dev;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 
 	unsigned int flags;
 
@@ -695,7 +695,7 @@ enum mac80211_scan_state {
 	SCAN_ENTER_OPER_CHANNEL,
 };
 
-struct ieee80211_local {
+struct mac80211_local {
 	/* embed the driver visible part.
 	 * don't cast (use the static inlines below), but we keep
 	 * it first anyway so they become a no-op */
@@ -1054,14 +1054,14 @@ struct ieee802_11_elems {
 	u8 timeout_int_len;
 };
 
-static inline struct ieee80211_local *hw_to_local(
+static inline struct mac80211_local *hw_to_local(
 	struct ieee80211_hw *hw)
 {
-	return container_of(hw, struct ieee80211_local, hw);
+	return container_of(hw, struct mac80211_local, hw);
 }
 
 static inline struct ieee80211_hw *local_to_hw(
-	struct ieee80211_local *local)
+	struct mac80211_local *local)
 {
 	return &local->hw;
 }
@@ -1074,11 +1074,11 @@ static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
 }
 
 
-int ieee80211_hw_config(struct ieee80211_local *local, u32 changed);
+int ieee80211_hw_config(struct mac80211_local *local, u32 changed);
 void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx);
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed);
-void ieee80211_configure_filter(struct ieee80211_local *local);
+void ieee80211_configure_filter(struct mac80211_local *local);
 u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata);
 
 /* STA code */
@@ -1093,9 +1093,9 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_disassoc_request *req,
 			   void *cookie);
-void ieee80211_send_pspoll(struct ieee80211_local *local,
+void ieee80211_send_pspoll(struct mac80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
-void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
+void ieee80211_recalc_ps(struct mac80211_local *local, s32 latency);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
@@ -1112,7 +1112,7 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata);
 
 /* IBSS code */
-void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
+void ieee80211_ibss_notify_scan_completed(struct mac80211_local *local);
 void ieee80211_ibss_setup_sdata(struct ieee80211_sub_if_data *sdata);
 struct sta_info *ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 					u8 *bssid, u8 *addr, u32 supp_rates,
@@ -1138,13 +1138,13 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_channel *chan);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
-void ieee80211_scan_cancel(struct ieee80211_local *local);
+void ieee80211_scan_cancel(struct mac80211_local *local);
 ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb);
 
-void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
+void ieee80211_mlme_notify_scan_completed(struct mac80211_local *local);
 struct ieee80211_bss *
-ieee80211_bss_info_update(struct ieee80211_local *local,
+ieee80211_bss_info_update(struct mac80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
 			  size_t len,
@@ -1152,9 +1152,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_channel *channel,
 			  bool beacon);
 struct ieee80211_bss *
-ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
+ieee80211_rx_bss_get(struct mac80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len);
-void ieee80211_rx_bss_put(struct ieee80211_local *local,
+void ieee80211_rx_bss_put(struct mac80211_local *local,
 			  struct ieee80211_bss *bss);
 
 /* scheduled scan handling */
@@ -1164,28 +1164,28 @@ int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sched_scan_stopped_work(struct work_struct *work);
 
 /* off-channel helpers */
-bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
-void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
+bool ieee80211_cfg_on_oper_channel(struct mac80211_local *local);
+void ieee80211_offchannel_enable_all_ps(struct mac80211_local *local,
 					bool tell_ap);
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
+void ieee80211_offchannel_stop_vifs(struct mac80211_local *local,
 				    bool offchannel_ps_enable);
-void ieee80211_offchannel_return(struct ieee80211_local *local,
+void ieee80211_offchannel_return(struct mac80211_local *local,
 				 bool enable_beaconing,
 				 bool offchannel_ps_disable);
-void ieee80211_hw_roc_setup(struct ieee80211_local *local);
+void ieee80211_hw_roc_setup(struct mac80211_local *local);
 
 /* interface handling */
 int ieee80211_iface_init(void);
 void ieee80211_iface_exit(void);
-int ieee80211_if_add(struct ieee80211_local *local, const char *name,
+int ieee80211_if_add(struct mac80211_local *local, const char *name,
 		     struct net_device **new_dev, enum nl80211_iftype type,
 		     struct vif_params *params);
 int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type);
 void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata);
-void ieee80211_remove_interfaces(struct ieee80211_local *local);
-u32 __ieee80211_recalc_idle(struct ieee80211_local *local);
-void ieee80211_recalc_idle(struct ieee80211_local *local);
+void ieee80211_remove_interfaces(struct mac80211_local *local);
+u32 __ieee80211_recalc_idle(struct mac80211_local *local);
+void ieee80211_recalc_idle(struct mac80211_local *local);
 void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 				    const int offset);
 
@@ -1195,7 +1195,7 @@ static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 }
 
 /* tx handling */
-void ieee80211_clear_tx_pending(struct ieee80211_local *local);
+void ieee80211_clear_tx_pending(struct mac80211_local *local);
 void ieee80211_tx_pending(unsigned long data);
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev);
@@ -1235,11 +1235,11 @@ void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx);
 void ieee80211_process_delba(struct ieee80211_sub_if_data *sdata,
 			     struct sta_info *sta,
 			     struct ieee80211_mgmt *mgmt, size_t len);
-void ieee80211_process_addba_resp(struct ieee80211_local *local,
+void ieee80211_process_addba_resp(struct mac80211_local *local,
 				  struct sta_info *sta,
 				  struct ieee80211_mgmt *mgmt,
 				  size_t len);
-void ieee80211_process_addba_request(struct ieee80211_local *local,
+void ieee80211_process_addba_request(struct mac80211_local *local,
 				     struct sta_info *sta,
 				     struct ieee80211_mgmt *mgmt,
 				     size_t len);
@@ -1262,8 +1262,8 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
 				       size_t len);
 
 /* Suspend/resume and hw reconfiguration */
-int ieee80211_reconfig(struct ieee80211_local *local);
-void ieee80211_stop_device(struct ieee80211_local *local);
+int ieee80211_reconfig(struct mac80211_local *local);
+void ieee80211_stop_device(struct mac80211_local *local);
 
 #ifdef CONFIG_PM
 int __ieee80211_suspend(struct ieee80211_hw *hw,
@@ -1271,7 +1271,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw,
 
 static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 		"%s: resume with hardware scan still in progress\n",
@@ -1296,7 +1296,7 @@ static inline int __ieee80211_resume(struct ieee80211_hw *hw)
 extern void *mac80211_wiphy_privid; /* for wiphy privid */
 u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len,
 			enum nl80211_iftype type);
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(struct mac80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble);
 void mac80211_ev_michael_mic_failure(struct ieee80211_sub_if_data *sdata, int keyidx,
 				     struct ieee80211_hdr *hdr, const u8 *tsc,
@@ -1308,13 +1308,13 @@ void ieee802_11_parse_elems(u8 *start, size_t len,
 u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 			       struct ieee802_11_elems *elems,
 			       u64 filter, u32 crc);
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct mac80211_local *local,
 			      enum ieee80211_band band);
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work);
 void ieee80211_dynamic_ps_timer(unsigned long data);
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
+void ieee80211_send_nullfunc(struct mac80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave);
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
@@ -1331,11 +1331,11 @@ void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason);
-void ieee80211_add_pending_skb(struct ieee80211_local *local,
+void ieee80211_add_pending_skb(struct mac80211_local *local,
 			       struct sk_buff *skb);
-int ieee80211_add_pending_skbs(struct ieee80211_local *local,
+int ieee80211_add_pending_skbs(struct mac80211_local *local,
 			       struct sk_buff_head *skbs);
-int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
+int ieee80211_add_pending_skbs_fn(struct mac80211_local *local,
 				  struct sk_buff_head *skbs,
 				  void (*fn)(void *data), void *data);
 
@@ -1343,7 +1343,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *key, u8 key_len, u8 key_idx);
-int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+int ieee80211_build_preq_ies(struct mac80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel);
@@ -1358,19 +1358,19 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates);
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct mac80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band);
 int __ieee80211_request_smps(struct ieee80211_sub_if_data *sdata,
 			     enum ieee80211_smps_mode smps_mode);
-void ieee80211_recalc_smps(struct ieee80211_local *local);
+void ieee80211_recalc_smps(struct mac80211_local *local);
 
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
 
 /* internal work items */
-void ieee80211_work_init(struct ieee80211_local *local);
+void ieee80211_work_init(struct mac80211_local *local);
 void ieee80211_add_work(struct ieee80211_work *wk);
 void free_work(struct ieee80211_work *wk);
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata);
@@ -1391,9 +1391,9 @@ enum ieee80211_chan_mode {
 };
 
 enum ieee80211_chan_mode
-ieee80211_get_channel_mode(struct ieee80211_local *local,
+ieee80211_get_channel_mode(struct mac80211_local *local,
 			   struct ieee80211_sub_if_data *ignore);
-bool ieee80211_set_channel_type(struct ieee80211_local *local,
+bool ieee80211_set_channel_type(struct mac80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0186aba..87416c3 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -35,7 +35,7 @@
 
 static struct lock_class_key ieee80211_rx_skb_queue_class;
 
-void ieee80211_configure_filter(struct ieee80211_local *local)
+void ieee80211_configure_filter(struct mac80211_local *local)
 {
 	u64 mc;
 	unsigned int changed_flags;
@@ -86,8 +86,8 @@ void ieee80211_configure_filter(struct ieee80211_local *local)
 
 static void ieee80211_reconfig_filter(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, reconfig_filter);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, reconfig_filter);
 
 	ieee80211_configure_filter(local);
 }
@@ -98,7 +98,7 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
  * configured on the operating channel.  Compares channel-type
  * as well.
  */
-bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
+bool ieee80211_cfg_on_oper_channel(struct mac80211_local *local)
 {
 	struct ieee80211_channel *chan, *scan_chan;
 	enum nl80211_channel_type channel_type;
@@ -133,7 +133,7 @@ bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
 	return true;
 }
 
-int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
+int ieee80211_hw_config(struct mac80211_local *local, u32 changed)
 {
 	struct ieee80211_channel *chan, *scan_chan;
 	int ret = 0;
@@ -234,7 +234,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				      u32 changed)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	static const u8 zero[ETH_ALEN] = { 0 };
 
 	if (!changed)
@@ -324,7 +324,7 @@ u32 ieee80211_reset_erp_info(struct ieee80211_sub_if_data *sdata)
 
 static void ieee80211_tasklet_handler(unsigned long data)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct mac80211_local *local = (struct mac80211_local *) data;
 	struct sk_buff *skb;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
@@ -351,8 +351,8 @@ static void ieee80211_tasklet_handler(unsigned long data)
 
 static void ieee80211_restart_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, restart_work);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, restart_work);
 
 	/* wait for scan work complete */
 	flush_workqueue(local->workqueue);
@@ -371,7 +371,7 @@ static void ieee80211_restart_work(struct work_struct *work)
 
 void ieee80211_restart_hw(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	trace_api_restart_hw(local);
 
@@ -388,8 +388,8 @@ EXPORT_SYMBOL(ieee80211_restart_hw);
 
 static void ieee80211_recalc_smps_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, recalc_smps);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, recalc_smps);
 
 	mutex_lock(&local->iflist_mtx);
 	ieee80211_recalc_smps(local);
@@ -401,8 +401,8 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 				 unsigned long data, void *arg)
 {
 	struct in_ifaddr *ifa = arg;
-	struct ieee80211_local *local =
-		container_of(nb, struct ieee80211_local,
+	struct mac80211_local *local =
+		container_of(nb, struct mac80211_local,
 			     ifa_notifier);
 	struct net_device *ndev = ifa->ifa_dev->dev;
 	struct wireless_dev *wdev = ndev->ieee80211_ptr;
@@ -468,15 +468,15 @@ static int ieee80211_ifa_changed(struct notifier_block *nb,
 
 static int ieee80211_napi_poll(struct napi_struct *napi, int budget)
 {
-	struct ieee80211_local *local =
-		container_of(napi, struct ieee80211_local, napi);
+	struct mac80211_local *local =
+		container_of(napi, struct mac80211_local, napi);
 
 	return local->ops->napi_poll(&local->hw, budget);
 }
 
 void ieee80211_napi_schedule(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	napi_schedule(&local->napi);
 }
@@ -484,7 +484,7 @@ EXPORT_SYMBOL(ieee80211_napi_schedule);
 
 void ieee80211_napi_complete(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	napi_complete(&local->napi);
 }
@@ -549,12 +549,12 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	int priv_size, i;
 	struct wiphy *wiphy;
 
 	/* Ensure 32-byte alignment of our private data and hw private data.
-	 * We use the wiphy priv data for both our ieee80211_local and for
+	 * We use the wiphy priv data for both our mac80211_local and for
 	 * the driver's private data
 	 *
 	 * In memory it'll be like this:
@@ -562,7 +562,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	 * +-------------------------+
 	 * | struct wiphy	    |
 	 * +-------------------------+
-	 * | struct ieee80211_local  |
+	 * | struct mac80211_local  |
 	 * +-------------------------+
 	 * | driver's private data   |
 	 * +-------------------------+
@@ -684,7 +684,7 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	int result, i;
 	enum ieee80211_band band;
 	int channels, max_bitrates;
@@ -980,7 +980,7 @@ EXPORT_SYMBOL(ieee80211_register_hw);
 
 void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	tasklet_kill(&local->tx_pending_tasklet);
 	tasklet_kill(&local->tasklet);
@@ -1032,7 +1032,7 @@ EXPORT_SYMBOL(ieee80211_unregister_hw);
 
 void ieee80211_free_hw(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	mutex_destroy(&local->iflist_mtx);
 	mutex_destroy(&local->mtx);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 69b284c..f39a6ef 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -44,7 +44,7 @@ void ieee80211s_stop(void)
 static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata = (void *) data;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
@@ -206,7 +206,7 @@ int mesh_rmc_check(u8 *sa, struct ieee80211s_hdr *mesh_hdr,
 
 void mesh_mgmt_ies_add(struct sk_buff *skb, struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 	int len, i, rate;
@@ -293,7 +293,7 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
 		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
@@ -308,7 +308,7 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
 
@@ -460,7 +460,7 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	local->fif_other_bss++;
 	/* mesh ifaces must set allmulti to forward mcast traffic */
@@ -481,7 +481,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
 	ifmsh->mesh_id_len = 0;
@@ -510,7 +510,7 @@ static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 					size_t len,
 					struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct ieee80211_channel *channel;
 	u32 supp_rates = 0;
@@ -611,7 +611,7 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 		ieee80211_mesh_rootpath(sdata);
 }
 
-void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
+void ieee80211_mesh_notify_scan_completed(struct mac80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index df4a9a1..d3b0201 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -202,7 +202,7 @@ void mesh_mgmt_ies_add(struct sk_buff *skb,
 void mesh_rmc_free(struct ieee80211_sub_if_data *sdata);
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_init(void);
-void ieee80211s_update_metric(struct ieee80211_local *local,
+void ieee80211s_update_metric(struct mac80211_local *local,
 		struct sta_info *stainfo, struct sk_buff *skb);
 void ieee80211s_stop(void);
 void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata);
@@ -289,7 +289,7 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mesh.mesh_pp_id == IEEE80211_PATH_PROTOCOL_HWMP;
 }
 
-void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
+void ieee80211_mesh_notify_scan_completed(struct mac80211_local *local);
 
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
@@ -298,7 +298,7 @@ void mesh_plink_restart(struct sta_info *sta);
 #else
 #define mesh_allocated	0
 static inline void
-ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
+ieee80211_mesh_notify_scan_completed(struct mac80211_local *local) {}
 static inline void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 {}
 static inline void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 2b18053..dc8746f 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -110,7 +110,7 @@ static int mesh_path_sel_frame_tx(enum mpath_frame_type action, u8 flags,
 		__le32 lifetime, __le32 metric, __le32 preq_id,
 		struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
@@ -204,7 +204,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 		       __le16 target_rcode, const u8 *ra,
 		       struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400);
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos;
@@ -255,7 +255,7 @@ int mesh_path_error_tx(u8 ttl, u8 *target, __le32 target_sn,
 	return 0;
 }
 
-void ieee80211s_update_metric(struct ieee80211_local *local,
+void ieee80211s_update_metric(struct mac80211_local *local,
 		struct sta_info *stainfo, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
@@ -273,7 +273,7 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 		mesh_plink_broken(stainfo);
 }
 
-static u32 airtime_link_metric_get(struct ieee80211_local *local,
+static u32 airtime_link_metric_get(struct mac80211_local *local,
 				   struct sta_info *sta)
 {
 	struct ieee80211_supported_band *sband;
@@ -325,7 +325,7 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
 			    struct ieee80211_mgmt *mgmt,
 			    u8 *hwmp_ie, enum mpath_frame_type action)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct mesh_path *mpath;
 	struct sta_info *sta;
 	bool fresh_info;
diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index bf7989c..c99fb89 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -316,7 +316,7 @@ struct mesh_path *mesh_path_lookup_by_idx(int idx, struct ieee80211_sub_if_data
 int mesh_path_add(u8 *dst, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
@@ -448,7 +448,7 @@ void mesh_mpp_table_grow(void)
 int mpp_path_add(u8 *dst, u8 *mpp, struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct mesh_table *tbl;
 	struct mesh_path *mpath, *new_mpath;
 	struct mpath_node *node, *new_node;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1832c46..a4e2de0 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -95,7 +95,7 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 					 u8 *hw_addr, u32 rates)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	if (local->num_sta >= MESH_MAX_PLINKS)
@@ -159,7 +159,7 @@ void mesh_plink_deactivate(struct sta_info *sta)
 static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		enum plink_frame_type action, u8 *da, __le16 llid, __le16 plid,
 		__le16 reason) {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb = dev_alloc_skb(local->hw.extra_tx_headroom + 400 +
 			sdata->u.mesh.ie_len);
 	struct ieee80211_mgmt *mgmt;
@@ -241,7 +241,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		struct ieee80211_sub_if_data *sdata,
 		struct ieee802_11_elems *elems)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	rcu_read_lock();
@@ -418,7 +418,7 @@ void mesh_plink_block(struct sta_info *sta)
 void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_mgmt *mgmt,
 			 size_t len, struct ieee80211_rx_status *rx_status)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee802_11_elems elems;
 	struct sta_info *sta;
 	enum plink_event event;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2a25ce8..6eb164a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -162,7 +162,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 			       struct ieee80211_ht_info *hti,
 			       const u8 *bssid, u16 ap_ht_cap_flags)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u32 changed = 0;
@@ -265,7 +265,7 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 					   const u8 *bssid, u16 stype, u16 reason,
 					   void *cookie, bool send_frame)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -307,7 +307,7 @@ static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
 		kfree_skb(skb);
 }
 
-void ieee80211_send_pspoll(struct ieee80211_local *local,
+void ieee80211_send_pspoll(struct mac80211_local *local,
 			   struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_pspoll *pspoll;
@@ -324,7 +324,7 @@ void ieee80211_send_pspoll(struct ieee80211_local *local,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-void ieee80211_send_nullfunc(struct ieee80211_local *local,
+void ieee80211_send_nullfunc(struct mac80211_local *local,
 			     struct ieee80211_sub_if_data *sdata,
 			     int powersave)
 {
@@ -343,7 +343,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
+static void ieee80211_send_4addr_nullfunc(struct mac80211_local *local,
 					  struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
@@ -530,7 +530,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
 
 	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION ||
@@ -545,7 +545,7 @@ EXPORT_SYMBOL(ieee80211_enable_dyn_ps);
 void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_conf *conf = &local->hw.conf;
 
 	WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION ||
@@ -561,7 +561,7 @@ void ieee80211_disable_dyn_ps(struct ieee80211_vif *vif)
 EXPORT_SYMBOL(ieee80211_disable_dyn_ps);
 
 /* powersave */
-static void ieee80211_enable_ps(struct ieee80211_local *local,
+static void ieee80211_enable_ps(struct mac80211_local *local,
 				struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
@@ -590,7 +590,7 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 	}
 }
 
-static void ieee80211_change_ps(struct ieee80211_local *local)
+static void ieee80211_change_ps(struct mac80211_local *local)
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
 
@@ -636,7 +636,7 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 }
 
 /* need to hold RTNL or interface lock */
-void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
+void ieee80211_recalc_ps(struct mac80211_local *local, s32 latency)
 {
 	struct ieee80211_sub_if_data *sdata, *found = NULL;
 	int count = 0;
@@ -730,8 +730,8 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local,
 			     dynamic_ps_disable_work);
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS) {
@@ -745,8 +745,8 @@ void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 
 void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local,
 			     dynamic_ps_enable_work);
 	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -806,7 +806,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 
 void ieee80211_dynamic_ps_timer(unsigned long data)
 {
-	struct ieee80211_local *local = (void *) data;
+	struct mac80211_local *local = (void *) data;
 
 	if (local->quiescing || local->suspended)
 		return;
@@ -815,7 +815,7 @@ void ieee80211_dynamic_ps_timer(unsigned long data)
 }
 
 /* MLME */
-static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
+static void ieee80211_sta_wmm_params(struct mac80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
@@ -958,7 +958,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 				     u32 bss_info_changed)
 {
 	struct ieee80211_bss *bss = (void *)cbss->priv;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 
 	bss_info_changed |= BSS_CHANGED_ASSOC;
@@ -1026,7 +1026,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   bool remove_sta, bool tx)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	u32 changed = 0, config_changed = 0;
 	u8 bssid[ETH_ALEN];
@@ -1298,7 +1298,7 @@ EXPORT_SYMBOL(ieee80211_ap_probereq_get);
 static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	u8 bssid[ETH_ALEN];
 
 	mutex_lock(&ifmgd->mtx);
@@ -1430,7 +1430,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	struct cfg80211_bss *cbss = wk->assoc.bss;
@@ -1600,7 +1600,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  struct ieee802_11_elems *elems,
 				  bool beacon)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int freq;
 	struct ieee80211_bss *bss;
 	struct ieee80211_channel *channel;
@@ -1708,7 +1708,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
 	size_t baselen;
 	struct ieee802_11_elems elems;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	u32 changed = 0;
 	bool erp_valid, directed_tim = false;
 	u8 erp_value = 0;
@@ -1957,7 +1957,7 @@ void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
 
 	if (skb->len >= 24 + 2 /* mgmt + deauth reason */ &&
 	    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_DEAUTH) {
-		struct ieee80211_local *local = sdata->local;
+		struct mac80211_local *local = sdata->local;
 		struct ieee80211_work *wk;
 
 		mutex_lock(&local->mtx);
@@ -2003,7 +2003,7 @@ static void ieee80211_sta_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing) {
 		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
@@ -2016,7 +2016,7 @@ static void ieee80211_sta_timer(unsigned long data)
 static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 					  u8 *bssid)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
@@ -2040,7 +2040,7 @@ static void ieee80211_sta_connection_lost(struct ieee80211_sub_if_data *sdata,
 
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/* then process the rest of the work */
@@ -2124,7 +2124,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing)
 		return;
@@ -2138,7 +2138,7 @@ static void ieee80211_sta_conn_mon_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (local->quiescing)
 		return;
@@ -2240,7 +2240,7 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
 }
 
 /* scan finished notification */
-void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
+void ieee80211_mlme_notify_scan_completed(struct mac80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
@@ -2255,8 +2255,8 @@ int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy)
 {
 	s32 latency_usec = (s32) data;
-	struct ieee80211_local *local =
-		container_of(nb, struct ieee80211_local,
+	struct mac80211_local *local =
+		container_of(nb, struct mac80211_local,
 			     network_latency_notifier);
 
 	mutex_lock(&local->iflist_mtx);
@@ -2532,7 +2532,7 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 			 struct cfg80211_deauth_request *req,
 			 void *cookie)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_work *wk;
 	u8 bssid[ETH_ALEN];
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index f6047f9..46814ee 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -26,7 +26,7 @@
 static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
 					   bool tell_ap)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	local->offchannel_ps_enabled = false;
@@ -63,7 +63,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
 /* inform AP that we are awake again, unless power save is enabled */
 static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	if (!local->ps_sdata)
 		ieee80211_send_nullfunc(local, sdata, 0);
@@ -102,7 +102,7 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
-void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
+void ieee80211_offchannel_stop_vifs(struct mac80211_local *local,
 				    bool offchannel_ps_enable)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -137,7 +137,7 @@ void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
+void ieee80211_offchannel_enable_all_ps(struct mac80211_local *local,
 					bool tell_ap)
 {
 	struct ieee80211_sub_if_data *sdata;
@@ -154,7 +154,7 @@ void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
 	mutex_unlock(&local->iflist_mtx);
 }
 
-void ieee80211_offchannel_return(struct ieee80211_local *local,
+void ieee80211_offchannel_return(struct mac80211_local *local,
 				 bool enable_beaconing,
 				 bool offchannel_ps_disable)
 {
@@ -200,8 +200,8 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
 
 static void ieee80211_hw_roc_start(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, hw_roc_start);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, hw_roc_start);
 	struct ieee80211_sub_if_data *sdata;
 
 	mutex_lock(&local->mtx);
@@ -231,7 +231,7 @@ static void ieee80211_hw_roc_start(struct work_struct *work)
 
 void ieee80211_ready_on_channel(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	trace_api_ready_on_channel(local);
 
@@ -241,8 +241,8 @@ EXPORT_SYMBOL_GPL(ieee80211_ready_on_channel);
 
 static void ieee80211_hw_roc_done(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, hw_roc_done);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, hw_roc_done);
 
 	mutex_lock(&local->mtx);
 
@@ -268,7 +268,7 @@ static void ieee80211_hw_roc_done(struct work_struct *work)
 
 void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	trace_api_remain_on_channel_expired(local);
 
@@ -276,7 +276,7 @@ void ieee80211_remain_on_channel_expired(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL_GPL(ieee80211_remain_on_channel_expired);
 
-void ieee80211_hw_roc_setup(struct ieee80211_local *local)
+void ieee80211_hw_roc_setup(struct mac80211_local *local)
 {
 	INIT_WORK(&local->hw_roc_start, ieee80211_hw_roc_start);
 	INIT_WORK(&local->hw_roc_done, ieee80211_hw_roc_done);
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 75cdb9f..bfc9cf3 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -8,7 +8,7 @@
 
 int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 88e2659..1b2eacf 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -150,7 +150,7 @@ static const struct file_operations rcname_ops = {
 #endif
 
 static struct rate_control_ref *rate_control_alloc(const char *name,
-					    struct ieee80211_local *local)
+					    struct mac80211_local *local)
 {
 	struct dentry *debugfsdir = NULL;
 	struct rate_control_ref *ref;
@@ -364,7 +364,7 @@ void rate_control_put(struct rate_control_ref *ref)
 	kref_put(&ref->kref, rate_control_release);
 }
 
-int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
+int ieee80211_init_rate_ctrl_alg(struct mac80211_local *local,
 				 const char *name)
 {
 	struct rate_control_ref *ref, *old;
@@ -400,7 +400,7 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 	return 0;
 }
 
-void rate_control_deinitialize(struct ieee80211_local *local)
+void rate_control_deinitialize(struct mac80211_local *local)
 {
 	struct rate_control_ref *ref;
 
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index b22c1de..5693817 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -20,7 +20,7 @@
 #include "sta_info.h"
 
 struct rate_control_ref {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct rate_control_ops *ops;
 	void *priv;
 	struct kref kref;
@@ -32,7 +32,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 struct rate_control_ref *rate_control_get(struct rate_control_ref *ref);
 void rate_control_put(struct rate_control_ref *ref);
 
-static inline void rate_control_tx_status(struct ieee80211_local *local,
+static inline void rate_control_tx_status(struct mac80211_local *local,
 					  struct ieee80211_supported_band *sband,
 					  struct sta_info *sta,
 					  struct sk_buff *skb)
@@ -50,7 +50,7 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 
 static inline void rate_control_rate_init(struct sta_info *sta)
 {
-	struct ieee80211_local *local = sta->sdata->local;
+	struct mac80211_local *local = sta->sdata->local;
 	struct rate_control_ref *ref = sta->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
@@ -64,7 +64,7 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 }
 
-static inline void rate_control_rate_update(struct ieee80211_local *local,
+static inline void rate_control_rate_update(struct mac80211_local *local,
 				    struct ieee80211_supported_band *sband,
 				    struct sta_info *sta, u32 changed,
 				    enum nl80211_channel_type oper_chan_type)
@@ -115,9 +115,9 @@ static inline void rate_control_remove_sta_debugfs(struct sta_info *sta)
 
 /* Get a reference to the rate control algorithm. If `name' is NULL, get the
  * first available algorithm. */
-int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
+int ieee80211_init_rate_ctrl_alg(struct mac80211_local *local,
 				 const char *name);
-void rate_control_deinitialize(struct ieee80211_local *local);
+void rate_control_deinitialize(struct mac80211_local *local);
 
 
 /* Rate control algorithms */
diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
index 58a8955..6a9d98e 100644
--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -334,7 +334,7 @@ minstrel_get_rate(void *priv, struct ieee80211_sta *sta,
 
 
 static void
-calc_rate_durations(struct minstrel_sta_info *mi, struct ieee80211_local *local,
+calc_rate_durations(struct minstrel_sta_info *mi, struct mac80211_local *local,
                     struct minstrel_rate *d, struct ieee80211_rate *rate)
 {
 	int erp = !!(rate->flags & IEEE80211_RATE_ERP_G);
@@ -379,7 +379,7 @@ minstrel_rate_init(void *priv, struct ieee80211_supported_band *sband,
 {
 	struct minstrel_sta_info *mi = priv_sta;
 	struct minstrel_priv *mp = priv;
-	struct ieee80211_local *local = hw_to_local(mp->hw);
+	struct mac80211_local *local = hw_to_local(mp->hw);
 	struct ieee80211_rate *ctl_rate;
 	unsigned int i, n = 0;
 	unsigned int t_slot = 9; /* FIXME: get real slot time */
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 66a1eeb..0aef63a 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -679,7 +679,7 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	struct minstrel_ht_sta_priv *msp = priv_sta;
 	struct minstrel_ht_sta *mi = &msp->ht;
 	struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
-	struct ieee80211_local *local = hw_to_local(mp->hw);
+	struct mac80211_local *local = hw_to_local(mp->hw);
 	u16 sta_cap = sta->ht_cap.cap;
 	int n_supported = 0;
 	int ack_dur;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3c0dbf2..22d066d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -34,7 +34,7 @@
  * This function cleans up the SKB, i.e. it removes all the stuff
  * only useful for monitoring.
  */
-static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
+static struct sk_buff *remove_monitor_info(struct mac80211_local *local,
 					   struct sk_buff *skb)
 {
 	if (local->hw.flags & IEEE80211_HW_RX_INCLUDES_FCS) {
@@ -69,7 +69,7 @@ static inline int should_drop_frame(struct sk_buff *skb,
 }
 
 static int
-ieee80211_rx_radiotap_len(struct ieee80211_local *local,
+ieee80211_rx_radiotap_len(struct mac80211_local *local,
 			  struct ieee80211_rx_status *status)
 {
 	int len;
@@ -97,7 +97,7 @@ ieee80211_rx_radiotap_len(struct ieee80211_local *local,
  * add a radiotap header containing all the fields which the hardware provided.
  */
 static void
-ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
+ieee80211_add_rx_radiotap_header(struct mac80211_local *local,
 				 struct sk_buff *skb,
 				 struct ieee80211_rate *rate,
 				 int rtap_len)
@@ -216,7 +216,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
  * radiotap header the driver might have added.
  */
 static struct sk_buff *
-ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
+ieee80211_rx_monitor(struct mac80211_local *local, struct sk_buff *origskb,
 		     struct ieee80211_rate *rate)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(origskb);
@@ -400,7 +400,7 @@ static void ieee80211_verify_alignment(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	struct sk_buff *skb = rx->skb;
 
@@ -550,7 +550,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 					    struct tid_ampdu_rx *tid_agg_rx,
 					    int index)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
 	struct ieee80211_rx_status *status;
 
@@ -742,7 +742,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta = rx->sta;
@@ -1059,7 +1059,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *skb;
 
@@ -1092,7 +1092,7 @@ ieee80211_rx_h_check_more_data(struct ieee80211_rx_data *rx)
 static void ap_sta_ps_start(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	atomic_inc(&sdata->bss->num_sta_ps);
 	set_sta_flags(sta, WLAN_STA_PS_STA);
@@ -1809,7 +1809,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211s_hdr *mesh_hdr;
 	unsigned int hdrlen;
 	struct sk_buff *skb = rx->skb, *fwd_skb;
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 
@@ -1922,7 +1922,7 @@ static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct net_device *dev = sdata->dev;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)rx->skb->data;
 	__le16 fc = hdr->frame_control;
@@ -1980,7 +1980,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
@@ -2037,7 +2037,7 @@ static void ieee80211_process_sa_query_req(struct ieee80211_sub_if_data *sdata,
 					   struct ieee80211_mgmt *mgmt,
 					   size_t len)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *resp;
 
@@ -2108,7 +2108,7 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
@@ -2274,7 +2274,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct sk_buff *nskb;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
@@ -2378,7 +2378,7 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 					struct ieee80211_rate *rate)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_rtap_hdr {
 		struct ieee80211_radiotap_header hdr;
 		u8 flags;
@@ -2703,7 +2703,7 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 					    struct sk_buff *skb, bool consume)
 {
-	struct ieee80211_local *local = rx->local;
+	struct mac80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (void *)skb->data;
@@ -2741,7 +2741,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
@@ -2848,7 +2848,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
  */
 void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -2951,7 +2951,7 @@ EXPORT_SYMBOL(ieee80211_rx);
  * context. Post the skb on the queue and schedule the tasklet */
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c21b720..e7b8be2 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -28,7 +28,7 @@
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 8)
 
 struct ieee80211_bss *
-ieee80211_rx_bss_get(struct ieee80211_local *local, u8 *bssid, int freq,
+ieee80211_rx_bss_get(struct mac80211_local *local, u8 *bssid, int freq,
 		     u8 *ssid, u8 ssid_len)
 {
 	struct cfg80211_bss *cbss;
@@ -49,7 +49,7 @@ static void ieee80211_rx_bss_free(struct cfg80211_bss *cbss)
 	kfree(bss_mesh_cfg(bss));
 }
 
-void ieee80211_rx_bss_put(struct ieee80211_local *local,
+void ieee80211_rx_bss_put(struct mac80211_local *local,
 			  struct ieee80211_bss *bss)
 {
 	if (!bss)
@@ -75,7 +75,7 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 }
 
 struct ieee80211_bss *
-ieee80211_bss_info_update(struct ieee80211_local *local,
+ieee80211_bss_info_update(struct mac80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
 			  struct ieee80211_mgmt *mgmt,
 			  size_t len,
@@ -225,7 +225,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 }
 
 /* return false if no more work */
-static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
+static bool ieee80211_prep_hw_scan(struct mac80211_local *local)
 {
 	struct cfg80211_scan_request *req = local->scan_req;
 	enum ieee80211_band band;
@@ -261,7 +261,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 				       bool was_hw_scan)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	bool on_oper_chan;
 	bool enable_beacons = false;
 
@@ -327,7 +327,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted,
 
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	trace_api_scan_completed(local, aborted);
 
@@ -338,7 +338,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
-static int ieee80211_start_sw_scan(struct ieee80211_local *local)
+static int ieee80211_start_sw_scan(struct mac80211_local *local)
 {
 	/*
 	 * Hardware/driver doesn't support hw_scan, so use software
@@ -381,7 +381,7 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
 static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_scan_request *req)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int rc;
 
 	lockdep_assert_held(&local->mtx);
@@ -467,7 +467,7 @@ ieee80211_scan_get_channel_time(struct ieee80211_channel *chan)
 	return IEEE80211_PROBE_DELAY + IEEE80211_CHANNEL_TIME;
 }
 
-static void ieee80211_scan_state_decision(struct ieee80211_local *local,
+static void ieee80211_scan_state_decision(struct mac80211_local *local,
 					  unsigned long *next_delay)
 {
 	bool associated = false;
@@ -557,7 +557,7 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
 	*next_delay = 0;
 }
 
-static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
+static void ieee80211_scan_state_leave_oper_channel(struct mac80211_local *local,
 						    unsigned long *next_delay)
 {
 	/* PS will already be in off-channel mode,
@@ -581,7 +581,7 @@ static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *loca
 	local->next_scan_state = SCAN_SET_CHANNEL;
 }
 
-static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *local,
+static void ieee80211_scan_state_enter_oper_channel(struct mac80211_local *local,
 						    unsigned long *next_delay)
 {
 	/* switch back to the operating channel */
@@ -600,7 +600,7 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
 	local->next_scan_state = SCAN_DECISION;
 }
 
-static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
+static void ieee80211_scan_state_set_channel(struct mac80211_local *local,
 					     unsigned long *next_delay)
 {
 	int skip;
@@ -647,7 +647,7 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	local->next_scan_state = SCAN_SEND_PROBE;
 }
 
-static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
+static void ieee80211_scan_state_send_probe(struct mac80211_local *local,
 					    unsigned long *next_delay)
 {
 	int i;
@@ -670,8 +670,8 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 
 void ieee80211_scan_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, scan_work.work);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, scan_work.work);
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long next_delay = 0;
 	bool aborted, hw_scan;
@@ -773,7 +773,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 				    const u8 *ssid, u8 ssid_len,
 				    struct ieee80211_channel *chan)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int ret = -EBUSY;
 	enum ieee80211_band band;
 
@@ -819,7 +819,7 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
 /*
  * Only call this function when a scan can't be queued -- under RTNL.
  */
-void ieee80211_scan_cancel(struct ieee80211_local *local)
+void ieee80211_scan_cancel(struct mac80211_local *local)
 {
 	bool abortscan;
 
@@ -859,7 +859,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
 				       struct cfg80211_sched_scan_request *req)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int ret, i;
 
 	mutex_lock(&sdata->local->mtx);
@@ -908,7 +908,7 @@ out:
 
 int ieee80211_request_sched_scan_stop(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int ret = 0, i;
 
 	mutex_lock(&sdata->local->mtx);
@@ -933,7 +933,7 @@ out:
 
 void ieee80211_sched_scan_results(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	trace_api_sched_scan_results(local);
 
@@ -943,8 +943,8 @@ EXPORT_SYMBOL(ieee80211_sched_scan_results);
 
 void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local,
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local,
 			     sched_scan_stopped_work);
 	int i;
 
@@ -967,7 +967,7 @@ void ieee80211_sched_scan_stopped_work(struct work_struct *work)
 
 void ieee80211_sched_scan_stopped(struct ieee80211_hw *hw)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	trace_api_sched_scan_stopped(local);
 
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 667cc06..fe1e76d 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -26,7 +26,7 @@ static void ieee80211_send_refuse_measurement_request(struct ieee80211_sub_if_da
 					const u8 *da, const u8 *bssid,
 					u8 dialog_token)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *msr_report;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e125bc4..5f649aa 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -62,7 +62,7 @@
  */
 
 /* Caller must hold local->sta_lock */
-static int sta_info_hash_del(struct ieee80211_local *local,
+static int sta_info_hash_del(struct mac80211_local *local,
 			     struct sta_info *sta)
 {
 	struct sta_info *s;
@@ -93,7 +93,7 @@ static int sta_info_hash_del(struct ieee80211_local *local,
 struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 			      const u8 *addr)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
@@ -119,7 +119,7 @@ struct sta_info *sta_info_get(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 
 	sta = rcu_dereference_check(local->sta_hash[STA_HASH(addr)],
@@ -142,7 +142,7 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 				     int idx)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	int i = 0;
 
@@ -168,7 +168,7 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
  * This function must undo everything done by sta_info_alloc()
  * that may happen before sta_info_insert().
  */
-static void __sta_info_free(struct ieee80211_local *local,
+static void __sta_info_free(struct mac80211_local *local,
 			    struct sta_info *sta)
 {
 	if (sta->rate_ctrl) {
@@ -184,7 +184,7 @@ static void __sta_info_free(struct ieee80211_local *local,
 }
 
 /* Caller must hold local->sta_lock */
-static void sta_info_hash_add(struct ieee80211_local *local,
+static void sta_info_hash_add(struct mac80211_local *local,
 			      struct sta_info *sta)
 {
 	sta->hnext = local->sta_hash[STA_HASH(sta->sta.addr)];
@@ -209,7 +209,7 @@ static void sta_unblock(struct work_struct *wk)
 		clear_sta_flags(sta, WLAN_STA_PS_DRIVER);
 }
 
-static int sta_prepare_rate_control(struct ieee80211_local *local,
+static int sta_prepare_rate_control(struct mac80211_local *local,
 				    struct sta_info *sta, gfp_t gfp)
 {
 	if (local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL)
@@ -229,7 +229,7 @@ static int sta_prepare_rate_control(struct ieee80211_local *local,
 struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 				u8 *addr, gfp_t gfp)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta;
 	struct timespec uptime;
 	int i;
@@ -286,7 +286,7 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 static int sta_info_finish_insert(struct sta_info *sta, bool async)
 {
-	struct ieee80211_local *local = sta->local;
+	struct mac80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	struct station_info sinfo;
 	unsigned long flags;
@@ -342,7 +342,7 @@ static int sta_info_finish_insert(struct sta_info *sta, bool async)
 	return 0;
 }
 
-static void sta_info_finish_pending(struct ieee80211_local *local)
+static void sta_info_finish_pending(struct mac80211_local *local)
 {
 	struct sta_info *sta;
 	unsigned long flags;
@@ -363,8 +363,8 @@ static void sta_info_finish_pending(struct ieee80211_local *local)
 
 static void sta_info_finish_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, sta_finish_work);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, sta_finish_work);
 
 	mutex_lock(&local->sta_mtx);
 	sta_info_finish_pending(local);
@@ -373,7 +373,7 @@ static void sta_info_finish_work(struct work_struct *work)
 
 int sta_info_insert_rcu(struct sta_info *sta) __acquires(RCU)
 {
-	struct ieee80211_local *local = sta->local;
+	struct mac80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	unsigned long flags;
 	int err = 0;
@@ -585,7 +585,7 @@ static int sta_info_buffer_expired(struct sta_info *sta,
 }
 
 
-static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
+static bool sta_info_cleanup_expire_buffered(struct mac80211_local *local,
 					     struct sta_info *sta)
 {
 	unsigned long flags;
@@ -623,7 +623,7 @@ static bool sta_info_cleanup_expire_buffered(struct ieee80211_local *local,
 
 static int __must_check __sta_info_destroy(struct sta_info *sta)
 {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct sk_buff *skb;
 	unsigned long flags;
@@ -759,7 +759,7 @@ int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 
 static void sta_info_cleanup(unsigned long data)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct mac80211_local *local = (struct mac80211_local *) data;
 	struct sta_info *sta;
 	bool timer_needed = false;
 
@@ -779,7 +779,7 @@ static void sta_info_cleanup(unsigned long data)
 		  round_jiffies(jiffies + STA_INFO_CLEANUP_INTERVAL));
 }
 
-void sta_info_init(struct ieee80211_local *local)
+void sta_info_init(struct mac80211_local *local)
 {
 	spin_lock_init(&local->sta_lock);
 	mutex_init(&local->sta_mtx);
@@ -791,7 +791,7 @@ void sta_info_init(struct ieee80211_local *local)
 		    (unsigned long)local);
 }
 
-void sta_info_stop(struct ieee80211_local *local)
+void sta_info_stop(struct mac80211_local *local)
 {
 	del_timer(&local->sta_cleanup);
 	sta_info_flush(local, NULL);
@@ -805,7 +805,7 @@ void sta_info_stop(struct ieee80211_local *local)
  * @local: local interface data
  * @sdata: matching rule for the net device (sta->dev) or %NULL to match all STAs
  */
-int sta_info_flush(struct ieee80211_local *local,
+int sta_info_flush(struct mac80211_local *local,
 		   struct ieee80211_sub_if_data *sdata)
 {
 	struct sta_info *sta, *tmp;
@@ -829,7 +829,7 @@ int sta_info_flush(struct ieee80211_local *local,
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta, *tmp;
 
 	mutex_lock(&local->sta_mtx);
@@ -897,7 +897,7 @@ static void clear_sta_ps_flags(void *_sta)
 void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int sent, buffered;
 
 	clear_sta_flags(sta, WLAN_STA_PS_DRIVER_BUF);
@@ -924,7 +924,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 void ieee80211_sta_ps_deliver_poll_response(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	int no_pending_pkts;
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index a06d64e..3623a2d 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -247,7 +247,7 @@ struct sta_info {
 	/* General information, mostly static */
 	struct list_head list;
 	struct sta_info __rcu *hnext;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_key __rcu *gtk[NUM_DEFAULT_KEYS + NUM_DEFAULT_MGMT_KEYS];
 	struct ieee80211_key __rcu *ptk;
@@ -439,7 +439,7 @@ struct sta_info *sta_info_get_bss(struct ieee80211_sub_if_data *sdata,
 				  const u8 *addr);
 
 static inline
-void for_each_sta_info_type_check(struct ieee80211_local *local,
+void for_each_sta_info_type_check(struct mac80211_local *local,
 				  const u8 *addr,
 				  struct sta_info *sta,
 				  struct sta_info *nxt)
@@ -492,9 +492,9 @@ int sta_info_destroy_addr_bss(struct ieee80211_sub_if_data *sdata,
 void sta_info_set_tim_bit(struct sta_info *sta);
 void sta_info_clear_tim_bit(struct sta_info *sta);
 
-void sta_info_init(struct ieee80211_local *local);
-void sta_info_stop(struct ieee80211_local *local);
-int sta_info_flush(struct ieee80211_local *local,
+void sta_info_init(struct mac80211_local *local);
+void sta_info_stop(struct mac80211_local *local);
+int sta_info_flush(struct mac80211_local *local,
 		   struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_expire(struct ieee80211_sub_if_data *sdata,
 			  unsigned long exp_time);
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index b69e8af..26d2c40 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -19,7 +19,7 @@
 void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 				 struct sk_buff *skb)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int tmp;
 
@@ -38,7 +38,7 @@ void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_status_irqsafe);
 
-static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
+static void ieee80211_handle_filtered_frame(struct mac80211_local *local,
 					    struct sta_info *sta,
 					    struct sk_buff *skb)
 {
@@ -130,7 +130,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (void *) skb->data;
-	struct ieee80211_local *local = sta->local;
+	struct mac80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
 	if (ieee80211_is_action(mgmt->frame_control) &&
@@ -174,7 +174,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct sk_buff *skb2;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u16 frag, type;
 	__le16 fc;
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 4ed89f3..99c9ab8 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -40,7 +40,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 {
 	int rate, mrate, erp, dur, i;
 	struct ieee80211_rate *txrate;
-	struct ieee80211_local *local = tx->local;
+	struct mac80211_local *local = tx->local;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
@@ -169,7 +169,7 @@ static __le16 ieee80211_duration(struct ieee80211_tx_data *tx, int group_addr,
 	return cpu_to_le16(dur);
 }
 
-static inline int is_ieee80211_device(struct ieee80211_local *local,
+static inline int is_ieee80211_device(struct mac80211_local *local,
 				      struct net_device *dev)
 {
 	return local == wdev_priv(dev->ieee80211_ptr);
@@ -179,7 +179,7 @@ static inline int is_ieee80211_device(struct ieee80211_local *local,
 static ieee80211_tx_result debug_noinline
 ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 {
-	struct ieee80211_local *local = tx->local;
+	struct mac80211_local *local = tx->local;
 	struct ieee80211_if_managed *ifmgd;
 
 	/* driver doesn't support power save */
@@ -318,7 +318,7 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
  * of buffered frames for power saving STAs. This situation should not really
  * happen often during normal operation, so dropping the oldest buffered packet
  * from each queue should be OK to make some room for new frames. */
-static void purge_old_ps_buffers(struct ieee80211_local *local)
+static void purge_old_ps_buffers(struct mac80211_local *local)
 {
 	int total = 0, purged = 0;
 	struct sk_buff *skb;
@@ -434,7 +434,7 @@ ieee80211_tx_h_unicast_ps_buf(struct ieee80211_tx_data *tx)
 	struct sta_info *sta = tx->sta;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx->skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx->skb->data;
-	struct ieee80211_local *local = tx->local;
+	struct mac80211_local *local = tx->local;
 	u32 staflags;
 
 	if (unlikely(!sta ||
@@ -833,7 +833,7 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	return TX_CONTINUE;
 }
 
-static int ieee80211_fragment(struct ieee80211_local *local,
+static int ieee80211_fragment(struct mac80211_local *local,
 			      struct sk_buff *skb, int hdrlen,
 			      int frag_threshold)
 {
@@ -1177,7 +1177,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		     struct ieee80211_tx_data *tx,
 		     struct sk_buff *skb)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int hdrlen, tid;
@@ -1285,7 +1285,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 /*
  * Returns false if the frame couldn't be transmitted but was queued instead.
  */
-static bool __ieee80211_tx(struct ieee80211_local *local, struct sk_buff **skbp,
+static bool __ieee80211_tx(struct mac80211_local *local, struct sk_buff **skbp,
 			   struct sta_info *sta, bool txpending)
 {
 	struct sk_buff *skb = *skbp, *next;
@@ -1439,7 +1439,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb, bool txpending)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1474,7 +1474,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 /* device xmit handlers */
 
-static int ieee80211_skb_resize(struct ieee80211_local *local,
+static int ieee80211_skb_resize(struct mac80211_local *local,
 				struct sk_buff *skb,
 				int head_need, bool may_encrypt)
 {
@@ -1518,7 +1518,7 @@ static int ieee80211_skb_resize(struct ieee80211_local *local,
 static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_sub_if_data *tmp_sdata;
@@ -1604,7 +1604,7 @@ static void ieee80211_xmit(struct ieee80211_sub_if_data *sdata,
 netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct mac80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_channel *chan = local->hw.conf.channel;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
@@ -1692,7 +1692,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				    struct net_device *dev)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_info *info;
 	int ret = NETDEV_TX_BUSY, head_need;
 	u16 ethertype, hdrlen,  meshhdrlen = 0;
@@ -2009,7 +2009,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
  * ieee80211_clear_tx_pending may not be called in a context where
  * it is possible that it packets could come in again.
  */
-void ieee80211_clear_tx_pending(struct ieee80211_local *local)
+void ieee80211_clear_tx_pending(struct mac80211_local *local)
 {
 	int i;
 
@@ -2022,7 +2022,7 @@ void ieee80211_clear_tx_pending(struct ieee80211_local *local)
  * which in this case means re-queued -- take as an indication to stop sending
  * more pending frames.
  */
-static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
+static bool ieee80211_tx_pending_skb(struct mac80211_local *local,
 				     struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -2050,7 +2050,7 @@ static bool ieee80211_tx_pending_skb(struct ieee80211_local *local,
  */
 void ieee80211_tx_pending(unsigned long data)
 {
-	struct ieee80211_local *local = (struct ieee80211_local *)data;
+	struct mac80211_local *local = (struct mac80211_local *)data;
 	struct ieee80211_sub_if_data *sdata;
 	unsigned long flags;
 	int i;
@@ -2166,7 +2166,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
 					 u16 *tim_offset, u16 *tim_length)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
@@ -2325,7 +2325,7 @@ struct sk_buff *ieee80211_pspoll_get(struct ieee80211_hw *hw,
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_managed *ifmgd;
 	struct ieee80211_pspoll *pspoll;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct sk_buff *skb;
 
 	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
@@ -2365,7 +2365,7 @@ struct sk_buff *ieee80211_nullfunc_get(struct ieee80211_hw *hw,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_managed *ifmgd;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct sk_buff *skb;
 
 	if (WARN_ON(vif->type != NL80211_IFTYPE_STATION))
@@ -2403,7 +2403,7 @@ struct sk_buff *ieee80211_probereq_get(struct ieee80211_hw *hw,
 				       const u8 *ie, size_t ie_len)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	struct ieee80211_hdr_3addr *hdr;
 	struct sk_buff *skb;
 	size_t ie_ssid_len;
@@ -2482,7 +2482,7 @@ struct sk_buff *
 ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_data tx;
 	struct ieee80211_sub_if_data *sdata;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 4be7132..ae6daaa 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -37,7 +37,7 @@ void *mac80211_wiphy_privid = &mac80211_wiphy_privid;
 
 struct ieee80211_hw *wiphy_to_ieee80211_hw(struct wiphy *wiphy)
 {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 	BUG_ON(!wiphy);
 
 	local = wiphy_priv(wiphy);
@@ -105,7 +105,7 @@ void ieee80211_tx_set_protected(struct ieee80211_tx_data *tx)
 	} while ((skb = skb->next));
 }
 
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+int ieee80211_frame_duration(struct mac80211_local *local, size_t len,
 			     int rate, int erp, int short_preamble)
 {
 	int dur;
@@ -164,7 +164,7 @@ __le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
 					size_t frame_len,
 					struct ieee80211_rate *rate)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	u16 dur;
 	int erp;
@@ -189,7 +189,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif, size_t frame_len,
 			      const struct ieee80211_tx_info *frame_txctl)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
@@ -230,7 +230,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 				    size_t frame_len,
 				    const struct ieee80211_tx_info *frame_txctl)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata;
 	bool short_preamble;
@@ -267,7 +267,7 @@ EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
 	trace_wake_queue(local, queue, reason);
@@ -296,7 +296,7 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
 void ieee80211_wake_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
@@ -314,7 +314,7 @@ EXPORT_SYMBOL(ieee80211_wake_queue);
 static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 				   enum queue_stop_reason reason)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
 	trace_stop_queue(local, queue, reason);
@@ -333,7 +333,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
 void ieee80211_stop_queue_by_reason(struct ieee80211_hw *hw, int queue,
 				    enum queue_stop_reason reason)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
@@ -348,7 +348,7 @@ void ieee80211_stop_queue(struct ieee80211_hw *hw, int queue)
 }
 EXPORT_SYMBOL(ieee80211_stop_queue);
 
-void ieee80211_add_pending_skb(struct ieee80211_local *local,
+void ieee80211_add_pending_skb(struct mac80211_local *local,
 			       struct sk_buff *skb)
 {
 	struct ieee80211_hw *hw = &local->hw;
@@ -368,7 +368,7 @@ void ieee80211_add_pending_skb(struct ieee80211_local *local,
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 }
 
-int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
+int ieee80211_add_pending_skbs_fn(struct mac80211_local *local,
 				  struct sk_buff_head *skbs,
 				  void (*fn)(void *data), void *data)
 {
@@ -406,7 +406,7 @@ int ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 	return ret;
 }
 
-int ieee80211_add_pending_skbs(struct ieee80211_local *local,
+int ieee80211_add_pending_skbs(struct mac80211_local *local,
 			       struct sk_buff_head *skbs)
 {
 	return ieee80211_add_pending_skbs_fn(local, skbs, NULL, NULL);
@@ -415,7 +415,7 @@ int ieee80211_add_pending_skbs(struct ieee80211_local *local,
 void ieee80211_stop_queues_by_reason(struct ieee80211_hw *hw,
 				    enum queue_stop_reason reason)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 	int i;
 
@@ -436,7 +436,7 @@ EXPORT_SYMBOL(ieee80211_stop_queues);
 
 int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 	int ret;
 
@@ -453,7 +453,7 @@ EXPORT_SYMBOL(ieee80211_queue_stopped);
 void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
 				     enum queue_stop_reason reason)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	unsigned long flags;
 	int i;
 
@@ -477,7 +477,7 @@ void ieee80211_iterate_active_interfaces(
 			 struct ieee80211_vif *vif),
 	void *data)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
 	mutex_lock(&local->iflist_mtx);
@@ -505,7 +505,7 @@ void ieee80211_iterate_active_interfaces_atomic(
 			 struct ieee80211_vif *vif),
 	void *data)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 
 	rcu_read_lock();
@@ -534,7 +534,7 @@ EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces_atomic);
  * mac80211 stuffing into the workqueue which we haven't yet
  * cleared during mac80211's suspend cycle.
  */
-static bool ieee80211_can_queue_work(struct ieee80211_local *local)
+static bool ieee80211_can_queue_work(struct mac80211_local *local)
 {
 	if (WARN(local->suspended && !local->resuming,
 		 "queueing ieee80211 work while going to suspend\n"))
@@ -545,7 +545,7 @@ static bool ieee80211_can_queue_work(struct ieee80211_local *local)
 
 void ieee80211_queue_work(struct ieee80211_hw *hw, struct work_struct *work)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	if (!ieee80211_can_queue_work(local))
 		return;
@@ -558,7 +558,7 @@ void ieee80211_queue_delayed_work(struct ieee80211_hw *hw,
 				  struct delayed_work *dwork,
 				  unsigned long delay)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct mac80211_local *local = hw_to_local(hw);
 
 	if (!ieee80211_can_queue_work(local))
 		return;
@@ -741,7 +741,7 @@ u32 ieee802_11_parse_elems_crc(u8 *start, size_t len,
 
 void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_tx_queue_params qparam;
 	int queue;
 	bool use_11b;
@@ -816,7 +816,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const size_t supp_rates_len,
 				  const u8 *supp_rates)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	int i, have_higher_than_11mbit = 0;
 
 	/* cf. IEEE 802.11 9.2.12 */
@@ -833,7 +833,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 	ieee80211_set_wmm_default(sdata);
 }
 
-u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
+u32 ieee80211_mandatory_rates(struct mac80211_local *local,
 			      enum ieee80211_band band)
 {
 	struct ieee80211_supported_band *sband;
@@ -866,7 +866,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
 			 const u8 *key, u8 key_len, u8 key_idx)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	int err;
@@ -903,7 +903,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
+int ieee80211_build_preq_ies(struct mac80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
 			     u8 channel)
@@ -1020,7 +1020,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  const u8 *ssid, size_t ssid_len,
 					  const u8 *ie, size_t ie_len)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	size_t buf_len;
@@ -1071,7 +1071,7 @@ void ieee80211_send_probe_req(struct ieee80211_sub_if_data *sdata, u8 *dst,
 		ieee80211_tx_skb(sdata, skb);
 }
 
-u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
+u32 ieee80211_sta_get_rates(struct mac80211_local *local,
 			    struct ieee802_11_elems *elems,
 			    enum ieee80211_band band)
 {
@@ -1107,7 +1107,7 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
 	return supp_rates;
 }
 
-void ieee80211_stop_device(struct ieee80211_local *local)
+void ieee80211_stop_device(struct mac80211_local *local)
 {
 	ieee80211_led_radio(local, false);
 	ieee80211_mod_tpt_led_trig(local, 0, IEEE80211_TPT_LEDTRIG_FL_RADIO);
@@ -1118,7 +1118,7 @@ void ieee80211_stop_device(struct ieee80211_local *local)
 	drv_stop(local);
 }
 
-int ieee80211_reconfig(struct ieee80211_local *local)
+int ieee80211_reconfig(struct mac80211_local *local)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_sub_if_data *sdata;
@@ -1341,7 +1341,7 @@ static int check_mgd_smps(struct ieee80211_if_managed *ifmgd,
 }
 
 /* must hold iflist_mtx */
-void ieee80211_recalc_smps(struct ieee80211_local *local)
+void ieee80211_recalc_smps(struct mac80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 	enum ieee80211_smps_mode smps_mode = IEEE80211_SMPS_OFF;
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index cf15e91..0f599fb 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -25,7 +25,7 @@
 #include "wep.h"
 
 
-int ieee80211_wep_init(struct ieee80211_local *local)
+int ieee80211_wep_init(struct mac80211_local *local)
 {
 	/* start WEP IV from a random value */
 	get_random_bytes(&local->wep_iv, WEP_IV_LEN);
@@ -46,7 +46,7 @@ int ieee80211_wep_init(struct ieee80211_local *local)
 	return 0;
 }
 
-void ieee80211_wep_free(struct ieee80211_local *local)
+void ieee80211_wep_free(struct mac80211_local *local)
 {
 	if (!IS_ERR(local->wep_tx_tfm))
 		crypto_free_cipher(local->wep_tx_tfm);
@@ -70,7 +70,7 @@ static inline bool ieee80211_wep_weak_iv(u32 iv, int keylen)
 }
 
 
-static void ieee80211_wep_get_iv(struct ieee80211_local *local,
+static void ieee80211_wep_get_iv(struct mac80211_local *local,
 				 int keylen, int keyidx, u8 *iv)
 {
 	local->wep_iv++;
@@ -87,7 +87,7 @@ static void ieee80211_wep_get_iv(struct ieee80211_local *local,
 }
 
 
-static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
+static u8 *ieee80211_wep_add_iv(struct mac80211_local *local,
 				struct sk_buff *skb,
 				int keylen, int keyidx)
 {
@@ -109,7 +109,7 @@ static u8 *ieee80211_wep_add_iv(struct ieee80211_local *local,
 }
 
 
-static void ieee80211_wep_remove_iv(struct ieee80211_local *local,
+static void ieee80211_wep_remove_iv(struct mac80211_local *local,
 				    struct sk_buff *skb,
 				    struct ieee80211_key *key)
 {
@@ -152,7 +152,7 @@ int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
  *
  * WEP frame payload: IV + TX key idx, RC4(data), ICV = RC4(CRC32(data))
  */
-int ieee80211_wep_encrypt(struct ieee80211_local *local,
+int ieee80211_wep_encrypt(struct mac80211_local *local,
 			  struct sk_buff *skb,
 			  const u8 *key, int keylen, int keyidx)
 {
@@ -213,7 +213,7 @@ int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
  * failure. If frame is OK, IV and ICV will be removed, i.e., decrypted payload
  * is moved to the beginning of the skb and skb length will be reduced.
  */
-static int ieee80211_wep_decrypt(struct ieee80211_local *local,
+static int ieee80211_wep_decrypt(struct mac80211_local *local,
 				 struct sk_buff *skb,
 				 struct ieee80211_key *key)
 {
diff --git a/net/mac80211/wep.h b/net/mac80211/wep.h
index f265c02..1ef436c 100644
--- a/net/mac80211/wep.h
+++ b/net/mac80211/wep.h
@@ -16,11 +16,11 @@
 #include "mac80211_i.h"
 #include "key.h"
 
-int ieee80211_wep_init(struct ieee80211_local *local);
-void ieee80211_wep_free(struct ieee80211_local *local);
+int ieee80211_wep_init(struct mac80211_local *local);
+void ieee80211_wep_free(struct mac80211_local *local);
 int ieee80211_wep_encrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
 				size_t klen, u8 *data, size_t data_len);
-int ieee80211_wep_encrypt(struct ieee80211_local *local,
+int ieee80211_wep_encrypt(struct mac80211_local *local,
 			  struct sk_buff *skb,
 			  const u8 *key, int keylen, int keyidx);
 int ieee80211_wep_decrypt_data(struct crypto_cipher *tfm, u8 *rc4key,
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 74f60ab..e20a843 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -57,7 +57,7 @@ static int wme_downgrade_ac(struct sk_buff *skb)
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sta_info *sta = NULL;
 	const u8 *ra = NULL;
 	bool qos = false;
@@ -119,7 +119,7 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 	return ieee80211_downgrade_queue(local, skb);
 }
 
-u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
+u16 ieee80211_downgrade_queue(struct mac80211_local *local,
 			      struct sk_buff *skb)
 {
 	/* in case we are a client verify acm is not set for this ac */
@@ -139,7 +139,7 @@ u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
 	return ieee802_1d_to_ac[skb->priority];
 }
 
-void ieee80211_set_qos_hdr(struct ieee80211_local *local, struct sk_buff *skb)
+void ieee80211_set_qos_hdr(struct mac80211_local *local, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 32f17c1..77a8e8d 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -22,8 +22,8 @@ extern const int ieee802_1d_to_ac[8];
 
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
-void ieee80211_set_qos_hdr(struct ieee80211_local *local, struct sk_buff *skb);
-u16 ieee80211_downgrade_queue(struct ieee80211_local *local,
+void ieee80211_set_qos_hdr(struct mac80211_local *local, struct sk_buff *skb);
+u16 ieee80211_downgrade_queue(struct mac80211_local *local,
                               struct sk_buff *skb);
 
 
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index d814547..a963b02 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -40,7 +40,7 @@ enum work_action {
 
 
 /* utils */
-static inline void ASSERT_WORK_MTX(struct ieee80211_local *local)
+static inline void ASSERT_WORK_MTX(struct mac80211_local *local)
 {
 	lockdep_assert_held(&local->mtx);
 }
@@ -55,7 +55,7 @@ static inline void ASSERT_WORK_MTX(struct ieee80211_local *local)
  * has happened -- the work that runs from this timer will
  * do that.
  */
-static void run_again(struct ieee80211_local *local,
+static void run_again(struct mac80211_local *local,
 		      unsigned long timeout)
 {
 	ASSERT_WORK_MTX(local);
@@ -186,7 +186,7 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 				 struct ieee80211_work *wk)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	u8 *pos, qos_info;
@@ -401,7 +401,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 	ieee80211_tx_skb(sdata, skb);
 }
 
-static void ieee80211_remove_auth_bss(struct ieee80211_local *local,
+static void ieee80211_remove_auth_bss(struct mac80211_local *local,
 				      struct ieee80211_work *wk)
 {
 	struct cfg80211_bss *cbss;
@@ -425,7 +425,7 @@ static enum work_action __must_check
 ieee80211_direct_probe(struct ieee80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -463,7 +463,7 @@ static enum work_action __must_check
 ieee80211_authenticate(struct ieee80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -496,7 +496,7 @@ static enum work_action __must_check
 ieee80211_associate(struct ieee80211_work *wk)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	wk->assoc.tries++;
 	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
@@ -651,7 +651,7 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee80211_work *wk,
 			     bool reassoc)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	u16 capab_info, status_code, aid;
 	struct ieee802_11_elems elems;
 	u8 *pos;
@@ -709,7 +709,7 @@ ieee80211_rx_mgmt_probe_resp(struct ieee80211_work *wk,
 			     struct ieee80211_rx_status *rx_status)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	size_t baselen;
 
 	ASSERT_WORK_MTX(local);
@@ -733,7 +733,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
 			 struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 
 	ASSERT_WORK_MTX(local);
 
@@ -747,7 +747,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_work *wk,
 	return WORK_ACT_DONE;
 }
 
-static void ieee80211_work_rx_queued_mgmt(struct ieee80211_local *local,
+static void ieee80211_work_rx_queued_mgmt(struct mac80211_local *local,
 					  struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
@@ -897,7 +897,7 @@ ieee80211_calc_ct(enum nl80211_channel_type wk_ct,
 
 static void ieee80211_work_timer(unsigned long data)
 {
-	struct ieee80211_local *local = (void *) data;
+	struct mac80211_local *local = (void *) data;
 
 	if (local->quiescing)
 		return;
@@ -907,8 +907,8 @@ static void ieee80211_work_timer(unsigned long data)
 
 static void ieee80211_work_work(struct work_struct *work)
 {
-	struct ieee80211_local *local =
-		container_of(work, struct ieee80211_local, work_work);
+	struct mac80211_local *local =
+		container_of(work, struct mac80211_local, work_work);
 	struct sk_buff *skb;
 	struct ieee80211_work *wk, *tmp;
 	LIST_HEAD(free_work);
@@ -1111,7 +1111,7 @@ static void ieee80211_work_work(struct work_struct *work)
 
 void ieee80211_add_work(struct ieee80211_work *wk)
 {
-	struct ieee80211_local *local;
+	struct mac80211_local *local;
 
 	if (WARN_ON(!wk->chan))
 		return;
@@ -1135,7 +1135,7 @@ void ieee80211_add_work(struct ieee80211_work *wk)
 	ieee80211_queue_work(&local->hw, &local->work_work);
 }
 
-void ieee80211_work_init(struct ieee80211_local *local)
+void ieee80211_work_init(struct mac80211_local *local)
 {
 	INIT_LIST_HEAD(&local->work_list);
 	setup_timer(&local->work_timer, ieee80211_work_timer,
@@ -1146,7 +1146,7 @@ void ieee80211_work_init(struct ieee80211_local *local)
 
 void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_work *wk;
 	bool cleanup = false;
 
@@ -1178,7 +1178,7 @@ void ieee80211_work_purge(struct ieee80211_sub_if_data *sdata)
 ieee80211_rx_result ieee80211_work_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					   struct sk_buff *skb)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_work *wk;
 	u16 fc;
@@ -1254,7 +1254,7 @@ int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 int ieee80211_wk_cancel_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 					  u64 cookie)
 {
-	struct ieee80211_local *local = sdata->local;
+	struct mac80211_local *local = sdata->local;
 	struct ieee80211_work *wk, *tmp;
 	bool found = false;
 

