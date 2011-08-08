Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3250 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 59/82] staging: brcm80211: reformat long lines in
 brcmsmac to 80 columns
Date: Mon, 8 Aug 2011 15:58:43 +0200
Message-ID: <1312811946-16713-60-git-send-email-arend@broadcom.com> (sfid-20110808_160033_132423_5CFE99EC)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux coding style strongly suggest to limit length of source lines
to 80 characters. This commit correct this for the brcmsmac sources.

Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |  191 ++++---
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |   21 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |  196 ++++--
 drivers/staging/brcm80211/brcmsmac/antsel.c      |   15 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |  151 +++--
 drivers/staging/brcm80211/brcmsmac/channel.h     |   15 +-
 drivers/staging/brcm80211/brcmsmac/d11.h         |  617 ++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/dma.c         |  247 +++++---
 drivers/staging/brcm80211/brcmsmac/dma.h         |   15 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   26 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    9 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |  701 ++++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/main.h        |  696 +++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/otp.c         |   32 +-
 drivers/staging/brcm80211/brcmsmac/otp.h         |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    9 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |   60 ++-
 drivers/staging/brcm80211/brcmsmac/pmu.c         |   10 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |  186 ++++---
 drivers/staging/brcm80211/brcmsmac/rate.c        |  104 ++--
 drivers/staging/brcm80211/brcmsmac/rate.h        |  141 +++--
 drivers/staging/brcm80211/brcmsmac/scb.h         |   35 +-
 drivers/staging/brcm80211/brcmsmac/srom.c        |   70 ++-
 drivers/staging/brcm80211/brcmsmac/stf.c         |   54 ++-
 drivers/staging/brcm80211/brcmsmac/types.h       |  182 ++++--
 25 files changed, 2394 insertions(+), 1392 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index bc4e2e1..4b1c60f 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -28,48 +28,68 @@
 #include "aiutils.h"
 
 /* slow_clk_ctl */
-#define SCC_SS_MASK		0x00000007	/* slow clock source mask */
-#define	SCC_SS_LPO		0x00000000	/* source of slow clock is LPO */
-#define	SCC_SS_XTAL		0x00000001	/* source of slow clock is crystal */
-#define	SCC_SS_PCI		0x00000002	/* source of slow clock is PCI */
-#define SCC_LF			0x00000200	/* LPOFreqSel, 1: 160Khz, 0: 32KHz */
-#define SCC_LP			0x00000400	/* LPOPowerDown, 1: LPO is disabled,
-						 * 0: LPO is enabled
-						 */
-#define SCC_FS			0x00000800	/* ForceSlowClk, 1: sb/cores running on slow clock,
-						 * 0: power logic control
-						 */
-#define SCC_IP			0x00001000	/* IgnorePllOffReq, 1/0: power logic ignores/honors
-						 * PLL clock disable requests from core
-						 */
-#define SCC_XC			0x00002000	/* XtalControlEn, 1/0: power logic does/doesn't
-						 * disable crystal when appropriate
-						 */
-#define SCC_XP			0x00004000	/* XtalPU (RO), 1/0: crystal running/disabled */
-#define SCC_CD_MASK		0xffff0000	/* ClockDivider (SlowClk = 1/(4+divisor)) */
+ /* slow clock source mask */
+#define SCC_SS_MASK		0x00000007
+ /* source of slow clock is LPO */
+#define	SCC_SS_LPO		0x00000000
+ /* source of slow clock is crystal */
+#define	SCC_SS_XTAL		0x00000001
+ /* source of slow clock is PCI */
+#define	SCC_SS_PCI		0x00000002
+ /* LPOFreqSel, 1: 160Khz, 0: 32KHz */
+#define SCC_LF			0x00000200
+ /* LPOPowerDown, 1: LPO is disabled, 0: LPO is enabled */
+#define SCC_LP			0x00000400
+ /* ForceSlowClk, 1: sb/cores running on slow clock, 0: power logic control */
+#define SCC_FS			0x00000800
+ /* IgnorePllOffReq, 1/0:
+  *  power logic ignores/honors PLL clock disable requests from core
+  */
+#define SCC_IP			0x00001000
+ /* XtalControlEn, 1/0:
+  *  power logic does/doesn't disable crystal when appropriate
+  */
+#define SCC_XC			0x00002000
+ /* XtalPU (RO), 1/0: crystal running/disabled */
+#define SCC_XP			0x00004000
+ /* ClockDivider (SlowClk = 1/(4+divisor)) */
+#define SCC_CD_MASK		0xffff0000
 #define SCC_CD_SHIFT		16
 
 /* system_clk_ctl */
-#define	SYCC_IE			0x00000001	/* ILPen: Enable Idle Low Power */
-#define	SYCC_AE			0x00000002	/* ALPen: Enable Active Low Power */
-#define	SYCC_FP			0x00000004	/* ForcePLLOn */
-#define	SYCC_AR			0x00000008	/* Force ALP (or HT if ALPen is not set */
-#define	SYCC_HR			0x00000010	/* Force HT */
-#define SYCC_CD_MASK		0xffff0000	/* ClkDiv  (ILP = 1/(4 * (divisor + 1)) */
+ /* ILPen: Enable Idle Low Power */
+#define	SYCC_IE			0x00000001
+ /* ALPen: Enable Active Low Power */
+#define	SYCC_AE			0x00000002
+ /* ForcePLLOn */
+#define	SYCC_FP			0x00000004
+ /* Force ALP (or HT if ALPen is not set */
+#define	SYCC_AR			0x00000008
+ /* Force HT */
+#define	SYCC_HR			0x00000010
+ /* ClkDiv  (ILP = 1/(4 * (divisor + 1)) */
+#define SYCC_CD_MASK		0xffff0000
 #define SYCC_CD_SHIFT		16
 
 #define CST4329_SPROM_OTP_SEL_MASK	0x00000003
-#define CST4329_DEFCIS_SEL		0	/* OTP is powered up, use def. CIS, no SPROM */
-#define CST4329_SPROM_SEL		1	/* OTP is powered up, SPROM is present */
-#define CST4329_OTP_SEL			2	/* OTP is powered up, no SPROM */
-#define CST4329_OTP_PWRDN		3	/* OTP is powered down, SPROM is present */
+ /* OTP is powered up, use def. CIS, no SPROM */
+#define CST4329_DEFCIS_SEL		0
+ /* OTP is powered up, SPROM is present */
+#define CST4329_SPROM_SEL		1
+ /* OTP is powered up, no SPROM */
+#define CST4329_OTP_SEL			2
+ /* OTP is powered down, SPROM is present */
+#define CST4329_OTP_PWRDN		3
+
 #define CST4329_SPI_SDIO_MODE_MASK	0x00000004
 #define CST4329_SPI_SDIO_MODE_SHIFT	2
 
 /* 43224 chip-specific ChipControl register bits */
 #define CCTRL43224_GPIO_TOGGLE          0x8000
-#define CCTRL_43224A0_12MA_LED_DRIVE    0x00F000F0	/* 12 mA drive strength */
-#define CCTRL_43224B0_12MA_LED_DRIVE    0xF0	/* 12 mA drive strength for later 43224s */
+ /* 12 mA drive strength */
+#define CCTRL_43224A0_12MA_LED_DRIVE    0x00F000F0
+ /* 12 mA drive strength for later 43224s */
+#define CCTRL_43224B0_12MA_LED_DRIVE    0xF0
 
 /* 43236 Chip specific ChipStatus register bits */
 #define CST43236_SFLASH_MASK		0x00000040
@@ -78,29 +98,44 @@
 #define CST43236_BP_CLK			0x00000200	/* 120/96Mbps */
 #define CST43236_BOOT_MASK		0x00001800
 #define CST43236_BOOT_SHIFT		11
-#define CST43236_BOOT_FROM_SRAM		0	/* boot from SRAM, ARM in reset */
-#define CST43236_BOOT_FROM_ROM		1	/* boot from ROM */
-#define CST43236_BOOT_FROM_FLASH	2	/* boot from FLASH */
+#define CST43236_BOOT_FROM_SRAM		0 /* boot from SRAM, ARM in reset */
+#define CST43236_BOOT_FROM_ROM		1 /* boot from ROM */
+#define CST43236_BOOT_FROM_FLASH	2 /* boot from FLASH */
 #define CST43236_BOOT_FROM_INVALID	3
 
 /* 4331 chip-specific ChipControl register bits */
-#define CCTRL4331_BT_COEXIST		(1<<0)	/* 0 disable */
-#define CCTRL4331_SECI			(1<<1)	/* 0 SECI is disabled (JATG functional) */
-#define CCTRL4331_EXT_LNA		(1<<2)	/* 0 disable */
-#define CCTRL4331_SPROM_GPIO13_15       (1<<3)	/* sprom/gpio13-15 mux */
-#define CCTRL4331_EXTPA_EN		(1<<4)	/* 0 ext pa disable, 1 ext pa enabled */
-#define CCTRL4331_GPIOCLK_ON_SPROMCS	(1<<5)	/* set drive out GPIO_CLK on sprom_cs pin */
-#define CCTRL4331_PCIE_MDIO_ON_SPROMCS	(1<<6)	/* use sprom_cs pin as PCIE mdio interface */
-#define CCTRL4331_EXTPA_ON_GPIO2_5	(1<<7)	/* aband extpa will be at gpio2/5 and sprom_dout */
-#define CCTRL4331_OVR_PIPEAUXCLKEN	(1<<8)	/* override core control on pipe_AuxClkEnable */
-#define CCTRL4331_OVR_PIPEAUXPWRDOWN	(1<<9)	/* override core control on pipe_AuxPowerDown */
-#define CCTRL4331_PCIE_AUXCLKEN		(1<<10)	/* pcie_auxclkenable */
-#define CCTRL4331_PCIE_PIPE_PLLDOWN	(1<<11)	/* pcie_pipe_pllpowerdown */
-#define CCTRL4331_BT_SHD0_ON_GPIO4	(1<<16)	/* enable bt_shd0 at gpio4 */
-#define CCTRL4331_BT_SHD1_ON_GPIO5	(1<<17)	/* enable bt_shd1 at gpio5 */
+ /* 0 disable */
+#define CCTRL4331_BT_COEXIST		(1<<0)
+ /* 0 SECI is disabled (JTAG functional) */
+#define CCTRL4331_SECI			(1<<1)
+ /* 0 disable */
+#define CCTRL4331_EXT_LNA		(1<<2)
+ /* sprom/gpio13-15 mux */
+#define CCTRL4331_SPROM_GPIO13_15       (1<<3)
+ /* 0 ext pa disable, 1 ext pa enabled */
+#define CCTRL4331_EXTPA_EN		(1<<4)
+ /* set drive out GPIO_CLK on sprom_cs pin */
+#define CCTRL4331_GPIOCLK_ON_SPROMCS	(1<<5)
+ /* use sprom_cs pin as PCIE mdio interface */
+#define CCTRL4331_PCIE_MDIO_ON_SPROMCS	(1<<6)
+ /* aband extpa will be at gpio2/5 and sprom_dout */
+#define CCTRL4331_EXTPA_ON_GPIO2_5	(1<<7)
+ /* override core control on pipe_AuxClkEnable */
+#define CCTRL4331_OVR_PIPEAUXCLKEN	(1<<8)
+ /* override core control on pipe_AuxPowerDown */
+#define CCTRL4331_OVR_PIPEAUXPWRDOWN	(1<<9)
+ /* pcie_auxclkenable */
+#define CCTRL4331_PCIE_AUXCLKEN		(1<<10)
+ /* pcie_pipe_pllpowerdown */
+#define CCTRL4331_PCIE_PIPE_PLLDOWN	(1<<11)
+ /* enable bt_shd0 at gpio4 */
+#define CCTRL4331_BT_SHD0_ON_GPIO4	(1<<16)
+ /* enable bt_shd1 at gpio5 */
+#define CCTRL4331_BT_SHD1_ON_GPIO5	(1<<17)
 
 /* 4331 Chip specific ChipStatus register bits */
-#define	CST4331_XTAL_FREQ		0x00000001	/* crystal frequency 20/40Mhz */
+ /* crystal frequency 20/40Mhz */
+#define	CST4331_XTAL_FREQ		0x00000001
 #define	CST4331_SPROM_PRESENT		0x00000002
 #define	CST4331_OTP_PRESENT		0x00000004
 #define	CST4331_LDO_RF			0x00000008
@@ -110,19 +145,26 @@
 #define	CST4319_SPI_CPULESSUSB		0x00000001
 #define	CST4319_SPI_CLK_POL		0x00000002
 #define	CST4319_SPI_CLK_PH		0x00000008
-#define	CST4319_SPROM_OTP_SEL_MASK	0x000000c0	/* gpio [7:6], SDIO CIS selection */
+ /* gpio [7:6], SDIO CIS selection */
+#define	CST4319_SPROM_OTP_SEL_MASK	0x000000c0
 #define	CST4319_SPROM_OTP_SEL_SHIFT	6
-#define	CST4319_DEFCIS_SEL		0x00000000	/* use default CIS, OTP is powered up */
-#define	CST4319_SPROM_SEL		0x00000040	/* use SPROM, OTP is powered up */
-#define	CST4319_OTP_SEL			0x00000080	/* use OTP, OTP is powered up */
-#define	CST4319_OTP_PWRDN		0x000000c0	/* use SPROM, OTP is powered down */
-#define	CST4319_SDIO_USB_MODE		0x00000100	/* gpio [8], sdio/usb mode */
+ /* use default CIS, OTP is powered up */
+#define	CST4319_DEFCIS_SEL		0x00000000
+ /* use SPROM, OTP is powered up */
+#define	CST4319_SPROM_SEL		0x00000040
+ /* use OTP, OTP is powered up */
+#define	CST4319_OTP_SEL			0x00000080
+ /* use SPROM, OTP is powered down */
+#define	CST4319_OTP_PWRDN		0x000000c0
+ /* gpio [8], sdio/usb mode */
+#define	CST4319_SDIO_USB_MODE		0x00000100
 #define	CST4319_REMAP_SEL_MASK		0x00000600
 #define	CST4319_ILPDIV_EN		0x00000800
 #define	CST4319_XTAL_PD_POL		0x00001000
 #define	CST4319_LPO_SEL			0x00002000
 #define	CST4319_RES_INIT_MODE		0x0000c000
-#define	CST4319_PALDO_EXTPNP		0x00010000	/* PALDO is configured with external PNP */
+ /* PALDO is configured with external PNP */
+#define	CST4319_PALDO_EXTPNP		0x00010000
 #define	CST4319_CBUCK_MODE_MASK		0x00060000
 #define CST4319_CBUCK_MODE_BURST	0x00020000
 #define CST4319_CBUCK_MODE_LPBURST	0x00060000
@@ -153,7 +195,8 @@
 #define	CST4313_SPROM_OTP_SEL_SHIFT		0
 
 /* 4313 Chip specific ChipControl register bits */
-#define CCTRL_4313_12MA_LED_DRIVE    0x00000007	/* 12 mA drive strengh for later 4313 */
+ /* 12 mA drive strengh for later 4313 */
+#define CCTRL_4313_12MA_LED_DRIVE    0x00000007
 
 #define BCM47162_DMP() ((sih->chip == BCM47162_CHIP_ID) && \
 		(sih->chiprev == 0) && \
@@ -227,9 +270,12 @@
 #define	SD_SG32			0x00000008
 #define	SD_SZ_ALIGN		0x00000fff
 
-#define	PCI_CFG_GPIO_SCS	0x10	/* PCI config space bit 4 for 4306c0 slow clock source */
-#define PCI_CFG_GPIO_XTAL	0x40	/* PCI config space GPIO 14 for Xtal power-up */
-#define PCI_CFG_GPIO_PLL	0x80	/* PCI config space GPIO 15 for PLL power-down */
+/* PCI config space bit 4 for 4306c0 slow clock source */
+#define	PCI_CFG_GPIO_SCS	0x10
+/* PCI config space GPIO 14 for Xtal power-up */
+#define PCI_CFG_GPIO_XTAL	0x40
+/* PCI config space GPIO 15 for PLL power-down */
+#define PCI_CFG_GPIO_PLL	0x80
 
 /* power control defines */
 #define PLL_DELAY		150	/* us pll on delay */
@@ -468,7 +514,8 @@ void ai_scan(struct si_pub *sih, void *regs)
 	}
 	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
 
-	SI_VMSG(("ai_scan: regs = 0x%p, erombase = 0x%08x, eromptr = 0x%p, eromlim = 0x%p\n", regs, erombase, eromptr, eromlim));
+	SI_VMSG(("ai_scan: regs = 0x%p, erombase = 0x%08x, eromptr = 0x%p, "
+		 "eromlim = 0x%p\n", regs, erombase, eromptr, eromlim));
 	while (eromptr < eromlim) {
 		u32 cia, cib, cid, mfg, crev, nmw, nsw, nmp, nsp;
 		u32 mpd, asd, addrl, addrh, sizel, sizeh;
@@ -502,7 +549,9 @@ void ai_scan(struct si_pub *sih, void *regs)
 		nmp = (cib & CIB_NMP_MASK) >> CIB_NMP_SHIFT;
 		nsp = (cib & CIB_NSP_MASK) >> CIB_NSP_SHIFT;
 
-		SI_VMSG(("Found component 0x%04x/0x%04x rev %d at erom addr 0x%p, with nmw = %d, " "nsw = %d, nmp = %d & nsp = %d\n", mfg, cid, crev, base, nmw, nsw, nmp, nsp));
+		SI_VMSG(("Found component 0x%04x/0x%04x rev %d at erom addr "
+			 "0x%p, with nmw = %d, nsw = %d, nmp = %d & nsp = %d\n",
+			 mfg, cid, crev, base, nmw, nsw, nmp, nsp));
 
 		if (((mfg == MFGID_ARM) && (cid == DEF_AI_COMP)) || (nsp == 0))
 			continue;
@@ -526,7 +575,8 @@ void ai_scan(struct si_pub *sih, void *regs)
 		for (i = 0; i < nmp; i++) {
 			mpd = get_erom_ent(sih, &eromptr, ER_VALID, ER_VALID);
 			if ((mpd & ER_TAG) != ER_MP) {
-				SI_ERROR(("Not enough MP entries for component 0x%x\n", cid));
+				SI_ERROR(("Not enough MP entries for "
+					  "component 0x%x\n", cid));
 				goto error;
 			}
 			SI_VMSG(("  Master port %d, mp: %d id: %d\n", i,
@@ -549,7 +599,8 @@ void ai_scan(struct si_pub *sih, void *regs)
 				br = true;
 			else if ((addrh != 0) || (sizeh != 0)
 				 || (sizel != SI_CORE_SIZE)) {
-				SI_ERROR(("First Slave ASD for core 0x%04x malformed " "(0x%08x)\n", cid, asd));
+				SI_ERROR(("First Slave ASD for core 0x%04x "
+					  "malformed (0x%08x)\n", cid, asd));
 				goto error;
 			}
 		}
@@ -704,7 +755,8 @@ u32 ai_addrspace(struct si_pub *sih, uint asidx)
 	else if (asidx == 1)
 		return sii->coresba2[cidx];
 	else {
-		SI_ERROR(("%s: Need to parse the erom again to find addr space %d\n", __func__, asidx));
+		SI_ERROR(("%s: Need to parse the erom again to find addr "
+			  "space %d\n", __func__, asidx));
 		return 0;
 	}
 }
@@ -723,7 +775,8 @@ u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
 	else if (asidx == 1)
 		return sii->coresba2_size[cidx];
 	else {
-		SI_ERROR(("%s: Need to parse the erom again to find addr space %d\n", __func__, asidx));
+		SI_ERROR(("%s: Need to parse the erom again to find addr "
+			  "space %d\n", __func__, asidx));
 		return 0;
 	}
 }
@@ -735,7 +788,8 @@ uint ai_flag(struct si_pub *sih)
 
 	sii = SI_INFO(sih);
 	if (BCM47162_DMP()) {
-		SI_ERROR(("%s: Attempting to read MIPS DMP registers on 47162a0", __func__));
+		SI_ERROR(("%s: Attempting to read MIPS DMP registers "
+			  "on 47162a0", __func__));
 		return sii->curidx;
 	}
 	ai = sii->curwrap;
@@ -833,7 +887,8 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 
 	sii = SI_INFO(sih);
 	if (BCM47162_DMP()) {
-		SI_ERROR(("%s: Accessing MIPS DMP register (iostatus) on 47162a0", __func__));
+		SI_ERROR(("%s: Accessing MIPS DMP register (iostatus) "
+			  "on 47162a0", __func__));
 		return 0;
 	}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index f881b44..4c682a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -242,16 +242,23 @@
 #define	SRC_PRESENT		0x00000001
 
 /* 4330 chip-specific ChipStatus register bits */
-#define CST4330_CHIPMODE_SDIOD(cs)	(((cs) & 0x7) < 6)	/* SDIO || gSPI */
-#define CST4330_CHIPMODE_USB20D(cs)	(((cs) & 0x7) >= 6)	/* USB || USBDA */
-#define CST4330_CHIPMODE_SDIO(cs)	(((cs) & 0x4) == 0)	/* SDIO */
-#define CST4330_CHIPMODE_GSPI(cs)	(((cs) & 0x6) == 4)	/* gSPI */
-#define CST4330_CHIPMODE_USB(cs)	(((cs) & 0x7) == 6)	/* USB packet-oriented */
-#define CST4330_CHIPMODE_USBDA(cs)	(((cs) & 0x7) == 7)	/* USB Direct Access */
+ /* SDIO || gSPI */
+#define CST4330_CHIPMODE_SDIOD(cs)	(((cs) & 0x7) < 6)
+ /* USB || USBDA */
+#define CST4330_CHIPMODE_USB20D(cs)	(((cs) & 0x7) >= 6)
+ /* SDIO */
+#define CST4330_CHIPMODE_SDIO(cs)	(((cs) & 0x4) == 0)
+ /* gSPI */
+#define CST4330_CHIPMODE_GSPI(cs)	(((cs) & 0x6) == 4)
+ /* USB packet-oriented */
+#define CST4330_CHIPMODE_USB(cs)	(((cs) & 0x7) == 6)
+ /* USB Direct Access */
+#define CST4330_CHIPMODE_USBDA(cs)	(((cs) & 0x7) == 7)
 #define	CST4330_OTP_PRESENT		0x00000010
 #define	CST4330_LPO_AUTODET_EN		0x00000020
 #define	CST4330_ARMREMAP_0		0x00000040
-#define	CST4330_SPROM_PRESENT		0x00000080	/* takes priority over OTP if both set */
+ /* takes priority over OTP if both set */
+#define	CST4330_SPROM_PRESENT		0x00000080
 #define	CST4330_ILPDIV_EN		0x00000100
 #define	CST4330_LPO_SEL			0x00000200
 #define	CST4330_RES_INIT_MODE_SHIFT	10
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index b462fc8..64bbc24 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -22,19 +22,32 @@
 #include "main.h"
 #include "ampdu.h"
 
-#define AMPDU_MAX_MPDU		32	/* max number of mpdus in an ampdu */
-#define AMPDU_NUM_MPDU_LEGACY	16	/* max number of mpdus in an ampdu to a legacy */
-#define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
-#define AMPDU_TX_BA_DEF_WSIZE	64	/* default Tx ba window size (in pdu) */
-#define AMPDU_RX_BA_DEF_WSIZE   64	/* max Rx ba window size (in pdu) */
-#define AMPDU_RX_BA_MAX_WSIZE   64	/* default Rx ba window size (in pdu) */
-#define	AMPDU_MAX_DUR		5	/* max dur of tx ampdu (in msec) */
-#define AMPDU_DEF_RETRY_LIMIT	5	/* default tx retry limit */
-#define AMPDU_DEF_RR_RETRY_LIMIT	2	/* default tx retry limit at reg rate */
-#define AMPDU_DEF_TXPKT_WEIGHT	2	/* default weight of ampdu in txfifo */
-#define AMPDU_DEF_FFPLD_RSVD	2048	/* default ffpld reserved bytes */
-#define AMPDU_INI_FREE		10	/* # of inis to be freed on detach */
-#define	AMPDU_SCB_MAX_RELEASE	20	/* max # of mpdus released at a time */
+/* max number of mpdus in an ampdu */
+#define AMPDU_MAX_MPDU			32
+/* max number of mpdus in an ampdu to a legacy */
+#define AMPDU_NUM_MPDU_LEGACY		16
+/* max Tx ba window size (in pdu) */
+#define AMPDU_TX_BA_MAX_WSIZE		64
+/* default Tx ba window size (in pdu) */
+#define AMPDU_TX_BA_DEF_WSIZE		64
+/* default Rx ba window size (in pdu) */
+#define AMPDU_RX_BA_DEF_WSIZE		64
+/* max Rx ba window size (in pdu) */
+#define AMPDU_RX_BA_MAX_WSIZE		64
+/* max dur of tx ampdu (in msec) */
+#define	AMPDU_MAX_DUR			5
+/* default tx retry limit */
+#define AMPDU_DEF_RETRY_LIMIT		5
+/* default tx retry limit at reg rate */
+#define AMPDU_DEF_RR_RETRY_LIMIT	2
+/* default weight of ampdu in txfifo */
+#define AMPDU_DEF_TXPKT_WEIGHT		2
+/* default ffpld reserved bytes */
+#define AMPDU_DEF_FFPLD_RSVD		2048
+/* # of inis to be freed on detach */
+#define AMPDU_INI_FREE			10
+/* max # of mpdus released at a time */
+#define	AMPDU_SCB_MAX_RELEASE		20
 
 #define NUM_FFPLD_FIFO 4	/* number of fifo concerned by pre-loading */
 #define FFPLD_TX_MAX_UNFL   200	/* default value of the average number of ampdu
@@ -59,44 +72,70 @@
  * some counters might be redundant with the ones in wlc or ampdu structures.
  * This allows to maintain a specific state independently of
  * how often and/or when the wlc counters are updated.
+ *
+ * ampdu_pld_size: number of bytes to be pre-loaded
+ * mcs2ampdu_table: per-mcs max # of mpdus in an ampdu
+ * prev_txfunfl: num of underflows last read from the HW macstats counter
+ * accum_txfunfl: num of underflows since we modified pld params
+ * accum_txampdu: num of tx ampdu since we modified pld params
+ * prev_txampdu: previous reading of tx ampdu
+ * dmaxferrate: estimated dma avg xfer rate in kbits/sec
  */
 struct brcms_fifo_info {
-	u16 ampdu_pld_size;	/* number of bytes to be pre-loaded */
-	u8 mcs2ampdu_table[FFPLD_MAX_MCS + 1];	/* per-mcs max # of mpdus in an ampdu */
-	u16 prev_txfunfl;	/* num of underflows last read from the HW macstats counter */
-	u32 accum_txfunfl;	/* num of underflows since we modified pld params */
-	u32 accum_txampdu;	/* num of tx ampdu since we modified pld params  */
-	u32 prev_txampdu;	/* previous reading of tx ampdu */
-	u32 dmaxferrate;	/* estimated dma avg xfer rate in kbits/sec */
+	u16 ampdu_pld_size;
+	u8 mcs2ampdu_table[FFPLD_MAX_MCS + 1];
+	u16 prev_txfunfl;
+	u32 accum_txfunfl;
+	u32 accum_txampdu;
+	u32 prev_txampdu;
+	u32 dmaxferrate;
 };
 
-/* AMPDU module specific state */
+/* AMPDU module specific state
+ *
+ * wlc: pointer to main wlc structure
+ * scb_handle: scb cubby handle to retrieve data from scb
+ * ini_enable: per-tid initiator enable/disable of ampdu
+ * ba_tx_wsize: Tx ba window size (in pdu)
+ * ba_rx_wsize: Rx ba window size (in pdu)
+ * retry_limit: mpdu transmit retry limit
+ * rr_retry_limit: mpdu transmit retry limit at regular rate
+ * retry_limit_tid: per-tid mpdu transmit retry limit
+ * rr_retry_limit_tid: per-tid mpdu transmit retry limit at regular rate
+ * mpdu_density: min mpdu spacing (0-7) ==> 2^(x-1)/8 usec
+ * max_pdu: max pdus allowed in ampdu
+ * dur: max duration of an ampdu (in msec)
+ * txpkt_weight: weight of ampdu in txfifo; reduces rate lag
+ * rx_factor: maximum rx ampdu factor (0-3) ==> 2^(13+x) bytes
+ * ffpld_rsvd: number of bytes to reserve for preload
+ * max_txlen: max size of ampdu per mcs, bw and sgi
+ * ini_free: array of ini's to be freed on detach
+ * mfbr: enable multiple fallback rate
+ * tx_max_funl: underflows should be kept such that
+ *		(tx_max_funfl*underflows) < tx frames
+ * fifo_tb: table of fifo infos
+ */
 struct ampdu_info {
-	struct brcms_c_info *wlc;	/* pointer to main wlc structure */
-	int scb_handle;		/* scb cubby handle to retrieve data from scb */
-	u8 ini_enable[AMPDU_MAX_SCB_TID];	/* per-tid initiator enable/disable of ampdu */
-	u8 ba_tx_wsize;	/* Tx ba window size (in pdu) */
-	u8 ba_rx_wsize;	/* Rx ba window size (in pdu) */
-	u8 retry_limit;	/* mpdu transmit retry limit */
-	u8 rr_retry_limit;	/* mpdu transmit retry limit at regular rate */
-	u8 retry_limit_tid[AMPDU_MAX_SCB_TID];	/* per-tid mpdu transmit retry limit */
-	/* per-tid mpdu transmit retry limit at regular rate */
+	struct brcms_c_info *wlc;
+	int scb_handle;
+	u8 ini_enable[AMPDU_MAX_SCB_TID];
+	u8 ba_tx_wsize;
+	u8 ba_rx_wsize;
+	u8 retry_limit;
+	u8 rr_retry_limit;
+	u8 retry_limit_tid[AMPDU_MAX_SCB_TID];
 	u8 rr_retry_limit_tid[AMPDU_MAX_SCB_TID];
-	u8 mpdu_density;	/* min mpdu spacing (0-7) ==> 2^(x-1)/8 usec */
-	s8 max_pdu;		/* max pdus allowed in ampdu */
-	u8 dur;		/* max duration of an ampdu (in msec) */
-	u8 txpkt_weight;	/* weight of ampdu in txfifo; reduces rate lag */
-	u8 rx_factor;	/* maximum rx ampdu factor (0-3) ==> 2^(13+x) bytes */
-	u32 ffpld_rsvd;	/* number of bytes to reserve for preload */
-	u32 max_txlen[MCS_TABLE_SIZE][2][2];	/* max size of ampdu per mcs, bw and sgi */
-	void *ini_free[AMPDU_INI_FREE];	/* array of ini's to be freed on detach */
-	bool mfbr;		/* enable multiple fallback rate */
-	u32 tx_max_funl;	/* underflows should be kept such that
-				 * (tx_max_funfl*underflows) < tx frames
-				 */
-	/* table of fifo infos */
+	u8 mpdu_density;
+	s8 max_pdu;
+	u8 dur;
+	u8 txpkt_weight;
+	u8 rx_factor;
+	u32 ffpld_rsvd;
+	u32 max_txlen[MCS_TABLE_SIZE][2][2];
+	void *ini_free[AMPDU_INI_FREE];
+	bool mfbr;
+	u32 tx_max_funl;
 	struct brcms_fifo_info fifo_tb[NUM_FFPLD_FIFO];
-
 };
 
 /* used for flushing ampdu packets */
@@ -163,7 +202,10 @@ struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 	ampdu->txpkt_weight = AMPDU_DEF_TXPKT_WEIGHT;
 
 	ampdu->ffpld_rsvd = AMPDU_DEF_FFPLD_RSVD;
-	/* bump max ampdu rcv size to 64k for all 11n devices except 4321A0 and 4321A1 */
+	/*
+	 * bump max ampdu rcv size to 64k for all 11n
+	 * devices except 4321A0 and 4321A1
+	 */
 	if (BRCMS_ISNPHY(wlc->band) && NREV_LT(wlc->band->phyrev, 2))
 		ampdu->rx_factor = IEEE80211_HT_MAX_AMPDU_32K;
 	else
@@ -194,7 +236,10 @@ void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 	if (!ampdu)
 		return;
 
-	/* free all ini's which were to be freed on callbacks which were never called */
+	/*
+	 * free all ini's which were to be freed on
+	 * callbacks which were never called
+	 */
 	for (i = 0; i < AMPDU_INI_FREE; i++)
 		kfree(ampdu->ini_free[i]);
 
@@ -220,7 +265,8 @@ static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
 	if (ampdu->max_pdu != AUTO)
 		scb_ampdu->max_pdu = (u8) ampdu->max_pdu;
 
-	scb_ampdu->release = min_t(u8, scb_ampdu->max_pdu, AMPDU_SCB_MAX_RELEASE);
+	scb_ampdu->release = min_t(u8, scb_ampdu->max_pdu,
+				   AMPDU_SCB_MAX_RELEASE);
 
 	if (scb_ampdu->max_rx_ampdu_bytes)
 		scb_ampdu->release = min_t(u8, scb_ampdu->release,
@@ -321,8 +367,8 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 
 		return 0;
 	}
-	max_mpdu =
-	    min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS], AMPDU_NUM_MPDU_LEGACY);
+	max_mpdu = min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS],
+			 AMPDU_NUM_MPDU_LEGACY);
 
 	/* In case max value max_pdu is already lower than
 	   the fifo depth, there is nothing more we can do.
@@ -344,11 +390,12 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 		brcms_c_scb_ampdu_update_config_all(ampdu);
 
 		/*
-		   compute a new dma xfer rate for max_mpdu @ max mcs.
-		   This is the minimum dma rate that
-		   can achieve no underflow condition for the current mpdu size.
+		 * compute a new dma xfer rate for max_mpdu @ max mcs.
+		 * This is the minimum dma rate that can achieve no
+		 * underflow condition for the current mpdu size.
+		 *
+		 * note : we divide/multiply by 100 to avoid integer overflows
 		 */
-		/* note : we divide/multiply by 100 to avoid integer overflows */
 		fifo->dmaxferrate =
 		    (((phy_rate / 100) *
 		      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
@@ -387,8 +434,8 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 
 	/* recompute the dma rate */
 	/* note : we divide/multiply by 100 to avoid integer overflows */
-	max_mpdu =
-	    min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS], AMPDU_NUM_MPDU_LEGACY);
+	max_mpdu = min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS],
+			 AMPDU_NUM_MPDU_LEGACY);
 	phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
 	dma_rate =
 	    (((phy_rate / 100) *
@@ -666,9 +713,13 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		if (count == scb_ampdu->max_pdu)
 			break;
 
-		/* check to see if the next pkt is a candidate for aggregation */
+		/*
+		 * check to see if the next pkt is
+		 * a candidate for aggregation
+		 */
 		p = pktq_ppeek(&qi->q, prec);
-		tx_info = IEEE80211_SKB_CB(p);	/* tx_info must be checked with current p */
+		/* tx_info must be checked with current p */
+		tx_info = IEEE80211_SKB_CB(p);
 
 		if (p) {
 			if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) &&
@@ -683,7 +734,10 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 					continue;
 				}
 
-				/* check if there are enough descriptors available */
+				/*
+				 * check if there are enough
+				 * descriptors available
+				 */
 				if (TXAVAIL(wlc, fifo) <= (seg_cnt + 1)) {
 					wiphy_err(wiphy, "%s: No fifo space  "
 						  "!!\n", __func__);
@@ -962,10 +1016,13 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			    supr_status == TX_STATUS_SUPR_EXPTIME) {
 				retry = false;
 			} else if (supr_status == TX_STATUS_SUPR_EXPTIME) {
-				/* TX underflow : try tuning pre-loading or ampdu size */
+				/* TX underflow:
+				 *   try tuning pre-loading or ampdu size
+				 */
 			} else if (supr_status == TX_STATUS_SUPR_FRAG) {
-				/* if there were underflows, but pre-loading is not active,
-				   notify rate adaptation.
+				/*
+				 * if there were underflows, but pre-loading
+				 * is not active, notify rate adaptation.
 				 */
 				if (brcms_c_ffpld_check_txfunfl(wlc,
 					prio2fifo[tid]) > 0)
@@ -1013,7 +1070,10 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				ini->tx_in_transit--;
 				ini->txretry[index] = 0;
 
-				/* ampdu_ack_len: number of acked aggregated frames */
+				/*
+				 * ampdu_ack_len:
+				 *   number of acked aggregated frames
+				 */
 				/* ampdu_len: number of aggregated frames */
 				brcms_c_ampdu_rate_status(wlc, tx_info, txs,
 							  mcs);
@@ -1038,11 +1098,14 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			if (retry && (txrate[0].count < (int)retry_limit)) {
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
-				/* Use high prededence for retransmit to give some punch */
+				/*
+				 * Use high prededence for retransmit to
+				 * give some punch
+				 */
 				/* brcms_c_txq_enq(wlc, scb, p,
 				 * BRCMS_PRIO_TO_PREC(tid)); */
 				brcms_c_txq_enq(wlc, scb, p,
-					    BRCMS_PRIO_TO_HI_PREC(tid));
+						BRCMS_PRIO_TO_HI_PREC(tid));
 			} else {
 				/* Retry timeout */
 				ini->tx_in_transit--;
@@ -1150,7 +1213,10 @@ void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu)
 {
 	struct brcms_c_info *wlc = ampdu->wlc;
 
-	/* Extend ucode internal watchdog timer to match larger received frames */
+	/*
+	 * Extend ucode internal watchdog timer to
+	 * match larger received frames
+	 */
 	if ((ampdu->rx_factor & IEEE80211_HT_AMPDU_PARM_FACTOR) ==
 	    IEEE80211_HT_MAX_AMPDU_64K) {
 		brcms_c_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_MAX);
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 5a5d5d6..23e0453 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -259,7 +259,10 @@ static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id)
 	return antcfg;
 }
 
-/* boardlevel antenna selection: convert ant_cfg to mimo_antsel (ucode interface) */
+/*
+ * boardlevel antenna selection:
+ *   convert ant_cfg to mimo_antsel (ucode interface)
+ */
 static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
 {
 	u8 idx = BRCMS_ANTIDX_11N(BRCMS_ANTSEL_11N(ant_cfg));
@@ -293,7 +296,10 @@ static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
 	ant_cfg = antsel->ant_config[ANT_SELCFG_TX_DEF];
 	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
 	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
-	/* Update driver stats for currently selected default tx/rx antenna config */
+	/*
+	 * Update driver stats for currently selected
+	 * default tx/rx antenna config
+	 */
 	asi->antcfg_cur.ant_config[ANT_SELCFG_TX_DEF] = ant_cfg;
 
 	/* 2) Update RX antconfig for all frames that are not unicast data
@@ -302,7 +308,10 @@ static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
 	ant_cfg = antsel->ant_config[ANT_SELCFG_RX_DEF];
 	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
 	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
-	/* Update driver stats for currently selected default tx/rx antenna config */
+	/*
+	 * Update driver stats for currently selected
+	 * default tx/rx antenna config
+	 */
 	asi->antcfg_cur.ant_config[ANT_SELCFG_RX_DEF] = ant_cfg;
 
 	return 0;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index a738e3b..b9cb892 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -151,9 +151,9 @@ const struct brcms_chanvec chanvec_all_5G = {
 
 /* Channels 52 - 64, 100 - 140 */
 static const struct brcms_chanvec radar_set1 = {
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,	/* 52 - 60 */
-	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,	/* 64, 100 - 124 */
-	 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	/* 128 - 140 */
+	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x11,  /* 52 - 60 */
+	 0x01, 0x00, 0x00, 0x00, 0x10, 0x11, 0x11, 0x11,  /* 64, 100 - 124 */
+	 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  /* 128 - 140 */
 	 0x00, 0x00, 0x00, 0x00}
 };
 
@@ -220,15 +220,19 @@ static const struct brcms_chanvec restricted_set_12_13_14 = {
 #define  LOCALE_CHAN_52_140_ALL  (1<<14)
 #define  LOCALE_SET_5G_HIGH4     (1<<15)	/* 184-216 */
 
-#define  LOCALE_CHAN_36_64       (LOCALE_SET_5G_LOW1 | LOCALE_SET_5G_LOW2 | LOCALE_SET_5G_LOW3)
-#define  LOCALE_CHAN_52_64       (LOCALE_SET_5G_LOW2 | LOCALE_SET_5G_LOW3)
-#define  LOCALE_CHAN_100_124	 (LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2)
-#define  LOCALE_CHAN_100_140     \
-	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2 | LOCALE_SET_5G_MID3 | LOCALE_SET_5G_HIGH1)
-#define  LOCALE_CHAN_149_165     (LOCALE_SET_5G_HIGH2 | LOCALE_SET_5G_HIGH3)
-#define  LOCALE_CHAN_184_216     LOCALE_SET_5G_HIGH4
+#define  LOCALE_CHAN_36_64	(LOCALE_SET_5G_LOW1 | \
+				 LOCALE_SET_5G_LOW2 | \
+				 LOCALE_SET_5G_LOW3)
+#define  LOCALE_CHAN_52_64	(LOCALE_SET_5G_LOW2 | LOCALE_SET_5G_LOW3)
+#define  LOCALE_CHAN_100_124	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2)
+#define  LOCALE_CHAN_100_140	(LOCALE_SET_5G_MID1 | LOCALE_SET_5G_MID2 | \
+				  LOCALE_SET_5G_MID3 | LOCALE_SET_5G_HIGH1)
+#define  LOCALE_CHAN_149_165	(LOCALE_SET_5G_HIGH2 | LOCALE_SET_5G_HIGH3)
+#define  LOCALE_CHAN_184_216	LOCALE_SET_5G_HIGH4
 
-#define  LOCALE_CHAN_01_14	(LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13 | LOCALE_CHAN_14)
+#define  LOCALE_CHAN_01_14	(LOCALE_CHAN_01_11 | \
+				 LOCALE_CHAN_12_13 | \
+				 LOCALE_CHAN_14)
 
 #define  LOCALE_RADAR_SET_NONE		  0
 #define  LOCALE_RADAR_SET_1		  1
@@ -500,7 +504,8 @@ static const struct locale_mimo_info *g_mimo_5g_table[] = {
 #endif
 #define LC_5G(id)	LOCALE_5G_IDX_ ## id
 
-#define LOCALES(band2, band5, mimo2, mimo5)     {LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
+#define LOCALES(band2, band5, mimo2, mimo5) \
+		{LC_2G(band2), LC_5G(band5), LC(mimo2), LC(mimo5)}
 
 static const struct {
 	char abbrev[BRCM_CNTRY_BUF_SZ];	/* country abbreviation */
@@ -644,7 +649,10 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	if (ccode)
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
 
-	/* internal country information which must match regulatory constraints in firmware */
+	/*
+	 * internal country information which must match
+	 * regulatory constraints in firmware
+	 */
 	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
 	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
 	country = brcms_c_country_lookup(wlc, country_abbrev);
@@ -672,8 +680,10 @@ brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 	return wlc_cm->bandstate[bandunit].locale_flags;
 }
 
-/* set the driver's current country and regulatory information using a country code
- * as the source. Lookup built in country information found with the country code.
+/*
+ * set the driver's current country and regulatory information using
+ * a country code as the source. Lookup built in country information
+ * found with the country code.
  */
 static int
 brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
@@ -696,7 +706,10 @@ brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 	 * otherwise use the ccode and regrev directly
 	 */
 	if (regrev == -1) {
-		/* map the country code to a built-in country code, regrev, and country_info */
+		/*
+		 * map the country code to a built-in country
+		 * code, regrev, and country_info
+		 */
 		country =
 		    brcms_c_countrycode_map(wlc_cm, ccode, mapped_ccode,
 					&mapped_regrev);
@@ -717,8 +730,10 @@ brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 	return 0;
 }
 
-/* set the driver's current country and regulatory information using a country code
- * as the source. Look up built in country information found with the country code.
+/*
+ * set the driver's current country and regulatory information
+ * using a country code as the source. Look up built in country
+ * information found with the country code.
  */
 static void
 brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
@@ -777,7 +792,10 @@ brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
 	char mapped_ccode[BRCM_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
-	/* map the country code to a built-in country code, regrev, and country_info struct */
+	/*
+	 * map the country code to a built-in country code, regrev, and
+	 * country_info struct
+	 */
 	country = brcms_c_countrycode_map(wlc->cmi, ccode, mapped_ccode,
 					  &mapped_regrev);
 
@@ -850,7 +868,10 @@ brcms_c_country_lookup_direct(const char *ccode, uint regrev)
 	/* Should just return 0 for single locale driver. */
 	/* Keep it this way in case we add more locales. (for now anyway) */
 
-	/* all other country def arrays are for regrev == 0, so if regrev is non-zero, fail */
+	/*
+	 * all other country def arrays are for regrev == 0, so if
+	 * regrev is non-zero, fail
+	 */
 	if (regrev > 0)
 		return NULL;
 
@@ -895,8 +916,9 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 		wlc_cm->bandstate[band->bandunit].radar_channels =
 		    g_table_radar_set[li->radar_channels];
 
-		/* set the channel availability,
-		 * masking out the channels that may not be supported on this phy
+		/*
+		 * set the channel availability, masking out the channels
+		 * that may not be supported on this phy.
 		 */
 		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
 					      &sup_chan);
@@ -931,9 +953,15 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	if (chan == MAXCHANNEL)
 		chan = INVCHANNEL;
 
-	/* based on the channel search above, set or clear WL_RADIO_COUNTRY_DISABLE */
+	/*
+	 * based on the channel search above, set or
+	 * clear WL_RADIO_COUNTRY_DISABLE.
+	 */
 	if (chan == INVCHANNEL) {
-		/* country/locale with no valid channels, set the radio disable bit */
+		/*
+		 * country/locale with no valid channels, set
+		 * the radio disable bit
+		 */
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
 		wiphy_err(wlc->wiphy, "wl%d: %s: no valid channel for \"%s\" "
 			  "nbands %d bandlocked %d\n", wlc->pub->unit,
@@ -941,12 +969,16 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 			  wlc->bandlocked);
 	} else if (mboolisset(wlc->pub->radio_disabled,
 			      WL_RADIO_COUNTRY_DISABLE)) {
-		/* country/locale with valid channel, clear the radio disable bit */
+		/*
+		 * country/locale with valid channel, clear
+		 * the radio disable bit
+		 */
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
 	}
 
-	/* Now that the country abbreviation is set, if the radio supports 2G, then
-	 * set channel 14 restrictions based on the new locale.
+	/*
+	 * Now that the country abbreviation is set, if the radio supports 2G,
+	 * then set channel 14 restrictions based on the new locale.
 	 */
 	if (NBANDS(wlc) > 1 || BAND_2G(wlc->band->bandtype))
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
@@ -961,7 +993,10 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	}
 }
 
-/* reset the quiet channels vector to the union of the restricted and radar channel sets */
+/*
+ * reset the quiet channels vector to the union
+ * of the restricted and radar channel sets
+ */
 static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -987,15 +1022,11 @@ static bool
 brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, u16 chspec)
 {
 	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
-		(isset
-		 (wlc_cm->quiet_channels.vec,
-		  LOWER_20_SB(CHSPEC_CHANNEL(chspec)))
-		 || isset(wlc_cm->quiet_channels.vec,
-			  UPPER_20_SB(CHSPEC_CHANNEL(chspec)))) : isset(wlc_cm->
-									quiet_channels.
-									vec,
-									CHSPEC_CHANNEL
-									(chspec));
+		(isset(wlc_cm->quiet_channels.vec,
+		       LOWER_20_SB(CHSPEC_CHANNEL(chspec))) ||
+		 isset(wlc_cm->quiet_channels.vec,
+		       UPPER_20_SB(CHSPEC_CHANNEL(chspec)))) :
+		isset(wlc_cm->quiet_channels.vec, CHSPEC_CHANNEL(chspec));
 }
 
 /* Is the channel valid for the current locale? (but don't consider channels not
@@ -1112,8 +1143,9 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 
 	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
 
-	brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm, &txpwr,
-							     local_constraint_qdbm);
+	brcms_c_channel_min_txpower_limits_with_local_constraint(
+		wlc_cm, &txpwr, local_constraint_qdbm
+	);
 
 	brcms_b_set_chanspec(wlc->hw, chanspec,
 			      (brcms_c_quiet_chanspec(wlc_cm, chanspec) != 0),
@@ -1317,10 +1349,12 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		txpwr->ofdm[i] = (u8) maxpwr;
 
 	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
-		/* OFDM 40 MHz SISO has the same power as the corresponding MCS0-7 rate unless
-		 * overriden by the locale specific code. We set this value to 0 as a
-		 * flag (presumably 0 dBm isn't a possibility) and then copy the MCS0-7 value
-		 * to the 40 MHz value if it wasn't explicitly set.
+		/*
+		 * OFDM 40 MHz SISO has the same power as the corresponding
+		 * MCS0-7 rate unless overriden by the locale specific code.
+		 * We set this value to 0 as a flag (presumably 0 dBm isn't
+		 * a possibility) and then copy the MCS0-7 value to the 40 MHz
+		 * value if it wasn't explicitly set.
 		 */
 		txpwr->ofdm_40_siso[i] = 0;
 
@@ -1354,8 +1388,9 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	/* Fill in the MCS 0-7 (SISO) rates */
 	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 
-		/* 20 MHz has the same power as the corresponding OFDM rate unless
-		 * overriden by the locale specific code.
+		/*
+		 * 20 MHz has the same power as the corresponding OFDM rate
+		 * unless overriden by the locale specific code.
 		 */
 		txpwr->mcs_20_siso[i] = txpwr->ofdm[i];
 		txpwr->mcs_40_siso[i] = 0;
@@ -1367,7 +1402,10 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		txpwr->mcs_40_cdd[i] = (u8) maxpwr40;
 	}
 
-	/* These locales have SISO expressed in the table and override CDD later */
+	/*
+	 * These locales have SISO expressed in the
+	 * table and override CDD later
+	 */
 	if (li_mimo == &locale_bn) {
 		if (li_mimo == &locale_bn) {
 			maxpwr20 = QDB(16);
@@ -1408,10 +1446,10 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		}
 	}
 
-	/* Copy the 40 MHZ MCS 0-7 CDD value to the 40 MHZ MCS 0-7 SISO value if it wasn't
-	 * provided explicitly.
+	/*
+	 * Copy the 40 MHZ MCS 0-7 CDD value to the 40 MHZ MCS 0-7 SISO
+	 * value if it wasn't provided explicitly.
 	 */
-
 	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		if (txpwr->mcs_40_siso[i] == 0)
 			txpwr->mcs_40_siso[i] = txpwr->mcs_40_cdd[i];
@@ -1427,8 +1465,9 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		}
 	}
 
-	/* Copy the 20 and 40 MHz MCS0-7 CDD values to the corresponding STBC values if they weren't
-	 * provided explicitly.
+	/*
+	 * Copy the 20 and 40 MHz MCS0-7 CDD values to the corresponding
+	 * STBC values if they weren't provided explicitly.
 	 */
 	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
 		if (txpwr->mcs_20_stbc[i] == 0)
@@ -1458,8 +1497,9 @@ static bool brcms_c_japan_ccode(const char *ccode)
 }
 
 /*
- * Validate the chanspec for this locale, for 40MHZ we need to also check that the sidebands
- * are valid 20MZH channels in this locale and they are also a legal HT combination
+ * Validate the chanspec for this locale, for 40MHZ we need to also
+ * check that the sidebands are valid 20MZH channels in this locale
+ * and they are also a legal HT combination
  */
 static bool
 brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
@@ -1487,8 +1527,9 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 			return VALID_CHANNEL20(wlc_cm->wlc, channel);
 	}
 #ifdef SUPPORT_40MHZ
-	/* We know we are now checking a 40MHZ channel, so we should only be here
-	 * for NPHYS
+	/*
+	 * We know we are now checking a 40MHZ channel, so we should
+	 * only be here for NPHYS
 	 */
 	if (BRCMS_ISNPHY(wlc->band) || BRCMS_ISSSLPNPHY(wlc->band)) {
 		u8 upper_sideband = 0, idx;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index c9452be..3e85844 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -40,12 +40,14 @@
  */
 
 /* macro to get 2.4 GHz channel group index for tx power */
-#define CHANNEL_POWER_IDX_2G_CCK(c) (((c) < 2) ? 0 : (((c) < 11) ? 1 : 2))	/* cck index */
-#define CHANNEL_POWER_IDX_2G_OFDM(c) (((c) < 2) ? 3 : (((c) < 11) ? 4 : 5))	/* ofdm index */
+#define CHANNEL_POWER_IDX_2G_CCK(c) (((c) < 2) ? 0 : (((c) < 11) ? 1 : 2))
+#define CHANNEL_POWER_IDX_2G_OFDM(c) (((c) < 2) ? 3 : (((c) < 11) ? 4 : 5))
 
 /* macro to get 5 GHz channel group index for tx power */
-#define CHANNEL_POWER_IDX_5G(c) \
-	(((c) < 52) ? 0 : (((c) < 62) ? 1 : (((c) < 100) ? 2 : (((c) < 149) ? 3 : 4))))
+#define CHANNEL_POWER_IDX_5G(c) (((c) < 52) ? 0 : \
+				 (((c) < 62) ? 1 : \
+				 (((c) < 100) ? 2 : \
+				 (((c) < 149) ? 3 : 4))))
 
 /* max of BAND_5G_PWR_LVLS and 6 for 2.4 GHz */
 #define BRCMS_MAXPWR_TBL_SIZE		6
@@ -67,9 +69,8 @@ struct locale_info {
 	u8 restricted_channels;
 	/* Max tx pwr in qdBm for each sub-band */
 	s8 maxpwr[BRCMS_MAXPWR_TBL_SIZE];
-	s8 pub_maxpwr[BAND_5G_PWR_LVLS];	/* Country IE advertised max tx pwr in dBm
-						 * per sub-band
-						 */
+	/* Country IE advertised max tx pwr in dBm per sub-band */
+	s8 pub_maxpwr[BAND_5G_PWR_LVLS];
 	u8 flags;
 };
 
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index 4dc7340..96f487a 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -29,11 +29,11 @@
 #define	RX_FIFO			0	/* data and ctl frames */
 #define	RX_TXSTATUS_FIFO	3	/* RX fifo for tx status packages */
 
-/* TX FIFO numbers using WME Access Classes */
-#define	TX_AC_BK_FIFO		0	/* Access Category Background TX FIFO */
-#define	TX_AC_BE_FIFO		1	/* Access Category Best-Effort TX FIFO */
-#define	TX_AC_VI_FIFO		2	/* Access Class Video TX FIFO */
-#define	TX_AC_VO_FIFO		3	/* Access Class Voice TX FIFO */
+/* TX FIFO numbers using WME Access Category */
+#define	TX_AC_BK_FIFO		0	/* Background TX FIFO */
+#define	TX_AC_BE_FIFO		1	/* Best-Effort TX FIFO */
+#define	TX_AC_VI_FIFO		2	/* Video TX FIFO */
+#define	TX_AC_VO_FIFO		3	/* Voice TX FIFO */
 #define	TX_BCMC_FIFO		4	/* Broadcast/Multicast TX FIFO */
 #define	TX_ATIM_FIFO		5	/* TX fifo for ATIM window info */
 
@@ -457,7 +457,7 @@ struct d11regs {
 #define	IRL_FC_MASK		0xff000000	/* frame count */
 #define	IRL_FC_SHIFT		24	/* frame count */
 
-/* maccontrol register */
+/*== maccontrol register ==*/
 #define	MCTL_GMODE		(1U << 31)
 #define	MCTL_DISCARD_PMQ	(1 << 30)
 #define	MCTL_WAKE		(1 << 26)
@@ -481,75 +481,119 @@ struct d11regs {
 #define	MCTL_PSM_RUN		(1 <<  1)
 #define	MCTL_EN_MAC		(1 <<  0)
 
-/* maccommand register */
+/*== maccommand register ==*/
 #define	MCMD_BCN0VLD		(1 <<  0)
 #define	MCMD_BCN1VLD		(1 <<  1)
 #define	MCMD_DIRFRMQVAL		(1 <<  2)
 #define	MCMD_CCA		(1 <<  3)
 #define	MCMD_BG_NOISE		(1 <<  4)
 #define	MCMD_SKIP_SHMINIT	(1 <<  5)	/* only used for simulation */
-#define MCMD_SAMPLECOLL		MCMD_SKIP_SHMINIT	/* reuse for sample collect */
-
-/* macintstatus/macintmask */
-#define	MI_MACSSPNDD		(1 <<  0)	/* MAC has gracefully suspended */
-#define	MI_BCNTPL		(1 <<  1)	/* beacon template available */
-#define	MI_TBTT			(1 <<  2)	/* TBTT indication */
-#define	MI_BCNSUCCESS		(1 <<  3)	/* beacon successfully tx'd */
-#define	MI_BCNCANCLD		(1 <<  4)	/* beacon canceled (IBSS) */
-#define	MI_ATIMWINEND		(1 <<  5)	/* end of ATIM-window (IBSS) */
-#define	MI_PMQ			(1 <<  6)	/* PMQ entries available */
-#define	MI_NSPECGEN_0		(1 <<  7)	/* non-specific gen-stat bits that are set by PSM */
-#define	MI_NSPECGEN_1		(1 <<  8)	/* non-specific gen-stat bits that are set by PSM */
-#define	MI_MACTXERR		(1 <<  9)	/* MAC level Tx error */
-#define	MI_NSPECGEN_3		(1 << 10)	/* non-specific gen-stat bits that are set by PSM */
-#define	MI_PHYTXERR		(1 << 11)	/* PHY Tx error */
-#define	MI_PME			(1 << 12)	/* Power Management Event */
-#define	MI_GP0			(1 << 13)	/* General-purpose timer0 */
-#define	MI_GP1			(1 << 14)	/* General-purpose timer1 */
-#define	MI_DMAINT		(1 << 15)	/* (ORed) DMA-interrupts */
-#define	MI_TXSTOP		(1 << 16)	/* MAC has completed a TX FIFO Suspend/Flush */
-#define	MI_CCA			(1 << 17)	/* MAC has completed a CCA measurement */
-#define	MI_BG_NOISE		(1 << 18)	/* MAC has collected background noise samples */
-#define	MI_DTIM_TBTT		(1 << 19)	/* MBSS DTIM TBTT indication */
-#define MI_PRQ			(1 << 20)	/* Probe response queue needs attention */
-#define	MI_PWRUP		(1 << 21)	/* Radio/PHY has been powered back up. */
+#define MCMD_SAMPLECOLL		MCMD_SKIP_SHMINIT /* reuse for sample collect */
+
+/*== macintstatus/macintmask ==*/
+/* gracefully suspended */
+#define	MI_MACSSPNDD		(1 <<  0)
+/* beacon template available */
+#define	MI_BCNTPL		(1 <<  1)
+/* TBTT indication */
+#define	MI_TBTT			(1 <<  2)
+/* beacon successfully tx'd */
+#define	MI_BCNSUCCESS		(1 <<  3)
+/* beacon canceled (IBSS) */
+#define	MI_BCNCANCLD		(1 <<  4)
+/* end of ATIM-window (IBSS) */
+#define	MI_ATIMWINEND		(1 <<  5)
+/* PMQ entries available */
+#define	MI_PMQ			(1 <<  6)
+/* non-specific gen-stat bits that are set by PSM */
+#define	MI_NSPECGEN_0		(1 <<  7)
+/* non-specific gen-stat bits that are set by PSM */
+#define	MI_NSPECGEN_1		(1 <<  8)
+/* MAC level Tx error */
+#define	MI_MACTXERR		(1 <<  9)
+/* non-specific gen-stat bits that are set by PSM */
+#define	MI_NSPECGEN_3		(1 << 10)
+/* PHY Tx error */
+#define	MI_PHYTXERR		(1 << 11)
+/* Power Management Event */
+#define	MI_PME			(1 << 12)
+/* General-purpose timer0 */
+#define	MI_GP0			(1 << 13)
+/* General-purpose timer1 */
+#define	MI_GP1			(1 << 14)
+/* (ORed) DMA-interrupts */
+#define	MI_DMAINT		(1 << 15)
+/* MAC has completed a TX FIFO Suspend/Flush */
+#define	MI_TXSTOP		(1 << 16)
+/* MAC has completed a CCA measurement */
+#define	MI_CCA			(1 << 17)
+/* MAC has collected background noise samples */
+#define	MI_BG_NOISE		(1 << 18)
+/* MBSS DTIM TBTT indication */
+#define	MI_DTIM_TBTT		(1 << 19)
+/* Probe response queue needs attention */
+#define MI_PRQ			(1 << 20)
+/* Radio/PHY has been powered back up. */
+#define	MI_PWRUP		(1 << 21)
 #define	MI_RESERVED3		(1 << 22)
 #define	MI_RESERVED2		(1 << 23)
 #define MI_RESERVED1		(1 << 25)
 /* MAC detected change on RF Disable input*/
 #define MI_RFDISABLE		(1 << 28)
-#define	MI_TFS			(1 << 29)	/* MAC has completed a TX */
-#define	MI_PHYCHANGED		(1 << 30)	/* A phy status change wrt G mode */
-#define	MI_TO			(1U << 31)	/* general purpose timeout */
+/* MAC has completed a TX */
+#define	MI_TFS			(1 << 29)
+/* A phy status change wrt G mode */
+#define	MI_PHYCHANGED		(1 << 30)
+/* general purpose timeout */
+#define	MI_TO			(1U << 31)
 
 /* Mac capabilities registers */
-/* machwcap */
+/*== machwcap ==*/
 #define	MCAP_TKIPMIC		0x80000000	/* TKIP MIC hardware present */
 
-/* pmqhost data */
-#define	PMQH_DATA_MASK		0xffff0000	/* data entry of head pmq entry */
-#define	PMQH_BSSCFG		0x00100000	/* PM entry for BSS config */
-#define	PMQH_PMOFF		0x00010000	/* PM Mode OFF: power save off */
-#define	PMQH_PMON		0x00020000	/* PM Mode ON: power save on */
-#define	PMQH_DASAT		0x00040000	/* Dis-associated or De-authenticated */
-#define	PMQH_ATIMFAIL		0x00080000	/* ATIM not acknowledged */
-#define	PMQH_DEL_ENTRY		0x00000001	/* delete head entry */
-#define	PMQH_DEL_MULT		0x00000002	/* delete head entry to cur read pointer -1 */
-#define	PMQH_OFLO		0x00000004	/* pmq overflow indication */
-#define	PMQH_NOT_EMPTY		0x00000008	/* entries are present in pmq */
-
-/* phydebug */
-#define	PDBG_CRS		(1 << 0)	/* phy is asserting carrier sense */
-#define	PDBG_TXA		(1 << 1)	/* phy is taking xmit byte from mac this cycle */
-#define	PDBG_TXF		(1 << 2)	/* mac is instructing the phy to transmit a frame */
-#define	PDBG_TXE		(1 << 3)	/* phy is signalling a transmit Error to the mac */
-#define	PDBG_RXF		(1 << 4)	/* phy detected the end of a valid frame preamble */
-#define	PDBG_RXS		(1 << 5)	/* phy detected the end of a valid PLCP header */
-#define	PDBG_RXFRG		(1 << 6)	/* rx start not asserted */
-#define	PDBG_RXV		(1 << 7)	/* mac is taking receive byte from phy this cycle */
-#define	PDBG_RFD		(1 << 16)	/* RF portion of the radio is disabled */
-
-/* objaddr register */
+/*== pmqhost data ==*/
+/* data entry of head pmq entry */
+#define	PMQH_DATA_MASK		0xffff0000
+/* PM entry for BSS config */
+#define	PMQH_BSSCFG		0x00100000
+/* PM Mode OFF: power save off */
+#define	PMQH_PMOFF		0x00010000
+/* PM Mode ON: power save on */
+#define	PMQH_PMON		0x00020000
+/* Dis-associated or De-authenticated */
+#define	PMQH_DASAT		0x00040000
+/* ATIM not acknowledged */
+#define	PMQH_ATIMFAIL		0x00080000
+/* delete head entry */
+#define	PMQH_DEL_ENTRY		0x00000001
+/* delete head entry to cur read pointer -1 */
+#define	PMQH_DEL_MULT		0x00000002
+/* pmq overflow indication */
+#define	PMQH_OFLO		0x00000004
+/* entries are present in pmq */
+#define	PMQH_NOT_EMPTY		0x00000008
+
+/*== phydebug ==*/
+/* phy is asserting carrier sense */
+#define	PDBG_CRS		(1 << 0)
+/* phy is taking xmit byte from mac this cycle */
+#define	PDBG_TXA		(1 << 1)
+/* mac is instructing the phy to transmit a frame */
+#define	PDBG_TXF		(1 << 2)
+/* phy is signalling a transmit Error to the mac */
+#define	PDBG_TXE		(1 << 3)
+/* phy detected the end of a valid frame preamble */
+#define	PDBG_RXF		(1 << 4)
+/* phy detected the end of a valid PLCP header */
+#define	PDBG_RXS		(1 << 5)
+/* rx start not asserted */
+#define	PDBG_RXFRG		(1 << 6)
+/* mac is taking receive byte from phy this cycle */
+#define	PDBG_RXV		(1 << 7)
+/* RF portion of the radio is disabled */
+#define	PDBG_RFD		(1 << 16)
+
+/*== objaddr register ==*/
 #define	OBJADDR_SEL_MASK	0x000F0000
 #define	OBJADDR_UCM_SEL		0x00000000
 #define	OBJADDR_SHM_SEL		0x00010000
@@ -564,20 +608,20 @@ struct d11regs {
 #define	WEP_PCMADDR		0x07d4
 #define	WEP_PCMDATA		0x07d6
 
-/* frmtxstatus */
+/*== frmtxstatus ==*/
 #define	TXS_V			(1 << 0)	/* valid bit */
 #define	TXS_STATUS_MASK		0xffff
 #define	TXS_FID_MASK		0xffff0000
 #define	TXS_FID_SHIFT		16
 
-/* frmtxstatus2 */
+/*== frmtxstatus2 ==*/
 #define	TXS_SEQ_MASK		0xffff
 #define	TXS_PTX_MASK		0xff0000
 #define	TXS_PTX_SHIFT		16
 #define	TXS_MU_MASK		0x01000000
 #define	TXS_MU_SHIFT		24
 
-/* clk_ctl_st */
+/*== clk_ctl_st ==*/
 #define CCS_ERSRC_REQ_D11PLL	0x00000100	/* d11 core pll request */
 #define CCS_ERSRC_REQ_PHYPLL	0x00000200	/* PHY pll request */
 #define CCS_ERSRC_AVAIL_D11PLL	0x01000000	/* d11 core pll available */
@@ -602,22 +646,27 @@ struct d11regs {
 #define TXFIFO_SIZE_UNIT	256	/* one unit corresponds to 256 bytes */
 #define MBSS16_TEMPLMEM_MINBLKS	65	/* one unit corresponds to 256 bytes */
 
-/* phy versions, PhyVersion:Revision field */
-#define	PV_AV_MASK		0xf000	/* analog block version */
-#define	PV_AV_SHIFT		12	/* analog block version bitfield offset */
-#define	PV_PT_MASK		0x0f00	/* phy type */
-#define	PV_PT_SHIFT		8	/* phy type bitfield offset */
-#define	PV_PV_MASK		0x000f	/* phy version */
+/*== phy versions (PhyVersion:Revision field) ==*/
+/* analog block version */
+#define	PV_AV_MASK		0xf000
+/* analog block version bitfield offset */
+#define	PV_AV_SHIFT		12
+/* phy type */
+#define	PV_PT_MASK		0x0f00
+/* phy type bitfield offset */
+#define	PV_PT_SHIFT		8
+/* phy version */
+#define	PV_PV_MASK		0x000f
 #define	PHY_TYPE(v)		((v & PV_PT_MASK) >> PV_PT_SHIFT)
 
-/* phy types, PhyVersion:PhyType field */
+/*== phy types (PhyVersion:PhyType field) ==*/
 #define	PHY_TYPE_N		4	/* N-Phy value */
 #define	PHY_TYPE_SSN		6	/* SSLPN-Phy value */
 #define	PHY_TYPE_LCN		8	/* LCN-Phy value */
 #define	PHY_TYPE_LCNXN		9	/* LCNXN-Phy value */
 #define	PHY_TYPE_NULL		0xf	/* Invalid Phy value */
 
-/* analog types, PhyVersion:AnalogType field */
+/*== analog types (PhyVersion:AnalogType field) ==*/
 #define	ANA_11N_013		5
 
 /* 802.11a PLCP header def */
@@ -693,9 +742,10 @@ struct cck_phy_hdr {
 #define BRCMS_CLR_MIMO_PLCP_AMPDU(plcp) (plcp[3] &= ~MIMO_PLCP_AMPDU)
 #define BRCMS_IS_MIMO_PLCP_AMPDU(plcp) (plcp[3] & MIMO_PLCP_AMPDU)
 
-/* The dot11a PLCP header is 5 bytes.  To simplify the software (so that we
- * don't need e.g. different tx DMA headers for 11a and 11b), the PLCP header has
- * padding added in the ucode.
+/*
+ * The dot11a PLCP header is 5 bytes.  To simplify the software (so that we
+ * don't need e.g. different tx DMA headers for 11a and 11b), the PLCP header
+ * has padding added in the ucode.
  */
 #define	D11_PHY_HDR_LEN	6
 
@@ -745,14 +795,17 @@ struct d11txh {
 #define FT_HT	2
 #define FT_N	3
 
-/* Position of MPDU inside A-MPDU; indicated with bits 10:9 of MacTxControlLow */
+/*
+ * Position of MPDU inside A-MPDU; indicated with bits 10:9
+ * of MacTxControlLow
+ */
 #define TXC_AMPDU_SHIFT		9	/* shift for ampdu settings */
 #define TXC_AMPDU_NONE		0	/* Regular MPDU, not an A-MPDU */
 #define TXC_AMPDU_FIRST		1	/* first MPDU of an A-MPDU */
 #define TXC_AMPDU_MIDDLE	2	/* intermediate MPDU of an A-MPDU */
 #define TXC_AMPDU_LAST		3	/* last (or single) MPDU of an A-MPDU */
 
-/* MacTxControlLow */
+/*== MacTxControlLow ==*/
 #define TXC_AMIC		0x8000
 #define	TXC_SENDCTS		0x0800
 #define TXC_AMPDU_MASK		0x0600
@@ -766,18 +819,25 @@ struct d11txh {
 #define	TXC_LONGFRAME		0x0002
 #define	TXC_IMMEDACK		0x0001
 
-/* MacTxControlHigh */
-#define TXC_PREAMBLE_RTS_FB_SHORT	0x8000	/* RTS fallback preamble type 1 = SHORT 0 = LONG */
-#define TXC_PREAMBLE_RTS_MAIN_SHORT	0x4000	/* RTS main rate preamble type 1 = SHORT 0 = LONG */
-#define TXC_PREAMBLE_DATA_FB_SHORT	0x2000	/* Main fallback rate preamble type
-						 * 1 = SHORT for OFDM/GF for MIMO
-						 * 0 = LONG for CCK/MM for MIMO
-						 */
+/*== MacTxControlHigh ==*/
+/* RTS fallback preamble type 1 = SHORT 0 = LONG */
+#define TXC_PREAMBLE_RTS_FB_SHORT	0x8000
+/* RTS main rate preamble type 1 = SHORT 0 = LONG */
+#define TXC_PREAMBLE_RTS_MAIN_SHORT	0x4000
+/*
+ * Main fallback rate preamble type
+ *   1 = SHORT for OFDM/GF for MIMO
+ *   0 = LONG for CCK/MM for MIMO
+ */
+#define TXC_PREAMBLE_DATA_FB_SHORT	0x2000
+
 /* TXC_PREAMBLE_DATA_MAIN is in PhyTxControl bit 5 */
-#define	TXC_AMPDU_FBR		0x1000	/* use fallback rate for this AMPDU */
+/* use fallback rate for this AMPDU */
+#define	TXC_AMPDU_FBR		0x1000
 #define	TXC_SECKEY_MASK		0x0FF0
 #define	TXC_SECKEY_SHIFT	4
-#define	TXC_ALT_TXPWR		0x0008	/* Use alternate txpwr defined at loc. M_ALT_TXPWR_IDX */
+/* Use alternate txpwr defined at loc. M_ALT_TXPWR_IDX */
+#define	TXC_ALT_TXPWR		0x0008
 #define	TXC_SECTYPE_MASK	0x0007
 #define	TXC_SECTYPE_SHIFT	0
 
@@ -817,7 +877,7 @@ struct d11txh {
 #define PHY_TXC1_MODE_SDM		3
 
 /* PhyTxControl for HTphy that are different from Mimophy */
-#define	PHY_TXC_HTANT_MASK		0x3fC0	/* bit 6, 7, 8, 9, 10, 11, 12, 13 */
+#define	PHY_TXC_HTANT_MASK		0x3fC0	/* bits 6-13 */
 
 /* XtraFrameTypes */
 #define XFTS_RTS_FT_SHIFT	2
@@ -862,23 +922,23 @@ struct tx_status {
 #define	TX_STATUS_RTS_RTX_MASK	0x0F00
 #define	TX_STATUS_RTS_RTX_SHIFT	8
 #define TX_STATUS_MASK		0x00FE
-#define	TX_STATUS_PMINDCTD	(1 << 7)	/* PM mode indicated to AP */
-#define	TX_STATUS_INTERMEDIATE	(1 << 6)	/* intermediate or 1st ampdu pkg */
-#define	TX_STATUS_AMPDU		(1 << 5)	/* AMPDU status */
-#define TX_STATUS_SUPR_MASK	0x1C	/* suppress status bits (4:2) */
+#define	TX_STATUS_PMINDCTD	(1 << 7) /* PM mode indicated to AP */
+#define	TX_STATUS_INTERMEDIATE	(1 << 6) /* intermediate or 1st ampdu pkg */
+#define	TX_STATUS_AMPDU		(1 << 5) /* AMPDU status */
+#define TX_STATUS_SUPR_MASK	0x1C	 /* suppress status bits (4:2) */
 #define TX_STATUS_SUPR_SHIFT	2
-#define	TX_STATUS_ACK_RCV	(1 << 1)	/* ACK received */
-#define	TX_STATUS_VALID		(1 << 0)	/* Tx status valid */
+#define	TX_STATUS_ACK_RCV	(1 << 1) /* ACK received */
+#define	TX_STATUS_VALID		(1 << 0) /* Tx status valid */
 #define	TX_STATUS_NO_ACK	0
 
 /* suppress status reason codes */
-#define	TX_STATUS_SUPR_PMQ	(1 << 2)	/* PMQ entry */
-#define	TX_STATUS_SUPR_FLUSH	(2 << 2)	/* flush request */
-#define	TX_STATUS_SUPR_FRAG	(3 << 2)	/* previous frag failure */
-#define	TX_STATUS_SUPR_TBTT	(3 << 2)	/* SHARED: Probe response supr for TBTT */
-#define	TX_STATUS_SUPR_BADCH	(4 << 2)	/* channel mismatch */
-#define	TX_STATUS_SUPR_EXPTIME	(5 << 2)	/* lifetime expiry */
-#define	TX_STATUS_SUPR_UF	(6 << 2)	/* underflow */
+#define	TX_STATUS_SUPR_PMQ	(1 << 2) /* PMQ entry */
+#define	TX_STATUS_SUPR_FLUSH	(2 << 2) /* flush request */
+#define	TX_STATUS_SUPR_FRAG	(3 << 2) /* previous frag failure */
+#define	TX_STATUS_SUPR_TBTT	(3 << 2) /* SHARED: Probe resp supr for TBTT */
+#define	TX_STATUS_SUPR_BADCH	(4 << 2) /* channel mismatch */
+#define	TX_STATUS_SUPR_EXPTIME	(5 << 2) /* lifetime expiry */
+#define	TX_STATUS_SUPR_UF	(6 << 2) /* underflow */
 
 /* Unexpected tx status for rate update */
 #define TX_STATUS_UNEXP(status) \
@@ -939,8 +999,8 @@ struct tx_status {
 #define ADDR_BMP_RA		(1 << 0)	/* Receiver Address (RA) */
 #define ADDR_BMP_TA		(1 << 1)	/* Transmitter Address (TA) */
 #define ADDR_BMP_BSSID		(1 << 2)	/* BSSID */
-#define ADDR_BMP_AP		(1 << 3)	/* Infra-BSS Access Point (AP) */
-#define ADDR_BMP_STA		(1 << 4)	/* Infra-BSS Station (STA) */
+#define ADDR_BMP_AP		(1 << 3)	/* Infra-BSS Access Point */
+#define ADDR_BMP_STA		(1 << 4)	/* Infra-BSS Station */
 #define ADDR_BMP_RESERVED1	(1 << 5)
 #define ADDR_BMP_RESERVED2	(1 << 6)
 #define ADDR_BMP_RESERVED3	(1 << 7)
@@ -1012,9 +1072,10 @@ struct tx_status {
 #define	T_BCN0_TPL_BASE		(0x34 * 2)
 #define	T_PRS_TPL_BASE		(0x134 * 2)
 #define	T_BCN1_TPL_BASE		(0x234 * 2)
-#define T_TX_FIFO_TXRAM_BASE	(T_ACTS_TPL_BASE + (TXFIFO_START_BLK * TXFIFO_SIZE_UNIT))
+#define T_TX_FIFO_TXRAM_BASE	(T_ACTS_TPL_BASE + \
+				 (TXFIFO_START_BLK * TXFIFO_SIZE_UNIT))
 
-#define T_BA_TPL_BASE		T_QNULL_TPL_BASE	/* template area for BA */
+#define T_BA_TPL_BASE		T_QNULL_TPL_BASE /* template area for BA */
 
 #define T_RAM_ACCESS_SZ		4	/* template ram is 4 byte access only */
 
@@ -1207,14 +1268,18 @@ struct tx_status {
 #define WATCHDOG_8TU_MAX	10
 
 /* Manufacturing Test Variables */
-#define M_PKTENG_CTRL		(0x6c * 2)	/* PER test mode */
-#define M_PKTENG_IFS		(0x6d * 2)	/* IFS for TX mode */
-#define M_PKTENG_FRMCNT_LO		(0x6e * 2)	/* Lower word of tx frmcnt/rx lostcnt */
-#define M_PKTENG_FRMCNT_HI		(0x6f * 2)	/* Upper word of tx frmcnt/rx lostcnt */
+/* PER test mode */
+#define M_PKTENG_CTRL		(0x6c * 2)
+/* IFS for TX mode */
+#define M_PKTENG_IFS		(0x6d * 2)
+/* Lower word of tx frmcnt/rx lostcnt */
+#define M_PKTENG_FRMCNT_LO	(0x6e * 2)
+/* Upper word of tx frmcnt/rx lostcnt */
+#define M_PKTENG_FRMCNT_HI	(0x6f * 2)
 
 /* Index variation in vbat ripple */
-#define M_LCN_PWR_IDX_MAX	(0x67 * 2)	/* highest index read by ucode */
-#define M_LCN_PWR_IDX_MIN	(0x66 * 2)	/* lowest index read by ucode */
+#define M_LCN_PWR_IDX_MAX	(0x67 * 2) /* highest index read by ucode */
+#define M_LCN_PWR_IDX_MIN	(0x66 * 2) /* lowest index read by ucode */
 
 /* M_PKTENG_CTRL bit definitions */
 #define M_PKTENG_MODE_TX		0x0001
@@ -1223,11 +1288,14 @@ struct tx_status {
 #define M_PKTENG_MODE_RX		0x0002
 #define M_PKTENG_MODE_RX_WITH_ACK	0x0402
 #define M_PKTENG_MODE_MASK		0x0003
-#define M_PKTENG_FRMCNT_VLD		0x0100	/* TX frames indicated in the frmcnt reg */
+/* TX frames indicated in the frmcnt reg */
+#define M_PKTENG_FRMCNT_VLD		0x0100
 
 /* Sample Collect parameters (bitmap and type) */
-#define M_SMPL_COL_BMP		(0x37d * 2)	/* Trigger bitmap for sample collect */
-#define M_SMPL_COL_CTL		(0x3b2 * 2)	/* Sample collect type */
+/* Trigger bitmap for sample collect */
+#define M_SMPL_COL_BMP		(0x37d * 2)
+/* Sample collect type */
+#define M_SMPL_COL_CTL		(0x3b2 * 2)
 
 #define ANTSEL_CLKDIV_4MHZ	6
 #define MIMO_ANTSEL_BUSY	0x4000	/* bit 14 (busy) */
@@ -1259,27 +1327,37 @@ struct shm_acparams {
 #define MHF5		4	/* Hostflag 5 index */
 
 /* Flags in M_HOST_FLAGS */
-#define	MHF1_ANTDIV		0x0001	/* Enable ucode antenna diversity help */
-#define	MHF1_EDCF		0x0100	/* Enable EDCF access control */
+/* Enable ucode antenna diversity help */
+#define	MHF1_ANTDIV		0x0001
+/* Enable EDCF access control */
+#define	MHF1_EDCF		0x0100
 #define MHF1_IQSWAP_WAR		0x0200
-#define	MHF1_FORCEFASTCLK	0x0400	/* Disable Slow clock request, for corerev < 11 */
+/* Disable Slow clock request, for corerev < 11 */
+#define	MHF1_FORCEFASTCLK	0x0400
 
 /* Flags in M_HOST_FLAGS2 */
-#define MHF2_PCISLOWCLKWAR	0x0008	/* PR16165WAR : Enable ucode PCI slow clock WAR */
-#define MHF2_TXBCMC_NOW		0x0040	/* Flush BCMC FIFO immediately */
-#define MHF2_HWPWRCTL		0x0080	/* Enable ucode/hw power control */
+/* PR16165WAR : Enable ucode PCI slow clock WAR */
+#define MHF2_PCISLOWCLKWAR	0x0008
+/* Flush BCMC FIFO immediately */
+#define MHF2_TXBCMC_NOW		0x0040
+/* Enable ucode/hw power control */
+#define MHF2_HWPWRCTL		0x0080
 #define MHF2_NPHY40MHZ_WAR	0x0800
 
 /* Flags in M_HOST_FLAGS3 */
-#define MHF3_ANTSEL_EN		0x0001	/* enabled mimo antenna selection */
-#define MHF3_ANTSEL_MODE	0x0002	/* antenna selection mode: 0: 2x3, 1: 2x4 */
+/* enabled mimo antenna selection */
+#define MHF3_ANTSEL_EN		0x0001
+/* antenna selection mode: 0: 2x3, 1: 2x4 */
+#define MHF3_ANTSEL_MODE	0x0002
 #define MHF3_RESERVED1		0x0004
 #define MHF3_RESERVED2		0x0008
 #define MHF3_NPHY_MLADV_WAR	0x0010
 
 /* Flags in M_HOST_FLAGS4 */
-#define MHF4_BPHY_TXCORE0	0x0080	/* force bphy Tx on core 0 (board level WAR) */
-#define MHF4_EXTPA_ENABLE	0x4000	/* for 4313A0 FEM boards */
+/* force bphy Tx on core 0 (board level WAR) */
+#define MHF4_BPHY_TXCORE0	0x0080
+/* for 4313A0 FEM boards */
+#define MHF4_EXTPA_ENABLE	0x4000
 
 /* Flags in M_HOST_FLAGS5 */
 #define MHF5_4313_GPIOCTRL	0x0001
@@ -1292,52 +1370,87 @@ struct shm_acparams {
 #define	M_PHY_NOISE		(0x037 * 2)
 #define	PHY_NOISE_MASK		0x00ff
 
-/* Receive Frame Data Header for 802.11b DCF-only frames */
+/*
+ * Receive Frame Data Header for 802.11b DCF-only frames
+ *
+ * RxFrameSize: Actual byte length of the frame data received
+ * PAD: padding (not used)
+ * PhyRxStatus_0: PhyRxStatus 15:0
+ * PhyRxStatus_1: PhyRxStatus 31:16
+ * PhyRxStatus_2: PhyRxStatus 47:32
+ * PhyRxStatus_3: PhyRxStatus 63:48
+ * PhyRxStatus_4: PhyRxStatus 79:64
+ * PhyRxStatus_5: PhyRxStatus 95:80
+ * RxStatus1: MAC Rx Status
+ * RxStatus2: extended MAC Rx status
+ * RxTSFTime: RxTSFTime time of first MAC symbol + M_PHY_PLCPRX_DLY
+ * RxChan: gain code, channel radio code, and phy type
+ */
 struct d11rxhdr {
-	u16 RxFrameSize;	/* Actual byte length of the frame data received */
+	u16 RxFrameSize;
 	u16 PAD;
-	u16 PhyRxStatus_0;	/* PhyRxStatus 15:0 */
-	u16 PhyRxStatus_1;	/* PhyRxStatus 31:16 */
-	u16 PhyRxStatus_2;	/* PhyRxStatus 47:32 */
-	u16 PhyRxStatus_3;	/* PhyRxStatus 63:48 */
-	u16 PhyRxStatus_4;	/* PhyRxStatus 79:64 */
-	u16 PhyRxStatus_5;	/* PhyRxStatus 95:80 */
-	u16 RxStatus1;	/* MAC Rx Status */
-	u16 RxStatus2;	/* extended MAC Rx status */
-	u16 RxTSFTime;	/* RxTSFTime time of first MAC symbol + M_PHY_PLCPRX_DLY */
-	u16 RxChan;		/* gain code, channel radio code, and phy type */
+	u16 PhyRxStatus_0;
+	u16 PhyRxStatus_1;
+	u16 PhyRxStatus_2;
+	u16 PhyRxStatus_3;
+	u16 PhyRxStatus_4;
+	u16 PhyRxStatus_5;
+	u16 RxStatus1;
+	u16 RxStatus2;
+	u16 RxTSFTime;
+	u16 RxChan;
 } __packed;
 
 #define	RXHDR_LEN		24	/* sizeof struct d11rxhdr */
 #define	FRAMELEN(h)		((h)->RxFrameSize)
 
+/*
+ * rxhdr: received frame header data
+ * tsf_l: TSF_L reading
+ * rssi: computed instanteneous rssi in BMAC
+ * rxpwr0: obsoleted, place holder for legacy ROM code. use rxpwr[]
+ * rxpwr1: obsoleted, place holder for legacy ROM code. use rxpwr[]
+ * do_rssi_ma: do per-pkt sampling for per-antenna ma in HIGH
+ * rxpwr: rssi for supported antennas
+ */
 struct brcms_d11rxhdr {
 	struct d11rxhdr rxhdr;
-	u32 tsf_l;		/* TSF_L reading */
-	s8 rssi;		/* computed instanteneous rssi in BMAC */
-	s8 rxpwr0;		/* obsoleted, place holder for legacy ROM code. use rxpwr[] */
-	s8 rxpwr1;		/* obsoleted, place holder for legacy ROM code. use rxpwr[] */
-	s8 do_rssi_ma;	/* do per-pkt sampling for per-antenna ma in HIGH */
-	s8 rxpwr[WL_RSSI_ANT_MAX];	/* rssi for supported antennas */
+	u32 tsf_l;
+	s8 rssi;
+	s8 rxpwr0;
+	s8 rxpwr1;
+	s8 do_rssi_ma;
+	s8 rxpwr[WL_RSSI_ANT_MAX];
 } __packed;
 
 /* PhyRxStatus_0: */
-#define	PRXS0_FT_MASK		0x0003	/* NPHY only: CCK, OFDM, preN, N */
-#define	PRXS0_CLIP_MASK		0x000C	/* NPHY only: clip count adjustment steps by AGC */
+/* NPHY only: CCK, OFDM, preN, N */
+#define	PRXS0_FT_MASK		0x0003
+/* NPHY only: clip count adjustment steps by AGC */
+#define	PRXS0_CLIP_MASK		0x000C
 #define	PRXS0_CLIP_SHIFT	2
-#define	PRXS0_UNSRATE		0x0010	/* PHY received a frame with unsupported rate */
-#define	PRXS0_RXANT_UPSUBBAND	0x0020	/* GPHY: rx ant, NPHY: upper sideband */
-#define	PRXS0_LCRS		0x0040	/* CCK frame only: lost crs during cck frame reception */
-#define	PRXS0_SHORTH		0x0080	/* Short Preamble */
-#define	PRXS0_PLCPFV		0x0100	/* PLCP violation */
-#define	PRXS0_PLCPHCF		0x0200	/* PLCP header integrity check failed */
-#define	PRXS0_GAIN_CTL		0x4000	/* legacy PHY gain control */
-#define PRXS0_ANTSEL_MASK	0xF000	/* NPHY: Antennas used for received frame, bitmask */
+/* PHY received a frame with unsupported rate */
+#define	PRXS0_UNSRATE		0x0010
+/* GPHY: rx ant, NPHY: upper sideband */
+#define	PRXS0_RXANT_UPSUBBAND	0x0020
+/* CCK frame only: lost crs during cck frame reception */
+#define	PRXS0_LCRS		0x0040
+/* Short Preamble */
+#define	PRXS0_SHORTH		0x0080
+/* PLCP violation */
+#define	PRXS0_PLCPFV		0x0100
+/* PLCP header integrity check failed */
+#define	PRXS0_PLCPHCF		0x0200
+/* legacy PHY gain control */
+#define	PRXS0_GAIN_CTL		0x4000
+/* NPHY: Antennas used for received frame, bitmask */
+#define PRXS0_ANTSEL_MASK	0xF000
 #define PRXS0_ANTSEL_SHIFT	0x12
 
 /* subfield PRXS0_FT_MASK */
 #define	PRXS0_CCK		0x0000
-#define	PRXS0_OFDM		0x0001	/* valid only for G phy, use rxh->RxChan for A phy */
+/* valid only for G phy, use rxh->RxChan for A phy */
+#define	PRXS0_OFDM		0x0001
 #define	PRXS0_PREN		0x0002
 #define	PRXS0_STDN		0x0003
 
@@ -1364,35 +1477,51 @@ struct brcms_d11rxhdr {
 #define PRXS0_UNUSED	        0xF000	/* unused and not defined; set to 0 */
 
 /* htphy PhyRxStatus_1: */
-#define PRXS1_HTPHY_CORE_MASK	0x000F	/* core enables for {3..0}, 0=disabled, 1=enabled */
-#define PRXS1_HTPHY_ANTCFG_MASK	0x00F0	/* antenna configation */
-#define PRXS1_HTPHY_MMPLCPLenL_MASK	0xFF00	/* Mixmode PLCP Length low byte mask */
+/* core enables for {3..0}, 0=disabled, 1=enabled */
+#define PRXS1_HTPHY_CORE_MASK	0x000F
+/* antenna configation */
+#define PRXS1_HTPHY_ANTCFG_MASK	0x00F0
+/* Mixmode PLCP Length low byte mask */
+#define PRXS1_HTPHY_MMPLCPLenL_MASK	0xFF00
 
 /* htphy PhyRxStatus_2: */
-#define PRXS2_HTPHY_MMPLCPLenH_MASK	0x000F	/* Mixmode PLCP Length high byte maskw */
-#define PRXS2_HTPHY_MMPLCH_RATE_MASK	0x00F0	/* Mixmode PLCP rate mask */
-#define PRXS2_HTPHY_RXPWR_ANT0	0xFF00	/* Rx power on core 0 */
+/* Mixmode PLCP Length high byte maskw */
+#define PRXS2_HTPHY_MMPLCPLenH_MASK	0x000F
+/* Mixmode PLCP rate mask */
+#define PRXS2_HTPHY_MMPLCH_RATE_MASK	0x00F0
+/* Rx power on core 0 */
+#define PRXS2_HTPHY_RXPWR_ANT0	0xFF00
 
 /* htphy PhyRxStatus_3: */
-#define PRXS3_HTPHY_RXPWR_ANT1	0x00FF	/* Rx power on core 1 */
-#define PRXS3_HTPHY_RXPWR_ANT2	0xFF00	/* Rx power on core 2 */
+/* Rx power on core 1 */
+#define PRXS3_HTPHY_RXPWR_ANT1	0x00FF
+/* Rx power on core 2 */
+#define PRXS3_HTPHY_RXPWR_ANT2	0xFF00
 
 /* htphy PhyRxStatus_4: */
-#define PRXS4_HTPHY_RXPWR_ANT3	0x00FF	/* Rx power on core 3 */
-#define PRXS4_HTPHY_CFO		0xFF00	/* Coarse frequency offset */
+/* Rx power on core 3 */
+#define PRXS4_HTPHY_RXPWR_ANT3	0x00FF
+/* Coarse frequency offset */
+#define PRXS4_HTPHY_CFO		0xFF00
 
 /* htphy PhyRxStatus_5: */
-#define PRXS5_HTPHY_FFO	        0x00FF	/* Fine frequency offset */
-#define PRXS5_HTPHY_AR	        0xFF00	/* Advance Retard */
+/* Fine frequency offset */
+#define PRXS5_HTPHY_FFO	        0x00FF
+/* Advance Retard */
+#define PRXS5_HTPHY_AR	        0xFF00
 
-#define HTPHY_MMPLCPLen(rxs)	((((rxs)->PhyRxStatus_1 & PRXS1_HTPHY_MMPLCPLenL_MASK) >> 8) | \
+#define HTPHY_MMPLCPLen(rxs) \
+	((((rxs)->PhyRxStatus_1 & PRXS1_HTPHY_MMPLCPLenL_MASK) >> 8) | \
 	(((rxs)->PhyRxStatus_2 & PRXS2_HTPHY_MMPLCPLenH_MASK) << 8))
 /* Get Rx power on core 0 */
-#define HTPHY_RXPWR_ANT0(rxs)	((((rxs)->PhyRxStatus_2) & PRXS2_HTPHY_RXPWR_ANT0) >> 8)
+#define HTPHY_RXPWR_ANT0(rxs) \
+	((((rxs)->PhyRxStatus_2) & PRXS2_HTPHY_RXPWR_ANT0) >> 8)
 /* Get Rx power on core 1 */
-#define HTPHY_RXPWR_ANT1(rxs)	(((rxs)->PhyRxStatus_3) & PRXS3_HTPHY_RXPWR_ANT1)
+#define HTPHY_RXPWR_ANT1(rxs) \
+	(((rxs)->PhyRxStatus_3) & PRXS3_HTPHY_RXPWR_ANT1)
 /* Get Rx power on core 2 */
-#define HTPHY_RXPWR_ANT2(rxs)	((((rxs)->PhyRxStatus_3) & PRXS3_HTPHY_RXPWR_ANT2) >> 8)
+#define HTPHY_RXPWR_ANT2(rxs) \
+	((((rxs)->PhyRxStatus_3) & PRXS3_HTPHY_RXPWR_ANT2) >> 8)
 
 /* ucode RxStatus1: */
 #define	RXS_BCNSENT		0x8000
@@ -1400,7 +1529,8 @@ struct brcms_d11rxhdr {
 #define	RXS_SECKINDX_SHIFT	5
 #define	RXS_DECERR		(1 << 4)
 #define	RXS_DECATMPT		(1 << 3)
-#define	RXS_PBPRES		(1 << 2)	/* PAD bytes to make IP data 4 bytes aligned */
+/* PAD bytes to make IP data 4 bytes aligned */
+#define	RXS_PBPRES		(1 << 2)
 #define	RXS_RESPFRAMETX		(1 << 1)
 #define	RXS_FCSERR		(1 << 0)
 
@@ -1433,16 +1563,17 @@ struct brcms_d11rxhdr {
 #define	M_PSM_SOFT_REGS	0x0
 #define	M_BOM_REV_MAJOR	(M_PSM_SOFT_REGS + 0x0)
 #define	M_BOM_REV_MINOR	(M_PSM_SOFT_REGS + 0x2)
-#define	M_UCODE_DBGST	(M_PSM_SOFT_REGS + 0x40)	/* ucode debug status code */
-#define	M_UCODE_MACSTAT	(M_PSM_SOFT_REGS + 0xE0)	/* macstat counters */
+#define	M_UCODE_DBGST	(M_PSM_SOFT_REGS + 0x40) /* ucode debug status code */
+#define	M_UCODE_MACSTAT	(M_PSM_SOFT_REGS + 0xE0) /* macstat counters */
 
-#define M_AGING_THRSH	(0x3e * 2)	/* max time waiting for medium before tx */
-#define	M_MBURST_SIZE	(0x40 * 2)	/* max frames in a frameburst */
-#define	M_MBURST_TXOP	(0x41 * 2)	/* max frameburst TXOP in unit of us */
-#define M_SYNTHPU_DLY	(0x4a * 2)	/* pre-wakeup for synthpu, default: 500 */
+#define M_AGING_THRSH	(0x3e * 2) /* max time waiting for medium before tx */
+#define	M_MBURST_SIZE	(0x40 * 2) /* max frames in a frameburst */
+#define	M_MBURST_TXOP	(0x41 * 2) /* max frameburst TXOP in unit of us */
+#define M_SYNTHPU_DLY	(0x4a * 2) /* pre-wakeup for synthpu, default: 500 */
 #define	M_PRETBTT	(0x4b * 2)
 
-#define M_ALT_TXPWR_IDX		(M_PSM_SOFT_REGS + (0x3b * 2))	/* offset to the target txpwr */
+/* offset to the target txpwr */
+#define M_ALT_TXPWR_IDX		(M_PSM_SOFT_REGS + (0x3b * 2))
 #define M_PHY_TX_FLT_PTR	(M_PSM_SOFT_REGS + (0x3d * 2))
 #define M_CTS_DURATION		(M_PSM_SOFT_REGS + (0x5c * 2))
 #define M_LP_RCCAL_OVR		(M_PSM_SOFT_REGS + (0x6b * 2))
@@ -1451,11 +1582,16 @@ struct brcms_d11rxhdr {
 #define M_RXSTATS_BLK_PTR	(M_PSM_SOFT_REGS + (0x65 * 2))
 
 /* ucode debug status codes */
-#define	DBGST_INACTIVE		0	/* not valid really */
-#define	DBGST_INIT		1	/* after zeroing SHM, before suspending at init */
-#define	DBGST_ACTIVE		2	/* "normal" state */
-#define	DBGST_SUSPENDED		3	/* suspended */
-#define	DBGST_ASLEEP		4	/* asleep (PS mode) */
+/* not valid really */
+#define	DBGST_INACTIVE		0
+/* after zeroing SHM, before suspending at init */
+#define	DBGST_INIT		1
+/* "normal" state */
+#define	DBGST_ACTIVE		2
+/* suspended */
+#define	DBGST_SUSPENDED		3
+/* asleep (PS mode) */
+#define	DBGST_ASLEEP		4
 
 /* Scratch Reg defs */
 enum _ePsmScratchPadRegDefinitions {
@@ -1463,66 +1599,66 @@ enum _ePsmScratchPadRegDefinitions {
 	S_RSV1,
 	S_RSV2,
 
-	/* scratch registers for Dot11-contants */
-	S_DOT11_CWMIN,		/* CW-minimum                                   0x03 */
-	S_DOT11_CWMAX,		/* CW-maximum                                   0x04 */
-	S_DOT11_CWCUR,		/* CW-current                                   0x05 */
-	S_DOT11_SRC_LMT,	/* short retry count limit                      0x06 */
-	S_DOT11_LRC_LMT,	/* long retry count limit                       0x07 */
-	S_DOT11_DTIMCOUNT,	/* DTIM-count                                   0x08 */
-
-	/* Tx-side scratch registers */
-	S_SEQ_NUM,		/* hardware sequence number reg                 0x09 */
-	S_SEQ_NUM_FRAG,		/* seq-num for frags (Set at the start os MSDU  0x0A */
-	S_FRMRETX_CNT,		/* frame retx count                             0x0B */
-	S_SSRC,			/* Station short retry count                    0x0C */
-	S_SLRC,			/* Station long retry count                     0x0D */
-	S_EXP_RSP,		/* Expected response frame                      0x0E */
-	S_OLD_BREM,		/* Remaining backoff ctr                        0x0F */
-	S_OLD_CWWIN,		/* saved-off CW-cur                             0x10 */
-	S_TXECTL,		/* TXE-Ctl word constructed in scr-pad          0x11 */
-	S_CTXTST,		/* frm type-subtype as read from Tx-descr       0x12 */
-
-	/* Rx-side scratch registers */
-	S_RXTST,		/* Type and subtype in Rxframe                  0x13 */
+	/* offset 0x03: scratch registers for Dot11-contants */
+	S_DOT11_CWMIN,		/* CW-minimum */
+	S_DOT11_CWMAX,		/* CW-maximum */
+	S_DOT11_CWCUR,		/* CW-current */
+	S_DOT11_SRC_LMT,	/* short retry count limit */
+	S_DOT11_LRC_LMT,	/* long retry count limit */
+	S_DOT11_DTIMCOUNT,	/* DTIM-count */
+
+	/* offset 0x09: Tx-side scratch registers */
+	S_SEQ_NUM,		/* hardware sequence number reg */
+	S_SEQ_NUM_FRAG,		/* seq num for frags (at the start of MSDU) */
+	S_FRMRETX_CNT,		/* frame retx count */
+	S_SSRC,			/* Station short retry count */
+	S_SLRC,			/* Station long retry count */
+	S_EXP_RSP,		/* Expected response frame */
+	S_OLD_BREM,		/* Remaining backoff ctr */
+	S_OLD_CWWIN,		/* saved-off CW-cur */
+	S_TXECTL,		/* TXE-Ctl word constructed in scr-pad */
+	S_CTXTST,		/* frm type-subtype as read from Tx-descr */
+
+	/* offset 0x13: Rx-side scratch registers */
+	S_RXTST,		/* Type and subtype in Rxframe */
 
 	/* Global state register */
-	S_STREG,		/* state storage actual bit maps below          0x14 */
-
-	S_TXPWR_SUM,		/* Tx power control: accumulator                0x15 */
-	S_TXPWR_ITER,		/* Tx power control: iteration                  0x16 */
-	S_RX_FRMTYPE,		/* Rate and PHY type for frames                 0x17 */
-	S_THIS_AGG,		/* Size of this AGG (A-MSDU)                    0x18 */
-
-	S_KEYINDX,		/*                                              0x19 */
-	S_RXFRMLEN,		/* Receive MPDU length in bytes                 0x1A */
-
-	/* Receive TSF time stored in SCR */
-	S_RXTSFTMRVAL_WD3,	/* TSF value at the start of rx                 0x1B */
-	S_RXTSFTMRVAL_WD2,	/* TSF value at the start of rx                 0x1C */
-	S_RXTSFTMRVAL_WD1,	/* TSF value at the start of rx                 0x1D */
-	S_RXTSFTMRVAL_WD0,	/* TSF value at the start of rx                 0x1E */
-	S_RXSSN,		/* Received start seq number for A-MPDU BA      0x1F */
-	S_RXQOSFLD,		/* Rx-QoS field (if present)                    0x20 */
-
-	/* Scratch pad regs used in microcode as temp storage */
-	S_TMP0,			/* stmp0                                        0x21 */
-	S_TMP1,			/* stmp1                                        0x22 */
-	S_TMP2,			/* stmp2                                        0x23 */
-	S_TMP3,			/* stmp3                                        0x24 */
-	S_TMP4,			/* stmp4                                        0x25 */
-	S_TMP5,			/* stmp5                                        0x26 */
-	S_PRQPENALTY_CTR,	/* Probe response queue penalty counter         0x27 */
-	S_ANTCNT,		/* unsuccessful attempts on current ant.        0x28 */
-	S_SYMBOL,		/* flag for possible symbol ctl frames          0x29 */
-	S_RXTP,			/* rx frame type                                0x2A */
-	S_STREG2,		/* extra state storage                          0x2B */
-	S_STREG3,		/* even more extra state storage                0x2C */
-	S_STREG4,		/* ...                                          0x2D */
-	S_STREG5,		/* remember to initialize it to zero            0x2E */
+	S_STREG,		/* state storage actual bit maps below */
+
+	S_TXPWR_SUM,		/* Tx power control: accumulator */
+	S_TXPWR_ITER,		/* Tx power control: iteration */
+	S_RX_FRMTYPE,		/* Rate and PHY type for frames */
+	S_THIS_AGG,		/* Size of this AGG (A-MSDU) */
+
+	S_KEYINDX,
+	S_RXFRMLEN,		/* Receive MPDU length in bytes */
+
+	/* offset 0x1B: Receive TSF time stored in SCR */
+	S_RXTSFTMRVAL_WD3,	/* TSF value at the start of rx */
+	S_RXTSFTMRVAL_WD2,	/* TSF value at the start of rx */
+	S_RXTSFTMRVAL_WD1,	/* TSF value at the start of rx */
+	S_RXTSFTMRVAL_WD0,	/* TSF value at the start of rx */
+	S_RXSSN,		/* Received start seq number for A-MPDU BA */
+	S_RXQOSFLD,		/* Rx-QoS field (if present) */
+
+	/* offset 0x21: Scratch pad regs used in microcode as temp storage */
+	S_TMP0,			/* stmp0 */
+	S_TMP1,			/* stmp1 */
+	S_TMP2,			/* stmp2 */
+	S_TMP3,			/* stmp3 */
+	S_TMP4,			/* stmp4 */
+	S_TMP5,			/* stmp5 */
+	S_PRQPENALTY_CTR,	/* Probe response queue penalty counter */
+	S_ANTCNT,		/* unsuccessful attempts on current ant. */
+	S_SYMBOL,		/* flag for possible symbol ctl frames */
+	S_RXTP,			/* rx frame type */
+	S_STREG2,		/* extra state storage */
+	S_STREG3,		/* even more extra state storage */
+	S_STREG4,		/* ... */
+	S_STREG5,		/* remember to initialize it to zero */
 
 	S_ADJPWR_IDX,
-	S_CUR_PTR,		/* Temp pointer for A-MPDU re-Tx SHM table      0x32 */
+	S_CUR_PTR,		/* Temp pointer for A-MPDU re-Tx SHM table */
 	S_REVID4,		/* 0x33 */
 	S_INDX,			/* 0x34 */
 	S_ADDR0,		/* 0x35 */
@@ -1532,9 +1668,9 @@ enum _ePsmScratchPadRegDefinitions {
 	S_ADDR4,		/* 0x39 */
 	S_ADDR5,		/* 0x3A */
 	S_TMP6,			/* 0x3B */
-	S_KEYINDX_BU,		/* Backup for Key index                         0x3C */
-	S_MFGTEST_TMP0,		/* Temp register used for RX test calculations  0x3D */
-	S_RXESN,		/* Received end sequence number for A-MPDU BA   0x3E */
+	S_KEYINDX_BU,		/* Backup for Key index */
+	S_MFGTEST_TMP0,		/* Temp regs used for RX test calculations */
+	S_RXESN,		/* Received end sequence number for A-MPDU BA */
 	S_STREG6,		/* 0x3F */
 };
 
@@ -1628,7 +1764,8 @@ struct macstat {
 #define	SISF_FCLKA		0x0004	/* FastClkAvailable */
 #define	SISF_DB_PHY		0x0008	/* Dualband phy */
 
-/* === End of MAC reg, Beginning of PHY(b/a/g/n) reg, radio and LPPHY regs are separated === */
+/* === End of MAC reg, Beginning of PHY(b/a/g/n) reg === */
+/* radio and LPPHY regs are separated */
 
 #define	BPHY_REG_OFT_BASE	0x0
 /* offsets for indirect access to bphy registers */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 31a4728..e662023 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -28,7 +28,8 @@
 #include "dma.h"
 
 /*
- * Each descriptor ring must be 8kB aligned, and fit within a contiguous 8kB physical address.
+ * Each descriptor ring must be 8kB aligned, and fit within a
+ * contiguous 8kB physical address.
  */
 #define D64RINGALIGN_BITS	13
 #define	D64MAXRINGSZ		(1 << D64RINGALIGN_BITS)
@@ -69,21 +70,32 @@
 #define	D64_XS1_XE_COREE	0x50000000	/* core error */
 
 /* receive channel control */
-#define	D64_RC_RE		0x00000001	/* receive enable */
-#define	D64_RC_RO_MASK		0x000000fe	/* receive frame offset */
+/* receive enable */
+#define	D64_RC_RE		0x00000001
+/* receive frame offset */
+#define	D64_RC_RO_MASK		0x000000fe
 #define	D64_RC_RO_SHIFT		1
-#define	D64_RC_FM		0x00000100	/* direct fifo receive (pio) mode */
-#define	D64_RC_SH		0x00000200	/* separate rx header descriptor enable */
-#define	D64_RC_OC		0x00000400	/* overflow continue */
-#define	D64_RC_PD		0x00000800	/* parity check disable */
-#define	D64_RC_AE		0x00030000	/* address extension bits */
+/* direct fifo receive (pio) mode */
+#define	D64_RC_FM		0x00000100
+/* separate rx header descriptor enable */
+#define	D64_RC_SH		0x00000200
+/* overflow continue */
+#define	D64_RC_OC		0x00000400
+/* parity check disable */
+#define	D64_RC_PD		0x00000800
+/* address extension bits */
+#define	D64_RC_AE		0x00030000
 #define	D64_RC_AE_SHIFT		16
 
 /* flags for dma controller */
-#define DMA_CTRL_PEN		(1 << 0)	/* partity enable */
-#define DMA_CTRL_ROC		(1 << 1)	/* rx overflow continue */
-#define DMA_CTRL_RXMULTI	(1 << 2)	/* allow rx scatter to multiple descriptors */
-#define DMA_CTRL_UNFRAMED	(1 << 3)	/* Unframed Rx/Tx data */
+/* partity enable */
+#define DMA_CTRL_PEN		(1 << 0)
+/* rx overflow continue */
+#define DMA_CTRL_ROC		(1 << 1)
+/* allow rx scatter to multiple descriptors */
+#define DMA_CTRL_RXMULTI	(1 << 2)
+/* Unframed Rx/Tx data */
+#define DMA_CTRL_UNFRAMED	(1 << 3)
 
 /* receive descriptor table pointer */
 #define	D64_RP_LD_MASK		0x00000fff	/* last valid descriptor */
@@ -131,10 +143,13 @@
 #define	D64_CTRL1_SOF		((u32)1 << 31)	/* start of frame */
 
 /* descriptor control flags 2 */
-#define	D64_CTRL2_BC_MASK	0x00007fff	/* buffer byte count. real data len must <= 16KB */
-#define	D64_CTRL2_AE		0x00030000	/* address extension bits */
+/* buffer byte count. real data len must <= 16KB */
+#define	D64_CTRL2_BC_MASK	0x00007fff
+/* address extension bits */
+#define	D64_CTRL2_AE		0x00030000
 #define	D64_CTRL2_AE_SHIFT	16
-#define D64_CTRL2_PARITY	0x00040000	/* parity bit */
+/* parity bit */
+#define D64_CTRL2_PARITY	0x00040000
 
 /* control flags in the range [27:20] are core-specific and not defined here */
 #define	D64_CTRL_CORE_MASK	0x0ff00000
@@ -149,10 +164,17 @@
 #define	DMADDRWIDTH_63  63	/* 64-bit addressing capability */
 #define	DMADDRWIDTH_64  64	/* 64-bit addressing capability */
 
-/* packet headroom necessary to accommodate the largest header in the system, (i.e TXOFF).
- * By doing, we avoid the need  to allocate an extra buffer for the header when bridging to WL.
- * There is a compile time check in wlc.c which ensure that this value is at least as big
- * as TXOFF. This value is used in dma_rxfill (dma.c).
+#define DMA64_DD_PARITY(dd) \
+	parity32((dd)->addrlow ^ (dd)->addrhigh ^ (dd)->ctrl1 ^ (dd)->ctrl2)
+
+
+/*
+ * packet headroom necessary to accommodate the largest header
+ * in the system, (i.e TXOFF). By doing, we avoid the need to
+ * allocate an extra buffer for the header when bridging to WL.
+ * There is a compile time check in wlc.c which ensure that this
+ * value is at least as big as TXOFF. This value is used in
+ * dma_rxfill().
  */
 
 #define BCMEXTRAHDROOM 172
@@ -193,7 +215,10 @@
 #define txd64		dregs.d64_u.txd_64
 #define rxd64		dregs.d64_u.rxd_64
 
-/* default dma message level (if input msg_level pointer is null in dma_attach()) */
+/*
+ * default dma message level (if input msg_level
+ * pointer is null in dma_attach())
+ */
 static uint dma_msg_level;
 
 #define	MAXNAMEL	8	/* 8 char names */
@@ -210,8 +235,8 @@ struct dma_seg {
 };
 
 struct dma_seg_map {
-	void *oshdmah;		/* Opaque handle for OSL to store its information */
-	uint origsize;		/* Size of the virtual packet */
+	void *oshdmah;	/* Opaque handle for OSL to store its information */
+	uint origsize;	/* Size of the virtual packet */
 	uint nsegs;
 	struct dma_seg segs[MAX_DMA_SEGS];
 };
@@ -221,9 +246,9 @@ struct dma_seg_map {
  * Descriptors are only read by the hardware, never written back.
  */
 struct dma64desc {
-	u32 ctrl1;		/* misc control bits & bufcount */
-	u32 ctrl2;		/* buffer count and address extension */
-	u32 addrlow;		/* memory address of the date buffer, bits 31:0 */
+	u32 ctrl1;	/* misc control bits & bufcount */
+	u32 ctrl2;	/* buffer count and address extension */
+	u32 addrlow;	/* memory address of the date buffer, bits 31:0 */
 	u32 addrhigh;	/* memory address of the date buffer, bits 63:32 */
 };
 
@@ -235,8 +260,8 @@ struct dma_info {
 
 	void *pbus;		/* bus handle */
 
-	bool dma64;		/* this dma engine is operating in 64-bit mode */
-	bool addrext;		/* this dma engine supports DmaExtendedAddrChanges */
+	bool dma64;	/* this dma engine is operating in 64-bit mode */
+	bool addrext;	/* this dma engine supports DmaExtendedAddrChanges */
 
 	union {
 		struct {
@@ -256,7 +281,7 @@ struct dma_info {
 	u16 ntxd;		/* # tx descriptors tunable */
 	u16 txin;		/* index of next descriptor to reclaim */
 	u16 txout;		/* index of next descriptor to post */
-	void **txp;		/* pointer to parallel array of pointers to packets */
+	void **txp;	/* pointer to parallel array of pointers to packets */
 	struct dma_seg_map *txp_dmah;	/* DMA MAP meta-data handle */
 	/* Aligned physical address of descriptor ring */
 	unsigned long txdpa;
@@ -265,14 +290,14 @@ struct dma_info {
 	u16 txdalign;	/* #bytes added to alloc'd mem to align txd */
 	u32 txdalloc;	/* #bytes allocated for the ring */
 	u32 xmtptrbase;	/* When using unaligned descriptors, the ptr register
-				 * is not just an index, it needs all 13 bits to be
-				 * an offset from the addr register.
-				 */
+			 * is not just an index, it needs all 13 bits to be
+			 * an offset from the addr register.
+			 */
 
-	u16 nrxd;		/* # rx descriptors tunable */
-	u16 rxin;		/* index of next descriptor to reclaim */
-	u16 rxout;		/* index of next descriptor to post */
-	void **rxp;		/* pointer to parallel array of pointers to packets */
+	u16 nrxd;	/* # rx descriptors tunable */
+	u16 rxin;	/* index of next descriptor to reclaim */
+	u16 rxout;	/* index of next descriptor to post */
+	void **rxp;	/* pointer to parallel array of pointers to packets */
 	struct dma_seg_map *rxp_dmah;	/* DMA MAP meta-data handle */
 	/* Aligned physical address of descriptor ring */
 	unsigned long rxdpa;
@@ -283,25 +308,34 @@ struct dma_info {
 	u32 rcvptrbase;	/* Base for ptr reg when using unaligned descriptors */
 
 	/* tunables */
-	unsigned int rxbufsize;	/* rx buffer size in bytes,
-				 * not including the extra headroom
+	unsigned int rxbufsize;	/* rx buffer size in bytes, not including
+				 * the extra headroom
 				 */
-	uint rxextrahdrroom;	/* extra rx headroom, reverseved to assist upper stack
-				 *  e.g. some rx pkt buffers will be bridged to tx side
-				 *  without byte copying. The extra headroom needs to be
-				 *  large enough to fit txheader needs.
-				 *  Some dongle driver may not need it.
+	uint rxextrahdrroom;	/* extra rx headroom, reverseved to assist upper
+				 * stack, e.g. some rx pkt buffers will be
+				 * bridged to tx side without byte copying.
+				 * The extra headroom needs to be large enough
+				 * to fit txheader needs. Some dongle driver may
+				 * not need it.
 				 */
 	uint nrxpost;		/* # rx buffers to keep posted */
 	unsigned int rxoffset;	/* rxcontrol offset */
-	uint ddoffsetlow;	/* add to get dma address of descriptor ring, low 32 bits */
-	uint ddoffsethigh;	/*   high 32 bits */
-	uint dataoffsetlow;	/* add to get dma address of data buffer, low 32 bits */
-	uint dataoffsethigh;	/*   high 32 bits */
-	bool aligndesc_4k;	/* descriptor base need to be aligned or not */
+	/* add to get dma address of descriptor ring, low 32 bits */
+	uint ddoffsetlow;
+	/*   high 32 bits */
+	uint ddoffsethigh;
+	/* add to get dma address of data buffer, low 32 bits */
+	uint dataoffsetlow;
+	/*   high 32 bits */
+	uint dataoffsethigh;
+	/* descriptor base need to be aligned or not */
+	bool aligndesc_4k;
 };
 
-/* DMA Scatter-gather list is supported. Note this is limited to TX direction only */
+/*
+ * DMA Scatter-gather list is supported. Note this is limited to TX
+ * direction only
+ */
 #ifdef BCMDMASGLISTOSL
 #define DMASGLIST_ENAB true
 #else
@@ -309,7 +343,9 @@ struct dma_info {
 #endif				/* BCMDMASGLISTOSL */
 
 /* descriptor bumping macros */
-#define	XXD(x, n)	((x) & ((n) - 1))	/* faster than %, but n must be power of 2 */
+/* faster than %, but n must be power of 2 */
+#define	XXD(x, n)	((x) & ((n) - 1))
+
 #define	TXD(x)		XXD((x), di->ntxd)
 #define	RXD(x)		XXD((x), di->nrxd)
 #define	NEXTTXD(i)	TXD((i) + 1)
@@ -465,10 +501,10 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->d64rxregs = (struct dma64regs *) dmaregsrx;
 	di->dma.di_fn = (const struct di_fcn_s *)&dma64proc;
 
-	/* Default flags (which can be changed by the driver calling dma_ctrlflags
-	 * before enable): For backwards compatibility both Rx Overflow Continue
-	 * and Parity are DISABLED.
-	 * supports it.
+	/*
+	 * Default flags (which can be changed by the driver calling
+	 * dma_ctrlflags before enable): For backwards compatibility
+	 * both Rx Overflow Continue and Parity are DISABLED.
 	 */
 	di->dma.di_fn->ctrlflags(&di->dma, DMA_CTRL_ROC | DMA_CTRL_PEN,
 				 0);
@@ -502,9 +538,10 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 
 	/*
 	 * figure out the DMA physical address offset for dd and data
-	 *     PCI/PCIE: they map silicon backplace address to zero based memory, need offset
-	 *     Other bus: use zero
-	 *     SI_BUS BIGENDIAN kludge: use sdram swapped region for data buffer, not descriptor
+	 *     PCI/PCIE: they map silicon backplace address to zero
+	 *     based memory, need offset
+	 *     Other bus: use zero SI_BUS BIGENDIAN kludge: use sdram
+	 *     swapped region for data buffer, not descriptor
 	 */
 	di->ddoffsetlow = 0;
 	di->dataoffsetlow = 0;
@@ -529,7 +566,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	else
 		di->addrext = _dma_isaddrext(di);
 
-	/* does the descriptors need to be aligned and if yes, on 4K/8K or not */
+	/* does the descriptor need to be aligned and if yes, on 4K/8K or not */
 	di->aligndesc_4k = _dma_descriptor_align(di);
 	if (di->aligndesc_4k) {
 		di->dmadesc_align = D64RINGALIGN_BITS;
@@ -548,7 +585,8 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		size = ntxd * sizeof(void *);
 		di->txp = kzalloc(size, GFP_ATOMIC);
 		if (di->txp == NULL) {
-			DMA_ERROR(("%s: dma_attach: out of tx memory\n", di->name));
+			DMA_ERROR(("%s: dma_attach: out of tx memory\n",
+				   di->name));
 			goto fail;
 		}
 	}
@@ -558,18 +596,25 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		size = nrxd * sizeof(void *);
 		di->rxp = kzalloc(size, GFP_ATOMIC);
 		if (di->rxp == NULL) {
-			DMA_ERROR(("%s: dma_attach: out of rx memory\n", di->name));
+			DMA_ERROR(("%s: dma_attach: out of rx memory\n",
+				   di->name));
 			goto fail;
 		}
 	}
 
-	/* allocate transmit descriptor ring, only need ntxd descriptors but it must be aligned */
+	/*
+	 * allocate transmit descriptor ring, only need ntxd descriptors
+	 * but it must be aligned
+	 */
 	if (ntxd) {
 		if (!_dma_alloc(di, DMA_TX))
 			goto fail;
 	}
 
-	/* allocate receive descriptor ring, only need nrxd descriptors but it must be aligned */
+	/*
+	 * allocate receive descriptor ring, only need nrxd descriptors
+	 * but it must be aligned
+	 */
 	if (nrxd) {
 		if (!_dma_alloc(di, DMA_RX))
 			goto fail;
@@ -577,16 +622,23 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 
 	if ((di->ddoffsetlow != 0) && !di->addrext) {
 		if (PHYSADDRLO(di->txdpa) > SI_PCI_DMA_SZ) {
-			DMA_ERROR(("%s: dma_attach: txdpa 0x%x: addrext not supported\n", di->name, (u32) PHYSADDRLO(di->txdpa)));
+			DMA_ERROR(("%s: dma_attach: txdpa 0x%x: addrext not "
+				   "supported\n", di->name,
+				   (u32)PHYSADDRLO(di->txdpa)));
 			goto fail;
 		}
 		if (PHYSADDRLO(di->rxdpa) > SI_PCI_DMA_SZ) {
-			DMA_ERROR(("%s: dma_attach: rxdpa 0x%x: addrext not supported\n", di->name, (u32) PHYSADDRLO(di->rxdpa)));
+			DMA_ERROR(("%s: dma_attach: rxdpa 0x%x: addrext not "
+				   "supported\n", di->name,
+				   (u32)PHYSADDRLO(di->rxdpa)));
 			goto fail;
 		}
 	}
 
-	DMA_TRACE(("ddoffsetlow 0x%x ddoffsethigh 0x%x dataoffsetlow 0x%x dataoffsethigh " "0x%x addrext %d\n", di->ddoffsetlow, di->ddoffsethigh, di->dataoffsetlow, di->dataoffsethigh, di->addrext));
+	DMA_TRACE(("ddoffsetlow 0x%x ddoffsethigh 0x%x dataoffsetlow 0x%x "
+		   "dataoffsethigh " "0x%x addrext %d\n", di->ddoffsetlow,
+		   di->ddoffsethigh, di->dataoffsetlow, di->dataoffsethigh,
+		   di->addrext));
 
 	/* allocate DMA mapping vectors */
 	if (DMASGLIST_ENAB) {
@@ -624,8 +676,6 @@ static inline u32 parity32(u32 data)
 	return data & 1;
 }
 
-#define DMA64_DD_PARITY(dd)  parity32((dd)->addrlow ^ (dd)->addrhigh ^ (dd)->ctrl1 ^ (dd)->ctrl2)
-
 static inline void
 dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 	     unsigned long pa, uint outidx, u32 *flags, u32 bufcount)
@@ -735,7 +785,10 @@ static bool _dma_descriptor_align(struct dma_info *di)
 	return true;
 }
 
-/* return true if this dma engine supports DmaExtendedAddrChanges, otherwise false */
+/*
+ * return true if this dma engine supports DmaExtendedAddrChanges,
+ * otherwise false
+ */
 static bool _dma_isaddrext(struct dma_info *di)
 {
 	/* DMA64 supports full 32- or 64-bit operation. AE is always valid */
@@ -868,14 +921,15 @@ _dma_rx_param_get(struct dma_info *di, u16 *rxoffset, u16 *rxbufsize)
 	*rxbufsize = (u16) di->rxbufsize;
 }
 
-/* !! rx entry routine
+/*
+ * !! rx entry routine
  * returns a pointer to the next frame received, or NULL if there are no more
- *   if DMA_CTRL_RXMULTI is defined, DMA scattering(multiple buffers) is supported
- *      with pkts chain
+ *   if DMA_CTRL_RXMULTI is defined, DMA scattering(multiple buffers) is
+ *   supported with pkts chain
  *   otherwise, it's treated as giant pkt and will be tossed.
- *   The DMA scattering starts with normal DMA header, followed by first buffer data.
- *   After it reaches the max size of buffer, the data continues in next DMA descriptor
- *   buffer WITHOUT DMA header
+ *   The DMA scattering starts with normal DMA header, followed by first
+ *   buffer data. After it reaches the max size of buffer, the data continues
+ *   in next DMA descriptor buffer WITHOUT DMA header
  */
 static void *_dma_rx(struct dma_info *di)
 {
@@ -935,10 +989,11 @@ static void *_dma_rx(struct dma_info *di)
 	return head;
 }
 
-/* post receive buffers
- *  return false is refill failed completely and ring is empty
- *  this will stall the rx dma and user might want to call rxfill again asap
- *  This unlikely happens on memory-rich NIC, but often on memory-constrained dongle
+/*
+ * post receive buffers
+ *  return false is refill failed completely and ring is empty this will stall
+ *  the rx dma and user might want to call rxfill again asap. This unlikely
+ *  happens on memory-rich NIC, but often on memory-constrained dongle
  */
 static bool _dma_rxfill(struct dma_info *di)
 {
@@ -970,10 +1025,10 @@ static bool _dma_rxfill(struct dma_info *di)
 		extra_offset = di->rxextrahdrroom;
 
 	for (i = 0; i < n; i++) {
-		/* the di->rxbufsize doesn't include the extra headroom, we need to add it to the
-		   size to be allocated
+		/*
+		 * the di->rxbufsize doesn't include the extra headroom,
+		 * we need to add it to the size to be allocated
 		 */
-
 		p = brcmu_pkt_buf_get_skb(di->rxbufsize + extra_offset);
 
 		if (p == NULL) {
@@ -1339,7 +1394,8 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
 			&alloced, &di->txdpaorig);
 		if (va == NULL) {
-			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(ntxd) failed\n", di->name));
+			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(ntxd)"
+				   " failed\n", di->name));
 			return false;
 		}
 		align = (1 << align_bits);
@@ -1354,7 +1410,8 @@ static bool dma64_alloc(struct dma_info *di, uint direction)
 		va = dma_ringalloc(di, D64RINGALIGN, size, &align_bits,
 			&alloced, &di->rxdpaorig);
 		if (va == NULL) {
-			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(nrxd) failed\n", di->name));
+			DMA_ERROR(("%s: dma64_alloc: DMA_ALLOC_CONSISTENT(nrxd)"
+				   " failed\n", di->name));
 			return false;
 		}
 		align = (1 << align_bits);
@@ -1445,9 +1502,10 @@ static bool dma64_txsuspendedidle(struct dma_info *di)
 	return 0;
 }
 
-/* Useful when sending unframed data.  This allows us to get a progress report from the DMA.
- * We return a pointer to the beginning of the DATA buffer of the current descriptor.
- * If DMA is idle, we return NULL.
+/*
+ * Useful when sending unframed data.  This allows us to get a progress report
+ * from the DMA. We return a pointer to the beginning of the DATA buffer of the
+ * current descriptor. If DMA is idle, we return NULL.
  */
 static void *dma64_getpos(struct dma_info *di, bool direction)
 {
@@ -1481,8 +1539,8 @@ static void *dma64_getpos(struct dma_info *di, bool direction)
  * Adds a DMA ring descriptor for the data pointed to by "buf".
  * This is for DMA of a buffer of data and is unlike other dma TX functions
  * that take a pointer to a "packet"
- * Each call to this is results in a single descriptor being added for "len" bytes of
- * data starting at "buf", it doesn't handle chained buffers.
+ * Each call to this is results in a single descriptor being added for "len"
+ * bytes of data starting at "buf", it doesn't handle chained buffers.
  */
 static int
 dma64_txunframed(struct dma_info *di, void *buf, uint len, bool commit)
@@ -1533,9 +1591,11 @@ dma64_txunframed(struct dma_info *di, void *buf, uint len, bool commit)
 	return -1;
 }
 
-/* !! tx entry routine
+/*
+ * !! tx entry routine
  * WARNING: call must check the return value for error.
- *   the error(toss frames) could be fatal and cause many subsequent hard to debug problems
+ *   the error(toss frames) could be fatal and cause many subsequent hard
+ *   to debug problems
  */
 static int dma64_txfast(struct dma_info *di, struct sk_buff *p0,
 				    bool commit)
@@ -1597,8 +1657,8 @@ static int dma64_txfast(struct dma_info *di, struct sk_buff *p0,
 
 			/* With a DMA segment list, Descriptor table is filled
 			 * using the segment list instead of looping over
-			 * buffers in multi-chain DMA. Therefore, EOF for SGLIST is when
-			 * end of segment list is reached.
+			 * buffers in multi-chain DMA. Therefore, EOF for SGLIST
+			 * is when end of segment list is reached.
 			 */
 			if ((!DMASGLIST_ENAB && next == NULL) ||
 			    (DMASGLIST_ENAB && j == nsegs))
@@ -1746,7 +1806,8 @@ static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range)
 	return txp;
 
  bogus:
-	DMA_NONE(("dma_getnexttxp: bogus curr: start %d end %d txout %d force %d\n", start, end, di->txout, forceall));
+	DMA_NONE(("dma_getnexttxp: bogus curr: start %d end %d txout %d "
+		  "force %d\n", start, end, di->txout, forceall));
 	return NULL;
 }
 
@@ -1888,7 +1949,7 @@ uint dma_addrwidth(struct si_pub *sih, void *dmaregs)
 			     (sih->buscoretype == PCIE_CORE_ID)))
 				return DMADDRWIDTH_64;
 	}
-	/* DMA hardware not supported by this driver*/
+	/* DMA hardware not supported by this driver */
 	return DMADDRWIDTH_64;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 334f2eb..4a33028 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -39,12 +39,12 @@ struct dma32diag {	/* diag access */
 
 /* dma registers per channel(xmt or rcv) */
 struct dma64regs {
-	u32 control;		/* enable, et al */
-	u32 ptr;		/* last descriptor posted to chip */
-	u32 addrlow;		/* descriptor ring base address low 32-bits (8K aligned) */
-	u32 addrhigh;	/* descriptor ring base address bits 63:32 (8K aligned) */
-	u32 status0;		/* current descriptor, xmt state */
-	u32 status1;		/* active descriptor, xmt error */
+	u32 control;	/* enable, et al */
+	u32 ptr;	/* last descriptor posted to chip */
+	u32 addrlow;	/* desc ring base address low 32-bits (8K aligned) */
+	u32 addrhigh;	/* desc ring base address bits 63:32 (8K aligned) */
+	u32 status0;	/* current descriptor, xmt state */
+	u32 status1;	/* active descriptor, xmt error */
 };
 
 /* map/unmap direction */
@@ -172,7 +172,8 @@ extern const struct di_fcn_s dma64proc;
 #define dma_rxactive(di)                (dma64proc.rxactive(di))
 #define dma_txrotate(di)                (dma64proc.txrotate(di))
 #define dma_counterreset(di)            (dma64proc.counterreset(di))
-#define dma_ctrlflags(di, mask, flags)  (dma64proc.ctrlflags((di), (mask), (flags)))
+#define dma_ctrlflags(di, mask, flags) \
+	(dma64proc.ctrlflags((di), (mask), (flags)))
 #define dma_txpending(di)		(dma64proc.txpending(di))
 #define dma_txcommitted(di)		(dma64proc.txcommitted(di))
 
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 1437e51..0af6041 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -606,7 +606,10 @@ brcms_ops_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT;
 
-	/* minstrel_ht initiates addBA on our behalf by calling ieee80211_start_tx_ba_session() */
+	/*
+	 * minstrel_ht initiates addBA on our behalf by calling
+	 * ieee80211_start_tx_ba_session()
+	 */
 	return 0;
 }
 
@@ -644,7 +647,10 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 				  tid);
 			return -EINVAL;
 		}
-		/* Future improvement: Use the starting sequence number provided ... */
+		/*
+		 * Future improvement:
+		 *   Use the starting sequence number provided ...
+		 */
 		*ssn = 0;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
@@ -1019,8 +1025,9 @@ static struct ieee80211_supported_band brcms_band_5GHz_nphy = {
 	.bitrates = legacy_ratetable + 4,
 	.n_bitrates = ARRAY_SIZE(legacy_ratetable) - 4,
 	.ht_cap = {
-		   /* use IEEE80211_HT_CAP_* from include/linux/ieee80211.h */
-		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 | IEEE80211_HT_CAP_SGI_40 | IEEE80211_HT_CAP_40MHZ_INTOLERANT,	/* No 40 mhz yet */
+		   .cap = IEEE80211_HT_CAP_GRN_FLD | IEEE80211_HT_CAP_SGI_20 |
+			  IEEE80211_HT_CAP_SGI_40 |
+			  IEEE80211_HT_CAP_40MHZ_INTOLERANT, /* No 40 mhz yet */
 		   .ht_supported = true,
 		   .ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K,
 		   .ampdu_density = AMPDU_DEF_MPDU_DENSITY,
@@ -1086,7 +1093,8 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	hw->queues = N_TX_QUEUES;
 	hw->max_rates = 2;	/* Primary rate and 1 fallback rate */
 
-	hw->channel_change_time = 7 * 1000;	/* channel change time is dependent on chip and band  */
+	/* channel change time is dependent on chip and band  */
+	hw->channel_change_time = 7 * 1000;
 	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	hw->rate_control_algorithm = "minstrel_ht";
@@ -1361,8 +1369,9 @@ static void brcms_free(struct brcms_info *wl)
 	}
 
 	/*
-	 * unregister_netdev() calls get_stats() which may read chip registers
-	 * so we cannot unmap the chip registers until after calling unregister_netdev() .
+	 * unregister_netdev() calls get_stats() which may read chip
+	 * registers so we cannot unmap the chip registers until
+	 * after calling unregister_netdev() .
 	 */
 	if (wl->regsva && wl->bcm_bustype != SDIO_BUS &&
 	    wl->bcm_bustype != JTAG_BUS)
@@ -1632,7 +1641,8 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 	return t;
 }
 
-/* BMAC_NOTE: Add timer adds only the kernel timer since it's going to be more accurate
+/*
+ * adds only the kernel timer since it's going to be more accurate
  * as well as it's easier to make it periodic
  *
  * precondition: perimeter lock has been acquired
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 40e3d37..0d91366 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -23,11 +23,6 @@
 /* softmac ioctl definitions */
 #define BRCMS_SET_SHORTSLOT_OVERRIDE		146
 
-
-/* BMAC Note: High-only driver is no longer working in softirq context as it needs to block and
- * sleep so perimeter lock has to be a semaphore instead of spinlock. This requires timers to be
- * submitted to workqueue instead of being on kernel timer
- */
 struct brcms_timer {
 	struct timer_list timer;
 	struct brcms_info *wl;
@@ -56,8 +51,8 @@ struct brcms_firmware {
 };
 
 struct brcms_info {
-	struct brcms_pub *pub;		/* pointer to public wlc state */
-	void *wlc;		/* pointer to private common os-independent data */
+	struct brcms_pub *pub;	/* pointer to public wlc state */
+	void *wlc;		/* pointer to private common data */
 	u32 magic;
 
 	int irq;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 001a1f7..d1a8388 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -53,8 +53,10 @@
  */
 #define SSID_FMT_BUF_LEN	((4 * IEEE80211_MAX_SSID_LEN) + 1)
 
-#define	TIMER_INTERVAL_WATCHDOG	1000	/* watchdog timer, in unit of ms */
-#define	TIMER_INTERVAL_RADIOCHK	800	/* radio monitor timer, in unit of ms */
+/* watchdog timer, in unit of ms */
+#define	TIMER_INTERVAL_WATCHDOG	1000
+/* radio monitor timer, in unit of ms */
+#define	TIMER_INTERVAL_RADIOCHK	800
 
 /* Max MPC timeout, in unit of watchdog */
 #ifndef BRCMS_MPC_MAX_DELAYCNT
@@ -65,12 +67,16 @@
 #define	BRCMS_MPC_MIN_DELAYCNT	1
 #define	BRCMS_MPC_THRESHOLD	3	/* MPC count threshold level */
 
-#define	BEACON_INTERVAL_DEFAULT	100	/* beacon interval, in unit of 1024TU */
-#define	DTIM_INTERVAL_DEFAULT	3	/* DTIM interval, in unit of beacon interval */
+/* beacon interval, in unit of 1024TU */
+#define	BEACON_INTERVAL_DEFAULT	100
+/* DTIM interval, in unit of beacon interval */
+#define	DTIM_INTERVAL_DEFAULT	3
 
 /* Scale down delays to accommodate QT slow speed */
-#define	BEACON_INTERVAL_DEF_QT	20	/* beacon interval, in unit of 1024TU */
-#define	DTIM_INTERVAL_DEF_QT	1	/* DTIM interval, in unit of beacon interval */
+/* beacon interval, in unit of 1024TU */
+#define	BEACON_INTERVAL_DEF_QT	20
+/* DTIM interval, in unit of beacon interval */
+#define	DTIM_INTERVAL_DEF_QT	1
 
 #define	TBTT_ALIGN_LEEWAY_US	100	/* min leeway before first TBTT in us */
 
@@ -163,26 +169,32 @@
 #define AC_VO			3
 
 /*
- * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s OS timer(soft
- * watchdog) it is not a wall clock and won't increment when driver is in "down" state
- * this low resolution driver tick can be used for maintenance tasks such as phy
- * calibration and scb update
+ * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s
+ * OS timer(soft watchdog) it is not a wall clock and won't increment when
+ * driver is in "down" state this low resolution driver tick can be used
+ * for maintenance tasks such as phy calibration and scb update
  */
 
-/* To inform the ucode of the last mcast frame posted so that it can clear moredata bit */
+/*
+ * To inform the ucode of the last mcast frame posted
+ * so that it can clear moredata bit
+ */
 #define BCMCFID(wlc, fid) brcms_b_write_shm((wlc)->hw, M_BCMC_FID, (fid))
 
 #define BRCMS_WAR16165(wlc) (wlc->pub->sih->bustype == PCI_BUS && \
 				(!AP_ENAB(wlc->pub)) && (wlc->war16165))
 
 /* Find basic rate for a given rate */
-#define BRCMS_BASIC_RATE(wlc, rspec)	(IS_MCS(rspec) ? \
-			(wlc)->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK].leg_ofdm] : \
-			(wlc)->band->basic_rate[rspec & RSPEC_RATE_MASK])
+#define BRCMS_BASIC_RATE(wlc, rspec) \
+	(IS_MCS(rspec) \
+	? (wlc)->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK].leg_ofdm] \
+	: (wlc)->band->basic_rate[rspec & RSPEC_RATE_MASK])
 
-#define FRAMETYPE(r, mimoframe)	(IS_MCS(r) ? mimoframe	: (IS_CCK(r) ? FT_CCK : FT_OFDM))
+#define FRAMETYPE(r, mimoframe)	\
+	(IS_MCS(r) ? mimoframe	: (IS_CCK(r) ? FT_CCK : FT_OFDM))
 
-#define RFDISABLE_DEFAULT	10000000	/* rfdisable delay timer 500 ms, runs of ALP clock */
+/* rfdisable delay timer 500 ms, runs of ALP clock */
+#define RFDISABLE_DEFAULT	10000000
 
 #define BRCMS_TEMPSENSE_PERIOD		10	/* 10 second timeout */
 
@@ -193,7 +205,8 @@
 /* precedences numbers for wlc queues. These are twice as may levels as
  * 802.1D priorities.
  * Odd numbers are used for HI priority traffic at same precedence levels
- * These constants are used ONLY by wlc_prio2prec_map.  Do not use them elsewhere.
+ * These constants are used ONLY by wlc_prio2prec_map.  Do not use them
+ * elsewhere.
  */
 #define	_BRCMS_PREC_NONE		0	/* None = - */
 #define	_BRCMS_PREC_BK		2	/* BK - Background */
@@ -216,11 +229,9 @@
 #define MBSS_PRB_ENAB(cfg)       0
 #define SOFTBCN_ENAB(pub)    (0)
 
-#define	TIMER_INTERVAL_WATCHDOG_BMAC	1000	/* watchdog timer, in unit of ms */
-
 #define	SYNTHPU_DLY_APHY_US	3700	/* a phy synthpu_dly time in us */
-#define	SYNTHPU_DLY_BPHY_US	1050	/* b/g phy synthpu_dly time in us, default */
-#define	SYNTHPU_DLY_NPHY_US	2048	/* n phy REV3 synthpu_dly time in us, default */
+#define	SYNTHPU_DLY_BPHY_US	1050	/* b/g phy synthpu_dly time in us */
+#define	SYNTHPU_DLY_NPHY_US	2048	/* n phy REV3 synthpu_dly time in us */
 #define	SYNTHPU_DLY_LPPHY_US	300	/* lpphy synthpu_dly time in us */
 
 #define	SYNTHPU_DLY_PHY_US_QT	100	/* QT synthpu_dly time in us */
@@ -244,7 +255,8 @@
  * the twiki is updated before making changes.
  */
 
-#define XMTFIFOTBL_STARTREV	20	/* Starting corerev for the fifo size table */
+/* Starting corerev for the fifo size table */
+#define XMTFIFOTBL_STARTREV	20
 
 /* Check if a particular BSS config is AP or STA */
 #define BSSCFG_AP(cfg)		(0)
@@ -487,11 +499,16 @@ const u8 wlc_prio2prec_map[] = {
 };
 
 static u16 xmtfifo_sz[][NFIFO] = {
-	{20, 192, 192, 21, 17, 5},	/* corerev 20: 5120, 49152, 49152, 5376, 4352, 1280 */
-	{9, 58, 22, 14, 14, 5},	/* corerev 21: 2304, 14848, 5632, 3584, 3584, 1280 */
-	{20, 192, 192, 21, 17, 5},	/* corerev 22: 5120, 49152, 49152, 5376, 4352, 1280 */
-	{20, 192, 192, 21, 17, 5},	/* corerev 23: 5120, 49152, 49152, 5376, 4352, 1280 */
-	{9, 58, 22, 14, 14, 5},	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
+	/* corerev 20: 5120, 49152, 49152, 5376, 4352, 1280 */
+	{20, 192, 192, 21, 17, 5},
+	/* corerev 21: 2304, 14848, 5632, 3584, 3584, 1280 */
+	{9, 58, 22, 14, 14, 5},
+	/* corerev 22: 5120, 49152, 49152, 5376, 4352, 1280 */
+	{20, 192, 192, 21, 17, 5},
+	/* corerev 23: 5120, 49152, 49152, 5376, 4352, 1280 */
+	{20, 192, 192, 21, 17, 5},
+	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
+	{9, 58, 22, 14, 14, 5},
 };
 
 static const u8 acbitmap2maxprio[] = {
@@ -631,7 +648,9 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 
 		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
 
-		/* compute the RSSI from d11rxhdr and record it in wlc_rxd11hr */
+		/*
+		 * compute the RSSI from d11rxhdr and record it in wlc_rxd11hr
+		 */
 		wlc_phy_rssi_compute(wlc_hw->band->pi, wlc_rxhdr);
 
 		brcms_c_recv(wlc_hw->wlc, p);
@@ -645,9 +664,9 @@ brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
 		   u32 s2)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
-	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
-	 *   tx of DATA failed. so it will start rts/cts from the beginning (resetting the rts
-	 *   transmission count)
+	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
+	 *   but the subsequent tx of DATA failed. so it will start rts/cts from
+	 *   the beginning (resetting the rts transmission count)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE))
@@ -768,7 +787,10 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		wlc->qvalid = 0;
 	}
 
-	/* received data or control frame, MI_DMAINT is indication of RX_FIFO interrupt */
+	/*
+	 * received data or control frame, MI_DMAINT is
+	 * indication of RX_FIFO interrupt
+	 */
 	if (macintstatus & MI_DMAINT)
 		if (brcms_b_recv(wlc_hw, RX_FIFO, bounded))
 			wlc->macintstatus |= MI_DMAINT;
@@ -826,7 +848,9 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 {
 	uint i;
 	char name[8];
-	/* ucode host flag 2 needed for pio mode, independent of band and fifo */
+	/*
+	 * ucode host flag 2 needed for pio mode, independent of band and fifo
+	 */
 	u16 pio_mhf2 = 0;
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
@@ -979,10 +1003,10 @@ static int brcms_b_bandtype(struct brcms_hardware *wlc_hw)
 static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 {
 	if (PMUCTL_ENAB(wlc_hw->sih)) {
-		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock on backplane,
-		 *  but mac core will still run on ALP(not HT) when it enters powersave mode,
-		 *      which means the FCA bit may not be set.
-		 *      should wakeup mac if driver wants it to run on HT.
+		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock
+		 * on backplane, but mac core will still run on ALP(not HT) when
+		 * it enters powersave mode, which means the FCA bit may not be
+		 * set. Should wakeup mac if driver wants it to run on HT.
 		 */
 
 		if (wlc_hw->clk) {
@@ -1027,14 +1051,15 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 			WARN_ON(!(ai_core_sflags(wlc_hw->sih, 0, 0) &
 				  SISF_FCLKA));
 
-		/* keep the ucode wake bit on if forcefastclk is on
-		 * since we do not want ucode to put us back to slow clock
-		 * when it dozes for PM mode.
-		 * Code below matches the wake override bit with current forcefastclk state
-		 * Only setting bit in wake_override instead of waking ucode immediately
-		 * since old code (wlc.c 1.4499) had this behavior. Older code set
-		 * wlc->forcefastclk but only had the wake happen if the wakup_ucode work
-		 * (protected by an up check) was executed just below.
+		/*
+		 * keep the ucode wake bit on if forcefastclk is on since we
+		 * do not want ucode to put us back to slow clock when it dozes
+		 * for PM mode. Code below matches the wake override bit with
+		 * current forcefastclk state. Only setting bit in wake_override
+		 * instead of waking ucode immediately since old code had this
+		 * behavior. Older code set wlc->forcefastclk but only had the
+		 * wake happen if the wakup_ucode work (protected by an up
+		 * check) was executed just below.
 		 */
 		if (wlc_hw->forcefastclk)
 			mboolset(wlc_hw->wake_override,
@@ -1176,7 +1201,10 @@ void brcms_b_mctrl(struct brcms_hardware *wlc_hw, u32 mask, u32 val)
 	brcms_c_mctrl_write(wlc_hw);
 }
 
-/* write the software state of maccontrol and overrides to the maccontrol register */
+/*
+ * write the software state of maccontrol and
+ * overrides to the maccontrol register
+ */
 static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw)
 {
 	u32 maccontrol = wlc_hw->maccontrol;
@@ -1418,7 +1446,10 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 
 	brcms_c_ucode_txant_set(wlc_hw);
 
-	/* cwmin is band-specific, update hardware with value for current band */
+	/*
+	 * cwmin is band-specific, update hardware
+	 * with value for current band
+	 */
 	brcms_b_set_cwmin(wlc_hw, wlc_hw->band->CWmin);
 	brcms_b_set_cwmax(wlc_hw, wlc_hw->band->CWmax);
 
@@ -1431,7 +1462,10 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 	brcms_b_write_shm(wlc_hw, M_PHYTYPE, (u16) wlc_hw->band->phytype);
 	brcms_b_write_shm(wlc_hw, M_PHYVER, (u16) wlc_hw->band->phyrev);
 
-	/* initialize the txphyctl1 rate table since shmem is shared between bands */
+	/*
+	 * initialize the txphyctl1 rate table since
+	 * shmem is shared between bands
+	 */
 	brcms_upd_ofdm_pctl1_table(wlc_hw);
 
 	brcms_b_upd_synthpu(wlc_hw);
@@ -1590,7 +1624,10 @@ void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
 
 	wlc_hw->band = wlc_hw->bandstate[bandunit];
 
-	/* BMAC_NOTE: until we eliminate need for wlc->band refs in low level code */
+	/*
+	 * BMAC_NOTE:
+	 *   until we eliminate need for wlc->band refs in low level code
+	 */
 	wlc_hw->wlc->band = wlc_hw->wlc->bandstate[bandunit];
 
 	/* set gmode core flag */
@@ -1689,7 +1726,10 @@ bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		 */
 		flags |= SICF_PCLKE;
 
-		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
+		/*
+		 * AI chip doesn't restore bar0win2 on
+		 * hibernation/resume, need sw fixup
+		 */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
 			wlc_hw->regs = (struct d11regs *)
@@ -1771,12 +1811,15 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	 */
 	flags |= SICF_PCLKE;
 
-	/* reset the core
-	 * In chips with PMU, the fastclk request goes through d11 core reg 0x1e0, which
-	 *  is cleared by the core_reset. have to re-request it.
-	 *  This adds some delay and we can optimize it by also requesting fastclk through
-	 *  chipcommon during this period if necessary. But that has to work coordinate
-	 *  with other driver like mips/arm since they may touch chipcommon as well.
+	/*
+	 * reset the core
+	 * In chips with PMU, the fastclk request goes through d11 core
+	 * reg 0x1e0, which is cleared by the core_reset. have to re-request it.
+	 *
+	 * This adds some delay and we can optimize it by also requesting
+	 * fastclk through chipcommon during this period if necessary. But
+	 * that has to work coordinate with other driver like mips/arm since
+	 * they may touch chipcommon as well.
 	 */
 	wlc_hw->clk = false;
 	ai_core_reset(wlc_hw->sih, flags, resetbits);
@@ -1948,7 +1991,10 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 				   ANTSEL_CLKDIV_4MHZ);
 	}
 
-	/* gpio 9 controls the PA.  ucode is responsible for wiggling out and oe */
+	/*
+	 * gpio 9 controls the PA. ucode is responsible
+	 * for wiggling out and oe
+	 */
 	if (wlc_hw->boardflags & BFL_PACTRL)
 		gm |= gc |= BOARD_GPIO_PACTRL;
 
@@ -2134,11 +2180,11 @@ void brcms_c_intrson(struct brcms_c_info *wlc)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
-/* callback for siutils.c, which has only wlc handler, no wl
- * they both check up, not only because there is no need to off/restore d11 interrupt
- *  but also because per-port code may require sync with valid interrupt.
+/*
+ * callback for siutils.c, which has only wlc handler, no wl they both check
+ * up, not only because there is no need to off/restore d11 interrupt but also
+ * because per-port code may require sync with valid interrupt.
  */
-
 static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc)
 {
 	if (!wlc->hw->up)
@@ -2203,9 +2249,10 @@ static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 	wlc_hw->suspended_fifos |= fifo;
 
 	if (wlc_hw->di[tx_fifo]) {
-		/* Suspending AMPDU transmissions in the middle can cause underflow
-		 * which may result in mismatch between ucode and driver
-		 * so suspend the mac before suspending the FIFO
+		/*
+		 * Suspending AMPDU transmissions in the middle can cause
+		 * underflow which may result in mismatch between ucode and
+		 * driver so suspend the mac before suspending the FIFO
 		 */
 		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
 			brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
@@ -2268,11 +2315,12 @@ static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
 	/* check that a suspend has been requested and is no longer pending */
 
 	/*
-	 * for DMA mode, the suspend request is set in xmtcontrol of the DMA engine,
-	 * and the tx fifo suspend at the lower end of the MAC is acknowledged in the
-	 * chnstatus register.
-	 * The tx fifo suspend completion is independent of the DMA suspend completion and
-	 *   may be acked before or after the DMA is suspended.
+	 * for DMA mode, the suspend request is set in xmtcontrol of the DMA
+	 * engine, and the tx fifo suspend at the lower end of the MAC is
+	 * acknowledged in the chnstatus register.
+	 *
+	 * The tx fifo suspend completion is independent of the DMA suspend
+	 * completion and may be acked before or after the DMA is suspended.
 	 */
 	if (dma_txsuspended(wlc_hw->di[tx_fifo]) &&
 	    (R_REG(&wlc_hw->regs->chnstatus) &
@@ -2709,8 +2757,10 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 					  "PHY PLL failed\n", __func__);
 		}
 	} else {
-		/* Since the PLL may be shared, other cores can still be requesting it;
-		 * so we'll deassert the request but not wait for status to comply.
+		/*
+		 * Since the PLL may be shared, other cores can still
+		 * be requesting it; so we'll deassert the request but
+		 * not wait for status to comply.
 		 */
 		AND_REG(&regs->clk_ctl_st, ~CCS_ERSRC_REQ_PHYPLL);
 		tmp = R_REG(&regs->clk_ctl_st);
@@ -2759,7 +2809,10 @@ static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
 
-	/* dont power down if plldown is false or we must poll hw radio disable */
+	/*
+	 * dont power down if plldown is false or
+	 * we must poll hw radio disable
+	 */
 	if (!want && wlc_hw->pllreq)
 		return;
 
@@ -2942,7 +2995,9 @@ void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
 	wlc_hw->antsel_avail = antsel_avail;
 }
 
-/* conditions under which the PM bit should be set in outgoing frames and STAY_AWAKE is meaningful
+/*
+ * conditions under which the PM bit should be set in outgoing frames
+ * and STAY_AWAKE is meaningful
  */
 bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
@@ -3259,7 +3314,8 @@ brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 	mboolset(wlc_hw->wake_override, BRCMS_WAKE_OVERRIDE_MACSUSPEND);
 
 	/*
-	 * initialize mac_suspend_depth to 1 to match ucode initial suspended state
+	 * initialize mac_suspend_depth to 1 to match ucode
+	 * initial suspended state
 	 */
 	wlc_hw->mac_suspend_depth = 1;
 
@@ -3280,8 +3336,10 @@ void brcms_c_init(struct brcms_c_info *wlc)
 
 	regs = wlc->regs;
 
-	/* This will happen if a big-hammer was executed. In that case, we want to go back
-	 * to the channel that we were on and not new channel
+	/*
+	 * This will happen if a big-hammer was executed. In
+	 * that case, we want to go back to the channel that
+	 * we were on and not new channel
 	 */
 	if (wlc->pub->associated)
 		chanspec = wlc->home_chanspec;
@@ -3341,7 +3399,10 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
 	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
 
-	/* Update some shared memory locations related to max AMPDU size allowed to received */
+	/*
+	 * Update some shared memory locations related to
+	 * max AMPDU size allowed to received
+	 */
 	brcms_c_ampdu_shm_upd(wlc->ampdu);
 
 	/* band-specific inits */
@@ -3412,9 +3473,11 @@ void brcms_c_mac_promisc(struct brcms_c_info *wlc)
 {
 	u32 promisc_bits = 0;
 
-	/* promiscuous mode just sets MCTL_PROMISC
-	 * Note: APs get all BSS traffic without the need to set the MCTL_PROMISC bit
-	 * since all BSS data traffic is directed at the AP
+	/*
+	 * promiscuous mode just sets MCTL_PROMISC
+	 * Note: APs get all BSS traffic without the need to set
+	 * the MCTL_PROMISC bit since all BSS data traffic is
+	 * directed at the AP
 	 */
 	if (PROMISC_ENAB(wlc->pub) && !AP_ENAB(wlc->pub))
 		promisc_bits |= MCTL_PROMISC;
@@ -3559,7 +3622,10 @@ static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
 	return local;
 }
 
-/* propagate home chanspec to all bsscfgs in case bsscfg->current_bss->chanspec is referenced */
+/*
+ * propagate home chanspec to all bsscfgs in
+ * case bsscfg->current_bss->chanspec is referenced
+ */
 void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	if (wlc->home_chanspec != chanspec) {
@@ -3714,7 +3780,10 @@ u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 		}
 	}
 #if NCONF
-	/* pick siso/cdd as default for OFDM (note no basic rate MCSs are supported yet) */
+	/*
+	 * pick siso/cdd as default for OFDM (note no basic
+	 * rate MCSs are supported yet)
+	 */
 	if (IS_OFDM(lowest_basic_rspec))
 		lowest_basic_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
 
@@ -3723,8 +3792,9 @@ u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 	return lowest_basic_rspec;
 }
 
-/* This function changes the phytxctl for beacon based on current beacon ratespec AND txant
- * setting as per this table:
+/*
+ * This function changes the phytxctl for beacon based on current
+ * beacon ratespec AND txant setting as per this table:
  *  ratespec     CCK		ant = wlc->stf->txant
  *		OFDM		ant = 3
  */
@@ -3744,9 +3814,11 @@ void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 	brcms_c_write_shm(wlc, M_BCN_PCTLWD, phyctl);
 }
 
-/* centralized protection config change function to simplify debugging, no consistency checking
- * this should be called only on changes to avoid overhead in periodic function
-*/
+/*
+ * centralized protection config change function to simplify debugging, no
+ * consistency checking this should be called only on changes to avoid overhead
+ * in periodic function
+ */
 void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx, int val)
 {
 	BCMMSG(wlc->wiphy, "idx %d, val %d\n", idx, val);
@@ -3833,11 +3905,14 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 	 */
 	if (wlc->home_chanspec == BRCMS_BAND_PI_RADIO_CHANSPEC) {
 		if (wlc->pub->associated) {
-			/* BMAC_NOTE: This is something that should be fixed in ucode inits.
-			 * I think that the ucode inits set up the bcn templates and shm values
-			 * with a bogus beacon. This should not be done in the inits. If ucode needs
-			 * to set up a beacon for testing, the test routines should write it down,
-			 * not expect the inits to populate a bogus beacon.
+			/*
+			 * BMAC_NOTE: This is something that should be fixed
+			 * in ucode inits. I think that the ucode inits set
+			 * up the bcn templates and shm values with a bogus
+			 * beacon. This should not be done in the inits. If
+			 * ucode needs to set up a beacon for testing, the
+			 * test routines should write it down, not expect the
+			 * inits to populate a bogus beacon.
 			 */
 			if (BRCMS_PHY_11N_CAP(wlc->band))
 				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
@@ -3861,8 +3936,8 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 	/*
-	 * We might have been bandlocked during down and the chip power-cycled (hibernate).
-	 * figure out the right band to park on
+	 * We might have been bandlocked during down and the chip
+	 * power-cycled (hibernate). Figure out the right band to park on
 	 */
 	if (wlc->bandlocked || NBANDS(wlc) == 1) {
 		/* updated in brcms_c_bandlock() */
@@ -3939,7 +4014,10 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 	brcms_c_bsinit(wlc);
 }
 
-/* Initialize a WME Parameter Info Element with default STA parameters from WMM Spec, Table 12 */
+/*
+ * Initialize a WME Parameter Info Element with default
+ * STA parameters from WMM Spec, Table 12
+ */
 void
 brcms_c_wme_initparams_sta(struct brcms_c_info *wlc, struct wme_param_ie *pe)
 {
@@ -4165,7 +4243,8 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->pub->_wme = AUTO;
 
 #ifdef BCMSDIODEV_ENABLED
-	wlc->pub->_priofc = true;	/* enable priority flow control for sdio dongle */
+	/* enable priority flow control for sdio dongle */
+	wlc->pub->_priofc = true;
 #endif
 
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
@@ -4263,9 +4342,8 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	brcms_b_info_init(wlc_hw);
 
 	/*
-	 * Do the hardware portion of the attach.
-	 * Also initialize software state that depends on the particular hardware
-	 * we are running.
+	 * Do the hardware portion of the attach. Also initialize software
+	 * state that depends on the particular hardware we are running.
 	 */
 	wlc_hw->sih = ai_attach(regsva, bustype, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
@@ -4338,8 +4416,9 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 
 	/* request fastclock and force fastclock for the rest of attach
 	 * bring the d11 core out of reset.
-	 *   For PMU chips, the first wlc_clkctl_clk is no-op since core-clk is still false;
-	 *   But it will be called again inside wlc_corereset, after d11 is out of reset.
+	 *   For PMU chips, the first wlc_clkctl_clk is no-op since core-clk
+	 *   is still false; But it will be called again inside wlc_corereset,
+	 *   after d11 is out of reset.
 	 */
 	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
@@ -4505,11 +4584,14 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		}
 
  good_phy:
-		/* BMAC_NOTE: wlc->band->pi should not be set below and should be done in the
-		 * high level attach. However we can not make that change until all low level access
-		 * is changed to wlc_hw->band->pi. Instead do the wlc->band->pi init below, keeping
-		 * wlc_hw->band->pi as well for incremental update of low level fns, and cut over
-		 * low only init when all fns updated.
+		/*
+		 * BMAC_NOTE: wlc->band->pi should not be set below and should
+		 * be done in the high level attach. However we can not make
+		 * that change until all low level access is changed to
+		 * wlc_hw->band->pi. Instead do the wlc->band->pi init below,
+		 * keeping wlc_hw->band->pi as well for incremental update of
+		 * low level fns, and cut over low only init when all fns
+		 * updated.
 		 */
 		wlc->band->pi = wlc_hw->band->pi;
 		wlc->band->phytype = wlc_hw->band->phytype;
@@ -4541,7 +4623,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	/* turn off pll and xtal to match driver "down" state */
 	brcms_b_xtal(wlc_hw, OFF);
 
-	/* *********************************************************************
+	/* *******************************************************************
 	 * The hardware is in the DOWN state at this point. D11 core
 	 * or cores are in reset with clocks off, and the board PLLs
 	 * are off if possible.
@@ -4630,8 +4712,10 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if (err)
 		goto fail;
 
-	/* for some states, due to different info pointer(e,g, wlc, wlc_hw) or master/slave split,
-	 * HIGH driver(both monolithic and HIGH_ONLY) needs to sync states FROM BMAC portion driver
+	/*
+	 * for some states, due to different info pointer(e,g, wlc, wlc_hw) or
+	 * master/slave split, HIGH driver(both monolithic and HIGH_ONLY) needs
+	 * to sync states FROM BMAC portion driver
 	 */
 	if (!brcms_c_state_bmac_sync(wlc)) {
 		err = 20;
@@ -4719,7 +4803,10 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 				   (bool) N_ENAB(wlc->pub));
 	}
 
-	/* update antenna config due to wlc->stf->txant/txchain/ant_rx_ovr change */
+	/*
+	 * update antenna config due to
+	 * wlc->stf->txant/txchain/ant_rx_ovr change
+	 */
 	brcms_c_stf_phy_txant_upd(wlc);
 
 	/* attach each modules */
@@ -4847,14 +4934,17 @@ static void brcms_c_attach_antgain_init(struct brcms_c_info *wlc)
 	} else {
 		s8 gain, fract;
 		/* Older sroms specified gain in whole dbm only.  In order
-		 * be able to specify qdbm granularity and remain backward compatible
-		 * the whole dbms are now encoded in only low 6 bits and remaining qdbms
-		 * are encoded in the hi 2 bits. 6 bit signed number ranges from
-		 * -32 - 31. Examples: 0x1 = 1 db,
+		 * be able to specify qdbm granularity and remain backward
+		 * compatible the whole dbms are now encoded in only
+		 * low 6 bits and remaining qdbms are encoded in the hi 2 bits.
+		 * 6 bit signed number ranges from -32 - 31.
+		 *
+		 * Examples:
+		 * 0x1 = 1 db,
 		 * 0xc1 = 1.75 db (1 + 3 quarters),
 		 * 0x3f = -1 (-1 + 0 quarters),
-		 * 0x7f = -.75 (-1 in low 6 bits + 1 quarters in hi 2 bits) = -3 qdbm.
-		 * 0xbf = -.50 (-1 in low 6 bits + 2 quarters in hi 2 bits) = -2 qdbm.
+		 * 0x7f = -.75 (-1 + 1 quarters) = -3 qdbm.
+		 * 0xbf = -.50 (-1 + 2 quarters) = -2 qdbm.
 		 */
 		gain = wlc->band->antgain & 0x3f;
 		gain <<= 2;	/* Sign extend */
@@ -4946,8 +5036,10 @@ int brcms_b_detach(struct brcms_c_info *wlc)
 	callbacks = 0;
 
 	if (wlc_hw->sih) {
-		/* detach interrupt sync mechanism since interrupt is disabled and per-port
-		 * interrupt object may has been freed. this must be done before sb core switch
+		/*
+		 * detach interrupt sync mechanism since interrupt is disabled
+		 * and per-port interrupt object may has been freed. this must
+		 * be done before sb core switch
 		 */
 		ai_deregister_intr_callback(wlc_hw->sih);
 
@@ -5050,7 +5142,10 @@ static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
 }
 
-/* return true if Minimum Power Consumption should be entered, false otherwise */
+/*
+ * return true if Minimum Power Consumption should
+ * be entered, false otherwise
+ */
 bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
 {
 	return false;
@@ -5082,9 +5177,10 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 	}
 
 	/*
-	 * sync ismpc logic with WL_RADIO_MPC_DISABLE bit in wlc->pub->radio_disabled
-	 * to go ON, always call radio_upd synchronously
-	 * to go OFF, postpone radio_upd to later when context is safe(e.g. watchdog)
+	 * sync ismpc logic with WL_RADIO_MPC_DISABLE bit in
+	 * wlc->pub->radio_disabled to go ON, always call radio_upd
+	 * synchronously to go OFF, postpone radio_upd to later when
+	 * context is safe(e.g. watchdog)
 	 */
 	radio_state =
 	    (mboolisset(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE) ? OFF :
@@ -5102,9 +5198,11 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 			wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
 		wlc->mpc_dur += OSL_SYSUPTIME() - wlc->mpc_laston_ts;
 	}
-	/* Below logic is meant to capture the transition from mpc off to mpc on for reasons
-	 * other than wlc->mpc_delay_off keeping the mpc off. In that case reset
-	 * wlc->mpc_delay_off to wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
+	/*
+	 * Below logic is meant to capture the transition from mpc off
+	 * to mpc on for reasons other than wlc->mpc_delay_off keeping
+	 * the mpc off. In that case reset wlc->mpc_delay_off to
+	 * wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
 	 */
 	if ((wlc->prev_non_delay_mpc == false) &&
 	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off)
@@ -5128,8 +5226,10 @@ static void brcms_c_radio_upd(struct brcms_c_info *wlc)
 /* maintain LED behavior in down state */
 static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 {
-	/* maintain LEDs while in down state, turn on sbclk if not available yet */
-	/* turn on sbclk if necessary */
+	/*
+	 * maintain LEDs while in down state, turn on sbclk if
+	 * not available yet. Turn on sbclk if necessary
+	 */
 	if (!AP_ENAB(wlc->pub)) {
 		brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
 
@@ -5142,7 +5242,8 @@ bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
 {
 	brcms_c_radio_hwdisable_upd(wlc);
 
-	return mboolisset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE) ? true : false;
+	return mboolisset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE) ?
+			true : false;
 }
 
 void brcms_c_radio_disable(struct brcms_c_info *wlc)
@@ -5282,7 +5383,10 @@ static void brcms_c_watchdog(void *arg)
 
 	brcms_b_watchdog(wlc);
 
-	/* occasionally sample mac stat counters to detect 16-bit counter wrap */
+	/*
+	 * occasionally sample mac stat counters to
+	 * detect 16-bit counter wrap
+	 */
 	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
 		brcms_c_statsupd(wlc);
 
@@ -5327,14 +5431,20 @@ void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	if (wlc_hw->sih->bustype == PCI_BUS) {
 		ai_pci_fixcfg(wlc_hw->sih);
 
-		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
+		/*
+		 * AI chip doesn't restore bar0win2 on
+		 * hibernation/resume, need sw fixup
+		 */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
 			wlc_hw->regs = (struct d11regs *)
 					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 	}
 
-	/* Inform phy that a POR reset has occurred so it does a complete phy init */
+	/*
+	 * Inform phy that a POR reset has occurred so
+	 * it does a complete phy init
+	 */
 	wlc_phy_por_inform(wlc_hw->band->pi);
 
 	wlc_hw->ucode_loaded = false;
@@ -5373,8 +5483,9 @@ int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 		ai_pci_setup(wlc_hw->sih, coremask);
 
 	/*
-	 * Need to read the hwradio status here to cover the case where the system
-	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
+	 * Need to read the hwradio status here to cover the case where the
+	 * system is loaded with the hw radio disabled. We do not want to
+	 * bring the driver up in this case.
 	 */
 	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
 		/* put SB PCI in down state again */
@@ -5432,10 +5543,11 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	}
 
 	/*
-	 * Need to read the hwradio status here to cover the case where the system
-	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
-	 * if radio is disabled, abort up, lower power, start radio timer and return 0(for NDIS)
-	 * don't call radio_update to avoid looping brcms_c_up.
+	 * Need to read the hwradio status here to cover the case where the
+	 * system is loaded with the hw radio disabled. We do not want to bring
+	 * the driver up in this case. If radio is disabled, abort up, lower
+	 * power, start radio timer and return 0(for NDIS) don't call
+	 * radio_update to avoid looping brcms_c_up.
 	 *
 	 * brcms_b_up_prep() returns either 0 or -BCME_RADIOOFF only
 	 */
@@ -5513,14 +5625,18 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	return 0;
 }
 
-/* Initialize the base precedence map for dequeueing from txq based on WME settings */
+/*
+ * Initialize the base precedence map for dequeueing
+ * from txq based on WME settings
+ */
 static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
 {
 	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
 	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
 
-	/* For non-WME, both fifos have overlapping MAXPRIO. So just disable all precedences
-	 * if either is full.
+	/*
+	 * For non-WME, both fifos have overlapping MAXPRIO. So just
+	 * disable all precedences if either is full.
 	 */
 	if (!EDCF_ENAB(wlc->pub)) {
 		wlc->fifo2prec_map[TX_DATA_FIFO] = BRCMS_PREC_BMP_ALL;
@@ -5688,13 +5804,14 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	/* Default to 54g Auto */
 	/* Advertise and use shortslot (-1/0/1 Auto/Off/On) */
 	s8 shortslot = BRCMS_SHORTSLOT_AUTO;
-	bool shortslot_restrict = false;	/* Restrict association to stations that support shortslot
-						 */
+	bool shortslot_restrict = false; /* Restrict association to stations
+					  * that support shortslot
+					  */
 	bool ofdm_basic = false;	/* Make 6, 12, and 24 basic rates */
 	/* Advertise and use short preambles (-1/0/1 Auto/Off/On) */
 	int preamble = BRCMS_PLCP_LONG;
-	bool preamble_restrict = false;	/* Restrict association to stations that support short
-					 * preambles
+	bool preamble_restrict = false;	/* Restrict association to stations
+					 * that support short preambles
 					 */
 	struct brcms_band *band;
 
@@ -5752,7 +5869,8 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		break;
 
 	case GMODE_PERFORMANCE:
-		if (AP_ENAB(wlc->pub))	/* Put all rates into the Supported Rates element */
+		if (AP_ENAB(wlc->pub))
+			/* Put all rates into the Supported Rates element */
 			brcms_c_rateset_copy(&cck_ofdm_rates,
 					 &wlc->sup_rates_override);
 
@@ -6281,7 +6399,10 @@ brcms_c_module_unregister(struct brcms_pub *pub, const char *name, void *hdl)
 	return -ENODATA;
 }
 
-/* Write WME tunable parameters for retransmit/max rate from wlc struct to ucode */
+/*
+ * Write WME tunable parameters for retransmit/max rate
+ * from wlc struct to ucode
+ */
 static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 {
 	int ac;
@@ -6661,9 +6782,11 @@ void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 		brcmu_pkt_buf_free_skb(sdu);
 	}
 
-	/* Check if flow control needs to be turned on after enqueuing the packet
-	 *   Don't turn on flow control if EDCF is enabled. Driver would make the decision on what
-	 *   to drop instead of relying on stack to make the right decision
+	/*
+	 * Check if flow control needs to be turned on after enqueuing the
+	 * packet. Don't turn on flow control if EDCF is enabled. Driver
+	 * would make the decision on what to drop instead of relying on
+	 * stack to make the right decision
 	 */
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
@@ -6686,7 +6809,10 @@ brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	struct scb *scb = &global_scb;
 	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 
-	/* 802.11 standard requires management traffic to go at highest priority */
+	/*
+	 * 802.11 standard requires management traffic
+	 * to go at highest priority
+	 */
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
@@ -6737,8 +6863,10 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 
 		if (err == -EBUSY) {
 			brcmu_pktq_penq_head(q, prec, pkt[0]);
-			/* If send failed due to any other reason than a change in
-			 * HW FIFO condition, quit. Otherwise, read the new prec_map!
+			/*
+			 * If send failed due to any other reason than a
+			 * change in HW FIFO condition, quit. Otherwise,
+			 * read the new prec_map!
 			 */
 			if (prec_map == wlc->tx_prec_map)
 				break;
@@ -6746,7 +6874,10 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 		}
 	}
 
-	/* Check if flow control needs to be turned off after sending the packet */
+	/*
+	 * Check if flow control needs to be turned off after
+	 * sending the packet
+	 */
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
 		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
@@ -6794,8 +6925,8 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 
 	txh = (struct d11txh *) (p->data);
 
-	/* When a BC/MC frame is being committed to the BCMC fifo via DMA (NOT PIO), update
-	 * ucode or BSS info as appropriate.
+	/* When a BC/MC frame is being committed to the BCMC fifo
+	 * via DMA (NOT PIO), update ucode or BSS info as appropriate.
 	 */
 	if (fifo == TX_BCMC_FIFO)
 		frameid = le16_to_cpu(txh->TxFrameID);
@@ -6804,8 +6935,9 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 		brcms_c_war16165(wlc, true);
 
 
-	/* Bump up pending count for if not using rpc. If rpc is used, this will be handled
-	 * in brcms_b_txfifo()
+	/*
+	 * Bump up pending count for if not using rpc. If rpc is
+	 * used, this will be handled in brcms_b_txfifo()
 	 */
 	if (commit) {
 		TXPKTPENDINC(wlc, fifo, txpktpend);
@@ -6842,9 +6974,9 @@ static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
 	if (RSPEC_IS40MHZ(rspec) || (mcs == 32))
 		plcp[0] |= MIMO_PLCP_40MHZ;
 	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
-	plcp[3] = RSPEC_MIMOPLCP3(rspec);	/* rspec already holds this byte */
-	plcp[3] |= 0x7;		/* set smoothing, not sounding ppdu & reserved */
-	plcp[4] = 0;		/* number of extension spatial streams bit 0 & 1 */
+	plcp[3] = RSPEC_MIMOPLCP3(rspec); /* rspec already holds this byte */
+	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
+	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
 	plcp[5] = 0;
 }
 
@@ -6856,7 +6988,10 @@ brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 	u32 tmp = 0;
 	int rate = RSPEC2RATE(rspec);
 
-	/* encode rate per 802.11a-1999 sec 17.3.4.1, with lsb transmitted first */
+	/*
+	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
+	 * transmitted first
+	 */
 	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
 	memset(plcp, 0, D11_PHY_HDR_LEN);
 	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
@@ -6904,8 +7039,9 @@ static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 		break;
 
 	default:
-		wiphy_err(wlc->wiphy, "brcms_c_cck_plcp_set: unsupported rate %d"
-			  "\n", rate_500);
+		wiphy_err(wlc->wiphy,
+			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
+			  rate_500);
 		rate_500 = BRCM_RATE_1M;
 		usec = length << 3;
 		break;
@@ -7036,8 +7172,11 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
 	} else if (IS_CCK(rspec) && !BRCMS_ISLCNPHY(wlc->band)
 		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
-		/* In CCK mode LPPHY overloads OFDM Modulation bits with CCK Data Rate */
-		/* Eventually MIMOPHY would also be converted to this format */
+		/*
+		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
+		 * Data Rate. Eventually MIMOPHY would also be converted to
+		 * this format
+		 */
 		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
 		phyctl1 = (bw | (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
 	} else {		/* legacy OFDM/CCK */
@@ -7070,8 +7209,9 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 		/* Use 11Mbps as the g protection RTS target rate and fallback.
 		 * Use the BRCMS_BASIC_RATE() lookup to find the best basic rate
 		 * under the target in case 11 Mbps is not Basic.
-		 * 6 and 9 Mbps are not usually selected by rate selection, but even
-		 * if the OFDM rate we are protecting is 6 or 9 Mbps, 11 is more robust.
+		 * 6 and 9 Mbps are not usually selected by rate selection, but
+		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
+		 * is more robust.
 		 */
 		rts_rspec = BRCMS_BASIC_RATE(wlc, BRCM_RATE_11M);
 	else
@@ -7085,8 +7225,9 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 		/* set rts txbw to correct side band */
 		rts_rspec &= ~RSPEC_BW_MASK;
 
-		/* if rspec/rspec_fallback is 40MHz, then send RTS on both 20MHz channel
-		 * (DUP), otherwise send RTS on control channel
+		/*
+		 * if rspec/rspec_fallback is 40MHz, then send RTS on both
+		 * 20MHz channel (DUP), otherwise send RTS on control channel
 		 */
 		if (RSPEC_IS40MHZ(rspec) && !IS_CCK(rts_rspec))
 			rts_rspec |= (PHY_TXC1_BW_40MHZ_DUP << RSPEC_BW_SHIFT);
@@ -7206,7 +7347,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	txrate[0] = tx_info->control.rates;
 	txrate[1] = txrate[0] + 1;
 
-	/* if rate control algorithm didn't give us a fallback rate, use the primary rate */
+	/*
+	 * if rate control algorithm didn't give us a fallback
+	 * rate, use the primary rate
+	 */
 	if (txrate[1]->idx < 0)
 		txrate[1] = txrate[0];
 
@@ -7231,8 +7375,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			rate_val[k] = txrate[k]->idx;
 		}
 
-		/* Currently only support same setting for primay and fallback rates.
-		 * Unify flags for each rate into a single value for the frame
+		/*
+		 * Currently only support same setting for primay and
+		 * fallback rates. Unify flags for each rate into a
+		 * single value for the frame
 		 */
 		use_rts |=
 		    txrate[k]->
@@ -7246,7 +7392,11 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 		rspec[k] = mac80211_wlc_set_nrate(wlc, wlc->band, rate_val[k]);
 
-		/* (1) RATE: determine and validate primary rate and fallback rates */
+		/*
+		 * (1) RATE:
+		 *   determine and validate primary rate
+		 *   and fallback rates
+		 */
 		if (!RSPEC_ACTIVE(rspec[k])) {
 			rspec[k] = BRCM_RATE_1M;
 		} else {
@@ -7262,7 +7412,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 	if (N_ENAB(wlc->pub)) {
 		for (k = 0; k < hw->max_rates; k++) {
-			/* apply siso/cdd to single stream mcs's or ofdm if rspec is auto selected */
+			/*
+			 * apply siso/cdd to single stream mcs's or ofdm
+			 * if rspec is auto selected
+			 */
 			if (((IS_MCS(rspec[k]) &&
 			      IS_SINGLE_STREAM(rspec[k] & RSPEC_RATE_MASK)) ||
 			     IS_OFDM(rspec[k]))
@@ -7275,17 +7428,20 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				    && BRCMS_STF_SS_STBC_TX(wlc, scb)) {
 					u8 stc;
 
-					stc = 1;	/* Nss for single stream is always 1 */
-					rspec[k] |=
-					    (PHY_TXC1_MODE_STBC <<
-					     RSPEC_STF_SHIFT) | (stc <<
-								 RSPEC_STC_SHIFT);
+					/* Nss for single stream is always 1 */
+					stc = 1;
+					rspec[k] |= (PHY_TXC1_MODE_STBC <<
+							RSPEC_STF_SHIFT) |
+						    (stc << RSPEC_STC_SHIFT);
 				} else
 					rspec[k] |=
 					    (phyctl1_stf << RSPEC_STF_SHIFT);
 			}
 
-			/* Is the phy configured to use 40MHZ frames? If so then pick the desired txbw */
+			/*
+			 * Is the phy configured to use 40MHZ frames? If
+			 * so then pick the desired txbw
+			 */
 			if (CHSPEC_WLC_BW(wlc->chanspec) == BRCMS_40_MHZ) {
 				/* default txbw is 20in40 SB */
 				mimo_ctlchbw = mimo_txbw =
@@ -7294,7 +7450,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 				if (IS_MCS(rspec[k])) {
 					/* mcs 32 must be 40b/w DUP */
-					if ((rspec[k] & RSPEC_RATE_MASK) == 32) {
+					if ((rspec[k] & RSPEC_RATE_MASK)
+					    == 32) {
 						mimo_txbw =
 						    PHY_TXC1_BW_40MHZ_DUP;
 						/* use override */
@@ -7310,8 +7467,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 					mimo_txbw = wlc->cck_40txbw;
 				}
 			} else {
-				/* mcs32 is 40 b/w only.
-				 * This is possible for probe packets on a STA during SCAN
+				/*
+				 * mcs32 is 40 b/w only.
+				 * This is possible for probe packets on
+				 * a STA during SCAN
 				 */
 				if ((rspec[k] & RSPEC_RATE_MASK) == 32)
 					/* mcs 0 */
@@ -7352,7 +7511,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			if (IS_MCS(rspec[k])) {
 				preamble_type[k] = mimo_preamble_type;
 
-				/* if SGI is selected, then forced mm for single stream */
+				/*
+				 * if SGI is selected, then forced mm
+				 * for single stream
+				 */
 				if ((rspec[k] & RSPEC_SHORT_GI)
 				    && IS_SINGLE_STREAM(rspec[k] &
 							RSPEC_RATE_MASK))
@@ -7476,12 +7638,14 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	/* TxFrameID */
 	txh->TxFrameID = cpu_to_le16(frameid);
 
-	/* TxStatus, Note the case of recreating the first frag of a suppressed frame
-	 * then we may need to reset the retry cnt's via the status reg
+	/*
+	 * TxStatus, Note the case of recreating the first frag of a suppressed
+	 * frame then we may need to reset the retry cnt's via the status reg
 	 */
 	txh->TxStatus = cpu_to_le16(status);
 
-	/* extra fields for ucode AMPDU aggregation, the new fields are added to
+	/*
+	 * extra fields for ucode AMPDU aggregation, the new fields are added to
 	 * the END of previous structure so that it's compatible in driver.
 	 */
 	txh->MaxNMpdus = cpu_to_le16(0);
@@ -7590,10 +7754,16 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 #endif
 
-	/* Now that RTS/RTS FB preamble types are updated, write the final value */
+	/*
+	 * Now that RTS/RTS FB preamble types are updated, write
+	 * the final value
+	 */
 	txh->MacTxControlHigh = cpu_to_le16(mch);
 
-	/* MainRates (both the rts and frag plcp rates have been calculated now) */
+	/*
+	 * MainRates (both the rts and frag plcp rates have
+	 * been calculated now)
+	 */
 	txh->MainRates = cpu_to_le16(mainrates);
 
 	/* XtraFrameTypes */
@@ -7633,9 +7803,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		}
 
 		/*
-		 * For mcs frames, if mixedmode(overloaded with long preamble) is going to be set,
-		 * fill in non-zero MModeLen and/or MModeFbrLen
-		 *  it will be unnecessary if they are separated
+		 * For mcs frames, if mixedmode(overloaded with long preamble)
+		 * is going to be set, fill in non-zero MModeLen and/or
+		 * MModeFbrLen it will be unnecessary if they are separated
 		 */
 		if (IS_MCS(rspec[0]) &&
 		    (preamble_type[0] == BRCMS_MM_PREAMBLE)) {
@@ -7657,7 +7827,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		uint frag_dur, dur, dur_fallback;
 
 		/* WME: Update TXOP threshold */
-		if ((!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) && (frag == 0)) {
+		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU) && frag == 0) {
 			frag_dur =
 			    brcms_c_calc_frame_time(wlc, rspec[0],
 					preamble_type[0], phylen);
@@ -7694,11 +7864,17 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			}
 			/* NEED to set TxFesTimeNormal (hard) */
 			txh->TxFesTimeNormal = cpu_to_le16((u16) dur);
-			/* NEED to set fallback rate version of TxFesTimeNormal (hard) */
+			/*
+			 * NEED to set fallback rate version of
+			 * TxFesTimeNormal (hard)
+			 */
 			txh->TxFesTimeFallback =
 				cpu_to_le16((u16) dur_fallback);
 
-			/* update txop byte threshold (txop minus intraframe overhead) */
+			/*
+			 * update txop byte threshold (txop minus intraframe
+			 * overhead)
+			 */
 			if (wlc->edcf_txop[ac] >= (dur - frag_dur)) {
 				uint newfragthresh;
 
@@ -7745,7 +7921,10 @@ void brcms_c_tbtt(struct brcms_c_info *wlc)
 	struct brcms_bss_cfg *cfg = wlc->cfg;
 
 	if (!cfg->BSS)
-		/* DirFrmQ is now valid...defer setting until end of ATIM window */
+		/*
+		 * DirFrmQ is now valid...defer setting until end
+		 * of ATIM window
+		 */
 		wlc->qvalid |= MCMD_DIRFRMQVAL;
 }
 
@@ -7780,12 +7959,13 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 	struct ieee80211_tx_rate *txrate;
 	int i;
 
-	(void)(frm_tx2);	/* Compiler reference to avoid unused variable warning */
+	/* Compiler reference to avoid unused variable warning */
+	(void)(frm_tx2);
 
 	/* discard intermediate indications for ucode with one legitimate case:
-	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
-	 *   tx of DATA failed. so it will start rts/cts from the beginning (resetting the rts
-	 *   transmission count)
+	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
+	 *   but the subsequent tx of DATA failed. so it will start rts/cts
+	 *   from the beginning (resetting the rts transmission count)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
@@ -7877,13 +8057,22 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 		ieee80211_tx_info_clear_status(tx_info);
 
 		if ((tx_frame_count > fbl) && (txrate[1].idx >= 0)) {
-			/* rate selection requested a fallback rate and we used it */
+			/*
+			 * rate selection requested a fallback rate
+			 * and we used it
+			 */
 			txrate[0].count = fbl;
 			txrate[1].count = tx_frame_count - fbl;
 		} else {
-			/* rate selection did not request fallback rate, or we didn't need it */
+			/*
+			 * rate selection did not request fallback rate, or
+			 * we didn't need it
+			 */
 			txrate[0].count = tx_frame_count;
-			/* rc80211_minstrel.c:minstrel_tx_status() expects unused rates to be marked with idx = -1 */
+			/*
+			 * rc80211_minstrel.c:minstrel_tx_status() expects
+			 * unused rates to be marked with idx = -1
+			 */
 			txrate[1].idx = -1;
 			txrate[1].count = 0;
 		}
@@ -8035,11 +8224,12 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		rx_status->freq = ieee80211_dsss_chan_to_freq(channel);
 	}
 
-	rx_status->signal = wlc_rxh->rssi;	/* signal */
+	rx_status->signal = wlc_rxh->rssi;
 
 	/* noise */
 	/* qual */
-	rx_status->antenna = (rxh->PhyRxStatus_0 & PRXS0_RXANT_UPSUBBAND) ? 1 : 0;	/* ant */
+	rx_status->antenna =
+		(rxh->PhyRxStatus_0 & PRXS0_RXANT_UPSUBBAND) ? 1 : 0;
 
 	plcp = p->data;
 
@@ -8253,14 +8443,16 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 		/* MCS_TXS(mcs) returns num tx streams - 1 */
 		int tot_streams = (MCS_TXS(mcs) + 1) + RSPEC_STC(ratespec);
 
-		/* the payload duration calculation matches that of regular ofdm */
+		/*
+		 * the payload duration calculation matches that
+		 * of regular ofdm
+		 */
 		/* 1000Ndbps = kbps * 4 */
 		kNdps =
 		    MCS_RATE(mcs, RSPEC_IS40MHZ(ratespec),
 			     RSPEC_ISSGI(ratespec)) * 4;
 
 		if (RSPEC_STC(ratespec) == 0)
-			/* NSyms = CEILING((SERVICE + 8*NBytes + TAIL) / Ndbps) */
 			nsyms =
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
 				  APHY_TAIL_NBITS) * 1000, kNdps);
@@ -8271,15 +8463,22 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
 				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
 
-		nsyms += (tot_streams + 3);	/* (+3) account for HT-SIG(2) and HT-STF(1) */
-		/* 3 bytes/symbol @ legacy 6Mbps rate */
-		len = (3 * nsyms) - 3;	/* (-3) excluding service bits and tail bits */
+		/* (+3) account for HT-SIG(2) and HT-STF(1) */
+		nsyms += (tot_streams + 3);
+		/*
+		 * 3 bytes/symbol @ legacy 6Mbps rate
+		 * (-3) excluding service bits and tail bits
+		 */
+		len = (3 * nsyms) - 3;
 	}
 
 	return (u16) len;
 }
 
-/* calculate frame duration of a given rate and length, return time in usec unit */
+/*
+ * calculate frame duration of a given rate and length, return
+ * time in usec unit
+ */
 uint
 brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 			u8 preamble_type, uint mac_len)
@@ -8309,7 +8508,6 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 			     RSPEC_ISSGI(ratespec)) * 4;
 
 		if (RSPEC_STC(ratespec) == 0)
-			/* NSyms = CEILING((SERVICE + 8*NBytes + TAIL) / Ndbps) */
 			nsyms =
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
 				  APHY_TAIL_NBITS) * 1000, kNdps);
@@ -8336,7 +8534,10 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		if (BAND_2G(wlc->band->bandtype))
 			dur += DOT11_OFDM_SIGNAL_EXTENSION;
 	} else {
-		/* calc # bits * 2 so factor of 2 in rate (1/2 mbps) will divide out */
+		/*
+		 * calc # bits * 2 so factor of 2 in rate (1/2 mbps)
+		 * will divide out
+		 */
 		mac_len = mac_len * 8 * 2;
 		/* calc ceiling of bits/rate = microseconds of air time */
 		dur = (mac_len + rate - 1) / rate;
@@ -8401,8 +8602,10 @@ brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 {
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
 		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
-	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
-	 * or equal to the rate of the immediately previous frame in the FES
+	/*
+	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
+	 * is less than or equal to the rate of the immediately previous
+	 * frame in the FES
 	 */
 	rspec = BRCMS_BASIC_RATE(wlc, rspec);
 	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
@@ -8419,8 +8622,10 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d\n",
 		wlc->pub->unit, rspec, preamble_type);
-	/* Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that is less than
-	 * or equal to the rate of the immediately previous frame in the FES
+	/*
+	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
+	 * is less than or equal to the rate of the immediately previous
+	 * frame in the FES
 	 */
 	rspec = BRCMS_BASIC_RATE(wlc, rspec);
 	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
@@ -8515,7 +8720,10 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 			continue;
 
 		if (IS_OFDM(rate)) {
-			/* In 11g and 11a, the OFDM mandatory rates are 6, 12, and 24 Mbps */
+			/*
+			 * In 11g and 11a, the OFDM mandatory rates
+			 * are 6, 12, and 24 Mbps
+			 */
 			if (rate >= BRCM_RATE_24M)
 				mandatory = BRCM_RATE_24M;
 			else if (rate >= BRCM_RATE_12M)
@@ -8523,7 +8731,7 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 			else
 				mandatory = BRCM_RATE_6M;
 		} else {
-			/* In 11b, all the CCK rates are mandatory 1 - 11 Mbps */
+			/* In 11b, all CCK rates are mandatory 1 - 11 Mbps */
 			mandatory = rate;
 		}
 
@@ -8691,7 +8899,10 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 	brcms_c_rateset_copy(rs_dflt, &rs);
 	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
 
-	/* walk the phy rate table and update MAC core SHM basic rate table entries */
+	/*
+	 * walk the phy rate table and update MAC core SHM
+	 * basic rate table entries
+	 */
 	for (i = 0; i < rs.count; i++) {
 		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
@@ -8700,7 +8911,10 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 		/* Calculate the Probe Response PLCP for the given rate */
 		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
 
-		/* Calculate the duration of the Probe Response frame plus SIFS for the MAC */
+		/*
+		 * Calculate the duration of the Probe Response
+		 * frame plus SIFS for the MAC
+		 */
 		dur = (u16) brcms_c_calc_frame_time(wlc, rate,
 						BRCMS_LONG_PREAMBLE, frame_len);
 		dur += sifs;
@@ -8723,8 +8937,8 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
  *
  *      *len on input contains the max length of the packet available.
  *
- *	The *len value is set to the number of bytes in buf used, and starts with the PLCP
- *	and included up to, but not including, the 4 byte FCS.
+ *	The *len value is set to the number of bytes in buf used, and starts
+ *	with the PLCP and included up to, but not including, the 4 byte FCS.
  */
 static void
 brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
@@ -8740,16 +8954,21 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 		hdr_len = DOT11_MAC_HDR_LEN;
 	else
 		hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
-	body_len = *len - hdr_len;	/* calc buffer size provided for frame body */
 
-	*len = hdr_len + body_len;	/* return actual size */
+	/* calc buffer size provided for frame body */
+	body_len = *len - hdr_len;
+	/* return actual size */
+	*len = hdr_len + body_len;
 
 	/* format PHY and MAC headers */
 	memset((char *)buf, 0, hdr_len);
 
 	plcp = (struct cck_phy_hdr *) buf;
 
-	/* PLCP for Probe Response frames are filled in from core's rate table */
+	/*
+	 * PLCP for Probe Response frames are filled in from
+	 * core's rate table
+	 */
 	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg))
 		/* fill in PLCP */
 		brcms_c_compute_plcp(wlc, bcn_rspec,
@@ -8807,10 +9026,11 @@ brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
 	}
 }
 
-/* Update a beacon for a particular BSS
- * For MBSS, this updates the software template and sets "latest" to the index of the
- * template updated.
- * Otherwise, it updates the hardware template.
+/*
+ * Update a beacon for a particular BSS
+ * For MBSS, this updates the software template and sets "latest" to
+ * the index of the template updated. Otherwise, it updates the hardware
+ * template.
  */
 void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 			       struct brcms_bss_cfg *cfg)
@@ -8907,7 +9127,10 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 	u16 prb_resp[BCN_TMPL_LEN / 2];
 	int len = BCN_TMPL_LEN;
 
-	/* write the probe response to hardware, or save in the config structure */
+	/*
+	 * write the probe response to hardware, or save in
+	 * the config structure
+	 */
 	if (!MBSS_PRB_ENAB(cfg)) {
 
 		/* create the probe response template */
@@ -8928,17 +9151,18 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 		brcms_c_shm_ssid_upd(wlc, cfg);
 
 		/*
-		 * Write PLCP headers and durations for probe response frames at all rates.
-		 * Use the actual frame length covered by the PLCP header for the call to
-		 * brcms_c_mod_prb_rsp_rate_table() by subtracting the PLCP len
-		 * and adding the FCS.
+		 * Write PLCP headers and durations for probe response frames
+		 * at all rates. Use the actual frame length covered by the
+		 * PLCP header for the call to brcms_c_mod_prb_rsp_rate_table()
+		 * by subtracting the PLCP len and adding the FCS.
 		 */
 		len += (-D11_PHY_HDR_LEN + FCS_LEN);
 		brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
 
 		if (suspend)
 			brcms_c_enable_mac(wlc);
-	} else {		/* Generating probe resp in sw; update local template */
+	} else {
+		/* Generating probe resp in sw; update local template */
 		/* error: No software probe response support without MBSS */
 	}
 }
@@ -9076,7 +9300,10 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
-			/* MCS 0-7 may use SISO, CDD, and for phy_rev >= 3 STBC */
+			/*
+			 * MCS 0-7 may use SISO, CDD, and for
+			 * phy_rev >= 3 STBC
+			 */
 			if ((stf > PHY_TXC1_MODE_STBC) ||
 			    (!BRCMS_STBC_CAP_PHY(wlc)
 			     && (stf == PHY_TXC1_MODE_STBC))) {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index e797bf0..0fd061b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -49,8 +49,7 @@
 /* uS: 83mS is max packet time (64KB ampdu @ 6Mbps) */
 #define	BRCMS_MAX_MAC_SUSPEND	83000
 
-/* Probe Response timeout - responses for probe requests older that this are tossed, zero to disable
- */
+/* responses for probe requests older that this are tossed, zero to disable */
 #define BRCMS_PRB_RESP_TIMEOUT	0	/* Disable probe response timeout */
 
 /* transmit buffer max headroom for protocol headers */
@@ -123,7 +122,9 @@
 #define BOARDREV_PROMOTABLE	0xFF	/* from */
 #define BOARDREV_PROMOTED	1	/* to */
 
-/* if wpa is in use then portopen is true when the group key is plumbed otherwise it is always true
+/*
+ * if wpa is in use then portopen is true when the
+ * group key is plumbed otherwise it is always true
  */
 #define WSEC_ENABLED(wsec) ((wsec) & (WEP_ENABLED | TKIP_ENABLED | AES_ENABLED))
 #define BRCMS_SW_KEYS(wlc, bsscfg) ((((wlc)->wsec_swkeys) || \
@@ -163,13 +164,13 @@ extern const u8 prio2fifo[];
 #define	RETRY_SHORT_DEF			7	/* Default Short retry Limit */
 #define	RETRY_SHORT_MAX			255	/* Maximum Short retry Limit */
 #define	RETRY_LONG_DEF			4	/* Default Long retry count */
-#define	RETRY_SHORT_FB			3	/* Short retry count for fallback rate */
-#define	RETRY_LONG_FB			2	/* Long retry count for fallback rate */
+#define	RETRY_SHORT_FB			3 /* Short count for fallback rate */
+#define	RETRY_LONG_FB			2 /* Long count for fallback rate */
 
 #define	MAXTXPKTS		6	/* max # pkts pending */
 
 /* frameburst */
-#define	MAXTXFRAMEBURST		8	/* vanilla xpress mode: max frames/burst */
+#define	MAXTXFRAMEBURST		8 /* vanilla xpress mode: max frames/burst */
 #define	MAXFRAMEBURST_TXOP	10000	/* Frameburst TXOP in usec */
 
 /* Per-AC retry limit register definitions; uses defs.h bitfield macros */
@@ -228,11 +229,12 @@ extern const u8 prio2fifo[];
 
 /*
  * Detect Card removed.
- * Even checking an sbconfig register read will not false trigger when the core is in reset.
- * it breaks CF address mechanism. Accessing gphy phyversion will cause SB error if aphy
- * is in reset on 4306B0-DB. Need a simple accessible reg with fixed 0/1 pattern
- * (some platforms return all 0).
- * If clocks are present, call the sb routine which will figure out if the device is removed.
+ * Even checking an sbconfig register read will not false trigger when the core
+ * is in reset it breaks CF address mechanism. Accessing gphy phyversion will
+ * cause SB error if aphy is in reset on 4306B0-DB. Need a simple accessible
+ * reg with fixed 0/1 pattern (some platforms return all 0).
+ * If clocks are present, call the sb routine which will figure out if the
+ * device is removed.
  */
 #define DEVICEREMOVED(wlc)      \
 	((wlc->hw->clk) ?   \
@@ -248,52 +250,81 @@ extern const u8 prio2fifo[];
 #define brcms_b_copyto_shm(wlc_hw, offset, buf, len)                   \
 	brcms_b_copyto_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
 
+/*
+ * 802.11 protection information
+ *
+ * _g: use g spec protection, driver internal.
+ * g_override: override for use of g spec protection.
+ * gmode_user: user config gmode, operating band->gmode is different.
+ * overlap: Overlap BSS/IBSS protection for both 11g and 11n.
+ * nmode_user: user config nmode, operating pub->nmode is different.
+ * n_cfg: use OFDM protection on MIMO frames.
+ * n_cfg_override: override for use of N protection.
+ * nongf: non-GF present protection.
+ * nongf_override: override for use of GF protection.
+ * n_pam_override: override for preamble: MM or GF.
+ * n_obss: indicated OBSS Non-HT STA present.
+*/
 struct brcms_protection {
-	bool _g;		/* use g spec protection, driver internal */
-	s8 g_override;	/* override for use of g spec protection */
-	u8 gmode_user;	/* user config gmode, operating band->gmode is different */
-	s8 overlap;		/* Overlap BSS/IBSS protection for both 11g and 11n */
-	s8 nmode_user;	/* user config nmode, operating pub->nmode is different */
-	s8 n_cfg;		/* use OFDM protection on MIMO frames */
-	s8 n_cfg_override;	/* override for use of N protection */
-	bool nongf;		/* non-GF present protection */
-	s8 nongf_override;	/* override for use of GF protection */
-	s8 n_pam_override;	/* override for preamble: MM or GF */
-	bool n_obss;		/* indicated OBSS Non-HT STA present */
+	bool _g;
+	s8 g_override;
+	u8 gmode_user;
+	s8 overlap;
+	s8 nmode_user;
+	s8 n_cfg;
+	s8 n_cfg_override;
+	bool nongf;
+	s8 nongf_override;
+	s8 n_pam_override;
+	bool n_obss;
 };
 
-/* anything affects the single/dual streams/antenna operation */
+/*
+ * anything affecting the single/dual streams/antenna operation
+ *
+ * hw_txchain: HW txchain bitmap cfg.
+ * txchain: txchain bitmap being used.
+ * txstreams: number of txchains being used.
+ * hw_rxchain: HW rxchain bitmap cfg.
+ * rxchain: rxchain bitmap being used.
+ * rxstreams: number of rxchains being used.
+ * ant_rx_ovr: rx antenna override.
+ * txant: userTx antenna setting.
+ * phytxant: phyTx antenna setting in txheader.
+ * ss_opmode: singlestream Operational mode, 0:siso; 1:cdd.
+ * ss_algosel_auto: if true, use wlc->stf->ss_algo_channel;
+ *			else use wlc->band->stf->ss_mode_band.
+ * ss_algo_channel: ss based on per-channel algo: 0: SISO, 1: CDD 2: STBC.
+ * no_cddstbc: stf override, 1: no CDD (or STBC) allowed.
+ * rxchain_restore_delay: delay time to restore default rxchain.
+ * ldpc: AUTO/ON/OFF ldpc cap supported.
+ * txcore[MAX_STREAMS_SUPPORTED + 1]: bitmap of selected core for each Nsts.
+ * spatial_policy:
+ */
 struct brcms_stf {
-	u8 hw_txchain;	/* HW txchain bitmap cfg */
-	u8 txchain;		/* txchain bitmap being used */
-	u8 txstreams;	/* number of txchains being used */
-
-	u8 hw_rxchain;	/* HW rxchain bitmap cfg */
-	u8 rxchain;		/* rxchain bitmap being used */
-	u8 rxstreams;	/* number of rxchains being used */
-
-	u8 ant_rx_ovr;	/* rx antenna override */
-	s8 txant;		/* userTx antenna setting */
-	u16 phytxant;	/* phyTx antenna setting in txheader */
-
-	u8 ss_opmode;	/* singlestream Operational mode, 0:siso; 1:cdd */
-	bool ss_algosel_auto;	/* if true, use wlc->stf->ss_algo_channel; */
-	/* else use wlc->band->stf->ss_mode_band; */
-	u16 ss_algo_channel;	/* ss based on per-channel algo: 0: SISO, 1: CDD 2: STBC */
-	u8 no_cddstbc;	/* stf override, 1: no CDD (or STBC) allowed */
-
-	u8 rxchain_restore_delay;	/* delay time to restore default rxchain */
-
-	s8 ldpc;		/* AUTO/ON/OFF ldpc cap supported */
-	u8 txcore[MAX_STREAMS_SUPPORTED + 1];	/* bitmap of selected core for each Nsts */
+	u8 hw_txchain;
+	u8 txchain;
+	u8 txstreams;
+	u8 hw_rxchain;
+	u8 rxchain;
+	u8 rxstreams;
+	u8 ant_rx_ovr;
+	s8 txant;
+	u16 phytxant;
+	u8 ss_opmode;
+	bool ss_algosel_auto;
+	u16 ss_algo_channel;
+	u8 no_cddstbc;
+	u8 rxchain_restore_delay;
+	s8 ldpc;
+	u8 txcore[MAX_STREAMS_SUPPORTED + 1];
 	s8 spatial_policy;
 };
 
 #define BRCMS_STF_SS_STBC_TX(wlc, scb) \
-	(((wlc)->stf->txstreams > 1) && (((wlc)->band->band_stf_stbc_tx == ON) || \
-	 (SCB_STBC_CAP((scb)) &&					\
-	  (wlc)->band->band_stf_stbc_tx == AUTO &&			\
-	  isset(&((wlc)->stf->ss_algo_channel), PHY_TXC1_MODE_STBC))))
+	(((wlc)->stf->txstreams > 1) && (((wlc)->band->band_stf_stbc_tx == ON) \
+	 || (SCB_STBC_CAP((scb)) && (wlc)->band->band_stf_stbc_tx == AUTO && \
+	     isset(&((wlc)->stf->ss_algo_channel), PHY_TXC1_MODE_STBC))))
 
 #define BRCMS_STBC_CAP_PHY(wlc) (BRCMS_ISNPHY(wlc->band) && \
 				 NREV_GE(wlc->band->phyrev, 3))
@@ -312,9 +343,12 @@ struct brcms_stf {
 #define BRCMS_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
 
 /* Flags used in brcms_c_txq_info.stopped */
-#define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF	/* per prio flow control bits */
-#define TXQ_STOP_FOR_PKT_DRAIN		0x00000100	/* stop txq enqueue for packet drain */
-#define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200	/* stop txq enqueue for ampdu flow control */
+/* per prio flow control bits */
+#define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF
+/* stop txq enqueue for packet drain */
+#define TXQ_STOP_FOR_PKT_DRAIN		0x00000100
+/* stop txq enqueue for ampdu flow control */
+#define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200
 
 #define BRCMS_HT_WEP_RESTRICT	0x01	/* restrict HT with WEP */
 #define BRCMS_HT_TKIP_RESTRICT	0x02	/* restrict HT with TKIP */
@@ -322,8 +356,8 @@ struct brcms_stf {
 /* Maximum # of keys that wl driver supports in S/W.
  * Keys supported in H/W is less than or equal to WSEC_MAX_KEYS.
  */
-#define WSEC_MAX_KEYS		54	/* Max # of keys (50 + 4 default keys) */
-#define BRCMS_DEFAULT_KEYS	4	/* Default # of keys */
+#define WSEC_MAX_KEYS		54 /* Max # of keys (50 + 4 default keys) */
+#define BRCMS_DEFAULT_KEYS	4 /* Default # of keys */
 
 /*
 * Max # of keys currently supported:
@@ -347,14 +381,14 @@ struct wsec_key {
 	u8 ea[ETH_ALEN];	/* per station */
 	u8 idx;		/* key index in wsec_keys array */
 	u8 id;		/* key ID [0-3] */
-	u8 algo;		/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
-	u8 rcmta;		/* rcmta entry index, same as idx by default */
-	u16 flags;		/* misc flags */
-	u8 algo_hw;		/* cache for hw register */
-	u8 aes_mode;		/* cache for hw register */
-	s8 iv_len;		/* IV length */
-	s8 icv_len;		/* ICV length */
-	u32 len;		/* key length..don't move this var */
+	u8 algo;	/* CRYPTO_ALGO_AES_CCM, CRYPTO_ALGO_WEP128, etc */
+	u8 rcmta;	/* rcmta entry index, same as idx by default */
+	u16 flags;	/* misc flags */
+	u8 algo_hw;	/* cache for hw register */
+	u8 aes_mode;	/* cache for hw register */
+	s8 iv_len;	/* IV length */
+	s8 icv_len;	/* ICV length */
+	u32 len;	/* key length..don't move this var */
 	/* data is 4byte aligned */
 	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
 	struct wsec_iv rxiv[BRCMS_NUMRXIVS];	/* Rx IV (one per TID) */
@@ -405,8 +439,8 @@ struct brcms_band {
 	bool mimo_cap_40;	/* 40 MHz cap enabled on this band */
 	s8 antgain;		/* antenna gain from srom */
 
-	u16 CWmin;		/* The minimum size of contention window, in unit of aSlotTime */
-	u16 CWmax;		/* The maximum size of contention window, in unit of aSlotTime */
+	u16 CWmin; /* minimum size of contention window, in unit of aSlotTime */
+	u16 CWmax; /* maximum size of contention window, in unit of aSlotTime */
 	u16 bcntsfoff;	/* beacon tsf offset */
 };
 
@@ -422,10 +456,14 @@ struct pkt_cb {
 
 /* module control blocks */
 struct modulecb {
-	char name[32];		/* module name : NULL indicates empty array member */
-	const struct brcmu_iovar *iovars;	/* iovar table */
-	void *hdl;		/* handle passed when handler 'doiovar' is called */
-	int (*watchdog_fn)(void *handle);	/* watchdog handler */
+	/* module name : NULL indicates empty array member */
+	char name[32];
+	/* iovar table */
+	const struct brcmu_iovar *iovars;
+	/* handle passed when handler 'doiovar' is called */
+	void *hdl;
+	/* watchdog handler */
+	int (*watchdog_fn)(void *handle);
 
 	/* IOVar handler
 	 *
@@ -483,11 +521,11 @@ struct wme_param_ie {
 /* virtual interface */
 struct brcms_c_if {
 	struct brcms_c_if *next;
-	u8 type;		/* BSS or WDS */
-	u8 index;		/* assigned in wl_add_if(), index of the wlif if any,
-				 * not necessarily corresponding to bsscfg._idx or
-				 * AID2PVBMAP(scb).
-				 */
+	u8 type;	/* BSS or WDS */
+	u8 index;	/* assigned in wl_add_if(), index of the wlif if any,
+			 * not necessarily corresponding to bsscfg._idx or
+			 * AID2PVBMAP(scb).
+			 */
 	u8 flags;		/* flags for the interface */
 	struct brcms_if *wlif;		/* pointer to wlif */
 	struct brcms_txq_info *qi;	/* pointer to associated tx queue */
@@ -569,12 +607,12 @@ struct brcms_hardware {
 	u8 suspended_fifos;	/* Which TX fifo to remain awake for */
 	u32 maccontrol;	/* Cached value of maccontrol */
 	uint mac_suspend_depth;	/* current depth of mac_suspend levels */
-	u32 wake_override;	/* Various conditions to force MAC to WAKE mode */
+	u32 wake_override;	/* bit flags to force MAC to WAKE mode */
 	u32 mute_override;	/* Prevent ucode from sending beacons */
 	u8 etheraddr[ETH_ALEN];	/* currently configured ethernet address */
 	u32 led_gpio_mask;	/* LED GPIO Mask */
 	bool noreset;		/* true= do not reset hw, used by WLC_OUT */
-	bool forcefastclk;	/* true if the h/w is forcing the use of fast clk */
+	bool forcefastclk;	/* true if h/w is forcing to use fast clk */
 	bool clk;		/* core is out of reset and has clock */
 	bool sbclk;		/* sb has clock */
 	struct bmac_pmq *bmac_pmq; /*  bmac PM states derived from ucode PMQ */
@@ -608,192 +646,267 @@ struct brcms_txq_info {
 };
 
 /*
- * Principal common (os-independent) software data structure.
+ * Principal common driver data structure.
+ *
+ * pub: pointer to driver public state.
+ * wl: pointer to specific private state.
+ * regs: pointer to device registers.
+ * hw: HW related state.
+ * clkreq_override: setting for clkreq for PCIE : Auto, 0, 1.
+ * fastpwrup_dly: time in us needed to bring up d11 fast clock.
+ * macintstatus: bit channel between isr and dpc.
+ * macintmask: sw runtime master macintmask value.
+ * defmacintmask: default "on" macintmask value.
+ * device_present: (removable) device is present.
+ * clk: core is out of reset and has clock.
+ * core: pointer to active io core.
+ * band: pointer to active per-band state.
+ * corestate: per-core state (one per hw core).
+ * bandstate: per-band state (one per phy/radio).
+ * war16165: PCI slow clock 16165 war flag.
+ * tx_suspended: data fifos need to remain suspended.
+ * txpend16165war: PCI slow clock 16165 war flag.
+ * qvalid: DirFrmQValid and BcMcFrmQValid.
+ * txpwr_local_max: regulatory local txpwr max.
+ * txpwr_local_constraint: local power contraint in dB.
+ * ampdu: ampdu module handler.
+ * asi: antsel module handler.
+ * cmi: channel manager module handler.
+ * vars_size: size of vars, free vars on detach.
+ * vendorid: PCI vendor id.
+ * deviceid: PCI device id.
+ * ucode_rev: microcode revision.
+ * machwcap: MAC capabilities, BMAC shadow.
+ * perm_etheraddr: original sprom local ethernet address.
+ * bandlocked: disable auto multi-band switching.
+ * bandinit_pending: track band init in auto band.
+ * radio_monitor: radio timer is running.
+ * going_down: down path intermediate variable.
+ * mpc: enable minimum power consumption.
+ * mpc_dlycnt: # of watchdog cnt before turn disable radio.
+ * mpc_offcnt: # of watchdog cnt that radio is disabled.
+ * mpc_delay_off: delay radio disable by # of watchdog cnt.
+ * prev_non_delay_mpc: prev state brcms_c_is_non_delay_mpc.
+ * wdtimer: timer for watchdog routine.
+ * radio_timer: timer for hw radio button monitor routine.
+ * monitor: monitor (MPDU sniffing) mode.
+ * bcnmisc_ibss: bcns promisc mode override for IBSS.
+ * bcnmisc_scan: bcns promisc mode override for scan.
+ * bcnmisc_monitor: bcns promisc mode override for monitor.
+ * _rifs: enable per-packet rifs.
+ * sgi_tx: sgi tx.
+ * bcn_li_bcn: beacon listen interval in # beacons.
+ * bcn_li_dtim: beacon listen interval in # dtims.
+ * WDarmed: watchdog timer is armed.
+ * WDlast: last time wlc_watchdog() was called.
+ * wme_dp: AC bitmap. Discard (oldest first) policy per AC.
+ * edcf_txop[AC_COUNT]: current txop for each ac.
+ * wme_param_ie: on STA contains parameters in use locally, and on AP
+ *		 contains parameters advertised
+ * wme_retries: per-AC retry limits.
+ * tx_prec_map: Precedence map based on HW FIFO space.
+ * fifo2prec_map[NFIFO]: pointer to fifo2_prec map based on WME.
+ * bsscfg: set of BSS configurations, idx 0 is default and always valid.
+ * cfg: the primary bsscfg (can be AP or STA).
+ * tx_queues: common TX Queue list.
+ * wsec_keys[WSEC_MAX_KEYS]: dynamic key storage.
+ * wsec_def_keys[BRCMS_DEFAULT_KEYS]: default key storage.
+ * wsec_swkeys: indicates that all keys should be treated as
+ *		sw keys (used for debugging).
+ * modulecb:
+ * mimoft: SIGN or 11N.
+ * cck_40txbw: 11N, cck tx b/w override when in 40MHZ mode.
+ * ofdm_40txbw: 11N, ofdm tx b/w override when in 40MHZ mode.
+ * mimo_40txbw: 11N, mimo tx b/w override when in 40MHZ mode.
+ * ht_cap: HT CAP IE being advertised by this node.
+ * default_bss: configured BSS parameters.
+ * mc_fid_counter: BC/MC FIFO frame ID counter.
+ * country_default: saved country for leaving 802.11d auto-country mode.
+ * autocountry_default: initial country for 802.11d auto-country mode.
+ * prb_resp_timeout: do not send prb resp if request older
+ *		     than this, 0 = disable.
+ * sup_rates_override: use only these rates in 11g supported rates if specified.
+ * home_chanspec: shared home chanspec.
+ * chanspec: target operational channel.
+ * usr_fragthresh: user configured fragmentation threshold.
+ * fragthresh[NFIFO]: per-fifo fragmentation thresholds.
+ * RTSThresh: 802.11 dot11RTSThreshold.
+ * SRL: 802.11 dot11ShortRetryLimit.
+ * LRL: 802.11 dot11LongRetryLimit.
+ * SFBL: Short Frame Rate Fallback Limit.
+ * LFBL: Long Frame Rate Fallback Limit.
+ * shortslot: currently using 11g ShortSlot timing.
+ * shortslot_override: 11g ShortSlot override.
+ * include_legacy_erp: include Legacy ERP info elt ID 47 as well as g ID 42.
+ * PLCPHdr_override: 802.11b Preamble Type override.
+ * stf:
+ * bcn_rspec: save bcn ratespec purpose.
+ * tempsense_lasttime;
+ * tx_duty_cycle_ofdm: maximum allowed duty cycle for OFDM.
+ * tx_duty_cycle_cck: maximum allowed duty cycle for CCK.
+ * next_bsscfg_ID;
+ * pkt_queue: txq for transmit packets.
+ * mpc_dur: total time (ms) in mpc mode except for the portion since
+ *	    radio is turned off last time.
+ * mpc_laston_ts: timestamp (ms) when radio is turned off last time.
+ * wiphy:
  */
 struct brcms_c_info {
-	struct brcms_pub *pub;		/* pointer to wlc public state */
-	struct brcms_info *wl;	/* pointer to os-specific private state */
-	struct d11regs *regs;	/* pointer to device registers */
-
-	/* HW related state used primarily by BMAC */
+	struct brcms_pub *pub;
+	struct brcms_info *wl;
+	struct d11regs *regs;
 	struct brcms_hardware *hw;
 
 	/* clock */
-	int clkreq_override;	/* setting for clkreq for PCIE : Auto, 0, 1 */
-	u16 fastpwrup_dly;	/* time in us needed to bring up d11 fast clock */
+	int clkreq_override;
+	u16 fastpwrup_dly;
 
 	/* interrupt */
-	u32 macintstatus;	/* bit channel between isr and dpc */
-	u32 macintmask;	/* sw runtime master macintmask value */
-	u32 defmacintmask;	/* default "on" macintmask value */
+	u32 macintstatus;
+	u32 macintmask;
+	u32 defmacintmask;
 
 	/* up and down */
-	bool device_present;	/* (removable) device is present */
+	bool device_present;
 
-	bool clk;		/* core is out of reset and has clock */
+	bool clk;
 
 	/* multiband */
-	struct brcms_core *core;	/* pointer to active io core */
-	struct brcms_band *band;	/* pointer to active per-band state */
-	struct brcms_core *corestate;	/* per-core state (one per hw core) */
-	/* per-band state (one per phy/radio): */
+	struct brcms_core *core;
+	struct brcms_band *band;
+	struct brcms_core *corestate;
 	struct brcms_band *bandstate[MAXBANDS];
 
-	bool war16165;		/* PCI slow clock 16165 war flag */
+	bool war16165;
 
-	bool tx_suspended;	/* data fifos need to remain suspended */
+	bool tx_suspended;
 
 	uint txpend16165war;
 
 	/* packet queue */
-	uint qvalid;		/* DirFrmQValid and BcMcFrmQValid */
+	uint qvalid;
 
 	/* Regulatory power limits */
-	s8 txpwr_local_max;	/* regulatory local txpwr max */
-	u8 txpwr_local_constraint;	/* local power contraint in dB */
+	s8 txpwr_local_max;
+	u8 txpwr_local_constraint;
 
 
-	struct ampdu_info *ampdu;	/* ampdu module handler */
-	struct antsel_info *asi;	/* antsel module handler */
-	struct brcms_cm_info *cmi;	/* channel manager module handler */
+	struct ampdu_info *ampdu;
+	struct antsel_info *asi;
+	struct brcms_cm_info *cmi;
 
-	uint vars_size;		/* size of vars, free vars on detach */
+	uint vars_size;
 
-	u16 vendorid;	/* PCI vendor id */
-	u16 deviceid;	/* PCI device id */
-	uint ucode_rev;		/* microcode revision */
+	u16 vendorid;
+	u16 deviceid;
+	uint ucode_rev;
 
-	u32 machwcap;	/* MAC capabilities, BMAC shadow */
+	u32 machwcap;
 
-	u8 perm_etheraddr[ETH_ALEN];	/* original sprom local ethernet address */
+	u8 perm_etheraddr[ETH_ALEN];
 
-	bool bandlocked;	/* disable auto multi-band switching */
-	bool bandinit_pending;	/* track band init in auto band */
+	bool bandlocked;
+	bool bandinit_pending;
 
-	bool radio_monitor;	/* radio timer is running */
-	bool going_down;	/* down path intermediate variable */
+	bool radio_monitor;
+	bool going_down;
 
-	bool mpc;		/* enable minimum power consumption */
-	u8 mpc_dlycnt;	/* # of watchdog cnt before turn disable radio */
-	u8 mpc_offcnt;	/* # of watchdog cnt that radio is disabled */
-	u8 mpc_delay_off;	/* delay radio disable by # of watchdog cnt */
-	u8 prev_non_delay_mpc;	/* prev state brcms_c_is_non_delay_mpc */
+	bool mpc;
+	u8 mpc_dlycnt;
+	u8 mpc_offcnt;
+	u8 mpc_delay_off;
+	u8 prev_non_delay_mpc;
 
-	/* timer for watchdog routine */
 	struct brcms_timer *wdtimer;
-	/* timer for hw radio button monitor routine */
 	struct brcms_timer *radio_timer;
 
 	/* promiscuous */
-	bool monitor;		/* monitor (MPDU sniffing) mode */
-	bool bcnmisc_ibss;	/* bcns promisc mode override for IBSS */
-	bool bcnmisc_scan;	/* bcns promisc mode override for scan */
-	bool bcnmisc_monitor;	/* bcns promisc mode override for monitor */
+	bool monitor;
+	bool bcnmisc_ibss;
+	bool bcnmisc_scan;
+	bool bcnmisc_monitor;
 
 	/* driver feature */
-	bool _rifs;		/* enable per-packet rifs */
-	s8 sgi_tx;		/* sgi tx */
+	bool _rifs;
+	s8 sgi_tx;
 
 	/* AP-STA synchronization, power save */
-	u8 bcn_li_bcn;	/* beacon listen interval in # beacons */
-	u8 bcn_li_dtim;	/* beacon listen interval in # dtims */
+	u8 bcn_li_bcn;
+	u8 bcn_li_dtim;
 
-	bool WDarmed;		/* watchdog timer is armed */
-	u32 WDlast;		/* last time wlc_watchdog() was called */
+	bool WDarmed;
+	u32 WDlast;
 
 	/* WME */
-	u8 wme_dp;	/* AC bitmap. Discard (oldest first) policy per AC */
-	u16 edcf_txop[AC_COUNT];	/* current txop for each ac */
+	u8 wme_dp;
+	u16 edcf_txop[AC_COUNT];
 
-	/*
-	 * WME parameter info element, which on STA contains parameters in use
-	 * locally, and on AP contains parameters advertised to STA in beacons
-	 * and assoc responses.
-	 */
 	struct wme_param_ie wme_param_ie;
-	u16 wme_retries[AC_COUNT];	/* per-AC retry limits */
-
-	u16 tx_prec_map;	/* Precedence map based on HW FIFO space */
-	u16 fifo2prec_map[NFIFO];	/* pointer to fifo2_prec map based on WME */
+	u16 wme_retries[AC_COUNT];
+	u16 tx_prec_map;
+	u16 fifo2prec_map[NFIFO];
 
-	/*
-	 * BSS Configurations set of BSS configurations, idx 0 is default and
-	 * always valid
-	 */
 	struct brcms_bss_cfg *bsscfg[BRCMS_MAXBSSCFG];
-	struct brcms_bss_cfg *cfg; /* the primary bsscfg (can be AP or STA) */
+	struct brcms_bss_cfg *cfg;
 
 	/* tx queue */
-	struct brcms_txq_info *tx_queues;	/* common TX Queue list */
+	struct brcms_txq_info *tx_queues;
 
 	/* security */
-	struct wsec_key *wsec_keys[WSEC_MAX_KEYS]; /* dynamic key storage */
-	/* default key storage */
+	struct wsec_key *wsec_keys[WSEC_MAX_KEYS];
 	struct wsec_key *wsec_def_keys[BRCMS_DEFAULT_KEYS];
-	bool wsec_swkeys;	/* indicates that all keys should be
-				 * treated as sw keys (used for debugging)
-				 */
+	bool wsec_swkeys;
 	struct modulecb *modulecb;
 
-	u8 mimoft;		/* SIGN or 11N */
-	s8 cck_40txbw;	/* 11N, cck tx b/w override when in 40MHZ mode */
-	s8 ofdm_40txbw;	/* 11N, ofdm tx b/w override when in 40MHZ mode */
-	s8 mimo_40txbw;	/* 11N, mimo tx b/w override when in 40MHZ mode */
-	/* HT CAP IE being advertised by this node: */
+	u8 mimoft;
+	s8 cck_40txbw;
+	s8 ofdm_40txbw;
+	s8 mimo_40txbw;
 	struct ieee80211_ht_cap ht_cap;
 
-	struct brcms_bss_info *default_bss;	/* configured BSS parameters */
+	struct brcms_bss_info *default_bss;
 
-	u16 mc_fid_counter;	/* BC/MC FIFO frame ID counter */
+	u16 mc_fid_counter;
 
-	/* saved country for leaving 802.11d auto-country mode */
 	char country_default[BRCM_CNTRY_BUF_SZ];
-	/* initial country for 802.11d auto-country mode */
 	char autocountry_default[BRCM_CNTRY_BUF_SZ];
-	u16 prb_resp_timeout;	/* do not send prb resp if request older than this,
-					 * 0 = disable
-					 */
-	/* use only these rates in 11g supported rates if specified */
+	u16 prb_resp_timeout;
 	struct brcms_c_rateset sup_rates_override;
 
-	u16 home_chanspec;	/* shared home chanspec */
+	u16 home_chanspec;
 
 	/* PHY parameters */
-	u16 chanspec;	/* target operational channel */
-	u16 usr_fragthresh;	/* user configured fragmentation threshold */
-	u16 fragthresh[NFIFO];	/* per-fifo fragmentation thresholds */
-	u16 RTSThresh;	/* 802.11 dot11RTSThreshold */
-	u16 SRL;		/* 802.11 dot11ShortRetryLimit */
-	u16 LRL;		/* 802.11 dot11LongRetryLimit */
-	u16 SFBL;		/* Short Frame Rate Fallback Limit */
-	u16 LFBL;		/* Long Frame Rate Fallback Limit */
+	u16 chanspec;
+	u16 usr_fragthresh;
+	u16 fragthresh[NFIFO];
+	u16 RTSThresh;
+	u16 SRL;
+	u16 LRL;
+	u16 SFBL;
+	u16 LFBL;
 
 	/* network config */
-	bool shortslot;		/* currently using 11g ShortSlot timing */
-	s8 shortslot_override;	/* 11g ShortSlot override */
-	bool include_legacy_erp;	/* include Legacy ERP info elt ID 47 as well as g ID 42 */
+	bool shortslot;
+	s8 shortslot_override;
+	bool include_legacy_erp;
 
 	struct brcms_protection *protection;
-	s8 PLCPHdr_override;	/* 802.11b Preamble Type override */
+	s8 PLCPHdr_override;
 
 	struct brcms_stf *stf;
 
-	u32 bcn_rspec;	/* save bcn ratespec purpose */
+	u32 bcn_rspec;
 
 	uint tempsense_lasttime;
 
-	u16 tx_duty_cycle_ofdm;	/* maximum allowed duty cycle for OFDM */
-	u16 tx_duty_cycle_cck;	/* maximum allowed duty cycle for CCK */
+	u16 tx_duty_cycle_ofdm;
+	u16 tx_duty_cycle_cck;
 
 	u16 next_bsscfg_ID;
 
-	struct brcms_txq_info *pkt_queue; /* txq for transmit packets */
-	u32 mpc_dur;		/* total time (ms) in mpc mode except for the
-				 * portion since radio is turned off last time
-				 */
-	u32 mpc_laston_ts;	/* timestamp (ms) when radio is turned off last
-				 * time
-				 */
+	struct brcms_txq_info *pkt_queue;
+	u32 mpc_dur;
+	u32 mpc_laston_ts;
 	struct wiphy *wiphy;
 };
 
@@ -810,88 +923,136 @@ struct antsel_info {
 	struct brcms_antselcfg antcfg_cur; /* current antenna config (auto) */
 };
 
-/* BSS configuration state */
+/*
+ * BSS configuration state
+ *
+ * wlc: wlc to which this bsscfg belongs to.
+ * up: is this configuration up operational
+ * enable: is this configuration enabled
+ * associated: is BSS in ASSOCIATED state
+ * BSS: infraustructure or adhoc
+ * dtim_programmed:
+ * SSID_len: the length of SSID
+ * SSID: SSID string
+ * bcmc_scb: one bcmc_scb per band
+ * _idx: the index of this bsscfg, assigned at wlc_bsscfg_alloc()
+ *
+ * MAC filter
+ * ----------
+ * nmac: # of entries on maclist array
+ * macmode: allow/deny stations on maclist array
+ * maclist: list of source MAC addrs to match
+
+ * security
+ * --------
+ * wsec: wireless security bitvec
+ * auth: 802.11 authentication: Open, Shared Key, WPA
+ * openshared: try Open auth first, then Shared Key
+ * wsec_restrict: drop unencrypted packets if wsec is enabled
+ * eap_restrict: restrict data until 802.1X auth succeeds
+ * WPA_auth: WPA authenticated key management
+ * wpa2_preauth: default is true, wpa_cap sets value
+ * wsec_portopen: indicates keys are plumbed
+ * wpa_none_txiv: global txiv for WPA_NONE, tkip and aes
+ * wsec_index: 0-3: default tx key, -1: not set
+ * bss_def_keys: default key storage
+ *
+ * TKIP countermeasures
+ * --------------------
+ * tkip_countermeasures: flags TKIP no-assoc period
+ * tk_cm_dt: detect timer
+ * tk_cm_bt: blocking timer
+ * tk_cm_bt_tmstmp: Timestamp when TKIP BT is activated
+ * tk_cm_activate: activate countermeasures after EAPOL-Key sent
+ *
+ * BSSID: BSSID (associated)
+ * cur_etheraddr: h/w address
+ * bcmc_fid: the last BCMC FID queued to TX_BCMC_FIFO
+ * bcmc_fid_shm: the last BCMC FID written to shared mem
+ * flags: BSSCFG flags; see below
+ * bcn: AP beacon
+ * bcn_len: AP beacon length
+ * ar_disassoc: disassociated in associated recreation
+ * auth_atmptd: auth type (open/shared) attempted
+ *
+ * pmkid_cand: PMKID candidate list
+ * npmkid_cand: num PMKID candidates
+ * pmkid: PMKID cache
+ * npmkid: num cached PMKIDs
+ * current_bss: BSS parms in ASSOCIATED state
+ *
+ * PM states
+ * ---------
+ * PMawakebcn: bcn recvd during current waking state
+ * PMpending: waiting for tx status with PM indicated set
+ * priorPMstate: Detecting PM state transitions
+ * PSpoll: flags there is an outstanding PS-Poll frame
+ *
+ * rcmta: BSSID entry in RCMTA, use the wsec key to manage the RCMTA entries.
+ *
+ * ID: 'unique' ID of this bsscfg, assigned at bsscfg allocation
+ *
+ * txrspecidx: index into tx rate circular buffer
+ * txrspec: circular buffer of prev MPDUs tx rates
+ */
 struct brcms_bss_cfg {
-	struct brcms_c_info *wlc; /* wlc to which this bsscfg belongs to. */
-	bool up;		/* is this configuration up operational */
-	bool enable;		/* is this configuration enabled */
-	bool associated;	/* is BSS in ASSOCIATED state */
-	bool BSS;		/* infraustructure or adhac */
+	struct brcms_c_info *wlc;
+	bool up;
+	bool enable;
+	bool associated;
+	bool BSS;
 	bool dtim_programmed;
-
-	u8 SSID_len;		/* the length of SSID */
-	u8 SSID[IEEE80211_MAX_SSID_LEN]; /* SSID string */
-	struct scb *bcmc_scb[MAXBANDS];	/* one bcmc_scb per band */
-	s8 _idx;		/* the index of this bsscfg,
-				 * assigned at wlc_bsscfg_alloc()
-				 */
-	/* MAC filter */
-	uint nmac;		/* # of entries on maclist array */
-	int macmode;		/* allow/deny stations on maclist array */
-	struct ether_addr *maclist;	/* list of source MAC addrs to match */
-
-	/* security */
-	u32 wsec;		/* wireless security bitvec */
-	s16 auth;		/* 802.11 authentication: Open, Shared Key, WPA */
-	s16 openshared;	/* try Open auth first, then Shared Key */
-	bool wsec_restrict;	/* drop unencrypted packets if wsec is enabled */
-	bool eap_restrict;	/* restrict data until 802.1X auth succeeds */
-	u16 WPA_auth;	/* WPA: authenticated key management */
-	bool wpa2_preauth;	/* default is true, wpa_cap sets value */
-	bool wsec_portopen;	/* indicates keys are plumbed */
-	/* global txiv for WPA_NONE, tkip and aes */
+	u8 SSID_len;
+	u8 SSID[IEEE80211_MAX_SSID_LEN];
+	struct scb *bcmc_scb[MAXBANDS];
+	s8 _idx;
+	uint nmac;
+	int macmode;
+	struct ether_addr *maclist;
+	u32 wsec;
+	s16 auth;
+	s16 openshared;
+	bool wsec_restrict;
+	bool eap_restrict;
+	u16 WPA_auth;
+	bool wpa2_preauth;
+	bool wsec_portopen;
 	struct wsec_iv wpa_none_txiv;
-	int wsec_index;		/* 0-3: default tx key, -1: not set */
-	/* default key storage: */
+	int wsec_index;
 	struct wsec_key *bss_def_keys[BRCMS_DEFAULT_KEYS];
-
-	/* TKIP countermeasures */
-	bool tkip_countermeasures;	/* flags TKIP no-assoc period */
-	u32 tk_cm_dt;	/* detect timer */
-	u32 tk_cm_bt;	/* blocking timer */
-	u32 tk_cm_bt_tmstmp;	/* Timestamp when TKIP BT is activated */
-	bool tk_cm_activate;	/* activate countermeasures after EAPOL-Key sent */
-
-	u8 BSSID[ETH_ALEN];	/* BSSID (associated) */
-	u8 cur_etheraddr[ETH_ALEN];	/* h/w address */
-	u16 bcmc_fid;	/* the last BCMC FID queued to TX_BCMC_FIFO */
-	u16 bcmc_fid_shm;	/* the last BCMC FID written to shared mem */
-
-	u32 flags;		/* BSSCFG flags; see below */
-
-	u8 *bcn;		/* AP beacon */
-	uint bcn_len;		/* AP beacon length */
-	bool ar_disassoc;	/* disassociated in associated recreation */
-
-	int auth_atmptd;	/* auth type (open/shared) attempted */
-
-	struct pmkid_cand pmkid_cand[MAXPMKID];	/* PMKID candidate list */
-	uint npmkid_cand;	/* num PMKID candidates */
-	struct pmkid pmkid[MAXPMKID];	/* PMKID cache */
-	uint npmkid;		/* num cached PMKIDs */
-
-	struct brcms_bss_info *current_bss; /* BSS parms in ASSOCIATED state */
-
-	/* PM states */
-	bool PMawakebcn;	/* bcn recvd during current waking state */
-	bool PMpending;		/* waiting for tx status with PM indicated set */
-	bool priorPMstate;	/* Detecting PM state transitions */
-	bool PSpoll;		/* whether there is an outstanding PS-Poll frame */
-
-	/* BSSID entry in RCMTA, use the wsec key management infrastructure to
-	 * manage the RCMTA entries.
-	 */
+	bool tkip_countermeasures;
+	u32 tk_cm_dt;
+	u32 tk_cm_bt;
+	u32 tk_cm_bt_tmstmp;
+	bool tk_cm_activate;
+	u8 BSSID[ETH_ALEN];
+	u8 cur_etheraddr[ETH_ALEN];
+	u16 bcmc_fid;
+	u16 bcmc_fid_shm;
+	u32 flags;
+	u8 *bcn;
+	uint bcn_len;
+	bool ar_disassoc;
+	int auth_atmptd;
+	struct pmkid_cand pmkid_cand[MAXPMKID];
+	uint npmkid_cand;
+	struct pmkid pmkid[MAXPMKID];
+	uint npmkid;
+	struct brcms_bss_info *current_bss;
+	bool PMawakebcn;
+	bool PMpending;
+	bool priorPMstate;
+	bool PSpoll;
 	struct wsec_key *rcmta;
-
-	/* 'unique' ID of this bsscfg, assigned at bsscfg allocation */
 	u16 ID;
-
-	uint txrspecidx;	 /* index into tx rate circular buffer */
-	u32 txrspec[NTXRATE][2]; /* circular buffer of prev MPDUs tx rates */
+	uint txrspecidx;
+	u32 txrspec[NTXRATE][2];
 };
 
-#define	CHANNEL_BANDUNIT(wlc, ch) (((ch) <= CH_MAX_2G_CHANNEL) ? BAND_2G_INDEX : BAND_5G_INDEX)
-#define	OTHERBANDUNIT(wlc)	((uint)((wlc)->band->bandunit ? BAND_2G_INDEX : BAND_5G_INDEX))
+#define	CHANNEL_BANDUNIT(wlc, ch) \
+	(((ch) <= CH_MAX_2G_CHANNEL) ? BAND_2G_INDEX : BAND_5G_INDEX)
+#define	OTHERBANDUNIT(wlc) \
+	((uint)((wlc)->band->bandunit ? BAND_2G_INDEX : BAND_5G_INDEX))
 
 #define IS_MBAND_UNLOCKED(wlc) \
 	((NBANDS(wlc) > 1) && !(wlc)->bandlocked)
@@ -899,14 +1060,15 @@ struct brcms_bss_cfg {
 #define BRCMS_BAND_PI_RADIO_CHANSPEC wlc_phy_chanspec_get(wlc->band->pi)
 
 /* sum the individual fifo tx pending packet counts */
-#define	TXPKTPENDTOT(wlc) ((wlc)->core->txpktpend[0] + (wlc)->core->txpktpend[1] + \
-	(wlc)->core->txpktpend[2] + (wlc)->core->txpktpend[3])
-#define TXPKTPENDGET(wlc, fifo)		((wlc)->core->txpktpend[(fifo)])
-#define TXPKTPENDINC(wlc, fifo, val)	((wlc)->core->txpktpend[(fifo)] += (val))
-#define TXPKTPENDDEC(wlc, fifo, val)	((wlc)->core->txpktpend[(fifo)] -= (val))
-#define TXPKTPENDCLR(wlc, fifo)		((wlc)->core->txpktpend[(fifo)] = 0)
-#define TXAVAIL(wlc, fifo)		(*(wlc)->core->txavail[(fifo)])
-#define GETNEXTTXP(wlc, _queue)								\
+#define	TXPKTPENDTOT(wlc) \
+	((wlc)->core->txpktpend[0] + (wlc)->core->txpktpend[1] + \
+	 (wlc)->core->txpktpend[2] + (wlc)->core->txpktpend[3])
+#define TXPKTPENDGET(wlc, fifo) ((wlc)->core->txpktpend[(fifo)])
+#define TXPKTPENDINC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] += (val))
+#define TXPKTPENDDEC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] -= (val))
+#define TXPKTPENDCLR(wlc, fifo)	((wlc)->core->txpktpend[(fifo)] = 0)
+#define TXAVAIL(wlc, fifo) (*(wlc)->core->txavail[(fifo)])
+#define GETNEXTTXP(wlc, _queue) \
 		dma_getnexttxp((wlc)->hw->di[(_queue)], DMA_RANGE_TRANSMITTED)
 
 #define BRCMS_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 03f9856..975d80c 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -24,10 +24,14 @@
 
 #define OTPS_GUP_MASK		0x00000f00
 #define OTPS_GUP_SHIFT		8
-#define OTPS_GUP_HW		0x00000100	/* h/w subregion is programmed */
-#define OTPS_GUP_SW		0x00000200	/* s/w subregion is programmed */
-#define OTPS_GUP_CI		0x00000400	/* chipid/pkgopt subregion is programmed */
-#define OTPS_GUP_FUSE		0x00000800	/* fuse subregion is programmed */
+/* h/w subregion is programmed */
+#define OTPS_GUP_HW		0x00000100
+/* s/w subregion is programmed */
+#define OTPS_GUP_SW		0x00000200
+/* chipid/pkgopt subregion is programmed */
+#define OTPS_GUP_CI		0x00000400
+/* fuse subregion is programmed */
+#define OTPS_GUP_FUSE		0x00000800
 
 /* Fields in otpprog in rev >= 21 */
 #define OTPP_COL_MASK		0x000000ff
@@ -195,8 +199,9 @@ static u16 ipxotp_read_bit(void *oh, struct chipcregs *cc, uint off)
 	return (int)st;
 }
 
-/* Calculate max HW/SW region byte size by subtracting fuse region and checksum size,
- * osizew is oi->wsize (OTP size - GU size) in words
+/*
+ * Calculate max HW/SW region byte size by subtracting fuse region
+ * and checksum size, osizew is oi->wsize (OTP size - GU size) in words
  */
 static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 {
@@ -222,12 +227,18 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 	uint k;
 	u32 otpp, st;
 
-	/* record word offset of General Use Region for various chipcommon revs */
+	/*
+	 * record word offset of General Use Region
+	 * for various chipcommon revs
+	 */
 	if (oi->sih->ccrev == 21 || oi->sih->ccrev == 24
 	    || oi->sih->ccrev == 27) {
 		oi->otpgu_base = REVA4_OTPGU_BASE;
 	} else if (oi->sih->ccrev == 36) {
-		/* OTP size greater than equal to 2KB (128 words), otpgu_base is similar to rev23 */
+		/*
+		 * OTP size greater than equal to 2KB (128 words),
+		 * otpgu_base is similar to rev23
+		 */
 		if (oi->wsize >= 128)
 			oi->otpgu_base = REVB8_OTPGU_BASE;
 		else
@@ -262,8 +273,9 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 	}
 
 	/*
-	 * h/w region base and fuse region limit are fixed to the top and
-	 * the bottom of the general use region. Everything else can be flexible.
+	 * h/w region base and fuse region limit are fixed to
+	 * the top and the bottom of the general use region.
+	 * Everything else can be flexible.
 	 */
 	oi->hwbase = oi->otpgu_base + OTPGU_SROM_OFF;
 	oi->hwlim = oi->wsize;
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.h b/drivers/staging/brcm80211/brcmsmac/otp.h
index f6d3a56..4d79246 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.h
+++ b/drivers/staging/brcm80211/brcmsmac/otp.h
@@ -24,7 +24,8 @@
 #define OTP_SW_RGN	2
 #define OTP_CI_RGN	4
 #define OTP_FUSE_RGN	8
-#define OTP_ALL_RGN	0xf	/* From h/w region to end of OTP including checksum */
+/* From h/w region to end of OTP including checksum */
+#define OTP_ALL_RGN	0xf
 
 /* OTP Size */
 #define OTP_SZ_MAX		(6144/8)	/* maximum bytes in one CIS */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 56824f4..a882139 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -15,10 +15,11 @@
  */
 
 /*
- * This is "two-way" interface, acting as the SHIM layer between WL and PHY layer.
- *   WL driver can optinally call this translation layer to do some preprocessing, then reach PHY.
- *   On the PHY->WL driver direction, all calls go through this layer since PHY doesn't have the
- *   access to wlc_hw pointer.
+ * This is "two-way" interface, acting as the SHIM layer between driver
+ * and PHY layer. The driver can optionally call this translation layer
+ * to do some preprocessing, then reach PHY. On the PHY->driver direction,
+ * all calls go through this layer since PHY doesn't have access to the
+ * driver's brcms_hardware pointer.
  */
 #include <linux/slab.h>
 #include <net/mac80211.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 2d12bb4..a35e1ed 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -45,17 +45,17 @@
 #define FRA_ERR_20MHZ	60
 #define FRA_ERR_40MHZ	120
 
-#define ANTSEL_NA		0	/* No boardlevel selection available */
-#define ANTSEL_2x4		1	/* 2x4 boardlevel selection available */
-#define ANTSEL_2x3		2	/* 2x3 CB2 boardlevel selection available */
+#define ANTSEL_NA		0 /* No boardlevel selection available */
+#define ANTSEL_2x4		1 /* 2x4 boardlevel selection available */
+#define ANTSEL_2x3		2 /* 2x3 CB2 boardlevel selection available */
 
 /* Rx Antenna diversity control values */
-#define	ANT_RX_DIV_FORCE_0		0	/* Use antenna 0 */
-#define	ANT_RX_DIV_FORCE_1		1	/* Use antenna 1 */
-#define	ANT_RX_DIV_START_1		2	/* Choose starting with 1 */
-#define	ANT_RX_DIV_START_0		3	/* Choose starting with 0 */
-#define	ANT_RX_DIV_ENABLE		3	/* APHY bbConfig Enable RX Diversity */
-#define ANT_RX_DIV_DEF		ANT_RX_DIV_START_0	/* default antdiv setting */
+#define	ANT_RX_DIV_FORCE_0	0	/* Use antenna 0 */
+#define	ANT_RX_DIV_FORCE_1	1	/* Use antenna 1 */
+#define	ANT_RX_DIV_START_1	2	/* Choose starting with 1 */
+#define	ANT_RX_DIV_START_0	3	/* Choose starting with 0 */
+#define	ANT_RX_DIV_ENABLE	3	/* APHY bbConfig Enable RX Diversity */
+#define ANT_RX_DIV_DEF		ANT_RX_DIV_START_0 /* default antdiv setting */
 
 #define WL_ANT_RX_MAX		2	/* max 2 receive antennas */
 #define WL_ANT_HT_RX_MAX	3	/* max 3 receive antennas/cores */
@@ -77,26 +77,40 @@
 #define WL_TX_POWER_RATES	       101
 #define WL_TX_POWER_CCK_FIRST	       0
 #define WL_TX_POWER_CCK_NUM	       4
-#define WL_TX_POWER_OFDM_FIRST	       4	/* Index for first 20MHz OFDM SISO rate */
-#define WL_TX_POWER_OFDM20_CDD_FIRST   12	/* Index for first 20MHz OFDM CDD rate */
-#define WL_TX_POWER_OFDM40_SISO_FIRST  52	/* Index for first 40MHz OFDM SISO rate */
-#define WL_TX_POWER_OFDM40_CDD_FIRST   60	/* Index for first 40MHz OFDM CDD rate */
+/* Index for first 20MHz OFDM SISO rate */
+#define WL_TX_POWER_OFDM_FIRST	       4
+/* Index for first 20MHz OFDM CDD rate */
+#define WL_TX_POWER_OFDM20_CDD_FIRST   12
+/* Index for first 40MHz OFDM SISO rate */
+#define WL_TX_POWER_OFDM40_SISO_FIRST  52
+/* Index for first 40MHz OFDM CDD rate */
+#define WL_TX_POWER_OFDM40_CDD_FIRST   60
 #define WL_TX_POWER_OFDM_NUM	       8
-#define WL_TX_POWER_MCS20_SISO_FIRST   20	/* Index for first 20MHz MCS SISO rate */
-#define WL_TX_POWER_MCS20_CDD_FIRST    28	/* Index for first 20MHz MCS CDD rate */
-#define WL_TX_POWER_MCS20_STBC_FIRST   36	/* Index for first 20MHz MCS STBC rate */
-#define WL_TX_POWER_MCS20_SDM_FIRST    44	/* Index for first 20MHz MCS SDM rate */
-#define WL_TX_POWER_MCS40_SISO_FIRST   68	/* Index for first 40MHz MCS SISO rate */
-#define WL_TX_POWER_MCS40_CDD_FIRST    76	/* Index for first 40MHz MCS CDD rate */
-#define WL_TX_POWER_MCS40_STBC_FIRST   84	/* Index for first 40MHz MCS STBC rate */
-#define WL_TX_POWER_MCS40_SDM_FIRST    92	/* Index for first 40MHz MCS SDM rate */
+/* Index for first 20MHz MCS SISO rate */
+#define WL_TX_POWER_MCS20_SISO_FIRST   20
+/* Index for first 20MHz MCS CDD rate */
+#define WL_TX_POWER_MCS20_CDD_FIRST    28
+/* Index for first 20MHz MCS STBC rate */
+#define WL_TX_POWER_MCS20_STBC_FIRST   36
+/* Index for first 20MHz MCS SDM rate */
+#define WL_TX_POWER_MCS20_SDM_FIRST    44
+/* Index for first 40MHz MCS SISO rate */
+#define WL_TX_POWER_MCS40_SISO_FIRST   68
+/* Index for first 40MHz MCS CDD rate */
+#define WL_TX_POWER_MCS40_CDD_FIRST    76
+/* Index for first 40MHz MCS STBC rate */
+#define WL_TX_POWER_MCS40_STBC_FIRST   84
+/* Index for first 40MHz MCS SDM rate */
+#define WL_TX_POWER_MCS40_SDM_FIRST    92
 #define WL_TX_POWER_MCS_1_STREAM_NUM   8
 #define WL_TX_POWER_MCS_2_STREAM_NUM   8
-#define WL_TX_POWER_MCS_32	       100	/* Index for 40MHz rate MCS 32 */
+/* Index for 40MHz rate MCS 32 */
+#define WL_TX_POWER_MCS_32	       100
 #define WL_TX_POWER_MCS_32_NUM	       1
 
 /* sslpnphy specifics */
-#define WL_TX_POWER_MCS20_SISO_FIRST_SSN   12	/* Index for first 20MHz MCS SISO rate */
+/* Index for first 20MHz MCS SISO rate */
+#define WL_TX_POWER_MCS20_SISO_FIRST_SSN   12
 
 /* struct tx_power::flags bits */
 #define WL_TX_POWER_F_ENABLED	1
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index ec53a08..f5e1085 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -70,11 +70,13 @@
 #define PMURES_BIT(bit)	(1 << (bit))
 
 /* PMU corerev and chip specific PLL controls.
- * PMU<rev>_PLL<num>_XX where <rev> is PMU corerev and <num> is an arbitrary number
- * to differentiate different PLLs controlled by the same PMU rev.
+ * PMU<rev>_PLL<num>_XX where <rev> is PMU corerev and <num> is an arbitrary
+ * number to differentiate different PLLs controlled by the same PMU rev.
+ */
+/* pllcontrol registers:
+ * ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>,
+ * p1div, p2div, _bypass_sdmod
  */
-/* pllcontrol registers */
-/* ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>, p1div, p2div, _bypass_sdmod */
 #define PMU1_PLL0_PLLCTL0		0
 #define PMU1_PLL0_PLLCTL1		1
 #define PMU1_PLL0_PLLCTL2		2
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index bfbdc3a..8da7250 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -69,36 +69,53 @@
 #define	BRCMS_RATE_MASK	0x7f	/* Rate value mask w/o basic rate flag */
 
 /* legacy rx Antenna diversity for SISO rates */
-#define	ANT_RX_DIV_FORCE_0		0	/* Use antenna 0 */
-#define	ANT_RX_DIV_FORCE_1		1	/* Use antenna 1 */
-#define	ANT_RX_DIV_START_1		2	/* Choose starting with 1 */
-#define	ANT_RX_DIV_START_0		3	/* Choose starting with 0 */
-#define	ANT_RX_DIV_ENABLE		3	/* APHY bbConfig Enable RX Diversity */
-#define ANT_RX_DIV_DEF		ANT_RX_DIV_START_0	/* default antdiv setting */
+#define	ANT_RX_DIV_FORCE_0	0	/* Use antenna 0 */
+#define	ANT_RX_DIV_FORCE_1	1	/* Use antenna 1 */
+#define	ANT_RX_DIV_START_1	2	/* Choose starting with 1 */
+#define	ANT_RX_DIV_START_0	3	/* Choose starting with 0 */
+#define	ANT_RX_DIV_ENABLE	3	/* APHY bbConfig Enable RX Diversity */
+/* default antdiv setting */
+#define ANT_RX_DIV_DEF		ANT_RX_DIV_START_0
 
 /* legacy rx Antenna diversity for SISO rates */
-#define ANT_TX_FORCE_0		0	/* Tx on antenna 0, "legacy term Main" */
-#define ANT_TX_FORCE_1		1	/* Tx on antenna 1, "legacy term Aux" */
-#define ANT_TX_LAST_RX		3	/* Tx on phy's last good Rx antenna */
-#define ANT_TX_DEF			3	/* driver's default tx antenna setting */
-
-#define TXCORE_POLICY_ALL	0x1	/* use all available core for transmit */
+/* Tx on antenna 0, "legacy term Main" */
+#define ANT_TX_FORCE_0		0
+/* Tx on antenna 1, "legacy term Aux" */
+#define ANT_TX_FORCE_1		1
+/* Tx on phy's last good Rx antenna */
+#define ANT_TX_LAST_RX		3
+/* driver's default tx antenna setting */
+#define ANT_TX_DEF		3
+
+/* use all available core for transmit */
+#define TXCORE_POLICY_ALL	0x1
 
 /* Tx Chain values */
-#define TXCHAIN_DEF		0x1	/* def bitmap of txchain */
-#define TXCHAIN_DEF_NPHY	0x3	/* default bitmap of tx chains for nphy */
-#define TXCHAIN_DEF_HTPHY	0x7	/* default bitmap of tx chains for nphy */
-#define RXCHAIN_DEF		0x1	/* def bitmap of rxchain */
-#define RXCHAIN_DEF_NPHY	0x3	/* default bitmap of rx chains for nphy */
-#define RXCHAIN_DEF_HTPHY	0x7	/* default bitmap of rx chains for nphy */
-#define ANTSWITCH_NONE		0	/* no antenna switch */
-#define ANTSWITCH_TYPE_1	1	/* antenna switch on 4321CB2, 2of3 */
-#define ANTSWITCH_TYPE_2	2	/* antenna switch on 4321MPCI, 2of3 */
-#define ANTSWITCH_TYPE_3	3	/* antenna switch on 4322, 2of3 */
+/* def bitmap of txchain */
+#define TXCHAIN_DEF		0x1
+/* default bitmap of tx chains for nphy */
+#define TXCHAIN_DEF_NPHY	0x3
+/* default bitmap of tx chains for nphy */
+#define TXCHAIN_DEF_HTPHY	0x7
+/* def bitmap of rxchain */
+#define RXCHAIN_DEF		0x1
+/* default bitmap of rx chains for nphy */
+#define RXCHAIN_DEF_NPHY	0x3
+/* default bitmap of rx chains for nphy */
+#define RXCHAIN_DEF_HTPHY	0x7
+/* no antenna switch */
+#define ANTSWITCH_NONE		0
+/* antenna switch on 4321CB2, 2of3 */
+#define ANTSWITCH_TYPE_1	1
+/* antenna switch on 4321MPCI, 2of3 */
+#define ANTSWITCH_TYPE_2	2
+/* antenna switch on 4322, 2of3 */
+#define ANTSWITCH_TYPE_3	3
 
 #define RXBUFSZ		PKTBUFSZ
 #ifndef AIDMAPSZ
-#define AIDMAPSZ	(roundup(MAXSCB, NBBY)/NBBY)	/* aid bitmap size in bytes */
+/* aid bitmap size in bytes */
+#define AIDMAPSZ	(roundup(MAXSCB, NBBY)/NBBY)
 #endif				/* AIDMAPSZ */
 
 #define MAX_STREAMS_SUPPORTED	4	/* max number of streams supported */
@@ -108,21 +125,21 @@
 #define	WL_SPURAVOID_ON2	2
 
 struct brcms_tunables {
-	int ntxd;		/* size of tx descriptor table */
-	int nrxd;		/* size of rx descriptor table */
-	int rxbufsz;		/* size of rx buffers to post */
-	int nrxbufpost;		/* # of rx buffers to post */
-	int maxscb;		/* # of SCBs supported */
+	int ntxd;	/* size of tx descriptor table */
+	int nrxd;	/* size of rx descriptor table */
+	int rxbufsz;	/* size of rx buffers to post */
+	int nrxbufpost;	/* # of rx buffers to post */
+	int maxscb;	/* # of SCBs supported */
 	int ampdunummpdu;	/* max number of mpdu in an ampdu */
-	int maxpktcb;		/* max # of packet callbacks */
-	int maxucodebss;	/* max # of BSS handled in ucode bcn/prb */
+	int maxpktcb;	/* max # of packet callbacks */
+	int maxucodebss;/* max # of BSS handled in ucode bcn/prb */
 	int maxucodebss4;	/* max # of BSS handled in sw bcn/prb */
-	int maxbss;		/* max # of bss info elements in scan list */
-	int datahiwat;		/* data msg txq hiwat mark */
+	int maxbss;	/* max # of bss info elements in scan list */
+	int datahiwat;	/* data msg txq hiwat mark */
 	int ampdudatahiwat;	/* AMPDU msg txq hiwat mark */
-	int rxbnd;		/* max # of rx bufs to process before deferring to dpc */
-	int txsbnd;		/* max # tx status to process in wlc_txstatus() */
-	int memreserved;	/* memory reserved for BMAC's USB dma rx */
+	int rxbnd;	/* max # rx bufs to process before deferring to dpc */
+	int txsbnd;	/* max # tx status to process in wlc_txstatus() */
+	int memreserved;/* memory reserved for BMAC's USB dma rx */
 };
 
 struct brcms_c_rateset {
@@ -181,7 +198,7 @@ struct brcms_bss_info {
 	struct rsn_parms wpa;
 	struct rsn_parms wpa2;
 	u16 qbss_load_aac;	/* qbss load available admission capacity */
-	/* qbss_load_chan_free <- (0xff - channel_utilization of qbss_load_ie_t) */
+	/* qbss_load_chan_free <- (0xff - chan utilization of qbss_load_ie_t) */
 	u8 qbss_load_chan_free;	/* indicates how free the channel is */
 	u8 mcipher;		/* multicast cipher */
 	u8 wpacfg;		/* wpa config index */
@@ -207,7 +224,7 @@ struct brcms_bss_info {
 #define MAC80211_SCAN		(1 << 1)
 
 /*
- * Public portion of "common" os-independent state structure.
+ * Public portion of common driver state structure.
  * The wlc handle points at this.
  */
 struct brcms_pub {
@@ -225,8 +242,8 @@ struct brcms_pub {
 	bool hw_off;		/* HW is off */
 	/* tunables: ntxd, nrxd, maxscb, etc. */
 	struct brcms_tunables *tunables;
-	bool hw_up;		/* one time hw up/down(from boot or hibernation) */
-	bool _piomode;		/* true if pio mode *//* BMAC_NOTE: NEED In both */
+	bool hw_up;		/* one time hw up/down */
+	bool _piomode;		/* true if pio mode */
 	uint _nbands;		/* # bands supported */
 	uint now;		/* # elapsed seconds */
 
@@ -247,7 +264,7 @@ struct brcms_pub {
 	u8 _n_enab;		/* bitmap of 11N + HT support */
 	bool _n_reqd;		/* N support required for clients */
 
-	s8 _coex;		/* 20/40 MHz BSS Management AUTO, ENAB, DISABLE */
+	s8 _coex;	/* 20/40 MHz BSS Management AUTO, ENAB, DISABLE */
 	bool _priofc;		/* Priority-based flowcontrol */
 
 	u8 cur_etheraddr[ETH_ALEN];	/* our local ethernet address */
@@ -337,8 +354,10 @@ enum wlc_par_id {
 #define SUPPORT_11N	(ENAB_1x1|ENAB_2x2)
 #define SUPPORT_HT	(ENAB_1x1|ENAB_2x2|ENAB_3x3)
 /* WL11N Support */
-#if ((defined(NCONF) && (NCONF != 0)) || (defined(LCNCONF) && (LCNCONF != 0)) || \
-	(defined(HTCONF) && (HTCONF != 0)) || (defined(SSLPNCONF) && (SSLPNCONF != 0)))
+#if ((defined(NCONF) && (NCONF != 0)) || \
+	(defined(LCNCONF) && (LCNCONF != 0)) || \
+	(defined(HTCONF) && (HTCONF != 0)) || \
+	(defined(SSLPNCONF) && (SSLPNCONF != 0)))
 #define N_ENAB(pub) ((pub)->_n_enab & SUPPORT_11N)
 #define N_REQD(pub) ((pub)->_n_reqd)
 #else
@@ -370,8 +389,10 @@ enum wlc_par_id {
 extern const u8 wlc_prio2prec_map[];
 #define BRCMS_PRIO_TO_PREC(pri)	wlc_prio2prec_map[(pri) & 7]
 
-/* This maps priority to one precedence higher - Used by PS-Poll response packets to
- * simulate enqueue-at-head operation, but still maintain the order on the queue
+/*
+ * This maps priority to one precedence higher - Used by PS-Poll response
+ * packets to simulate enqueue-at-head operation, but still maintain the
+ * order on the queue
  */
 #define BRCMS_PRIO_TO_HI_PREC(pri)	min(BRCMS_PRIO_TO_PREC(pri) + 1,\
 					    BRCMS_PREC_COUNT - 1)
@@ -424,28 +445,34 @@ extern const u8 wme_fifo2ac[];
 /*
  * 54g modes (basic bits may still be overridden)
  *
- * GMODE_LEGACY_B			Rateset: 1b, 2b, 5.5, 11
- *					Preamble: Long
- *					Shortslot: Off
- * GMODE_AUTO				Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
- *					Extended Rateset: 6, 9, 12, 48
- *					Preamble: Long
- *					Shortslot: Auto
- * GMODE_ONLY				Rateset: 1b, 2b, 5.5b, 11b, 18, 24b, 36, 54
- *					Extended Rateset: 6b, 9, 12b, 48
- *					Preamble: Short required
- *					Shortslot: Auto
- * GMODE_B_DEFERRED			Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
- *					Extended Rateset: 6, 9, 12, 48
- *					Preamble: Long
- *					Shortslot: On
- * GMODE_PERFORMANCE			Rateset: 1b, 2b, 5.5b, 6b, 9, 11b, 12b, 18, 24b, 36, 48, 54
- *					Preamble: Short required
- *					Shortslot: On and required
- * GMODE_LRS				Rateset: 1b, 2b, 5.5b, 11b
- *					Extended Rateset: 6, 9, 12, 18, 24, 36, 48, 54
- *					Preamble: Long
- *					Shortslot: Auto
+ * GMODE_LEGACY_B
+ *	Rateset: 1b, 2b, 5.5, 11
+ *	Preamble: Long
+ *	Shortslot: Off
+ * GMODE_AUTO
+ *	Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
+ *	Extended Rateset: 6, 9, 12, 48
+ *	Preamble: Long
+ *	Shortslot: Auto
+ * GMODE_ONLY
+ *	Rateset: 1b, 2b, 5.5b, 11b, 18, 24b, 36, 54
+ *	Extended Rateset: 6b, 9, 12b, 48
+ *	Preamble: Short required
+ *	Shortslot: Auto
+ * GMODE_B_DEFERRED
+ *	Rateset: 1b, 2b, 5.5b, 11b, 18, 24, 36, 54
+ *	Extended Rateset: 6, 9, 12, 48
+ *	Preamble: Long
+ *	Shortslot: On
+ * GMODE_PERFORMANCE
+ *	Rateset: 1b, 2b, 5.5b, 6b, 9, 11b, 12b, 18, 24b, 36, 48, 54
+ *	Preamble: Short required
+ *	Shortslot: On and required
+ * GMODE_LRS
+ *	Rateset: 1b, 2b, 5.5b, 11b
+ *	Extended Rateset: 6, 9, 12, 18, 24, 36, 48, 54
+ *	Preamble: Long
+ *	Shortslot: Auto
  */
 #define GMODE_LEGACY_B		0
 #define GMODE_AUTO		1
@@ -488,12 +515,18 @@ extern const u8 wme_fifo2ac[];
 #define BRCMS_N_SGI_40			0x02
 
 /* defines used by the nrate iovar */
-#define NRATE_MCS_INUSE	0x00000080	/* MSC in use,indicates b0-6 holds an mcs */
-#define NRATE_RATE_MASK 0x0000007f	/* rate/mcs value */
-#define NRATE_STF_MASK	0x0000ff00	/* stf mode mask: siso, cdd, stbc, sdm */
-#define NRATE_STF_SHIFT	8	/* stf mode shift */
-#define NRATE_OVERRIDE	0x80000000	/* bit indicates override both rate & mode */
-#define NRATE_OVERRIDE_MCS_ONLY 0x40000000	/* bit indicate to override mcs only */
+/* MSC in use,indicates b0-6 holds an mcs */
+#define NRATE_MCS_INUSE	0x00000080
+/* rate/mcs value */
+#define NRATE_RATE_MASK 0x0000007f
+/* stf mode mask: siso, cdd, stbc, sdm */
+#define NRATE_STF_MASK	0x0000ff00
+/* stf mode shift */
+#define NRATE_STF_SHIFT	8
+/* bit indicates override both rate & mode */
+#define NRATE_OVERRIDE	0x80000000
+/* bit indicate to override mcs only */
+#define NRATE_OVERRIDE_MCS_ONLY 0x40000000
 #define NRATE_SGI_MASK  0x00800000	/* sgi mode */
 #define NRATE_SGI_SHIFT 23	/* sgi mode */
 #define NRATE_LDPC_CODING 0x00400000	/* bit indicates adv coding in use */
@@ -504,9 +537,11 @@ extern const u8 wme_fifo2ac[];
 #define NRATE_STF_STBC	2	/* stf mode STBC */
 #define NRATE_STF_SDM	3	/* stf mode SDM */
 
-#define ANT_SELCFG_MAX		4	/* max number of antenna configurations */
+/* max number of antenna configurations */
+#define ANT_SELCFG_MAX		4
 
-#define HIGHEST_SINGLE_STREAM_MCS	7	/* MCS values greater than this enable multiple streams */
+/* MCS values greater than this enable multiple streams */
+#define HIGHEST_SINGLE_STREAM_MCS	7
 
 struct brcms_antselcfg {
 	u8 ant_config[ANT_SELCFG_MAX];	/* antenna configuration */
@@ -606,7 +641,4 @@ extern bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc);
 #define BAND_2G_NAME		"2.4G"
 #define BAND_5G_NAME		"5G"
 
-/* BMAC RPC: 7 u32 params: pkttotlen, fifo, commit, fid, txpktpend, pktflag, rpc_id */
-#define BRCMS_RPCTX_PARAMS		32
-
 #endif				/* _BRCM_PUB_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index c320384..5fb0d9e 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -21,7 +21,10 @@
 #include "pub.h"
 #include "rate.h"
 
-/* Rate info per rate: It tells whether a rate is ofdm or not and its phy_rate value */
+/*
+ * Rate info per rate: It tells whether a rate is ofdm or not and its phy_rate
+ * value
+ */
 const u8 rate_info[BRCM_MAXRATE + 1] = {
 	/*  0     1     2     3     4     5     6     7     8     9 */
 /*   0 */ 0x00, 0x00, 0x0a, 0x00, 0x14, 0x00, 0x00, 0x00, 0x00, 0x00,
@@ -139,20 +142,25 @@ const struct brcms_mcs_info mcs_table[MCS_TABLE_SIZE] = {
 	{0, 6000, 0, CEIL(6000 * 10, 9), 0x00, BRCM_RATE_6M},
 };
 
-/* phycfg for legacy OFDM frames: code rate, modulation scheme, spatial streams
- *   Number of spatial streams: always 1
- *   other fields: refer to table 78 of section 17.3.2.2 of the original .11a standard
+/*
+ * phycfg for legacy OFDM frames: code rate, modulation scheme, spatial streams
+ * Number of spatial streams: always 1 other fields: refer to table 78 of
+ * section 17.3.2.2 of the original .11a standard
  */
 struct legacy_phycfg {
 	u32 rate_ofdm;	/* ofdm mac rate */
-	u8 tx_phy_ctl3;	/* phy ctl byte 3, code rate, modulation type, # of streams */
+	/* phy ctl byte 3, code rate, modulation type, # of streams */
+	u8 tx_phy_ctl3;
 };
 
-#define LEGACY_PHYCFG_TABLE_SIZE	12	/* Number of legacy_rate_cfg entries in the table */
+/* Number of legacy_rate_cfg entries in the table */
+#define LEGACY_PHYCFG_TABLE_SIZE	12
 
-/* In CCK mode LPPHY overloads OFDM Modulation bits with CCK Data Rate */
-/* Eventually MIMOPHY would also be converted to this format */
-/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
+/*
+ * In CCK mode LPPHY overloads OFDM Modulation bits with CCK Data Rate
+ * Eventually MIMOPHY would also be converted to this format
+ * 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps
+ */
 static const struct
 legacy_phycfg legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
 	{BRCM_RATE_1M, 0x00},	/* CCK  1Mbps,  data rate  0 */
@@ -181,78 +189,81 @@ legacy_phycfg legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
 
 const struct brcms_c_rateset cck_ofdm_mimo_rates = {
 	12,
-	{			/*    1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,   54 Mbps */
-	 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
-	 0x6c},
+	/*  1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48, */
+	{ 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
+	/* 54 Mbps */
+	  0x6c},
 	0x00,
-	{0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 const struct brcms_c_rateset ofdm_mimo_rates = {
 	8,
-	{			/*    6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
-	 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
+	/*  6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
+	{ 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
 	0x00,
-	{0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0xff, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 /* Default ratesets that include MCS32 for 40BW channels */
 const struct brcms_c_rateset cck_ofdm_40bw_mimo_rates = {
 	12,
-	{			/*    1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,   54 Mbps */
-	 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
-	 0x6c},
+	/*  1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48 */
+	{ 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
+	/* 54 Mbps */
+	  0x6c},
 	0x00,
-	{0xff, 0xff, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0xff, 0xff, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 const struct brcms_c_rateset ofdm_40bw_mimo_rates = {
 	8,
-	{			/*    6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
-	 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
+	/*  6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
+	{ 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
 	0x00,
-	{0xff, 0xff, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0xff, 0xff, 0xff, 0xff, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 const struct brcms_c_rateset cck_ofdm_rates = {
 	12,
-	{			/*    1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,   54 Mbps */
-	 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
-	 0x6c},
+	/*  1b,   2b, 5.5b, 6,    9,    11b,  12,   18,   24,   36,   48,*/
+	{ 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
+	/*54 Mbps */
+	  0x6c},
 	0x00,
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 const struct brcms_c_rateset gphy_legacy_rates = {
 	4,
-	{			/*    1b,   2b,   5.5b,  11b Mbps */
-	 0x82, 0x84, 0x8b, 0x96},
+	/*  1b,   2b,   5.5b, 11b Mbps */
+	{ 0x82, 0x84, 0x8b, 0x96},
 	0x00,
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 const struct brcms_c_rateset ofdm_rates = {
 	8,
-	{			/*    6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
-	 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
+	/*  6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
+	{ 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
 	0x00,
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 const struct brcms_c_rateset cck_rates = {
 	4,
-	{			/*    1b,   2b,   5.5,  11 Mbps */
-	 0x82, 0x84, 0x0b, 0x16},
+	/*  1b,   2b,   5.5,  11 Mbps */
+	{ 0x82, 0x84, 0x0b, 0x16},
 	0x00,
-	{0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-	 0x00, 0x00, 0x00, 0x00}
+	{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
 /* check if rateset is valid.
@@ -283,8 +294,9 @@ void brcms_c_rateset_mcs_upd(struct brcms_c_rateset *rs, u8 txstreams)
 		rs->mcs[i] = 0;
 }
 
-/* filter based on hardware rateset, and sort filtered rateset with basic bit(s) preserved,
- * and check if resulting rateset is valid.
+/*
+ * filter based on hardware rateset, and sort filtered rateset with basic
+ * bit(s) preserved, and check if resulting rateset is valid.
 */
 bool
 brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 9fb187e..39e1796 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -30,12 +30,18 @@ extern const struct brcms_c_rateset wlc_lrs_rates;
 extern const struct brcms_c_rateset rate_limit_1_2;
 
 struct brcms_mcs_info {
-	u32 phy_rate_20;	/* phy rate in kbps [20Mhz] */
-	u32 phy_rate_40;	/* phy rate in kbps [40Mhz] */
-	u32 phy_rate_20_sgi;	/* phy rate in kbps [20Mhz] with SGI */
-	u32 phy_rate_40_sgi;	/* phy rate in kbps [40Mhz] with SGI */
-	u8 tx_phy_ctl3;	/* phy ctl byte 3, code rate, modulation type, # of streams */
-	u8 leg_ofdm;		/* matching legacy ofdm rate in 500bkps */
+	/* phy rate in kbps [20Mhz] */
+	u32 phy_rate_20;
+	/* phy rate in kbps [40Mhz] */
+	u32 phy_rate_40;
+	/* phy rate in kbps [20Mhz] with SGI */
+	u32 phy_rate_20_sgi;
+	/* phy rate in kbps [40Mhz] with SGI */
+	u32 phy_rate_40_sgi;
+	/* phy ctl byte 3, code rate, modulation type, # of streams */
+	u8 tx_phy_ctl3;
+	/* matching legacy ofdm rate in 500bkps */
+	u8 leg_ofdm;
 };
 
 #define BRCMS_MAXMCS	32	/* max valid mcs index */
@@ -49,11 +55,18 @@ extern const struct brcms_mcs_info mcs_table[];
 #define MCS_TXS_MASK	0xc0	/* num tx streams - 1 bit mask */
 #define MCS_TXS_SHIFT	6	/* num tx streams - 1 bit shift */
 #define MCS_CR(_mcs)	(mcs_table[_mcs].tx_phy_ctl3 & MCS_CR_MASK)
-#define MCS_MOD(_mcs)	((mcs_table[_mcs].tx_phy_ctl3 & MCS_MOD_MASK) >> MCS_MOD_SHIFT)
-#define MCS_TXS(_mcs)	((mcs_table[_mcs].tx_phy_ctl3 & MCS_TXS_MASK) >> MCS_TXS_SHIFT)
+
+#define MCS_MOD(_mcs) \
+	((mcs_table[_mcs].tx_phy_ctl3 & MCS_MOD_MASK) >> MCS_MOD_SHIFT)
+
+#define MCS_TXS(_mcs) \
+	((mcs_table[_mcs].tx_phy_ctl3 & MCS_TXS_MASK) >> MCS_TXS_SHIFT)
+
 #define MCS_RATE(_mcs, _is40, _sgi)	(_sgi ? \
-	(_is40 ? mcs_table[_mcs].phy_rate_40_sgi : mcs_table[_mcs].phy_rate_20_sgi) : \
+	(_is40 ? mcs_table[_mcs].phy_rate_40_sgi : \
+		 mcs_table[_mcs].phy_rate_20_sgi) : \
 	(_is40 ? mcs_table[_mcs].phy_rate_40 : mcs_table[_mcs].phy_rate_20))
+
 #define VALID_MCS(_mcs)	((_mcs < MCS_TABLE_SIZE))
 
 /* Macro to use the rate_info table */
@@ -62,46 +75,78 @@ extern const struct brcms_mcs_info mcs_table[];
 /* convert 500kbps to bps */
 #define BRCMS_RATE_500K_TO_BPS(rate)	((rate) * 500000)
 
-/* rate spec : holds rate and mode specific information required to generate a tx frame. */
-/* Legacy CCK and OFDM information is held in the same manner as was done in the past    */
-/* (in the lower byte) the upper 3 bytes primarily hold MIMO specific information        */
+/*
+ * rate spec : holds rate and mode specific information required to generate a
+ * tx frame. Legacy CCK and OFDM information is held in the same manner as was
+ * done in the past (in the lower byte) the upper 3 bytes primarily hold MIMO
+ * specific information
+ */
 
 /* rate spec bit fields */
-#define RSPEC_RATE_MASK		0x0000007F	/* Either 500Kbps units or MIMO MCS idx */
-#define RSPEC_MIMORATE		0x08000000	/* mimo MCS is stored in RSPEC_RATE_MASK */
-#define RSPEC_BW_MASK		0x00000700	/* mimo bw mask */
-#define RSPEC_BW_SHIFT		8	/* mimo bw shift */
-#define RSPEC_STF_MASK		0x00003800	/* mimo Space/Time/Frequency mode mask */
-#define RSPEC_STF_SHIFT		11	/* mimo Space/Time/Frequency mode shift */
-#define RSPEC_CT_MASK		0x0000C000	/* mimo coding type mask */
-#define RSPEC_CT_SHIFT		14	/* mimo coding type shift */
-#define RSPEC_STC_MASK		0x00300000	/* mimo num STC streams per PLCP defn. */
-#define RSPEC_STC_SHIFT		20	/* mimo num STC streams per PLCP defn. */
-#define RSPEC_LDPC_CODING	0x00400000	/* mimo bit indicates adv coding in use */
-#define RSPEC_SHORT_GI		0x00800000	/* mimo bit indicates short GI in use */
-#define RSPEC_OVERRIDE		0x80000000	/* bit indicates override both rate & mode */
-#define RSPEC_OVERRIDE_MCS_ONLY 0x40000000	/* bit indicates override rate only */
+
+/* Either 500Kbps units or MIMO MCS idx */
+#define RSPEC_RATE_MASK		0x0000007F
+/* mimo MCS is stored in RSPEC_RATE_MASK */
+#define RSPEC_MIMORATE		0x08000000
+/* mimo bw mask */
+#define RSPEC_BW_MASK		0x00000700
+/* mimo bw shift */
+#define RSPEC_BW_SHIFT		8
+/* mimo Space/Time/Frequency mode mask */
+#define RSPEC_STF_MASK		0x00003800
+/* mimo Space/Time/Frequency mode shift */
+#define RSPEC_STF_SHIFT		11
+/* mimo coding type mask */
+#define RSPEC_CT_MASK		0x0000C000
+/* mimo coding type shift */
+#define RSPEC_CT_SHIFT		14
+/* mimo num STC streams per PLCP defn. */
+#define RSPEC_STC_MASK		0x00300000
+/* mimo num STC streams per PLCP defn. */
+#define RSPEC_STC_SHIFT		20
+/* mimo bit indicates adv coding in use */
+#define RSPEC_LDPC_CODING	0x00400000
+/* mimo bit indicates short GI in use */
+#define RSPEC_SHORT_GI		0x00800000
+/* bit indicates override both rate & mode */
+#define RSPEC_OVERRIDE		0x80000000
+/* bit indicates override rate only */
+#define RSPEC_OVERRIDE_MCS_ONLY 0x40000000
 
 #define BRCMS_HTPHY		127	/* HT PHY Membership */
 
 #define RSPEC_ACTIVE(rspec)	(rspec & (RSPEC_RATE_MASK | RSPEC_MIMORATE))
-#define RSPEC2RATE(rspec)	((rspec & RSPEC_MIMORATE) ? \
-	MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), RSPEC_ISSGI(rspec)) : \
+
+#define RSPEC2RATE(rspec) \
+	((rspec & RSPEC_MIMORATE) ? \
+	MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), \
+		  RSPEC_ISSGI(rspec)) : \
 	(rspec & RSPEC_RATE_MASK))
+
 /* return rate in unit of 500Kbps -- for internal use in wlc_rate_sel.c */
-#define RSPEC2RATE500K(rspec)	((rspec & RSPEC_MIMORATE) ? \
-		MCS_RATE((rspec & RSPEC_RATE_MASK), state->is40bw, RSPEC_ISSGI(rspec))/500 : \
-		(rspec & RSPEC_RATE_MASK))
-#define CRSPEC2RATE500K(rspec)	((rspec & RSPEC_MIMORATE) ? \
-		MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), RSPEC_ISSGI(rspec))/500 :\
-		(rspec & RSPEC_RATE_MASK))
-
-#define RSPEC2KBPS(rspec)	(IS_MCS(rspec) ? RSPEC2RATE(rspec) : RSPEC2RATE(rspec)*500)
+#define RSPEC2RATE500K(rspec) \
+	((rspec & RSPEC_MIMORATE) ? \
+	 MCS_RATE((rspec & RSPEC_RATE_MASK), state->is40bw, \
+		   RSPEC_ISSGI(rspec))/500 : \
+	(rspec & RSPEC_RATE_MASK))
+
+#define CRSPEC2RATE500K(rspec) \
+	((rspec & RSPEC_MIMORATE) ? \
+	 MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), \
+		   RSPEC_ISSGI(rspec))/500 :\
+	(rspec & RSPEC_RATE_MASK))
+
+#define RSPEC2KBPS(rspec) \
+	(IS_MCS(rspec) ? RSPEC2RATE(rspec) : RSPEC2RATE(rspec)*500)
+
 #define RSPEC_PHYTXBYTE2(rspec)	((rspec & 0xff00) >> 8)
+
 #define RSPEC_GET_BW(rspec)	((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT)
-#define RSPEC_IS40MHZ(rspec)	((((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT) == \
-				PHY_TXC1_BW_40MHZ) || (((rspec & RSPEC_BW_MASK) >> \
-				RSPEC_BW_SHIFT) == PHY_TXC1_BW_40MHZ_DUP))
+
+#define RSPEC_IS40MHZ(rspec) \
+	((((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT) == PHY_TXC1_BW_40MHZ) || \
+	 (((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT) == PHY_TXC1_BW_40MHZ_DUP))
+
 #define RSPEC_ISSGI(rspec)	((rspec & RSPEC_SHORT_GI) == RSPEC_SHORT_GI)
 #define RSPEC_MIMOPLCP3(rspec)	((rspec & 0xf00000) >> 16)
 #define PLCP3_ISSGI(plcp)	(plcp & (RSPEC_SHORT_GI >> 16))
@@ -113,24 +158,33 @@ extern const struct brcms_mcs_info mcs_table[];
 
 /* Rate info table; takes a legacy rate or u32 */
 #define	IS_MCS(r)	(r & RSPEC_MIMORATE)
+
 #define	IS_OFDM(r)	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & \
 					BRCMS_RATE_FLAG))
+
 #define	IS_CCK(r)	(!IS_MCS(r) && ( \
 			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_1M || \
 			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_2M || \
 			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_5M5 || \
 			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_11M))
-#define IS_SINGLE_STREAM(mcs)	(((mcs) <= HIGHEST_SINGLE_STREAM_MCS) || ((mcs) == 32))
+
+#define IS_SINGLE_STREAM(mcs) \
+	(((mcs) <= HIGHEST_SINGLE_STREAM_MCS) || ((mcs) == 32))
+
 #define CCK_RSPEC(cck)		((cck) & RSPEC_RATE_MASK)
+
 #define OFDM_RSPEC(ofdm)	(((ofdm) & RSPEC_RATE_MASK) |\
 	(PHY_TXC1_MODE_CDD << RSPEC_STF_SHIFT))
-#define LEGACY_RSPEC(rate)	(IS_CCK(rate) ? CCK_RSPEC(rate) : OFDM_RSPEC(rate))
+
+#define LEGACY_RSPEC(rate) \
+	(IS_CCK(rate) ? CCK_RSPEC(rate) : OFDM_RSPEC(rate))
 
 #define MCS_RSPEC(mcs)		(((mcs) & RSPEC_RATE_MASK) | RSPEC_MIMORATE | \
 	(IS_SINGLE_STREAM(mcs) ? (PHY_TXC1_MODE_CDD << RSPEC_STF_SHIFT) : \
 	(PHY_TXC1_MODE_SDM << RSPEC_STF_SHIFT)))
 
-/* Convert encoded rate value in plcp header to numerical rates in 500 KHz increments */
+/* Convert encoded rate value in plcp header to numerical rates in 500 KHz
+ * increments */
 extern const u8 ofdm_rate_lookup[];
 #define OFDM_PHY2MAC_RATE(rlpt)		(ofdm_rate_lookup[rlpt & 0x7])
 #define CCK_PHY2MAC_RATE(signal)	(signal/5)
@@ -140,7 +194,8 @@ extern const u8 ofdm_rate_lookup[];
 #define BRCMS_RATES_CCK		1
 #define BRCMS_RATES_OFDM		2
 
-/* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
+/* sanitize, and sort a rateset with the basic bit(s) preserved, validate
+ * rateset */
 extern bool
 brcms_c_rate_hwrs_filter_sort_validate(struct brcms_c_rateset *rs,
 				       const struct brcms_c_rateset *hw_rs,
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index d6c8328..22ef8e8 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -23,13 +23,15 @@
 #include "types.h"
 
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
+
 /* structure to store per-tid state for the ampdu initiator */
 struct scb_ampdu_tid_ini {
-	u8 tx_in_transit;	/* number of pending mpdus in transit in driver */
-	u8 tid;		/* initiator tid for easy lookup */
-	u8 txretry[AMPDU_TX_BA_MAX_WSIZE];	/* tx retry count; indexed by seq modulo */
-	struct scb *scb;	/* backptr for easy lookup */
-	u8 ba_wsize;		/* negotiated ba window size (in pdu) */
+	u8 tx_in_transit; /* number of pending mpdus in transit in driver */
+	u8 tid;		  /* initiator tid for easy lookup */
+	/* tx retry count; indexed by seq modulo */
+	u8 txretry[AMPDU_TX_BA_MAX_WSIZE];
+	struct scb *scb;  /* backptr for easy lookup */
+	u8 ba_wsize;	  /* negotiated ba window size (in pdu) */
 };
 
 #define AMPDU_MAX_SCB_TID	NUMPRIO
@@ -43,9 +45,10 @@ struct scb_ampdu {
 	u32 max_rx_ampdu_bytes;	/* max ampdu rcv length; 8k, 16k, 32k, 64k */
 	struct pktq txq;	/* sdu transmit queue pending aggregation */
 
-	/* This could easily be a ini[] pointer and we keep this info in wl itself instead
-	 * of having mac80211 hold it for us.  Also could be made dynamic per tid instead of
-	 * static.
+	/*
+	 * This could easily be a ini[] pointer and we keep this info in wl
+	 * itself instead of having mac80211 hold it for us. Also could be made
+	 * dynamic per tid instead of static.
 	 */
 	/* initiator info - per tid (NUMPRIO): */
 	struct scb_ampdu_tid_ini ini[AMPDU_MAX_SCB_TID];
@@ -56,18 +59,18 @@ struct scb_ampdu {
 /* station control block - one per remote MAC address */
 struct scb {
 	u32 magic;
-	u32 flags;		/* various bit flags as defined below */
-	u32 flags2;		/* various bit flags2 as defined below */
-	u8 state;		/* current state bitfield of auth/assoc process */
+	u32 flags;	/* various bit flags as defined below */
+	u32 flags2;	/* various bit flags2 as defined below */
+	u8 state;	/* current state bitfield of auth/assoc process */
 	u8 ea[ETH_ALEN];	/* station address */
 	void *fragbuf[NUMPRIO];	/* defragmentation buffer per prio */
-	uint fragresid[NUMPRIO];	/* #bytes unused in frag buffer per prio */
+	uint fragresid[NUMPRIO];/* #bytes unused in frag buffer per prio */
 
 	u16 seqctl[NUMPRIO];	/* seqctl of last received frame (for dups) */
-	u16 seqctl_nonqos;	/* seqctl of last received frame (for dups) for
-				 * non-QoS data and management
-				 */
-	u16 seqnum[NUMPRIO];	/* WME: driver maintained sw seqnum per priority */
+	/* seqctl of last received frame (for dups) for non-QoS data and
+	 * management */
+	u16 seqctl_nonqos;
+	u16 seqnum[NUMPRIO];/* WME: driver maintained sw seqnum per priority */
 
 	struct scb_ampdu scb_ampdu;	/* AMPDU state including per tid info */
 };
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index bef43ea..40a3156 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -33,8 +33,10 @@
 	((u8 *)curmap + PCI_BAR0_SPROM_OFFSET))
 
 #if defined(BCMDBG)
-#define WRITE_ENABLE_DELAY	500	/* 500 ms after write enable/disable toggle */
-#define WRITE_WORD_DELAY	20	/* 20 ms between each word write */
+/* 500 ms after write enable/disable toggle */
+#define WRITE_ENABLE_DELAY	500
+/* 20 ms between each word write */
+#define WRITE_WORD_DELAY	20
 #endif
 
 /* Maximum srom: 6 Kilobits == 768 bytes */
@@ -260,7 +262,8 @@
 /* Temp sense related entries */
 #define SROM8_MPWR_RAWTS		90
 #define SROM8_TS_SLP_OPT_CORRX	91
-/* FOC: freiquency offset correction, HWIQ: H/W IOCAL enable, IQSWP: IQ CAL swap disable */
+/* FOC: freiquency offset correction, HWIQ: H/W IOCAL enable,
+ * IQSWP: IQ CAL swap disable */
 #define SROM8_FOC_HWIQ_IQSWP	92
 
 /* Temperature delta for PHY calibration */
@@ -349,14 +352,17 @@
 #define SROM9_PO_LOFDM40DUP	203
 
 /* SROM flags (see sromvar_t) */
-#define SRFL_MORE	1	/* value continues as described by the next entry */
+
+/* value continues as described by the next entry */
+#define SRFL_MORE	1
 #define	SRFL_NOFFS	2	/* value bits can't be all one's */
 #define	SRFL_PRHEX	4	/* value is in hexdecimal format */
 #define	SRFL_PRSIGN	8	/* value is in signed decimal format */
 #define	SRFL_CCODE	0x10	/* value is in country code format */
 #define	SRFL_ETHADDR	0x20	/* value is an Ethernet address */
 #define SRFL_LEDDC	0x40	/* value is an LED duty cycle */
-#define SRFL_NOVAR	0x80	/* do not generate a nvram param, entry is for mfgc */
+/* do not generate a nvram param, entry is for mfgc */
+#define SRFL_NOVAR	0x80
 
 /* Max. nvram variable table size */
 #define	MAXSZ_NVRAM_VARS	4096
@@ -375,17 +381,18 @@ struct brcms_varbuf {
 	unsigned int size;	/* current (residual) size in bytes */
 };
 
-/* Assumptions:
- * - Ethernet address spans across 3 consective words
+/*
+ * Assumptions:
+ * - Ethernet address spans across 3 consecutive words
  *
  * Table rules:
- * - Add multiple entries next to each other if a value spans across multiple words
- *   (even multiple fields in the same word) with each entry except the last having
- *   it's SRFL_MORE bit set.
- * - Ethernet address entry does not follow above rule and must not have SRFL_MORE
- *   bit set. Its SRFL_ETHADDR bit implies it takes multiple words.
- * - The last entry's name field must be NULL to indicate the end of the table. Other
- *   entries must have non-NULL name.
+ * - Add multiple entries next to each other if a value spans across multiple
+ *   words (even multiple fields in the same word) with each entry except the
+ *   last having it's SRFL_MORE bit set.
+ * - Ethernet address entry does not follow above rule and must not have
+ *   SRFL_MORE bit set. Its SRFL_ETHADDR bit implies it takes multiple words.
+ * - The last entry's name field must be NULL to indicate the end of the table.
+ *   Other entries must have non-NULL name.
  */
 static const struct brcms_sromvar pci_sromvars[] = {
 	{"devid", 0xffffff00, SRFL_PRHEX | SRFL_NOVAR, PCI_F0DEVID, 0xffff},
@@ -810,12 +817,12 @@ static int varbuf_append(struct brcms_varbuf *b, const char *fmt, ...)
 	r = vsnprintf(b->buf, b->size, fmt, ap);
 	va_end(ap);
 
-	/* C99 snprintf behavior returns r >= size on overflow,
-	 * others return -1 on overflow.
-	 * All return -1 on format error.
-	 * We need to leave room for 2 null terminations, one for the current var
-	 * string, and one for final null of the var table. So check that the
-	 * strlen written, r, leaves room for 2 chars.
+	/*
+	 * C99 snprintf behavior returns r >= size on overflow,
+	 * others return -1 on overflow. All return -1 on format error.
+	 * We need to leave room for 2 null terminations, one for the current
+	 * var string, and one for final null of the var table. So check that
+	 * the strlen written, r, leaves room for 2 chars.
 	 */
 	if ((r == -1) || (r > (int)(b->size - 2))) {
 		b->size = 0;
@@ -902,9 +909,10 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 	if (check_crc) {
 
 		if (buf[0] == 0xffff)
-			/* The hardware thinks that an srom that starts with 0xffff
-			 * is blank, regardless of the rest of the content, so declare
-			 * it bad.
+			/*
+			 * The hardware thinks that an srom that starts with
+			 * 0xffff is blank, regardless of the rest of the
+			 * content, so declare it bad.
 			 */
 			return -ENODATA;
 
@@ -1081,8 +1089,10 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 			 *(oncount >> 24) (offcount >> 8)
 			 */
 			else if (flags & SRFL_LEDDC) {
-				u32 w32 = (((val >> 8) & 0xff) << 24) |	/* oncount */
-				    (((val & 0xff)) << 8);	/* offcount */
+				u32 w32 = /* oncount */
+					  (((val >> 8) & 0xff) << 24) |
+					  /* offcount */
+					  (((val & 0xff)) << 8);
 				varbuf_append(b, "leddc=%d", w32);
 			} else if (flags & SRFL_PRHEX)
 				varbuf_append(b, "%s=0x%x", name, val);
@@ -1116,7 +1126,6 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 				if (pb + srv->off < off)
 					continue;
 
-				/* This entry is for mfgc only. Don't generate param for it, */
 				if (srv->flags & SRFL_NOVAR)
 					continue;
 
@@ -1124,8 +1133,8 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 				val = (w & srv->mask) >> mask_shift(srv->mask);
 				width = mask_width(srv->mask);
 
-				/* Cheating: no per-path var is more than 1 word */
-
+				/* Cheating: no per-path var is more than
+				 * 1 word */
 				if ((srv->flags & SRFL_NOFFS)
 				    && ((int)val == (1 << width) - 1))
 					continue;
@@ -1203,7 +1212,10 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 		/* Bitmask for the sromrev */
 		sr = 1 << sromrev;
 
-		/* srom version check: Current valid versions: 1, 2, 3, 4, 5, 8, 9 */
+		/*
+		 * srom version check: Current valid versions: 1, 2, 3, 4, 5, 8,
+		 * 9
+		 */
 		if ((sr & 0x33e) == 0) {
 			err = -EINVAL;
 			goto errout;
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 709c9a3..a4c5c63 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -68,7 +68,10 @@ static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 	}
 }
 
-/* every WLC_TEMPSENSE_PERIOD seconds temperature check to decide whether to turn on/off txchain */
+/*
+ * every WLC_TEMPSENSE_PERIOD seconds temperature check to decide whether to
+ * turn on/off txchain.
+ */
 void brcms_c_tempsense_upd(struct brcms_c_info *wlc)
 {
 	struct brcms_phy_pub *pi = wlc->band->pi;
@@ -117,16 +120,19 @@ brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 
 	/* criteria to choose stf mode */
 
-	/* the "+3dbm (12 0.25db units)" is to account for the fact that with CDD, tx occurs
-	 * on both chains
+	/*
+	 * the "+3dbm (12 0.25db units)" is to account for the fact that with
+	 * CDD, tx occurs on both chains
 	 */
 	if (power.target[siso_mcs_id] > (power.target[cdd_mcs_id] + 12))
 		setbit(ss_algo_channel, PHY_TXC1_MODE_SISO);
 	else
 		setbit(ss_algo_channel, PHY_TXC1_MODE_CDD);
 
-	/* STBC is ORed into to algo channel as STBC requires per-packet SCB capability check
-	 * so cannot be default mode of operation. One of SISO, CDD have to be set
+	/*
+	 * STBC is ORed into to algo channel as STBC requires per-packet SCB
+	 * capability check so cannot be default mode of operation. One of
+	 * SISO, CDD have to be set
 	 */
 	if (power.target[siso_mcs_id] <= (power.target[stbc_mcs_id] + 12))
 		setbit(ss_algo_channel, PHY_TXC1_MODE_STBC);
@@ -229,7 +235,10 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 	    || !(txchain & wlc->stf->hw_txchain))
 		return -EINVAL;
 
-	/* if nrate override is configured to be non-SISO STF mode, reject reducing txchain to 1 */
+	/*
+	 * if nrate override is configured to be non-SISO STF mode, reject
+	 * reducing txchain to 1
+	 */
 	txstreams = (u8) BRCMS_BITSCNT(txchain);
 	if (txstreams > MAX_STREAMS_SUPPORTED)
 		return -EINVAL;
@@ -282,7 +291,10 @@ int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 	return 0;
 }
 
-/* update wlc->stf->ss_opmode which represents the operational stf_ss mode we're using */
+/*
+ * update wlc->stf->ss_opmode which represents the operational stf_ss mode
+ * we're using
+ */
 int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 {
 	int ret_code = 0;
@@ -291,7 +303,10 @@ int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_band *band)
 
 	prev_stf_ss = wlc->stf->ss_opmode;
 
-	/* NOTE: opmode can only be SISO or CDD as STBC is decided on a per-packet basis */
+	/*
+	 * NOTE: opmode can only be SISO or CDD as STBC is decided on a
+	 * per-packet basis
+	 */
 	if (BRCMS_STBC_CAP_PHY(wlc) &&
 	    wlc->stf->ss_algosel_auto
 	    && (wlc->stf->ss_algo_channel != (u16) -1)) {
@@ -333,7 +348,8 @@ int brcms_c_stf_attach(struct brcms_c_info *wlc)
 
 	if (BRCMS_STBC_CAP_PHY(wlc)) {
 		wlc->stf->ss_algosel_auto = true;
-		wlc->stf->ss_algo_channel = (u16) -1;	/* Init the default value */
+		/* Init the default value */
+		wlc->stf->ss_algo_channel = (u16) -1;
 	}
 	return 0;
 }
@@ -343,18 +359,20 @@ void brcms_c_stf_detach(struct brcms_c_info *wlc)
 }
 
 /*
- * Centralized txant update function. call it whenever wlc->stf->txant and/or wlc->stf->txchain
- *  change
+ * Centralized txant update function. call it whenever wlc->stf->txant and/or
+ * wlc->stf->txchain change.
  *
  * Antennas are controlled by ucode indirectly, which drives PHY or GPIO to
- *   achieve various tx/rx antenna selection schemes
+ * achieve various tx/rx antenna selection schemes
  *
- * legacy phy, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7 means auto(last rx)
- * for NREV<3, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7 means last rx and
- *    do tx-antenna selection for SISO transmissions
- * for NREV=3, bit 6 and bit _8_ means antenna 0 and 1 respectively, bit6+bit7 means last rx and
- *    do tx-antenna selection for SISO transmissions
- * for NREV>=7, bit 6 and bit 7 mean antenna 0 and 1 respectively, nit6+bit7 means both cores active
+ * legacy phy, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7
+ * means auto(last rx).
+ * for NREV<3, bit 6 and bit 7 means antenna 0 and 1 respectively, bit6+bit7
+ * means last rx and do tx-antenna selection for SISO transmissions
+ * for NREV=3, bit 6 and bit _8_ means antenna 0 and 1 respectively, bit6+bit7
+ * means last rx and do tx-antenna selection for SISO transmissions
+ * for NREV>=7, bit 6 and bit 7 mean antenna 0 and 1 respectively, nit6+bit7
+ * means both cores active
 */
 static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index ab97718..360795f 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -37,42 +37,71 @@
 #define MAX_DMA_SEGS 4
 
 /* boardflags */
-#define	BFL_PACTRL		0x00000002	/* Board has gpio 9 controlling the PA */
-#define	BFL_NOPLLDOWN		0x00000020	/* Not ok to power down the chip pll and oscillator */
-#define BFL_FEM			0x00000800	/* Board supports the Front End Module */
-#define BFL_EXTLNA		0x00001000	/* Board has an external LNA in 2.4GHz band */
-#define BFL_NOPA		0x00010000	/* Board has no PA */
-#define BFL_BUCKBOOST		0x00200000	/* Power topology uses BUCKBOOST */
-#define BFL_FEM_BT		0x00400000	/* Board has FEM and switch to share antenna w/ BT */
-#define BFL_NOCBUCK		0x00800000	/* Power topology doesn't use CBUCK */
-#define BFL_PALDO		0x02000000	/* Power topology uses PALDO */
-#define BFL_EXTLNA_5GHz		0x10000000	/* Board has an external LNA in 5GHz band */
+
+/* Board has gpio 9 controlling the PA */
+#define	BFL_PACTRL		0x00000002
+/* Not ok to power down the chip pll and oscillator */
+#define	BFL_NOPLLDOWN		0x00000020
+/* Board supports the Front End Module */
+#define BFL_FEM			0x00000800
+/* Board has an external LNA in 2.4GHz band */
+#define BFL_EXTLNA		0x00001000
+/* Board has no PA */
+#define BFL_NOPA		0x00010000
+/* Power topology uses BUCKBOOST */
+#define BFL_BUCKBOOST		0x00200000
+/* Board has FEM and switch to share antenna w/ BT */
+#define BFL_FEM_BT		0x00400000
+/* Power topology doesn't use CBUCK */
+#define BFL_NOCBUCK		0x00800000
+/* Power topology uses PALDO */
+#define BFL_PALDO		0x02000000
+/* Board has an external LNA in 5GHz band */
+#define BFL_EXTLNA_5GHz		0x10000000
 
 /* boardflags2 */
-#define BFL2_RXBB_INT_REG_DIS	0x00000001	/* Board has an external rxbb regulator */
-#define BFL2_APLL_WAR		0x00000002	/* Flag to implement alternative A-band PLL settings */
-#define BFL2_TXPWRCTRL_EN	0x00000004	/* Board permits enabling TX Power Control */
-#define BFL2_2X4_DIV		0x00000008	/* Board supports the 2X4 diversity switch */
-#define BFL2_5G_PWRGAIN		0x00000010	/* Board supports 5G band power gain */
-#define BFL2_PCIEWAR_OVR	0x00000020	/* Board overrides ASPM and Clkreq settings */
+
+/* Board has an external rxbb regulator */
+#define BFL2_RXBB_INT_REG_DIS	0x00000001
+/* Flag to implement alternative A-band PLL settings */
+#define BFL2_APLL_WAR		0x00000002
+/* Board permits enabling TX Power Control */
+#define BFL2_TXPWRCTRL_EN	0x00000004
+/* Board supports the 2X4 diversity switch */
+#define BFL2_2X4_DIV		0x00000008
+/* Board supports 5G band power gain */
+#define BFL2_5G_PWRGAIN		0x00000010
+/* Board overrides ASPM and Clkreq settings */
+#define BFL2_PCIEWAR_OVR	0x00000020
 #define BFL2_LEGACY		0x00000080
-#define BFL2_SKWRKFEM_BRD	0x00000100	/* 4321mcm93 board uses Skyworks FEM */
-#define BFL2_SPUR_WAR		0x00000200	/* Board has a WAR for clock-harmonic spurs */
-#define BFL2_GPLL_WAR		0x00000400	/* Flag to narrow G-band PLL loop b/w */
-#define BFL2_SINGLEANT_CCK	0x00001000	/* Tx CCK pkts on Ant 0 only */
-#define BFL2_2G_SPUR_WAR	0x00002000	/* WAR to reduce and avoid clock-harmonic spurs in 2G */
-#define BFL2_GPLL_WAR2	        0x00010000	/* Flag to widen G-band PLL loop b/w */
+/* 4321mcm93 board uses Skyworks FEM */
+#define BFL2_SKWRKFEM_BRD	0x00000100
+/* Board has a WAR for clock-harmonic spurs */
+#define BFL2_SPUR_WAR		0x00000200
+/* Flag to narrow G-band PLL loop b/w */
+#define BFL2_GPLL_WAR		0x00000400
+/* Tx CCK pkts on Ant 0 only */
+#define BFL2_SINGLEANT_CCK	0x00001000
+/* WAR to reduce and avoid clock-harmonic spurs in 2G */
+#define BFL2_2G_SPUR_WAR	0x00002000
+/* Flag to widen G-band PLL loop b/w */
+#define BFL2_GPLL_WAR2	        0x00010000
 #define BFL2_IPALVLSHIFT_3P3    0x00020000
-#define BFL2_INTERNDET_TXIQCAL  0x00040000	/* Use internal envelope detector for TX IQCAL */
-#define BFL2_XTALBUFOUTEN       0x00080000	/* Keep the buffered Xtal output from radio "ON"
-						 * Most drivers will turn it off without this flag
-						 * to save power.
-						 */
+/* Use internal envelope detector for TX IQCAL */
+#define BFL2_INTERNDET_TXIQCAL  0x00040000
+/* Keep the buffered Xtal output from radio "ON". Most drivers will turn it
+ * off without this flag to save power. */
+#define BFL2_XTALBUFOUTEN       0x00080000
+
+/*
+ * board specific GPIO assignment, gpio 0-3 are also customer-configurable
+ * led
+ */
 
-/* board specific GPIO assignment, gpio 0-3 are also customer-configurable led */
-#define	BOARD_GPIO_PACTRL	0x200	/* bit 9 controls the PA on new 4306 boards */
-#define BOARD_GPIO_12		0x1000	/* gpio 12 */
-#define BOARD_GPIO_13		0x2000	/* gpio 13 */
+/* bit 9 controls the PA on new 4306 boards */
+#define	BOARD_GPIO_PACTRL	0x200
+#define BOARD_GPIO_12		0x1000
+#define BOARD_GPIO_13		0x2000
 
 /* **** Core type/rev defaults **** */
 #define D11CONF		0x0fffffb0	/* Supported  D11 revs: 4, 5, 7-27
@@ -152,25 +181,53 @@
 #define PHYCONF_HAS(val) CONF_HAS(PHYTYPE, val)
 #define PHYCONF_IS(val)	CONF_IS(PHYTYPE, val)
 
-#define NREV_IS(var, val)	(NCONF_HAS(val) && (NCONF_IS(val) || ((var) == (val))))
-#define NREV_GE(var, val)	(NCONF_GE(val) && (!NCONF_LT(val) || ((var) >= (val))))
-#define NREV_GT(var, val)	(NCONF_GT(val) && (!NCONF_LE(val) || ((var) > (val))))
-#define NREV_LT(var, val)	(NCONF_LT(val) && (!NCONF_GE(val) || ((var) < (val))))
-#define NREV_LE(var, val)	(NCONF_LE(val) && (!NCONF_GT(val) || ((var) <= (val))))
+#define NREV_IS(var, val) \
+	(NCONF_HAS(val) && (NCONF_IS(val) || ((var) == (val))))
+
+#define NREV_GE(var, val) \
+	(NCONF_GE(val) && (!NCONF_LT(val) || ((var) >= (val))))
+
+#define NREV_GT(var, val) \
+	(NCONF_GT(val) && (!NCONF_LE(val) || ((var) > (val))))
+
+#define NREV_LT(var, val) \
+	(NCONF_LT(val) && (!NCONF_GE(val) || ((var) < (val))))
+
+#define NREV_LE(var, val) \
+	(NCONF_LE(val) && (!NCONF_GT(val) || ((var) <= (val))))
+
+#define LCNREV_IS(var, val) \
+	(LCNCONF_HAS(val) && (LCNCONF_IS(val) || ((var) == (val))))
 
-#define LCNREV_IS(var, val)	(LCNCONF_HAS(val) && (LCNCONF_IS(val) || ((var) == (val))))
-#define LCNREV_GE(var, val)	(LCNCONF_GE(val) && (!LCNCONF_LT(val) || ((var) >= (val))))
-#define LCNREV_GT(var, val)	(LCNCONF_GT(val) && (!LCNCONF_LE(val) || ((var) > (val))))
-#define LCNREV_LT(var, val)	(LCNCONF_LT(val) && (!LCNCONF_GE(val) || ((var) < (val))))
-#define LCNREV_LE(var, val)	(LCNCONF_LE(val) && (!LCNCONF_GT(val) || ((var) <= (val))))
+#define LCNREV_GE(var, val) \
+	(LCNCONF_GE(val) && (!LCNCONF_LT(val) || ((var) >= (val))))
 
-#define D11REV_IS(var, val)	(D11CONF_HAS(val) && (D11CONF_IS(val) || ((var) == (val))))
-#define D11REV_GE(var, val)	(D11CONF_GE(val) && (!D11CONF_LT(val) || ((var) >= (val))))
-#define D11REV_GT(var, val)	(D11CONF_GT(val) && (!D11CONF_LE(val) || ((var) > (val))))
-#define D11REV_LT(var, val)	(D11CONF_LT(val) && (!D11CONF_GE(val) || ((var) < (val))))
-#define D11REV_LE(var, val)	(D11CONF_LE(val) && (!D11CONF_GT(val) || ((var) <= (val))))
+#define LCNREV_GT(var, val) \
+	(LCNCONF_GT(val) && (!LCNCONF_LE(val) || ((var) > (val))))
 
-#define PHYTYPE_IS(var, val)	(PHYCONF_HAS(val) && (PHYCONF_IS(val) || ((var) == (val))))
+#define LCNREV_LT(var, val) \
+	(LCNCONF_LT(val) && (!LCNCONF_GE(val) || ((var) < (val))))
+
+#define LCNREV_LE(var, val) \
+	(LCNCONF_LE(val) && (!LCNCONF_GT(val) || ((var) <= (val))))
+
+#define D11REV_IS(var, val) \
+	(D11CONF_HAS(val) && (D11CONF_IS(val) || ((var) == (val))))
+
+#define D11REV_GE(var, val) \
+	(D11CONF_GE(val) && (!D11CONF_LT(val) || ((var) >= (val))))
+
+#define D11REV_GT(var, val) \
+	(D11CONF_GT(val) && (!D11CONF_LE(val) || ((var) > (val))))
+
+#define D11REV_LT(var, val) \
+	(D11CONF_LT(val) && (!D11CONF_GE(val) || ((var) < (val))))
+
+#define D11REV_LE(var, val) \
+	(D11CONF_LE(val) && (!D11CONF_GT(val) || ((var) <= (val))))
+
+#define PHYTYPE_IS(var, val)\
+	(PHYCONF_HAS(val) && (PHYCONF_IS(val) || ((var) == (val))))
 
 /* Finally, early-exit from switch case if anyone wants it... */
 
@@ -213,11 +270,18 @@
  *
  * ***********************************************
  */
-#define NTXD		256	/* Max # of entries in Tx FIFO based on 4kb page size */
-#define NRXD		256	/* Max # of entries in Rx FIFO based on 4kb page size */
-#define	NRXBUFPOST	32	/* try to keep this # rbufs posted to the chip */
-#define MAXSCB		32	/* Maximum SCBs in cache for STA */
-#define AMPDU_NUM_MPDU		16	/* max allowed number of mpdus in an ampdu (2 streams) */
+
+/* Max # of entries in Tx FIFO based on 4kb page size */
+#define NTXD		256
+/* Max # of entries in Rx FIFO based on 4kb page size */
+#define NRXD		256
+/* try to keep this # rbufs posted to the chip */
+#define	NRXBUFPOST	32
+/* Maximum SCBs in cache for STA */
+#define MAXSCB		32
+
+/* max allowed number of mpdus in an ampdu (2 streams) */
+#define AMPDU_NUM_MPDU		16
 
 /* Count of packet callback structures. either of following
  * 1. Set to the number of SCBs since a STA
@@ -242,8 +306,8 @@
 #define BRCMS_AMPDUDATAHIWAT 255
 
 /* bounded rx loops */
-#define RXBND		8	/* max # frames to process in brcms_c_recv() */
-#define TXSBND		8	/* max # tx status to process in wlc_txstatus() */
+#define RXBND		8 /* max # frames to process in brcms_c_recv() */
+#define TXSBND		8 /* max # tx status to process in wlc_txstatus() */
 
 #define BAND_5G(bt)	((bt) == BRCM_BAND_5G)
 #define BAND_2G(bt)	((bt) == BRCM_BAND_2G)
@@ -351,9 +415,13 @@ do {						\
 		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
 
 /* multi-bool data type: set of bools, mbool is true if any is set */
-#define mboolset(mb, bit)		((mb) |= (bit))	/* set one bool */
-#define mboolclr(mb, bit)		((mb) &= ~(bit))	/* clear one bool */
-#define mboolisset(mb, bit)		(((mb) & (bit)) != 0)	/* true if one bool is set */
+
+/* set one bool */
+#define mboolset(mb, bit)		((mb) |= (bit))
+/* clear one bool */
+#define mboolclr(mb, bit)		((mb) &= ~(bit))
+/* true if one bool is set */
+#define mboolisset(mb, bit)		(((mb) & (bit)) != 0)
 #define	mboolmaskset(mb, mask, val)	((mb) = (((mb) & ~(mask)) | (val)))
 
 /* forward declarations */
-- 
1.7.4.1


