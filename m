Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46600 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab2G0JdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 05:33:23 -0400
Received: by wgbdr13 with SMTP id dr13so2637895wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2012 02:33:22 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3] mac80211: add PS flag to bss_conf
Date: Fri, 27 Jul 2012 12:33:22 +0300
Message-Id: <1343381602-10079-1-git-send-email-eliad@wizery.com> (sfid-20120727_113327_549863_526C635C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, ps mode is indicated per device (rather than
per interface), which doesn't make a lot of sense.

Moreover, there are subtle bugs caused by the inability
to indicate ps change along with other changes
(e.g. when the AP deauth us, we'd like to indicate
CHANGED_PS | CHANGED_ASSOC, as changing PS before
notifying about disassociation will result in null-packets
being sent (if IEEE80211_HW_SUPPORTS_DYNAMIC_PS) while
the sta is already disconnected.)

Keep the current per-device notifications, and add
parallel per-vif notifications.

In order to keep it simple, the per-device ps and
the per-vif ps are orthogonal - the per-vif ps
configuration is determined only by the user
configuration (enable/disable) and the connection
state, and is not affected by other vifs state and
(temporary) dynamic_ps/offchannel operations
(unlike per-device ps).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: refactor and always check for actual ps change (thanks Johannes)
v3: remove redundant changes (thanks Johannes)

 include/net/mac80211.h     |    5 +++++
 net/mac80211/cfg.c         |    6 ++++--
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mlme.c        |   15 +++++++++++++++
 net/mac80211/util.c        |    3 ++-
 5 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 3a700fd..1fcb109 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -171,6 +171,7 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_IDLE: Idle changed for this BSS/interface.
  * @BSS_CHANGED_SSID: SSID changed for this BSS (AP mode)
  * @BSS_CHANGED_AP_PROBE_RESP: Probe Response changed for this BSS (AP mode)
+ * @BSS_CHANGED_PS: PS changed for this BSS (STA mode)
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -190,6 +191,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_IDLE		= 1<<14,
 	BSS_CHANGED_SSID		= 1<<15,
 	BSS_CHANGED_AP_PROBE_RESP	= 1<<16,
+	BSS_CHANGED_PS			= 1<<17,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -266,6 +268,8 @@ enum ieee80211_rssi_event {
  * @idle: This interface is idle. There's also a global idle flag in the
  *	hardware config which may be more appropriate depending on what
  *	your driver/device needs to do.
+ * @ps: power-save mode (STA only). This flag is NOT affected by
+ *	offchannel/dynamic_ps operations.
  * @ssid: The SSID of the current vif. Only valid in AP-mode.
  * @ssid_len: Length of SSID given in @ssid.
  * @hidden_ssid: The SSID of the current vif is hidden. Only valid in AP-mode.
@@ -296,6 +300,7 @@ struct ieee80211_bss_conf {
 	bool arp_filter_enabled;
 	bool qos;
 	bool idle;
+	bool ps;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	size_t ssid_len;
 	bool hidden_ssid;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e81b4a5..72c9681 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1283,9 +1283,10 @@ static int ieee80211_change_station(struct wiphy *wiphy,
 	mutex_unlock(&local->sta_mtx);
 
 	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))
+	    params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
 		ieee80211_recalc_ps(local, -1);
-
+		ieee80211_recalc_ps_vif(sdata);
+	}
 	return 0;
 }
 
@@ -2084,6 +2085,7 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
 
 	ieee80211_recalc_ps(local, -1);
+	ieee80211_recalc_ps_vif(sdata);
 
 	return 0;
 }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d08c547..856d153 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1207,6 +1207,7 @@ int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
 void ieee80211_send_pspoll(struct ieee80211_local *local,
 			   struct ieee80211_sub_if_data *sdata);
 void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency);
+void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata);
 int ieee80211_max_network_latency(struct notifier_block *nb,
 				  unsigned long data, void *dummy);
 int ieee80211_set_arp_filter(struct ieee80211_sub_if_data *sdata);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index bf3da5a..e9c3f86 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1007,6 +1007,16 @@ void ieee80211_recalc_ps(struct ieee80211_local *local, s32 latency)
 	ieee80211_change_ps(local);
 }
 
+void ieee80211_recalc_ps_vif(struct ieee80211_sub_if_data *sdata)
+{
+	bool ps_allowed = ieee80211_powersave_allowed(sdata);
+
+	if (sdata->vif.bss_conf.ps != ps_allowed) {
+		sdata->vif.bss_conf.ps = ps_allowed;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_PS);
+	}
+}
+
 void ieee80211_dynamic_ps_disable_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
@@ -1310,6 +1320,8 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	ieee80211_recalc_smps(local);
 	mutex_unlock(&local->iflist_mtx);
 
+	ieee80211_recalc_ps_vif(sdata);
+
 	netif_tx_start_all_queues(sdata->dev);
 	netif_carrier_on(sdata->dev);
 }
@@ -1371,6 +1383,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	}
 	local->ps_sdata = NULL;
 
+	/* disable per-vif ps */
+	ieee80211_recalc_ps_vif(sdata);
+
 	/* flush out any pending frame (e.g. DELBA) before deauth/disassoc */
 	if (tx)
 		drv_flush(local, false);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 39b82fe..037d148 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1359,7 +1359,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			changed |= BSS_CHANGED_ASSOC |
-				   BSS_CHANGED_ARP_FILTER;
+				   BSS_CHANGED_ARP_FILTER |
+				   BSS_CHANGED_PS;
 			mutex_lock(&sdata->u.mgd.mtx);
 			ieee80211_bss_info_change_notify(sdata, changed);
 			mutex_unlock(&sdata->u.mgd.mtx);
-- 
1.7.6.401.g6a319

