Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:27907 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728736AbeIFR4h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 13:56:37 -0400
From: Rakesh Pillai <pillair@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH] ath10k: Fix tx status flag setting for management frames
Date: Thu,  6 Sep 2018 18:50:14 +0530
Message-Id: <1536240014-10349-1-git-send-email-pillair@codeaurora.org> (sfid-20180906_152111_307248_19016B85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The tx_status for management frames is being filled
incorrectly in the flags of skb_cb. This incorrect
flag setting causes the upper layers to consider that
the particular frame was not transmitted properly,
leading to improper behavior.

Set the IEEE80211_TX_STAT_ACK flag in the info flags
of skb_cb, to indicate the successful transmission of
the management frame.

Fixes: dc405152bb64d4ae01c9ac669de25b2d1fb6fc2d

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fd612d2..1dced0d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2336,7 +2336,12 @@ static int wmi_process_mgmt_tx_comp(struct ath10k *ar, u32 desc_id,
 	dma_unmap_single(ar->dev, pkt_addr->paddr,
 			 msdu->len, DMA_FROM_DEVICE);
 	info = IEEE80211_SKB_CB(msdu);
-	info->flags |= status;
+
+	if (status)
+		info->flags &= ~IEEE80211_TX_STAT_ACK;
+	else
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
 	ieee80211_tx_status_irqsafe(ar->hw, msdu);
 
 	ret = 0;
-- 
2.7.4
