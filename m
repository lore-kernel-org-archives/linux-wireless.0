Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2659 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1LLXPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:52 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 06/15] brcm80211: smac: remove register access macro
 definitions
Date: Mon, 12 Dec 2011 15:15:04 -0800
Message-ID: <1323731713-14942-7-git-send-email-frankyl@broadcom.com> (sfid-20111213_001612_816145_F28DB855)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The register access macros like R_REG/W_REG/etc. are no longer
needed as the driver uses the BCMA provided functions.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/types.h |   51 -----------------------
 1 files changed, 0 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/types.h b/drivers/net/wireless/brcm80211/brcmsmac/types.h
index e64971a..e11ae83 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/types.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/types.h
@@ -250,69 +250,18 @@ do {						\
 		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
 } while (0)
 
-/*
- * Register access macros.
- *
- * These macro's take a pointer to the address to read as one of their
- * arguments. The macro itself deduces the size of the IO transaction (u8, u16
- * or u32). Advantage of this approach in combination with using a struct to
- * define the registers in a register block, is that access size and access
- * location are defined in only one spot. This reduces the risk of the
- * programmer trying to use an unsupported transaction size on a register.
- *
- */
-
-#define R_REG(r) \
-	({ \
-		__typeof(*(r)) __osl_v; \
-		switch (sizeof(*(r))) { \
-		case sizeof(u8): \
-			__osl_v = readb((u8 __iomem *)(r)); \
-			break; \
-		case sizeof(u16): \
-			__osl_v = readw((u16 __iomem *)(r)); \
-			break; \
-		case sizeof(u32): \
-			__osl_v = readl((u32 __iomem *)(r)); \
-			break; \
-		} \
-		__osl_v; \
-	})
-
-#define W_REG(r, v) do { \
-		switch (sizeof(*(r))) { \
-		case sizeof(u8):	\
-			writeb((u8)((v) & 0xFF), (u8 __iomem *)(r)); \
-			break; \
-		case sizeof(u16):	\
-			writew((u16)((v) & 0xFFFF), (u16 __iomem *)(r)); \
-			break; \
-		case sizeof(u32):	\
-			writel((u32)(v), (u32 __iomem *)(r)); \
-			break; \
-		} \
-	} while (0)
-
 #ifdef CONFIG_BCM47XX
 /*
  * bcm4716 (which includes 4717 & 4718), plus 4706 on PCIe can reorder
  * transactions. As a fix, a read after write is performed on certain places
  * in the code. Older chips and the newer 5357 family don't require this fix.
  */
-#define W_REG_FLUSH(r, v)	({ W_REG((r), (v)); (void)R_REG(r); })
 #define bcma_wflush16(c, o, v) \
 	({ bcma_write16(c, o, v); (void)bcma_read16(c, o); })
 #else
-#define W_REG_FLUSH(r, v)	W_REG((r), (v))
 #define bcma_wflush16(c, o, v)	bcma_write16(c, o, v)
 #endif				/* CONFIG_BCM47XX */
 
-#define AND_REG(r, v)	W_REG((r), R_REG(r) & (v))
-#define OR_REG(r, v)	W_REG((r), R_REG(r) | (v))
-
-#define SET_REG(r, mask, val) \
-		W_REG((r), ((R_REG(r) & ~(mask)) | (val)))
-
 /* multi-bool data type: set of bools, mbool is true if any is set */
 
 /* set one bool */
-- 
1.7.5.4


