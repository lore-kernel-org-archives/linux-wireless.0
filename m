Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D73FC64EBC
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EA5320684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EA5320684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbeJCOgW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:22 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54428 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726807AbeJCOgW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id r63-v6so4674895wma.4
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eRyV+VvkhRxJO9J+VY5Rq+2tHI1HSOd2LmbzW8gRx54=;
        b=EolCdhSNTtLhF1i9Q5iV33pbcF5uUhEGEcuu64XcXiB9VyKfM96ci/iVI9Bi+k3qSz
         /TdccOo6HrZCZwqUHvq3u+Rh89A8bUNvt/KrRtJtC4PSt9t+F0CHTSIMJrsfNTIykH8X
         KonxBwsbzi9DJBwhRaG/pqzdzN6gocIRqHeSAzV0qHoQGV7ei/wetyiMxj8dmsEOskn3
         AeoqQ9/Uu6lqBCndJhwQZc6PQNBfJlL10HpOToIR/oqXjCK7jb9TmqC+WmF7utE514sc
         k/ioYh1H2swjye81gmD+KJ1qikhO+Znee+ZXzqrecpu7oha3nqJ/UD45A/MnoXUt01Ed
         Vgfw==
X-Gm-Message-State: ABuFfog2D8M3MEVAY2sN3URDU0nIzYmGjLSP34dSIU0Bcqw0FFGwZChq
        XaKRFqqbzxcZX8CaAqL1Q5+cKlWfo8g=
X-Google-Smtp-Source: ACcGV61BO1bp/8Peu+VUXXBWwf/5nHwyRvfJt+u96O0IqwB8m7FqoocaI9qMZWVybTbnkdkKV8+Q5Q==
X-Received: by 2002:a1c:99c2:: with SMTP id b185-v6mr514239wme.15.1538552945800;
        Wed, 03 Oct 2018 00:49:05 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.49.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:49:05 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 7/9] mt76: move tx_tasklet management in mt76x02-lib moudle
Date:   Wed,  3 Oct 2018 09:48:49 +0200
Message-Id: <f840153456ea71b7645d86ad27fd9fcae4b1fc15.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
References: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move tx_tasklet management in mt76x02_mmio.c in order to
be reused by mt76x0 driver and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_dma.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 42 ++++++++++++++++++-
 .../wireless/mediatek/mt76/mt76x2/Makefile    |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2/mac.h   |  2 -
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  3 --
 .../wireless/mediatek/mt76/mt76x2/pci_dma.c   | 37 ----------------
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 11 +----
 .../wireless/mediatek/mt76/mt76x2/pci_mac.c   |  9 ----
 9 files changed, 45 insertions(+), 64 deletions(-)
 delete mode 100644 drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index f817c870587d..87997cddf0d6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -166,7 +166,7 @@ static void mt76x0e_cleanup(struct mt76x02_dev *dev)
 	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
 	mt76x0e_stop_hw(dev);
-	mt76_dma_cleanup(&dev->mt76);
+	mt76x02_dma_cleanup(dev);
 	mt76x02_mcu_cleanup(&dev->mt76);
 }
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
index aa38ef9ec7d0..6394010a565f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_dma.h
@@ -72,5 +72,6 @@ mt76x02_wait_for_wpdma(struct mt76_dev *dev, int timeout)
 
 int mt76x02_dma_init(struct mt76x02_dev *dev);
 void mt76x02_dma_disable(struct mt76x02_dev *dev);
+void mt76x02_dma_cleanup(struct mt76x02_dev *dev);
 
 #endif /* __MT76x02_DMA_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 98aeb64d9c37..bb609b775de9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -57,16 +57,49 @@ mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 	return 0;
 }
 
+static void mt76x02_process_tx_status_fifo(struct mt76x02_dev *dev)
+{
+	struct mt76x02_tx_status stat;
+	u8 update = 1;
+
+	while (kfifo_get(&dev->txstatus_fifo, &stat))
+		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
+}
+
+static void mt76x02_tx_tasklet(unsigned long data)
+{
+	struct mt76x02_dev *dev = (struct mt76x02_dev *)data;
+	int i;
+
+	mt76x02_process_tx_status_fifo(dev);
+
+	for (i = MT_TXQ_MCU; i >= 0; i--)
+		mt76_queue_tx_cleanup(dev, i, false);
+
+	mt76x02_mac_poll_tx_status(dev, false);
+	mt76x02_irq_enable(dev, MT_INT_TX_DONE_ALL);
+}
+
 int mt76x02_dma_init(struct mt76x02_dev *dev)
 {
 	struct mt76_txwi_cache __maybe_unused *t;
+	int i, ret, fifo_size;
 	struct mt76_queue *q;
-	int i, ret;
+	void *status_fifo;
 
 	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
 	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
 
+	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x02_tx_status));
+	status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
+	if (!status_fifo)
+		return -ENOMEM;
+
+	tasklet_init(&dev->tx_tasklet, mt76x02_tx_tasklet, (unsigned long) dev);
+	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
+
 	mt76_dma_attach(&dev->mt76);
+
 	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
@@ -132,6 +165,13 @@ static void mt76x02_dma_enable(struct mt76x02_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_enable);
 
+void mt76x02_dma_cleanup(struct mt76x02_dev *dev)
+{
+	tasklet_kill(&dev->tx_tasklet);
+	mt76_dma_cleanup(&dev->mt76);
+}
+EXPORT_SYMBOL_GPL(mt76x02_dma_cleanup);
+
 void mt76x02_dma_disable(struct mt76x02_dev *dev)
 {
 	u32 val = mt76_rr(dev, MT_WPDMA_GLO_CFG);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
index 2e6ef73944ed..66f8b8ee6bc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/Makefile
@@ -6,7 +6,7 @@ mt76x2-common-y := \
 	eeprom.o mac.o init.o phy.o debugfs.o mcu.o
 
 mt76x2e-y := \
-	pci.o pci_dma.o pci_main.o pci_init.o pci_tx.o \
+	pci.o pci_main.o pci_init.o pci_tx.o \
 	pci_core.o pci_mac.o pci_mcu.o pci_phy.o \
 	pci_dfs.o pci_trace.o
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
index b13d629053d6..a31bd49ae6cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mac.h
@@ -32,8 +32,6 @@ int mt76x2_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
 void mt76x2_mac_set_beacon_enable(struct mt76x02_dev *dev, u8 vif_idx, bool val);
 
-void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev);
-
 void mt76x2_mac_work(struct work_struct *work);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index db9b3b30a8ac..fc70711ea9e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -81,9 +81,6 @@ int mt76x2_mcu_set_channel(struct mt76x02_dev *dev, u8 channel, u8 bw,
 int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 		       u8 channel);
 
-void mt76x2_tx_tasklet(unsigned long data);
-void mt76x2_dma_cleanup(struct mt76x02_dev *dev);
-
 void mt76x2_cleanup(struct mt76x02_dev *dev);
 
 void mt76x2_mac_set_tx_protection(struct mt76x02_dev *dev, u32 val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
deleted file mode 100644
index 1ac0df9a7928..000000000000
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dma.c
+++ /dev/null
@@ -1,37 +0,0 @@
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
-#include "mt76x2.h"
-
-void mt76x2_tx_tasklet(unsigned long data)
-{
-	struct mt76x02_dev *dev = (struct mt76x02_dev *) data;
-	int i;
-
-	mt76x2_mac_process_tx_status_fifo(dev);
-
-	for (i = MT_TXQ_MCU; i >= 0; i--)
-		mt76_queue_tx_cleanup(dev, i, false);
-
-	mt76x02_mac_poll_tx_status(dev, false);
-	mt76x02_irq_enable(dev, MT_INT_TX_DONE_ALL);
-}
-
-void mt76x2_dma_cleanup(struct mt76x02_dev *dev)
-{
-	tasklet_kill(&dev->tx_tasklet);
-	mt76_dma_cleanup(&dev->mt76);
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 78fdc4754b77..88f2aa257274 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -346,7 +346,7 @@ void mt76x2_cleanup(struct mt76x02_dev *dev)
 	tasklet_disable(&dev->dfs_pd.dfs_tasklet);
 	tasklet_disable(&dev->pre_tbtt_tasklet);
 	mt76x2_stop_hardware(dev);
-	mt76x2_dma_cleanup(dev);
+	mt76x02_dma_cleanup(dev);
 	mt76x02_mcu_cleanup(&dev->mt76);
 }
 
@@ -464,17 +464,8 @@ int mt76x2_register_device(struct mt76x02_dev *dev)
 {
 	struct ieee80211_hw *hw = mt76_hw(dev);
 	struct wiphy *wiphy = hw->wiphy;
-	void *status_fifo;
-	int fifo_size;
 	int i, ret;
 
-	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x02_tx_status));
-	status_fifo = devm_kzalloc(dev->mt76.dev, fifo_size, GFP_KERNEL);
-	if (!status_fifo)
-		return -ENOMEM;
-
-	tasklet_init(&dev->tx_tasklet, mt76x2_tx_tasklet, (unsigned long)dev);
-	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
 	INIT_DELAYED_WORK(&dev->cal_work, mt76x2_phy_calibrate);
 	INIT_DELAYED_WORK(&dev->mac_work, mt76x2_mac_work);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
index 710e91ca4af1..c7484aa543fa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mac.c
@@ -28,15 +28,6 @@ void mt76x2_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
 		       get_unaligned_le16(addr + 4));
 }
 
-void mt76x2_mac_process_tx_status_fifo(struct mt76x02_dev *dev)
-{
-	struct mt76x02_tx_status stat;
-	u8 update = 1;
-
-	while (kfifo_get(&dev->txstatus_fifo, &stat))
-		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
-}
-
 static int
 mt76_write_beacon(struct mt76x02_dev *dev, int offset, struct sk_buff *skb)
 {
-- 
2.17.1

