Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.smtp.broadcom.com ([192.19.211.62]:33434 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbcKQJKf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 04:10:35 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 2/2] nl80211: check NL80211_ATTR_SCHED_SCAN_INTERVAL only once
Date: Thu, 17 Nov 2016 09:02:40 +0000
Message-Id: <1479373360-1398-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161117_101042_678900_62808FE2)
In-Reply-To: <1479373360-1398-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479373360-1398-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The presence of the NL80211_ATTR_SCHED_SCAN_INTERVAL attribute was
checked in nl80211_parse_sched_scan() and
nl80211_parse_sched_scan_plans() which might be a bit redundant
so removing one.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 24ab199..051cd5a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6761,13 +6761,10 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 
 		/*
 		 * If scan plans are not specified,
-		 * %NL80211_ATTR_SCHED_SCAN_INTERVAL must be specified. In this
+		 * %NL80211_ATTR_SCHED_SCAN_INTERVAL will be specified. In this
 		 * case one scan plan will be set with the specified scan
 		 * interval and infinite number of iterations.
 		 */
-		if (!attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL])
-			return -EINVAL;
-
 		interval = nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL]);
 		if (!interval)
 			return -EINVAL;
-- 
1.9.1
