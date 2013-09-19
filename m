Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39225 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab3ITLG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 07:06:57 -0400
In-Reply-To: <20130919212235.GD12758@n2100.arm.linux.org.uk>
References: <20130919212235.GD12758@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, b43-dev@lists.infradead.org,
	devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, e1000-devel@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-media@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-omap@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
	uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 45/51] DMA-API: firmware/google/gsmi.c: avoid direct access
 to DMA masks
Message-Id: <E1VMnTf-0007ss-9q@rmk-PC.arm.linux.org.uk> (sfid-20130920_130700_359934_7DF429D4)
Date: Fri, 20 Sep 2013 00:17:39 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver doesn't need to directly access DMA masks if it uses the
platform_device_register_full() API rather than
platform_device_register_simple() - the former function can initialize
the DMA mask appropriately.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/firmware/google/gsmi.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsmi.c
index 6eb535f..e5a67b2 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -764,6 +764,13 @@ static __init int gsmi_system_valid(void)
 static struct kobject *gsmi_kobj;
 static struct efivars efivars;
 
+static const struct platform_device_info gsmi_dev_info = {
+	.name		= "gsmi",
+	.id		= -1,
+	/* SMI callbacks require 32bit addresses */
+	.dma_mask	= DMA_BIT_MASK(32),
+};
+
 static __init int gsmi_init(void)
 {
 	unsigned long flags;
@@ -776,7 +783,7 @@ static __init int gsmi_init(void)
 	gsmi_dev.smi_cmd = acpi_gbl_FADT.smi_command;
 
 	/* register device */
-	gsmi_dev.pdev = platform_device_register_simple("gsmi", -1, NULL, 0);
+	gsmi_dev.pdev = platform_device_register_full(&gsmi_dev_info);
 	if (IS_ERR(gsmi_dev.pdev)) {
 		printk(KERN_ERR "gsmi: unable to register platform device\n");
 		return PTR_ERR(gsmi_dev.pdev);
@@ -785,10 +792,6 @@ static __init int gsmi_init(void)
 	/* SMI access needs to be serialized */
 	spin_lock_init(&gsmi_dev.lock);
 
-	/* SMI callbacks require 32bit addresses */
-	gsmi_dev.pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
-	gsmi_dev.pdev->dev.dma_mask =
-		&gsmi_dev.pdev->dev.coherent_dma_mask;
 	ret = -ENOMEM;
 	gsmi_dev.dma_pool = dma_pool_create("gsmi", &gsmi_dev.pdev->dev,
 					     GSMI_BUF_SIZE, GSMI_BUF_ALIGN, 0);
-- 
1.7.4.4

