Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4788 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030378Ab2CFNes (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 08:34:48 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
Subject: [PATCH] bcma: add support for on-chip OTP memory used for SPROM
 storage
Date: Tue, 6 Mar 2012 14:34:33 +0100
Message-ID: <1331040873-10290-1-git-send-email-arend@broadcom.com> (sfid-20120306_143452_562673_9C336698)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless Broadcom chips can have either their SPROM data stored
on either external SPROM or on-chip OTP memory. Both are accessed
through the same register space. This patch adds support for the
on-chip OTP memory.

Tested with:
BCM43224 OTP and SPROM
BCM4331 SPROM
BCM4313 OTP

This patch is in response to linux-wireless thread [1].

[1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426

Tested-by: Saul St. John <saul.stjohn@gmail.com>
Tested-by: Rafal Milecki <zajec5@gmail.com>
Tested-by: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Incorporated the comments on the RFC patch and acknowledged testing
efforts.

Gr. AvS
---
 drivers/bcma/sprom.c                        |  149 ++++++++++++++++++++++-----
 include/linux/bcma/bcma_driver_chipcommon.h |   10 ++-
 2 files changed, 130 insertions(+), 29 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 916ae25..cdcf75c 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -49,10 +49,23 @@ int bcma_arch_register_fallback_sprom(int (*sprom_callback)(struct bcma_bus *bus
 static int bcma_fill_sprom_with_fallback(struct bcma_bus *bus,
 					 struct ssb_sprom *out)
 {
-	if (!get_fallback_sprom)
-		return -ENOENT;
+	int err;
 
-	return get_fallback_sprom(bus, out);
+	if (!get_fallback_sprom) {
+		err = -ENOENT;
+		goto fail;
+	}
+
+	err = get_fallback_sprom(bus, out);
+	if (err)
+		goto fail;
+
+	pr_debug("Using SPROM revision %d provided by"
+		 " platform.\n", bus->sprom.revision);
+	return 0;
+fail:
+	pr_warn("Using fallback SPROM failed (err %d)\n", err);
+	return err;
 }
 
 /**************************************************
@@ -287,42 +300,127 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 	     SSB_SROM8_FEM_ANTSWLUT_SHIFT);
 }
 
-static bool bcma_is_sprom_available(struct bcma_bus *bus)
+/*
+ * Indicates the presence of external SPROM.
+ */
+static bool bcma_sprom_ext_available(struct bcma_bus *bus)
 {
-	u32 sromctrl;
+	u32 chip_status;
+	u32 srom_control;
+	u32 present_mask;
+
+	if (bus->drv_cc.core->id.rev >= 31) {
+		if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
+			return false;
+
+		srom_control = bcma_read32(bus->drv_cc.core,
+					   BCMA_CC_SROM_CONTROL);
+		return srom_control & BCMA_CC_SROM_CONTROL_PRESENT;
+	}
 
-	if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
-		return false;
+	/* older chipcommon revisions use chip status register */
+	chip_status = bcma_read32(bus->drv_cc.core, BCMA_CC_CHIPSTAT);
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+		present_mask = BCMA_CC_CHIPST_4313_SPROM_PRESENT;
+		break;
 
-	if (bus->drv_cc.core->id.rev >= 32) {
-		sromctrl = bcma_read32(bus->drv_cc.core, BCMA_CC_SROM_CONTROL);
-		return sromctrl & BCMA_CC_SROM_CONTROL_PRESENT;
+	case 0x4331:
+		present_mask = BCMA_CC_CHIPST_4331_SPROM_PRESENT;
+		break;
+
+	default:
+		return true;
 	}
-	return true;
+
+	return chip_status & present_mask;
+}
+
+/*
+ * Indicates that on-chip OTP memory is present and enabled.
+ */
+static bool bcma_sprom_onchip_available(struct bcma_bus *bus)
+{
+	u32 chip_status;
+	u32 otpsize = 0;
+	bool present;
+
+	chip_status = bcma_read32(bus->drv_cc.core, BCMA_CC_CHIPSTAT);
+	switch (bus->chipinfo.id) {
+	case 0x4313:
+		present = chip_status & BCMA_CC_CHIPST_4313_OTP_PRESENT;
+		break;
+
+	case 0x4331:
+		present = chip_status & BCMA_CC_CHIPST_4331_OTP_PRESENT;
+		break;
+
+	case 43224:
+	case 43225:
+		/* for these chips OTP is always available */
+		present = true;
+		break;
+
+	default:
+		present = false;
+		break;
+	}
+
+	if (present) {
+		otpsize = bus->drv_cc.capabilities & BCMA_CC_CAP_OTPS;
+		otpsize >>= BCMA_CC_CAP_OTPS_SHIFT;
+	}
+
+	return otpsize != 0;
+}
+
+/*
+ * Verify OTP is filled and determine the byte
+ * offset where SPROM data is located.
+ *
+ * On error, returns 0; byte offset otherwise.
+ */
+static int bcma_sprom_onchip_offset(struct bcma_bus *bus)
+{
+	struct bcma_device *cc = bus->drv_cc.core;
+	u32 offset;
+
+	/* verify OTP status */
+	if ((bcma_read32(cc, BCMA_CC_OTPS) & BCMA_CC_OTPS_GU_PROG_HW) == 0)
+		return 0;
+
+	/* obtain bit offset from otplayout register */
+	offset = (bcma_read32(cc, BCMA_CC_OTPL) & BCMA_CC_OTPL_GURGN_OFFSET);
+	return BCMA_CC_SPROM + (offset >> 3);
 }
 
 int bcma_sprom_get(struct bcma_bus *bus)
 {
-	u16 offset;
+	u16 offset = BCMA_CC_SPROM;
 	u16 *sprom;
 	int err = 0;
 
 	if (!bus->drv_cc.core)
 		return -EOPNOTSUPP;
 
-	if (!bcma_is_sprom_available(bus)) {
+	if (!bcma_sprom_ext_available(bus)) {
 		/*
-		 * Maybe there is no SPROM on the device?
-		 * Now we ask the arch code if there is some sprom
-		 * available for this device in some other storage.
+		 * External SPROM takes precedence so check
+		 * on-chip OTP only when no external SPROM
+		 * is present.
 		 */
-		err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
-		if (err) {
-			pr_warn("Using fallback SPROM failed (err %d)\n", err);
-		} else {
-			pr_debug("Using SPROM revision %d provided by"
-				 " platform.\n", bus->sprom.revision);
-			return 0;
+		if (bcma_sprom_onchip_available(bus)) {
+			/* determine offset */
+			offset = bcma_sprom_onchip_offset(bus);
+		}
+		if (!offset) {
+			/*
+			 * Maybe there is no SPROM on the device?
+			 * Now we ask the arch code if there is some sprom
+			 * available for this device in some other storage.
+			 */
+			err = bcma_fill_sprom_with_fallback(bus, &bus->sprom);
+			return err;
 		}
 	}
 
@@ -334,11 +432,6 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (bus->chipinfo.id == 0x4331)
 		bcma_chipco_bcm4331_ext_pa_lines_ctl(&bus->drv_cc, false);
 
-	/* Most cards have SPROM moved by additional offset 0x30 (48 dwords).
-	 * According to brcm80211 this applies to cards with PCIe rev >= 6
-	 * TODO: understand this condition and use it */
-	offset = (bus->chipinfo.id == 0x4331) ? BCMA_CC_SPROM :
-		BCMA_CC_SPROM_PCIE6;
 	pr_debug("SPROM offset 0x%x\n", offset);
 	bcma_sprom_read(bus, offset, sprom);
 
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index e72938b..8bbfe31 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -56,6 +56,9 @@
 #define	 BCMA_CC_OTPS_HW_PROTECT	0x00000001
 #define	 BCMA_CC_OTPS_SW_PROTECT	0x00000002
 #define	 BCMA_CC_OTPS_CID_PROTECT	0x00000004
+#define  BCMA_CC_OTPS_GU_PROG_IND	0x00000F00	/* General Use programmed indication */
+#define  BCMA_CC_OTPS_GU_PROG_IND_SHIFT	8
+#define  BCMA_CC_OTPS_GU_PROG_HW	0x00000100	/* HW region programmed */
 #define BCMA_CC_OTPC			0x0014		/* OTP control */
 #define	 BCMA_CC_OTPC_RECWAIT		0xFF000000
 #define	 BCMA_CC_OTPC_PROGWAIT		0x00FFFF00
@@ -72,6 +75,8 @@
 #define	 BCMA_CC_OTPP_READ		0x40000000
 #define	 BCMA_CC_OTPP_START		0x80000000
 #define	 BCMA_CC_OTPP_BUSY		0x80000000
+#define BCMA_CC_OTPL			0x001C		/* OTP layout */
+#define  BCMA_CC_OTPL_GURGN_OFFSET	0x00000FFF	/* offset of general use region */
 #define BCMA_CC_IRQSTAT			0x0020
 #define BCMA_CC_IRQMASK			0x0024
 #define	 BCMA_CC_IRQ_GPIO		0x00000001	/* gpio intr */
@@ -79,6 +84,10 @@
 #define	 BCMA_CC_IRQ_WDRESET		0x80000000	/* watchdog reset occurred */
 #define BCMA_CC_CHIPCTL			0x0028		/* Rev >= 11 only */
 #define BCMA_CC_CHIPSTAT		0x002C		/* Rev >= 11 only */
+#define  BCMA_CC_CHIPST_4313_SPROM_PRESENT	1
+#define  BCMA_CC_CHIPST_4313_OTP_PRESENT	2
+#define  BCMA_CC_CHIPST_4331_SPROM_PRESENT	2
+#define  BCMA_CC_CHIPST_4331_OTP_PRESENT	4
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
@@ -256,7 +265,6 @@
 #define BCMA_CC_PLLCTL_ADDR		0x0660
 #define BCMA_CC_PLLCTL_DATA		0x0664
 #define BCMA_CC_SPROM			0x0800 /* SPROM beginning */
-#define BCMA_CC_SPROM_PCIE6		0x0830 /* SPROM beginning on PCIe rev >= 6 */
 
 /* Divider allocation in 4716/47162/5356 */
 #define BCMA_CC_PMU5_MAINPLL_CPU	1
-- 
1.7.5.4


