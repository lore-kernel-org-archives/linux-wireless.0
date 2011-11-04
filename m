Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2036 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1KDVX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:23:59 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/16] brcm80211: fmac: replace private SB macros with
 ssb_regs version
Date: Fri, 4 Nov 2011 22:23:41 +0100
Message-ID: <1320441822-4615-16-git-send-email-arend@broadcom.com> (sfid-20111104_222408_935797_FE2B4403)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Use SSB macros in order to clean up brcmfmac code

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   66 ++++++++-----------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   25 --------
 2 files changed, 28 insertions(+), 63 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index e068107..62c4621 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -18,6 +18,8 @@
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/mmc/card.h>
+#include <linux/ssb/ssb_regs.h>
+
 #include <chipcommon.h>
 #include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
@@ -38,19 +40,9 @@
 #define BCM4329_CORE_ARM_BASE		0x18002000
 #define BCM4329_RAMSIZE			0x48000
 
-
-/* SB regs */
-/* sbidhigh */
-#define	SBIDH_RC_MASK		0x000f	/* revision code */
-#define	SBIDH_RCE_MASK		0x7000	/* revision code extension field */
-#define	SBIDH_RCE_SHIFT		8
 #define	SBCOREREV(sbidh) \
-	((((sbidh) & SBIDH_RCE_MASK) >> SBIDH_RCE_SHIFT) | \
-	  ((sbidh) & SBIDH_RC_MASK))
-#define	SBIDH_CC_MASK		0x8ff0	/* core code */
-#define	SBIDH_CC_SHIFT		4
-#define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
-#define	SBIDH_VC_SHIFT		16
+	((((sbidh) & SSB_IDHIGH_RCHI) >> SSB_IDHIGH_RCHI_SHIFT) | \
+	  ((sbidh) & SSB_IDHIGH_RCLO))
 
 #define SDIOD_DRVSTR_KEY(chip, pmu)     (((chip) << 16) | (pmu))
 /* SDIO Pad drive strength to select value mappings */
@@ -109,9 +101,9 @@ brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
-	regdata &= (SBTML_RESET | SBTML_REJ_MASK |
-			(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-	return ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) == regdata);
+	regdata &= (SSB_TMSLOW_RESET | SSB_TMSLOW_REJECT |
+		    SSB_IMSTATE_REJECT | SSB_TMSLOW_CLOCK);
+	return (SSB_TMSLOW_CLOCK == regdata);
 }
 
 void
@@ -121,12 +113,12 @@ brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 		CORE_SB(corebase, sbtmstatelow), 4);
-	if (regdata & SBTML_RESET)
+	if (regdata & SSB_TMSLOW_RESET)
 		return;
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 		CORE_SB(corebase, sbtmstatelow), 4);
-	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
+	if ((regdata & SSB_TMSLOW_CLOCK) != 0) {
 		/*
 		 * set target reject and spin until busy is clear
 		 * (preserve core-specific bits)
@@ -134,26 +126,26 @@ brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
-				       4, regdata | SBTML_REJ);
+				       4, regdata | SSB_TMSLOW_REJECT);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(1);
 		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatehigh), 4) &
-			SBTMH_BUSY), 100000);
+			SSB_TMSHIGH_BUSY), 100000);
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatehigh), 4);
-		if (regdata & SBTMH_BUSY)
+		if (regdata & SSB_TMSHIGH_BUSY)
 			brcmf_dbg(ERROR, "core state still busy\n");
 
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbidlow), 4);
-		if (regdata & SBIDL_INIT) {
+		if (regdata & SSB_IDLOW_INITIATOR) {
 			regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4) |
-				SBIM_RJ;
+				SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
@@ -162,14 +154,14 @@ brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 			udelay(1);
 			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4) &
-				SBIM_BY), 100000);
+				SSB_IMSTATE_BUSY), 100000);
 		}
 
 		/* set reset and reject while enabling the clocks */
 		brcmf_sdcard_reg_write(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4,
-			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
-			SBTML_REJ | SBTML_RESET));
+			(SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK |
+			SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbtmstatelow), 4);
 		udelay(10);
@@ -177,10 +169,10 @@ brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 		/* clear the initiator reject bit */
 		regdata = brcmf_sdcard_reg_read(sdiodev,
 			CORE_SB(corebase, sbidlow), 4);
-		if (regdata & SBIDL_INIT) {
+		if (regdata & SSB_IDLOW_INITIATOR) {
 			regdata = brcmf_sdcard_reg_read(sdiodev,
 				CORE_SB(corebase, sbimstate), 4) &
-				~SBIM_RJ;
+				~SSB_IMSTATE_REJECT;
 			brcmf_sdcard_reg_write(sdiodev,
 				CORE_SB(corebase, sbimstate), 4,
 				regdata);
@@ -189,7 +181,7 @@ brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 
 	/* leave reset and reject asserted */
 	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SBTML_REJ | SBTML_RESET));
+		(SSB_TMSLOW_REJECT | SSB_TMSLOW_RESET));
 	udelay(1);
 }
 
@@ -210,31 +202,29 @@ brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 	 * forcing them on throughout the core
 	 */
 	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
-		SBTML_RESET);
+		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK | SSB_TMSLOW_RESET);
 	udelay(1);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					CORE_SB(corebase, sbtmstatehigh), 4);
-	if (regdata & SBTMH_SERR)
+	if (regdata & SSB_TMSHIGH_SERR)
 		brcmf_sdcard_reg_write(sdiodev,
 				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
 
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					CORE_SB(corebase, sbimstate), 4);
-	if (regdata & (SBIM_IBE | SBIM_TO))
+	if (regdata & (SSB_IMSTATE_IBE | SSB_IMSTATE_TO))
 		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
-			regdata & ~(SBIM_IBE | SBIM_TO));
+			regdata & ~(SSB_IMSTATE_IBE | SSB_IMSTATE_TO));
 
 	/* clear reset and allow it to propagate throughout the core */
 	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SICF_FGC << SBTML_SICF_SHIFT) |
-		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+		SSB_TMSLOW_FGC | SSB_TMSLOW_CLOCK);
 	udelay(1);
 
 	/* leave clock enabled */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
+			       4, SSB_TMSLOW_CLOCK);
 	udelay(1);
 }
 
@@ -345,7 +335,7 @@ brcmf_sdio_chip_buscoresetup(struct brcmf_sdio_dev *sdiodev,
 	ci->buscorerev = brcmf_sdio_chip_corerev(sdiodev, ci->buscorebase);
 	regdata = brcmf_sdcard_reg_read(sdiodev,
 					CORE_SB(ci->buscorebase, sbidhigh), 4);
-	ci->buscoretype = (regdata & SBIDH_CC_MASK) >> SBIDH_CC_SHIFT;
+	ci->buscoretype = (regdata & SSB_IDHIGH_CC) >> SSB_IDHIGH_CC_SHIFT;
 
 	brcmf_dbg(INFO, "ccrev=%d, pmurev=%d, buscore rev/type=%d/0x%x\n",
 		  ci->ccrev, ci->pmurev, ci->buscorerev, ci->buscoretype);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index e816bb6..6383746 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -52,31 +52,6 @@
 #define SBSDIO_CLKAV(regval, alponly) \
 	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
 
-/* sbimstate */
-#define	SBIM_IBE		0x20000	/* inbanderror */
-#define	SBIM_TO			0x40000	/* timeout */
-#define	SBIM_BY			0x01800000	/* busy (sonics >= 2.3) */
-#define	SBIM_RJ			0x02000000	/* reject (sonics >= 2.3) */
-
-/* sbtmstatelow */
-#define	SBTML_RESET		0x0001	/* reset */
-#define	SBTML_REJ_MASK		0x0006	/* reject field */
-#define	SBTML_REJ		0x0002	/* reject */
-#define	SBTML_TMPREJ		0x0004	/* temporary reject(error recovery) */
-/* Shift to locate the SI control flags in sbtml */
-#define	SBTML_SICF_SHIFT	16
-
-/* sbtmstatehigh */
-#define	SBTMH_SERR		0x0001	/* serror */
-#define	SBTMH_INT		0x0002	/* interrupt */
-#define	SBTMH_BUSY		0x0004	/* busy */
-#define	SBTMH_TO		0x0020	/* timeout (sonics >= 2.3) */
-/* Shift to locate the SI status flags in sbtmh */
-#define	SBTMH_SISF_SHIFT	16
-
-/* sbidlow */
-#define	SBIDL_INIT		0x80	/* initiator */
-
 struct chip_info {
 	u32 chip;
 	u32 chiprev;
-- 
1.7.4.1


