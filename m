Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50776 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754093AbeD3OM7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:12:59 -0400
Received: by mail-wm0-f66.google.com with SMTP id t11so13468658wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:12:59 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC 06/18] mt76x2: introduce mt76x2_mac_load_tx_status routine
Date: Mon, 30 Apr 2018 16:12:21 +0200
Message-Id: <9d50bf4d74ec52e141dd112768570e15a481ad2e.1525096206.git.lorenzo.bianconi@redhat.com> (sfid-20180430_161303_896097_7E5B69E9)
In-Reply-To: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add mt76x2_mac_load_tx_status routine since tx stats register map is
shared between usb and pci based devices but usb devices do not have a
tx stat irq line as pcie ones and it is necessary to load tx statistics
using a workqueue

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 43 +++++++++++++++----------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index d18315652583..0ddc84525ffa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -515,6 +515,28 @@ mt76x2_send_tx_status(struct mt76x2_dev *dev, struct mt76x2_tx_status *stat,
 	rcu_read_unlock();
 }
 
+static struct mt76x2_tx_status
+mt76x2_mac_load_tx_status(struct mt76x2_dev *dev)
+{
+	struct mt76x2_tx_status stat = {};
+	u32 stat1, stat2;
+
+	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
+	stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
+
+	stat.valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
+	stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
+	stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
+	stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
+	stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
+	stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
+
+	stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
+	stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
+
+	return stat;
+}
+
 void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 {
 	struct mt76x2_tx_status stat = {};
@@ -527,26 +549,13 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
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
+		stat = mt76x2_mac_load_tx_status(dev);
 		spin_unlock_irqrestore(&dev->irq_lock, flags);
 
-		stat.valid = 1;
-		stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
-		stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
-		stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
-		stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
-		stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
-		stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
-		stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
+		if (!stat.valid)
+			break;
+
 		trace_mac_txstat_fetch(dev, &stat);
 
 		if (!irq) {
-- 
2.14.3
