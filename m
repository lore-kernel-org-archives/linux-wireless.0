Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3678 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab1KDVYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:02 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/16] brcm80211: fmac: move core disable function to
 sdio_chip.c
Date: Fri, 4 Nov 2011 22:23:31 +0100
Message-ID: <1320441822-4615-6-git-send-email-arend@broadcom.com> (sfid-20111104_222415_240650_F47AB38F)
In-Reply-To: <1320441822-4615-1-git-send-email-arend@broadcom.com>
References: <1320441822-4615-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

This patch is part of the abstracting chip backplane handle code
series.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |  117 +-------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   80 +++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |   28 +++++
 3 files changed, 111 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 9a78cc3..af0d5c9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -309,38 +309,6 @@ struct rte_console {
 /* Flags for SDH calls */
 #define F2SYNC	(SDIO_REQ_4BYTE | SDIO_REQ_FIXED)
 
-/* sbimstate */
-#define	SBIM_IBE		0x20000	/* inbanderror */
-#define	SBIM_TO			0x40000	/* timeout */
-#define	SBIM_BY			0x01800000	/* busy (sonics >= 2.3) */
-#define	SBIM_RJ			0x02000000	/* reject (sonics >= 2.3) */
-
-/* sbtmstatelow */
-
-/* reset */
-#define	SBTML_RESET		0x0001
-/* reject field */
-#define	SBTML_REJ_MASK		0x0006
-/* reject */
-#define	SBTML_REJ		0x0002
-/* temporary reject, for error recovery */
-#define	SBTML_TMPREJ		0x0004
-
-/* Shift to locate the SI control flags in sbtml */
-#define	SBTML_SICF_SHIFT	16
-
-/* sbtmstatehigh */
-#define	SBTMH_SERR		0x0001	/* serror */
-#define	SBTMH_INT		0x0002	/* interrupt */
-#define	SBTMH_BUSY		0x0004	/* busy */
-#define	SBTMH_TO		0x0020	/* timeout (sonics >= 2.3) */
-
-/* Shift to locate the SI status flags in sbtmh */
-#define	SBTMH_SISF_SHIFT	16
-
-/* sbidlow */
-#define	SBIDL_INIT		0x80	/* initiator */
-
 /*
  * Conversion of 802.1D priority to precedence level
  */
@@ -3123,85 +3091,6 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 }
 
 static void
-brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
-{
-	u32 regdata;
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(corebase, sbtmstatelow), 4);
-	if (regdata & SBTML_RESET)
-		return;
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-		CORE_SB(corebase, sbtmstatelow), 4);
-	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
-		/*
-		 * set target reject and spin until busy is clear
-		 * (preserve core-specific bits)
-		 */
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
-				       4, regdata | SBTML_REJ);
-
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		udelay(1);
-		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatehigh), 4) &
-			SBTMH_BUSY), 100000);
-
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatehigh), 4);
-		if (regdata & SBTMH_BUSY)
-			brcmf_dbg(ERROR, "ARM core still busy\n");
-
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidlow), 4);
-		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) |
-				SBIM_RJ;
-			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(corebase, sbimstate), 4,
-				regdata);
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4);
-			udelay(1);
-			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) &
-				SBIM_BY), 100000);
-		}
-
-		/* set reset and reject while enabling the clocks */
-		brcmf_sdcard_reg_write(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4,
-			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
-			SBTML_REJ | SBTML_RESET));
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbtmstatelow), 4);
-		udelay(10);
-
-		/* clear the initiator reject bit */
-		regdata = brcmf_sdcard_reg_read(sdiodev,
-			CORE_SB(corebase, sbidlow), 4);
-		if (regdata & SBIDL_INIT) {
-			regdata = brcmf_sdcard_reg_read(sdiodev,
-				CORE_SB(corebase, sbimstate), 4) &
-				~SBIM_RJ;
-			brcmf_sdcard_reg_write(sdiodev,
-				CORE_SB(corebase, sbimstate), 4,
-				regdata);
-		}
-	}
-
-	/* leave reset and reject asserted */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SBTML_REJ | SBTML_RESET));
-	udelay(1);
-}
-
-static void
 brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 {
 	u32 regdata;
@@ -3210,7 +3099,7 @@ brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 	 * Must do the disable sequence first to work for
 	 * arbitrary current core state.
 	 */
-	brcmf_sdbrcm_chip_disablecore(sdiodev, corebase);
+	brcmf_sdio_chip_coredisable(sdiodev, corebase);
 
 	/*
 	 * Now do the initialization sequence.
@@ -3258,7 +3147,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 	if (enter) {
 		bus->alp_only = true;
 
-		brcmf_sdbrcm_chip_disablecore(bus->sdiodev,
+		brcmf_sdio_chip_coredisable(bus->sdiodev,
 					      bus->ci->armcorebase);
 
 		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
@@ -4000,7 +3889,7 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 	 * Make sure any on-chip ARM is off (in case strapping is wrong),
 	 * or downloaded code was already running.
 	 */
-	brcmf_sdbrcm_chip_disablecore(bus->sdiodev, ci->armcorebase);
+	brcmf_sdio_chip_coredisable(bus->sdiodev, ci->armcorebase);
 
 	brcmf_sdcard_reg_write(bus->sdiodev,
 		CORE_CC_REG(ci->cccorebase, gpiopullup), 4, 0);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 1e01ae2..f198a48 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -22,6 +22,7 @@
 #include <brcm_hw_ids.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
+#include <soc.h>
 #include "dhd.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
@@ -51,6 +52,85 @@
 #define	SBIDH_VC_MASK		0xffff0000	/* vendor code */
 #define	SBIDH_VC_SHIFT		16
 
+void
+brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
+{
+	u32 regdata;
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_SB(corebase, sbtmstatelow), 4);
+	if (regdata & SBTML_RESET)
+		return;
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+		CORE_SB(corebase, sbtmstatelow), 4);
+	if ((regdata & (SICF_CLOCK_EN << SBTML_SICF_SHIFT)) != 0) {
+		/*
+		 * set target reject and spin until busy is clear
+		 * (preserve core-specific bits)
+		 */
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow),
+				       4, regdata | SBTML_REJ);
+
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		udelay(1);
+		SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatehigh), 4) &
+			SBTMH_BUSY), 100000);
+
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatehigh), 4);
+		if (regdata & SBTMH_BUSY)
+			brcmf_dbg(ERROR, "core state still busy\n");
+
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbidlow), 4);
+		if (regdata & SBIDL_INIT) {
+			regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4) |
+				SBIM_RJ;
+			brcmf_sdcard_reg_write(sdiodev,
+				CORE_SB(corebase, sbimstate), 4,
+				regdata);
+			regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4);
+			udelay(1);
+			SPINWAIT((brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4) &
+				SBIM_BY), 100000);
+		}
+
+		/* set reset and reject while enabling the clocks */
+		brcmf_sdcard_reg_write(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4,
+			(((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
+			SBTML_REJ | SBTML_RESET));
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbtmstatelow), 4);
+		udelay(10);
+
+		/* clear the initiator reject bit */
+		regdata = brcmf_sdcard_reg_read(sdiodev,
+			CORE_SB(corebase, sbidlow), 4);
+		if (regdata & SBIDL_INIT) {
+			regdata = brcmf_sdcard_reg_read(sdiodev,
+				CORE_SB(corebase, sbimstate), 4) &
+				~SBIM_RJ;
+			brcmf_sdcard_reg_write(sdiodev,
+				CORE_SB(corebase, sbimstate), 4,
+				regdata);
+		}
+	}
+
+	/* leave reset and reject asserted */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		(SBTML_REJ | SBTML_RESET));
+	udelay(1);
+}
+
 static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 				       struct chip_info *ci, u32 regs)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 1985e36..17007bd 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -52,6 +52,31 @@
 #define SBSDIO_CLKAV(regval, alponly) \
 	(SBSDIO_ALPAV(regval) && (alponly ? 1 : SBSDIO_HTAV(regval)))
 
+/* sbimstate */
+#define	SBIM_IBE		0x20000	/* inbanderror */
+#define	SBIM_TO			0x40000	/* timeout */
+#define	SBIM_BY			0x01800000	/* busy (sonics >= 2.3) */
+#define	SBIM_RJ			0x02000000	/* reject (sonics >= 2.3) */
+
+/* sbtmstatelow */
+#define	SBTML_RESET		0x0001	/* reset */
+#define	SBTML_REJ_MASK		0x0006	/* reject field */
+#define	SBTML_REJ		0x0002	/* reject */
+#define	SBTML_TMPREJ		0x0004	/* temporary reject(error recovery) */
+/* Shift to locate the SI control flags in sbtml */
+#define	SBTML_SICF_SHIFT	16
+
+/* sbtmstatehigh */
+#define	SBTMH_SERR		0x0001	/* serror */
+#define	SBTMH_INT		0x0002	/* interrupt */
+#define	SBTMH_BUSY		0x0004	/* busy */
+#define	SBTMH_TO		0x0020	/* timeout (sonics >= 2.3) */
+/* Shift to locate the SI status flags in sbtmh */
+#define	SBTMH_SISF_SHIFT	16
+
+/* sbidlow */
+#define	SBIDL_INIT		0x80	/* initiator */
+
 struct chip_info {
 	u32 chip;
 	u32 chiprev;
@@ -108,6 +133,9 @@ struct sbconfig {
 	u32 sbidhigh;	/* identification */
 };
 
+
+extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
+					u32 corebase);
 extern int brcmf_sdio_chip_attach(struct brcmf_sdio_dev *sdiodev,
 				  struct chip_info *ci, u32 regs);
 
-- 
1.7.4.1


