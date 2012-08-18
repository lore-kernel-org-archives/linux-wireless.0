Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63879 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2HRIM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Aug 2012 04:12:27 -0400
Received: by weyx8 with SMTP id x8so2909402wey.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Aug 2012 01:12:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: handle BCM43227
Date: Sat, 18 Aug 2012 10:12:35 +0200
Message-Id: <1345277555-13013-1-git-send-email-zajec5@gmail.com> (sfid-20120818_101315_356367_D9673E5B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Tested-by: Jack <x6719620@gmail.com>
---
 drivers/bcma/host_pci.c |    1 +
 drivers/bcma/sprom.c    |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index f7b0af7..b6b4b5e 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -273,6 +273,7 @@ static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4358) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) },
 	{ 0, },
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 9ea4627..0d546b6 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -507,7 +507,9 @@ static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
 		/* for these chips OTP is always available */
 		present = true;
 		break;
+	case BCMA_CHIP_ID_BCM43227:
 	case BCMA_CHIP_ID_BCM43228:
+	case BCMA_CHIP_ID_BCM43428:
 		present = chip_status & BCMA_CC_CHIPST_43228_OTP_PRESENT;
 		break;
 	default:
-- 
1.7.7

