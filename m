Return-Path: <SRS0=QFll=PB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0518C64E75
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 16:25:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C66321736
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Dec 2018 16:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbeLXQZA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 24 Dec 2018 11:25:00 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52209 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbeLXQZA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Dec 2018 11:25:00 -0500
Received: by mail-wm1-f67.google.com with SMTP id b11so11511934wmj.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Dec 2018 08:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BOKYftvS6s4HYnxpeMUdPAtiqdyIrd9ggcYl+6eCaZM=;
        b=imvkWSeU0OIBjjwvsGRdmKPtIoYBQQ8MaUvS3AQGsJSFa6snA4WijsvR8aL7PsTBzB
         XTwb9oKq+8M/7WjwwQGZA5mzkbXZ9tnaL78W8dpIQ/M6ca+N1uVmzBysZqnSYAgYRisp
         xXVqR2xBxmQkzKIXrdApbxbWC2V+tMUptVEpHUBdVYQOo1G0+YaQxHeAsmxXH99PBXhf
         9y3CT+sE2yQ9MMBQsEUs2LkDT+p1TXLixq5sycWh15FsVfjl5hk8GbMG+adko7jls1Zh
         XangIEipMnKffQfrX+35wF0nvOvLMw65I/2AInzHhIYv/H7wbSgaK5lEI3189FQg3Lt6
         QmSA==
X-Gm-Message-State: AJcUukeGIxwNzygJG+o7hL5Ei+VSG5nIfkP8wWaEN3Cf6bzcxxBqPSWY
        1X1J95Fjahigbs1PNDVE8vMJbw==
X-Google-Smtp-Source: AFSGD/WmDDU5SIMYRxjoDcu4yDAMNQOL80AcBXyTEINRm/1/TWLByCZxMTEpBchjpuZIWXpbOm6eXg==
X-Received: by 2002:a1c:cf0d:: with SMTP id f13mr12330900wmg.70.1545668697383;
        Mon, 24 Dec 2018 08:24:57 -0800 (PST)
Received: from localhost.localdomain.com (host89-60-dynamic.56-79-r.retail.telecomitalia.it. [79.56.60.89])
        by smtp.gmail.com with ESMTPSA id o82sm21283194wmo.29.2018.12.24.08.24.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 Dec 2018 08:24:56 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 2/2] mt76: introduce mt76x02_check_tx_hang watchdog
Date:   Mon, 24 Dec 2018 17:24:42 +0100
Message-Id: <cce12fc0b89944f1bea0b8bbddacf81547572c0f.1545667662.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
References: <cover.1545667662.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Port mt76x02_check_tx_hang watchdog from vendor driver in order to
perform a device reset when tx mac/dma logic hangs. Tx mac/dma stuck
has been observed when the device is heavily loaded or in a noisy
environment.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  6 ++
 .../wireless/mediatek/mt76/mt76x02_debugfs.c  |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  | 88 ++++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 23 +++++
 5 files changed, 119 insertions(+), 1 deletion(-)

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
index 17e13e373f53..09ae4f246131 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -29,6 +29,8 @@
 #define MT_WATCHDOG_TIME	(HZ / 10)
 #define MT_CALIBRATE_INTERVAL	HZ
 
+#define MT_TX_HANG_TH		10
+
 #define MT_MAX_CHAINS		2
 struct mt76x02_rx_freq_cal {
 	s8 high_gain[MT_MAX_CHAINS];
@@ -91,6 +93,9 @@ struct mt76x02_dev {
 	u8 tbtt_count;
 	u16 beacon_int;
 
+	u32 tx_hang_reset;
+	u8 tx_hang_check;
+
 	struct mt76x02_calibration cal;
 
 	s8 target_power;
@@ -144,6 +149,7 @@ s8 mt76x02_tx_get_max_txpwr_adj(struct mt76x02_dev *dev,
 				const struct ieee80211_tx_rate *rate);
 s8 mt76x02_tx_get_txpwr_adj(struct mt76x02_dev *dev, s8 txpwr,
 			    s8 max_txpwr_adj);
+bool mt76x02_tx_hang(struct mt76x02_dev *dev);
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
index a4ff5a7a219f..402944e81e5e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -778,6 +778,90 @@ static void mt76x02_check_mac_err(struct mt76x02_dev *dev)
 		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
 }
 
+static void mt76x02_mac_watchdog_reset(struct mt76x02_dev *dev)
+{
+	u32 mask = dev->mt76.mmio.irqmask;
+	int i;
+
+	ieee80211_stop_queues(dev->mt76.hw);
+	set_bit(MT76_RESET, &dev->mt76.state);
+
+	if (dev->beacon_mask) {
+		tasklet_disable(&dev->pre_tbtt_tasklet);
+		mt76_clear(dev, MT_BEACON_TIME_CFG,
+			   MT_BEACON_TIME_CFG_BEACON_TX |
+			   MT_BEACON_TIME_CFG_TBTT_EN);
+	}
+
+	tasklet_disable(&dev->tx_tasklet);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++)
+		napi_disable(&dev->mt76.napi[i]);
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
+	mt76_wr(dev, MT_MAC_SYS_CTRL,
+		MT_MAC_SYS_CTRL_ENABLE_TX | MT_MAC_SYS_CTRL_ENABLE_RX);
+	mt76_set(dev, MT_WPDMA_GLO_CFG,
+		 MT_WPDMA_GLO_CFG_TX_DMA_EN | MT_WPDMA_GLO_CFG_RX_DMA_EN);
+	if (dev->ed_monitor)
+		mt76_set(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
+
+	clear_bit(MT76_RESET, &dev->mt76.state);
+
+	mt76x02_irq_enable(dev, mask);
+
+	tasklet_enable(&dev->tx_tasklet);
+	tasklet_schedule(&dev->tx_tasklet);
+
+	for (i = 0; i < ARRAY_SIZE(dev->mt76.napi); i++) {
+		napi_enable(&dev->mt76.napi[i]);
+		napi_schedule(&dev->mt76.napi[i]);
+	}
+
+	if (dev->beacon_mask) {
+		tasklet_enable(&dev->pre_tbtt_tasklet);
+		mt76_set(dev, MT_BEACON_TIME_CFG,
+			 MT_BEACON_TIME_CFG_BEACON_TX |
+			 MT_BEACON_TIME_CFG_TBTT_EN);
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
+		mt76x02_mac_watchdog_reset(dev);
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
 static void
 mt76x02_edcca_tx_enable(struct mt76x02_dev *dev, bool enable)
 {
@@ -876,7 +960,9 @@ void mt76x02_mac_work(struct work_struct *work)
 		dev->aggr_stats[idx++] += val >> 16;
 	}
 
-	/* XXX: check beacon stuck for ap mode */
+	if (mt76_is_mmio(dev))
+		mt76x02_check_tx_hang(dev);
+
 	if (!dev->beacon_mask)
 		mt76x02_check_mac_err(dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 6974acc75e2b..89d9cb1f45bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -385,3 +385,26 @@ void mt76x02_mac_start(struct mt76x02_dev *dev)
 			   MT_INT_TX_STAT);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_start);
+
+bool mt76x02_tx_hang(struct mt76x02_dev *dev)
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
-- 
2.20.1

