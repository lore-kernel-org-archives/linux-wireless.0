Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4854 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161415Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 36/83] staging: brcm80211: cleaned bcmdefs.h
Date: Wed, 1 Jun 2011 13:45:21 +0200
Message-ID: <1306928768-7501-36-git-send-email-rvossen@broadcom.com> (sfid-20110601_134652_398961_BCB605C6)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |    1 +
 drivers/staging/brcm80211/brcmsmac/dma.c           |   36 +++++++
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |    1 +
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    1 +
 drivers/staging/brcm80211/brcmsmac/wl_ucode.h      |    2 +
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |   20 ++++
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |   18 ++++
 drivers/staging/brcm80211/include/bcmdefs.h        |  108 +-------------------
 9 files changed, 82 insertions(+), 106 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index 311bc0c..952bc40 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <stdarg.h>
+#include "wlc_types.h"
 #include <bcmutils.h>
 #include <bcmsoc.h>
 #include <sbchipc.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 77baef2..611a7e2 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -24,6 +24,7 @@
 #include <bcmutils.h>
 #include <aiutils.h>
 
+#include "wlc_types.h"
 #include <sbdma.h>
 #include <bcmdma.h>
 
@@ -148,6 +149,19 @@
 #define D64_RX_FRM_STS_DSCRCNT	0x0f000000  /* no. of descriptors used - 1 */
 #define D64_RX_FRM_STS_DATATYPE	0xf0000000	/* core-dependent data type */
 
+#define	DMADDRWIDTH_30  30	/* 30-bit addressing capability */
+#define	DMADDRWIDTH_32  32	/* 32-bit addressing capability */
+#define	DMADDRWIDTH_63  63	/* 64-bit addressing capability */
+#define	DMADDRWIDTH_64  64	/* 64-bit addressing capability */
+
+/* packet headroom necessary to accommodate the largest header in the system, (i.e TXOFF).
+ * By doing, we avoid the need  to allocate an extra buffer for the header when bridging to WL.
+ * There is a compile time check in wlc.c which ensure that this value is at least as big
+ * as TXOFF. This value is used in dma_rxfill (dma.c).
+ */
+
+#define BCMEXTRAHDROOM 172
+
 /* debug/trace */
 #ifdef BCMDBG
 #define	DMA_ERROR(args) \
@@ -171,6 +185,15 @@
 
 #define	DMA_NONE(args)
 
+typedef unsigned long dmaaddr_t;
+#define PHYSADDRHI(_pa) (0)
+#define PHYSADDRHISET(_pa, _val)
+#define PHYSADDRLO(_pa) ((_pa))
+#define PHYSADDRLOSET(_pa, _val) \
+	do { \
+		(_pa) = (_val);			\
+	} while (0)
+
 #define d64txregs	dregs.d64_u.txregs_64
 #define d64rxregs	dregs.d64_u.rxregs_64
 #define txd64		dregs.d64_u.txd_64
@@ -186,6 +209,19 @@ static uint dma_msg_level;
 #define R_SM(r)		(*(r))
 #define W_SM(r, v)	(*(r) = (v))
 
+/* One physical DMA segment */
+typedef struct {
+	dmaaddr_t addr;
+	u32 length;
+} dma_seg_t;
+
+typedef struct {
+	void *oshdmah;		/* Opaque handle for OSL to store its information */
+	uint origsize;		/* Size of the virtual packet */
+	uint nsegs;
+	dma_seg_t segs[MAX_DMA_SEGS];
+} dma_seg_map_t;
+
 /*
  * DMA Descriptor
  * Descriptors are only read by the hardware, never written back.
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 22ba415..1e9865f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -29,6 +29,7 @@
 #include <bcmdevs.h>
 #include <sbdma.h>
 
+#include <wlc_types.h>
 #include <wlc_phy_int.h>
 #include <wlc_phyreg_n.h>
 #include <wlc_phy_radio.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 620eb86..78d8cbe 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -27,6 +27,7 @@
 #include <bcmdevs.h>
 #include <sbdma.h>
 
+#include <wlc_types.h>
 #include <wlc_phy_radio.h>
 #include <wlc_phy_int.h>
 #include <wlc_phyreg_n.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_ucode.h b/drivers/staging/brcm80211/brcmsmac/wl_ucode.h
index 6933fda..28838d8 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_ucode.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_ucode.h
@@ -14,6 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include "wlc_types.h"		/* forward structure declarations */
+
 #define MIN_FW_SIZE 40000	/* minimum firmware file size in bytes */
 #define MAX_FW_SIZE 150000
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index d066339..4e62b11 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -47,6 +47,24 @@
 
 #define AC_COUNT		4
 
+/* Macros for doing definition and get/set of bitfields
+ * Usage example, e.g. a three-bit field (bits 4-6):
+ *    #define <NAME>_M	BITFIELD_MASK(3)
+ *    #define <NAME>_S	4
+ * ...
+ *    regval = R_REG(osh, &regs->regfoo);
+ *    field = GFIELD(regval, <NAME>);
+ *    regval = SFIELD(regval, <NAME>, 1);
+ *    W_REG(osh, &regs->regfoo, regval);
+ */
+#define BITFIELD_MASK(width) \
+		(((unsigned)1 << (width)) - 1)
+#define GFIELD(val, field) \
+		(((val) >> field ## _S) & field ## _M)
+#define SFIELD(val, field, bits) \
+		(((val) & (~(field ## _M << field ## _S))) | \
+		 ((unsigned)(bits) << field ## _S))
+
 /* For managing scan result lists */
 struct wlc_bss_list {
 	uint count;
@@ -158,6 +176,8 @@ extern const u8 prio2fifo[];
 #define EDCF_LONG_M             BITFIELD_MASK(4)
 #define EDCF_LFB_M              BITFIELD_MASK(4)
 
+#define	NFIFO			6	/* # tx/rx fifopairs */
+
 #define WLC_WME_RETRY_SHORT_GET(wlc, ac)    GFIELD(wlc->wme_retries[ac], EDCF_SHORT)
 #define WLC_WME_RETRY_SFB_GET(wlc, ac)      GFIELD(wlc->wme_retries[ac], EDCF_SFB)
 #define WLC_WME_RETRY_LONG_GET(wlc, ac)     GFIELD(wlc->wme_retries[ac], EDCF_LONG)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index bd0885e..0ab16c4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -17,6 +17,7 @@
 #ifndef _wlc_pub_h_
 #define _wlc_pub_h_
 
+#include "wlc_types.h"		/* forward structure declarations */
 #include "bcmwifi.h"		/* for chanspec_t */
 
 #define	WLC_NUMRATES	16	/* max # of rates in a rateset */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index b8cede1..76a1348 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -17,7 +17,24 @@
 #ifndef _wlc_types_h_
 #define _wlc_types_h_
 
+/* Bus types */
+#define	SI_BUS			0	/* SOC Interconnect */
+#define	PCI_BUS			1	/* PCI target */
+#define SDIO_BUS		3	/* SDIO target */
+#define JTAG_BUS		4	/* JTAG */
+#define USB_BUS			5	/* USB (does not support R/W REG) */
+#define SPI_BUS			6	/* gSPI target */
+#define RPC_BUS			7	/* RPC target */
+
+#define WL_CHAN_FREQ_RANGE_2G      0
+#define WL_CHAN_FREQ_RANGE_5GL     1
+#define WL_CHAN_FREQ_RANGE_5GM     2
+#define WL_CHAN_FREQ_RANGE_5GH     3
+
+#define MAX_DMA_SEGS 4
+
 /* forward declarations */
+struct wl_info;
 struct wlc_info;
 struct wlc_hw_info;
 struct wlc_if;
@@ -27,5 +44,6 @@ struct antsel_info;
 struct bmac_pmq;
 struct d11init;
 struct dma_pub;
+struct wlc_bsscfg;
 
 #endif				/* _wlc_types_h_ */
diff --git a/drivers/staging/brcm80211/include/bcmdefs.h b/drivers/staging/brcm80211/include/bcmdefs.h
index 7613845..cf9dc0e 100644
--- a/drivers/staging/brcm80211/include/bcmdefs.h
+++ b/drivers/staging/brcm80211/include/bcmdefs.h
@@ -25,7 +25,6 @@
 #define USB_BUS			5
 #define SPI_BUS			6
 
-
 #ifndef OFF
 #define	OFF	0
 #endif
@@ -36,96 +35,6 @@
 
 #define	AUTO	(-1)		/* Auto = -1 */
 
-/* Bus types */
-#define	SI_BUS			0	/* SOC Interconnect */
-#define	PCI_BUS			1	/* PCI target */
-#define SDIO_BUS		3	/* SDIO target */
-#define JTAG_BUS		4	/* JTAG */
-#define USB_BUS			5	/* USB (does not support R/W REG) */
-#define SPI_BUS			6	/* gSPI target */
-#define RPC_BUS			7	/* RPC target */
-
-
-/* Defines for DMA Address Width - Shared between OSL and HNDDMA */
-#define DMADDR_MASK_32 0x0	/* Address mask for 32-bits */
-#define DMADDR_MASK_30 0xc0000000	/* Address mask for 30-bits */
-#define DMADDR_MASK_0  0xffffffff	/* Address mask for 0-bits (hi-part) */
-
-#define	DMADDRWIDTH_30  30	/* 30-bit addressing capability */
-#define	DMADDRWIDTH_32  32	/* 32-bit addressing capability */
-#define	DMADDRWIDTH_63  63	/* 64-bit addressing capability */
-#define	DMADDRWIDTH_64  64	/* 64-bit addressing capability */
-
-#ifdef BCMDMA64OSL
-typedef struct {
-	u32 loaddr;
-	u32 hiaddr;
-} dma64addr_t;
-
-typedef dma64addr_t dmaaddr_t;
-#define PHYSADDRHI(_pa) ((_pa).hiaddr)
-#define PHYSADDRHISET(_pa, _val) \
-	do { \
-		(_pa).hiaddr = (_val);		\
-	} while (0)
-#define PHYSADDRLO(_pa) ((_pa).loaddr)
-#define PHYSADDRLOSET(_pa, _val) \
-	do { \
-		(_pa).loaddr = (_val);		\
-	} while (0)
-
-#else
-typedef unsigned long dmaaddr_t;
-#define PHYSADDRHI(_pa) (0)
-#define PHYSADDRHISET(_pa, _val)
-#define PHYSADDRLO(_pa) ((_pa))
-#define PHYSADDRLOSET(_pa, _val) \
-	do { \
-		(_pa) = (_val);			\
-	} while (0)
-#endif				/* BCMDMA64OSL */
-
-/* One physical DMA segment */
-typedef struct {
-	dmaaddr_t addr;
-	u32 length;
-} dma_seg_t;
-
-#define MAX_DMA_SEGS 4
-
-typedef struct {
-	void *oshdmah;		/* Opaque handle for OSL to store its information */
-	uint origsize;		/* Size of the virtual packet */
-	uint nsegs;
-	dma_seg_t segs[MAX_DMA_SEGS];
-} dma_seg_map_t;
-
-/* packet headroom necessary to accommodate the largest header in the system, (i.e TXOFF).
- * By doing, we avoid the need  to allocate an extra buffer for the header when bridging to WL.
- * There is a compile time check in wlc.c which ensure that this value is at least as big
- * as TXOFF. This value is used in dma_rxfill (dma.c).
- */
-
-#define BCMEXTRAHDROOM 172
-
-/* Macros for doing definition and get/set of bitfields
- * Usage example, e.g. a three-bit field (bits 4-6):
- *    #define <NAME>_M	BITFIELD_MASK(3)
- *    #define <NAME>_S	4
- * ...
- *    regval = R_REG(osh, &regs->regfoo);
- *    field = GFIELD(regval, <NAME>);
- *    regval = SFIELD(regval, <NAME>, 1);
- *    W_REG(osh, &regs->regfoo, regval);
- */
-#define BITFIELD_MASK(width) \
-		(((unsigned)1 << (width)) - 1)
-#define GFIELD(val, field) \
-		(((val) >> field ## _S) & field ## _M)
-#define SFIELD(val, field, bits) \
-		(((val) & (~(field ## _M << field ## _S))) | \
-		 ((unsigned)(bits) << field ## _S))
-
 /*
  * Priority definitions according 802.1D
  */
@@ -137,17 +46,12 @@ typedef struct {
 #define	PRIO_8021D_VI		5
 #define	PRIO_8021D_VO		6
 #define	PRIO_8021D_NC		7
+
 #define	MAXPRIO			7
 #define NUMPRIO			(MAXPRIO + 1)
 
-/* Max. nvram variable table size */
-#define	MAXSZ_NVRAM_VARS	4096
-
-/* handle forward declaration */
-struct wl_info;
-struct wlc_bsscfg;
-
 #define WL_NUMRATES		16	/* max # of rates in a rateset */
+
 typedef struct wl_rateset {
 	u32 count;		/* # rates in this set */
 	u8 rates[WL_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
@@ -187,16 +91,8 @@ typedef struct wl_rateset {
 #define WL_ERROR_VAL		0x00000001
 #define WL_TRACE_VAL		0x00000002
 
-#define	NFIFO			6	/* # tx/rx fifopairs */
-
 #define PM_OFF	0
 #define PM_MAX	1
 #define PM_FAST 2
 
-/* band range returned by band_range iovar */
-#define WL_CHAN_FREQ_RANGE_2G      0
-#define WL_CHAN_FREQ_RANGE_5GL     1
-#define WL_CHAN_FREQ_RANGE_5GM     2
-#define WL_CHAN_FREQ_RANGE_5GH     3
-
 #endif				/* _bcmdefs_h_ */
-- 
1.7.4.1


