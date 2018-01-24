Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48644 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934010AbeAXPTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/8] mt76: retry rx polling as long as there is budget left
Date: Wed, 24 Jan 2018 16:19:10 +0100
Message-Id: <20180124151917.70962-1-nbd@nbd.name> (sfid-20180124_161927_699492_05A0D71E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sending frames to mac80211 needs time, which could allow for more rx
packets to end up in the DMA ring. Retry polling until there are no more
frames left. Improves rx latency under load.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index ecd409a4a89b..e539b3838b94 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -387,17 +387,21 @@ static int
 mt76_dma_rx_poll(struct napi_struct *napi, int budget)
 {
 	struct mt76_dev *dev;
-	int qid, done;
+	int qid, done = 0, cur;
 
 	dev = container_of(napi->dev, struct mt76_dev, napi_dev);
 	qid = napi - dev->napi;
 
-	done = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget);
+	do {
+		cur = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget - done);
+		mt76_rx_complete(dev, qid);
+		done += cur;
+	} while (cur && done < budget);
+
 	if (done < budget) {
 		napi_complete(napi);
 		dev->drv->rx_poll_complete(dev, qid);
 	}
-	mt76_rx_complete(dev, qid);
 
 	return done;
 }
-- 
2.14.2
