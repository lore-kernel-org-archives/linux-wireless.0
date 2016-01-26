Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:34222 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964834AbcAZQCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 11:02:22 -0500
Received: by mail-lf0-f41.google.com with SMTP id 17so107979756lfz.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jan 2016 08:02:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: claim only 14e4:4365 PCI Dell card with SoftMAC BCM43142
Date: Tue, 26 Jan 2016 17:02:09 +0100
Message-Id: <1453824129-9645-1-git-send-email-zajec5@gmail.com> (sfid-20160126_170226_169967_75ED25B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems 14e4:4365 pattern is too generic as there are two devices:
1) 14e4:4365 1028:0016 with SoftMAC BCM43142 chipset
2) 14e4:4365 14e4:4365 with FullMAC BCM4366 chipset
The later one was found in D-Link DIR-885L router and we want to let
brcmfmac handle it.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/host_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 0856189..cae5385 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -294,7 +294,7 @@ static const struct pci_device_id bcma_pci_bridge_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4358) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4359) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4360) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4365) },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_BROADCOM, 0x4365, PCI_VENDOR_ID_DELL, 0x0016) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43a9) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x43aa) },
-- 
1.8.4.5

