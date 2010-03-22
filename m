Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:19110 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0CVKSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 06:18:51 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o2MAIkvc011861
	for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 12:18:48 +0200
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com
Subject: [RFC PATCHv6 2/2] mac80211: Add support for connection quality monitoring
Date: Mon, 22 Mar 2010 12:15:43 +0200
Message-Id: <1269252943-2450-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1269252943-2450-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the set_cqm_config op. This op function configures the
requested connection quality monitor rssi threshold and rssi hysteresis
values to the hardware  if the hardware supports
IEEE80211_HW_SUPPORTS_CQM.

For unsupporting hardware, currently -EOPNOTSUPP is returned, so the mac80211
is currently not doing connection quality monitoring on the host. This could be
added later, if needed.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 include/net/mac80211.h |   29 +++++++++++++++++++++++++++++
 net/mac80211/cfg.c     |   27 +++++++++++++++++++++++++++
 net/mac80211/mlme.c    |   15 +++++++++++++++
 3 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 936bc41..40e23f3 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -144,6 +144,7 @@ struct ieee80211_low_level_stats {
  *	new beacon (beaconing modes)
  * @BSS_CHANGED_BEACON_ENABLED: Beaconing should be
  *	enabled/disabled (beaconing modes)
+ * @BSS_CHANGED_CQM: Connection quality monitor config changed
  */
 enum ieee80211_bss_change {
 	BSS_CHANGED_ASSOC		= 1<<0,
@@ -156,6 +157,7 @@ enum ieee80211_bss_change {
 	BSS_CHANGED_BSSID		= 1<<7,
 	BSS_CHANGED_BEACON		= 1<<8,
 	BSS_CHANGED_BEACON_ENABLED	= 1<<9,
+	BSS_CHANGED_CQM			= 1<<10,
 };
 
 /**
@@ -185,6 +187,9 @@ enum ieee80211_bss_change {
  * @enable_beacon: whether beaconing should be enabled or not
  * @ht_operation_mode: HT operation mode (like in &struct ieee80211_ht_info).
  *	This field is only valid when the channel type is one of the HT types.
+ * @cqm_rssi_thold: Connection quality monitor RSSI threshold, a zero value
+ *	implies disabled
+ * @cqm_rssi_hyst: Connection quality monitor RSSI hysteresis
  */
 struct ieee80211_bss_conf {
 	const u8 *bssid;
@@ -202,6 +207,8 @@ struct ieee80211_bss_conf {
 	u64 timestamp;
 	u32 basic_rates;
 	u16 ht_operation_mode;
+	s32 cqm_rssi_thold;
+	u32 cqm_rssi_hyst;
 };
 
 /**
@@ -954,6 +961,11 @@ enum ieee80211_tkip_key_type {
  *	Hardware can provide ack status reports of Tx frames to
  *	the stack.
  *
+ * @IEEE80211_HW_SUPPORTS_CQM_RSSI:
+ *	Hardware can do connection quality monitoring - i.e. it can monitor
+ *	connection quality related parameters, such as the RSSI level and
+ *	provide notifications if configured trigger levels are reached.
+ *
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -975,6 +987,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
 	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
+	IEEE80211_HW_SUPPORTS_CQM_RSSI			= 1<<19,
 };
 
 /**
@@ -2370,6 +2383,22 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
  */
 void ieee80211_beacon_loss(struct ieee80211_vif *vif);
 
+/**
+ * ieee80211_cqm_rssi_notify - inform a configured connection quality monitoring
+ *	rssi threshold triggered
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @rssi_event: the RSSI trigger event type
+ * @gfp: context flags
+ *
+ * When the %IEEE80211_HW_SUPPORTS_CQM_RSSI is set, and a connection quality
+ * monitoring is configured with an rssi threshold, the driver will inform
+ * whenever the rssi level reaches the threshold.
+ */
+void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
+			       enum nl80211_cqm_rssi_threshold_event rssi_event,
+			       gfp_t gfp);
+
 /* Rate control API */
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index b7116ef..c8f5205 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1402,6 +1402,32 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	return 0;
 }
 
+static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
+					 struct net_device *dev,
+					 s32 rssi_thold, u32 rssi_hyst)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_vif *vif = &sdata->vif;
+	struct ieee80211_bss_conf *bss_conf = &vif->bss_conf;
+
+	if (!(local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI))
+		return -EOPNOTSUPP;
+
+	if (rssi_thold == bss_conf->cqm_rssi_thold &&
+	    rssi_hyst == bss_conf->cqm_rssi_hyst)
+		return 0;
+
+	bss_conf->cqm_rssi_thold = rssi_thold;
+	bss_conf->cqm_rssi_hyst = rssi_hyst;
+
+	/* tell the driver upon association, unless already associated */
+	if (sdata->u.mgd.associated)
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_CQM);
+
+	return 0;
+}
+
 static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 				      struct net_device *dev,
 				      const u8 *addr,
@@ -1506,4 +1532,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.remain_on_channel = ieee80211_remain_on_channel,
 	.cancel_remain_on_channel = ieee80211_cancel_remain_on_channel,
 	.action = ieee80211_action,
+	.set_cqm_rssi_config = ieee80211_set_cqm_rssi_config,
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index be5f723..5927077 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -753,6 +753,11 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 	/* And the BSSID changed - we're associated now */
 	bss_info_changed |= BSS_CHANGED_BSSID;
 
+	/* Tell the driver to monitor connection quality (if supported) */
+	if ((local->hw.flags & IEEE80211_HW_SUPPORTS_CQM_RSSI) &&
+	    sdata->vif.bss_conf.cqm_rssi_thold)
+		bss_info_changed |= BSS_CHANGED_CQM;
+
 	ieee80211_bss_info_change_notify(sdata, bss_info_changed);
 
 	mutex_lock(&local->iflist_mtx);
@@ -2135,3 +2140,13 @@ int ieee80211_mgd_action(struct ieee80211_sub_if_data *sdata,
 	*cookie = (unsigned long) skb;
 	return 0;
 }
+
+void ieee80211_cqm_rssi_notify(struct ieee80211_vif *vif,
+			       enum nl80211_cqm_rssi_threshold_event rssi_event,
+			       gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_cqm_rssi_notify(sdata->dev, rssi_event, gfp);
+}
+EXPORT_SYMBOL(ieee80211_cqm_rssi_notify);
-- 
1.6.3.3

