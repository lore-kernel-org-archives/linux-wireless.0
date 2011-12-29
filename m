Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37005 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1L2Kfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 05:35:32 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 1/3] ath6kl: Remove few unnecessary spin_locks around set_bit()
Date: Thu, 29 Dec 2011 16:05:37 +0530
Message-ID: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20111229_113536_209794_41BD4A51)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 506a303..7645eac 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -449,9 +449,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 		 * WMI queue with too many commands the only exception to
 		 * this is during testing using endpointping.
 		 */
-		spin_lock_bh(&ar->lock);
 		set_bit(WMI_CTRL_EP_FULL, &ar->flag);
-		spin_unlock_bh(&ar->lock);
 		ath6kl_err("wmi ctrl ep is full\n");
 		return action;
 	}
@@ -479,9 +477,7 @@ enum htc_send_full_action ath6kl_tx_queue_full(struct htc_target *target,
 		    action != HTC_SEND_FULL_DROP) {
 			spin_unlock_bh(&ar->list_lock);
 
-			spin_lock_bh(&vif->if_lock);
 			set_bit(NETQ_STOPPED, &vif->flags);
-			spin_unlock_bh(&vif->if_lock);
 			netif_stop_queue(vif->ndev);
 
 			return action;
-- 
1.7.0.4

