Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4452 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab1F2Xsi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:38 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 001/119] staging: brcm80211: fix checkpatch errors in
 types.h
Date: Wed, 29 Jun 2011 16:46:25 -0700
Message-ID: <1309391303-22741-2-git-send-email-frankyl@broadcom.com> (sfid-20110630_014852_227149_247F4F1C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The file types.h contains several occurrences of the checkpatch
error "(foo*)" should be "(foo *)". This has been fixed in this
patch.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/types.h |   30 ++++++++++++++--------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 163973d..af1514e 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -257,9 +257,9 @@ do {						\
 #define R_REG(r) \
 	({\
 		sizeof(*(r)) == sizeof(u8) ? \
-		readb((volatile u8*)(r)) : \
-		sizeof(*(r)) == sizeof(u16) ? readw((volatile u16*)(r)) : \
-		readl((volatile u32*)(r)); \
+		readb((u8 *)(r)) : \
+		sizeof(*(r)) == sizeof(u16) ? readw((u16 *)(r)) : \
+		readl((u32 *)(r)); \
 	})
 #else				/* __mips__ */
 #define R_REG(r) \
@@ -268,14 +268,14 @@ do {						\
 		__asm__ __volatile__("sync"); \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
-			__osl_v = readb((volatile u8*)(r)); \
+			__osl_v = readb((u8 *)(r)); \
 			break; \
 		case sizeof(u16): \
-			__osl_v = readw((volatile u16*)(r)); \
+			__osl_v = readw((u16 *)(r)); \
 			break; \
 		case sizeof(u32): \
 			__osl_v = \
-			readl((volatile u32*)(r)); \
+			readl((u32 *)(r)); \
 			break; \
 		} \
 		__asm__ __volatile__("sync"); \
@@ -286,11 +286,11 @@ do {						\
 #define W_REG(r, v) do { \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
-			writeb((u8)(v), (volatile u8*)(r)); break; \
+			writeb((u8)(v), (u8 *)(r)); break; \
 		case sizeof(u16): \
-			writew((u16)(v), (volatile u16*)(r)); break; \
+			writew((u16)(v), (u16 *)(r)); break; \
 		case sizeof(u32): \
-			writel((u32)(v), (volatile u32*)(r)); break; \
+			writel((u32)(v), (u32 *)(r)); break; \
 		}; \
 	} while (0)
 #else				/* __BIG_ENDIAN */
@@ -300,14 +300,14 @@ do {						\
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
 			__osl_v = \
-			readb((volatile u8*)((r)^3)); \
+			readb((u8 *)((r)^3)); \
 			break; \
 		case sizeof(u16): \
 			__osl_v = \
-			readw((volatile u16*)((r)^2)); \
+			readw((u16 *)((r)^2)); \
 			break; \
 		case sizeof(u32): \
-			__osl_v = readl((volatile u32*)(r)); \
+			__osl_v = readl((u32 *)(r)); \
 			break; \
 		} \
 		__osl_v; \
@@ -317,13 +317,13 @@ do {						\
 		switch (sizeof(*(r))) { \
 		case sizeof(u8):	\
 			writeb((u8)(v), \
-			(volatile u8*)((r)^3)); break; \
+			(u8 *)((r)^3)); break; \
 		case sizeof(u16):	\
 			writew((u16)(v), \
-			(volatile u16*)((r)^2)); break; \
+			(u16 *)((r)^2)); break; \
 		case sizeof(u32):	\
 			writel((u32)(v), \
-			(volatile u32*)(r)); break; \
+			(u32 *)(r)); break; \
 		} \
 	} while (0)
 #endif				/* __BIG_ENDIAN */
-- 
1.7.1


