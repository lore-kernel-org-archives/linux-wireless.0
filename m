Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55516 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932899AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 1/9] mt76: fix beacon timer drift
Date: Thu, 21 Jun 2018 11:17:53 +0200
Message-Id: <20180621091801.41184-1-nbd@nbd.name> (sfid-20180621_111825_036519_3BB539FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The beacon timer drifts by 1 microsecond every TBTT. After 20 minutes
with a beacon interval of 100, the drift will be almost 12 ms, enough to
cause weird issues for devices in powersave mode.

Since the beacon timer is configured in units of 1/16 TU (64 us), we
need to adjust it once every 64 beacons and only for one beacon.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  5 ++-
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |  5 ++-
 .../net/wireless/mediatek/mt76/mt76x2_tx.c    | 33 +++++++++++++++++++
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index dc12bbdbb2ee..06ca5a77dfdf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -120,10 +120,13 @@ struct mt76x2_dev {
 	u8 beacon_mask;
 	u8 beacon_data_mask;
 
-	u32 rxfilter;
+	u8 tbtt_count;
+	u16 beacon_int;
 
 	u16 chainmask;
 
+	u32 rxfilter;
+
 	struct mt76x2_calibration cal;
 
 	s8 target_power;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index ce90ff999b49..e4e41faf6739 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -238,10 +238,13 @@ mt76x2_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (changed & BSS_CHANGED_BSSID)
 		mt76x2_mac_set_bssid(dev, mvif->idx, info->bssid);
 
-	if (changed & BSS_CHANGED_BEACON_INT)
+	if (changed & BSS_CHANGED_BEACON_INT) {
 		mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
 			       MT_BEACON_TIME_CFG_INTVAL,
 			       info->beacon_int << 4);
+		dev->beacon_int = info->beacon_int;
+		dev->tbtt_count = 0;
+	}
 
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		tasklet_disable(&dev->pre_tbtt_tasklet);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index e46eafc4c436..560376dd1133 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -218,6 +218,37 @@ mt76x2_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	data->tail[mvif->idx] = skb;
 }
 
+static void
+mt76x2_resync_beacon_timer(struct mt76x2_dev *dev)
+{
+	u32 timer_val = dev->beacon_int << 4;
+
+	dev->tbtt_count++;
+
+	/*
+	 * Beacon timer drifts by 1us every tick, the timer is configured
+	 * in 1/16 TU (64us) units.
+	 */
+	if (dev->tbtt_count < 62)
+		return;
+
+	if (dev->tbtt_count >= 64) {
+		dev->tbtt_count = 0;
+		return;
+	}
+
+	/*
+	 * The updated beacon interval takes effect after two TBTT, because
+	 * at this point the original interval has already been loaded into
+	 * the next TBTT_TIMER value
+	 */
+	if (dev->tbtt_count == 62)
+		timer_val -= 1;
+
+	mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
+		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
+}
+
 void mt76x2_pre_tbtt_tasklet(unsigned long arg)
 {
 	struct mt76x2_dev *dev = (struct mt76x2_dev *) arg;
@@ -226,6 +257,8 @@ void mt76x2_pre_tbtt_tasklet(unsigned long arg)
 	struct sk_buff *skb;
 	int i, nframes;
 
+	mt76x2_resync_beacon_timer(dev);
+
 	data.dev = dev;
 	__skb_queue_head_init(&data.q);
 
-- 
2.17.0
