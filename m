Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3750 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/19] brcm80211: fmac: remove PCMCIA core related code
Date: Thu, 10 Nov 2011 20:30:33 +0100
Message-ID: <1320953434-16859-20-git-send-email-arend@broadcom.com> (sfid-20111110_203134_530616_B438E079)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

all the devices supported or will be supported by brcmfmac
do not have a PCMCIA bus core. So remove the corresponding code.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index a7fc542..6a3d484 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -691,14 +691,6 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 			return -EBADE;
 		}
 
-		if (pendok && ((bus->ci->c_inf[1].id == PCMCIA_CORE_ID)
-			       && (bus->ci->c_inf[1].rev == 9))) {
-			u32 dummy, retries;
-			r_sdreg32(bus, &dummy,
-				  offsetof(struct sdpcmd_regs, clockctlstatus),
-				  &retries);
-		}
-
 		/* Check current status */
 		clkctl = brcmf_sdcard_cfg_read(bus->sdiodev, SDIO_FUNC_1,
 					       SBSDIO_FUNC1_CHIPCLKCSR, &err);
@@ -915,13 +907,6 @@ static int brcmf_sdbrcm_bussleep(struct brcmf_bus *bus, bool sleep)
 		brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
 			SBSDIO_FUNC1_CHIPCLKCSR, 0, NULL);
 
-		/* Force pad isolation off if possible
-			 (in case power never toggled) */
-		if ((bus->ci->c_inf[1].id == PCMCIA_CORE_ID)
-		    && (bus->ci->c_inf[1].rev >= 10))
-			brcmf_sdcard_cfg_write(bus->sdiodev, SDIO_FUNC_1,
-				SBSDIO_DEVICE_CTL, 0, NULL);
-
 		/* Make sure the controller has the bus up */
 		brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
 
-- 
1.7.5.4


