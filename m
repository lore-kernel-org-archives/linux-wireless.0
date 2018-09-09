Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37210 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbeIJBX4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 21:23:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id u12-v6so19720146wrr.4
        for <linux-wireless@vger.kernel.org>; Sun, 09 Sep 2018 13:33:01 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 06/11] mt76: usb: move mt76x02 mcu code in mt76x02-usb module
Date: Sun,  9 Sep 2018 22:32:41 +0200
Message-Id: <20180909203246.21608-7-lorenzo.bianconi@redhat.com> (sfid-20180909_223307_202671_C588AF02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce mt76x02_usb_mcu.c in order to contain mt76x02u mcu related
code. Add mt76x02-usb module as a container for mt76x02 usb code.
This is a preliminary patch to move MT_TXD_INFO, MT_MCU_MSG and
MT_RX_FCE_INFO defs in mt76x02-lib module since other chipsets (e.g.
mt7603) use different dma definitions

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig    |   8 +-
 drivers/net/wireless/mediatek/mt76/Makefile   |   3 +
 drivers/net/wireless/mediatek/mt76/mt76.h     |   4 -
 .../net/wireless/mediatek/mt76/mt76x0/mcu.c   |  15 +-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  27 ++
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 358 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2_usb.c   |   2 +
 .../net/wireless/mediatek/mt76/mt76x2u_mcu.c  |  27 +-
 drivers/net/wireless/mediatek/mt76/usb.c      |   3 +-
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  | 335 ----------------
 11 files changed, 422 insertions(+), 362 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index e460a3a5e763..7f24aad94efd 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -9,6 +9,10 @@ config MT76x02_LIB
 	tristate
 	select MT76_CORE
 
+config MT76x02_USB
+	tristate
+	select MT76_USB
+
 config MT76x0_COMMON
 	tristate
 	select MT76x02_LIB
@@ -20,7 +24,7 @@ config MT76x2_COMMON
 config MT76x0U
 	tristate "MediaTek MT76x0U (USB) support"
 	select MT76x0_COMMON
-	select MT76_USB
+	select MT76x02_USB
 	depends on MAC80211
 	depends on USB
 	help
@@ -45,7 +49,7 @@ config MT76x2E
 config MT76x2U
 	tristate "MediaTek MT76x2U (USB) support"
 	select MT76x2_COMMON
-	select MT76_USB
+	select MT76x02_USB
 	depends on MAC80211
 	depends on USB
 	help
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 129ac71446d6..64a32b4bb127 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
 obj-$(CONFIG_MT76x02_LIB) += mt76x02-lib.o
+obj-$(CONFIG_MT76x02_USB) += mt76x02-usb.o
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 obj-$(CONFIG_MT76x2U) += mt76x2u.o
@@ -16,6 +17,8 @@ CFLAGS_usb_trace.o := -I$(src)
 
 mt76x02-lib-y := mt76x02_util.o mt76x02_mac.o
 
+mt76x02-usb-y := mt76x02_usb_mcu.o
+
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
 	mt76x2_init_common.o mt76x2_common.o mt76x2_phy_common.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 9cf112778c05..c5adc678786a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -651,12 +651,8 @@ void mt76u_stop_stat_wk(struct mt76_dev *dev);
 void mt76u_queues_deinit(struct mt76_dev *dev);
 int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
 
-int mt76u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
-			   int data_len, u32 max_payload, u32 offset);
 void mt76u_mcu_complete_urb(struct urb *urb);
-void mt76u_mcu_fw_reset(struct mt76_dev *dev);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
 void mt76u_mcu_deinit(struct mt76_dev *dev);
-void mt76u_init_mcu_ops(struct mt76_dev *dev);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
index 17ec9189ac50..7baa9a45bd84 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c
@@ -25,6 +25,7 @@
 #include "mcu.h"
 #include "usb.h"
 #include "trace.h"
+#include "../mt76x02_usb.h"
 
 #define MCU_FW_URB_MAX_PAYLOAD		0x38f8
 #define MCU_FW_URB_SIZE			(MCU_FW_URB_MAX_PAYLOAD + 12)
@@ -177,17 +178,17 @@ mt76x0_upload_firmware(struct mt76x0_dev *dev, const struct mt76_fw *fw)
 	ilm_len = le32_to_cpu(fw->hdr.ilm_len) - sizeof(fw->ivb);
 	dev_dbg(dev->mt76.dev, "loading FW - ILM %u + IVB %zu\n",
 		ilm_len, sizeof(fw->ivb));
-	ret = mt76u_mcu_fw_send_data(&dev->mt76, fw->ilm, ilm_len,
-				     MCU_FW_URB_MAX_PAYLOAD,
-				     sizeof(fw->ivb));
+	ret = mt76x02u_mcu_fw_send_data(&dev->mt76, fw->ilm, ilm_len,
+					MCU_FW_URB_MAX_PAYLOAD,
+					sizeof(fw->ivb));
 	if (ret)
 		goto error;
 
 	dlm_len = le32_to_cpu(fw->hdr.dlm_len);
 	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
-	ret = mt76u_mcu_fw_send_data(&dev->mt76, fw->ilm + ilm_len,
-				     dlm_len, MCU_FW_URB_MAX_PAYLOAD,
-				     MT_MCU_DLM_OFFSET);
+	ret = mt76x02u_mcu_fw_send_data(&dev->mt76, fw->ilm + ilm_len,
+					dlm_len, MCU_FW_URB_MAX_PAYLOAD,
+					MT_MCU_DLM_OFFSET);
 	if (ret)
 		goto error;
 
@@ -257,7 +258,7 @@ static int mt76x0_load_firmware(struct mt76x0_dev *dev)
 	mt76_set(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
 				       MT_USB_DMA_CFG_TX_BULK_EN) |
 				       FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20));
-	mt76u_mcu_fw_reset(&dev->mt76);
+	mt76x02u_mcu_fw_reset(&dev->mt76);
 	msleep(5);
 /*
 	mt76x0_rmw(dev, MT_PBF_CFG, 0, (MT_PBF_CFG_TX0Q_EN |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 89e856745fec..2f05f7383117 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -19,6 +19,7 @@
 #include "usb.h"
 #include "trace.h"
 #include "../mt76x02_util.h"
+#include "../mt76x02_usb.h"
 
 static struct usb_device_id mt76x0_device_table[] = {
 	{ USB_DEVICE(0x148F, 0x7610) },	/* MT7610U */
@@ -70,6 +71,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 
 	usb_set_intfdata(usb_intf, dev);
 
+	mt76x02u_init_mcu(&dev->mt76);
 	ret = mt76u_init(&dev->mt76, usb_intf);
 	if (ret)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
new file mode 100644
index 000000000000..798354be54ec
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -0,0 +1,27 @@
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
+#ifndef __MT76x02_USB_H
+#define __MT76x0x_USB_H
+
+#include "mt76.h"
+
+void mt76x02u_init_mcu(struct mt76_dev *dev);
+void mt76x02u_mcu_fw_reset(struct mt76_dev *dev);
+int mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
+			      int data_len, u32 max_payload, u32 offset);
+
+#endif /* __MT76x02_USB_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
new file mode 100644
index 000000000000..3072be3e0dde
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -0,0 +1,358 @@
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
+#include <linux/firmware.h>
+
+#include "mt76.h"
+#include "dma.h"
+#include "mt76x02_mcu.h"
+
+#define MT_CMD_HDR_LEN			4
+
+#define MT_FCE_DMA_ADDR			0x0230
+#define MT_FCE_DMA_LEN			0x0234
+
+#define MT_TX_CPU_FROM_FCE_CPU_DESC_IDX	0x09a8
+
+static struct sk_buff *
+mt76x02u_mcu_msg_alloc(const void *data, int len)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(MT_CMD_HDR_LEN + len + 8, GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, MT_CMD_HDR_LEN);
+	skb_put_data(skb, data, len);
+
+	return skb;
+}
+
+static void
+mt76x02u_multiple_mcu_reads(struct mt76_dev *dev, u8 *data, int len)
+{
+	struct mt76_usb *usb = &dev->usb;
+	u32 reg, val;
+	int i;
+
+	if (usb->mcu.burst) {
+		WARN_ON_ONCE(len / 4 != usb->mcu.rp_len);
+
+		reg = usb->mcu.rp[0].reg - usb->mcu.base;
+		for (i = 0; i < usb->mcu.rp_len; i++) {
+			val = get_unaligned_le32(data + 4 * i);
+			usb->mcu.rp[i].reg = reg++;
+			usb->mcu.rp[i].value = val;
+		}
+	} else {
+		WARN_ON_ONCE(len / 8 != usb->mcu.rp_len);
+
+		for (i = 0; i < usb->mcu.rp_len; i++) {
+			reg = get_unaligned_le32(data + 8 * i) -
+			      usb->mcu.base;
+			val = get_unaligned_le32(data + 8 * i + 4);
+
+			WARN_ON_ONCE(usb->mcu.rp[i].reg != reg);
+			usb->mcu.rp[i].value = val;
+		}
+	}
+}
+
+static int mt76x02u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
+{
+	struct mt76_usb *usb = &dev->usb;
+	struct mt76u_buf *buf = &usb->mcu.res;
+	struct urb *urb = buf->urb;
+	int i, ret;
+	u32 rxfce;
+	u8 *data;
+
+	for (i = 0; i < 5; i++) {
+		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
+						 msecs_to_jiffies(300)))
+			continue;
+
+		if (urb->status)
+			return -EIO;
+
+		data = sg_virt(&urb->sg[0]);
+		if (usb->mcu.rp)
+			mt76x02u_multiple_mcu_reads(dev, data + 4,
+						    urb->actual_length - 8);
+
+		rxfce = get_unaligned_le32(data);
+		ret = mt76u_submit_buf(dev, USB_DIR_IN,
+				       MT_EP_IN_CMD_RESP,
+				       buf, GFP_KERNEL,
+				       mt76u_mcu_complete_urb,
+				       &usb->mcu.cmpl);
+		if (ret)
+			return ret;
+
+		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce) &&
+		    FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce) == EVT_CMD_DONE)
+			return 0;
+
+		dev_err(dev->dev, "error: MCU resp evt:%lx seq:%hhx-%lx\n",
+			FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce),
+			seq, FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce));
+	}
+
+	dev_err(dev->dev, "error: %s timed out\n", __func__);
+	return -ETIMEDOUT;
+}
+
+static int
+__mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+			int cmd, bool wait_resp)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct mt76_usb *usb = &dev->usb;
+	unsigned int pipe;
+	int ret, sent;
+	u8 seq = 0;
+	u32 info;
+
+	if (!skb)
+		return -EINVAL;
+
+	if (test_bit(MT76_REMOVED, &dev->state))
+		return 0;
+
+	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
+	if (wait_resp) {
+		seq = ++usb->mcu.msg_seq & 0xf;
+		if (!seq)
+			seq = ++usb->mcu.msg_seq & 0xf;
+	}
+
+	info = FIELD_PREP(MT_MCU_MSG_CMD_SEQ, seq) |
+	       FIELD_PREP(MT_MCU_MSG_CMD_TYPE, cmd) |
+	       MT_MCU_MSG_TYPE_CMD;
+	ret = mt76u_skb_dma_info(skb, CPU_TX_PORT, info);
+	if (ret)
+		return ret;
+
+	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
+	if (ret)
+		return ret;
+
+	if (wait_resp)
+		ret = mt76x02u_mcu_wait_resp(dev, seq);
+
+	consume_skb(skb);
+
+	return ret;
+}
+
+static int
+mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+		      int cmd, bool wait_resp)
+{
+	struct mt76_usb *usb = &dev->usb;
+	int err;
+
+	mutex_lock(&usb->mcu.mutex);
+	err = __mt76x02u_mcu_send_msg(dev, skb, cmd, wait_resp);
+	mutex_unlock(&usb->mcu.mutex);
+
+	return err;
+}
+
+static inline void skb_put_le32(struct sk_buff *skb, u32 val)
+{
+	put_unaligned_le32(val, skb_put(skb, 4));
+}
+
+static int
+mt76x02u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
+		   const struct mt76_reg_pair *data, int n)
+{
+	const int CMD_RANDOM_WRITE = 12;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
+	struct sk_buff *skb;
+	int cnt, i, ret;
+
+	if (!n)
+		return 0;
+
+	cnt = min(max_vals_per_cmd, n);
+
+	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, MT_DMA_HDR_LEN);
+
+	for (i = 0; i < cnt; i++) {
+		skb_put_le32(skb, base + data[i].reg);
+		skb_put_le32(skb, data[i].value);
+	}
+
+	ret = mt76x02u_mcu_send_msg(dev, skb, CMD_RANDOM_WRITE, cnt == n);
+	if (ret)
+		return ret;
+
+	return mt76x02u_mcu_wr_rp(dev, base, data + cnt, n - cnt);
+}
+
+static int
+mt76x02u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
+		   struct mt76_reg_pair *data, int n)
+{
+	const int CMD_RANDOM_READ = 10;
+	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
+	struct mt76_usb *usb = &dev->usb;
+	struct sk_buff *skb;
+	int cnt, i, ret;
+
+	if (!n)
+		return 0;
+
+	cnt = min(max_vals_per_cmd, n);
+	if (cnt != n)
+		return -EINVAL;
+
+	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, MT_DMA_HDR_LEN);
+
+	for (i = 0; i < cnt; i++) {
+		skb_put_le32(skb, base + data[i].reg);
+		skb_put_le32(skb, data[i].value);
+	}
+
+	mutex_lock(&usb->mcu.mutex);
+
+	usb->mcu.rp = data;
+	usb->mcu.rp_len = n;
+	usb->mcu.base = base;
+	usb->mcu.burst = false;
+
+	ret = __mt76x02u_mcu_send_msg(dev, skb, CMD_RANDOM_READ, true);
+
+	usb->mcu.rp = NULL;
+
+	mutex_unlock(&usb->mcu.mutex);
+
+	return ret;
+}
+
+void mt76x02u_mcu_fw_reset(struct mt76_dev *dev)
+{
+	mt76u_vendor_request(dev, MT_VEND_DEV_MODE,
+			     USB_DIR_OUT | USB_TYPE_VENDOR,
+			     0x1, 0, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_reset);
+
+static int
+__mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, struct mt76u_buf *buf,
+			    const void *fw_data, int len, u32 dst_addr)
+{
+	u8 *data = sg_virt(&buf->urb->sg[0]);
+	DECLARE_COMPLETION_ONSTACK(cmpl);
+	__le32 info;
+	u32 val;
+	int err;
+
+	info = cpu_to_le32(FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
+			   FIELD_PREP(MT_MCU_MSG_LEN, len) |
+			   MT_MCU_MSG_TYPE_CMD);
+
+	memcpy(data, &info, sizeof(info));
+	memcpy(data + sizeof(info), fw_data, len);
+	memset(data + sizeof(info) + len, 0, 4);
+
+	mt76u_single_wr(dev, MT_VEND_WRITE_FCE,
+			MT_FCE_DMA_ADDR, dst_addr);
+	len = roundup(len, 4);
+	mt76u_single_wr(dev, MT_VEND_WRITE_FCE,
+			MT_FCE_DMA_LEN, len << 16);
+
+	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
+	err = mt76u_submit_buf(dev, USB_DIR_OUT,
+			       MT_EP_OUT_INBAND_CMD,
+			       buf, GFP_KERNEL,
+			       mt76u_mcu_complete_urb, &cmpl);
+	if (err < 0)
+		return err;
+
+	if (!wait_for_completion_timeout(&cmpl,
+					 msecs_to_jiffies(1000))) {
+		dev_err(dev->dev, "firmware upload timed out\n");
+		usb_kill_urb(buf->urb);
+		return -ETIMEDOUT;
+	}
+
+	if (mt76u_urb_error(buf->urb)) {
+		dev_err(dev->dev, "firmware upload failed: %d\n",
+			buf->urb->status);
+		return buf->urb->status;
+	}
+
+	val = mt76u_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
+	val++;
+	mt76u_wr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX, val);
+
+	return 0;
+}
+
+int mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
+			      int data_len, u32 max_payload, u32 offset)
+{
+	int err, len, pos = 0, max_len = max_payload - 8;
+	struct mt76u_buf buf;
+
+	err = mt76u_buf_alloc(dev, &buf, 1, max_payload, max_payload,
+			      GFP_KERNEL);
+	if (err < 0)
+		return err;
+
+	while (data_len > 0) {
+		len = min_t(int, data_len, max_len);
+		err = __mt76x02u_mcu_fw_send_data(dev, &buf, data + pos,
+						  len, offset + pos);
+		if (err < 0)
+			break;
+
+		data_len -= len;
+		pos += len;
+		usleep_range(5000, 10000);
+	}
+	mt76u_buf_free(&buf);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_send_data);
+
+void mt76x02u_init_mcu(struct mt76_dev *dev)
+{
+	static const struct mt76_mcu_ops mt76x02u_mcu_ops = {
+		.mcu_msg_alloc = mt76x02u_mcu_msg_alloc,
+		.mcu_send_msg = mt76x02u_mcu_send_msg,
+		.mcu_wr_rp = mt76x02u_mcu_wr_rp,
+		.mcu_rd_rp = mt76x02u_mcu_rd_rp,
+	};
+
+	dev->mcu_ops = &mt76x02u_mcu_ops;
+}
+EXPORT_SYMBOL_GPL(mt76x02u_init_mcu);
+
+MODULE_AUTHOR("Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
index 2a465c4e1009..feb5cec66c67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
@@ -17,6 +17,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
+#include "mt76x02_usb.h"
 #include "mt76x2u.h"
 
 static const struct usb_device_id mt76x2u_device_table[] = {
@@ -46,6 +47,7 @@ static int mt76x2u_probe(struct usb_interface *intf,
 	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
+	mt76x02u_init_mcu(&dev->mt76);
 	err = mt76u_init(&dev->mt76, intf);
 	if (err < 0)
 		goto err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
index 9d73bdc785b2..09afb8c5d851 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
@@ -18,6 +18,7 @@
 
 #include "mt76x2u.h"
 #include "mt76x2_eeprom.h"
+#include "mt76x02_usb.h"
 
 #define MT_CMD_HDR_LEN			4
 
@@ -300,7 +301,7 @@ static int mt76x2u_mcu_load_rom_patch(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG), val);
 
 	/* vendor reset */
-	mt76u_mcu_fw_reset(&dev->mt76);
+	mt76x02u_mcu_fw_reset(&dev->mt76);
 	usleep_range(5000, 10000);
 
 	/* enable FCE to send in-band cmd */
@@ -314,10 +315,10 @@ static int mt76x2u_mcu_load_rom_patch(struct mt76x2_dev *dev)
 	/* FCE skip_fs_en */
 	mt76_wr(dev, MT_FCE_SKIP_FS, 0x3);
 
-	err = mt76u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
-				     fw->size - sizeof(*hdr),
-				     MCU_ROM_PATCH_MAX_PAYLOAD,
-				     MT76U_MCU_ROM_PATCH_OFFSET);
+	err = mt76x02u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
+					fw->size - sizeof(*hdr),
+					MCU_ROM_PATCH_MAX_PAYLOAD,
+					MT76U_MCU_ROM_PATCH_OFFSET);
 	if (err < 0) {
 		err = -EIO;
 		goto out;
@@ -373,7 +374,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
 	dev_info(dev->mt76.dev, "Build Time: %.16s\n", hdr->build_time);
 
 	/* vendor reset */
-	mt76u_mcu_fw_reset(&dev->mt76);
+	mt76x02u_mcu_fw_reset(&dev->mt76);
 	usleep_range(5000, 10000);
 
 	/* enable USB_DMA_CFG */
@@ -393,9 +394,9 @@ static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
 	mt76_wr(dev, MT_FCE_SKIP_FS, 0x3);
 
 	/* load ILM */
-	err = mt76u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
-				     ilm_len, MCU_FW_URB_MAX_PAYLOAD,
-				     MT76U_MCU_ILM_OFFSET);
+	err = mt76x02u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
+					ilm_len, MCU_FW_URB_MAX_PAYLOAD,
+					MT76U_MCU_ILM_OFFSET);
 	if (err < 0) {
 		err = -EIO;
 		goto out;
@@ -404,10 +405,10 @@ static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
 	/* load DLM */
 	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
 		dlm_offset += 0x800;
-	err = mt76u_mcu_fw_send_data(&dev->mt76,
-				     fw->data + sizeof(*hdr) + ilm_len,
-				     dlm_len, MCU_FW_URB_MAX_PAYLOAD,
-				     dlm_offset);
+	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
+					fw->data + sizeof(*hdr) + ilm_len,
+					dlm_len, MCU_FW_URB_MAX_PAYLOAD,
+					dlm_offset);
 	if (err < 0) {
 		err = -EIO;
 		goto out;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 17ad8a8f1c56..b1efbccb2be2 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -109,6 +109,7 @@ u32 mt76u_rr(struct mt76_dev *dev, u32 addr)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(mt76u_rr);
 
 /* should be called with usb_ctrl_mtx locked */
 static void __mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
@@ -140,6 +141,7 @@ void mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
 	__mt76u_wr(dev, addr, val);
 	mutex_unlock(&dev->usb.usb_ctrl_mtx);
 }
+EXPORT_SYMBOL_GPL(mt76u_wr);
 
 static u32 mt76u_rmw(struct mt76_dev *dev, u32 addr,
 		     u32 mask, u32 val)
@@ -892,7 +894,6 @@ int mt76u_init(struct mt76_dev *dev,
 	mutex_init(&usb->usb_ctrl_mtx);
 	dev->bus = &mt76u_ops;
 	dev->queue_ops = &usb_queue_ops;
-	mt76u_init_mcu_ops(dev);
 
 	return mt76u_set_endpoints(intf, usb);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
index 362a6de73fc1..036be4163e69 100644
--- a/drivers/net/wireless/mediatek/mt76/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -14,34 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/firmware.h>
-
 #include "mt76.h"
-#include "dma.h"
-
-#define MT_CMD_HDR_LEN			4
-
-#define MT_FCE_DMA_ADDR			0x0230
-#define MT_FCE_DMA_LEN			0x0234
-
-#define MT_TX_CPU_FROM_FCE_CPU_DESC_IDX	0x09a8
-
-#define MT_INBAND_PACKET_MAX_LEN	192
-
-static struct sk_buff *
-mt76u_mcu_msg_alloc(const void *data, int len)
-{
-	struct sk_buff *skb;
-
-	skb = alloc_skb(MT_CMD_HDR_LEN + len + 8, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
-	skb_reserve(skb, MT_CMD_HDR_LEN);
-	skb_put_data(skb, data, len);
-
-	return skb;
-}
 
 void mt76u_mcu_complete_urb(struct urb *urb)
 {
@@ -51,302 +24,6 @@ void mt76u_mcu_complete_urb(struct urb *urb)
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_complete_urb);
 
-static void
-mt76u_multiple_mcu_reads(struct mt76_dev *dev, u8 *data,
-			 int len)
-{
-	struct mt76_usb *usb = &dev->usb;
-	u32 reg, val;
-	int i;
-
-	if (usb->mcu.burst) {
-		WARN_ON_ONCE(len / 4 != usb->mcu.rp_len);
-
-		reg = usb->mcu.rp[0].reg - usb->mcu.base;
-		for (i = 0; i < usb->mcu.rp_len; i++) {
-			val = get_unaligned_le32(data + 4 * i);
-			usb->mcu.rp[i].reg = reg++;
-			usb->mcu.rp[i].value = val;
-		}
-	} else {
-		WARN_ON_ONCE(len / 8 != usb->mcu.rp_len);
-
-		for (i = 0; i < usb->mcu.rp_len; i++) {
-			reg = get_unaligned_le32(data + 8 * i) -
-			      usb->mcu.base;
-			val = get_unaligned_le32(data + 8 * i + 4);
-
-			WARN_ON_ONCE(usb->mcu.rp[i].reg != reg);
-			usb->mcu.rp[i].value = val;
-		}
-	}
-}
-
-static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
-{
-	struct mt76_usb *usb = &dev->usb;
-	struct mt76u_buf *buf = &usb->mcu.res;
-	int i, ret;
-	u32 rxfce;
-	u8 *data;
-
-	for (i = 0; i < 5; i++) {
-		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
-						 msecs_to_jiffies(300)))
-			continue;
-
-		if (buf->urb->status)
-			return -EIO;
-
-		data = sg_virt(&buf->urb->sg[0]);
-		if (usb->mcu.rp)
-			mt76u_multiple_mcu_reads(dev, data + 4,
-						 buf->urb->actual_length - 8);
-
-		rxfce = get_unaligned_le32(data);
-		ret = mt76u_submit_buf(dev, USB_DIR_IN,
-				       MT_EP_IN_CMD_RESP,
-				       buf, GFP_KERNEL,
-				       mt76u_mcu_complete_urb,
-				       &usb->mcu.cmpl);
-		if (ret)
-			return ret;
-
-		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce) &&
-		    FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce) == EVT_CMD_DONE)
-			return 0;
-
-		dev_err(dev->dev, "error: MCU resp evt:%lx seq:%hhx-%lx\n",
-			FIELD_GET(MT_RX_FCE_INFO_EVT_TYPE, rxfce),
-			seq, FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce));
-	}
-
-	dev_err(dev->dev, "error: %s timed out\n", __func__);
-	return -ETIMEDOUT;
-}
-
-static int
-__mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-		     int cmd, bool wait_resp)
-{
-	struct usb_interface *intf = to_usb_interface(dev->dev);
-	struct usb_device *udev = interface_to_usbdev(intf);
-	struct mt76_usb *usb = &dev->usb;
-	unsigned int pipe;
-	int ret, sent;
-	u8 seq = 0;
-	u32 info;
-
-	if (test_bit(MT76_REMOVED, &dev->state))
-		return 0;
-
-	pipe = usb_sndbulkpipe(udev, usb->out_ep[MT_EP_OUT_INBAND_CMD]);
-	if (wait_resp) {
-		seq = ++usb->mcu.msg_seq & 0xf;
-		if (!seq)
-			seq = ++usb->mcu.msg_seq & 0xf;
-	}
-
-	info = FIELD_PREP(MT_MCU_MSG_CMD_SEQ, seq) |
-	       FIELD_PREP(MT_MCU_MSG_CMD_TYPE, cmd) |
-	       MT_MCU_MSG_TYPE_CMD;
-	ret = mt76u_skb_dma_info(skb, CPU_TX_PORT, info);
-	if (ret)
-		return ret;
-
-	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
-	if (ret)
-		return ret;
-
-	if (wait_resp)
-		ret = mt76u_mcu_wait_resp(dev, seq);
-
-	consume_skb(skb);
-
-	return ret;
-}
-
-static int
-mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-		   int cmd, bool wait_resp)
-{
-	struct mt76_usb *usb = &dev->usb;
-	int err;
-
-	mutex_lock(&usb->mcu.mutex);
-	err = __mt76u_mcu_send_msg(dev, skb, cmd, wait_resp);
-	mutex_unlock(&usb->mcu.mutex);
-
-	return err;
-}
-
-static inline void skb_put_le32(struct sk_buff *skb, u32 val)
-{
-	put_unaligned_le32(val, skb_put(skb, 4));
-}
-
-static int
-mt76u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
-		const struct mt76_reg_pair *data, int n)
-{
-	const int CMD_RANDOM_WRITE = 12;
-	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
-	struct sk_buff *skb;
-	int cnt, i, ret;
-
-	if (!n)
-		return 0;
-
-	cnt = min(max_vals_per_cmd, n);
-
-	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-
-	for (i = 0; i < cnt; i++) {
-		skb_put_le32(skb, base + data[i].reg);
-		skb_put_le32(skb, data[i].value);
-	}
-
-	ret = mt76u_mcu_send_msg(dev, skb, CMD_RANDOM_WRITE, cnt == n);
-	if (ret)
-		return ret;
-
-	return mt76u_mcu_wr_rp(dev, base, data + cnt, n - cnt);
-}
-
-static int
-mt76u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
-		struct mt76_reg_pair *data, int n)
-{
-	const int CMD_RANDOM_READ = 10;
-	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
-	struct mt76_usb *usb = &dev->usb;
-	struct sk_buff *skb;
-	int cnt, i, ret;
-
-	if (!n)
-		return 0;
-
-	cnt = min(max_vals_per_cmd, n);
-	if (cnt != n)
-		return -EINVAL;
-
-	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, MT_DMA_HDR_LEN);
-
-	for (i = 0; i < cnt; i++) {
-		skb_put_le32(skb, base + data[i].reg);
-		skb_put_le32(skb, data[i].value);
-	}
-
-	mutex_lock(&usb->mcu.mutex);
-
-	usb->mcu.rp = data;
-	usb->mcu.rp_len = n;
-	usb->mcu.base = base;
-	usb->mcu.burst = false;
-
-	ret = __mt76u_mcu_send_msg(dev, skb, CMD_RANDOM_READ, true);
-
-	usb->mcu.rp = NULL;
-
-	mutex_unlock(&usb->mcu.mutex);
-
-	return ret;
-}
-
-void mt76u_mcu_fw_reset(struct mt76_dev *dev)
-{
-	mt76u_vendor_request(dev, MT_VEND_DEV_MODE,
-			     USB_DIR_OUT | USB_TYPE_VENDOR,
-			     0x1, 0, NULL, 0);
-}
-EXPORT_SYMBOL_GPL(mt76u_mcu_fw_reset);
-
-static int
-__mt76u_mcu_fw_send_data(struct mt76_dev *dev, struct mt76u_buf *buf,
-			 const void *fw_data, int len, u32 dst_addr)
-{
-	u8 *data = sg_virt(&buf->urb->sg[0]);
-	DECLARE_COMPLETION_ONSTACK(cmpl);
-	__le32 info;
-	u32 val;
-	int err;
-
-	info = cpu_to_le32(FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
-			   FIELD_PREP(MT_MCU_MSG_LEN, len) |
-			   MT_MCU_MSG_TYPE_CMD);
-
-	memcpy(data, &info, sizeof(info));
-	memcpy(data + sizeof(info), fw_data, len);
-	memset(data + sizeof(info) + len, 0, 4);
-
-	mt76u_single_wr(dev, MT_VEND_WRITE_FCE,
-			MT_FCE_DMA_ADDR, dst_addr);
-	len = roundup(len, 4);
-	mt76u_single_wr(dev, MT_VEND_WRITE_FCE,
-			MT_FCE_DMA_LEN, len << 16);
-
-	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
-	err = mt76u_submit_buf(dev, USB_DIR_OUT,
-			       MT_EP_OUT_INBAND_CMD,
-			       buf, GFP_KERNEL,
-			       mt76u_mcu_complete_urb, &cmpl);
-	if (err < 0)
-		return err;
-
-	if (!wait_for_completion_timeout(&cmpl,
-					 msecs_to_jiffies(1000))) {
-		dev_err(dev->dev, "firmware upload timed out\n");
-		usb_kill_urb(buf->urb);
-		return -ETIMEDOUT;
-	}
-
-	if (mt76u_urb_error(buf->urb)) {
-		dev_err(dev->dev, "firmware upload failed: %d\n",
-			buf->urb->status);
-		return buf->urb->status;
-	}
-
-	val = mt76u_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
-	val++;
-	mt76u_wr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX, val);
-
-	return 0;
-}
-
-int mt76u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
-			   int data_len, u32 max_payload, u32 offset)
-{
-	int err, len, pos = 0, max_len = max_payload - 8;
-	struct mt76u_buf buf;
-
-	err = mt76u_buf_alloc(dev, &buf, 1, max_payload, max_payload,
-			      GFP_KERNEL);
-	if (err < 0)
-		return err;
-
-	while (data_len > 0) {
-		len = min_t(int, data_len, max_len);
-		err = __mt76u_mcu_fw_send_data(dev, &buf, data + pos,
-					       len, offset + pos);
-		if (err < 0)
-			break;
-
-		data_len -= len;
-		pos += len;
-		usleep_range(5000, 10000);
-	}
-	mt76u_buf_free(&buf);
-
-	return err;
-}
-EXPORT_SYMBOL_GPL(mt76u_mcu_fw_send_data);
-
 int mt76u_mcu_init_rx(struct mt76_dev *dev)
 {
 	struct mt76_usb *usb = &dev->usb;
@@ -377,15 +54,3 @@ void mt76u_mcu_deinit(struct mt76_dev *dev)
 	mt76u_buf_free(&usb->mcu.res);
 }
 EXPORT_SYMBOL_GPL(mt76u_mcu_deinit);
-
-void mt76u_init_mcu_ops(struct mt76_dev *dev)
-{
-	static const struct mt76_mcu_ops mt76u_mcu_ops = {
-		.mcu_msg_alloc = mt76u_mcu_msg_alloc,
-		.mcu_send_msg = mt76u_mcu_send_msg,
-		.mcu_wr_rp = mt76u_mcu_wr_rp,
-		.mcu_rd_rp = mt76u_mcu_rd_rp,
-	};
-
-	dev->mcu_ops = &mt76u_mcu_ops;
-}
-- 
2.18.0
