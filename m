Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:56657 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760292AbcLPLWD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Dec 2016 06:22:03 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH] nl80211: rework {sched_,}scan event related functions
Date: Fri, 16 Dec 2016 11:21:54 +0000
Message-Id: <1481887314-9471-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161216_122206_791964_E9897EFE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A couple of functions used with scan events were named with
term "send" although they were only preparing the the event
message so renamed those.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 34 ++++++++--------------------------
 net/wireless/nl80211.h |  6 ++----
 net/wireless/scan.c    |  9 +++++----
 3 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 3df85a7..727ca50 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12810,7 +12810,7 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	return -ENOBUFS;
 }
 
-static int nl80211_send_scan_msg(struct sk_buff *msg,
+static int nl80211_prep_scan_msg(struct sk_buff *msg,
 				 struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
 				 u32 portid, u32 seq, int flags,
@@ -12841,7 +12841,7 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
 }
 
 static int
-nl80211_send_sched_scan_msg(struct sk_buff *msg,
+nl80211_prep_sched_scan_msg(struct sk_buff *msg,
 			    struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev,
 			    u32 portid, u32 seq, int flags, u32 cmd)
@@ -12873,7 +12873,7 @@ void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
+	if (nl80211_prep_scan_msg(msg, rdev, wdev, 0, 0, 0,
 				  NL80211_CMD_TRIGGER_SCAN) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -12892,7 +12892,7 @@ struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return NULL;
 
-	if (nl80211_send_scan_msg(msg, rdev, wdev, 0, 0, 0,
+	if (nl80211_prep_scan_msg(msg, rdev, wdev, 0, 0, 0,
 				  aborted ? NL80211_CMD_SCAN_ABORTED :
 					    NL80211_CMD_NEW_SCAN_RESULTS) < 0) {
 		nlmsg_free(msg);
@@ -12902,31 +12902,13 @@ struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
 	return msg;
 }
 
-void nl80211_send_scan_result(struct cfg80211_registered_device *rdev,
-			      struct sk_buff *msg)
-{
-	if (!msg)
-		return;
-
-	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
-				NL80211_MCGRP_SCAN, GFP_KERNEL);
-}
-
-void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
-				     struct net_device *netdev)
+/* send message created by nl80211_build_scan_msg() */
+void nl80211_send_scan_msg(struct cfg80211_registered_device *rdev,
+			   struct sk_buff *msg)
 {
-	struct sk_buff *msg;
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
-	if (nl80211_send_sched_scan_msg(msg, rdev, netdev, 0, 0, 0,
-					NL80211_CMD_SCHED_SCAN_RESULTS) < 0) {
-		nlmsg_free(msg);
-		return;
-	}
-
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
@@ -12940,7 +12922,7 @@ void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_send_sched_scan_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
+	if (nl80211_prep_sched_scan_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 7e3821d..75f8252 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -14,12 +14,10 @@ void nl80211_send_scan_start(struct cfg80211_registered_device *rdev,
 			     struct wireless_dev *wdev);
 struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
 				       struct wireless_dev *wdev, bool aborted);
-void nl80211_send_scan_result(struct cfg80211_registered_device *rdev,
-			      struct sk_buff *msg);
+void nl80211_send_scan_msg(struct cfg80211_registered_device *rdev,
+			   struct sk_buff *msg);
 void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd);
-void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
-				     struct net_device *netdev);
 void nl80211_common_reg_change_event(enum nl80211_commands cmd_id,
 				     struct regulatory_request *request);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index b5bd58d..76cdd1d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -176,7 +176,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 	ASSERT_RTNL();
 
 	if (rdev->scan_msg) {
-		nl80211_send_scan_result(rdev, rdev->scan_msg);
+		nl80211_send_scan_msg(rdev, rdev->scan_msg);
 		rdev->scan_msg = NULL;
 		return;
 	}
@@ -222,7 +222,7 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 	if (!send_message)
 		rdev->scan_msg = msg;
 	else
-		nl80211_send_scan_result(rdev, msg);
+		nl80211_send_scan_msg(rdev, msg);
 }
 
 void __cfg80211_scan_done(struct work_struct *wk)
@@ -270,7 +270,8 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 			spin_unlock_bh(&rdev->bss_lock);
 			request->scan_start = jiffies;
 		}
-		nl80211_send_sched_scan_results(rdev, request->dev);
+		nl80211_send_sched_scan(rdev, request->dev,
+					NL80211_CMD_SCHED_SCAN_RESULTS);
 	}
 
 	rtnl_unlock();
@@ -1078,7 +1079,7 @@ struct cfg80211_bss *
 	else
 		rcu_assign_pointer(tmp.pub.beacon_ies, ies);
 	rcu_assign_pointer(tmp.pub.ies, ies);
-	
+
 	memcpy(tmp.pub.bssid, mgmt->bssid, ETH_ALEN);
 	tmp.pub.channel = channel;
 	tmp.pub.scan_width = data->scan_width;
-- 
1.9.1
