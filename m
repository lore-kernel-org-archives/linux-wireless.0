Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49820 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752639AbeDCTw6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 15:52:58 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/7] mt76: stop tx queues from the driver callback instead of common code
Date: Tue,  3 Apr 2018 21:52:48 +0200
Message-Id: <20180403195254.87700-1-nbd@nbd.name> (sfid-20180403_215303_795763_8C065383)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allows the driver to control whether to send a BlockAckReq after waking
up. MT76x2 needs this set to true, for MT7603 (to be submitted later)
it needs to be false.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 6 ++----
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 1 +
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 4f30cdcd2b53..962ed8234065 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -541,12 +541,10 @@ mt76_check_ps(struct mt76_dev *dev, struct sk_buff *skb)
 	if (!!test_bit(MT_WCID_FLAG_PS, &wcid->flags) == ps)
 		return;
 
-	if (ps) {
+	if (ps)
 		set_bit(MT_WCID_FLAG_PS, &wcid->flags);
-		mt76_stop_tx_queues(dev, sta, true);
-	} else {
+	else
 		clear_bit(MT_WCID_FLAG_PS, &wcid->flags);
-	}
 
 	ieee80211_sta_ps_transition(sta, ps);
 	dev->drv->sta_ps(dev, sta, ps);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 73c127f92613..81c58f865c64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -321,6 +321,7 @@ mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 	int idx = msta->wcid.idx;
 
+	mt76_stop_tx_queues(&dev->mt76, sta, true);
 	mt76x2_mac_wcid_set_drop(dev, idx, ps);
 }
 
-- 
2.14.2
