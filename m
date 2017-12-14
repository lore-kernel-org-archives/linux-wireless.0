Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45538 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753320AbdLNPjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 11/14] mt76x2: drop wiphy->addresses
Date: Thu, 14 Dec 2017 16:39:15 +0100
Message-Id: <20171214153918.43774-12-nbd@nbd.name> (sfid-20171214_163948_273063_1F4A50EC)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the MAC address limitation is resolved, we no longer need a MAC
address list

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h      |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 16 +---------------
 2 files changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a993cc09cd1b..7f961cc4504a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -84,8 +84,6 @@ struct mt76x2_calibration {
 struct mt76x2_dev {
 	struct mt76_dev mt76; /* must be first */
 
-	struct mac_address macaddr_list[8];
-
 	struct mutex mutex;
 
 	const u16 *beacon_offsets;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index f54dc67a13d0..818164d1ed7a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -796,7 +796,7 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	struct wiphy *wiphy = hw->wiphy;
 	void *status_fifo;
 	int fifo_size;
-	int i, ret;
+	int ret;
 
 	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x2_tx_status));
 	status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
@@ -818,20 +818,6 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	hw->sta_data_size = sizeof(struct mt76x2_sta);
 	hw->vif_data_size = sizeof(struct mt76x2_vif);
 
-	for (i = 0; i < ARRAY_SIZE(dev->macaddr_list); i++) {
-		u8 *addr = dev->macaddr_list[i].addr;
-
-		memcpy(addr, dev->mt76.macaddr, ETH_ALEN);
-
-		if (!i)
-			continue;
-
-		addr[0] |= BIT(1);
-		addr[0] ^= ((i - 1) << 2);
-	}
-	wiphy->addresses = dev->macaddr_list;
-	wiphy->n_addresses = ARRAY_SIZE(dev->macaddr_list);
-
 	wiphy->iface_combinations = if_comb;
 	wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
 
-- 
2.14.2
