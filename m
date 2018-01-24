Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48656 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934042AbeAXPTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 5/8] mt76: implement A-MPDU rx reordering in the driver code
Date: Wed, 24 Jan 2018 16:19:14 +0100
Message-Id: <20180124151917.70962-5-nbd@nbd.name> (sfid-20180124_161934_517177_1F8003D1)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is required for performing CCMP PN validation in software

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/Makefile      |   2 +-
 drivers/net/wireless/mediatek/mt76/agg-rx.c      | 264 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mac80211.c    |  11 +-
 drivers/net/wireless/mediatek/mt76/mt76.h        |  35 +++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  |   7 +
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c |   2 +
 7 files changed, 319 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/agg-rx.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 2bb919863616..a0156bc01dea 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -2,7 +2,7 @@ obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 
 mt76-y := \
-	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o
+	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
 
 CFLAGS_trace.o := -I$(src)
 
diff --git a/drivers/net/wireless/mediatek/mt76/agg-rx.c b/drivers/net/wireless/mediatek/mt76/agg-rx.c
new file mode 100644
index 000000000000..ecd0bcd149e5
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/agg-rx.c
@@ -0,0 +1,264 @@
+/*
+ * Copyright (C) 2018 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include "mt76.h"
+
+#define REORDER_TIMEOUT (HZ / 10)
+
+static void
+mt76_aggr_release(struct mt76_rx_tid *tid, struct sk_buff_head *frames, int idx)
+{
+	struct sk_buff *skb;
+
+	tid->head = ieee80211_sn_inc(tid->head);
+
+	skb = tid->reorder_buf[idx];
+	if (!skb)
+		return;
+
+	tid->reorder_buf[idx] = NULL;
+	tid->nframes--;
+	__skb_queue_tail(frames, skb);
+}
+
+static void
+mt76_rx_aggr_release_frames(struct mt76_rx_tid *tid, struct sk_buff_head *frames,
+			 u16 head)
+{
+	int idx;
+
+	while (ieee80211_sn_less(tid->head, head)) {
+		idx = tid->head % tid->size;
+		mt76_aggr_release(tid, frames, idx);
+	}
+}
+
+static void
+mt76_rx_aggr_release_head(struct mt76_rx_tid *tid, struct sk_buff_head *frames)
+{
+	int idx = tid->head % tid->size;
+
+	while (tid->reorder_buf[idx]) {
+		mt76_aggr_release(tid, frames, idx);
+		idx = tid->head % tid->size;
+	}
+}
+
+static void
+mt76_rx_aggr_check_release(struct mt76_rx_tid *tid, struct sk_buff_head *frames)
+{
+	struct mt76_rx_status *status;
+	struct sk_buff *skb;
+	int start, idx, nframes;
+
+	if (!tid->nframes)
+		return;
+
+	mt76_rx_aggr_release_head(tid, frames);
+
+	start = tid->head % tid->size;
+	nframes = tid->nframes;
+
+	for (idx = (tid->head + 1) % tid->size;
+	     idx != start && nframes;
+	     idx = (idx + 1) % tid->size) {
+
+		skb = tid->reorder_buf[idx];
+		if (!skb)
+			continue;
+
+		nframes--;
+		status = (struct mt76_rx_status *) skb->cb;
+		if (!time_after(jiffies, status->reorder_time +
+					 REORDER_TIMEOUT))
+			continue;
+
+		mt76_rx_aggr_release_frames(tid, frames, status->seqno);
+	}
+
+	mt76_rx_aggr_release_head(tid, frames);
+}
+
+static void
+mt76_rx_aggr_reorder_work(struct work_struct *work)
+{
+	struct mt76_rx_tid *tid = container_of(work, struct mt76_rx_tid,
+					       reorder_work.work);
+	struct mt76_dev *dev = tid->dev;
+	struct ieee80211_sta *sta;
+	struct sk_buff_head frames;
+	struct sk_buff *skb;
+
+	__skb_queue_head_init(&frames);
+
+	local_bh_disable();
+
+	spin_lock(&tid->lock);
+	mt76_rx_aggr_check_release(tid, &frames);
+	spin_unlock(&tid->lock);
+
+	ieee80211_queue_delayed_work(tid->dev->hw, &tid->reorder_work, REORDER_TIMEOUT);
+
+	while ((skb = __skb_dequeue(&frames)) != NULL) {
+		sta = mt76_rx_convert(skb);
+		ieee80211_rx_napi(dev->hw, sta, skb, NULL);
+	}
+
+	local_bh_enable();
+}
+
+void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
+	struct mt76_wcid *wcid = status->wcid;
+	struct ieee80211_sta *sta;
+	struct mt76_rx_tid *tid;
+	bool sn_less;
+	u16 seqno, head, size;
+	u8 idx;
+
+	__skb_queue_tail(frames, skb);
+
+	sta = wcid_to_sta(wcid);
+	if (!sta || !status->aggr)
+		return;
+
+	tid = rcu_dereference(wcid->aggr[status->tid]);
+	if (!tid)
+		return;
+
+	spin_lock_bh(&tid->lock);
+
+	if (tid->stopped)
+		goto out;
+
+	head = tid->head;
+	seqno = status->seqno;
+	size = tid->size;
+	sn_less = ieee80211_sn_less(seqno, head);
+
+	if (!tid->started) {
+		if (sn_less)
+			goto out;
+
+		tid->started = true;
+	}
+
+	if (sn_less) {
+		__skb_unlink(skb, frames);
+		dev_kfree_skb(skb);
+		goto out;
+	}
+
+	if (seqno == head) {
+		tid->head = ieee80211_sn_inc(head);
+		if (tid->nframes)
+			mt76_rx_aggr_release_head(tid, frames);
+		goto out;
+	}
+
+	__skb_unlink(skb, frames);
+
+	/*
+	 * Frame sequence number exceeds buffering window, free up some space
+	 * by releasing previous frames
+	 */
+	if (!ieee80211_sn_less(seqno, head + size)) {
+		head = ieee80211_sn_inc(ieee80211_sn_sub(seqno, size));
+		mt76_rx_aggr_release_frames(tid, frames, head);
+	}
+
+	idx = seqno % size;
+
+	/* Discard if the current slot is already in use */
+	if (tid->reorder_buf[idx]) {
+		dev_kfree_skb(skb);
+		goto out;
+	}
+
+	status->reorder_time = jiffies;
+	tid->reorder_buf[idx] = skb;
+	tid->nframes++;
+	mt76_rx_aggr_release_head(tid, frames);
+
+	ieee80211_queue_delayed_work(tid->dev->hw, &tid->reorder_work, REORDER_TIMEOUT);
+
+out:
+	spin_unlock_bh(&tid->lock);
+}
+
+int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno,
+		       u16 ssn, u8 size)
+{
+	struct mt76_rx_tid *tid;
+
+	mt76_rx_aggr_stop(dev, wcid, tidno);
+
+	tid = kzalloc(sizeof(*tid) + size * sizeof(tid->reorder_buf[0]),
+		      GFP_KERNEL);
+	if (!tid)
+		return -ENOMEM;
+
+	tid->dev = dev;
+	tid->head = ssn;
+	tid->size = size;
+	INIT_DELAYED_WORK(&tid->reorder_work, mt76_rx_aggr_reorder_work);
+	spin_lock_init(&tid->lock);
+
+	rcu_assign_pointer(wcid->aggr[tidno], tid);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_rx_aggr_start);
+
+static void mt76_rx_aggr_shutdown(struct mt76_dev *dev, struct mt76_rx_tid *tid)
+{
+	u8 size = tid->size;
+	int i;
+
+	spin_lock_bh(&tid->lock);
+
+	tid->stopped = true;
+	for (i = 0; tid->nframes && i < size; i++) {
+		struct sk_buff *skb = tid->reorder_buf[i];
+
+		if (!skb)
+			continue;
+
+		tid->nframes--;
+		dev_kfree_skb(skb);
+	}
+
+	spin_unlock_bh(&tid->lock);
+
+	cancel_delayed_work_sync(&tid->reorder_work);
+}
+
+void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tidno)
+{
+	struct mt76_rx_tid *tid;
+
+	rcu_read_lock();
+
+	tid = rcu_dereference(wcid->aggr[tidno]);
+	if (tid) {
+		rcu_assign_pointer(wcid->aggr[tidno], NULL);
+		mt76_rx_aggr_shutdown(dev, tid);
+		kfree_rcu(tid, rcu_head);
+	}
+
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(mt76_rx_aggr_stop);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index c1982211d658..5978e5b0a2fe 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -384,8 +384,7 @@ int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 }
 EXPORT_SYMBOL_GPL(mt76_get_survey);
 
-static struct ieee80211_sta *
-mt76_rx_convert(struct sk_buff *skb)
+struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct mt76_rx_status mstat;
@@ -414,9 +413,15 @@ mt76_rx_convert(struct sk_buff *skb)
 void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 {
 	struct ieee80211_sta *sta;
+	struct sk_buff_head frames;
 	struct sk_buff *skb;
 
-	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL) {
+	__skb_queue_head_init(&frames);
+
+	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL)
+		mt76_rx_aggr_reorder(skb, &frames);
+
+	while ((skb = __skb_dequeue(&frames)) != NULL) {
 		sta = mt76_rx_convert(skb);
 		ieee80211_rx_napi(dev->hw, sta, skb, &dev->napi[q]);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index e20c52607c66..cde199ed3f57 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -122,6 +122,10 @@ struct mt76_queue_ops {
 };
 
 struct mt76_wcid {
+	struct mt76_rx_tid __rcu *aggr[IEEE80211_NUM_TIDS];
+
+	struct work_struct aggr_work;
+
 	u8 idx;
 	u8 hw_key_idx;
 
@@ -152,6 +156,24 @@ struct mt76_txwi_cache {
 	struct list_head list;
 };
 
+
+struct mt76_rx_tid {
+	struct rcu_head rcu_head;
+
+	struct mt76_dev *dev;
+
+	spinlock_t lock;
+	struct delayed_work reorder_work;
+
+	u16 head;
+	u8 size;
+	u8 nframes;
+
+	u8 started:1, stopped:1, timer_pending:1;
+
+	struct sk_buff *reorder_buf[];
+};
+
 enum {
 	MT76_STATE_INITIALIZED,
 	MT76_STATE_RUNNING,
@@ -254,6 +276,13 @@ struct mt76_rate_power {
 
 struct mt76_rx_status {
 	struct mt76_wcid *wcid;
+
+	unsigned long reorder_time;
+
+	u8 aggr;
+	u8 tid;
+	u16 seqno;
+
 	u32 flag;
 	u16 freq;
 	u8 enc_flags;
@@ -380,9 +409,15 @@ void mt76_set_channel(struct mt76_dev *dev);
 int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 		    struct survey_info *survey);
 
+int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid,
+		       u16 ssn, u8 size);
+void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
+
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
 void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q);
+void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames);
+struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 7b4851481dd6..1e34b578b151 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -842,6 +842,8 @@ int mt76x2_register_device(struct mt76x2_dev *dev)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_VHT_IBSS);
 
 	ieee80211_hw_set(hw, SUPPORTS_HT_CCK_RATES);
+	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
+
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
 	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 75f2843847d0..b96d8a88656c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -281,6 +281,7 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	struct mt76x2_rxwi *rxwi = rxi;
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
+	u16 tid_sn = le16_to_cpu(rxwi->tid_sn);
 	u8 wcid;
 	int len;
 
@@ -290,6 +291,9 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD))
 		mt76x2_remove_hdr_pad(skb);
 
+	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_BA))
+		status->aggr = true;
+
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
@@ -307,6 +311,9 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	status->freq = dev->mt76.chandef.chan->center_freq;
 	status->band = dev->mt76.chandef.chan->band;
 
+	status->tid = FIELD_GET(MT_RXWI_TID, tid_sn);
+	status->seqno = FIELD_GET(MT_RXWI_SN, tid_sn);
+
 	return mt76x2_mac_process_rate(status, rate);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 2a1cb65c5edb..bc08040123b9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -487,9 +487,11 @@ mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
+		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, *ssn, params->buf_size);
 		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
+		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
 		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4,
 			   BIT(16 + tid));
 		break;
-- 
2.14.2
