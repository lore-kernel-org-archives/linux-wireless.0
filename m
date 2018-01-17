Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:43482 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbeAQLBe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 06:01:34 -0500
Received: by mail-wm0-f66.google.com with SMTP id g1so14282627wmg.2
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jan 2018 03:01:33 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, gaetano.catalli@gmail.com
Subject: [PATCH] mt76x2: fix WMM parameter configuration
Date: Wed, 17 Jan 2018 12:01:27 +0100
Message-Id: <7554b3527fd55afa7561ffc89fb7f3bea1a902ed.1516186517.git.lorenzo.bianconi@redhat.com> (sfid-20180117_120138_568947_4085610A)
In-Reply-To: <cover.1516186517.git.lorenzo.bianconi@redhat.com>
References: <cover.1516186517.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix hw queue configuration since mt76x2 devices use a reverse queue
enumeration respect to mac80211 one:
 - 0: AC_BE
 - 1: AC_BK
 - 2: AC_VI
 - 3: AC_VO

The issue can be reproduced sending two concurrent flow using
two separate queues:
 - VO: 20Mbps UDP traffic
 - BE: TCP traffic

In this scenario the UDP traffic will be blocked by the TCP one.
Fix it configuring properly WMM hw queue parameters

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Tested-by: Gaetano Catalli <gaetano.catalli@gmail.com>
Signed-off-by: Gaetano Catalli <gaetano.catalli@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c  |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c | 26 +++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 0a3f729a7156..fd1ec4743e0b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -55,6 +55,7 @@ mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 
 	q->regs = dev->mt76.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
+	q->hw_idx = idx;
 
 	ret = mt76_queue_alloc(dev, q);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 963aea9e8801..edaaa053c43c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -380,9 +380,11 @@ mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	       const struct ieee80211_tx_queue_params *params)
 {
 	struct mt76x2_dev *dev = hw->priv;
-	u8 cw_min = 5, cw_max = 10;
+	u8 cw_min = 5, cw_max = 10, qid;
 	u32 val;
 
+	qid = dev->mt76.q_tx[queue].hw_idx;
+
 	if (params->cw_min)
 		cw_min = fls(params->cw_min);
 	if (params->cw_max)
@@ -392,26 +394,26 @@ mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	      FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
 	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
 	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
-	mt76_wr(dev, MT_EDCA_CFG_AC(queue), val);
+	mt76_wr(dev, MT_EDCA_CFG_AC(qid), val);
 
-	val = mt76_rr(dev, MT_WMM_TXOP(queue));
-	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(queue));
-	val |= params->txop << MT_WMM_TXOP_SHIFT(queue);
-	mt76_wr(dev, MT_WMM_TXOP(queue), val);
+	val = mt76_rr(dev, MT_WMM_TXOP(qid));
+	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(qid));
+	val |= params->txop << MT_WMM_TXOP_SHIFT(qid);
+	mt76_wr(dev, MT_WMM_TXOP(qid), val);
 
 	val = mt76_rr(dev, MT_WMM_AIFSN);
-	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(queue));
-	val |= params->aifs << MT_WMM_AIFSN_SHIFT(queue);
+	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(qid));
+	val |= params->aifs << MT_WMM_AIFSN_SHIFT(qid);
 	mt76_wr(dev, MT_WMM_AIFSN, val);
 
 	val = mt76_rr(dev, MT_WMM_CWMIN);
-	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(queue));
-	val |= cw_min << MT_WMM_CWMIN_SHIFT(queue);
+	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(qid));
+	val |= cw_min << MT_WMM_CWMIN_SHIFT(qid);
 	mt76_wr(dev, MT_WMM_CWMIN, val);
 
 	val = mt76_rr(dev, MT_WMM_CWMAX);
-	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(queue));
-	val |= cw_max << MT_WMM_CWMAX_SHIFT(queue);
+	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(qid));
+	val |= cw_max << MT_WMM_CWMAX_SHIFT(qid);
 	mt76_wr(dev, MT_WMM_CWMAX, val);
 
 	return 0;
-- 
2.13.6
