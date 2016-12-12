Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54807 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbcLLMAS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:18 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 02/11] nl80211: rename some notification functions
Date: Mon, 12 Dec 2016 11:59:48 +0000
Message-Id: <1481543997-24624-3-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130931_185177_F9BD72F9)
In-Reply-To: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The functions nl80211_send_sched_scan() and nl80211_send_sched_scan_msg()
take command as parameter, which strictly speaking makes them general
purpose and not directly related to scheduled scan functionality. The
message are sent to "scan" multicast group so renaming them to
nl80211_send_scan_event{,_msg}().

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 10 +++++-----
 net/wireless/nl80211.h |  2 +-
 net/wireless/scan.c    |  4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 40209ec..14e1940 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7247,7 +7247,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,

 	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);

-	nl80211_send_sched_scan(rdev, dev,
+	nl80211_send_scan_event(rdev, dev,
 				NL80211_CMD_START_SCHED_SCAN);
 	return 0;

@@ -12878,7 +12878,7 @@ static int nl80211_send_scan_msg(struct sk_buff *msg,
 }

 static int
-nl80211_send_sched_scan_msg(struct sk_buff *msg,
+nl80211_send_scan_event_msg(struct sk_buff *msg,
 			    struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev,
 			    u32 portid, u32 seq, int flags, u32 cmd)
@@ -12958,7 +12958,7 @@ void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;

-	if (nl80211_send_sched_scan_msg(msg, rdev, netdev, 0, 0, 0,
+	if (nl80211_send_scan_event_msg(msg, rdev, netdev, 0, 0, 0,
 					NL80211_CMD_SCHED_SCAN_RESULTS) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -12968,7 +12968,7 @@ void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 				NL80211_MCGRP_SCAN, GFP_KERNEL);
 }

-void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
+void nl80211_send_scan_event(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd)
 {
 	struct sk_buff *msg;
@@ -12977,7 +12977,7 @@ void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
 	if (!msg)
 		return;

-	if (nl80211_send_sched_scan_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
+	if (nl80211_send_scan_event_msg(msg, rdev, netdev, 0, 0, 0, cmd) < 0) {
 		nlmsg_free(msg);
 		return;
 	}
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 7e3821d..fb304ce9 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -16,7 +16,7 @@ struct sk_buff *nl80211_build_scan_msg(struct cfg80211_registered_device *rdev,
 				       struct wireless_dev *wdev, bool aborted);
 void nl80211_send_scan_result(struct cfg80211_registered_device *rdev,
 			      struct sk_buff *msg);
-void nl80211_send_sched_scan(struct cfg80211_registered_device *rdev,
+void nl80211_send_scan_event(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, u32 cmd);
 void nl80211_send_sched_scan_results(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev);
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 35ad69f..174076b 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -378,7 +378,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			return err;
 	}

-	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
+	nl80211_send_scan_event(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);

 	RCU_INIT_POINTER(rdev->sched_scan_req, NULL);
 	kfree_rcu(sched_scan_req, rcu_head);
@@ -1147,7 +1147,7 @@ struct cfg80211_bss *
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
