Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36937 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbYHGQYf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 12:24:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: allow compilation on systems without PCI
Date: Thu, 7 Aug 2008 18:24:12 +0200
Cc: linux-wireless@vger.kernel.org,
	Holger Schurig <hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200808071824.12255.mb@bu3sch.de> (sfid-20080807_182437_936963_71412549)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Holger Schurig <hs4233@mail.mn-solutions.de>

Makes ssb work on system without a PCI bus.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please apply to current bugfix tree (Don't remember the version
number, duh. Linus, need new versioning scheme! :D)


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


-------------------------------------------------------

-- 
Greetings Michael.
