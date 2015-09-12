Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33584 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbbILSLR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:17 -0400
Received: by wiclk2 with SMTP id lk2so96489556wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:15 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 11/11] staging: vt6655: Move code in device_get_pci_info
Date: Sat, 12 Sep 2015 19:10:38 +0100
Message-Id: <1442081438-3485-11-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201135_302347_4343D176)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Function always returns true and now only a few lines move
to vt6655_probe.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 21 +++------------------
 1 file changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index add9cdf..326bce3 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -29,7 +29,6 @@
  *   vt6655_probe - module initial (insmod) driver entry
  *   vt6655_remove - module remove entry
  *   device_free_info - device structure resource free function
- *   device_get_pci_info - get allocated pci io/mem resource
  *   device_print_info - print out resource
  *   device_rx_srv - rx service function
  *   device_alloc_rx_buf - rx buffer pre-allocated function
@@ -136,7 +135,6 @@ static const struct pci_device_id vt6655_pci_id_table[] = {
 
 static int  vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent);
 static void device_free_info(struct vnt_private *pDevice);
-static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
 static void device_print_info(struct vnt_private *pDevice);
 
 static void device_init_rd0_ring(struct vnt_private *pDevice);
@@ -430,17 +428,6 @@ static void device_print_info(struct vnt_private *pDevice)
 		 (unsigned long)pDevice->PortOffset, pDevice->pcid->irq);
 }
 
-static bool device_get_pci_info(struct vnt_private *pDevice,
-				struct pci_dev *pcid)
-{
-	pci_set_master(pcid);
-
-	pDevice->memaddr = pci_resource_start(pcid, 0);
-	pDevice->ioaddr = pci_resource_start(pcid, 1);
-
-	return true;
-}
-
 static void device_free_info(struct vnt_private *pDevice)
 {
 	if (!pDevice)
@@ -1629,12 +1616,10 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	dev_dbg(&pcid->dev,
 		"Before get pci_info memaddr is %x\n", priv->memaddr);
 
-	if (!device_get_pci_info(priv, pcid)) {
-		dev_err(&pcid->dev, ": Failed to find PCI device.\n");
-		device_free_info(priv);
-		return -ENODEV;
-	}
+	pci_set_master(pcid);
 
+	priv->memaddr = pci_resource_start(pcid, 0);
+	priv->ioaddr = pci_resource_start(pcid, 1);
 	priv->PortOffset = ioremap(priv->memaddr & PCI_BASE_ADDRESS_MEM_MASK,
 				   256);
 	if (!priv->PortOffset) {
-- 
2.5.0

