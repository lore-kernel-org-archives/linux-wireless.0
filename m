Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:36765 "EHLO m50-133.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1427705AbdDWHBy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Apr 2017 03:01:54 -0400
From: Pan Bian <bianpan2016@163.com>
To: Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, Pan Bian <bianpan2016@163.com>
Subject: [PATCH 1/1] mt7601u: check return value of alloc_skb
Date: Sun, 23 Apr 2017 15:00:23 +0800
Message-Id: <1492930823-17249-1-git-send-email-bianpan2016@163.com> (sfid-20170423_090219_346441_7830741A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function alloc_skb() will return a NULL pointer if there is no enough
memory. However, in function mt7601u_mcu_msg_alloc(), its return value
is not validated before it is used. This patch fixes it.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index dbdfb3f..a9f5f39 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -66,8 +66,10 @@ static inline void trace_mt_mcu_msg_send_cs(struct mt7601u_dev *dev,
 	WARN_ON(len % 4); /* if length is not divisible by 4 we need to pad */
 
 	skb = alloc_skb(len + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-	memcpy(skb_put(skb, len), data, len);
+	if (skb) {
+		skb_reserve(skb, MT_DMA_HDR_LEN);
+		memcpy(skb_put(skb, len), data, len);
+	}
 
 	return skb;
 }
@@ -170,6 +172,8 @@ static int mt7601u_mcu_function_select(struct mt7601u_dev *dev,
 	};
 
 	skb = mt7601u_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
 	return mt7601u_mcu_msg_send(dev, skb, CMD_FUN_SET_OP, func == 5);
 }
 
@@ -205,6 +209,8 @@ int mt7601u_mcu_tssi_read_kick(struct mt7601u_dev *dev, int use_hvga)
 	};
 
 	skb = mt7601u_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
 	return mt7601u_mcu_msg_send(dev, skb, CMD_CALIBRATION_OP, true);
 }
 
-- 
1.9.1
