Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:54956 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933454AbaD3NOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 09:14:34 -0400
Received: by mail-wg0-f48.google.com with SMTP id b13so1694085wgh.7
        for <linux-wireless@vger.kernel.org>; Wed, 30 Apr 2014 06:14:33 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: add cfg80211_sched_scan_stopped_rtnl
Date: Wed, 30 Apr 2014 16:14:23 +0300
Message-Id: <1398863664-20193-1-git-send-email-eliad@wizery.com> (sfid-20140430_151437_712887_088DC0FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add locked-version for cfg80211_sched_scan_stopped.
This is used for some users that might want to
call it when rtnl is already locked.

Fixes: d43c6b6 ("mac80211: reschedule sched scan after HW restart")
Cc: stable@vger.kernel.org (3.14+)
Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
---
 include/net/cfg80211.h | 12 ++++++++++++
 net/wireless/scan.c    | 13 +++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7eae46c..f2c3186 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3692,6 +3692,18 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy);
 void cfg80211_sched_scan_stopped(struct wiphy *wiphy);
 
 /**
+ * cfg80211_sched_scan_stopped_rtnl - notify that the scheduled scan has stopped
+ *
+ * @wiphy: the wiphy on which the scheduled scan stopped
+ *
+ * The driver can call this function to inform cfg80211 that the
+ * scheduled scan had to be stopped, for whatever reason.  The driver
+ * is then called back via the sched_scan_stop operation when done.
+ * This function should be called with rtnl locked.
+ */
+void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy);
+
+/**
  * cfg80211_inform_bss_width_frame - inform cfg80211 of a received BSS frame
  *
  * @wiphy: the wiphy reporting the BSS
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0f5da18..c0abd75 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -284,18 +284,27 @@ void cfg80211_sched_scan_results(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_results);
 
-void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
+void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
+	ASSERT_RTNL();
+
 	trace_cfg80211_sched_scan_stopped(wiphy);
 
-	rtnl_lock();
 	__cfg80211_stop_sched_scan(rdev, true);
+}
+EXPORT_SYMBOL(cfg80211_sched_scan_stopped_rtnl);
+
+void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
+{
+	rtnl_lock();
+	cfg80211_sched_scan_stopped_rtnl(wiphy);
 	rtnl_unlock();
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
+
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
-- 
1.8.5.2.229.g4448466.dirty

