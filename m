Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:28353 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYHGPVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:21:07 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ssb: allow compilation on systems without PCI
Date: Thu, 7 Aug 2008 17:21:00 +0200
Cc: Michael Buesch <mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808071721.00737.hs4233@mail.mn-solutions.de> (sfid-20080807_172110_046287_876004D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Makes ssb work on system without a PCI bus.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
I'm not sure if I should check for CONFIG_SSB_PCIHOST (like in
the rest of the file) or simply for CONFIG_PCI.

--- wireless-testing.orig/drivers/ssb/main.c
+++ wireless-testing/drivers/ssb/main.c
@@ -1165,15 +1165,19 @@ EXPORT_SYMBOL(ssb_dma_translation);
 
 int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
 {
+#ifdef CONFIG_SSB_PCIHOST
 	int err;
+#endif
 
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_PCI:
+#ifdef CONFIG_SSB_PCIHOST
 		err = pci_set_dma_mask(dev->bus->host_pci, mask);
 		if (err)
 			return err;
 		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
 		return err;
+#endif
 	case SSB_BUSTYPE_SSB:
 		return dma_set_mask(dev->dev, mask);
 	default:
@@ -1188,6 +1192,7 @@ void * ssb_dma_alloc_consistent(struct s
 {
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_PCI:
+#ifdef CONFIG_SSB_PCIHOST
 		if (gfp_flags & GFP_DMA) {
 			/* Workaround: The PCI API does not support passing
 			 * a GFP flag. */
@@ -1195,6 +1200,7 @@ void * ssb_dma_alloc_consistent(struct s
 						  size, dma_handle, gfp_flags);
 		}
 		return pci_alloc_consistent(dev->bus->host_pci, size, dma_handle);
+#endif
 	case SSB_BUSTYPE_SSB:
 		return dma_alloc_coherent(dev->dev, size, dma_handle, gfp_flags);
 	default:
@@ -1210,6 +1216,7 @@ void ssb_dma_free_consistent(struct ssb_
 {
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_PCI:
+#ifdef CONFIG_SSB_PCIHOST
 		if (gfp_flags & GFP_DMA) {
 			/* Workaround: The PCI API does not support passing
 			 * a GFP flag. */
@@ -1220,6 +1227,7 @@ void ssb_dma_free_consistent(struct ssb_
 		pci_free_consistent(dev->bus->host_pci, size,
 				    vaddr, dma_handle);
 		return;
+#endif
 	case SSB_BUSTYPE_SSB:
 		dma_free_coherent(dev->dev, size, vaddr, dma_handle);
 		return;
