Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A81C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B21E218A4
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 14:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="l8n9FBId"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbfA3OIG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 09:08:06 -0500
Received: from nbd.name ([46.4.11.11]:40150 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbfA3OIG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 09:08:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fp0GLcHzAQkmqln8poOieg2hIRcO8sf/eNA+JN0mg9k=; b=l8n9FBIdzutKU/aqU5Qmgq0hZW
        5tKf+7tG9l0Y+ai2/tWVDkwEdTPj7IanqZ3c6ifyaQYDgedtL6ZPmpHWCFL/iQSQ9U8m2TEAN0U30
        0mRn1C40SWiXW14GFLizCnXmZvRG/LF/XyLNHwNsq+bLg7BehfUcMICZfRDec6Ak80+Q=;
Received: by maeck.lan (Postfix, from userid 501)
        id 4D1464E25A70; Wed, 30 Jan 2019 15:07:57 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76: add driver for MT7603E and MT7628/7688
Date:   Wed, 30 Jan 2019 15:07:56 +0100
Message-Id: <20190130140756.91317-3-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190130140756.91317-1-nbd@nbd.name>
References: <20190130140756.91317-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This driver is for a newer generation of 2x2 MediaTek 802.11n chipsets.
MT7603E is a PCIe chip.
MT7628 and MT7688 are MIPS SoC devices with built-in WLAN.
MT7688 is limited to 1x1

This driver fully supports AP, station, mesh, ad-hoc and monitor mode.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/Kconfig    |    1 +
 drivers/net/wireless/mediatek/mt76/Makefile   |    1 +
 .../net/wireless/mediatek/mt76/mt7603/Kconfig |    9 +
 .../wireless/mediatek/mt76/mt7603/Makefile    |    6 +
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  201 ++
 .../net/wireless/mediatek/mt76/mt7603/core.c  |   88 +
 .../wireless/mediatek/mt76/mt7603/debugfs.c   |   71 +
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |  253 +++
 .../wireless/mediatek/mt76/mt7603/eeprom.c    |  183 ++
 .../wireless/mediatek/mt76/mt7603/eeprom.h    |  101 +
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  608 ++++++
 .../net/wireless/mediatek/mt76/mt7603/mac.c   | 1764 +++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7603/mac.h   |  257 +++
 .../net/wireless/mediatek/mt76/mt7603/main.c  |  730 +++++++
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   |  536 +++++
 .../net/wireless/mediatek/mt76/mt7603/mcu.h   |  118 ++
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  271 +++
 .../net/wireless/mediatek/mt76/mt7603/pci.c   |   92 +
 .../net/wireless/mediatek/mt76/mt7603/regs.h  |  789 ++++++++
 .../net/wireless/mediatek/mt76/mt7603/soc.c   |   97 +
 20 files changed, 6176 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/Kconfig
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/Makefile
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/core.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/init.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mac.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mac.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/main.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mcu.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/pci.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/regs.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt7603/soc.c

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index c30d8f5bbf2a..dbe8c70a8f73 100644
--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -21,3 +21,4 @@ config MT76x02_USB
 
 source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
 source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
+source "drivers/net/wireless/mediatek/mt76/mt7603/Kconfig"
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 1a45cb30f39f..40615327ab68 100644
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -21,3 +21,4 @@ mt76x02-usb-y := mt76x02_usb_mcu.o mt76x02_usb_core.o
 
 obj-$(CONFIG_MT76x0_COMMON) += mt76x0/
 obj-$(CONFIG_MT76x2_COMMON) += mt76x2/
+obj-$(CONFIG_MT7603E) += mt7603/
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/Kconfig b/drivers/net/wireless/mediatek/mt76/mt7603/Kconfig
new file mode 100644
index 000000000000..087945c3d8f3
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/Kconfig
@@ -0,0 +1,9 @@
+config MT7603E
+	tristate "MediaTek MT7603E (PCIe) and MT76x8 WLAN support"
+	select MT76_CORE
+	depends on MAC80211
+	depends on PCI
+	help
+	  This adds support for MT7603E wireless PCIe devices and the WLAN core on
+	  MT7628/MT7688 SoC devices
+
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/Makefile b/drivers/net/wireless/mediatek/mt76/mt7603/Makefile
new file mode 100644
index 000000000000..d95a30421c62
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/Makefile
@@ -0,0 +1,6 @@
+obj-$(CONFIG_MT7603E) += mt7603e.o
+
+mt7603e-y := \
+	pci.o soc.o main.o init.o mcu.o \
+	core.o dma.o mac.o eeprom.o \
+	beacon.o debugfs.o
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
new file mode 100644
index 000000000000..0f6f679bbe73
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -0,0 +1,201 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include "mt7603.h"
+
+struct beacon_bc_data {
+	struct mt7603_dev *dev;
+	struct sk_buff_head q;
+	struct sk_buff *tail[MT7603_MAX_INTERFACES];
+	int count[MT7603_MAX_INTERFACES];
+};
+
+static void
+mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct mt7603_dev *dev = (struct mt7603_dev *)priv;
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+	struct sk_buff *skb = NULL;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_beacon_get(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	mt76_dma_tx_queue_skb(&dev->mt76, &dev->mt76.q_tx[MT_TXQ_BEACON], skb,
+			      &mvif->sta.wcid, NULL);
+
+	spin_lock_bh(&dev->ps_lock);
+	mt76_wr(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY |
+		FIELD_PREP(MT_DMA_FQCR0_TARGET_WCID, mvif->sta.wcid.idx) |
+		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID,
+			   dev->mt76.q_tx[MT_TXQ_CAB].hw_idx) |
+		FIELD_PREP(MT_DMA_FQCR0_DEST_PORT_ID, 3) |
+		FIELD_PREP(MT_DMA_FQCR0_DEST_QUEUE_ID, 8));
+
+	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000))
+		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+static void
+mt7603_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
+{
+	struct beacon_bc_data *data = priv;
+	struct mt7603_dev *dev = data->dev;
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+	struct ieee80211_tx_info *info;
+	struct sk_buff *skb;
+
+	if (!(dev->beacon_mask & BIT(mvif->idx)))
+		return;
+
+	skb = ieee80211_get_buffered_bc(mt76_hw(dev), vif);
+	if (!skb)
+		return;
+
+	info = IEEE80211_SKB_CB(skb);
+	info->control.vif = vif;
+	info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
+	mt76_skb_set_moredata(skb, true);
+	__skb_queue_tail(&data->q, skb);
+	data->tail[mvif->idx] = skb;
+	data->count[mvif->idx]++;
+}
+
+void mt7603_pre_tbtt_tasklet(unsigned long arg)
+{
+	struct mt7603_dev *dev = (struct mt7603_dev *)arg;
+	struct mt76_queue *q;
+	struct beacon_bc_data data = {};
+	struct sk_buff *skb;
+	int i, nframes;
+
+	data.dev = dev;
+	__skb_queue_head_init(&data.q);
+
+	q = &dev->mt76.q_tx[MT_TXQ_BEACON];
+	spin_lock_bh(&q->lock);
+	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+		IEEE80211_IFACE_ITER_RESUME_ALL,
+		mt7603_update_beacon_iter, dev);
+	mt76_queue_kick(dev, q);
+	spin_unlock_bh(&q->lock);
+
+	/* Flush all previous CAB queue packets */
+	mt76_wr(dev, MT_WF_ARB_CAB_FLUSH, GENMASK(30, 16) | BIT(0));
+
+	mt76_queue_tx_cleanup(dev, MT_TXQ_CAB, false);
+
+	mt76_csa_check(&dev->mt76);
+	if (dev->mt76.csa_complete)
+		goto out;
+
+	q = &dev->mt76.q_tx[MT_TXQ_CAB];
+	do {
+		nframes = skb_queue_len(&data.q);
+		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
+			IEEE80211_IFACE_ITER_RESUME_ALL,
+			mt7603_add_buffered_bc, &data);
+	} while (nframes != skb_queue_len(&data.q) &&
+		 skb_queue_len(&data.q) < 8);
+
+	if (skb_queue_empty(&data.q))
+		goto out;
+
+	for (i = 0; i < ARRAY_SIZE(data.tail); i++) {
+		if (!data.tail[i])
+			continue;
+
+		mt76_skb_set_moredata(data.tail[i], false);
+	}
+
+	spin_lock_bh(&q->lock);
+	while ((skb = __skb_dequeue(&data.q)) != NULL) {
+		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+		struct ieee80211_vif *vif = info->control.vif;
+		struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+
+		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->sta.wcid,
+				      NULL);
+	}
+	mt76_queue_kick(dev, q);
+	spin_unlock_bh(&q->lock);
+
+	for (i = 0; i < ARRAY_SIZE(data.count); i++)
+		mt76_wr(dev, MT_WF_ARB_CAB_COUNT_B0_REG(i),
+			data.count[i] << MT_WF_ARB_CAB_COUNT_B0_SHIFT(i));
+
+	mt76_wr(dev, MT_WF_ARB_CAB_START,
+		MT_WF_ARB_CAB_START_BSSn(0) |
+		(MT_WF_ARB_CAB_START_BSS0n(1) *
+		 ((1 << (MT7603_MAX_INTERFACES - 1)) - 1)));
+
+out:
+	mt76_queue_tx_cleanup(dev, MT_TXQ_BEACON, false);
+	if (dev->mt76.q_tx[MT_TXQ_BEACON].queued >
+	    __sw_hweight8(dev->beacon_mask))
+		dev->beacon_check++;
+}
+
+void mt7603_beacon_set_timer(struct mt7603_dev *dev, int idx, int intval)
+{
+	u32 pre_tbtt = MT7603_PRE_TBTT_TIME / 64;
+
+	if (idx >= 0) {
+		if (intval)
+			dev->beacon_mask |= BIT(idx);
+		else
+			dev->beacon_mask &= ~BIT(idx);
+	}
+
+	if (!dev->beacon_mask || (!intval && idx < 0)) {
+		mt7603_irq_disable(dev, MT_INT_MAC_IRQ3);
+		mt76_clear(dev, MT_ARB_SCR, MT_ARB_SCR_BCNQ_OPMODE_MASK);
+		mt76_wr(dev, MT_HW_INT_MASK(3), 0);
+		return;
+	}
+
+	dev->beacon_int = intval;
+	mt76_wr(dev, MT_TBTT,
+		FIELD_PREP(MT_TBTT_PERIOD, intval) | MT_TBTT_CAL_ENABLE);
+
+	mt76_wr(dev, MT_TBTT_TIMER_CFG, 0x99); /* start timer */
+
+	mt76_rmw_field(dev, MT_ARB_SCR, MT_ARB_SCR_BCNQ_OPMODE_MASK,
+		       MT_BCNQ_OPMODE_AP);
+	mt76_clear(dev, MT_ARB_SCR, MT_ARB_SCR_TBTT_BCN_PRIO);
+	mt76_set(dev, MT_ARB_SCR, MT_ARB_SCR_TBTT_BCAST_PRIO);
+
+	mt76_wr(dev, MT_PRE_TBTT, pre_tbtt);
+
+	mt76_set(dev, MT_HW_INT_MASK(3),
+		 MT_HW_INT3_PRE_TBTT0 | MT_HW_INT3_TBTT0);
+
+	mt76_set(dev, MT_WF_ARB_BCN_START,
+		 MT_WF_ARB_BCN_START_BSSn(0) |
+		 ((dev->beacon_mask >> 1) * MT_WF_ARB_BCN_START_BSS0n(1)));
+	mt7603_irq_enable(dev, MT_INT_MAC_IRQ3);
+
+	if (dev->beacon_mask & ~BIT(0))
+		mt76_set(dev, MT_LPON_SBTOR(0), MT_LPON_SBTOR_SUB_BSS_EN);
+	else
+		mt76_clear(dev, MT_LPON_SBTOR(0), MT_LPON_SBTOR_SUB_BSS_EN);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/core.c b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
new file mode 100644
index 000000000000..30ffc68b0208
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include "mt7603.h"
+
+void mt7603_set_irq_mask(struct mt7603_dev *dev, u32 clear, u32 set)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->mt76.mmio.irq_lock, flags);
+	dev->mt76.mmio.irqmask &= ~clear;
+	dev->mt76.mmio.irqmask |= set;
+	mt76_wr(dev, MT_INT_MASK_CSR, dev->mt76.mmio.irqmask);
+	spin_unlock_irqrestore(&dev->mt76.mmio.irq_lock, flags);
+}
+
+void mt7603_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+
+	mt7603_irq_enable(dev, MT_INT_RX_DONE(q));
+}
+
+irqreturn_t mt7603_irq_handler(int irq, void *dev_instance)
+{
+	struct mt7603_dev *dev = dev_instance;
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
+	if (intr & MT_INT_MAC_IRQ3) {
+		u32 hwintr = mt76_rr(dev, MT_HW_INT_STATUS(3));
+
+		mt76_wr(dev, MT_HW_INT_STATUS(3), hwintr);
+		if (hwintr & MT_HW_INT3_PRE_TBTT0)
+			tasklet_schedule(&dev->pre_tbtt_tasklet);
+
+		if ((hwintr & MT_HW_INT3_TBTT0) && dev->mt76.csa_complete)
+			mt76_csa_finish(&dev->mt76);
+	}
+
+	if (intr & MT_INT_TX_DONE_ALL) {
+		mt7603_irq_disable(dev, MT_INT_TX_DONE_ALL);
+		tasklet_schedule(&dev->tx_tasklet);
+	}
+
+	if (intr & MT_INT_RX_DONE(0)) {
+		mt7603_irq_disable(dev, MT_INT_RX_DONE(0));
+		napi_schedule(&dev->mt76.napi[0]);
+	}
+
+	if (intr & MT_INT_RX_DONE(1)) {
+		mt7603_irq_disable(dev, MT_INT_RX_DONE(1));
+		napi_schedule(&dev->mt76.napi[1]);
+	}
+
+	return IRQ_HANDLED;
+}
+
+u32 mt7603_reg_map(struct mt7603_dev *dev, u32 addr)
+{
+	u32 base = addr & GENMASK(31, 19);
+	u32 offset = addr & GENMASK(18, 0);
+
+	dev->bus_ops->wr(&dev->mt76, MT_MCU_PCIE_REMAP_2, base);
+
+	return MT_PCIE_REMAP_BASE_2 + offset;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c b/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
new file mode 100644
index 000000000000..ca7b109c78a6
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/debugfs.c
@@ -0,0 +1,71 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include "mt7603.h"
+
+static int
+mt7603_reset_read(struct seq_file *s, void *data)
+{
+	struct mt7603_dev *dev = dev_get_drvdata(s->private);
+	static const char * const reset_cause_str[] = {
+		[RESET_CAUSE_TX_HANG] = "TX hang",
+		[RESET_CAUSE_TX_BUSY] = "TX DMA busy stuck",
+		[RESET_CAUSE_RX_BUSY] = "RX DMA busy stuck",
+		[RESET_CAUSE_RX_PSE_BUSY] = "RX PSE busy stuck",
+		[RESET_CAUSE_BEACON_STUCK] = "Beacon stuck",
+		[RESET_CAUSE_MCU_HANG] = "MCU hang",
+		[RESET_CAUSE_RESET_FAILED] = "PSE reset failed",
+	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(reset_cause_str); i++) {
+		if (!reset_cause_str[i])
+			continue;
+
+		seq_printf(s, "%20s: %u\n", reset_cause_str[i],
+			   dev->reset_cause[i]);
+	}
+
+	return 0;
+}
+
+static int
+mt7603_radio_read(struct seq_file *s, void *data)
+{
+	struct mt7603_dev *dev = dev_get_drvdata(s->private);
+
+	seq_printf(s, "Sensitivity: %d\n", dev->sensitivity);
+	seq_printf(s, "False CCA: ofdm=%d cck=%d\n",
+		   dev->false_cca_ofdm, dev->false_cca_cck);
+
+	return 0;
+}
+
+void mt7603_init_debugfs(struct mt7603_dev *dev)
+{
+	struct dentry *dir;
+
+	dir = mt76_register_debugfs(&dev->mt76);
+	if (!dir)
+		return;
+
+	debugfs_create_u32("reset_test", 0600, dir, &dev->reset_test);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "reset", dir,
+				    mt7603_reset_read);
+	debugfs_create_devm_seqfile(dev->mt76.dev, "radio", dir,
+				    mt7603_radio_read);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
new file mode 100644
index 000000000000..75ec077d8d74
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -0,0 +1,253 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include "mt7603.h"
+#include "mac.h"
+#include "../dma.h"
+
+int
+mt7603_tx_queue_mcu(struct mt7603_dev *dev, enum mt76_txq_id qid,
+		    struct sk_buff *skb)
+{
+	struct mt76_queue *q = &dev->mt76.q_tx[qid];
+	struct mt76_queue_buf buf;
+	dma_addr_t addr;
+
+	addr = dma_map_single(dev->mt76.dev, skb->data, skb->len,
+			      DMA_TO_DEVICE);
+	if (dma_mapping_error(dev->mt76.dev, addr))
+		return -ENOMEM;
+
+	buf.addr = addr;
+	buf.len = skb->len;
+	spin_lock_bh(&q->lock);
+	mt76_queue_add_buf(dev, q, &buf, 1, 0, skb, NULL);
+	mt76_queue_kick(dev, q);
+	spin_unlock_bh(&q->lock);
+
+	return 0;
+}
+
+static int
+mt7603_init_tx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc)
+{
+	int ret;
+
+	q->hw_idx = idx;
+	q->regs = dev->mt76.mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+
+	ret = mt76_queue_alloc(dev, q);
+	if (ret)
+		return ret;
+
+	mt7603_irq_enable(dev, MT_INT_TX_DONE(idx));
+
+	return 0;
+}
+
+static void
+mt7603_rx_loopback_skb(struct mt7603_dev *dev, struct sk_buff *skb)
+{
+	__le32 *txd = (__le32 *)skb->data;
+	struct mt7603_sta *msta;
+	struct mt76_wcid *wcid;
+	int idx;
+	u32 val;
+
+	if (skb->len < sizeof(MT_TXD_SIZE) + sizeof(struct ieee80211_hdr))
+		goto free;
+
+	val = le32_to_cpu(txd[1]);
+	idx = FIELD_GET(MT_TXD1_WLAN_IDX, val);
+	skb->priority = FIELD_GET(MT_TXD1_TID, val);
+
+	if (idx >= MT7603_WTBL_STA - 1)
+		goto free;
+
+	wcid = rcu_dereference(dev->mt76.wcid[idx]);
+	if (!wcid)
+		goto free;
+
+	msta = container_of(wcid, struct mt7603_sta, wcid);
+	val = le32_to_cpu(txd[0]);
+	skb_set_queue_mapping(skb, FIELD_GET(MT_TXD0_Q_IDX, val));
+
+	spin_lock_bh(&dev->ps_lock);
+	__skb_queue_tail(&msta->psq, skb);
+	if (skb_queue_len(&msta->psq) >= 64) {
+		skb = __skb_dequeue(&msta->psq);
+		dev_kfree_skb(skb);
+	}
+	spin_unlock_bh(&dev->ps_lock);
+	return;
+
+free:
+	dev_kfree_skb(skb);
+}
+
+void mt7603_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	__le32 *rxd = (__le32 *)skb->data;
+	__le32 *end = (__le32 *)&skb->data[skb->len];
+	enum rx_pkt_type type;
+
+	type = FIELD_GET(MT_RXD0_PKT_TYPE, le32_to_cpu(rxd[0]));
+
+	if (q == MT_RXQ_MCU) {
+		if (type == PKT_TYPE_RX_EVENT)
+			mt7603_mcu_rx_event(dev, skb);
+		else
+			mt7603_rx_loopback_skb(dev, skb);
+		return;
+	}
+
+	switch (type) {
+	case PKT_TYPE_TXS:
+		for (rxd++; rxd + 5 <= end; rxd += 5)
+			mt7603_mac_add_txs(dev, rxd);
+		dev_kfree_skb(skb);
+		break;
+	case PKT_TYPE_RX_EVENT:
+		mt7603_mcu_rx_event(dev, skb);
+		return;
+	case PKT_TYPE_NORMAL:
+		if (mt7603_mac_fill_rx(dev, skb) == 0) {
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
+static int
+mt7603_init_rx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc, int bufsize)
+{
+	int ret;
+
+	q->regs = dev->mt76.mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+	q->buf_size = bufsize;
+
+	ret = mt76_queue_alloc(dev, q);
+	if (ret)
+		return ret;
+
+	mt7603_irq_enable(dev, MT_INT_RX_DONE(idx));
+
+	return 0;
+}
+
+static void
+mt7603_tx_tasklet(unsigned long data)
+{
+	struct mt7603_dev *dev = (struct mt7603_dev *)data;
+	int i;
+
+	dev->tx_dma_check = 0;
+	for (i = MT_TXQ_MCU; i >= 0; i--)
+		mt76_queue_tx_cleanup(dev, i, false);
+
+	mt7603_irq_enable(dev, MT_INT_TX_DONE_ALL);
+}
+
+int mt7603_dma_init(struct mt7603_dev *dev)
+{
+	static const u8 wmm_queue_map[] = {
+		[IEEE80211_AC_BK] = 0,
+		[IEEE80211_AC_BE] = 1,
+		[IEEE80211_AC_VI] = 2,
+		[IEEE80211_AC_VO] = 3,
+	};
+	int ret;
+	int i;
+
+	mt76_dma_attach(&dev->mt76);
+
+	init_waitqueue_head(&dev->mt76.mmio.mcu.wait);
+	skb_queue_head_init(&dev->mt76.mmio.mcu.res_q);
+
+	tasklet_init(&dev->tx_tasklet, mt7603_tx_tasklet, (unsigned long)dev);
+
+	mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		   MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		   MT_WPDMA_GLO_CFG_RX_DMA_EN |
+		   MT_WPDMA_GLO_CFG_DMA_BURST_SIZE |
+		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+
+	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
+	mt7603_pse_client_reset(dev);
+
+	for (i = 0; i < ARRAY_SIZE(wmm_queue_map); i++) {
+		ret = mt7603_init_tx_queue(dev, &dev->mt76.q_tx[i],
+					   wmm_queue_map[i],
+					   MT_TX_RING_SIZE);
+		if (ret)
+			return ret;
+	}
+
+	ret = mt7603_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_PSD],
+				   MT_TX_HW_QUEUE_MGMT, MT_TX_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7603_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_MCU],
+				   MT_TX_HW_QUEUE_MCU, MT_MCU_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7603_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_BEACON],
+				   MT_TX_HW_QUEUE_BCN, MT_MCU_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7603_init_tx_queue(dev, &dev->mt76.q_tx[MT_TXQ_CAB],
+				   MT_TX_HW_QUEUE_BMC, MT_MCU_RING_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7603_init_rx_queue(dev, &dev->mt76.q_rx[MT_RXQ_MCU], 1,
+				   MT_MCU_RING_SIZE, MT_RX_BUF_SIZE);
+	if (ret)
+		return ret;
+
+	ret = mt7603_init_rx_queue(dev, &dev->mt76.q_rx[MT_RXQ_MAIN], 0,
+				   MT7603_RX_RING_SIZE, MT_RX_BUF_SIZE);
+	if (ret)
+		return ret;
+
+	mt76_wr(dev, MT_DELAY_INT_CFG, 0);
+	return mt76_init_queues(dev);
+}
+
+void mt7603_dma_cleanup(struct mt7603_dev *dev)
+{
+	mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		   MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		   MT_WPDMA_GLO_CFG_RX_DMA_EN |
+		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+
+	tasklet_kill(&dev->tx_tasklet);
+	mt76_dma_cleanup(&dev->mt76);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
new file mode 100644
index 000000000000..6d7df67de494
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -0,0 +1,183 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include "mt7603.h"
+#include "eeprom.h"
+
+static int
+mt7603_efuse_read(struct mt7603_dev *dev, u32 base, u16 addr, u8 *data)
+{
+	u32 val;
+	int i;
+
+	val = mt76_rr(dev, base + MT_EFUSE_CTRL);
+	val &= ~(MT_EFUSE_CTRL_AIN |
+		 MT_EFUSE_CTRL_MODE);
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
+		memset(data, 0xff, 16);
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
+static int
+mt7603_efuse_init(struct mt7603_dev *dev)
+{
+	u32 base = mt7603_reg_map(dev, MT_EFUSE_BASE);
+	int len = MT7603_EEPROM_SIZE;
+	void *buf;
+	int ret, i;
+
+	if (mt76_rr(dev, base + MT_EFUSE_BASE_CTRL) & MT_EFUSE_BASE_CTRL_EMPTY)
+		return 0;
+
+	dev->mt76.otp.data = devm_kzalloc(dev->mt76.dev, len, GFP_KERNEL);
+	dev->mt76.otp.size = len;
+	if (!dev->mt76.otp.data)
+		return -ENOMEM;
+
+	buf = dev->mt76.otp.data;
+	for (i = 0; i + 16 <= len; i += 16) {
+		ret = mt7603_efuse_read(dev, base, i, buf + i);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static bool
+mt7603_has_cal_free_data(struct mt7603_dev *dev, u8 *efuse)
+{
+	if (!efuse[MT_EE_TEMP_SENSOR_CAL])
+		return false;
+
+	if (get_unaligned_le16(efuse + MT_EE_TX_POWER_0_START_2G) == 0)
+		return false;
+
+	if (get_unaligned_le16(efuse + MT_EE_TX_POWER_1_START_2G) == 0)
+		return false;
+
+	if (!efuse[MT_EE_CP_FT_VERSION])
+		return false;
+
+	if (!efuse[MT_EE_XTAL_FREQ_OFFSET])
+		return false;
+
+	if (!efuse[MT_EE_XTAL_WF_RFCAL])
+		return false;
+
+	return true;
+}
+
+static void
+mt7603_apply_cal_free_data(struct mt7603_dev *dev, u8 *efuse)
+{
+	static const u8 cal_free_bytes[] = {
+		MT_EE_TEMP_SENSOR_CAL,
+		MT_EE_CP_FT_VERSION,
+		MT_EE_XTAL_FREQ_OFFSET,
+		MT_EE_XTAL_WF_RFCAL,
+		/* Skip for MT7628 */
+		MT_EE_TX_POWER_0_START_2G,
+		MT_EE_TX_POWER_0_START_2G + 1,
+		MT_EE_TX_POWER_1_START_2G,
+		MT_EE_TX_POWER_1_START_2G + 1,
+	};
+	u8 *eeprom = dev->mt76.eeprom.data;
+	int n = ARRAY_SIZE(cal_free_bytes);
+	int i;
+
+	if (!mt7603_has_cal_free_data(dev, efuse))
+		return;
+
+	if (is_mt7628(dev))
+		n -= 4;
+
+	for (i = 0; i < n; i++) {
+		int offset = cal_free_bytes[i];
+
+		eeprom[offset] = efuse[offset];
+	}
+}
+
+static int
+mt7603_eeprom_load(struct mt7603_dev *dev)
+{
+	int ret;
+
+	ret = mt76_eeprom_init(&dev->mt76, MT7603_EEPROM_SIZE);
+	if (ret < 0)
+		return ret;
+
+	return mt7603_efuse_init(dev);
+}
+
+static int mt7603_check_eeprom(struct mt76_dev *dev)
+{
+	u16 val = get_unaligned_le16(dev->eeprom.data);
+
+	switch (val) {
+	case 0x7628:
+	case 0x7603:
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+int mt7603_eeprom_init(struct mt7603_dev *dev)
+{
+	int ret;
+
+	ret = mt7603_eeprom_load(dev);
+	if (ret < 0)
+		return ret;
+
+	if (dev->mt76.otp.data) {
+		if (mt7603_check_eeprom(&dev->mt76) == 0)
+			mt7603_apply_cal_free_data(dev, dev->mt76.otp.data);
+		else
+			memcpy(dev->mt76.eeprom.data, dev->mt76.otp.data,
+			       MT7603_EEPROM_SIZE);
+	}
+
+	dev->mt76.cap.has_2ghz = true;
+	memcpy(dev->mt76.macaddr, dev->mt76.eeprom.data + MT_EE_MAC_ADDR,
+	       ETH_ALEN);
+
+	mt76_eeprom_override(&dev->mt76);
+
+	return 0;
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h
new file mode 100644
index 000000000000..18e649493bfd
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.h
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#ifndef __MT7603_EEPROM_H
+#define __MT7603_EEPROM_H
+
+#include "mt7603.h"
+
+enum mt7603_eeprom_field {
+	MT_EE_CHIP_ID =				0x000,
+	MT_EE_VERSION =				0x002,
+	MT_EE_MAC_ADDR =			0x004,
+	MT_EE_NIC_CONF_0 =			0x034,
+	MT_EE_NIC_CONF_1 =			0x036,
+	MT_EE_NIC_CONF_2 =			0x042,
+
+	MT_EE_XTAL_TRIM_1 =			0x03a,
+
+	MT_EE_RSSI_OFFSET_2G =			0x046,
+	MT_EE_WIFI_RF_SETTING =			0x048,
+	MT_EE_RSSI_OFFSET_5G =			0x04a,
+
+	MT_EE_TX_POWER_DELTA_BW40 =		0x050,
+	MT_EE_TX_POWER_DELTA_BW80 =		0x052,
+
+	MT_EE_TX_POWER_EXT_PA_5G =		0x054,
+
+	MT_EE_TEMP_SENSOR_CAL =			0x055,
+
+	MT_EE_TX_POWER_0_START_2G =		0x056,
+	MT_EE_TX_POWER_1_START_2G =		0x05c,
+
+	/* used as byte arrays */
+#define MT_TX_POWER_GROUP_SIZE_5G		5
+#define MT_TX_POWER_GROUPS_5G			6
+	MT_EE_TX_POWER_0_START_5G =		0x062,
+
+	MT_EE_TX_POWER_0_GRP3_TX_POWER_DELTA =	0x074,
+	MT_EE_TX_POWER_0_GRP4_TSSI_SLOPE =	0x076,
+
+	MT_EE_TX_POWER_1_START_5G =		0x080,
+
+	MT_EE_TX_POWER_CCK =			0x0a0,
+	MT_EE_TX_POWER_OFDM_2G_6M =		0x0a2,
+	MT_EE_TX_POWER_OFDM_2G_24M =		0x0a4,
+	MT_EE_TX_POWER_OFDM_2G_54M =		0x0a6,
+	MT_EE_TX_POWER_HT_BPSK_QPSK =		0x0a8,
+	MT_EE_TX_POWER_HT_16_64_QAM =		0x0aa,
+	MT_EE_TX_POWER_HT_64_QAM =		0x0ac,
+
+	MT_EE_ELAN_RX_MODE_GAIN =		0x0c0,
+	MT_EE_ELAN_RX_MODE_NF =			0x0c1,
+	MT_EE_ELAN_RX_MODE_P1DB =		0x0c2,
+
+	MT_EE_ELAN_BYPASS_MODE_GAIN =		0x0c3,
+	MT_EE_ELAN_BYPASS_MODE_NF =		0x0c4,
+	MT_EE_ELAN_BYPASS_MODE_P1DB =		0x0c5,
+
+	MT_EE_STEP_NUM_NEG_6_7 =		0x0c6,
+	MT_EE_STEP_NUM_NEG_4_5 =		0x0c8,
+	MT_EE_STEP_NUM_NEG_2_3 =		0x0ca,
+	MT_EE_STEP_NUM_NEG_0_1 =		0x0cc,
+
+	MT_EE_REF_STEP_24G =			0x0ce,
+
+	MT_EE_STEP_NUM_PLUS_1_2 =		0x0d0,
+	MT_EE_STEP_NUM_PLUS_3_4 =		0x0d2,
+	MT_EE_STEP_NUM_PLUS_5_6 =		0x0d4,
+	MT_EE_STEP_NUM_PLUS_7 =			0x0d6,
+
+	MT_EE_CP_FT_VERSION =			0x0f0,
+
+	MT_EE_XTAL_FREQ_OFFSET =		0x0f4,
+	MT_EE_XTAL_TRIM_2_COMP =		0x0f5,
+	MT_EE_XTAL_TRIM_3_COMP =		0x0f6,
+	MT_EE_XTAL_WF_RFCAL =			0x0f7,
+
+	__MT_EE_MAX
+};
+
+enum mt7603_eeprom_source {
+	MT_EE_SRC_PROM,
+	MT_EE_SRC_EFUSE,
+	MT_EE_SRC_FLASH,
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
new file mode 100644
index 000000000000..41d92fb9c280
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -0,0 +1,608 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include <linux/etherdevice.h>
+#include "mt7603.h"
+#include "mac.h"
+#include "eeprom.h"
+
+struct mt7603_dev *mt7603_alloc_device(struct device *pdev)
+{
+	static const struct mt76_driver_ops drv_ops = {
+		.txwi_size = MT_TXD_SIZE,
+		.tx_prepare_skb = mt7603_tx_prepare_skb,
+		.tx_complete_skb = mt7603_tx_complete_skb,
+		.rx_skb = mt7603_queue_rx_skb,
+		.rx_poll_complete = mt7603_rx_poll_complete,
+		.sta_ps = mt7603_sta_ps,
+		.sta_add = mt7603_sta_add,
+		.sta_assoc = mt7603_sta_assoc,
+		.sta_remove = mt7603_sta_remove,
+		.update_survey = mt7603_update_channel,
+	};
+	struct mt7603_dev *dev;
+	struct mt76_dev *mdev;
+
+	mdev = mt76_alloc_device(sizeof(*dev), &mt7603_ops);
+	if (!mdev)
+		return NULL;
+
+	dev = container_of(mdev, struct mt7603_dev, mt76);
+	mdev->dev = pdev;
+	mdev->drv = &drv_ops;
+
+	return dev;
+}
+
+static void
+mt7603_set_tmac_template(struct mt7603_dev *dev)
+{
+	u32 desc[5] = {
+		[1] = FIELD_PREP(MT_TXD3_REM_TX_COUNT, 0xf),
+		[3] = MT_TXD5_SW_POWER_MGMT
+	};
+	u32 addr;
+	int i;
+
+	addr = mt7603_reg_map(dev, MT_CLIENT_BASE_PHYS_ADDR);
+	addr += MT_CLIENT_TMAC_INFO_TEMPLATE;
+	for (i = 0; i < ARRAY_SIZE(desc); i++)
+		mt76_wr(dev, addr + 4 * i, desc[i]);
+}
+
+static void
+mt7603_dma_sched_init(struct mt7603_dev *dev)
+{
+	int page_size = 128;
+	int page_count;
+	int max_len = 1792;
+	int max_amsdu_pages = 4096 / page_size;
+	int max_mcu_len = 4096;
+	int max_beacon_len = 512 * 4 + max_len;
+	int max_mcast_pages = 4 * max_len / page_size;
+	int reserved_count = 0;
+	int beacon_pages;
+	int mcu_pages;
+	int i;
+
+	page_count = mt76_get_field(dev, MT_PSE_FC_P0,
+				    MT_PSE_FC_P0_MAX_QUOTA);
+	beacon_pages = 4 * (max_beacon_len / page_size);
+	mcu_pages = max_mcu_len / page_size;
+
+	mt76_wr(dev, MT_PSE_FRP,
+		FIELD_PREP(MT_PSE_FRP_P0, 7) |
+		FIELD_PREP(MT_PSE_FRP_P1, 6) |
+		FIELD_PREP(MT_PSE_FRP_P2_RQ2, 4));
+
+	mt76_wr(dev, MT_HIGH_PRIORITY_1, 0x55555553);
+	mt76_wr(dev, MT_HIGH_PRIORITY_2, 0x78555555);
+
+	mt76_wr(dev, MT_QUEUE_PRIORITY_1, 0x2b1a096e);
+	mt76_wr(dev, MT_QUEUE_PRIORITY_2, 0x785f4d3c);
+
+	mt76_wr(dev, MT_PRIORITY_MASK, 0xffffffff);
+
+	mt76_wr(dev, MT_SCH_1, page_count | (2 << 28));
+	mt76_wr(dev, MT_SCH_2, max_amsdu_pages);
+
+	for (i = 0; i <= 4; i++)
+		mt76_wr(dev, MT_PAGE_COUNT(i), max_amsdu_pages);
+	reserved_count += 5 * max_amsdu_pages;
+
+	mt76_wr(dev, MT_PAGE_COUNT(5), mcu_pages);
+	reserved_count += mcu_pages;
+
+	mt76_wr(dev, MT_PAGE_COUNT(7), beacon_pages);
+	reserved_count += beacon_pages;
+
+	mt76_wr(dev, MT_PAGE_COUNT(8), max_mcast_pages);
+	reserved_count += max_mcast_pages;
+
+	if (is_mt7603(dev))
+		reserved_count = 0;
+
+	mt76_wr(dev, MT_RSV_MAX_THRESH, page_count - reserved_count);
+
+	if (is_mt7603(dev) && mt76xx_rev(dev) >= MT7603_REV_E2) {
+		mt76_wr(dev, MT_GROUP_THRESH(0),
+			page_count - beacon_pages - mcu_pages);
+		mt76_wr(dev, MT_GROUP_THRESH(1), beacon_pages);
+		mt76_wr(dev, MT_BMAP_0, 0x0080ff5f);
+		mt76_wr(dev, MT_GROUP_THRESH(2), mcu_pages);
+		mt76_wr(dev, MT_BMAP_1, 0x00000020);
+	} else {
+		mt76_wr(dev, MT_GROUP_THRESH(0), page_count);
+		mt76_wr(dev, MT_BMAP_0, 0xffff);
+	}
+
+	mt76_wr(dev, MT_SCH_4, 0);
+
+	for (i = 0; i <= 15; i++)
+		mt76_wr(dev, MT_TXTIME_THRESH(i), 0xfffff);
+
+	mt76_set(dev, MT_SCH_4, BIT(6));
+}
+
+static void
+mt7603_phy_init(struct mt7603_dev *dev)
+{
+	int rx_chains = dev->mt76.antenna_mask;
+	int tx_chains = __sw_hweight8(rx_chains) - 1;
+
+	mt76_rmw(dev, MT_WF_RMAC_RMCR,
+		 (MT_WF_RMAC_RMCR_SMPS_MODE |
+		  MT_WF_RMAC_RMCR_RX_STREAMS),
+		 (FIELD_PREP(MT_WF_RMAC_RMCR_SMPS_MODE, 3) |
+		  FIELD_PREP(MT_WF_RMAC_RMCR_RX_STREAMS, rx_chains)));
+
+	mt76_rmw_field(dev, MT_TMAC_TCR, MT_TMAC_TCR_TX_STREAMS,
+		       tx_chains);
+
+	dev->agc0 = mt76_rr(dev, MT_AGC(0));
+	dev->agc3 = mt76_rr(dev, MT_AGC(3));
+}
+
+static void
+mt7603_mac_init(struct mt7603_dev *dev)
+{
+	u8 bc_addr[ETH_ALEN];
+	u32 addr;
+	int i;
+
+	mt76_wr(dev, MT_AGG_BA_SIZE_LIMIT_0,
+		(MT_AGG_SIZE_LIMIT(0) << 0 * MT_AGG_BA_SIZE_LIMIT_SHIFT) |
+		(MT_AGG_SIZE_LIMIT(1) << 1 * MT_AGG_BA_SIZE_LIMIT_SHIFT) |
+		(MT_AGG_SIZE_LIMIT(2) << 2 * MT_AGG_BA_SIZE_LIMIT_SHIFT) |
+		(MT_AGG_SIZE_LIMIT(3) << 3 * MT_AGG_BA_SIZE_LIMIT_SHIFT));
+
+	mt76_wr(dev, MT_AGG_BA_SIZE_LIMIT_1,
+		(MT_AGG_SIZE_LIMIT(4) << 0 * MT_AGG_BA_SIZE_LIMIT_SHIFT) |
+		(MT_AGG_SIZE_LIMIT(5) << 1 * MT_AGG_BA_SIZE_LIMIT_SHIFT) |
+		(MT_AGG_SIZE_LIMIT(6) << 2 * MT_AGG_BA_SIZE_LIMIT_SHIFT) |
+		(MT_AGG_SIZE_LIMIT(7) << 3 * MT_AGG_BA_SIZE_LIMIT_SHIFT));
+
+	mt76_wr(dev, MT_AGG_LIMIT,
+		FIELD_PREP(MT_AGG_LIMIT_AC(0), 24) |
+		FIELD_PREP(MT_AGG_LIMIT_AC(1), 24) |
+		FIELD_PREP(MT_AGG_LIMIT_AC(2), 24) |
+		FIELD_PREP(MT_AGG_LIMIT_AC(3), 24));
+
+	mt76_wr(dev, MT_AGG_LIMIT_1,
+		FIELD_PREP(MT_AGG_LIMIT_AC(0), 24) |
+		FIELD_PREP(MT_AGG_LIMIT_AC(1), 24) |
+		FIELD_PREP(MT_AGG_LIMIT_AC(2), 24) |
+		FIELD_PREP(MT_AGG_LIMIT_AC(3), 24));
+
+	mt76_wr(dev, MT_AGG_CONTROL,
+		FIELD_PREP(MT_AGG_CONTROL_BAR_RATE, 0x4b) |
+		FIELD_PREP(MT_AGG_CONTROL_CFEND_RATE, 0x69) |
+		MT_AGG_CONTROL_NO_BA_AR_RULE);
+
+	mt76_wr(dev, MT_AGG_RETRY_CONTROL,
+		FIELD_PREP(MT_AGG_RETRY_CONTROL_BAR_LIMIT, 1) |
+		FIELD_PREP(MT_AGG_RETRY_CONTROL_RTS_LIMIT, 15));
+
+	mt76_rmw(dev, MT_DMA_DCR0, ~0xfffc, 4096);
+
+	mt76_rmw(dev, MT_DMA_VCFR0, BIT(0), BIT(13));
+	mt76_rmw(dev, MT_DMA_TMCFR0, BIT(0) | BIT(1), BIT(13));
+
+	mt76_clear(dev, MT_WF_RMAC_TMR_PA, BIT(31));
+
+	mt76_set(dev, MT_WF_RMACDR, MT_WF_RMACDR_MAXLEN_20BIT);
+	mt76_rmw(dev, MT_WF_RMAC_MAXMINLEN, 0xffffff, 0x19000);
+
+	mt76_wr(dev, MT_WF_RFCR1, 0);
+
+	mt76_set(dev, MT_TMAC_TCR, MT_TMAC_TCR_RX_RIFS_MODE);
+
+	mt7603_set_tmac_template(dev);
+
+	/* Enable RX group to HIF */
+	addr = mt7603_reg_map(dev, MT_CLIENT_BASE_PHYS_ADDR);
+	mt76_set(dev, addr + MT_CLIENT_RXINF, MT_CLIENT_RXINF_RXSH_GROUPS);
+
+	/* Enable RX group to MCU */
+	mt76_set(dev, MT_DMA_DCR1, GENMASK(13, 11));
+
+	mt76_rmw_field(dev, MT_AGG_PCR_RTS, MT_AGG_PCR_RTS_PKT_THR, 3);
+	mt76_set(dev, MT_TMAC_PCR, MT_TMAC_PCR_SPE_EN);
+
+	/* include preamble detection in CCA trigger signal */
+	mt76_rmw_field(dev, MT_TXREQ, MT_TXREQ_CCA_SRC_SEL, 2);
+
+	mt76_wr(dev, MT_RXREQ, 4);
+
+	/* Configure all rx packets to HIF */
+	mt76_wr(dev, MT_DMA_RCFR0, 0xc0000000);
+
+	/* Configure MCU txs selection with aggregation */
+	mt76_wr(dev, MT_DMA_TCFR0,
+		FIELD_PREP(MT_DMA_TCFR_TXS_AGGR_TIMEOUT, 1) | /* 32 us */
+		MT_DMA_TCFR_TXS_AGGR_COUNT);
+
+	/* Configure HIF txs selection with aggregation */
+	mt76_wr(dev, MT_DMA_TCFR1,
+		FIELD_PREP(MT_DMA_TCFR_TXS_AGGR_TIMEOUT, 1) | /* 32 us */
+		MT_DMA_TCFR_TXS_AGGR_COUNT | /* Maximum count */
+		MT_DMA_TCFR_TXS_BIT_MAP);
+
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_1, MT_PSE_WTBL_2_PHYS_ADDR);
+
+	for (i = 0; i < MT7603_WTBL_SIZE; i++)
+		mt7603_wtbl_clear(dev, i);
+
+	eth_broadcast_addr(bc_addr);
+	mt7603_wtbl_init(dev, MT7603_WTBL_RESERVED, -1, bc_addr);
+	dev->global_sta.wcid.idx = MT7603_WTBL_RESERVED;
+	rcu_assign_pointer(dev->mt76.wcid[MT7603_WTBL_RESERVED],
+			   &dev->global_sta.wcid);
+
+	mt76_rmw_field(dev, MT_LPON_BTEIR, MT_LPON_BTEIR_MBSS_MODE, 2);
+	mt76_rmw_field(dev, MT_WF_RMACDR, MT_WF_RMACDR_MBSSID_MASK, 2);
+
+	mt76_wr(dev, MT_AGG_ARUCR, FIELD_PREP(MT_AGG_ARxCR_LIMIT(0), 7));
+	mt76_wr(dev, MT_AGG_ARDCR,
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(0), 0) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(1),
+			   max_t(int, 0, MT7603_RATE_RETRY - 2)) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(2), MT7603_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(3), MT7603_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(4), MT7603_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(5), MT7603_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(6), MT7603_RATE_RETRY - 1) |
+		FIELD_PREP(MT_AGG_ARxCR_LIMIT(7), MT7603_RATE_RETRY - 1));
+
+	mt76_wr(dev, MT_AGG_ARCR,
+		(MT_AGG_ARCR_INIT_RATE1 |
+		 FIELD_PREP(MT_AGG_ARCR_RTS_RATE_THR, 2) |
+		 MT_AGG_ARCR_RATE_DOWN_RATIO_EN |
+		 FIELD_PREP(MT_AGG_ARCR_RATE_DOWN_RATIO, 1) |
+		 FIELD_PREP(MT_AGG_ARCR_RATE_UP_EXTRA_TH, 4)));
+
+	mt76_set(dev, MT_WTBL_RMVTCR, MT_WTBL_RMVTCR_RX_MV_MODE);
+
+	mt76_clear(dev, MT_SEC_SCR, MT_SEC_SCR_MASK_ORDER);
+	mt76_clear(dev, MT_SEC_SCR, BIT(18));
+
+	/* Set secondary beacon time offsets */
+	for (i = 0; i <= 4; i++)
+		mt76_rmw_field(dev, MT_LPON_SBTOR(i), MT_LPON_SBTOR_TIME_OFFSET,
+			       (i + 1) * (20 + 4096));
+}
+
+static int
+mt7603_init_hardware(struct mt7603_dev *dev)
+{
+	int i, ret;
+
+	mt76_wr(dev, MT_INT_SOURCE_CSR, ~0);
+
+	ret = mt7603_eeprom_init(dev);
+	if (ret < 0)
+		return ret;
+
+	ret = mt7603_dma_init(dev);
+	if (ret)
+		return ret;
+
+	mt76_wr(dev, MT_WPDMA_GLO_CFG, 0x52000850);
+	mt7603_mac_dma_start(dev);
+	dev->rxfilter = mt76_rr(dev, MT_WF_RFCR);
+	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+
+	for (i = 0; i < MT7603_WTBL_SIZE; i++) {
+		mt76_wr(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY | MT_PSE_RTA_WRITE |
+			FIELD_PREP(MT_PSE_RTA_TAG_ID, i));
+		mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
+	}
+
+	ret = mt7603_mcu_init(dev);
+	if (ret)
+		return ret;
+
+	mt7603_dma_sched_init(dev);
+	mt7603_mcu_set_eeprom(dev);
+	mt7603_phy_init(dev);
+	mt7603_mac_init(dev);
+
+	return 0;
+}
+
+#define CCK_RATE(_idx, _rate) {					\
+	.bitrate = _rate,					\
+	.flags = IEEE80211_RATE_SHORT_PREAMBLE,			\
+	.hw_value = (MT_PHY_TYPE_CCK << 8) | (_idx),		\
+	.hw_value_short = (MT_PHY_TYPE_CCK << 8) | (4 + _idx),	\
+}
+
+#define OFDM_RATE(_idx, _rate) {				\
+	.bitrate = _rate,					\
+	.hw_value = (MT_PHY_TYPE_OFDM << 8) | (_idx),		\
+	.hw_value_short = (MT_PHY_TYPE_OFDM << 8) | (_idx),	\
+}
+
+static struct ieee80211_rate mt7603_rates[] = {
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
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_ADHOC)
+	}, {
+		.max = MT7603_MAX_INTERFACES,
+		.types = BIT(NL80211_IFTYPE_STATION) |
+#ifdef CONFIG_MAC80211_MESH
+			 BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+			 BIT(NL80211_IFTYPE_AP)
+	 },
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
+static void mt7603_led_set_config(struct mt76_dev *mt76, u8 delay_on,
+				  u8 delay_off)
+{
+	struct mt7603_dev *dev = container_of(mt76, struct mt7603_dev,
+					      mt76);
+	u32 val, addr;
+
+	val = MT_LED_STATUS_DURATION(0xffff) |
+	      MT_LED_STATUS_OFF(delay_off) |
+	      MT_LED_STATUS_ON(delay_on);
+
+	addr = mt7603_reg_map(dev, MT_LED_STATUS_0(mt76->led_pin));
+	mt76_wr(dev, addr, val);
+	addr = mt7603_reg_map(dev, MT_LED_STATUS_1(mt76->led_pin));
+	mt76_wr(dev, addr, val);
+
+	val = MT_LED_CTRL_REPLAY(mt76->led_pin) |
+	      MT_LED_CTRL_KICK(mt76->led_pin);
+	if (mt76->led_al)
+		val |= MT_LED_CTRL_POLARITY(mt76->led_pin);
+	addr = mt7603_reg_map(dev, MT_LED_CTRL);
+	mt76_wr(dev, addr, val);
+}
+
+static int mt7603_led_set_blink(struct led_classdev *led_cdev,
+				unsigned long *delay_on,
+				unsigned long *delay_off)
+{
+	struct mt76_dev *mt76 = container_of(led_cdev, struct mt76_dev,
+					     led_cdev);
+	u8 delta_on, delta_off;
+
+	delta_off = max_t(u8, *delay_off / 10, 1);
+	delta_on = max_t(u8, *delay_on / 10, 1);
+
+	mt7603_led_set_config(mt76, delta_on, delta_off);
+	return 0;
+}
+
+static void mt7603_led_set_brightness(struct led_classdev *led_cdev,
+				      enum led_brightness brightness)
+{
+	struct mt76_dev *mt76 = container_of(led_cdev, struct mt76_dev,
+					     led_cdev);
+
+	if (!brightness)
+		mt7603_led_set_config(mt76, 0, 0xff);
+	else
+		mt7603_led_set_config(mt76, 0xff, 0);
+}
+
+static u32 __mt7603_reg_addr(struct mt7603_dev *dev, u32 addr)
+{
+	if (addr < 0x100000)
+		return addr;
+
+	return mt7603_reg_map(dev, addr);
+}
+
+static u32 mt7603_rr(struct mt76_dev *mdev, u32 offset)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	u32 addr = __mt7603_reg_addr(dev, offset);
+
+	return dev->bus_ops->rr(mdev, addr);
+}
+
+static void mt7603_wr(struct mt76_dev *mdev, u32 offset, u32 val)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	u32 addr = __mt7603_reg_addr(dev, offset);
+
+	dev->bus_ops->wr(mdev, addr, val);
+}
+
+static u32 mt7603_rmw(struct mt76_dev *mdev, u32 offset, u32 mask, u32 val)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	u32 addr = __mt7603_reg_addr(dev, offset);
+
+	return dev->bus_ops->rmw(mdev, addr, mask, val);
+}
+
+static void
+mt7603_regd_notifier(struct wiphy *wiphy,
+		     struct regulatory_request *request)
+{
+	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
+	struct mt7603_dev *dev = hw->priv;
+
+	dev->ed_monitor = request->dfs_region == NL80211_DFS_ETSI;
+}
+
+static int
+mt7603_txpower_signed(int val)
+{
+	bool sign = val & BIT(6);
+
+	if (!(val & BIT(7)))
+		return 0;
+
+	val &= GENMASK(5, 0);
+	if (!sign)
+		val = -val;
+
+	return val;
+}
+
+static void
+mt7603_init_txpower(struct mt7603_dev *dev,
+		    struct ieee80211_supported_band *sband)
+{
+	struct ieee80211_channel *chan;
+	u8 *eeprom = (u8 *)dev->mt76.eeprom.data;
+	int target_power = eeprom[MT_EE_TX_POWER_0_START_2G + 2] & ~BIT(7);
+	u8 *rate_power = &eeprom[MT_EE_TX_POWER_CCK];
+	int max_offset, cur_offset;
+	int i;
+
+	if (target_power & BIT(6))
+		target_power = -(target_power & GENMASK(5, 0));
+
+	max_offset = 0;
+	for (i = 0; i < 14; i++) {
+		cur_offset = mt7603_txpower_signed(rate_power[i]);
+		max_offset = max(max_offset, cur_offset);
+	}
+
+	target_power += max_offset;
+
+	dev->tx_power_limit = target_power;
+	dev->mt76.txpower_cur = target_power;
+
+	target_power = DIV_ROUND_UP(target_power, 2);
+
+	/* add 3 dBm for 2SS devices (combined output) */
+	if (dev->mt76.antenna_mask & BIT(1))
+		target_power += 3;
+
+	for (i = 0; i < sband->n_channels; i++) {
+		chan = &sband->channels[i];
+		chan->max_power = target_power;
+	}
+}
+
+
+int mt7603_register_device(struct mt7603_dev *dev)
+{
+	struct mt76_bus_ops *bus_ops;
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	struct wiphy *wiphy = hw->wiphy;
+	int ret;
+
+	dev->bus_ops = dev->mt76.bus;
+	bus_ops = devm_kmemdup(dev->mt76.dev, dev->bus_ops, sizeof(*bus_ops),
+			       GFP_KERNEL);
+	if (!bus_ops)
+		return -ENOMEM;
+
+	bus_ops->rr = mt7603_rr;
+	bus_ops->wr = mt7603_wr;
+	bus_ops->rmw = mt7603_rmw;
+	dev->mt76.bus = bus_ops;
+
+	INIT_DELAYED_WORK(&dev->mac_work, mt7603_mac_work);
+	tasklet_init(&dev->pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet,
+		     (unsigned long)dev);
+
+	/* Check for 7688, which only has 1SS */
+	dev->mt76.antenna_mask = 3;
+	if (mt76_rr(dev, MT_EFUSE_BASE + 0x64) & BIT(4))
+		dev->mt76.antenna_mask = 1;
+
+	dev->slottime = 9;
+
+	ret = mt7603_init_hardware(dev);
+	if (ret)
+		return ret;
+
+	hw->queues = 4;
+	hw->max_rates = 3;
+	hw->max_report_rates = 7;
+	hw->max_rate_tries = 11;
+
+	hw->sta_data_size = sizeof(struct mt7603_sta);
+	hw->vif_data_size = sizeof(struct mt7603_vif);
+
+	wiphy->iface_combinations = if_comb;
+	wiphy->n_iface_combinations = ARRAY_SIZE(if_comb);
+
+	ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
+	ieee80211_hw_set(hw, TX_STATUS_NO_AMPDU_LEN);
+
+	/* init led callbacks */
+	if (IS_ENABLED(CONFIG_MT76_LEDS)) {
+		dev->mt76.led_cdev.brightness_set = mt7603_led_set_brightness;
+		dev->mt76.led_cdev.blink_set = mt7603_led_set_blink;
+	}
+
+	wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		BIT(NL80211_IFTYPE_ADHOC);
+
+	wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+
+	wiphy->reg_notifier = mt7603_regd_notifier;
+
+	ret = mt76_register_device(&dev->mt76, true, mt7603_rates,
+				   ARRAY_SIZE(mt7603_rates));
+	if (ret)
+		return ret;
+
+	mt7603_init_debugfs(dev);
+	mt7603_init_txpower(dev, &dev->mt76.sband_2g.sband);
+
+	return 0;
+}
+
+void mt7603_unregister_device(struct mt7603_dev *dev)
+{
+	tasklet_disable(&dev->pre_tbtt_tasklet);
+	mt76_unregister_device(&dev->mt76);
+	mt7603_mcu_exit(dev);
+	mt7603_dma_cleanup(dev);
+	ieee80211_free_hw(mt76_hw(dev));
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
new file mode 100644
index 000000000000..d1ea0e32b2ca
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -0,0 +1,1764 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include <linux/etherdevice.h>
+#include <linux/timekeeping.h>
+#include "mt7603.h"
+#include "mac.h"
+
+#define MT_PSE_PAGE_SIZE	128
+
+static u32
+mt7603_ac_queue_mask0(u32 mask)
+{
+	u32 ret = 0;
+
+	ret |= GENMASK(3, 0) * !!(mask & BIT(0));
+	ret |= GENMASK(8, 5) * !!(mask & BIT(1));
+	ret |= GENMASK(13, 10) * !!(mask & BIT(2));
+	ret |= GENMASK(19, 16) * !!(mask & BIT(3));
+	return ret;
+}
+
+static void
+mt76_stop_tx_ac(struct mt7603_dev *dev, u32 mask)
+{
+	mt76_set(dev, MT_WF_ARB_TX_STOP_0, mt7603_ac_queue_mask0(mask));
+}
+
+static void
+mt76_start_tx_ac(struct mt7603_dev *dev, u32 mask)
+{
+	mt76_set(dev, MT_WF_ARB_TX_START_0, mt7603_ac_queue_mask0(mask));
+}
+
+void mt7603_mac_set_timing(struct mt7603_dev *dev)
+{
+	u32 cck = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, 231) |
+		  FIELD_PREP(MT_TIMEOUT_VAL_CCA, 48);
+	u32 ofdm = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, 60) |
+		   FIELD_PREP(MT_TIMEOUT_VAL_CCA, 24);
+	int offset = 3 * dev->coverage_class;
+	u32 reg_offset = FIELD_PREP(MT_TIMEOUT_VAL_PLCP, offset) |
+			 FIELD_PREP(MT_TIMEOUT_VAL_CCA, offset);
+	int sifs;
+	u32 val;
+
+	if (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ)
+		sifs = 16;
+	else
+		sifs = 10;
+
+	mt76_set(dev, MT_ARB_SCR,
+		 MT_ARB_SCR_TX_DISABLE | MT_ARB_SCR_RX_DISABLE);
+	udelay(1);
+
+	mt76_wr(dev, MT_TIMEOUT_CCK, cck + reg_offset);
+	mt76_wr(dev, MT_TIMEOUT_OFDM, ofdm + reg_offset);
+	mt76_wr(dev, MT_IFS,
+		FIELD_PREP(MT_IFS_EIFS, 360) |
+		FIELD_PREP(MT_IFS_RIFS, 2) |
+		FIELD_PREP(MT_IFS_SIFS, sifs) |
+		FIELD_PREP(MT_IFS_SLOT, dev->slottime));
+
+	if (dev->slottime < 20)
+		val = MT7603_CFEND_RATE_DEFAULT;
+	else
+		val = MT7603_CFEND_RATE_11B;
+
+	mt76_rmw_field(dev, MT_AGG_CONTROL, MT_AGG_CONTROL_CFEND_RATE, val);
+
+	mt76_clear(dev, MT_ARB_SCR,
+		   MT_ARB_SCR_TX_DISABLE | MT_ARB_SCR_RX_DISABLE);
+}
+
+static void
+mt7603_wtbl_update(struct mt7603_dev *dev, int idx, u32 mask)
+{
+	mt76_rmw(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_WLAN_IDX,
+		 FIELD_PREP(MT_WTBL_UPDATE_WLAN_IDX, idx) | mask);
+
+	mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
+}
+
+static u32
+mt7603_wtbl1_addr(int idx)
+{
+	return MT_WTBL1_BASE + idx * MT_WTBL1_SIZE;
+}
+
+static u32
+mt7603_wtbl2_addr(int idx)
+{
+	/* Mapped to WTBL2 */
+	return MT_PCIE_REMAP_BASE_1 + idx * MT_WTBL2_SIZE;
+}
+
+static u32
+mt7603_wtbl3_addr(int idx)
+{
+	u32 base = mt7603_wtbl2_addr(MT7603_WTBL_SIZE);
+
+	return base + idx * MT_WTBL3_SIZE;
+}
+
+static u32
+mt7603_wtbl4_addr(int idx)
+{
+	u32 base = mt7603_wtbl3_addr(MT7603_WTBL_SIZE);
+
+	return base + idx * MT_WTBL4_SIZE;
+}
+
+void mt7603_wtbl_init(struct mt7603_dev *dev, int idx, int vif,
+		      const u8 *mac_addr)
+{
+	const void *_mac = mac_addr;
+	u32 addr = mt7603_wtbl1_addr(idx);
+	u32 w0 = 0, w1 = 0;
+	int i;
+
+	if (_mac) {
+		w0 = FIELD_PREP(MT_WTBL1_W0_ADDR_HI,
+				get_unaligned_le16(_mac + 4));
+		w1 = FIELD_PREP(MT_WTBL1_W1_ADDR_LO,
+				get_unaligned_le32(_mac));
+	}
+
+	if (vif < 0)
+		vif = 0;
+	else
+		w0 |= MT_WTBL1_W0_RX_CHECK_A1;
+	w0 |= FIELD_PREP(MT_WTBL1_W0_MUAR_IDX, vif);
+
+	mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
+
+	mt76_set(dev, addr + 0 * 4, w0);
+	mt76_set(dev, addr + 1 * 4, w1);
+	mt76_set(dev, addr + 2 * 4, MT_WTBL1_W2_ADMISSION_CONTROL);
+
+	mt76_stop_tx_ac(dev, GENMASK(3, 0));
+	addr = mt7603_wtbl2_addr(idx);
+	for (i = 0; i < MT_WTBL2_SIZE; i += 4)
+		mt76_wr(dev, addr + i, 0);
+	mt7603_wtbl_update(dev, idx, MT_WTBL_UPDATE_WTBL2);
+	mt76_start_tx_ac(dev, GENMASK(3, 0));
+
+	addr = mt7603_wtbl3_addr(idx);
+	for (i = 0; i < MT_WTBL3_SIZE; i += 4)
+		mt76_wr(dev, addr + i, 0);
+
+	addr = mt7603_wtbl4_addr(idx);
+	for (i = 0; i < MT_WTBL4_SIZE; i += 4)
+		mt76_wr(dev, addr + i, 0);
+}
+
+static void
+mt7603_wtbl_set_skip_tx(struct mt7603_dev *dev, int idx, bool enabled)
+{
+	u32 addr = mt7603_wtbl1_addr(idx);
+	u32 val = mt76_rr(dev, addr + 3 * 4);
+
+	val &= ~MT_WTBL1_W3_SKIP_TX;
+	val |= enabled * MT_WTBL1_W3_SKIP_TX;
+
+	mt76_wr(dev, addr + 3 * 4, val);
+}
+
+void mt7603_filter_tx(struct mt7603_dev *dev, int idx, bool abort)
+{
+	int i, port, queue;
+
+	if (abort) {
+		port = 3; /* PSE */
+		queue = 8; /* free queue */
+	} else {
+		port = 0; /* HIF */
+		queue = 1; /* MCU queue */
+	}
+
+	mt7603_wtbl_set_skip_tx(dev, idx, true);
+
+	mt76_wr(dev, MT_TX_ABORT, MT_TX_ABORT_EN |
+			FIELD_PREP(MT_TX_ABORT_WCID, idx));
+
+	for (i = 0; i < 4; i++) {
+		mt76_wr(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY |
+			FIELD_PREP(MT_DMA_FQCR0_TARGET_WCID, idx) |
+			FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, i) |
+			FIELD_PREP(MT_DMA_FQCR0_DEST_PORT_ID, port) |
+			FIELD_PREP(MT_DMA_FQCR0_DEST_QUEUE_ID, queue));
+
+		WARN_ON_ONCE(!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY,
+					0, 5000));
+	}
+
+	mt76_wr(dev, MT_TX_ABORT, 0);
+
+	mt7603_wtbl_set_skip_tx(dev, idx, false);
+}
+
+void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			  bool enabled)
+{
+	u32 addr = mt7603_wtbl1_addr(sta->wcid.idx);
+
+	if (sta->smps == enabled)
+		return;
+
+	mt76_rmw_field(dev, addr + 2 * 4, MT_WTBL1_W2_SMPS, enabled);
+	sta->smps = enabled;
+}
+
+void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool enabled)
+{
+	int idx = sta->wcid.idx;
+	u32 addr;
+
+	spin_lock_bh(&dev->ps_lock);
+
+	if (sta->ps == enabled)
+		goto out;
+
+	mt76_wr(dev, MT_PSE_RTA,
+		FIELD_PREP(MT_PSE_RTA_TAG_ID, idx) |
+		FIELD_PREP(MT_PSE_RTA_PORT_ID, 0) |
+		FIELD_PREP(MT_PSE_RTA_QUEUE_ID, 1) |
+		FIELD_PREP(MT_PSE_RTA_REDIRECT_EN, enabled) |
+		MT_PSE_RTA_WRITE | MT_PSE_RTA_BUSY);
+
+	mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
+
+	if (enabled)
+		mt7603_filter_tx(dev, idx, false);
+
+	addr = mt7603_wtbl1_addr(idx);
+	mt76_set(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
+	mt76_rmw(dev, addr + 3 * 4, MT_WTBL1_W3_POWER_SAVE,
+		 enabled * MT_WTBL1_W3_POWER_SAVE);
+	mt76_clear(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
+	sta->ps = enabled;
+
+out:
+	spin_unlock_bh(&dev->ps_lock);
+}
+
+void mt7603_wtbl_clear(struct mt7603_dev *dev, int idx)
+{
+	int wtbl2_frame_size = MT_PSE_PAGE_SIZE / MT_WTBL2_SIZE;
+	int wtbl2_frame = idx / wtbl2_frame_size;
+	int wtbl2_entry = idx % wtbl2_frame_size;
+
+	int wtbl3_base_frame = MT_WTBL3_OFFSET / MT_PSE_PAGE_SIZE;
+	int wtbl3_frame_size = MT_PSE_PAGE_SIZE / MT_WTBL3_SIZE;
+	int wtbl3_frame = wtbl3_base_frame + idx / wtbl3_frame_size;
+	int wtbl3_entry = (idx % wtbl3_frame_size) * 2;
+
+	int wtbl4_base_frame = MT_WTBL4_OFFSET / MT_PSE_PAGE_SIZE;
+	int wtbl4_frame_size = MT_PSE_PAGE_SIZE / MT_WTBL4_SIZE;
+	int wtbl4_frame = wtbl4_base_frame + idx / wtbl4_frame_size;
+	int wtbl4_entry = idx % wtbl4_frame_size;
+
+	u32 addr = MT_WTBL1_BASE + idx * MT_WTBL1_SIZE;
+	int i;
+
+	mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
+
+	mt76_wr(dev, addr + 0 * 4,
+		MT_WTBL1_W0_RX_CHECK_A1 |
+		MT_WTBL1_W0_RX_CHECK_A2 |
+		MT_WTBL1_W0_RX_VALID);
+	mt76_wr(dev, addr + 1 * 4, 0);
+	mt76_wr(dev, addr + 2 * 4, 0);
+
+	mt76_set(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
+
+	mt76_wr(dev, addr + 3 * 4,
+		FIELD_PREP(MT_WTBL1_W3_WTBL2_FRAME_ID, wtbl2_frame) |
+		FIELD_PREP(MT_WTBL1_W3_WTBL2_ENTRY_ID, wtbl2_entry) |
+		FIELD_PREP(MT_WTBL1_W3_WTBL4_FRAME_ID, wtbl4_frame) |
+		MT_WTBL1_W3_I_PSM | MT_WTBL1_W3_KEEP_I_PSM);
+	mt76_wr(dev, addr + 4 * 4,
+		FIELD_PREP(MT_WTBL1_W4_WTBL3_FRAME_ID, wtbl3_frame) |
+		FIELD_PREP(MT_WTBL1_W4_WTBL3_ENTRY_ID, wtbl3_entry) |
+		FIELD_PREP(MT_WTBL1_W4_WTBL4_ENTRY_ID, wtbl4_entry));
+
+	mt76_clear(dev, MT_WTBL1_OR, MT_WTBL1_OR_PSM_WRITE);
+
+	addr = mt7603_wtbl2_addr(idx);
+
+	/* Clear BA information */
+	mt76_wr(dev, addr + (15 * 4), 0);
+
+	mt76_stop_tx_ac(dev, GENMASK(3, 0));
+	for (i = 2; i <= 4; i++)
+		mt76_wr(dev, addr + (i * 4), 0);
+	mt7603_wtbl_update(dev, idx, MT_WTBL_UPDATE_WTBL2);
+	mt76_start_tx_ac(dev, GENMASK(3, 0));
+
+	mt7603_wtbl_update(dev, idx, MT_WTBL_UPDATE_RX_COUNT_CLEAR);
+	mt7603_wtbl_update(dev, idx, MT_WTBL_UPDATE_TX_COUNT_CLEAR);
+	mt7603_wtbl_update(dev, idx, MT_WTBL_UPDATE_ADM_COUNT_CLEAR);
+}
+
+void mt7603_wtbl_update_cap(struct mt7603_dev *dev, struct ieee80211_sta *sta)
+{
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+	int idx = msta->wcid.idx;
+	u32 addr;
+	u32 val;
+
+	addr = mt7603_wtbl1_addr(idx);
+
+	val = mt76_rr(dev, addr + 2 * 4);
+	val &= MT_WTBL1_W2_KEY_TYPE | MT_WTBL1_W2_ADMISSION_CONTROL;
+	val |= FIELD_PREP(MT_WTBL1_W2_AMPDU_FACTOR, sta->ht_cap.ampdu_factor) |
+	       FIELD_PREP(MT_WTBL1_W2_MPDU_DENSITY, sta->ht_cap.ampdu_density) |
+	       MT_WTBL1_W2_TXS_BAF_REPORT;
+
+	if (sta->ht_cap.cap)
+		val |= MT_WTBL1_W2_HT;
+	if (sta->vht_cap.cap)
+		val |= MT_WTBL1_W2_VHT;
+
+	mt76_wr(dev, addr + 2 * 4, val);
+
+	addr = mt7603_wtbl2_addr(idx);
+	val = mt76_rr(dev, addr + 9 * 4);
+	val &= ~(MT_WTBL2_W9_SHORT_GI_20 | MT_WTBL2_W9_SHORT_GI_40 |
+		 MT_WTBL2_W9_SHORT_GI_80);
+	if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20)
+		val |= MT_WTBL2_W9_SHORT_GI_20;
+	if (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40)
+		val |= MT_WTBL2_W9_SHORT_GI_40;
+	mt76_wr(dev, addr + 9 * 4, val);
+}
+
+void mt7603_mac_rx_ba_reset(struct mt7603_dev *dev, void *addr, u8 tid)
+{
+	mt76_wr(dev, MT_BA_CONTROL_0, get_unaligned_le32(addr));
+	mt76_wr(dev, MT_BA_CONTROL_1,
+		(get_unaligned_le16(addr + 4) |
+		 FIELD_PREP(MT_BA_CONTROL_1_TID, tid) |
+		 MT_BA_CONTROL_1_RESET));
+}
+
+void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid, int ssn,
+			    int ba_size)
+{
+	u32 addr = mt7603_wtbl2_addr(wcid);
+	u32 tid_mask = FIELD_PREP(MT_WTBL2_W15_BA_EN_TIDS, BIT(tid)) |
+		       (MT_WTBL2_W15_BA_WIN_SIZE <<
+			(tid * MT_WTBL2_W15_BA_WIN_SIZE_SHIFT));
+	u32 tid_val;
+	int i;
+
+	if (ba_size < 0) {
+		/* disable */
+		mt76_clear(dev, addr + (15 * 4), tid_mask);
+		return;
+	}
+	mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
+
+	mt7603_mac_stop(dev);
+	switch (tid) {
+	case 0:
+		mt76_rmw_field(dev, addr + (2 * 4), MT_WTBL2_W2_TID0_SN, ssn);
+		break;
+	case 1:
+		mt76_rmw_field(dev, addr + (2 * 4), MT_WTBL2_W2_TID1_SN, ssn);
+		break;
+	case 2:
+		mt76_rmw_field(dev, addr + (2 * 4), MT_WTBL2_W2_TID2_SN_LO,
+			       ssn);
+		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID2_SN_HI,
+			       ssn >> 8);
+		break;
+	case 3:
+		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID3_SN, ssn);
+		break;
+	case 4:
+		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID4_SN, ssn);
+		break;
+	case 5:
+		mt76_rmw_field(dev, addr + (3 * 4), MT_WTBL2_W3_TID5_SN_LO,
+			       ssn);
+		mt76_rmw_field(dev, addr + (4 * 4), MT_WTBL2_W4_TID5_SN_HI,
+			       ssn >> 4);
+		break;
+	case 6:
+		mt76_rmw_field(dev, addr + (4 * 4), MT_WTBL2_W4_TID6_SN, ssn);
+		break;
+	case 7:
+		mt76_rmw_field(dev, addr + (4 * 4), MT_WTBL2_W4_TID7_SN, ssn);
+		break;
+	}
+	mt7603_wtbl_update(dev, wcid, MT_WTBL_UPDATE_WTBL2);
+	mt7603_mac_start(dev);
+
+	for (i = 7; i > 0; i--) {
+		if (ba_size < MT_AGG_SIZE_LIMIT(i))
+			break;
+	}
+
+	tid_val = FIELD_PREP(MT_WTBL2_W15_BA_EN_TIDS, BIT(tid)) |
+		  i << (tid * MT_WTBL2_W15_BA_WIN_SIZE_SHIFT);
+
+	mt76_rmw(dev, addr + (15 * 4), tid_mask, tid_val);
+}
+
+static int
+mt7603_get_rate(struct mt7603_dev *dev, struct ieee80211_supported_band *sband,
+		int idx, bool cck)
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
+static struct mt76_wcid *
+mt7603_rx_get_wcid(struct mt7603_dev *dev, u8 idx, bool unicast)
+{
+	struct mt7603_sta *sta;
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
+	sta = container_of(wcid, struct mt7603_sta, wcid);
+	if (!sta->vif)
+		return NULL;
+
+	return &sta->vif->sta.wcid;
+}
+
+static void
+mt7603_insert_ccmp_hdr(struct sk_buff *skb, u8 key_id)
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
+int
+mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *)skb->cb;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_hdr *hdr;
+	__le32 *rxd = (__le32 *)skb->data;
+	u32 rxd0 = le32_to_cpu(rxd[0]);
+	u32 rxd1 = le32_to_cpu(rxd[1]);
+	u32 rxd2 = le32_to_cpu(rxd[2]);
+	bool unicast = rxd1 & MT_RXD1_NORMAL_U2M;
+	bool insert_ccmp_hdr = false;
+	bool remove_pad;
+	int idx;
+	int i;
+
+	memset(status, 0, sizeof(*status));
+
+	i = FIELD_GET(MT_RXD1_NORMAL_CH_FREQ, rxd1);
+	sband = (i & 1) ? &dev->mt76.sband_5g.sband : &dev->mt76.sband_2g.sband;
+	i >>= 1;
+
+	idx = FIELD_GET(MT_RXD2_NORMAL_WLAN_IDX, rxd2);
+	status->wcid = mt7603_rx_get_wcid(dev, idx, unicast);
+
+	status->band = sband->band;
+	if (i < sband->n_channels)
+		status->freq = sband->channels[i].center_freq;
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
+
+		rxd += 4;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	}
+	if (rxd0 & MT_RXD0_NORMAL_GROUP_2) {
+		rxd += 2;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	}
+	if (rxd0 & MT_RXD0_NORMAL_GROUP_3) {
+		u32 rxdg0 = le32_to_cpu(rxd[0]);
+		u32 rxdg3 = le32_to_cpu(rxd[3]);
+		bool cck = false;
+
+		i = FIELD_GET(MT_RXV1_TX_RATE, rxdg0);
+		switch (FIELD_GET(MT_RXV1_TX_MODE, rxdg0)) {
+		case MT_PHY_TYPE_CCK:
+			cck = true;
+			/* fall through */
+		case MT_PHY_TYPE_OFDM:
+			i = mt7603_get_rate(dev, sband, i, cck);
+			break;
+		case MT_PHY_TYPE_HT_GF:
+		case MT_PHY_TYPE_HT:
+			status->encoding = RX_ENC_HT;
+			if (i > 15)
+				return -EINVAL;
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
+		status->enc_flags |= RX_ENC_FLAG_STBC_MASK *
+				    FIELD_GET(MT_RXV1_HT_STBC, rxdg0);
+
+		status->rate_idx = i;
+
+		status->chains = dev->mt76.antenna_mask;
+		status->chain_signal[0] = FIELD_GET(MT_RXV4_IB_RSSI0, rxdg3) +
+					  dev->rssi_offset[0];
+		status->chain_signal[1] = FIELD_GET(MT_RXV4_IB_RSSI1, rxdg3) +
+					  dev->rssi_offset[1];
+
+		status->signal = status->chain_signal[0];
+		if (status->chains & BIT(1))
+			status->signal = max(status->signal,
+					     status->chain_signal[1]);
+
+		if (FIELD_GET(MT_RXV1_FRAME_MODE, rxdg0) == 1)
+			status->bw = RATE_INFO_BW_40;
+
+		rxd += 6;
+		if ((u8 *)rxd - skb->data >= skb->len)
+			return -EINVAL;
+	} else {
+		return -EINVAL;
+	}
+
+	skb_pull(skb, (u8 *)rxd - skb->data + 2 * remove_pad);
+
+	if (insert_ccmp_hdr) {
+		u8 key_id = FIELD_GET(MT_RXD1_NORMAL_KEY_ID, rxd1);
+
+		mt7603_insert_ccmp_hdr(skb, key_id);
+	}
+
+	hdr = (struct ieee80211_hdr *)skb->data;
+	if (!status->wcid || !ieee80211_is_data_qos(hdr->frame_control))
+		return 0;
+
+	status->aggr = unicast &&
+		       !ieee80211_is_qos_nullfunc(hdr->frame_control);
+	status->tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
+	status->seqno = hdr->seq_ctrl >> 4;
+
+	return 0;
+}
+
+static u16
+mt7603_mac_tx_rate_val(struct mt7603_dev *dev,
+		       const struct ieee80211_tx_rate *rate, bool stbc, u8 *bw)
+{
+	u8 phy, nss, rate_idx;
+	u16 rateval;
+
+	*bw = 0;
+	if (rate->flags & IEEE80211_TX_RC_MCS) {
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
+		   FIELD_PREP(MT_TX_RATE_MODE, phy));
+
+	if (stbc && nss == 1)
+		rateval |= MT_TX_RATE_STBC;
+
+	return rateval;
+}
+
+void mt7603_wtbl_set_rates(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			   struct ieee80211_tx_rate *probe_rate,
+			   struct ieee80211_tx_rate *rates)
+{
+	int wcid = sta->wcid.idx;
+	u32 addr = mt7603_wtbl2_addr(wcid);
+	bool stbc = false;
+	int n_rates = sta->n_rates;
+	u8 bw, bw_prev, bw_idx = 0;
+	u16 val[4];
+	u16 probe_val;
+	u32 w9 = mt76_rr(dev, addr + 9 * 4);
+	int i;
+
+	if (!mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000))
+		return;
+
+	for (i = n_rates; i < 4; i++)
+		rates[i] = rates[n_rates - 1];
+
+	w9 &= MT_WTBL2_W9_SHORT_GI_20 | MT_WTBL2_W9_SHORT_GI_40 |
+	      MT_WTBL2_W9_SHORT_GI_80;
+
+	val[0] = mt7603_mac_tx_rate_val(dev, &rates[0], stbc, &bw);
+	bw_prev = bw;
+
+	if (probe_rate) {
+		probe_val = mt7603_mac_tx_rate_val(dev, probe_rate, stbc, &bw);
+		if (bw)
+			bw_idx = 1;
+		else
+			bw_prev = 0;
+	} else {
+		probe_val = val[0];
+	}
+
+	w9 |= FIELD_PREP(MT_WTBL2_W9_CC_BW_SEL, bw);
+	w9 |= FIELD_PREP(MT_WTBL2_W9_BW_CAP, bw);
+
+	val[1] = mt7603_mac_tx_rate_val(dev, &rates[1], stbc, &bw);
+	if (bw_prev) {
+		bw_idx = 3;
+		bw_prev = bw;
+	}
+
+	val[2] = mt7603_mac_tx_rate_val(dev, &rates[2], stbc, &bw);
+	if (bw_prev) {
+		bw_idx = 5;
+		bw_prev = bw;
+	}
+
+	val[3] = mt7603_mac_tx_rate_val(dev, &rates[3], stbc, &bw);
+	if (bw_prev)
+		bw_idx = 7;
+
+	w9 |= FIELD_PREP(MT_WTBL2_W9_CHANGE_BW_RATE,
+		       bw_idx ? bw_idx - 1 : 7);
+
+	mt76_wr(dev, MT_WTBL_RIUCR0, w9);
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
+	if (!sta->wcid.tx_rate_set)
+		mt76_poll(dev, MT_WTBL_UPDATE, MT_WTBL_UPDATE_BUSY, 0, 5000);
+
+	sta->rate_count = 2 * MT7603_RATE_RETRY * n_rates;
+	sta->wcid.tx_rate_set = true;
+}
+
+static enum mt7603_cipher_type
+mt7603_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
+{
+	memset(key_data, 0, 32);
+	if (!key)
+		return MT_CIPHER_NONE;
+
+	if (key->keylen > 32)
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
+	default:
+		return MT_CIPHER_NONE;
+	}
+}
+
+int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
+			struct ieee80211_key_conf *key)
+{
+	enum mt7603_cipher_type cipher;
+	u32 addr = mt7603_wtbl3_addr(wcid);
+	u8 key_data[32];
+	int key_len = sizeof(key_data);
+
+	cipher = mt7603_mac_get_key_info(key, key_data);
+	if (cipher == MT_CIPHER_NONE && key)
+		return -EOPNOTSUPP;
+
+	if (key && (cipher == MT_CIPHER_WEP40 || cipher == MT_CIPHER_WEP104)) {
+		addr += key->keyidx * 16;
+		key_len = 16;
+	}
+
+	mt76_wr_copy(dev, addr, key_data, key_len);
+
+	addr = mt7603_wtbl1_addr(wcid);
+	mt76_rmw_field(dev, addr + 2 * 4, MT_WTBL1_W2_KEY_TYPE, cipher);
+	if (key)
+		mt76_rmw_field(dev, addr, MT_WTBL1_W0_KEY_IDX, key->keyidx);
+	mt76_rmw_field(dev, addr, MT_WTBL1_W0_RX_KEY_VALID, !!key);
+
+	return 0;
+}
+
+static int
+mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
+		      struct sk_buff *skb, struct mt76_queue *q,
+		      struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+		      int pid, struct ieee80211_key_conf *key)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_vif *vif = info->control.vif;
+	struct mt7603_vif *mvif;
+	int wlan_idx;
+	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	int tx_count = 8;
+	u8 frame_type, frame_subtype;
+	u16 fc = le16_to_cpu(hdr->frame_control);
+	u8 vif_idx = 0;
+	u32 val;
+	u8 bw;
+
+	if (vif) {
+		mvif = (struct mt7603_vif *)vif->drv_priv;
+		vif_idx = mvif->idx;
+		if (vif_idx && q >= &dev->mt76.q_tx[MT_TXQ_BEACON])
+			vif_idx += 0x10;
+	}
+
+	if (sta) {
+		struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+
+		tx_count = msta->rate_count;
+	}
+
+	if (wcid)
+		wlan_idx = wcid->idx;
+	else
+		wlan_idx = MT7603_WTBL_RESERVED;
+
+	frame_type = (fc & IEEE80211_FCTL_FTYPE) >> 2;
+	frame_subtype = (fc & IEEE80211_FCTL_STYPE) >> 4;
+
+	val = FIELD_PREP(MT_TXD0_TX_BYTES, skb->len + MT_TXD_SIZE) |
+	      FIELD_PREP(MT_TXD0_Q_IDX, q->hw_idx);
+	txwi[0] = cpu_to_le32(val);
+
+	val = MT_TXD1_LONG_FORMAT |
+	      FIELD_PREP(MT_TXD1_OWN_MAC, vif_idx) |
+	      FIELD_PREP(MT_TXD1_TID,
+			 skb->priority & IEEE80211_QOS_CTL_TID_MASK) |
+	      FIELD_PREP(MT_TXD1_HDR_FORMAT, MT_HDR_FORMAT_802_11) |
+	      FIELD_PREP(MT_TXD1_HDR_INFO, hdr_len / 2) |
+	      FIELD_PREP(MT_TXD1_WLAN_IDX, wlan_idx) |
+	      FIELD_PREP(MT_TXD1_PROTECTED, !!key);
+	txwi[1] = cpu_to_le32(val);
+
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		txwi[1] |= cpu_to_le32(MT_TXD1_NO_ACK);
+
+	val = FIELD_PREP(MT_TXD2_FRAME_TYPE, frame_type) |
+	      FIELD_PREP(MT_TXD2_SUB_TYPE, frame_subtype) |
+	      FIELD_PREP(MT_TXD2_MULTICAST,
+			 is_multicast_ether_addr(hdr->addr1));
+	txwi[2] = cpu_to_le32(val);
+
+	if (!(info->flags & IEEE80211_TX_CTL_AMPDU))
+		txwi[2] |= cpu_to_le32(MT_TXD2_BA_DISABLE);
+
+	txwi[4] = 0;
+
+	val = MT_TXD5_TX_STATUS_HOST | MT_TXD5_SW_POWER_MGMT |
+	      FIELD_PREP(MT_TXD5_PID, pid);
+	txwi[5] = cpu_to_le32(val);
+
+	txwi[6] = 0;
+
+	if (rate->idx >= 0 && rate->count &&
+	    !(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
+		bool stbc = info->flags & IEEE80211_TX_CTL_STBC;
+		u16 rateval = mt7603_mac_tx_rate_val(dev, rate, stbc, &bw);
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
+		if (!(rate->flags & IEEE80211_TX_RC_MCS))
+			txwi[2] |= cpu_to_le32(MT_TXD2_BA_DISABLE);
+
+		tx_count = rate->count;
+	}
+
+	/* use maximum tx count for beacons and buffered multicast */
+	if (q >= &dev->mt76.q_tx[MT_TXQ_BEACON])
+		tx_count = 0x1f;
+
+	val = FIELD_PREP(MT_TXD3_REM_TX_COUNT, tx_count) |
+	      FIELD_PREP(MT_TXD3_SEQ, le16_to_cpu(hdr->seq_ctrl));
+	txwi[3] = cpu_to_le32(val);
+
+	if (key) {
+		u64 pn = atomic64_inc_return(&key->tx_pn);
+
+		txwi[3] |= cpu_to_le32(MT_TXD3_PN_VALID);
+		txwi[4] = cpu_to_le32(pn & GENMASK(31, 0));
+		txwi[5] |= cpu_to_le32(FIELD_PREP(MT_TXD5_PN_HIGH, pn >> 32));
+	}
+
+	txwi[7] = 0;
+
+	return 0;
+}
+
+int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
+			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  u32 *tx_info)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	struct mt7603_sta *msta = container_of(wcid, struct mt7603_sta, wcid);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_key_conf *key = info->control.hw_key;
+	int pid;
+
+	if (!wcid)
+		wcid = &dev->global_sta.wcid;
+
+	if (sta) {
+		msta = (struct mt7603_sta *)sta->drv_priv;
+
+		if ((info->flags & (IEEE80211_TX_CTL_NO_PS_BUFFER |
+				    IEEE80211_TX_CTL_CLEAR_PS_FILT)) ||
+		    (info->control.flags & IEEE80211_TX_CTRL_PS_RESPONSE))
+			mt7603_wtbl_set_ps(dev, msta, false);
+	}
+
+	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
+
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+		spin_lock_bh(&dev->mt76.lock);
+		msta->rate_probe = true;
+		mt7603_wtbl_set_rates(dev, msta, &info->control.rates[0],
+				      msta->rates);
+		spin_unlock_bh(&dev->mt76.lock);
+	}
+
+	mt7603_mac_write_txwi(dev, txwi_ptr, skb, q, wcid, sta, pid, key);
+
+	return 0;
+}
+
+static bool
+mt7603_fill_txs(struct mt7603_dev *dev, struct mt7603_sta *sta,
+		struct ieee80211_tx_info *info, __le32 *txs_data)
+{
+	struct ieee80211_supported_band *sband;
+	int final_idx = 0;
+	u32 final_rate;
+	u32 final_rate_flags;
+	bool final_mpdu;
+	bool ack_timeout;
+	bool fixed_rate;
+	bool probe;
+	bool ampdu;
+	bool cck = false;
+	int count;
+	u32 txs;
+	u8 pid;
+	int idx;
+	int i;
+
+	fixed_rate = info->status.rates[0].count;
+	probe = !!(info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+
+	txs = le32_to_cpu(txs_data[4]);
+	final_mpdu = txs & MT_TXS4_ACKED_MPDU;
+	ampdu = !fixed_rate && (txs & MT_TXS4_AMPDU);
+	pid = FIELD_GET(MT_TXS4_PID, txs);
+	count = FIELD_GET(MT_TXS4_TX_COUNT, txs);
+
+	txs = le32_to_cpu(txs_data[0]);
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
+		int cur_count = min_t(int, count, 2 * MT7603_RATE_RETRY);
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
+		final_rate &= GENMASK(5, 0);
+		final_rate = mt7603_get_rate(dev, sband, final_rate, cck);
+		final_rate_flags = 0;
+		break;
+	case MT_PHY_TYPE_HT_GF:
+	case MT_PHY_TYPE_HT:
+		final_rate_flags |= IEEE80211_TX_RC_MCS;
+		final_rate &= GENMASK(5, 0);
+		if (i > 15)
+			return false;
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
+static bool
+mt7603_mac_add_txs_skb(struct mt7603_dev *dev, struct mt7603_sta *sta, int pid,
+		       __le32 *txs_data)
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
+				mt7603_wtbl_set_rates(dev, sta, NULL,
+						      sta->rates);
+				sta->rate_probe = false;
+			}
+			spin_unlock_bh(&dev->mt76.lock);
+		}
+
+		if (!mt7603_fill_txs(dev, sta, info, txs_data)) {
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
+void mt7603_mac_add_txs(struct mt7603_dev *dev, void *data)
+{
+	struct ieee80211_tx_info info = {};
+	struct ieee80211_sta *sta = NULL;
+	struct mt7603_sta *msta = NULL;
+	struct mt76_wcid *wcid;
+	__le32 *txs_data = data;
+	u32 txs;
+	u8 wcidx;
+	u8 pid;
+
+	txs = le32_to_cpu(txs_data[4]);
+	pid = FIELD_GET(MT_TXS4_PID, txs);
+	txs = le32_to_cpu(txs_data[3]);
+	wcidx = FIELD_GET(MT_TXS3_WCID, txs);
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
+	msta = container_of(wcid, struct mt7603_sta, wcid);
+	sta = wcid_to_sta(wcid);
+
+	if (mt7603_mac_add_txs_skb(dev, msta, pid, txs_data))
+		goto out;
+
+	if (wcidx >= MT7603_WTBL_STA || !sta)
+		goto out;
+
+	if (mt7603_fill_txs(dev, msta, &info, txs_data))
+		ieee80211_tx_status_noskb(mt76_hw(dev), sta, &info);
+
+out:
+	rcu_read_unlock();
+}
+
+void mt7603_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			    struct mt76_queue_entry *e, bool flush)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	struct sk_buff *skb = e->skb;
+
+	if (!e->txwi) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	if (q - dev->mt76.q_tx < 4)
+		dev->tx_hang_check = 0;
+
+	mt76_tx_complete_skb(mdev, skb);
+}
+
+static bool
+wait_for_wpdma(struct mt7603_dev *dev)
+{
+	return mt76_poll(dev, MT_WPDMA_GLO_CFG,
+			 MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+			 MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
+			 0, 1000);
+}
+
+static void mt7603_pse_reset(struct mt7603_dev *dev)
+{
+	/* Clear previous reset result */
+	if (!dev->reset_cause[RESET_CAUSE_RESET_FAILED])
+		mt76_clear(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_PSE_S);
+
+	/* Reset PSE */
+	mt76_set(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_PSE);
+
+	if (!mt76_poll_msec(dev, MT_MCU_DEBUG_RESET,
+			    MT_MCU_DEBUG_RESET_PSE_S,
+			    MT_MCU_DEBUG_RESET_PSE_S, 500)) {
+		dev->reset_cause[RESET_CAUSE_RESET_FAILED]++;
+		mt76_clear(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_PSE);
+	} else {
+		dev->reset_cause[RESET_CAUSE_RESET_FAILED] = 0;
+		mt76_clear(dev, MT_MCU_DEBUG_RESET, MT_MCU_DEBUG_RESET_QUEUES);
+	}
+
+	if (dev->reset_cause[RESET_CAUSE_RESET_FAILED] >= 3)
+		dev->reset_cause[RESET_CAUSE_RESET_FAILED] = 0;
+}
+
+void mt7603_mac_dma_start(struct mt7603_dev *dev)
+{
+	mt7603_mac_start(dev);
+
+	wait_for_wpdma(dev);
+	usleep_range(50, 100);
+
+	mt76_set(dev, MT_WPDMA_GLO_CFG,
+		 (MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		  MT_WPDMA_GLO_CFG_RX_DMA_EN |
+		  FIELD_PREP(MT_WPDMA_GLO_CFG_DMA_BURST_SIZE, 3) |
+		  MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE));
+
+	mt7603_irq_enable(dev, MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL);
+}
+
+void mt7603_mac_start(struct mt7603_dev *dev)
+{
+	mt76_clear(dev, MT_ARB_SCR,
+		   MT_ARB_SCR_TX_DISABLE | MT_ARB_SCR_RX_DISABLE);
+	mt76_wr(dev, MT_WF_ARB_TX_START_0, ~0);
+	mt76_set(dev, MT_WF_ARB_RQCR, MT_WF_ARB_RQCR_RX_START);
+}
+
+void mt7603_mac_stop(struct mt7603_dev *dev)
+{
+	mt76_set(dev, MT_ARB_SCR,
+		 MT_ARB_SCR_TX_DISABLE | MT_ARB_SCR_RX_DISABLE);
+	mt76_wr(dev, MT_WF_ARB_TX_START_0, 0);
+	mt76_clear(dev, MT_WF_ARB_RQCR, MT_WF_ARB_RQCR_RX_START);
+}
+
+void mt7603_pse_client_reset(struct mt7603_dev *dev)
+{
+	u32 addr;
+
+	addr = mt7603_reg_map(dev, MT_CLIENT_BASE_PHYS_ADDR +
+				   MT_CLIENT_RESET_TX);
+
+	/* Clear previous reset state */
+	mt76_clear(dev, addr,
+		   MT_CLIENT_RESET_TX_R_E_1 |
+		   MT_CLIENT_RESET_TX_R_E_2 |
+		   MT_CLIENT_RESET_TX_R_E_1_S |
+		   MT_CLIENT_RESET_TX_R_E_2_S);
+
+	/* Start PSE client TX abort */
+	mt76_set(dev, addr, MT_CLIENT_RESET_TX_R_E_1);
+	mt76_poll_msec(dev, addr, MT_CLIENT_RESET_TX_R_E_1_S,
+		       MT_CLIENT_RESET_TX_R_E_1_S, 500);
+
+	mt76_set(dev, addr, MT_CLIENT_RESET_TX_R_E_2);
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_SW_RESET);
+
+	/* Wait for PSE client to clear TX FIFO */
+	mt76_poll_msec(dev, addr, MT_CLIENT_RESET_TX_R_E_2_S,
+		       MT_CLIENT_RESET_TX_R_E_2_S, 500);
+
+	/* Clear PSE client TX abort state */
+	mt76_clear(dev, addr,
+		   MT_CLIENT_RESET_TX_R_E_1 |
+		   MT_CLIENT_RESET_TX_R_E_2);
+}
+
+static void mt7603_dma_sched_reset(struct mt7603_dev *dev)
+{
+	if (!is_mt7628(dev))
+		return;
+
+	mt76_set(dev, MT_SCH_4, MT_SCH_4_RESET);
+	mt76_clear(dev, MT_SCH_4, MT_SCH_4_RESET);
+}
+
+static void mt7603_mac_watchdog_reset(struct mt7603_dev *dev)
+{
+	int beacon_int = dev->beacon_int;
+	u32 mask = dev->mt76.mmio.irqmask;
+	int i;
+
+	ieee80211_stop_queues(dev->mt76.hw);
+	set_bit(MT76_RESET, &dev->mt76.state);
+
+	/* lock/unlock all queues to ensure that no tx is pending */
+	mt76_txq_schedule_all(&dev->mt76);
+
+	tasklet_disable(&dev->tx_tasklet);
+	tasklet_disable(&dev->pre_tbtt_tasklet);
+	napi_disable(&dev->mt76.napi[0]);
+	napi_disable(&dev->mt76.napi[1]);
+
+	mutex_lock(&dev->mt76.mutex);
+
+	mt7603_beacon_set_timer(dev, -1, 0);
+
+	if (dev->reset_cause[RESET_CAUSE_RESET_FAILED] ||
+	    dev->cur_reset_cause == RESET_CAUSE_RX_PSE_BUSY ||
+	    dev->cur_reset_cause == RESET_CAUSE_BEACON_STUCK ||
+	    dev->cur_reset_cause == RESET_CAUSE_TX_HANG)
+		mt7603_pse_reset(dev);
+
+	if (dev->reset_cause[RESET_CAUSE_RESET_FAILED])
+		goto skip_dma_reset;
+
+	mt7603_mac_stop(dev);
+
+	mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		   MT_WPDMA_GLO_CFG_RX_DMA_EN | MT_WPDMA_GLO_CFG_TX_DMA_EN |
+		   MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE);
+	usleep_range(1000, 2000);
+
+	mt7603_irq_disable(dev, mask);
+
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_FORCE_TX_EOF);
+
+	mt7603_pse_client_reset(dev);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_tx); i++)
+		mt76_queue_tx_cleanup(dev, i, true);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_rx); i++)
+		mt76_queue_rx_reset(dev, i);
+
+	mt7603_dma_sched_reset(dev);
+
+	mt7603_mac_dma_start(dev);
+
+	mt7603_irq_enable(dev, mask);
+
+skip_dma_reset:
+	clear_bit(MT76_RESET, &dev->mt76.state);
+	mutex_unlock(&dev->mt76.mutex);
+
+	tasklet_enable(&dev->tx_tasklet);
+	tasklet_schedule(&dev->tx_tasklet);
+
+	tasklet_enable(&dev->pre_tbtt_tasklet);
+	mt7603_beacon_set_timer(dev, -1, beacon_int);
+
+	napi_enable(&dev->mt76.napi[0]);
+	napi_schedule(&dev->mt76.napi[0]);
+
+	napi_enable(&dev->mt76.napi[1]);
+	napi_schedule(&dev->mt76.napi[1]);
+
+	ieee80211_wake_queues(dev->mt76.hw);
+	mt76_txq_schedule_all(&dev->mt76);
+}
+
+static u32 mt7603_dma_debug(struct mt7603_dev *dev, u8 index)
+{
+	u32 val;
+
+	mt76_wr(dev, MT_WPDMA_DEBUG,
+		FIELD_PREP(MT_WPDMA_DEBUG_IDX, index) |
+		MT_WPDMA_DEBUG_SEL);
+
+	val = mt76_rr(dev, MT_WPDMA_DEBUG);
+	return FIELD_GET(MT_WPDMA_DEBUG_VALUE, val);
+}
+
+static bool mt7603_rx_fifo_busy(struct mt7603_dev *dev)
+{
+	if (is_mt7628(dev))
+		return mt7603_dma_debug(dev, 9) & BIT(9);
+
+	return mt7603_dma_debug(dev, 2) & BIT(8);
+}
+
+static bool mt7603_rx_dma_busy(struct mt7603_dev *dev)
+{
+	if (!(mt76_rr(dev, MT_WPDMA_GLO_CFG) & MT_WPDMA_GLO_CFG_RX_DMA_BUSY))
+		return false;
+
+	return mt7603_rx_fifo_busy(dev);
+}
+
+static bool mt7603_tx_dma_busy(struct mt7603_dev *dev)
+{
+	u32 val;
+
+	if (!(mt76_rr(dev, MT_WPDMA_GLO_CFG) & MT_WPDMA_GLO_CFG_TX_DMA_BUSY))
+		return false;
+
+	val = mt7603_dma_debug(dev, 9);
+	return (val & BIT(8)) && (val & 0xf) != 0xf;
+}
+
+static bool mt7603_tx_hang(struct mt7603_dev *dev)
+{
+	struct mt76_queue *q;
+	u32 dma_idx, prev_dma_idx;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		q = &dev->mt76.q_tx[i];
+
+		if (!q->queued)
+			continue;
+
+		prev_dma_idx = dev->tx_dma_idx[i];
+		dma_idx = ioread32(&q->regs->dma_idx);
+		dev->tx_dma_idx[i] = dma_idx;
+
+		if (dma_idx == prev_dma_idx &&
+		    dma_idx != ioread32(&q->regs->cpu_idx))
+			break;
+	}
+
+	return i < 4;
+}
+
+static bool mt7603_rx_pse_busy(struct mt7603_dev *dev)
+{
+	u32 addr, val;
+
+	if (mt76_rr(dev, MT_MCU_DEBUG_RESET) & MT_MCU_DEBUG_RESET_QUEUES)
+		return true;
+
+	if (mt7603_rx_fifo_busy(dev))
+		return false;
+
+	addr = mt7603_reg_map(dev, MT_CLIENT_BASE_PHYS_ADDR + MT_CLIENT_STATUS);
+	mt76_wr(dev, addr, 3);
+	val = mt76_rr(dev, addr) >> 16;
+
+	if (is_mt7628(dev) && (val & 0x4001) == 0x4001)
+		return true;
+
+	return (val & 0x8001) == 0x8001 || (val & 0xe001) == 0xe001;
+}
+
+static bool
+mt7603_watchdog_check(struct mt7603_dev *dev, u8 *counter,
+		      enum mt7603_reset_cause cause,
+		      bool (*check)(struct mt7603_dev *dev))
+{
+	if (dev->reset_test == cause + 1) {
+		dev->reset_test = 0;
+		goto trigger;
+	}
+
+	if (check) {
+		if (!check(dev) && *counter < MT7603_WATCHDOG_TIMEOUT) {
+			*counter = 0;
+			return false;
+		}
+
+		(*counter)++;
+	}
+
+	if (*counter < MT7603_WATCHDOG_TIMEOUT)
+		return false;
+trigger:
+	dev->cur_reset_cause = cause;
+	dev->reset_cause[cause]++;
+	return true;
+}
+
+void mt7603_update_channel(struct mt76_dev *mdev)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	struct mt76_channel_state *state;
+	ktime_t cur_time;
+	u32 busy;
+
+	if (!test_bit(MT76_STATE_RUNNING, &dev->mt76.state))
+		return;
+
+	state = mt76_channel_state(&dev->mt76, dev->mt76.chandef.chan);
+	busy = mt76_rr(dev, MT_MIB_STAT_PSCCA);
+
+	spin_lock_bh(&dev->mt76.cc_lock);
+	cur_time = ktime_get_boottime();
+	state->cc_busy += busy;
+	state->cc_active += ktime_to_us(ktime_sub(cur_time, dev->survey_time));
+	dev->survey_time = cur_time;
+	spin_unlock_bh(&dev->mt76.cc_lock);
+}
+
+void
+mt7603_edcca_set_strict(struct mt7603_dev *dev, bool val)
+{
+	u32 rxtd_6 = 0xd7c80000;
+
+	if (val == dev->ed_strict_mode)
+		return;
+
+	dev->ed_strict_mode = val;
+
+	/* Ensure that ED/CCA does not trigger if disabled */
+	if (!dev->ed_monitor)
+		rxtd_6 |= FIELD_PREP(MT_RXTD_6_CCAED_TH, 0x34);
+	else
+		rxtd_6 |= FIELD_PREP(MT_RXTD_6_CCAED_TH, 0x7d);
+
+	if (dev->ed_monitor && !dev->ed_strict_mode)
+		rxtd_6 |= FIELD_PREP(MT_RXTD_6_ACI_TH, 0x0f);
+	else
+		rxtd_6 |= FIELD_PREP(MT_RXTD_6_ACI_TH, 0x10);
+
+	mt76_wr(dev, MT_RXTD(6), rxtd_6);
+
+	mt76_rmw_field(dev, MT_RXTD(13), MT_RXTD_13_ACI_TH_EN,
+		       dev->ed_monitor && !dev->ed_strict_mode);
+}
+
+static void
+mt7603_edcca_check(struct mt7603_dev *dev)
+{
+	u32 val = mt76_rr(dev, MT_AGC(41));
+	ktime_t cur_time;
+	int rssi0, rssi1;
+	u32 active;
+	u32 ed_busy;
+
+	if (!dev->ed_monitor)
+		return;
+
+	rssi0 = FIELD_GET(MT_AGC_41_RSSI_0, val);
+	if (rssi0 > 128)
+		rssi0 -= 256;
+
+	rssi1 = FIELD_GET(MT_AGC_41_RSSI_1, val);
+	if (rssi1 > 128)
+		rssi1 -= 256;
+
+	if (max(rssi0, rssi1) >= -40 &&
+	    dev->ed_strong_signal < MT7603_EDCCA_BLOCK_TH)
+		dev->ed_strong_signal++;
+	else if (dev->ed_strong_signal > 0)
+		dev->ed_strong_signal--;
+
+	cur_time = ktime_get_boottime();
+	ed_busy = mt76_rr(dev, MT_MIB_STAT_ED) & MT_MIB_STAT_ED_MASK;
+
+	active = ktime_to_us(ktime_sub(cur_time, dev->ed_time));
+	dev->ed_time = cur_time;
+
+	if (!active)
+		return;
+
+	if (100 * ed_busy / active > 90) {
+		if (dev->ed_trigger < 0)
+			dev->ed_trigger = 0;
+		dev->ed_trigger++;
+	} else {
+		if (dev->ed_trigger > 0)
+			dev->ed_trigger = 0;
+		dev->ed_trigger--;
+	}
+
+	if (dev->ed_trigger > MT7603_EDCCA_BLOCK_TH ||
+	    dev->ed_strong_signal < MT7603_EDCCA_BLOCK_TH / 2) {
+		mt7603_edcca_set_strict(dev, true);
+	} else if (dev->ed_trigger < -MT7603_EDCCA_BLOCK_TH) {
+		mt7603_edcca_set_strict(dev, false);
+	}
+
+	if (dev->ed_trigger > MT7603_EDCCA_BLOCK_TH)
+		dev->ed_trigger = MT7603_EDCCA_BLOCK_TH;
+	else if (dev->ed_trigger < -MT7603_EDCCA_BLOCK_TH)
+		dev->ed_trigger = -MT7603_EDCCA_BLOCK_TH;
+}
+
+void mt7603_cca_stats_reset(struct mt7603_dev *dev)
+{
+	mt76_set(dev, MT_PHYCTRL(2), MT_PHYCTRL_2_STATUS_RESET);
+	mt76_clear(dev, MT_PHYCTRL(2), MT_PHYCTRL_2_STATUS_RESET);
+	mt76_set(dev, MT_PHYCTRL(2), MT_PHYCTRL_2_STATUS_EN);
+}
+
+static void
+mt7603_adjust_sensitivity(struct mt7603_dev *dev)
+{
+	u32 agc0 = dev->agc0, agc3 = dev->agc3;
+	u32 adj;
+
+	if (!dev->sensitivity || dev->sensitivity < -100) {
+		dev->sensitivity = 0;
+	} else if (dev->sensitivity <= -84) {
+		adj = 7 + (dev->sensitivity + 92) / 2;
+
+		agc0 = 0x56f0076f;
+		agc0 |= adj << 12;
+		agc0 |= adj << 16;
+		agc3 = 0x81d0d5e3;
+	} else if (dev->sensitivity <= -72) {
+		adj = 7 + (dev->sensitivity + 80) / 2;
+
+		agc0 = 0x6af0006f;
+		agc0 |= adj << 8;
+		agc0 |= adj << 12;
+		agc0 |= adj << 16;
+
+		agc3 = 0x8181d5e3;
+	} else {
+		if (dev->sensitivity > -54)
+			dev->sensitivity = -54;
+
+		adj = 7 + (dev->sensitivity + 80) / 2;
+
+		agc0 = 0x7ff0000f;
+		agc0 |= adj << 4;
+		agc0 |= adj << 8;
+		agc0 |= adj << 12;
+		agc0 |= adj << 16;
+
+		agc3 = 0x818181e3;
+	}
+
+	mt76_wr(dev, MT_AGC(0), agc0);
+	mt76_wr(dev, MT_AGC1(0), agc0);
+
+	mt76_wr(dev, MT_AGC(3), agc3);
+	mt76_wr(dev, MT_AGC1(3), agc3);
+}
+
+static void
+mt7603_false_cca_check(struct mt7603_dev *dev)
+{
+	int pd_cck, pd_ofdm, mdrdy_cck, mdrdy_ofdm;
+	int false_cca;
+	int min_signal;
+	u32 val;
+
+	val = mt76_rr(dev, MT_PHYCTRL_STAT_PD);
+	pd_cck = FIELD_GET(MT_PHYCTRL_STAT_PD_CCK, val);
+	pd_ofdm = FIELD_GET(MT_PHYCTRL_STAT_PD_OFDM, val);
+
+	val = mt76_rr(dev, MT_PHYCTRL_STAT_MDRDY);
+	mdrdy_cck = FIELD_GET(MT_PHYCTRL_STAT_MDRDY_CCK, val);
+	mdrdy_ofdm = FIELD_GET(MT_PHYCTRL_STAT_MDRDY_OFDM, val);
+
+	dev->false_cca_ofdm = pd_ofdm - mdrdy_ofdm;
+	dev->false_cca_cck = pd_cck - mdrdy_cck;
+
+	mt7603_cca_stats_reset(dev);
+
+	min_signal = mt76_get_min_avg_rssi(&dev->mt76);
+	if (!min_signal) {
+		dev->sensitivity = 0;
+		dev->last_cca_adj = jiffies;
+		goto out;
+	}
+
+	min_signal -= 15;
+
+	false_cca = dev->false_cca_ofdm + dev->false_cca_cck;
+	if (false_cca > 600) {
+		if (!dev->sensitivity)
+			dev->sensitivity = -92;
+		else
+			dev->sensitivity += 2;
+		dev->last_cca_adj = jiffies;
+	} else if (false_cca < 100 ||
+		   time_after(jiffies, dev->last_cca_adj + 10 * HZ)) {
+		dev->last_cca_adj = jiffies;
+		if (!dev->sensitivity)
+			goto out;
+
+		dev->sensitivity -= 2;
+	}
+
+	if (dev->sensitivity && dev->sensitivity > min_signal) {
+		dev->sensitivity = min_signal;
+		dev->last_cca_adj = jiffies;
+	}
+
+out:
+	mt7603_adjust_sensitivity(dev);
+}
+
+void mt7603_mac_work(struct work_struct *work)
+{
+	struct mt7603_dev *dev = container_of(work, struct mt7603_dev,
+					      mac_work.work);
+	bool reset = false;
+
+	mt76_tx_status_check(&dev->mt76, NULL, false);
+
+	mutex_lock(&dev->mt76.mutex);
+
+	dev->mac_work_count++;
+	mt7603_update_channel(&dev->mt76);
+	mt7603_edcca_check(dev);
+
+	if (dev->mac_work_count == 10)
+		mt7603_false_cca_check(dev);
+
+	if (mt7603_watchdog_check(dev, &dev->rx_pse_check,
+				  RESET_CAUSE_RX_PSE_BUSY,
+				  mt7603_rx_pse_busy) ||
+	    mt7603_watchdog_check(dev, &dev->beacon_check,
+				  RESET_CAUSE_BEACON_STUCK,
+				  NULL) ||
+	    mt7603_watchdog_check(dev, &dev->tx_hang_check,
+				  RESET_CAUSE_TX_HANG,
+				  mt7603_tx_hang) ||
+	    mt7603_watchdog_check(dev, &dev->tx_dma_check,
+				  RESET_CAUSE_TX_BUSY,
+				  mt7603_tx_dma_busy) ||
+	    mt7603_watchdog_check(dev, &dev->rx_dma_check,
+				  RESET_CAUSE_RX_BUSY,
+				  mt7603_rx_dma_busy) ||
+	    mt7603_watchdog_check(dev, &dev->mcu_hang,
+				  RESET_CAUSE_MCU_HANG,
+				  NULL) ||
+	    dev->reset_cause[RESET_CAUSE_RESET_FAILED]) {
+		dev->beacon_check = 0;
+		dev->tx_dma_check = 0;
+		dev->tx_hang_check = 0;
+		dev->rx_dma_check = 0;
+		dev->rx_pse_check = 0;
+		dev->mcu_hang = 0;
+		dev->rx_dma_idx = ~0;
+		memset(dev->tx_dma_idx, 0xff, sizeof(dev->tx_dma_idx));
+		reset = true;
+		dev->mac_work_count = 0;
+	}
+
+	if (dev->mac_work_count >= 10)
+		dev->mac_work_count = 0;
+
+	mutex_unlock(&dev->mt76.mutex);
+
+	if (reset)
+		mt7603_mac_watchdog_reset(dev);
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+				     msecs_to_jiffies(MT7603_WATCHDOG_TIME));
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.h b/drivers/net/wireless/mediatek/mt76/mt7603/mac.h
new file mode 100644
index 000000000000..1704e6f932a3
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.h
@@ -0,0 +1,257 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#ifndef __MT7603_MAC_H
+#define __MT7603_MAC_H
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
+	PKT_TYPE_TXS		= 0,
+	PKT_TYPE_TXRXV		= 1,
+	PKT_TYPE_NORMAL		= 2,
+	PKT_TYPE_RX_DUP_RFB	= 3,
+	PKT_TYPE_RX_TMR		= 4,
+	PKT_TYPE_RETRIEVE	= 5,
+	PKT_TYPE_RX_EVENT	= 7,
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
+#define MT_RXD1_NORMAL_BCAST		BIT(3)
+#define MT_RXD1_NORMAL_MCAST		BIT(2)
+#define MT_RXD1_NORMAL_U2M		BIT(1)
+#define MT_RXD1_NORMAL_HTC_VLD		BIT(0)
+
+#define MT_RXD2_NORMAL_NON_AMPDU	BIT(31)
+#define MT_RXD2_NORMAL_NON_AMPDU_SUB	BIT(30)
+#define MT_RXD2_NORMAL_NDATA		BIT(29)
+#define MT_RXD2_NORMAL_NULL_FRAME	BIT(28)
+#define MT_RXD2_NORMAL_FRAG		BIT(27)
+#define MT_RXD2_NORMAL_UDF_VALID	BIT(26)
+#define MT_RXD2_NORMAL_LLC_MIS		BIT(25)
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
+#define MT_RXV1_VHTA1_B5_B4		GENMASK(31, 30)
+#define MT_RXV1_VHTA2_B8_B1		GENMASK(29, 22)
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
+#define MT_RXV2_VHTA1_B16_B6		GENMASK(31, 21)
+#define MT_RXV2_LENGTH			GENMASK(20, 0)
+
+#define MT_RXV3_F_AGC1_CAL_GAIN		GENMASK(31, 29)
+#define MT_RXV3_F_AGC1_EQ_CAL		BIT(28)
+#define MT_RXV3_RCPI1			GENMASK(27, 20)
+#define MT_RXV3_F_AGC0_CAL_GAIN		GENMASK(19, 17)
+#define MT_RXV3_F_AGC0_EQ_CAL		BIT(16)
+#define MT_RXV3_RCPI0			GENMASK(15, 8)
+#define MT_RXV3_SEL_ANT			BIT(7)
+#define MT_RXV3_ACI_DET_X		BIT(6)
+#define MT_RXV3_OFDM_FREQ_TRANS_DETECT	BIT(5)
+#define MT_RXV3_VHTA1_B21_B17		GENMASK(4, 0)
+
+#define MT_RXV4_F_AGC_CAL_GAIN		GENMASK(31, 29)
+#define MT_RXV4_F_AGC2_EQ_CAL		BIT(28)
+#define MT_RXV4_IB_RSSI1		GENMASK(27, 20)
+#define MT_RXV4_F_AGC_LPF_GAIN_X	GENMASK(19, 16)
+#define MT_RXV4_WB_RSSI_X		GENMASK(15, 8)
+#define MT_RXV4_IB_RSSI0		GENMASK(7, 0)
+
+#define MT_RXV5_LTF_SNR0		GENMASK(31, 26)
+#define MT_RXV5_LTF_PROC_TIME		GENMASK(25, 19)
+#define MT_RXV5_FOE			GENMASK(18, 7)
+#define MT_RXV5_C_AGC_SATE		GENMASK(6, 4)
+#define MT_RXV5_F_AGC_LNA_GAIN_0	GENMASK(3, 2)
+#define MT_RXV5_F_AGC_LNA_GAIN_1	GENMASK(1, 0)
+
+#define MT_RXV6_C_AGC_STATE		GENMASK(30, 28)
+#define MT_RXV6_NS_TS_FIELD		GENMASK(27, 25)
+#define MT_RXV6_RX_VALID		BIT(24)
+#define MT_RXV6_NF2			GENMASK(23, 16)
+#define MT_RXV6_NF1			GENMASK(15, 8)
+#define MT_RXV6_NF0			GENMASK(7, 0)
+
+enum mt7603_tx_header_format {
+	MT_HDR_FORMAT_802_3,
+	MT_HDR_FORMAT_CMD,
+	MT_HDR_FORMAT_802_11,
+	MT_HDR_FORMAT_802_11_EXT,
+};
+
+#define MT_TXD_SIZE			(8 * 4)
+
+#define MT_TXD0_P_IDX			BIT(31)
+#define MT_TXD0_Q_IDX			GENMASK(30, 27)
+#define MT_TXD0_UTXB			BIT(26)
+#define MT_TXD0_UNXV			BIT(25)
+#define MT_TXD0_UDP_TCP_SUM		BIT(24)
+#define MT_TXD0_IP_SUM			BIT(23)
+#define MT_TXD0_ETH_TYPE_OFFSET		GENMASK(22, 16)
+#define MT_TXD0_TX_BYTES		GENMASK(15, 0)
+
+#define MT_TXD1_OWN_MAC			GENMASK(31, 26)
+#define MT_TXD1_PROTECTED		BIT(23)
+#define MT_TXD1_TID			GENMASK(22, 20)
+#define MT_TXD1_NO_ACK			BIT(19)
+#define MT_TXD1_HDR_PAD			GENMASK(18, 16)
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
+
+#define MT_TXD4_PN_LOW			GENMASK(31, 0)
+
+#define MT_TXD5_PN_HIGH			GENMASK(31, 16)
+#define MT_TXD5_SW_POWER_MGMT		BIT(13)
+#define MT_TXD5_BA_SEQ_CTRL		BIT(12)
+#define MT_TXD5_DA_SELECT		BIT(11)
+#define MT_TXD5_TX_STATUS_HOST		BIT(10)
+#define MT_TXD5_TX_STATUS_MCU		BIT(9)
+#define MT_TXD5_TX_STATUS_FMT		BIT(8)
+#define MT_TXD5_PID			GENMASK(7, 0)
+
+#define MT_TXD6_SGI			BIT(31)
+#define MT_TXD6_LDPC			BIT(30)
+#define MT_TXD6_TX_RATE			GENMASK(29, 18)
+#define MT_TXD6_I_TXBF			BIT(17)
+#define MT_TXD6_E_TXBF			BIT(16)
+#define MT_TXD6_DYN_BW			BIT(15)
+#define MT_TXD6_ANT_PRI			GENMASK(14, 12)
+#define MT_TXD6_SPE_EN			BIT(11)
+#define MT_TXD6_FIXED_BW		BIT(10)
+#define MT_TXD6_BW			GENMASK(9, 8)
+#define MT_TXD6_ANT_ID			GENMASK(7, 2)
+#define MT_TXD6_FIXED_RATE		BIT(0)
+
+#define MT_TX_RATE_STBC			BIT(11)
+#define MT_TX_RATE_NSS			GENMASK(10, 9)
+#define MT_TX_RATE_MODE			GENMASK(8, 6)
+#define MT_TX_RATE_IDX			GENMASK(5, 0)
+
+#define MT_TXS0_ANTENNA			GENMASK(31, 26)
+#define MT_TXS0_TID			GENMASK(25, 22)
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
+#define MT_TXS1_F0_TIMESTAMP		GENMASK(31, 0)
+#define MT_TXS1_F1_NOISE_2		GENMASK(23, 16)
+#define MT_TXS1_F1_NOISE_1		GENMASK(15, 8)
+#define MT_TXS1_F1_NOISE_0		GENMASK(7, 0)
+
+#define MT_TXS2_F0_FRONT_TIME		GENMASK(24, 0)
+#define MT_TXS2_F1_RCPI_2		GENMASK(23, 16)
+#define MT_TXS2_F1_RCPI_1		GENMASK(15, 8)
+#define MT_TXS2_F1_RCPI_0		GENMASK(7, 0)
+
+#define MT_TXS3_WCID			GENMASK(31, 24)
+#define MT_TXS3_RXV_SEQNO		GENMASK(23, 16)
+#define MT_TXS3_TX_DELAY		GENMASK(15, 0)
+
+#define MT_TXS4_LAST_TX_RATE		GENMASK(31, 29)
+#define MT_TXS4_TX_COUNT		GENMASK(28, 24)
+#define MT_TXS4_AMPDU			BIT(23)
+#define MT_TXS4_ACKED_MPDU		BIT(22)
+#define MT_TXS4_PID			GENMASK(21, 14)
+#define MT_TXS4_BW			GENMASK(13, 12)
+#define MT_TXS4_F0_SEQNO		GENMASK(11, 0)
+#define MT_TXS4_F1_TSSI			GENMASK(11, 0)
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
new file mode 100644
index 000000000000..74ccd6edbb9f
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -0,0 +1,730 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include <linux/etherdevice.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/module.h>
+#include "mt7603.h"
+#include "eeprom.h"
+
+static int
+mt7603_start(struct ieee80211_hw *hw)
+{
+	struct mt7603_dev *dev = hw->priv;
+
+	mt7603_mac_start(dev);
+	dev->survey_time = ktime_get_boottime();
+	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	mt7603_mac_work(&dev->mac_work.work);
+
+	return 0;
+}
+
+static void
+mt7603_stop(struct ieee80211_hw *hw)
+{
+	struct mt7603_dev *dev = hw->priv;
+
+	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
+	cancel_delayed_work_sync(&dev->mac_work);
+	mt7603_mac_stop(dev);
+}
+
+static int
+mt7603_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+	struct mt7603_dev *dev = hw->priv;
+	struct mt76_txq *mtxq;
+	u8 bc_addr[ETH_ALEN];
+	int idx;
+	int ret = 0;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	mvif->idx = ffs(~dev->vif_mask) - 1;
+	if (mvif->idx >= MT7603_MAX_INTERFACES) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	mt76_wr(dev, MT_MAC_ADDR0(mvif->idx),
+		get_unaligned_le32(vif->addr));
+	mt76_wr(dev, MT_MAC_ADDR1(mvif->idx),
+		(get_unaligned_le16(vif->addr + 4) |
+		 MT_MAC_ADDR1_VALID));
+
+	if (vif->type == NL80211_IFTYPE_AP) {
+		mt76_wr(dev, MT_BSSID0(mvif->idx),
+			get_unaligned_le32(vif->addr));
+		mt76_wr(dev, MT_BSSID1(mvif->idx),
+			(get_unaligned_le16(vif->addr + 4) |
+			 MT_BSSID1_VALID));
+	}
+
+	idx = MT7603_WTBL_RESERVED - 1 - mvif->idx;
+	dev->vif_mask |= BIT(mvif->idx);
+	mvif->sta.wcid.idx = idx;
+	mvif->sta.wcid.hw_key_idx = -1;
+
+	eth_broadcast_addr(bc_addr);
+	mt7603_wtbl_init(dev, idx, mvif->idx, bc_addr);
+
+	mtxq = (struct mt76_txq *)vif->txq->drv_priv;
+	mtxq->wcid = &mvif->sta.wcid;
+	mt76_txq_init(&dev->mt76, vif->txq);
+	rcu_assign_pointer(dev->mt76.wcid[idx], &mvif->sta.wcid);
+
+out:
+	mutex_unlock(&dev->mt76.mutex);
+
+	return ret;
+}
+
+static void
+mt7603_remove_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+	struct mt7603_dev *dev = hw->priv;
+	int idx = mvif->sta.wcid.idx;
+
+	mt76_wr(dev, MT_MAC_ADDR0(mvif->idx), 0);
+	mt76_wr(dev, MT_MAC_ADDR1(mvif->idx), 0);
+	mt76_wr(dev, MT_BSSID0(mvif->idx), 0);
+	mt76_wr(dev, MT_BSSID1(mvif->idx), 0);
+	mt7603_beacon_set_timer(dev, mvif->idx, 0);
+
+	rcu_assign_pointer(dev->mt76.wcid[idx], NULL);
+	mt76_txq_remove(&dev->mt76, vif->txq);
+
+	mutex_lock(&dev->mt76.mutex);
+	dev->vif_mask &= ~BIT(mvif->idx);
+	mutex_unlock(&dev->mt76.mutex);
+}
+
+static void
+mt7603_init_edcca(struct mt7603_dev *dev)
+{
+	/* Set lower signal level to -65dBm */
+	mt76_rmw_field(dev, MT_RXTD(8), MT_RXTD_8_LOWER_SIGNAL, 0x23);
+
+	/* clear previous energy detect monitor results */
+	mt76_rr(dev, MT_MIB_STAT_ED);
+
+	if (dev->ed_monitor)
+		mt76_set(dev, MT_MIB_CTL, MT_MIB_CTL_ED_TIME);
+	else
+		mt76_clear(dev, MT_MIB_CTL, MT_MIB_CTL_ED_TIME);
+
+	dev->ed_strict_mode = 0xff;
+	dev->ed_strong_signal = 0;
+	dev->ed_time = ktime_get_boottime();
+
+	mt7603_edcca_set_strict(dev, false);
+}
+
+static int
+mt7603_set_channel(struct mt7603_dev *dev, struct cfg80211_chan_def *def)
+{
+	u8 *rssi_data = (u8 *)dev->mt76.eeprom.data;
+	int idx, ret;
+	u8 bw = MT_BW_20;
+	bool failed = false;
+
+	cancel_delayed_work_sync(&dev->mac_work);
+
+	mutex_lock(&dev->mt76.mutex);
+	set_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76_set_channel(&dev->mt76);
+	mt7603_mac_stop(dev);
+
+	if (def->width == NL80211_CHAN_WIDTH_40)
+		bw = MT_BW_40;
+
+	dev->mt76.chandef = *def;
+	mt76_rmw_field(dev, MT_AGG_BWCR, MT_AGG_BWCR_BW, bw);
+	ret = mt7603_mcu_set_channel(dev);
+	if (ret) {
+		failed = true;
+		goto out;
+	}
+
+	if (def->chan->band == NL80211_BAND_5GHZ) {
+		idx = 1;
+		rssi_data += MT_EE_RSSI_OFFSET_5G;
+	} else {
+		idx = 0;
+		rssi_data += MT_EE_RSSI_OFFSET_2G;
+	}
+
+	memcpy(dev->rssi_offset, rssi_data, sizeof(dev->rssi_offset));
+
+	idx |= (def->chan -
+		mt76_hw(dev)->wiphy->bands[def->chan->band]->channels) << 1;
+	mt76_wr(dev, MT_WF_RMAC_CH_FREQ, idx);
+	mt7603_mac_set_timing(dev);
+	mt7603_mac_start(dev);
+
+	clear_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76_txq_schedule_all(&dev->mt76);
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
+				     MT7603_WATCHDOG_TIME);
+
+	/* reset channel stats */
+	mt76_clear(dev, MT_MIB_CTL, MT_MIB_CTL_READ_CLR_DIS);
+	mt76_set(dev, MT_MIB_CTL,
+		 MT_MIB_CTL_CCA_NAV_TX | MT_MIB_CTL_PSCCA_TIME);
+	mt76_rr(dev, MT_MIB_STAT_PSCCA);
+	mt7603_cca_stats_reset(dev);
+
+	dev->survey_time = ktime_get_boottime();
+
+	mt7603_init_edcca(dev);
+
+out:
+	mutex_unlock(&dev->mt76.mutex);
+
+	if (failed)
+		mt7603_mac_work(&dev->mac_work.work);
+
+	return ret;
+}
+
+static int
+mt7603_config(struct ieee80211_hw *hw, u32 changed)
+{
+	struct mt7603_dev *dev = hw->priv;
+	int ret = 0;
+
+	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
+		       IEEE80211_CONF_CHANGE_POWER))
+		ret = mt7603_set_channel(dev, &hw->conf.chandef);
+
+	if (changed & IEEE80211_CONF_CHANGE_MONITOR) {
+		mutex_lock(&dev->mt76.mutex);
+
+		if (!(hw->conf.flags & IEEE80211_CONF_MONITOR))
+			dev->rxfilter |= MT_WF_RFCR_DROP_OTHER_UC;
+		else
+			dev->rxfilter &= ~MT_WF_RFCR_DROP_OTHER_UC;
+
+		mt76_wr(dev, MT_WF_RFCR, dev->rxfilter);
+
+		mutex_unlock(&dev->mt76.mutex);
+	}
+
+	return ret;
+}
+
+static void
+mt7603_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
+			unsigned int *total_flags, u64 multicast)
+{
+	struct mt7603_dev *dev = hw->priv;
+	u32 flags = 0;
+
+#define MT76_FILTER(_flag, _hw) do { \
+		flags |= *total_flags & FIF_##_flag;			\
+		dev->rxfilter &= ~(_hw);				\
+		dev->rxfilter |= !(flags & FIF_##_flag) * (_hw);	\
+	} while (0)
+
+	dev->rxfilter &= ~(MT_WF_RFCR_DROP_OTHER_BSS |
+			   MT_WF_RFCR_DROP_OTHER_BEACON |
+			   MT_WF_RFCR_DROP_FRAME_REPORT |
+			   MT_WF_RFCR_DROP_PROBEREQ |
+			   MT_WF_RFCR_DROP_MCAST_FILTERED |
+			   MT_WF_RFCR_DROP_MCAST |
+			   MT_WF_RFCR_DROP_BCAST |
+			   MT_WF_RFCR_DROP_DUPLICATE |
+			   MT_WF_RFCR_DROP_A2_BSSID |
+			   MT_WF_RFCR_DROP_UNWANTED_CTL |
+			   MT_WF_RFCR_DROP_STBC_MULTI);
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
+	mt76_wr(dev, MT_WF_RFCR, dev->rxfilter);
+}
+
+static void
+mt7603_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_bss_conf *info, u32 changed)
+{
+	struct mt7603_dev *dev = hw->priv;
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+
+	mutex_lock(&dev->mt76.mutex);
+
+	if (changed & (BSS_CHANGED_ASSOC | BSS_CHANGED_BSSID)) {
+		if (info->assoc || info->ibss_joined) {
+			mt76_wr(dev, MT_BSSID0(mvif->idx),
+				get_unaligned_le32(info->bssid));
+			mt76_wr(dev, MT_BSSID1(mvif->idx),
+				(get_unaligned_le16(info->bssid + 4) |
+				 MT_BSSID1_VALID));
+		} else {
+			mt76_wr(dev, MT_BSSID0(mvif->idx), 0);
+			mt76_wr(dev, MT_BSSID1(mvif->idx), 0);
+		}
+	}
+
+	if (changed & BSS_CHANGED_ERP_SLOT) {
+		int slottime = info->use_short_slot ? 9 : 20;
+
+		if (slottime != dev->slottime) {
+			dev->slottime = slottime;
+			mt7603_mac_set_timing(dev);
+		}
+	}
+
+	if (changed & (BSS_CHANGED_BEACON_ENABLED | BSS_CHANGED_BEACON_INT)) {
+		int beacon_int = !!info->enable_beacon * info->beacon_int;
+
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+		mt7603_beacon_set_timer(dev, mvif->idx, beacon_int);
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+	}
+
+	mutex_unlock(&dev->mt76.mutex);
+}
+
+int
+mt7603_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+	       struct ieee80211_sta *sta)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+	int idx;
+	int ret = 0;
+
+	idx = mt76_wcid_alloc(dev->mt76.wcid_mask, MT7603_WTBL_STA - 1);
+	if (idx < 0)
+		return -ENOSPC;
+
+	__skb_queue_head_init(&msta->psq);
+	msta->ps = ~0;
+	msta->smps = ~0;
+	msta->wcid.sta = 1;
+	msta->wcid.idx = idx;
+	mt7603_wtbl_init(dev, idx, mvif->idx, sta->addr);
+	mt7603_wtbl_set_ps(dev, msta, false);
+
+	if (vif->type == NL80211_IFTYPE_AP)
+		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
+
+	return ret;
+}
+
+void
+mt7603_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		 struct ieee80211_sta *sta)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+
+	mt7603_wtbl_update_cap(dev, sta);
+}
+
+void
+mt7603_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		  struct ieee80211_sta *sta)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+	struct mt76_wcid *wcid = (struct mt76_wcid *)sta->drv_priv;
+
+	spin_lock_bh(&dev->ps_lock);
+	__skb_queue_purge(&msta->psq);
+	mt7603_filter_tx(dev, wcid->idx, true);
+	spin_unlock_bh(&dev->ps_lock);
+
+	mt7603_wtbl_clear(dev, wcid->idx);
+}
+
+static void
+mt7603_ps_tx_list(struct mt7603_dev *dev, struct sk_buff_head *list)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(list)) != NULL)
+		mt7603_tx_queue_mcu(dev, skb_get_queue_mapping(skb), skb);
+}
+
+void
+mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
+{
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+	struct sk_buff_head list;
+
+	mt76_stop_tx_queues(&dev->mt76, sta, false);
+	mt7603_wtbl_set_ps(dev, msta, ps);
+	if (ps)
+		return;
+
+	__skb_queue_head_init(&list);
+
+	spin_lock_bh(&dev->ps_lock);
+	skb_queue_splice_tail_init(&msta->psq, &list);
+	spin_unlock_bh(&dev->ps_lock);
+
+	mt7603_ps_tx_list(dev, &list);
+}
+
+static void
+mt7603_release_buffered_frames(struct ieee80211_hw *hw,
+			       struct ieee80211_sta *sta,
+			       u16 tids, int nframes,
+			       enum ieee80211_frame_release_type reason,
+			       bool more_data)
+{
+	struct mt7603_dev *dev = hw->priv;
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+	struct sk_buff_head list;
+	struct sk_buff *skb, *tmp;
+
+	__skb_queue_head_init(&list);
+
+	spin_lock_bh(&dev->ps_lock);
+	skb_queue_walk_safe(&msta->psq, skb, tmp) {
+		if (!nframes)
+			break;
+
+		if (!(tids & BIT(skb->priority)))
+			continue;
+
+		skb_set_queue_mapping(skb, MT_TXQ_PSD);
+		__skb_unlink(skb, &msta->psq);
+		__skb_queue_tail(&list, skb);
+		nframes--;
+	}
+	spin_unlock_bh(&dev->ps_lock);
+
+	mt7603_ps_tx_list(dev, &list);
+
+	if (nframes)
+		mt76_release_buffered_frames(hw, sta, tids, nframes, reason,
+					     more_data);
+}
+
+static int
+mt7603_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+	       struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+	       struct ieee80211_key_conf *key)
+{
+	struct mt7603_dev *dev = hw->priv;
+	struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
+	struct mt7603_sta *msta = sta ? (struct mt7603_sta *)sta->drv_priv :
+				  &mvif->sta;
+	struct mt76_wcid *wcid = &msta->wcid;
+	int idx = key->keyidx;
+
+	/* fall back to sw encryption for unsupported ciphers */
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * The hardware does not support per-STA RX GTK, fall back
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
+	return mt7603_wtbl_set_key(dev, wcid->idx, key);
+}
+
+static int
+mt7603_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
+	       const struct ieee80211_tx_queue_params *params)
+{
+	struct mt7603_dev *dev = hw->priv;
+	u16 cw_min = (1 << 5) - 1;
+	u16 cw_max = (1 << 10) - 1;
+	u32 val;
+
+	queue = dev->mt76.q_tx[queue].hw_idx;
+
+	if (params->cw_min)
+		cw_min = params->cw_min;
+	if (params->cw_max)
+		cw_max = params->cw_max;
+
+	mutex_lock(&dev->mt76.mutex);
+	mt7603_mac_stop(dev);
+
+	val = mt76_rr(dev, MT_WMM_TXOP(queue));
+	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(queue));
+	val |= params->txop << MT_WMM_TXOP_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_TXOP(queue), val);
+
+	val = mt76_rr(dev, MT_WMM_AIFSN);
+	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(queue));
+	val |= params->aifs << MT_WMM_AIFSN_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_AIFSN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMIN);
+	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(queue));
+	val |= cw_min << MT_WMM_CWMIN_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_CWMIN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMAX(queue));
+	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(queue));
+	val |= cw_max << MT_WMM_CWMAX_SHIFT(queue);
+	mt76_wr(dev, MT_WMM_CWMAX(queue), val);
+
+	mt7603_mac_start(dev);
+	mutex_unlock(&dev->mt76.mutex);
+
+	return 0;
+}
+
+static void
+mt7603_sw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	       const u8 *mac)
+{
+	struct mt7603_dev *dev = hw->priv;
+
+	set_bit(MT76_SCANNING, &dev->mt76.state);
+	mt7603_beacon_set_timer(dev, -1, 0);
+}
+
+static void
+mt7603_sw_scan_complete(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	struct mt7603_dev *dev = hw->priv;
+
+	clear_bit(MT76_SCANNING, &dev->mt76.state);
+	mt7603_beacon_set_timer(dev, -1, dev->beacon_int);
+}
+
+static void
+mt7603_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+	     u32 queues, bool drop)
+{
+}
+
+static int
+mt7603_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    struct ieee80211_ampdu_params *params)
+{
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	struct mt7603_dev *dev = hw->priv;
+	struct ieee80211_sta *sta = params->sta;
+	struct ieee80211_txq *txq = sta->txq[params->tid];
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	u8 ba_size = params->buf_size;
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
+		mt7603_mac_rx_ba_reset(dev, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		mtxq->aggr = true;
+		mtxq->send_bar = false;
+		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, ba_size);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		mtxq->aggr = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, -1);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		mtxq->agg_ssn = *ssn << 4;
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		mtxq->aggr = false;
+		mt7603_mac_tx_ba_reset(dev, msta->wcid.idx, tid, *ssn, -1);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	}
+
+	return 0;
+}
+
+static void
+mt7603_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta)
+{
+	struct mt7603_dev *dev = hw->priv;
+	struct mt7603_sta *msta = (struct mt7603_sta *)sta->drv_priv;
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
+	mt7603_wtbl_set_rates(dev, msta, NULL, msta->rates);
+	msta->rate_probe = false;
+	mt7603_wtbl_set_smps(dev, msta,
+			     sta->smps_mode == IEEE80211_SMPS_DYNAMIC);
+	spin_unlock_bh(&dev->mt76.lock);
+}
+
+static void
+mt7603_set_coverage_class(struct ieee80211_hw *hw, s16 coverage_class)
+{
+	struct mt7603_dev *dev = hw->priv;
+
+	dev->coverage_class = coverage_class;
+	mt7603_mac_set_timing(dev);
+}
+
+static void mt7603_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+		      struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_vif *vif = info->control.vif;
+	struct mt7603_dev *dev = hw->priv;
+	struct mt76_wcid *wcid = &dev->global_sta.wcid;
+
+	if (control->sta) {
+		struct mt7603_sta *msta;
+
+		msta = (struct mt7603_sta *)control->sta->drv_priv;
+		wcid = &msta->wcid;
+		/* sw encrypted frames */
+		if (!info->control.hw_key && wcid->hw_key_idx != 0xff &&
+		    ieee80211_has_protected(hdr->frame_control))
+			control->sta = NULL;
+	}
+
+	if (vif && !control->sta) {
+		struct mt7603_vif *mvif;
+
+		mvif = (struct mt7603_vif *)vif->drv_priv;
+		wcid = &mvif->sta.wcid;
+	}
+
+	mt76_tx(&dev->mt76, control->sta, wcid, skb);
+}
+
+static int
+mt7603_set_tim(struct ieee80211_hw *hw, struct ieee80211_sta *sta, bool set)
+{
+	return 0;
+}
+
+const struct ieee80211_ops mt7603_ops = {
+	.tx = mt7603_tx,
+	.start = mt7603_start,
+	.stop = mt7603_stop,
+	.add_interface = mt7603_add_interface,
+	.remove_interface = mt7603_remove_interface,
+	.config = mt7603_config,
+	.configure_filter = mt7603_configure_filter,
+	.bss_info_changed = mt7603_bss_info_changed,
+	.sta_state = mt76_sta_state,
+	.set_key = mt7603_set_key,
+	.conf_tx = mt7603_conf_tx,
+	.sw_scan_start = mt7603_sw_scan,
+	.sw_scan_complete = mt7603_sw_scan_complete,
+	.flush = mt7603_flush,
+	.ampdu_action = mt7603_ampdu_action,
+	.get_txpower = mt76_get_txpower,
+	.wake_tx_queue = mt76_wake_tx_queue,
+	.sta_rate_tbl_update = mt7603_sta_rate_tbl_update,
+	.release_buffered_frames = mt7603_release_buffered_frames,
+	.set_coverage_class = mt7603_set_coverage_class,
+	.set_tim = mt7603_set_tim,
+	.get_survey = mt76_get_survey,
+};
+
+MODULE_LICENSE("Dual BSD/GPL");
+
+static int __init mt7603_init(void)
+{
+	int ret;
+
+	ret = platform_driver_register(&mt76_wmac_driver);
+	if (ret)
+		return ret;
+
+#ifdef CONFIG_PCI
+	ret = pci_register_driver(&mt7603_pci_driver);
+	if (ret)
+		platform_driver_unregister(&mt76_wmac_driver);
+#endif
+	return ret;
+}
+
+static void __exit mt7603_exit(void)
+{
+#ifdef CONFIG_PCI
+	pci_unregister_driver(&mt7603_pci_driver);
+#endif
+	platform_driver_unregister(&mt76_wmac_driver);
+}
+
+module_init(mt7603_init);
+module_exit(mt7603_exit);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
new file mode 100644
index 000000000000..bd5b60ac7a24
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -0,0 +1,536 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include "mt7603.h"
+#include "mcu.h"
+#include "eeprom.h"
+
+#define MCU_SKB_RESERVE	8
+
+struct mt7603_fw_trailer {
+	char fw_ver[10];
+	char build_date[15];
+	__le32 dl_len;
+} __packed;
+
+static struct sk_buff *mt7603_mcu_msg_alloc(const void *data, int len)
+{
+	struct sk_buff *skb;
+
+	skb = alloc_skb(len + sizeof(struct mt7603_mcu_txd),
+			GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	skb_reserve(skb, sizeof(struct mt7603_mcu_txd));
+	if (data && len)
+		memcpy(skb_put(skb, len), data, len);
+
+	return skb;
+}
+
+void mt7603_mcu_rx_event(struct mt7603_dev *dev, struct sk_buff *skb)
+{
+	skb_queue_tail(&dev->mt76.mmio.mcu.res_q, skb);
+	wake_up(&dev->mt76.mmio.mcu.wait);
+}
+
+static struct sk_buff *
+mt7603_mcu_get_response(struct mt7603_dev *dev, unsigned long expires)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	unsigned long timeout;
+
+	if (!time_is_after_jiffies(expires))
+		return NULL;
+
+	timeout = expires - jiffies;
+	wait_event_timeout(mdev->mmio.mcu.wait,
+			   !skb_queue_empty(&mdev->mmio.mcu.res_q),
+			   timeout);
+	return skb_dequeue(&mdev->mmio.mcu.res_q);
+}
+
+static int
+__mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
+		      int query, int *wait_seq)
+{
+	int hdrlen = dev->mcu_running ? sizeof(struct mt7603_mcu_txd) : 12;
+	struct mt76_dev *mdev = &dev->mt76;
+	struct mt7603_mcu_txd *txd;
+	u8 seq;
+
+	if (!skb)
+		return -EINVAL;
+
+	seq = ++mdev->mmio.mcu.msg_seq & 0xf;
+	if (!seq)
+		seq = ++mdev->mmio.mcu.msg_seq & 0xf;
+
+	txd = (struct mt7603_mcu_txd *)skb_push(skb, hdrlen);
+	memset(txd, 0, hdrlen);
+
+	txd->len = cpu_to_le16(skb->len);
+	if (cmd == -MCU_CMD_FW_SCATTER)
+		txd->pq_id = cpu_to_le16(MCU_PORT_QUEUE_FW);
+	else
+		txd->pq_id = cpu_to_le16(MCU_PORT_QUEUE);
+	txd->pkt_type = MCU_PKT_ID;
+	txd->seq = seq;
+
+	if (cmd < 0) {
+		txd->cid = -cmd;
+	} else {
+		txd->cid = MCU_CMD_EXT_CID;
+		txd->ext_cid = cmd;
+		if (query != MCU_Q_NA)
+			txd->ext_cid_ack = 1;
+	}
+
+	txd->set_query = query;
+
+	if (wait_seq)
+		*wait_seq = seq;
+
+	return mt7603_tx_queue_mcu(dev, MT_TXQ_MCU, skb);
+}
+
+static int
+mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
+		    int query)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	unsigned long expires = jiffies + 3 * HZ;
+	struct mt7603_mcu_rxd *rxd;
+	int ret, seq;
+
+	mutex_lock(&mdev->mmio.mcu.mutex);
+
+	ret = __mt7603_mcu_msg_send(dev, skb, cmd, query, &seq);
+	if (ret)
+		goto out;
+
+	while (1) {
+		bool check_seq = false;
+
+		skb = mt7603_mcu_get_response(dev, expires);
+		if (!skb) {
+			dev_err(mdev->dev,
+				"MCU message %d (seq %d) timed out\n",
+				cmd, seq);
+			dev->mcu_hang = MT7603_WATCHDOG_TIMEOUT;
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		rxd = (struct mt7603_mcu_rxd *)skb->data;
+		if (seq == rxd->seq)
+			check_seq = true;
+
+		dev_kfree_skb(skb);
+
+		if (check_seq)
+			break;
+	}
+
+out:
+	mutex_unlock(&mdev->mmio.mcu.mutex);
+
+	return ret;
+}
+
+static int
+mt7603_mcu_init_download(struct mt7603_dev *dev, u32 addr, u32 len)
+{
+	struct {
+		__le32 addr;
+		__le32 len;
+		__le32 mode;
+	} req = {
+		.addr = cpu_to_le32(addr),
+		.len = cpu_to_le32(len),
+		.mode = cpu_to_le32(BIT(31)),
+	};
+	struct sk_buff *skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_TARGET_ADDRESS_LEN_REQ,
+				   MCU_Q_NA);
+}
+
+static int
+mt7603_mcu_send_firmware(struct mt7603_dev *dev, const void *data, int len)
+{
+	struct sk_buff *skb;
+	int ret = 0;
+
+	while (len > 0) {
+		int cur_len = min_t(int, 4096 - sizeof(struct mt7603_mcu_txd),
+				    len);
+
+		skb = mt7603_mcu_msg_alloc(data, cur_len);
+		if (!skb)
+			return -ENOMEM;
+
+		ret = __mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_SCATTER,
+					    MCU_Q_NA, NULL);
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
+static int
+mt7603_mcu_start_firmware(struct mt7603_dev *dev, u32 addr)
+{
+	struct {
+		__le32 override;
+		__le32 addr;
+	} req = {
+		.override = cpu_to_le32(addr ? 1 : 0),
+		.addr = cpu_to_le32(addr),
+	};
+	struct sk_buff *skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
+
+	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_START_REQ,
+				   MCU_Q_NA);
+}
+
+static int
+mt7603_mcu_restart(struct mt7603_dev *dev)
+{
+	struct sk_buff *skb = mt7603_mcu_msg_alloc(NULL, 0);
+
+	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_RESTART_DL_REQ,
+				   MCU_Q_NA);
+}
+
+static int
+mt7603_load_firmware(struct mt7603_dev *dev)
+{
+	const struct firmware *fw;
+	const struct mt7603_fw_trailer *hdr;
+	const char *firmware;
+	int dl_len;
+	u32 addr, val;
+	int ret;
+
+	if (is_mt7628(dev)) {
+		if (mt76xx_rev(dev) == MT7628_REV_E1)
+			firmware = MT7628_FIRMWARE_E1;
+		else
+			firmware = MT7628_FIRMWARE_E2;
+	} else {
+		if (mt76xx_rev(dev) < MT7603_REV_E2)
+			firmware = MT7603_FIRMWARE_E1;
+		else
+			firmware = MT7603_FIRMWARE_E2;
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
+	hdr = (const struct mt7603_fw_trailer *)(fw->data + fw->size -
+						 sizeof(*hdr));
+
+	dev_info(dev->mt76.dev, "Firmware Version: %.10s\n", hdr->fw_ver);
+	dev_info(dev->mt76.dev, "Build Time: %.15s\n", hdr->build_date);
+
+	addr = mt7603_reg_map(dev, 0x50012498);
+	mt76_wr(dev, addr, 0x5);
+	mt76_wr(dev, addr, 0x5);
+	udelay(1);
+
+	/* switch to bypass mode */
+	mt76_rmw(dev, MT_SCH_4, MT_SCH_4_FORCE_QID,
+		 MT_SCH_4_BYPASS | FIELD_PREP(MT_SCH_4_FORCE_QID, 5));
+
+	val = mt76_rr(dev, MT_TOP_MISC2);
+	if (val & BIT(1)) {
+		dev_info(dev->mt76.dev, "Firmware already running...\n");
+		goto running;
+	}
+
+	if (!mt76_poll_msec(dev, MT_TOP_MISC2, BIT(0) | BIT(1), BIT(0), 500)) {
+		dev_err(dev->mt76.dev, "Timeout waiting for ROM code to become ready\n");
+		ret = -EIO;
+		goto out;
+	}
+
+	dl_len = le32_to_cpu(hdr->dl_len) + 4;
+	ret = mt7603_mcu_init_download(dev, MCU_FIRMWARE_ADDRESS, dl_len);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Download request failed\n");
+		goto out;
+	}
+
+	ret = mt7603_mcu_send_firmware(dev, fw->data, dl_len);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Failed to send firmware to device\n");
+		goto out;
+	}
+
+	ret = mt7603_mcu_start_firmware(dev, MCU_FIRMWARE_ADDRESS);
+	if (ret) {
+		dev_err(dev->mt76.dev, "Failed to start firmware\n");
+		goto out;
+	}
+
+	if (!mt76_poll_msec(dev, MT_TOP_MISC2, BIT(1), BIT(1), 500)) {
+		dev_err(dev->mt76.dev, "Timeout waiting for firmware to initialize\n");
+		ret = -EIO;
+		goto out;
+	}
+
+running:
+	mt76_clear(dev, MT_SCH_4, MT_SCH_4_FORCE_QID | MT_SCH_4_BYPASS);
+
+	mt76_set(dev, MT_SCH_4, BIT(8));
+	mt76_clear(dev, MT_SCH_4, BIT(8));
+
+	dev->mcu_running = true;
+	dev_info(dev->mt76.dev, "firmware init done\n");
+
+out:
+	release_firmware(fw);
+
+	return ret;
+}
+
+int mt7603_mcu_init(struct mt7603_dev *dev)
+{
+	mutex_init(&dev->mt76.mmio.mcu.mutex);
+
+	return mt7603_load_firmware(dev);
+}
+
+void mt7603_mcu_exit(struct mt7603_dev *dev)
+{
+	mt7603_mcu_restart(dev);
+	skb_queue_purge(&dev->mt76.mmio.mcu.res_q);
+}
+
+int mt7603_mcu_set_eeprom(struct mt7603_dev *dev)
+{
+	static const u16 req_fields[] = {
+#define WORD(_start)			\
+		_start,			\
+		_start + 1
+#define GROUP_2G(_start)		\
+		WORD(_start),		\
+		WORD(_start + 2),	\
+		WORD(_start + 4)
+
+		MT_EE_NIC_CONF_0 + 1,
+		WORD(MT_EE_NIC_CONF_1),
+		MT_EE_WIFI_RF_SETTING,
+		MT_EE_TX_POWER_DELTA_BW40,
+		MT_EE_TX_POWER_DELTA_BW80 + 1,
+		MT_EE_TX_POWER_EXT_PA_5G,
+		MT_EE_TEMP_SENSOR_CAL,
+		GROUP_2G(MT_EE_TX_POWER_0_START_2G),
+		GROUP_2G(MT_EE_TX_POWER_1_START_2G),
+		WORD(MT_EE_TX_POWER_CCK),
+		WORD(MT_EE_TX_POWER_OFDM_2G_6M),
+		WORD(MT_EE_TX_POWER_OFDM_2G_24M),
+		WORD(MT_EE_TX_POWER_OFDM_2G_54M),
+		WORD(MT_EE_TX_POWER_HT_BPSK_QPSK),
+		WORD(MT_EE_TX_POWER_HT_16_64_QAM),
+		WORD(MT_EE_TX_POWER_HT_64_QAM),
+		MT_EE_ELAN_RX_MODE_GAIN,
+		MT_EE_ELAN_RX_MODE_NF,
+		MT_EE_ELAN_RX_MODE_P1DB,
+		MT_EE_ELAN_BYPASS_MODE_GAIN,
+		MT_EE_ELAN_BYPASS_MODE_NF,
+		MT_EE_ELAN_BYPASS_MODE_P1DB,
+		WORD(MT_EE_STEP_NUM_NEG_6_7),
+		WORD(MT_EE_STEP_NUM_NEG_4_5),
+		WORD(MT_EE_STEP_NUM_NEG_2_3),
+		WORD(MT_EE_STEP_NUM_NEG_0_1),
+		WORD(MT_EE_REF_STEP_24G),
+		WORD(MT_EE_STEP_NUM_PLUS_1_2),
+		WORD(MT_EE_STEP_NUM_PLUS_3_4),
+		WORD(MT_EE_STEP_NUM_PLUS_5_6),
+		MT_EE_STEP_NUM_PLUS_7,
+		MT_EE_XTAL_FREQ_OFFSET,
+		MT_EE_XTAL_TRIM_2_COMP,
+		MT_EE_XTAL_TRIM_3_COMP,
+		MT_EE_XTAL_WF_RFCAL,
+
+		/* unknown fields below */
+		WORD(0x24),
+		0x34,
+		0x39,
+		0x3b,
+		WORD(0x42),
+		WORD(0x9e),
+		0xf2,
+		WORD(0xf8),
+		0xfa,
+		0x12e,
+		WORD(0x130), WORD(0x132), WORD(0x134), WORD(0x136),
+		WORD(0x138), WORD(0x13a), WORD(0x13c), WORD(0x13e),
+
+#undef GROUP_2G
+#undef WORD
+
+	};
+	struct req_data {
+		u16 addr;
+		u8 val;
+		u8 pad;
+	} __packed;
+	struct {
+		u8 buffer_mode;
+		u8 len;
+		u8 pad[2];
+	} req_hdr = {
+		.buffer_mode = 1,
+		.len = ARRAY_SIZE(req_fields) - 1,
+	};
+	struct sk_buff *skb;
+	struct req_data *data;
+	const int size = 0xff * sizeof(struct req_data);
+	u8 *eep = (u8 *)dev->mt76.eeprom.data;
+	int i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(req_fields) * sizeof(*data) > size);
+
+	skb = mt7603_mcu_msg_alloc(NULL, size + sizeof(req_hdr));
+	memcpy(skb_put(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
+	data = (struct req_data *)skb_put(skb, size);
+	memset(data, 0, size);
+
+	for (i = 0; i < ARRAY_SIZE(req_fields); i++) {
+		data[i].addr = cpu_to_le16(req_fields[i]);
+		data[i].val = eep[req_fields[i]];
+		data[i].pad = 0;
+	}
+
+	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
+				   MCU_Q_SET);
+}
+
+static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
+{
+	struct {
+		u8 center_channel;
+		u8 tssi;
+		u8 temp_comp;
+		u8 target_power[2];
+		u8 rate_power_delta[14];
+		u8 bw_power_delta;
+		u8 ch_power_delta[6];
+		u8 temp_comp_power[17];
+		u8 reserved;
+	} req = {
+		.center_channel = dev->mt76.chandef.chan->hw_value,
+#define EEP_VAL(n) ((u8 *)dev->mt76.eeprom.data)[n]
+		.tssi = EEP_VAL(MT_EE_NIC_CONF_1 + 1),
+		.temp_comp = EEP_VAL(MT_EE_NIC_CONF_1),
+		.target_power = {
+			EEP_VAL(MT_EE_TX_POWER_0_START_2G + 2),
+			EEP_VAL(MT_EE_TX_POWER_1_START_2G + 2)
+		},
+		.bw_power_delta = EEP_VAL(MT_EE_TX_POWER_DELTA_BW40),
+		.ch_power_delta = {
+			EEP_VAL(MT_EE_TX_POWER_0_START_2G + 3),
+			EEP_VAL(MT_EE_TX_POWER_0_START_2G + 4),
+			EEP_VAL(MT_EE_TX_POWER_0_START_2G + 5),
+			EEP_VAL(MT_EE_TX_POWER_1_START_2G + 3),
+			EEP_VAL(MT_EE_TX_POWER_1_START_2G + 4),
+			EEP_VAL(MT_EE_TX_POWER_1_START_2G + 5)
+		},
+#undef EEP_VAL
+	};
+	struct sk_buff *skb;
+	u8 *eep = (u8 *)dev->mt76.eeprom.data;
+
+	memcpy(req.rate_power_delta, eep + MT_EE_TX_POWER_CCK,
+	       sizeof(req.rate_power_delta));
+
+	memcpy(req.temp_comp_power, eep + MT_EE_STEP_NUM_NEG_6_7,
+	       sizeof(req.temp_comp_power));
+
+	skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
+	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_SET_TX_POWER_CTRL,
+				   MCU_Q_SET);
+}
+
+int mt7603_mcu_set_channel(struct mt7603_dev *dev)
+{
+	struct cfg80211_chan_def *chandef = &dev->mt76.chandef;
+	struct ieee80211_hw *hw = mt76_hw(dev);
+	int n_chains = __sw_hweight8(dev->mt76.antenna_mask);
+	struct {
+		u8 control_chan;
+		u8 center_chan;
+		u8 bw;
+		u8 tx_streams;
+		u8 rx_streams;
+		u8 _res0[7];
+		u8 txpower[21];
+		u8 _res1[3];
+	} req = {
+		.control_chan = chandef->chan->hw_value,
+		.center_chan = chandef->chan->hw_value,
+		.bw = MT_BW_20,
+		.tx_streams = n_chains,
+		.rx_streams = n_chains,
+	};
+	struct sk_buff *skb;
+	s8 tx_power;
+	int ret;
+	int i;
+
+	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_40) {
+		req.bw = MT_BW_40;
+		if (chandef->center_freq1 > chandef->chan->center_freq)
+			req.center_chan += 2;
+		else
+			req.center_chan -= 2;
+	}
+
+	tx_power = hw->conf.power_level * 2;
+	if (dev->mt76.antenna_mask == 3)
+		tx_power -= 6;
+	tx_power = min(tx_power, dev->tx_power_limit);
+
+	dev->mt76.txpower_cur = tx_power;
+
+	for (i = 0; i < ARRAY_SIZE(req.txpower); i++)
+		req.txpower[i] = tx_power;
+
+	skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
+	ret = mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_CHANNEL_SWITCH,
+				  MCU_Q_SET);
+	if (ret)
+		return ret;
+
+	return mt7603_mcu_set_tx_power(dev);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.h b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.h
new file mode 100644
index 000000000000..3cdb4e6e0c9d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#ifndef __MT7603_MCU_H
+#define __MT7603_MCU_H
+
+struct mt7603_mcu_txd {
+	__le16 len;
+	__le16 pq_id;
+
+	u8 cid;
+	u8 pkt_type;
+	u8 set_query;
+	u8 seq;
+
+	u8 uc_d2b0_rev;
+	u8 ext_cid;
+	u8 uc_d2b2_rev;
+	u8 ext_cid_ack;
+
+	u32 au4_d3_to_d7_rev[5];
+} __packed __aligned(4);
+
+struct mt7603_mcu_rxd {
+	__le16 len;
+	__le16 pkt_type_id;
+
+	u8 eid;
+	u8 seq;
+	__le16 __rsv;
+
+	u8 ext_eid;
+	u8 __rsv1[3];
+};
+
+#define MCU_PKT_ID		0xa0
+#define MCU_PORT_QUEUE		0x8000
+#define MCU_PORT_QUEUE_FW	0xc000
+
+#define MCU_FIRMWARE_ADDRESS	0x100000
+
+enum {
+	MCU_Q_QUERY,
+	MCU_Q_SET,
+	MCU_Q_RESERVED,
+	MCU_Q_NA
+};
+
+enum {
+	MCU_CMD_TARGET_ADDRESS_LEN_REQ = 0x01,
+	MCU_CMD_FW_START_REQ = 0x02,
+	MCU_CMD_INIT_ACCESS_REG = 0x3,
+	MCU_CMD_PATCH_START_REQ = 0x05,
+	MCU_CMD_PATCH_FINISH_REQ = 0x07,
+	MCU_CMD_PATCH_SEM_CONTROL = 0x10,
+	MCU_CMD_HIF_LOOPBACK = 0x20,
+	MCU_CMD_CH_PRIVILEGE = 0x20,
+	MCU_CMD_ACCESS_REG = 0xC2,
+	MCU_CMD_EXT_CID = 0xED,
+	MCU_CMD_FW_SCATTER = 0xEE,
+	MCU_CMD_RESTART_DL_REQ = 0xEF,
+};
+
+enum {
+	MCU_EXT_CMD_RF_REG_ACCESS = 0x02,
+	MCU_EXT_CMD_RF_TEST = 0x04,
+	MCU_EXT_CMD_RADIO_ON_OFF_CTRL = 0x05,
+	MCU_EXT_CMD_WIFI_RX_DISABLE = 0x06,
+	MCU_EXT_CMD_PM_STATE_CTRL = 0x07,
+	MCU_EXT_CMD_CHANNEL_SWITCH = 0x08,
+	MCU_EXT_CMD_NIC_CAPABILITY = 0x09,
+	MCU_EXT_CMD_PWR_SAVING = 0x0A,
+	MCU_EXT_CMD_MULTIPLE_REG_ACCESS = 0x0E,
+	MCU_EXT_CMD_AP_PWR_SAVING_CAPABILITY = 0xF,
+	MCU_EXT_CMD_SEC_ADDREMOVE_KEY = 0x10,
+	MCU_EXT_CMD_SET_TX_POWER_CTRL = 0x11,
+	MCU_EXT_CMD_FW_LOG_2_HOST = 0x13,
+	MCU_EXT_CMD_PS_RETRIEVE_START = 0x14,
+	MCU_EXT_CMD_LED_CTRL = 0x17,
+	MCU_EXT_CMD_PACKET_FILTER = 0x18,
+	MCU_EXT_CMD_PWR_MGT_BIT_WIFI = 0x1B,
+	MCU_EXT_CMD_EFUSE_BUFFER_MODE = 0x21,
+	MCU_EXT_CMD_THERMAL_PROTECT = 0x23,
+	MCU_EXT_CMD_EDCA_SET = 0x27,
+	MCU_EXT_CMD_SLOT_TIME_SET = 0x28,
+	MCU_EXT_CMD_CONFIG_INTERNAL_SETTING = 0x29,
+	MCU_EXT_CMD_NOA_OFFLOAD_CTRL = 0x2B,
+	MCU_EXT_CMD_GET_THEMAL_SENSOR = 0x2C,
+	MCU_EXT_CMD_WAKEUP_OPTION = 0x2E,
+	MCU_EXT_CMD_AC_QUEUE_CONTROL = 0x31,
+	MCU_EXT_CMD_BCN_UPDATE = 0x33
+};
+
+enum {
+	MCU_EXT_EVENT_CMD_RESULT = 0x0,
+	MCU_EXT_EVENT_RF_REG_ACCESS = 0x2,
+	MCU_EXT_EVENT_MULTI_CR_ACCESS = 0x0E,
+	MCU_EXT_EVENT_FW_LOG_2_HOST = 0x13,
+	MCU_EXT_EVENT_BEACON_LOSS = 0x1A,
+	MCU_EXT_EVENT_THERMAL_PROTECT = 0x22,
+	MCU_EXT_EVENT_BCN_UPDATE = 0x31,
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
new file mode 100644
index 000000000000..8b9297d0ec89
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -0,0 +1,271 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#ifndef __MT7603_H
+#define __MT7603_H
+
+#include <linux/interrupt.h>
+#include <linux/ktime.h>
+#include "../mt76.h"
+#include "regs.h"
+
+#define MT7603_MAX_INTERFACES	4
+#define MT7603_WTBL_SIZE	128
+#define MT7603_WTBL_RESERVED	(MT7603_WTBL_SIZE - 1)
+#define MT7603_WTBL_STA		(MT7603_WTBL_RESERVED - MT7603_MAX_INTERFACES)
+
+#define MT7603_RATE_RETRY	2
+
+#define MT7603_RX_RING_SIZE     128
+
+#define MT7603_FIRMWARE_E1	"mt7603_e1.bin"
+#define MT7603_FIRMWARE_E2	"mt7603_e2.bin"
+#define MT7628_FIRMWARE_E1	"mt7628_e1.bin"
+#define MT7628_FIRMWARE_E2	"mt7628_e2.bin"
+
+#define MT7603_EEPROM_SIZE	1024
+
+#define MT_AGG_SIZE_LIMIT(_n)	(((_n) + 1) * 4)
+
+#define MT7603_PRE_TBTT_TIME	5000 /* ms */
+
+#define MT7603_WATCHDOG_TIME	100 /* ms */
+#define MT7603_WATCHDOG_TIMEOUT	10 /* number of checks */
+
+#define MT7603_EDCCA_BLOCK_TH	10
+
+#define MT7603_CFEND_RATE_DEFAULT	0x69 /* chip default (24M) */
+#define MT7603_CFEND_RATE_11B		0x03 /* 11B LP, 11M */
+
+struct mt7603_vif;
+struct mt7603_sta;
+
+enum {
+	MT7603_REV_E1 = 0x00,
+	MT7603_REV_E2 = 0x10,
+	MT7628_REV_E1 = 0x8a00,
+};
+
+enum mt7603_bw {
+	MT_BW_20,
+	MT_BW_40,
+	MT_BW_80,
+};
+
+struct mt7603_sta {
+	struct mt76_wcid wcid; /* must be first */
+
+	struct mt7603_vif *vif;
+
+	struct sk_buff_head psq;
+
+	struct ieee80211_tx_rate rates[8];
+	u8 rate_count;
+	u8 n_rates;
+
+	u8 rate_probe;
+	u8 smps;
+
+	u8 ps;
+};
+
+struct mt7603_vif {
+	struct mt7603_sta sta; /* must be first */
+
+	u8 idx;
+};
+
+enum mt7603_reset_cause {
+	RESET_CAUSE_TX_HANG,
+	RESET_CAUSE_TX_BUSY,
+	RESET_CAUSE_RX_BUSY,
+	RESET_CAUSE_BEACON_STUCK,
+	RESET_CAUSE_RX_PSE_BUSY,
+	RESET_CAUSE_MCU_HANG,
+	RESET_CAUSE_RESET_FAILED,
+	__RESET_CAUSE_MAX
+};
+
+struct mt7603_dev {
+	struct mt76_dev mt76; /* must be first */
+
+	const struct mt76_bus_ops *bus_ops;
+
+	u32 rxfilter;
+
+	u8 vif_mask;
+
+	struct mt7603_sta global_sta;
+
+	u32 agc0, agc3;
+	u32 false_cca_ofdm, false_cca_cck;
+	unsigned long last_cca_adj;
+
+	u8 rssi_offset[3];
+
+	u8 slottime;
+	s16 coverage_class;
+
+	s8 tx_power_limit;
+
+	ktime_t survey_time;
+	ktime_t ed_time;
+	int beacon_int;
+
+	struct mt76_queue q_rx;
+
+	spinlock_t ps_lock;
+
+	u8 mac_work_count;
+
+	u8 mcu_running;
+	u8 ed_monitor;
+
+	s8 ed_trigger;
+	u8 ed_strict_mode;
+	u8 ed_strong_signal;
+
+	s8 sensitivity;
+
+	u8 beacon_mask;
+
+	u8 beacon_check;
+	u8 tx_hang_check;
+	u8 tx_dma_check;
+	u8 rx_dma_check;
+	u8 rx_pse_check;
+	u8 mcu_hang;
+
+	enum mt7603_reset_cause cur_reset_cause;
+
+	u16 tx_dma_idx[4];
+	u16 rx_dma_idx;
+
+	u32 reset_test;
+
+	unsigned int reset_cause[__RESET_CAUSE_MAX];
+
+	struct delayed_work mac_work;
+	struct tasklet_struct tx_tasklet;
+	struct tasklet_struct pre_tbtt_tasklet;
+};
+
+extern const struct ieee80211_ops mt7603_ops;
+extern struct pci_driver mt7603_pci_driver;
+extern struct platform_driver mt76_wmac_driver;
+
+static inline bool is_mt7603(struct mt7603_dev *dev)
+{
+	return mt76xx_chip(dev) == 0x7603;
+}
+
+static inline bool is_mt7628(struct mt7603_dev *dev)
+{
+	return mt76xx_chip(dev) == 0x7628;
+}
+
+/* need offset to prevent conflict with ampdu_ack_len */
+#define MT_RATE_DRIVER_DATA_OFFSET	4
+
+u32 mt7603_reg_map(struct mt7603_dev *dev, u32 addr);
+
+struct mt7603_dev *mt7603_alloc_device(struct device *pdev);
+irqreturn_t mt7603_irq_handler(int irq, void *dev_instance);
+
+int mt7603_register_device(struct mt7603_dev *dev);
+void mt7603_unregister_device(struct mt7603_dev *dev);
+int mt7603_eeprom_init(struct mt7603_dev *dev);
+int mt7603_dma_init(struct mt7603_dev *dev);
+void mt7603_dma_cleanup(struct mt7603_dev *dev);
+int mt7603_mcu_init(struct mt7603_dev *dev);
+int mt7603_tx_queue_mcu(struct mt7603_dev *dev, enum mt76_txq_id qid,
+			struct sk_buff *skb);
+void mt7603_mcu_rx_event(struct mt7603_dev *dev, struct sk_buff *skb);
+void mt7603_init_debugfs(struct mt7603_dev *dev);
+
+void mt7603_set_irq_mask(struct mt7603_dev *dev, u32 clear, u32 set);
+
+static inline void mt7603_irq_enable(struct mt7603_dev *dev, u32 mask)
+{
+	mt7603_set_irq_mask(dev, 0, mask);
+}
+
+static inline void mt7603_irq_disable(struct mt7603_dev *dev, u32 mask)
+{
+	mt7603_set_irq_mask(dev, mask, 0);
+}
+
+void mt7603_mac_dma_start(struct mt7603_dev *dev);
+void mt7603_mac_start(struct mt7603_dev *dev);
+void mt7603_mac_stop(struct mt7603_dev *dev);
+void mt7603_mac_work(struct work_struct *work);
+void mt7603_mac_set_timing(struct mt7603_dev *dev);
+void mt7603_beacon_set_timer(struct mt7603_dev *dev, int idx, int intval);
+int mt7603_mac_fill_rx(struct mt7603_dev *dev, struct sk_buff *skb);
+void mt7603_mac_add_txs(struct mt7603_dev *dev, void *data);
+void mt7603_mac_rx_ba_reset(struct mt7603_dev *dev, void *addr, u8 tid);
+void mt7603_mac_tx_ba_reset(struct mt7603_dev *dev, int wcid, int tid, int ssn,
+			    int ba_size);
+
+void mt7603_pse_client_reset(struct mt7603_dev *dev);
+
+int mt7603_mcu_set_channel(struct mt7603_dev *dev);
+int mt7603_mcu_set_eeprom(struct mt7603_dev *dev);
+void mt7603_mcu_exit(struct mt7603_dev *dev);
+
+void mt7603_wtbl_init(struct mt7603_dev *dev, int idx, int vif,
+		      const u8 *mac_addr);
+void mt7603_wtbl_clear(struct mt7603_dev *dev, int idx);
+void mt7603_wtbl_update_cap(struct mt7603_dev *dev, struct ieee80211_sta *sta);
+void mt7603_wtbl_set_rates(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			   struct ieee80211_tx_rate *probe_rate,
+			   struct ieee80211_tx_rate *rates);
+int mt7603_wtbl_set_key(struct mt7603_dev *dev, int wcid,
+			struct ieee80211_key_conf *key);
+void mt7603_wtbl_set_ps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			bool enabled);
+void mt7603_wtbl_set_smps(struct mt7603_dev *dev, struct mt7603_sta *sta,
+			  bool enabled);
+void mt7603_filter_tx(struct mt7603_dev *dev, int idx, bool abort);
+
+int mt7603_tx_prepare_skb(struct mt76_dev *mdev, void *txwi_ptr,
+			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  u32 *tx_info);
+
+void mt7603_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
+			    struct mt76_queue_entry *e, bool flush);
+
+void mt7603_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb);
+void mt7603_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
+void mt7603_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps);
+int mt7603_sta_add(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		   struct ieee80211_sta *sta);
+void mt7603_sta_assoc(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		      struct ieee80211_sta *sta);
+void mt7603_sta_remove(struct mt76_dev *mdev, struct ieee80211_vif *vif,
+		       struct ieee80211_sta *sta);
+
+void mt7603_pre_tbtt_tasklet(unsigned long arg);
+
+void mt7603_update_channel(struct mt76_dev *mdev);
+
+void mt7603_edcca_set_strict(struct mt7603_dev *dev, bool val);
+void mt7603_cca_stats_reset(struct mt7603_dev *dev);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/pci.c b/drivers/net/wireless/mediatek/mt76/mt7603/pci.c
new file mode 100644
index 000000000000..cc740bcf1e07
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/pci.c
@@ -0,0 +1,92 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include <linux/pci.h>
+
+#include "mt7603.h"
+
+static const struct pci_device_id mt76pci_device_table[] = {
+	{ PCI_DEVICE(0x14c3, 0x7603) },
+	{ },
+};
+
+static int
+mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
+{
+	struct mt7603_dev *dev;
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
+	dev = mt7603_alloc_device(&pdev->dev);
+	if (!dev)
+		return -ENOMEM;
+
+	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+
+	dev->mt76.rev = (mt76_rr(dev, MT_HW_CHIPID) << 16) |
+			(mt76_rr(dev, MT_HW_REV) & 0xff);
+	dev_info(dev->mt76.dev, "ASIC revision: %04x\n", dev->mt76.rev);
+
+	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt7603_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (ret)
+		goto error;
+
+	ret = mt7603_register_device(dev);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	ieee80211_free_hw(mt76_hw(dev));
+	return ret;
+}
+
+static void
+mt76pci_remove(struct pci_dev *pdev)
+{
+	struct mt76_dev *mdev = pci_get_drvdata(pdev);
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+
+	mt7603_unregister_device(dev);
+}
+
+MODULE_DEVICE_TABLE(pci, mt76pci_device_table);
+MODULE_FIRMWARE(MT7603_FIRMWARE_E1);
+MODULE_FIRMWARE(MT7603_FIRMWARE_E2);
+
+struct pci_driver mt7603_pci_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= mt76pci_device_table,
+	.probe		= mt76pci_probe,
+	.remove		= mt76pci_remove,
+};
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
new file mode 100644
index 000000000000..5d61e222f227
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
@@ -0,0 +1,789 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#ifndef __MT7603_REGS_H
+#define __MT7603_REGS_H
+
+#define MT_HW_REV			0x1000
+#define MT_HW_CHIPID			0x1008
+#define MT_TOP_MISC2			0x1134
+
+#define MT_MCU_BASE			0x2000
+#define MT_MCU(ofs)			(MT_MCU_BASE + (ofs))
+
+#define MT_MCU_PCIE_REMAP_1		MT_MCU(0x500)
+#define MT_MCU_PCIE_REMAP_1_OFFSET	GENMASK(17, 0)
+#define MT_MCU_PCIE_REMAP_1_BASE	GENMASK(31, 18)
+
+#define MT_MCU_PCIE_REMAP_2		MT_MCU(0x504)
+#define MT_MCU_PCIE_REMAP_2_OFFSET	GENMASK(18, 0)
+#define MT_MCU_PCIE_REMAP_2_BASE	GENMASK(31, 19)
+
+#define MT_HIF_BASE			0x4000
+#define MT_HIF(ofs)			(MT_HIF_BASE + (ofs))
+
+#define MT_INT_SOURCE_CSR		MT_HIF(0x200)
+#define MT_INT_MASK_CSR			MT_HIF(0x204)
+#define MT_DELAY_INT_CFG		MT_HIF(0x210)
+
+#define MT_INT_RX_DONE(_n)		BIT(_n)
+#define MT_INT_RX_DONE_ALL		GENMASK(1, 0)
+#define MT_INT_TX_DONE_ALL		GENMASK(19, 4)
+#define MT_INT_TX_DONE(_n)		BIT((_n) + 4)
+
+#define MT_INT_RX_COHERENT		BIT(20)
+#define MT_INT_TX_COHERENT		BIT(21)
+#define MT_INT_MAC_IRQ3			BIT(27)
+
+#define MT_INT_MCU_CMD			BIT(30)
+
+#define MT_WPDMA_GLO_CFG		MT_HIF(0x208)
+#define MT_WPDMA_GLO_CFG_TX_DMA_EN	BIT(0)
+#define MT_WPDMA_GLO_CFG_TX_DMA_BUSY	BIT(1)
+#define MT_WPDMA_GLO_CFG_RX_DMA_EN	BIT(2)
+#define MT_WPDMA_GLO_CFG_RX_DMA_BUSY	BIT(3)
+#define MT_WPDMA_GLO_CFG_DMA_BURST_SIZE	GENMASK(5, 4)
+#define MT_WPDMA_GLO_CFG_TX_WRITEBACK_DONE	BIT(6)
+#define MT_WPDMA_GLO_CFG_BIG_ENDIAN	BIT(7)
+#define MT_WPDMA_GLO_CFG_HDR_SEG_LEN	GENMASK(15, 8)
+#define MT_WPDMA_GLO_CFG_SW_RESET	BIT(24)
+#define MT_WPDMA_GLO_CFG_FORCE_TX_EOF	BIT(25)
+#define MT_WPDMA_GLO_CFG_CLK_GATE_DIS	BIT(30)
+#define MT_WPDMA_GLO_CFG_RX_2B_OFFSET	BIT(31)
+
+#define MT_WPDMA_RST_IDX		MT_HIF(0x20c)
+
+#define MT_WPDMA_DEBUG			MT_HIF(0x244)
+#define MT_WPDMA_DEBUG_VALUE		GENMASK(17, 0)
+#define MT_WPDMA_DEBUG_SEL		BIT(27)
+#define MT_WPDMA_DEBUG_IDX		GENMASK(31, 28)
+
+#define MT_TX_RING_BASE			MT_HIF(0x300)
+#define MT_RX_RING_BASE			MT_HIF(0x400)
+
+#define MT_TXTIME_THRESH_BASE		MT_HIF(0x500)
+#define MT_TXTIME_THRESH(n)		(MT_TXTIME_THRESH_BASE + ((n) * 4))
+
+#define MT_PAGE_COUNT_BASE		MT_HIF(0x540)
+#define MT_PAGE_COUNT(n)		(MT_PAGE_COUNT_BASE + ((n) * 4))
+
+#define MT_SCH_1			MT_HIF(0x588)
+#define MT_SCH_2			MT_HIF(0x58c)
+#define MT_SCH_3			MT_HIF(0x590)
+
+#define MT_SCH_4			MT_HIF(0x594)
+#define MT_SCH_4_FORCE_QID		GENMASK(4, 0)
+#define MT_SCH_4_BYPASS			BIT(5)
+#define MT_SCH_4_RESET			BIT(8)
+
+#define MT_GROUP_THRESH_BASE		MT_HIF(0x598)
+#define MT_GROUP_THRESH(n)		(MT_GROUP_THRESH_BASE + ((n) * 4))
+
+#define MT_QUEUE_PRIORITY_1		MT_HIF(0x580)
+#define MT_QUEUE_PRIORITY_2		MT_HIF(0x584)
+
+#define MT_BMAP_0			MT_HIF(0x5b0)
+#define MT_BMAP_1			MT_HIF(0x5b4)
+#define MT_BMAP_2			MT_HIF(0x5b8)
+
+#define MT_HIGH_PRIORITY_1		MT_HIF(0x5bc)
+#define MT_HIGH_PRIORITY_2		MT_HIF(0x5c0)
+
+#define MT_PRIORITY_MASK		MT_HIF(0x5c4)
+
+#define MT_RSV_MAX_THRESH		MT_HIF(0x5c8)
+
+#define MT_PSE_BASE			0x8000
+#define MT_PSE(ofs)			(MT_PSE_BASE + (ofs))
+
+#define MT_MCU_DEBUG_RESET		MT_PSE(0x16c)
+#define MT_MCU_DEBUG_RESET_PSE		BIT(0)
+#define MT_MCU_DEBUG_RESET_PSE_S	BIT(1)
+#define MT_MCU_DEBUG_RESET_QUEUES	GENMASK(6, 2)
+
+#define MT_PSE_FC_P0			MT_PSE(0x120)
+#define MT_PSE_FC_P0_MIN_RESERVE	GENMASK(11, 0)
+#define MT_PSE_FC_P0_MAX_QUOTA		GENMASK(27, 16)
+
+#define MT_PSE_FRP			MT_PSE(0x138)
+#define MT_PSE_FRP_P0			GENMASK(2, 0)
+#define MT_PSE_FRP_P1			GENMASK(5, 3)
+#define MT_PSE_FRP_P2_RQ0		GENMASK(8, 6)
+#define MT_PSE_FRP_P2_RQ1		GENMASK(11, 9)
+#define MT_PSE_FRP_P2_RQ2		GENMASK(14, 12)
+
+#define MT_FC_RSV_COUNT_0		MT_PSE(0x13c)
+#define MT_FC_RSV_COUNT_0_P0		GENMASK(11, 0)
+#define MT_FC_RSV_COUNT_0_P1		GENMASK(27, 16)
+
+#define MT_FC_SP2_Q0Q1			MT_PSE(0x14c)
+#define MT_FC_SP2_Q0Q1_SRC_COUNT_Q0	GENMASK(11, 0)
+#define MT_FC_SP2_Q0Q1_SRC_COUNT_Q1	GENMASK(27, 16)
+
+#define MT_PSE_FW_SHARED		MT_PSE(0x17c)
+
+#define MT_PSE_RTA			MT_PSE(0x194)
+#define MT_PSE_RTA_QUEUE_ID		GENMASK(4, 0)
+#define MT_PSE_RTA_PORT_ID		GENMASK(6, 5)
+#define MT_PSE_RTA_REDIRECT_EN		BIT(7)
+#define MT_PSE_RTA_TAG_ID		GENMASK(15, 8)
+#define MT_PSE_RTA_WRITE		BIT(16)
+#define MT_PSE_RTA_BUSY			BIT(31)
+
+#define MT_WF_PHY_BASE			0x10000
+#define MT_WF_PHY_OFFSET		0x1000
+#define MT_WF_PHY(ofs)			(MT_WF_PHY_BASE + (ofs))
+
+#define MT_AGC_BASE			MT_WF_PHY(0x500)
+#define MT_AGC(n)			(MT_AGC_BASE + ((n) * 4))
+
+#define MT_AGC1_BASE			MT_WF_PHY(0x1500)
+#define MT_AGC1(n)			(MT_AGC1_BASE + ((n) * 4))
+
+#define MT_AGC_41_RSSI_0		GENMASK(23, 16)
+#define MT_AGC_41_RSSI_1		GENMASK(7, 0)
+
+#define MT_RXTD_BASE			MT_WF_PHY(0x600)
+#define MT_RXTD(n)			(MT_RXTD_BASE + ((n) * 4))
+
+#define MT_RXTD_6_ACI_TH		GENMASK(4, 0)
+#define MT_RXTD_6_CCAED_TH		GENMASK(14, 8)
+
+#define MT_RXTD_8_LOWER_SIGNAL		GENMASK(5, 0)
+
+#define MT_RXTD_13_ACI_TH_EN		BIT(0)
+
+#define MT_WF_PHY_CR_TSSI_BASE		MT_WF_PHY(0xd00)
+#define MT_WF_PHY_CR_TSSI(phy, n)	(MT_WF_PHY_CR_TSSI_BASE +	\
+					 ((phy) * MT_WF_PHY_OFFSET) +	\
+					 ((n) * 4))
+
+#define MT_PHYCTRL_BASE			MT_WF_PHY(0x4100)
+#define MT_PHYCTRL(n)			(MT_PHYCTRL_BASE + ((n) * 4))
+
+#define MT_PHYCTRL_2_STATUS_RESET	BIT(6)
+#define MT_PHYCTRL_2_STATUS_EN		BIT(7)
+
+#define MT_PHYCTRL_STAT_PD		MT_PHYCTRL(3)
+#define MT_PHYCTRL_STAT_PD_OFDM		GENMASK(31, 16)
+#define MT_PHYCTRL_STAT_PD_CCK		GENMASK(15, 0)
+
+#define MT_PHYCTRL_STAT_MDRDY		MT_PHYCTRL(8)
+#define MT_PHYCTRL_STAT_MDRDY_OFDM	GENMASK(31, 16)
+#define MT_PHYCTRL_STAT_MDRDY_CCK	GENMASK(15, 0)
+
+#define MT_WF_AGG_BASE			0x21200
+#define MT_WF_AGG(ofs)			(MT_WF_AGG_BASE + (ofs))
+
+#define MT_AGG_ARCR			MT_WF_AGG(0x010)
+#define MT_AGG_ARCR_INIT_RATE1		BIT(0)
+#define MT_AGG_ARCR_FB_SGI_DISABLE	BIT(1)
+#define MT_AGG_ARCR_RATE8_DOWN_WRAP	BIT(2)
+#define MT_AGG_ARCR_RTS_RATE_THR	GENMASK(12, 8)
+#define MT_AGG_ARCR_RATE_DOWN_RATIO	GENMASK(17, 16)
+#define MT_AGG_ARCR_RATE_DOWN_RATIO_EN	BIT(19)
+#define MT_AGG_ARCR_RATE_UP_EXTRA_TH	GENMASK(22, 20)
+#define MT_AGG_ARCR_SPE_DIS_TH		GENMASK(27, 24)
+
+#define MT_AGG_ARUCR			MT_WF_AGG(0x014)
+#define MT_AGG_ARDCR			MT_WF_AGG(0x018)
+#define MT_AGG_ARxCR_LIMIT_SHIFT(_n)	(4 * (_n))
+#define MT_AGG_ARxCR_LIMIT(_n)		GENMASK(2 + \
+						MT_AGG_ARxCR_LIMIT_SHIFT(_n), \
+						MT_AGG_ARxCR_LIMIT_SHIFT(_n))
+
+#define MT_AGG_LIMIT			MT_WF_AGG(0x040)
+#define MT_AGG_LIMIT_1			MT_WF_AGG(0x044)
+#define MT_AGG_LIMIT_AC(_n)		GENMASK(((_n) + 1) * 8 - 1, (_n) * 8)
+
+#define MT_AGG_BA_SIZE_LIMIT_0		MT_WF_AGG(0x048)
+#define MT_AGG_BA_SIZE_LIMIT_1		MT_WF_AGG(0x04c)
+#define MT_AGG_BA_SIZE_LIMIT_SHIFT	8
+
+#define MT_AGG_PCR			MT_WF_AGG(0x050)
+#define MT_AGG_PCR_MM			BIT(16)
+#define MT_AGG_PCR_GF			BIT(17)
+#define MT_AGG_PCR_BW40			BIT(18)
+#define MT_AGG_PCR_RIFS			BIT(19)
+#define MT_AGG_PCR_BW80			BIT(20)
+#define MT_AGG_PCR_BW160		BIT(21)
+#define MT_AGG_PCR_ERP			BIT(22)
+
+#define MT_AGG_PCR_RTS			MT_WF_AGG(0x054)
+#define MT_AGG_PCR_RTS_THR		GENMASK(19, 0)
+#define MT_AGG_PCR_RTS_PKT_THR		GENMASK(31, 25)
+
+#define MT_AGG_CONTROL			MT_WF_AGG(0x070)
+#define MT_AGG_CONTROL_NO_BA_RULE	BIT(0)
+#define MT_AGG_CONTROL_NO_BA_AR_RULE	BIT(1)
+#define MT_AGG_CONTROL_CFEND_SPE_EN	BIT(3)
+#define MT_AGG_CONTROL_CFEND_RATE	GENMASK(15, 4)
+#define MT_AGG_CONTROL_BAR_SPE_EN	BIT(19)
+#define MT_AGG_CONTROL_BAR_RATE		GENMASK(31, 20)
+
+#define MT_AGG_TMP			MT_WF_AGG(0x0d8)
+
+#define MT_AGG_BWCR			MT_WF_AGG(0x0ec)
+#define MT_AGG_BWCR_BW			GENMASK(3, 2)
+
+#define MT_AGG_RETRY_CONTROL		MT_WF_AGG(0x0f4)
+#define MT_AGG_RETRY_CONTROL_RTS_LIMIT	GENMASK(11, 7)
+#define MT_AGG_RETRY_CONTROL_BAR_LIMIT	GENMASK(15, 12)
+
+#define MT_WF_DMA_BASE			0x21c00
+#define MT_WF_DMA(ofs)			(MT_WF_DMA_BASE + (ofs))
+
+#define MT_DMA_DCR0			MT_WF_DMA(0x000)
+#define MT_DMA_DCR1			MT_WF_DMA(0x004)
+
+#define MT_DMA_FQCR0			MT_WF_DMA(0x008)
+#define MT_DMA_FQCR0_TARGET_WCID	GENMASK(7, 0)
+#define MT_DMA_FQCR0_TARGET_BSS		GENMASK(13, 8)
+#define MT_DMA_FQCR0_TARGET_QID		GENMASK(20, 16)
+#define MT_DMA_FQCR0_DEST_PORT_ID	GENMASK(23, 22)
+#define MT_DMA_FQCR0_DEST_QUEUE_ID	GENMASK(28, 24)
+#define MT_DMA_FQCR0_MODE		BIT(29)
+#define MT_DMA_FQCR0_STATUS		BIT(30)
+#define MT_DMA_FQCR0_BUSY		BIT(31)
+
+#define MT_DMA_RCFR0			MT_WF_DMA(0x070)
+#define MT_DMA_VCFR0			MT_WF_DMA(0x07c)
+
+#define MT_DMA_TCFR0			MT_WF_DMA(0x080)
+#define MT_DMA_TCFR1			MT_WF_DMA(0x084)
+#define MT_DMA_TCFR_TXS_AGGR_TIMEOUT	GENMASK(27, 16)
+#define MT_DMA_TCFR_TXS_QUEUE		BIT(14)
+#define MT_DMA_TCFR_TXS_AGGR_COUNT	GENMASK(12, 8)
+#define MT_DMA_TCFR_TXS_BIT_MAP		GENMASK(6, 0)
+
+#define MT_DMA_TMCFR0			MT_WF_DMA(0x088)
+
+#define MT_WF_ARB_BASE			0x21400
+#define MT_WF_ARB(ofs)			(MT_WF_ARB_BASE + (ofs))
+
+#define MT_WMM_AIFSN			MT_WF_ARB(0x020)
+#define MT_WMM_AIFSN_MASK		GENMASK(3, 0)
+#define MT_WMM_AIFSN_SHIFT(_n)		((_n) * 4)
+
+#define MT_WMM_CWMAX_BASE		MT_WF_ARB(0x028)
+#define MT_WMM_CWMAX(_n)		(MT_WMM_CWMAX_BASE + (((_n) / 2) << 2))
+#define MT_WMM_CWMAX_SHIFT(_n)		(((_n) & 1) * 16)
+#define MT_WMM_CWMAX_MASK		GENMASK(15, 0)
+
+#define MT_WMM_CWMIN			MT_WF_ARB(0x040)
+#define MT_WMM_CWMIN_MASK		GENMASK(7, 0)
+#define MT_WMM_CWMIN_SHIFT(_n)		((_n) * 8)
+
+#define MT_WF_ARB_RQCR			MT_WF_ARB(0x070)
+#define MT_WF_ARB_RQCR_RX_START		BIT(0)
+#define MT_WF_ARB_RQCR_RXV_START	BIT(4)
+#define MT_WF_ARB_RQCR_RXV_R_EN		BIT(7)
+#define MT_WF_ARB_RQCR_RXV_T_EN		BIT(8)
+
+#define MT_ARB_SCR			MT_WF_ARB(0x080)
+#define MT_ARB_SCR_BCNQ_OPMODE_MASK	GENMASK(1, 0)
+#define MT_ARB_SCR_BCNQ_OPMODE_SHIFT(n)	((n) * 2)
+#define MT_ARB_SCR_TX_DISABLE		BIT(8)
+#define MT_ARB_SCR_RX_DISABLE		BIT(9)
+#define MT_ARB_SCR_BCNQ_EMPTY_SKIP	BIT(28)
+#define MT_ARB_SCR_TTTT_BTIM_PRIO	BIT(29)
+#define MT_ARB_SCR_TBTT_BCN_PRIO	BIT(30)
+#define MT_ARB_SCR_TBTT_BCAST_PRIO	BIT(31)
+
+enum {
+	MT_BCNQ_OPMODE_STA =	0,
+	MT_BCNQ_OPMODE_AP =	1,
+	MT_BCNQ_OPMODE_ADHOC =	2,
+};
+
+#define MT_WF_ARB_TX_START_0		MT_WF_ARB(0x100)
+#define MT_WF_ARB_TX_START_1		MT_WF_ARB(0x104)
+#define MT_WF_ARB_TX_FLUSH_0		MT_WF_ARB(0x108)
+#define MT_WF_ARB_TX_FLUSH_1		MT_WF_ARB(0x10c)
+#define MT_WF_ARB_TX_STOP_0		MT_WF_ARB(0x110)
+#define MT_WF_ARB_TX_STOP_1		MT_WF_ARB(0x114)
+
+#define MT_WF_ARB_BCN_START		MT_WF_ARB(0x118)
+#define MT_WF_ARB_BCN_START_BSSn(n)	BIT(0 + (n))
+#define MT_WF_ARB_BCN_START_T_PRE_TTTT	BIT(10)
+#define MT_WF_ARB_BCN_START_T_TTTT	BIT(11)
+#define MT_WF_ARB_BCN_START_T_PRE_TBTT	BIT(12)
+#define MT_WF_ARB_BCN_START_T_TBTT	BIT(13)
+#define MT_WF_ARB_BCN_START_T_SLOT_IDLE	BIT(14)
+#define MT_WF_ARB_BCN_START_T_TX_START	BIT(15)
+#define MT_WF_ARB_BCN_START_BSS0n(n)	BIT((n) ? 16 + ((n) - 1) : 0)
+
+#define MT_WF_ARB_BCN_FLUSH		MT_WF_ARB(0x11c)
+#define MT_WF_ARB_BCN_FLUSH_BSSn(n)	BIT(0 + (n))
+#define MT_WF_ARB_BCN_FLUSH_BSS0n(n)	BIT((n) ? 16 + ((n) - 1) : 0)
+
+#define MT_WF_ARB_CAB_START		MT_WF_ARB(0x120)
+#define MT_WF_ARB_CAB_START_BSSn(n)	BIT(0 + (n))
+#define MT_WF_ARB_CAB_START_BSS0n(n)	BIT((n) ? 16 + ((n) - 1) : 0)
+
+#define MT_WF_ARB_CAB_FLUSH		MT_WF_ARB(0x124)
+#define MT_WF_ARB_CAB_FLUSH_BSSn(n)	BIT(0 + (n))
+#define MT_WF_ARB_CAB_FLUSH_BSS0n(n)	BIT((n) ? 16 + ((n) - 1) : 0)
+
+#define MT_WF_ARB_CAB_COUNT(n)		MT_WF_ARB(0x128 + (n) * 4)
+#define MT_WF_ARB_CAB_COUNT_SHIFT	4
+#define MT_WF_ARB_CAB_COUNT_MASK	GENMASK(3, 0)
+#define MT_WF_ARB_CAB_COUNT_B0_REG(n)	MT_WF_ARB_CAB_COUNT(((n) > 12 ? 2 : \
+							     ((n) > 4 ? 1 : 0)))
+#define MT_WF_ARB_CAB_COUNT_B0_SHIFT(n)	(((n) > 12 ? (n) - 12 : \
+					 ((n) > 4 ? (n) - 4 : \
+					  (n) ? (n) + 3 : 0)) * 4)
+
+#define MT_TX_ABORT			MT_WF_ARB(0x134)
+#define MT_TX_ABORT_EN			BIT(0)
+#define MT_TX_ABORT_WCID		GENMASK(15, 8)
+
+#define MT_WF_TMAC_BASE			0x21600
+#define MT_WF_TMAC(ofs)			(MT_WF_TMAC_BASE + (ofs))
+
+#define MT_TMAC_TCR			MT_WF_TMAC(0x000)
+#define MT_TMAC_TCR_BLINK_SEL		GENMASK(7, 6)
+#define MT_TMAC_TCR_PRE_RTS_GUARD	GENMASK(11, 8)
+#define MT_TMAC_TCR_PRE_RTS_SEC_IDLE	GENMASK(13, 12)
+#define MT_TMAC_TCR_RTS_SIGTA		BIT(14)
+#define MT_TMAC_TCR_LDPC_OFS		BIT(15)
+#define MT_TMAC_TCR_TX_STREAMS		GENMASK(17, 16)
+#define MT_TMAC_TCR_SCH_IDLE_SEL	GENMASK(19, 18)
+#define MT_TMAC_TCR_SCH_DET_PER_IOD	BIT(20)
+#define MT_TMAC_TCR_DCH_DET_DISABLE	BIT(21)
+#define MT_TMAC_TCR_TX_RIFS		BIT(22)
+#define MT_TMAC_TCR_RX_RIFS_MODE	BIT(23)
+#define MT_TMAC_TCR_TXOP_TBTT_CTL	BIT(24)
+#define MT_TMAC_TCR_TBTT_TX_STOP_CTL	BIT(25)
+#define MT_TMAC_TCR_TXOP_BURST_STOP	BIT(26)
+#define MT_TMAC_TCR_RDG_RA_MODE		BIT(27)
+#define MT_TMAC_TCR_RDG_RESP		BIT(29)
+#define MT_TMAC_TCR_RDG_NO_PENDING	BIT(30)
+#define MT_TMAC_TCR_SMOOTHING		BIT(31)
+
+#define MT_WMM_TXOP_BASE		MT_WF_TMAC(0x010)
+#define MT_WMM_TXOP(_n)			(MT_WMM_TXOP_BASE + \
+					 ((((_n) / 2) ^ 0x1) << 2))
+#define MT_WMM_TXOP_SHIFT(_n)		(((_n) & 1) * 16)
+#define MT_WMM_TXOP_MASK		GENMASK(15, 0)
+
+#define MT_TIMEOUT_CCK			MT_WF_TMAC(0x090)
+#define MT_TIMEOUT_OFDM			MT_WF_TMAC(0x094)
+#define MT_TIMEOUT_VAL_PLCP		GENMASK(15, 0)
+#define MT_TIMEOUT_VAL_CCA		GENMASK(31, 16)
+
+#define MT_TXREQ			MT_WF_TMAC(0x09c)
+#define MT_TXREQ_CCA_SRC_SEL		GENMASK(31, 30)
+
+#define MT_RXREQ			MT_WF_TMAC(0x0a0)
+#define MT_RXREQ_DELAY			GENMASK(8, 0)
+
+#define MT_IFS				MT_WF_TMAC(0x0a4)
+#define MT_IFS_EIFS			GENMASK(8, 0)
+#define MT_IFS_RIFS			GENMASK(14, 10)
+#define MT_IFS_SIFS			GENMASK(22, 16)
+#define MT_IFS_SLOT			GENMASK(30, 24)
+
+#define MT_TMAC_PCR			MT_WF_TMAC(0x0b4)
+#define MT_TMAC_PCR_RATE		GENMASK(8, 0)
+#define MT_TMAC_PCR_RATE_FIXED		BIT(15)
+#define MT_TMAC_PCR_ANT_ID		GENMASK(21, 16)
+#define MT_TMAC_PCR_ANT_ID_SEL		BIT(22)
+#define MT_TMAC_PCR_SPE_EN		BIT(23)
+#define MT_TMAC_PCR_ANT_PRI		GENMASK(26, 24)
+#define MT_TMAC_PCR_ANT_PRI_SEL		GENMASK(27)
+
+#define MT_WF_RMAC_BASE			0x21800
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
+#define MT_BSSID0(idx)			MT_WF_RMAC(0x004 + (idx) * 8)
+#define MT_BSSID1(idx)			MT_WF_RMAC(0x008 + (idx) * 8)
+#define MT_BSSID1_VALID			BIT(16)
+
+#define MT_MAC_ADDR0(idx)		MT_WF_RMAC(0x024 + (idx) * 8)
+#define MT_MAC_ADDR1(idx)		MT_WF_RMAC(0x028 + (idx) * 8)
+#define MT_MAC_ADDR1_ADDR		GENMASK(15, 0)
+#define MT_MAC_ADDR1_VALID		BIT(16)
+
+#define MT_BA_CONTROL_0			MT_WF_RMAC(0x068)
+#define MT_BA_CONTROL_1			MT_WF_RMAC(0x06c)
+#define MT_BA_CONTROL_1_ADDR		GENMASK(15, 0)
+#define MT_BA_CONTROL_1_TID		GENMASK(19, 16)
+#define MT_BA_CONTROL_1_IGNORE_TID	BIT(20)
+#define MT_BA_CONTROL_1_IGNORE_ALL	BIT(21)
+#define MT_BA_CONTROL_1_RESET		BIT(22)
+
+#define MT_WF_RMACDR			MT_WF_RMAC(0x078)
+#define MT_WF_RMACDR_TSF_PROBERSP_DIS	BIT(0)
+#define MT_WF_RMACDR_TSF_TIM		BIT(4)
+#define MT_WF_RMACDR_MBSSID_MASK	GENMASK(25, 24)
+#define MT_WF_RMACDR_CHECK_HTC_BY_RATE	BIT(26)
+#define MT_WF_RMACDR_MAXLEN_20BIT	BIT(30)
+
+#define MT_WF_RMAC_RMCR			MT_WF_RMAC(0x080)
+#define MT_WF_RMAC_RMCR_SMPS_MODE	GENMASK(21, 20)
+#define MT_WF_RMAC_RMCR_RX_STREAMS	GENMASK(24, 22)
+#define MT_WF_RMAC_RMCR_SMPS_RTS	BIT(25)
+
+#define MT_WF_RMAC_CH_FREQ		MT_WF_RMAC(0x090)
+#define MT_WF_RMAC_MAXMINLEN		MT_WF_RMAC(0x098)
+#define MT_WF_RFCR1			MT_WF_RMAC(0x0a4)
+#define MT_WF_RMAC_TMR_PA		MT_WF_RMAC(0x0e0)
+
+#define MT_WF_SEC_BASE			0x21a00
+#define MT_WF_SEC(ofs)			(MT_WF_SEC_BASE + (ofs))
+
+#define MT_SEC_SCR			MT_WF_SEC(0x004)
+#define MT_SEC_SCR_MASK_ORDER		GENMASK(1, 0)
+
+#define MT_WTBL_OFF_BASE		0x23000
+#define MT_WTBL_OFF(n)			(MT_WTBL_OFF_BASE + (n))
+
+#define MT_WTBL_UPDATE			MT_WTBL_OFF(0x000)
+#define MT_WTBL_UPDATE_WLAN_IDX		GENMASK(7, 0)
+#define MT_WTBL_UPDATE_WTBL2		BIT(11)
+#define MT_WTBL_UPDATE_ADM_COUNT_CLEAR	BIT(12)
+#define MT_WTBL_UPDATE_RATE_UPDATE	BIT(13)
+#define MT_WTBL_UPDATE_TX_COUNT_CLEAR	BIT(14)
+#define MT_WTBL_UPDATE_RX_COUNT_CLEAR	BIT(15)
+#define MT_WTBL_UPDATE_BUSY		BIT(16)
+
+#define MT_WTBL_RMVTCR			MT_WTBL_OFF(0x008)
+#define MT_WTBL_RMVTCR_RX_MV_MODE	BIT(23)
+
+#define MT_LPON_BASE			0x24000
+#define MT_LPON(n)			(MT_LPON_BASE + (n))
+
+#define MT_LPON_BTEIR			MT_LPON(0x020)
+#define MT_LPON_BTEIR_MBSS_MODE		GENMASK(31, 29)
+
+#define MT_PRE_TBTT			MT_LPON(0x030)
+#define MT_PRE_TBTT_MASK		GENMASK(7, 0)
+#define MT_PRE_TBTT_SHIFT		8
+
+#define MT_TBTT				MT_LPON(0x034)
+#define MT_TBTT_PERIOD			GENMASK(15, 0)
+#define MT_TBTT_DTIM_PERIOD		GENMASK(23, 16)
+#define MT_TBTT_TBTT_WAKE_PERIOD	GENMASK(27, 24)
+#define MT_TBTT_DTIM_WAKE_PERIOD	GENMASK(30, 28)
+#define MT_TBTT_CAL_ENABLE		BIT(31)
+
+#define MT_TBTT_TIMER_CFG		MT_LPON(0x05c)
+
+#define MT_LPON_SBTOR(n)		MT_LPON(0x0a0)
+#define MT_LPON_SBTOR_SUB_BSS_EN	BIT(29)
+#define MT_LPON_SBTOR_TIME_OFFSET	GENMASK(19, 0)
+
+#define MT_INT_WAKEUP_BASE		0x24400
+#define MT_INT_WAKEUP(n)		(MT_INT_WAKEUP_BASE + (n))
+
+#define MT_HW_INT_STATUS(n)		MT_INT_WAKEUP(0x3c + (n) * 8)
+#define MT_HW_INT_MASK(n)		MT_INT_WAKEUP(0x40 + (n) * 8)
+
+#define MT_HW_INT3_TBTT0		BIT(15)
+#define MT_HW_INT3_PRE_TBTT0		BIT(31)
+
+#define MT_WTBL1_BASE			0x28000
+
+#define MT_WTBL_ON_BASE			(MT_WTBL1_BASE + 0x2000)
+#define MT_WTBL_ON(_n)			(MT_WTBL_ON_BASE + (_n))
+
+#define MT_WTBL_RIUCR0			MT_WTBL_ON(0x200)
+
+#define MT_WTBL_RIUCR1			MT_WTBL_ON(0x204)
+#define MT_WTBL_RIUCR1_RATE0		GENMASK(11, 0)
+#define MT_WTBL_RIUCR1_RATE1		GENMASK(23, 12)
+#define MT_WTBL_RIUCR1_RATE2_LO		GENMASK(31, 24)
+
+#define MT_WTBL_RIUCR2			MT_WTBL_ON(0x208)
+#define MT_WTBL_RIUCR2_RATE2_HI		GENMASK(3, 0)
+#define MT_WTBL_RIUCR2_RATE3		GENMASK(15, 4)
+#define MT_WTBL_RIUCR2_RATE4		GENMASK(27, 16)
+#define MT_WTBL_RIUCR2_RATE5_LO		GENMASK(31, 28)
+
+#define MT_WTBL_RIUCR3			MT_WTBL_ON(0x20c)
+#define MT_WTBL_RIUCR3_RATE5_HI		GENMASK(7, 0)
+#define MT_WTBL_RIUCR3_RATE6		GENMASK(19, 8)
+#define MT_WTBL_RIUCR3_RATE7		GENMASK(31, 20)
+
+#define MT_MIB_BASE			0x2c000
+#define MT_MIB(_n)			(MT_MIB_BASE + (_n))
+
+#define MT_MIB_CTL			MT_MIB(0x00)
+#define MT_MIB_CTL_PSCCA_TIME		GENMASK(13, 11)
+#define MT_MIB_CTL_CCA_NAV_TX		GENMASK(16, 14)
+#define MT_MIB_CTL_ED_TIME		GENMASK(30, 28)
+#define MT_MIB_CTL_READ_CLR_DIS		BIT(31)
+
+#define MT_MIB_STAT(_n)			MT_MIB(0x08 + (_n) * 4)
+
+#define MT_MIB_STAT_CCA			MT_MIB_STAT(9)
+#define MT_MIB_STAT_CCA_MASK		GENMASK(23, 0)
+
+#define MT_MIB_STAT_PSCCA		MT_MIB_STAT(16)
+#define MT_MIB_STAT_PSCCA_MASK		GENMASK(23, 0)
+
+#define MT_MIB_STAT_ED			MT_MIB_STAT(18)
+#define MT_MIB_STAT_ED_MASK		GENMASK(23, 0)
+
+#define MT_PCIE_REMAP_BASE_1		0x40000
+#define MT_PCIE_REMAP_BASE_2		0x80000
+
+#define MT_TX_HW_QUEUE_MGMT		4
+#define MT_TX_HW_QUEUE_MCU		5
+#define MT_TX_HW_QUEUE_BCN		7
+#define MT_TX_HW_QUEUE_BMC		8
+
+#define MT_LED_BASE_PHYS		0x80024000
+#define MT_LED_PHYS(_n)			(MT_LED_BASE_PHYS + (_n))
+
+#define MT_LED_CTRL			MT_LED_PHYS(0x00)
+
+#define MT_LED_CTRL_REPLAY(_n)		BIT(0 + (8 * (_n)))
+#define MT_LED_CTRL_POLARITY(_n)	BIT(1 + (8 * (_n)))
+#define MT_LED_CTRL_TX_BLINK_MODE(_n)	BIT(2 + (8 * (_n)))
+#define MT_LED_CTRL_TX_MANUAL_BLINK(_n)	BIT(3 + (8 * (_n)))
+#define MT_LED_CTRL_TX_OVER_BLINK(_n)	BIT(5 + (8 * (_n)))
+#define MT_LED_CTRL_KICK(_n)		BIT(7 + (8 * (_n)))
+
+#define MT_LED_STATUS_0(_n)		MT_LED_PHYS(0x10 + ((_n) * 8))
+#define MT_LED_STATUS_1(_n)		MT_LED_PHYS(0x14 + ((_n) * 8))
+#define MT_LED_STATUS_OFF_MASK		GENMASK(31, 24)
+#define MT_LED_STATUS_OFF(_v)		(((_v) << \
+					  __ffs(MT_LED_STATUS_OFF_MASK)) & \
+					 MT_LED_STATUS_OFF_MASK)
+#define MT_LED_STATUS_ON_MASK		GENMASK(23, 16)
+#define MT_LED_STATUS_ON(_v)		(((_v) << \
+					  __ffs(MT_LED_STATUS_ON_MASK)) & \
+					 MT_LED_STATUS_ON_MASK)
+#define MT_LED_STATUS_DURATION_MASK	GENMASK(15, 0)
+#define MT_LED_STATUS_DURATION(_v)	(((_v) << \
+					  __ffs(MT_LED_STATUS_DURATION_MASK)) &\
+					 MT_LED_STATUS_DURATION_MASK)
+
+#define MT_CLIENT_BASE_PHYS_ADDR	0x800c0000
+
+#define MT_CLIENT_TMAC_INFO_TEMPLATE	0x040
+
+#define MT_CLIENT_STATUS		0x06c
+
+#define MT_CLIENT_RESET_TX		0x070
+#define MT_CLIENT_RESET_TX_R_E_1	BIT(16)
+#define MT_CLIENT_RESET_TX_R_E_2	BIT(17)
+#define MT_CLIENT_RESET_TX_R_E_1_S	BIT(20)
+#define MT_CLIENT_RESET_TX_R_E_2_S	BIT(21)
+
+#define MT_EFUSE_BASE			0x81070000
+
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
+#define MT_CLIENT_RXINF			0x068
+#define MT_CLIENT_RXINF_RXSH_GROUPS	GENMASK(2, 0)
+
+#define MT_PSE_BASE_PHYS_ADDR		0xa0000000
+
+#define MT_PSE_WTBL_2_PHYS_ADDR		0xa5000000
+
+#define MT_WTBL1_SIZE			(8 * 4)
+#define MT_WTBL2_SIZE			(16 * 4)
+#define MT_WTBL3_OFFSET			(MT7603_WTBL_SIZE * MT_WTBL2_SIZE)
+#define MT_WTBL3_SIZE			(16 * 4)
+#define MT_WTBL4_OFFSET			(MT7603_WTBL_SIZE * MT_WTBL3_SIZE + \
+					 MT_WTBL3_OFFSET)
+#define MT_WTBL4_SIZE			(8 * 4)
+
+#define MT_WTBL1_W0_ADDR_HI		GENMASK(15, 0)
+#define MT_WTBL1_W0_MUAR_IDX		GENMASK(21, 16)
+#define MT_WTBL1_W0_RX_CHECK_A1		BIT(22)
+#define MT_WTBL1_W0_KEY_IDX		GENMASK(24, 23)
+#define MT_WTBL1_W0_RX_CHECK_KEY_IDX	BIT(25)
+#define MT_WTBL1_W0_RX_KEY_VALID	BIT(26)
+#define MT_WTBL1_W0_RX_IK_VALID		BIT(27)
+#define MT_WTBL1_W0_RX_VALID		BIT(28)
+#define MT_WTBL1_W0_RX_CHECK_A2		BIT(29)
+#define MT_WTBL1_W0_RX_DATA_VALID	BIT(30)
+#define MT_WTBL1_W0_WRITE_BURST		BIT(31)
+
+#define MT_WTBL1_W1_ADDR_LO		GENMASK(31, 0)
+
+#define MT_WTBL1_W2_MPDU_DENSITY	GENMASK(2, 0)
+#define MT_WTBL1_W2_KEY_TYPE		GENMASK(6, 3)
+#define MT_WTBL1_W2_EVEN_PN		BIT(7)
+#define MT_WTBL1_W2_TO_DS		BIT(8)
+#define MT_WTBL1_W2_FROM_DS		BIT(9)
+#define MT_WTBL1_W2_HEADER_TRANS	BIT(10)
+#define MT_WTBL1_W2_AMPDU_FACTOR	GENMASK(13, 11)
+#define MT_WTBL1_W2_PWR_MGMT		BIT(14)
+#define MT_WTBL1_W2_RDG			BIT(15)
+#define MT_WTBL1_W2_RTS			BIT(16)
+#define MT_WTBL1_W2_CFACK		BIT(17)
+#define MT_WTBL1_W2_RDG_BA		BIT(18)
+#define MT_WTBL1_W2_SMPS		BIT(19)
+#define MT_WTBL1_W2_TXS_BAF_REPORT	BIT(20)
+#define MT_WTBL1_W2_DYN_BW		BIT(21)
+#define MT_WTBL1_W2_LDPC		BIT(22)
+#define MT_WTBL1_W2_ITXBF		BIT(23)
+#define MT_WTBL1_W2_ETXBF		BIT(24)
+#define MT_WTBL1_W2_TXOP_PS		BIT(25)
+#define MT_WTBL1_W2_MESH		BIT(26)
+#define MT_WTBL1_W2_QOS			BIT(27)
+#define MT_WTBL1_W2_HT			BIT(28)
+#define MT_WTBL1_W2_VHT			BIT(29)
+#define MT_WTBL1_W2_ADMISSION_CONTROL	BIT(30)
+#define MT_WTBL1_W2_GROUP_ID		BIT(31)
+
+#define MT_WTBL1_W3_WTBL2_FRAME_ID	GENMASK(10, 0)
+#define MT_WTBL1_W3_WTBL2_ENTRY_ID	GENMASK(15, 11)
+#define MT_WTBL1_W3_WTBL4_FRAME_ID	GENMASK(26, 16)
+#define MT_WTBL1_W3_CHECK_PER		BIT(27)
+#define MT_WTBL1_W3_KEEP_I_PSM		BIT(28)
+#define MT_WTBL1_W3_I_PSM		BIT(29)
+#define MT_WTBL1_W3_POWER_SAVE		BIT(30)
+#define MT_WTBL1_W3_SKIP_TX		BIT(31)
+
+#define MT_WTBL1_W4_WTBL3_FRAME_ID	GENMASK(10, 0)
+#define MT_WTBL1_W4_WTBL3_ENTRY_ID	GENMASK(16, 11)
+#define MT_WTBL1_W4_WTBL4_ENTRY_ID	GENMASK(22, 17)
+#define MT_WTBL1_W4_PARTIAL_AID		GENMASK(31, 23)
+
+#define MT_WTBL2_W0_PN_LO		GENMASK(31, 0)
+
+#define MT_WTBL2_W1_PN_HI		GENMASK(15, 0)
+#define MT_WTBL2_W1_NON_QOS_SEQNO	GENMASK(27, 16)
+
+#define MT_WTBL2_W2_TID0_SN		GENMASK(11, 0)
+#define MT_WTBL2_W2_TID1_SN		GENMASK(23, 12)
+#define MT_WTBL2_W2_TID2_SN_LO		GENMASK(31, 24)
+
+#define MT_WTBL2_W3_TID2_SN_HI		GENMASK(3, 0)
+#define MT_WTBL2_W3_TID3_SN		GENMASK(15, 4)
+#define MT_WTBL2_W3_TID4_SN		GENMASK(27, 16)
+#define MT_WTBL2_W3_TID5_SN_LO		GENMASK(31, 28)
+
+#define MT_WTBL2_W4_TID5_SN_HI		GENMASK(7, 0)
+#define MT_WTBL2_W4_TID6_SN		GENMASK(19, 8)
+#define MT_WTBL2_W4_TID7_SN		GENMASK(31, 20)
+
+#define MT_WTBL2_W5_TX_COUNT_RATE1	GENMASK(15, 0)
+#define MT_WTBL2_W5_FAIL_COUNT_RATE1	GENAMSK(31, 16)
+
+#define MT_WTBL2_W6_TX_COUNT_RATE2	GENMASK(7, 0)
+#define MT_WTBL2_W6_TX_COUNT_RATE3	GENMASK(15, 8)
+#define MT_WTBL2_W6_TX_COUNT_RATE4	GENMASK(23, 16)
+#define MT_WTBL2_W6_TX_COUNT_RATE5	GENMASK(31, 24)
+
+#define MT_WTBL2_W7_TX_COUNT_CUR_BW	GENMASK(15, 0)
+#define MT_WTBL2_W7_FAIL_COUNT_CUR_BW	GENMASK(31, 16)
+
+#define MT_WTBL2_W8_TX_COUNT_OTHER_BW	GENMASK(15, 0)
+#define MT_WTBL2_W8_FAIL_COUNT_OTHER_BW	GENMASK(31, 16)
+
+#define MT_WTBL2_W9_POWER_OFFSET	GENMASK(4, 0)
+#define MT_WTBL2_W9_SPATIAL_EXT		BIT(5)
+#define MT_WTBL2_W9_ANT_PRIORITY	GENMASK(8, 6)
+#define MT_WTBL2_W9_CC_BW_SEL		GENMASK(10, 9)
+#define MT_WTBL2_W9_CHANGE_BW_RATE	GENMASK(13, 11)
+#define MT_WTBL2_W9_BW_CAP		GENMASK(15, 14)
+#define MT_WTBL2_W9_SHORT_GI_20		BIT(16)
+#define MT_WTBL2_W9_SHORT_GI_40		BIT(17)
+#define MT_WTBL2_W9_SHORT_GI_80		BIT(18)
+#define MT_WTBL2_W9_SHORT_GI_160	BIT(19)
+#define MT_WTBL2_W9_MPDU_FAIL_COUNT	GENMASK(25, 23)
+#define MT_WTBL2_W9_MPDU_OK_COUNT	GENMASK(28, 26)
+#define MT_WTBL2_W9_RATE_IDX		GENMASK(31, 29)
+
+#define MT_WTBL2_W10_RATE1		GENMASK(11, 0)
+#define MT_WTBL2_W10_RATE2		GENMASK(23, 12)
+#define MT_WTBL2_W10_RATE3_LO		GENMASK(31, 24)
+
+#define MT_WTBL2_W11_RATE3_HI		GENMASK(3, 0)
+#define MT_WTBL2_W11_RATE4		GENMASK(15, 4)
+#define MT_WTBL2_W11_RATE5		GENMASK(27, 16)
+#define MT_WTBL2_W11_RATE6_LO		GENMASK(31, 28)
+
+#define MT_WTBL2_W12_RATE6_HI		GENMASK(7, 0)
+#define MT_WTBL2_W12_RATE7		GENMASK(19, 8)
+#define MT_WTBL2_W12_RATE8		GENMASK(31, 20)
+
+#define MT_WTBL2_W13_AVG_RCPI0		GENMASK(7, 0)
+#define MT_WTBL2_W13_AVG_RCPI1		GENMASK(15, 8)
+#define MT_WTBL2_W13_AVG_RCPI2		GENAMSK(23, 16)
+
+#define MT_WTBL2_W14_CC_NOISE_1S	GENMASK(6, 0)
+#define MT_WTBL2_W14_CC_NOISE_2S	GENMASK(13, 7)
+#define MT_WTBL2_W14_CC_NOISE_3S	GENMASK(20, 14)
+#define MT_WTBL2_W14_CHAN_EST_RMS	GENMASK(24, 21)
+#define MT_WTBL2_W14_CC_NOISE_SEL	BIT(15)
+#define MT_WTBL2_W14_ANT_SEL		GENMASK(31, 26)
+
+#define MT_WTBL2_W15_BA_WIN_SIZE	GENMASK(2, 0)
+#define MT_WTBL2_W15_BA_WIN_SIZE_SHIFT	3
+#define MT_WTBL2_W15_BA_EN_TIDS		GENMASK(31, 24)
+
+#define MT_WTBL1_OR			(MT_WTBL1_BASE + 0x2300)
+#define MT_WTBL1_OR_PSM_WRITE		BIT(31)
+
+enum mt7603_cipher_type {
+	MT_CIPHER_NONE,
+	MT_CIPHER_WEP40,
+	MT_CIPHER_TKIP,
+	MT_CIPHER_TKIP_NO_MIC,
+	MT_CIPHER_AES_CCMP,
+	MT_CIPHER_WEP104,
+	MT_CIPHER_BIP_CMAC_128,
+	MT_CIPHER_WEP128,
+	MT_CIPHER_WAPI,
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/soc.c b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
new file mode 100644
index 000000000000..5d19b4e7edc6
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/soc.c
@@ -0,0 +1,97 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
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
+#include <linux/platform_device.h>
+
+#include "mt7603.h"
+
+static int
+mt76_wmac_probe(struct platform_device *pdev)
+{
+	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct mt7603_dev *dev;
+	void __iomem *mem_base;
+	int irq;
+	int ret;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "Failed to get device IRQ\n");
+		return irq;
+	}
+
+	mem_base = devm_ioremap_resource(&pdev->dev, res);
+	if (!mem_base) {
+		dev_err(&pdev->dev, "Failed to get memory resource\n");
+		return -EINVAL;
+	}
+
+	dev = mt7603_alloc_device(&pdev->dev);
+	if (!dev)
+		return -ENOMEM;
+
+	mt76_mmio_init(&dev->mt76, mem_base);
+
+	dev->mt76.rev = (mt76_rr(dev, MT_HW_CHIPID) << 16) |
+			(mt76_rr(dev, MT_HW_REV) & 0xff);
+	dev_info(dev->mt76.dev, "ASIC revision: %04x\n", dev->mt76.rev);
+
+	ret = devm_request_irq(dev->mt76.dev, irq, mt7603_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (ret)
+		goto error;
+
+	ret = mt7603_register_device(dev);
+	if (ret)
+		goto error;
+
+	return 0;
+error:
+	ieee80211_free_hw(mt76_hw(dev));
+	return ret;
+}
+
+static int
+mt76_wmac_remove(struct platform_device *pdev)
+{
+	struct mt76_dev *mdev = platform_get_drvdata(pdev);
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
+
+	mt7603_unregister_device(dev);
+
+	return 0;
+}
+
+static const struct of_device_id of_wmac_match[] = {
+	{ .compatible = "mediatek,mt7628-wmac" },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, of_wmac_match);
+MODULE_FIRMWARE(MT7628_FIRMWARE_E1);
+MODULE_FIRMWARE(MT7628_FIRMWARE_E2);
+
+struct platform_driver mt76_wmac_driver = {
+	.probe		= mt76_wmac_probe,
+	.remove		= mt76_wmac_remove,
+	.driver = {
+		.name = "mt76_wmac",
+		.of_match_table = of_wmac_match,
+	},
+};
-- 
2.17.0

