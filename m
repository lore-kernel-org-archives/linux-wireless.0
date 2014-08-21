Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63954 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbaHUUlr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2014 16:41:47 -0400
Received: by mail-wi0-f179.google.com with SMTP id f8so9049248wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2014 13:41:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/3] staging: vt6655: remove multiple instances of driver loading.
Date: Thu, 21 Aug 2014 21:40:48 +0100
Message-Id: <1408653650-9049-1-git-send-email-tvboxspy@gmail.com> (sfid-20140821_224150_745805_7CE114FE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver can only load once from the instance provided
by pci_dev.

struct vnt_private next, prev and pDevice_Infos are removed.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  3 ---
 drivers/staging/vt6655/device_main.c | 31 +++----------------------------
 2 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 2434a37..bc16ece 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -331,9 +331,6 @@ typedef struct __device_opt {
 } OPTIONS, *POPTIONS;
 
 struct vnt_private {
-	struct vnt_private *next;
-	struct vnt_private *prev;
-
 	struct pci_dev *pcid;
 
 #ifdef CONFIG_PM
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 1a94d4f..a441a5c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -247,7 +247,6 @@ DEVICE_PARAM(bDiversityANTEnable, "ANT diversity mode");
 //
 
 static int          device_nics             = 0;
-static struct vnt_private *pDevice_Infos = NULL;
 static struct net_device *root_device_dev = NULL;
 
 static CHIP_INFO chip_info_table[] = {
@@ -979,19 +978,8 @@ static void vt6655_init_info(struct pci_dev *pcid,
 			     struct vnt_private **ppDevice,
 			     PCHIP_INFO pChip_info)
 {
-	struct vnt_private *p;
-
 	memset(*ppDevice, 0, sizeof(**ppDevice));
 
-	if (pDevice_Infos == NULL) {
-		pDevice_Infos = *ppDevice;
-	} else {
-		for (p = pDevice_Infos; p->next != NULL; p = p->next)
-			do {} while (0);
-		p->next = *ppDevice;
-		(*ppDevice)->prev = p;
-	}
-
 	(*ppDevice)->pcid = pcid;
 	(*ppDevice)->chip_id = pChip_info->chip_id;
 	(*ppDevice)->io_size = pChip_info->io_size;
@@ -1030,9 +1018,11 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 
 static void device_free_info(struct vnt_private *pDevice)
 {
-	struct vnt_private *ptr;
 	struct net_device *dev = pDevice->dev;
 
+	if (!pDevice)
+		return;
+
 	ASSERT(pDevice);
 //2008-0714-01<Add>by chester
 	device_release_WPADEV(pDevice);
@@ -1042,21 +1032,6 @@ static void device_free_info(struct vnt_private *pDevice)
 	if (wpa_set_wpadev(pDevice, 0) != 0)
 		pr_err("unregister wpadev fail?\n");
 
-	if (pDevice_Infos == NULL)
-		return;
-
-	for (ptr = pDevice_Infos; ptr && (ptr != pDevice); ptr = ptr->next)
-		do {} while (0);
-
-	if (ptr == pDevice) {
-		if (ptr == pDevice_Infos)
-			pDevice_Infos = ptr->next;
-		else
-			ptr->prev->next = ptr->next;
-	} else {
-		pr_err("info struct not found\n");
-		return;
-	}
 #ifdef HOSTAP
 	if (dev)
 		vt6655_hostap_set_hostapd(pDevice, 0, 0);
-- 
1.9.1

