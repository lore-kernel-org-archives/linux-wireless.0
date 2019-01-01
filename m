Return-Path: <SRS0=Lfj+=PJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B2FC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jan 2019 23:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 111412073F
	for <linux-wireless@archiver.kernel.org>; Tue,  1 Jan 2019 23:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAc1hb4o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfAAXAU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 1 Jan 2019 18:00:20 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35360 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfAAXAU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Jan 2019 18:00:20 -0500
Received: by mail-lj1-f195.google.com with SMTP id x85-v6so25759396ljb.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jan 2019 15:00:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcoPzlis8iXqis1UJ1EhXh28sZXjp0LmqBGGUyL9vSA=;
        b=bAc1hb4oa9eduyiG9v3dUDp/hcNMIz44VbRRBabeZ0/yLkC7aMYbicJyCLbEGaNCjn
         lIxLpYZFttUFhdcbcRv+Ejds25wlNAWlj5W5c3y8uh9/BcZojPOb+AW6W+SJlJMPo7P/
         jxoCYjcJHYSNP0KrjeA4baRHosltr9OCNlUA0FUmmoCoLDZva5pBFuXbm4Hs608c50GD
         kF6aKO1ANSE76N1WSYipFmHZNiq9lHy68uEM98yE4VDDr6MR2MaT07zCcQzmWo0AP71K
         pjyIFDnoTKqkVr3CQHwQiBwG/3mv4TrwuqU6LH9GFNj3NyPPOMRKLFwQ7bfM1QpeOzWK
         kUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NcoPzlis8iXqis1UJ1EhXh28sZXjp0LmqBGGUyL9vSA=;
        b=iwtJeYjbaD2JiwzEpFbfKw8acgSv3On5m+WzLbzqBdwKgnJG8JENxlgZAv5P9Rwji+
         4LZOlhcz0MNxdW0Mn2cserVbvWQyqGiDwJ0qO6f3R5oBYeRabsFS+cuvdPr4yIAZxk/i
         GSryejuoS0aQolhGkYT6woTcZyRXP/mgCQWgfTPZtaSK556xiJ3htm9xW0VvhBg2vSdB
         a5YP1UVe0Cw4+M92nHCpQSZv1nrkBQvM2PciN5U1RDukHmTmzXwNd3rNNg9owK8y+p1R
         PKPn+4oU+a3qBstVKzhdjD+E4RXgbMb2y1rtEP3aos6q5ecUWRo+NVa9t+ZqwvQsgWHl
         ug2g==
X-Gm-Message-State: AJcUukdASZKAFfjAb54fZALldo3pM8J/fjBB4bxjuMIyMOIRpBq1Mt2i
        MC7pCMAuKFstltb8ExMrYMA=
X-Google-Smtp-Source: ALg8bN5JcQO0cZe4ZczFOlK3ggAG0kd02tOnBmaoeWFI9TZ0Es1vlWDFQ8T09VU78FtbWkl6d7BUXw==
X-Received: by 2002:a2e:9dcb:: with SMTP id x11-v6mr25882888ljj.158.1546383616955;
        Tue, 01 Jan 2019 15:00:16 -0800 (PST)
Received: from linux-veee.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e97-v6sm10994589lji.51.2019.01.01.15.00.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 01 Jan 2019 15:00:15 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 1/2] bcma: keep a direct pointer to the struct device
Date:   Wed,  2 Jan 2019 00:00:01 +0100
Message-Id: <20190101230002.18845-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.13.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Accessing struct device is pretty useful/common so having a direct
pointer:
1) Simplifies some code
2) Makes bcma_bus_get_host_dev() unneeded
3) Allows further improvements like using dev_* printing helpers

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/bcma/bcma_private.h |  1 -
 drivers/bcma/driver_gpio.c  |  2 +-
 drivers/bcma/host_pci.c     |  2 ++
 drivers/bcma/host_soc.c     |  4 ++--
 drivers/bcma/main.c         | 45 +++++++++----------------------------
 include/linux/bcma/bcma.h   | 11 +++------
 6 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index a4aac370f21f..1f0e66310b23 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -33,7 +33,6 @@ int __init bcma_bus_early_register(struct bcma_bus *bus);
 int bcma_bus_suspend(struct bcma_bus *bus);
 int bcma_bus_resume(struct bcma_bus *bus);
 #endif
-struct device *bcma_bus_get_host_dev(struct bcma_bus *bus);
 
 /* scan.c */
 void bcma_detect_chip(struct bcma_bus *bus);
diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
index 2c0ffb77d738..a5df3d111334 100644
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@ -183,7 +183,7 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
 	chip->direction_input	= bcma_gpio_direction_input;
 	chip->direction_output	= bcma_gpio_direction_output;
 	chip->owner		= THIS_MODULE;
-	chip->parent		= bcma_bus_get_host_dev(bus);
+	chip->parent		= bus->dev;
 #if IS_BUILTIN(CONFIG_OF)
 	chip->of_node		= cc->core->dev.of_node;
 #endif
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 63410ecfe640..f52239feb4cb 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -196,6 +196,8 @@ static int bcma_host_pci_probe(struct pci_dev *dev,
 		goto err_pci_release_regions;
 	}
 
+	bus->dev = &dev->dev;
+
 	/* Map MMIO */
 	err = -ENOMEM;
 	bus->mmio = pci_iomap(dev, 0, ~0UL);
diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index 2dce34789329..c8073b509a2b 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -179,7 +179,6 @@ int __init bcma_host_soc_register(struct bcma_soc *soc)
 	/* Host specific */
 	bus->hosttype = BCMA_HOSTTYPE_SOC;
 	bus->ops = &bcma_host_soc_ops;
-	bus->host_pdev = NULL;
 
 	/* Initialize struct, detect chip */
 	bcma_init_bus(bus);
@@ -213,6 +212,8 @@ static int bcma_host_soc_probe(struct platform_device *pdev)
 	if (!bus)
 		return -ENOMEM;
 
+	bus->dev = dev;
+
 	/* Map MMIO */
 	bus->mmio = of_iomap(np, 0);
 	if (!bus->mmio)
@@ -221,7 +222,6 @@ static int bcma_host_soc_probe(struct platform_device *pdev)
 	/* Host specific */
 	bus->hosttype = BCMA_HOSTTYPE_SOC;
 	bus->ops = &bcma_host_soc_ops;
-	bus->host_pdev = pdev;
 
 	/* Initialize struct, detect chip */
 	bcma_init_bus(bus);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index fc1f4acdd189..6535614a7dc1 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -223,8 +223,8 @@ unsigned int bcma_core_irq(struct bcma_device *core, int num)
 			mips_irq = bcma_core_mips_irq(core);
 			return mips_irq <= 4 ? mips_irq + 2 : 0;
 		}
-		if (bus->host_pdev)
-			return bcma_of_get_irq(&bus->host_pdev->dev, core, num);
+		if (bus->dev)
+			return bcma_of_get_irq(bus->dev, core, num);
 		return 0;
 	case BCMA_HOSTTYPE_SDIO:
 		return 0;
@@ -239,18 +239,18 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
-	core->dev.parent = bcma_bus_get_host_dev(bus);
-	if (core->dev.parent)
-		bcma_of_fill_device(core->dev.parent, core);
+	core->dev.parent = bus->dev;
+	if (bus->dev)
+		bcma_of_fill_device(bus->dev, core);
 
 	switch (bus->hosttype) {
 	case BCMA_HOSTTYPE_PCI:
-		core->dma_dev = &bus->host_pci->dev;
+		core->dma_dev = bus->dev;
 		core->irq = bus->host_pci->irq;
 		break;
 	case BCMA_HOSTTYPE_SOC:
-		if (IS_ENABLED(CONFIG_OF) && bus->host_pdev) {
-			core->dma_dev = &bus->host_pdev->dev;
+		if (IS_ENABLED(CONFIG_OF) && bus->dev) {
+			core->dma_dev = bus->dev;
 		} else {
 			core->dev.dma_mask = &core->dev.coherent_dma_mask;
 			core->dma_dev = &core->dev;
@@ -261,28 +261,6 @@ void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 	}
 }
 
-struct device *bcma_bus_get_host_dev(struct bcma_bus *bus)
-{
-	switch (bus->hosttype) {
-	case BCMA_HOSTTYPE_PCI:
-		if (bus->host_pci)
-			return &bus->host_pci->dev;
-		else
-			return NULL;
-	case BCMA_HOSTTYPE_SOC:
-		if (bus->host_pdev)
-			return &bus->host_pdev->dev;
-		else
-			return NULL;
-	case BCMA_HOSTTYPE_SDIO:
-		if (bus->host_sdio)
-			return &bus->host_sdio->dev;
-		else
-			return NULL;
-	}
-	return NULL;
-}
-
 void bcma_init_bus(struct bcma_bus *bus)
 {
 	mutex_lock(&bcma_buses_mutex);
@@ -402,7 +380,6 @@ int bcma_bus_register(struct bcma_bus *bus)
 {
 	int err;
 	struct bcma_device *core;
-	struct device *dev;
 
 	/* Scan for devices (cores) */
 	err = bcma_bus_scan(bus);
@@ -425,10 +402,8 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_early_init(&bus->drv_pci[0]);
 	}
 
-	dev = bcma_bus_get_host_dev(bus);
-	if (dev) {
-		of_platform_default_populate(dev->of_node, NULL, dev);
-	}
+	if (bus->dev)
+		of_platform_default_populate(bus->dev->of_node, NULL, bus->dev);
 
 	/* Cores providing flash access go before SPROM init */
 	list_for_each_entry(core, &bus->cores, list) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index ef61f3607e99..60b94b944e9f 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -332,6 +332,8 @@ extern int bcma_arch_register_fallback_sprom(
 		struct ssb_sprom *out));
 
 struct bcma_bus {
+	struct device *dev;
+
 	/* The MMIO area. */
 	void __iomem *mmio;
 
@@ -339,14 +341,7 @@ struct bcma_bus {
 
 	enum bcma_hosttype hosttype;
 	bool host_is_pcie2; /* Used for BCMA_HOSTTYPE_PCI only */
-	union {
-		/* Pointer to the PCI bus (only for BCMA_HOSTTYPE_PCI) */
-		struct pci_dev *host_pci;
-		/* Pointer to the SDIO device (only for BCMA_HOSTTYPE_SDIO) */
-		struct sdio_func *host_sdio;
-		/* Pointer to platform device (only for BCMA_HOSTTYPE_SOC) */
-		struct platform_device *host_pdev;
-	};
+	struct pci_dev *host_pci; /* PCI bus pointer (BCMA_HOSTTYPE_PCI only) */
 
 	struct bcma_chipinfo chipinfo;
 
-- 
2.20.1

