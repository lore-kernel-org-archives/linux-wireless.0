Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:27105 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1BQWnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 17:43:55 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022272.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 00:43:16 +0200
Subject: Re: [RFC] AI support (14/14 ssb AI on pci host (untested))
From: George Kashperko <george@znau.edu.ua>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297980093.13554.5.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 (sfid-20110217_170718_357395_57E8418D)  <1297980093.13554.5.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 00:35:24 +0200
Message-Id: <1297982124.23381.44.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: George Kashperko <george@znau.edu.ua>

Add support for AI-style bus on PCI host. This is preliminary
and untested yet.
Signed-off-by: George Kashperko <george@znau.edu.ua>
---
 drivers/ssb/ssb_ai.c |  100 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)
--- linux-wireless-testing.orig/drivers/ssb/ssb_ai.c	2011-02-17 16:01:51.000000000 +0200
+++ linux-wireless-testing/drivers/ssb/ssb_ai.c	2011-02-17 16:04:43.000000000 +0200
@@ -48,6 +48,93 @@ struct ssb_bus_aiops ssb_ssb_aiops = {
 	.write32	= ssb_ssb_aiwrite32,
 };
 
+#ifdef CONFIG_SSB_PCIHOST
+#define SSB_VERBOSE_PCICOREAISWITCH_DEBUG	0
+static int ssb_pci_switch_aicoreidx(struct ssb_bus *bus, u8 coreidx)
+{
+	int err;
+	int attempts = 0;
+	u32 cur_core;
+
+	while (true) {
+		err = pci_write_config_dword(bus->host_pci, SSB_BAR0_WIN2,
+					     (coreidx * SSB_CORE_SIZE) +
+					     SSB_AI_BASE);
+		if (err)
+			goto error;
+		err = pci_read_config_dword(bus->host_pci, SSB_BAR0_WIN2,
+					    &cur_core);
+		if (err)
+			goto error;
+		cur_core = (cur_core - SSB_AI_BASE)
+			   / SSB_CORE_SIZE;
+		if (cur_core == coreidx)
+			break;
+
+		if (attempts++ > SSB_BAR0_MAX_RETRIES)
+			goto error;
+		udelay(10);
+	}
+	return 0;
+error:
+	ssb_printk(KERN_ERR PFX "Failed to switch to AI core %u\n", coreidx);
+	return -ENODEV;
+}
+
+static int ssb_pci_switch_aicore(struct ssb_bus *bus,
+				 struct ssb_device *dev)
+{
+	int err;
+	unsigned long flags;
+
+#if SSB_VERBOSE_PCICOREAISWITCH_DEBUG
+	ssb_printk(KERN_INFO PFX
+		   "Switching to %s AI core, index %d\n",
+		   ssb_core_name(dev->id.coreid),
+		   dev->core_index);
+#endif
+
+	spin_lock_irqsave(&bus->bar_lock, flags);
+	err = ssb_pci_switch_aicoreidx(bus, dev->core_index);
+	if (!err)
+		bus->ai.mapped_device = dev;
+	spin_unlock_irqrestore(&bus->bar_lock, flags);
+
+	return err;
+}
+
+static u32 ssb_pci_airead32(struct ssb_device *dev, u16 offset)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	if (unlikely(!bus->powered_up))
+		return 0xFFFFFFFF;
+	if (unlikely(bus->ai.mapped_device != dev)) {
+		if (unlikely(ssb_pci_switch_aicore(bus, dev)))
+			return 0xFFFFFFFF;
+	}
+	return ioread32(bus->ai.mmio + offset);
+}
+
+static void ssb_pci_aiwrite32(struct ssb_device *dev, u16 offset, u32 value)
+{
+	struct ssb_bus *bus = dev->bus;
+
+	if (unlikely(!bus->powered_up))
+		return;
+	if (unlikely(bus->ai.mapped_device != dev)) {
+		if (unlikely(ssb_pci_switch_aicore(bus, dev)))
+			return;
+	}
+	iowrite32(value, bus->ai.mmio + offset);
+}
+
+struct ssb_bus_aiops ssb_pci_aiops = {
+	.read32		= ssb_pci_airead32,
+	.write32	= ssb_pci_aiwrite32,
+};
+#endif /* CONFIG_SSB_PCIHOST */
+
 /* The 47162a0 hangs when reading its registers */
 static inline bool ssb_bcm47162a0_quirk(struct ssb_device *dev)
 {
@@ -188,6 +275,10 @@ void ssb_iounmap_ai(struct ssb_bus *bus)
 		iounmap(bus->mmio);
 		iounmap(bus->ai.mmio);
 		break;
+#ifdef CONFIG_SSB_PCIHOST
+	case SSB_BUSTYPE_PCI:
+		pci_iounmap(bus->host_pci, bus->mmio);
+#endif
 	default:
 		break;
 	}
@@ -263,6 +354,15 @@ int ssb_bus_scan_ai(struct ssb_bus *bus,
 		if (!eromptr)
 			return -ENOMEM;
 		break;
+#ifdef CONFIG_SSB_PCIHOST
+	case SSB_BUSTYPE_PCI:
+		bus->ai.ops = &ssb_pci_aiops;
+		/* point second bar0 window at the EROM */
+		pci_write_config_dword(bus->host_pci, SSB_BAR0_WIN2, erombase);
+		eromptr = bus->mmio;
+		bus->ai.mmio = bus->mmio + 0x1000;
+		break;
+#endif /* CONFIG_SSB_PCIHOST */
 	default:
 		return -ENODEV;
 	}



