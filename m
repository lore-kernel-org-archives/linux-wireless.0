Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4822 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758832Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 72/83] staging: brcm80211: cleanup after R_REG/W_REG
 patches
Date: Wed, 1 Jun 2011 13:45:57 +0200
Message-ID: <1306928768-7501-72-git-send-email-rvossen@broadcom.com> (sfid-20110601_134720_961564_FEF9AE99)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Removed unused sections. Added () to make macro safe.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   29 ++++------------------
 drivers/staging/brcm80211/brcmsmac/wlc_types.h  |    7 -----
 drivers/staging/brcm80211/include/brcmu_utils.h |    4 ---
 3 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 2a93f3b..397798a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -32,50 +32,33 @@
 #include <bcmsoc.h>
 
 /* register access macros */
-#if defined(BCMSDIO)
-#ifdef BRCM_FULLMAC
-#include <bcmsdh.h>
-#endif
-#endif
-
-/* register access macros */
 #ifndef __BIG_ENDIAN
 #ifndef __mips__
 #define R_REG(r) \
-	bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))
+	bcmsdh_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
 #else				/* __mips__ */
 #define R_REG(r) \
 	({ \
 		__typeof(*(r)) __osl_v; \
 		__asm__ __volatile__("sync"); \
-		__osl_v = bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r)); \
+		__osl_v = bcmsdh_reg_read(NULL, (unsigned long)(r),\
+					  sizeof(*(r))); \
 		__asm__ __volatile__("sync"); \
 		__osl_v; \
 	})
 #endif				/* __mips__ */
 
 #define W_REG(r, v) do { \
-		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), (v)); \
+		bcmsdh_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), (v)); \
 	} while (0)
 #else				/* __BIG_ENDIAN */
 #define R_REG(r) \
-	bcmsdh_reg_read(NULL, (unsigned long)r, sizeof(*r))
+	bcmsdh_reg_read(NULL, (unsigned long)(r), sizeof(*(r)))
 #define W_REG(r, v) do { \
-		bcmsdh_reg_write(NULL, (unsigned long)r, sizeof(*r), v); \
+		bcmsdh_reg_write(NULL, (unsigned long)(r), sizeof(*(r)), (v)); \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
 
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
 #define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
 #define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_types.h b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
index 059dc17..db296d4 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_types.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_types.h
@@ -42,13 +42,6 @@ do {						\
 #define WL_ERROR_ON()		(brcm_msg_level & LOG_ERROR_VAL)
 
 /* register access macros */
-#if defined(BCMSDIO)
-#ifdef BRCM_FULLMAC
-#include <bcmsdh.h>
-#endif
-#endif
-
-/* register access macros */
 #ifndef __BIG_ENDIAN
 #ifndef __mips__
 #define R_REG(r) \
diff --git a/drivers/staging/brcm80211/include/brcmu_utils.h b/drivers/staging/brcm80211/include/brcmu_utils.h
index 94ae604..e4007d4 100644
--- a/drivers/staging/brcm80211/include/brcmu_utils.h
+++ b/drivers/staging/brcm80211/include/brcmu_utils.h
@@ -239,10 +239,6 @@ extern int brcmu_iovar_lencheck(const struct brcmu_iovar *table, void *arg,
 #define	PKTBUFSZ	2048
 
 #define OSL_SYSUPTIME()		((u32)jiffies * (1000 / HZ))
-#ifdef BRCM_FULLMAC
-#include <linux/kernel.h>	/* for vsn/printf's */
-#include <linux/string.h>	/* for mem*, str* */
-#endif
 
 #ifndef setbit
 #ifndef NBBY			/* the BSD family defines NBBY */
-- 
1.7.4.1


