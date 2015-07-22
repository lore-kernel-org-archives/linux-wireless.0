Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36601 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbbGVSRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 14:17:05 -0400
Received: by wicgb10 with SMTP id gb10so109848190wic.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2015 11:17:03 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 02/15] staging: vt6655: remove unused DBG_PORT80 and VIAWET_DEBUG
Date: Wed, 22 Jul 2015 19:16:34 +0100
Message-Id: <1437589007-5479-2-git-send-email-tvboxspy@gmail.com> (sfid-20150722_201710_683469_340BC5A3)
In-Reply-To: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
References: <1437589007-5479-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

VIAWET_DEBUG is never defined so DBG_PORT80 is empty and never used.

Remove both macros.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/baseband.c   |  2 --
 drivers/staging/vt6655/device_cfg.h |  6 ------
 drivers/staging/vt6655/mac.c        | 17 -----------------
 3 files changed, 25 deletions(-)

diff --git a/drivers/staging/vt6655/baseband.c b/drivers/staging/vt6655/baseband.c
index befaa42..9e61f2d 100644
--- a/drivers/staging/vt6655/baseband.c
+++ b/drivers/staging/vt6655/baseband.c
@@ -1943,7 +1943,6 @@ bool BBbReadEmbedded(struct vnt_private *priv,
 	VNSvInPortB(dwIoBase + MAC_REG_BBREGDATA, pbyData);
 
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x30);
 		pr_debug(" DBG_PORT80(0x30)\n");
 		return false;
 	}
@@ -1986,7 +1985,6 @@ bool BBbWriteEmbedded(struct vnt_private *priv,
 	}
 
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x31);
 		pr_debug(" DBG_PORT80(0x31)\n");
 		return false;
 	}
diff --git a/drivers/staging/vt6655/device_cfg.h b/drivers/staging/vt6655/device_cfg.h
index c7f21716..b4c9547 100644
--- a/drivers/staging/vt6655/device_cfg.h
+++ b/drivers/staging/vt6655/device_cfg.h
@@ -69,10 +69,4 @@ typedef enum  _chip_type {
 	VT3253 = 1
 } CHIP_TYPE, *PCHIP_TYPE;
 
-#ifdef VIAWET_DEBUG
-#define DBG_PORT80(value)                   outb(value, 0x80)
-#else
-#define DBG_PORT80(value)
-#endif
-
 #endif
diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 65dd49c..3dfd333 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -373,7 +373,6 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x10);
 		pr_debug(" DBG_PORT80(0x10)\n");
 		return false;
 	}
@@ -383,7 +382,6 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x11);
 		pr_debug(" DBG_PORT80(0x11)\n");
 		return false;
 	}
@@ -397,7 +395,6 @@ bool MACbSafeRxOff(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x12);
 		pr_debug(" DBG_PORT80(0x12)\n");
 		return false;
 	}
@@ -435,7 +432,6 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x20);
 		pr_debug(" DBG_PORT80(0x20)\n");
 		return false;
 	}
@@ -445,7 +441,6 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x21);
 		pr_debug(" DBG_PORT80(0x21)\n");
 		return false;
 	}
@@ -460,7 +455,6 @@ bool MACbSafeTxOff(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x24);
 		pr_debug(" DBG_PORT80(0x24)\n");
 		return false;
 	}
@@ -485,13 +479,11 @@ bool MACbSafeStop(void __iomem *dwIoBase)
 	MACvRegBitsOff(dwIoBase, MAC_REG_TCR, TCR_AUTOBCNTX);
 
 	if (!MACbSafeRxOff(dwIoBase)) {
-		DBG_PORT80(0xA1);
 		pr_debug(" MACbSafeRxOff == false)\n");
 		MACbSafeSoftwareReset(dwIoBase);
 		return false;
 	}
 	if (!MACbSafeTxOff(dwIoBase)) {
-		DBG_PORT80(0xA2);
 		pr_debug(" MACbSafeTxOff == false)\n");
 		MACbSafeSoftwareReset(dwIoBase);
 		return false;
@@ -589,9 +581,6 @@ void MACvSetCurrRx0DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr
 			break;
 	}
 
-	if (ww == W_MAX_TIMEOUT)
-		DBG_PORT80(0x13);
-
 	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR0, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
 		VNSvOutPortB(dwIoBase + MAC_REG_RXDMACTL0, DMACTL_RUN);
@@ -626,8 +615,6 @@ void MACvSetCurrRx1DescAddr(void __iomem *dwIoBase, unsigned long dwCurrDescAddr
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
-	if (ww == W_MAX_TIMEOUT)
-		DBG_PORT80(0x14);
 
 	VNSvOutPortD(dwIoBase + MAC_REG_RXDMAPTR1, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
@@ -665,8 +652,6 @@ void MACvSetCurrTx0DescAddrEx(void __iomem *dwIoBase,
 		if (!(byData & DMACTL_RUN))
 			break;
 	}
-	if (ww == W_MAX_TIMEOUT)
-		DBG_PORT80(0x25);
 
 	VNSvOutPortD(dwIoBase + MAC_REG_TXDMAPTR0, dwCurrDescAddr);
 	if (byOrgDMACtl & DMACTL_RUN)
@@ -705,7 +690,6 @@ void MACvSetCurrAC0DescAddrEx(void __iomem *dwIoBase,
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x26);
 		pr_debug(" DBG_PORT80(0x26)\n");
 	}
 	VNSvOutPortD(dwIoBase + MAC_REG_AC0DMAPTR, dwCurrDescAddr);
@@ -806,7 +790,6 @@ bool MACbPSWakeup(void __iomem *dwIoBase)
 			break;
 	}
 	if (ww == W_MAX_TIMEOUT) {
-		DBG_PORT80(0x36);
 		pr_debug(" DBG_PORT80(0x33)\n");
 		return false;
 	}
-- 
2.1.4

