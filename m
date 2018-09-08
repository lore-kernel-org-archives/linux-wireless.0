Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:37821 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbeIHQTL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Sep 2018 12:19:11 -0400
From: zhong jiang <zhongjiang@huawei.com>
To: <johannes@sipsolutions.net>, <davem@davemloft.net>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] cfg80211: remove unnecessary null pointer check in cfg80211_netdev_notifier_call
Date: Sat, 8 Sep 2018 19:21:28 +0800
Message-ID: <1536405688-26239-1-git-send-email-zhongjiang@huawei.com> (sfid-20180908_133442_414412_E649F9D0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The iterator in list_for_each_entry_safe is never null, therefore, remove
the redundant null pointer check.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 net/wireless/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a88551f..4d5215e 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1238,7 +1238,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 
 		list_for_each_entry_safe(pos, tmp,
 					 &rdev->sched_scan_req_list, list) {
-			if (WARN_ON(pos && pos->dev == wdev->netdev))
+			if (WARN_ON(pos->dev == wdev->netdev))
 				cfg80211_stop_sched_scan_req(rdev, pos, false);
 		}
 
-- 
1.7.12.4
