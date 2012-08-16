Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47209 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab2HPTGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 15:06:20 -0400
Received: by yhmm54 with SMTP id m54so3273499yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 12:06:19 -0700 (PDT)
Date: Thu, 16 Aug 2012 14:06:16 -0500
From: "Saul St. John" <saul.stjohn@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] bcma: expose cc sprom to sysfs
Message-ID: <20120816190616.GE6726@eris.garyseven.net> (sfid-20120816_210625_252193_347C30A1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20120816185905.GA6726@eris.garyseven.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On BCMA devices with a ChipCommon core of revision 31 or higher, the device
SPROM can be accessed through CC core registers. This patch exposes the
SPROM on such devices for read/write access as a sysfs attribute.

Tested on a MacBookPro8,2 with BCM4331.

Cc: Rafał Miłecki <zajec5@gmail.com> 
Cc: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Saul St. John <saul.stjohn@gmail.com>
---
 drivers/bcma/bcma_private.h                 |    4 +
 drivers/bcma/driver_chipcommon.c            |  163 ++++++++++++++++++++++++++-
 drivers/bcma/sprom.c                        |   47 +++++++-
 include/linux/bcma/bcma_driver_chipcommon.h |    2 +
 4 files changed, 213 insertions(+), 3 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 19b97f9..de32bb9 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -41,6 +41,10 @@ void bcma_init_bus(struct bcma_bus *bus);
 
 /* sprom.c */
 int bcma_sprom_get(struct bcma_bus *bus);
+int bcma_sprom_valid(const u16 *sprom);
+void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom);
+int bcma_sprom_fromhex(u16 *sprom, const char *dump, size_t len);
+int bcma_sprom_tohex(const u16 *sprom, char *buf, size_t buf_len);
 
 /* driver_chipcommon.c */
 #ifdef CONFIG_BCMA_DRIVER_MIPS
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 8c2013c..4dbddb3 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -22,6 +22,149 @@ static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 	return value;
 }
 
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
+	bcma_warn(core->bus, "Writing SPROM. Do NOT turn off the power!\n");
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
 static int bcma_core_cc_initialize(struct bcma_device *core)
 {
 	u32 leddc_on = 10;
@@ -60,6 +203,23 @@ static int bcma_core_cc_initialize(struct bcma_device *core)
 	return 0;
 }
 
+static int bcma_core_cc_probe(struct bcma_device *core)
+{
+	bcma_core_cc_initialize(core);
+	if (core->id.rev >= 31 &&
+	    core->bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM)
+		device_create_file(&core->dev, &dev_attr_sprom);
+
+	return 0;
+}
+
+static void bcma_core_cc_remove(struct bcma_device *core)
+{
+	if (core->id.rev >= 31 &&
+	    core->bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM)
+		device_remove_file(&core->dev, &dev_attr_sprom);
+}
+
 static struct bcma_device_id bcma_core_cc_id_table[] = {
 	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_CHIPCOMMON,
 		  BCMA_ANY_REV, BCMA_ANY_CLASS),
@@ -70,8 +230,9 @@ static struct bcma_device_id bcma_core_cc_id_table[] = {
 
 struct bcma_driver bcma_core_cc_driver = {
 	.name     = "bcma-cc-core",
-	.probe    = bcma_core_cc_initialize,
+	.probe    = bcma_core_cc_probe,
 	.id_table = bcma_core_cc_id_table,
+	.remove   = bcma_core_cc_remove,
 #ifdef CONFIG_PM
 	.resume   = bcma_core_cc_initialize,
 #endif
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
index f6e5858..57893a8 100644
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
-- 
1.7.10.4

