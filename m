Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:34167 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaA2Ocd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 09:32:33 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 12/14] brcmfmac: get chip core information from the device
Date: Wed, 29 Jan 2014 15:32:22 +0100
Message-ID: <1391005944-3220-13-git-send-email-arend@broadcom.com> (sfid-20140129_153252_923431_82BAF3D7)
In-Reply-To: <1391005944-3220-1-git-send-email-arend@broadcom.com>
References: <1391005944-3220-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of instantiating core info structs based upon the
chip identifier it is now done parsing information provided
on the device.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c |  307 ++++++++++++++++--------
 1 file changed, 203 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 29047ef..b04ea95 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -32,6 +32,55 @@
 #define SOCI_SB		0
 #define SOCI_AI		1
 
+/* PL-368 DMP definitions */
+#define DMP_DESC_TYPE_MSK	0x0000000F
+#define  DMP_DESC_EMPTY		0x00000000
+#define  DMP_DESC_VALID		0x00000001
+#define  DMP_DESC_COMPONENT	0x00000001
+#define  DMP_DESC_MASTER_PORT	0x00000003
+#define  DMP_DESC_ADDRESS	0x00000005
+#define  DMP_DESC_ADDRSIZE_GT32	0x00000008
+#define  DMP_DESC_EOT		0x0000000F
+
+#define DMP_COMP_DESIGNER	0xFFF00000
+#define DMP_COMP_DESIGNER_S	20
+#define DMP_COMP_PARTNUM	0x000FFF00
+#define DMP_COMP_PARTNUM_S	8
+#define DMP_COMP_CLASS		0x000000F0
+#define DMP_COMP_CLASS_S	4
+#define DMP_COMP_REVISION	0xFF000000
+#define DMP_COMP_REVISION_S	24
+#define DMP_COMP_NUM_SWRAP	0x00F80000
+#define DMP_COMP_NUM_SWRAP_S	19
+#define DMP_COMP_NUM_MWRAP	0x0007C000
+#define DMP_COMP_NUM_MWRAP_S	14
+#define DMP_COMP_NUM_SPORT	0x00003E00
+#define DMP_COMP_NUM_SPORT_S	9
+#define DMP_COMP_NUM_MPORT	0x000001F0
+#define DMP_COMP_NUM_MPORT_S	4
+
+#define DMP_MASTER_PORT_UID	0x0000FF00
+#define DMP_MASTER_PORT_UID_S	8
+#define DMP_MASTER_PORT_NUM	0x000000F0
+#define DMP_MASTER_PORT_NUM_S	4
+
+#define DMP_SLAVE_ADDR_BASE	0xFFFFF000
+#define DMP_SLAVE_ADDR_BASE_S	12
+#define DMP_SLAVE_PORT_NUM	0x00000F00
+#define DMP_SLAVE_PORT_NUM_S	8
+#define DMP_SLAVE_TYPE		0x000000C0
+#define DMP_SLAVE_TYPE_S	6
+#define  DMP_SLAVE_TYPE_SLAVE	0
+#define  DMP_SLAVE_TYPE_BRIDGE	1
+#define  DMP_SLAVE_TYPE_SWRAP	2
+#define  DMP_SLAVE_TYPE_MWRAP	3
+#define DMP_SLAVE_SIZE_TYPE	0x00000030
+#define DMP_SLAVE_SIZE_TYPE_S	4
+#define  DMP_SLAVE_SIZE_4K	0
+#define  DMP_SLAVE_SIZE_8K	1
+#define  DMP_SLAVE_SIZE_16K	2
+#define  DMP_SLAVE_SIZE_DESC	3
+
 /* EROM CompIdentB */
 #define CIB_REV_MASK		0xff000000
 #define CIB_REV_SHIFT		24
@@ -393,8 +442,9 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 	int idx = 1;
 
 	list_for_each_entry(core, &ci->cores, list) {
-		brcmf_dbg(INFO, " [%-2d] core 0x%x rev %-2d base 0x%08x\n",
-			  idx++, core->pub.id, core->pub.rev, core->pub.base);
+		brcmf_dbg(INFO, " [%-2d] core 0x%x:%-2d base 0x%08x wrap 0x%08x\n",
+			  idx++, core->pub.id, core->pub.rev, core->pub.base,
+			  core->wrapbase);
 
 		switch (core->pub.id) {
 		case BCMA_CORE_ARM_CM3:
@@ -463,6 +513,151 @@ static void brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 	}
 }
 
+static u32 brcmf_chip_dmp_get_desc(struct brcmf_chip_priv *ci, u32 *eromaddr,
+				   u8 *type)
+{
+	u32 val;
+
+	/* read next descriptor */
+	val = ci->ops->read32(ci->ctx, *eromaddr);
+	*eromaddr += 4;
+
+	if (!type)
+		return val;
+
+	/* determine descriptor type */
+	*type = (val & DMP_DESC_TYPE_MSK);
+	if ((*type & ~DMP_DESC_ADDRSIZE_GT32) == DMP_DESC_ADDRESS)
+		*type = DMP_DESC_ADDRESS;
+
+	return val;
+}
+
+static int brcmf_chip_dmp_get_regaddr(struct brcmf_chip_priv *ci, u32 *eromaddr,
+				      u32 *regbase, u32 *wrapbase)
+{
+	u8 desc;
+	u32 val;
+	u8 mpnum = 0;
+	u8 stype, sztype, wraptype;
+
+	*regbase = 0;
+	*wrapbase = 0;
+
+	val = brcmf_chip_dmp_get_desc(ci, eromaddr, &desc);
+	if (desc == DMP_DESC_MASTER_PORT) {
+		mpnum = (val & DMP_MASTER_PORT_NUM) >> DMP_MASTER_PORT_NUM_S;
+		wraptype = DMP_SLAVE_TYPE_MWRAP;
+	} else if (desc == DMP_DESC_ADDRESS) {
+		/* revert erom address */
+		*eromaddr -= 4;
+		wraptype = DMP_SLAVE_TYPE_SWRAP;
+	} else {
+		*eromaddr -= 4;
+		return -EILSEQ;
+	}
+
+	do {
+		/* locate address descriptor */
+		do {
+			val = brcmf_chip_dmp_get_desc(ci, eromaddr, &desc);
+			/* unexpected table end */
+			if (desc == DMP_DESC_EOT) {
+				*eromaddr -= 4;
+				return -EFAULT;
+			}
+		} while (desc != DMP_DESC_ADDRESS);
+
+		/* skip upper 32-bit address descriptor */
+		if (val & DMP_DESC_ADDRSIZE_GT32)
+			brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
+
+		sztype = (val & DMP_SLAVE_SIZE_TYPE) >> DMP_SLAVE_SIZE_TYPE_S;
+
+		/* next size descriptor can be skipped */
+		if (sztype == DMP_SLAVE_SIZE_DESC) {
+			val = brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
+			/* skip upper size descriptor if present */
+			if (val & DMP_DESC_ADDRSIZE_GT32)
+				brcmf_chip_dmp_get_desc(ci, eromaddr, NULL);
+		}
+
+		/* only look for 4K register regions */
+		if (sztype != DMP_SLAVE_SIZE_4K)
+			continue;
+
+		stype = (val & DMP_SLAVE_TYPE) >> DMP_SLAVE_TYPE_S;
+
+		/* only regular slave and wrapper */
+		if (*regbase == 0 && stype == DMP_SLAVE_TYPE_SLAVE)
+			*regbase = val & DMP_SLAVE_ADDR_BASE;
+		if (*wrapbase == 0 && stype == wraptype)
+			*wrapbase = val & DMP_SLAVE_ADDR_BASE;
+	} while (*regbase == 0 || *wrapbase == 0);
+
+	return 0;
+}
+
+static
+int brcmf_chip_dmp_erom_scan(struct brcmf_chip_priv *ci)
+{
+	struct brcmf_core *core;
+	u32 eromaddr;
+	u8 desc_type = 0;
+	u32 val;
+	u16 id;
+	u8 nmp, nsp, nmw, nsw, rev;
+	u32 base, wrap;
+	int err;
+
+	eromaddr = ci->ops->read32(ci->ctx, CORE_CC_REG(SI_ENUM_BASE, eromptr));
+
+	while (desc_type != DMP_DESC_EOT) {
+		val = brcmf_chip_dmp_get_desc(ci, &eromaddr, &desc_type);
+		if (!(val & DMP_DESC_VALID))
+			continue;
+
+		if (desc_type == DMP_DESC_EMPTY)
+			continue;
+
+		/* need a component descriptor */
+		if (desc_type != DMP_DESC_COMPONENT)
+			continue;
+
+		id = (val & DMP_COMP_PARTNUM) >> DMP_COMP_PARTNUM_S;
+
+		/* next descriptor must be component as well */
+		val = brcmf_chip_dmp_get_desc(ci, &eromaddr, &desc_type);
+		if (WARN_ON((val & DMP_DESC_TYPE_MSK) != DMP_DESC_COMPONENT))
+			return -EFAULT;
+
+		/* only look at cores with master port(s) */
+		nmp = (val & DMP_COMP_NUM_MPORT) >> DMP_COMP_NUM_MPORT_S;
+		nsp = (val & DMP_COMP_NUM_SPORT) >> DMP_COMP_NUM_SPORT_S;
+		nmw = (val & DMP_COMP_NUM_MWRAP) >> DMP_COMP_NUM_MWRAP_S;
+		nsw = (val & DMP_COMP_NUM_SWRAP) >> DMP_COMP_NUM_SWRAP_S;
+		rev = (val & DMP_COMP_REVISION) >> DMP_COMP_REVISION_S;
+
+		/* need core with ports */
+		if (nmw + nsw == 0)
+			continue;
+
+		/* try to obtain register address info */
+		err = brcmf_chip_dmp_get_regaddr(ci, &eromaddr, &base, &wrap);
+		if (err)
+			continue;
+
+		/* finally a core to be added */
+		core = brcmf_chip_add_core(ci, id, base, wrap);
+		if (IS_ERR(core))
+			return PTR_ERR(core);
+
+		core->rev = rev;
+	}
+
+	return 0;
+}
+
 static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 {
 	struct brcmf_core *core;
@@ -505,114 +700,21 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 		core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
 					   BCM4329_CORE_ARM_BASE, 0);
 		brcmf_chip_sb_corerev(ci, core);
+
+		core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0);
+		brcmf_chip_sb_corerev(ci, core);
 	} else if (socitype == SOCI_AI) {
 		ci->iscoreup = brcmf_chip_ai_iscoreup;
 		ci->coredisable = brcmf_chip_ai_coredisable;
 		ci->resetcore = brcmf_chip_ai_resetcore;
 
-		core = brcmf_chip_add_core(ci, BCMA_CORE_CHIPCOMMON,
-					   SI_ENUM_BASE,
-					   SI_ENUM_BASE + 0x100000);
-
-		/* Address of cores for new chips should be added here */
-		switch (ci->pub.chip) {
-		case BCM43143_CHIP_ID:
-			core->rev = 43;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   BCM43143_CORE_BUS_BASE,
-						   BCM43143_CORE_BUS_BASE +
-						   0x100000);
-			core->rev = 24;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
-						   BCM43143_CORE_SOCRAM_BASE,
-						   BCM43143_CORE_SOCRAM_BASE +
-						   0x100000);
-			core->rev = 20;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
-						   BCM43143_CORE_ARM_BASE,
-						   BCM43143_CORE_ARM_BASE +
-						   0x100000);
-			core->rev = 7;
-			break;
-		case BCM43241_CHIP_ID:
-			core->rev = 42;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   0x18002000, 0x18102000);
-			core->rev = 14;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
-						   0x18004000, 0x18104000);
-			core->rev = 20;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
-						   0x18003000, 0x18103000);
-			core->rev = 7;
-			break;
-		case BCM4330_CHIP_ID:
-			core->rev = 39;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   0x18002000, 0x18102000);
-			core->rev = 7;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
-						   0x18004000, 0x18104000);
-			core->rev = 13;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
-						   0x18003000, 0x18103000);
-			core->rev = 3;
-			break;
-		case BCM4334_CHIP_ID:
-			core->rev = 41;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   0x18002000, 0x18102000);
-			core->rev = 13;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
-						   0x18004000, 0x18104000);
-			core->rev = 19;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
-						   0x18003000, 0x18103000);
-			core->rev = 7;
-			break;
-		case BCM4335_CHIP_ID:
-			core->rev = 43;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   0x18005000, 0x18105000);
-			core->rev = 15;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CR4,
-						   0x18002000, 0x18102000);
-			core->rev = 1;
-			break;
-		case BCM43362_CHIP_ID:
-			core->rev = 39;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   0x18002000, 0x18102000);
-			core->rev = 10;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_INTERNAL_MEM,
-						   0x18004000, 0x18104000);
-			core->rev = 8;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CM3,
-						   0x18003000, 0x18103000);
-			core->rev = 3;
-			break;
-		case BCM4339_CHIP_ID:
-			core->rev = 46;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_SDIO_DEV,
-						   0x18005000, 0x18105000);
-			core->rev = 21;
-			core = brcmf_chip_add_core(ci, BCMA_CORE_ARM_CR4,
-						   0x18002000, 0x18102000);
-			core->rev = 4;
-			break;
-		default:
-			brcmf_err("AXI chip is not supported\n");
-			return -ENODEV;
-		}
+		brcmf_chip_dmp_erom_scan(ci);
 	} else {
 		brcmf_err("chip backplane type %u is not supported\n",
 			  socitype);
 		return -ENODEV;
 	}
 
-	/* add 802.11 core for all chips on same backplane address */
-	core = brcmf_chip_add_core(ci, BCMA_CORE_80211, 0x18001000, 0x18101000);
-
 	brcmf_chip_get_raminfo(ci);
 
 	return brcmf_chip_cores_check(ci);
@@ -652,7 +754,6 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 {
 	struct brcmf_chip *pub;
 	struct brcmf_core_priv *cc;
-	struct brcmf_core_priv *bus;
 	u32 base;
 	u32 val;
 	int ret = 0;
@@ -673,10 +774,8 @@ static int brcmf_chip_setup(struct brcmf_chip_priv *chip)
 		pub->pmucaps = val;
 	}
 
-	bus = list_next_entry(cc, list);
-
-	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		  cc->pub.rev, pub->pmurev, bus->pub.rev, bus->pub.id);
+	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, pmucaps=0x%x\n",
+		  cc->pub.rev, pub->pmurev, pub->pmucaps);
 
 	/* execute bus core specific setup */
 	if (chip->ops->setup)
-- 
1.7.10.4

