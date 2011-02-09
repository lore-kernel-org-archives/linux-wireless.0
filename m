Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:20459 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab1BIOgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:36:54 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000019972.msg
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 16:36:17 +0200
Subject: Re: SSB AI support code ([RFC1/11] SSB admatch redefine)
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297258590.17400.37.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
Content-Type: text/plain
Date: Wed, 09 Feb 2011 16:29:29 +0200
Message-Id: <1297261769.18053.14.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Move direct master/slave wrappers registers' queries into SSB management code.
Indirect requests to SB management code for wrappers' base/size rather than
direct access to backplane-specific registers will let adding AI-style SSB
buses support without need to alter drivers' code later on.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/driver_gige.c   |    2 +-
 drivers/ssb/main.c          |    8 ++++++--
 drivers/usb/host/ohci-ssb.c |    8 ++++----
 include/linux/ssb/ssb.h     |    4 ++--
 4 files changed, 13 insertions(+), 9 deletions(-)
--- linux-next-20110203.orig/drivers/ssb/driver_gige.c	2011-02-01 05:05:49.000000000 +0200
+++ linux-next-20110203/drivers/ssb/driver_gige.c	2011-02-05 17:41:30.000000000 +0200
@@ -193,7 +193,7 @@ static int ssb_gige_probe(struct ssb_dev
 		ssb_device_enable(sdev, 0);
 
 	/* Setup BAR0. This is a 64k MMIO region. */
-	base = ssb_admatch_base(ssb_read32(sdev, SSB_ADMATCH1));
+	base = ssb_admatch_base(sdev, SSB_ADMATCH1);
 	gige_pcicfg_write32(dev, PCI_BASE_ADDRESS_0, base);
 	gige_pcicfg_write32(dev, PCI_BASE_ADDRESS_1, 0);
 
--- linux-next-20110203.orig/drivers/ssb/main.c	2011-02-01 05:05:49.000000000 +0200
+++ linux-next-20110203/drivers/ssb/main.c	2011-02-05 17:42:37.000000000 +0200
@@ -1312,10 +1312,12 @@ error:
 }
 EXPORT_SYMBOL(ssb_bus_powerup);
 
-u32 ssb_admatch_base(u32 adm)
+u32 ssb_admatch_base(struct ssb_device *dev, u32 adm)
 {
 	u32 base = 0;
 
+	adm = ssb_read32(dev, adm);
+
 	switch (adm & SSB_ADM_TYPE) {
 	case SSB_ADM_TYPE0:
 		base = (adm & SSB_ADM_BASE0);
@@ -1336,10 +1338,12 @@ u32 ssb_admatch_base(u32 adm)
 }
 EXPORT_SYMBOL(ssb_admatch_base);
 
-u32 ssb_admatch_size(u32 adm)
+u32 ssb_admatch_size(struct ssb_device *dev, u32 adm)
 {
 	u32 size = 0;
 
+	adm = ssb_read32(dev, adm);
+
 	switch (adm & SSB_ADM_TYPE) {
 	case SSB_ADM_TYPE0:
 		size = ((adm & SSB_ADM_SZ0) >> SSB_ADM_SZ0_SHIFT);
--- linux-next-20110203.orig/drivers/usb/host/ohci-ssb.c	2011-02-01 05:05:49.000000000 +0200
+++ linux-next-20110203/drivers/usb/host/ohci-ssb.c	2011-02-05 17:44:59.000000000 +0200
@@ -107,7 +107,7 @@ static int ssb_ohci_attach(struct ssb_de
 	struct ssb_ohci_device *ohcidev;
 	struct usb_hcd *hcd;
 	int err = -ENOMEM;
-	u32 tmp, flags = 0;
+	u32 flags = 0;
 
 	if (dma_set_mask(dev->dma_dev, DMA_BIT_MASK(32)) ||
 	    dma_set_coherent_mask(dev->dma_dev, DMA_BIT_MASK(32)))
@@ -118,6 +118,7 @@ static int ssb_ohci_attach(struct ssb_de
 		flags |= SSB_OHCI_TMSLOW_HOSTMODE;
 		ssb_device_enable(dev, flags);
 	} else if (dev->id.coreid == SSB_DEV_USB20_HOST) {
+		u32 tmp;
 		/*
 		 * USB 2.0 special considerations:
 		 *
@@ -163,9 +164,8 @@ static int ssb_ohci_attach(struct ssb_de
 	ohcidev = hcd_to_ssb_ohci(hcd);
 	ohcidev->enable_flags = flags;
 
-	tmp = ssb_read32(dev, SSB_ADMATCH0);
-	hcd->rsrc_start = ssb_admatch_base(tmp);
-	hcd->rsrc_len = ssb_admatch_size(tmp);
+	hcd->rsrc_start = ssb_admatch_base(dev, SSB_ADMATCH0);
+	hcd->rsrc_len = ssb_admatch_size(dev, SSB_ADMATCH0);
 	hcd->regs = ioremap_nocache(hcd->rsrc_start, hcd->rsrc_len);
 	if (!hcd->regs)
 		goto err_put_hcd;
--- linux-next-20110203.orig/include/linux/ssb/ssb.h	2011-02-01 05:05:49.000000000 +0200
+++ linux-next-20110203/include/linux/ssb/ssb.h	2011-02-05 17:40:13.000000000 +0200
@@ -520,8 +520,8 @@ extern int ssb_bus_powerup(struct ssb_bu
 

 /* Various helper functions */
-extern u32 ssb_admatch_base(u32 adm);
-extern u32 ssb_admatch_size(u32 adm);
+extern u32 ssb_admatch_base(struct ssb_device *dev, u32 adm);
+extern u32 ssb_admatch_size(struct ssb_device *dev, u32 adm);
 
 /* PCI device mapping and fixup routines.
  * Called from the architecture pcibios init code.



