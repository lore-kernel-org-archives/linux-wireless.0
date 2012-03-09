Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50675 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2CILtX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 06:49:23 -0500
Subject: [PATCH] mac80211: remove tx_sync
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Mar 2012 12:49:21 +0100
Message-ID: <1331293761.3491.2.camel@jlt3.sipsolutions.net> (sfid-20120309_124936_801749_B5E68A7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the station state callback was added, this
was no longer needed in theory. With the iwlwifi
changes to remove use of it landing, we can kill
the entire tx-sync framework again, RIP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h      |   41 -----------------------------------------
 net/mac80211/driver-ops.h   |   35 -----------------------------------
 net/mac80211/driver-trace.h |   43 -------------------------------------------
 net/mac80211/ieee80211_i.h  |    1 -
 net/mac80211/mlme.c         |   41 -----------------------------------------
 5 files changed, 161 deletions(-)

--- a/include/net/mac80211.h	2012-03-09 12:46:56.000000000 +0100
+++ b/include/net/mac80211.h	2012-03-09 12:47:46.000000000 +0100
@@ -1766,20 +1766,6 @@ enum ieee80211_ampdu_mlme_action {
 };
 
 /**
- * enum ieee80211_tx_sync_type - TX sync type
- * @IEEE80211_TX_SYNC_AUTH: sync TX for authentication
- *	(and possibly also before direct probe)
- * @IEEE80211_TX_SYNC_ASSOC: sync TX for association
- * @IEEE80211_TX_SYNC_ACTION: sync TX for action frame
- *	(not implemented yet)
- */
-enum ieee80211_tx_sync_type {
-	IEEE80211_TX_SYNC_AUTH,
-	IEEE80211_TX_SYNC_ASSOC,
-	IEEE80211_TX_SYNC_ACTION,
-};
-
-/**
  * enum ieee80211_frame_release_type - frame release reason
  * @IEEE80211_FRAME_RELEASE_PSPOLL: frame released for PS-Poll
  * @IEEE80211_FRAME_RELEASE_UAPSD: frame(s) released due to
@@ -1889,26 +1875,6 @@ enum ieee80211_frame_release_type {
  *	of the bss parameters has changed when a call is made. The callback
  *	can sleep.
  *
- * @tx_sync: Called before a frame is sent to an AP/GO. In the GO case, the
- *	driver should sync with the GO's powersaving so the device doesn't
- *	transmit the frame while the GO is asleep. In the regular AP case
- *	it may be used by drivers for devices implementing other restrictions
- *	on talking to APs, e.g. due to regulatory enforcement or just HW
- *	restrictions.
- *	This function is called for every authentication, association and
- *	action frame separately since applications might attempt to auth
- *	with multiple APs before chosing one to associate to. If it returns
- *	an error, the corresponding authentication, association or frame
- *	transmission is aborted and reported as having failed. It is always
- *	called after tuning to the correct channel.
- *	The callback might be called multiple times before @finish_tx_sync
- *	(but @finish_tx_sync will be called once for each) but in practice
- *	this is unlikely to happen. It can also refuse in that case if the
- *	driver cannot handle that situation.
- *	This callback can sleep.
- * @finish_tx_sync: Called as a counterpart to @tx_sync, unless that returned
- *	an error. This callback can sleep.
- *
  * @prepare_multicast: Prepare for multicast filter configuration.
  *	This callback is optional, and its return value is passed
  *	to configure_filter(). This callback must be atomic.
@@ -2180,13 +2146,6 @@ struct ieee80211_ops {
 				 struct ieee80211_bss_conf *info,
 				 u32 changed);
 
-	int (*tx_sync)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		       const u8 *bssid, enum ieee80211_tx_sync_type type);
-	void (*finish_tx_sync)(struct ieee80211_hw *hw,
-			       struct ieee80211_vif *vif,
-			       const u8 *bssid,
-			       enum ieee80211_tx_sync_type type);
-
 	u64 (*prepare_multicast)(struct ieee80211_hw *hw,
 				 struct netdev_hw_addr_list *mc_list);
 	void (*configure_filter)(struct ieee80211_hw *hw,
--- a/net/mac80211/driver-ops.h	2012-03-09 12:46:56.000000000 +0100
+++ b/net/mac80211/driver-ops.h	2012-03-09 12:47:46.000000000 +0100
@@ -168,41 +168,6 @@ static inline void drv_bss_info_changed(
 	trace_drv_return_void(local);
 }
 
-static inline int drv_tx_sync(struct ieee80211_local *local,
-			      struct ieee80211_sub_if_data *sdata,
-			      const u8 *bssid,
-			      enum ieee80211_tx_sync_type type)
-{
-	int ret = 0;
-
-	might_sleep();
-
-	check_sdata_in_driver(sdata);
-
-	trace_drv_tx_sync(local, sdata, bssid, type);
-	if (local->ops->tx_sync)
-		ret = local->ops->tx_sync(&local->hw, &sdata->vif,
-					  bssid, type);
-	trace_drv_return_int(local, ret);
-	return ret;
-}
-
-static inline void drv_finish_tx_sync(struct ieee80211_local *local,
-				      struct ieee80211_sub_if_data *sdata,
-				      const u8 *bssid,
-				      enum ieee80211_tx_sync_type type)
-{
-	might_sleep();
-
-	check_sdata_in_driver(sdata);
-
-	trace_drv_finish_tx_sync(local, sdata, bssid, type);
-	if (local->ops->finish_tx_sync)
-		local->ops->finish_tx_sync(&local->hw, &sdata->vif,
-					   bssid, type);
-	trace_drv_return_void(local);
-}
-
 static inline u64 drv_prepare_multicast(struct ieee80211_local *local,
 					struct netdev_hw_addr_list *mc_list)
 {
--- a/net/mac80211/driver-trace.h	2012-03-09 12:46:56.000000000 +0100
+++ b/net/mac80211/driver-trace.h	2012-03-09 12:47:46.000000000 +0100
@@ -308,49 +308,6 @@ TRACE_EVENT(drv_bss_info_changed,
 	)
 );
 
-DECLARE_EVENT_CLASS(tx_sync_evt,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 const u8 *bssid,
-		 enum ieee80211_tx_sync_type type),
-	TP_ARGS(local, sdata, bssid, type),
-
-	TP_STRUCT__entry(
-		LOCAL_ENTRY
-		VIF_ENTRY
-		__array(char, bssid, ETH_ALEN)
-		__field(u32, sync_type)
-	),
-
-	TP_fast_assign(
-		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		memcpy(__entry->bssid, bssid, ETH_ALEN);
-		__entry->sync_type = type;
-	),
-
-	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT " bssid:%pM type:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, __entry->bssid, __entry->sync_type
-	)
-);
-
-DEFINE_EVENT(tx_sync_evt, drv_tx_sync,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 const u8 *bssid,
-		 enum ieee80211_tx_sync_type type),
-	TP_ARGS(local, sdata, bssid, type)
-);
-
-DEFINE_EVENT(tx_sync_evt, drv_finish_tx_sync,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 const u8 *bssid,
-		 enum ieee80211_tx_sync_type type),
-	TP_ARGS(local, sdata, bssid, type)
-);
-
 TRACE_EVENT(drv_prepare_multicast,
 	TP_PROTO(struct ieee80211_local *local, int mc_count),
 
--- a/net/mac80211/ieee80211_i.h	2012-03-09 12:47:46.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2012-03-09 12:47:46.000000000 +0100
@@ -388,7 +388,6 @@ struct ieee80211_mgd_auth_data {
 
 	u8 key[WLAN_KEY_LEN_WEP104];
 	u8 key_len, key_idx;
-	bool synced;
 	bool done;
 
 	size_t ie_len;
--- a/net/mac80211/mlme.c	2012-03-09 12:47:46.000000000 +0100
+++ b/net/mac80211/mlme.c	2012-03-09 12:47:46.000000000 +0100
@@ -1750,11 +1750,6 @@ static void ieee80211_destroy_auth_data(
 
 	lockdep_assert_held(&sdata->u.mgd.mtx);
 
-	if (auth_data->synced)
-		drv_finish_tx_sync(sdata->local, sdata,
-				   auth_data->bss->bssid,
-				   IEEE80211_TX_SYNC_AUTH);
-
 	if (!assoc) {
 		sta_info_destroy_addr(sdata, auth_data->bss->bssid);
 
@@ -1842,10 +1837,6 @@ ieee80211_rx_mgmt_auth(struct ieee80211_
 
 	printk(KERN_DEBUG "%s: authenticated\n", sdata->name);
  out:
-	if (ifmgd->auth_data->synced)
-		drv_finish_tx_sync(sdata->local, sdata, bssid,
-				   IEEE80211_TX_SYNC_AUTH);
-	ifmgd->auth_data->synced = false;
 	ifmgd->auth_data->done = true;
 	ifmgd->auth_data->timeout = jiffies + IEEE80211_AUTH_WAIT_ASSOC;
 	run_again(ifmgd, ifmgd->auth_data->timeout);
@@ -1985,11 +1976,6 @@ static void ieee80211_destroy_assoc_data
 
 	lockdep_assert_held(&sdata->u.mgd.mtx);
 
-	if (assoc_data->synced)
-		drv_finish_tx_sync(sdata->local, sdata,
-				   assoc_data->bss->bssid,
-				   IEEE80211_TX_SYNC_ASSOC);
-
 	if (!assoc) {
 		sta_info_destroy_addr(sdata, assoc_data->bss->bssid);
 
@@ -2200,14 +2186,6 @@ ieee80211_rx_mgmt_assoc_resp(struct ieee
 	} else {
 		printk(KERN_DEBUG "%s: associated\n", sdata->name);
 
-		/* tell driver about sync done first */
-		if (assoc_data->synced) {
-			drv_finish_tx_sync(sdata->local, sdata,
-					   assoc_data->bss->bssid,
-					   IEEE80211_TX_SYNC_ASSOC);
-			assoc_data->synced = false;
-		}
-
 		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
 			/* oops -- internal error -- send timeout for now */
 			ieee80211_destroy_assoc_data(sdata, true);
@@ -2692,14 +2670,6 @@ static int ieee80211_probe_auth(struct i
 	if (WARN_ON_ONCE(!auth_data))
 		return -EINVAL;
 
-	if (!auth_data->synced) {
-		int ret = drv_tx_sync(local, sdata, auth_data->bss->bssid,
-				      IEEE80211_TX_SYNC_AUTH);
-		if (ret)
-			return ret;
-	}
-	auth_data->synced = true;
-
 	auth_data->tries++;
 
 	if (auth_data->tries > IEEE80211_AUTH_MAX_TRIES) {
@@ -2756,14 +2726,6 @@ static int ieee80211_do_assoc(struct iee
 
 	lockdep_assert_held(&sdata->u.mgd.mtx);
 
-	if (!assoc_data->synced) {
-		int ret = drv_tx_sync(local, sdata, assoc_data->bss->bssid,
-				      IEEE80211_TX_SYNC_ASSOC);
-		if (ret)
-			return ret;
-	}
-	assoc_data->synced = true;
-
 	assoc_data->tries++;
 	if (assoc_data->tries > IEEE80211_ASSOC_MAX_TRIES) {
 		printk(KERN_DEBUG "%s: association with %pM timed out\n",
@@ -3261,9 +3223,6 @@ int ieee80211_mgd_auth(struct ieee80211_
 
 	err = ieee80211_probe_auth(sdata);
 	if (err) {
-		if (auth_data->synced)
-			drv_finish_tx_sync(local, sdata, req->bss->bssid,
-					   IEEE80211_TX_SYNC_AUTH);
 		sta_info_destroy_addr(sdata, req->bss->bssid);
 		goto err_clear;
 	}


