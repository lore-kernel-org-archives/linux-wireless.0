Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:40390 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYCJQ1L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 12:27:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Add SPROM/invariants support for PCMCIA devices
Date: Mon, 10 Mar 2008 17:26:32 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200803101726.32658.mb@bu3sch.de> (sfid-20080310_162717_495422_4CE8FA50)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds support for reading/writing the SPROM invariants
for PCMCIA based devices.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.26.


Index: wireless-testing/drivers/ssb/Kconfig
===================================================================
--- wireless-testing.orig/drivers/ssb/Kconfig	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/drivers/ssb/Kconfig	2008-03-10 17:23:59.000000000 +0100
@@ -17,20 +17,25 @@ config SSB
 	  environments.
 
 	  The module will be called ssb.
 
 	  If unsure, say N.
 
+# Common SPROM support routines
+config SSB_SPROM
+	bool
+
 config SSB_PCIHOST_POSSIBLE
 	bool
 	depends on SSB && (PCI = y || PCI = SSB)
 	default y
 
 config SSB_PCIHOST
 	bool "Support for SSB on PCI-bus host"
 	depends on SSB_PCIHOST_POSSIBLE
+	select SSB_SPROM
 	default y
 	help
 	  Support for a Sonics Silicon Backplane on top
 	  of a PCI device.
 
 	  If unsure, say Y
@@ -45,12 +50,13 @@ config SSB_PCMCIAHOST_POSSIBLE
 	depends on SSB && (PCMCIA = y || PCMCIA = SSB) && EXPERIMENTAL
 	default y
 
 config SSB_PCMCIAHOST
 	bool "Support for SSB on PCMCIA-bus host (EXPERIMENTAL)"
 	depends on SSB_PCMCIAHOST_POSSIBLE
+	select SSB_SPROM
 	help
 	  Support for a Sonics Silicon Backplane on top
 	  of a PCMCIA device.
 
 	  If unsure, say N
 
Index: wireless-testing/drivers/ssb/Makefile
===================================================================
--- wireless-testing.orig/drivers/ssb/Makefile	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/drivers/ssb/Makefile	2008-03-10 17:15:52.000000000 +0100
@@ -1,9 +1,10 @@
 # core
 ssb-y					+= main.o scan.o
 ssb-$(CONFIG_SSB_EMBEDDED)		+= embedded.o
+ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 
 # host support
 ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
 ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o
 
 # built-in drivers
Index: wireless-testing/drivers/ssb/main.c
===================================================================
--- wireless-testing.orig/drivers/ssb/main.c	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/drivers/ssb/main.c	2008-03-10 17:15:52.000000000 +0100
@@ -65,12 +65,31 @@ found:
 	ssb_buses_unlock();
 
 	return bus;
 }
 #endif /* CONFIG_SSB_PCIHOST */
 
+#ifdef CONFIG_SSB_PCMCIAHOST
+struct ssb_bus *ssb_pcmcia_dev_to_bus(struct pcmcia_device *pdev)
+{
+	struct ssb_bus *bus;
+
+	ssb_buses_lock();
+	list_for_each_entry(bus, &buses, list) {
+		if (bus->bustype == SSB_BUSTYPE_PCMCIA &&
+		    bus->host_pcmcia == pdev)
+			goto found;
+	}
+	bus = NULL;
+found:
+	ssb_buses_unlock();
+
+	return bus;
+}
+#endif /* CONFIG_SSB_PCMCIAHOST */
+
 static struct ssb_device *ssb_device_get(struct ssb_device *dev)
 {
 	if (dev)
 		get_device(dev->dev);
 	return dev;
 }
@@ -375,13 +394,13 @@ void ssb_bus_unregister(struct ssb_bus *
 {
 	ssb_buses_lock();
 	ssb_devices_unregister(bus);
 	list_del(&bus->list);
 	ssb_buses_unlock();
 
-	/* ssb_pcmcia_exit(bus); */
+	ssb_pcmcia_exit(bus);
 	ssb_pci_exit(bus);
 	ssb_iounmap(bus);
 }
 EXPORT_SYMBOL(ssb_bus_unregister);
 
 static void ssb_release_dev(struct device *dev)
@@ -640,13 +659,13 @@ static int ssb_bus_register(struct ssb_b
 out:
 	return err;
 
 err_dequeue:
 	list_del(&bus->list);
 err_pcmcia_exit:
-/*	ssb_pcmcia_exit(bus); */
+	ssb_pcmcia_exit(bus);
 err_pci_exit:
 	ssb_pci_exit(bus);
 err_unmap:
 	ssb_iounmap(bus);
 err_disable_xtal:
 	ssb_buses_unlock();
Index: wireless-testing/drivers/ssb/pci.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pci.c	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/drivers/ssb/pci.c	2008-03-10 17:15:52.000000000 +0100
@@ -224,13 +224,13 @@ static u8 ssb_sprom_crc(const u16 *sprom
 	crc = ssb_crc8(crc, sprom[size - 1] & 0x00FF);
 	crc ^= 0xFF;
 
 	return crc;
 }
 
-static int sprom_check_crc(const u16 *sprom, u16 size)
+static int sprom_check_crc(const u16 *sprom, size_t size)
 {
 	u8 crc;
 	u8 expected_crc;
 	u16 tmp;
 
 	crc = ssb_sprom_crc(sprom, size);
@@ -239,18 +239,20 @@ static int sprom_check_crc(const u16 *sp
 	if (crc != expected_crc)
 		return -EPROTO;
 
 	return 0;
 }
 
-static void sprom_do_read(struct ssb_bus *bus, u16 *sprom)
+static int sprom_do_read(struct ssb_bus *bus, u16 *sprom)
 {
 	int i;
 
 	for (i = 0; i < bus->sprom_size; i++)
 		sprom[i] = ioread16(bus->mmio + SSB_SPROM_BASE + (i * 2));
+
+	return 0;
 }
 
 static int sprom_do_write(struct ssb_bus *bus, const u16 *sprom)
 {
 	struct pci_dev *pdev = bus->host_pci;
 	int i, err;
@@ -657,134 +659,39 @@ const struct ssb_bus_ops ssb_pci_ops = {
 	.read32		= ssb_pci_read32,
 	.write8		= ssb_pci_write8,
 	.write16	= ssb_pci_write16,
 	.write32	= ssb_pci_write32,
 };
 
-static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len, u16 size)
-{
-	int i, pos = 0;
-
-	for (i = 0; i < size; i++)
-		pos += snprintf(buf + pos, buf_len - pos - 1,
-				"%04X", swab16(sprom[i]) & 0xFFFF);
-	pos += snprintf(buf + pos, buf_len - pos - 1, "\n");
-
-	return pos + 1;
-}
-
-static int hex2sprom(u16 *sprom, const char *dump, size_t len, u16 size)
-{
-	char tmp[5] = { 0 };
-	int cnt = 0;
-	unsigned long parsed;
-
-	if (len < size * 2)
-		return -EINVAL;
-
-	while (cnt < size) {
-		memcpy(tmp, dump, 4);
-		dump += 4;
-		parsed = simple_strtoul(tmp, NULL, 16);
-		sprom[cnt++] = swab16((u16)parsed);
-	}
-
-	return 0;
-}
-
 static ssize_t ssb_pci_attr_sprom_show(struct device *pcidev,
 				       struct device_attribute *attr,
 				       char *buf)
 {
 	struct pci_dev *pdev = container_of(pcidev, struct pci_dev, dev);
 	struct ssb_bus *bus;
-	u16 *sprom;
-	int err = -ENODEV;
-	ssize_t count = 0;
 
 	bus = ssb_pci_dev_to_bus(pdev);
 	if (!bus)
-		goto out;
-	err = -ENOMEM;
-	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
-	if (!sprom)
-		goto out;
-
-	/* Use interruptible locking, as the SPROM write might
-	 * be holding the lock for several seconds. So allow userspace
-	 * to cancel operation. */
-	err = -ERESTARTSYS;
-	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
-		goto out_kfree;
-	sprom_do_read(bus, sprom);
-	mutex_unlock(&bus->pci_sprom_mutex);
+		return -ENODEV;
 
-	count = sprom2hex(sprom, buf, PAGE_SIZE, bus->sprom_size);
-	err = 0;
-
-out_kfree:
-	kfree(sprom);
-out:
-	return err ? err : count;
+	return ssb_attr_sprom_show(bus, buf, sprom_do_read);
 }
 
 static ssize_t ssb_pci_attr_sprom_store(struct device *pcidev,
 					struct device_attribute *attr,
 					const char *buf, size_t count)
 {
 	struct pci_dev *pdev = container_of(pcidev, struct pci_dev, dev);
 	struct ssb_bus *bus;
-	u16 *sprom;
-	int res = 0, err = -ENODEV;
 
 	bus = ssb_pci_dev_to_bus(pdev);
 	if (!bus)
-		goto out;
-	err = -ENOMEM;
-	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
-	if (!sprom)
-		goto out;
-	err = hex2sprom(sprom, buf, count, bus->sprom_size);
-	if (err) {
-		err = -EINVAL;
-		goto out_kfree;
-	}
-	err = sprom_check_crc(sprom, bus->sprom_size);
-	if (err) {
-		err = -EINVAL;
-		goto out_kfree;
-	}
+		return -ENODEV;
 
-	/* Use interruptible locking, as the SPROM write might
-	 * be holding the lock for several seconds. So allow userspace
-	 * to cancel operation. */
-	err = -ERESTARTSYS;
-	if (mutex_lock_interruptible(&bus->pci_sprom_mutex))
-		goto out_kfree;
-	err = ssb_devices_freeze(bus);
-	if (err == -EOPNOTSUPP) {
-		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze devices. "
-			   "No suspend support. Is CONFIG_PM enabled?\n");
-		goto out_unlock;
-	}
-	if (err) {
-		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze all devices\n");
-		goto out_unlock;
-	}
-	res = sprom_do_write(bus, sprom);
-	err = ssb_devices_thaw(bus);
-	if (err)
-		ssb_printk(KERN_ERR PFX "SPROM write: Could not thaw all devices\n");
-out_unlock:
-	mutex_unlock(&bus->pci_sprom_mutex);
-out_kfree:
-	kfree(sprom);
-out:
-	if (res)
-		return res;
-	return err ? err : count;
+	return ssb_attr_sprom_store(bus, buf, count,
+				    sprom_check_crc, sprom_do_write);
 }
 
 static DEVICE_ATTR(ssb_sprom, 0600,
 		   ssb_pci_attr_sprom_show,
 		   ssb_pci_attr_sprom_store);
 
@@ -805,13 +712,13 @@ int ssb_pci_init(struct ssb_bus *bus)
 	int err;
 
 	if (bus->bustype != SSB_BUSTYPE_PCI)
 		return 0;
 
 	pdev = bus->host_pci;
-	mutex_init(&bus->pci_sprom_mutex);
+	mutex_init(&bus->sprom_mutex);
 	err = device_create_file(&pdev->dev, &dev_attr_ssb_sprom);
 	if (err)
 		goto out;
 
 out:
 	return err;
Index: wireless-testing/drivers/ssb/pcmcia.c
===================================================================
--- wireless-testing.orig/drivers/ssb/pcmcia.c	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/drivers/ssb/pcmcia.c	2008-03-10 17:15:52.000000000 +0100
@@ -1,19 +1,20 @@
 /*
  * Sonics Silicon Backplane
  * PCMCIA-Hostbus related functions
  *
  * Copyright 2006 Johannes Berg <johannes@sipsolutions.net>
- * Copyright 2007 Michael Buesch <mb@bu3sch.de>
+ * Copyright 2007-2008 Michael Buesch <mb@bu3sch.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
 #include <linux/ssb/ssb.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/etherdevice.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ciscode.h>
 #include <pcmcia/ds.h>
@@ -23,74 +24,147 @@
 
 
 /* Define the following to 1 to enable a printk on each coreswitch. */
 #define SSB_VERBOSE_PCMCIACORESWITCH_DEBUG		0
 
 
+/* PCMCIA configuration registers */
+#define SSB_PCMCIA_CORECTL		0x00
+#define  SSB_PCMCIA_CORECTL_RESET	0x80 /* Core reset */
+#define  SSB_PCMCIA_CORECTL_IRQEN	0x04 /* IRQ enable */
+#define  SSB_PCMCIA_CORECTL_FUNCEN	0x01 /* Function enable */
+#define SSB_PCMCIA_CORECTL2		0x80
+#define SSB_PCMCIA_ADDRESS0		0x2E
+#define SSB_PCMCIA_ADDRESS1		0x30
+#define SSB_PCMCIA_ADDRESS2		0x32
+#define SSB_PCMCIA_MEMSEG		0x34
+#define SSB_PCMCIA_SPROMCTL		0x36
+#define  SSB_PCMCIA_SPROMCTL_IDLE	0
+#define  SSB_PCMCIA_SPROMCTL_WRITE	1
+#define  SSB_PCMCIA_SPROMCTL_READ	2
+#define  SSB_PCMCIA_SPROMCTL_WRITEEN	4
+#define  SSB_PCMCIA_SPROMCTL_WRITEDIS	7
+#define  SSB_PCMCIA_SPROMCTL_DONE	8
+#define SSB_PCMCIA_SPROM_DATALO		0x38
+#define SSB_PCMCIA_SPROM_DATAHI		0x3A
+#define SSB_PCMCIA_SPROM_ADDRLO		0x3C
+#define SSB_PCMCIA_SPROM_ADDRHI		0x3E
+
+/* Hardware invariants CIS tuples */
+#define SSB_PCMCIA_CIS			0x80
+#define  SSB_PCMCIA_CIS_ID		0x01
+#define  SSB_PCMCIA_CIS_BOARDREV	0x02
+#define  SSB_PCMCIA_CIS_PA		0x03
+#define   SSB_PCMCIA_CIS_PA_PA0B0_LO	0
+#define   SSB_PCMCIA_CIS_PA_PA0B0_HI	1
+#define   SSB_PCMCIA_CIS_PA_PA0B1_LO	2
+#define   SSB_PCMCIA_CIS_PA_PA0B1_HI	3
+#define   SSB_PCMCIA_CIS_PA_PA0B2_LO	4
+#define   SSB_PCMCIA_CIS_PA_PA0B2_HI	5
+#define   SSB_PCMCIA_CIS_PA_ITSSI	6
+#define   SSB_PCMCIA_CIS_PA_MAXPOW	7
+#define  SSB_PCMCIA_CIS_OEMNAME		0x04
+#define  SSB_PCMCIA_CIS_CCODE		0x05
+#define  SSB_PCMCIA_CIS_ANTENNA		0x06
+#define  SSB_PCMCIA_CIS_ANTGAIN		0x07
+#define  SSB_PCMCIA_CIS_BFLAGS		0x08
+#define  SSB_PCMCIA_CIS_LEDS		0x09
+
+/* PCMCIA SPROM size. */
+#define SSB_PCMCIA_SPROM_SIZE		256
+#define SSB_PCMCIA_SPROM_SIZE_BYTES	(SSB_PCMCIA_SPROM_SIZE * sizeof(u16))
+
+
+/* Write to a PCMCIA configuration register. */
+static int ssb_pcmcia_cfg_write(struct ssb_bus *bus, u8 offset, u8 value)
+{
+	conf_reg_t reg;
+	int res;
+
+	memset(&reg, 0, sizeof(reg));
+	reg.Offset = offset;
+	reg.Action = CS_WRITE;
+	reg.Value = value;
+	res = pcmcia_access_configuration_register(bus->host_pcmcia, &reg);
+	if (unlikely(res != CS_SUCCESS))
+		return -EBUSY;
+
+	return 0;
+}
+
+/* Read from a PCMCIA configuration register. */
+static int ssb_pcmcia_cfg_read(struct ssb_bus *bus, u8 offset, u8 *value)
+{
+	conf_reg_t reg;
+	int res;
+
+	memset(&reg, 0, sizeof(reg));
+	reg.Offset = offset;
+	reg.Action = CS_READ;
+	res = pcmcia_access_configuration_register(bus->host_pcmcia, &reg);
+	if (unlikely(res != CS_SUCCESS))
+		return -EBUSY;
+	*value = reg.Value;
+
+	return 0;
+}
+
 int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
 			      u8 coreidx)
 {
-	struct pcmcia_device *pdev = bus->host_pcmcia;
 	int err;
 	int attempts = 0;
 	u32 cur_core;
-	conf_reg_t reg;
 	u32 addr;
 	u32 read_addr;
+	u8 val;
 
 	addr = (coreidx * SSB_CORE_SIZE) + SSB_ENUM_BASE;
 	while (1) {
-		reg.Action = CS_WRITE;
-		reg.Offset = 0x2E;
-		reg.Value = (addr & 0x0000F000) >> 12;
-		err = pcmcia_access_configuration_register(pdev, &reg);
-		if (err != CS_SUCCESS)
+		err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_ADDRESS0,
+					   (addr & 0x0000F000) >> 12);
+		if (err)
 			goto error;
-		reg.Offset = 0x30;
-		reg.Value = (addr & 0x00FF0000) >> 16;
-		err = pcmcia_access_configuration_register(pdev, &reg);
-		if (err != CS_SUCCESS)
+		err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_ADDRESS1,
+					   (addr & 0x00FF0000) >> 16);
+		if (err)
 			goto error;
-		reg.Offset = 0x32;
-		reg.Value = (addr & 0xFF000000) >> 24;
-		err = pcmcia_access_configuration_register(pdev, &reg);
-		if (err != CS_SUCCESS)
+		err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_ADDRESS2,
+					   (addr & 0xFF000000) >> 24);
+		if (err)
 			goto error;
 
 		read_addr = 0;
 
-		reg.Action = CS_READ;
-		reg.Offset = 0x2E;
-		err = pcmcia_access_configuration_register(pdev, &reg);
-		if (err != CS_SUCCESS)
+		err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_ADDRESS0, &val);
+		if (err)
 			goto error;
-		read_addr |= ((u32)(reg.Value & 0x0F)) << 12;
-		reg.Offset = 0x30;
-		err = pcmcia_access_configuration_register(pdev, &reg);
-		if (err != CS_SUCCESS)
+		read_addr |= ((u32)(val & 0x0F)) << 12;
+		err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_ADDRESS1, &val);
+		if (err)
 			goto error;
-		read_addr |= ((u32)reg.Value) << 16;
-		reg.Offset = 0x32;
-		err = pcmcia_access_configuration_register(pdev, &reg);
-		if (err != CS_SUCCESS)
+		read_addr |= ((u32)val) << 16;
+		err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_ADDRESS2, &val);
+		if (err)
 			goto error;
-		read_addr |= ((u32)reg.Value) << 24;
+		read_addr |= ((u32)val) << 24;
 
 		cur_core = (read_addr - SSB_ENUM_BASE) / SSB_CORE_SIZE;
 		if (cur_core == coreidx)
 			break;
 
+		err = -ETIMEDOUT;
 		if (attempts++ > SSB_BAR0_MAX_RETRIES)
 			goto error;
 		udelay(10);
 	}
 
 	return 0;
 error:
 	ssb_printk(KERN_ERR PFX "Failed to switch to core %u\n", coreidx);
-	return -ENODEV;
+	return err;
 }
 
 int ssb_pcmcia_switch_core(struct ssb_bus *bus,
 			   struct ssb_device *dev)
 {
 	int err;
@@ -109,43 +183,37 @@ int ssb_pcmcia_switch_core(struct ssb_bu
 	return err;
 }
 
 int ssb_pcmcia_switch_segment(struct ssb_bus *bus, u8 seg)
 {
 	int attempts = 0;
-	conf_reg_t reg;
-	int res;
+	int err;
+	u8 val;
 
 	SSB_WARN_ON((seg != 0) && (seg != 1));
-	reg.Offset = 0x34;
-	reg.Function = 0;
 	while (1) {
-		reg.Action = CS_WRITE;
-		reg.Value = seg;
-		res = pcmcia_access_configuration_register(bus->host_pcmcia, &reg);
-		if (unlikely(res != CS_SUCCESS))
+		err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_MEMSEG, seg);
+		if (err)
 			goto error;
-		reg.Value = 0xFF;
-		reg.Action = CS_READ;
-		res = pcmcia_access_configuration_register(bus->host_pcmcia, &reg);
-		if (unlikely(res != CS_SUCCESS))
+		err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_MEMSEG, &val);
+		if (err)
 			goto error;
-
-		if (reg.Value == seg)
+		if (val == seg)
 			break;
 
+		err = -ETIMEDOUT;
 		if (unlikely(attempts++ > SSB_BAR0_MAX_RETRIES))
 			goto error;
 		udelay(10);
 	}
 	bus->mapped_pcmcia_seg = seg;
 
 	return 0;
 error:
 	ssb_printk(KERN_ERR PFX "Failed to switch pcmcia segment\n");
-	return -ENODEV;
+	return err;
 }
 
 static int select_core_and_segment(struct ssb_device *dev,
 				   u16 *offset)
 {
 	struct ssb_bus *bus = dev->bus;
@@ -273,47 +341,377 @@ const struct ssb_bus_ops ssb_pcmcia_ops 
 	.read32		= ssb_pcmcia_read32,
 	.write8		= ssb_pcmcia_write8,
 	.write16	= ssb_pcmcia_write16,
 	.write32	= ssb_pcmcia_write32,
 };
 
-#include <linux/etherdevice.h>
+static int ssb_pcmcia_sprom_command(struct ssb_bus *bus, u8 command)
+{
+	unsigned int i;
+	int err;
+	u8 value;
+
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROMCTL, command);
+	if (err)
+		return err;
+	for (i = 0; i < 1000; i++) {
+		err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_SPROMCTL, &value);
+		if (err)
+			return err;
+		if (value & SSB_PCMCIA_SPROMCTL_DONE)
+			return 0;
+		udelay(10);
+	}
+
+	return -ETIMEDOUT;
+}
+
+/* offset is the 16bit word offset */
+static int ssb_pcmcia_sprom_read(struct ssb_bus *bus, u16 offset, u16 *value)
+{
+	int err;
+	u8 lo, hi;
+
+	offset *= 2; /* Make byte offset */
+
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROM_ADDRLO,
+				   (offset & 0x00FF));
+	if (err)
+		return err;
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROM_ADDRHI,
+				   (offset & 0xFF00) >> 8);
+	if (err)
+		return err;
+	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_READ);
+	if (err)
+		return err;
+	err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_SPROM_DATALO, &lo);
+	if (err)
+		return err;
+	err = ssb_pcmcia_cfg_read(bus, SSB_PCMCIA_SPROM_DATAHI, &hi);
+	if (err)
+		return err;
+	*value = (lo | (((u16)hi) << 8));
+
+	return 0;
+}
+
+/* offset is the 16bit word offset */
+static int ssb_pcmcia_sprom_write(struct ssb_bus *bus, u16 offset, u16 value)
+{
+	int err;
+
+	offset *= 2; /* Make byte offset */
+
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROM_ADDRLO,
+				   (offset & 0x00FF));
+	if (err)
+		return err;
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROM_ADDRHI,
+				   (offset & 0xFF00) >> 8);
+	if (err)
+		return err;
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROM_DATALO,
+				   (value & 0x00FF));
+	if (err)
+		return err;
+	err = ssb_pcmcia_cfg_write(bus, SSB_PCMCIA_SPROM_DATAHI,
+				   (value & 0xFF00) >> 8);
+	if (err)
+		return err;
+	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_WRITE);
+	if (err)
+		return err;
+	msleep(20);
+
+	return 0;
+}
+
+/* Read the SPROM image. bufsize is in 16bit words. */
+static int ssb_pcmcia_sprom_read_all(struct ssb_bus *bus, u16 *sprom)
+{
+	int err, i;
+
+	for (i = 0; i < SSB_PCMCIA_SPROM_SIZE; i++) {
+		err = ssb_pcmcia_sprom_read(bus, i, &sprom[i]);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+/* Write the SPROM image. size is in 16bit words. */
+static int ssb_pcmcia_sprom_write_all(struct ssb_bus *bus, const u16 *sprom)
+{
+	int i, err;
+	bool failed = 0;
+	size_t size = SSB_PCMCIA_SPROM_SIZE;
+
+	ssb_printk(KERN_NOTICE PFX
+		   "Writing SPROM. Do NOT turn off the power! "
+		   "Please stand by...\n");
+	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_WRITEEN);
+	if (err) {
+		ssb_printk(KERN_NOTICE PFX
+			   "Could not enable SPROM write access.\n");
+		return -EBUSY;
+	}
+	ssb_printk(KERN_NOTICE PFX "[ 0%%");
+	msleep(500);
+	for (i = 0; i < size; i++) {
+		if (i == size / 4)
+			ssb_printk("25%%");
+		else if (i == size / 2)
+			ssb_printk("50%%");
+		else if (i == (size * 3) / 4)
+			ssb_printk("75%%");
+		else if (i % 2)
+			ssb_printk(".");
+		err = ssb_pcmcia_sprom_write(bus, i, sprom[i]);
+		if (err) {
+			ssb_printk("\n" KERN_NOTICE PFX
+				   "Failed to write to SPROM.\n");
+			failed = 1;
+			break;
+		}
+	}
+	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_WRITEDIS);
+	if (err) {
+		ssb_printk("\n" KERN_NOTICE PFX
+			   "Could not disable SPROM write access.\n");
+		failed = 1;
+	}
+	msleep(500);
+	if (!failed) {
+		ssb_printk("100%% ]\n");
+		ssb_printk(KERN_NOTICE PFX "SPROM written.\n");
+	}
+
+	return failed ? -EBUSY : 0;
+}
+
+static int ssb_pcmcia_sprom_check_crc(const u16 *sprom, size_t size)
+{
+	//TODO
+	return 0;
+}
+
+#define GOTO_ERROR_ON(condition, description) do {	\
+	if (unlikely(condition)) {			\
+		error_description = description;	\
+		goto error;				\
+	}						\
+  } while (0)
+
 int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 			      struct ssb_init_invariants *iv)
 {
-	//TODO
-	random_ether_addr(iv->sprom.il0mac);
+	tuple_t tuple;
+	int res;
+	unsigned char buf[32];
+	struct ssb_sprom *sprom = &iv->sprom;
+	struct ssb_boardinfo *bi = &iv->boardinfo;
+	const char *error_description;
+
+	memset(sprom, 0xFF, sizeof(*sprom));
+	sprom->revision = 1;
+	sprom->boardflags_lo = 0;
+	sprom->boardflags_hi = 0;
+
+	/* First fetch the MAC address. */
+	memset(&tuple, 0, sizeof(tuple));
+	tuple.DesiredTuple = CISTPL_FUNCE;
+	tuple.TupleData = buf;
+	tuple.TupleDataMax = sizeof(buf);
+	res = pcmcia_get_first_tuple(bus->host_pcmcia, &tuple);
+	GOTO_ERROR_ON(res != CS_SUCCESS, "MAC first tpl");
+	res = pcmcia_get_tuple_data(bus->host_pcmcia, &tuple);
+	GOTO_ERROR_ON(res != CS_SUCCESS, "MAC first tpl data");
+	while (1) {
+		GOTO_ERROR_ON(tuple.TupleDataLen < 1, "MAC tpl < 1");
+		if (tuple.TupleData[0] == CISTPL_FUNCE_LAN_NODE_ID)
+			break;
+		res = pcmcia_get_next_tuple(bus->host_pcmcia, &tuple);
+		GOTO_ERROR_ON(res != CS_SUCCESS, "MAC next tpl");
+		res = pcmcia_get_tuple_data(bus->host_pcmcia, &tuple);
+		GOTO_ERROR_ON(res != CS_SUCCESS, "MAC next tpl data");
+	}
+	GOTO_ERROR_ON(tuple.TupleDataLen != ETH_ALEN + 2, "MAC tpl size");
+	memcpy(sprom->il0mac, &tuple.TupleData[2], ETH_ALEN);
+
+	/* Fetch the vendor specific tuples. */
+	memset(&tuple, 0, sizeof(tuple));
+	tuple.DesiredTuple = SSB_PCMCIA_CIS;
+	tuple.TupleData = buf;
+	tuple.TupleDataMax = sizeof(buf);
+	res = pcmcia_get_first_tuple(bus->host_pcmcia, &tuple);
+	GOTO_ERROR_ON(res != CS_SUCCESS, "VEN first tpl");
+	res = pcmcia_get_tuple_data(bus->host_pcmcia, &tuple);
+	GOTO_ERROR_ON(res != CS_SUCCESS, "VEN first tpl data");
+	while (1) {
+		GOTO_ERROR_ON(tuple.TupleDataLen < 1, "VEN tpl < 1");
+		switch (tuple.TupleData[0]) {
+		case SSB_PCMCIA_CIS_ID:
+			GOTO_ERROR_ON((tuple.TupleDataLen != 5) &&
+				      (tuple.TupleDataLen != 7),
+				      "id tpl size");
+			bi->vendor = tuple.TupleData[1] |
+			       ((u16)tuple.TupleData[2] << 8);
+			break;
+		case SSB_PCMCIA_CIS_BOARDREV:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 2,
+				      "boardrev tpl size");
+			sprom->board_rev = tuple.TupleData[1];
+			break;
+		case SSB_PCMCIA_CIS_PA:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 9,
+				      "pa tpl size");
+			sprom->pa0b0 = tuple.TupleData[1] |
+				 ((u16)tuple.TupleData[2] << 8);
+			sprom->pa0b1 = tuple.TupleData[3] |
+				 ((u16)tuple.TupleData[4] << 8);
+			sprom->pa0b2 = tuple.TupleData[5] |
+				 ((u16)tuple.TupleData[6] << 8);
+			sprom->itssi_a = tuple.TupleData[7];
+			sprom->itssi_bg = tuple.TupleData[7];
+			sprom->maxpwr_a = tuple.TupleData[8];
+			sprom->maxpwr_bg = tuple.TupleData[8];
+			break;
+		case SSB_PCMCIA_CIS_OEMNAME:
+			/* We ignore this. */
+			break;
+		case SSB_PCMCIA_CIS_CCODE:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 2,
+				      "ccode tpl size");
+			sprom->country_code = tuple.TupleData[1];
+			break;
+		case SSB_PCMCIA_CIS_ANTENNA:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 2,
+				      "ant tpl size");
+			sprom->ant_available_a = tuple.TupleData[1];
+			sprom->ant_available_bg = tuple.TupleData[1];
+			break;
+		case SSB_PCMCIA_CIS_ANTGAIN:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 2,
+				      "antg tpl size");
+			sprom->antenna_gain.ghz24.a0 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz24.a1 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz24.a2 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz24.a3 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz5.a0 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz5.a1 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz5.a2 = tuple.TupleData[1];
+			sprom->antenna_gain.ghz5.a3 = tuple.TupleData[1];
+			break;
+		case SSB_PCMCIA_CIS_BFLAGS:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 3,
+				      "bfl tpl size");
+			sprom->boardflags_lo = tuple.TupleData[1] |
+					 ((u16)tuple.TupleData[2] << 8);
+			break;
+		case SSB_PCMCIA_CIS_LEDS:
+			GOTO_ERROR_ON(tuple.TupleDataLen != 5,
+				      "leds tpl size");
+			sprom->gpio0 = tuple.TupleData[1];
+			sprom->gpio1 = tuple.TupleData[2];
+			sprom->gpio2 = tuple.TupleData[3];
+			sprom->gpio3 = tuple.TupleData[4];
+			break;
+		}
+		res = pcmcia_get_next_tuple(bus->host_pcmcia, &tuple);
+		if (res == CS_NO_MORE_ITEMS)
+			break;
+		GOTO_ERROR_ON(res != CS_SUCCESS, "VEN next tpl");
+		res = pcmcia_get_tuple_data(bus->host_pcmcia, &tuple);
+		GOTO_ERROR_ON(res != CS_SUCCESS, "VEN next tpl data");
+	}
+
 	return 0;
+error:
+	ssb_printk(KERN_ERR PFX
+		   "PCMCIA: Failed to fetch device invariants: %s\n",
+		   error_description);
+	return -ENODEV;
+}
+
+static ssize_t ssb_pcmcia_attr_sprom_show(struct device *pcmciadev,
+					  struct device_attribute *attr,
+					  char *buf)
+{
+	struct pcmcia_device *pdev =
+		container_of(pcmciadev, struct pcmcia_device, dev);
+	struct ssb_bus *bus;
+
+	bus = ssb_pcmcia_dev_to_bus(pdev);
+	if (!bus)
+		return -ENODEV;
+
+	return ssb_attr_sprom_show(bus, buf,
+				   ssb_pcmcia_sprom_read_all);
+}
+
+static ssize_t ssb_pcmcia_attr_sprom_store(struct device *pcmciadev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct pcmcia_device *pdev =
+		container_of(pcmciadev, struct pcmcia_device, dev);
+	struct ssb_bus *bus;
+
+	bus = ssb_pcmcia_dev_to_bus(pdev);
+	if (!bus)
+		return -ENODEV;
+
+	return ssb_attr_sprom_store(bus, buf, count,
+				    ssb_pcmcia_sprom_check_crc,
+				    ssb_pcmcia_sprom_write_all);
+}
+
+static DEVICE_ATTR(ssb_sprom, 0600,
+		   ssb_pcmcia_attr_sprom_show,
+		   ssb_pcmcia_attr_sprom_store);
+
+void ssb_pcmcia_exit(struct ssb_bus *bus)
+{
+	if (bus->bustype != SSB_BUSTYPE_PCMCIA)
+		return;
+
+	device_remove_file(&bus->host_pcmcia->dev, &dev_attr_ssb_sprom);
 }
 
 int ssb_pcmcia_init(struct ssb_bus *bus)
 {
-	conf_reg_t reg;
+	u8 val, offset;
 	int err;
 
 	if (bus->bustype != SSB_BUSTYPE_PCMCIA)
 		return 0;
 
 	/* Switch segment to a known state and sync
 	 * bus->mapped_pcmcia_seg with hardware state. */
 	ssb_pcmcia_switch_segment(bus, 0);
 
 	/* Init IRQ routing */
-	reg.Action = CS_READ;
-	reg.Function = 0;
 	if (bus->chip_id == 0x4306)
-		reg.Offset = 0x00;
+		offset = SSB_PCMCIA_CORECTL;
 	else
-		reg.Offset = 0x80;
-	err = pcmcia_access_configuration_register(bus->host_pcmcia, &reg);
-	if (err != CS_SUCCESS)
+		offset = SSB_PCMCIA_CORECTL2;
+	err = ssb_pcmcia_cfg_read(bus, offset, &val);
+	if (err)
 		goto error;
-	reg.Action = CS_WRITE;
-	reg.Value |= 0x04 | 0x01;
-	err = pcmcia_access_configuration_register(bus->host_pcmcia, &reg);
-	if (err != CS_SUCCESS)
+	val |= SSB_PCMCIA_CORECTL_IRQEN | SSB_PCMCIA_CORECTL_FUNCEN;
+	err = ssb_pcmcia_cfg_write(bus, offset, val);
+	if (err)
+		goto error;
+
+	bus->sprom_size = SSB_PCMCIA_SPROM_SIZE;
+	mutex_init(&bus->sprom_mutex);
+	err = device_create_file(&bus->host_pcmcia->dev, &dev_attr_ssb_sprom);
+	if (err)
 		goto error;
 
 	return 0;
 error:
-	return -ENODEV;
+	ssb_printk(KERN_ERR PFX "Failed to initialize PCMCIA host device\n");
+	return err;
 }
Index: wireless-testing/drivers/ssb/sprom.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/drivers/ssb/sprom.c	2008-03-10 17:15:52.000000000 +0100
@@ -0,0 +1,133 @@
+/*
+ * Sonics Silicon Backplane
+ * Common SPROM support routines
+ *
+ * Copyright (C) 2005-2008 Michael Buesch <mb@bu3sch.de>
+ * Copyright (C) 2005 Martin Langer <martin-langer@gmx.de>
+ * Copyright (C) 2005 Stefano Brivio <st3@riseup.net>
+ * Copyright (C) 2005 Danny van Dyk <kugelfang@gentoo.org>
+ * Copyright (C) 2005 Andreas Jaggi <andreas.jaggi@waterwave.ch>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "ssb_private.h"
+
+
+static int sprom2hex(const u16 *sprom, char *buf, size_t buf_len,
+		     size_t sprom_size_words)
+{
+	int i, pos = 0;
+
+	for (i = 0; i < sprom_size_words; i++)
+		pos += snprintf(buf + pos, buf_len - pos - 1,
+				"%04X", swab16(sprom[i]) & 0xFFFF);
+	pos += snprintf(buf + pos, buf_len - pos - 1, "\n");
+
+	return pos + 1;
+}
+
+static int hex2sprom(u16 *sprom, const char *dump, size_t len,
+		     size_t sprom_size_words)
+{
+	char tmp[5] = { 0 };
+	int cnt = 0;
+	unsigned long parsed;
+
+	if (len < sprom_size_words * 2)
+		return -EINVAL;
+
+	while (cnt < sprom_size_words) {
+		memcpy(tmp, dump, 4);
+		dump += 4;
+		parsed = simple_strtoul(tmp, NULL, 16);
+		sprom[cnt++] = swab16((u16)parsed);
+	}
+
+	return 0;
+}
+
+/* Common sprom device-attribute show-handler */
+ssize_t ssb_attr_sprom_show(struct ssb_bus *bus, char *buf,
+			    int (*sprom_read)(struct ssb_bus *bus, u16 *sprom))
+{
+	u16 *sprom;
+	int err = -ENOMEM;
+	ssize_t count = 0;
+	size_t sprom_size_words = bus->sprom_size;
+
+	sprom = kcalloc(sprom_size_words, sizeof(u16), GFP_KERNEL);
+	if (!sprom)
+		goto out;
+
+	/* Use interruptible locking, as the SPROM write might
+	 * be holding the lock for several seconds. So allow userspace
+	 * to cancel operation. */
+	err = -ERESTARTSYS;
+	if (mutex_lock_interruptible(&bus->sprom_mutex))
+		goto out_kfree;
+	err = sprom_read(bus, sprom);
+	mutex_unlock(&bus->sprom_mutex);
+
+	if (!err)
+		count = sprom2hex(sprom, buf, PAGE_SIZE, sprom_size_words);
+
+out_kfree:
+	kfree(sprom);
+out:
+	return err ? err : count;
+}
+
+/* Common sprom device-attribute store-handler */
+ssize_t ssb_attr_sprom_store(struct ssb_bus *bus,
+			     const char *buf, size_t count,
+			     int (*sprom_check_crc)(const u16 *sprom, size_t size),
+			     int (*sprom_write)(struct ssb_bus *bus, const u16 *sprom))
+{
+	u16 *sprom;
+	int res = 0, err = -ENOMEM;
+	size_t sprom_size_words = bus->sprom_size;
+
+	sprom = kcalloc(bus->sprom_size, sizeof(u16), GFP_KERNEL);
+	if (!sprom)
+		goto out;
+	err = hex2sprom(sprom, buf, count, sprom_size_words);
+	if (err) {
+		err = -EINVAL;
+		goto out_kfree;
+	}
+	err = sprom_check_crc(sprom, sprom_size_words);
+	if (err) {
+		err = -EINVAL;
+		goto out_kfree;
+	}
+
+	/* Use interruptible locking, as the SPROM write might
+	 * be holding the lock for several seconds. So allow userspace
+	 * to cancel operation. */
+	err = -ERESTARTSYS;
+	if (mutex_lock_interruptible(&bus->sprom_mutex))
+		goto out_kfree;
+	err = ssb_devices_freeze(bus);
+	if (err == -EOPNOTSUPP) {
+		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze devices. "
+			   "No suspend support. Is CONFIG_PM enabled?\n");
+		goto out_unlock;
+	}
+	if (err) {
+		ssb_printk(KERN_ERR PFX "SPROM write: Could not freeze all devices\n");
+		goto out_unlock;
+	}
+	res = sprom_write(bus, sprom);
+	err = ssb_devices_thaw(bus);
+	if (err)
+		ssb_printk(KERN_ERR PFX "SPROM write: Could not thaw all devices\n");
+out_unlock:
+	mutex_unlock(&bus->sprom_mutex);
+out_kfree:
+	kfree(sprom);
+out:
+	if (res)
+		return res;
+	return err ? err : count;
+}
Index: wireless-testing/drivers/ssb/ssb_private.h
===================================================================
--- wireless-testing.orig/drivers/ssb/ssb_private.h	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/drivers/ssb/ssb_private.h	2008-03-10 17:15:52.000000000 +0100
@@ -78,12 +78,13 @@ extern int ssb_pcmcia_switch_core(struct
 extern int ssb_pcmcia_switch_coreidx(struct ssb_bus *bus,
 				     u8 coreidx);
 extern int ssb_pcmcia_switch_segment(struct ssb_bus *bus,
 				     u8 seg);
 extern int ssb_pcmcia_get_invariants(struct ssb_bus *bus,
 				     struct ssb_init_invariants *iv);
+extern void ssb_pcmcia_exit(struct ssb_bus *bus);
 extern int ssb_pcmcia_init(struct ssb_bus *bus);
 extern const struct ssb_bus_ops ssb_pcmcia_ops;
 #else /* CONFIG_SSB_PCMCIAHOST */
 static inline int ssb_pcmcia_switch_core(struct ssb_bus *bus,
 					 struct ssb_device *dev)
 {
@@ -96,12 +97,15 @@ static inline int ssb_pcmcia_switch_core
 }
 static inline int ssb_pcmcia_switch_segment(struct ssb_bus *bus,
 					    u8 seg)
 {
 	return 0;
 }
+static inline void ssb_pcmcia_exit(struct ssb_bus *bus)
+{
+}
 static inline int ssb_pcmcia_init(struct ssb_bus *bus)
 {
 	return 0;
 }
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
@@ -110,17 +114,30 @@ static inline int ssb_pcmcia_init(struct
 extern const char *ssb_core_name(u16 coreid);
 extern int ssb_bus_scan(struct ssb_bus *bus,
 			unsigned long baseaddr);
 extern void ssb_iounmap(struct ssb_bus *ssb);
 
 
+/* sprom.c */
+extern
+ssize_t ssb_attr_sprom_show(struct ssb_bus *bus, char *buf,
+			    int (*sprom_read)(struct ssb_bus *bus, u16 *sprom));
+extern
+ssize_t ssb_attr_sprom_store(struct ssb_bus *bus,
+			     const char *buf, size_t count,
+			     int (*sprom_check_crc)(const u16 *sprom, size_t size),
+			     int (*sprom_write)(struct ssb_bus *bus, const u16 *sprom));
+
+
 /* core.c */
 extern u32 ssb_calc_clock_rate(u32 plltype, u32 n, u32 m);
 extern int ssb_devices_freeze(struct ssb_bus *bus);
 extern int ssb_devices_thaw(struct ssb_bus *bus);
 extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);
+extern struct ssb_bus *ssb_pcmcia_dev_to_bus(struct pcmcia_device *pdev);
+
 
 /* b43_pci_bridge.c */
 #ifdef CONFIG_SSB_B43_PCI_BRIDGE
 extern int __init b43_pci_ssb_bridge_init(void);
 extern void __exit b43_pci_ssb_bridge_exit(void);
 #else /* CONFIG_SSB_B43_PCI_BRIDGR */
Index: wireless-testing/include/linux/ssb/ssb.h
===================================================================
--- wireless-testing.orig/include/linux/ssb/ssb.h	2008-03-10 17:15:50.000000000 +0100
+++ wireless-testing/include/linux/ssb/ssb.h	2008-03-10 17:23:43.000000000 +0100
@@ -242,15 +242,15 @@ struct ssb_bus {
 	enum ssb_bustype bustype;
 	/* Pointer to the PCI bus (only valid if bustype == SSB_BUSTYPE_PCI). */
 	struct pci_dev *host_pci;
 	/* Pointer to the PCMCIA device (only if bustype == SSB_BUSTYPE_PCMCIA). */
 	struct pcmcia_device *host_pcmcia;
 
-#ifdef CONFIG_SSB_PCIHOST
+#ifdef CONFIG_SSB_SPROM
 	/* Mutex to protect the SPROM writing. */
-	struct mutex pci_sprom_mutex;
+	struct mutex sprom_mutex;
 #endif
 
 	/* ID information about the Chip. */
 	u16 chip_id;
 	u16 chip_rev;
 	u16 sprom_size;		/* number of words in sprom */
