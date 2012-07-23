Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34729 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab2GWPgH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 11:36:07 -0400
Received: by weyx8 with SMTP id x8so4347016wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 08:36:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: BCM43228 support
Date: Mon, 23 Jul 2012 18:20:12 +0200
Message-Id: <1343060412-6793-1-git-send-email-zajec5@gmail.com> (sfid-20120723_173612_616819_B56FA0FA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/host_pci.c                     |    1 +
 drivers/bcma/sprom.c                        |    4 +++-
 include/linux/bcma/bcma_driver_chipcommon.h |    6 ++++++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 11b32d2..a6e5672 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -272,6 +272,7 @@ static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ 0, },
 };
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 26823d9..9ea4627 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -507,7 +507,9 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
 		/* for these chips OTP is always available */
 		present = true;
 		break;
-
+	case BCMA_CHIP_ID_BCM43228:
+		present = chip_status & BCMA_CC_CHIPST_43228_OTP_PRESENT;
+		break;
 	default:
 		present = false;
 		break;
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 3c80885..d323a4b 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -89,6 +89,12 @@
 #define  BCMA_CC_CHIPST_4313_OTP_PRESENT	2
 #define  BCMA_CC_CHIPST_4331_SPROM_PRESENT	2
 #define  BCMA_CC_CHIPST_4331_OTP_PRESENT	4
+#define  BCMA_CC_CHIPST_43228_ILP_DIV_EN	0x00000001
+#define  BCMA_CC_CHIPST_43228_OTP_PRESENT	0x00000002
+#define  BCMA_CC_CHIPST_43228_SERDES_REFCLK_PADSEL	0x00000004
+#define  BCMA_CC_CHIPST_43228_SDIO_MODE		0x00000008
+#define  BCMA_CC_CHIPST_43228_SDIO_OTP_PRESENT	0x00000010
+#define  BCMA_CC_CHIPST_43228_SDIO_RESET	0x00000020
 #define  BCMA_CC_CHIPST_4706_PKG_OPTION		BIT(0) /* 0: full-featured package 1: low-cost package */
 #define  BCMA_CC_CHIPST_4706_SFLASH_PRESENT	BIT(1) /* 0: parallel, 1: serial flash is present */
 #define  BCMA_CC_CHIPST_4706_SFLASH_TYPE	BIT(2) /* 0: 8b-p/ST-s flash, 1: 16b-p/Atmal-s flash */
-- 
1.7.7

