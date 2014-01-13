Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:62369 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaAMVUl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 16:20:41 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/8] bcma: add agent IOCTL bit values for Broadcom 802.11 and CR4 cores
Date: Mon, 13 Jan 2014 22:20:24 +0100
Message-ID: <1389648029-23560-4-git-send-email-arend@broadcom.com> (sfid-20140113_222051_265191_0CB273CB)
In-Reply-To: <1389648029-23560-1-git-send-email-arend@broadcom.com>
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The IOCTL register in the agent/wrapper contains additional bits
that are core specific and use in the core reset sequence.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   22 +++++++-------------
 include/linux/bcma/bcma_regs.h                     |    5 ++++-
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 4342976..a002af9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -66,13 +66,6 @@
 #define CIB_REV_MASK		0xff000000
 #define CIB_REV_SHIFT		24
 
-/* ARM CR4 core specific control flag bits */
-#define ARMCR4_BCMA_IOCTL_CPUHALT	0x0020
-
-/* D11 core specific control flag bits */
-#define D11_BCMA_IOCTL_PHYCLOCKEN	0x0004
-#define D11_BCMA_IOCTL_PHYRESET		0x0008
-
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 /* SDIO Pad drive strength to select value mappings */
 struct sdiod_drive_str {
@@ -873,8 +866,8 @@ brcmf_sdio_chip_cm3_enterdl(struct brcmf_sdio_dev *sdiodev,
 {
 	ci->coredisable(sdiodev, ci, BCMA_CORE_ARM_CM3, 0, 0);
 	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
-		      D11_BCMA_IOCTL_PHYRESET | D11_BCMA_IOCTL_PHYCLOCKEN,
-		      D11_BCMA_IOCTL_PHYCLOCKEN, D11_BCMA_IOCTL_PHYCLOCKEN);
+		      BCMA_IOCTL_80211_PHYCLOCKEN | BCMA_IOCTL_80211_PHYRESET,
+		      BCMA_IOCTL_80211_PHYCLOCKEN, BCMA_IOCTL_80211_PHYCLOCKEN);
 	ci->resetcore(sdiodev, ci, BCMA_CORE_INTERNAL_MEM, 0, 0, 0);
 }
 
@@ -913,13 +906,14 @@ brcmf_sdio_chip_cr4_enterdl(struct brcmf_sdio_dev *sdiodev,
 		return;
 
 	wrapbase = ci->c_inf[idx].wrapbase;
+	/* clear all IOCTL bits except HALT bit */
 	regdata = brcmf_sdiod_regrl(sdiodev, wrapbase + BCMA_IOCTL, NULL);
-	regdata &= ARMCR4_BCMA_IOCTL_CPUHALT;
+	regdata &= BCMA_IOCTL_ARMCR4_HALT;
 	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, regdata,
-		      ARMCR4_BCMA_IOCTL_CPUHALT, ARMCR4_BCMA_IOCTL_CPUHALT);
+		      BCMA_IOCTL_ARMCR4_HALT, BCMA_IOCTL_ARMCR4_HALT);
 	ci->resetcore(sdiodev, ci, BCMA_CORE_80211,
-		      D11_BCMA_IOCTL_PHYRESET | D11_BCMA_IOCTL_PHYCLOCKEN,
-		      D11_BCMA_IOCTL_PHYCLOCKEN, D11_BCMA_IOCTL_PHYCLOCKEN);
+		      BCMA_IOCTL_80211_PHYCLOCKEN | BCMA_IOCTL_80211_PHYRESET,
+		      BCMA_IOCTL_80211_PHYCLOCKEN, BCMA_IOCTL_80211_PHYCLOCKEN);
 }
 
 static bool
@@ -939,7 +933,7 @@ brcmf_sdio_chip_cr4_exitdl(struct brcmf_sdio_dev *sdiodev, struct chip_info *ci)
 			  sizeof(ci->rst_vec));
 
 	/* restore ARM */
-	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, ARMCR4_BCMA_IOCTL_CPUHALT,
+	ci->resetcore(sdiodev, ci, BCMA_CORE_ARM_CR4, BCMA_IOCTL_ARMCR4_HALT,
 		      0, 0);
 
 	return true;
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 917dcd7..7f0edf2 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -22,10 +22,13 @@
 #define  BCMA_CLKCTLST_4328A0_HAVEHT	0x00010000 /* 4328a0 has reversed bits */
 #define  BCMA_CLKCTLST_4328A0_HAVEALP	0x00020000 /* 4328a0 has reversed bits */
 
-/* Agent registers (common for every core) */
+/* Agent registers (common unless indicated) */
 #define BCMA_IOCTL			0x0408 /* IO control */
 #define  BCMA_IOCTL_CLK			0x0001
 #define  BCMA_IOCTL_FGC			0x0002
+#define  BCMA_IOCTL_80211_PHYCLOCKEN	0x0004 /* for 80211 core */
+#define  BCMA_IOCTL_80211_PHYRESET	0x0008 /* for 80211 core */
+#define  BCMA_IOCTL_ARMCR4_HALT		0x0020 /* for ARM CR4 core */
 #define  BCMA_IOCTL_CORE_BITS		0x3FFC
 #define  BCMA_IOCTL_PME_EN		0x4000
 #define  BCMA_IOCTL_BIST_EN		0x8000
-- 
1.7.10.4

