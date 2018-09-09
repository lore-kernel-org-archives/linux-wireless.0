Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33115 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbeIJBX5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id v90-v6so19812673wrc.0
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:33:02 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] mt76: usb: move mt76u_skb_dma_info in mt76x02_usb_core.c
Date: Sun,  9 Sep 2018 22:32:42 +0200
Message-Id: <20180909203246.21608-8-lorenzo.bianconi@redhat.com> (sfid-20180909_223308_427836_FE611FB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76u_skb_dma_info routine in mt76x02-usb module and rename it in
mt76x02u_skb_dma_info. Moreover move mt76x02u_set_txinfo in
mt76x02_usb_core.c. This is a preliminary patch to move MT_TXD_INFO,
MT_MCU_MSG and MT_RX_FCE_INFO defs in mt76x02-lib module since other
chipsets (e.g. mt7603) use different dma definitions

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 -
 .../net/wireless/mediatek/mt76/mt76x0/tx.c    |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  2 +
 .../wireless/mediatek/mt76/mt76x02_usb_core.c | 72 +++++++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  |  3 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 21 ------
 .../net/wireless/mediatek/mt76/mt76x02_util.h |  1 -
 .../net/wireless/mediatek/mt76/mt76x2u_core.c |  3 +-
 drivers/net/wireless/mediatek/mt76/usb.c      | 34 ---------
 10 files changed, 81 insertions(+), 61 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c

diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 64a32b4bb127..e8bd26923d73 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -17,7 +17,7 @@ CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o
 
-mt76x02-usb-y := mt76x02_usb_mcu.o
+mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index c5adc678786a..2df13aabc5a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -649,7 +649,6 @@ int mt76u_alloc_queues(struct mt76_dev *dev);
 void mt76u_stop_queues(struct mt76_dev *dev);
 void mt76u_stop_stat_wk(struct mt76_dev *dev);
 void mt76u_queues_deinit(struct mt76_dev *dev);
-int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
 
 void mt76u_mcu_complete_urb(struct urb *urb);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 5306fc3a90fb..ae196880bfad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -15,6 +15,7 @@
 #include "mt76x0.h"
 #include "trace.h"
 #include "../mt76x02_util.h"
+#include "../mt76x02_usb.h"
 
 static struct mt76x02_txwi *
 mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
@@ -93,7 +94,7 @@ int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	mt76x02_insert_hdr_pad(skb);
 	txwi = mt76x0_push_txwi(dev, skb, sta, wcid, len);
 
-	return mt76x02_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
+	return mt76x02u_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
 }
 EXPORT_SYMBOL_GPL(mt76x0_tx_prepare_skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 798354be54ec..2482f9761fcd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -24,4 +24,6 @@ void mt76x02u_mcu_fw_reset(struct mt76_dev *dev);
 int mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset);
 
+int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
+int mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep);
 #endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
new file mode 100644
index 000000000000..9ca9e3d414d3
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -0,0 +1,72 @@
+/*
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
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
+
+#include "mt76.h"
+#include "dma.h"
+
+int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
+{
+	struct sk_buff *iter, *last = skb;
+	u32 info, pad;
+
+	/* Buffer layout:
+	 *	|   4B   | xfer len |      pad       |  4B  |
+	 *	| TXINFO | pkt/cmd  | zero pad to 4B | zero |
+	 *
+	 * length field of TXINFO should be set to 'xfer len'.
+	 */
+	info = FIELD_PREP(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
+	       FIELD_PREP(MT_TXD_INFO_DPORT, port) | flags;
+	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
+
+	pad = round_up(skb->len, 4) + 4 - skb->len;
+	skb_walk_frags(skb, iter) {
+		last = iter;
+		if (!iter->next) {
+			skb->data_len += pad;
+			skb->len += pad;
+			break;
+		}
+	}
+
+	if (unlikely(pad)) {
+		if (__skb_pad(last, pad, true))
+			return -ENOMEM;
+		__skb_put(last, pad);
+	}
+	return 0;
+}
+
+int mt76x02u_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	enum mt76_qsel qsel;
+	u32 flags;
+
+	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
+	    ep == MT_EP_OUT_HCCA)
+		qsel = MT_QSEL_MGMT;
+	else
+		qsel = MT_QSEL_EDCA;
+
+	flags = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
+		MT_TXD_INFO_80211;
+	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
+		flags |= MT_TXD_INFO_WIV;
+
+	return mt76x02u_skb_dma_info(skb, WLAN_PORT, flags);
+}
+EXPORT_SYMBOL_GPL(mt76x02u_set_txinfo);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index 3072be3e0dde..cc63efa16634 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -19,6 +19,7 @@
 #include "mt76.h"
 #include "dma.h"
 #include "mt76x02_mcu.h"
+#include "mt76x02_usb.h"
 
 #define MT_CMD_HDR_LEN			4
 
@@ -144,7 +145,7 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	info = FIELD_PREP(MT_MCU_MSG_CMD_SEQ, seq) |
 	       FIELD_PREP(MT_MCU_MSG_CMD_TYPE, cmd) |
 	       MT_MCU_MSG_TYPE_CMD;
-	ret = mt76u_skb_dma_info(skb, CPU_TX_PORT, info);
+	ret = mt76x02u_skb_dma_info(skb, CPU_TX_PORT, info);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index f44c149aa6ef..33d5cd00e48d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -441,27 +441,6 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 }
 EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
 
-int mt76x02_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
-{
-	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	enum mt76_qsel qsel;
-	u32 flags;
-
-	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
-	    ep == MT_EP_OUT_HCCA)
-		qsel = MT_QSEL_MGMT;
-	else
-		qsel = MT_QSEL_EDCA;
-
-	flags = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
-		MT_TXD_INFO_80211;
-	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
-		flags |= MT_TXD_INFO_WIV;
-
-	return mt76u_skb_dma_info(skb, WLAN_PORT, flags);
-}
-EXPORT_SYMBOL_GPL(mt76x02_set_txinfo);
-
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update)
 {
 	struct mt76x02_tx_status stat;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index b6ba7e6c2748..48307ef2c380 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -51,6 +51,5 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 void mt76x02_remove_dma_hdr(struct sk_buff *skb);
 void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			    struct mt76_queue_entry *e, bool flush);
-int mt76x02_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index a61ab329f13c..b6b7e381aec4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -17,6 +17,7 @@
 #include "mt76x2u.h"
 #include "dma.h"
 #include "mt76x02_util.h"
+#include "mt76x02_usb.h"
 
 static int
 mt76x2u_check_skb_rooms(struct sk_buff *skb)
@@ -49,5 +50,5 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	txwi = skb_push(skb, sizeof(struct mt76x02_txwi));
 	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
 
-	return mt76x02_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
+	return mt76x02u_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index b1efbccb2be2..e19b567a6df7 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -565,40 +565,6 @@ static void mt76u_stop_rx(struct mt76_dev *dev)
 		usb_kill_urb(q->entry[i].ubuf.urb);
 }
 
-int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
-{
-	struct sk_buff *iter, *last = skb;
-	u32 info, pad;
-
-	/* Buffer layout:
-	 *	|   4B   | xfer len |      pad       |  4B  |
-	 *	| TXINFO | pkt/cmd  | zero pad to 4B | zero |
-	 *
-	 * length field of TXINFO should be set to 'xfer len'.
-	 */
-	info = FIELD_PREP(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
-	       FIELD_PREP(MT_TXD_INFO_DPORT, port) | flags;
-	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
-
-	pad = round_up(skb->len, 4) + 4 - skb->len;
-	skb_walk_frags(skb, iter) {
-		last = iter;
-		if (!iter->next) {
-			skb->data_len += pad;
-			skb->len += pad;
-			break;
-		}
-	}
-
-	if (unlikely(pad)) {
-		if (__skb_pad(last, pad, true))
-			return -ENOMEM;
-		__skb_put(last, pad);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76u_skb_dma_info);
-
 static void mt76u_tx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
-- 
2.18.0
