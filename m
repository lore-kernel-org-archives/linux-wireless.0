Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54317 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594Ab2AUJxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 04:53:02 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 1/6] ath6kl: Make sure to delete rx aggregation timer in aggr_reset_state()
Date: Sat, 21 Jan 2012 15:22:48 +0530
Message-ID: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120121_105502_531383_4BAD5E45)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timer which is used to flush rx aggregation frames needs to
be disabled when resetting the aggregation state. This is found
in code review.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index dd63371..cb7421a 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1685,6 +1685,11 @@ void aggr_reset_state(struct aggr_info *aggr_info)
 {
 	u8 tid;
 
+	if (aggr_info->timer_scheduled) {
+		del_timer(&aggr_info->timer);
+		aggr_info->timer_scheduled = false;
+	}
+
 	for (tid = 0; tid < NUM_OF_TIDS; tid++)
 		aggr_delete_tid_state(aggr_info, tid);
 }
-- 
1.7.0.4

