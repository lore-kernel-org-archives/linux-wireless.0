Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48898 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:01 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 16/22] mt76: unify load_tx_status
Date: Tue,  4 Sep 2018 16:41:09 +0200
Message-Id: <1536072075-6990-17-git-send-email-sgruszka@redhat.com> (sfid-20180904_164254_036601_859067ED)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unify load/fetch tx status from mt76x0 and mt76x2

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 21 ------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  3 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 25 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 25 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |  2 +-
 8 files changed, 30 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 46646a7461bd..41f681cfc5ef 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -116,27 +116,6 @@ mt76_mac_fill_tx_status(struct mt76x0_dev *dev, struct ieee80211_tx_info *info,
 		info->flags |= IEEE80211_TX_STAT_ACK;
 }
 
-struct mt76x02_tx_status mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev)
-{
-	struct mt76x02_tx_status stat = {};
-	u32 stat2, stat1;
-
-	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
-	stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
-
-	stat.valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
-	stat.success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
-	stat.aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
-	stat.ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
-	stat.wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
-	stat.rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
-
-	stat.retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
-	stat.pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
-
-	return stat;
-}
-
 void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *stat, u8 *update)
 {
 	struct ieee80211_tx_info info = {};
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index c94b9cf4231d..9270469a580d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -190,8 +190,7 @@ void mt76x0_tx_stat(struct work_struct *work)
 	u8 update = 1;
 
 	while (!test_bit(MT76_REMOVED, &dev->mt76.state)) {
-		stat = mt76x0_mac_fetch_tx_status(dev);
-		if (!stat.valid)
+		if (!mt76x02_mac_load_tx_status(&dev->mt76, &stat))
 			break;
 
 		mt76x0_send_tx_status(dev, &stat, &update);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index d67e12bd23a7..ea1f77579b7c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -216,3 +216,28 @@ void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
 	wcid->tx_rate_set = true;
 	spin_unlock_bh(&dev->lock);
 }
+
+bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
+			       struct mt76x02_tx_status *stat)
+{
+	u32 stat1, stat2;
+
+	stat2 = __mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
+	stat1 = __mt76_rr(dev, MT_TX_STAT_FIFO);
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
+EXPORT_SYMBOL_GPL(mt76x02_mac_load_tx_status);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 498b2b293d20..0547f7db9d3d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -195,4 +195,6 @@ void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
 __le16
 mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 		       const struct ieee80211_tx_rate *rate, u8 *nss_val);
+bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
+			       struct mt76x02_tx_status *stat);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index faf830585515..0a29e7ae1a9d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -241,8 +241,6 @@ void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
 
 int mt76x2_insert_hdr_pad(struct sk_buff *skb);
 
-bool mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
-			       struct mt76x02_tx_status *stat);
 void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 			   struct mt76x02_tx_status *stat, u8 *update);
 void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 0d37d0de0b84..b346f17e49d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -42,7 +42,7 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 
 	while (!irq || !kfifo_is_full(&dev->txstatus_fifo)) {
 		spin_lock_irqsave(&dev->irq_lock, flags);
-		ret = mt76x2_mac_load_tx_status(dev, &stat);
+		ret = mt76x02_mac_load_tx_status(&dev->mt76, &stat);
 		spin_unlock_irqrestore(&dev->irq_lock, flags);
 
 		if (!ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 3cd99d4debb8..4cd94bfc9dbc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -53,31 +53,6 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_stop);
 
-bool mt76x2_mac_load_tx_status(struct mt76x2_dev *dev,
-			       struct mt76x02_tx_status *stat)
-{
-	u32 stat1, stat2;
-
-	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
-	stat1 = mt76_rr(dev, MT_TX_STAT_FIFO);
-
-	stat->valid = !!(stat1 & MT_TX_STAT_FIFO_VALID);
-	if (!stat->valid)
-		return false;
-
-	stat->success = !!(stat1 & MT_TX_STAT_FIFO_SUCCESS);
-	stat->aggr = !!(stat1 & MT_TX_STAT_FIFO_AGGR);
-	stat->ack_req = !!(stat1 & MT_TX_STAT_FIFO_ACKREQ);
-	stat->wcid = FIELD_GET(MT_TX_STAT_FIFO_WCID, stat1);
-	stat->rate = FIELD_GET(MT_TX_STAT_FIFO_RATE, stat1);
-
-	stat->retry = FIELD_GET(MT_TX_STAT_FIFO_EXT_RETRY, stat2);
-	stat->pktid = FIELD_GET(MT_TX_STAT_FIFO_EXT_PKTID, stat2);
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_load_tx_status);
-
 static int
 mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 			   enum nl80211_band band)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index d983b3e1a4e4..73af4c8a73ae 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -68,7 +68,7 @@ bool mt76x2u_tx_status_data(struct mt76_dev *mdev, u8 *update)
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 	struct mt76x02_tx_status stat;
 
-	if (!mt76x2_mac_load_tx_status(dev, &stat))
+	if (!mt76x02_mac_load_tx_status(&dev->mt76, &stat))
 		return false;
 
 	mt76x2_send_tx_status(dev, &stat, update);
-- 
2.7.5
