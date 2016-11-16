Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f74.google.com ([74.125.83.74]:36666 "EHLO
        mail-pg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422751AbcKPWwY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 17:52:24 -0500
Received: by mail-pg0-f74.google.com with SMTP id g186so6773963pgc.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2016 14:52:24 -0800 (PST)
MIME-Version: 1.0
Message-ID: <94eb2c110db85c2379054172dad0@google.com> (sfid-20161116_235236_736106_A8DBAB02)
Date: Wed, 16 Nov 2016 22:47:09 +0000
Subject: [PATCH] RFC: Universal scan proposal
From: dimitrysh@google.com
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 From 68a9d37a4c7e9dc7a90a6e922cdea52737a98d66 Mon Sep 17 00:00:00 2001
From: Dmitry Shmidt <dimitrysh@google.com>
Date: Wed, 16 Nov 2016 14:27:26 -0800
Subject: [PATCH] RFC: Universal scan proposal

   Currently we have sched scan with possibility of various
intervals. We would like to extend it to support also
different types of scan.
   In case of powerful wlan CPU, all this functionality
can be offloaded.
   In general case FW processes additional scan requests
and puts them into queue based on start time and interval.
Once current request is fulfilled, FW adds it (if interval != 0)
again to the queue with proper interval. If requests are
overlapping, new request can be combined with either one before,
or one after, assuming that requests are not mutually exclusive.
   Combining requests is done by combining scan channels, ssids,
bssids and types of scan result. Once combined request was fulfilled
it will be reinserted as two (or three) different requests based on
their type and interval.
   Each request has attribute:
Type: connectivity / location
Report: none / batch / immediate
   Request may have priority and can be inserted into
the head of the queue.
   Types of scans:
- Normal scan
- Scheduled scan
- Hotlist (BSSID scan)
- Roaming
- AutoJoin

Change-Id: I9f3e4c975784f1c1c5156887144d80fc5a26bffa
Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
---
  include/net/cfg80211.h | 37 +++++++++++++++++++++++++++++++------
  1 file changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 14b51d7..1ae2570 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1602,8 +1602,10 @@ struct cfg80211_sched_scan_plan {
   *	cycle.  The driver may ignore this parameter and start
   *	immediately (or at any other time), if this feature is not
   *	supported.
+ * @uscan_type: uscan type (scan, sched_scan, hotlist, scan_history,  
roaming)
+ * @uscan_results: uscan results report (none/batch/immediate)
   */
-struct cfg80211_sched_scan_request {
+struct cfg80211_uscan_request {
  	struct cfg80211_ssid *ssids;
  	int n_ssids;
  	u32 n_channels;
@@ -1621,6 +1623,10 @@ struct cfg80211_sched_scan_request {
  	u8 mac_addr[ETH_ALEN] __aligned(2);
  	u8 mac_addr_mask[ETH_ALEN] __aligned(2);

+	/* universal scan fields */
+	u32 uscan_type;
+	u32 uscan_results;
+
  	/* internal */
  	struct wiphy *wiphy;
  	struct net_device *dev;
@@ -1633,6 +1639,21 @@ struct cfg80211_sched_scan_request {
  };

  /**
+ * struct cfg80211_uscan_capa - universal scan capabilities
+ *
+ * @uscan_type: uscan type (scan, sched_scan, hotlist, scan_history,  
roaming)
+ * @max_ssids: max amount of ssids in sched scan
+ * @max_hotlist: max amount of bssids in hotlist
+ * @max_history: max amount of records in history
+ */
+struct cfg80211_uscan_capa {
+	u32 uscan_type;
+	u32 max_ssids;
+	u32 max_hotlist;
+	u32 max_history;
+};
+
+/**
   * enum cfg80211_signal_type - signal type
   *
   * @CFG80211_SIGNAL_TYPE_NONE: no signal strength information available
@@ -2898,10 +2919,13 @@ struct cfg80211_ops {
  	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
  	int	(*get_antenna)(struct wiphy *wiphy, u32 *tx_ant, u32 *rx_ant);

-	int	(*sched_scan_start)(struct wiphy *wiphy,
+	int	(*uscan_get_capa)(struct wiphy *wiphy, struct net_device *dev,
+				struct cfg80211_uscan_capa *uscan_capa);
+	int	(*uscan_start)(struct wiphy *wiphy,
  				struct net_device *dev,
-				struct cfg80211_sched_scan_request *request);
-	int	(*sched_scan_stop)(struct wiphy *wiphy, struct net_device *dev);
+				struct cfg80211_uscan_request *request);
+	int	(*uscan_stop)(struct wiphy *wiphy, struct net_device *dev,
+				int uscan_id);

  	int	(*set_rekey_data)(struct wiphy *wiphy, struct net_device *dev,
  				  struct cfg80211_gtk_rekey_data *data);
@@ -4305,11 +4329,12 @@ void cfg80211_scan_done(struct  
cfg80211_scan_request *request,
  			struct cfg80211_scan_info *info);

  /**
- * cfg80211_sched_scan_results - notify that new scan results are available
+ * cfg80211_uscan_results - notify that new uscan results are available
   *
   * @wiphy: the wiphy which got scheduled scan results
+ * @uscan_id: type of scan results
   */
-void cfg80211_sched_scan_results(struct wiphy *wiphy);
+void cfg80211_sched_scan_results(struct wiphy *wiphy, int uscan_id);

  /**
   * cfg80211_sched_scan_stopped - notify that the scheduled scan has stopped
-- 
2.8.0.rc3.226.g39d4020
