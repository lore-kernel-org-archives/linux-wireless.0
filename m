Return-Path: <SRS0=/Gk3=PL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61D3C43387
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:34:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F462073D
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jan 2019 07:34:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fk6PI2uv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbfACHea (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:34:30 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40721 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbfACHea (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jan 2019 02:34:30 -0500
Received: by mail-lj1-f195.google.com with SMTP id n18-v6so28952831lji.7;
        Wed, 02 Jan 2019 23:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+bIv39C7rFrvwbW/wdIPTGOZJxiyH8atfwA9HpMUmiU=;
        b=Fk6PI2uvEVR7d/ieALWxz1nEq6ZHwrjQ+T8DPxdDpr8WURR86y0+WpZ4XGDvv+UroK
         MmPdD2N9481PEPl70WYcU85z9y6UTabgZf46qlRRdlJUNRGas7PPdjSZzMU7DWPJIrdy
         nBUJm9ZyJ0Dx2OoxvR15Go282VXToVCa1okOKP+7/p6HUyEZTdUAbZufJHyX2juWUIrV
         K/qkdNc3rLSauvaH0R4nSJd1rdSovK13kax383S4M1oR7GiMzrvmcbzDvL7rnZSSF4vr
         vB/IAwJ5ytCaXAwMrW2nc2WLh73BzyjKmmcac9mS52gryfwx08NyNeh6d1W6X5+IzOzH
         dguQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+bIv39C7rFrvwbW/wdIPTGOZJxiyH8atfwA9HpMUmiU=;
        b=T7APf5ZpMg9YJl5K1OdOeroMNzVJSlQlWaKTw8v3GApgbe6hoTQ3MuScAXQhVHFCcH
         JSzhVXJ5WcRXD57/3kvOGxldQg12cuJ+S3mQO07Ui9YuPENfsyHDE8q/exrSwPax6xP2
         CxzzkT8+ee68ERWG6yx/64cCDWcNu79Rhq0DoAvZ0B74k96JFSsdnwDldTm6ghe7C4Ic
         xjMGMW8ym6huT3jtCmxJ2sIQWF6AHLO4cGYfmPrSyZ7cKOckj0yz1ejBl7oChsYJqFYD
         GVip/wE6qgeiIVy6aVSDkZSzXkxgsClkhfZHyK/VO1q8OxuA+U3NrMqncDg8zmYrb3yO
         sQ4g==
X-Gm-Message-State: AJcUukeY+waFotZ1HBd6T0uax3dflRYRlC817qNMvxTu2mcdhbKIHfNt
        +AGZ5hIEH9GbvmrflXmh8dE=
X-Google-Smtp-Source: ALg8bN7r7TFo/Qhf1/ZL3zheo9ELlr4YxieKiiOjr+Kbb8ueK/XTF3MrYNWb6od7IBhZc/rdTl2L2A==
X-Received: by 2002:a2e:81d3:: with SMTP id s19-v6mr14650233ljg.138.1546500867282;
        Wed, 02 Jan 2019 23:34:27 -0800 (PST)
Received: from linux-veee.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id b21sm10488233lfi.7.2019.01.02.23.34.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 02 Jan 2019 23:34:26 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Paul Burton <paul.burton@mips.com>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 mips-fixes] MIPS: BCM47XX: Setup struct device for the SoC
Date:   Thu,  3 Jan 2019 08:34:17 +0100
Message-Id: <20190103073417.24135-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20190102125147.3282-1-zajec5@gmail.com>
References: <20190102125147.3282-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

So far we never had any device registered for the SoC. This resulted in
some small issues that we kept ignoring like:
1) Not working GPIOLIB_IRQCHIP (gpiochip_irqchip_add_key() failing)
2) Lack of proper tree in the /sys/devices/
3) mips_dma_alloc_coherent() silently handling empty coherent_dma_mask

Kernel 4.19 came with a lot of DMA changes and caused a regression on
bcm47xx. Starting with the commit f8c55dc6e828 ("MIPS: use generic dma
noncoherent ops for simple noncoherent platforms") DMA coherent
allocations just fail. Example:
[    1.114914] bgmac_bcma bcma0:2: Allocation of TX ring 0x200 failed
[    1.121215] bgmac_bcma bcma0:2: Unable to alloc memory for DMA
[    1.127626] bgmac_bcma: probe of bcma0:2 failed with error -12
[    1.133838] bgmac_bcma: Broadcom 47xx GBit MAC driver loaded

The bgmac driver also triggers a WARNING:
[    0.959486] ------------[ cut here ]------------
[    0.964387] WARNING: CPU: 0 PID: 1 at ./include/linux/dma-mapping.h:516 bgmac_enet_probe+0x1b4/0x5c4
[    0.973751] Modules linked in:
[    0.976913] CPU: 0 PID: 1 Comm: swapper Not tainted 4.19.9 #0
[    0.982750] Stack : 804a0000 804597c4 00000000 00000000 80458fd8 8381bc2c 838282d4 80481a47
[    0.991367]         8042e3ec 00000001 804d38f0 00000204 83980000 00000065 8381bbe0 6f55b24f
[    0.999975]         00000000 00000000 80520000 00002018 00000000 00000075 00000007 00000000
[    1.008583]         00000000 80480000 000ee811 00000000 00000000 00000000 80432c00 80248db8
[    1.017196]         00000009 00000204 83980000 803ad7b0 00000000 801feeec 00000000 804d0000
[    1.025804]         ...
[    1.028325] Call Trace:
[    1.030875] [<8000aef8>] show_stack+0x58/0x100
[    1.035513] [<8001f8b4>] __warn+0xe4/0x118
[    1.039708] [<8001f9a4>] warn_slowpath_null+0x48/0x64
[    1.044935] [<80248db8>] bgmac_enet_probe+0x1b4/0x5c4
[    1.050101] [<802498e0>] bgmac_probe+0x558/0x590
[    1.054906] [<80252fd0>] bcma_device_probe+0x38/0x70
[    1.060017] [<8020e1e8>] really_probe+0x170/0x2e8
[    1.064891] [<8020e714>] __driver_attach+0xa4/0xec
[    1.069784] [<8020c1e0>] bus_for_each_dev+0x58/0xb0
[    1.074833] [<8020d590>] bus_add_driver+0xf8/0x218
[    1.079731] [<8020ef24>] driver_register+0xcc/0x11c
[    1.084804] [<804b54cc>] bgmac_init+0x1c/0x44
[    1.089258] [<8000121c>] do_one_initcall+0x7c/0x1a0
[    1.094343] [<804a1d34>] kernel_init_freeable+0x150/0x218
[    1.099886] [<803a082c>] kernel_init+0x10/0x104
[    1.104583] [<80005878>] ret_from_kernel_thread+0x14/0x1c
[    1.110107] ---[ end trace f441c0d873d1fb5b ]---

This patch setups a "struct device" (and passes it to the bcma) which
allows fixing all the mentioned problems. It'll also require a tiny bcma
patch which will follow through the wireless tree & its maintainer.

Fixes: f8c55dc6e828 ("MIPS: use generic dma noncoherent ops for simple noncoherent platforms")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-wireless@vger.kernel.org
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
---
V2: Reorder struct bcma_soc fields (trivial optimization - thanks Hauke)
    Add pr_err on error
---
 arch/mips/bcm47xx/setup.c     | 31 +++++++++++++++++++++++++++++++
 include/linux/bcma/bcma_soc.h |  1 +
 2 files changed, 32 insertions(+)

diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 6054d49e608e..fe3773539eff 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -173,6 +173,31 @@ void __init plat_mem_setup(void)
 	pm_power_off = bcm47xx_machine_halt;
 }
 
+#ifdef CONFIG_BCM47XX_BCMA
+static struct device * __init bcm47xx_setup_device(void)
+{
+	struct device *dev;
+	int err;
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return NULL;
+
+	err = dev_set_name(dev, "bcm47xx_soc");
+	if (err) {
+		pr_err("Failed to set SoC device name: %d\n", err);
+		kfree(dev);
+		return NULL;
+	}
+
+	err = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (err)
+		pr_err("Failed to set SoC DMA mask: %d\n", err);
+
+	return dev;
+}
+#endif
+
 /*
  * This finishes bus initialization doing things that were not possible without
  * kmalloc. Make sure to call it late enough (after mm_init).
@@ -183,6 +208,10 @@ void __init bcm47xx_bus_setup(void)
 	if (bcm47xx_bus_type == BCM47XX_BUS_TYPE_BCMA) {
 		int err;
 
+		bcm47xx_bus.bcma.dev = bcm47xx_setup_device();
+		if (!bcm47xx_bus.bcma.dev)
+			panic("Failed to setup SoC device\n");
+
 		err = bcma_host_soc_init(&bcm47xx_bus.bcma);
 		if (err)
 			panic("Failed to initialize BCMA bus (err %d)", err);
@@ -235,6 +264,8 @@ static int __init bcm47xx_register_bus_complete(void)
 #endif
 #ifdef CONFIG_BCM47XX_BCMA
 	case BCM47XX_BUS_TYPE_BCMA:
+		if (device_register(bcm47xx_bus.bcma.dev))
+			pr_err("Failed to register SoC device\n");
 		bcma_bus_register(&bcm47xx_bus.bcma.bus);
 		break;
 #endif
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

