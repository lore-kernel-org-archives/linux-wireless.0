Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4614 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757810Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 014/119] staging: brcm80211: remove unused macro
 definitions from pmu.c
Date: Wed, 29 Jun 2011 16:46:38 -0700
Message-ID: <1309391303-22741-15-git-send-email-frankyl@broadcom.com> (sfid-20110630_014941_598371_AD788133)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The source file pmu.c contained a large number of definitions that
are no longer needed and have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/pmu.c |  491 ------------------------------
 1 files changed, 0 insertions(+), 491 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index d7ca7ed..6508243 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -25,11 +25,6 @@
 #include "pmu.h"
 
 /*
- * d11 slow to fast clock transition time in slow clock cycles
- */
-#define D11SCC_SLOW2FAST_TRANSITION	2
-
-/*
  * external LPO crystal frequency
  */
 #define EXT_ILP_HZ 32768
@@ -41,93 +36,6 @@
  */
 #define ILP_CALC_DUR	10
 
-/*
- * FVCO frequency
- */
-#define FVCO_880	880000	/* 880MHz */
-#define FVCO_1760	1760000	/* 1760MHz */
-#define FVCO_1440	1440000	/* 1440MHz */
-#define FVCO_960	960000	/* 960MHz */
-
-/*
- * PMU crystal table indices for 1440MHz fvco
- */
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
-
-/*
- * PMU crystal table indices for 960MHz fvco
- */
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
-
-/*
- * PMU crystal table indices for 880MHz fvco
- */
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
-/*
- * crystal frequency values
- */
-#define XTAL_FREQ_24000MHZ		24000
-#define XTAL_FREQ_30000MHZ		30000
-#define XTAL_FREQ_37400MHZ		37400
-#define XTAL_FREQ_48000MHZ		48000
-
-/*
- * Resource dependancies mask change action
- *
- * @RES_DEPEND_SET: Override the dependancies mask
- * @RES_DEPEND_ADD: Add to the  dependancies mask
- * @RES_DEPEND_REMOVE: Remove from the dependancies mask
- */
-#define RES_DEPEND_SET		0
-#define RES_DEPEND_ADD		1
-#define RES_DEPEND_REMOVE	-1
-
 /* Fields in pmucontrol */
 #define	PCTL_ILP_DIV_MASK	0xffff0000
 #define	PCTL_ILP_DIV_SHIFT	16
@@ -140,24 +48,12 @@
 #define	PCTL_ILP_DIV_EN		0x00000002
 #define	PCTL_LPO_SEL		0x00000001
 
-/* Fields in clkstretch */
-#define CSTRETCH_HT		0xffff0000
-#define CSTRETCH_ALP		0x0000ffff
-
-/* d11 slow to fast clock transition time in slow clock cycles */
-#define D11SCC_SLOW2FAST_TRANSITION	2
-
 /* ILP clock */
 #define	ILP_CLOCK		32000
 
 /* ALP clock on pre-PMU chips */
 #define	ALP_CLOCK		20000000
 
-/* HT clock */
-#define	HT_CLOCK		80000000
-
-#define OTPS_READY		0x00001000
-
 /* pmustatus */
 #define PST_EXTLPOAVAIL	0x0100
 #define PST_WDRESET	0x0080
@@ -170,411 +66,27 @@
 #define	PST_HTAVAIL	0x0004
 #define	PST_RESINIT	0x0003
 
-/* PMU Resource Request Timer registers */
-/* This is based on PmuRev0 */
-#define	PRRT_TIME_MASK	0x03ff
-#define	PRRT_INTEN	0x0400
-#define	PRRT_REQ_ACTIVE	0x0800
-#define	PRRT_ALP_REQ	0x1000
-#define	PRRT_HT_REQ	0x2000
-
 /* PMU resource bit position */
 #define PMURES_BIT(bit)	(1 << (bit))
 
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
 /* PMU corerev and chip specific PLL controls.
  * PMU<rev>_PLL<num>_XX where <rev> is PMU corerev and <num> is an arbitrary number
  * to differentiate different PLLs controlled by the same PMU rev.
  */
 /* pllcontrol registers */
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
 /* ndiv_pwrdn, pwrdn_ch<x>, refcomp_pwrdn, dly_ch<x>, p1div, p2div, _bypass_sdmod */
 #define PMU1_PLL0_PLLCTL0		0
-#define PMU1_PLL0_PC0_P1DIV_MASK	0x00f00000
-#define PMU1_PLL0_PC0_P1DIV_SHIFT	20
-#define PMU1_PLL0_PC0_P2DIV_MASK	0x0f000000
-#define PMU1_PLL0_PC0_P2DIV_SHIFT	24
-
-/* m<x>div */
 #define PMU1_PLL0_PLLCTL1		1
-#define PMU1_PLL0_PC1_M1DIV_MASK	0x000000ff
-#define PMU1_PLL0_PC1_M1DIV_SHIFT	0
-#define PMU1_PLL0_PC1_M2DIV_MASK	0x0000ff00
-#define PMU1_PLL0_PC1_M2DIV_SHIFT	8
-#define PMU1_PLL0_PC1_M3DIV_MASK	0x00ff0000
-#define PMU1_PLL0_PC1_M3DIV_SHIFT	16
-#define PMU1_PLL0_PC1_M4DIV_MASK	0xff000000
-#define PMU1_PLL0_PC1_M4DIV_SHIFT	24
-
-#define PMU1_PLL0_CHIPCTL0		0
-#define PMU1_PLL0_CHIPCTL1		1
-#define PMU1_PLL0_CHIPCTL2		2
-
-#define DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT 8
-#define DOT11MAC_880MHZ_CLK_DIVISOR_MASK (0xFF << DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT)
-#define DOT11MAC_880MHZ_CLK_DIVISOR_VAL  (0xE << DOT11MAC_880MHZ_CLK_DIVISOR_SHIFT)
-
-/* m<x>div, ndiv_dither_mfb, ndiv_mode, ndiv_int */
 #define PMU1_PLL0_PLLCTL2		2
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
 #define PMU1_PLL0_PLLCTL3		3
-#define PMU1_PLL0_PC3_NDIV_FRAC_MASK	0x00ffffff
-#define PMU1_PLL0_PC3_NDIV_FRAC_SHIFT	0
-
-/* pll_ctrl */
 #define PMU1_PLL0_PLLCTL4		4
-
-/* pll_ctrl, vco_rng, clkdrive_ch<x> */
 #define PMU1_PLL0_PLLCTL5		5
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
 
 /* pmu XtalFreqRatio */
 #define	PMU_XTALFREQ_REG_ILPCTR_MASK	0x00001FFF
 #define	PMU_XTALFREQ_REG_MEASURE_MASK	0x80000000
 #define	PMU_XTALFREQ_REG_MEASURE_SHIFT	31
 
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
 /* 4313 resources */
 #define	RES4313_BB_PU_RSRC		0
 #define	RES4313_ILP_REQ_RSRC		1
@@ -593,9 +105,6 @@
 #define	RES4313_HT_AVAIL_RSRC		14
 #define	RES4313_MACPHY_CLK_AVAIL_RSRC	15
 
-/* PMU resource up transition time in ILP cycles */
-#define PMURES_UP_TRANSITION	2
-
 /* Determine min/max rsrc masks. Value 0 leaves hardware at default. */
 static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 {
-- 
1.7.1


