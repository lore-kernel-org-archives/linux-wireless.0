Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3699 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 02/16] brcm80211: fmac: move chip recognition function
 to sdio_chip.c
Date: Fri, 4 Nov 2011 22:23:28 +0100
Message-ID: <1320441822-4615-3-git-send-email-arend@broadcom.com> (sfid-20111104_222423_416865_6D0BBE27)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Currently backplane handle code is scatterd around dhd_sdio.c which
is not good for maintenance and adding new backplane interconnect
type support. This patch and the follow up patches are going to
abstract all chip backplane control code specific for sdio bus
into this new sdio_chip.c

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h  |    7 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  137 +-------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |  119 +++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   90 +++++++++++++
 5 files changed, 213 insertions(+), 143 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index b44e309..d58aa1b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -26,7 +26,8 @@ DHDOFILES = \
 	dhd_sdio.o	\
 	dhd_linux.o \
 	bcmsdh.o \
-	bcmsdh_sdmmc.o
+	bcmsdh_sdmmc.o \
+	sdio_chip.o
 
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += $(DHDOFILES)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h b/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
index d7d3afd..cecb5e5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmchip.h
@@ -18,13 +18,6 @@
 #define _bcmchip_h_
 
 /* bcm4329 */
-/* SDIO device core, ID 0x829 */
-#define BCM4329_CORE_BUS_BASE		0x18011000
-/* internal memory core, ID 0x80e */
-#define BCM4329_CORE_SOCRAM_BASE	0x18003000
-/* ARM Cortex M3 core, ID 0x82a */
-#define BCM4329_CORE_ARM_BASE		0x18002000
-#define BCM4329_RAMSIZE			0x48000
 /* firmware name */
 #define BCM4329_FW_NAME			"brcm/bcm4329-fullmac-4.bin"
 #define BCM4329_NV_NAME			"brcm/bcm4329-fullmac-4.txt"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 2c409ca..e12e99b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -35,6 +35,7 @@
 #include <brcm_hw_ids.h>
 #include <soc.h>
 #include "sdio_host.h"
+#include "sdio_chip.h"
 
 #define DCMD_RESP_TIMEOUT  2000	/* In milli second */
 
@@ -367,18 +368,6 @@ struct rte_console {
 /* sbidlow */
 #define	SBIDL_INIT		0x80	/* initiator */
 
-/* sbidhigh */
-#define	SBIDH_RC_MASK		0x000f	/* revision code */
-#define	SBIDH_RCE_MASK		0x7000	/* revision code extension field */
-#define	SBIDH_RCE_SHIFT		8
-#define	SBCOREREV(sbidh) \
-	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | \
-	  ((sbidh) & SBIDH_RC_MASK))
-#define	SBIDH_CC_MASK		0x8ff0	/* core code */
-#define	SBIDH_CC_SHIFT		4
-#define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
-#define	SBIDH_VC_SHIFT		16
-
 /*
  * Conversion of 802.1D priority to precedence level
  */
@@ -388,17 +377,6 @@ static uint prio2prec(u32 prio)
 	       (prio^2) : prio;
 }
 
-/*
- * Core reg address translation.
- * Both macro's returns a 32 bits byte address on the backplane bus.
- */
-#define CORE_CC_REG(base, field) \
-		(base + offsetof(struct chipcregs, field))
-#define CORE_BUS_REG(base, field) \
-		(base + offsetof(struct sdpcmd_regs, field))
-#define CORE_SB(base, field) \
-		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
-
 /* core registers */
 struct sdpcmd_regs {
 	u32 corecontrol;		/* 0x00, rev8 */
@@ -524,21 +502,6 @@ struct sdpcm_shared_le {
 
 
 /* misc chip info needed by some of the routines */
-struct chip_info {
-	u32 chip;
-	u32 chiprev;
-	u32 cccorebase;
-	u32 ccrev;
-	u32 cccaps;
-	u32 buscorebase; /* 32 bits backplane bus address */
-	u32 buscorerev;
-	u32 buscoretype;
-	u32 ramcorebase;
-	u32 armcorebase;
-	u32 pmurev;
-	u32 ramsize;
-};
-
 /* Private data for SDIO bus interaction */
 struct brcmf_bus {
 	struct brcmf_pub *drvr;
@@ -663,46 +626,6 @@ struct brcmf_bus {
 	u32 fw_ptr;
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
-};
-
 /* clkstate */
 #define CLK_NONE	0
 #define CLK_SDONLY	1
@@ -4083,62 +4006,6 @@ static void brcmf_sdbrcm_sdiod_drive_strength_init(struct brcmf_bus *bus,
 }
 
 static int
-brcmf_sdbrcm_chip_recognition(struct brcmf_sdio_dev *sdiodev,
-			      struct chip_info *ci, u32 regs)
-{
-	u32 regdata;
-
-	/*
-	 * Get CC core rev
-	 * Chipid is assume to be at offset 0 from regs arg
-	 * For different chiptypes or old sdio hosts w/o chipcommon,
-	 * other ways of recognition should be added here.
-	 */
-	ci->cccorebase = regs;
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_CC_REG(ci->cccorebase, chipid), 4);
-	ci->chip = regdata & CID_ID_MASK;
-	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
-
-	brcmf_dbg(INFO, "chipid=0x%x chiprev=%d\n", ci->chip, ci->chiprev);
-
-	/* Address of cores for new chips should be added here */
-	switch (ci->chip) {
-	case BCM4329_CHIP_ID:
-		ci->buscorebase = BCM4329_CORE_BUS_BASE;
-		ci->ramcorebase = BCM4329_CORE_SOCRAM_BASE;
-		ci->armcorebase	= BCM4329_CORE_ARM_BASE;
-		ci->ramsize = BCM4329_RAMSIZE;
-		break;
-	default:
-		brcmf_dbg(ERROR, "chipid 0x%x is not supported\n", ci->chip);
-		return -ENODEV;
-	}
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(ci->cccorebase, sbidhigh), 4);
-	ci->ccrev = SBCOREREV(regdata);
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
-	ci->pmurev = regdata & PCAP_REV_MASK;
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(ci->buscorebase, sbidhigh), 4);
-	ci->buscorerev = SBCOREREV(regdata);
-	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
-
-	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
-		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
-
-	/* get chipcommon capabilites */
-	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
-		CORE_CC_REG(ci->cccorebase, capabilities), 4);
-
-	return 0;
-}
-
-static int
 brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 {
 	struct chip_info *ci;
@@ -4196,7 +4063,7 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			       SBSDIO_FUNC1_SDIOPULLUP, 0, NULL);
 
-	err = brcmf_sdbrcm_chip_recognition(bus->sdiodev, ci, regs);
+	err = brcmf_sdio_chip_attach(bus->sdiodev, ci, regs);
 	if (err)
 		goto fail;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
new file mode 100644
index 0000000..7f01a9b
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -0,0 +1,119 @@
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
+/* ***** SDIO interface chip backplane handle functions ***** */
+
+#include <linux/types.h>
+#include <linux/netdevice.h>
+#include <linux/mmc/card.h>
+#include <chipcommon.h>
+#include <brcm_hw_ids.h>
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
+#include "dhd.h"
+#include "dhd_dbg.h"
+#include "sdio_host.h"
+#include "sdio_chip.h"
+
+/* chip core base & ramsize */
+/* bcm4329 */
+/* SDIO device core, ID 0x829 */
+#define BCM4329_CORE_BUS_BASE		0x18011000
+/* internal memory core, ID 0x80e */
+#define BCM4329_CORE_SOCRAM_BASE	0x18003000
+/* ARM Cortex M3 core, ID 0x82a */
+#define BCM4329_CORE_ARM_BASE		0x18002000
+#define BCM4329_RAMSIZE			0x48000
+
+
+/* SB regs */
+/* sbidhigh */
+#define	SBIDH_RC_MASK		0x000f	/* revision code */
+#define	SBIDH_RCE_MASK		0x7000	/* revision code extension field */
+#define	SBIDH_RCE_SHIFT		8
+#define	SBCOREREV(sbidh) \
+	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | \
+	  ((sbidh) & SBIDH_RC_MASK))
+#define	SBIDH_CC_MASK		0x8ff0	/* core code */
+#define	SBIDH_CC_SHIFT		4
+#define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
+#define	SBIDH_VC_SHIFT		16
+
+static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
+				       struct chip_info *ci, u32 regs)
+{
+	u32 regdata;
+
+	/*
+	 * Get CC core rev
+	 * Chipid is assume to be at offset 0 from regs arg
+	 * For different chiptypes or old sdio hosts w/o chipcommon,
+	 * other ways of recognition should be added here.
+	 */
+	ci->cccorebase = regs;
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_CC_REG(ci->cccorebase, chipid), 4);
+	ci->chip = regdata & CID_ID_MASK;
+	ci->chiprev = (regdata & CID_REV_MASK) >> CID_REV_SHIFT;
+
+	brcmf_dbg(INFO, "chipid=0x%x chiprev=%d\n", ci->chip, ci->chiprev);
+
+	/* Address of cores for new chips should be added here */
+	switch (ci->chip) {
+	case BCM4329_CHIP_ID:
+		ci->buscorebase = BCM4329_CORE_BUS_BASE;
+		ci->ramcorebase = BCM4329_CORE_SOCRAM_BASE;
+		ci->armcorebase	= BCM4329_CORE_ARM_BASE;
+		ci->ramsize = BCM4329_RAMSIZE;
+		break;
+	default:
+		brcmf_dbg(ERROR, "chipid 0x%x is not supported\n", ci->chip);
+		return -ENODEV;
+	}
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_SB(ci->cccorebase, sbidhigh), 4);
+	ci->ccrev = SBCOREREV(regdata);
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_CC_REG(ci->cccorebase, pmucapabilities), 4);
+	ci->pmurev = regdata & PCAP_REV_MASK;
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(ci->buscorebase, sbidhigh), 4);
+	ci->buscorerev = SBCOREREV(regdata);
+	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
+
+	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
+		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
+
+	/* get chipcommon capabilites */
+	ci->cccaps = brcmf_sdcard_reg_read(sdiodev,
+		CORE_CC_REG(ci->cccorebase, capabilities), 4);
+
+	return 0;
+}
+
+int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
+			   struct chip_info *ci, u32 regs)
+{
+	int ret = 0;
+
+	ret = brcmf_sdio_chip_recognition(sdiodev, ci, regs);
+	if (ret != 0)
+		return ret;
+
+	return ret;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
new file mode 100644
index 0000000..9595186
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -0,0 +1,90 @@
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
+#ifndef _BRCMFMAC_SDIO_CHIP_H_
+#define _BRCMFMAC_SDIO_CHIP_H_
+
+/*
+ * Core reg address translation.
+ * Both macro's returns a 32 bits byte address on the backplane bus.
+ */
+#define CORE_CC_REG(base, field) \
+		(base + offsetof(struct chipcregs, field))
+#define CORE_BUS_REG(base, field) \
+		(base + offsetof(struct sdpcmd_regs, field))
+#define CORE_SB(base, field) \
+		(base + SBCONFIGOFF + offsetof(struct sbconfig, field))
+
+struct chip_info {
+	u32 chip;
+	u32 chiprev;
+	u32 cccorebase;
+	u32 ccrev;
+	u32 cccaps;
+	u32 buscorebase; /* 32 bits backplane bus address */
+	u32 buscorerev;
+	u32 buscoretype;
+	u32 ramcorebase;
+	u32 armcorebase;
+	u32 pmurev;
+	u32 ramsize;
+};
+
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
+extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
+				  struct chip_info *ci, u32 regs);
+
+
+#endif		/* _BRCMFMAC_SDIO_CHIP_H_ */
-- 
1.7.4.1


