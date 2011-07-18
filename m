Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4218 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643Ab1GROaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:23 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/19] staging: brcm80211: fixed build issue for big
 endian platforms
Date: Mon, 18 Jul 2011 16:29:50 +0200
Message-ID: <1310999405-10062-5-git-send-email-arend@broadcom.com> (sfid-20110718_163051_218818_0CE2876A)
In-Reply-To: <1310999405-10062-1-git-send-email-arend@broadcom.com>
References: <1310999405-10062-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Driver now builds for big endian mips platform, possibly also for other
big endian platforms. A change was made to the R_REG and W_REG macro's.
These macro's perform an xor (^) operation for endianess swap purposes.
Gcc complained because an xor operation is not allowed on a pointer type.
Fixed this by casting the pointer to an unsigned long.

Cc: linux-wireless@vger.kernel.org
Cc: devel@linuxdriverproject.org
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/dma.h   |    1 +
 drivers/staging/brcm80211/brcmsmac/types.h |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index 3ff109f..334f2eb 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -17,6 +17,7 @@
 #ifndef	_BRCM_DMA_H_
 #define	_BRCM_DMA_H_
 
+#include <linux/delay.h>
 #include "types.h"		/* forward structure declarations */
 
 /* DMA structure:
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 6275160..55db3cd 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -304,11 +304,11 @@ do {						\
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
 			__osl_v = \
-			readb((u8 *)((r)^3)); \
+			readb((u8 *)((unsigned long)(r)^3)); \
 			break; \
 		case sizeof(u16): \
 			__osl_v = \
-			readw((u16 *)((r)^2)); \
+			readw((u16 *)((unsigned long)(r)^2)); \
 			break; \
 		case sizeof(u32): \
 			__osl_v = readl((u32 *)(r)); \
@@ -321,10 +321,10 @@ do {						\
 		switch (sizeof(*(r))) { \
 		case sizeof(u8):	\
 			writeb((u8)(v), \
-			(u8 *)((r)^3)); break; \
+			(u8 *)((unsigned long)(r)^3)); break; \
 		case sizeof(u16):	\
 			writew((u16)(v), \
-			(u16 *)((r)^2)); break; \
+			(u16 *)((unsigned long)(r)^2)); break; \
 		case sizeof(u32):	\
 			writel((u32)(v), \
 			(u32 *)(r)); break; \
-- 
1.7.4.1


