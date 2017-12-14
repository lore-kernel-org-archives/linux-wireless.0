Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45550 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753335AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 10/14] mt76x2: clean up MAC/BSSID address initialization
Date: Thu, 14 Dec 2017 16:39:14 +0100
Message-Id: <20171214153918.43774-11-nbd@nbd.name> (sfid-20171214_163935_518794_8DE30AAD)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drop the use of the EEPROM address entirely, rely on interface address
only

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 11 ++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 14 ++++++++++++++
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index ac4eeaf2c993..f54dc67a13d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -231,7 +231,6 @@ mt76x2_init_beacon_offsets(struct mt76x2_dev *dev)
 int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 {
 	static const u8 null_addr[ETH_ALEN] = {};
-	const u8 *macaddr = dev->mt76.macaddr;
 	u32 val;
 	int i, k;
 
@@ -271,13 +270,11 @@ int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 	mt76_wr(dev, MT_MCU_CLOCK_CTL, 0x1401);
 	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
 
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(macaddr));
-	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(macaddr + 4));
+	mt76_wr(dev, MT_MAC_ADDR_DW0, 0);
+	mt76_wr(dev, MT_MAC_ADDR_DW1, 0);
 
-	mt76_wr(dev, MT_MAC_BSSID_DW0, get_unaligned_le32(macaddr));
-	mt76_wr(dev, MT_MAC_BSSID_DW1, get_unaligned_le16(macaddr + 4) |
-		FIELD_PREP(MT_MAC_BSSID_DW1_MBSS_MODE, 3) | /* 8 beacons */
-		MT_MAC_BSSID_DW1_MBSS_LOCAL_BIT);
+	mt76_wr(dev, MT_MAC_BSSID_DW0, 0);
+	mt76_wr(dev, MT_MAC_BSSID_DW1, 0);
 
 	mt76_set(dev, MT_MAC_ADDR_EXT_CTL, MT_MAC_ADDR_EXT_CTL_EN);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 60cee4abed7c..d2ae093b7092 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -27,6 +27,15 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 	if (addr) {
 		lo = get_unaligned_le32(addr);
 		hi = get_unaligned_le16(addr + 4);
+
+		if (!idx) {
+			mt76_wr(dev, MT_MAC_BSSID_DW0, lo);
+
+			mt76_rmw_field(dev, MT_MAC_BSSID_DW1,
+				       MT_MAC_BSSID_DW1_ADDR,
+				       hi);
+		}
+
 		hi |= MT_MAC_APC_BSSID0_H_EN;
 	}
 
@@ -41,6 +50,11 @@ void mt76x2_mac_set_ext_mac(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 	if (addr) {
 		lo = get_unaligned_le32(addr);
 		hi = get_unaligned_le16(addr + 4);
+
+		if (!idx) {
+			mt76_wr(dev, MT_MAC_ADDR_DW0, lo);
+			mt76_wr(dev, MT_MAC_ADDR_DW1, hi);
+		}
 	}
 
 	mt76_wr(dev, MT_MAC_ADDR_EXT_L(idx), lo);
-- 
2.14.2
