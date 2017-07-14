Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34628 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752742AbdGNCOK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Jul 2017 22:14:10 -0400
Received: by mail-pg0-f65.google.com with SMTP id j186so8849305pge.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Jul 2017 19:14:09 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com, Rosen Penev <rosenp@gmail.com>
Subject: [PATCH] ath9k: Add Dell Wireless 1802 with wowlan capability
Date: Thu, 13 Jul 2017 19:10:30 -0700
Message-Id: <20170714021030.9828-1-rosenp@gmail.com> (sfid-20170714_041413_909071_B568E84C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the Dell Wireless 1802 card as an AR9462 in the ath9k pci list.
Note that the wowlan feature is supported and has been tested
successfully.

Signed-off by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7b7627f85d3a..223606311261 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -388,6 +388,11 @@ static const struct pci_device_id ath_pci_id_table[] = {
 			 PCI_VENDOR_ID_DELL,
 			 0x020B),
 	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_DELL,
+			 0x0300),
+	  .driver_data = ATH9K_PCI_WOW },
 
 	/* Killer Wireless (2x2) */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
-- 
2.13.0
