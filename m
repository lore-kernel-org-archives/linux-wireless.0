Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36216 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbbFJRlc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 13:41:32 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: upgrade BW of TDLS peers when possible
Date: Wed, 10 Jun 2015 20:41:23 +0300
Message-Id: <1433958083-27918-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150610_194136_180311_8EBB9ECD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Define a station chandef, to be used for wider-bw TDLS peers. When both
peers support the feature, upgrade the channel bandwidth to the maximum
allowed by both peers and regulatory. Currently widths up to 80MHz are
supported in the 5GHz band.

When a TDLS peer connects/disconnects recalculate the channel type of the
current chanctx.
Make the chanctx width calculation consider wider-bw TDLS peers and
similarly fix the max_required_bw calculation for the chanctx min_def.
Since the sta->bandwidth is calculated only later on, take
bss_conf.chandef.width as the minimal width for station interface.

Set the upgraded channel width in the VHT-operation set during TDLS setup.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/chan.c        |  31 +++++++++++--
 net/mac80211/ieee80211_i.h |   3 ++
 net/mac80211/sta_info.h    |   4 ++
 net/mac80211/tdls.c        | 105 ++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 132 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f01c18a..1d1b9b7 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -190,7 +190,7 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-static enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
+enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta)
 {
 	switch (sta->bandwidth) {
 	case IEEE80211_STA_RX_BW_20:
@@ -264,9 +264,17 @@ ieee80211_get_chanctx_max_required_bw(struct ieee80211_local *local,
 		case NL80211_IFTYPE_AP_VLAN:
 			width = ieee80211_get_max_required_bw(sdata);
 			break;
+		case NL80211_IFTYPE_STATION:
+			/*
+			 * The ap's sta->bandwidth is not set yet at this
+			 * point, so take the width from the chandef, but
+			 * account also for TDLS peers
+			 */
+			width = max(vif->bss_conf.chandef.width,
+				    ieee80211_get_max_required_bw(sdata));
+			break;
 		case NL80211_IFTYPE_P2P_DEVICE:
 			continue;
-		case NL80211_IFTYPE_STATION:
 		case NL80211_IFTYPE_ADHOC:
 		case NL80211_IFTYPE_WDS:
 		case NL80211_IFTYPE_MESH_POINT:
@@ -554,12 +562,13 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	kfree_rcu(ctx, rcu_head);
 }
 
-static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
-					      struct ieee80211_chanctx *ctx)
+void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+				       struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_chanctx_conf *conf = &ctx->conf;
 	struct ieee80211_sub_if_data *sdata;
 	const struct cfg80211_chan_def *compat = NULL;
+	struct sta_info *sta;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
@@ -581,6 +590,20 @@ static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 		if (WARN_ON_ONCE(!compat))
 			break;
 	}
+
+	/* TDLS peers can sometimes affect the chandef width */
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (!sta->uploaded ||
+		    !test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW) ||
+		    !test_sta_flag(sta, WLAN_STA_AUTHORIZED) ||
+		    !sta->tdls_chandef.chan)
+			continue;
+
+		compat = cfg80211_chandef_compatible(&sta->tdls_chandef,
+						     compat);
+		if (WARN_ON_ONCE(!compat))
+			break;
+	}
 	rcu_read_unlock();
 
 	if (!compat)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b12f615..9d5e7dd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2042,6 +2042,9 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 				 enum ieee80211_chanctx_mode chanmode,
 				 u8 radar_detect);
 int ieee80211_max_num_channels(struct ieee80211_local *local);
+enum nl80211_chan_width ieee80211_get_sta_bw(struct ieee80211_sta *sta);
+void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
+				       struct ieee80211_chanctx *ctx);
 
 /* TDLS */
 int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2cde9d0..5a887f4 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -374,6 +374,8 @@ struct ieee80211_fast_tx {
  * @fast_tx: TX fastpath information
  * @processed_beacon: set to true after peer rates and capabilities are
  *	processed
+ * @tdls_chandef: a TDLS peer can have a wider chandef that is compatible to
+ *	the BSS one.
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -501,6 +503,8 @@ struct sta_info {
 
 	u8 reserved_tid;
 
+	struct cfg80211_chan_def tdls_chandef;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index fec1b33..fb846cb 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -292,6 +292,60 @@ static void ieee80211_tdls_add_wmm_param_ie(struct ieee80211_sub_if_data *sdata,
 }
 
 static void
+ieee80211_tdls_chandef_vht_upgrade(struct ieee80211_sub_if_data *sdata,
+				   struct sta_info *sta)
+{
+	/* IEEE802.11ac-2013 Table E-4 */
+	u16 centers_80mhz[] = { 5210, 5290, 5530, 5610, 5690, 5775 };
+	struct cfg80211_chan_def uc = sta->tdls_chandef;
+	enum nl80211_chan_width max_width = ieee80211_get_sta_bw(&sta->sta);
+	int i;
+
+	/* only support upgrading non-narrow channels up to 80Mhz */
+	if (max_width == NL80211_CHAN_WIDTH_5 ||
+	    max_width == NL80211_CHAN_WIDTH_10)
+		return;
+
+	if (max_width > NL80211_CHAN_WIDTH_80)
+		max_width = NL80211_CHAN_WIDTH_80;
+
+	if (uc.width == max_width)
+		return;
+	/*
+	 * Channel usage constrains in the IEEE802.11ac-2013 specification only
+	 * allow expanding a 20MHz channel to 80MHz in a single way. In
+	 * addition, there are no 40MHz allowed channels that are not part of
+	 * the allowed 80MHz range in the 5GHz spectrum (the relevant one here).
+	 */
+	for (i = 0; i < ARRAY_SIZE(centers_80mhz); i++)
+		if (abs(uc.chan->center_freq - centers_80mhz[i]) <= 30) {
+			uc.center_freq1 = centers_80mhz[i];
+			uc.width = NL80211_CHAN_WIDTH_80;
+			break;
+		}
+
+	if (!uc.center_freq1)
+		return;
+
+	/* proceed to downgrade the chandef until usable or the same */
+	while (uc.width > max_width &&
+	       !cfg80211_reg_can_beacon(sdata->local->hw.wiphy,
+					&uc, sdata->wdev.iftype))
+		ieee80211_chandef_downgrade(&uc);
+
+	if (!cfg80211_chandef_identical(&uc, &sta->tdls_chandef)) {
+		tdls_dbg(sdata, "TDLS ch width upgraded %d -> %d\n",
+			 sta->tdls_chandef.width, uc.width);
+
+		/*
+		 * the station is not yet authorized when BW upgrade is done,
+		 * locking is not required
+		 */
+		sta->tdls_chandef = uc;
+	}
+}
+
+static void
 ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 				   struct sk_buff *skb, const u8 *peer,
 				   u8 action_code, bool initiator,
@@ -358,15 +412,17 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 		offset = noffset;
 	}
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	/* we should have the peer STA if we're already responding */
 	if (action_code == WLAN_TDLS_SETUP_RESPONSE) {
 		sta = sta_info_get(sdata, peer);
 		if (WARN_ON_ONCE(!sta)) {
-			rcu_read_unlock();
+			mutex_unlock(&local->sta_mtx);
 			return;
 		}
+
+		sta->tdls_chandef = sdata->vif.bss_conf.chandef;
 	}
 
 	ieee80211_tdls_add_oper_classes(sdata, skb);
@@ -456,9 +512,16 @@ ieee80211_tdls_add_setup_start_ies(struct ieee80211_sub_if_data *sdata,
 
 		pos = skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
 		ieee80211_ie_build_vht_cap(pos, &vht_cap, vht_cap.cap);
+
+		/*
+		 * if both peers support WIDER_BW, we can expand the chandef to
+		 * a wider compatible one, up to 80MHz
+		 */
+		if (test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
+			ieee80211_tdls_chandef_vht_upgrade(sdata, sta);
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	/* add any remaining IEs */
 	if (extra_ies_len) {
@@ -482,15 +545,17 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	u8 *pos;
 
-	rcu_read_lock();
+	mutex_lock(&local->sta_mtx);
 
 	sta = sta_info_get(sdata, peer);
 	ap_sta = sta_info_get(sdata, ifmgd->bssid);
 	if (WARN_ON_ONCE(!sta || !ap_sta)) {
-		rcu_read_unlock();
+		mutex_unlock(&local->sta_mtx);
 		return;
 	}
 
+	sta->tdls_chandef = sdata->vif.bss_conf.chandef;
+
 	/* add any custom IEs that go before the QoS IE */
 	if (extra_ies_len) {
 		static const u8 before_qos[] = {
@@ -538,12 +603,19 @@ ieee80211_tdls_add_setup_cfm_ies(struct ieee80211_sub_if_data *sdata,
 
 	/* only include VHT-operation if not on the 2.4GHz band */
 	if (band != IEEE80211_BAND_2GHZ && sta->sta.vht_cap.vht_supported) {
+		/*
+		 * if both peers support WIDER_BW, we can expand the chandef to
+		 * a wider compatible one, up to 80MHz
+		 */
+		if (test_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW))
+			ieee80211_tdls_chandef_vht_upgrade(sdata, sta);
+
 		pos = skb_put(skb, 2 + sizeof(struct ieee80211_vht_operation));
 		ieee80211_ie_build_vht_oper(pos, &sta->sta.vht_cap,
-					    &sdata->vif.bss_conf.chandef);
+					    &sta->tdls_chandef);
 	}
 
-	rcu_read_unlock();
+	mutex_unlock(&local->sta_mtx);
 
 	/* add any remaining IEs */
 	if (extra_ies_len) {
@@ -1154,6 +1226,22 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return ret;
 }
 
+static void iee80211_tdls_recalc_chanctx(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+
+	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (conf) {
+		ctx = container_of(conf, struct ieee80211_chanctx, conf);
+		ieee80211_recalc_chanctx_chantype(local, ctx);
+	}
+	mutex_unlock(&local->chanctx_mtx);
+}
+
 int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			const u8 *peer, enum nl80211_tdls_operation oper)
 {
@@ -1190,6 +1278,8 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 			break;
 		}
 
+		iee80211_tdls_recalc_chanctx(sdata);
+
 		rcu_read_lock();
 		sta = sta_info_get(sdata, peer);
 		if (!sta) {
@@ -1221,6 +1311,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_flush_queues(local, sdata, false);
 
 		ret = sta_info_destroy_addr(sdata, peer);
+		iee80211_tdls_recalc_chanctx(sdata);
 		break;
 	default:
 		ret = -ENOTSUPP;
-- 
2.1.4

