Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:59595 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752547AbdDMMHF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 08:07:05 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V2 01/10] nl80211: add request id in scheduled scan event messages
Date: Thu, 13 Apr 2017 13:06:27 +0100
Message-Id: <1492085196-4574-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170413_140724_747022_27A2CF28)
In-Reply-To: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1492085196-4574-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For multi-scheduled scan support in subsequent patch a request id
will be added. This patch add this request id to the scheduled
scan event messages. For now the request id will always be zero.
With multi-scheduled scan its value will inform user-space to which
scan the event relates.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h |  2 ++
 net/wireless/nl80211.c | 23 +++++++++++------------
 net/wireless/nl80211.h |  3 +--
 net/wireless/scan.c    |  5 ++---
 4 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 89fa499..2a200b9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1649,6 +1649,7 @@ struct cfg80211_bss_select_adjust {
 /**
  * struct cfg80211_sched_scan_request - scheduled scan request description
  *
+ * @reqid: identifies this request.
  * @ssids: SSIDs to scan for (passed in the probe_reqs in active scans)
  * @n_ssids: number of SSIDs
  * @n_channels: total number of channels to scan
@@ -1693,6 +1694,7 @@ struct cfg80211_bss_select_adjust {
  *	comparisions.
  */
 struct cfg80211_sched_scan_request {
+	u64 reqid;
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
 	u32 n_channels;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 671b635..a047992 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7371,8 +7371,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);
 
-	nl80211_send_sched_scan(rdev, dev,
-				NL80211_CMD_START_SCHED_SCAN);
+	nl80211_send_sched_scan(sched_scan_req, NL80211_CMD_START_SCHED_SCAN);
 	return 0;
 
 out_free:
@@ -13219,18 +13218,19 @@ static int nl80211_prep_scan_msg(struct sk_buff *msg,
 
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
@@ -13290,8 +13290,7 @@ void nl80211_send_scan_msg(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }
 
-void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
-			     struct net_device *netdev, u32 cmd)
+void nl80211_send_sched_scan(struct cfg80211_sched_scan_request *req, u32 cmd)
 {
 	struct sk_buff *msg;
 
@@ -13299,12 +13298,12 @@ void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
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
index 3cb17cd..d5f6860 100644
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
index 21be56b..6f4996c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -321,8 +321,7 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 			spin_unlock_bh(&rdev->bss_lock);
 			request->scan_start = jiffies;
 		}
-		nl80211_send_sched_scan(rdev, request->dev,
-					NL80211_CMD_SCHED_SCAN_RESULTS);
+		nl80211_send_sched_scan(request, NL80211_CMD_SCHED_SCAN_RESULTS);
 	}
 
 	rtnl_unlock();
@@ -379,7 +378,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
+	nl80211_send_sched_scan(sched_scan_req, NL80211_CMD_SCHED_SCAN_STOPPED);
 
 	RCU_INIT_POINTER(rdev->sched_scan_req, NULL);
 	kfree_rcu(sched_scan_req, rcu_head);
-- 
1.9.1
