Return-Path: <SRS0=EPmr=NA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A61BC67863
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F01EF2150F
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Oct 2018 10:14:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F01EF2150F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbeJTSYA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Oct 2018 14:24:00 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38489 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJTSX7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Oct 2018 14:23:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id 193-v6so5817194wme.3
        for <linux-wireless@vger.kernel.org>; Sat, 20 Oct 2018 03:14:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cw4vhwhoHDyYiw+BWKfWoeMqP1/JaOYhARF7zaj+29I=;
        b=H0K9DvXYXqrcS+2T6HMHXCz/StpVd924C0uFvwlHUrwU418oTURSFL/5BM4cXQ3EJK
         FcUoMCzLafc/vKEVqdXUzLq6Wdk5XDMcN4TpH5f8Dy8y3IHpZEJrQJHWLeZ5Ks53wDqv
         vQmDt1YtOmng0cUlmdjPSHqObvPQw8WELqWNhOt1HfbCt+GHi/5bieniz0zk6N+yDewd
         AR3nc8wtYVDL8fJ26H06emzYpbzVtDxQiQ9QhEEuttCaGFMpkMI0GcVfdSLwBBW9AwQ0
         3/5sMmm5yrBGGHYWtZrF+Zaabse0TwHcg2UbVJ3awUfl6ePyCUDYDBRMGqVo4vQsOa+t
         NVjg==
X-Gm-Message-State: ABuFfoiAf2ndX4y/UALDjwxSMQD3Oib81+T7bdHR+0gOijsetnDWIXib
        CSliAl8n7sfBd6BxrfsmVmdTtQ==
X-Google-Smtp-Source: ACcGV60NXA3mDXNQJhP7xb4cHTrxnkM58cK0GZoT7aFGtY+2+0E25Pl1v7Re/9UstuezgAw9t/YCmw==
X-Received: by 2002:a7b:c1d9:: with SMTP id a25-v6mr8344798wmj.55.1540030442410;
        Sat, 20 Oct 2018 03:14:02 -0700 (PDT)
Received: from localhost.localdomain ([151.66.57.235])
        by smtp.gmail.com with ESMTPSA id c2-v6sm19548631wrt.77.2018.10.20.03.14.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 03:14:01 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 4/9] mt76x0: pci: add pre_tbtt_tasklet support
Date:   Sat, 20 Oct 2018 12:13:27 +0200
Message-Id: <4b31ed66b9cf7a42f3ea47ec118f119b1688a24f.1540029458.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
References: <cover.1540029458.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable/disable pre_tbtt_tasklet in mt76x0 driver in order
to add AP support

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c     | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h         | 2 --
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c    | 6 ++++--
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c | 3 ---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index a61b23239cb2..da98382bdb5a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -22,6 +22,7 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	int ret;
 
 	cancel_delayed_work_sync(&dev->cal_work);
+	tasklet_disable(&dev->pre_tbtt_tasklet);
 
 	mt76_set_channel(&dev->mt76);
 	ret = mt76x0_phy_set_channel(dev, chandef);
@@ -30,6 +31,7 @@ mt76x0_set_channel(struct mt76x02_dev *dev, struct cfg80211_chan_def *chandef)
 	mt76_rr(dev, MT_CH_IDLE);
 	mt76_rr(dev, MT_CH_BUSY);
 
+	tasklet_enable(&dev->pre_tbtt_tasklet);
 	mt76_txq_schedule_all(&dev->mt76);
 
 	return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 6e11b8c8e495..f15f9bf14900 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -187,6 +187,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static void mt76x0e_cleanup(struct mt76x02_dev *dev)
 {
 	clear_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+	tasklet_disable(&dev->pre_tbtt_tasklet);
 	mt76x0_chip_onoff(dev, false, false);
 	mt76x0e_stop_hw(dev);
 	mt76x02_dma_cleanup(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index 72343d329f81..1cd0f758587d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -148,8 +148,6 @@ int mt76x02_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			   struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			   u32 *tx_info);
 
-void mt76x02_pre_tbtt_tasklet(unsigned long arg);
-
 extern const u16 mt76x02_beacon_offsets[16];
 void mt76x02_set_beacon_offsets(struct mt76x02_dev *dev);
 void mt76x02_set_irq_mask(struct mt76x02_dev *dev, u32 clear, u32 set);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index ab1c8c8ef15b..66315410aebe 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -99,7 +99,7 @@ mt76x02_resync_beacon_timer(struct mt76x02_dev *dev)
 		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
 }
 
-void mt76x02_pre_tbtt_tasklet(unsigned long arg)
+static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 {
 	struct mt76x02_dev *dev = (struct mt76x02_dev *)arg;
 	struct mt76_queue *q = &dev->mt76.q_tx[MT_TXQ_PSD];
@@ -144,7 +144,6 @@ void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 	}
 	spin_unlock_bh(&q->lock);
 }
-EXPORT_SYMBOL_GPL(mt76x02_pre_tbtt_tasklet);
 
 static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
@@ -223,6 +222,9 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 		return -ENOMEM;
 
 	tasklet_init(&dev->tx_tasklet, mt76x02_tx_tasklet, (unsigned long) dev);
+	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
+		     (unsigned long)dev);
+
 	kfifo_init(&dev->txstatus_fifo, status_fifo, fifo_size);
 
 	mt76_dma_attach(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index bc1dbdf5af20..c5d5fcbd9a55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -298,9 +298,6 @@ int mt76x2_init_hardware(struct mt76x02_dev *dev)
 {
 	int ret;
 
-	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
-		     (unsigned long) dev);
-
 	mt76x02_dma_disable(dev);
 	mt76x2_reset_wlan(dev, true);
 	mt76x2_power_on(dev);
-- 
2.19.1

