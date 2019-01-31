Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6ACEC169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A379C218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388742AbfAaQ4Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:56:16 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53766 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbfAaQ4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:56:16 -0500
Received: by mail-wm1-f65.google.com with SMTP id d15so3268671wmb.3
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 08:56:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HHfbs2/Z2KNMtpi2eLCy2m5zDayEON0cq1rb9gJqa0Q=;
        b=Q3ISa+hs89YHpQA34fIbBHOEuHroUuC0a381yWFuuvQ4a8NxmdQf074yBdRf7ABoOc
         rtWikjOWouefMZo54iA2jEEeqj5yFnEIO1CRjaBS/x41eliMOa6SQqIxZGepFHhHmwmL
         DY9Y4Htn/JIKuInigKKYURoUMC3miUp57+Qlk0NaOQcZO+HVANd2j+20OLpXterifhKY
         5Sq7ikPF1wqQ5Du58YFCnZhs9L/aNIrHgtgqyM6k8f4cl/I0RiCDTsUPPbp4cz4og64g
         ogeefv08YZZuci+enmCTqf7Hwr9dhT+eCWpmDrcoNcEd7cij+kaCZ+xT25n9BkLsQJo8
         OajQ==
X-Gm-Message-State: AJcUukdA77y4hdA6CeKD59Njm0iSGOrS1soUJ122556PmaDbqkno4wBm
        2ovwJnLF8M502oKN+k6pPKwoKg==
X-Google-Smtp-Source: ALg8bN4QmaS+0cwpSmpAqEx6hLTODEc5a4zKcuCT3KGk9MkYt+Ywoky4DofXGjzLveeY0areI66d4w==
X-Received: by 2002:a1c:494:: with SMTP id 142mr30209879wme.111.1548953774086;
        Thu, 31 Jan 2019 08:56:14 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k128sm9502889wmd.37.2019.01.31.08.56.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 31 Jan 2019 08:56:13 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 2/4] mt76x2u: remove mt76x2u_alloc_device routine
Date:   Thu, 31 Jan 2019 17:55:55 +0100
Message-Id: <5e7e75b428bb47f97b14cb81aa9f84778196dfd4.1548952312.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
References: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76x2u_alloc_device since it just runs mt76_alloc_device.
Move mt76_alloc_device call in mt76x2u_probe

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x2/mt76x2u.h   |  1 -
 .../net/wireless/mediatek/mt76/mt76x2/usb.c   | 24 ++++++++++++++-----
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  | 23 ------------------
 3 files changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
index 0b0075411b34..787cdfdf5db5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mt76x2u.h
@@ -29,7 +29,6 @@
 
 extern const struct ieee80211_ops mt76x2u_ops;
 
-struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev);
 int mt76x2u_register_device(struct mt76x02_dev *dev);
 int mt76x2u_init_hardware(struct mt76x02_dev *dev);
 void mt76x2u_cleanup(struct mt76x02_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index 4d1788eb3812..f81a85e96922 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -36,24 +36,36 @@ static const struct usb_device_id mt76x2u_device_table[] = {
 static int mt76x2u_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
+	static const struct mt76_driver_ops drv_ops = {
+		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
+		.tx_complete_skb = mt76x02u_tx_complete_skb,
+		.tx_status_data = mt76x02_tx_status_data,
+		.rx_skb = mt76x02_queue_rx_skb,
+		.sta_add = mt76x02_sta_add,
+		.sta_remove = mt76x02_sta_remove,
+	};
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct mt76x02_dev *dev;
+	struct mt76_dev *mdev;
 	int err;
 
-	dev = mt76x2u_alloc_device(&intf->dev);
-	if (!dev)
+	mdev = mt76_alloc_device(&intf->dev, sizeof(*dev), &mt76x2u_ops,
+				 &drv_ops);
+	if (!mdev)
 		return -ENOMEM;
 
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+
 	udev = usb_get_dev(udev);
 	usb_reset_device(udev);
 
-	mt76x02u_init_mcu(&dev->mt76);
-	err = mt76u_init(&dev->mt76, intf);
+	mt76x02u_init_mcu(mdev);
+	err = mt76u_init(mdev, intf);
 	if (err < 0)
 		goto err;
 
-	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
-	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
+	mdev->rev = mt76_rr(dev, MT_ASIC_VERSION);
+	dev_info(mdev->dev, "ASIC revision: %08x\n", mdev->rev);
 
 	err = mt76x2u_register_device(dev);
 	if (err < 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 523a308dd490..50b6bc55bf06 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -134,29 +134,6 @@ static int mt76x2u_init_eeprom(struct mt76x02_dev *dev)
 	return 0;
 }
 
-struct mt76x02_dev *mt76x2u_alloc_device(struct device *pdev)
-{
-	static const struct mt76_driver_ops drv_ops = {
-		.tx_prepare_skb = mt76x02u_tx_prepare_skb,
-		.tx_complete_skb = mt76x02u_tx_complete_skb,
-		.tx_status_data = mt76x02_tx_status_data,
-		.rx_skb = mt76x02_queue_rx_skb,
-		.sta_add = mt76x02_sta_add,
-		.sta_remove = mt76x02_sta_remove,
-	};
-	struct mt76x02_dev *dev;
-	struct mt76_dev *mdev;
-
-	mdev = mt76_alloc_device(pdev, sizeof(*dev), &mt76x2u_ops,
-				 &drv_ops);
-	if (!mdev)
-		return NULL;
-
-	dev = container_of(mdev, struct mt76x02_dev, mt76);
-
-	return dev;
-}
-
 int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 {
 	int i, k, err;
-- 
2.20.1

