Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50250 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935290AbeB1WUU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 17:20:20 -0500
Received: by mail-wm0-f65.google.com with SMTP id w128so8019258wmw.0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 14:20:20 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: remove unnecessary len variable in mt76x2_eeprom_load()
Date: Wed, 28 Feb 2018 23:20:12 +0100
Message-Id: <20180228222012.503-1-lorenzo.bianconi@redhat.com> (sfid-20180228_232024_024726_C8305941)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substitute unnecessary len variable in mt76x2_eeprom_load() with
MT7662_EEPROM_SIZE macro since len is used just to store eeprom
default size.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 9c9bf3e785ba..5bb50027c1e8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -222,11 +222,10 @@ static int
 mt76x2_eeprom_load(struct mt76x2_dev *dev)
 {
 	void *efuse;
-	int len = MT7662_EEPROM_SIZE;
 	bool found;
 	int ret;
 
-	ret = mt76_eeprom_init(&dev->mt76, len);
+	ret = mt76_eeprom_init(&dev->mt76, MT7662_EEPROM_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -234,14 +233,15 @@ mt76x2_eeprom_load(struct mt76x2_dev *dev)
 	if (found)
 		found = !mt76x2_check_eeprom(dev);
 
-	dev->mt76.otp.data = devm_kzalloc(dev->mt76.dev, len, GFP_KERNEL);
-	dev->mt76.otp.size = len;
+	dev->mt76.otp.data = devm_kzalloc(dev->mt76.dev, MT7662_EEPROM_SIZE,
+					  GFP_KERNEL);
+	dev->mt76.otp.size = MT7662_EEPROM_SIZE;
 	if (!dev->mt76.otp.data)
 		return -ENOMEM;
 
 	efuse = dev->mt76.otp.data;
 
-	if (mt76x2_get_efuse_data(dev, efuse, len))
+	if (mt76x2_get_efuse_data(dev, efuse, MT7662_EEPROM_SIZE))
 		goto out;
 
 	if (found) {
@@ -249,7 +249,7 @@ mt76x2_eeprom_load(struct mt76x2_dev *dev)
 	} else {
 		/* FIXME: check if efuse data is complete */
 		found = true;
-		memcpy(dev->mt76.eeprom.data, efuse, len);
+		memcpy(dev->mt76.eeprom.data, efuse, MT7662_EEPROM_SIZE);
 	}
 
 out:
-- 
2.16.2
