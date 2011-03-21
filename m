Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4018 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab1CUUQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 16:16:52 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: george@znau.edu.ua
cc: zajec5@gmail.com, mb@bu3sch.de, linville@tuxdriver.com,
	arend@broadcom.com, linux-wireless@vger.kernel.org
Subject: [RFC] drivers: brcmaxi: provide amba axi functionality in
 separate module
Date: Mon, 21 Mar 2011 21:16:26 +0100
Message-ID: <1300738586-7157-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1300738586-7157-1-git-send-email-arend@broadcom.com>
References: <1300738586-7157-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The open-source community is looking for a library which will detect
cores in a chip using axi backplane. This is an initial delivery of
what it could look like. Tested it with the brcm80211 driver.
---
 drivers/Kconfig          |    2 +
 drivers/Makefile         |    1 +
 drivers/brcmaxi/Makefile |   23 ++
 drivers/brcmaxi/axi.c    |  859 ++++++++++++++++++++++++++++++++++++++++++++++
 include/brcmaxi/axi.h    |  340 ++++++++++++++++++
 5 files changed, 1225 insertions(+), 0 deletions(-)
 create mode 100644 drivers/brcmaxi/Makefile
 create mode 100644 drivers/brcmaxi/axi.c
 create mode 100644 include/brcmaxi/axi.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 9bfb71f..2fee176 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -68,6 +68,8 @@ source "drivers/watchdog/Kconfig"
 
 source "drivers/ssb/Kconfig"
 
+source "drivers/brcmaxi/Kconfig"
+
 source "drivers/mfd/Kconfig"
 
 source "drivers/regulator/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index b423bb1..34bd6a6 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_HID)		+= hid/
 obj-$(CONFIG_PPC_PS3)		+= ps3/
 obj-$(CONFIG_OF)		+= of/
 obj-$(CONFIG_SSB)		+= ssb/
+obj-$(CONFIG_BRCMAXI)		+= brcmaxi/
 obj-$(CONFIG_VHOST_NET)		+= vhost/
 obj-$(CONFIG_VLYNQ)		+= vlynq/
 obj-$(CONFIG_STAGING)		+= staging/
diff --git a/drivers/brcmaxi/Makefile b/drivers/brcmaxi/Makefile
new file mode 100644
index 0000000..0b1502c
--- /dev/null
+++ b/drivers/brcmaxi/Makefile
@@ -0,0 +1,23 @@
+#
+# Makefile for Broadcom AMBA AXI utility module
+#
+# Copyright (c) 2011 Broadcom Corporation
+#
+# Permission to use, copy, modify, and/or distribute this software for any
+# purpose with or without fee is hereby granted, provided that the above
+# copyright notice and this permission notice appear in all copies.
+#
+# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+# OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+# CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+
+MODULEPFX := brcmaxi
+
+ccflags-$(CONFIG_DEBUG_KERNEL) += -DDEBUG
+
+obj-m	+= $(MODULEPFX).o
+$(MODULEPFX)-objs	= axi.o
diff --git a/drivers/brcmaxi/axi.c b/drivers/brcmaxi/axi.c
new file mode 100644
index 0000000..359e72d
--- /dev/null
+++ b/drivers/brcmaxi/axi.c
@@ -0,0 +1,859 @@
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
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <asm/byteorder.h>
+
+#include "axi.h"
+
+#define AXI_DESCRIPTION "Broadcom AXI utility library"
+
+MODULE_DESCRIPTION(AXI_DESCRIPTION);
+MODULE_AUTHOR("Broadcom Corporation");
+MODULE_LICENSE("Dual BSD/GPL");
+
+/* Enumeration ROM registers */
+#define	ER_EROMENTRY		0x000
+#define	ER_REMAPCONTROL		0xe00
+#define	ER_REMAPSELECT		0xe04
+#define	ER_MASTERSELECT		0xe10
+#define	ER_ITCR			0xf00
+#define	ER_ITIP			0xf04
+
+/* Enumeration ROM entries */
+#define	ER_TAG			0xe
+#define	ER_TAG1			0x6
+#define	ER_VALID		1
+#define	ER_CI			0
+#define	ER_MP			2
+#define	ER_ADD			4
+#define	ER_END			0xe
+#define	ER_BAD			0xffffffff
+
+/* EROM CompIdentA */
+#define	CIA_MFG_MASK		0xfff00000
+#define	CIA_MFG_SHIFT		20
+#define	CIA_CID_MASK		0x000fff00
+#define	CIA_CID_SHIFT		8
+#define	CIA_CCL_MASK		0x000000f0
+#define	CIA_CCL_SHIFT		4
+
+/* EROM CompIdentB */
+#define	CIB_REV_MASK		0xff000000
+#define	CIB_REV_SHIFT		24
+#define	CIB_NSW_MASK		0x00f80000
+#define	CIB_NSW_SHIFT		19
+#define	CIB_NMW_MASK		0x0007c000
+#define	CIB_NMW_SHIFT		14
+#define	CIB_NSP_MASK		0x00003e00
+#define	CIB_NSP_SHIFT		9
+#define	CIB_NMP_MASK		0x000001f0
+#define	CIB_NMP_SHIFT		4
+
+/* EROM MasterPortDesc */
+#define	MPD_MUI_MASK		0x0000ff00
+#define	MPD_MUI_SHIFT		8
+#define	MPD_MP_MASK		0x000000f0
+#define	MPD_MP_SHIFT		4
+
+/* EROM AddrDesc */
+#define	AD_ADDR_MASK		0xfffff000
+#define	AD_SP_MASK		0x00000f00
+#define	AD_SP_SHIFT		8
+#define	AD_ST_MASK		0x000000c0
+#define	AD_ST_SHIFT		6
+#define	AD_ST_SLAVE		0x00000000
+#define	AD_ST_BRIDGE		0x00000040
+#define	AD_ST_SWRAP		0x00000080
+#define	AD_ST_MWRAP		0x000000c0
+#define	AD_SZ_MASK		0x00000030
+#define	AD_SZ_SHIFT		4
+#define	AD_SZ_4K		0x00000000
+#define	AD_SZ_8K		0x00000010
+#define	AD_SZ_16K		0x00000020
+#define	AD_SZ_SZD		0x00000030
+#define	AD_AG32			0x00000008
+#define	AD_ADDR_ALIGN		0x00000fff
+#define	AD_SZ_BASE		0x00001000	/* 4KB */
+
+/* EROM SizeDesc */
+#define	SD_SZ_MASK		0xfffff000
+#define	SD_SG32			0x00000008
+#define	SD_SZ_ALIGN		0x00000fff
+
+/* resetctrl */
+#define	AIRC_RESET		1
+
+/* backplane address space accessed by BAR0 */
+#define	PCI_BAR0_WIN		0x80
+/* backplane address space accessed by second 4KB of BAR0 */
+#define	PCI_BAR0_WIN2		0xac
+
+/* definition for specifying padding fields */
+#define	_PADLINE(line)	pad ## line
+#define	_XSTR(line)	_PADLINE(line)
+#define	PAD		_XSTR(__LINE__)
+
+/**
+ * struct axi_local - internal instance data
+ *
+ * @pub: @struct axi_instance pointer to public instance data.
+ * @curcore: @struct axi_core pointer to active core.
+ * @bustype: @enum axi_bus referring to type of bus between axi and caller.
+ * @enum_rom_ptr: pointer to system discovery enumeration rom.
+ */
+struct axi_local {
+	struct axi_instance pub;
+	struct axi_core *curcore;
+	enum axi_bus bustype;
+	u32 *enum_rom_ptr;
+};
+
+/**
+ * struct aidmp - device management plugin "wrapper" registers.
+ */
+volatile struct aidmp {
+	u32 oobselina30;	/* 0x000 */
+	u32 oobselina74;	/* 0x004 */
+	u32 PAD[6];
+	u32 oobselinb30;	/* 0x020 */
+	u32 oobselinb74;	/* 0x024 */
+	u32 PAD[6];
+	u32 oobselinc30;	/* 0x040 */
+	u32 oobselinc74;	/* 0x044 */
+	u32 PAD[6];
+	u32 oobselind30;	/* 0x060 */
+	u32 oobselind74;	/* 0x064 */
+	u32 PAD[38];
+	u32 oobselouta30;	/* 0x100 */
+	u32 oobselouta74;	/* 0x104 */
+	u32 PAD[6];
+	u32 oobseloutb30;	/* 0x120 */
+	u32 oobseloutb74;	/* 0x124 */
+	u32 PAD[6];
+	u32 oobseloutc30;	/* 0x140 */
+	u32 oobseloutc74;	/* 0x144 */
+	u32 PAD[6];
+	u32 oobseloutd30;	/* 0x160 */
+	u32 oobseloutd74;	/* 0x164 */
+	u32 PAD[38];
+	u32 oobsynca;	/* 0x200 */
+	u32 oobseloutaen;	/* 0x204 */
+	u32 PAD[6];
+	u32 oobsyncb;	/* 0x220 */
+	u32 oobseloutben;	/* 0x224 */
+	u32 PAD[6];
+	u32 oobsyncc;	/* 0x240 */
+	u32 oobseloutcen;	/* 0x244 */
+	u32 PAD[6];
+	u32 oobsyncd;	/* 0x260 */
+	u32 oobseloutden;	/* 0x264 */
+	u32 PAD[38];
+	u32 oobaextwidth;	/* 0x300 */
+	u32 oobainwidth;	/* 0x304 */
+	u32 oobaoutwidth;	/* 0x308 */
+	u32 PAD[5];
+	u32 oobbextwidth;	/* 0x320 */
+	u32 oobbinwidth;	/* 0x324 */
+	u32 oobboutwidth;	/* 0x328 */
+	u32 PAD[5];
+	u32 oobcextwidth;	/* 0x340 */
+	u32 oobcinwidth;	/* 0x344 */
+	u32 oobcoutwidth;	/* 0x348 */
+	u32 PAD[5];
+	u32 oobdextwidth;	/* 0x360 */
+	u32 oobdinwidth;	/* 0x364 */
+	u32 oobdoutwidth;	/* 0x368 */
+	u32 PAD[37];
+	u32 ioctrlset;	/* 0x400 */
+	u32 ioctrlclear;	/* 0x404 */
+	u32 ioctrl;		/* 0x408 */
+	u32 PAD[61];
+	u32 iostatus;	/* 0x500 */
+	u32 PAD[127];
+	u32 ioctrlwidth;	/* 0x700 */
+	u32 iostatuswidth;	/* 0x704 */
+	u32 PAD[62];
+	u32 resetctrl;	/* 0x800 */
+	u32 resetstatus;	/* 0x804 */
+	u32 resetreadid;	/* 0x808 */
+	u32 resetwriteid;	/* 0x80c */
+	u32 PAD[60];
+	u32 errlogctrl;	/* 0x900 */
+	u32 errlogdone;	/* 0x904 */
+	u32 errlogstatus;	/* 0x908 */
+	u32 errlogaddrlo;	/* 0x90c */
+	u32 errlogaddrhi;	/* 0x910 */
+	u32 errlogid;	/* 0x914 */
+	u32 errloguser;	/* 0x918 */
+	u32 errlogflags;	/* 0x91c */
+	u32 PAD[56];
+	u32 intstatus;	/* 0xa00 */
+	u32 PAD[127];
+	u32 config;		/* 0xe00 */
+	u32 PAD[63];
+	u32 itcr;		/* 0xf00 */
+	u32 PAD[3];
+	u32 itipooba;	/* 0xf10 */
+	u32 itipoobb;	/* 0xf14 */
+	u32 itipoobc;	/* 0xf18 */
+	u32 itipoobd;	/* 0xf1c */
+	u32 PAD[4];
+	u32 itipoobaout;	/* 0xf30 */
+	u32 itipoobbout;	/* 0xf34 */
+	u32 itipoobcout;	/* 0xf38 */
+	u32 itipoobdout;	/* 0xf3c */
+	u32 PAD[4];
+	u32 itopooba;	/* 0xf50 */
+	u32 itopoobb;	/* 0xf54 */
+	u32 itopoobc;	/* 0xf58 */
+	u32 itopoobd;	/* 0xf5c */
+	u32 PAD[4];
+	u32 itopoobain;	/* 0xf70 */
+	u32 itopoobbin;	/* 0xf74 */
+	u32 itopoobcin;	/* 0xf78 */
+	u32 itopoobdin;	/* 0xf7c */
+	u32 PAD[4];
+	u32 itopreset;	/* 0xf90 */
+	u32 PAD[15];
+	u32 peripherialid4;	/* 0xfd0 */
+	u32 peripherialid5;	/* 0xfd4 */
+	u32 peripherialid6;	/* 0xfd8 */
+	u32 peripherialid7;	/* 0xfdc */
+	u32 peripherialid0;	/* 0xfe0 */
+	u32 peripherialid1;	/* 0xfe4 */
+	u32 peripherialid2;	/* 0xfe8 */
+	u32 peripherialid3;	/* 0xfec */
+	u32 componentid0;	/* 0xff0 */
+	u32 componentid1;	/* 0xff4 */
+	u32 componentid2;	/* 0xff8 */
+	u32 componentid3;	/* 0xffc */
+} aidmp_t;
+
+/* register access macros */
+#ifdef __LITTLE_ENDIAN
+#ifndef __mips__
+#define R_REG(r) \
+	(sizeof(*(r)) == sizeof(u8) ? \
+		readb((volatile u8*)(r)) : \
+	sizeof(*(r)) == sizeof(u16) ? \
+		readw((volatile u16*)(r)) : \
+	readl((volatile u32*)(r)))
+
+#else	/* __mips__ */
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __reg_val; \
+		__asm__ __volatile__("sync"); \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			__reg_val = readb((volatile u8*)(r)); \
+			break; \
+		case sizeof(u16): \
+			__reg_val = readw((volatile u16*)(r)); \
+			break; \
+		case sizeof(u32): \
+			__reg_val = readl((volatile u32*)(r)); \
+			break; \
+		} \
+		__asm__ __volatile__("sync"); \
+		__reg_val; \
+	})
+#endif	/* __mips__ */
+#define W_REG(r, v) \
+	do { \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			writeb((u8)(v), (volatile u8*)(r)); break; \
+		case sizeof(u16): \
+			writew((u16)(v), (volatile u16*)(r)); break; \
+		case sizeof(u32): \
+			writel((u32)(v), (volatile u32*)(r)); break; \
+		} \
+	} while (0)
+#else	/* __LITTLE_ENDIAN */
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __reg_val; \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			__reg_val = readb((volatile u8*)((r)^3)); \
+			break; \
+		case sizeof(u16): \
+			__reg_val = readw((volatile u16*)((r)^2)); \
+			break; \
+		case sizeof(u32): \
+			__reg_val = readl((volatile u32*)(r)); \
+			break; \
+		} \
+		__reg_val; \
+	})
+#define W_REG(r, v) \
+	do { \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8):	\
+			writeb((u8)(v), \
+			(volatile u8*)((r)^3)); break; \
+		case sizeof(u16):	\
+			writew((u16)(v), \
+			(volatile u16*)((r)^2)); break; \
+		case sizeof(u32):	\
+			writel((u32)(v), \
+			(volatile u32*)(r)); break; \
+		} \
+	} while (0)
+#endif	/* __LITTLE_ENDIAN */
+
+static void *find_core_handler(struct axi_instance *aih,
+			       u32 mfg_id, u32 core_id)
+{
+	const struct axi_core_handler *handler = aih->handler_list;
+	int i;
+
+	for (i = 0; i < aih->num_handler; i++, handler++) {
+		if ((handler->mfg_id != AXI_ANY_ID) &&
+		    (handler->mfg_id != mfg_id))
+			continue;
+		if ((handler->core_id != AXI_ANY_ID) &&
+		    (handler->mfg_id != mfg_id) &&
+		    (handler->core_id != core_id))
+			continue;
+
+		return handler->handler;
+	}
+
+	return NULL;
+}
+
+/**
+ * get_erom_ent - axi enumeration rom parsing
+ *
+ * @returns enumeration rom entry
+ */
+static u32
+get_erom_ent(u32 **eromptr, u32 mask, u32 match)
+{
+	u32 ent;
+	uint inv = 0, nom = 0;
+
+	while (true) {
+		ent = R_REG(*eromptr);
+		(*eromptr)++;
+
+		if (mask == 0)
+			break;
+
+		if ((ent & ER_VALID) == 0) {
+			inv++;
+			continue;
+		}
+
+		if (ent == (ER_END | ER_VALID))
+			break;
+
+		if ((ent & mask) == match)
+			break;
+
+		nom++;
+	}
+
+	if (inv + nom) {
+		pr_debug("%d invalid and %d non-matching entries\n",
+		       inv, nom);
+	}
+	pr_debug("%s: Returning ent 0x%08x\n", __func__, ent);
+	return ent;
+}
+
+static u32
+get_asd(u32 **eromptr, uint sp, uint ad, uint st,
+	u32 *addrl, u32 *addrh, u32 *sizel, u32 *sizeh)
+{
+	u32 asd, sz, szd;
+
+	asd = get_erom_ent(eromptr, ER_VALID, ER_VALID);
+	if (((asd & ER_TAG1) != ER_ADD) ||
+	    (((asd & AD_SP_MASK) >> AD_SP_SHIFT) != sp) ||
+	    ((asd & AD_ST_MASK) != st)) {
+		/* This is not what we want, "push" it back */
+		(*eromptr)--;
+		return 0;
+	}
+	*addrl = asd & AD_ADDR_MASK;
+	if (asd & AD_AG32)
+		*addrh = get_erom_ent(eromptr, 0, 0);
+	else
+		*addrh = 0;
+	*sizeh = 0;
+	sz = asd & AD_SZ_MASK;
+	if (sz == AD_SZ_SZD) {
+		szd = get_erom_ent(eromptr, 0, 0);
+		*sizel = szd & SD_SZ_MASK;
+		if (szd & SD_SG32)
+			*sizeh = get_erom_ent(eromptr, 0, 0);
+	} else
+		*sizel = AD_SZ_BASE << (sz >> AD_SZ_SHIFT);
+
+	pr_debug("  SP %d, ad %d: st = %d, 0x%08x_0x%08x @ 0x%08x_0x%08x\n",
+	       sp, ad, st, *sizeh, *sizel, *addrh, *addrl);
+
+	return asd;
+}
+
+struct axi_instance *axi_open(enum axi_bus bus_type, void *pbus,
+			      void *regs, u32 erombase, u32 priv_len)
+{
+	struct axi_local *inst;
+	int size = ALIGN(sizeof(*inst), 4) + priv_len;
+
+	inst = kzalloc(size, GFP_ATOMIC);
+
+	/* fill public fields */
+	inst->pub.pbus = pbus;
+	inst->pub.regs = regs;
+	inst->pub.priv = (char *)inst + ALIGN(sizeof(*inst), 4);
+
+	inst->bustype = bus_type;
+	switch (bus_type) {
+	case AXI_PCI_BUS:
+		/* Now point the window at the erom */
+		pci_write_config_dword(inst->pub.pbus, PCI_BAR0_WIN, erombase);
+		inst->enum_rom_ptr = regs;
+		break;
+
+	case AXI_AMBA_BUS:
+		inst->enum_rom_ptr = ioremap_nocache((unsigned long)erombase,
+						     AXI_CORE_SIZE);
+		break;
+
+	case AXI_SPI_BUS:
+	case AXI_SDIO_BUS:
+		inst->enum_rom_ptr = (u32 *)(unsigned long)erombase;
+		break;
+
+	default:
+		pr_err("Don't know how to do AXI "
+		       "enumertion on bus %d\n", bus_type);
+		WARN_ON(0);
+		return 0;
+	}
+
+
+	try_module_get(THIS_MODULE);
+
+	return &inst->pub;
+}
+EXPORT_SYMBOL(axi_open);
+
+void axi_close(struct axi_instance *aih)
+{
+	kfree(aih);
+	module_put(THIS_MODULE);
+}
+EXPORT_SYMBOL(axi_close);
+
+/* parse the enumeration rom to identify all cores */
+int axi_scan(struct axi_instance *aih)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct axi_core *core = NULL;
+	u32 *eromlim, *eromptr = ail->enum_rom_ptr;
+	int numcores = 0;
+
+	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
+
+	pr_debug("axi_scan: erom: ptr = 0x%p, limit = 0x%p\n",
+		 eromptr, eromlim);
+
+	while (eromptr < eromlim) {
+		bool (*handler)(struct axi_instance *ai, struct axi_core *core);
+		u32 cia, cib, cid, mfg, crev;
+		u32 n_master_wrap, n_slave_wrap, n_master_port, n_slave_port;
+		u32 mst_port_desc, addr_space_desc, addrl, addrh, sizel, sizeh;
+		u32 *base;
+		uint i, j;
+		bool br;
+
+		br = false;
+		core = NULL;
+
+		/* Grok a component */
+		cia = get_erom_ent(&eromptr, ER_TAG, ER_CI);
+		if (cia == (ER_END | ER_VALID)) {
+			pr_debug("Found END of erom after %d cores\n",
+				 numcores);
+			return numcores;
+		}
+		base = eromptr - 1;
+		cib = get_erom_ent(&eromptr, 0, 0);
+
+		if ((cib & ER_TAG) != ER_CI) {
+			pr_err("CIA not followed by CIB\n");
+			return 0;
+		}
+
+		cid = (cia & CIA_CID_MASK) >> CIA_CID_SHIFT;
+		mfg = (cia & CIA_MFG_MASK) >> CIA_MFG_SHIFT;
+		crev = (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
+		n_master_wrap = (cib & CIB_NMW_MASK) >> CIB_NMW_SHIFT;
+		n_slave_wrap = (cib & CIB_NSW_MASK) >> CIB_NSW_SHIFT;
+		n_master_port = (cib & CIB_NMP_MASK) >> CIB_NMP_SHIFT;
+		n_slave_port = (cib & CIB_NSP_MASK) >> CIB_NSP_SHIFT;
+
+		pr_debug("Found component 0x%04x/0x%04x rev %d at "
+		       "erom addr 0x%p, with nmw = %d, nsw = %d, nmp = %d & "
+		       "nsp = %d\n", mfg, cid, crev, base, n_master_wrap,
+		       n_slave_wrap, n_master_port, n_slave_port);
+
+		/* ??ignore processor core?? */
+		if (((mfg == MFGID_ARM) && (cid == DEF_AI_COMP)) ||
+		    (n_slave_port == 0))
+			continue;
+
+		/* alloc space to store core information */
+		core = kzalloc(sizeof(struct axi_core), GFP_ATOMIC);
+		if (!core)
+			return 0;
+
+		core->id = cid;
+		core->mfg = mfg;
+		core->rev = crev;
+
+		if ((n_master_wrap + n_slave_wrap) == 0) {
+			/* A component which is not a core */
+			if (cid == OOB_ROUTER_CORE_ID) {
+				addr_space_desc = get_asd(&eromptr, 0, 0,
+					AD_ST_SLAVE, &addrl, &addrh,
+					&sizel, &sizeh);
+				if (addr_space_desc != 0) {
+					core->phys_address = addrl;
+					handler = find_core_handler(aih,
+								     mfg, cid);
+					if (!handler ||
+					    handler(aih, core) == true) {
+						kfree(core);
+					}
+				} else {
+					kfree(core);
+				}
+			}
+			continue;
+		}
+
+		for (i = 0; i < n_master_port; i++) {
+			mst_port_desc =
+				get_erom_ent(&eromptr, ER_VALID, ER_VALID);
+			if ((mst_port_desc & ER_TAG) != ER_MP) {
+				pr_err("Not enough MP entries for "
+				       "component 0x%x\n", cid);
+				goto error;
+			}
+			pr_debug("  Master port %d, mp: %d id: %d\n", i,
+				 (mst_port_desc & MPD_MP_MASK) >> MPD_MP_SHIFT,
+				 (mst_port_desc & MPD_MUI_MASK) >> MPD_MUI_SHIFT
+			);
+		}
+
+		/* First Slave Address Descriptor should be port 0:
+		 * the main register space for the core
+		 */
+		addr_space_desc =
+		    get_asd(&eromptr, 0, 0, AD_ST_SLAVE, &addrl, &addrh,
+			    &sizel, &sizeh);
+		if (addr_space_desc == 0) {
+			/* Try again to see if it is a bridge */
+			addr_space_desc =
+			    get_asd(&eromptr, 0, 0, AD_ST_BRIDGE, &addrl,
+				    &addrh, &sizel, &sizeh);
+			if (addr_space_desc != 0)
+				br = true;
+			else if ((addrh != 0) || (sizeh != 0)
+				 || (sizel != AXI_CORE_SIZE)) {
+				pr_err("First Slave ASD for core "
+				       "0x%04x malformed (0x%08x)\n",
+				       cid, addr_space_desc);
+				goto error;
+			}
+		}
+
+		core->phys_address = addrl;
+		core->phys_space = sizel;
+
+		/* Get any more ASDs in port 0 */
+		j = 1;
+		do {
+			addr_space_desc =
+			    get_asd(&eromptr, 0, j, AD_ST_SLAVE, &addrl,
+				    &addrh, &sizel, &sizeh);
+			if ((addr_space_desc != 0) && (j == 1) &&
+			    (sizel == AXI_CORE_SIZE)) {
+				core->sec_phys_address = addrl;
+				core->sec_phys_space = sizel;
+			}
+			j++;
+		} while (addr_space_desc != 0);
+
+		/* Go through the ASDs for other slave ports */
+		for (i = 1; i < n_slave_port; i++) {
+			j = 0;
+			do {
+				addr_space_desc =
+				    get_asd(&eromptr, i, j++, AD_ST_SLAVE,
+					    &addrl, &addrh, &sizel, &sizeh);
+			} while (addr_space_desc != 0);
+			if (j == 0) {
+				pr_err("SP %d has no address "
+				       "descriptors\n", i);
+				goto error;
+			}
+		}
+
+		/* Now get master wrappers */
+		for (i = 0; i < n_master_wrap; i++) {
+			addr_space_desc =
+			    get_asd(&eromptr, i, 0, AD_ST_MWRAP, &addrl,
+				    &addrh, &sizel, &sizeh);
+			if (addr_space_desc == 0) {
+				pr_err("Missing descriptor for MW %d\n"
+				       , i);
+				goto error;
+			}
+			if ((sizeh != 0) || (sizel != AXI_CORE_SIZE)) {
+				pr_err("Master wrapper %d is not 4KB\n"
+				       , i);
+				goto error;
+			}
+			if (i == 0)
+				core->wrap_phys_address = addrl;
+		}
+
+		/* And finally slave wrappers */
+		for (i = 0; i < n_slave_wrap; i++) {
+			uint fwp = (n_slave_port == 1) ? 0 : 1;
+			addr_space_desc =
+			    get_asd(&eromptr, fwp + i, 0, AD_ST_SWRAP,
+				    &addrl, &addrh, &sizel, &sizeh);
+			if (addr_space_desc == 0) {
+				pr_err("Missing descriptor for SW %d\n", i);
+				goto error;
+			}
+			if ((sizeh != 0) || (sizel != AXI_CORE_SIZE)) {
+				pr_err("Slave wrapper %d is not 4KB\n", i);
+				goto error;
+			}
+			if ((n_master_wrap == 0) && (i == 0))
+				core->wrap_phys_address = addrl;
+		}
+
+		/* Don't record bridges */
+		if (br)
+			continue;
+
+		/* Done with core */
+		handler = find_core_handler(aih, mfg, cid);
+		if (handler && handler(aih, core) == false)
+			numcores++;
+		else
+			kfree(core);
+	}
+
+	pr_err("Reached end of erom without finding END");
+
+error:
+	kfree(core);
+	return 0;
+}
+EXPORT_SYMBOL(axi_scan);
+
+void *axi_set_active_core(struct axi_instance *aih, struct axi_core *ach)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+
+	u32 addr = ach->phys_address;
+	u32 wrap = ach->sec_phys_address;
+
+	switch (ail->bustype) {
+	case AXI_AMBA_BUS:
+		/* map new one */
+		if (!ach->regs)
+			ach->regs = ioremap_nocache(addr, AXI_CORE_SIZE);
+		if (!ach->wrap)
+			ach->wrap = ioremap_nocache(wrap, AXI_CORE_SIZE);
+		break;
+
+	case AXI_PCI_BUS:
+		/* point bar0 window */
+		pci_write_config_dword(aih->pbus, PCI_BAR0_WIN, addr);
+		ach->regs = ail->curcore->regs;
+		/* point bar0 2nd 4KB window */
+		pci_write_config_dword(aih->pbus, PCI_BAR0_WIN2, wrap);
+		ach->wrap = ail->curcore->wrap;
+		break;
+
+	case AXI_SPI_BUS:
+	case AXI_SDIO_BUS:
+		ach->regs = (void *)(unsigned long)addr;
+		ach->wrap = (void *)(unsigned long)wrap;
+		break;
+
+	default:
+		WARN_ON(0);
+		return NULL;
+		break;
+	}
+
+	ail->curcore = ach;
+
+	return ach->regs;
+}
+EXPORT_SYMBOL(axi_set_active_core);
+
+bool axi_iscoreup(struct axi_instance *aih)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct aidmp *ai;
+
+	ai = ail->curcore->wrap;
+
+	return (((R_REG(&ai->ioctrl) & (SICF_FGC | SICF_CLOCK_EN)) ==
+		 SICF_CLOCK_EN)
+		&& ((R_REG(&ai->resetctrl) & AIRC_RESET) == 0));
+}
+EXPORT_SYMBOL(axi_iscoreup);
+
+void axi_core_disable(struct axi_instance *aih, u32 bits)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	volatile u32 dummy;
+	struct aidmp *ai;
+
+	ai = ail->curcore->wrap;
+
+	/* if core is already in reset, just return */
+	if (R_REG(&ai->resetctrl) & AIRC_RESET)
+		return;
+
+	W_REG(&ai->ioctrl, bits);
+	dummy = R_REG(&ai->ioctrl);
+	udelay(10);
+
+	W_REG(&ai->resetctrl, AIRC_RESET);
+	udelay(1);
+}
+EXPORT_SYMBOL(axi_core_disable);
+
+/* reset and re-enable a core
+ * inputs:
+ * bits - core specific bits that are set during and after reset sequence
+ * resetbits - core specific bits that are set only during reset sequence
+ */
+void axi_core_reset(struct axi_instance *aih, u32 bits, u32 resetbits)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct aidmp *ai;
+	volatile u32 dummy;
+
+	ai = ail->curcore->wrap;
+
+	/*
+	 * Must do the disable sequence first to work for
+	 * arbitrary current core state.
+	 */
+	axi_core_disable(aih, (bits | resetbits));
+
+	/*
+	 * Now do the initialization sequence.
+	 */
+	W_REG(&ai->ioctrl, (bits | SICF_FGC | SICF_CLOCK_EN));
+	dummy = R_REG(&ai->ioctrl);
+	W_REG(&ai->resetctrl, 0);
+	udelay(1);
+
+	W_REG(&ai->ioctrl, (bits | SICF_CLOCK_EN));
+	dummy = R_REG(&ai->ioctrl);
+	udelay(1);
+}
+EXPORT_SYMBOL(axi_core_reset);
+
+uint axi_flag(struct axi_instance *aih)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct aidmp *ai;
+
+	/* TODO: what is with BCM47162 DMP */
+	ai = ail->curcore->wrap;
+
+	return R_REG(&ai->oobselouta30) & 0x1f;
+}
+EXPORT_SYMBOL(axi_flag);
+
+u32 axi_core_cflags(struct axi_instance *aih, u32 mask, u32 val)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct aidmp *ai;
+	u32 w;
+
+	/* TODO: what is with BCM47162 DMP */
+	ai = ail->curcore->wrap;
+
+	WARN_ON((val & ~mask) == 0);
+
+	if (mask || val) {
+		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
+		W_REG(&ai->ioctrl, w);
+	}
+
+	return R_REG(&ai->ioctrl);
+}
+EXPORT_SYMBOL(axi_core_cflags);
+
+u32 axi_core_sflags(struct axi_instance *aih, u32 mask, u32 val)
+{
+	struct axi_local *ail = (struct axi_local *)aih;
+	struct aidmp *ai;
+	u32 w;
+
+	/* TODO: what is with BCM47162 DMP */
+	ai = ail->curcore->wrap;
+
+	WARN_ON((val & ~mask) == 0);
+	WARN_ON((mask & ~SISF_CORE_BITS) == 0);
+
+	if (mask || val) {
+		w = ((R_REG(&ai->iostatus) & ~mask) | val);
+		W_REG(&ai->iostatus, w);
+	}
+
+	return R_REG(&ai->iostatus);
+}
+EXPORT_SYMBOL(axi_core_sflags);
+
+static int __init axi_init(void)
+{
+	pr_info(AXI_DESCRIPTION "\n");
+	return 0;
+}
+
+static void __exit axi_exit(void)
+{
+}
+
+module_init(axi_init);
+module_exit(axi_exit);
diff --git a/include/brcmaxi/axi.h b/include/brcmaxi/axi.h
new file mode 100644
index 0000000..0988939
--- /dev/null
+++ b/include/brcmaxi/axi.h
@@ -0,0 +1,340 @@
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
+
+#ifndef AXI_H_
+#define AXI_H_
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+/**
+ * DOC: Introduction
+ *
+ * brcmaxi provides detection of chip cores in chipsets using the AMBA AXI
+ * on-chip interconnect. It also provides basic functions to operate these
+ * cores and obtain/modify common core control and status flags.
+ */
+/**
+ * DOC: Chip System Discovery
+ *
+ * The discovery of cores in the chip is done parsing through an enumeration
+ * rom located on the chip. After using the @axi_open function by which the
+ * calling code provides the type of bus present between calling code and the
+ * enumeration rom, physical base address of the enumeration rom and virtual
+ * address of currently mapped memory, the calling code needs to provide a
+ * table of handlers using the macro @AXI_SET_HANDLERS. The argument should
+ * be declared using the macro @AXI_CORE_HANDLER_TABLE. The actual scan is
+ * initiated by calling @axi_scan.
+ *
+ * The user-provided handlers are called for each core that matches.
+ *
+ * NOTE: currently matching is only based on manufacturer and/or core ID.
+ */
+/**
+ * DOC: Core Utility Functions
+ *
+ * The core function provided are operating on an active core, which is selected
+ * by using @axi_set_active_core. Before calling this function the calling code
+ * must assure that interrupts from the currently active core are disabled.
+ *
+ * This active core approach is mainly in place for PCI bus where the registers
+ * for a core and wrapper are accessed by moving the BAR windows.
+ */
+/**
+ * Manufacturer Ids
+ */
+#define	MFGID_ARM			0x43b
+#define	MFGID_BRCM			0x4bf
+#define	MFGID_MIPS			0x4a7
+
+/**
+ * Component Classes
+ *
+ * This is used to have a more specific core identification.
+ */
+#define	CC_SIM				0
+#define	CC_EROM				1
+#define	CC_CORESIGHT			9
+#define	CC_VERIF			0xb
+#define	CC_OPTIMO			0xd
+#define	CC_GEN				0xe
+#define	CC_PRIMECELL			0xf
+
+/* Core Codes */
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
+#define AXI_CORE_SIZE		0x1000	/* each core has 4Kbytes registers */
+
+/* match for all values */
+#define AXI_ANY_ID		(~0)
+
+/**
+ * Common core control flags
+ *
+ * used in @axi_core_cflags.
+ */
+#define	SICF_BIST_EN		0x8000
+#define	SICF_PME_EN		0x4000
+#define	SICF_CORE_BITS		0x3ffc
+#define	SICF_FGC		0x0002
+#define	SICF_CLOCK_EN		0x0001
+
+/*
+ * Common core status flags
+ *
+ * used in @axi_core_sflags.
+ */
+#define	SISF_BIST_DONE		0x8000
+#define	SISF_BIST_ERROR		0x4000
+#define	SISF_GATED_CLK		0x2000
+#define	SISF_DMA64		0x1000
+#define	SISF_CORE_BITS		0x0fff
+
+/**
+ * enum axi_bus - bus by which AXI erom is accessed
+ */
+enum axi_bus {
+	AXI_AMBA_BUS,
+	AXI_PCI_BUS,
+	AXI_SDIO_BUS,
+	AXI_JTAG_BUS,
+	AXI_USB_BUS,
+	AXI_SPI_BUS,
+	AXI_RPC_BUS,
+};
+
+/**
+ * struct axi_core - core information
+ *
+ * @id: component identifier
+ * @ident_a: raw component identification data (part a)
+ * @ident_b: raw component identification data (part b)
+ * @phys_address: physical backplane address
+ * @sec_phys_address: physical backplane address of 2nd register set
+ * @wrap_phys_address: physical backplane address of controlling wrapper
+ *
+ */
+struct axi_core {
+	u32	mfg;
+	u32	id;
+	u32	rev;
+	u32	phys_address;
+	u32	phys_space;
+	u32	sec_phys_address;
+	u32	sec_phys_space;
+	u32	wrap_phys_address;
+
+	void	*regs;
+	void	*wrap;
+};
+
+/**
+ * forward declaration for handler in axi_core_handler structure.
+ */
+struct axi_instance;
+
+struct axi_core_handler {
+	bool (*handler)(struct axi_instance *ai, struct axi_core *core);
+	u32 mfg_id;
+	u32 core_id;
+	u32 class;
+};
+
+#define AXI_CORE_HANDLER_TABLE(_table) \
+	static const struct axi_core_handler _table[]
+
+#define AXI_CORE(mfg, core, _handler) \
+	.handler = (_handler), .core_id = (core), \
+	.mfg_id = (mfg), .class = AXI_ANY_ID
+
+#define AXI_CORE_CLASS(mfg, core, _class, _handler) \
+	.handler = (_handler), .core_id = (core) \
+	.mfg_id = (mfg), .class = (_class)
+
+#define AXI_SET_HANDLERS(aih, _table) \
+	axi_set_handlers((aih), ARRAY_SIZE(_table), _table)
+
+/**
+ * struct axi_instance - instance data
+ *
+ * @bustype: indicates how to get hold on enumeration rom
+ * @pbus: bus access object
+ * @handler_list: list of handler for detected cores
+ */
+struct axi_instance {
+	void *pbus;
+	void *regs;
+
+	const struct axi_core_handler *handler_list;
+	size_t num_handler;
+
+	void *priv;
+};
+
+static inline void axi_set_handlers(struct axi_instance *aih, size_t n_handler,
+				    const struct axi_core_handler *list)
+{
+	aih->num_handler = n_handler;
+	aih->handler_list = list;
+}
+
+/**
+ * axi_open - create instance.
+ * @bus_type: &enum axi_bus specifies type of bus to access chipset.
+ * @pbus: pointer to bus device structure.
+ * @erom_base: physical address where enumeration srom is located.
+ * @priv_size: additional memory appended to instance for caller to use.
+ *
+ * Creates the instance filling in the provided details.
+ */
+struct axi_instance *axi_open(enum axi_bus bus_type, void *pbus,
+			      void *regs, u32 erom_base, u32 priv_size);
+/**
+ * axi_close - release the instance.
+ * @aih: &struct axi_instance pointer to the instance.
+ */
+void axi_close(struct axi_instance *aih);
+/**
+ * axi_scan - scan the chipset for cores.
+ * @aih: &struct axi_instance pointer to the instance.
+ */
+int axi_scan(struct axi_instance *aih);
+/**
+ * axi_set_active_core - activate given core.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @ach: pointer to core to be activated.
+ *
+ * Activating a core will have the other operations
+ * be acted upon the core activated here.
+ */
+void *axi_set_active_core(struct axi_instance *aih, struct axi_core *ach);
+/**
+ * axi_iscoreup - indicates core is reset and enabled.
+ * @aih: &struct axi_instance pointer to the instance.
+ *
+ * Indicates whether the active core has reset and is enabled.
+ * Active core is set using @axi_set_active_core.
+ */
+bool axi_iscoreup(struct axi_instance *aih);
+/**
+ * axi_core_disable - disable the core.
+ * @aih: &struct axi_instance pointer to the instance.
+ *
+ * Disables the active core. Active core is set using @axi_set_active_core.
+ */
+void axi_core_disable(struct axi_instance *aih, u32 bits);
+/**
+ * axi_core_reset - reset and enable the core.
+ * @aih: &struct axi_instance pointer to the instance.
+ *
+ * Resets and enables the active core. Active core is set
+ * using @axi_set_active_core.
+ */
+void axi_core_reset(struct axi_instance *aih, u32 bits, u32 resetbits);
+/**
+ * axi_flag - get axi flag.
+ * @aih: &struct axi_instance pointer to the instance.
+ *
+ * Retrieves the axi flag for the active core. Active core is set
+ * using @axi_set_active_core.
+ */
+uint axi_flag(struct axi_instance *aih);
+/**
+ * axi_core_cflags - set core control flags.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @mask: mask indicating the bits to clear.
+ * @val: value with bits to set. bits must be within mask.
+ *
+ * Set I/O control flags for the active core. Active core is set
+ * using @axi_set_active_core. The function returns the resulting
+ * value of the control flags. When called with with mask and val
+ * parameters being 0 the current control flags are returned.
+ */
+u32 axi_core_cflags(struct axi_instance *aih, u32 mask, u32 val);
+/**
+ * axi_core_sflags - set core status flags.
+ * @aih: &struct axi_instance pointer to the instance.
+ * @mask: mask indicating the bits to clear.
+ * @val: value with bits to set. bits must be within mask.
+ *
+ * Set I/O status flags for the active core. Active core is set
+ * using @axi_set_active_core. The function returns the resulting
+ * value of the status flags. When called with with mask and val
+ * parameters being 0 the current status flags are returned.
+ */
+u32 axi_core_sflags(struct axi_instance *aih, u32 mask, u32 val);
+
+#endif /* AXI_H_ */
-- 
1.7.1


