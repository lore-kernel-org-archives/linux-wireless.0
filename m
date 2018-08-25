Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40420 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbeHYOTw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 25 Aug 2018 10:19:52 -0400
Received: by mail-wm0-f66.google.com with SMTP id 207-v6so3837979wme.5
        for <linux-wireless@vger.kernel.org>; Sat, 25 Aug 2018 03:41:17 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 14/16] mt76x0: remove unused mt76x0_mcu structure
Date: Sat, 25 Aug 2018 12:40:54 +0200
Message-Id: <20180825104056.9130-15-lorenzo.bianconi@redhat.com> (sfid-20180825_124129_318382_BB4EBD8B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove no longer used mt76x0_mcu data structure

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c   |  2 --
 .../net/wireless/mediatek/mt76/mt76x0/mt76x0.h    | 15 ---------------
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 39b2ec0c1ee0..d49557834658 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -452,8 +452,6 @@ int mt76x0_mcu_init(struct mt76x0_dev *dev)
 {
 	int ret;
 
-	mutex_init(&dev->mcu.mutex);
-
 	ret = mt76x0_load_firmware(dev);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 298b7af31911..cdace0565d51 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -49,19 +49,6 @@ struct mt76x0_dma_buf {
 	size_t len;
 };
 
-struct mt76x0_mcu {
-	struct mutex mutex;
-
-	u8 msg_seq;
-
-	struct mt76x0_dma_buf resp;
-
-	struct mt76_reg_pair *reg_pairs;
-	unsigned int reg_pairs_len;
-	u32 reg_base;
-	bool burst_read;
-};
-
 struct mac_stats {
 	u64 rx_stat[6];
 	u64 tx_stat[6];
@@ -160,8 +147,6 @@ struct mt76x0_dev {
 	unsigned long wcid_mask[DIV_ROUND_UP(N_WCIDS, BITS_PER_LONG)];
 	unsigned long vif_mask;
 
-	struct mt76x0_mcu mcu;
-
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
 
-- 
2.18.0
