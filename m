Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43266 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbeIJBX5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id k5-v6so19741575wre.10
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:33:04 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 09/11] mt76x02: add static qualifier to mt76x02_remove_dma_hdr
Date: Sun,  9 Sep 2018 22:32:44 +0200
Message-Id: <20180909203246.21608-10-lorenzo.bianconi@redhat.com> (sfid-20180909_223308_203218_959A8BBF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add static qualifier to mt76x02_remove_dma_hdr routine and
do not export the symbol since it is only used in mt76x02_util.c

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 3 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h | 1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a14d7dba628b..3a3d355b9e61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -407,7 +407,7 @@ void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len)
 }
 EXPORT_SYMBOL_GPL(mt76x02_remove_hdr_pad);
 
-void mt76x02_remove_dma_hdr(struct sk_buff *skb)
+static void mt76x02_remove_dma_hdr(struct sk_buff *skb)
 {
 	int hdr_len;
 
@@ -416,7 +416,6 @@ void mt76x02_remove_dma_hdr(struct sk_buff *skb)
 	if (hdr_len % 4)
 		mt76x02_remove_hdr_pad(skb, 2);
 }
-EXPORT_SYMBOL_GPL(mt76x02_remove_dma_hdr);
 
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 48307ef2c380..2ea9e68bfa3f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -48,7 +48,6 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
 int mt76x02_insert_hdr_pad(struct sk_buff *skb);
 void mt76x02_remove_hdr_pad(struct sk_buff *skb, int len);
 void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
-void mt76x02_remove_dma_hdr(struct sk_buff *skb);
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
-- 
2.18.0
