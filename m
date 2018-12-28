Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C27C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 14:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B01A820869
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 14:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbeL1OpY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 09:45:24 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41614 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbeL1OpX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 09:45:23 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so21083418wrs.8
        for <linux-wireless@vger.kernel.org>; Fri, 28 Dec 2018 06:45:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3kYWcYdjDGTLAm2iV4VkWYKAr5flZBmzpOATPk8/bwA=;
        b=sDKzcaA65rX4/YPiVZL1IZ6e108X8rsUpaA3MoU2CVt9Qfrz2NYG/JXloMd4DRf6ci
         T3nAokoyKHyh15t8qV9P1DaVEljB/gYNTyQgflc3tIlGH/6nO7NK8Z6Qb8G/H5I2/AUs
         Nci4nsBzK0FgVB0Oy+6tzjPwUYUY5e9Xq3S+DVg1nIL88xoEEy6KPmbonoQurpK/ehhS
         1C3Rh3wUWA+r7eVzXBDlEnXaWsJEEf9++DyYVHssFboh/zMsXI5o9HH0JfDvo/s/SoDw
         O6SknLHDkrbn7+Ffu5z9J5rWwU+zaSjqBfii96QRpyJuHd0FP58vrA7WKr96ronvrgTL
         Z+VQ==
X-Gm-Message-State: AJcUukepa/fHFudDFWviGpg0tXur/mk/OhHFjHRGPQLyoY8BkD8NIxqY
        Hw29Qwn6kacxQV+RwBm48Rmw1ReE10U=
X-Google-Smtp-Source: ALg8bN45wKWTLnPO3ohnS6K1d6oaNe8Xdshpk86kdC9D5709Mhac5SNmy1AAtZJaOVmpb1MJjYb6dw==
X-Received: by 2002:adf:c042:: with SMTP id c2mr26610987wrf.158.1546008321650;
        Fri, 28 Dec 2018 06:45:21 -0800 (PST)
Received: from localhost.net (host10-126-dynamic.18-79-r.retail.telecomitalia.it. [79.18.126.10])
        by smtp.gmail.com with ESMTPSA id 126sm70087610wmx.26.2018.12.28.06.45.19
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Dec 2018 06:45:20 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2] mt76: mmio: introduce mt76x02_check_tx_hang watchdog
Date:   Fri, 28 Dec 2018 15:44:09 +0100
Message-Id: <82a9efd24a70b701808d4ecd8ad2c8289463ae35.1546004654.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1546004654.git.lorenzo.bianconi@redhat.com>
References: <cover.1546004654.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Port mt76x02_check_tx_hang watchdog from vendor driver in order to
perform a device reset when tx mac/dma logic hangs. Tx mac/dma stuck
has been observed when the device is heavy loaded or in a noisy
environment. Moreover introduce wdt delayed work in order to run
tx_hang watchdog. For the moment run mt76x02_check_tx_hang watchdog
just on mt76x2 devices since the issue has not been observed on mt76x0
driver yet

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- drop patch 1/2 and introduce wdt work
- move watchdog routines in mt76x02_mmio.c
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |   1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |   8 ++
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |   1 -
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 124 ++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c |   2 +
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |   1 +
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |   2 +
 8 files changed, 140 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5cd508a68609..8ef430d8afc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -421,6 +421,7 @@ struct mt76_dev {
 	struct mt76_queue q_tx[__MT_TXQ_MAX];
 	struct mt76_queue q_rx[__MT_RXQ_MAX];
 	const struct mt76_queue_ops *queue_ops;
+	int tx_dma_idx[4];
 
 	wait_queue_head_t tx_wait;
 	struct sk_buff_head status_list;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index f383fdd914c5..f594e8c82500 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -28,6 +28,9 @@
 
 #define MT_CALIBRATE_INTERVAL	HZ
 
+#define MT_WATCHDOG_TIME	(HZ / 10)
+#define MT_TX_HANG_TH		10
+
 #define MT_MAX_CHAINS		2
 struct mt76x02_rx_freq_cal {
 	s8 high_gain[MT_MAX_CHAINS];
@@ -79,6 +82,7 @@ struct mt76x02_dev {
 	struct tasklet_struct pre_tbtt_tasklet;
 	struct delayed_work cal_work;
 	struct delayed_work mac_work;
+	struct delayed_work wdt_work;
 
 	u32 aggr_stats[32];
 
@@ -89,6 +93,9 @@ struct mt76x02_dev {
 	u8 tbtt_count;
 	u16 beacon_int;
 
+	u32 tx_hang_reset;
+	u8 tx_hang_check;
+
 	struct mt76x02_calibration cal;
 
 	s8 target_power;
@@ -142,6 +149,7 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76x02_dev *dev,
 				const struct ieee80211_tx_rate *rate);
 s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr,
 			    s8 max_txpwr_adj);
+void mt76x02_wdt_work(struct work_struct *work);
 void mt76x02_tx_set_txpwr_auto(struct mt76x02_dev *dev, s8 txpwr);
 void mt76x02_set_tx_ackto(struct mt76x02_dev *dev);
 void mt76x02_set_coverage_class(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
index a9d52ba1e270..7580c5c986ff 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_debugfs.c
@@ -133,5 +133,7 @@ void mt76x02_init_debugfs(struct mt76x02_dev *dev)
 				    read_txpower);
 
 	debugfs_create_devm_seqfile(dev->mt76.dev, "agc", dir, read_agc);
+
+	debugfs_create_u32("tx_hang_reset", 0400, dir, &dev->tx_hang_reset);
 }
 EXPORT_SYMBOL_GPL(mt76x02_init_debugfs);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index cc584ea4a8d7..6adea0278284 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -943,7 +943,6 @@ void mt76x02_mac_work(struct work_struct *work)
 		dev->aggr_stats[idx++] += val >> 16;
 	}
 
-	/* XXX: check beacon stuck for ap mode */
 	if (!dev->beacon_mask)
 		mt76x02_check_mac_err(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 6974acc75e2b..6236c6121c01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -385,3 +385,127 @@ void mt76x02_mac_start(struct mt76x02_dev *dev)
 			   MT_INT_TX_STAT);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_start);
+
+static bool mt76x02_tx_hang(struct mt76x02_dev *dev)
+{
+	u32 dma_idx, prev_dma_idx;
+	struct mt76_queue *q;
+	int i;
+
+	for (i = 0; i < 4; i++) {
+		q = &dev->mt76.q_tx[i];
+
+		if (!q->queued)
+			continue;
+
+		prev_dma_idx = dev->mt76.tx_dma_idx[i];
+		dma_idx = ioread32(&q->regs->dma_idx);
+		dev->mt76.tx_dma_idx[i] = dma_idx;
+
+		if (prev_dma_idx == dma_idx)
+			break;
+	}
+
+	return i < 4;
+}
+
+static void mt76x02_watchdog_reset(struct mt76x02_dev *dev)
+{
+	u32 mask = dev->mt76.mmio.irqmask;
+	int i;
+
+	ieee80211_stop_queues(dev->mt76.hw);
+	set_bit(MT76_RESET, &dev->mt76.state);
+
+	tasklet_disable(&dev->pre_tbtt_tasklet);
+	tasklet_disable(&dev->tx_tasklet);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++)
+		napi_disable(&dev->mt76.napi[i]);
+
+	mutex_lock(&dev->mt76.mutex);
+
+	if (dev->beacon_mask)
+		mt76_clear(dev, MT_BEACON_TIME_CFG,
+			   MT_BEACON_TIME_CFG_BEACON_TX |
+			   MT_BEACON_TIME_CFG_TBTT_EN);
+
+	mt76x02_irq_disable(dev, mask);
+
+	/* perform device reset */
+	mt76_clear(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+	mt76_wr(dev, MT_MAC_SYS_CTRL, 0);
+	mt76_clear(dev, MT_WPDMA_GLO_CFG,
+		   MT_WPDMA_GLO_CFG_TX_DMA_EN | MT_WPDMA_GLO_CFG_RX_DMA_EN);
+	usleep_range(5000, 10000);
+	mt76_wr(dev, MT_INT_SOURCE_CSR, 0xffffffff);
+
+	/* let fw reset DMA */
+	mt76_set(dev, 0x734, 0x3);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_tx); i++)
+		mt76_queue_tx_cleanup(dev, i, true);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.q_rx); i++)
+		mt76_queue_rx_reset(dev, i);
+
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76_set(dev, MT_WPDMA_GLO_CFG,
+		 MT_WPDMA_GLO_CFG_TX_DMA_EN | MT_WPDMA_GLO_CFG_RX_DMA_EN);
+	if (dev->ed_monitor)
+		mt76_set(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+
+	if (dev->beacon_mask)
+		mt76_set(dev, MT_BEACON_TIME_CFG,
+			 MT_BEACON_TIME_CFG_BEACON_TX |
+			 MT_BEACON_TIME_CFG_TBTT_EN);
+
+	mt76x02_irq_enable(dev, mask);
+
+	mutex_unlock(&dev->mt76.mutex);
+
+	clear_bit(MT76_RESET, &dev->mt76.state);
+
+	tasklet_enable(&dev->tx_tasklet);
+	tasklet_schedule(&dev->tx_tasklet);
+
+	tasklet_enable(&dev->pre_tbtt_tasklet);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++) {
+		napi_enable(&dev->mt76.napi[i]);
+		napi_schedule(&dev->mt76.napi[i]);
+	}
+
+	ieee80211_wake_queues(dev->mt76.hw);
+
+	mt76_txq_schedule_all(&dev->mt76);
+}
+
+static void mt76x02_check_tx_hang(struct mt76x02_dev *dev)
+{
+	if (mt76x02_tx_hang(dev)) {
+		if (++dev->tx_hang_check < MT_TX_HANG_TH)
+			return;
+
+		mt76x02_watchdog_reset(dev);
+
+		dev->tx_hang_reset++;
+		dev->tx_hang_check = 0;
+		memset(dev->mt76.tx_dma_idx, 0xff,
+		       sizeof(dev->mt76.tx_dma_idx));
+	} else {
+		dev->tx_hang_check = 0;
+	}
+}
+
+void mt76x02_wdt_work(struct work_struct *work)
+{
+	struct mt76x02_dev *dev = container_of(work, struct mt76x02_dev,
+					       wdt_work.work);
+
+	mt76x02_check_tx_hang(dev);
+
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->wdt_work,
+				     MT_WATCHDOG_TIME);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index aac64d0969b8..3c878f18e05d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -93,6 +93,8 @@ void mt76x02_init_device(struct mt76x02_dev *dev)
 					 MT_DMA_HDR_LEN;
 		wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 	} else {
+		INIT_DELAYED_WORK(&dev->wdt_work, mt76x02_wdt_work);
+
 		mt76x02_dfs_init_detector(dev);
 
 		wiphy->reg_notifier = mt76x02_regd_notifier;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index 9f313824eead..34418e575542 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -301,6 +301,7 @@ void mt76x2_stop_hardware(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
+	cancel_delayed_work_sync(&dev->wdt_work);
 	mt76x02_mcu_set_radio_state(dev, false);
 	mt76x2_mac_stop(dev, false);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
index b54a32397486..6a87b88eb036 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c
@@ -34,6 +34,8 @@ mt76x2_start(struct ieee80211_hw *hw)
 
 	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->mac_work,
 				     MT_CALIBRATE_INTERVAL);
+	ieee80211_queue_delayed_work(mt76_hw(dev), &dev->wdt_work,
+				     MT_WATCHDOG_TIME);
 
 	set_bit(MT76_STATE_RUNNING, &dev->mt76.state);
 
-- 
2.20.1

