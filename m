Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50572 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbdGQQsp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:48:45 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 20/29] brcmfmac: Whitespace patch
Date: Mon, 17 Jul 2017 17:16:28 +0100
Message-Id: <20170717161637.4652-21-ian@mnementh.co.uk> (sfid-20170717_184852_616238_07C2D59C)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improve legibility / conform to kernel coding style.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 781f54bb844b..38794d7c1da8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -276,29 +276,36 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
 	base = core->base;
 
 	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 	if (val & SSB_TMSLOW_RESET)
 		return;
 
 	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 	if ((val & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
 		 */
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
 					 val | SSB_TMSLOW_REJECT);
 
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 		udelay(1);
+
 		SPINWAIT((ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh))
 			  & SSB_TMSHIGH_BUSY), 100000);
 
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
+
 		if (val & SSB_TMSHIGH_BUSY)
 			brcmf_err("core state still busy\n");
 
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
+
 		if (val & SSB_IDLOW_INITIATOR) {
 			val = ci->ops->read32(ci->ctx,
 					      CORE_SB(base, sbimstate));
@@ -316,16 +323,22 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
 		/* set reset and reject while enabling the clocks */
 		val = SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 		      SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET;
+
 		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow), val);
+
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 		udelay(10);
 
 		/* clear the initiator reject bit */
 		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
+
 		if (val & SSB_IDLOW_INITIATOR) {
 			val = ci->ops->read32(ci->ctx,
 					      CORE_SB(base, sbimstate));
+
 			val &= ~SSB_IMSTATE_REJECT;
+
 			ci->ops->write32(ci->ctx,
 					 CORE_SB(base, sbimstate), val);
 		}
@@ -334,6 +347,7 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
 	/* leave reset and reject asserted */
 	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
 			 (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
+
 	udelay(1);
 }
 
@@ -345,17 +359,20 @@ static void brcmf_chip_ai_coredisable(struct brcmf_core *core,
 
 	/* if core is already in reset, skip reset */
 	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
+
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
 		goto in_reset_configure;
 
 	/* configure reset */
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
 			 prereset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+
 	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 
 	/* put in reset */
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_RESET_CTL,
 			 BCMA_RESET_CTL_RESET);
+
 	usleep_range(10, 20);
 
 	/* wait till reset is 1 */
@@ -366,6 +383,7 @@ static void brcmf_chip_ai_coredisable(struct brcmf_core *core,
 	/* in-reset configure */
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
 			 reset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
+
 	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 }
 
@@ -390,15 +408,19 @@ static void brcmf_chip_sb_resetcore(struct brcmf_core *core, u32 prereset,
 	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
 			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			 SSB_TMSLOW_RESET);
+
 	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 	udelay(1);
 
 	/* clear any serror */
 	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
+
 	if (regdata & SSB_TMSHIGH_SERR)
 		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatehigh), 0);
 
 	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbimstate));
+
 	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO)) {
 		regdata &= ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO);
 		ci->ops->write32(ci->ctx, CORE_SB(base, sbimstate), regdata);
@@ -407,13 +429,17 @@ static void brcmf_chip_sb_resetcore(struct brcmf_core *core, u32 prereset,
 	/* clear reset and allow it to propagate throughout the core */
 	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
 			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
+
 	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 	udelay(1);
 
 	/* leave clock enabled */
 	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
 			 SSB_TMSLOW_CLOCK);
+
 	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+
 	udelay(1);
 }
 
@@ -427,17 +453,23 @@ static void brcmf_chip_ai_resetcore(struct brcmf_core *core, u32 prereset,
 	brcmf_chip_ai_coredisable(core, prereset, reset);
 
 	count = 0;
+
 	while (ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) &
 	       BCMA_RESET_CTL_RESET) {
+
 		ci->ops->write32(ci->ctx, core->wrapbase + BCMA_RESET_CTL, 0);
+
 		count++;
+
 		if (count > 50)
 			break;
+
 		usleep_range(40, 60);
 	}
 
 	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
 			 postreset | BCMA_IOCTL_CLK);
+
 	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 }
 
@@ -908,6 +940,7 @@ static int brcmf_chip_recognition(struct brcmf_chip *ci)
 			brcmf_err("SB chip is not supported\n");
 			return -ENODEV;
 		}
+
 		ci->iscoreup = brcmf_chip_sb_iscoreup;
 		ci->coredisable = brcmf_chip_sb_coredisable;
 		ci->resetcore = brcmf_chip_sb_resetcore;
@@ -915,25 +948,31 @@ static int brcmf_chip_recognition(struct brcmf_chip *ci)
 		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
 					   SI_ENUM_BASE, 0);
 		brcmf_chip_sb_corerev(ci, core);
+
 		core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
 					   BCM4329_CORE_BUS_BASE, 0);
 		brcmf_chip_sb_corerev(ci, core);
+
 		core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
 					   BCM4329_CORE_SOCRAM_BASE, 0);
 		brcmf_chip_sb_corerev(ci, core);
+
 		core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
 					   BCM4329_CORE_ARM_BASE, 0);
 		brcmf_chip_sb_corerev(ci, core);
 
 		core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0);
 		brcmf_chip_sb_corerev(ci, core);
+
 		break;
 	case SOCI_AXI:
+
 		ci->iscoreup = brcmf_chip_ai_iscoreup;
 		ci->coredisable = brcmf_chip_ai_coredisable;
 		ci->resetcore = brcmf_chip_ai_resetcore;
 
 		brcmf_chip_dmp_erom_scan(ci);
+
 		break;
 	default:
 		brcmf_err("chip backplane type %u is not supported\n",
@@ -1301,24 +1340,32 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *chip)
 	case BRCM_CC_43241_CHIP_ID:
 	case BRCM_CC_4335_CHIP_ID:
 	case BRCM_CC_4339_CHIP_ID:
+
 		/* read PMU chipcontrol register 3 */
 		addr = CORE_CC_REG(pmu->base, chipcontrol_addr);
 		chip->ops->write32(chip->ctx, addr, 3);
+
 		addr = CORE_CC_REG(pmu->base, chipcontrol_data);
 		reg = chip->ops->read32(chip->ctx, addr);
+
 		return (reg & pmu_cc3_mask) != 0;
 	case BRCM_CC_43430_CHIP_ID:
+
 		addr = CORE_CC_REG(base, sr_control1);
 		reg = chip->ops->read32(chip->ctx, addr);
+
 		return reg != 0;
 	default:
+
 		addr = CORE_CC_REG(pmu->base, pmucapabilities_ext);
 		reg = chip->ops->read32(chip->ctx, addr);
+
 		if ((reg & PCAPEXT_SR_SUPPORTED_MASK) == 0)
 			return false;
 
 		addr = CORE_CC_REG(pmu->base, retention_ctl);
 		reg = chip->ops->read32(chip->ctx, addr);
+
 		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
 			       PMU_RCTL_LOGIC_DISABLE_MASK)) == 0;
 	}
-- 
2.11.0
