Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emita2.mittwald.de ([85.199.129.253]:39283 "EHLO
	emita2.mittwald.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYHGMWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 08:22:53 -0400
Received: from mx51.mymxserver.com (unknown [172.16.51.3])
	by emita2.mittwald.de (Postfix) with ESMTP id D9C5F5FD28B
	for <linux-wireless@vger.kernel.org>; Thu,  7 Aug 2008 12:16:19 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 913B64B015
	for <linux-wireless@vger.kernel.org>; Thu,  7 Aug 2008 12:16:12 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d1wHPzSreEUt for <linux-wireless@vger.kernel.org>;
	Thu,  7 Aug 2008 12:16:12 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FAA36.dip0.t-ipconnect.de [217.95.170.54])
	by mx51.mymxserver.com (Postfix) with ESMTP id EEE6B4B010
	for <linux-wireless@vger.kernel.org>; Thu,  7 Aug 2008 12:16:11 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 85C8B1E005E
	for <linux-wireless@vger.kernel.org>; Thu,  7 Aug 2008 12:16:05 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: [RFC, compat-wireless] ssb woes for ARCH "arm", MACH "pxa"
Date: Thu, 7 Aug 2008 12:16:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808071216.03897.hs4233@mail.mn-solutions.de> (sfid-20080807_142337_979445_BDB64D1E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to compile a Broadcom 4318 compact-flash card
for an embedded device, based on an Intel PXA CPU.

When I compile compat-wireless (2008-08-01), I get
these errors:

include/linux/ssb.h: In function `ssb_dma_sync_single_range_for_cpu':
include/linux/ssb.h:518: error: implicit declaration of function `dma_sync_single_range_for_cpu'
include/linux/ssb/ssb.h: In function `ssb_dma_sync_single_range_for_device':
include/linux/ssb/ssb.h:539: error: implicit declaration of function `dma_sync_single_range_for_device'

However, in have the following configs defined (among others),
so this shouldn't happen:

CONFIG_B43=m
CONFIG_B43_DEBUG=y
CONFIG_B43_DMA=n                        <-- no DMA
CONFIG_B43_PIO=y
CONFIG_B43_FORCE_PIO=y                  <-- force PIO
CONFIG_B43_DMA_AND_PIO_MODE=n
CONFIG_B43_PCMCIA=y
CONFIG_B43_PCICORE_AUTOSELECT=n
CONFIG_B43_PCI_AUTOSELECT=n
CONFIG_B43_RFKILL=n
CONFIG_B43_LEDS=n

CONFIG_SSB=m
CONFIG_SSB_DEBUG=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB_B43_PCI_BRIDGE=n
CONFIG_SSB_DRIVER_PCICORE=n
CONFIG_SSB_PCICORE_HOSTMODE=n
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=n
CONFIG_SSB_PCIHOST=n
CONFIG_SSB_PCIHOST_POSSIBLE=n
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_DRIVER_MIPS=n
CONFIG_SSB_DRIVER_EXTIF=n
CONFIG_SSB_SPROM=y


I now have a (possibly ugly) patch that at least allows me to
compile the beast, but I'd like to get advice on how to solve
this issue correctly.

--- b.orig/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -509,6 +509,7 @@ static inline void ssb_dma_sync_single_r
 						     enum dma_data_direction dir)
 {
 	switch (dev->bus->bustype) {
+#ifndef CONFIG_B43_FORCE_PIO
 	case SSB_BUSTYPE_PCI:
 		/* Just sync everything. That's all the PCI API can do. */
 		pci_dma_sync_single_for_cpu(dev->bus->host_pci, dma_addr,
@@ -518,6 +519,7 @@ static inline void ssb_dma_sync_single_r
 		dma_sync_single_range_for_cpu(dev->dev, dma_addr, offset,
 					      size, dir);
 		return;
+#endif
 	default:
 		__ssb_dma_not_implemented(dev);
 	}
@@ -530,6 +532,7 @@ static inline void ssb_dma_sync_single_r
 							enum dma_data_direction dir)
 {
 	switch (dev->bus->bustype) {
+#ifndef CONFIG_B43_FORCE_PIO
 	case SSB_BUSTYPE_PCI:
 		/* Just sync everything. That's all the PCI API can do. */
 		pci_dma_sync_single_for_device(dev->bus->host_pci, dma_addr,
@@ -539,6 +542,7 @@ static inline void ssb_dma_sync_single_r
 		dma_sync_single_range_for_device(dev->dev, dma_addr, offset,
 						 size, dir);
 		return;
+#endif
 	default:
 		__ssb_dma_not_implemented(dev);
 	}
--- b.orig/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -1187,15 +1187,19 @@ EXPORT_SYMBOL(ssb_dma_translation);
 
 int ssb_dma_set_mask(struct ssb_device *dev, u64 mask)
 {
+#ifndef CONFIG_B43_FORCE_PIO
 	int err;
+#endif
 
 	switch (dev->bus->bustype) {
+#ifndef CONFIG_B43_FORCE_PIO
 	case SSB_BUSTYPE_PCI:
 		err = pci_set_dma_mask(dev->bus->host_pci, mask);
 		if (err)
 			return err;
 		err = pci_set_consistent_dma_mask(dev->bus->host_pci, mask);
 		return err;
+#endif
 	case SSB_BUSTYPE_SSB:
 		return dma_set_mask(dev->dev, mask);
 	default:
--- b.orig/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -928,6 +928,9 @@ static inline void b43_write32(struct b4
 	ssb_write32(dev->dev, offset, value);
 }
 
+#ifdef CONFIG_B43_FORCE_PIO
+#define b43_using_pio_transfers(dev) 1
+#else
 static inline bool b43_using_pio_transfers(struct b43_wldev *dev)
 {
 #ifdef CONFIG_B43_PIO
@@ -936,6 +939,7 @@ static inline bool b43_using_pio_transfe
 	return 0;
 #endif
 }
+#endif
 
 #ifdef CONFIG_B43_FORCE_PIO
 # define B43_FORCE_PIO	1

