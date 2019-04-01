Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3913EC4360F
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC7BA20896
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 07:17:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731966AbfDAHR1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 03:17:27 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:22029 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731774AbfDAHR1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 03:17:27 -0400
X-UUID: 551ae24a56674ac1bacd31b73e26f09d-20190401
X-UUID: 551ae24a56674ac1bacd31b73e26f09d-20190401
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1056373737; Mon, 01 Apr 2019 15:16:47 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 1 Apr 2019 15:16:45 +0800
Received: from mtkslt306.mediatek.inc (10.21.14.136) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 1 Apr 2019 15:16:45 +0800
From:   Ryder Lee <ryder.lee@mediatek.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>
CC:     Roy Luo <royluo@google.com>, Sean Wang <sean.wang@mediatek.com>,
        Nelson Chang <nelson.chang@mediatek.com>,
        YF Luo <yf.luo@mediatek.com>, Kai Lin <kai.lin@mediatek.com>,
        Rorscha Yang <rorscha.yang@mediatek.com>,
        Kyle Lee <kyle.lee@mediatek.com>,
        Miller Shen <miller.shen@mediatek.com>,
        Haipin Liang <haipin.liang@mediatek.com>,
        KL Huang <kl.huang@mediatek.com>,
        YH chen <yh.chen@mediatek.com>,
        <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Ryder Lee <ryder.lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH v3 1/4] mt76: add mac80211 driver for MT7615 PCIe-based chipsets
Date:   Mon, 1 Apr 2019 15:16:41 +0800
Message-ID: <4e974271e93b719e0463aa0269b4b970cc2b267f.1554102584.git.ryder.lee@mediatek.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1554102584.git.ryder.lee@mediatek.com>
References: <cover.1554102584.git.ryder.lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 0C1A1FF7952184F071578C7C2A247B1F6FEA7F3BF172C2EA8E4D1A2308DD38502000:8
X-MTK:  N
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This driver is for a newer generation of MediaTek MT7615 4x4 802.11ac
PCIe-based chipsets, which support wave2 MU-MIMO up to 4 users/group
and also support up to 160MHz bandwidth.

The driver fully supports AP, station and monitor mode.

Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Roy Luo <royluo@google.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v3:
-fix build error

Changes since v2:
-switch to use ISC license
-use sw assign sequence number
-add missing hw rate setting
---
 drivers/net/wireless/mediatek/mt76/Kconfig         |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile        |    1 +
 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig  |    7 +
 drivers/net/wireless/mediatek/mt76/mt7615/Makefile |    5 +
 drivers/net/wireless/mediatek/mt76/mt7615/dma.c    |  205 +++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |   98 ++
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h |   18 +
 drivers/net/wireless/mediatek/mt76/mt7615/init.c   |  229 +++
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  775 +++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mac.h    |  300 ++++
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  499 ++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    | 1656 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h    |  520 ++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  195 +++
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c    |  150 ++
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |  203 +++
 16 files changed, 4862 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7615/regs.h

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index dbe8c70..30e44e4 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -22,3 +22,4 @@ config MT76x02_USB
 source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
 source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
 source "drivers/net/wireless/mediatek/mt76/mt7603/Kconfig"
+source "drivers/net/wireless/mediatek/mt76/mt7615/Kconfig"
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index cad4fed..7beae23 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -23,3 +23,4 @@ mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2/
 obj-$(CONFIG_MT7603E) += mt7603/
+obj-$(CONFIG_MT7615E) += mt7615/
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/Kconfig b/drivers/net/wireless/mediatek/mt76/mt7615/Kconfig
new file mode 100644
index 0000000..3b8aba0
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/Kconfig
@@ -0,0 +1,7 @@
+config MT7615E
+	tristate "MediaTek MT7615E (PCIe) support"
+	select MT76_CORE
+	depends on MAC80211
+	depends on PCI
+	help
+	  This adds support for MT7615-based wireless PCIe devices.
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/Makefile b/drivers/net/wireless/mediatek/mt76/mt7615/Makefile
new file mode 100644
index 0000000..6397552
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/Makefile
@@ -0,0 +1,5 @@
+#SPDX-License-Identifier: ISC
+
+obj-$(CONFIG_MT7615E) += mt7615e.o
+
+mt7615e-y := pci.o init.o dma.o eeprom.o main.o mcu.o mac.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/dma.c b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
new file mode 100644
index 0000000..3ec6582
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/dma.c
@@ -0,0 +1,205 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Ryder Lee <ryder.lee@mediatek.com>
+ *         Roy Luo <royluo@google.com>
+ *         Lorenzo Bianconi <lorenzo@kernel.org>
+ *         Felix Fietkau <nbd@nbd.name>
+ */
+
+#include "mt7615.h"
+#include "../dma.h"
+#include "mac.h"
+
+static int
+mt7615_init_tx_queues(struct mt7615_dev *dev, int n_desc)
+{
+	struct mt76_sw_queue *q;
+	struct mt76_queue *hwq;
+	int err, i;
+
+	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return -ENOMEM;
+
+	err = mt76_queue_alloc(dev, hwq, 0, n_desc, 0, MT_TX_RING_BASE);
+	if (err < 0)
+		return err;
+
+	for (i = 0; i < MT_TXQ_MCU; i++) {
+		q = &dev->mt76.q_tx[i];
+		INIT_LIST_HEAD(&q->swq);
+		q->q = hwq;
+	}
+
+	return 0;
+}
+
+static int
+mt7615_init_mcu_queue(struct mt7615_dev *dev, struct mt76_sw_queue *q,
+		      int idx, int n_desc)
+{
+	struct mt76_queue *hwq;
+	int err;
+
+	hwq = devm_kzalloc(dev->mt76.dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return -ENOMEM;
+
+	err = mt76_queue_alloc(dev, hwq, idx, n_desc, 0, MT_TX_RING_BASE);
+	if (err < 0)
+		return err;
+
+	INIT_LIST_HEAD(&q->swq);
+	q->q = hwq;
+
+	return 0;
+}
+
+void mt7615_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb)
+{
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+	__le32 *rxd = (__le32 *)skb->data;
+	__le32 *end = (__le32 *)&skb->data[skb->len];
+	enum rx_pkt_type type;
+
+	type = FIELD_GET(MT_RXD0_PKT_TYPE, le32_to_cpu(rxd[0]));
+
+	switch (type) {
+	case PKT_TYPE_TXS:
+		for (rxd++; rxd + 7 <= end; rxd += 7)
+			mt7615_mac_add_txs(dev, rxd);
+		dev_kfree_skb(skb);
+		break;
+	case PKT_TYPE_TXRX_NOTIFY:
+		mt7615_mac_tx_free(dev, skb);
+		break;
+	case PKT_TYPE_RX_EVENT:
+		mt76_mcu_rx_event(&dev->mt76, skb);
+		break;
+	case PKT_TYPE_NORMAL:
+		if (!mt7615_mac_fill_rx(dev, skb)) {
+			mt76_rx(&dev->mt76, q, skb);
+			return;
+		}
+		/* fall through */
+	default:
+		dev_kfree_skb(skb);
+		break;
+	}
+}
+
+static void mt7615_tx_tasklet(unsigned long data)
+{
+	struct mt7615_dev *dev = (struct mt7615_dev *)data;
+	static const u8 queue_map[] = {
+		MT_TXQ_MCU,
+		MT_TXQ_BE
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(queue_map); i++)
+		mt76_queue_tx_cleanup(dev, queue_map[i], false);
+
+	mt76_txq_schedule_all(&dev->mt76);
+
+	mt7615_irq_enable(dev, MT_INT_TX_DONE_ALL);
+}
+
+int mt7615_dma_init(struct mt7615_dev *dev)
+{
+	int ret;
+
+	mt76_dma_attach(&dev->mt76);
+
+	tasklet_init(&dev->mt76.tx_tasklet, mt7615_tx_tasklet,
+		     (unsigned long)dev);
+
+	mt76_wr(dev, MT_WPDMA_GLO_CFG,
+		MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE |
+		MT_WPDMA_GLO_CFG_FIFO_LITTLE_ENDIAN |
+		MT_WPDMA_GLO_CFG_FIRST_TOKEN_ONLY |
+		MT_WPDMA_GLO_CFG_OMIT_TX_INFO);
+
+	mt76_rmw_field(dev, MT_WPDMA_GLO_CFG,
+		       MT_WPDMA_GLO_CFG_TX_BT_SIZE_BIT0, 0x1);
+
+	mt76_rmw_field(dev, MT_WPDMA_GLO_CFG,
+		       MT_WPDMA_GLO_CFG_TX_BT_SIZE_BIT21, 0x1);
+
+	mt76_rmw_field(dev, MT_WPDMA_GLO_CFG,
+		       MT_WPDMA_GLO_CFG_DMA_BURST_SIZE, 0x3);
+
+	mt76_rmw_field(dev, MT_WPDMA_GLO_CFG,
+		       MT_WPDMA_GLO_CFG_MULTI_DMA_EN, 0x3);
+
+	mt76_wr(dev, MT_WPDMA_GLO_CFG1, 0x1);
+	mt76_wr(dev, MT_WPDMA_TX_PRE_CFG, 0xf0000);
+	mt76_wr(dev, MT_WPDMA_RX_PRE_CFG, 0xf7f0000);
+	mt76_wr(dev, MT_WPDMA_ABT_CFG, 0x4000026);
+	mt76_wr(dev, MT_WPDMA_ABT_CFG1, 0x18811881);
+	mt76_set(dev, 0x7158, BIT(16));
+	mt76_clear(dev, 0x7000, BIT(23));
+	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
+
+	ret = mt7615_init_tx_queues(dev, MT7615_TX_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7615_init_mcu_queue(dev, &dev->mt76.q_tx[MT_TXQ_MCU],
+				    MT7615_TXQ_MCU,
+				    MT7615_TX_MCU_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7615_init_mcu_queue(dev, &dev->mt76.q_tx[MT_TXQ_FWDL],
+				    MT7615_TXQ_FWDL,
+				    MT7615_TX_FWDL_RING_SIZE);
+	if (ret)
+		return ret;
+
+	/* init rx queues */
+	ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MCU], 1,
+			       MT7615_RX_MCU_RING_SIZE, MT_RX_BUF_SIZE,
+			       MT_RX_RING_BASE);
+	if (ret)
+		return ret;
+
+	ret = mt76_queue_alloc(dev, &dev->mt76.q_rx[MT_RXQ_MAIN], 0,
+			       MT7615_RX_RING_SIZE, MT_RX_BUF_SIZE,
+			       MT_RX_RING_BASE);
+	if (ret)
+		return ret;
+
+	mt76_wr(dev, MT_DELAY_INT_CFG, 0);
+
+	ret = mt76_init_queues(dev);
+	if (ret < 0)
+		return ret;
+
+	mt76_poll(dev, MT_WPDMA_GLO_CFG,
+		  MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+		  MT_WPDMA_GLO_CFG_RX_DMA_BUSY, 0, 1000);
+
+	/* start dma engine */
+	mt76_set(dev, MT_WPDMA_GLO_CFG,
+		 MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		 MT_WPDMA_GLO_CFG_RX_DMA_EN);
+
+	/* enable interrupts for TX/RX rings */
+	mt7615_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL);
+
+	return 0;
+}
+
+void mt7615_dma_cleanup(struct mt7615_dev *dev)
+{
+	mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		   MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		   MT_WPDMA_GLO_CFG_RX_DMA_EN);
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_SW_RESET);
+
+	tasklet_kill(&dev->mt76.tx_tasklet);
+	mt76_dma_cleanup(&dev->mt76);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
new file mode 100644
index 0000000..dd5ab46
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Ryder Lee <ryder.lee@mediatek.com>
+ *         Felix Fietkau <nbd@nbd.name>
+ */
+
+#include "mt7615.h"
+#include "eeprom.h"
+
+static int mt7615_efuse_read(struct mt7615_dev *dev, u32 base,
+			     u16 addr, u8 *data)
+{
+	u32 val;
+	int i;
+
+	val = mt76_rr(dev, base + MT_EFUSE_CTRL);
+	val &= ~(MT_EFUSE_CTRL_AIN | MT_EFUSE_CTRL_MODE);
+	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf);
+	val |= MT_EFUSE_CTRL_KICK;
+	mt76_wr(dev, base + MT_EFUSE_CTRL, val);
+
+	if (!mt76_poll(dev, base + MT_EFUSE_CTRL, MT_EFUSE_CTRL_KICK, 0, 1000))
+		return -ETIMEDOUT;
+
+	udelay(2);
+
+	val = mt76_rr(dev, base + MT_EFUSE_CTRL);
+	if ((val & MT_EFUSE_CTRL_AOUT) == MT_EFUSE_CTRL_AOUT ||
+	    WARN_ON_ONCE(!(val & MT_EFUSE_CTRL_VALID))) {
+		memset(data, 0x0, 16);
+		return 0;
+	}
+
+	for (i = 0; i < 4; i++) {
+		val = mt76_rr(dev, base + MT_EFUSE_RDATA(i));
+		put_unaligned_le32(val, data + 4 * i);
+	}
+
+	return 0;
+}
+
+static int mt7615_efuse_init(struct mt7615_dev *dev)
+{
+	u32 base = mt7615_reg_map(dev, MT_EFUSE_BASE);
+	int len = MT7615_EEPROM_SIZE;
+	int ret, i;
+	void *buf;
+
+	if (mt76_rr(dev, base + MT_EFUSE_BASE_CTRL) & MT_EFUSE_BASE_CTRL_EMPTY)
+		return -EINVAL;
+
+	dev->mt76.otp.data = devm_kzalloc(dev->mt76.dev, len, GFP_KERNEL);
+	dev->mt76.otp.size = len;
+	if (!dev->mt76.otp.data)
+		return -ENOMEM;
+
+	buf = dev->mt76.otp.data;
+	for (i = 0; i + 16 <= len; i += 16) {
+		ret = mt7615_efuse_read(dev, base, i, buf + i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int mt7615_eeprom_load(struct mt7615_dev *dev)
+{
+	int ret;
+
+	ret = mt76_eeprom_init(&dev->mt76, MT7615_EEPROM_SIZE);
+	if (ret < 0)
+		return ret;
+
+	return mt7615_efuse_init(dev);
+}
+
+int mt7615_eeprom_init(struct mt7615_dev *dev)
+{
+	int ret;
+
+	ret = mt7615_eeprom_load(dev);
+	if (ret < 0)
+		return ret;
+
+	memcpy(dev->mt76.eeprom.data, dev->mt76.otp.data, MT7615_EEPROM_SIZE);
+
+	dev->mt76.cap.has_2ghz = true;
+	dev->mt76.cap.has_5ghz = true;
+
+	memcpy(dev->mt76.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR,
+	       ETH_ALEN);
+
+	mt76_eeprom_override(&dev->mt76);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
new file mode 100644
index 0000000..a4cf166
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: ISC */
+/* Copyright (C) 2019 MediaTek Inc. */
+
+#ifndef __MT7615_EEPROM_H
+#define __MT7615_EEPROM_H
+
+#include "mt7615.h"
+
+enum mt7615_eeprom_field {
+	MT_EE_CHIP_ID =				0x000,
+	MT_EE_VERSION =				0x002,
+	MT_EE_MAC_ADDR =			0x004,
+	MT_EE_NIC_CONF_0 =			0x034,
+
+	__MT_EE_MAX =				0x3bf
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/init.c b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
new file mode 100644
index 0000000..3ab3ff5
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/init.c
@@ -0,0 +1,229 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Roy Luo <royluo@google.com>
+ *         Ryder Lee <ryder.lee@mediatek.com>
+ *         Felix Fietkau <nbd@nbd.name>
+ */
+
+#include <linux/etherdevice.h>
+#include "mt7615.h"
+#include "mac.h"
+
+static void mt7615_phy_init(struct mt7615_dev *dev)
+{
+	/* disable band 0 rf low power beacon mode */
+	mt76_rmw(dev, MT_WF_PHY_WF2_RFCTRL0, MT_WF_PHY_WF2_RFCTRL0_LPBCN_EN,
+		 MT_WF_PHY_WF2_RFCTRL0_LPBCN_EN);
+}
+
+static void mt7615_mac_init(struct mt7615_dev *dev)
+{
+	/* enable band 0 clk */
+	mt76_rmw(dev, MT_CFG_CCR,
+		 MT_CFG_CCR_MAC_D0_1X_GC_EN | MT_CFG_CCR_MAC_D0_2X_GC_EN,
+		 MT_CFG_CCR_MAC_D0_1X_GC_EN | MT_CFG_CCR_MAC_D0_2X_GC_EN);
+
+	mt76_rmw_field(dev, MT_TMAC_CTCR0,
+		       MT_TMAC_CTCR0_INS_DDLMT_REFTIME, 0x3f);
+	mt76_rmw_field(dev, MT_TMAC_CTCR0,
+		       MT_TMAC_CTCR0_INS_DDLMT_DENSITY, 0x3);
+	mt76_rmw(dev, MT_TMAC_CTCR0,
+		 MT_TMAC_CTCR0_INS_DDLMT_VHT_SMPDU_EN |
+		 MT_TMAC_CTCR0_INS_DDLMT_EN,
+		 MT_TMAC_CTCR0_INS_DDLMT_VHT_SMPDU_EN |
+		 MT_TMAC_CTCR0_INS_DDLMT_EN);
+
+	mt7615_mcu_set_rts_thresh(dev, 0x92b);
+
+	mt76_rmw(dev, MT_AGG_SCR, MT_AGG_SCR_NLNAV_MID_PTEC_DIS,
+		 MT_AGG_SCR_NLNAV_MID_PTEC_DIS);
+
+	mt7615_mcu_init_mac(dev);
+
+	mt76_wr(dev, MT_DMA_DCR0, MT_DMA_DCR0_RX_VEC_DROP |
+		FIELD_PREP(MT_DMA_DCR0_MAX_RX_LEN, 3072));
+
+	mt76_wr(dev, MT_AGG_ARUCR, FIELD_PREP(MT_AGG_ARxCR_LIMIT(0), 7));
+	mt76_wr(dev, MT_AGG_ARDCR,
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(0), 0) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(1),
+			   max_t(int, 0, MT7615_RATE_RETRY - 2)) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(2), MT7615_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(3), MT7615_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(4), MT7615_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(5), MT7615_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(6), MT7615_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(7), MT7615_RATE_RETRY - 1));
+
+	mt76_wr(dev, MT_AGG_ARCR,
+		(MT_AGG_ARCR_INIT_RATE1 |
+		 FIELD_PREP(MT_AGG_ARCR_RTS_RATE_THR, 2) |
+		 MT_AGG_ARCR_RATE_DOWN_RATIO_EN |
+		 FIELD_PREP(MT_AGG_ARCR_RATE_DOWN_RATIO, 1) |
+		 FIELD_PREP(MT_AGG_ARCR_RATE_UP_EXTRA_TH, 4)));
+
+	dev->mt76.global_wcid.idx = MT7615_WTBL_RESERVED;
+	dev->mt76.global_wcid.hw_key_idx = -1;
+	rcu_assign_pointer(dev->mt76.wcid[MT7615_WTBL_RESERVED],
+			   &dev->mt76.global_wcid);
+}
+
+static int mt7615_init_hardware(struct mt7615_dev *dev)
+{
+	int ret;
+
+	mt76_wr(dev, MT_INT_SOURCE_CSR, ~0);
+
+	spin_lock_init(&dev->token_lock);
+	idr_init(&dev->token);
+
+	ret = mt7615_eeprom_init(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = mt7615_dma_init(dev);
+	if (ret)
+		return ret;
+
+	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+
+	ret = mt7615_mcu_init(dev);
+	if (ret)
+		return ret;
+
+	mt7615_mcu_set_eeprom(dev);
+	mt7615_mac_init(dev);
+	mt7615_phy_init(dev);
+	mt7615_mcu_ctrl_pm_state(dev, 0);
+	mt7615_mcu_del_wtbl_all(dev);
+
+	return 0;
+}
+
+#define CCK_RATE(_idx, _rate) {						\
+	.bitrate = _rate,						\
+	.flags = IEEE80211_RATE_SHORT_PREAMBLE,				\
+	.hw_value = (MT_PHY_TYPE_CCK << 8) | (_idx),			\
+	.hw_value_short = (MT_PHY_TYPE_CCK << 8) | (4 + (_idx)),	\
+}
+
+#define OFDM_RATE(_idx, _rate) {					\
+	.bitrate = _rate,						\
+	.hw_value = (MT_PHY_TYPE_OFDM << 8) | (_idx),			\
+	.hw_value_short = (MT_PHY_TYPE_OFDM << 8) | (_idx),		\
+}
+
+static struct ieee80211_rate mt7615_rates[] = {
+	CCK_RATE(0, 10),
+	CCK_RATE(1, 20),
+	CCK_RATE(2, 55),
+	CCK_RATE(3, 110),
+	OFDM_RATE(11, 60),
+	OFDM_RATE(15, 90),
+	OFDM_RATE(10, 120),
+	OFDM_RATE(14, 180),
+	OFDM_RATE(9,  240),
+	OFDM_RATE(13, 360),
+	OFDM_RATE(8,  480),
+	OFDM_RATE(12, 540),
+};
+
+static const struct ieee80211_iface_limit if_limits[] = {
+	{
+		.max = MT7615_MAX_INTERFACES,
+		.types = BIT(NL80211_IFTYPE_AP) |
+			 BIT(NL80211_IFTYPE_STATION)
+	}
+};
+
+static const struct ieee80211_iface_combination if_comb[] = {
+	{
+		.limits = if_limits,
+		.n_limits = ARRAY_SIZE(if_limits),
+		.max_interfaces = 4,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+	}
+};
+
+static int mt7615_init_debugfs(struct mt7615_dev *dev)
+{
+	struct dentry *dir;
+
+	dir = mt76_register_debugfs(&dev->mt76);
+	if (!dir)
+		return -ENOMEM;
+
+	return 0;
+}
+
+int mt7615_register_device(struct mt7615_dev *dev)
+{
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct wiphy *wiphy = hw->wiphy;
+	int ret;
+
+	ret = mt7615_init_hardware(dev);
+	if (ret)
+		return ret;
+
+	INIT_DELAYED_WORK(&dev->mt76.mac_work, mt7615_mac_work);
+
+	hw->queues = 4;
+	hw->max_rates = 3;
+	hw->max_report_rates = 7;
+	hw->max_rate_tries = 11;
+
+	hw->sta_data_size = sizeof(struct mt7615_sta);
+	hw->vif_data_size = sizeof(struct mt7615_vif);
+
+	wiphy->iface_combinations = if_comb;
+	wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+
+	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
+	ieee80211_hw_set(hw, TX_STATUS_NO_AMPDU_LEN);
+
+	dev->mt76.sband_2g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+	dev->mt76.sband_5g.sband.ht_cap.cap |= IEEE80211_HT_CAP_LDPC_CODING;
+	dev->mt76.sband_5g.sband.vht_cap.cap |=
+			IEEE80211_VHT_CAP_SHORT_GI_160 |
+			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
+			IEEE80211_VHT_CAP_MAX_A_MPDU_LENGTH_EXPONENT_MASK |
+			IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
+	dev->mt76.chainmask = 0x404;
+	dev->mt76.antenna_mask = 0xf;
+
+	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
+				 BIT(NL80211_IFTYPE_AP);
+
+	ret = mt76_register_device(&dev->mt76, true, mt7615_rates,
+				   ARRAY_SIZE(mt7615_rates));
+	if (ret)
+		return ret;
+
+	hw->max_tx_fragments = MT_TXP_MAX_BUF_NUM;
+
+	return mt7615_init_debugfs(dev);
+}
+
+void mt7615_unregister_device(struct mt7615_dev *dev)
+{
+	struct mt76_txwi_cache *txwi;
+	int id;
+
+	spin_lock_bh(&dev->token_lock);
+	idr_for_each_entry(&dev->token, txwi, id) {
+		mt7615_txp_skb_unmap(&dev->mt76, txwi);
+		if (txwi->skb)
+			dev_kfree_skb_any(txwi->skb);
+		mt76_put_txwi(&dev->mt76, txwi);
+	}
+	spin_unlock_bh(&dev->token_lock);
+	idr_destroy(&dev->token);
+	mt76_unregister_device(&dev->mt76);
+	mt7615_mcu_exit(dev);
+	mt7615_dma_cleanup(dev);
+
+	ieee80211_free_hw(mt76_hw(dev));
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
new file mode 100644
index 0000000..1bf3e7b
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -0,0 +1,775 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Ryder Lee <ryder.lee@mediatek.com>
+ *         Roy Luo <royluo@google.com>
+ *         Felix Fietkau <nbd@nbd.name>
+ *         Lorenzo Bianconi <lorenzo@kernel.org>
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/timekeeping.h>
+#include "mt7615.h"
+#include "../dma.h"
+#include "mac.h"
+
+static struct mt76_wcid *mt7615_rx_get_wcid(struct mt7615_dev *dev,
+					    u8 idx, bool unicast)
+{
+	struct mt7615_sta *sta;
+	struct mt76_wcid *wcid;
+
+	if (idx >= ARRAY_SIZE(dev->mt76.wcid))
+		return NULL;
+
+	wcid = rcu_dereference(dev->mt76.wcid[idx]);
+	if (unicast || !wcid)
+		return wcid;
+
+	if (!wcid->sta)
+		return NULL;
+
+	sta = container_of(wcid, struct mt7615_sta, wcid);
+	if (!sta->vif)
+		return NULL;
+
+	return &sta->vif->sta.wcid;
+}
+
+static int mt7615_get_rate(struct mt7615_dev *dev,
+			   struct ieee80211_supported_band *sband,
+			   int idx, bool cck)
+{
+	int offset = 0;
+	int len = sband->n_bitrates;
+	int i;
+
+	if (cck) {
+		if (sband == &dev->mt76.sband_5g.sband)
+			return 0;
+
+		idx &= ~BIT(2); /* short preamble */
+	} else if (sband == &dev->mt76.sband_2g.sband) {
+		offset = 4;
+	}
+
+	for (i = offset; i < len; i++) {
+		if ((sband->bitrates[i].hw_value & GENMASK(7, 0)) == idx)
+			return i;
+	}
+
+	return 0;
+}
+
+static void mt7615_insert_ccmp_hdr(struct sk_buff *skb, u8 key_id)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	u8 *pn = status->iv;
+	u8 *hdr;
+
+	__skb_push(skb, 8);
+	memmove(skb->data, skb->data + 8, hdr_len);
+	hdr = skb->data + hdr_len;
+
+	hdr[0] = pn[5];
+	hdr[1] = pn[4];
+	hdr[2] = 0;
+	hdr[3] = 0x20 | (key_id << 6);
+	hdr[4] = pn[3];
+	hdr[5] = pn[2];
+	hdr[6] = pn[1];
+	hdr[7] = pn[0];
+
+	status->flag &= ~RX_FLAG_IV_STRIPPED;
+}
+
+int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_hdr *hdr;
+	__le32 *rxd = (__le32 *)skb->data;
+	u32 rxd0 = le32_to_cpu(rxd[0]);
+	u32 rxd1 = le32_to_cpu(rxd[1]);
+	u32 rxd2 = le32_to_cpu(rxd[2]);
+	bool unicast, remove_pad, insert_ccmp_hdr = false;
+	int i, idx;
+
+	memset(status, 0, sizeof(*status));
+
+	unicast = (rxd1 & MT_RXD1_NORMAL_ADDR_TYPE) == MT_RXD1_NORMAL_U2M;
+	idx = FIELD_GET(MT_RXD2_NORMAL_WLAN_IDX, rxd2);
+	status->wcid = mt7615_rx_get_wcid(dev, idx, unicast);
+
+	/* TODO: properly support DBDC */
+	status->freq = dev->mt76.chandef.chan->center_freq;
+	status->band = dev->mt76.chandef.chan->band;
+	if (status->band == NL80211_BAND_5GHZ)
+		sband = &dev->mt76.sband_5g.sband;
+	else
+		sband = &dev->mt76.sband_2g.sband;
+
+	if (rxd2 & MT_RXD2_NORMAL_FCS_ERR)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
+	if (rxd2 & MT_RXD2_NORMAL_TKIP_MIC_ERR)
+		status->flag |= RX_FLAG_MMIC_ERROR;
+
+	if (FIELD_GET(MT_RXD2_NORMAL_SEC_MODE, rxd2) != 0 &&
+	    !(rxd2 & (MT_RXD2_NORMAL_CLM | MT_RXD2_NORMAL_CM))) {
+		status->flag |= RX_FLAG_DECRYPTED;
+		status->flag |= RX_FLAG_IV_STRIPPED;
+		status->flag |= RX_FLAG_MMIC_STRIPPED | RX_FLAG_MIC_STRIPPED;
+	}
+
+	remove_pad = rxd1 & MT_RXD1_NORMAL_HDR_OFFSET;
+
+	if (rxd2 & MT_RXD2_NORMAL_MAX_LEN_ERROR)
+		return -EINVAL;
+
+	if (!sband->channels)
+		return -EINVAL;
+
+	rxd += 4;
+	if (rxd0 & MT_RXD0_NORMAL_GROUP_4) {
+		rxd += 4;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	}
+
+	if (rxd0 & MT_RXD0_NORMAL_GROUP_1) {
+		u8 *data = (u8 *)rxd;
+
+		if (status->flag & RX_FLAG_DECRYPTED) {
+			status->iv[0] = data[5];
+			status->iv[1] = data[4];
+			status->iv[2] = data[3];
+			status->iv[3] = data[2];
+			status->iv[4] = data[1];
+			status->iv[5] = data[0];
+
+			insert_ccmp_hdr = FIELD_GET(MT_RXD2_NORMAL_FRAG, rxd2);
+		}
+		rxd += 4;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	}
+
+	if (rxd0 & MT_RXD0_NORMAL_GROUP_2) {
+		rxd += 2;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	}
+
+	if (rxd0 & MT_RXD0_NORMAL_GROUP_3) {
+		u32 rxdg0 = le32_to_cpu(rxd[0]);
+		u32 rxdg1 = le32_to_cpu(rxd[1]);
+		u8 stbc = FIELD_GET(MT_RXV1_HT_STBC, rxdg0);
+		bool cck = false;
+
+		i = FIELD_GET(MT_RXV1_TX_RATE, rxdg0);
+		switch (FIELD_GET(MT_RXV1_TX_MODE, rxdg0)) {
+		case MT_PHY_TYPE_CCK:
+			cck = true;
+			/* fall through */
+		case MT_PHY_TYPE_OFDM:
+			i = mt7615_get_rate(dev, sband, i, cck);
+			break;
+		case MT_PHY_TYPE_HT_GF:
+		case MT_PHY_TYPE_HT:
+			status->encoding = RX_ENC_HT;
+			if (i > 31)
+				return -EINVAL;
+			break;
+		case MT_PHY_TYPE_VHT:
+			status->nss = FIELD_GET(MT_RXV2_NSTS, rxdg1) + 1;
+			status->encoding = RX_ENC_VHT;
+			break;
+		default:
+			return -EINVAL;
+		}
+		status->rate_idx = i;
+
+		switch (FIELD_GET(MT_RXV1_FRAME_MODE, rxdg0)) {
+		case MT_PHY_BW_20:
+			break;
+		case MT_PHY_BW_40:
+			status->bw = RATE_INFO_BW_40;
+			break;
+		case MT_PHY_BW_80:
+			status->bw = RATE_INFO_BW_80;
+			break;
+		case MT_PHY_BW_160:
+			status->bw = RATE_INFO_BW_160;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (rxdg0 & MT_RXV1_HT_SHORT_GI)
+			status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
+		if (rxdg0 & MT_RXV1_HT_AD_CODE)
+			status->enc_flags |= RX_ENC_FLAG_LDPC;
+
+		status->enc_flags |= RX_ENC_FLAG_STBC_MASK * stbc;
+
+		/* TODO: RSSI */
+		rxd += 6;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	}
+
+	skb_pull(skb, (u8 *)rxd - skb->data + 2 * remove_pad);
+
+	if (insert_ccmp_hdr) {
+		u8 key_id = FIELD_GET(MT_RXD1_NORMAL_KEY_ID, rxd1);
+
+		mt7615_insert_ccmp_hdr(skb, key_id);
+	}
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (!status->wcid || !ieee80211_is_data_qos(hdr->frame_control))
+		return 0;
+
+	status->aggr = unicast &&
+		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
+	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	status->seqno = IEEE80211_SEQ_TO_SN(hdr->seq_ctrl);
+
+	return 0;
+}
+
+void mt7615_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
+{
+}
+
+void mt7615_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			    struct mt76_queue_entry *e)
+{
+	if (!e->txwi) {
+		dev_kfree_skb_any(e->skb);
+		return;
+	}
+
+	/* error path */
+	if (e->skb == DMA_DUMMY_DATA) {
+		struct mt76_txwi_cache *t;
+		struct mt7615_dev *dev;
+		struct mt7615_txp *txp;
+		u8 *txwi_ptr;
+
+		txwi_ptr = mt76_get_txwi_ptr(mdev, e->txwi);
+		txp = (struct mt7615_txp *)(txwi_ptr + MT_TXD_SIZE);
+		dev = container_of(mdev, struct mt7615_dev, mt76);
+
+		spin_lock_bh(&dev->token_lock);
+		t = idr_remove(&dev->token, le16_to_cpu(txp->token));
+		spin_unlock_bh(&dev->token_lock);
+		e->skb = t ? t->skb : NULL;
+	}
+
+	if (e->skb)
+		mt76_tx_complete_skb(mdev, e->skb);
+}
+
+u16 mt7615_mac_tx_rate_val(struct mt7615_dev *dev,
+			   const struct ieee80211_tx_rate *rate,
+			   bool stbc, u8 *bw)
+{
+	u8 phy, nss, rate_idx;
+	u16 rateval;
+
+	*bw = 0;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		rate_idx = ieee80211_rate_get_vht_mcs(rate);
+		nss = ieee80211_rate_get_vht_nss(rate);
+		phy = MT_PHY_TYPE_VHT;
+		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			*bw = 1;
+		else if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+			*bw = 2;
+		else if (rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+			*bw = 3;
+	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
+		rate_idx = rate->idx;
+		nss = 1 + (rate->idx >> 3);
+		phy = MT_PHY_TYPE_HT;
+		if (rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+			phy = MT_PHY_TYPE_HT_GF;
+		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			*bw = 1;
+	} else {
+		const struct ieee80211_rate *r;
+		int band = dev->mt76.chandef.chan->band;
+		u16 val;
+
+		nss = 1;
+		r = &mt76_hw(dev)->wiphy->bands[band]->bitrates[rate->idx];
+		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+			val = r->hw_value_short;
+		else
+			val = r->hw_value;
+
+		phy = val >> 8;
+		rate_idx = val & 0xff;
+	}
+
+	rateval = (FIELD_PREP(MT_TX_RATE_IDX, rate_idx) |
+		   FIELD_PREP(MT_TX_RATE_MODE, phy) |
+		   FIELD_PREP(MT_TX_RATE_NSS, nss - 1));
+
+	if (stbc && nss == 1)
+		rateval |= MT_TX_RATE_STBC;
+
+	return rateval;
+}
+
+int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
+			  struct sk_buff *skb, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta, int pid,
+			  struct ieee80211_key_conf *key)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_vif *vif = info->control.vif;
+	int tx_count = 8;
+	u8 fc_type, fc_stype, p_fmt, q_idx, omac_idx = 0;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	u16 seqno = 0;
+	u32 val;
+
+	if (vif) {
+		struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+
+		omac_idx = mvif->omac_idx;
+	}
+
+	if (sta) {
+		struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+
+		tx_count = msta->rate_count;
+	}
+
+	fc_type = (fc & IEEE80211_FCTL_FTYPE) >> 2;
+	fc_stype = (fc & IEEE80211_FCTL_STYPE) >> 4;
+
+	if (ieee80211_is_data(fc)) {
+		q_idx = skb_get_queue_mapping(skb);
+		p_fmt = MT_TX_TYPE_CT;
+	} else if (ieee80211_is_beacon(fc)) {
+		q_idx = MT_LMAC_BCN0;
+		p_fmt = MT_TX_TYPE_FW;
+	} else {
+		q_idx = MT_LMAC_ALTX0;
+		p_fmt = MT_TX_TYPE_CT;
+	}
+
+	val = FIELD_PREP(MT_TXD0_TX_BYTES, skb->len + MT_TXD_SIZE) |
+	      FIELD_PREP(MT_TXD0_P_IDX, MT_TX_PORT_IDX_LMAC) |
+	      FIELD_PREP(MT_TXD0_Q_IDX, q_idx);
+	txwi[0] = cpu_to_le32(val);
+
+	val = MT_TXD1_LONG_FORMAT |
+	      FIELD_PREP(MT_TXD1_WLAN_IDX, wcid->idx) |
+	      FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_11) |
+	      FIELD_PREP(MT_TXD1_HDR_INFO,
+			 ieee80211_get_hdrlen_from_skb(skb) / 2) |
+	      FIELD_PREP(MT_TXD1_TID,
+			 skb->priority & IEEE80211_QOS_CTL_TID_MASK) |
+	      FIELD_PREP(MT_TXD1_PKT_FMT, p_fmt) |
+	      FIELD_PREP(MT_TXD1_OWN_MAC, omac_idx);
+	txwi[1] = cpu_to_le32(val);
+
+	val = FIELD_PREP(MT_TXD2_FRAME_TYPE, fc_type) |
+	      FIELD_PREP(MT_TXD2_SUB_TYPE, fc_stype) |
+	      FIELD_PREP(MT_TXD2_MULTICAST,
+			 is_multicast_ether_addr(hdr->addr1));
+	txwi[2] = cpu_to_le32(val);
+
+	if (!(info->flags & IEEE80211_TX_CTL_AMPDU))
+		txwi[2] |= cpu_to_le32(MT_TXD2_BA_DISABLE);
+
+	txwi[4] = 0;
+	txwi[6] = 0;
+
+	if (rate->idx >= 0 && rate->count &&
+	    !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
+		bool stbc = info->flags & IEEE80211_TX_CTL_STBC;
+		u8 bw;
+		u16 rateval = mt7615_mac_tx_rate_val(dev, rate, stbc, &bw);
+
+		txwi[2] |= cpu_to_le32(MT_TXD2_FIX_RATE);
+
+		val = MT_TXD6_FIXED_BW |
+		      FIELD_PREP(MT_TXD6_BW, bw) |
+		      FIELD_PREP(MT_TXD6_TX_RATE, rateval);
+		txwi[6] |= cpu_to_le32(val);
+
+		if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+			txwi[6] |= cpu_to_le32(MT_TXD6_SGI);
+
+		if (info->flags & IEEE80211_TX_CTL_LDPC)
+			txwi[6] |= cpu_to_le32(MT_TXD6_LDPC);
+
+		if (!(rate->flags & (IEEE80211_TX_RC_MCS |
+				     IEEE80211_TX_RC_VHT_MCS)))
+			txwi[2] |= cpu_to_le32(MT_TXD2_BA_DISABLE);
+
+		tx_count = rate->count;
+	}
+
+	if (!ieee80211_is_beacon(fc)) {
+		val = MT_TXD5_TX_STATUS_HOST | MT_TXD5_SW_POWER_MGMT |
+		      FIELD_PREP(MT_TXD5_PID, pid);
+		txwi[5] = cpu_to_le32(val);
+	} else {
+		txwi[5] = 0;
+		/* use maximum tx count for beacons */
+		tx_count = 0x1f;
+	}
+
+	val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, tx_count);
+	if (ieee80211_is_data_qos(hdr->frame_control)) {
+		seqno = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
+		val |= MT_TXD3_SN_VALID;
+	} else if (ieee80211_is_back_req(hdr->frame_control)) {
+		struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
+
+		seqno = IEEE80211_SEQ_TO_SN(le16_to_cpu(bar->start_seq_num));
+		val |= MT_TXD3_SN_VALID;
+	}
+	val |= FIELD_PREP(MT_TXD3_SEQ, seqno);
+
+	txwi[3] = cpu_to_le32(val);
+
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		txwi[3] |= cpu_to_le32(MT_TXD3_NO_ACK);
+
+	if (key)
+		txwi[3] |= cpu_to_le32(MT_TXD3_PROTECT_FRAME);
+
+	txwi[7] = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
+		  FIELD_PREP(MT_TXD7_SUB_TYPE, fc_stype);
+
+	return 0;
+}
+
+void mt7615_txp_skb_unmap(struct mt76_dev *dev,
+			  struct mt76_txwi_cache *t)
+{
+	struct mt7615_txp *txp;
+	u8 *txwi;
+	int i;
+
+	txwi = mt76_get_txwi_ptr(dev, t);
+	txp = (struct mt7615_txp *)(txwi + MT_TXD_SIZE);
+	for (i = 1; i < txp->nbuf; i++)
+		dma_unmap_single(dev->dev, le32_to_cpu(txp->buf[i]),
+				 le32_to_cpu(txp->len[i]), DMA_TO_DEVICE);
+}
+
+int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
+			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta,
+			  struct mt76_tx_info *tx_info)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)tx_info->skb->data;
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+	struct mt7615_sta *msta = container_of(wcid, struct mt7615_sta, wcid);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(tx_info->skb);
+	struct ieee80211_key_conf *key = info->control.hw_key;
+	struct ieee80211_vif *vif = info->control.vif;
+	int i, pid, id, nbuf = tx_info->nbuf - 1;
+	u8 *txwi = (u8 *)txwi_ptr;
+	struct mt76_txwi_cache *t;
+	struct mt7615_txp *txp;
+
+	if (!wcid)
+		wcid = &dev->mt76.global_wcid;
+
+	pid = mt76_tx_status_skb_add(mdev, wcid, tx_info->skb);
+
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+		spin_lock_bh(&dev->mt76.lock);
+		msta->rate_probe = true;
+		mt7615_mcu_set_rates(dev, msta, &info->control.rates[0],
+				     msta->rates);
+		spin_unlock_bh(&dev->mt76.lock);
+	}
+
+	mt7615_mac_write_txwi(dev, txwi_ptr, tx_info->skb, wcid, sta,
+			      pid, key);
+
+	txp = (struct mt7615_txp *)(txwi + MT_TXD_SIZE);
+	for (i = 0; i < nbuf; i++) {
+		txp->buf[i] = cpu_to_le32(tx_info->buf[i + 1].addr);
+		txp->len[i] = cpu_to_le32(tx_info->buf[i + 1].len);
+	}
+	txp->nbuf = nbuf;
+
+	/* pass partial skb header to fw */
+	tx_info->buf[1].len = MT_CT_PARSE_LEN;
+	tx_info->nbuf = MT_CT_DMA_BUF_NUM;
+
+	txp->flags = cpu_to_le16(MT_CT_INFO_APPLY_TXD);
+
+	if (!key)
+		txp->flags |= cpu_to_le16(MT_CT_INFO_NONE_CIPHER_FRAME);
+
+	if (ieee80211_is_mgmt(hdr->frame_control))
+		txp->flags |= cpu_to_le16(MT_CT_INFO_MGMT_FRAME);
+
+	if (vif) {
+		struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+
+		txp->bss_idx = mvif->idx;
+	}
+
+	t = (struct mt76_txwi_cache *)(txwi + mdev->drv->txwi_size);
+	t->skb = tx_info->skb;
+
+	spin_lock_bh(&dev->token_lock);
+	id = idr_alloc(&dev->token, t, 0, MT7615_TOKEN_SIZE, GFP_ATOMIC);
+	spin_unlock_bh(&dev->token_lock);
+	if (id < 0)
+		return id;
+
+	txp->token = cpu_to_le16(id);
+	txp->rept_wds_wcid = 0xff;
+	tx_info->skb = DMA_DUMMY_DATA;
+
+	return 0;
+}
+
+static bool mt7615_fill_txs(struct mt7615_dev *dev, struct mt7615_sta *sta,
+			    struct ieee80211_tx_info *info, __le32 *txs_data)
+{
+	struct ieee80211_supported_band *sband;
+	int i, idx, count, final_idx = 0;
+	bool fixed_rate, final_mpdu, ack_timeout;
+	bool probe, ampdu, cck = false;
+	u32 final_rate, final_rate_flags, final_nss, txs;
+	u8 pid;
+
+	fixed_rate = info->status.rates[0].count;
+	probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+
+	txs = le32_to_cpu(txs_data[1]);
+	final_mpdu = txs & MT_TXS1_ACKED_MPDU;
+	ampdu = !fixed_rate && (txs & MT_TXS1_AMPDU);
+
+	txs = le32_to_cpu(txs_data[3]);
+	count = FIELD_GET(MT_TXS3_TX_COUNT, txs);
+
+	txs = le32_to_cpu(txs_data[0]);
+	pid = FIELD_GET(MT_TXS0_PID, txs);
+	final_rate = FIELD_GET(MT_TXS0_TX_RATE, txs);
+	ack_timeout = txs & MT_TXS0_ACK_TIMEOUT;
+
+	if (!ampdu && (txs & MT_TXS0_RTS_TIMEOUT))
+		return false;
+
+	if (txs & MT_TXS0_QUEUE_TIMEOUT)
+		return false;
+
+	if (!ack_timeout)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
+	info->status.ampdu_len = 1;
+	info->status.ampdu_ack_len = !!(info->flags &
+					IEEE80211_TX_STAT_ACK);
+
+	if (ampdu || (info->flags & IEEE80211_TX_CTL_AMPDU))
+		info->flags |= IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_CTL_AMPDU;
+
+	if (fixed_rate && !probe) {
+		info->status.rates[0].count = count;
+		goto out;
+	}
+
+	for (i = 0, idx = 0; i < ARRAY_SIZE(info->status.rates); i++) {
+		int cur_count = min_t(int, count, 2 * MT7615_RATE_RETRY);
+
+		if (!i && probe) {
+			cur_count = 1;
+		} else {
+			info->status.rates[i] = sta->rates[idx];
+			idx++;
+		}
+
+		if (i && info->status.rates[i].idx < 0) {
+			info->status.rates[i - 1].count += count;
+			break;
+		}
+
+		if (!count) {
+			info->status.rates[i].idx = -1;
+			break;
+		}
+
+		info->status.rates[i].count = cur_count;
+		final_idx = i;
+		count -= cur_count;
+	}
+
+out:
+	final_rate_flags = info->status.rates[final_idx].flags;
+
+	switch (FIELD_GET(MT_TX_RATE_MODE, final_rate)) {
+	case MT_PHY_TYPE_CCK:
+		cck = true;
+		/* fall through */
+	case MT_PHY_TYPE_OFDM:
+		if (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ)
+			sband = &dev->mt76.sband_5g.sband;
+		else
+			sband = &dev->mt76.sband_2g.sband;
+		final_rate &= MT_TX_RATE_IDX;
+		final_rate = mt7615_get_rate(dev, sband, final_rate, cck);
+		final_rate_flags = 0;
+		break;
+	case MT_PHY_TYPE_HT_GF:
+	case MT_PHY_TYPE_HT:
+		final_rate_flags |= IEEE80211_TX_RC_MCS;
+		final_rate &= MT_TX_RATE_IDX;
+		if (final_rate > 31)
+			return false;
+		break;
+	case MT_PHY_TYPE_VHT:
+		final_nss = FIELD_GET(MT_TX_RATE_NSS, final_rate);
+		final_rate_flags |= IEEE80211_TX_RC_VHT_MCS;
+		final_rate = (final_rate & MT_TX_RATE_IDX) | (final_nss << 4);
+		break;
+	default:
+		return false;
+	}
+
+	info->status.rates[final_idx].idx = final_rate;
+	info->status.rates[final_idx].flags = final_rate_flags;
+
+	return true;
+}
+
+static bool mt7615_mac_add_txs_skb(struct mt7615_dev *dev,
+				   struct mt7615_sta *sta, int pid,
+				   __le32 *txs_data)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct sk_buff_head list;
+	struct sk_buff *skb;
+
+	if (pid < MT_PACKET_ID_FIRST)
+		return false;
+
+	mt76_tx_status_lock(mdev, &list);
+	skb = mt76_tx_status_skb_get(mdev, &sta->wcid, pid, &list);
+	if (skb) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+			spin_lock_bh(&dev->mt76.lock);
+			if (sta->rate_probe) {
+				mt7615_mcu_set_rates(dev, sta, NULL,
+						     sta->rates);
+				sta->rate_probe = false;
+			}
+			spin_unlock_bh(&dev->mt76.lock);
+		}
+
+		if (!mt7615_fill_txs(dev, sta, info, txs_data)) {
+			ieee80211_tx_info_clear_status(info);
+			info->status.rates[0].idx = -1;
+		}
+
+		mt76_tx_status_skb_done(mdev, skb, &list);
+	}
+	mt76_tx_status_unlock(mdev, &list);
+
+	return !!skb;
+}
+
+void mt7615_mac_add_txs(struct mt7615_dev *dev, void *data)
+{
+	struct ieee80211_tx_info info = {};
+	struct ieee80211_sta *sta = NULL;
+	struct mt7615_sta *msta = NULL;
+	struct mt76_wcid *wcid;
+	__le32 *txs_data = data;
+	u32 txs;
+	u8 wcidx;
+	u8 pid;
+
+	txs = le32_to_cpu(txs_data[0]);
+	pid = FIELD_GET(MT_TXS0_PID, txs);
+	txs = le32_to_cpu(txs_data[2]);
+	wcidx = FIELD_GET(MT_TXS2_WCID, txs);
+
+	if (pid == MT_PACKET_ID_NO_ACK)
+		return;
+
+	if (wcidx >= ARRAY_SIZE(dev->mt76.wcid))
+		return;
+
+	rcu_read_lock();
+
+	wcid = rcu_dereference(dev->mt76.wcid[wcidx]);
+	if (!wcid)
+		goto out;
+
+	msta = container_of(wcid, struct mt7615_sta, wcid);
+	sta = wcid_to_sta(wcid);
+
+	if (mt7615_mac_add_txs_skb(dev, msta, pid, txs_data))
+		goto out;
+
+	if (wcidx >= MT7615_WTBL_STA || !sta)
+		goto out;
+
+	if (mt7615_fill_txs(dev, msta, &info, txs_data))
+		ieee80211_tx_status_noskb(mt76_hw(dev), sta, &info);
+
+out:
+	rcu_read_unlock();
+}
+
+void mt7615_mac_tx_free(struct mt7615_dev *dev, struct sk_buff *skb)
+{
+	struct mt7615_tx_free *free = (struct mt7615_tx_free *)skb->data;
+	struct mt76_dev *mdev = &dev->mt76;
+	struct mt76_txwi_cache *txwi;
+	u8 i, count;
+
+	count = FIELD_GET(MT_TX_FREE_MSDU_ID_CNT, le16_to_cpu(free->ctrl));
+	for (i = 0; i < count; i++) {
+		spin_lock_bh(&dev->token_lock);
+		txwi = idr_remove(&dev->token, le16_to_cpu(free->token[i]));
+		spin_unlock_bh(&dev->token_lock);
+
+		if (!txwi)
+			continue;
+
+		mt7615_txp_skb_unmap(mdev, txwi);
+		if (txwi->skb) {
+			mt76_tx_complete_skb(mdev, txwi->skb);
+			txwi->skb = NULL;
+		}
+
+		mt76_put_txwi(mdev, txwi);
+	}
+	dev_kfree_skb(skb);
+}
+
+void mt7615_mac_work(struct work_struct *work)
+{
+	struct mt7615_dev *dev;
+
+	dev = (struct mt7615_dev *)container_of(work, struct mt76_dev,
+						mac_work.work);
+
+	mt76_tx_status_check(&dev->mt76, NULL, false);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
+				     MT7615_WATCHDOG_TIME);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.h b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
new file mode 100644
index 0000000..18ad4b8
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.h
@@ -0,0 +1,300 @@
+/* SPDX-License-Identifier: ISC */
+/* Copyright (C) 2019 MediaTek Inc. */
+
+#ifndef __MT7615_MAC_H
+#define __MT7615_MAC_H
+
+#define MT_CT_PARSE_LEN			72
+#define MT_CT_DMA_BUF_NUM		2
+
+#define MT_RXD0_LENGTH			GENMASK(15, 0)
+#define MT_RXD0_PKT_TYPE		GENMASK(31, 29)
+
+#define MT_RXD0_NORMAL_ETH_TYPE_OFS	GENMASK(22, 16)
+#define MT_RXD0_NORMAL_IP_SUM		BIT(23)
+#define MT_RXD0_NORMAL_UDP_TCP_SUM	BIT(24)
+#define MT_RXD0_NORMAL_GROUP_1		BIT(25)
+#define MT_RXD0_NORMAL_GROUP_2		BIT(26)
+#define MT_RXD0_NORMAL_GROUP_3		BIT(27)
+#define MT_RXD0_NORMAL_GROUP_4		BIT(28)
+
+enum rx_pkt_type {
+	PKT_TYPE_TXS,
+	PKT_TYPE_TXRXV,
+	PKT_TYPE_NORMAL,
+	PKT_TYPE_RX_DUP_RFB,
+	PKT_TYPE_RX_TMR,
+	PKT_TYPE_RETRIEVE,
+	PKT_TYPE_TXRX_NOTIFY,
+	PKT_TYPE_RX_EVENT
+};
+
+#define MT_RXD1_NORMAL_BSSID		GENMASK(31, 26)
+#define MT_RXD1_NORMAL_PAYLOAD_FORMAT	GENMASK(25, 24)
+#define MT_RXD1_NORMAL_HDR_TRANS	BIT(23)
+#define MT_RXD1_NORMAL_HDR_OFFSET	BIT(22)
+#define MT_RXD1_NORMAL_MAC_HDR_LEN	GENMASK(21, 16)
+#define MT_RXD1_NORMAL_CH_FREQ		GENMASK(15, 8)
+#define MT_RXD1_NORMAL_KEY_ID		GENMASK(7, 6)
+#define MT_RXD1_NORMAL_BEACON_UC	BIT(5)
+#define MT_RXD1_NORMAL_BEACON_MC	BIT(4)
+#define MT_RXD1_NORMAL_BF_REPORT	BIT(3)
+#define MT_RXD1_NORMAL_ADDR_TYPE	GENMASK(2, 1)
+#define MT_RXD1_NORMAL_BCAST		GENMASK(2, 1)
+#define MT_RXD1_NORMAL_MCAST		BIT(2)
+#define MT_RXD1_NORMAL_U2M		BIT(1)
+#define MT_RXD1_NORMAL_HTC_VLD		BIT(0)
+
+#define MT_RXD2_NORMAL_NON_AMPDU	BIT(31)
+#define MT_RXD2_NORMAL_NON_AMPDU_SUB	BIT(30)
+#define MT_RXD2_NORMAL_NDATA		BIT(29)
+#define MT_RXD2_NORMAL_NULL_FRAME	BIT(28)
+#define MT_RXD2_NORMAL_FRAG		BIT(27)
+#define MT_RXD2_NORMAL_INT_FRAME	BIT(26)
+#define MT_RXD2_NORMAL_HDR_TRANS_ERROR	BIT(25)
+#define MT_RXD2_NORMAL_MAX_LEN_ERROR	BIT(24)
+#define MT_RXD2_NORMAL_AMSDU_ERR	BIT(23)
+#define MT_RXD2_NORMAL_LEN_MISMATCH	BIT(22)
+#define MT_RXD2_NORMAL_TKIP_MIC_ERR	BIT(21)
+#define MT_RXD2_NORMAL_ICV_ERR		BIT(20)
+#define MT_RXD2_NORMAL_CLM		BIT(19)
+#define MT_RXD2_NORMAL_CM		BIT(18)
+#define MT_RXD2_NORMAL_FCS_ERR		BIT(17)
+#define MT_RXD2_NORMAL_SW_BIT		BIT(16)
+#define MT_RXD2_NORMAL_SEC_MODE		GENMASK(15, 12)
+#define MT_RXD2_NORMAL_TID		GENMASK(11, 8)
+#define MT_RXD2_NORMAL_WLAN_IDX		GENMASK(7, 0)
+
+#define MT_RXD3_NORMAL_PF_STS		GENMASK(31, 30)
+#define MT_RXD3_NORMAL_PF_MODE		BIT(29)
+#define MT_RXD3_NORMAL_CLS_BITMAP	GENMASK(28, 19)
+#define MT_RXD3_NORMAL_WOL		GENMASK(18, 14)
+#define MT_RXD3_NORMAL_MAGIC_PKT	BIT(13)
+#define MT_RXD3_NORMAL_OFLD		GENMASK(12, 11)
+#define MT_RXD3_NORMAL_CLS		BIT(10)
+#define MT_RXD3_NORMAL_PATTERN_DROP	BIT(9)
+#define MT_RXD3_NORMAL_TSF_COMPARE_LOSS	BIT(8)
+#define MT_RXD3_NORMAL_RXV_SEQ		GENMASK(7, 0)
+
+#define MT_RXV1_ACID_DET_H		BIT(31)
+#define MT_RXV1_ACID_DET_L		BIT(30)
+#define MT_RXV1_VHTA2_B8_B3		GENMASK(29, 24)
+#define MT_RXV1_NUM_RX			GENMASK(23, 22)
+#define MT_RXV1_HT_NO_SOUND		BIT(21)
+#define MT_RXV1_HT_SMOOTH		BIT(20)
+#define MT_RXV1_HT_SHORT_GI		BIT(19)
+#define MT_RXV1_HT_AGGR			BIT(18)
+#define MT_RXV1_VHTA1_B22		BIT(17)
+#define MT_RXV1_FRAME_MODE		GENMASK(16, 15)
+#define MT_RXV1_TX_MODE			GENMASK(14, 12)
+#define MT_RXV1_HT_EXT_LTF		GENMASK(11, 10)
+#define MT_RXV1_HT_AD_CODE		BIT(9)
+#define MT_RXV1_HT_STBC			GENMASK(8, 7)
+#define MT_RXV1_TX_RATE			GENMASK(6, 0)
+
+#define MT_RXV2_SEL_ANT			BIT(31)
+#define MT_RXV2_VALID_BIT		BIT(30)
+#define MT_RXV2_NSTS			GENMASK(29, 27)
+#define MT_RXV2_GROUP_ID		GENMASK(26, 21)
+#define MT_RXV2_LENGTH			GENMASK(20, 0)
+
+enum tx_header_format {
+	MT_HDR_FORMAT_802_3,
+	MT_HDR_FORMAT_CMD,
+	MT_HDR_FORMAT_802_11,
+	MT_HDR_FORMAT_802_11_EXT,
+};
+
+enum tx_pkt_type {
+	MT_TX_TYPE_CT,
+	MT_TX_TYPE_SF,
+	MT_TX_TYPE_CMD,
+	MT_TX_TYPE_FW,
+};
+
+enum tx_pkt_queue_idx {
+	MT_LMAC_AC00,
+	MT_LMAC_AC01,
+	MT_LMAC_AC02,
+	MT_LMAC_AC03,
+	MT_LMAC_ALTX0 = 0x10,
+	MT_LMAC_BMC0,
+	MT_LMAC_BCN0,
+	MT_LMAC_PSMP0,
+};
+
+enum tx_port_idx {
+	MT_TX_PORT_IDX_LMAC,
+	MT_TX_PORT_IDX_MCU
+};
+
+enum tx_mcu_port_q_idx {
+	MT_TX_MCU_PORT_RX_Q0 = 0,
+	MT_TX_MCU_PORT_RX_Q1,
+	MT_TX_MCU_PORT_RX_Q2,
+	MT_TX_MCU_PORT_RX_Q3,
+	MT_TX_MCU_PORT_RX_FWDL = 0x1e
+};
+
+enum tx_phy_bandwidth {
+	MT_PHY_BW_20,
+	MT_PHY_BW_40,
+	MT_PHY_BW_80,
+	MT_PHY_BW_160,
+};
+
+#define MT_CT_INFO_APPLY_TXD		BIT(0)
+#define MT_CT_INFO_COPY_HOST_TXD_ALL	BIT(1)
+#define MT_CT_INFO_MGMT_FRAME		BIT(2)
+#define MT_CT_INFO_NONE_CIPHER_FRAME	BIT(3)
+#define MT_CT_INFO_HSR2_TX		BIT(4)
+
+#define MT_TXD_SIZE			(8 * 4)
+
+#define MT_TXD0_P_IDX			BIT(31)
+#define MT_TXD0_Q_IDX			GENMASK(30, 26)
+#define MT_TXD0_UDP_TCP_SUM		BIT(24)
+#define MT_TXD0_IP_SUM			BIT(23)
+#define MT_TXD0_ETH_TYPE_OFFSET		GENMASK(22, 16)
+#define MT_TXD0_TX_BYTES		GENMASK(15, 0)
+
+#define MT_TXD1_OWN_MAC			GENMASK(31, 26)
+#define MT_TXD1_PKT_FMT			GENMASK(25, 24)
+#define MT_TXD1_TID			GENMASK(23, 21)
+#define MT_TXD1_AMSDU			BIT(20)
+#define MT_TXD1_UNXV			BIT(19)
+#define MT_TXD1_HDR_PAD			GENMASK(18, 17)
+#define MT_TXD1_TXD_LEN			BIT(16)
+#define MT_TXD1_LONG_FORMAT		BIT(15)
+#define MT_TXD1_HDR_FORMAT		GENMASK(14, 13)
+#define MT_TXD1_HDR_INFO		GENMASK(12, 8)
+#define MT_TXD1_WLAN_IDX		GENMASK(7, 0)
+
+#define MT_TXD2_FIX_RATE		BIT(31)
+#define MT_TXD2_TIMING_MEASURE		BIT(30)
+#define MT_TXD2_BA_DISABLE		BIT(29)
+#define MT_TXD2_POWER_OFFSET		GENMASK(28, 24)
+#define MT_TXD2_MAX_TX_TIME		GENMASK(23, 16)
+#define MT_TXD2_FRAG			GENMASK(15, 14)
+#define MT_TXD2_HTC_VLD			BIT(13)
+#define MT_TXD2_DURATION		BIT(12)
+#define MT_TXD2_BIP			BIT(11)
+#define MT_TXD2_MULTICAST		BIT(10)
+#define MT_TXD2_RTS			BIT(9)
+#define MT_TXD2_SOUNDING		BIT(8)
+#define MT_TXD2_NDPA			BIT(7)
+#define MT_TXD2_NDP			BIT(6)
+#define MT_TXD2_FRAME_TYPE		GENMASK(5, 4)
+#define MT_TXD2_SUB_TYPE		GENMASK(3, 0)
+
+#define MT_TXD3_SN_VALID		BIT(31)
+#define MT_TXD3_PN_VALID		BIT(30)
+#define MT_TXD3_SEQ			GENMASK(27, 16)
+#define MT_TXD3_REM_TX_COUNT		GENMASK(15, 11)
+#define MT_TXD3_TX_COUNT		GENMASK(10, 6)
+#define MT_TXD3_PROTECT_FRAME		BIT(1)
+#define MT_TXD3_NO_ACK			BIT(0)
+
+#define MT_TXD4_PN_LOW			GENMASK(31, 0)
+
+#define MT_TXD5_PN_HIGH			GENMASK(31, 16)
+#define MT_TXD5_SW_POWER_MGMT		BIT(13)
+#define MT_TXD5_DA_SELECT		BIT(11)
+#define MT_TXD5_TX_STATUS_HOST		BIT(10)
+#define MT_TXD5_TX_STATUS_MCU		BIT(9)
+#define MT_TXD5_TX_STATUS_FMT		BIT(8)
+#define MT_TXD5_PID			GENMASK(7, 0)
+
+#define MT_TXD6_FIXED_RATE		BIT(31)
+#define MT_TXD6_SGI			BIT(30)
+#define MT_TXD6_LDPC			BIT(29)
+#define MT_TXD6_TX_BF			BIT(28)
+#define MT_TXD6_TX_RATE			GENMASK(27, 16)
+#define MT_TXD6_ANT_ID			GENMASK(15, 4)
+#define MT_TXD6_DYN_BW			BIT(3)
+#define MT_TXD6_FIXED_BW		BIT(2)
+#define MT_TXD6_BW			GENMASK(1, 0)
+
+#define MT_TXD7_TYPE			GENMASK(21, 20)
+#define MT_TXD7_SUB_TYPE		GENMASK(19, 16)
+
+#define MT_TX_RATE_STBC			BIT(11)
+#define MT_TX_RATE_NSS			GENMASK(10, 9)
+#define MT_TX_RATE_MODE			GENMASK(8, 6)
+#define MT_TX_RATE_IDX			GENMASK(5, 0)
+
+#define MT_TXP_MAX_BUF_NUM		6
+
+struct mt7615_txp {
+	__le16 flags;
+	__le16 token;
+	u8 bss_idx;
+	u8 rept_wds_wcid;
+	u8 rsv;
+	u8 nbuf;
+	__le32 buf[MT_TXP_MAX_BUF_NUM];
+	__le16 len[MT_TXP_MAX_BUF_NUM];
+} __packed;
+
+struct mt7615_tx_free {
+	__le16 rx_byte_cnt;
+	__le16 ctrl;
+	u8 txd_cnt;
+	u8 rsv[3];
+	__le16 token[];
+} __packed;
+
+#define MT_TX_FREE_MSDU_ID_CNT		GENMASK(6, 0)
+
+#define MT_TXS0_PID			GENMASK(31, 24)
+#define MT_TXS0_BA_ERROR		BIT(22)
+#define MT_TXS0_PS_FLAG			BIT(21)
+#define MT_TXS0_TXOP_TIMEOUT		BIT(20)
+#define MT_TXS0_BIP_ERROR		BIT(19)
+
+#define MT_TXS0_QUEUE_TIMEOUT		BIT(18)
+#define MT_TXS0_RTS_TIMEOUT		BIT(17)
+#define MT_TXS0_ACK_TIMEOUT		BIT(16)
+#define MT_TXS0_ACK_ERROR_MASK		GENMASK(18, 16)
+
+#define MT_TXS0_TX_STATUS_HOST		BIT(15)
+#define MT_TXS0_TX_STATUS_MCU		BIT(14)
+#define MT_TXS0_TXS_FORMAT		BIT(13)
+#define MT_TXS0_FIXED_RATE		BIT(12)
+#define MT_TXS0_TX_RATE			GENMASK(11, 0)
+
+#define MT_TXS1_ANT_ID			GENMASK(31, 20)
+#define MT_TXS1_RESP_RATE		GENMASK(19, 16)
+#define MT_TXS1_BW			GENMASK(15, 14)
+#define MT_TXS1_I_TXBF			BIT(13)
+#define MT_TXS1_E_TXBF			BIT(12)
+#define MT_TXS1_TID			GENMASK(11, 9)
+#define MT_TXS1_AMPDU			BIT(8)
+#define MT_TXS1_ACKED_MPDU		BIT(7)
+#define MT_TXS1_TX_POWER_DBM		GENMASK(6, 0)
+
+#define MT_TXS2_WCID			GENMASK(31, 24)
+#define MT_TXS2_RXV_SEQNO		GENMASK(23, 16)
+#define MT_TXS2_TX_DELAY		GENMASK(15, 0)
+
+#define MT_TXS3_LAST_TX_RATE		GENMASK(31, 29)
+#define MT_TXS3_TX_COUNT		GENMASK(28, 24)
+#define MT_TXS3_F1_TSSI1		GENMASK(23, 12)
+#define MT_TXS3_F1_TSSI0		GENMASK(11, 0)
+#define MT_TXS3_F0_SEQNO		GENMASK(11, 0)
+
+#define MT_TXS4_F0_TIMESTAMP		GENMASK(31, 0)
+#define MT_TXS4_F1_TSSI3		GENMASK(23, 12)
+#define MT_TXS4_F1_TSSI2		GENMASK(11, 0)
+
+#define MT_TXS5_F0_FRONT_TIME		GENMASK(24, 0)
+#define MT_TXS5_F1_NOISE_2		GENMASK(23, 16)
+#define MT_TXS5_F1_NOISE_1		GENMASK(15, 8)
+#define MT_TXS5_F1_NOISE_0		GENMASK(7, 0)
+
+#define MT_TXS6_F1_RCPI_3		GENMASK(31, 24)
+#define MT_TXS6_F1_RCPI_2		GENMASK(23, 16)
+#define MT_TXS6_F1_RCPI_1		GENMASK(15, 8)
+#define MT_TXS6_F1_RCPI_0		GENMASK(7, 0)
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/main.c b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
new file mode 100644
index 0000000..80e6b21
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/main.c
@@ -0,0 +1,499 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Roy Luo <royluo@google.com>
+ *         Ryder Lee <ryder.lee@mediatek.com>
+ *         Felix Fietkau <nbd@nbd.name>
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include "mt7615.h"
+
+static int mt7615_start(struct ieee80211_hw *hw)
+{
+	struct mt7615_dev *dev = hw->priv;
+
+	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
+				     MT7615_WATCHDOG_TIME);
+
+	return 0;
+}
+
+static void mt7615_stop(struct ieee80211_hw *hw)
+{
+	struct mt7615_dev *dev = hw->priv;
+
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
+}
+
+static int get_omac_idx(enum nl80211_iftype type, u32 mask)
+{
+	int i;
+
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+		/* ap use hw bssid 0 and ext bssid */
+		if (~mask & BIT(HW_BSSID_0))
+			return HW_BSSID_0;
+
+		for (i = EXT_BSSID_1; i < EXT_BSSID_END; i++)
+			if (~mask & BIT(i))
+				return i;
+
+		break;
+	case NL80211_IFTYPE_STATION:
+		/* sta use hw bssid other than 0 */
+		for (i = HW_BSSID_1; i < HW_BSSID_MAX; i++)
+			if (~mask & BIT(i))
+				return i;
+
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	};
+
+	return -1;
+}
+
+static int mt7615_add_interface(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct mt7615_dev *dev = hw->priv;
+	struct mt76_txq *mtxq;
+	int idx, ret = 0;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	mvif->idx = ffs(~dev->vif_mask) - 1;
+	if (mvif->idx >= MT7615_MAX_INTERFACES) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	mvif->omac_idx = get_omac_idx(vif->type, dev->omac_mask);
+	if (mvif->omac_idx < 0) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	/* TODO: DBDC support. Use band 0 and wmm 0 for now */
+	mvif->band_idx = 0;
+	mvif->wmm_idx = 0;
+
+	ret = mt7615_mcu_set_dev_info(dev, vif, 1);
+	if (ret)
+		goto out;
+
+	dev->vif_mask |= BIT(mvif->idx);
+	dev->omac_mask |= BIT(mvif->omac_idx);
+	idx = MT7615_WTBL_RESERVED - 1 - mvif->idx;
+	mvif->sta.wcid.idx = idx;
+	mvif->sta.wcid.hw_key_idx = -1;
+
+	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
+	mtxq = (struct mt76_txq *)vif->txq->drv_priv;
+	mtxq->wcid = &mvif->sta.wcid;
+	mt76_txq_init(&dev->mt76, vif->txq);
+
+out:
+	mutex_unlock(&dev->mt76.mutex);
+
+	return ret;
+}
+
+static void mt7615_remove_interface(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct mt7615_dev *dev = hw->priv;
+	int idx = mvif->sta.wcid.idx;
+
+	/* TODO: disable beacon for the bss */
+
+	mt7615_mcu_set_dev_info(dev, vif, 0);
+
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
+	mt76_txq_remove(&dev->mt76, vif->txq);
+
+	mutex_lock(&dev->mt76.mutex);
+	dev->vif_mask &= ~BIT(mvif->idx);
+	dev->omac_mask &= ~BIT(mvif->omac_idx);
+	mutex_unlock(&dev->mt76.mutex);
+}
+
+static int mt7615_set_channel(struct mt7615_dev *dev,
+			      struct cfg80211_chan_def *def)
+{
+	int ret;
+
+	cancel_delayed_work_sync(&dev->mt76.mac_work);
+	set_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76_set_channel(&dev->mt76);
+
+	ret = mt7615_mcu_set_channel(dev);
+	if (ret)
+		return ret;
+
+	clear_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76_txq_schedule_all(&dev->mt76);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mt76.mac_work,
+				     MT7615_WATCHDOG_TIME);
+	return 0;
+}
+
+static int mt7615_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+			  struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+			  struct ieee80211_key_conf *key)
+{
+	struct mt7615_dev *dev = hw->priv;
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct mt7615_sta *msta = sta ? (struct mt7615_sta *)sta->drv_priv :
+				  &mvif->sta;
+	struct mt76_wcid *wcid = &msta->wcid;
+	int idx = key->keyidx;
+
+	/* The hardware does not support per-STA RX GTK, fallback
+	 * to software mode for these.
+	 */
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
+	if (cmd == SET_KEY) {
+		key->hw_key_idx = wcid->idx;
+		wcid->hw_key_idx = idx;
+	} else {
+		if (idx == wcid->hw_key_idx)
+			wcid->hw_key_idx = -1;
+
+		key = NULL;
+	}
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
+
+	return mt7615_mcu_set_wtbl_key(dev, wcid->idx, key, cmd);
+}
+
+static int mt7615_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct mt7615_dev *dev = hw->priv;
+	int ret = 0;
+
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		mutex_lock(&dev->mt76.mutex);
+
+		ieee80211_stop_queues(hw);
+		ret = mt7615_set_channel(dev, &hw->conf.chandef);
+		ieee80211_wake_queues(hw);
+
+		mutex_unlock(&dev->mt76.mutex);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		mutex_lock(&dev->mt76.mutex);
+
+		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
+			dev->mt76.rxfilter |= MT_WF_RFCR_DROP_OTHER_UC;
+		else
+			dev->mt76.rxfilter &= ~MT_WF_RFCR_DROP_OTHER_UC;
+
+		mt76_wr(dev, MT_WF_RFCR, dev->mt76.rxfilter);
+
+		mutex_unlock(&dev->mt76.mutex);
+	}
+	return ret;
+}
+
+static int
+mt7615_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
+	       const struct ieee80211_tx_queue_params *params)
+{
+	struct mt7615_dev *dev = hw->priv;
+	static const u8 wmm_queue_map[] = {
+		[IEEE80211_AC_BK] = 0,
+		[IEEE80211_AC_BE] = 1,
+		[IEEE80211_AC_VI] = 2,
+		[IEEE80211_AC_VO] = 3,
+	};
+
+	/* TODO: hw wmm_set 1~3 */
+	return mt7615_mcu_set_wmm(dev, wmm_queue_map[queue], params);
+}
+
+static void mt7615_configure_filter(struct ieee80211_hw *hw,
+				    unsigned int changed_flags,
+				    unsigned int *total_flags,
+				    u64 multicast)
+{
+	struct mt7615_dev *dev = hw->priv;
+	u32 flags = 0;
+
+#define MT76_FILTER(_flag, _hw) do { \
+		flags |= *total_flags & FIF_##_flag;			\
+		dev->mt76.rxfilter &= ~(_hw);				\
+		dev->mt76.rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
+	} while (0)
+
+	dev->mt76.rxfilter &= ~(MT_WF_RFCR_DROP_OTHER_BSS |
+				MT_WF_RFCR_DROP_OTHER_BEACON |
+				MT_WF_RFCR_DROP_FRAME_REPORT |
+				MT_WF_RFCR_DROP_PROBEREQ |
+				MT_WF_RFCR_DROP_MCAST_FILTERED |
+				MT_WF_RFCR_DROP_MCAST |
+				MT_WF_RFCR_DROP_BCAST |
+				MT_WF_RFCR_DROP_DUPLICATE |
+				MT_WF_RFCR_DROP_A2_BSSID |
+				MT_WF_RFCR_DROP_UNWANTED_CTL |
+				MT_WF_RFCR_DROP_STBC_MULTI);
+
+	MT76_FILTER(OTHER_BSS, MT_WF_RFCR_DROP_OTHER_TIM |
+			       MT_WF_RFCR_DROP_A3_MAC |
+			       MT_WF_RFCR_DROP_A3_BSSID);
+
+	MT76_FILTER(FCSFAIL, MT_WF_RFCR_DROP_FCSFAIL);
+
+	MT76_FILTER(CONTROL, MT_WF_RFCR_DROP_CTS |
+			     MT_WF_RFCR_DROP_RTS |
+			     MT_WF_RFCR_DROP_CTL_RSV |
+			     MT_WF_RFCR_DROP_NDPA);
+
+	*total_flags = flags;
+	mt76_wr(dev, MT_WF_RFCR, dev->mt76.rxfilter);
+}
+
+static void mt7615_bss_info_changed(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
+				    struct ieee80211_bss_conf *info,
+				    u32 changed)
+{
+	struct mt7615_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	/* TODO: sta mode connect/disconnect
+	 * BSS_CHANGED_ASSOC | BSS_CHANGED_BSSID
+	 */
+
+	/* TODO: update beacon content
+	 * BSS_CHANGED_BEACON
+	 */
+
+	if (changed & BSS_CHANGED_BEACON_ENABLED) {
+		if (info->enable_beacon) {
+			mt7615_mcu_set_bss_info(dev, vif, 1);
+			mt7615_mcu_add_wtbl_bmc(dev, vif);
+			mt7615_mcu_set_sta_rec_bmc(dev, vif, 1);
+			mt7615_mcu_set_bcn(dev, vif, 1);
+		} else {
+			mt7615_mcu_set_sta_rec_bmc(dev, vif, 0);
+			mt7615_mcu_del_wtbl_bmc(dev, vif);
+			mt7615_mcu_set_bss_info(dev, vif, 0);
+			mt7615_mcu_set_bcn(dev, vif, 0);
+		}
+	}
+
+	mutex_unlock(&dev->mt76.mutex);
+}
+
+int mt7615_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta)
+{
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	int idx;
+
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7615_WTBL_STA - 1);
+	if (idx < 0)
+		return -ENOSPC;
+
+	msta->vif = mvif;
+	msta->wcid.sta = 1;
+	msta->wcid.idx = idx;
+
+	mt7615_mcu_add_wtbl(dev, vif, sta);
+	mt7615_mcu_set_sta_rec(dev, vif, sta, 1);
+
+	return 0;
+}
+
+void mt7615_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta)
+{
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+
+	if (sta->ht_cap.ht_supported)
+		mt7615_mcu_set_ht_cap(dev, vif, sta);
+}
+
+void mt7615_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta)
+{
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+
+	mt7615_mcu_set_sta_rec(dev, vif, sta, 0);
+	mt7615_mcu_del_wtbl(dev, vif, sta);
+}
+
+static void mt7615_sta_rate_tbl_update(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta)
+{
+	struct mt7615_dev *dev = hw->priv;
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct ieee80211_sta_rates *sta_rates = rcu_dereference(sta->rates);
+	int i;
+
+	spin_lock_bh(&dev->mt76.lock);
+	for (i = 0; i < ARRAY_SIZE(msta->rates); i++) {
+		msta->rates[i].idx = sta_rates->rate[i].idx;
+		msta->rates[i].count = sta_rates->rate[i].count;
+		msta->rates[i].flags = sta_rates->rate[i].flags;
+
+		if (msta->rates[i].idx < 0 || !msta->rates[i].count)
+			break;
+	}
+	msta->n_rates = i;
+	mt7615_mcu_set_rates(dev, msta, NULL, msta->rates);
+	msta->rate_probe = false;
+	spin_unlock_bh(&dev->mt76.lock);
+}
+
+static void mt7615_tx(struct ieee80211_hw *hw,
+		      struct ieee80211_tx_control *control,
+		      struct sk_buff *skb)
+{
+	struct mt7615_dev *dev = hw->priv;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
+
+	if (control->sta) {
+		struct mt7615_sta *sta;
+
+		sta = (struct mt7615_sta *)control->sta->drv_priv;
+		wcid = &sta->wcid;
+	}
+
+	if (vif && !control->sta) {
+		struct mt7615_vif *mvif;
+
+		mvif = (struct mt7615_vif *)vif->drv_priv;
+		wcid = &mvif->sta.wcid;
+	}
+
+	mt76_tx(&dev->mt76, control->sta, wcid, skb);
+}
+
+static int mt7615_set_rts_threshold(struct ieee80211_hw *hw, u32 val)
+{
+	struct mt7615_dev *dev = hw->priv;
+
+	mutex_lock(&dev->mt76.mutex);
+	mt7615_mcu_set_rts_thresh(dev, val);
+	mutex_unlock(&dev->mt76.mutex);
+
+	return 0;
+}
+
+static int
+mt7615_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    struct ieee80211_ampdu_params *params)
+{
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	struct mt7615_dev *dev = hw->priv;
+	struct ieee80211_sta *sta = params->sta;
+	struct ieee80211_txq *txq = sta->txq[params->tid];
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	struct mt76_txq *mtxq;
+
+	if (!txq)
+		return -EINVAL;
+
+	mtxq = (struct mt76_txq *)txq->drv_priv;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, *ssn,
+				   params->buf_size);
+		mt7615_mcu_set_rx_ba(dev, params, 1);
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
+		mt7615_mcu_set_rx_ba(dev, params, 0);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		mtxq->aggr = true;
+		mtxq->send_bar = false;
+		mt7615_mcu_set_tx_ba(dev, params, 1);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		mtxq->aggr = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		mt7615_mcu_set_tx_ba(dev, params, 0);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		mtxq->agg_ssn = IEEE80211_SN_TO_SEQ(*ssn);
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		mtxq->aggr = false;
+		mt7615_mcu_set_tx_ba(dev, params, 0);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	}
+
+	return 0;
+}
+
+static void
+mt7615_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	       const u8 *mac)
+{
+	struct mt7615_dev *dev = hw->priv;
+
+	set_bit(MT76_SCANNING, &dev->mt76.state);
+}
+
+static void
+mt7615_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt7615_dev *dev = hw->priv;
+
+	clear_bit(MT76_SCANNING, &dev->mt76.state);
+}
+
+const struct ieee80211_ops mt7615_ops = {
+	.tx = mt7615_tx,
+	.start = mt7615_start,
+	.stop = mt7615_stop,
+	.add_interface = mt7615_add_interface,
+	.remove_interface = mt7615_remove_interface,
+	.config = mt7615_config,
+	.conf_tx = mt7615_conf_tx,
+	.configure_filter = mt7615_configure_filter,
+	.bss_info_changed = mt7615_bss_info_changed,
+	.sta_state = mt76_sta_state,
+	.set_key = mt7615_set_key,
+	.ampdu_action = mt7615_ampdu_action,
+	.set_rts_threshold = mt7615_set_rts_threshold,
+	.wake_tx_queue = mt76_wake_tx_queue,
+	.sta_rate_tbl_update = mt7615_sta_rate_tbl_update,
+	.sw_scan_start = mt7615_sw_scan,
+	.sw_scan_complete = mt7615_sw_scan_complete,
+	.release_buffered_frames = mt76_release_buffered_frames,
+};
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
new file mode 100644
index 0000000..b095406
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -0,0 +1,1656 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Roy Luo <royluo@google.com>
+ *         Ryder Lee <ryder.lee@mediatek.com>
+ */
+
+#include <linux/firmware.h>
+#include "mt7615.h"
+#include "mcu.h"
+#include "mac.h"
+#include "eeprom.h"
+
+struct mt7615_patch_hdr {
+	char build_date[16];
+	char platform[4];
+	__be32 hw_sw_ver;
+	__be32 patch_ver;
+	__be16 checksum;
+} __packed;
+
+struct mt7615_fw_trailer {
+	__le32 addr;
+	u8 chip_id;
+	u8 feature_set;
+	u8 eco_code;
+	char fw_ver[10];
+	char build_date[15];
+	__le32 len;
+} __packed;
+
+#define MCU_PATCH_ADDRESS		0x80000
+
+#define N9_REGION_NUM			2
+#define CR4_REGION_NUM			1
+
+#define IMG_CRC_LEN			4
+
+#define FW_FEATURE_SET_ENCRYPT		BIT(0)
+#define FW_FEATURE_SET_KEY_IDX		GENMASK(2, 1)
+
+#define DL_MODE_ENCRYPT			BIT(0)
+#define DL_MODE_KEY_IDX			GENMASK(2, 1)
+#define DL_MODE_RESET_SEC_IV		BIT(3)
+#define DL_MODE_WORKING_PDA_CR4		BIT(4)
+#define DL_MODE_NEED_RSP		BIT(31)
+
+#define FW_START_OVERRIDE		BIT(0)
+#define FW_START_WORKING_PDA_CR4	BIT(2)
+
+static int __mt7615_mcu_msg_send(struct mt7615_dev *dev, struct sk_buff *skb,
+				 int cmd, int query, int dest, int *wait_seq)
+{
+	struct mt7615_mcu_txd *mcu_txd;
+	u8 seq, q_idx, pkt_fmt;
+	enum mt76_txq_id qid;
+	u32 val;
+	__le32 *txd;
+
+	if (!skb)
+		return -EINVAL;
+
+	seq = ++dev->mt76.mmio.mcu.msg_seq & 0xf;
+	if (!seq)
+		seq = ++dev->mt76.mmio.mcu.msg_seq & 0xf;
+
+	mcu_txd = (struct mt7615_mcu_txd *)skb_push(skb,
+		   sizeof(struct mt7615_mcu_txd));
+	memset(mcu_txd, 0, sizeof(struct mt7615_mcu_txd));
+
+	if (cmd != -MCU_CMD_FW_SCATTER) {
+		q_idx = MT_TX_MCU_PORT_RX_Q0;
+		pkt_fmt = MT_TX_TYPE_CMD;
+	} else {
+		q_idx = MT_TX_MCU_PORT_RX_FWDL;
+		pkt_fmt = MT_TX_TYPE_FW;
+	}
+
+	txd = mcu_txd->txd;
+
+	val = FIELD_PREP(MT_TXD0_TX_BYTES, cpu_to_le16(skb->len)) |
+	      FIELD_PREP(MT_TXD0_P_IDX, MT_TX_PORT_IDX_MCU) |
+	      FIELD_PREP(MT_TXD0_Q_IDX, q_idx);
+	txd[0] = cpu_to_le32(val);
+
+	val = MT_TXD1_LONG_FORMAT |
+	      FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_CMD) |
+	      FIELD_PREP(MT_TXD1_PKT_FMT, pkt_fmt);
+	txd[1] = cpu_to_le32(val);
+
+	mcu_txd->len = cpu_to_le16(skb->len -
+				   sizeof_field(struct mt7615_mcu_txd, txd));
+	mcu_txd->pq_id = cpu_to_le16(MCU_PQ_ID(MT_TX_PORT_IDX_MCU, q_idx));
+	mcu_txd->pkt_type = MCU_PKT_ID;
+	mcu_txd->seq = seq;
+
+	if (cmd < 0) {
+		mcu_txd->cid = -cmd;
+	} else {
+		mcu_txd->cid = MCU_CMD_EXT_CID;
+		mcu_txd->ext_cid = cmd;
+		if (query != MCU_Q_NA)
+			mcu_txd->ext_cid_ack = 1;
+	}
+
+	mcu_txd->set_query = query;
+	mcu_txd->s2d_index = dest;
+
+	if (wait_seq)
+		*wait_seq = seq;
+
+	if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state))
+		qid = MT_TXQ_MCU;
+	else
+		qid = MT_TXQ_FWDL;
+
+	return mt76_tx_queue_skb_raw(dev, qid, skb, 0);
+}
+
+static int mt7615_mcu_msg_send(struct mt7615_dev *dev, struct sk_buff *skb,
+			       int cmd, int query, int dest,
+			       struct sk_buff **skb_ret)
+{
+	unsigned long expires = jiffies + 10 * HZ;
+	struct mt7615_mcu_rxd *rxd;
+	int ret, seq;
+
+	mutex_lock(&dev->mt76.mmio.mcu.mutex);
+
+	ret = __mt7615_mcu_msg_send(dev, skb, cmd, query, dest, &seq);
+	if (ret)
+		goto out;
+
+	while (1) {
+		skb = mt76_mcu_get_response(&dev->mt76, expires);
+		if (!skb) {
+			dev_err(dev->mt76.dev, "Message %d (seq %d) timeout\n",
+				cmd, seq);
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		rxd = (struct mt7615_mcu_rxd *)skb->data;
+		if (seq != rxd->seq)
+			continue;
+
+		if (skb_ret) {
+			int hdr_len = sizeof(*rxd);
+
+			if (!test_bit(MT76_STATE_MCU_RUNNING,
+				      &dev->mt76.state))
+				hdr_len -= 4;
+			skb_pull(skb, hdr_len);
+			*skb_ret = skb;
+		} else {
+			dev_kfree_skb(skb);
+		}
+
+		break;
+	}
+
+out:
+	mutex_unlock(&dev->mt76.mmio.mcu.mutex);
+
+	return ret;
+}
+
+static int mt7615_mcu_init_download(struct mt7615_dev *dev, u32 addr,
+				    u32 len, u32 mode)
+{
+	struct {
+		__le32 addr;
+		__le32 len;
+		__le32 mode;
+	} req = {
+		.addr = cpu_to_le32(addr),
+		.len = cpu_to_le32(len),
+		.mode = cpu_to_le32(mode),
+	};
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, -MCU_CMD_TARGET_ADDRESS_LEN_REQ,
+				   MCU_Q_NA, MCU_S2D_H2N, NULL);
+}
+
+static int mt7615_mcu_send_firmware(struct mt7615_dev *dev, const void *data,
+				    int len)
+{
+	struct sk_buff *skb;
+	int ret = 0;
+
+	while (len > 0) {
+		int cur_len = min_t(int, 4096 - sizeof(struct mt7615_mcu_txd),
+				    len);
+
+		skb = mt7615_mcu_msg_alloc(data, cur_len);
+		if (!skb)
+			return -ENOMEM;
+
+		ret = __mt7615_mcu_msg_send(dev, skb, -MCU_CMD_FW_SCATTER,
+					    MCU_Q_NA, MCU_S2D_H2N, NULL);
+		if (ret)
+			break;
+
+		data += cur_len;
+		len -= cur_len;
+	}
+
+	return ret;
+}
+
+static int mt7615_mcu_start_firmware(struct mt7615_dev *dev, u32 addr,
+				     u32 option)
+{
+	struct {
+		__le32 option;
+		__le32 addr;
+	} req = {
+		.option = cpu_to_le32(option),
+		.addr = cpu_to_le32(addr),
+	};
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, -MCU_CMD_FW_START_REQ,
+				   MCU_Q_NA, MCU_S2D_H2N, NULL);
+}
+
+static int mt7615_mcu_restart(struct mt7615_dev *dev)
+{
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(NULL, 0);
+
+	return mt7615_mcu_msg_send(dev, skb, -MCU_CMD_RESTART_DL_REQ,
+				   MCU_Q_NA, MCU_S2D_H2N, NULL);
+}
+
+static int mt7615_mcu_patch_sem_ctrl(struct mt7615_dev *dev, bool get)
+{
+	struct {
+		__le32 operation;
+	} req = {
+		.operation = cpu_to_le32(get ? PATCH_SEM_GET :
+					 PATCH_SEM_RELEASE),
+	};
+	struct event {
+		u8 status;
+		u8 reserved[3];
+	} *resp;
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+	struct sk_buff *skb_ret;
+	int ret;
+
+	ret = mt7615_mcu_msg_send(dev, skb, -MCU_CMD_PATCH_SEM_CONTROL,
+				  MCU_Q_NA, MCU_S2D_H2N, &skb_ret);
+	if (ret)
+		goto out;
+
+	resp = (struct event *)(skb_ret->data);
+	ret = resp->status;
+	dev_kfree_skb(skb_ret);
+
+out:
+	return ret;
+}
+
+static int mt7615_mcu_start_patch(struct mt7615_dev *dev)
+{
+	struct {
+		u8 check_crc;
+		u8 reserved[3];
+	} req = {
+		.check_crc = 0,
+	};
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, -MCU_CMD_PATCH_FINISH_REQ,
+				   MCU_Q_NA, MCU_S2D_H2N, NULL);
+}
+
+static int mt7615_driver_own(struct mt7615_dev *dev)
+{
+	mt76_wr(dev, MT_CFG_LPCR_HOST, MT_CFG_LPCR_HOST_DRV_OWN);
+	if (!mt76_poll_msec(dev, MT_CFG_LPCR_HOST,
+			    MT_CFG_LPCR_HOST_FW_OWN, 0, 500)) {
+		dev_err(dev->mt76.dev, "Timeout for driver own\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int mt7615_load_patch(struct mt7615_dev *dev)
+{
+	const struct firmware *fw;
+	const struct mt7615_patch_hdr *hdr;
+	const char *firmware = MT7615_ROM_PATCH;
+	int len, ret, sem;
+
+	sem = mt7615_mcu_patch_sem_ctrl(dev, 1);
+	switch (sem) {
+	case PATCH_IS_DL:
+		return 0;
+	case PATCH_NOT_DL_SEM_SUCCESS:
+		break;
+	default:
+		dev_err(dev->mt76.dev, "Failed to get patch semaphore\n");
+		return -EAGAIN;
+	}
+
+	ret = request_firmware(&fw, firmware, dev->mt76.dev);
+	if (ret)
+		return ret;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+		dev_err(dev->mt76.dev, "Invalid firmware\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	hdr = (const struct mt7615_patch_hdr *)(fw->data);
+
+	dev_info(dev->mt76.dev, "HW/SW Version: 0x%x, Build Time: %.16s\n",
+		 be32_to_cpu(hdr->hw_sw_ver), hdr->build_date);
+
+	len = fw->size - sizeof(*hdr);
+
+	ret = mt7615_mcu_init_download(dev, MCU_PATCH_ADDRESS, len,
+				       DL_MODE_NEED_RSP);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Download request failed\n");
+		goto out;
+	}
+
+	ret = mt7615_mcu_send_firmware(dev, fw->data + sizeof(*hdr), len);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Failed to send firmware to device\n");
+		goto out;
+	}
+
+	ret = mt7615_mcu_start_patch(dev);
+	if (ret)
+		dev_err(dev->mt76.dev, "Failed to start patch\n");
+
+out:
+	release_firmware(fw);
+
+	sem = mt7615_mcu_patch_sem_ctrl(dev, 0);
+	switch (sem) {
+	case PATCH_REL_SEM_SUCCESS:
+		break;
+	default:
+		ret = -EAGAIN;
+		dev_err(dev->mt76.dev, "Failed to release patch semaphore\n");
+		break;
+	}
+
+	return ret;
+}
+
+static u32 gen_dl_mode(u8 feature_set, bool is_cr4)
+{
+	u32 ret = 0;
+
+	ret |= (feature_set & FW_FEATURE_SET_ENCRYPT) ?
+	       (DL_MODE_ENCRYPT | DL_MODE_RESET_SEC_IV) : 0;
+	ret |= FIELD_PREP(DL_MODE_KEY_IDX,
+			  FIELD_GET(FW_FEATURE_SET_KEY_IDX, feature_set));
+	ret |= DL_MODE_NEED_RSP;
+	ret |= is_cr4 ? DL_MODE_WORKING_PDA_CR4 : 0;
+
+	return ret;
+}
+
+static int mt7615_load_ram(struct mt7615_dev *dev)
+{
+	const struct firmware *fw;
+	const struct mt7615_fw_trailer *hdr;
+	const char *n9_firmware = MT7615_FIRMWARE_N9;
+	const char *cr4_firmware = MT7615_FIRMWARE_CR4;
+	u32 n9_ilm_addr, offset;
+	int i, ret;
+
+	ret = request_firmware(&fw, n9_firmware, dev->mt76.dev);
+	if (ret)
+		return ret;
+
+	if (!fw || !fw->data || fw->size < N9_REGION_NUM * sizeof(*hdr)) {
+		dev_err(dev->mt76.dev, "Invalid firmware\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	hdr = (const struct mt7615_fw_trailer *)(fw->data + fw->size -
+					N9_REGION_NUM * sizeof(*hdr));
+
+	dev_info(dev->mt76.dev, "N9 Firmware Version: %.10s, Build Time: %.15s\n",
+		 hdr->fw_ver, hdr->build_date);
+
+	n9_ilm_addr = le32_to_cpu(hdr->addr);
+
+	for (offset = 0, i = 0; i < N9_REGION_NUM; i++) {
+		u32 len, addr, mode;
+
+		len = le32_to_cpu(hdr[i].len) + IMG_CRC_LEN;
+		addr = le32_to_cpu(hdr[i].addr);
+		mode = gen_dl_mode(hdr[i].feature_set, false);
+
+		ret = mt7615_mcu_init_download(dev, addr, len, mode);
+		if (ret) {
+			dev_err(dev->mt76.dev, "Download request failed\n");
+			goto out;
+		}
+
+		ret = mt7615_mcu_send_firmware(dev, fw->data + offset, len);
+		if (ret) {
+			dev_err(dev->mt76.dev, "Failed to send firmware to device\n");
+			goto out;
+		}
+
+		offset += len;
+	}
+
+	ret = mt7615_mcu_start_firmware(dev, n9_ilm_addr, FW_START_OVERRIDE);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Failed to start N9 firmware\n");
+		goto out;
+	}
+
+	release_firmware(fw);
+
+	ret = request_firmware(&fw, cr4_firmware, dev->mt76.dev);
+	if (ret)
+		return ret;
+
+	if (!fw || !fw->data || fw->size < CR4_REGION_NUM * sizeof(*hdr)) {
+		dev_err(dev->mt76.dev, "Invalid firmware\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	hdr = (const struct mt7615_fw_trailer *)(fw->data + fw->size -
+					CR4_REGION_NUM * sizeof(*hdr));
+
+	dev_info(dev->mt76.dev, "CR4 Firmware Version: %.10s, Build Time: %.15s\n",
+		 hdr->fw_ver, hdr->build_date);
+
+	for (offset = 0, i = 0; i < CR4_REGION_NUM; i++) {
+		u32 len, addr, mode;
+
+		len = le32_to_cpu(hdr[i].len) + IMG_CRC_LEN;
+		addr = le32_to_cpu(hdr[i].addr);
+		mode = gen_dl_mode(hdr[i].feature_set, true);
+
+		ret = mt7615_mcu_init_download(dev, addr, len, mode);
+		if (ret) {
+			dev_err(dev->mt76.dev, "Download request failed\n");
+			goto out;
+		}
+
+		ret = mt7615_mcu_send_firmware(dev, fw->data + offset, len);
+		if (ret) {
+			dev_err(dev->mt76.dev, "Failed to send firmware to device\n");
+			goto out;
+		}
+
+		offset += len;
+	}
+
+	ret = mt7615_mcu_start_firmware(dev, 0, FW_START_WORKING_PDA_CR4);
+	if (ret)
+		dev_err(dev->mt76.dev, "Failed to start CR4 firmware\n");
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+static int mt7615_load_firmware(struct mt7615_dev *dev)
+{
+	int ret;
+	u32 val;
+
+	val = mt76_get_field(dev, MT_TOP_MISC2, MT_TOP_MISC2_FW_STATE);
+
+	if (val != FW_STATE_FW_DOWNLOAD) {
+		dev_err(dev->mt76.dev, "Firmware is not ready for download\n");
+		return -EIO;
+	}
+
+	ret = mt7615_load_patch(dev);
+	if (ret)
+		return ret;
+
+	ret = mt7615_load_ram(dev);
+	if (ret)
+		return ret;
+
+	if (!mt76_poll_msec(dev, MT_TOP_MISC2, MT_TOP_MISC2_FW_STATE,
+			    FIELD_PREP(MT_TOP_MISC2_FW_STATE,
+				       FW_STATE_CR4_RDY), 500)) {
+		dev_err(dev->mt76.dev, "Timeout for initializing firmware\n");
+		return -EIO;
+	}
+
+	dev_dbg(dev->mt76.dev, "Firmware init done\n");
+
+	return 0;
+}
+
+int mt7615_mcu_init(struct mt7615_dev *dev)
+{
+	int ret;
+
+	ret = mt7615_driver_own(dev);
+	if (ret)
+		return ret;
+
+	ret = mt7615_load_firmware(dev);
+	if (ret)
+		return ret;
+
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
+
+	return 0;
+}
+
+void mt7615_mcu_exit(struct mt7615_dev *dev)
+{
+	mt7615_mcu_restart(dev);
+	mt76_wr(dev, MT_CFG_LPCR_HOST, MT_CFG_LPCR_HOST_FW_OWN);
+	skb_queue_purge(&dev->mt76.mmio.mcu.res_q);
+}
+
+int mt7615_mcu_set_eeprom(struct mt7615_dev *dev)
+{
+	struct req_data {
+		u8 val;
+	} __packed;
+	struct {
+		u8 buffer_mode;
+		u8 pad;
+		u16 len;
+	} __packed req_hdr = {
+		.buffer_mode = 1,
+		.len = __MT_EE_MAX - MT_EE_NIC_CONF_0,
+	};
+	struct sk_buff *skb;
+	struct req_data *data;
+	const int size = (__MT_EE_MAX - MT_EE_NIC_CONF_0) *
+			 sizeof(struct req_data);
+	u8 *eep = (u8 *)dev->mt76.eeprom.data;
+	u16 off;
+
+	skb = mt7615_mcu_msg_alloc(NULL, size + sizeof(req_hdr));
+	memcpy(skb_put(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
+	data = (struct req_data *)skb_put(skb, size);
+	memset(data, 0, size);
+
+	for (off = MT_EE_NIC_CONF_0; off < __MT_EE_MAX; off++)
+		data[off - MT_EE_NIC_CONF_0].val = eep[off];
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_init_mac(struct mt7615_dev *dev)
+{
+	struct {
+		u8 enable;
+		u8 band;
+		u8 rsv[2];
+	} __packed req = {
+		.enable = 1,
+		.band = 0,
+	};
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_MAC_INIT_CTRL,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_set_rts_thresh(struct mt7615_dev *dev, u32 val)
+{
+	struct {
+		u8 prot_idx;
+		u8 band;
+		u8 rsv[2];
+		__le32 len_thresh;
+		__le32 pkt_thresh;
+	} __packed req = {
+		.prot_idx = 1,
+		.band = 0,
+		.len_thresh = cpu_to_le32(val),
+		.pkt_thresh = cpu_to_le32(0x2),
+	};
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_PROTECT_CTRL,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_set_wmm(struct mt7615_dev *dev, u8 queue,
+		       const struct ieee80211_tx_queue_params *params)
+{
+#define WMM_AIFS_SET	BIT(0)
+#define WMM_CW_MIN_SET	BIT(1)
+#define WMM_CW_MAX_SET	BIT(2)
+#define WMM_TXOP_SET	BIT(3)
+	struct req_data {
+		u8 number;
+		u8 rsv[3];
+		u8 queue;
+		u8 valid;
+		u8 aifs;
+		u8 cw_min;
+		__le16 cw_max;
+		__le16 txop;
+	} __packed req = {
+		.number = 1,
+		.queue = queue,
+		.valid = WMM_AIFS_SET | WMM_TXOP_SET,
+		.aifs = params->aifs,
+		.txop = cpu_to_le16(params->txop),
+	};
+	struct sk_buff *skb;
+
+	if (params->cw_min) {
+		req.valid |= WMM_CW_MIN_SET;
+		req.cw_min = params->cw_min;
+	}
+	if (params->cw_max) {
+		req.valid |= WMM_CW_MAX_SET;
+		req.cw_max = cpu_to_le16(params->cw_max);
+	}
+
+	skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_EDCA_UPDATE,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_ctrl_pm_state(struct mt7615_dev *dev, int enter)
+{
+#define ENTER_PM_STATE	1
+#define EXIT_PM_STATE	2
+	struct {
+		u8 pm_number;
+		u8 pm_state;
+		u8 bssid[ETH_ALEN];
+		u8 dtim_period;
+		u8 wlan_idx;
+		__le16 bcn_interval;
+		__le32 aid;
+		__le32 rx_filter;
+		u8 band_idx;
+		u8 rsv[3];
+		__le32 feature;
+		u8 omac_idx;
+		u8 wmm_idx;
+		u8 bcn_loss_cnt;
+		u8 bcn_sp_duration;
+	} __packed req = {
+		.pm_number = 5,
+		.pm_state = (enter) ? ENTER_PM_STATE : EXIT_PM_STATE,
+		.band_idx = 0,
+	};
+	struct sk_buff *skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_PM_STATE_CTRL,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+static int __mt7615_mcu_set_dev_info(struct mt7615_dev *dev,
+				     struct dev_info *dev_info)
+{
+	struct req_hdr {
+		u8 omac_idx;
+		u8 band_idx;
+		__le16 tlv_num;
+		u8 is_tlv_append;
+		u8 rsv[3];
+	} __packed req_hdr = {0};
+	struct req_tlv {
+		__le16 tag;
+		__le16 len;
+		u8 active;
+		u8 band_idx;
+		u8 omac_addr[ETH_ALEN];
+	} __packed;
+	struct sk_buff *skb;
+	u16 tlv_num = 0;
+
+	skb = mt7615_mcu_msg_alloc(NULL, sizeof(req_hdr) +
+				   sizeof(struct req_tlv));
+	skb_reserve(skb, sizeof(req_hdr));
+
+	if (dev_info->feature & BIT(DEV_INFO_ACTIVE)) {
+		struct req_tlv req_tlv = {
+			.tag = cpu_to_le16(DEV_INFO_ACTIVE),
+			.len = cpu_to_le16(sizeof(req_tlv)),
+			.active = dev_info->enable,
+			.band_idx = dev_info->band_idx,
+		};
+		memcpy(req_tlv.omac_addr, dev_info->omac_addr, ETH_ALEN);
+		memcpy(skb_put(skb, sizeof(req_tlv)), &req_tlv,
+		       sizeof(req_tlv));
+		tlv_num++;
+	}
+
+	req_hdr.omac_idx = dev_info->omac_idx;
+	req_hdr.band_idx = dev_info->band_idx;
+	req_hdr.tlv_num = cpu_to_le16(tlv_num);
+	req_hdr.is_tlv_append = tlv_num ? 1 : 0;
+
+	memcpy(skb_push(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_DEV_INFO_UPDATE,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_set_dev_info(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			    int en)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct dev_info dev_info = {0};
+
+	dev_info.omac_idx = mvif->omac_idx;
+	memcpy(dev_info.omac_addr, vif->addr, ETH_ALEN);
+	dev_info.band_idx = mvif->band_idx;
+	dev_info.enable = en;
+	dev_info.feature = BIT(DEV_INFO_ACTIVE);
+
+	return __mt7615_mcu_set_dev_info(dev, &dev_info);
+}
+
+static void bss_info_omac_handler (struct mt7615_dev *dev,
+				   struct bss_info *bss_info,
+				   struct sk_buff *skb)
+{
+	struct bss_info_omac tlv = {0};
+
+	tlv.tag = cpu_to_le16(BSS_INFO_OMAC);
+	tlv.len = cpu_to_le16(sizeof(tlv));
+	tlv.hw_bss_idx = (bss_info->omac_idx > EXT_BSSID_START) ?
+			 HW_BSSID_0 : bss_info->omac_idx;
+	tlv.omac_idx = bss_info->omac_idx;
+	tlv.band_idx = bss_info->band_idx;
+	tlv.conn_type = cpu_to_le32(bss_info->conn_type);
+
+	memcpy(skb_put(skb, sizeof(tlv)), &tlv, sizeof(tlv));
+}
+
+static void bss_info_basic_handler (struct mt7615_dev *dev,
+				    struct bss_info *bss_info,
+				    struct sk_buff *skb)
+{
+	struct bss_info_basic tlv = {0};
+
+	tlv.tag = cpu_to_le16(BSS_INFO_BASIC);
+	tlv.len = cpu_to_le16(sizeof(tlv));
+	tlv.network_type = cpu_to_le32(bss_info->network_type);
+	tlv.active = bss_info->enable;
+	tlv.bcn_interval = cpu_to_le16(bss_info->bcn_interval);
+	memcpy(tlv.bssid, bss_info->bssid, ETH_ALEN);
+	tlv.wmm_idx = bss_info->wmm_idx;
+	tlv.dtim_period = bss_info->dtim_period;
+	tlv.bmc_tx_wlan_idx = bss_info->bmc_tx_wlan_idx;
+
+	memcpy(skb_put(skb, sizeof(tlv)), &tlv, sizeof(tlv));
+}
+
+static void bss_info_ext_bss_handler (struct mt7615_dev *dev,
+				      struct bss_info *bss_info,
+				      struct sk_buff *skb)
+{
+/* SIFS 20us + 512 byte beacon tranmitted by 1Mbps (3906us) */
+#define BCN_TX_ESTIMATE_TIME (4096 + 20)
+	struct bss_info_ext_bss tlv = {0};
+	int ext_bss_idx;
+
+	ext_bss_idx = bss_info->omac_idx - EXT_BSSID_START;
+
+	if (ext_bss_idx < 0)
+		return;
+
+	tlv.tag = cpu_to_le16(BSS_INFO_EXT_BSS);
+	tlv.len = cpu_to_le16(sizeof(tlv));
+	tlv.mbss_tsf_offset = ext_bss_idx * BCN_TX_ESTIMATE_TIME;
+
+	memcpy(skb_put(skb, sizeof(tlv)), &tlv, sizeof(tlv));
+}
+
+static struct bss_info_tag_handler bss_info_tag_handler[] = {
+	{BSS_INFO_OMAC, sizeof(struct bss_info_omac), bss_info_omac_handler},
+	{BSS_INFO_BASIC, sizeof(struct bss_info_basic), bss_info_basic_handler},
+	{BSS_INFO_RF_CH, sizeof(struct bss_info_rf_ch), NULL},
+	{BSS_INFO_PM, 0, NULL},
+	{BSS_INFO_UAPSD, 0, NULL},
+	{BSS_INFO_ROAM_DETECTION, 0, NULL},
+	{BSS_INFO_LQ_RM, 0, NULL},
+	{BSS_INFO_EXT_BSS, sizeof(struct bss_info_ext_bss), bss_info_ext_bss_handler},
+	{BSS_INFO_BMC_INFO, 0, NULL},
+	{BSS_INFO_SYNC_MODE, 0, NULL},
+	{BSS_INFO_RA, 0, NULL},
+	{BSS_INFO_MAX_NUM, 0, NULL},
+};
+
+static int __mt7615_mcu_set_bss_info(struct mt7615_dev *dev,
+				     struct bss_info *bss_info)
+{
+	struct req_hdr {
+		u8 bss_idx;
+		u8 rsv0;
+		__le16 tlv_num;
+		u8 is_tlv_append;
+		u8 rsv1[3];
+	} __packed req_hdr = {0};
+	struct sk_buff *skb;
+	u16 tlv_num = 0;
+	u32 size = 0;
+	int i;
+
+	for (i = 0; i < BSS_INFO_MAX_NUM; i++)
+		if ((BIT(bss_info_tag_handler[i].tag) & bss_info->feature) &&
+		    bss_info_tag_handler[i].handler) {
+			tlv_num++;
+			size += bss_info_tag_handler[i].len;
+		}
+
+	skb = mt7615_mcu_msg_alloc(NULL, sizeof(req_hdr) + size);
+
+	req_hdr.bss_idx = bss_info->bss_idx;
+	req_hdr.tlv_num = cpu_to_le16(tlv_num);
+	req_hdr.is_tlv_append = tlv_num ? 1 : 0;
+
+	memcpy(skb_put(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
+
+	for (i = 0; i < BSS_INFO_MAX_NUM; i++)
+		if ((BIT(bss_info_tag_handler[i].tag) & bss_info->feature) &&
+		    bss_info_tag_handler[i].handler)
+			bss_info_tag_handler[i].handler(dev, bss_info, skb);
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_BSS_INFO_UPDATE,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+static void bss_info_convert_vif_type(enum nl80211_iftype type,
+				      u32 *network_type, u32 *conn_type)
+{
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+		if (network_type)
+			*network_type = NETWORK_INFRA;
+		if (conn_type)
+			*conn_type = CONNECTION_INFRA_AP;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (network_type)
+			*network_type = NETWORK_INFRA;
+		if (conn_type)
+			*conn_type = CONNECTION_INFRA_STA;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	};
+}
+
+int mt7615_mcu_set_bss_info(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			    int en)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct bss_info bss_info = {0};
+	u8 bmc_tx_wlan_idx = 0;
+	u32 network_type = 0, conn_type = 0;
+
+	if (vif->type == NL80211_IFTYPE_AP) {
+		bmc_tx_wlan_idx = mvif->sta.wcid.idx;
+	} else if (vif->type == NL80211_IFTYPE_STATION) {
+		/* find the unicast entry for sta mode bmc tx */
+		struct ieee80211_sta *ap_sta;
+		struct mt7615_sta *msta;
+
+		rcu_read_lock();
+
+		ap_sta = ieee80211_find_sta(vif, vif->bss_conf.bssid);
+		if (!ap_sta) {
+			rcu_read_unlock();
+			return -EINVAL;
+		}
+
+		msta = (struct mt7615_sta *)ap_sta->drv_priv;
+		bmc_tx_wlan_idx = msta->wcid.idx;
+
+		rcu_read_unlock();
+	} else {
+		WARN_ON(1);
+	}
+
+	bss_info_convert_vif_type(vif->type, &network_type, &conn_type);
+
+	bss_info.bss_idx = mvif->idx;
+	memcpy(bss_info.bssid, vif->bss_conf.bssid, ETH_ALEN);
+	bss_info.omac_idx = mvif->omac_idx;
+	bss_info.band_idx = mvif->band_idx;
+	bss_info.bmc_tx_wlan_idx = bmc_tx_wlan_idx;
+	bss_info.wmm_idx = mvif->wmm_idx;
+	bss_info.network_type = network_type;
+	bss_info.conn_type = conn_type;
+	bss_info.bcn_interval = vif->bss_conf.beacon_int;
+	bss_info.dtim_period = vif->bss_conf.dtim_period;
+	bss_info.enable = en;
+	bss_info.feature = BIT(BSS_INFO_BASIC);
+	if (en) {
+		bss_info.feature |= BIT(BSS_INFO_OMAC);
+		if (mvif->omac_idx > EXT_BSSID_START)
+			bss_info.feature |= BIT(BSS_INFO_EXT_BSS);
+	}
+
+	return __mt7615_mcu_set_bss_info(dev, &bss_info);
+}
+
+static int __mt7615_mcu_set_wtbl(struct mt7615_dev *dev, int wlan_idx,
+				 int operation, void *buf, int buf_len)
+{
+	struct req_hdr {
+		u8 wlan_idx;
+		u8 operation;
+		__le16 tlv_num;
+		u8 rsv[4];
+	} __packed req_hdr = {0};
+	struct tlv {
+		__le16 tag;
+		__le16 len;
+		u8 buf[0];
+	} __packed;
+	struct sk_buff *skb;
+	u16 tlv_num = 0;
+	int offset = 0;
+
+	while (offset < buf_len) {
+		struct tlv *tlv = (struct tlv *)((u8 *)buf + offset);
+
+		tlv_num++;
+		offset += tlv->len;
+	}
+
+	skb = mt7615_mcu_msg_alloc(NULL, sizeof(req_hdr) + buf_len);
+
+	req_hdr.wlan_idx = wlan_idx;
+	req_hdr.operation = operation;
+	req_hdr.tlv_num = cpu_to_le16(tlv_num);
+
+	memcpy(skb_put(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
+
+	if (buf && buf_len)
+		memcpy(skb_put(skb, buf_len), buf, buf_len);
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_WTBL_UPDATE,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+static enum mt7615_cipher_type
+mt7615_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
+{
+	if (!key || key->keylen > 32)
+		return MT_CIPHER_NONE;
+
+	memcpy(key_data, key->key, key->keylen);
+
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		return MT_CIPHER_WEP40;
+	case WLAN_CIPHER_SUITE_WEP104:
+		return MT_CIPHER_WEP104;
+	case WLAN_CIPHER_SUITE_TKIP:
+		/* Rx/Tx MIC keys are swapped */
+		memcpy(key_data + 16, key->key + 24, 8);
+		memcpy(key_data + 24, key->key + 16, 8);
+		return MT_CIPHER_TKIP;
+	case WLAN_CIPHER_SUITE_CCMP:
+		return MT_CIPHER_AES_CCMP;
+	case WLAN_CIPHER_SUITE_CCMP_256:
+		return MT_CIPHER_CCMP_256;
+	case WLAN_CIPHER_SUITE_GCMP:
+		return MT_CIPHER_GCMP;
+	case WLAN_CIPHER_SUITE_GCMP_256:
+		return MT_CIPHER_GCMP_256;
+	case WLAN_CIPHER_SUITE_SMS4:
+		return MT_CIPHER_WAPI;
+	default:
+		return MT_CIPHER_NONE;
+	}
+}
+
+int mt7615_mcu_set_wtbl_key(struct mt7615_dev *dev, int wcid,
+			    struct ieee80211_key_conf *key,
+			    enum set_key_cmd cmd)
+{
+	struct wtbl_sec_key wtbl_sec_key = {0};
+	int buf_len = sizeof(struct wtbl_sec_key);
+	u8 cipher;
+
+	wtbl_sec_key.tag = cpu_to_le16(WTBL_SEC_KEY);
+	wtbl_sec_key.len = cpu_to_le16(buf_len);
+	wtbl_sec_key.add = cmd;
+
+	if (cmd == SET_KEY) {
+		cipher = mt7615_get_key_info(key, wtbl_sec_key.key_material);
+		if (cipher == MT_CIPHER_NONE && key)
+			return -EOPNOTSUPP;
+
+		wtbl_sec_key.cipher_id = cipher;
+		wtbl_sec_key.key_id = key->keyidx;
+		wtbl_sec_key.key_len = key->keylen;
+	} else {
+		wtbl_sec_key.key_len = sizeof(wtbl_sec_key.key_material);
+	}
+
+	return __mt7615_mcu_set_wtbl(dev, wcid, WTBL_SET, &wtbl_sec_key,
+				     buf_len);
+}
+
+int mt7615_mcu_add_wtbl_bmc(struct mt7615_dev *dev, struct ieee80211_vif *vif)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct wtbl_generic *wtbl_generic;
+	struct wtbl_rx *wtbl_rx;
+	int buf_len, ret;
+	u8 *buf;
+
+	buf = kzalloc(MT7615_WTBL_UPDATE_MAX_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	wtbl_generic = (struct wtbl_generic *)buf;
+	buf_len = sizeof(*wtbl_generic);
+	wtbl_generic->tag = cpu_to_le16(WTBL_GENERIC);
+	wtbl_generic->len = cpu_to_le16(buf_len);
+	eth_broadcast_addr(wtbl_generic->peer_addr);
+	wtbl_generic->muar_idx = 0xe;
+
+	wtbl_rx = (struct wtbl_rx *)(buf + buf_len);
+	buf_len += sizeof(*wtbl_rx);
+	wtbl_rx->tag = cpu_to_le16(WTBL_RX);
+	wtbl_rx->len = cpu_to_le16(sizeof(*wtbl_rx));
+	wtbl_rx->rca1 = 1;
+	wtbl_rx->rca2 = 1;
+	wtbl_rx->rv = 1;
+
+	ret = __mt7615_mcu_set_wtbl(dev, mvif->sta.wcid.idx,
+				    WTBL_RESET_AND_SET, buf, buf_len);
+
+	kfree(buf);
+	return ret;
+}
+
+int mt7615_mcu_del_wtbl_bmc(struct mt7615_dev *dev, struct ieee80211_vif *vif)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+
+	return __mt7615_mcu_set_wtbl(dev, mvif->sta.wcid.idx,
+				     WTBL_RESET_AND_SET, NULL, 0);
+}
+
+int mt7615_mcu_add_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct wtbl_generic *wtbl_generic;
+	struct wtbl_rx *wtbl_rx;
+	int buf_len, ret;
+	u8 *buf;
+
+	buf = kzalloc(MT7615_WTBL_UPDATE_MAX_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	wtbl_generic = (struct wtbl_generic *)buf;
+	buf_len = sizeof(*wtbl_generic);
+	wtbl_generic->tag = cpu_to_le16(WTBL_GENERIC);
+	wtbl_generic->len = cpu_to_le16(buf_len);
+	memcpy(wtbl_generic->peer_addr, sta->addr, ETH_ALEN);
+	wtbl_generic->muar_idx = mvif->omac_idx;
+	wtbl_generic->qos = sta->wme;
+	wtbl_generic->partial_aid = cpu_to_le16(sta->aid);
+
+	wtbl_rx = (struct wtbl_rx *)(buf + buf_len);
+	buf_len += sizeof(*wtbl_rx);
+	wtbl_rx->tag = cpu_to_le16(WTBL_RX);
+	wtbl_rx->len = cpu_to_le16(sizeof(*wtbl_rx));
+	wtbl_rx->rca1 = (vif->type == NL80211_IFTYPE_AP) ? 0 : 1;
+	wtbl_rx->rca2 = 1;
+	wtbl_rx->rv = 1;
+
+	ret = __mt7615_mcu_set_wtbl(dev, msta->wcid.idx,
+				    WTBL_RESET_AND_SET, buf, buf_len);
+
+	kfree(buf);
+	return ret;
+}
+
+int mt7615_mcu_del_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta)
+{
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+
+	return __mt7615_mcu_set_wtbl(dev, msta->wcid.idx,
+				     WTBL_RESET_AND_SET, NULL, 0);
+}
+
+int mt7615_mcu_del_wtbl_all(struct mt7615_dev *dev)
+{
+	return __mt7615_mcu_set_wtbl(dev, 0, WTBL_RESET_ALL, NULL, 0);
+}
+
+static int __mt7615_mcu_set_sta_rec(struct mt7615_dev *dev, int bss_idx,
+				    int wlan_idx, int muar_idx, void *buf,
+				    int buf_len)
+{
+	struct req_hdr {
+		u8 bss_idx;
+		u8 wlan_idx;
+		__le16 tlv_num;
+		u8 is_tlv_append;
+		u8 muar_idx;
+		u8 rsv[2];
+	} __packed req_hdr = {0};
+	struct tlv {
+		__le16 tag;
+		__le16 len;
+		u8 buf[0];
+	} __packed;
+	struct sk_buff *skb;
+	u16 tlv_num = 0;
+	int offset = 0;
+
+	while (offset < buf_len) {
+		struct tlv *tlv = (struct tlv *)((u8 *)buf + offset);
+
+		tlv_num++;
+		offset += tlv->len;
+	}
+
+	skb = mt7615_mcu_msg_alloc(NULL, sizeof(req_hdr) + buf_len);
+
+	req_hdr.bss_idx = bss_idx;
+	req_hdr.wlan_idx = wlan_idx;
+	req_hdr.tlv_num = cpu_to_le16(tlv_num);
+	req_hdr.is_tlv_append = tlv_num ? 1 : 0;
+	req_hdr.muar_idx = muar_idx;
+
+	memcpy(skb_put(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
+
+	if (buf && buf_len)
+		memcpy(skb_put(skb, buf_len), buf, buf_len);
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_STA_REC_UPDATE,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_set_sta_rec_bmc(struct mt7615_dev *dev,
+			       struct ieee80211_vif *vif, bool en)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct sta_rec_basic sta_rec_basic = {0};
+	int buf_len = sizeof(struct sta_rec_basic);
+
+	sta_rec_basic.tag = cpu_to_le16(STA_REC_BASIC);
+	sta_rec_basic.len = cpu_to_le16(buf_len);
+	sta_rec_basic.conn_type = cpu_to_le32(CONNECTION_INFRA_BC);
+	eth_broadcast_addr(sta_rec_basic.peer_addr);
+	if (en) {
+		sta_rec_basic.conn_state = CONN_STATE_PORT_SECURE;
+		sta_rec_basic.extra_info =
+			cpu_to_le16(EXTRA_INFO_VER | EXTRA_INFO_NEW);
+	} else {
+		sta_rec_basic.conn_state = CONN_STATE_DISCONNECT;
+		sta_rec_basic.extra_info = cpu_to_le16(EXTRA_INFO_VER);
+	}
+
+	return __mt7615_mcu_set_sta_rec(dev, mvif->idx, mvif->sta.wcid.idx,
+					mvif->omac_idx, &sta_rec_basic,
+					buf_len);
+}
+
+static void sta_rec_convert_vif_type(enum nl80211_iftype type, u32 *conn_type)
+{
+	switch (type) {
+	case NL80211_IFTYPE_AP:
+		if (conn_type)
+			*conn_type = CONNECTION_INFRA_STA;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (conn_type)
+			*conn_type = CONNECTION_INFRA_AP;
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	};
+}
+
+int mt7615_mcu_set_sta_rec(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta, bool en)
+{
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct sta_rec_basic sta_rec_basic = {0};
+	int buf_len = sizeof(struct sta_rec_basic);
+	u32 conn_type = 0;
+
+	sta_rec_convert_vif_type(vif->type, &conn_type);
+
+	sta_rec_basic.tag = cpu_to_le16(STA_REC_BASIC);
+	sta_rec_basic.len = cpu_to_le16(buf_len);
+	sta_rec_basic.conn_type = cpu_to_le32(conn_type);
+	sta_rec_basic.qos = sta->wme;
+	sta_rec_basic.aid = cpu_to_le16(sta->aid);
+	memcpy(sta_rec_basic.peer_addr, sta->addr, ETH_ALEN);
+
+	if (en) {
+		sta_rec_basic.conn_state = CONN_STATE_PORT_SECURE;
+		sta_rec_basic.extra_info =
+			cpu_to_le16(EXTRA_INFO_VER | EXTRA_INFO_NEW);
+	} else {
+		sta_rec_basic.conn_state = CONN_STATE_DISCONNECT;
+		sta_rec_basic.extra_info = cpu_to_le16(EXTRA_INFO_VER);
+	}
+
+	return __mt7615_mcu_set_sta_rec(dev, mvif->idx, msta->wcid.idx,
+					mvif->omac_idx, &sta_rec_basic,
+					buf_len);
+}
+
+int mt7615_mcu_set_bcn(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+		       int en)
+{
+	struct req {
+		u8 omac_idx;
+		u8 enable;
+		u8 wlan_idx;
+		u8 band_idx;
+		u8 pkt_type;
+		u8 need_pre_tbtt_int;
+		__le16 csa_ie_pos;
+		__le16 pkt_len;
+		__le16 tim_ie_pos;
+		u8 pkt[512];
+		u8 csa_cnt;
+		/* bss color change */
+		u8 bcc_cnt;
+		__le16 bcc_ie_pos;
+	} __packed req = {0};
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct mt76_wcid *wcid = &dev->mt76.global_wcid;
+	struct sk_buff *skb;
+	u16 tim_off, tim_len;
+
+	skb = ieee80211_beacon_get_tim(mt76_hw(dev), vif, &tim_off, &tim_len);
+
+	if (!skb)
+		return -EINVAL;
+
+	if (skb->len > 512 - MT_TXD_SIZE) {
+		dev_err(dev->mt76.dev, "Bcn size limit exceed\n");
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	mt7615_mac_write_txwi(dev, (__le32 *)(req.pkt), skb, wcid, NULL,
+			      0, NULL);
+	memcpy(req.pkt + MT_TXD_SIZE, skb->data, skb->len);
+	dev_kfree_skb(skb);
+
+	req.omac_idx = mvif->omac_idx;
+	req.enable = en;
+	req.wlan_idx = wcid->idx;
+	req.band_idx = mvif->band_idx;
+	/* pky_type: 0 for bcn, 1 for tim */
+	req.pkt_type = 0;
+	req.pkt_len = cpu_to_le16(MT_TXD_SIZE + skb->len);
+	req.tim_ie_pos = cpu_to_le16(MT_TXD_SIZE + tim_off);
+
+	skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_BCN_OFFLOAD,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_set_channel(struct mt7615_dev *dev)
+{
+	struct cfg80211_chan_def *chdef = &dev->mt76.chandef;
+	struct {
+		u8 control_chan;
+		u8 center_chan;
+		u8 bw;
+		u8 tx_streams;
+		u8 rx_streams_mask;
+		u8 switch_reason;
+		u8 band_idx;
+		/* for 80+80 only */
+		u8 center_chan2;
+		__le16 cac_case;
+		u8 channel_band;
+		u8 rsv0;
+		__le32 outband_freq;
+		u8 txpower_drop;
+		u8 rsv1[3];
+		u8 txpower_sku[53];
+		u8 rsv2[3];
+	} req = {0};
+	struct sk_buff *skb;
+	int ret;
+
+	req.control_chan = chdef->chan->hw_value;
+	req.center_chan = ieee80211_frequency_to_channel(chdef->center_freq1);
+	req.tx_streams = (dev->mt76.chainmask >> 8) & 0xf;
+	req.rx_streams_mask = dev->mt76.antenna_mask;
+	req.switch_reason = CH_SWITCH_NORMAL;
+	req.band_idx = 0;
+	req.center_chan2 = ieee80211_frequency_to_channel(chdef->center_freq2);
+	req.txpower_drop = 0;
+
+	switch (dev->mt76.chandef.width) {
+	case NL80211_CHAN_WIDTH_40:
+		req.bw = CMD_CBW_40MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+		req.bw = CMD_CBW_80MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_80P80:
+		req.bw = CMD_CBW_8080MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_160:
+		req.bw = CMD_CBW_160MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_5:
+		req.bw = CMD_CBW_5MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		req.bw = CMD_CBW_10MHZ;
+		break;
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+	default:
+		req.bw = CMD_CBW_20MHZ;
+	}
+
+	memset(req.txpower_sku, 0x3f, 49);
+
+	skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+	ret = mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_CHANNEL_SWITCH,
+				  MCU_Q_SET, MCU_S2D_H2N, NULL);
+	if (ret)
+		return ret;
+
+	skb = mt7615_mcu_msg_alloc(&req, sizeof(req));
+	return mt7615_mcu_msg_send(dev, skb, MCU_EXT_CMD_SET_RX_PATH,
+				   MCU_Q_SET, MCU_S2D_H2N, NULL);
+}
+
+int mt7615_mcu_set_ht_cap(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta)
+{
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct mt7615_vif *mvif = (struct mt7615_vif *)vif->drv_priv;
+	struct wtbl_ht *wtbl_ht;
+	struct wtbl_raw *wtbl_raw;
+	struct sta_rec_ht *sta_rec_ht;
+	int buf_len, ret;
+	u32 msk, val = 0;
+	u8 *buf;
+
+	buf = kzalloc(MT7615_WTBL_UPDATE_MAX_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	/* ht basic */
+	buf_len = sizeof(*wtbl_ht);
+	wtbl_ht = (struct wtbl_ht *)buf;
+	wtbl_ht->tag = cpu_to_le16(WTBL_HT);
+	wtbl_ht->len = cpu_to_le16(sizeof(*wtbl_ht));
+	wtbl_ht->ht = 1;
+	wtbl_ht->ldpc = sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING;
+	wtbl_ht->af = sta->ht_cap.ampdu_factor;
+	wtbl_ht->mm = sta->ht_cap.ampdu_density;
+
+	if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
+		val |= MT_WTBL_W5_SHORT_GI_20;
+	if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
+		val |= MT_WTBL_W5_SHORT_GI_40;
+
+	/* vht basic */
+	if (sta->vht_cap.vht_supported) {
+		struct wtbl_vht *wtbl_vht;
+
+		wtbl_vht = (struct wtbl_vht *)(buf + buf_len);
+		buf_len += sizeof(*wtbl_vht);
+		wtbl_vht->tag = cpu_to_le16(WTBL_VHT);
+		wtbl_vht->len = cpu_to_le16(sizeof(*wtbl_vht));
+		wtbl_vht->ldpc = sta->vht_cap.cap & IEEE80211_VHT_CAP_RXLDPC;
+		wtbl_vht->vht = 1;
+
+		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_80)
+			val |= MT_WTBL_W5_SHORT_GI_80;
+		if (sta->vht_cap.cap & IEEE80211_VHT_CAP_SHORT_GI_160)
+			val |= MT_WTBL_W5_SHORT_GI_160;
+	}
+
+	/* smps */
+	if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC) {
+		struct wtbl_smps *wtbl_smps;
+
+		wtbl_smps = (struct wtbl_smps *)(buf + buf_len);
+		buf_len += sizeof(*wtbl_smps);
+		wtbl_smps->tag = cpu_to_le16(WTBL_SMPS);
+		wtbl_smps->len = cpu_to_le16(sizeof(*wtbl_smps));
+		wtbl_smps->smps = 1;
+	}
+
+	/* sgi */
+	msk = MT_WTBL_W5_SHORT_GI_20 | MT_WTBL_W5_SHORT_GI_40 |
+	      MT_WTBL_W5_SHORT_GI_80 | MT_WTBL_W5_SHORT_GI_160;
+
+	wtbl_raw = (struct wtbl_raw *)(buf + buf_len);
+	buf_len += sizeof(*wtbl_raw);
+	wtbl_raw->tag = cpu_to_le16(WTBL_RAW_DATA);
+	wtbl_raw->len = cpu_to_le16(sizeof(*wtbl_raw));
+	wtbl_raw->wtbl_idx = 1;
+	wtbl_raw->dw = 5;
+	wtbl_raw->msk = cpu_to_le32(~msk);
+	wtbl_raw->val = cpu_to_le32(val);
+
+	ret = __mt7615_mcu_set_wtbl(dev, msta->wcid.idx, WTBL_SET, buf,
+				    buf_len);
+	if (ret) {
+		kfree(buf);
+		return ret;
+	}
+
+	memset(buf, 0, MT7615_WTBL_UPDATE_MAX_SIZE);
+
+	buf_len = sizeof(*sta_rec_ht);
+	sta_rec_ht = (struct sta_rec_ht *)buf;
+	sta_rec_ht->tag = cpu_to_le16(STA_REC_HT);
+	sta_rec_ht->len = cpu_to_le16(sizeof(*sta_rec_ht));
+	sta_rec_ht->ht_cap = cpu_to_le16(sta->ht_cap.cap);
+
+	if (sta->vht_cap.vht_supported) {
+		struct sta_rec_vht *sta_rec_vht;
+
+		sta_rec_vht = (struct sta_rec_vht *)(buf + buf_len);
+		buf_len += sizeof(*sta_rec_vht);
+		sta_rec_vht->tag = cpu_to_le16(STA_REC_VHT);
+		sta_rec_vht->len = cpu_to_le16(sizeof(*sta_rec_vht));
+		sta_rec_vht->vht_cap = cpu_to_le32(sta->vht_cap.cap);
+		sta_rec_vht->vht_rx_mcs_map =
+			cpu_to_le16(sta->vht_cap.vht_mcs.rx_mcs_map);
+		sta_rec_vht->vht_tx_mcs_map =
+			cpu_to_le16(sta->vht_cap.vht_mcs.tx_mcs_map);
+	}
+
+	ret = __mt7615_mcu_set_sta_rec(dev, mvif->idx, msta->wcid.idx,
+				       mvif->omac_idx, buf, buf_len);
+	kfree(buf);
+	return ret;
+}
+
+int mt7615_mcu_set_tx_ba(struct mt7615_dev *dev,
+			 struct ieee80211_ampdu_params *params,
+			 bool add)
+{
+	struct ieee80211_sta *sta = params->sta;
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct mt7615_vif *mvif = msta->vif;
+	u8 ba_range[8] = {4, 8, 12, 24, 36, 48, 54, 64};
+	u16 tid = params->tid;
+	u16 ba_size = params->buf_size;
+	u16 ssn = params->ssn;
+	struct wtbl_ba wtbl_ba = {0};
+	struct sta_rec_ba sta_rec_ba = {0};
+	int ret, buf_len;
+
+	buf_len = sizeof(struct wtbl_ba);
+
+	wtbl_ba.tag = cpu_to_le16(WTBL_BA);
+	wtbl_ba.len = cpu_to_le16(buf_len);
+	wtbl_ba.tid = tid;
+	wtbl_ba.ba_type = MT_BA_TYPE_ORIGINATOR;
+
+	if (add) {
+		u8 idx;
+
+		for (idx = 7; idx > 0; idx--) {
+			if (ba_size >= ba_range[idx])
+				break;
+		}
+
+		wtbl_ba.sn = cpu_to_le16(ssn);
+		wtbl_ba.ba_en = 1;
+		wtbl_ba.ba_winsize_idx = idx;
+	}
+
+	ret = __mt7615_mcu_set_wtbl(dev, msta->wcid.idx, WTBL_SET, &wtbl_ba,
+				    buf_len);
+	if (ret)
+		return ret;
+
+	buf_len = sizeof(struct sta_rec_ba);
+
+	sta_rec_ba.tag = cpu_to_le16(STA_REC_BA);
+	sta_rec_ba.len = cpu_to_le16(buf_len);
+	sta_rec_ba.tid = tid;
+	sta_rec_ba.ba_type = MT_BA_TYPE_ORIGINATOR;
+	sta_rec_ba.amsdu = params->amsdu;
+	sta_rec_ba.ba_en = add << tid;
+	sta_rec_ba.ssn = cpu_to_le16(ssn);
+	sta_rec_ba.winsize = cpu_to_le16(ba_size);
+
+	return __mt7615_mcu_set_sta_rec(dev, mvif->idx, msta->wcid.idx,
+					mvif->omac_idx, &sta_rec_ba, buf_len);
+}
+
+int mt7615_mcu_set_rx_ba(struct mt7615_dev *dev,
+			 struct ieee80211_ampdu_params *params,
+			 bool add)
+{
+	struct ieee80211_sta *sta = params->sta;
+	struct mt7615_sta *msta = (struct mt7615_sta *)sta->drv_priv;
+	struct mt7615_vif *mvif = msta->vif;
+	u16 tid = params->tid;
+	struct wtbl_ba wtbl_ba = {0};
+	struct sta_rec_ba sta_rec_ba = {0};
+	int ret, buf_len;
+
+	buf_len = sizeof(struct sta_rec_ba);
+
+	sta_rec_ba.tag = cpu_to_le16(STA_REC_BA);
+	sta_rec_ba.len = cpu_to_le16(buf_len);
+	sta_rec_ba.tid = tid;
+	sta_rec_ba.ba_type = MT_BA_TYPE_RECIPIENT;
+	sta_rec_ba.amsdu = params->amsdu;
+	sta_rec_ba.ba_en = add << tid;
+	sta_rec_ba.ssn = cpu_to_le16(params->ssn);
+	sta_rec_ba.winsize = cpu_to_le16(params->buf_size);
+
+	ret = __mt7615_mcu_set_sta_rec(dev, mvif->idx, msta->wcid.idx,
+				       mvif->omac_idx, &sta_rec_ba, buf_len);
+	if (ret || !add)
+		return ret;
+
+	buf_len = sizeof(struct wtbl_ba);
+
+	wtbl_ba.tag = cpu_to_le16(WTBL_BA);
+	wtbl_ba.len = cpu_to_le16(buf_len);
+	wtbl_ba.tid = tid;
+	wtbl_ba.ba_type = MT_BA_TYPE_RECIPIENT;
+	memcpy(wtbl_ba.peer_addr, sta->addr, ETH_ALEN);
+	wtbl_ba.rst_ba_tid = tid;
+	wtbl_ba.rst_ba_sel = RST_BA_MAC_TID_MATCH;
+	wtbl_ba.rst_ba_sb = 1;
+
+	return  __mt7615_mcu_set_wtbl(dev, msta->wcid.idx, WTBL_SET,
+				      &wtbl_ba, buf_len);
+}
+
+void mt7615_mcu_set_rates(struct mt7615_dev *dev, struct mt7615_sta *sta,
+			  struct ieee80211_tx_rate *probe_rate,
+			  struct ieee80211_tx_rate *rates)
+{
+	int wcid = sta->wcid.idx;
+	u32 addr = MT_WTBL_BASE + wcid * MT_WTBL_ENTRY_SIZE;
+	bool stbc = false;
+	int n_rates = sta->n_rates;
+	u8 bw, bw_prev, bw_idx = 0;
+	u16 val[4];
+	u16 probe_val;
+	u32 w5, w27;
+	int i;
+
+	if (!mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000))
+		return;
+
+	for (i = n_rates; i < 4; i++)
+		rates[i] = rates[n_rates - 1];
+
+	val[0] = mt7615_mac_tx_rate_val(dev, &rates[0], stbc, &bw);
+	bw_prev = bw;
+
+	if (probe_rate) {
+		probe_val = mt7615_mac_tx_rate_val(dev, probe_rate, stbc, &bw);
+		if (bw)
+			bw_idx = 1;
+		else
+			bw_prev = 0;
+	} else {
+		probe_val = val[0];
+	}
+
+	val[1] = mt7615_mac_tx_rate_val(dev, &rates[1], stbc, &bw);
+	if (bw_prev) {
+		bw_idx = 3;
+		bw_prev = bw;
+	}
+
+	val[2] = mt7615_mac_tx_rate_val(dev, &rates[2], stbc, &bw);
+	if (bw_prev) {
+		bw_idx = 5;
+		bw_prev = bw;
+	}
+
+	val[3] = mt7615_mac_tx_rate_val(dev, &rates[3], stbc, &bw);
+	if (bw_prev)
+		bw_idx = 7;
+
+	w27 = mt76_rr(dev, addr + 27 * 4);
+	w27 &= ~MT_WTBL_W27_CC_BW_SEL;
+	w27 |= FIELD_PREP(MT_WTBL_W27_CC_BW_SEL, bw);
+
+	w5 = mt76_rr(dev, addr + 5 * 4);
+	w5 &= ~(MT_WTBL_W5_BW_CAP | MT_WTBL_W5_CHANGE_BW_RATE);
+	w5 |= FIELD_PREP(MT_WTBL_W5_BW_CAP, bw) |
+	      FIELD_PREP(MT_WTBL_W5_CHANGE_BW_RATE, bw_idx ? bw_idx - 1 : 7);
+
+	mt76_wr(dev, MT_WTBL_RIUCR0, w5);
+
+	mt76_wr(dev, MT_WTBL_RIUCR1,
+		FIELD_PREP(MT_WTBL_RIUCR1_RATE0, probe_val) |
+		FIELD_PREP(MT_WTBL_RIUCR1_RATE1, val[0]) |
+		FIELD_PREP(MT_WTBL_RIUCR1_RATE2_LO, val[0]));
+
+	mt76_wr(dev, MT_WTBL_RIUCR2,
+		FIELD_PREP(MT_WTBL_RIUCR2_RATE2_HI, val[0] >> 8) |
+		FIELD_PREP(MT_WTBL_RIUCR2_RATE3, val[1]) |
+		FIELD_PREP(MT_WTBL_RIUCR2_RATE4, val[1]) |
+		FIELD_PREP(MT_WTBL_RIUCR2_RATE5_LO, val[2]));
+
+	mt76_wr(dev, MT_WTBL_RIUCR3,
+		FIELD_PREP(MT_WTBL_RIUCR3_RATE5_HI, val[2] >> 4) |
+		FIELD_PREP(MT_WTBL_RIUCR3_RATE6, val[2]) |
+		FIELD_PREP(MT_WTBL_RIUCR3_RATE7, val[3]));
+
+	mt76_wr(dev, MT_WTBL_UPDATE,
+		FIELD_PREP(MT_WTBL_UPDATE_WLAN_IDX, wcid) |
+		MT_WTBL_UPDATE_RATE_UPDATE |
+		MT_WTBL_UPDATE_TX_COUNT_CLEAR);
+
+	mt76_wr(dev, addr + 27 * 4, w27);
+
+	if (!(sta->wcid.tx_info & MT_WCID_TX_INFO_SET))
+		mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
+
+	sta->rate_count = 2 * MT7615_RATE_RETRY * n_rates;
+	sta->wcid.tx_info |= MT_WCID_TX_INFO_SET;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
new file mode 100644
index 0000000..9455f8f
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.h
@@ -0,0 +1,520 @@
+/* SPDX-License-Identifier: ISC */
+/* Copyright (C) 2019 MediaTek Inc. */
+
+#ifndef __MT7615_MCU_H
+#define __MT7615_MCU_H
+
+struct mt7615_mcu_txd {
+	__le32 txd[8];
+
+	__le16 len;
+	__le16 pq_id;
+
+	u8 cid;
+	u8 pkt_type;
+	u8 set_query; /* FW don't care */
+	u8 seq;
+
+	u8 uc_d2b0_rev;
+	u8 ext_cid;
+	u8 s2d_index;
+	u8 ext_cid_ack;
+
+	u32 reserved[5];
+} __packed __aligned(4);
+
+struct mt7615_mcu_rxd {
+	__le32 rxd[4];
+
+	__le16 len;
+	__le16 pkt_type_id;
+
+	u8 eid;
+	u8 seq;
+	__le16 __rsv;
+
+	u8 ext_eid;
+	u8 __rsv1[2];
+	u8 s2d_index;
+};
+
+#define MCU_PQ_ID(p, q)		(((p) << 15) | ((q) << 10))
+#define MCU_PKT_ID		0xa0
+
+enum {
+	MCU_Q_QUERY,
+	MCU_Q_SET,
+	MCU_Q_RESERVED,
+	MCU_Q_NA
+};
+
+enum {
+	MCU_S2D_H2N,
+	MCU_S2D_C2N,
+	MCU_S2D_H2C,
+	MCU_S2D_H2CN
+};
+
+enum {
+	MCU_CMD_TARGET_ADDRESS_LEN_REQ = 0x01,
+	MCU_CMD_FW_START_REQ = 0x02,
+	MCU_CMD_INIT_ACCESS_REG = 0x3,
+	MCU_CMD_PATCH_START_REQ = 0x05,
+	MCU_CMD_PATCH_FINISH_REQ = 0x07,
+	MCU_CMD_PATCH_SEM_CONTROL = 0x10,
+	MCU_CMD_EXT_CID = 0xED,
+	MCU_CMD_FW_SCATTER = 0xEE,
+	MCU_CMD_RESTART_DL_REQ = 0xEF,
+};
+
+enum {
+	MCU_EXT_CMD_PM_STATE_CTRL = 0x07,
+	MCU_EXT_CMD_CHANNEL_SWITCH = 0x08,
+	MCU_EXT_CMD_EFUSE_BUFFER_MODE = 0x21,
+	MCU_EXT_CMD_STA_REC_UPDATE = 0x25,
+	MCU_EXT_CMD_BSS_INFO_UPDATE = 0x26,
+	MCU_EXT_CMD_EDCA_UPDATE = 0x27,
+	MCU_EXT_CMD_DEV_INFO_UPDATE = 0x2A,
+	MCU_EXT_CMD_WTBL_UPDATE = 0x32,
+	MCU_EXT_CMD_PROTECT_CTRL = 0x3e,
+	MCU_EXT_CMD_MAC_INIT_CTRL = 0x46,
+	MCU_EXT_CMD_BCN_OFFLOAD = 0x49,
+	MCU_EXT_CMD_SET_RX_PATH = 0x4e,
+};
+
+enum {
+	PATCH_SEM_RELEASE = 0x0,
+	PATCH_SEM_GET	  = 0x1
+};
+
+enum {
+	PATCH_NOT_DL_SEM_FAIL	 = 0x0,
+	PATCH_IS_DL		 = 0x1,
+	PATCH_NOT_DL_SEM_SUCCESS = 0x2,
+	PATCH_REL_SEM_SUCCESS	 = 0x3
+};
+
+enum {
+	FW_STATE_INITIAL          = 0,
+	FW_STATE_FW_DOWNLOAD      = 1,
+	FW_STATE_NORMAL_OPERATION = 2,
+	FW_STATE_NORMAL_TRX       = 3,
+	FW_STATE_CR4_RDY          = 7
+};
+
+#define STA_TYPE_STA		BIT(0)
+#define STA_TYPE_AP		BIT(1)
+#define STA_TYPE_ADHOC		BIT(2)
+#define STA_TYPE_TDLS		BIT(3)
+#define STA_TYPE_WDS		BIT(4)
+#define STA_TYPE_BC		BIT(5)
+
+#define NETWORK_INFRA		BIT(16)
+#define NETWORK_P2P		BIT(17)
+#define NETWORK_IBSS		BIT(18)
+#define NETWORK_MESH		BIT(19)
+#define NETWORK_BOW		BIT(20)
+#define NETWORK_WDS		BIT(21)
+
+#define CONNECTION_INFRA_STA	(STA_TYPE_STA | NETWORK_INFRA)
+#define CONNECTION_INFRA_AP	(STA_TYPE_AP | NETWORK_INFRA)
+#define CONNECTION_P2P_GC	(STA_TYPE_STA | NETWORK_P2P)
+#define CONNECTION_P2P_GO	(STA_TYPE_AP | NETWORK_P2P)
+#define CONNECTION_MESH_STA	(STA_TYPE_STA | NETWORK_MESH)
+#define CONNECTION_MESH_AP	(STA_TYPE_AP | NETWORK_MESH)
+#define CONNECTION_IBSS_ADHOC	(STA_TYPE_ADHOC | NETWORK_IBSS)
+#define CONNECTION_TDLS		(STA_TYPE_STA | NETWORK_INFRA | STA_TYPE_TDLS)
+#define CONNECTION_WDS		(STA_TYPE_WDS | NETWORK_WDS)
+#define CONNECTION_INFRA_BC	(STA_TYPE_BC | NETWORK_INFRA)
+
+#define CONN_STATE_DISCONNECT	0
+#define CONN_STATE_CONNECT	1
+#define CONN_STATE_PORT_SECURE	2
+
+struct dev_info {
+	u8 omac_idx;
+	u8 omac_addr[ETH_ALEN];
+	u8 band_idx;
+	u8 enable;
+	u32 feature;
+};
+
+enum {
+	DEV_INFO_ACTIVE,
+	DEV_INFO_MAX_NUM
+};
+
+struct bss_info {
+	u8 bss_idx;
+	u8 bssid[ETH_ALEN];
+	u8 omac_idx;
+	u8 band_idx;
+	u8 bmc_tx_wlan_idx; /* for bmc tx (sta mode use uc entry) */
+	u8 wmm_idx;
+	u32 network_type;
+	u32 conn_type;
+	u16 bcn_interval;
+	u8 dtim_period;
+	u8 enable;
+	u32 feature;
+};
+
+struct bss_info_tag_handler {
+	u32 tag;
+	u32 len;
+	void (*handler)(struct mt7615_dev *dev,
+			struct bss_info *bss_info, struct sk_buff *skb);
+};
+
+struct bss_info_omac {
+	__le16 tag;
+	__le16 len;
+	u8 hw_bss_idx;
+	u8 omac_idx;
+	u8 band_idx;
+	u8 rsv0;
+	__le32 conn_type;
+	u32 rsv1;
+} __packed;
+
+struct bss_info_basic {
+	__le16 tag;
+	__le16 len;
+	__le32 network_type;
+	u8 active;
+	u8 rsv0;
+	__le16 bcn_interval;
+	u8 bssid[ETH_ALEN];
+	u8 wmm_idx;
+	u8 dtim_period;
+	u8 bmc_tx_wlan_idx;
+	u8 cipher; /* not used */
+	u8 phymode; /* not used */
+	u8 rsv1[5];
+} __packed;
+
+struct bss_info_rf_ch {
+	__le16 tag;
+	__le16 len;
+	u8 pri_ch;
+	u8 central_ch0;
+	u8 central_ch1;
+	u8 bw;
+} __packed;
+
+struct bss_info_ext_bss {
+	__le16 tag;
+	__le16 len;
+	__le32 mbss_tsf_offset; /* in unit of us */
+	u8 rsv[8];
+} __packed;
+
+enum {
+	BSS_INFO_OMAC,
+	BSS_INFO_BASIC,
+	BSS_INFO_RF_CH, /* optional, for BT/LTE coex */
+	BSS_INFO_PM, /* sta only */
+	BSS_INFO_UAPSD, /* sta only */
+	BSS_INFO_ROAM_DETECTION, /* obsoleted */
+	BSS_INFO_LQ_RM, /* obsoleted */
+	BSS_INFO_EXT_BSS,
+	BSS_INFO_BMC_INFO, /* for bmc rate control in CR4 */
+	BSS_INFO_SYNC_MODE, /* obsoleted */
+	BSS_INFO_RA,
+	BSS_INFO_MAX_NUM
+};
+
+enum {
+	WTBL_RESET_AND_SET = 1,
+	WTBL_SET,
+	WTBL_QUERY,
+	WTBL_RESET_ALL
+};
+
+struct wtbl_generic {
+	__le16 tag;
+	__le16 len;
+	u8 peer_addr[ETH_ALEN];
+	u8 muar_idx;
+	u8 skip_tx;
+	u8 cf_ack;
+	u8 qos;
+	u8 mesh;
+	u8 adm;
+	__le16 partial_aid;
+	u8 baf_en;
+	u8 aad_om;
+} __packed;
+
+struct wtbl_rx {
+	__le16 tag;
+	__le16 len;
+	u8 rcid;
+	u8 rca1;
+	u8 rca2;
+	u8 rv;
+	u8 rsv[4];
+} __packed;
+
+struct wtbl_ht {
+	__le16 tag;
+	__le16 len;
+	u8 ht;
+	u8 ldpc;
+	u8 af;
+	u8 mm;
+	u8 rsv[4];
+} __packed;
+
+struct wtbl_vht {
+	__le16 tag;
+	__le16 len;
+	u8 ldpc;
+	u8 dyn_bw;
+	u8 vht;
+	u8 txop_ps;
+	u8 rsv[4];
+} __packed;
+
+struct wtbl_tx_ps {
+	__le16 tag;
+	__le16 len;
+	u8 txps;
+	u8 rsv[3];
+} __packed;
+
+struct wtbl_hdr_trans {
+	__le16 tag;
+	__le16 len;
+	u8 to_ds;
+	u8 from_ds;
+	u8 disable_rx_trans;
+	u8 rsv;
+} __packed;
+
+enum mt7615_cipher_type {
+	MT_CIPHER_NONE,
+	MT_CIPHER_WEP40,
+	MT_CIPHER_TKIP,
+	MT_CIPHER_TKIP_NO_MIC,
+	MT_CIPHER_AES_CCMP,
+	MT_CIPHER_WEP104,
+	MT_CIPHER_BIP_CMAC_128,
+	MT_CIPHER_WEP128,
+	MT_CIPHER_WAPI,
+	MT_CIPHER_CCMP_256 = 10,
+	MT_CIPHER_GCMP,
+	MT_CIPHER_GCMP_256,
+};
+
+struct wtbl_sec_key {
+	__le16 tag;
+	__le16 len;
+	u8 add; /* 0: add, 1: remove */
+	u8 rkv;
+	u8 ikv;
+	u8 cipher_id;
+	u8 key_id;
+	u8 key_len;
+	u8 rsv[2];
+	u8 key_material[32];
+} __packed;
+
+enum {
+	MT_BA_TYPE_INVALID,
+	MT_BA_TYPE_ORIGINATOR,
+	MT_BA_TYPE_RECIPIENT
+};
+
+enum {
+	RST_BA_MAC_TID_MATCH,
+	RST_BA_MAC_MATCH,
+	RST_BA_NO_MATCH
+};
+
+struct wtbl_ba {
+	__le16 tag;
+	__le16 len;
+	/* common */
+	u8 tid;
+	u8 ba_type;
+	u8 rsv0[2];
+	/* originator only */
+	__le16 sn;
+	u8 ba_en;
+	u8 ba_winsize_idx;
+	__le16 ba_winsize;
+	/* recipient only */
+	u8 peer_addr[ETH_ALEN];
+	u8 rst_ba_tid;
+	u8 rst_ba_sel;
+	u8 rst_ba_sb;
+	u8 band_idx;
+	u8 rsv1[4];
+} __packed;
+
+struct wtbl_bf {
+	__le16 tag;
+	__le16 len;
+	u8 ibf;
+	u8 ebf;
+	u8 ibf_vht;
+	u8 ebf_vht;
+	u8 gid;
+	u8 pfmu_idx;
+	u8 rsv[2];
+} __packed;
+
+struct wtbl_smps {
+	__le16 tag;
+	__le16 len;
+	u8 smps;
+	u8 rsv[3];
+} __packed;
+
+struct wtbl_pn {
+	__le16 tag;
+	__le16 len;
+	u8 pn[6];
+	u8 rsv[2];
+} __packed;
+
+struct wtbl_spe {
+	__le16 tag;
+	__le16 len;
+	u8 spe_idx;
+	u8 rsv[3];
+} __packed;
+
+struct wtbl_raw {
+	__le16 tag;
+	__le16 len;
+	u8 wtbl_idx;
+	u8 dw;
+	u8 rsv[2];
+	__le32 msk;
+	__le32 val;
+} __packed;
+
+#define MT7615_WTBL_UPDATE_MAX_SIZE (sizeof(struct wtbl_generic) + \
+				     sizeof(struct wtbl_rx) + \
+				     sizeof(struct wtbl_ht) + \
+				     sizeof(struct wtbl_vht) + \
+				     sizeof(struct wtbl_tx_ps) + \
+				     sizeof(struct wtbl_hdr_trans) + \
+				     sizeof(struct wtbl_sec_key) + \
+				     sizeof(struct wtbl_ba) + \
+				     sizeof(struct wtbl_bf) + \
+				     sizeof(struct wtbl_smps) + \
+				     sizeof(struct wtbl_pn) + \
+				     sizeof(struct wtbl_spe))
+
+enum {
+	WTBL_GENERIC,
+	WTBL_RX,
+	WTBL_HT,
+	WTBL_VHT,
+	WTBL_PEER_PS, /* not used */
+	WTBL_TX_PS,
+	WTBL_HDR_TRANS,
+	WTBL_SEC_KEY,
+	WTBL_BA,
+	WTBL_RDG, /* obsoleted */
+	WTBL_PROTECT, /* not used */
+	WTBL_CLEAR, /* not used */
+	WTBL_BF,
+	WTBL_SMPS,
+	WTBL_RAW_DATA, /* debug only */
+	WTBL_PN,
+	WTBL_SPE,
+	WTBL_MAX_NUM
+};
+
+struct sta_rec_basic {
+	__le16 tag;
+	__le16 len;
+	__le32 conn_type;
+	u8 conn_state;
+	u8 qos;
+	__le16 aid;
+	u8 peer_addr[ETH_ALEN];
+#define EXTRA_INFO_VER	BIT(0)
+#define EXTRA_INFO_NEW	BIT(1)
+	__le16 extra_info;
+} __packed;
+
+struct sta_rec_ht {
+	__le16 tag;
+	__le16 len;
+	__le16 ht_cap;
+	u16 rsv;
+} __packed;
+
+struct sta_rec_vht {
+	__le16 tag;
+	__le16 len;
+	__le32 vht_cap;
+	__le16 vht_rx_mcs_map;
+	__le16 vht_tx_mcs_map;
+} __packed;
+
+struct sta_rec_ba {
+	__le16 tag;
+	__le16 len;
+	u8 tid;
+	u8 ba_type;
+	u8 amsdu;
+	u8 ba_en;
+	__le16 ssn;
+	__le16 winsize;
+} __packed;
+
+#define MT7615_STA_REC_UPDATE_MAX_SIZE (sizeof(struct sta_rec_basic) + \
+					sizeof(struct sta_rec_ht) + \
+					sizeof(struct sta_rec_vht))
+
+enum {
+	STA_REC_BASIC,
+	STA_REC_RA,
+	STA_REC_RA_CMM_INFO,
+	STA_REC_RA_UPDATE,
+	STA_REC_BF,
+	STA_REC_AMSDU, /* for CR4 */
+	STA_REC_BA,
+	STA_REC_RED, /* not used */
+	STA_REC_TX_PROC, /* for hdr trans and CSO in CR4 */
+	STA_REC_HT,
+	STA_REC_VHT,
+	STA_REC_APPS,
+	STA_REC_MAX_NUM
+};
+
+enum {
+	CMD_CBW_20MHZ,
+	CMD_CBW_40MHZ,
+	CMD_CBW_80MHZ,
+	CMD_CBW_160MHZ,
+	CMD_CBW_10MHZ,
+	CMD_CBW_5MHZ,
+	CMD_CBW_8080MHZ
+};
+
+enum {
+	CH_SWITCH_NORMAL = 0,
+	CH_SWITCH_SCAN = 3,
+	CH_SWITCH_MCC = 4,
+	CH_SWITCH_DFS = 5,
+	CH_SWITCH_BACKGROUND_SCAN_START = 6,
+	CH_SWITCH_BACKGROUND_SCAN_RUNNING = 7,
+	CH_SWITCH_BACKGROUND_SCAN_STOP = 8,
+	CH_SWITCH_SCAN_BYPASS_DPD = 9
+};
+
+static inline struct sk_buff *
+mt7615_mcu_msg_alloc(const void *data, int len)
+{
+	return mt76_mcu_msg_alloc(data, sizeof(struct mt7615_mcu_txd),
+				  len, 0);
+}
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
new file mode 100644
index 0000000..895c290
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h
@@ -0,0 +1,195 @@
+/* SPDX-License-Identifier: ISC */
+/* Copyright (C) 2019 MediaTek Inc. */
+
+#ifndef __MT7615_H
+#define __MT7615_H
+
+#include <linux/interrupt.h>
+#include <linux/ktime.h>
+#include "../mt76.h"
+#include "regs.h"
+
+#define MT7615_MAX_INTERFACES		4
+#define MT7615_WTBL_SIZE		128
+#define MT7615_WTBL_RESERVED		(MT7615_WTBL_SIZE - 1)
+#define MT7615_WTBL_STA			(MT7615_WTBL_RESERVED - \
+					 MT7615_MAX_INTERFACES)
+
+#define MT7615_WATCHDOG_TIME		100 /* ms */
+#define MT7615_RATE_RETRY		2
+
+#define MT7615_TX_RING_SIZE		1024
+#define MT7615_TX_MCU_RING_SIZE		128
+#define MT7615_TX_FWDL_RING_SIZE	128
+
+#define MT7615_RX_RING_SIZE		1024
+#define MT7615_RX_MCU_RING_SIZE		512
+
+#define MT7615_FIRMWARE_CR4		"mt7615_cr4.bin"
+#define MT7615_FIRMWARE_N9		"mt7615_n9.bin"
+#define MT7615_ROM_PATCH		"mt7615_rom_patch.bin"
+
+#define MT7615_EEPROM_SIZE		1024
+#define MT7615_TOKEN_SIZE		4096
+
+struct mt7615_vif;
+struct mt7615_sta;
+
+enum mt7615_hw_txq_id {
+	MT7615_TXQ_MAIN,
+	MT7615_TXQ_EXT,
+	MT7615_TXQ_MCU,
+	MT7615_TXQ_FWDL,
+};
+
+struct mt7615_sta {
+	struct mt76_wcid wcid; /* must be first */
+
+	struct mt7615_vif *vif;
+
+	struct ieee80211_tx_rate rates[8];
+	u8 rate_count;
+	u8 n_rates;
+
+	u8 rate_probe;
+};
+
+struct mt7615_vif {
+	u8 idx;
+	u8 omac_idx;
+	u8 band_idx;
+	u8 wmm_idx;
+
+	struct mt7615_sta sta;
+};
+
+struct mt7615_dev {
+	struct mt76_dev mt76; /* must be first */
+	u32 vif_mask;
+	u32 omac_mask;
+
+	spinlock_t token_lock;
+	struct idr token;
+};
+
+enum {
+	HW_BSSID_0 = 0x0,
+	HW_BSSID_1,
+	HW_BSSID_2,
+	HW_BSSID_3,
+	HW_BSSID_MAX,
+	EXT_BSSID_START = 0x10,
+	EXT_BSSID_1,
+	EXT_BSSID_2,
+	EXT_BSSID_3,
+	EXT_BSSID_4,
+	EXT_BSSID_5,
+	EXT_BSSID_6,
+	EXT_BSSID_7,
+	EXT_BSSID_8,
+	EXT_BSSID_9,
+	EXT_BSSID_10,
+	EXT_BSSID_11,
+	EXT_BSSID_12,
+	EXT_BSSID_13,
+	EXT_BSSID_14,
+	EXT_BSSID_15,
+	EXT_BSSID_END
+};
+
+extern const struct ieee80211_ops mt7615_ops;
+extern struct pci_driver mt7615_pci_driver;
+
+u32 mt7615_reg_map(struct mt7615_dev *dev, u32 addr);
+
+int mt7615_register_device(struct mt7615_dev *dev);
+void mt7615_unregister_device(struct mt7615_dev *dev);
+int mt7615_eeprom_init(struct mt7615_dev *dev);
+int mt7615_dma_init(struct mt7615_dev *dev);
+void mt7615_dma_cleanup(struct mt7615_dev *dev);
+int mt7615_mcu_init(struct mt7615_dev *dev);
+int mt7615_mcu_set_dev_info(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			    int en);
+int mt7615_mcu_set_bss_info(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			    int en);
+int mt7615_mcu_set_wtbl_key(struct mt7615_dev *dev, int wcid,
+			    struct ieee80211_key_conf *key,
+			    enum set_key_cmd cmd);
+void mt7615_mcu_set_rates(struct mt7615_dev *dev, struct mt7615_sta *sta,
+			  struct ieee80211_tx_rate *probe_rate,
+			  struct ieee80211_tx_rate *rates);
+int mt7615_mcu_add_wtbl_bmc(struct mt7615_dev *dev, struct ieee80211_vif *vif);
+int mt7615_mcu_del_wtbl_bmc(struct mt7615_dev *dev, struct ieee80211_vif *vif);
+int mt7615_mcu_add_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta);
+int mt7615_mcu_del_wtbl(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta);
+int mt7615_mcu_del_wtbl_all(struct mt7615_dev *dev);
+int mt7615_mcu_set_sta_rec_bmc(struct mt7615_dev *dev,
+			       struct ieee80211_vif *vif, bool en);
+int mt7615_mcu_set_sta_rec(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta, bool en);
+int mt7615_mcu_set_bcn(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+		       int en);
+int mt7615_mcu_set_channel(struct mt7615_dev *dev);
+int mt7615_mcu_set_wmm(struct mt7615_dev *dev, u8 queue,
+		       const struct ieee80211_tx_queue_params *params);
+int mt7615_mcu_set_tx_ba(struct mt7615_dev *dev,
+			 struct ieee80211_ampdu_params *params,
+			 bool add);
+int mt7615_mcu_set_rx_ba(struct mt7615_dev *dev,
+			 struct ieee80211_ampdu_params *params,
+			 bool add);
+int mt7615_mcu_set_ht_cap(struct mt7615_dev *dev, struct ieee80211_vif *vif,
+			  struct ieee80211_sta *sta);
+
+static inline void mt7615_irq_enable(struct mt7615_dev *dev, u32 mask)
+{
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, 0, mask);
+}
+
+static inline void mt7615_irq_disable(struct mt7615_dev *dev, u32 mask)
+{
+	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
+}
+
+u16 mt7615_mac_tx_rate_val(struct mt7615_dev *dev,
+			   const struct ieee80211_tx_rate *rate,
+			   bool stbc, u8 *bw);
+int mt7615_mac_write_txwi(struct mt7615_dev *dev, __le32 *txwi,
+			  struct sk_buff *skb, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta, int pid,
+			  struct ieee80211_key_conf *key);
+int mt7615_mac_fill_rx(struct mt7615_dev *dev, struct sk_buff *skb);
+void mt7615_mac_add_txs(struct mt7615_dev *dev, void *data);
+void mt7615_mac_tx_free(struct mt7615_dev *dev, struct sk_buff *skb);
+
+int mt7615_mcu_set_eeprom(struct mt7615_dev *dev);
+int mt7615_mcu_init_mac(struct mt7615_dev *dev);
+int mt7615_mcu_set_rts_thresh(struct mt7615_dev *dev, u32 val);
+int mt7615_mcu_ctrl_pm_state(struct mt7615_dev *dev, int enter);
+void mt7615_mcu_exit(struct mt7615_dev *dev);
+
+int mt7615_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
+			  enum mt76_txq_id qid, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta,
+			  struct mt76_tx_info *tx_info);
+
+void mt7615_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
+			    struct mt76_queue_entry *e);
+
+void mt7615_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb);
+void mt7615_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
+void mt7615_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps);
+int mt7615_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta);
+void mt7615_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
+void mt7615_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
+void mt7615_mac_work(struct work_struct *work);
+void mt7615_txp_skb_unmap(struct mt76_dev *dev,
+			  struct mt76_txwi_cache *txwi);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
new file mode 100644
index 0000000..11122bd
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: ISC
+/* Copyright (C) 2019 MediaTek Inc.
+ *
+ * Author: Ryder Lee <ryder.lee@mediatek.com>
+ *         Felix Fietkau <nbd@nbd.name>
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mt7615.h"
+#include "mac.h"
+
+static const struct pci_device_id mt7615_pci_device_table[] = {
+	{ PCI_DEVICE(0x14c3, 0x7615) },
+	{ },
+};
+
+u32 mt7615_reg_map(struct mt7615_dev *dev, u32 addr)
+{
+	u32 base = addr & MT_MCU_PCIE_REMAP_2_BASE;
+	u32 offset = addr & MT_MCU_PCIE_REMAP_2_OFFSET;
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_2, base);
+
+	return MT_PCIE_REMAP_BASE_2 + offset;
+}
+
+void mt7615_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
+{
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+
+	mt7615_irq_enable(dev, MT_INT_RX_DONE(q));
+}
+
+irqreturn_t mt7615_irq_handler(int irq, void *dev_instance)
+{
+	struct mt7615_dev *dev = dev_instance;
+	u32 intr;
+
+	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
+	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
+
+	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
+		return IRQ_NONE;
+
+	intr &= dev->mt76.mmio.irqmask;
+
+	if (intr & MT_INT_TX_DONE_ALL) {
+		mt7615_irq_disable(dev, MT_INT_TX_DONE_ALL);
+		tasklet_schedule(&dev->mt76.tx_tasklet);
+	}
+
+	if (intr & MT_INT_RX_DONE(0)) {
+		mt7615_irq_disable(dev, MT_INT_RX_DONE(0));
+		napi_schedule(&dev->mt76.napi[0]);
+	}
+
+	if (intr & MT_INT_RX_DONE(1)) {
+		mt7615_irq_disable(dev, MT_INT_RX_DONE(1));
+		napi_schedule(&dev->mt76.napi[1]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int mt7615_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *id)
+{
+	static const struct mt76_driver_ops drv_ops = {
+		/* txwi_size = txd size + txp size */
+		.txwi_size = MT_TXD_SIZE + sizeof(struct mt7615_txp),
+		.txwi_flags = MT_TXWI_NO_FREE,
+		.tx_prepare_skb = mt7615_tx_prepare_skb,
+		.tx_complete_skb = mt7615_tx_complete_skb,
+		.rx_skb = mt7615_queue_rx_skb,
+		.rx_poll_complete = mt7615_rx_poll_complete,
+		.sta_ps = mt7615_sta_ps,
+		.sta_add = mt7615_sta_add,
+		.sta_assoc = mt7615_sta_assoc,
+		.sta_remove = mt7615_sta_remove,
+	};
+	struct mt7615_dev *dev;
+	struct mt76_dev *mdev;
+	int ret;
+
+	ret = pcim_enable_device(pdev);
+	if (ret)
+		return ret;
+
+	ret = pcim_iomap_regions(pdev, BIT(0), pci_name(pdev));
+	if (ret)
+		return ret;
+
+	pci_set_master(pdev);
+
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
+	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt7615_ops,
+				 &drv_ops);
+	if (!mdev)
+		return -ENOMEM;
+
+	dev = container_of(mdev, struct mt7615_dev, mt76);
+	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+
+	mdev->rev = (mt76_rr(dev, MT_HW_CHIPID) << 16) |
+		    (mt76_rr(dev, MT_HW_REV) & 0xff);
+	dev_dbg(mdev->dev, "ASIC revision: %04x\n", mdev->rev);
+
+	ret = devm_request_irq(mdev->dev, pdev->irq, mt7615_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (ret)
+		goto error;
+
+	ret = mt7615_register_device(dev);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	ieee80211_free_hw(mt76_hw(dev));
+	return ret;
+}
+
+static void mt7615_pci_remove(struct pci_dev *pdev)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
+
+	mt7615_unregister_device(dev);
+}
+
+struct pci_driver mt7615_pci_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= mt7615_pci_device_table,
+	.probe		= mt7615_pci_probe,
+	.remove		= mt7615_pci_remove,
+};
+
+module_pci_driver(mt7615_pci_driver);
+
+MODULE_DEVICE_TABLE(pci, mt7615_pci_device_table);
+MODULE_FIRMWARE(MT7615_FIRMWARE_CR4);
+MODULE_FIRMWARE(MT7615_FIRMWARE_N9);
+MODULE_FIRMWARE(MT7615_ROM_PATCH);
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/regs.h b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
new file mode 100644
index 0000000..70e5ace
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/regs.h
@@ -0,0 +1,203 @@
+/* SPDX-License-Identifier: ISC */
+/* Copyright (C) 2019 MediaTek Inc. */
+
+#ifndef __MT7615_REGS_H
+#define __MT7615_REGS_H
+
+#define MT_HW_REV			0x1000
+#define MT_HW_CHIPID			0x1008
+#define MT_TOP_MISC2			0x1134
+#define MT_TOP_MISC2_FW_STATE		GENMASK(2, 0)
+
+#define MT_MCU_BASE			0x2000
+#define MT_MCU(ofs)			(MT_MCU_BASE + (ofs))
+
+#define MT_MCU_PCIE_REMAP_1		MT_MCU(0x500)
+#define MT_MCU_PCIE_REMAP_1_OFFSET	GENMASK(17, 0)
+#define MT_MCU_PCIE_REMAP_1_BASE	GENMASK(31, 18)
+#define MT_PCIE_REMAP_BASE_1		0x40000
+
+#define MT_MCU_PCIE_REMAP_2		MT_MCU(0x504)
+#define MT_MCU_PCIE_REMAP_2_OFFSET	GENMASK(18, 0)
+#define MT_MCU_PCIE_REMAP_2_BASE	GENMASK(31, 19)
+#define MT_PCIE_REMAP_BASE_2		0x80000
+
+#define MT_HIF_BASE			0x4000
+#define MT_HIF(ofs)			(MT_HIF_BASE + (ofs))
+
+#define MT_CFG_LPCR_HOST		MT_HIF(0x1f0)
+#define MT_CFG_LPCR_HOST_FW_OWN		BIT(0)
+#define MT_CFG_LPCR_HOST_DRV_OWN	BIT(1)
+
+#define MT_INT_SOURCE_CSR		MT_HIF(0x200)
+#define MT_INT_MASK_CSR			MT_HIF(0x204)
+#define MT_DELAY_INT_CFG		MT_HIF(0x210)
+
+#define MT_INT_RX_DONE(_n)		BIT(_n)
+#define MT_INT_RX_DONE_ALL		GENMASK(1, 0)
+#define MT_INT_TX_DONE_ALL		GENMASK(7, 4)
+#define MT_INT_TX_DONE(_n)		BIT((_n) + 4)
+
+#define MT_WPDMA_GLO_CFG		MT_HIF(0x208)
+#define MT_WPDMA_GLO_CFG_TX_DMA_EN	BIT(0)
+#define MT_WPDMA_GLO_CFG_TX_DMA_BUSY	BIT(1)
+#define MT_WPDMA_GLO_CFG_RX_DMA_EN	BIT(2)
+#define MT_WPDMA_GLO_CFG_RX_DMA_BUSY	BIT(3)
+#define MT_WPDMA_GLO_CFG_DMA_BURST_SIZE	GENMASK(5, 4)
+#define MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE	BIT(6)
+#define MT_WPDMA_GLO_CFG_BIG_ENDIAN	BIT(7)
+#define MT_WPDMA_GLO_CFG_TX_BT_SIZE_BIT0	BIT(9)
+#define MT_WPDMA_GLO_CFG_MULTI_DMA_EN	GENMASK(11, 10)
+#define MT_WPDMA_GLO_CFG_FIFO_LITTLE_ENDIAN	BIT(12)
+#define MT_WPDMA_GLO_CFG_TX_BT_SIZE_BIT21	GENMASK(23, 22)
+#define MT_WPDMA_GLO_CFG_SW_RESET	BIT(24)
+#define MT_WPDMA_GLO_CFG_FIRST_TOKEN_ONLY	BIT(26)
+#define MT_WPDMA_GLO_CFG_OMIT_TX_INFO	BIT(28)
+
+#define MT_WPDMA_RST_IDX		MT_HIF(0x20c)
+
+#define MT_TX_RING_BASE			MT_HIF(0x300)
+#define MT_RX_RING_BASE			MT_HIF(0x400)
+
+#define MT_WPDMA_GLO_CFG1		MT_HIF(0x500)
+#define MT_WPDMA_TX_PRE_CFG		MT_HIF(0x510)
+#define MT_WPDMA_RX_PRE_CFG		MT_HIF(0x520)
+#define MT_WPDMA_ABT_CFG		MT_HIF(0x530)
+#define MT_WPDMA_ABT_CFG1		MT_HIF(0x534)
+
+#define MT_WF_PHY_BASE			0x10000
+#define MT_WF_PHY(ofs)			(MT_WF_PHY_BASE + (ofs))
+
+#define MT_WF_PHY_WF2_RFCTRL0		MT_WF_PHY(0x1900)
+#define MT_WF_PHY_WF2_RFCTRL0_LPBCN_EN	BIT(9)
+
+#define MT_WF_CFG_BASE			0x20200
+#define MT_WF_CFG(ofs)			(MT_WF_CFG_BASE + (ofs))
+
+#define MT_CFG_CCR			MT_WF_CFG(0x000)
+#define MT_CFG_CCR_MAC_D1_1X_GC_EN	BIT(24)
+#define MT_CFG_CCR_MAC_D0_1X_GC_EN	BIT(25)
+#define MT_CFG_CCR_MAC_D1_2X_GC_EN	BIT(30)
+#define MT_CFG_CCR_MAC_D0_2X_GC_EN	BIT(31)
+
+#define MT_WF_AGG_BASE			0x20a00
+#define MT_WF_AGG(ofs)			(MT_WF_AGG_BASE + (ofs))
+
+#define MT_AGG_ARCR			MT_WF_AGG(0x010)
+#define MT_AGG_ARCR_INIT_RATE1		BIT(0)
+#define MT_AGG_ARCR_RTS_RATE_THR	GENMASK(12, 8)
+#define MT_AGG_ARCR_RATE_DOWN_RATIO	GENMASK(17, 16)
+#define MT_AGG_ARCR_RATE_DOWN_RATIO_EN	BIT(19)
+#define MT_AGG_ARCR_RATE_UP_EXTRA_TH	GENMASK(22, 20)
+
+#define MT_AGG_ARUCR			MT_WF_AGG(0x018)
+#define MT_AGG_ARDCR			MT_WF_AGG(0x01c)
+#define MT_AGG_ARxCR_LIMIT_SHIFT(_n)	(4 * (_n))
+#define MT_AGG_ARxCR_LIMIT(_n)		GENMASK(2 + \
+					MT_AGG_ARxCR_LIMIT_SHIFT(_n), \
+					MT_AGG_ARxCR_LIMIT_SHIFT(_n))
+
+#define MT_AGG_SCR			MT_WF_AGG(0x0fc)
+#define MT_AGG_SCR_NLNAV_MID_PTEC_DIS	BIT(3)
+
+#define MT_WF_TMAC_BASE			0x21000
+#define MT_WF_TMAC(ofs)			(MT_WF_TMAC_BASE + (ofs))
+
+#define MT_TMAC_CTCR0			MT_WF_TMAC(0x0f4)
+#define MT_TMAC_CTCR0_INS_DDLMT_REFTIME	GENMASK(5, 0)
+#define MT_TMAC_CTCR0_INS_DDLMT_DENSITY	GENMASK(15, 12)
+#define MT_TMAC_CTCR0_INS_DDLMT_EN	BIT(17)
+#define MT_TMAC_CTCR0_INS_DDLMT_VHT_SMPDU_EN	BIT(18)
+
+#define MT_WF_RMAC_BASE			0x21200
+#define MT_WF_RMAC(ofs)			(MT_WF_RMAC_BASE + (ofs))
+
+#define MT_WF_RFCR			MT_WF_RMAC(0x000)
+#define MT_WF_RFCR_DROP_STBC_MULTI	BIT(0)
+#define MT_WF_RFCR_DROP_FCSFAIL		BIT(1)
+#define MT_WF_RFCR_DROP_VERSION		BIT(3)
+#define MT_WF_RFCR_DROP_PROBEREQ	BIT(4)
+#define MT_WF_RFCR_DROP_MCAST		BIT(5)
+#define MT_WF_RFCR_DROP_BCAST		BIT(6)
+#define MT_WF_RFCR_DROP_MCAST_FILTERED	BIT(7)
+#define MT_WF_RFCR_DROP_A3_MAC		BIT(8)
+#define MT_WF_RFCR_DROP_A3_BSSID	BIT(9)
+#define MT_WF_RFCR_DROP_A2_BSSID	BIT(10)
+#define MT_WF_RFCR_DROP_OTHER_BEACON	BIT(11)
+#define MT_WF_RFCR_DROP_FRAME_REPORT	BIT(12)
+#define MT_WF_RFCR_DROP_CTL_RSV		BIT(13)
+#define MT_WF_RFCR_DROP_CTS		BIT(14)
+#define MT_WF_RFCR_DROP_RTS		BIT(15)
+#define MT_WF_RFCR_DROP_DUPLICATE	BIT(16)
+#define MT_WF_RFCR_DROP_OTHER_BSS	BIT(17)
+#define MT_WF_RFCR_DROP_OTHER_UC	BIT(18)
+#define MT_WF_RFCR_DROP_OTHER_TIM	BIT(19)
+#define MT_WF_RFCR_DROP_NDPA		BIT(20)
+#define MT_WF_RFCR_DROP_UNWANTED_CTL	BIT(21)
+
+#define MT_WF_DMA_BASE			0x21800
+#define MT_WF_DMA(ofs)			(MT_WF_DMA_BASE + (ofs))
+
+#define MT_DMA_DCR0			MT_WF_DMA(0x000)
+#define MT_DMA_DCR0_MAX_RX_LEN		GENMASK(15, 2)
+#define MT_DMA_DCR0_RX_VEC_DROP		BIT(17)
+
+#define MT_WTBL_BASE			0x30000
+#define MT_WTBL_ENTRY_SIZE		256
+
+#define MT_WTBL_OFF_BASE		0x23400
+#define MT_WTBL_OFF(n)			(MT_WTBL_OFF_BASE + (n))
+
+#define MT_WTBL_UPDATE			MT_WTBL_OFF(0x030)
+#define MT_WTBL_UPDATE_WLAN_IDX		GENMASK(7, 0)
+#define MT_WTBL_UPDATE_RATE_UPDATE	BIT(13)
+#define MT_WTBL_UPDATE_TX_COUNT_CLEAR	BIT(14)
+#define MT_WTBL_UPDATE_BUSY		BIT(31)
+
+#define MT_WTBL_ON_BASE			0x23000
+#define MT_WTBL_ON(_n)			(MT_WTBL_ON_BASE + (_n))
+
+#define MT_WTBL_RIUCR0			MT_WTBL_ON(0x020)
+
+#define MT_WTBL_RIUCR1			MT_WTBL_ON(0x024)
+#define MT_WTBL_RIUCR1_RATE0		GENMASK(11, 0)
+#define MT_WTBL_RIUCR1_RATE1		GENMASK(23, 12)
+#define MT_WTBL_RIUCR1_RATE2_LO		GENMASK(31, 24)
+
+#define MT_WTBL_RIUCR2			MT_WTBL_ON(0x028)
+#define MT_WTBL_RIUCR2_RATE2_HI		GENMASK(3, 0)
+#define MT_WTBL_RIUCR2_RATE3		GENMASK(15, 4)
+#define MT_WTBL_RIUCR2_RATE4		GENMASK(27, 16)
+#define MT_WTBL_RIUCR2_RATE5_LO		GENMASK(31, 28)
+
+#define MT_WTBL_RIUCR3			MT_WTBL_ON(0x02c)
+#define MT_WTBL_RIUCR3_RATE5_HI		GENMASK(7, 0)
+#define MT_WTBL_RIUCR3_RATE6		GENMASK(19, 8)
+#define MT_WTBL_RIUCR3_RATE7		GENMASK(31, 20)
+
+#define MT_WTBL_W5_CHANGE_BW_RATE	GENMASK(7, 5)
+#define MT_WTBL_W5_SHORT_GI_20		BIT(8)
+#define MT_WTBL_W5_SHORT_GI_40		BIT(9)
+#define MT_WTBL_W5_SHORT_GI_80		BIT(10)
+#define MT_WTBL_W5_SHORT_GI_160		BIT(11)
+#define MT_WTBL_W5_BW_CAP		GENMASK(13, 12)
+#define MT_WTBL_W27_CC_BW_SEL		GENMASK(6, 5)
+
+#define MT_EFUSE_BASE			0x81070000
+#define MT_EFUSE_BASE_CTRL		0x000
+#define MT_EFUSE_BASE_CTRL_EMPTY	BIT(30)
+
+#define MT_EFUSE_CTRL			0x008
+#define MT_EFUSE_CTRL_AOUT		GENMASK(5, 0)
+#define MT_EFUSE_CTRL_MODE		GENMASK(7, 6)
+#define MT_EFUSE_CTRL_LDO_OFF_TIME	GENMASK(13, 8)
+#define MT_EFUSE_CTRL_LDO_ON_TIME	GENMASK(15, 14)
+#define MT_EFUSE_CTRL_AIN		GENMASK(25, 16)
+#define MT_EFUSE_CTRL_VALID		BIT(29)
+#define MT_EFUSE_CTRL_KICK		BIT(30)
+#define MT_EFUSE_CTRL_SEL		BIT(31)
+
+#define MT_EFUSE_WDATA(_i)		(0x010 + ((_i) * 4))
+#define MT_EFUSE_RDATA(_i)		(0x030 + ((_i) * 4))
+
+#endif
-- 
1.9.1

