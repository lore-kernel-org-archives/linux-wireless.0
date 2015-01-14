Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:49118 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbANLzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 06:55:11 -0500
Received: by mail-wg0-f51.google.com with SMTP id x12so8399367wgg.10
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 03:55:10 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCHv5] mac80211: enable TPC through mac80211 stack
Date: Wed, 14 Jan 2015 12:55:08 +0100
Message-Id: <1421236508-9055-1-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150114_125520_694139_EABE7080)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Control per packet Transmit Power Control (TPC) in lower drivers
according to TX power settings configured by the user. In particular TPC is
enabled if value passed in enum nl80211_tx_power_setting is
NL80211_TX_POWER_LIMITED (allow using less than specified from userspace),
whereas TPC is disabled if nl80211_tx_power_setting is set to
NL80211_TX_POWER_FIXED (use value configured from userspace)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/mac80211.h     |  7 +++++++
 net/mac80211/cfg.c         | 19 ++++++++++++++++---
 net/mac80211/chan.c        |  4 ++--
 net/mac80211/ieee80211_i.h |  3 ++-
 net/mac80211/iface.c       |  5 +++--
 5 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 123f230..bc343d7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -376,6 +376,12 @@ enum ieee80211_rssi_event {
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
  * @txpower: TX power in dBm
+ * @txpower_type: TX power adjustment used to control per packet Transmit
+ *	Power Control (TPC) in lower driver for the current vif. In particular
+ *	TPC is enabled if value passed in %txpower_type is
+ *	NL80211_TX_POWER_LIMITED (allow using less than specified from
+ *	userspace), whereas TPC is disabled if %txpower_type is set to
+ *	NL80211_TX_POWER_FIXED (use value configured from userspace)
  * @p2p_noa_attr: P2P NoA attribute for P2P powersave
  */
 struct ieee80211_bss_conf {
@@ -411,6 +417,7 @@ struct ieee80211_bss_conf {
 	size_t ssid_len;
 	bool hidden_ssid;
 	int txpower;
+	enum nl80211_tx_power_setting txpower_type;
 	struct ieee80211_p2p_noa_attr p2p_noa_attr;
 };
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1696658..d108e47 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2103,6 +2103,8 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata;
+	enum nl80211_tx_power_setting txp_type = type;
+	bool update_txp_type = false;
 
 	if (wdev) {
 		sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
@@ -2110,6 +2112,7 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 		switch (type) {
 		case NL80211_TX_POWER_AUTOMATIC:
 			sdata->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
+			txp_type = NL80211_TX_POWER_LIMITED;
 			break;
 		case NL80211_TX_POWER_LIMITED:
 		case NL80211_TX_POWER_FIXED:
@@ -2119,7 +2122,12 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 			break;
 		}
 
-		ieee80211_recalc_txpower(sdata);
+		if (txp_type != sdata->vif.bss_conf.txpower_type) {
+			update_txp_type = true;
+			sdata->vif.bss_conf.txpower_type = txp_type;
+		}
+
+		ieee80211_recalc_txpower(sdata, update_txp_type);
 
 		return 0;
 	}
@@ -2127,6 +2135,7 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	switch (type) {
 	case NL80211_TX_POWER_AUTOMATIC:
 		local->user_power_level = IEEE80211_UNSET_POWER_LEVEL;
+		txp_type = NL80211_TX_POWER_LIMITED;
 		break;
 	case NL80211_TX_POWER_LIMITED:
 	case NL80211_TX_POWER_FIXED:
@@ -2137,10 +2146,14 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 	}
 
 	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list)
+	list_for_each_entry(sdata, &local->interfaces, list) {
 		sdata->user_power_level = local->user_power_level;
+		if (txp_type != sdata->vif.bss_conf.txpower_type)
+			update_txp_type = true;
+		sdata->vif.bss_conf.txpower_type = txp_type;
+	}
 	list_for_each_entry(sdata, &local->interfaces, list)
-		ieee80211_recalc_txpower(sdata);
+		ieee80211_recalc_txpower(sdata, update_txp_type);
 	mutex_unlock(&local->iflist_mtx);
 
 	return 0;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index da1c12c..17c49d8 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -628,7 +628,7 @@ out:
 	}
 
 	if (new_ctx && ieee80211_chanctx_num_assigned(local, new_ctx) > 0) {
-		ieee80211_recalc_txpower(sdata);
+		ieee80211_recalc_txpower(sdata, false);
 		ieee80211_recalc_chanctx_min_def(local, new_ctx);
 	}
 
@@ -1360,7 +1360,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 				ieee80211_bss_info_change_notify(sdata,
 								 changed);
 
-			ieee80211_recalc_txpower(sdata);
+			ieee80211_recalc_txpower(sdata, false);
 		}
 
 		ieee80211_recalc_chanctx_chantype(local, ctx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 4f45cab..486dbc5d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1623,7 +1623,8 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local);
 void ieee80211_del_virtual_monitor(struct ieee80211_local *local);
 
 bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
-void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata);
+void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata,
+			      bool update_bss);
 
 static inline bool ieee80211_sdata_running(struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4173553..bc885e2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -73,9 +73,10 @@ bool __ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
 	return false;
 }
 
-void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata)
+void ieee80211_recalc_txpower(struct ieee80211_sub_if_data *sdata,
+			      bool update_bss)
 {
-	if (__ieee80211_recalc_txpower(sdata))
+	if (__ieee80211_recalc_txpower(sdata) || update_bss)
 		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_TXPOWER);
 }
 
-- 
2.1.0

