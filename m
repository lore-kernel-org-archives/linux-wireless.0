Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:1342 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbbATUQY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 15:16:24 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: tell drivers the user TX power restriction
Date: Tue, 20 Jan 2015 22:15:45 +0200
Message-Id: <1421784945-7815-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150120_211630_901989_A605EDE5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

When a tx power restriction is set, mac80211 protects its downstream
stack by taking min(user, regulatory, 11h ap). However, we should allow
drivers to use that value as it is - on their own risk.
This might come handy, when tx power is set per phy. As mac80211 has
only a concept of "per-vif" tx power, it iterates over the active vifs,
and sets their tx power limit accordingly. Allowing this value to
proliferate downstream unchanged, the driver might use this legacy
api differently, e.g. to set tx power for the whole device.

Change-Id: I4a77b1131bf02f5e0a967132a7c6c3a1cd186e13
Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h        |  9 +++++++++
 net/mac80211/cfg.c            | 37 ++++++++++++++++++++++++++++++-------
 net/mac80211/debugfs_netdev.c |  2 +-
 net/mac80211/ieee80211_i.h    |  1 -
 net/mac80211/iface.c          |  7 ++++---
 5 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index e4fab94..d11d811 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -264,6 +264,7 @@ struct ieee80211_vif_chanctx_switch {
  *	note that this is only called when it changes after the channel
  *	context had been assigned.
  * @BSS_CHANGED_OCB: OCB join status changed
+ * @BSS_CHANGED_USER_TXPOWER: User TX power setting changed for this interface
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -289,6 +290,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BEACON_INFO		= 1<<20,
 	BSS_CHANGED_BANDWIDTH		= 1<<21,
 	BSS_CHANGED_OCB                 = 1<<22,
+	BSS_CHANGED_USER_TXPOWER	= 1<<23,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -376,6 +378,12 @@ enum ieee80211_rssi_event {
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
+ * @user_power_level: TX power limit requested by the user (in dBm).
+ *	This must be used carefully, it isn't restricted by regulatory.
+ *	However, it could be used for example for hardware scanning to limit
+ *	the TX power to the user-requested level, while also limiting to the
+ *	correct per-channel regulatory. Similarly for other out-of-channel
+ *	activities where mac80211 cannot correctly set the TX power level.
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
  */
 struct ieee80211_bss_conf {
@@ -411,6 +419,7 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
+	int user_power_level;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 84ed7b1..22f5e60 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2109,21 +2109,34 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	struct ieee80211_sub_if_data *sdata;
 
 	if (wdev) {
+		int old_user_level, new_user_level;
+		u32 change;
+
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+		old_user_level = sdata->vif.bss_conf.user_power_level;
+		new_user_level = old_user_level;
 
 		switch (type) {
 		case NL80211_TX_POWER_AUTOMATIC:
-			sdata->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
+			new_user_level = IEEE80211_UNSET_POWER_LEVEL;
 			break;
 		case NL80211_TX_POWER_LIMITED:
 		case NL80211_TX_POWER_FIXED:
 			if (mbm < 0 || (mbm % 100))
 				return -EOPNOTSUPP;
-			sdata->user_power_level = MBM_TO_DBM(mbm);
+			new_user_level = MBM_TO_DBM(mbm);
 			break;
 		}
 
-		ieee80211_recalc_txpower(sdata);
+		if (old_user_level == new_user_level)
+			return 0;
+
+		change = BSS_CHANGED_USER_TXPOWER;
+		sdata->vif.bss_conf.user_power_level = new_user_level;
+
+		if (__ieee80211_recalc_txpower(sdata))
+			change |= BSS_CHANGED_TXPOWER;
+		ieee80211_bss_info_change_notify(sdata, change);
 
 		return 0;
 	}
@@ -2141,10 +2154,20 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	}
 
 	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list)
-		sdata->user_power_level = local->user_power_level;
-	list_for_each_entry(sdata, &local->interfaces, list)
-		ieee80211_recalc_txpower(sdata);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		u32 change = 0;
+
+		if (sdata->vif.bss_conf.user_power_level !=
+				local->user_power_level) {
+			change |= BSS_CHANGED_USER_TXPOWER;
+			sdata->vif.bss_conf.user_power_level =
+						local->user_power_level;
+		}
+		if (__ieee80211_recalc_txpower(sdata))
+			change |= BSS_CHANGED_TXPOWER;
+		if (change)
+			ieee80211_bss_info_change_notify(sdata, change);
+	}
 	mutex_unlock(&local->iflist_mtx);
 
 	return 0;
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index bb625e9..285b094 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -191,7 +191,7 @@ IEEE80211_IF_FILE(flags, flags, HEX);
 IEEE80211_IF_FILE(state, state, LHEX);
 IEEE80211_IF_FILE(txpower, vif.bss_conf.txpower, DEC);
 IEEE80211_IF_FILE(ap_power_level, ap_power_level, DEC);
-IEEE80211_IF_FILE(user_power_level, user_power_level, DEC);
+IEEE80211_IF_FILE(user_power_level, vif.bss_conf.user_power_level, DEC);
 
 static ssize_t
 ieee80211_if_fmt_hw_queues(const struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ac3455b..f6772b4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -867,7 +867,6 @@ struct ieee80211_sub_if_data {
 	u8 needed_rx_chains;
 	enum ieee80211_smps_mode smps_mode;
 
-	int user_power_level; /* in dBm */
 	int ap_power_level; /* in dBm */
 
 	bool radar_required;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 93e4639..a818b3b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -58,8 +58,9 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 	power = ieee80211_chandef_max_power(&chanctx_conf->def);
 	rcu_read_unlock();
 
-	if (sdata->user_power_level != IEEE80211_UNSET_POWER_LEVEL)
-		power = min(power, sdata->user_power_level);
+	if (sdata->vif.bss_conf.user_power_level !=
+	    IEEE80211_UNSET_POWER_LEVEL)
+		power = min(power, sdata->vif.bss_conf.user_power_level);
 
 	if (sdata->ap_power_level != IEEE80211_UNSET_POWER_LEVEL)
 		power = min(power, sdata->ap_power_level);
@@ -1769,7 +1770,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_set_default_queues(sdata);
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
-	sdata->user_power_level = local->user_power_level;
+	sdata->vif.bss_conf.user_power_level = local->user_power_level;
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 
-- 
1.9.1

