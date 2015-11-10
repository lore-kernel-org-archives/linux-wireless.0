Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39228 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbKJIwg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 03:52:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/4] mac80211: introduce ieee80211_local_check()
Date: Tue, 10 Nov 2015 09:52:27 +0100
Message-Id: <1447145549-27376-3-git-send-email-johannes@sipsolutions.net> (sfid-20151110_095245_360810_731626B3)
In-Reply-To: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
References: <1447145549-27376-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This will later allow introducing different behaviour between
driver and hw checks. Make mac80211 use the new check function
almost everywhere - one place cannot (rate control) and two of
them shouldn't get the behaviour I want to introduce (in hw
registration.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c         |  2 +-
 net/mac80211/agg-tx.c         |  4 +--
 net/mac80211/cfg.c            | 12 ++++-----
 net/mac80211/debugfs_netdev.c |  2 +-
 net/mac80211/driver-ops.c     |  2 +-
 net/mac80211/ieee80211_i.h    |  9 +++++++
 net/mac80211/iface.c          | 10 ++++----
 net/mac80211/key.c            |  4 +--
 net/mac80211/main.c           | 10 ++++----
 net/mac80211/mlme.c           | 58 +++++++++++++++++++++----------------------
 net/mac80211/offchannel.c     |  2 +-
 net/mac80211/pm.c             |  4 +--
 net/mac80211/rate.c           |  6 ++---
 net/mac80211/rx.c             | 26 +++++++++----------
 net/mac80211/scan.c           | 10 ++++----
 net/mac80211/sta_info.c       | 14 +++++------
 net/mac80211/status.c         | 12 ++++-----
 net/mac80211/tdls.c           |  4 +--
 net/mac80211/tx.c             | 36 +++++++++++++--------------
 net/mac80211/util.c           |  6 ++---
 20 files changed, 121 insertions(+), 112 deletions(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 10ad4ac1fa0b..d9bf3701e4f9 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -189,7 +189,7 @@ static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *d
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
-	bool amsdu = ieee80211_hw_check(&local->hw, SUPPORTS_AMSDU_IN_AMPDU);
+	bool amsdu = ieee80211_local_check(local, SUPPORTS_AMSDU_IN_AMPDU);
 	u16 capab;
 
 	skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index a758eb84e8f0..18b8809521ff 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -565,8 +565,8 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 		return -EINVAL;
 
 	if ((tid >= IEEE80211_NUM_TIDS) ||
-	    !ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION) ||
-	    ieee80211_hw_check(&local->hw, TX_AMPDU_SETUP_IN_HW))
+	    !ieee80211_local_check(local, AMPDU_AGGREGATION) ||
+	    ieee80211_local_check(local, TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
 
 	ht_dbg(sdata, "Open BA session requested for %pM tid %u\n",
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2bd1b6a6922..cf285033741c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1121,7 +1121,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER) &&
 	    !sdata->u.mgd.tdls_wider_bw_prohibited &&
-	    ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
+	    ieee80211_local_check(local, TDLS_WIDER_BW) &&
 	    params->ext_capab_len >= 8 &&
 	    params->ext_capab[7] & WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED)
 		set_sta_flag(sta, WLAN_STA_TDLS_WIDER_BW);
@@ -1746,7 +1746,7 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 		/* our RSSI threshold implementation is supported only for
 		 * devices that report signal in dBm.
 		 */
-		if (!ieee80211_hw_check(&sdata->local->hw, SIGNAL_DBM))
+		if (!ieee80211_local_check(sdata->local, SIGNAL_DBM))
 			return -ENOTSUPP;
 		conf->rssi_threshold = nconf->rssi_threshold;
 	}
@@ -2405,7 +2405,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	if (sdata->vif.type != NL80211_IFTYPE_STATION)
 		return -EOPNOTSUPP;
 
-	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
+	if (!ieee80211_local_check(local, SUPPORTS_PS))
 		return -EOPNOTSUPP;
 
 	if (enabled == sdata->u.mgd.powersave &&
@@ -2420,7 +2420,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	__ieee80211_request_smps_mgd(sdata, sdata->u.mgd.req_smps);
 	sdata_unlock(sdata);
 
-	if (ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
+	if (ieee80211_local_check(local, SUPPORTS_DYNAMIC_PS))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
 	ieee80211_recalc_ps(local);
@@ -2469,7 +2469,7 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 	if (!ieee80211_sdata_running(sdata))
 		return -ENETDOWN;
 
-	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
+	if (ieee80211_local_check(local, HAS_RATE_CONTROL)) {
 		ret = drv_set_bitrate_mask(local, sdata, mask);
 		if (ret)
 			return ret;
@@ -3466,7 +3466,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_TX_OFFCHAN |
 					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
-	if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+	if (ieee80211_local_check(local, QUEUE_CONTROL))
 		IEEE80211_SKB_CB(skb)->hw_queue =
 			local->hw.offchannel_tx_hw_queue;
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 37ea30e0754c..e18e49b2faec 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -451,7 +451,7 @@ static ssize_t ieee80211_if_fmt_tdls_wider_bw(
 	const struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool tdls_wider_bw;
 
-	tdls_wider_bw = ieee80211_hw_check(&sdata->local->hw, TDLS_WIDER_BW) &&
+	tdls_wider_bw = ieee80211_local_check(sdata->local, TDLS_WIDER_BW) &&
 			!ifmgd->tdls_wider_bw_prohibited;
 
 	return snprintf(buf, buflen, "%d\n", tdls_wider_bw);
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index ca1fe5576103..d84029d892a5 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -61,7 +61,7 @@ int drv_add_interface(struct ieee80211_local *local,
 
 	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-		     !ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
+		     !ieee80211_local_check(local, WANT_MONITOR_VIF) &&
 		     !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
 		return -EINVAL;
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d832bd59236b..46bd8965d164 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1357,6 +1357,15 @@ struct ieee80211_local {
 	struct sk_buff_head skb_queue_tdls_chsw;
 };
 
+static inline bool _ieee80211_local_check(struct ieee80211_local *local,
+					  enum ieee80211_hw_flags flg)
+{
+	return test_bit(flg, local->hw.flags);
+}
+
+#define ieee80211_local_check(local, flg)	\
+	_ieee80211_local_check(local, IEEE80211_HW_##flg)
+
 static inline struct ieee80211_sub_if_data *
 IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d0dc1bfaeec2..43c675ec3c14 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -338,7 +338,7 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
 	if ((iftype != NL80211_IFTYPE_AP &&
 	     iftype != NL80211_IFTYPE_P2P_GO &&
 	     iftype != NL80211_IFTYPE_MESH_POINT) ||
-	    !ieee80211_hw_check(&sdata->local->hw, QUEUE_CONTROL)) {
+	    !ieee80211_local_check(sdata->local, QUEUE_CONTROL)) {
 		sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 		return 0;
 	}
@@ -378,7 +378,7 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	int i;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+		if (ieee80211_local_check(local, QUEUE_CONTROL))
 			sdata->vif.hw_queue[i] = IEEE80211_INVAL_HW_QUEUE;
 		else if (local->hw.queues >= IEEE80211_NUM_ACS)
 			sdata->vif.hw_queue[i] = i;
@@ -393,7 +393,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 	struct ieee80211_sub_if_data *sdata;
 	int ret;
 
-	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+	if (!ieee80211_local_check(local, WANT_MONITOR_VIF))
 		return 0;
 
 	ASSERT_RTNL();
@@ -454,7 +454,7 @@ void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
 
-	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF))
+	if (!ieee80211_local_check(local, WANT_MONITOR_VIF))
 		return;
 
 	ASSERT_RTNL();
@@ -1586,7 +1586,7 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_P2P_GO:
-		if (ieee80211_hw_check(&local->hw, P2P_DEV_ADDR_FOR_INTF)) {
+		if (ieee80211_local_check(local, P2P_DEV_ADDR_FOR_INTF)) {
 			list_for_each_entry(sdata, &local->interfaces, list) {
 				if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE)
 					continue;
diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index 44388d6a1d8e..d9f0f0fbc70b 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -154,7 +154,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 	 * is supported; if not, return.
 	 */
 	if (sta && !(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
-	    !ieee80211_hw_check(&key->local->hw, SUPPORTS_PER_STA_GTK))
+	    !ieee80211_local_check(key->local, SUPPORTS_PER_STA_GTK))
 		goto out_unsupported;
 
 	if (sta && !sta->uploaded)
@@ -208,7 +208,7 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
 		/* all of these we can do in software - if driver can */
 		if (ret == 1)
 			return 0;
-		if (ieee80211_hw_check(&key->local->hw, SW_CRYPTO_CONTROL))
+		if (ieee80211_local_check(key->local, SW_CRYPTO_CONTROL))
 			return -EINVAL;
 		return 0;
 	default:
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 858f6b1cb149..84d7480fe7c8 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -663,7 +663,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 {
 	bool have_wep = !(IS_ERR(local->wep_tx_tfm) ||
 			  IS_ERR(local->wep_rx_tfm));
-	bool have_mfp = ieee80211_hw_check(&local->hw, MFP_CAPABLE);
+	bool have_mfp = ieee80211_local_check(local, MFP_CAPABLE);
 	int n_suites = 0, r = 0, w = 0;
 	u32 *suites;
 	static const u32 cipher_suites[] = {
@@ -683,7 +683,7 @@ static int ieee80211_init_cipher_suites(struct ieee80211_local *local)
 		WLAN_CIPHER_SUITE_BIP_GMAC_256,
 	};
 
-	if (ieee80211_hw_check(&local->hw, SW_CRYPTO_CONTROL) ||
+	if (ieee80211_local_check(local, SW_CRYPTO_CONTROL) ||
 	    local->hw.wiphy->cipher_suites) {
 		/* If the driver advertises, or doesn't support SW crypto,
 		 * we only need to remove WEP if necessary.
@@ -947,9 +947,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/* mac80211 supports control port protocol changing */
 	local->hw.wiphy->flags |= WIPHY_FLAG_CONTROL_PORT_PROTOCOL;
 
-	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM)) {
+	if (ieee80211_local_check(local, SIGNAL_DBM)) {
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
-	} else if (ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC)) {
+	} else if (ieee80211_local_check(local, SIGNAL_UNSPEC)) {
 		local->hw.wiphy->signal_type = CFG80211_SIGNAL_TYPE_UNSPEC;
 		if (hw->max_signal <= 0) {
 			result = -EINVAL;
@@ -1003,7 +1003,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
 	/* mac80211 supports eCSA, if the driver supports STA CSA at all */
-	if (ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA))
+	if (ieee80211_local_check(local, CHANCTX_STA_CSA))
 		local->ext_capa[0] |= WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING;
 
 	local->hw.wiphy->max_num_csa_counters = IEEE80211_MAX_CSA_COUNTERS_NUM;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b140cc6651f4..53b5b524702b 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -111,7 +111,7 @@ void ieee80211_sta_reset_beacon_monitor(struct ieee80211_sub_if_data *sdata)
 	if (sdata->vif.driver_flags & IEEE80211_VIF_BEACON_FILTER)
 		return;
 
-	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
+	if (ieee80211_local_check(sdata->local, CONNECTION_MONITOR))
 		return;
 
 	mod_timer(&sdata->u.mgd.bcn_mon_timer,
@@ -127,7 +127,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 
 	ifmgd->probe_send_count = 0;
 
-	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
+	if (ieee80211_local_check(sdata->local, CONNECTION_MONITOR))
 		return;
 
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
@@ -702,7 +702,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		capab |= WLAN_CAPABILITY_PRIVACY;
 
 	if ((assoc_data->capability & WLAN_CAPABILITY_SPECTRUM_MGMT) &&
-	    ieee80211_hw_check(&local->hw, SPECTRUM_MGMT))
+	    ieee80211_local_check(local, SPECTRUM_MGMT))
 		capab |= WLAN_CAPABILITY_SPECTRUM_MGMT;
 
 	if (ifmgd->flags & IEEE80211_STA_ENABLE_RRM)
@@ -910,7 +910,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 	drv_mgd_prepare_tx(local, sdata);
 
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS |
 						IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_tx_skb(sdata, skb);
@@ -952,7 +952,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
 
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 		IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL)
@@ -1205,7 +1205,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	chanctx = container_of(conf, struct ieee80211_chanctx, conf);
 
 	if (local->use_chanctx &&
-	    !ieee80211_hw_check(&local->hw, CHANCTX_STA_CSA)) {
+	    !ieee80211_local_check(local, CHANCTX_STA_CSA)) {
 		sdata_info(sdata,
 			   "driver doesn't support chan-switch with channel contexts\n");
 		goto drop_connection;
@@ -1414,15 +1414,15 @@ static void ieee80211_enable_ps(struct ieee80211_local *local,
 		return;
 
 	if (conf->dynamic_ps_timeout > 0 &&
-	    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS)) {
+	    !ieee80211_local_check(local, SUPPORTS_DYNAMIC_PS)) {
 		mod_timer(&local->dynamic_ps_timer, jiffies +
 			  msecs_to_jiffies(conf->dynamic_ps_timeout));
 	} else {
-		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
+		if (ieee80211_local_check(local, PS_NULLFUNC_STACK))
 			ieee80211_send_nullfunc(local, sdata, true);
 
-		if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
-		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+		if (ieee80211_local_check(local, PS_NULLFUNC_STACK) &&
+		    ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 			return;
 
 		conf->flags |= IEEE80211_CONF_PS;
@@ -1481,7 +1481,7 @@ void ieee80211_recalc_ps(struct ieee80211_local *local)
 	int count = 0;
 	int timeout;
 
-	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS)) {
+	if (!ieee80211_local_check(local, SUPPORTS_PS)) {
 		local->ps_sdata = NULL;
 		return;
 	}
@@ -1602,7 +1602,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
 	}
 
-	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
+	if (ieee80211_local_check(local, PS_NULLFUNC_STACK) &&
 	    !(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		if (drv_tx_frames_pending(local)) {
 			mod_timer(&local->dynamic_ps_timer, jiffies +
@@ -1615,8 +1615,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		}
 	}
 
-	if (!(ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
-	      ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK)) ||
+	if (!(ieee80211_local_check(local, REPORTS_TX_ACK_STATUS) &&
+	      ieee80211_local_check(local, PS_NULLFUNC_STACK)) ||
 	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
 		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
 		local->hw.conf.flags |= IEEE80211_CONF_PS;
@@ -2157,7 +2157,7 @@ static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
 	ieee80211_recalc_ps(local);
 	mutex_unlock(&local->iflist_mtx);
 
-	if (ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
+	if (ieee80211_local_check(sdata->local, CONNECTION_MONITOR))
 		goto out;
 
 	/*
@@ -2255,7 +2255,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 	 */
 	ifmgd->probe_send_count++;
 
-	if (ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
+	if (ieee80211_local_check(sdata->local, REPORTS_TX_ACK_STATUS)) {
 		ifmgd->nullfunc_failed = false;
 		ieee80211_send_nullfunc(sdata->local, sdata, false);
 	} else {
@@ -2555,7 +2555,7 @@ static void ieee80211_auth_challenge(struct ieee80211_sub_if_data *sdata,
 		return;
 	auth_data->expected_transaction = 4;
 	drv_mgd_prepare_tx(sdata->local, sdata);
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 	ieee80211_send_auth(sdata, 3, auth_data->algorithm, 0,
@@ -3330,7 +3330,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 		ifmgd->have_beacon = true;
 		ifmgd->assoc_data->need_beacon = false;
-		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
+		if (ieee80211_local_check(local, TIMING_BEACON_ONLY)) {
 			sdata->vif.bss_conf.sync_tsf =
 				le64_to_cpu(mgmt->u.beacon.timestamp);
 			sdata->vif.bss_conf.sync_device_ts =
@@ -3434,7 +3434,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					  len - baselen, false, &elems,
 					  care_about_ies, ncrc);
 
-	if (ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK) &&
+	if (ieee80211_local_check(local, PS_NULLFUNC_STACK) &&
 	    ieee80211_check_tim(elems.tim, elems.tim_len, ifmgd->aid)) {
 		if (local->hw.conf.dynamic_ps_timeout > 0) {
 			if (local->hw.conf.flags & IEEE80211_CONF_PS) {
@@ -3498,7 +3498,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	 * the driver will use them. The synchronized view is currently
 	 * guaranteed only in certain callbacks.
 	 */
-	if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
+	if (ieee80211_local_check(local, TIMING_BEACON_ONLY)) {
 		sdata->vif.bss_conf.sync_tsf =
 			le64_to_cpu(mgmt->u.beacon.timestamp);
 		sdata->vif.bss_conf.sync_device_ts =
@@ -3734,7 +3734,7 @@ static int ieee80211_auth(struct ieee80211_sub_if_data *sdata)
 		auth_data->expected_transaction = trans;
 	}
 
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 		tx_flags = IEEE80211_TX_CTL_REQ_TX_STATUS |
 			   IEEE80211_TX_INTFL_MLME_CONN_TX;
 
@@ -3784,7 +3784,7 @@ static int ieee80211_do_assoc(struct ieee80211_sub_if_data *sdata)
 		   IEEE80211_ASSOC_MAX_TRIES);
 	ieee80211_send_assoc(sdata);
 
-	if (!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+	if (!ieee80211_local_check(local, REPORTS_TX_ACK_STATUS)) {
 		assoc_data->timeout = jiffies + IEEE80211_ASSOC_TIMEOUT;
 		assoc_data->timeout_started = true;
 		run_again(sdata, assoc_data->timeout);
@@ -3897,7 +3897,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 		memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
 
-		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+		if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 			max_tries = max_nullfunc_tries;
 		else
 			max_tries = max_probe_tries;
@@ -3922,7 +3922,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			}
 		} else if (time_is_after_jiffies(ifmgd->probe_timeout))
 			run_again(sdata, ifmgd->probe_timeout);
-		else if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+		else if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS)) {
 			mlme_dbg(sdata,
 				 "Failed to send nullfunc to AP %pM after %dms, disconnecting\n",
 				 bssid, probe_wait_ms);
@@ -3995,7 +3995,7 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
 		__ieee80211_stop_poll(sdata);
 
 		/* let's probe the connection once */
-		if (!ieee80211_hw_check(&sdata->local->hw, CONNECTION_MONITOR))
+		if (!ieee80211_local_check(sdata->local, CONNECTION_MONITOR))
 			ieee80211_queue_work(&sdata->local->hw,
 					     &sdata->u.mgd.monitor_work);
 		/* and do all the other regular work too */
@@ -4409,7 +4409,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 				sdata->vif.bss_conf.sync_dtim_count = tim_ie[2];
 			else
 				sdata->vif.bss_conf.sync_dtim_count = 0;
-		} else if (!ieee80211_hw_check(&sdata->local->hw,
+		} else if (!ieee80211_local_check(sdata->local,
 					       TIMING_BEACON_ONLY)) {
 			ies = rcu_dereference(cbss->proberesp_ies);
 			/* must be non-NULL since beacon IEs were NULL */
@@ -4717,7 +4717,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_unlock();
 
 	if (WARN((sdata->vif.driver_flags & IEEE80211_VIF_SUPPORTS_UAPSD) &&
-		 ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK),
+		 ieee80211_local_check(local, PS_NULLFUNC_STACK),
 	     "U-APSD not supported with HW_PS_NULLFUNC_STACK\n"))
 		sdata->vif.driver_flags &= ~IEEE80211_VIF_SUPPORTS_UAPSD;
 
@@ -4798,7 +4798,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 	rcu_read_lock();
 	beacon_ies = rcu_dereference(req->bss->beacon_ies);
 
-	if (ieee80211_hw_check(&sdata->local->hw, NEED_DTIM_BEFORE_ASSOC) &&
+	if (ieee80211_local_check(sdata->local, NEED_DTIM_BEFORE_ASSOC) &&
 	    !beacon_ies) {
 		/*
 		 * Wait up to one beacon interval ...
@@ -4825,7 +4825,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
 
-		if (ieee80211_hw_check(&local->hw, TIMING_BEACON_ONLY)) {
+		if (ieee80211_local_check(local, TIMING_BEACON_ONLY)) {
 			sdata->vif.bss_conf.sync_tsf = beacon_ies->tsf;
 			sdata->vif.bss_conf.sync_device_ts =
 				bss->device_ts_beacon;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 04401037140e..bf0ecc8e0954 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -46,7 +46,7 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
 	}
 
 	if (!local->offchannel_ps_enabled ||
-	    !ieee80211_hw_check(&local->hw, PS_NULLFUNC_STACK))
+	    !ieee80211_local_check(local, PS_NULLFUNC_STACK))
 		/*
 		 * If power save was enabled, no need to send a nullfunc
 		 * frame because AP knows that we are sleeping. But if the
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 00a43a70e1fc..877ecf747cd2 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -30,7 +30,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	ieee80211_del_virtual_monitor(local);
 
-	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION) &&
+	if (ieee80211_local_check(local, AMPDU_AGGREGATION) &&
 	    !(wowlan && wowlan->any)) {
 		mutex_lock(&local->sta_mtx);
 		list_for_each_entry(sta, &local->sta_list, list) {
@@ -110,7 +110,7 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		if (err < 0) {
 			local->quiescing = false;
 			local->wowlan = false;
-			if (ieee80211_hw_check(hw, AMPDU_AGGREGATION)) {
+			if (ieee80211_local_check(local, AMPDU_AGGREGATION)) {
 				mutex_lock(&local->sta_mtx);
 				list_for_each_entry(sta,
 						    &local->sta_list, list) {
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index a4e2f4e67f94..106360ebea97 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -848,7 +848,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		info->control.rates[i].count = 0;
 	}
 
-	if (ieee80211_hw_check(&sdata->local->hw, HAS_RATE_CONTROL))
+	if (ieee80211_local_check(sdata->local, HAS_RATE_CONTROL))
 		return;
 
 	if (ista) {
@@ -859,7 +859,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 		ref->ops->get_rate(ref->priv, NULL, NULL, txrc);
 	}
 
-	if (ieee80211_hw_check(&sdata->local->hw, SUPPORTS_RC_TABLE))
+	if (ieee80211_local_check(sdata->local, SUPPORTS_RC_TABLE))
 		return;
 
 	ieee80211_get_tx_rates(&sdata->vif, ista, txrc->skb,
@@ -904,7 +904,7 @@ int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 	if (local->open_count)
 		return -EBUSY;
 
-	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
+	if (ieee80211_local_check(local, HAS_RATE_CONTROL)) {
 		if (WARN_ON(!local->ops->set_rts_threshold))
 			return -EINVAL;
 		return 0;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8bae5de0dc44..311d87a22303 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -97,7 +97,7 @@ static struct sk_buff *remove_monitor_info(struct ieee80211_local *local,
 					   struct sk_buff *skb,
 					   unsigned int rtap_vendor_space)
 {
-	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)) {
+	if (ieee80211_local_check(local, RX_INCLUDES_FCS)) {
 		if (likely(skb->len > FCS_LEN))
 			__pskb_trim(skb, skb->len - FCS_LEN);
 		else {
@@ -154,7 +154,7 @@ ieee80211_rx_radiotap_hdrlen(struct ieee80211_local *local,
 		len = ALIGN(len, 8);
 		len += 8;
 	}
-	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
+	if (ieee80211_local_check(local, SIGNAL_DBM))
 		len += 1;
 
 	/* antenna field, if we don't have per-chain info */
@@ -229,7 +229,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 
 	mpdulen = skb->len;
-	if (!(has_fcs && ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS)))
+	if (!(has_fcs && ieee80211_local_check(local, RX_INCLUDES_FCS)))
 		mpdulen += FCS_LEN;
 
 	rthdr = (struct ieee80211_radiotap_header *)skb_push(skb, rtap_len);
@@ -283,7 +283,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	}
 
 	/* IEEE80211_RADIOTAP_FLAGS */
-	if (has_fcs && ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS))
+	if (has_fcs && ieee80211_local_check(local, RX_INCLUDES_FCS))
 		*pos |= IEEE80211_RADIOTAP_F_FCS;
 	if (status->flag & (RX_FLAG_FAILED_FCS_CRC | RX_FLAG_FAILED_PLCP_CRC))
 		*pos |= IEEE80211_RADIOTAP_F_BADFCS;
@@ -333,7 +333,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos += 2;
 
 	/* IEEE80211_RADIOTAP_DBM_ANTSIGNAL */
-	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM) &&
+	if (ieee80211_local_check(local, SIGNAL_DBM) &&
 	    !(status->flag & RX_FLAG_NO_SIGNAL_VAL)) {
 		*pos = status->signal;
 		rthdr->it_present |=
@@ -498,7 +498,7 @@ ieee80211_rx_monitor(struct ieee80211_local *local, struct sk_buff *origskb,
 	 * the SKB because it has a bad FCS/PLCP checksum.
 	 */
 
-	if (ieee80211_hw_check(&local->hw, RX_INCLUDES_FCS))
+	if (ieee80211_local_check(local, RX_INCLUDES_FCS))
 		present_fcs_len = FCS_LEN;
 
 	/* ensure hdr->frame_control and vendor radiotap data are in skb head */
@@ -1232,7 +1232,7 @@ static void sta_ps_start(struct sta_info *sta)
 
 	atomic_inc(&ps->num_sta_ps);
 	set_sta_flag(sta, WLAN_STA_PS_STA);
-	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
+	if (!ieee80211_local_check(local, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_SLEEP, &sta->sta);
 	ps_dbg(sdata, "STA %pM aid %d enters power save mode\n",
 	       sta->sta.addr, sta->sta.aid);
@@ -1280,7 +1280,7 @@ int ieee80211_sta_ps_transition(struct ieee80211_sta *pubsta, bool start)
 	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
 	bool in_ps;
 
-	WARN_ON(!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS));
+	WARN_ON(!ieee80211_local_check(sta->local, AP_LINK_PS));
 
 	/* Don't let the same PS state be set twice */
 	in_ps = test_sta_flag(sta, WLAN_STA_PS_STA);
@@ -1316,7 +1316,7 @@ ieee80211_rx_h_uapsd_and_pspoll(struct ieee80211_rx_data *rx)
 	 * uAPSD and PS-Poll frames (the latter shouldn't even come up from
 	 * it to mac80211 since they're handled.)
 	 */
-	if (ieee80211_hw_check(&sdata->local->hw, AP_LINK_PS))
+	if (ieee80211_local_check(sdata->local, AP_LINK_PS))
 		return RX_CONTINUE;
 
 	/*
@@ -1453,7 +1453,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	 * Change STA power saving mode only at the end of a frame
 	 * exchange sequence.
 	 */
-	if (!ieee80211_hw_check(&sta->local->hw, AP_LINK_PS) &&
+	if (!ieee80211_local_check(sta->local, AP_LINK_PS) &&
 	    !ieee80211_has_morefrags(hdr->frame_control) &&
 	    !(status->rx_flags & IEEE80211_RX_DEFERRED_RELEASE) &&
 	    (rx->sdata->vif.type == NL80211_IFTYPE_AP ||
@@ -2579,7 +2579,7 @@ ieee80211_rx_h_mgmt_check(struct ieee80211_rx_data *rx)
 	    !(rx->flags & IEEE80211_RX_BEACON_REPORTED)) {
 		int sig = 0;
 
-		if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM))
+		if (ieee80211_local_check(rx->local, SIGNAL_DBM))
 			sig = status->signal;
 
 		cfg80211_report_obss_beacon(rx->local->hw.wiphy,
@@ -2910,7 +2910,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	 * it transmitted were processed or returned.
 	 */
 
-	if (ieee80211_hw_check(&rx->local->hw, SIGNAL_DBM))
+	if (ieee80211_local_check(rx->local, SIGNAL_DBM))
 		sig = status->signal;
 
 	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
@@ -2975,7 +2975,7 @@ ieee80211_rx_h_action_return(struct ieee80211_rx_data *rx)
 			info->flags = IEEE80211_TX_CTL_TX_OFFCHAN |
 				      IEEE80211_TX_INTFL_OFFCHAN_TX_OK |
 				      IEEE80211_TX_CTL_NO_CCK_RATE;
-			if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+			if (ieee80211_local_check(local, QUEUE_CONTROL))
 				info->hw_queue =
 					local->hw.offchannel_tx_hw_queue;
 		}
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 4aeca4b0c3cb..bea544d8e106 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -69,9 +69,9 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 	struct cfg80211_inform_bss bss_meta = {};
 	bool signal_valid;
 
-	if (ieee80211_hw_check(&local->hw, SIGNAL_DBM))
+	if (ieee80211_local_check(local, SIGNAL_DBM))
 		bss_meta.signal = rx_status->signal * 100;
-	else if (ieee80211_hw_check(&local->hw, SIGNAL_UNSPEC))
+	else if (ieee80211_local_check(local, SIGNAL_UNSPEC))
 		bss_meta.signal = (rx_status->signal * 100) / local->hw.max_signal;
 
 	bss_meta.scan_width = NL80211_BSS_CHAN_WIDTH_20;
@@ -261,7 +261,7 @@ static bool ieee80211_prep_hw_scan(struct ieee80211_local *local)
 	if (test_bit(SCAN_HW_CANCELLED, &local->scanning))
 		return false;
 
-	if (ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS)) {
+	if (ieee80211_local_check(local, SINGLE_SCAN_ON_ALL_BANDS)) {
 		for (i = 0; i < req->n_channels; i++) {
 			local->hw_scan_req->req.channels[i] = req->channels[i];
 			bands_used |= BIT(req->channels[i]->band);
@@ -330,7 +330,7 @@ static void __ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 		return;
 
 	if (hw_scan && !aborted &&
-	    !ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS) &&
+	    !ieee80211_local_check(local, SINGLE_SCAN_ON_ALL_BANDS) &&
 	    ieee80211_prep_hw_scan(local)) {
 		int rc;
 
@@ -524,7 +524,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 
 		local->hw_scan_ies_bufsize = local->scan_ies_len + req->ie_len;
 
-		if (ieee80211_hw_check(&local->hw, SINGLE_SCAN_ON_ALL_BANDS)) {
+		if (ieee80211_local_check(local, SINGLE_SCAN_ON_ALL_BANDS)) {
 			int i, n_bands = 0;
 			u8 bands_counted = 0;
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f91d1873218c..49cebf0a748c 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -285,7 +285,7 @@ static void sta_deliver_ps_frames(struct work_struct *wk)
 static int sta_prepare_rate_control(struct ieee80211_local *local,
 				    struct sta_info *sta, gfp_t gfp)
 {
-	if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL))
+	if (ieee80211_local_check(local, HAS_RATE_CONTROL))
 		return 0;
 
 	sta->rate_ctrl = local->rate_ctrl;
@@ -650,7 +650,7 @@ static void __sta_info_recalc_tim(struct sta_info *sta, bool ignore_pending)
 	}
 
 	/* No need to do anything if the driver does all */
-	if (ieee80211_hw_check(&local->hw, AP_LINK_PS))
+	if (ieee80211_local_check(local, AP_LINK_PS))
 		return;
 
 	if (sta->dead)
@@ -1155,7 +1155,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	sta->driver_buffered_tids = 0;
 	sta->txq_buffered_tids = 0;
 
-	if (!ieee80211_hw_check(&local->hw, AP_LINK_PS))
+	if (!ieee80211_local_check(local, AP_LINK_PS))
 		drv_sta_notify(local, sdata, STA_NOTIFY_AWAKE, &sta->sta);
 
 	if (sta->sta.txq[0]) {
@@ -1927,8 +1927,8 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->rx_beacon_signal_avg = ieee80211_ave_rssi(&sdata->vif);
 	}
 
-	if (ieee80211_hw_check(&sta->local->hw, SIGNAL_DBM) ||
-	    ieee80211_hw_check(&sta->local->hw, SIGNAL_UNSPEC)) {
+	if (ieee80211_local_check(sta->local, SIGNAL_DBM) ||
+	    ieee80211_local_check(sta->local, SIGNAL_UNSPEC)) {
 		if (!(sinfo->filled & BIT(NL80211_STA_INFO_SIGNAL))) {
 			sinfo->signal = (s8)sta->rx_stats.last_signal;
 			sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL);
@@ -1983,7 +1983,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(tidstats->filled &
 				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES)) &&
-		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+		    ieee80211_local_check(local, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_RETRIES);
 			tidstats->tx_msdu_retries =
@@ -1992,7 +1992,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 
 		if (!(tidstats->filled &
 				BIT(NL80211_TID_STATS_TX_MSDU_FAILED)) &&
-		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+		    ieee80211_local_check(local, REPORTS_TX_ACK_STATUS)) {
 			tidstats->filled |=
 				BIT(NL80211_TID_STATS_TX_MSDU_FAILED);
 			tidstats->tx_msdu_failed =
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 5bad05e9af90..f07104ec5c99 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -182,7 +182,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 	struct ieee80211_local *local = sta->local;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 
-	if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+	if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 		sta->rx_stats.last_rx = jiffies;
 
 	if (ieee80211_is_data_qos(mgmt->frame_control)) {
@@ -415,7 +415,7 @@ static void ieee80211_tdls_td_tx_handle(struct ieee80211_local *local,
 
 	if (is_teardown) {
 		/* This mechanism relies on being able to get ACKs */
-		WARN_ON(!ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS));
+		WARN_ON(!ieee80211_local_check(local, REPORTS_TX_ACK_STATUS));
 
 		/* Check if peer has ACKed */
 		if (flags & IEEE80211_TX_STAT_ACK) {
@@ -783,7 +783,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 					ieee80211_get_qos_ctl(hdr),
 					sta, true, acked);
 
-		if (ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL) &&
+		if (ieee80211_local_check(local, HAS_RATE_CONTROL) &&
 		    (ieee80211_is_data(hdr->frame_control)) &&
 		    (rates_idx != -1))
 			sta->tx_stats.last_rate =
@@ -853,11 +853,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 			ieee80211_frame_acked(sta, skb);
 
 		if ((sta->sdata->vif.type == NL80211_IFTYPE_STATION) &&
-		    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS))
+		    ieee80211_local_check(local, REPORTS_TX_ACK_STATUS))
 			ieee80211_sta_tx_notify(sta->sdata, (void *) skb->data,
 						acked, info->status.tx_time);
 
-		if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
+		if (ieee80211_local_check(local, REPORTS_TX_ACK_STATUS)) {
 			if (info->flags & IEEE80211_TX_STAT_ACK) {
 				if (sta->status_stats.lost_packets)
 					sta->status_stats.lost_packets = 0;
@@ -906,7 +906,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 
 	if (ieee80211_is_nullfunc(fc) && ieee80211_has_pm(fc) &&
-	    ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS) &&
+	    ieee80211_local_check(local, REPORTS_TX_ACK_STATUS) &&
 	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
 	    local->ps_sdata && !(local->scanning)) {
 		if (info->flags & IEEE80211_TX_STAT_ACK) {
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index c9eeb3f12808..6aca8572b8de 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -44,7 +44,7 @@ static void ieee80211_tdls_add_ext_capab(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool chan_switch = local->hw.wiphy->features &
 			   NL80211_FEATURE_TDLS_CHANNEL_SWITCH;
-	bool wider_band = ieee80211_hw_check(&local->hw, TDLS_WIDER_BW) &&
+	bool wider_band = ieee80211_local_check(local, TDLS_WIDER_BW) &&
 			  !ifmgd->tdls_wider_bw_prohibited;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
 	struct ieee80211_supported_band *sband = local->hw.wiphy->bands[band];
@@ -1022,7 +1022,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	 * packet through the AP.
 	 */
 	if ((action_code == WLAN_TDLS_TEARDOWN) &&
-	    ieee80211_hw_check(&sdata->local->hw, REPORTS_TX_ACK_STATUS)) {
+	    ieee80211_local_check(sdata->local, REPORTS_TX_ACK_STATUS)) {
 		bool try_resend; /* Should we keep skb for possible resend */
 
 		/* If not sending directly to peer - no point in keeping skb */
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index bdc224d5053a..6356a95788cc 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -211,11 +211,11 @@ ieee80211_tx_h_dynamic_ps(struct ieee80211_tx_data *tx)
 	struct ieee80211_if_managed *ifmgd;
 
 	/* driver doesn't support power save */
-	if (!ieee80211_hw_check(&local->hw, SUPPORTS_PS))
+	if (!ieee80211_local_check(local, SUPPORTS_PS))
 		return TX_CONTINUE;
 
 	/* hardware does dynamic power save */
-	if (ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS))
+	if (ieee80211_local_check(local, SUPPORTS_DYNAMIC_PS))
 		return TX_CONTINUE;
 
 	/* dynamic power save disabled */
@@ -428,7 +428,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	if (ieee80211_is_probe_req(hdr->frame_control))
 		return TX_CONTINUE;
 
-	if (ieee80211_hw_check(&tx->local->hw, QUEUE_CONTROL))
+	if (ieee80211_local_check(tx->local, QUEUE_CONTROL))
 		info->hw_queue = tx->sdata->vif.cab_queue;
 
 	/* no stations in PS mode */
@@ -438,7 +438,7 @@ ieee80211_tx_h_multicast_ps_buf(struct ieee80211_tx_data *tx)
 	info->flags |= IEEE80211_TX_CTL_SEND_AFTER_DTIM;
 
 	/* device releases frame after DTIM beacon */
-	if (!ieee80211_hw_check(&tx->local->hw, HOST_BROADCAST_PS_BUFFERING))
+	if (!ieee80211_local_check(tx->local, HOST_BROADCAST_PS_BUFFERING))
 		return TX_CONTINUE;
 
 	/* buffered in mac80211 */
@@ -1184,8 +1184,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
 	    !ieee80211_is_qos_nullfunc(hdr->frame_control) &&
-	    ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION) &&
-	    !ieee80211_hw_check(&local->hw, TX_AMPDU_SETUP_IN_HW)) {
+	    ieee80211_local_check(local, AMPDU_AGGREGATION) &&
+	    !ieee80211_local_check(local, TX_AMPDU_SETUP_IN_HW)) {
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
@@ -1430,7 +1430,7 @@ static bool __ieee80211_tx(struct ieee80211_local *local,
 			vif = &sdata->vif;
 			info->hw_queue =
 				vif->hw_queue[skb_get_queue_mapping(skb)];
-		} else if (ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
+		} else if (ieee80211_local_check(local, QUEUE_CONTROL)) {
 			dev_kfree_skb(skb);
 			return true;
 		} else
@@ -1476,7 +1476,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	CALL_TXH(ieee80211_tx_h_ps_buf);
 	CALL_TXH(ieee80211_tx_h_check_control_port_protocol);
 	CALL_TXH(ieee80211_tx_h_select_key);
-	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
+	if (!ieee80211_local_check(tx->local, HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
 
 	if (unlikely(info->flags & IEEE80211_TX_INTFL_RETRANSMISSION)) {
@@ -1491,7 +1491,7 @@ static int invoke_tx_handlers(struct ieee80211_tx_data *tx)
 	/* handlers after fragment must be aware of tx info fragmentation! */
 	CALL_TXH(ieee80211_tx_h_stats);
 	CALL_TXH(ieee80211_tx_h_encrypt);
-	if (!ieee80211_hw_check(&tx->local->hw, HAS_RATE_CONTROL))
+	if (!ieee80211_local_check(tx->local, HAS_RATE_CONTROL))
 		CALL_TXH(ieee80211_tx_h_calculate_duration);
 #undef CALL_TXH
 
@@ -1581,7 +1581,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 
 	/* set up hw_queue value early */
 	if (!(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN) ||
-	    !ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+	    !ieee80211_local_check(local, QUEUE_CONTROL))
 		info->hw_queue =
 			sdata->vif.hw_queue[skb_get_queue_mapping(skb)];
 
@@ -1608,7 +1608,7 @@ static int ieee80211_skb_resize(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (skb_cloned(skb) &&
-	    (!ieee80211_hw_check(&local->hw, SUPPORTS_CLONED_SKBS) ||
+	    (!ieee80211_local_check(local, SUPPORTS_CLONED_SKBS) ||
 	     !skb_clone_writable(skb, ETH_HLEN) ||
 	     (may_encrypt && sdata->crypto_tx_tailroom_needed_cnt)))
 		I802_DEBUG_INC(local->tx_expand_skb_head_cloned);
@@ -2427,7 +2427,7 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	__le16 fc;
 
-	if (!ieee80211_hw_check(&local->hw, SUPPORT_FAST_XMIT))
+	if (!ieee80211_local_check(local, SUPPORT_FAST_XMIT))
 		return;
 
 	/* Locking here protects both the pointer itself, and against concurrent
@@ -2443,8 +2443,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 	 * cleared/changed already.
 	 */
 	spin_lock_bh(&sta->lock);
-	if (ieee80211_hw_check(&local->hw, SUPPORTS_PS) &&
-	    !ieee80211_hw_check(&local->hw, SUPPORTS_DYNAMIC_PS) &&
+	if (ieee80211_local_check(local, SUPPORTS_PS) &&
+	    !ieee80211_local_check(local, SUPPORTS_DYNAMIC_PS) &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION)
 		goto out;
 
@@ -2797,7 +2797,7 @@ static bool ieee80211_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (fast_tx->key)
 		info->control.hw_key = &fast_tx->key->conf;
 
-	if (!ieee80211_hw_check(&local->hw, HAS_RATE_CONTROL)) {
+	if (!ieee80211_local_check(local, HAS_RATE_CONTROL)) {
 		tx.skb = skb;
 		r = ieee80211_tx_h_rate_ctrl(&tx);
 		skb = tx.skb;
@@ -3529,7 +3529,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 	if (tim_length)
 		*tim_length = offs.tim_length;
 
-	if (ieee80211_hw_check(hw, BEACON_TX_STATUS) ||
+	if (ieee80211_local_check(hw_to_local(hw), BEACON_TX_STATUS) ||
 	    !hw_to_local(hw)->monitors)
 		return bcn;
 
@@ -3839,7 +3839,7 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 	synchronize_net();
 
 	/* Tear down BA sessions so we stop aggregating on this TID */
-	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION)) {
+	if (ieee80211_local_check(local, AMPDU_AGGREGATION)) {
 		set_sta_flag(sta, WLAN_STA_BLOCK_BA);
 		__ieee80211_stop_tx_ba_session(sta, tid,
 					       AGG_STOP_LOCAL_REQUEST);
@@ -3853,7 +3853,7 @@ int ieee80211_reserve_tid(struct ieee80211_sta *pubsta, u8 tid)
 	ieee80211_wake_vif_queues(local, sdata,
 				  IEEE80211_QUEUE_STOP_REASON_RESERVE_TID);
 
-	if (ieee80211_hw_check(&local->hw, AMPDU_AGGREGATION))
+	if (ieee80211_local_check(local, AMPDU_AGGREGATION))
 		clear_sta_flag(sta, WLAN_STA_BLOCK_BA);
 
 	ret = 0;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 74058020b7d6..6cffa4a6face 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -516,7 +516,7 @@ ieee80211_get_vif_queues(struct ieee80211_local *local,
 {
 	unsigned int queues;
 
-	if (sdata && ieee80211_hw_check(&local->hw, QUEUE_CONTROL)) {
+	if (sdata && ieee80211_local_check(local, QUEUE_CONTROL)) {
 		int ac;
 
 		queues = 0;
@@ -544,7 +544,7 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 	 * If no queue was set, or if the HW doesn't support
 	 * IEEE80211_HW_QUEUE_CONTROL - flush all queues
 	 */
-	if (!queues || !ieee80211_hw_check(&local->hw, QUEUE_CONTROL))
+	if (!queues || !ieee80211_local_check(local, QUEUE_CONTROL))
 		queues = ieee80211_get_vif_queues(local, sdata);
 
 	ieee80211_stop_queues_by_reason(&local->hw, queues,
@@ -2041,7 +2041,7 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * about the sessions, but we and the AP still think they
 	 * are active. This is really a workaround though.
 	 */
-	if (ieee80211_hw_check(hw, AMPDU_AGGREGATION)) {
+	if (ieee80211_local_check(local, AMPDU_AGGREGATION)) {
 		mutex_lock(&local->sta_mtx);
 
 		list_for_each_entry(sta, &local->sta_list, list) {
-- 
2.6.2

