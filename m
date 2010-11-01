Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26086 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab0KAM0A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:26:00 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcJ020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:23 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 07/15] cfg80211: add periodic scan results handler
Date: Mon,  1 Nov 2010 13:52:08 +0200
Message-Id: <1288612336-2830-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a function that the drivers need to call when they get scan results
during a periodic scan.  It will send signals to the userspace informing that
new scan results are available.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/cfg80211.h      |    7 +++++++
 include/net/mac80211.h      |   10 ++++++++++
 net/mac80211/driver-trace.h |   18 ++++++++++++++++++
 net/mac80211/ieee80211_i.h  |    2 ++
 net/mac80211/rx.c           |    4 +++-
 net/mac80211/scan.c         |   17 ++++++++++++++++-
 net/wireless/core.c         |    1 +
 net/wireless/core.h         |    2 ++
 net/wireless/scan.c         |   20 ++++++++++++++++++++
 9 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ac7b934..41e7dc4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2140,6 +2140,13 @@ int cfg80211_wext_siwpmksa(struct net_device *dev,
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted);
 
 /**
+ * cfg80211_periodic_results - notify that new scan results are available
+ *
+ * @request: the corresponding periodic scan request
+ */
+void cfg80211_periodic_results(struct cfg80211_periodic_request *req);
+
+/**
  * cfg80211_inform_bss_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 4ea2149..6b50780 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2322,6 +2322,16 @@ void ieee80211_wake_queues(struct ieee80211_hw *hw);
 void ieee80211_scan_completed(struct ieee80211_hw *hw, bool aborted);
 
 /**
+ * ieee80211_periodic_results - got results from periodic scan
+ *
+ * When a periodic scan is running, this function needs to be called by the
+ * driver whenever there are new scan results availble.
+ *
+ * @hw: the hardware that is performing periodic scans
+ */
+void ieee80211_periodic_results(struct ieee80211_hw *hw);
+
+/**
  * ieee80211_iterate_active_interfaces - iterate active interfaces
  *
  * This function iterates over the interfaces associated with a given
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index a09c17d..2acdc43 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -519,6 +519,24 @@ TRACE_EVENT(drv_sw_scan_complete,
 	)
 );
 
+TRACE_EVENT(drv_periodic_results,
+	TP_PROTO(struct ieee80211_local *local),
+
+	TP_ARGS(local),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT, LOCAL_PR_ARG
+	)
+);
+
 TRACE_EVENT(drv_get_stats,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_low_level_stats *stats,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 305bd57..c8846a4 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -648,6 +648,7 @@ enum queue_stop_reason {
  *	that the scan completed.
  * @SCAN_ABORTED: Set for our scan work function when the driver reported
  *	a scan complete for an aborted scan.
+ * @SCAN_PERIODIC_SCANNING: We're currently performing periodic scans
  */
 enum {
 	SCAN_SW_SCANNING,
@@ -655,6 +656,7 @@ enum {
 	SCAN_OFF_CHANNEL,
 	SCAN_COMPLETED,
 	SCAN_ABORTED,
+	SCAN_PERIODIC_SCANNING,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 902b03e..56db997 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -392,7 +392,8 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
 	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
 		return RX_CONTINUE;
 
-	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
+	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
+	    test_bit(SCAN_PERIODIC_SCANNING, &local->scanning))
 		return ieee80211_scan_rx(rx->sdata, skb);
 
 	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
@@ -2702,6 +2703,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 		local->dot11ReceivedFragmentCount++;
 
 	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
+		     test_bit(SCAN_PERIODIC_SCANNING, &local->scanning) ||
 		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
 		status->rx_flags |= IEEE80211_RX_IN_SCAN;
 
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index fa73abe..9273ab0 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -847,7 +847,9 @@ int ieee80211_request_periodic_start(struct ieee80211_sub_if_data *sdata,
 	local->periodic_req = req;
 
 	ret = drv_periodic_start(local, sdata);
-	if (ret)
+	if (!ret)
+		__set_bit(SCAN_PERIODIC_SCANNING, &local->scanning);
+	else
 		local->periodic_req = NULL;
 out:
 	mutex_unlock(&sdata->local->mtx);
@@ -870,6 +872,7 @@ int ieee80211_request_periodic_stop(struct ieee80211_sub_if_data *sdata)
 	if (local->periodic_req) {
 		ret = drv_periodic_stop(local, sdata);
 		local->periodic_req = NULL;
+		__clear_bit(SCAN_PERIODIC_SCANNING, &local->scanning);
 	}
 
 out:
@@ -877,3 +880,15 @@ out:
 
 	return ret;
 }
+
+void ieee80211_periodic_results(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	mutex_lock(&local->mtx);
+
+	cfg80211_periodic_results(local->periodic_req);
+
+	mutex_unlock(&local->mtx);
+}
+EXPORT_SYMBOL(ieee80211_periodic_results);
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9c21ebf..b90ae7c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -363,6 +363,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
+	INIT_WORK(&rdev->periodic_wk, __cfg80211_periodic_results);
 
 #ifdef CONFIG_CFG80211_WEXT
 	rdev->wiphy.wext = &cfg80211_wext_handler;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index bf4e348..de4578a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -63,6 +63,7 @@ struct cfg80211_registered_device {
 	struct cfg80211_periodic_request *periodic_req; /* protected by RTNL */
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
+	struct work_struct periodic_wk;
 
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
@@ -384,6 +385,7 @@ void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev, int idx);
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
+void __cfg80211_periodic_results(struct work_struct *wk);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 503ebb8..300876b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -93,6 +93,26 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
+void __cfg80211_periodic_results(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    periodic_wk);
+
+	cfg80211_lock_rdev(rdev);
+	nl80211_send_scan_done(rdev, rdev->periodic_req->dev);
+	cfg80211_unlock_rdev(rdev);
+}
+
+void cfg80211_periodic_results(struct cfg80211_periodic_request *req)
+{
+	WARN_ON(req != wiphy_to_dev(req->wiphy)->periodic_req);
+
+	queue_work(cfg80211_wq, &wiphy_to_dev(req->wiphy)->periodic_wk);
+}
+EXPORT_SYMBOL(cfg80211_periodic_results);
+
 static void bss_release(struct kref *ref)
 {
 	struct cfg80211_internal_bss *bss;
-- 
1.7.0.4

