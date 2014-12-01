Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:47662 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaLAKaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2014 05:30:17 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so16801634wiv.14
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2014 02:30:16 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de, adrian@freebsd.org
Subject: [PATCHv2] mac80211: enable TPC through mac80211 stack
Date: Mon,  1 Dec 2014 11:30:14 +0100
Message-Id: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20141201_113026_970608_05B2BB00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable/disable per packet Transmit Power Control (TPC) in lower drivers
according to TX power settings configured by the user. In particular TPC is
enabled if value passed in enum nl80211_tx_power_setting is
NL80211_TX_POWER_AUTOMATIC (no limit from userspace) or
NL80211_TX_POWER_LIMITED (allow using less than specified from userspace),
whereas TPC is disabled if nl80211_tx_power_setting is set to
NL80211_TX_POWER_FIXED (use value configured from userspace)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h     | 10 ++++++++++
 net/mac80211/cfg.c         |  6 +++++-
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       |  8 +++++++-
 net/mac80211/main.c        |  8 +++++++-
 5 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cff3a26..7dd2432 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -376,6 +376,8 @@ enum ieee80211_rssi_event {
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
+ * @tpc_enabled: enable/disable per packet Transmit Power Control (TPC) for the
+ *	current vif
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
  */
 struct ieee80211_bss_conf {
@@ -411,6 +413,7 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
+	bool tpc_enabled;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };
 
@@ -1115,6 +1118,12 @@ enum ieee80211_smps_mode {
  *
  * @power_level: requested transmit power (in dBm), backward compatibility
  *	value only that is set to the minimum of all interfaces
+ * @tpc_enabled: enable/disable per packet Transmit Power Control (TPC) in
+ *	lower driver. TPC is enabled if value passed in
+ *	nl80211_tx_power_setting is %NL80211_TX_POWER_AUTOMATIC (no limit from
+ *	userspace) or %NL80211_TX_POWER_LIMITED (allow using less than
+ *	specified from userspace), whereas TPC is disabled if
+ *	nl80211_tx_power_setting is set to %NL80211_TX_POWER_FIXED
  *
  * @chandef: the channel definition to tune to
  * @radar_enabled: whether radar detection is enabled
@@ -1135,6 +1144,7 @@ enum ieee80211_smps_mode {
 struct ieee80211_conf {
 	u32 flags;
 	int power_level, dynamic_ps_timeout;
+	bool tpc_enabled;
 	int max_sleep_period;
 
 	u16 listen_interval;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e75d5c5..05829d5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2118,6 +2118,8 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 			break;
 		}
 
+		sdata->tx_power_type = type;
+
 		ieee80211_recalc_txpower(sdata);
 
 		return 0;
@@ -2136,8 +2138,10 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	}
 
 	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list)
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		sdata->user_power_level = local->user_power_level;
+		sdata->tx_power_type = type;
+	}
 	list_for_each_entry(sdata, &local->interfaces, list)
 		ieee80211_recalc_txpower(sdata);
 	mutex_unlock(&local->iflist_mtx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cc6e964..0c6c7a4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -869,6 +869,7 @@ struct ieee80211_sub_if_data {
 
 	int user_power_level; /* in dBm */
 	int ap_power_level; /* in dBm */
+	enum nl80211_tx_power_setting tx_power_type;
 
 	bool radar_required;
 	struct delayed_work dfs_cac_timer_work;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 538fe4e..33277e2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -47,6 +47,7 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	int power;
+	bool tpc_enabled;
 
 	rcu_read_lock();
 	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
@@ -64,8 +65,13 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 	if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL)
 		power = min(power, sdata->ap_power_level);
 
-	if (power != sdata->vif.bss_conf.txpower) {
+	tpc_enabled = (sdata->tx_power_type == NL80211_TX_POWER_AUTOMATIC ||
+		       sdata->tx_power_type == NL80211_TX_POWER_LIMITED);
+
+	if (power != sdata->vif.bss_conf.txpower ||
+	    tpc_enabled != sdata->vif.bss_conf.tpc_enabled) {
 		sdata->vif.bss_conf.txpower = power;
+		sdata->vif.bss_conf.tpc_enabled = tpc_enabled;
 		ieee80211_hw_config(sdata->local, 0);
 		return true;
 	}
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6ab99da..bfcaeee 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -100,6 +100,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 	u32 changed = 0;
 	int power;
 	u32 offchannel_flag;
+	bool tpc_enabled = false;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
@@ -152,12 +153,17 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 			continue;
 		power = min(power, sdata->vif.bss_conf.txpower);
+
+		if (!tpc_enabled && sdata->vif.bss_conf.tpc_enabled)
+			tpc_enabled = true;
 	}
 	rcu_read_unlock();
 
-	if (local->hw.conf.power_level != power) {
+	if (local->hw.conf.power_level != power ||
+	    local->hw.conf.tpc_enabled != tpc_enabled) {
 		changed |= IEEE80211_CONF_CHANGE_POWER;
 		local->hw.conf.power_level = power;
+		local->hw.conf.tpc_enabled = tpc_enabled;
 	}
 
 	return changed;
-- 
2.1.0

