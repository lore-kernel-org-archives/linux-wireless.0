Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43808 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbeGaJsj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:39 -0400
Received: by mail-wr1-f67.google.com with SMTP id b15-v6so15598616wrv.10
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:30 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 06/19] mt76x2: introduce mt76x2_mac_load_tx_status routine
Date: Tue, 31 Jul 2018 10:09:07 +0200
Message-Id: <51b6f31569c15c6354051d79f16d5423ce0ecc8e.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100936_067730_3D3E8624)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x2_mac_load_tx_status routine since tx stats register map is
shared between usb and pci based devices but usb devices do not have a
tx stat irq line as pcie ones and it is necessary to load tx statistics
using a workqueue

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x2_mac.c   | 47 ++++++++++++-------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index e5e92f79f28a..bff0b7268467 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -532,11 +532,37 @@ mt76x2_send_tx_status(struct mt76x2_dev *dev, struct mt76x2_tx_status *stat,
 	rcu_read_unlock();
 }
 
+static bool
+mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
+			  struct mt76x2_tx_status *stat)
+{
+	u32 stat1, stat2;
+
+	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
+	stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
+
+	stat->valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
+	if (!stat->valid)
+		return false;
+
+	stat->success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
+	stat->aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
+	stat->ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
+	stat->wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
+	stat->rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
+
+	stat->retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
+	stat->pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
+
+	return true;
+}
+
 void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 {
 	struct mt76x2_tx_status stat = {};
 	unsigned long flags;
 	u8 update = 1;
+	bool ret;
 
 	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
 		return;
@@ -544,26 +570,13 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 	trace_mac_txstat_poll(dev);
 
 	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
-		u32 stat1, stat2;
-
 		spin_lock_irqsave(&dev->irq_lock, flags);
-		stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
-		stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
-		if (!(stat1 & MT_TX_STAT_FIFO_VALID)) {
-			spin_unlock_irqrestore(&dev->irq_lock, flags);
-			break;
-		}
-
+		ret = mt76x2_mac_load_tx_status(dev, &stat);
 		spin_unlock_irqrestore(&dev->irq_lock, flags);
 
-		stat.valid = 1;
-		stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
-		stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
-		stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
-		stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
-		stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
-		stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
-		stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
+		if (!ret)
+			break;
+
 		trace_mac_txstat_fetch(dev, &stat);
 
 		if (!irq) {
-- 
2.17.1
