Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26102 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcK020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:24 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 08/15] nl80211: report periodic scan results
Date: Mon,  1 Nov 2010 13:52:09 +0200
Message-Id: <1288612336-2830-9-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add code to report periodic scan results whenever they are available.  This
adds NL80211_CMD_PERIODIC_RESULTS to the API.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/linux/nl80211.h |    2 ++
 net/wireless/nl80211.c  |   19 +++++++++++++++++++
 net/wireless/nl80211.h  |    2 ++
 net/wireless/scan.c     |    2 +-
 4 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index b3d1306..3206b8f 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -201,6 +201,7 @@
  *
  * @NL80211_CMD_START_PERIODIC_SCAN: start a periodic scan
  * @NL80211_CMD_STOP_PERIODIC_SCAN: stop a periodic scan
+ * @NL80211_CMD_PERIODIC_RESULTS: there are periodic scan results available.
  *
  * @NL80211_CMD_GET_SURVEY: get survey resuls, e.g. channel occupation
  *      or noise level
@@ -448,6 +449,7 @@ enum nl80211_commands {
 
 	NL80211_CMD_START_PERIODIC_SCAN,
 	NL80211_CMD_STOP_PERIODIC_SCAN,
+	NL80211_CMD_PERIODIC_RESULTS,
 
 	NL80211_CMD_REG_CHANGE,
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fd50186..e1d7ab2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5151,6 +5151,25 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
+void nl80211_send_periodic_results(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev)
+{
+	struct sk_buff *msg;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	if (nl80211_send_periodic_msg(msg, rdev, netdev, 0, 0, 0,
+				      NL80211_CMD_PERIODIC_RESULTS) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
+}
+
 void nl80211_send_periodic(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev, u32 cmd)
 {
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 435d452..586fd1f 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -14,6 +14,8 @@ void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev);
 void nl80211_send_periodic(struct cfg80211_registered_device *rdev,
 			   struct net_device *netdev, u32 cmd);
+void nl80211_send_periodic_results(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev);
 void nl80211_send_reg_change_event(struct regulatory_request *request);
 void nl80211_send_rx_auth(struct cfg80211_registered_device *rdev,
 			  struct net_device *netdev,
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 300876b..925bdfb 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -101,7 +101,7 @@ void __cfg80211_periodic_results(struct work_struct *wk)
 			    periodic_wk);
 
 	cfg80211_lock_rdev(rdev);
-	nl80211_send_scan_done(rdev, rdev->periodic_req->dev);
+	nl80211_send_periodic_results(rdev, rdev->periodic_req->dev);
 	cfg80211_unlock_rdev(rdev);
 }
 
-- 
1.7.0.4

