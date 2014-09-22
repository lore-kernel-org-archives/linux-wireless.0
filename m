Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36639 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaIVU2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 16:28:23 -0400
Received: by mail-wg0-f51.google.com with SMTP id m15so3322224wgh.22
        for <linux-wireless@vger.kernel.org>; Mon, 22 Sep 2014 13:28:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: vt6655: device_get_options remove unused variable devname
Date: Mon, 22 Sep 2014 21:27:47 +0100
Message-Id: <1411417667-9191-2-git-send-email-tvboxspy@gmail.com> (sfid-20140922_222826_552636_73691D0B)
In-Reply-To: <1411417667-9191-1-git-send-email-tvboxspy@gmail.com>
References: <1411417667-9191-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1a1440f..76d5454 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -331,8 +331,7 @@ static void vt6655_remove(struct pci_dev *pcid)
 	device_free_info(pDevice);
 }
 
-static void device_get_options(struct vnt_private *pDevice,
-			       char *devname)
+static void device_get_options(struct vnt_private *pDevice)
 {
 	POPTIONS pOpts = &(pDevice->sOpts);
 
@@ -923,7 +922,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	MACvInitialize(pDevice->PortOffset);
 	MACvReadEtherAddress(pDevice->PortOffset, dev->dev_addr);
 
-	device_get_options(pDevice, dev->name);
+	device_get_options(pDevice);
 	device_set_options(pDevice);
 	//Mask out the options cannot be set to the chip
 	pDevice->sOpts.flags &= pChip_info->flags;
-- 
1.9.1

