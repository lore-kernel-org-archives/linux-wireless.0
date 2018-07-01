Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40342 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752416AbeGAONK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 10:13:10 -0400
Received: by mail-wr0-f196.google.com with SMTP id t6-v6so686747wrn.7
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2018 07:13:09 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 06/19] mt76x2: introduce mt76x2_mac_load_tx_status routine
Date: Sun,  1 Jul 2018 16:12:18 +0200
Message-Id: <20180701141231.25323-7-lorenzo.bianconi@redhat.com> (sfid-20180701_161320_566155_1E8BD132)
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
index fc9af79b3e69..7dceadd279a1 100644
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
2.18.0
