Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42776 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759582AbcINIMC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 04:12:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/5] nl80211: always check nla_nest_start() return value
Date: Wed, 14 Sep 2016 10:11:54 +0200
Message-Id: <1473840718-5605-1-git-send-email-johannes@sipsolutions.net> (sfid-20160914_101209_663324_D4B650AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If the message got full during nla_nest_start(), it can return
NULL. None of the cases here seem like that can really happen,
but check the return value nonetheless.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dc81c5b91f61..4c8cc743ae7d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8013,6 +8013,8 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 	}
 
 	data = nla_nest_start(skb, attr);
+	if (!data)
+		goto nla_put_failure;
 
 	((void **)skb->cb)[0] = rdev;
 	((void **)skb->cb)[1] = hdr;
@@ -9449,8 +9451,14 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 
 	if (req->n_match_sets) {
 		matches = nla_nest_start(msg, NL80211_ATTR_SCHED_SCAN_MATCH);
+		if (!matches)
+			return -ENOBUFS;
+
 		for (i = 0; i < req->n_match_sets; i++) {
 			match = nla_nest_start(msg, i);
+			if (!match)
+				return -ENOBUFS;
+
 			nla_put(msg, NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
 				req->match_sets[i].ssid.ssid_len,
 				req->match_sets[i].ssid.ssid);
@@ -9465,6 +9473,9 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 
 	for (i = 0; i < req->n_scan_plans; i++) {
 		scan_plan = nla_nest_start(msg, i + 1);
+		if (!scan_plan)
+			return -ENOBUFS;
+
 		if (!scan_plan ||
 		    nla_put_u32(msg, NL80211_SCHED_SCAN_PLAN_INTERVAL,
 				req->scan_plans[i].interval) ||
-- 
2.8.1
