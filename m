Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756430AbcCQNlt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 09:41:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 5/5] mac80211: track and tell driver about GO client P2P PS abilities
Date: Thu, 17 Mar 2016 15:41:39 +0200
Message-Id: <1458222099-30301-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160317_144152_755140_1B6D1DD5)
In-Reply-To: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1458222099-30301-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

Legacy clients don't support P2P power save mechanism, and thus if a P2P GO
has a legacy client connected to it, it should disable P2P PS mechanisms.
Let the driver know about this with a new bss_conf parameter.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h  |  8 +++++++-
 net/mac80211/cfg.c      |  4 ++++
 net/mac80211/sta_info.c | 29 +++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a53333c..6e34675 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -291,7 +291,7 @@ struct ieee80211_vif_chanctx_switch {
  * @BSS_CHANGED_PS: PS changed for this BSS (STA mode)
  * @BSS_CHANGED_TXPOWER: TX power setting changed for this interface
  * @BSS_CHANGED_P2P_PS: P2P powersave settings (CTWindow, opportunistic PS)
- *	changed (currently only in P2P client mode, GO mode will be later)
+ *	changed
  * @BSS_CHANGED_BEACON_INFO: Data from the AP's beacon became available:
  *	currently dtim_period only is under consideration.
  * @BSS_CHANGED_BANDWIDTH: The bandwidth used by this interface changed,
@@ -526,6 +526,9 @@ struct ieee80211_mu_group_data {
  *	userspace), whereas TPC is disabled if %txpower_type is set to
  *	NL80211_TX_POWER_FIXED (use value configured from userspace)
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
+ * @allow_p2p_go_ps: indication for AP or P2P GO interface, whether it's allowed
+ *	to use P2P PS mechanism or not. AP/P2P GO is not allowed to use P2P PS
+ *	if it has associated clients without P2P PS support.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -563,6 +566,7 @@ struct ieee80211_bss_conf {
 	int txpower;
 	enum nl80211_tx_power_setting txpower_type;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
+	bool allow_p2p_go_ps;
 };
 
 /**
@@ -1741,6 +1745,7 @@ struct ieee80211_sta_rates {
  *		  size is min(max_amsdu_len, 7935) bytes.
  *	Both additional HT limits must be enforced by the low level driver.
  *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 2).
+ * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
  * @txq: per-TID data TX queues (if driver uses the TXQ abstraction)
  */
 struct ieee80211_sta {
@@ -1761,6 +1766,7 @@ struct ieee80211_sta {
 	bool mfp;
 	u8 max_amsdu_subframes;
 	u16 max_amsdu_len;
+	bool support_p2p_ps;
 
 	struct ieee80211_txq *txq[IEEE80211_NUM_TIDS];
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b37adb6..62a90f2 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -732,6 +732,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.beacon_int = params->beacon_interval;
 	sdata->vif.bss_conf.dtim_period = params->dtim_period;
 	sdata->vif.bss_conf.enable_beacon = true;
+	sdata->vif.bss_conf.allow_p2p_go_ps = sdata->vif.p2p;
 
 	sdata->vif.bss_conf.ssid_len = params->ssid_len;
 	if (params->ssid_len)
@@ -1202,6 +1203,9 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					      params->opmode_notif, band);
 	}
 
+	if (params->support_p2p_ps >= 0)
+		sta->sta.support_p2p_ps = params->support_p2p_ps;
+
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		sta_apply_mesh_params(local, sta, params);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 00c82fb..01e070c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1767,6 +1767,31 @@ void ieee80211_sta_set_buffered(struct ieee80211_sta *pubsta,
 }
 EXPORT_SYMBOL(ieee80211_sta_set_buffered);
 
+static void
+ieee80211_recalc_p2p_go_ps_allowed(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	bool allow_p2p_go_ps = sdata->vif.p2p;
+	struct sta_info *sta;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata ||
+		    !test_sta_flag(sta, WLAN_STA_ASSOC))
+			continue;
+		if (!sta->sta.support_p2p_ps) {
+			allow_p2p_go_ps = false;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	if (allow_p2p_go_ps != sdata->vif.bss_conf.allow_p2p_go_ps) {
+		sdata->vif.bss_conf.allow_p2p_go_ps = allow_p2p_go_ps;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_P2P_PS);
+	}
+}
+
 int sta_info_move_state(struct sta_info *sta,
 			enum ieee80211_sta_state new_state)
 {
@@ -1828,12 +1853,16 @@ int sta_info_move_state(struct sta_info *sta,
 		} else if (sta->sta_state == IEEE80211_STA_ASSOC) {
 			clear_bit(WLAN_STA_ASSOC, &sta->_flags);
 			ieee80211_recalc_min_chandef(sta->sdata);
+			if (!sta->sta.support_p2p_ps)
+				ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
 		}
 		break;
 	case IEEE80211_STA_ASSOC:
 		if (sta->sta_state == IEEE80211_STA_AUTH) {
 			set_bit(WLAN_STA_ASSOC, &sta->_flags);
 			ieee80211_recalc_min_chandef(sta->sdata);
+			if (!sta->sta.support_p2p_ps)
+				ieee80211_recalc_p2p_go_ps_allowed(sta->sdata);
 		} else if (sta->sta_state == IEEE80211_STA_AUTHORIZED) {
 			if (sta->sdata->vif.type == NL80211_IFTYPE_AP ||
 			    (sta->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
-- 
2.5.0

