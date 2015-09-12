Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33551 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbbILSLM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:12 -0400
Received: by wiclk2 with SMTP id lk2so96488439wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:11 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 07/11] staging: vt6655: device_get_pci_info remove unused pci_read_config_*
Date: Sat, 12 Sep 2015 19:10:34 +0100
Message-Id: <1442081438-3485-7-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201137_748744_ABB24F92)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These values are read from pci but never used.

Removing variables byRevId, SubSystemID, SubVendorID and pci_cmd.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 3 ---
 drivers/staging/vt6655/device_main.c | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index f020bb1..271a719 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -231,10 +231,7 @@ struct vnt_private {
 	u32                         memaddr;
 	u32                         ioaddr;
 
-	unsigned char byRevId;
 	unsigned char byRxMode;
-	unsigned short SubSystemID;
-	unsigned short SubVendorID;
 
 	spinlock_t                  lock;
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ce2df37..1e660cc 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -230,9 +230,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 	pDevice->byTopOFDMBasicRate = RATE_24M;
 	pDevice->byTopCCKBasicRate = RATE_1M;
 
-	/* Target to IF pin while programming to RF chip. */
-	pDevice->byRevId = 0;
-
 	/* init MAC */
 	MACvInitialize(pDevice->PortOffset);
 
@@ -436,15 +433,9 @@ static void device_print_info(struct vnt_private *pDevice)
 static bool device_get_pci_info(struct vnt_private *pDevice,
 				struct pci_dev *pcid)
 {
-	u16 pci_cmd;
 	u8  b;
 	unsigned int cis_addr;
 
-	pci_read_config_byte(pcid, PCI_REVISION_ID, &pDevice->byRevId);
-	pci_read_config_word(pcid, PCI_SUBSYSTEM_ID, &pDevice->SubSystemID);
-	pci_read_config_word(pcid, PCI_SUBSYSTEM_VENDOR_ID, &pDevice->SubVendorID);
-	pci_read_config_word(pcid, PCI_COMMAND, (u16 *)&(pci_cmd));
-
 	pci_set_master(pcid);
 
 	pDevice->memaddr = pci_resource_start(pcid, 0);
-- 
2.5.0

