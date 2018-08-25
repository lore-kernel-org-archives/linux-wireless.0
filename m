Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42618 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:46 -0400
Received: by mail-wr1-f68.google.com with SMTP id v17-v6so9438398wrr.9
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:11 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 08/16] mt76x0: remove mt76x0_mcu_msg_alloc routine
Date: Sat, 25 Aug 2018 12:40:48 +0200
Message-Id: <20180825104056.9130-9-lorenzo.bianconi@redhat.com> (sfid-20180825_124115_284080_3BB26723)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove mt76x0_mcu_msg_alloc duplicated routine and use mt76u_mcu_msg_alloc
utility function for usb mcu message allocation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index cf3acee12dc3..8a258fa33c2a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -59,21 +59,6 @@ static inline void trace_mt76x0_mcu_msg_send_cs(struct mt76_dev *dev,
 	trace_mt76x0_mcu_msg_send(dev, skb, csum, need_resp);
 }
 
-static struct sk_buff *
-mt76x0_mcu_msg_alloc(struct mt76x0_dev *dev, const void *data, int len)
-{
-	struct sk_buff *skb;
-
-	WARN_ON(len % 4); /* if length is not divisible by 4 we need to pad */
-
-	skb = alloc_skb(len + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (skb) {
-		skb_reserve(skb, MT_DMA_HDR_LEN);
-		memcpy(skb_put(skb, len), data, len);
-	}
-	return skb;
-}
-
 static void mt76x0_read_resp_regs(struct mt76x0_dev *dev, int len)
 {
 	int i;
@@ -217,7 +202,7 @@ int mt76x0_mcu_function_select(struct mt76x0_dev *dev,
 		.value = cpu_to_le32(val),
 	};
 
-	skb = mt76x0_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
 	return mt76x0_mcu_msg_send(dev, skb, CMD_FUN_SET_OP, func == 5);
@@ -235,7 +220,7 @@ mt76x0_mcu_calibrate(struct mt76x0_dev *dev, enum mcu_calibrate cal, u32 val)
 		.value = cpu_to_le32(val),
 	};
 
-	skb = mt76x0_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
 	if (!skb)
 		return -ENOMEM;
 	return mt76x0_mcu_msg_send(dev, skb, CMD_CALIBRATION_OP, true);
-- 
2.18.0
