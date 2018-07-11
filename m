Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35394 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387401AbeGKUIf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 16:08:35 -0400
Received: by mail-wm0-f65.google.com with SMTP id v3-v6so3764300wmh.0
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jul 2018 13:02:39 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mt76x2: add frame protection support
Date: Wed, 11 Jul 2018 22:02:22 +0200
Message-Id: <20180711200222.23457-1-lorenzo.bianconi@redhat.com> (sfid-20180711_220247_641617_425B73D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce mac80211 rts threshold handler in order to add frame
protection support to mt76x2 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |  1 +
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   | 30 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_main.c  | 16 ++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 71fcfa44fb2e..40e57073923e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -222,6 +222,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			  u32 *tx_info);
 void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
+void mt76x2_mac_set_tx_protection(struct mt76x2_dev *dev, u32 val);
 
 void mt76x2_pre_tbtt_tasklet(unsigned long arg);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index fc9af79b3e69..e5e92f79f28a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -854,3 +854,33 @@ void mt76x2_mac_work(struct work_struct *work)
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
 }
+
+void mt76x2_mac_set_tx_protection(struct mt76x2_dev *dev, u32 val)
+{
+	u32 data = 0;
+
+	if (val != ~0)
+		data = FIELD_PREP(MT_PROT_CFG_CTRL, 1) |
+		       MT_PROT_CFG_RTS_THRESH;
+
+	mt76_rmw_field(dev, MT_TX_RTS_CFG, MT_TX_RTS_CFG_THRESH, val);
+
+	mt76_rmw(dev, MT_CCK_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_OFDM_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_MM20_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_MM40_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_GF20_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_GF40_PROT_CFG,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_TX_PROT_CFG6,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_TX_PROT_CFG7,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+	mt76_rmw(dev, MT_TX_PROT_CFG8,
+		 MT_PROT_CFG_CTRL | MT_PROT_CFG_RTS_THRESH, data);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 3c0ebe6d231c..1f4d3e5ae64b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -605,6 +605,21 @@ static int mt76x2_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant,
 	return 0;
 }
 
+static int
+mt76x2_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	if (val != ~0 && val > 0xffff)
+		return -EINVAL;
+
+	mutex_lock(&dev->mutex);
+	mt76x2_mac_set_tx_protection(dev, val);
+	mutex_unlock(&dev->mutex);
+
+	return 0;
+}
+
 const struct ieee80211_ops mt76x2_ops = {
 	.tx = mt76x2_tx,
 	.start = mt76x2_start,
@@ -631,5 +646,6 @@ const struct ieee80211_ops mt76x2_ops = {
 	.set_tim = mt76x2_set_tim,
 	.set_antenna = mt76x2_set_antenna,
 	.get_antenna = mt76x2_get_antenna,
+	.set_rts_threshold = mt76x2_set_rts_threshold,
 };
 
-- 
2.18.0
