Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1184 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 21/30] staging: brcm80211: reduce sparse messages on
 brcmsmac sources
Date: Thu, 1 Sep 2011 11:17:11 +0200
Message-ID: <1314868640-9425-22-git-send-email-rvossen@broadcom.com> (sfid-20110901_111838_943104_72791B0F)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Running sparse over the driver sources showed 1356 sparse messages
and quite a number are due to missing __iomem attribute in some
places. This patch reduces the number significantly.

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/types.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 6d17d7f..cf65f6e 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -328,13 +328,13 @@ do {						\
 		__typeof(*(r)) __osl_v; \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8): \
-			__osl_v = readb((u8 *)(r)); \
+			__osl_v = readb((u8 __iomem *)(r)); \
 			break; \
 		case sizeof(u16): \
-			__osl_v = readw((u16 *)(r)); \
+			__osl_v = readw((u16 __iomem *)(r)); \
 			break; \
 		case sizeof(u32): \
-			__osl_v = readl((u32 *)(r)); \
+			__osl_v = readl((u32 __iomem *)(r)); \
 			break; \
 		} \
 		__osl_v; \
@@ -343,13 +343,13 @@ do {						\
 #define W_REG(r, v) do { \
 		switch (sizeof(*(r))) { \
 		case sizeof(u8):	\
-			writeb((u8)(v), (u8 *)(r)); \
+			writeb((u8)((v) & 0xFF), (u8 __iomem *)(r)); \
 			break; \
 		case sizeof(u16):	\
-			writew((u16)(v), (u16 *)(r)); \
+			writew((u16)((v) & 0xFFFF), (u16 __iomem *)(r)); \
 			break; \
 		case sizeof(u32):	\
-			writel((u32)(v), (u32 *)(r)); \
+			writel((u32)(v), (u32 __iomem *)(r)); \
 			break; \
 		} \
 	} while (0)
-- 
1.7.4.1


