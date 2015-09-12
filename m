Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34825 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbbILSLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:07 -0400
Received: by wicge5 with SMTP id ge5so96621858wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:05 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/11] staging: vt6655: remove get_chip_name and info message.
Date: Sat, 12 Sep 2015 19:10:29 +0100
Message-Id: <1442081438-3485-2-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201127_011064_C1EE3EE7)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prints "VIA Networking Solomon-A/B/G Wireless LAN Adapter"
which has already printed once in vt6655_probe.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 2584d17..99191d9 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -168,16 +168,6 @@ static void device_free_rings(struct vnt_private *pDevice);
 
 /*---------------------  Export Functions  --------------------------*/
 
-static char *get_chip_name(int chip_id)
-{
-	int i;
-
-	for (i = 0; chip_info_table[i].name != NULL; i++)
-		if (chip_info_table[i].chip_id == chip_id)
-			break;
-	return chip_info_table[i].name;
-}
-
 static void vt6655_remove(struct pci_dev *pcid)
 {
 	struct vnt_private *pDevice = pci_get_drvdata(pcid);
@@ -447,8 +437,6 @@ static void device_init_registers(struct vnt_private *pDevice)
 
 static void device_print_info(struct vnt_private *pDevice)
 {
-	dev_info(&pDevice->pcid->dev, "%s\n", get_chip_name(pDevice->chip_id));
-
 	dev_info(&pDevice->pcid->dev, "MAC=%pM IO=0x%lx Mem=0x%lx IRQ=%d\n",
 		 pDevice->abyCurrentNetAddr, (unsigned long)pDevice->ioaddr,
 		 (unsigned long)pDevice->PortOffset, pDevice->pcid->irq);
-- 
2.5.0

