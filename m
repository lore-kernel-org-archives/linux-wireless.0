Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45542 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753327AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 09/14] mt76x2: remove MAC address limitation for multi-vif setups
Date: Thu, 14 Dec 2017 16:39:13 +0100
Message-Id: <20171214153918.43774-10-nbd@nbd.name> (sfid-20171214_163933_540385_E395B94A)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hardware has a separate set of registers to configure a
per-interface MAC address.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 27 +++++++++++++++++----
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h  |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 30 ++++++++++--------------
 drivers/net/wireless/mediatek/mt76/mt76x2_regs.h |  8 +++++++
 6 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a12dfce8c0d1..a993cc09cd1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -90,6 +90,7 @@ struct mt76x2_dev {
 
 	const u16 *beacon_offsets;
 	unsigned long wcid_mask[128 / BITS_PER_LONG];
+	unsigned long vif_mask;
 
 	int txpower_conf;
 	int txpower_cur;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 3e3a01b6f2ce..ac4eeaf2c993 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -279,6 +279,8 @@ int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 beacons */
 		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
 
+	mt76_set(dev, MT_MAC_ADDR_EXT_CTL, MT_MAC_ADDR_EXT_CTL_EN);
+
 	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
 	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
 		       8 << 4);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index a7416a01baa4..60cee4abed7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -22,10 +22,29 @@
 
 void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 {
-	idx &= 7;
-	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), get_unaligned_le32(addr));
-	mt76_rmw_field(dev, MT_MAC_APC_BSSID_H(idx), MT_MAC_APC_BSSID_H_ADDR,
-		       get_unaligned_le16(addr + 4));
+	u32 lo = 0, hi = 0;
+
+	if (addr) {
+		lo = get_unaligned_le32(addr);
+		hi = get_unaligned_le16(addr + 4);
+		hi |= MT_MAC_APC_BSSID0_H_EN;
+	}
+
+	mt76_wr(dev, MT_MAC_APC_BSSID_L(idx), lo);
+	mt76_wr(dev, MT_MAC_APC_BSSID_H(idx), hi);
+}
+
+void mt76x2_mac_set_ext_mac(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
+{
+	u32 lo = 0, hi = 0;
+
+	if (addr) {
+		lo = get_unaligned_le32(addr);
+		hi = get_unaligned_le16(addr + 4);
+	}
+
+	mt76_wr(dev, MT_MAC_ADDR_EXT_L(idx), lo);
+	mt76_wr(dev, MT_MAC_ADDR_EXT_H(idx), hi);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 8a8a25e32d5f..a993c383d9e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -162,6 +162,7 @@ int mt76x2_mac_start(struct mt76x2_dev *dev);
 void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force);
 void mt76x2_mac_resume(struct mt76x2_dev *dev);
 void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr);
+void mt76x2_mac_set_ext_mac(struct mt76x2_dev *dev, u8 idx, const u8 *addr);
 
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 8098a2b82c5b..240e11508ecd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -82,26 +82,15 @@ mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct mt76x2_dev *dev = hw->priv;
 	struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
-	unsigned int idx = 0;
+	unsigned int idx;
 
-	if (vif->addr[0] & BIT(1))
-		idx = 1 + (((dev->mt76.macaddr[0] ^ vif->addr[0]) >> 2) & 7);
+	idx = ffs(~dev->vif_mask);
+	if (!idx || idx > 8)
+		return -ENOSPC;
 
-	/*
-	 * Client mode typically only has one configurable BSSID register,
-	 * which is used for bssidx=0. This is linked to the MAC address.
-	 * Since mac80211 allows changing interface types, and we cannot
-	 * force the use of the primary MAC address for a station mode
-	 * interface, we need some other way of configuring a per-interface
-	 * remote BSSID.
-	 * The hardware provides an AP-Client feature, where bssidx 0-7 are
-	 * used for AP mode and bssidx 8-15 for client mode.
-	 * We shift the station interface bss index by 8 to force the
-	 * hardware to recognize the BSSID.
-	 * The resulting bssidx mismatch for unicast frames is ignored by hw.
-	 */
-	if (vif->type == NL80211_IFTYPE_STATION)
-		idx += 8;
+	idx--;
+	dev->vif_mask |= BIT(idx);
+	mt76x2_mac_set_ext_mac(dev, idx, vif->addr);
 
 	mvif->idx = idx;
 	mvif->group_wcid.idx = 254 - idx;
@@ -114,8 +103,13 @@ mt76x2_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 static void
 mt76x2_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *)vif->drv_priv;
 	struct mt76x2_dev *dev = hw->priv;
+	int idx = mvif->idx;
 
+	mt76x2_mac_set_bssid(dev, mvif->idx, NULL);
+	mt76x2_mac_set_ext_mac(dev, idx, NULL);
+	dev->vif_mask &= ~BIT(idx);
 	mt76_txq_remove(&dev->mt76, vif->txq);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
index ce3ab85c8b0f..95c1e9559f1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
@@ -438,6 +438,14 @@
 
 #define MT_TX_SW_CFG3			0x1478
 
+#define MT_MAC_ADDR_EXT_CTL		0x147c
+#define MT_MAC_ADDR_EXT_CTL_EN		BIT(0)
+
+#define MT_MAC_ADDR_EXT_BASE		0x1480
+#define MT_MAC_ADDR_EXT_L(_n)		(MT_MAC_ADDR_EXT_BASE + ((_n) * 8))
+#define MT_MAC_ADDR_EXT_H(_n)		(MT_MAC_ADDR_EXT_BASE + ((_n) * 8 + 4))
+#define MT_MAC_ADDR_EXT_H_MASK		GENMASK(15, 0)
+
 #define MT_PN_PAD_MODE			0x150c
 
 #define MT_TXOP_HLDR_ET			0x1608
-- 
2.14.2
