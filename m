Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:45028 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbeIFOd3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:33:29 -0400
From: Colin King <colin.king@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cfg80211: remove redundant check of !scan_plan
Date: Thu,  6 Sep 2018 10:58:44 +0100
Message-Id: <20180906095844.17071-1-colin.king@canonical.com> (sfid-20180906_115858_216355_E1212791)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The check for !scan_plan is redunant as this has been checked
in the proceeding statement and the code returns -ENOBUFS if
it is true. Remove the redundant check.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/wireless/nl80211.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d5f9b5235cdd..b4908bcb0d77 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10690,8 +10690,7 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 		if (!scan_plan)
 			return -ENOBUFS;
 
-		if (!scan_plan ||
-		    nla_put_u32(msg, NL80211_SCHED_SCAN_PLAN_INTERVAL,
+		if (nla_put_u32(msg, NL80211_SCHED_SCAN_PLAN_INTERVAL,
 				req->scan_plans[i].interval) ||
 		    (req->scan_plans[i].iterations &&
 		     nla_put_u32(msg, NL80211_SCHED_SCAN_PLAN_ITERATIONS,
-- 
2.17.1
