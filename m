Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4651 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab1DYWpa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 18:45:30 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	brudley@broadcom.com, henryp@broadcom.com, hharte@broadcom.com
Subject: [PATCH 4/7] staging: brcm80211: Move sdiod strength init to
 dhd_sdio.c
Date: Mon, 25 Apr 2011 15:45:10 -0700
Message-ID: <1303771513-18851-5-git-send-email-frankyl@broadcom.com> (sfid-20110426_004547_754747_EF5C4E1A)
In-Reply-To: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
References: <1303771513-18851-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move si_sdiod_drive_strength_init to dhd_sdio and rename to
dhdsdio_sdiod_drive_strength_init for dhd_pmu.c removal

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c |  114 ++++++++++++++++++++++++-
 1 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4e5d1ee..02f6509 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -485,6 +485,8 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus);
 static void dhdsdio_chip_disablecore(bcmsdh_info_t *sdh, u32 corebase);
 static int dhdsdio_chip_attach(struct dhd_bus *bus, void *regs);
 static void dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase);
+static void dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus,
+					u32 drivestrength);
 
 static void dhd_dongle_setmemsize(struct dhd_bus *bus, int mem_size)
 {
@@ -2292,7 +2294,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_SDIOD_DRIVE):
 		dhd_sdiod_drive_strength = int_val;
-		si_sdiod_drive_strength_init(bus->sih,
+		dhdsdio_sdiod_drive_strength_init(bus,
 					     dhd_sdiod_drive_strength);
 		break;
 
@@ -5270,7 +5272,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva, u16 devid)
 		goto fail;
 	}
 
-	si_sdiod_drive_strength_init(bus->sih, dhd_sdiod_drive_strength);
+	dhdsdio_sdiod_drive_strength_init(bus, dhd_sdiod_drive_strength);
 
 	/* Get info on the ARM and SOCRAM cores... */
 	if (!DHD_NOPMU(bus)) {
@@ -6316,3 +6318,111 @@ dhdsdio_chip_resetcore(bcmsdh_info_t *sdh, u32 corebase)
 		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
 	udelay(1);
 }
+
+/* SDIO Pad drive strength to select value mappings */
+struct sdiod_drive_str {
+	u8 strength;	/* Pad Drive Strength in mA */
+	u8 sel;		/* Chip-specific select value */
+};
+
+/* SDIO Drive Strength to sel value table for PMU Rev 1 */
+static const struct sdiod_drive_str sdiod_drive_strength_tab1[] = {
+	{
+	4, 0x2}, {
+	2, 0x3}, {
+	1, 0x0}, {
+	0, 0x0}
+	};
+
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
+
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
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+
+static void
+dhdsdio_sdiod_drive_strength_init(struct dhd_bus *bus, u32 drivestrength) {
+	struct sdiod_drive_str *str_tab = NULL;
+	u32 str_mask = 0;
+	u32 str_shift = 0;
+#ifdef BCMDBG
+	char chn[8];
+#endif
+
+	if (!(bus->ci->cccaps & CC_CAP_PMU))
+		return;
+
+	switch (SDIOD_DRVSTR_KEY(bus->ci->chip, bus->ci->pmurev)) {
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
+		DHD_ERROR(("No SDIO Drive strength init"
+			"done for chip %s rev %d pmurev %d\n",
+			bcm_chipname(bus->ci->chip, chn, 8),
+			bus->ci->chiprev, bus->ci->pmurev));
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
+		bcmsdh_reg_write(bus->sdh,
+			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
+			4, 1);
+		cc_data_temp = bcmsdh_reg_read(bus->sdh,
+			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr), 4);
+		cc_data_temp &= ~str_mask;
+		drivestrength_sel <<= str_shift;
+		cc_data_temp |= drivestrength_sel;
+		bcmsdh_reg_write(bus->sdh,
+			CORE_CC_REG(bus->ci->cccorebase, chipcontrol_addr),
+			4, cc_data_temp);
+
+		DHD_INFO(("SDIO: %dmA drive strength selected, set to 0x%08x\n",
+			drivestrength, cc_data_temp));
+	}
+}
-- 
1.7.1


