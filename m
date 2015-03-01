Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbCAHKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:37 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/16] mac80211: tell drivers the user TX power restriction
Date: Sun,  1 Mar 2015 09:10:05 +0200
Message-Id: <1425193815-17785-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081046_434588_D9AF83D5)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Allow drivers to obtain the user's TX power restrictions in
order to be able to  apply it properly on (for example)
hardware scanning which operations on a set of channels,
in which case mac80211 cannot properly apply the per-channel
regulatory limits, and the currently exposed txpower value,
which is the minimum  of the user setting, channel regulatory
and possible 11h AP reduction isn't  appropriate to use
since scanning is done on many channels.

Note that drivers need to be careful when using this value
and must ensure that  regulatory is maintained, i.e. the
new value cannot be used as-is.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h        |  9 +++++++++
 net/mac80211/cfg.c            | 44 +++++++++++++++++++++++++++++++++----------
 net/mac80211/chan.c           |  4 ++--
 net/mac80211/debugfs_netdev.c |  2 +-
 net/mac80211/ieee80211_i.h    |  4 +---
 net/mac80211/iface.c          | 12 ++++++------
 6 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3a029f0..78ecfe5 100644
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
@@ -385,6 +387,12 @@ enum ieee80211_rssi_event {
  *	NL80211_TX_POWER_LIMITED (allow using less than specified from
  *	userspace), whereas TPC is disabled if %txpower_type is set to
  *	NL80211_TX_POWER_FIXED (use value configured from userspace)
+ * @user_power_level: TX power limit requested by the user (in dBm).
+ *	This must be used carefully, it isn't restricted by regulatory.
+ *	However, it could be used for example for hardware scanning to limit
+ *	the TX power to the user-requested level, while also limiting to the
+ *	correct per-channel regulatory. Similarly for other out-of-channel
+ *	activities where mac80211 cannot correctly set the TX power level.
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
  */
 struct ieee80211_bss_conf {
@@ -421,6 +429,7 @@ struct ieee80211_bss_conf {
 	bool hidden_ssid;
 	int txpower;
 	enum nl80211_tx_power_setting txpower_type;
+	int user_power_level;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36..02f1125 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2142,30 +2142,44 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
 	enum nl80211_tx_power_setting txp_type = type;
-	bool update_txp_type = false;
 
 	if (wdev) {
+		int old_user_level, new_user_level;
+		u32 change = 0;
+
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+		old_user_level = sdata->vif.bss_conf.user_power_level;
+		new_user_level = old_user_level;
 
 		switch (type) {
 		case NL80211_TX_POWER_AUTOMATIC:
-			sdata->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
+			new_user_level = IEEE80211_UNSET_POWER_LEVEL;
 			txp_type = NL80211_TX_POWER_LIMITED;
 			break;
 		case NL80211_TX_POWER_LIMITED:
 		case NL80211_TX_POWER_FIXED:
 			if (mbm < 0 || (mbm % 100))
 				return -EOPNOTSUPP;
-			sdata->user_power_level = MBM_TO_DBM(mbm);
+			new_user_level = MBM_TO_DBM(mbm);
 			break;
 		}
 
 		if (txp_type != sdata->vif.bss_conf.txpower_type) {
-			update_txp_type = true;
 			sdata->vif.bss_conf.txpower_type = txp_type;
+			change |= BSS_CHANGED_TXPOWER;
+		}
+
+		if (old_user_level != new_user_level) {
+			change |= BSS_CHANGED_USER_TXPOWER;
+			sdata->vif.bss_conf.user_power_level = new_user_level;
 		}
 
-		ieee80211_recalc_txpower(sdata, update_txp_type);
+		if (!change)
+			return 0;
+
+		if (__ieee80211_recalc_txpower(sdata))
+			change |= BSS_CHANGED_TXPOWER;
+		ieee80211_bss_info_change_notify(sdata, change);
 
 		return 0;
 	}
@@ -2185,13 +2199,23 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		sdata->user_power_level = local->user_power_level;
-		if (txp_type != sdata->vif.bss_conf.txpower_type)
-			update_txp_type = true;
+		u32 change = 0;
+
+		if (sdata->vif.bss_conf.user_power_level !=
+				local->user_power_level) {
+			change |= BSS_CHANGED_USER_TXPOWER;
+			sdata->vif.bss_conf.user_power_level =
+						local->user_power_level;
+		}
+
+		if (__ieee80211_recalc_txpower(sdata) ||
+		    txp_type != sdata->vif.bss_conf.txpower_type)
+			change |= BSS_CHANGED_TXPOWER;
 		sdata->vif.bss_conf.txpower_type = txp_type;
+
+		if (change)
+			ieee80211_bss_info_change_notify(sdata, change);
 	}
-	list_for_each_entry(sdata, &local->interfaces, list)
-		ieee80211_recalc_txpower(sdata, update_txp_type);
 	mutex_unlock(&local->iflist_mtx);
 
 	return 0;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 5bcd4e5..0259671 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -655,7 +655,7 @@ out:
 	}
 
 	if (new_ctx && ieee80211_chanctx_num_assigned(local, new_ctx) > 0) {
-		ieee80211_recalc_txpower(sdata, false);
+		ieee80211_recalc_txpower(sdata);
 		ieee80211_recalc_chanctx_min_def(local, new_ctx);
 	}
 
@@ -1387,7 +1387,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 				ieee80211_bss_info_change_notify(sdata,
 								 changed);
 
-			ieee80211_recalc_txpower(sdata, false);
+			ieee80211_recalc_txpower(sdata);
 		}
 
 		ieee80211_recalc_chanctx_chantype(local, ctx);
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c68896a..40cea0c 100644
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
index 2891e40..09cdd25 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -867,7 +867,6 @@ struct ieee80211_sub_if_data {
 	u8 needed_rx_chains;
 	enum ieee80211_smps_mode smps_mode;
 
-	int user_power_level; /* in dBm */
 	int ap_power_level; /* in dBm */
 
 	bool radar_required;
@@ -1621,8 +1620,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
 void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
-void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata,
-			      bool update_bss);
+void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 81a2751..b49812f 100644
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
@@ -73,10 +74,9 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 	return false;
 }
 
-void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata,
-			      bool update_bss)
+void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 {
-	if (__ieee80211_recalc_txpower(sdata) || update_bss)
+	if (__ieee80211_recalc_txpower(sdata))
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
 }
 
@@ -1745,7 +1745,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	ieee80211_set_default_queues(sdata);
 
 	sdata->ap_power_level = IEEE80211_UNSET_POWER_LEVEL;
-	sdata->user_power_level = local->user_power_level;
+	sdata->vif.bss_conf.user_power_level = local->user_power_level;
 
 	sdata->encrypt_headroom = IEEE80211_ENCRYPT_HEADROOM;
 
-- 
1.9.1

