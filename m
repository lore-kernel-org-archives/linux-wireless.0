Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:42121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbYIOM3u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 08:29:50 -0400
Received: from Relay2.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id EA0B3418FA
	for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 14:29:48 +0200 (CEST)
From: Helmut Schaa <hschaa@suse.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC] Implement basic background scanning
Date: Mon, 15 Sep 2008 14:29:46 +0200
References: <200809151416.07552.hschaa@suse.de>
In-Reply-To: <200809151416.07552.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809151429.46638.hschaa@suse.de> (sfid-20080915_142954_498790_4E509226)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic implementation of software background scanning functionality.

The patch basically enhances the scanning state machine by two further
states (SCAN_DEFER, SCAN_OPERATION). In state SCAN_DEFER the driver is advised
to switch back to the operating channel while SCAN_OPERATION tells the access
point about being back from power saving and restarts the tx queue. Just before
SCAN_SET_CHANNEL sets the next channel to scan it notifies the access point
about going to power save state and stops the tx queue.

However one (still unresolved) issue is that the code does not wait for the
appropriate ACK from the access point after notifying the new power state.

Any thoughts or comments?

Signed-off-by: Helmut Schaa <hschaa@suse.de>
---

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c05f70c..91eac0b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -647,11 +647,11 @@ struct ieee80211_local {
 
 
 	/* Scanning and BSS list */
-	bool sw_scanning, hw_scanning;
+	bool sw_scanning, hw_scanning, bg_scanning;
 	int scan_channel_idx;
 	enum ieee80211_band scan_band;
 
-	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
+	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE, SCAN_DEFER, SCAN_OPERATION } scan_state;
 	unsigned long last_scan_completed;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 92d898b..49b5c29 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -414,7 +414,7 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 		return RX_QUEUED;
 	}
 
-	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN)) {
+	if (unlikely(rx->flags & IEEE80211_RX_IN_SCAN && !local->bg_scanning)) {
 		/* scanning finished during invoking of handlers */
 		I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
 		return RX_DROP_UNUSABLE;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 8e6685e..4a9cdfe 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -29,6 +29,7 @@
 #define IEEE80211_PROBE_DELAY (HZ / 33)
 #define IEEE80211_CHANNEL_TIME (HZ / 33)
 #define IEEE80211_PASSIVE_CHANNEL_TIME (HZ / 5)
+#define IEEE80211_BG_SCAN_INTERRUPT (HZ / 4)
 
 void ieee80211_rx_bss_list_init(struct ieee80211_local *local)
 {
@@ -455,6 +456,7 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	}
 
 	local->sw_scanning = false;
+	local->bg_scanning = false;
 	if (ieee80211_hw_config(local))
 		printk(KERN_DEBUG "%s: failed to restore operational "
 		       "channel after scan\n", wiphy_name(local->hw.wiphy));
@@ -510,6 +512,37 @@ void ieee80211_scan_work(struct work_struct *work)
 
 	switch (local->scan_state) {
 	case SCAN_SET_CHANNEL:
+		if (local->bg_scanning) {
+			/*
+			 * background scan is in progress, notify all associated 
+			 * access points about us leaving the channel and
+			 * update the filter flags
+			 */
+			local->sw_scanning = 1;
+
+			rcu_read_lock();
+			list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+				if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+				    (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED)) {
+					ieee80211_send_nullfunc(local, sdata, 1);
+					netif_tx_stop_all_queues(sdata->dev);
+				}
+			}
+			rcu_read_unlock();
+
+			/* TODO: start scan as soon as all nullfunc frames are ACKed */
+			msleep(1);
+
+			netif_tx_lock_bh(local->mdev);
+			local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+			local->ops->configure_filter(local_to_hw(local),
+						     FIF_BCN_PRBRESP_PROMISC,
+						     &local->filter_flags,
+						     local->mdev->mc_count,
+						     local->mdev->mc_list);
+			netif_tx_unlock_bh(local->mdev);
+		}
+
 		/*
 		 * Get current scan band. scan_band may be IEEE80211_NUM_BANDS
 		 * after we successfully scanned the last channel of the last
@@ -574,7 +607,10 @@ void ieee80211_scan_work(struct work_struct *work)
 		break;
 	case SCAN_SEND_PROBE:
 		next_delay = IEEE80211_PASSIVE_CHANNEL_TIME;
-		local->scan_state = SCAN_SET_CHANNEL;
+		if (!local->bg_scanning)
+			local->scan_state = SCAN_SET_CHANNEL;
+		else
+			local->scan_state = SCAN_DEFER;
 
 		if (local->scan_channel->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 			break;
@@ -582,6 +618,50 @@ void ieee80211_scan_work(struct work_struct *work)
 					 local->scan_ssid_len);
 		next_delay = IEEE80211_CHANNEL_TIME;
 		break;
+	case SCAN_DEFER:
+		local->scan_state = SCAN_OPERATION;
+		/* interrupt the current scan */
+		local->sw_scanning = 0;
+
+		/* switch back to the operating channel */
+		if (ieee80211_hw_config(local))
+			printk(KERN_DEBUG "%s: failed to restore operational "
+			       "channel after scan\n", sdata->dev->name);
+
+		/* reconfigure filter flags*/
+		netif_tx_lock_bh(local->mdev);
+		local->filter_flags &= ~FIF_BCN_PRBRESP_PROMISC;
+		local->ops->configure_filter(local_to_hw(local),
+					     FIF_BCN_PRBRESP_PROMISC,
+					     &local->filter_flags,
+					     local->mdev->mc_count,
+					     local->mdev->mc_list);
+
+		netif_tx_unlock_bh(local->mdev);
+
+		/* wait for the channel switch */
+		next_delay = usecs_to_jiffies(local->hw.channel_change_time);
+		break;
+
+	case SCAN_OPERATION:	
+		rcu_read_lock();
+		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+			/* Tell AP we're back */
+			if (sdata->vif.type == NL80211_IFTYPE_STATION &&
+			    sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
+				ieee80211_send_nullfunc(local, sdata, 0);
+				netif_tx_wake_all_queues(sdata->dev);
+			}
+		}
+		rcu_read_unlock();
+
+		/* TODO: start scan as soon as all nullfunc frames are ACKed */
+		msleep(1);
+
+		next_delay = IEEE80211_BG_SCAN_INTERRUPT;
+		local->scan_state = SCAN_SET_CHANNEL;
+
+		break;
 	}
 
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
@@ -615,7 +695,7 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 	  * ResultCode: SUCCESS, INVALID_PARAMETERS
 	 */
 
-	if (local->sw_scanning || local->hw_scanning) {
+	if (local->sw_scanning || local->hw_scanning || local->bg_scanning) {
 		if (local->scan_sdata == scan_sdata)
 			return 0;
 		return -EBUSY;
@@ -636,18 +716,28 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 
 	local->sw_scanning = true;
 
+	/*
+	 * if at least one station interface is associated start a background scan
+	 * instead of a common software scan
+	 */
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.sta.flags & IEEE80211_STA_ASSOCIATED) {
-				netif_tx_stop_all_queues(sdata->dev);
-				ieee80211_send_nullfunc(local, sdata, 1);
+				/*
+				 * no need to stop station interaces here, that will be done in
+				 * the scan handler
+				 */
+				local->bg_scanning = true;
 			}
 		} else
 			netif_tx_stop_all_queues(sdata->dev);
 	}
 	rcu_read_unlock();
 
+	if (!local->bg_scanning)
+		local->sw_scanning = true;
+
 	if (ssid) {
 		local->scan_ssid_len = ssid_len;
 		memcpy(local->scan_ssid, ssid, ssid_len);
@@ -658,14 +748,16 @@ int ieee80211_start_scan(struct ieee80211_sub_if_data *scan_sdata,
 	local->scan_band = IEEE80211_BAND_2GHZ;
 	local->scan_sdata = scan_sdata;
 
-	netif_addr_lock_bh(local->mdev);
-	local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
-	local->ops->configure_filter(local_to_hw(local),
-				     FIF_BCN_PRBRESP_PROMISC,
-				     &local->filter_flags,
-				     local->mdev->mc_count,
-				     local->mdev->mc_list);
-	netif_addr_unlock_bh(local->mdev);
+	if (!local->bg_scanning) {
+		netif_addr_lock_bh(local->mdev);
+		local->filter_flags |= FIF_BCN_PRBRESP_PROMISC;
+		local->ops->configure_filter(local_to_hw(local),
+					     FIF_BCN_PRBRESP_PROMISC,
+					     &local->filter_flags,
+					     local->mdev->mc_count,
+					     local->mdev->mc_list);
+		netif_addr_unlock_bh(local->mdev);
+	}
 
 	/* TODO: start scan as soon as all nullfunc frames are ACKed */
 	queue_delayed_work(local->hw.workqueue, &local->scan_work,
diff --git a/net/mac80211/wext.c b/net/mac80211/wext.c
index 7e0d53a..fd7783a 100644
--- a/net/mac80211/wext.c
+++ b/net/mac80211/wext.c
@@ -566,7 +566,7 @@ static int ieee80211_ioctl_giwscan(struct net_device *dev,
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (local->sw_scanning || local->hw_scanning)
+	if (local->sw_scanning || local->hw_scanning || local->bg_scanning)
 		return -EAGAIN;
 
 	res = ieee80211_scan_results(local, info, extra, data->length);
