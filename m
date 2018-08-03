Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728412AbeHCNkz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Aug 2018 09:40:55 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH 2/2] mt76x0: rename trace symbols
Date: Fri,  3 Aug 2018 13:44:40 +0200
Message-Id: <1533296680-7236-2-git-send-email-sgruszka@redhat.com> (sfid-20180803_134507_870133_3529B22C)
In-Reply-To: <1533296680-7236-1-git-send-email-sgruszka@redhat.com>
References: <1533296680-7236-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename trace symbols that conflict with mt7601u and remove some
definitions that are not used.

Patch fixes build errors like this:
ld: drivers/net/wireless/mediatek/mt76/mt76x0/trace.o:(__tracepoints+0x0): multiple definition of `__tracepoint_set_shared_key'; drivers/net/wireless/mediatek/mt7601u/trace.o:(__tracepoints+0x0): first defined here

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c    |  8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c    |  8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  6 --
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  | 87 +++++-----------------
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  8 +-
 8 files changed, 35 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
index d91b1bb8fcc7..e2efb430419b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -105,7 +105,7 @@ static void mt76x0_rx_process_seg(struct mt76x0_dev *dev, u8 *data,
 	if (unlikely(FIELD_GET(MT_RXD_INFO_TYPE, fce_info)))
 		dev_err_once(dev->mt76.dev, "Error: RX path seen a non-pkt urb\n");
 
-	trace_mt_rx(&dev->mt76, rxwi, fce_info);
+	trace_mt76x0_rx(&dev->mt76, rxwi, fce_info);
 
 	skb = mt76x0_rx_skb_from_seg(dev, rxwi, data, seg_len, truesize, p);
 	if (!skb)
@@ -155,7 +155,7 @@ mt76x0_rx_process_entry(struct mt76x0_dev *dev, struct mt76x0_dma_buf_rx *e)
 	}
 
 	if (cnt > 1)
-		trace_mt_rx_dma_aggr(&dev->mt76, cnt, !!new_p);
+		trace_mt76x0_rx_dma_aggr(&dev->mt76, cnt, !!new_p);
 
 	if (new_p) {
 		/* we have one extra ref from the allocator */
@@ -235,7 +235,7 @@ static void mt76x0_complete_tx(struct urb *urb)
 		goto out;
 
 	skb = q->e[q->start].skb;
-	trace_mt_tx_dma_done(&dev->mt76, skb);
+	trace_mt76x0_tx_dma_done(&dev->mt76, skb);
 
 	__skb_queue_tail(&dev->tx_skb_done, skb);
 	tasklet_schedule(&dev->tx_tasklet);
@@ -384,7 +384,7 @@ static int mt76x0_submit_rx_buf(struct mt76x0_dev *dev,
 	usb_fill_bulk_urb(e->urb, usb_dev, pipe, buf, MT_RX_URB_SIZE,
 			  mt76x0_complete_rx, dev);
 
-	trace_mt_submit_urb(&dev->mt76, e->urb);
+	trace_mt76x0_submit_urb(&dev->mt76, e->urb);
 	ret = usb_submit_urb(e->urb, gfp);
 	if (ret)
 		dev_err(dev->mt76.dev, "Error: submit RX URB failed:%d\n", ret);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 5f12724eeb62..95f28492a843 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -606,7 +606,7 @@ int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EINVAL;
 
-	trace_set_key(&dev->mt76, idx);
+	trace_mt76x0_set_key(&dev->mt76, idx);
 
 	mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
 
@@ -646,7 +646,7 @@ int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
 	if (cipher == MT_CIPHER_NONE && key)
 		return -EINVAL;
 
-	trace_set_shared_key(&dev->mt76, vif_idx, key_idx);
+	trace_mt76x0_set_shared_key(&dev->mt76, vif_idx, key_idx);
 
 	mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx),
 			key_data, sizeof(key_data));
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 979ba519e54f..8affacbab90a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -48,7 +48,7 @@ static inline void mt76x0_dma_skb_wrap_cmd(struct sk_buff *skb,
 				     FIELD_PREP(MT_TXD_CMD_TYPE, cmd)));
 }
 
-static inline void trace_mt_mcu_msg_send_cs(struct mt76_dev *dev,
+static inline void trace_mt76x0_mcu_msg_send_cs(struct mt76_dev *dev,
 					    struct sk_buff *skb, bool need_resp)
 {
 	u32 i, csum = 0;
@@ -56,7 +56,7 @@ static inline void trace_mt_mcu_msg_send_cs(struct mt76_dev *dev,
 	for (i = 0; i < skb->len / 4; i++)
 		csum ^= get_unaligned_le32(skb->data + i * 4);
 
-	trace_mt_mcu_msg_send(dev, skb, csum, need_resp);
+	trace_mt76x0_mcu_msg_send(dev, skb, csum, need_resp);
 }
 
 static struct sk_buff *
@@ -168,8 +168,8 @@ __mt76x0_mcu_msg_send(struct mt76x0_dev *dev, struct sk_buff *skb,
 	if (dev->mcu.resp_cmpl.done)
 		dev_err(dev->mt76.dev, "Error: MCU response pre-completed!\n");
 
-	trace_mt_mcu_msg_send_cs(&dev->mt76, skb, wait_resp);
-	trace_mt_submit_urb_sync(&dev->mt76, cmd_pipe, skb->len);
+	trace_mt76x0_mcu_msg_send_cs(&dev->mt76, skb, wait_resp);
+	trace_mt76x0_submit_urb_sync(&dev->mt76, cmd_pipe, skb->len);
 
 	ret = usb_bulk_msg(usb_dev, cmd_pipe, skb->data, skb->len, &sent, 500);
 	if (ret) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index c1feca3ea016..fc9857f61771 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -124,12 +124,6 @@ struct mt76x0_eeprom_params;
 
 #define MT_VEND_ADDR(type, n)	(MT_VEND_TYPE_##type | (n))
 
-enum mt_temp_mode {
-	MT_TEMP_MODE_NORMAL,
-	MT_TEMP_MODE_HIGH,
-	MT_TEMP_MODE_LOW,
-};
-
 enum mt_bw {
 	MT_BW_20,
 	MT_BW_40,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index e52a50661b1a..5da7bfbe907f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -52,7 +52,7 @@ mt76x0_rf_csr_wr(struct mt76x0_dev *dev, u32 offset, u8 value)
 		   FIELD_PREP(MT_RF_CSR_CFG_REG_ID, reg) |
 		   MT_RF_CSR_CFG_WR |
 		   MT_RF_CSR_CFG_KICK);
-	trace_rf_write(&dev->mt76, bank, offset, value);
+	trace_mt76x0_rf_write(&dev->mt76, bank, offset, value);
 out:
 	mutex_unlock(&dev->reg_atomic_mutex);
 
@@ -96,7 +96,7 @@ mt76x0_rf_csr_rr(struct mt76x0_dev *dev, u32 offset)
 	if (FIELD_GET(MT_RF_CSR_CFG_REG_ID, val) == reg &&
 	    FIELD_GET(MT_RF_CSR_CFG_REG_BANK, val) == bank) {
 		ret = FIELD_GET(MT_RF_CSR_CFG_DATA, val);
-		trace_rf_read(&dev->mt76, bank, offset, ret);
+		trace_mt76x0_rf_read(&dev->mt76, bank, offset, ret);
 	}
 out:
 	mutex_unlock(&dev->reg_atomic_mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
index cdf53e5442d8..8a752a09f2dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
@@ -51,17 +51,17 @@ DECLARE_EVENT_CLASS(dev_reg_evt,
 	)
 );
 
-DEFINE_EVENT(dev_reg_evt, reg_read,
+DEFINE_EVENT(dev_reg_evt, mt76x0_reg_read,
 	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
 	TP_ARGS(dev, reg, val)
 );
 
-DEFINE_EVENT(dev_reg_evt, reg_write,
+DEFINE_EVENT(dev_reg_evt, mt76x0_reg_write,
 	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
 	TP_ARGS(dev, reg, val)
 );
 
-TRACE_EVENT(mt_submit_urb,
+TRACE_EVENT(mt76x0_submit_urb,
 	TP_PROTO(struct mt76_dev *dev, struct urb *u),
 	TP_ARGS(dev, u),
 	TP_STRUCT__entry(
@@ -76,14 +76,14 @@ TRACE_EVENT(mt_submit_urb,
 		  DEV_PR_ARG, __entry->pipe, __entry->len)
 );
 
-#define trace_mt_submit_urb_sync(__dev, __pipe, __len) ({	\
+#define trace_mt76x0_submit_urb_sync(__dev, __pipe, __len) ({	\
 	struct urb u;					\
 	u.pipe = __pipe;				\
 	u.transfer_buffer_length = __len;		\
-	trace_mt_submit_urb(__dev, &u);			\
+	trace_mt76x0_submit_urb(__dev, &u);			\
 })
 
-TRACE_EVENT(mt_mcu_msg_send,
+TRACE_EVENT(mt76x0_mcu_msg_send,
 	TP_PROTO(struct mt76_dev *dev,
 		 struct sk_buff *skb, u32 csum, bool resp),
 	TP_ARGS(dev, skb, csum, resp),
@@ -103,7 +103,7 @@ TRACE_EVENT(mt_mcu_msg_send,
 		  DEV_PR_ARG, __entry->info, __entry->csum, __entry->resp)
 );
 
-TRACE_EVENT(mt_vend_req,
+TRACE_EVENT(mt76x0_vend_req,
 	TP_PROTO(struct mt76_dev *dev, unsigned pipe, u8 req, u8 req_type,
 		 u16 val, u16 offset, void *buf, size_t buflen, int ret),
 	TP_ARGS(dev, pipe, req, req_type, val, offset, buf, buflen, ret),
@@ -131,21 +131,6 @@ TRACE_EVENT(mt_vend_req,
 		  !!__entry->buf, __entry->buflen)
 );
 
-TRACE_EVENT(ee_read,
-	TP_PROTO(struct mt76_dev *dev, int offset, u16 val),
-	TP_ARGS(dev, offset, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(int, o) __field(u16, v)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->o = offset;
-		__entry->v = val;
-	),
-	TP_printk(DEV_PR_FMT "%04x=%04x", DEV_PR_ARG, __entry->o, __entry->v)
-);
-
 DECLARE_EVENT_CLASS(dev_rf_reg_evt,
 	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
 	TP_ARGS(dev, bank, reg, val),
@@ -166,44 +151,16 @@ DECLARE_EVENT_CLASS(dev_rf_reg_evt,
 	)
 );
 
-DEFINE_EVENT(dev_rf_reg_evt, rf_read,
+DEFINE_EVENT(dev_rf_reg_evt, mt76x0_rf_read,
 	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
 	TP_ARGS(dev, bank, reg, val)
 );
 
-DEFINE_EVENT(dev_rf_reg_evt, rf_write,
+DEFINE_EVENT(dev_rf_reg_evt, mt76x0_rf_write,
 	TP_PROTO(struct mt76_dev *dev, u8 bank, u8 reg, u8 val),
 	TP_ARGS(dev, bank, reg, val)
 );
 
-DECLARE_EVENT_CLASS(dev_bbp_reg_evt,
-	TP_PROTO(struct mt76_dev *dev, u8 reg, u8 val),
-	TP_ARGS(dev, reg, val),
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u8, reg)
-		__field(u8, val)
-	),
-	TP_fast_assign(
-		DEV_ASSIGN;
-		REG_ASSIGN;
-	),
-	TP_printk(
-		DEV_PR_FMT "%02hhx=%02hhx",
-		DEV_PR_ARG, __entry->reg, __entry->val
-	)
-);
-
-DEFINE_EVENT(dev_bbp_reg_evt, bbp_read,
-	TP_PROTO(struct mt76_dev *dev, u8 reg, u8 val),
-	TP_ARGS(dev, reg, val)
-);
-
-DEFINE_EVENT(dev_bbp_reg_evt, bbp_write,
-	TP_PROTO(struct mt76_dev *dev, u8 reg, u8 val),
-	TP_ARGS(dev, reg, val)
-);
-
 DECLARE_EVENT_CLASS(dev_simple_evt,
 	TP_PROTO(struct mt76_dev *dev, u8 val),
 	TP_ARGS(dev, val),
@@ -220,17 +177,7 @@ DECLARE_EVENT_CLASS(dev_simple_evt,
 	)
 );
 
-DEFINE_EVENT(dev_simple_evt, temp_mode,
-	TP_PROTO(struct mt76_dev *dev, u8 val),
-	TP_ARGS(dev, val)
-);
-
-DEFINE_EVENT(dev_simple_evt, read_temp,
-	TP_PROTO(struct mt76_dev *dev, u8 val),
-	TP_ARGS(dev, val)
-);
-
-TRACE_EVENT(mt_rx,
+TRACE_EVENT(mt76x0_rx,
 	TP_PROTO(struct mt76_dev *dev, struct mt76x0_rxwi *rxwi, u32 f),
 	TP_ARGS(dev, rxwi, f),
 	TP_STRUCT__entry(
@@ -248,7 +195,7 @@ TRACE_EVENT(mt_rx,
 		  le32_to_cpu(__entry->rxwi.ctl))
 );
 
-TRACE_EVENT(mt_tx,
+TRACE_EVENT(mt76x0_tx,
 	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb,
 		 struct mt76_sta *sta, struct mt76_txwi *h),
 	TP_ARGS(dev, skb, sta, h),
@@ -273,7 +220,7 @@ TRACE_EVENT(mt_tx,
 		  le16_to_cpu(__entry->h.len_ctl))
 );
 
-TRACE_EVENT(mt_tx_dma_done,
+TRACE_EVENT(mt76x0_tx_dma_done,
 	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb),
 	TP_ARGS(dev, skb),
 	TP_STRUCT__entry(
@@ -287,7 +234,7 @@ TRACE_EVENT(mt_tx_dma_done,
 	TP_printk(DEV_PR_FMT "%p", DEV_PR_ARG, __entry->skb)
 );
 
-TRACE_EVENT(mt_tx_status_cleaned,
+TRACE_EVENT(mt76x0_tx_status_cleaned,
 	TP_PROTO(struct mt76_dev *dev, int cleaned),
 	TP_ARGS(dev, cleaned),
 	TP_STRUCT__entry(
@@ -301,7 +248,7 @@ TRACE_EVENT(mt_tx_status_cleaned,
 	TP_printk(DEV_PR_FMT "%d", DEV_PR_ARG, __entry->cleaned)
 );
 
-TRACE_EVENT(mt_tx_status,
+TRACE_EVENT(mt76x0_tx_status,
 	TP_PROTO(struct mt76_dev *dev, u32 stat1, u32 stat2),
 	TP_ARGS(dev, stat1, stat2),
 	TP_STRUCT__entry(
@@ -317,7 +264,7 @@ TRACE_EVENT(mt_tx_status,
 		  DEV_PR_ARG, __entry->stat1, __entry->stat2)
 );
 
-TRACE_EVENT(mt_rx_dma_aggr,
+TRACE_EVENT(mt76x0_rx_dma_aggr,
 	TP_PROTO(struct mt76_dev *dev, int cnt, bool paged),
 	TP_ARGS(dev, cnt, paged),
 	TP_STRUCT__entry(
@@ -334,12 +281,12 @@ TRACE_EVENT(mt_rx_dma_aggr,
 		  DEV_PR_ARG, __entry->cnt, __entry->paged)
 );
 
-DEFINE_EVENT(dev_simple_evt, set_key,
+DEFINE_EVENT(dev_simple_evt, mt76x0_set_key,
 	TP_PROTO(struct mt76_dev *dev, u8 val),
 	TP_ARGS(dev, val)
 );
 
-TRACE_EVENT(set_shared_key,
+TRACE_EVENT(mt76x0_set_shared_key,
 	TP_PROTO(struct mt76_dev *dev, u8 vid, u8 key),
 	TP_ARGS(dev, vid, key),
 	TP_STRUCT__entry(
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 976d3ee91f67..751b49c28ae5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -177,7 +177,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	if (mt76x0_dma_enqueue_tx(dev, skb, wcid, hw_q))
 		return;
 
-	trace_mt_tx(&dev->mt76, skb, msta, txwi);
+	trace_mt76x0_tx(&dev->mt76, skb, msta, txwi);
 }
 
 void mt76x0_tx_stat(struct work_struct *work)
@@ -198,7 +198,7 @@ void mt76x0_tx_stat(struct work_struct *work)
 
 		cleaned++;
 	}
-	trace_mt_tx_status_cleaned(&dev->mt76, cleaned);
+	trace_mt76x0_tx_status_cleaned(&dev->mt76, cleaned);
 
 	spin_lock_irqsave(&dev->tx_lock, flags);
 	if (cleaned)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 7a635cdcbae0..54ae1f113be2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -84,7 +84,7 @@ int mt76x0_usb_submit_buf(struct mt76x0_dev *dev, int dir, int ep_idx,
 	buf->urb->transfer_dma = buf->dma;
 	buf->urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
-	trace_mt_submit_urb(&dev->mt76, buf->urb);
+	trace_mt76x0_submit_urb(&dev->mt76, buf->urb);
 	ret = usb_submit_urb(buf->urb, gfp);
 	if (ret)
 		dev_err(dev->mt76.dev, "Error: submit URB dir:%d ep:%d failed:%d\n",
@@ -113,7 +113,7 @@ int mt76x0_vendor_request(struct mt76x0_dev *dev, const u8 req,
 		ret = usb_control_msg(usb_dev, pipe, req, req_type,
 				      val, offset, buf, buflen,
 				      MT_VEND_REQ_TOUT_MS);
-		trace_mt_vend_req(&dev->mt76, pipe, req, req_type, val, offset,
+		trace_mt76x0_vend_req(&dev->mt76, pipe, req, req_type, val, offset,
 				  buf, buflen, ret);
 
 		if (ret == -ENODEV)
@@ -156,7 +156,7 @@ static u32 mt76x0_rr(struct mt76_dev *dev, u32 offset)
 
 	mutex_unlock(&mdev->usb_ctrl_mtx);
 
-	trace_reg_read(dev, offset, val);
+	trace_mt76x0_reg_read(dev, offset, val);
 	return val;
 }
 
@@ -191,7 +191,7 @@ static void mt76x0_wr(struct mt76_dev *dev, u32 offset, u32 val)
 	put_unaligned_le32(val, mdev->data);
 	ret = mt76x0_vendor_request(mdev, MT_VEND_MULTI_WRITE, USB_DIR_OUT,
 				    0, offset, mdev->data, MT_VEND_BUF);
-	trace_reg_write(dev, offset, val);
+	trace_mt76x0_reg_write(dev, offset, val);
 
 	mutex_unlock(&mdev->usb_ctrl_mtx);
 }
-- 
2.7.5
