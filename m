Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33667 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbcAOXtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 18:49:03 -0500
Received: by mail-lb0-f182.google.com with SMTP id x4so66539595lbm.0
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2016 15:49:02 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: identify bus cores (devices) found on BCM47189
Date: Sat, 16 Jan 2016 00:48:52 +0100
Message-Id: <1452901733-22271-1-git-send-email-zajec5@gmail.com> (sfid-20160116_004906_798516_6B5DE91E)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add missing defines and print proper names.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c       | 3 +++
 include/linux/bcma/bcma.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index df806b9..5ee7311 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -98,6 +98,9 @@ static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_SHIM, "SHIM" },
 	{ BCMA_CORE_PCIE2, "PCIe Gen2" },
 	{ BCMA_CORE_ARM_CR4, "ARM CR4" },
+	{ BCMA_CORE_GCI, "GCI" },
+	{ BCMA_CORE_CMEM, "CNDS DDR2/3 memory controller" },
+	{ BCMA_CORE_ARM_CA7, "ARM CA7" },
 	{ BCMA_CORE_DEFAULT, "Default" },
 };
 
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 3feb1b2..991ebb4 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -151,6 +151,8 @@ struct bcma_host_ops {
 #define BCMA_CORE_PCIE2			0x83C	/* PCI Express Gen2 */
 #define BCMA_CORE_USB30_DEV		0x83D
 #define BCMA_CORE_ARM_CR4		0x83E
+#define BCMA_CORE_GCI			0x840
+#define BCMA_CORE_CMEM			0x846	/* CNDS DDR2/3 memory controller */
 #define BCMA_CORE_ARM_CA7		0x847
 #define BCMA_CORE_SYS_MEM		0x849
 #define BCMA_CORE_DEFAULT		0xFFF
-- 
1.8.4.5

