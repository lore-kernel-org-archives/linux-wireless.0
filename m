Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35592 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584Ab1EMNOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 09:14:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.75)
	(envelope-from <johannes@sipsolutions.net>)
	id 1QKsCC-0001Bj-CR
	for linux-wireless@vger.kernel.org; Fri, 13 May 2011 15:14:20 +0200
Subject: [RFC] mac80211: notify driver about auth/assoc
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:14:20 +0200
Message-ID: <1305292460.3487.36.camel@jlt3.sipsolutions.net> (sfid-20110513_151435_631931_4E03E74D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In P2P client mode, the GO (AP) to connect to might
have periods of time where it is not available due
to powersave. To allow the driver to sync with them
and send frames to the GO only when it is available
add a new callback prepare_auth_assoc (and also the
corresponding finish_auth_assoc). They are invoked
for each authentication/association as described in
the documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   21 +++++++++++++++++++++
 net/mac80211/driver-ops.h   |   31 +++++++++++++++++++++++++++++++
 net/mac80211/driver-trace.h |   38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    2 ++
 net/mac80211/mlme.c         |   21 ++++++++++++++++++---
 net/mac80211/work.c         |   22 ++++++++++++++++++++++
 6 files changed, 132 insertions(+), 3 deletions(-)

--- a/include/net/mac80211.h	2011-05-13 14:58:43.000000000 +0200
+++ b/include/net/mac80211.h	2011-05-13 15:11:55.000000000 +0200
@@ -1671,6 +1671,19 @@ enum ieee80211_ampdu_mlme_action {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
+ * @prepare_auth_assoc: Called before an authentication or association is
+ *	attempted. The function allows the driver to implement for example
+ *	support for sending frames to a P2P GO only during its availability
+ *	periods only. It is called for every authentication and association
+ *	separately, since applications might attempt to authenticate with
+ *	multiple APs before chosing one to associate to. If it returns an
+ *	error, the authentication process is reported as failed.
+ *	This callback can sleep.
+ * @finish_auth_assoc: Called after an authentication or association was
+ *	completed (whether successfully or not), as a counterpart to the
+ *	@prepare_auth_assoc function.
+ *	This callback can sleep.
+ *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -1881,6 +1894,14 @@ struct ieee80211_ops {
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
+
+	int (*prepare_auth_assoc)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  const u8 *bssid);
+	void (*finish_auth_assoc)(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
+				  const u8 *bssid);
+
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
--- a/net/mac80211/ieee80211_i.h	2011-05-13 14:58:43.000000000 +0200
+++ b/net/mac80211/ieee80211_i.h	2011-05-13 14:58:44.000000000 +0200
@@ -308,6 +308,7 @@ struct ieee80211_work {
 			u8 key[WLAN_KEY_LEN_WEP104];
 			u8 key_len, key_idx;
 			bool privacy;
+			bool prepared;
 		} probe_auth;
 		struct {
 			struct cfg80211_bss *bss;
@@ -321,6 +322,7 @@ struct ieee80211_work {
 			u8 ssid_len;
 			u8 supp_rates_len;
 			bool wmm_used, use_11n, uapsd_used;
+			bool prepared;
 		} assoc;
 		struct {
 			u32 duration;
--- a/net/mac80211/mlme.c	2011-05-13 14:58:43.000000000 +0200
+++ b/net/mac80211/mlme.c	2011-05-13 15:06:06.000000000 +0200
@@ -2270,14 +2270,16 @@ static enum work_done_result
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
@@ -2287,6 +2289,11 @@ ieee80211_probe_auth_done(struct ieee802
 	wk->type = IEEE80211_WORK_AUTH;
 	wk->probe_auth.tries = 0;
 	return WORK_DONE_REQUEUE;
+ destroy:
+	if (wk->probe_auth.prepared)
+		drv_finish_auth_assoc(local, wk->sdata, wk->filter_ta);
+
+	return WORK_DONE_DESTROY;
 }
 
 int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
@@ -2359,6 +2366,7 @@ int ieee80211_mgd_auth(struct ieee80211_
 static enum work_done_result ieee80211_assoc_done(struct ieee80211_work *wk,
 						  struct sk_buff *skb)
 {
+	struct ieee80211_local *local = wk->sdata->local;
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_rx_status *rx_status;
 	struct ieee802_11_elems elems;
@@ -2366,7 +2374,7 @@ static enum work_done_result ieee80211_a
 
 	if (!skb) {
 		cfg80211_send_assoc_timeout(wk->sdata->dev, wk->filter_ta);
-		return WORK_DONE_DESTROY;
+		goto destroy;
 	}
 
 	if (wk->type == IEEE80211_WORK_ASSOC_BEACON_WAIT) {
@@ -2386,6 +2394,9 @@ static enum work_done_result ieee80211_a
 	status = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
 	if (status == WLAN_STATUS_SUCCESS) {
+		if (wk->assoc.prepared)
+			drv_finish_auth_assoc(local, wk->sdata, wk->filter_ta);
+
 		mutex_lock(&wk->sdata->u.mgd.mtx);
 		if (!ieee80211_assoc_success(wk, mgmt, skb->len)) {
 			mutex_unlock(&wk->sdata->u.mgd.mtx);
@@ -2399,6 +2410,10 @@ static enum work_done_result ieee80211_a
 	}
 
 	cfg80211_send_rx_assoc(wk->sdata->dev, skb->data, skb->len);
+ destroy:
+	if (wk->assoc.prepared)
+		drv_finish_auth_assoc(local, wk->sdata, wk->filter_ta);
+
 	return WORK_DONE_DESTROY;
 }
 
--- a/net/mac80211/work.c	2011-05-13 14:58:43.000000000 +0200
+++ b/net/mac80211/work.c	2011-05-13 15:07:23.000000000 +0200
@@ -25,6 +25,7 @@
 
 #include "ieee80211_i.h"
 #include "rate.h"
+#include "driver-ops.h"
 
 #define IEEE80211_AUTH_TIMEOUT (HZ / 5)
 #define IEEE80211_AUTH_MAX_TRIES 3
@@ -435,6 +436,13 @@ ieee80211_direct_probe(struct ieee80211_
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	if (!wk->probe_auth.prepared) {
+		int ret = drv_prepare_auth_assoc(local, sdata, wk->filter_ta);
+		if (ret)
+			return WORK_ACT_TIMEOUT;
+	}
+	wk->probe_auth.prepared = true;
+
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: direct probe to %pM timed out\n",
@@ -473,6 +481,13 @@ ieee80211_authenticate(struct ieee80211_
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	if (!wk->probe_auth.prepared) {
+		int ret = drv_prepare_auth_assoc(local, sdata, wk->filter_ta);
+		if (ret)
+			return WORK_ACT_TIMEOUT;
+	}
+	wk->probe_auth.prepared = true;
+
 	wk->probe_auth.tries++;
 	if (wk->probe_auth.tries > IEEE80211_AUTH_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: authentication with %pM"
@@ -506,6 +521,13 @@ ieee80211_associate(struct ieee80211_wor
 	struct ieee80211_sub_if_data *sdata = wk->sdata;
 	struct ieee80211_local *local = sdata->local;
 
+	if (!wk->assoc.prepared) {
+		int ret = drv_prepare_auth_assoc(local, sdata, wk->filter_ta);
+		if (ret)
+			return WORK_ACT_TIMEOUT;
+	}
+	wk->assoc.prepared = true;
+
 	wk->assoc.tries++;
 	if (wk->assoc.tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with %pM"
--- a/net/mac80211/driver-ops.h	2011-05-13 14:59:50.000000000 +0200
+++ b/net/mac80211/driver-ops.h	2011-05-13 15:04:55.000000000 +0200
@@ -130,6 +130,37 @@ static inline void drv_bss_info_changed(
 	trace_drv_return_void(local);
 }
 
+static inline int drv_prepare_auth_assoc(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data *sdata,
+					 const u8 *bssid)
+{
+	int ret = 0;
+
+	might_sleep();
+
+	trace_drv_prepare_auth_assoc(local, sdata, bssid);
+	if (local->ops->prepare_auth_assoc)
+		ret = local->ops->prepare_auth_assoc(&local->hw,
+						     &sdata->vif,
+						     bssid);
+	trace_drv_return_int(local, ret);
+	return ret;
+}
+
+static inline void drv_finish_auth_assoc(struct ieee80211_local *local,
+					 struct ieee80211_sub_if_data *sdata,
+					 const u8 *bssid)
+{
+	might_sleep();
+
+	trace_drv_finish_auth_assoc(local, sdata, bssid);
+	if (local->ops->finish_auth_assoc)
+		local->ops->finish_auth_assoc(&local->hw,
+					      &sdata->vif,
+					      bssid);
+	trace_drv_return_void(local);
+}
+
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
--- a/net/mac80211/driver-trace.h	2011-05-13 15:02:09.000000000 +0200
+++ b/net/mac80211/driver-trace.h	2011-05-13 15:04:35.000000000 +0200
@@ -119,6 +119,30 @@ DECLARE_EVENT_CLASS(local_sdata_evt,
 	)
 );
 
+DECLARE_EVENT_CLASS(local_sdata_bssid_evt,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid),
+	TP_ARGS(local, sdata, bssid),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		__array(char, bssid, ETH_ALEN)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		memcpy(__entry->bssid, bssid, ETH_ALEN);
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT " bssid:%pM",
+		LOCAL_PR_ARG, VIF_PR_ARG, __entry->bssid
+	)
+);
+
 DEFINE_EVENT(local_only_evt, drv_return_void,
 	TP_PROTO(struct ieee80211_local *local),
 	TP_ARGS(local)
@@ -319,6 +343,20 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
+DEFINE_EVENT(local_sdata_bssid_evt, drv_prepare_auth_assoc,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid),
+	TP_ARGS(local, sdata, bssid)
+)
+
+DEFINE_EVENT(local_sdata_bssid_evt, drv_finish_auth_assoc,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 const u8 *bssid),
+	TP_ARGS(local, sdata, bssid)
+)
+
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count),
 


