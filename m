Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49848 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752881AbeDCTxD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:53:03 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/7] mt76: toggle driver station powersave bit before notifying mac80211
Date: Tue,  3 Apr 2018 21:52:50 +0200
Message-Id: <20180403195254.87700-3-nbd@nbd.name> (sfid-20180403_215306_539190_F4EEF110)
In-Reply-To: <20180403195254.87700-1-nbd@nbd.name>
References: <20180403195254.87700-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids race conditions from mac80211 enqueueing tx packets before the
tx-drop bit is cleared

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index ec531ce50d01..eb49e0a6758c 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -547,8 +547,8 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 	else
 		clear_bit(MT_WCID_FLAG_PS, &wcid->flags);
 
-	ieee80211_sta_ps_transition(sta, ps);
 	dev->drv->sta_ps(dev, sta, ps);
+	ieee80211_sta_ps_transition(sta, ps);
 }
 
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
-- 
2.14.2
