Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:58046 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S933435AbdGSTLA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2017 15:11:00 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 19/34] brcmfmac: Get rid of chip_priv and core_priv structs
Date: Wed, 19 Jul 2017 20:08:07 +0100
Message-Id: <20170719190822.10857-20-ian@mnementh.co.uk> (sfid-20170719_211104_340241_9961C3B3)
In-Reply-To: <20170719190822.10857-1-ian@mnementh.co.uk>
References: <20170719190822.10857-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is zero need to keep these structures separate, they are *always*
allocated together. All they do is obfuscate the code, whilst offering
zero real gain.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 384 +++++++++------------
 .../wireless/broadcom/brcm80211/brcmfmac/chip.h    |  22 ++
 2 files changed, 192 insertions(+), 214 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index 7b8ba7192e1a..781f54bb844b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -223,75 +223,58 @@ struct sbsocramregs {
 #define	ARMCR4_BSZ_MASK		0x3f
 #define	ARMCR4_BSZ_MULT		8192
 
-struct brcmf_core_priv {
-	struct brcmf_core pub;
-	u32 wrapbase;
-	struct list_head list;
-	struct brcmf_chip_priv *chip;
-};
-
-struct brcmf_chip_priv {
-	struct brcmf_chip pub;
-	const struct brcmf_buscore_ops *ops;
-	void *ctx;
-	/* assured first core is chipcommon, second core is buscore */
-	struct list_head cores;
-	u16 num_cores;
-
-	bool (*iscoreup)(struct brcmf_core_priv *core);
-	void (*coredisable)(struct brcmf_core_priv *core, u32 prereset,
-			    u32 reset);
-	void (*resetcore)(struct brcmf_core_priv *core, u32 prereset, u32 reset,
-			  u32 postreset);
-};
 
-static void brcmf_chip_sb_corerev(struct brcmf_chip_priv *ci,
+static void brcmf_chip_sb_corerev(struct brcmf_chip *ci,
 				  struct brcmf_core *core)
 {
 	u32 regdata;
 
 	regdata = ci->ops->read32(ci->ctx, CORE_SB(core->base, sbidhigh));
+
 	core->rev = SBCOREREV(regdata);
 }
 
-static bool brcmf_chip_sb_iscoreup(struct brcmf_core_priv *core)
+static bool brcmf_chip_sb_iscoreup(struct brcmf_core *core)
 {
-	struct brcmf_chip_priv *ci;
+	struct brcmf_chip *ci = core->chip;
 	u32 regdata;
 	u32 address;
 
-	ci = core->chip;
-	address = CORE_SB(core->pub.base, sbtmstatelow);
+	address = CORE_SB(core->base, sbtmstatelow);
+
 	regdata = ci->ops->read32(ci->ctx, address);
+
 	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
 		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
+
 	return SSB_TMSLOW_CLOCK == regdata;
 }
 
-static bool brcmf_chip_ai_iscoreup(struct brcmf_core_priv *core)
+static bool brcmf_chip_ai_iscoreup(struct brcmf_core *core)
 {
-	struct brcmf_chip_priv *ci;
+	struct brcmf_chip *ci = core->chip;
 	u32 regdata;
 	bool ret;
 
-	ci = core->chip;
 	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
+
 	ret = (regdata & (BCMA_IOCTL_FGC | BCMA_IOCTL_CLK)) == BCMA_IOCTL_CLK;
 
 	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
+
 	ret = ret && ((regdata & BCMA_RESET_CTL_RESET) == 0);
 
 	return ret;
 }
 
-static void brcmf_chip_sb_coredisable(struct brcmf_core_priv *core,
+static void brcmf_chip_sb_coredisable(struct brcmf_core *core,
 				      u32 prereset, u32 reset)
 {
-	struct brcmf_chip_priv *ci;
+	struct brcmf_chip *ci = core->chip;
 	u32 val, base;
 
-	ci = core->chip;
-	base = core->pub.base;
+	base = core->base;
+
 	val = ci->ops->read32(ci->ctx, CORE_SB(base, sbtmstatelow));
 	if (val & SSB_TMSLOW_RESET)
 		return;
@@ -354,14 +337,12 @@ static void brcmf_chip_sb_coredisable(struct brcmf_core_priv *core,
 	udelay(1);
 }
 
-static void brcmf_chip_ai_coredisable(struct brcmf_core_priv *core,
+static void brcmf_chip_ai_coredisable(struct brcmf_core *core,
 				      u32 prereset, u32 reset)
 {
-	struct brcmf_chip_priv *ci;
+	struct brcmf_chip *ci = core->chip;
 	u32 regdata;
 
-	ci = core->chip;
-
 	/* if core is already in reset, skip reset */
 	regdata = ci->ops->read32(ci->ctx, core->wrapbase + BCMA_RESET_CTL);
 	if ((regdata & BCMA_RESET_CTL_RESET) != 0)
@@ -388,15 +369,13 @@ static void brcmf_chip_ai_coredisable(struct brcmf_core_priv *core,
 	ci->ops->read32(ci->ctx, core->wrapbase + BCMA_IOCTL);
 }
 
-static void brcmf_chip_sb_resetcore(struct brcmf_core_priv *core, u32 prereset,
+static void brcmf_chip_sb_resetcore(struct brcmf_core *core, u32 prereset,
 				    u32 reset, u32 postreset)
 {
-	struct brcmf_chip_priv *ci;
+	struct brcmf_chip *ci = core->chip;
+	u32 base = core->base;
 	u32 regdata;
-	u32 base;
 
-	ci = core->chip;
-	base = core->pub.base;
 	/*
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
@@ -438,14 +417,12 @@ static void brcmf_chip_sb_resetcore(struct brcmf_core_priv *core, u32 prereset,
 	udelay(1);
 }
 
-static void brcmf_chip_ai_resetcore(struct brcmf_core_priv *core, u32 prereset,
+static void brcmf_chip_ai_resetcore(struct brcmf_core *core, u32 prereset,
 				    u32 reset, u32 postreset)
 {
-	struct brcmf_chip_priv *ci;
+	struct brcmf_chip *ci = core->chip;
 	int count;
 
-	ci = core->chip;
-
 	/* must disable first to work for arbitrary current core state */
 	brcmf_chip_ai_coredisable(core, prereset, reset);
 
@@ -473,29 +450,30 @@ static char *brcmf_chip_name(uint chipid, char *buf, uint len)
 	return buf;
 }
 
-static struct brcmf_core *brcmf_chip_add_core(struct brcmf_chip_priv *ci,
+static struct brcmf_core *brcmf_chip_add_core(struct brcmf_chip *ci,
 					      u16 coreid, u32 base,
 					      u32 wrapbase)
 {
-	struct brcmf_core_priv *core;
+	struct brcmf_core *core;
 
 	core = kzalloc(sizeof(*core), GFP_KERNEL);
 	if (!core)
 		return ERR_PTR(-ENOMEM);
 
-	core->pub.id = coreid;
-	core->pub.base = base;
+	core->id = coreid;
+	core->base = base;
 	core->chip = ci;
 	core->wrapbase = wrapbase;
 
 	list_add_tail(&core->list, &ci->cores);
-	return &core->pub;
+
+	return core;
 }
 
 /* safety check for chipinfo */
-static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
+static int brcmf_chip_cores_check(struct brcmf_chip *ci)
 {
-	struct brcmf_core_priv *core;
+	struct brcmf_core *core;
 	bool need_socram = false;
 	bool has_socram = false;
 	bool cpu_found = false;
@@ -503,10 +481,10 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 
 	list_for_each_entry(core, &ci->cores, list) {
 		brcmf_dbg(INFO, " [%-2d] core 0x%x:%-2d base 0x%08x wrap 0x%08x\n",
-			  idx++, core->pub.id, core->pub.rev, core->pub.base,
+			  idx++, core->id, core->rev, core->base,
 			  core->wrapbase);
 
-		switch (core->pub.id) {
+		switch (core->id) {
 		case BCMA_CORE_ARM_CM3:
 			cpu_found = true;
 			need_socram = true;
@@ -529,26 +507,28 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 		brcmf_err("CPU core not detected\n");
 		return -ENXIO;
 	}
+
 	/* check RAM core presence for ARM CM3 core */
 	if (need_socram && !has_socram) {
 		brcmf_err("RAM core not provided with ARM CM3 core\n");
 		return -ENODEV;
 	}
+
 	return 0;
 }
 
-static u32 brcmf_chip_core_read32(struct brcmf_core_priv *core, u16 reg)
+static u32 brcmf_chip_core_read32(struct brcmf_core *core, u16 reg)
 {
-	return core->chip->ops->read32(core->chip->ctx, core->pub.base + reg);
+	return core->chip->ops->read32(core->chip->ctx, core->base + reg);
 }
 
-static void brcmf_chip_core_write32(struct brcmf_core_priv *core,
+static void brcmf_chip_core_write32(struct brcmf_core *core,
 				    u16 reg, u32 val)
 {
-	core->chip->ops->write32(core->chip->ctx, core->pub.base + reg, val);
+	core->chip->ops->write32(core->chip->ctx, core->base + reg, val);
 }
 
-static bool brcmf_chip_socram_banksize(struct brcmf_core_priv *core, u8 idx,
+static bool brcmf_chip_socram_banksize(struct brcmf_core *core, u8 idx,
 				       u32 *banksize)
 {
 	u32 bankinfo;
@@ -562,7 +542,7 @@ static bool brcmf_chip_socram_banksize(struct brcmf_core_priv *core, u8 idx,
 	return !!(bankinfo & SOCRAM_BANKINFO_RETNTRAM_MASK);
 }
 
-static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
+static void brcmf_chip_socram_ramsize(struct brcmf_core *sr, u32 *ramsize,
 				      u32 *srsize)
 {
 	u32 coreinfo;
@@ -573,17 +553,17 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
 	*ramsize = 0;
 	*srsize = 0;
 
-	if (WARN_ON(sr->pub.rev < 4))
+	if (WARN_ON(sr->rev < 4))
 		return;
 
-	if (!brcmf_chip_iscoreup(&sr->pub))
-		brcmf_chip_resetcore(&sr->pub, 0, 0, 0);
+	if (!brcmf_chip_iscoreup(sr))
+		brcmf_chip_resetcore(sr, 0, 0, 0);
 
 	/* Get info for determining size */
 	coreinfo = brcmf_chip_core_read32(sr, SOCRAMREGOFFS(coreinfo));
 	nb = (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
 
-	if ((sr->pub.rev <= 7) || (sr->pub.rev == 12)) {
+	if ((sr->rev <= 7) || (sr->rev == 12)) {
 		banksize = (coreinfo & SRCI_SRBSZ_MASK);
 		lss = (coreinfo & SRCI_LSS_MASK) >> SRCI_LSS_SHIFT;
 		if (lss != 0)
@@ -602,9 +582,9 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
 	}
 
 	/* hardcoded save&restore memory sizes */
-	switch (sr->chip->pub.chip) {
+	switch (sr->chip->chip) {
 	case BRCM_CC_4334_CHIP_ID:
-		if (sr->chip->pub.chiprev < 2)
+		if (sr->chip->chiprev < 2)
 			*srsize = (32 * 1024);
 		break;
 	case BRCM_CC_43430_CHIP_ID:
@@ -619,7 +599,7 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
 }
 
 /** Return the SYS MEM size */
-static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core_priv *sysmem)
+static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core *sysmem)
 {
 	u32 memsize = 0;
 	u32 coreinfo;
@@ -627,8 +607,8 @@ static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core_priv *sysmem)
 	u32 nb;
 	u32 banksize;
 
-	if (!brcmf_chip_iscoreup(&sysmem->pub))
-		brcmf_chip_resetcore(&sysmem->pub, 0, 0, 0);
+	if (!brcmf_chip_iscoreup(sysmem))
+		brcmf_chip_resetcore(sysmem, 0, 0, 0);
 
 	coreinfo = brcmf_chip_core_read32(sysmem, SYSMEMREGOFFS(coreinfo));
 	nb = (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
@@ -642,7 +622,7 @@ static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core_priv *sysmem)
 }
 
 /** Return the TCM-RAM size of the ARMCR4 core. */
-static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
+static u32 brcmf_chip_tcm_ramsize(struct brcmf_core *cr4)
 {
 	u32 corecap;
 	u32 memsize = 0;
@@ -667,9 +647,9 @@ static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
 	return memsize;
 }
 
-static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
+static u32 brcmf_chip_tcm_rambase(struct brcmf_chip *ci)
 {
-	switch (ci->pub.chip) {
+	switch (ci->chip) {
 	case BRCM_CC_4345_CHIP_ID:
 		return 0x198000;
 	case BRCM_CC_4335_CHIP_ID:
@@ -691,60 +671,53 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_4366_CHIP_ID:
 		return 0x200000;
 	default:
-		brcmf_err("unknown chip: %s\n", ci->pub.name);
+		brcmf_err("unknown chip: %s\n", ci->name);
 		break;
 	}
 	return 0;
 }
 
-static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
+static int brcmf_chip_get_raminfo(struct brcmf_chip *ci)
 {
-	struct brcmf_core_priv *mem_core;
 	struct brcmf_core *mem;
 
-	mem = brcmf_chip_get_core(&ci->pub, BCMA_CORE_ARM_CR4);
+	mem = brcmf_chip_get_core(ci, BCMA_CORE_ARM_CR4);
 	if (mem) {
-		mem_core = container_of(mem, struct brcmf_core_priv, pub);
-		ci->pub.ramsize = brcmf_chip_tcm_ramsize(mem_core);
-		ci->pub.rambase = brcmf_chip_tcm_rambase(ci);
-		if (!ci->pub.rambase) {
+		ci->ramsize = brcmf_chip_tcm_ramsize(mem);
+		ci->rambase = brcmf_chip_tcm_rambase(ci);
+		if (!ci->rambase) {
 			brcmf_err("RAM base not provided with ARM CR4 core\n");
 			return -EINVAL;
 		}
 	} else {
-		mem = brcmf_chip_get_core(&ci->pub, BCMA_CORE_SYS_MEM);
+		mem = brcmf_chip_get_core(ci, BCMA_CORE_SYS_MEM);
 		if (mem) {
-			mem_core = container_of(mem, struct brcmf_core_priv,
-						pub);
-			ci->pub.ramsize = brcmf_chip_sysmem_ramsize(mem_core);
-			ci->pub.rambase = brcmf_chip_tcm_rambase(ci);
-			if (!ci->pub.rambase) {
+			ci->ramsize = brcmf_chip_sysmem_ramsize(mem);
+			ci->rambase = brcmf_chip_tcm_rambase(ci);
+			if (!ci->rambase) {
 				brcmf_err("RAM base not provided with ARM CA7 core\n");
 				return -EINVAL;
 			}
 		} else {
-			mem = brcmf_chip_get_core(&ci->pub,
-						  BCMA_CORE_INTERNAL_MEM);
+			mem = brcmf_chip_get_core(ci, BCMA_CORE_INTERNAL_MEM);
 			if (!mem) {
 				brcmf_err("No memory cores found\n");
 				return -ENOMEM;
 			}
-			mem_core = container_of(mem, struct brcmf_core_priv,
-						pub);
-			brcmf_chip_socram_ramsize(mem_core, &ci->pub.ramsize,
-						  &ci->pub.srsize);
+			brcmf_chip_socram_ramsize(mem, &ci->ramsize,
+						  &ci->srsize);
 		}
 	}
 	brcmf_dbg(INFO, "RAM: base=0x%x size=%d (0x%x) sr=%d (0x%x)\n",
-		  ci->pub.rambase, ci->pub.ramsize, ci->pub.ramsize,
-		  ci->pub.srsize, ci->pub.srsize);
+		  ci->rambase, ci->ramsize, ci->ramsize,
+		  ci->srsize, ci->srsize);
 
-	if (!ci->pub.ramsize) {
+	if (!ci->ramsize) {
 		brcmf_err("RAM size is undetermined\n");
 		return -ENOMEM;
 	}
 
-	if (ci->pub.ramsize > BRCMF_CHIP_MAX_MEMSIZE) {
+	if (ci->ramsize > BRCMF_CHIP_MAX_MEMSIZE) {
 		brcmf_err("RAM size is incorrect\n");
 		return -ENOMEM;
 	}
@@ -752,7 +725,7 @@ static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 	return 0;
 }
 
-static u32 brcmf_chip_dmp_get_desc(struct brcmf_chip_priv *ci, u32 *eromaddr,
+static u32 brcmf_chip_dmp_get_desc(struct brcmf_chip *ci, u32 *eromaddr,
 				   u8 *type)
 {
 	u32 val;
@@ -772,7 +745,7 @@ static u32 brcmf_chip_dmp_get_desc(struct brcmf_chip_priv *ci, u32 *eromaddr,
 	return val;
 }
 
-static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
+static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip *ci, u32 *eromaddr,
 				      u32 *regbase, u32 *wrapbase)
 {
 	u8 desc;
@@ -845,7 +818,7 @@ static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
 }
 
 static
-int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
+int brcmf_chip_dmp_erom_scan(struct brcmf_chip *ci)
 {
 	struct brcmf_core *core;
 	u32 eromaddr;
@@ -905,7 +878,7 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
 	return 0;
 }
 
-static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
+static int brcmf_chip_recognition(struct brcmf_chip *ci)
 {
 	struct brcmf_core *core;
 	u32 regdata;
@@ -918,18 +891,20 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 	 * other ways of recognition should be added here.
 	 */
 	regdata = ci->ops->read32(ci->ctx, CORE_CC_REG(SI_ENUM_BASE, chipid));
-	ci->pub.chip = regdata & CID_ID_MASK;
-	ci->pub.chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
+	ci->chip = regdata & CID_ID_MASK;
+	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
 	socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
-	brcmf_chip_name(ci->pub.chip, ci->pub.name, sizeof(ci->pub.name));
-	brcmf_dbg(INFO, "found %s chip: BCM%s, rev=%d\n",
-		  socitype == SOCI_SB ? "SB" : "AXI", ci->pub.name,
-		  ci->pub.chiprev);
+	brcmf_chip_name(ci->chip, ci->name, sizeof(ci->name));
+
+	printk("found %s chip: BCM%s, rev=%d\n",
+		  socitype == SOCI_SB ? "SB" : "AXI", ci->name,
+		  ci->chiprev);
 
 	switch(socitype) {
 		case SOCI_SB:
-		if (ci->pub.chip != BRCM_CC_4329_CHIP_ID) {
+
+		if (ci->chip != BRCM_CC_4329_CHIP_ID) {
 			brcmf_err("SB chip is not supported\n");
 			return -ENODEV;
 		}
@@ -971,42 +946,40 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 		return ret;
 
 	/* assure chip is passive for core access */
-	brcmf_chip_set_passive(&ci->pub);
+	brcmf_chip_set_passive(ci);
 
 	/* Call bus specific reset function now. Cores have been determined
 	 * but further access may require a chip specific reset at this point.
 	 */
 	if (ci->ops->reset) {
-		ci->ops->reset(ci->ctx, &ci->pub);
-		brcmf_chip_set_passive(&ci->pub);
+		ci->ops->reset(ci->ctx, ci);
+		brcmf_chip_set_passive(ci);
 	}
 
 	return brcmf_chip_get_raminfo(ci);
 }
 
-static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
+static void brcmf_chip_disable_arm(struct brcmf_chip *chip, u16 id)
 {
-	struct brcmf_core *core;
-	struct brcmf_core_priv *cpu;
+	struct brcmf_core *cpu;
 	u32 val;
 
 
-	core = brcmf_chip_get_core(&chip->pub, id);
-	if (!core)
+	cpu = brcmf_chip_get_core(chip, id);
+	if (!cpu)
 		return;
 
 	switch (id) {
 	case BCMA_CORE_ARM_CM3:
-		brcmf_chip_coredisable(core, 0, 0);
+		brcmf_chip_coredisable(cpu, 0, 0);
 		break;
 	case BCMA_CORE_ARM_CR4:
 	case BCMA_CORE_ARM_CA7:
-		cpu = container_of(core, struct brcmf_core_priv, pub);
 
 		/* clear all IOCTL bits except HALT bit */
 		val = chip->ops->read32(chip->ctx, cpu->wrapbase + BCMA_IOCTL);
 		val &= ARMCR4_BCMA_IOCTL_CPUHALT;
-		brcmf_chip_resetcore(core, val, ARMCR4_BCMA_IOCTL_CPUHALT,
+		brcmf_chip_resetcore(cpu, val, ARMCR4_BCMA_IOCTL_CPUHALT,
 				     ARMCR4_BCMA_IOCTL_CPUHALT);
 		break;
 	default:
@@ -1015,41 +988,38 @@ static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
 	}
 }
 
-static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
+static int brcmf_chip_setup(struct brcmf_chip *chip)
 {
-	struct brcmf_chip *pub;
-	struct brcmf_core_priv *cc;
-	struct brcmf_core *pmu;
+	struct brcmf_core *cc, *pmu;
 	u32 base;
 	u32 val;
 	int ret = 0;
 
-	pub = &chip->pub;
-	cc = list_first_entry(&chip->cores, struct brcmf_core_priv, list);
-	base = cc->pub.base;
+	cc = list_first_entry(&chip->cores, struct brcmf_core, list);
+	base = cc->base;
 
 	/* get chipcommon capabilites */
-	pub->cc_caps = chip->ops->read32(chip->ctx,
+	chip->cc_caps = chip->ops->read32(chip->ctx,
 					 CORE_CC_REG(base, capabilities));
-	pub->cc_caps_ext = chip->ops->read32(chip->ctx,
+	chip->cc_caps_ext = chip->ops->read32(chip->ctx,
 					     CORE_CC_REG(base,
 							 capabilities_ext));
 
 	/* get pmu caps & rev */
-	pmu = brcmf_chip_get_pmu(pub); /* after reading cc_caps_ext */
-	if (pub->cc_caps & CC_CAP_PMU) {
+	pmu = brcmf_chip_get_pmu(chip); /* after reading cc_caps_ext */
+	if (chip->cc_caps & CC_CAP_PMU) {
 		val = chip->ops->read32(chip->ctx,
 					CORE_CC_REG(pmu->base, pmucapabilities));
-		pub->pmurev = val & PCAP_REV_MASK;
-		pub->pmucaps = val;
+		chip->pmurev = val & PCAP_REV_MASK;
+		chip->pmucaps = val;
 	}
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, pmucaps=0x%x\n",
-		  cc->pub.rev, pub->pmurev, pub->pmucaps);
+		  cc->rev, chip->pmurev, chip->pmucaps);
 
 	/* execute bus core specific setup */
 	if (chip->ops->setup)
-		ret = chip->ops->setup(chip->ctx, pub);
+		ret = chip->ops->setup(chip->ctx, chip);
 
 	return ret;
 }
@@ -1057,7 +1027,7 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 struct brcmf_chip *brcmf_chip_attach(void *ctx,
 				     const struct brcmf_buscore_ops *ops)
 {
-	struct brcmf_chip_priv *chip;
+	struct brcmf_chip *chip;
 	int err = 0;
 
 	if (WARN_ON(!ops->read32))
@@ -1092,20 +1062,18 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
 	if (err < 0)
 		goto fail;
 
-	return &chip->pub;
+	return chip;
 
 fail:
-	brcmf_chip_detach(&chip->pub);
+	brcmf_chip_detach(chip);
 	return ERR_PTR(err);
 }
 
-void brcmf_chip_detach(struct brcmf_chip *pub)
+void brcmf_chip_detach(struct brcmf_chip *chip)
 {
-	struct brcmf_chip_priv *chip;
-	struct brcmf_core_priv *core;
-	struct brcmf_core_priv *tmp;
+	struct brcmf_core *core;
+	struct brcmf_core *tmp;
 
-	chip = container_of(pub, struct brcmf_chip_priv, pub);
 	list_for_each_entry_safe(core, tmp, &chip->cores, list) {
 		list_del(&core->list);
 		kfree(core);
@@ -1113,40 +1081,38 @@ void brcmf_chip_detach(struct brcmf_chip *pub)
 	kfree(chip);
 }
 
-struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *pub, u16 coreid)
+struct brcmf_core *brcmf_chip_get_core(struct brcmf_chip *chip, u16 coreid)
 {
-	struct brcmf_chip_priv *chip;
-	struct brcmf_core_priv *core;
+	struct brcmf_core *core;
 
-	chip = container_of(pub, struct brcmf_chip_priv, pub);
 	list_for_each_entry(core, &chip->cores, list)
-		if (core->pub.id == coreid)
-			return &core->pub;
+		if (core->id == coreid)
+			return core;
 
 	return NULL;
 }
 
-struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *pub)
+struct brcmf_core *brcmf_chip_get_chipcommon(struct brcmf_chip *chip)
 {
-	struct brcmf_chip_priv *chip;
-	struct brcmf_core_priv *cc;
-
-	chip = container_of(pub, struct brcmf_chip_priv, pub);
-	cc = list_first_entry(&chip->cores, struct brcmf_core_priv, list);
-	if (WARN_ON(!cc || cc->pub.id != BCMA_CORE_CHIPCOMMON))
-		return brcmf_chip_get_core(pub, BCMA_CORE_CHIPCOMMON);
-	return &cc->pub;
+	struct brcmf_core *cc;
+
+	cc = list_first_entry(&chip->cores, struct brcmf_core, list);
+
+	if (WARN_ON(!cc || cc->id != BCMA_CORE_CHIPCOMMON))
+		return brcmf_chip_get_core(chip, BCMA_CORE_CHIPCOMMON);
+
+	return cc;
 }
 
-struct brcmf_core *brcmf_chip_get_pmu(struct brcmf_chip *pub)
+struct brcmf_core *brcmf_chip_get_pmu(struct brcmf_chip *chip)
 {
-	struct brcmf_core *cc = brcmf_chip_get_chipcommon(pub);
+	struct brcmf_core *cc = brcmf_chip_get_chipcommon(chip);
 	struct brcmf_core *pmu;
 
 	/* See if there is separated PMU core available */
 	if (cc->rev >= 35 &&
-	    pub->cc_caps_ext & BCMA_CC_CAP_EXT_AOB_PRESENT) {
-		pmu = brcmf_chip_get_core(pub, BCMA_CORE_PMU);
+	    chip->cc_caps_ext & BCMA_CC_CAP_EXT_AOB_PRESENT) {
+		pmu = brcmf_chip_get_core(chip, BCMA_CORE_PMU);
 		if (pmu)
 			return pmu;
 	}
@@ -1155,188 +1121,178 @@ struct brcmf_core *brcmf_chip_get_pmu(struct brcmf_chip *pub)
 	return cc;
 }
 
-bool brcmf_chip_iscoreup(struct brcmf_core *pub)
+bool brcmf_chip_iscoreup(struct brcmf_core *core)
 {
-	struct brcmf_core_priv *core;
-
-	core = container_of(pub, struct brcmf_core_priv, pub);
 	return core->chip->iscoreup(core);
 }
 
-void brcmf_chip_coredisable(struct brcmf_core *pub, u32 prereset, u32 reset)
+void brcmf_chip_coredisable(struct brcmf_core *core, u32 prereset, u32 reset)
 {
-	struct brcmf_core_priv *core;
-
-	core = container_of(pub, struct brcmf_core_priv, pub);
 	core->chip->coredisable(core, prereset, reset);
 }
 
-void brcmf_chip_resetcore(struct brcmf_core *pub, u32 prereset, u32 reset,
+void brcmf_chip_resetcore(struct brcmf_core *core, u32 prereset, u32 reset,
 			  u32 postreset)
 {
-	struct brcmf_core_priv *core;
-
-	core = container_of(pub, struct brcmf_core_priv, pub);
 	core->chip->resetcore(core, prereset, reset, postreset);
 }
 
 static void
-brcmf_chip_cm3_set_passive(struct brcmf_chip_priv *chip)
+brcmf_chip_cm3_set_passive(struct brcmf_chip *chip)
 {
 	struct brcmf_core *core;
-	struct brcmf_core_priv *sr;
 
 	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CM3);
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
+
+	core = brcmf_chip_get_core(chip, BCMA_CORE_80211);
 	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
 				   D11_BCMA_IOCTL_PHYCLOCKEN,
 			     D11_BCMA_IOCTL_PHYCLOCKEN,
 			     D11_BCMA_IOCTL_PHYCLOCKEN);
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_INTERNAL_MEM);
+
+	core = brcmf_chip_get_core(chip, BCMA_CORE_INTERNAL_MEM);
 	brcmf_chip_resetcore(core, 0, 0, 0);
 
 	/* disable bank #3 remap for this device */
-	if (chip->pub.chip == BRCM_CC_43430_CHIP_ID) {
-		sr = container_of(core, struct brcmf_core_priv, pub);
-		brcmf_chip_core_write32(sr, SOCRAMREGOFFS(bankidx), 3);
-		brcmf_chip_core_write32(sr, SOCRAMREGOFFS(bankpda), 0);
+	if (chip->chip == BRCM_CC_43430_CHIP_ID) {
+		brcmf_chip_core_write32(core, SOCRAMREGOFFS(bankidx), 3);
+		brcmf_chip_core_write32(core, SOCRAMREGOFFS(bankpda), 0);
 	}
 }
 
-static bool brcmf_chip_cm3_set_active(struct brcmf_chip_priv *chip)
+static bool brcmf_chip_cm3_set_active(struct brcmf_chip *chip)
 {
 	struct brcmf_core *core;
 
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_INTERNAL_MEM);
+	core = brcmf_chip_get_core(chip, BCMA_CORE_INTERNAL_MEM);
+
 	if (!brcmf_chip_iscoreup(core)) {
 		brcmf_err("SOCRAM core is down after reset?\n");
 		return false;
 	}
 
-	chip->ops->activate(chip->ctx, &chip->pub, 0);
+	chip->ops->activate(chip->ctx, chip, 0);
 
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CM3);
+	core = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CM3);
 	brcmf_chip_resetcore(core, 0, 0, 0);
 
 	return true;
 }
 
 static inline void
-brcmf_chip_cr4_set_passive(struct brcmf_chip_priv *chip)
+brcmf_chip_cr4_set_passive(struct brcmf_chip *chip)
 {
 	struct brcmf_core *core;
 
 	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CR4);
 
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
+	core = brcmf_chip_get_core(chip, BCMA_CORE_80211);
 	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
 				   D11_BCMA_IOCTL_PHYCLOCKEN,
 			     D11_BCMA_IOCTL_PHYCLOCKEN,
 			     D11_BCMA_IOCTL_PHYCLOCKEN);
 }
 
-static bool brcmf_chip_cr4_set_active(struct brcmf_chip_priv *chip, u32 rstvec)
+static bool brcmf_chip_cr4_set_active(struct brcmf_chip *chip, u32 rstvec)
 {
 	struct brcmf_core *core;
 
-	chip->ops->activate(chip->ctx, &chip->pub, rstvec);
+	chip->ops->activate(chip->ctx, chip, rstvec);
 
 	/* restore ARM */
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CR4);
+	core = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CR4);
 	brcmf_chip_resetcore(core, ARMCR4_BCMA_IOCTL_CPUHALT, 0, 0);
 
 	return true;
 }
 
 static inline void
-brcmf_chip_ca7_set_passive(struct brcmf_chip_priv *chip)
+brcmf_chip_ca7_set_passive(struct brcmf_chip *chip)
 {
 	struct brcmf_core *core;
 
 	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CA7);
 
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
+	core = brcmf_chip_get_core(chip, BCMA_CORE_80211);
 	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
 				   D11_BCMA_IOCTL_PHYCLOCKEN,
 			     D11_BCMA_IOCTL_PHYCLOCKEN,
 			     D11_BCMA_IOCTL_PHYCLOCKEN);
 }
 
-static bool brcmf_chip_ca7_set_active(struct brcmf_chip_priv *chip, u32 rstvec)
+static bool brcmf_chip_ca7_set_active(struct brcmf_chip *chip, u32 rstvec)
 {
 	struct brcmf_core *core;
 
-	chip->ops->activate(chip->ctx, &chip->pub, rstvec);
+	chip->ops->activate(chip->ctx, chip, rstvec);
 
 	/* restore ARM */
-	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CA7);
+	core = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CA7);
 	brcmf_chip_resetcore(core, ARMCR4_BCMA_IOCTL_CPUHALT, 0, 0);
 
 	return true;
 }
 
-void brcmf_chip_set_passive(struct brcmf_chip *pub)
+void brcmf_chip_set_passive(struct brcmf_chip *chip)
 {
-	struct brcmf_chip_priv *chip;
 	struct brcmf_core *arm;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	chip = container_of(pub, struct brcmf_chip_priv, pub);
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CR4);
+	arm = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CR4);
 	if (arm) {
 		brcmf_chip_cr4_set_passive(chip);
 		return;
 	}
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CA7);
+
+	arm = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CA7);
 	if (arm) {
 		brcmf_chip_ca7_set_passive(chip);
 		return;
 	}
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+
+	arm = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CM3);
 	if (arm) {
 		brcmf_chip_cm3_set_passive(chip);
 		return;
 	}
 }
 
-bool brcmf_chip_set_active(struct brcmf_chip *pub, u32 rstvec)
+bool brcmf_chip_set_active(struct brcmf_chip *chip, u32 rstvec)
 {
-	struct brcmf_chip_priv *chip;
 	struct brcmf_core *arm;
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	chip = container_of(pub, struct brcmf_chip_priv, pub);
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CR4);
+	arm = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CR4);
 	if (arm)
 		return brcmf_chip_cr4_set_active(chip, rstvec);
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CA7);
+
+	arm = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CA7);
 	if (arm)
 		return brcmf_chip_ca7_set_active(chip, rstvec);
-	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+
+	arm = brcmf_chip_get_core(chip, BCMA_CORE_ARM_CM3);
 	if (arm)
 		return brcmf_chip_cm3_set_active(chip);
 
 	return false;
 }
 
-bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
+bool brcmf_chip_sr_capable(struct brcmf_chip *chip)
 {
+	struct brcmf_core *pmu = brcmf_chip_get_pmu(chip);
 	u32 base, addr, reg, pmu_cc3_mask = ~0;
-	struct brcmf_chip_priv *chip;
-	struct brcmf_core *pmu = brcmf_chip_get_pmu(pub);
 
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* old chips with PMU version less than 17 don't support save restore */
-	if (pub->pmurev < 17)
+	if (chip->pmurev < 17)
 		return false;
 
-	base = brcmf_chip_get_chipcommon(pub)->base;
-	chip = container_of(pub, struct brcmf_chip_priv, pub);
+	base = brcmf_chip_get_chipcommon(chip)->base;
 
-	switch (pub->chip) {
+	switch (chip->chip) {
 	case BRCM_CC_4354_CHIP_ID:
 	case BRCM_CC_4356_CHIP_ID:
 		/* explicitly check SR engine enable bit */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
index dd0ec3eba6a9..0babb328d155 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.h
@@ -21,6 +21,8 @@
 #define CORE_CC_REG(base, field) \
 		(base + offsetof(struct chipcregs, field))
 
+struct brcmf_core;
+
 /**
  * struct brcmf_chip - chip level information.
  *
@@ -36,6 +38,20 @@
  * @name: string representation of the chip identifier.
  */
 struct brcmf_chip {
+	const struct brcmf_buscore_ops *ops;
+
+	/* assured first core is chipcommon, second core is buscore */
+	//FIXME: Really? does not appear to hold true for 43430
+	struct list_head cores; /* List of cores in this chip */
+	u16 num_cores;
+
+	bool (*iscoreup)(struct brcmf_core *core);
+	void (*coredisable)(struct brcmf_core *core, u32 prereset, u32 reset);
+	void (*resetcore)(struct brcmf_core *core, u32 prereset, u32 reset,
+				u32 postreset);
+
+	void *ctx;
+
 	u32 chip;
 	u32 chiprev;
 	u32 cc_caps;
@@ -45,6 +61,7 @@ struct brcmf_chip {
 	u32 rambase;
 	u32 ramsize;
 	u32 srsize;
+
 	char name[8];
 };
 
@@ -56,9 +73,14 @@ struct brcmf_chip {
  * @base: base address of core register space.
  */
 struct brcmf_core {
+	struct brcmf_chip *chip; /* Parent chip */
+	struct list_head list;
+
 	u16 id;
 	u16 rev;
 	u32 base;
+	u32 wrapbase;
+
 };
 
 /**
-- 
2.11.0
