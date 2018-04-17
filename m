Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46473 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750811AbeDQW10 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 18:27:26 -0400
Received: by mail-wr0-f196.google.com with SMTP id d1so39606765wrj.13
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 15:27:25 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: fix is_mt7612 routine
Date: Wed, 18 Apr 2018 00:27:18 +0200
Message-Id: <20180417222718.17039-1-lorenzo.bianconi@redhat.com> (sfid-20180418_002729_347399_AF75BCEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix is_mt7612 routine since asic version is set in mt76_dev revision
field and not in mt76x2_dev one.
Moreover remove mt76x2_dev rev field since it is never used in the
driver

Fixes: 7bc04215a66b ('mt76: add driver code for MT76x2e')
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 783b8122ec3c..a5d1255e4b9c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -117,7 +117,6 @@ struct mt76x2_dev {
 	u8 beacon_mask;
 	u8 beacon_data_mask;
 
-	u32 rev;
 	u32 rxfilter;
 
 	u16 chainmask;
@@ -151,7 +150,7 @@ struct mt76x2_sta {
 
 static inline bool is_mt7612(struct mt76x2_dev *dev)
 {
-	return (dev->rev >> 16) == 0x7612;
+	return mt76_chip(&dev->mt76) == 0x7612;
 }
 
 void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set);
-- 
2.16.3
