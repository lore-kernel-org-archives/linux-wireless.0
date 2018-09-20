Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40261 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387441AbeITOzB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207-v6so9998776wme.5
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 06/20] mt76: move mt76x02_mac_setaddr in mt76x02-lib module
Date: Thu, 20 Sep 2018 11:11:53 +0200
Message-Id: <ea07bdd7425e1740a85d55107a5468065c785466.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_111252_204908_BA6920B2)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x02_mac_setaddr utility routine in mt76x02-lib
module and remove duplicated code. This is a preliminary patch
to unify eeprom code between mt76x2 and mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 24 +------------------
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 18 ++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |  1 -
 .../net/wireless/mediatek/mt76/mt76x2u_init.c |  3 ++-
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  | 18 --------------
 .../net/wireless/mediatek/mt76/mt76x2u_main.c |  2 +-
 7 files changed, 23 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index c935d98f5710..a93da6c5ce59 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -131,28 +131,6 @@ mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
 	dev_dbg(dev->mt76.dev, "PA Type %d\n", dev->ee->pa_type);
 }
 
-static int
-mt76x0_set_macaddr(struct mt76x0_dev *dev, const u8 *eeprom)
-{
-	const void *src = eeprom + MT_EE_MAC_ADDR;
-	u8 *dst = dev->mt76.macaddr;
-
-	ether_addr_copy(dev->mt76.macaddr, src);
-
-	if (!is_valid_ether_addr(dst)) {
-		eth_random_addr(dst);
-		dev_info(dev->mt76.dev,
-			 "Invalid MAC address, using random address %pM\n",
-			 dst);
-	}
-
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dst));
-	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dst + 4) |
-		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
-
-	return 0;
-}
-
 static void
 mt76x0_set_temp_offset(struct mt76x0_dev *dev, u8 *eeprom)
 {
@@ -409,7 +387,7 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 	dev_info(dev->mt76.dev, "EEPROM ver:%02hhx fae:%02hhx\n",
 		 eeprom[MT_EE_VERSION + 1], eeprom[MT_EE_VERSION]);
 
-	mt76x0_set_macaddr(dev, eeprom);
+	mt76x02_mac_setaddr(&dev->mt76, eeprom + MT_EE_MAC_ADDR);
 	mt76x0_set_chip_cap(dev, eeprom);
 	mt76x0_set_country_reg(dev, eeprom);
 	mt76x0_set_rf_freq_off(dev, eeprom);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 0b12299c7a41..df4366a702c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -502,3 +502,21 @@ mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_process_rate);
+
+void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr)
+{
+	ether_addr_copy(dev->macaddr, addr);
+
+	if (!is_valid_ether_addr(dev->macaddr)) {
+		eth_random_addr(dev->macaddr);
+		dev_info(dev->dev,
+			 "Invalid MAC address, using random address %pM\n",
+			 dev->macaddr);
+	}
+
+	__mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
+	__mt76_wr(dev, MT_MAC_ADDR_DW1,
+		  get_unaligned_le16(dev->macaddr + 4) |
+		  FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 1a5da35702e6..f12ecbe15d8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -202,4 +202,5 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 			   struct mt76x02_tx_status *stat, u8 *update);
 int
 mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
+void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
index a0ff6472de1f..74fde9f107e1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -36,7 +36,6 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev);
 void mt76x2u_cleanup(struct mt76x2_dev *dev);
 void mt76x2u_stop_hw(struct mt76x2_dev *dev);
 
-void mt76x2u_mac_setaddr(struct mt76x2_dev *dev, u8 *addr);
 int mt76x2u_mac_reset(struct mt76x2_dev *dev);
 void mt76x2u_mac_resume(struct mt76x2_dev *dev);
 int mt76x2u_mac_start(struct mt76x2_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
index e41880c43fa7..89cfacfb276c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -212,7 +212,8 @@ int mt76x2u_init_hardware(struct mt76x2_dev *dev)
 	if (err < 0)
 		return err;
 
-	mt76x2u_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	mt76x02_mac_setaddr(&dev->mt76,
+			    dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
 	dev->mt76.rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
 
 	mt76x2u_init_beacon_offsets(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
index b59336110746..0f5d781b13dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
@@ -220,21 +220,3 @@ void mt76x2u_mac_resume(struct mt76x2_dev *dev)
 	mt76_set(dev, MT_TXOP_CTRL_CFG, BIT(20));
 	mt76_set(dev, MT_TXOP_HLDR_ET, BIT(1));
 }
-
-void mt76x2u_mac_setaddr(struct mt76x2_dev *dev, u8 *addr)
-{
-	ether_addr_copy(dev->mt76.macaddr, addr);
-
-	if (!is_valid_ether_addr(dev->mt76.macaddr)) {
-		eth_random_addr(dev->mt76.macaddr);
-		dev_info(dev->mt76.dev,
-			 "Invalid MAC address, using random address %pM\n",
-			 dev->mt76.macaddr);
-	}
-
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->mt76.macaddr));
-	mt76_wr(dev, MT_MAC_ADDR_DW1,
-		get_unaligned_le16(dev->mt76.macaddr + 4) |
-		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
-}
-
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index c6855549c312..620aeb3eb79f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -51,7 +51,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	struct mt76x2_dev *dev = hw->priv;
 
 	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
-		mt76x2u_mac_setaddr(dev, vif->addr);
+		mt76x02_mac_setaddr(&dev->mt76, vif->addr);
 
 	mt76x02_vif_init(&dev->mt76, vif, 0);
 	return 0;
-- 
2.17.1
