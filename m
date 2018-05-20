Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51952 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751026AbeETFnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 01:43:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 5/5] mt76: use udelay instead of usleep_range in mt76x2_mac_stop
Date: Sun, 20 May 2018 07:43:49 +0200
Message-Id: <20180520054349.49422-5-nbd@nbd.name> (sfid-20180520_074407_315770_BE01A2B6)
In-Reply-To: <20180520054349.49422-1-nbd@nbd.name>
References: <20180520054349.49422-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usleep_range can cause excessive latency on channel change if waiting
for the MAC to stop fails. It will be forced to stop by the code
following that loop anyway.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 7096256c7f50..4e5f360d0655 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -376,7 +376,7 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 		if ((mt76_rr(dev, MT_MAC_STATUS) &
 		     (MT_MAC_STATUS_RX | MT_MAC_STATUS_TX)) ||
 		    mt76_rr(dev, MT_BBP(IBI, 12))) {
-			usleep_range(10, 20);
+			udelay(1);
 			continue;
 		}
 
-- 
2.17.0
