Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48252 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751365AbdGZUpY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:45:24 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 21/34] brcmfmac: Simplify chip probe routine
Date: Wed, 26 Jul 2017 21:25:44 +0100
Message-Id: <20170726202557.15632-22-ian@mnementh.co.uk> (sfid-20170726_224529_771315_9F687A7B)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Renamed routine in line with kernel convention.
* Improved handling of chips that cannot autoprobe

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 .../wireless/broadcom/brcm80211/brcmfmac/chip.c    | 132 +++++++++++++--------
 1 file changed, 84 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index daa3c335804b..3fe75aa30d9b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -223,17 +223,6 @@ struct sbsocramregs {
 #define	ARMCR4_BSZ_MASK		0x3f
 #define	ARMCR4_BSZ_MULT		8192
 
-
-static void brcmf_chip_sb_corerev(struct brcmf_chip *ci,
-				  struct brcmf_core *core)
-{
-	u32 regdata;
-
-	regdata = ci->ops->read32(ci->ctx, CORE_SB(core->base, sbidhigh));
-
-	core->rev = SBCOREREV(regdata);
-}
-
 static bool brcmf_chip_sb_iscoreup(struct brcmf_core *core)
 {
 	struct brcmf_chip *ci = core->chip;
@@ -482,15 +471,15 @@ static char *brcmf_chip_name(uint chipid, char *buf, uint len)
 	return buf;
 }
 
-static struct brcmf_core *brcmf_chip_add_core(struct brcmf_chip *ci,
-					      u16 coreid, u32 base,
-					      u32 wrapbase)
+static struct brcmf_core *__brcmf_chip_add_core(struct brcmf_chip *ci,
+						u16 coreid, u32 base,
+						u32 wrapbase)
 {
 	struct brcmf_core *core;
 
 	core = kzalloc(sizeof(*core), GFP_KERNEL);
 	if (!core)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	core->id = coreid;
 	core->base = base;
@@ -502,6 +491,40 @@ static struct brcmf_core *brcmf_chip_add_core(struct brcmf_chip *ci,
 	return core;
 }
 
+static struct brcmf_core *brcmf_chip_add_sb_core(struct brcmf_chip *ci,
+						 u16 coreid, u32 base,
+						 u32 wrapbase)
+{
+	struct brcmf_core *core;
+	u32 regdata;
+
+	core = __brcmf_chip_add_core(ci, coreid, base, wrapbase);
+
+	if (!core)
+		goto out;
+
+	regdata = ci->ops->read32(ci->ctx, CORE_SB(core->base, sbidhigh));
+
+	core->rev = SBCOREREV(regdata);
+
+out:
+	return core;
+}
+
+static struct brcmf_core *brcmf_chip_add_axi_core(struct brcmf_chip *ci,
+						  u16 coreid, u32 base,
+						  u32 wrapbase, u8 rev)
+{
+	struct brcmf_core *core;
+
+	core = __brcmf_chip_add_core(ci, coreid, base, wrapbase);
+
+	if (core)
+		core->rev = rev;
+
+	return core;
+}
+
 /* safety check for chipinfo */
 static int brcmf_chip_cores_check(struct brcmf_chip *ci)
 {
@@ -900,19 +923,41 @@ int brcmf_chip_dmp_erom_scan(struct brcmf_chip *ci)
 			continue;
 
 		/* finally a core to be added */
-		core = brcmf_chip_add_core(ci, id, base, wrap);
-		if (IS_ERR(core))
-			return PTR_ERR(core);
-
-		core->rev = rev;
+		core = brcmf_chip_add_axi_core(ci, id, base, wrap, rev);
+		if (!core)
+			return -ENOMEM; //FIXME - Cleanup the allocated cores?
 	}
 
 	return 0;
 }
 
-static int brcmf_chip_recognition(struct brcmf_chip *ci)
+struct brcmf_chip_desc {
+	u16 id;
+	u32 base;
+};
+
+static struct brcmf_chip_desc brcmf_4329[] = {
+	{ BCMA_CORE_CHIPCOMMON,   SI_ENUM_BASE },
+	{ BCMA_CORE_SDIO_DEV,     BCM4329_CORE_BUS_BASE },
+	{ BCMA_CORE_INTERNAL_MEM, BCM4329_CORE_SOCRAM_BASE },
+	{ BCMA_CORE_ARM_CM3,      BCM4329_CORE_ARM_BASE },
+	{ BCMA_CORE_80211,        0x18001000 },
+	{ 0, 0},
+};
+
+static int brcmf_chip_add_static(struct brcmf_chip *ci,
+				 struct brcmf_chip_desc *desc)
+{
+	for ( ; desc->id ; desc++)
+		brcmf_chip_add_sb_core(ci, desc->id, desc->base, 0);
+
+	//FIXME: cleanup if we fail to add a core?
+
+	return 0;
+}
+
+static int brcmf_chip_probe(struct brcmf_chip *ci)
 {
-	struct brcmf_core *core;
 	u32 regdata;
 	u32 socitype;
 	int ret;
@@ -920,11 +965,13 @@ static int brcmf_chip_recognition(struct brcmf_chip *ci)
 	/* Get CC core rev
 	 * Chipid is assume to be at offset 0 from SI_ENUM_BASE
 	 * For different chiptypes or old sdio hosts w/o chipcommon,
-	 * other ways of recognition should be added here.
+	 * other ways of to probe should be added here.
 	 */
 	regdata = ci->ops->read32(ci->ctx, CORE_CC_REG(SI_ENUM_BASE, chipid));
+
 	ci->chip = regdata & CID_ID_MASK;
 	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
+
 	socitype = (regdata & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 
 	brcmf_chip_name(ci->chip, ci->name, sizeof(ci->name));
@@ -932,46 +979,35 @@ static int brcmf_chip_recognition(struct brcmf_chip *ci)
 	printk(KERN_LOG "found %s chip: BCM%s, rev=%d\n",
 	       socitype == SOCI_SB ? "SB" : "AXI", ci->name, ci->chiprev);
 
-	switch(socitype) {
-		case SOCI_SB:
+	switch (socitype) {
+	case SOCI_SB:
 
-		if (ci->chip != BRCM_CC_4329_CHIP_ID) {
+		switch (ci->chip) {
+		case BRCM_CC_4329_CHIP_ID:
+			ret = brcmf_chip_add_static(ci, brcmf_4329);
+			break;
+		default:
 			brcmf_err("SB chip is not supported\n");
 			return -ENODEV;
 		}
 
+		if (!ret)
+			return -ENODEV;
+
 		ci->iscoreup = brcmf_chip_sb_iscoreup;
 		ci->coredisable = brcmf_chip_sb_coredisable;
 		ci->resetcore = brcmf_chip_sb_resetcore;
 
-		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
-					   SI_ENUM_BASE, 0);
-		brcmf_chip_sb_corerev(ci, core);
-
-		core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-					   BCM4329_CORE_BUS_BASE, 0);
-		brcmf_chip_sb_corerev(ci, core);
-
-		core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
-					   BCM4329_CORE_SOCRAM_BASE, 0);
-		brcmf_chip_sb_corerev(ci, core);
-
-		core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
-					   BCM4329_CORE_ARM_BASE, 0);
-		brcmf_chip_sb_corerev(ci, core);
-
-		core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0);
-		brcmf_chip_sb_corerev(ci, core);
-
 		break;
 	case SOCI_AXI:
 
+		if (brcmf_chip_dmp_erom_scan(ci))
+			return -ENODEV;
+
 		ci->iscoreup = brcmf_chip_ai_iscoreup;
 		ci->coredisable = brcmf_chip_ai_coredisable;
 		ci->resetcore = brcmf_chip_ai_resetcore;
 
-		brcmf_chip_dmp_erom_scan(ci);
-
 		break;
 	default:
 		brcmf_err("chip backplane type %u is not supported\n",
@@ -1092,7 +1128,7 @@ struct brcmf_chip *brcmf_chip_attach(void *ctx,
 	if (err < 0)
 		goto fail;
 
-	err = brcmf_chip_recognition(chip);
+	err = brcmf_chip_probe(chip);
 	if (err < 0)
 		goto fail;
 
-- 
2.11.0
