Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:34167 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbaA2Ocg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:36 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/14] brcmfmac: move SDIO specific functions
Date: Wed, 29 Jan 2014 15:32:14 +0100
Message-ID: <1391005944-3220-5-git-send-email-arend@broadcom.com> (sfid-20140129_160006_936560_8CD1D431)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The chip related functions will be made agnostic of the host
interface. However, some functions in the source file are
rather SDIO specific so better move it to the SDIO specific
source file.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  173 +++++++++++++++++++-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  172 +------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    3 -
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |    1 +
 4 files changed, 174 insertions(+), 175 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 98d0784..090ce18 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -494,6 +494,52 @@ enum brcmf_sdio_frmtype {
 	BRCMF_SDIO_FT_SUB,
 };
 
+#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
+
+/* SDIO Pad drive strength to select value mappings */
+struct sdiod_drive_str {
+	u8 strength;	/* Pad Drive Strength in mA */
+	u8 sel;		/* Chip-specific select value */
+};
+
+/* SDIO Drive Strength to sel value table for PMU Rev 11 (1.8V) */
+static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
+	{32, 0x6},
+	{26, 0x7},
+	{22, 0x4},
+	{16, 0x5},
+	{12, 0x2},
+	{8, 0x3},
+	{4, 0x0},
+	{0, 0x1}
+};
+
+/* SDIO Drive Strength to sel value table for PMU Rev 13 (1.8v) */
+static const struct sdiod_drive_str sdiod_drive_strength_tab5_1v8[] = {
+	{6, 0x7},
+	{5, 0x6},
+	{4, 0x5},
+	{3, 0x4},
+	{2, 0x2},
+	{1, 0x1},
+	{0, 0x0}
+};
+
+/* SDIO Drive Strength to sel value table for PMU Rev 17 (1.8v) */
+static const struct sdiod_drive_str sdiod_drvstr_tab6_1v8[] = {
+	{3, 0x3},
+	{2, 0x2},
+	{1, 0x1},
+	{0, 0x0} };
+
+/* SDIO Drive Strength to sel value table for 43143 PMU Rev 17 (3.3V) */
+static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
+	{16, 0x7},
+	{12, 0x5},
+	{8,  0x3},
+	{4,  0x1}
+};
+
 #define BCM43143_FIRMWARE_NAME		"brcm/brcmfmac43143-sdio.bin"
 #define BCM43143_NVRAM_NAME		"brcm/brcmfmac43143-sdio.txt"
 #define BCM43241B0_FIRMWARE_NAME	"brcm/brcmfmac43241b0-sdio.bin"
@@ -3744,6 +3790,131 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 	}
 }
 
+static char *brcmf_sdio_chip_name(uint chipid, char *buf, uint len)
+{
+	const char *fmt;
+
+	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
+	snprintf(buf, len, fmt, chipid);
+	return buf;
+}
+
+static void
+brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
+				  struct brcmf_chip *ci, u32 drivestrength)
+{
+	const struct sdiod_drive_str *str_tab = NULL;
+	u32 str_mask;
+	u32 str_shift;
+	char chn[8];
+	u32 base = ci->c_inf[0].base;
+	u32 i;
+	u32 drivestrength_sel = 0;
+	u32 cc_data_temp;
+	u32 addr;
+
+	if (!(ci->c_inf[0].caps & CC_CAP_PMU))
+		return;
+
+	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
+	case SDIOD_DRVSTR_KEY(BCM4330_CHIP_ID, 12):
+		str_tab = sdiod_drvstr_tab1_1v8;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
+	case SDIOD_DRVSTR_KEY(BCM4334_CHIP_ID, 17):
+		str_tab = sdiod_drvstr_tab6_1v8;
+		str_mask = 0x00001800;
+		str_shift = 11;
+		break;
+	case SDIOD_DRVSTR_KEY(BCM43143_CHIP_ID, 17):
+		/* note: 43143 does not support tristate */
+		i = ARRAY_SIZE(sdiod_drvstr_tab2_3v3) - 1;
+		if (drivestrength >= sdiod_drvstr_tab2_3v3[i].strength) {
+			str_tab = sdiod_drvstr_tab2_3v3;
+			str_mask = 0x00000007;
+			str_shift = 0;
+		} else
+			brcmf_err("Invalid SDIO Drive strength for chip %s, strength=%d\n",
+				  brcmf_sdio_chip_name(ci->chip, chn, 8),
+				  drivestrength);
+		break;
+	case SDIOD_DRVSTR_KEY(BCM43362_CHIP_ID, 13):
+		str_tab = sdiod_drive_strength_tab5_1v8;
+		str_mask = 0x00003800;
+		str_shift = 11;
+		break;
+	default:
+		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
+			  brcmf_sdio_chip_name(ci->chip, chn, 8),
+			  ci->chiprev, ci->pmurev);
+		break;
+	}
+
+	if (str_tab != NULL) {
+		for (i = 0; str_tab[i].strength != 0; i++) {
+			if (drivestrength >= str_tab[i].strength) {
+				drivestrength_sel = str_tab[i].sel;
+				break;
+			}
+		}
+		addr = CORE_CC_REG(base, chipcontrol_addr);
+		brcmf_sdiod_regwl(sdiodev, addr, 1, NULL);
+		cc_data_temp = brcmf_sdiod_regrl(sdiodev, addr, NULL);
+		cc_data_temp &= ~str_mask;
+		drivestrength_sel <<= str_shift;
+		cc_data_temp |= drivestrength_sel;
+		brcmf_sdiod_regwl(sdiodev, addr, cc_data_temp, NULL);
+
+		brcmf_dbg(INFO, "SDIO: %d mA (req=%d mA) drive strength selected, set to 0x%08x\n",
+			  str_tab[i].strength, drivestrength, cc_data_temp);
+	}
+}
+
+int brcmf_sdio_buscoreprep(struct brcmf_sdio_dev *sdiodev)
+{
+	int err = 0;
+	u8 clkval, clkset;
+
+	/* Try forcing SDIO core to do ALPAvail request only */
+	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	if (err) {
+		brcmf_err("error writing for HT off\n");
+		return err;
+	}
+
+	/* If register supported, wait for ALPAvail and then force ALP */
+	/* This may take up to 15 milliseconds */
+	clkval = brcmf_sdiod_regrb(sdiodev,
+				   SBSDIO_FUNC1_CHIPCLKCSR, NULL);
+
+	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
+		brcmf_err("ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
+			  clkset, clkval);
+		return -EACCES;
+	}
+
+	SPINWAIT(((clkval = brcmf_sdiod_regrb(sdiodev,
+					      SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
+			!SBSDIO_ALPAV(clkval)),
+			PMU_MAX_TRANSITION_DLY);
+	if (!SBSDIO_ALPAV(clkval)) {
+		brcmf_err("timeout on ALPAV wait, clkval 0x%02x\n",
+			  clkval);
+		return -EBUSY;
+	}
+
+	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
+	udelay(65);
+
+	/* Also, disable the extra SDIO pull-ups */
+	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
+
+	return 0;
+}
+
 static bool
 brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 {
@@ -3794,7 +3965,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		drivestrength = bus->sdiodev->pdata->drive_strength;
 	else
 		drivestrength = DEFAULT_SDIO_DRIVE_STRENGTH;
-	brcmf_sdio_chip_drivestrengthinit(bus->sdiodev, bus->ci, drivestrength);
+	brcmf_sdio_drivestrengthinit(bus->sdiodev, bus->ci, drivestrength);
 
 	/* Get info on the SOCRAM cores... */
 	bus->ramsize = bus->ci->ramsize;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 82bf3c5..1ce8cb7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -73,50 +73,6 @@
 #define D11_BCMA_IOCTL_PHYCLOCKEN	0x0004
 #define D11_BCMA_IOCTL_PHYRESET		0x0008
 
-#define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
-/* SDIO Pad drive strength to select value mappings */
-struct sdiod_drive_str {
-	u8 strength;	/* Pad Drive Strength in mA */
-	u8 sel;		/* Chip-specific select value */
-};
-/* SDIO Drive Strength to sel value table for PMU Rev 11 (1.8V) */
-static const struct sdiod_drive_str sdiod_drvstr_tab1_1v8[] = {
-	{32, 0x6},
-	{26, 0x7},
-	{22, 0x4},
-	{16, 0x5},
-	{12, 0x2},
-	{8, 0x3},
-	{4, 0x0},
-	{0, 0x1}
-};
-
-/* SDIO Drive Strength to sel value table for PMU Rev 13 (1.8v) */
-static const struct sdiod_drive_str sdiod_drive_strength_tab5_1v8[] = {
-        {6, 0x7},
-        {5, 0x6},
-        {4, 0x5},
-        {3, 0x4},
-        {2, 0x2},
-        {1, 0x1},
-        {0, 0x0}
-};
-
-/* SDIO Drive Strength to sel value table for PMU Rev 17 (1.8v) */
-static const struct sdiod_drive_str sdiod_drvstr_tab6_1v8[] = {
-	{3, 0x3},
-	{2, 0x2},
-	{1, 0x1},
-	{0, 0x0} };
-
-/* SDIO Drive Strength to sel value table for 43143 PMU Rev 17 (3.3V) */
-static const struct sdiod_drive_str sdiod_drvstr_tab2_3v3[] = {
-	{16, 0x7},
-	{12, 0x5},
-	{8,  0x3},
-	{4,  0x1}
-};
-
 u8
 brcmf_sdio_chip_getinfidx(struct brcmf_chip *ci, u16 coreid)
 {
@@ -661,51 +617,6 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	return brcmf_sdio_chip_cichk(ci);
 }
 
-static int
-brcmf_sdio_chip_buscoreprep(struct brcmf_sdio_dev *sdiodev)
-{
-	int err = 0;
-	u8 clkval, clkset;
-
-	/* Try forcing SDIO core to do ALPAvail request only */
-	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_ALP_AVAIL_REQ;
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
-	if (err) {
-		brcmf_err("error writing for HT off\n");
-		return err;
-	}
-
-	/* If register supported, wait for ALPAvail and then force ALP */
-	/* This may take up to 15 milliseconds */
-	clkval = brcmf_sdiod_regrb(sdiodev,
-				   SBSDIO_FUNC1_CHIPCLKCSR, NULL);
-
-	if ((clkval & ~SBSDIO_AVBITS) != clkset) {
-		brcmf_err("ChipClkCSR access: wrote 0x%02x read 0x%02x\n",
-			  clkset, clkval);
-		return -EACCES;
-	}
-
-	SPINWAIT(((clkval = brcmf_sdiod_regrb(sdiodev,
-					      SBSDIO_FUNC1_CHIPCLKCSR, NULL)),
-			!SBSDIO_ALPAV(clkval)),
-			PMU_MAX_TRANSITION_DLY);
-	if (!SBSDIO_ALPAV(clkval)) {
-		brcmf_err("timeout on ALPAV wait, clkval 0x%02x\n",
-			  clkval);
-		return -EBUSY;
-	}
-
-	clkset = SBSDIO_FORCE_HW_CLKREQ_OFF | SBSDIO_FORCE_ALP;
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_CHIPCLKCSR, clkset, &err);
-	udelay(65);
-
-	/* Also, disable the extra SDIO pull-ups */
-	brcmf_sdiod_regwb(sdiodev, SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
-
-	return 0;
-}
-
 static void
 brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 			     struct brcmf_chip *ci)
@@ -754,7 +665,7 @@ int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 	if (!ci)
 		return -ENOMEM;
 
-	ret = brcmf_sdio_chip_buscoreprep(sdiodev);
+	ret = brcmf_sdio_buscoreprep(sdiodev);
 	if (ret != 0)
 		goto err;
 
@@ -786,87 +697,6 @@ brcmf_sdio_chip_detach(struct brcmf_chip **ci_ptr)
 	*ci_ptr = NULL;
 }
 
-static char *brcmf_sdio_chip_name(uint chipid, char *buf, uint len)
-{
-	const char *fmt;
-
-	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
-	snprintf(buf, len, fmt, chipid);
-	return buf;
-}
-
-void
-brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
-				  struct brcmf_chip *ci, u32 drivestrength)
-{
-	const struct sdiod_drive_str *str_tab = NULL;
-	u32 str_mask;
-	u32 str_shift;
-	char chn[8];
-	u32 base = ci->c_inf[0].base;
-	u32 i;
-	u32 drivestrength_sel = 0;
-	u32 cc_data_temp;
-	u32 addr;
-
-	if (!(ci->c_inf[0].caps & CC_CAP_PMU))
-		return;
-
-	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
-	case SDIOD_DRVSTR_KEY(BCM4330_CHIP_ID, 12):
-		str_tab = sdiod_drvstr_tab1_1v8;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4334_CHIP_ID, 17):
-		str_tab = sdiod_drvstr_tab6_1v8;
-		str_mask = 0x00001800;
-		str_shift = 11;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM43143_CHIP_ID, 17):
-		/* note: 43143 does not support tristate */
-		i = ARRAY_SIZE(sdiod_drvstr_tab2_3v3) - 1;
-		if (drivestrength >= sdiod_drvstr_tab2_3v3[i].strength) {
-			str_tab = sdiod_drvstr_tab2_3v3;
-			str_mask = 0x00000007;
-			str_shift = 0;
-		} else
-			brcmf_err("Invalid SDIO Drive strength for chip %s, strength=%d\n",
-				  brcmf_sdio_chip_name(ci->chip, chn, 8),
-				  drivestrength);
-		break;
-	case SDIOD_DRVSTR_KEY(BCM43362_CHIP_ID, 13):
-		str_tab = sdiod_drive_strength_tab5_1v8;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	default:
-		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
-			  brcmf_sdio_chip_name(ci->chip, chn, 8),
-			  ci->chiprev, ci->pmurev);
-		break;
-	}
-
-	if (str_tab != NULL) {
-		for (i = 0; str_tab[i].strength != 0; i++) {
-			if (drivestrength >= str_tab[i].strength) {
-				drivestrength_sel = str_tab[i].sel;
-				break;
-			}
-		}
-		addr = CORE_CC_REG(base, chipcontrol_addr);
-		brcmf_sdiod_regwl(sdiodev, addr, 1, NULL);
-		cc_data_temp = brcmf_sdiod_regrl(sdiodev, addr, NULL);
-		cc_data_temp &= ~str_mask;
-		drivestrength_sel <<= str_shift;
-		cc_data_temp |= drivestrength_sel;
-		brcmf_sdiod_regwl(sdiodev, addr, cc_data_temp, NULL);
-
-		brcmf_dbg(INFO, "SDIO: %d mA (req=%d mA) drive strength selected, set to 0x%08x\n",
-			  str_tab[i].strength, drivestrength, cc_data_temp);
-	}
-}
-
 static void
 brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 			    struct brcmf_chip *ci)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index fb06143..2bc00c5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -219,9 +219,6 @@ struct sdpcmd_regs {
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 			   struct brcmf_chip **ci_ptr);
 void brcmf_sdio_chip_detach(struct brcmf_chip **ci_ptr);
-void brcmf_sdio_chip_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
-				       struct brcmf_chip *ci,
-				       u32 drivestrength);
 u8 brcmf_sdio_chip_getinfidx(struct brcmf_chip *ci, u16 coreid);
 void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
 				    struct brcmf_chip *ci);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 092e9c8..396c06c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -239,5 +239,6 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus);
 void brcmf_sdio_isr(struct brcmf_sdio *bus);
 
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
+int brcmf_sdio_buscoreprep(struct brcmf_sdio_dev *sdiodev);
 
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.10.4

