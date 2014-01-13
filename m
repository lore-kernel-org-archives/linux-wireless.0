Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:45221 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaAMVUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:42 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/8] brcmfmac: update core reset and disable routines.
Date: Mon, 13 Jan 2014 22:20:23 +0100
Message-ID: <1389648029-23560-3-git-send-email-arend@broadcom.com> (sfid-20140113_222049_334884_82307907)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The original core reset and disable routines do not work always
on running system. These routines were updated to properly reset
a core. When module is unloaded the device is put into download
state where all necessary cores have been reset. This will make
sure the device is in idle mode after module unload.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    8 +-
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  149 +++++++++++++-------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    6 +-
 3 files changed, 106 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 4f936c6..1905789 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -2263,8 +2263,6 @@ static void brcmf_sdio_bus_stop(struct device *dev)
 	w_sdreg32(bus, local_hostintmask,
 		  offsetof(struct sdpcmd_regs, intstatus));
 
-	/* Turn off the backplane clock (only) */
-	brcmf_sdio_clkctl(bus, CLK_SDONLY, false);
 	sdio_release_host(bus->sdiodev->func[1]);
 
 	/* Clear the data packet queues */
@@ -4085,6 +4083,12 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 		if (bus->ci) {
 			sdio_claim_host(bus->sdiodev->func[1]);
 			brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
+			/* Leave the device in state where it is 'quiet'. This
+			 * is done by putting it in download_state which
+			 * essentially resets all necessary cores
+			 */
+			msleep(20);
+			brcmf_sdio_download_state(bus, true);
 			brcmf_sdio_clkctl(bus, CLK_NONE, false);
 			sdio_release_host(bus->sdiodev->func[1]);
 			brcmf_sdio_chip_detach(&bus->ci);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index a74a3d1..4342976 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -51,6 +51,9 @@
 #define BCM43143_CORE_ARM_BASE		0x18003000
 #define BCM43143_RAMSIZE		0x70000
 
+/* All D11 cores, ID 0x812 */
+#define BCM43xx_CORE_D11_BASE		0x18001000
+
 #define	SBCOREREV(sbidh) \
 	((((sbidh) & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT) | \
 	  ((sbidh) & SSB_IDHIGH_RCLO))
@@ -66,6 +69,10 @@
 /* ARM CR4 core specific control flag bits */
 #define ARMCR4_BCMA_IOCTL_CPUHALT	0x0020
 
+/* D11 core specific control flag bits */
+#define D11_BCMA_IOCTL_PHYCLOCKEN	0x0004
+#define D11_BCMA_IOCTL_PHYRESET		0x0008
+
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
@@ -193,7 +200,8 @@ brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid, u32 core_bits)
+			  struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			  u32 in_resetbits)
 {
 	u32 regdata, base;
 	u8 idx;
@@ -279,52 +287,48 @@ brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct chip_info *ci, u16 coreid, u32 core_bits)
+			  struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			  u32 in_resetbits)
 {
 	u8 idx;
 	u32 regdata;
+	u32 wrapbase;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 	if (idx == BRCMF_MAX_CORENUM)
 		return;
 
+	wrapbase = ci->c_inf[idx].wrapbase;
+
 	/* if core is already in reset, just return */
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-				    NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
-	/* ensure no pending backplane operation
-	 * 300uc should be sufficient for backplane ops to be finish
-	 * extra 10ms is taken into account for firmware load stage
-	 * after 10300us carry on disabling the core anyway
-	 */
-	SPINWAIT(brcmf_sdiod_regrl(sdiodev,
-				   ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
-				   NULL), 10300);
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    ci->c_inf[idx].wrapbase+BCMA_RESET_ST,
-				    NULL);
-	if (regdata)
-		brcmf_err("disabling core 0x%x with reset status %x\n",
-			  coreid, regdata);
+	/* configure reset */
+	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, pre_resetbits |
+			  BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
 
-	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
+	/* put in reset */
+	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_RESET_CTL,
 			  BCMA_RESET_CTL_RESET, NULL);
-	udelay(1);
-
-	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			  core_bits, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				    NULL);
 	usleep_range(10, 20);
 
+	/* wait till reset is 1 */
+	SPINWAIT(brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL) !=
+		 BCMA_RESET_CTL_RESET, 300);
+
+	/* post reset configure */
+	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, pre_resetbits |
+			  BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
 }
 
 static void
 brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 core_bits)
+			struct chip_info *ci, u16 coreid,  u32 pre_resetbits,
+			u32 in_resetbits, u32 post_resetbits)
 {
 	u32 regdata;
 	u8 idx;
@@ -337,7 +341,8 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdio_sb_coredisable(sdiodev, ci, coreid, 0);
+	brcmf_sdio_sb_coredisable(sdiodev, ci, coreid, pre_resetbits,
+				  in_resetbits);
 
 	/*
 	 * Now do the initialization sequence.
@@ -390,35 +395,32 @@ brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
 
 static void
 brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 core_bits)
+			struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			u32 in_resetbits, u32 post_resetbits)
 {
 	u8 idx;
 	u32 regdata;
+	u32 wrapbase;
 
 	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
 	if (idx == BRCMF_MAX_CORENUM)
 		return;
 
+	wrapbase = ci->c_inf[idx].wrapbase;
+
 	/* must disable first to work for arbitrary current core state */
-	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid, core_bits);
+	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid, pre_resetbits,
+				  in_resetbits);
 
-	/* now do initialization sequence */
-	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			  core_bits | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				    NULL);
-	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-			  0, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-				    NULL);
-	udelay(1);
+	while (brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL) &
+	       BCMA_RESET_CTL_RESET) {
+		brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_RESET_CTL, 0, NULL);
+		usleep_range(40, 60);
+	}
 
-	brcmf_sdiod_regwl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-			  core_bits | BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				    NULL);
-	udelay(1);
+	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, post_resetbits |
+			  BCMA_IOCTL_CLK, NULL);
+	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
 }
 
 #ifdef DEBUG
@@ -498,6 +500,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].base = BCM43143_CORE_ARM_BASE;
 		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
 		ci->c_inf[3].cib = 0x07000000;
+		ci->c_inf[4].id = BCMA_CORE_80211;
+		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
 		ci->ramsize = BCM43143_RAMSIZE;
 		break;
 	case BCM43241_CHIP_ID:
@@ -515,6 +520,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].base = 0x18003000;
 		ci->c_inf[3].wrapbase = 0x18103000;
 		ci->c_inf[3].cib = 0x07004211;
+		ci->c_inf[4].id = BCMA_CORE_80211;
+		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
 		ci->ramsize = 0x90000;
 		break;
 	case BCM4329_CHIP_ID:
@@ -524,6 +532,8 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[2].base = BCM4329_CORE_SOCRAM_BASE;
 		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
 		ci->c_inf[3].base = BCM4329_CORE_ARM_BASE;
+		ci->c_inf[4].id = BCMA_CORE_80211;
+		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
 		ci->ramsize = BCM4329_RAMSIZE;
 		break;
 	case BCM4330_CHIP_ID:
@@ -541,6 +551,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].base = 0x18003000;
 		ci->c_inf[3].wrapbase = 0x18103000;
 		ci->c_inf[3].cib = 0x03004211;
+		ci->c_inf[4].id = BCMA_CORE_80211;
+		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
 		ci->ramsize = 0x48000;
 		break;
 	case BCM4334_CHIP_ID:
@@ -558,6 +571,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].base = 0x18003000;
 		ci->c_inf[3].wrapbase = 0x18103000;
 		ci->c_inf[3].cib = 0x07004211;
+		ci->c_inf[4].id = BCMA_CORE_80211;
+		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
 		ci->ramsize = 0x80000;
 		break;
 	case BCM4335_CHIP_ID:
@@ -571,6 +587,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[2].base = 0x18002000;
 		ci->c_inf[2].wrapbase = 0x18102000;
 		ci->c_inf[2].cib = 0x01084411;
+		ci->c_inf[3].id = BCMA_CORE_80211;
+		ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
 		ci->ramsize = 0xc0000;
 		ci->rambase = 0x180000;
 		break;
@@ -585,6 +604,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[2].base = 0x18002000;
 		ci->c_inf[2].wrapbase = 0x18102000;
 		ci->c_inf[2].cib = 0x04084411;
+		ci->c_inf[3].id = BCMA_CORE_80211;
+		ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
 		ci->ramsize = 0xc0000;
 		ci->rambase = 0x180000;
 		break;
@@ -603,6 +625,9 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		ci->c_inf[3].base = 0x18003000;
 		ci->c_inf[3].wrapbase = 0x18103000;
 		ci->c_inf[3].cib = 0x03004211;
+		ci->c_inf[4].id = BCMA_CORE_80211;
+		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
+		ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
 		ci->ramsize = 0x3C000;
 		break;
 	default:
@@ -713,7 +738,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
+	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0);
 }
 
 int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
@@ -846,8 +871,11 @@ static void
 brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 			    struct chip_info *ci)
 {
-	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
-	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0);
+	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
+		      D11_BCMA_IOCTL_PHYRESET | D11_BCMA_IOCTL_PHYCLOCKEN,
+		      D11_BCMA_IOCTL_PHYCLOCKEN, D11_BCMA_IOCTL_PHYCLOCKEN);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0, 0, 0);
 }
 
 static bool
@@ -867,7 +895,7 @@ brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
 	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
 
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3, 0);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0, 0);
 
 	return true;
 }
@@ -876,8 +904,22 @@ static inline void
 brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
 			    struct chip_info *ci)
 {
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4,
-		      ARMCR4_BCMA_IOCTL_CPUHALT);
+	u8 idx;
+	u32 regdata;
+	u32 wrapbase;
+	idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CR4);
+
+	if (idx == BRCMF_MAX_CORENUM)
+		return;
+
+	wrapbase = ci->c_inf[idx].wrapbase;
+	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
+	regdata &= ARMCR4_BCMA_IOCTL_CPUHALT;
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, regdata,
+		      ARMCR4_BCMA_IOCTL_CPUHALT, ARMCR4_BCMA_IOCTL_CPUHALT);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
+		      D11_BCMA_IOCTL_PHYRESET | D11_BCMA_IOCTL_PHYCLOCKEN,
+		      D11_BCMA_IOCTL_PHYCLOCKEN, D11_BCMA_IOCTL_PHYCLOCKEN);
 }
 
 static bool
@@ -897,7 +939,8 @@ brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 			  sizeof(ci->rst_vec));
 
 	/* restore ARM */
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, 0);
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, ARMCR4_BCMA_IOCTL_CPUHALT,
+		      0, 0);
 
 	return true;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index c7d0dbc..91c61cb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -81,9 +81,11 @@ struct chip_info {
 	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci,
 			 u16 coreid);
 	void (*coredisable)(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 core_bits);
+			struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			u32 in_resetbits);
 	void (*resetcore)(struct brcmf_sdio_dev *sdiodev,
-			struct chip_info *ci, u16 coreid, u32 core_bits);
+			struct chip_info *ci, u16 coreid, u32 pre_resetbits,
+			u32 in_resetbits, u32 post_resetbits);
 };
 
 struct sbconfig {
-- 
1.7.10.4

