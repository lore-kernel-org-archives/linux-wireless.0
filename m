Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40339 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdBOUq6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 15:46:58 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2] mac80211: fix mesh fail_avg check
Date: Wed, 15 Feb 2017 12:46:50 -0800
Message-ID: <1487191610-20948-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20170215_214701_903968_984BB56D)
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
v2: define MACRO for threshold

 net/mac80211/mesh_hwmp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index d07ee3ca07ee..4005edd71fe8 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -16,6 +16,7 @@
 #define TEST_FRAME_LEN	8192
 #define MAX_METRIC	0xffffffff
 #define ARITH_SHIFT	8
+#define LINK_FAIL_THRESH 95
 
 #define MAX_PREQ_QUEUE_LEN	64
 
@@ -311,7 +312,8 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 	 * feed failure as 100 and success as 0
 	 */
 	ewma_mesh_fail_avg_add(&sta->mesh->fail_avg, failed * 100);
-	if (ewma_mesh_fail_avg_read(&sta->mesh->fail_avg) > 95)
+	if (ewma_mesh_fail_avg_read(&sta->mesh->fail_avg) >
+			LINK_FAIL_THRESH)
 		mesh_plink_broken(sta);
 }
 
@@ -339,7 +341,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	if (rate) {
 		err = 0;
 	} else {
-		if (fail_avg >= 100)
+		if (fail_avg > LINK_FAIL_THRESH)
 			return MAX_METRIC;
 
 		sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
-- 
1.9.1
