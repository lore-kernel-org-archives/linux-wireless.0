Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D09ABC282DA
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB8FD218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388746AbfAaQ4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:56:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33290 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfAaQ4S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:56:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id p7so4157584wru.0
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 08:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HHlxkOeh+D363SlFen1wvOmfZGM4LpuXbtMk6w5zvK8=;
        b=ja8dvRP/0M93tsyBHYCy0EXLGWFZe7SyR+lQCRqvErlD8bLLd6Z2rhfKk+G+RS+97P
         gjMrgakYKx/ILOBX0D3U/k6CLJQdnhlz6KLf2T/uuVrqIrdl2xkOXxHwwl63R1Lq0fVF
         TKVXV2NvIuUm1kt650lRkZ00+jYJu7PZlgX5mQxJ3k6k1BvdA39BNO0gSyBEcGW9bs+R
         Z1AsbNIjBIkI4CURnxCsEhPWPo7FFPXQ/tCaxYFR1I+xRht/d4n9XiMkc8Uol04HF+mJ
         wj0oH0mwelxlGZal70ZgQtIV5bP748yALQoxn3ZdNrffj7xsJNU3P7g7f/+mdtwd5+nN
         vB1w==
X-Gm-Message-State: AJcUukeNZt2va9ROTSE5qQXovu+sJPhRBoPgyVuOJ9g8zyXUqoLQGYQO
        dihmxCY3k1IHfy0TSghxY6NZuQ==
X-Google-Smtp-Source: ALg8bN65lLKBpNt2nWNNgw/8c2k+QvU4URHnJI5jTlZn22Qwf0j1ja57tP/1Lps1nKkBl4QE0Md55w==
X-Received: by 2002:adf:ab51:: with SMTP id r17mr35137271wrc.62.1548953776945;
        Thu, 31 Jan 2019 08:56:16 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k128sm9502889wmd.37.2019.01.31.08.56.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 31 Jan 2019 08:56:16 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 4/4] mt76x2: remove mt76x2_alloc_device routine
Date:   Thu, 31 Jan 2019 17:55:57 +0100
Message-Id: <4a49cdbb42a8f44f5b8e8cb9d1bdc1a02a2f811a.1548952312.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
References: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76x2_alloc_device since it just runs mt76_alloc_device.
Move mt76_alloc_device call in mt76x2_probe

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x2/mt76x2.h    |  1 -
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   | 26 ++++++++++++++-----
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  | 26 -------------------
 3 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
index 28ec19acf9db..6c619f1c65c9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2.h
@@ -49,7 +49,6 @@ static inline bool mt76x2_channel_silent(struct mt76x02_dev *dev)
 
 extern const struct ieee80211_ops mt76x2_ops;
 
-struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev);
 int mt76x2_register_device(struct mt76x02_dev *dev);
 
 void mt76x2_phy_power_on(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
index 92432fe97312..6274655e1f7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci.c
@@ -30,7 +30,19 @@ static const struct pci_device_id mt76pci_device_table[] = {
 static int
 mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	static const struct mt76_driver_ops drv_ops = {
+		.txwi_size = sizeof(struct mt76x02_txwi),
+		.update_survey = mt76x02_update_channel,
+		.tx_prepare_skb = mt76x02_tx_prepare_skb,
+		.tx_complete_skb = mt76x02_tx_complete_skb,
+		.rx_skb = mt76x02_queue_rx_skb,
+		.rx_poll_complete = mt76x02_rx_poll_complete,
+		.sta_ps = mt76x02_sta_ps,
+		.sta_add = mt76x02_sta_add,
+		.sta_remove = mt76x02_sta_remove,
+	};
 	struct mt76x02_dev *dev;
+	struct mt76_dev *mdev;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -47,17 +59,19 @@ mt76pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	dev = mt76x2_alloc_device(&pdev->dev);
-	if (!dev)
+	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt76x2_ops,
+				 &drv_ops);
+	if (!mdev)
 		return -ENOMEM;
 
-	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+	mt76_mmio_init(mdev, pcim_iomap_table(pdev)[0]);
 	mt76x2_reset_wlan(dev, false);
 
-	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
-	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
+	mdev->rev = mt76_rr(dev, MT_ASIC_VERSION);
+	dev_info(mdev->dev, "ASIC revision: %08x\n", mdev->rev);
 
-	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt76x02_irq_handler,
+	ret = devm_request_irq(mdev->dev, pdev->irq, mt76x02_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index be2f53604311..59a827cfb2d2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -315,32 +315,6 @@ void mt76x2_cleanup(struct mt76x02_dev *dev)
 	mt76x02_mcu_cleanup(dev);
 }
 
-struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
-{
-	static const struct mt76_driver_ops drv_ops = {
-		.txwi_size = sizeof(struct mt76x02_txwi),
-		.update_survey = mt76x02_update_channel,
-		.tx_prepare_skb = mt76x02_tx_prepare_skb,
-		.tx_complete_skb = mt76x02_tx_complete_skb,
-		.rx_skb = mt76x02_queue_rx_skb,
-		.rx_poll_complete = mt76x02_rx_poll_complete,
-		.sta_ps = mt76x02_sta_ps,
-		.sta_add = mt76x02_sta_add,
-		.sta_remove = mt76x02_sta_remove,
-	};
-	struct mt76x02_dev *dev;
-	struct mt76_dev *mdev;
-
-	mdev = mt76_alloc_device(pdev, sizeof(*dev), &mt76x2_ops,
-				 &drv_ops);
-	if (!mdev)
-		return NULL;
-
-	dev = container_of(mdev, struct mt76x02_dev, mt76);
-
-	return dev;
-}
-
 int mt76x2_register_device(struct mt76x02_dev *dev)
 {
 	int ret;
-- 
2.20.1

