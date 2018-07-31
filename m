Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51733 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729224AbeGaJsw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:52 -0400
Received: by mail-wm0-f65.google.com with SMTP id y2-v6so2027101wma.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:42 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 18/19] mt76: add usb support to mt76 layer
Date: Tue, 31 Jul 2018 10:09:19 +0200
Message-Id: <e35c00e4b61a2b21bc9486682d3863ab50f908b5.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_101001_808327_864DB383)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be used by drivers for MT76x2u based devices

Tested-by: <cug_yangyuancong@hotmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig    |   4 +
 drivers/net/wireless/mediatek/mt76/Makefile   |   4 +
 drivers/net/wireless/mediatek/mt76/dma.h      |   5 +
 drivers/net/wireless/mediatek/mt76/mt76.h     | 143 ++-
 drivers/net/wireless/mediatek/mt76/usb.c      | 845 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/usb_mcu.c  | 242 +++++
 .../net/wireless/mediatek/mt76/usb_trace.c    |  23 +
 .../net/wireless/mediatek/mt76/usb_trace.h    |  71 ++
 8 files changed, 1336 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/usb_trace.h

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 1e5c6af6afa2..ba17cdd46ea3 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -1,6 +1,10 @@
 config MT76_CORE
 	tristate
 
+config MT76_USB
+	tristate
+	depends on MT76_CORE
+
 config MT76x2_COMMON
 	tristate
 	depends on MT76_CORE
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index e1bc229e4aad..de0a4bc235d1 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -1,11 +1,15 @@
 obj-$(CONFIG_MT76_CORE) += mt76.o
+obj-$(CONFIG_MT76_USB) += mt76-usb.o
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
 
 mt76-y := \
 	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
 
+mt76-usb-y := usb.o usb_trace.o usb_mcu.o
+
 CFLAGS_trace.o := -I$(src)
+CFLAGS_usb_trace.o := -I$(src)
 
 mt76x2-common-y := \
 	mt76x2_eeprom.o mt76x2_tx_common.o mt76x2_mac_common.o \
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
index 14cfb2dbca25..27248e24a19b 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.h
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -53,6 +53,11 @@
 #define MT_MCU_MSG_TYPE			GENMASK(31, 30)
 #define MT_MCU_MSG_TYPE_CMD		BIT(30)
 
+#define MT_DMA_HDR_LEN			4
+#define MT_RX_INFO_LEN			4
+#define MT_FCE_INFO_LEN			4
+#define MT_RX_RXWI_LEN			32
+
 struct mt76_desc {
 	__le32 buf0;
 	__le32 ctrl;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index ed40d6e66d44..4bf1b35ec44c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -22,6 +22,7 @@
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
 #include <linux/leds.h>
+#include <linux/usb.h>
 #include <net/mac80211.h>
 #include "util.h"
 
@@ -63,12 +64,22 @@ struct mt76_queue_buf {
 	int len;
 };
 
+struct mt76u_buf {
+	struct mt76_dev *dev;
+	struct urb *urb;
+	size_t len;
+	bool done;
+};
+
 struct mt76_queue_entry {
 	union {
 		void *buf;
 		struct sk_buff *skb;
 	};
-	struct mt76_txwi_cache *txwi;
+	union {
+		struct mt76_txwi_cache *txwi;
+		struct mt76u_buf ubuf;
+	};
 	bool schedule;
 };
 
@@ -89,6 +100,7 @@ struct mt76_queue {
 	struct list_head swq;
 	int swq_queued;
 
+	u16 first;
 	u16 head;
 	u16 tail;
 	int ndesc;
@@ -195,6 +207,8 @@ enum {
 	MT76_SCANNING,
 	MT76_RESET,
 	MT76_OFFCHANNEL,
+	MT76_REMOVED,
+	MT76_READING_STATS,
 };
 
 struct mt76_hw_cap {
@@ -215,6 +229,8 @@ struct mt76_driver_ops {
 	void (*tx_complete_skb)(struct mt76_dev *dev, struct mt76_queue *q,
 				struct mt76_queue_entry *e, bool flush);
 
+	bool (*tx_status_data)(struct mt76_dev *dev, u8 *update);
+
 	void (*rx_skb)(struct mt76_dev *dev, enum mt76_rxq_id q,
 		       struct sk_buff *skb);
 
@@ -234,6 +250,64 @@ struct mt76_sband {
 	struct mt76_channel_state *chan;
 };
 
+/* addr req mask */
+#define MT_VEND_TYPE_EEPROM	BIT(31)
+#define MT_VEND_TYPE_CFG	BIT(30)
+#define MT_VEND_TYPE_MASK	(MT_VEND_TYPE_EEPROM | MT_VEND_TYPE_CFG)
+
+#define MT_VEND_ADDR(type, n)	(MT_VEND_TYPE_##type | (n))
+enum mt_vendor_req {
+	MT_VEND_DEV_MODE =	0x1,
+	MT_VEND_WRITE =		0x2,
+	MT_VEND_MULTI_WRITE =	0x6,
+	MT_VEND_MULTI_READ =	0x7,
+	MT_VEND_READ_EEPROM =	0x9,
+	MT_VEND_WRITE_FCE =	0x42,
+	MT_VEND_WRITE_CFG =	0x46,
+	MT_VEND_READ_CFG =	0x47,
+};
+
+enum mt76u_in_ep {
+	MT_EP_IN_PKT_RX,
+	MT_EP_IN_CMD_RESP,
+	__MT_EP_IN_MAX,
+};
+
+enum mt76u_out_ep {
+	MT_EP_OUT_INBAND_CMD,
+	MT_EP_OUT_AC_BK,
+	MT_EP_OUT_AC_BE,
+	MT_EP_OUT_AC_VI,
+	MT_EP_OUT_AC_VO,
+	MT_EP_OUT_HCCA,
+	__MT_EP_OUT_MAX,
+};
+
+#define MT_SG_MAX_SIZE		8
+#define MT_NUM_TX_ENTRIES	256
+#define MT_NUM_RX_ENTRIES	128
+#define MCU_RESP_URB_SIZE	1024
+struct mt76_usb {
+	struct mutex usb_ctrl_mtx;
+	u8 data[32];
+
+	struct tasklet_struct rx_tasklet;
+	struct tasklet_struct tx_tasklet;
+	struct delayed_work stat_work;
+
+	u8 out_ep[__MT_EP_OUT_MAX];
+	u16 out_max_packet;
+	u8 in_ep[__MT_EP_IN_MAX];
+	u16 in_max_packet;
+
+	struct mt76u_mcu {
+		struct mutex mutex;
+		struct completion cmpl;
+		struct mt76u_buf res;
+		u32 msg_seq;
+	} mcu;
+};
+
 struct mt76_dev {
 	struct ieee80211_hw *hw;
 	struct cfg80211_chan_def chandef;
@@ -276,6 +350,8 @@ struct mt76_dev {
 	char led_name[32];
 	bool led_al;
 	u8 led_pin;
+
+	struct mt76_usb usb;
 };
 
 enum mt76_phy_type {
@@ -407,6 +483,14 @@ static inline int mt76_decr(int val, int size)
 	return (val - 1) & (size - 1);
 }
 
+/* Hardware uses mirrored order of queues with Q3
+ * having the highest priority
+ */
+static inline u8 q2hwq(u8 q)
+{
+	return q ^ 0x3;
+}
+
 static inline struct ieee80211_txq *
 mtxq_to_txq(struct mt76_txq *mtxq)
 {
@@ -467,4 +551,61 @@ void mt76_rx_poll_complete(struct mt76_dev *dev, enum mt76_rxq_id q,
 			   struct napi_struct *napi);
 void mt76_rx_aggr_reorder(struct sk_buff *skb, struct sk_buff_head *frames);
 
+/* usb */
+static inline bool mt76u_urb_error(struct urb *urb)
+{
+	return urb->status &&
+	       urb->status != -ECONNRESET &&
+	       urb->status != -ESHUTDOWN &&
+	       urb->status != -ENOENT;
+}
+
+/* Map hardware queues to usb endpoints */
+static inline u8 q2ep(u8 qid)
+{
+	/* TODO: take management packets to queue 5 */
+	return qid + 1;
+}
+
+static inline bool mt76u_check_sg(struct mt76_dev *dev)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+
+	return (udev->bus->sg_tablesize > 0 &&
+		(udev->bus->no_sg_constraint ||
+		 udev->speed == USB_SPEED_WIRELESS));
+}
+
+int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
+			 u8 req_type, u16 val, u16 offset,
+			 void *buf, size_t len);
+void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
+		     const u16 offset, const u32 val);
+u32 mt76u_rr(struct mt76_dev *dev, u32 addr);
+void mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val);
+int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
+void mt76u_deinit(struct mt76_dev *dev);
+int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
+		    int nsgs, int len, int sglen, gfp_t gfp);
+void mt76u_buf_free(struct mt76u_buf *buf);
+int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
+		     struct mt76u_buf *buf, gfp_t gfp,
+		     usb_complete_t complete_fn, void *context);
+int mt76u_submit_rx_buffers(struct mt76_dev *dev);
+int mt76u_alloc_queues(struct mt76_dev *dev);
+void mt76u_stop_queues(struct mt76_dev *dev);
+void mt76u_stop_stat_wk(struct mt76_dev *dev);
+void mt76u_queues_deinit(struct mt76_dev *dev);
+int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
+
+int mt76u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
+			   int data_len, u32 max_payload, u32 offset);
+void mt76u_mcu_complete_urb(struct urb *urb);
+struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len);
+int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+		       int cmd, bool wait_resp);
+void mt76u_mcu_fw_reset(struct mt76_dev *dev);
+int mt76u_mcu_init_rx(struct mt76_dev *dev);
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
new file mode 100644
index 000000000000..7780b07543bb
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -0,0 +1,845 @@
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
+#include "usb_trace.h"
+#include "dma.h"
+
+#define MT_VEND_REQ_MAX_RETRY	10
+#define MT_VEND_REQ_TOUT_MS	300
+
+/* should be called with usb_ctrl_mtx locked */
+static int __mt76u_vendor_request(struct mt76_dev *dev, u8 req,
+				  u8 req_type, u16 val, u16 offset,
+				  void *buf, size_t len)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	unsigned int pipe;
+	int i, ret;
+
+	pipe = (req_type & USB_DIR_IN) ? usb_rcvctrlpipe(udev, 0)
+				       : usb_sndctrlpipe(udev, 0);
+	for (i = 0; i < MT_VEND_REQ_MAX_RETRY; i++) {
+		if (test_bit(MT76_REMOVED, &dev->state))
+			return -EIO;
+
+		ret = usb_control_msg(udev, pipe, req, req_type, val,
+				      offset, buf, len, MT_VEND_REQ_TOUT_MS);
+		if (ret == -ENODEV)
+			set_bit(MT76_REMOVED, &dev->state);
+		if (ret >= 0 || ret == -ENODEV)
+			return ret;
+		usleep_range(5000, 10000);
+	}
+
+	dev_err(dev->dev, "vendor request req:%02x off:%04x failed:%d\n",
+		req, offset, ret);
+	return ret;
+}
+
+int mt76u_vendor_request(struct mt76_dev *dev, u8 req,
+			 u8 req_type, u16 val, u16 offset,
+			 void *buf, size_t len)
+{
+	int ret;
+
+	mutex_lock(&dev->usb.usb_ctrl_mtx);
+	ret = __mt76u_vendor_request(dev, req, req_type,
+				     val, offset, buf, len);
+	trace_usb_reg_wr(dev, offset, val);
+	mutex_unlock(&dev->usb.usb_ctrl_mtx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76u_vendor_request);
+
+/* should be called with usb_ctrl_mtx locked */
+static u32 __mt76u_rr(struct mt76_dev *dev, u32 addr)
+{
+	struct mt76_usb *usb = &dev->usb;
+	u32 data = ~0;
+	u16 offset;
+	int ret;
+	u8 req;
+
+	switch (addr & MT_VEND_TYPE_MASK) {
+	case MT_VEND_TYPE_EEPROM:
+		req = MT_VEND_READ_EEPROM;
+		break;
+	case MT_VEND_TYPE_CFG:
+		req = MT_VEND_READ_CFG;
+		break;
+	default:
+		req = MT_VEND_MULTI_READ;
+		break;
+	}
+	offset = addr & ~MT_VEND_TYPE_MASK;
+
+	ret = __mt76u_vendor_request(dev, req,
+				     USB_DIR_IN | USB_TYPE_VENDOR,
+				     0, offset, usb->data, sizeof(__le32));
+	if (ret == sizeof(__le32))
+		data = get_unaligned_le32(usb->data);
+	trace_usb_reg_rr(dev, addr, data);
+
+	return data;
+}
+
+u32 mt76u_rr(struct mt76_dev *dev, u32 addr)
+{
+	u32 ret;
+
+	mutex_lock(&dev->usb.usb_ctrl_mtx);
+	ret = __mt76u_rr(dev, addr);
+	mutex_unlock(&dev->usb.usb_ctrl_mtx);
+
+	return ret;
+}
+
+/* should be called with usb_ctrl_mtx locked */
+static void __mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
+{
+	struct mt76_usb *usb = &dev->usb;
+	u16 offset;
+	u8 req;
+
+	switch (addr & MT_VEND_TYPE_MASK) {
+	case MT_VEND_TYPE_CFG:
+		req = MT_VEND_WRITE_CFG;
+		break;
+	default:
+		req = MT_VEND_MULTI_WRITE;
+		break;
+	}
+	offset = addr & ~MT_VEND_TYPE_MASK;
+
+	put_unaligned_le32(val, usb->data);
+	__mt76u_vendor_request(dev, req,
+			       USB_DIR_OUT | USB_TYPE_VENDOR, 0,
+			       offset, usb->data, sizeof(__le32));
+	trace_usb_reg_wr(dev, addr, val);
+}
+
+void mt76u_wr(struct mt76_dev *dev, u32 addr, u32 val)
+{
+	mutex_lock(&dev->usb.usb_ctrl_mtx);
+	__mt76u_wr(dev, addr, val);
+	mutex_unlock(&dev->usb.usb_ctrl_mtx);
+}
+
+static u32 mt76u_rmw(struct mt76_dev *dev, u32 addr,
+		     u32 mask, u32 val)
+{
+	mutex_lock(&dev->usb.usb_ctrl_mtx);
+	val |= __mt76u_rr(dev, addr) & ~mask;
+	__mt76u_wr(dev, addr, val);
+	mutex_unlock(&dev->usb.usb_ctrl_mtx);
+
+	return val;
+}
+
+static void mt76u_copy(struct mt76_dev *dev, u32 offset,
+		       const void *data, int len)
+{
+	struct mt76_usb *usb = &dev->usb;
+	const u32 *val = data;
+	int i, ret;
+
+	mutex_lock(&usb->usb_ctrl_mtx);
+	for (i = 0; i < (len / 4); i++) {
+		put_unaligned_le32(val[i], usb->data);
+		ret = __mt76u_vendor_request(dev, MT_VEND_MULTI_WRITE,
+					     USB_DIR_OUT | USB_TYPE_VENDOR,
+					     0, offset + i * 4, usb->data,
+					     sizeof(__le32));
+		if (ret < 0)
+			break;
+	}
+	mutex_unlock(&usb->usb_ctrl_mtx);
+}
+
+void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
+		     const u16 offset, const u32 val)
+{
+	mutex_lock(&dev->usb.usb_ctrl_mtx);
+	__mt76u_vendor_request(dev, req,
+			       USB_DIR_OUT | USB_TYPE_VENDOR,
+			       val & 0xffff, offset, NULL, 0);
+	__mt76u_vendor_request(dev, req,
+			       USB_DIR_OUT | USB_TYPE_VENDOR,
+			       val >> 16, offset + 2, NULL, 0);
+	mutex_unlock(&dev->usb.usb_ctrl_mtx);
+}
+EXPORT_SYMBOL_GPL(mt76u_single_wr);
+
+static int
+mt76u_set_endpoints(struct usb_interface *intf,
+		    struct mt76_usb *usb)
+{
+	struct usb_host_interface *intf_desc = intf->cur_altsetting;
+	struct usb_endpoint_descriptor *ep_desc;
+	int i, in_ep = 0, out_ep = 0;
+
+	for (i = 0; i < intf_desc->desc.bNumEndpoints; i++) {
+		ep_desc = &intf_desc->endpoint[i].desc;
+
+		if (usb_endpoint_is_bulk_in(ep_desc) &&
+		    in_ep < __MT_EP_IN_MAX) {
+			usb->in_ep[in_ep] = usb_endpoint_num(ep_desc);
+			usb->in_max_packet = usb_endpoint_maxp(ep_desc);
+			in_ep++;
+		} else if (usb_endpoint_is_bulk_out(ep_desc) &&
+			   out_ep < __MT_EP_OUT_MAX) {
+			usb->out_ep[out_ep] = usb_endpoint_num(ep_desc);
+			usb->out_max_packet = usb_endpoint_maxp(ep_desc);
+			out_ep++;
+		}
+	}
+
+	if (in_ep != __MT_EP_IN_MAX || out_ep != __MT_EP_OUT_MAX)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
+		 int nsgs, int len, int sglen)
+{
+	struct urb *urb = buf->urb;
+	int i;
+
+	for (i = 0; i < nsgs; i++) {
+		struct page *page;
+		void *data;
+		int offset;
+
+		data = netdev_alloc_frag(len);
+		if (!data)
+			break;
+
+		page = virt_to_head_page(data);
+		offset = data - page_address(page);
+		sg_set_page(&urb->sg[i], page, sglen, offset);
+	}
+
+	if (i < nsgs) {
+		int j;
+
+		for (j = nsgs; j < urb->num_sgs; j++)
+			skb_free_frag(sg_virt(&urb->sg[j]));
+		urb->num_sgs = i;
+	}
+
+	urb->num_sgs = max_t(int, i, urb->num_sgs);
+	buf->len = urb->num_sgs * sglen,
+	sg_init_marker(urb->sg, urb->num_sgs);
+
+	return i ? : -ENOMEM;
+}
+
+int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
+		    int nsgs, int len, int sglen, gfp_t gfp)
+{
+	buf->urb = usb_alloc_urb(0, gfp);
+	if (!buf->urb)
+		return -ENOMEM;
+
+	buf->urb->sg = devm_kzalloc(dev->dev, nsgs * sizeof(*buf->urb->sg),
+				    gfp);
+	if (!buf->urb->sg)
+		return -ENOMEM;
+
+	sg_init_table(buf->urb->sg, nsgs);
+	buf->dev = dev;
+
+	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
+}
+EXPORT_SYMBOL_GPL(mt76u_buf_alloc);
+
+void mt76u_buf_free(struct mt76u_buf *buf)
+{
+	struct urb *urb = buf->urb;
+	int i;
+
+	for (i = 0; i < urb->num_sgs; i++)
+		skb_free_frag(sg_virt(&urb->sg[i]));
+	usb_free_urb(buf->urb);
+}
+EXPORT_SYMBOL_GPL(mt76u_buf_free);
+
+int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
+		     struct mt76u_buf *buf, gfp_t gfp,
+		     usb_complete_t complete_fn, void *context)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	unsigned int pipe;
+
+	if (dir == USB_DIR_IN)
+		pipe = usb_rcvbulkpipe(udev, dev->usb.in_ep[index]);
+	else
+		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
+
+	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, buf->len,
+			  complete_fn, context);
+
+	return usb_submit_urb(buf->urb, gfp);
+}
+EXPORT_SYMBOL_GPL(mt76u_submit_buf);
+
+static inline struct mt76u_buf
+*mt76u_get_next_rx_entry(struct mt76_queue *q)
+{
+	struct mt76u_buf *buf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (q->queued > 0) {
+		buf = &q->entry[q->head].ubuf;
+		q->head = (q->head + 1) % q->ndesc;
+		q->queued--;
+	}
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return buf;
+}
+
+static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
+{
+	u16 dma_len, min_len;
+
+	dma_len = get_unaligned_le16(data);
+	min_len = MT_DMA_HDR_LEN + MT_RX_RXWI_LEN +
+		  MT_FCE_INFO_LEN;
+
+	if (data_len < min_len || WARN_ON(!dma_len) ||
+	    WARN_ON(dma_len + MT_DMA_HDR_LEN > data_len) ||
+	    WARN_ON(dma_len & 0x3))
+		return -EINVAL;
+	return dma_len;
+}
+
+static int
+mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	u8 *data = sg_virt(&urb->sg[0]);
+	int data_len, len, nsgs = 1;
+	struct sk_buff *skb;
+
+	if (!test_bit(MT76_STATE_INITIALIZED, &dev->state))
+		return 0;
+
+	len = mt76u_get_rx_entry_len(data, urb->actual_length);
+	if (len < 0)
+		return 0;
+
+	skb = build_skb(data, q->buf_size);
+	if (!skb)
+		return 0;
+
+	data_len = min_t(int, len, urb->sg[0].length - MT_DMA_HDR_LEN);
+	skb_reserve(skb, MT_DMA_HDR_LEN);
+	if (skb->tail + data_len > skb->end) {
+		dev_kfree_skb(skb);
+		return 1;
+	}
+
+	__skb_put(skb, data_len);
+	len -= data_len;
+
+	while (len > 0) {
+		data_len = min_t(int, len, urb->sg[nsgs].length);
+		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
+				sg_page(&urb->sg[nsgs]),
+				urb->sg[nsgs].offset,
+				data_len, q->buf_size);
+		len -= data_len;
+		nsgs++;
+	}
+	dev->drv->rx_skb(dev, MT_RXQ_MAIN, skb);
+
+	return nsgs;
+}
+
+static void mt76u_complete_rx(struct urb *urb)
+{
+	struct mt76_dev *dev = urb->context;
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	unsigned long flags;
+
+	switch (urb->status) {
+	case -ECONNRESET:
+	case -ESHUTDOWN:
+	case -ENOENT:
+		return;
+	default:
+		dev_err(dev->dev, "rx urb failed: %d\n", urb->status);
+		/* fall through */
+	case 0:
+		break;
+	}
+
+	spin_lock_irqsave(&q->lock, flags);
+	if (WARN_ONCE(q->entry[q->tail].ubuf.urb != urb, "rx urb mismatch"))
+		goto out;
+
+	q->tail = (q->tail + 1) % q->ndesc;
+	q->queued++;
+	tasklet_schedule(&dev->usb.rx_tasklet);
+out:
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+
+static void mt76u_rx_tasklet(unsigned long data)
+{
+	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	int err, nsgs, buf_len = q->buf_size;
+	struct mt76u_buf *buf;
+
+	rcu_read_lock();
+
+	while (true) {
+		buf = mt76u_get_next_rx_entry(q);
+		if (!buf)
+			break;
+
+		nsgs = mt76u_process_rx_entry(dev, buf->urb);
+		if (nsgs > 0) {
+			err = mt76u_fill_rx_sg(dev, buf, nsgs,
+					       buf_len,
+					       SKB_WITH_OVERHEAD(buf_len));
+			if (err < 0)
+				break;
+		}
+		mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX,
+				 buf, GFP_ATOMIC,
+				 mt76u_complete_rx, dev);
+	}
+	mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
+
+	rcu_read_unlock();
+}
+
+int mt76u_submit_rx_buffers(struct mt76_dev *dev)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	unsigned long flags;
+	int i, err = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	for (i = 0; i < q->ndesc; i++) {
+		err = mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX,
+				       &q->entry[i].ubuf, GFP_ATOMIC,
+				       mt76u_complete_rx, dev);
+		if (err < 0)
+			break;
+	}
+	q->head = q->tail = 0;
+	q->queued = 0;
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
+
+static int mt76u_alloc_rx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	int i, err, nsgs;
+
+	spin_lock_init(&q->lock);
+	q->entry = devm_kzalloc(dev->dev,
+				MT_NUM_RX_ENTRIES * sizeof(*q->entry),
+				GFP_KERNEL);
+	if (!q->entry)
+		return -ENOMEM;
+
+	if (mt76u_check_sg(dev)) {
+		q->buf_size = MT_RX_BUF_SIZE;
+		nsgs = MT_SG_MAX_SIZE;
+	} else {
+		q->buf_size = PAGE_SIZE;
+		nsgs = 1;
+	}
+
+	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
+		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
+				      nsgs, q->buf_size,
+				      SKB_WITH_OVERHEAD(q->buf_size),
+				      GFP_KERNEL);
+		if (err < 0)
+			return err;
+	}
+	q->ndesc = MT_NUM_RX_ENTRIES;
+
+	return mt76u_submit_rx_buffers(dev);
+}
+
+static void mt76u_free_rx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	int i;
+
+	for (i = 0; i < q->ndesc; i++)
+		mt76u_buf_free(&q->entry[i].ubuf);
+}
+
+static void mt76u_stop_rx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	int i;
+
+	for (i = 0; i < q->ndesc; i++)
+		usb_kill_urb(q->entry[i].ubuf.urb);
+}
+
+int mt76u_skb_dma_info(struct sk_buff *skb, int port, u32 flags)
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
+EXPORT_SYMBOL_GPL(mt76u_skb_dma_info);
+
+static void mt76u_tx_tasklet(unsigned long data)
+{
+	struct mt76_dev *dev = (struct mt76_dev *)data;
+	struct mt76u_buf *buf;
+	struct mt76_queue *q;
+	bool wake;
+	int i;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		q = &dev->q_tx[i];
+
+		spin_lock_bh(&q->lock);
+		while (true) {
+			buf = &q->entry[q->head].ubuf;
+			if (!buf->done || !q->queued)
+				break;
+
+			dev->drv->tx_complete_skb(dev, q,
+						  &q->entry[q->head],
+						  false);
+
+			if (q->entry[q->head].schedule) {
+				q->entry[q->head].schedule = false;
+				q->swq_queued--;
+			}
+
+			q->head = (q->head + 1) % q->ndesc;
+			q->queued--;
+		}
+		mt76_txq_schedule(dev, q);
+		wake = i < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+		if (!q->queued)
+			wake_up(&dev->tx_wait);
+
+		spin_unlock_bh(&q->lock);
+
+		if (!test_and_set_bit(MT76_READING_STATS, &dev->state))
+			ieee80211_queue_delayed_work(dev->hw,
+						     &dev->usb.stat_work,
+						     msecs_to_jiffies(10));
+
+		if (wake)
+			ieee80211_wake_queue(dev->hw, i);
+	}
+}
+
+static void mt76u_tx_status_data(struct work_struct *work)
+{
+	struct mt76_usb *usb;
+	struct mt76_dev *dev;
+	u8 update = 1;
+	u16 count = 0;
+
+	usb = container_of(work, struct mt76_usb, stat_work.work);
+	dev = container_of(usb, struct mt76_dev, usb);
+
+	while (true) {
+		if (test_bit(MT76_REMOVED, &dev->state))
+			break;
+
+		if (!dev->drv->tx_status_data(dev, &update))
+			break;
+		count++;
+	}
+
+	if (count && test_bit(MT76_STATE_RUNNING, &dev->state))
+		ieee80211_queue_delayed_work(dev->hw, &usb->stat_work,
+					     msecs_to_jiffies(10));
+	else
+		clear_bit(MT76_READING_STATS, &dev->state);
+}
+
+static void mt76u_complete_tx(struct urb *urb)
+{
+	struct mt76u_buf *buf = urb->context;
+	struct mt76_dev *dev = buf->dev;
+
+	if (mt76u_urb_error(urb))
+		dev_err(dev->dev, "tx urb failed: %d\n", urb->status);
+	buf->done = true;
+
+	tasklet_schedule(&dev->usb.tx_tasklet);
+}
+
+static int
+mt76u_tx_build_sg(struct sk_buff *skb, struct urb *urb)
+{
+	int nsgs = 1 + skb_shinfo(skb)->nr_frags;
+	struct sk_buff *iter;
+
+	skb_walk_frags(skb, iter)
+		nsgs += 1 + skb_shinfo(iter)->nr_frags;
+
+	memset(urb->sg, 0, sizeof(*urb->sg) * MT_SG_MAX_SIZE);
+
+	nsgs = min_t(int, MT_SG_MAX_SIZE, nsgs);
+	sg_init_marker(urb->sg, nsgs);
+	urb->num_sgs = nsgs;
+
+	return skb_to_sgvec_nomark(skb, urb->sg, 0, skb->len);
+}
+
+static int
+mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+		   struct sk_buff *skb, struct mt76_wcid *wcid,
+		   struct ieee80211_sta *sta)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	u8 ep = q2ep(q->hw_idx);
+	struct mt76u_buf *buf;
+	u16 idx = q->tail;
+	unsigned int pipe;
+	int err;
+
+	if (q->queued == q->ndesc)
+		return -ENOSPC;
+
+	err = dev->drv->tx_prepare_skb(dev, NULL, skb, q, wcid, sta, NULL);
+	if (err < 0)
+		return err;
+
+	buf = &q->entry[idx].ubuf;
+	buf->done = false;
+
+	err = mt76u_tx_build_sg(skb, buf->urb);
+	if (err < 0)
+		return err;
+
+	pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[ep]);
+	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, skb->len,
+			  mt76u_complete_tx, buf);
+
+	q->tail = (q->tail + 1) % q->ndesc;
+	q->entry[idx].skb = skb;
+	q->queued++;
+
+	return idx;
+}
+
+static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	struct mt76u_buf *buf;
+	int err;
+
+	while (q->first != q->tail) {
+		buf = &q->entry[q->first].ubuf;
+		err = usb_submit_urb(buf->urb, GFP_ATOMIC);
+		if (err < 0) {
+			if (err == -ENODEV)
+				set_bit(MT76_REMOVED, &dev->state);
+			else
+				dev_err(dev->dev, "tx urb submit failed:%d\n",
+					err);
+			break;
+		}
+		q->first = (q->first + 1) % q->ndesc;
+	}
+}
+
+static int mt76u_alloc_tx(struct mt76_dev *dev)
+{
+	struct mt76u_buf *buf;
+	struct mt76_queue *q;
+	size_t size;
+	int i, j;
+
+	size = MT_SG_MAX_SIZE * sizeof(struct scatterlist);
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		q = &dev->q_tx[i];
+		spin_lock_init(&q->lock);
+		INIT_LIST_HEAD(&q->swq);
+		q->hw_idx = q2hwq(i);
+
+		q->entry = devm_kzalloc(dev->dev,
+					MT_NUM_TX_ENTRIES * sizeof(*q->entry),
+					GFP_KERNEL);
+		if (!q->entry)
+			return -ENOMEM;
+
+		q->ndesc = MT_NUM_TX_ENTRIES;
+		for (j = 0; j < q->ndesc; j++) {
+			buf = &q->entry[j].ubuf;
+			buf->dev = dev;
+
+			buf->urb = usb_alloc_urb(0, GFP_KERNEL);
+			if (!buf->urb)
+				return -ENOMEM;
+
+			buf->urb->sg = devm_kzalloc(dev->dev, size, GFP_KERNEL);
+			if (!buf->urb->sg)
+				return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+static void mt76u_free_tx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q;
+	int i, j;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		q = &dev->q_tx[i];
+		for (j = 0; j < q->ndesc; j++)
+			usb_free_urb(q->entry[j].ubuf.urb);
+	}
+}
+
+static void mt76u_stop_tx(struct mt76_dev *dev)
+{
+	struct mt76_queue *q;
+	int i, j;
+
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		q = &dev->q_tx[i];
+		for (j = 0; j < q->ndesc; j++)
+			usb_kill_urb(q->entry[j].ubuf.urb);
+	}
+}
+
+void mt76u_stop_queues(struct mt76_dev *dev)
+{
+	tasklet_disable(&dev->usb.rx_tasklet);
+	tasklet_disable(&dev->usb.tx_tasklet);
+
+	mt76u_stop_rx(dev);
+	mt76u_stop_tx(dev);
+}
+EXPORT_SYMBOL_GPL(mt76u_stop_queues);
+
+void mt76u_stop_stat_wk(struct mt76_dev *dev)
+{
+	cancel_delayed_work_sync(&dev->usb.stat_work);
+	clear_bit(MT76_READING_STATS, &dev->state);
+}
+EXPORT_SYMBOL_GPL(mt76u_stop_stat_wk);
+
+void mt76u_queues_deinit(struct mt76_dev *dev)
+{
+	mt76u_stop_queues(dev);
+
+	mt76u_free_rx(dev);
+	mt76u_free_tx(dev);
+}
+EXPORT_SYMBOL_GPL(mt76u_queues_deinit);
+
+int mt76u_alloc_queues(struct mt76_dev *dev)
+{
+	int err;
+
+	err = mt76u_alloc_rx(dev);
+	if (err < 0)
+		goto err;
+
+	err = mt76u_alloc_tx(dev);
+	if (err < 0)
+		goto err;
+
+	return 0;
+err:
+	mt76u_queues_deinit(dev);
+	return err;
+}
+EXPORT_SYMBOL_GPL(mt76u_alloc_queues);
+
+static const struct mt76_queue_ops usb_queue_ops = {
+	.tx_queue_skb = mt76u_tx_queue_skb,
+	.kick = mt76u_tx_kick,
+};
+
+int mt76u_init(struct mt76_dev *dev,
+	       struct usb_interface *intf)
+{
+	static const struct mt76_bus_ops mt76u_ops = {
+		.rr = mt76u_rr,
+		.wr = mt76u_wr,
+		.rmw = mt76u_rmw,
+		.copy = mt76u_copy,
+	};
+	struct mt76_usb *usb = &dev->usb;
+
+	tasklet_init(&usb->rx_tasklet, mt76u_rx_tasklet, (unsigned long)dev);
+	tasklet_init(&usb->tx_tasklet, mt76u_tx_tasklet, (unsigned long)dev);
+	INIT_DELAYED_WORK(&usb->stat_work, mt76u_tx_status_data);
+	skb_queue_head_init(&dev->rx_skb[MT_RXQ_MAIN]);
+
+	init_completion(&usb->mcu.cmpl);
+	mutex_init(&usb->mcu.mutex);
+
+	mutex_init(&usb->usb_ctrl_mtx);
+	dev->bus = &mt76u_ops;
+	dev->queue_ops = &usb_queue_ops;
+
+	return mt76u_set_endpoints(intf, usb);
+}
+EXPORT_SYMBOL_GPL(mt76u_init);
+
+MODULE_AUTHOR("Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
new file mode 100644
index 000000000000..070be803d463
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/usb_mcu.c
@@ -0,0 +1,242 @@
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
+
+#define MT_CMD_HDR_LEN			4
+
+#define MT_FCE_DMA_ADDR			0x0230
+#define MT_FCE_DMA_LEN			0x0234
+
+#define MT_TX_CPU_FROM_FCE_CPU_DESC_IDX	0x09a8
+
+struct sk_buff *mt76u_mcu_msg_alloc(const void *data, int len)
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
+EXPORT_SYMBOL_GPL(mt76u_mcu_msg_alloc);
+
+void mt76u_mcu_complete_urb(struct urb *urb)
+{
+	struct completion *cmpl = urb->context;
+
+	complete(cmpl);
+}
+EXPORT_SYMBOL_GPL(mt76u_mcu_complete_urb);
+
+static int mt76u_mcu_wait_resp(struct mt76_dev *dev, u8 seq)
+{
+	struct mt76_usb *usb = &dev->usb;
+	struct mt76u_buf *buf = &usb->mcu.res;
+	int i, ret;
+	u32 rxfce;
+
+	for (i = 0; i < 5; i++) {
+		if (!wait_for_completion_timeout(&usb->mcu.cmpl,
+						 msecs_to_jiffies(300)))
+			continue;
+
+		if (buf->urb->status)
+			return -EIO;
+
+		rxfce = get_unaligned_le32(sg_virt(&buf->urb->sg[0]));
+		ret = mt76u_submit_buf(dev, USB_DIR_IN,
+				       MT_EP_IN_CMD_RESP,
+				       buf, GFP_KERNEL,
+				       mt76u_mcu_complete_urb,
+				       &usb->mcu.cmpl);
+		if (ret)
+			return ret;
+
+		if (seq == FIELD_GET(MT_RX_FCE_INFO_CMD_SEQ, rxfce))
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
+int mt76u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
+		       int cmd, bool wait_resp)
+{
+	struct usb_interface *intf = to_usb_interface(dev->dev);
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct mt76_usb *usb = &dev->usb;
+	unsigned int pipe;
+	int ret, sent;
+	u8 seq = 0;
+	u32 info;
+
+	if (test_bit(MT76_REMOVED, &dev->state))
+		return 0;
+
+	mutex_lock(&usb->mcu.mutex);
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
+		goto out;
+
+	ret = usb_bulk_msg(udev, pipe, skb->data, skb->len, &sent, 500);
+	if (ret)
+		goto out;
+
+	if (wait_resp)
+		ret = mt76u_mcu_wait_resp(dev, seq);
+
+out:
+	mutex_unlock(&usb->mcu.mutex);
+
+	consume_skb(skb);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76u_mcu_send_msg);
+
+void mt76u_mcu_fw_reset(struct mt76_dev *dev)
+{
+	mt76u_vendor_request(dev, MT_VEND_DEV_MODE,
+			     USB_DIR_OUT | USB_TYPE_VENDOR,
+			     0x1, 0, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(mt76u_mcu_fw_reset);
+
+static int
+__mt76u_mcu_fw_send_data(struct mt76_dev *dev, struct mt76u_buf *buf,
+			 const void *fw_data, int len, u32 dst_addr)
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
+int mt76u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
+			   int data_len, u32 max_payload, u32 offset)
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
+		err = __mt76u_mcu_fw_send_data(dev, &buf, data + pos,
+					       len, offset + pos);
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
+EXPORT_SYMBOL_GPL(mt76u_mcu_fw_send_data);
+
+int mt76u_mcu_init_rx(struct mt76_dev *dev)
+{
+	struct mt76_usb *usb = &dev->usb;
+	int err;
+
+	err = mt76u_buf_alloc(dev, &usb->mcu.res, 1,
+			      MCU_RESP_URB_SIZE, MCU_RESP_URB_SIZE,
+			      GFP_KERNEL);
+	if (err < 0)
+		return err;
+
+	err = mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_CMD_RESP,
+			       &usb->mcu.res, GFP_KERNEL,
+			       mt76u_mcu_complete_urb,
+			       &usb->mcu.cmpl);
+	if (err < 0)
+		mt76u_buf_free(&usb->mcu.res);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(mt76u_mcu_init_rx);
diff --git a/drivers/net/wireless/mediatek/mt76/usb_trace.c b/drivers/net/wireless/mediatek/mt76/usb_trace.c
new file mode 100644
index 000000000000..7e1f540f0b7a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/usb_trace.c
@@ -0,0 +1,23 @@
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
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "usb_trace.h"
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/usb_trace.h b/drivers/net/wireless/mediatek/mt76/usb_trace.h
new file mode 100644
index 000000000000..52db7012304a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/usb_trace.h
@@ -0,0 +1,71 @@
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
+#if !defined(__MT76_USB_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __MT76_USB_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "mt76.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mt76_usb
+
+#define MAXNAME		32
+#define DEV_ENTRY   __array(char, wiphy_name, 32)
+#define DEV_ASSIGN  strlcpy(__entry->wiphy_name, wiphy_name(dev->hw->wiphy), MAXNAME)
+#define DEV_PR_FMT  "%s"
+#define DEV_PR_ARG  __entry->wiphy_name
+
+#define REG_ENTRY	__field(u32, reg) __field(u32, val)
+#define REG_ASSIGN	__entry->reg = reg; __entry->val = val
+#define REG_PR_FMT	" %04x=%08x"
+#define REG_PR_ARG	__entry->reg, __entry->val
+
+DECLARE_EVENT_CLASS(dev_reg_evt,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		REG_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		REG_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT REG_PR_FMT,
+		DEV_PR_ARG, REG_PR_ARG
+	)
+);
+
+DEFINE_EVENT(dev_reg_evt, usb_reg_rr,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+DEFINE_EVENT(dev_reg_evt, usb_reg_wr,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE usb_trace
+
+#include <trace/define_trace.h>
-- 
2.17.1
