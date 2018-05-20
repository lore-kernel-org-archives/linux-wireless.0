Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51956 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750921AbeETFnw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 01:43:52 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/5] mt76: prevent tx scheduling during channel change
Date: Sun, 20 May 2018 07:43:46 +0200
Message-Id: <20180520054349.49422-2-nbd@nbd.name> (sfid-20180520_074406_652078_6D9DC04E)
In-Reply-To: <20180520054349.49422-1-nbd@nbd.name>
References: <20180520054349.49422-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Re-schedule tx afterwards

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 5c0d1e1260fa..48388f51915a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -124,11 +124,14 @@ mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 {
 	int ret;
 
+	cancel_delayed_work_sync(&dev->cal_work);
+
+	set_bit(MT76_RESET, &dev->mt76.state);
+
 	mt76_set_channel(&dev->mt76);
 
 	tasklet_disable(&dev->pre_tbtt_tasklet);
 	tasklet_disable(&dev->dfs_pd.dfs_tasklet);
-	cancel_delayed_work_sync(&dev->cal_work);
 
 	mt76x2_mac_stop(dev, true);
 	ret = mt76x2_phy_set_channel(dev, chandef);
@@ -143,6 +146,10 @@ mt76x2_set_channel(struct mt76x2_dev *dev, struct cfg80211_chan_def *chandef)
 	tasklet_enable(&dev->dfs_pd.dfs_tasklet);
 	tasklet_enable(&dev->pre_tbtt_tasklet);
 
+	clear_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76_txq_schedule_all(&dev->mt76);
+
 	return ret;
 }
 
@@ -453,7 +460,6 @@ mt76x2_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 
 	clear_bit(MT76_SCANNING, &dev->mt76.state);
 	tasklet_enable(&dev->pre_tbtt_tasklet);
-	mt76_txq_schedule_all(&dev->mt76);
 }
 
 static void
-- 
2.17.0
