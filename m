Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34120 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752256AbeA0PCI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Jan 2018 10:02:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4.16 4/4] mt76: do not set status->aggr for NULL data frames
Date: Sat, 27 Jan 2018 16:02:06 +0100
Message-Id: <20180127150206.24690-4-nbd@nbd.name> (sfid-20180127_160213_851483_3C1616DC)
In-Reply-To: <20180127150206.24690-1-nbd@nbd.name>
References: <20180127150206.24690-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids data connection stalls when the client toggles powersave mode

Fixes: aee5b8cf2477 ("mt76: implement A-MPDU rx reordering in the driver code")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 6c30b5eaa9ca..7ea3d841918e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -341,7 +341,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 
 	mt76x2_remove_hdr_pad(skb, pad_len);
 
-	if (rxinfo & MT_RXINFO_BA)
+	if ((rxinfo & MT_RXINFO_BA) && !(rxinfo & MT_RXINFO_NULL))
 		status->aggr = true;
 
 	if (WARN_ON_ONCE(len > skb->len))
-- 
2.14.2
