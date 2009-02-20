Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39889 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751424AbZBTOln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 09:41:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Add software scan notifiers
Date: Fri, 20 Feb 2009 15:37:03 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902201537.03643.mb@bu3sch.de> (sfid-20090220_154148_682446_12DFB8F8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds optional notifier functions for software scan.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next feature release.


Index: wireless-testing/include/net/mac80211.h
===================================================================
--- wireless-testing.orig/include/net/mac80211.h	2009-02-19 22:20:25.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-02-20 15:20:35.000000000 +0100
@@ -1321,12 +1321,18 @@ enum ieee80211_ampdu_mlme_action {
  *	configuration done by the regulatory agent in the wiphy's registered
  *	bands. When the scan finishes, ieee80211_scan_completed() must be
  *	called; note that it also must be called when the scan cannot finish
  *	because the hardware is turned off! Anything else is a bug!
  *	Returns a negative error code which will be seen in userspace.
  *
+ * @sw_scan_start: Notifier function that is called just before a software scan
+ *	is started. Can be NULL, if the driver doesn't need this notification.
+ *
+ * @sw_scan_complete: Notifier function that is called just after a software scan
+ *	finished. Can be NULL, if the driver doesn't need this notification.
+ *
  * @get_stats: Return low-level statistics.
  * 	Returns zero if statistics are available.
  *
  * @get_tkip_seq: If your device implements TKIP encryption in hardware this
  *	callback should be provided to read the TKIP transmit IVs (both IV32
  *	and IV16) for the given key from hardware.
@@ -1400,12 +1406,14 @@ struct ieee80211_ops {
 		       struct ieee80211_key_conf *key);
 	void (*update_tkip_key)(struct ieee80211_hw *hw,
 			struct ieee80211_key_conf *conf, const u8 *address,
 			u32 iv32, u16 *phase1key);
 	int (*hw_scan)(struct ieee80211_hw *hw,
 		       struct cfg80211_scan_request *req);
+	void (*sw_scan_start)(struct ieee80211_hw *hw);
+	void (*sw_scan_complete)(struct ieee80211_hw *hw);
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
 	void (*get_tkip_seq)(struct ieee80211_hw *hw, u8 hw_key_idx,
 			     u32 *iv32, u16 *iv16);
 	int (*set_rts_threshold)(struct ieee80211_hw *hw, u32 value);
 	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
Index: wireless-testing/net/mac80211/scan.c
===================================================================
--- wireless-testing.orig/net/mac80211/scan.c	2009-02-19 22:20:25.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-02-20 15:19:21.000000000 +0100
@@ -242,12 +242,15 @@ void ieee80211_scan_completed(struct iee
 				     local->mdev->mc_count,
 				     local->mdev->mc_list);
 
 	netif_addr_unlock(local->mdev);
 	netif_tx_unlock_bh(local->mdev);
 
+	if (local->ops->sw_scan_complete)
+		local->ops->sw_scan_complete(local_to_hw(local));
+
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
 
 		/* Tell AP we're back */
@@ -392,12 +395,14 @@ int ieee80211_start_scan(struct ieee8021
 		}
 		local->scan_sdata = scan_sdata;
 		return 0;
 	}
 
 	local->sw_scanning = true;
+	if (local->ops->sw_scan_start)
+		local->ops->sw_scan_start(local_to_hw(local));
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		if (!netif_running(sdata->dev))
 			continue;
 

-- 
Greetings, Michael.
