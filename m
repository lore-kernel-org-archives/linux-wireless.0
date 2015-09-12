Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38675 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbbILSLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:11 -0400
Received: by wiclk2 with SMTP id lk2so89648402wic.1
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:10 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/11] staging: vt6655: remove and move vt6655_init_info
Date: Sat, 12 Sep 2015 19:10:33 +0100
Message-Id: <1442081438-3485-6-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201139_494140_7D755453)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move code to vt6655_probe.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 03cc52e..ce2df37 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -28,7 +28,6 @@
  *
  *   vt6655_probe - module initial (insmod) driver entry
  *   vt6655_remove - module remove entry
- *   vt6655_init_info - device structure resource allocation function
  *   device_free_info - device structure resource free function
  *   device_get_pci_info - get allocated pci io/mem resource
  *   device_print_info - print out resource
@@ -136,8 +135,6 @@ static const struct pci_device_id vt6655_pci_id_table[] = {
 /*---------------------  Static Functions  --------------------------*/
 
 static int  vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent);
-static void vt6655_init_info(struct pci_dev *pcid,
-			     struct vnt_private **ppDevice);
 static void device_free_info(struct vnt_private *pDevice);
 static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
 static void device_print_info(struct vnt_private *pDevice);
@@ -436,14 +433,6 @@ static void device_print_info(struct vnt_private *pDevice)
 		 (unsigned long)pDevice->PortOffset, pDevice->pcid->irq);
 }
 
-static void vt6655_init_info(struct pci_dev *pcid,
-			     struct vnt_private **ppDevice)
-{
-	(*ppDevice)->pcid = pcid;
-
-	spin_lock_init(&((*ppDevice)->lock));
-}
-
 static bool device_get_pci_info(struct vnt_private *pDevice,
 				struct pci_dev *pcid)
 {
@@ -1643,8 +1632,9 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	}
 
 	priv = hw->priv;
+	priv->pcid = pcid;
 
-	vt6655_init_info(pcid, &priv);
+	spin_lock_init(&priv->lock);
 
 	priv->hw = hw;
 
-- 
2.5.0

