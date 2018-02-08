Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39669 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbeBHWI0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 17:08:26 -0500
Received: by mail-wm0-f66.google.com with SMTP id b21so12790603wme.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 14:08:25 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: kubakici@wp.pl
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt7601u: move mt7601u_set_macaddr in mac related code
Date: Thu,  8 Feb 2018 23:08:08 +0100
Message-Id: <05bb725e26b34bfc88b515110b0fcfb2c6b2303e.1518126991.git.lorenzo.bianconi@redhat.com> (sfid-20180208_230829_921133_992965E8)
In-Reply-To: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
References: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove static qualifier from mt7601u_set_macaddr routine and move it
in mac related code in order to be used to properly support vif with
different mac address respect to the default one

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/eeprom.c | 24 ++----------------------
 drivers/net/wireless/mediatek/mt7601u/mac.c    | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt7601u/mac.h    |  1 +
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
index da6faea092d6..05d729be0c65 100644
--- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
@@ -19,6 +19,7 @@
 #include <asm/unaligned.h>
 #include "mt7601u.h"
 #include "eeprom.h"
+#include "mac.h"
 
 static bool
 field_valid(u8 val)
@@ -134,27 +135,6 @@ mt7601u_set_chip_cap(struct mt7601u_dev *dev, u8 *eeprom)
 			"Error: device has more than 1 RX/TX stream!\n");
 }
 
-static int
-mt7601u_set_macaddr(struct mt7601u_dev *dev, const u8 *eeprom)
-{
-	const void *src = eeprom + MT_EE_MAC_ADDR;
-
-	ether_addr_copy(dev->macaddr, src);
-
-	if (!is_valid_ether_addr(dev->macaddr)) {
-		eth_random_addr(dev->macaddr);
-		dev_info(dev->dev,
-			 "Invalid MAC address, using random address %pM\n",
-			 dev->macaddr);
-	}
-
-	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
-	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dev->macaddr + 4) |
-		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
-
-	return 0;
-}
-
 static void mt7601u_set_channel_target_power(struct mt7601u_dev *dev,
 					     u8 *eeprom, u8 max_pwr)
 {
@@ -400,7 +380,7 @@ mt7601u_eeprom_init(struct mt7601u_dev *dev)
 	dev_info(dev->dev, "EEPROM ver:%02hhx fae:%02hhx\n",
 		 eeprom[MT_EE_VERSION_EE], eeprom[MT_EE_VERSION_FAE]);
 
-	mt7601u_set_macaddr(dev, eeprom);
+	mt7601u_set_macaddr(dev, eeprom + MT_EE_MAC_ADDR);
 	mt7601u_set_chip_cap(dev, eeprom);
 	mt7601u_set_channel_power(dev, eeprom);
 	mt7601u_set_country_reg(dev, eeprom);
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index d6dc59bb00df..4d3077941138 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -16,6 +16,22 @@
 #include "trace.h"
 #include <linux/etherdevice.h>
 
+void mt7601u_set_macaddr(struct mt7601u_dev *dev, const u8 *addr)
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
+	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->macaddr));
+	mt76_wr(dev, MT_MAC_ADDR_DW1, get_unaligned_le16(dev->macaddr + 4) |
+		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+}
+
 static void
 mt76_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate)
 {
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.h b/drivers/net/wireless/mediatek/mt7601u/mac.h
index 2c22d63c63a2..b7aa24656d0e 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.h
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.h
@@ -174,5 +174,6 @@ u16 mt76_mac_tx_rate_val(struct mt7601u_dev *dev,
 struct mt76_tx_status
 mt7601u_mac_fetch_tx_status(struct mt7601u_dev *dev);
 void mt76_send_tx_status(struct mt7601u_dev *dev, struct mt76_tx_status *stat);
+void mt7601u_set_macaddr(struct mt7601u_dev *dev, const u8 *addr);
 
 #endif
-- 
2.14.3
