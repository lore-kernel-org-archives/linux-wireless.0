Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36438 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387496AbeITOzK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 10:55:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id e1-v6so8601585wrt.3
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 02:12:41 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 16/20] mt76x0: unify parse hw capabilities
Date: Thu, 20 Sep 2018 11:12:03 +0200
Message-Id: <d93440ac8cf0c77e43c9a19706455c98ef242e14.1537433365.git.lorenzo.bianconi@redhat.com> (sfid-20180920_112418_034419_4E45D589)
In-Reply-To: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
References: <cover.1537433365.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify parse hw capabilities with mt76x2 driver using
mt76x02_eeprom_parse_hw_cap utility routine available
in mt76x02-lib module

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 33 +++++--------------
 1 file changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 70dd96051e77..f9d917a7f3f5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -51,29 +51,13 @@ mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
 	return 0;
 }
 
-static void
-mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
+static void mt76x0_set_chip_cap(struct mt76x0_dev *dev)
 {
-	enum mt76x2_board_type { BOARD_TYPE_2GHZ = 1, BOARD_TYPE_5GHZ = 2 };
-	u16 nic_conf0 = get_unaligned_le16(eeprom + MT_EE_NIC_CONF_0);
-	u16 nic_conf1 = get_unaligned_le16(eeprom + MT_EE_NIC_CONF_1);
-
-	dev_dbg(dev->mt76.dev, "NIC_CONF0: %04x NIC_CONF1: %04x\n", nic_conf0, nic_conf1);
-
-	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, nic_conf0)) {
-	case BOARD_TYPE_5GHZ:
-		dev->mt76.cap.has_5ghz = true;
-		break;
-	case BOARD_TYPE_2GHZ:
-		dev->mt76.cap.has_2ghz = true;
-		break;
-	default:
-		dev->mt76.cap.has_2ghz = true;
-		dev->mt76.cap.has_5ghz = true;
-		break;
-	}
+	u16 nic_conf0 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_0);
+	u16 nic_conf1 = mt76x02_eeprom_get(&dev->mt76, MT_EE_NIC_CONF_1);
 
-	dev_dbg(dev->mt76.dev, "Has 2GHZ %d 5GHZ %d\n",
+	mt76x02_eeprom_parse_hw_cap(&dev->mt76);
+	dev_dbg(dev->mt76.dev, "2GHz %d 5GHz %d\n",
 		dev->mt76.cap.has_2ghz, dev->mt76.cap.has_5ghz);
 
 	if (!mt76x02_field_valid(nic_conf1 & 0xff))
@@ -81,15 +65,14 @@ mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
 
 	if (nic_conf1 & MT_EE_NIC_CONF_1_HW_RF_CTRL)
 		dev_err(dev->mt76.dev,
-			"Error: this driver does not support HW RF ctrl\n");
+			"driver does not support HW RF ctrl\n");
 
 	if (!mt76x02_field_valid(nic_conf0 >> 8))
 		return;
 
 	if (FIELD_GET(MT_EE_NIC_CONF_0_RX_PATH, nic_conf0) > 1 ||
 	    FIELD_GET(MT_EE_NIC_CONF_0_TX_PATH, nic_conf0) > 1)
-		dev_err(dev->mt76.dev,
-			"Error: device has more than 1 RX/TX stream!\n");
+		dev_err(dev->mt76.dev, "invalid tx-rx stream\n");
 }
 
 static void mt76x0_set_temp_offset(struct mt76x0_dev *dev)
@@ -283,7 +266,7 @@ mt76x0_eeprom_init(struct mt76x0_dev *dev)
 		 eeprom[MT_EE_VERSION + 1], eeprom[MT_EE_VERSION]);
 
 	mt76x02_mac_setaddr(&dev->mt76, eeprom + MT_EE_MAC_ADDR);
-	mt76x0_set_chip_cap(dev, eeprom);
+	mt76x0_set_chip_cap(dev);
 	mt76x0_set_freq_offset(dev);
 	mt76x0_set_temp_offset(dev);
 	dev->chainmask = 0x0101;
-- 
2.17.1
