Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41351
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbXHKAGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2007 20:06:10 -0400
Message-Id: <20070811000358.075558000@bu3sch.de>
References: <20070811000354.611868000@bu3sch.de>
Date: Sat, 11 Aug 2007 02:03:59 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 5/5] ssb: Remove verbose coreswitch printk
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes the verbose printk on every coreswitch dependent
on a default-off debugging variable.
Verbose coreswitch messages are only needed when debugging
strange crashes or machine check exceptions.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge/drivers/ssb/pci.c
===================================================================
--- ssb-merge.orig/drivers/ssb/pci.c	2007-08-10 12:52:50.000000000 +0200
+++ ssb-merge/drivers/ssb/pci.c	2007-08-10 13:38:43.000000000 +0200
@@ -23,6 +23,10 @@
 #include "ssb_private.h"
 
 
+/* Define the following to 1 to enable a printk on each coreswitch. */
+#define SSB_VERBOSE_PCICORESWITCH_DEBUG		0
+
+
 /* Lowlevel coreswitching */
 int ssb_pci_switch_coreidx(struct ssb_bus *bus, u8 coreidx)
 {
@@ -61,10 +65,12 @@ int ssb_pci_switch_core(struct ssb_bus *
 	int err;
 	unsigned long flags;
 
-	ssb_dprintk(KERN_INFO PFX
-		    "Switching to %s core, index %d\n",
-		    ssb_core_name(dev->id.coreid),
-		    dev->core_index);
+#if SSB_VERBOSE_PCICORESWITCH_DEBUG
+	ssb_printk(KERN_INFO PFX
+		   "Switching to %s core, index %d\n",
+		   ssb_core_name(dev->id.coreid),
+		   dev->core_index);
+#endif
 
 	spin_lock_irqsave(&bus->bar_lock, flags);
 	err = ssb_pci_switch_coreidx(bus, dev->core_index);
Index: ssb-merge/drivers/ssb/pcmcia.c
===================================================================
--- ssb-merge.orig/drivers/ssb/pcmcia.c	2007-08-10 12:52:50.000000000 +0200
+++ ssb-merge/drivers/ssb/pcmcia.c	2007-08-10 13:38:43.000000000 +0200
@@ -21,6 +21,10 @@
 #include "ssb_private.h"
 
 
+/* Define the following to 1 to enable a printk on each coreswitch. */
+#define SSB_VERBOSE_PCMCIACORESWITCH_DEBUG		0
+
+
 int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
 			      u8 coreidx)
 {
@@ -91,10 +95,12 @@ int ssb_pcmcia_switch_core(struct ssb_bu
 	int err;
 	unsigned long flags;
 
-	ssb_dprintk(KERN_INFO PFX
-		    "Switching to %s core, index %d\n",
-		    ssb_core_name(dev->id.coreid),
-		    dev->core_index);
+#if SSB_VERBOSE_PCMCIACORESWITCH_DEBUG
+	ssb_printk(KERN_INFO PFX
+		   "Switching to %s core, index %d\n",
+		   ssb_core_name(dev->id.coreid),
+		   dev->core_index);
+#endif
 
 	spin_lock_irqsave(&bus->bar_lock, flags);
 	err = ssb_pcmcia_switch_coreidx(bus, dev->core_index);

-- 

