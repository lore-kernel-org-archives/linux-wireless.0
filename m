Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2294 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 46/83] staging: brcm80211: moved sbdma.h into
 brcmsmac/bcmdma.h
Date: Wed, 1 Jun 2011 13:45:31 +0200
Message-ID: <1306928768-7501-46-git-send-email-rvossen@broadcom.com> (sfid-20110601_134707_588617_1C0228CE)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Removed fullmac dependencies on this file.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h    |   57 +-------------------
 drivers/staging/brcm80211/brcmsmac/bcmdma.h        |   29 ++++++++++
 drivers/staging/brcm80211/brcmsmac/dma.c           |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    2 +-
 .../brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c        |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c  |    3 +-
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |    3 +
 drivers/staging/brcm80211/include/sbdma.h          |   47 ----------------
 21 files changed, 48 insertions(+), 121 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/sbdma.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 67768bb..ebead09 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -131,7 +131,6 @@ typedef struct {
 
 #endif				/* DHD_DEBUG */
 #include <chipcommon.h>
-#include <sbdma.h>
 
 #include <sdio.h>
 #include <sbsdio.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
index 76266db..cc64b2f 100644
--- a/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
+++ b/drivers/staging/brcm80211/brcmfmac/sbsdpcmdev.h
@@ -24,55 +24,6 @@
 #define	PAD		_XSTR(__LINE__)
 #endif				/* PAD */
 
-/* dma registers per channel(xmt or rcv) */
-typedef volatile struct {
-	u32 control;		/* enable, et al */
-	u32 addr;		/* descriptor ring base address (4K aligned) */
-	u32 ptr;		/* last descriptor posted to chip */
-	u32 status;		/* current active descriptor, et al */
-} dma32regs_t;
-
-typedef volatile struct {
-	dma32regs_t xmt;	/* dma tx channel */
-	dma32regs_t rcv;	/* dma rx channel */
-} dma32regp_t;
-
-typedef volatile struct {
-	dma64regs_t xmt;	/* dma tx */
-	u32 PAD[2];
-	dma64regs_t rcv;	/* dma rx */
-	u32 PAD[2];
-} dma64p_t;
-
-
-typedef volatile struct {	/* diag access */
-	u32 fifoaddr;	/* diag address */
-	u32 fifodatalow;	/* low 32bits of data */
-	u32 fifodatahigh;	/* high 32bits of data */
-	u32 pad;		/* reserved */
-} dma64diag_t;
-
-/* dma64 sdiod corerev >= 1 */
-typedef volatile struct {
-	dma64p_t dma64regs[2];
-	dma64diag_t dmafifo;	/* DMA Diagnostic Regs, 0x280-0x28c */
-	u32 PAD[92];
-} sdiodma64_t;
-
-/* dma32 sdiod corerev == 0 */
-typedef volatile struct {
-	dma32regp_t dma32regs[2];	/* dma tx & rx, 0x200-0x23c */
-	dma32diag_t dmafifo;	/* DMA Diagnostic Regs, 0x240-0x24c */
-	u32 PAD[108];
-} sdiodma32_t;
-
-/* dma32 regs for pcmcia core */
-typedef volatile struct {
-	dma32regp_t dmaregs;	/* DMA Regs, 0x200-0x21c, rev8 */
-	dma32diag_t dmafifo;	/* DMA Diagnostic Regs, 0x220-0x22c */
-	u32 PAD[116];
-} pcmdma32_t;
-
 /* core registers */
 typedef volatile struct {
 	u32 corecontrol;	/* CoreControl, 0x000, rev8 */
@@ -133,13 +84,7 @@ typedef volatile struct {
 	u32 PAD[40];
 	u32 clockctlstatus;	/* ClockCtlStatus, 0x1e0, rev8 */
 	u32 PAD[7];
-
-	/* DMA engines */
-	volatile union {
-		pcmdma32_t pcm32;
-		sdiodma32_t sdiod32;
-		sdiodma64_t sdiod64;
-	} dma;
+	u32 PAD[128];		/* DMA engines */
 
 	/* SDIO/PCMCIA CIS region */
 	char cis[512];		/* 512 byte CIS, 0x400-0x5ff, rev6 */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
index 005410d..1a1ca03 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
@@ -17,11 +17,40 @@
 #ifndef	_bcmdma_h_
 #define	_bcmdma_h_
 
+#include "wlc_types.h"		/* forward structure declarations */
+
 #ifndef _dma_pub_
 #define _dma_pub_
 struct dma_pub;
 #endif				/* _dma_pub_ */
 
+/* DMA structure:
+ *  support two DMA engines: 32 bits address or 64 bit addressing
+ *  basic DMA register set is per channel(transmit or receive)
+ *  a pair of channels is defined for convenience
+ */
+
+/* 32 bits addressing */
+
+typedef volatile struct {	/* diag access */
+	u32 fifoaddr;	/* diag address */
+	u32 fifodatalow;	/* low 32bits of data */
+	u32 fifodatahigh;	/* high 32bits of data */
+	u32 pad;		/* reserved */
+} dma32diag_t;
+
+/* 64 bits addressing */
+
+/* dma registers per channel(xmt or rcv) */
+typedef volatile struct {
+	u32 control;		/* enable, et al */
+	u32 ptr;		/* last descriptor posted to chip */
+	u32 addrlow;		/* descriptor ring base address low 32-bits (8K aligned) */
+	u32 addrhigh;	/* descriptor ring base address bits 63:32 (8K aligned) */
+	u32 status0;		/* current descriptor, xmt state */
+	u32 status1;		/* active descriptor, xmt error */
+} dma64regs_t;
+
 /* map/unmap direction */
 #define	DMA_TX	1		/* TX direction for DMA */
 #define	DMA_RX	2		/* RX direction for DMA */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 7d666c6..d50395d 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -25,7 +25,7 @@
 #include <aiutils.h>
 
 #include "wlc_types.h"
-#include <sbdma.h>
+#include "bcmdma.h"
 #include <bcmdma.h>
 
 #if defined(__mips__)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index d54e264..8045c39 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -27,7 +27,7 @@
 #include <bcmnvram.h>
 #include <chipcommon.h>
 #include <bcmdevs.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include <wlc_types.h>
 #include <wlc_phy_int.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
index b5ec9ae..1011ca5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_lcn.c
@@ -25,7 +25,7 @@
 #include <bcmnvram.h>
 
 #include <bcmdevs.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "wlc_phy_radio.h"
 #include "wlc_phy_int.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index bc362f3..da2afbb 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -25,7 +25,7 @@
 #include <wlc_pmu.h>
 
 #include <bcmdevs.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include <wlc_types.h>
 #include <wlc_phy_radio.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
index e9d8661..679002e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_lcn.c
@@ -15,7 +15,7 @@
  */
 
 #include <linux/types.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 #include <wlc_phy_int.h>
 #include <wlc_phytbl_lcn.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
index e4a15c4..ad41a19 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phytbl_n.c
@@ -16,7 +16,7 @@
 
 #include <linux/kernel.h>
 
-#include <sbdma.h>
+#include "bcmdma.h"
 #include <wlc_phy_int.h>
 #include <wlc_phytbl_n.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index ee026d3..0f4a1cc 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -30,7 +30,7 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <nicpci.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "phy/wlc_phy_int.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 8a4875d..218210a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -19,7 +19,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "d11.h"
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 53ca0ff..0c325c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -19,7 +19,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 #include <bcmdma.h>
 #include <d11.h>
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index d26a520..fba9eaf 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -25,7 +25,7 @@
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmdevs.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "d11.h"
 #include "wlc_rate.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 0f876a7..6bc547a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -31,7 +31,6 @@
 #include <bcmnvram.h>
 #include <chipcommon.h>
 #include <nicpci.h>
-#include <sbdma.h>
 #include <bcmdma.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 0b980ac..cd37971 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -23,7 +23,7 @@
 #include <bcmutils.h>
 #include <bcmnvram.h>
 #include <aiutils.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 18a5463..3e34b31 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -26,7 +26,7 @@
 #include <bcmnvram.h>
 #include <aiutils.h>
 #include <bcmsrom.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 #include <bcmdma.h>
 
 #include "wlc_pmu.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
index b97fa3e..6689691 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_phy_shim.c
@@ -29,8 +29,7 @@
 #include <bcmwifi.h>
 #include <aiutils.h>
 #include <chipcommon.h>
-#include <sbdma.h>
-#include <bcmdma.h>
+#include "bcmdma.h"
 #include <wlc_pmu.h>
 
 #include "wlc_types.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 53dcf24..d6eae1f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -19,7 +19,7 @@
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <aiutils.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index a08db2e..8fb90d4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -22,7 +22,7 @@
 #include <aiutils.h>
 #include <bcmwifi.h>
 #include <bcmnvram.h>
-#include <sbdma.h>
+#include "bcmdma.h"
 
 #include "wlc_types.h"
 #include "d11.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 76a1348..5cca063 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -34,6 +34,7 @@
 #define MAX_DMA_SEGS 4
 
 /* forward declarations */
+struct sk_buff;
 struct wl_info;
 struct wlc_info;
 struct wlc_hw_info;
@@ -45,5 +46,7 @@ struct bmac_pmq;
 struct d11init;
 struct dma_pub;
 struct wlc_bsscfg;
+struct bcmstrbuf;
+struct si_pub;
 
 #endif				/* _wlc_types_h_ */
diff --git a/drivers/staging/brcm80211/include/sbdma.h b/drivers/staging/brcm80211/include/sbdma.h
deleted file mode 100644
index 9814a0c..0000000
--- a/drivers/staging/brcm80211/include/sbdma.h
+++ /dev/null
@@ -1,47 +0,0 @@
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
-#ifndef	_sbdma_h_
-#define	_sbdma_h_
-
-/* DMA structure:
- *  support two DMA engines: 32 bits address or 64 bit addressing
- *  basic DMA register set is per channel(transmit or receive)
- *  a pair of channels is defined for convenience
- */
-
-/* 32 bits addressing */
-
-typedef volatile struct {	/* diag access */
-	u32 fifoaddr;	/* diag address */
-	u32 fifodatalow;	/* low 32bits of data */
-	u32 fifodatahigh;	/* high 32bits of data */
-	u32 pad;		/* reserved */
-} dma32diag_t;
-
-/* 64 bits addressing */
-
-/* dma registers per channel(xmt or rcv) */
-typedef volatile struct {
-	u32 control;		/* enable, et al */
-	u32 ptr;		/* last descriptor posted to chip */
-	u32 addrlow;		/* descriptor ring base address low 32-bits (8K aligned) */
-	u32 addrhigh;	/* descriptor ring base address bits 63:32 (8K aligned) */
-	u32 status0;		/* current descriptor, xmt state */
-	u32 status1;		/* active descriptor, xmt error */
-} dma64regs_t;
-
-#endif				/* _sbdma_h_ */
-- 
1.7.4.1


