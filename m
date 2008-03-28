Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:44766 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbYC1Jge (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 05:36:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb-pcmcia: IRQ and DMA related fixes
Date: Fri, 28 Mar 2008 10:34:55 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200803281034.55731.mb@bu3sch.de> (sfid-20080328_093653_402379_EF8CB304)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here come some IRQ and DMA related fixes for the ssb PCMCIA-host code.
Not much to say, actually. I think the patch explains itself.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.25

Index: wireless-testing/drivers/ssb/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcmcia.c	2008-03-28 10:23:09.000000000 +0100
+++ wireless-testing/drivers/ssb/pcmcia.c	2008-03-28 10:25:00.000000000 +0100
@@ -25,17 +25,12 @@
 
 /* Define the following to 1 to enable a printk on each coreswitch. */
 #define SSB_VERBOSE_PCMCIACORESWITCH_DEBUG		0
 
 
 /* PCMCIA configuration registers */
-#define SSB_PCMCIA_CORECTL		0x00
-#define  SSB_PCMCIA_CORECTL_RESET	0x80 /* Core reset */
-#define  SSB_PCMCIA_CORECTL_IRQEN	0x04 /* IRQ enable */
-#define  SSB_PCMCIA_CORECTL_FUNCEN	0x01 /* Function enable */
-#define SSB_PCMCIA_CORECTL2		0x80
 #define SSB_PCMCIA_ADDRESS0		0x2E
 #define SSB_PCMCIA_ADDRESS1		0x30
 #define SSB_PCMCIA_ADDRESS2		0x32
 #define SSB_PCMCIA_MEMSEG		0x34
 #define SSB_PCMCIA_SPROMCTL		0x36
 #define  SSB_PCMCIA_SPROMCTL_IDLE	0
@@ -668,42 +663,55 @@ static ssize_t ssb_pcmcia_attr_sprom_sto
 }
 
 static DEVICE_ATTR(ssb_sprom, 0600,
 		   ssb_pcmcia_attr_sprom_show,
 		   ssb_pcmcia_attr_sprom_store);
 
+static int ssb_pcmcia_cor_setup(struct ssb_bus *bus, u8 cor)
+{
+	u8 val;
+	int err;
+
+	err = ssb_pcmcia_cfg_read(bus, cor, &val);
+	if (err)
+		return err;
+	val &= ~COR_SOFT_RESET;
+	val |= COR_FUNC_ENA | COR_IREQ_ENA | COR_LEVEL_REQ;
+	err = ssb_pcmcia_cfg_write(bus, cor, val);
+	if (err)
+		return err;
+	msleep(40);
+
+	return 0;
+}
+
 void ssb_pcmcia_exit(struct ssb_bus *bus)
 {
 	if (bus->bustype != SSB_BUSTYPE_PCMCIA)
 		return;
 
 	device_remove_file(&bus->host_pcmcia->dev, &dev_attr_ssb_sprom);
 }
 
 int ssb_pcmcia_init(struct ssb_bus *bus)
 {
-	u8 val, offset;
 	int err;
 
 	if (bus->bustype != SSB_BUSTYPE_PCMCIA)
 		return 0;
 
 	/* Switch segment to a known state and sync
 	 * bus->mapped_pcmcia_seg with hardware state. */
 	ssb_pcmcia_switch_segment(bus, 0);
 
-	/* Init IRQ routing */
-	if (bus->chip_id == 0x4306)
-		offset = SSB_PCMCIA_CORECTL;
-	else
-		offset = SSB_PCMCIA_CORECTL2;
-	err = ssb_pcmcia_cfg_read(bus, offset, &val);
+	/* Init the COR register. */
+	err = ssb_pcmcia_cor_setup(bus, CISREG_COR);
 	if (err)
 		goto error;
-	val |= SSB_PCMCIA_CORECTL_IRQEN | SSB_PCMCIA_CORECTL_FUNCEN;
-	err = ssb_pcmcia_cfg_write(bus, offset, val);
+	/* Some cards also need this register to get poked. */
+	err = ssb_pcmcia_cor_setup(bus, CISREG_COR + 0x80);
 	if (err)
 		goto error;
 
 	bus->sprom_size = SSB_PCMCIA_SPROM_SIZE;
 	mutex_init(&bus->sprom_mutex);
 	err = device_create_file(&bus->host_pcmcia->dev, &dev_attr_ssb_sprom);
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-03-28 10:23:21.000000000 +0100
+++ wireless-testing/drivers/ssb/main.c	2008-03-28 10:25:00.000000000 +0100
@@ -1061,15 +1061,15 @@ void ssb_device_disable(struct ssb_devic
 EXPORT_SYMBOL(ssb_device_disable);
 
 u32 ssb_dma_translation(struct ssb_device *dev)
 {
 	switch (dev->bus->bustype) {
 	case SSB_BUSTYPE_SSB:
+	case SSB_BUSTYPE_PCMCIA:
 		return 0;
 	case SSB_BUSTYPE_PCI:
-	case SSB_BUSTYPE_PCMCIA:
 		return SSB_PCI_DMA;
 	}
 	return 0;
 }
 EXPORT_SYMBOL(ssb_dma_translation);
 
