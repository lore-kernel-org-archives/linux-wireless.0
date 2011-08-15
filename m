Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3555 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1HONem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 09:34:42 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/15] staging: brcm80211: Remove swaps in R_REG and
 W_REG macros
Date: Mon, 15 Aug 2011 15:34:22 +0200
Message-ID: <1313415267-5264-11-git-send-email-arend@broadcom.com> (sfid-20110815_153501_693263_CFE8EB98)
In-Reply-To: <1313415267-5264-1-git-send-email-arend@broadcom.com>
References: <1313415267-5264-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Swapping the addresses is unnecessary, since the swaps are handled by the
underlying platform code (i.e. readb() etc. handle any necessary swapping).

Tested on Mac G5 PPC and BCM63281.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Tested-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/types.h |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index c0d41cc..ad874a7 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -329,28 +329,17 @@ do {						\
  * location are defined in only one spot. This reduces the risk of the
  * programmer trying to use an unsupported transaction size on a register.
  *
- * For big endian operation, a byte swap has to be done. Eg, when attempting
- * to read byte address 0, byte 3 should be read. This is accomplished
- * using an xor ('^') operator.
  */
 
-#ifndef __BIG_ENDIAN
-#define SWP2(r)	(r)
-#define SWP3(r) (r)
-#else
-#define SWP2(r)	((unsigned long)(r)^2)
-#define SWP3(r)	((unsigned long)(r)^3)
-#endif /* __BIG_ENDIAN */
-
 #define R_REG(r) \
 	({ \
 		__typeof(*(r)) __osl_v; \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
-			__osl_v = readb((u8 *)(SWP3(r))); \
+			__osl_v = readb((u8 *)(r)); \
 			break; \
 		case sizeof(u16): \
-			__osl_v = readw((u16 *)(SWP2(r))); \
+			__osl_v = readw((u16 *)(r)); \
 			break; \
 		case sizeof(u32): \
 			__osl_v = readl((u32 *)(r)); \
@@ -362,10 +351,10 @@ do {						\
 #define W_REG(r, v) do { \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8):	\
-			writeb((u8)(v), (u8 *)(SWP3(r))); \
+			writeb((u8)(v), (u8 *)(r)); \
 			break; \
 		case sizeof(u16):	\
-			writew((u16)(v), (u16 *)(SWP2(r))); \
+			writew((u16)(v), (u16 *)(r)); \
 			break; \
 		case sizeof(u32):	\
 			writel((u32)(v), (u32 *)(r)); \
-- 
1.7.4.1


