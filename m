Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33559 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbbILSLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:13 -0400
Received: by wiclk2 with SMTP id lk2so96488711wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:12 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 08/11] staging: vt6655: device_get_pci_info remove variable cis_addr.
Date: Sat, 12 Sep 2015 19:10:35 +0100
Message-Id: <1442081438-3485-8-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201129_048994_36B80A67)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cis_addr is never used remove its call to pci_resource_start.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1e660cc..17fa6aa 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -434,15 +434,12 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 				struct pci_dev *pcid)
 {
 	u8  b;
-	unsigned int cis_addr;
 
 	pci_set_master(pcid);
 
 	pDevice->memaddr = pci_resource_start(pcid, 0);
 	pDevice->ioaddr = pci_resource_start(pcid, 1);
 
-	cis_addr = pci_resource_start(pcid, 2);
-
 	pDevice->pcid = pcid;
 
 	pci_read_config_byte(pcid, PCI_COMMAND, &b);
-- 
2.5.0

