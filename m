Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381C7C2F3A0
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:18:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07DB120861
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 14:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548080325;
	bh=qJXL7sJxZPhAnZRB4U+qRwKgUuEW7UP68hZuMgxb+KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LAj9o+N8FdZMR0/ZeTXy5WsZSWYBJZW9IRVlETfOGf4n8xAW+McM3Dm3wFc3kEIOa
	 MJoH5cq3fA6Zkmv/5MPx19E85fqCwA4zNvpRhHV1YMNfK41Uv9J4N9bDiBTa+B8JT0
	 jFEDIuRj3mEg0tNivbP7vtXk9nKCyMyx8JcbylY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730232AbfAUNt0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 08:49:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:59972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbfAUNtZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 08:49:25 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8473920861;
        Mon, 21 Jan 2019 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548078564;
        bh=qJXL7sJxZPhAnZRB4U+qRwKgUuEW7UP68hZuMgxb+KQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TK+SI6CYAqtJMA7NxVUxocKZbKAMB7EmrETUKPxqeCUb+aWDe8A/Hs9fPKpIrLc6g
         255CtIlNK6zxEWgWv7MtmMfvIesveUJLJlrUc1DpOU+xRv1IuGzV771yXs1O5BwTk8
         zJLVI+rFXMzkQRRZqI83znO5D0EED19q2OoFEc+c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Paul Burton <paul.burton@mips.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Christoph Hellwig <hch@lst.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-wireless@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org
Subject: [PATCH 4.20 049/111] MIPS: BCM47XX: Setup struct device for the SoC
Date:   Mon, 21 Jan 2019 14:42:43 +0100
Message-Id: <20190121122501.362663107@linuxfoundation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190121122455.819406896@linuxfoundation.org>
References: <20190121122455.819406896@linuxfoundation.org>
User-Agent: quilt/0.65
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

4.20-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

commit 321c46b91550adc03054125fa7a1639390608e1a upstream.

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
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-wireless@vger.kernel.org
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/bcm47xx/setup.c     |   31 +++++++++++++++++++++++++++++++
 include/linux/bcma/bcma_soc.h |    1 +
 2 files changed, 32 insertions(+)

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
@@ -235,6 +264,8 @@ static int __init bcm47xx_register_bus_c
 #endif
 #ifdef CONFIG_BCM47XX_BCMA
 	case BCM47XX_BUS_TYPE_BCMA:
+		if (device_register(bcm47xx_bus.bcma.dev))
+			pr_err("Failed to register SoC device\n");
 		bcma_bus_register(&bcm47xx_bus.bcma.bus);
 		break;
 #endif
--- a/include/linux/bcma/bcma_soc.h
+++ b/include/linux/bcma/bcma_soc.h
@@ -6,6 +6,7 @@
 
 struct bcma_soc {
 	struct bcma_bus bus;
+	struct device *dev;
 };
 
 int __init bcma_host_soc_register(struct bcma_soc *soc);


