Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2340 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 71/83] staging: brcm80211: further simplified register
 access macro's
Date: Wed, 1 Jun 2011 13:45:56 +0200
Message-ID: <1306928768-7501-71-git-send-email-rvossen@broadcom.com> (sfid-20110601_134911_530157_BE912033)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SELECT_BUS_READ and SELECT_BUS_WRITE macro's always select
a (sdio) bus operation for fullmac, and a memory operation for
softmac. Thus they can be removed by expanding them in place.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c  |  102 +++------------------
 drivers/staging/brcm80211/brcmsmac/wlc_types.h |  116 ++++++++++--------------
 2 files changed, 61 insertions(+), 157 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8da6589..2a93f3b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -38,102 +38,30 @@
 #endif
 #endif
 
-#if defined(BCMSDIO)
-#define SELECT_BUS_WRITE(mmap_op, bus_op) bus_op
-#define SELECT_BUS_READ(mmap_op, bus_op) bus_op
-#else
-#define SELECT_BUS_WRITE(mmap_op, bus_op) mmap_op
-#define SELECT_BUS_READ(mmap_op, bus_op) mmap_op
-#endif
-
 /* register access macros */
 #ifndef __BIG_ENDIAN
 #ifndef __mips__
-#define R_REG(r) (\
-	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
-	readb((volatile u8*)(r)) : \
-	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
-	readl((volatile u32*)(r)), bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
-)
+#define R_REG(r) \
+	bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))
 #else				/* __mips__ */
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
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __osl_v; \
+		__asm__ __volatile__("sync"); \
+		__osl_v = bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r)); \
+		__asm__ __volatile__("sync"); \
+		__osl_v; \
+	})
 #endif				/* __mips__ */
 
 #define W_REG(r, v) do { \
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
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v)); \
 	} while (0)
 #else				/* __BIG_ENDIAN */
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
+#define R_REG(r) \
+	bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))
 #define W_REG(r, v) do { \
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
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v); \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
@@ -154,8 +82,6 @@
 #define SET_REG(r, mask, val) \
 		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
 
-
-
 #ifdef DHD_DEBUG
 
 /* ARM trap handling */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 12c35bd..059dc17 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -48,56 +48,39 @@ do {						\
 #endif
 #endif
 
-#if defined(BCMSDIO)
-#define SELECT_BUS_WRITE(mmap_op, bus_op) bus_op
-#define SELECT_BUS_READ(mmap_op, bus_op) bus_op
-#else
-#define SELECT_BUS_WRITE(mmap_op, bus_op) mmap_op
-#define SELECT_BUS_READ(mmap_op, bus_op) mmap_op
-#endif
-
 /* register access macros */
 #ifndef __BIG_ENDIAN
 #ifndef __mips__
-#define R_REG(r) (\
-	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
-	readb((volatile u8*)(r)) : \
-	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
-	readl((volatile u32*)(r)), bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
-)
+#define R_REG(r) \
+	({\
+		sizeof(*(r)) == sizeof(u8) ? \
+		readb((volatile u8*)(r)) : \
+		sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
+		readl((volatile u32*)(r)); \
+	})
 #else				/* __mips__ */
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
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __osl_v; \
+		__asm__ __volatile__("sync"); \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			__osl_v = readb((volatile u8*)(r)); \
+			break; \
+		case sizeof(u16): \
+			__osl_v = readw((volatile u16*)(r)); \
+			break; \
+		case sizeof(u32): \
+			__osl_v = \
+			readl((volatile u32*)(r)); \
+			break; \
+		} \
+		__asm__ __volatile__("sync"); \
+		__osl_v; \
+	})
 #endif				/* __mips__ */
 
 #define W_REG(r, v) do { \
-	SELECT_BUS_WRITE( \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
 			writeb((u8)(v), (volatile u8*)(r)); break; \
@@ -105,33 +88,29 @@ do {						\
 			writew((u16)(v), (volatile u16*)(r)); break; \
 		case sizeof(u32): \
 			writel((u32)(v), (volatile u32*)(r)); break; \
-		}, \
-		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v))); \
+		}; \
 	} while (0)
 #else				/* __BIG_ENDIAN */
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
+#define R_REG(r) \
+	({ \
+		__typeof(*(r)) __osl_v; \
+		switch (sizeof(*(r))) { \
+		case sizeof(u8): \
+			__osl_v = \
+			readb((volatile u8*)((r)^3)); \
+			break; \
+		case sizeof(u16): \
+			__osl_v = \
+			readw((volatile u16*)((r)^2)); \
+			break; \
+		case sizeof(u32): \
+			__osl_v = readl((volatile u32*)(r)); \
+			break; \
+		} \
+		__osl_v; \
+	})
+
 #define W_REG(r, v) do { \
-	SELECT_BUS_WRITE( \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8):	\
 			writeb((u8)(v), \
@@ -142,8 +121,7 @@ do {						\
 		case sizeof(u32):	\
 			writel((u32)(v), \
 			(volatile u32*)(r)); break; \
-		}, \
-		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v)); \
+		} \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
-- 
1.7.4.1


