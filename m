Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2360 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758849Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 76/83] staging: brcm80211: cleaned include/brcm_hw_ids.h
Date: Wed, 1 Jun 2011 13:46:01 +0200
Message-ID: <1306928768-7501-76-git-send-email-rvossen@broadcom.com> (sfid-20110601_134854_750730_462BDD58)
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
 drivers/staging/brcm80211/brcmsmac/aiutils.c    |    9 +++
 drivers/staging/brcm80211/brcmsmac/aiutils.h    |   17 ++++++
 drivers/staging/brcm80211/brcmsmac/types.h      |   38 +++++++++++++
 drivers/staging/brcm80211/include/brcm_hw_ids.h |   66 -----------------------
 4 files changed, 64 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 071279a..7eabe90 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -234,6 +234,15 @@
 #define	SD_SG32			0x00000008
 #define	SD_SZ_ALIGN		0x00000fff
 
+#define	PCI_CFG_GPIO_SCS	0x10	/* PCI config space bit 4 for 4306c0 slow clock source */
+#define PCI_CFG_GPIO_XTAL	0x40	/* PCI config space GPIO 14 for Xtal power-up */
+#define PCI_CFG_GPIO_PLL	0x80	/* PCI config space GPIO 15 for PLL power-down */
+
+/* power control defines */
+#define PLL_DELAY		150	/* us pll on delay */
+#define FREF_DELAY		200	/* us fref change delay */
+#define	XTAL_ON_DELAY		1000	/* us crystal power-on delay */
+
 /* resetctrl */
 #define	AIRC_RESET		1
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index f8f5cc1..b007fac 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -259,6 +259,23 @@
 #define	CST4330_CBUCK_POWER_OK		0x00004000
 #define	CST4330_BB_PLL_LOCKED		0x00008000
 
+/* Package IDs */
+#define BCM4329_289PIN_PKG_ID	0	/* 4329 289-pin package id */
+#define BCM4329_182PIN_PKG_ID	1	/* 4329N 182-pin package id */
+#define	BCM4717_PKG_ID		9	/* 4717 package id */
+#define	BCM4718_PKG_ID		10	/* 4718 package id */
+#define HDLSIM_PKG_ID		14	/* HDL simulator package id */
+#define HWSIM_PKG_ID		15	/* Hardware simulator package id */
+#define BCM43224_FAB_SMIC	0xa	/* the chip is manufactured by SMIC */
+
+/* these are router chips */
+#define	BCM4716_CHIP_ID		0x4716	/* 4716 chipcommon chipid */
+#define	BCM47162_CHIP_ID	47162	/* 47162 chipcommon chipid */
+#define	BCM4748_CHIP_ID		0x4748	/* 4716 chipcommon chipid (OTP, RBBU) */
+#define	BCM5356_CHIP_ID		0x5356	/* 5356 chipcommon chipid */
+#define	BCM5357_CHIP_ID		0x5357	/* 5357 chipcommon chipid */
+
+
 #define	SI_INFO(sih)	((si_info_t *)sih)
 
 #define	GOODCOREADDR(x, b) \
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index d15860b..526d3e3 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -33,6 +33,44 @@
 
 #define MAX_DMA_SEGS 4
 
+/* boardflags */
+#define	BFL_PACTRL		0x00000002	/* Board has gpio 9 controlling the PA */
+#define	BFL_NOPLLDOWN		0x00000020	/* Not ok to power down the chip pll and oscillator */
+#define BFL_FEM			0x00000800	/* Board supports the Front End Module */
+#define BFL_EXTLNA		0x00001000	/* Board has an external LNA in 2.4GHz band */
+#define BFL_NOPA		0x00010000	/* Board has no PA */
+#define BFL_BUCKBOOST		0x00200000	/* Power topology uses BUCKBOOST */
+#define BFL_FEM_BT		0x00400000	/* Board has FEM and switch to share antenna w/ BT */
+#define BFL_NOCBUCK		0x00800000	/* Power topology doesn't use CBUCK */
+#define BFL_PALDO		0x02000000	/* Power topology uses PALDO */
+#define BFL_EXTLNA_5GHz		0x10000000	/* Board has an external LNA in 5GHz band */
+
+/* boardflags2 */
+#define BFL2_RXBB_INT_REG_DIS	0x00000001	/* Board has an external rxbb regulator */
+#define BFL2_APLL_WAR		0x00000002	/* Flag to implement alternative A-band PLL settings */
+#define BFL2_TXPWRCTRL_EN	0x00000004	/* Board permits enabling TX Power Control */
+#define BFL2_2X4_DIV		0x00000008	/* Board supports the 2X4 diversity switch */
+#define BFL2_5G_PWRGAIN		0x00000010	/* Board supports 5G band power gain */
+#define BFL2_PCIEWAR_OVR	0x00000020	/* Board overrides ASPM and Clkreq settings */
+#define BFL2_LEGACY		0x00000080
+#define BFL2_SKWRKFEM_BRD	0x00000100	/* 4321mcm93 board uses Skyworks FEM */
+#define BFL2_SPUR_WAR		0x00000200	/* Board has a WAR for clock-harmonic spurs */
+#define BFL2_GPLL_WAR		0x00000400	/* Flag to narrow G-band PLL loop b/w */
+#define BFL2_SINGLEANT_CCK	0x00001000	/* Tx CCK pkts on Ant 0 only */
+#define BFL2_2G_SPUR_WAR	0x00002000	/* WAR to reduce and avoid clock-harmonic spurs in 2G */
+#define BFL2_GPLL_WAR2	        0x00010000	/* Flag to widen G-band PLL loop b/w */
+#define BFL2_IPALVLSHIFT_3P3    0x00020000
+#define BFL2_INTERNDET_TXIQCAL  0x00040000	/* Use internal envelope detector for TX IQCAL */
+#define BFL2_XTALBUFOUTEN       0x00080000	/* Keep the buffered Xtal output from radio "ON"
+						 * Most drivers will turn it off without this flag
+						 * to save power.
+						 */
+
+/* board specific GPIO assignment, gpio 0-3 are also customer-configurable led */
+#define	BOARD_GPIO_PACTRL	0x200	/* bit 9 controls the PA on new 4306 boards */
+#define BOARD_GPIO_12		0x1000	/* gpio 12 */
+#define BOARD_GPIO_13		0x2000	/* gpio 13 */
+
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
 	if (brcm_msg_level & LOG_TRACE_VAL)	\
diff --git a/drivers/staging/brcm80211/include/brcm_hw_ids.h b/drivers/staging/brcm80211/include/brcm_hw_ids.h
index b7aedac..5fb17d5 100644
--- a/drivers/staging/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/staging/brcm80211/include/brcm_hw_ids.h
@@ -56,70 +56,4 @@
 #define BCM4330_CHIP_ID		0x4330	/* 4330 chipcommon chipid */
 #define BCM6362_CHIP_ID		0x6362	/* 6362 chipcommon chipid */
 
-/* these are router chips */
-#define	BCM4716_CHIP_ID		0x4716	/* 4716 chipcommon chipid */
-#define	BCM47162_CHIP_ID	47162	/* 47162 chipcommon chipid */
-#define	BCM4748_CHIP_ID		0x4748	/* 4716 chipcommon chipid (OTP, RBBU) */
-#define	BCM5356_CHIP_ID		0x5356	/* 5356 chipcommon chipid */
-#define	BCM5357_CHIP_ID		0x5357	/* 5357 chipcommon chipid */
-
-/* Package IDs */
-#define BCM4329_289PIN_PKG_ID	0	/* 4329 289-pin package id */
-#define BCM4329_182PIN_PKG_ID	1	/* 4329N 182-pin package id */
-#define	BCM4717_PKG_ID		9	/* 4717 package id */
-#define	BCM4718_PKG_ID		10	/* 4718 package id */
-#define HDLSIM_PKG_ID		14	/* HDL simulator package id */
-#define HWSIM_PKG_ID		15	/* Hardware simulator package id */
-#define BCM43224_FAB_SMIC	0xa	/* the chip is manufactured by SMIC */
-
-/* boardflags */
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
-
-/* boardflags2 */
-#define BFL2_RXBB_INT_REG_DIS	0x00000001	/* Board has an external rxbb regulator */
-#define BFL2_APLL_WAR		0x00000002	/* Flag to implement alternative A-band PLL settings */
-#define BFL2_TXPWRCTRL_EN	0x00000004	/* Board permits enabling TX Power Control */
-#define BFL2_2X4_DIV		0x00000008	/* Board supports the 2X4 diversity switch */
-#define BFL2_5G_PWRGAIN		0x00000010	/* Board supports 5G band power gain */
-#define BFL2_PCIEWAR_OVR	0x00000020	/* Board overrides ASPM and Clkreq settings */
-#define BFL2_LEGACY		0x00000080
-#define BFL2_SKWRKFEM_BRD	0x00000100	/* 4321mcm93 board uses Skyworks FEM */
-#define BFL2_SPUR_WAR		0x00000200	/* Board has a WAR for clock-harmonic spurs */
-#define BFL2_GPLL_WAR		0x00000400	/* Flag to narrow G-band PLL loop b/w */
-#define BFL2_SINGLEANT_CCK	0x00001000	/* Tx CCK pkts on Ant 0 only */
-#define BFL2_2G_SPUR_WAR	0x00002000	/* WAR to reduce and avoid clock-harmonic spurs in 2G */
-#define BFL2_GPLL_WAR2	        0x00010000	/* Flag to widen G-band PLL loop b/w */
-#define BFL2_IPALVLSHIFT_3P3    0x00020000
-#define BFL2_INTERNDET_TXIQCAL  0x00040000	/* Use internal envelope detector for TX IQCAL */
-#define BFL2_XTALBUFOUTEN       0x00080000	/* Keep the buffered Xtal output from radio "ON"
-						 * Most drivers will turn it off without this flag
-						 * to save power.
-						 */
-
-/* board specific GPIO assignment, gpio 0-3 are also customer-configurable led */
-#define	BOARD_GPIO_PACTRL	0x200	/* bit 9 controls the PA on new 4306 boards */
-#define BOARD_GPIO_12		0x1000	/* gpio 12 */
-#define BOARD_GPIO_13		0x2000	/* gpio 13 */
-
-#define	PCI_CFG_GPIO_SCS	0x10	/* PCI config space bit 4 for 4306c0 slow clock source */
-#define PCI_CFG_GPIO_XTAL	0x40	/* PCI config space GPIO 14 for Xtal power-up */
-#define PCI_CFG_GPIO_PLL	0x80	/* PCI config space GPIO 15 for PLL power-down */
-
-/* power control defines */
-#define PLL_DELAY		150	/* us pll on delay */
-#define FREF_DELAY		200	/* us fref change delay */
-#define	XTAL_ON_DELAY		1000	/* us crystal power-on delay */
-
-/* Reference board types */
-#define	SPI_BOARD		0x0402
-
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.4.1


