Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38640 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbbILSLH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:07 -0400
Received: by wiclk2 with SMTP id lk2so89646947wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 01/11] staging: vt6655: vt6655_probe remove PCI debug info
Date: Sat, 12 Sep 2015 19:10:28 +0100
Message-Id: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201127_603989_5326E990)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove unnecessary debug PCI info that can be obtained
by lspci.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 46 ------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 86c24a1..2584d17 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1692,52 +1692,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-#ifdef	DEBUG
-	dev_dbg(&pcid->dev,
-		"after get pci_info memaddr is %x, io addr is %x,io_size is %d\n",
-		priv->memaddr, priv->ioaddr, priv->io_size);
-	{
-		int i;
-		u32 bar, len;
-		u32 address[] = {
-			PCI_BASE_ADDRESS_0,
-			PCI_BASE_ADDRESS_1,
-			PCI_BASE_ADDRESS_2,
-			PCI_BASE_ADDRESS_3,
-			PCI_BASE_ADDRESS_4,
-			PCI_BASE_ADDRESS_5,
-			0};
-		for (i = 0; address[i]; i++) {
-			pci_read_config_dword(pcid, address[i], &bar);
-
-			dev_dbg(&pcid->dev, "bar %d is %x\n", i, bar);
-
-			if (!bar) {
-				dev_dbg(&pcid->dev,
-					"bar %d not implemented\n", i);
-				continue;
-			}
-
-			if (bar & PCI_BASE_ADDRESS_SPACE_IO) {
-				/* This is IO */
-
-				len = bar & (PCI_BASE_ADDRESS_IO_MASK & 0xffff);
-				len = len & ~(len - 1);
-
-				dev_dbg(&pcid->dev,
-					"IO space:  len in IO %x, BAR %d\n",
-					len, i);
-			} else {
-				len = bar & 0xfffffff0;
-				len = ~len + 1;
-
-				dev_dbg(&pcid->dev,
-					"len in MEM %x, BAR %d\n", len, i);
-			}
-		}
-	}
-#endif
-
 	priv->PortOffset = ioremap(priv->memaddr & PCI_BASE_ADDRESS_MEM_MASK,
 				   priv->io_size);
 	if (!priv->PortOffset) {
-- 
2.5.0

