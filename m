Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbZDWOCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 10:02:20 -0400
Subject: [PATCH] mac80211: fix scan races and rework scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 23 Apr 2009 16:01:47 +0200
Message-Id: <1240495307.30082.227.camel@johannes.local> (sfid-20090423_160225_856729_0DE698F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some places marked
	/* XXX maybe racy? */
and they really are racy because there's no locking.

This patch reworks much of the scan code, and introduces proper
locking for the scan request as well as the internal scanning
(which is necessary for IBSS/managed modes). Helper functions
are added to call the scanning code whenever necessary. The
scan deferring is changed to simply queue the scanning work
instead of trying to start the scan in place, the scanning work
will then take care of the rest.

Also, currently when internal scans are requested for an interface
that is trying to associate, we reject such scans. This was not
intended, the mlme code has provisions to scan twice when it can't
find the BSS to associate with right away; this has never worked
properly. Fix this by not rejecting internal scan requests for an
interface that is associating.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ibss.c        |   22 --
 net/mac80211/ieee80211_i.h |    6 
 net/mac80211/main.c        |    2 
 net/mac80211/mlme.c        |   28 +--
 net/mac80211/scan.c        |  387 ++++++++++++++++++++++++---------------------
 5 files changed, 229 insertions(+), 216 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2009-04-23 12:30:59.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2009-04-23 15:36:15.000000000 +0200
@@ -432,15 +432,7 @@ static void ieee80211_sta_merge_ibss(str
 	printk(KERN_DEBUG "%s: No active IBSS STAs - trying to scan for other "
 	       "IBSS networks with same SSID (merge)\n", sdata->dev->name);
 
-	/* XXX maybe racy? */
-	if (sdata->local->scan_req)
-		return;
-
-	memcpy(sdata->local->int_scan_req.ssids[0].ssid,
-	       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
-	sdata->local->int_scan_req.ssids[0].ssid_len = ifibss->ssid_len;
-	if (ieee80211_request_scan(sdata, &sdata->local->int_scan_req))
-		ieee80211_scan_failed(sdata->local);
+	ieee80211_request_internal_scan(sdata, ifibss->ssid, ifibss->ssid_len);
 }
 
 static void ieee80211_sta_create_ibss(struct ieee80211_sub_if_data *sdata)
@@ -553,16 +545,8 @@ static void ieee80211_sta_find_ibss(stru
 		printk(KERN_DEBUG "%s: Trigger new scan to find an IBSS to "
 		       "join\n", sdata->dev->name);
 
-		/* XXX maybe racy? */
-		if (local->scan_req)
-			return;
-
-		memcpy(local->int_scan_req.ssids[0].ssid,
-		       ifibss->ssid, IEEE80211_MAX_SSID_LEN);
-		local->int_scan_req.ssids[0].ssid_len =
-			ifibss->ssid_len;
-		if (ieee80211_request_scan(sdata, &local->int_scan_req))
-			ieee80211_scan_failed(local);
+		ieee80211_request_internal_scan(sdata, ifibss->ssid,
+						ifibss->ssid_len);
 	} else if (ifibss->state != IEEE80211_IBSS_MLME_JOINED) {
 		int interval = IEEE80211_SCAN_INTERVAL;
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-04-23 12:29:57.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-04-23 15:36:13.000000000 +0200
@@ -659,6 +659,7 @@ struct ieee80211_local {
 
 
 	/* Scanning and BSS list */
+	struct mutex scan_mtx;
 	bool sw_scanning, hw_scanning;
 	struct cfg80211_ssid scan_ssid;
 	struct cfg80211_scan_request int_scan_req;
@@ -947,6 +948,8 @@ int ieee80211_ibss_leave(struct ieee8021
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
+int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
+				    const u8 *ssid, u8 ssid_len);
 int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
 			   struct cfg80211_scan_request *req);
 int ieee80211_scan_results(struct ieee80211_local *local,
@@ -960,9 +963,6 @@ int ieee80211_sta_set_extra_ie(struct ie
 			       const char *ie, size_t len);
 
 void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local);
-void ieee80211_scan_failed(struct ieee80211_local *local);
-int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-			 struct cfg80211_scan_request *req);
 struct ieee80211_bss *
 ieee80211_bss_info_update(struct ieee80211_local *local,
 			  struct ieee80211_rx_status *rx_status,
--- wireless-testing.orig/net/mac80211/main.c	2009-04-23 12:30:27.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-04-23 15:36:15.000000000 +0200
@@ -782,6 +782,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	INIT_LIST_HEAD(&local->interfaces);
 	mutex_init(&local->iflist_mtx);
+	mutex_init(&local->scan_mtx);
 
 	spin_lock_init(&local->key_lock);
 
@@ -1126,6 +1127,7 @@ void ieee80211_free_hw(struct ieee80211_
 	struct ieee80211_local *local = hw_to_local(hw);
 
 	mutex_destroy(&local->iflist_mtx);
+	mutex_destroy(&local->scan_mtx);
 
 	wiphy_free(local->hw.wiphy);
 }
--- wireless-testing.orig/net/mac80211/scan.c	2009-04-23 12:32:48.000000000 +0200
+++ wireless-testing/net/mac80211/scan.c	2009-04-23 15:37:10.000000000 +0200
@@ -202,18 +202,6 @@ ieee80211_scan_rx(struct ieee80211_sub_i
 	return RX_QUEUED;
 }
 
-void ieee80211_scan_failed(struct ieee80211_local *local)
-{
-	if (WARN_ON(!local->scan_req))
-		return;
-
-	/* notify cfg80211 about the failed scan */
-	if (local->scan_req != &local->int_scan_req)
-		cfg80211_scan_done(local->scan_req, true);
-
-	local->scan_req = NULL;
-}
-
 /*
  * inform AP that we will go to sleep so that it will buffer the frames
  * while we scan
@@ -274,29 +262,46 @@ static void ieee80211_scan_ps_disable(st
 	}
 }
 
+static void ieee80211_restore_scan_ies(struct ieee80211_local *local)
+{
+	kfree(local->scan_req->ie);
+	local->scan_req->ie = local->orig_ies;
+	local->scan_req->ie_len = local->orig_ies_len;
+}
+
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
+	bool was_hw_scan;
 
-	if (WARN_ON(!local->hw_scanning && !local->sw_scanning))
-		return;
+	mutex_lock(&local->scan_mtx);
 
-	if (WARN_ON(!local->scan_req))
+	if (WARN_ON(!local->hw_scanning && !local->sw_scanning)) {
+		mutex_unlock(&local->scan_mtx);
 		return;
+	}
 
-	if (local->hw_scanning) {
-		kfree(local->scan_req->ie);
-		local->scan_req->ie = local->orig_ies;
-		local->scan_req->ie_len = local->orig_ies_len;
+	if (WARN_ON(!local->scan_req)) {
+		mutex_unlock(&local->scan_mtx);
+		return;
 	}
 
+	if (local->hw_scanning)
+		ieee80211_restore_scan_ies(local);
+
 	if (local->scan_req != &local->int_scan_req)
 		cfg80211_scan_done(local->scan_req, aborted);
 	local->scan_req = NULL;
 
-	if (local->hw_scanning) {
-		local->hw_scanning = false;
+	was_hw_scan = local->hw_scanning;
+	local->hw_scanning = false;
+	local->sw_scanning = false;
+
+	/* we only have to protect scan_req and hw/sw scan */
+	mutex_unlock(&local->scan_mtx);
+
+	if (was_hw_scan) {
 		/*
 		 * Somebody might have requested channel change during scan
 		 * that we won't have acted upon, try now. ieee80211_hw_config
@@ -306,7 +311,6 @@ void ieee80211_scan_completed(struct iee
 		goto done;
 	}
 
-	local->sw_scanning = false;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	netif_tx_lock_bh(local->mdev);
@@ -354,6 +358,146 @@ void ieee80211_scan_completed(struct iee
 }
 EXPORT_SYMBOL(ieee80211_scan_completed);
 
+static int ieee80211_start_sw_scan(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	/*
+	 * Hardware/driver doesn't support hw_scan, so use software
+	 * scanning instead. First send a nullfunc frame with power save
+	 * bit on so that AP will buffer the frames for us while we are not
+	 * listening, then send probe requests to each channel and wait for
+	 * the responses. After all channels are scanned, tune back to the
+	 * original channel and send a nullfunc frame with power save bit
+	 * off to trigger the AP to send us all the buffered frames.
+	 *
+	 * Note that while local->sw_scanning is true everything else but
+	 * nullfunc frames and probe requests will be dropped in
+	 * ieee80211_tx_h_check_assoc().
+	 */
+	if (local->ops->sw_scan_start)
+		local->ops->sw_scan_start(local_to_hw(local));
+
+	mutex_lock(&local->iflist_mtx);
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		if (!netif_running(sdata->dev))
+			continue;
+
+		/* disable beaconing */
+		if (sdata->vif.type == NL80211_IFTYPE_AP ||
+		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
+		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
+			ieee80211_if_config(sdata,
+					    IEEE80211_IFCC_BEACON_ENABLED);
+
+		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
+				netif_tx_stop_all_queues(sdata->dev);
+				ieee80211_scan_ps_enable(sdata);
+			}
+		} else
+			netif_tx_stop_all_queues(sdata->dev);
+	}
+	mutex_unlock(&local->iflist_mtx);
+
+	local->scan_state = SCAN_SET_CHANNEL;
+	local->scan_channel_idx = 0;
+
+	netif_addr_lock_bh(local->mdev);
+	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+	local->ops->configure_filter(local_to_hw(local),
+				     FIF_BCN_PRBRESP_PROMISC,
+				     &local->filter_flags,
+				     local->mdev->mc_count,
+				     local->mdev->mc_list);
+	netif_addr_unlock_bh(local->mdev);
+
+	/* TODO: start scan as soon as all nullfunc frames are ACKed */
+	queue_delayed_work(local->hw.workqueue, &local->scan_work,
+			   IEEE80211_CHANNEL_TIME);
+
+	return 0;
+}
+
+
+static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
+				  struct cfg80211_scan_request *req)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	int rc;
+
+	if (local->scan_req)
+		return -EBUSY;
+
+	if (local->ops->hw_scan) {
+		u8 *ies;
+		int ielen;
+
+		ies = kmalloc(2 + IEEE80211_MAX_SSID_LEN +
+			      local->scan_ies_len + req->ie_len, GFP_KERNEL);
+		if (!ies)
+			return -ENOMEM;
+
+		ielen = ieee80211_build_preq_ies(local, ies,
+						 req->ie, req->ie_len);
+		local->orig_ies = req->ie;
+		local->orig_ies_len = req->ie_len;
+		req->ie = ies;
+		req->ie_len = ielen;
+	}
+
+	local->scan_req = req;
+	local->scan_sdata = sdata;
+
+	if (req != &local->int_scan_req &&
+	    sdata->vif.type == NL80211_IFTYPE_STATION &&
+	    (ifmgd->state == IEEE80211_STA_MLME_DIRECT_PROBE ||
+	     ifmgd->state == IEEE80211_STA_MLME_AUTHENTICATE ||
+	     ifmgd->state == IEEE80211_STA_MLME_ASSOCIATE)) {
+		/* actually wait for the assoc to finish/time out */
+		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
+		return 0;
+	}
+
+	if (local->ops->hw_scan)
+		local->hw_scanning = true;
+	else
+		local->sw_scanning = true;
+	/*
+	 * Kicking off the scan need not be protected,
+	 * only the scan variable stuff, since now
+	 * local->scan_req is assigned and other callers
+	 * will abort their scan attempts.
+	 *
+	 * This avoids getting a scan_mtx -> iflist_mtx
+	 * dependency, so that the scan completed calls
+	 * have more locking freedom.
+	 */
+	mutex_unlock(&local->scan_mtx);
+
+	if (local->ops->hw_scan)
+		rc = local->ops->hw_scan(local_to_hw(local),
+					 local->scan_req);
+	else
+		rc = ieee80211_start_sw_scan(local);
+
+	mutex_lock(&local->scan_mtx);
+
+	if (rc) {
+		if (local->ops->hw_scan) {
+			local->hw_scanning = false;
+			ieee80211_restore_scan_ies(local);
+		} else
+			local->sw_scanning = false;
+
+		local->scan_req = NULL;
+		local->scan_sdata = NULL;
+	}
+
+	return rc;
+}
+
 void ieee80211_scan_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
@@ -363,17 +507,41 @@ void ieee80211_scan_work(struct work_str
 	int skip, i;
 	unsigned long next_delay = 0;
 
+	mutex_lock(&local->scan_mtx);
+	if (!sdata || !local->scan_req) {
+		mutex_unlock(&local->scan_mtx);
+		return;
+	}
+
+	if (local->scan_req && !(local->sw_scanning || local->hw_scanning)) {
+		struct cfg80211_scan_request *req = local->scan_req;
+		int rc;
+
+		local->scan_req = NULL;
+
+		rc = __ieee80211_start_scan(sdata, req);
+		mutex_unlock(&local->scan_mtx);
+
+		if (rc)
+			ieee80211_scan_completed(&local->hw, true);
+		return;
+	}
+
+	mutex_unlock(&local->scan_mtx);
+
 	/*
 	 * Avoid re-scheduling when the sdata is going away.
 	 */
-	if (!netif_running(sdata->dev))
+	if (!netif_running(sdata->dev)) {
+		ieee80211_scan_completed(&local->hw, true);
 		return;
+	}
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
 		/* if no more bands/channels left, complete scan */
 		if (local->scan_channel_idx >= local->scan_req->n_channels) {
-			ieee80211_scan_completed(local_to_hw(local), false);
+			ieee80211_scan_completed(&local->hw, false);
 			return;
 		}
 		skip = 0;
@@ -422,166 +590,35 @@ void ieee80211_scan_work(struct work_str
 			   next_delay);
 }
 
-
-int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
-			 struct cfg80211_scan_request *req)
+int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
+			   struct cfg80211_scan_request *req)
 {
-	struct ieee80211_local *local = scan_sdata->local;
-	struct ieee80211_sub_if_data *sdata;
-
-	if (!req)
-		return -EINVAL;
-
-	if (local->scan_req && local->scan_req != req)
-		return -EBUSY;
-
-	local->scan_req = req;
-
-	/* MLME-SCAN.request (page 118)  page 144 (11.1.3.1)
-	 * BSSType: INFRASTRUCTURE, INDEPENDENT, ANY_BSS
-	 * BSSID: MACAddress
-	 * SSID
-	 * ScanType: ACTIVE, PASSIVE
-	 * ProbeDelay: delay (in microseconds) to be used prior to transmitting
-	 *    a Probe frame during active scanning
-	 * ChannelList
-	 * MinChannelTime (>= ProbeDelay), in TU
-	 * MaxChannelTime: (>= MinChannelTime), in TU
-	 */
-
-	 /* MLME-SCAN.confirm
-	  * BSSDescriptionSet
-	  * ResultCode: SUCCESS, INVALID_PARAMETERS
-	 */
-
-	if (local->sw_scanning || local->hw_scanning) {
-		if (local->scan_sdata == scan_sdata)
-			return 0;
-		return -EBUSY;
-	}
-
-	if (local->ops->hw_scan) {
-		u8 *ies;
-		int rc, ielen;
-
-		ies = kmalloc(2 + IEEE80211_MAX_SSID_LEN +
-			      local->scan_ies_len + req->ie_len, GFP_KERNEL);
-		if (!ies)
-			return -ENOMEM;
-
-		ielen = ieee80211_build_preq_ies(local, ies,
-						 req->ie, req->ie_len);
-		local->orig_ies = req->ie;
-		local->orig_ies_len = req->ie_len;
-		req->ie = ies;
-		req->ie_len = ielen;
-
-		local->hw_scanning = true;
-		rc = local->ops->hw_scan(local_to_hw(local), req);
-		if (rc) {
-			local->hw_scanning = false;
-			kfree(ies);
-			req->ie_len = local->orig_ies_len;
-			req->ie = local->orig_ies;
-			return rc;
-		}
-		local->scan_sdata = scan_sdata;
-		return 0;
-	}
-
-	/*
-	 * Hardware/driver doesn't support hw_scan, so use software
-	 * scanning instead. First send a nullfunc frame with power save
-	 * bit on so that AP will buffer the frames for us while we are not
-	 * listening, then send probe requests to each channel and wait for
-	 * the responses. After all channels are scanned, tune back to the
-	 * original channel and send a nullfunc frame with power save bit
-	 * off to trigger the AP to send us all the buffered frames.
-	 *
-	 * Note that while local->sw_scanning is true everything else but
-	 * nullfunc frames and probe requests will be dropped in
-	 * ieee80211_tx_h_check_assoc().
-	 */
-	local->sw_scanning = true;
-	if (local->ops->sw_scan_start)
-		local->ops->sw_scan_start(local_to_hw(local));
-
-	mutex_lock(&local->iflist_mtx);
-	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!netif_running(sdata->dev))
-			continue;
-
-		/* disable beaconing */
-		if (sdata->vif.type == NL80211_IFTYPE_AP ||
-		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
-		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
-			ieee80211_if_config(sdata,
-					    IEEE80211_IFCC_BEACON_ENABLED);
+	int res;
 
-		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
-			if (sdata->u.mgd.flags & IEEE80211_STA_ASSOCIATED) {
-				netif_tx_stop_all_queues(sdata->dev);
-				ieee80211_scan_ps_enable(sdata);
-			}
-		} else
-			netif_tx_stop_all_queues(sdata->dev);
-	}
-	mutex_unlock(&local->iflist_mtx);
+	mutex_lock(&sdata->local->scan_mtx);
+	res = __ieee80211_start_scan(sdata, req);
+	mutex_unlock(&sdata->local->scan_mtx);
 
-	local->scan_state = SCAN_SET_CHANNEL;
-	local->scan_channel_idx = 0;
-	local->scan_sdata = scan_sdata;
-	local->scan_req = req;
-
-	netif_addr_lock_bh(local->mdev);
-	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
-	local->ops->configure_filter(local_to_hw(local),
-				     FIF_BCN_PRBRESP_PROMISC,
-				     &local->filter_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
-	netif_addr_unlock_bh(local->mdev);
-
-	/* TODO: start scan as soon as all nullfunc frames are ACKed */
-	queue_delayed_work(local->hw.workqueue, &local->scan_work,
-			   IEEE80211_CHANNEL_TIME);
-
-	return 0;
+	return res;
 }
 
-
-int ieee80211_request_scan(struct ieee80211_sub_if_data *sdata,
-			   struct cfg80211_scan_request *req)
+int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
+				    const u8 *ssid, u8 ssid_len)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd;
-
-	if (!req)
-		return -EINVAL;
-
-	if (local->scan_req && local->scan_req != req)
-		return -EBUSY;
-
-	local->scan_req = req;
+	int ret = -EBUSY;
 
-	if (sdata->vif.type != NL80211_IFTYPE_STATION)
-		return ieee80211_start_scan(sdata, req);
+	mutex_lock(&local->scan_mtx);
 
-	/*
-	 * STA has a state machine that might need to defer scanning
-	 * while it's trying to associate/authenticate, therefore we
-	 * queue it up to the state machine in that case.
-	 */
+	/* busy scanning */
+	if (local->scan_req)
+		goto unlock;
 
-	if (local->sw_scanning || local->hw_scanning) {
-		if (local->scan_sdata == sdata)
-			return 0;
-		return -EBUSY;
-	}
-
-	ifmgd = &sdata->u.mgd;
-	set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
-	queue_work(local->hw.workqueue, &ifmgd->work);
+	memcpy(local->int_scan_req.ssids[0].ssid, ssid, IEEE80211_MAX_SSID_LEN);
+	local->int_scan_req.ssids[0].ssid_len = ssid_len;
 
-	return 0;
+	ret = __ieee80211_start_scan(sdata, &sdata->local->int_scan_req);
+ unlock:
+	mutex_unlock(&local->scan_mtx);
+	return ret;
 }
--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-23 12:39:53.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-23 15:36:15.000000000 +0200
@@ -2072,19 +2072,15 @@ static int ieee80211_sta_config_auth(str
 		return 0;
 	} else {
 		if (ifmgd->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
+			u8 ssid_len = 0;
+
+			if (!(ifmgd->flags & IEEE80211_STA_AUTO_SSID_SEL))
+				ssid_len = ifmgd->ssid_len;
+
 			ifmgd->assoc_scan_tries++;
-			/* XXX maybe racy? */
-			if (local->scan_req)
-				return -1;
-			memcpy(local->int_scan_req.ssids[0].ssid,
-			       ifmgd->ssid, IEEE80211_MAX_SSID_LEN);
-			if (ifmgd->flags & IEEE80211_STA_AUTO_SSID_SEL)
-				local->int_scan_req.ssids[0].ssid_len = 0;
-			else
-				local->int_scan_req.ssids[0].ssid_len = ifmgd->ssid_len;
 
-			if (ieee80211_start_scan(sdata, &local->int_scan_req))
-				ieee80211_scan_failed(local);
+			ieee80211_request_internal_scan(sdata, ifmgd->ssid,
+							ssid_len);
 
 			ifmgd->state = IEEE80211_STA_MLME_AUTHENTICATE;
 			set_bit(IEEE80211_STA_REQ_AUTH, &ifmgd->request);
@@ -2122,14 +2118,8 @@ static void ieee80211_sta_work(struct wo
 	    ifmgd->state != IEEE80211_STA_MLME_AUTHENTICATE &&
 	    ifmgd->state != IEEE80211_STA_MLME_ASSOCIATE &&
 	    test_and_clear_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request)) {
-		/*
-		 * The call to ieee80211_start_scan can fail but ieee80211_request_scan
-		 * (which queued ieee80211_sta_work) did not return an error. Thus, call
-		 * ieee80211_scan_failed here if ieee80211_start_scan fails in order to
-		 * notify the scan requester.
-		 */
-		if (ieee80211_start_scan(sdata, local->scan_req))
-			ieee80211_scan_failed(local);
+		queue_delayed_work(local->hw.workqueue, &local->scan_work,
+				   round_jiffies_relative(0));
 		return;
 	}
 


