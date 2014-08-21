Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65417 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaHUUlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 16:41:50 -0400
Received: by mail-wg0-f48.google.com with SMTP id x13so9625040wgg.31
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2014 13:41:49 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3/3] staging: vt6655: dead code remove device_nics variable
Date: Thu, 21 Aug 2014 21:40:50 +0100
Message-Id: <1408653650-9049-3-git-send-email-tvboxspy@gmail.com> (sfid-20140821_224154_488377_68516A97)
In-Reply-To: <1408653650-9049-1-git-send-email-tvboxspy@gmail.com>
References: <1408653650-9049-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The module can not load more than once.

Remove device_nics, MAX_UINTS and OPTION_DEFAULT

Remove dead index variable from device_get_options

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_cfg.h  |  3 ---
 drivers/staging/vt6655/device_main.c | 12 ++----------
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/device_cfg.h
index 8e50e53..7221824 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -67,9 +67,6 @@ struct _version {
 
 #define PKT_BUF_SZ          2390
 
-#define MAX_UINTS           8
-#define OPTION_DEFAULT      { [0 ... MAX_UINTS-1] = -1}
-
 typedef enum  _chip_type {
 	VT3253 = 1
 } CHIP_TYPE, *PCHIP_TYPE;
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index ffbe64f..34a70b0 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -245,9 +245,6 @@ DEVICE_PARAM(bDiversityANTEnable, "ANT diversity mode");
 //
 // Static vars definitions
 //
-
-static int          device_nics             = 0;
-
 static CHIP_INFO chip_info_table[] = {
 	{ VT3253,       "VIA Networking Solomon-A/B/G Wireless LAN Adapter ",
 	  256, 1,     DEVICE_FLAGS_IP_ALIGN|DEVICE_FLAGS_TX_ALIGN },
@@ -336,7 +333,7 @@ static void vt6655_remove(struct pci_dev *pcid)
 }
 
 static void device_get_options(struct vnt_private *pDevice,
-			       int index, char *devname)
+			       char *devname)
 {
 	POPTIONS pOpts = &(pDevice->sOpts);
 
@@ -825,11 +822,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	struct vnt_private *pDevice;
 	int         rc;
 
-	if (device_nics++ >= MAX_UINTS) {
-		pr_notice(DEVICE_NAME ": already found %d NICs\n", device_nics);
-		return -ENODEV;
-	}
-
 	dev = alloc_etherdev(sizeof(*pDevice));
 
 	pDevice = netdev_priv(dev);
@@ -934,7 +926,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	MACvInitialize(pDevice->PortOffset);
 	MACvReadEtherAddress(pDevice->PortOffset, dev->dev_addr);
 
-	device_get_options(pDevice, device_nics-1, dev->name);
+	device_get_options(pDevice, dev->name);
 	device_set_options(pDevice);
 	//Mask out the options cannot be set to the chip
 	pDevice->sOpts.flags &= pChip_info->flags;
-- 
1.9.1

