Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18866 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab2D0BS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 21:18:28 -0400
From: Kevin Fang <chienf@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/2] ath6kl: handle background(BK) stream properly on htc mbox layer
Date: Fri, 27 Apr 2012 09:18:01 +0800
Message-ID: <1335489482-15565-1-git-send-email-kevin.fang@qca.qualcomm.com> (sfid-20120427_031831_701742_58A74EF7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bug description:
STA sends huge BK QoS data frame first, then sends BE/VI/VO QoS data frame.
The corresponding throughput becomes much lower than
that without sends BK QoS data frame before.

The root cause is that when station send BK stream,
the tx credits of BK stream don't return back to
higher priority QoS stream such as BE, VI, and VO stream.
This patch will handle BK stream properly,
when there is higher priority QoS stream,
it will seek tx credits from BK stream properly.

Signed-off-by: Kevin Fang <kevin.fang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index 065e615..3e65d36 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -83,10 +83,7 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 			 * never goes inactive EVER.
 			 */
 			cur_ep_dist->dist_flags |= HTC_EP_ACTIVE;
-		} else if (cur_ep_dist->svc_id == WMI_DATA_BK_SVC)
-			/* this is the lowest priority data endpoint */
-			/* FIXME: this looks fishy, check */
-			cred_info->lowestpri_ep_dist = cur_ep_dist->list;
+		}
 
 		/*
 		 * Streams have to be created (explicit | implicit) for all
@@ -100,6 +97,13 @@ static void ath6kl_credit_init(struct ath6kl_htc_credit_info *cred_info,
 		 */
 	}
 
+	/*
+	 * For ath6kl_credit_seek function,
+	 * it use list_for_each_entry_reverse to walk around the whole ep list.
+	 * Therefore assign this lowestpri_ep_dist after walk around the ep_list
+	 */
+	cred_info->lowestpri_ep_dist = cur_ep_dist->list;
+
 	WARN_ON(cred_info->cur_free_credits <= 0);
 
 	list_for_each_entry(cur_ep_dist, ep_list, list) {
-- 
1.7.0.4

