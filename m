Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51968 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750918AbeETFnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 01:43:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/5] mt76: only stop tx queues on offchannel, not during the entire scan
Date: Sun, 20 May 2018 07:43:45 +0200
Message-Id: <20180520054349.49422-1-nbd@nbd.name> (sfid-20180520_074404_838212_30E29DBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During scans, mac80211 frequently switches back to the home channel to
minimize interruption of ongoing traffic. Keep regular tx queues active
during that time.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 1 +
 drivers/net/wireless/mediatek/mt76/tx.c       | 4 ++--
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 915e61733131..d862e5efd094 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -366,6 +366,11 @@ void mt76_set_channel(struct mt76_dev *dev)
 	struct mt76_channel_state *state;
 	bool offchannel = hw->conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
+	if (offchannel)
+		set_bit(MT76_OFFCHANNEL, &dev->state);
+	else
+		clear_bit(MT76_OFFCHANNEL, &dev->state);
+
 	if (dev->drv->update_survey)
 		dev->drv->update_survey(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index a74e6eef51e9..2d098fac6147 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -189,6 +189,7 @@ enum {
 	MT76_STATE_RUNNING,
 	MT76_SCANNING,
 	MT76_RESET,
+	MT76_OFFCHANNEL,
 };
 
 struct mt76_hw_cap {
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 7ecd2d7c5db4..e96956710fb2 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -332,7 +332,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		if (probe)
 			break;
 
-		if (test_bit(MT76_SCANNING, &dev->state) ||
+		if (test_bit(MT76_OFFCHANNEL, &dev->state) ||
 		    test_bit(MT76_RESET, &dev->state))
 			return -EBUSY;
 
@@ -385,7 +385,7 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 		bool empty = false;
 		int cur;
 
-		if (test_bit(MT76_SCANNING, &dev->state) ||
+		if (test_bit(MT76_OFFCHANNEL, &dev->state) ||
 		    test_bit(MT76_RESET, &dev->state))
 			return -EBUSY;
 
-- 
2.17.0
