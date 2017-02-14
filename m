Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35332 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755002AbdBNU2h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 15:28:37 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] mac80211: fix mesh fail_avg check
Date: Tue, 14 Feb 2017 12:27:17 -0800
Message-ID: <1487104037-24941-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170214_212848_670036_1640AEE4)
In-Reply-To: <1487104037-24941-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1487104037-24941-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh failure average never be more than 100. Only in case of
fixed path, average will be more than threshold limit (95%).
With recent EWMA changes it may go upto 99 as it is scaled to
100. It make sense to return maximum metric when average is
greater than threshold limit.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mesh_hwmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d07ee3ca07ee..02c30a21eb66 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -339,7 +339,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (rate) {
 		err = 0;
 	} else {
-		if (fail_avg >= 100)
+		if (fail_avg >= 95)
 			return MAX_METRIC;
 
 		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
-- 
1.9.1
