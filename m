Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3J1OI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:08:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] nl80211: check nla_put_* return values
Date: Mon, 28 Oct 2013 15:08:21 +0100
Message-Id: <1382969304-25611-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150831_591764_43492672)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Coverity pointed out that in a few functions we don't
check the return value of the nla_put_*() calls. Most
of these are fairly harmless because the input isn't
very dynamic and controlled by the kernel, but the
pattern is simply wrong, so fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 52 +++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8ced6bc..1fef427 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9633,8 +9633,9 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	    nla_put(msg, NL80211_ATTR_IE, req->ie_len, req->ie))
 		goto nla_put_failure;
 
-	if (req->flags)
-		nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);
+	if (req->flags &&
+	    nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags))
+		goto nla_put_failure;
 
 	return 0;
  nla_put_failure:
@@ -11118,16 +11119,18 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
 				wakeup->pattern_idx))
 			goto free_msg;
 
-		if (wakeup->tcp_match)
-			nla_put_flag(msg, NL80211_WOWLAN_TRIG_WAKEUP_TCP_MATCH);
+		if (wakeup->tcp_match &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_WAKEUP_TCP_MATCH))
+			goto free_msg;
 
-		if (wakeup->tcp_connlost)
-			nla_put_flag(msg,
-				     NL80211_WOWLAN_TRIG_WAKEUP_TCP_CONNLOST);
+		if (wakeup->tcp_connlost &&
+		    nla_put_flag(msg, NL80211_WOWLAN_TRIG_WAKEUP_TCP_CONNLOST))
+			goto free_msg;
 
-		if (wakeup->tcp_nomoretokens)
-			nla_put_flag(msg,
-				NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS);
+		if (wakeup->tcp_nomoretokens &&
+		    nla_put_flag(msg,
+				 NL80211_WOWLAN_TRIG_WAKEUP_TCP_NOMORETOKENS))
+			goto free_msg;
 
 		if (wakeup->packet) {
 			u32 pkt_attr = NL80211_WOWLAN_TRIG_WAKEUP_PKT_80211;
@@ -11263,24 +11266,29 @@ void cfg80211_ft_event(struct net_device *netdev,
 		return;
 
 	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FT_EVENT);
-	if (!hdr) {
-		nlmsg_free(msg);
-		return;
-	}
+	if (!hdr)
+		goto out;
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, ft_event->target_ap))
+		goto out;
 
-	nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
-	nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
-	nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, ft_event->target_ap);
-	if (ft_event->ies)
-		nla_put(msg, NL80211_ATTR_IE, ft_event->ies_len, ft_event->ies);
-	if (ft_event->ric_ies)
-		nla_put(msg, NL80211_ATTR_IE_RIC, ft_event->ric_ies_len,
-			ft_event->ric_ies);
+	if (ft_event->ies &&
+	    nla_put(msg, NL80211_ATTR_IE, ft_event->ies_len, ft_event->ies))
+		goto out;
+	if (ft_event->ric_ies &&
+	    nla_put(msg, NL80211_ATTR_IE_RIC, ft_event->ric_ies_len,
+		    ft_event->ric_ies))
+		goto out;
 
 	genlmsg_end(msg, hdr);
 
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
 				nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	return;
+ out:
+	nlmsg_free(msg);
 }
 EXPORT_SYMBOL(cfg80211_ft_event);
 
-- 
1.8.4.rc3

