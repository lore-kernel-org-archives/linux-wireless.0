Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:51542 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750975AbdASKBl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 05:01:41 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH] nl80211: fix validation of scheduled scan info for wowlan netdetect
Date: Thu, 19 Jan 2017 10:01:28 +0000
Message-Id: <1484820088-24448-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170119_110145_377724_A0FBE719)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For wowlan netdetect a separate limit is defined for the number of
matchsets. Currently, this limit is ignored and the regular limit
for scheduled scan matchsets, ie. struct wiphy::max_match_sets, is
used for the net-detect case as well.

Cc: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b4e7bdd..df0675d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6852,7 +6852,7 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 
 static struct cfg80211_sched_scan_request *
 nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
-			 struct nlattr **attrs)
+			 struct nlattr **attrs, int max_match_sets)
 {
 	struct cfg80211_sched_scan_request *request;
 	struct nlattr *attr;
@@ -6917,7 +6917,7 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	if (!n_match_sets && default_match_rssi != NL80211_SCAN_RSSI_THOLD_OFF)
 		n_match_sets = 1;
 
-	if (n_match_sets > wiphy->max_match_sets)
+	if (n_match_sets > max_match_sets)
 		return ERR_PTR(-EINVAL);
 
 	if (attrs[NL80211_ATTR_IE])
@@ -7217,7 +7217,8 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		return -EINPROGRESS;
 
 	sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
-						  info->attrs);
+						  info->attrs,
+						  rdev->wiphy.max_match_sets);
 
 	err = PTR_ERR_OR_ZERO(sched_scan_req);
 	if (err)
@@ -10030,7 +10031,8 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
 	if (err)
 		goto out;
 
-	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, NULL, tb);
+	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, NULL, tb,
+						   wowlan->max_nd_match_sets);
 	err = PTR_ERR_OR_ZERO(trig->nd_config);
 	if (err)
 		trig->nd_config = NULL;
-- 
1.9.1
