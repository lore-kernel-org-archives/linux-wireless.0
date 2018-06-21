Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55508 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932891AbeFUJSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Jun 2018 05:18:05 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 8/9] mt76: track ewma rssi for gain adjustment per station
Date: Thu, 21 Jun 2018 11:18:00 +0200
Message-Id: <20180621091801.41184-8-nbd@nbd.name> (sfid-20180621_111844_815533_D2A25F29)
In-Reply-To: <20180621091801.41184-1-nbd@nbd.name>
References: <20180621091801.41184-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This preserves more sensitivity when weak stations are active and avoids
counting signal measurements from other unrelated networks

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h   | 10 +++-
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   | 33 ++++++++---
 .../net/wireless/mediatek/mt76/mt76x2_main.c  |  2 +
 .../net/wireless/mediatek/mt76/mt76x2_phy.c   | 58 ++++++++++++++++---
 4 files changed, 83 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 21de1168076d..71fcfa44fb2e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -27,6 +27,7 @@
 #include <linux/mutex.h>
 #include <linux/bitops.h>
 #include <linux/kfifo.h>
+#include <linux/average.h>
 
 #define MT7662_FIRMWARE		"mt7662.bin"
 #define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
@@ -47,6 +48,8 @@
 #include "mt76x2_mac.h"
 #include "mt76x2_dfs.h"
 
+DECLARE_EWMA(signal, 10, 8)
+
 struct mt76x2_mcu {
 	struct mutex mutex;
 
@@ -69,10 +72,8 @@ struct mt76x2_calibration {
 	u8 agc_gain_init[MT_MAX_CHAINS];
 	u8 agc_gain_cur[MT_MAX_CHAINS];
 
-	int avg_rssi[MT_MAX_CHAINS];
-	int avg_rssi_all;
-
 	u16 false_cca;
+	s8 avg_rssi_all;
 	s8 agc_gain_adjust;
 	s8 low_gain;
 
@@ -153,6 +154,9 @@ struct mt76x2_sta {
 	struct mt76x2_vif *vif;
 	struct mt76x2_tx_status status;
 	int n_frames;
+
+	struct ewma_signal rssi;
+	int inactive_count;
 };
 
 static inline bool is_mt7612(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index b49aea4da2d6..f34b4d6413e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -269,21 +269,31 @@ static void mt76x2_remove_hdr_pad(struct sk_buff *skb, int len)
 	skb_pull(skb, len);
 }
 
-static struct mt76_wcid *
-mt76x2_rx_get_sta_wcid(struct mt76x2_dev *dev, u8 idx, bool unicast)
+static struct mt76x2_sta *
+mt76x2_rx_get_sta(struct mt76x2_dev *dev, u8 idx)
 {
-	struct mt76x2_sta *sta;
 	struct mt76_wcid *wcid;
 
 	if (idx >= ARRAY_SIZE(dev->wcid))
 		return NULL;
 
 	wcid = rcu_dereference(dev->wcid[idx]);
-	if (unicast || !wcid)
-		return wcid;
+	if (!wcid)
+		return NULL;
 
-	sta = container_of(wcid, struct mt76x2_sta, wcid);
-	return &sta->vif->group_wcid;
+	return container_of(wcid, struct mt76x2_sta, wcid);
+}
+
+static struct mt76_wcid *
+mt76x2_rx_get_sta_wcid(struct mt76x2_dev *dev, struct mt76x2_sta *sta, bool unicast)
+{
+	if (!sta)
+		return NULL;
+
+	if (unicast)
+		return &sta->wcid;
+	else
+		return &sta->vif->group_wcid;
 }
 
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
@@ -291,6 +301,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x2_rxwi *rxwi = rxi;
+	struct mt76x2_sta *sta;
 	u32 rxinfo = le32_to_cpu(rxwi->rxinfo);
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
@@ -315,7 +326,8 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	}
 
 	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
-	status->wcid = mt76x2_rx_get_sta_wcid(dev, wcid, unicast);
+	sta = mt76x2_rx_get_sta(dev, wcid);
+	status->wcid = mt76x2_rx_get_sta_wcid(dev, sta, unicast);
 
 	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
@@ -361,6 +373,11 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	status->tid = FIELD_GET(MT_RXWI_TID, tid_sn);
 	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
 
+	if (sta) {
+		ewma_signal_add(&sta->rssi, status->signal);
+		sta->inactive_count = 0;
+	}
+
 	return mt76x2_mac_process_rate(status, rate);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index e4e41faf6739..3c0ebe6d231c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -294,6 +294,8 @@ mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
 
+	ewma_signal_init(&msta->rssi);
+
 	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
 
 out:
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index 94943aeb249d..14aedc3ef731 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -499,22 +499,62 @@ mt76x2_phy_adjust_vga_gain(struct mt76x2_dev *dev)
 	mt76x2_phy_set_gain_val(dev);
 }
 
+static int
+mt76x2_phy_get_min_avg_rssi(struct mt76x2_dev *dev)
+{
+	struct mt76x2_sta *sta;
+	struct mt76_wcid *wcid;
+	int i, j, min_rssi = 0;
+	s8 cur_rssi;
+
+	local_bh_disable();
+	rcu_read_lock();
+
+	for (i = 0; i < ARRAY_SIZE(dev->wcid_mask); i++) {
+		unsigned long mask = dev->wcid_mask[i];
+
+		if (!mask)
+			continue;
+
+		for (j = i * BITS_PER_LONG; mask; j++, mask >>= 1) {
+			if (!(mask & 1))
+				continue;
+
+			wcid = rcu_dereference(dev->wcid[j]);
+			if (!wcid)
+				continue;
+
+			sta = container_of(wcid, struct mt76x2_sta, wcid);
+			spin_lock(&dev->mt76.rx_lock);
+			if (sta->inactive_count++ < 5)
+				cur_rssi = ewma_signal_read(&sta->rssi);
+			else
+				cur_rssi = 0;
+			spin_unlock(&dev->mt76.rx_lock);
+
+			if (cur_rssi < min_rssi)
+				min_rssi = cur_rssi;
+		}
+	}
+
+	rcu_read_unlock();
+	local_bh_enable();
+
+	if (!min_rssi)
+		return -75;
+
+	return min_rssi;
+}
+
 static void
 mt76x2_phy_update_channel_gain(struct mt76x2_dev *dev)
 {
-	u32 val = mt76_rr(dev, MT_BBP(AGC, 20));
-	int rssi0 = (s8) FIELD_GET(MT_BBP_AGC20_RSSI0, val);
-	int rssi1 = (s8) FIELD_GET(MT_BBP_AGC20_RSSI1, val);
 	u8 *gain = dev->cal.agc_gain_init;
 	u8 gain_delta;
 	int low_gain;
+	u32 val;
 
-	dev->cal.avg_rssi[0] = (dev->cal.avg_rssi[0] * 15) / 16 +
-			       (rssi0 << 8) / 16;
-	dev->cal.avg_rssi[1] = (dev->cal.avg_rssi[1] * 15) / 16 +
-			       (rssi1 << 8) / 16;
-	dev->cal.avg_rssi_all = (dev->cal.avg_rssi[0] +
-				 dev->cal.avg_rssi[1]) / 512;
+	dev->cal.avg_rssi_all = mt76x2_phy_get_min_avg_rssi(dev);
 
 	low_gain = (dev->cal.avg_rssi_all > mt76x2_get_rssi_gain_thresh(dev)) +
 		   (dev->cal.avg_rssi_all > mt76x2_get_low_rssi_gain_thresh(dev));
-- 
2.17.0
