Return-Path: <SRS0=9HFQ=MT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E048DC65C30
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B14D920882
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Oct 2018 09:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B14D920882
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbeJGREO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Oct 2018 13:04:14 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43398 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeJGREO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Oct 2018 13:04:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id n1-v6so17635152wrt.10
        for <linux-wireless@vger.kernel.org>; Sun, 07 Oct 2018 02:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uCOs/hYoG+vW21WEJi3EevSA9hcY4l5l0Q353787baU=;
        b=QJcyQof7PcHBrDel4VQc6J0pS8EPbYVtuBU8aQs8/sdy7ZLnJLAQI3TAhvHJuXCZip
         NGAElbnz8ejrJMP2pIJ3C7utjWhvt8Ra/o0WuK3w8LunwcNrJ9F7R4XScg46lWcrlVIu
         RvfaFhLKgm9QH9kuEzz8TKuwRfR9w5DyqFYoi3vhcWpuI5LDWBlds2K/7kBXdgfnjmdo
         I0mrx5j8l0O4NM2er7DIm0uVDE+Fb0IjAmXC6h5wSQwokxjhcykTRF+Cpy3JWLhU68IT
         2aawiuIgvCklYNb/Vc3etLGAsDsvArRnJ84fzUnFkLtlu0JzkLgReAagvEVToNkpjHF2
         J/Vw==
X-Gm-Message-State: ABuFfogPlv5NlOrhuHZGbLvlFfuS9rruUTg3Ge6yNWO35illiNX/ClBV
        5WcFQsMqdI2IuclBAHQggwQq+g==
X-Google-Smtp-Source: ACcGV634ISDdk6ih+lCHKa2/5SPyBjoGFt55pN+PZrnDNtn8mcJeNAK9tLP/EiC1yGumfDogk7mtsQ==
X-Received: by 2002:adf:9af5:: with SMTP id a108-v6mr12733137wrc.125.1538906248054;
        Sun, 07 Oct 2018 02:57:28 -0700 (PDT)
Received: from localhost.localdomain ([151.66.32.138])
        by smtp.gmail.com with ESMTPSA id a5-v6sm6404631wmh.8.2018.10.07.02.57.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 07 Oct 2018 02:57:27 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mt76x0: pci: add mt76x0_register_device in mt76x0e_register_device
Date:   Sun,  7 Oct 2018 11:57:22 +0200
Message-Id: <20181007095722.13577-4-lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index ab91a22b4f05..10845f37af37 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -127,12 +127,25 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
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
 
@@ -150,7 +163,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	dev = mt76x0_alloc_device(&pdev->dev, NULL, &mt76x0e_ops);
+	dev = mt76x0_alloc_device(&pdev->dev, &drv_ops, &mt76x0e_ops);
 	if (!dev)
 		return -ENOMEM;
 
@@ -159,6 +172,11 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
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
2.19.0

