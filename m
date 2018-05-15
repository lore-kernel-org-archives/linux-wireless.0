Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47412 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752698AbeEOMd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 08:33:26 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/2] mt76: discard early received packets if not running yet
Date: Tue, 15 May 2018 14:33:23 +0200
Message-Id: <20180515123323.24702-2-nbd@nbd.name> (sfid-20180515_143330_923624_56C3E3D3)
In-Reply-To: <20180515123323.24702-1-nbd@nbd.name>
References: <20180515123323.24702-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the radio was previously in running state, it can receive some
packets before it is able to process them.
This can lead to a crash if the channel is not initialized yet.
Discard all rx packets until start() is called

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index dab713756004..b49aea4da2d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -301,6 +301,9 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	u8 wcid;
 	int len;
 
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+		return -EINVAL;
+
 	if (rxinfo & MT_RXINFO_L2PAD)
 		pad_len += 2;
 
-- 
2.17.0
