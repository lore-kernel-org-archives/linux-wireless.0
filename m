Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:62080 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaHUUlt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 16:41:49 -0400
Received: by mail-wg0-f41.google.com with SMTP id z12so9836424wgg.24
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2014 13:41:47 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/3] staging: vt6655: remove multiple instances of netdevice.
Date: Thu, 21 Aug 2014 21:40:49 +0100
Message-Id: <1408653650-9049-2-git-send-email-tvboxspy@gmail.com> (sfid-20140821_224152_580216_A4011BD7)
In-Reply-To: <1408653650-9049-1-git-send-email-tvboxspy@gmail.com>
References: <1408653650-9049-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

netdevice can only be created once.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      | 1 -
 drivers/staging/vt6655/device_main.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index bc16ece..8ac7901 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -339,7 +339,6 @@ struct vnt_private {
 
 // netdev
 	struct net_device *dev;
-	struct net_device *next_module;
 	struct net_device_stats     stats;
 
 //dma addr, rx/tx pool
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a441a5c..ffbe64f 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -247,7 +247,6 @@ DEVICE_PARAM(bDiversityANTEnable, "ANT diversity mode");
 //
 
 static int          device_nics             = 0;
-static struct net_device *root_device_dev = NULL;
 
 static CHIP_INFO chip_info_table[] = {
 	{ VT3253,       "VIA Networking Solomon-A/B/G Wireless LAN Adapter ",
@@ -851,8 +850,6 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	vt6655_init_info(pcid, &pDevice, pChip_info);
 	pDevice->dev = dev;
-	pDevice->next_module = root_device_dev;
-	root_device_dev = dev;
 
 	if (pci_enable_device(pcid)) {
 		device_free_info(pDevice);
-- 
1.9.1

