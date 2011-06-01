Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2343 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 70/83] staging: brcm80211: moved register read/write
 macro's
Date: Wed, 1 Jun 2011 13:45:55 +0200
Message-ID: <1306928768-7501-70-git-send-email-rvossen@broadcom.com> (sfid-20110601_134909_282965_B4985690)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. R_REG()/W_REG() macro's are overly complex. Copied
the macro's to both fullmac and softmac. Next patches will simplify
both copies of the macro's.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    1 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    1 +
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  126 ++++++++++++++++++++
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    1 +
 drivers/staging/brcm80211/brcmsmac/bcmotp.c        |    1 +
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |    1 +
 drivers/staging/brcm80211/brcmsmac/wlc_types.h     |  123 +++++++++++++++++++
 drivers/staging/brcm80211/include/brcmu_utils.h    |  123 -------------------
 10 files changed, 256 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index e7638f4..5812b5b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -28,6 +28,7 @@
 #include <bcmdefs.h>
 #include <bcmdevs.h>
 #include <brcmu_utils.h>
+#include <bcmsdh.h>
 #include <brcmu_wifi.h>
 
 #if defined(OOB_INTR_ONLY)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 8dadfb6..9abd620 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -20,6 +20,7 @@
 #include <bcmdevs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
+#include <bcmsdh.h>
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* ioctl/iovars */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index e1b2592..2da07e2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -20,6 +20,7 @@
 #include <bcmdefs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
+#include <bcmsdh.h>
 #include <bcmsdbus.h>		/* bcmsdh to/from specific controller APIs */
 #include <sdiovar.h>		/* to get msglevel bit values */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 0bff0ed..8da6589 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -30,6 +30,132 @@
 #include <bcmdevs.h>
 
 #include <bcmsoc.h>
+
+/* register access macros */
+#if defined(BCMSDIO)
+#ifdef BRCM_FULLMAC
+#include <bcmsdh.h>
+#endif
+#endif
+
+#if defined(BCMSDIO)
+#define SELECT_BUS_WRITE(mmap_op, bus_op) bus_op
+#define SELECT_BUS_READ(mmap_op, bus_op) bus_op
+#else
+#define SELECT_BUS_WRITE(mmap_op, bus_op) mmap_op
+#define SELECT_BUS_READ(mmap_op, bus_op) mmap_op
+#endif
+
+/* register access macros */
+#ifndef __BIG_ENDIAN
+#ifndef __mips__
+#define R_REG(r) (\
+	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
+	readb((volatile u8*)(r)) : \
+	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
+	readl((volatile u32*)(r)), bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
+)
+#else				/* __mips__ */
+#define R_REG(r) (\
+	SELECT_BUS_READ( \
+		({ \
+			__typeof(*(r)) __osl_v; \
+			__asm__ __volatile__("sync"); \
+			switch (sizeof(*(r))) { \
+			case sizeof(u8): \
+				__osl_v = readb((volatile u8*)(r)); \
+				break; \
+			case sizeof(u16): \
+				__osl_v = readw((volatile u16*)(r)); \
+				break; \
+			case sizeof(u32): \
+				__osl_v = \
+				readl((volatile u32*)(r)); \
+				break; \
+			} \
+			__asm__ __volatile__("sync"); \
+			__osl_v; \
+		}), \
+		({ \
+			__typeof(*(r)) __osl_v; \
+			__asm__ __volatile__("sync"); \
+			__osl_v = bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r)); \
+			__asm__ __volatile__("sync"); \
+			__osl_v; \
+		})) \
+)
+#endif				/* __mips__ */
+
+#define W_REG(r, v) do { \
+	SELECT_BUS_WRITE( \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			writeb((u8)(v), (volatile u8*)(r)); break; \
+		case sizeof(u16): \
+			writew((u16)(v), (volatile u16*)(r)); break; \
+		case sizeof(u32): \
+			writel((u32)(v), (volatile u32*)(r)); break; \
+		}, \
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v))); \
+	} while (0)
+#else				/* __BIG_ENDIAN */
+#define R_REG(r) (\
+	SELECT_BUS_READ( \
+		({ \
+			__typeof(*(r)) __osl_v; \
+			switch (sizeof(*(r))) { \
+			case sizeof(u8): \
+				__osl_v = \
+				readb((volatile u8*)((r)^3)); \
+				break; \
+			case sizeof(u16): \
+				__osl_v = \
+				readw((volatile u16*)((r)^2)); \
+				break; \
+			case sizeof(u32): \
+				__osl_v = readl((volatile u32*)(r)); \
+				break; \
+			} \
+			__osl_v; \
+		}), \
+		bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
+)
+#define W_REG(r, v) do { \
+	SELECT_BUS_WRITE( \
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
+		}, \
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v)); \
+	} while (0)
+#endif				/* __BIG_ENDIAN */
+
+#ifdef __mips__
+/*
+ * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
+ * transactions. As a fix, a read after write is performed on certain places
+ * in the code. Older chips and the newer 5357 family don't require this fix.
+ */
+#define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
+#else
+#define W_REG_FLUSH(r, v)	W_REG((r), (v))
+#endif				/* __mips__ */
+
+#define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
+#define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
+
+#define SET_REG(r, mask, val) \
+		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
+
+
+
 #ifdef DHD_DEBUG
 
 /* ARM trap handling */
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index bc1c52d..7a8bab7 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -18,6 +18,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <bcmdefs.h>
+#include "wlc_types.h"
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <brcmu_utils.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index 4a0deec..baed204 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -23,6 +23,7 @@
 
 #include <bcmdefs.h>
 #include <bcmdevs.h>
+#include "wlc_types.h"
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 6e61ca1..3ffad2e 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/pci.h>
 #include <bcmdefs.h>
+#include "wlc_types.h"
 #include <brcmu_utils.h>
 #include <aiutils.h>
 #include <bcmsoc.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index f10a137..720839b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -19,6 +19,7 @@
 #include <linux/io.h>
 
 #include <bcmdevs.h>
+#include "wlc_types.h"
 #include <chipcommon.h>
 #include <brcmu_utils.h>
 #include "wlc_scb.h"
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 3442d32..12c35bd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -41,6 +41,129 @@ do {						\
 
 #define WL_ERROR_ON()		(brcm_msg_level & LOG_ERROR_VAL)
 
+/* register access macros */
+#if defined(BCMSDIO)
+#ifdef BRCM_FULLMAC
+#include <bcmsdh.h>
+#endif
+#endif
+
+#if defined(BCMSDIO)
+#define SELECT_BUS_WRITE(mmap_op, bus_op) bus_op
+#define SELECT_BUS_READ(mmap_op, bus_op) bus_op
+#else
+#define SELECT_BUS_WRITE(mmap_op, bus_op) mmap_op
+#define SELECT_BUS_READ(mmap_op, bus_op) mmap_op
+#endif
+
+/* register access macros */
+#ifndef __BIG_ENDIAN
+#ifndef __mips__
+#define R_REG(r) (\
+	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
+	readb((volatile u8*)(r)) : \
+	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
+	readl((volatile u32*)(r)), bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
+)
+#else				/* __mips__ */
+#define R_REG(r) (\
+	SELECT_BUS_READ( \
+		({ \
+			__typeof(*(r)) __osl_v; \
+			__asm__ __volatile__("sync"); \
+			switch (sizeof(*(r))) { \
+			case sizeof(u8): \
+				__osl_v = readb((volatile u8*)(r)); \
+				break; \
+			case sizeof(u16): \
+				__osl_v = readw((volatile u16*)(r)); \
+				break; \
+			case sizeof(u32): \
+				__osl_v = \
+				readl((volatile u32*)(r)); \
+				break; \
+			} \
+			__asm__ __volatile__("sync"); \
+			__osl_v; \
+		}), \
+		({ \
+			__typeof(*(r)) __osl_v; \
+			__asm__ __volatile__("sync"); \
+			__osl_v = bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r)); \
+			__asm__ __volatile__("sync"); \
+			__osl_v; \
+		})) \
+)
+#endif				/* __mips__ */
+
+#define W_REG(r, v) do { \
+	SELECT_BUS_WRITE( \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			writeb((u8)(v), (volatile u8*)(r)); break; \
+		case sizeof(u16): \
+			writew((u16)(v), (volatile u16*)(r)); break; \
+		case sizeof(u32): \
+			writel((u32)(v), (volatile u32*)(r)); break; \
+		}, \
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v))); \
+	} while (0)
+#else				/* __BIG_ENDIAN */
+#define R_REG(r) (\
+	SELECT_BUS_READ( \
+		({ \
+			__typeof(*(r)) __osl_v; \
+			switch (sizeof(*(r))) { \
+			case sizeof(u8): \
+				__osl_v = \
+				readb((volatile u8*)((r)^3)); \
+				break; \
+			case sizeof(u16): \
+				__osl_v = \
+				readw((volatile u16*)((r)^2)); \
+				break; \
+			case sizeof(u32): \
+				__osl_v = readl((volatile u32*)(r)); \
+				break; \
+			} \
+			__osl_v; \
+		}), \
+		bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
+)
+#define W_REG(r, v) do { \
+	SELECT_BUS_WRITE( \
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
+		}, \
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v)); \
+	} while (0)
+#endif				/* __BIG_ENDIAN */
+
+#ifdef __mips__
+/*
+ * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
+ * transactions. As a fix, a read after write is performed on certain places
+ * in the code. Older chips and the newer 5357 family don't require this fix.
+ */
+#define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
+#else
+#define W_REG_FLUSH(r, v)	W_REG((r), (v))
+#endif				/* __mips__ */
+
+#define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
+#define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
+
+#define SET_REG(r, mask, val) \
+		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
+
 /* forward declarations */
 struct sk_buff;
 struct brcms_info;
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 260d0b6..94ae604 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -235,21 +235,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #define REG_MAP(pa, size)       (void *)(0)
 #endif
 
-/* register access macros */
-#if defined(BCMSDIO)
-#ifdef BRCM_FULLMAC
-#include <bcmsdh.h>
-#endif
-#endif
-
-#if defined(BCMSDIO)
-#define SELECT_BUS_WRITE(mmap_op, bus_op) bus_op
-#define SELECT_BUS_READ(mmap_op, bus_op) bus_op
-#else
-#define SELECT_BUS_WRITE(mmap_op, bus_op) mmap_op
-#define SELECT_BUS_READ(mmap_op, bus_op) mmap_op
-#endif
-
 /* the largest reasonable packet buffer driver uses for ethernet MTU in bytes */
 #define	PKTBUFSZ	2048
 
@@ -259,114 +244,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #include <linux/string.h>	/* for mem*, str* */
 #endif
 
-/* register access macros */
-#ifndef __BIG_ENDIAN
-#ifndef __mips__
-#define R_REG(r) (\
-	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
-	readb((volatile u8*)(r)) : \
-	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
-	readl((volatile u32*)(r)), bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
-)
-#else				/* __mips__ */
-#define R_REG(r) (\
-	SELECT_BUS_READ( \
-		({ \
-			__typeof(*(r)) __osl_v; \
-			__asm__ __volatile__("sync"); \
-			switch (sizeof(*(r))) { \
-			case sizeof(u8): \
-				__osl_v = readb((volatile u8*)(r)); \
-				break; \
-			case sizeof(u16): \
-				__osl_v = readw((volatile u16*)(r)); \
-				break; \
-			case sizeof(u32): \
-				__osl_v = \
-				readl((volatile u32*)(r)); \
-				break; \
-			} \
-			__asm__ __volatile__("sync"); \
-			__osl_v; \
-		}), \
-		({ \
-			__typeof(*(r)) __osl_v; \
-			__asm__ __volatile__("sync"); \
-			__osl_v = bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r)); \
-			__asm__ __volatile__("sync"); \
-			__osl_v; \
-		})) \
-)
-#endif				/* __mips__ */
-
-#define W_REG(r, v) do { \
-	SELECT_BUS_WRITE( \
-		switch (sizeof(*(r))) { \
-		case sizeof(u8): \
-			writeb((u8)(v), (volatile u8*)(r)); break; \
-		case sizeof(u16): \
-			writew((u16)(v), (volatile u16*)(r)); break; \
-		case sizeof(u32): \
-			writel((u32)(v), (volatile u32*)(r)); break; \
-		}, \
-		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v))); \
-	} while (0)
-#else				/* __BIG_ENDIAN */
-#define R_REG(r) (\
-	SELECT_BUS_READ( \
-		({ \
-			__typeof(*(r)) __osl_v; \
-			switch (sizeof(*(r))) { \
-			case sizeof(u8): \
-				__osl_v = \
-				readb((volatile u8*)((r)^3)); \
-				break; \
-			case sizeof(u16): \
-				__osl_v = \
-				readw((volatile u16*)((r)^2)); \
-				break; \
-			case sizeof(u32): \
-				__osl_v = readl((volatile u32*)(r)); \
-				break; \
-			} \
-			__osl_v; \
-		}), \
-		bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
-)
-#define W_REG(r, v) do { \
-	SELECT_BUS_WRITE( \
-		switch (sizeof(*(r))) { \
-		case sizeof(u8):	\
-			writeb((u8)(v), \
-			(volatile u8*)((r)^3)); break; \
-		case sizeof(u16):	\
-			writew((u16)(v), \
-			(volatile u16*)((r)^2)); break; \
-		case sizeof(u32):	\
-			writel((u32)(v), \
-			(volatile u32*)(r)); break; \
-		}, \
-		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v)); \
-	} while (0)
-#endif				/* __BIG_ENDIAN */
-
-#ifdef __mips__
-/*
- * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
- * transactions. As a fix, a read after write is performed on certain places
- * in the code. Older chips and the newer 5357 family don't require this fix.
- */
-#define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
-#else
-#define W_REG_FLUSH(r, v)	W_REG((r), (v))
-#endif				/* __mips__ */
-
-#define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
-#define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
-
-#define SET_REG(r, mask, val) \
-		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
-
 #ifndef setbit
 #ifndef NBBY			/* the BSD family defines NBBY */
 #define	NBBY	8		/* 8 bits per byte */
-- 
1.7.4.1


