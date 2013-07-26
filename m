Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58006 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3GZIIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:08:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: implement critical protocol protection
Date: Fri, 26 Jul 2013 10:08:10 +0200
Message-Id: <1374826090-17322-1-git-send-email-johannes@sipsolutions.net> (sfid-20130726_100826_932225_4D950664)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This new API add in cfg80211 wasn't implemented in mac80211.
Advertise the capabilities based on the device's
implementation (possibly NULL) of crit_prot mac80211 ops.

This callback will be called by cfg80211 when hinted by
userspace that a critical protocol is happening, e.g. it can
be EAPOL, DHCP.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h     |  2 ++
 include/net/mac80211.h     |  7 +++++++
 net/mac80211/cfg.c         | 29 +++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h  | 18 ++++++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       | 14 ++++++++++++++
 net/mac80211/main.c        |  3 +++
 net/mac80211/trace.h       | 26 ++++++++++++++++++++++++++
 net/wireless/nl80211.c     |  6 ++++--
 9 files changed, 104 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 019e256..5dc5e75 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2452,6 +2452,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_BEACON_MEAS: Device supports beacon measurements. Should
  *	be set when the device can let all the beacon through up to cfg80211
  *	to proceed to measurements (i.e. RSSI measurements).
+ * @WIPHY_FLAG_SUPPORTS_CRIT_PROT: Device supports critical protocol protection.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -2477,6 +2478,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL	= BIT(21),
 	WIPHY_FLAG_SUPPORTS_5_10_MHZ		= BIT(22),
 	WIPHY_FLAG_SUPPORTS_BEACON_MEAS		= BIT(23),
+	WIPHY_FLAG_SUPPORTS_CRIT_PROT		= BIT(24),
 };
 
 /**
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index fb8f6c6..70d8ea4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2638,6 +2638,10 @@ enum ieee80211_roc_type {
  *	beacons must be let through and data for measurement should be set in
  *	&ieee80211_rx_status (rssi etc...).
  *
+ * @crit_proto: Start or stop a critical protocol session. This can be DHCP, EAP
+ *	or any other protocol that gates the connection. Look at
+ *	%crit_prot_start in %cfg80211_ops.
+ *
  * @ipv6_addr_change: IPv6 address assignment on the given interface changed.
  *	Currently, this is only called for managed or P2P client interfaces.
  *	This callback is optional; it must not sleep.
@@ -2826,6 +2830,9 @@ struct ieee80211_ops {
 	int (*beacon_measurement)(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif, bool state);
 
+	int (*crit_proto)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			  enum nl80211_crit_proto_id protocol, bool start);
+
 #if IS_ENABLED(CONFIG_IPV6)
 	void (*ipv6_addr_change)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 34b57a9..3070d5e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3407,6 +3407,33 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 	return ret;
 }
 
+static int ieee80211_crit_proto_start(struct wiphy *wiphy,
+				      struct wireless_dev *wdev,
+				      enum nl80211_crit_proto_id protocol,
+				      u16 duration)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	int ret;
+
+	ret = drv_crit_proto(local, sdata, protocol, true);
+	if (!ret)
+		return ret;
+
+	ieee80211_queue_delayed_work(&sdata->local->hw,
+				     &sdata->crit_prot_end_wk,
+				     msecs_to_jiffies(duration));
+	return 0;
+}
+
+static void ieee80211_crit_proto_stop(struct wiphy *wiphy,
+				      struct wireless_dev *wdev)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	flush_delayed_work(&sdata->crit_prot_end_wk);
+}
+
 static int ieee80211_beacon_measurement(struct wiphy *wiphy,
 					struct wireless_dev *wdev,
 					bool state)
@@ -3505,5 +3532,7 @@ struct cfg80211_ops mac80211_config_ops = {
 	.get_et_strings = ieee80211_get_et_strings,
 	.get_channel = ieee80211_cfg_get_channel,
 	.start_radar_detection = ieee80211_start_radar_detection,
+	.crit_proto_start = ieee80211_crit_proto_start,
+	.crit_proto_stop = ieee80211_crit_proto_stop,
 	.beacon_measurement = ieee80211_beacon_measurement,
 };
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 7fbe57f..30a773b 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1060,6 +1060,24 @@ drv_set_default_unicast_key(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_crit_proto(struct ieee80211_local *local,
+				 struct ieee80211_sub_if_data *sdata,
+				 enum nl80211_crit_proto_id protocol,
+				 bool start)
+{
+	int ret = -EOPNOTSUPP;
+	check_sdata_in_driver(sdata);
+
+	trace_drv_crit_proto(local, sdata, protocol, start);
+
+	if (local->ops->crit_proto)
+		ret = local->ops->crit_proto(&local->hw, &sdata->vif, protocol,
+					     start);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 static inline int
 drv_beacon_measurement(struct ieee80211_local *local,
 		       struct ieee80211_sub_if_data *sdata, bool state)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 3d32df1..b04c62f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -683,6 +683,7 @@ struct ieee80211_sub_if_data {
 	int crypto_tx_tailroom_needed_cnt;
 	int crypto_tx_tailroom_pending_dec;
 	struct delayed_work dec_tailroom_needed_wk;
+	struct delayed_work crit_prot_end_wk;
 
 	struct net_device *dev;
 	struct ieee80211_local *local;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 4c41c11..700c937 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -806,6 +806,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	cancel_work_sync(&sdata->recalc_smps);
 
 	cancel_delayed_work_sync(&sdata->dfs_cac_timer_work);
+	/* this will end the critical protocol right away */
+	flush_delayed_work(&sdata->crit_prot_end_wk);
 
 	if (sdata->wdev.cac_started) {
 		WARN_ON(local->suspended);
@@ -1568,6 +1570,16 @@ static void ieee80211_cleanup_sdata_stas_wk(struct work_struct *wk)
 	ieee80211_cleanup_sdata_stas(sdata);
 }
 
+static void ieee80211_crit_prot_timeout(struct work_struct *wk)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	sdata = container_of(wk, struct ieee80211_sub_if_data,
+			     crit_prot_end_wk.work);
+
+	drv_crit_proto(sdata->local, sdata, NL80211_CRIT_PROTO_UNSPEC, false);
+}
+
 int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 		     struct wireless_dev **new_wdev, enum nl80211_iftype type,
 		     struct vif_params *params)
@@ -1647,6 +1659,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			  ieee80211_dfs_cac_timer_work);
 	INIT_DELAYED_WORK(&sdata->dec_tailroom_needed_wk,
 			  ieee80211_delayed_tailroom_dec);
+	INIT_DELAYED_WORK(&sdata->crit_prot_end_wk,
+			  ieee80211_crit_prot_timeout);
 
 	for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
 		struct ieee80211_supported_band *sband;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 25eb35b..c3084e4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -895,6 +895,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->ops->sched_scan_start)
 		local->hw.wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 
+	if (local->ops->crit_proto)
+		local->hw.wiphy->flags |= WIPHY_FLAG_SUPPORTS_CRIT_PROT;
+
 	/* mac80211 based drivers don't support internal TDLS setup */
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index d41bbe2..1e8eaaa 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1887,6 +1887,32 @@ TRACE_EVENT(drv_set_default_unicast_key,
 		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->key_idx)
 );
 
+TRACE_EVENT(drv_crit_proto,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 enum nl80211_crit_proto_id protocol,
+		 bool start),
+
+	TP_ARGS(local, sdata, protocol, start),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__field(unsigned int, protocol)
+		__field(bool, start)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		__entry->protocol = protocol;
+		__entry->start = start;
+	),
+
+	TP_printk(LOCAL_PR_FMT VIF_PR_FMT " protocol:%d start:%d",
+		  LOCAL_PR_ARG, VIF_PR_ARG, __entry->protocol, __entry->start)
+);
+
 TRACE_EVENT(drv_beacon_measurement,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c2b43b6..e39c43d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1421,8 +1421,10 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *dev,
 		CMD(start_p2p_device, START_P2P_DEVICE);
 		CMD(set_mcast_rate, SET_MCAST_RATE);
 		if (state->split) {
-			CMD(crit_proto_start, CRIT_PROTOCOL_START);
-			CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+			if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_CRIT_PROT) {
+				CMD(crit_proto_start, CRIT_PROTOCOL_START);
+				CMD(crit_proto_stop, CRIT_PROTOCOL_STOP);
+			}
 		}
 
 #ifdef CONFIG_NL80211_TESTMODE
-- 
1.8.0

