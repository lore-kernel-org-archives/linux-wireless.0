Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:38505 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3EITYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 15:24:53 -0400
Received: by mail-ee0-f48.google.com with SMTP id c4so1331684eek.21
        for <linux-wireless@vger.kernel.org>; Thu, 09 May 2013 12:24:52 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add more core IDs
Date: Thu,  9 May 2013 21:24:24 +0200
Message-Id: <1368127464-11448-1-git-send-email-zajec5@gmail.com> (sfid-20130509_212523_030863_B8195615)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCIe and ARM CR4 cores were found on 14e4:43b1 AKA BCM4352.

Reported-by: Gabriel Thörnblad <gabriel@thornblad.com>
Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c       |    2 ++
 include/linux/bcma/bcma.h |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index bca9c80..8bffa5c 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -84,6 +84,8 @@ static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_I2S, "I2S" },
 	{ BCMA_CORE_SDR_DDR1_MEM_CTL, "SDR/DDR1 Memory Controller" },
 	{ BCMA_CORE_SHIM, "SHIM" },
+	{ BCMA_CORE_PCIE2, "PCIe Gen2" },
+	{ BCMA_CORE_ARM_CR4, "ARM CR4" },
 	{ BCMA_CORE_DEFAULT, "Default" },
 };
 
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index f14a98a..2e34db8 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -134,7 +134,10 @@ struct bcma_host_ops {
 #define BCMA_CORE_I2S			0x834
 #define BCMA_CORE_SDR_DDR1_MEM_CTL	0x835	/* SDR/DDR1 memory controller core */
 #define BCMA_CORE_SHIM			0x837	/* SHIM component in ubus/6362 */
-#define BCMA_CORE_ARM_CR4		0x83e
+#define BCMA_CORE_PHY_AC		0x83B
+#define BCMA_CORE_PCIE2			0x83C	/* PCI Express Gen2 */
+#define BCMA_CORE_USB30_DEV		0x83D
+#define BCMA_CORE_ARM_CR4		0x83E
 #define BCMA_CORE_DEFAULT		0xFFF
 
 #define BCMA_MAX_NR_CORES		16
-- 
1.7.10.4

