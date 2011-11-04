Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2036 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab1KDVYE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 17:24:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/16] brcm80211: fmac: move chip reset core function to
 sdio_chip.c
Date: Fri, 4 Nov 2011 22:23:38 +0100
Message-ID: <1320441822-4615-13-git-send-email-arend@broadcom.com> (sfid-20111104_222434_893208_CB72A3A9)
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
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   49 +-------------------
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.c    |   45 ++++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/sdio_chip.h    |    2 +
 3 files changed, 49 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 84b10f1..af6f3a4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -3090,51 +3090,6 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 	return bcmerror;
 }
 
-static void
-brcmf_sdbrcm_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
-{
-	u32 regdata;
-
-	/*
-	 * Must do the disable sequence first to work for
-	 * arbitrary current core state.
-	 */
-	brcmf_sdio_chip_coredisable(sdiodev, corebase);
-
-	/*
-	 * Now do the initialization sequence.
-	 * set reset while enabling the clock and
-	 * forcing them on throughout the core
-	 */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
-		SBTML_RESET);
-	udelay(1);
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(corebase, sbtmstatehigh), 4);
-	if (regdata & SBTMH_SERR)
-		brcmf_sdcard_reg_write(sdiodev,
-				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
-
-	regdata = brcmf_sdcard_reg_read(sdiodev,
-					CORE_SB(corebase, sbimstate), 4);
-	if (regdata & (SBIM_IBE | SBIM_TO))
-		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
-			regdata & ~(SBIM_IBE | SBIM_TO));
-
-	/* clear reset and allow it to propagate throughout the core */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SICF_FGC << SBTML_SICF_SHIFT) |
-		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-	udelay(1);
-
-	/* leave clock enabled */
-	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
-		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
-	udelay(1);
-}
-
 static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 {
 	uint retries;
@@ -3149,7 +3104,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		brcmf_sdio_chip_coredisable(bus->sdiodev,
 					      bus->ci->armcorebase);
 
-		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
+		brcmf_sdio_chip_resetcore(bus->sdiodev, bus->ci->ramcorebase);
 
 		/* Clear the top bit of memory */
 		if (bus->ramsize) {
@@ -3174,7 +3129,7 @@ static int brcmf_sdbrcm_download_state(struct brcmf_bus *bus, bool enter)
 		w_sdreg32(bus, 0xFFFFFFFF,
 			  offsetof(struct sdpcmd_regs, intstatus), &retries);
 
-		brcmf_sdbrcm_chip_resetcore(bus->sdiodev, bus->ci->armcorebase);
+		brcmf_sdio_chip_resetcore(bus->sdiodev, bus->ci->armcorebase);
 
 		/* Allow HT Clock now that the ARM is running. */
 		bus->alp_only = false;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
index 5d788a6..4acdda1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c
@@ -155,6 +155,51 @@ brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev, u32 corebase)
 	udelay(1);
 }
 
+void
+brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev, u32 corebase)
+{
+	u32 regdata;
+
+	/*
+	 * Must do the disable sequence first to work for
+	 * arbitrary current core state.
+	 */
+	brcmf_sdio_chip_coredisable(sdiodev, corebase);
+
+	/*
+	 * Now do the initialization sequence.
+	 * set reset while enabling the clock and
+	 * forcing them on throughout the core
+	 */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		((SICF_FGC | SICF_CLOCK_EN) << SBTML_SICF_SHIFT) |
+		SBTML_RESET);
+	udelay(1);
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(corebase, sbtmstatehigh), 4);
+	if (regdata & SBTMH_SERR)
+		brcmf_sdcard_reg_write(sdiodev,
+				       CORE_SB(corebase, sbtmstatehigh), 4, 0);
+
+	regdata = brcmf_sdcard_reg_read(sdiodev,
+					CORE_SB(corebase, sbimstate), 4);
+	if (regdata & (SBIM_IBE | SBIM_TO))
+		brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbimstate), 4,
+			regdata & ~(SBIM_IBE | SBIM_TO));
+
+	/* clear reset and allow it to propagate throughout the core */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		(SICF_FGC << SBTML_SICF_SHIFT) |
+		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	udelay(1);
+
+	/* leave clock enabled */
+	brcmf_sdcard_reg_write(sdiodev, CORE_SB(corebase, sbtmstatelow), 4,
+		(SICF_CLOCK_EN << SBTML_SICF_SHIFT));
+	udelay(1);
+}
+
 static int brcmf_sdio_chip_recognition(struct brcmf_sdio_dev *sdiodev,
 				       struct chip_info *ci, u32 regs)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
index 9c43e1d..6ad5ea6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.h
@@ -133,6 +133,8 @@ struct sbconfig {
 	u32 sbidhigh;	/* identification */
 };
 
+extern void brcmf_sdio_chip_resetcore(struct brcmf_sdio_dev *sdiodev,
+				      u32 corebase);
 extern bool brcmf_sdio_chip_iscoreup(struct brcmf_sdio_dev *sdiodev,
 				     u32 corebase);
 extern void brcmf_sdio_chip_coredisable(struct brcmf_sdio_dev *sdiodev,
-- 
1.7.4.1


