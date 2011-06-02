Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:64831 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546Ab1FAXav (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 19:30:51 -0400
Received: by eyx24 with SMTP id 24so102687eyx.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 16:30:50 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: read SPROM and extract MAC from it
Date: Thu,  2 Jun 2011 02:08:51 +0200
Message-Id: <1306973331-3959-1-git-send-email-zajec5@gmail.com> (sfid-20110602_013104_593187_E2D7E490)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of BCMA cards SPROM is located in the ChipCommon core, it is
not mapped as separated host window. So far we have met only SPROMs rev
8.
SPROM layout seems to be the same as for SSB buses, so we decided to
share SPROM struct and some defines.
For now we extract MAC address only, this can be improved of course.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Makefile                       |    2 +-
 drivers/bcma/bcma_private.h                 |    3 +
 drivers/bcma/main.c                         |    7 +
 drivers/bcma/sprom.c                        |  162 +++++++++++++++++++++++++++
 include/linux/bcma/bcma.h                   |    5 +
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 6 files changed, 179 insertions(+), 1 deletions(-)
 create mode 100644 drivers/bcma/sprom.c

diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index 0d56245..cde0182 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,4 +1,4 @@
-bcma-y					+= main.o scan.o core.o
+bcma-y					+= main.o scan.o core.o sprom.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
 bcma-y					+= driver_pci.o
 bcma-$(CONFIG_BCMA_HOST_PCI)		+= host_pci.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 2f72e9c..12a75ab 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -19,6 +19,9 @@ extern void bcma_bus_unregister(struct bcma_bus *bus);
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
 
+/* sprom.c */
+int bcma_sprom_get(struct bcma_bus *bus);
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index a2f6b18..11e96dc 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -146,6 +146,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_pci_init(&bus->drv_pci);
 	}
 
+	/* Try to get SPROM */
+	err = bcma_sprom_get(bus);
+	if (err) {
+		pr_err("Failed to get SPROM: %d\n", err);
+		return -ENOENT;
+	}
+
 	/* Register found cores */
 	bcma_register_cores(bus);
 
diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
new file mode 100644
index 0000000..ffbb0e3
--- /dev/null
+++ b/drivers/bcma/sprom.c
@@ -0,0 +1,162 @@
+/*
+ * Broadcom specific AMBA
+ * SPROM reading
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include "bcma_private.h"
+
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_regs.h>
+#include <linux/pci.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+#include <linux/slab.h>
+
+#define SPOFF(offset)	((offset) / sizeof(u16))
+
+/**************************************************
+ * R/W ops.
+ **************************************************/
+
+static void bcma_sprom_read(struct bcma_bus *bus, u16 *sprom)
+{
+	int i;
+	for (i = 0; i < SSB_SPROMSIZE_WORDS_R4; i++)
+		sprom[i] = bcma_read16(bus->drv_cc.core,
+				       BCMA_CC_SPROM + (i * 2));
+}
+
+/**************************************************
+ * Validation.
+ **************************************************/
+
+static inline u8 bcma_crc8(u8 crc, u8 data)
+{
+	/* Polynomial:   x^8 + x^7 + x^6 + x^4 + x^2 + 1   */
+	static const u8 t[] = {
+		0x00, 0xF7, 0xB9, 0x4E, 0x25, 0xD2, 0x9C, 0x6B,
+		0x4A, 0xBD, 0xF3, 0x04, 0x6F, 0x98, 0xD6, 0x21,
+		0x94, 0x63, 0x2D, 0xDA, 0xB1, 0x46, 0x08, 0xFF,
+		0xDE, 0x29, 0x67, 0x90, 0xFB, 0x0C, 0x42, 0xB5,
+		0x7F, 0x88, 0xC6, 0x31, 0x5A, 0xAD, 0xE3, 0x14,
+		0x35, 0xC2, 0x8C, 0x7B, 0x10, 0xE7, 0xA9, 0x5E,
+		0xEB, 0x1C, 0x52, 0xA5, 0xCE, 0x39, 0x77, 0x80,
+		0xA1, 0x56, 0x18, 0xEF, 0x84, 0x73, 0x3D, 0xCA,
+		0xFE, 0x09, 0x47, 0xB0, 0xDB, 0x2C, 0x62, 0x95,
+		0xB4, 0x43, 0x0D, 0xFA, 0x91, 0x66, 0x28, 0xDF,
+		0x6A, 0x9D, 0xD3, 0x24, 0x4F, 0xB8, 0xF6, 0x01,
+		0x20, 0xD7, 0x99, 0x6E, 0x05, 0xF2, 0xBC, 0x4B,
+		0x81, 0x76, 0x38, 0xCF, 0xA4, 0x53, 0x1D, 0xEA,
+		0xCB, 0x3C, 0x72, 0x85, 0xEE, 0x19, 0x57, 0xA0,
+		0x15, 0xE2, 0xAC, 0x5B, 0x30, 0xC7, 0x89, 0x7E,
+		0x5F, 0xA8, 0xE6, 0x11, 0x7A, 0x8D, 0xC3, 0x34,
+		0xAB, 0x5C, 0x12, 0xE5, 0x8E, 0x79, 0x37, 0xC0,
+		0xE1, 0x16, 0x58, 0xAF, 0xC4, 0x33, 0x7D, 0x8A,
+		0x3F, 0xC8, 0x86, 0x71, 0x1A, 0xED, 0xA3, 0x54,
+		0x75, 0x82, 0xCC, 0x3B, 0x50, 0xA7, 0xE9, 0x1E,
+		0xD4, 0x23, 0x6D, 0x9A, 0xF1, 0x06, 0x48, 0xBF,
+		0x9E, 0x69, 0x27, 0xD0, 0xBB, 0x4C, 0x02, 0xF5,
+		0x40, 0xB7, 0xF9, 0x0E, 0x65, 0x92, 0xDC, 0x2B,
+		0x0A, 0xFD, 0xB3, 0x44, 0x2F, 0xD8, 0x96, 0x61,
+		0x55, 0xA2, 0xEC, 0x1B, 0x70, 0x87, 0xC9, 0x3E,
+		0x1F, 0xE8, 0xA6, 0x51, 0x3A, 0xCD, 0x83, 0x74,
+		0xC1, 0x36, 0x78, 0x8F, 0xE4, 0x13, 0x5D, 0xAA,
+		0x8B, 0x7C, 0x32, 0xC5, 0xAE, 0x59, 0x17, 0xE0,
+		0x2A, 0xDD, 0x93, 0x64, 0x0F, 0xF8, 0xB6, 0x41,
+		0x60, 0x97, 0xD9, 0x2E, 0x45, 0xB2, 0xFC, 0x0B,
+		0xBE, 0x49, 0x07, 0xF0, 0x9B, 0x6C, 0x22, 0xD5,
+		0xF4, 0x03, 0x4D, 0xBA, 0xD1, 0x26, 0x68, 0x9F,
+	};
+	return t[crc ^ data];
+}
+
+static u8 bcma_sprom_crc(const u16 *sprom)
+{
+	int word;
+	u8 crc = 0xFF;
+
+	for (word = 0; word < SSB_SPROMSIZE_WORDS_R4 - 1; word++) {
+		crc = bcma_crc8(crc, sprom[word] & 0x00FF);
+		crc = bcma_crc8(crc, (sprom[word] & 0xFF00) >> 8);
+	}
+	crc = bcma_crc8(crc, sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & 0x00FF);
+	crc ^= 0xFF;
+
+	return crc;
+}
+
+static int bcma_sprom_check_crc(const u16 *sprom)
+{
+	u8 crc;
+	u8 expected_crc;
+	u16 tmp;
+
+	crc = bcma_sprom_crc(sprom);
+	tmp = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_CRC;
+	expected_crc = tmp >> SSB_SPROM_REVISION_CRC_SHIFT;
+	if (crc != expected_crc)
+		return -EPROTO;
+
+	return 0;
+}
+
+static int bcma_sprom_valid(const u16 *sprom)
+{
+	u16 revision;
+	int err;
+
+	err = bcma_sprom_check_crc(sprom);
+	if (err)
+		return err;
+
+	revision = sprom[SSB_SPROMSIZE_WORDS_R4 - 1] & SSB_SPROM_REVISION_REV;
+	if (revision != 8) {
+		pr_err("Unsupported SPROM revision: %d\n", revision);
+		return -ENOENT;
+	}
+
+	return 0;
+}
+
+/**************************************************
+ * SPROM extraction.
+ **************************************************/
+
+static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
+{
+	u16 v;
+	int i;
+
+	for (i = 0; i < 3; i++) {
+		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
+		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
+	}
+}
+
+int bcma_sprom_get(struct bcma_bus *bus)
+{
+	u16 *sprom;
+	int err = 0;
+
+	if (!bus->drv_cc.core)
+		return -EOPNOTSUPP;
+
+	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
+			GFP_KERNEL);
+	if (!sprom)
+		return -ENOMEM;
+
+	bcma_sprom_read(bus, sprom);
+
+	err = bcma_sprom_valid(sprom);
+	if (err)
+		goto out;
+
+	bcma_sprom_extract_r8(bus, sprom);
+
+out:
+	kfree(sprom);
+	return err;
+}
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 27a27a7..6ff080e 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -6,6 +6,7 @@
 
 #include <linux/bcma/bcma_driver_chipcommon.h>
 #include <linux/bcma/bcma_driver_pci.h>
+#include <linux/ssb/ssb.h> /* SPROM sharing */
 
 #include "bcma_regs.h"
 
@@ -187,6 +188,10 @@ struct bcma_bus {
 
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci;
+
+	/* We decided to share SPROM struct with SSB as long as we do not need
+	 * any hacks for BCMA. This simplifies drivers code. */
+	struct ssb_sprom sprom;
 };
 
 extern inline u32 bcma_read8(struct bcma_device *core, u16 offset)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 083c3b6..9c5b69f 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -244,6 +244,7 @@
 #define BCMA_CC_REGCTL_DATA		0x065C
 #define BCMA_CC_PLLCTL_ADDR		0x0660
 #define BCMA_CC_PLLCTL_DATA		0x0664
+#define BCMA_CC_SPROM			0x0830 /* SPROM beginning */
 
 /* Data for the PMU, if available.
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
-- 
1.7.3.4

