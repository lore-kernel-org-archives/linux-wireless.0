Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3879 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758852Ab1FALqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:35 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 69/83] staging: brcm80211: removed OSL_WRITE_REG and
 OSL_READ_REG macros
Date: Wed, 1 Jun 2011 13:45:54 +0200
Message-ID: <1306928768-7501-69-git-send-email-rvossen@broadcom.com> (sfid-20110601_134747_500299_1D04BD89)
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
 drivers/staging/brcm80211/include/brcmu_utils.h |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 73854a4..260d0b6 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -240,10 +240,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #ifdef BRCM_FULLMAC
 #include <bcmsdh.h>
 #endif
-#define OSL_WRITE_REG(r, v) \
-		(bcmsdh_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), (v)))
-#define OSL_READ_REG(r) \
-		(bcmsdh_reg_read(NULL, (unsigned long)(r), sizeof(*(r))))
 #endif
 
 #if defined(BCMSDIO)
@@ -270,7 +266,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 	SELECT_BUS_READ(sizeof(*(r)) == sizeof(u8) ? \
 	readb((volatile u8*)(r)) : \
 	sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
-	readl((volatile u32*)(r)), OSL_READ_REG(r)) \
+	readl((volatile u32*)(r)), bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
 )
 #else				/* __mips__ */
 #define R_REG(r) (\
@@ -296,7 +292,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 		({ \
 			__typeof(*(r)) __osl_v; \
 			__asm__ __volatile__("sync"); \
-			__osl_v = OSL_READ_REG(r); \
+			__osl_v = bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r)); \
 			__asm__ __volatile__("sync"); \
 			__osl_v; \
 		})) \
@@ -313,7 +309,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 		case sizeof(u32): \
 			writel((u32)(v), (volatile u32*)(r)); break; \
 		}, \
-		(OSL_WRITE_REG(r, v))); \
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v))); \
 	} while (0)
 #else				/* __BIG_ENDIAN */
 #define R_REG(r) (\
@@ -335,7 +331,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 			} \
 			__osl_v; \
 		}), \
-		OSL_READ_REG(r)) \
+		bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))) \
 )
 #define W_REG(r, v) do { \
 	SELECT_BUS_WRITE( \
@@ -350,7 +346,7 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 			writel((u32)(v), \
 			(volatile u32*)(r)); break; \
 		}, \
-		(OSL_WRITE_REG(r, v))); \
+		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v)); \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
-- 
1.7.4.1


