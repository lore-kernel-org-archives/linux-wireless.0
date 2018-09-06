Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728096AbeIFNzC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:55:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 35/42] mt76x0: remove has_{2,5}ghz fields of mt76x0_eeprom_params
Date: Thu,  6 Sep 2018 11:18:51 +0200
Message-Id: <1536225538-16454-36-git-send-email-sgruszka@redhat.com> (sfid-20180906_112035_338860_ABA5C05E)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Remove has_2ghz/has_5ghz fields of mt76x0_eeprom_params data
structure and use mt76_dev ones. This is a preliminary patch
to use shared routines for device allocation

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 11 ++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |  3 ---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 36da1e6bc21a..0fd178d84277 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -123,18 +123,19 @@ mt76x0_set_chip_cap(struct mt76x0_dev *dev, u8 *eeprom)
 
 	switch (FIELD_GET(MT_EE_NIC_CONF_0_BOARD_TYPE, nic_conf0)) {
 	case BOARD_TYPE_5GHZ:
-		dev->ee->has_5ghz = true;
+		dev->mt76.cap.has_5ghz = true;
 		break;
 	case BOARD_TYPE_2GHZ:
-		dev->ee->has_2ghz = true;
+		dev->mt76.cap.has_2ghz = true;
 		break;
 	default:
-		dev->ee->has_2ghz = true;
-		dev->ee->has_5ghz = true;
+		dev->mt76.cap.has_2ghz = true;
+		dev->mt76.cap.has_5ghz = true;
 		break;
 	}
 
-	dev_dbg(dev->mt76.dev, "Has 2GHZ %d 5GHZ %d\n", dev->ee->has_2ghz, dev->ee->has_5ghz);
+	dev_dbg(dev->mt76.dev, "Has 2GHZ %d 5GHZ %d\n",
+		dev->mt76.cap.has_2ghz, dev->mt76.cap.has_5ghz);
 
 	if (!field_valid(nic_conf1 & 0xff))
 		nic_conf1 &= 0xff00;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
index e37b573aed7b..cd0f14361405 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h
@@ -112,9 +112,6 @@ struct mt76x0_eeprom_params {
 	u8 tx_pwr_per_chan[58];
 
 	struct reg_channel_bounds reg;
-
-	bool has_2ghz;
-	bool has_5ghz;
 };
 
 int mt76x0_eeprom_init(struct mt76x0_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 8f4b3197ab95..d075b29977e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -662,13 +662,13 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
-	if (dev->ee->has_2ghz) {
+	if (dev->mt76.cap.has_2ghz) {
 		ret = mt76_init_sband_2g(dev);
 		if (ret)
 			return ret;
 	}
 
-	if (dev->ee->has_5ghz) {
+	if (dev->mt76.cap.has_5ghz) {
 		ret = mt76_init_sband_5g(dev);
 		if (ret)
 			return ret;
-- 
2.7.5
