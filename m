Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965039Ab0GPLeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jul 2010 07:34:24 -0400
Subject: [RFC] mac80211: move QoS-enable to BSS info
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Jul 2010 13:34:20 +0200
Message-ID: <1279280060.3938.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since

commit e1b3ec1a2a336c328c336cfa5485a5f0484cc90d
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Mon Mar 29 12:18:34 2010 +0200

    mac80211: explicitly disable/enable QoS

mac80211 is telling drivers, in particular
iwlwifi, whether QoS is enabled or not.

However, this is only relevant for station mode,
since only then will any device send nullfunc
frames and need to know whether they should be
QoS frames or not. In other modes, there are
(currently) no frames the device is supposed to
send.

When you now consider virtual interfaces, it
becomes apparent that the current mechanism is
inadequate since it enables/disables QoS on a
global scale, where for nullfunc frames it has
to be on a per-interface scale.

Due to the above considerations, we can change
the way mac80211 advertises the QoS state to
drivers to only ever advertise it as "off" in
station mode, and make it a per-BSS setting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Stanislaw, can you please test this? I have no legacy APs that really
don't understand QoS frames. I suppose I could use a sniffer but maybe
it's easier for you to just test with the AP you have?

 drivers/net/wireless/iwlwifi/iwl-core.c |   18 +++++++++---------
 include/net/mac80211.h                  |   11 +++++------
 net/mac80211/cfg.c                      |    4 ----
 net/mac80211/mlme.c                     |   11 ++++++-----
 net/mac80211/util.c                     |    7 ++++---
 5 files changed, 24 insertions(+), 27 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2010-07-16 11:44:49.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-07-16 13:22:38.000000000 +0200
@@ -147,6 +147,8 @@ struct ieee80211_low_level_stats {
  * @BSS_CHANGED_CQM: Connection quality monitor config changed
  * @BSS_CHANGED_IBSS: IBSS join status changed
  * @BSS_CHANGED_ARP_FILTER: Hardware ARP filter address list or state changed.
+ * @BSS_CHANGED_QOS: QoS for this association was enabled/disabled. Note
+ *	that it is only ever disabled for station mode.
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -162,6 +164,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_CQM			= 1<<10,
 	BSS_CHANGED_IBSS		= 1<<11,
 	BSS_CHANGED_ARP_FILTER		= 1<<12,
+	BSS_CHANGED_QOS			= 1<<13,
 
 	/* when adding here, make sure to change ieee80211_reconfig */
 };
@@ -217,6 +220,7 @@ enum ieee80211_bss_change {
  *	filter ARP queries based on the @arp_addr_list, if disabled, the
  *	hardware must not perform any ARP filtering. Note, that the filter will
  *	be enabled also in promiscuous mode.
+ * @qos: This is a QoS-enabled BSS.
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -240,6 +244,7 @@ struct ieee80211_bss_conf {
 	__be32 arp_addr_list[IEEE80211_BSS_ARP_ADDR_LIST_LEN];
 	u8 arp_addr_cnt;
 	bool arp_filter_enabled;
+	bool qos;
 };
 
 /**
@@ -620,15 +625,11 @@ struct ieee80211_rx_status {
  *	may turn the device off as much as possible. Typically, this flag will
  *	be set when an interface is set UP but not associated or scanning, but
  *	it can also be unset in that case when monitor interfaces are active.
- * @IEEE80211_CONF_QOS: Enable 802.11e QoS also know as WMM (Wireless
- *      Multimedia). On some drivers (iwlwifi is one of know) we have
- *      to enable/disable QoS explicitly.
  */
 enum ieee80211_conf_flags {
 	IEEE80211_CONF_MONITOR		= (1<<0),
 	IEEE80211_CONF_PS		= (1<<1),
 	IEEE80211_CONF_IDLE		= (1<<2),
-	IEEE80211_CONF_QOS		= (1<<3),
 };
 
 
@@ -643,7 +644,6 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
- * @IEEE80211_CONF_CHANGE_QOS: Quality of service was enabled or disabled
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
@@ -654,7 +654,6 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
-	IEEE80211_CONF_CHANGE_QOS		= BIT(9),
 };
 
 /**
--- wireless-testing.orig/net/mac80211/cfg.c	2010-07-16 13:16:46.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2010-07-16 13:17:23.000000000 +0200
@@ -1154,10 +1154,6 @@ static int ieee80211_set_txq_params(stru
 		return -EINVAL;
 	}
 
-	/* enable WMM or activate new settings */
-	local->hw.conf.flags |= IEEE80211_CONF_QOS;
-	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
-
 	return 0;
 }
 
--- wireless-testing.orig/net/mac80211/mlme.c	2010-07-16 13:16:46.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-07-16 13:23:52.000000000 +0200
@@ -698,10 +698,11 @@ void ieee80211_dynamic_ps_timer(unsigned
 
 /* MLME */
 static void ieee80211_sta_wmm_params(struct ieee80211_local *local,
-				     struct ieee80211_if_managed *ifmgd,
+				     struct ieee80211_sub_if_data *sdata,
 				     u8 *wmm_param, size_t wmm_param_len)
 {
 	struct ieee80211_tx_queue_params params;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	size_t left;
 	int count;
 	u8 *pos, uapsd_queues = 0;
@@ -790,8 +791,8 @@ static void ieee80211_sta_wmm_params(str
 	}
 
 	/* enable WMM or activate new settings */
-	local->hw.conf.flags |=	IEEE80211_CONF_QOS;
-	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
+	sdata->vif.bss_conf.qos = true;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
 }
 
 static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
@@ -1325,7 +1326,7 @@ static bool ieee80211_assoc_success(stru
 	}
 
 	if (elems.wmm_param)
-		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
+		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
 	else
 		ieee80211_set_wmm_default(sdata);
@@ -1597,7 +1598,7 @@ static void ieee80211_rx_mgmt_beacon(str
 		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
 				      true);
 
-		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
+		ieee80211_sta_wmm_params(local, sdata, elems.wmm_param,
 					 elems.wmm_param_len);
 	}
 
--- wireless-testing.orig/net/mac80211/util.c	2010-07-16 13:16:46.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2010-07-16 13:24:30.000000000 +0200
@@ -803,8 +803,8 @@ void ieee80211_set_wmm_default(struct ie
 
 	/* after reinitialize QoS TX queues setting to default,
 	 * disable QoS at all */
-	local->hw.conf.flags &=	~IEEE80211_CONF_QOS;
-	drv_config(local, IEEE80211_CONF_CHANGE_QOS);
+	sdata->vif.bss_conf.qos = sdata->vif.type != NL80211_IFTYPE_STATION;
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
@@ -1161,7 +1161,8 @@ int ieee80211_reconfig(struct ieee80211_
 			  BSS_CHANGED_BASIC_RATES |
 			  BSS_CHANGED_BEACON_INT |
 			  BSS_CHANGED_BSSID |
-			  BSS_CHANGED_CQM;
+			  BSS_CHANGED_CQM |
+			  BSS_CHANGED_QOS;
 
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2010-07-16 13:25:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2010-07-16 13:27:49.000000000 +0200
@@ -1763,6 +1763,15 @@ void iwl_bss_info_changed(struct ieee802
 
 	mutex_lock(&priv->mutex);
 
+	if (changes & BSS_CHANGED_QOS) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&priv->lock, flags);
+		priv->qos_data.qos_active = bss_conf->qos;
+		iwl_update_qos(priv);
+		spin_unlock_irqrestore(&priv->lock, flags);
+	}
+
 	if (changes & BSS_CHANGED_BEACON && vif->type == NL80211_IFTYPE_AP) {
 		dev_kfree_skb(priv->ibss_beacon);
 		priv->ibss_beacon = ieee80211_beacon_get(hw, vif);
@@ -2138,15 +2147,6 @@ int iwl_mac_config(struct ieee80211_hw *
 		iwl_set_tx_power(priv, conf->power_level, false);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_QOS) {
-		bool qos_active = !!(conf->flags & IEEE80211_CONF_QOS);
-
-		spin_lock_irqsave(&priv->lock, flags);
-		priv->qos_data.qos_active = qos_active;
-		iwl_update_qos(priv);
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
-
 	if (!iwl_is_ready(priv)) {
 		IWL_DEBUG_MAC80211(priv, "leave - not ready\n");
 		goto out;


