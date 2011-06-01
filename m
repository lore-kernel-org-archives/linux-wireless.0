Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4876 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161416Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 34/83] staging: brcm80211: cleaned sb* header files
Date: Wed, 1 Jun 2011 13:45:19 +0200
Message-ID: <1306928768-7501-34-git-send-email-rvossen@broadcom.com> (sfid-20110601_134946_694930_638AB725)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmchip.h       |    6 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   86 ++
 .../brcm80211/{include => brcmfmac}/sbsdio.h       |    0
 .../brcm80211/{include => brcmfmac}/sbsdpcmdev.h   |   23 +-
 .../staging/brcm80211/{include => brcmfmac}/sdio.h |    0
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  128 ++
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |   46 +
 drivers/staging/brcm80211/brcmsmac/bcmotp.c        |   31 +
 drivers/staging/brcm80211/brcmsmac/d11.h           |    4 -
 drivers/staging/brcm80211/brcmsmac/dma.c           |  128 ++
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    3 +
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    4 +
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |  465 +++++++
 drivers/staging/brcm80211/include/sbchipc.h        | 1302 --------------------
 drivers/staging/brcm80211/include/sbconfig.h       |  240 ----
 drivers/staging/brcm80211/include/sbdma.h          |  268 ----
 18 files changed, 913 insertions(+), 1823 deletions(-)
 rename drivers/staging/brcm80211/{include => brcmfmac}/sbsdio.h (100%)
 rename drivers/staging/brcm80211/{include => brcmfmac}/sbsdpcmdev.h (94%)
 rename drivers/staging/brcm80211/{include => brcmfmac}/sdio.h (100%)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmchip.h b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
index c0d4c3b..08729e1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmchip.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
@@ -17,12 +17,6 @@
 #ifndef _bcmchip_h_
 #define _bcmchip_h_
 
-/* Core reg address translation */
-#define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
-#define CORE_BUS_REG(base, field)	(base + offsetof(sdpcmd_regs_t, field))
-#define CORE_SB(base, field) \
-		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
-
 /* bcm4329 */
 /* SDIO device core, ID 0x829 */
 #define BCM4329_CORE_BUS_BASE		0x18011000
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0034dcd..275fa7c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -229,6 +229,42 @@ typedef struct {
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
 
+/* sbimstate */
+#define	SBIM_IBE		0x20000	/* inbanderror */
+#define	SBIM_TO			0x40000	/* timeout */
+#define	SBIM_BY			0x01800000	/* busy (sonics >= 2.3) */
+#define	SBIM_RJ			0x02000000	/* reject (sonics >= 2.3) */
+
+/* sbtmstatelow */
+#define	SBTML_RESET		0x0001	/* reset */
+#define	SBTML_REJ_MASK		0x0006	/* reject field */
+#define	SBTML_REJ		0x0002	/* reject */
+#define	SBTML_TMPREJ		0x0004	/* temporary reject, for error recovery */
+
+#define	SBTML_SICF_SHIFT	16	/* Shift to locate the SI control flags in sbtml */
+
+/* sbtmstatehigh */
+#define	SBTMH_SERR		0x0001	/* serror */
+#define	SBTMH_INT		0x0002	/* interrupt */
+#define	SBTMH_BUSY		0x0004	/* busy */
+#define	SBTMH_TO		0x0020	/* timeout (sonics >= 2.3) */
+
+#define	SBTMH_SISF_SHIFT	16	/* Shift to locate the SI status flags in sbtmh */
+
+/* sbidlow */
+#define	SBIDL_INIT		0x80	/* initiator */
+
+/* sbidhigh */
+#define	SBIDH_RC_MASK		0x000f	/* revision code */
+#define	SBIDH_RCE_MASK		0x7000	/* revision code extension field */
+#define	SBIDH_RCE_SHIFT		8
+#define	SBCOREREV(sbidh) \
+	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | ((sbidh) & SBIDH_RC_MASK))
+#define	SBIDH_CC_MASK		0x8ff0	/* core code */
+#define	SBIDH_CC_SHIFT		4
+#define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
+#define	SBIDH_VC_SHIFT		16
+
 /*
  * Conversion of 802.1D priority to precedence level
  */
@@ -240,6 +276,12 @@ DHD_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 extern int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 			    uint len);
 
+/* Core reg address translation */
+#define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
+#define CORE_BUS_REG(base, field)	(base + offsetof(sdpcmd_regs_t, field))
+#define CORE_SB(base, field) \
+		(base + SBCONFIGOFF + offsetof(sbconfig_t, field))
+
 #ifdef DHD_DEBUG
 /* Device console log buffer state */
 typedef struct dhd_console {
@@ -406,6 +448,50 @@ typedef struct dhd_bus {
 	bool ctrl_frame_stat;
 } dhd_bus_t;
 
+#ifndef _LANGUAGE_ASSEMBLY
+
+typedef volatile struct _sbconfig {
+	u32 PAD[2];
+	u32 sbipsflag;	/* initiator port ocp slave flag */
+	u32 PAD[3];
+	u32 sbtpsflag;	/* target port ocp slave flag */
+	u32 PAD[11];
+	u32 sbtmerrloga;	/* (sonics >= 2.3) */
+	u32 PAD;
+	u32 sbtmerrlog;	/* (sonics >= 2.3) */
+	u32 PAD[3];
+	u32 sbadmatch3;	/* address match3 */
+	u32 PAD;
+	u32 sbadmatch2;	/* address match2 */
+	u32 PAD;
+	u32 sbadmatch1;	/* address match1 */
+	u32 PAD[7];
+	u32 sbimstate;	/* initiator agent state */
+	u32 sbintvec;	/* interrupt mask */
+	u32 sbtmstatelow;	/* target state */
+	u32 sbtmstatehigh;	/* target state */
+	u32 sbbwa0;		/* bandwidth allocation table0 */
+	u32 PAD;
+	u32 sbimconfiglow;	/* initiator configuration */
+	u32 sbimconfighigh;	/* initiator configuration */
+	u32 sbadmatch0;	/* address match0 */
+	u32 PAD;
+	u32 sbtmconfiglow;	/* target configuration */
+	u32 sbtmconfighigh;	/* target configuration */
+	u32 sbbconfig;	/* broadcast configuration */
+	u32 PAD;
+	u32 sbbstate;	/* broadcast state */
+	u32 PAD[3];
+	u32 sbactcnfg;	/* activate configuration */
+	u32 PAD[3];
+	u32 sbflagst;	/* current sbflags */
+	u32 PAD[3];
+	u32 sbidlow;		/* identification */
+	u32 sbidhigh;	/* identification */
+} sbconfig_t;
+
+#endif				/* _LANGUAGE_ASSEMBLY */
+
 /* clkstate */
 #define CLK_NONE	0
 #define CLK_SDONLY	1
diff --git a/drivers/staging/brcm80211/include/sbsdio.h b/drivers/staging/brcm80211/brcmfmac/sbsdio.h
similarity index 100%
rename from drivers/staging/brcm80211/include/sbsdio.h
rename to drivers/staging/brcm80211/brcmfmac/sbsdio.h
diff --git a/drivers/staging/brcm80211/include/sbsdpcmdev.h b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
similarity index 94%
rename from drivers/staging/brcm80211/include/sbsdpcmdev.h
rename to drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
index afd3581..76266db 100644
--- a/drivers/staging/brcm80211/include/sbsdpcmdev.h
+++ b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
@@ -24,6 +24,19 @@
 #define	PAD		_XSTR(__LINE__)
 #endif				/* PAD */
 
+/* dma registers per channel(xmt or rcv) */
+typedef volatile struct {
+	u32 control;		/* enable, et al */
+	u32 addr;		/* descriptor ring base address (4K aligned) */
+	u32 ptr;		/* last descriptor posted to chip */
+	u32 status;		/* current active descriptor, et al */
+} dma32regs_t;
+
+typedef volatile struct {
+	dma32regs_t xmt;	/* dma tx channel */
+	dma32regs_t rcv;	/* dma rx channel */
+} dma32regp_t;
+
 typedef volatile struct {
 	dma64regs_t xmt;	/* dma tx */
 	u32 PAD[2];
@@ -31,6 +44,14 @@ typedef volatile struct {
 	u32 PAD[2];
 } dma64p_t;
 
+
+typedef volatile struct {	/* diag access */
+	u32 fifoaddr;	/* diag address */
+	u32 fifodatalow;	/* low 32bits of data */
+	u32 fifodatahigh;	/* high 32bits of data */
+	u32 pad;		/* reserved */
+} dma64diag_t;
+
 /* dma64 sdiod corerev >= 1 */
 typedef volatile struct {
 	dma64p_t dma64regs[2];
@@ -144,7 +165,7 @@ typedef volatile struct {
 	u32 PAD[464];
 
 	/* Sonics SiliconBackplane registers */
-	sbconfig_t sbconfig;	/* SbConfig Regs, 0xf00-0xfff, rev8 */
+	u16 PAD[0x80];		/* SbConfig Regs, 0xf00-0xfff, rev8 */
 } sdpcmd_regs_t;
 
 /* corecontrol */
diff --git a/drivers/staging/brcm80211/include/sdio.h b/drivers/staging/brcm80211/brcmfmac/sdio.h
similarity index 100%
rename from drivers/staging/brcm80211/include/sdio.h
rename to drivers/staging/brcm80211/brcmfmac/sdio.h
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 73587b3..9aec084 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -35,6 +35,134 @@
 #include <bcmsrom.h>
 #include <wlc_pmu.h>
 
+/* slow_clk_ctl */
+#define SCC_SS_MASK		0x00000007	/* slow clock source mask */
+#define	SCC_SS_LPO		0x00000000	/* source of slow clock is LPO */
+#define	SCC_SS_XTAL		0x00000001	/* source of slow clock is crystal */
+#define	SCC_SS_PCI		0x00000002	/* source of slow clock is PCI */
+#define SCC_LF			0x00000200	/* LPOFreqSel, 1: 160Khz, 0: 32KHz */
+#define SCC_LP			0x00000400	/* LPOPowerDown, 1: LPO is disabled,
+						 * 0: LPO is enabled
+						 */
+#define SCC_FS			0x00000800	/* ForceSlowClk, 1: sb/cores running on slow clock,
+						 * 0: power logic control
+						 */
+#define SCC_IP			0x00001000	/* IgnorePllOffReq, 1/0: power logic ignores/honors
+						 * PLL clock disable requests from core
+						 */
+#define SCC_XC			0x00002000	/* XtalControlEn, 1/0: power logic does/doesn't
+						 * disable crystal when appropriate
+						 */
+#define SCC_XP			0x00004000	/* XtalPU (RO), 1/0: crystal running/disabled */
+#define SCC_CD_MASK		0xffff0000	/* ClockDivider (SlowClk = 1/(4+divisor)) */
+#define SCC_CD_SHIFT		16
+
+/* system_clk_ctl */
+#define	SYCC_IE			0x00000001	/* ILPen: Enable Idle Low Power */
+#define	SYCC_AE			0x00000002	/* ALPen: Enable Active Low Power */
+#define	SYCC_FP			0x00000004	/* ForcePLLOn */
+#define	SYCC_AR			0x00000008	/* Force ALP (or HT if ALPen is not set */
+#define	SYCC_HR			0x00000010	/* Force HT */
+#define SYCC_CD_MASK		0xffff0000	/* ClkDiv  (ILP = 1/(4 * (divisor + 1)) */
+#define SYCC_CD_SHIFT		16
+
+#define CST4329_SPROM_OTP_SEL_MASK	0x00000003
+#define CST4329_DEFCIS_SEL		0	/* OTP is powered up, use def. CIS, no SPROM */
+#define CST4329_SPROM_SEL		1	/* OTP is powered up, SPROM is present */
+#define CST4329_OTP_SEL			2	/* OTP is powered up, no SPROM */
+#define CST4329_OTP_PWRDN		3	/* OTP is powered down, SPROM is present */
+#define CST4329_SPI_SDIO_MODE_MASK	0x00000004
+#define CST4329_SPI_SDIO_MODE_SHIFT	2
+
+/* 43224 chip-specific ChipControl register bits */
+#define CCTRL43224_GPIO_TOGGLE          0x8000
+#define CCTRL_43224A0_12MA_LED_DRIVE    0x00F000F0	/* 12 mA drive strength */
+#define CCTRL_43224B0_12MA_LED_DRIVE    0xF0	/* 12 mA drive strength for later 43224s */
+
+/* 43236 Chip specific ChipStatus register bits */
+#define CST43236_SFLASH_MASK		0x00000040
+#define CST43236_OTP_MASK		0x00000080
+#define CST43236_HSIC_MASK		0x00000100	/* USB/HSIC */
+#define CST43236_BP_CLK			0x00000200	/* 120/96Mbps */
+#define CST43236_BOOT_MASK		0x00001800
+#define CST43236_BOOT_SHIFT		11
+#define CST43236_BOOT_FROM_SRAM		0	/* boot from SRAM, ARM in reset */
+#define CST43236_BOOT_FROM_ROM		1	/* boot from ROM */
+#define CST43236_BOOT_FROM_FLASH	2	/* boot from FLASH */
+#define CST43236_BOOT_FROM_INVALID	3
+
+/* 4331 chip-specific ChipControl register bits */
+#define CCTRL4331_BT_COEXIST		(1<<0)	/* 0 disable */
+#define CCTRL4331_SECI			(1<<1)	/* 0 SECI is disabled (JATG functional) */
+#define CCTRL4331_EXT_LNA		(1<<2)	/* 0 disable */
+#define CCTRL4331_SPROM_GPIO13_15       (1<<3)	/* sprom/gpio13-15 mux */
+#define CCTRL4331_EXTPA_EN		(1<<4)	/* 0 ext pa disable, 1 ext pa enabled */
+#define CCTRL4331_GPIOCLK_ON_SPROMCS	(1<<5)	/* set drive out GPIO_CLK on sprom_cs pin */
+#define CCTRL4331_PCIE_MDIO_ON_SPROMCS	(1<<6)	/* use sprom_cs pin as PCIE mdio interface */
+#define CCTRL4331_EXTPA_ON_GPIO2_5	(1<<7)	/* aband extpa will be at gpio2/5 and sprom_dout */
+#define CCTRL4331_OVR_PIPEAUXCLKEN	(1<<8)	/* override core control on pipe_AuxClkEnable */
+#define CCTRL4331_OVR_PIPEAUXPWRDOWN	(1<<9)	/* override core control on pipe_AuxPowerDown */
+#define CCTRL4331_PCIE_AUXCLKEN		(1<<10)	/* pcie_auxclkenable */
+#define CCTRL4331_PCIE_PIPE_PLLDOWN	(1<<11)	/* pcie_pipe_pllpowerdown */
+#define CCTRL4331_BT_SHD0_ON_GPIO4	(1<<16)	/* enable bt_shd0 at gpio4 */
+#define CCTRL4331_BT_SHD1_ON_GPIO5	(1<<17)	/* enable bt_shd1 at gpio5 */
+
+/* 4331 Chip specific ChipStatus register bits */
+#define	CST4331_XTAL_FREQ		0x00000001	/* crystal frequency 20/40Mhz */
+#define	CST4331_SPROM_PRESENT		0x00000002
+#define	CST4331_OTP_PRESENT		0x00000004
+#define	CST4331_LDO_RF			0x00000008
+#define	CST4331_LDO_PAR			0x00000010
+
+/* 4319 chip-specific ChipStatus register bits */
+#define	CST4319_SPI_CPULESSUSB		0x00000001
+#define	CST4319_SPI_CLK_POL		0x00000002
+#define	CST4319_SPI_CLK_PH		0x00000008
+#define	CST4319_SPROM_OTP_SEL_MASK	0x000000c0	/* gpio [7:6], SDIO CIS selection */
+#define	CST4319_SPROM_OTP_SEL_SHIFT	6
+#define	CST4319_DEFCIS_SEL		0x00000000	/* use default CIS, OTP is powered up */
+#define	CST4319_SPROM_SEL		0x00000040	/* use SPROM, OTP is powered up */
+#define	CST4319_OTP_SEL			0x00000080	/* use OTP, OTP is powered up */
+#define	CST4319_OTP_PWRDN		0x000000c0	/* use SPROM, OTP is powered down */
+#define	CST4319_SDIO_USB_MODE		0x00000100	/* gpio [8], sdio/usb mode */
+#define	CST4319_REMAP_SEL_MASK		0x00000600
+#define	CST4319_ILPDIV_EN		0x00000800
+#define	CST4319_XTAL_PD_POL		0x00001000
+#define	CST4319_LPO_SEL			0x00002000
+#define	CST4319_RES_INIT_MODE		0x0000c000
+#define	CST4319_PALDO_EXTPNP		0x00010000	/* PALDO is configured with external PNP */
+#define	CST4319_CBUCK_MODE_MASK		0x00060000
+#define CST4319_CBUCK_MODE_BURST	0x00020000
+#define CST4319_CBUCK_MODE_LPBURST	0x00060000
+#define	CST4319_RCAL_VALID		0x01000000
+#define	CST4319_RCAL_VALUE_MASK		0x3e000000
+#define	CST4319_RCAL_VALUE_SHIFT	25
+
+/* 4336 chip-specific ChipStatus register bits */
+#define	CST4336_SPI_MODE_MASK		0x00000001
+#define	CST4336_SPROM_PRESENT		0x00000002
+#define	CST4336_OTP_PRESENT		0x00000004
+#define	CST4336_ARMREMAP_0		0x00000008
+#define	CST4336_ILPDIV_EN_MASK		0x00000010
+#define	CST4336_ILPDIV_EN_SHIFT		4
+#define	CST4336_XTAL_PD_POL_MASK	0x00000020
+#define	CST4336_XTAL_PD_POL_SHIFT	5
+#define	CST4336_LPO_SEL_MASK		0x00000040
+#define	CST4336_LPO_SEL_SHIFT		6
+#define	CST4336_RES_INIT_MODE_MASK	0x00000180
+#define	CST4336_RES_INIT_MODE_SHIFT	7
+#define	CST4336_CBUCK_MODE_MASK		0x00000600
+#define	CST4336_CBUCK_MODE_SHIFT	9
+
+/* 4313 chip-specific ChipStatus register bits */
+#define	CST4313_SPROM_PRESENT			1
+#define	CST4313_OTP_PRESENT			2
+#define	CST4313_SPROM_OTP_SEL_MASK		0x00000002
+#define	CST4313_SPROM_OTP_SEL_SHIFT		0
+
+/* 4313 Chip specific ChipControl register bits */
+#define CCTRL_4313_12MA_LED_DRIVE    0x00000007	/* 12 mA drive strengh for later 4313 */
+
 #define BCM47162_DMP() ((sih->chip == BCM47162_CHIP_ID) && \
 		(sih->chiprev == 0) && \
 		(sii->coreid[sii->curidx] == MIPS74K_CORE_ID))
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index b98099e..2941537 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -225,6 +225,52 @@
 #define	BISZ_BSSEND_IDX		6	/*      6: bss end */
 #define BISZ_SIZE		7	/* descriptor size in 32-bit integers */
 
+#define	CC_SROM_OTP		0x800	/* SROM/OTP address space */
+
+/* gpiotimerval */
+#define GPIO_ONTIME_SHIFT	16
+
+/* Fields in clkdiv */
+#define	CLKD_OTP		0x000f0000
+#define	CLKD_OTP_SHIFT		16
+
+/* When Srom support present, fields in sromcontrol */
+#define	SRC_START		0x80000000
+#define	SRC_BUSY		0x80000000
+#define	SRC_OPCODE		0x60000000
+#define	SRC_OP_READ		0x00000000
+#define	SRC_OP_WRITE		0x20000000
+#define	SRC_OP_WRDIS		0x40000000
+#define	SRC_OP_WREN		0x60000000
+#define	SRC_OTPSEL		0x00000010
+#define	SRC_LOCK		0x00000008
+#define	SRC_SIZE_MASK		0x00000006
+#define	SRC_SIZE_1K		0x00000000
+#define	SRC_SIZE_4K		0x00000002
+#define	SRC_SIZE_16K		0x00000004
+#define	SRC_SIZE_SHIFT		1
+#define	SRC_PRESENT		0x00000001
+
+/* 4330 chip-specific ChipStatus register bits */
+#define CST4330_CHIPMODE_SDIOD(cs)	(((cs) & 0x7) < 6)	/* SDIO || gSPI */
+#define CST4330_CHIPMODE_USB20D(cs)	(((cs) & 0x7) >= 6)	/* USB || USBDA */
+#define CST4330_CHIPMODE_SDIO(cs)	(((cs) & 0x4) == 0)	/* SDIO */
+#define CST4330_CHIPMODE_GSPI(cs)	(((cs) & 0x6) == 4)	/* gSPI */
+#define CST4330_CHIPMODE_USB(cs)	(((cs) & 0x7) == 6)	/* USB packet-oriented */
+#define CST4330_CHIPMODE_USBDA(cs)	(((cs) & 0x7) == 7)	/* USB Direct Access */
+#define	CST4330_OTP_PRESENT		0x00000010
+#define	CST4330_LPO_AUTODET_EN		0x00000020
+#define	CST4330_ARMREMAP_0		0x00000040
+#define	CST4330_SPROM_PRESENT		0x00000080	/* takes priority over OTP if both set */
+#define	CST4330_ILPDIV_EN		0x00000100
+#define	CST4330_LPO_SEL			0x00000200
+#define	CST4330_RES_INIT_MODE_SHIFT	10
+#define	CST4330_RES_INIT_MODE_MASK	0x00000c00
+#define CST4330_CBUCK_MODE_SHIFT	12
+#define CST4330_CBUCK_MODE_MASK		0x00003000
+#define	CST4330_CBUCK_POWER_OK		0x00004000
+#define	CST4330_BB_PLL_LOCKED		0x00008000
+
 #define	SI_INFO(sih)	(si_info_t *)sih
 
 #define	GOODCOREADDR(x, b) \
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index d01f60a..aa147c3 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -29,6 +29,37 @@
 #include <sbchipc.h>
 #include <bcmotp.h>
 
+#define OTPS_GUP_MASK		0x00000f00
+#define OTPS_GUP_SHIFT		8
+#define OTPS_GUP_HW		0x00000100	/* h/w subregion is programmed */
+#define OTPS_GUP_SW		0x00000200	/* s/w subregion is programmed */
+#define OTPS_GUP_CI		0x00000400	/* chipid/pkgopt subregion is programmed */
+#define OTPS_GUP_FUSE		0x00000800	/* fuse subregion is programmed */
+
+/* Fields in otpprog in rev >= 21 and HND OTP */
+#define OTPP_COL_MASK		0x000000ff
+#define OTPP_COL_SHIFT		0
+#define OTPP_ROW_MASK		0x0000ff00
+#define OTPP_ROW_SHIFT		8
+#define OTPP_OC_MASK		0x0f000000
+#define OTPP_OC_SHIFT		24
+#define OTPP_READERR		0x10000000
+#define OTPP_VALUE_MASK		0x20000000
+#define OTPP_VALUE_SHIFT	29
+#define OTPP_START_BUSY		0x80000000
+#define	OTPP_READ		0x40000000	/* HND OTP */
+
+/* Opcodes for OTPP_OC field */
+#define OTPPOC_READ		0
+#define OTPPOC_BIT_PROG		1
+#define OTPPOC_VERIFY		3
+#define OTPPOC_INIT		4
+#define OTPPOC_SET		5
+#define OTPPOC_RESET		6
+#define OTPPOC_OCST		7
+#define OTPPOC_ROW_LOCK		8
+#define OTPPOC_PRESCN_TEST	9
+
 /*
  * There are two different OTP controllers so far:
  * 	1. new IPX OTP controller:	chipc 21, >=23
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index e022224..d1babcd 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -18,7 +18,6 @@
 #define	_D11_H
 
 #include <linux/ieee80211.h>
-#include <sbconfig.h>
 
 /* cpp contortions to concatenate w/arg prescan */
 #ifndef	PAD
@@ -440,9 +439,6 @@ typedef volatile struct _d11regs {
 
 	/* SHM *//* 0x800 - 0xEFE */
 	u16 PAD[0x380];	/* 0x800 - 0xEFE */
-
-	/* SB configuration registers: 0xF00 */
-	sbconfig_t sbconfig;	/* sb config regs occupy top 256 bytes */
 } d11regs_t;
 
 #define	PIHR_BASE	0x0400	/* byte address of packed IHR region */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 2557255..77baef2 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -31,6 +31,123 @@
 #include <asm/addrspace.h>
 #endif
 
+/*
+ * Each descriptor ring must be 8kB aligned, and fit within a contiguous 8kB physical address.
+ */
+#define D64RINGALIGN_BITS	13
+#define	D64MAXRINGSZ		(1 << D64RINGALIGN_BITS)
+#define	D64RINGALIGN		(1 << D64RINGALIGN_BITS)
+
+#define	D64MAXDD	(D64MAXRINGSZ / sizeof (dma64dd_t))
+
+/* transmit channel control */
+#define	D64_XC_XE		0x00000001	/* transmit enable */
+#define	D64_XC_SE		0x00000002	/* transmit suspend request */
+#define	D64_XC_LE		0x00000004	/* loopback enable */
+#define	D64_XC_FL		0x00000010	/* flush request */
+#define	D64_XC_PD		0x00000800	/* parity check disable */
+#define	D64_XC_AE		0x00030000	/* address extension bits */
+#define	D64_XC_AE_SHIFT		16
+
+/* transmit descriptor table pointer */
+#define	D64_XP_LD_MASK		0x00000fff	/* last valid descriptor */
+
+/* transmit channel status */
+#define	D64_XS0_CD_MASK		0x00001fff	/* current descriptor pointer */
+#define	D64_XS0_XS_MASK		0xf0000000	/* transmit state */
+#define	D64_XS0_XS_SHIFT		28
+#define	D64_XS0_XS_DISABLED	0x00000000	/* disabled */
+#define	D64_XS0_XS_ACTIVE	0x10000000	/* active */
+#define	D64_XS0_XS_IDLE		0x20000000	/* idle wait */
+#define	D64_XS0_XS_STOPPED	0x30000000	/* stopped */
+#define	D64_XS0_XS_SUSP		0x40000000	/* suspend pending */
+
+#define	D64_XS1_AD_MASK		0x00001fff	/* active descriptor */
+#define	D64_XS1_XE_MASK		0xf0000000	/* transmit errors */
+#define	D64_XS1_XE_SHIFT		28
+#define	D64_XS1_XE_NOERR	0x00000000	/* no error */
+#define	D64_XS1_XE_DPE		0x10000000	/* descriptor protocol error */
+#define	D64_XS1_XE_DFU		0x20000000	/* data fifo underrun */
+#define	D64_XS1_XE_DTE		0x30000000	/* data transfer error */
+#define	D64_XS1_XE_DESRE	0x40000000	/* descriptor read error */
+#define	D64_XS1_XE_COREE	0x50000000	/* core error */
+
+/* receive channel control */
+#define	D64_RC_RE		0x00000001	/* receive enable */
+#define	D64_RC_RO_MASK		0x000000fe	/* receive frame offset */
+#define	D64_RC_RO_SHIFT		1
+#define	D64_RC_FM		0x00000100	/* direct fifo receive (pio) mode */
+#define	D64_RC_SH		0x00000200	/* separate rx header descriptor enable */
+#define	D64_RC_OC		0x00000400	/* overflow continue */
+#define	D64_RC_PD		0x00000800	/* parity check disable */
+#define	D64_RC_AE		0x00030000	/* address extension bits */
+#define	D64_RC_AE_SHIFT		16
+
+/* flags for dma controller */
+#define DMA_CTRL_PEN		(1 << 0)	/* partity enable */
+#define DMA_CTRL_ROC		(1 << 1)	/* rx overflow continue */
+#define DMA_CTRL_RXMULTI	(1 << 2)	/* allow rx scatter to multiple descriptors */
+#define DMA_CTRL_UNFRAMED	(1 << 3)	/* Unframed Rx/Tx data */
+
+/* receive descriptor table pointer */
+#define	D64_RP_LD_MASK		0x00000fff	/* last valid descriptor */
+
+/* receive channel status */
+#define	D64_RS0_CD_MASK		0x00001fff	/* current descriptor pointer */
+#define	D64_RS0_RS_MASK		0xf0000000	/* receive state */
+#define	D64_RS0_RS_SHIFT		28
+#define	D64_RS0_RS_DISABLED	0x00000000	/* disabled */
+#define	D64_RS0_RS_ACTIVE	0x10000000	/* active */
+#define	D64_RS0_RS_IDLE		0x20000000	/* idle wait */
+#define	D64_RS0_RS_STOPPED	0x30000000	/* stopped */
+#define	D64_RS0_RS_SUSP		0x40000000	/* suspend pending */
+
+#define	D64_RS1_AD_MASK		0x0001ffff	/* active descriptor */
+#define	D64_RS1_RE_MASK		0xf0000000	/* receive errors */
+#define	D64_RS1_RE_SHIFT		28
+#define	D64_RS1_RE_NOERR	0x00000000	/* no error */
+#define	D64_RS1_RE_DPO		0x10000000	/* descriptor protocol error */
+#define	D64_RS1_RE_DFU		0x20000000	/* data fifo overflow */
+#define	D64_RS1_RE_DTE		0x30000000	/* data transfer error */
+#define	D64_RS1_RE_DESRE	0x40000000	/* descriptor read error */
+#define	D64_RS1_RE_COREE	0x50000000	/* core error */
+
+/* fifoaddr */
+#define	D64_FA_OFF_MASK		0xffff	/* offset */
+#define	D64_FA_SEL_MASK		0xf0000	/* select */
+#define	D64_FA_SEL_SHIFT	16
+#define	D64_FA_SEL_XDD		0x00000	/* transmit dma data */
+#define	D64_FA_SEL_XDP		0x10000	/* transmit dma pointers */
+#define	D64_FA_SEL_RDD		0x40000	/* receive dma data */
+#define	D64_FA_SEL_RDP		0x50000	/* receive dma pointers */
+#define	D64_FA_SEL_XFD		0x80000	/* transmit fifo data */
+#define	D64_FA_SEL_XFP		0x90000	/* transmit fifo pointers */
+#define	D64_FA_SEL_RFD		0xc0000	/* receive fifo data */
+#define	D64_FA_SEL_RFP		0xd0000	/* receive fifo pointers */
+#define	D64_FA_SEL_RSD		0xe0000	/* receive frame status data */
+#define	D64_FA_SEL_RSP		0xf0000	/* receive frame status pointers */
+
+/* descriptor control flags 1 */
+#define D64_CTRL_COREFLAGS	0x0ff00000	/* core specific flags */
+#define	D64_CTRL1_EOT		((u32)1 << 28)	/* end of descriptor table */
+#define	D64_CTRL1_IOC		((u32)1 << 29)	/* interrupt on completion */
+#define	D64_CTRL1_EOF		((u32)1 << 30)	/* end of frame */
+#define	D64_CTRL1_SOF		((u32)1 << 31)	/* start of frame */
+
+/* descriptor control flags 2 */
+#define	D64_CTRL2_BC_MASK	0x00007fff	/* buffer byte count. real data len must <= 16KB */
+#define	D64_CTRL2_AE		0x00030000	/* address extension bits */
+#define	D64_CTRL2_AE_SHIFT	16
+#define D64_CTRL2_PARITY	0x00040000	/* parity bit */
+
+/* control flags in the range [27:20] are core-specific and not defined here */
+#define	D64_CTRL_CORE_MASK	0x0ff00000
+
+#define D64_RX_FRM_STS_LEN	0x0000ffff	/* frame length mask */
+#define D64_RX_FRM_STS_OVFL	0x00800000	/* RxOverFlow */
+#define D64_RX_FRM_STS_DSCRCNT	0x0f000000  /* no. of descriptors used - 1 */
+#define D64_RX_FRM_STS_DATATYPE	0xf0000000	/* core-dependent data type */
+
 /* debug/trace */
 #ifdef BCMDBG
 #define	DMA_ERROR(args) \
@@ -69,6 +186,17 @@ static uint dma_msg_level;
 #define R_SM(r)		(*(r))
 #define W_SM(r, v)	(*(r) = (v))
 
+/*
+ * DMA Descriptor
+ * Descriptors are only read by the hardware, never written back.
+ */
+typedef volatile struct {
+	u32 ctrl1;		/* misc control bits & bufcount */
+	u32 ctrl2;		/* buffer count and address extension */
+	u32 addrlow;		/* memory address of the date buffer, bits 31:0 */
+	u32 addrhigh;	/* memory address of the date buffer, bits 63:32 */
+} dma64dd_t;
+
 /* dma engine software state */
 typedef struct dma_info {
 	struct dma_pub dma; /* exported structure */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 51d56b6..806b2ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -29,6 +29,9 @@
 #include <nicpci.h>
 #include <pcicfg.h>
 
+/* chipcontrol */
+#define CHIPCTRL_4321_PLL_DOWN	0x800000	/* serdes PLL down override */
+
 typedef struct {
 	union {
 		sbpcieregs_t *pcieregs;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 123bd6a..620eb86 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -141,6 +141,10 @@
 
 #define NPHY_ADJUSTED_MINCRSPOWER 0x1e
 
+/* 5357 Chip specific ChipControl register bits */
+#define CCTRL5357_EXTPA                 (1<<14)	/* extPA in ChipControl 1, bit 14 */
+#define CCTRL5357_ANT_MUX_2o3		(1<<15)	/* 2o3 in ChipControl 1, bit 15 */
+
 typedef struct _nphy_iqcal_params {
 	u16 txlpf;
 	u16 txgm;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index ab4ef6c..a7994e4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -29,7 +29,6 @@
 #include <bcmotp.h>
 #include <bcmutils.h>
 #include <bcmnvram.h>
-#include <sbconfig.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
 #include <sbdma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index c6f9694..7bb122b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -29,7 +29,6 @@
 #include <bcmutils.h>
 #include <bcmwifi.h>
 #include <aiutils.h>
-#include <sbconfig.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
 #include <sbdma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 82986bd..e9230a8 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -128,9 +128,474 @@
 #define RES_DEPEND_ADD		1
 #define RES_DEPEND_REMOVE	-1
 
+/* Fields in pmucontrol */
+#define	PCTL_ILP_DIV_MASK	0xffff0000
+#define	PCTL_ILP_DIV_SHIFT	16
+#define PCTL_PLL_PLLCTL_UPD	0x00000400	/* rev 2 */
+#define PCTL_NOILP_ON_WAIT	0x00000200	/* rev 1 */
+#define	PCTL_HT_REQ_EN		0x00000100
+#define	PCTL_ALP_REQ_EN		0x00000080
+#define	PCTL_XTALFREQ_MASK	0x0000007c
+#define	PCTL_XTALFREQ_SHIFT	2
+#define	PCTL_ILP_DIV_EN		0x00000002
+#define	PCTL_LPO_SEL		0x00000001
+
+/* Fields in clkstretch */
+#define CSTRETCH_HT		0xffff0000
+#define CSTRETCH_ALP		0x0000ffff
+
 /* d11 slow to fast clock transition time in slow clock cycles */
 #define D11SCC_SLOW2FAST_TRANSITION	2
 
+/* ILP clock */
+#define	ILP_CLOCK		32000
+
+/* ALP clock on pre-PMU chips */
+#define	ALP_CLOCK		20000000
+
+/* HT clock */
+#define	HT_CLOCK		80000000
+
+#define OTPS_READY		0x00001000
+
+/* pmustatus */
+#define PST_EXTLPOAVAIL	0x0100
+#define PST_WDRESET	0x0080
+#define	PST_INTPEND	0x0040
+#define	PST_SBCLKST	0x0030
+#define	PST_SBCLKST_ILP	0x0010
+#define	PST_SBCLKST_ALP	0x0020
+#define	PST_SBCLKST_HT	0x0030
+#define	PST_ALPAVAIL	0x0008
+#define	PST_HTAVAIL	0x0004
+#define	PST_RESINIT	0x0003
+
+/* PMU Resource Request Timer registers */
+/* This is based on PmuRev0 */
+#define	PRRT_TIME_MASK	0x03ff
+#define	PRRT_INTEN	0x0400
+#define	PRRT_REQ_ACTIVE	0x0800
+#define	PRRT_ALP_REQ	0x1000
+#define	PRRT_HT_REQ	0x2000
+
+/* PMU resource bit position */
+#define PMURES_BIT(bit)	(1 << (bit))
+
+/* PMU resource number limit */
+#define PMURES_MAX_RESNUM	30
+
+/* PMU chip control0 register */
+#define	PMU_CHIPCTL0		0
+
+/* PMU chip control1 register */
+#define	PMU_CHIPCTL1			1
+#define	PMU_CC1_RXC_DLL_BYPASS		0x00010000
+
+#define PMU_CC1_IF_TYPE_MASK   		0x00000030
+#define PMU_CC1_IF_TYPE_RMII    	0x00000000
+#define PMU_CC1_IF_TYPE_MII     	0x00000010
+#define PMU_CC1_IF_TYPE_RGMII   	0x00000020
+
+#define PMU_CC1_SW_TYPE_MASK    	0x000000c0
+#define PMU_CC1_SW_TYPE_EPHY    	0x00000000
+#define PMU_CC1_SW_TYPE_EPHYMII 	0x00000040
+#define PMU_CC1_SW_TYPE_EPHYRMII	0x00000080
+#define PMU_CC1_SW_TYPE_RGMII   	0x000000c0
+
+/* PMU corerev and chip specific PLL controls.
+ * PMU<rev>_PLL<num>_XX where <rev> is PMU corerev and <num> is an arbitrary number
+ * to differentiate different PLLs controlled by the same PMU rev.
+ */
+/* pllcontrol registers */
+/* PDIV, div_phy, div_arm, div_adc, dith_sel, ioff, kpd_scale, lsb_sel, mash_sel, lf_c & lf_r */
+#define	PMU0_PLL0_PLLCTL0		0
+#define	PMU0_PLL0_PC0_PDIV_MASK		1
+#define	PMU0_PLL0_PC0_PDIV_FREQ		25000
+#define PMU0_PLL0_PC0_DIV_ARM_MASK	0x00000038
+#define PMU0_PLL0_PC0_DIV_ARM_SHIFT	3
+#define PMU0_PLL0_PC0_DIV_ARM_BASE	8
+
+/* PC0_DIV_ARM for PLLOUT_ARM */
+#define PMU0_PLL0_PC0_DIV_ARM_110MHZ	0
+#define PMU0_PLL0_PC0_DIV_ARM_97_7MHZ	1
+#define PMU0_PLL0_PC0_DIV_ARM_88MHZ	2
+#define PMU0_PLL0_PC0_DIV_ARM_80MHZ	3	/* Default */
+#define PMU0_PLL0_PC0_DIV_ARM_73_3MHZ	4
+#define PMU0_PLL0_PC0_DIV_ARM_67_7MHZ	5
+#define PMU0_PLL0_PC0_DIV_ARM_62_9MHZ	6
+#define PMU0_PLL0_PC0_DIV_ARM_58_6MHZ	7
+
+/* Wildcard base, stop_mod, en_lf_tp, en_cal & lf_r2 */
+#define	PMU0_PLL0_PLLCTL1		1
+#define	PMU0_PLL0_PC1_WILD_INT_MASK	0xf0000000
+#define	PMU0_PLL0_PC1_WILD_INT_SHIFT	28
+#define	PMU0_PLL0_PC1_WILD_FRAC_MASK	0x0fffff00
+#define	PMU0_PLL0_PC1_WILD_FRAC_SHIFT	8
+#define	PMU0_PLL0_PC1_STOP_MOD		0x00000040
+
+/* Wildcard base, vco_calvar, vco_swc, vco_var_selref, vso_ical & vco_sel_avdd */
+#define	PMU0_PLL0_PLLCTL2		2
+#define	PMU0_PLL0_PC2_WILD_INT_MASK	0xf
+#define	PMU0_PLL0_PC2_WILD_INT_SHIFT	4
+
+/* pllcontrol registers */
+/* ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>, p1div, p2div, _bypass_sdmod */
+#define PMU1_PLL0_PLLCTL0		0
+#define PMU1_PLL0_PC0_P1DIV_MASK	0x00f00000
+#define PMU1_PLL0_PC0_P1DIV_SHIFT	20
+#define PMU1_PLL0_PC0_P2DIV_MASK	0x0f000000
+#define PMU1_PLL0_PC0_P2DIV_SHIFT	24
+
+/* m<x>div */
+#define PMU1_PLL0_PLLCTL1		1
+#define PMU1_PLL0_PC1_M1DIV_MASK	0x000000ff
+#define PMU1_PLL0_PC1_M1DIV_SHIFT	0
+#define PMU1_PLL0_PC1_M2DIV_MASK	0x0000ff00
+#define PMU1_PLL0_PC1_M2DIV_SHIFT	8
+#define PMU1_PLL0_PC1_M3DIV_MASK	0x00ff0000
+#define PMU1_PLL0_PC1_M3DIV_SHIFT	16
+#define PMU1_PLL0_PC1_M4DIV_MASK	0xff000000
+#define PMU1_PLL0_PC1_M4DIV_SHIFT	24
+
+#define PMU1_PLL0_CHIPCTL0		0
+#define PMU1_PLL0_CHIPCTL1		1
+#define PMU1_PLL0_CHIPCTL2		2
+
+#define DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT 8
+#define DOT11MAC_880MHZ_CLK_DIVISOR_MASK (0xFF << DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT)
+#define DOT11MAC_880MHZ_CLK_DIVISOR_VAL  (0xE << DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT)
+
+/* m<x>div, ndiv_dither_mfb, ndiv_mode, ndiv_int */
+#define PMU1_PLL0_PLLCTL2		2
+#define PMU1_PLL0_PC2_M5DIV_MASK	0x000000ff
+#define PMU1_PLL0_PC2_M5DIV_SHIFT	0
+#define PMU1_PLL0_PC2_M6DIV_MASK	0x0000ff00
+#define PMU1_PLL0_PC2_M6DIV_SHIFT	8
+#define PMU1_PLL0_PC2_NDIV_MODE_MASK	0x000e0000
+#define PMU1_PLL0_PC2_NDIV_MODE_SHIFT	17
+#define PMU1_PLL0_PC2_NDIV_MODE_MASH	1
+#define PMU1_PLL0_PC2_NDIV_MODE_MFB	2	/* recommended for 4319 */
+#define PMU1_PLL0_PC2_NDIV_INT_MASK	0x1ff00000
+#define PMU1_PLL0_PC2_NDIV_INT_SHIFT	20
+
+/* ndiv_frac */
+#define PMU1_PLL0_PLLCTL3		3
+#define PMU1_PLL0_PC3_NDIV_FRAC_MASK	0x00ffffff
+#define PMU1_PLL0_PC3_NDIV_FRAC_SHIFT	0
+
+/* pll_ctrl */
+#define PMU1_PLL0_PLLCTL4		4
+
+/* pll_ctrl, vco_rng, clkdrive_ch<x> */
+#define PMU1_PLL0_PLLCTL5		5
+#define PMU1_PLL0_PC5_CLK_DRV_MASK 0xffffff00
+#define PMU1_PLL0_PC5_CLK_DRV_SHIFT 8
+
+/* PMU rev 2 control words */
+#define PMU2_PHY_PLL_PLLCTL		4
+#define PMU2_SI_PLL_PLLCTL		10
+
+/* PMU rev 2 */
+/* pllcontrol registers */
+/* ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>, p1div, p2div, _bypass_sdmod */
+#define PMU2_PLL_PLLCTL0		0
+#define PMU2_PLL_PC0_P1DIV_MASK 	0x00f00000
+#define PMU2_PLL_PC0_P1DIV_SHIFT	20
+#define PMU2_PLL_PC0_P2DIV_MASK 	0x0f000000
+#define PMU2_PLL_PC0_P2DIV_SHIFT	24
+
+/* m<x>div */
+#define PMU2_PLL_PLLCTL1		1
+#define PMU2_PLL_PC1_M1DIV_MASK 	0x000000ff
+#define PMU2_PLL_PC1_M1DIV_SHIFT	0
+#define PMU2_PLL_PC1_M2DIV_MASK 	0x0000ff00
+#define PMU2_PLL_PC1_M2DIV_SHIFT	8
+#define PMU2_PLL_PC1_M3DIV_MASK 	0x00ff0000
+#define PMU2_PLL_PC1_M3DIV_SHIFT	16
+#define PMU2_PLL_PC1_M4DIV_MASK 	0xff000000
+#define PMU2_PLL_PC1_M4DIV_SHIFT	24
+
+/* m<x>div, ndiv_dither_mfb, ndiv_mode, ndiv_int */
+#define PMU2_PLL_PLLCTL2		2
+#define PMU2_PLL_PC2_M5DIV_MASK 	0x000000ff
+#define PMU2_PLL_PC2_M5DIV_SHIFT	0
+#define PMU2_PLL_PC2_M6DIV_MASK 	0x0000ff00
+#define PMU2_PLL_PC2_M6DIV_SHIFT	8
+#define PMU2_PLL_PC2_NDIV_MODE_MASK	0x000e0000
+#define PMU2_PLL_PC2_NDIV_MODE_SHIFT	17
+#define PMU2_PLL_PC2_NDIV_INT_MASK	0x1ff00000
+#define PMU2_PLL_PC2_NDIV_INT_SHIFT	20
+
+/* ndiv_frac */
+#define PMU2_PLL_PLLCTL3		3
+#define PMU2_PLL_PC3_NDIV_FRAC_MASK	0x00ffffff
+#define PMU2_PLL_PC3_NDIV_FRAC_SHIFT	0
+
+/* pll_ctrl */
+#define PMU2_PLL_PLLCTL4		4
+
+/* pll_ctrl, vco_rng, clkdrive_ch<x> */
+#define PMU2_PLL_PLLCTL5		5
+#define PMU2_PLL_PC5_CLKDRIVE_CH1_MASK	0x00000f00
+#define PMU2_PLL_PC5_CLKDRIVE_CH1_SHIFT	8
+#define PMU2_PLL_PC5_CLKDRIVE_CH2_MASK	0x0000f000
+#define PMU2_PLL_PC5_CLKDRIVE_CH2_SHIFT	12
+#define PMU2_PLL_PC5_CLKDRIVE_CH3_MASK	0x000f0000
+#define PMU2_PLL_PC5_CLKDRIVE_CH3_SHIFT	16
+#define PMU2_PLL_PC5_CLKDRIVE_CH4_MASK	0x00f00000
+#define PMU2_PLL_PC5_CLKDRIVE_CH4_SHIFT	20
+#define PMU2_PLL_PC5_CLKDRIVE_CH5_MASK	0x0f000000
+#define PMU2_PLL_PC5_CLKDRIVE_CH5_SHIFT	24
+#define PMU2_PLL_PC5_CLKDRIVE_CH6_MASK	0xf0000000
+#define PMU2_PLL_PC5_CLKDRIVE_CH6_SHIFT	28
+
+/* PMU rev 5 (& 6) */
+#define	PMU5_PLL_P1P2_OFF		0
+#define	PMU5_PLL_P1_MASK		0x0f000000
+#define	PMU5_PLL_P1_SHIFT		24
+#define	PMU5_PLL_P2_MASK		0x00f00000
+#define	PMU5_PLL_P2_SHIFT		20
+#define	PMU5_PLL_M14_OFF		1
+#define	PMU5_PLL_MDIV_MASK		0x000000ff
+#define	PMU5_PLL_MDIV_WIDTH		8
+#define	PMU5_PLL_NM5_OFF		2
+#define	PMU5_PLL_NDIV_MASK		0xfff00000
+#define	PMU5_PLL_NDIV_SHIFT		20
+#define	PMU5_PLL_NDIV_MODE_MASK		0x000e0000
+#define	PMU5_PLL_NDIV_MODE_SHIFT	17
+#define	PMU5_PLL_FMAB_OFF		3
+#define	PMU5_PLL_MRAT_MASK		0xf0000000
+#define	PMU5_PLL_MRAT_SHIFT		28
+#define	PMU5_PLL_ABRAT_MASK		0x08000000
+#define	PMU5_PLL_ABRAT_SHIFT		27
+#define	PMU5_PLL_FDIV_MASK		0x07ffffff
+#define	PMU5_PLL_PLLCTL_OFF		4
+#define	PMU5_PLL_PCHI_OFF		5
+#define	PMU5_PLL_PCHI_MASK		0x0000003f
+
+/* pmu XtalFreqRatio */
+#define	PMU_XTALFREQ_REG_ILPCTR_MASK	0x00001FFF
+#define	PMU_XTALFREQ_REG_MEASURE_MASK	0x80000000
+#define	PMU_XTALFREQ_REG_MEASURE_SHIFT	31
+
+/* Divider allocation in 4716/47162/5356/5357 */
+#define	PMU5_MAINPLL_CPU		1
+#define	PMU5_MAINPLL_MEM		2
+#define	PMU5_MAINPLL_SI			3
+
+#define PMU7_PLL_PLLCTL7                7
+#define PMU7_PLL_PLLCTL8                8
+#define PMU7_PLL_PLLCTL11		11
+
+/* PLL usage in 4716/47162 */
+#define	PMU4716_MAINPLL_PLL0		12
+
+/* PLL usage in 5356/5357 */
+#define	PMU5356_MAINPLL_PLL0		0
+#define	PMU5357_MAINPLL_PLL0		0
+
+/* 4328 resources */
+#define RES4328_EXT_SWITCHER_PWM	0	/* 0x00001 */
+#define RES4328_BB_SWITCHER_PWM		1	/* 0x00002 */
+#define RES4328_BB_SWITCHER_BURST	2	/* 0x00004 */
+#define RES4328_BB_EXT_SWITCHER_BURST	3	/* 0x00008 */
+#define RES4328_ILP_REQUEST		4	/* 0x00010 */
+#define RES4328_RADIO_SWITCHER_PWM	5	/* 0x00020 */
+#define RES4328_RADIO_SWITCHER_BURST	6	/* 0x00040 */
+#define RES4328_ROM_SWITCH		7	/* 0x00080 */
+#define RES4328_PA_REF_LDO		8	/* 0x00100 */
+#define RES4328_RADIO_LDO		9	/* 0x00200 */
+#define RES4328_AFE_LDO			10	/* 0x00400 */
+#define RES4328_PLL_LDO			11	/* 0x00800 */
+#define RES4328_BG_FILTBYP		12	/* 0x01000 */
+#define RES4328_TX_FILTBYP		13	/* 0x02000 */
+#define RES4328_RX_FILTBYP		14	/* 0x04000 */
+#define RES4328_XTAL_PU			15	/* 0x08000 */
+#define RES4328_XTAL_EN			16	/* 0x10000 */
+#define RES4328_BB_PLL_FILTBYP		17	/* 0x20000 */
+#define RES4328_RF_PLL_FILTBYP		18	/* 0x40000 */
+#define RES4328_BB_PLL_PU		19	/* 0x80000 */
+
+/* 4325 A0/A1 resources */
+#define RES4325_BUCK_BOOST_BURST	0	/* 0x00000001 */
+#define RES4325_CBUCK_BURST		1	/* 0x00000002 */
+#define RES4325_CBUCK_PWM		2	/* 0x00000004 */
+#define RES4325_CLDO_CBUCK_BURST	3	/* 0x00000008 */
+#define RES4325_CLDO_CBUCK_PWM		4	/* 0x00000010 */
+#define RES4325_BUCK_BOOST_PWM		5	/* 0x00000020 */
+#define RES4325_ILP_REQUEST		6	/* 0x00000040 */
+#define RES4325_ABUCK_BURST		7	/* 0x00000080 */
+#define RES4325_ABUCK_PWM		8	/* 0x00000100 */
+#define RES4325_LNLDO1_PU		9	/* 0x00000200 */
+#define RES4325_OTP_PU			10	/* 0x00000400 */
+#define RES4325_LNLDO3_PU		11	/* 0x00000800 */
+#define RES4325_LNLDO4_PU		12	/* 0x00001000 */
+#define RES4325_XTAL_PU			13	/* 0x00002000 */
+#define RES4325_ALP_AVAIL		14	/* 0x00004000 */
+#define RES4325_RX_PWRSW_PU		15	/* 0x00008000 */
+#define RES4325_TX_PWRSW_PU		16	/* 0x00010000 */
+#define RES4325_RFPLL_PWRSW_PU		17	/* 0x00020000 */
+#define RES4325_LOGEN_PWRSW_PU		18	/* 0x00040000 */
+#define RES4325_AFE_PWRSW_PU		19	/* 0x00080000 */
+#define RES4325_BBPLL_PWRSW_PU		20	/* 0x00100000 */
+#define RES4325_HT_AVAIL		21	/* 0x00200000 */
+
+/* 4325 B0/C0 resources */
+#define RES4325B0_CBUCK_LPOM		1	/* 0x00000002 */
+#define RES4325B0_CBUCK_BURST		2	/* 0x00000004 */
+#define RES4325B0_CBUCK_PWM		3	/* 0x00000008 */
+#define RES4325B0_CLDO_PU		4	/* 0x00000010 */
+
+/* 4325 C1 resources */
+#define RES4325C1_LNLDO2_PU		12	/* 0x00001000 */
+
+#define RES4329_RESERVED0		0	/* 0x00000001 */
+#define RES4329_CBUCK_LPOM		1	/* 0x00000002 */
+#define RES4329_CBUCK_BURST		2	/* 0x00000004 */
+#define RES4329_CBUCK_PWM		3	/* 0x00000008 */
+#define RES4329_CLDO_PU			4	/* 0x00000010 */
+#define RES4329_PALDO_PU		5	/* 0x00000020 */
+#define RES4329_ILP_REQUEST		6	/* 0x00000040 */
+#define RES4329_RESERVED7		7	/* 0x00000080 */
+#define RES4329_RESERVED8		8	/* 0x00000100 */
+#define RES4329_LNLDO1_PU		9	/* 0x00000200 */
+#define RES4329_OTP_PU			10	/* 0x00000400 */
+#define RES4329_RESERVED11		11	/* 0x00000800 */
+#define RES4329_LNLDO2_PU		12	/* 0x00001000 */
+#define RES4329_XTAL_PU			13	/* 0x00002000 */
+#define RES4329_ALP_AVAIL		14	/* 0x00004000 */
+#define RES4329_RX_PWRSW_PU		15	/* 0x00008000 */
+#define RES4329_TX_PWRSW_PU		16	/* 0x00010000 */
+#define RES4329_RFPLL_PWRSW_PU		17	/* 0x00020000 */
+#define RES4329_LOGEN_PWRSW_PU		18	/* 0x00040000 */
+#define RES4329_AFE_PWRSW_PU		19	/* 0x00080000 */
+#define RES4329_BBPLL_PWRSW_PU		20	/* 0x00100000 */
+#define RES4329_HT_AVAIL		21	/* 0x00200000 */
+
+/* 4315 resources */
+#define RES4315_CBUCK_LPOM		1	/* 0x00000002 */
+#define RES4315_CBUCK_BURST		2	/* 0x00000004 */
+#define RES4315_CBUCK_PWM		3	/* 0x00000008 */
+#define RES4315_CLDO_PU			4	/* 0x00000010 */
+#define RES4315_PALDO_PU		5	/* 0x00000020 */
+#define RES4315_ILP_REQUEST		6	/* 0x00000040 */
+#define RES4315_LNLDO1_PU		9	/* 0x00000200 */
+#define RES4315_OTP_PU			10	/* 0x00000400 */
+#define RES4315_LNLDO2_PU		12	/* 0x00001000 */
+#define RES4315_XTAL_PU			13	/* 0x00002000 */
+#define RES4315_ALP_AVAIL		14	/* 0x00004000 */
+#define RES4315_RX_PWRSW_PU		15	/* 0x00008000 */
+#define RES4315_TX_PWRSW_PU		16	/* 0x00010000 */
+#define RES4315_RFPLL_PWRSW_PU		17	/* 0x00020000 */
+#define RES4315_LOGEN_PWRSW_PU		18	/* 0x00040000 */
+#define RES4315_AFE_PWRSW_PU		19	/* 0x00080000 */
+#define RES4315_BBPLL_PWRSW_PU		20	/* 0x00100000 */
+#define RES4315_HT_AVAIL		21	/* 0x00200000 */
+
+/* 4319 resources */
+#define RES4319_CBUCK_LPOM		1	/* 0x00000002 */
+#define RES4319_CBUCK_BURST		2	/* 0x00000004 */
+#define RES4319_CBUCK_PWM		3	/* 0x00000008 */
+#define RES4319_CLDO_PU			4	/* 0x00000010 */
+#define RES4319_PALDO_PU		5	/* 0x00000020 */
+#define RES4319_ILP_REQUEST		6	/* 0x00000040 */
+#define RES4319_LNLDO1_PU		9	/* 0x00000200 */
+#define RES4319_OTP_PU			10	/* 0x00000400 */
+#define RES4319_LNLDO2_PU		12	/* 0x00001000 */
+#define RES4319_XTAL_PU			13	/* 0x00002000 */
+#define RES4319_ALP_AVAIL		14	/* 0x00004000 */
+#define RES4319_RX_PWRSW_PU		15	/* 0x00008000 */
+#define RES4319_TX_PWRSW_PU		16	/* 0x00010000 */
+#define RES4319_RFPLL_PWRSW_PU		17	/* 0x00020000 */
+#define RES4319_LOGEN_PWRSW_PU		18	/* 0x00040000 */
+#define RES4319_AFE_PWRSW_PU		19	/* 0x00080000 */
+#define RES4319_BBPLL_PWRSW_PU		20	/* 0x00100000 */
+#define RES4319_HT_AVAIL		21	/* 0x00200000 */
+
+#define CCTL_4319USB_XTAL_SEL_MASK	0x00180000
+#define CCTL_4319USB_XTAL_SEL_SHIFT	19
+#define CCTL_4319USB_48MHZ_PLL_SEL	1
+#define CCTL_4319USB_24MHZ_PLL_SEL	2
+
+/* PMU resources for 4336 */
+#define	RES4336_CBUCK_LPOM		0
+#define	RES4336_CBUCK_BURST		1
+#define	RES4336_CBUCK_LP_PWM		2
+#define	RES4336_CBUCK_PWM		3
+#define	RES4336_CLDO_PU			4
+#define	RES4336_DIS_INT_RESET_PD	5
+#define	RES4336_ILP_REQUEST		6
+#define	RES4336_LNLDO_PU		7
+#define	RES4336_LDO3P3_PU		8
+#define	RES4336_OTP_PU			9
+#define	RES4336_XTAL_PU			10
+#define	RES4336_ALP_AVAIL		11
+#define	RES4336_RADIO_PU		12
+#define	RES4336_BG_PU			13
+#define	RES4336_VREG1p4_PU_PU		14
+#define	RES4336_AFE_PWRSW_PU		15
+#define	RES4336_RX_PWRSW_PU		16
+#define	RES4336_TX_PWRSW_PU		17
+#define	RES4336_BB_PWRSW_PU		18
+#define	RES4336_SYNTH_PWRSW_PU		19
+#define	RES4336_MISC_PWRSW_PU		20
+#define	RES4336_LOGEN_PWRSW_PU		21
+#define	RES4336_BBPLL_PWRSW_PU		22
+#define	RES4336_MACPHY_CLKAVAIL		23
+#define	RES4336_HT_AVAIL		24
+#define	RES4336_RSVD			25
+
+/* 4330 resources */
+#define	RES4330_CBUCK_LPOM		0
+#define	RES4330_CBUCK_BURST		1
+#define	RES4330_CBUCK_LP_PWM		2
+#define	RES4330_CBUCK_PWM		3
+#define	RES4330_CLDO_PU			4
+#define	RES4330_DIS_INT_RESET_PD	5
+#define	RES4330_ILP_REQUEST		6
+#define	RES4330_LNLDO_PU		7
+#define	RES4330_LDO3P3_PU		8
+#define	RES4330_OTP_PU			9
+#define	RES4330_XTAL_PU			10
+#define	RES4330_ALP_AVAIL		11
+#define	RES4330_RADIO_PU		12
+#define	RES4330_BG_PU			13
+#define	RES4330_VREG1p4_PU_PU		14
+#define	RES4330_AFE_PWRSW_PU		15
+#define	RES4330_RX_PWRSW_PU		16
+#define	RES4330_TX_PWRSW_PU		17
+#define	RES4330_BB_PWRSW_PU		18
+#define	RES4330_SYNTH_PWRSW_PU		19
+#define	RES4330_MISC_PWRSW_PU		20
+#define	RES4330_LOGEN_PWRSW_PU		21
+#define	RES4330_BBPLL_PWRSW_PU		22
+#define	RES4330_MACPHY_CLKAVAIL		23
+#define	RES4330_HT_AVAIL		24
+#define	RES4330_5gRX_PWRSW_PU		25
+#define	RES4330_5gTX_PWRSW_PU		26
+#define	RES4330_5g_LOGEN_PWRSW_PU	27
+
+/* 4313 resources */
+#define	RES4313_BB_PU_RSRC		0
+#define	RES4313_ILP_REQ_RSRC		1
+#define	RES4313_XTAL_PU_RSRC		2
+#define	RES4313_ALP_AVAIL_RSRC		3
+#define	RES4313_RADIO_PU_RSRC		4
+#define	RES4313_BG_PU_RSRC		5
+#define	RES4313_VREG1P4_PU_RSRC		6
+#define	RES4313_AFE_PWRSW_RSRC		7
+#define	RES4313_RX_PWRSW_RSRC		8
+#define	RES4313_TX_PWRSW_RSRC		9
+#define	RES4313_BB_PWRSW_RSRC		10
+#define	RES4313_SYNTH_PWRSW_RSRC	11
+#define	RES4313_MISC_PWRSW_RSRC		12
+#define	RES4313_BB_PLL_PWRSW_RSRC	13
+#define	RES4313_HT_AVAIL_RSRC		14
+#define	RES4313_MACPHY_CLK_AVAIL_RSRC	15
+
+/* PMU resource up transition time in ILP cycles */
+#define PMURES_UP_TRANSITION	2
+
 /* Setup resource up/down timers */
 typedef struct {
 	u8 resnum;
diff --git a/drivers/staging/brcm80211/include/sbchipc.h b/drivers/staging/brcm80211/include/sbchipc.h
index 8c01c63..9ca2e69 100644
--- a/drivers/staging/brcm80211/include/sbchipc.h
+++ b/drivers/staging/brcm80211/include/sbchipc.h
@@ -17,8 +17,6 @@
 #ifndef	_SBCHIPC_H
 #define	_SBCHIPC_H
 
-#ifndef _LANGUAGE_ASSEMBLY
-
 /* cpp contortions to concatenate w/arg prescan */
 #ifndef PAD
 #define	_PADLINE(line)	pad ## line
@@ -223,63 +221,6 @@ typedef volatile struct {
 	u16 sromotp[768];
 } chipcregs_t;
 
-#endif				/* _LANGUAGE_ASSEMBLY */
-
-#if	defined(__BIG_ENDIAN) && defined(BCMHND74K)
-/* Selective swapped defines for those registers we need in
- * big-endian code.
- */
-#define	CC_CHIPID		4
-#define	CC_CAPABILITIES		0
-#define	CC_CHIPST		0x28
-#define	CC_EROMPTR		0xf8
-
-#else				/* !__BIG_ENDIAN || !BCMHND74K */
-
-#define	CC_CHIPID		0
-#define	CC_CAPABILITIES		4
-#define	CC_CHIPST		0x2c
-#define	CC_EROMPTR		0xfc
-
-#endif				/* __BIG_ENDIAN && BCMHND74K */
-
-#define CC_OTPST		0x10
-#define	CC_JTAGCMD		0x30
-#define	CC_JTAGIR		0x34
-#define	CC_JTAGDR		0x38
-#define	CC_JTAGCTRL		0x3c
-#define	CC_GPIOPU		0x58
-#define	CC_GPIOPD		0x5c
-#define	CC_GPIOIN		0x60
-#define	CC_GPIOOUT		0x64
-#define	CC_GPIOOUTEN		0x68
-#define	CC_GPIOCTRL		0x6c
-#define	CC_GPIOPOL		0x70
-#define	CC_GPIOINTM		0x74
-#define	CC_WATCHDOG		0x80
-#define	CC_CLKC_N		0x90
-#define	CC_CLKC_M0		0x94
-#define	CC_CLKC_M1		0x98
-#define	CC_CLKC_M2		0x9c
-#define	CC_CLKC_M3		0xa0
-#define	CC_CLKDIV		0xa4
-#define	CC_SYS_CLK_CTL		0xc0
-#define	CC_CLK_CTL_ST		SI_CLK_CTL_ST
-#define	PMU_CTL			0x600
-#define	PMU_CAP			0x604
-#define	PMU_ST			0x608
-#define PMU_RES_STATE		0x60c
-#define PMU_TIMER		0x614
-#define	PMU_MIN_RES_MASK	0x618
-#define	PMU_MAX_RES_MASK	0x61c
-#define CC_CHIPCTL_ADDR         0x650
-#define CC_CHIPCTL_DATA         0x654
-#define PMU_REG_CONTROL_ADDR	0x658
-#define PMU_REG_CONTROL_DATA	0x65C
-#define PMU_PLL_CONTROL_ADDR 	0x660
-#define PMU_PLL_CONTROL_DATA 	0x664
-#define	CC_SROM_OTP		0x800	/* SROM/OTP address space */
-
 /* chipid */
 #define	CID_ID_MASK		0x0000ffff	/* Chip Id mask */
 #define	CID_REV_MASK		0x000f0000	/* Chip Revision mask */
@@ -317,504 +258,6 @@ typedef volatile struct {
 #define	CC_CAP2_SECI		0x00000001	/* SECI Present, rev >= 36 */
 #define	CC_CAP2_GSIO		0x00000002	/* GSIO (spi/i2c) present, rev >= 37 */
 
-/* PLL type */
-#define PLL_NONE		0x00000000
-#define PLL_TYPE1		0x00010000	/* 48MHz base, 3 dividers */
-#define PLL_TYPE2		0x00020000	/* 48MHz, 4 dividers */
-#define PLL_TYPE3		0x00030000	/* 25MHz, 2 dividers */
-#define PLL_TYPE4		0x00008000	/* 48MHz, 4 dividers */
-#define PLL_TYPE5		0x00018000	/* 25MHz, 4 dividers */
-#define PLL_TYPE6		0x00028000	/* 100/200 or 120/240 only */
-#define PLL_TYPE7		0x00038000	/* 25MHz, 4 dividers */
-
-/* ILP clock */
-#define	ILP_CLOCK		32000
-
-/* ALP clock on pre-PMU chips */
-#define	ALP_CLOCK		20000000
-
-/* HT clock */
-#define	HT_CLOCK		80000000
-
-/* corecontrol */
-#define CC_UARTCLKO		0x00000001	/* Drive UART with internal clock */
-#define	CC_SE			0x00000002	/* sync clk out enable (corerev >= 3) */
-#define CC_UARTCLKEN		0x00000008	/* enable UART Clock (corerev > = 21 */
-
-/* chipcontrol */
-#define CHIPCTRL_4321A0_DEFAULT	0x3a4
-#define CHIPCTRL_4321A1_DEFAULT	0x0a4
-#define CHIPCTRL_4321_PLL_DOWN	0x800000	/* serdes PLL down override */
-
-/* Fields in the otpstatus register in rev >= 21 */
-#define OTPS_OL_MASK		0x000000ff
-#define OTPS_OL_MFG		0x00000001	/* manuf row is locked */
-#define OTPS_OL_OR1		0x00000002	/* otp redundancy row 1 is locked */
-#define OTPS_OL_OR2		0x00000004	/* otp redundancy row 2 is locked */
-#define OTPS_OL_GU		0x00000008	/* general use region is locked */
-#define OTPS_GUP_MASK		0x00000f00
-#define OTPS_GUP_SHIFT		8
-#define OTPS_GUP_HW		0x00000100	/* h/w subregion is programmed */
-#define OTPS_GUP_SW		0x00000200	/* s/w subregion is programmed */
-#define OTPS_GUP_CI		0x00000400	/* chipid/pkgopt subregion is programmed */
-#define OTPS_GUP_FUSE		0x00000800	/* fuse subregion is programmed */
-#define OTPS_READY		0x00001000
-#define OTPS_RV(x)		(1 << (16 + (x)))	/* redundancy entry valid */
-#define OTPS_RV_MASK		0x0fff0000
-
-/* Fields in the otpcontrol register in rev >= 21 */
-#define OTPC_PROGSEL		0x00000001
-#define OTPC_PCOUNT_MASK	0x0000000e
-#define OTPC_PCOUNT_SHIFT	1
-#define OTPC_VSEL_MASK		0x000000f0
-#define OTPC_VSEL_SHIFT		4
-#define OTPC_TMM_MASK		0x00000700
-#define OTPC_TMM_SHIFT		8
-#define OTPC_ODM		0x00000800
-#define OTPC_PROGEN		0x80000000
-
-/* Fields in otpprog in rev >= 21 and HND OTP */
-#define OTPP_COL_MASK		0x000000ff
-#define OTPP_COL_SHIFT		0
-#define OTPP_ROW_MASK		0x0000ff00
-#define OTPP_ROW_SHIFT		8
-#define OTPP_OC_MASK		0x0f000000
-#define OTPP_OC_SHIFT		24
-#define OTPP_READERR		0x10000000
-#define OTPP_VALUE_MASK		0x20000000
-#define OTPP_VALUE_SHIFT	29
-#define OTPP_START_BUSY		0x80000000
-#define	OTPP_READ		0x40000000	/* HND OTP */
-
-/* otplayout reg corerev >= 36 */
-#define OTP_CISFORMAT_NEW	0x80000000
-
-/* Opcodes for OTPP_OC field */
-#define OTPPOC_READ		0
-#define OTPPOC_BIT_PROG		1
-#define OTPPOC_VERIFY		3
-#define OTPPOC_INIT		4
-#define OTPPOC_SET		5
-#define OTPPOC_RESET		6
-#define OTPPOC_OCST		7
-#define OTPPOC_ROW_LOCK		8
-#define OTPPOC_PRESCN_TEST	9
-
-/* Jtagm characteristics that appeared at a given corerev */
-#define	JTAGM_CREV_OLD		10	/* Old command set, 16bit max IR */
-#define	JTAGM_CREV_IRP		22	/* Able to do pause-ir */
-#define	JTAGM_CREV_RTI		28	/* Able to do return-to-idle */
-
-/* jtagcmd */
-#define JCMD_START		0x80000000
-#define JCMD_BUSY		0x80000000
-#define JCMD_STATE_MASK		0x60000000
-#define JCMD_STATE_TLR		0x00000000	/* Test-logic-reset */
-#define JCMD_STATE_PIR		0x20000000	/* Pause IR */
-#define JCMD_STATE_PDR		0x40000000	/* Pause DR */
-#define JCMD_STATE_RTI		0x60000000	/* Run-test-idle */
-#define JCMD0_ACC_MASK		0x0000f000
-#define JCMD0_ACC_IRDR		0x00000000
-#define JCMD0_ACC_DR		0x00001000
-#define JCMD0_ACC_IR		0x00002000
-#define JCMD0_ACC_RESET		0x00003000
-#define JCMD0_ACC_IRPDR		0x00004000
-#define JCMD0_ACC_PDR		0x00005000
-#define JCMD0_IRW_MASK		0x00000f00
-#define JCMD_ACC_MASK		0x000f0000	/* Changes for corerev 11 */
-#define JCMD_ACC_IRDR		0x00000000
-#define JCMD_ACC_DR		0x00010000
-#define JCMD_ACC_IR		0x00020000
-#define JCMD_ACC_RESET		0x00030000
-#define JCMD_ACC_IRPDR		0x00040000
-#define JCMD_ACC_PDR		0x00050000
-#define JCMD_ACC_PIR		0x00060000
-#define JCMD_ACC_IRDR_I		0x00070000	/* rev 28: return to run-test-idle */
-#define JCMD_ACC_DR_I		0x00080000	/* rev 28: return to run-test-idle */
-#define JCMD_IRW_MASK		0x00001f00
-#define JCMD_IRW_SHIFT		8
-#define JCMD_DRW_MASK		0x0000003f
-
-/* jtagctrl */
-#define JCTRL_FORCE_CLK		4	/* Force clock */
-#define JCTRL_EXT_EN		2	/* Enable external targets */
-#define JCTRL_EN		1	/* Enable Jtag master */
-
-/* Fields in clkdiv */
-#define	CLKD_SFLASH		0x0f000000
-#define	CLKD_SFLASH_SHIFT	24
-#define	CLKD_OTP		0x000f0000
-#define	CLKD_OTP_SHIFT		16
-#define	CLKD_JTAG		0x00000f00
-#define	CLKD_JTAG_SHIFT		8
-#define	CLKD_UART		0x000000ff
-
-#define	CLKD2_SROM		0x00000003
-
-/* intstatus/intmask */
-#define	CI_GPIO			0x00000001	/* gpio intr */
-#define	CI_EI			0x00000002	/* extif intr (corerev >= 3) */
-#define	CI_TEMP			0x00000004	/* temp. ctrl intr (corerev >= 15) */
-#define	CI_SIRQ			0x00000008	/* serial IRQ intr (corerev >= 15) */
-#define	CI_PMU			0x00000020	/* pmu intr (corerev >= 21) */
-#define	CI_UART			0x00000040	/* uart intr (corerev >= 21) */
-#define	CI_WDRESET		0x80000000	/* watchdog reset occurred */
-
-/* slow_clk_ctl */
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
-#define SCC_CD_SHIFT		16
-
-/* system_clk_ctl */
-#define	SYCC_IE			0x00000001	/* ILPen: Enable Idle Low Power */
-#define	SYCC_AE			0x00000002	/* ALPen: Enable Active Low Power */
-#define	SYCC_FP			0x00000004	/* ForcePLLOn */
-#define	SYCC_AR			0x00000008	/* Force ALP (or HT if ALPen is not set */
-#define	SYCC_HR			0x00000010	/* Force HT */
-#define SYCC_CD_MASK		0xffff0000	/* ClkDiv  (ILP = 1/(4 * (divisor + 1)) */
-#define SYCC_CD_SHIFT		16
-
-/* Indirect backplane access */
-#define	BPIA_BYTEEN		0x0000000f
-#define	BPIA_SZ1		0x00000001
-#define	BPIA_SZ2		0x00000003
-#define	BPIA_SZ4		0x00000007
-#define	BPIA_SZ8		0x0000000f
-#define	BPIA_WRITE		0x00000100
-#define	BPIA_START		0x00000200
-#define	BPIA_BUSY		0x00000200
-#define	BPIA_ERROR		0x00000400
-
-/* pcmcia/prog/flash_config */
-#define	CF_EN			0x00000001	/* enable */
-#define	CF_EM_MASK		0x0000000e	/* mode */
-#define	CF_EM_SHIFT		1
-#define	CF_EM_FLASH		0	/* flash/asynchronous mode */
-#define	CF_EM_SYNC		2	/* synchronous mode */
-#define	CF_EM_PCMCIA		4	/* pcmcia mode */
-#define	CF_DS			0x00000010	/* destsize:  0=8bit, 1=16bit */
-#define	CF_BS			0x00000020	/* byteswap */
-#define	CF_CD_MASK		0x000000c0	/* clock divider */
-#define	CF_CD_SHIFT		6
-#define	CF_CD_DIV2		0x00000000	/* backplane/2 */
-#define	CF_CD_DIV3		0x00000040	/* backplane/3 */
-#define	CF_CD_DIV4		0x00000080	/* backplane/4 */
-#define	CF_CE			0x00000100	/* clock enable */
-#define	CF_SB			0x00000200	/* size/bytestrobe (synch only) */
-
-/* pcmcia_memwait */
-#define	PM_W0_MASK		0x0000003f	/* waitcount0 */
-#define	PM_W1_MASK		0x00001f00	/* waitcount1 */
-#define	PM_W1_SHIFT		8
-#define	PM_W2_MASK		0x001f0000	/* waitcount2 */
-#define	PM_W2_SHIFT		16
-#define	PM_W3_MASK		0x1f000000	/* waitcount3 */
-#define	PM_W3_SHIFT		24
-
-/* pcmcia_attrwait */
-#define	PA_W0_MASK		0x0000003f	/* waitcount0 */
-#define	PA_W1_MASK		0x00001f00	/* waitcount1 */
-#define	PA_W1_SHIFT		8
-#define	PA_W2_MASK		0x001f0000	/* waitcount2 */
-#define	PA_W2_SHIFT		16
-#define	PA_W3_MASK		0x1f000000	/* waitcount3 */
-#define	PA_W3_SHIFT		24
-
-/* pcmcia_iowait */
-#define	PI_W0_MASK		0x0000003f	/* waitcount0 */
-#define	PI_W1_MASK		0x00001f00	/* waitcount1 */
-#define	PI_W1_SHIFT		8
-#define	PI_W2_MASK		0x001f0000	/* waitcount2 */
-#define	PI_W2_SHIFT		16
-#define	PI_W3_MASK		0x1f000000	/* waitcount3 */
-#define	PI_W3_SHIFT		24
-
-/* prog_waitcount */
-#define	PW_W0_MASK		0x0000001f	/* waitcount0 */
-#define	PW_W1_MASK		0x00001f00	/* waitcount1 */
-#define	PW_W1_SHIFT		8
-#define	PW_W2_MASK		0x001f0000	/* waitcount2 */
-#define	PW_W2_SHIFT		16
-#define	PW_W3_MASK		0x1f000000	/* waitcount3 */
-#define	PW_W3_SHIFT		24
-
-#define PW_W0       		0x0000000c
-#define PW_W1       		0x00000a00
-#define PW_W2       		0x00020000
-#define PW_W3       		0x01000000
-
-/* flash_waitcount */
-#define	FW_W0_MASK		0x0000003f	/* waitcount0 */
-#define	FW_W1_MASK		0x00001f00	/* waitcount1 */
-#define	FW_W1_SHIFT		8
-#define	FW_W2_MASK		0x001f0000	/* waitcount2 */
-#define	FW_W2_SHIFT		16
-#define	FW_W3_MASK		0x1f000000	/* waitcount3 */
-#define	FW_W3_SHIFT		24
-
-/* When Srom support present, fields in sromcontrol */
-#define	SRC_START		0x80000000
-#define	SRC_BUSY		0x80000000
-#define	SRC_OPCODE		0x60000000
-#define	SRC_OP_READ		0x00000000
-#define	SRC_OP_WRITE		0x20000000
-#define	SRC_OP_WRDIS		0x40000000
-#define	SRC_OP_WREN		0x60000000
-#define	SRC_OTPSEL		0x00000010
-#define	SRC_LOCK		0x00000008
-#define	SRC_SIZE_MASK		0x00000006
-#define	SRC_SIZE_1K		0x00000000
-#define	SRC_SIZE_4K		0x00000002
-#define	SRC_SIZE_16K		0x00000004
-#define	SRC_SIZE_SHIFT		1
-#define	SRC_PRESENT		0x00000001
-
-/* Fields in pmucontrol */
-#define	PCTL_ILP_DIV_MASK	0xffff0000
-#define	PCTL_ILP_DIV_SHIFT	16
-#define PCTL_PLL_PLLCTL_UPD	0x00000400	/* rev 2 */
-#define PCTL_NOILP_ON_WAIT	0x00000200	/* rev 1 */
-#define	PCTL_HT_REQ_EN		0x00000100
-#define	PCTL_ALP_REQ_EN		0x00000080
-#define	PCTL_XTALFREQ_MASK	0x0000007c
-#define	PCTL_XTALFREQ_SHIFT	2
-#define	PCTL_ILP_DIV_EN		0x00000002
-#define	PCTL_LPO_SEL		0x00000001
-
-/* Fields in clkstretch */
-#define CSTRETCH_HT		0xffff0000
-#define CSTRETCH_ALP		0x0000ffff
-
-/* gpiotimerval */
-#define GPIO_ONTIME_SHIFT	16
-
-/* clockcontrol_n */
-#define	CN_N1_MASK		0x3f	/* n1 control */
-#define	CN_N2_MASK		0x3f00	/* n2 control */
-#define	CN_N2_SHIFT		8
-#define	CN_PLLC_MASK		0xf0000	/* pll control */
-#define	CN_PLLC_SHIFT		16
-
-/* clockcontrol_sb/pci/uart */
-#define	CC_M1_MASK		0x3f	/* m1 control */
-#define	CC_M2_MASK		0x3f00	/* m2 control */
-#define	CC_M2_SHIFT		8
-#define	CC_M3_MASK		0x3f0000	/* m3 control */
-#define	CC_M3_SHIFT		16
-#define	CC_MC_MASK		0x1f000000	/* mux control */
-#define	CC_MC_SHIFT		24
-
-/* N3M Clock control magic field values */
-#define	CC_F6_2			0x02	/* A factor of 2 in */
-#define	CC_F6_3			0x03	/* 6-bit fields like */
-#define	CC_F6_4			0x05	/* N1, M1 or M3 */
-#define	CC_F6_5			0x09
-#define	CC_F6_6			0x11
-#define	CC_F6_7			0x21
-
-#define	CC_F5_BIAS		5	/* 5-bit fields get this added */
-
-#define	CC_MC_BYPASS		0x08
-#define	CC_MC_M1		0x04
-#define	CC_MC_M1M2		0x02
-#define	CC_MC_M1M2M3		0x01
-#define	CC_MC_M1M3		0x11
-
-/* Type 2 Clock control magic field values */
-#define	CC_T2_BIAS		2	/* n1, n2, m1 & m3 bias */
-#define	CC_T2M2_BIAS		3	/* m2 bias */
-
-#define	CC_T2MC_M1BYP		1
-#define	CC_T2MC_M2BYP		2
-#define	CC_T2MC_M3BYP		4
-
-/* Type 6 Clock control magic field values */
-#define	CC_T6_MMASK		1	/* bits of interest in m */
-#define	CC_T6_M0		120000000	/* sb clock for m = 0 */
-#define	CC_T6_M1		100000000	/* sb clock for m = 1 */
-#define	SB2MIPS_T6(sb)		(2 * (sb))
-
-/* Common clock base */
-#define	CC_CLOCK_BASE1		24000000	/* Half the clock freq */
-#define CC_CLOCK_BASE2		12500000	/* Alternate crystal on some PLLs */
-
-/* Clock control values for 200MHz in 5350 */
-#define	CLKC_5350_N		0x0311
-#define	CLKC_5350_M		0x04020009
-
-/* Flash types in the chipcommon capabilities register */
-#define FLASH_NONE		0x000	/* No flash */
-#define SFLASH_ST		0x100	/* ST serial flash */
-#define SFLASH_AT		0x200	/* Atmel serial flash */
-#define	PFLASH			0x700	/* Parallel flash */
-
-/* Bits in the ExtBus config registers */
-#define	CC_CFG_EN		0x0001	/* Enable */
-#define	CC_CFG_EM_MASK		0x000e	/* Extif Mode */
-#define	CC_CFG_EM_ASYNC		0x0000	/*   Async/Parallel flash */
-#define	CC_CFG_EM_SYNC		0x0002	/*   Synchronous */
-#define	CC_CFG_EM_PCMCIA	0x0004	/*   PCMCIA */
-#define	CC_CFG_EM_IDE		0x0006	/*   IDE */
-#define	CC_CFG_DS		0x0010	/* Data size, 0=8bit, 1=16bit */
-#define	CC_CFG_CD_MASK		0x00e0	/* Sync: Clock divisor, rev >= 20 */
-#define	CC_CFG_CE		0x0100	/* Sync: Clock enable, rev >= 20 */
-#define	CC_CFG_SB		0x0200	/* Sync: Size/Bytestrobe, rev >= 20 */
-#define	CC_CFG_IS		0x0400	/* Extif Sync Clk Select, rev >= 20 */
-
-/* ExtBus address space */
-#define	CC_EB_BASE		0x1a000000	/* Chipc ExtBus base address */
-#define	CC_EB_PCMCIA_MEM	0x1a000000	/* PCMCIA 0 memory base address */
-#define	CC_EB_PCMCIA_IO		0x1a200000	/* PCMCIA 0 I/O base address */
-#define	CC_EB_PCMCIA_CFG	0x1a400000	/* PCMCIA 0 config base address */
-#define	CC_EB_IDE		0x1a800000	/* IDE memory base */
-#define	CC_EB_PCMCIA1_MEM	0x1a800000	/* PCMCIA 1 memory base address */
-#define	CC_EB_PCMCIA1_IO	0x1aa00000	/* PCMCIA 1 I/O base address */
-#define	CC_EB_PCMCIA1_CFG	0x1ac00000	/* PCMCIA 1 config base address */
-#define	CC_EB_PROGIF		0x1b000000	/* ProgIF Async/Sync base address */
-
-/* Start/busy bit in flashcontrol */
-#define SFLASH_OPCODE		0x000000ff
-#define SFLASH_ACTION		0x00000700
-#define	SFLASH_CS_ACTIVE	0x00001000	/* Chip Select Active, rev >= 20 */
-#define SFLASH_START		0x80000000
-#define SFLASH_BUSY		SFLASH_START
-
-/* flashcontrol action codes */
-#define	SFLASH_ACT_OPONLY	0x0000	/* Issue opcode only */
-#define	SFLASH_ACT_OP1D		0x0100	/* opcode + 1 data byte */
-#define	SFLASH_ACT_OP3A		0x0200	/* opcode + 3 addr bytes */
-#define	SFLASH_ACT_OP3A1D	0x0300	/* opcode + 3 addr & 1 data bytes */
-#define	SFLASH_ACT_OP3A4D	0x0400	/* opcode + 3 addr & 4 data bytes */
-#define	SFLASH_ACT_OP3A4X4D	0x0500	/* opcode + 3 addr, 4 don't care & 4 data bytes */
-#define	SFLASH_ACT_OP3A1X4D	0x0700	/* opcode + 3 addr, 1 don't care & 4 data bytes */
-
-/* flashcontrol action+opcodes for ST flashes */
-#define SFLASH_ST_WREN		0x0006	/* Write Enable */
-#define SFLASH_ST_WRDIS		0x0004	/* Write Disable */
-#define SFLASH_ST_RDSR		0x0105	/* Read Status Register */
-#define SFLASH_ST_WRSR		0x0101	/* Write Status Register */
-#define SFLASH_ST_READ		0x0303	/* Read Data Bytes */
-#define SFLASH_ST_PP		0x0302	/* Page Program */
-#define SFLASH_ST_SE		0x02d8	/* Sector Erase */
-#define SFLASH_ST_BE		0x00c7	/* Bulk Erase */
-#define SFLASH_ST_DP		0x00b9	/* Deep Power-down */
-#define SFLASH_ST_RES		0x03ab	/* Read Electronic Signature */
-#define SFLASH_ST_CSA		0x1000	/* Keep chip select asserted */
-#define SFLASH_ST_SSE		0x0220	/* Sub-sector Erase */
-
-/* Status register bits for ST flashes */
-#define SFLASH_ST_WIP		0x01	/* Write In Progress */
-#define SFLASH_ST_WEL		0x02	/* Write Enable Latch */
-#define SFLASH_ST_BP_MASK	0x1c	/* Block Protect */
-#define SFLASH_ST_BP_SHIFT	2
-#define SFLASH_ST_SRWD		0x80	/* Status Register Write Disable */
-
-/* flashcontrol action+opcodes for Atmel flashes */
-#define SFLASH_AT_READ				0x07e8
-#define SFLASH_AT_PAGE_READ			0x07d2
-#define SFLASH_AT_BUF1_READ
-#define SFLASH_AT_BUF2_READ
-#define SFLASH_AT_STATUS			0x01d7
-#define SFLASH_AT_BUF1_WRITE			0x0384
-#define SFLASH_AT_BUF2_WRITE			0x0387
-#define SFLASH_AT_BUF1_ERASE_PROGRAM		0x0283
-#define SFLASH_AT_BUF2_ERASE_PROGRAM		0x0286
-#define SFLASH_AT_BUF1_PROGRAM			0x0288
-#define SFLASH_AT_BUF2_PROGRAM			0x0289
-#define SFLASH_AT_PAGE_ERASE			0x0281
-#define SFLASH_AT_BLOCK_ERASE			0x0250
-#define SFLASH_AT_BUF1_WRITE_ERASE_PROGRAM	0x0382
-#define SFLASH_AT_BUF2_WRITE_ERASE_PROGRAM	0x0385
-#define SFLASH_AT_BUF1_LOAD			0x0253
-#define SFLASH_AT_BUF2_LOAD			0x0255
-#define SFLASH_AT_BUF1_COMPARE			0x0260
-#define SFLASH_AT_BUF2_COMPARE			0x0261
-#define SFLASH_AT_BUF1_REPROGRAM		0x0258
-#define SFLASH_AT_BUF2_REPROGRAM		0x0259
-
-/* Status register bits for Atmel flashes */
-#define SFLASH_AT_READY				0x80
-#define SFLASH_AT_MISMATCH			0x40
-#define SFLASH_AT_ID_MASK			0x38
-#define SFLASH_AT_ID_SHIFT			3
-
-/*
- * These are the UART port assignments, expressed as offsets from the base
- * register.  These assignments should hold for any serial port based on
- * a 8250, 16450, or 16550(A).
- */
-
-#define UART_RX		0	/* In:  Receive buffer (DLAB=0) */
-#define UART_TX		0	/* Out: Transmit buffer (DLAB=0) */
-#define UART_DLL	0	/* Out: Divisor Latch Low (DLAB=1) */
-#define UART_IER	1	/* In/Out: Interrupt Enable Register (DLAB=0) */
-#define UART_DLM	1	/* Out: Divisor Latch High (DLAB=1) */
-#define UART_IIR	2	/* In: Interrupt Identity Register  */
-#define UART_FCR	2	/* Out: FIFO Control Register */
-#define UART_LCR	3	/* Out: Line Control Register */
-#define UART_MCR	4	/* Out: Modem Control Register */
-#define UART_LSR	5	/* In:  Line Status Register */
-#define UART_MSR	6	/* In:  Modem Status Register */
-#define UART_SCR	7	/* I/O: Scratch Register */
-#define UART_LCR_DLAB	0x80	/* Divisor latch access bit */
-#define UART_LCR_WLEN8	0x03	/* Word length: 8 bits */
-#define UART_MCR_OUT2	0x08	/* MCR GPIO out 2 */
-#define UART_MCR_LOOP	0x10	/* Enable loopback test mode */
-#define UART_LSR_RX_FIFO 	0x80	/* Receive FIFO error */
-#define UART_LSR_TDHR		0x40	/* Data-hold-register empty */
-#define UART_LSR_THRE		0x20	/* Transmit-hold-register empty */
-#define UART_LSR_BREAK		0x10	/* Break interrupt */
-#define UART_LSR_FRAMING	0x08	/* Framing error */
-#define UART_LSR_PARITY		0x04	/* Parity error */
-#define UART_LSR_OVERRUN	0x02	/* Overrun error */
-#define UART_LSR_RXRDY		0x01	/* Receiver ready */
-#define UART_FCR_FIFO_ENABLE 1	/* FIFO control register bit controlling FIFO enable/disable */
-
-/* Interrupt Identity Register (IIR) bits */
-#define UART_IIR_FIFO_MASK	0xc0	/* IIR FIFO disable/enabled mask */
-#define UART_IIR_INT_MASK	0xf	/* IIR interrupt ID source */
-#define UART_IIR_MDM_CHG	0x0	/* Modem status changed */
-#define UART_IIR_NOINT		0x1	/* No interrupt pending */
-#define UART_IIR_THRE		0x2	/* THR empty */
-#define UART_IIR_RCVD_DATA	0x4	/* Received data available */
-#define UART_IIR_RCVR_STATUS 	0x6	/* Receiver status */
-#define UART_IIR_CHAR_TIME 	0xc	/* Character time */
-
-/* Interrupt Enable Register (IER) bits */
-#define UART_IER_EDSSI	8	/* enable modem status interrupt */
-#define UART_IER_ELSI	4	/* enable receiver line status interrupt */
-#define UART_IER_ETBEI  2	/* enable transmitter holding register empty interrupt */
-#define UART_IER_ERBFI	1	/* enable data available interrupt */
-
-/* pmustatus */
-#define PST_EXTLPOAVAIL	0x0100
-#define PST_WDRESET	0x0080
-#define	PST_INTPEND	0x0040
-#define	PST_SBCLKST	0x0030
-#define	PST_SBCLKST_ILP	0x0010
-#define	PST_SBCLKST_ALP	0x0020
-#define	PST_SBCLKST_HT	0x0030
-#define	PST_ALPAVAIL	0x0008
-#define	PST_HTAVAIL	0x0004
-#define	PST_RESINIT	0x0003
-
 /* pmucapabilities */
 #define PCAP_REV_MASK	0x000000ff
 #define PCAP_RC_MASK	0x00001f00
@@ -834,755 +277,10 @@ typedef volatile struct {
 #define PCAP5_CC_MASK	0xf8000000
 #define PCAP5_CC_SHIFT	27
 
-/* PMU Resource Request Timer registers */
-/* This is based on PmuRev0 */
-#define	PRRT_TIME_MASK	0x03ff
-#define	PRRT_INTEN	0x0400
-#define	PRRT_REQ_ACTIVE	0x0800
-#define	PRRT_ALP_REQ	0x1000
-#define	PRRT_HT_REQ	0x2000
-
-/* PMU resource bit position */
-#define PMURES_BIT(bit)	(1 << (bit))
-
-/* PMU resource number limit */
-#define PMURES_MAX_RESNUM	30
-
-/* PMU chip control0 register */
-#define	PMU_CHIPCTL0		0
-
-/* PMU chip control1 register */
-#define	PMU_CHIPCTL1			1
-#define	PMU_CC1_RXC_DLL_BYPASS		0x00010000
-
-#define PMU_CC1_IF_TYPE_MASK   		0x00000030
-#define PMU_CC1_IF_TYPE_RMII    	0x00000000
-#define PMU_CC1_IF_TYPE_MII     	0x00000010
-#define PMU_CC1_IF_TYPE_RGMII   	0x00000020
-
-#define PMU_CC1_SW_TYPE_MASK    	0x000000c0
-#define PMU_CC1_SW_TYPE_EPHY    	0x00000000
-#define PMU_CC1_SW_TYPE_EPHYMII 	0x00000040
-#define PMU_CC1_SW_TYPE_EPHYRMII	0x00000080
-#define PMU_CC1_SW_TYPE_RGMII   	0x000000c0
-
-/* PMU corerev and chip specific PLL controls.
- * PMU<rev>_PLL<num>_XX where <rev> is PMU corerev and <num> is an arbitrary number
- * to differentiate different PLLs controlled by the same PMU rev.
- */
-/* pllcontrol registers */
-/* PDIV, div_phy, div_arm, div_adc, dith_sel, ioff, kpd_scale, lsb_sel, mash_sel, lf_c & lf_r */
-#define	PMU0_PLL0_PLLCTL0		0
-#define	PMU0_PLL0_PC0_PDIV_MASK		1
-#define	PMU0_PLL0_PC0_PDIV_FREQ		25000
-#define PMU0_PLL0_PC0_DIV_ARM_MASK	0x00000038
-#define PMU0_PLL0_PC0_DIV_ARM_SHIFT	3
-#define PMU0_PLL0_PC0_DIV_ARM_BASE	8
-
-/* PC0_DIV_ARM for PLLOUT_ARM */
-#define PMU0_PLL0_PC0_DIV_ARM_110MHZ	0
-#define PMU0_PLL0_PC0_DIV_ARM_97_7MHZ	1
-#define PMU0_PLL0_PC0_DIV_ARM_88MHZ	2
-#define PMU0_PLL0_PC0_DIV_ARM_80MHZ	3	/* Default */
-#define PMU0_PLL0_PC0_DIV_ARM_73_3MHZ	4
-#define PMU0_PLL0_PC0_DIV_ARM_67_7MHZ	5
-#define PMU0_PLL0_PC0_DIV_ARM_62_9MHZ	6
-#define PMU0_PLL0_PC0_DIV_ARM_58_6MHZ	7
-
-/* Wildcard base, stop_mod, en_lf_tp, en_cal & lf_r2 */
-#define	PMU0_PLL0_PLLCTL1		1
-#define	PMU0_PLL0_PC1_WILD_INT_MASK	0xf0000000
-#define	PMU0_PLL0_PC1_WILD_INT_SHIFT	28
-#define	PMU0_PLL0_PC1_WILD_FRAC_MASK	0x0fffff00
-#define	PMU0_PLL0_PC1_WILD_FRAC_SHIFT	8
-#define	PMU0_PLL0_PC1_STOP_MOD		0x00000040
-
-/* Wildcard base, vco_calvar, vco_swc, vco_var_selref, vso_ical & vco_sel_avdd */
-#define	PMU0_PLL0_PLLCTL2		2
-#define	PMU0_PLL0_PC2_WILD_INT_MASK	0xf
-#define	PMU0_PLL0_PC2_WILD_INT_SHIFT	4
-
-/* pllcontrol registers */
-/* ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>, p1div, p2div, _bypass_sdmod */
-#define PMU1_PLL0_PLLCTL0		0
-#define PMU1_PLL0_PC0_P1DIV_MASK	0x00f00000
-#define PMU1_PLL0_PC0_P1DIV_SHIFT	20
-#define PMU1_PLL0_PC0_P2DIV_MASK	0x0f000000
-#define PMU1_PLL0_PC0_P2DIV_SHIFT	24
-
-/* m<x>div */
-#define PMU1_PLL0_PLLCTL1		1
-#define PMU1_PLL0_PC1_M1DIV_MASK	0x000000ff
-#define PMU1_PLL0_PC1_M1DIV_SHIFT	0
-#define PMU1_PLL0_PC1_M2DIV_MASK	0x0000ff00
-#define PMU1_PLL0_PC1_M2DIV_SHIFT	8
-#define PMU1_PLL0_PC1_M3DIV_MASK	0x00ff0000
-#define PMU1_PLL0_PC1_M3DIV_SHIFT	16
-#define PMU1_PLL0_PC1_M4DIV_MASK	0xff000000
-#define PMU1_PLL0_PC1_M4DIV_SHIFT	24
-
-#define DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT 8
-#define DOT11MAC_880MHZ_CLK_DIVISOR_MASK (0xFF << DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT)
-#define DOT11MAC_880MHZ_CLK_DIVISOR_VAL  (0xE << DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT)
-
-/* m<x>div, ndiv_dither_mfb, ndiv_mode, ndiv_int */
-#define PMU1_PLL0_PLLCTL2		2
-#define PMU1_PLL0_PC2_M5DIV_MASK	0x000000ff
-#define PMU1_PLL0_PC2_M5DIV_SHIFT	0
-#define PMU1_PLL0_PC2_M6DIV_MASK	0x0000ff00
-#define PMU1_PLL0_PC2_M6DIV_SHIFT	8
-#define PMU1_PLL0_PC2_NDIV_MODE_MASK	0x000e0000
-#define PMU1_PLL0_PC2_NDIV_MODE_SHIFT	17
-#define PMU1_PLL0_PC2_NDIV_MODE_MASH	1
-#define PMU1_PLL0_PC2_NDIV_MODE_MFB	2	/* recommended for 4319 */
-#define PMU1_PLL0_PC2_NDIV_INT_MASK	0x1ff00000
-#define PMU1_PLL0_PC2_NDIV_INT_SHIFT	20
-
-/* ndiv_frac */
-#define PMU1_PLL0_PLLCTL3		3
-#define PMU1_PLL0_PC3_NDIV_FRAC_MASK	0x00ffffff
-#define PMU1_PLL0_PC3_NDIV_FRAC_SHIFT	0
-
-/* pll_ctrl */
-#define PMU1_PLL0_PLLCTL4		4
-
-/* pll_ctrl, vco_rng, clkdrive_ch<x> */
-#define PMU1_PLL0_PLLCTL5		5
-#define PMU1_PLL0_PC5_CLK_DRV_MASK 0xffffff00
-#define PMU1_PLL0_PC5_CLK_DRV_SHIFT 8
-
-/* PMU rev 2 control words */
-#define PMU2_PHY_PLL_PLLCTL		4
-#define PMU2_SI_PLL_PLLCTL		10
-
-/* PMU rev 2 */
-/* pllcontrol registers */
-/* ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>, p1div, p2div, _bypass_sdmod */
-#define PMU2_PLL_PLLCTL0		0
-#define PMU2_PLL_PC0_P1DIV_MASK 	0x00f00000
-#define PMU2_PLL_PC0_P1DIV_SHIFT	20
-#define PMU2_PLL_PC0_P2DIV_MASK 	0x0f000000
-#define PMU2_PLL_PC0_P2DIV_SHIFT	24
-
-/* m<x>div */
-#define PMU2_PLL_PLLCTL1		1
-#define PMU2_PLL_PC1_M1DIV_MASK 	0x000000ff
-#define PMU2_PLL_PC1_M1DIV_SHIFT	0
-#define PMU2_PLL_PC1_M2DIV_MASK 	0x0000ff00
-#define PMU2_PLL_PC1_M2DIV_SHIFT	8
-#define PMU2_PLL_PC1_M3DIV_MASK 	0x00ff0000
-#define PMU2_PLL_PC1_M3DIV_SHIFT	16
-#define PMU2_PLL_PC1_M4DIV_MASK 	0xff000000
-#define PMU2_PLL_PC1_M4DIV_SHIFT	24
-
-/* m<x>div, ndiv_dither_mfb, ndiv_mode, ndiv_int */
-#define PMU2_PLL_PLLCTL2		2
-#define PMU2_PLL_PC2_M5DIV_MASK 	0x000000ff
-#define PMU2_PLL_PC2_M5DIV_SHIFT	0
-#define PMU2_PLL_PC2_M6DIV_MASK 	0x0000ff00
-#define PMU2_PLL_PC2_M6DIV_SHIFT	8
-#define PMU2_PLL_PC2_NDIV_MODE_MASK	0x000e0000
-#define PMU2_PLL_PC2_NDIV_MODE_SHIFT	17
-#define PMU2_PLL_PC2_NDIV_INT_MASK	0x1ff00000
-#define PMU2_PLL_PC2_NDIV_INT_SHIFT	20
-
-/* ndiv_frac */
-#define PMU2_PLL_PLLCTL3		3
-#define PMU2_PLL_PC3_NDIV_FRAC_MASK	0x00ffffff
-#define PMU2_PLL_PC3_NDIV_FRAC_SHIFT	0
-
-/* pll_ctrl */
-#define PMU2_PLL_PLLCTL4		4
-
-/* pll_ctrl, vco_rng, clkdrive_ch<x> */
-#define PMU2_PLL_PLLCTL5		5
-#define PMU2_PLL_PC5_CLKDRIVE_CH1_MASK	0x00000f00
-#define PMU2_PLL_PC5_CLKDRIVE_CH1_SHIFT	8
-#define PMU2_PLL_PC5_CLKDRIVE_CH2_MASK	0x0000f000
-#define PMU2_PLL_PC5_CLKDRIVE_CH2_SHIFT	12
-#define PMU2_PLL_PC5_CLKDRIVE_CH3_MASK	0x000f0000
-#define PMU2_PLL_PC5_CLKDRIVE_CH3_SHIFT	16
-#define PMU2_PLL_PC5_CLKDRIVE_CH4_MASK	0x00f00000
-#define PMU2_PLL_PC5_CLKDRIVE_CH4_SHIFT	20
-#define PMU2_PLL_PC5_CLKDRIVE_CH5_MASK	0x0f000000
-#define PMU2_PLL_PC5_CLKDRIVE_CH5_SHIFT	24
-#define PMU2_PLL_PC5_CLKDRIVE_CH6_MASK	0xf0000000
-#define PMU2_PLL_PC5_CLKDRIVE_CH6_SHIFT	28
-
-/* PMU rev 5 (& 6) */
-#define	PMU5_PLL_P1P2_OFF		0
-#define	PMU5_PLL_P1_MASK		0x0f000000
-#define	PMU5_PLL_P1_SHIFT		24
-#define	PMU5_PLL_P2_MASK		0x00f00000
-#define	PMU5_PLL_P2_SHIFT		20
-#define	PMU5_PLL_M14_OFF		1
-#define	PMU5_PLL_MDIV_MASK		0x000000ff
-#define	PMU5_PLL_MDIV_WIDTH		8
-#define	PMU5_PLL_NM5_OFF		2
-#define	PMU5_PLL_NDIV_MASK		0xfff00000
-#define	PMU5_PLL_NDIV_SHIFT		20
-#define	PMU5_PLL_NDIV_MODE_MASK		0x000e0000
-#define	PMU5_PLL_NDIV_MODE_SHIFT	17
-#define	PMU5_PLL_FMAB_OFF		3
-#define	PMU5_PLL_MRAT_MASK		0xf0000000
-#define	PMU5_PLL_MRAT_SHIFT		28
-#define	PMU5_PLL_ABRAT_MASK		0x08000000
-#define	PMU5_PLL_ABRAT_SHIFT		27
-#define	PMU5_PLL_FDIV_MASK		0x07ffffff
-#define	PMU5_PLL_PLLCTL_OFF		4
-#define	PMU5_PLL_PCHI_OFF		5
-#define	PMU5_PLL_PCHI_MASK		0x0000003f
-
-/* pmu XtalFreqRatio */
-#define	PMU_XTALFREQ_REG_ILPCTR_MASK	0x00001FFF
-#define	PMU_XTALFREQ_REG_MEASURE_MASK	0x80000000
-#define	PMU_XTALFREQ_REG_MEASURE_SHIFT	31
-
-/* Divider allocation in 4716/47162/5356/5357 */
-#define	PMU5_MAINPLL_CPU		1
-#define	PMU5_MAINPLL_MEM		2
-#define	PMU5_MAINPLL_SI			3
-
-#define PMU7_PLL_PLLCTL7                7
-#define PMU7_PLL_PLLCTL8                8
-#define PMU7_PLL_PLLCTL11		11
-
-/* PLL usage in 4716/47162 */
-#define	PMU4716_MAINPLL_PLL0		12
-
-/* PLL usage in 5356/5357 */
-#define	PMU5356_MAINPLL_PLL0		0
-#define	PMU5357_MAINPLL_PLL0		0
-
-/* 4716/47162 resources */
-#define RES4716_PROC_PLL_ON		0x00000040
-#define RES4716_PROC_HT_AVAIL		0x00000080
-
-/* 4716/4717/4718 Chip specific ChipControl register bits */
-#define CCTRL471X_I2S_PINS_ENABLE          0x0080	/* I2S pins off by default, shared with pflash */
-
-/* 5354 resources */
-#define RES5354_EXT_SWITCHER_PWM	0	/* 0x00001 */
-#define RES5354_BB_SWITCHER_PWM		1	/* 0x00002 */
-#define RES5354_BB_SWITCHER_BURST	2	/* 0x00004 */
-#define RES5354_BB_EXT_SWITCHER_BURST	3	/* 0x00008 */
-#define RES5354_ILP_REQUEST		4	/* 0x00010 */
-#define RES5354_RADIO_SWITCHER_PWM	5	/* 0x00020 */
-#define RES5354_RADIO_SWITCHER_BURST	6	/* 0x00040 */
-#define RES5354_ROM_SWITCH		7	/* 0x00080 */
-#define RES5354_PA_REF_LDO		8	/* 0x00100 */
-#define RES5354_RADIO_LDO		9	/* 0x00200 */
-#define RES5354_AFE_LDO			10	/* 0x00400 */
-#define RES5354_PLL_LDO			11	/* 0x00800 */
-#define RES5354_BG_FILTBYP		12	/* 0x01000 */
-#define RES5354_TX_FILTBYP		13	/* 0x02000 */
-#define RES5354_RX_FILTBYP		14	/* 0x04000 */
-#define RES5354_XTAL_PU			15	/* 0x08000 */
-#define RES5354_XTAL_EN			16	/* 0x10000 */
-#define RES5354_BB_PLL_FILTBYP		17	/* 0x20000 */
-#define RES5354_RF_PLL_FILTBYP		18	/* 0x40000 */
-#define RES5354_BB_PLL_PU		19	/* 0x80000 */
-
-/* 5357 Chip specific ChipControl register bits */
-#define CCTRL5357_EXTPA                 (1<<14)	/* extPA in ChipControl 1, bit 14 */
-#define CCTRL5357_ANT_MUX_2o3		(1<<15)	/* 2o3 in ChipControl 1, bit 15 */
-
-/* 4328 resources */
-#define RES4328_EXT_SWITCHER_PWM	0	/* 0x00001 */
-#define RES4328_BB_SWITCHER_PWM		1	/* 0x00002 */
-#define RES4328_BB_SWITCHER_BURST	2	/* 0x00004 */
-#define RES4328_BB_EXT_SWITCHER_BURST	3	/* 0x00008 */
-#define RES4328_ILP_REQUEST		4	/* 0x00010 */
-#define RES4328_RADIO_SWITCHER_PWM	5	/* 0x00020 */
-#define RES4328_RADIO_SWITCHER_BURST	6	/* 0x00040 */
-#define RES4328_ROM_SWITCH		7	/* 0x00080 */
-#define RES4328_PA_REF_LDO		8	/* 0x00100 */
-#define RES4328_RADIO_LDO		9	/* 0x00200 */
-#define RES4328_AFE_LDO			10	/* 0x00400 */
-#define RES4328_PLL_LDO			11	/* 0x00800 */
-#define RES4328_BG_FILTBYP		12	/* 0x01000 */
-#define RES4328_TX_FILTBYP		13	/* 0x02000 */
-#define RES4328_RX_FILTBYP		14	/* 0x04000 */
-#define RES4328_XTAL_PU			15	/* 0x08000 */
-#define RES4328_XTAL_EN			16	/* 0x10000 */
-#define RES4328_BB_PLL_FILTBYP		17	/* 0x20000 */
-#define RES4328_RF_PLL_FILTBYP		18	/* 0x40000 */
-#define RES4328_BB_PLL_PU		19	/* 0x80000 */
-
-/* 4325 A0/A1 resources */
-#define RES4325_BUCK_BOOST_BURST	0	/* 0x00000001 */
-#define RES4325_CBUCK_BURST		1	/* 0x00000002 */
-#define RES4325_CBUCK_PWM		2	/* 0x00000004 */
-#define RES4325_CLDO_CBUCK_BURST	3	/* 0x00000008 */
-#define RES4325_CLDO_CBUCK_PWM		4	/* 0x00000010 */
-#define RES4325_BUCK_BOOST_PWM		5	/* 0x00000020 */
-#define RES4325_ILP_REQUEST		6	/* 0x00000040 */
-#define RES4325_ABUCK_BURST		7	/* 0x00000080 */
-#define RES4325_ABUCK_PWM		8	/* 0x00000100 */
-#define RES4325_LNLDO1_PU		9	/* 0x00000200 */
-#define RES4325_OTP_PU			10	/* 0x00000400 */
-#define RES4325_LNLDO3_PU		11	/* 0x00000800 */
-#define RES4325_LNLDO4_PU		12	/* 0x00001000 */
-#define RES4325_XTAL_PU			13	/* 0x00002000 */
-#define RES4325_ALP_AVAIL		14	/* 0x00004000 */
-#define RES4325_RX_PWRSW_PU		15	/* 0x00008000 */
-#define RES4325_TX_PWRSW_PU		16	/* 0x00010000 */
-#define RES4325_RFPLL_PWRSW_PU		17	/* 0x00020000 */
-#define RES4325_LOGEN_PWRSW_PU		18	/* 0x00040000 */
-#define RES4325_AFE_PWRSW_PU		19	/* 0x00080000 */
-#define RES4325_BBPLL_PWRSW_PU		20	/* 0x00100000 */
-#define RES4325_HT_AVAIL		21	/* 0x00200000 */
-
-/* 4325 B0/C0 resources */
-#define RES4325B0_CBUCK_LPOM		1	/* 0x00000002 */
-#define RES4325B0_CBUCK_BURST		2	/* 0x00000004 */
-#define RES4325B0_CBUCK_PWM		3	/* 0x00000008 */
-#define RES4325B0_CLDO_PU		4	/* 0x00000010 */
-
-/* 4325 C1 resources */
-#define RES4325C1_LNLDO2_PU		12	/* 0x00001000 */
-
-/* 4325 chip-specific ChipStatus register bits */
-#define CST4325_SPROM_OTP_SEL_MASK	0x00000003
-#define CST4325_DEFCIS_SEL		0	/* OTP is powered up, use def. CIS, no SPROM */
-#define CST4325_SPROM_SEL		1	/* OTP is powered up, SPROM is present */
-#define CST4325_OTP_SEL			2	/* OTP is powered up, no SPROM */
-#define CST4325_OTP_PWRDN		3	/* OTP is powered down, SPROM is present */
-#define CST4325_SDIO_USB_MODE_MASK	0x00000004
-#define CST4325_SDIO_USB_MODE_SHIFT	2
-#define CST4325_RCAL_VALID_MASK		0x00000008
-#define CST4325_RCAL_VALID_SHIFT	3
-#define CST4325_RCAL_VALUE_MASK		0x000001f0
-#define CST4325_RCAL_VALUE_SHIFT	4
-#define CST4325_PMUTOP_2B_MASK 		0x00000200	/* 1 for 2b, 0 for to 2a */
-#define CST4325_PMUTOP_2B_SHIFT   	9
-
-#define RES4329_RESERVED0		0	/* 0x00000001 */
-#define RES4329_CBUCK_LPOM		1	/* 0x00000002 */
-#define RES4329_CBUCK_BURST		2	/* 0x00000004 */
-#define RES4329_CBUCK_PWM		3	/* 0x00000008 */
-#define RES4329_CLDO_PU			4	/* 0x00000010 */
-#define RES4329_PALDO_PU		5	/* 0x00000020 */
-#define RES4329_ILP_REQUEST		6	/* 0x00000040 */
-#define RES4329_RESERVED7		7	/* 0x00000080 */
-#define RES4329_RESERVED8		8	/* 0x00000100 */
-#define RES4329_LNLDO1_PU		9	/* 0x00000200 */
-#define RES4329_OTP_PU			10	/* 0x00000400 */
-#define RES4329_RESERVED11		11	/* 0x00000800 */
-#define RES4329_LNLDO2_PU		12	/* 0x00001000 */
-#define RES4329_XTAL_PU			13	/* 0x00002000 */
-#define RES4329_ALP_AVAIL		14	/* 0x00004000 */
-#define RES4329_RX_PWRSW_PU		15	/* 0x00008000 */
-#define RES4329_TX_PWRSW_PU		16	/* 0x00010000 */
-#define RES4329_RFPLL_PWRSW_PU		17	/* 0x00020000 */
-#define RES4329_LOGEN_PWRSW_PU		18	/* 0x00040000 */
-#define RES4329_AFE_PWRSW_PU		19	/* 0x00080000 */
-#define RES4329_BBPLL_PWRSW_PU		20	/* 0x00100000 */
-#define RES4329_HT_AVAIL		21	/* 0x00200000 */
-
-#define CST4329_SPROM_OTP_SEL_MASK	0x00000003
-#define CST4329_DEFCIS_SEL		0	/* OTP is powered up, use def. CIS, no SPROM */
-#define CST4329_SPROM_SEL		1	/* OTP is powered up, SPROM is present */
-#define CST4329_OTP_SEL			2	/* OTP is powered up, no SPROM */
-#define CST4329_OTP_PWRDN		3	/* OTP is powered down, SPROM is present */
-#define CST4329_SPI_SDIO_MODE_MASK	0x00000004
-#define CST4329_SPI_SDIO_MODE_SHIFT	2
-
-/* 4312 chip-specific ChipStatus register bits */
-#define CST4312_SPROM_OTP_SEL_MASK	0x00000003
-#define CST4312_DEFCIS_SEL		0	/* OTP is powered up, use def. CIS, no SPROM */
-#define CST4312_SPROM_SEL		1	/* OTP is powered up, SPROM is present */
-#define CST4312_OTP_SEL			2	/* OTP is powered up, no SPROM */
-#define CST4312_OTP_BAD			3	/* OTP is broken, SPROM is present */
-
-/* 4312 resources (all PMU chips with little memory constraint) */
-#define RES4312_SWITCHER_BURST		0	/* 0x00000001 */
-#define RES4312_SWITCHER_PWM    	1	/* 0x00000002 */
-#define RES4312_PA_REF_LDO		2	/* 0x00000004 */
-#define RES4312_CORE_LDO_BURST		3	/* 0x00000008 */
-#define RES4312_CORE_LDO_PWM		4	/* 0x00000010 */
-#define RES4312_RADIO_LDO		5	/* 0x00000020 */
-#define RES4312_ILP_REQUEST		6	/* 0x00000040 */
-#define RES4312_BG_FILTBYP		7	/* 0x00000080 */
-#define RES4312_TX_FILTBYP		8	/* 0x00000100 */
-#define RES4312_RX_FILTBYP		9	/* 0x00000200 */
-#define RES4312_XTAL_PU			10	/* 0x00000400 */
-#define RES4312_ALP_AVAIL		11	/* 0x00000800 */
-#define RES4312_BB_PLL_FILTBYP		12	/* 0x00001000 */
-#define RES4312_RF_PLL_FILTBYP		13	/* 0x00002000 */
-#define RES4312_HT_AVAIL		14	/* 0x00004000 */
-
-/* 4322 resources */
-#define RES4322_RF_LDO			0
-#define RES4322_ILP_REQUEST		1
-#define RES4322_XTAL_PU			2
-#define RES4322_ALP_AVAIL		3
-#define RES4322_SI_PLL_ON		4
-#define RES4322_HT_SI_AVAIL		5
-#define RES4322_PHY_PLL_ON		6
-#define RES4322_HT_PHY_AVAIL		7
-#define RES4322_OTP_PU			8
-
-/* 4322 chip-specific ChipStatus register bits */
-#define CST4322_XTAL_FREQ_20_40MHZ	0x00000020
-#define CST4322_SPROM_OTP_SEL_MASK	0x000000c0
-#define CST4322_SPROM_OTP_SEL_SHIFT	6
-#define CST4322_NO_SPROM_OTP		0	/* no OTP, no SPROM */
-#define CST4322_SPROM_PRESENT		1	/* SPROM is present */
-#define CST4322_OTP_PRESENT		2	/* OTP is present */
-#define CST4322_PCI_OR_USB		0x00000100
-#define CST4322_BOOT_MASK		0x00000600
-#define CST4322_BOOT_SHIFT		9
-#define CST4322_BOOT_FROM_SRAM		0	/* boot from SRAM, ARM in reset */
-#define CST4322_BOOT_FROM_ROM		1	/* boot from ROM */
-#define CST4322_BOOT_FROM_FLASH		2	/* boot from FLASH */
-#define CST4322_BOOT_FROM_INVALID	3
-#define CST4322_ILP_DIV_EN		0x00000800
-#define CST4322_FLASH_TYPE_MASK		0x00001000
-#define CST4322_FLASH_TYPE_SHIFT	12
-#define CST4322_FLASH_TYPE_SHIFT_ST	0	/* ST serial FLASH */
-#define CST4322_FLASH_TYPE_SHIFT_ATMEL	1	/* ATMEL flash */
-#define CST4322_ARM_TAP_SEL		0x00002000
-#define CST4322_RES_INIT_MODE_MASK	0x0000c000
-#define CST4322_RES_INIT_MODE_SHIFT	14
-#define CST4322_RES_INIT_MODE_ILPAVAIL	0	/* resinitmode: ILP available */
-#define CST4322_RES_INIT_MODE_ILPREQ	1	/* resinitmode: ILP request */
-#define CST4322_RES_INIT_MODE_ALPAVAIL	2	/* resinitmode: ALP available */
-#define CST4322_RES_INIT_MODE_HTAVAIL	3	/* resinitmode: HT available */
-#define CST4322_PCIPLLCLK_GATING	0x00010000
-#define CST4322_CLK_SWITCH_PCI_TO_ALP	0x00020000
-#define CST4322_PCI_CARDBUS_MODE	0x00040000
-
-/* 43224 chip-specific ChipControl register bits */
-#define CCTRL43224_GPIO_TOGGLE          0x8000
-#define CCTRL_43224A0_12MA_LED_DRIVE    0x00F000F0	/* 12 mA drive strength */
-#define CCTRL_43224B0_12MA_LED_DRIVE    0xF0	/* 12 mA drive strength for later 43224s */
-
-/* 43236 resources */
-#define RES43236_REGULATOR		0
-#define RES43236_ILP_REQUEST		1
-#define RES43236_XTAL_PU		2
-#define RES43236_ALP_AVAIL		3
-#define RES43236_SI_PLL_ON		4
-#define RES43236_HT_SI_AVAIL		5
-
-/* 43236 chip-specific ChipControl register bits */
-#define CCTRL43236_BT_COEXIST		(1<<0)	/* 0 disable */
-#define CCTRL43236_SECI			(1<<1)	/* 0 SECI is disabled (JATG functional) */
-#define CCTRL43236_EXT_LNA		(1<<2)	/* 0 disable */
-#define CCTRL43236_ANT_MUX_2o3          (1<<3)	/* 2o3 mux, chipcontrol bit 3 */
-#define CCTRL43236_GSIO			(1<<4)	/* 0 disable */
-
-/* 43236 Chip specific ChipStatus register bits */
-#define CST43236_SFLASH_MASK		0x00000040
-#define CST43236_OTP_MASK		0x00000080
-#define CST43236_HSIC_MASK		0x00000100	/* USB/HSIC */
-#define CST43236_BP_CLK			0x00000200	/* 120/96Mbps */
-#define CST43236_BOOT_MASK		0x00001800
-#define CST43236_BOOT_SHIFT		11
-#define CST43236_BOOT_FROM_SRAM		0	/* boot from SRAM, ARM in reset */
-#define CST43236_BOOT_FROM_ROM		1	/* boot from ROM */
-#define CST43236_BOOT_FROM_FLASH	2	/* boot from FLASH */
-#define CST43236_BOOT_FROM_INVALID	3
-
-/* 4331 resources */
-#define RES4331_REGULATOR		0
-#define RES4331_ILP_REQUEST		1
-#define RES4331_XTAL_PU			2
-#define RES4331_ALP_AVAIL		3
-#define RES4331_SI_PLL_ON		4
-#define RES4331_HT_SI_AVAIL		5
-
-/* 4331 chip-specific ChipControl register bits */
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
-
-/* 4331 Chip specific ChipStatus register bits */
-#define	CST4331_XTAL_FREQ		0x00000001	/* crystal frequency 20/40Mhz */
-#define	CST4331_SPROM_PRESENT		0x00000002
-#define	CST4331_OTP_PRESENT		0x00000004
-#define	CST4331_LDO_RF			0x00000008
-#define	CST4331_LDO_PAR			0x00000010
-
-/* 4315 resources */
-#define RES4315_CBUCK_LPOM		1	/* 0x00000002 */
-#define RES4315_CBUCK_BURST		2	/* 0x00000004 */
-#define RES4315_CBUCK_PWM		3	/* 0x00000008 */
-#define RES4315_CLDO_PU			4	/* 0x00000010 */
-#define RES4315_PALDO_PU		5	/* 0x00000020 */
-#define RES4315_ILP_REQUEST		6	/* 0x00000040 */
-#define RES4315_LNLDO1_PU		9	/* 0x00000200 */
-#define RES4315_OTP_PU			10	/* 0x00000400 */
-#define RES4315_LNLDO2_PU		12	/* 0x00001000 */
-#define RES4315_XTAL_PU			13	/* 0x00002000 */
-#define RES4315_ALP_AVAIL		14	/* 0x00004000 */
-#define RES4315_RX_PWRSW_PU		15	/* 0x00008000 */
-#define RES4315_TX_PWRSW_PU		16	/* 0x00010000 */
-#define RES4315_RFPLL_PWRSW_PU		17	/* 0x00020000 */
-#define RES4315_LOGEN_PWRSW_PU		18	/* 0x00040000 */
-#define RES4315_AFE_PWRSW_PU		19	/* 0x00080000 */
-#define RES4315_BBPLL_PWRSW_PU		20	/* 0x00100000 */
-#define RES4315_HT_AVAIL		21	/* 0x00200000 */
-
-/* 4315 chip-specific ChipStatus register bits */
-#define CST4315_SPROM_OTP_SEL_MASK	0x00000003	/* gpio [7:6], SDIO CIS selection */
-#define CST4315_DEFCIS_SEL		0x00000000	/* use default CIS, OTP is powered up */
-#define CST4315_SPROM_SEL		0x00000001	/* use SPROM, OTP is powered up */
-#define CST4315_OTP_SEL			0x00000002	/* use OTP, OTP is powered up */
-#define CST4315_OTP_PWRDN		0x00000003	/* use SPROM, OTP is powered down */
-#define CST4315_SDIO_MODE		0x00000004	/* gpio [8], sdio/usb mode */
-#define CST4315_RCAL_VALID		0x00000008
-#define CST4315_RCAL_VALUE_MASK		0x000001f0
-#define CST4315_RCAL_VALUE_SHIFT	4
-#define CST4315_PALDO_EXTPNP		0x00000200	/* PALDO is configured with external PNP */
-#define CST4315_CBUCK_MODE_MASK		0x00000c00
-#define CST4315_CBUCK_MODE_BURST	0x00000400
-#define CST4315_CBUCK_MODE_LPBURST	0x00000c00
-
-/* 4319 resources */
-#define RES4319_CBUCK_LPOM		1	/* 0x00000002 */
-#define RES4319_CBUCK_BURST		2	/* 0x00000004 */
-#define RES4319_CBUCK_PWM		3	/* 0x00000008 */
-#define RES4319_CLDO_PU			4	/* 0x00000010 */
-#define RES4319_PALDO_PU		5	/* 0x00000020 */
-#define RES4319_ILP_REQUEST		6	/* 0x00000040 */
-#define RES4319_LNLDO1_PU		9	/* 0x00000200 */
-#define RES4319_OTP_PU			10	/* 0x00000400 */
-#define RES4319_LNLDO2_PU		12	/* 0x00001000 */
-#define RES4319_XTAL_PU			13	/* 0x00002000 */
-#define RES4319_ALP_AVAIL		14	/* 0x00004000 */
-#define RES4319_RX_PWRSW_PU		15	/* 0x00008000 */
-#define RES4319_TX_PWRSW_PU		16	/* 0x00010000 */
-#define RES4319_RFPLL_PWRSW_PU		17	/* 0x00020000 */
-#define RES4319_LOGEN_PWRSW_PU		18	/* 0x00040000 */
-#define RES4319_AFE_PWRSW_PU		19	/* 0x00080000 */
-#define RES4319_BBPLL_PWRSW_PU		20	/* 0x00100000 */
-#define RES4319_HT_AVAIL		21	/* 0x00200000 */
-
-/* 4319 chip-specific ChipStatus register bits */
-#define	CST4319_SPI_CPULESSUSB		0x00000001
-#define	CST4319_SPI_CLK_POL		0x00000002
-#define	CST4319_SPI_CLK_PH		0x00000008
-#define	CST4319_SPROM_OTP_SEL_MASK	0x000000c0	/* gpio [7:6], SDIO CIS selection */
-#define	CST4319_SPROM_OTP_SEL_SHIFT	6
-#define	CST4319_DEFCIS_SEL		0x00000000	/* use default CIS, OTP is powered up */
-#define	CST4319_SPROM_SEL		0x00000040	/* use SPROM, OTP is powered up */
-#define	CST4319_OTP_SEL			0x00000080	/* use OTP, OTP is powered up */
-#define	CST4319_OTP_PWRDN		0x000000c0	/* use SPROM, OTP is powered down */
-#define	CST4319_SDIO_USB_MODE		0x00000100	/* gpio [8], sdio/usb mode */
-#define	CST4319_REMAP_SEL_MASK		0x00000600
-#define	CST4319_ILPDIV_EN		0x00000800
-#define	CST4319_XTAL_PD_POL		0x00001000
-#define	CST4319_LPO_SEL			0x00002000
-#define	CST4319_RES_INIT_MODE		0x0000c000
-#define	CST4319_PALDO_EXTPNP		0x00010000	/* PALDO is configured with external PNP */
-#define	CST4319_CBUCK_MODE_MASK		0x00060000
-#define CST4319_CBUCK_MODE_BURST	0x00020000
-#define CST4319_CBUCK_MODE_LPBURST	0x00060000
-#define	CST4319_RCAL_VALID		0x01000000
-#define	CST4319_RCAL_VALUE_MASK		0x3e000000
-#define	CST4319_RCAL_VALUE_SHIFT	25
-
-#define PMU1_PLL0_CHIPCTL0		0
-#define PMU1_PLL0_CHIPCTL1		1
-#define PMU1_PLL0_CHIPCTL2		2
-#define CCTL_4319USB_XTAL_SEL_MASK	0x00180000
-#define CCTL_4319USB_XTAL_SEL_SHIFT	19
-#define CCTL_4319USB_48MHZ_PLL_SEL	1
-#define CCTL_4319USB_24MHZ_PLL_SEL	2
-
-/* PMU resources for 4336 */
-#define	RES4336_CBUCK_LPOM		0
-#define	RES4336_CBUCK_BURST		1
-#define	RES4336_CBUCK_LP_PWM		2
-#define	RES4336_CBUCK_PWM		3
-#define	RES4336_CLDO_PU			4
-#define	RES4336_DIS_INT_RESET_PD	5
-#define	RES4336_ILP_REQUEST		6
-#define	RES4336_LNLDO_PU		7
-#define	RES4336_LDO3P3_PU		8
-#define	RES4336_OTP_PU			9
-#define	RES4336_XTAL_PU			10
-#define	RES4336_ALP_AVAIL		11
-#define	RES4336_RADIO_PU		12
-#define	RES4336_BG_PU			13
-#define	RES4336_VREG1p4_PU_PU		14
-#define	RES4336_AFE_PWRSW_PU		15
-#define	RES4336_RX_PWRSW_PU		16
-#define	RES4336_TX_PWRSW_PU		17
-#define	RES4336_BB_PWRSW_PU		18
-#define	RES4336_SYNTH_PWRSW_PU		19
-#define	RES4336_MISC_PWRSW_PU		20
-#define	RES4336_LOGEN_PWRSW_PU		21
-#define	RES4336_BBPLL_PWRSW_PU		22
-#define	RES4336_MACPHY_CLKAVAIL		23
-#define	RES4336_HT_AVAIL		24
-#define	RES4336_RSVD			25
-
-/* 4336 chip-specific ChipStatus register bits */
-#define	CST4336_SPI_MODE_MASK		0x00000001
-#define	CST4336_SPROM_PRESENT		0x00000002
-#define	CST4336_OTP_PRESENT		0x00000004
-#define	CST4336_ARMREMAP_0		0x00000008
-#define	CST4336_ILPDIV_EN_MASK		0x00000010
-#define	CST4336_ILPDIV_EN_SHIFT		4
-#define	CST4336_XTAL_PD_POL_MASK	0x00000020
-#define	CST4336_XTAL_PD_POL_SHIFT	5
-#define	CST4336_LPO_SEL_MASK		0x00000040
-#define	CST4336_LPO_SEL_SHIFT		6
-#define	CST4336_RES_INIT_MODE_MASK	0x00000180
-#define	CST4336_RES_INIT_MODE_SHIFT	7
-#define	CST4336_CBUCK_MODE_MASK		0x00000600
-#define	CST4336_CBUCK_MODE_SHIFT	9
-
-/* 4330 resources */
-#define	RES4330_CBUCK_LPOM		0
-#define	RES4330_CBUCK_BURST		1
-#define	RES4330_CBUCK_LP_PWM		2
-#define	RES4330_CBUCK_PWM		3
-#define	RES4330_CLDO_PU			4
-#define	RES4330_DIS_INT_RESET_PD	5
-#define	RES4330_ILP_REQUEST		6
-#define	RES4330_LNLDO_PU		7
-#define	RES4330_LDO3P3_PU		8
-#define	RES4330_OTP_PU			9
-#define	RES4330_XTAL_PU			10
-#define	RES4330_ALP_AVAIL		11
-#define	RES4330_RADIO_PU		12
-#define	RES4330_BG_PU			13
-#define	RES4330_VREG1p4_PU_PU		14
-#define	RES4330_AFE_PWRSW_PU		15
-#define	RES4330_RX_PWRSW_PU		16
-#define	RES4330_TX_PWRSW_PU		17
-#define	RES4330_BB_PWRSW_PU		18
-#define	RES4330_SYNTH_PWRSW_PU		19
-#define	RES4330_MISC_PWRSW_PU		20
-#define	RES4330_LOGEN_PWRSW_PU		21
-#define	RES4330_BBPLL_PWRSW_PU		22
-#define	RES4330_MACPHY_CLKAVAIL		23
-#define	RES4330_HT_AVAIL		24
-#define	RES4330_5gRX_PWRSW_PU		25
-#define	RES4330_5gTX_PWRSW_PU		26
-#define	RES4330_5g_LOGEN_PWRSW_PU	27
-
-/* 4330 chip-specific ChipStatus register bits */
-#define CST4330_CHIPMODE_SDIOD(cs)	(((cs) & 0x7) < 6)	/* SDIO || gSPI */
-#define CST4330_CHIPMODE_USB20D(cs)	(((cs) & 0x7) >= 6)	/* USB || USBDA */
-#define CST4330_CHIPMODE_SDIO(cs)	(((cs) & 0x4) == 0)	/* SDIO */
-#define CST4330_CHIPMODE_GSPI(cs)	(((cs) & 0x6) == 4)	/* gSPI */
-#define CST4330_CHIPMODE_USB(cs)	(((cs) & 0x7) == 6)	/* USB packet-oriented */
-#define CST4330_CHIPMODE_USBDA(cs)	(((cs) & 0x7) == 7)	/* USB Direct Access */
-#define	CST4330_OTP_PRESENT		0x00000010
-#define	CST4330_LPO_AUTODET_EN		0x00000020
-#define	CST4330_ARMREMAP_0		0x00000040
-#define	CST4330_SPROM_PRESENT		0x00000080	/* takes priority over OTP if both set */
-#define	CST4330_ILPDIV_EN		0x00000100
-#define	CST4330_LPO_SEL			0x00000200
-#define	CST4330_RES_INIT_MODE_SHIFT	10
-#define	CST4330_RES_INIT_MODE_MASK	0x00000c00
-#define CST4330_CBUCK_MODE_SHIFT	12
-#define CST4330_CBUCK_MODE_MASK		0x00003000
-#define	CST4330_CBUCK_POWER_OK		0x00004000
-#define	CST4330_BB_PLL_LOCKED		0x00008000
-#define SOCDEVRAM_4330_BP_ADDR		0x1E000000
-#define SOCDEVRAM_4330_ARM_ADDR		0x00800000
-
-/* 4313 resources */
-#define	RES4313_BB_PU_RSRC		0
-#define	RES4313_ILP_REQ_RSRC		1
-#define	RES4313_XTAL_PU_RSRC		2
-#define	RES4313_ALP_AVAIL_RSRC		3
-#define	RES4313_RADIO_PU_RSRC		4
-#define	RES4313_BG_PU_RSRC		5
-#define	RES4313_VREG1P4_PU_RSRC		6
-#define	RES4313_AFE_PWRSW_RSRC		7
-#define	RES4313_RX_PWRSW_RSRC		8
-#define	RES4313_TX_PWRSW_RSRC		9
-#define	RES4313_BB_PWRSW_RSRC		10
-#define	RES4313_SYNTH_PWRSW_RSRC	11
-#define	RES4313_MISC_PWRSW_RSRC		12
-#define	RES4313_BB_PLL_PWRSW_RSRC	13
-#define	RES4313_HT_AVAIL_RSRC		14
-#define	RES4313_MACPHY_CLK_AVAIL_RSRC	15
-
-/* 4313 chip-specific ChipStatus register bits */
-#define	CST4313_SPROM_PRESENT			1
-#define	CST4313_OTP_PRESENT			2
-#define	CST4313_SPROM_OTP_SEL_MASK		0x00000002
-#define	CST4313_SPROM_OTP_SEL_SHIFT		0
-
-/* 4313 Chip specific ChipControl register bits */
-#define CCTRL_4313_12MA_LED_DRIVE    0x00000007	/* 12 mA drive strengh for later 4313 */
-
-/* 43228 resources */
-#define RES43228_NOT_USED		0
-#define RES43228_ILP_REQUEST		1
-#define RES43228_XTAL_PU		2
-#define RES43228_ALP_AVAIL		3
-#define RES43228_PLL_EN			4
-#define RES43228_HT_PHY_AVAIL		5
-
-/* 43228 chipstatus  reg bits */
-#define CST43228_ILP_DIV_EN		0x1
-#define	CST43228_OTP_PRESENT		0x2
-#define	CST43228_SERDES_REFCLK_PADSEL	0x4
-#define	CST43228_SDIO_MODE		0x8
-
-#define	CST43228_SDIO_OTP_PRESENT	0x10
-#define	CST43228_SDIO_RESET		0x20
-
 /*
 * Maximum delay for the PMU state transition in us.
 * This is an upper bound intended for spinwaits etc.
 */
 #define PMU_MAX_TRANSITION_DLY	15000
 
-/* PMU resource up transition time in ILP cycles */
-#define PMURES_UP_TRANSITION	2
-
-/*
-* Register eci_inputlo bitfield values.
-* - BT packet type information bits [7:0]
-*/
-/*  [3:0] - Task (link) type */
-#define BT_ACL				0x00
-#define BT_SCO				0x01
-#define BT_eSCO				0x02
-#define BT_A2DP				0x03
-#define BT_SNIFF			0x04
-#define BT_PAGE_SCAN			0x05
-#define BT_INQUIRY_SCAN			0x06
-#define BT_PAGE				0x07
-#define BT_INQUIRY			0x08
-#define BT_MSS				0x09
-#define BT_PARK				0x0a
-#define BT_RSSISCAN			0x0b
-#define BT_MD_ACL			0x0c
-#define BT_MD_eSCO			0x0d
-#define BT_SCAN_WITH_SCO_LINK		0x0e
-#define BT_SCAN_WITHOUT_SCO_LINK	0x0f
-/* [7:4] = packet duration code */
-/* [8] - Master / Slave */
-#define BT_MASTER			0
-#define BT_SLAVE			1
-/* [11:9] - multi-level priority */
-#define BT_LOWEST_PRIO			0x0
-#define BT_HIGHEST_PRIO			0x3
-
-/* WLAN - number of antenna */
-#define WLAN_NUM_ANT1 TXANT_0
-#define WLAN_NUM_ANT2 TXANT_1
-
 #endif				/* _SBCHIPC_H */
diff --git a/drivers/staging/brcm80211/include/sbconfig.h b/drivers/staging/brcm80211/include/sbconfig.h
index 5247f01..68e4b54 100644
--- a/drivers/staging/brcm80211/include/sbconfig.h
+++ b/drivers/staging/brcm80211/include/sbconfig.h
@@ -24,249 +24,9 @@
 #define	PAD		_XSTR(__LINE__)
 #endif
 
-/* enumeration in SB is based on the premise that cores are contiguos in the
- * enumeration space.
- */
-#define SB_BUS_SIZE		0x10000	/* Each bus gets 64Kbytes for cores */
-#define SB_BUS_BASE(b)		(SI_ENUM_BASE + (b) * SB_BUS_SIZE)
-#define	SB_BUS_MAXCORES		(SB_BUS_SIZE / SI_CORE_SIZE)	/* Max cores per bus */
-
 /*
  * Sonics Configuration Space Registers.
  */
 #define	SBCONFIGOFF		0xf00	/* core sbconfig regs are top 256bytes of regs */
-#define	SBCONFIGSIZE		256	/* sizeof (sbconfig_t) */
-
-#define SBIPSFLAG		0x08
-#define SBTPSFLAG		0x18
-#define	SBTMERRLOGA		0x48	/* sonics >= 2.3 */
-#define	SBTMERRLOG		0x50	/* sonics >= 2.3 */
-#define SBADMATCH3		0x60
-#define SBADMATCH2		0x68
-#define SBADMATCH1		0x70
-#define SBIMSTATE		0x90
-#define SBINTVEC		0x94
-#define SBTMSTATELOW		0x98
-#define SBTMSTATEHIGH		0x9c
-#define SBBWA0			0xa0
-#define SBIMCONFIGLOW		0xa8
-#define SBIMCONFIGHIGH		0xac
-#define SBADMATCH0		0xb0
-#define SBTMCONFIGLOW		0xb8
-#define SBTMCONFIGHIGH		0xbc
-#define SBBCONFIG		0xc0
-#define SBBSTATE		0xc8
-#define SBACTCNFG		0xd8
-#define	SBFLAGST		0xe8
-#define SBIDLOW			0xf8
-#define SBIDHIGH		0xfc
-
-/* All the previous registers are above SBCONFIGOFF, but with Sonics 2.3, we have
- * a few registers *below* that line. I think it would be very confusing to try
- * and change the value of SBCONFIGOFF, so I'm definig them as absolute offsets here,
- */
-
-#define SBIMERRLOGA		0xea8
-#define SBIMERRLOG		0xeb0
-#define SBTMPORTCONNID0		0xed8
-#define SBTMPORTLOCK0		0xef8
-
-#ifndef _LANGUAGE_ASSEMBLY
-
-typedef volatile struct _sbconfig {
-	u32 PAD[2];
-	u32 sbipsflag;	/* initiator port ocp slave flag */
-	u32 PAD[3];
-	u32 sbtpsflag;	/* target port ocp slave flag */
-	u32 PAD[11];
-	u32 sbtmerrloga;	/* (sonics >= 2.3) */
-	u32 PAD;
-	u32 sbtmerrlog;	/* (sonics >= 2.3) */
-	u32 PAD[3];
-	u32 sbadmatch3;	/* address match3 */
-	u32 PAD;
-	u32 sbadmatch2;	/* address match2 */
-	u32 PAD;
-	u32 sbadmatch1;	/* address match1 */
-	u32 PAD[7];
-	u32 sbimstate;	/* initiator agent state */
-	u32 sbintvec;	/* interrupt mask */
-	u32 sbtmstatelow;	/* target state */
-	u32 sbtmstatehigh;	/* target state */
-	u32 sbbwa0;		/* bandwidth allocation table0 */
-	u32 PAD;
-	u32 sbimconfiglow;	/* initiator configuration */
-	u32 sbimconfighigh;	/* initiator configuration */
-	u32 sbadmatch0;	/* address match0 */
-	u32 PAD;
-	u32 sbtmconfiglow;	/* target configuration */
-	u32 sbtmconfighigh;	/* target configuration */
-	u32 sbbconfig;	/* broadcast configuration */
-	u32 PAD;
-	u32 sbbstate;	/* broadcast state */
-	u32 PAD[3];
-	u32 sbactcnfg;	/* activate configuration */
-	u32 PAD[3];
-	u32 sbflagst;	/* current sbflags */
-	u32 PAD[3];
-	u32 sbidlow;		/* identification */
-	u32 sbidhigh;	/* identification */
-} sbconfig_t;
-
-#endif				/* _LANGUAGE_ASSEMBLY */
-
-/* sbipsflag */
-#define	SBIPS_INT1_MASK		0x3f	/* which sbflags get routed to mips interrupt 1 */
-#define	SBIPS_INT1_SHIFT	0
-#define	SBIPS_INT2_MASK		0x3f00	/* which sbflags get routed to mips interrupt 2 */
-#define	SBIPS_INT2_SHIFT	8
-#define	SBIPS_INT3_MASK		0x3f0000	/* which sbflags get routed to mips interrupt 3 */
-#define	SBIPS_INT3_SHIFT	16
-#define	SBIPS_INT4_MASK		0x3f000000	/* which sbflags get routed to mips interrupt 4 */
-#define	SBIPS_INT4_SHIFT	24
-
-/* sbtpsflag */
-#define	SBTPS_NUM0_MASK		0x3f	/* interrupt sbFlag # generated by this core */
-#define	SBTPS_F0EN0		0x40	/* interrupt is always sent on the backplane */
-
-/* sbtmerrlog */
-#define	SBTMEL_CM		0x00000007	/* command */
-#define	SBTMEL_CI		0x0000ff00	/* connection id */
-#define	SBTMEL_EC		0x0f000000	/* error code */
-#define	SBTMEL_ME		0x80000000	/* multiple error */
-
-/* sbimstate */
-#define	SBIM_PC			0xf	/* pipecount */
-#define	SBIM_AP_MASK		0x30	/* arbitration policy */
-#define	SBIM_AP_BOTH		0x00	/* use both timeslaces and token */
-#define	SBIM_AP_TS		0x10	/* use timesliaces only */
-#define	SBIM_AP_TK		0x20	/* use token only */
-#define	SBIM_AP_RSV		0x30	/* reserved */
-#define	SBIM_IBE		0x20000	/* inbanderror */
-#define	SBIM_TO			0x40000	/* timeout */
-#define	SBIM_BY			0x01800000	/* busy (sonics >= 2.3) */
-#define	SBIM_RJ			0x02000000	/* reject (sonics >= 2.3) */
-
-/* sbtmstatelow */
-#define	SBTML_RESET		0x0001	/* reset */
-#define	SBTML_REJ_MASK		0x0006	/* reject field */
-#define	SBTML_REJ		0x0002	/* reject */
-#define	SBTML_TMPREJ		0x0004	/* temporary reject, for error recovery */
-
-#define	SBTML_SICF_SHIFT	16	/* Shift to locate the SI control flags in sbtml */
-
-/* sbtmstatehigh */
-#define	SBTMH_SERR		0x0001	/* serror */
-#define	SBTMH_INT		0x0002	/* interrupt */
-#define	SBTMH_BUSY		0x0004	/* busy */
-#define	SBTMH_TO		0x0020	/* timeout (sonics >= 2.3) */
-
-#define	SBTMH_SISF_SHIFT	16	/* Shift to locate the SI status flags in sbtmh */
-
-/* sbbwa0 */
-#define	SBBWA_TAB0_MASK		0xffff	/* lookup table 0 */
-#define	SBBWA_TAB1_MASK		0xffff	/* lookup table 1 */
-#define	SBBWA_TAB1_SHIFT	16
-
-/* sbimconfiglow */
-#define	SBIMCL_STO_MASK		0x7	/* service timeout */
-#define	SBIMCL_RTO_MASK		0x70	/* request timeout */
-#define	SBIMCL_RTO_SHIFT	4
-#define	SBIMCL_CID_MASK		0xff0000	/* connection id */
-#define	SBIMCL_CID_SHIFT	16
-
-/* sbimconfighigh */
-#define	SBIMCH_IEM_MASK		0xc	/* inband error mode */
-#define	SBIMCH_TEM_MASK		0x30	/* timeout error mode */
-#define	SBIMCH_TEM_SHIFT	4
-#define	SBIMCH_BEM_MASK		0xc0	/* bus error mode */
-#define	SBIMCH_BEM_SHIFT	6
-
-/* sbadmatch0 */
-#define	SBAM_TYPE_MASK		0x3	/* address type */
-#define	SBAM_AD64		0x4	/* reserved */
-#define	SBAM_ADINT0_MASK	0xf8	/* type0 size */
-#define	SBAM_ADINT0_SHIFT	3
-#define	SBAM_ADINT1_MASK	0x1f8	/* type1 size */
-#define	SBAM_ADINT1_SHIFT	3
-#define	SBAM_ADINT2_MASK	0x1f8	/* type2 size */
-#define	SBAM_ADINT2_SHIFT	3
-#define	SBAM_ADEN		0x400	/* enable */
-#define	SBAM_ADNEG		0x800	/* negative decode */
-#define	SBAM_BASE0_MASK		0xffffff00	/* type0 base address */
-#define	SBAM_BASE0_SHIFT	8
-#define	SBAM_BASE1_MASK		0xfffff000	/* type1 base address for the core */
-#define	SBAM_BASE1_SHIFT	12
-#define	SBAM_BASE2_MASK		0xffff0000	/* type2 base address for the core */
-#define	SBAM_BASE2_SHIFT	16
-
-/* sbtmconfiglow */
-#define	SBTMCL_CD_MASK		0xff	/* clock divide */
-#define	SBTMCL_CO_MASK		0xf800	/* clock offset */
-#define	SBTMCL_CO_SHIFT		11
-#define	SBTMCL_IF_MASK		0xfc0000	/* interrupt flags */
-#define	SBTMCL_IF_SHIFT		18
-#define	SBTMCL_IM_MASK		0x3000000	/* interrupt mode */
-#define	SBTMCL_IM_SHIFT		24
-
-/* sbtmconfighigh */
-#define	SBTMCH_BM_MASK		0x3	/* busy mode */
-#define	SBTMCH_RM_MASK		0x3	/* retry mode */
-#define	SBTMCH_RM_SHIFT		2
-#define	SBTMCH_SM_MASK		0x30	/* stop mode */
-#define	SBTMCH_SM_SHIFT		4
-#define	SBTMCH_EM_MASK		0x300	/* sb error mode */
-#define	SBTMCH_EM_SHIFT		8
-#define	SBTMCH_IM_MASK		0xc00	/* int mode */
-#define	SBTMCH_IM_SHIFT		10
-
-/* sbbconfig */
-#define	SBBC_LAT_MASK		0x3	/* sb latency */
-#define	SBBC_MAX0_MASK		0xf0000	/* maxccntr0 */
-#define	SBBC_MAX0_SHIFT		16
-#define	SBBC_MAX1_MASK		0xf00000	/* maxccntr1 */
-#define	SBBC_MAX1_SHIFT		20
-
-/* sbbstate */
-#define	SBBS_SRD		0x1	/* st reg disable */
-#define	SBBS_HRD		0x2	/* hold reg disable */
-
-/* sbidlow */
-#define	SBIDL_CS_MASK		0x3	/* config space */
-#define	SBIDL_AR_MASK		0x38	/* # address ranges supported */
-#define	SBIDL_AR_SHIFT		3
-#define	SBIDL_SYNCH		0x40	/* sync */
-#define	SBIDL_INIT		0x80	/* initiator */
-#define	SBIDL_MINLAT_MASK	0xf00	/* minimum backplane latency */
-#define	SBIDL_MINLAT_SHIFT	8
-#define	SBIDL_MAXLAT		0xf000	/* maximum backplane latency */
-#define	SBIDL_MAXLAT_SHIFT	12
-#define	SBIDL_FIRST		0x10000	/* this initiator is first */
-#define	SBIDL_CW_MASK		0xc0000	/* cycle counter width */
-#define	SBIDL_CW_SHIFT		18
-#define	SBIDL_TP_MASK		0xf00000	/* target ports */
-#define	SBIDL_TP_SHIFT		20
-#define	SBIDL_IP_MASK		0xf000000	/* initiator ports */
-#define	SBIDL_IP_SHIFT		24
-#define	SBIDL_RV_MASK		0xf0000000	/* sonics backplane revision code */
-#define	SBIDL_RV_SHIFT		28
-#define	SBIDL_RV_2_2		0x00000000	/* version 2.2 or earlier */
-#define	SBIDL_RV_2_3		0x10000000	/* version 2.3 */
-
-/* sbidhigh */
-#define	SBIDH_RC_MASK		0x000f	/* revision code */
-#define	SBIDH_RCE_MASK		0x7000	/* revision code extension field */
-#define	SBIDH_RCE_SHIFT		8
-#define	SBCOREREV(sbidh) \
-	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | ((sbidh) & SBIDH_RC_MASK))
-#define	SBIDH_CC_MASK		0x8ff0	/* core code */
-#define	SBIDH_CC_SHIFT		4
-#define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
-#define	SBIDH_VC_SHIFT		16
-
-#define	SB_COMMIT		0xfd8	/* update buffered registers value */
-
-/* vendor codes */
-#define	SB_VEND_BCM		0x4243	/* Broadcom's SB vendor code */
 
 #endif				/* _SBCONFIG_H */
diff --git a/drivers/staging/brcm80211/include/sbdma.h b/drivers/staging/brcm80211/include/sbdma.h
index 1da979a..9814a0c 100644
--- a/drivers/staging/brcm80211/include/sbdma.h
+++ b/drivers/staging/brcm80211/include/sbdma.h
@@ -25,19 +25,6 @@
 
 /* 32 bits addressing */
 
-/* dma registers per channel(xmt or rcv) */
-typedef volatile struct {
-	u32 control;		/* enable, et al */
-	u32 addr;		/* descriptor ring base address (4K aligned) */
-	u32 ptr;		/* last descriptor posted to chip */
-	u32 status;		/* current active descriptor, et al */
-} dma32regs_t;
-
-typedef volatile struct {
-	dma32regs_t xmt;	/* dma tx channel */
-	dma32regs_t rcv;	/* dma rx channel */
-} dma32regp_t;
-
 typedef volatile struct {	/* diag access */
 	u32 fifoaddr;	/* diag address */
 	u32 fifodatalow;	/* low 32bits of data */
@@ -45,115 +32,6 @@ typedef volatile struct {	/* diag access */
 	u32 pad;		/* reserved */
 } dma32diag_t;
 
-/*
- * DMA Descriptor
- * Descriptors are only read by the hardware, never written back.
- */
-typedef volatile struct {
-	u32 ctrl;		/* misc control bits & bufcount */
-	u32 addr;		/* data buffer address */
-} dma32dd_t;
-
-/*
- * Each descriptor ring must be 4096byte aligned, and fit within a single 4096byte page.
- */
-#define	D32RINGALIGN_BITS	12
-#define	D32MAXRINGSZ		(1 << D32RINGALIGN_BITS)
-#define	D32RINGALIGN		(1 << D32RINGALIGN_BITS)
-
-#define	D32MAXDD	(D32MAXRINGSZ / sizeof (dma32dd_t))
-
-/* transmit channel control */
-#define	XC_XE		((u32)1 << 0)	/* transmit enable */
-#define	XC_SE		((u32)1 << 1)	/* transmit suspend request */
-#define	XC_LE		((u32)1 << 2)	/* loopback enable */
-#define	XC_FL		((u32)1 << 4)	/* flush request */
-#define	XC_PD		((u32)1 << 11)	/* parity check disable */
-#define	XC_AE		((u32)3 << 16)	/* address extension bits */
-#define	XC_AE_SHIFT	16
-
-/* transmit descriptor table pointer */
-#define	XP_LD_MASK	0xfff	/* last valid descriptor */
-
-/* transmit channel status */
-#define	XS_CD_MASK	0x0fff	/* current descriptor pointer */
-#define	XS_XS_MASK	0xf000	/* transmit state */
-#define	XS_XS_SHIFT	12
-#define	XS_XS_DISABLED	0x0000	/* disabled */
-#define	XS_XS_ACTIVE	0x1000	/* active */
-#define	XS_XS_IDLE	0x2000	/* idle wait */
-#define	XS_XS_STOPPED	0x3000	/* stopped */
-#define	XS_XS_SUSP	0x4000	/* suspend pending */
-#define	XS_XE_MASK	0xf0000	/* transmit errors */
-#define	XS_XE_SHIFT	16
-#define	XS_XE_NOERR	0x00000	/* no error */
-#define	XS_XE_DPE	0x10000	/* descriptor protocol error */
-#define	XS_XE_DFU	0x20000	/* data fifo underrun */
-#define	XS_XE_BEBR	0x30000	/* bus error on buffer read */
-#define	XS_XE_BEDA	0x40000	/* bus error on descriptor access */
-#define	XS_AD_MASK	0xfff00000	/* active descriptor */
-#define	XS_AD_SHIFT	20
-
-/* receive channel control */
-#define	RC_RE		((u32)1 << 0)	/* receive enable */
-#define	RC_RO_MASK	0xfe	/* receive frame offset */
-#define	RC_RO_SHIFT	1
-#define	RC_FM		((u32)1 << 8)	/* direct fifo receive (pio) mode */
-#define	RC_SH		((u32)1 << 9)	/* separate rx header descriptor enable */
-#define	RC_OC		((u32)1 << 10)	/* overflow continue */
-#define	RC_PD		((u32)1 << 11)	/* parity check disable */
-#define	RC_AE		((u32)3 << 16)	/* address extension bits */
-#define	RC_AE_SHIFT	16
-
-/* receive descriptor table pointer */
-#define	RP_LD_MASK	0xfff	/* last valid descriptor */
-
-/* receive channel status */
-#define	RS_CD_MASK	0x0fff	/* current descriptor pointer */
-#define	RS_RS_MASK	0xf000	/* receive state */
-#define	RS_RS_SHIFT	12
-#define	RS_RS_DISABLED	0x0000	/* disabled */
-#define	RS_RS_ACTIVE	0x1000	/* active */
-#define	RS_RS_IDLE	0x2000	/* idle wait */
-#define	RS_RS_STOPPED	0x3000	/* reserved */
-#define	RS_RE_MASK	0xf0000	/* receive errors */
-#define	RS_RE_SHIFT	16
-#define	RS_RE_NOERR	0x00000	/* no error */
-#define	RS_RE_DPE	0x10000	/* descriptor protocol error */
-#define	RS_RE_DFO	0x20000	/* data fifo overflow */
-#define	RS_RE_BEBW	0x30000	/* bus error on buffer write */
-#define	RS_RE_BEDA	0x40000	/* bus error on descriptor access */
-#define	RS_AD_MASK	0xfff00000	/* active descriptor */
-#define	RS_AD_SHIFT	20
-
-/* fifoaddr */
-#define	FA_OFF_MASK	0xffff	/* offset */
-#define	FA_SEL_MASK	0xf0000	/* select */
-#define	FA_SEL_SHIFT	16
-#define	FA_SEL_XDD	0x00000	/* transmit dma data */
-#define	FA_SEL_XDP	0x10000	/* transmit dma pointers */
-#define	FA_SEL_RDD	0x40000	/* receive dma data */
-#define	FA_SEL_RDP	0x50000	/* receive dma pointers */
-#define	FA_SEL_XFD	0x80000	/* transmit fifo data */
-#define	FA_SEL_XFP	0x90000	/* transmit fifo pointers */
-#define	FA_SEL_RFD	0xc0000	/* receive fifo data */
-#define	FA_SEL_RFP	0xd0000	/* receive fifo pointers */
-#define	FA_SEL_RSD	0xe0000	/* receive frame status data */
-#define	FA_SEL_RSP	0xf0000	/* receive frame status pointers */
-
-/* descriptor control flags */
-#define	CTRL_BC_MASK	0x00001fff	/* buffer byte count, real data len must <= 4KB */
-#define	CTRL_AE		((u32)3 << 16)	/* address extension bits */
-#define	CTRL_AE_SHIFT	16
-#define	CTRL_PARITY	((u32)3 << 18)	/* parity bit */
-#define	CTRL_EOT	((u32)1 << 28)	/* end of descriptor table */
-#define	CTRL_IOC	((u32)1 << 29)	/* interrupt on completion */
-#define	CTRL_EOF	((u32)1 << 30)	/* end of frame */
-#define	CTRL_SOF	((u32)1 << 31)	/* start of frame */
-
-/* control flags in the range [27:20] are core-specific and not defined here */
-#define	CTRL_CORE_MASK	0x0ff00000
-
 /* 64 bits addressing */
 
 /* dma registers per channel(xmt or rcv) */
@@ -166,150 +44,4 @@ typedef volatile struct {
 	u32 status1;		/* active descriptor, xmt error */
 } dma64regs_t;
 
-typedef volatile struct {
-	dma64regs_t tx;		/* dma64 tx channel */
-	dma64regs_t rx;		/* dma64 rx channel */
-} dma64regp_t;
-
-typedef volatile struct {	/* diag access */
-	u32 fifoaddr;	/* diag address */
-	u32 fifodatalow;	/* low 32bits of data */
-	u32 fifodatahigh;	/* high 32bits of data */
-	u32 pad;		/* reserved */
-} dma64diag_t;
-
-/*
- * DMA Descriptor
- * Descriptors are only read by the hardware, never written back.
- */
-typedef volatile struct {
-	u32 ctrl1;		/* misc control bits & bufcount */
-	u32 ctrl2;		/* buffer count and address extension */
-	u32 addrlow;		/* memory address of the date buffer, bits 31:0 */
-	u32 addrhigh;	/* memory address of the date buffer, bits 63:32 */
-} dma64dd_t;
-
-/*
- * Each descriptor ring must be 8kB aligned, and fit within a contiguous 8kB physical address.
- */
-#define D64RINGALIGN_BITS	13
-#define	D64MAXRINGSZ		(1 << D64RINGALIGN_BITS)
-#define	D64RINGALIGN		(1 << D64RINGALIGN_BITS)
-
-#define	D64MAXDD	(D64MAXRINGSZ / sizeof (dma64dd_t))
-
-/* transmit channel control */
-#define	D64_XC_XE		0x00000001	/* transmit enable */
-#define	D64_XC_SE		0x00000002	/* transmit suspend request */
-#define	D64_XC_LE		0x00000004	/* loopback enable */
-#define	D64_XC_FL		0x00000010	/* flush request */
-#define	D64_XC_PD		0x00000800	/* parity check disable */
-#define	D64_XC_AE		0x00030000	/* address extension bits */
-#define	D64_XC_AE_SHIFT		16
-
-/* transmit descriptor table pointer */
-#define	D64_XP_LD_MASK		0x00000fff	/* last valid descriptor */
-
-/* transmit channel status */
-#define	D64_XS0_CD_MASK		0x00001fff	/* current descriptor pointer */
-#define	D64_XS0_XS_MASK		0xf0000000	/* transmit state */
-#define	D64_XS0_XS_SHIFT		28
-#define	D64_XS0_XS_DISABLED	0x00000000	/* disabled */
-#define	D64_XS0_XS_ACTIVE	0x10000000	/* active */
-#define	D64_XS0_XS_IDLE		0x20000000	/* idle wait */
-#define	D64_XS0_XS_STOPPED	0x30000000	/* stopped */
-#define	D64_XS0_XS_SUSP		0x40000000	/* suspend pending */
-
-#define	D64_XS1_AD_MASK		0x00001fff	/* active descriptor */
-#define	D64_XS1_XE_MASK		0xf0000000	/* transmit errors */
-#define	D64_XS1_XE_SHIFT		28
-#define	D64_XS1_XE_NOERR	0x00000000	/* no error */
-#define	D64_XS1_XE_DPE		0x10000000	/* descriptor protocol error */
-#define	D64_XS1_XE_DFU		0x20000000	/* data fifo underrun */
-#define	D64_XS1_XE_DTE		0x30000000	/* data transfer error */
-#define	D64_XS1_XE_DESRE	0x40000000	/* descriptor read error */
-#define	D64_XS1_XE_COREE	0x50000000	/* core error */
-
-/* receive channel control */
-#define	D64_RC_RE		0x00000001	/* receive enable */
-#define	D64_RC_RO_MASK		0x000000fe	/* receive frame offset */
-#define	D64_RC_RO_SHIFT		1
-#define	D64_RC_FM		0x00000100	/* direct fifo receive (pio) mode */
-#define	D64_RC_SH		0x00000200	/* separate rx header descriptor enable */
-#define	D64_RC_OC		0x00000400	/* overflow continue */
-#define	D64_RC_PD		0x00000800	/* parity check disable */
-#define	D64_RC_AE		0x00030000	/* address extension bits */
-#define	D64_RC_AE_SHIFT		16
-
-/* flags for dma controller */
-#define DMA_CTRL_PEN		(1 << 0)	/* partity enable */
-#define DMA_CTRL_ROC		(1 << 1)	/* rx overflow continue */
-#define DMA_CTRL_RXMULTI	(1 << 2)	/* allow rx scatter to multiple descriptors */
-#define DMA_CTRL_UNFRAMED	(1 << 3)	/* Unframed Rx/Tx data */
-
-/* receive descriptor table pointer */
-#define	D64_RP_LD_MASK		0x00000fff	/* last valid descriptor */
-
-/* receive channel status */
-#define	D64_RS0_CD_MASK		0x00001fff	/* current descriptor pointer */
-#define	D64_RS0_RS_MASK		0xf0000000	/* receive state */
-#define	D64_RS0_RS_SHIFT		28
-#define	D64_RS0_RS_DISABLED	0x00000000	/* disabled */
-#define	D64_RS0_RS_ACTIVE	0x10000000	/* active */
-#define	D64_RS0_RS_IDLE		0x20000000	/* idle wait */
-#define	D64_RS0_RS_STOPPED	0x30000000	/* stopped */
-#define	D64_RS0_RS_SUSP		0x40000000	/* suspend pending */
-
-#define	D64_RS1_AD_MASK		0x0001ffff	/* active descriptor */
-#define	D64_RS1_RE_MASK		0xf0000000	/* receive errors */
-#define	D64_RS1_RE_SHIFT		28
-#define	D64_RS1_RE_NOERR	0x00000000	/* no error */
-#define	D64_RS1_RE_DPO		0x10000000	/* descriptor protocol error */
-#define	D64_RS1_RE_DFU		0x20000000	/* data fifo overflow */
-#define	D64_RS1_RE_DTE		0x30000000	/* data transfer error */
-#define	D64_RS1_RE_DESRE	0x40000000	/* descriptor read error */
-#define	D64_RS1_RE_COREE	0x50000000	/* core error */
-
-/* fifoaddr */
-#define	D64_FA_OFF_MASK		0xffff	/* offset */
-#define	D64_FA_SEL_MASK		0xf0000	/* select */
-#define	D64_FA_SEL_SHIFT	16
-#define	D64_FA_SEL_XDD		0x00000	/* transmit dma data */
-#define	D64_FA_SEL_XDP		0x10000	/* transmit dma pointers */
-#define	D64_FA_SEL_RDD		0x40000	/* receive dma data */
-#define	D64_FA_SEL_RDP		0x50000	/* receive dma pointers */
-#define	D64_FA_SEL_XFD		0x80000	/* transmit fifo data */
-#define	D64_FA_SEL_XFP		0x90000	/* transmit fifo pointers */
-#define	D64_FA_SEL_RFD		0xc0000	/* receive fifo data */
-#define	D64_FA_SEL_RFP		0xd0000	/* receive fifo pointers */
-#define	D64_FA_SEL_RSD		0xe0000	/* receive frame status data */
-#define	D64_FA_SEL_RSP		0xf0000	/* receive frame status pointers */
-
-/* descriptor control flags 1 */
-#define D64_CTRL_COREFLAGS	0x0ff00000	/* core specific flags */
-#define	D64_CTRL1_EOT		((u32)1 << 28)	/* end of descriptor table */
-#define	D64_CTRL1_IOC		((u32)1 << 29)	/* interrupt on completion */
-#define	D64_CTRL1_EOF		((u32)1 << 30)	/* end of frame */
-#define	D64_CTRL1_SOF		((u32)1 << 31)	/* start of frame */
-
-/* descriptor control flags 2 */
-#define	D64_CTRL2_BC_MASK	0x00007fff	/* buffer byte count. real data len must <= 16KB */
-#define	D64_CTRL2_AE		0x00030000	/* address extension bits */
-#define	D64_CTRL2_AE_SHIFT	16
-#define D64_CTRL2_PARITY	0x00040000	/* parity bit */
-
-/* control flags in the range [27:20] are core-specific and not defined here */
-#define	D64_CTRL_CORE_MASK	0x0ff00000
-
-#define D64_RX_FRM_STS_LEN	0x0000ffff	/* frame length mask */
-#define D64_RX_FRM_STS_OVFL	0x00800000	/* RxOverFlow */
-#define D64_RX_FRM_STS_DSCRCNT	0x0f000000  /* no. of descriptors used - 1 */
-#define D64_RX_FRM_STS_DATATYPE	0xf0000000	/* core-dependent data type */
-
-/* receive frame status */
-typedef volatile struct {
-	u16 len;
-	u16 flags;
-} dma_rxh_t;
-
 #endif				/* _sbdma_h_ */
-- 
1.7.4.1


