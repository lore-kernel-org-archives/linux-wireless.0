Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:60076 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751708AbdAMMr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:47:57 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC 2/5] nl80211: include request id in scheduled scan event messages
Date: Fri, 13 Jan 2017 12:47:41 +0000
Message-Id: <1484311664-4840-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170113_134900_374091_924A90C0)
In-Reply-To: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include the request id in the event messages so user-space knows
which scan the event relates to.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 23 +++++++++++------------
 net/wireless/nl80211.h |  3 +--
 net/wireless/scan.c    |  5 ++---
 3 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4d1070a..a0cd0e2 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7218,8 +7218,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	cfg80211_add_sched_scan_req(rdev, sched_scan_req);
 
-	nl80211_send_sched_scan(rdev, dev,
-				NL80211_CMD_START_SCHED_SCAN);
+	nl80211_send_sched_scan(sched_scan_req, NL80211_CMD_START_SCHED_SCAN);
 	return 0;
 
 out_free:
@@ -12887,18 +12886,19 @@ static int nl80211_prep_scan_msg(struct sk_buff *msg,
 
 static int
 nl80211_prep_sched_scan_msg(struct sk_buff *msg,
-			    struct cfg80211_registered_device *rdev,
-			    struct net_device *netdev,
-			    u32 portid, u32 seq, int flags, u32 cmd)
+			    struct cfg80211_sched_scan_request *req, u32 cmd)
 {
 	void *hdr;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
+	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
 	if (!hdr)
 		return -1;
 
-	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY,
+			wiphy_to_rdev(req->wiphy)->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, req->dev->ifindex) ||
+	    nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, req->reqid,
+			      NL80211_ATTR_PAD))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
@@ -12958,8 +12958,7 @@ void nl80211_send_scan_msg(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
 
-void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev, u32 cmd)
+void nl80211_send_sched_scan(struct cfg80211_sched_scan_request *req, u32 cmd)
 {
 	struct sk_buff *msg;
 
@@ -12967,12 +12966,12 @@ void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;
 
-	if (nl80211_prep_sched_scan_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
+	if (nl80211_prep_sched_scan_msg(msg, req, cmd) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
 
-	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(req->wiphy), msg, 0,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
 
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 75f8252..33d4a0a 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -16,8 +16,7 @@ struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
 				       struct wireless_dev *wdev, bool aborted);
 void nl80211_send_scan_msg(struct cfg80211_registered_device *rdev,
 			   struct sk_buff *msg);
-void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev, u32 cmd);
+void nl80211_send_sched_scan(struct cfg80211_sched_scan_request *req, u32 cmd);
 void nl80211_common_reg_change_event(enum nl80211_commands cmd_id,
 				     struct regulatory_request *request);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 6704198..f2b2064 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -379,8 +379,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 			spin_unlock_bh(&rdev->bss_lock);
 			request->scan_start = jiffies;
 		}
-		nl80211_send_sched_scan(rdev, request->dev,
-					NL80211_CMD_SCHED_SCAN_RESULTS);
+		nl80211_send_sched_scan(request, NL80211_CMD_SCHED_SCAN_RESULTS);
 	}
 
 	rtnl_unlock();
@@ -429,7 +428,7 @@ int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	nl80211_send_sched_scan(rdev, req->dev, NL80211_CMD_SCHED_SCAN_STOPPED);
+	nl80211_send_sched_scan(req, NL80211_CMD_SCHED_SCAN_STOPPED);
 
 	cfg80211_del_sched_scan_req(rdev, req);
 
-- 
1.9.1
