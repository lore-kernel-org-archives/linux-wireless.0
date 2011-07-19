Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab1GSIj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 04:39:58 -0400
Subject: [PATCH] mac80211: sync driver before TX
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 10:39:53 +0200
Message-ID: <1311064793.24078.0.camel@jlt3.sipsolutions.net> (sfid-20110719_104003_496137_7EA3301D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In P2P client mode, the GO (AP) to connect to might
have periods of time where it is not available due
to powersave. To allow the driver to sync with it
and send frames to the GO only when it is available
add a new callback tx_sync (and the corresponding
finish_tx_sync). These callbacks can sleep unlike
the actual TX.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   42 ++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h   |   31 +++++++++++++++++++++++++++++++
 net/mac80211/driver-trace.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    2 ++
 net/mac80211/mlme.c         |   24 +++++++++++++++++++++---
 net/mac80211/work.c         |   25 +++++++++++++++++++++++++
 6 files changed, 164 insertions(+), 3 deletions(-)

--- a/include/net/mac80211.h	2011-07-19 08:07:58.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-19 10:30:13.000000000 +0200
@@ -1585,6 +1585,20 @@ enum ieee80211_ampdu_mlme_action {
 };
 
 /**
+ * enum ieee80211_tx_sync_type - TX sync type
+ * @IEEE80211_TX_SYNC_AUTH: sync TX for authentication
+ *	(and possibly also before direct probe)
+ * @IEEE80211_TX_SYNC_ASSOC: sync TX for association
+ * @IEEE80211_TX_SYNC_ACTION: sync TX for action frame
+ *	(not implemented yet)
+ */
+enum ieee80211_tx_sync_type {
+	IEEE80211_TX_SYNC_AUTH,
+	IEEE80211_TX_SYNC_ASSOC,
+	IEEE80211_TX_SYNC_ACTION,
+};
+
+/**
  * struct ieee80211_ops - callbacks from mac80211 to the driver
  *
  * This structure contains various callbacks that the driver may
@@ -1673,6 +1687,26 @@ enum ieee80211_ampdu_mlme_action {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
+ * @tx_sync: Called before a frame is sent to an AP/GO. In the GO case, the
+ *	driver should sync with the GO's powersaving so the device doesn't
+ *	transmit the frame while the GO is asleep. In the regular AP case
+ *	it may be used by drivers for devices implementing other restrictions
+ *	on talking to APs, e.g. due to regulatory enforcement or just HW
+ *	restrictions.
+ *	This function is called for every authentication, association and
+ *	action frame separately since applications might attempt to auth
+ *	with multiple APs before chosing one to associate to. If it returns
+ *	an error, the corresponding authentication, association or frame
+ *	transmission is aborted and reported as having failed. It is always
+ *	called after tuning to the correct channel.
+ *	The callback might be called multiple times before @finish_tx_sync
+ *	(but @finish_tx_sync will be called once for each) but in practice
+ *	this is unlikely to happen. It can also refuse in that case if the
+ *	driver cannot handle that situation.
+ *	This callback can sleep.
+ * @finish_tx_sync: Called as a counterpart to @tx_sync, unless that returned
+ *	an error. This callback can sleep.
+ *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -1900,6 +1934,14 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
+
+	int (*tx_sync)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		       const u8 *bssid, enum ieee80211_tx_sync_type type);
+	void (*finish_tx_sync)(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
+			       const u8 *bssid,
+			       enum ieee80211_tx_sync_type type);
+
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
--- a/net/mac80211/ieee80211_i.h	2011-07-19 08:07:58.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-07-19 09:49:03.000000000 +0200
@@ -323,6 +323,7 @@ struct ieee80211_work {
 			u8 key[WLAN_KEY_LEN_WEP104];
 			u8 key_len, key_idx;
 			bool privacy;
+			bool synced;
 		} probe_auth;
 		struct {
 			struct cfg80211_bss *bss;
@@ -336,6 +337,7 @@ struct ieee80211_work {
 			u8 ssid_len;
 			u8 supp_rates_len;
 			bool wmm_used, use_11n, uapsd_used;
+			bool synced;
 		} assoc;
 		struct {
 			u32 duration;
--- a/net/mac80211/mlme.c	2011-07-19 08:07:58.000000000 +0200
+++ b/net/mac80211/mlme.c	2011-07-19 09:53:17.000000000 +0200
@@ -2335,14 +2335,16 @@ static enum work_done_result
 ieee80211_probe_auth_done(struct ieee80211_work *wk,
 			  struct sk_buff *skb)
 {
+	struct ieee80211_local *local = wk->sdata->local;
+
 	if (!skb) {
 		cfg80211_send_auth_timeout(wk->sdata->dev, wk->filter_ta);
-		return WORK_DONE_DESTROY;
+		goto destroy;
 	}
 
 	if (wk->type == IEEE80211_WORK_AUTH) {
 		cfg80211_send_rx_auth(wk->sdata->dev, skb->data, skb->len);
-		return WORK_DONE_DESTROY;
+		goto destroy;
 	}
 
 	mutex_lock(&wk->sdata->u.mgd.mtx);
@@ -2352,6 +2354,12 @@ ieee80211_probe_auth_done(struct ieee802
 	wk->type = IEEE80211_WORK_AUTH;
 	wk->probe_auth.tries = 0;
 	return WORK_DONE_REQUEUE;
+ destroy:
+	if (wk->probe_auth.synced)
+		drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
+				   IEEE80211_TX_SYNC_AUTH);
+
+	return WORK_DONE_DESTROY;
 }
 
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
@@ -2424,6 +2432,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 						  struct sk_buff *skb)
 {
+	struct ieee80211_local *local = wk->sdata->local;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee802_11_elems elems;
@@ -2431,7 +2440,7 @@ static enum work_done_result ieee80211_a
 
 	if (!skb) {
 		cfg80211_send_assoc_timeout(wk->sdata->dev, wk->filter_ta);
-		return WORK_DONE_DESTROY;
+		goto destroy;
 	}
 
 	if (wk->type == IEEE80211_WORK_ASSOC_BEACON_WAIT) {
@@ -2451,6 +2460,10 @@ static enum work_done_result ieee80211_a
 	status = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
 	if (status == WLAN_STATUS_SUCCESS) {
+		if (wk->assoc.synced)
+			drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
+					   IEEE80211_TX_SYNC_ASSOC);
+
 		mutex_lock(&wk->sdata->u.mgd.mtx);
 		if (!ieee80211_assoc_success(wk, mgmt, skb->len)) {
 			mutex_unlock(&wk->sdata->u.mgd.mtx);
@@ -2464,6 +2477,11 @@ static enum work_done_result ieee80211_a
 	}
 
 	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
+ destroy:
+	if (wk->assoc.synced)
+		drv_finish_tx_sync(local, wk->sdata, wk->filter_ta,
+				   IEEE80211_TX_SYNC_ASSOC);
+
 	return WORK_DONE_DESTROY;
 }
 
--- a/net/mac80211/work.c	2011-07-19 08:07:58.000000000 +0200
+++ b/net/mac80211/work.c	2011-07-19 09:52:38.000000000 +0200
@@ -25,6 +25,7 @@
 
 #include "ieee80211_i.h"
 #include "rate.h"
+#include "driver-ops.h"
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3
@@ -427,6 +428,14 @@ ieee80211_direct_probe(struct ieee80211_
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	if (!wk->probe_auth.synced) {
+		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
+				      IEEE80211_TX_SYNC_AUTH);
+		if (ret)
+			return WORK_ACT_TIMEOUT;
+	}
+	wk->probe_auth.synced = true;
+
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: direct probe to %pM timed out\n",
@@ -466,6 +475,14 @@ ieee80211_authenticate(struct ieee80211_
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	if (!wk->probe_auth.synced) {
+		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
+				      IEEE80211_TX_SYNC_AUTH);
+		if (ret)
+			return WORK_ACT_TIMEOUT;
+	}
+	wk->probe_auth.synced = true;
+
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: authentication with %pM"
@@ -499,6 +516,14 @@ ieee80211_associate(struct ieee80211_wor
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	if (!wk->assoc.synced) {
+		int ret = drv_tx_sync(local, sdata, wk->filter_ta,
+				      IEEE80211_TX_SYNC_ASSOC);
+		if (ret)
+			return WORK_ACT_TIMEOUT;
+	}
+	wk->assoc.synced = true;
+
 	wk->assoc.tries++;
 	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with %pM"
--- a/net/mac80211/driver-ops.h	2011-07-19 08:07:58.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2011-07-19 09:51:55.000000000 +0200
@@ -130,6 +130,37 @@ static inline void drv_bss_info_changed(
 	trace_drv_return_void(local);
 }
 
+static inline int drv_tx_sync(struct ieee80211_local *local,
+			      struct ieee80211_sub_if_data *sdata,
+			      const u8 *bssid,
+			      enum ieee80211_tx_sync_type type)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	trace_drv_tx_sync(local, sdata, bssid, type);
+	if (local->ops->tx_sync)
+		ret = local->ops->tx_sync(&local->hw, &sdata->vif,
+					  bssid, type);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline void drv_finish_tx_sync(struct ieee80211_local *local,
+				      struct ieee80211_sub_if_data *sdata,
+				      const u8 *bssid,
+				      enum ieee80211_tx_sync_type type)
+{
+	might_sleep();
+
+	trace_drv_finish_tx_sync(local, sdata, bssid, type);
+	if (local->ops->finish_tx_sync)
+		local->ops->finish_tx_sync(&local->hw, &sdata->vif,
+					   bssid, type);
+	trace_drv_return_void(local);
+}
+
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
--- a/net/mac80211/driver-trace.h	2011-07-19 08:07:58.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-07-19 09:48:27.000000000 +0200
@@ -319,6 +319,49 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
+DECLARE_EVENT_CLASS(tx_sync_evt,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid,
+		 enum ieee80211_tx_sync_type type),
+	TP_ARGS(local, sdata, bssid, type),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(char, bssid, ETH_ALEN)
+		__field(u32, sync_type)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->bssid, bssid, ETH_ALEN);
+		__entry->sync_type = type;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " bssid:%pM type:%d",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->bssid, __entry->sync_type
+	)
+);
+
+DEFINE_EVENT(tx_sync_evt, drv_tx_sync,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid,
+		 enum ieee80211_tx_sync_type type),
+	TP_ARGS(local, sdata, bssid, type)
+);
+
+DEFINE_EVENT(tx_sync_evt, drv_finish_tx_sync,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid,
+		 enum ieee80211_tx_sync_type type),
+	TP_ARGS(local, sdata, bssid, type)
+);
+
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count),
 


