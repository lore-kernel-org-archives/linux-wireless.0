Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550Ab2JZNSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 09:18:51 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3/4] mac80211: handle TX power per virtual interface
Date: Fri, 26 Oct 2012 15:19:21 +0200
Message-Id: <1351257562-30729-4-git-send-email-johannes@sipsolutions.net> (sfid-20121026_151857_944623_FAC2EFF4)
In-Reply-To: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
References: <1351257562-30729-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even before channel contexts/multi-channel, having a
single global TX power limit was already problematic,
in particular if two managed interfaces connected to
two APs with different power constraints. The channel
context introduction completely broke this though and
in fact I had disabled TX power configuration there
for drivers using channel contexts.

Change everything to track TX power per interface so
that different user settings and different channel
maxima are treated correctly. Also continue tracking
the global TX power though for compatibility with
applications that attempt to configure the wiphy's
TX power globally.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h        |    7 +++++-
 net/mac80211/cfg.c            |   47 ++++++++++++++++++++++++++++-------------
 net/mac80211/chan.c           |    2 ++
 net/mac80211/debugfs_netdev.c |    6 ++++++
 net/mac80211/ieee80211_i.h    |   12 +++++++++--
 net/mac80211/iface.c          |   38 +++++++++++++++++++++++++++++++++
 net/mac80211/main.c           |   27 +++++++++++++----------
 net/mac80211/mlme.c           |   32 +++++++++++++++-------------
 net/mac80211/trace.h          |    2 ++
 net/mac80211/util.c           |    3 ++-
 10 files changed, 131 insertions(+), 45 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5f53274..dfa589b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -207,6 +207,7 @@ struct ieee80211_chanctx_conf {
  * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
  * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
  * @BSS_CHANGED_PS: PS changed for this BSS (STA mode)
+ * @BSS_CHANGED_TXPOWER: TX power setting changed for this interface
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -227,6 +228,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_SSID		= 1<<15,
 	BSS_CHANGED_AP_PROBE_RESP	= 1<<16,
 	BSS_CHANGED_PS			= 1<<17,
+	BSS_CHANGED_TXPOWER		= 1<<18,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -309,6 +311,7 @@ enum ieee80211_rssi_event {
  * @ssid: The SSID of the current vif. Only valid in AP-mode.
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
+ * @txpower: TX power in dBm
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -341,6 +344,7 @@ struct ieee80211_bss_conf {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	bool hidden_ssid;
+	int txpower;
 };
 
 /**
@@ -884,7 +888,8 @@ enum ieee80211_smps_mode {
  *	powersave documentation below. This variable is valid only when
  *	the CONF_PS flag is set.
  *
- * @power_level: requested transmit power (in dBm)
+ * @power_level: requested transmit power (in dBm), backward compatibility
+ *	value only that is set to the minimum of all interfaces
  *
  * @channel: the channel to tune to
  * @channel_type: the channel (HT) type
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a352e4d..986e9a1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1996,33 +1996,46 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_channel *chan = local->_oper_channel;
-	u32 changes = 0;
+	struct ieee80211_sub_if_data *sdata;
 
-	/* FIXME */
-	if (local->use_chanctx)
-		return -EOPNOTSUPP;
+	if (wdev) {
+		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+		switch (type) {
+		case NL80211_TX_POWER_AUTOMATIC:
+			sdata->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
+			break;
+		case NL80211_TX_POWER_LIMITED:
+		case NL80211_TX_POWER_FIXED:
+			if (mbm < 0 || (mbm % 100))
+				return -EOPNOTSUPP;
+			sdata->user_power_level = MBM_TO_DBM(mbm);
+			break;
+		}
+
+		ieee80211_recalc_txpower(sdata);
+
+		return 0;
+	}
 
 	switch (type) {
 	case NL80211_TX_POWER_AUTOMATIC:
-		local->user_power_level = -1;
+		local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
 		break;
 	case NL80211_TX_POWER_LIMITED:
-		if (mbm < 0 || (mbm % 100))
-			return -EOPNOTSUPP;
-		local->user_power_level = MBM_TO_DBM(mbm);
-		break;
 	case NL80211_TX_POWER_FIXED:
 		if (mbm < 0 || (mbm % 100))
 			return -EOPNOTSUPP;
-		/* TODO: move to cfg80211 when it knows the channel */
-		if (MBM_TO_DBM(mbm) > chan->max_power)
-			return -EINVAL;
 		local->user_power_level = MBM_TO_DBM(mbm);
 		break;
 	}
 
-	ieee80211_hw_config(local, changes);
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list)
+		sdata->user_power_level = local->user_power_level;
+	list_for_each_entry(sdata, &local->interfaces, list)
+		ieee80211_recalc_txpower(sdata);
+	mutex_unlock(&local->iflist_mtx);
 
 	return 0;
 }
@@ -2032,8 +2045,12 @@ static int ieee80211_get_tx_power(struct wiphy *wiphy,
 				  int *dbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 
-	*dbm = local->hw.conf.power_level;
+	if (!local->use_chanctx)
+		*dbm = local->hw.conf.power_level;
+	else
+		*dbm = sdata->vif.bss_conf.txpower;
 
 	return 0;
 }
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index f84b860..a2b06d4 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -173,6 +173,8 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
 	ctx->refcount++;
 
+	ieee80211_recalc_txpower(sdata);
+
 	return 0;
 }
 
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 3393ad5..07c5721 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -168,6 +168,9 @@ IEEE80211_IF_FILE(rc_rateidx_mcs_mask_5ghz,
 IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
 IEEE80211_IF_FILE(channel_type, vif.bss_conf.channel_type, DEC);
+IEEE80211_IF_FILE(txpower, vif.bss_conf.txpower, DEC);
+IEEE80211_IF_FILE(ap_power_level, ap_power_level, DEC);
+IEEE80211_IF_FILE(user_power_level, user_power_level, DEC);
 
 /* STA attributes */
 IEEE80211_IF_FILE(bssid, u.mgd.bssid, MAC);
@@ -632,6 +635,9 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	DEBUGFS_ADD(flags);
 	DEBUGFS_ADD(state);
 	DEBUGFS_ADD(channel_type);
+	DEBUGFS_ADD(txpower);
+	DEBUGFS_ADD(user_power_level);
+	DEBUGFS_ADD(ap_power_level);
 
 	if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
 		add_common_files(sdata);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3026519..a1f7c13 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -56,6 +56,9 @@ struct ieee80211_local;
 #define TU_TO_JIFFIES(x)	(usecs_to_jiffies((x) * 1024))
 #define TU_TO_EXP_TIME(x)	(jiffies + TU_TO_JIFFIES(x))
 
+/* power level hasn't been configured (or set to automatic) */
+#define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
+
 /*
  * Some APs experience problems when working with U-APSD. Decrease the
  * probability of that happening by using legacy mode for all ACs but VO.
@@ -743,6 +746,9 @@ struct ieee80211_sub_if_data {
 	u8 needed_rx_chains;
 	enum ieee80211_smps_mode smps_mode;
 
+	int user_power_level; /* in dBm */
+	int ap_power_level; /* in dBm */
+
 	/*
 	 * AP this belongs to: self in AP mode and
 	 * corresponding AP in VLAN mode, NULL for
@@ -1117,8 +1123,7 @@ struct ieee80211_local {
 	int dynamic_ps_user_timeout;
 	bool disable_dynamic_ps;
 
-	int user_power_level; /* in dBm */
-	int ap_power_level; /* in dBm */
+	int user_power_level; /* in dBm, for all interfaces */
 
 	enum ieee80211_smps_mode smps_mode;
 
@@ -1365,6 +1370,9 @@ void ieee80211_adjust_monitor_flags(struct ieee80211_sub_if_data *sdata,
 int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up);
 void ieee80211_sdata_stop(struct ieee80211_sub_if_data *sdata);
 
+bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
+void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
+
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
 	return test_bit(SDATA_STATE_RUNNING, &sdata->state);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 944c6cf..1ee2f52 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -42,6 +42,41 @@
  * by either the RTNL, the iflist_mtx or RCU.
  */
 
+bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	int power;
+
+	rcu_read_lock();
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (!chanctx_conf) {
+		rcu_read_unlock();
+		return false;
+	}
+
+	power = chanctx_conf->channel->max_power;
+	rcu_read_unlock();
+
+	if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(power, sdata->user_power_level);
+
+	if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL)
+		power = min(power, sdata->ap_power_level);
+
+	if (power != sdata->vif.bss_conf.txpower) {
+		sdata->vif.bss_conf.txpower = power;
+		ieee80211_hw_config(sdata->local, 0);
+		return true;
+	}
+
+	return false;
+}
+
+void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
+{
+	if (__ieee80211_recalc_txpower(sdata))
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
+}
 
 static u32 ieee80211_idle_off(struct ieee80211_local *local,
 			      const char *reason)
@@ -1510,6 +1545,9 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 	ieee80211_set_default_queues(sdata);
 
+	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
+	sdata->user_power_level = local->user_power_level;
+
 	/* setup type-dependent data */
 	ieee80211_setup_sdata(sdata, type);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index fd8345c..70e8760 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -95,11 +95,13 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 
 static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 {
+	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *chan;
 	u32 changed = 0;
 	int power;
 	enum nl80211_channel_type channel_type;
 	u32 offchannel_flag;
+	bool scanning = false;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 	if (local->scan_channel) {
@@ -146,16 +148,18 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
-	    test_bit(SCAN_HW_SCANNING, &local->scanning) ||
-	    !local->ap_power_level)
-		power = chan->max_power;
-	else
-		power = min(chan->max_power, local->ap_power_level);
+	scanning = test_bit(SCAN_SW_SCANNING, &local->scanning) ||
+		   test_bit(SCAN_ONCHANNEL_SCANNING, &local->scanning) ||
+		   test_bit(SCAN_HW_SCANNING, &local->scanning);
+	power = chan->max_power;
 
-	if (local->user_power_level >= 0)
-		power = min(power, local->user_power_level);
+	rcu_read_lock();
+	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+		if (!rcu_access_pointer(sdata->vif.chanctx_conf))
+			continue;
+		power = min(power, sdata->vif.bss_conf.txpower);
+	}
+	rcu_read_unlock();
 
 	if (local->hw.conf.power_level != power) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
@@ -600,7 +604,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 
 	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS |
 			   NL80211_FEATURE_SAE |
-			   NL80211_FEATURE_HT_IBSS;
+			   NL80211_FEATURE_HT_IBSS |
+			   NL80211_FEATURE_VIF_TXPOWER;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
@@ -633,7 +638,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->hw.radiotap_mcs_details = IEEE80211_RADIOTAP_MCS_HAVE_MCS |
 					 IEEE80211_RADIOTAP_MCS_HAVE_GI |
 					 IEEE80211_RADIOTAP_MCS_HAVE_BW;
-	local->user_power_level = -1;
+	local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
 	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 
 	INIT_LIST_HEAD(&local->interfaces);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2bdf776..91c90ac 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -820,10 +820,10 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 					 cbss->beacon_interval));
 }
 
-static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
-					struct ieee80211_channel *channel,
-					const u8 *country_ie, u8 country_ie_len,
-					const u8 *pwr_constr_elem)
+static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_channel *channel,
+				       const u8 *country_ie, u8 country_ie_len,
+				       const u8 *pwr_constr_elem)
 {
 	struct ieee80211_country_ie_triplet *triplet;
 	int chan = ieee80211_frequency_to_channel(channel->center_freq);
@@ -832,7 +832,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 
 	/* Invalid IE */
 	if (country_ie_len % 2 || country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
-		return;
+		return 0;
 
 	triplet = (void *)(country_ie + 3);
 	country_ie_len -= 3;
@@ -873,19 +873,21 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (!have_chan_pwr)
-		return;
+		return 0;
 
 	new_ap_level = max_t(int, 0, chan_pwr - *pwr_constr_elem);
 
-	if (sdata->local->ap_power_level == new_ap_level)
-		return;
+	if (sdata->ap_power_level == new_ap_level)
+		return 0;
 
 	sdata_info(sdata,
 		   "Limiting TX power to %d (%d - %d) dBm as advertised by %pM\n",
 		   new_ap_level, chan_pwr, *pwr_constr_elem,
 		   sdata->u.mgd.bssid);
-	sdata->local->ap_power_level = new_ap_level;
-	ieee80211_hw_config(sdata->local, 0);
+	sdata->ap_power_level = new_ap_level;
+	if (__ieee80211_recalc_txpower(sdata))
+		return BSS_CHANGED_TXPOWER;
+	return 0;
 }
 
 void ieee80211_enable_dyn_ps(struct ieee80211_vif *vif)
@@ -1489,7 +1491,7 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
 	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
 
-	local->ap_power_level = 0;
+	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
 
 	del_timer_sync(&local->dynamic_ps_timer);
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -2623,10 +2625,10 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (elems.country_elem && elems.pwr_constr_elem &&
 	    mgmt->u.probe_resp.capab_info &
 				cpu_to_le16(WLAN_CAPABILITY_SPECTRUM_MGMT))
-		ieee80211_handle_pwr_constr(sdata, chan,
-					    elems.country_elem,
-					    elems.country_elem_len,
-					    elems.pwr_constr_elem);
+		changed |= ieee80211_handle_pwr_constr(sdata, chan,
+						       elems.country_elem,
+						       elems.country_elem_len,
+						       elems.pwr_constr_elem);
 
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 5e74e77..eeebbd9 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -342,6 +342,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__field(bool, ps);
 		__dynamic_array(u8, ssid, info->ssid_len);
 		__field(bool, hidden_ssid);
+		__field(int, txpower)
 	),
 
 	TP_fast_assign(
@@ -376,6 +377,7 @@ TRACE_EVENT(drv_bss_info_changed,
 		__entry->ps = info->ps;
 		memcpy(__get_dynamic_array(ssid), info->ssid, info->ssid_len);
 		__entry->hidden_ssid = info->hidden_ssid;
+		__entry->txpower = info->txpower;
 	),
 
 	TP_printk(
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index dd0e6f2..7fbd77b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1450,7 +1450,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_BSSID |
 			  BSS_CHANGED_CQM |
 			  BSS_CHANGED_QOS |
-			  BSS_CHANGED_IDLE;
+			  BSS_CHANGED_IDLE |
+			  BSS_CHANGED_TXPOWER;
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
-- 
1.7.10.4

