Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2322 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab1ECJgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:19 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 38/61] staging: brcm80211: remove dependency between
 aiutils and siutils sources
Date: Tue, 3 May 2011 11:35:38 +0200
Message-ID: <1304415361-7813-39-git-send-email-arend@broadcom.com> (sfid-20110503_113751_207813_4CE3A7B8)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The two source files have been separated where aiutils is only used
by the brcmsmac driver and the siutils is only used by the brcmfmac
driver.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile        |    1 -
 drivers/staging/brcm80211/brcmsmac/d11.h           |    2 +
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       | 2157 +++++++++-----------
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.h       |   38 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    2 +-
 drivers/staging/brcm80211/include/aiutils.h        |  565 +++++
 drivers/staging/brcm80211/util/aiutils.c           | 1582 ++++++++++++++-
 drivers/staging/brcm80211/util/bcmotp.c            |   18 +-
 19 files changed, 3145 insertions(+), 1244 deletions(-)
 create mode 100644 drivers/staging/brcm80211/include/aiutils.h

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index 65a1a25..3d9e04b 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -47,7 +47,6 @@ BRCMSMAC_OFILES := \
 	phy/wlc_phytbl_lcn.o \
 	phy/wlc_phytbl_n.o \
 	../util/aiutils.o \
-	../util/siutils.o \
 	../util/bcmutils.o \
 	../util/bcmwifi.o \
 	../util/bcmotp.o \
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index a9d182f..d91e418 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -17,6 +17,8 @@
 #ifndef	_D11_H
 #define	_D11_H
 
+#include <sbconfig.h>
+
 #ifndef WL_RSSI_ANT_MAX
 #define WL_RSSI_ANT_MAX		4	/* max possible rx antennas */
 #elif WL_RSSI_ANT_MAX != 4
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index 12eabc9..8939153 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -18,7 +18,7 @@
 #define _wlc_phy_h_
 
 #include <wlioctl.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <d11.h>
 #include <wlc_phy_shim.h>
 #include <net/mac80211.h>	/* struct wiphy */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index d9f6254..0722097 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -21,7 +21,7 @@
 #include <wlc_cfg.h>
 #include <qmath.h>
 #include <linux/pci.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <wlc_pmu.h>
 
 #include <bcmdevs.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 111b8e9..353b5e2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -20,7 +20,7 @@
 #include <wlc_cfg.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <sbchipc.h>
 #include <wlc_pmu.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index d93bd6a..dc43227 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -18,7 +18,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <wlioctl.h>
 #include <sbhnddma.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 1d7d91b..49ac26c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -18,7 +18,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <wlioctl.h>
 #include <sbhnddma.h>
 #include <hnddma.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 89346fe..a8037e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -22,7 +22,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <bcmdevs.h>
 #include <sbhnddma.h>
 #include <wlioctl.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index e9867ea..a646ab9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -25,7 +25,7 @@
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmwifi.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <bcmsrom.h>
 #include <bcmotp.h>
 #include <bcmutils.h>
@@ -829,7 +829,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		wlc_hw->band->bandtype = j ? WLC_BAND_5G : WLC_BAND_2G;
 		wlc->band->bandunit = j;
 		wlc->band->bandtype = j ? WLC_BAND_5G : WLC_BAND_2G;
-		wlc->core->coreidx = si_coreidx(wlc_hw->sih);
+		wlc->core->coreidx = ai_coreidx(wlc_hw->sih);
 
 		wlc_hw->machwcap = R_REG(&regs->machwcap);
 		wlc_hw->machwcap_backup = wlc_hw->machwcap;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 345c197..40d94b6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -21,7 +21,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <sbhnddma.h>
 #include <wlioctl.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index ea12749..a790cb6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -23,7 +23,7 @@
 #include <bcmdevs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <pcicfg.h>
 #include <bcmsrom.h>
 #include <wlioctl.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index b008582..16fea02 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -29,7 +29,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <wlioctl.h>
 #include <sbconfig.h>
 #include <sbchipc.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 98ba874..4bb14c5 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -13,221 +13,123 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-#include <linux/delay.h>
 #include <linux/kernel.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <bcmdefs.h>
-#include <bcmutils.h>
-#include <siutils.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/io.h>
+
 #include <bcmdevs.h>
-#include <hndsoc.h>
 #include <sbchipc.h>
-#include <wlc_pmu.h>
-#include "siutils_priv.h"
-
-#define	PMU_ERROR(args)
-
-#ifdef BCMDBG
-#define	PMU_MSG(args)	printk args
-
-/* debug-only definitions */
-/* #define BCMDBG_FORCEHT */
-#else
-#define	PMU_MSG(args)
-#endif				/* BCMDBG */
+#include <bcmutils.h>
+#include "wlc_pmu.h"
 
-/* To check in verbose debugging messages not intended
- * to be on except on private builds.
+/*
+ * d11 slow to fast clock transition time in slow clock cycles
  */
-#define	PMU_NONE(args)
-
-/* PLL controls/clocks */
-static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal);
-static u32 si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc);
+#define D11SCC_SLOW2FAST_TRANSITION	2
 
-/* PMU resources */
-static bool si_pmu_res_depfltr_bb(si_t *sih);
-static bool si_pmu_res_depfltr_ncb(si_t *sih);
-static bool si_pmu_res_depfltr_paldo(si_t *sih);
-static bool si_pmu_res_depfltr_npaldo(si_t *sih);
-static u32 si_pmu_res_deps(si_t *sih, chipcregs_t *cc, u32 rsrcs, bool all);
-static uint si_pmu_res_uptime(si_t *sih, chipcregs_t *cc, u8 rsrc);
-static void si_pmu_res_masks(si_t *sih, u32 * pmin, u32 * pmax);
-static void si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc,
-				       u8 spuravoid);
+/*
+ * external LPO crystal frequency
+ */
+#define EXT_ILP_HZ 32768
 
-static void si_pmu_set_4330_plldivs(si_t *sih);
+/*
+ * Duration for ILP clock frequency measurment in milliseconds
+ *
+ * remark: 1000 must be an integer multiple of this duration
+ */
+#define ILP_CALC_DUR	10
 
-/* FVCO frequency */
+/*
+ * FVCO frequency
+ */
 #define FVCO_880	880000	/* 880MHz */
 #define FVCO_1760	1760000	/* 1760MHz */
 #define FVCO_1440	1440000	/* 1440MHz */
 #define FVCO_960	960000	/* 960MHz */
 
-/* Read/write a chipcontrol reg */
-u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val)
-{
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol_addr), ~0,
-		   reg);
-	return si_corereg(sih, SI_CC_IDX,
-			  offsetof(chipcregs_t, chipcontrol_data), mask, val);
-}
-
-/* Read/write a regcontrol reg */
-u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val)
-{
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr), ~0,
-		   reg);
-	return si_corereg(sih, SI_CC_IDX,
-			  offsetof(chipcregs_t, regcontrol_data), mask, val);
-}
-
-/* Read/write a pllcontrol reg */
-u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val)
-{
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pllcontrol_addr), ~0,
-		   reg);
-	return si_corereg(sih, SI_CC_IDX,
-			  offsetof(chipcregs_t, pllcontrol_data), mask, val);
-}
-
-/* PMU PLL update */
-void si_pmu_pllupd(si_t *sih)
-{
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmucontrol),
-		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
-}
+/*
+ * PMU crystal table indices for 1440MHz fvco
+ */
+#define PMU1_XTALTAB0_1440_12000K	0
+#define PMU1_XTALTAB0_1440_13000K	1
+#define PMU1_XTALTAB0_1440_14400K	2
+#define PMU1_XTALTAB0_1440_15360K	3
+#define PMU1_XTALTAB0_1440_16200K	4
+#define PMU1_XTALTAB0_1440_16800K	5
+#define PMU1_XTALTAB0_1440_19200K	6
+#define PMU1_XTALTAB0_1440_19800K	7
+#define PMU1_XTALTAB0_1440_20000K	8
+#define PMU1_XTALTAB0_1440_25000K	9
+#define PMU1_XTALTAB0_1440_26000K	10
+#define PMU1_XTALTAB0_1440_30000K	11
+#define PMU1_XTALTAB0_1440_37400K	12
+#define PMU1_XTALTAB0_1440_38400K	13
+#define PMU1_XTALTAB0_1440_40000K	14
+#define PMU1_XTALTAB0_1440_48000K	15
 
-void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
-{
-	u8 sr_cntl_shift = 0, rc_shift = 0, shift = 0, mask = 0;
-	u8 addr = 0;
+/*
+ * PMU crystal table indices for 960MHz fvco
+ */
+#define PMU1_XTALTAB0_960_12000K	0
+#define PMU1_XTALTAB0_960_13000K	1
+#define PMU1_XTALTAB0_960_14400K	2
+#define PMU1_XTALTAB0_960_15360K	3
+#define PMU1_XTALTAB0_960_16200K	4
+#define PMU1_XTALTAB0_960_16800K	5
+#define PMU1_XTALTAB0_960_19200K	6
+#define PMU1_XTALTAB0_960_19800K	7
+#define PMU1_XTALTAB0_960_20000K	8
+#define PMU1_XTALTAB0_960_25000K	9
+#define PMU1_XTALTAB0_960_26000K	10
+#define PMU1_XTALTAB0_960_30000K	11
+#define PMU1_XTALTAB0_960_37400K	12
+#define PMU1_XTALTAB0_960_38400K	13
+#define PMU1_XTALTAB0_960_40000K	14
+#define PMU1_XTALTAB0_960_48000K	15
 
-	switch (sih->chip) {
-	case BCM4336_CHIP_ID:
-		switch (ldo) {
-		case SET_LDO_VOLTAGE_CLDO_PWM:
-			addr = 4;
-			rc_shift = 1;
-			mask = 0xf;
-			break;
-		case SET_LDO_VOLTAGE_CLDO_BURST:
-			addr = 4;
-			rc_shift = 5;
-			mask = 0xf;
-			break;
-		case SET_LDO_VOLTAGE_LNLDO1:
-			addr = 4;
-			rc_shift = 17;
-			mask = 0xf;
-			break;
-		default:
-			return;
-		}
-		break;
-	case BCM4330_CHIP_ID:
-		switch (ldo) {
-		case SET_LDO_VOLTAGE_CBUCK_PWM:
-			addr = 3;
-			rc_shift = 0;
-			mask = 0x1f;
-			break;
-		default:
-			break;
-		}
-		break;
-	default:
-		return;
-	}
+/*
+ * PMU crystal table indices for 880MHz fvco
+ */
+#define PMU1_XTALTAB0_880_12000K	0
+#define PMU1_XTALTAB0_880_13000K	1
+#define PMU1_XTALTAB0_880_14400K	2
+#define PMU1_XTALTAB0_880_15360K	3
+#define PMU1_XTALTAB0_880_16200K	4
+#define PMU1_XTALTAB0_880_16800K	5
+#define PMU1_XTALTAB0_880_19200K	6
+#define PMU1_XTALTAB0_880_19800K	7
+#define PMU1_XTALTAB0_880_20000K	8
+#define PMU1_XTALTAB0_880_24000K	9
+#define PMU1_XTALTAB0_880_25000K	10
+#define PMU1_XTALTAB0_880_26000K	11
+#define PMU1_XTALTAB0_880_30000K	12
+#define PMU1_XTALTAB0_880_37400K	13
+#define PMU1_XTALTAB0_880_38400K	14
+#define PMU1_XTALTAB0_880_40000K	15
 
-	shift = sr_cntl_shift + rc_shift;
+/*
+ * crystal frequency values
+ */
+#define XTAL_FREQ_24000MHZ		24000
+#define XTAL_FREQ_30000MHZ		30000
+#define XTAL_FREQ_37400MHZ		37400
+#define XTAL_FREQ_48000MHZ		48000
 
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr),
-		   ~0, addr);
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_data),
-		   mask << shift, (voltage & mask) << shift);
-}
+/*
+ * Resource dependancies mask change action
+ *
+ * @RES_DEPEND_SET: Override the dependancies mask
+ * @RES_DEPEND_ADD: Add to the  dependancies mask
+ * @RES_DEPEND_REMOVE: Remove from the dependancies mask
+ */
+#define RES_DEPEND_SET		0
+#define RES_DEPEND_ADD		1
+#define RES_DEPEND_REMOVE	-1
 
 /* d11 slow to fast clock transition time in slow clock cycles */
 #define D11SCC_SLOW2FAST_TRANSITION	2
 
-u16 si_pmu_fast_pwrup_delay(si_t *sih)
-{
-	uint delay = PMU_MAX_TRANSITION_DLY;
-	chipcregs_t *cc;
-	uint origidx;
-#ifdef BCMDBG
-	char chn[8];
-	chn[0] = 0;		/* to suppress compile error */
-#endif
-
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	switch (sih->chip) {
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-	case BCM43421_CHIP_ID:
-	case BCM43235_CHIP_ID:
-	case BCM43236_CHIP_ID:
-	case BCM43238_CHIP_ID:
-	case BCM4331_CHIP_ID:
-	case BCM6362_CHIP_ID:
-	case BCM4313_CHIP_ID:
-		delay = ISSIM_ENAB(sih) ? 70 : 3700;
-		break;
-	case BCM4329_CHIP_ID:
-		if (ISSIM_ENAB(sih))
-			delay = 70;
-		else {
-			u32 ilp = si_ilp_clock(sih);
-			delay =
-			    (si_pmu_res_uptime(sih, cc, RES4329_HT_AVAIL) +
-			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
-							      1) / ilp);
-			delay = (11 * delay) / 10;
-		}
-		break;
-	case BCM4319_CHIP_ID:
-		delay = ISSIM_ENAB(sih) ? 70 : 3700;
-		break;
-	case BCM4336_CHIP_ID:
-		if (ISSIM_ENAB(sih))
-			delay = 70;
-		else {
-			u32 ilp = si_ilp_clock(sih);
-			delay =
-			    (si_pmu_res_uptime(sih, cc, RES4336_HT_AVAIL) +
-			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
-							      1) / ilp);
-			delay = (11 * delay) / 10;
-		}
-		break;
-	case BCM4330_CHIP_ID:
-		if (ISSIM_ENAB(sih))
-			delay = 70;
-		else {
-			u32 ilp = si_ilp_clock(sih);
-			delay =
-			    (si_pmu_res_uptime(sih, cc, RES4330_HT_AVAIL) +
-			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
-							      1) / ilp);
-			delay = (11 * delay) / 10;
-		}
-		break;
-	default:
-		break;
-	}
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-
-	return (u16) delay;
-}
-
 /* Setup resource up/down timers */
 typedef struct {
 	u8 resnum;
@@ -242,10 +144,23 @@ typedef struct {
 	 bool(*filter) (si_t *sih);	/* action is taken when filter is NULL or return true */
 } pmu_res_depend_t;
 
-/* Resource dependancies mask change action */
-#define RES_DEPEND_SET		0	/* Override the dependancies mask */
-#define RES_DEPEND_ADD		1	/* Add to the  dependancies mask */
-#define RES_DEPEND_REMOVE	-1	/* Remove from the dependancies mask */
+/* setup pll and query clock speed */
+typedef struct {
+	u16 fref;
+	u8 xf;
+	u8 p1div;
+	u8 p2div;
+	u8 ndiv_int;
+	u32 ndiv_frac;
+} pmu1_xtaltab0_t;
+
+/*
+ * prototypes used in resource tables
+ */
+static bool si_pmu_res_depfltr_bb(si_t *sih);
+static bool si_pmu_res_depfltr_ncb(si_t *sih);
+static bool si_pmu_res_depfltr_paldo(si_t *sih);
+static bool si_pmu_res_depfltr_npaldo(si_t *sih);
 
 static const pmu_res_updown_t bcm4328a0_res_updown[] = {
 	{
@@ -502,6 +417,92 @@ static const pmu_res_depend_t bcm4330a0_res_depend[] = {
 	PMURES_BIT(RES4330_HT_AVAIL), RES_DEPEND_ADD, 0, NULL}
 };
 
+/* the following table is based on 1440Mhz fvco */
+static const pmu1_xtaltab0_t pmu1_xtaltab0_1440[] = {
+	{
+	12000, 1, 1, 1, 0x78, 0x0}, {
+	13000, 2, 1, 1, 0x6E, 0xC4EC4E}, {
+	14400, 3, 1, 1, 0x64, 0x0}, {
+	15360, 4, 1, 1, 0x5D, 0xC00000}, {
+	16200, 5, 1, 1, 0x58, 0xE38E38}, {
+	16800, 6, 1, 1, 0x55, 0xB6DB6D}, {
+	19200, 7, 1, 1, 0x4B, 0}, {
+	19800, 8, 1, 1, 0x48, 0xBA2E8B}, {
+	20000, 9, 1, 1, 0x48, 0x0}, {
+	25000, 10, 1, 1, 0x39, 0x999999}, {
+	26000, 11, 1, 1, 0x37, 0x627627}, {
+	30000, 12, 1, 1, 0x30, 0x0}, {
+	37400, 13, 2, 1, 0x4D, 0x15E76}, {
+	38400, 13, 2, 1, 0x4B, 0x0}, {
+	40000, 14, 2, 1, 0x48, 0x0}, {
+	48000, 15, 2, 1, 0x3c, 0x0}, {
+	0, 0, 0, 0, 0, 0}
+};
+
+static const pmu1_xtaltab0_t pmu1_xtaltab0_960[] = {
+	{
+	12000, 1, 1, 1, 0x50, 0x0}, {
+	13000, 2, 1, 1, 0x49, 0xD89D89}, {
+	14400, 3, 1, 1, 0x42, 0xAAAAAA}, {
+	15360, 4, 1, 1, 0x3E, 0x800000}, {
+	16200, 5, 1, 1, 0x39, 0x425ED0}, {
+	16800, 6, 1, 1, 0x39, 0x249249}, {
+	19200, 7, 1, 1, 0x32, 0x0}, {
+	19800, 8, 1, 1, 0x30, 0x7C1F07}, {
+	20000, 9, 1, 1, 0x30, 0x0}, {
+	25000, 10, 1, 1, 0x26, 0x666666}, {
+	26000, 11, 1, 1, 0x24, 0xEC4EC4}, {
+	30000, 12, 1, 1, 0x20, 0x0}, {
+	37400, 13, 2, 1, 0x33, 0x563EF9}, {
+	38400, 14, 2, 1, 0x32, 0x0}, {
+	40000, 15, 2, 1, 0x30, 0x0}, {
+	48000, 16, 2, 1, 0x28, 0x0}, {
+	0, 0, 0, 0, 0, 0}
+};
+
+static const pmu1_xtaltab0_t pmu1_xtaltab0_880_4329[] = {
+	{
+	12000, 1, 3, 22, 0x9, 0xFFFFEF}, {
+	13000, 2, 1, 6, 0xb, 0x483483}, {
+	14400, 3, 1, 10, 0xa, 0x1C71C7}, {
+	15360, 4, 1, 5, 0xb, 0x755555}, {
+	16200, 5, 1, 10, 0x5, 0x6E9E06}, {
+	16800, 6, 1, 10, 0x5, 0x3Cf3Cf}, {
+	19200, 7, 1, 4, 0xb, 0x755555}, {
+	19800, 8, 1, 11, 0x4, 0xA57EB}, {
+	20000, 9, 1, 11, 0x4, 0x0}, {
+	24000, 10, 3, 11, 0xa, 0x0}, {
+	25000, 11, 5, 16, 0xb, 0x0}, {
+	26000, 12, 1, 1, 0x21, 0xD89D89}, {
+	30000, 13, 3, 8, 0xb, 0x0}, {
+	37400, 14, 3, 1, 0x46, 0x969696}, {
+	38400, 15, 1, 1, 0x16, 0xEAAAAA}, {
+	40000, 16, 1, 2, 0xb, 0}, {
+	0, 0, 0, 0, 0, 0}
+};
+
+/* the following table is based on 880Mhz fvco */
+static const pmu1_xtaltab0_t pmu1_xtaltab0_880[] = {
+	{
+	12000, 1, 3, 22, 0x9, 0xFFFFEF}, {
+	13000, 2, 1, 6, 0xb, 0x483483}, {
+	14400, 3, 1, 10, 0xa, 0x1C71C7}, {
+	15360, 4, 1, 5, 0xb, 0x755555}, {
+	16200, 5, 1, 10, 0x5, 0x6E9E06}, {
+	16800, 6, 1, 10, 0x5, 0x3Cf3Cf}, {
+	19200, 7, 1, 4, 0xb, 0x755555}, {
+	19800, 8, 1, 11, 0x4, 0xA57EB}, {
+	20000, 9, 1, 11, 0x4, 0x0}, {
+	24000, 10, 3, 11, 0xa, 0x0}, {
+	25000, 11, 5, 16, 0xb, 0x0}, {
+	26000, 12, 1, 2, 0x10, 0xEC4EC4}, {
+	30000, 13, 3, 8, 0xb, 0x0}, {
+	33600, 14, 1, 2, 0xd, 0x186186}, {
+	38400, 15, 1, 2, 0xb, 0x755555}, {
+	40000, 16, 1, 2, 0xb, 0}, {
+	0, 0, 0, 0, 0, 0}
+};
+
 /* true if the power topology uses the buck boost to provide 3.3V to VDDIO_RF and WLAN PA */
 static bool si_pmu_res_depfltr_bb(si_t *sih)
 {
@@ -527,8 +528,26 @@ static bool si_pmu_res_depfltr_npaldo(si_t *sih)
 	return (sih->boardflags & BFL_PALDO) == 0;
 }
 
-#define BCM94325_BBVDDIOSD_BOARDS(sih) (sih->boardtype == BCM94325DEVBU_BOARD || \
-					sih->boardtype == BCM94325BGABU_BOARD)
+/* Return dependancies (direct or all/indirect) for the given resources */
+static u32
+si_pmu_res_deps(si_t *sih, chipcregs_t *cc, u32 rsrcs,
+		bool all)
+{
+	u32 deps = 0;
+	u32 i;
+
+	for (i = 0; i <= PMURES_MAX_RESNUM; i++) {
+		if (!(rsrcs & PMURES_BIT(i)))
+			continue;
+		W_REG(&cc->res_table_sel, i);
+		deps |= R_REG(&cc->res_dep_mask);
+	}
+
+	return !all ? deps : (deps
+			      ? (deps |
+				 si_pmu_res_deps(sih, cc, deps,
+						 true)) : 0);
+}
 
 /* Determine min/max rsrc masks. Value 0 leaves hardware at default. */
 static void si_pmu_res_masks(si_t *sih, u32 * pmin, u32 * pmax)
@@ -604,13 +623,11 @@ static void si_pmu_res_masks(si_t *sih, u32 * pmin, u32 * pmax)
 	/* Apply nvram override to min mask */
 	val = getvar(NULL, "rmin");
 	if (val != NULL) {
-		PMU_MSG(("Applying rmin=%s to min_mask\n", val));
 		min_mask = (u32) simple_strtoul(val, NULL, 0);
 	}
 	/* Apply nvram override to max mask */
 	val = getvar(NULL, "rmax");
 	if (val != NULL) {
-		PMU_MSG(("Applying rmax=%s to max_mask\n", val));
 		max_mask = (u32) simple_strtoul(val, NULL, 0);
 	}
 
@@ -618,446 +635,239 @@ static void si_pmu_res_masks(si_t *sih, u32 * pmin, u32 * pmax)
 	*pmax = max_mask;
 }
 
-/* initialize PMU resources */
-void si_pmu_res_init(si_t *sih)
-{
-	chipcregs_t *cc;
-	uint origidx;
-	const pmu_res_updown_t *pmu_res_updown_table = NULL;
-	uint pmu_res_updown_table_sz = 0;
-	const pmu_res_depend_t *pmu_res_depend_table = NULL;
-	uint pmu_res_depend_table_sz = 0;
+/* Return up time in ILP cycles for the given resource. */
+static uint
+si_pmu_res_uptime(si_t *sih, chipcregs_t *cc, u8 rsrc) {
+	u32 deps;
+	uint up, i, dup, dmax;
 	u32 min_mask = 0, max_mask = 0;
-	char name[8], *val;
-	uint i, rsrcs;
 
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	/* uptime of resource 'rsrc' */
+	W_REG(&cc->res_table_sel, rsrc);
+	up = (R_REG(&cc->res_updn_timer) >> 8) & 0xff;
+
+	/* direct dependancies of resource 'rsrc' */
+	deps = si_pmu_res_deps(sih, cc, PMURES_BIT(rsrc), false);
+	for (i = 0; i <= PMURES_MAX_RESNUM; i++) {
+		if (!(deps & PMURES_BIT(i)))
+			continue;
+		deps &= ~si_pmu_res_deps(sih, cc, PMURES_BIT(i), true);
+	}
+	si_pmu_res_masks(sih, &min_mask, &max_mask);
+	deps &= ~min_mask;
+
+	/* max uptime of direct dependancies */
+	dmax = 0;
+	for (i = 0; i <= PMURES_MAX_RESNUM; i++) {
+		if (!(deps & PMURES_BIT(i)))
+			continue;
+		dup = si_pmu_res_uptime(sih, cc, (u8) i);
+		if (dmax < dup)
+			dmax = dup;
+	}
+
+	return up + dmax + PMURES_UP_TRANSITION;
+}
+
+static void
+si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
+{
+	u32 tmp = 0;
+	u8 phypll_offset = 0;
+	u8 bcm5357_bcm43236_p1div[] = { 0x1, 0x5, 0x5 };
+	u8 bcm5357_bcm43236_ndiv[] = { 0x30, 0xf6, 0xfc };
 
 	switch (sih->chip) {
-	case BCM4329_CHIP_ID:
-		/* Optimize resources up/down timers */
-		if (ISSIM_ENAB(sih)) {
-			pmu_res_updown_table = NULL;
-			pmu_res_updown_table_sz = 0;
-		} else {
-			pmu_res_updown_table = bcm4329_res_updown;
-			pmu_res_updown_table_sz = ARRAY_SIZE(bcm4329_res_updown);
-		}
-		/* Optimize resources dependencies */
-		pmu_res_depend_table = bcm4329_res_depend;
-		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4329_res_depend);
-		break;
+	case BCM5357_CHIP_ID:
+	case BCM43235_CHIP_ID:
+	case BCM43236_CHIP_ID:
+	case BCM43238_CHIP_ID:
 
-	case BCM4319_CHIP_ID:
-		/* Optimize resources up/down timers */
-		if (ISSIM_ENAB(sih)) {
-			pmu_res_updown_table = bcm4319a0_res_updown_qt;
-			pmu_res_updown_table_sz =
-			    ARRAY_SIZE(bcm4319a0_res_updown_qt);
-		} else {
-			pmu_res_updown_table = bcm4319a0_res_updown;
-			pmu_res_updown_table_sz =
-			    ARRAY_SIZE(bcm4319a0_res_updown);
-		}
-		/* Optimize resources dependancies masks */
-		pmu_res_depend_table = bcm4319a0_res_depend;
-		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4319a0_res_depend);
-		break;
+		/* BCM5357 needs to touch PLL1_PLLCTL[02], so offset PLL0_PLLCTL[02] by 6 */
+		phypll_offset = (sih->chip == BCM5357_CHIP_ID) ? 6 : 0;
 
-	case BCM4336_CHIP_ID:
-		/* Optimize resources up/down timers */
-		if (ISSIM_ENAB(sih)) {
-			pmu_res_updown_table = bcm4336a0_res_updown_qt;
-			pmu_res_updown_table_sz =
-			    ARRAY_SIZE(bcm4336a0_res_updown_qt);
-		} else {
-			pmu_res_updown_table = bcm4336a0_res_updown;
-			pmu_res_updown_table_sz =
-			    ARRAY_SIZE(bcm4336a0_res_updown);
-		}
-		/* Optimize resources dependancies masks */
-		pmu_res_depend_table = bcm4336a0_res_depend;
-		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4336a0_res_depend);
+		/* RMW only the P1 divider */
+		W_REG(&cc->pllcontrol_addr,
+		      PMU1_PLL0_PLLCTL0 + phypll_offset);
+		tmp = R_REG(&cc->pllcontrol_data);
+		tmp &= (~(PMU1_PLL0_PC0_P1DIV_MASK));
+		tmp |=
+		    (bcm5357_bcm43236_p1div[spuravoid] <<
+		     PMU1_PLL0_PC0_P1DIV_SHIFT);
+		W_REG(&cc->pllcontrol_data, tmp);
+
+		/* RMW only the int feedback divider */
+		W_REG(&cc->pllcontrol_addr,
+		      PMU1_PLL0_PLLCTL2 + phypll_offset);
+		tmp = R_REG(&cc->pllcontrol_data);
+		tmp &= ~(PMU1_PLL0_PC2_NDIV_INT_MASK);
+		tmp |=
+		    (bcm5357_bcm43236_ndiv[spuravoid]) <<
+		    PMU1_PLL0_PC2_NDIV_INT_SHIFT;
+		W_REG(&cc->pllcontrol_data, tmp);
+
+		tmp = 1 << 10;
 		break;
 
-	case BCM4330_CHIP_ID:
-		/* Optimize resources up/down timers */
-		if (ISSIM_ENAB(sih)) {
-			pmu_res_updown_table = bcm4330a0_res_updown_qt;
-			pmu_res_updown_table_sz =
-			    ARRAY_SIZE(bcm4330a0_res_updown_qt);
+	case BCM4331_CHIP_ID:
+		if (spuravoid == 2) {
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11500014);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x0FC00a08);
+		} else if (spuravoid == 1) {
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11500014);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x0F600a08);
 		} else {
-			pmu_res_updown_table = bcm4330a0_res_updown;
-			pmu_res_updown_table_sz =
-			    ARRAY_SIZE(bcm4330a0_res_updown);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11100014);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x03000a08);
 		}
-		/* Optimize resources dependancies masks */
-		pmu_res_depend_table = bcm4330a0_res_depend;
-		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4330a0_res_depend);
+		tmp = 1 << 10;
 		break;
 
-	default:
+	case BCM43224_CHIP_ID:
+	case BCM43225_CHIP_ID:
+	case BCM43421_CHIP_ID:
+	case BCM6362_CHIP_ID:
+		if (spuravoid == 1) {
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11500010);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+			W_REG(&cc->pllcontrol_data, 0x000C0C06);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x0F600a08);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
+			W_REG(&cc->pllcontrol_data, 0x00000000);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
+			W_REG(&cc->pllcontrol_data, 0x2001E920);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+			W_REG(&cc->pllcontrol_data, 0x88888815);
+		} else {
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11100010);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+			W_REG(&cc->pllcontrol_data, 0x000c0c06);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x03000a08);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
+			W_REG(&cc->pllcontrol_data, 0x00000000);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
+			W_REG(&cc->pllcontrol_data, 0x200005c0);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+			W_REG(&cc->pllcontrol_data, 0x88888815);
+		}
+		tmp = 1 << 10;
 		break;
-	}
 
-	/* # resources */
-	rsrcs = (sih->pmucaps & PCAP_RC_MASK) >> PCAP_RC_SHIFT;
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+		W_REG(&cc->pllcontrol_data, 0x11100008);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+		W_REG(&cc->pllcontrol_data, 0x0c000c06);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+		W_REG(&cc->pllcontrol_data, 0x03000a08);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
+		W_REG(&cc->pllcontrol_data, 0x00000000);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
+		W_REG(&cc->pllcontrol_data, 0x200005c0);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+		W_REG(&cc->pllcontrol_data, 0x88888855);
 
-	/* Program up/down timers */
-	while (pmu_res_updown_table_sz--) {
-		PMU_MSG(("Changing rsrc %d res_updn_timer to 0x%x\n",
-			 pmu_res_updown_table[pmu_res_updown_table_sz].resnum,
-			 pmu_res_updown_table[pmu_res_updown_table_sz].updown));
-		W_REG(&cc->res_table_sel,
-		      pmu_res_updown_table[pmu_res_updown_table_sz].resnum);
-		W_REG(&cc->res_updn_timer,
-		      pmu_res_updown_table[pmu_res_updown_table_sz].updown);
-	}
-	/* Apply nvram overrides to up/down timers */
-	for (i = 0; i < rsrcs; i++) {
-		snprintf(name, sizeof(name), "r%dt", i);
-		val = getvar(NULL, name);
-		if (val == NULL)
-			continue;
-		PMU_MSG(("Applying %s=%s to rsrc %d res_updn_timer\n", name,
-			 val, i));
-		W_REG(&cc->res_table_sel, (u32) i);
-		W_REG(&cc->res_updn_timer,
-		      (u32) simple_strtoul(val, NULL, 0));
-	}
+		tmp = 1 << 10;
+		break;
 
-	/* Program resource dependencies table */
-	while (pmu_res_depend_table_sz--) {
-		if (pmu_res_depend_table[pmu_res_depend_table_sz].filter != NULL
-		    && !(pmu_res_depend_table[pmu_res_depend_table_sz].
-			 filter) (sih))
-			continue;
-		for (i = 0; i < rsrcs; i++) {
-			if ((pmu_res_depend_table[pmu_res_depend_table_sz].
-			     res_mask & PMURES_BIT(i)) == 0)
-				continue;
-			W_REG(&cc->res_table_sel, i);
-			switch (pmu_res_depend_table[pmu_res_depend_table_sz].
-				action) {
-			case RES_DEPEND_SET:
-				PMU_MSG(("Changing rsrc %d res_dep_mask to 0x%x\n", i, pmu_res_depend_table[pmu_res_depend_table_sz].depend_mask));
-				W_REG(&cc->res_dep_mask,
-				      pmu_res_depend_table
-				      [pmu_res_depend_table_sz].depend_mask);
-				break;
-			case RES_DEPEND_ADD:
-				PMU_MSG(("Adding 0x%x to rsrc %d res_dep_mask\n", pmu_res_depend_table[pmu_res_depend_table_sz].depend_mask, i));
-				OR_REG(&cc->res_dep_mask,
-				       pmu_res_depend_table
-				       [pmu_res_depend_table_sz].depend_mask);
-				break;
-			case RES_DEPEND_REMOVE:
-				PMU_MSG(("Removing 0x%x from rsrc %d res_dep_mask\n", pmu_res_depend_table[pmu_res_depend_table_sz].depend_mask, i));
-				AND_REG(&cc->res_dep_mask,
-					~pmu_res_depend_table
-					[pmu_res_depend_table_sz].depend_mask);
-				break;
-			default:
-				break;
-			}
+	case BCM4716_CHIP_ID:
+	case BCM4748_CHIP_ID:
+	case BCM47162_CHIP_ID:
+		if (spuravoid == 1) {
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11500060);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+			W_REG(&cc->pllcontrol_data, 0x080C0C06);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x0F600000);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
+			W_REG(&cc->pllcontrol_data, 0x00000000);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
+			W_REG(&cc->pllcontrol_data, 0x2001E924);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+			W_REG(&cc->pllcontrol_data, 0x88888815);
+		} else {
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+			W_REG(&cc->pllcontrol_data, 0x11100060);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+			W_REG(&cc->pllcontrol_data, 0x080c0c06);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x03000000);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
+			W_REG(&cc->pllcontrol_data, 0x00000000);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
+			W_REG(&cc->pllcontrol_data, 0x200005c0);
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+			W_REG(&cc->pllcontrol_data, 0x88888815);
 		}
-	}
-	/* Apply nvram overrides to dependancies masks */
-	for (i = 0; i < rsrcs; i++) {
-		snprintf(name, sizeof(name), "r%dd", i);
-		val = getvar(NULL, name);
-		if (val == NULL)
-			continue;
-		PMU_MSG(("Applying %s=%s to rsrc %d res_dep_mask\n", name, val,
-			 i));
-		W_REG(&cc->res_table_sel, (u32) i);
-		W_REG(&cc->res_dep_mask,
-		      (u32) simple_strtoul(val, NULL, 0));
-	}
-
-	/* Determine min/max rsrc masks */
-	si_pmu_res_masks(sih, &min_mask, &max_mask);
-
-	/* It is required to program max_mask first and then min_mask */
-
-	/* Program max resource mask */
-
-	if (max_mask) {
-		PMU_MSG(("Changing max_res_mask to 0x%x\n", max_mask));
-		W_REG(&cc->max_res_mask, max_mask);
-	}
-
-	/* Program min resource mask */
-
-	if (min_mask) {
-		PMU_MSG(("Changing min_res_mask to 0x%x\n", min_mask));
-		W_REG(&cc->min_res_mask, min_mask);
-	}
-
-	/* Add some delay; allow resources to come up and settle. */
-	mdelay(2);
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-}
-
-/* setup pll and query clock speed */
-typedef struct {
-	u16 freq;
-	u8 xf;
-	u8 wbint;
-	u32 wbfrac;
-} pmu0_xtaltab0_t;
-
-/* the following table is based on 880Mhz fvco */
-static const pmu0_xtaltab0_t pmu0_xtaltab0[] = {
-	{
-	12000, 1, 73, 349525}, {
-	13000, 2, 67, 725937}, {
-	14400, 3, 61, 116508}, {
-	15360, 4, 57, 305834}, {
-	16200, 5, 54, 336579}, {
-	16800, 6, 52, 399457}, {
-	19200, 7, 45, 873813}, {
-	19800, 8, 44, 466033}, {
-	20000, 9, 44, 0}, {
-	25000, 10, 70, 419430}, {
-	26000, 11, 67, 725937}, {
-	30000, 12, 58, 699050}, {
-	38400, 13, 45, 873813}, {
-	40000, 14, 45, 0}, {
-	0, 0, 0, 0}
-};
-
-#define PMU0_XTAL0_DEFAULT	8
-
-/* setup pll and query clock speed */
-typedef struct {
-	u16 fref;
-	u8 xf;
-	u8 p1div;
-	u8 p2div;
-	u8 ndiv_int;
-	u32 ndiv_frac;
-} pmu1_xtaltab0_t;
-
-static const pmu1_xtaltab0_t pmu1_xtaltab0_880_4329[] = {
-	{
-	12000, 1, 3, 22, 0x9, 0xFFFFEF}, {
-	13000, 2, 1, 6, 0xb, 0x483483}, {
-	14400, 3, 1, 10, 0xa, 0x1C71C7}, {
-	15360, 4, 1, 5, 0xb, 0x755555}, {
-	16200, 5, 1, 10, 0x5, 0x6E9E06}, {
-	16800, 6, 1, 10, 0x5, 0x3Cf3Cf}, {
-	19200, 7, 1, 4, 0xb, 0x755555}, {
-	19800, 8, 1, 11, 0x4, 0xA57EB}, {
-	20000, 9, 1, 11, 0x4, 0x0}, {
-	24000, 10, 3, 11, 0xa, 0x0}, {
-	25000, 11, 5, 16, 0xb, 0x0}, {
-	26000, 12, 1, 1, 0x21, 0xD89D89}, {
-	30000, 13, 3, 8, 0xb, 0x0}, {
-	37400, 14, 3, 1, 0x46, 0x969696}, {
-	38400, 15, 1, 1, 0x16, 0xEAAAAA}, {
-	40000, 16, 1, 2, 0xb, 0}, {
-	0, 0, 0, 0, 0, 0}
-};
 
-/* the following table is based on 880Mhz fvco */
-static const pmu1_xtaltab0_t pmu1_xtaltab0_880[] = {
-	{
-	12000, 1, 3, 22, 0x9, 0xFFFFEF}, {
-	13000, 2, 1, 6, 0xb, 0x483483}, {
-	14400, 3, 1, 10, 0xa, 0x1C71C7}, {
-	15360, 4, 1, 5, 0xb, 0x755555}, {
-	16200, 5, 1, 10, 0x5, 0x6E9E06}, {
-	16800, 6, 1, 10, 0x5, 0x3Cf3Cf}, {
-	19200, 7, 1, 4, 0xb, 0x755555}, {
-	19800, 8, 1, 11, 0x4, 0xA57EB}, {
-	20000, 9, 1, 11, 0x4, 0x0}, {
-	24000, 10, 3, 11, 0xa, 0x0}, {
-	25000, 11, 5, 16, 0xb, 0x0}, {
-	26000, 12, 1, 2, 0x10, 0xEC4EC4}, {
-	30000, 13, 3, 8, 0xb, 0x0}, {
-	33600, 14, 1, 2, 0xd, 0x186186}, {
-	38400, 15, 1, 2, 0xb, 0x755555}, {
-	40000, 16, 1, 2, 0xb, 0}, {
-	0, 0, 0, 0, 0, 0}
-};
-
-#define PMU1_XTALTAB0_880_12000K	0
-#define PMU1_XTALTAB0_880_13000K	1
-#define PMU1_XTALTAB0_880_14400K	2
-#define PMU1_XTALTAB0_880_15360K	3
-#define PMU1_XTALTAB0_880_16200K	4
-#define PMU1_XTALTAB0_880_16800K	5
-#define PMU1_XTALTAB0_880_19200K	6
-#define PMU1_XTALTAB0_880_19800K	7
-#define PMU1_XTALTAB0_880_20000K	8
-#define PMU1_XTALTAB0_880_24000K	9
-#define PMU1_XTALTAB0_880_25000K	10
-#define PMU1_XTALTAB0_880_26000K	11
-#define PMU1_XTALTAB0_880_30000K	12
-#define PMU1_XTALTAB0_880_37400K	13
-#define PMU1_XTALTAB0_880_38400K	14
-#define PMU1_XTALTAB0_880_40000K	15
-
-/* the following table is based on 1760Mhz fvco */
-static const pmu1_xtaltab0_t pmu1_xtaltab0_1760[] = {
-	{
-	12000, 1, 3, 44, 0x9, 0xFFFFEF}, {
-	13000, 2, 1, 12, 0xb, 0x483483}, {
-	14400, 3, 1, 20, 0xa, 0x1C71C7}, {
-	15360, 4, 1, 10, 0xb, 0x755555}, {
-	16200, 5, 1, 20, 0x5, 0x6E9E06}, {
-	16800, 6, 1, 20, 0x5, 0x3Cf3Cf}, {
-	19200, 7, 1, 18, 0x5, 0x17B425}, {
-	19800, 8, 1, 22, 0x4, 0xA57EB}, {
-	20000, 9, 1, 22, 0x4, 0x0}, {
-	24000, 10, 3, 22, 0xa, 0x0}, {
-	25000, 11, 5, 32, 0xb, 0x0}, {
-	26000, 12, 1, 4, 0x10, 0xEC4EC4}, {
-	30000, 13, 3, 16, 0xb, 0x0}, {
-	38400, 14, 1, 10, 0x4, 0x955555}, {
-	40000, 15, 1, 4, 0xb, 0}, {
-	0, 0, 0, 0, 0, 0}
-};
-
-/* table index */
-#define PMU1_XTALTAB0_1760_12000K	0
-#define PMU1_XTALTAB0_1760_13000K	1
-#define PMU1_XTALTAB0_1760_14400K	2
-#define PMU1_XTALTAB0_1760_15360K	3
-#define PMU1_XTALTAB0_1760_16200K	4
-#define PMU1_XTALTAB0_1760_16800K	5
-#define PMU1_XTALTAB0_1760_19200K	6
-#define PMU1_XTALTAB0_1760_19800K	7
-#define PMU1_XTALTAB0_1760_20000K	8
-#define PMU1_XTALTAB0_1760_24000K	9
-#define PMU1_XTALTAB0_1760_25000K	10
-#define PMU1_XTALTAB0_1760_26000K	11
-#define PMU1_XTALTAB0_1760_30000K	12
-#define PMU1_XTALTAB0_1760_38400K	13
-#define PMU1_XTALTAB0_1760_40000K	14
+		tmp = 3 << 9;
+		break;
 
-/* the following table is based on 1440Mhz fvco */
-static const pmu1_xtaltab0_t pmu1_xtaltab0_1440[] = {
-	{
-	12000, 1, 1, 1, 0x78, 0x0}, {
-	13000, 2, 1, 1, 0x6E, 0xC4EC4E}, {
-	14400, 3, 1, 1, 0x64, 0x0}, {
-	15360, 4, 1, 1, 0x5D, 0xC00000}, {
-	16200, 5, 1, 1, 0x58, 0xE38E38}, {
-	16800, 6, 1, 1, 0x55, 0xB6DB6D}, {
-	19200, 7, 1, 1, 0x4B, 0}, {
-	19800, 8, 1, 1, 0x48, 0xBA2E8B}, {
-	20000, 9, 1, 1, 0x48, 0x0}, {
-	25000, 10, 1, 1, 0x39, 0x999999}, {
-	26000, 11, 1, 1, 0x37, 0x627627}, {
-	30000, 12, 1, 1, 0x30, 0x0}, {
-	37400, 13, 2, 1, 0x4D, 0x15E76}, {
-	38400, 13, 2, 1, 0x4B, 0x0}, {
-	40000, 14, 2, 1, 0x48, 0x0}, {
-	48000, 15, 2, 1, 0x3c, 0x0}, {
-	0, 0, 0, 0, 0, 0}
-};
+	case BCM4319_CHIP_ID:
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+		W_REG(&cc->pllcontrol_data, 0x11100070);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+		W_REG(&cc->pllcontrol_data, 0x1014140a);
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+		W_REG(&cc->pllcontrol_data, 0x88888854);
 
-/* table index */
-#define PMU1_XTALTAB0_1440_12000K	0
-#define PMU1_XTALTAB0_1440_13000K	1
-#define PMU1_XTALTAB0_1440_14400K	2
-#define PMU1_XTALTAB0_1440_15360K	3
-#define PMU1_XTALTAB0_1440_16200K	4
-#define PMU1_XTALTAB0_1440_16800K	5
-#define PMU1_XTALTAB0_1440_19200K	6
-#define PMU1_XTALTAB0_1440_19800K	7
-#define PMU1_XTALTAB0_1440_20000K	8
-#define PMU1_XTALTAB0_1440_25000K	9
-#define PMU1_XTALTAB0_1440_26000K	10
-#define PMU1_XTALTAB0_1440_30000K	11
-#define PMU1_XTALTAB0_1440_37400K	12
-#define PMU1_XTALTAB0_1440_38400K	13
-#define PMU1_XTALTAB0_1440_40000K	14
-#define PMU1_XTALTAB0_1440_48000K	15
+		if (spuravoid == 1) {	/* spur_avoid ON, enable 41/82/164Mhz clock mode */
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x05201828);
+		} else {	/* enable 40/80/160Mhz clock mode */
+			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+			W_REG(&cc->pllcontrol_data, 0x05001828);
+		}
+		break;
+	case BCM4336_CHIP_ID:
+		/* Looks like these are only for default xtal freq 26MHz */
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
+		W_REG(&cc->pllcontrol_data, 0x02100020);
 
-#define XTAL_FREQ_24000MHZ		24000
-#define XTAL_FREQ_30000MHZ		30000
-#define XTAL_FREQ_37400MHZ		37400
-#define XTAL_FREQ_48000MHZ		48000
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
+		W_REG(&cc->pllcontrol_data, 0x0C0C0C0C);
 
-static const pmu1_xtaltab0_t pmu1_xtaltab0_960[] = {
-	{
-	12000, 1, 1, 1, 0x50, 0x0}, {
-	13000, 2, 1, 1, 0x49, 0xD89D89}, {
-	14400, 3, 1, 1, 0x42, 0xAAAAAA}, {
-	15360, 4, 1, 1, 0x3E, 0x800000}, {
-	16200, 5, 1, 1, 0x39, 0x425ED0}, {
-	16800, 6, 1, 1, 0x39, 0x249249}, {
-	19200, 7, 1, 1, 0x32, 0x0}, {
-	19800, 8, 1, 1, 0x30, 0x7C1F07}, {
-	20000, 9, 1, 1, 0x30, 0x0}, {
-	25000, 10, 1, 1, 0x26, 0x666666}, {
-	26000, 11, 1, 1, 0x24, 0xEC4EC4}, {
-	30000, 12, 1, 1, 0x20, 0x0}, {
-	37400, 13, 2, 1, 0x33, 0x563EF9}, {
-	38400, 14, 2, 1, 0x32, 0x0}, {
-	40000, 15, 2, 1, 0x30, 0x0}, {
-	48000, 16, 2, 1, 0x28, 0x0}, {
-	0, 0, 0, 0, 0, 0}
-};
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
+		W_REG(&cc->pllcontrol_data, 0x01240C0C);
 
-/* table index */
-#define PMU1_XTALTAB0_960_12000K	0
-#define PMU1_XTALTAB0_960_13000K	1
-#define PMU1_XTALTAB0_960_14400K	2
-#define PMU1_XTALTAB0_960_15360K	3
-#define PMU1_XTALTAB0_960_16200K	4
-#define PMU1_XTALTAB0_960_16800K	5
-#define PMU1_XTALTAB0_960_19200K	6
-#define PMU1_XTALTAB0_960_19800K	7
-#define PMU1_XTALTAB0_960_20000K	8
-#define PMU1_XTALTAB0_960_25000K	9
-#define PMU1_XTALTAB0_960_26000K	10
-#define PMU1_XTALTAB0_960_30000K	11
-#define PMU1_XTALTAB0_960_37400K	12
-#define PMU1_XTALTAB0_960_38400K	13
-#define PMU1_XTALTAB0_960_40000K	14
-#define PMU1_XTALTAB0_960_48000K	15
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
+		W_REG(&cc->pllcontrol_data, 0x202C2820);
 
-/* select xtal table for each chip */
-static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(si_t *sih)
-{
-#ifdef BCMDBG
-	char chn[8];
-#endif
-	switch (sih->chip) {
-	case BCM4329_CHIP_ID:
-		return pmu1_xtaltab0_880_4329;
-	case BCM4319_CHIP_ID:
-		return pmu1_xtaltab0_1440;
-	case BCM4336_CHIP_ID:
-		return pmu1_xtaltab0_960;
-	case BCM4330_CHIP_ID:
-		if (CST4330_CHIPMODE_SDIOD(sih->chipst))
-			return pmu1_xtaltab0_960;
-		else
-			return pmu1_xtaltab0_1440;
-	default:
-		PMU_MSG(("si_pmu1_xtaltab0: Unknown chipid %s\n",
-			 bcm_chipname(sih->chip, chn, 8)));
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
+		W_REG(&cc->pllcontrol_data, 0x88888825);
+
+		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
+		if (spuravoid == 1) {
+			W_REG(&cc->pllcontrol_data, 0x00EC4EC4);
+		} else {
+			W_REG(&cc->pllcontrol_data, 0x00762762);
+		}
+
+		tmp = PCTL_PLL_PLLCTL_UPD;
 		break;
+
+	default:
+		/* bail out */
+		return;
 	}
-	return NULL;
+
+	tmp |= R_REG(&cc->pmucontrol);
+	W_REG(&cc->pmucontrol, tmp);
 }
 
 /* select default xtal frequency for each chip */
 static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(si_t *sih)
 {
-#ifdef BCMDBG
-	char chn[8];
-#endif
-
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
 		/* Default to 38400Khz */
@@ -1075,38 +885,30 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(si_t *sih)
 		else
 			return &pmu1_xtaltab0_1440[PMU1_XTALTAB0_1440_37400K];
 	default:
-		PMU_MSG(("si_pmu1_xtaldef0: Unknown chipid %s\n",
-			 bcm_chipname(sih->chip, chn, 8)));
 		break;
 	}
 	return NULL;
 }
 
-/* select default pll fvco for each chip */
-static u32 si_pmu1_pllfvco0(si_t *sih)
+/* select xtal table for each chip */
+static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(si_t *sih)
 {
-#ifdef BCMDBG
-	char chn[8];
-#endif
-
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
-		return FVCO_880;
+		return pmu1_xtaltab0_880_4329;
 	case BCM4319_CHIP_ID:
-		return FVCO_1440;
+		return pmu1_xtaltab0_1440;
 	case BCM4336_CHIP_ID:
-		return FVCO_960;
+		return pmu1_xtaltab0_960;
 	case BCM4330_CHIP_ID:
 		if (CST4330_CHIPMODE_SDIOD(sih->chipst))
-			return FVCO_960;
+			return pmu1_xtaltab0_960;
 		else
-			return FVCO_1440;
+			return pmu1_xtaltab0_1440;
 	default:
-		PMU_MSG(("si_pmu1_pllfvco0: Unknown chipid %s\n",
-			 bcm_chipname(sih->chip, chn, 8)));
 		break;
 	}
-	return 0;
+	return NULL;
 }
 
 /* query alp/xtal clock frequency */
@@ -1128,6 +930,55 @@ si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc)
 	return xt->fref * 1000;
 }
 
+/* select default pll fvco for each chip */
+static u32 si_pmu1_pllfvco0(si_t *sih)
+{
+	switch (sih->chip) {
+	case BCM4329_CHIP_ID:
+		return FVCO_880;
+	case BCM4319_CHIP_ID:
+		return FVCO_1440;
+	case BCM4336_CHIP_ID:
+		return FVCO_960;
+	case BCM4330_CHIP_ID:
+		if (CST4330_CHIPMODE_SDIOD(sih->chipst))
+			return FVCO_960;
+		else
+			return FVCO_1440;
+	default:
+		break;
+	}
+	return 0;
+}
+
+static void si_pmu_set_4330_plldivs(si_t *sih)
+{
+	u32 FVCO = si_pmu1_pllfvco0(sih) / 1000;
+	u32 m1div, m2div, m3div, m4div, m5div, m6div;
+	u32 pllc1, pllc2;
+
+	m2div = m3div = m4div = m6div = FVCO / 80;
+	m5div = FVCO / 160;
+
+	if (CST4330_CHIPMODE_SDIOD(sih->chipst))
+		m1div = FVCO / 80;
+	else
+		m1div = FVCO / 90;
+	pllc1 =
+	    (m1div << PMU1_PLL0_PC1_M1DIV_SHIFT) | (m2div <<
+						    PMU1_PLL0_PC1_M2DIV_SHIFT) |
+	    (m3div << PMU1_PLL0_PC1_M3DIV_SHIFT) | (m4div <<
+						    PMU1_PLL0_PC1_M4DIV_SHIFT);
+	si_pmu_pllcontrol(sih, PMU1_PLL0_PLLCTL1, ~0, pllc1);
+
+	pllc2 = si_pmu_pllcontrol(sih, PMU1_PLL0_PLLCTL1, 0, 0);
+	pllc2 &= ~(PMU1_PLL0_PC2_M5DIV_MASK | PMU1_PLL0_PC2_M6DIV_MASK);
+	pllc2 |=
+	    ((m5div << PMU1_PLL0_PC2_M5DIV_SHIFT) |
+	     (m6div << PMU1_PLL0_PC2_M6DIV_SHIFT));
+	si_pmu_pllcontrol(sih, PMU1_PLL0_PLLCTL2, ~0, pllc2);
+}
+
 /* Set up PLL registers in the PMU as per the crystal speed.
  * XtalFreq field in pmucontrol register being 0 indicates the PLL
  * is not programmed and the h/w default is assumed to work, in which
@@ -1143,7 +994,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 
 	/* Use h/w default PLL config */
 	if (xtal == 0) {
-		PMU_MSG(("Unspecified xtal frequency, skip PLL configuration\n"));
 		return;
 	}
 
@@ -1156,24 +1006,16 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 	 * we don't know how to program it.
 	 */
 	if (xt == NULL || xt->fref == 0) {
-		PMU_MSG(("Unsupported xtal frequency %d.%d MHz, skip PLL configuration\n", xtal / 1000, xtal % 1000));
 		return;
 	}
-	/*  for 4319 bootloader already programs the PLL but bootloader does not program the
-	   PLL4 and PLL5. So Skip this check for 4319
+	/* for 4319 bootloader already programs the PLL but bootloader does not
+	 * program the PLL4 and PLL5. So Skip this check for 4319
 	 */
 	if ((((R_REG(&cc->pmucontrol) & PCTL_XTALFREQ_MASK) >>
 	      PCTL_XTALFREQ_SHIFT) == xt->xf) &&
 	    !((sih->chip == BCM4319_CHIP_ID)
-	      || (sih->chip == BCM4330_CHIP_ID))) {
-		PMU_MSG(("PLL already programmed for %d.%d MHz\n",
-			 xt->fref / 1000, xt->fref % 1000));
+	      || (sih->chip == BCM4330_CHIP_ID)))
 		return;
-	}
-
-	PMU_MSG(("XTAL %d.%d MHz (%d)\n", xtal / 1000, xtal % 1000, xt->xf));
-	PMU_MSG(("Programming PLL for %d.%d MHz\n", xt->fref / 1000,
-		 xt->fref % 1000));
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1264,8 +1106,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		break;
 	}
 
-	PMU_MSG(("Done masking\n"));
-
 	/* Write p1div and p2div to pllcontrol[0] */
 	W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
 	tmp = R_REG(&cc->pllcontrol_data) &
@@ -1317,9 +1157,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 
 	/* Write clock driving strength to pllcontrol[5] */
 	if (buf_strength) {
-		PMU_MSG(("Adjusting PLL buffer drive strength: %x\n",
-			 buf_strength));
-
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
 		tmp =
 		    R_REG(&cc->pllcontrol_data) & ~PMU1_PLL0_PC5_CLK_DRV_MASK;
@@ -1327,8 +1164,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		W_REG(&cc->pllcontrol_data, tmp);
 	}
 
-	PMU_MSG(("Done pll\n"));
-
 	/* to operate the 4319 usb in 24MHz/48MHz; chipcontrol[2][84:83] needs
 	 * to be updated.
 	 */
@@ -1370,26 +1205,94 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 	W_REG(&cc->pmucontrol, tmp);
 }
 
-/* initialize PLL */
-void si_pmu_pll_init(si_t *sih, uint xtalfreq)
+u32 si_pmu_ilp_clock(si_t *sih)
+{
+	static u32 ilpcycles_per_sec = 0;
+
+	if (ISSIM_ENAB(sih))
+		return ILP_CLOCK;
+
+	if (ilpcycles_per_sec == 0) {
+		u32 start, end, delta;
+		u32 origidx = ai_coreidx(sih);
+		chipcregs_t *cc = si_setcoreidx(sih, SI_CC_IDX);
+		ASSERT(cc != NULL);
+		start = R_REG(&cc->pmutimer);
+		mdelay(ILP_CALC_DUR);
+		end = R_REG(&cc->pmutimer);
+		delta = end - start;
+		ilpcycles_per_sec = delta * (1000 / ILP_CALC_DUR);
+		si_setcoreidx(sih, origidx);
+	}
+
+	return ilpcycles_per_sec;
+}
+
+void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
+{
+	u8 sr_cntl_shift = 0, rc_shift = 0, shift = 0, mask = 0;
+	u8 addr = 0;
+
+	switch (sih->chip) {
+	case BCM4336_CHIP_ID:
+		switch (ldo) {
+		case SET_LDO_VOLTAGE_CLDO_PWM:
+			addr = 4;
+			rc_shift = 1;
+			mask = 0xf;
+			break;
+		case SET_LDO_VOLTAGE_CLDO_BURST:
+			addr = 4;
+			rc_shift = 5;
+			mask = 0xf;
+			break;
+		case SET_LDO_VOLTAGE_LNLDO1:
+			addr = 4;
+			rc_shift = 17;
+			mask = 0xf;
+			break;
+		default:
+			return;
+		}
+		break;
+	case BCM4330_CHIP_ID:
+		switch (ldo) {
+		case SET_LDO_VOLTAGE_CBUCK_PWM:
+			addr = 3;
+			rc_shift = 0;
+			mask = 0x1f;
+			break;
+		default:
+			return;
+		}
+		break;
+	default:
+		return;
+	}
+
+	shift = sr_cntl_shift + rc_shift;
+
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr),
+		   ~0, addr);
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_data),
+		   mask << shift, (voltage & mask) << shift);
+}
+
+u16 si_pmu_fast_pwrup_delay(si_t *sih)
 {
+	uint delay = PMU_MAX_TRANSITION_DLY;
 	chipcregs_t *cc;
 	uint origidx;
 #ifdef BCMDBG
 	char chn[8];
+	chn[0] = 0;		/* to suppress compile error */
 #endif
 
 	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
+	origidx = ai_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
-	case BCM4329_CHIP_ID:
-		if (xtalfreq == 0)
-			xtalfreq = 38400;
-		si_pmu1_pllinit0(sih, cc, xtalfreq);
-		break;
-	case BCM4313_CHIP_ID:
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 	case BCM43421_CHIP_ID:
@@ -1398,22 +1301,102 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 	case BCM43238_CHIP_ID:
 	case BCM4331_CHIP_ID:
 	case BCM6362_CHIP_ID:
-		/* ??? */
+	case BCM4313_CHIP_ID:
+		delay = ISSIM_ENAB(sih) ? 70 : 3700;
+		break;
+	case BCM4329_CHIP_ID:
+		if (ISSIM_ENAB(sih))
+			delay = 70;
+		else {
+			u32 ilp = si_ilp_clock(sih);
+			delay =
+			    (si_pmu_res_uptime(sih, cc, RES4329_HT_AVAIL) +
+			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
+							      1) / ilp);
+			delay = (11 * delay) / 10;
+		}
 		break;
 	case BCM4319_CHIP_ID:
+		delay = ISSIM_ENAB(sih) ? 70 : 3700;
+		break;
 	case BCM4336_CHIP_ID:
+		if (ISSIM_ENAB(sih))
+			delay = 70;
+		else {
+			u32 ilp = si_ilp_clock(sih);
+			delay =
+			    (si_pmu_res_uptime(sih, cc, RES4336_HT_AVAIL) +
+			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
+							      1) / ilp);
+			delay = (11 * delay) / 10;
+		}
+		break;
 	case BCM4330_CHIP_ID:
-		si_pmu1_pllinit0(sih, cc, xtalfreq);
+		if (ISSIM_ENAB(sih))
+			delay = 70;
+		else {
+			u32 ilp = si_ilp_clock(sih);
+			delay =
+			    (si_pmu_res_uptime(sih, cc, RES4330_HT_AVAIL) +
+			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
+							      1) / ilp);
+			delay = (11 * delay) / 10;
+		}
 		break;
 	default:
-		PMU_MSG(("No PLL init done for chip %s rev %d pmurev %d\n",
-			 bcm_chipname(sih->chip, chn, 8), sih->chiprev,
-			 sih->pmurev));
 		break;
 	}
+	/* Return to original core */
+	si_setcoreidx(sih, origidx);
+
+	return (u16) delay;
+}
+
+void si_pmu_sprom_enable(si_t *sih, bool enable)
+{
+	chipcregs_t *cc;
+	uint origidx;
+
+	/* Remember original core before switch to chipc */
+	origidx = ai_coreidx(sih);
+	cc = si_setcoreidx(sih, SI_CC_IDX);
+
+	/* Return to original core */
+	si_setcoreidx(sih, origidx);
+}
+
+/* Read/write a chipcontrol reg */
+u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val)
+{
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol_addr), ~0,
+		   reg);
+	return si_corereg(sih, SI_CC_IDX,
+			  offsetof(chipcregs_t, chipcontrol_data), mask, val);
+}
 
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+/* Read/write a regcontrol reg */
+u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val)
+{
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr), ~0,
+		   reg);
+	return si_corereg(sih, SI_CC_IDX,
+			  offsetof(chipcregs_t, regcontrol_data), mask, val);
+}
+
+/* Read/write a pllcontrol reg */
+u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val)
+{
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pllcontrol_addr), ~0,
+		   reg);
+	return si_corereg(sih, SI_CC_IDX,
+			  offsetof(chipcregs_t, pllcontrol_data), mask, val);
+}
+
+/* PMU PLL update */
+void si_pmu_pllupd(si_t *sih)
+{
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmucontrol),
+		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
 }
 
 /* query alp/xtal clock frequency */
@@ -1422,15 +1405,13 @@ u32 si_pmu_alp_clock(si_t *sih)
 	chipcregs_t *cc;
 	uint origidx;
 	u32 clock = ALP_CLOCK;
-#ifdef BCMDBG
-	char chn[8];
-#endif
+
 	/* bail out with default */
 	if (!PMUCTL_ENAB(sih))
 		return clock;
 
 	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
+	origidx = ai_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
@@ -1462,10 +1443,6 @@ u32 si_pmu_alp_clock(si_t *sih)
 		clock = 25000 * 1000;
 		break;
 	default:
-		PMU_MSG(("No ALP clock specified "
-			 "for chip %s rev %d pmurev %d, using default %d Hz\n",
-			 bcm_chipname(sih->chip, chn, 8), sih->chiprev,
-			 sih->pmurev, clock));
 		break;
 	}
 
@@ -1474,137 +1451,35 @@ u32 si_pmu_alp_clock(si_t *sih)
 	return clock;
 }
 
-/* Measure ILP clock frequency */
-#define ILP_CALC_DUR	10	/* ms, make sure 1000 can be divided by it. */
-
-static u32 ilpcycles_per_sec;
-
-u32 si_pmu_ilp_clock(si_t *sih)
+void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 {
-	if (ISSIM_ENAB(sih))
-		return ILP_CLOCK;
-
-	if (ilpcycles_per_sec == 0) {
-		u32 start, end, delta;
-		u32 origidx = si_coreidx(sih);
-		chipcregs_t *cc = si_setcoreidx(sih, SI_CC_IDX);
-		start = R_REG(&cc->pmutimer);
-		mdelay(ILP_CALC_DUR);
-		end = R_REG(&cc->pmutimer);
-		delta = end - start;
-		ilpcycles_per_sec = delta * (1000 / ILP_CALC_DUR);
-		si_setcoreidx(sih, origidx);
-	}
-
-	return ilpcycles_per_sec;
-}
-
-/* SDIO Pad drive strength to select value mappings */
-typedef struct {
-	u8 strength;		/* Pad Drive Strength in mA */
-	u8 sel;		/* Chip-specific select value */
-} sdiod_drive_str_t;
-
-/* SDIO Drive Strength to sel value table for PMU Rev 1 */
-static const sdiod_drive_str_t sdiod_drive_strength_tab1[] = {
-	{
-	4, 0x2}, {
-	2, 0x3}, {
-	1, 0x0}, {
-	0, 0x0}
-	};
-
-/* SDIO Drive Strength to sel value table for PMU Rev 2, 3 */
-static const sdiod_drive_str_t sdiod_drive_strength_tab2[] = {
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
-static const sdiod_drive_str_t sdiod_drive_strength_tab3[] = {
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
-#define SDIOD_DRVSTR_KEY(chip, pmu)	(((chip) << 16) | (pmu))
-
-void
-si_sdiod_drive_strength_init(si_t *sih, u32 drivestrength) {
 	chipcregs_t *cc;
-	uint origidx, intr_val = 0;
-	sdiod_drive_str_t *str_tab = NULL;
-	u32 str_mask = 0;
-	u32 str_shift = 0;
-#ifdef BCMDBG
-	char chn[8];
-#endif
-
-	if (!(sih->cccaps & CC_CAP_PMU)) {
-		return;
-	}
+	uint origidx, intr_val;
+	u32 tmp = 0;
 
 	/* Remember original core before switch to chipc */
 	cc = (chipcregs_t *) si_switch_core(sih, CC_CORE_ID, &origidx,
 					    &intr_val);
 
-	switch (SDIOD_DRVSTR_KEY(sih->chip, sih->pmurev)) {
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 1):
-		str_tab = (sdiod_drive_str_t *)&sdiod_drive_strength_tab1;
-		str_mask = 0x30000000;
-		str_shift = 28;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 2):
-	case SDIOD_DRVSTR_KEY(BCM4325_CHIP_ID, 3):
-		str_tab = (sdiod_drive_str_t *)&sdiod_drive_strength_tab2;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-	case SDIOD_DRVSTR_KEY(BCM4336_CHIP_ID, 8):
-		str_tab = (sdiod_drive_str_t *) &sdiod_drive_strength_tab3;
-		str_mask = 0x00003800;
-		str_shift = 11;
-		break;
-
-	default:
-		PMU_MSG(("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n", bcm_chipname(sih->chip, chn, 8), sih->chiprev, sih->pmurev));
-
-		break;
+	/* force the HT off  */
+	if (sih->chip == BCM4336_CHIP_ID) {
+		tmp = R_REG(&cc->max_res_mask);
+		tmp &= ~RES4336_HT_AVAIL;
+		W_REG(&cc->max_res_mask, tmp);
+		/* wait for the ht to really go away */
+		SPINWAIT(((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0),
+			 10000);
+		ASSERT((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0);
 	}
 
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
-		W_REG(&cc->chipcontrol_addr, 1);
-		cc_data_temp = R_REG(&cc->chipcontrol_data);
-		cc_data_temp &= ~str_mask;
-		drivestrength_sel <<= str_shift;
-		cc_data_temp |= drivestrength_sel;
-		W_REG(&cc->chipcontrol_data, cc_data_temp);
+	/* update the pll changes */
+	si_pmu_spuravoid_pllupdate(sih, cc, spuravoid);
 
-		PMU_MSG(("SDIO: %dmA drive strength selected, set to 0x%08x\n",
-			 drivestrength, cc_data_temp));
+	/* enable HT back on  */
+	if (sih->chip == BCM4336_CHIP_ID) {
+		tmp = R_REG(&cc->max_res_mask);
+		tmp |= RES4336_HT_AVAIL;
+		W_REG(&cc->max_res_mask, tmp);
 	}
 
 	/* Return to original core */
@@ -1618,7 +1493,7 @@ void si_pmu_init(si_t *sih)
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
+	origidx = ai_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	if (sih->pmurev == 1)
@@ -1639,357 +1514,307 @@ void si_pmu_init(si_t *sih)
 	si_setcoreidx(sih, origidx);
 }
 
-/* Return up time in ILP cycles for the given resource. */
-static uint
-si_pmu_res_uptime(si_t *sih, chipcregs_t *cc, u8 rsrc) {
-	u32 deps;
-	uint up, i, dup, dmax;
-	u32 min_mask = 0, max_mask = 0;
-
-	/* uptime of resource 'rsrc' */
-	W_REG(&cc->res_table_sel, rsrc);
-	up = (R_REG(&cc->res_updn_timer) >> 8) & 0xff;
-
-	/* direct dependancies of resource 'rsrc' */
-	deps = si_pmu_res_deps(sih, cc, PMURES_BIT(rsrc), false);
-	for (i = 0; i <= PMURES_MAX_RESNUM; i++) {
-		if (!(deps & PMURES_BIT(i)))
-			continue;
-		deps &= ~si_pmu_res_deps(sih, cc, PMURES_BIT(i), true);
-	}
-	si_pmu_res_masks(sih, &min_mask, &max_mask);
-	deps &= ~min_mask;
-
-	/* max uptime of direct dependancies */
-	dmax = 0;
-	for (i = 0; i <= PMURES_MAX_RESNUM; i++) {
-		if (!(deps & PMURES_BIT(i)))
-			continue;
-		dup = si_pmu_res_uptime(sih, cc, (u8) i);
-		if (dmax < dup)
-			dmax = dup;
-	}
-
-	PMU_MSG(("si_pmu_res_uptime: rsrc %u uptime %u(deps 0x%08x uptime %u)\n", rsrc, up, deps, dmax));
+/* initialize PMU chip controls and other chip level stuff */
+void si_pmu_chip_init(si_t *sih)
+{
+	uint origidx;
 
-	return up + dmax + PMURES_UP_TRANSITION;
-}
 
-/* Return dependancies (direct or all/indirect) for the given resources */
-static u32
-si_pmu_res_deps(si_t *sih, chipcregs_t *cc, u32 rsrcs,
-		bool all)
-{
-	u32 deps = 0;
-	u32 i;
+	/* Gate off SPROM clock and chip select signals */
+	si_pmu_sprom_enable(sih, false);
 
-	for (i = 0; i <= PMURES_MAX_RESNUM; i++) {
-		if (!(rsrcs & PMURES_BIT(i)))
-			continue;
-		W_REG(&cc->res_table_sel, i);
-		deps |= R_REG(&cc->res_dep_mask);
-	}
+	/* Remember original core */
+	origidx = ai_coreidx(sih);
 
-	return !all ? deps : (deps
-			      ? (deps |
-				 si_pmu_res_deps(sih, cc, deps,
-						 true)) : 0);
+	/* Return to original core */
+	si_setcoreidx(sih, origidx);
 }
 
-/* power up/down OTP through PMU resources */
-void si_pmu_otp_power(si_t *sih, bool on)
+/* initialize PMU switch/regulators */
+void si_pmu_swreg_init(si_t *sih)
 {
-	chipcregs_t *cc;
-	uint origidx;
-	u32 rsrcs = 0;	/* rsrcs to turn on/off OTP power */
-
-	/* Don't do anything if OTP is disabled */
-	if (si_is_otp_disabled(sih)) {
-		PMU_MSG(("si_pmu_otp_power: OTP is disabled\n"));
-		return;
-	}
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
-	case BCM4329_CHIP_ID:
-		rsrcs = PMURES_BIT(RES4329_OTP_PU);
-		break;
-	case BCM4319_CHIP_ID:
-		rsrcs = PMURES_BIT(RES4319_OTP_PU);
-		break;
 	case BCM4336_CHIP_ID:
-		rsrcs = PMURES_BIT(RES4336_OTP_PU);
+		/* Reduce CLDO PWM output voltage to 1.2V */
+		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_CLDO_PWM, 0xe);
+		/* Reduce CLDO BURST output voltage to 1.2V */
+		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_CLDO_BURST,
+				       0xe);
+		/* Reduce LNLDO1 output voltage to 1.2V */
+		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_LNLDO1, 0xe);
+		if (sih->chiprev == 0)
+			si_pmu_regcontrol(sih, 2, 0x400000, 0x400000);
 		break;
+
 	case BCM4330_CHIP_ID:
-		rsrcs = PMURES_BIT(RES4330_OTP_PU);
+		/* CBUCK Voltage is 1.8 by default and set that to 1.5 */
+		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_CBUCK_PWM, 0);
 		break;
 	default:
 		break;
 	}
-
-	if (rsrcs != 0) {
-		u32 otps;
-
-		/* Figure out the dependancies (exclude min_res_mask) */
-		u32 deps = si_pmu_res_deps(sih, cc, rsrcs, true);
-		u32 min_mask = 0, max_mask = 0;
-		si_pmu_res_masks(sih, &min_mask, &max_mask);
-		deps &= ~min_mask;
-		/* Turn on/off the power */
-		if (on) {
-			PMU_MSG(("Adding rsrc 0x%x to min_res_mask\n",
-				 rsrcs | deps));
-			OR_REG(&cc->min_res_mask, (rsrcs | deps));
-			SPINWAIT(!(R_REG(&cc->res_state) & rsrcs),
-				 PMU_MAX_TRANSITION_DLY);
-		} else {
-			PMU_MSG(("Removing rsrc 0x%x from min_res_mask\n",
-				 rsrcs | deps));
-			AND_REG(&cc->min_res_mask, ~(rsrcs | deps));
-		}
-
-		SPINWAIT((((otps = R_REG(&cc->otpstatus)) & OTPS_READY) !=
-			  (on ? OTPS_READY : 0)), 100);
-		if ((otps & OTPS_READY) != (on ? OTPS_READY : 0))
-			PMU_MSG(("OTP ready bit not %s after wait\n",
-				 (on ? "ON" : "OFF")));
-	}
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-}
-
-void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
-{
-	chipcregs_t *cc;
-	uint origidx, intr_val;
-	u32 tmp = 0;
-
-	/* Remember original core before switch to chipc */
-	cc = (chipcregs_t *) si_switch_core(sih, CC_CORE_ID, &origidx,
-					    &intr_val);
-
-	/* force the HT off  */
-	if (sih->chip == BCM4336_CHIP_ID) {
-		tmp = R_REG(&cc->max_res_mask);
-		tmp &= ~RES4336_HT_AVAIL;
-		W_REG(&cc->max_res_mask, tmp);
-		/* wait for the ht to really go away */
-		SPINWAIT(((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0),
-			 10000);
-	}
-
-	/* update the pll changes */
-	si_pmu_spuravoid_pllupdate(sih, cc, spuravoid);
-
-	/* enable HT back on  */
-	if (sih->chip == BCM4336_CHIP_ID) {
-		tmp = R_REG(&cc->max_res_mask);
-		tmp |= RES4336_HT_AVAIL;
-		W_REG(&cc->max_res_mask, tmp);
-	}
-
-	/* Return to original core */
-	si_restore_core(sih, origidx, intr_val);
 }
 
-static void
-si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
-{
-	u32 tmp = 0;
-	u8 phypll_offset = 0;
-	u8 bcm5357_bcm43236_p1div[] = { 0x1, 0x5, 0x5 };
-	u8 bcm5357_bcm43236_ndiv[] = { 0x30, 0xf6, 0xfc };
+/* initialize PLL */
+void si_pmu_pll_init(si_t *sih, uint xtalfreq)
+{
+	chipcregs_t *cc;
+	uint origidx;
+
+
+	/* Remember original core before switch to chipc */
+	origidx = ai_coreidx(sih);
+	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
-	case BCM5357_CHIP_ID:
+	case BCM4329_CHIP_ID:
+		if (xtalfreq == 0)
+			xtalfreq = 38400;
+		si_pmu1_pllinit0(sih, cc, xtalfreq);
+		break;
+	case BCM4313_CHIP_ID:
+	case BCM43224_CHIP_ID:
+	case BCM43225_CHIP_ID:
+	case BCM43421_CHIP_ID:
 	case BCM43235_CHIP_ID:
 	case BCM43236_CHIP_ID:
 	case BCM43238_CHIP_ID:
+	case BCM4331_CHIP_ID:
+	case BCM6362_CHIP_ID:
+		/* ??? */
+		break;
+	case BCM4319_CHIP_ID:
+	case BCM4336_CHIP_ID:
+	case BCM4330_CHIP_ID:
+		si_pmu1_pllinit0(sih, cc, xtalfreq);
+		break;
+	default:
+		break;
+	}
 
-		/* BCM5357 needs to touch PLL1_PLLCTL[02], so offset PLL0_PLLCTL[02] by 6 */
-		phypll_offset = (sih->chip == BCM5357_CHIP_ID) ? 6 : 0;
+	/* Return to original core */
+	si_setcoreidx(sih, origidx);
+}
 
-		/* RMW only the P1 divider */
-		W_REG(&cc->pllcontrol_addr,
-		      PMU1_PLL0_PLLCTL0 + phypll_offset);
-		tmp = R_REG(&cc->pllcontrol_data);
-		tmp &= (~(PMU1_PLL0_PC0_P1DIV_MASK));
-		tmp |=
-		    (bcm5357_bcm43236_p1div[spuravoid] <<
-		     PMU1_PLL0_PC0_P1DIV_SHIFT);
-		W_REG(&cc->pllcontrol_data, tmp);
+/* initialize PMU resources */
+void si_pmu_res_init(si_t *sih)
+{
+	chipcregs_t *cc;
+	uint origidx;
+	const pmu_res_updown_t *pmu_res_updown_table = NULL;
+	uint pmu_res_updown_table_sz = 0;
+	const pmu_res_depend_t *pmu_res_depend_table = NULL;
+	uint pmu_res_depend_table_sz = 0;
+	u32 min_mask = 0, max_mask = 0;
+	char name[8], *val;
+	uint i, rsrcs;
 
-		/* RMW only the int feedback divider */
-		W_REG(&cc->pllcontrol_addr,
-		      PMU1_PLL0_PLLCTL2 + phypll_offset);
-		tmp = R_REG(&cc->pllcontrol_data);
-		tmp &= ~(PMU1_PLL0_PC2_NDIV_INT_MASK);
-		tmp |=
-		    (bcm5357_bcm43236_ndiv[spuravoid]) <<
-		    PMU1_PLL0_PC2_NDIV_INT_SHIFT;
-		W_REG(&cc->pllcontrol_data, tmp);
+	/* Remember original core before switch to chipc */
+	origidx = ai_coreidx(sih);
+	cc = si_setcoreidx(sih, SI_CC_IDX);
 
-		tmp = 1 << 10;
+	switch (sih->chip) {
+	case BCM4329_CHIP_ID:
+		/* Optimize resources up/down timers */
+		if (ISSIM_ENAB(sih)) {
+			pmu_res_updown_table = NULL;
+			pmu_res_updown_table_sz = 0;
+		} else {
+			pmu_res_updown_table = bcm4329_res_updown;
+			pmu_res_updown_table_sz = ARRAY_SIZE(bcm4329_res_updown);
+		}
+		/* Optimize resources dependencies */
+		pmu_res_depend_table = bcm4329_res_depend;
+		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4329_res_depend);
 		break;
 
-	case BCM4331_CHIP_ID:
-		if (spuravoid == 2) {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11500014);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x0FC00a08);
-		} else if (spuravoid == 1) {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11500014);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x0F600a08);
+	case BCM4319_CHIP_ID:
+		/* Optimize resources up/down timers */
+		if (ISSIM_ENAB(sih)) {
+			pmu_res_updown_table = bcm4319a0_res_updown_qt;
+			pmu_res_updown_table_sz =
+			    ARRAY_SIZE(bcm4319a0_res_updown_qt);
 		} else {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11100014);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x03000a08);
+			pmu_res_updown_table = bcm4319a0_res_updown;
+			pmu_res_updown_table_sz =
+			    ARRAY_SIZE(bcm4319a0_res_updown);
 		}
-		tmp = 1 << 10;
+		/* Optimize resources dependancies masks */
+		pmu_res_depend_table = bcm4319a0_res_depend;
+		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4319a0_res_depend);
 		break;
 
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-	case BCM43421_CHIP_ID:
-	case BCM6362_CHIP_ID:
-		if (spuravoid == 1) {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11500010);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-			W_REG(&cc->pllcontrol_data, 0x000C0C06);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x0F600a08);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-			W_REG(&cc->pllcontrol_data, 0x00000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-			W_REG(&cc->pllcontrol_data, 0x2001E920);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-			W_REG(&cc->pllcontrol_data, 0x88888815);
+	case BCM4336_CHIP_ID:
+		/* Optimize resources up/down timers */
+		if (ISSIM_ENAB(sih)) {
+			pmu_res_updown_table = bcm4336a0_res_updown_qt;
+			pmu_res_updown_table_sz =
+			    ARRAY_SIZE(bcm4336a0_res_updown_qt);
 		} else {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11100010);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-			W_REG(&cc->pllcontrol_data, 0x000c0c06);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x03000a08);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-			W_REG(&cc->pllcontrol_data, 0x00000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-			W_REG(&cc->pllcontrol_data, 0x200005c0);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-			W_REG(&cc->pllcontrol_data, 0x88888815);
+			pmu_res_updown_table = bcm4336a0_res_updown;
+			pmu_res_updown_table_sz =
+			    ARRAY_SIZE(bcm4336a0_res_updown);
 		}
-		tmp = 1 << 10;
+		/* Optimize resources dependancies masks */
+		pmu_res_depend_table = bcm4336a0_res_depend;
+		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4336a0_res_depend);
 		break;
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-		W_REG(&cc->pllcontrol_data, 0x11100008);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-		W_REG(&cc->pllcontrol_data, 0x0c000c06);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-		W_REG(&cc->pllcontrol_data, 0x03000a08);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-		W_REG(&cc->pllcontrol_data, 0x00000000);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-		W_REG(&cc->pllcontrol_data, 0x200005c0);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-		W_REG(&cc->pllcontrol_data, 0x88888855);
+	case BCM4330_CHIP_ID:
+		/* Optimize resources up/down timers */
+		if (ISSIM_ENAB(sih)) {
+			pmu_res_updown_table = bcm4330a0_res_updown_qt;
+			pmu_res_updown_table_sz =
+			    ARRAY_SIZE(bcm4330a0_res_updown_qt);
+		} else {
+			pmu_res_updown_table = bcm4330a0_res_updown;
+			pmu_res_updown_table_sz =
+			    ARRAY_SIZE(bcm4330a0_res_updown);
+		}
+		/* Optimize resources dependancies masks */
+		pmu_res_depend_table = bcm4330a0_res_depend;
+		pmu_res_depend_table_sz = ARRAY_SIZE(bcm4330a0_res_depend);
+		break;
+
+	default:
+		break;
+	}
+
+	/* # resources */
+	rsrcs = (sih->pmucaps & PCAP_RC_MASK) >> PCAP_RC_SHIFT;
+
+	/* Program up/down timers */
+	while (pmu_res_updown_table_sz--) {
+		W_REG(&cc->res_table_sel,
+		      pmu_res_updown_table[pmu_res_updown_table_sz].resnum);
+		W_REG(&cc->res_updn_timer,
+		      pmu_res_updown_table[pmu_res_updown_table_sz].updown);
+	}
+	/* Apply nvram overrides to up/down timers */
+	for (i = 0; i < rsrcs; i++) {
+		snprintf(name, sizeof(name), "r%dt", i);
+		val = getvar(NULL, name);
+		if (val == NULL)
+			continue;
+		W_REG(&cc->res_table_sel, (u32) i);
+		W_REG(&cc->res_updn_timer,
+		      (u32) simple_strtoul(val, NULL, 0));
+	}
+
+	/* Program resource dependencies table */
+	while (pmu_res_depend_table_sz--) {
+		if (pmu_res_depend_table[pmu_res_depend_table_sz].filter != NULL
+		    && !(pmu_res_depend_table[pmu_res_depend_table_sz].
+			 filter) (sih))
+			continue;
+		for (i = 0; i < rsrcs; i++) {
+			if ((pmu_res_depend_table[pmu_res_depend_table_sz].
+			     res_mask & PMURES_BIT(i)) == 0)
+				continue;
+			W_REG(&cc->res_table_sel, i);
+			switch (pmu_res_depend_table[pmu_res_depend_table_sz].
+				action) {
+			case RES_DEPEND_SET:
+				W_REG(&cc->res_dep_mask,
+				      pmu_res_depend_table
+				      [pmu_res_depend_table_sz].depend_mask);
+				break;
+			case RES_DEPEND_ADD:
+				OR_REG(&cc->res_dep_mask,
+				       pmu_res_depend_table
+				       [pmu_res_depend_table_sz].depend_mask);
+				break;
+			case RES_DEPEND_REMOVE:
+				AND_REG(&cc->res_dep_mask,
+					~pmu_res_depend_table
+					[pmu_res_depend_table_sz].depend_mask);
+				break;
+			default:
+				ASSERT(0);
+				break;
+			}
+		}
+	}
+	/* Apply nvram overrides to dependancies masks */
+	for (i = 0; i < rsrcs; i++) {
+		snprintf(name, sizeof(name), "r%dd", i);
+		val = getvar(NULL, name);
+		if (val == NULL)
+			continue;
+		W_REG(&cc->res_table_sel, (u32) i);
+		W_REG(&cc->res_dep_mask,
+		      (u32) simple_strtoul(val, NULL, 0));
+	}
+
+	/* Determine min/max rsrc masks */
+	si_pmu_res_masks(sih, &min_mask, &max_mask);
+
+	/* It is required to program max_mask first and then min_mask */
+
+	/* Program max resource mask */
+
+	if (max_mask) {
+		W_REG(&cc->max_res_mask, max_mask);
+	}
 
-		tmp = 1 << 10;
-		break;
+	/* Program min resource mask */
 
-	case BCM4716_CHIP_ID:
-	case BCM4748_CHIP_ID:
-	case BCM47162_CHIP_ID:
-		if (spuravoid == 1) {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11500060);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-			W_REG(&cc->pllcontrol_data, 0x080C0C06);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x0F600000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-			W_REG(&cc->pllcontrol_data, 0x00000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-			W_REG(&cc->pllcontrol_data, 0x2001E924);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-			W_REG(&cc->pllcontrol_data, 0x88888815);
-		} else {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11100060);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-			W_REG(&cc->pllcontrol_data, 0x080c0c06);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x03000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-			W_REG(&cc->pllcontrol_data, 0x00000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-			W_REG(&cc->pllcontrol_data, 0x200005c0);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-			W_REG(&cc->pllcontrol_data, 0x88888815);
-		}
+	if (min_mask) {
+		W_REG(&cc->min_res_mask, min_mask);
+	}
 
-		tmp = 3 << 9;
-		break;
+	/* Add some delay; allow resources to come up and settle. */
+	mdelay(2);
 
-	case BCM4319_CHIP_ID:
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-		W_REG(&cc->pllcontrol_data, 0x11100070);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-		W_REG(&cc->pllcontrol_data, 0x1014140a);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-		W_REG(&cc->pllcontrol_data, 0x88888854);
+	/* Return to original core */
+	si_setcoreidx(sih, origidx);
+}
 
-		if (spuravoid == 1) {	/* spur_avoid ON, enable 41/82/164Mhz clock mode */
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x05201828);
-		} else {	/* enable 40/80/160Mhz clock mode */
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x05001828);
-		}
-		break;
-	case BCM4336_CHIP_ID:
-		/* Looks like these are only for default xtal freq 26MHz */
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-		W_REG(&cc->pllcontrol_data, 0x02100020);
+u32 si_pmu_measure_alpclk(si_t *sih)
+{
+	chipcregs_t *cc;
+	uint origidx;
+	u32 alp_khz;
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-		W_REG(&cc->pllcontrol_data, 0x0C0C0C0C);
+	if (sih->pmurev < 10)
+		return 0;
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-		W_REG(&cc->pllcontrol_data, 0x01240C0C);
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-		W_REG(&cc->pllcontrol_data, 0x202C2820);
+	/* Remember original core before switch to chipc */
+	origidx = ai_coreidx(sih);
+	cc = si_setcoreidx(sih, SI_CC_IDX);
+	ASSERT(cc != NULL);
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-		W_REG(&cc->pllcontrol_data, 0x88888825);
+	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
+		u32 ilp_ctr, alp_hz;
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-		if (spuravoid == 1) {
-			W_REG(&cc->pllcontrol_data, 0x00EC4EC4);
-		} else {
-			W_REG(&cc->pllcontrol_data, 0x00762762);
-		}
+		/* Enable the reg to measure the freq, in case disabled before */
+		W_REG(&cc->pmu_xtalfreq,
+		      1U << PMU_XTALFREQ_REG_MEASURE_SHIFT);
 
-		tmp = PCTL_PLL_PLLCTL_UPD;
-		break;
+		/* Delay for well over 4 ILP clocks */
+		udelay(1000);
 
-	default:
-		PMU_ERROR(("%s: unknown spuravoidance settings for chip %s, not changing PLL\n", __func__, bcm_chipname(sih->chip, chn, 8)));
-		break;
-	}
+		/* Read the latched number of ALP ticks per 4 ILP ticks */
+		ilp_ctr =
+		    R_REG(&cc->pmu_xtalfreq) & PMU_XTALFREQ_REG_ILPCTR_MASK;
 
-	tmp |= R_REG(&cc->pmucontrol);
-	W_REG(&cc->pmucontrol, tmp);
+		/* Turn off the PMU_XTALFREQ_REG_MEASURE_SHIFT bit to save power */
+		W_REG(&cc->pmu_xtalfreq, 0);
+
+		/* Calculate ALP frequency */
+		alp_hz = (ilp_ctr * EXT_ILP_HZ) / 4;
+
+		/* Round to nearest 100KHz, and at the same time convert to KHz */
+		alp_khz = (alp_hz + 50000) / 100000 * 100;
+	} else
+		alp_khz = 0;
+
+	/* Return to original core */
+	si_setcoreidx(sih, origidx);
+
+	return alp_khz;
 }
 
 bool si_pmu_is_otp_powered(si_t *sih)
@@ -1999,7 +1824,7 @@ bool si_pmu_is_otp_powered(si_t *sih)
 	bool st;
 
 	/* Remember original core before switch to chipc */
-	idx = si_coreidx(sih);
+	idx = ai_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
@@ -2041,134 +1866,60 @@ bool si_pmu_is_otp_powered(si_t *sih)
 	return st;
 }
 
-void si_pmu_sprom_enable(si_t *sih, bool enable)
+/* power up/down OTP through PMU resources */
+void si_pmu_otp_power(si_t *sih, bool on)
 {
 	chipcregs_t *cc;
 	uint origidx;
+	u32 rsrcs = 0;	/* rsrcs to turn on/off OTP power */
+
+	/* Don't do anything if OTP is disabled */
+	if (si_is_otp_disabled(sih)) {
+		return;
+	}
 
 	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
+	origidx = ai_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
 
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-}
-
-/* initialize PMU chip controls and other chip level stuff */
-void si_pmu_chip_init(si_t *sih)
-{
-	uint origidx;
-
-	/* Gate off SPROM clock and chip select signals */
-	si_pmu_sprom_enable(sih, false);
-
-	/* Remember original core */
-	origidx = si_coreidx(sih);
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-}
-
-/* initialize PMU switch/regulators */
-void si_pmu_swreg_init(si_t *sih)
-{
 	switch (sih->chip) {
+	case BCM4329_CHIP_ID:
+		rsrcs = PMURES_BIT(RES4329_OTP_PU);
+		break;
+	case BCM4319_CHIP_ID:
+		rsrcs = PMURES_BIT(RES4319_OTP_PU);
+		break;
 	case BCM4336_CHIP_ID:
-		/* Reduce CLDO PWM output voltage to 1.2V */
-		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_CLDO_PWM, 0xe);
-		/* Reduce CLDO BURST output voltage to 1.2V */
-		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_CLDO_BURST,
-				       0xe);
-		/* Reduce LNLDO1 output voltage to 1.2V */
-		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_LNLDO1, 0xe);
-		if (sih->chiprev == 0)
-			si_pmu_regcontrol(sih, 2, 0x400000, 0x400000);
+		rsrcs = PMURES_BIT(RES4336_OTP_PU);
 		break;
-
 	case BCM4330_CHIP_ID:
-		/* CBUCK Voltage is 1.8 by default and set that to 1.5 */
-		si_pmu_set_ldo_voltage(sih, SET_LDO_VOLTAGE_CBUCK_PWM, 0);
+		rsrcs = PMURES_BIT(RES4330_OTP_PU);
 		break;
 	default:
 		break;
 	}
-}
-
-/*
- * Measures the ALP clock frequency in KHz.  Returns 0 if not possible.
- * Possible only if PMU rev >= 10 and there is an external LPO 32768Hz crystal.
- */
-
-#define EXT_ILP_HZ 32768
-
-u32 si_pmu_measure_alpclk(si_t *sih)
-{
-	chipcregs_t *cc;
-	uint origidx;
-	u32 alp_khz;
-
-	if (sih->pmurev < 10)
-		return 0;
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
-		u32 ilp_ctr, alp_hz;
-
-		/* Enable the reg to measure the freq, in case disabled before */
-		W_REG(&cc->pmu_xtalfreq,
-		      1U << PMU_XTALFREQ_REG_MEASURE_SHIFT);
-
-		/* Delay for well over 4 ILP clocks */
-		udelay(1000);
-
-		/* Read the latched number of ALP ticks per 4 ILP ticks */
-		ilp_ctr =
-		    R_REG(&cc->pmu_xtalfreq) & PMU_XTALFREQ_REG_ILPCTR_MASK;
 
-		/* Turn off the PMU_XTALFREQ_REG_MEASURE_SHIFT bit to save power */
-		W_REG(&cc->pmu_xtalfreq, 0);
+	if (rsrcs != 0) {
+		u32 otps;
 
-		/* Calculate ALP frequency */
-		alp_hz = (ilp_ctr * EXT_ILP_HZ) / 4;
+		/* Figure out the dependancies (exclude min_res_mask) */
+		u32 deps = si_pmu_res_deps(sih, cc, rsrcs, true);
+		u32 min_mask = 0, max_mask = 0;
+		si_pmu_res_masks(sih, &min_mask, &max_mask);
+		deps &= ~min_mask;
+		/* Turn on/off the power */
+		if (on) {
+			OR_REG(&cc->min_res_mask, (rsrcs | deps));
+			SPINWAIT(!(R_REG(&cc->res_state) & rsrcs),
+				 PMU_MAX_TRANSITION_DLY);
+		} else {
+			AND_REG(&cc->min_res_mask, ~(rsrcs | deps));
+		}
 
-		/* Round to nearest 100KHz, and at the same time convert to KHz */
-		alp_khz = (alp_hz + 50000) / 100000 * 100;
-	} else
-		alp_khz = 0;
+		SPINWAIT((((otps = R_REG(&cc->otpstatus)) & OTPS_READY) !=
+			  (on ? OTPS_READY : 0)), 100);
+	}
 
 	/* Return to original core */
 	si_setcoreidx(sih, origidx);
-
-	return alp_khz;
-}
-
-static void si_pmu_set_4330_plldivs(si_t *sih)
-{
-	u32 FVCO = si_pmu1_pllfvco0(sih) / 1000;
-	u32 m1div, m2div, m3div, m4div, m5div, m6div;
-	u32 pllc1, pllc2;
-
-	m2div = m3div = m4div = m6div = FVCO / 80;
-	m5div = FVCO / 160;
-
-	if (CST4330_CHIPMODE_SDIOD(sih->chipst))
-		m1div = FVCO / 80;
-	else
-		m1div = FVCO / 90;
-	pllc1 =
-	    (m1div << PMU1_PLL0_PC1_M1DIV_SHIFT) | (m2div <<
-						    PMU1_PLL0_PC1_M2DIV_SHIFT) |
-	    (m3div << PMU1_PLL0_PC1_M3DIV_SHIFT) | (m4div <<
-						    PMU1_PLL0_PC1_M4DIV_SHIFT);
-	si_pmu_pllcontrol(sih, PMU1_PLL0_PLLCTL1, ~0, pllc1);
-
-	pllc2 = si_pmu_pllcontrol(sih, PMU1_PLL0_PLLCTL1, 0, 0);
-	pllc2 &= ~(PMU1_PLL0_PC2_M5DIV_MASK | PMU1_PLL0_PC2_M6DIV_MASK);
-	pllc2 |=
-	    ((m5div << PMU1_PLL0_PC2_M5DIV_SHIFT) |
-	     (m6div << PMU1_PLL0_PC2_M6DIV_SHIFT));
-	si_pmu_pllcontrol(sih, PMU1_PLL0_PLLCTL2, ~0, pllc2);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
index 56a7311..bd5b809b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
@@ -14,9 +14,17 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#ifndef _hndpmu_h_
-#define _hndpmu_h_
 
+#ifndef WLC_PMU_H_
+#define WLC_PMU_H_
+
+#include <linux/types.h>
+
+#include <aiutils.h>
+
+/*
+ * LDO selections used in si_pmu_set_ldo_voltage
+ */
 #define SET_LDO_VOLTAGE_LDO1	1
 #define SET_LDO_VOLTAGE_LDO2	2
 #define SET_LDO_VOLTAGE_LDO3	3
@@ -28,25 +36,23 @@
 #define SET_LDO_VOLTAGE_LNLDO1	9
 #define SET_LDO_VOLTAGE_LNLDO2_SEL	10
 
+extern void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage);
+extern u16 si_pmu_fast_pwrup_delay(si_t *sih);
+extern void si_pmu_sprom_enable(si_t *sih, bool enable);
+extern u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val);
+extern u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val);
+extern u32 si_pmu_ilp_clock(si_t *sih);
+extern u32 si_pmu_alp_clock(si_t *sih);
+extern void si_pmu_pllupd(si_t *sih);
+extern void si_pmu_spuravoid(si_t *sih, u8 spuravoid);
+extern u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val);
 extern void si_pmu_init(si_t *sih);
 extern void si_pmu_chip_init(si_t *sih);
 extern void si_pmu_pll_init(si_t *sih, u32 xtalfreq);
 extern void si_pmu_res_init(si_t *sih);
 extern void si_pmu_swreg_init(si_t *sih);
-extern u32 si_pmu_alp_clock(si_t *sih);
-extern void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage);
-extern u16 si_pmu_fast_pwrup_delay(si_t *sih);
-extern void si_pmu_pllupd(si_t *sih);
-extern void si_pmu_spuravoid(si_t *sih, u8 spuravoid);
-extern bool si_pmu_is_otp_powered(si_t *sih);
 extern u32 si_pmu_measure_alpclk(si_t *sih);
-extern u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val);
-extern void si_pmu_sprom_enable(si_t *sih, bool enable);
+extern bool si_pmu_is_otp_powered(si_t *sih);
 extern void si_pmu_otp_power(si_t *sih, bool on);
 
-extern void si_sdiod_drive_strength_init(si_t *sih, u32 drivestrength);
-extern u32 si_pmu_ilp_clock(si_t *sih);
-
-#endif				/* _hndpmu_h_ */
+#endif /* WLC_PMU_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 50a9fb5..87a2f62 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -19,7 +19,7 @@
 #include <proto/802.11.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <wlioctl.h>
 #include <sbhnddma.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 6eff7ef..bbf8442 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -21,7 +21,7 @@
 
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <wlioctl.h>
 #include <bcmwifi.h>
 #include <sbhnddma.h>
diff --git a/drivers/staging/brcm80211/include/aiutils.h b/drivers/staging/brcm80211/include/aiutils.h
new file mode 100644
index 0000000..3b7235c
--- /dev/null
+++ b/drivers/staging/brcm80211/include/aiutils.h
@@ -0,0 +1,565 @@
+/*
+ * Copyright (c) 2011 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef	_aiutils_h_
+#define	_aiutils_h_
+
+/* cpp contortions to concatenate w/arg prescan */
+#ifndef PAD
+#define	_PADLINE(line)	pad ## line
+#define	_XSTR(line)	_PADLINE(line)
+#define	PAD		_XSTR(__LINE__)
+#endif
+
+/* Include the soci specific files */
+#include <aidmp.h>
+
+/*
+ * SOC Interconnect Address Map.
+ * All regions may not exist on all chips.
+ */
+/* Physical SDRAM */
+#define SI_SDRAM_BASE		0x00000000
+/* Host Mode sb2pcitranslation0 (64 MB) */
+#define SI_PCI_MEM		0x08000000
+#define SI_PCI_MEM_SZ		(64 * 1024 * 1024)
+/* Host Mode sb2pcitranslation1 (64 MB) */
+#define SI_PCI_CFG		0x0c000000
+/* Byteswapped Physical SDRAM */
+#define	SI_SDRAM_SWAPPED	0x10000000
+/* Region 2 for sdram (512 MB) */
+#define SI_SDRAM_R2		0x80000000
+
+#ifdef SI_ENUM_BASE_VARIABLE
+#define SI_ENUM_BASE		(sii->pub.si_enum_base)
+#else
+#define SI_ENUM_BASE		0x18000000	/* Enumeration space base */
+#endif				/* SI_ENUM_BASE_VARIABLE */
+
+/* Wrapper space base */
+#define SI_WRAP_BASE		0x18100000
+/* each core gets 4Kbytes for registers */
+#define SI_CORE_SIZE		0x1000
+/*
+ * Max cores (this is arbitrary, for software
+ * convenience and could be changed if we
+ * make any larger chips
+ */
+#define	SI_MAXCORES		16
+
+/* On-chip RAM on chips that also have DDR */
+#define	SI_FASTRAM		0x19000000
+#define	SI_FASTRAM_SWAPPED	0x19800000
+
+/* Flash Region 2 (region 1 shadowed here) */
+#define	SI_FLASH2		0x1c000000
+/* Size of Flash Region 2 */
+#define	SI_FLASH2_SZ		0x02000000
+/* ARM Cortex-M3 ROM */
+#define	SI_ARMCM3_ROM		0x1e000000
+/* MIPS Flash Region 1 */
+#define	SI_FLASH1		0x1fc00000
+/* MIPS Size of Flash Region 1 */
+#define	SI_FLASH1_SZ		0x00400000
+/* ARM7TDMI-S ROM */
+#define	SI_ARM7S_ROM		0x20000000
+/* ARM Cortex-M3 SRAM Region 2 */
+#define	SI_ARMCM3_SRAM2		0x60000000
+/* ARM7TDMI-S SRAM Region 2 */
+#define	SI_ARM7S_SRAM2		0x80000000
+/* ARM Flash Region 1 */
+#define	SI_ARM_FLASH1		0xffff0000
+/* ARM Size of Flash Region 1 */
+#define	SI_ARM_FLASH1_SZ	0x00010000
+
+/* Client Mode sb2pcitranslation2 (1 GB) */
+#define SI_PCI_DMA		0x40000000
+/* Client Mode sb2pcitranslation2 (1 GB) */
+#define SI_PCI_DMA2		0x80000000
+/* Client Mode sb2pcitranslation2 size in bytes */
+#define SI_PCI_DMA_SZ		0x40000000
+/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
+#define SI_PCIE_DMA_L32		0x00000000
+/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
+#define SI_PCIE_DMA_H32		0x80000000
+
+/* core codes */
+#define	NODEV_CORE_ID		0x700	/* Invalid coreid */
+#define	CC_CORE_ID		0x800	/* chipcommon core */
+#define	ILINE20_CORE_ID		0x801	/* iline20 core */
+#define	SRAM_CORE_ID		0x802	/* sram core */
+#define	SDRAM_CORE_ID		0x803	/* sdram core */
+#define	PCI_CORE_ID		0x804	/* pci core */
+#define	MIPS_CORE_ID		0x805	/* mips core */
+#define	ENET_CORE_ID		0x806	/* enet mac core */
+#define	CODEC_CORE_ID		0x807	/* v90 codec core */
+#define	USB_CORE_ID		0x808	/* usb 1.1 host/device core */
+#define	ADSL_CORE_ID		0x809	/* ADSL core */
+#define	ILINE100_CORE_ID	0x80a	/* iline100 core */
+#define	IPSEC_CORE_ID		0x80b	/* ipsec core */
+#define	UTOPIA_CORE_ID		0x80c	/* utopia core */
+#define	PCMCIA_CORE_ID		0x80d	/* pcmcia core */
+#define	SOCRAM_CORE_ID		0x80e	/* internal memory core */
+#define	MEMC_CORE_ID		0x80f	/* memc sdram core */
+#define	OFDM_CORE_ID		0x810	/* OFDM phy core */
+#define	EXTIF_CORE_ID		0x811	/* external interface core */
+#define	D11_CORE_ID		0x812	/* 802.11 MAC core */
+#define	APHY_CORE_ID		0x813	/* 802.11a phy core */
+#define	BPHY_CORE_ID		0x814	/* 802.11b phy core */
+#define	GPHY_CORE_ID		0x815	/* 802.11g phy core */
+#define	MIPS33_CORE_ID		0x816	/* mips3302 core */
+#define	USB11H_CORE_ID		0x817	/* usb 1.1 host core */
+#define	USB11D_CORE_ID		0x818	/* usb 1.1 device core */
+#define	USB20H_CORE_ID		0x819	/* usb 2.0 host core */
+#define	USB20D_CORE_ID		0x81a	/* usb 2.0 device core */
+#define	SDIOH_CORE_ID		0x81b	/* sdio host core */
+#define	ROBO_CORE_ID		0x81c	/* roboswitch core */
+#define	ATA100_CORE_ID		0x81d	/* parallel ATA core */
+#define	SATAXOR_CORE_ID		0x81e	/* serial ATA & XOR DMA core */
+#define	GIGETH_CORE_ID		0x81f	/* gigabit ethernet core */
+#define	PCIE_CORE_ID		0x820	/* pci express core */
+#define	NPHY_CORE_ID		0x821	/* 802.11n 2x2 phy core */
+#define	SRAMC_CORE_ID		0x822	/* SRAM controller core */
+#define	MINIMAC_CORE_ID		0x823	/* MINI MAC/phy core */
+#define	ARM11_CORE_ID		0x824	/* ARM 1176 core */
+#define	ARM7S_CORE_ID		0x825	/* ARM7tdmi-s core */
+#define	LPPHY_CORE_ID		0x826	/* 802.11a/b/g phy core */
+#define	PMU_CORE_ID		0x827	/* PMU core */
+#define	SSNPHY_CORE_ID		0x828	/* 802.11n single-stream phy core */
+#define	SDIOD_CORE_ID		0x829	/* SDIO device core */
+#define	ARMCM3_CORE_ID		0x82a	/* ARM Cortex M3 core */
+#define	HTPHY_CORE_ID		0x82b	/* 802.11n 4x4 phy core */
+#define	MIPS74K_CORE_ID		0x82c	/* mips 74k core */
+#define	GMAC_CORE_ID		0x82d	/* Gigabit MAC core */
+#define	DMEMC_CORE_ID		0x82e	/* DDR1/2 memory controller core */
+#define	PCIERC_CORE_ID		0x82f	/* PCIE Root Complex core */
+#define	OCP_CORE_ID		0x830	/* OCP2OCP bridge core */
+#define	SC_CORE_ID		0x831	/* shared common core */
+#define	AHB_CORE_ID		0x832	/* OCP2AHB bridge core */
+#define	SPIH_CORE_ID		0x833	/* SPI host core */
+#define	I2S_CORE_ID		0x834	/* I2S core */
+#define	DMEMS_CORE_ID		0x835	/* SDR/DDR1 memory controller core */
+#define	DEF_SHIM_COMP		0x837	/* SHIM component in ubus/6362 */
+#define OOB_ROUTER_CORE_ID	0x367	/* OOB router core ID */
+#define	DEF_AI_COMP		0xfff	/* Default component, in ai chips it
+					 * maps all unused address ranges
+					 */
+
+/* There are TWO constants on all HND chips: SI_ENUM_BASE above,
+ * and chipcommon being the first core:
+ */
+#define	SI_CC_IDX		0
+
+/* SOC Interconnect types (aka chip types) */
+#define	SOCI_AI			1
+
+/* Common core control flags */
+#define	SICF_BIST_EN		0x8000
+#define	SICF_PME_EN		0x4000
+#define	SICF_CORE_BITS		0x3ffc
+#define	SICF_FGC		0x0002
+#define	SICF_CLOCK_EN		0x0001
+
+/* Common core status flags */
+#define	SISF_BIST_DONE		0x8000
+#define	SISF_BIST_ERROR		0x4000
+#define	SISF_GATED_CLK		0x2000
+#define	SISF_DMA64		0x1000
+#define	SISF_CORE_BITS		0x0fff
+
+/* A register that is common to all cores to
+ * communicate w/PMU regarding clock control.
+ */
+#define SI_CLK_CTL_ST		0x1e0	/* clock control and status */
+
+/* clk_ctl_st register */
+#define	CCS_FORCEALP		0x00000001	/* force ALP request */
+#define	CCS_FORCEHT		0x00000002	/* force HT request */
+#define	CCS_FORCEILP		0x00000004	/* force ILP request */
+#define	CCS_ALPAREQ		0x00000008	/* ALP Avail Request */
+#define	CCS_HTAREQ		0x00000010	/* HT Avail Request */
+#define	CCS_FORCEHWREQOFF	0x00000020	/* Force HW Clock Request Off */
+#define CCS_ERSRC_REQ_MASK	0x00000700	/* external resource requests */
+#define CCS_ERSRC_REQ_SHIFT	8
+#define	CCS_ALPAVAIL		0x00010000	/* ALP is available */
+#define	CCS_HTAVAIL		0x00020000	/* HT is available */
+#define CCS_BP_ON_APL		0x00040000	/* RO: running on ALP clock */
+#define CCS_BP_ON_HT		0x00080000	/* RO: running on HT clock */
+#define CCS_ERSRC_STS_MASK	0x07000000	/* external resource status */
+#define CCS_ERSRC_STS_SHIFT	24
+
+/* HT avail in chipc and pcmcia on 4328a0 */
+#define	CCS0_HTAVAIL		0x00010000
+/* ALP avail in chipc and pcmcia on 4328a0 */
+#define	CCS0_ALPAVAIL		0x00020000
+
+/* Not really related to SOC Interconnect, but a couple of software
+ * conventions for the use the flash space:
+ */
+
+/* Minumum amount of flash we support */
+#define FLASH_MIN		0x00020000	/* Minimum flash size */
+
+/* A boot/binary may have an embedded block that describes its size  */
+#define	BISZ_OFFSET		0x3e0	/* At this offset into the binary */
+#define	BISZ_MAGIC		0x4249535a	/* Marked with value: 'BISZ' */
+#define	BISZ_MAGIC_IDX		0	/* Word 0: magic */
+#define	BISZ_TXTST_IDX		1	/*      1: text start */
+#define	BISZ_TXTEND_IDX		2	/*      2: text end */
+#define	BISZ_DATAST_IDX		3	/*      3: data start */
+#define	BISZ_DATAEND_IDX	4	/*      4: data end */
+#define	BISZ_BSSST_IDX		5	/*      5: bss start */
+#define	BISZ_BSSEND_IDX		6	/*      6: bss end */
+#define BISZ_SIZE		7	/* descriptor size in 32-bit integers */
+
+#define	SI_INFO(sih)	(si_info_t *)sih
+
+#define	GOODCOREADDR(x, b) \
+	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
+		IS_ALIGNED((x), SI_CORE_SIZE))
+#define	GOODREGS(regs) \
+	((regs) != NULL && IS_ALIGNED((unsigned long)(regs), SI_CORE_SIZE))
+#define BADCOREADDR	0
+#define	GOODIDX(idx)	(((uint)idx) < SI_MAXCORES)
+#define	NOREV		-1	/* Invalid rev */
+
+/* Newer chips can access PCI/PCIE and CC core without requiring to change
+ * PCI BAR0 WIN
+ */
+#define SI_FAST(si) (((si)->pub.buscoretype == PCIE_CORE_ID) ||	\
+		     (((si)->pub.buscoretype == PCI_CORE_ID) && \
+		      (si)->pub.buscorerev >= 13))
+
+#define PCIEREGS(si) (((char *)((si)->curmap) + PCI_16KB0_PCIREGS_OFFSET))
+#define CCREGS_FAST(si) (((char *)((si)->curmap) + PCI_16KB0_CCREGS_OFFSET))
+
+/*
+ * Macros to disable/restore function core(D11, ENET, ILINE20, etc) interrupts
+ * before after core switching to avoid invalid register accesss inside ISR.
+ */
+#define INTR_OFF(si, intr_val) \
+	if ((si)->intrsoff_fn && \
+	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
+		intr_val = (*(si)->intrsoff_fn)((si)->intr_arg)
+#define INTR_RESTORE(si, intr_val) \
+	if ((si)->intrsrestore_fn && \
+	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
+		(*(si)->intrsrestore_fn)((si)->intr_arg, intr_val)
+
+/* dynamic clock control defines */
+#define	LPOMINFREQ		25000	/* low power oscillator min */
+#define	LPOMAXFREQ		43000	/* low power oscillator max */
+#define	XTALMINFREQ		19800000	/* 20 MHz - 1% */
+#define	XTALMAXFREQ		20200000	/* 20 MHz + 1% */
+#define	PCIMINFREQ		25000000	/* 25 MHz */
+#define	PCIMAXFREQ		34000000	/* 33 MHz + fudge */
+
+#define	ILP_DIV_5MHZ		0	/* ILP = 5 MHz */
+#define	ILP_DIV_1MHZ		4	/* ILP = 1 MHz */
+
+#define PCI(si)		(((si)->pub.bustype == PCI_BUS) &&	\
+			 ((si)->pub.buscoretype == PCI_CORE_ID))
+#define PCIE(si)	(((si)->pub.bustype == PCI_BUS) &&	\
+			 ((si)->pub.buscoretype == PCIE_CORE_ID))
+#define PCI_FORCEHT(si)	\
+	(PCIE(si) && (si->pub.chip == BCM4716_CHIP_ID))
+
+/* GPIO Based LED powersave defines */
+#define DEFAULT_GPIO_ONTIME	10	/* Default: 10% on */
+#define DEFAULT_GPIO_OFFTIME	90	/* Default: 10% on */
+
+#ifndef DEFAULT_GPIOTIMERVAL
+#define DEFAULT_GPIOTIMERVAL \
+	((DEFAULT_GPIO_ONTIME << GPIO_ONTIME_SHIFT) | DEFAULT_GPIO_OFFTIME)
+#endif
+
+/*
+ * Data structure to export all chip specific common variables
+ *   public (read-only) portion of aiutils handle returned by si_attach()
+ */
+struct si_pub {
+	uint socitype;		/* SOCI_SB, SOCI_AI */
+
+	uint bustype;		/* SI_BUS, PCI_BUS */
+	uint buscoretype;	/* PCI_CORE_ID, PCIE_CORE_ID, PCMCIA_CORE_ID */
+	uint buscorerev;	/* buscore rev */
+	uint buscoreidx;	/* buscore index */
+	int ccrev;		/* chip common core rev */
+	u32 cccaps;		/* chip common capabilities */
+	u32 cccaps_ext;	/* chip common capabilities extension */
+	int pmurev;		/* pmu core rev */
+	u32 pmucaps;		/* pmu capabilities */
+	uint boardtype;		/* board type */
+	uint boardvendor;	/* board vendor */
+	uint boardflags;	/* board flags */
+	uint boardflags2;	/* board flags2 */
+	uint chip;		/* chip number */
+	uint chiprev;		/* chip revision */
+	uint chippkg;		/* chip package option */
+	u32 chipst;		/* chip status */
+	bool issim;		/* chip is in simulation or emulation */
+	uint socirev;		/* SOC interconnect rev */
+	bool pci_pr32414;
+
+};
+
+/*
+ * for HIGH_ONLY driver, the si_t must be writable to allow states sync from
+ * BMAC to HIGH driver for monolithic driver, it is readonly to prevent accident
+ * change
+ */
+typedef const struct si_pub si_t;
+
+/*
+ * Many of the routines below take an 'sih' handle as their first arg.
+ * Allocate this by calling si_attach().  Free it by calling si_detach().
+ * At any one time, the sih is logically focused on one particular si core
+ * (the "current core").
+ * Use si_setcore() or si_setcoreidx() to change the association to another core
+ */
+
+#define	BADIDX		(SI_MAXCORES + 1)
+
+/* clkctl xtal what flags */
+#define	XTAL			0x1	/* primary crystal oscillator (2050) */
+#define	PLL			0x2	/* main chip pll */
+
+/* clkctl clk mode */
+#define	CLK_FAST		0	/* force fast (pll) clock */
+#define	CLK_DYNAMIC		2	/* enable dynamic clock control */
+
+/* GPIO usage priorities */
+#define GPIO_DRV_PRIORITY	0	/* Driver */
+#define GPIO_APP_PRIORITY	1	/* Application */
+#define GPIO_HI_PRIORITY	2	/* Highest priority. Ignore GPIO
+					 * reservation
+					 */
+
+/* GPIO pull up/down */
+#define GPIO_PULLUP		0
+#define GPIO_PULLDN		1
+
+/* GPIO event regtype */
+#define GPIO_REGEVT		0	/* GPIO register event */
+#define GPIO_REGEVT_INTMSK	1	/* GPIO register event int mask */
+#define GPIO_REGEVT_INTPOL	2	/* GPIO register event int polarity */
+
+/* device path */
+#define SI_DEVPATH_BUFSZ	16	/* min buffer size in bytes */
+
+/* SI routine enumeration: to be used by update function with multiple hooks */
+#define	SI_DOATTACH	1
+#define SI_PCIDOWN	2
+#define SI_PCIUP	3
+
+#define	ISSIM_ENAB(sih)	0
+
+/* PMU clock/power control */
+#if defined(BCMPMUCTL)
+#define PMUCTL_ENAB(sih)	(BCMPMUCTL)
+#else
+#define PMUCTL_ENAB(sih)	((sih)->cccaps & CC_CAP_PMU)
+#endif
+
+/* chipcommon clock/power control (exclusive with PMU's) */
+#if defined(BCMPMUCTL) && BCMPMUCTL
+#define CCCTL_ENAB(sih)		(0)
+#define CCPLL_ENAB(sih)		(0)
+#else
+#define CCCTL_ENAB(sih)		((sih)->cccaps & CC_CAP_PWR_CTL)
+#define CCPLL_ENAB(sih)		((sih)->cccaps & CC_CAP_PLL_MASK)
+#endif
+
+typedef void (*gpio_handler_t) (u32 stat, void *arg);
+
+/* External PA enable mask */
+#define GPIO_CTRL_EPA_EN_MASK 0x40
+
+#define	SI_ERROR(args)
+
+#ifdef BCMDBG
+#define	SI_MSG(args)	printk args
+#else
+#define	SI_MSG(args)
+#endif				/* BCMDBG */
+
+/* Define SI_VMSG to printf for verbose debugging, but don't check it in */
+#define	SI_VMSG(args)
+
+#define	IS_SIM(chippkg)	\
+	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
+
+typedef u32(*si_intrsoff_t) (void *intr_arg);
+typedef void (*si_intrsrestore_t) (void *intr_arg, u32 arg);
+typedef bool(*si_intrsenabled_t) (void *intr_arg);
+
+typedef struct gpioh_item {
+	void *arg;
+	bool level;
+	gpio_handler_t handler;
+	u32 event;
+	struct gpioh_item *next;
+} gpioh_item_t;
+
+/* misc si info needed by some of the routines */
+typedef struct si_info {
+	struct si_pub pub;	/* back plane public state (must be first) */
+	void *pbus;		/* handle to bus (pci/sdio/..) */
+	uint dev_coreid;	/* the core provides driver functions */
+	void *intr_arg;		/* interrupt callback function arg */
+	si_intrsoff_t intrsoff_fn;	/* turns chip interrupts off */
+	si_intrsrestore_t intrsrestore_fn; /* restore chip interrupts */
+	si_intrsenabled_t intrsenabled_fn; /* check if interrupts are enabled */
+
+	void *pch;		/* PCI/E core handle */
+
+	gpioh_item_t *gpioh_head;	/* GPIO event handlers list */
+
+	bool memseg;		/* flag to toggle MEM_SEG register */
+
+	char *vars;
+	uint varsz;
+
+	void *curmap;		/* current regs va */
+	void *regs[SI_MAXCORES];	/* other regs va */
+
+	uint curidx;		/* current core index */
+	uint numcores;		/* # discovered cores */
+	uint coreid[SI_MAXCORES]; /* id of each core */
+	u32 coresba[SI_MAXCORES]; /* backplane address of each core */
+	void *regs2[SI_MAXCORES]; /* 2nd virtual address per core (usbh20) */
+	u32 coresba2[SI_MAXCORES]; /* 2nd phys address per core (usbh20) */
+	u32 coresba_size[SI_MAXCORES]; /* backplane address space size */
+	u32 coresba2_size[SI_MAXCORES];	/* second address space size */
+
+	void *curwrap;		/* current wrapper va */
+	void *wrappers[SI_MAXCORES];	/* other cores wrapper va */
+	u32 wrapba[SI_MAXCORES];	/* address of controlling wrapper */
+
+	u32 cia[SI_MAXCORES];	/* erom cia entry for each core */
+	u32 cib[SI_MAXCORES];	/* erom cia entry for each core */
+	u32 oob_router;	/* oob router registers for axi */
+} si_info_t;
+
+/* AMBA Interconnect exported externs */
+#if 0
+extern si_t *ai_attach(uint pcidev, struct osl_info *osh, void *regs,
+		       uint bustype, void *sdh, char **vars, uint *varsz);
+extern si_t *ai_kattach(struct osl_info *osh);
+#endif
+extern void ai_scan(si_t *sih, void *regs, uint devid);
+
+extern uint ai_flag(si_t *sih);
+extern void ai_setint(si_t *sih, int siflag);
+extern uint ai_coreidx(si_t *sih);
+extern uint ai_corevendor(si_t *sih);
+extern uint ai_corerev(si_t *sih);
+extern bool ai_iscoreup(si_t *sih);
+extern void *ai_setcoreidx(si_t *sih, uint coreidx);
+extern u32 ai_core_cflags(si_t *sih, u32 mask, u32 val);
+extern void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val);
+extern u32 ai_core_sflags(si_t *sih, u32 mask, u32 val);
+extern uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
+		       uint val);
+extern void ai_core_reset(si_t *sih, u32 bits, u32 resetbits);
+extern void ai_core_disable(si_t *sih, u32 bits);
+extern int ai_numaddrspaces(si_t *sih);
+extern u32 ai_addrspace(si_t *sih, uint asidx);
+extern u32 ai_addrspacesize(si_t *sih, uint asidx);
+extern void ai_write_wrap_reg(si_t *sih, u32 offset, u32 val);
+
+/* === exported functions === */
+extern si_t *si_attach(uint pcidev, void *regs, uint bustype,
+		       void *sdh, char **vars, uint *varsz);
+
+extern void si_detach(si_t *sih);
+extern bool si_pci_war16165(si_t *sih);
+
+extern uint si_coreid(si_t *sih);
+extern uint si_flag(si_t *sih);
+extern uint si_corerev(si_t *sih);
+struct osl_info *si_osh(si_t *sih);
+extern uint si_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
+		uint val);
+extern void si_write_wrapperreg(si_t *sih, u32 offset, u32 val);
+extern u32 si_core_cflags(si_t *sih, u32 mask, u32 val);
+extern u32 si_core_sflags(si_t *sih, u32 mask, u32 val);
+extern bool si_iscoreup(si_t *sih);
+extern uint si_findcoreidx(si_t *sih, uint coreid, uint coreunit);
+extern void *si_setcoreidx(si_t *sih, uint coreidx);
+extern void *si_setcore(si_t *sih, uint coreid, uint coreunit);
+extern void *si_switch_core(si_t *sih, uint coreid, uint *origidx,
+			    uint *intr_val);
+extern void si_restore_core(si_t *sih, uint coreid, uint intr_val);
+extern void si_core_reset(si_t *sih, u32 bits, u32 resetbits);
+extern void si_core_disable(si_t *sih, u32 bits);
+extern u32 si_alp_clock(si_t *sih);
+extern u32 si_ilp_clock(si_t *sih);
+extern void si_pci_setup(si_t *sih, uint coremask);
+extern void si_setint(si_t *sih, int siflag);
+extern bool si_backplane64(si_t *sih);
+extern void si_register_intr_callback(si_t *sih, void *intrsoff_fn,
+				      void *intrsrestore_fn,
+				      void *intrsenabled_fn, void *intr_arg);
+extern void si_deregister_intr_callback(si_t *sih);
+extern void si_clkctl_init(si_t *sih);
+extern u16 si_clkctl_fast_pwrup_delay(si_t *sih);
+extern bool si_clkctl_cc(si_t *sih, uint mode);
+extern int si_clkctl_xtal(si_t *sih, uint what, bool on);
+extern bool si_deviceremoved(si_t *sih);
+extern u32 si_socram_size(si_t *sih);
+
+extern void si_watchdog(si_t *sih, uint ticks);
+extern u32 si_gpiocontrol(si_t *sih, u32 mask, u32 val,
+			     u8 priority);
+
+#define si_eci(sih) 0
+#define si_eci_init(sih) (0)
+#define si_eci_notify_bt(sih, type, val)  (0)
+#define si_seci(sih) 0
+
+/* OTP status */
+extern bool si_is_otp_disabled(si_t *sih);
+extern bool si_is_otp_powered(si_t *sih);
+extern void si_otp_power(si_t *sih, bool on);
+
+/* SPROM availability */
+extern bool si_is_sprom_available(si_t *sih);
+
+/*
+ * Build device path. Path size must be >= SI_DEVPATH_BUFSZ.
+ * The returned path is NULL terminated and has trailing '/'.
+ * Return 0 on success, nonzero otherwise.
+ */
+extern int si_devpath(si_t *sih, char *path, int size);
+/* Read variable with prepending the devpath to the name */
+extern char *si_getdevpathvar(si_t *sih, const char *name);
+extern int si_getdevpathintvar(si_t *sih, const char *name);
+
+extern void si_war42780_clkreq(si_t *sih, bool clkreq);
+extern void si_pci_sleep(si_t *sih);
+extern void si_pci_down(si_t *sih);
+extern void si_pci_up(si_t *sih);
+extern void si_pcie_extendL1timer(si_t *sih, bool extend);
+extern int si_pci_fixcfg(si_t *sih);
+
+extern void si_chipcontrl_epa4331(si_t *sih, bool on);
+/* Enable Ex-PA for 4313 */
+extern void si_epa_4313war(si_t *sih);
+
+char *si_getnvramflvar(si_t *sih, const char *name);
+
+#endif				/* _aiutils_h_ */
diff --git a/drivers/staging/brcm80211/util/aiutils.c b/drivers/staging/brcm80211/util/aiutils.c
index ba205ce..57c5615 100644
--- a/drivers/staging/brcm80211/util/aiutils.c
+++ b/drivers/staging/brcm80211/util/aiutils.c
@@ -21,12 +21,20 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <hndsoc.h>
 #include <sbchipc.h>
 #include <pcicfg.h>
 #include <bcmdevs.h>
 
+/* ********** from siutils.c *********** */
+#include <pci_core.h>
+#include <pcie_core.h>
+#include <nicpci.h>
+#include <bcmnvram.h>
+#include <bcmsrom.h>
+#include <wlc_pmu.h>
+
 #define BCM47162_DMP() ((sih->chip == BCM47162_CHIP_ID) && \
 		(sih->chiprev == 0) && \
 		(sii->coreid[sii->curidx] == MIPS74K_CORE_ID))
@@ -526,7 +534,7 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 		INTR_OFF(sii, intr_val);
 
 		/* save current core index */
-		origidx = si_coreidx(&sii->pub);
+		origidx = ai_coreidx(&sii->pub);
 
 		/* switch core */
 		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx) +
@@ -674,3 +682,1573 @@ u32 ai_core_sflags(si_t *sih, u32 mask, u32 val)
 	return R_REG(&ai->iostatus);
 }
 
+/* *************** from siutils.c ************** */
+/* local prototypes */
+static si_info_t *si_doattach(si_info_t *sii, uint devid, void *regs,
+			      uint bustype, void *sdh, char **vars,
+			      uint *varsz);
+static bool si_buscore_prep(si_info_t *sii, uint bustype, uint devid,
+			    void *sdh);
+static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
+			     u32 savewin, uint *origidx, void *regs);
+static void si_nvram_process(si_info_t *sii, char *pvars);
+
+/* dev path concatenation util */
+static char *si_devpathvar(si_t *sih, char *var, int len, const char *name);
+static bool _si_clkctl_cc(si_info_t *sii, uint mode);
+static bool si_ispcie(si_info_t *sii);
+
+/* global variable to indicate reservation/release of gpio's */
+static u32 si_gpioreservation;
+
+/*
+ * Allocate a si handle.
+ * devid - pci device id (used to determine chip#)
+ * osh - opaque OS handle
+ * regs - virtual address of initial core registers
+ * bustype - pci/sb/sdio/etc
+ * vars - pointer to a pointer area for "environment" variables
+ * varsz - pointer to int to return the size of the vars
+ */
+si_t *si_attach(uint devid, void *regs, uint bustype,
+		void *sdh, char **vars, uint *varsz)
+{
+	si_info_t *sii;
+
+	/* alloc si_info_t */
+	sii = kmalloc(sizeof(si_info_t), GFP_ATOMIC);
+	if (sii == NULL) {
+		SI_ERROR(("si_attach: malloc failed!\n"));
+		return NULL;
+	}
+
+	if (si_doattach(sii, devid, regs, bustype, sdh, vars, varsz) ==
+	    NULL) {
+		kfree(sii);
+		return NULL;
+	}
+	sii->vars = vars ? *vars : NULL;
+	sii->varsz = varsz ? *varsz : 0;
+
+	return (si_t *) sii;
+}
+
+/* global kernel resource */
+static si_info_t ksii;
+
+static bool si_buscore_prep(si_info_t *sii, uint bustype, uint devid,
+			    void *sdh)
+{
+	/* kludge to enable the clock on the 4306 which lacks a slowclock */
+	if (bustype == PCI_BUS && !si_ispcie(sii))
+		si_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
+	return true;
+}
+
+static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
+			     u32 savewin, uint *origidx, void *regs)
+{
+	bool pci, pcie;
+	uint i;
+	uint pciidx, pcieidx, pcirev, pcierev;
+
+	cc = si_setcoreidx(&sii->pub, SI_CC_IDX);
+	ASSERT(cc);
+
+	/* get chipcommon rev */
+	sii->pub.ccrev = (int)si_corerev(&sii->pub);
+
+	/* get chipcommon chipstatus */
+	if (sii->pub.ccrev >= 11)
+		sii->pub.chipst = R_REG(&cc->chipstatus);
+
+	/* get chipcommon capabilites */
+	sii->pub.cccaps = R_REG(&cc->capabilities);
+	/* get chipcommon extended capabilities */
+
+	if (sii->pub.ccrev >= 35)
+		sii->pub.cccaps_ext = R_REG(&cc->capabilities_ext);
+
+	/* get pmu rev and caps */
+	if (sii->pub.cccaps & CC_CAP_PMU) {
+		sii->pub.pmucaps = R_REG(&cc->pmucapabilities);
+		sii->pub.pmurev = sii->pub.pmucaps & PCAP_REV_MASK;
+	}
+
+	/* figure out bus/orignal core idx */
+	sii->pub.buscoretype = NODEV_CORE_ID;
+	sii->pub.buscorerev = NOREV;
+	sii->pub.buscoreidx = BADIDX;
+
+	pci = pcie = false;
+	pcirev = pcierev = NOREV;
+	pciidx = pcieidx = BADIDX;
+
+	for (i = 0; i < sii->numcores; i++) {
+		uint cid, crev;
+
+		si_setcoreidx(&sii->pub, i);
+		cid = si_coreid(&sii->pub);
+		crev = si_corerev(&sii->pub);
+
+		/* Display cores found */
+		SI_VMSG(("CORE[%d]: id 0x%x rev %d base 0x%x regs 0x%p\n",
+			 i, cid, crev, sii->coresba[i], sii->regs[i]));
+
+		if (bustype == PCI_BUS) {
+			if (cid == PCI_CORE_ID) {
+				pciidx = i;
+				pcirev = crev;
+				pci = true;
+			} else if (cid == PCIE_CORE_ID) {
+				pcieidx = i;
+				pcierev = crev;
+				pcie = true;
+			}
+		}
+
+		/* find the core idx before entering this func. */
+		if ((savewin && (savewin == sii->coresba[i])) ||
+		    (regs == sii->regs[i]))
+			*origidx = i;
+	}
+
+	if (pci && pcie) {
+		if (si_ispcie(sii))
+			pci = false;
+		else
+			pcie = false;
+	}
+	if (pci) {
+		sii->pub.buscoretype = PCI_CORE_ID;
+		sii->pub.buscorerev = pcirev;
+		sii->pub.buscoreidx = pciidx;
+	} else if (pcie) {
+		sii->pub.buscoretype = PCIE_CORE_ID;
+		sii->pub.buscorerev = pcierev;
+		sii->pub.buscoreidx = pcieidx;
+	}
+
+	SI_VMSG(("Buscore id/type/rev %d/0x%x/%d\n", sii->pub.buscoreidx,
+		 sii->pub.buscoretype, sii->pub.buscorerev));
+
+	/* fixup necessary chip/core configurations */
+	if (sii->pub.bustype == PCI_BUS) {
+		if (SI_FAST(sii)) {
+			if (!sii->pch) {
+				sii->pch = (void *)pcicore_init(
+					&sii->pub, sii->pbus,
+					(void *)PCIEREGS(sii));
+				if (sii->pch == NULL)
+					return false;
+			}
+		}
+		if (si_pci_fixcfg(&sii->pub)) {
+			SI_ERROR(("si_doattach: si_pci_fixcfg failed\n"));
+			return false;
+		}
+	}
+
+	/* return to the original core */
+	si_setcoreidx(&sii->pub, *origidx);
+
+	return true;
+}
+
+static __used void si_nvram_process(si_info_t *sii, char *pvars)
+{
+	uint w = 0;
+
+	/* get boardtype and boardrev */
+	switch (sii->pub.bustype) {
+	case PCI_BUS:
+		/* do a pci config read to get subsystem id and subvendor id */
+		pci_read_config_dword(sii->pbus, PCI_SUBSYSTEM_VENDOR_ID, &w);
+		/* Let nvram variables override subsystem Vend/ID */
+		sii->pub.boardvendor = (u16)si_getdevpathintvar(&sii->pub,
+			"boardvendor");
+		if (sii->pub.boardvendor == 0)
+			sii->pub.boardvendor = w & 0xffff;
+		else
+			SI_ERROR(("Overriding boardvendor: 0x%x instead of "
+				  "0x%x\n", sii->pub.boardvendor, w & 0xffff));
+		sii->pub.boardtype = (u16)si_getdevpathintvar(&sii->pub,
+			"boardtype");
+		if (sii->pub.boardtype == 0)
+			sii->pub.boardtype = (w >> 16) & 0xffff;
+		else
+			SI_ERROR(("Overriding boardtype: 0x%x instead of 0x%x\n"
+				  , sii->pub.boardtype, (w >> 16) & 0xffff));
+		break;
+
+		sii->pub.boardvendor = getintvar(pvars, "manfid");
+		sii->pub.boardtype = getintvar(pvars, "prodid");
+		break;
+
+	case SI_BUS:
+	case JTAG_BUS:
+		sii->pub.boardvendor = PCI_VENDOR_ID_BROADCOM;
+		sii->pub.boardtype = getintvar(pvars, "prodid");
+		if (pvars == NULL || (sii->pub.boardtype == 0)) {
+			sii->pub.boardtype = getintvar(NULL, "boardtype");
+			if (sii->pub.boardtype == 0)
+				sii->pub.boardtype = 0xffff;
+		}
+		break;
+	}
+
+	if (sii->pub.boardtype == 0) {
+		SI_ERROR(("si_doattach: unknown board type\n"));
+		ASSERT(sii->pub.boardtype);
+	}
+
+	sii->pub.boardflags = getintvar(pvars, "boardflags");
+}
+
+static si_info_t *si_doattach(si_info_t *sii, uint devid,
+			      void *regs, uint bustype, void *pbus,
+			      char **vars, uint *varsz)
+{
+	struct si_pub *sih = &sii->pub;
+	u32 w, savewin;
+	chipcregs_t *cc;
+	char *pvars = NULL;
+	uint origidx;
+
+	ASSERT(GOODREGS(regs));
+
+	memset((unsigned char *) sii, 0, sizeof(si_info_t));
+
+	savewin = 0;
+
+	sih->buscoreidx = BADIDX;
+
+	sii->curmap = regs;
+	sii->pbus = pbus;
+
+	/* check to see if we are a si core mimic'ing a pci core */
+	if (bustype == PCI_BUS) {
+		pci_read_config_dword(sii->pbus, PCI_SPROM_CONTROL,  &w);
+		if (w == 0xffffffff) {
+			SI_ERROR(("%s: incoming bus is PCI but it's a lie, "
+				" switching to SI devid:0x%x\n",
+				__func__, devid));
+			bustype = SI_BUS;
+		}
+	}
+
+	/* find Chipcommon address */
+	if (bustype == PCI_BUS) {
+		pci_read_config_dword(sii->pbus, PCI_BAR0_WIN, &savewin);
+		if (!GOODCOREADDR(savewin, SI_ENUM_BASE))
+			savewin = SI_ENUM_BASE;
+		pci_write_config_dword(sii->pbus, PCI_BAR0_WIN,
+				       SI_ENUM_BASE);
+		cc = (chipcregs_t *) regs;
+	} else {
+		cc = (chipcregs_t *) REG_MAP(SI_ENUM_BASE, SI_CORE_SIZE);
+	}
+
+	sih->bustype = bustype;
+
+	/* bus/core/clk setup for register access */
+	if (!si_buscore_prep(sii, bustype, devid, pbus)) {
+		SI_ERROR(("si_doattach: si_core_clk_prep failed %d\n",
+			  bustype));
+		return NULL;
+	}
+
+	/*
+	 * ChipID recognition.
+	 *   We assume we can read chipid at offset 0 from the regs arg.
+	 *   If we add other chiptypes (or if we need to support old sdio
+	 *   hosts w/o chipcommon), some way of recognizing them needs to
+	 *   be added here.
+	 */
+	w = R_REG(&cc->chipid);
+	sih->socitype = (w & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
+	/* Might as wll fill in chip id rev & pkg */
+	sih->chip = w & CID_ID_MASK;
+	sih->chiprev = (w & CID_REV_MASK) >> CID_REV_SHIFT;
+	sih->chippkg = (w & CID_PKG_MASK) >> CID_PKG_SHIFT;
+
+	sih->issim = IS_SIM(sih->chippkg);
+
+	/* scan for cores */
+	if (sii->pub.socitype == SOCI_AI) {
+		SI_MSG(("Found chip type AI (0x%08x)\n", w));
+		/* pass chipc address instead of original core base */
+		ai_scan(&sii->pub, (void *)cc, devid);
+	} else {
+		SI_ERROR(("Found chip of unknown type (0x%08x)\n", w));
+		return NULL;
+	}
+	/* no cores found, bail out */
+	if (sii->numcores == 0) {
+		SI_ERROR(("si_doattach: could not find any cores\n"));
+		return NULL;
+	}
+	/* bus/core/clk setup */
+	origidx = SI_CC_IDX;
+	if (!si_buscore_setup(sii, cc, bustype, savewin, &origidx, regs)) {
+		SI_ERROR(("si_doattach: si_buscore_setup failed\n"));
+		goto exit;
+	}
+
+	/* assume current core is CC */
+	if ((sii->pub.ccrev == 0x25)
+	    &&
+	    ((sih->chip == BCM43236_CHIP_ID
+	      || sih->chip == BCM43235_CHIP_ID
+	      || sih->chip == BCM43238_CHIP_ID)
+	     && (sii->pub.chiprev <= 2))) {
+
+		if ((cc->chipstatus & CST43236_BP_CLK) != 0) {
+			uint clkdiv;
+			clkdiv = R_REG(&cc->clkdiv);
+			/* otp_clk_div is even number, 120/14 < 9mhz */
+			clkdiv = (clkdiv & ~CLKD_OTP) | (14 << CLKD_OTP_SHIFT);
+			W_REG(&cc->clkdiv, clkdiv);
+			SI_ERROR(("%s: set clkdiv to %x\n", __func__, clkdiv));
+		}
+		udelay(10);
+	}
+
+	/* Init nvram from flash if it exists */
+	nvram_init((void *)&(sii->pub));
+
+	/* Init nvram from sprom/otp if they exist */
+	if (srom_var_init
+	    (&sii->pub, bustype, regs, vars, varsz)) {
+		SI_ERROR(("si_doattach: srom_var_init failed: bad srom\n"));
+		goto exit;
+	}
+	pvars = vars ? *vars : NULL;
+	si_nvram_process(sii, pvars);
+
+	/* === NVRAM, clock is ready === */
+	cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+	W_REG(&cc->gpiopullup, 0);
+	W_REG(&cc->gpiopulldown, 0);
+	si_setcoreidx(sih, origidx);
+
+	/* PMU specific initializations */
+	if (PMUCTL_ENAB(sih)) {
+		u32 xtalfreq;
+		si_pmu_init(sih);
+		si_pmu_chip_init(sih);
+		xtalfreq = getintvar(pvars, "xtalfreq");
+		/* If xtalfreq var not available, try to measure it */
+		if (xtalfreq == 0)
+			xtalfreq = si_pmu_measure_alpclk(sih);
+		si_pmu_pll_init(sih, xtalfreq);
+		si_pmu_res_init(sih);
+		si_pmu_swreg_init(sih);
+	}
+
+	/* setup the GPIO based LED powersave register */
+	w = getintvar(pvars, "leddc");
+	if (w == 0)
+		w = DEFAULT_GPIOTIMERVAL;
+	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
+
+	if (PCIE(sii)) {
+		ASSERT(sii->pch != NULL);
+		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
+	}
+
+	if ((sih->chip == BCM43224_CHIP_ID) ||
+	    (sih->chip == BCM43421_CHIP_ID)) {
+		/*
+		 * enable 12 mA drive strenth for 43224 and
+		 * set chipControl register bit 15
+		 */
+		if (sih->chiprev == 0) {
+			SI_MSG(("Applying 43224A0 WARs\n"));
+			si_corereg(sih, SI_CC_IDX,
+				   offsetof(chipcregs_t, chipcontrol),
+				   CCTRL43224_GPIO_TOGGLE,
+				   CCTRL43224_GPIO_TOGGLE);
+			si_pmu_chipcontrol(sih, 0, CCTRL_43224A0_12MA_LED_DRIVE,
+					   CCTRL_43224A0_12MA_LED_DRIVE);
+		}
+		if (sih->chiprev >= 1) {
+			SI_MSG(("Applying 43224B0+ WARs\n"));
+			si_pmu_chipcontrol(sih, 0, CCTRL_43224B0_12MA_LED_DRIVE,
+					   CCTRL_43224B0_12MA_LED_DRIVE);
+		}
+	}
+
+	if (sih->chip == BCM4313_CHIP_ID) {
+		/*
+		 * enable 12 mA drive strenth for 4313 and
+		 * set chipControl register bit 1
+		 */
+		SI_MSG(("Applying 4313 WARs\n"));
+		si_pmu_chipcontrol(sih, 0, CCTRL_4313_12MA_LED_DRIVE,
+				   CCTRL_4313_12MA_LED_DRIVE);
+	}
+
+	if (sih->chip == BCM4331_CHIP_ID) {
+		/* Enable Ext PA lines depending on chip package option */
+		si_chipcontrl_epa4331(sih, true);
+	}
+
+	return sii;
+ exit:
+	if (sih->bustype == PCI_BUS) {
+		if (sii->pch)
+			pcicore_deinit(sii->pch);
+		sii->pch = NULL;
+	}
+
+	return NULL;
+}
+
+/* may be called with core in reset */
+void si_detach(si_t *sih)
+{
+	si_info_t *sii;
+	uint idx;
+
+	struct si_pub *si_local = NULL;
+	bcopy(&sih, &si_local, sizeof(si_t **));
+
+	sii = SI_INFO(sih);
+
+	if (sii == NULL)
+		return;
+
+	if (sih->bustype == SI_BUS)
+		for (idx = 0; idx < SI_MAXCORES; idx++)
+			if (sii->regs[idx]) {
+				iounmap(sii->regs[idx]);
+				sii->regs[idx] = NULL;
+			}
+
+	nvram_exit((void *)si_local);	/* free up nvram buffers */
+
+	if (sih->bustype == PCI_BUS) {
+		if (sii->pch)
+			pcicore_deinit(sii->pch);
+		sii->pch = NULL;
+	}
+
+	if (sii != &ksii)
+		kfree(sii);
+}
+
+/* register driver interrupt disabling and restoring callback functions */
+void
+si_register_intr_callback(si_t *sih, void *intrsoff_fn, void *intrsrestore_fn,
+			  void *intrsenabled_fn, void *intr_arg)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+	sii->intr_arg = intr_arg;
+	sii->intrsoff_fn = (si_intrsoff_t) intrsoff_fn;
+	sii->intrsrestore_fn = (si_intrsrestore_t) intrsrestore_fn;
+	sii->intrsenabled_fn = (si_intrsenabled_t) intrsenabled_fn;
+	/* save current core id.  when this function called, the current core
+	 * must be the core which provides driver functions(il, et, wl, etc.)
+	 */
+	sii->dev_coreid = sii->coreid[sii->curidx];
+}
+
+void si_deregister_intr_callback(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+	sii->intrsoff_fn = NULL;
+}
+
+uint si_flag(si_t *sih)
+{
+	if (sih->socitype == SOCI_AI)
+		return ai_flag(sih);
+	else {
+		ASSERT(0);
+		return 0;
+	}
+}
+
+void si_setint(si_t *sih, int siflag)
+{
+	if (sih->socitype == SOCI_AI)
+		ai_setint(sih, siflag);
+	else
+		ASSERT(0);
+}
+
+uint si_coreid(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+	return sii->coreid[sii->curidx];
+}
+
+uint ai_coreidx(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+	return sii->curidx;
+}
+
+bool si_backplane64(si_t *sih)
+{
+	return (sih->cccaps & CC_CAP_BKPLN64) != 0;
+}
+
+uint si_corerev(si_t *sih)
+{
+	if (sih->socitype == SOCI_AI)
+		return ai_corerev(sih);
+	else {
+		ASSERT(0);
+		return 0;
+	}
+}
+
+/* return index of coreid or BADIDX if not found */
+uint si_findcoreidx(si_t *sih, uint coreid, uint coreunit)
+{
+	si_info_t *sii;
+	uint found;
+	uint i;
+
+	sii = SI_INFO(sih);
+
+	found = 0;
+
+	for (i = 0; i < sii->numcores; i++)
+		if (sii->coreid[i] == coreid) {
+			if (found == coreunit)
+				return i;
+			found++;
+		}
+
+	return BADIDX;
+}
+
+/*
+ * This function changes logical "focus" to the indicated core;
+ * must be called with interrupts off.
+ * Moreover, callers should keep interrupts off during switching
+ * out of and back to d11 core.
+ */
+void *si_setcore(si_t *sih, uint coreid, uint coreunit)
+{
+	uint idx;
+
+	idx = si_findcoreidx(sih, coreid, coreunit);
+	if (!GOODIDX(idx))
+		return NULL;
+
+	if (sih->socitype == SOCI_AI)
+		return ai_setcoreidx(sih, idx);
+	else {
+		ASSERT(0);
+		return NULL;
+	}
+}
+
+void *si_setcoreidx(si_t *sih, uint coreidx)
+{
+	if (sih->socitype == SOCI_AI)
+		return ai_setcoreidx(sih, coreidx);
+	else {
+		ASSERT(0);
+		return NULL;
+	}
+}
+
+/* Turn off interrupt as required by si_setcore, before switch core */
+void *si_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
+{
+	void *cc;
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	if (SI_FAST(sii)) {
+		/* Overloading the origidx variable to remember the coreid,
+		 * this works because the core ids cannot be confused with
+		 * core indices.
+		 */
+		*origidx = coreid;
+		if (coreid == CC_CORE_ID)
+			return (void *)CCREGS_FAST(sii);
+		else if (coreid == sih->buscoretype)
+			return (void *)PCIEREGS(sii);
+	}
+	INTR_OFF(sii, *intr_val);
+	*origidx = sii->curidx;
+	cc = si_setcore(sih, coreid, 0);
+	ASSERT(cc != NULL);
+
+	return cc;
+}
+
+/* restore coreidx and restore interrupt */
+void si_restore_core(si_t *sih, uint coreid, uint intr_val)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+	if (SI_FAST(sii)
+	    && ((coreid == CC_CORE_ID) || (coreid == sih->buscoretype)))
+		return;
+
+	si_setcoreidx(sih, coreid);
+	INTR_RESTORE(sii, intr_val);
+}
+
+u32 si_core_cflags(si_t *sih, u32 mask, u32 val)
+{
+	if (sih->socitype == SOCI_AI)
+		return ai_core_cflags(sih, mask, val);
+	else {
+		ASSERT(0);
+		return 0;
+	}
+}
+
+u32 si_core_sflags(si_t *sih, u32 mask, u32 val)
+{
+	if (sih->socitype == SOCI_AI)
+		return ai_core_sflags(sih, mask, val);
+	else {
+		ASSERT(0);
+		return 0;
+	}
+}
+
+bool si_iscoreup(si_t *sih)
+{
+	if (sih->socitype == SOCI_AI)
+		return ai_iscoreup(sih);
+	else {
+		ASSERT(0);
+		return false;
+	}
+}
+
+void si_write_wrapperreg(si_t *sih, u32 offset, u32 val)
+{
+	/* only for 4319, no requirement for SOCI_SB */
+	if (sih->socitype == SOCI_AI)
+		ai_write_wrap_reg(sih, offset, val);
+}
+
+uint si_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
+{
+
+	if (sih->socitype == SOCI_AI)
+		return ai_corereg(sih, coreidx, regoff, mask, val);
+	else {
+		ASSERT(0);
+		return 0;
+	}
+}
+
+void si_core_disable(si_t *sih, u32 bits)
+{
+
+	if (sih->socitype == SOCI_AI)
+		ai_core_disable(sih, bits);
+}
+
+void si_core_reset(si_t *sih, u32 bits, u32 resetbits)
+{
+	if (sih->socitype == SOCI_AI)
+		ai_core_reset(sih, bits, resetbits);
+}
+
+u32 si_alp_clock(si_t *sih)
+{
+	if (PMUCTL_ENAB(sih))
+		return si_pmu_alp_clock(sih);
+
+	return ALP_CLOCK;
+}
+
+u32 si_ilp_clock(si_t *sih)
+{
+	if (PMUCTL_ENAB(sih))
+		return si_pmu_ilp_clock(sih);
+
+	return ILP_CLOCK;
+}
+
+/* set chip watchdog reset timer to fire in 'ticks' */
+void si_watchdog(si_t *sih, uint ticks)
+{
+	uint nb, maxt;
+
+	if (PMUCTL_ENAB(sih)) {
+
+		if ((sih->chip == BCM4319_CHIP_ID) &&
+		    (sih->chiprev == 0) && (ticks != 0)) {
+			si_corereg(sih, SI_CC_IDX,
+				   offsetof(chipcregs_t, clk_ctl_st), ~0, 0x2);
+			si_setcore(sih, USB20D_CORE_ID, 0);
+			si_core_disable(sih, 1);
+			si_setcore(sih, CC_CORE_ID, 0);
+		}
+
+		nb = (sih->ccrev < 26) ? 16 : ((sih->ccrev >= 37) ? 32 : 24);
+		/* The mips compiler uses the sllv instruction,
+		 * so we specially handle the 32-bit case.
+		 */
+		if (nb == 32)
+			maxt = 0xffffffff;
+		else
+			maxt = ((1 << nb) - 1);
+
+		if (ticks == 1)
+			ticks = 2;
+		else if (ticks > maxt)
+			ticks = maxt;
+
+		si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmuwatchdog),
+			   ~0, ticks);
+	} else {
+		/*
+		 * make sure we come up in fast clock mode;
+		 * or if clearing, clear clock
+		 */
+		si_clkctl_cc(sih, ticks ? CLK_FAST : CLK_DYNAMIC);
+		maxt = (1 << 28) - 1;
+		if (ticks > maxt)
+			ticks = maxt;
+
+		si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, watchdog), ~0,
+			   ticks);
+	}
+}
+
+/* return the slow clock source - LPO, XTAL, or PCI */
+static uint si_slowclk_src(si_info_t *sii)
+{
+	chipcregs_t *cc;
+	u32 val;
+
+	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
+
+	if (sii->pub.ccrev < 6) {
+		if (sii->pub.bustype == PCI_BUS) {
+			pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
+					      &val);
+			if (val & PCI_CFG_GPIO_SCS)
+				return SCC_SS_PCI;
+		}
+		return SCC_SS_XTAL;
+	} else if (sii->pub.ccrev < 10) {
+		cc = (chipcregs_t *) si_setcoreidx(&sii->pub, sii->curidx);
+		return R_REG(&cc->slow_clk_ctl) & SCC_SS_MASK;
+	} else			/* Insta-clock */
+		return SCC_SS_XTAL;
+}
+
+/* return the ILP (slowclock) min or max frequency */
+static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
+{
+	u32 slowclk;
+	uint div;
+
+	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
+
+	/*
+	 * shouldn't be here unless we've established
+	 * the chip has dynamic clk control
+	 */
+	ASSERT(R_REG(&cc->capabilities) & CC_CAP_PWR_CTL);
+
+	slowclk = si_slowclk_src(sii);
+	if (sii->pub.ccrev < 6) {
+		if (slowclk == SCC_SS_PCI)
+			return max_freq ? (PCIMAXFREQ / 64)
+				: (PCIMINFREQ / 64);
+		else
+			return max_freq ? (XTALMAXFREQ / 32)
+				: (XTALMINFREQ / 32);
+	} else if (sii->pub.ccrev < 10) {
+		div = 4 *
+		    (((R_REG(&cc->slow_clk_ctl) & SCC_CD_MASK) >>
+		      SCC_CD_SHIFT) + 1);
+		if (slowclk == SCC_SS_LPO)
+			return max_freq ? LPOMAXFREQ : LPOMINFREQ;
+		else if (slowclk == SCC_SS_XTAL)
+			return max_freq ? (XTALMAXFREQ / div)
+				: (XTALMINFREQ / div);
+		else if (slowclk == SCC_SS_PCI)
+			return max_freq ? (PCIMAXFREQ / div)
+				: (PCIMINFREQ / div);
+		else
+			ASSERT(0);
+	} else {
+		/* Chipc rev 10 is InstaClock */
+		div = R_REG(&cc->system_clk_ctl) >> SYCC_CD_SHIFT;
+		div = 4 * (div + 1);
+		return max_freq ? XTALMAXFREQ : (XTALMINFREQ / div);
+	}
+	return 0;
+}
+
+static void si_clkctl_setdelay(si_info_t *sii, void *chipcregs)
+{
+	chipcregs_t *cc = (chipcregs_t *) chipcregs;
+	uint slowmaxfreq, pll_delay, slowclk;
+	uint pll_on_delay, fref_sel_delay;
+
+	pll_delay = PLL_DELAY;
+
+	/*
+	 * If the slow clock is not sourced by the xtal then
+	 * add the xtal_on_delay since the xtal will also be
+	 * powered down by dynamic clk control logic.
+	 */
+	slowclk = si_slowclk_src(sii);
+	if (slowclk != SCC_SS_XTAL)
+		pll_delay += XTAL_ON_DELAY;
+
+	/* Starting with 4318 it is ILP that is used for the delays */
+	slowmaxfreq =
+	    si_slowclk_freq(sii, (sii->pub.ccrev >= 10) ? false : true, cc);
+
+	pll_on_delay = ((slowmaxfreq * pll_delay) + 999999) / 1000000;
+	fref_sel_delay = ((slowmaxfreq * FREF_DELAY) + 999999) / 1000000;
+
+	W_REG(&cc->pll_on_delay, pll_on_delay);
+	W_REG(&cc->fref_sel_delay, fref_sel_delay);
+}
+
+/* initialize power control delay registers */
+void si_clkctl_init(si_t *sih)
+{
+	si_info_t *sii;
+	uint origidx = 0;
+	chipcregs_t *cc;
+	bool fast;
+
+	if (!CCCTL_ENAB(sih))
+		return;
+
+	sii = SI_INFO(sih);
+	fast = SI_FAST(sii);
+	if (!fast) {
+		origidx = sii->curidx;
+		cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+		if (cc == NULL)
+			return;
+	} else {
+		cc = (chipcregs_t *) CCREGS_FAST(sii);
+		if (cc == NULL)
+			return;
+	}
+	ASSERT(cc != NULL);
+
+	/* set all Instaclk chip ILP to 1 MHz */
+	if (sih->ccrev >= 10)
+		SET_REG(&cc->system_clk_ctl, SYCC_CD_MASK,
+			(ILP_DIV_1MHZ << SYCC_CD_SHIFT));
+
+	si_clkctl_setdelay(sii, (void *)cc);
+
+	if (!fast)
+		si_setcoreidx(sih, origidx);
+}
+
+/*
+ * return the value suitable for writing to the
+ * dot11 core FAST_PWRUP_DELAY register
+ */
+u16 si_clkctl_fast_pwrup_delay(si_t *sih)
+{
+	si_info_t *sii;
+	uint origidx = 0;
+	chipcregs_t *cc;
+	uint slowminfreq;
+	u16 fpdelay;
+	uint intr_val = 0;
+	bool fast;
+
+	sii = SI_INFO(sih);
+	if (PMUCTL_ENAB(sih)) {
+		INTR_OFF(sii, intr_val);
+		fpdelay = si_pmu_fast_pwrup_delay(sih);
+		INTR_RESTORE(sii, intr_val);
+		return fpdelay;
+	}
+
+	if (!CCCTL_ENAB(sih))
+		return 0;
+
+	fast = SI_FAST(sii);
+	fpdelay = 0;
+	if (!fast) {
+		origidx = sii->curidx;
+		INTR_OFF(sii, intr_val);
+		cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+		if (cc == NULL)
+			goto done;
+	} else {
+		cc = (chipcregs_t *) CCREGS_FAST(sii);
+		if (cc == NULL)
+			goto done;
+	}
+	ASSERT(cc != NULL);
+
+	slowminfreq = si_slowclk_freq(sii, false, cc);
+	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
+		   (slowminfreq - 1)) / slowminfreq;
+
+ done:
+	if (!fast) {
+		si_setcoreidx(sih, origidx);
+		INTR_RESTORE(sii, intr_val);
+	}
+	return fpdelay;
+}
+
+/* turn primary xtal and/or pll off/on */
+int si_clkctl_xtal(si_t *sih, uint what, bool on)
+{
+	si_info_t *sii;
+	u32 in, out, outen;
+
+	sii = SI_INFO(sih);
+
+	switch (sih->bustype) {
+
+	case PCI_BUS:
+		/* pcie core doesn't have any mapping to control the xtal pu */
+		if (PCIE(sii))
+			return -1;
+
+		pci_read_config_dword(sii->pbus, PCI_GPIO_IN, &in);
+		pci_read_config_dword(sii->pbus, PCI_GPIO_OUT, &out);
+		pci_read_config_dword(sii->pbus, PCI_GPIO_OUTEN, &outen);
+
+		/*
+		 * Avoid glitching the clock if GPRS is already using it.
+		 * We can't actually read the state of the PLLPD so we infer it
+		 * by the value of XTAL_PU which *is* readable via gpioin.
+		 */
+		if (on && (in & PCI_CFG_GPIO_XTAL))
+			return 0;
+
+		if (what & XTAL)
+			outen |= PCI_CFG_GPIO_XTAL;
+		if (what & PLL)
+			outen |= PCI_CFG_GPIO_PLL;
+
+		if (on) {
+			/* turn primary xtal on */
+			if (what & XTAL) {
+				out |= PCI_CFG_GPIO_XTAL;
+				if (what & PLL)
+					out |= PCI_CFG_GPIO_PLL;
+				pci_write_config_dword(sii->pbus,
+						       PCI_GPIO_OUT, out);
+				pci_write_config_dword(sii->pbus,
+						       PCI_GPIO_OUTEN, outen);
+				udelay(XTAL_ON_DELAY);
+			}
+
+			/* turn pll on */
+			if (what & PLL) {
+				out &= ~PCI_CFG_GPIO_PLL;
+				pci_write_config_dword(sii->pbus,
+						       PCI_GPIO_OUT, out);
+				mdelay(2);
+			}
+		} else {
+			if (what & XTAL)
+				out &= ~PCI_CFG_GPIO_XTAL;
+			if (what & PLL)
+				out |= PCI_CFG_GPIO_PLL;
+			pci_write_config_dword(sii->pbus,
+					       PCI_GPIO_OUT, out);
+			pci_write_config_dword(sii->pbus,
+					       PCI_GPIO_OUTEN, outen);
+		}
+
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ *  clock control policy function throught chipcommon
+ *
+ *    set dynamic clk control mode (forceslow, forcefast, dynamic)
+ *    returns true if we are forcing fast clock
+ *    this is a wrapper over the next internal function
+ *      to allow flexible policy settings for outside caller
+ */
+bool si_clkctl_cc(si_t *sih, uint mode)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	/* chipcommon cores prior to rev6 don't support dynamic clock control */
+	if (sih->ccrev < 6)
+		return false;
+
+	if (PCI_FORCEHT(sii))
+		return mode == CLK_FAST;
+
+	return _si_clkctl_cc(sii, mode);
+}
+
+/* clk control mechanism through chipcommon, no policy checking */
+static bool _si_clkctl_cc(si_info_t *sii, uint mode)
+{
+	uint origidx = 0;
+	chipcregs_t *cc;
+	u32 scc;
+	uint intr_val = 0;
+	bool fast = SI_FAST(sii);
+
+	/* chipcommon cores prior to rev6 don't support dynamic clock control */
+	if (sii->pub.ccrev < 6)
+		return false;
+
+	/*
+	 * Chips with ccrev 10 are EOL and they
+	 * don't have SYCC_HR which we use below
+	 */
+	ASSERT(sii->pub.ccrev != 10);
+
+	if (!fast) {
+		INTR_OFF(sii, intr_val);
+		origidx = sii->curidx;
+
+		if ((sii->pub.bustype == SI_BUS) &&
+		    si_setcore(&sii->pub, MIPS33_CORE_ID, 0) &&
+		    (si_corerev(&sii->pub) <= 7) && (sii->pub.ccrev >= 10))
+			goto done;
+
+		cc = (chipcregs_t *) si_setcore(&sii->pub, CC_CORE_ID, 0);
+	} else {
+		cc = (chipcregs_t *) CCREGS_FAST(sii);
+		if (cc == NULL)
+			goto done;
+	}
+	ASSERT(cc != NULL);
+
+	if (!CCCTL_ENAB(&sii->pub) && (sii->pub.ccrev < 20))
+		goto done;
+
+	switch (mode) {
+	case CLK_FAST:		/* FORCEHT, fast (pll) clock */
+		if (sii->pub.ccrev < 10) {
+			/*
+			 * don't forget to force xtal back
+			 * on before we clear SCC_DYN_XTAL..
+			 */
+			si_clkctl_xtal(&sii->pub, XTAL, ON);
+			SET_REG(&cc->slow_clk_ctl,
+				(SCC_XC | SCC_FS | SCC_IP), SCC_IP);
+		} else if (sii->pub.ccrev < 20) {
+			OR_REG(&cc->system_clk_ctl, SYCC_HR);
+		} else {
+			OR_REG(&cc->clk_ctl_st, CCS_FORCEHT);
+		}
+
+		/* wait for the PLL */
+		if (PMUCTL_ENAB(&sii->pub)) {
+			u32 htavail = CCS_HTAVAIL;
+			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
+				  == 0), PMU_MAX_TRANSITION_DLY);
+			ASSERT(R_REG(&cc->clk_ctl_st) & htavail);
+		} else {
+			udelay(PLL_DELAY);
+		}
+		break;
+
+	case CLK_DYNAMIC:	/* enable dynamic clock control */
+		if (sii->pub.ccrev < 10) {
+			scc = R_REG(&cc->slow_clk_ctl);
+			scc &= ~(SCC_FS | SCC_IP | SCC_XC);
+			if ((scc & SCC_SS_MASK) != SCC_SS_XTAL)
+				scc |= SCC_XC;
+			W_REG(&cc->slow_clk_ctl, scc);
+
+			/*
+			 * for dynamic control, we have to
+			 * release our xtal_pu "force on"
+			 */
+			if (scc & SCC_XC)
+				si_clkctl_xtal(&sii->pub, XTAL, OFF);
+		} else if (sii->pub.ccrev < 20) {
+			/* Instaclock */
+			AND_REG(&cc->system_clk_ctl, ~SYCC_HR);
+		} else {
+			AND_REG(&cc->clk_ctl_st, ~CCS_FORCEHT);
+		}
+		break;
+
+	default:
+		ASSERT(0);
+	}
+
+ done:
+	if (!fast) {
+		si_setcoreidx(&sii->pub, origidx);
+		INTR_RESTORE(sii, intr_val);
+	}
+	return mode == CLK_FAST;
+}
+
+/* Build device path. Support SI, PCI, and JTAG for now. */
+int si_devpath(si_t *sih, char *path, int size)
+{
+	int slen;
+
+	ASSERT(path != NULL);
+	ASSERT(size >= SI_DEVPATH_BUFSZ);
+
+	if (!path || size <= 0)
+		return -1;
+
+	switch (sih->bustype) {
+	case SI_BUS:
+	case JTAG_BUS:
+		slen = snprintf(path, (size_t) size, "sb/%u/", ai_coreidx(sih));
+		break;
+	case PCI_BUS:
+		ASSERT((SI_INFO(sih))->pbus != NULL);
+		slen = snprintf(path, (size_t) size, "pci/%u/%u/",
+			((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
+			PCI_SLOT(
+			    ((struct pci_dev *)((SI_INFO(sih))->pbus))->devfn));
+		break;
+
+	default:
+		slen = -1;
+		ASSERT(0);
+		break;
+	}
+
+	if (slen < 0 || slen >= size) {
+		path[0] = '\0';
+		return -1;
+	}
+
+	return 0;
+}
+
+/* Get a variable, but only if it has a devpath prefix */
+char *si_getdevpathvar(si_t *sih, const char *name)
+{
+	char varname[SI_DEVPATH_BUFSZ + 32];
+
+	si_devpathvar(sih, varname, sizeof(varname), name);
+
+	return getvar(NULL, varname);
+}
+
+/* Get a variable, but only if it has a devpath prefix */
+int si_getdevpathintvar(si_t *sih, const char *name)
+{
+#if defined(BCMBUSTYPE) && (BCMBUSTYPE == SI_BUS)
+	return getintvar(NULL, name);
+#else
+	char varname[SI_DEVPATH_BUFSZ + 32];
+
+	si_devpathvar(sih, varname, sizeof(varname), name);
+
+	return getintvar(NULL, varname);
+#endif
+}
+
+char *si_getnvramflvar(si_t *sih, const char *name)
+{
+	return getvar(NULL, name);
+}
+
+/* Concatenate the dev path with a varname into the given 'var' buffer
+ * and return the 'var' pointer. Nothing is done to the arguments if
+ * len == 0 or var is NULL, var is still returned. On overflow, the
+ * first char will be set to '\0'.
+ */
+static char *si_devpathvar(si_t *sih, char *var, int len, const char *name)
+{
+	uint path_len;
+
+	if (!var || len <= 0)
+		return var;
+
+	if (si_devpath(sih, var, len) == 0) {
+		path_len = strlen(var);
+
+		if (strlen(name) + 1 > (uint) (len - path_len))
+			var[0] = '\0';
+		else
+			strncpy(var + path_len, name, len - path_len - 1);
+	}
+
+	return var;
+}
+
+/* return true if PCIE capability exists in the pci config space */
+static __used bool si_ispcie(si_info_t *sii)
+{
+	u8 cap_ptr;
+
+	if (sii->pub.bustype != PCI_BUS)
+		return false;
+
+	cap_ptr =
+	    pcicore_find_pci_capability(sii->pbus, PCI_CAP_ID_EXP, NULL,
+					NULL);
+	if (!cap_ptr)
+		return false;
+
+	return true;
+}
+
+bool si_pci_war16165(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	return PCI(sii) && (sih->buscorerev <= 10);
+}
+
+void si_pci_up(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	/* if not pci bus, we're done */
+	if (sih->bustype != PCI_BUS)
+		return;
+
+	if (PCI_FORCEHT(sii))
+		_si_clkctl_cc(sii, CLK_FAST);
+
+	if (PCIE(sii))
+		pcicore_up(sii->pch, SI_PCIUP);
+
+}
+
+/* Unconfigure and/or apply various WARs when system is going to sleep mode */
+void si_pci_sleep(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	pcicore_sleep(sii->pch);
+}
+
+/* Unconfigure and/or apply various WARs when going down */
+void si_pci_down(si_t *sih)
+{
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	/* if not pci bus, we're done */
+	if (sih->bustype != PCI_BUS)
+		return;
+
+	/* release FORCEHT since chip is going to "down" state */
+	if (PCI_FORCEHT(sii))
+		_si_clkctl_cc(sii, CLK_DYNAMIC);
+
+	pcicore_down(sii->pch, SI_PCIDOWN);
+}
+
+/*
+ * Configure the pci core for pci client (NIC) action
+ * coremask is the bitvec of cores by index to be enabled.
+ */
+void si_pci_setup(si_t *sih, uint coremask)
+{
+	si_info_t *sii;
+	struct sbpciregs *pciregs = NULL;
+	u32 siflag = 0, w;
+	uint idx = 0;
+
+	sii = SI_INFO(sih);
+
+	if (sii->pub.bustype != PCI_BUS)
+		return;
+
+	ASSERT(PCI(sii) || PCIE(sii));
+	ASSERT(sii->pub.buscoreidx != BADIDX);
+
+	if (PCI(sii)) {
+		/* get current core index */
+		idx = sii->curidx;
+
+		/* we interrupt on this backplane flag number */
+		siflag = si_flag(sih);
+
+		/* switch over to pci core */
+		pciregs = si_setcoreidx(sih, sii->pub.buscoreidx);
+	}
+
+	/*
+	 * Enable sb->pci interrupts.  Assume
+	 * PCI rev 2.3 support was added in pci core rev 6 and things changed..
+	 */
+	if (PCIE(sii) || (PCI(sii) && ((sii->pub.buscorerev) >= 6))) {
+		/* pci config write to set this core bit in PCIIntMask */
+		pci_read_config_dword(sii->pbus, PCI_INT_MASK, &w);
+		w |= (coremask << PCI_SBIM_SHIFT);
+		pci_write_config_dword(sii->pbus, PCI_INT_MASK, w);
+	} else {
+		/* set sbintvec bit for our flag number */
+		si_setint(sih, siflag);
+	}
+
+	if (PCI(sii)) {
+		OR_REG(&pciregs->sbtopci2,
+		       (SBTOPCI_PREF | SBTOPCI_BURST));
+		if (sii->pub.buscorerev >= 11) {
+			OR_REG(&pciregs->sbtopci2,
+			       SBTOPCI_RC_READMULTI);
+			w = R_REG(&pciregs->clkrun);
+			W_REG(&pciregs->clkrun,
+			      (w | PCI_CLKRUN_DSBL));
+			w = R_REG(&pciregs->clkrun);
+		}
+
+		/* switch back to previous core */
+		si_setcoreidx(sih, idx);
+	}
+}
+
+/*
+ * Fixup SROMless PCI device's configuration.
+ * The current core may be changed upon return.
+ */
+int si_pci_fixcfg(si_t *sih)
+{
+	uint origidx, pciidx;
+	struct sbpciregs *pciregs = NULL;
+	sbpcieregs_t *pcieregs = NULL;
+	void *regs = NULL;
+	u16 val16, *reg16 = NULL;
+
+	si_info_t *sii = SI_INFO(sih);
+
+	ASSERT(sii->pub.bustype == PCI_BUS);
+
+	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
+	/* save the current index */
+	origidx = ai_coreidx(&sii->pub);
+
+	/* check 'pi' is correct and fix it if not */
+	if (sii->pub.buscoretype == PCIE_CORE_ID) {
+		pcieregs = si_setcore(&sii->pub, PCIE_CORE_ID, 0);
+		regs = pcieregs;
+		ASSERT(pcieregs != NULL);
+		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
+	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
+		pciregs = si_setcore(&sii->pub, PCI_CORE_ID, 0);
+		regs = pciregs;
+		ASSERT(pciregs != NULL);
+		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
+	}
+	pciidx = ai_coreidx(&sii->pub);
+	val16 = R_REG(reg16);
+	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16) pciidx) {
+		val16 =
+		    (u16) (pciidx << SRSH_PI_SHIFT) | (val16 &
+							  ~SRSH_PI_MASK);
+		W_REG(reg16, val16);
+	}
+
+	/* restore the original index */
+	si_setcoreidx(&sii->pub, origidx);
+
+	pcicore_hwup(sii->pch);
+	return 0;
+}
+
+/* mask&set gpiocontrol bits */
+u32 si_gpiocontrol(si_t *sih, u32 mask, u32 val, u8 priority)
+{
+	uint regoff;
+
+	regoff = 0;
+
+	/* gpios could be shared on router platforms
+	 * ignore reservation if it's high priority (e.g., test apps)
+	 */
+	if ((priority != GPIO_HI_PRIORITY) &&
+	    (sih->bustype == SI_BUS) && (val || mask)) {
+		mask = priority ? (si_gpioreservation & mask) :
+		    ((si_gpioreservation | mask) & ~(si_gpioreservation));
+		val &= mask;
+	}
+
+	regoff = offsetof(chipcregs_t, gpiocontrol);
+	return si_corereg(sih, SI_CC_IDX, regoff, mask, val);
+}
+
+void si_chipcontrl_epa4331(si_t *sih, bool on)
+{
+	si_info_t *sii;
+	chipcregs_t *cc;
+	uint origidx;
+	u32 val;
+
+	sii = SI_INFO(sih);
+	origidx = ai_coreidx(sih);
+
+	cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+
+	val = R_REG(&cc->chipcontrol);
+
+	if (on) {
+		if (sih->chippkg == 9 || sih->chippkg == 0xb) {
+			/* Ext PA Controls for 4331 12x9 Package */
+			W_REG(&cc->chipcontrol, val |
+			      (CCTRL4331_EXTPA_EN |
+			       CCTRL4331_EXTPA_ON_GPIO2_5));
+		} else {
+			/* Ext PA Controls for 4331 12x12 Package */
+			W_REG(&cc->chipcontrol,
+			      val | (CCTRL4331_EXTPA_EN));
+		}
+	} else {
+		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
+		W_REG(&cc->chipcontrol, val);
+	}
+
+	si_setcoreidx(sih, origidx);
+}
+
+/* Enable BT-COEX & Ex-PA for 4313 */
+void si_epa_4313war(si_t *sih)
+{
+	si_info_t *sii;
+	chipcregs_t *cc;
+	uint origidx;
+
+	sii = SI_INFO(sih);
+	origidx = ai_coreidx(sih);
+
+	cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+
+	/* EPA Fix */
+	W_REG(&cc->gpiocontrol,
+	      R_REG(&cc->gpiocontrol) | GPIO_CTRL_EPA_EN_MASK);
+
+	si_setcoreidx(sih, origidx);
+}
+
+/* check if the device is removed */
+bool si_deviceremoved(si_t *sih)
+{
+	u32 w;
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	switch (sih->bustype) {
+	case PCI_BUS:
+		ASSERT(sii->pbus != NULL);
+		pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
+		if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
+			return true;
+		break;
+	}
+	return false;
+}
+
+bool si_is_sprom_available(si_t *sih)
+{
+	if (sih->ccrev >= 31) {
+		si_info_t *sii;
+		uint origidx;
+		chipcregs_t *cc;
+		u32 sromctrl;
+
+		if ((sih->cccaps & CC_CAP_SROM) == 0)
+			return false;
+
+		sii = SI_INFO(sih);
+		origidx = sii->curidx;
+		cc = si_setcoreidx(sih, SI_CC_IDX);
+		sromctrl = R_REG(&cc->sromcontrol);
+		si_setcoreidx(sih, origidx);
+		return sromctrl & SRC_PRESENT;
+	}
+
+	switch (sih->chip) {
+	case BCM4329_CHIP_ID:
+		return (sih->chipst & CST4329_SPROM_SEL) != 0;
+	case BCM4319_CHIP_ID:
+		return (sih->chipst & CST4319_SPROM_SEL) != 0;
+	case BCM4336_CHIP_ID:
+		return (sih->chipst & CST4336_SPROM_PRESENT) != 0;
+	case BCM4330_CHIP_ID:
+		return (sih->chipst & CST4330_SPROM_PRESENT) != 0;
+	case BCM4313_CHIP_ID:
+		return (sih->chipst & CST4313_SPROM_PRESENT) != 0;
+	case BCM4331_CHIP_ID:
+		return (sih->chipst & CST4331_SPROM_PRESENT) != 0;
+	default:
+		return true;
+	}
+}
+
+bool si_is_otp_disabled(si_t *sih)
+{
+	switch (sih->chip) {
+	case BCM4329_CHIP_ID:
+		return (sih->chipst & CST4329_SPROM_OTP_SEL_MASK) ==
+		    CST4329_OTP_PWRDN;
+	case BCM4319_CHIP_ID:
+		return (sih->chipst & CST4319_SPROM_OTP_SEL_MASK) ==
+		    CST4319_OTP_PWRDN;
+	case BCM4336_CHIP_ID:
+		return (sih->chipst & CST4336_OTP_PRESENT) == 0;
+	case BCM4330_CHIP_ID:
+		return (sih->chipst & CST4330_OTP_PRESENT) == 0;
+	case BCM4313_CHIP_ID:
+		return (sih->chipst & CST4313_OTP_PRESENT) == 0;
+		/* These chips always have their OTP on */
+	case BCM43224_CHIP_ID:
+	case BCM43225_CHIP_ID:
+	case BCM43421_CHIP_ID:
+	case BCM43235_CHIP_ID:
+	case BCM43236_CHIP_ID:
+	case BCM43238_CHIP_ID:
+	case BCM4331_CHIP_ID:
+	default:
+		return false;
+	}
+}
+
+bool si_is_otp_powered(si_t *sih)
+{
+	if (PMUCTL_ENAB(sih))
+		return si_pmu_is_otp_powered(sih);
+	return true;
+}
+
+void si_otp_power(si_t *sih, bool on)
+{
+	if (PMUCTL_ENAB(sih))
+		si_pmu_otp_power(sih, on);
+	udelay(1000);
+}
+
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index c076d68..aaa80a3 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -17,16 +17,16 @@
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <bcmdefs.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+
+#include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <hndsoc.h>
 #include <sbchipc.h>
 #include <bcmotp.h>
-#include "siutils_priv.h"
 
 /*
  * There are two different OTP controllers so far:
@@ -356,7 +356,7 @@ static void *ipxotp_init(si_t *sih)
 	}
 
 	/* Retrieve OTP region info */
-	idx = si_coreidx(sih);
+	idx = ai_coreidx(sih);
 	cc = si_setcoreidx(sih, SI_CC_IDX);
 
 	_ipxotp_init(oi, cc);
@@ -439,7 +439,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		return -EINVAL;
 	}
 
-	idx = si_coreidx(oi->sih);
+	idx = ai_coreidx(oi->sih);
 	cc = si_setcoreidx(oi->sih, SI_CC_IDX);
 
 	/* Read the data */
@@ -615,7 +615,7 @@ static void *hndotp_init(si_t *sih)
 
 	oi = &otpinfo;
 
-	idx = si_coreidx(sih);
+	idx = ai_coreidx(sih);
 
 	/* Check for otp */
 	cc = si_setcoreidx(sih, SI_CC_IDX);
@@ -699,7 +699,7 @@ static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 	*wlen =
 	    ((int)*wlen < oi->boundary / 2) ? *wlen : (uint) oi->boundary / 2;
 
-	idx = si_coreidx(oi->sih);
+	idx = ai_coreidx(oi->sih);
 	cc = si_setcoreidx(oi->sih, SI_CC_IDX);
 
 	for (i = 0; i < (int)*wlen; i++)
@@ -722,7 +722,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 	u16 *rawotp = NULL;
 
 	/* save the orig core */
-	idx = si_coreidx(oi->sih);
+	idx = ai_coreidx(oi->sih);
 	cc = si_setcoreidx(oi->sih, SI_CC_IDX);
 
 	st = hndotp_status(oh);
@@ -860,7 +860,7 @@ int otp_size(void *oh)
 u16 otp_read_bit(void *oh, uint offset)
 {
 	otpinfo_t *oi = (otpinfo_t *) oh;
-	uint idx = si_coreidx(oi->sih);
+	uint idx = ai_coreidx(oi->sih);
 	chipcregs_t *cc = si_setcoreidx(oi->sih, SI_CC_IDX);
 	u16 readBit = (u16) oi->fn->read_bit(oh, cc, offset);
 	si_setcoreidx(oi->sih, idx);
-- 
1.7.4.1


