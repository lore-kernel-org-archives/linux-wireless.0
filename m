Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:38293 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753058AbcKQLkE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 06:40:04 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/5] nl80211: add driver api for gscan notifications
Date: Thu, 17 Nov 2016 11:39:52 +0000
Message-Id: <1479382792-13131-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_124008_082949_EC363510)
In-Reply-To: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479382792-13131-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver can indicate gscan results are available or gscan operation
has stopped.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       | 28 ++++++++++++++++++++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/core.c          |  2 ++
 net/wireless/core.h          |  2 ++
 net/wireless/nl80211.c       | 19 ++++++++++++++
 net/wireless/nl80211.h       |  2 ++
 net/wireless/scan.c          | 61 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 10 ++++++++
 8 files changed, 126 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b4b0536..d85a439 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4570,6 +4570,34 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
 void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy);
 
 /**
+ * cfg80211_gscan_results - notify that new scan results are available
+ *
+ * @wiphy: the wiphy which got GScan results
+ */
+void cfg80211_gscan_results(struct wiphy *wiphy);
+
+/**
+ * cfg80211_gscan_stopped - notify that the GScan has stopped
+ *
+ * @wiphy: the wiphy on which the GScan stopped.
+ *
+ * The driver can call this function to inform cfg80211 that the
+ * GScan had to be stopped, for whatever reason.
+ */
+void cfg80211_gscan_stopped(struct wiphy *wiphy);
+
+/**
+ * cfg80211_gscan_stopped_rtnl - notify that the GScan has stopped
+ *
+ * @wiphy: the wiphy on which the GScan stopped.
+ *
+ * The driver can call this function to inform cfg80211 that the
+ * GScan had to be stopped, for whatever reason.
+ * This function should be called with rtnl locked.
+ */
+void cfg80211_gscan_stopped_rtnl(struct wiphy *wiphy);
+
+/**
  * cfg80211_inform_bss_frame_data - inform cfg80211 of a received BSS frame
  * @wiphy: the wiphy reporting the BSS
  * @data: the BSS metadata
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 8071dae..c4c9005 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -896,6 +896,7 @@
  *
  * @NL80211_CMD_START_GSCAN: start GScan.
  * @NL80211_CMD_STOP_GSCAN: request to stop current GScan.
+ * @NL80211_CMD_GSCAN_RESULTS: indicates that there GScan results available.
  * @NL80211_CMD_GSCAN_STOPPED: indicates that the currently running GScan
  *	has stopped. This event is generated upon @NL80211_CMD_STOP_GSCAN and
  *	the driver may issue this event at any time when a GScan is running.
@@ -1101,6 +1102,7 @@ enum nl80211_commands {
 
 	NL80211_CMD_START_GSCAN,
 	NL80211_CMD_STOP_GSCAN,
+	NL80211_CMD_GSCAN_RESULTS,
 	NL80211_CMD_GSCAN_STOPPED,
 
 	/* add new commands above here */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 760a2fb..69eea4c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -453,6 +453,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	INIT_LIST_HEAD(&rdev->bss_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
+	INIT_WORK(&rdev->gscan_results_wk, __cfg80211_gscan_results);
 	INIT_LIST_HEAD(&rdev->mlme_unreg);
 	spin_lock_init(&rdev->mlme_unreg_lock);
 	INIT_WORK(&rdev->mlme_unreg_wk, cfg80211_mlme_unreg_wk);
@@ -935,6 +936,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 	flush_work(&rdev->destroy_work);
 	flush_work(&rdev->sched_scan_stop_wk);
+	flush_work(&rdev->gscan_stop_wk);
 	flush_work(&rdev->mlme_unreg_wk);
 
 #ifdef CONFIG_PM
diff --git a/net/wireless/core.h b/net/wireless/core.h
index b0f2519..1d56ef4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -78,6 +78,7 @@ struct cfg80211_registered_device {
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
+	struct work_struct gscan_results_wk;
 
 	struct genl_info *cur_cmd_info;
 
@@ -423,6 +424,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 void __cfg80211_sched_scan_results(struct work_struct *wk);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated);
+void __cfg80211_gscan_results(struct work_struct *wk);
 int __cfg80211_stop_gscan(struct cfg80211_registered_device *rdev,
 			  bool driver_initiated);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b22310..f0099ee 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13304,6 +13304,25 @@ void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
 
+void nl80211_send_gscan_results(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_scan_event_msg(msg, rdev, netdev, 0, 0, 0,
+					NL80211_CMD_GSCAN_RESULTS) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_SCAN, GFP_KERNEL);
+}
+
 void nl80211_send_scan_event(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd)
 {
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index fb304ce9..4eec856 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -20,6 +20,8 @@ void nl80211_send_scan_event(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd);
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev);
+void nl80211_send_gscan_results(struct cfg80211_registered_device *rdev,
+				     struct net_device *netdev);
 void nl80211_common_reg_change_event(enum nl80211_commands cmd_id,
 				     struct regulatory_request *request);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 327b23c..f34d5d4 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -287,6 +287,47 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
+void __cfg80211_gscan_results(struct work_struct *wk)
+{
+	struct cfg80211_registered_device *rdev;
+	struct cfg80211_gscan_request *request;
+
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    gscan_results_wk);
+
+	rtnl_lock();
+
+	request = rtnl_dereference(rdev->gscan_req);
+
+	/* we don't have sched_scan_req anymore if the scan is stopping */
+	if (request) {
+#if 0
+		/* TODO: how to deal with flush */
+		if (request->flags & NL80211_SCAN_FLAG_FLUSH) {
+			/* flush entries from previous scans */
+			spin_lock_bh(&rdev->bss_lock);
+			__cfg80211_bss_expire(rdev, request->scan_start);
+			spin_unlock_bh(&rdev->bss_lock);
+			request->scan_start = jiffies;
+		}
+#endif
+		nl80211_send_gscan_results(rdev, request->dev);
+	}
+
+	rtnl_unlock();
+}
+
+void cfg80211_gscan_results(struct wiphy *wiphy)
+{
+	trace_cfg80211_gscan_results(wiphy);
+	/* ignore if we're not scanning */
+
+	if (rcu_access_pointer(wiphy_to_rdev(wiphy)->gscan_req))
+		queue_work(cfg80211_wq,
+			   &wiphy_to_rdev(wiphy)->gscan_results_wk);
+}
+EXPORT_SYMBOL(cfg80211_gscan_results);
+
 void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
@@ -307,6 +348,26 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
+void cfg80211_gscan_stopped_rtnl(struct wiphy *wiphy)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
+
+	ASSERT_RTNL();
+
+	trace_cfg80211_gscan_stopped(wiphy);
+
+	__cfg80211_stop_gscan(rdev, true);
+}
+EXPORT_SYMBOL(cfg80211_gscan_stopped_rtnl);
+
+void cfg80211_gscan_stopped(struct wiphy *wiphy)
+{
+	rtnl_lock();
+	cfg80211_gscan_stopped_rtnl(wiphy);
+	rtnl_unlock();
+}
+EXPORT_SYMBOL(cfg80211_gscan_stopped);
+
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 1d0fde9..f3f5d82 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2799,6 +2799,16 @@
 	TP_ARGS(wiphy)
 );
 
+DEFINE_EVENT(wiphy_only_evt, cfg80211_gscan_results,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
+DEFINE_EVENT(wiphy_only_evt, cfg80211_gscan_stopped,
+	TP_PROTO(struct wiphy *wiphy),
+	TP_ARGS(wiphy)
+);
+
 TRACE_EVENT(cfg80211_get_bss,
 	TP_PROTO(struct wiphy *wiphy, struct ieee80211_channel *channel,
 		 const u8 *bssid, const u8 *ssid, size_t ssid_len,
-- 
1.9.1
