Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45008 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Av5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:57 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 16/19] brcmsmac: remove nicpci.c
Date: Sun, 29 Apr 2012 02:50:40 +0200
Message-Id: <1335660643-26368-17-git-send-email-hauke@hauke-m.de> (sfid-20120429_025204_585088_7E081BEE)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no code doing anything useful in nicpci.c anymore, so remove
it.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |   16 --
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |    1 -
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |  241 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h   |   70 ------
 6 files changed, 330 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
 delete mode 100644 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
index 80b00e2..e227c4c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmsmac/Makefile
@@ -40,7 +40,6 @@ BRCMSMAC_OFILES := \
 	phy/phytbl_n.o \
 	phy/phy_qmath.o \
 	dma.o \
-	nicpci.o \
 	brcms_trace_events.o
 
 MODULEPFX := brcmsmac
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 8908c89..dd4698d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -19,7 +19,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/delay.h>
-#include <linux/pci.h>
 
 #include <defs.h>
 #include <chipcommon.h>
@@ -29,7 +28,6 @@
 #include "types.h"
 #include "pub.h"
 #include "pmu.h"
-#include "nicpci.h"
 #include "aiutils.h"
 
 /* slow_clk_ctl */
@@ -478,13 +476,6 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 	/* figure out buscore */
 	sii->buscore = ai_findcore(&sii->pub, PCIE_CORE_ID, 0);
 
-	/* fixup necessary chip/core configurations */
-	if (!sii->pch) {
-		sii->pch = pcicore_init(&sii->pub, sii->icbus->drv_pci.core);
-		if (sii->pch == NULL)
-			return false;
-	}
-
 	return true;
 }
 
@@ -565,9 +556,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	return sii;
 
  exit:
-	if (sii->pch)
-		pcicore_deinit(sii->pch);
-	sii->pch = NULL;
 
 	return NULL;
 }
@@ -606,10 +594,6 @@ void ai_detach(struct si_pub *sih)
 	if (sii == NULL)
 		return;
 
-	if (sii->pch)
-		pcicore_deinit(sii->pch);
-	sii->pch = NULL;
-
 	kfree(sii);
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index da758c3..d9f04a6 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -168,7 +168,6 @@ struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
 	struct bcma_bus *icbus;	/* handle to soc interconnect bus */
 	struct pci_dev *pcibus;	/* handle to pci bus */
-	struct pcicore_info *pch; /* PCI/E core handle */
 	struct bcma_device *buscore;
 
 	u32 chipst;		/* chip status */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index aa15558..b8350ff 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -25,7 +25,6 @@
 #include <linux/bcma/bcma.h>
 #include <net/mac80211.h>
 #include <defs.h>
-#include "nicpci.h"
 #include "phy/phy_int.h"
 #include "d11.h"
 #include "channel.h"
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
deleted file mode 100644
index cd3899b7..0000000
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ /dev/null
@@ -1,241 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <linux/slab.h>
-#include <linux/delay.h>
-#include <linux/pci.h>
-
-#include <defs.h>
-#include <soc.h>
-#include <chipcommon.h>
-#include "aiutils.h"
-#include "pub.h"
-#include "nicpci.h"
-
-/* SPROM offsets */
-#define SRSH_ASPM_OFFSET		4	/* word 4 */
-#define SRSH_ASPM_ENB			0x18	/* bit 3, 4 */
-#define SRSH_ASPM_L1_ENB		0x10	/* bit 4 */
-#define SRSH_ASPM_L0s_ENB		0x8	/* bit 3 */
-
-#define SRSH_PCIE_MISC_CONFIG		5	/* word 5 */
-#define SRSH_L23READY_EXIT_NOPERST	0x8000	/* bit 15 */
-#define SRSH_CLKREQ_OFFSET_REV5		20	/* word 20 for srom rev <= 5 */
-#define SRSH_CLKREQ_ENB			0x0800	/* bit 11 */
-#define SRSH_BD_OFFSET                  6	/* word 6 */
-
-/* chipcontrol */
-#define CHIPCTRL_4321_PLL_DOWN		0x800000/* serdes PLL down override */
-
-/* MDIO control */
-#define MDIOCTL_DIVISOR_MASK		0x7f	/* clock to be used on MDIO */
-#define MDIOCTL_DIVISOR_VAL		0x2
-#define MDIOCTL_PREAM_EN		0x80	/* Enable preamble sequnce */
-#define MDIOCTL_ACCESS_DONE		0x100	/* Transaction complete */
-
-/* MDIO Data */
-#define MDIODATA_MASK			0x0000ffff	/* data 2 bytes */
-#define MDIODATA_TA			0x00020000	/* Turnaround */
-
-#define MDIODATA_REGADDR_SHF		18		/* Regaddr shift */
-#define MDIODATA_REGADDR_MASK		0x007c0000	/* Regaddr Mask */
-#define MDIODATA_DEVADDR_SHF		23	/* Physmedia devaddr shift */
-#define MDIODATA_DEVADDR_MASK		0x0f800000
-						/* Physmedia devaddr Mask */
-
-/* MDIO Data for older revisions < 10 */
-#define MDIODATA_REGADDR_SHF_OLD	18	/* Regaddr shift */
-#define MDIODATA_REGADDR_MASK_OLD	0x003c0000
-						/* Regaddr Mask */
-#define MDIODATA_DEVADDR_SHF_OLD	22	/* Physmedia devaddr shift  */
-#define MDIODATA_DEVADDR_MASK_OLD	0x0fc00000
-						/* Physmedia devaddr Mask */
-
-/* Transactions flags */
-#define MDIODATA_WRITE			0x10000000
-#define MDIODATA_READ			0x20000000
-#define MDIODATA_START			0x40000000
-
-#define MDIODATA_DEV_ADDR		0x0	/* dev address for serdes */
-#define	MDIODATA_BLK_ADDR		0x1F	/* blk address for serdes */
-
-/* serdes regs (rev < 10) */
-#define MDIODATA_DEV_PLL		0x1d	/* SERDES PLL Dev */
-#define MDIODATA_DEV_TX			0x1e	/* SERDES TX Dev */
-#define MDIODATA_DEV_RX			0x1f	/* SERDES RX Dev */
-
-/* SERDES RX registers */
-#define SERDES_RX_CTRL			1	/* Rx cntrl */
-#define SERDES_RX_TIMER1		2	/* Rx Timer1 */
-#define SERDES_RX_CDR			6	/* CDR */
-#define SERDES_RX_CDRBW			7	/* CDR BW */
-/* SERDES RX control register */
-#define SERDES_RX_CTRL_FORCE		0x80	/* rxpolarity_force */
-#define SERDES_RX_CTRL_POLARITY		0x40	/* rxpolarity_value */
-
-/* SERDES PLL registers */
-#define SERDES_PLL_CTRL                 1	/* PLL control reg */
-#define PLL_CTRL_FREQDET_EN             0x4000	/* bit 14 is FREQDET on */
-
-/* Linkcontrol reg offset in PCIE Cap */
-#define PCIE_CAP_LINKCTRL_OFFSET	16	/* offset in pcie cap */
-#define PCIE_CAP_LCREG_ASPML0s		0x01	/* ASPM L0s in linkctrl */
-#define PCIE_CAP_LCREG_ASPML1		0x02	/* ASPM L1 in linkctrl */
-#define PCIE_CLKREQ_ENAB		0x100	/* CLKREQ Enab in linkctrl */
-
-#define PCIE_ASPM_ENAB			3	/* ASPM L0s & L1 in linkctrl */
-#define PCIE_ASPM_L1_ENAB		2	/* ASPM L0s & L1 in linkctrl */
-#define PCIE_ASPM_L0s_ENAB		1	/* ASPM L0s & L1 in linkctrl */
-#define PCIE_ASPM_DISAB			0	/* ASPM L0s & L1 in linkctrl */
-
-/* Power management threshold */
-#define PCIE_L1THRESHOLDTIME_MASK       0xFF00	/* bits 8 - 15 */
-#define PCIE_L1THRESHOLDTIME_SHIFT      8	/* PCIE_L1THRESHOLDTIME_SHIFT */
-#define PCIE_L1THRESHOLD_WARVAL         0x72	/* WAR value */
-#define PCIE_ASPMTIMER_EXTEND		0x01000000
-						/* > rev7:
-						 * enable extend ASPM timer
-						 */
-
-/* different register spaces to access thru pcie indirect access */
-#define PCIE_CONFIGREGS		1	/* Access to config space */
-#define PCIE_PCIEREGS		2	/* Access to pcie registers */
-
-/* PCIE protocol PHY diagnostic registers */
-#define	PCIE_PLP_STATUSREG		0x204	/* Status */
-
-/* Status reg PCIE_PLP_STATUSREG */
-#define PCIE_PLP_POLARITYINV_STAT	0x10
-
-/* PCIE protocol DLLP diagnostic registers */
-#define PCIE_DLLP_LCREG			0x100	/* Link Control */
-#define PCIE_DLLP_PMTHRESHREG		0x128	/* Power Management Threshold */
-
-/* PCIE protocol TLP diagnostic registers */
-#define PCIE_TLP_WORKAROUNDSREG		0x004	/* TLP Workarounds */
-
-/* Sonics to PCI translation types */
-#define	SBTOPCI_PREF	0x4		/* prefetch enable */
-#define	SBTOPCI_BURST	0x8		/* burst enable */
-#define	SBTOPCI_RC_READMULTI	0x20	/* memory read multiple */
-
-#define PCI_CLKRUN_DSBL	0x8000	/* Bit 15 forceClkrun */
-
-/* PCI core index in SROM shadow area */
-#define SRSH_PI_OFFSET	0	/* first word */
-#define SRSH_PI_MASK	0xf000	/* bit 15:12 */
-#define SRSH_PI_SHIFT	12	/* bit 15:12 */
-
-#define PCIREGOFFS(field)	offsetof(struct sbpciregs, field)
-#define PCIEREGOFFS(field)	offsetof(struct sbpcieregs, field)
-
-/* Sonics side: PCI core and host control registers */
-struct sbpciregs {
-	u32 control;		/* PCI control */
-	u32 PAD[3];
-	u32 arbcontrol;		/* PCI arbiter control */
-	u32 clkrun;		/* Clkrun Control (>=rev11) */
-	u32 PAD[2];
-	u32 intstatus;		/* Interrupt status */
-	u32 intmask;		/* Interrupt mask */
-	u32 sbtopcimailbox;	/* Sonics to PCI mailbox */
-	u32 PAD[9];
-	u32 bcastaddr;		/* Sonics broadcast address */
-	u32 bcastdata;		/* Sonics broadcast data */
-	u32 PAD[2];
-	u32 gpioin;		/* ro: gpio input (>=rev2) */
-	u32 gpioout;		/* rw: gpio output (>=rev2) */
-	u32 gpioouten;		/* rw: gpio output enable (>= rev2) */
-	u32 gpiocontrol;	/* rw: gpio control (>= rev2) */
-	u32 PAD[36];
-	u32 sbtopci0;		/* Sonics to PCI translation 0 */
-	u32 sbtopci1;		/* Sonics to PCI translation 1 */
-	u32 sbtopci2;		/* Sonics to PCI translation 2 */
-	u32 PAD[189];
-	u32 pcicfg[4][64];	/* 0x400 - 0x7FF, PCI Cfg Space (>=rev8) */
-	u16 sprom[36];		/* SPROM shadow Area */
-	u32 PAD[46];
-};
-
-/* SB side: PCIE core and host control registers */
-struct sbpcieregs {
-	u32 control;		/* host mode only */
-	u32 PAD[2];
-	u32 biststatus;		/* bist Status: 0x00C */
-	u32 gpiosel;		/* PCIE gpio sel: 0x010 */
-	u32 gpioouten;		/* PCIE gpio outen: 0x14 */
-	u32 PAD[2];
-	u32 intstatus;		/* Interrupt status: 0x20 */
-	u32 intmask;		/* Interrupt mask: 0x24 */
-	u32 sbtopcimailbox;	/* sb to pcie mailbox: 0x028 */
-	u32 PAD[53];
-	u32 sbtopcie0;		/* sb to pcie translation 0: 0x100 */
-	u32 sbtopcie1;		/* sb to pcie translation 1: 0x104 */
-	u32 sbtopcie2;		/* sb to pcie translation 2: 0x108 */
-	u32 PAD[5];
-
-	/* pcie core supports in direct access to config space */
-	u32 configaddr;	/* pcie config space access: Address field: 0x120 */
-	u32 configdata;	/* pcie config space access: Data field: 0x124 */
-
-	/* mdio access to serdes */
-	u32 mdiocontrol;	/* controls the mdio access: 0x128 */
-	u32 mdiodata;		/* Data to the mdio access: 0x12c */
-
-	/* pcie protocol phy/dllp/tlp register indirect access mechanism */
-	u32 pcieindaddr;	/* indirect access to
-				 * the internal register: 0x130
-				 */
-	u32 pcieinddata;	/* Data to/from the internal regsiter: 0x134 */
-
-	u32 clkreqenctrl;	/* >= rev 6, Clkreq rdma control : 0x138 */
-	u32 PAD[177];
-	u32 pciecfg[4][64];	/* 0x400 - 0x7FF, PCIE Cfg Space */
-	u16 sprom[64];		/* SPROM shadow Area */
-};
-
-struct pcicore_info {
-	struct bcma_device *core;
-	struct si_pub *sih;	/* System interconnect handle */
-	struct pci_dev *dev;
-
-	u8 pmecap_offset;	/* PM Capability offset in the config space */
-	bool pmecap;		/* Capable of generating PME */
-};
-
-/* Initialize the PCI core.
- * It's caller's responsibility to make sure that this is done only once
- */
-struct pcicore_info *pcicore_init(struct si_pub *sih, struct bcma_device *core)
-{
-	struct pcicore_info *pi;
-
-	/* alloc struct pcicore_info */
-	pi = kzalloc(sizeof(struct pcicore_info), GFP_ATOMIC);
-	if (pi == NULL)
-		return NULL;
-
-	pi->sih = sih;
-	pi->dev = core->bus->host_pci;
-	pi->core = core;
-
-	return pi;
-}
-
-void pcicore_deinit(struct pcicore_info *pch)
-{
-	kfree(pch);
-}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
deleted file mode 100644
index cbd426e..0000000
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ /dev/null
@@ -1,70 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#ifndef	_BRCM_NICPCI_H_
-#define	_BRCM_NICPCI_H_
-
-#include "types.h"
-
-/* PCI configuration address space size */
-#define PCI_SZPCR		256
-
-/* Brcm PCI configuration registers */
-/* backplane address space accessed by BAR0 */
-#define PCI_BAR0_WIN		0x80
-/* sprom property control */
-#define PCI_SPROM_CONTROL	0x88
-/* mask of PCI and other cores interrupts */
-#define PCI_INT_MASK		0x94
-/* backplane core interrupt mask bits offset */
-#define  PCI_SBIM_SHIFT		8
-/* backplane address space accessed by second 4KB of BAR0 */
-#define PCI_BAR0_WIN2		0xac
-/* pci config space gpio input (>=rev3) */
-#define PCI_GPIO_IN		0xb0
-/* pci config space gpio output (>=rev3) */
-#define PCI_GPIO_OUT		0xb4
-/* pci config space gpio output enable (>=rev3) */
-#define PCI_GPIO_OUTEN		0xb8
-
-/* bar0 + 4K accesses external sprom */
-#define PCI_BAR0_SPROM_OFFSET	(4 * 1024)
-/* bar0 + 6K accesses pci core registers */
-#define PCI_BAR0_PCIREGS_OFFSET	(6 * 1024)
-/*
- * pci core SB registers are at the end of the
- * 8KB window, so their address is the "regular"
- * address plus 4K
- */
-#define PCI_BAR0_PCISBR_OFFSET	(4 * 1024)
-/* bar0 window size Match with corerev 13 */
-#define PCI_BAR0_WINSZ		(16 * 1024)
-/* On pci corerev >= 13 and all pcie, the bar0 is now 16KB and it maps: */
-/* bar0 + 8K accesses pci/pcie core registers */
-#define PCI_16KB0_PCIREGS_OFFSET (8 * 1024)
-/* bar0 + 12K accesses chipc core registers */
-#define PCI_16KB0_CCREGS_OFFSET	(12 * 1024)
-
-struct sbpciregs;
-struct sbpcieregs;
-
-extern struct pcicore_info *pcicore_init(struct si_pub *sih,
-					 struct bcma_device *core);
-extern void pcicore_deinit(struct pcicore_info *pch);
-extern void pcicore_up(struct pcicore_info *pch, int state);
-extern void pcicore_down(struct pcicore_info *pch, int state);
-
-#endif /* _BRCM_NICPCI_H_ */
-- 
1.7.9.5

