Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50416 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2HJAXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 20:23:13 -0400
Received: by yhmm54 with SMTP id m54so1124993yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 17:23:12 -0700 (PDT)
Date: Thu, 9 Aug 2012 19:23:05 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: [RFC] bcma: add cc core driver, expose sprom to sysfs
Message-ID: <20120810002305.GA5966@eris.garyseven.net> (sfid-20120810_022351_490818_28E18424)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adds a driver for BCMA ChipCommon cores, registers the struct device 
bcma_bus.drv_cc->core->dev with device_register(), and exposes the SPROM
in rev 31+ cc cores as a R/W sysfs attribute.

Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
---
 drivers/bcma/bcma_private.h                 |    6 +
 drivers/bcma/driver_chipcommon.c            |  238 +++++++++++++++++++++++++--
 drivers/bcma/main.c                         |    8 +-
 drivers/bcma/sprom.c                        |   47 +++++-
 include/linux/bcma/bcma_driver_chipcommon.h |    4 +-
 5 files changed, 280 insertions(+), 23 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3cf9cc9..fda6614 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -41,11 +41,17 @@ void bcma_init_bus(struct bcma_bus *bus);
 
 /* sprom.c */
 int bcma_sprom_get(struct bcma_bus *bus);
+int bcma_sprom_valid(const u16 *sprom);
+void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom);
+int bcma_sprom_fromhex(u16 *sprom, const char *dump, size_t len);
+int bcma_sprom_tohex(const u16 *sprom, char *buf, size_t buf_len);
 
 /* driver_chipcommon.c */
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
+void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
+extern struct bcma_driver bcma_core_cc_driver;
 
 /* driver_chipcommon_pmu.c */
 u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index a4c3ebc..8d7d23a 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -22,42 +22,246 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 	return value;
 }
 
-void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
+static u16 bcma_cc_srom_cmd(struct bcma_device *cc, u32 cmd,
+			    uint wordoff, u16 data)
+{
+	u16 res = 0xffff;
+	uint wait_cnt = 1000;
+
+	if ((cmd == BCMA_CC_SROM_CONTROL_OP_READ) ||
+	    (cmd == BCMA_CC_SROM_CONTROL_OP_WRITE)) {
+		bcma_write32(cc, BCMA_CC_SROM_ADDRESS, wordoff * 2);
+		if (cmd == BCMA_CC_SROM_CONTROL_OP_WRITE)
+			bcma_write32(cc, BCMA_CC_SROM_DATA, data);
+	}
+
+	bcma_write32(cc, BCMA_CC_SROM_CONTROL,
+			BCMA_CC_SROM_CONTROL_START | cmd);
+
+	while (wait_cnt--) {
+		uint tmp = bcma_read32(cc, BCMA_CC_SROM_CONTROL);
+		if ((tmp & BCMA_CC_SROM_CONTROL_BUSY) == 0)
+			break;
+	}
+
+	if (!wait_cnt)
+		bcma_warn(cc->bus, "timed out waiting for busy to clear.\n");
+	else if (cmd == BCMA_CC_SROM_CONTROL_OP_READ)
+		res = (u16)bcma_read32(cc, BCMA_CC_SROM_DATA);
+
+	return res;
+}
+
+static ssize_t bcma_core_cc_attr_sprom_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	u16 *sprom;
+	int i;
+	ssize_t res = -ERESTARTSYS;
+
+	struct bcma_device *cc = container_of(dev, struct bcma_device, dev);
+
+	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
+			GFP_KERNEL);
+	if (!sprom)
+		return -ENOMEM;
+
+	if (mutex_lock_interruptible(&cc->dev.mutex))
+		goto out_kfree;
+
+	if (cc->bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
+	    cc->bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(&cc->bus->drv_cc,
+						     false);
+
+	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++)
+		sprom[i] = bcma_cc_srom_cmd(cc, BCMA_CC_SROM_CONTROL_OP_READ,
+					    i, 0);
+
+	if (cc->bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
+	    cc->bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(&cc->bus->drv_cc,
+						     true);
+
+	mutex_unlock(&cc->dev.mutex);
+
+	res = bcma_sprom_tohex(sprom, buf, PAGE_SIZE);
+
+out_kfree:
+	kfree(sprom);
+
+	return res;
+}
+
+static ssize_t bcma_core_cc_attr_sprom_store(struct device *dev,
+						struct device_attribute *attr,
+						const char *buf, size_t count)
+{
+	u16 *sprom;
+	int err, i;
+
+	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
+
+	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16), GFP_KERNEL);
+	if (!sprom)
+		return -ENOMEM;
+
+	err = bcma_sprom_fromhex(sprom, buf, count);
+	if (!err)
+		err = bcma_sprom_valid(sprom);
+	if (err)
+		goto out_kfree;
+
+	if (mutex_lock_interruptible(&core->dev.mutex)) {
+		err = -ERESTARTSYS;
+		goto out_kfree;
+	}
+
+	if (core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
+	    core->bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(&core->bus->drv_cc,
+						     false);
+
+	bcma_warn(core->bus,
+		"Writing SPROM. Do NOT turn off the power! "
+		"Please stand by...\n");
+
+	bcma_cc_srom_cmd(core, BCMA_CC_SROM_CONTROL_OP_WREN, 0, 0);
+
+	msleep(500);
+
+	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++) {
+		if (i == SSB_SPROMSIZE_WORDS_R4 / 4)
+			bcma_warn(core->bus, "SPROM write 25%% complete.\n");
+		else if (i == SSB_SPROMSIZE_WORDS_R4 / 2)
+			bcma_warn(core->bus, "SPROM write 50%% complete.\n");
+		else if (i == (SSB_SPROMSIZE_WORDS_R4 * 3) / 4)
+			bcma_warn(core->bus, "SPROM write 75%% complete.\n");
+		bcma_cc_srom_cmd(core, BCMA_CC_SROM_CONTROL_OP_WRITE,
+				 i, sprom[i]);
+		msleep(20);
+	}
+
+	bcma_cc_srom_cmd(core, BCMA_CC_SROM_CONTROL_OP_WRDIS, 0, 0);
+
+	msleep(500);
+
+	bcma_warn(core->bus, "SPROM wrte complete.\n");
+
+	if (core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4331 ||
+	    core->bus->chipinfo.id == BCMA_CHIP_ID_BCM43431)
+		bcma_chipco_bcm4331_ext_pa_lines_ctl(&core->bus->drv_cc,
+						     true);
+
+	mutex_unlock(&core->dev.mutex);
+
+	bcma_sprom_extract_r8(core->bus, sprom);
+
+out_kfree:
+	kfree(sprom);
+
+	return err ? err : count;
+}
+
+static DEVICE_ATTR(sprom, 0600, bcma_core_cc_attr_sprom_show,
+				bcma_core_cc_attr_sprom_store);
+
+
+static int bcma_core_cc_probe(struct bcma_device *core)
 {
 	u32 leddc_on = 10;
 	u32 leddc_off = 90;
 
-	if (cc->setup_done)
-		return;
+	struct bcma_drv_cc *cc = &core->bus->drv_cc;
 
-	if (cc->core->id.rev >= 11)
-		cc->status = bcma_cc_read32(cc, BCMA_CC_CHIPSTAT);
-	cc->capabilities = bcma_cc_read32(cc, BCMA_CC_CAP);
-	if (cc->core->id.rev >= 35)
-		cc->capabilities_ext = bcma_cc_read32(cc, BCMA_CC_CAP_EXT);
+	if (core->id.rev >= 11)
+		cc->status = bcma_read32(core, BCMA_CC_CHIPSTAT);
+	cc->capabilities = bcma_read32(core, BCMA_CC_CAP);
+	if (core->id.rev >= 35)
+		cc->capabilities_ext = bcma_read32(core, BCMA_CC_CAP_EXT);
 
-	if (cc->core->id.rev >= 20) {
-		bcma_cc_write32(cc, BCMA_CC_GPIOPULLUP, 0);
-		bcma_cc_write32(cc, BCMA_CC_GPIOPULLDOWN, 0);
+	if (core->id.rev >= 20) {
+		bcma_write32(core, BCMA_CC_GPIOPULLUP, 0);
+		bcma_write32(core, BCMA_CC_GPIOPULLDOWN, 0);
 	}
 
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		bcma_pmu_init(cc);
 	if (cc->capabilities & BCMA_CC_CAP_PCTL)
-		bcma_err(cc->core->bus, "Power control not implemented!\n");
+		bcma_err(core->bus, "Power control not implemented!\n");
 
-	if (cc->core->id.rev >= 16) {
-		if (cc->core->bus->sprom.leddc_on_time &&
-		    cc->core->bus->sprom.leddc_off_time) {
-			leddc_on = cc->core->bus->sprom.leddc_on_time;
-			leddc_off = cc->core->bus->sprom.leddc_off_time;
+	if (core->id.rev >= 16) {
+		if (core->bus->sprom.leddc_on_time &&
+		    core->bus->sprom.leddc_off_time) {
+			leddc_on = core->bus->sprom.leddc_on_time;
+			leddc_off = core->bus->sprom.leddc_off_time;
 		}
 		bcma_cc_write32(cc, BCMA_CC_GPIOTIMER,
 			((leddc_on << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
 			 (leddc_off << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT)));
 	}
 
+	if (core->id.rev >= 31 &&
+	    cc->capabilities & BCMA_CC_CAP_SPROM)
+		device_create_file(&cc->core->dev, &dev_attr_sprom);
+
 	cc->setup_done = true;
+	return 0;
+}
+
+
+static void bcma_core_cc_remove(struct bcma_device *core)
+{
+	if (core->id.rev >= 31 &&
+	    core->bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM)
+		device_remove_file(&core->dev, &dev_attr_sprom);
+}
+
+static struct bcma_device_id bcma_core_cc_id_table[] = {
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_CHIPCOMMON,
+		  BCMA_ANY_REV, BCMA_ANY_CLASS),
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_4706_CHIPCOMMON,
+		  BCMA_ANY_REV, BCMA_ANY_CLASS),
+	BCMA_CORETABLE_END
+};
+
+struct bcma_driver bcma_core_cc_driver = {
+	.name     = "bcma-cc-core",
+	.probe    = bcma_core_cc_probe,
+	.remove   = bcma_core_cc_remove,
+	.id_table = bcma_core_cc_id_table,
+};
+
+static void bcma_core_cc_release(struct device *dev)
+{
+	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
+
+	kfree(core);
+}
+
+void bcma_core_chipcommon_init(struct bcma_drv_cc *cc)
+{
+	int err;
+
+	if (cc->setup_done)
+		return;
+
+	cc->core->dev.bus = bcma_core_cc_driver.drv.bus;
+	cc->core->dev.release = bcma_core_cc_release;
+	dev_set_name(&cc->core->dev, "bcma%d:%d",
+		     cc->core->bus->num, cc->core->core_index);
+
+	if (cc->core->bus->hosttype == BCMA_HOSTTYPE_PCI)
+		cc->core->dev.parent = &cc->core->bus->host_pci->dev;
+
+	err = device_register(&cc->core->dev);
+	if (err) {
+		bcma_err(cc->core->bus,
+			 "Could not register dev for core 0x%03X\n",
+			 cc->core->id.id);
+	} else
+		cc->core->dev_registered = true;
 }
 
 /* Set chip watchdog reset timer to fire in 'ticks' backplane cycles */
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 758af9c..9ceaca3 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -109,7 +109,8 @@ static int bcma_register_cores(struct bcma_bus *bus)
 
 		core->dev.release = bcma_release_core_dev;
 		core->dev.bus = &bcma_bus_type;
-		dev_set_name(&core->dev, "bcma%d:%d", bus->num, dev_id);
+		dev_set_name(&core->dev, "bcma%d:%d",
+			     bus->num, core->core_index);
 
 		switch (bus->hosttype) {
 		case BCMA_HOSTTYPE_PCI:
@@ -143,7 +144,7 @@ static void bcma_unregister_cores(struct bcma_bus *bus)
 {
 	struct bcma_device *core;
 
-	list_for_each_entry(core, &bus->cores, list) {
+	list_for_each_entry_reverse(core, &bus->cores, list) {
 		if (core->dev_registered)
 			device_unregister(&core->dev);
 	}
@@ -381,6 +382,8 @@ static int __init bcma_modinit(void)
 	if (err)
 		return err;
 
+	bcma_driver_register(&bcma_core_cc_driver);
+
 #ifdef CONFIG_BCMA_HOST_PCI
 	err = bcma_host_pci_init();
 	if (err) {
@@ -398,6 +401,7 @@ static void __exit bcma_modexit(void)
 #ifdef CONFIG_BCMA_HOST_PCI
 	bcma_host_pci_exit();
 #endif
+	bcma_driver_unregister(&bcma_core_cc_driver);
 	bus_unregister(&bcma_bus_type);
 }
 module_exit(bcma_modexit)
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 9ea4627..eff6104 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -15,6 +15,7 @@
 #include <linux/io.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/ctype.h>
 
 static int(*get_fallback_sprom)(struct bcma_bus *dev, struct ssb_sprom *out);
 
@@ -154,7 +155,7 @@ static int bcma_sprom_check_crc(const u16 *sprom)
 	return 0;
 }
 
-static int bcma_sprom_valid(const u16 *sprom)
+int bcma_sprom_valid(const u16 *sprom)
 {
 	u16 revision;
 	int err;
@@ -197,7 +198,7 @@ static int bcma_sprom_valid(const u16 *sprom)
 		SPEX(_field[7], _offset + 14, _mask, _shift);	\
 	} while (0)
 
-static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
+void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 {
 	u16 v, o;
 	int i;
@@ -602,3 +603,45 @@ out:
 	kfree(sprom);
 	return err;
 }
+
+int bcma_sprom_tohex(const u16 *sprom, char *buf, size_t buf_len)
+{
+	int i, pos = 0;
+
+	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++)
+		pos += snprintf(buf + pos, buf_len - pos - 1,
+	"%04X", swab16(sprom[i]) & 0xFFFF);
+	pos += snprintf(buf + pos, buf_len - pos - 1, "\n");
+
+	return pos + 1;
+}
+
+int bcma_sprom_fromhex(u16 *sprom, const char *dump, size_t len)
+{
+	char c, tmp[5] = { 0 };
+	int err, cnt = 0;
+	unsigned long parsed;
+
+	/* Strip whitespace at the end. */
+	while (len) {
+		c = dump[len - 1];
+		if (!isspace(c) && c != '\0')
+			break;
+		len--;
+	}
+
+	/* Length must match exactly. */
+	if (len != SSB_SPROMSIZE_WORDS_R4 * 4)
+		return -EINVAL;
+
+	while (cnt < SSB_SPROMSIZE_WORDS_R4) {
+		memcpy(tmp, dump, 4);
+		dump += 4;
+		err = kstrtoul(tmp, 16, &parsed);
+		if (err)
+			return err;
+		sprom[cnt++] = swab16((u16)parsed);
+	}
+
+	return 0;
+}
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index d323a4b..57893a8 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -251,6 +251,8 @@
 #define  BCMA_CC_FLASH_CFG_DS		0x0010	/* Data size, 0=8bit, 1=16bit */
 #define BCMA_CC_FLASH_WAITCNT		0x012C
 #define BCMA_CC_SROM_CONTROL		0x0190
+#define BCMA_CC_SROM_ADDRESS		0x0194
+#define BCMA_CC_SROM_DATA		0x0198
 #define  BCMA_CC_SROM_CONTROL_START	0x80000000
 #define  BCMA_CC_SROM_CONTROL_BUSY	0x80000000
 #define  BCMA_CC_SROM_CONTROL_OPCODE	0x60000000
@@ -469,8 +471,6 @@ struct bcma_drv_cc {
 #define bcma_cc_maskset32(cc, offset, mask, set) \
 	bcma_cc_write32(cc, offset, (bcma_cc_read32(cc, offset) & (mask)) | (set))
 
-extern void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
-
 extern void bcma_chipco_suspend(struct bcma_drv_cc *cc);
 extern void bcma_chipco_resume(struct bcma_drv_cc *cc);
 
-- 
1.7.10.4

