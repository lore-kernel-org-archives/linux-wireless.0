Return-Path: <SRS0=UNZO=RF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39905C43381
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C1D20863
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Mar 2019 13:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551534486;
	bh=8HGXXhZbTAxQwveTYFDRoOUSR8Sd5bKnITKkMjlZfwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=PNrpYp2crZ3tJuRUPuvaK66vv+A7uH7pez5eG5kzuX0MYp8HuwonaWCgOpwSPgaG0
	 HHjutAQA2774Oujiz+k1HpJXY4RghYUiNAMUdshbxvUERtF00hIr3unHGzekH/t2f2
	 Of9O2zeF/w3U0wyGSw1m6mtVzXn9b8GSfyYJVJ+E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfCBNsF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Mar 2019 08:48:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726951AbfCBNsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Mar 2019 08:48:04 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4139B2086D;
        Sat,  2 Mar 2019 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551534482;
        bh=8HGXXhZbTAxQwveTYFDRoOUSR8Sd5bKnITKkMjlZfwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jN21vZHP0cfOZxwzm3DzOzhaT+BGz4siNY78KP4ztX9kVDoYox4Avpc7Vnncg6d7H
         AOaTRDgfRyuidRjUDVVwNmWldSAxQ5DAGZ0COQbgPNat2dPHqrMcf8aeIBza1A/zoh
         GS9tTQmyI6zUVOj/ECrMSMIUAjdKTxD137wRUWqo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, roychl666@gmail.com,
        ryder.lee@mediatek.com
Subject: [PATCH 4/5] mt76: introduce mt76_sw_queue data structure
Date:   Sat,  2 Mar 2019 14:47:41 +0100
Message-Id: <f76120bea93ac19b82c63765aab27a003e6b187e.1551533068.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551533068.git.lorenzo@kernel.org>
References: <cover.1551533068.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_sw_queue data structure in order to support new
chipsets (e.g. mt7615) that have a shared hardware queue for all traffic
identifiers. mt76_sw_queue will be used to track outstanding packets

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c  |  7 ++-
 drivers/net/wireless/mediatek/mt76/dma.c      | 12 ++--
 drivers/net/wireless/mediatek/mt76/mac80211.c |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     | 16 ++++--
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  8 +--
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 13 ++++-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  4 +-
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 19 +++++--
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |  2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       | 55 ++++++++++---------
 drivers/net/wireless/mediatek/mt76/usb.c      | 23 +++++---
 13 files changed, 100 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index a5adf22c3ffa..840615362b08 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -43,14 +43,15 @@ mt76_queues_read(struct seq_file *s, void *data)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
-		struct mt76_queue *q = &dev->q_tx[i];
+		struct mt76_sw_queue *q = &dev->q_tx[i];
 
-		if (!q->ndesc)
+		if (!q->q->ndesc)
 			continue;
 
 		seq_printf(s,
 			   "%d:	queued=%d head=%d tail=%d swq_queued=%d\n",
-			   i, q->queued, q->head, q->tail, q->swq_queued);
+			   i, q->q->queued, q->q->head, q->q->tail,
+			   q->swq_queued);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 58c67df9f185..a37a1af74981 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -29,7 +29,6 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	int i;
 
 	spin_lock_init(&q->lock);
-	INIT_LIST_HEAD(&q->swq);
 
 	q->regs = dev->mmio.regs + ring_base + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
@@ -147,7 +146,8 @@ mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
 static void
 mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 {
-	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_sw_queue *sq = &dev->q_tx[qid];
+	struct mt76_queue *q = sq->q;
 	struct mt76_queue_entry entry;
 	bool wake = false;
 	int last;
@@ -164,7 +164,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 	while (q->queued && q->tail != last) {
 		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
 		if (entry.schedule)
-			q->swq_queued--;
+			dev->q_tx[qid].swq_queued--;
 
 		q->tail = (q->tail + 1) % q->ndesc;
 		q->queued--;
@@ -185,7 +185,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 	}
 
 	if (!flush)
-		mt76_txq_schedule(dev, q);
+		mt76_txq_schedule(dev, sq);
 	else
 		mt76_dma_sync_idx(dev, q);
 
@@ -258,7 +258,7 @@ static int
 mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, u32 tx_info)
 {
-	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_queue *q = dev->q_tx[qid].q;
 	struct mt76_queue_buf buf;
 	dma_addr_t addr;
 
@@ -282,7 +282,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta)
 {
-	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_queue *q = dev->q_tx[qid].q;
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct mt76_queue_buf buf[32];
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index a033745adb2f..47eecb4d4d01 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -386,10 +386,12 @@ EXPORT_SYMBOL_GPL(mt76_rx);
 
 static bool mt76_has_tx_pending(struct mt76_dev *dev)
 {
+	struct mt76_queue *q;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
-		if (dev->q_tx[i].queued)
+		q = dev->q_tx[i].q;
+		if (q && q->queued)
 			return true;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e9bb1812c4cf..e3160dc7c515 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -117,9 +117,6 @@ struct mt76_queue {
 	struct mt76_queue_entry *entry;
 	struct mt76_desc *desc;
 
-	struct list_head swq;
-	int swq_queued;
-
 	u16 first;
 	u16 head;
 	u16 tail;
@@ -137,6 +134,13 @@ struct mt76_queue {
 	spinlock_t rx_page_lock;
 };
 
+struct mt76_sw_queue {
+	struct mt76_queue *q;
+
+	struct list_head swq;
+	int swq_queued;
+};
+
 struct mt76_mcu_ops {
 	int (*mcu_send_msg)(struct mt76_dev *dev, int cmd, const void *data,
 			    int len, bool wait_resp);
@@ -214,7 +218,7 @@ struct mt76_wcid {
 
 struct mt76_txq {
 	struct list_head list;
-	struct mt76_queue *hwq;
+	struct mt76_sw_queue *swq;
 	struct mt76_wcid *wcid;
 
 	struct sk_buff_head retry_q;
@@ -437,7 +441,7 @@ struct mt76_dev {
 	struct sk_buff_head rx_skb[__MT_RXQ_MAX];
 
 	struct list_head txwi_cache;
-	struct mt76_queue q_tx[__MT_TXQ_MAX];
+	struct mt76_sw_queue q_tx[__MT_TXQ_MAX];
 	struct mt76_queue q_rx[__MT_RXQ_MAX];
 	const struct mt76_queue_ops *queue_ops;
 	int tx_dma_idx[4];
@@ -659,7 +663,7 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
 void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			 bool send_bar);
-void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *hwq);
+void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_sw_queue *sq);
 void mt76_txq_schedule_all(struct mt76_dev *dev);
 void mt76_release_buffered_frames(struct ieee80211_hw *hw,
 				  struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index ae41c1ba6e9b..addfeec51f60 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -30,7 +30,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	mt76_wr(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY |
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_WCID, mvif->sta.wcid.idx) |
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID,
-			   dev->mt76.q_tx[MT_TXQ_CAB].hw_idx) |
+			   dev->mt76.q_tx[MT_TXQ_CAB].q->hw_idx) |
 		FIELD_PREP(MT_DMA_FQCR0_DEST_PORT_ID, 3) |
 		FIELD_PREP(MT_DMA_FQCR0_DEST_QUEUE_ID, 8));
 
@@ -76,7 +76,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 	data.dev = dev;
 	__skb_queue_head_init(&data.q);
 
-	q = &dev->mt76.q_tx[MT_TXQ_BEACON];
+	q = dev->mt76.q_tx[MT_TXQ_BEACON].q;
 	spin_lock_bh(&q->lock);
 	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 		IEEE80211_IFACE_ITER_RESUME_ALL,
@@ -93,7 +93,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 	if (dev->mt76.csa_complete)
 		goto out;
 
-	q = &dev->mt76.q_tx[MT_TXQ_CAB];
+	q = dev->mt76.q_tx[MT_TXQ_CAB].q;
 	do {
 		nframes = skb_queue_len(&data.q);
 		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
@@ -135,7 +135,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 
 out:
 	mt76_queue_tx_cleanup(dev, MT_TXQ_BEACON, false);
-	if (dev->mt76.q_tx[MT_TXQ_BEACON].queued >
+	if (dev->mt76.q_tx[MT_TXQ_BEACON].q->queued >
 	    __sw_hweight8(dev->beacon_mask))
 		dev->beacon_check++;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 5067c49142f7..56c02423370c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -5,16 +5,23 @@
 #include "../dma.h"
 
 static int
-mt7603_init_tx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
+mt7603_init_tx_queue(struct mt7603_dev *dev, struct mt76_sw_queue *q,
 		     int idx, int n_desc)
 {
+	struct mt76_queue *hwq;
 	int err;
 
-	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
-			       MT_TX_RING_BASE);
+	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return -ENOMEM;
+
+	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
 	if (err < 0)
 		return err;
 
+	INIT_LIST_HEAD(&q->swq);
+	q->q = hwq;
+
 	mt7603_irq_enable(dev, MT_INT_TX_DONE(idx));
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 7a7f898f5400..c640f3e2e640 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -828,7 +828,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_vif *vif = info->control.vif;
-	struct mt76_queue *q = &dev->mt76.q_tx[qid];
+	struct mt76_queue *q = dev->mt76.q_tx[qid].q;
 	struct mt7603_vif *mvif;
 	int wlan_idx;
 	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
@@ -1411,7 +1411,7 @@ static bool mt7603_tx_hang(struct mt7603_dev *dev)
 	int i;
 
 	for (i = 0; i < 4; i++) {
-		q = &dev->mt76.q_tx[i];
+		q = dev->mt76.q_tx[i].q;
 
 		if (!q->queued)
 			continue;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index b10775ed92e6..05fd8009a5fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -476,7 +476,7 @@ mt7603_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	u16 cw_max = (1 << 10) - 1;
 	u32 val;
 
-	queue = dev->mt76.q_tx[queue].hw_idx;
+	queue = dev->mt76.q_tx[queue].q->hw_idx;
 
 	if (params->cw_min)
 		cw_min = params->cw_min;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 910277e55480..c2a2fa353297 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -103,7 +103,7 @@ mt76x02_resync_beacon_timer(struct mt76x02_dev *dev)
 static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 {
 	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
-	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
+	struct mt76_queue *q = dev->mt76.q_tx[MT_TXQ_PSD].q;
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
 	int i, nframes;
@@ -153,16 +153,23 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 }
 
 static int
-mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
+mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_sw_queue *q,
 		      int idx, int n_desc)
 {
+	struct mt76_queue *hwq;
 	int err;
 
-	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
-			       MT_TX_RING_BASE);
+	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return -ENOMEM;
+
+	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
 	if (err < 0)
 		return err;
 
+	INIT_LIST_HEAD(&q->swq);
+	q->q = hwq;
+
 	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
 
 	return 0;
@@ -313,7 +320,7 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 		if (dev->mt76.csa_complete)
 			mt76_csa_finish(&dev->mt76);
 		else
-			mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
+			mt76_queue_kick(dev, dev->mt76.q_tx[MT_TXQ_PSD].q);
 	}
 
 	if (intr & MT_INT_TX_STAT) {
@@ -385,7 +392,7 @@ static bool mt76x02_tx_hang(struct mt76x02_dev *dev)
 	int i;
 
 	for (i = 0; i < 4; i++) {
-		q = &dev->mt76.q_tx[i];
+		q = dev->mt76.q_tx[i].q;
 
 		if (!q->queued)
 			continue;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 6ad2f9f95120..8ab63255ba6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -77,7 +77,7 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			    u32 *tx_info)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
-	int pid, len = skb->len, ep = q2ep(mdev->q_tx[qid].hw_idx);
+	int pid, len = skb->len, ep = q2ep(mdev->q_tx[qid].q->hw_idx);
 	struct mt76x02_txwi *txwi;
 	enum mt76_qsel qsel;
 	u32 flags;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index cd072ac614f7..b14a55737829 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -465,7 +465,7 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u8 cw_min = 5, cw_max = 10, qid;
 	u32 val;
 
-	qid = dev->mt76.q_tx[queue].hw_idx;
+	qid = dev->mt76.q_tx[queue].q->hw_idx;
 
 	if (params->cw_min)
 		cw_min = fls(params->cw_min);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 5c94cffb53b7..240ef2cc5c79 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -283,7 +283,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 			mt76_check_agg_ssn(mtxq, skb);
 	}
 
-	q = &dev->q_tx[qid];
+	q = dev->q_tx[qid].q;
 
 	spin_lock_bh(&q->lock);
 	dev->queue_ops->tx_queue_skb(dev, qid, skb, wcid, sta);
@@ -345,7 +345,7 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 {
 	struct mt76_dev *dev = hw->priv;
 	struct sk_buff *last_skb = NULL;
-	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
+	struct mt76_queue *hwq = dev->q_tx[MT_TXQ_PSD].q;
 	int i;
 
 	spin_lock_bh(&hwq->lock);
@@ -382,13 +382,14 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 EXPORT_SYMBOL_GPL(mt76_release_buffered_frames);
 
 static int
-mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
+mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_sw_queue *sq,
 		    struct mt76_txq *mtxq, bool *empty)
 {
 	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
 	enum mt76_txq_id qid = mt76_txq_get_qid(txq);
-	struct ieee80211_tx_info *info;
 	struct mt76_wcid *wcid = mtxq->wcid;
+	struct mt76_queue *hwq = sq->q;
+	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
 	int n_frames = 1, limit;
 	struct ieee80211_tx_rate tx_rate;
@@ -464,8 +465,8 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	} while (n_frames < limit);
 
 	if (!probe) {
-		hwq->swq_queued++;
 		hwq->entry[idx].schedule = true;
+		sq->swq_queued++;
 	}
 
 	dev->queue_ops->kick(dev, hwq);
@@ -474,14 +475,15 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 }
 
 static int
-mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
+mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_sw_queue *sq)
 {
+	struct mt76_queue *hwq = sq->q;
 	struct mt76_txq *mtxq, *mtxq_last;
 	int len = 0;
 
 restart:
-	mtxq_last = list_last_entry(&hwq->swq, struct mt76_txq, list);
-	while (!list_empty(&hwq->swq)) {
+	mtxq_last = list_last_entry(&sq->swq, struct mt76_txq, list);
+	while (!list_empty(&sq->swq)) {
 		bool empty = false;
 		int cur;
 
@@ -489,7 +491,7 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 		    test_bit(MT76_RESET, &dev->state))
 			return -EBUSY;
 
-		mtxq = list_first_entry(&hwq->swq, struct mt76_txq, list);
+		mtxq = list_first_entry(&sq->swq, struct mt76_txq, list);
 		if (mtxq->send_bar && mtxq->aggr) {
 			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
 			struct ieee80211_sta *sta = txq->sta;
@@ -506,9 +508,9 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 
 		list_del_init(&mtxq->list);
 
-		cur = mt76_txq_send_burst(dev, hwq, mtxq, &empty);
+		cur = mt76_txq_send_burst(dev, sq, mtxq, &empty);
 		if (!empty)
-			list_add_tail(&mtxq->list, &hwq->swq);
+			list_add_tail(&mtxq->list, &sq->swq);
 
 		if (cur < 0)
 			return cur;
@@ -522,16 +524,16 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
 	return len;
 }
 
-void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *hwq)
+void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_sw_queue *sq)
 {
 	int len;
 
 	rcu_read_lock();
 	do {
-		if (hwq->swq_queued >= 4 || list_empty(&hwq->swq))
+		if (sq->swq_queued >= 4 || list_empty(&sq->swq))
 			break;
 
-		len = mt76_txq_schedule_list(dev, hwq);
+		len = mt76_txq_schedule_list(dev, sq);
 	} while (len > 0);
 	rcu_read_unlock();
 }
@@ -542,10 +544,10 @@ void mt76_txq_schedule_all(struct mt76_dev *dev)
 	int i;
 
 	for (i = 0; i <= MT_TXQ_BK; i++) {
-		struct mt76_queue *q = &dev->q_tx[i];
+		struct mt76_queue *q = dev->q_tx[i].q;
 
 		spin_lock_bh(&q->lock);
-		mt76_txq_schedule(dev, q);
+		mt76_txq_schedule(dev, &dev->q_tx[i]);
 		spin_unlock_bh(&q->lock);
 	}
 }
@@ -558,18 +560,20 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
 		struct ieee80211_txq *txq = sta->txq[i];
+		struct mt76_queue *hwq;
 		struct mt76_txq *mtxq;
 
 		if (!txq)
 			continue;
 
 		mtxq = (struct mt76_txq *)txq->drv_priv;
+		hwq = mtxq->swq->q;
 
-		spin_lock_bh(&mtxq->hwq->lock);
+		spin_lock_bh(&hwq->lock);
 		mtxq->send_bar = mtxq->aggr && send_bar;
 		if (!list_empty(&mtxq->list))
 			list_del_init(&mtxq->list);
-		spin_unlock_bh(&mtxq->hwq->lock);
+		spin_unlock_bh(&hwq->lock);
 	}
 }
 EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
@@ -577,31 +581,32 @@ EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
 	struct mt76_dev *dev = hw->priv;
-	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
-	struct mt76_queue *hwq = mtxq->hwq;
+	struct mt76_txq *mtxq = (struct mt76_txq *)txq->drv_priv;
+	struct mt76_sw_queue *sq = mtxq->swq;
+	struct mt76_queue *hwq = sq->q;
 
 	if (!test_bit(MT76_STATE_RUNNING, &dev->state))
 		return;
 
 	spin_lock_bh(&hwq->lock);
 	if (list_empty(&mtxq->list))
-		list_add_tail(&mtxq->list, &hwq->swq);
-	mt76_txq_schedule(dev, hwq);
+		list_add_tail(&mtxq->list, &sq->swq);
+	mt76_txq_schedule(dev, sq);
 	spin_unlock_bh(&hwq->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
 
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 {
-	struct mt76_txq *mtxq;
 	struct mt76_queue *hwq;
+	struct mt76_txq *mtxq;
 	struct sk_buff *skb;
 
 	if (!txq)
 		return;
 
 	mtxq = (struct mt76_txq *) txq->drv_priv;
-	hwq = mtxq->hwq;
+	hwq = mtxq->swq->q;
 
 	spin_lock_bh(&hwq->lock);
 	if (!list_empty(&mtxq->list))
@@ -620,7 +625,7 @@ void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 	INIT_LIST_HEAD(&mtxq->list);
 	skb_queue_head_init(&mtxq->retry_q);
 
-	mtxq->hwq = &dev->q_tx[mt76_txq_get_qid(txq)];
+	mtxq->swq = &dev->q_tx[mt76_txq_get_qid(txq)];
 }
 EXPORT_SYMBOL_GPL(mt76_txq_init);
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index e5485c83267b..7cff5c2b547b 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -627,13 +627,15 @@ static void mt76u_tx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
 	struct mt76_queue_entry entry;
+	struct mt76_sw_queue *sq;
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
 	bool wake;
 	int i;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		q = &dev->q_tx[i];
+		sq = &dev->q_tx[i];
+		q = sq->q;
 
 		spin_lock_bh(&q->lock);
 		while (true) {
@@ -643,7 +645,7 @@ static void mt76u_tx_tasklet(unsigned long data)
 
 			if (q->entry[q->head].schedule) {
 				q->entry[q->head].schedule = false;
-				q->swq_queued--;
+				sq->swq_queued--;
 			}
 
 			entry = q->entry[q->head];
@@ -654,7 +656,7 @@ static void mt76u_tx_tasklet(unsigned long data)
 			dev->drv->tx_complete_skb(dev, i, &entry);
 			spin_lock_bh(&q->lock);
 		}
-		mt76_txq_schedule(dev, q);
+		mt76_txq_schedule(dev, sq);
 
 		wake = q->stopped && q->queued < q->ndesc - 8;
 		if (wake)
@@ -730,7 +732,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		   struct sk_buff *skb, struct mt76_wcid *wcid,
 		   struct ieee80211_sta *sta)
 {
-	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_queue *q = dev->q_tx[qid].q;
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
 	int err;
@@ -792,10 +794,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		q = &dev->q_tx[i];
+		INIT_LIST_HEAD(&dev->q_tx[i].swq);
+
+		q = devm_kzalloc(dev->dev, sizeof(*q), GFP_KERNEL);
+		if (!q)
+			return -ENOMEM;
+
 		spin_lock_init(&q->lock);
-		INIT_LIST_HEAD(&q->swq);
 		q->hw_idx = mt76_ac_to_hwq(i);
+		dev->q_tx[i].q = q;
 
 		q->entry = devm_kcalloc(dev->dev,
 					MT_NUM_TX_ENTRIES, sizeof(*q->entry),
@@ -832,7 +839,7 @@ static void mt76u_free_tx(struct mt76_dev *dev)
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		q = &dev->q_tx[i];
+		q = dev->q_tx[i].q;
 		for (j = 0; j < q->ndesc; j++)
 			usb_free_urb(q->entry[j].ubuf.urb);
 	}
@@ -844,7 +851,7 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		q = &dev->q_tx[i];
+		q = dev->q_tx[i].q;
 		for (j = 0; j < q->ndesc; j++)
 			usb_kill_urb(q->entry[j].ubuf.urb);
 	}
-- 
2.20.1

