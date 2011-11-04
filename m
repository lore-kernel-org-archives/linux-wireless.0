Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3677 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754251Ab1KDVYG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:06 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/16] brcm80211: fmac: move chip drive strength related
 code to sdio_chip.c
Date: Fri, 4 Nov 2011 22:23:40 +0100
Message-ID: <1320441822-4615-15-git-send-email-arend@broadcom.com> (sfid-20111104_222428_923275_84D945B8)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of the abstracting chip backplane handle code
series.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  117 +-------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  112 +++++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    3 +
 3 files changed, 117 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index e05c784..d45fa32 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3704,120 +3704,6 @@ fail:
 	return false;
 }
 
-/* SDIO Pad drive strength to select value mappings */
-struct sdiod_drive_str {
-	u8 strength;	/* Pad Drive Strength in mA */
-	u8 sel;		/* Chip-specific select value */
-};
-
-/* SDIO Drive Strength to sel value table for PMU Rev 1 */
-static const struct sdiod_drive_str sdiod_drive_strength_tab1[] = {
-	{
-	4, 0x2}, {
-	2, 0x3}, {
-	1, 0x0}, {
-	0, 0x0}
-	};
-
-/* SDIO Drive Strength to sel value table for PMU Rev 2, 3 */
-static const struct sdiod_drive_str sdiod_drive_strength_tab2[] = {
-	{
-	12, 0x7}, {
-	10, 0x6}, {
-	8, 0x5}, {
-	6, 0x4}, {
-	4, 0x2}, {
-	2, 0x1}, {
-	0, 0x0}
-	};
-
-/* SDIO Drive Strength to sel value table for PMU Rev 8 (1.8V) */
-static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
-	{
-	32, 0x7}, {
-	26, 0x6}, {
-	22, 0x5}, {
-	16, 0x4}, {
-	12, 0x3}, {
-	8, 0x2}, {
-	4, 0x1}, {
-	0, 0x0}
-	};
-
-#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
-
-static char *brcmf_chipname(uint chipid, char *buf, uint len)
-{
-	const char *fmt;
-
-	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
-	snprintf(buf, len, fmt, chipid);
-	return buf;
-}
-
-static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
-						   u32 drivestrength) {
-	struct sdiod_drive_str *str_tab = NULL;
-	u32 str_mask = 0;
-	u32 str_shift = 0;
-	char chn[8];
-
-	if (!(bus->ci->cccaps & CC_CAP_PMU))
-		return;
-
-	switch (SDIOD_DRVSTR_KEY(bus->ci->chip, bus->ci->pmurev)) {
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 1):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab1;
-		str_mask = 0x30000000;
-		str_shift = 28;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 2):
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 3):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab2;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4336_CHIP_ID, 8):
-		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab3;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	default:
-		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
-			  brcmf_chipname(bus->ci->chip, chn, 8),
-			  bus->ci->chiprev, bus->ci->pmurev);
-		break;
-	}
-
-	if (str_tab != NULL) {
-		u32 drivestrength_sel = 0;
-		u32 cc_data_temp;
-		int i;
-
-		for (i = 0; str_tab[i].strength != 0; i++) {
-			if (drivestrength >= str_tab[i].strength) {
-				drivestrength_sel = str_tab[i].sel;
-				break;
-			}
-		}
-
-		brcmf_sdcard_reg_write(bus->sdiodev,
-			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
-			4, 1);
-		cc_data_temp = brcmf_sdcard_reg_read(bus->sdiodev,
-			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
-		cc_data_temp &= ~str_mask;
-		drivestrength_sel <<= str_shift;
-		cc_data_temp |= drivestrength_sel;
-		brcmf_sdcard_reg_write(bus->sdiodev,
-			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
-			4, cc_data_temp);
-
-		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
-			  drivestrength, cc_data_temp);
-	}
-}
-
 static bool
 brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 {
@@ -3867,7 +3753,8 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, u32 regsva)
 		goto fail;
 	}
 
-	brcmf_sdbrcm_sdiod_drive_strength_init(bus, SDIO_DRIVE_STRENGTH);
+	brcmf_sdio_chip_drivestrengthinit(bus->sdiodev, bus->ci,
+					  SDIO_DRIVE_STRENGTH);
 
 	/* Get info on the SOCRAM cores... */
 	bus->ramsize = bus->ci->ramsize;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index ea12a4c..e068107 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -52,6 +52,44 @@
 #define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
 #define	SBIDH_VC_SHIFT		16
 
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+/* SDIO Pad drive strength to select value mappings */
+struct sdiod_drive_str {
+	u8 strength;	/* Pad Drive Strength in mA */
+	u8 sel;		/* Chip-specific select value */
+};
+/* SDIO Drive Strength to sel value table for PMU Rev 1 */
+static const struct sdiod_drive_str sdiod_drive_strength_tab1[] = {
+	{
+	4, 0x2}, {
+	2, 0x3}, {
+	1, 0x0}, {
+	0, 0x0}
+	};
+/* SDIO Drive Strength to sel value table for PMU Rev 2, 3 */
+static const struct sdiod_drive_str sdiod_drive_strength_tab2[] = {
+	{
+	12, 0x7}, {
+	10, 0x6}, {
+	8, 0x5}, {
+	6, 0x4}, {
+	4, 0x2}, {
+	2, 0x1}, {
+	0, 0x0}
+	};
+/* SDIO Drive Strength to sel value table for PMU Rev 8 (1.8V) */
+static const struct sdiod_drive_str sdiod_drive_strength_tab3[] = {
+	{
+	32, 0x7}, {
+	26, 0x6}, {
+	22, 0x5}, {
+	16, 0x4}, {
+	12, 0x3}, {
+	8, 0x2}, {
+	4, 0x1}, {
+	0, 0x0}
+	};
+
 static u32
 brcmf_sdio_chip_corerev(struct brcmf_sdio_dev *sdiodev,
 			u32 corebase)
@@ -363,3 +401,77 @@ brcmf_sdio_chip_detach(struct chip_info **ci_ptr)
 	kfree(*ci_ptr);
 	*ci_ptr = NULL;
 }
+
+static char *brcmf_sdio_chip_name(uint chipid, char *buf, uint len)
+{
+	const char *fmt;
+
+	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
+	snprintf(buf, len, fmt, chipid);
+	return buf;
+}
+
+void
+brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
+				  struct chip_info *ci, u32 drivestrength)
+{
+	struct sdiod_drive_str *str_tab = NULL;
+	u32 str_mask = 0;
+	u32 str_shift = 0;
+	char chn[8];
+
+	if (!(ci->cccaps & CC_CAP_PMU))
+		return;
+
+	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
+	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 1):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab1;
+		str_mask = 0x30000000;
+		str_shift = 28;
+		break;
+	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 2):
+	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 3):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab2;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
+	case SDIOD_DRVSTR_KEY(BCM4336_CHIP_ID, 8):
+		str_tab = (struct sdiod_drive_str *)&sdiod_drive_strength_tab3;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
+	default:
+		brcmf_dbg(ERROR, "No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+			  brcmf_sdio_chip_name(ci->chip, chn, 8),
+			  ci->chiprev, ci->pmurev);
+		break;
+	}
+
+	if (str_tab != NULL) {
+		u32 drivestrength_sel = 0;
+		u32 cc_data_temp;
+		int i;
+
+		for (i = 0; str_tab[i].strength != 0; i++) {
+			if (drivestrength >= str_tab[i].strength) {
+				drivestrength_sel = str_tab[i].sel;
+				break;
+			}
+		}
+
+		brcmf_sdcard_reg_write(sdiodev,
+			CORE_CC_REG(ci->cccorebase, chipcontrol_addr),
+			4, 1);
+		cc_data_temp = brcmf_sdcard_reg_read(sdiodev,
+			CORE_CC_REG(ci->cccorebase, chipcontrol_addr), 4);
+		cc_data_temp &= ~str_mask;
+		drivestrength_sel <<= str_shift;
+		cc_data_temp |= drivestrength_sel;
+		brcmf_sdcard_reg_write(sdiodev,
+			CORE_CC_REG(ci->cccorebase, chipcontrol_addr),
+			4, cc_data_temp);
+
+		brcmf_dbg(INFO, "SDIO: %dmA drive strength selected, set to 0x%08x\n",
+			  drivestrength, cc_data_temp);
+	}
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 13b09a4..e816bb6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -142,5 +142,8 @@ extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info **ci_ptr, u32 regs);
 extern void brcmf_sdio_chip_detach(struct chip_info **ci_ptr);
+extern void brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
+					      struct chip_info *ci,
+					      u32 drivestrength);
 
 #endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.4.1


