Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42583 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756670Ab1FQKhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 06:37:11 -0400
Received: by ewy4 with SMTP id 4so459904ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 03:37:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: enable support for 14e4:4357 (BCM43225)
Date: Fri, 17 Jun 2011 13:15:23 +0200
Message-Id: <1308309324-8680-1-git-send-email-zajec5@gmail.com> (sfid-20110617_123719_508703_88C3E8F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c |    4 ++++
 drivers/bcma/host_pci.c              |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index f44177a..934b7ed 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -53,6 +53,7 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 		max_msk = 0xFFFF;
 		break;
 	case 43224:
+	case 43225:
 		break;
 	default:
 		pr_err("PMU resource config unknown for device 0x%04X\n",
@@ -74,6 +75,7 @@ void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
 	case 0x4313:
 	case 0x4331:
 	case 43224:
+	case 43225:
 		break;
 	default:
 		pr_err("PMU switch/regulators init unknown for device "
@@ -101,6 +103,8 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 			bcma_chipco_chipctl_maskset(cc, 0, ~0, 0xF0);
 		}
 		break;
+	case 43225:
+		break;
 	default:
 		pr_err("Workarounds unknown for device 0x%04X\n",
 			bus->chipinfo.id);
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 2a526bc..ac4bc62 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -227,6 +227,7 @@ static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ 0, },
 };
-- 
1.7.3.4

