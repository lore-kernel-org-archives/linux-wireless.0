Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48978 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbdGPLqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:46:40 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 17/21] brcmfmac: HUGE cleanup of IO access functions.
Date: Sun, 16 Jul 2017 12:21:25 +0100
Message-Id: <20170716112129.10206-18-ian@mnementh.co.uk> (sfid-20170716_140043_703545_40132070)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 474 ++++++++++-----------
 1 file changed, 235 insertions(+), 239 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 1485463794ff..bab1bb3e99ae 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -28,6 +28,9 @@
 #include "debug.h"
 #include "chip.h"
 
+#undef brcmf_dbg
+#define brcmf_dbg(a, b, ...) printk(b, ##__VA_ARGS__)
+
 /* SOC Interconnect types (aka chip types) */
 #define SOCI_SB		0
 #define SOCI_AXI	1
@@ -106,9 +109,6 @@
 
 #define CORE_SB(base, field) \
 		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
-#define	SBCOREREV(sbidh) \
-	((((sbidh) & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT) | \
-	  ((sbidh) & SSB_IDHIGH_RCLO))
 
 struct sbconfig {
 	u32 PAD[2];
@@ -223,40 +223,75 @@ struct sbsocramregs {
 #define	ARMCR4_BSZ_MASK		0x3f
 #define	ARMCR4_BSZ_MULT		8192
 
+static inline int brcmf_readl(struct brcmf_chip *chip, u32 addr)
+{
+	return chip->ops->read32(chip->ctx, addr);
+}
+
+static inline void brcmf_writel(struct brcmf_chip *chip, u32 addr, u32 v)
+{
+	chip->ops->write32(chip->ctx, addr, v);
+}
+
+static inline void brcmf_writelp(struct brcmf_chip *chip, u32 addr, u32 v)
+{
+	chip->ops->write32(chip->ctx, addr, v);
+	chip->ops->read32(chip->ctx, addr);
+}
+
+static void brcmf_clear_bits(struct brcmf_chip *ci, u32 reg, u32 bits)
+{
+	u32 val;
+
+	val = brcmf_readl(ci, reg);
+	val &= ~bits;
+	brcmf_writel(ci, reg, val);
+}
+
+static void brcmf_set_bits_post(struct brcmf_chip *ci, u32 reg, u32 bits)
+{
+	u32 val;
+
+	val = brcmf_readl(ci, reg);
+	val |= bits;
+	brcmf_writelp(ci, reg, val);
+}
+
 static bool brcmf_chip_sb_iscoreup(struct brcmf_core *core)
 {
 	struct brcmf_chip *ci = core->chip;
-	u32 regdata;
-	u32 address;
-
-	address = CORE_SB(core->base, sbtmstatelow);
+	u32 val;
 
-	regdata = ci->ops->read32(ci->ctx, address);
+	val = brcmf_readl(ci, CORE_SB(core->base, sbtmstatelow));
 
-	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
-		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
+	val &= SSB_TMSLOW_RESET |
+		SSB_TMSLOW_REJECT |
+		SSB_IMSTATE_REJECT |
+		SSB_TMSLOW_CLOCK;
 
-	return SSB_TMSLOW_CLOCK == regdata;
+	return SSB_TMSLOW_CLOCK == val;
 }
 
 static bool brcmf_chip_axi_iscoreup(struct brcmf_core *core)
 {
 	struct brcmf_chip *ci = core->chip;
-	u32 regdata;
-	bool ret;
+	u32 val;
 
-	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
+	val = brcmf_readl(ci, core->wrapbase + BCMA_IOCTL);
 
-	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
+	if((val & BCMA_IOCTL_FGC) || !(val & BCMA_IOCTL_CLK))
+		return 0;
 
-	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
+	/* Is core in reset? */
+	val = brcmf_readl(ci, core->wrapbase + BCMA_RESET_CTL);
 
-	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
+	val &= BCMA_RESET_CTL_RESET;
 
-	return ret;
+	return !val;
 }
 
-static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
+/* prereset and reset ignored */
+static void brcmf_chip_sb_core_disable(struct brcmf_core *core,
 				      u32 prereset, u32 reset)
 {
 	struct brcmf_chip *ci = core->chip;
@@ -264,211 +299,176 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
 
 	base = core->base;
 
-	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+	val = brcmf_readl(ci, CORE_SB(base, sbtmstatelow));
 
+	/* If core is already in reset, skip reset */
 	if (val & SSB_TMSLOW_RESET)
 		return;
 
-	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
-
-	if ((val & SSB_TMSLOW_CLOCK) != 0) {
-		/*
-		 * set target reject and spin until busy is clear
-		 * (preserve core-specific bits)
-		 */
-		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+	if (!(val & SSB_TMSLOW_CLOCK))
+		goto out_clock_off;
 
-		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
-					 val | SSB_TMSLOW_REJECT);
+	/* Clock is running, so do other stuff? */
 
-		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+	/*
+	 * Set target reject and spin until busy is clear
+	 * (preserve core-specific bits)
+	 */
+	brcmf_set_bits_post(ci, CORE_SB(base, sbtmstatelow), SSB_TMSLOW_REJECT);
+	udelay(1);
 
-		udelay(1);
+	SPINWAIT((brcmf_readl(ci, CORE_SB(base, sbtmstatehigh))
+		  & SSB_TMSHIGH_BUSY), 100000);
 
-		SPINWAIT((ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh))
-			  & SSB_TMSHIGH_BUSY), 100000);
+	val = brcmf_readl(ci, CORE_SB(base, sbtmstatehigh));
 
-		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
+	if (val & SSB_TMSHIGH_BUSY)
+		brcmf_err("core state still busy\n");
 
-		if (val & SSB_TMSHIGH_BUSY)
-			brcmf_err("core state still busy\n");
 
-		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
-
-		if (val & SSB_IDLOW_INITIATOR) {
-			val = ci->ops->read32(ci->ctx,
-					      CORE_SB(base, sbimstate));
-			val |= SSB_IMSTATE_REJECT;
-			ci->ops->write32(ci->ctx,
-					 CORE_SB(base, sbimstate), val);
-			val = ci->ops->read32(ci->ctx,
-					      CORE_SB(base, sbimstate));
-			udelay(1);
-			SPINWAIT((ci->ops->read32(ci->ctx,
-						  CORE_SB(base, sbimstate)) &
-				  SSB_IMSTATE_BUSY), 100000);
-		}
+	val = brcmf_readl(ci, CORE_SB(base, sbidlow));
+	if (val & SSB_IDLOW_INITIATOR)
+	{
+		/* Do something and spin until core acknowledges */
 
-		/* set reset and reject while enabling the clocks */
-		val = SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
-		      SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET;
+		brcmf_set_bits_post(ci, CORE_SB(base, sbimstate),
+				SSB_IMSTATE_REJECT);
+		udelay(1);
 
-		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow), val);
+		SPINWAIT((brcmf_readl(ci, CORE_SB(base, sbimstate)) &
+			  SSB_IMSTATE_BUSY), 100000);
 
-		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+		val = brcmf_readl(ci, CORE_SB(base, sbimstate));
 
-		udelay(10);
+		if (val & SSB_IMSTATE_BUSY)
+			brcmf_err("core state still busy\n");
+	}
 
-		/* clear the initiator reject bit */
-		val = ci->ops->read32(ci->ctx, CORE_SB(base, sbidlow));
+	/* Set reset and reject while enabling the clocks */
+	brcmf_writelp(ci, CORE_SB(base, sbtmstatelow),
+			SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
+			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET);
 
-		if (val & SSB_IDLOW_INITIATOR) {
-			val = ci->ops->read32(ci->ctx,
-					      CORE_SB(base, sbimstate));
+	udelay(10);
 
-			val &= ~SSB_IMSTATE_REJECT;
+	/* Clear the initiator reject bit */
+	/* FIXME: Has this value actually changed since it was read earlier? */
+	val = brcmf_readl(ci, CORE_SB(base, sbidlow));
 
-			ci->ops->write32(ci->ctx,
-					 CORE_SB(base, sbimstate), val);
-		}
-	}
+	if (val & SSB_IDLOW_INITIATOR)
+		brcmf_clear_bits(ci, CORE_SB(base, sbimstate),
+				SSB_IMSTATE_REJECT);
 
+out_clock_off:
 	/* leave reset and reject asserted */
-	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
-			 (SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
+	brcmf_writel(ci, CORE_SB(base, sbtmstatelow),
+			 SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET);
 
 	udelay(1);
 }
 
-static void brcmf_chip_axi_coredisable(struct brcmf_core *core,
+static void brcmf_chip_axi_core_disable(struct brcmf_core *core,
 				      u32 prereset, u32 reset)
 {
 	struct brcmf_chip *ci = core->chip;
-	u32 regdata;
+	u32 val;
 
-	/* if core is already in reset, skip reset */
-	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
+	val = brcmf_readl(ci, core->wrapbase + BCMA_RESET_CTL);
 
-	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
+	/* If core is already in reset, skip reset */
+	if ((val & BCMA_RESET_CTL_RESET))
 		goto in_reset_configure;
 
-	/* configure reset */
-	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
+	/* Configure reset */
+	brcmf_writelp(ci, core->wrapbase + BCMA_IOCTL,
 			 prereset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
 
-	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
-
-	/* put in reset */
-	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_RESET_CTL,
-			 BCMA_RESET_CTL_RESET);
+	/* Put the core into reset */
+	brcmf_writel(ci, core->wrapbase + BCMA_RESET_CTL, BCMA_RESET_CTL_RESET);
 
 	usleep_range(10, 20);
 
-	/* wait till reset is 1 */
-	SPINWAIT(ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) !=
+	/*
+	 * Wait till reset is 1
+	 * FIXME: should this test the BCMA_RESET_CTL_RESET bit only?
+	 */
+	SPINWAIT(brcmf_readl(ci, core->wrapbase + BCMA_RESET_CTL) !=
 		 BCMA_RESET_CTL_RESET, 300);
 
 in_reset_configure:
-	/* in-reset configure */
-	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
+	brcmf_writelp(ci, core->wrapbase + BCMA_IOCTL,
 			 reset | BCMA_IOCTL_FGC | BCMA_IOCTL_CLK);
-
-	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 }
 
-static void brcmf_chip_sb_resetcore(struct brcmf_core *core, u32 prereset,
+static void brcmf_chip_sb_reset_core(struct brcmf_core *core, u32 prereset,
 				    u32 reset, u32 postreset)
 {
 	struct brcmf_chip *ci = core->chip;
 	u32 base = core->base;
-	u32 regdata;
+	u32 val;
 
 	/*
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_chip_sb_coredisable(core, 0, 0);
+	brcmf_chip_sb_core_disable(core, 0, 0);
 
 	/*
 	 * Now do the initialization sequence.
 	 * set reset while enabling the clock and
 	 * forcing them on throughout the core
 	 */
-	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+	brcmf_writelp(ci, CORE_SB(base, sbtmstatelow),
 			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
 			 SSB_TMSLOW_RESET);
 
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
-
 	udelay(1);
 
-	/* clear any serror */
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatehigh));
+	/* Clear any serror */
+	val = brcmf_readl(ci, CORE_SB(base, sbtmstatehigh));
 
-	if (regdata & SSB_TMSHIGH_SERR)
-		ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatehigh), 0);
+	if (val & SSB_TMSHIGH_SERR)
+		brcmf_writel(ci, CORE_SB(base, sbtmstatehigh), 0);
 
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbimstate));
+	val = brcmf_readl(ci, CORE_SB(base, sbimstate));
 
-	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO)) {
-		regdata &= ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO);
-		ci->ops->write32(ci->ctx, CORE_SB(base, sbimstate), regdata);
+	if (val & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO)) {
+		val &= ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO);
+		brcmf_writel(ci, CORE_SB(base, sbimstate), val);
 	}
 
-	/* clear reset and allow it to propagate throughout the core */
-	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
+	/* Clear reset and allow it to propagate throughout the core */
+	brcmf_writelp(ci, CORE_SB(base, sbtmstatelow),
 			 SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
 
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
-
 	udelay(1);
 
-	/* leave clock enabled */
-	ci->ops->write32(ci->ctx, CORE_SB(base, sbtmstatelow),
-			 SSB_TMSLOW_CLOCK);
-
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
+	/* Leave clock enabled */
+	brcmf_writelp(ci, CORE_SB(base, sbtmstatelow), SSB_TMSLOW_CLOCK);
 
 	udelay(1);
 }
 
-static void brcmf_chip_axi_resetcore(struct brcmf_core *core, u32 prereset,
+static void brcmf_chip_axi_reset_core(struct brcmf_core *core, u32 prereset,
 				    u32 reset, u32 postreset)
 {
 	struct brcmf_chip *ci = core->chip;
-	int count;
-
-	/* must disable first to work for arbitrary current core state */
-	brcmf_chip_axi_coredisable(core, prereset, reset);
-
-	count = 0;
+	int count = 0;
 
-	while (ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL) &
-	       BCMA_RESET_CTL_RESET) {
+	/* Must disable first to work for arbitrary current core state */
+	brcmf_chip_axi_core_disable(core, prereset, reset);
 
-		ci->ops->write32(ci->ctx, core->wrapbase + BCMA_RESET_CTL, 0);
+	while ((brcmf_readl(ci, core->wrapbase + BCMA_RESET_CTL) &
+			BCMA_RESET_CTL_RESET) &&
+			count++ <= 50) {
 
-		count++;
-
-		if (count > 50)
-			break;
+		brcmf_writel(ci, core->wrapbase + BCMA_RESET_CTL, 0);
 
 		usleep_range(40, 60);
 	}
 
-	ci->ops->write32(ci->ctx, core->wrapbase + BCMA_IOCTL,
-			 postreset | BCMA_IOCTL_CLK);
-
-	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
-}
-
-static char *brcmf_chip_name(uint chipid, char *buf, uint len)
-{
-	const char *fmt;
-
-	fmt = ((chipid > 0xa000) || (chipid < 0x4000)) ? "%d" : "%x";
-	snprintf(buf, len, fmt, chipid);
-	return buf;
+	brcmf_writelp(ci, core->wrapbase + BCMA_IOCTL,
+			postreset | BCMA_IOCTL_CLK);
 }
 
 static struct brcmf_core *__brcmf_chip_add_core(struct brcmf_chip *ci,
@@ -481,9 +481,9 @@ static struct brcmf_core *__brcmf_chip_add_core(struct brcmf_chip *ci,
 	if (!core)
 		return NULL;
 
+	core->chip = ci;
 	core->id = coreid;
 	core->base = base;
-	core->chip = ci;
 	core->wrapbase = wrapbase;
 
 	list_add_tail(&core->list, &ci->cores);
@@ -496,16 +496,16 @@ static struct brcmf_core *brcmf_chip_add_sb_core(struct brcmf_chip *ci,
 					      u32 wrapbase)
 {
 	struct brcmf_core *core;
-	u32 regdata;
+	u32 val;
 
 	core = __brcmf_chip_add_core(ci, coreid, base, wrapbase);
 
 	if (!core)
 		goto out;
 
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(core->base, sbidhigh));
+	val = brcmf_readl(ci, CORE_SB(core->base, sbidhigh));
 
-	core->rev = SBCOREREV(regdata);
+	core->rev = (val & 0xf) | ((val & 0x7000) >> 8);
 
 out:
 	return core;
@@ -573,34 +573,29 @@ static int brcmf_chip_cores_check(struct brcmf_chip *ci)
 	return 0;
 }
 
-static u32 brcmf_chip_core_read32(struct brcmf_core *core, u16 reg)
-{
-	return core->chip->ops->read32(core->chip->ctx, core->base + reg);
-}
-
-static void brcmf_chip_core_write32(struct brcmf_core *core,
-				    u16 reg, u32 val)
-{
-	core->chip->ops->write32(core->chip->ctx, core->base + reg, val);
-}
-
 static bool brcmf_chip_socram_banksize(struct brcmf_core *core, u8 idx,
 				       u32 *banksize)
 {
+	struct brcmf_chip *ci = core->chip;
 	u32 bankinfo;
 	u32 bankidx = (SOCRAM_MEMTYPE_RAM << SOCRAM_BANKIDX_MEMTYPE_SHIFT);
 
 	bankidx |= idx;
-	brcmf_chip_core_write32(core, SOCRAMREGOFFS(bankidx), bankidx);
-	bankinfo = brcmf_chip_core_read32(core, SOCRAMREGOFFS(bankinfo));
+
+	brcmf_writel(ci, core->base + SOCRAMREGOFFS(bankidx), bankidx);
+
+	bankinfo = brcmf_readl(ci, core->base + SOCRAMREGOFFS(bankinfo));
+
 	*banksize = (bankinfo & SOCRAM_BANKINFO_SZMASK) + 1;
 	*banksize *= SOCRAM_BANKINFO_SZBASE;
+
 	return !!(bankinfo & SOCRAM_BANKINFO_RETNTRAM_MASK);
 }
 
 static void brcmf_chip_socram_ramsize(struct brcmf_core *sr, u32 *ramsize,
 				      u32 *srsize)
 {
+	struct brcmf_chip *ci = sr->chip;
 	u32 coreinfo;
 	uint nb, banksize, lss;
 	bool retent;
@@ -616,7 +611,8 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core *sr, u32 *ramsize,
 		brcmf_chip_resetcore(sr, 0, 0, 0);
 
 	/* Get info for determining size */
-	coreinfo = brcmf_chip_core_read32(sr, SOCRAMREGOFFS(coreinfo));
+	coreinfo = brcmf_readl(ci, sr->base + SOCRAMREGOFFS(coreinfo));
+
 	nb = (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
 
 	if ((sr->rev <= 7) || (sr->rev == 12)) {
@@ -657,6 +653,7 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core *sr, u32 *ramsize,
 /** Return the SYS MEM size */
 static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core *sysmem)
 {
+	struct brcmf_chip *ci = sysmem->chip;
 	u32 memsize = 0;
 	u32 coreinfo;
 	u32 idx;
@@ -666,7 +663,7 @@ static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core *sysmem)
 	if (!brcmf_chip_iscoreup(sysmem))
 		brcmf_chip_resetcore(sysmem, 0, 0, 0);
 
-	coreinfo = brcmf_chip_core_read32(sysmem, SYSMEMREGOFFS(coreinfo));
+	coreinfo = brcmf_readl(ci, sysmem->base + SYSMEMREGOFFS(coreinfo));
 	nb = (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
 
 	for (idx = 0; idx < nb; idx++) {
@@ -680,6 +677,7 @@ static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core *sysmem)
 /** Return the TCM-RAM size of the ARMCR4 core. */
 static u32 brcmf_chip_tcm_ramsize(struct brcmf_core *cr4)
 {
+	struct brcmf_chip *ci = cr4->chip;
 	u32 corecap;
 	u32 memsize = 0;
 	u32 nab;
@@ -688,15 +686,18 @@ static u32 brcmf_chip_tcm_ramsize(struct brcmf_core *cr4)
 	u32 bxinfo;
 	u32 idx;
 
-	corecap = brcmf_chip_core_read32(cr4, ARMCR4_CAP);
+	corecap = brcmf_readl(ci, cr4->base + ARMCR4_CAP);
 
 	nab = (corecap & ARMCR4_TCBANB_MASK) >> ARMCR4_TCBANB_SHIFT;
 	nbb = (corecap & ARMCR4_TCBBNB_MASK) >> ARMCR4_TCBBNB_SHIFT;
+
 	totb = nab + nbb;
 
 	for (idx = 0; idx < totb; idx++) {
-		brcmf_chip_core_write32(cr4, ARMCR4_BANKIDX, idx);
-		bxinfo = brcmf_chip_core_read32(cr4, ARMCR4_BANKINFO);
+		brcmf_writel(ci, cr4->base + ARMCR4_BANKIDX, idx);
+
+		bxinfo = brcmf_readl(ci, cr4->base + ARMCR4_BANKINFO);
+
 		memsize += ((bxinfo & ARMCR4_BSZ_MASK) + 1) * ARMCR4_BSZ_MULT;
 	}
 
@@ -786,15 +787,17 @@ static u32 brcmf_chip_dmp_get_desc(struct brcmf_chip *ci, u32 *eromaddr,
 {
 	u32 val;
 
-	/* read next descriptor */
-	val = ci->ops->read32(ci->ctx, *eromaddr);
+	/* Read next descriptor */
+	val = brcmf_readl(ci, *eromaddr);
+
 	*eromaddr += 4;
 
 	if (!type)
 		return val;
 
-	/* determine descriptor type */
+	/* Determine descriptor type */
 	*type = (val & DMP_DESC_TYPE_MSK);
+
 	if ((*type & ~DMP_DESC_ADDRSIZE_GT32) == DMP_DESC_ADDRESS)
 		*type = DMP_DESC_ADDRESS;
 
@@ -885,7 +888,7 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip *ci)
 	u32 base, wrap;
 	int err;
 
-	eromaddr = ci->ops->read32(ci->ctx, CORE_CC_REG(SI_ENUM_BASE, eromptr));
+	eromaddr = brcmf_readl(ci, CORE_CC_REG(SI_ENUM_BASE, eromptr));
 
 	while (desc_type != DMP_DESC_EOT) {
 		val = brcmf_chip_dmp_get_desc(ci, &eromaddr, &desc_type);
@@ -960,80 +963,79 @@ static int brcmf_chip_add_static(struct brcmf_chip *ci,
 
 static int brcmf_chip_probe(struct brcmf_chip *ci)
 {
-	u32 regdata;
-	u32 socitype;
+	u32 val, socitype;
 	int ret;
 
-	/* Get CC core rev
-	 * Chipid is assume to be at offset 0 from SI_ENUM_BASE
-	 * For different chiptypes or old sdio hosts w/o chipcommon,
-	 * other ways of to probe should be added here.
-	 */
-	regdata = ci->ops->read32(ci->ctx, CORE_CC_REG(SI_ENUM_BASE, chipid));
+	val = brcmf_readl(ci, CORE_CC_REG(SI_ENUM_BASE, chipid));
 
-	ci->chip = regdata & CID_ID_MASK;
-	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 
-	socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
+	ci->chip = val & CID_ID_MASK;
+	ci->chiprev = (val & CID_REV_MASK) >> CID_REV_SHIFT;
 
-	brcmf_chip_name(ci->chip, ci->name, sizeof(ci->name));
+	snprintf(ci->name, sizeof(ci->name), 
+		(ci->chip > 0xa000 || ci->chip < 0x4000) ? "%d" : "%x",
+		ci->chip);
 
-	printk("found %s chip: BCM%s, rev=%d\n",
-		  socitype == SOCI_SB ? "SB" : "AXI", ci->name,
-		  ci->chiprev);
+	socitype = (val & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
 	switch(socitype) {
 		case SOCI_SB:
 
-		switch(ci->chip) {
-			case BRCM_CC_4329_CHIP_ID:
-				ret = brcmf_chip_add_static(ci, brcmf_4329);
-				break;
-			default:
-				brcmf_err("SB chip is not supported\n");
-				return -ENODEV;
-		}
+			switch(ci->chip) {
+				case BRCM_CC_4329_CHIP_ID:
+					ret = brcmf_chip_add_static(ci, brcmf_4329);
+					break;
+				default:
+					brcmf_err("SB chip is not supported\n");
+					return -ENODEV;
+			}
 
-		if(!ret)
-			return -ENODEV;
+			if(!ret)
+				return -ENODEV;
 
-		ci->iscoreup = brcmf_chip_sb_iscoreup;
-		ci->coredisable = brcmf_chip_sb_coredisable;
-		ci->resetcore = brcmf_chip_sb_resetcore;
+			ci->iscoreup = brcmf_chip_sb_iscoreup;
+			ci->coredisable = brcmf_chip_sb_core_disable;
+			ci->resetcore = brcmf_chip_sb_reset_core;
 
-		break;
-	case SOCI_AXI:
+			break;
+		case SOCI_AXI:
 
-		if (brcmf_chip_dmp_erom_scan(ci))
-			return -ENODEV;
+			if (brcmf_chip_dmp_erom_scan(ci))
+				return -ENODEV;
 
-		ci->iscoreup = brcmf_chip_axi_iscoreup;
-		ci->coredisable = brcmf_chip_axi_coredisable;
-		ci->resetcore = brcmf_chip_axi_resetcore;
+			ci->iscoreup = brcmf_chip_axi_iscoreup;
+			ci->coredisable = brcmf_chip_axi_core_disable;
+			ci->resetcore = brcmf_chip_axi_reset_core;
 
-		break;
-	default:
-		brcmf_err("chip backplane type %u is not supported\n",
-			  socitype);
-		return -ENODEV;
+			break;
+		default:
+			brcmf_err("chip backplane type %u is not supported\n",
+				  socitype);
+			return -ENODEV;
 	}
 
 	ret = brcmf_chip_cores_check(ci);
 	if (ret)
 		return ret;
 
-	/* assure chip is passive for core access */
+	/* Ensure chip is passive for core access */
 	brcmf_chip_set_passive(ci);
 
-	/* Call bus specific reset function now. Cores have been determined
-	 * but further access may require a chip specific reset at this point.
+	/* Cores have been probed, but further access may require a chip
+	 * specific reset at this point.
 	 */
 	if (ci->ops->reset) {
 		ci->ops->reset(ci->ctx, ci);
 		brcmf_chip_set_passive(ci);
 	}
 
-	return brcmf_chip_get_raminfo(ci);
+	ret = brcmf_chip_get_raminfo(ci);
+
+	printk("Found BCM%s, %s backplane, rev=%d\n", ci->name,
+		  socitype == SOCI_SB ? "SB" : "AXI",
+		  ci->chiprev);
+
+	return ret;
 }
 
 static void brcmf_chip_disable_arm(struct brcmf_chip *chip, u16 id)
@@ -1053,9 +1055,11 @@ static void brcmf_chip_disable_arm(struct brcmf_chip *chip, u16 id)
 	case BCMA_CORE_ARM_CR4:
 	case BCMA_CORE_ARM_CA7:
 
-		/* clear all IOCTL bits except HALT bit */
-		val = chip->ops->read32(chip->ctx, cpu->wrapbase + BCMA_IOCTL);
+		/* Clear all IOCTL bits except HALT bit */
+		val = brcmf_readl(chip, cpu->wrapbase + BCMA_IOCTL);
+
 		val &= ARMCR4_BCMA_IOCTL_CPUHALT;
+
 		brcmf_chip_resetcore(cpu, val, ARMCR4_BCMA_IOCTL_CPUHALT,
 				     ARMCR4_BCMA_IOCTL_CPUHALT);
 		break;
@@ -1076,17 +1080,14 @@ static int brcmf_chip_setup(struct brcmf_chip *chip)
 	base = cc->base;
 
 	/* get chipcommon capabilites */
-	chip->cc_caps = chip->ops->read32(chip->ctx,
-					 CORE_CC_REG(base, capabilities));
-	chip->cc_caps_ext = chip->ops->read32(chip->ctx,
-					     CORE_CC_REG(base,
+	chip->cc_caps = brcmf_readl(chip, CORE_CC_REG(base, capabilities));
+	chip->cc_caps_ext = brcmf_readl(chip, CORE_CC_REG(base,
 							 capabilities_ext));
 
 	/* get pmu caps & rev */
 	pmu = brcmf_chip_get_pmu(chip); /* after reading cc_caps_ext */
 	if (chip->cc_caps & CC_CAP_PMU) {
-		val = chip->ops->read32(chip->ctx,
-					CORE_CC_REG(pmu->base, pmucapabilities));
+		val = brcmf_readl(chip,	CORE_CC_REG(pmu->base, pmucapabilities));
 		chip->pmurev = val & PCAP_REV_MASK;
 		chip->pmucaps = val;
 	}
@@ -1232,8 +1233,8 @@ brcmf_chip_cm3_set_passive(struct brcmf_chip *chip)
 
 	/* disable bank #3 remap for this device */
 	if (chip->chip == BRCM_CC_43430_CHIP_ID) {
-		brcmf_chip_core_write32(core, SOCRAMREGOFFS(bankidx), 3);
-		brcmf_chip_core_write32(core, SOCRAMREGOFFS(bankpda), 0);
+		brcmf_writel(chip, core->base + SOCRAMREGOFFS(bankidx), 3);
+		brcmf_writel(chip, core->base + SOCRAMREGOFFS(bankpda), 0);
 	}
 }
 
@@ -1356,53 +1357,48 @@ bool brcmf_chip_set_active(struct brcmf_chip *chip, u32 rstvec)
 	return false;
 }
 
-bool brcmf_chip_sr_capable(struct brcmf_chip *chip)
+bool brcmf_chip_sr_capable(struct brcmf_chip *ci)
 {
-	struct brcmf_core *pmu = brcmf_chip_get_pmu(chip);
-	u32 base, addr, reg, pmu_cc3_mask = ~0;
+	struct brcmf_core *pmu = brcmf_chip_get_pmu(ci);
+	u32 base, reg, pmu_cc3_mask = ~0;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	/* old chips with PMU version less than 17 don't support save restore */
-	if (chip->pmurev < 17)
+	/* Old chips with PMU version less than 17 don't support save restore */
+	if (ci->pmurev < 17)
 		return false;
 
-	base = brcmf_chip_get_chipcommon(chip)->base;
-
-	switch (chip->chip) {
+	switch (ci->chip) {
 	case BRCM_CC_4354_CHIP_ID:
 	case BRCM_CC_4356_CHIP_ID:
-		/* explicitly check SR engine enable bit */
+		/* Explicitly check SR engine enable bit */
 		pmu_cc3_mask = BIT(2);
-		/* fall-through */
+		/* Fall-through */
 	case BRCM_CC_43241_CHIP_ID:
 	case BRCM_CC_4335_CHIP_ID:
 	case BRCM_CC_4339_CHIP_ID:
 
-		/* read PMU chipcontrol register 3 */
-		addr = CORE_CC_REG(pmu->base, chipcontrol_addr);
-		chip->ops->write32(chip->ctx, addr, 3);
+		/* Read PMU chipcontrol register 3 */
+		brcmf_writel(ci, CORE_CC_REG(pmu->base, chipcontrol_addr), 3);
 
-		addr = CORE_CC_REG(pmu->base, chipcontrol_data);
-		reg = chip->ops->read32(chip->ctx, addr);
+		reg = brcmf_readl(ci, CORE_CC_REG(pmu->base, chipcontrol_data));
 
 		return (reg & pmu_cc3_mask) != 0;
 	case BRCM_CC_43430_CHIP_ID:
 
-		addr = CORE_CC_REG(base, sr_control1);
-		reg = chip->ops->read32(chip->ctx, addr);
+		base = brcmf_chip_get_chipcommon(ci)->base;
+
+		reg = brcmf_readl(ci, CORE_CC_REG(base, sr_control1));
 
 		return reg != 0;
 	default:
 
-		addr = CORE_CC_REG(pmu->base, pmucapabilities_ext);
-		reg = chip->ops->read32(chip->ctx, addr);
+		reg = brcmf_readl(ci, CORE_CC_REG(pmu->base, pmucapabilities_ext));
 
 		if ((reg & PCAPEXT_SR_SUPPORTED_MASK) == 0)
 			return false;
 
-		addr = CORE_CC_REG(pmu->base, retention_ctl);
-		reg = chip->ops->read32(chip->ctx, addr);
+		reg = brcmf_readl(ci, CORE_CC_REG(pmu->base, retention_ctl));
 
 		return (reg & (PMU_RCTL_MACPHY_DISABLE_MASK |
 			       PMU_RCTL_LOGIC_DISABLE_MASK)) == 0;
-- 
2.11.0
