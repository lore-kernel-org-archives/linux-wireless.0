Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:54947 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597Ab0CLLho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 06:37:44 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2CBbSAW002045
	for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 13:37:42 +0200
Received: from localhost.localdomain (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.ext.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2CBb6aD028203
	for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 13:37:08 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 2/2] mac80211: Add support for roam trigger configuration
Date: Fri, 12 Mar 2010 13:34:31 +0200
Message-Id: <1268393671-5498-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1268393671-5498-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268393671-5498-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the set_roam_trigger op. This op function configures the
requested rssi roam trigger state, and associated threshold and hysteresis
values to the hardware, if the hardware supports
IEEE80211_HW_SUPPORTS_ROAM_TRIGGER.

For unsupporting hardware, currently -EOPNOTSUPP is returned, so the mac80211
is currently not doing roam trigger monitoring on the host. This could be added
later, if needed.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |   28 ++++++++++++++++++++++++++++
 net/mac80211/cfg.c     |   29 +++++++++++++++++++++++++++++
 net/mac80211/mlme.c    |    9 +++++++++
 3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 936bc41..f2be0c8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -599,6 +599,7 @@ enum ieee80211_conf_flags {
  * @IEEE80211_CONF_CHANGE_RETRY_LIMITS: retry limits changed
  * @IEEE80211_CONF_CHANGE_IDLE: Idle flag changed
  * @IEEE80211_CONF_CHANGE_SMPS: Spatial multiplexing powersave mode changed
+ * @IEEE80211_CONF_CHANGE_ROAM_TRIGGER: roaming trigger config changed
  */
 enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_SMPS		= BIT(1),
@@ -609,6 +610,7 @@ enum ieee80211_conf_changed {
 	IEEE80211_CONF_CHANGE_CHANNEL		= BIT(6),
 	IEEE80211_CONF_CHANGE_RETRY_LIMITS	= BIT(7),
 	IEEE80211_CONF_CHANGE_IDLE		= BIT(8),
+	IEEE80211_CONF_CHANGE_ROAM_TRIGGER      = BIT(9),
 };
 
 /**
@@ -662,6 +664,10 @@ enum ieee80211_smps_mode {
  *    frame, called "dot11ShortRetryLimit" in 802.11, but actually means the
  *    number of transmissions not the number of retries
  *
+ * @rtrig_rssi: Current state of the RSSI level based roam trigger
+ * @rtrig_rssi_thold: Roam trigger RSSI threshold
+ * @rtrig_rssi_hyst: Roam trigger RSSI hysteresis
+ *
  * @smps_mode: spatial multiplexing powersave mode; note that
  *	%IEEE80211_SMPS_STATIC is used when the device is not
  *	configured for an HT channel
@@ -676,6 +682,10 @@ struct ieee80211_conf {
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
+	bool rtrig_rssi;
+	s8 rtrig_rssi_thold;
+	u8 rtrig_rssi_hyst;
+
 	struct ieee80211_channel *channel;
 	enum nl80211_channel_type channel_type;
 	enum ieee80211_smps_mode smps_mode;
@@ -954,6 +964,10 @@ enum ieee80211_tkip_key_type {
  *	Hardware can provide ack status reports of Tx frames to
  *	the stack.
  *
+ * @IEEE80211_HW_SUPPORTS_ROAM_TRIGGER:
+ *	Hardware can provide roaming indications based on configured
+ *	RSSI threshold and hysteresis values.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -975,6 +989,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
+	IEEE80211_HW_SUPPORTS_ROAM_TRIGGER              = 1<<19,
 };
 
 /**
@@ -2370,6 +2385,19 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  */
 void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 
+/**
+ * ieee80211_roam_trigger - inform roaming RSSI threshold triggered
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @level: the current level of the RSSI value
+ *
+ * When the HW supports IEEE80211_HW_SUPPORTS_ROAM_TRIGGER is set, and
+ * a roaming RSSI threshold has been configured and enabled, the driver will
+ * inform whenever RSSI goes above or below the threshold with this function.
+ */
+void ieee80211_roam_trigger(struct ieee80211_vif *vif,
+			    enum ieee80211_roam_trigger_level level);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b7116ef..079fcf6 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1402,6 +1402,34 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_set_roam_trigger(struct wiphy *wiphy,
+				      struct net_device *dev,
+				      bool rssi_enabled, s8 rssi_thold,
+				      u8 rssi_hyst)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_conf *conf = &local->hw.conf;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION)
+		return -EOPNOTSUPP;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_ROAM_TRIGGER))
+		return -EOPNOTSUPP;
+
+	if (rssi_enabled == conf->rtrig_rssi &&
+	    rssi_thold == conf->rtrig_rssi_thold &&
+	    rssi_hyst == conf->rtrig_rssi_hyst)
+		return 0;
+
+	conf->rtrig_rssi = rssi_enabled;
+	conf->rtrig_rssi_thold = rssi_thold;
+	conf->rtrig_rssi_hyst = rssi_hyst;
+
+	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_ROAM_TRIGGER);
+	return 0;
+}
+
 static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      const u8 *addr,
@@ -1506,4 +1534,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.action = ieee80211_action,
+	.set_roam_trigger = ieee80211_set_roam_trigger,
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..7a72913 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2135,3 +2135,12 @@ int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
 	*cookie = (unsigned long) skb;
 	return 0;
 }
+
+void ieee80211_roam_trigger(struct ieee80211_vif *vif,
+			    enum ieee80211_roam_trigger_level level)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_roam_trigger(sdata->dev, level, GFP_KERNEL);
+}
+EXPORT_SYMBOL(ieee80211_roam_trigger);
-- 
1.6.3.3

