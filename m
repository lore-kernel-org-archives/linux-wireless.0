Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:55550 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752344AbeGAONc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jul 2018 10:13:32 -0400
Received: by mail-wm0-f68.google.com with SMTP id v16-v6so6461199wmv.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2018 07:13:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 19/19] mt76: add driver code for MT76x2u based devices
Date: Sun,  1 Jul 2018 16:12:31 +0200
Message-Id: <20180701141231.25323-20-lorenzo.bianconi@redhat.com> (sfid-20180701_161352_672767_4BBE95E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MT76x2u is a 2x2 USB 802.11ac chipset by MediaTek. This driver currently
support station mode

Tested-by: <cug_yangyuancong@hotmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/Kconfig    |  10 +
 drivers/net/wireless/mediatek/mt76/Makefile   |   5 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h   |   4 +
 .../net/wireless/mediatek/mt76/mt76x2_regs.h  |  30 ++
 .../net/wireless/mediatek/mt76/mt76x2_usb.c   | 142 +++++
 drivers/net/wireless/mediatek/mt76/mt76x2u.h  |  84 +++
 .../net/wireless/mediatek/mt76/mt76x2u_core.c | 110 ++++
 .../net/wireless/mediatek/mt76/mt76x2u_init.c | 318 ++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2u_mac.c  | 240 +++++++++
 .../net/wireless/mediatek/mt76/mt76x2u_main.c | 185 +++++++
 .../net/wireless/mediatek/mt76/mt76x2u_mcu.c  | 490 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x2u_phy.c  | 303 +++++++++++
 12 files changed, 1921 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index ba17cdd46ea3..69906c733a1c 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -17,3 +17,13 @@ config MT76x2E
 	depends on PCI
 	---help---
 	  This adds support for MT7612/MT7602/MT7662-based wireless PCIe devices.
+
+config MT76x2U
+	tristate "MediaTek MT76x2U (USB) support"
+	select MT76_CORE
+	select MT76_USB
+	select MT76x2_COMMON
+	depends on MAC80211
+	depends on USB
+	help
+	  This adds support for MT7612U-based wireless USB dongles.
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index de0a4bc235d1..dfe1c1ba60db 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -2,6 +2,7 @@ obj-$(CONFIG_MT76_CORE) += mt76.o
 obj-$(CONFIG_MT76_USB) += mt76-usb.o
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2-common.o
 obj-$(CONFIG_MT76x2E) += mt76x2e.o
+obj-$(CONFIG_MT76x2U) += mt76x2u.o
 
 mt76-y := \
 	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o tx.o agg-rx.o
@@ -22,4 +23,8 @@ mt76x2e-y := \
 	mt76x2_core.o mt76x2_mac.o mt76x2_mcu.o mt76x2_phy.o \
 	mt76x2_dfs.o mt76x2_trace.o
 
+mt76x2u-y := \
+	mt76x2_usb.o mt76x2u_init.o mt76x2u_main.o mt76x2u_mac.o \
+	mt76x2u_mcu.o mt76x2u_phy.o mt76x2u_core.o
+
 CFLAGS_mt76x2_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 0fd2e49fb1bc..5d4c4b7ba6b6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -33,6 +33,9 @@
 #define MT7662_ROM_PATCH	"mt7662_rom_patch.bin"
 #define MT7662_EEPROM_SIZE	512
 
+#define MT7662U_FIRMWARE	"mt7662u.bin"
+#define MT7662U_ROM_PATCH	"mt7662u_rom_patch.bin"
+
 #define MT76x2_RX_RING_SIZE	256
 #define MT_RX_HEADROOM		32
 
@@ -55,6 +58,7 @@ struct mt76x2_mcu {
 
 	wait_queue_head_t wait;
 	struct sk_buff_head res_q;
+	struct mt76u_buf res_u;
 
 	u32 msg_seq;
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
index b9c334d9e5b8..1551ea453180 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_regs.h
@@ -75,6 +75,21 @@
 
 #define MT_XO_CTRL7			0x011c
 
+#define MT_USB_U3DMA_CFG		0x9018
+#define MT_USB_DMA_CFG_RX_BULK_AGG_TOUT	GENMASK(7, 0)
+#define MT_USB_DMA_CFG_RX_BULK_AGG_LMT	GENMASK(15, 8)
+#define MT_USB_DMA_CFG_UDMA_TX_WL_DROP	BIT(16)
+#define MT_USB_DMA_CFG_WAKE_UP_EN	BIT(17)
+#define MT_USB_DMA_CFG_RX_DROP_OR_PAD	BIT(18)
+#define MT_USB_DMA_CFG_TX_CLR		BIT(19)
+#define MT_USB_DMA_CFG_TXOP_HALT	BIT(20)
+#define MT_USB_DMA_CFG_RX_BULK_AGG_EN	BIT(21)
+#define MT_USB_DMA_CFG_RX_BULK_EN	BIT(22)
+#define MT_USB_DMA_CFG_TX_BULK_EN	BIT(23)
+#define MT_USB_DMA_CFG_EP_OUT_VALID	GENMASK(29, 24)
+#define MT_USB_DMA_CFG_RX_BUSY		BIT(30)
+#define MT_USB_DMA_CFG_TX_BUSY		BIT(31)
+
 #define MT_WLAN_MTC_CTRL		0x10148
 #define MT_WLAN_MTC_CTRL_MTCMOS_PWR_UP	BIT(0)
 #define MT_WLAN_MTC_CTRL_PWR_ACK	BIT(12)
@@ -150,6 +165,9 @@
 #define MT_TX_HW_QUEUE_MCU		8
 #define MT_TX_HW_QUEUE_MGMT		9
 
+#define MT_US_CYC_CFG			0x02a4
+#define MT_US_CYC_CNT			GENMASK(7, 0)
+
 #define MT_PBF_SYS_CTRL			0x0400
 #define MT_PBF_SYS_CTRL_MCU_RESET	BIT(0)
 #define MT_PBF_SYS_CTRL_DMA_RESET	BIT(1)
@@ -202,6 +220,11 @@
 
 #define MT_FCE_WLAN_FLOW_CONTROL1	0x0824
 
+#define MT_TX_CPU_FROM_FCE_BASE_PTR	0x09a0
+#define MT_TX_CPU_FROM_FCE_MAX_COUNT	0x09a4
+#define MT_FCE_PDMA_GLOBAL_CONF		0x09c4
+#define MT_FCE_SKIP_FS			0x0a6c
+
 #define MT_PAUSE_ENABLE_CONTROL1	0x0a38
 
 #define MT_MAC_CSR0			0x1000
@@ -214,6 +237,7 @@
 
 #define MT_MAC_ADDR_DW0			0x1008
 #define MT_MAC_ADDR_DW1			0x100c
+#define MT_MAC_ADDR_DW1_U2ME_MASK	GENMASK(23, 16)
 
 #define MT_MAC_BSSID_DW0		0x1010
 #define MT_MAC_BSSID_DW1		0x1014
@@ -351,6 +375,7 @@
 #define MT_TX_TIMEOUT_CFG_ACKTO		GENMASK(15, 8)
 
 #define MT_TX_RETRY_CFG			0x134c
+#define MT_TX_LINK_CFG			0x1350
 #define MT_VHT_HT_FBK_CFG1		0x1358
 
 #define MT_PROT_CFG_RATE		GENMASK(15, 0)
@@ -425,6 +450,7 @@
 #define MT_RX_FILTR_CFG_BAR		BIT(15)
 #define MT_RX_FILTR_CFG_CTRL_RSV	BIT(16)
 
+#define MT_AUTO_RSP_CFG			0x1404
 #define MT_LEGACY_BASIC_RATE		0x1408
 #define MT_HT_BASIC_RATE		0x140c
 
@@ -460,6 +486,10 @@
 #define MT_RX_STAT_2_DUP_ERRORS		GENMASK(15, 0)
 #define MT_RX_STAT_2_OVERFLOW_ERRORS	GENMASK(31, 16)
 
+#define MT_TX_STA_0			0x170c
+#define MT_TX_STA_1			0x1710
+#define MT_TX_STA_2			0x1714
+
 #define MT_TX_STAT_FIFO			0x1718
 #define MT_TX_STAT_FIFO_VALID		BIT(0)
 #define MT_TX_STAT_FIFO_SUCCESS		BIT(5)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
new file mode 100644
index 000000000000..1428cfdee579
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_usb.c
@@ -0,0 +1,142 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "mt76x2u.h"
+
+static const struct usb_device_id mt76x2u_device_table[] = {
+	{ USB_DEVICE(0x0b05, 0x1833) },	/* Asus USB-AC54 */
+	{ USB_DEVICE(0x0b05, 0x17eb) },	/* Asus USB-AC55 */
+	{ USB_DEVICE(0x0b05, 0x180b) },	/* Asus USB-N53 B1 */
+	{ USB_DEVICE(0x0e8d, 0x7612) },	/* Aukey USB-AC1200 */
+	{ USB_DEVICE(0x057c, 0x8503) },	/* Avm FRITZ!WLAN AC860 */
+	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax EW 7722 UAC */
+	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
+	{ USB_DEVICE(0x045e, 0x02e6) },	/* XBox One Wireless Adapter */
+	{ },
+};
+
+static int mt76x2u_probe(struct usb_interface *intf,
+			 const struct usb_device_id *id)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct mt76x2_dev *dev;
+	int err;
+
+	dev = mt76x2u_alloc_device(&intf->dev);
+	if (!dev)
+		return -ENOMEM;
+
+	udev = usb_get_dev(udev);
+	usb_reset_device(udev);
+
+	err = mt76u_init(&dev->mt76, intf);
+	if (err < 0)
+		goto err;
+
+	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
+	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
+
+	err = mt76x2u_register_device(dev);
+	if (err < 0)
+		goto err;
+
+	return 0;
+
+err:
+	ieee80211_free_hw(mt76_hw(dev));
+	usb_set_intfdata(intf, NULL);
+	usb_put_dev(udev);
+
+	return err;
+}
+
+static void mt76x2u_disconnect(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	struct mt76x2_dev *dev = usb_get_intfdata(intf);
+	struct ieee80211_hw *hw = mt76_hw(dev);
+
+	set_bit(MT76_REMOVED, &dev->mt76.state);
+	ieee80211_unregister_hw(hw);
+	mt76x2u_cleanup(dev);
+
+	ieee80211_free_hw(hw);
+	usb_set_intfdata(intf, NULL);
+	usb_put_dev(udev);
+}
+
+static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
+					  pm_message_t state)
+{
+	struct mt76x2_dev *dev = usb_get_intfdata(intf);
+	struct mt76_usb *usb = &dev->mt76.usb;
+
+	mt76u_stop_queues(&dev->mt76);
+	mt76x2u_stop_hw(dev);
+	usb_kill_urb(usb->mcu.res.urb);
+
+	return 0;
+}
+
+static int __maybe_unused mt76x2u_resume(struct usb_interface *intf)
+{
+	struct mt76x2_dev *dev = usb_get_intfdata(intf);
+	struct mt76_usb *usb = &dev->mt76.usb;
+	int err;
+
+	reinit_completion(&usb->mcu.cmpl);
+	err = mt76u_submit_buf(&dev->mt76, USB_DIR_IN,
+			       MT_EP_IN_CMD_RESP,
+			       &usb->mcu.res, GFP_KERNEL,
+			       mt76u_mcu_complete_urb,
+			       &usb->mcu.cmpl);
+	if (err < 0)
+		return err;
+
+	err = mt76u_submit_rx_buffers(&dev->mt76);
+	if (err < 0)
+		return err;
+
+	tasklet_enable(&usb->rx_tasklet);
+	tasklet_enable(&usb->tx_tasklet);
+
+	return mt76x2u_init_hardware(dev);
+}
+
+MODULE_DEVICE_TABLE(usb, mt76x2u_device_table);
+MODULE_FIRMWARE(MT7662U_FIRMWARE);
+MODULE_FIRMWARE(MT7662U_ROM_PATCH);
+
+static struct usb_driver mt76x2u_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= mt76x2u_device_table,
+	.probe		= mt76x2u_probe,
+	.disconnect	= mt76x2u_disconnect,
+#ifdef CONFIG_PM
+	.suspend	= mt76x2u_suspend,
+	.resume		= mt76x2u_resume,
+	.reset_resume	= mt76x2u_resume,
+#endif /* CONFIG_PM */
+	.soft_unbind	= 1,
+	.disable_hub_initiated_lpm = 1,
+};
+module_usb_driver(mt76x2u_driver);
+
+MODULE_AUTHOR("Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
new file mode 100644
index 000000000000..a2274f758b84
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u.h
@@ -0,0 +1,84 @@
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
+#ifndef __MT76x2U_H
+#define __MT76x2U_H
+
+#include <linux/device.h>
+
+#include "mt76x2.h"
+#include "mt76x2_dma.h"
+#include "mt76x2_mcu.h"
+
+#define MT7612U_EEPROM_SIZE		512
+
+#define MT_USB_AGGR_SIZE_LIMIT		21 /* 1024B unit */
+#define MT_USB_AGGR_TIMEOUT		0x80 /* 33ns unit */
+
+extern const struct ieee80211_ops mt76x2u_ops;
+
+struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev);
+int mt76x2u_register_device(struct mt76x2_dev *dev);
+int mt76x2u_init_hardware(struct mt76x2_dev *dev);
+void mt76x2u_cleanup(struct mt76x2_dev *dev);
+void mt76x2u_stop_hw(struct mt76x2_dev *dev);
+
+void mt76x2u_mac_setaddr(struct mt76x2_dev *dev, u8 *addr);
+int mt76x2u_mac_reset(struct mt76x2_dev *dev);
+void mt76x2u_mac_resume(struct mt76x2_dev *dev);
+int mt76x2u_mac_start(struct mt76x2_dev *dev);
+int mt76x2u_mac_stop(struct mt76x2_dev *dev);
+
+int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
+			    struct cfg80211_chan_def *chandef);
+void mt76x2u_phy_calibrate(struct work_struct *work);
+void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev);
+void mt76x2u_phy_set_txdac(struct mt76x2_dev *dev);
+void mt76x2u_phy_set_rxpath(struct mt76x2_dev *dev);
+
+void mt76x2u_mcu_complete_urb(struct urb *urb);
+int mt76x2u_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
+			    u8 bw_index, bool scan);
+int mt76x2u_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
+			  u32 val);
+int mt76x2u_mcu_tssi_comp(struct mt76x2_dev *dev,
+			  struct mt76x2_tssi_comp *tssi_data);
+int mt76x2u_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
+			  bool force);
+int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
+				bool ext, int rssi, u32 false_cca);
+int mt76x2u_mcu_set_radio_state(struct mt76x2_dev *dev, bool val);
+int mt76x2u_mcu_load_cr(struct mt76x2_dev *dev, u8 type,
+			u8 temp_level, u8 channel);
+int mt76x2u_mcu_init(struct mt76x2_dev *dev);
+int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev);
+int mt76x2u_mcu_init_rx(struct mt76x2_dev *dev);
+void mt76x2u_mcu_deinit(struct mt76x2_dev *dev);
+
+int mt76x2u_alloc_queues(struct mt76x2_dev *dev);
+void mt76x2u_queues_deinit(struct mt76x2_dev *dev);
+void mt76x2u_stop_queues(struct mt76x2_dev *dev);
+bool mt76x2u_tx_status_data(struct mt76_dev *mdev, u8 *update);
+int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
+			   struct sk_buff *skb, struct mt76_queue *q,
+			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			   u32 *tx_info);
+void mt76x2u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			     struct mt76_queue_entry *e, bool flush);
+int mt76x2u_skb_dma_info(struct sk_buff *skb, enum dma_msg_port port,
+			 u32 flags);
+
+#endif /* __MT76x2U_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
new file mode 100644
index 000000000000..7b31d512a8ad
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -0,0 +1,110 @@
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
+#include "mt76x2u.h"
+#include "dma.h"
+
+static void mt76x2u_remove_dma_hdr(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	int hdr_len, len;
+
+	len = (unsigned long)info->status.status_driver_data[0];
+	skb_pull(skb, sizeof(struct mt76x2_txwi) + MT_DMA_HDR_LEN);
+	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdr_len % 4) {
+		memmove(skb->data + 2, skb->data, hdr_len);
+		skb_pull(skb, 2);
+	}
+}
+
+static int
+mt76x2u_check_skb_rooms(struct sk_buff *skb)
+{
+	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	u32 need_head;
+
+	need_head = sizeof(struct mt76x2_txwi) + MT_DMA_HDR_LEN;
+	if (hdr_len % 4)
+		need_head += 2;
+	return skb_cow(skb, need_head);
+}
+
+static int
+mt76x2u_set_txinfo(struct sk_buff *skb,
+		   struct mt76_wcid *wcid, u8 ep)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	enum mt76x2_qsel qsel;
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
+	return mt76u_skb_dma_info(skb, WLAN_PORT, flags);
+}
+
+bool mt76x2u_tx_status_data(struct mt76_dev *mdev, u8 *update)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x2_tx_status stat;
+
+	if (!mt76x2_mac_load_tx_status(dev, &stat))
+		return false;
+
+	mt76x2_send_tx_status(dev, &stat, update);
+
+	return true;
+}
+
+int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
+			   struct sk_buff *skb, struct mt76_queue *q,
+			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			   u32 *tx_info)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+	struct mt76x2_txwi *txwi;
+	int err, len = skb->len;
+
+	err = mt76x2u_check_skb_rooms(skb);
+	if (err < 0)
+		return -ENOMEM;
+
+	mt76x2_insert_hdr_pad(skb);
+
+	txwi = skb_push(skb, sizeof(struct mt76x2_txwi));
+	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
+
+	return mt76x2u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
+}
+
+void mt76x2u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			     struct mt76_queue_entry *e, bool flush)
+{
+	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
+
+	mt76x2u_remove_dma_hdr(e->skb);
+	mt76x2_tx_complete(dev, e->skb);
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
new file mode 100644
index 000000000000..a14bc77fe19f
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_init.c
@@ -0,0 +1,318 @@
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
+#include <linux/delay.h>
+
+#include "mt76x2u.h"
+#include "mt76x2_eeprom.h"
+
+static void mt76x2u_init_dma(struct mt76x2_dev *dev)
+{
+	u32 val = mt76_rr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG));
+
+	val |= MT_USB_DMA_CFG_RX_DROP_OR_PAD |
+	       MT_USB_DMA_CFG_RX_BULK_EN |
+	       MT_USB_DMA_CFG_TX_BULK_EN;
+
+	/* disable AGGR_BULK_RX in order to receive one
+	 * frame in each rx urb and avoid copies
+	 */
+	val &= ~MT_USB_DMA_CFG_RX_BULK_AGG_EN;
+	mt76_wr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG), val);
+}
+
+static void mt76x2u_power_on_rf_patch(struct mt76x2_dev *dev)
+{
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x130), BIT(0) | BIT(16));
+	udelay(1);
+
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x1c), 0xff);
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x1c), 0x30);
+
+	mt76_wr(dev, MT_VEND_ADDR(CFG, 0x14), 0x484f);
+	udelay(1);
+
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x130), BIT(17));
+	usleep_range(150, 200);
+
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x130), BIT(16));
+	usleep_range(50, 100);
+
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x14c), BIT(19) | BIT(20));
+}
+
+static void mt76x2u_power_on_rf(struct mt76x2_dev *dev, int unit)
+{
+	int shift = unit ? 8 : 0;
+	u32 val = (BIT(1) | BIT(3) | BIT(4) | BIT(5)) << shift;
+
+	/* Enable RF BG */
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x130), BIT(0) << shift);
+	usleep_range(10, 20);
+
+	/* Enable RFDIG LDO/AFE/ABB/ADDA */
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x130), val);
+	usleep_range(10, 20);
+
+	/* Switch RFDIG power to internal LDO */
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x130), BIT(2) << shift);
+	usleep_range(10, 20);
+
+	mt76x2u_power_on_rf_patch(dev);
+
+	mt76_set(dev, 0x530, 0xf);
+}
+
+static void mt76x2u_power_on(struct mt76x2_dev *dev)
+{
+	u32 val;
+
+	/* Turn on WL MTCMOS */
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x148),
+		 MT_WLAN_MTC_CTRL_MTCMOS_PWR_UP);
+
+	val = MT_WLAN_MTC_CTRL_STATE_UP |
+	      MT_WLAN_MTC_CTRL_PWR_ACK |
+	      MT_WLAN_MTC_CTRL_PWR_ACK_S;
+
+	mt76_poll(dev, MT_VEND_ADDR(CFG, 0x148), val, val, 1000);
+
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x148), 0x7f << 16);
+	usleep_range(10, 20);
+
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x148), 0xf << 24);
+	usleep_range(10, 20);
+
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x148), 0xf << 24);
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x148), 0xfff);
+
+	/* Turn on AD/DA power down */
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x1204), BIT(3));
+
+	/* WLAN function enable */
+	mt76_set(dev, MT_VEND_ADDR(CFG, 0x80), BIT(0));
+
+	/* Release BBP software reset */
+	mt76_clear(dev, MT_VEND_ADDR(CFG, 0x64), BIT(18));
+
+	mt76x2u_power_on_rf(dev, 0);
+	mt76x2u_power_on_rf(dev, 1);
+}
+
+static int mt76x2u_init_eeprom(struct mt76x2_dev *dev)
+{
+	u32 val, i;
+
+	dev->mt76.eeprom.data = devm_kzalloc(dev->mt76.dev,
+					     MT7612U_EEPROM_SIZE,
+					     GFP_KERNEL);
+	dev->mt76.eeprom.size = MT7612U_EEPROM_SIZE;
+	if (!dev->mt76.eeprom.data)
+		return -ENOMEM;
+
+	for (i = 0; i + 4 <= MT7612U_EEPROM_SIZE; i += 4) {
+		val = mt76_rr(dev, MT_VEND_ADDR(EEPROM, i));
+		put_unaligned_le32(val, dev->mt76.eeprom.data + i);
+	}
+
+	mt76x2_eeprom_parse_hw_cap(dev);
+	return 0;
+}
+
+struct mt76x2_dev *mt76x2u_alloc_device(struct device *pdev)
+{
+	static const struct mt76_driver_ops drv_ops = {
+		.tx_prepare_skb = mt76x2u_tx_prepare_skb,
+		.tx_complete_skb = mt76x2u_tx_complete_skb,
+		.tx_status_data = mt76x2u_tx_status_data,
+		.rx_skb = mt76x2_queue_rx_skb,
+	};
+	struct mt76x2_dev *dev;
+	struct mt76_dev *mdev;
+
+	mdev = mt76_alloc_device(sizeof(*dev), &mt76x2u_ops);
+	if (!mdev)
+		return NULL;
+
+	dev = container_of(mdev, struct mt76x2_dev, mt76);
+	mdev->dev = pdev;
+	mdev->drv = &drv_ops;
+
+	mutex_init(&dev->mutex);
+
+	return dev;
+}
+
+static void mt76x2u_init_beacon_offsets(struct mt76x2_dev *dev)
+{
+	mt76_wr(dev, MT_BCN_OFFSET(0), 0x18100800);
+	mt76_wr(dev, MT_BCN_OFFSET(1), 0x38302820);
+	mt76_wr(dev, MT_BCN_OFFSET(2), 0x58504840);
+	mt76_wr(dev, MT_BCN_OFFSET(3), 0x78706860);
+}
+
+int mt76x2u_init_hardware(struct mt76x2_dev *dev)
+{
+	static const u16 beacon_offsets[] = {
+		/* 512 byte per beacon */
+		0xc000, 0xc200, 0xc400, 0xc600,
+		0xc800, 0xca00, 0xcc00, 0xce00,
+		0xd000, 0xd200, 0xd400, 0xd600,
+		0xd800, 0xda00, 0xdc00, 0xde00
+	};
+	const struct mt76_wcid_addr addr = {
+		.macaddr = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
+		.ba_mask = 0,
+	};
+	int i, err;
+
+	dev->beacon_offsets = beacon_offsets;
+
+	mt76x2_reset_wlan(dev, true);
+	mt76x2u_power_on(dev);
+
+	if (!mt76x2_wait_for_mac(dev))
+		return -ETIMEDOUT;
+
+	err = mt76x2u_mcu_fw_init(dev);
+	if (err < 0)
+		return err;
+
+	if (!mt76_poll_msec(dev, MT_WPDMA_GLO_CFG,
+			    MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+			    MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 100))
+		return -EIO;
+
+	/* wait for asic ready after fw load. */
+	if (!mt76x2_wait_for_mac(dev))
+		return -ETIMEDOUT;
+
+	mt76_wr(dev, MT_HEADER_TRANS_CTRL_REG, 0);
+	mt76_wr(dev, MT_TSO_CTRL, 0);
+
+	mt76x2u_init_dma(dev);
+
+	err = mt76x2u_mcu_init(dev);
+	if (err < 0)
+		return err;
+
+	err = mt76x2u_mac_reset(dev);
+	if (err < 0)
+		return err;
+
+	mt76x2u_mac_setaddr(dev, dev->mt76.eeprom.data + MT_EE_MAC_ADDR);
+	dev->rxfilter = mt76_rr(dev, MT_RX_FILTR_CFG);
+
+	mt76x2u_init_beacon_offsets(dev);
+
+	if (!mt76x2_wait_for_bbp(dev))
+		return -ETIMEDOUT;
+
+	/* reset wcid table */
+	for (i = 0; i < 254; i++)
+		mt76_wr_copy(dev, MT_WCID_ADDR(i), &addr,
+			     sizeof(struct mt76_wcid_addr));
+
+	/* reset shared key table and pairwise key table */
+	for (i = 0; i < 4; i++)
+		mt76_wr(dev, MT_SKEY_MODE_BASE_0 + 4 * i, 0);
+	for (i = 0; i < 256; i++)
+		mt76_wr(dev, MT_WCID_ATTR(i), 1);
+
+	mt76_clear(dev, MT_BEACON_TIME_CFG,
+		   MT_BEACON_TIME_CFG_TIMER_EN |
+		   MT_BEACON_TIME_CFG_SYNC_MODE |
+		   MT_BEACON_TIME_CFG_TBTT_EN |
+		   MT_BEACON_TIME_CFG_BEACON_TX);
+
+	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
+	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x583f);
+
+	err = mt76x2u_mcu_load_cr(dev, MT_RF_BBP_CR, 0, 0);
+	if (err < 0)
+		return err;
+
+	mt76x2u_phy_set_rxpath(dev);
+	mt76x2u_phy_set_txdac(dev);
+
+	return mt76x2u_mac_stop(dev);
+}
+
+int mt76x2u_register_device(struct mt76x2_dev *dev)
+{
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct wiphy *wiphy = hw->wiphy;
+	int err;
+
+	INIT_DELAYED_WORK(&dev->cal_work, mt76x2u_phy_calibrate);
+	mt76x2_init_device(dev);
+
+	err = mt76x2u_init_eeprom(dev);
+	if (err < 0)
+		return err;
+
+	err = mt76x2u_mcu_init_rx(dev);
+	if (err < 0)
+		return err;
+
+	err = mt76u_alloc_queues(&dev->mt76);
+	if (err < 0)
+		goto fail;
+
+	err = mt76x2u_init_hardware(dev);
+	if (err < 0)
+		goto fail;
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
+
+	err = mt76_register_device(&dev->mt76, true, mt76x2_rates,
+				   ARRAY_SIZE(mt76x2_rates));
+	if (err)
+		goto fail;
+
+	/* check hw sg support in order to enable AMSDU */
+	if (mt76u_check_sg(&dev->mt76))
+		hw->max_tx_fragments = MT_SG_MAX_SIZE;
+	else
+		hw->max_tx_fragments = 1;
+
+	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+
+	mt76x2_init_debugfs(dev);
+	mt76x2_init_txpower(dev, &dev->mt76.sband_2g.sband);
+	mt76x2_init_txpower(dev, &dev->mt76.sband_5g.sband);
+
+	return 0;
+
+fail:
+	mt76x2u_cleanup(dev);
+	return err;
+}
+
+void mt76x2u_stop_hw(struct mt76x2_dev *dev)
+{
+	mt76u_stop_stat_wk(&dev->mt76);
+	cancel_delayed_work_sync(&dev->cal_work);
+	mt76x2u_mac_stop(dev);
+}
+
+void mt76x2u_cleanup(struct mt76x2_dev *dev)
+{
+	mt76x2u_mcu_set_radio_state(dev, false);
+	mt76x2u_stop_hw(dev);
+	mt76u_queues_deinit(&dev->mt76);
+	mt76x2u_mcu_deinit(dev);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
new file mode 100644
index 000000000000..eab7ab297aa6
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mac.c
@@ -0,0 +1,240 @@
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
+#include "mt76x2u.h"
+#include "mt76x2_eeprom.h"
+
+static void mt76x2u_mac_reset_counters(struct mt76x2_dev *dev)
+{
+	mt76_rr(dev, MT_RX_STAT_0);
+	mt76_rr(dev, MT_RX_STAT_1);
+	mt76_rr(dev, MT_RX_STAT_2);
+	mt76_rr(dev, MT_TX_STA_0);
+	mt76_rr(dev, MT_TX_STA_1);
+	mt76_rr(dev, MT_TX_STA_2);
+}
+
+static void mt76x2u_mac_fixup_xtal(struct mt76x2_dev *dev)
+{
+	s8 offset = 0;
+	u16 eep_val;
+
+	eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_2);
+
+	offset = eep_val & 0x7f;
+	if ((eep_val & 0xff) == 0xff)
+		offset = 0;
+	else if (eep_val & 0x80)
+		offset = 0 - offset;
+
+	eep_val >>= 8;
+	if (eep_val == 0x00 || eep_val == 0xff) {
+		eep_val = mt76x2_eeprom_get(dev, MT_EE_XTAL_TRIM_1);
+		eep_val &= 0xff;
+
+		if (eep_val == 0x00 || eep_val == 0xff)
+			eep_val = 0x14;
+	}
+
+	eep_val &= 0x7f;
+	mt76_rmw_field(dev, MT_VEND_ADDR(CFG, MT_XO_CTRL5),
+		       MT_XO_CTRL5_C2_VAL, eep_val + offset);
+	mt76_set(dev, MT_VEND_ADDR(CFG, MT_XO_CTRL6), MT_XO_CTRL6_C2_CTRL);
+
+	mt76_wr(dev, 0x504, 0x06000000);
+	mt76_wr(dev, 0x50c, 0x08800000);
+	mdelay(5);
+	mt76_wr(dev, 0x504, 0x0);
+
+	/* decrease SIFS from 16us to 13us */
+	mt76_rmw_field(dev, MT_XIFS_TIME_CFG,
+		       MT_XIFS_TIME_CFG_OFDM_SIFS, 0xd);
+	mt76_rmw_field(dev, MT_BKOFF_SLOT_CFG, MT_BKOFF_SLOT_CFG_CC_DELAY, 1);
+
+	/* init fce */
+	mt76_clear(dev, MT_FCE_L2_STUFF, MT_FCE_L2_STUFF_WR_MPDU_LEN_EN);
+
+	eep_val = mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_2);
+	switch (FIELD_GET(MT_EE_NIC_CONF_2_XTAL_OPTION, eep_val)) {
+	case 0:
+		mt76_wr(dev, MT_XO_CTRL7, 0x5c1fee80);
+		break;
+	case 1:
+		mt76_wr(dev, MT_XO_CTRL7, 0x5c1feed0);
+		break;
+	default:
+		break;
+	}
+}
+
+int mt76x2u_mac_reset(struct mt76x2_dev *dev)
+{
+	mt76_wr(dev, MT_WPDMA_GLO_CFG, BIT(4) | BIT(5));
+
+	/* init pbf regs */
+	mt76_wr(dev, MT_PBF_TX_MAX_PCNT, 0xefef3f1f);
+	mt76_wr(dev, MT_PBF_RX_MAX_PCNT, 0xfebf);
+
+	mt76_write_mac_initvals(dev);
+
+	mt76_wr(dev, MT_TX_LINK_CFG, 0x1020);
+	mt76_wr(dev, MT_AUTO_RSP_CFG, 0x13);
+	mt76_wr(dev, MT_MAX_LEN_CFG, 0x2f00);
+	mt76_wr(dev, MT_TX_RTS_CFG, 0x92b20);
+
+	mt76_wr(dev, MT_WMM_AIFSN, 0x2273);
+	mt76_wr(dev, MT_WMM_CWMIN, 0x2344);
+	mt76_wr(dev, MT_WMM_CWMAX, 0x34aa);
+
+	mt76_clear(dev, MT_MAC_SYS_CTRL,
+		   MT_MAC_SYS_CTRL_RESET_CSR |
+		   MT_MAC_SYS_CTRL_RESET_BBP);
+
+	if (is_mt7612(dev))
+		mt76_clear(dev, MT_COEXCFG0, MT_COEXCFG0_COEX_EN);
+
+	mt76_set(dev, MT_EXT_CCA_CFG, 0xf000);
+	mt76_clear(dev, MT_TX_ALC_CFG_4, BIT(31));
+
+	mt76x2u_mac_fixup_xtal(dev);
+
+	return 0;
+}
+
+int mt76x2u_mac_start(struct mt76x2_dev *dev)
+{
+	mt76x2u_mac_reset_counters(dev);
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL, MT_MAC_SYS_CTRL_ENABLE_TX);
+	wait_for_wpdma(dev);
+	usleep_range(50, 100);
+
+	mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX |
+		MT_MAC_SYS_CTRL_ENABLE_RX);
+
+	return 0;
+}
+
+int mt76x2u_mac_stop(struct mt76x2_dev *dev)
+{
+	int i, count = 0, val;
+	bool stopped = false;
+	u32 rts_cfg;
+
+	if (test_bit(MT76_REMOVED, &dev->mt76.state))
+		return -EIO;
+
+	rts_cfg = mt76_rr(dev, MT_TX_RTS_CFG);
+	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg & ~MT_TX_RTS_CFG_RETRY_LIMIT);
+
+	mt76_clear(dev, MT_TXOP_CTRL_CFG, BIT(20));
+	mt76_clear(dev, MT_TXOP_HLDR_ET, BIT(1));
+
+	/* wait tx dma to stop */
+	for (i = 0; i < 2000; i++) {
+		val = mt76_rr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG));
+		if (!(val & MT_USB_DMA_CFG_TX_BUSY) && i > 10)
+			break;
+		usleep_range(50, 100);
+	}
+
+	/* page count on TxQ */
+	for (i = 0; i < 200; i++) {
+		if (!(mt76_rr(dev, 0x0438) & 0xffffffff) &&
+		    !(mt76_rr(dev, 0x0a30) & 0x000000ff) &&
+		    !(mt76_rr(dev, 0x0a34) & 0xff00ff00))
+			break;
+		usleep_range(10, 20);
+	}
+
+	/* disable tx-rx */
+	mt76_clear(dev, MT_MAC_SYS_CTRL,
+		   MT_MAC_SYS_CTRL_ENABLE_RX |
+		   MT_MAC_SYS_CTRL_ENABLE_TX);
+
+	/* Wait for MAC to become idle */
+	for (i = 0; i < 1000; i++) {
+		if (!(mt76_rr(dev, MT_MAC_STATUS) & MT_MAC_STATUS_TX) &&
+		    !mt76_rr(dev, MT_BBP(IBI, 12))) {
+			stopped = true;
+			break;
+		}
+		usleep_range(10, 20);
+	}
+
+	if (!stopped) {
+		mt76_set(dev, MT_BBP(CORE, 4), BIT(1));
+		mt76_clear(dev, MT_BBP(CORE, 4), BIT(1));
+
+		mt76_set(dev, MT_BBP(CORE, 4), BIT(0));
+		mt76_clear(dev, MT_BBP(CORE, 4), BIT(0));
+	}
+
+	/* page count on RxQ */
+	for (i = 0; i < 200; i++) {
+		if (!(mt76_rr(dev, 0x0430) & 0x00ff0000) &&
+		    !(mt76_rr(dev, 0x0a30) & 0xffffffff) &&
+		    !(mt76_rr(dev, 0x0a34) & 0xffffffff) &&
+		    ++count > 10)
+			break;
+		msleep(50);
+	}
+
+	if (!mt76_poll(dev, MT_MAC_STATUS, MT_MAC_STATUS_RX, 0, 2000))
+		dev_warn(dev->mt76.dev, "MAC RX failed to stop\n");
+
+	/* wait rx dma to stop */
+	for (i = 0; i < 2000; i++) {
+		val = mt76_rr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG));
+		if (!(val & MT_USB_DMA_CFG_RX_BUSY) && i > 10)
+			break;
+		usleep_range(50, 100);
+	}
+
+	mt76_wr(dev, MT_TX_RTS_CFG, rts_cfg);
+
+	return 0;
+}
+
+void mt76x2u_mac_resume(struct mt76x2_dev *dev)
+{
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX |
+		MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76_set(dev, MT_TXOP_CTRL_CFG, BIT(20));
+	mt76_set(dev, MT_TXOP_HLDR_ET, BIT(1));
+}
+
+void mt76x2u_mac_setaddr(struct mt76x2_dev *dev, u8 *addr)
+{
+	ether_addr_copy(dev->mt76.macaddr, addr);
+
+	if (!is_valid_ether_addr(dev->mt76.macaddr)) {
+		eth_random_addr(dev->mt76.macaddr);
+		dev_info(dev->mt76.dev,
+			 "Invalid MAC address, using random address %pM\n",
+			 dev->mt76.macaddr);
+	}
+
+	mt76_wr(dev, MT_MAC_ADDR_DW0, get_unaligned_le32(dev->mt76.macaddr));
+	mt76_wr(dev, MT_MAC_ADDR_DW1,
+		get_unaligned_le16(dev->mt76.macaddr + 4) |
+		FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
+}
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
new file mode 100644
index 000000000000..7367ba111119
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -0,0 +1,185 @@
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
+#include "mt76x2u.h"
+
+static int mt76x2u_start(struct ieee80211_hw *hw)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	int ret;
+
+	mutex_lock(&dev->mutex);
+
+	ret = mt76x2u_mac_start(dev);
+	if (ret)
+		goto out;
+
+	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+
+out:
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static void mt76x2u_stop(struct ieee80211_hw *hw)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mutex);
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	mt76x2u_stop_hw(dev);
+	mutex_unlock(&dev->mutex);
+}
+
+static int mt76x2u_add_interface(struct ieee80211_hw *hw,
+				 struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	struct mt76x2_vif *mvif = (struct mt76x2_vif *)vif->drv_priv;
+	unsigned int idx = 0;
+
+	if (!ether_addr_equal(dev->mt76.macaddr, vif->addr))
+		mt76x2u_mac_setaddr(dev, vif->addr);
+
+	mvif->idx = idx;
+	mvif->group_wcid.idx = MT_VIF_WCID(idx);
+	mvif->group_wcid.hw_key_idx = -1;
+	mt76x2_txq_init(dev, vif->txq);
+
+	return 0;
+}
+
+static int
+mt76x2u_set_channel(struct mt76x2_dev *dev,
+		    struct cfg80211_chan_def *chandef)
+{
+	int err;
+
+	cancel_delayed_work_sync(&dev->cal_work);
+	set_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76_set_channel(&dev->mt76);
+
+	mt76_clear(dev, MT_TXOP_CTRL_CFG, BIT(20));
+	mt76_clear(dev, MT_TXOP_HLDR_ET, BIT(1));
+	mt76x2_mac_stop(dev, false);
+
+	err = mt76x2u_phy_set_channel(dev, chandef);
+
+	mt76x2u_mac_resume(dev);
+
+	clear_bit(MT76_RESET, &dev->mt76.state);
+	mt76_txq_schedule_all(&dev->mt76);
+
+	return err;
+}
+
+static void
+mt76x2u_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			 struct ieee80211_bss_conf *info, u32 changed)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mutex);
+
+	if (changed & BSS_CHANGED_ASSOC) {
+		mt76x2u_phy_channel_calibrate(dev);
+		mt76x2_apply_gain_adj(dev);
+	}
+
+	if (changed & BSS_CHANGED_BSSID) {
+		mt76_wr(dev, MT_MAC_BSSID_DW0,
+			get_unaligned_le32(info->bssid));
+		mt76_wr(dev, MT_MAC_BSSID_DW1,
+			get_unaligned_le16(info->bssid + 4));
+	}
+
+	mutex_unlock(&dev->mutex);
+}
+
+static int
+mt76x2u_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct mt76x2_dev *dev = hw->priv;
+	int err = 0;
+
+	mutex_lock(&dev->mutex);
+
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
+			dev->rxfilter |= MT_RX_FILTR_CFG_PROMISC;
+		else
+			dev->rxfilter &= ~MT_RX_FILTR_CFG_PROMISC;
+		mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		ieee80211_stop_queues(hw);
+		err = mt76x2u_set_channel(dev, &hw->conf.chandef);
+		ieee80211_wake_queues(hw);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		dev->txpower_conf = hw->conf.power_level * 2;
+
+		/* convert to per-chain power for 2x2 devices */
+		dev->txpower_conf -= 6;
+
+		if (test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+			mt76x2_phy_set_txpower(dev);
+	}
+
+	mutex_unlock(&dev->mutex);
+
+	return err;
+}
+
+static void
+mt76x2u_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		const u8 *mac)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	set_bit(MT76_SCANNING, &dev->mt76.state);
+}
+
+static void
+mt76x2u_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt76x2_dev *dev = hw->priv;
+
+	clear_bit(MT76_SCANNING, &dev->mt76.state);
+}
+
+const struct ieee80211_ops mt76x2u_ops = {
+	.tx = mt76x2_tx,
+	.start = mt76x2u_start,
+	.stop = mt76x2u_stop,
+	.add_interface = mt76x2u_add_interface,
+	.remove_interface = mt76x2_remove_interface,
+	.sta_add = mt76x2_sta_add,
+	.sta_remove = mt76x2_sta_remove,
+	.set_key = mt76x2_set_key,
+	.ampdu_action = mt76x2_ampdu_action,
+	.config = mt76x2u_config,
+	.wake_tx_queue = mt76_wake_tx_queue,
+	.bss_info_changed = mt76x2u_bss_info_changed,
+	.configure_filter = mt76x2_configure_filter,
+	.conf_tx = mt76x2_conf_tx,
+	.sw_scan_start = mt76x2u_sw_scan,
+	.sw_scan_complete = mt76x2u_sw_scan_complete,
+	.sta_rate_tbl_update = mt76x2_sta_rate_tbl_update,
+};
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
new file mode 100644
index 000000000000..6430d17cef3d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_mcu.c
@@ -0,0 +1,490 @@
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
+#include "mt76x2u.h"
+#include "mt76x2_eeprom.h"
+
+#define MT_CMD_HDR_LEN			4
+#define MT_INBAND_PACKET_MAX_LEN	192
+#define MT_MCU_MEMMAP_WLAN		0x410000
+
+#define MCU_FW_URB_MAX_PAYLOAD		0x3900
+#define MCU_ROM_PATCH_MAX_PAYLOAD	2048
+
+#define MT76U_MCU_ILM_OFFSET		0x80000
+#define MT76U_MCU_DLM_OFFSET		0x110000
+#define MT76U_MCU_ROM_PATCH_OFFSET	0x90000
+
+static int
+mt76x2u_mcu_function_select(struct mt76x2_dev *dev, enum mcu_function func,
+			    u32 val)
+{
+	struct {
+		__le32 id;
+		__le32 value;
+	} __packed __aligned(4) msg = {
+		.id = cpu_to_le32(func),
+		.value = cpu_to_le32(val),
+	};
+	struct sk_buff *skb;
+
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_FUN_SET_OP,
+				  func != Q_SELECT);
+}
+
+int mt76x2u_mcu_set_radio_state(struct mt76x2_dev *dev, bool val)
+{
+	struct {
+		__le32 mode;
+		__le32 level;
+	} __packed __aligned(4) msg = {
+		.mode = cpu_to_le32(val ? RADIO_ON : RADIO_OFF),
+		.level = cpu_to_le32(0),
+	};
+	struct sk_buff *skb;
+
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_POWER_SAVING_OP,
+				  false);
+}
+
+int mt76x2u_mcu_load_cr(struct mt76x2_dev *dev, u8 type, u8 temp_level,
+			u8 channel)
+{
+	struct {
+		u8 cr_mode;
+		u8 temp;
+		u8 ch;
+		u8 _pad0;
+		__le32 cfg;
+	} __packed __aligned(4) msg = {
+		.cr_mode = type,
+		.temp = temp_level,
+		.ch = channel,
+	};
+	struct sk_buff *skb;
+	u32 val;
+
+	val = BIT(31);
+	val |= (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_0) >> 8) & 0x00ff;
+	val |= (mt76x2_eeprom_get(dev, MT_EE_NIC_CONF_1) << 8) & 0xff00;
+	msg.cfg = cpu_to_le32(val);
+
+	/* first set the channel without the extension channel info */
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_LOAD_CR, true);
+}
+
+int mt76x2u_mcu_set_channel(struct mt76x2_dev *dev, u8 channel, u8 bw,
+			    u8 bw_index, bool scan)
+{
+	struct {
+		u8 idx;
+		u8 scan;
+		u8 bw;
+		u8 _pad0;
+
+		__le16 chainmask;
+		u8 ext_chan;
+		u8 _pad1;
+
+	} __packed __aligned(4) msg = {
+		.idx = channel,
+		.scan = scan,
+		.bw = bw,
+		.chainmask = cpu_to_le16(dev->chainmask),
+	};
+	struct sk_buff *skb;
+
+	/* first set the channel without the extension channel info */
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+
+	mt76u_mcu_send_msg(&dev->mt76, skb, CMD_SWITCH_CHANNEL_OP, true);
+
+	usleep_range(5000, 10000);
+
+	msg.ext_chan = 0xe0 + bw_index;
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_SWITCH_CHANNEL_OP, true);
+}
+
+int mt76x2u_mcu_calibrate(struct mt76x2_dev *dev, enum mcu_calibration type,
+			  u32 val)
+{
+	struct {
+		__le32 id;
+		__le32 value;
+	} __packed __aligned(4) msg = {
+		.id = cpu_to_le32(type),
+		.value = cpu_to_le32(val),
+	};
+	struct sk_buff *skb;
+
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_CALIBRATION_OP, true);
+}
+
+int mt76x2u_mcu_init_gain(struct mt76x2_dev *dev, u8 channel, u32 gain,
+			  bool force)
+{
+	struct {
+		__le32 channel;
+		__le32 gain_val;
+	} __packed __aligned(4) msg = {
+		.channel = cpu_to_le32(channel),
+		.gain_val = cpu_to_le32(gain),
+	};
+	struct sk_buff *skb;
+
+	if (force)
+		msg.channel |= cpu_to_le32(BIT(31));
+
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_INIT_GAIN_OP, true);
+}
+
+int mt76x2u_mcu_set_dynamic_vga(struct mt76x2_dev *dev, u8 channel, bool ap,
+				bool ext, int rssi, u32 false_cca)
+{
+	struct {
+		__le32 channel;
+		__le32 rssi_val;
+		__le32 false_cca_val;
+	} __packed __aligned(4) msg = {
+		.rssi_val = cpu_to_le32(rssi),
+		.false_cca_val = cpu_to_le32(false_cca),
+	};
+	struct sk_buff *skb;
+	u32 val = channel;
+
+	if (ap)
+		val |= BIT(31);
+	if (ext)
+		val |= BIT(30);
+	msg.channel = cpu_to_le32(val);
+
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_DYNC_VGA_OP, true);
+}
+
+int mt76x2u_mcu_tssi_comp(struct mt76x2_dev *dev,
+			  struct mt76x2_tssi_comp *tssi_data)
+{
+	struct {
+		__le32 id;
+		struct mt76x2_tssi_comp data;
+	} __packed __aligned(4) msg = {
+		.id = cpu_to_le32(MCU_CAL_TSSI_COMP),
+		.data = *tssi_data,
+	};
+	struct sk_buff *skb;
+
+	skb = mt76u_mcu_msg_alloc(&msg, sizeof(msg));
+	if (!skb)
+		return -ENOMEM;
+	return mt76u_mcu_send_msg(&dev->mt76, skb, CMD_CALIBRATION_OP, true);
+}
+
+int mt76x2u_mcu_init_rx(struct mt76x2_dev *dev)
+{
+	struct mt76_usb *usb = &dev->mt76.usb;
+	int err;
+
+	err = mt76u_buf_alloc(&dev->mt76, &usb->mcu.res, 1,
+			      512, 512, GFP_KERNEL);
+	if (err < 0)
+		return err;
+
+	err = mt76u_submit_buf(&dev->mt76, USB_DIR_IN, MT_EP_IN_CMD_RESP,
+			       &usb->mcu.res, GFP_KERNEL,
+			       mt76u_mcu_complete_urb,
+			       &usb->mcu.cmpl);
+	if (err < 0)
+		mt76u_buf_free(&usb->mcu.res);
+
+	return err;
+}
+
+static void mt76x2u_mcu_fw_reset(struct mt76x2_dev *dev)
+{
+	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
+			     USB_DIR_OUT | USB_TYPE_VENDOR,
+			     0x1, 0, NULL, 0);
+}
+
+static void mt76x2u_mcu_load_ivb(struct mt76x2_dev *dev)
+{
+	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
+			     USB_DIR_OUT | USB_TYPE_VENDOR,
+			     0x12, 0, NULL, 0);
+}
+
+static void mt76x2u_mcu_enable_patch(struct mt76x2_dev *dev)
+{
+	struct mt76_usb *usb = &dev->mt76.usb;
+	const u8 data[] = {
+		0x6f, 0xfc, 0x08, 0x01,
+		0x20, 0x04, 0x00, 0x00,
+		0x00, 0x09, 0x00,
+	};
+
+	memcpy(usb->data, data, sizeof(data));
+	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
+			     USB_DIR_OUT | USB_TYPE_CLASS,
+			     0x12, 0, usb->data, sizeof(data));
+}
+
+static void mt76x2u_mcu_reset_wmt(struct mt76x2_dev *dev)
+{
+	struct mt76_usb *usb = &dev->mt76.usb;
+	u8 data[] = {
+		0x6f, 0xfc, 0x05, 0x01,
+		0x07, 0x01, 0x00, 0x04
+	};
+
+	memcpy(usb->data, data, sizeof(data));
+	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
+			     USB_DIR_OUT | USB_TYPE_CLASS,
+			     0x12, 0, usb->data, sizeof(data));
+}
+
+static int mt76x2u_mcu_load_rom_patch(struct mt76x2_dev *dev)
+{
+	bool rom_protect = !is_mt7612(dev);
+	struct mt76x2_patch_header *hdr;
+	u32 val, patch_mask, patch_reg;
+	const struct firmware *fw;
+	int err;
+
+	if (rom_protect &&
+	    !mt76_poll_msec(dev, MT_MCU_SEMAPHORE_03, 1, 1, 600)) {
+		dev_err(dev->mt76.dev,
+			"could not get hardware semaphore for ROM PATCH\n");
+		return -ETIMEDOUT;
+	}
+
+	if (mt76xx_rev(dev) >= MT76XX_REV_E3) {
+		patch_mask = BIT(0);
+		patch_reg = MT_MCU_CLOCK_CTL;
+	} else {
+		patch_mask = BIT(1);
+		patch_reg = MT_MCU_COM_REG0;
+	}
+
+	if (rom_protect && (mt76_rr(dev, patch_reg) & patch_mask)) {
+		dev_info(dev->mt76.dev, "ROM patch already applied\n");
+		return 0;
+	}
+
+	err = request_firmware(&fw, MT7662U_ROM_PATCH, dev->mt76.dev);
+	if (err < 0)
+		return err;
+
+	if (!fw || !fw->data || fw->size <= sizeof(*hdr)) {
+		dev_err(dev->mt76.dev, "failed to load firmware\n");
+		err = -EIO;
+		goto out;
+	}
+
+	hdr = (struct mt76x2_patch_header *)fw->data;
+	dev_info(dev->mt76.dev, "ROM patch build: %.15s\n", hdr->build_time);
+
+	/* enable USB_DMA_CFG */
+	val = MT_USB_DMA_CFG_RX_BULK_EN |
+	      MT_USB_DMA_CFG_TX_BULK_EN |
+	      FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20);
+	mt76_wr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG), val);
+
+	/* vendor reset */
+	mt76x2u_mcu_fw_reset(dev);
+	usleep_range(5000, 10000);
+
+	/* enable FCE to send in-band cmd */
+	mt76_wr(dev, MT_FCE_PSE_CTRL, 0x1);
+	/* FCE tx_fs_base_ptr */
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_BASE_PTR, 0x400230);
+	/* FCE tx_fs_max_cnt */
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_MAX_COUNT, 0x1);
+	/* FCE pdma enable */
+	mt76_wr(dev, MT_FCE_PDMA_GLOBAL_CONF, 0x44);
+	/* FCE skip_fs_en */
+	mt76_wr(dev, MT_FCE_SKIP_FS, 0x3);
+
+	err = mt76u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
+				     fw->size - sizeof(*hdr),
+				     MCU_ROM_PATCH_MAX_PAYLOAD,
+				     MT76U_MCU_ROM_PATCH_OFFSET);
+	if (err < 0) {
+		err = -EIO;
+		goto out;
+	}
+
+	mt76x2u_mcu_enable_patch(dev);
+	mt76x2u_mcu_reset_wmt(dev);
+	mdelay(20);
+
+	if (!mt76_poll_msec(dev, patch_reg, patch_mask, patch_mask, 100)) {
+		dev_err(dev->mt76.dev, "failed to load ROM patch\n");
+		err = -ETIMEDOUT;
+	}
+
+out:
+	if (rom_protect)
+		mt76_wr(dev, MT_MCU_SEMAPHORE_03, 1);
+	release_firmware(fw);
+	return err;
+}
+
+static int mt76x2u_mcu_load_firmware(struct mt76x2_dev *dev)
+{
+	u32 val, dlm_offset = MT76U_MCU_DLM_OFFSET;
+	const struct mt76x2_fw_header *hdr;
+	int err, len, ilm_len, dlm_len;
+	const struct firmware *fw;
+
+	err = request_firmware(&fw, MT7662U_FIRMWARE, dev->mt76.dev);
+	if (err < 0)
+		return err;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	hdr = (const struct mt76x2_fw_header *)fw->data;
+	ilm_len = le32_to_cpu(hdr->ilm_len);
+	dlm_len = le32_to_cpu(hdr->dlm_len);
+	len = sizeof(*hdr) + ilm_len + dlm_len;
+	if (fw->size != len) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	val = le16_to_cpu(hdr->fw_ver);
+	dev_info(dev->mt76.dev, "Firmware Version: %d.%d.%02d\n",
+		 (val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf);
+
+	val = le16_to_cpu(hdr->build_ver);
+	dev_info(dev->mt76.dev, "Build: %x\n", val);
+	dev_info(dev->mt76.dev, "Build Time: %.16s\n", hdr->build_time);
+
+	/* vendor reset */
+	mt76x2u_mcu_fw_reset(dev);
+	usleep_range(5000, 10000);
+
+	/* enable USB_DMA_CFG */
+	val = MT_USB_DMA_CFG_RX_BULK_EN |
+	      MT_USB_DMA_CFG_TX_BULK_EN |
+	      FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20);
+	mt76_wr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG), val);
+	/* enable FCE to send in-band cmd */
+	mt76_wr(dev, MT_FCE_PSE_CTRL, 0x1);
+	/* FCE tx_fs_base_ptr */
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_BASE_PTR, 0x400230);
+	/* FCE tx_fs_max_cnt */
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_MAX_COUNT, 0x1);
+	/* FCE pdma enable */
+	mt76_wr(dev, MT_FCE_PDMA_GLOBAL_CONF, 0x44);
+	/* FCE skip_fs_en */
+	mt76_wr(dev, MT_FCE_SKIP_FS, 0x3);
+
+	/* load ILM */
+	err = mt76u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
+				     ilm_len, MCU_FW_URB_MAX_PAYLOAD,
+				     MT76U_MCU_ILM_OFFSET);
+	if (err < 0) {
+		err = -EIO;
+		goto out;
+	}
+
+	/* load DLM */
+	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
+		dlm_offset += 0x800;
+	err = mt76u_mcu_fw_send_data(&dev->mt76,
+				     fw->data + sizeof(*hdr) + ilm_len,
+				     dlm_len, MCU_FW_URB_MAX_PAYLOAD,
+				     dlm_offset);
+	if (err < 0) {
+		err = -EIO;
+		goto out;
+	}
+
+	mt76x2u_mcu_load_ivb(dev);
+	if (!mt76_poll_msec(dev, MT_MCU_COM_REG0, 1, 1, 100)) {
+		dev_err(dev->mt76.dev, "firmware failed to start\n");
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
+	mt76_set(dev, MT_MCU_COM_REG0, BIT(1));
+	/* enable FCE to send in-band cmd */
+	mt76_wr(dev, MT_FCE_PSE_CTRL, 0x1);
+	dev_dbg(dev->mt76.dev, "firmware running\n");
+
+out:
+	release_firmware(fw);
+	return err;
+}
+
+int mt76x2u_mcu_fw_init(struct mt76x2_dev *dev)
+{
+	int err;
+
+	err = mt76x2u_mcu_load_rom_patch(dev);
+	if (err < 0)
+		return err;
+
+	return mt76x2u_mcu_load_firmware(dev);
+}
+
+int mt76x2u_mcu_init(struct mt76x2_dev *dev)
+{
+	int err;
+
+	err = mt76x2u_mcu_function_select(dev, Q_SELECT, 1);
+	if (err < 0)
+		return err;
+
+	return mt76x2u_mcu_set_radio_state(dev, true);
+}
+
+void mt76x2u_mcu_deinit(struct mt76x2_dev *dev)
+{
+	struct mt76_usb *usb = &dev->mt76.usb;
+
+	usb_kill_urb(usb->mcu.res.urb);
+	mt76u_buf_free(&usb->mcu.res);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
new file mode 100644
index 000000000000..5158063d0c2e
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_phy.c
@@ -0,0 +1,303 @@
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
+#include "mt76x2u.h"
+#include "mt76x2_eeprom.h"
+
+void mt76x2u_phy_set_rxpath(struct mt76x2_dev *dev)
+{
+	u32 val;
+
+	val = mt76_rr(dev, MT_BBP(AGC, 0));
+	val &= ~BIT(4);
+
+	switch (dev->chainmask & 0xf) {
+	case 2:
+		val |= BIT(3);
+		break;
+	default:
+		val &= ~BIT(3);
+		break;
+	}
+	mt76_wr(dev, MT_BBP(AGC, 0), val);
+}
+
+void mt76x2u_phy_set_txdac(struct mt76x2_dev *dev)
+{
+	int txpath;
+
+	txpath = (dev->chainmask >> 8) & 0xf;
+	switch (txpath) {
+	case 2:
+		mt76_set(dev, MT_BBP(TXBE, 5), 0x3);
+		break;
+	default:
+		mt76_clear(dev, MT_BBP(TXBE, 5), 0x3);
+		break;
+	}
+}
+
+void mt76x2u_phy_channel_calibrate(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	bool is_5ghz = chan->band == NL80211_BAND_5GHZ;
+
+	if (mt76x2_channel_silent(dev))
+		return;
+
+	mt76x2u_mac_stop(dev);
+
+	if (is_5ghz)
+		mt76x2u_mcu_calibrate(dev, MCU_CAL_LC, 0);
+
+	mt76x2u_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz);
+	mt76x2u_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz);
+	mt76x2u_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz);
+	mt76x2u_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0);
+
+	mt76x2u_mac_resume(dev);
+}
+
+static void
+mt76x2u_phy_tssi_compensate(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+	struct mt76x2_tx_power_info txp;
+	struct mt76x2_tssi_comp t = {};
+
+	if (!dev->cal.tssi_cal_done)
+		return;
+
+	if (!dev->cal.tssi_comp_pending) {
+		/* TSSI trigger */
+		t.cal_mode = BIT(0);
+		mt76x2u_mcu_tssi_comp(dev, &t);
+		dev->cal.tssi_comp_pending = true;
+	} else {
+		if (mt76_rr(dev, MT_BBP(CORE, 34)) & BIT(4))
+			return;
+
+		dev->cal.tssi_comp_pending = false;
+		mt76x2_get_power_info(dev, &txp, chan);
+
+		if (mt76x2_ext_pa_enabled(dev, chan->band))
+			t.pa_mode = 1;
+
+		t.cal_mode = BIT(1);
+		t.slope0 = txp.chain[0].tssi_slope;
+		t.offset0 = txp.chain[0].tssi_offset;
+		t.slope1 = txp.chain[1].tssi_slope;
+		t.offset1 = txp.chain[1].tssi_offset;
+		mt76x2u_mcu_tssi_comp(dev, &t);
+
+		if (t.pa_mode || dev->cal.dpd_cal_done)
+			return;
+
+		usleep_range(10000, 20000);
+		mt76x2u_mcu_calibrate(dev, MCU_CAL_DPD, chan->hw_value);
+		dev->cal.dpd_cal_done = true;
+	}
+}
+
+static void
+mt76x2u_phy_update_channel_gain(struct mt76x2_dev *dev)
+{
+	u8 channel = dev->mt76.chandef.chan->hw_value;
+	int freq, freq1;
+	u32 false_cca;
+
+	freq = dev->mt76.chandef.chan->center_freq;
+	freq1 = dev->mt76.chandef.center_freq1;
+
+	switch (dev->mt76.chandef.width) {
+	case NL80211_CHAN_WIDTH_80: {
+		int ch_group_index;
+
+		ch_group_index = (freq - freq1 + 30) / 20;
+		if (WARN_ON(ch_group_index < 0 || ch_group_index > 3))
+			ch_group_index = 0;
+		channel += 6 - ch_group_index * 4;
+		break;
+	}
+	case NL80211_CHAN_WIDTH_40:
+		if (freq1 > freq)
+			channel += 2;
+		else
+			channel -= 2;
+		break;
+	default:
+		break;
+	}
+
+	dev->cal.avg_rssi_all = mt76x2_phy_get_min_avg_rssi(dev);
+	false_cca = FIELD_GET(MT_RX_STAT_1_CCA_ERRORS,
+			      mt76_rr(dev, MT_RX_STAT_1));
+
+	mt76x2u_mcu_set_dynamic_vga(dev, channel, false, false,
+				    dev->cal.avg_rssi_all, false_cca);
+}
+
+void mt76x2u_phy_calibrate(struct work_struct *work)
+{
+	struct mt76x2_dev *dev;
+
+	dev = container_of(work, struct mt76x2_dev, cal_work.work);
+	mt76x2u_phy_tssi_compensate(dev);
+	mt76x2u_phy_update_channel_gain(dev);
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+}
+
+int mt76x2u_phy_set_channel(struct mt76x2_dev *dev,
+			    struct cfg80211_chan_def *chandef)
+{
+	u32 ext_cca_chan[4] = {
+		[0] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(0)),
+		[1] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(1)),
+		[2] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(2)),
+		[3] = FIELD_PREP(MT_EXT_CCA_CFG_CCA0, 3) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA1, 2) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA2, 1) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA3, 0) |
+		      FIELD_PREP(MT_EXT_CCA_CFG_CCA_MASK, BIT(3)),
+	};
+	bool scan = test_bit(MT76_SCANNING, &dev->mt76.state);
+	struct ieee80211_channel *chan = chandef->chan;
+	u8 channel = chan->hw_value, bw, bw_index;
+	int ch_group_index, freq, freq1, ret;
+
+	dev->cal.channel_cal_done = false;
+	freq = chandef->chan->center_freq;
+	freq1 = chandef->center_freq1;
+
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_40:
+		bw = 1;
+		if (freq1 > freq) {
+			bw_index = 1;
+			ch_group_index = 0;
+		} else {
+			bw_index = 3;
+			ch_group_index = 1;
+		}
+		channel += 2 - ch_group_index * 4;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		ch_group_index = (freq - freq1 + 30) / 20;
+		if (WARN_ON(ch_group_index < 0 || ch_group_index > 3))
+			ch_group_index = 0;
+		bw = 2;
+		bw_index = ch_group_index;
+		channel += 6 - ch_group_index * 4;
+		break;
+	default:
+		bw = 0;
+		bw_index = 0;
+		ch_group_index = 0;
+		break;
+	}
+
+	mt76x2_read_rx_gain(dev);
+	mt76x2_phy_set_txpower_regs(dev, chan->band);
+	mt76x2_configure_tx_delay(dev, chan->band, bw);
+	mt76x2_phy_set_txpower(dev);
+
+	mt76x2_phy_set_band(dev, chan->band, ch_group_index & 1);
+	mt76x2_phy_set_bw(dev, chandef->width, ch_group_index);
+
+	mt76_rmw(dev, MT_EXT_CCA_CFG,
+		 (MT_EXT_CCA_CFG_CCA0 |
+		  MT_EXT_CCA_CFG_CCA1 |
+		  MT_EXT_CCA_CFG_CCA2 |
+		  MT_EXT_CCA_CFG_CCA3 |
+		  MT_EXT_CCA_CFG_CCA_MASK),
+		 ext_cca_chan[ch_group_index]);
+
+	ret = mt76x2u_mcu_set_channel(dev, channel, bw, bw_index, scan);
+	if (ret)
+		return ret;
+
+	mt76x2u_mcu_init_gain(dev, channel, dev->cal.rx.mcu_gain, true);
+
+	/* Enable LDPC Rx */
+	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
+		mt76_set(dev, MT_BBP(RXO, 13), BIT(10));
+
+	if (!dev->cal.init_cal_done) {
+		u8 val = mt76x2_eeprom_get(dev, MT_EE_BT_RCAL_RESULT);
+
+		if (val != 0xff)
+			mt76x2u_mcu_calibrate(dev, MCU_CAL_R, 0);
+	}
+
+	mt76x2u_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel);
+
+	/* Rx LPF calibration */
+	if (!dev->cal.init_cal_done)
+		mt76x2u_mcu_calibrate(dev, MCU_CAL_RC, 0);
+	dev->cal.init_cal_done = true;
+
+	mt76_wr(dev, MT_BBP(AGC, 61), 0xff64a4e2);
+	mt76_wr(dev, MT_BBP(AGC, 7), 0x08081010);
+	mt76_wr(dev, MT_BBP(AGC, 11), 0x00000404);
+	mt76_wr(dev, MT_BBP(AGC, 2), 0x00007070);
+	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0X04101b3f);
+
+	mt76_set(dev, MT_BBP(TXO, 4), BIT(25));
+	mt76_set(dev, MT_BBP(RXO, 13), BIT(8));
+
+	if (scan)
+		return 0;
+
+	if (mt76x2_tssi_enabled(dev)) {
+		/* init default values for temp compensation */
+		mt76_rmw_field(dev, MT_TX_ALC_CFG_1, MT_TX_ALC_CFG_1_TEMP_COMP,
+			       0x38);
+		mt76_rmw_field(dev, MT_TX_ALC_CFG_2, MT_TX_ALC_CFG_2_TEMP_COMP,
+			       0x38);
+
+		/* init tssi calibration */
+		if (!mt76x2_channel_silent(dev)) {
+			struct ieee80211_channel *chan;
+			u32 flag = 0;
+
+			chan = dev->mt76.chandef.chan;
+			if (chan->band == NL80211_BAND_5GHZ)
+				flag |= BIT(0);
+			if (mt76x2_ext_pa_enabled(dev, chan->band))
+				flag |= BIT(8);
+			mt76x2u_mcu_calibrate(dev, MCU_CAL_TSSI, flag);
+			dev->cal.tssi_cal_done = true;
+		}
+	}
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->cal_work,
+				     MT_CALIBRATE_INTERVAL);
+	return 0;
+}
-- 
2.18.0
