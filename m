Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68073C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39D41218AF
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 16:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388744AbfAaQ4T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 11:56:19 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52016 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388740AbfAaQ4S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 11:56:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so3277453wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 08:56:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=73ryWJdrEJe3ecJx0nWiluH1GAudk44db8VseE464AA=;
        b=UiYiE5r9YiwmA+7bH50VHj3v0XL51b77sSvhN/AT3xP/0WGKjUvnrEsaD4SzXv0agO
         OR+Cz3Eb86PEeMGEqcwWFWt1Xsu+Cq3cGMNs3gX63TyengkJw3iIYdEe/05gH92ZvPUA
         J70hPdcwAvQfvIljPoz/ohxJ4+8ZHkZyp1gc3kYQt9KZ/k0P/v79WPtS4pIwgjdyZ+gQ
         T5qPScnqUAS5HQDUYwXIlD0D/jVINuNj2F+u/Jp0pcg9o+kWj4mFwoP79tPSAUP8Is/2
         Iv16Z3jAxNVTGaymhoOsqAIpDVvriXNtvhpOg5q8pGi9DgnNiYpj/iEhePnxHsSJXIr5
         4QZA==
X-Gm-Message-State: AHQUAuYdTXOXk1r52Nf5Jlxr0rqYPTYqQXwValwgTEei+NfAUBsJsbhg
        oSfiVJiRJPrubd3rXjci9IYxVQ==
X-Google-Smtp-Source: ALg8bN6kr0UBUwq0U3LbzOBbMZT0xp5x4ZpzinuArtnh4T8xyfKlM6ptJLDEHniVlOTTxnv/T74XUA==
X-Received: by 2002:a1c:8acd:: with SMTP id m196mr30472054wmd.120.1548953775573;
        Thu, 31 Jan 2019 08:56:15 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id k128sm9502889wmd.37.2019.01.31.08.56.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 31 Jan 2019 08:56:15 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 3/4] mt76x0: remove mt76x0u_alloc_device routine
Date:   Thu, 31 Jan 2019 17:55:56 +0100
Message-Id: <8d22b8d1bf7820106d1edef3e3cdbc486976011c.1548952312.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
References: <cover.1548952312.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76x0u_alloc_device since it just runs mt76_alloc_device.
Move mt76_alloc_device call in mt76x0u_probe and in mt76x0e_probe

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 19 ----------------
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  4 ----
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 17 +++++++++-----
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 22 +++++++++++--------
 4 files changed, 24 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 34db3ec24e6e..820632e40c1b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -262,25 +262,6 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 }
 EXPORT_SYMBOL_GPL(mt76x0_init_hardware);
 
-struct mt76x02_dev *
-mt76x0_alloc_device(struct device *pdev,
-		    const struct mt76_driver_ops *drv_ops,
-		    const struct ieee80211_ops *ops)
-{
-	struct mt76x02_dev *dev;
-	struct mt76_dev *mdev;
-
-	mdev = mt76_alloc_device(pdev, sizeof(*dev), ops, drv_ops);
-	if (!mdev)
-		return NULL;
-
-	dev = container_of(mdev, struct mt76x02_dev, mt76);
-	mutex_init(&dev->phy_mutex);
-
-	return dev;
-}
-EXPORT_SYMBOL_GPL(mt76x0_alloc_device);
-
 int mt76x0_register_device(struct mt76x02_dev *dev)
 {
 	int ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 46629f61673b..51fbd75dff31 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -50,10 +50,6 @@ static inline bool is_mt7630(struct mt76x02_dev *dev)
 }
 
 /* Init */
-struct mt76x02_dev *
-mt76x0_alloc_device(struct device *pdev,
-		    const struct mt76_driver_ops *drv_ops,
-		    const struct ieee80211_ops *ops);
 int mt76x0_init_hardware(struct mt76x02_dev *dev);
 int mt76x0_register_device(struct mt76x02_dev *dev);
 void mt76x0_chip_onoff(struct mt76x02_dev *dev, bool enable, bool reset);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 1472c8699b29..0ba624d9d426 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -174,6 +174,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		.sta_remove = mt76x02_sta_remove,
 	};
 	struct mt76x02_dev *dev;
+	struct mt76_dev *mdev;
 	int ret;
 
 	ret = pcim_enable_device(pdev);
@@ -190,16 +191,20 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (ret)
 		return ret;
 
-	dev = mt76x0_alloc_device(&pdev->dev, &drv_ops, &mt76x0e_ops);
-	if (!dev)
+	mdev = mt76_alloc_device(&pdev->dev, sizeof(*dev), &mt76x0e_ops,
+				 &drv_ops);
+	if (!mdev)
 		return -ENOMEM;
 
-	mt76_mmio_init(&dev->mt76, pcim_iomap_table(pdev)[0]);
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+	mutex_init(&dev->phy_mutex);
 
-	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
-	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
+	mt76_mmio_init(mdev, pcim_iomap_table(pdev)[0]);
 
-	ret = devm_request_irq(dev->mt76.dev, pdev->irq, mt76x02_irq_handler,
+	mdev->rev = mt76_rr(dev, MT_ASIC_VERSION);
+	dev_info(mdev->dev, "ASIC revision: %08x\n", mdev->rev);
+
+	ret = devm_request_irq(mdev->dev, pdev->irq, mt76x02_irq_handler,
 			       IRQF_SHARED, KBUILD_MODNAME, dev);
 	if (ret)
 		goto error;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index f66e1b2f0980..06023513a113 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -223,14 +223,18 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	};
 	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
 	struct mt76x02_dev *dev;
+	struct mt76_dev *mdev;
 	u32 asic_rev, mac_rev;
 	int ret;
 
-	dev = mt76x0_alloc_device(&usb_intf->dev, &drv_ops,
-				  &mt76x0u_ops);
-	if (!dev)
+	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), &mt76x0u_ops,
+				 &drv_ops);
+	if (!mdev)
 		return -ENOMEM;
 
+	dev = container_of(mdev, struct mt76x02_dev, mt76);
+	mutex_init(&dev->phy_mutex);
+
 	/* Quirk for Archer T1U */
 	if (id->driver_info)
 		dev->no_2ghz = true;
@@ -240,27 +244,27 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 
 	usb_set_intfdata(usb_intf, dev);
 
-	mt76x02u_init_mcu(&dev->mt76);
-	ret = mt76u_init(&dev->mt76, usb_intf);
+	mt76x02u_init_mcu(mdev);
+	ret = mt76u_init(mdev, usb_intf);
 	if (ret)
 		goto err;
 
 	/* Disable the HW, otherwise MCU fail to initalize on hot reboot */
 	mt76x0_chip_onoff(dev, false, false);
 
-	if (!mt76x02_wait_for_mac(&dev->mt76)) {
+	if (!mt76x02_wait_for_mac(mdev)) {
 		ret = -ETIMEDOUT;
 		goto err;
 	}
 
 	asic_rev = mt76_rr(dev, MT_ASIC_VERSION);
 	mac_rev = mt76_rr(dev, MT_MAC_CSR0);
-	dev_info(dev->mt76.dev, "ASIC revision: %08x MAC revision: %08x\n",
+	dev_info(mdev->dev, "ASIC revision: %08x MAC revision: %08x\n",
 		 asic_rev, mac_rev);
 
 	/* Note: vendor driver skips this check for MT76X0U */
 	if (!(mt76_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
-		dev_warn(dev->mt76.dev, "Warning: eFUSE not present\n");
+		dev_warn(mdev->dev, "Warning: eFUSE not present\n");
 
 	ret = mt76x0u_register_device(dev);
 	if (ret < 0)
@@ -272,7 +276,7 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	usb_set_intfdata(usb_intf, NULL);
 	usb_put_dev(interface_to_usbdev(usb_intf));
 
-	ieee80211_free_hw(dev->mt76.hw);
+	ieee80211_free_hw(mdev->hw);
 	return ret;
 }
 
-- 
2.20.1

