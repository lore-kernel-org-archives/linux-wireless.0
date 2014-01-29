Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:38045 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaA2Oce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:34 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 09/14] brcmfmac: make chip related functions host interface independent
Date: Wed, 29 Jan 2014 15:32:19 +0100
Message-ID: <1391005944-3220-10-git-send-email-arend@broadcom.com> (sfid-20140129_160006_107535_E11A8DCA)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch make several chip related functions host interface
independent by defining callback interface struct brcmf_buscore_ops.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 1151 +++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/chip.h     |  259 ++---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  200 ++--
 .../net/wireless/brcm80211/brcmfmac/sdio_host.h    |   90 +-
 4 files changed, 901 insertions(+), 799 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 37fd44a..29047ef 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011 Broadcom Corporation
+ * Copyright (c) 2014 Broadcom Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -13,25 +13,36 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
-/* ***** SDIO interface chip backplane handle functions ***** */
-
-#include <linux/types.h>
-#include <linux/netdevice.h>
-#include <linux/mmc/card.h>
-#include <linux/mmc/sdio_func.h>
-#include <linux/mmc/sdio_ids.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/list.h>
 #include <linux/ssb/ssb_regs.h>
 #include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_regs.h>
 
-#include <chipcommon.h>
+#include <defs.h>
+#include <soc.h>
 #include <brcm_hw_ids.h>
-#include <brcmu_wifi.h>
 #include <brcmu_utils.h>
-#include <soc.h>
+#include <chipcommon.h>
 #include "dhd_dbg.h"
-#include "sdio_host.h"
 #include "chip.h"
 
+/* SOC Interconnect types (aka chip types) */
+#define SOCI_SB		0
+#define SOCI_AI		1
+
+/* EROM CompIdentB */
+#define CIB_REV_MASK		0xff000000
+#define CIB_REV_SHIFT		24
+
+/* ARM CR4 core specific control flag bits */
+#define ARMCR4_BCMA_IOCTL_CPUHALT	0x0020
+
+/* D11 core specific control flag bits */
+#define D11_BCMA_IOCTL_PHYCLOCKEN	0x0004
+#define D11_BCMA_IOCTL_PHYRESET		0x0008
+
 /* chip core base & ramsize */
 /* bcm4329 */
 /* SDIO device core, ID 0x829 */
@@ -51,20 +62,58 @@
 #define BCM43143_CORE_ARM_BASE		0x18003000
 #define BCM43143_RAMSIZE		0x70000
 
-/* All D11 cores, ID 0x812 */
-#define BCM43xx_CORE_D11_BASE		0x18001000
-
+#define CORE_SB(base, field) \
+		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
 #define	SBCOREREV(sbidh) \
 	((((sbidh) & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT) | \
 	  ((sbidh) & SSB_IDHIGH_RCLO))
 
-/* SOC Interconnect types (aka chip types) */
-#define SOCI_SB		0
-#define SOCI_AI		1
-
-/* EROM CompIdentB */
-#define CIB_REV_MASK		0xff000000
-#define CIB_REV_SHIFT		24
+struct sbconfig {
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
+};
+
+struct brcmf_core_priv {
+	struct brcmf_core pub;
+	u32 wrapbase;
+	struct list_head list;
+	struct brcmf_chip_priv *chip;
+};
 
 /* ARM CR4 core specific control flag bits */
 #define ARMCR4_BCMA_IOCTL_CPUHALT	0x0020
@@ -73,350 +122,350 @@
 #define D11_BCMA_IOCTL_PHYCLOCKEN	0x0004
 #define D11_BCMA_IOCTL_PHYRESET		0x0008
 
-u8
-brcmf_sdio_chip_getinfidx(struct brcmf_chip *ci, u16 coreid)
-{
-	u8 idx;
-
-	for (idx = 0; idx < BRCMF_MAX_CORENUM; idx++)
-		if (coreid == ci->c_inf[idx].id)
-			return idx;
-
-	return BRCMF_MAX_CORENUM;
-}
-
-static u32
-brcmf_sdio_sb_corerev(struct brcmf_sdio_dev *sdiodev,
-		      struct brcmf_chip *ci, u16 coreid)
+struct brcmf_chip_priv {
+	struct brcmf_chip pub;
+	const struct brcmf_buscore_ops *ops;
+	void *ctx;
+	/* assured first core is chipcommon, second core is buscore */
+	struct list_head cores;
+	u16 num_cores;
+
+	bool (*iscoreup)(struct brcmf_core_priv *core);
+	void (*coredisable)(struct brcmf_core_priv *core, u32 prereset,
+			    u32 reset);
+	void (*resetcore)(struct brcmf_core_priv *core, u32 prereset, u32 reset,
+			  u32 postreset);
+};
+
+static void brcmf_chip_sb_corerev(struct brcmf_chip_priv *ci,
+				  struct brcmf_core *core)
 {
 	u32 regdata;
-	u8 idx;
 
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbidhigh),
-				    NULL);
-	return SBCOREREV(regdata);
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(core->base, sbidhigh));
+	core->rev = SBCOREREV(regdata);
 }
 
-static u32
-brcmf_sdio_ai_corerev(struct brcmf_sdio_dev *sdiodev,
-		      struct brcmf_chip *ci, u16 coreid)
-{
-	u8 idx;
-
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-
-	return (ci->c_inf[idx].cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
-}
-
-static bool
-brcmf_sdio_sb_iscoreup(struct brcmf_sdio_dev *sdiodev,
-		       struct brcmf_chip *ci, u16 coreid)
+static bool brcmf_chip_sb_iscoreup(struct brcmf_core_priv *core)
 {
+	struct brcmf_chip_priv *ci;
 	u32 regdata;
-	u8 idx;
-
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-	if (idx == BRCMF_MAX_CORENUM)
-		return false;
+	u32 address;
 
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				    NULL);
+	ci = core->chip;
+	address = CORE_SB(core->pub.base, sbtmstatelow);
+	regdata = ci->ops->read32(ci->ctx, address);
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
 	return SSB_TMSLOW_CLOCK == regdata;
 }
 
-static bool
-brcmf_sdio_ai_iscoreup(struct brcmf_sdio_dev *sdiodev,
-		       struct brcmf_chip *ci, u16 coreid)
+static bool brcmf_chip_ai_iscoreup(struct brcmf_core_priv *core)
 {
+	struct brcmf_chip_priv *ci;
 	u32 regdata;
-	u8 idx;
 	bool ret;
 
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-	if (idx == BRCMF_MAX_CORENUM)
-		return false;
-
-	regdata = brcmf_sdiod_regrl(sdiodev, ci->c_inf[idx].wrapbase+BCMA_IOCTL,
-				    NULL);
+	ci = core->chip;
+	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
 
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    ci->c_inf[idx].wrapbase+BCMA_RESET_CTL,
-				    NULL);
+	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
 	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
 
 	return ret;
 }
 
-static void
-brcmf_sdio_sb_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
-			  u32 in_resetbits)
+static void brcmf_chip_sb_coredisable(struct brcmf_core_priv *core,
+				      u32 prereset, u32 reset)
 {
-	u32 regdata, base;
-	u8 idx;
+	struct brcmf_chip_priv *ci;
+	u32 val, base;
 
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-	base = ci->c_inf[idx].base;
-
-	regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
-	if (regdata & SSB_TMSLOW_RESET)
+	ci = core->chip;
+	base = core->pub.base;
+	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+	if (val & SSB_TMSLOW_RESET)
 		return;
 
-	regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbtmstatelow), NULL);
-	if ((regdata & SSB_TMSLOW_CLOCK) != 0) {
+	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+	if ((val & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
-		regdata = brcmf_sdiod_regrl(sdiodev,
-					    CORE_SB(base, sbtmstatelow), NULL);
-		brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
-				  regdata | SSB_TMSLOW_REJECT, NULL);
+		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+					 val | SSB_TMSLOW_REJECT);
 
-		regdata = brcmf_sdiod_regrl(sdiodev,
-					    CORE_SB(base, sbtmstatelow), NULL);
+		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
 		udelay(1);
-		SPINWAIT((brcmf_sdiod_regrl(sdiodev,
-					    CORE_SB(base, sbtmstatehigh),
-					    NULL) &
-			  SSB_TMSHIGH_BUSY), 100000);
-
-		regdata = brcmf_sdiod_regrl(sdiodev,
-					    CORE_SB(base, sbtmstatehigh),
-					    NULL);
-		if (regdata & SSB_TMSHIGH_BUSY)
+		SPINWAIT((ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh))
+			  & SSB_TMSHIGH_BUSY), 100000);
+
+		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
+		if (val & SSB_TMSHIGH_BUSY)
 			brcmf_err("core state still busy\n");
 
-		regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbidlow),
-					    NULL);
-		if (regdata & SSB_IDLOW_INITIATOR) {
-			regdata = brcmf_sdiod_regrl(sdiodev,
-						    CORE_SB(base, sbimstate),
-						    NULL);
-			regdata |= SSB_IMSTATE_REJECT;
-			brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbimstate),
-					  regdata, NULL);
-			regdata = brcmf_sdiod_regrl(sdiodev,
-						    CORE_SB(base, sbimstate),
-						    NULL);
+		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
+		if (val & SSB_IDLOW_INITIATOR) {
+			val = ci->ops->read32(ci->ctx,
+					      CORE_SB(base, sbimstate));
+			val |= SSB_IMSTATE_REJECT;
+			ci->ops->write32(ci->ctx,
+					 CORE_SB(base, sbimstate), val);
+			val = ci->ops->read32(ci->ctx,
+					      CORE_SB(base, sbimstate));
 			udelay(1);
-			SPINWAIT((brcmf_sdiod_regrl(sdiodev,
-						    CORE_SB(base, sbimstate),
-						    NULL) &
+			SPINWAIT((ci->ops->read32(ci->ctx,
+						  CORE_SB(base, sbimstate)) &
 				  SSB_IMSTATE_BUSY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
-		regdata = SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
-			  SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET;
-		brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
-				  regdata, NULL);
-		regdata = brcmf_sdiod_regrl(sdiodev,
-					    CORE_SB(base, sbtmstatelow), NULL);
+		val = SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
+		      SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET;
+		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow), val);
+		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
 		udelay(10);
 
 		/* clear the initiator reject bit */
-		regdata = brcmf_sdiod_regrl(sdiodev, CORE_SB(base, sbidlow),
-					    NULL);
-		if (regdata & SSB_IDLOW_INITIATOR) {
-			regdata = brcmf_sdiod_regrl(sdiodev,
-						    CORE_SB(base, sbimstate),
-						    NULL);
-			regdata &= ~SSB_IMSTATE_REJECT;
-			brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbimstate),
-					  regdata, NULL);
+		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
+		if (val & SSB_IDLOW_INITIATOR) {
+			val = ci->ops->read32(ci->ctx,
+					      CORE_SB(base, sbimstate));
+			val &= ~SSB_IMSTATE_REJECT;
+			ci->ops->write32(ci->ctx,
+					 CORE_SB(base, sbimstate), val);
 		}
 	}
 
 	/* leave reset and reject asserted */
-	brcmf_sdiod_regwl(sdiodev, CORE_SB(base, sbtmstatelow),
-			  (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET), NULL);
+	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+			 (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 	udelay(1);
 }
 
-static void
-brcmf_sdio_ai_coredisable(struct brcmf_sdio_dev *sdiodev,
-			  struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
-			  u32 in_resetbits)
+static void brcmf_chip_ai_coredisable(struct brcmf_core_priv *core,
+				      u32 prereset, u32 reset)
 {
-	u8 idx;
+	struct brcmf_chip_priv *ci;
 	u32 regdata;
-	u32 wrapbase;
-
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-	if (idx == BRCMF_MAX_CORENUM)
-		return;
 
-	wrapbase = ci->c_inf[idx].wrapbase;
+	ci = core->chip;
 
 	/* if core is already in reset, just return */
-	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL);
+	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		return;
 
 	/* configure reset */
-	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, pre_resetbits |
-			  BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
+	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
+			 prereset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 
 	/* put in reset */
-	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_RESET_CTL,
-			  BCMA_RESET_CTL_RESET, NULL);
+	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_RESET_CTL,
+			 BCMA_RESET_CTL_RESET);
 	usleep_range(10, 20);
 
 	/* wait till reset is 1 */
-	SPINWAIT(brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL) !=
+	SPINWAIT(ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) !=
 		 BCMA_RESET_CTL_RESET, 300);
 
-	/* post reset configure */
-	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, pre_resetbits |
-			  BCMA_IOCTL_FGC | BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
+	/* in-reset configure */
+	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
+			 reset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 }
 
-static void
-brcmf_sdio_sb_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct brcmf_chip *ci, u16 coreid,  u32 pre_resetbits,
-			u32 in_resetbits, u32 post_resetbits)
+static void brcmf_chip_sb_resetcore(struct brcmf_core_priv *core, u32 prereset,
+				    u32 reset, u32 postreset)
 {
+	struct brcmf_chip_priv *ci;
 	u32 regdata;
-	u8 idx;
-
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-	if (idx == BRCMF_MAX_CORENUM)
-		return;
+	u32 base;
 
+	ci = core->chip;
+	base = core->pub.base;
 	/*
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdio_sb_coredisable(sdiodev, ci, coreid, pre_resetbits,
-				  in_resetbits);
+	brcmf_chip_sb_coredisable(core, 0, 0);
 
 	/*
 	 * Now do the initialization sequence.
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	brcmf_sdiod_regwl(sdiodev,
-			  CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			  SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET,
-			  NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				    NULL);
+	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
+			 SSB_TMSLOW_RESET);
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
 	udelay(1);
 
 	/* clear any serror */
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
-				    NULL);
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
 	if (regdata & SSB_TMSHIGH_SERR)
-		brcmf_sdiod_regwl(sdiodev,
-				  CORE_SB(ci->c_inf[idx].base, sbtmstatehigh),
-				  0, NULL);
-
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbimstate),
-				    NULL);
-	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
-		brcmf_sdiod_regwl(sdiodev,
-				  CORE_SB(ci->c_inf[idx].base, sbimstate),
-				  regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO),
-				  NULL);
+		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatehigh), 0);
+
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbimstate));
+	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO)) {
+		regdata &= ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO);
+		ci->ops->write32(ci->ctx, CORE_SB(base, sbimstate), regdata);
+	}
 
 	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdiod_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			  SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				    NULL);
+	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdiod_regwl(sdiodev, CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-			  SSB_TMSLOW_CLOCK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_SB(ci->c_inf[idx].base, sbtmstatelow),
-				    NULL);
+	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+			 SSB_TMSLOW_CLOCK);
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
 	udelay(1);
 }
 
-static void
-brcmf_sdio_ai_resetcore(struct brcmf_sdio_dev *sdiodev,
-			struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
-			u32 in_resetbits, u32 post_resetbits)
+static void brcmf_chip_ai_resetcore(struct brcmf_core_priv *core, u32 prereset,
+				    u32 reset, u32 postreset)
 {
-	u8 idx;
-	u32 regdata;
-	u32 wrapbase;
+	struct brcmf_chip_priv *ci;
+	int count;
 
-	idx = brcmf_sdio_chip_getinfidx(ci, coreid);
-	if (idx == BRCMF_MAX_CORENUM)
-		return;
-
-	wrapbase = ci->c_inf[idx].wrapbase;
+	ci = core->chip;
 
 	/* must disable first to work for arbitrary current core state */
-	brcmf_sdio_ai_coredisable(sdiodev, ci, coreid, pre_resetbits,
-				  in_resetbits);
+	brcmf_chip_ai_coredisable(core, prereset, reset);
 
-	while (brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_RESET_CTL, NULL) &
+	count = 0;
+	while (ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) &
 	       BCMA_RESET_CTL_RESET) {
-		brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_RESET_CTL, 0, NULL);
+		ci->ops->write32(ci->ctx, core->wrapbase + BCMA_RESET_CTL, 0);
+		count++;
+		if (count > 50)
+			break;
 		usleep_range(40, 60);
 	}
 
-	brcmf_sdiod_regwl(sdiodev, wrapbase + BCMA_IOCTL, post_resetbits |
-			  BCMA_IOCTL_CLK, NULL);
-	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
+	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
+			 postreset | BCMA_IOCTL_CLK);
+	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
+}
+
+static char *brcmf_chip_name(uint chipid, char *buf, uint len)
+{
+	const char *fmt;
+
+	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
+	snprintf(buf, len, fmt, chipid);
+	return buf;
+}
+
+static struct brcmf_core *brcmf_chip_add_core(struct brcmf_chip_priv *ci,
+					      u16 coreid, u32 base,
+					      u32 wrapbase)
+{
+	struct brcmf_core_priv *core;
+
+	core = kzalloc(sizeof(*core), GFP_KERNEL);
+	if (!core)
+		return ERR_PTR(-ENOMEM);
+
+	core->pub.id = coreid;
+	core->pub.base = base;
+	core->chip = ci;
+	core->wrapbase = wrapbase;
+
+	list_add_tail(&core->list, &ci->cores);
+	return &core->pub;
 }
 
 #ifdef DEBUG
 /* safety check for chipinfo */
-static int brcmf_sdio_chip_cichk(struct brcmf_chip *ci)
+static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 {
-	u8 core_idx;
-
-	/* check RAM core presence for ARM CM3 core */
-	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
-	if (BRCMF_MAX_CORENUM != core_idx) {
-		core_idx = brcmf_sdio_chip_getinfidx(ci,
-						     BCMA_CORE_INTERNAL_MEM);
-		if (BRCMF_MAX_CORENUM == core_idx) {
-			brcmf_err("RAM core not provided with ARM CM3 core\n");
-			return -ENODEV;
+	struct brcmf_core_priv *core;
+	bool need_socram = false;
+	bool has_socram = false;
+	int idx = 1;
+
+	list_for_each_entry(core, &ci->cores, list) {
+		brcmf_dbg(INFO, " [%-2d] core 0x%x rev %-2d base 0x%08x\n",
+			  idx++, core->pub.id, core->pub.rev, core->pub.base);
+
+		switch (core->pub.id) {
+		case BCMA_CORE_ARM_CM3:
+			need_socram = true;
+			break;
+		case BCMA_CORE_INTERNAL_MEM:
+			has_socram = true;
+			break;
+		case BCMA_CORE_ARM_CR4:
+			if (ci->pub.rambase == 0) {
+				brcmf_err("RAM base not provided with ARM CR4 core\n");
+				return -ENOMEM;
+			}
+			break;
+		default:
+			break;
 		}
 	}
 
-	/* check RAM base for ARM CR4 core */
-	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CR4);
-	if (BRCMF_MAX_CORENUM != core_idx) {
-		if (ci->rambase == 0) {
-			brcmf_err("RAM base not provided with ARM CR4 core\n");
-			return -ENOMEM;
-		}
+	/* check RAM core presence for ARM CM3 core */
+	if (need_socram && !has_socram) {
+		brcmf_err("RAM core not provided with ARM CM3 core\n");
+		return -ENODEV;
 	}
-
 	return 0;
 }
 #else	/* DEBUG */
-static inline int brcmf_sdio_chip_cichk(struct brcmf_chip *ci)
+static inline int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 {
 	return 0;
 }
 #endif
 
-static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
-				       struct brcmf_chip *ci)
+static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
+{
+	switch (ci->pub.chip) {
+	case BCM4329_CHIP_ID:
+		ci->pub.ramsize = BCM4329_RAMSIZE;
+		break;
+	case BCM43143_CHIP_ID:
+		ci->pub.ramsize = BCM43143_RAMSIZE;
+		break;
+	case BCM43241_CHIP_ID:
+		ci->pub.ramsize = 0x90000;
+		break;
+	case BCM4330_CHIP_ID:
+		ci->pub.ramsize = 0x48000;
+		break;
+	case BCM4334_CHIP_ID:
+		ci->pub.ramsize = 0x80000;
+		break;
+	case BCM4335_CHIP_ID:
+		ci->pub.ramsize = 0xc0000;
+		ci->pub.rambase = 0x180000;
+		break;
+	case BCM43362_CHIP_ID:
+		ci->pub.ramsize = 0x3c000;
+		break;
+	case BCM4339_CHIP_ID:
+		ci->pub.ramsize = 0xc0000;
+		ci->pub.rambase = 0x180000;
+		break;
+	default:
+		brcmf_err("unknown chip: %s\n", ci->pub.name);
+		break;
+	}
+}
+
+static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 {
+	struct brcmf_core *core;
 	u32 regdata;
 	u32 socitype;
 
@@ -425,184 +474,131 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 	 * For different chiptypes or old sdio hosts w/o chipcommon,
 	 * other ways of recognition should be added here.
 	 */
-	regdata = brcmf_sdiod_regrl(sdiodev,
-				    CORE_CC_REG(SI_ENUM_BASE, chipid),
-				    NULL);
-	ci->chip = regdata & CID_ID_MASK;
-	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
-	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
-	    ci->chiprev >= 2)
-		ci->chip = BCM4339_CHIP_ID;
+	regdata = ci->ops->read32(ci->ctx, CORE_CC_REG(SI_ENUM_BASE, chipid));
+	ci->pub.chip = regdata & CID_ID_MASK;
+	ci->pub.chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
-	brcmf_dbg(INFO, "found %s chip: id=0x%x, rev=%d\n",
-		  socitype == SOCI_SB ? "SB" : "AXI", ci->chip, ci->chiprev);
+	brcmf_chip_name(ci->pub.chip, ci->pub.name, sizeof(ci->pub.name));
+	brcmf_dbg(INFO, "found %s chip: BCM%s, rev=%d\n",
+		  socitype == SOCI_SB ? "SB" : "AXI", ci->pub.name,
+		  ci->pub.chiprev);
 
 	if (socitype == SOCI_SB) {
-		if (ci->chip != BCM4329_CHIP_ID) {
+		if (ci->pub.chip != BCM4329_CHIP_ID) {
 			brcmf_err("SB chip is not supported\n");
 			return -ENODEV;
 		}
-		ci->iscoreup = brcmf_sdio_sb_iscoreup;
-		ci->corerev = brcmf_sdio_sb_corerev;
-		ci->coredisable = brcmf_sdio_sb_coredisable;
-		ci->resetcore = brcmf_sdio_sb_resetcore;
-
-		ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
-		ci->c_inf[0].base = SI_ENUM_BASE;
-		ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-		ci->c_inf[1].base = BCM4329_CORE_BUS_BASE;
-		ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-		ci->c_inf[2].base = BCM4329_CORE_SOCRAM_BASE;
-		ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-		ci->c_inf[3].base = BCM4329_CORE_ARM_BASE;
-		ci->c_inf[4].id = BCMA_CORE_80211;
-		ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-		ci->ramsize = BCM4329_RAMSIZE;
+		ci->iscoreup = brcmf_chip_sb_iscoreup;
+		ci->coredisable = brcmf_chip_sb_coredisable;
+		ci->resetcore = brcmf_chip_sb_resetcore;
+
+		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
+					   SI_ENUM_BASE, 0);
+		brcmf_chip_sb_corerev(ci, core);
+		core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+					   BCM4329_CORE_BUS_BASE, 0);
+		brcmf_chip_sb_corerev(ci, core);
+		core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
+					   BCM4329_CORE_SOCRAM_BASE, 0);
+		brcmf_chip_sb_corerev(ci, core);
+		core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
+					   BCM4329_CORE_ARM_BASE, 0);
+		brcmf_chip_sb_corerev(ci, core);
 	} else if (socitype == SOCI_AI) {
-		ci->iscoreup = brcmf_sdio_ai_iscoreup;
-		ci->corerev = brcmf_sdio_ai_corerev;
-		ci->coredisable = brcmf_sdio_ai_coredisable;
-		ci->resetcore = brcmf_sdio_ai_resetcore;
+		ci->iscoreup = brcmf_chip_ai_iscoreup;
+		ci->coredisable = brcmf_chip_ai_coredisable;
+		ci->resetcore = brcmf_chip_ai_resetcore;
 
-		ci->c_inf[0].id = BCMA_CORE_CHIPCOMMON;
-		ci->c_inf[0].base = SI_ENUM_BASE;
+		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
+					   SI_ENUM_BASE,
+					   SI_ENUM_BASE + 0x100000);
 
 		/* Address of cores for new chips should be added here */
-		switch (ci->chip) {
+		switch (ci->pub.chip) {
 		case BCM43143_CHIP_ID:
-			ci->c_inf[0].wrapbase = ci->c_inf[0].base + 0x00100000;
-			ci->c_inf[0].cib = 0x2b000000;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = BCM43143_CORE_BUS_BASE;
-			ci->c_inf[1].wrapbase = ci->c_inf[1].base + 0x00100000;
-			ci->c_inf[1].cib = 0x18000000;
-			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-			ci->c_inf[2].base = BCM43143_CORE_SOCRAM_BASE;
-			ci->c_inf[2].wrapbase = ci->c_inf[2].base + 0x00100000;
-			ci->c_inf[2].cib = 0x14000000;
-			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-			ci->c_inf[3].base = BCM43143_CORE_ARM_BASE;
-			ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
-			ci->c_inf[3].cib = 0x07000000;
-			ci->c_inf[4].id = BCMA_CORE_80211;
-			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-			ci->ramsize = BCM43143_RAMSIZE;
+			core->rev = 43;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   BCM43143_CORE_BUS_BASE,
+						   BCM43143_CORE_BUS_BASE +
+						   0x100000);
+			core->rev = 24;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
+						   BCM43143_CORE_SOCRAM_BASE,
+						   BCM43143_CORE_SOCRAM_BASE +
+						   0x100000);
+			core->rev = 20;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
+						   BCM43143_CORE_ARM_BASE,
+						   BCM43143_CORE_ARM_BASE +
+						   0x100000);
+			core->rev = 7;
 			break;
 		case BCM43241_CHIP_ID:
-			ci->c_inf[0].wrapbase = 0x18100000;
-			ci->c_inf[0].cib = 0x2a084411;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = 0x18002000;
-			ci->c_inf[1].wrapbase = 0x18102000;
-			ci->c_inf[1].cib = 0x0e004211;
-			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-			ci->c_inf[2].base = 0x18004000;
-			ci->c_inf[2].wrapbase = 0x18104000;
-			ci->c_inf[2].cib = 0x14080401;
-			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-			ci->c_inf[3].base = 0x18003000;
-			ci->c_inf[3].wrapbase = 0x18103000;
-			ci->c_inf[3].cib = 0x07004211;
-			ci->c_inf[4].id = BCMA_CORE_80211;
-			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-			ci->ramsize = 0x90000;
+			core->rev = 42;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   0x18002000, 0x18102000);
+			core->rev = 14;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
+						   0x18004000, 0x18104000);
+			core->rev = 20;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
+						   0x18003000, 0x18103000);
+			core->rev = 7;
 			break;
 		case BCM4330_CHIP_ID:
-			ci->c_inf[0].wrapbase = 0x18100000;
-			ci->c_inf[0].cib = 0x27004211;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = 0x18002000;
-			ci->c_inf[1].wrapbase = 0x18102000;
-			ci->c_inf[1].cib = 0x07004211;
-			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-			ci->c_inf[2].base = 0x18004000;
-			ci->c_inf[2].wrapbase = 0x18104000;
-			ci->c_inf[2].cib = 0x0d080401;
-			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-			ci->c_inf[3].base = 0x18003000;
-			ci->c_inf[3].wrapbase = 0x18103000;
-			ci->c_inf[3].cib = 0x03004211;
-			ci->c_inf[4].id = BCMA_CORE_80211;
-			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-			ci->ramsize = 0x48000;
+			core->rev = 39;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   0x18002000, 0x18102000);
+			core->rev = 7;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
+						   0x18004000, 0x18104000);
+			core->rev = 13;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
+						   0x18003000, 0x18103000);
+			core->rev = 3;
 			break;
 		case BCM4334_CHIP_ID:
-			ci->c_inf[0].wrapbase = 0x18100000;
-			ci->c_inf[0].cib = 0x29004211;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = 0x18002000;
-			ci->c_inf[1].wrapbase = 0x18102000;
-			ci->c_inf[1].cib = 0x0d004211;
-			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-			ci->c_inf[2].base = 0x18004000;
-			ci->c_inf[2].wrapbase = 0x18104000;
-			ci->c_inf[2].cib = 0x13080401;
-			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-			ci->c_inf[3].base = 0x18003000;
-			ci->c_inf[3].wrapbase = 0x18103000;
-			ci->c_inf[3].cib = 0x07004211;
-			ci->c_inf[4].id = BCMA_CORE_80211;
-			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-			ci->ramsize = 0x80000;
+			core->rev = 41;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   0x18002000, 0x18102000);
+			core->rev = 13;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
+						   0x18004000, 0x18104000);
+			core->rev = 19;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
+						   0x18003000, 0x18103000);
+			core->rev = 7;
 			break;
 		case BCM4335_CHIP_ID:
-			ci->c_inf[0].wrapbase = 0x18100000;
-			ci->c_inf[0].cib = 0x2b084411;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = 0x18005000;
-			ci->c_inf[1].wrapbase = 0x18105000;
-			ci->c_inf[1].cib = 0x0f004211;
-			ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
-			ci->c_inf[2].base = 0x18002000;
-			ci->c_inf[2].wrapbase = 0x18102000;
-			ci->c_inf[2].cib = 0x01084411;
-			ci->c_inf[3].id = BCMA_CORE_80211;
-			ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
-			ci->ramsize = 0xc0000;
-			ci->rambase = 0x180000;
+			core->rev = 43;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   0x18005000, 0x18105000);
+			core->rev = 15;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CR4,
+						   0x18002000, 0x18102000);
+			core->rev = 1;
 			break;
 		case BCM43362_CHIP_ID:
-			ci->c_inf[0].wrapbase = 0x18100000;
-			ci->c_inf[0].cib = 0x27004211;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = 0x18002000;
-			ci->c_inf[1].wrapbase = 0x18102000;
-			ci->c_inf[1].cib = 0x0a004211;
-			ci->c_inf[2].id = BCMA_CORE_INTERNAL_MEM;
-			ci->c_inf[2].base = 0x18004000;
-			ci->c_inf[2].wrapbase = 0x18104000;
-			ci->c_inf[2].cib = 0x08080401;
-			ci->c_inf[3].id = BCMA_CORE_ARM_CM3;
-			ci->c_inf[3].base = 0x18003000;
-			ci->c_inf[3].wrapbase = 0x18103000;
-			ci->c_inf[3].cib = 0x03004211;
-			ci->c_inf[4].id = BCMA_CORE_80211;
-			ci->c_inf[4].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[4].wrapbase = ci->c_inf[4].base + 0x00100000;
-			ci->ramsize = 0x3C000;
+			core->rev = 39;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   0x18002000, 0x18102000);
+			core->rev = 10;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
+						   0x18004000, 0x18104000);
+			core->rev = 8;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
+						   0x18003000, 0x18103000);
+			core->rev = 3;
 			break;
 		case BCM4339_CHIP_ID:
-			ci->c_inf[0].wrapbase = 0x18100000;
-			ci->c_inf[0].cib = 0x2e084411;
-			ci->c_inf[1].id = BCMA_CORE_SDIO_DEV;
-			ci->c_inf[1].base = 0x18005000;
-			ci->c_inf[1].wrapbase = 0x18105000;
-			ci->c_inf[1].cib = 0x15004211;
-			ci->c_inf[2].id = BCMA_CORE_ARM_CR4;
-			ci->c_inf[2].base = 0x18002000;
-			ci->c_inf[2].wrapbase = 0x18102000;
-			ci->c_inf[2].cib = 0x04084411;
-			ci->c_inf[3].id = BCMA_CORE_80211;
-			ci->c_inf[3].base = BCM43xx_CORE_D11_BASE;
-			ci->c_inf[3].wrapbase = ci->c_inf[3].base + 0x00100000;
-			ci->ramsize = 0xc0000;
-			ci->rambase = 0x180000;
+			core->rev = 46;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
+						   0x18005000, 0x18105000);
+			core->rev = 21;
+			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CR4,
+						   0x18002000, 0x18102000);
+			core->rev = 4;
 			break;
 		default:
 			brcmf_err("AXI chip is not supported\n");
@@ -614,189 +610,322 @@ static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 		return -ENODEV;
 	}
 
-	return brcmf_sdio_chip_cichk(ci);
+	/* add 802.11 core for all chips on same backplane address */
+	core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0x18101000);
+
+	brcmf_chip_get_raminfo(ci);
+
+	return brcmf_chip_cores_check(ci);
 }
 
-static void
-brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
-			     struct brcmf_chip *ci)
+static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
 {
-	u32 base = ci->c_inf[0].base;
+	struct brcmf_core *core;
+	struct brcmf_core_priv *cr4;
+	u32 val;
+
 
-	/* get chipcommon rev */
-	ci->c_inf[0].rev = ci->corerev(sdiodev, ci, ci->c_inf[0].id);
+	core = brcmf_chip_get_core(&chip->pub, id);
+	if (!core)
+		return;
+
+	switch (id) {
+	case BCMA_CORE_ARM_CM3:
+		brcmf_chip_coredisable(core, 0, 0);
+		break;
+	case BCMA_CORE_ARM_CR4:
+		cr4 = container_of(core, struct brcmf_core_priv, pub);
+
+		/* clear all IOCTL bits except HALT bit */
+		val = chip->ops->read32(chip->ctx, cr4->wrapbase + BCMA_IOCTL);
+		val &= ARMCR4_BCMA_IOCTL_CPUHALT;
+		brcmf_chip_resetcore(core, val, ARMCR4_BCMA_IOCTL_CPUHALT,
+				     ARMCR4_BCMA_IOCTL_CPUHALT);
+		break;
+	default:
+		brcmf_err("unknown id: %u\n", id);
+		break;
+	}
+}
+
+static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
+{
+	struct brcmf_chip *pub;
+	struct brcmf_core_priv *cc;
+	struct brcmf_core_priv *bus;
+	u32 base;
+	u32 val;
+	int ret = 0;
+
+	pub = &chip->pub;
+	cc = list_first_entry(&chip->cores, struct brcmf_core_priv, list);
+	base = cc->pub.base;
 
 	/* get chipcommon capabilites */
-	ci->c_inf[0].caps = brcmf_sdiod_regrl(sdiodev,
-					      CORE_CC_REG(base, capabilities),
-					      NULL);
+	pub->cc_caps = chip->ops->read32(chip->ctx,
+					 CORE_CC_REG(base, capabilities));
 
 	/* get pmu caps & rev */
-	if (ci->c_inf[0].caps & CC_CAP_PMU) {
-		ci->pmucaps =
-			brcmf_sdiod_regrl(sdiodev,
-					  CORE_CC_REG(base, pmucapabilities),
-					  NULL);
-		ci->pmurev = ci->pmucaps & PCAP_REV_MASK;
+	if (pub->cc_caps & CC_CAP_PMU) {
+		val = chip->ops->read32(chip->ctx,
+					CORE_CC_REG(base, pmucapabilities));
+		pub->pmurev = val & PCAP_REV_MASK;
+		pub->pmucaps = val;
 	}
 
-	ci->c_inf[1].rev = ci->corerev(sdiodev, ci, ci->c_inf[1].id);
+	bus = list_next_entry(cc, list);
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		  ci->c_inf[0].rev, ci->pmurev,
-		  ci->c_inf[1].rev, ci->c_inf[1].id);
+		  cc->pub.rev, pub->pmurev, bus->pub.rev, bus->pub.id);
+
+	/* execute bus core specific setup */
+	if (chip->ops->setup)
+		ret = chip->ops->setup(chip->ctx, pub);
 
 	/*
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0);
+	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CM3);
+	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CR4);
+	return ret;
 }
 
-int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct brcmf_chip **ci_ptr)
+struct brcmf_chip *brcmf_chip_attach(void *ctx,
+				     const struct brcmf_buscore_ops *ops)
 {
-	int ret;
-	struct brcmf_chip *ci;
+	struct brcmf_chip_priv *chip;
+	int err = 0;
+
+	if (WARN_ON(!ops->read32))
+		err = -EINVAL;
+	if (WARN_ON(!ops->write32))
+		err = -EINVAL;
+	if (WARN_ON(!ops->prepare))
+		err = -EINVAL;
+	if (WARN_ON(!ops->exit_dl))
+		err = -EINVAL;
+	if (err < 0)
+		return ERR_PTR(-EINVAL);
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&chip->cores);
+	chip->num_cores = 0;
+	chip->ops = ops;
+	chip->ctx = ctx;
+
+	err = ops->prepare(ctx);
+	if (err < 0)
+		goto fail;
+
+	err = brcmf_chip_recognition(chip);
+	if (err < 0)
+		goto fail;
+
+	err = brcmf_chip_setup(chip);
+	if (err < 0)
+		goto fail;
+
+	return &chip->pub;
+
+fail:
+	brcmf_chip_detach(&chip->pub);
+	return ERR_PTR(err);
+}
 
-	brcmf_dbg(TRACE, "Enter\n");
+void brcmf_chip_detach(struct brcmf_chip *pub)
+{
+	struct brcmf_chip_priv *chip;
+	struct brcmf_core_priv *core;
+	struct brcmf_core_priv *tmp;
+
+	chip = container_of(pub, struct brcmf_chip_priv, pub);
+	list_for_each_entry_safe(core, tmp, &chip->cores, list) {
+		list_del(&core->list);
+		kfree(core);
+	}
+	kfree(chip);
+}
 
-	ci = kzalloc(sizeof(*ci), GFP_ATOMIC);
-	if (!ci)
-		return -ENOMEM;
+struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *pub, u16 coreid)
+{
+	struct brcmf_chip_priv *chip;
+	struct brcmf_core_priv *core;
 
-	ret = brcmf_sdio_buscoreprep(sdiodev);
-	if (ret != 0)
-		goto err;
+	chip = container_of(pub, struct brcmf_chip_priv, pub);
+	list_for_each_entry(core, &chip->cores, list)
+		if (core->pub.id == coreid)
+			return &core->pub;
 
-	ret = brcmf_sdio_chip_recognition(sdiodev, ci);
-	if (ret != 0)
-		goto err;
+	return NULL;
+}
 
-	brcmf_sdio_chip_buscoresetup(sdiodev, ci);
+struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *pub)
+{
+	struct brcmf_chip_priv *chip;
+	struct brcmf_core_priv *cc;
+
+	chip = container_of(pub, struct brcmf_chip_priv, pub);
+	cc = list_first_entry(&chip->cores, struct brcmf_core_priv, list);
+	if (WARN_ON(!cc || cc->pub.id != BCMA_CORE_CHIPCOMMON))
+		return brcmf_chip_get_core(pub, BCMA_CORE_CHIPCOMMON);
+	return &cc->pub;
+}
 
-	brcmf_sdiod_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopullup),
-			  0, NULL);
-	brcmf_sdiod_regwl(sdiodev, CORE_CC_REG(ci->c_inf[0].base, gpiopulldown),
-			  0, NULL);
+bool brcmf_chip_iscoreup(struct brcmf_core *pub)
+{
+	struct brcmf_core_priv *core;
 
-	*ci_ptr = ci;
-	return 0;
+	core = container_of(pub, struct brcmf_core_priv, pub);
+	return core->chip->iscoreup(core);
+}
 
-err:
-	kfree(ci);
-	return ret;
+void brcmf_chip_coredisable(struct brcmf_core *pub, u32 prereset, u32 reset)
+{
+	struct brcmf_core_priv *core;
+
+	core = container_of(pub, struct brcmf_core_priv, pub);
+	core->chip->coredisable(core, prereset, reset);
 }
 
-void
-brcmf_sdio_chip_detach(struct brcmf_chip **ci_ptr)
+void brcmf_chip_resetcore(struct brcmf_core *pub, u32 prereset, u32 reset,
+			  u32 postreset)
 {
-	brcmf_dbg(TRACE, "Enter\n");
+	struct brcmf_core_priv *core;
 
-	kfree(*ci_ptr);
-	*ci_ptr = NULL;
+	core = container_of(pub, struct brcmf_core_priv, pub);
+	core->chip->resetcore(core, prereset, reset, postreset);
 }
 
 static void
-brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
-			    struct brcmf_chip *ci)
+brcmf_chip_cm3_enterdl(struct brcmf_chip_priv *chip)
 {
-	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0);
-	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
-		      D11_BCMA_IOCTL_PHYRESET | D11_BCMA_IOCTL_PHYCLOCKEN,
-		      D11_BCMA_IOCTL_PHYCLOCKEN, D11_BCMA_IOCTL_PHYCLOCKEN);
-	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0, 0, 0);
+	struct brcmf_core *core;
+
+	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CM3);
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
+	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
+				   D11_BCMA_IOCTL_PHYCLOCKEN,
+			     D11_BCMA_IOCTL_PHYCLOCKEN,
+			     D11_BCMA_IOCTL_PHYCLOCKEN);
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_INTERNAL_MEM);
+	brcmf_chip_resetcore(core, 0, 0, 0);
 }
 
-static bool brcmf_sdio_chip_cm3_exitdl(struct brcmf_sdio_dev *sdiodev,
-				       struct brcmf_chip *ci)
+static bool brcmf_chip_cm3_exitdl(struct brcmf_chip_priv *chip)
 {
-	u8 core_idx;
-	u32 reg_addr;
+	struct brcmf_core *core;
 
-	if (!ci->iscoreup(sdiodev, ci, BCMA_CORE_INTERNAL_MEM)) {
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_INTERNAL_MEM);
+	if (!brcmf_chip_iscoreup(core)) {
 		brcmf_err("SOCRAM core is down after reset?\n");
 		return false;
 	}
 
-	/* clear all interrupts */
-	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
-	reg_addr = ci->c_inf[core_idx].base;
-	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
-	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+	chip->ops->exit_dl(chip->ctx, &chip->pub, 0);
 
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0, 0);
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CM3);
+	brcmf_chip_resetcore(core, 0, 0, 0);
 
 	return true;
 }
 
 static inline void
-brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
-			    struct brcmf_chip *ci)
+brcmf_chip_cr4_enterdl(struct brcmf_chip_priv *chip)
 {
-	u8 idx;
-	u32 regdata;
-	u32 wrapbase;
-	idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CR4);
+	struct brcmf_core *core;
 
-	if (idx == BRCMF_MAX_CORENUM)
-		return;
+	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CR4);
 
-	wrapbase = ci->c_inf[idx].wrapbase;
-	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
-	regdata &= ARMCR4_BCMA_IOCTL_CPUHALT;
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, regdata,
-		      ARMCR4_BCMA_IOCTL_CPUHALT, ARMCR4_BCMA_IOCTL_CPUHALT);
-	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
-		      D11_BCMA_IOCTL_PHYRESET | D11_BCMA_IOCTL_PHYCLOCKEN,
-		      D11_BCMA_IOCTL_PHYCLOCKEN, D11_BCMA_IOCTL_PHYCLOCKEN);
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
+	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
+				   D11_BCMA_IOCTL_PHYCLOCKEN,
+			     D11_BCMA_IOCTL_PHYCLOCKEN,
+			     D11_BCMA_IOCTL_PHYCLOCKEN);
 }
 
-static bool brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev,
-				       struct brcmf_chip *ci, u32 rstvec)
+static bool brcmf_chip_cr4_exitdl(struct brcmf_chip_priv *chip, u32 rstvec)
 {
-	u8 core_idx;
-	u32 reg_addr;
-
-	/* clear all interrupts */
-	core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_SDIO_DEV);
-	reg_addr = ci->c_inf[core_idx].base;
-	reg_addr += offsetof(struct sdpcmd_regs, intstatus);
-	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+	struct brcmf_core *core;
 
-	/* Write reset vector to address 0 */
-	brcmf_sdiod_ramrw(sdiodev, true, 0, (void *)&rstvec,
-			  sizeof(rstvec));
+	chip->ops->exit_dl(chip->ctx, &chip->pub, rstvec);
 
 	/* restore ARM */
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, ARMCR4_BCMA_IOCTL_CPUHALT,
-		      0, 0);
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CR4);
+	brcmf_chip_resetcore(core, ARMCR4_BCMA_IOCTL_CPUHALT, 0, 0);
 
 	return true;
 }
 
-void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
-				    struct brcmf_chip *ci)
+void brcmf_chip_enter_download(struct brcmf_chip *pub)
 {
-	u8 arm_core_idx;
+	struct brcmf_chip_priv *chip;
+	struct brcmf_core *arm;
+
+	brcmf_dbg(TRACE, "Enter\n");
 
-	arm_core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
-	if (BRCMF_MAX_CORENUM != arm_core_idx) {
-		brcmf_sdio_chip_cm3_enterdl(sdiodev, ci);
+	chip = container_of(pub, struct brcmf_chip_priv, pub);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+	if (arm) {
+		brcmf_chip_cm3_enterdl(chip);
 		return;
 	}
 
-	brcmf_sdio_chip_cr4_enterdl(sdiodev, ci);
+	brcmf_chip_cr4_enterdl(chip);
+}
+
+bool brcmf_chip_exit_download(struct brcmf_chip *pub, u32 rstvec)
+{
+	struct brcmf_chip_priv *chip;
+	struct brcmf_core *arm;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	chip = container_of(pub, struct brcmf_chip_priv, pub);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+	if (arm)
+		return brcmf_chip_cm3_exitdl(chip);
+
+	return brcmf_chip_cr4_exitdl(chip, rstvec);
 }
 
-bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct brcmf_chip *ci, u32 rstvec)
+bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 {
-	u8 arm_core_idx;
+	u32 base, addr, reg, pmu_cc3_mask = ~0;
+	struct brcmf_chip_priv *chip;
+
+	brcmf_dbg(TRACE, "Enter\n");
 
-	arm_core_idx = brcmf_sdio_chip_getinfidx(ci, BCMA_CORE_ARM_CM3);
-	if (BRCMF_MAX_CORENUM != arm_core_idx)
-		return brcmf_sdio_chip_cm3_exitdl(sdiodev, ci);
+	/* old chips with PMU version less than 17 don't support save restore */
+	if (pub->pmurev < 17)
+		return false;
 
-	return brcmf_sdio_chip_cr4_exitdl(sdiodev, ci, rstvec);
+	base = brcmf_chip_get_chipcommon(pub)->base;
+	chip = container_of(pub, struct brcmf_chip_priv, pub);
+
+	switch (pub->chip) {
+	case BCM43241_CHIP_ID:
+	case BCM4335_CHIP_ID:
+	case BCM4339_CHIP_ID:
+		/* read PMU chipcontrol register 3 */
+		addr = CORE_CC_REG(base, chipcontrol_addr);
+		chip->ops->write32(chip->ctx, addr, 3);
+		addr = CORE_CC_REG(base, chipcontrol_data);
+		reg = chip->ops->read32(chip->ctx, addr);
+		return (reg & pmu_cc3_mask) != 0;
+	default:
+		addr = CORE_CC_REG(base, pmucapabilities_ext);
+		reg = chip->ops->read32(chip->ctx, addr);
+		if ((reg & PCAPEXT_SR_SUPPORTED_MASK) == 0)
+			return false;
+
+		addr = CORE_CC_REG(base, retention_ctl);
+		reg = chip->ops->read32(chip->ctx, addr);
+		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
+			       PMU_RCTL_LOGIC_DISABLE_MASK)) == 0;
+	}
 }
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/brcm80211/brcmfmac/chip.h
index 2bc00c5..c32908d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2011 Broadcom Corporation
+ * Copyright (c) 2014 Broadcom Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -13,216 +13,79 @@
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
+#ifndef BRCMF_CHIP_H
+#define BRCMF_CHIP_H
 
-#ifndef _BRCMFMAC_SDIO_CHIP_H_
-#define _BRCMFMAC_SDIO_CHIP_H_
+#include <linux/types.h>
 
-/*
- * Core reg address translation.
- * Both macro's returns a 32 bits byte address on the backplane bus.
- */
 #define CORE_CC_REG(base, field) \
 		(base + offsetof(struct chipcregs, field))
-#define CORE_BUS_REG(base, field) \
-		(base + offsetof(struct sdpcmd_regs, field))
-#define CORE_SB(base, field) \
-		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
-
-/* SDIO function 1 register CHIPCLKCSR */
-/* Force ALP request to backplane */
-#define SBSDIO_FORCE_ALP		0x01
-/* Force HT request to backplane */
-#define SBSDIO_FORCE_HT			0x02
-/* Force ILP request to backplane */
-#define SBSDIO_FORCE_ILP		0x04
-/* Make ALP ready (power up xtal) */
-#define SBSDIO_ALP_AVAIL_REQ		0x08
-/* Make HT ready (power up PLL) */
-#define SBSDIO_HT_AVAIL_REQ		0x10
-/* Squelch clock requests from HW */
-#define SBSDIO_FORCE_HW_CLKREQ_OFF	0x20
-/* Status: ALP is ready */
-#define SBSDIO_ALP_AVAIL		0x40
-/* Status: HT is ready */
-#define SBSDIO_HT_AVAIL			0x80
-#define SBSDIO_AVBITS		(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
-#define SBSDIO_ALPAV(regval)	((regval) & SBSDIO_AVBITS)
-#define SBSDIO_HTAV(regval)	(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
-#define SBSDIO_ALPONLY(regval)	(SBSDIO_ALPAV(regval) && !SBSDIO_HTAV(regval))
-#define SBSDIO_CLKAV(regval, alponly) \
-	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
-
-#define BRCMF_MAX_CORENUM	6
-
-struct brcmf_core {
-	u16 id;
-	u16 rev;
-	u32 base;
-	u32 wrapbase;
-	u32 caps;
-	u32 cib;
-};
 
+/**
+ * struct brcmf_chip - chip level information.
+ *
+ * @chip: chip identifier.
+ * @chiprev: chip revision.
+ * @cc_caps: chipcommon core capabilities.
+ * @pmucaps: PMU capabilities.
+ * @pmurev: PMU revision.
+ * @rambase: RAM base address (only applicable for ARM CR4 chips).
+ * @ramsize: amount of RAM on chip.
+ * @name: string representation of the chip identifier.
+ */
 struct brcmf_chip {
 	u32 chip;
 	u32 chiprev;
-	/* core info */
-	/* always put chipcommon core at 0, bus core at 1 */
-	struct brcmf_core c_inf[BRCMF_MAX_CORENUM];
-	u32 pmurev;
+	u32 cc_caps;
 	u32 pmucaps;
-	u32 ramsize;
+	u32 pmurev;
 	u32 rambase;
-	u32 rst_vec;	/* reset vertor for ARM CR4 core */
-
-	bool (*iscoreup)(struct brcmf_sdio_dev *sdiodev, struct brcmf_chip *ci,
-			 u16 coreid);
-	u32 (*corerev)(struct brcmf_sdio_dev *sdiodev, struct brcmf_chip *ci,
-			 u16 coreid);
-	void (*coredisable)(struct brcmf_sdio_dev *sdiodev,
-			struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
-			u32 in_resetbits);
-	void (*resetcore)(struct brcmf_sdio_dev *sdiodev,
-			struct brcmf_chip *ci, u16 coreid, u32 pre_resetbits,
-			u32 in_resetbits, u32 post_resetbits);
+	u32 ramsize;
+	char name[8];
 };
 
-struct sbconfig {
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
+/**
+ * struct brcmf_core - core related information.
+ *
+ * @id: core identifier.
+ * @rev: core revision.
+ * @base: base address of core register space.
+ */
+struct brcmf_core {
+	u16 id;
+	u16 rev;
+	u32 base;
 };
 
-/* sdio core registers */
-struct sdpcmd_regs {
-	u32 corecontrol;		/* 0x00, rev8 */
-	u32 corestatus;			/* rev8 */
-	u32 PAD[1];
-	u32 biststatus;			/* rev8 */
-
-	/* PCMCIA access */
-	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
-	u16 PAD[1];
-	u16 pcmciamesportalmask;	/* rev8 */
-	u16 PAD[1];
-	u16 pcmciawrframebc;		/* rev8 */
-	u16 PAD[1];
-	u16 pcmciaunderflowtimer;	/* rev8 */
-	u16 PAD[1];
-
-	/* interrupt */
-	u32 intstatus;			/* 0x020, rev8 */
-	u32 hostintmask;		/* rev8 */
-	u32 intmask;			/* rev8 */
-	u32 sbintstatus;		/* rev8 */
-	u32 sbintmask;			/* rev8 */
-	u32 funcintmask;		/* rev4 */
-	u32 PAD[2];
-	u32 tosbmailbox;		/* 0x040, rev8 */
-	u32 tohostmailbox;		/* rev8 */
-	u32 tosbmailboxdata;		/* rev8 */
-	u32 tohostmailboxdata;		/* rev8 */
-
-	/* synchronized access to registers in SDIO clock domain */
-	u32 sdioaccess;			/* 0x050, rev8 */
-	u32 PAD[3];
-
-	/* PCMCIA frame control */
-	u8 pcmciaframectrl;		/* 0x060, rev8 */
-	u8 PAD[3];
-	u8 pcmciawatermark;		/* rev8 */
-	u8 PAD[155];
-
-	/* interrupt batching control */
-	u32 intrcvlazy;			/* 0x100, rev8 */
-	u32 PAD[3];
-
-	/* counters */
-	u32 cmd52rd;			/* 0x110, rev8 */
-	u32 cmd52wr;			/* rev8 */
-	u32 cmd53rd;			/* rev8 */
-	u32 cmd53wr;			/* rev8 */
-	u32 abort;			/* rev8 */
-	u32 datacrcerror;		/* rev8 */
-	u32 rdoutofsync;		/* rev8 */
-	u32 wroutofsync;		/* rev8 */
-	u32 writebusy;			/* rev8 */
-	u32 readwait;			/* rev8 */
-	u32 readterm;			/* rev8 */
-	u32 writeterm;			/* rev8 */
-	u32 PAD[40];
-	u32 clockctlstatus;		/* rev8 */
-	u32 PAD[7];
-
-	u32 PAD[128];			/* DMA engines */
-
-	/* SDIO/PCMCIA CIS region */
-	char cis[512];			/* 0x400-0x5ff, rev6 */
-
-	/* PCMCIA function control registers */
-	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
-	u16 PAD[55];
-
-	/* PCMCIA backplane access */
-	u16 backplanecsr;		/* 0x76E, rev6 */
-	u16 backplaneaddr0;		/* rev6 */
-	u16 backplaneaddr1;		/* rev6 */
-	u16 backplaneaddr2;		/* rev6 */
-	u16 backplaneaddr3;		/* rev6 */
-	u16 backplanedata0;		/* rev6 */
-	u16 backplanedata1;		/* rev6 */
-	u16 backplanedata2;		/* rev6 */
-	u16 backplanedata3;		/* rev6 */
-	u16 PAD[31];
-
-	/* sprom "size" & "blank" info */
-	u16 spromstatus;		/* 0x7BE, rev2 */
-	u32 PAD[464];
-
-	u16 PAD[0x80];
+/**
+ * struct brcmf_buscore_ops - buscore specific callbacks.
+ *
+ * @read32: read 32-bit value over bus.
+ * @write32: write 32-bit value over bus.
+ * @prepare: prepare bus for core configuration.
+ * @setup: bus-specific core setup.
+ * @exit_dl: exit download state.
+ *	The callback should use the provided @rstvec when non-zero.
+ */
+struct brcmf_buscore_ops {
+	u32 (*read32)(void *ctx, u32 addr);
+	void (*write32)(void *ctx, u32 addr, u32 value);
+	int (*prepare)(void *ctx);
+	int (*setup)(void *ctx, struct brcmf_chip *chip);
+	void (*exit_dl)(void *ctx, struct brcmf_chip *chip, u32 rstvec);
 };
 
-int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
-			   struct brcmf_chip **ci_ptr);
-void brcmf_sdio_chip_detach(struct brcmf_chip **ci_ptr);
-u8 brcmf_sdio_chip_getinfidx(struct brcmf_chip *ci, u16 coreid);
-void brcmf_sdio_chip_enter_download(struct brcmf_sdio_dev *sdiodev,
-				    struct brcmf_chip *ci);
-bool brcmf_sdio_chip_exit_download(struct brcmf_sdio_dev *sdiodev,
-				   struct brcmf_chip *ci, u32 rstvec);
-
-#endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
+struct brcmf_chip *brcmf_chip_attach(void *ctx,
+				     const struct brcmf_buscore_ops *ops);
+void brcmf_chip_detach(struct brcmf_chip *chip);
+struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *chip, u16 coreid);
+struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *chip);
+bool brcmf_chip_iscoreup(struct brcmf_core *core);
+void brcmf_chip_coredisable(struct brcmf_core *core, u32 prereset, u32 reset);
+void brcmf_chip_resetcore(struct brcmf_core *core, u32 prereset, u32 reset,
+			  u32 postreset);
+void brcmf_chip_enter_download(struct brcmf_chip *ci);
+bool brcmf_chip_exit_download(struct brcmf_chip *ci, u32 rstvec);
+bool brcmf_chip_sr_capable(struct brcmf_chip *pub);
+
+#endif /* BRCMF_AXIDMP_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 0981854..3056f11 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/card.h>
 #include <linux/semaphore.h>
@@ -156,6 +157,33 @@ struct rte_console {
 /* manfid tuple length, include tuple, link bytes */
 #define SBSDIO_CIS_MANFID_TUPLE_LEN	6
 
+#define CORE_BUS_REG(base, field) \
+		(base + offsetof(struct sdpcmd_regs, field))
+
+/* SDIO function 1 register CHIPCLKCSR */
+/* Force ALP request to backplane */
+#define SBSDIO_FORCE_ALP		0x01
+/* Force HT request to backplane */
+#define SBSDIO_FORCE_HT			0x02
+/* Force ILP request to backplane */
+#define SBSDIO_FORCE_ILP		0x04
+/* Make ALP ready (power up xtal) */
+#define SBSDIO_ALP_AVAIL_REQ		0x08
+/* Make HT ready (power up PLL) */
+#define SBSDIO_HT_AVAIL_REQ		0x10
+/* Squelch clock requests from HW */
+#define SBSDIO_FORCE_HW_CLKREQ_OFF	0x20
+/* Status: ALP is ready */
+#define SBSDIO_ALP_AVAIL		0x40
+/* Status: HT is ready */
+#define SBSDIO_HT_AVAIL			0x80
+#define SBSDIO_AVBITS		(SBSDIO_HT_AVAIL | SBSDIO_ALP_AVAIL)
+#define SBSDIO_ALPAV(regval)	((regval) & SBSDIO_AVBITS)
+#define SBSDIO_HTAV(regval)	(((regval) & SBSDIO_AVBITS) == SBSDIO_AVBITS)
+#define SBSDIO_ALPONLY(regval)	(SBSDIO_ALPAV(regval) && !SBSDIO_HTAV(regval))
+#define SBSDIO_CLKAV(regval, alponly) \
+	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
+
 /* intstatus */
 #define I_SMB_SW0	(1 << 0)	/* To SB Mail S/W interrupt 0 */
 #define I_SMB_SW1	(1 << 1)	/* To SB Mail S/W interrupt 1 */
@@ -665,27 +693,24 @@ static bool data_ok(struct brcmf_sdio *bus)
  * Reads a register in the SDIO hardware block. This block occupies a series of
  * adresses on the 32 bit backplane bus.
  */
-static int
-r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
+static int r_sdreg32(struct brcmf_sdio *bus, u32 *regvar, u32 offset)
 {
-	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	struct brcmf_core *core;
 	int ret;
 
-	*regvar = brcmf_sdiod_regrl(bus->sdiodev,
-				    bus->ci->c_inf[idx].base + offset, &ret);
+	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
+	*regvar = brcmf_sdiod_regrl(bus->sdiodev, core->base + offset, &ret);
 
 	return ret;
 }
 
-static int
-w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
+static int w_sdreg32(struct brcmf_sdio *bus, u32 regval, u32 reg_offset)
 {
-	u8 idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
+	struct brcmf_core *core;
 	int ret;
 
-	brcmf_sdiod_regwl(bus->sdiodev,
-			  bus->ci->c_inf[idx].base + reg_offset,
-			  regval, &ret);
+	core = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
+	brcmf_sdiod_regwl(bus->sdiodev, core->base + reg_offset, regval, &ret);
 
 	return ret;
 }
@@ -2425,14 +2450,13 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
 
 static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
 {
-	u8 idx;
+	struct brcmf_core *buscore;
 	u32 addr;
 	unsigned long val;
 	int n, ret;
 
-	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
-	addr = bus->ci->c_inf[idx].base +
-	       offsetof(struct sdpcmd_regs, intstatus);
+	buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
+	addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
 
 	val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
 	bus->sdcnt.f1regdata++;
@@ -3344,7 +3368,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 	brcmf_sdio_clkctl(bus, CLK_AVAIL, false);
 
 	/* Keep arm in reset */
-	brcmf_sdio_chip_enter_download(bus->sdiodev, bus->ci);
+	brcmf_chip_enter_download(bus->ci);
 
 	fw = brcmf_sdio_get_fw(bus, BRCMF_FIRMWARE_BIN);
 	if (fw == NULL) {
@@ -3376,7 +3400,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus)
 	}
 
 	/* Take arm out of reset */
-	if (!brcmf_sdio_chip_exit_download(bus->sdiodev, bus->ci, rstvec)) {
+	if (!brcmf_chip_exit_download(bus->ci, rstvec)) {
 		brcmf_err("error getting out of ARM core reset\n");
 		goto err;
 	}
@@ -3391,40 +3415,6 @@ err:
 	return bcmerror;
 }
 
-static bool brcmf_sdio_sr_capable(struct brcmf_sdio *bus)
-{
-	u32 addr, reg, pmu_cc3_mask = ~0;
-	int err;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* old chips with PMU version less than 17 don't support save restore */
-	if (bus->ci->pmurev < 17)
-		return false;
-
-	switch (bus->ci->chip) {
-	case BCM43241_CHIP_ID:
-	case BCM4335_CHIP_ID:
-	case BCM4339_CHIP_ID:
-		/* read PMU chipcontrol register 3 */
-		addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_addr);
-		brcmf_sdiod_regwl(bus->sdiodev, addr, 3, NULL);
-		addr = CORE_CC_REG(bus->ci->c_inf[0].base, chipcontrol_data);
-		reg = brcmf_sdiod_regrl(bus->sdiodev, addr, NULL);
-		return (reg & pmu_cc3_mask) != 0;
-	default:
-		addr = CORE_CC_REG(bus->ci->c_inf[0].base, pmucapabilities_ext);
-		reg = brcmf_sdiod_regrl(bus->sdiodev, addr, &err);
-		if ((reg & PCAPEXT_SR_SUPPORTED_MASK) == 0)
-			return false;
-
-		addr = CORE_CC_REG(bus->ci->c_inf[0].base, retention_ctl);
-		reg = brcmf_sdiod_regrl(bus->sdiodev, addr, NULL);
-		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
-			       PMU_RCTL_LOGIC_DISABLE_MASK)) == 0;
-	}
-}
-
 static void brcmf_sdio_sr_init(struct brcmf_sdio *bus)
 {
 	int err = 0;
@@ -3476,7 +3466,7 @@ static int brcmf_sdio_kso_init(struct brcmf_sdio *bus)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* KSO bit added in SDIO core rev 12 */
-	if (bus->ci->c_inf[1].rev < 12)
+	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12)
 		return 0;
 
 	val = brcmf_sdiod_regrb(bus->sdiodev, SBSDIO_FUNC1_SLEEPCSR, &err);
@@ -3507,15 +3497,13 @@ static int brcmf_sdio_bus_preinit(struct device *dev)
 	struct brcmf_sdio *bus = sdiodev->bus;
 	uint pad_size;
 	u32 value;
-	u8 idx;
 	int err;
 
 	/* the commands below use the terms tx and rx from
 	 * a device perspective, ie. bus:txglom affects the
 	 * bus transfers from device to host.
 	 */
-	idx = brcmf_sdio_chip_getinfidx(bus->ci, BCMA_CORE_SDIO_DEV);
-	if (bus->ci->c_inf[idx].rev < 12) {
+	if (brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV)->rev < 12) {
 		/* for sdio core rev < 12, disable txgloming */
 		value = 0;
 		err = brcmf_iovar_data_set(dev, "bus:txglom", &value,
@@ -3626,7 +3614,7 @@ static int brcmf_sdio_bus_init(struct device *dev)
 		ret = -ENODEV;
 	}
 
-	if (brcmf_sdio_sr_capable(bus)) {
+	if (brcmf_chip_sr_capable(bus->ci)) {
 		brcmf_sdio_sr_init(bus);
 	} else {
 		/* Restore previous clock setting */
@@ -3775,30 +3763,20 @@ static void brcmf_sdio_dataworker(struct work_struct *work)
 	}
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
 static void
 brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
-				  struct brcmf_chip *ci, u32 drivestrength)
+			     struct brcmf_chip *ci, u32 drivestrength)
 {
 	const struct sdiod_drive_str *str_tab = NULL;
 	u32 str_mask;
 	u32 str_shift;
-	char chn[8];
-	u32 base = ci->c_inf[0].base;
+	u32 base;
 	u32 i;
 	u32 drivestrength_sel = 0;
 	u32 cc_data_temp;
 	u32 addr;
 
-	if (!(ci->c_inf[0].caps & CC_CAP_PMU))
+	if (!(ci->cc_caps & CC_CAP_PMU))
 		return;
 
 	switch (SDIOD_DRVSTR_KEY(ci->chip, ci->pmurev)) {
@@ -3821,8 +3799,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 			str_shift = 0;
 		} else
 			brcmf_err("Invalid SDIO Drive strength for chip %s, strength=%d\n",
-				  brcmf_sdio_chip_name(ci->chip, chn, 8),
-				  drivestrength);
+				  ci->name, drivestrength);
 		break;
 	case SDIOD_DRVSTR_KEY(BCM43362_CHIP_ID, 13):
 		str_tab = sdiod_drive_strength_tab5_1v8;
@@ -3831,8 +3808,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 		break;
 	default:
 		brcmf_err("No SDIO Drive strength init done for chip %s rev %d pmurev %d\n",
-			  brcmf_sdio_chip_name(ci->chip, chn, 8),
-			  ci->chiprev, ci->pmurev);
+			  ci->name, ci->chiprev, ci->pmurev);
 		break;
 	}
 
@@ -3843,6 +3819,7 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 				break;
 			}
 		}
+		base = brcmf_chip_get_chipcommon(ci)->base;
 		addr = CORE_CC_REG(base, chipcontrol_addr);
 		brcmf_sdiod_regwl(sdiodev, addr, 1, NULL);
 		cc_data_temp = brcmf_sdiod_regrl(sdiodev, addr, NULL);
@@ -3856,8 +3833,9 @@ brcmf_sdio_drivestrengthinit(struct brcmf_sdio_dev *sdiodev,
 	}
 }
 
-int brcmf_sdio_buscoreprep(struct brcmf_sdio_dev *sdiodev)
+static int brcmf_sdio_buscoreprep(void *ctx)
 {
+	struct brcmf_sdio_dev *sdiodev = ctx;
 	int err = 0;
 	u8 clkval, clkset;
 
@@ -3900,6 +3878,55 @@ int brcmf_sdio_buscoreprep(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
+static void brcmf_sdio_buscore_exitdl(void *ctx, struct brcmf_chip *chip,
+				      u32 rstvec)
+{
+	struct brcmf_sdio_dev *sdiodev = ctx;
+	struct brcmf_core *core;
+	u32 reg_addr;
+
+	/* clear all interrupts */
+	core = brcmf_chip_get_core(chip, BCMA_CORE_SDIO_DEV);
+	reg_addr = core->base + offsetof(struct sdpcmd_regs, intstatus);
+	brcmf_sdiod_regwl(sdiodev, reg_addr, 0xFFFFFFFF, NULL);
+
+	if (rstvec)
+		/* Write reset vector to address 0 */
+		brcmf_sdiod_ramrw(sdiodev, true, 0, (void *)&rstvec,
+				  sizeof(rstvec));
+}
+
+static u32 brcmf_sdio_buscore_read32(void *ctx, u32 addr)
+{
+	struct brcmf_sdio_dev *sdiodev = ctx;
+	u32 val, rev;
+
+	val = brcmf_sdiod_regrl(sdiodev, addr, NULL);
+	if (sdiodev->func[0]->device == SDIO_DEVICE_ID_BROADCOM_4335_4339 &&
+	    addr == CORE_CC_REG(SI_ENUM_BASE, chipid)) {
+		rev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
+		if (rev >= 2) {
+			val &= ~CID_ID_MASK;
+			val |= BCM4339_CHIP_ID;
+		}
+	}
+	return val;
+}
+
+static void brcmf_sdio_buscore_write32(void *ctx, u32 addr, u32 val)
+{
+	struct brcmf_sdio_dev *sdiodev = ctx;
+
+	brcmf_sdiod_regwl(sdiodev, addr, val, NULL);
+}
+
+static const struct brcmf_buscore_ops brcmf_sdio_buscore_ops = {
+	.prepare = brcmf_sdio_buscoreprep,
+	.exit_dl = brcmf_sdio_buscore_exitdl,
+	.read32 = brcmf_sdio_buscore_read32,
+	.write32 = brcmf_sdio_buscore_write32,
+};
+
 static bool
 brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 {
@@ -3915,7 +3942,7 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		 brcmf_sdiod_regrl(bus->sdiodev, SI_ENUM_BASE, NULL));
 
 	/*
-	 * Force PLL off until brcmf_sdio_chip_attach()
+	 * Force PLL off until brcmf_chip_attach()
 	 * programs PLL control regs
 	 */
 
@@ -3936,8 +3963,10 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 	 */
 	brcmf_bus_change_state(bus->sdiodev->bus_if, BRCMF_BUS_DOWN);
 
-	if (brcmf_sdio_chip_attach(bus->sdiodev, &bus->ci)) {
-		brcmf_err("brcmf_sdio_chip_attach failed!\n");
+	bus->ci = brcmf_chip_attach(bus->sdiodev, &brcmf_sdio_buscore_ops);
+	if (IS_ERR(bus->ci)) {
+		brcmf_err("brcmf_chip_attach failed!\n");
+		bus->ci = NULL;
 		goto fail;
 	}
 
@@ -3973,24 +4002,18 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
 		goto fail;
 
 	/* set PMUControl so a backplane reset does PMU state reload */
-	reg_addr = CORE_CC_REG(bus->ci->c_inf[0].base,
+	reg_addr = CORE_CC_REG(brcmf_chip_get_chipcommon(bus->ci)->base,
 			       pmucontrol);
-	reg_val = brcmf_sdiod_regrl(bus->sdiodev,
-				    reg_addr,
-				    &err);
+	reg_val = brcmf_sdiod_regrl(bus->sdiodev, reg_addr, &err);
 	if (err)
 		goto fail;
 
 	reg_val |= (BCMA_CC_PMU_CTL_RES_RELOAD << BCMA_CC_PMU_CTL_RES_SHIFT);
 
-	brcmf_sdiod_regwl(bus->sdiodev,
-			  reg_addr,
-			  reg_val,
-			  &err);
+	brcmf_sdiod_regwl(bus->sdiodev, reg_addr, reg_val, &err);
 	if (err)
 		goto fail;
 
-
 	sdio_release_host(bus->sdiodev->func[1]);
 
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
@@ -4223,12 +4246,11 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
 				 * all necessary cores.
 				 */
 				msleep(20);
-				brcmf_sdio_chip_enter_download(bus->sdiodev,
-							       bus->ci);
+				brcmf_chip_enter_download(bus->ci);
 				brcmf_sdio_clkctl(bus, CLK_NONE, false);
 				sdio_release_host(bus->sdiodev->func[1]);
 			}
-			brcmf_sdio_chip_detach(&bus->ci);
+			brcmf_chip_detach(bus->ci);
 		}
 
 		brcmu_pkt_buf_free_skb(bus->txglom_sgpad);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
index 396c06c..5e53eb1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_host.h
@@ -182,6 +182,95 @@ struct brcmf_sdio_dev {
 	uint max_segment_size;
 };
 
+/* sdio core registers */
+struct sdpcmd_regs {
+	u32 corecontrol;		/* 0x00, rev8 */
+	u32 corestatus;			/* rev8 */
+	u32 PAD[1];
+	u32 biststatus;			/* rev8 */
+
+	/* PCMCIA access */
+	u16 pcmciamesportaladdr;	/* 0x010, rev8 */
+	u16 PAD[1];
+	u16 pcmciamesportalmask;	/* rev8 */
+	u16 PAD[1];
+	u16 pcmciawrframebc;		/* rev8 */
+	u16 PAD[1];
+	u16 pcmciaunderflowtimer;	/* rev8 */
+	u16 PAD[1];
+
+	/* interrupt */
+	u32 intstatus;			/* 0x020, rev8 */
+	u32 hostintmask;		/* rev8 */
+	u32 intmask;			/* rev8 */
+	u32 sbintstatus;		/* rev8 */
+	u32 sbintmask;			/* rev8 */
+	u32 funcintmask;		/* rev4 */
+	u32 PAD[2];
+	u32 tosbmailbox;		/* 0x040, rev8 */
+	u32 tohostmailbox;		/* rev8 */
+	u32 tosbmailboxdata;		/* rev8 */
+	u32 tohostmailboxdata;		/* rev8 */
+
+	/* synchronized access to registers in SDIO clock domain */
+	u32 sdioaccess;			/* 0x050, rev8 */
+	u32 PAD[3];
+
+	/* PCMCIA frame control */
+	u8 pcmciaframectrl;		/* 0x060, rev8 */
+	u8 PAD[3];
+	u8 pcmciawatermark;		/* rev8 */
+	u8 PAD[155];
+
+	/* interrupt batching control */
+	u32 intrcvlazy;			/* 0x100, rev8 */
+	u32 PAD[3];
+
+	/* counters */
+	u32 cmd52rd;			/* 0x110, rev8 */
+	u32 cmd52wr;			/* rev8 */
+	u32 cmd53rd;			/* rev8 */
+	u32 cmd53wr;			/* rev8 */
+	u32 abort;			/* rev8 */
+	u32 datacrcerror;		/* rev8 */
+	u32 rdoutofsync;		/* rev8 */
+	u32 wroutofsync;		/* rev8 */
+	u32 writebusy;			/* rev8 */
+	u32 readwait;			/* rev8 */
+	u32 readterm;			/* rev8 */
+	u32 writeterm;			/* rev8 */
+	u32 PAD[40];
+	u32 clockctlstatus;		/* rev8 */
+	u32 PAD[7];
+
+	u32 PAD[128];			/* DMA engines */
+
+	/* SDIO/PCMCIA CIS region */
+	char cis[512];			/* 0x400-0x5ff, rev6 */
+
+	/* PCMCIA function control registers */
+	char pcmciafcr[256];		/* 0x600-6ff, rev6 */
+	u16 PAD[55];
+
+	/* PCMCIA backplane access */
+	u16 backplanecsr;		/* 0x76E, rev6 */
+	u16 backplaneaddr0;		/* rev6 */
+	u16 backplaneaddr1;		/* rev6 */
+	u16 backplaneaddr2;		/* rev6 */
+	u16 backplaneaddr3;		/* rev6 */
+	u16 backplanedata0;		/* rev6 */
+	u16 backplanedata1;		/* rev6 */
+	u16 backplanedata2;		/* rev6 */
+	u16 backplanedata3;		/* rev6 */
+	u16 PAD[31];
+
+	/* sprom "size" & "blank" info */
+	u16 spromstatus;		/* 0x7BE, rev2 */
+	u32 PAD[464];
+
+	u16 PAD[0x80];
+};
+
 /* Register/deregister interrupt handler. */
 int brcmf_sdiod_intr_register(struct brcmf_sdio_dev *sdiodev);
 int brcmf_sdiod_intr_unregister(struct brcmf_sdio_dev *sdiodev);
@@ -239,6 +328,5 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus);
 void brcmf_sdio_isr(struct brcmf_sdio *bus);
 
 void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, uint wdtick);
-int brcmf_sdio_buscoreprep(struct brcmf_sdio_dev *sdiodev);
 
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.10.4

