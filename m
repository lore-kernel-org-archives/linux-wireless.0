Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA8C282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 10:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0FF52085A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 10:11:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCbCrKoC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfAUKLj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 05:11:39 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:40227 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbfAUKLj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 05:11:39 -0500
Received: by mail-lj1-f196.google.com with SMTP id n18-v6so16996874lji.7
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jan 2019 02:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7bsaY3TzQjf47B9lLjDRCKxEkIvRvluc34tmMZCk4TY=;
        b=TCbCrKoCE/GGKsKmLU4OoCgswVn7eUxD/fZTgLpZm/4z5FEgVjGvf2Fh8UWmxwYVNG
         2WWlSGyGZz3ICJgccocKFbqaiSuyzcngkvdvzrqI20SvLwVmxzumcOU5Qn0b5tzU0VIk
         bO8hzjjQtvBt67MiS38QHD2OjX2LMd/OMr0hv51hSX5Gzw/vVrGM6t0GWM23Tx8T0eSI
         Do5pv1VoBsv0mXl4q73XXl1OvPqV0aC8yMgmfhddq+VZsMg+EejYheHOHCMJ3AuXVAHl
         Y7AfR58sGMl4By+smyiziZBq8BB+QNv1KuUGt2fympNZ8ZQmGQ/mUI5uKKbIaOdvkWF6
         i8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7bsaY3TzQjf47B9lLjDRCKxEkIvRvluc34tmMZCk4TY=;
        b=rX+JwwzQmW3bdNkfJSVwD90mkVPGurSWi5iXC9NrDhosnGSwtdM/RlvEhiyo06BHgN
         qrLzLBoc3eVzzX0e4YEhLIMvf4QvQ/J6Ch1Ba+7/fHGB/Gn5BxwL8xBBLhss55TeFXtI
         ZgUK7ZEeEmxuO+pJ+fy60TA2pMYTudpPOmz+zLPDUcbDzGTmDGud45Kqb41l+dpLyADP
         tbahgX4ZB3DSyNdO/X4NNoFrT/4uysbkTSvE3Kj5I6BmwzK/yzsuL1pIDuS5m4ZCHBsu
         krQG9BPjnZuGwimAFXvVfGXAQiAlVxr0YtsOHtCc3l4HMryMDghDG+6k6ANbtAEtQ3P1
         uXGA==
X-Gm-Message-State: AJcUukff/Fi9wxHXCOn+/z1D6pGj0p1ztW6a+IH7dCVKzTYYzFj+8OAc
        KKLxQXcmJ7jkvgrZUjZ+4kQ=
X-Google-Smtp-Source: ALg8bN4a77u6vkXc6aip1et0ydstjIynoanE34z3b6UyXvnuZU92yEn9HYhSMorXRKC6x5NDwhpzug==
X-Received: by 2002:a2e:9783:: with SMTP id y3-v6mr17128317lji.167.1548065496273;
        Mon, 21 Jan 2019 02:11:36 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id k20sm2208164lfe.3.2019.01.21.02.11.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 21 Jan 2019 02:11:35 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-mips@linux-mips.org, Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH wireless-drivers-next] bcma: get SoC device struct & copy its DMA params to the subdevices
Date:   Mon, 21 Jan 2019 11:11:21 +0100
Message-Id: <20190121101121.24555-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

For bus devices to be fully usable it's required to set their DMA
parameters.

For years it has been missing and remained unnoticed because of
mips_dma_alloc_coherent() silently handling the empty coherent_dma_mask.
Kernel 4.19 came with a lot of DMA changes and caused a regression on
the bcm47xx. Starting with the commit f8c55dc6e828 ("MIPS: use generic
dma noncoherent ops for simple noncoherent platforms") DMA coherent
allocations just fail. Example:
[    1.114914] bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
[    1.121215] bgmac_bcma bcma0:2: Unable to alloc memory for DMA
[    1.127626] bgmac_bcma: probe of bcma0:2 failed with error -12
[    1.133838] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded

This change fixes above regression in addition to the MIPS bcm47xx
commit 321c46b91550 ("MIPS: BCM47XX: Setup struct device for the SoC").

It also fixes another *old* GPIO regression caused by a parent pointing
to the NULL:
[    0.157054] missing gpiochip .dev parent pointer
[    0.157287] bcma: bus0: Error registering GPIO driver: -22
introduced by the commit 74f4e0cc6108 ("bcma: switch GPIO portions to
use GPIOLIB_IRQCHIP").

Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple noncoherent platforms")
Fixes: 74f4e0cc6108 ("bcma: switch GPIO portions to use GPIOLIB_IRQCHIP")
Cc: linux-mips@linux-mips.org
Cc: Christoph Hellwig <hch@lst.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
While this patch is a regression fix, it depends on a change present in
the wireless-drivers-next.git:
bcma: keep a direct pointer to the struct device

That's why I suggest pushing it into the wireless-drivers-next.git and I
can take care of picking it for the stable@kernel.org later.

Another option would be cherry-picking commit 5a1c18b761dd ("bcma: keep
a direct pointer to the struct device") to the wireless-drivers.git but
I don't think it's a common practice.
---
 drivers/bcma/host_soc.c       | 2 ++
 drivers/bcma/main.c           | 6 +++++-
 include/linux/bcma/bcma_soc.h | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/host_soc.c b/drivers/bcma/host_soc.c
index c8073b509a2b..1fdfb704f22d 100644
--- a/drivers/bcma/host_soc.c
+++ b/drivers/bcma/host_soc.c
@@ -191,6 +191,8 @@ int __init bcma_host_soc_init(struct bcma_soc *soc)
 	struct bcma_bus *bus = &soc->bus;
 	int err;
 
+	bus->dev = soc->dev;
+
 	/* Scan bus and initialize it */
 	err = bcma_bus_early_register(bus);
 	if (err)
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 6535614a7dc1..433ca5e2ed2c 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -236,12 +236,16 @@ EXPORT_SYMBOL(bcma_core_irq);
 
 void bcma_prepare_core(struct bcma_bus *bus, struct bcma_device *core)
 {
+	struct device *dev = &core->dev;
+
 	core->dev.release = bcma_release_core_dev;
 	core->dev.bus = &bcma_bus_type;
 	dev_set_name(&core->dev, "bcma%d:%d", bus->num, core->core_index);
 	core->dev.parent = bus->dev;
-	if (bus->dev)
+	if (bus->dev) {
 		bcma_of_fill_device(bus->dev, core);
+		dma_coerce_mask_and_coherent(dev, bus->dev->coherent_dma_mask);
+	}
 
 	switch (bus->hosttype) {
 	case BCMA_HOSTTYPE_PCI:
diff --git a/include/linux/bcma/bcma_soc.h b/include/linux/bcma/bcma_soc.h
index 7cca5f859a90..f3c43519baa7 100644
--- a/include/linux/bcma/bcma_soc.h
+++ b/include/linux/bcma/bcma_soc.h
@@ -6,6 +6,7 @@
 
 struct bcma_soc {
 	struct bcma_bus bus;
+	struct device *dev;
 };
 
 int __init bcma_host_soc_register(struct bcma_soc *soc);
-- 
2.20.1

