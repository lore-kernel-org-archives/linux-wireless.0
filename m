Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:31577 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaLULoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 06:44:02 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 05/10] brcmfmac: remove unused/duplicate defines in chip.c
Date: Sun, 21 Dec 2014 12:43:48 +0100
Message-ID: <1419162233-19492-6-git-send-email-arend@broadcom.com> (sfid-20141221_124415_955791_EE1BF6CE)
In-Reply-To: <1419162233-19492-1-git-send-email-arend@broadcom.com>
References: <1419162233-19492-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The source file chip.c contained some duplicate defines and
some unused ones. Removing them.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index 0393d84..04d2ca0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -101,14 +101,7 @@
 /* ARM Cortex M3 core, ID 0x82a */
 #define BCM4329_CORE_ARM_BASE		0x18002000
 #define BCM4329_RAMSIZE			0x48000
-
 /* bcm43143 */
-/* SDIO device core */
-#define BCM43143_CORE_BUS_BASE		0x18002000
-/* internal memory core */
-#define BCM43143_CORE_SOCRAM_BASE	0x18004000
-/* ARM Cortex M3 core, ID 0x82a */
-#define BCM43143_CORE_ARM_BASE		0x18003000
 #define BCM43143_RAMSIZE		0x70000
 
 #define CORE_SB(base, field) \
@@ -164,13 +157,6 @@ struct brcmf_core_priv {
 	struct brcmf_chip_priv *chip;
 };
 
-/* ARM CR4 core specific control flag bits */
-#define ARMCR4_BCMA_IOCTL_CPUHALT	0x0020
-
-/* D11 core specific control flag bits */
-#define D11_BCMA_IOCTL_PHYCLOCKEN	0x0004
-#define D11_BCMA_IOCTL_PHYRESET		0x0008
-
 struct brcmf_chip_priv {
 	struct brcmf_chip pub;
 	const struct brcmf_buscore_ops *ops;
-- 
1.9.1

