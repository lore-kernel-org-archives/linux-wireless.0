Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:45520 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751092AbdLNKqI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 05:46:08 -0500
Received: by mail-wm0-f67.google.com with SMTP id 9so10376816wme.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Dec 2017 02:46:07 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: colin.king@canonical.com, linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()
Date: Thu, 14 Dec 2017 11:46:02 +0100
Message-Id: <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com> (sfid-20171214_114611_706137_BD7DB44B)
In-Reply-To: <cover.1513248071.git.lorenzo.bianconi@redhat.com>
References: <cover.1513248071.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix typo in 5GHz power vs channel eeprom parsing

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
index 440b7e7d73a9..29dc52ef629d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_eeprom.c
@@ -524,7 +524,7 @@ mt76x2_get_power_info_5g(struct mt76x2_dev *dev, struct mt76x2_tx_power_info *t,
 
 	if (channel >= 192)
 		delta_idx = 4;
-	else if (channel >= 484)
+	else if (channel >= 184)
 		delta_idx = 3;
 	else if (channel < 44)
 		delta_idx = 3;
-- 
2.13.6
