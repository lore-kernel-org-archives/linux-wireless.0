Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30031 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab2AYQIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 11:08:01 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V3 1/6] ath6kl: Make sure to delete rx aggregation timer in aggr_reset_state()
Date: Wed, 25 Jan 2012 21:37:49 +0530
Message-ID: <1327507674-2561-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120125_170817_706035_8A9B5210)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The timer which is used to flush rx aggregation frames needs to
be disabled when resetting the aggregation state. This is found
in code review.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
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

