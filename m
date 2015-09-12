Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:34887 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753856AbbILSLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:14 -0400
Received: by wicge5 with SMTP id ge5so96624170wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:13 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/11] staging: vt6655: device_get_pci_info remove call to set master.
Date: Sat, 12 Sep 2015 19:10:36 +0100
Message-Id: <1442081438-3485-9-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201132_999762_EA386257)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

a call to PCI_COMMAND is used to set master.

However, a call to pci_set_master earlier in function which
does the same thing.

So remove the calls and variable b.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 17fa6aa..edda836 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -433,8 +433,6 @@ static void device_print_info(struct vnt_private *pDevice)
 static bool device_get_pci_info(struct vnt_private *pDevice,
 				struct pci_dev *pcid)
 {
-	u8  b;
-
 	pci_set_master(pcid);
 
 	pDevice->memaddr = pci_resource_start(pcid, 0);
@@ -442,9 +440,6 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 
 	pDevice->pcid = pcid;
 
-	pci_read_config_byte(pcid, PCI_COMMAND, &b);
-	pci_write_config_byte(pcid, PCI_COMMAND, (b|PCI_COMMAND_MASTER));
-
 	return true;
 }
 
-- 
2.5.0

