Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C492C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279BD20684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 279BD20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbeJCOgY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:24 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54225 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbeJCOgX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:23 -0400
Received: by mail-wm1-f65.google.com with SMTP id b19-v6so4677541wme.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:49:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YFrFJnODE9rS1WJM+FAytWlICuFIN6VS3o+tZ8SSpRE=;
        b=R0dKKCaYw9M8nrwfYqeyJCIBchmPSs0505uRyBXmEVcdU3TS5fuXOXgZy2s5Vtk2dD
         vaS06tLa1VG8wxLaNKQgA5tEZWESczDdGNBvLeta0rQIksDI0a4BxFERnCznCBP7mXte
         e7P+JOri9bUTfXBFHlo1sKACZiHCrVahKhl4kseRFXpNMBAi9QtXomUTpyhQpwXTNrXj
         +7VocmlFctA0ZBlk8Q1Gri72/9R0+Q9oRVATBnhshS0ip86EusIEBj6y37GHG8T7WnXC
         TXGLV3aRZkjDa4zxgeFtrWgwiwkB8e5/+Lx6dXruEXmyM//2gQp26MerDF95zfpzXsF7
         36jA==
X-Gm-Message-State: ABuFfojq50qqzY9kWdcEtN//lNSqncN5WPmjVd61ebL8Qnk5K//waW9I
        7Oa5uoJgdgb3gqAaqbythyxWFQ==
X-Google-Smtp-Source: ACcGV63X99LcPmYMGpdKcTaZCST9eyO9kjdEGoiplRtPaKLO+EB6+RQx2IoVELUUbfMOhnoMWkxVkQ==
X-Received: by 2002:a1c:3288:: with SMTP id y130-v6mr533977wmy.11.1538552946882;
        Wed, 03 Oct 2018 00:49:06 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.49.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:49:06 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 8/9] mt76: move irq handler in mt76x02-lib moudle
Date:   Wed,  3 Oct 2018 09:48:50 +0200
Message-Id: <417a57b5c3aa9de2f75fa91c869b045d22b6149d.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
References: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_irq_handler handler in mt76x02_mmio.c in order to be
reused in mt76x0 driver. Move mt76x02_rx_poll_complete routine in
mt76x02-lib module. Moreover remove pci_core.c and mt76x2/trace.{c,h}
since are empty files

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 62 +++++++++++++++
 .../wireless/mediatek/mt76/mt76x02_trace.h    | 23 ++++++
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  3 +-
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  3 -
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  3 +-
 .../wireless/mediatek/mt76/mt76x2/pci_core.c  | 78 -------------------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  1 -
 .../wireless/mediatek/mt76/mt76x2/pci_trace.c | 23 ------
 .../net/wireless/mediatek/mt76/mt76x2/trace.h | 67 ----------------
 11 files changed, 90 insertions(+), 177 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/trace.h

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index d4dd4547bb06..65174817ebc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -146,6 +146,8 @@ void mt76x02_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 bool mt76x02_tx_status_data(struct mt76_dev *dev, u8 *update);
 void mt76x02_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			  struct sk_buff *skb);
+void mt76x02_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
+irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance);
 void mt76x02_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 		struct sk_buff *skb);
 int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index bb609b775de9..1b945079c802 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -16,8 +16,10 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/irq.h>
 
 #include "mt76x02.h"
+#include "mt76x02_trace.h"
 
 static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
@@ -136,6 +138,66 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_init);
 
+void mt76x02_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
+{
+	struct mt76x02_dev *dev;
+
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+	mt76x02_irq_enable(dev, MT_INT_RX_DONE(q));
+}
+EXPORT_SYMBOL_GPL(mt76x02_rx_poll_complete);
+
+irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
+{
+	struct mt76x02_dev *dev = dev_instance;
+	u32 intr;
+
+	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
+	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
+
+	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
+		return IRQ_NONE;
+
+	trace_dev_irq(dev, intr, dev->mt76.mmio.irqmask);
+
+	intr &= dev->mt76.mmio.irqmask;
+
+	if (intr & MT_INT_TX_DONE_ALL) {
+		mt76x02_irq_disable(dev, MT_INT_TX_DONE_ALL);
+		tasklet_schedule(&dev->tx_tasklet);
+	}
+
+	if (intr & MT_INT_RX_DONE(0)) {
+		mt76x02_irq_disable(dev, MT_INT_RX_DONE(0));
+		napi_schedule(&dev->mt76.napi[0]);
+	}
+
+	if (intr & MT_INT_RX_DONE(1)) {
+		mt76x02_irq_disable(dev, MT_INT_RX_DONE(1));
+		napi_schedule(&dev->mt76.napi[1]);
+	}
+
+	if (intr & MT_INT_PRE_TBTT)
+		tasklet_schedule(&dev->pre_tbtt_tasklet);
+
+	/* send buffered multicast frames now */
+	if (intr & MT_INT_TBTT)
+		mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
+
+	if (intr & MT_INT_TX_STAT) {
+		mt76x02_mac_poll_tx_status(dev, true);
+		tasklet_schedule(&dev->tx_tasklet);
+	}
+
+	if (intr & MT_INT_GPTIMER) {
+		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
+		tasklet_schedule(&dev->dfs_pd.dfs_tasklet);
+	}
+
+	return IRQ_HANDLED;
+}
+EXPORT_SYMBOL_GPL(mt76x02_irq_handler);
+
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set)
 {
 	unsigned long flags;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
index a18f26d857e4..713f12d3c8de 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_trace.h
@@ -110,6 +110,29 @@ TRACE_EVENT(mac_txstat_fetch,
 	)
 );
 
+TRACE_EVENT(dev_irq,
+	TP_PROTO(struct mt76x02_dev *dev, u32 val, u32 mask),
+
+	TP_ARGS(dev, val, mask),
+
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		__field(u32, val)
+		__field(u32, mask)
+	),
+
+	TP_fast_assign(
+		DEV_ASSIGN;
+		__entry->val = val;
+		__entry->mask = mask;
+	),
+
+	TP_printk(
+		DEV_PR_FMT " %08x & %08x",
+		DEV_PR_ARG, __entry->val, __entry->mask
+	)
+);
+
 #endif
 
 #undef TRACE_INCLUDE_PATH
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index 66f8b8ee6bc4..b71bb1049170 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -7,8 +7,7 @@ mt76x2-common-y := \
 
 mt76x2e-y := \
 	pci.o pci_main.o pci_init.o pci_tx.o \
-	pci_core.o pci_mac.o pci_mcu.o pci_phy.o \
-	pci_dfs.o pci_trace.o
+	pci_mac.o pci_mcu.o pci_phy.o pci_dfs.o
 
 mt76x2u-y := \
 	usb.o usb_init.o usb_main.o usb_mac.o usb_mcu.o \
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index fc70711ea9e4..cbec8c6f1b2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -60,7 +60,6 @@ int mt76x2_register_device(struct mt76x02_dev *dev);
 void mt76x2_init_debugfs(struct mt76x02_dev *dev);
 void mt76x2_init_device(struct mt76x02_dev *dev);
 
-irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance);
 void mt76x2_phy_power_on(struct mt76x02_dev *dev);
 int mt76x2_init_hardware(struct mt76x02_dev *dev);
 void mt76x2_stop_hardware(struct mt76x02_dev *dev);
@@ -87,8 +86,6 @@ void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
 
 void mt76x2_pre_tbtt_tasklet(unsigned long arg);
 
-void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q);
-
 void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_update_channel(struct mt76_dev *mdev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 1fcf23dad06f..92432fe97312 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -19,7 +19,6 @@
 #include <linux/pci.h>
 
 #include "mt76x2.h"
-#include "trace.h"
 
 static const struct pci_device_id mt76pci_device_table[] = {
 	{ PCI_DEVICE(0x14c3, 0x7662) },
@@ -58,7 +57,7 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
-	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt76x2_irq_handler,
+	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt76x02_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
deleted file mode 100644
index 775ff0a43010..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_core.c
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/delay.h>
-#include "mt76x2.h"
-#include "trace.h"
-
-void mt76x2_rx_poll_complete(struct mt76_dev *mdev, enum mt76_rxq_id q)
-{
-	struct mt76x02_dev *dev;
-
-	dev = container_of(mdev, struct mt76x02_dev, mt76);
-	mt76x02_irq_enable(dev, MT_INT_RX_DONE(q));
-}
-
-irqreturn_t mt76x2_irq_handler(int irq, void *dev_instance)
-{
-	struct mt76x02_dev *dev = dev_instance;
-	u32 intr;
-
-	intr = mt76_rr(dev, MT_INT_SOURCE_CSR);
-	mt76_wr(dev, MT_INT_SOURCE_CSR, intr);
-
-	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
-		return IRQ_NONE;
-
-	trace_dev_irq(dev, intr, dev->mt76.mmio.irqmask);
-
-	intr &= dev->mt76.mmio.irqmask;
-
-	if (intr & MT_INT_TX_DONE_ALL) {
-		mt76x02_irq_disable(dev, MT_INT_TX_DONE_ALL);
-		tasklet_schedule(&dev->tx_tasklet);
-	}
-
-	if (intr & MT_INT_RX_DONE(0)) {
-		mt76x02_irq_disable(dev, MT_INT_RX_DONE(0));
-		napi_schedule(&dev->mt76.napi[0]);
-	}
-
-	if (intr & MT_INT_RX_DONE(1)) {
-		mt76x02_irq_disable(dev, MT_INT_RX_DONE(1));
-		napi_schedule(&dev->mt76.napi[1]);
-	}
-
-	if (intr & MT_INT_PRE_TBTT)
-		tasklet_schedule(&dev->pre_tbtt_tasklet);
-
-	/* send buffered multicast frames now */
-	if (intr & MT_INT_TBTT)
-		mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
-
-	if (intr & MT_INT_TX_STAT) {
-		mt76x02_mac_poll_tx_status(dev, true);
-		tasklet_schedule(&dev->tx_tasklet);
-	}
-
-	if (intr & MT_INT_GPTIMER) {
-		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
-		tasklet_schedule(&dev->dfs_pd.dfs_tasklet);
-	}
-
-	return IRQ_HANDLED;
-}
-
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 88f2aa257274..f229c6eb65dc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -358,7 +358,7 @@ struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
 		.tx_prepare_skb = mt76x02_tx_prepare_skb,
 		.tx_complete_skb = mt76x02_tx_complete_skb,
 		.rx_skb = mt76x02_queue_rx_skb,
-		.rx_poll_complete = mt76x2_rx_poll_complete,
+		.rx_poll_complete = mt76x02_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
 	};
 	struct mt76x02_dev *dev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index c7484aa543fa..08366c5988ea 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -18,7 +18,6 @@
 #include "mt76x2.h"
 #include "mcu.h"
 #include "eeprom.h"
-#include "trace.h"
 
 void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c
deleted file mode 100644
index ea4ab8729ae4..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_trace.c
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/module.h>
-
-#ifndef __CHECKER__
-#define CREATE_TRACE_POINTS
-#include "trace.h"
-
-#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
deleted file mode 100644
index 86a4703ddbc1..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/trace.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
- * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
- * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
- * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#if !defined(__MT76x2_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
-#define __MT76x2_TRACE_H
-
-#include <linux/tracepoint.h>
-#include "mt76x2.h"
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM mt76x2
-
-#define MAXNAME		32
-#define DEV_ENTRY	__array(char, wiphy_name, 32)
-#define DEV_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(mt76_hw(dev)->wiphy), MAXNAME)
-#define DEV_PR_FMT	"%s"
-#define DEV_PR_ARG	__entry->wiphy_name
-
-#define TXID_ENTRY	__field(u8, wcid) __field(u8, pktid)
-#define TXID_ASSIGN	__entry->wcid = wcid; __entry->pktid = pktid
-#define TXID_PR_FMT	" [%d:%d]"
-#define TXID_PR_ARG	__entry->wcid, __entry->pktid
-
-TRACE_EVENT(dev_irq,
-	TP_PROTO(struct mt76x02_dev *dev, u32 val, u32 mask),
-
-	TP_ARGS(dev, val, mask),
-
-	TP_STRUCT__entry(
-		DEV_ENTRY
-		__field(u32, val)
-		__field(u32, mask)
-	),
-
-	TP_fast_assign(
-		DEV_ASSIGN;
-		__entry->val = val;
-		__entry->mask = mask;
-	),
-
-	TP_printk(
-		DEV_PR_FMT " %08x & %08x",
-		DEV_PR_ARG, __entry->val, __entry->mask
-	)
-);
-
-#endif
-
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE trace
-
-#include <trace/define_trace.h>
-- 
2.17.1

