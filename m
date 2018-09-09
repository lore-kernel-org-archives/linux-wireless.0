Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41730 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeIJBX6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id z96-v6so19761385wrb.8
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:33:05 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] mt76x0: remove unused mt76x0_burst_read_regs
Date: Sun,  9 Sep 2018 22:32:45 +0200
Message-Id: <20180909203246.21608-11-lorenzo.bianconi@redhat.com> (sfid-20180909_223312_701272_9896EC6A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <sgruszka@redhat.com>

mt76x0_burst_read_regs is not used, but keep it for eventual use. Since
we have this function now in the driver git history, we can remove it and
eventually revert this commit it the function will be needed.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   | 43 -------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 7baa9a45bd84..c14ae6c3e863 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -106,49 +106,6 @@ int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
 					data + cnt, n - cnt);
 }
 
-#if 0
-static int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
-				  struct mt76_reg_pair *data, int n)
-{
-	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 4 - 1;
-	struct mt76_usb *usb = &dev->mt76.usb;
-	struct sk_buff *skb;
-	int cnt, ret;
-
-	if (!n)
-		return 0;
-
-	cnt = min(max_vals_per_cmd, n);
-	if (cnt != n)
-		return -EINVAL;
-
-	skb = alloc_skb(cnt * 4 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-
-	skb_put_le32(skb, base + data[0].reg);
-	skb_put_le32(skb, n);
-
-	mutex_lock(&usb->mcu.mutex);
-
-	usb->mcu.rp = data;
-	usb->mcu.rp_len = n;
-	usb->mcu.base = base;
-	usb->mcu.burst = false;
-
-	ret = __mt76u_mcu_send_msg(&dev->mt76, skb, CMD_BURST_READ, true);
-
-	usb->mcu.rp = NULL;
-
-	mutex_unlock(&usb->mcu.mutex);
-
-	consume_skb(skb);
-
-	return ret;
-}
-#endif
-
 struct mt76_fw_header {
 	__le32 ilm_len;
 	__le32 dlm_len;
-- 
2.18.0
