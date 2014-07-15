Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59667 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbaGORok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2014 13:44:40 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so4827486wib.4
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jul 2014 10:44:39 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add support for BCM43217 found in Tenda W322E (14e4:43a9)
Date: Tue, 15 Jul 2014 19:44:28 +0200
Message-Id: <1405446268-6801-1-git-send-email-zajec5@gmail.com> (sfid-20140715_194443_652698_9164E20F)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c | 1 +
 drivers/bcma/host_pci.c              | 1 +
 drivers/bcma/sprom.c                 | 1 +
 include/linux/bcma/bcma.h            | 1 +
 4 files changed, 4 insertions(+)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 5081a8c..bb694e2 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -603,6 +603,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 		tmp = BCMA_CC_PMU_CTL_PLL_UPD | BCMA_CC_PMU_CTL_NOILPONW;
 		break;
 
+	case BCMA_CHIP_ID_BCM43217:
 	case BCMA_CHIP_ID_BCM43227:
 	case BCMA_CHIP_ID_BCM43228:
 	case BCMA_CHIP_ID_BCM43428:
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index e3333053..3cf725a 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -279,6 +279,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4358) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4365) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ 0, },
 };
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index a9dfb1a..97bb38e 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -534,6 +534,7 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
 		/* for these chips OTP is always available */
 		present = true;
 		break;
+	case BCMA_CHIP_ID_BCM43217:
 	case BCMA_CHIP_ID_BCM43227:
 	case BCMA_CHIP_ID_BCM43228:
 	case BCMA_CHIP_ID_BCM43428:
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 452286a..7cb2344 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -158,6 +158,7 @@ struct bcma_host_ops {
 /* Chip IDs of PCIe devices */
 #define BCMA_CHIP_ID_BCM4313	0x4313
 #define BCMA_CHIP_ID_BCM43142	43142
+#define BCMA_CHIP_ID_BCM43217	43217
 #define BCMA_CHIP_ID_BCM43224	43224
 #define  BCMA_PKG_ID_BCM43224_FAB_CSM	0x8
 #define  BCMA_PKG_ID_BCM43224_FAB_SMIC	0xa
-- 
1.8.4.5

