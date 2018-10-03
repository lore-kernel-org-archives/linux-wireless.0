Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7045CC65BA7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4295F20684
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 07:49:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4295F20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbeJCOgX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 10:36:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44814 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727336AbeJCOgX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 10:36:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id 63-v6so4928557wra.11
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 00:49:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pgFDOotoCMmppmAy6Kthbda7zZUDyXxmpPngZ939GJA=;
        b=Avn0jvpzuFVUzu4u2DfvxBKlFaDZjaXg13u1U5zPwM5oXu7nR6M6qeD6u7Yv6pTaAp
         GPv+FDFgEg3vRhqAEpMY/JARri6ZbkEpNBKt3KPAdyu6xZ19AKFMxQG3HOAhiCq7kiGP
         keLG6GWEkLBXN+1K65hkkLWgl6lwHmk0r1rvfoHV9BZiV1NN775vZMJSmZdwkA1CTG/3
         4BIqx//43b575iOdfB5dyEQ8oPPfM8vTp4Y52uNTRhudvmKutxZaRi0fHUPdpzyWFE4v
         UaJ+pNywa/Tq2H2hQBCXQVOjgiS5sSh+vUQM4V9Gx9tbYiM5kCKnX8qNNlamWqrmQRY3
         9KCQ==
X-Gm-Message-State: ABuFfogbdtZ+s9Q63b0lQZk7t69mhy3D19KQ0wLIxJhyC17hH+JLvFxM
        jlGOjBNWbIywgVv7abZ25IqNVyQGasE=
X-Google-Smtp-Source: ACcGV61mnkPJkIqZX3GO7y4FAOF4FQCJs/K0RsENFPyAsbhUY1XIAchSRv4oGJRoGT5l8/YJGZQIHg==
X-Received: by 2002:adf:e348:: with SMTP id n8-v6mr255685wrj.158.1538552947738;
        Wed, 03 Oct 2018 00:49:07 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id y3sm421878wrw.11.2018.10.03.00.49.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Oct 2018 00:49:07 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 9/9] mt76x0: pci: add mt76x0_register_device in mt76x0e_register_device
Date:   Wed,  3 Oct 2018 09:48:51 +0200
Message-Id: <7ebff9f3df7ff89688c99b209d370c71a31797a1.1538552703.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
References: <cover.1538552703.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Run mt76x0_register_device routine in mt76x0e_register_device
in order to register the device to the mac80211 layer.
Moreover init mt76_driver_ops data structure and register
interrupt line

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 87997cddf0d6..5c1045fbf699 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -118,12 +118,25 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	mt76_clear(dev, 0x110, BIT(9));
 	mt76_set(dev, MT_MAX_LEN_CFG, BIT(13));
 
+	err = mt76x0_register_device(dev);
+	if (err < 0)
+		return err;
+
+	set_bit(MT76_STATE_INITIALIZED, &dev->mt76.state);
+
 	return 0;
 }
 
 static int
 mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
+	static const struct mt76_driver_ops drv_ops = {
+		.txwi_size = sizeof(struct mt76x02_txwi),
+		.tx_prepare_skb = mt76x02_tx_prepare_skb,
+		.tx_complete_skb = mt76x02_tx_complete_skb,
+		.rx_skb = mt76x02_queue_rx_skb,
+		.rx_poll_complete = mt76x02_rx_poll_complete,
+	};
 	struct mt76x02_dev *dev;
 	int ret;
 
@@ -141,7 +154,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	dev = mt76x0_alloc_device(&pdev->dev, NULL, &mt76x0e_ops);
+	dev = mt76x0_alloc_device(&pdev->dev, &drv_ops, &mt76x0e_ops);
 	if (!dev)
 		return -ENOMEM;
 
@@ -150,6 +163,11 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
+	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt76x02_irq_handler,
+			       IRQF_SHARED, KBUILD_MODNAME, dev);
+	if (ret)
+		goto error;
+
 	ret = mt76x0e_register_device(dev);
 	if (ret < 0)
 		goto error;
-- 
2.17.1

