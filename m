Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49824 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752863AbeDCTw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:52:58 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 6/7] mt76: set RX_FLAG_DUP_VALIDATED for A-MPDU reordered packets
Date: Tue,  3 Apr 2018 21:52:53 +0200
Message-Id: <20180403195254.87700-6-nbd@nbd.name> (sfid-20180403_215307_203108_59BB74DC)
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Required for fast-rx and allows mac80211 to skip an unnnecessary check.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/agg-rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
index cbac42cb536c..6657ec8928de 100644
--- a/drivers/net/wireless/mediatek/mt76/agg-rx.c
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -169,6 +169,7 @@ void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
 	if (!tid)
 		return;
 
+	status->flag |= RX_FLAG_DUP_VALIDATED;
 	spin_lock_bh(&tid->lock);
 
 	if (tid->stopped)
-- 
2.14.2
